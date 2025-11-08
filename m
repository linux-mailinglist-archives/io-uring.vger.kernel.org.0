Return-Path: <io-uring+bounces-10455-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E19EFC428A4
	for <lists+io-uring@lfdr.de>; Sat, 08 Nov 2025 07:54:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5B9CE188E956
	for <lists+io-uring@lfdr.de>; Sat,  8 Nov 2025 06:54:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D99E02DE718;
	Sat,  8 Nov 2025 06:54:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cxCP9H+Q"
X-Original-To: io-uring@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C878A2B9A8;
	Sat,  8 Nov 2025 06:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762584850; cv=fail; b=GbOSUBy8FgXppl+p4qs/04UIW0iOXMQHv6QK+nuQttI8NW6J1GpK/sUVVwraAi1sWKVXaSz1qpFxi3fSncfKgrmR13qFFkd0BuPLKxXmISz0tzoPaaTYPcTJ2fxSp8kczomc0KiZLCOdjy+HqJR4qM6+56IOK2WcwLcFzloVLEc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762584850; c=relaxed/simple;
	bh=RmRtlckkW9sLkVWU3/DDclSk2PHTrLhTJWYYx2BL9dk=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=GwsbANfTZbRtXzSBYuFsaQEsaLi/I+e1dD6PdQkJoVawf8rAEF33XIdAUlglXRxJhU4GFYwrd/tgpG+j93gMfjzvlXUDAf/m/Sfvb4JNK4WB1Ec8aTve7Y22e3TTlmoCSqSD2uHedPtZORnO/XoGI8MmqGsCn2mewemOhursH24=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cxCP9H+Q; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762584848; x=1794120848;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   mime-version;
  bh=RmRtlckkW9sLkVWU3/DDclSk2PHTrLhTJWYYx2BL9dk=;
  b=cxCP9H+QwG1VG1M0oZnOSvKW6qYalEaafdVVmGWXer8LjQM+DIzHviet
   /wDWRPM9/Y70USgWbIpKPvLEgbs2Cwwtk2HjL6HxN87FVjmP8tzLsD35a
   7KroDn7LY7nabgN9/vEzy57Q2E38VC4ubulenASiWR53U9idaIFMZJgyp
   Uld9LYTR0CFm4FvxPggVf58mQLaogVgbNuGLEGzHeGzVJZl7FUR5IjBaC
   cWV7jiSdG7ruA8swc6xtfHs7nASgpBPQYSc8jhBXJqkxMWERKZ1JA3AEf
   OGwLwHMDtB9FoerouNEVAaj7JJ3LprdvnEzyrF/4kG6plIj2jSabrMc1X
   w==;
X-CSE-ConnectionGUID: TJrXldCVRhiAV7QzXMMJow==
X-CSE-MsgGUID: 6xn/3CDjRk2iPATs31NU6Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11606"; a="68585873"
X-IronPort-AV: E=Sophos;i="6.19,289,1754982000"; 
   d="scan'208";a="68585873"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2025 22:54:07 -0800
X-CSE-ConnectionGUID: RR7R2BMkRbq4km0yQWY6IQ==
X-CSE-MsgGUID: 6kSYDut8QeeAbPd3RZKdyA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,289,1754982000"; 
   d="scan'208";a="187966333"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2025 22:54:07 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 7 Nov 2025 22:54:06 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Fri, 7 Nov 2025 22:54:06 -0800
