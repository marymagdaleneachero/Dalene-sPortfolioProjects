/*
Cleaning data in SQL queries
*/
Select*
From PortfolioProject.dbo.NashvilleHousing

--Standardize Date Format
Select saleDateconverted, CONVERT(Date, saleDate)
From PortfolioProject.dbo.NashvilleHousing 

update NashvilleHousing
set saleDate = CONVERT(Date, saleDate)


ALTER table NashvilleHousing
Add saleDateConverted Date

Update NashvilleHousing
set saleDateConverted = convert(date,saleDate)

--Populate property address data
Select*
From PortfolioProject.dbo.NashvilleHousing
--where propertyaddress is null
order by parcelID



Select a.parcelID, a.propertyaddress,b.parcelID,b.propertyaddress, ISNULL(a.propertyaddress,b.propertyaddress)
From PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
ON a.parcelID = b.parcelID
AND a.UniqueID <> b.UniqueID
where a.propertyaddress is null

update a
set propertyaddress = ISNULL(a.propertyaddress,b.propertyaddress)
From PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
ON a.parcelID = b.parcelID
AND a.UniqueID <> b.UniqueID
where a.propertyaddress is null

--Breaking out Address into individual columns(Address, city,state)
select propertyaddress
from PortfolioProject.dbo.NashvilleHousing
--where propertyaddress is null
--order by parcelID

select
substring(propertyaddress,1, CHARINDEX(',',Propertyaddress)-1) as Address,
substring(propertyaddress, CHARINDEX(',',Propertyaddress)+1, LEN(propertyaddress)) as Address
FROM PortfolioProject.dbo.NashvilleHousing



ALTER table NashvilleHousing
Add PropertySplitAddress nvarchar(255)

Update NashvilleHousing
set PropertySplitAddress = substring(propertyaddress,1, CHARINDEX(',',Propertyaddress)-1)


ALTER table NashvilleHousing
Add PropertySplitCity nvarchar(255)

Update NashvilleHousing
set PropertySplitCity = substring(propertyaddress, CHARINDEX(',',Propertyaddress)+1, LEN(propertyaddress))

select*
from PortfolioProject.dbo.NashvilleHousing


select ownerAddress
from PortfolioProject.dbo.NashvilleHousing

select
PARSENAME(REPLACE(ownerAddress, ',' , '.'),3),
PARSENAME(REPLACE(ownerAddress, ',', '.'),2),
PARSENAME(REPLACE(ownerAddress, ',', '.'),1)
from PortfolioProject.dbo.NashvilleHousing

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

Select *
From PortfolioProject.dbo.NashvilleHousing




--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field


Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From PortfolioProject.dbo.NashvilleHousing
Group by SoldAsVacant
order by 2

Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From PortfolioProject.dbo.NashvilleHousing

Update NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END

--Delete unused columns
Select *
From PortfolioProject.dbo.NashvilleHousing

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate






