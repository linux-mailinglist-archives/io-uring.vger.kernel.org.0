Return-Path: <io-uring+bounces-8551-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 95215AEED57
	for <lists+io-uring@lfdr.de>; Tue,  1 Jul 2025 06:48:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9A9391BC0BD2
	for <lists+io-uring@lfdr.de>; Tue,  1 Jul 2025 04:48:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29A0A2905;
	Tue,  1 Jul 2025 04:48:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QhOvOoYg"
X-Original-To: io-uring@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 174F51E5018
	for <io-uring@vger.kernel.org>; Tue,  1 Jul 2025 04:48:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751345301; cv=fail; b=MwWGycdZCpKRJq8W9LDAwPa1Ocj/cTT2rV8x+yROPZ5yvsBGeEwDPHV56Ogr0aZj5U/8ygYzKvLR8HDdsHWlNv2kUmDWFjmVHcft+q/o+pbFYglZvqT1Z95w6kPIJK9v7I7WVZrChwMShVP1KxMNjdnGIqB+5uL7Z4PiuT+1zB8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751345301; c=relaxed/simple;
	bh=iz9mXJzdTxSM7B3p+bZ3QmGMzn9kpYlXIIJv5NpUDcg=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=kCiiwxGgctcm9++2O6v8Frr2sqqt+LHn2pxamt01HS215PN05eA6kRd53S/KsHpl+uA7jGxLM7H6SrGCGhLBgU+CkKW4+OrMM8DX3EX6FBb2d5X/7HhSkmTX3AOYHHa66IkCJ1KTuatYdsNPYPYESbXyMCM12WonDf3XF186ZGQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QhOvOoYg; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751345298; x=1782881298;
  h=date:from:to:cc:subject:message-id:
   content-transfer-encoding:mime-version;
  bh=iz9mXJzdTxSM7B3p+bZ3QmGMzn9kpYlXIIJv5NpUDcg=;
  b=QhOvOoYg6wnA1rP9pRc4SVYLRoSwi2PuWoCPpo+sH+fpZox9tfCco2sq
   TgKhRWyBAqDQ7RLFnzkbSe9PLNujR6FlxXgMZ9l5QRc/TjcPlj+ewvNiX
   audSakT8BsnM7mKtgmmrt2BWies5IvPdyt2iEdQu39PUmN7UoisAkxYW3
   F9fVHrmQ2mvE3QaYFDLE0srmDslJ2lP4r07JpqPEYNEm41OTN5ALC0rwt
   9Z6eE5YZRTONFw1j4FMUt2RzMNuXq3LxQFe9+EVBcPMAGbRHKggfhdoIv
   6yQ1MV7TDzVipsXBrX0DrB1uGR0gpRa0LRZZefyY0gREA4QLEp9B8cFTK
   A==;
X-CSE-ConnectionGUID: 99elgginTFyKgUcYT29vrw==
X-CSE-MsgGUID: M0MGy2gsRSKleHsyPuSOYQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11480"; a="53734847"
X-IronPort-AV: E=Sophos;i="6.16,279,1744095600"; 
   d="scan'208";a="53734847"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2025 21:48:14 -0700