Received: from CO1PR03CU002.outbound.protection.outlook.com (52.101.46.69) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 7 Nov 2025 22:54:06 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Tf91JZHLhLOXTtLvAmPQRPEi9U1q99gfBhIukgxff98LM3I2e/nhD1qq2uj/OxdTgfufZ8CIQ9lg0CM71l8CTS+UVcQzpcMtzndcGQKTg/u2vxZKDN21pYF6i9yz/ieHJjmlCnotd9Oxi1OgFh83hYpUwlg5Sb/mRmMVKJc6sObxhTEPTwfKfGI3OdZLbBSujMGQjqPkXw9R2/Z9uAe7pebCiocJnhY0WYBlprToBJBgs3G9TO08DTvNT39qMVjWxGQLp8JRZmSPOJtYt/uiGmWVW8B58cueUopPK9pp3xltayE/5AN8gKywT7Qc4cwK7ZNpXTPH/kibYGjQXL5g+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wfB0n2aBnKSdn6+spnoRPt31tRUtDJGUrfwJhM9XPNY=;
 b=I5qahaeGbpVzI7YLASj+LmaCzOoASsscHLYixW87q8wXQer7IOTK4qN88vUpEDX42vSAph9bkIlpI2bqJlBibor+k44rak1Z5Izzi0ohmZxWz8T1g/gJ9AKTsndzCQEj/pwNn/9SK0ZNKLDqcyp9RhYdEF6O6BQtWWrCptymlCWSHSLWUllIXzH1h11YZ6wUqdjEQI59Zq2N8FGrxCPkeJrs4jpEY1FcjPEhO8sJ7rXtEe5/QjEmj3O/xV/NK4dZs6kfBHP1VO+Q5wvYpkSEShh+oukZOLgU4bIBL8sDA3u3iD3XQTkJskLRaTlYIa2mjRpr8zxlUT0MWVbLz66nXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BY5PR11MB4165.namprd11.prod.outlook.com (2603:10b6:a03:18c::26)
 by PH3PPFE80710477.namprd11.prod.outlook.com (2603:10b6:518:1::d5a) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.13; Sat, 8 Nov
 2025 06:54:04 +0000
Received: from BY5PR11MB4165.namprd11.prod.outlook.com
 ([fe80::d9f7:7a66:b261:8891]) by BY5PR11MB4165.namprd11.prod.outlook.com
 ([fe80::d9f7:7a66:b261:8891%7]) with mapi id 15.20.9275.015; Sat, 8 Nov 2025
 06:54:04 +0000
Date: Sat, 8 Nov 2025 14:53:54 +0800
From: kernel test robot <lkp@intel.com>
To: Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
	<io-uring@vger.kernel.org>
CC: <llvm@lists.linux.dev>, <oe-kbuild-all@lists.linux.dev>, "Caleb Sander
 Mateos" <csander@purestorage.com>, Akilesh Kailash <akailash@google.com>,
	<bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>, Ming Lei
	<ming.lei@redhat.com>
Subject: Re: [PATCH 3/5] io_uring: bpf: extend io_uring with bpf struct_ops
Message-ID: <aQ7pAuXIw11QfXm1@rli9-mobl>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251104162123.1086035-4-ming.lei@redhat.com>
X-ClientProxiedBy: SG2PR04CA0157.apcprd04.prod.outlook.com (2603:1096:4::19)
 To BY5PR11MB4165.namprd11.prod.outlook.com (2603:10b6:a03:18c::26)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR11MB4165:EE_|PH3PPFE80710477:EE_
