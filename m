Return-Path: <io-uring+bounces-10996-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 23D7FCB20F5
	for <lists+io-uring@lfdr.de>; Wed, 10 Dec 2025 07:20:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 6C3633002FE2
	for <lists+io-uring@lfdr.de>; Wed, 10 Dec 2025 06:20:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C56533B8D60;
	Wed, 10 Dec 2025 06:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mPHPW0sn"
X-Original-To: io-uring@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16A03274670;
	Wed, 10 Dec 2025 06:20:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765347648; cv=fail; b=psdzltck/AcLfJ5koKh/Pyl2uz1Usk0xL3W3m2Qdmpgo6LmGfx3SzZbq0Z9WikDFeQdOD0lGfdppETg5xgWwj1/OFidH8/po3EOhn5Rjxi/UXfcWNPhn1IvrHPdbcd8oCVnco3OdlR3FqmZxKRPYNCiXTEuzd7LAOuUefv4M8m0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765347648; c=relaxed/simple;
	bh=ryLe7L0RWHoUDBIm4pbS+Gqc8eihGQc7tBeJj035TBg=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=qv5EaKotD35W8LjX8vF30XMYbityNQgUEc8D40iRKWz5kgqtg3h1Ct//PoFKx/SA+RgvWbLgQM1tNKIF7j+pxKY9CYkWwTLU1nMS49uaf9DcZFKyeA9PJ2xyhec9NYx8tVOjjyDkaGHtP3uBk3uhATuXDQ5QNHt/8Zg+aHY1OxU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mPHPW0sn; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765347647; x=1796883647;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   mime-version;
  bh=ryLe7L0RWHoUDBIm4pbS+Gqc8eihGQc7tBeJj035TBg=;
  b=mPHPW0snGe81jtr70tth8srewl5WkssV83s7UyFSyph0mEcp+qv2o5hc
   B8qw+T9cH1/cInRO0BE+aHcxyzZcfFuQlN4MPHIcjLQGJXL0k79QLTrIP
   W4Ody5uKFcMmlaO86yS66z2COMhIWhnZxfLuqt4jKK/IFKgbjl77d5fnJ
   1aMXHY9UEDNr3xo+EGN2mW6UbW9pj/OXT+rSYPGaRhDxW2OP3uqMoBFXu
   BwxpXRQ5tlYGOzp3Ph0XIIU42mTLHEBM6BChevImBEbhlsTIAAbfyu8/y
   /Dl4+5JgBen8rvlstbauwBxQZWS9rndLF9tPtlHHRPlWcL+9VhMEiupAO
   A==;
X-CSE-ConnectionGUID: UA45zUk7Q0yYEuXWxFMOUw==
X-CSE-MsgGUID: aMfT036TQcu1IXkJk3MNcA==
X-IronPort-AV: E=McAfee;i="6800,10657,11637"; a="69901846"
X-IronPort-AV: E=Sophos;i="6.20,263,1758610800"; 
   d="scan'208";a="69901846"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2025 22:20:47 -0800
X-CSE-ConnectionGUID: peRip3lKTkCjuG4aIY1wrA==
X-CSE-MsgGUID: 9eEuwfodR/OYuW9Pnb5ggQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,263,1758610800"; 
   d="scan'208";a="200920755"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2025 22:20:47 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 9 Dec 2025 22:20:45 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Tue, 9 Dec 2025 22:20:45 -0800
