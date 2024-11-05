Return-Path: <io-uring+bounces-4462-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B0E119BD258
	for <lists+io-uring@lfdr.de>; Tue,  5 Nov 2024 17:30:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3AA671F21EC0
	for <lists+io-uring@lfdr.de>; Tue,  5 Nov 2024 16:30:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1B137DA88;
	Tue,  5 Nov 2024 16:30:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="K2xPfX0P"
X-Original-To: io-uring@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 760C0157465;
	Tue,  5 Nov 2024 16:30:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730824217; cv=fail; b=J0XV8R2M87nezDhv2eYseWaCMcTa50o528+hB1zDlVtwhddrGhz6eeR6E2zYaXqVS2F1buaLt+uXUnAAJY0QF20T/YrEmaF8rK/YbcAfOYvuTOs1e4LiTjy+YbNLFRAut/mrsW/H/Yg9JZ+B/G2CgEdl4zqtOQY/nuZMkMQjxrU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730824217; c=relaxed/simple;
	bh=MOLUfk3CeFNNWw7GHhWQ1FfJvYBfEz2jpIkjftx68HI=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Zmi5vFVBEfIXSY0YDwefTs/82if/vT9/CHEX2fkXdnMSh0XeFWc/1ZVqODgx/9AhWATK48mwkGwV+BMbjhSohaJHFckiy/SdYAPsOvxL34fG2R1JEeXjGPLfeTO9UbvVqBU5bqg9l5DF4rSNuZwY8TshHDc35njQe9a3jfZwTKc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=K2xPfX0P; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730824216; x=1762360216;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=MOLUfk3CeFNNWw7GHhWQ1FfJvYBfEz2jpIkjftx68HI=;
  b=K2xPfX0PiqOACjcnwJvB6WOVN3nNcq4UwW5TDR3s9vF33KF1wc/P0Aza
   ocN18/4gRO1zL8gF7OQuEG/JHB8CkcoTI/x0GI9IIwdv5LBe9fC42VGfZ
   nJfwnp54YxlYzCM3QBi0v07ZWaJYfaKY0hTu7S66PdbHq6XAZW5wnvBiR
   ZYfYbgT2ZA3c4Opj8DpiI+pua93Lg/gpHuKnGWkRHr13UE0Z45C7UfNgi
   c/IMcsPfFtUXtQYPG08I+uyR3KF8WBhFSCo10sipvKAh1+50oa44oonIm
   Y7Gx+a8wfcB7EJWLh+4/LE0RvABwJmGiGd/goVph7GmkEk4pkiN8AIvV3
   w==;
X-CSE-ConnectionGUID: jo3K35T9TUW6DoQXHigipw==
X-CSE-MsgGUID: 835KvinsS1utY/shsx0x0A==
X-IronPort-AV: E=McAfee;i="6700,10204,11247"; a="29998524"
X-IronPort-AV: E=Sophos;i="6.11,260,1725346800"; 
   d="scan'208";a="29998524"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2024 08:30:06 -0800
