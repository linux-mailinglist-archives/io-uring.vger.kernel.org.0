Return-Path: <io-uring+bounces-10821-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id E6913C8CE20
	for <lists+io-uring@lfdr.de>; Thu, 27 Nov 2025 06:56:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 4F9E534B3B6
	for <lists+io-uring@lfdr.de>; Thu, 27 Nov 2025 05:56:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2811A27A460;
	Thu, 27 Nov 2025 05:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Yx7qJO+S"
X-Original-To: io-uring@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52A39276050;
	Thu, 27 Nov 2025 05:55:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764222956; cv=fail; b=FHhvYLOUHRq4HS+NZyxeR6bn8xNp9CgDPlfphJ+FdkvI9qHJfnDXWTd4U+EucBT/tYeXV+g+NTKaqzxMC+n2gmBQx3yCLNXFEjd6+2fVAz0OAT779OFKMalqxzq6C1TotHGNbth3PyUs781EOq34O55lf2n/ZFKW2A7E/ozWHQY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764222956; c=relaxed/simple;
	bh=VdssG02c1ktturJZTbGFTCnjeqp5/UcTxwX7lbdJvtw=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=u/O9boo93QRZut+eOpEBcFjm5500yppSyhHJO//H6zTbY5AIUaqVWY2mTwujs2hRXvH3lsIOGkDLyonpyAWuX663O2NLHn4yeqaH8DMVKXJMjA57tI0zgWYg8MuSQmU66zJiwA1ZQZFo9ZCM6N9Qka2DbSr4Gq/e995LukIFiwM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Yx7qJO+S; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764222954; x=1795758954;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   mime-version;
  bh=VdssG02c1ktturJZTbGFTCnjeqp5/UcTxwX7lbdJvtw=;
  b=Yx7qJO+S+qdN8xDCmZk9xGg6C6jsrmrjJ+VY2VlgjfeXmVEqF1rlj59k
   aejY6VvqZDy5CehjhZK1AncdzPo8ajTMASP39rqcQ3z/4A92pLQgp3yem
   sE9rCo7MwyKYtR/wdrkm2hYMQG0SiVDUBiL8D1Uhj7/2LAYfYTAHeV37R
   vnPEsDagZYIi8rSdmeljKvS8WAhJylKqry0Zc1PltjT/687anrBkRHI3d
   6MWwdcZbUTIB3d7ex4n51KUMjsldZXULVxZUVHEsoBhF0xELZs5eFOuVP
   Cl3lrMWg0sQr/HKKxlPVwLq9M3I5n+0OFr82RxWaxL4fir2gWKaiffwbf
   w==;
X-CSE-ConnectionGUID: p/OwLRCER/SmDiGIimfdEw==
X-CSE-MsgGUID: CiaviwUUTsCVPkK5N8hYOw==
X-IronPort-AV: E=McAfee;i="6800,10657,11625"; a="83873138"
X-IronPort-AV: E=Sophos;i="6.20,230,1758610800"; 
   d="scan'208";a="83873138"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2025 21:55:54 -0800
X-CSE-ConnectionGUID: E0jWJ9hBTMCyYjRVfCeaiA==
X-CSE-MsgGUID: fDBZE6NjTAi+Z0+0AqRvAA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,230,1758610800"; 
   d="scan'208";a="193599817"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2025 21:55:53 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 26 Nov 2025 21:55:53 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Wed, 26 Nov 2025 21:55:53 -0800
