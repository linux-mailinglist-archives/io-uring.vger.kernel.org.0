Return-Path: <io-uring+bounces-3193-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 15880979CD7
	for <lists+io-uring@lfdr.de>; Mon, 16 Sep 2024 10:35:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9CB821F23A70
	for <lists+io-uring@lfdr.de>; Mon, 16 Sep 2024 08:35:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01BE913CFA1;
	Mon, 16 Sep 2024 08:35:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="khwZPHNU"
X-Original-To: io-uring@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B6D01339B1
	for <io-uring@vger.kernel.org>; Mon, 16 Sep 2024 08:35:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726475745; cv=fail; b=PYYnEp9ocsJ2iR7bkwGMDPe+y3qWO3sm3chkhAcsj5CVO3j1vyhDL0ls8/tHgmbzHQNsGp5+YJL+kT2IQDbWo/nLP2W0pj9zNVBht51rIasMQCyMwiDvS8/REfq0XLyB9BXKCtKxEJJ2DMEYkpt9UsxhaCHIiVVeFUa+7e0GKV0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726475745; c=relaxed/simple;
	bh=w3Lb5WGrZhwOok6whDMhDZoS+l4yZjlAQ9FcV2nOodA=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=TOrhmokw45gys3RYDB8x3s28dgIJd5MAlq1jSw9WGZ7idDrCHmW4FISYO9LT8KZ5HN1sS6QBztRsl3EaM8FHdDIHpES4jHss4j0eXz74chU2fe7bHVWIjCHHYYDRMq+2NWQnaL0K9di2hBuAJT630kzXnRYy8i4/NzKKH/PsA9Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=khwZPHNU; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726475744; x=1758011744;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=w3Lb5WGrZhwOok6whDMhDZoS+l4yZjlAQ9FcV2nOodA=;
  b=khwZPHNUbrmpr1QDyVaUf4pw9oce5H8kpua9fLAa1M8nDAtKTUO5Hl7U
   nbwvM86/p7SIPCFmvegoP9HNbuAhkVwgEhZvrK8aD/czEjt4r7ADXaI8q
   SyG1UuOfrSo3Vd6bjWOa4ZbJv9WKr8JFKV73zBQVhwyOQ/RogHr2mMpsB
   0i4S9JK3UTupXwxK77w66pQ4lhUF/2No0kr7Ash4N8BuM+hiilIJZBZkR
   8Uoiil1wFYAP6L38jurUbDjy2Y1dB2m4kCEaqDytzjmR3a0hwaWOV/7lU
   lpSbxxSnmxj3h3H0LX39O1CkXMO2BFL/CKsxUb2YtMa2KMew+IM1hQe1z
   Q==;
X-CSE-ConnectionGUID: WvuQny9sSRy9hZhoiAWrvg==
X-CSE-MsgGUID: KDklNWEiQkufrYoSCqPyaw==
X-IronPort-AV: E=McAfee;i="6700,10204,11196"; a="25227603"
X-IronPort-AV: E=Sophos;i="6.10,232,1719903600"; 
   d="scan'208";a="25227603"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2024 01:35:43 -0700
X-CSE-ConnectionGUID: DruSEuczQMicIBOlzfb/lA==
X-CSE-MsgGUID: +jGvHhUCT/6l72lV0FOTHA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,232,1719903600"; 
   d="scan'208";a="68680484"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa010.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 16 Sep 2024 01:35:43 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 16 Sep 2024 01:35:43 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 16 Sep 2024 01:35:42 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.176)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 16 Sep 2024 01:35:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LH9X7ZpD17UvQUzZp03Ci92MsVzEbi3lI1xdriVZi4gOBzTiEEF6zkkmj3smuCp3SgpraV5dNBscjaoRYbZ95Y//L1DEyQgA8kiaKMOJDVKEQlIAihbL/cHwT+96o6qsFA2ZhQxIo8IAjEhEJpcJzrJurDVDAXlqCkVdvA/IZwFWAw/I1GtQ0fJVBLXNrkOrohCuhftYkDXWYtL0fFQFg/0ZMo9jRnzP0nEJQ9BqN9pR2/XqZDWMTUQNDOB5rGKXwU3Pb453UBtRoQPr6H5WKpV+uRV1bueY+ZKXBMbTVbqonc/KAIEyfWy/ldvlONEj6r26dxJCwu1Ps6S6jVaWsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V/K77vBSZD8oMEVO3v99M3j7UVsKw7nQUyJCUjsLbLI=;
 b=icLOsV9uQ7y7QnuGbDuvnx109vF987hCxEs4myKwyOKYUm4aaHs1Do6SlqvP7fR3t8F63s8rkR+4vfiVyq51flohUaFo7VDPu2XA527f7lIWStppaYZhdodQ/5yew+75l73ZSKTOGY4lBIq+r+Od8dqrOY5fwv5vVT5TcLjXMkPNhLAP1jrsIjpXzqHunhJz7Ubm5mJxlcQNSZaEn6mp1yrLvtZg/gv7biTtaQZ6crQhX3RlpnezsFKatdBHSieijko2Ea4TnuCqM6EVlblFNno0aBnfJM8/OEsO5nTZaE4fYVKMKYCnOFw2S54vc7xMrTRFlNAqXQvuGtrKdX75KA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by LV8PR11MB8721.namprd11.prod.outlook.com (2603:10b6:408:203::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.24; Mon, 16 Sep
 2024 08:35:34 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c%5]) with mapi id 15.20.7962.022; Mon, 16 Sep 2024
 08:35:34 +0000