X-CSE-ConnectionGUID: 3BXfMqT4SyCUBMVTIH6HvQ==
X-CSE-MsgGUID: kHDR2A/CTK2scZYzCHJiMw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,279,1744095600"; 
   d="scan'208";a="153130514"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2025 21:48:15 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 30 Jun 2025 21:48:14 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Mon, 30 Jun 2025 21:48:14 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (40.107.244.46)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 30 Jun 2025 21:48:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hkn+UOCeQsJi2DrY+DeRE72vXIr1isrv6Hpu3Ldlth7nk3ZHY5KN513AvHxKqRB0OkL249+xCNY10MORLKWQRmKbPKeqAfTC2IT6Rg8vylddnYDHaSgJ2IbXKthqyA8jzGHobojdc+dTYIh0aZ4IYJ+/DiDK8cp2EBAzEYaaIzPNfAP6EkoFBoiYQ+W8XHVnMrkF5lp0yfpiJt4t8usebiSE/dLK/trpv2qXDbigoH6qxI4+kho9gr62c2BpwngLIMhkAnaEjM/ULTbKrWD8egTnOalnXwz7a82VV4MeyfjngJhIhBsAkY1KFC4/jkJiQMcpvXiv1kr+r8IfNftUqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Rzi8NcNumlXdn/7X3X2IAEGAIWKR23cqvnlm/FGXKss=;
 b=DI2zoGzeRhq8R5+hflLOBsV3ovTuqO00EO2VUJc19IF4CrIOmiDtSdeV0VsPVUxnwpzgiKWPme0CYJWwKW5nmROavKJ5Smv5VDUHtw/iR9fdyhTRfVhiCDfCiO6M5RgQZB5Xb/1TumVTtDH2Bc5ANfecugTqJMjE8r/ufnd5eZt/En1MIhhIwwt7IB9TGrreStyY5NxLhkXOTe0+w/AwJCRfeCuq8ZYsevDJIeZiIvq4+H+u2qYmk+B2tEOYNmGQhazLd9HQDPg0g16HKuol0Aep6NNRkXTExXSpy2yh0wACG0klGU7K9H28Mo/1a9qNy0K3DJnrIIkQVcYJDeLTBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by SN7PR11MB6653.namprd11.prod.outlook.com (2603:10b6:806:26f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.29; Tue, 1 Jul
 2025 04:48:05 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c%3]) with mapi id 15.20.8880.026; Tue, 1 Jul 2025
 04:48:04 +0000
Date: Tue, 1 Jul 2025 12:47:55 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Jens Axboe <axboe@kernel.dk>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <io-uring@vger.kernel.org>,
	<oliver.sang@intel.com>
Subject: [axboe-block:io_uring-defer-tw.4] [io_uring]  61a5e20297:
 stress-ng.io-uring.ops_per_sec 41.9% regression
Message-ID: <202507010550.2d6f83ea-lkp@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SGAP274CA0001.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::13)
 To LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|SN7PR11MB6653:EE_