X-CSE-ConnectionGUID: 6ZdDbjCpS1WIEiD56eY/tg==
X-CSE-MsgGUID: WXM6UvLsRzqReaWa2T8fIg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,260,1725346800"; 
   d="scan'208";a="89215825"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 05 Nov 2024 08:30:06 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 5 Nov 2024 08:30:05 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 5 Nov 2024 08:30:05 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.44) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 5 Nov 2024 08:30:05 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FY0HHLJIHs5ciwa7zz1QpUvXPysXM5c/6RX2tP9IFxiF1EslUOKkyo3yMRHXdm8TZz79K7bvkgW/K9ZZMKbPQIq/Or+6XCd83VTpQqTUyX0ZC3L3sc3whafB1ehsCydyAUSwlijYZS4/RIj/rboSpYCDtiRsKfkXswsmFdJK6d903KYf2rnwbp6DYpepRW+A2kTeU9Tbyp06PEOfziJkBDral9my7m6/tXQew+prfOvL29m/QMeYLeMaEcjvA1zXPAJTAFfHfG1Dvf8kQBU4YCQFBES+Bbelgx2trBcsmaFOtukndJlM2Ipzsu7smz4I4NT8oQtKggVHLxzQu1cyOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ocESmNPWeKpBKJslFgey3NacDaMQ7wqRR7l7Xl1fqWU=;
 b=GCAeBYW3KAX9vztj1vzvp/kOOd5AJRqY+Qghk/Zam6U7bYLcB63ybuEAHEyyZ+4hmII7JNm1h+87JUxb/3xBxwwKni+vdFUdGRgoRdke0iqVpQuC9OKIDUnzP5KJk5/W1Gk0vJatWVS47w/hFoQyU5IShv3tu5goxENcPZefY1YzFARwSssftbgFb66zv25pAZ//FTCOg5ekS+IIsW18Ka/SIPpNOz7HISDSkgsK7HEGnu81w3POrgDxiE3FvEZPMt8NnVzGA9RUDbUgEYHvCUk0Yoceuy/WllaLINY+fdmvCB4/0XsqHMS4O5hHdYuJTZAsqO6ctdQjcxxjt7H2aQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB8718.namprd11.prod.outlook.com (2603:10b6:8:1b9::20)
 by SA2PR11MB4937.namprd11.prod.outlook.com (2603:10b6:806:118::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.19; Tue, 5 Nov
 2024 16:29:54 +0000
Received: from DS0PR11MB8718.namprd11.prod.outlook.com
 ([fe80::4b3b:9dbe:f68c:d808]) by DS0PR11MB8718.namprd11.prod.outlook.com
 ([fe80::4b3b:9dbe:f68c:d808%4]) with mapi id 15.20.8114.028; Tue, 5 Nov 2024
 16:29:54 +0000
Message-ID: <6d227ee7-68c9-4d81-8efa-c91bbfede750@intel.com>
Date: Tue, 5 Nov 2024 17:28:00 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 03/15] net: page_pool: create hooks for custom page
 providers
To: David Wei <dw@davidwei.uk>
CC: <io-uring@vger.kernel.org>, <netdev@vger.kernel.org>, Jens Axboe
	<axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, Jakub Kicinski
	<kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, "Jesper Dangaard
 Brouer" <hawk@kernel.org>, David Ahern <dsahern@kernel.org>, Mina Almasry
	<almasrymina@google.com>, Stanislav Fomichev <stfomichev@gmail.com>, "Joe
 Damato" <jdamato@fastly.com>, Pedro Tammela <pctammela@mojatatu.com>
References: <20241029230521.2385749-1-dw@davidwei.uk>
 <20241029230521.2385749-4-dw@davidwei.uk>
From: Alexander Lobakin <aleksander.lobakin@intel.com>
Content-Language: en-US
In-Reply-To: <20241029230521.2385749-4-dw@davidwei.uk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MI2P293CA0014.ITAP293.PROD.OUTLOOK.COM
 (2603:10a6:290:45::13) To DS0PR11MB8718.namprd11.prod.outlook.com
 (2603:10b6:8:1b9::20)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB8718:EE_|SA2PR11MB4937:EE_
