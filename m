Return-Path: <io-uring+bounces-9693-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B618B50673
	for <lists+io-uring@lfdr.de>; Tue,  9 Sep 2025 21:36:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6FDEB7A9F55
	for <lists+io-uring@lfdr.de>; Tue,  9 Sep 2025 19:34:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 862D62FFDF5;
	Tue,  9 Sep 2025 19:36:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PryngjAe"
X-Original-To: io-uring@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0D1C238D3A;
	Tue,  9 Sep 2025 19:36:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757446583; cv=fail; b=U3EFzn3njj4uotXTCFkKbKHXPZcpFxXWwUzYrnSyqzpluz+KleO8xSOlOTXikni8YoS+lr6PRF5f6QDC/XxK5fT6v2PMvfb/cd43rkOAKrO9Z9Lu/9CmmSTRG65/VcC2zhN6oeouiyGQpbEV8hNPnKkcwtU586dGavP+QQrKRK0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757446583; c=relaxed/simple;
	bh=Y/8rPp+U0q1tZqwPrHSggbNLVdWKhMmdbOATkZzfipI=;
	h=From:Date:To:CC:Message-ID:In-Reply-To:References:Subject:
	 Content-Type:MIME-Version; b=jPE/xueVF+IBfGd29+AtUY1i48kcILlWZYJCrNRMIKtUkdh0uZIQykXq40dfUJ99CNwFi0tJflW8LVWNY213FT7Rknb5Qn3w9nF9SHNDr3fl74fM1IYg6xIPV+sngpXayv89V77gFYYpiOqLR4C5spWcPVfENKFcqN03Cf1lIkw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PryngjAe; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757446582; x=1788982582;
  h=from:date:to:cc:message-id:in-reply-to:references:
   subject:content-transfer-encoding:mime-version;
  bh=Y/8rPp+U0q1tZqwPrHSggbNLVdWKhMmdbOATkZzfipI=;
  b=PryngjAeMRmmF6jaCvwnG8Zk/pPe10Gm6HmfnoXCNYtBVhbzwE4VBolA
   22thI927S++2dyBZgEgPQ651T5J+q1Xx1L5ZG/HDQH+NrI9bEopo5HNrY
   VQIOiu3Meh114jmT1pcRtE/aueQUrWpoKrlWXI3+6VAkeVgy9nH3j+d1V
   B53Uf0Ps4xvDGnhhauj95yT1cYFuQ/VFaknj+uOnp+En95gNJ2yyAcVtL
   aKpPA8QxPvJPip5pt4gIXT7MaoKC0Ng9qkbG8p+cnWOQPibjO3VwXkwhH
   /gkgIXTLfIbtPjdij7ibMSokYtip5mUzHpbdrnPA+34Md1i4FCqsXUMdD
   A==;
X-CSE-ConnectionGUID: 9cewAbo9TI2s3mIbgpgJUw==
X-CSE-MsgGUID: UZg9z7pDRf6nXDN6EbCGMw==
X-IronPort-AV: E=McAfee;i="6800,10657,11548"; a="62375477"
X-IronPort-AV: E=Sophos;i="6.18,252,1751266800"; 
   d="scan'208";a="62375477"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2025 12:36:20 -0700