Received: from SA9PR02CU001.outbound.protection.outlook.com (40.93.196.27) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 26 Nov 2025 21:55:52 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mfN0a2MDc5+nZBUwV1Es4W+rHxc7wKnjFyd2MM4oQ2VS3reJyg48Whl20fN88u52QGMrO2jhJ6kdwAaJBYDpqAkUQOefTTnGyMyQnUxVm9HUs1lVNTdzfj3J36ytNi1lFftTglVyGYL3qApPK5SRL4ON/q5lF/UqwBh7myjPBHPYEm+y9lTSYGhCxRfiWH+yEE7oDuanID4zbklMok3ozesZ/fEM5a0/NcdPyuPc/DMDTNR2+tc8mK0IQu/xbeEW+/MkD9VFJ1qQvMbBYKfR7yBu+09OhxoCuuMI/KjYgTz4mrbBUObPMfjMCZea1wdx16ak/7uGushl+/Gack8p6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W9rWraG9jTrzQ4sFwT/TMxJYbn+3uTRJu3RTNeX7E2c=;
 b=LZXXyeFOUoXUtRhUGsCDQfjTaIsUvjvykjF5tAqTuIf2nof8p4vsjhKEwWvUUPTAb+uRmwA5qgDNACSuv5ry56dsQkO906wU0VOCOZp7YTh0HwYqfR9XK1/sTiuwlRZ7/rRJjknUZME8K+MHhIU8qbyrWebl3ZlvbMKZj3sdWuoYZF8BQKsxN3pPehHpp6WCNPWdI56mJP/5w4a1kmox/o+IzLvwZUJfR9ihepftKfcq6jK+8BXw5zOinM+Wi6ytORjb9ddFDsS1aLnPI3V4OddFShxkHF5pzZPOOpIZNs4ttBga64iYIQIW88YAu1dZhD3Ir1wotHC9nhXg4or3fQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by PH0PR11MB7585.namprd11.prod.outlook.com (2603:10b6:510:28f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.11; Thu, 27 Nov
 2025 05:55:45 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c%5]) with mapi id 15.20.9366.012; Thu, 27 Nov 2025
 05:55:44 +0000
Date: Thu, 27 Nov 2025 13:55:35 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Caleb Sander Mateos <csander@purestorage.com>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <io-uring@vger.kernel.org>,
	Jens Axboe <axboe@kernel.dk>, <linux-kernel@vger.kernel.org>, "Caleb Sander
 Mateos" <csander@purestorage.com>, <oliver.sang@intel.com>
Subject: Re: [PATCH v3 4/4] io_uring: avoid uring_lock for
 IORING_SETUP_SINGLE_ISSUER
Message-ID: <202511270630.4e038598-lkp@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251125233928.3962947-5-csander@purestorage.com>
X-ClientProxiedBy: SI2PR04CA0015.apcprd04.prod.outlook.com
 (2603:1096:4:197::21) To LV3PR11MB8603.namprd11.prod.outlook.com
 (2603:10b6:408:1b6::9)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|PH0PR11MB7585:EE_
