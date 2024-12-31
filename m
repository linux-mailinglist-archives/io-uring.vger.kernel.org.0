Return-Path: <io-uring+bounces-5644-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 90FE39FED50
	for <lists+io-uring@lfdr.de>; Tue, 31 Dec 2024 07:37:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DFC791882D88
	for <lists+io-uring@lfdr.de>; Tue, 31 Dec 2024 06:37:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C43D186E27;
	Tue, 31 Dec 2024 06:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kWwRvsRH"
X-Original-To: io-uring@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22DF115573F
	for <io-uring@vger.kernel.org>; Tue, 31 Dec 2024 06:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735627025; cv=fail; b=t28rK0IQWaH2boSqK7tTkrEK0iX3gE8OpyARDHO7GGOp+1+u62ygUJ4pADzQRO/mQK6cfULPUgzOVJU0btRYroRHn6+N+i6McJ8PHjynnKC2uoxidhCZ1wJt6uGwflTfzCWLcu5gNTqhLyjZmDFVazUWaEBBy9FmvyJfYmEXY8M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735627025; c=relaxed/simple;
	bh=BXxQOy/smV2l/YX7HhIVZfNB9ILysX7ufV/GTlSZ254=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=rpGwDMiW7l1SJqpbwo4ptaWbW3u4z8C3489Jk9fU0axDIBhsNV2wbNrcSlTTh1S/xqWC1tjc98n5pwLkaCkKSANQClqGYQhdepGWhY8V5QmdMQwBecpUT/v2G0ORcZCL709koZXOImXY5HnjoTB7G/kKRpYv0NEduMqosB/FpO4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kWwRvsRH; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1735627022; x=1767163022;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=BXxQOy/smV2l/YX7HhIVZfNB9ILysX7ufV/GTlSZ254=;
  b=kWwRvsRHUCKZWs0na3v4mnZzyMRPbWoFX546rZI5w5QmVUer0/a8PTvV
   FAtx6jT62yoGe0clEZNhgoMe1cWvnt67wsQF8QwMaojo3kXRRBOneqLuR
   chrwN2h0I4Xjj57rCgZofDPQCmTN6BlxStDWEWlJ5YXu6CJ5+InhpehMS
   OXyVljKUFm1z35H/QYMyE98bw+Khsi5gbtikXKGZQtFkaqcYpMiEgvNo9
   gk4YaVK6QmtiIb35mBevnBYHis6R1exKHZ7tUfG/xuKb7jQmMCMZuPfIQ
   GBusJu/I71IWakfx/96TqiLVqhwjG5W4DpzmBLK5Fka2GBuTv7r/4ypiy
   g==;
X-CSE-ConnectionGUID: mSejtt6AQoG15s1E/nRzPA==
X-CSE-MsgGUID: QvaD2KuSQzGv7cbAn5aNpg==
X-IronPort-AV: E=McAfee;i="6700,10204,11301"; a="23500652"
X-IronPort-AV: E=Sophos;i="6.12,278,1728975600"; 
   d="scan'208";a="23500652"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Dec 2024 22:36:59 -0800
X-CSE-ConnectionGUID: DWAPWuRFSWe/gWP5ROJhhA==
X-CSE-MsgGUID: G3rpoDdBS5ivzXXE1inj4A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="105985836"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 30 Dec 2024 22:36:59 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Mon, 30 Dec 2024 22:36:58 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Mon, 30 Dec 2024 22:36:58 -0800
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.42) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 30 Dec 2024 22:36:58 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=k0LgfOTYrnKjJubld65lgkZOJxlx6HVrbMHdnp5IM/DoIm43zD2UjqXsK7STs3WVpY+mabcXQL1COITWwpybTqb7alcobisaKUx8iJU/1qOGm10KCtcmBQs1ybxS6jDy4tlnr5I5A5cP8zW11+zVKyKO/Vs7Oi295P0wwP3Hzw62lP2VY3GvhUw7FJXHGBKOryJtPk/IvWiugBNd7KzlnLypo7524xsLD55INhBkE7YQx1D1lWKxqFlIzVEyqqQftBZkykL1ZTAg5e0CJb6hqmfQxDSAZBajn6pXjyglyd05E5olE0ycmIocd30iAc5bY4f/5XEdRX7dzi5iz6H/Kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PTItuo53L8CIYK6UVEDGbKtWAaqKW+FPVstKdtgabIE=;
 b=G/NNrtTd+VbadCj9dP8RF4zh8qjnQw9q9NzeUvawpKuyr+YcRwzox71LpzROewzoPmuFdSnwyy8KwDqu/TTlHjiCuSdVX+cRc+FbzPwg/Q64fnPif4PZkJR/qTh9HeD6PFdIsBUqXzcbO5WYjASGmFHTzZ29298XbvKulprooexLO8alT1ifhr0FiM80KnDdf1FW1RZ+WAlQ9b8wMJFoYuLePqw8mzRCNyao1hSXSLeOT7cnOhuv5ftDpulvKoz/Ngf4YveAv35KZPJrVJRUt/7Ybjro3LxeqpDfljC5XpmO/ZSLkMFUEa9Ec32r2Yat7j3glGEplRTm7ctUsDuBSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by SJ1PR11MB6203.namprd11.prod.outlook.com (2603:10b6:a03:45a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8293.19; Tue, 31 Dec
 2024 06:36:51 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c%6]) with mapi id 15.20.8293.000; Tue, 31 Dec 2024
 06:36:51 +0000
Date: Tue, 31 Dec 2024 14:36:42 +0800
From: Oliver Sang <oliver.sang@intel.com>
To: Jens Axboe <axboe@kernel.dk>
CC: Gabriel Krisman Bertazi <krisman@suse.de>, <oe-lkp@lists.linux.dev>,
	<lkp@intel.com>, <io-uring@vger.kernel.org>, <oliver.sang@intel.com>
Subject: Re: [linux-next:master] [io_uring/rw] 8cf0c45999: fio.read_bw_MBps
 51.1% regression
Message-ID: <Z3OQ+u4LSZd7CWY8@xsang-OptiPlex-9020>
References: <202412271132.a09c3500-lkp@intel.com>
 <98fc1d1e-2b39-4628-a209-a76407130f6c@kernel.dk>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <98fc1d1e-2b39-4628-a209-a76407130f6c@kernel.dk>
X-ClientProxiedBy: SG2P153CA0020.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c7::7)
 To LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|SJ1PR11MB6203:EE_
