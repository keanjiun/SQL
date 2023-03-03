

--Cleaning Data

Select *
From NashVilleHousing

--Standardized Data Format

Select SaleDate, CONVERT(Date,SaleDate)
From NashVilleHousing

Update NashVilleHousing
Set SaleDate = Convert(Date,SaleDate)

Alter Table NashVilleHousing
Add SaleDateConverted Date

Update NashVilleHousing
Set SaleDateConverted = Convert(Date,SaleDate)

--Populate Property Address

Select *
From NashVilleHousing
Where PropertyAddress is Null
Order By ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.propertyaddress,b.PropertyAddress)
From NashVilleHousing a
Join NashVilleHousing b 
	On a.ParcelID = b.ParcelID And a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is Null

Update a
Set PropertyAddress = ISNULL(a.propertyaddress,b.PropertyAddress)
From NashVilleHousing a
Join NashVilleHousing b 
	On a.ParcelID = b.ParcelID And a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is Null

--Breaking out Address into individual column (address, city, state)

Select PropertyAddress
From NashVilleHousing

Select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1) As Address,
SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress)) As Address
From NashVilleHousing

Alter Table NashVilleHousing
Add PropertySplitAddress nvarchar(255)

Update NashVilleHousing
Set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1)

Alter Table NashVilleHousing
Add PropertySplitCity nvarchar(255)

Update NashVilleHousing
Set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress))


Select OwnerAddress
From NashVilleHousing

Select
PARSENAME(Replace(OwnerAddress,',','.'),3),
PARSENAME(Replace(OwnerAddress,',','.'),2),
PARSENAME(Replace(OwnerAddress,',','.'),1)
From NashVilleHousing

Alter Table NashVilleHousing
Add OwnerSplitAddress nvarchar(255)

Update NashVilleHousing
Set OwnerSplitAddress = PARSENAME(Replace(OwnerAddress,',','.'),3)

Alter Table NashVilleHousing
Add OwnerSplitCity nvarchar(255)

Update NashVilleHousing
Set OwnerSplitCity = PARSENAME(Replace(OwnerAddress,',','.'),2)

Alter Table NashVilleHousing
Add OwnerSplitState nvarchar(255)

Update NashVilleHousing
Set OwnerSplitState = PARSENAME(Replace(OwnerAddress,',','.'),1)

Select *
From NashVilleHousing

--Change Y to Yes and No to "Sold as Vacant"

Select Distinct(SoldAsVacant), COUNT(SoldAsVacant)
From NashVilleHousing
Group By SoldAsVacant
Order By 2

Select SoldAsVacant,
	Case When SoldAsVacant = 'Y' Then 'Yes'
	When SoldAsVacant = 'N' Then 'No'
	Else SoldAsVacant
	End
From NashVilleHousing

Update NashVilleHousing
Set SoldAsVacant =	Case When SoldAsVacant = 'Y' Then 'Yes'
	When SoldAsVacant = 'N' Then 'No'
	Else SoldAsVacant
	End

--Remove Duplicate
With RowNumCTE as(
Select *,
Row_Number() Over (
	Partition By ParcelID,
	PropertyAddress,
	SalePrice,
	SaleDate,
	LegalReference
	Order  By UniqueID) row_num
From NashVilleHousing
)

Select *
From RowNumCTE
Where row_num > 1

--Delete Unused Columns

Alter Table NashVilleHousing
Drop Column OwnerAddress, TaxDistrict, PropertyAddress

Select *
From NashVilleHousing

Alter Table NashVilleHousing
Drop Column SaleDate