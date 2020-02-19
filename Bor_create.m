function ck7=Bor_create(ck7,portion,dk2,colorb,kid)

for F=1:3
ck7(portion(kid,1):portion(kid,1)+dk2(kid)-1,portion(kid,3):portion(kid,4),F)=colorb(F);
ck7(portion(kid,2)-dk2(kid)+1:portion(kid,2),portion(kid,3):portion(kid,4),F)=colorb(F);
ck7(portion(kid,1):portion(kid,2),portion(kid,3):portion(kid,3)+dk2(kid)-1,F)=colorb(F);
ck7(portion(kid,1):portion(kid,2),portion(kid,4)-dk2(kid)+1:portion(kid,4),F)=colorb(F);
end