

// Chooses which Mercenaries appear on the map
// rmAddMerc("proto unit", count, min, max, increment)
	
void chooseMercs(void)
{
/*	if(rmIsMapType("water"))
	{
		if (rmRandFloat(0,1) < 0.5)
			rmAddMerc("Galleon", 1, 0, 2, 1);
	} */
//maximum = 4500 resources Inc = 200

	// HOLY ROMAN EMPIRE
	if (rmRandFloat(0,1) < 0.33)
	{
		rmAddMerc("MercJaeger", 0, 0, 12, 0.9);
		if (rmRandFloat(0,1) < 0.5)
		   rmAddMerc("MercBlackRider", 0, 0, 12, 0.3);
		if (rmRandFloat(0,1) < 0.5)
	     rmAddMerc("MercLandsknecht", 0, 0, 12, 0.6);
	}
	else if (rmRandFloat(0,1) < 0.5)
	{
		   rmAddMerc("MercBlackRider", 0, 0, 12, 0.3);
		if (rmRandFloat(0,1) < 0.5)
			rmAddMerc("MercJaeger", 0, 0, 12, 0.9);
		if (rmRandFloat(0,1) < 0.5)
	     rmAddMerc("MercLandsknecht", 0, 0, 12, 0.6);
	}
   else
   {
	   rmAddMerc("MercLandsknecht", 0, 0, 12, 0.6);
		if (rmRandFloat(0,1) < 0.5)
		   rmAddMerc("MercBlackRider", 0, 0, 12, 0.3);
		if (rmRandFloat(0,1) < 0.5)
			rmAddMerc("MercJaeger", 0, 0, 12, 0.9);
	}

	// HIGHLAND
	if (rmRandFloat(0,1) < 0.33)
	{
      rmAddMerc("MercHighlander", 0, 0, 0, 0);
		if (rmRandFloat(0,1) < 0.5)
	     rmAddMerc("MercHackapell", 0, 0, 0, 0);
		if (rmRandFloat(0,1) < 0.5)
			rmAddMerc("MercSwissPikeman", 0, 0, 0, 0);
	}
	else if (rmRandFloat(0,1) < 0.5)
	{
		rmAddMerc("MercHackapell", 0, 0, 0, 0);
		if (rmRandFloat(0,1) < 0.5)
	      rmAddMerc("MercHighlander", 0, 0, 0, 0);
		if (rmRandFloat(0,1) < 0.5)
			rmAddMerc("MercSwissPikeman", 0, 0, 0, 0);
	}
   else
   {
		rmAddMerc("MercSwissPikeman", 0, 0, 0, 0);
		if (rmRandFloat(0,1) < 0.5)
	     rmAddMerc("MercHackapell", 0, 0, 0, 0);
		if (rmRandFloat(0,1) < 0.5)
	      rmAddMerc("MercHighlander", 0, 0, 0, 0);
	}

	// MEDITERRANEAN
	if (rmRandFloat(0,1) < 0.33)
	{
		rmAddMerc("MercBarbaryCorsair", 0, 0, 0, 0);
		if (rmRandFloat(0,1) < 0.5)
	     rmAddMerc("MercMameluke", 0, 0, 0, 0);
		if (rmRandFloat(0,1) < 0.5)
			rmAddMerc("MercStradiot", 0, 0, 0, 0);
	}
	else if (rmRandFloat(0,1) < 0.5)
	{
		rmAddMerc("MercMameluke", 0, 0, 0, 0);
		if (rmRandFloat(0,1) < 0.5)
			rmAddMerc("MercBarbaryCorsair", 0, 0, 0, 0);
		if (rmRandFloat(0,1) < 0.5)
			rmAddMerc("MercStradiot", 0, 0, 0, 0);
	}
   else
   {
      rmAddMerc("MercStradiot", 0, 0, 0, 0);
		if (rmRandFloat(0,1) < 0.5)
			rmAddMerc("MercMameluke", 0, 0, 0, 0);
		if (rmRandFloat(0,1) < 0.5)
			rmAddMerc("MercBarbaryCorsair", 0, 0, 0, 0);
	}

	// ASIAN
	if (rmRandFloat(0,1) < 0.5)
	{
		rmAddMerc("MercRonin", 0, 0, 0, 0);
		if (rmRandFloat(0,1) < 0.5)
		   rmAddMerc("MercManchu", 0, 0, 0, 0);
	}
   else
   {
		rmAddMerc("MercManchu", 0, 0, 0, 0);
		if (rmRandFloat(0,1) < 0.5)
			rmAddMerc("MercRonin", 0, 0, 0, 0);
	}

	// PRIVATEERS
	rmAddMerc("Privateer", 0, 0, 0, 0);
}