X-MS-Office365-Filtering-Correlation-Id: ec6a77ca-6ed1-4b95-7b50-08de1e939af2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?b0hj7SxWWt4TEyz6xIfcX4Uv6oujtjEnV9ctrz1fTGk7UvDvQeDtTLe0cljL?=
 =?us-ascii?Q?vXR9olHpjeCs+G064j7POafoKb36bhpJTM1M3dOt9npD1YiRimLrBEZwetd5?=
 =?us-ascii?Q?Do2R8V3HeMQUb1s2R5GHEnhZGUetg7m9oJoTXNHO9Q3oYTqmRu0NsVVpoOwf?=
 =?us-ascii?Q?EnUXClK9MRFiZ6jEVH5IMolhEqfxPQ644oAtlz8JWiJ2c/ikCd2Fi71/fDdq?=
 =?us-ascii?Q?O61HVATnKuheBdFizeaYIdBo885+BDCUBjLtHn0HaUe779OzELgaeI1eKzFx?=
 =?us-ascii?Q?pMy3IbeMFnQI4fHOk6ptrU9cE0hUvZu5dqMheYkiBvw9g5KxidPFN1gS2n1P?=
 =?us-ascii?Q?IdvsZmg3ymffNMR7HMlDKQhj379DILySyGzCt+xnl+YguxHarwn8x+RRfGj8?=
 =?us-ascii?Q?VLqZwCE9GK8d7001h7xh8Muts+kwQtQsuMWCSIUS7s7m20f8HzuCzWUCcXPM?=
 =?us-ascii?Q?hR9zJgQUhV8F8pgNFA22S9W88wmg4thfxDCEa3Kb2hYLX9Y8KyGcniYlLGWQ?=
 =?us-ascii?Q?J+x0PvExhat0pAKX9IgFcuEuEq8NxJuJatlH7TgEkiD9RxBdKw416E4nx2Lb?=
 =?us-ascii?Q?HYKJ8glFxVBn9tR6VHJWfDaRgEVMaWq4jciP6OHJKJrCPQYnwSP1iJH3tCVN?=
 =?us-ascii?Q?Au6UISe6NhgSDl2p47iHzkUl5Pk4FgIqo7hIr09Ray5B3YlM0ZnLalnGWxJ8?=
 =?us-ascii?Q?6OrbAW4Gy3oAP/potMPHdQrKgFildrvAQNxSWidmo1569OLSuvhUDhqoGIi5?=
 =?us-ascii?Q?UtSz2qYalX88JsPPl/h5FPOjKIJLfOehUufUJQLj3RGhiH1wmsX0WEpZ+DP2?=
 =?us-ascii?Q?1jbxKrFKS2sKrP+jKooZZ4Rn7irLWzWdB75igLtbiU4gycg9evwJsy0NqIXo?=
 =?us-ascii?Q?nWsKKvoyH2be8CYrlVnyQ1CQihvpQIkAIG5Gta2Axe6HIe15Cwj8CtG+sQQl?=
 =?us-ascii?Q?cXeyBu50g+XVSqB3JqxbTxhDY3jcnnF5rZzp9s1cxcZXGKxk0fjP3GWDJBEU?=
 =?us-ascii?Q?hPGPFoKSz4pEIZ/eYl2bo24Ggnw2V2q8c5+4bTNW0opemKzO4Fng9xxcnEj6?=
 =?us-ascii?Q?P5mmCWoVvmEZzmcYUa4ekWw/2nr/NWZPSVR0ZQ2kary8eH+GIApPzrqcT25g?=
 =?us-ascii?Q?ZSdvTZfdPUnTuo1Lp7ygV6Cgl2IP0u9SZtiM7f7qDvKq4dYqlIDLAcjG+887?=
 =?us-ascii?Q?YSnJzyD79EJZ9UvxpObJ8ZFFT/t7jU6ilNpnGTIamka38+1JqlobEFC0nVdD?=
 =?us-ascii?Q?BKQ4XkFE8pPNQ64ot9Ofm9XLIbxXfQvyGXVOacQs8J3BmdXj04jRDfFlOnNe?=
 =?us-ascii?Q?A73zWoGjga3LjEFrdrrYCZZhAZEGNCplsy1RJsC//g9YEZ5WYkq950H68A3D?=
 =?us-ascii?Q?Akiz5KyoxhZJEHA4Vv8bbUlg+rd5nU4XNYiRccIh/eq2lnLESONPk4YhVy7+?=
 =?us-ascii?Q?LyWrUh7FIbxDygTeLXxfe40ToiuUA8RYsqUb++HyDDZMy2yZsSiJcQ=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB4165.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?u1aGjgJPgaFMqwLZOi5Kt2YDKJ5M2CnQyRxy+f4ZJS6Yez8CugdTT6zRNEA/?=
 =?us-ascii?Q?g1+w36UAGHMe6g8w+YB7V1voe36/fq2H3U1Y+13C5PlwMwzmRN2QX6HuE52i?=
 =?us-ascii?Q?Tv7zCilslNot4XOqfyga+lxHPsmXQMsy4bKXnOcsLMVMfjaLm6UXM6XlRACG?=
 =?us-ascii?Q?rRAFUQlEu+gdiuzzfF5yJ8ELIPfVt7Vs6GChaaxTlNh0JEBIj/aH6TD3Gql2?=
 =?us-ascii?Q?W/pvxRByVN+2oG+JoScUTpYduYTPyNE4D59Xmf+TA44sDPCKaF65Ul3l3rHY?=
 =?us-ascii?Q?niRrWwLJzWM6wxmEgcYN/ckI+YGFSk707ml0U5JE+0tKqyGpSO8pYWqTiyp3?=
 =?us-ascii?Q?tJ5KDzxf2VNHBFxhSKqJjl47X+Bxvcp3513w/TJjPzAUQJk+ipqNzHZQmtHW?=
 =?us-ascii?Q?yPi6UFl0A0A7GtFkYa+9bc8KVeLuCg0Q5M3z8euKBxuO4X+mB+kU9oc/Wuax?=
 =?us-ascii?Q?bhF2NpUAp8Dj2FMOM6D+ZO+HhuiTCtGglu71xJzk7B/afg7E6vB50wkF2+Dg?=
 =?us-ascii?Q?Haikl15V0eSD/yVHDATm/Au5oN/yF1UCGRrbvXuO2+64sWBVQNguLgVN+vGF?=
 =?us-ascii?Q?lg1yk+PYZZBfW8o9OMLlg+BkThooaTDKjBJIf1mk0w6D1vS9ki5W67azsjz9?=
 =?us-ascii?Q?ZxY4vvQ1w9QMGXBdbIcWRvo4kdvmB6WW0HOoxTPlYKWoeJ8a+6X4p+ZFS5oS?=
 =?us-ascii?Q?6hSmDXasWuMTFKeO6g4X1DId/reG/drwmsWb3TSCvbnoWz22zj3NAChuU1RA?=
 =?us-ascii?Q?6pDoBRA3DqXijlhlJ9xnFOCR89Xeca8oemOns+Zin923DjY5Jl8mVIy32MHY?=
 =?us-ascii?Q?KrtAiefBi/V5gR/FWEDrZyM1Yt5mo50rCb6vmGIHUAvqi6UQ774R5dOCXUEy?=
 =?us-ascii?Q?GyPSV1Fa3B8a+mihlYEwldilFH/hCuv9PLa0FHhLoO9+gkNj4HaarR0ChHD4?=
 =?us-ascii?Q?NKYE9dw1V/2ahp00inGIB6b+mKxv9QBqwvBJ2KAeATSqHfWmEOFgiX7fohfn?=
 =?us-ascii?Q?CDZ5HnF61tLqgWDoIabcVc7EOzRNe7FS4CY3kYyKZ77G7sFURBc4sAbr7DRL?=
 =?us-ascii?Q?k6fxreWQa5TeOROmwixPlbetkTlQ1Ec1Vk8c6fdgc4PBNDLpIIp5VhkeaU44?=
 =?us-ascii?Q?Lz3OGgcnID0BW5qppJfOscBAcGaMvMyvCOa809WMEFDD7q+iPRvU3oTEKhgN?=
 =?us-ascii?Q?xXmc/6UvOE4EohWVYLg6j7rzy6hRhNbb4rQDLFHa9O6krIhidsQWuIAoeBAA?=
 =?us-ascii?Q?3G63tvSXMtpt/DOKs6lbXDVq2LO2NSU6vRE718JVH+ejBJLHdt67DZ0kXQnb?=
 =?us-ascii?Q?ojHOMTuBk3AQN40NZRm+HO978gnAT+YFaj3g3aMKhj7VhJsILTtWnBDgGlLx?=
 =?us-ascii?Q?EAy8lsQl+FlZ7nuMxgtAA33E4gwB7Zo8Gua+Bdm2gbzptIZmO8/ODlHMOeAV?=
 =?us-ascii?Q?UEYQgv8G0K56X0665yyMqtOUJVm0lSKDROmWLTpVTWDJxknvN/8ww3J3K4t3?=
 =?us-ascii?Q?T9d26iwkHjCt9jJb6p8qyjs1q6fKZc5HvS2HWltrfWC2+fqO5mg6lyRYUaq8?=
 =?us-ascii?Q?sUU2FVRzBhQcype9wkakev0IOlXp7AxaoQLh2pKc?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ec6a77ca-6ed1-4b95-7b50-08de1e939af2