Received: from BL0PR03CU003.outbound.protection.outlook.com (52.101.53.52) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 9 Dec 2025 22:20:45 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=w9SPyFS1bRo6/YVNp4hYqhTHhYzbxEa9DTKTmdnQlHbNohSfNAlsCA4cIH+T7RafLjr4vYiiv/CcYHcSDdto7zK31OEJzy1Ib5wB9KwExBLYk8zWbzaIRmhuYDab2o51mtFm4z/n5cdqmB+tN1AniyP1FKmBTVdlu+gP0yNS3dFB10OU1FID2tF2IHebOwbbtvtIfpDWj7ND7OdDZsVlGH2Fpb6bXlntrtIonmNF1X3lVF6wQckoTpA9a3ichYAKW3hWKfq6swxg7QOnO13SLeXl9ZzslbF3px0q1DvWw+1xILK5sEHG2DtGLQ1kpypJ2XLhusMXTFf9TapPQTAy1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G72PT6SUCHYTT80s+oWE+D+ZkfiCRk0VzPBNBij9+Ng=;
 b=PlMVQcZHrpZ7WMwh1KBNg+abGYhp7xDGLr7itED5xJ5a9ATTWX6i3+RAMpofEu6Dy7/LLjvf0YPDZywOofkTnsYf/igdx7XtG+ULUdW5u+PNbpvJU+oDTuU2ZLz5PVy117kXsWpwxvykUBgWSbnSUij/0UF+2GD4s5fpXYEpUxT32FQyc4/hzBe2fU0k3BC34pfHyk0VhBPWXGAYYLjqrbldmIflWqAErifomo3lwUFIDCDkj7oAfEbmz8y8pdmbMttJc1RXfYkcp6f3VpIEQX5rCmGG521/QsJIeMPt2SMjPGf+3yfwxVKar7WqVw1d/VsUtn1rsHnLwz8Wm45paw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by SA1PR11MB7700.namprd11.prod.outlook.com (2603:10b6:806:330::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.8; Wed, 10 Dec
 2025 06:20:37 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c%5]) with mapi id 15.20.9412.005; Wed, 10 Dec 2025
 06:20:37 +0000
Date: Wed, 10 Dec 2025 14:20:28 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Caleb Sander Mateos <csander@purestorage.com>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <io-uring@vger.kernel.org>,
	Jens Axboe <axboe@kernel.dk>, <linux-kernel@vger.kernel.org>, "Caleb Sander
 Mateos" <csander@purestorage.com>, <syzbot@syzkaller.appspotmail.com>,
	<oliver.sang@intel.com>
Subject: Re: [PATCH v4 5/5] io_uring: avoid uring_lock for
 IORING_SETUP_SINGLE_ISSUER
Message-ID: <202512101405.a7a2bdb2-lkp@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251202164121.3612929-6-csander@purestorage.com>
X-ClientProxiedBy: SI2PR01CA0046.apcprd01.prod.exchangelabs.com
 (2603:1096:4:193::18) To LV3PR11MB8603.namprd11.prod.outlook.com
 (2603:10b6:408:1b6::9)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|SA1PR11MB7700:EE_