X-MS-Office365-Filtering-Correlation-Id: 1b813214-7fbb-4756-6bd4-08ddb85a774e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?FPF+xueA+DDhJ/o20Q0ze7FKhcLrn2a8Y1BbTTCA3vg9WxVeYstm0Gu0M3?=
 =?iso-8859-1?Q?IUDPSmDOtChK7xJPY04cgf3A0o+ShUQZz/MAoCYHJnhkhZ84ABYE6q6B3l?=
 =?iso-8859-1?Q?w8GQg66wPyYP5dWLWyFm+sX9X9odyA09FGXML8wLtYCe7mAyCfAYsjttd0?=
 =?iso-8859-1?Q?8FJwXHkfV1ZfZ9e4ITxyPlV4iMnwvjiK6PDsdJiuirfWT5fO24m5Z2Trt+?=
 =?iso-8859-1?Q?ZjxMk7X1DVJsPvO4v9yOy2SFL0PKJYetYHH74NoL5/Q/LwUgUXJ9OM5Jtz?=
 =?iso-8859-1?Q?uWPvfcFVhtXLJY+0u1WNq69ZYi5NmeqQsjH+QzUa6aPVhcpN8VFBAXyb1N?=
 =?iso-8859-1?Q?hLTSGNk7FQfP4Z38kpTCvhxY4yMqbrwRUdY802NH2T6Y+fyf0QJMkIDDEg?=
 =?iso-8859-1?Q?N7qZzk3o7atiLj/lD2Zgc9r1SyRPzy3SppI+Ogdt6kAP28mZirAU7BpP9S?=
 =?iso-8859-1?Q?O2CZkldAk/OdCzqnSD7L0n5l9xuf1P77Q7mleI/hHQgV1uZ+v9vd/In9WX?=
 =?iso-8859-1?Q?S9zMwOGSClp3O39VIMwc3bJi89S8EXWv0mR2KHTq723n+vuCUG5GMz1AUw?=
 =?iso-8859-1?Q?GtaauLeKhYstwEUG1NPJWEB4FHCKvi65O8Wsl75KR2/9JljagLq8SKy6uN?=
 =?iso-8859-1?Q?HZxyZ6rtyYPWpsgBfNYhGnToj75ZfiKfM057d2u4L1djTAmwxTgSXYoBRC?=
 =?iso-8859-1?Q?f2M4eiD2LSfqzFpNvLTLbQ5uMCKtXh0wGl70JQebWJt7QVhw7whDtK5i8i?=
 =?iso-8859-1?Q?68ytfugPg9ORcR5QaRCMK7gysrbUqnzp6+MmJCynRWBMgzmVMYIfGhdqz2?=
 =?iso-8859-1?Q?S4ZjSQnrCj6c+EYrZPq4okUfPjQ3F1Itf6L1Rl4rV/TKexBCKdcSveWOOe?=
 =?iso-8859-1?Q?pPi21OeFerseR19navEkOW3w6bJFLwhi8sX7cc03ZoCuCGhM5ofeEBBLNs?=
 =?iso-8859-1?Q?4hetBGd6Mo1/JZ1VXdXuNUHxRz2sZClcRLJQX394/gpk3bLdf0MGnIeKAV?=
 =?iso-8859-1?Q?hzGatK8YahcYcHWqOoSkriyXSExp4yBCA45PDxAcHeume5H03oO193QaYN?=
 =?iso-8859-1?Q?mr+SOL7sm/LYKFnHwBHQOQphc2yDaL2/pJmsCoAdZea20B+ew2iBpMYLVR?=
 =?iso-8859-1?Q?75dtQk6Div+1UtxdtuDJrJ8X11XddcGmdL3elxnzWLt3lhpr7KaCa/B8Rw?=
 =?iso-8859-1?Q?vaGM+7Ba/ZUDeyFEtSSgWTlhsy3kPOmD7C9zYQzZmok3ZFWkHgYRGdlIJs?=
 =?iso-8859-1?Q?QyT5fzs+0IocAGAyTzMqgDmOMiiPyvAIeqSPZvoYGWjPWbMKcggnqgc/C5?=
 =?iso-8859-1?Q?7+28VoFjTmnshQSmudVDC1N/1XWKi+6N5Inp/2tc0oP4Js8Iu7VP8kR7mH?=
 =?iso-8859-1?Q?wNXEN24enZuRvc+5VuiHngUyKFZnCSX9ys4MxWGe8WG6ONJ7Zvq4HZVF3o?=
 =?iso-8859-1?Q?YRY8+8GXvHJoij+8?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?2PAReTLF4ooFpV3+qkn/F+irmFp+h/dz7cpD20EAZ7t1kHin98VNXihrct?=
 =?iso-8859-1?Q?meQfqI6x4kBPrVO4S+7SLDp9SN8c4sHriKw348r5tSt22cK5K12kNaUl2f?=
 =?iso-8859-1?Q?aFLdH341neOIUIlsdSJrDafh81uPIqSNRTwetVr7xkf/MUAbfdKVrAjgtr?=
 =?iso-8859-1?Q?HQKd1n9rlt5WkOh5F/BiiDGR9cqX02W+DrJZkKXK5ZGY3U/IDk2xeZfh3D?=
 =?iso-8859-1?Q?9a6zxEoO8cu0sHbxoMBrViC713mHo1BbjR5Wzq+RSu+R1DvoV3D7yxlOdI?=
 =?iso-8859-1?Q?wvnnAnH4ZuVEhhjUMOvcXKyFBiv5HveJwo+jqL+OVJSabm7MrA5FWL05vf?=
 =?iso-8859-1?Q?2tbB8/DosrMoyRRcFMY19vBojAXxY3iluEQeuxaUu1EROGAMjBb2hhs7IV?=
 =?iso-8859-1?Q?Yc9fClOwJleeE3nfJLdiYbafjmOhq48a5PfEEA4365yM44DcOoDkJvg3Bg?=
 =?iso-8859-1?Q?7Wmys8HwFs52MMRviaZeavzwYKagfHrfX8RwEgy4xtSyn8Sfwm/4T/xepu?=
 =?iso-8859-1?Q?rlDxX3kMWAZiAg/yyUKSoG12zYw/i3jlUnq2oHpLp/xXENliCAqYS42jy9?=
 =?iso-8859-1?Q?uKBCw8no7h+RKfmOW9wmiSflDSysfNZbGfpteIW6OH8NaCowH5fgB6/nvd?=
 =?iso-8859-1?Q?ssoBuelO22fovEGW0Rj2szD8rBTowmUrE5fg7UasJxX6GKv/ITBZonJwoh?=
 =?iso-8859-1?Q?k1PwKR7SgiDgF7ibH87L0oXC0AxyzHu18x3kXpzhGAUFn/bXfIk/m0Gxkp?=
 =?iso-8859-1?Q?fpM1TFInAWBo/bcOPhc/aRnggOErppTNMZyhOSG2osZVdlOdVpfRuEsxuz?=
 =?iso-8859-1?Q?rpAicjQLVIPlZmhAxnrMn3Z57g98cV2Ysj1UcOZwyPBeiScG7MsFKvK2QR?=
 =?iso-8859-1?Q?raZjjT5kcv5mmtSjopCl1TlYeQQcCnOfJeTpU6rGR3rjJU9k9JewF6eycw?=
 =?iso-8859-1?Q?ks9/YuncMh5B0oU0w8rqAIrV7T9ZA+jiB50XeCyf31la6mTc1YwihBMt6I?=
 =?iso-8859-1?Q?sRKSCJ9zwXRb4LV3zLcbpLv9aWWMmea4TKrfTT4KB2OmCMqZalvOyQuWTs?=
 =?iso-8859-1?Q?P9OrHQINdG61PVR+1lljT1GPntQk9Qkv3As0HAKWegpkEMTPgCNacRbNpR?=
 =?iso-8859-1?Q?T2nRnox1qIPImZGBz1eG1aLkah5bRKtktE/Q6yfOmNDKAwl2TbJ0R8OS//?=
 =?iso-8859-1?Q?mG0MsZT3vS2noJe/1WPSvPPpYFvjhe2SqUvRl0knMPeZLpvTi4BqxVx+LB?=
 =?iso-8859-1?Q?f6T5qforrkcSbSSLAzp/mF62p/5VAJ4Gup0AqjbdT+iAIOi5hbC9GmknGM?=
 =?iso-8859-1?Q?KBPrHrajWRIqrBLTHm4UocYwj7puuUopyRdeSvwvFuXAH7ktYsPmS3TVZ+?=
 =?iso-8859-1?Q?ZlRXoJ0XxBJvY2hU8jQGkqRC74EBuwVjtMyQwZr/8ySaNwLq/oLxfvaF8T?=
 =?iso-8859-1?Q?dK7Uh2jLw65k1E7V+WPxg6f8nuHEuXkAviNLDokiqwrDrhRbcmRvT73n3j?=
 =?iso-8859-1?Q?u+ocOCCfGNQW+ZNnH6tf/5DRKDL9XHJ52F8cvPiL2Co/AGe4AFNTqxteIQ?=
 =?iso-8859-1?Q?A7YYWAO57kmWIcyqMqlBkqxcZlDKmFps3OinI3kGeiufzrB0cljaTWsczz?=
 =?iso-8859-1?Q?T/WDMlr2PcEuBQnVMn5fGW6vl+nkrp7zlFybVUs5RUh0PklQnMMQEkjQ?=
 =?iso-8859-1?Q?=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b813214-7fbb-4756-6bd4-08ddb85a774e
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2025 04:48:04.6394
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /6dNp/NEviD5yBSnTj/K33ni+f0ez3XtQq4B9CwSYE1uV8UfROTEYeqXX28D58dJm896rtSV+h7EQZ2fKemIMw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6653
X-OriginatorOrg: intel.com