Date: Mon, 16 Sep 2024 16:35:24 +0800
From: kerne test robot <oliver.sang@intel.com>
To: Felix Moessbauer <felix.moessbauer@siemens.com>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, Jens Axboe <axboe@kernel.dk>,
	<io-uring@vger.kernel.org>, <oliver.sang@intel.com>
Subject: [axboe-block:for-6.12/io_uring] [io_uring/sqpoll] f011c9cf04:
 BUG:KASAN:slab-out-of-bounds_in_io_sq_offload_create
Message-ID: <202409161632.cbeeca0d-lkp@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-ClientProxiedBy: SGXP274CA0018.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b8::30)
 To LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|LV8PR11MB8721:EE_
X-MS-Office365-Filtering-Correlation-Id: 71b40742-989e-4314-3139-08dcd62a8804
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?wwfoFgb7S5vXx9fgkdNQc8wBoV2vJlHCaEXpoEOoQcV+xhdVSUXNJPK68ZxR?=
 =?us-ascii?Q?2Ey1y3L3jEZvO42hFFWURsCd+47gW5HabuMucRtJg9bVjas5vOBLmmJ++nEm?=
 =?us-ascii?Q?SQgDtRD7iYyWNVCz+IcEDVk95fqF8yTNcdinevGiuKrDpOUTC9HDPoXqf/p2?=
 =?us-ascii?Q?U8VsZrNaWSxA83o3V7M+IEnKY+lv3xLRW9r73f5cMbYwktV/RQnhBR6H8Ov/?=
 =?us-ascii?Q?Kf7L9Cm5I9SzhJ1pOQ623a11trhSdxyokV1eE+A4sz7UGt/45IAZs7hXIUP1?=
 =?us-ascii?Q?yBgvs6umu/3p0mf/mmOPFnNFDZiaiy8V0VJc1C3vFFiQmyAOdzGXH5rdeviO?=
 =?us-ascii?Q?GpCZ+Atz5ugcOBjxEtr62pWT4k6ylNAeQHPMzREeLO7lj52UAyImU+z2e85s?=
 =?us-ascii?Q?hbzEw4/7G5O9xjAhBN8MMTpTWjkhfuepfX/32bTGcSvWRP01IW/byGT93hF0?=
 =?us-ascii?Q?14U/rPOd8A7U/etdviCoiUJfFHOGTfVtzAShIfNMF41U+RsJDq1CeAYhQr9i?=
 =?us-ascii?Q?TJ5VYMnNvQQ2koKplxhvWvFRIAxbdq34eDV6GbCl8NE+RQ1u4GC52mcldq/K?=
 =?us-ascii?Q?T5C2D71+/zJye+9n7VjweJpNS7oXv/Vnq+yH9l8SkUduVy7tpW6TZ77/tQxV?=
 =?us-ascii?Q?yT2cNFCa3X9smGINgkO0Efwmh7S4x2ylPn/mO4LU/2iu4E7SGNBogB3AIEr6?=
 =?us-ascii?Q?JqmJivJ1FZ7O/6r+9Zy7SzBHLmw3MIB806jrmoCrjazJy549wyHboh6pvKCH?=
 =?us-ascii?Q?enMcSo8/0tCXfAOZ2Qj38JoblMz8jVMMb3vgrbWBRXhA5N2kQWgghTBQsCLH?=
 =?us-ascii?Q?RVHbNRkLbYyB9XPs+nJaVlrIeARKJtM5P7j9WEiyH/jtY/NR4KqZhK6nPLhK?=
 =?us-ascii?Q?xYZDMik9iEdDjnjRbzmdQAd/j10dLLA7sbF9oLvP7nXQaHHrzLIJfHGX3hU5?=
 =?us-ascii?Q?d7KM2jPQCMS8ArC195u3tYUzOb911B17HTCN1aSOl+n0itq6LZGbrsWdBy4+?=
 =?us-ascii?Q?6WMogZHL1KvMgSxnXJuS98cMAaqjIeXFJAm9nvtHbq5k7/n4s3ligujLuDDF?=
 =?us-ascii?Q?o0HQrZcPDsA3bXl2xIN1uUqAp0S6XqqI8ZM8b6kFFA98mxybwqEeb8c319rq?=
 =?us-ascii?Q?FceVqXWXhM4HVNX9rUHZd4Vt5E6V8iFM7YF3yeMf7nBlKsZTIthWmLtMlKMa?=
 =?us-ascii?Q?KQ1xvGSYdAzfCvla5xGWk9bYj57hfC0TXLDSin7FxS/aVq+IKPqyjX5ra6q7?=
 =?us-ascii?Q?kTXIOvsPMWUSdjyRYnXM2ZiCyfDWMWn4ZFc+gyT8G76NcEz73bkkvVFU+nok?=
 =?us-ascii?Q?lrhtJP0PGXkDgypKiT53O1eiC0sCqZSGMGNLTDaQP5IBlZH6rsXGAUKxmJ88?=
 =?us-ascii?Q?BnmHaxw=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Mrs2fBnBYcsHFUAcr4/Uwh7h48Ef2Da+FmrNeMjBuJVvfb4fa4GUVzR3kmrf?=
 =?us-ascii?Q?Z2m/vYSFv2Ayf556d3DW0uQMmBo7/CzDtSjllHTVjY2nuIVp3JdYiRhHjx7G?=
 =?us-ascii?Q?ATDX5Tb2Fnj5Xzy5NWlOs0lP1Oci4BL0RvGLXZGRX7UBIeMzWkukKEGM2p9m?=
 =?us-ascii?Q?t0VumaMdHp9CYypb1lhoYBMkbvnOXocK99KmHUpZbe5X2/QCLHhfoLN7b28Y?=
 =?us-ascii?Q?YJpEXZ6w1uiDKwZBI26MMsr1uei3RYtmG2PFWxM3WlHV5fcbQwe6KdMaxchg?=
 =?us-ascii?Q?zMXqOnBGoecEAuqinIjpS/3jx2JErFI/kUyjapazMUNeIDTgDEqFp/otN/1G?=
 =?us-ascii?Q?9J3LUdh62bErpIT5g85dhVzRXgUdQjtnqXKOzD+RrXxAVEovAnZiSOCfji5Q?=
 =?us-ascii?Q?bpCVQDetkhFWYYiL0sMUWU+si83am5jp1U4MWpCZJcjlQhO1d7wSPUOi1Mxj?=
 =?us-ascii?Q?k8smkTtOY/YfRIYjve4gtIE9hyeysj1ehnZ90P80jGsHRMZd1RRvodMLf6Xi?=
 =?us-ascii?Q?S6v/J7/Klx9ZfWL/5sRdIL/24KmWBnRltZQhBIV01uLOcfRQhd16GWJ1y3Vv?=
 =?us-ascii?Q?zMqy+rBXbjRX3OKkvQAvh4hXyqqI9Uz2jLzxiphCci4KzrPncL2I3jcDz0ao?=
 =?us-ascii?Q?XnBPNZrL7xa/vp4P8XUEhij/bHb3yx6W1GYlgD25eOBl3AxS9sA68C7u17FT?=
 =?us-ascii?Q?oFXB+o2CY0UAobqYcEWC71VwHIIAmXLFmWafsuf1ZKy/PbOFRnrgZJFHaZQm?=
 =?us-ascii?Q?wktiiXS3tlg5bLgoAkkpSFw/S/eyW+LfY/SritW+rF7GOXJGmswwArC65Nu5?=
 =?us-ascii?Q?9WmPrVSNJPOy84VDYrMv02jiIbBEy/QD8WgZW+Rp82oXWaL1mTiTVoaODYpJ?=
 =?us-ascii?Q?kvRnDFNxpl7TjppzTdpgUQwgGl5kBSSFxot2+SemrKmVU0zitVz8bvzFKDRc?=
 =?us-ascii?Q?55/QxNMXV/LRXOvxPk35EqVKFwJkGAbQsGPOMHKhnURy2Tjw6VdfOLgU0wTj?=
 =?us-ascii?Q?Qu9ueSVRdUBLeD/bfeBXqRjJgMz425eWNq7fCFsMzUuNlxpF30ID+cBqpA7Q?=
 =?us-ascii?Q?4l6MSfM1nxorBFH821gwSxk9plocABq6E3VvgVfqdl9iXWhtZhLEl1sCeCtn?=
 =?us-ascii?Q?YyIaNv8gOrZGjGgTYNEjkJjyxDlz8/N1YzcZC0doBOMw5ClgDRTrmUGxf+Wu?=
 =?us-ascii?Q?WJoRuDzQn0lrQ5cAQZNVHcpzF99ivKqjcZkFDRFkj0fWTModMuRRzWI1vK2r?=
 =?us-ascii?Q?KuUcYYgkDTBQVzY7MNZpqDS3PsZnwfA0WWqs7ewxbLsgU/xA7NlnSuPJUh5H?=
 =?us-ascii?Q?q7byesTwcc15mzM/9ePuxRmNPlf9fV3n2l2bP/nWw5/DSi2Drjvtl+IoiENK?=
 =?us-ascii?Q?8oi4DLcaNdu2Smu+302KO2ngkcur7o0/aJSGb5wjUVQRQPnWAqsCdS/MHtnW?=
 =?us-ascii?Q?8o08uhyiwIO9K84/7TjtMOb3uuOyFv28h3+jkY+7HqajIbTRXcRiYy7jellc?=
 =?us-ascii?Q?vPlQ+p6dp1xPZRbiPMLBnEzhIJX9HCfESH20EAg72mVANFV5pHb6ZEzOWILY?=
 =?us-ascii?Q?T8Z0w+wReFGT4hgd2opkN7gYcHiePVaAC44+twyrN0R+56fyXS70VCVTmvW4?=
 =?us-ascii?Q?wQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 71b40742-989e-4314-3139-08dcd62a8804
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2024 08:35:34.1767
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u4z6FkxNH0rO+WxkiUbrtZ2qya3yhHsvtWcnfNX1+2an+CcqQzPeFr9J5CJ+U7qEYoDgnYZ7SJ7VaGzFLj2k+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR11MB8721
X-OriginatorOrg: intel.com



