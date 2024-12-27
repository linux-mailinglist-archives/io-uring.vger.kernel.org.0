Return-Path: <io-uring+bounces-5610-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A9F6F9FCFC7
	for <lists+io-uring@lfdr.de>; Fri, 27 Dec 2024 04:14:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4A2447A00EA
	for <lists+io-uring@lfdr.de>; Fri, 27 Dec 2024 03:14:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB65B19A;
	Fri, 27 Dec 2024 03:14:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="X7sQrpBe"
X-Original-To: io-uring@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12D648821
	for <io-uring@vger.kernel.org>; Fri, 27 Dec 2024 03:14:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735269260; cv=fail; b=TLX/k41gE8SMSa2Y6qetgW+mPbgASfRerUKkdxMZDhvPd//s6ldheikD2TnCv7s4sTGWkukKPr2Lo1QLdV7vlLUHjGKK080xJFqz8Y481bw9vpbcMtosFufVmtR3+hChN13FHDsGZVo4dJa7vsV9OlVY7phPaIWtFKBBCOcQgTA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735269260; c=relaxed/simple;
	bh=3tCnX3O9NiBXQMDPhKvjk6O+aCao3uIywUvTNApBZSU=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=lx+JRGGkInSSGihlC4VwyV3s5zgAHrqxqzT8fbkRhylTdJrwp1gCLvECL6eVM3a2MLNMfQ0ZCrw6dRaqVHuddVAWbjZofCOVGxZiwfpJ/1MeQlB7XIlhC7lDbqn0oNj7P7J5N4OGHGuFNfwVaWK6c4ZAmQYQZOYgMwQwypZBO40=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=X7sQrpBe; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1735269257; x=1766805257;
  h=date:from:to:cc:subject:message-id:
   content-transfer-encoding:mime-version;
  bh=3tCnX3O9NiBXQMDPhKvjk6O+aCao3uIywUvTNApBZSU=;
  b=X7sQrpBec9hQsd+0BIPYJX0hmfu95wZausBThDLQ81QKmD7EFNDrBwPn
   LoqDvtlHZfDbXl85DXVGkfjYoLQA0qg/16R4GmfMM7rmn7cTsfFw+CM8J
   cHRnMKsOc4f25c8Yh0qXpWkkHORB02CS6D636de0Nu9l7RP3gPuDxegQc
   nygbqMIeL2NxtDSCK0JbQVn7FraFoJPkOzH+wq5FuhbN7Se+BxzOIv1kJ
   UB4HpUsZgvE+vSflE5gZkiIv+1Wf35wLwVbGopQXwXuXBvgTnbjdqMzxn
   gxTN9n7dlKX5erkardGH6FtKDFVzkFlUpbxHMVowmKOwiCOHmTyMN0ScP
   A==;
X-CSE-ConnectionGUID: Niv6nbvWSQ+QGVV0C+qX5w==
X-CSE-MsgGUID: Ya7Z0qTLRs+8Sl1nxNO22g==
X-IronPort-AV: E=McAfee;i="6700,10204,11297"; a="35910483"
X-IronPort-AV: E=Sophos;i="6.12,268,1728975600"; 
   d="scan'208";a="35910483"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Dec 2024 19:14:17 -0800
X-CSE-ConnectionGUID: CtH0JmLOTrqvrYFWobVe4w==
X-CSE-MsgGUID: 5ZNP0iTQRzu0MVAt8Vc1rQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="137412032"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 26 Dec 2024 19:14:16 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Thu, 26 Dec 2024 19:14:15 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Thu, 26 Dec 2024 19:14:15 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 26 Dec 2024 19:14:15 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EieBABhY9XvUc1hrAJMsW/T1a4+2kObYqyjLRoYON+Wyi4Pb9KHxxMJOQUSdD4tChIASXOHOoYcX5JTpTq3YdtKXWeMvHUjnM6s5VwOmu28wlfPFaAAw3SItQd3l/X45wo2ZskJJp0GDSAfRT5muJIVMiqthcC8Dingc3kHK2rnCCvbGTkcjpyYDBKHnUhemDVV23ApSavzU0sqyT9swZheENR69Kbk6KFPQDSlIV98GWDAiRrt54yUkQrw7rPSRiXi997qKow/Etas5YWLvCtt5IYDVpPci5JmR2oyxWsKIQyhnl7XfjA7akSTAnYUfVG+cxFDeqtuYTqSwaXiJlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7WQ3qWORL2/UDOts6Br1SunYhm709p4UHbngPXn5BCM=;
 b=ZWvgRcC+0JmIzJHT38VFnj3P7tUfsa2whUQb4Or8fQ0L/K7p8loaQ2Tb/l6UkAE04Iwcnz2+7/KteNrCUD0MOJD5lGBkd6OGfo0eEQU5iVMtk9OUFgjrGjkUoutQTqHzBTVYkD4Qtg+PeIRANanEBBdi5oqMZXNxDfvpepjBnvLVuCjnzudrKSvqoi156crxKLciixJV93QVHitLvVB8Hghc3bfigTjiT70UmaTkYWiKF2rpmxWP6CFti9A4GpqeeXIA4EOG4XeF68iKVdp6qeERbgahFAoOCUwyCnpqDlcNXZh8Rtu+gai6Rj9E63L0JhB4q3xrTnYvIFAZtwOGoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by BY1PR11MB8053.namprd11.prod.outlook.com (2603:10b6:a03:525::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8293.15; Fri, 27 Dec
 2024 03:14:04 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c%6]) with mapi id 15.20.8293.000; Fri, 27 Dec 2024
 03:13:57 +0000
Date: Fri, 27 Dec 2024 11:13:49 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Gabriel Krisman Bertazi <krisman@suse.de>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, Jens Axboe <axboe@kernel.dk>,
	<io-uring@vger.kernel.org>, <oliver.sang@intel.com>
Subject: [linux-next:master] [io_uring/rw]  8cf0c45999:  fio.read_bw_MBps
 51.1% regression
Message-ID: <202412271132.a09c3500-lkp@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI1PR02CA0028.apcprd02.prod.outlook.com
 (2603:1096:4:1f4::6) To LV3PR11MB8603.namprd11.prod.outlook.com
 (2603:10b6:408:1b6::9)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|BY1PR11MB8053:EE_
