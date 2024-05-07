Return-Path: <io-uring+bounces-1803-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0CAF18BE4BC
	for <lists+io-uring@lfdr.de>; Tue,  7 May 2024 15:53:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B6FF228C19F
	for <lists+io-uring@lfdr.de>; Tue,  7 May 2024 13:53:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16BEC15ECD3;
	Tue,  7 May 2024 13:51:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TKtT/NyX"
X-Original-To: io-uring@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F4DC15ECCF;
	Tue,  7 May 2024 13:51:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715089868; cv=fail; b=hN4pd9dbSa8abODmi6GQJ9unSoD/iH30QjzQOETC+F6+MAyS9yaI09EwwtujvlMZZ67VslMDjrh9XtbSlrBS485vAmy1So/K3qTiiPONAb38zBvsVD/RdP2q4zNehjVVhvGRyw6meGIu39X8kugezX1vlNLU/Oo/PhZDfRs8/LI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715089868; c=relaxed/simple;
	bh=MEyLTZ6p1naZXhzt/nFHwD8+bW2EmL2eTOvW+qZT9+0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Og902MiMHJO9eDqGjC9Bj9jmb7zPbW3yzbEh3NtN/aztpLP2MgWZzDjHJ4XplPqVZ2wG91GC7qr0/R7/pqLt5T7dl0uUCrkw9VPV6GXZkY3odgbPxvMDFxtVY2uhd5ZdPcAXruU6JPOE5v1yMNUvVX+lLZdXpnSPxNHLDFTPc64=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TKtT/NyX; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715089868; x=1746625868;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=MEyLTZ6p1naZXhzt/nFHwD8+bW2EmL2eTOvW+qZT9+0=;
  b=TKtT/NyXYUvYnQ9K4BrCNlmjnVqO9V9qbjpUtjzSbFRp8doud6KxRlx5
   wcY0Q2+N9WXCoDzvdyl6//crLP+Y+PhpL3yLXOl001Z6aB42/sOKyLS21
   sgM1ifLAJth2TazCb2EIvXi6Q0Ze5cso1u6wtKSOxfEfkQLaSBWXBgFEK
   VUXknv0hhN+71D2cA/7Ij+0IoPhZfI8apQwgsSY+o2bijtH57IGPidpKl
   IwiO+6kPfuFB7cxY9zlSj9qUmXqkc3FUtdiminlyGJK8dHeD6L/w9aVkT
   zOdVqtkYmYGB5ZUYTzAznHCO5hSdUwaPw2EA4gok6YVPtFTCKCYLiSFmD
   g==;
X-CSE-ConnectionGUID: Sl9j3B6DSMeNAqPO2mJJag==
X-CSE-MsgGUID: wOMHVVVnReCpP4xqRVuTmg==
X-IronPort-AV: E=McAfee;i="6600,9927,11066"; a="22043435"
X-IronPort-AV: E=Sophos;i="6.08,261,1712646000"; 
   d="scan'208";a="22043435"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2024 06:51:07 -0700
X-CSE-ConnectionGUID: ahOy1eM0RcqNzWKvdykEBw==
X-CSE-MsgGUID: tGu+fGd3Q8WlmSUka3eepw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,261,1712646000"; 
   d="scan'208";a="28511092"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 07 May 2024 06:51:06 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 7 May 2024 06:51:05 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 7 May 2024 06:51:05 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 7 May 2024 06:51:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jpdJnT1i4eTdPST97CuCC55ut8AmTfg0v0wFpMuXsQA17hTVa+WeurSH/7y3VL0RholOM4kafZqrMErB0GTgY4s6F+J4/EJHr/xvW5DM97oCr2azBWb1ALxaWkDKGhQAtKhTbjpUT7pObenIYEOKZgzZqc6SxyQje0GmO76C9feU3Gy7cJpUlXw0Z6F+97LiEeFvcI6rOZRET+lBxL6OfSjLGbnJtxAgZvtfrrxlP6IS91RtFMNejkOdBeorvbhknWGIozbtEXq8SKVvIYQWuVX3iXIoO4mYPiQXr0UshimjjCrwb75EfslzikwsUcsJwKMYro4VHX4w2fBrBjmbBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MEyLTZ6p1naZXhzt/nFHwD8+bW2EmL2eTOvW+qZT9+0=;
 b=GmNbklLpYBwAgB/ig1ExZBQpFdonXZcNvUj28W4204jC15sIJ0Q9+t8OtnAWBozh4NCX+kYkpchcteBACFbCRzzuTMO5oAPLnFNNjHpQmZq0UpBi4YdH76HLA5kraGVL2kOazUcR+Yvl8oKp3DyBSbsgpdelhSQwD0sfmlo3XBWg+4guO7J2UwtPJbv5+6r9v/9IjZNiCjEHVGGkLAgtGbtjuNd4lcVLi1FlI6XFVMRA55cGMuC+dBXHyhFfpZjR3Z8jMAC5EL62E+4xQt1SupKVNoqio1UI5oNET350EAQ2+T5jG0ecJ+ut7iKf0xOYFTp+Wz1CA9/nQzla6Ksg0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DS7PR11MB7834.namprd11.prod.outlook.com (2603:10b6:8:ed::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.41; Tue, 7 May
 2024 13:51:02 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%3]) with mapi id 15.20.7544.041; Tue, 7 May 2024
 13:51:00 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>