X-MS-Exchange-CrossTenant-AuthSource: BY5PR11MB4165.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2025 06:54:04.5752
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4GIFC+w2SQTTgqX4I9fmKfCIUgqalKFAWHwWWRD4sH1e6WO1fgQTVmloT9mJ6B4PGvxknkfOWATnxd1qugJWMg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPFE80710477
X-OriginatorOrg: intel.com

Hi Ming,

kernel test robot noticed the following build errors:

[auto build test ERROR on next-20251104]
[cannot apply to bpf-next/net bpf-next/master bpf/master linus/master v6.18-rc4 v6.18-rc3 v6.18-rc2 v6.18-rc4]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Ming-Lei/io_uring-prepare-for-extending-io_uring-with-bpf/20251105-002757
base:   next-20251104
patch link:    https://lore.kernel.org/r/20251104162123.1086035-4-ming.lei%40redhat.com
patch subject: [PATCH 3/5] io_uring: bpf: extend io_uring with bpf struct_ops
:::::: branch date: 3 days ago
:::::: commit date: 3 days ago
config: hexagon-allmodconfig (https://download.01.org/0day-ci/archive/20251108/202511080004.DkwIEtwd-lkp@intel.com/config)
compiler: clang version 17.0.6 (https://github.com/llvm/llvm-project 6009708b4367171ccdbf4b5905cb6a803753fe18)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251108/202511080004.DkwIEtwd-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/r/202511080004.DkwIEtwd-lkp@intel.com/

All errors (new ones prefixed by >>):

   io_uring/bpf.c:29:28: warning: unused function 'uring_bpf_get_flags' [-Wunused-function]
      29 | static inline unsigned int uring_bpf_get_flags(unsigned int op_flags)
         |                            ^~~~~~~~~~~~~~~~~~~
   In file included from io_uring/bpf.c:14:
   In file included from io_uring/io_uring.h:9:
>> include/linux/io_uring_types.h:655:2: error: call to '__compiletime_assert_586' declared with 'error' attribute: BUILD_BUG_ON failed: cmd_sz > sizeof(struct io_cmd_data)
     655 |         BUILD_BUG_ON(cmd_sz > sizeof(struct io_cmd_data));
         |         ^
   include/linux/build_bug.h:50:2: note: expanded from macro 'BUILD_BUG_ON'
      50 |         BUILD_BUG_ON_MSG(condition, "BUILD_BUG_ON failed: " #condition)
         |         ^
   include/linux/build_bug.h:39:37: note: expanded from macro 'BUILD_BUG_ON_MSG'
      39 | #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
         |                                     ^
   include/linux/compiler_types.h:603:2: note: expanded from macro 'compiletime_assert'
     603 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |         ^
   include/linux/compiler_types.h:591:2: note: expanded from macro '_compiletime_assert'
     591 |         __compiletime_assert(condition, msg, prefix, suffix)
         |         ^
   include/linux/compiler_types.h:584:4: note: expanded from macro '__compiletime_assert'
     584 |                         prefix ## suffix();                             \
         |                         ^
   <scratch space>:174:1: note: expanded from here
     174 | __compiletime_assert_586
         | ^
   In file included from io_uring/bpf.c:14:
   In file included from io_uring/io_uring.h:9:
>> include/linux/io_uring_types.h:655:2: error: call to '__compiletime_assert_586' declared with 'error' attribute: BUILD_BUG_ON failed: cmd_sz > sizeof(struct io_cmd_data)
   include/linux/build_bug.h:50:2: note: expanded from macro 'BUILD_BUG_ON'
      50 |         BUILD_BUG_ON_MSG(condition, "BUILD_BUG_ON failed: " #condition)
         |         ^
   include/linux/build_bug.h:39:37: note: expanded from macro 'BUILD_BUG_ON_MSG'
      39 | #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
         |                                     ^
   include/linux/compiler_types.h:603:2: note: expanded from macro 'compiletime_assert'
     603 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |         ^
   include/linux/compiler_types.h:591:2: note: expanded from macro '_compiletime_assert'
     591 |         __compiletime_assert(condition, msg, prefix, suffix)
         |         ^
   include/linux/compiler_types.h:584:4: note: expanded from macro '__compiletime_assert'
     584 |                         prefix ## suffix();                             \
         |                         ^
   <scratch space>:174:1: note: expanded from here
     174 | __compiletime_assert_586
         | ^
   In file included from io_uring/bpf.c:14:
   In file included from io_uring/io_uring.h:9:
>> include/linux/io_uring_types.h:655:2: error: call to '__compiletime_assert_586' declared with 'error' attribute: BUILD_BUG_ON failed: cmd_sz > sizeof(struct io_cmd_data)
   include/linux/build_bug.h:50:2: note: expanded from macro 'BUILD_BUG_ON'
      50 |         BUILD_BUG_ON_MSG(condition, "BUILD_BUG_ON failed: " #condition)
         |         ^
   include/linux/build_bug.h:39:37: note: expanded from macro 'BUILD_BUG_ON_MSG'
      39 | #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
         |                                     ^
   include/linux/compiler_types.h:603:2: note: expanded from macro 'compiletime_assert'
     603 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |         ^
   include/linux/compiler_types.h:591:2: note: expanded from macro '_compiletime_assert'
     591 |         __compiletime_assert(condition, msg, prefix, suffix)
         |         ^
   include/linux/compiler_types.h:584:4: note: expanded from macro '__compiletime_assert'
     584 |                         prefix ## suffix();                             \
         |                         ^
   <scratch space>:174:1: note: expanded from here
     174 | __compiletime_assert_586
         | ^
   In file included from io_uring/bpf.c:14:
   In file included from io_uring/io_uring.h:9:
>> include/linux/io_uring_types.h:655:2: error: call to '__compiletime_assert_586' declared with 'error' attribute: BUILD_BUG_ON failed: cmd_sz > sizeof(struct io_cmd_data)
   include/linux/build_bug.h:50:2: note: expanded from macro 'BUILD_BUG_ON'
      50 |         BUILD_BUG_ON_MSG(condition, "BUILD_BUG_ON failed: " #condition)
         |         ^
   include/linux/build_bug.h:39:37: note: expanded from macro 'BUILD_BUG_ON_MSG'
      39 | #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
         |                                     ^
   include/linux/compiler_types.h:603:2: note: expanded from macro 'compiletime_assert'
     603 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |         ^
   include/linux/compiler_types.h:591:2: note: expanded from macro '_compiletime_assert'
     591 |         __compiletime_assert(condition, msg, prefix, suffix)
         |         ^
   include/linux/compiler_types.h:584:4: note: expanded from macro '__compiletime_assert'
     584 |                         prefix ## suffix();                             \
         |                         ^
   <scratch space>:174:1: note: expanded from here
     174 | __compiletime_assert_586
         | ^
   In file included from io_uring/bpf.c:14:
   In file included from io_uring/io_uring.h:9:
>> include/linux/io_uring_types.h:655:2: error: call to '__compiletime_assert_586' declared with 'error' attribute: BUILD_BUG_ON failed: cmd_sz > sizeof(struct io_cmd_data)
   include/linux/build_bug.h:50:2: note: expanded from macro 'BUILD_BUG_ON'
      50 |         BUILD_BUG_ON_MSG(condition, "BUILD_BUG_ON failed: " #condition)
         |         ^
   include/linux/build_bug.h:39:37: note: expanded from macro 'BUILD_BUG_ON_MSG'
      39 | #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
         |                                     ^
   include/linux/compiler_types.h:603:2: note: expanded from macro 'compiletime_assert'
     603 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |         ^
   include/linux/compiler_types.h:591:2: note: expanded from macro '_compiletime_assert'
     591 |         __compiletime_assert(condition, msg, prefix, suffix)
         |         ^
   include/linux/compiler_types.h:584:4: note: expanded from macro '__compiletime_assert'
     584 |                         prefix ## suffix();                             \
         |                         ^
   <scratch space>:174:1: note: expanded from here
     174 | __compiletime_assert_586
         | ^
   1 warning and 5 errors generated.


vim +655 include/linux/io_uring_types.h

e27f928ee1cb06 io_uring/io_uring_types.h      Jens Axboe          2022-05-24  652  
f2ccb5aed7bce1 include/linux/io_uring_types.h Stefan Metzmacher   2022-08-11  653  static inline void io_kiocb_cmd_sz_check(size_t cmd_sz)
f2ccb5aed7bce1 include/linux/io_uring_types.h Stefan Metzmacher   2022-08-11  654  {
f2ccb5aed7bce1 include/linux/io_uring_types.h Stefan Metzmacher   2022-08-11 @655  	BUILD_BUG_ON(cmd_sz > sizeof(struct io_cmd_data));
f2ccb5aed7bce1 include/linux/io_uring_types.h Stefan Metzmacher   2022-08-11  656  }
f2ccb5aed7bce1 include/linux/io_uring_types.h Stefan Metzmacher   2022-08-11  657  #define io_kiocb_to_cmd(req, cmd_type) ( \
f2ccb5aed7bce1 include/linux/io_uring_types.h Stefan Metzmacher   2022-08-11  658  	io_kiocb_cmd_sz_check(sizeof(cmd_type)) , \
f2ccb5aed7bce1 include/linux/io_uring_types.h Stefan Metzmacher   2022-08-11  659  	((cmd_type *)&(req)->cmd) \
f2ccb5aed7bce1 include/linux/io_uring_types.h Stefan Metzmacher   2022-08-11  660  )
09fdd35162c289 include/linux/io_uring_types.h Caleb Sander Mateos 2025-02-28  661  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