X-MS-Office365-Filtering-Correlation-Id: 8c8dd2f2-234f-4b91-0201-08dd29658247
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?cRiC0hg0Gu/EJA5CCHAvGn0DX/Q9nqnv5Gfjp1MmyggJvPb7ZDiYrtdvNp?=
 =?iso-8859-1?Q?5SmI8f7HuB0KbpfiMylHEAbD/UZGv0n5i8MTeOaMBO4Yj5qbE+gy6XHW5g?=
 =?iso-8859-1?Q?D6or6g40+eBCQ7l7GMyX7QzpTpr1KkjW9Rn582WdaqZx8mUa84u9NyYK+w?=
 =?iso-8859-1?Q?HC3UcfUGKCBH6i/GsnXKvhs33lK/15vomRB7gLket2LhzNLfXuL9K2/fkD?=
 =?iso-8859-1?Q?JpCHy8qEjUCWR0+YmuTJ6puU5t+YH7vBFDCVHn0mW2cD6O7mXNw2LDuMXf?=
 =?iso-8859-1?Q?fU5AMLPJumhV3Ex+pI4fS5KRacyWRIvpOGOn2SI84somKAeUpgkf6CE9Zt?=
 =?iso-8859-1?Q?s1M0ehf6avCrzFhNalv38cIPz5KO2/6xEffr8bW88tvc5pNuJvmgJ/mt4X?=
 =?iso-8859-1?Q?mWMEMdJLmoJW+vfT8VgSVCE/UcdWY8bfuquBUvg7T/wdiVUqD9dGcycWEn?=
 =?iso-8859-1?Q?vU3ewkvyOL9MeQoKxprhzTd299mpQlqqmhEF9SWKtNPJ6DcCsxt+51qDW/?=
 =?iso-8859-1?Q?+l9ave9U8X57tkfEowRj3L+cfl49/Lhmwp2E2SXoWJAhiFZIFfWhd7LfSJ?=
 =?iso-8859-1?Q?kPJ3LSHed2Glccvb3fGTIxEm3OwLTG4pqV8/L+j5JEvjHuC+Cs062NZ4rF?=
 =?iso-8859-1?Q?YAg5f4EMEMRhiI2Bk5SSEtRgW3ulcSjWhV7jEHsRemQqCEHjM6dDSiTfYq?=
 =?iso-8859-1?Q?lyKW0Z9gYvik0rHu3EGMh6C/3+4pHAq6SH1es/2PC1btYjB8oEaWMY70FE?=
 =?iso-8859-1?Q?iE0j+mpUsdxP9M11xHR0fyArCquOVKEiUDGeakRhGMaXRPPFrvrh1BbJJV?=
 =?iso-8859-1?Q?9a44UNpjgf5nn0QLEVrpC2UgisQ+jdmviQjcGilxP3zxC7QTDyEqOpyy3e?=
 =?iso-8859-1?Q?9xT9fQnaZzBTnVh8DqaCg47t8BN8qCmImZoYbN02apkCtLAaHkP/5FWR17?=
 =?iso-8859-1?Q?9Q0xQkTbPyEUohYmkiLjTsTROTHOovrPlr7GLqFSLEeSBpIcUE/gQPXRZt?=
 =?iso-8859-1?Q?+6M0RYZVMPyEMtVgt35zSNmHbv1adKlsdH2Ce5VkymdpxESrdiiMl628sT?=
 =?iso-8859-1?Q?A1mlDC9NmLjCPAlJf7MeRYWVnEjX7yYSx0I9o27aG+rsXMYLu8U476J6Th?=
 =?iso-8859-1?Q?plkTowkjaQ7T4CjYEOl13t5blG19yJ+JaXthnGZs1PN1hKLByAgFqeAjRd?=
 =?iso-8859-1?Q?UuIrZWGHBF3W8itE3IMa22S+vkHEmrmRX6soDDz0c8PZanr3o9YwcD2qMX?=
 =?iso-8859-1?Q?1A93NGTAsKRc8kzAUyOo0OQUQUO5dknjErg60oNUCC/H4SrDWz/TjCpJZd?=
 =?iso-8859-1?Q?jafNwEd+hcLfabiJEsYX1Qcw7mBOWRV7HUyzGnolPtedv1/sXJM+S7ZHG9?=
 =?iso-8859-1?Q?13iQKTe32O/OQoUWQrnnptHSJdb8cFPY8L1AOILo1Xo/z2EUW9b4GeXncQ?=
 =?iso-8859-1?Q?VHMGJJbL371xxdec?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?aleuUT3Rx95QCC0Z5xM01GEQZmTty6ZVwlpOCL0+mR3oBwObE3WXe6opWa?=
 =?iso-8859-1?Q?MY8E+KETiEYsjCa1e1vFZuR9OwL4bLSUxQ12qrkeWcz1Y3D/B1IVsrPhyw?=
 =?iso-8859-1?Q?ZCJaZxLzhfeXmwnPeiA+Z23pMNJJZPwyhcrWLd21/0CKF6767cnViQ8cPd?=
 =?iso-8859-1?Q?oiJe4kMn91hPKC/M6YY43r5lGe3f0p1CjsHvIKI2Rt0XlWdM0flN8QtZAg?=
 =?iso-8859-1?Q?MKSXl1yhWNdfp81JtumCgnkP7qgr8PKp6Sc5N1oxvG2IG+u47Xk6rNv27p?=
 =?iso-8859-1?Q?0gUvYwmOF/U4Am6jCHChLC8Hft2M5gqJkf6BzpWKORpDbwXi/K/3qpba0g?=
 =?iso-8859-1?Q?5VtKhvEyH6ub4fZjPVpnKR+LJMejQoBSLr8xl2eK8T5bEu/k8xPij9K4L4?=
 =?iso-8859-1?Q?PLBE0+23M1Nvl82aBG0wuNw8wMufy+Ne3APJrVpleZrB7GtkBee9wUeJha?=
 =?iso-8859-1?Q?gJI5e91fof/FWisTa3xp9wpwWsx0QXISvggeWLhNLMJlNfJuI+R0sFCKGY?=
 =?iso-8859-1?Q?PH4q1HHlFMXDL3LsFEQRrDw5Hzz+J/IsIzPAGsJqniFZURAIIBZn4LW46i?=
 =?iso-8859-1?Q?L4jd+h+wkQOU0d8vEUJIHFWTNq71UYBqyPlgALM5Et1+YeBzZMyG+fymK4?=
 =?iso-8859-1?Q?8Rwk0G8BlEuvOCJt4D5gGZSja45mAkx1PW/Dlm9N6235LjqpeJwVXbR3IT?=
 =?iso-8859-1?Q?l5f8fenqyKZ0qpBBmYFqBu5jFedSI9rBCmIio4zXHlKF0vDv7unoIflQP+?=
 =?iso-8859-1?Q?dtGp4VReBosPrxZBUki5YUSJM5oiTPLKOcHtgYIUO6Nu8JlVRGAOxnL0Tx?=
 =?iso-8859-1?Q?ormeaPsPYN5ce6m33M5myqHzUxDkeZGZ1m3uP8+6G9mAPa9zIWjXrAU/VD?=
 =?iso-8859-1?Q?MMlpJ0kw/0XxItSs4z95gaWS58lYDiZATq9vyhKi6zRJbfBO5LwhfB4t5/?=
 =?iso-8859-1?Q?+jXv1reRh4FFfQb/EqmNn81Y/V6YB+fKzMSeRIADPqyXhSVJXLW/QL2lCn?=
 =?iso-8859-1?Q?rY7aeTeihmjkZHJ4yY+spQjIYV5gZWp6/MQtIJgsGaADKQKBwrS/DwrP52?=
 =?iso-8859-1?Q?V7Fj1S87XXrka7RR4tQ0aMNT7gYyk0yFBnSXSZdngfz0BoJDFLr3CV8lvy?=
 =?iso-8859-1?Q?H1wxl3QJPS9fOJtk7RvHOen1gqz0Elb4QIRGT1bJlSSJK+nZd5UNW25ERE?=
 =?iso-8859-1?Q?i1OzE/U0LAm9lby6cojnJbu5yPj3qlQMB9FF5gzqWVcl60lcWHJuX9yQjA?=
 =?iso-8859-1?Q?/A/2O3AgR8qH8+bSaPvEiGf1rjNtJHlmyXCu9gXDZDR/ellwBvK71tHAnE?=
 =?iso-8859-1?Q?kS4vVxowQovtMwyTgH7/mo4wwaVPryoJW0VTXyhyBlmTw+pGxY+em0zF+V?=
 =?iso-8859-1?Q?bffzlffntio+XmNmDnr6FmSbLyefQpp5U1SVuAikXv/vTh/8DGp4wAUTQf?=
 =?iso-8859-1?Q?ilaQehiVbqEnmVJOSjWLyPXQrAkXUSzkrZQ5Bni2r7f4OECKOTMSzTIOpH?=
 =?iso-8859-1?Q?ReVMH86LV08l046LcTJbkJbv5JBjwji7nQUwV63YJm2Bn2GvuA+41QfRCq?=
 =?iso-8859-1?Q?fZbp935kf1ZwZFxiVFlJhwSpc6zMevZoykJPgER//b+x8DDDzumsGm0pW6?=
 =?iso-8859-1?Q?MSegPCGkJFXXsL7Vo3bkanfUL980f5dDMPadWDPFuqz4psCapZSht4ow?=
 =?iso-8859-1?Q?=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c8dd2f2-234f-4b91-0201-08dd29658247
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Dec 2024 06:36:51.4518
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bDiQVfd3xnAgFnzbHTqpQxbuk0yxMsiPQEL3sf6a8vOJJtLjTVYXUb8SkRXdtvhG7SpSDzsnHI8ZZxSUZKHbFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR11MB6203
X-OriginatorOrg: intel.com

hi, Jens Axboe,

On Fri, Dec 27, 2024 at 09:48:58AM -0700, Jens Axboe wrote:
> On 12/26/24 8:13 PM, kernel test robot wrote:
> > 
> > 
> > Hello,
> > 
> > kernel test robot noticed a 51.1% regression of fio.read_bw_MBps on:
> > 
> > 
> > commit: 8cf0c459993ee2911f4f01fba21b1987b102c887 ("io_uring/rw: Allocate async data through helper")
> > https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git master
> > 
> > [test failed on linux-next/master 8155b4ef3466f0e289e8fcc9e6e62f3f4dceeac2]
> 
> Took a quick look, and I think that patch forgets to clear ->bytes_done
> when we don't have a free_iovec. That looks like a mistake, it should
> always get cleared, it has no dependence on ->free_iovec.

below patch recover the performance fully. thanks!

Tested-by: kernel test robot <oliver.sang@intel.com>

=========================================================================================
bs/compiler/cpufreq_governor/disk/fs/ioengine/kconfig/nr_task/rootfs/runtime/rw/tbox_group/test_size/testcase:
  2M/gcc-12/performance/1SSD/xfs/io_uring/x86_64-rhel-9.4/8t/debian-12-x86_64-20240206.cgz/300s/read/lkp-csl-2sp3/256g/fio-basic

commit: 
  23d91035ca ("io_uring/net: Allocate msghdr async data through helper")
  8cf0c45999 ("io_uring/rw: Allocate async data through helper")
  605f6d311e  <---- your patch

23d91035cafa30d1 8cf0c459993ee2911f4f01fba21 605f6d311ea47324304d60dd32a
---------------- --------------------------- ---------------------------
         %stddev     %change         %stddev     %change         %stddev
             \          |                \          |                \
      2171           -51.1%       1060 ±  3%      +0.2%       2174        fio.read_bw_MBps

full comparison as below [1] FYI


> 
> diff --git a/io_uring/rw.c b/io_uring/rw.c
> index 75f70935ccf4..ca1b19d3d142 100644
> --- a/io_uring/rw.c
> +++ b/io_uring/rw.c
> @@ -228,8 +228,8 @@ static int io_rw_alloc_async(struct io_kiocb *req)
>  		kasan_mempool_unpoison_object(rw->free_iovec,
>  					      rw->free_iov_nr * sizeof(struct iovec));
>  		req->flags |= REQ_F_NEED_CLEANUP;
> -		rw->bytes_done = 0;
>  	}
> +	rw->bytes_done = 0;
>  	return 0;
>  }
>  
> 
> -- 
> Jens Axboe

[1]
=========================================================================================
bs/compiler/cpufreq_governor/disk/fs/ioengine/kconfig/nr_task/rootfs/runtime/rw/tbox_group/test_size/testcase:
  2M/gcc-12/performance/1SSD/xfs/io_uring/x86_64-rhel-9.4/8t/debian-12-x86_64-20240206.cgz/300s/read/lkp-csl-2sp3/256g/fio-basic

commit: 
  23d91035ca ("io_uring/net: Allocate msghdr async data through helper")
  8cf0c45999 ("io_uring/rw: Allocate async data through helper")
  605f6d311e  <---- your patch