X-MS-Office365-Filtering-Correlation-Id: c183f7f4-5d9a-4d10-adaf-08de37b43bdd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?Fs6pZ1axsX0e6KaQin2V1aLlNPakTCZYfWZl/18BdDHmzG1kGv2o4iZSUi7O?=
 =?us-ascii?Q?6mYWW19OsabN0QVCHJNYR775GufbwGqJyf/kynHpAiUo7Yg56qMPQQtvcVeQ?=
 =?us-ascii?Q?DtqrnTNBHbOIaQXblOwHPLRoBzSMPlSW0J3RuBrfUP4oDe5bXOcIWfNfoEgE?=
 =?us-ascii?Q?XXx60sN7pwGXkzsZPbL4b4O12KVXw1vDVjDt1TIESEVXhU/1rL96e4qfu5gS?=
 =?us-ascii?Q?2iYGGYoDeDB5q4K1gBRNYxJsnxT8plz9+p6WtjGPyg3az0TawKSx1k8casVm?=
 =?us-ascii?Q?2llF35nSSw1cOKd2K79iVNQhiCbgZWBFysv8OSSJHk1JhAeRVbMMPHQOf1Yx?=
 =?us-ascii?Q?Y8lPrAClkcgs7ZEzoyriTUzTQuiJuniOgXNHEqRVwiXEkfOx96atbF+5Knxa?=
 =?us-ascii?Q?zTtk2L4wm5jhBXHSIQfSOLKBbFcbZpiYnLmV43kMH85SReYQOxQAtvHiKzG/?=
 =?us-ascii?Q?A+EZi269d0J+aZr/A2N6PAuotAVmsMQL02H4wFcP+2dV/vOv8z4Bogzgugvm?=
 =?us-ascii?Q?3kkMdEz9uZNQ9OsbHwRMELwLr10z5Uwi9WG4erUGJL2ewLW6SrncnruqQZcn?=
 =?us-ascii?Q?i10SidlyaMGEmX/doAZU3uze2iwDtE2SD7W1T7MbRN8qfzYHqsAoOIaN9gCn?=
 =?us-ascii?Q?TWW1xPrz1UNgfpT48kuWFSdptTezXgjm20qgkYPT9Hwt4OWj6AT1i4U/3Uyo?=
 =?us-ascii?Q?6FURly7PIdjXYKAaKnN2njXXt8Vd1574WlyiSMYYdi7DMrS7CmZr4bDuneY6?=
 =?us-ascii?Q?IE2g/TK2ZxI8fWgZFwMnXPOit873ZpbT1wtFbg+8VQE1Gm3BuYrS9XzzOJ+7?=
 =?us-ascii?Q?oO0CLVakkk9NmNSNTgchU/4f9qwEcRh6ILIalvLnV2khsRB3hDUj3whuCrgr?=
 =?us-ascii?Q?wwfg1y/iAhsQZ5PJcqBsgdacjZ38l0nDs3q5ukq1WDlrBdpF5T0qBDJlXkrL?=
 =?us-ascii?Q?7XVN94aamCkwt6ZuybMp4QalDReAPqkJNd/P4XnadwQZwkBnGxgNw754sq14?=
 =?us-ascii?Q?MP0DybxEb/P90VL1tQoGRbMLErEXAKD1SZfOGPLnReaL57Na20QXv+8MCC98?=
 =?us-ascii?Q?6BzTWx5f01Uhl93PILs9eYz4zwHZ+QJvLV0nXjXJK345N56bTbqb9/sMuU7F?=
 =?us-ascii?Q?xspn5tVjRoQpPYe6ys05JejlvMjX03slfRRhsOCNvLOGZNHtk8xXsQS7CPpw?=
 =?us-ascii?Q?AXMf2N2bckmaxn5Cgrh+MbD/dNnSTYlaGmowKVYXog6uAjwdoUslPUZJV06g?=
 =?us-ascii?Q?6dcju/1fjXgndJBlvdx7qUJVwz8ozmjTfjHkFpfgQu3IZYX6HT/S9N5AcRF2?=
 =?us-ascii?Q?z1d5gVGv817Y6nhhf56omgon06Qn8pV8K8ZXs17uUY1n/q8T0G4PBbYbgTqV?=
 =?us-ascii?Q?65pn6t9rTvga9Wbttiw+Q/XWR/ZPw3x7ZkOcWmpJIEDpTMp4LkwxiEXPxgVc?=
 =?us-ascii?Q?QUyHcc/GFm1E+ms9MCOZjnTOv0huenhwbWwV/kH0p1l2Y2tRmAoCJA=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?R+1cG2odEbfxzJOsnWOzyK7cPbV6UAaDro3soHzNjqW92Oq3xidMm2xwp1sm?=
 =?us-ascii?Q?9x7awZRY2W5+l8deBzSuo5ZZqzFQxsI4fKNdsKkgGk5gqF6M3VlI0jjxQrd7?=
 =?us-ascii?Q?Bkd7PEMYSCVLsxAYkN4Bh4KAzyVfewlRClToUvwrEM5ueH2+ZdDCKK52jfHs?=
 =?us-ascii?Q?pNJtSxDeBIP/9v2sHei9diib+xs0zS49tBbIAZX8XHMryt1tCaWGe0q7vhAQ?=
 =?us-ascii?Q?YMVthSoBnzvoH6FGn1zMV7f0zVaIHlteWrL6H5wlNUPAyUPO/0oWdZW5PxRX?=
 =?us-ascii?Q?FGHTWWMtySZu0JpJOtKNjF+VTM//TwCrjlC/wa3tPNRTcskCwx2bqzYWc2GV?=
 =?us-ascii?Q?lTtv45ygdHLGVyB/wvkitRrvq2N93BiG/4aHHLtnGT6juGat75iTAxoPGKEc?=
 =?us-ascii?Q?SlzvCShFRdGk++/nuo3ATbHAdhatJarjJLSBPxpXaiYwJgEFyozpy3AtO7Kz?=
 =?us-ascii?Q?aeswslJKgOqd2kDwOpKjpvbxqkBzrnMx/ecWnMnDsHnZEJmCO8s4h0G5DZ1N?=
 =?us-ascii?Q?J7YhKBLlR1HRFuule36p3UUqEjYbAtqoxSEZWKfnRNzOf+ICAfrA4TCg5neD?=
 =?us-ascii?Q?lYHCvQoy8/ohR6QCZjRGxD2R2z2S2m+iJHJIfI/XL1uBO1BULNrOArsGw7Qj?=
 =?us-ascii?Q?9Fhg9MWanZ0voNuK2WM4euM1HI7mhnGmjTPabt3ikfbe9bl9yxEdLt/DmSvx?=
 =?us-ascii?Q?UWL27Ue3vKe5xSFsbzSBT5XOfK3aMvv0SYmYMJJyZ9mPvROBDZrjKARVOUt1?=
 =?us-ascii?Q?/eCdAL1wO1SA+o9kcZUHBw4bR0LNFJEDlS0gQ3H/PnyH+gEFpoxNpMFginTJ?=
 =?us-ascii?Q?2oFLqMuG6nwQt+rZkjweQdgWUjogEZw77vnm15uuJGnQbizxgexjnx2Asr+G?=
 =?us-ascii?Q?gLJh5oCsUYKoV2qGaQP3FvI2im00WyZ+O6jYnyYq7Jo8nj10FuVb5nk70/MA?=
 =?us-ascii?Q?BBxWvGnUzaZtPEh843VIwKz9qwCd/n75MVW3x3seopeb68PvfWQohqJBUSIq?=
 =?us-ascii?Q?xpRsEm8vGnEZKvO+HVKLIjrxpbEp4tanRwtPmvzD4t30hGUGLRtR7WHmScox?=
 =?us-ascii?Q?HMKaBYygwFloLaaUf2nvRWvNrmECQYCpGaPD5EwU6ey2oVwV1Kc4LMOXUi0f?=
 =?us-ascii?Q?9ru5UUZZmN+fr9hjt2ZWYGA87adz1XNNj55HJLGcvE/pi1zYDQxpWZE0ZwKz?=
 =?us-ascii?Q?ZUZRcjnjgSgiC45RIzL/yTyA/R2sBrEbUOsptIaEzqd+RNElmCA1IdpNVpMP?=
 =?us-ascii?Q?th9iJ/SFosUGM4BNTccbN1oSKKOnvJnguN5si8rrBPe/sy3VcTN9Yy3DGLjj?=
 =?us-ascii?Q?jqwZ6RohEoQt1gvvVUzDOWN1uLj2w8lbTbJLQUUOGyM4gmeXp0Q0O7gbpcU0?=
 =?us-ascii?Q?bTgxBdG1KVeHoDacd0CvkEGXYY2ePNoK1DLQjtndVIBseqiIt23tWHB8YFZL?=
 =?us-ascii?Q?xsozIryg7hqJ55m5t3SYuLlwNRQ/cSsCTcdNQHn0CsaTKY69kgBxCOeBxdTQ?=
 =?us-ascii?Q?ToxOX5UhngexISZtcXCVFf8ob72aUem4dtl2vuLlbnz5iKBDQoh5wvZPzbET?=
 =?us-ascii?Q?uHvrpPIyHne4PFTehqrFA/D9YqbrwUhVnVKP8MFLKK0o4fAA9XdmTDSfVTXs?=
 =?us-ascii?Q?jQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c183f7f4-5d9a-4d10-adaf-08de37b43bdd
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2025 06:20:37.2635
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Dla91w1KuMWP+lZ4EqHxn5S0Zb+d6cinn9YNluotigxS4aj/jFHCiQ7Q5IuwfJBdNtbyQUFiqAeCVVxwezdE1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB7700
X-OriginatorOrg: intel.com