X-MS-Office365-Filtering-Correlation-Id: 4d25779c-cfce-4be6-7075-08de2d799aea
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?GuT/YWOLmkwY0jdw5+as6gDnhuTQQbfJenhCCnYMefrqMyZRR/3232rHNOJ2?=
 =?us-ascii?Q?78yiD7Ze1NnG9H2MiBlhAJAdyQqV+Cpkf9wxBccsESiB4u5vUblYiF7rLPzV?=
 =?us-ascii?Q?NZ8+c3ugOeHCFVSj6Ie+O7IwdRM6DjcuRHZ2HjTXITWUjWtJkq5sisobi9Q6?=
 =?us-ascii?Q?32ikvkFKFGmI9OK8+iGJadABXbUaCQpwWXzBqmw8rc04YaeiiOQDRP4Mpaz+?=
 =?us-ascii?Q?Jca5VqjOzZy8ZHVum2SLoNJNgdYZJiNrfPM6voU9n+lbnTIJ59+xCgyatyFG?=
 =?us-ascii?Q?wEdrTTVD1gdArUPJkzpF/Xb0yL9meAdnDLlqLsPImSWhyUiu41Xgk0Nu6vif?=
 =?us-ascii?Q?7k2bKggrT9jdNThNvBK4izvwCKNpxsAGKkUwYzpEV1OuEkzQzbASB8HQUXYj?=
 =?us-ascii?Q?gZjbHRPJDjMyEh0D3AYC5YwfWAMPVovxo31VYPhDdx3aWIZc94RSy5Qe7BB5?=
 =?us-ascii?Q?YCiFhbyU1VSoS4fS5RwGITTDAzJm/yCHzH/wuCd9MPe84XMZLPZHmoKtyDbP?=
 =?us-ascii?Q?ga+qX8JJ3EqQAi2YQmS+MoX/HlpjFqnZZSU+GFhT+m6N9Y/+MliC7GUY//A0?=
 =?us-ascii?Q?7Tryk0rLQij0JTBad69uzWwNhwV6Rb+17wyUvl4e/hy79U4O0HVqv6k0tBoh?=
 =?us-ascii?Q?v5+CQDGGXb6jxHgxOAzc5HL+QoKeU/ybchMX5Lhb3cHS3k8177hoksiOuSRG?=
 =?us-ascii?Q?d5DzUg0rEWvhzzmrPklQpg7zQ7G2m6HI3Zo0vD9pB/UduTJPA5MQBMbMjcPm?=
 =?us-ascii?Q?ekrtMWV47LGrco0FkMhlWVNcZKCSA31SnxAHhY+UVgF9ySkHy/FQnx9YWQhq?=
 =?us-ascii?Q?7AEZmb3lj42JGqo3d80ayLuMPDvGdlU+WmFIIx3eYTpxu4lf2mrNW5OAt/5F?=
 =?us-ascii?Q?Y7xdgccErbavjpbYu72rSn8ngwuiXRXpB3Eh4ueG5qmwD9rk1R6/ITNkgk3F?=
 =?us-ascii?Q?34CenBxmW5zKc0441mJVxQjX+IRDa12DN08ASsS1BqyIkqK1RSYeDRVnTo0B?=
 =?us-ascii?Q?SnyU/AEvNPzKKuD9F4VoiT+wBDxv22EMP86+BSeq/TnOnlBCLCEgYcvItXRL?=
 =?us-ascii?Q?pxslVrNRX3lrqoAX3hxlsuePp9gR4AqIt3hVtDh+n0y6VHURyQj2QqeLAl3o?=
 =?us-ascii?Q?m1s5ojV2WlmkrvqGfqOMM7633t0+B/H2Jr+4rciGxv7QFJ/JVQTi8izMT7lM?=
 =?us-ascii?Q?SCxzNFctwvyfF+OyhaohuAbVeC0q/GmgGkf7sRxTHj0xQPnPKb2bil8W2YZK?=
 =?us-ascii?Q?pbJT8BVVl71c3T7Qn7t4v1OQCwh5UXvRNc2ZgPv0UwiaqpOhT82uJz/VaWC6?=
 =?us-ascii?Q?UcZ3LhspTvCqL/dRRnSl6pjpAPbMoGZCuc6BxJdzM1z2iFw9PgHmAwHvGABa?=
 =?us-ascii?Q?P1HKtlqjiQLJOm43GcMMIOUsgcfq47uSYSP4TLC7zfK2KMXIj0YrsYPseoS1?=
 =?us-ascii?Q?TnPB11RPp1w=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tdGuzbr4WhbHH6ZMNN/QHhS4k0SoSShw/M4kCYV8rRaH2TgsF0OrSi04zlqh?=
 =?us-ascii?Q?jW7SbwE+4p+evoydTTlC6LilTjMEJia4iGvRwSw/CaeHNNG4i27oQcfL+z+G?=
 =?us-ascii?Q?leV36beOl53VpUM0obi5o276jWlFnnWfrl+CmK3cJbuekH9QQukcs2dJ1Wck?=
 =?us-ascii?Q?K8ud6XaVUq6f2dxD5odg70tiqYRC+qraMBmhoBtnoaI3JWN14RLBq2iNW24u?=
 =?us-ascii?Q?haAOb0IR9QxDzdi5/EEXiP0W7Ls3SUjEdIX5VxHX40pxRBHYnG5M7CvU3g17?=
 =?us-ascii?Q?QUs8DdlpD//Fo125cG8r+bt272fyNwsLkwkDlLm3LrYX/YZOy5waVATCkBJi?=
 =?us-ascii?Q?J+Pb7+Iwr4qnvGpnS5KrLRUfQog8UsbyHmwWJo4gQ/+9QMsbxAqfn/wS2Hhs?=
 =?us-ascii?Q?DH6kEzQ1fB7nLFVAET0ujWus37p0Z4z7n/tTrvLBXMEnfcnU3xpkg2eqXLDJ?=
 =?us-ascii?Q?WzIMGRnrL7RDiN7iINBDCq0qIIp8p5Hnf5ssqS6IBgyMIHdOTt9ZMr7nTCyu?=
 =?us-ascii?Q?0avaBeVs5XC9ztM14s9oXau63ln5PqZrBbN9PjAFkuqqebmPNA3hplOUY04I?=
 =?us-ascii?Q?AVrU/+ofKfeNnwUiQ/yVCjIiknI0bQc0WXePJF8HnzPFtNyW/4f5rcg1UhwK?=
 =?us-ascii?Q?SlgMOdbXJn0VqaRy4o6icbUPBaxfqaCwyykyNK0COzwB2Z1PIylO7VRF3QP6?=
 =?us-ascii?Q?O72LVMUiXNZl89vww1sHnG1TaHa+kBpRRnid/fxraE9gpg8ek0UQe5oolsZp?=
 =?us-ascii?Q?FQnraSMwwQrq/556jWd32Npd6wPvsLsUtgqylLgJF45jyadgXJV9FmP6z77R?=
 =?us-ascii?Q?59SL0a553CAPKybCrU+tJweb9mz2S+27iXM6nPXn0+AvCYBG/j2/ZVO5LemO?=
 =?us-ascii?Q?0H1UEPFpDofLWxetRzjfNWOClaGCN0f1CA5++ptpsBamgrjsWWnYExQvhdQP?=
 =?us-ascii?Q?cRiElbG3eHMv10rcIMfTcfULs45U5VFm+Yk1PxUyzXm+pbGKGuN+0FbAcrJj?=
 =?us-ascii?Q?3EStfTFNQyu1/uDCdx59xxzwRj45cju/71ZX1mESld52cemTe97QxRR4xWi7?=
 =?us-ascii?Q?Yj0Xpc7ES72MkfLXy74OoFhAujNgZew+J+A09qPDnhg71Zeu4QWwaCKjOTN0?=
 =?us-ascii?Q?46VjtKkABi4vUI14H7xgxmvYyxOKvgLLDIGnKG8tu3K0zV5lLj5sECPeUzn6?=
 =?us-ascii?Q?Ns6iZfgHfjVFzFtxLnJB5MU5E3TmSa1xHnrMUGitRSnXGuVUy5HLfL9ZHT+Z?=
 =?us-ascii?Q?m8dkGmp2FutytnePzsaU51Tine3I9h1Zo71ZGbJJj2Jdz7f3/tQ9pK6y/2R+?=
 =?us-ascii?Q?Uiax41JqzX0u3tFiTEIK/OGbaKy15ygPc5iVNPTwwhrWmL3xQWGI3nh45g5b?=
 =?us-ascii?Q?DZ4zPTUGKyFFCuMw/g31rvdxDZSXzfYVc5vxN+Nf4brNRZaSm5NZ7ZMXFce4?=
 =?us-ascii?Q?nUEC2W5N1owNUz4HwYzmyTEGCImf2ZCh1ui8vxifLE9iJ+l2mhZwI2ZtC5BC?=
 =?us-ascii?Q?KhDvkObdobocyFJKCuh1dogkumwU+TI4l+T7HeYYpJjPk15DxZuAkjJplrim?=
 =?us-ascii?Q?XXXn1CYCfvpIL2B2UEBcb2T9hNGzg2BO3JYaOBbgOfYExN4rkHxKU6/Unw6q?=
 =?us-ascii?Q?cQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d25779c-cfce-4be6-7075-08de2d799aea
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2025 05:55:44.7321
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xKMeZ0PXKhxUH9DHgK/KxuG1wF5JQLSyoWxvWxJyXFdq0z/U2YOtA/tje3RTv4PEq7Enwpv+lmpQzOr1W6+cJQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7585
X-OriginatorOrg: intel.com