X-MS-Office365-Filtering-Correlation-Id: bf04af80-0c45-42e8-2e48-08dcfdb71435
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?ZlpGUDdMQ3dmTW9HdldEL0p2Y0s3eEZSdEx3SkRZSUZZQ0JlelBCK0wxVWZk?=
 =?utf-8?B?UlF1ZmF5d05yWUZGdHl5R3Y0dFdwUko0bEpwU1U1R2kwenM1UzZHcEY3Z1Vr?=
 =?utf-8?B?ZlN4MUdoK1k4Si96ZHFCaWtQOG9qbmtGemF6Vk43RUdOeTVJc204bTdVWUxt?=
 =?utf-8?B?MGlEbHNCWDcrSVBTbUM3S0x1Qm5vVEJhbTBKZnF5SW83TkxwY0t3RDRlUDdD?=
 =?utf-8?B?YWVvWjAySWFHNklPaFBrS0p6S1lZSjR3V1pkTVZQSjhUQnNUdVZ3RnpUeTJh?=
 =?utf-8?B?a0NjZEswL0F5ei8xQW1PZ0lUd3Z5TUxrQys4T2dpSXZuR01UVWNRWGw2MXJG?=
 =?utf-8?B?dHh2K1MycHFPNjZpaVdaSzZoYmlKemkzSEkwSmY0clczWitVcW9JNFZSUGFS?=
 =?utf-8?B?UjVLZDRhd2IrRUtUZVZTTU5IZ3MzUGtsT0J0YXV6dnFXc2dEMnlZbklBYWRT?=
 =?utf-8?B?bGdtbDNmOHJDcWZFU2dmZGQ3T09GSklIZVI3ZWV6TTIvQjJVVlRKQktZSHdW?=
 =?utf-8?B?eW1RZkhOOVh0bU1pM2h6dG5pMG80RmhycTV6ZTJMUlQyb2tuemhacDFGU0Nm?=
 =?utf-8?B?aTBqNDJldGZ6c2tyYmpmVDB2a2g1R1YyL0VSdFRkUWRjYThONEhXRkRQdWNG?=
 =?utf-8?B?U21JbXdJb1E0UHNLRS90b3NNNkpMMzMzcmwrN0U2UE4xUUJwVlN2TWMzYkND?=
 =?utf-8?B?elh5alplM0Zob21nQXVjWGlVZUFXY0J3SzFrcWNSZnYzL2JhNHBMMURkODlR?=
 =?utf-8?B?TjhyR1lWRzlNSTFkbG9sZkZIRzBhUHpIVC9hM0l1N3lRVVRtcGgxSjFFY0lt?=
 =?utf-8?B?YUVscklZSCtBV0M1TDMwcm84Q1RuT2hxZ2lyRGM4OXRnZHBudlVCdm9OOWtz?=
 =?utf-8?B?N3NoYno0K2VsY05vRnEwNCtSVk1VREF0d1FrTG9CdHVmZkhnemxnUkxXbWx5?=
 =?utf-8?B?aHZ1d0lzWGZXTk1kS3FGSHRUUmtTODA4OGRrUWpuMUVRMGk0ckpBYjA5RXdO?=
 =?utf-8?B?bXFZOEdKRllYWk1YbFNnSDlPSUQrVFdFZlVRL1kyUHovd0dpNmFCTHhGeDU4?=
 =?utf-8?B?V3A4U3d0VEV4eGpJaklzZ3hIWVdUakFHVTVnYTU3UjNNNnBwenh2amRUbFho?=
 =?utf-8?B?dC9IZWQzVVlMOXJOVUE2MHhSU1ZXSWFpNEc1ZnI2VjFMd2NEcFZjbDRtcXlj?=
 =?utf-8?B?S3Y3ZlZQemJrb0dFWTVqUGdMK3pTRnpBY0IzNmdlK2pYMG11VG50Z2ZTT3lR?=
 =?utf-8?B?VGdndDNLK09MaEhWV1Jwa2hnOTEvT3B1N09FNURpNGhHODc0MmNyWVhPckNN?=
 =?utf-8?B?R1hoNDhFSjF1YmVBNFpvSXVndk54SXlkV0tZY09WclFPRTIreHl2b0h3V0JY?=
 =?utf-8?B?RzI4d2YzLzVSd2JaYmVINFV5VDVoc3kzQVQrcTJZblFxRi9JYkE2eWlBaGVO?=
 =?utf-8?B?a1ZpUzYweW40ejh3ZzRiKzNWdjRaSXpKSWpxM01KOVNoWmFOQXI0bjdMc1ls?=
 =?utf-8?B?L3llVFNiVnNCQWFwQTRHU2JUcVJPZE9jVHBlZjFPQnFyYkZwdURGMjlxYUUv?=
 =?utf-8?B?TlNlRjN5T0RiNWZOVFdmV1h1ZFo2SGdFRkN2U21aWWJ6cUVFYXZpb2pQdUxX?=
 =?utf-8?B?YVlLVkVsR2xGMVArcEZlcnp1dGkzRlpnUXZsbGlmKzNnUkZhUWVmRHg0VnhE?=
 =?utf-8?B?UWx1VldnN21wNEJlYVFDRDZGWlhwK01TTWtQaVhEWGhHMWlXcDBPa0k5WEl1?=
 =?utf-8?Q?qCnrA2D3yRvHcfJOnubDhscdEP7aJP8aV/4yoYv?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB8718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?b1ZJWTg5RTVSaDh4YUc5V3l0ZjkrM29XbHpVNHJjMTk3Tm9kcDFnWVYxWS9t?=
 =?utf-8?B?VE9jQUxlNU9EWDRHanlXMHpCZUVtaFpsUFlHY1lJQ1U3ZVpFWjgweUxaQTRL?=
 =?utf-8?B?ZGh6Y3BxNWJBRTdadkZ4QnE5R3lzRjhINXJVRmZrUTN5TVVuU1RNYWZpZ0lC?=
 =?utf-8?B?ZVZLTjNkTDFDSkJCbnZzbTNVNm5yWm5RSktZZlc4V1RTYWhhZ2UyQlNqWnZy?=
 =?utf-8?B?TExNNE5STVNHZDhFdUgxYlJnTkcrSW1wR1hYeEpvbjFzM2pVMUFPQkNHaW5k?=
 =?utf-8?B?ZTFDZUNOOTBteGhJdGRvNnV5SW5FMnE4V0gzSXVKazlWcFkxd3JsRCtpaTE2?=
 =?utf-8?B?YlBsa25Wamt1SE5Tb2ZjOTZVTFN5T2w3eTZTTGQ4ZjF2NjAwZVVyUXc2b0pK?=
 =?utf-8?B?bURTSXVYbEJRVTEzZS84eDB2VXMzMjJFNFpjVVp5NjNTRXljcDRCQm5RSWkz?=
 =?utf-8?B?c3BPWkROR3JiVWp0K2RhdzZWS3hodzFFU3ZjSTFkN3VKRVdlYVRiQW5rYTFl?=
 =?utf-8?B?elRFS0lKSFVpTDlKcUJlY2RpWlpxS0RhK0xjTjhIWXZ6RlN5bFNqVGVCNXNU?=
 =?utf-8?B?RDlVUkp3RTQyVHZvSHI5UUhRUnpaNndYWGVoekMwdnVJUE9Fb21NMGNMRHhZ?=
 =?utf-8?B?cGR1M3l1RTdVVkZPbC9qdTJwSXdXV1MrNDMzRnl0TURjQ0dScG4zakx3N2x4?=
 =?utf-8?B?bkxHODUvNXRhNVRyenpUYXVWTzFidkhZWWl6WUJNNUV0Y2dEK3BUaVJDNFFu?=
 =?utf-8?B?QnlXM2hXcGtUQzlESXJ4NHpQU3dDZjkrSDRoYlE3bmZpUmJWeTRsd2lXT1FW?=
 =?utf-8?B?elQ2ZEhtM0dSVTRuMUE4VXhjcTc1TW5pdS9qb3FndXF5VnhEQVI3RTQxeEtC?=
 =?utf-8?B?dFkyYkFBeWtxRU43VHFsTEQ5K0lHd3d1dkN0bVM2U2RkYXlONWxjS2N4dnda?=
 =?utf-8?B?RWZCMG4wd0JVVFMvNkxUTUVKaUhxZGk2TEk5RFB0QlBXNTJheUMxekFJNEtZ?=
 =?utf-8?B?U1dsV2cwdFNpMkk0dzF6Vlpaazg1YVRoZlEzNXpuQVRwdFVBNjQvRkYydzJY?=
 =?utf-8?B?dkdwRmFveVJZa0dJa1FlejI2b1g3VUNKNjZodER3cWIrbXJha29kbWlNNE81?=
 =?utf-8?B?TjZ6YUxsUmkxZ2lZYk9mdk9LcHhFZG1zRURpejlWSWZmWEdWRXUvUnVVb3dj?=
 =?utf-8?B?QkdiUFFyUzJvVUJVWnA4NUJSSnF3RkhwYUtFTCtBdytEVStBL3hyUnZJTExy?=
 =?utf-8?B?L1FOSEduUm9TS3oycEhPbUFRUmJ3anJFTGsvRm5pelRJSGpGV2JTaDdvc29w?=
 =?utf-8?B?SVNDQWRHeFRNZGdKbjFGODFqc1NyWHJ2OThCVzl0RkFERi9MZm1kMExOMXJB?=
 =?utf-8?B?MTBFZ1crVjhFa0RQbUZJZitaa1BDamxLOUlCL2tGemhlaUpFWWpCdUcxdFFi?=
 =?utf-8?B?Z0JVbGlMdFAyQWx4ZVR5OEVVTDg2ci9QUjNqb0hKeTFrZ2JaT1FwaEFvUnly?=
 =?utf-8?B?NUkvN1lWUkNQV21OSUhFQVpxd1VXbEtYd05xMkxwUk13VUJFMERUU3IrTmFL?=
 =?utf-8?B?RU94N0pieHl3SGxodVRUS3cyRzQ4TW5haXVzZk5STjFCcUVtQytxTytkdWE4?=
 =?utf-8?B?M3Z6Z2VMaUtxejJXR29XeU0reDJlU3BpOTRMU1dTcndiT1RFckR0dzdXV1dO?=
 =?utf-8?B?K0ZaZ3RhWVdPS3hwdGxxNUV2ZDJRQ3IxQ2hBOG02VWxaNzN4N081djllSHdN?=
 =?utf-8?B?L3pWaktrcUozaXBaQlR4eUZMSmk0ZmpzWUNTVFNqTUpMeC9hWGNvUmVwQ1Nt?=
 =?utf-8?B?dTVGQ015MCtNNjJ0cXZUenBoUy9EZWp6QzZjQkFEZkNQV0ZKVXlQUUtMWU5q?=
 =?utf-8?B?bHlGUkhrTjZNWmJGUlNuMGRlRDM2QjZ5TVJ2ZUZYR1NtZUxncE93RzJWbHAw?=
 =?utf-8?B?aTI2UEhxenIvdTA5NG4vYTdHYTd1cy9TOFlSaXhZSG95R0M4VUdYZXFXekNN?=
 =?utf-8?B?YjNRZWRBb2x4S1FrVmx4TWUzMml0OUx3UFN0SElJUENEc2ozc3lmUVh5RnpK?=
 =?utf-8?B?U1Bhb0hQWjVNNmtKbllJVEYxVzZ6ZElETnNZazhaVy82Q0s5NmxRbHVndkx2?=
 =?utf-8?B?Z3cwaWtDajZiK2E5NGMvSDVONzcwcWp6NnR4VjZIQ2J5bmZ5V1dRNHVJU0gr?=
 =?utf-8?B?cGc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: bf04af80-0c45-42e8-2e48-08dcfdb71435
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB8718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2024 16:29:54.2340
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SUdi5RABV5sHkE8fgJkQq6CWfDkCEBYIiFjUyILSzf2hwFvxoqkNmhlF2nO2HQzkHLjs0F+LErMBi+nSxN0STGFcHvuF9r7qk0+KHB9Z3ek=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4937
X-OriginatorOrg: intel.com