Hello,

kernel test robot noticed a 41.9% regression of stress-ng.io-uring.ops_per_sec on:


commit: 61a5e202971d4a242fc761728e89922edde02d38 ("io_uring: switch defer task_work to using a ring")
https://git.kernel.org/cgit/linux/kernel/git/axboe/linux-block.git io_uring-defer-tw.4

testcase: stress-ng
config: x86_64-rhel-9.4
compiler: gcc-12
test machine: 192 threads 2 sockets Intel(R) Xeon(R) 6740E  CPU @ 2.4GHz (Sierra Forest) with 256G memory
parameters:

	nr_threads: 100%
	testtime: 60s
	test: io-uring
	cpufreq_governor: performance


If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202507010550.2d6f83ea-lkp@intel.com


Details are as below:
-------------------------------------------------------------------------------------------------->


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20250701/202507010550.2d6f83ea-lkp@intel.com

=========================================================================================
compiler/cpufreq_governor/kconfig/nr_threads/rootfs/tbox_group/test/testcase/testtime:
  gcc-12/performance/x86_64-rhel-9.4/100%/debian-12-x86_64-20240206.cgz/lkp-srf-2sp2/io-uring/stress-ng/60s

commit: 
  8559f3b41f ("io_uring: make task_work pending check dependent on ring type")
  61a5e20297 ("io_uring: switch defer task_work to using a ring")

