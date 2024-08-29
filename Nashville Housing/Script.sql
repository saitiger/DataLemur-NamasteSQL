/*Data Cleaning Nashville Housing Dataset */

-- Extracting date from datetime column 

Update NashvilleHousing
SET SaleDate = DATE("Date",SaleDate)

-- If directly updating doesn't work we add a column first and then use date to extract date 
-- from datetime field.

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
SET SaleDateConverted = DATE("Date",SaleDate)


-- To change the formatting of the date we can use to_char and specify the formatting as a -- string as the second argument.

select "Date",to_char("Date","dd:mm:yyyy") as tochar_date from NashvilleHousing;


-- Populating address data

Select *
From NashvilleHousing
Where PropertyAddress is null

-- Lot of rows with property address are missing are present.

Select *
From NashvilleHousing
order by ParcelID

-- Rows with same parcelid have missing values so we impute the missing column value if the 
-- value exists for the parcel with same parcelid 

-- Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL-- (a.PropertyAddress,b.PropertyAddress)
-- From NashvilleHousing a
-- JOIN NashvilleHousing b
-- 	on a.ParcelID = b.ParcelID
-- 	AND a.[UniqueID ] <> b.[UniqueID ]
-- Where a.PropertyAddress is null

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From NashvilleHousing a
JOIN NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

-- Breaking out Address into Individual Columns (Address, City, State)

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address From NashvilleHousing

ALTER TABLE NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )

ALTER TABLE NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))

Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From NashvilleHousing

ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)

ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)

ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)

-- Changing Y and N to their full form notation in the "Sold as Vacant" field

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From NashvilleHousing
Group by SoldAsVacant
order by 2

Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From NashvilleHousing

Update NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END

-- Deduping

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From NashvilleHousing
order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress

-- Removing Unused Columns

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate

Data Exploration 

-- Average house price vs number of bedrooms,bathrooms

Select Bedrooms, FullBath, AVG(TotalValue) as avg_house_price
From NashvilleHousing
Group by 1,2
Order by 3 Desc

-- Average house price vs number of half bathrooms
Select HalfBaths, AVG(TotalValue) as avg_house_price
From NashvilleHousing 
Group by 1 Order by 2 Desc

Select Bedrooms, FullBath, AVG(TotalValue) as avg_house_price
From NashvilleHousing
Group by 1,2
Order by 3 Desc

-- Sales Monthly and Yearly breakdown

SELECT extract(month from SaleDateConverted) as mth, COUNT(*) as num_houses_sold
FROM NashvilleHousing
GROUP BY 1
ORDER BY 2 DESC;

SELECT extract(year from SaleDateConverted) as yr,COUNT(*) as num_houses_sold
FROM NashvilleHousing
GROUP BY 1
ORDER BY 2 DESC;

--Land Type (Single,Residential Condo,Duplex etc.) vs Average Price 

SELECT LandUse, AVG(TotalValue) as avg_price
FROM NashvilleHousing
GROUP BY 1
ORDER BY 2 DESC

-- Average Price based on if the property was sold as a vacant plot or not.
SELECT SoldAsVacant, AVG(TotalValue) as avg_price 
FROM NashvilleHousing
GROUP BY 1
ORDER BY 2 DESC

-- Average Price by state,city

SELECT OwnerSplitState,OwnerSplitCity,AVG(TotalValue) as avg_price 
FROM NashvilleHousing
GROUP BY 1,2
ORDER BY 3 DESC

SELECT OwnerSplitState,OwnerSplitCity,max(TotalValue) over(partition by OwnerSplitState) as max_price_breakdown 
FROM NashvilleHousing
GROUP BY 1
ORDER BY 3 DESC