Hello,

kernel test robot noticed "BUG:KASAN:slab-out-of-bounds_in_io_sq_offload_create" on:

commit: f011c9cf04c06f16b24f583d313d3c012e589e50 ("io_uring/sqpoll: do not allow pinning outside of cpuset")
https://git.kernel.org/cgit/linux/kernel/git/axboe/linux-block.git for-6.12/io_uring

[test failed on linux-next/master 57f962b956f1d116cd64d5c406776c4975de549d]

in testcase: trinity
version: 
with following parameters:

	runtime: 300s
	group: group-02
	nr_groups: 5



compiler: gcc-12
test machine: qemu-system-x86_64 -enable-kvm -cpu SandyBridge -smp 2 -m 16G

(please refer to attached dmesg/kmsg for entire log/backtrace)


+-------------------------------------------------------+------------+------------+
|                                                       | 0e0bcf07ec | f011c9cf04 |
+-------------------------------------------------------+------------+------------+
| BUG:KASAN:slab-use-after-free_in_io_sq_offload_create | 0          | 3          |
| BUG:KASAN:slab-out-of-bounds_in_io_sq_offload_create  | 0          | 2          |
+-------------------------------------------------------+------------+------------+


If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202409161632.cbeeca0d-lkp@intel.com


[ 155.627997][ T6168] BUG: KASAN: slab-out-of-bounds in io_sq_offload_create (arch/x86/include/asm/bitops.h:227 arch/x86/include/asm/bitops.h:239 include/asm-generic/bitops/instrumented-non-atomic.h:142 include/linux/cpumask.h:562 io_uring/sqpoll.c:469) 
[  155.628787][ T6168] Read of size 8 at addr ffff888138ecf948 by task trinity-c3/6168
[  155.629542][ T6168]
[  155.629806][ T6168] CPU: 1 UID: 4294967291 PID: 6168 Comm: trinity-c3 Not tainted 6.11.0-rc5-00027-gf011c9cf04c0 #1 074b2dc9794d1910767b5e24d1a9cb7061a66647
[  155.631255][ T6168] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
[  155.632276][ T6168] Call Trace:
[  155.632627][ T6168]  <TASK>
[ 155.632952][ T6168] dump_stack_lvl (lib/dump_stack.c:122) 
[ 155.633418][ T6168] print_address_description+0x51/0x3a0 
[ 155.634147][ T6168] ? io_sq_offload_create (arch/x86/include/asm/bitops.h:227 arch/x86/include/asm/bitops.h:239 include/asm-generic/bitops/instrumented-non-atomic.h:142 include/linux/cpumask.h:562 io_uring/sqpoll.c:469) 
[ 155.634671][ T6168] print_report (mm/kasan/report.c:489) 
[ 155.635119][ T6168] ? lock_acquired (include/trace/events/lock.h:85 kernel/locking/lockdep.c:6039) 
[ 155.635596][ T6168] ? kasan_addr_to_slab (include/linux/mm.h:1283 mm/kasan/../slab.h:206 mm/kasan/common.c:38) 
[ 155.636243][ T6168] ? io_sq_offload_create (arch/x86/include/asm/bitops.h:227 arch/x86/include/asm/bitops.h:239 include/asm-generic/bitops/instrumented-non-atomic.h:142 include/linux/cpumask.h:562 io_uring/sqpoll.c:469) 
[ 155.636890][ T6168] kasan_report (mm/kasan/report.c:603) 
[ 155.637320][ T6168] ? io_sq_offload_create (arch/x86/include/asm/bitops.h:227 arch/x86/include/asm/bitops.h:239 include/asm-generic/bitops/instrumented-non-atomic.h:142 include/linux/cpumask.h:562 io_uring/sqpoll.c:469) 
[ 155.637873][ T6168] kasan_check_range (mm/kasan/generic.c:183 mm/kasan/generic.c:189) 
[ 155.638384][ T6168] io_sq_offload_create (arch/x86/include/asm/bitops.h:227 arch/x86/include/asm/bitops.h:239 include/asm-generic/bitops/instrumented-non-atomic.h:142 include/linux/cpumask.h:562 io_uring/sqpoll.c:469) 
[ 155.638921][ T6168] ? __pfx_io_sq_offload_create (io_uring/sqpoll.c:413) 
[ 155.639501][ T6168] ? __lock_acquire (kernel/locking/lockdep.c:5142) 
[ 155.640040][ T6168] ? io_pages_map (include/linux/gfp.h:269 include/linux/gfp.h:296 include/linux/gfp.h:313 io_uring/memmap.c:28 io_uring/memmap.c:72) 
[ 155.640495][ T6168] ? io_allocate_scq_urings (io_uring/io_uring.c:3441) 
[ 155.641079][ T6168] io_uring_create (io_uring/io_uring.c:3606) 
[ 155.641591][ T6168] io_uring_setup (io_uring/io_uring.c:3715) 
[ 155.642185][ T6168] ? __pfx_io_uring_setup (io_uring/io_uring.c:3693) 
[ 155.642698][ T6168] ? do_int80_emulation (arch/x86/include/asm/irqflags.h:42 arch/x86/include/asm/irqflags.h:97 arch/x86/entry/common.c:251) 
[ 155.643206][ T6168] do_int80_emulation (arch/x86/entry/common.c:165 arch/x86/entry/common.c:253) 
[ 155.643675][ T6168] asm_int80_emulation (arch/x86/include/asm/idtentry.h:626) 
[  155.644159][ T6168] RIP: 0033:0x407ebc
[ 155.644532][ T6168] Code: 83 c0 01 41 89 80 40 30 00 00 8b 44 24 04 4c 89 d1 48 8b 54 24 08 4c 89 de 4c 89 e7 55 41 50 41 51 41 52 41 53 4c 89 cd cd 80 <41> 5b 41 5a 41 59 41 58 5d 48 3d 7a ff ff ff 49 89 c4 0f 87 5c 01
All code
========
   0:	83 c0 01             	add    $0x1,%eax
   3:	41 89 80 40 30 00 00 	mov    %eax,0x3040(%r8)
   a:	8b 44 24 04          	mov    0x4(%rsp),%eax
   e:	4c 89 d1             	mov    %r10,%rcx
  11:	48 8b 54 24 08       	mov    0x8(%rsp),%rdx
  16:	4c 89 de             	mov    %r11,%rsi
  19:	4c 89 e7             	mov    %r12,%rdi
  1c:	55                   	push   %rbp
  1d:	41 50                	push   %r8
  1f:	41 51                	push   %r9
  21:	41 52                	push   %r10
  23:	41 53                	push   %r11
  25:	4c 89 cd             	mov    %r9,%rbp
  28:	cd 80                	int    $0x80
  2a:*	41 5b                	pop    %r11		<-- trapping instruction
  2c:	41 5a                	pop    %r10
  2e:	41 59                	pop    %r9
  30:	41 58                	pop    %r8
  32:	5d                   	pop    %rbp
  33:	48 3d 7a ff ff ff    	cmp    $0xffffffffffffff7a,%rax
  39:	49 89 c4             	mov    %rax,%r12
  3c:	0f                   	.byte 0xf
  3d:	87                   	.byte 0x87
  3e:	5c                   	pop    %rsp
  3f:	01                   	.byte 0x1