X-MS-Office365-Filtering-Correlation-Id: e18ff5e9-c0a5-4e28-4e22-08dd262480ad
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?uCX+LPxtjLj3dqIf7Fd8GU+6QPK4zCgn+WiKGpbgOog2nXvvElCIDGXVus?=
 =?iso-8859-1?Q?IfcC7YLnxbNOWyWI4oCsyk/ece6eVEWdjRulcuARCLvS37e89cAnkvDPaa?=
 =?iso-8859-1?Q?deYUUqfm+4K/cTol1771zfTidaJINAyXLBovGNaolQvnMLGWzMmrd7mgeX?=
 =?iso-8859-1?Q?pNEm2bixKSFeDEKFu31dH7onS+6n9+OjE3A7E4rxwntmYkhUybXv1i6or6?=
 =?iso-8859-1?Q?uyIxmvWwrQGYFx4Y1pSgouRP/ybj4EXiOq0OvqGfOlVabE6ZIFsv1WhqCT?=
 =?iso-8859-1?Q?a8gbrRFnGwtrHhopTXpBhnZTByvqZ9WYpK4vUePgPcc+fKADu+s4ovtDwZ?=
 =?iso-8859-1?Q?bc1FpaDUdg9FyLGMlSmOkFcryTPTvPSYUsgpA55T9fXl/Ke177U+Ek27ct?=
 =?iso-8859-1?Q?pSh5YxkF5UwBiN9ldUbLVpg2pSJ8a5R2zJrmOZU5/14VBjBeVHC5yOE66q?=
 =?iso-8859-1?Q?dD04ORZNuqkE6vhVOBqwYm9SOEB4/vos9NT07IQ/PXD9BqDYQgKLeaGnWJ?=
 =?iso-8859-1?Q?LO6FFaszXHO/QqzXNsNTh+xmRjgKMuvhyaksCfGlLiuiBI62vZKLy1eopF?=
 =?iso-8859-1?Q?Kw2XA6/Gj6b7Kb7NQudbaoDAuPf2JTaAyk4UhKA30oZNqS1dJY6F7PW63v?=
 =?iso-8859-1?Q?MCYAQGAxabKCp+l5uouZ1OWzjLTsNDMxKWA87lq0ANiYxTXbei16aveCU6?=
 =?iso-8859-1?Q?lyNDLNPIq4iOv4+uceYT3gO75eqSRt97t+3iuuxnP1DoANBXC9gi0FWlVk?=
 =?iso-8859-1?Q?XDN8UafKyqLFrYYbilGW/QuDjtrm5I0iRss9VqbIz6xeGTaw2MLSPrMPvd?=
 =?iso-8859-1?Q?bC3Z40Q8KzxUqYwPl2AlIUTHWtEiw9GGjcOq+FqjOtbSgJV1dSIv4XAE03?=
 =?iso-8859-1?Q?0CxI1/ANGllUxMybhMP6JmCVOhIY/XQ0FcDRVvmZ0IPSIObMKqHB7E6xfN?=
 =?iso-8859-1?Q?xsMDM9nMK8rwW2d2JAd4MR7t5mIw3TS7PLDsdlK5/8owAzYeitkLicBkPN?=
 =?iso-8859-1?Q?ro4hKcBOti6ZBIrksqlILCbMk7p7AH4Oi4/tWibfEmyca6tks8WifYIyrE?=
 =?iso-8859-1?Q?6pV0BheaLs/qXH3EpM3FfcgCJWMxfakTETfXucxSOF4/cZBmTJzDx3e4Ai?=
 =?iso-8859-1?Q?tXMUejHtMrWgWSgk0q/3BnUQcG5FS4fgql9sYfuVjvR6RU1YJXajp4cV2D?=
 =?iso-8859-1?Q?8GHOLDhkni1Jf27dGFGipa3RLAdxO53VcxAnVIYd3PFr0bi00lVD/Hd9Nq?=
 =?iso-8859-1?Q?hy/sWUJsemBMqgaaW82L6TJPjbOtqqyUrr/1B0gaKeLj42UYnipPDlZI4T?=
 =?iso-8859-1?Q?CjD5RtQlU5n7ssoHiP6fBtzQsDM2K4A0M96E1i7Wz8cLocAEfJsckuQjuO?=
 =?iso-8859-1?Q?dXBVPulwyNeti3ixf5e5jH7PMcb1Zn+A=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?5wMW/OKz60lxS6XbigxamlAb2Moypm7qyuXoRVL2GmiQR/cJGuRLwkvEag?=
 =?iso-8859-1?Q?Qzrawp3SADvUWjgnMsEwl/9Ptaufh+zs8N43W10Afw5WMkJ+dNxbf6B4uL?=
 =?iso-8859-1?Q?M2vFOyrBsF5bBbGXyRXd5CfeEkdfpfgXM1noMh8STfOE/NkDoMnwhdX1Mt?=
 =?iso-8859-1?Q?wTHKvdIFdZMANin6/3twxRiIqrsVorTeFXmTtw3GdtdpJ21gmC7IRL8tAa?=
 =?iso-8859-1?Q?vfmWVJo72ir3kh76Hy/1wcajTYW/R9XtRIhCYVXjIB0AWAIZAg4jMApJxr?=
 =?iso-8859-1?Q?j4ZgWnHv9dcZCpg5dvzZ3oKe/14e5tJlD3i+VUnaabjxUcHr6XWtsCzHRV?=
 =?iso-8859-1?Q?grmizf4z0G4bknscKnAkkdh7CwhtJYzrCsg75cFZE2uIBfmtRtkxxpZDja?=
 =?iso-8859-1?Q?dTjS/2wiBhZpOG7F5upO7jQuwmKfqLYEFDNdmVdDlfM/fdCnhnWkFJJEG9?=
 =?iso-8859-1?Q?1TIhaKAcmwbR0L3rbf1YmGtD0YUFd/v9wLJe7oxgEL8HEXZGGdNb+lN0Bp?=
 =?iso-8859-1?Q?H1JtQJYRcV6ZBNc/RvD0hGiNSwn44DW1R0TNodmdFjIPTopEDy2imCAvOJ?=
 =?iso-8859-1?Q?Chk63+ilWvSBxJhhj1zRaNxmA5Qfj5OCK37c1zuMg6aL4AIBAkDMRZkJFH?=
 =?iso-8859-1?Q?+9wg9r4XbFA9u3Ap5kcQkbw8Ou05eos3gFgG9bEbSCRYMuVrQokAfiXaQ/?=
 =?iso-8859-1?Q?7hvo1dB7G7UVmjnYFaQUgUmR1XIGeYscTGfVV9NcgIQCs2nVe1ApJSPMYc?=
 =?iso-8859-1?Q?G+nPvqaLvBAxFz6YYo44LZ6VpleKkXpfmd4rXLNrV9aajJC0K1l5hMLRaN?=
 =?iso-8859-1?Q?BEwT+NmebYsQLNsDU+2CAgeCjvsVd1YtieOqRm/zi4itSD7oIq0kigRxUX?=
 =?iso-8859-1?Q?F94WJM/B5ia8lpBQAYqGUhyGOm5erPIS9Dwl5dbutNtDoOxUCIgD6d1+Bw?=
 =?iso-8859-1?Q?f73CAADdGrMOO6Dl/Og8lnwrkBFK0/oyoZbWn04VSQkXBTopn2Ja3U6p8T?=
 =?iso-8859-1?Q?a+eP8NZE6jGwnRLzH0SOx/HXiJV/6a1/+oF19t0O1ddxgmxDYo4FlA4hpK?=
 =?iso-8859-1?Q?mbi92cFB68GjJhyqROUXWdVUcIyzssb31QMY8JGudRk98kKt2tyckTWTFd?=
 =?iso-8859-1?Q?rLYlKX3aMTkst+AtWKF6qWIeCDxErLhgZ1DKa64+ykmi5GAED2DZh0MR1N?=
 =?iso-8859-1?Q?O0TRi4FEo5newe2xxQrJu55bsjlX9gn3Fx4lzC4mItZ2navos9E1Pd+zHX?=
 =?iso-8859-1?Q?4fCiOjHpeNjMIGsfrQJMVG258/R28SHA/qMAYanQuHqYeAX5QOE5m/CHlt?=
 =?iso-8859-1?Q?SFX8ivr+vfrkKGJfQukIJNrAl+/FvCVxopJYdThgQEYFz/t/uyYwGvjH+3?=
 =?iso-8859-1?Q?jVPrsZ2I59FjRZF8DwaRVWEuKcFAQzPmObLabjo8Fz5ewJT8F3AE1y1tvE?=
 =?iso-8859-1?Q?jI/2MMsGHtsI6wjdRtS8TMAVCRXSVsHCEeHJk6nlSGZkPNgWUU7zwGJbb0?=
 =?iso-8859-1?Q?yE0jc5Z4P2zHxWtgSePN6N/uPMhjkD6vuuwQNnaq0kMPrBtEXfDWfd2XfU?=
 =?iso-8859-1?Q?bH7sEtqXKdNdfezTaMqmD4eo3jICHo2P8+geozwBxY4LShgZCnn+b8vRFh?=
 =?iso-8859-1?Q?ucGeJ2SwyNz+NA5mpLDBtNsNyfHJyB48QGiO01ipx82HaExjCoIqkcmw?=
 =?iso-8859-1?Q?=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e18ff5e9-c0a5-4e28-4e22-08dd262480ad
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Dec 2024 03:13:57.9320
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0OVnVEvfbX2Ytr7WpWPTPOhCNzvxpvuz6E85sbBsi1tXRXuCKgKjctenS+0U+PxIBSnXMKvdQZIzQpWQ+w/LvQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR11MB8053
X-OriginatorOrg: intel.com



Hello,

kernel test robot noticed a 51.1% regression of fio.read_bw_MBps on:


commit: 8cf0c459993ee2911f4f01fba21b1987b102c887 ("io_uring/rw: Allocate async data through helper")
https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git master

[test failed on linux-next/master 8155b4ef3466f0e289e8fcc9e6e62f3f4dceeac2]