CC: "x86@kernel.org" <x86@kernel.org>, "keescook@chromium.org"
	<keescook@chromium.org>, "linux-sgx@vger.kernel.org"
	<linux-sgx@vger.kernel.org>, "luto@kernel.org" <luto@kernel.org>,
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"debug@rivosinc.com" <debug@rivosinc.com>, "io-uring@vger.kernel.org"
	<io-uring@vger.kernel.org>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "kirill.shutemov@linux.intel.com"
	<kirill.shutemov@linux.intel.com>, "mingo@redhat.com" <mingo@redhat.com>,
	"linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
	"christophe.leroy@csgroup.eu" <christophe.leroy@csgroup.eu>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "sparclinux@vger.kernel.org"
	<sparclinux@vger.kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
	"bpf@vger.kernel.org" <bpf@vger.kernel.org>, "peterz@infradead.org"
	<peterz@infradead.org>, "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"bp@alien8.de" <bp@alien8.de>, "Williams, Dan J" <dan.j.williams@intel.com>,
	"broonie@kernel.org" <broonie@kernel.org>
Subject: Re: [PATCH] mm: Remove mm argument from mm_get_unmapped_area()
Thread-Topic: [PATCH] mm: Remove mm argument from mm_get_unmapped_area()
Thread-Index: AQHan8+VcRuZX/+qhkGkv4gN6Jgd0bGKZjqAgAFlVYA=
Date: Tue, 7 May 2024 13:51:00 +0000
Message-ID: <8811ab073c9d1f0c1dfdb04ae193e091839b4682.camel@intel.com>
References: <20240506160747.1321726-1-rick.p.edgecombe@intel.com>
	 <tj2cc7k2fyeh2qi6hqkftxe2vk46rtjxaue222jkw3zcnxad4d@uark4ccqtx3t>