Code starting with the faulting instruction
===========================================
   0:	41 5b                	pop    %r11
   2:	41 5a                	pop    %r10
   4:	41 59                	pop    %r9
   6:	41 58                	pop    %r8
   8:	5d                   	pop    %rbp
   9:	48 3d 7a ff ff ff    	cmp    $0xffffffffffffff7a,%rax
   f:	49 89 c4             	mov    %rax,%r12
  12:	0f                   	.byte 0xf
  13:	87                   	.byte 0x87
  14:	5c                   	pop    %rsp
  15:	01                   	.byte 0x1
[  155.650354][ T6168] RSP: 002b:00007ffe588726a8 EFLAGS: 00000202 ORIG_RAX: 00000000000001a9
[  155.651160][ T6168] RAX: ffffffffffffffda RBX: 000000000000018b RCX: 0000000000000001
[  155.651928][ T6168] RDX: 0000000000000020 RSI: ff39a6338351dabb RDI: 0000004801000022
[  155.652658][ T6168] RBP: 00000000000000d8 R08: 00007f75264d9000 R09: 00000000000000d8
[  155.653402][ T6168] R10: 0000000000000001 R11: ff39a6338351dabb R12: 0000004801000022
[  155.654296][ T6168] R13: 00007f75261cd058 R14: 0000000014055850 R15: 00007f75261cd000
[  155.655144][ T6168]  </TASK>
[  155.655463][ T6168]
[  155.655702][ T6168] Allocated by task 5605:
[ 155.656127][ T6168] kasan_save_stack (mm/kasan/common.c:48) 
[ 155.656595][ T6168] kasan_save_track (arch/x86/include/asm/current.h:49 mm/kasan/common.c:60 mm/kasan/common.c:69) 
[ 155.657087][ T6168] __kasan_slab_alloc (mm/kasan/common.c:312 mm/kasan/common.c:338) 
[ 155.657583][ T6168] kmem_cache_alloc_noprof (mm/slub.c:3988 mm/slub.c:4037 mm/slub.c:4044) 
[ 155.658217][ T6168] getname_flags (fs/namei.c:139) 
[ 155.658665][ T6168] user_path_at (fs/namei.c:3002) 
[ 155.659099][ T6168] path_getxattr (fs/xattr.c:785) 
[ 155.659569][ T6168] do_syscall_64 (arch/x86/entry/common.c:52 arch/x86/entry/common.c:83) 
[ 155.660020][ T6168] entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:130) 
[  155.660569][ T6168]
[  155.660776][ T6168] Freed by task 5605:
[ 155.661134][ T6168] kasan_save_stack (mm/kasan/common.c:48) 
[ 155.661543][ T6168] kasan_save_track (arch/x86/include/asm/current.h:49 mm/kasan/common.c:60 mm/kasan/common.c:69) 
[ 155.662064][ T6168] kasan_save_free_info (mm/kasan/generic.c:582) 
[ 155.662570][ T6168] __kasan_slab_free (mm/kasan/common.c:264) 
[ 155.663054][ T6168] kmem_cache_free (mm/slub.c:4473 mm/slub.c:4548) 
[ 155.663559][ T6168] user_path_at (fs/namei.c:3006) 
[ 155.664016][ T6168] path_getxattr (fs/xattr.c:785) 
[ 155.664454][ T6168] do_syscall_64 (arch/x86/entry/common.c:52 arch/x86/entry/common.c:83) 
[ 155.664866][ T6168] entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:130) 
[  155.665459][ T6168]
[  155.665709][ T6168] The buggy address belongs to the object at ffff888138ece600
[  155.665709][ T6168]  which belongs to the cache names_cache of size 4096
[  155.667216][ T6168] The buggy address is located 840 bytes to the right of
[  155.667216][ T6168]  allocated 4096-byte region [ffff888138ece600, ffff888138ecf600)
[  155.668597][ T6168]
[  155.668840][ T6168] The buggy address belongs to the physical page:
[  155.669458][ T6168] page: refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x138ec8
[  155.670449][ T6168] head: order:3 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
[  155.671298][ T6168] flags: 0x8000000000000040(head|zone=2)
[  155.671866][ T6168] page_type: 0xfdffffff(slab)
[  155.672341][ T6168] raw: 8000000000000040 ffff888101a588c0 ffffea0004e34a00 dead000000000002
[  155.673187][ T6168] raw: 0000000000000000 0000000000070007 00000001fdffffff 0000000000000000
[  155.674122][ T6168] head: 8000000000000040 ffff888101a588c0 ffffea0004e34a00 dead000000000002
[  155.675017][ T6168] head: 0000000000000000 0000000000070007 00000001fdffffff 0000000000000000
[  155.675912][ T6168] head: 8000000000000003 ffffea0004e3b201 ffffffffffffffff 0000000000000000
[  155.676727][ T6168] head: 0000000000000008 0000000000000000 00000000ffffffff 0000000000000000
[  155.677541][ T6168] page dumped because: kasan: bad access detected
[  155.678288][ T6168] page_owner tracks the page as allocated
[  155.678859][ T6168] page last allocated via order 3, migratetype Unmovable, gfp_mask 0xd20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 1391, tgid 1391 (grep), ts 35826248170, free_ts 0
[ 155.680744][ T6168] post_alloc_hook (include/linux/page_owner.h:32 mm/page_alloc.c:1493) 
[ 155.681229][ T6168] get_page_from_freelist (mm/page_alloc.c:1503 mm/page_alloc.c:3439) 
[ 155.681767][ T6168] __alloc_pages_noprof (mm/page_alloc.c:4695) 
[ 155.682356][ T6168] allocate_slab (include/linux/gfp.h:269 include/linux/gfp.h:296 mm/slub.c:2321 mm/slub.c:2484) 
[ 155.682811][ T6168] ___slab_alloc (mm/slub.c:3724 (discriminator 3)) 
[ 155.683285][ T6168] __slab_alloc+0x58/0xc0 
[ 155.683836][ T6168] kmem_cache_alloc_noprof (mm/slub.c:3866 mm/slub.c:4025 mm/slub.c:4044) 
[ 155.684381][ T6168] getname_flags (fs/namei.c:139) 
[ 155.684823][ T6168] do_sys_openat2 (fs/open.c:1410) 
[ 155.685268][ T6168] __x64_sys_openat (fs/open.c:1442) 
[ 155.685770][ T6168] do_syscall_64 (arch/x86/entry/common.c:52 arch/x86/entry/common.c:83) 
[ 155.686312][ T6168] entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:130) 
[  155.686902][ T6168] page_owner free stack trace missing
[  155.687448][ T6168]
[  155.687683][ T6168] Memory state around the buggy address:
[  155.688227][ T6168]  ffff888138ecf800: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[  155.688998][ T6168]  ffff888138ecf880: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[  155.689839][ T6168] >ffff888138ecf900: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[  155.690685][ T6168]                                               ^
[  155.691299][ T6168]  ffff888138ecf980: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[  155.692085][ T6168]  ffff888138ecfa00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[  155.692848][ T6168] ==================================================================
[  155.693783][ T6168] Disabling lock debugging due to kernel taint
[  158.741439][    C1] workqueue: pcpu_balance_workfn hogged CPU for >10000us 4 times, consider switching to WQ_UNBOUND



The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20240916/202409161632.cbeeca0d-lkp@intel.com



-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