Hello,

kernel test robot noticed "Oops:general_protection_fault,probably_for_non-canonical_address#:#[##]KASAN" on:

commit: a924e7ffd1b0b2e015ed1174662d52053a2339c4 ("[PATCH v4 5/5] io_uring: avoid uring_lock for IORING_SETUP_SINGLE_ISSUER")
url: https://github.com/intel-lab-lkp/linux/commits/Caleb-Sander-Mateos/io_uring-use-release-acquire-ordering-for-IORING_SETUP_R_DISABLED/20251203-004502
base: https://git.kernel.org/cgit/linux/kernel/git/axboe/linux.git for-next
patch link: https://lore.kernel.org/all/20251202164121.3612929-6-csander@purestorage.com/
patch subject: [PATCH v4 5/5] io_uring: avoid uring_lock for IORING_SETUP_SINGLE_ISSUER

in testcase: trinity
version: 
with following parameters:

	runtime: 300s
	group: group-00
	nr_groups: 5



config: x86_64-randconfig-015-20251205
compiler: gcc-14
test machine: qemu-system-x86_64 -enable-kvm -cpu SandyBridge -smp 2 -m 32G

(please refer to attached dmesg/kmsg for entire log/backtrace)



If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202512101405.a7a2bdb2-lkp@intel.com