Hello,

kernel test robot noticed "WARNING:at_io_uring/io_uring.h:#io_ring_ctx_wait_and_kill" on:

commit: f82bff8359e8780d831f1180c9e8196d2d20f03c ("[PATCH v3 4/4] io_uring: avoid uring_lock for IORING_SETUP_SINGLE_ISSUER")
url: https://github.com/intel-lab-lkp/linux/commits/Caleb-Sander-Mateos/io_uring-clear-IORING_SETUP_SINGLE_ISSUER-for-IORING_SETUP_SQPOLL/20251126-074303
base: https://git.kernel.org/cgit/linux/kernel/git/axboe/linux.git for-next
patch link: https://lore.kernel.org/all/20251125233928.3962947-5-csander@purestorage.com/
patch subject: [PATCH v3 4/4] io_uring: avoid uring_lock for IORING_SETUP_SINGLE_ISSUER

in testcase: trinity
version: 
with following parameters:

	runtime: 300s
	group: group-01
	nr_groups: 5



config: x86_64-kexec
compiler: clang-20
test machine: qemu-system-x86_64 -enable-kvm -cpu SandyBridge -smp 2 -m 32G

(please refer to attached dmesg/kmsg for entire log/backtrace)



If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202511270630.4e038598-lkp@intel.com