testcase: fio-basic
config: x86_64-rhel-9.4
compiler: gcc-12
test machine: 96 threads 2 sockets Intel(R) Xeon(R) Platinum 8260L CPU @ 2.40GHz (Cascade Lake) with 128G memory
parameters:

	runtime: 300s
	nr_task: 8t
	disk: 1SSD
	fs: xfs
	rw: read
	bs: 2M
	ioengine: io_uring
	test_size: 256g
	cpufreq_governor: performance




If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202412271132.a09c3500-lkp@intel.com


Details are as below:
-------------------------------------------------------------------------------------------------->


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20241227/202412271132.a09c3500-lkp@intel.com

=========================================================================================
bs/compiler/cpufreq_governor/disk/fs/ioengine/kconfig/nr_task/rootfs/runtime/rw/tbox_group/test_size/testcase:
  2M/gcc-12/performance/1SSD/xfs/io_uring/x86_64-rhel-9.4/8t/debian-12-x86_64-20240206.cgz/300s/read/lkp-csl-2sp3/256g/fio-basic

commit: 
  23d91035ca ("io_uring/net: Allocate msghdr async data through helper")
  8cf0c45999 ("io_uring/rw: Allocate async data through helper")

23d91035cafa30d1 8cf0c459993ee2911f4f01fba21 
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
 1.169e+10           -97.9%  2.464e+08 ±  4%  cpuidle..time
   4187672 ±  5%     -98.3%      69610        cpuidle..usage
    490.00           -24.5%     370.16        uptime.boot
     45002           -23.4%      34483        uptime.idle
     91.67            +3.9%      95.24        iostat.cpu.idle
      6.67           -83.6%       1.09 ±  2%  iostat.cpu.iowait
      0.15 ±  3%   +1569.3%       2.51 ±  5%  iostat.cpu.user
      6.77 ±  2%      -5.2        1.52 ±  4%  mpstat.cpu.all.iowait%
      0.03 ± 22%      +0.0        0.05 ± 18%  mpstat.cpu.all.soft%
      0.15 ±  4%      +4.1        4.23 ±  6%  mpstat.cpu.all.usr%
   5982113 ± 42%     -97.3%     160513 ± 30%  numa-numastat.node0.local_node
   6032931 ± 41%     -96.5%     209090 ± 13%  numa-numastat.node0.numa_hit
   2662250 ±124%     -94.1%     155780 ± 31%  numa-numastat.node1.local_node
   2710984 ±121%     -92.4%     206648 ± 13%  numa-numastat.node1.numa_hit
   2142706           -87.8%     262066        vmstat.io.bi
     62.03         +2998.4%       1922        vmstat.io.bo
      6.47 ±  3%    -100.0%       0.00        vmstat.procs.b
      2.69 ± 12%    +173.1%       7.33 ±  8%  vmstat.procs.r
     19637           -46.7%      10473 ±  4%  vmstat.system.cs
     34417 ±  3%     -10.8%      30715 ±  2%  vmstat.system.in
      2.37 ± 49%      -2.1        0.26 ±103%  fio.latency_100ms%
     81.78 ±  3%     -56.2       25.56 ± 29%  fio.latency_250ms%
      0.34 ± 66%      -0.3        0.00        fio.latency_50ms%
      2171           -51.1%       1060 ±  3%  fio.read_bw_MBps
 4.194e+08           -14.2%    3.6e+08 ±  5%  fio.read_clat_99%_ns
    121.24           -99.2%       0.96 ±  6%  fio.time.elapsed_time
    121.24           -99.2%       0.96 ±  6%  fio.time.elapsed_time.max
 5.369e+08           -99.6%    2096533        fio.time.file_system_inputs
      8592 ±  3%     -10.2%       7716        fio.time.minor_page_faults
     89.00 ±  4%    +587.6%     612.00 ±  6%  fio.time.percent_of_cpu_this_job_got
    102.38 ±  4%     -99.6%       0.44 ±  2%  fio.time.system_time
   1101885           -99.6%       4454        fio.time.voluntary_context_switches
    131072           -99.6%     510.83        fio.workload
   6857403 ± 71%    -100.0%       0.00        numa-meminfo.node0.Active(file)
  49781569 ± 10%     -98.0%     971701 ±119%  numa-meminfo.node0.FilePages
  42007683 ±  4%     -99.4%     232792 ± 70%  numa-meminfo.node0.Inactive
  41773509 ±  4%     -99.4%     232792 ± 70%  numa-meminfo.node0.Inactive(file)
    181744 ± 10%     -80.2%      36054 ± 50%  numa-meminfo.node0.KReclaimable
  11216992 ± 48%    +440.7%   60655275        numa-meminfo.node0.MemFree
  54456267 ±  9%     -90.8%    5017984 ± 22%  numa-meminfo.node0.MemUsed
    181744 ± 10%     -80.2%      36054 ± 50%  numa-meminfo.node0.SReclaimable
     11353 ± 48%     -50.3%       5640 ±  9%  numa-meminfo.node0.Shmem
  46742560 ± 10%     -93.7%    2968006 ± 39%  numa-meminfo.node1.FilePages
  44279309 ± 12%     -99.7%     116761 ±141%  numa-meminfo.node1.Inactive
  44279309 ± 12%     -99.7%     116761 ±141%  numa-meminfo.node1.Inactive(file)
    222588 ±  9%     -71.5%      63492 ± 29%  numa-meminfo.node1.KReclaimable
  17706281 ± 29%    +248.8%   61765996        numa-meminfo.node1.MemFree
  48294686 ± 10%     -91.2%    4234972 ± 26%  numa-meminfo.node1.MemUsed
    222588 ±  9%     -71.5%      63492 ± 29%  numa-meminfo.node1.SReclaimable
     19553 ± 30%     -91.4%       1688 ± 29%  numa-meminfo.node1.Shmem
    484021 ± 22%     -54.2%     221920 ± 54%  numa-meminfo.node1.Slab
   8292851 ± 60%     -91.7%     685299        meminfo.Active
    993491 ± 17%     -31.0%     685299        meminfo.Active(anon)
   7299359 ± 70%    -100.0%       0.00        meminfo.Active(file)
   1059116 ±  3%     -57.9%     446122 ± 20%  meminfo.AnonHugePages
   1199023           -43.1%     682106        meminfo.AnonPages
  96504886           -95.9%    3939272        meminfo.Cached
   1771531           -52.2%     846516 ±  3%  meminfo.Committed_AS
  85824229 ±  5%     -99.6%     349553        meminfo.Inactive
  85591704 ±  5%     -99.6%     349553        meminfo.Inactive(file)
    404111           -75.5%      99205        meminfo.KReclaimable
     82199           -26.3%      60586        meminfo.Mapped
  28942581 ±  2%    +323.0%  1.224e+08        meminfo.MemFree
 1.027e+08           -91.0%    9249647        meminfo.Memused
      2432           -62.3%     917.33 ± 79%  meminfo.Mlocked
    404111           -75.5%      99205        meminfo.SReclaimable
    600546           -30.5%     417425        meminfo.SUnreclaim
     30852 ±  2%     -77.6%       6905 ±  5%  meminfo.Shmem
   1004658           -48.6%     516630        meminfo.Slab
 1.028e+08           -91.0%    9249647        meminfo.max_used_kB
   1780344 ± 71%    -100.0%       0.00        numa-vmstat.node0.nr_active_file
  12441416 ± 10%     -98.0%     242939 ±119%  numa-vmstat.node0.nr_file_pages
   2808184 ± 48%    +440.0%   15163781        numa-vmstat.node0.nr_free_pages
  10373418 ±  5%     -99.4%      58198 ± 70%  numa-vmstat.node0.nr_inactive_file
      2830 ± 48%     -49.7%       1424 ±  8%  numa-vmstat.node0.nr_shmem
     45390 ± 10%     -80.1%       9015 ± 50%  numa-vmstat.node0.nr_slab_reclaimable
   1779467 ± 71%    -100.0%       0.00        numa-vmstat.node0.nr_zone_active_file
  10374301 ±  5%     -99.4%      58198 ± 70%  numa-vmstat.node0.nr_zone_inactive_file
   6032577 ± 41%     -96.5%     209022 ± 13%  numa-vmstat.node0.numa_hit
   5981759 ± 42%     -97.3%     160445 ± 30%  numa-vmstat.node0.numa_local
     60865 ± 46%    -100.0%       0.00        numa-vmstat.node0.workingset_nodes
  11683973 ± 10%     -93.6%     742001 ± 39%  numa-vmstat.node1.nr_file_pages
   4428033 ± 29%    +248.7%   15441242        numa-vmstat.node1.nr_free_pages
  11068153 ± 12%     -99.7%      29190 ±141%  numa-vmstat.node1.nr_inactive_file
      4895 ± 30%     -91.4%     422.28 ± 29%  numa-vmstat.node1.nr_shmem
     55624 ±  9%     -71.5%      15873 ± 29%  numa-vmstat.node1.nr_slab_reclaimable
  11068150 ± 12%     -99.7%      29190 ±141%  numa-vmstat.node1.nr_zone_inactive_file
   2710384 ±121%     -92.4%     205957 ± 13%  numa-vmstat.node1.numa_hit
   2661650 ±124%     -94.2%     155089 ± 31%  numa-vmstat.node1.numa_local
     96303 ± 31%    -100.0%       0.00        numa-vmstat.node1.workingset_nodes
      9.70 ± 66%      -9.4        0.32 ±223%  perf-profile.calltrace.cycles-pp.vfs_write.ksys_write.do_syscall_64.entry_SYSCALL_64_after_hwframe.write
      9.09 ± 54%      -9.1        0.00        perf-profile.calltrace.cycles-pp.record__pushfn.perf_mmap__push.record__mmap_read_evlist.__cmd_record.cmd_record
      9.09 ± 54%      -9.1        0.00        perf-profile.calltrace.cycles-pp.write.writen.record__pushfn.perf_mmap__push.record__mmap_read_evlist
      9.09 ± 54%      -9.1        0.00        perf-profile.calltrace.cycles-pp.writen.record__pushfn.perf_mmap__push.record__mmap_read_evlist.__cmd_record
     13.49 ± 32%      -8.7        4.75 ± 38%  perf-profile.calltrace.cycles-pp.handle_internal_command.main
     13.49 ± 32%      -8.7        4.75 ± 38%  perf-profile.calltrace.cycles-pp.main
     13.49 ± 32%      -8.7        4.75 ± 38%  perf-profile.calltrace.cycles-pp.run_builtin.handle_internal_command.main
      8.57 ± 57%      -8.6        0.00        perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe.write.writen.record__pushfn
      8.57 ± 57%      -8.6        0.00        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe.write.writen.record__pushfn.perf_mmap__push
      8.57 ± 57%      -8.6        0.00        perf-profile.calltrace.cycles-pp.generic_perform_write.shmem_file_write_iter.vfs_write.ksys_write.do_syscall_64
      8.57 ± 57%      -8.6        0.00        perf-profile.calltrace.cycles-pp.ksys_write.do_syscall_64.entry_SYSCALL_64_after_hwframe.write.writen
      8.57 ± 57%      -8.6        0.00        perf-profile.calltrace.cycles-pp.shmem_file_write_iter.vfs_write.ksys_write.do_syscall_64.entry_SYSCALL_64_after_hwframe
      9.34 ± 22%      -6.9        2.45 ± 67%  perf-profile.calltrace.cycles-pp.__cmd_record.cmd_record.run_builtin.handle_internal_command.main
      9.34 ± 22%      -6.9        2.45 ± 67%  perf-profile.calltrace.cycles-pp.cmd_record.run_builtin.handle_internal_command.main
      7.20 ± 25%      -5.5        1.70 ± 79%  perf-profile.calltrace.cycles-pp.perf_mmap__push.record__mmap_read_evlist.__cmd_record.cmd_record.run_builtin
      7.20 ± 25%      -5.5        1.70 ± 79%  perf-profile.calltrace.cycles-pp.record__mmap_read_evlist.__cmd_record.cmd_record.run_builtin.handle_internal_command
     10.62 ± 57%      -9.4        1.17 ±142%  perf-profile.children.cycles-pp.write
      9.69 ± 66%      -9.4        0.32 ±223%  perf-profile.children.cycles-pp.ksys_write
      9.69 ± 66%      -9.4        0.32 ±223%  perf-profile.children.cycles-pp.vfs_write
     13.49 ± 32%      -9.1        4.41 ± 47%  perf-profile.children.cycles-pp.__cmd_record
     13.49 ± 32%      -9.1        4.41 ± 47%  perf-profile.children.cycles-pp.cmd_record
      9.09 ± 54%      -8.8        0.32 ±223%  perf-profile.children.cycles-pp.writen
      9.09 ± 54%      -8.7        0.34 ±223%  perf-profile.children.cycles-pp.record__pushfn
     13.49 ± 32%      -8.7        4.75 ± 38%  perf-profile.children.cycles-pp.handle_internal_command
     13.49 ± 32%      -8.7        4.75 ± 38%  perf-profile.children.cycles-pp.main
     13.49 ± 32%      -8.7        4.75 ± 38%  perf-profile.children.cycles-pp.run_builtin
      8.56 ± 57%      -8.6        0.00        perf-profile.children.cycles-pp.generic_perform_write
      8.56 ± 57%      -8.6        0.00        perf-profile.children.cycles-pp.shmem_file_write_iter
      9.94 ± 51%      -8.2        1.70 ± 79%  perf-profile.children.cycles-pp.perf_mmap__push
      9.94 ± 51%      -8.2        1.70 ± 79%  perf-profile.children.cycles-pp.record__mmap_read_evlist
     21.85 ± 22%     -95.7%       0.93 ±  9%  perf-stat.i.MPKI
 7.833e+08 ± 36%    +248.8%  2.733e+09        perf-stat.i.branch-instructions
      1.20 ± 21%      +1.4        2.60        perf-stat.i.branch-miss-rate%
  10294722 ±  8%    +588.8%   70910805        perf-stat.i.branch-misses
     71.04 ±  7%     -45.3       25.71 ±  6%  perf-stat.i.cache-miss-rate%
  67179322 ± 23%     -82.0%   12088775 ±  8%  perf-stat.i.cache-misses
  92053950 ± 16%     -49.0%   46958614 ±  2%  perf-stat.i.cache-references
     19893           -57.6%       8444 ±  6%  perf-stat.i.context-switches
      1.42 ± 18%     +47.0%       2.09 ±  6%  perf-stat.i.cpi
     96008            +3.1%      99012        perf-stat.i.cpu-clock
 5.166e+09 ± 27%    +426.7%  2.721e+10 ±  5%  perf-stat.i.cpu-cycles
    109.64          +297.0%     435.28 ± 26%  perf-stat.i.cpu-migrations
     95.02 ± 12%   +2287.2%       2268 ± 10%  perf-stat.i.cycles-between-cache-misses
 4.488e+09 ± 40%    +190.0%  1.301e+10        perf-stat.i.instructions
      0.78 ± 18%     -38.5%       0.48 ±  6%  perf-stat.i.ipc
      3257         +2386.4%      81003 ±  2%  perf-stat.i.minor-faults
      3257         +2386.3%      81001 ±  2%  perf-stat.i.page-faults
     96008            +3.1%      99013        perf-stat.i.task-clock
     16.77 ± 26%     -94.5%       0.93 ±  9%  perf-stat.overall.MPKI
      1.53 ± 39%      +1.1        2.60        perf-stat.overall.branch-miss-rate%
     72.01 ±  8%     -46.3       25.71 ±  6%  perf-stat.overall.cache-miss-rate%
      1.26 ± 22%     +66.0%       2.09 ±  6%  perf-stat.overall.cpi
     76.07 ±  5%   +2881.9%       2268 ± 10%  perf-stat.overall.cycles-between-cache-misses
      0.83 ± 18%     -42.0%       0.48 ±  6%  perf-stat.overall.ipc
   4201457 ± 40%    +507.2%   25510793        perf-stat.overall.path-length
 7.771e+08 ± 36%     +72.4%   1.34e+09        perf-stat.ps.branch-instructions
  10227839 ±  8%    +239.9%   34759364        perf-stat.ps.branch-misses
  66623351 ± 23%     -91.1%    5924306 ±  8%  perf-stat.ps.cache-misses
  91293692 ± 16%     -74.8%   23018351 ±  2%  perf-stat.ps.cache-references
     19729           -79.0%       4140 ±  6%  perf-stat.ps.context-switches
     95218           -49.0%      48533        perf-stat.ps.cpu-clock
 5.123e+09 ± 27%    +160.3%  1.334e+10 ±  5%  perf-stat.ps.cpu-cycles
    108.79           +95.9%     213.12 ± 25%  perf-stat.ps.cpu-migrations
 4.452e+09 ± 40%     +43.3%   6.38e+09        perf-stat.ps.instructions
      3230         +1129.5%      39716 ±  3%  perf-stat.ps.minor-faults
      3230         +1129.5%      39715 ±  3%  perf-stat.ps.page-faults
     95218           -49.0%      48533        perf-stat.ps.task-clock
 5.507e+11 ± 40%     -97.6%  1.303e+10        perf-stat.total.instructions
    428.50 ±113%    -100.0%       0.00        proc-vmstat.kswapd_high_wmark_hit_quickly
      1663 ± 68%    -100.0%       0.00        proc-vmstat.kswapd_low_wmark_hit_quickly
    248125 ± 17%     -30.9%     171528        proc-vmstat.nr_active_anon
   1740791 ± 71%    -100.0%       0.00        proc-vmstat.nr_active_file
    299833           -43.1%     170711        proc-vmstat.nr_anon_pages
    517.25 ±  3%     -57.9%     217.83 ± 20%  proc-vmstat.nr_anon_transparent_hugepages
  24125371           -95.9%     984856        proc-vmstat.nr_file_pages
   7236331          +322.9%   30605541        proc-vmstat.nr_free_pages
  21481117 ±  5%     -99.6%      87388        proc-vmstat.nr_inactive_file
     20818           -25.3%      15557        proc-vmstat.nr_mapped
    608.02           -62.3%     229.33 ± 79%  proc-vmstat.nr_mlock
      7717           -77.2%       1762 ±  4%  proc-vmstat.nr_shmem
    101012           -75.4%      24886        proc-vmstat.nr_slab_reclaimable
    150134           -30.4%     104433        proc-vmstat.nr_slab_unreclaimable
    248125 ± 17%     -30.9%     171528        proc-vmstat.nr_zone_active_anon
   1740790 ± 71%    -100.0%       0.00        proc-vmstat.nr_zone_active_file
  21481124 ±  5%     -99.6%      87388        proc-vmstat.nr_zone_inactive_file
   9755834 ± 25%    -100.0%       0.00        proc-vmstat.numa_foreign
    995.00 ± 26%     -95.4%      45.33 ±164%  proc-vmstat.numa_hint_faults
    939.00 ± 28%     -96.3%      34.67 ±204%  proc-vmstat.numa_hint_faults_local
   8745252 ± 28%     -95.2%     416538        proc-vmstat.numa_hit
   8645700 ± 28%     -96.3%     317091        proc-vmstat.numa_local
   9755622 ± 25%    -100.0%       0.00        proc-vmstat.numa_miss
   9856110 ± 25%     -99.0%      99445        proc-vmstat.numa_other
    386923           -97.4%       9959 ±222%  proc-vmstat.numa_pte_updates
      2224 ± 32%    -100.0%       0.00        proc-vmstat.pageoutrun
    423905 ±  3%    -100.0%       0.00        proc-vmstat.pgalloc_dma32
  68828649           -98.9%     752946        proc-vmstat.pgalloc_normal
    498127           -61.7%     190797        proc-vmstat.pgfault
  38943033           -99.2%     297228        proc-vmstat.pgfree
 2.685e+08           -99.6%    1048266        proc-vmstat.pgpgin
     22286 ±  3%     -58.9%       9168 ±  6%  proc-vmstat.pgreuse
  36664920          -100.0%       0.00        proc-vmstat.pgscan_file
  36664920          -100.0%       0.00        proc-vmstat.pgscan_kswapd
  36664893          -100.0%       0.00        proc-vmstat.pgsteal_file
  36664893          -100.0%       0.00        proc-vmstat.pgsteal_kswapd
     30510 ±  9%    -100.0%       0.00        proc-vmstat.slabs_scanned
    157121 ±  3%    -100.0%       0.00        proc-vmstat.workingset_nodes
      8736 ±  9%     -37.6%       5455 ±  7%  sched_debug.cfs_rq:/.avg_vruntime.min
      0.00 ± 56%    +407.7%       0.02 ± 58%  sched_debug.cfs_rq:/.h_nr_delayed.avg
      0.31 ± 48%    +227.3%       1.00        sched_debug.cfs_rq:/.h_nr_delayed.max
      0.03 ± 49%    +295.2%       0.13 ± 27%  sched_debug.cfs_rq:/.h_nr_delayed.stddev
      0.09 ± 11%     +84.1%       0.17 ±  9%  sched_debug.cfs_rq:/.h_nr_running.avg
      0.28 ±  6%     +43.8%       0.40 ± 11%  sched_debug.cfs_rq:/.h_nr_running.stddev
     48.57 ± 18%     +84.9%      89.82 ± 18%  sched_debug.cfs_rq:/.load_avg.avg
    947.69 ± 14%     +46.5%       1388 ± 33%  sched_debug.cfs_rq:/.load_avg.max
    166.24 ± 14%     +62.3%     269.79 ± 16%  sched_debug.cfs_rq:/.load_avg.stddev
      8736 ±  9%     -37.6%       5452 ±  7%  sched_debug.cfs_rq:/.min_vruntime.min
      0.09 ± 11%     +88.9%       0.18 ±  9%  sched_debug.cfs_rq:/.nr_running.avg
      1.36 ±  4%     +46.9%       2.00        sched_debug.cfs_rq:/.nr_running.max
      0.29 ±  6%     +50.1%       0.43 ±  9%  sched_debug.cfs_rq:/.nr_running.stddev
     17.33 ± 38%    +147.9%      42.98 ± 29%  sched_debug.cfs_rq:/.removed.load_avg.avg
    483.56 ± 31%    +111.8%       1024        sched_debug.cfs_rq:/.removed.load_avg.max
     85.81 ± 31%    +132.6%     199.60 ± 14%  sched_debug.cfs_rq:/.removed.load_avg.stddev
      6.41 ± 42%    +176.3%      17.71 ± 38%  sched_debug.cfs_rq:/.removed.runnable_avg.avg
    239.17 ± 37%    +119.8%     525.67 ±  2%  sched_debug.cfs_rq:/.removed.runnable_avg.max
     34.33 ± 35%    +152.5%      86.68 ± 22%  sched_debug.cfs_rq:/.removed.runnable_avg.stddev
      6.41 ± 42%    +176.4%      17.71 ± 38%  sched_debug.cfs_rq:/.removed.util_avg.avg
    238.94 ± 37%    +120.0%     525.67 ±  2%  sched_debug.cfs_rq:/.removed.util_avg.max
     34.31 ± 35%    +152.7%      86.68 ± 22%  sched_debug.cfs_rq:/.removed.util_avg.stddev
    126.39 ± 12%    +132.4%     293.67 ±  3%  sched_debug.cfs_rq:/.util_avg.avg
    992.22 ±  8%     +30.8%       1298 ± 16%  sched_debug.cfs_rq:/.util_avg.max
    188.05 ±  8%     +70.1%     319.91 ±  7%  sched_debug.cfs_rq:/.util_avg.stddev
     18.55 ± 20%     +78.8%      33.17 ± 14%  sched_debug.cfs_rq:/.util_est.avg
    614.94 ± 29%     +62.9%       1002 ±  3%  sched_debug.cfs_rq:/.util_est.max
     83.77 ± 24%     +64.2%     137.53 ±  4%  sched_debug.cfs_rq:/.util_est.stddev
    196044 ± 15%     -98.6%       2808 ± 15%  sched_debug.cpu.avg_idle.min
    163689 ±  3%     +38.6%     226871 ±  4%  sched_debug.cpu.avg_idle.stddev
    421612 ±  2%     -12.7%     367991        sched_debug.cpu.clock.avg
    421617 ±  2%     -12.7%     367996        sched_debug.cpu.clock.max
    421588 ±  2%     -12.7%     367986        sched_debug.cpu.clock.min
      4.22 ± 27%     -38.7%       2.58 ±  4%  sched_debug.cpu.clock.stddev
    421249 ±  2%     -12.7%     367704        sched_debug.cpu.clock_task.avg
    421583 ±  2%     -12.7%     367963        sched_debug.cpu.clock_task.max
    411856 ±  2%     -12.8%     359277        sched_debug.cpu.clock_task.min
      1029 ±  6%     -11.9%     907.72 ±  3%  sched_debug.cpu.clock_task.stddev
    252.14 ± 13%     +61.7%     407.60 ±  6%  sched_debug.cpu.curr->pid.avg
      5177 ±  6%     -42.7%       2967        sched_debug.cpu.curr->pid.max
      0.00 ±  9%     +38.2%       0.00 ± 17%  sched_debug.cpu.next_balance.stddev
      0.09 ± 12%     +96.6%       0.17 ±  9%  sched_debug.cpu.nr_running.avg
      0.26 ±  6%     +50.6%       0.40 ± 11%  sched_debug.cpu.nr_running.stddev
     35646 ±  7%     -28.2%      25593 ±  2%  sched_debug.cpu.nr_switches.avg
    711.47 ± 10%     -44.3%     396.17 ± 11%  sched_debug.cpu.nr_switches.min
     52034 ±  7%     -16.0%      43686 ±  6%  sched_debug.cpu.nr_switches.stddev
      0.01 ± 21%    +100.0%       0.01 ± 31%  sched_debug.cpu.nr_uninterruptible.avg
    421610 ±  2%     -12.7%     367987        sched_debug.cpu_clk
    421050 ±  2%     -12.7%     367426        sched_debug.ktime
    422192 ±  2%     -12.7%     368564        sched_debug.sched_clk
      0.01 ± 71%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.filemap_read.xfs_file_buffered_read.xfs_file_read_iter.__io_read
      0.06 ± 10%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.shrink_folio_list.evict_folios.try_to_shrink_lruvec.shrink_one
      0.04 ± 49%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.try_to_shrink_lruvec.shrink_one.shrink_many.shrink_node
      0.03 ± 23%     -93.6%       0.00 ±223%  perf-sched.sch_delay.avg.ms.__x64_sys_pause.do_syscall_64.entry_SYSCALL_64_after_hwframe.[unknown]
      0.06 ± 33%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.devkmsg_read.vfs_read.ksys_read.do_syscall_64
      0.01 ± 20%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.io_cqring_wait.__do_sys_io_uring_enter.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.02 ± 70%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.irq_thread.kthread.ret_from_fork.ret_from_fork_asm
      0.04 ± 31%     -91.0%       0.00 ±170%  perf-sched.sch_delay.avg.ms.irqentry_exit_to_user_mode.asm_sysvec_apic_timer_interrupt.[unknown].[unknown]
      0.03 ± 52%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.rcu_gp_kthread.kthread.ret_from_fork.ret_from_fork_asm
      0.02 ± 20%     -74.2%       0.01 ± 42%  perf-sched.sch_delay.avg.ms.schedule_hrtimeout_range.do_poll.constprop.0.do_sys_poll
      0.02 ± 33%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.schedule_hrtimeout_range.do_select.core_sys_select.do_pselect.constprop
      0.04 ± 51%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.schedule_timeout.__wait_for_common.__flush_work.__lru_add_drain_all
      0.01 ± 44%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.schedule_timeout.__wait_for_common.wait_for_completion_state.kernel_clone
      0.01 ± 43%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.schedule_timeout.io_schedule_timeout.__wait_for_common.blk_execute_rq
      0.05 ± 27%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.schedule_timeout.kcompactd.kthread.ret_from_fork
      0.01 ± 35%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.schedule_timeout.khugepaged_wait_work.khugepaged.kthread
      0.04 ± 25%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.schedule_timeout.kswapd_try_to_sleep.kswapd.kthread
      0.03 ± 18%     -69.6%       0.01 ± 92%  perf-sched.sch_delay.avg.ms.syscall_exit_to_user_mode.do_syscall_64.entry_SYSCALL_64_after_hwframe.[unknown]
      0.02 ± 20%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.wait_for_partner.fifo_open.do_dentry_open.vfs_open
      0.03 ± 75%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.filemap_read.xfs_file_buffered_read.xfs_file_read_iter.__io_read
      0.08 ±  4%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.shrink_folio_list.evict_folios.try_to_shrink_lruvec.shrink_one
      0.07 ± 21%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.try_to_shrink_lruvec.shrink_one.shrink_many.shrink_node
      0.04 ±  6%     -95.2%       0.00 ±223%  perf-sched.sch_delay.max.ms.__x64_sys_pause.do_syscall_64.entry_SYSCALL_64_after_hwframe.[unknown]
      0.06 ± 34%    -100.0%       0.00        perf-sched.sch_delay.max.ms.devkmsg_read.vfs_read.ksys_read.do_syscall_64
      3.27 ±147%    -100.0%       0.00        perf-sched.sch_delay.max.ms.io_cqring_wait.__do_sys_io_uring_enter.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.02 ± 89%    -100.0%       0.00        perf-sched.sch_delay.max.ms.irq_thread.kthread.ret_from_fork.ret_from_fork_asm
      0.07 ± 18%     -89.3%       0.01 ±192%  perf-sched.sch_delay.max.ms.irqentry_exit_to_user_mode.asm_sysvec_apic_timer_interrupt.[unknown].[unknown]
      0.08 ± 15%    -100.0%       0.00        perf-sched.sch_delay.max.ms.rcu_gp_kthread.kthread.ret_from_fork.ret_from_fork_asm
      0.10 ± 23%     -92.1%       0.01 ± 26%  perf-sched.sch_delay.max.ms.schedule_hrtimeout_range.do_poll.constprop.0.do_sys_poll
      0.04 ± 38%    -100.0%       0.00        perf-sched.sch_delay.max.ms.schedule_hrtimeout_range.do_select.core_sys_select.do_pselect.constprop
      0.07 ±  4%    -100.0%       0.00        perf-sched.sch_delay.max.ms.schedule_timeout.__wait_for_common.__flush_work.__lru_add_drain_all
      0.09 ± 30%    -100.0%       0.00        perf-sched.sch_delay.max.ms.schedule_timeout.__wait_for_common.wait_for_completion_state.kernel_clone
      0.02 ± 54%    -100.0%       0.00        perf-sched.sch_delay.max.ms.schedule_timeout.io_schedule_timeout.__wait_for_common.blk_execute_rq
      0.09 ± 12%    -100.0%       0.00        perf-sched.sch_delay.max.ms.schedule_timeout.kcompactd.kthread.ret_from_fork
      0.01 ± 35%    -100.0%       0.00        perf-sched.sch_delay.max.ms.schedule_timeout.khugepaged_wait_work.khugepaged.kthread
      0.12 ± 26%    -100.0%       0.00        perf-sched.sch_delay.max.ms.schedule_timeout.kswapd_try_to_sleep.kswapd.kthread
      0.07 ± 27%     -62.3%       0.03 ± 94%  perf-sched.sch_delay.max.ms.syscall_exit_to_user_mode.do_syscall_64.entry_SYSCALL_64_after_hwframe.[unknown]
      0.07 ± 15%    -100.0%       0.00        perf-sched.sch_delay.max.ms.wait_for_partner.fifo_open.do_dentry_open.vfs_open
      0.01 ± 17%    +593.2%       0.09 ± 74%  perf-sched.total_sch_delay.average.ms
     15.98 ±  2%     -85.5%       2.32 ± 48%  perf-sched.total_wait_and_delay.average.ms
     52651           -98.0%       1045 ± 30%  perf-sched.total_wait_and_delay.count.ms
      4255 ± 13%     -98.3%      73.23 ± 15%  perf-sched.total_wait_and_delay.max.ms
     15.97 ±  2%     -86.0%       2.24 ± 53%  perf-sched.total_wait_time.average.ms
      4255 ± 13%     -98.9%      45.89 ±  7%  perf-sched.total_wait_time.max.ms
      7.81 ±  7%     -97.5%       0.19 ± 62%  perf-sched.wait_and_delay.avg.ms.__cond_resched.__wait_for_common.affine_move_task.__set_cpus_allowed_ptr.__sched_setaffinity
     69.50 ± 29%    -100.0%       0.00        perf-sched.wait_and_delay.avg.ms.__cond_resched.shrink_folio_list.evict_folios.try_to_shrink_lruvec.shrink_one
    689.13 ± 14%    -100.0%       0.00        perf-sched.wait_and_delay.avg.ms.__x64_sys_pause.do_syscall_64.entry_SYSCALL_64_after_hwframe.[unknown]
     17.56 ±  4%    -100.0%       0.00        perf-sched.wait_and_delay.avg.ms.do_nanosleep.hrtimer_nanosleep.common_nsleep.__x64_sys_clock_nanosleep
     32.71           -99.4%       0.21 ± 50%  perf-sched.wait_and_delay.avg.ms.do_task_dead.do_exit.do_group_exit.__x64_sys_exit_group.x64_sys_call
      0.78          -100.0%       0.00        perf-sched.wait_and_delay.avg.ms.io_cqring_wait.__do_sys_io_uring_enter.do_syscall_64.entry_SYSCALL_64_after_hwframe
     29.64 ±  3%     -97.5%       0.73 ±  7%  perf-sched.wait_and_delay.avg.ms.pipe_read.vfs_read.ksys_read.do_syscall_64
    403.38 ±  7%     -99.4%       2.51 ±223%  perf-sched.wait_and_delay.avg.ms.schedule_hrtimeout_range.do_poll.constprop.0.do_sys_poll
    158.27          -100.0%       0.00        perf-sched.wait_and_delay.avg.ms.schedule_hrtimeout_range.do_select.core_sys_select.do_pselect.constprop
    112.37 ± 23%     -96.3%       4.12 ±103%  perf-sched.wait_and_delay.avg.ms.schedule_hrtimeout_range.ep_poll.do_epoll_wait.__x64_sys_epoll_wait
    285.75 ± 73%    -100.0%       0.00        perf-sched.wait_and_delay.avg.ms.schedule_timeout.io_schedule_timeout.__wait_for_common.blk_execute_rq
    453.18          -100.0%       0.00        perf-sched.wait_and_delay.avg.ms.schedule_timeout.kcompactd.kthread.ret_from_fork
     47.62 ± 62%    -100.0%       0.00        perf-sched.wait_and_delay.avg.ms.schedule_timeout.kswapd_try_to_sleep.kswapd.kthread
    500.57 ±  7%     -98.9%       5.42 ± 59%  perf-sched.wait_and_delay.avg.ms.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
    561.24 ±  5%     -99.5%       3.01 ± 50%  perf-sched.wait_and_delay.avg.ms.worker_thread.kthread.ret_from_fork.ret_from_fork_asm
    577.00           -40.4%     343.83 ± 23%  perf-sched.wait_and_delay.count.__cond_resched.__wait_for_common.affine_move_task.__set_cpus_allowed_ptr.__sched_setaffinity
      6.00 ± 31%    -100.0%       0.00        perf-sched.wait_and_delay.count.__cond_resched.shrink_folio_list.evict_folios.try_to_shrink_lruvec.shrink_one
     10.17 ±  3%    -100.0%       0.00        perf-sched.wait_and_delay.count.__x64_sys_pause.do_syscall_64.entry_SYSCALL_64_after_hwframe.[unknown]
    501.83          -100.0%       0.00        perf-sched.wait_and_delay.count.do_nanosleep.hrtimer_nanosleep.common_nsleep.__x64_sys_clock_nanosleep
     45905          -100.0%       0.00        perf-sched.wait_and_delay.count.io_cqring_wait.__do_sys_io_uring_enter.do_syscall_64.entry_SYSCALL_64_after_hwframe
      2426 ±  2%     -97.9%      51.67 ± 61%  perf-sched.wait_and_delay.count.pipe_read.vfs_read.ksys_read.do_syscall_64
     37.83 ±  5%     -98.7%       0.50 ±223%  perf-sched.wait_and_delay.count.schedule_hrtimeout_range.do_poll.constprop.0.do_sys_poll
     30.00          -100.0%       0.00        perf-sched.wait_and_delay.count.schedule_hrtimeout_range.do_select.core_sys_select.do_pselect.constprop
      2.33 ± 20%    -100.0%       0.00        perf-sched.wait_and_delay.count.schedule_timeout.io_schedule_timeout.__wait_for_common.blk_execute_rq
     19.83          -100.0%       0.00        perf-sched.wait_and_delay.count.schedule_timeout.kcompactd.kthread.ret_from_fork
    134.67 ± 21%    -100.0%       0.00        perf-sched.wait_and_delay.count.schedule_timeout.kswapd_try_to_sleep.kswapd.kthread
      1195 ±  3%     -99.1%      10.17 ± 54%  perf-sched.wait_and_delay.count.schedule_timeout.rcu_gp_fqs_loop.rcu_gp_kthread.kthread
    925.67 ±  7%     -58.9%     380.00 ± 24%  perf-sched.wait_and_delay.count.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
    362.33 ±  5%     -79.0%      76.17 ± 58%  perf-sched.wait_and_delay.count.worker_thread.kthread.ret_from_fork.ret_from_fork_asm
      1013 ±  2%     -94.8%      53.21 ± 65%  perf-sched.wait_and_delay.max.ms.__cond_resched.__wait_for_common.affine_move_task.__set_cpus_allowed_ptr.__sched_setaffinity
     89.90 ± 17%    -100.0%       0.00        perf-sched.wait_and_delay.max.ms.__cond_resched.shrink_folio_list.evict_folios.try_to_shrink_lruvec.shrink_one
    999.82          -100.0%       0.00        perf-sched.wait_and_delay.max.ms.__x64_sys_pause.do_syscall_64.entry_SYSCALL_64_after_hwframe.[unknown]
      1000          -100.0%       0.00        perf-sched.wait_and_delay.max.ms.do_nanosleep.hrtimer_nanosleep.common_nsleep.__x64_sys_clock_nanosleep
    890.88 ±  8%     -99.4%       5.21 ±101%  perf-sched.wait_and_delay.max.ms.do_task_dead.do_exit.do_group_exit.__x64_sys_exit_group.x64_sys_call
     13.58 ±106%    -100.0%       0.00        perf-sched.wait_and_delay.max.ms.io_cqring_wait.__do_sys_io_uring_enter.do_syscall_64.entry_SYSCALL_64_after_hwframe
      1013           -99.8%       1.97 ± 28%  perf-sched.wait_and_delay.max.ms.pipe_read.vfs_read.ksys_read.do_syscall_64
      1464 ± 16%     -99.5%       7.52 ±223%  perf-sched.wait_and_delay.max.ms.schedule_hrtimeout_range.do_poll.constprop.0.do_sys_poll
    250.08          -100.0%       0.00        perf-sched.wait_and_delay.max.ms.schedule_hrtimeout_range.do_select.core_sys_select.do_pselect.constprop
    334.30 ± 23%     -95.4%      15.29 ±103%  perf-sched.wait_and_delay.max.ms.schedule_hrtimeout_range.ep_poll.do_epoll_wait.__x64_sys_epoll_wait
    355.60 ± 68%    -100.0%       0.00        perf-sched.wait_and_delay.max.ms.schedule_timeout.io_schedule_timeout.__wait_for_common.blk_execute_rq
    504.88          -100.0%       0.00        perf-sched.wait_and_delay.max.ms.schedule_timeout.kcompactd.kthread.ret_from_fork
    111.51 ±  7%    -100.0%       0.00        perf-sched.wait_and_delay.max.ms.schedule_timeout.kswapd_try_to_sleep.kswapd.kthread
      6.34 ± 18%     -28.2%       4.55 ± 11%  perf-sched.wait_and_delay.max.ms.schedule_timeout.rcu_gp_fqs_loop.rcu_gp_kthread.kthread
      3150 ± 21%     -98.5%      45.76 ±  7%  perf-sched.wait_and_delay.max.ms.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
      4235 ± 14%     -99.3%      29.44 ± 43%  perf-sched.wait_and_delay.max.ms.worker_thread.kthread.ret_from_fork.ret_from_fork_asm
      7.76 ±  7%     -98.8%       0.10 ± 61%  perf-sched.wait_time.avg.ms.__cond_resched.__wait_for_common.affine_move_task.__set_cpus_allowed_ptr.__sched_setaffinity
      0.96 ± 56%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.filemap_read.xfs_file_buffered_read.xfs_file_read_iter.__io_read
     69.43 ± 29%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.shrink_folio_list.evict_folios.try_to_shrink_lruvec.shrink_one
     45.25 ± 92%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.try_to_shrink_lruvec.shrink_one.shrink_many.shrink_node
    689.10 ± 14%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__x64_sys_pause.do_syscall_64.entry_SYSCALL_64_after_hwframe.[unknown]
      1.38 ±  9%    -100.0%       0.00        perf-sched.wait_time.avg.ms.devkmsg_read.vfs_read.ksys_read.do_syscall_64
     17.55 ±  4%    -100.0%       0.00        perf-sched.wait_time.avg.ms.do_nanosleep.hrtimer_nanosleep.common_nsleep.__x64_sys_clock_nanosleep
     32.71           -99.4%       0.21 ± 50%  perf-sched.wait_time.avg.ms.do_task_dead.do_exit.do_group_exit.__x64_sys_exit_group.x64_sys_call
      0.41 ±  4%     -14.0%       0.35 ±  3%  perf-sched.wait_time.avg.ms.do_wait.kernel_wait4.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.77          -100.0%       0.00        perf-sched.wait_time.avg.ms.io_cqring_wait.__do_sys_io_uring_enter.do_syscall_64.entry_SYSCALL_64_after_hwframe
    194.51 ±103%    -100.0%       0.00 ±223%  perf-sched.wait_time.avg.ms.irqentry_exit_to_user_mode.asm_sysvec_apic_timer_interrupt.[unknown].[unknown]
     29.63 ±  3%     -97.6%       0.71 ±  8%  perf-sched.wait_time.avg.ms.pipe_read.vfs_read.ksys_read.do_syscall_64
      4.01 ±  7%    -100.0%       0.00        perf-sched.wait_time.avg.ms.rcu_gp_kthread.kthread.ret_from_fork.ret_from_fork_asm
    403.36 ±  7%     -99.3%       2.82 ±193%  perf-sched.wait_time.avg.ms.schedule_hrtimeout_range.do_poll.constprop.0.do_sys_poll
    158.25          -100.0%       0.00        perf-sched.wait_time.avg.ms.schedule_hrtimeout_range.do_select.core_sys_select.do_pselect.constprop
    112.32 ± 23%     -96.5%       3.93 ±106%  perf-sched.wait_time.avg.ms.schedule_hrtimeout_range.ep_poll.do_epoll_wait.__x64_sys_epoll_wait
      0.66 ±  4%    -100.0%       0.00        perf-sched.wait_time.avg.ms.schedule_timeout.__wait_for_common.wait_for_completion_state.kernel_clone
    285.74 ± 73%    -100.0%       0.00        perf-sched.wait_time.avg.ms.schedule_timeout.io_schedule_timeout.__wait_for_common.blk_execute_rq
    453.14          -100.0%       0.00        perf-sched.wait_time.avg.ms.schedule_timeout.kcompactd.kthread.ret_from_fork
      0.07 ± 83%    -100.0%       0.00        perf-sched.wait_time.avg.ms.schedule_timeout.khugepaged_wait_work.khugepaged.kthread
     47.57 ± 62%    -100.0%       0.00        perf-sched.wait_time.avg.ms.schedule_timeout.kswapd_try_to_sleep.kswapd.kthread
      3.86 ±  6%     -24.9%       2.90 ± 23%  perf-sched.wait_time.avg.ms.schedule_timeout.rcu_gp_fqs_loop.rcu_gp_kthread.kthread
    500.56 ±  7%     -98.9%       5.38 ± 60%  perf-sched.wait_time.avg.ms.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
    226.30 ± 64%    -100.0%       0.01 ±107%  perf-sched.wait_time.avg.ms.syscall_exit_to_user_mode.do_syscall_64.entry_SYSCALL_64_after_hwframe.[unknown]
    561.18 ±  5%     -99.6%       2.50 ± 79%  perf-sched.wait_time.avg.ms.worker_thread.kthread.ret_from_fork.ret_from_fork_asm
      1013 ±  2%     -97.4%      26.61 ± 65%  perf-sched.wait_time.max.ms.__cond_resched.__wait_for_common.affine_move_task.__set_cpus_allowed_ptr.__sched_setaffinity
      1.65 ± 66%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.filemap_read.xfs_file_buffered_read.xfs_file_read_iter.__io_read
     89.83 ± 17%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.shrink_folio_list.evict_folios.try_to_shrink_lruvec.shrink_one
     91.01 ± 14%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.try_to_shrink_lruvec.shrink_one.shrink_many.shrink_node
    999.79          -100.0%       0.00        perf-sched.wait_time.max.ms.__x64_sys_pause.do_syscall_64.entry_SYSCALL_64_after_hwframe.[unknown]
      2.76 ±  9%    -100.0%       0.00        perf-sched.wait_time.max.ms.devkmsg_read.vfs_read.ksys_read.do_syscall_64
      1000          -100.0%       0.00        perf-sched.wait_time.max.ms.do_nanosleep.hrtimer_nanosleep.common_nsleep.__x64_sys_clock_nanosleep
    890.88 ±  8%     -99.4%       5.21 ±101%  perf-sched.wait_time.max.ms.do_task_dead.do_exit.do_group_exit.__x64_sys_exit_group.x64_sys_call
     15.72 ±  2%     -93.4%       1.04 ± 28%  perf-sched.wait_time.max.ms.do_wait.kernel_wait4.do_syscall_64.entry_SYSCALL_64_after_hwframe
     13.23 ±110%    -100.0%       0.00        perf-sched.wait_time.max.ms.io_cqring_wait.__do_sys_io_uring_enter.do_syscall_64.entry_SYSCALL_64_after_hwframe
    500.20 ± 99%    -100.0%       0.01 ±223%  perf-sched.wait_time.max.ms.irqentry_exit_to_user_mode.asm_sysvec_apic_timer_interrupt.[unknown].[unknown]
      1013           -99.8%       1.96 ± 29%  perf-sched.wait_time.max.ms.pipe_read.vfs_read.ksys_read.do_syscall_64
      4.85 ±  6%    -100.0%       0.00        perf-sched.wait_time.max.ms.rcu_gp_kthread.kthread.ret_from_fork.ret_from_fork_asm
      1464 ± 16%     -99.4%       8.15 ±202%  perf-sched.wait_time.max.ms.schedule_hrtimeout_range.do_poll.constprop.0.do_sys_poll
    250.06          -100.0%       0.00        perf-sched.wait_time.max.ms.schedule_hrtimeout_range.do_select.core_sys_select.do_pselect.constprop
    334.27 ± 23%     -95.4%      15.28 ±103%  perf-sched.wait_time.max.ms.schedule_hrtimeout_range.ep_poll.do_epoll_wait.__x64_sys_epoll_wait
      2.04 ±  7%    -100.0%       0.00        perf-sched.wait_time.max.ms.schedule_timeout.__wait_for_common.wait_for_completion_state.kernel_clone
    355.59 ± 68%    -100.0%       0.00        perf-sched.wait_time.max.ms.schedule_timeout.io_schedule_timeout.__wait_for_common.blk_execute_rq
    504.84          -100.0%       0.00        perf-sched.wait_time.max.ms.schedule_timeout.kcompactd.kthread.ret_from_fork
      0.07 ± 83%    -100.0%       0.00        perf-sched.wait_time.max.ms.schedule_timeout.khugepaged_wait_work.khugepaged.kthread
    111.44 ±  7%    -100.0%       0.00        perf-sched.wait_time.max.ms.schedule_timeout.kswapd_try_to_sleep.kswapd.kthread
      3150 ± 21%     -98.7%      39.96 ± 40%  perf-sched.wait_time.max.ms.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
    843.01 ± 41%    -100.0%       0.03 ± 94%  perf-sched.wait_time.max.ms.syscall_exit_to_user_mode.do_syscall_64.entry_SYSCALL_64_after_hwframe.[unknown]
      4235 ± 14%     -99.5%      21.72 ± 79%  perf-sched.wait_time.max.ms.worker_thread.kthread.ret_from_fork.ret_from_fork_asm




Disclaimer:
Results have been estimated based on internal Intel analysis and are provided
for informational purposes only. Any difference in system hardware or software
design or configuration may affect actual performance.


-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