In-Reply-To: <tj2cc7k2fyeh2qi6hqkftxe2vk46rtjxaue222jkw3zcnxad4d@uark4ccqtx3t>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DS7PR11MB7834:EE_
x-ms-office365-filtering-correlation-id: ec83565e-8d77-4257-148d-08dc6e9cbab3
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|366007|376005|1800799015|7416005|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?TGNUR0xERVd1aTRRNVBNa0JYU1RwNlNMZ2w2Q013c1BYQ294WE1la0dVYlpX?=
 =?utf-8?B?aU1lYW9sWEtGZnFrWVpLUjMzbEExY0Nqc0NtYU5xWElHcmFJV040TmlhQytK?=
 =?utf-8?B?T3JzODlPZHo5T0NNbm8rK1gwNmlUVmRIamk0c0lHVlJGL1QraFZ5aStVNHpH?=
 =?utf-8?B?c3h0MWlKbVo3QkhvTmR4c0E3SUlWTnpCY281TWoySG80ZmhQNUpHSkd1Rkp6?=
 =?utf-8?B?emJWSUQ4a1JrSyszbjFVTjE0WG9tSjJKMUlTM0p3cVNlalRPM2ZWU2h6T0NM?=
 =?utf-8?B?OURERTVyckYrcE9mWUhzTnlid0xTdkRPVVJoSU5PV3F5R1JGekpvM045Ly93?=
 =?utf-8?B?dGJwblJpSmFndHNMWWhEcnU5TUsvNStQUXNEa2dYa05lZWZTak1EUTBlaGkw?=
 =?utf-8?B?bDlXeFYyTlFMTGlRbzdZcTAyNUx4alZzR2hKMTQxWGhmNXZWSjlPdWFZNkwv?=
 =?utf-8?B?cE9SUStodnhsQVRNOFV1c2FVeks2WWxwSlFxUS9ZZHJsd3FUZ3RIVU0vVUx3?=
 =?utf-8?B?UDRKSnU1L05KclVFN3dOTTVrS3NpenJRaWVtRHlmR05ScXpONWdhVTROWllu?=
 =?utf-8?B?bFZuN1VaZ0ZPUkJUMEM0WW9IVGY1Yk1zeG5vdk5iK3IyZmllTDB4TXo3WnBi?=
 =?utf-8?B?WXo1K3IzTUd5anQ0czhzcytXeFVZaWJjZ0xMSzhIR0tjV3ZMZ3hOMFh4SFdX?=
 =?utf-8?B?YlNlYWVwblgxc3ZhZk1WRnE3TzNMZnhUOU4yU2VIUk40VzRQeXRoL1pwV1da?=
 =?utf-8?B?Z1JaVUxQQ2E0U2s2VVB4OGwrZmVQMENUNEt0N3JjSEo3Z3NTSnlzQVRrWVZV?=
 =?utf-8?B?YS9KeXhOZm9RNUNxdFRjOGFDZ084SkRCeTdlYUpiR3M4cDJQajRpM1FkM0hu?=
 =?utf-8?B?bWMwN0lGcHNoWVFZZEtRMG9wS2dQY0xCNzc2SVRQWXoyM3d6OUN6MVlyaWp1?=
 =?utf-8?B?U3RNVzVKSVQvUTdtTFF5VDhsQUs4QXQ3MVhxZStDWGtnTDBlOEVvdis2aDNu?=
 =?utf-8?B?NjVVSjJKQmthWnBLQUkxVmkyUWt0TjlZallaMmw1cG4yRXVuTC9kb3BZTlhC?=
 =?utf-8?B?SmdXblJyWDVJNm9WWjRzMkRqSXBnOHFMejBVbDNDZnR1RmdkcWJCdmNNYnhR?=
 =?utf-8?B?VFcyU2REVzNDTy9TL0IxYUdJZWtsOWM1Q2tvTWRiTFYyekFqbGxFd1JSZW1y?=
 =?utf-8?B?R1hUOFZZV0d0R2g2Q0tvUk5EVlJqZFo1Q1BFSU5jTnV2Uk13cTNBZ253Nm1y?=
 =?utf-8?B?SjQydmpMN1pwSHNiY3dtUjlpZ2o2MjcxeU5TTEh1OHV5MENFZnJZRFEvaXZ6?=
 =?utf-8?B?Z1BjclozUGc0Yk9neFovSFd6cEFDZTluU3AwYkRYbXNoNW1TdXZPSUNNMURv?=
 =?utf-8?B?ODJseHR2Yy9xZmlyLzNvc2R2VitieEpJckhGekJ6S01UbEtodmhqUHVsQXF3?=
 =?utf-8?B?QVFJbmxSYk9zMklHT3ZIUm0waVY2RHdxYUNFaWNLV3F2bzZkVlhLR2pWdVAz?=
 =?utf-8?B?L3dmbENmYUxWL2QrVzV4aUxXN2VFTHNuRkc5ajZYdUk1ZFMxS0FXU3hud1dM?=
 =?utf-8?B?aXlJWVNPbGxpN0Y3Zkd6amtmd28yY045QytTNFZIR0hhaDFPbDd1ZnlLZHVs?=
 =?utf-8?B?Z1ZWMkloZXJzSmZjdUJvK3JKUXlob04wS2t6d2RicE5uUnpOQWUxMVRnTWRi?=
 =?utf-8?B?N0piRC9sS1BLNC9FUnRCbGo0TGF2VEtHVUVueXViV0RTWGYwV0FoOHhNdkJH?=
 =?utf-8?B?endVT3Y5V3A2cGVDOUtTS0IxRnRmNE5PemZlNnR4cHc4UEtELzI2ZWx2TnBT?=
 =?utf-8?B?MUZ2YzI1NnRGQnJsWFVGUT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015)(7416005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?U28vZTcwRmxEa1gxcG1qQnpnZGdTT3lRelNwK2RjdGN6bTREcFNGYnRjOVhl?=
 =?utf-8?B?WjBhbXZ5aCsxMERaRmR6Z1lzOXBreE85NTE2VFhpMWF6azV3cjdUbDF6d1Rl?=
 =?utf-8?B?TVdOcUhFbDRReDFwUVBER3F5SXBSRTFRamNaNEVTNW5UbFdEME52aXFWdVB4?=
 =?utf-8?B?dFBhV2JROUZySjdTcThWVDN4VTZ6WUEwY1JEbE9vZ1JPMG5ORmpBenRPbWN1?=
 =?utf-8?B?YkRCemFCOTI1Vk9EZkhHZi94c1pmTHpTcElkVXVWS042dXZhZFdpbTdOdVc4?=
 =?utf-8?B?TVM5NXlGcHpya2NISFhMUmx1eDV1ZUZpS2JqMzVUZmo2cUpiY0RqaW1NTEJh?=
 =?utf-8?B?N0xPcjNvY2xTQWp4VXZDcGZ4dlJQYXZ1a3JpWnhPOGZJYmMreW0yd1JHVnY2?=
 =?utf-8?B?TzVLZlpoOU9hTzNiMEVUdHRJeC95bk4zV0JhUEpLUStWTzRqUldVUXJMbXl5?=
 =?utf-8?B?S1YxTWl6cnB3RFM2akt5WVZ6QWhQY1gwNnpyRzd4OWpMcUxVT21VSHQ0OEJ4?=
 =?utf-8?B?cG5VbFdrYjZDRE95OWs3V09NdE1ZZnNGbzdIa29GclRTc2pXTzM2NmZTYjV0?=
 =?utf-8?B?MWgzc0RXOTF2V1BFM29qUk1hQ2ZWUTlTalVtS0lFeGZzNEV6NnBTNWx1akRZ?=
 =?utf-8?B?TUdiZVAyNTZpVit4aENGN0hLR3YrK3hhUHpqZ1NMaFI4WDloRHF4NHhmUi91?=
 =?utf-8?B?NFY4N21naUloTDRZTHYwWkJlcXBoa1dDcy9KaXZIQTJncUlLdVZFcU5CL3dB?=
 =?utf-8?B?ZTdLa09zOVJwQytrYlhacDI5KzBxUjFiSHhpSTdheWxGU1F1Z3lLUDZoRGFH?=
 =?utf-8?B?ZXo1VURvV3Nrc2VXcm9Cd2VJSDhSRHZudXlTMllINXF3YWhBSTA1TkdCR2xB?=
 =?utf-8?B?K0YweVN3N0xrcXBDbnlXem5vVllaVGpGTXFmaXBGU0dGRzhaMWxQTVhEN2Nu?=
 =?utf-8?B?NHpHeHNRMnYxSG9BN1dmT1FzWEZBN0RCTE5rM25JZC9IVzBxU2JtVzFHTWRQ?=
 =?utf-8?B?S201WnZ6SW5lc1IrbTg0bnhGdkhyeGhILzhkdlRVWUx3djZZZDdHS0lhRU53?=
 =?utf-8?B?bSt2QTUwaW10NzVBN0p0SnhqWitJa2NqVy9qVk82Vi9EV2xOWkh4RS9tbEph?=
 =?utf-8?B?bG5TNndHWDRJTWVFbmVIb0JBV2RYNlVSbXhUZ09jREkwTkRQUEFlaHJNcHYy?=
 =?utf-8?B?MFkxSEIyclZrZXdMUTQwSWtvNmVrR2pjb1lJa0FUUjRGdnNHWEFPaW1rdEp2?=
 =?utf-8?B?Uk0yUElvTG80SjYrZmtLMHhseEFoVHZ5Z2hETDJxb1VxOUtDd09kWmYrWXhh?=
 =?utf-8?B?NEZuek9vcUo0Z0FncDkzcm4wM0FnTDNMc1hsbTJxS1VsMTN0YkxHYUFtZ1Y3?=
 =?utf-8?B?b3RBVUZIYUo2WkE3UUJtcmxFSDU1aVRxR2x4SS9XRzhucUdKdUlEUFZUNWJv?=
 =?utf-8?B?VnZhT2xpR0VWTXd5UE1BVFZQeUtMbWxMNklFNlV5TkZ3LytES3ZaT1VLWERh?=
 =?utf-8?B?UGh1TEZpb2NUZ1ZKeEI2UldlSVYzaVVvOUkrVEFKYmt1d2VwQkRJYmZSekJO?=
 =?utf-8?B?M0RETmVxN2xSd0VEVDJiUTloZ044cHhxRE9RV2VXYWF5Wm1qdm5vYnRqZGxh?=
 =?utf-8?B?Nk1US1hNMmNGUWNDQ0ZuM1JOZjVxRnFoWlJnYVZ0bTVuR0c2d1FDRFpLTHdu?=
 =?utf-8?B?Wi9UeGlZaDJFZkxac01WR0IxSkdVVFZqYzVkMUV5bGIzY29rMEorRWptN0cv?=
 =?utf-8?B?NXIyMU9wTHY0cTRXVUhHeTlEczlNbFJqemN6c3o0R3VHRXlqekNCWEJKd0Ju?=
 =?utf-8?B?SVFyZDlSSEpVc1lHeDFXR3IxZ0hocjRJQ0VOOVB2V00yVFdnYVpkckkwUml4?=
 =?utf-8?B?cVJ2T2FWZzU0RFVzVGtMRm1VeW1RK2E5UVhQbnNRWUhSV3pJaEswY0pqS0My?=
 =?utf-8?B?UkpsbVJ2anF4ZnQ1ZHFaNXVJclhYNmp6RXB5anV5N0NySmhhSzBvNG9IYnFh?=
 =?utf-8?B?UXBGRGQ1WkgvZVliTjRyckZ1ZXhEbk5JbHlwakRQbjZMNU8vdklzbDhmYVZt?=
 =?utf-8?B?MUgvYVRTbHN4VHAxTXo1aVNGbGNDUncveHdWL0JMdmIzNTdsMHlvUXN6N0ht?=
 =?utf-8?B?YXVuNkNSMENxZit2ckkrV3g1RDRVRVRQMHhvTG5Wd1RSLzJmMnhEWnVvVVho?=
 =?utf-8?B?cWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <65DE2C5BC1B4A047BB5D1A730EE37CF6@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec83565e-8d77-4257-148d-08dc6e9cbab3
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 May 2024 13:51:00.4312
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: b+RqNNNKk8rgHwIrLlbEE1dDwAkNgLXTZgfBk2fkOkYV56Em4fmcTI4SdDJfiUZU5c83nD01uWxL/YGYFnFFsZymWC2L587MdKAdbXUo+2Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB7834
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI0LTA1LTA2IGF0IDEyOjMyIC0wNDAwLCBMaWFtIFIuIEhvd2xldHQgd3JvdGU6
DQo+IA0KPiBJIGxpa2UgdGhpcyBwYXRjaC4NCg0KVGhhbmtzIGZvciB0YWtpbmcgYSBsb29rLg0K
DQo+IA0KPiBJIHRoaW5rIHRoZSBjb250ZXh0IG9mIGN1cnJlbnQtPm1tIGlzIGltcGxpZWQuIElP
VywgY291bGQgd2UgY2FsbCBpdA0KPiBnZXRfdW5tYXBwZWRfYXJlYSgpIGluc3RlYWQ/wqAgVGhl
cmUgYXJlIG90aGVyIGZ1bmN0aW9ucyB0b2RheSB0aGF0IHVzZQ0KPiBjdXJyZW50LT5tbSB0aGF0
IGRvbid0IHN0YXJ0IHdpdGggY3VycmVudF88d2hhdGV2ZXI+LsKgIEkgcHJvYmFibHkgc2hvdWxk
DQo+IGhhdmUgcmVzcG9uZGVkIHRvIERhbidzIHN1Z2dlc3Rpb24gd2l0aCBteSBjb21tZW50Lg0K
DQpZZXMsIGdldF91bm1hcHBlZF9hcmVhKCkgaXMgYWxyZWFkeSB0YWtlbi4gV2hhdCBlbHNlIHRv
IGNhbGwgaXQuLi4gSXQgaXMga2luZCBvZg0KdGhlIHByb2Nlc3MgImRlZmF1bHQiIGdldF91bm1h
cHBlZF9hcmVhKCkuIEJ1dCB3aXRoIENocmlzdG9waCdzIHByb3Bvc2FsIGl0DQp3b3VsZCBiYXNp
Y2FsbHkgYmUgYXJjaF9nZXRfdW5tYXBwZWRfYXJlYSgpLg0KDQo+IA0KPiBFaXRoZXIgd2F5LCB0
aGlzIGlzIGEgbWlub3IgdGhpbmcgc28gZmVlbCBmcmVlIHRvIGFkZDoNCj4gUmV2aWV3ZWQtYnk6
IExpYW0gUi4gSG93bGV0dCA8TGlhbS5Ib3dsZXR0QG9yYWNsZS5jb20+DQoNCg==