[   22.144951][ T6341] ------------[ cut here ]------------
[   22.145674][ T1564] [main] futex: 0 owner:0
[   22.146000][ T6341] WARNING: CPU: 1 PID: 6341 at io_uring/io_uring.h:266 io_ring_ctx_wait_and_kill (io_uring/io_uring.h:266)
[   22.146149][ T1564]
[   22.146482][ T6341] Modules linked in:
[   22.147631][ T1564] [main] futex: 0 owner:0
[   22.147751][ T6341]  can_bcm
[   22.148030][ T1564]
[   22.148330][ T6341]  can_raw
[   22.148974][ T1564] [main] futex: 0 owner:0
[   22.149038][ T6341]  can
[   22.149264][ T1564]
[   22.149572][ T6341]  cn scsi_transport_iscsi sr_mod cdrom
[   22.149579][ T6341] CPU: 1 UID: 65534 PID: 6341 Comm: trinity-c3 Not tainted 6.18.0-rc6-00278-gf82bff8359e8 #1 PREEMPT(voluntary)
[   22.149582][ T6341] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[   22.151109][ T1564] [main] Reserved/initialized 10 futexes.
[   22.151645][ T6341] RIP: 0010:io_ring_ctx_wait_and_kill (io_uring/io_uring.h:266)
[   22.152382][ T1564]
[   22.152774][ T6341] Code: 02 00 00 e8 af e2 0b 00 65 48 8b 05 97 1a 5f 02 48 3b 44 24 48 0f 85 98 00 00 00 48 83 c4 50 5b 41 5e 41 5f e9 be c6 f8 00 cc <0f> 0b e9 ed fe ff ff 31 c0 4c 8d 7c 24 28 49 89 47 18 49 89 47 10
All code
========
   0:	02 00                	add    (%rax),%al
   2:	00 e8                	add    %ch,%al
   4:	af                   	scas   %es:(%rdi),%eax
   5:	e2 0b                	loop   0x12
   7:	00 65 48             	add    %ah,0x48(%rbp)
   a:	8b 05 97 1a 5f 02    	mov    0x25f1a97(%rip),%eax        # 0x25f1aa7
  10:	48 3b 44 24 48       	cmp    0x48(%rsp),%rax
  15:	0f 85 98 00 00 00    	jne    0xb3
  1b:	48 83 c4 50          	add    $0x50,%rsp
  1f:	5b                   	pop    %rbx
  20:	41 5e                	pop    %r14
  22:	41 5f                	pop    %r15
  24:	e9 be c6 f8 00       	jmp    0xf8c6e7
  29:	cc                   	int3
  2a:*	0f 0b                	ud2		<-- trapping instruction
  2c:	e9 ed fe ff ff       	jmp    0xffffffffffffff1e
  31:	31 c0                	xor    %eax,%eax
  33:	4c 8d 7c 24 28       	lea    0x28(%rsp),%r15
  38:	49 89 47 18          	mov    %rax,0x18(%r15)
  3c:	49 89 47 10          	mov    %rax,0x10(%r15)

Code starting with the faulting instruction
===========================================
   0:	0f 0b                	ud2
   2:	e9 ed fe ff ff       	jmp    0xfffffffffffffef4
   7:	31 c0                	xor    %eax,%eax
   9:	4c 8d 7c 24 28       	lea    0x28(%rsp),%r15
   e:	49 89 47 18          	mov    %rax,0x18(%r15)
  12:	49 89 47 10          	mov    %rax,0x10(%r15)