23d91035cafa30d1 8cf0c459993ee2911f4f01fba21 605f6d311ea47324304d60dd32a
---------------- --------------------------- ---------------------------
         %stddev     %change         %stddev     %change         %stddev
             \          |                \          |                \
 1.169e+10           -97.9%  2.464e+08 ±  4%      -0.9%  1.158e+10        cpuidle..time
   4187672 ±  5%     -98.3%      69610            +1.4%    4247402 ±  3%  cpuidle..usage
    490.00           -24.5%     370.16            +0.2%     491.13        uptime.boot
     45002           -23.4%      34483            +0.2%      45104        uptime.idle
     91.67            +3.9%      95.24            -0.1%      91.56        iostat.cpu.idle
      6.67           -83.6%       1.09 ±  2%      +0.6%       6.71        iostat.cpu.iowait
      0.15 ±  3%   +1569.3%       2.51 ±  5%      +3.2%       0.16 ±  2%  iostat.cpu.user
      6.77 ±  2%      -5.2        1.52 ±  4%      +0.0        6.81        mpstat.cpu.all.iowait%
      0.03 ± 22%      +0.0        0.05 ± 18%      -0.0        0.03 ± 24%  mpstat.cpu.all.soft%
      0.15 ±  4%      +4.1        4.23 ±  6%      +0.0        0.15 ±  2%  mpstat.cpu.all.usr%
   5982113 ± 42%     -97.3%     160513 ± 30%      -4.7%    5699677 ± 47%  numa-numastat.node0.local_node
   6032931 ± 41%     -96.5%     209090 ± 13%      -4.6%    5755952 ± 47%  numa-numastat.node0.numa_hit
   2662250 ±124%     -94.1%     155780 ± 31%     -33.0%    1783404 ±162%  numa-numastat.node1.local_node
   2710984 ±121%     -92.4%     206648 ± 13%     -32.5%    1829467 ±159%  numa-numastat.node1.numa_hit
   2142706           -87.8%     262066            +0.6%    2156601        vmstat.io.bi
     62.03         +2998.4%       1922            +0.0%      62.04        vmstat.io.bo
      6.47 ±  3%    -100.0%       0.00            +0.3%       6.49        vmstat.procs.b
      2.69 ± 12%    +173.1%       7.33 ±  8%      +2.8%       2.76 ±  9%  vmstat.procs.r
     19637           -46.7%      10473 ±  4%      +0.3%      19702        vmstat.system.cs
     34417 ±  3%     -10.8%      30715 ±  2%      +1.8%      35043 ±  3%  vmstat.system.in
    121.24           -99.2%       0.96 ±  6%      -0.2%     120.98        time.elapsed_time
    121.24           -99.2%       0.96 ±  6%      -0.2%     120.98        time.elapsed_time.max
 5.369e+08           -99.6%    2096533            +0.0%   5.37e+08        time.file_system_inputs
    340.33 ±  6%     -53.7%     157.67 ±  9%      +2.3%     348.20 ±  7%  time.involuntary_context_switches
      8592 ±  3%     -10.2%       7716            +0.1%       8598 ±  4%  time.minor_page_faults
     89.00 ±  4%    +587.6%     612.00 ±  6%      -2.8%      86.50 ±  3%  time.percent_of_cpu_this_job_got
    102.38 ±  4%     -99.6%       0.44 ±  2%      -3.3%      98.96 ±  3%  time.system_time
   1101885           -99.6%       4454            -0.3%    1098618        time.voluntary_context_switches
      2.37 ± 49%      -2.1        0.26 ±103%      +0.8        3.16 ± 26%  fio.latency_100ms%
     81.78 ±  3%     -56.2       25.56 ± 29%      -0.5       81.27 ±  5%  fio.latency_250ms%
      0.34 ± 66%      -0.3        0.00            +0.6        0.94 ± 54%  fio.latency_50ms%
      2171           -51.1%       1060 ±  3%      +0.2%       2174        fio.read_bw_MBps
 4.194e+08           -14.2%    3.6e+08 ±  5%      +8.0%   4.53e+08 ± 11%  fio.read_clat_99%_ns
    121.24           -99.2%       0.96 ±  6%      -0.2%     120.98        fio.time.elapsed_time
    121.24           -99.2%       0.96 ±  6%      -0.2%     120.98        fio.time.elapsed_time.max
 5.369e+08           -99.6%    2096533            +0.0%   5.37e+08        fio.time.file_system_inputs
      8592 ±  3%     -10.2%       7716            +0.1%       8598 ±  4%  fio.time.minor_page_faults
     89.00 ±  4%    +587.6%     612.00 ±  6%      -2.8%      86.50 ±  3%  fio.time.percent_of_cpu_this_job_got
    102.38 ±  4%     -99.6%       0.44 ±  2%      -3.3%      98.96 ±  3%  fio.time.system_time
   1101885           -99.6%       4454            -0.3%    1098618        fio.time.voluntary_context_switches
    131072           -99.6%     510.83            +0.0%     131072        fio.workload
   6857403 ± 71%    -100.0%       0.00           +19.9%    8220508 ± 50%  numa-meminfo.node0.Active(file)
  49781569 ± 10%     -98.0%     971701 ±119%      +2.0%   50763968 ± 10%  numa-meminfo.node0.FilePages
  42007683 ±  4%     -99.4%     232792 ± 70%      -2.9%   40784060 ±  5%  numa-meminfo.node0.Inactive
  41773509 ±  4%     -99.4%     232792 ± 70%      -2.9%   40541517 ±  5%  numa-meminfo.node0.Inactive(file)
    181744 ± 10%     -80.2%      36054 ± 50%      +5.2%     191237 ± 11%  numa-meminfo.node0.KReclaimable
  11216992 ± 48%    +440.7%   60655275           -10.4%   10049266 ± 55%  numa-meminfo.node0.MemFree
  54456267 ±  9%     -90.8%    5017984 ± 22%      +2.1%   55623993 ±  9%  numa-meminfo.node0.MemUsed
    181744 ± 10%     -80.2%      36054 ± 50%      +5.2%     191237 ± 11%  numa-meminfo.node0.SReclaimable
     11353 ± 48%     -50.3%       5640 ±  9%      -9.8%      10245 ± 60%  numa-meminfo.node0.Shmem
  46742560 ± 10%     -93.7%    2968006 ± 39%      -2.4%   45597696 ± 11%  numa-meminfo.node1.FilePages
  44279309 ± 12%     -99.7%     116761 ±141%      -0.7%   43985860 ± 12%  numa-meminfo.node1.Inactive
  44279309 ± 12%     -99.7%     116761 ±141%      -0.7%   43985860 ± 12%  numa-meminfo.node1.Inactive(file)
    222588 ±  9%     -71.5%      63492 ± 29%      -5.5%     210385 ± 10%  numa-meminfo.node1.KReclaimable
  17706281 ± 29%    +248.8%   61765996            +7.6%   19054511 ± 28%  numa-meminfo.node1.MemFree
  48294686 ± 10%     -91.2%    4234972 ± 26%      -2.8%   46946456 ± 11%  numa-meminfo.node1.MemUsed
    222588 ±  9%     -71.5%      63492 ± 29%      -5.5%     210385 ± 10%  numa-meminfo.node1.SReclaimable
     19553 ± 30%     -91.4%       1688 ± 29%      +4.2%      20377 ± 31%  numa-meminfo.node1.Shmem
    484021 ± 22%     -54.2%     221920 ± 54%     -15.5%     408872 ± 16%  numa-meminfo.node1.Slab
   8292851 ± 60%     -91.7%     685299            +9.9%    9110413 ± 44%  meminfo.Active
    993491 ± 17%     -31.0%     685299            -1.3%     980308 ± 15%  meminfo.Active(anon)
   7299359 ± 70%    -100.0%       0.00           +11.4%    8130104 ± 51%  meminfo.Active(file)
   1059116 ±  3%     -57.9%     446122 ± 20%      -9.0%     963510 ± 10%  meminfo.AnonHugePages
   1199023           -43.1%     682106            -0.3%    1194992        meminfo.AnonPages
  96504886           -95.9%    3939272            -0.2%   96340575        meminfo.Cached
   1771531           -52.2%     846516 ±  3%      +0.2%    1774404        meminfo.Committed_AS
  85824229 ±  5%     -99.6%     349553            -1.1%   84838187 ±  4%  meminfo.Inactive
  85591704 ±  5%     -99.6%     349553            -1.2%   84596818 ±  4%  meminfo.Inactive(file)
    404111           -75.5%      99205            -0.7%     401394        meminfo.KReclaimable
     82199           -26.3%      60586            +0.4%      82511        meminfo.Mapped
  28942581 ±  2%    +323.0%  1.224e+08            +0.6%   29124721        meminfo.MemFree
 1.027e+08           -91.0%    9249647            -0.2%  1.025e+08        meminfo.Memused
      2432           -62.3%     917.33 ± 79%      +0.0%       2432 ±  3%  meminfo.Mlocked
    404111           -75.5%      99205            -0.7%     401394        meminfo.SReclaimable
    600546           -30.5%     417425            -0.1%     600233        meminfo.SUnreclaim
     30852 ±  2%     -77.6%       6905 ±  5%      -1.0%      30536        meminfo.Shmem
   1004658           -48.6%     516630            -0.3%    1001628        meminfo.Slab
 1.028e+08           -91.0%    9249647            -0.2%  1.026e+08        meminfo.max_used_kB
   1780344 ± 71%    -100.0%       0.00           +25.0%    2225468 ± 50%  numa-vmstat.node0.nr_active_file
  12441416 ± 10%     -98.0%     242939 ±119%      +2.0%   12690240 ± 10%  numa-vmstat.node0.nr_file_pages
   2808184 ± 48%    +440.0%   15163781           -10.5%    2513104 ± 55%  numa-vmstat.node0.nr_free_pages
  10373418 ±  5%     -99.4%      58198 ± 70%      -3.9%    9964288 ±  3%  numa-vmstat.node0.nr_inactive_file
      2830 ± 48%     -49.7%       1424 ±  8%      -9.6%       2559 ± 60%  numa-vmstat.node0.nr_shmem
     45390 ± 10%     -80.1%       9015 ± 50%      +5.3%      47791 ± 11%  numa-vmstat.node0.nr_slab_reclaimable
   1779467 ± 71%    -100.0%       0.00           +25.0%    2224367 ± 50%  numa-vmstat.node0.nr_zone_active_file
  10374301 ±  5%     -99.4%      58198 ± 70%      -3.9%    9965396 ±  3%  numa-vmstat.node0.nr_zone_inactive_file
   6032577 ± 41%     -96.5%     209022 ± 13%      -4.6%    5755362 ± 47%  numa-vmstat.node0.numa_hit
   5981759 ± 42%     -97.3%     160445 ± 30%      -4.7%    5699087 ± 47%  numa-vmstat.node0.numa_local
     60865 ± 46%    -100.0%       0.00           -16.8%      50609 ± 41%  numa-vmstat.node0.workingset_nodes
  11683973 ± 10%     -93.6%     742001 ± 39%      -2.4%   11401511 ± 11%  numa-vmstat.node1.nr_file_pages
   4428033 ± 29%    +248.7%   15441242            +7.5%    4761384 ± 28%  numa-vmstat.node1.nr_free_pages
  11068153 ± 12%     -99.7%      29190 ±141%      -0.6%   10998539 ± 12%  numa-vmstat.node1.nr_inactive_file
      4895 ± 30%     -91.4%     422.28 ± 29%      +4.3%       5107 ± 31%  numa-vmstat.node1.nr_shmem
     55624 ±  9%     -71.5%      15873 ± 29%      -5.4%      52619 ± 10%  numa-vmstat.node1.nr_slab_reclaimable
  11068150 ± 12%     -99.7%      29190 ±141%      -0.6%   10998535 ± 12%  numa-vmstat.node1.nr_zone_inactive_file
   2710384 ±121%     -92.4%     205957 ± 13%     -32.5%    1828924 ±159%  numa-vmstat.node1.numa_hit
   2661650 ±124%     -94.2%     155089 ± 31%     -33.0%    1782861 ±162%  numa-vmstat.node1.numa_local
     96303 ± 31%    -100.0%       0.00            +7.8%     103794 ± 21%  numa-vmstat.node1.workingset_nodes
     21.85 ± 22%     -95.7%       0.93 ±  9%      -6.2%      20.49 ± 21%  perf-stat.i.MPKI
 7.833e+08 ± 36%    +248.8%  2.733e+09           +11.1%  8.702e+08 ± 28%  perf-stat.i.branch-instructions
      1.20 ± 21%      +1.4        2.60            -0.1        1.11 ± 23%  perf-stat.i.branch-miss-rate%
  10294722 ±  8%    +588.8%   70910805            +1.9%   10489353 ±  5%  perf-stat.i.branch-misses
     71.04 ±  7%     -45.3       25.71 ±  6%      +1.9       72.95 ±  7%  perf-stat.i.cache-miss-rate%
  67179322 ± 23%     -82.0%   12088775 ±  8%      +7.8%   72424185 ± 18%  perf-stat.i.cache-misses
  92053950 ± 16%     -49.0%   46958614 ±  2%      +5.7%   97306974 ± 12%  perf-stat.i.cache-references
     19893           -57.6%       8444 ±  6%      +0.5%      19982        perf-stat.i.context-switches
      1.42 ± 18%     +47.0%       2.09 ±  6%      -3.7%       1.37 ± 21%  perf-stat.i.cpi
     96008            +3.1%      99012            -0.0%      96007        perf-stat.i.cpu-clock
 5.166e+09 ± 27%    +426.7%  2.721e+10 ±  5%      +9.2%  5.642e+09 ± 19%  perf-stat.i.cpu-cycles
    109.64          +297.0%     435.28 ± 26%      -0.2%     109.44        perf-stat.i.cpu-migrations
     95.02 ± 12%   +2287.2%       2268 ± 10%      -1.4%      93.64 ±  4%  perf-stat.i.cycles-between-cache-misses
 4.488e+09 ± 40%    +190.0%  1.301e+10           +12.3%  5.042e+09 ± 30%  perf-stat.i.instructions
      0.78 ± 18%     -38.5%       0.48 ±  6%      +4.8%       0.82 ± 17%  perf-stat.i.ipc
      3257         +2386.4%      81003 ±  2%      -0.3%       3248        perf-stat.i.minor-faults
      3257         +2386.3%      81001 ±  2%      -0.3%       3248        perf-stat.i.page-faults
     96008            +3.1%      99013            -0.0%      96007        perf-stat.i.task-clock
     16.77 ± 26%     -94.5%       0.93 ±  9%      -7.2%      15.57 ± 25%  perf-stat.overall.MPKI
      1.53 ± 39%      +1.1        2.60            -0.2        1.36 ± 39%  perf-stat.overall.branch-miss-rate%
     72.01 ±  8%     -46.3       25.71 ±  6%      +1.7       73.69 ±  8%  perf-stat.overall.cache-miss-rate%
      1.26 ± 22%     +66.0%       2.09 ±  6%      -4.2%       1.21 ± 23%  perf-stat.overall.cpi
     76.07 ±  5%   +2881.9%       2268 ± 10%      +2.2%      77.75        perf-stat.overall.cycles-between-cache-misses
      0.83 ± 18%     -42.0%       0.48 ±  6%      +4.4%       0.86 ± 17%  perf-stat.overall.ipc
   4201457 ± 40%    +507.2%   25510793           +10.9%    4661229 ± 30%  perf-stat.overall.path-length
 7.771e+08 ± 36%     +72.4%   1.34e+09           +11.1%  8.631e+08 ± 28%  perf-stat.ps.branch-instructions
  10227839 ±  8%    +239.9%   34759364            +1.8%   10413922 ±  5%  perf-stat.ps.branch-misses
  66623351 ± 23%     -91.1%    5924306 ±  8%      +7.8%   71821853 ± 18%  perf-stat.ps.cache-misses
  91293692 ± 16%     -74.8%   23018351 ±  2%      +5.7%   96498110 ± 12%  perf-stat.ps.cache-references
     19729           -79.0%       4140 ±  6%      +0.4%      19817        perf-stat.ps.context-switches
     95218           -49.0%      48533            -0.0%      95211        perf-stat.ps.cpu-clock
 5.123e+09 ± 27%    +160.3%  1.334e+10 ±  5%      +9.2%  5.594e+09 ± 19%  perf-stat.ps.cpu-cycles
    108.79           +95.9%     213.12 ± 25%      -0.2%     108.56        perf-stat.ps.cpu-migrations
 4.452e+09 ± 40%     +43.3%   6.38e+09           +12.3%      5e+09 ± 30%  perf-stat.ps.instructions
      3230         +1129.5%      39716 ±  3%      -0.4%       3218        perf-stat.ps.minor-faults
      3230         +1129.5%      39715 ±  3%      -0.4%       3218        perf-stat.ps.page-faults
     95218           -49.0%      48533            -0.0%      95211        perf-stat.ps.task-clock
 5.507e+11 ± 40%     -97.6%  1.303e+10           +10.9%   6.11e+11 ± 30%  perf-stat.total.instructions
    428.50 ±113%    -100.0%       0.00           -32.7%     288.40 ±132%  proc-vmstat.kswapd_high_wmark_hit_quickly
      1663 ± 68%    -100.0%       0.00           +20.0%       1995 ± 47%  proc-vmstat.kswapd_low_wmark_hit_quickly
    248125 ± 17%     -30.9%     171528            -1.3%     244986 ± 15%  proc-vmstat.nr_active_anon
   1740791 ± 71%    -100.0%       0.00           +16.8%    2033072 ± 51%  proc-vmstat.nr_active_file
    299833           -43.1%     170711            -0.4%     298782        proc-vmstat.nr_anon_pages
    517.25 ±  3%     -57.9%     217.83 ± 20%      -9.0%     470.49 ± 10%  proc-vmstat.nr_anon_transparent_hugepages
  24125371           -95.9%     984856            -0.2%   24081001        proc-vmstat.nr_file_pages
   7236331          +322.9%   30605541            +0.7%    7285216        proc-vmstat.nr_free_pages
  21481117 ±  5%     -99.6%      87388            -1.6%   21144500 ±  4%  proc-vmstat.nr_inactive_file
     20818           -25.3%      15557            +0.4%      20894        proc-vmstat.nr_mapped
    608.02           -62.3%     229.33 ± 79%      +0.0%     608.17 ±  3%  proc-vmstat.nr_mlock
      7717           -77.2%       1762 ±  4%      -0.9%       7646        proc-vmstat.nr_shmem
    101012           -75.4%      24886            -0.7%     100304        proc-vmstat.nr_slab_reclaimable
    150134           -30.4%     104433            -0.1%     150047        proc-vmstat.nr_slab_unreclaimable
    248125 ± 17%     -30.9%     171528            -1.3%     244986 ± 15%  proc-vmstat.nr_zone_active_anon
   1740790 ± 71%    -100.0%       0.00           +16.8%    2033071 ± 51%  proc-vmstat.nr_zone_active_file
  21481124 ±  5%     -99.6%      87388            -1.6%   21144511 ±  4%  proc-vmstat.nr_zone_inactive_file
   9755834 ± 25%    -100.0%       0.00           +12.1%   10940500 ±  3%  proc-vmstat.numa_foreign
    995.00 ± 26%     -95.4%      45.33 ±164%     +35.7%       1350 ± 82%  proc-vmstat.numa_hint_faults
    939.00 ± 28%     -96.3%      34.67 ±204%     +30.4%       1224 ± 91%  proc-vmstat.numa_hint_faults_local
   8745252 ± 28%     -95.2%     416538           -13.3%    7584794 ±  3%  proc-vmstat.numa_hit
   8645700 ± 28%     -96.3%     317091           -13.5%    7482456 ±  3%  proc-vmstat.numa_local
   9755622 ± 25%    -100.0%       0.00           +12.1%   10939557 ±  3%  proc-vmstat.numa_miss
   9856110 ± 25%     -99.0%      99445           +12.0%   11040265 ±  3%  proc-vmstat.numa_other
    386923           -97.4%       9959 ±222%      -0.6%     384707        proc-vmstat.numa_pte_updates
      2224 ± 32%    -100.0%       0.00            +9.4%       2433 ± 25%  proc-vmstat.pageoutrun
    423905 ±  3%    -100.0%       0.00            +1.5%     430262 ±  3%  proc-vmstat.pgalloc_dma32
  68828649           -98.9%     752946            +0.1%   68875748        proc-vmstat.pgalloc_normal
    498127           -61.7%     190797            -0.8%     494373        proc-vmstat.pgfault
  38943033           -99.2%     297228            +0.4%   39088883        proc-vmstat.pgfree
 2.685e+08           -99.6%    1048266            -0.0%  2.684e+08        proc-vmstat.pgpgin
     22286 ±  3%     -58.9%       9168 ±  6%      +1.3%      22573        proc-vmstat.pgreuse
  36664920          -100.0%       0.00            -0.0%   36656051        proc-vmstat.pgscan_file
  36664920          -100.0%       0.00            -0.0%   36656051        proc-vmstat.pgscan_kswapd
  36664893          -100.0%       0.00            -0.0%   36655993        proc-vmstat.pgsteal_file
  36664893          -100.0%       0.00            -0.0%   36655993        proc-vmstat.pgsteal_kswapd
     30510 ±  9%    -100.0%       0.00            +0.7%      30728 ±  8%  proc-vmstat.slabs_scanned
    157121 ±  3%    -100.0%       0.00            -2.1%     153839        proc-vmstat.workingset_nodes
      9.70 ± 66%      -9.4        0.32 ±223%      -0.9        8.78 ± 35%  perf-profile.calltrace.cycles-pp.vfs_write.ksys_write.do_syscall_64.entry_SYSCALL_64_after_hwframe.write
      9.09 ± 54%      -9.1        0.00            -0.4        8.72 ± 25%  perf-profile.calltrace.cycles-pp.record__pushfn.perf_mmap__push.record__mmap_read_evlist.__cmd_record.cmd_record
      9.09 ± 54%      -9.1        0.00            -0.4        8.72 ± 25%  perf-profile.calltrace.cycles-pp.write.writen.record__pushfn.perf_mmap__push.record__mmap_read_evlist
      9.09 ± 54%      -9.1        0.00            -0.4        8.72 ± 25%  perf-profile.calltrace.cycles-pp.writen.record__pushfn.perf_mmap__push.record__mmap_read_evlist.__cmd_record
     13.49 ± 32%      -8.7        4.75 ± 38%      -1.1       12.42 ± 13%  perf-profile.calltrace.cycles-pp.handle_internal_command.main
     13.49 ± 32%      -8.7        4.75 ± 38%      -1.1       12.42 ± 13%  perf-profile.calltrace.cycles-pp.main
     13.49 ± 32%      -8.7        4.75 ± 38%      -1.1       12.42 ± 13%  perf-profile.calltrace.cycles-pp.run_builtin.handle_internal_command.main
      8.57 ± 57%      -8.6        0.00            -0.3        8.24 ± 25%  perf-profile.calltrace.cycles-pp.generic_perform_write.shmem_file_write_iter.vfs_write.ksys_write.do_syscall_64
      8.57 ± 57%      -8.6        0.00            -0.3        8.24 ± 25%  perf-profile.calltrace.cycles-pp.shmem_file_write_iter.vfs_write.ksys_write.do_syscall_64.entry_SYSCALL_64_after_hwframe
      8.57 ± 57%      -8.6        0.00            -0.2        8.40 ± 27%  perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe.write.writen.record__pushfn
      8.57 ± 57%      -8.6        0.00            -0.2        8.40 ± 27%  perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe.write.writen.record__pushfn.perf_mmap__push
      8.57 ± 57%      -8.6        0.00            -0.2        8.40 ± 27%  perf-profile.calltrace.cycles-pp.ksys_write.do_syscall_64.entry_SYSCALL_64_after_hwframe.write.writen
      9.34 ± 22%      -6.9        2.45 ± 67%      +0.0        9.35 ± 25%  perf-profile.calltrace.cycles-pp.__cmd_record.cmd_record.run_builtin.handle_internal_command.main
      9.34 ± 22%      -6.9        2.45 ± 67%      +0.0        9.35 ± 25%  perf-profile.calltrace.cycles-pp.cmd_record.run_builtin.handle_internal_command.main
      7.20 ± 25%      -5.5        1.70 ± 79%      +1.3        8.52 ± 28%  perf-profile.calltrace.cycles-pp.perf_mmap__push.record__mmap_read_evlist.__cmd_record.cmd_record.run_builtin
      7.20 ± 25%      -5.5        1.70 ± 79%      +1.3        8.52 ± 28%  perf-profile.calltrace.cycles-pp.record__mmap_read_evlist.__cmd_record.cmd_record.run_builtin.handle_internal_command
      0.37 ±142%      +1.0        1.38 ± 79%      +1.2        1.61 ± 25%  perf-profile.calltrace.cycles-pp.__tlb_batch_free_encoded_pages.tlb_finish_mmu.exit_mmap.__mmput.exit_mm
      0.37 ±142%      +1.0        1.38 ± 79%      +1.2        1.61 ± 25%  perf-profile.calltrace.cycles-pp.free_pages_and_swap_cache.__tlb_batch_free_encoded_pages.tlb_finish_mmu.exit_mmap.__mmput
      0.37 ±142%      +1.0        1.38 ± 79%      +1.2        1.61 ± 25%  perf-profile.calltrace.cycles-pp.tlb_finish_mmu.exit_mmap.__mmput.exit_mm.do_exit
      1.21 ±112%      +2.2        3.41 ± 70%      +3.1        4.30 ± 38%  perf-profile.calltrace.cycles-pp.zap_pmd_range.unmap_page_range.unmap_vmas.exit_mmap.__mmput
      1.21 ±112%      +2.2        3.41 ± 70%      +3.1        4.30 ± 38%  perf-profile.calltrace.cycles-pp.zap_pte_range.zap_pmd_range.unmap_page_range.unmap_vmas.exit_mmap
      1.21 ±112%      +2.6        3.85 ± 75%      +3.2        4.38 ± 42%  perf-profile.calltrace.cycles-pp.unmap_vmas.exit_mmap.__mmput.exit_mm.do_exit
      1.01 ±141%      +2.8        3.85 ± 75%      +3.2        4.24 ± 40%  perf-profile.calltrace.cycles-pp.unmap_page_range.unmap_vmas.exit_mmap.__mmput.exit_mm
      2.20 ±101%      +3.5        5.73 ± 58%      +5.4        7.65 ± 37%  perf-profile.calltrace.cycles-pp.exit_mmap.__mmput.exit_mm.do_exit.do_group_exit
     10.62 ± 57%      -9.4        1.17 ±142%      -1.2        9.37 ± 31%  perf-profile.children.cycles-pp.write
      9.69 ± 66%      -9.4        0.32 ±223%      -0.9        8.78 ± 35%  perf-profile.children.cycles-pp.ksys_write
      9.69 ± 66%      -9.4        0.32 ±223%      -0.9        8.78 ± 35%  perf-profile.children.cycles-pp.vfs_write
     13.49 ± 32%      -9.1        4.41 ± 47%      -1.1       12.42 ± 13%  perf-profile.children.cycles-pp.__cmd_record
     13.49 ± 32%      -9.1        4.41 ± 47%      -1.1       12.42 ± 13%  perf-profile.children.cycles-pp.cmd_record
      9.09 ± 54%      -8.8        0.32 ±223%      -0.1        9.03 ± 23%  perf-profile.children.cycles-pp.writen
      9.09 ± 54%      -8.7        0.34 ±223%      -0.3        8.83 ± 23%  perf-profile.children.cycles-pp.record__pushfn
     13.49 ± 32%      -8.7        4.75 ± 38%      -1.1       12.42 ± 13%  perf-profile.children.cycles-pp.handle_internal_command
     13.49 ± 32%      -8.7        4.75 ± 38%      -1.1       12.42 ± 13%  perf-profile.children.cycles-pp.main
     13.49 ± 32%      -8.7        4.75 ± 38%      -1.1       12.42 ± 13%  perf-profile.children.cycles-pp.run_builtin
      8.56 ± 57%      -8.6        0.00            -0.3        8.24 ± 25%  perf-profile.children.cycles-pp.generic_perform_write
      8.56 ± 57%      -8.6        0.00            -0.3        8.24 ± 25%  perf-profile.children.cycles-pp.shmem_file_write_iter
      9.94 ± 51%      -8.2        1.70 ± 79%      -0.3        9.60 ± 23%  perf-profile.children.cycles-pp.perf_mmap__push
      9.94 ± 51%      -8.2        1.70 ± 79%      -0.3        9.60 ± 23%  perf-profile.children.cycles-pp.record__mmap_read_evlist
      0.85 ± 82%      +0.5        1.38 ± 79%      +1.5        2.33 ± 28%  perf-profile.children.cycles-pp.__tlb_batch_free_encoded_pages
      0.85 ± 82%      +0.5        1.38 ± 79%      +1.5        2.33 ± 28%  perf-profile.children.cycles-pp.free_pages_and_swap_cache
      0.56 ±100%      +0.8        1.38 ± 79%      +1.1        1.66 ± 21%  perf-profile.children.cycles-pp.tlb_finish_mmu
      0.96 ±115%      +2.0        2.98 ± 76%      +2.4        3.41 ± 30%  perf-profile.children.cycles-pp.zap_present_ptes
      1.38 ±116%      +2.0        3.41 ± 70%      +3.0        4.34 ± 37%  perf-profile.children.cycles-pp.zap_pmd_range
      1.38 ±116%      +2.0        3.41 ± 70%      +3.0        4.34 ± 37%  perf-profile.children.cycles-pp.zap_pte_range
      1.58 ± 94%      +2.3        3.85 ± 75%      +2.9        4.49 ± 40%  perf-profile.children.cycles-pp.unmap_vmas
      1.38 ±116%      +2.5        3.85 ± 75%      +3.0        4.34 ± 37%  perf-profile.children.cycles-pp.unmap_page_range
      2.20 ±101%      +3.5        5.73 ± 58%      +5.6        7.77 ± 36%  perf-profile.children.cycles-pp.exit_mm
      2.40 ± 86%      +3.5        5.95 ± 55%      +5.4        7.86 ± 39%  perf-profile.children.cycles-pp.exit_mmap
      2.40 ± 86%      +3.5        5.95 ± 55%      +5.6        7.98 ± 38%  perf-profile.children.cycles-pp.__mmput
      8736 ±  9%     -37.6%       5455 ±  7%      +8.3%       9460 ± 23%  sched_debug.cfs_rq:/.avg_vruntime.min
      0.00 ± 56%    +407.7%       0.02 ± 58%      +1.5%       0.00 ± 56%  sched_debug.cfs_rq:/.h_nr_delayed.avg
      0.31 ± 48%    +227.3%       1.00            +9.1%       0.33 ± 54%  sched_debug.cfs_rq:/.h_nr_delayed.max
      0.03 ± 49%    +295.2%       0.13 ± 27%      +5.7%       0.04 ± 53%  sched_debug.cfs_rq:/.h_nr_delayed.stddev
      0.09 ± 11%     +84.1%       0.17 ±  9%      +5.5%       0.10 ± 17%  sched_debug.cfs_rq:/.h_nr_running.avg
      0.28 ±  6%     +43.8%       0.40 ± 11%      +0.9%       0.28 ±  9%  sched_debug.cfs_rq:/.h_nr_running.stddev
     48.57 ± 18%     +84.9%      89.82 ± 18%     +75.3%      85.12 ±102%  sched_debug.cfs_rq:/.load_avg.avg
    947.69 ± 14%     +46.5%       1388 ± 33%    +297.9%       3771 ±221%  sched_debug.cfs_rq:/.load_avg.max
    166.24 ± 14%     +62.3%     269.79 ± 16%    +175.8%     458.43 ±180%  sched_debug.cfs_rq:/.load_avg.stddev
      8736 ±  9%     -37.6%       5452 ±  7%      +8.3%       9460 ± 23%  sched_debug.cfs_rq:/.min_vruntime.min
      0.09 ± 11%     +88.9%       0.18 ±  9%      +5.7%       0.10 ± 18%  sched_debug.cfs_rq:/.nr_running.avg
      1.36 ±  4%     +46.9%       2.00            -2.0%       1.33 ± 13%  sched_debug.cfs_rq:/.nr_running.max
      0.29 ±  6%     +50.1%       0.43 ±  9%      +1.0%       0.29 ± 10%  sched_debug.cfs_rq:/.nr_running.stddev
     17.33 ± 38%    +147.9%      42.98 ± 29%     +44.5%      25.05 ± 43%  sched_debug.cfs_rq:/.removed.load_avg.avg
    483.56 ± 31%    +111.8%       1024           +37.6%     665.60 ± 40%  sched_debug.cfs_rq:/.removed.load_avg.max
     85.81 ± 31%    +132.6%     199.60 ± 14%     +38.4%     118.74 ± 36%  sched_debug.cfs_rq:/.removed.load_avg.stddev
      6.41 ± 42%    +176.3%      17.71 ± 38%     +50.5%       9.65 ± 51%  sched_debug.cfs_rq:/.removed.runnable_avg.avg
    239.17 ± 37%    +119.8%     525.67 ±  2%     +37.4%     328.52 ± 42%  sched_debug.cfs_rq:/.removed.runnable_avg.max
     34.33 ± 35%    +152.5%      86.68 ± 22%     +45.2%      49.85 ± 44%  sched_debug.cfs_rq:/.removed.runnable_avg.stddev
      6.41 ± 42%    +176.4%      17.71 ± 38%     +50.4%       9.64 ± 51%  sched_debug.cfs_rq:/.removed.util_avg.avg
    238.94 ± 37%    +120.0%     525.67 ±  2%     +37.5%     328.52 ± 42%  sched_debug.cfs_rq:/.removed.util_avg.max
     34.31 ± 35%    +152.7%      86.68 ± 22%     +45.2%      49.82 ± 44%  sched_debug.cfs_rq:/.removed.util_avg.stddev
    126.39 ± 12%    +132.4%     293.67 ±  3%     +12.1%     141.62 ± 16%  sched_debug.cfs_rq:/.util_avg.avg
    992.22 ±  8%     +30.8%       1298 ± 16%      +9.1%       1082 ± 23%  sched_debug.cfs_rq:/.util_avg.max
    188.05 ±  8%     +70.1%     319.91 ±  7%      +8.7%     204.36 ± 12%  sched_debug.cfs_rq:/.util_avg.stddev
     18.55 ± 20%     +78.8%      33.17 ± 14%      +7.6%      19.97 ± 21%  sched_debug.cfs_rq:/.util_est.avg
    614.94 ± 29%     +62.9%       1002 ±  3%     +10.9%     682.00 ± 24%  sched_debug.cfs_rq:/.util_est.max
     83.77 ± 24%     +64.2%     137.53 ±  4%      +9.7%      91.87 ± 22%  sched_debug.cfs_rq:/.util_est.stddev
    196044 ± 15%     -98.6%       2808 ± 15%     -17.2%     162396 ± 48%  sched_debug.cpu.avg_idle.min
    163689 ±  3%     +38.6%     226871 ±  4%      -0.3%     163181 ±  8%  sched_debug.cpu.avg_idle.stddev
    421612 ±  2%     -12.7%     367991            -1.1%     416790 ±  4%  sched_debug.cpu.clock.avg
    421617 ±  2%     -12.7%     367996            -1.1%     416795 ±  4%  sched_debug.cpu.clock.max
    421588 ±  2%     -12.7%     367986            -1.1%     416772 ±  4%  sched_debug.cpu.clock.min
      4.22 ± 27%     -38.7%       2.58 ±  4%     -15.7%       3.55 ± 37%  sched_debug.cpu.clock.stddev
    421249 ±  2%     -12.7%     367704            -1.1%     416439 ±  4%  sched_debug.cpu.clock_task.avg
    421583 ±  2%     -12.7%     367963            -1.1%     416760 ±  4%  sched_debug.cpu.clock_task.max
    411856 ±  2%     -12.8%     359277            -1.2%     406861 ±  4%  sched_debug.cpu.clock_task.min
      1029 ±  6%     -11.9%     907.72 ±  3%      +1.1%       1041 ±  8%  sched_debug.cpu.clock_task.stddev
    252.14 ± 13%     +61.7%     407.60 ±  6%      +6.5%     268.49 ±  9%  sched_debug.cpu.curr->pid.avg
      5177 ±  6%     -42.7%       2967            -4.5%       4944 ±  9%  sched_debug.cpu.curr->pid.max
      0.00 ±  9%     +38.2%       0.00 ± 17%      -3.3%       0.00 ± 18%  sched_debug.cpu.next_balance.stddev
      0.09 ± 12%     +96.6%       0.17 ±  9%      +8.0%       0.09 ± 16%  sched_debug.cpu.nr_running.avg
      0.26 ±  6%     +50.6%       0.40 ± 11%      +2.1%       0.27 ± 10%  sched_debug.cpu.nr_running.stddev
     35646 ±  7%     -28.2%      25593 ±  2%      -3.2%      34501 ± 12%  sched_debug.cpu.nr_switches.avg
    711.47 ± 10%     -44.3%     396.17 ± 11%      -7.2%     659.97 ± 19%  sched_debug.cpu.nr_switches.min
     52034 ±  7%     -16.0%      43686 ±  6%      -0.6%      51709 ± 16%  sched_debug.cpu.nr_switches.stddev
      0.01 ± 21%    +100.0%       0.01 ± 31%      -5.7%       0.01 ± 54%  sched_debug.cpu.nr_uninterruptible.avg
    421610 ±  2%     -12.7%     367987            -1.1%     416787 ±  4%  sched_debug.cpu_clk
    421050 ±  2%     -12.7%     367426            -1.1%     416227 ±  4%  sched_debug.ktime
    422192 ±  2%     -12.7%     368564            -1.1%     417374 ±  4%  sched_debug.sched_clk
      0.01 ± 71%    -100.0%       0.00           +27.1%       0.02 ± 91%  perf-sched.sch_delay.avg.ms.__cond_resched.filemap_read.xfs_file_buffered_read.xfs_file_read_iter.__io_read
      0.06 ± 10%    -100.0%       0.00            -4.4%       0.06 ± 22%  perf-sched.sch_delay.avg.ms.__cond_resched.shrink_folio_list.evict_folios.try_to_shrink_lruvec.shrink_one
      0.04 ± 49%    -100.0%       0.00            -1.1%       0.04 ± 50%  perf-sched.sch_delay.avg.ms.__cond_resched.try_to_shrink_lruvec.shrink_one.shrink_many.shrink_node
      0.03 ± 23%     -93.6%       0.00 ±223%      +5.9%       0.03 ± 18%  perf-sched.sch_delay.avg.ms.__x64_sys_pause.do_syscall_64.entry_SYSCALL_64_after_hwframe.[unknown]
      0.06 ± 33%    -100.0%       0.00           -20.4%       0.05 ± 63%  perf-sched.sch_delay.avg.ms.devkmsg_read.vfs_read.ksys_read.do_syscall_64
      0.01 ± 20%    -100.0%       0.00            -8.2%       0.01 ± 19%  perf-sched.sch_delay.avg.ms.io_cqring_wait.__do_sys_io_uring_enter.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.02 ± 70%    -100.0%       0.00           -32.0%       0.01 ± 73%  perf-sched.sch_delay.avg.ms.irq_thread.kthread.ret_from_fork.ret_from_fork_asm
      0.04 ± 31%     -91.0%       0.00 ±170%     -12.6%       0.04 ± 55%  perf-sched.sch_delay.avg.ms.irqentry_exit_to_user_mode.asm_sysvec_apic_timer_interrupt.[unknown].[unknown]
      0.03 ± 52%    -100.0%       0.00           +71.6%       0.06 ± 19%  perf-sched.sch_delay.avg.ms.rcu_gp_kthread.kthread.ret_from_fork.ret_from_fork_asm
      0.02 ± 20%     -74.2%       0.01 ± 42%     +18.2%       0.03 ± 36%  perf-sched.sch_delay.avg.ms.schedule_hrtimeout_range.do_poll.constprop.0.do_sys_poll
      0.02 ± 33%    -100.0%       0.00           +11.4%       0.02 ± 36%  perf-sched.sch_delay.avg.ms.schedule_hrtimeout_range.do_select.core_sys_select.do_pselect.constprop
      0.04 ± 51%    -100.0%       0.00           -47.4%       0.02 ±113%  perf-sched.sch_delay.avg.ms.schedule_timeout.__wait_for_common.__flush_work.__lru_add_drain_all
      0.01 ± 44%    -100.0%       0.00            +7.8%       0.01 ± 19%  perf-sched.sch_delay.avg.ms.schedule_timeout.__wait_for_common.wait_for_completion_state.kernel_clone
      0.01 ± 43%    -100.0%       0.00           -23.7%       0.01 ± 67%  perf-sched.sch_delay.avg.ms.schedule_timeout.io_schedule_timeout.__wait_for_common.blk_execute_rq
      0.05 ± 27%    -100.0%       0.00            +7.9%       0.05 ± 26%  perf-sched.sch_delay.avg.ms.schedule_timeout.kcompactd.kthread.ret_from_fork
      0.01 ± 35%    -100.0%       0.00           -45.3%       0.00 ±108%  perf-sched.sch_delay.avg.ms.schedule_timeout.khugepaged_wait_work.khugepaged.kthread
      0.04 ± 25%    -100.0%       0.00           -16.5%       0.04 ± 13%  perf-sched.sch_delay.avg.ms.schedule_timeout.kswapd_try_to_sleep.kswapd.kthread
      0.03 ± 18%     -69.6%       0.01 ± 92%     +36.7%       0.04 ± 46%  perf-sched.sch_delay.avg.ms.syscall_exit_to_user_mode.do_syscall_64.entry_SYSCALL_64_after_hwframe.[unknown]
      0.02 ± 20%    -100.0%       0.00            +2.3%       0.02 ± 19%  perf-sched.sch_delay.avg.ms.wait_for_partner.fifo_open.do_dentry_open.vfs_open
      0.03 ± 75%    -100.0%       0.00            +7.1%       0.03 ± 90%  perf-sched.sch_delay.max.ms.__cond_resched.filemap_read.xfs_file_buffered_read.xfs_file_read_iter.__io_read
      0.08 ±  4%    -100.0%       0.00            +7.7%       0.08 ± 20%  perf-sched.sch_delay.max.ms.__cond_resched.shrink_folio_list.evict_folios.try_to_shrink_lruvec.shrink_one
      0.07 ± 21%    -100.0%       0.00           +10.9%       0.07 ± 18%  perf-sched.sch_delay.max.ms.__cond_resched.try_to_shrink_lruvec.shrink_one.shrink_many.shrink_node
      0.04 ±  6%     -95.2%       0.00 ±223%      +8.3%       0.04 ± 19%  perf-sched.sch_delay.max.ms.__x64_sys_pause.do_syscall_64.entry_SYSCALL_64_after_hwframe.[unknown]
      0.06 ± 34%    -100.0%       0.00           -18.8%       0.05 ± 65%  perf-sched.sch_delay.max.ms.devkmsg_read.vfs_read.ksys_read.do_syscall_64
      3.27 ±147%    -100.0%       0.00           -93.3%       0.22 ± 62%  perf-sched.sch_delay.max.ms.io_cqring_wait.__do_sys_io_uring_enter.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.02 ± 89%    -100.0%       0.00           -41.1%       0.01 ± 76%  perf-sched.sch_delay.max.ms.irq_thread.kthread.ret_from_fork.ret_from_fork_asm
      0.07 ± 18%     -89.3%       0.01 ±192%     -12.4%       0.06 ± 53%  perf-sched.sch_delay.max.ms.irqentry_exit_to_user_mode.asm_sysvec_apic_timer_interrupt.[unknown].[unknown]
      0.08 ± 15%    -100.0%       0.00           +22.4%       0.10 ± 11%  perf-sched.sch_delay.max.ms.rcu_gp_kthread.kthread.ret_from_fork.ret_from_fork_asm
      0.10 ± 23%     -92.1%       0.01 ± 26%    +115.2%       0.22 ±161%  perf-sched.sch_delay.max.ms.schedule_hrtimeout_range.do_poll.constprop.0.do_sys_poll
      0.04 ± 38%    -100.0%       0.00            -4.4%       0.03 ± 38%  perf-sched.sch_delay.max.ms.schedule_hrtimeout_range.do_select.core_sys_select.do_pselect.constprop
      0.07 ±  4%    -100.0%       0.00           -42.8%       0.04 ± 84%  perf-sched.sch_delay.max.ms.schedule_timeout.__wait_for_common.__flush_work.__lru_add_drain_all
      0.09 ± 30%    -100.0%       0.00            +0.5%       0.09 ± 17%  perf-sched.sch_delay.max.ms.schedule_timeout.__wait_for_common.wait_for_completion_state.kernel_clone
      0.02 ± 54%    -100.0%       0.00            +6.4%       0.02 ±105%  perf-sched.sch_delay.max.ms.schedule_timeout.io_schedule_timeout.__wait_for_common.blk_execute_rq
      0.09 ± 12%    -100.0%       0.00            +0.7%       0.09 ± 15%  perf-sched.sch_delay.max.ms.schedule_timeout.kcompactd.kthread.ret_from_fork
      0.01 ± 35%    -100.0%       0.00           -45.3%       0.00 ±108%  perf-sched.sch_delay.max.ms.schedule_timeout.khugepaged_wait_work.khugepaged.kthread
      0.12 ± 26%    -100.0%       0.00            +7.4%       0.13 ± 19%  perf-sched.sch_delay.max.ms.schedule_timeout.kswapd_try_to_sleep.kswapd.kthread
      0.07 ± 27%     -62.3%       0.03 ± 94%      +7.3%       0.07 ± 37%  perf-sched.sch_delay.max.ms.syscall_exit_to_user_mode.do_syscall_64.entry_SYSCALL_64_after_hwframe.[unknown]
      0.07 ± 15%    -100.0%       0.00            -0.1%       0.07 ± 16%  perf-sched.sch_delay.max.ms.wait_for_partner.fifo_open.do_dentry_open.vfs_open
      0.01 ± 17%    +593.2%       0.09 ± 74%      -5.1%       0.01 ± 15%  perf-sched.total_sch_delay.average.ms
     15.98 ±  2%     -85.5%       2.32 ± 48%      +0.3%      16.03 ±  2%  perf-sched.total_wait_and_delay.average.ms
     52651           -98.0%       1045 ± 30%      -0.1%      52620        perf-sched.total_wait_and_delay.count.ms
      4255 ± 13%     -98.3%      73.23 ± 15%      -9.1%       3867 ± 15%  perf-sched.total_wait_and_delay.max.ms
     15.97 ±  2%     -86.0%       2.24 ± 53%      +0.3%      16.02 ±  2%  perf-sched.total_wait_time.average.ms
      4255 ± 13%     -98.9%      45.89 ±  7%      -9.1%       3866 ± 15%  perf-sched.total_wait_time.max.ms
      7.81 ±  7%     -97.5%       0.19 ± 62%      -3.0%       7.58 ±  7%  perf-sched.wait_and_delay.avg.ms.__cond_resched.__wait_for_common.affine_move_task.__set_cpus_allowed_ptr.__sched_setaffinity
     69.50 ± 29%    -100.0%       0.00            -2.9%      67.48 ± 26%  perf-sched.wait_and_delay.avg.ms.__cond_resched.shrink_folio_list.evict_folios.try_to_shrink_lruvec.shrink_one
    689.13 ± 14%    -100.0%       0.00           +10.2%     759.73 ± 12%  perf-sched.wait_and_delay.avg.ms.__x64_sys_pause.do_syscall_64.entry_SYSCALL_64_after_hwframe.[unknown]
     17.56 ±  4%    -100.0%       0.00            +0.6%      17.67 ±  3%  perf-sched.wait_and_delay.avg.ms.do_nanosleep.hrtimer_nanosleep.common_nsleep.__x64_sys_clock_nanosleep
     32.71           -99.4%       0.21 ± 50%      -1.6%      32.18        perf-sched.wait_and_delay.avg.ms.do_task_dead.do_exit.do_group_exit.__x64_sys_exit_group.x64_sys_call
      0.78          -100.0%       0.00            +0.5%       0.79        perf-sched.wait_and_delay.avg.ms.io_cqring_wait.__do_sys_io_uring_enter.do_syscall_64.entry_SYSCALL_64_after_hwframe
     29.64 ±  3%     -97.5%       0.73 ±  7%      -1.8%      29.10 ±  4%  perf-sched.wait_and_delay.avg.ms.pipe_read.vfs_read.ksys_read.do_syscall_64
    403.38 ±  7%     -99.4%       2.51 ±223%      +2.1%     411.67 ±  4%  perf-sched.wait_and_delay.avg.ms.schedule_hrtimeout_range.do_poll.constprop.0.do_sys_poll
    158.27          -100.0%       0.00            -2.8%     153.90 ±  3%  perf-sched.wait_and_delay.avg.ms.schedule_hrtimeout_range.do_select.core_sys_select.do_pselect.constprop
    112.37 ± 23%     -96.3%       4.12 ±103%      +6.5%     119.69 ± 20%  perf-sched.wait_and_delay.avg.ms.schedule_hrtimeout_range.ep_poll.do_epoll_wait.__x64_sys_epoll_wait
    285.75 ± 73%    -100.0%       0.00           -47.6%     149.67 ± 84%  perf-sched.wait_and_delay.avg.ms.schedule_timeout.io_schedule_timeout.__wait_for_common.blk_execute_rq
    453.18          -100.0%       0.00            -0.0%     453.09        perf-sched.wait_and_delay.avg.ms.schedule_timeout.kcompactd.kthread.ret_from_fork
     47.62 ± 62%    -100.0%       0.00           -20.9%      37.65 ± 63%  perf-sched.wait_and_delay.avg.ms.schedule_timeout.kswapd_try_to_sleep.kswapd.kthread
    500.57 ±  7%     -98.9%       5.42 ± 59%      +4.0%     520.58 ±  2%  perf-sched.wait_and_delay.avg.ms.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
    561.24 ±  5%     -99.5%       3.01 ± 50%      +0.9%     566.29 ±  4%  perf-sched.wait_and_delay.avg.ms.worker_thread.kthread.ret_from_fork.ret_from_fork_asm
    577.00           -40.4%     343.83 ± 23%      -0.1%     576.70        perf-sched.wait_and_delay.count.__cond_resched.__wait_for_common.affine_move_task.__set_cpus_allowed_ptr.__sched_setaffinity
      6.00 ± 31%    -100.0%       0.00           -15.0%       5.10 ± 51%  perf-sched.wait_and_delay.count.__cond_resched.shrink_folio_list.evict_folios.try_to_shrink_lruvec.shrink_one
     10.17 ±  3%    -100.0%       0.00            -1.6%      10.00        perf-sched.wait_and_delay.count.__x64_sys_pause.do_syscall_64.entry_SYSCALL_64_after_hwframe.[unknown]
    501.83          -100.0%       0.00            +0.2%     502.70        perf-sched.wait_and_delay.count.do_nanosleep.hrtimer_nanosleep.common_nsleep.__x64_sys_clock_nanosleep
     45905          -100.0%       0.00            -0.1%      45851        perf-sched.wait_and_delay.count.io_cqring_wait.__do_sys_io_uring_enter.do_syscall_64.entry_SYSCALL_64_after_hwframe
      2426 ±  2%     -97.9%      51.67 ± 61%      +1.0%       2450 ±  3%  perf-sched.wait_and_delay.count.pipe_read.vfs_read.ksys_read.do_syscall_64
     37.83 ±  5%     -98.7%       0.50 ±223%      +1.8%      38.50 ±  4%  perf-sched.wait_and_delay.count.schedule_hrtimeout_range.do_poll.constprop.0.do_sys_poll
     30.00          -100.0%       0.00            +0.3%      30.10        perf-sched.wait_and_delay.count.schedule_hrtimeout_range.do_select.core_sys_select.do_pselect.constprop
      2.33 ± 20%    -100.0%       0.00           +15.7%       2.70 ± 16%  perf-sched.wait_and_delay.count.schedule_timeout.io_schedule_timeout.__wait_for_common.blk_execute_rq
     19.83          -100.0%       0.00            -0.2%      19.80 ±  2%  perf-sched.wait_and_delay.count.schedule_timeout.kcompactd.kthread.ret_from_fork
    134.67 ± 21%    -100.0%       0.00            +8.6%     146.20 ± 18%  perf-sched.wait_and_delay.count.schedule_timeout.kswapd_try_to_sleep.kswapd.kthread
      1195 ±  3%     -99.1%      10.17 ± 54%      +1.4%       1212 ±  3%  perf-sched.wait_and_delay.count.schedule_timeout.rcu_gp_fqs_loop.rcu_gp_kthread.kthread
    925.67 ±  7%     -58.9%     380.00 ± 24%      -3.7%     891.10 ±  2%  perf-sched.wait_and_delay.count.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
    362.33 ±  5%     -79.0%      76.17 ± 58%      -1.1%     358.50 ±  6%  perf-sched.wait_and_delay.count.worker_thread.kthread.ret_from_fork.ret_from_fork_asm
      1013 ±  2%     -94.8%      53.21 ± 65%      -0.1%       1012 ±  3%  perf-sched.wait_and_delay.max.ms.__cond_resched.__wait_for_common.affine_move_task.__set_cpus_allowed_ptr.__sched_setaffinity
     89.90 ± 17%    -100.0%       0.00            -0.2%      89.68 ± 26%  perf-sched.wait_and_delay.max.ms.__cond_resched.shrink_folio_list.evict_folios.try_to_shrink_lruvec.shrink_one
    999.82          -100.0%       0.00            +0.0%     999.82        perf-sched.wait_and_delay.max.ms.__x64_sys_pause.do_syscall_64.entry_SYSCALL_64_after_hwframe.[unknown]
      1000          -100.0%       0.00            -0.0%       1000        perf-sched.wait_and_delay.max.ms.do_nanosleep.hrtimer_nanosleep.common_nsleep.__x64_sys_clock_nanosleep
    890.88 ±  8%     -99.4%       5.21 ±101%      -0.7%     884.99 ±  6%  perf-sched.wait_and_delay.max.ms.do_task_dead.do_exit.do_group_exit.__x64_sys_exit_group.x64_sys_call
     13.58 ±106%    -100.0%       0.00           +14.8%      15.59 ± 77%  perf-sched.wait_and_delay.max.ms.io_cqring_wait.__do_sys_io_uring_enter.do_syscall_64.entry_SYSCALL_64_after_hwframe
      1013           -99.8%       1.97 ± 28%      -0.0%       1013        perf-sched.wait_and_delay.max.ms.pipe_read.vfs_read.ksys_read.do_syscall_64
      1464 ± 16%     -99.5%       7.52 ±223%      +0.4%       1471 ± 17%  perf-sched.wait_and_delay.max.ms.schedule_hrtimeout_range.do_poll.constprop.0.do_sys_poll
    250.08          -100.0%       0.00            +0.0%     250.09        perf-sched.wait_and_delay.max.ms.schedule_hrtimeout_range.do_select.core_sys_select.do_pselect.constprop
    334.30 ± 23%     -95.4%      15.29 ±103%      +6.6%     356.31 ± 20%  perf-sched.wait_and_delay.max.ms.schedule_hrtimeout_range.ep_poll.do_epoll_wait.__x64_sys_epoll_wait
    355.60 ± 68%    -100.0%       0.00           -43.2%     201.89 ± 66%  perf-sched.wait_and_delay.max.ms.schedule_timeout.io_schedule_timeout.__wait_for_common.blk_execute_rq
    504.88          -100.0%       0.00            -0.0%     504.71        perf-sched.wait_and_delay.max.ms.schedule_timeout.kcompactd.kthread.ret_from_fork
    111.51 ±  7%    -100.0%       0.00            -6.7%     104.09 ±  8%  perf-sched.wait_and_delay.max.ms.schedule_timeout.kswapd_try_to_sleep.kswapd.kthread
      6.34 ± 18%     -28.2%       4.55 ± 11%      +7.5%       6.81 ± 21%  perf-sched.wait_and_delay.max.ms.schedule_timeout.rcu_gp_fqs_loop.rcu_gp_kthread.kthread
      3150 ± 21%     -98.5%      45.76 ±  7%     -16.1%       2642 ± 17%  perf-sched.wait_and_delay.max.ms.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
      4235 ± 14%     -99.3%      29.44 ± 43%      -8.7%       3867 ± 15%  perf-sched.wait_and_delay.max.ms.worker_thread.kthread.ret_from_fork.ret_from_fork_asm
      7.76 ±  7%     -98.8%       0.10 ± 61%      -3.0%       7.53 ±  7%  perf-sched.wait_time.avg.ms.__cond_resched.__wait_for_common.affine_move_task.__set_cpus_allowed_ptr.__sched_setaffinity
      0.96 ± 56%    -100.0%       0.00            +3.6%       0.99 ± 68%  perf-sched.wait_time.avg.ms.__cond_resched.filemap_read.xfs_file_buffered_read.xfs_file_read_iter.__io_read
     69.43 ± 29%    -100.0%       0.00            -2.9%      67.42 ± 26%  perf-sched.wait_time.avg.ms.__cond_resched.shrink_folio_list.evict_folios.try_to_shrink_lruvec.shrink_one
     45.25 ± 92%    -100.0%       0.00           -30.3%      31.53 ±119%  perf-sched.wait_time.avg.ms.__cond_resched.try_to_shrink_lruvec.shrink_one.shrink_many.shrink_node
    689.10 ± 14%    -100.0%       0.00           +10.2%     759.70 ± 12%  perf-sched.wait_time.avg.ms.__x64_sys_pause.do_syscall_64.entry_SYSCALL_64_after_hwframe.[unknown]
      1.38 ±  9%    -100.0%       0.00            -0.3%       1.38 ± 10%  perf-sched.wait_time.avg.ms.devkmsg_read.vfs_read.ksys_read.do_syscall_64
     17.55 ±  4%    -100.0%       0.00            +0.7%      17.67 ±  3%  perf-sched.wait_time.avg.ms.do_nanosleep.hrtimer_nanosleep.common_nsleep.__x64_sys_clock_nanosleep
     32.71           -99.4%       0.21 ± 50%      -1.6%      32.18        perf-sched.wait_time.avg.ms.do_task_dead.do_exit.do_group_exit.__x64_sys_exit_group.x64_sys_call
      0.41 ±  4%     -14.0%       0.35 ±  3%      +2.2%       0.42 ±  4%  perf-sched.wait_time.avg.ms.do_wait.kernel_wait4.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.77          -100.0%       0.00            +0.7%       0.78        perf-sched.wait_time.avg.ms.io_cqring_wait.__do_sys_io_uring_enter.do_syscall_64.entry_SYSCALL_64_after_hwframe
    194.51 ±103%    -100.0%       0.00 ±223%     -13.3%     168.55 ±177%  perf-sched.wait_time.avg.ms.irqentry_exit_to_user_mode.asm_sysvec_apic_timer_interrupt.[unknown].[unknown]
     29.63 ±  3%     -97.6%       0.71 ±  8%      -1.8%      29.10 ±  4%  perf-sched.wait_time.avg.ms.pipe_read.vfs_read.ksys_read.do_syscall_64
      4.01 ±  7%    -100.0%       0.00            -4.7%       3.83 ±  2%  perf-sched.wait_time.avg.ms.rcu_gp_kthread.kthread.ret_from_fork.ret_from_fork_asm
    403.36 ±  7%     -99.3%       2.82 ±193%      +2.1%     411.65 ±  4%  perf-sched.wait_time.avg.ms.schedule_hrtimeout_range.do_poll.constprop.0.do_sys_poll
    158.25          -100.0%       0.00            -2.8%     153.89 ±  3%  perf-sched.wait_time.avg.ms.schedule_hrtimeout_range.do_select.core_sys_select.do_pselect.constprop
    112.32 ± 23%     -96.5%       3.93 ±106%      +6.5%     119.64 ± 20%  perf-sched.wait_time.avg.ms.schedule_hrtimeout_range.ep_poll.do_epoll_wait.__x64_sys_epoll_wait
      0.66 ±  4%    -100.0%       0.00            +1.0%       0.67 ±  4%  perf-sched.wait_time.avg.ms.schedule_timeout.__wait_for_common.wait_for_completion_state.kernel_clone
    285.74 ± 73%    -100.0%       0.00           -47.6%     149.66 ± 84%  perf-sched.wait_time.avg.ms.schedule_timeout.io_schedule_timeout.__wait_for_common.blk_execute_rq
    453.14          -100.0%       0.00            -0.0%     453.04        perf-sched.wait_time.avg.ms.schedule_timeout.kcompactd.kthread.ret_from_fork
      0.07 ± 83%    -100.0%       0.00           -43.0%       0.04 ±160%  perf-sched.wait_time.avg.ms.schedule_timeout.khugepaged_wait_work.khugepaged.kthread
     47.57 ± 62%    -100.0%       0.00           -20.9%      37.61 ± 63%  perf-sched.wait_time.avg.ms.schedule_timeout.kswapd_try_to_sleep.kswapd.kthread
      3.86 ±  6%     -24.9%       2.90 ± 23%      -1.9%       3.79 ±  5%  perf-sched.wait_time.avg.ms.schedule_timeout.rcu_gp_fqs_loop.rcu_gp_kthread.kthread
    500.56 ±  7%     -98.9%       5.38 ± 60%      +4.0%     520.57 ±  2%  perf-sched.wait_time.avg.ms.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
    226.30 ± 64%    -100.0%       0.01 ±107%     -18.7%     184.02 ±120%  perf-sched.wait_time.avg.ms.syscall_exit_to_user_mode.do_syscall_64.entry_SYSCALL_64_after_hwframe.[unknown]
    561.18 ±  5%     -99.6%       2.50 ± 79%      +0.9%     566.24 ±  4%  perf-sched.wait_time.avg.ms.worker_thread.kthread.ret_from_fork.ret_from_fork_asm
      1013 ±  2%     -97.4%      26.61 ± 65%      -0.1%       1012 ±  3%  perf-sched.wait_time.max.ms.__cond_resched.__wait_for_common.affine_move_task.__set_cpus_allowed_ptr.__sched_setaffinity
      1.65 ± 66%    -100.0%       0.00            +7.2%       1.77 ± 48%  perf-sched.wait_time.max.ms.__cond_resched.filemap_read.xfs_file_buffered_read.xfs_file_read_iter.__io_read
     89.83 ± 17%    -100.0%       0.00            -0.2%      89.61 ± 26%  perf-sched.wait_time.max.ms.__cond_resched.shrink_folio_list.evict_folios.try_to_shrink_lruvec.shrink_one
     91.01 ± 14%    -100.0%       0.00           -19.8%      73.00 ± 37%  perf-sched.wait_time.max.ms.__cond_resched.try_to_shrink_lruvec.shrink_one.shrink_many.shrink_node
    999.79          -100.0%       0.00            +0.0%     999.79        perf-sched.wait_time.max.ms.__x64_sys_pause.do_syscall_64.entry_SYSCALL_64_after_hwframe.[unknown]
      2.76 ±  9%    -100.0%       0.00            -0.3%       2.76 ± 10%  perf-sched.wait_time.max.ms.devkmsg_read.vfs_read.ksys_read.do_syscall_64
      1000          -100.0%       0.00            -0.0%       1000        perf-sched.wait_time.max.ms.do_nanosleep.hrtimer_nanosleep.common_nsleep.__x64_sys_clock_nanosleep
    890.88 ±  8%     -99.4%       5.21 ±101%      -0.7%     884.99 ±  6%  perf-sched.wait_time.max.ms.do_task_dead.do_exit.do_group_exit.__x64_sys_exit_group.x64_sys_call
     15.72 ±  2%     -93.4%       1.04 ± 28%      +3.2%      16.22 ±  4%  perf-sched.wait_time.max.ms.do_wait.kernel_wait4.do_syscall_64.entry_SYSCALL_64_after_hwframe
     13.23 ±110%    -100.0%       0.00           +17.7%      15.57 ± 77%  perf-sched.wait_time.max.ms.io_cqring_wait.__do_sys_io_uring_enter.do_syscall_64.entry_SYSCALL_64_after_hwframe
    500.20 ± 99%    -100.0%       0.01 ±223%     -48.4%     258.00 ±148%  perf-sched.wait_time.max.ms.irqentry_exit_to_user_mode.asm_sysvec_apic_timer_interrupt.[unknown].[unknown]
      1013           -99.8%       1.96 ± 29%      -0.0%       1013        perf-sched.wait_time.max.ms.pipe_read.vfs_read.ksys_read.do_syscall_64
      4.85 ±  6%    -100.0%       0.00            -5.0%       4.61 ± 10%  perf-sched.wait_time.max.ms.rcu_gp_kthread.kthread.ret_from_fork.ret_from_fork_asm
      1464 ± 16%     -99.4%       8.15 ±202%      +0.4%       1471 ± 17%  perf-sched.wait_time.max.ms.schedule_hrtimeout_range.do_poll.constprop.0.do_sys_poll
    250.06          -100.0%       0.00            +0.0%     250.06        perf-sched.wait_time.max.ms.schedule_hrtimeout_range.do_select.core_sys_select.do_pselect.constprop
    334.27 ± 23%     -95.4%      15.28 ±103%      +6.6%     356.28 ± 20%  perf-sched.wait_time.max.ms.schedule_hrtimeout_range.ep_poll.do_epoll_wait.__x64_sys_epoll_wait
      2.04 ±  7%    -100.0%       0.00            -1.8%       2.01 ±  6%  perf-sched.wait_time.max.ms.schedule_timeout.__wait_for_common.wait_for_completion_state.kernel_clone
    355.59 ± 68%    -100.0%       0.00           -43.2%     201.88 ± 66%  perf-sched.wait_time.max.ms.schedule_timeout.io_schedule_timeout.__wait_for_common.blk_execute_rq
    504.84          -100.0%       0.00            -0.0%     504.68        perf-sched.wait_time.max.ms.schedule_timeout.kcompactd.kthread.ret_from_fork
      0.07 ± 83%    -100.0%       0.00           -43.0%       0.04 ±160%  perf-sched.wait_time.max.ms.schedule_timeout.khugepaged_wait_work.khugepaged.kthread
    111.44 ±  7%    -100.0%       0.00            -6.7%     104.03 ±  8%  perf-sched.wait_time.max.ms.schedule_timeout.kswapd_try_to_sleep.kswapd.kthread
      3150 ± 21%     -98.7%      39.96 ± 40%     -16.1%       2642 ± 17%  perf-sched.wait_time.max.ms.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
    843.01 ± 41%    -100.0%       0.03 ± 94%     -50.4%     417.72 ±114%  perf-sched.wait_time.max.ms.syscall_exit_to_user_mode.do_syscall_64.entry_SYSCALL_64_after_hwframe.[unknown]
      4235 ± 14%     -99.5%      21.72 ± 79%      -8.7%       3866 ± 15%  perf-sched.wait_time.max.ms.worker_thread.kthread.ret_from_fork.ret_from_fork_asm