8559f3b41fdcdd01 61a5e202971d4a242fc761728e8 
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
   1022268 ±  2%     -30.4%     711175        meminfo.Mapped
 7.478e+09           +30.1%  9.727e+09        cpuidle..time
  3.03e+08           -20.9%  2.398e+08 ±  3%  cpuidle..usage
    696425 ±171%    +181.2%    1958387 ± 81%  numa-meminfo.node0.Unevictable
    940879 ± 10%     -32.9%     631792 ± 14%  numa-meminfo.node1.Mapped
     43.50 ± 20%     -73.9%      11.33 ± 53%  perf-c2c.DRAM.local
     32749 ± 10%     -86.3%       4475 ± 29%  perf-c2c.HITM.local
     33251 ± 10%     -85.0%       4989 ± 25%  perf-c2c.HITM.total
  14632245 ±  9%     -38.5%    8999074 ±  7%  numa-numastat.node0.local_node
  14749610 ±  9%     -38.6%    9056826 ±  6%  numa-numastat.node0.numa_hit
  21106190 ±  4%     -37.5%   13198942 ±  4%  numa-numastat.node1.local_node
  21186924 ±  4%     -37.0%   13339356 ±  4%  numa-numastat.node1.numa_hit
     43.02 ±  2%     -12.5%      37.66 ±  2%  vmstat.cpu.id
     19.87          +121.8%      44.07 ±  2%  vmstat.cpu.wa
     73.14          +101.7%     147.54 ±  2%  vmstat.procs.b
    112.33 ±  2%     -64.8%      39.60 ±  7%  vmstat.procs.r
  12695197           -38.2%    7849636 ±  4%  vmstat.system.cs
   5179340 ±  2%     -24.4%    3915343 ±  4%  vmstat.system.in
    174059 ±171%    +181.3%     489607 ± 81%  numa-vmstat.node0.nr_unevictable
    174060 ±171%    +181.3%     489607 ± 81%  numa-vmstat.node0.nr_zone_unevictable
  14750003 ±  9%     -38.6%    9057006 ±  6%  numa-vmstat.node0.numa_hit
  14632638 ±  9%     -38.5%    8999253 ±  7%  numa-vmstat.node0.numa_local
    236391 ± 10%     -33.3%     157713 ± 14%  numa-vmstat.node1.nr_mapped
  21186186 ±  4%     -37.0%   13338387 ±  4%  numa-vmstat.node1.numa_hit
  21105453 ±  4%     -37.5%   13197958 ±  4%  numa-vmstat.node1.numa_local
     41.57            -5.8       35.76 ±  2%  mpstat.cpu.all.idle%
     20.32           +25.1       45.43 ±  2%  mpstat.cpu.all.iowait%
      6.25 ±  4%      -2.2        4.09 ±  6%  mpstat.cpu.all.irq%
      0.34 ±  4%      -0.2        0.14 ±  6%  mpstat.cpu.all.soft%
     28.91           -15.5       13.40 ±  6%  mpstat.cpu.all.sys%
      2.62            -1.4        1.17 ±  6%  mpstat.cpu.all.usr%
     18.83 ±  5%     -84.1%       3.00        mpstat.max_utilization.seconds
     61.41           -30.1%      42.94        mpstat.max_utilization_pct
 3.455e+08           -41.9%  2.006e+08 ±  4%  stress-ng.io-uring.ops
   5758736           -41.9%    3343243 ±  4%  stress-ng.io-uring.ops_per_sec
  63485668           -85.7%    9052788 ± 15%  stress-ng.time.involuntary_context_switches
     86971            -2.2%      85030        stress-ng.time.minor_page_faults
      6021           -54.8%       2724 ±  6%  stress-ng.time.percent_of_cpu_this_job_got
      3383           -53.8%       1562 ±  6%  stress-ng.time.system_time
    248.17           -67.3%      81.18 ±  9%  stress-ng.time.user_time
 4.227e+08           -40.1%  2.531e+08 ±  4%  stress-ng.time.voluntary_context_switches
   2888857 ±  2%      -8.1%    2654260        proc-vmstat.nr_active_anon
    302955            -3.1%     293576        proc-vmstat.nr_anon_pages
   3475920 ±  2%      -6.5%    3250878        proc-vmstat.nr_file_pages
     44207            -3.1%      42858        proc-vmstat.nr_kernel_stack
    255933 ±  3%     -30.6%     177546        proc-vmstat.nr_mapped
   2586684 ±  3%      -8.7%    2361525        proc-vmstat.nr_shmem
     43152            -1.5%      42518        proc-vmstat.nr_slab_reclaimable
   2888857 ±  2%      -8.1%    2654260        proc-vmstat.nr_zone_active_anon
  35939101           -37.7%   22399100 ±  3%  proc-vmstat.numa_hit
  35741003           -37.9%   22200912 ±  3%  proc-vmstat.numa_local
    585759 ±  5%     -27.5%     424436 ±  8%  proc-vmstat.numa_pte_updates
  36196152           -37.5%   22624491 ±  3%  proc-vmstat.pgalloc_normal
    700860 ±  3%      -7.0%     651538 ±  4%  proc-vmstat.pgfault
  32134448           -41.1%   18939637 ±  4%  proc-vmstat.pgfree
  16707904           -77.5%    3755057 ± 10%  proc-vmstat.unevictable_pgs_culled
      0.17 ±  4%     +94.3%       0.32 ± 16%  perf-stat.i.MPKI
 2.698e+10           -40.1%  1.616e+10 ±  4%  perf-stat.i.branch-instructions
      0.92            -0.3        0.64        perf-stat.i.branch-miss-rate%
 2.173e+08           -57.1%   93142321 ±  5%  perf-stat.i.branch-misses
      2.25 ±  4%      +6.4        8.67 ± 17%  perf-stat.i.cache-miss-rate%
 1.262e+09           -68.8%   3.94e+08 ±  6%  perf-stat.i.cache-references
  13218006           -37.6%    8252620 ±  4%  perf-stat.i.context-switches
      3.40            -7.5%       3.15 ±  3%  perf-stat.i.cpi
 4.003e+11           -40.4%  2.384e+11 ±  5%  perf-stat.i.cpu-cycles
   5382764           -76.2%    1281759 ± 10%  perf-stat.i.cpu-migrations
     32980 ±  5%     -25.9%      24437 ±  9%  perf-stat.i.cycles-between-cache-misses
 1.327e+11           -39.9%  7.973e+10 ±  4%  perf-stat.i.instructions
      0.33            +9.9%       0.36 ±  3%  perf-stat.i.ipc
     96.88           -48.8%      49.64 ±  4%  perf-stat.i.metric.K/sec
      8872 ±  4%     -11.6%       7844 ±  4%  perf-stat.i.minor-faults
      8872 ±  4%     -11.6%       7844 ±  4%  perf-stat.i.page-faults
      0.18 ±  3%     +61.7%       0.29 ±  8%  perf-stat.overall.MPKI
      0.81            -0.2        0.58        perf-stat.overall.branch-miss-rate%
      1.88 ±  3%      +4.0        5.86 ±  9%  perf-stat.overall.cache-miss-rate%
     16903 ±  3%     -38.3%      10426 ±  9%  perf-stat.overall.cycles-between-cache-misses
 2.655e+10           -40.1%   1.59e+10 ±  4%  perf-stat.ps.branch-instructions
 2.138e+08           -57.2%   91585587 ±  5%  perf-stat.ps.branch-misses
 1.241e+09           -68.8%  3.875e+08 ±  6%  perf-stat.ps.cache-references
  13003285           -37.6%    8120099 ±  4%  perf-stat.ps.context-switches
 3.938e+11           -40.5%  2.345e+11 ±  5%  perf-stat.ps.cpu-cycles
   5295095           -76.2%    1259803 ± 10%  perf-stat.ps.cpu-migrations
 1.306e+11           -39.9%  7.846e+10 ±  4%  perf-stat.ps.instructions
      8714 ±  4%     -11.7%       7694 ±  4%  perf-stat.ps.minor-faults
      8714 ±  4%     -11.7%       7694 ±  4%  perf-stat.ps.page-faults
 8.049e+12           -40.0%  4.829e+12 ±  4%  perf-stat.total.instructions
    879267 ±  3%     -77.4%     198767 ± 46%  sched_debug.cfs_rq:/.avg_vruntime.avg
   2197261 ±  7%     -80.3%     433455 ± 40%  sched_debug.cfs_rq:/.avg_vruntime.max
    702597 ±  3%     -82.0%     126663 ± 48%  sched_debug.cfs_rq:/.avg_vruntime.min
    144651 ±  9%     -75.7%      35081 ± 36%  sched_debug.cfs_rq:/.avg_vruntime.stddev
      0.38 ±  7%     -79.6%       0.08 ± 20%  sched_debug.cfs_rq:/.h_nr_queued.avg
      2.92 ± 20%     -65.7%       1.00        sched_debug.cfs_rq:/.h_nr_queued.max
      0.61 ±  4%     -57.2%       0.26 ±  9%  sched_debug.cfs_rq:/.h_nr_queued.stddev
      0.34 ±  6%     -77.5%       0.08 ± 19%  sched_debug.cfs_rq:/.h_nr_runnable.avg
      2.92 ± 20%     -65.7%       1.00        sched_debug.cfs_rq:/.h_nr_runnable.max
      0.56 ±  5%     -53.3%       0.26 ±  9%  sched_debug.cfs_rq:/.h_nr_runnable.stddev
    115895 ± 14%     -93.3%       7740 ± 69%  sched_debug.cfs_rq:/.left_deadline.avg
   1148129 ± 31%     -77.7%     255916 ± 52%  sched_debug.cfs_rq:/.left_deadline.max
    300169 ±  8%     -87.0%      39025 ± 54%  sched_debug.cfs_rq:/.left_deadline.stddev
    115876 ± 14%     -93.3%       7740 ± 69%  sched_debug.cfs_rq:/.left_vruntime.avg
   1147975 ± 31%     -77.7%     255883 ± 52%  sched_debug.cfs_rq:/.left_vruntime.max
    300120 ±  8%     -87.0%      39021 ± 54%  sched_debug.cfs_rq:/.left_vruntime.stddev
      2.08 ± 16%    -100.0%       0.00        sched_debug.cfs_rq:/.load_avg.min
    879267 ±  3%     -77.4%     198767 ± 46%  sched_debug.cfs_rq:/.min_vruntime.avg
   2197261 ±  7%     -80.3%     433455 ± 40%  sched_debug.cfs_rq:/.min_vruntime.max
    702597 ±  3%     -82.0%     126663 ± 48%  sched_debug.cfs_rq:/.min_vruntime.min
    144651 ±  9%     -75.7%      35081 ± 36%  sched_debug.cfs_rq:/.min_vruntime.stddev
      0.24 ±  5%     -67.9%       0.08 ± 19%  sched_debug.cfs_rq:/.nr_queued.avg
      0.36           -27.4%       0.26 ±  9%  sched_debug.cfs_rq:/.nr_queued.stddev
    115876 ± 14%     -93.3%       7740 ± 69%  sched_debug.cfs_rq:/.right_vruntime.avg
   1147975 ± 31%     -77.7%     255883 ± 52%  sched_debug.cfs_rq:/.right_vruntime.max
    300120 ±  8%     -87.0%      39021 ± 54%  sched_debug.cfs_rq:/.right_vruntime.stddev
    293.31 ±  2%     -61.0%     114.35 ± 10%  sched_debug.cfs_rq:/.runnable_avg.avg
    114.75 ±  6%    -100.0%       0.00        sched_debug.cfs_rq:/.runnable_avg.min
    161.40 ±  3%     +16.8%     188.44 ±  6%  sched_debug.cfs_rq:/.runnable_avg.stddev
    243.06 ±  2%     -53.0%     114.20 ± 10%  sched_debug.cfs_rq:/.util_avg.avg
    111.42 ±  5%    -100.0%       0.00        sched_debug.cfs_rq:/.util_avg.min
    143.53 ±  4%     +31.2%     188.36 ±  6%  sched_debug.cfs_rq:/.util_avg.stddev
     45.14 ±  5%     -53.8%      20.87 ± 29%  sched_debug.cfs_rq:/.util_est.avg
    117.16 ±  9%     -23.3%      89.81 ± 15%  sched_debug.cfs_rq:/.util_est.stddev
    460889           +78.9%     824600 ±  4%  sched_debug.cpu.avg_idle.avg
    545161 ±  4%     +83.4%    1000000        sched_debug.cpu.avg_idle.max
      7815 ±  7%     -47.7%       4084 ± 14%  sched_debug.cpu.avg_idle.min
     96234 ±  8%    +192.4%     281404 ± 13%  sched_debug.cpu.avg_idle.stddev
    754.64 ±  5%     -19.2%     609.61 ±  9%  sched_debug.cpu.clock_task.stddev
      1016 ±  7%     -74.3%     261.72 ± 25%  sched_debug.cpu.curr->pid.avg
      1648           -37.6%       1027 ± 14%  sched_debug.cpu.curr->pid.stddev
      0.00 ± 24%     -27.7%       0.00 ± 10%  sched_debug.cpu.next_balance.stddev
      0.35 ± 10%     -82.5%       0.06 ± 20%  sched_debug.cpu.nr_running.avg
      2.92 ± 20%     -65.7%       1.00        sched_debug.cpu.nr_running.max
      0.60 ±  6%     -61.0%       0.23 ±  8%  sched_debug.cpu.nr_running.stddev
   2060126           -47.9%    1073009 ± 44%  sched_debug.cpu.nr_switches.avg
   2688437           -31.6%    1839609 ± 44%  sched_debug.cpu.nr_switches.max
    650892 ±  9%     -43.0%     370926 ± 54%  sched_debug.cpu.nr_switches.min
    522908 ±  2%     -49.9%     261974 ± 45%  sched_debug.cpu.nr_switches.stddev




Disclaimer:
Results have been estimated based on internal Intel analysis and are provided
for informational purposes only. Any difference in system hardware or software
design or configuration may affect actual performance.


-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