[   22.154288][ T1564] [main] sysv_shm: id:0 size:40960 flags:7b0 ptr:(nil)
[   22.155063][ T6341] RSP: 0018:ffffc90000217db0 EFLAGS: 00010246
[   22.155249][ T1564]
[   22.155714][ T6341]
[   22.157177][ T1564] [main] sysv_shm: id:1 size:4096 flags:17b0 ptr:(nil)
[   22.157242][ T6341] RAX: 0000000000000000 RBX: ffff88810d435800 RCX: 0000000000000001
[   22.157489][ T1564]
[   22.157954][ T6341] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff88810d435800
[   22.159286][ T1564] [main] Added 28 filenames from /dev
[   22.159684][ T6341] RBP: 00000000fffffff2 R08: 0000000000000000 R09: ffffffff00000000
[   22.159688][ T6341] R10: 0000000000000010 R11: 0000000000100000 R12: 0000000000000000
[   22.160050][ T1564]
[   22.160414][ T6341] R13: 0000000000000000 R14: 0000000000000000 R15: ffff888119bf9000
[   22.161762][ T1564] [main] Added 17230 filenames from /proc
[   22.161924][ T6341] FS:  00000000010a2880(0000) GS:ffff88889c519000(0000) knlGS:0000000000000000
[   22.162568][ T1564]
[   22.162958][ T6341] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   22.164372][ T1564] [main] Added 15134 filenames from /sys
[   22.164448][ T6341] CR2: 0000000000000008 CR3: 0000000165c9c000 CR4: 00000000000406f0
[   22.164456][ T6341] Call Trace:
[   22.164626][ T1564]
[   22.166367][ T6341]  <TASK>
[   22.168128][ T1564] [main] Couldn't open socket (30:1:0). Address family not supported by protocol
[   22.168186][ T6341]  io_uring_create (io_uring/io_uring.c:?)
[   22.168352][ T1564]
[   22.168974][ T6341]  __x64_sys_io_uring_setup (io_uring/io_uring.c:3766)
[   22.170902][ T1564] [main] Couldn't open socket (27:1:3). Address family not supported by protocol
[   22.172459][ T6341]  do_syscall_64 (arch/x86/entry/syscall_64.c:?)
[   22.172512][ T1564]
[   22.173163][ T6341]  ? exc_page_fault (arch/x86/include/asm/irqflags.h:37 arch/x86/include/asm/irqflags.h:114 arch/x86/mm/fault.c:1484 arch/x86/mm/fault.c:1532)
[   22.175090][ T1564] [main] Couldn't open socket (44:3:0). Address family not supported by protocol
[   22.175097][ T6341]  entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:130)
[   22.175309][ T1564]
[   22.175935][ T6341] RIP: 0033:0x453b29
[   22.176865][ T1564] Can't do protocol NETBEUI
[   22.176935][ T6341] Code: 00 f3 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 3b 84 00 00 c3 66 2e 0f 1f 84 00 00 00 00
All code
========
   0:	00 f3                	add    %dh,%bl
   2:	c3                   	ret
   3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
   a:	00 00 00 
   d:	0f 1f 40 00          	nopl   0x0(%rax)
  11:	48 89 f8             	mov    %rdi,%rax
  14:	48 89 f7             	mov    %rsi,%rdi
  17:	48 89 d6             	mov    %rdx,%rsi
  1a:	48 89 ca             	mov    %rcx,%rdx
  1d:	4d 89 c2             	mov    %r8,%r10
  20:	4d 89 c8             	mov    %r9,%r8
  23:	4c 8b 4c 24 08       	mov    0x8(%rsp),%r9
  28:	0f 05                	syscall
  2a:*	48 3d 01 f0 ff ff    	cmp    $0xfffffffffffff001,%rax		<-- trapping instruction
  30:	0f 83 3b 84 00 00    	jae    0x8471
  36:	c3                   	ret
  37:	66                   	data16
  38:	2e                   	cs
  39:	0f                   	.byte 0xf
  3a:	1f                   	(bad)
  3b:	84 00                	test   %al,(%rax)
  3d:	00 00                	add    %al,(%rax)
	...

Code starting with the faulting instruction
===========================================
   0:	48 3d 01 f0 ff ff    	cmp    $0xfffffffffffff001,%rax
   6:	0f 83 3b 84 00 00    	jae    0x8447
   c:	c3                   	ret
   d:	66                   	data16
   e:	2e                   	cs
   f:	0f                   	.byte 0xf
  10:	1f                   	(bad)
  11:	84 00                	test   %al,(%rax)
  13:	00 00                	add    %al,(%rax)


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20251127/202511270630.4e038598-lkp@intel.com



-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