[  617.261968][ T3783] Oops: general protection fault, probably for non-canonical address 0xdffffc00000000f3: 0000 [#1] KASAN
[  617.267361][ T3783] KASAN: null-ptr-deref in range [0x0000000000000798-0x000000000000079f]
[  617.268334][ T3783] CPU: 0 UID: 65534 PID: 3783 Comm: trinity-c0 Not tainted 6.18.0-rc6-00312-ga924e7ffd1b0 #1 PREEMPT(lazy)  f22e3d733e0666690a06b271bf82578b56b40aa3
[  617.269927][ T3783] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[  617.271108][ T3783] RIP: 0010:task_work_add (kbuild/src/consumer/kernel/task_work.c:68 (discriminator 2))
[  617.271772][ T3783] Code: 39 25 df fe 67 03 0f 85 8c 01 00 00 e8 1c bd 24 00 4d 8d ac 24 98 07 00 00 48 b8 00 00 00 00 00 fc ff df 4c 89 ea 48 c1 ea 03 <80> 3c 02 00 0f 85 2f 02 00 00 49 89 df 48 8d 44 24 38 4d 8b b4 24
All code
========
   0:	39 25 df fe 67 03    	cmp    %esp,0x367fedf(%rip)        # 0x367fee5
   6:	0f 85 8c 01 00 00    	jne    0x198
   c:	e8 1c bd 24 00       	call   0x24bd2d
  11:	4d 8d ac 24 98 07 00 	lea    0x798(%r12),%r13
  18:	00 
  19:	48 b8 00 00 00 00 00 	movabs $0xdffffc0000000000,%rax
  20:	fc ff df 
  23:	4c 89 ea             	mov    %r13,%rdx
  26:	48 c1 ea 03          	shr    $0x3,%rdx
  2a:*	80 3c 02 00          	cmpb   $0x0,(%rdx,%rax,1)		<-- trapping instruction
  2e:	0f 85 2f 02 00 00    	jne    0x263
  34:	49 89 df             	mov    %rbx,%r15
  37:	48 8d 44 24 38       	lea    0x38(%rsp),%rax
  3c:	4d                   	rex.WRB
  3d:	8b                   	.byte 0x8b
  3e:	b4 24                	mov    $0x24,%ah

Code starting with the faulting instruction
===========================================
   0:	80 3c 02 00          	cmpb   $0x0,(%rdx,%rax,1)
   4:	0f 85 2f 02 00 00    	jne    0x239
   a:	49 89 df             	mov    %rbx,%r15
   d:	48 8d 44 24 38       	lea    0x38(%rsp),%rax
  12:	4d                   	rex.WRB
  13:	8b                   	.byte 0x8b
  14:	b4 24                	mov    $0x24,%ah
[  617.273774][ T3783] RSP: 0018:ffff88816ac9fb10 EFLAGS: 00010206
[  617.274486][ T3783] RAX: dffffc0000000000 RBX: ffff88816ac9fbe0 RCX: 0000000000000000
[  617.275413][ T3783] RDX: 00000000000000f3 RSI: 0000000000000000 RDI: 0000000000000000
[  617.276336][ T3783] RBP: 0000000000000002 R08: 0000000000000000 R09: 0000000000000000
[  617.277257][ T3783] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
[  617.278178][ T3783] R13: 0000000000000798 R14: 1ffff1102d593f65 R15: ffff88816ac9fcf0
[  617.279075][ T3783] FS:  00000000010a2880(0000) GS:0000000000000000(0000) knlGS:0000000000000000
[  617.280114][ T3783] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  617.280856][ T3783] CR2: 00000000d684d000 CR3: 000000015f35b000 CR4: 00000000000406f0
[  617.281749][ T3783] Call Trace:
[  617.282202][ T3783]  <TASK>
[  617.282613][ T3783]  ? lockdep_init_map_type (kbuild/src/consumer/kernel/locking/lockdep.c:4973 (discriminator 1))
[  617.283274][ T3783]  ? task_work_set_notify_irq (kbuild/src/consumer/kernel/task_work.c:56)
[  617.283904][ T3783]  ? lockdep_init_map_type (kbuild/src/consumer/kernel/locking/lockdep.c:4973 (discriminator 1))
[  617.284515][ T3783]  ? __init_swait_queue_head (kbuild/src/consumer/include/linux/list.h:45 (discriminator 2) kbuild/src/consumer/kernel/sched/swait.c:12 (discriminator 2))


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20251210/202512101405.a7a2bdb2-lkp@intel.com



-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