From: David Wei <dw@davidwei.uk>
Date: Tue, 29 Oct 2024 16:05:06 -0700

> From: Jakub Kicinski <kuba@kernel.org>
> 
> The page providers which try to reuse the same pages will
> need to hold onto the ref, even if page gets released from
> the pool - as in releasing the page from the pp just transfers
> the "ownership" reference from pp to the provider, and provider
> will wait for other references to be gone before feeding this
> page back into the pool.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> [Pavel] Rebased, renamed callback, +converted devmem
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> Signed-off-by: David Wei <dw@davidwei.uk>
> ---
>  include/net/page_pool/types.h |  9 +++++++++
>  net/core/devmem.c             | 14 +++++++++++++-
>  net/core/page_pool.c          | 17 +++++++++--------
>  3 files changed, 31 insertions(+), 9 deletions(-)
> 
> diff --git a/include/net/page_pool/types.h b/include/net/page_pool/types.h
> index c022c410abe3..8a35fe474adb 100644
> --- a/include/net/page_pool/types.h
> +++ b/include/net/page_pool/types.h
> @@ -152,8 +152,16 @@ struct page_pool_stats {
>   */
>  #define PAGE_POOL_FRAG_GROUP_ALIGN	(4 * sizeof(long))
>  
> +struct memory_provider_ops {
> +	netmem_ref (*alloc_netmems)(struct page_pool *pool, gfp_t gfp);
> +	bool (*release_netmem)(struct page_pool *pool, netmem_ref netmem);
> +	int (*init)(struct page_pool *pool);
> +	void (*destroy)(struct page_pool *pool);
> +};
> +
>  struct pp_memory_provider_params {
>  	void *mp_priv;
> +	const struct memory_provider_ops *mp_ops;
>  };
>  
>  struct page_pool {
> @@ -215,6 +223,7 @@ struct page_pool {
>  	struct ptr_ring ring;
>  
>  	void *mp_priv;
> +	const struct memory_provider_ops *mp_ops;
>  
>  #ifdef CONFIG_PAGE_POOL_STATS
>  	/* recycle stats are per-cpu to avoid locking */
> diff --git a/net/core/devmem.c b/net/core/devmem.c
> index 5c10cf0e2a18..01738029e35c 100644
> --- a/net/core/devmem.c
> +++ b/net/core/devmem.c
> @@ -26,6 +26,8 @@
>  /* Protected by rtnl_lock() */
>  static DEFINE_XARRAY_FLAGS(net_devmem_dmabuf_bindings, XA_FLAGS_ALLOC1);
>  
> +static const struct memory_provider_ops dmabuf_devmem_ops;
> +
>  static void net_devmem_dmabuf_free_chunk_owner(struct gen_pool *genpool,
>  					       struct gen_pool_chunk *chunk,
>  					       void *not_used)
> @@ -117,6 +119,7 @@ void net_devmem_unbind_dmabuf(struct net_devmem_dmabuf_binding *binding)
>  		WARN_ON(rxq->mp_params.mp_priv != binding);
>  
>  		rxq->mp_params.mp_priv = NULL;
> +		rxq->mp_params.mp_ops = NULL;
>  
>  		rxq_idx = get_netdev_rx_queue_index(rxq);
>  
> @@ -142,7 +145,7 @@ int net_devmem_bind_dmabuf_to_queue(struct net_device *dev, u32 rxq_idx,
>  	}
>  
>  	rxq = __netif_get_rx_queue(dev, rxq_idx);
> -	if (rxq->mp_params.mp_priv) {
> +	if (rxq->mp_params.mp_ops) {
>  		NL_SET_ERR_MSG(extack, "designated queue already memory provider bound");
>  		return -EEXIST;
>  	}
> @@ -160,6 +163,7 @@ int net_devmem_bind_dmabuf_to_queue(struct net_device *dev, u32 rxq_idx,
>  		return err;
>  
>  	rxq->mp_params.mp_priv = binding;
> +	rxq->mp_params.mp_ops = &dmabuf_devmem_ops;
>  
>  	err = netdev_rx_queue_restart(dev, rxq_idx);
>  	if (err)
> @@ -169,6 +173,7 @@ int net_devmem_bind_dmabuf_to_queue(struct net_device *dev, u32 rxq_idx,
>  
>  err_xa_erase:
>  	rxq->mp_params.mp_priv = NULL;
> +	rxq->mp_params.mp_ops = NULL;
>  	xa_erase(&binding->bound_rxqs, xa_idx);
>  
>  	return err;
> @@ -388,3 +393,10 @@ bool mp_dmabuf_devmem_release_page(struct page_pool *pool, netmem_ref netmem)
>  	/* We don't want the page pool put_page()ing our net_iovs. */
>  	return false;
>  }
> +
> +static const struct memory_provider_ops dmabuf_devmem_ops = {
> +	.init			= mp_dmabuf_devmem_init,
> +	.destroy		= mp_dmabuf_devmem_destroy,
> +	.alloc_netmems		= mp_dmabuf_devmem_alloc_netmems,
> +	.release_netmem		= mp_dmabuf_devmem_release_page,
> +};
> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> index a813d30d2135..c21c5b9edc68 100644
> --- a/net/core/page_pool.c
> +++ b/net/core/page_pool.c
> @@ -284,10 +284,11 @@ static int page_pool_init(struct page_pool *pool,
>  		rxq = __netif_get_rx_queue(pool->slow.netdev,
>  					   pool->slow.queue_idx);
>  		pool->mp_priv = rxq->mp_params.mp_priv;
> +		pool->mp_ops = rxq->mp_params.mp_ops;
>  	}
>  
> -	if (pool->mp_priv) {
> -		err = mp_dmabuf_devmem_init(pool);
> +	if (pool->mp_ops) {
> +		err = pool->mp_ops->init(pool);

Can't we just switch-case instead of indirect calls?
IO_URING is bool, it can't be a module, which means its functions will
be available here when it's enabled. These ops are easy to predict (no
ops, dmabuf, io_uring), so this really looks like an enum with 3 entries
+ switch-case ("regular" path is out if this switch-case under likely etc).

>  		if (err) {
>  			pr_warn("%s() mem-provider init failed %d\n", __func__,
>  				err);
> @@ -584,8 +585,8 @@ netmem_ref page_pool_alloc_netmem(struct page_pool *pool, gfp_t gfp)
>  		return netmem;

Thanks,
Olek

