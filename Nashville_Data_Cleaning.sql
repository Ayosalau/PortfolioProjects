-- CLEANING Nashville_Housing_Data 

-- Confirm date structure
SELECT date{SaleDate)
FROM Nashville_Housing_Data

-- Populate PropertyAddress, DATA
-- Fill PropertyAddress NULL spaces with address from UniqueID of the ParcelID
SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ifnull(a.PropertyAddress, b.PropertyAddress)
FROM Nashville_Housing_Data a
Join Nashville_Housing_Data b
ON a.ParcelID = b.ParcelID
AND a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress is NULL

UPDATE Nashville_Housing_Data
SET PropertyAddress = ifnull(a.PropertyAddress, b.PropertyAddress)
FROM Nashville_Housing_Data a
Join Nashville_Housing_Data b
ON a.ParcelID = b.ParcelID
AND a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress is NULL

-- Breaking Out Property Address Into Individual Columns (Address, City, State)
-- USING a substring
SELECT 
substr(PropertyAddress, 1, 20) Address, 
substr(PropertyAddress, 22, 9) City
FROM Nashville_Housing_Data

ALTER TABLE Nashville_Housing_Data
ADD PropAddress 

UPDATE Nashville_Housing_Data
SET PropAddress = substr(PropertyAddress, 1, 20)

ALTER TABLE Nashville_Housing_Data
ADD PropCity

UPDATE Nashville_Housing_Data
SET PropCity = substr(PropertyAddress, 22, 9)

SELECT *
FROM Nashville_Housing_Data

-- Breaking Out Onwer's Address Into Individual Columns (Address, City, State)
-- USING substr and instr
SELECT  substr(OwnerAddress, 1, instr(OwnerAddress, ' -')) Owner_house_no, 
substr(OwnerAddress, 22, instr(OwnerAddress, ' -')) Owner_City, 
substr(OwnerAddress, 39, instr(OwnerAddress, ' -')) Owner_State

FROM Nashville_Housing_Data

ALTER TABLE Nashville_Housing_Data
ADD  Owner_house_no

UPDATE Nashville_Housing_Data
SET Owner_house_no = substr(OwnerAddress, 1, instr(OwnerAddress, ' -'))

ALTER TABLE Nashville_Housing_Data
ADD Owner_City

UPDATE Nashville_Housing_Data
SET Owner_City = substr(OwnerAddress, 22, instr(OwnerAddress, ' -'))

ALTER TABLE Nashville_Housing_Data
ADD Owner_State

UPDATE Nashville_Housing_Data
SET Owner_State = substr(OwnerAddress, 39, instr(OwnerAddress, ' -'))

-- Change Y and N to YES and NO in sold and vacant field
-- USING CASE STATEMENTS
SELECT SoldAsVacant,
CASE When SoldAsVacant = 'Y' THEN 'Yes' 
		When SoldAsVacant = 'N' THEN 'No'
		When SoldAsVacant = 'YES' THEN 'Yes' 
		When SoldAsVacant = 'NO' THEN 'No'
			ELSE SoldAsVacant
			END 
FROM Nashville_Housing_Data

UPDATE Nashville_Housing_Data
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes' 
		When SoldAsVacant = 'N' THEN 'No'
		When SoldAsVacant = 'YES' THEN 'Yes' 
		When SoldAsVacant = 'NO' THEN 'No'
			ELSE SoldAsVacant
			END 
			
-- Removing Duplicates using CTE and windows functions
WITH row_num as (
Select *,
row_number() OVER(
PARTITION BY ParcelID, 
				PropertyAddress, 
				SalePrice, 
				SaleDate, 
				LegalReference
ORDER BY UniqueID) row_no

From Nashville_Housing_Data
ORDER BY ParcelID
)
DELETE From row_num
where row_no > 1
--ORDER  BY PropertyAddress

-- Deleting unused data
ALTER TABLE Nashville_Housing_Data
DROP COLUMN SaleDate, PropertyAddress, OwnerAddress, TaxDistrict