X-CSE-ConnectionGUID: WcQzhxBuQ9+9eRm5i+c3dQ==
X-CSE-MsgGUID: fr/lFy1vRtKNlA7iAWikLw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,252,1751266800"; 
   d="scan'208";a="204164723"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2025 12:36:20 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 9 Sep 2025 12:36:19 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Tue, 9 Sep 2025 12:36:19 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (40.107.92.72) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 9 Sep 2025 12:36:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=exNFoQvYRr+KoG6oQkdUoYKolLzHzyuJ4MIPJgaWKFTgnCjGT1ttSNgpSobPk6Vs6crHlVgSTjje94nVBh3jJLI3js7eNlyjUwQAFYGtVhiJAvTqJBCT++sj3nw4k4gbuQLB2XF3wtaHDuF9SjlWydM7DRgmA/ROi0l3TuI7sWnxQUSMjzw1Fmp8LSkJCP3bruYcJjq5xo6BGjcpLUNFNRRSCU6eaLve4LIeokqi1s+psjNMF45D+gFgM8Z35mQuLxeKWgiFx0/SxkAJcMbna/uOCd1Ji8EoggUXUESCDnMZRgdLrNfqutTHPmxQmXI6HEkWiU/aaRkLCEPN7gbKYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dvm4xnJG4jwOoVrfVnOHS1+14hmjWvooEzAn6dF18is=;
 b=uHyAddTmjB4IaQiY/v5aEG2Q3PmrJVCR4RaUa5Y9MvZqYwHQH0vqiQDDxK4uLBE6UUrbhD5h13rLM1J/FQslOf6ZHOE9uNTqt+kd3i533Ioc/fB1VhUdDaYCCRElpK4u040QcxJkwoaUp/Hx/IBVQeWC+tJXih34dViVW3IUpPsyMvJ3qwonhj2qT0CDzDcqej9Vy2iVmKLKpGU1f9N4J1QVR9MJ5eXvBvnXQrPoiZuxjC8hewov2usPfdjjFTCFJTerVW9Nbd2FQdTehfeSGPdA8TvCxXLLb3sIzQV6dc3oojsl6IBX4UKCNCTc/0N2ujB2F1gJaPkRQ/Izmqy/HA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by SA1PR11MB7700.namprd11.prod.outlook.com (2603:10b6:806:330::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Tue, 9 Sep
 2025 19:36:17 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%2]) with mapi id 15.20.9094.021; Tue, 9 Sep 2025
 19:36:17 +0000
From: <dan.j.williams@intel.com>
Date: Tue, 9 Sep 2025 12:36:16 -0700
To: Konstantin Ryabitsev <konstantin@linuxfoundation.org>, Linus Torvalds
	<torvalds@linux-foundation.org>
CC: Mark Brown <broonie@kernel.org>, Jens Axboe <axboe@kernel.dk>, "Vlastimil
 Babka" <vbabka@suse.cz>, Jakub Kicinski <kuba@kernel.org>, "Rafael J.
 Wysocki" <rafael@kernel.org>, <dan.j.williams@intel.com>, Caleb Sander Mateos
	<csander@purestorage.com>, io-uring <io-uring@vger.kernel.org>,
	<workflows@vger.kernel.org>
Message-ID: <68c081b0c010c_4224d10077@dwillia2-mobl4.notmuch>
In-Reply-To: <20250909-impetuous-swine-of-chaos-2aa9af@meerkat>
References: <5922560.DvuYhMxLoT@rafael.j.wysocki>
 <20250909071818.15507ee6@kernel.org>
 <92dc8570-84a2-4015-9c7a-6e7da784869a@kernel.dk>
 <20250909-green-oriole-of-speed-85cd6d@lemur>
 <497c9c10-3309-49b9-8d4f-ff0bc34df4e5@suse.cz>
 <be98399d-3886-496e-9cf4-5ec909124418@kernel.dk>
 <CAHk-=whP2zoFm+-EmgQ69-00cxM5jgoEGWyAYVQ8bQYFbb2j=Q@mail.gmail.com>
 <af29e72b-ade6-4549-b264-af31a3128cf1@sirena.org.uk>
 <CAHk-=wiN+8EUoik4UeAJ-HPSU7hczQP+8+_uP3vtAy_=YfJ9PQ@mail.gmail.com>
 <CAHk-=wh2F5EPJWhiEeW=Ft0rx9HFcZj2cWnNGh_OuR0kdBm8UA@mail.gmail.com>
 <20250909-impetuous-swine-of-chaos-2aa9af@meerkat>
Subject: Re: Link trailers revisited (was Re: [GIT PULL] io_uring fix for
 6.17-rc5)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0232.namprd13.prod.outlook.com
 (2603:10b6:a03:2c1::27) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|SA1PR11MB7700:EE_
X-MS-Office365-Filtering-Correlation-Id: 68cd5258-410d-461b-be05-08ddefd8255a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7416014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?MVpDakQ3bUxxT1E0d1VWYjU5dmd6WTR4Mk5VZU9wQzkwbFBEakRyc0F0NUQy?=
 =?utf-8?B?RWFGampuelg4dVQvMzhBajhBRGJjem9tRzZvUEtKQ0Q2T3Z3N2pRUWpoNWxy?=
 =?utf-8?B?ZTRidm1XZEp5eUp2MVJCQlhIYjlUc1p5RE9FWmRlWXhwZTJqeThKSm13c0dK?=
 =?utf-8?B?S1h4cjZQYzhqOGpkcVRLYXVobWRhUFB3TEY1c3VNbkYvRmFGenlvMStvcGVp?=
 =?utf-8?B?QVdZQkhMRDg4cVdONTMxeDVveTFoVkwwWEtTa1oyVVVUbHhQK0I1UGtETDRY?=
 =?utf-8?B?U3pDYk5RVkJJRlhXVlB2ZFlIZDF6eEdrbEU4OW1oUlJjRVZwZ0NhUkNYcXdS?=
 =?utf-8?B?OEVzMUE5OFRVM0VRQmZKZ0VqOWxFV0VSKzlSNjBvTTdUZUdpclFuQWpYK2pH?=
 =?utf-8?B?dTBOMUhKcUJDK2d1Y2x6a0wwL1ZaeUNZOW9VZnB2eXVLK1ZKS2JSb252V2do?=
 =?utf-8?B?bXV1bXBrc0l3ZzFabXAyQ28va1NDWlNsSVVqeWd4SDgxZkg5RTBGV2pGYllS?=
 =?utf-8?B?K2VIekN0VWVMWkNUdmhEUE14VjcwLzBFVlBlSXJTdlJCN2FzVndRMU8vdXpw?=
 =?utf-8?B?OGtEVDlmU1Z5ZmlyL2dSc3VuUnNtcUxzNnpEb25maVRmK2tkL3NLWXdOZnJz?=
 =?utf-8?B?V3VxNjY1YnpYR0dhaXFRdnpWRFNPL2VYTzdrTEJnR2l6TGdETkJaWXMyeW5Z?=
 =?utf-8?B?NTRBMndvUzRabEdUZm5CZlF5N0Rpelo1bXF6b3V5OTJlYm1sTHI4ZVdESnlR?=
 =?utf-8?B?NllkQzlqYjZaTnBHR0hwNDlGaURpaU1CYTlKSTl0M2FMT1NCeklLM0ZNdDN0?=
 =?utf-8?B?SW4zVWpDWVpRR3lGczIvckdsV09jUGMwWlpBVmdma2s0Z21odXo5WUdJTlB0?=
 =?utf-8?B?bzBpTEpKT0FCMHlseHJCc3dVN0gwWk42WjlQVnRvcUNzWUplWldBUHZTVEdx?=
 =?utf-8?B?YXRhRTNWOFZaWUV6TjlycVJZbFhBZ05tOFdXMzhXeWovajBGYWlWRFRSWElB?=
 =?utf-8?B?SHFYUEtJYXZ6SUwxTGNQRU5ZUCtBemNrZ1B1cis1UjNJZTQvVmQ1SmdoZ2x3?=
 =?utf-8?B?TkxyQ2VlTUFUV1VKczJ2SFhFcEhKdWExNWJZMnlPOHJMNXRHODdzNXE4MHIz?=
 =?utf-8?B?aUZlVG5DRWRTbkcxTGlMZ0ZnQ3Exam11Z2FwcTQzSUowTlRaRThIR0dPWURx?=
 =?utf-8?B?VEtFd200NTdLOXErZmxGU2g0ZzJ5TUhzTzF1UmZBamVXNGEwQ0NqOHVHaUJR?=
 =?utf-8?B?b2dzcGp2aFkzd2szcnpsTXBxZ01oS1VQSGVtOU5JUjIvUzJtOFM3dVcxc3J1?=
 =?utf-8?B?a2pLMjlPbmRZVVBUbWQvK2NGK25vdHdNOWd3cThERzBPVGh2ZXdRcDlMdEtJ?=
 =?utf-8?B?NXZ5U2ZCTllrKzd3ZmR5RjRqRDRGUkpnWmRrWW14YkU1Tjd3QlN1R01sSkZ2?=
 =?utf-8?B?WnlKYk9aSmdhRnJBT2lXU1ZpeUFqSEEra3pIZ21nNXpnRkNNNEJkejIxRE0w?=
 =?utf-8?B?N2FPWTRsVWx2clhYMXNCQVJWek5MKzlwU2JOMm0xcTZleFd5dEplS3pCSVBi?=
 =?utf-8?B?UWdNZGdFcTZudFpwZ2pkTWFrdWg5S3AzWlkwN0k0cHRIdzhWRG5qYTJERk9C?=
 =?utf-8?B?NWlpMVhaQVBHRHVZNUVmcWVrVUNBVWt5dGtkUTRWdjFJQjVLU0JwZVRTaUdR?=
 =?utf-8?B?R01tc25aS2tRZmpjREN3aGdUMVJQbGRGZktnbmlhRWFiMTJwVGwyYUpzd2dM?=
 =?utf-8?B?MFo4ekl4MHdzZk5VNjN2VWdob2xYQ2p6M0VBcGVrTzJyN2hkY2ZuZzVMMnhu?=
 =?utf-8?B?TEM4aHBPS3N2VEovSVBQUVZhVGVMaVAvZDQzcmU0NGg3RzV2b3BOYVVmRDBz?=
 =?utf-8?B?ZDZNRzlTSmNlekxKRWZ4ODI5cEVOYXg2ODJkZ0xrZEswbDloWklmNGlIZnRa?=
 =?utf-8?Q?dTPhm+sMPOo=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Qkh1MStsY0ExdUtzVHZWNEUwQmRUelBxK1BGOEV6akhIQnkwbWpxRkRPeFU4?=
 =?utf-8?B?UzJnSExKNjhjZG8rUU1nelFYeTh0TmovUGdqOXVMb0NHM0hXVHlVd2RROUcz?=
 =?utf-8?B?WEZjYi80WXRUbkR3bVNveFVWM01kVHZsN2g4YlE4ZVY4cVNSVU1hVlJVRVRM?=
 =?utf-8?B?M1NCUGpDbGR4RlN5cHdWN3U0bURSaU1KNlBOeTRpN2RHTnN0VHQ5MUdiVlVM?=
 =?utf-8?B?aWtUSnlIRjcydHJmUVJMRFp4M1ZydEJRaXdUNlA3VXAxa3lwcDdPYjZqb1dC?=
 =?utf-8?B?WHBxSCt0VXh3TjZzT3ZOajMrUWpMRUt6VU1HSG1tWmpBT2MyNDZxanRwaEFl?=
 =?utf-8?B?OGhtM0NwR0hnc0lSSmdIUmlDNEo4Vy9ZUW5kdUdlOHAyY0hkUXU1M05Ydy81?=
 =?utf-8?B?K3BJcDRYbG1nVFN0TGYzUlQwMkw2K2wzNzNZdlJVakRhL2V4NE5GeXdtcTh3?=
 =?utf-8?B?WWk0NGt3Y2RDRXdFbzhlV0xYNXNvUGZENnZiZjJYUVhhSkxUQy9SRUhXa3o5?=
 =?utf-8?B?UmY3ejAyekVrN21jcmFldmxDamo4Z29ydjNXU0NLRzR6WmxFY3BNanQyRlEv?=
 =?utf-8?B?aTZIVW41QnRtc3pTUXVhN0U2cHdMQjhuSTE2TytqcE8xaEd2QVhNZjRJUjRn?=
 =?utf-8?B?MVRTTXk5L2pZTGJTRUdTb2JBeU45NGdHT0JFVWl4elZaNkVFYnZJMWxlWmhq?=
 =?utf-8?B?dThvWFhOMUZJYVEvWFVBQXZhRnlQeHBoUEN3dmlHd05tSVpXRVFicFl6ZWJx?=
 =?utf-8?B?OTlMVFN3b3lkcHdYUmJzVkMvUS9kTlgwZEhUOWRjMUREVnhQWGxub00yb1hO?=
 =?utf-8?B?Y3VuUjRNaWF3MXp3dlpYL3NPZDVhbHhuVWMrb3pOVnAyR2Z6K3I0bytmSEkv?=
 =?utf-8?B?ODc0MVRtQjVzZUtDdC8yN3RwUjY2TDVBWXFkVmVHcHJiWVJvTUFzZGJBd3hG?=
 =?utf-8?B?WjQ1R2U3aGxkUXdKK2psdyt6cDdoWlE2QnJ2VkhDYXhrNWg2bHNZK0MwelUy?=
 =?utf-8?B?ekNYekkvS2NweFZTRUlGd1RIZHozL3c5Wld6KzY5VmRwQmZSR29HUklnK2pX?=
 =?utf-8?B?MEN4WWpJZlRjSEFXeU5sa3VYR0JKQkczTUV4K0paQVl0djhub1ZYc1dINVJD?=
 =?utf-8?B?cmU4TC9PNmlkcC9Ta1ZRUXA1VjIwOUl4N0c4SUxneENqdEVaTHJVNVFIMi9Q?=
 =?utf-8?B?STZ4SFpHSW9CNUJkZHV0WU1Rc3d2N2pLUXBwUktSYWp1R2NlaHdCNldjcm44?=
 =?utf-8?B?RlhKbGk0RDhSK3ZjbUxsZzh4U1pCMnovdUk0WHpxSjdVWWV0Nk1zZmRhc2pr?=
 =?utf-8?B?TDBkNGVLQWptazZUK09UU2FNR2pEVG9SeG5KbEUxbFMxMGVPcjBoWlI2allY?=
 =?utf-8?B?NWZUenlvdTd5cXFtcHFJZHFrWkdnL0xCK3lsaHBXM3JIUlhhdkRxZm1NczZC?=
 =?utf-8?B?c0F1azJVVG1NYk5hYUtvM2tSQ24wT2JIZmVxT1hZa2VLM1Q0YlMveUZxd3FE?=
 =?utf-8?B?Qks4a210NGVVcEpyYlZXSjI1UlJKdEdldzhrVFBoSWpnM2kybW5yM1JicnJs?=
 =?utf-8?B?c2FJRllnWTZncXAvVGQ4T0hFc3ZFaXM2bEd0eWJWRUVLbkVZZnIvVDlzRERL?=
 =?utf-8?B?eFBXNmh1YzBJalVmdGhjTEpWYUZvdEE3dVV1UjRxbndGRmZXamcrWklJNEVm?=
 =?utf-8?B?Um13SlJjV01SQ0prbDhZaVE3UWFuejZkVGdrSGtUMDhOOHpCMDB0OEo0RmJL?=
 =?utf-8?B?L0pVZkZ1NFMzNTJmZ3NsMzdkNXRFbE9TVVVSZWlkUDBielp3UHo3N1hXbmRJ?=
 =?utf-8?B?bGhMWFZ2S2hsdlc5dkxDVWtOYVdSSi9QdGJsYkFmbld1TXoyN2lZN2hBSVJU?=
 =?utf-8?B?ZjRHb2N4MERRMVlvaTJkT0ZFQU5Ud2FicTR4cXkyZzZWd3dPM1Y1NUhrQW5Y?=
 =?utf-8?B?SUlDNUE5YU84YitzNEJ6T2lFT1Izd2M1MVAzRmhRNFAzczh4T1hmSlhvM3hi?=
 =?utf-8?B?ZUVXazZEN3lVTVRKUTRkWUN4WjJLK1cwLzQvR3R3Vk1JdHVFUUFpb0NmbUNK?=
 =?utf-8?B?cmU5bXFtcEJtV0hQU2QrYVVSdCtDNFcxTzZuREdEZ3IxNEpvYXAwRUVub1Vy?=
 =?utf-8?B?UWk3Wk1HZlB2T1Qvb2I0VmhHcVRIK1ZuWE5Sd2w2ckFtSDBTaFRkUkVlVVE2?=
 =?utf-8?B?Znc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 68cd5258-410d-461b-be05-08ddefd8255a
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2025 19:36:17.6743
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TH2cS3VBiSnHho2thMMrW3V2mxZJ5uhWz2L5FHm6gpjVF8boP/QgYBTYDvHfZgORf+enf8EexSrS3Y1HE/zsfOHERwQpHoD70pTCU9zYSA8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB7700
X-OriginatorOrg: intel.com

Konstantin Ryabitsev wrote:
[..]
> I don't have precise statistics, but I do have firsthand experience trying to
> make this work with git-patch-id, because this is how git-patchwork-bot works,
> and we can't match a significant portion of commits to patches.

What about something like this based on the idea that the same set of
files are almost never being touched at the exact same author-date
second:

time=0
for i in $(git show $1 --pretty=format:"%at" --name-only)
do
        if [ $time -eq 0 ]; then
                time=1
                echo -n "d:$i..$i"
        else
                echo -n " dfn:$i"
        fi
done
echo ""

For example:
$ ./lore.sh f10f46a0ee53420f707195fe33b7c235a1c0e48a
d:1752747497..1752747497 dfn:drivers/cxl/core/mbox.c dfn:drivers/cxl/core/trace.h dfn:drivers/cxl/cxlmem.h dfn:include/cxl/event.h

