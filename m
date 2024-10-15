Return-Path: <io-uring+bounces-3681-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 49F9999DC34
	for <lists+io-uring@lfdr.de>; Tue, 15 Oct 2024 04:23:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6A0C21C21586
	for <lists+io-uring@lfdr.de>; Tue, 15 Oct 2024 02:23:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A146157A6B;
	Tue, 15 Oct 2024 02:23:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dcgoYuUK"
X-Original-To: io-uring@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74AE71662EF;
	Tue, 15 Oct 2024 02:23:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728958997; cv=fail; b=WajJavNbRgIgFBKwR29aILI7vjCF4RWMNP3KoDuvfhcXjCfK2xAt7Og3iHQTh/pWhhPTXd0xBYEwwx/e9KJxDb1ygBuBtvDL4Urv/5mFRur4E1J/XleK5JXEHvNP+74kxtBwPpsBo1pyo4edouhh45fCkVG/tofPNUz7GJ+duus=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728958997; c=relaxed/simple;
	bh=eT2kjWjBtQHw7iYBXwZKhu98lvpdqSuXYISDMP3rHac=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=oT/nwPb6H+It8sSbAJZ3VsTamSBsfYHWR/B4l8L4lGuoaEbxbdQo5j961Y64XGV7G+2rnNBm5zs+WvcIviVPj41ZvpNl79Ad1LvKdPFxSt7DAd0PnDhT1bxVw3KsvDNuxTjGYZqeJ/3aRFj7DrVnxD5YcEmqZZf+ZkCUvqPSzZ0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dcgoYuUK; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1728958995; x=1760494995;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=eT2kjWjBtQHw7iYBXwZKhu98lvpdqSuXYISDMP3rHac=;
  b=dcgoYuUK+Am52iB/uKQs9GmgcGNJNifUpZuBELx/sxrCNpDyvJ7ycbq2
   DerIfB6RhcmJjs4pgDEDIrNO9wEXUxitP7WOQbYmw+yuC+euOsP5mA7DV
   r3DTyhYiJju7laoZFjZxiMp2D3Ax+uXOEIFdTS2JeqUPosHe6aQW4Slaa
   Rx579L0peLennGo6jApOHcIbktWQNOwcS9pbTud2Ryh6eG/T/BmvAdFIK
   Y/hwJ+wTFvZMwirEI2aA4X/UicWV0ZkwvFZY0y687gVZO9X2h3PREGIaH
   VRaccSLKjlAn8yMZ7x8F+WfVFvs0ULOLV0EmzVdnuaY986cze8yivqKvq
   Q==;
X-CSE-ConnectionGUID: f4VeaREWTrCua2J6u/g2TQ==
X-CSE-MsgGUID: 626XYs4gQJ2iXm6Nx0AaBA==
X-IronPort-AV: E=McAfee;i="6700,10204,11225"; a="32250877"
X-IronPort-AV: E=Sophos;i="6.11,204,1725346800"; 
   d="scan'208";a="32250877"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2024 19:23:11 -0700
X-CSE-ConnectionGUID: M54PI1ueRW6QQ70PUWCqUw==
X-CSE-MsgGUID: UmJDmILQTniWtJ9r5Nz8fA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,204,1725346800"; 
   d="scan'208";a="77828254"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 14 Oct 2024 19:23:07 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 14 Oct 2024 19:23:07 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 14 Oct 2024 19:23:07 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.49) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 14 Oct 2024 19:23:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fxY5+t/NG5LVTJsk74xfXEdszEJQbKqJ8KlnMegmuqZCLuC5hnEZZHQ2GHbIfUqrxEFASyXE1CMUTI1d5j9ND5C8vLi3fTY33Vf10Sign8RYxRWYBK3/b8Z5KKSOw+njvRA8VyquWe66JLlmCWwG4EidLRo/3XdnbiiUoBEyge8JNrldVAXW3qDyeeoDZ4gbWhlQznZsQCisx5nzc5CmO0YE93BWgbZPELrw0k/410kjupyuUV4AWB/TvaPHEOIkvqeHjn2prA5ZiTDr4y7micfjnFKgo7wDHkQBxeWRobWRZru33HqrJuTI3zCTSc/OwMb9pNAQ+Wjz0tSCiFCpNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ETdYsfVGV4upQRKIvFJavJmL/uZJuXMWdYMzvPYdqpc=;
 b=mRSwFZ0aJyAq/cX3e6t9gWzPRvrzMhAIvT1js8ddREalGQKLYCjS5kInpDcgdFLhhhDYSD1pbdK62S8fqqrSFuILlHtzjII3AhU1c1vp8JJZPI2K25tY7jZt2AmWcwvZxN7yMblaFL5VZvVRxaFcd59qc2VTA1LzK/3dB+ycGTQwpgAG2TvEXuhD4J3PQ/xw1GoJEYGHEPEAVN3e+tVKKQboNEkQYLPkFcIekJ7SJOZ9CDFlymZNzbcfMabnR0PVsUfSiizz0JR+7oE/MeEZdBVLemReLplJ/5oiFYBU+H3/rOsIT7ivr4ES7gpt1Miqe9dypaKuhM0SmLgdH2aOGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by SJ0PR11MB6693.namprd11.prod.outlook.com (2603:10b6:a03:44b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.26; Tue, 15 Oct
 2024 02:22:59 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%5]) with mapi id 15.20.8048.020; Tue, 15 Oct 2024
 02:22:59 +0000
Date: Mon, 14 Oct 2024 19:22:56 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Ming Lei <ming.lei@redhat.com>, Robin Murphy <robin.murphy@arm.com>
CC: Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, "Hamza
 Mahfooz" <someguy@effective-light.com>, Dan Williams
	<dan.j.williams@intel.com>, <linux-block@vger.kernel.org>,
	<io-uring@vger.kernel.org>, <linux-raid@vger.kernel.org>,
	<iommu@lists.linux.dev>, <linux-kernel@vger.kernel.org>
Subject: Re: [Report] annoyed dma debug warning "cacheline tracking EEXIST,
 overlapping mappings aren't supported"
Message-ID: <670dd20098d9d_3f142943d@dwillia2-xfh.jf.intel.com.notmuch>
References: <ZwxzdWmYcBK27mUs@fedora>
 <426b5600-7489-43a7-8007-ac4d9dbc9aca@suse.de>
 <20241014074151.GA22419@lst.de>
 <ZwzPDU5Lgt6MbpYt@fedora>
 <7411ae1d-5e36-46da-99cf-c485ebdb31bc@arm.com>
 <Zw3MZrK_l7DuFfFd@fedora>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Zw3MZrK_l7DuFfFd@fedora>
X-ClientProxiedBy: MW4PR03CA0281.namprd03.prod.outlook.com
 (2603:10b6:303:b5::16) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|SJ0PR11MB6693:EE_
X-MS-Office365-Filtering-Correlation-Id: 963d4f0b-c7a3-4c8d-dadd-08dcecc0498e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?qjngRkeJ8CBBWoIcPIvfRzWHhKhmWOSiz0KRmG3x7qAQboBAI2BmAYcrFJ7+?=
 =?us-ascii?Q?iJQumoBpEFedC7XvFXmt3+8/8xDLVJqsYKx6vtcpMUXX61xPS2Xhk9BSiPaY?=
 =?us-ascii?Q?Z9Nget3Uot7NUT6iVvOw6NoJKe0o3yHnV8m7LV4laY/edmAwJYO03bXvy6X0?=
 =?us-ascii?Q?hABQWXJIzZM0p6NIGgbYmUA9p2+AxrJB6dk111jgH2foKiwyKGkI6ScBT4nd?=
 =?us-ascii?Q?/yL1SSueCfVBZ8+yosaYELHSL8m60iQYXMleCXVRibVlUQ+SErn5NePGi4nx?=
 =?us-ascii?Q?P/NA3JSrps7RevKuZUNOWcvmBsK7iAVCa7xV7AoU6xV3omEVzvkjCnUeAg7Y?=
 =?us-ascii?Q?B7UT4nxbcFFIiaLNPbBPhYNA4bXSVNM7V7l9TVNx1q2f6DtE+FGlAfrfrAvZ?=
 =?us-ascii?Q?nJVwgKAghordxZf2hNxtkt9h8bTCwxEdUhklw6u0WhQNEYXdAnZTGhwnv6EB?=
 =?us-ascii?Q?pBTCK9C+gN0nWzZ+yjH8q2VfIN36e8vwlWll/iCp2lANBwKsYHCfcusfEMDn?=
 =?us-ascii?Q?OGVBm83LBrBSt7Ohq11PMJU6nddeFXcLQeGxKpy7TqhIOluxpGu4Bu27v31c?=
 =?us-ascii?Q?4EzIuEPJqbckWjsdH6qvVgtTk//4dE36PGS6DMFlfIhpIqF53Dpbq0H4E58b?=
 =?us-ascii?Q?BzufIqyHgPLLq5mbMVYyBNRMmACOIWhMUlMTjNE/y4ev5zY6QAraUtUn5kvI?=
 =?us-ascii?Q?LCrXo7FELw/PmNgYzROyK7Wmv5jlz65VdK+rnG+jfMhnEx/TwH0Fn894r0Oc?=
 =?us-ascii?Q?Q6e8F8x6gbymO6d3se80SLn7Uajzd8xxrwUmWr6iXz76yzKMnZ2+5xiUjrVx?=
 =?us-ascii?Q?72IEWa9kbt5pmczQ/yQck30HL1TOSVPNz9g+8Bep1qQZEBx+O7HIKkiDntYM?=
 =?us-ascii?Q?sVMGlPQaREZDHOGXpHr41MxlMrZNMdycqbCvukJ1u2FPYvU1r2HNMxFCa60w?=
 =?us-ascii?Q?JHwsbSFduVuJ+Zf1JJiCoTXUbkWxM861LHsToxYzBXv8ZoGyXYbzOQakNWmF?=
 =?us-ascii?Q?cRUiGBzDXsc0Xg3nWU1bFDGBI5x1ENmDIDut1Te7qWcEnRy1YwHWlWTYV4bs?=
 =?us-ascii?Q?UIQW3S78wrrJBX6n1+nf7tpJ3J51Q+58DvsK80hry9i6sJ9tSCh6faeN5heq?=
 =?us-ascii?Q?OfbES335BEUB7VLP1/xBAo1VQF5ABaefvM1zgRKqZVypyUyDVIrRq4j5Uhfn?=
 =?us-ascii?Q?3kB3PKPZBAEizBW01e/vl0vKxUcSyQX8m2pF8dXnGY/MXC66M/cLGHO2Awk3?=
 =?us-ascii?Q?3Qk4HZ0T7maoKh3JMWEgRb84r3fO0pA8MpwSvFsMAQ=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?oiJkDguDf5TpQnpvAUn9DeRQlRyIhy0v6Zy321wHFJnHsongPgDxOxwENpJX?=
 =?us-ascii?Q?wvmsLSfTk2072DI6VeV4XVWs2IbIYaA37ntWL2cVLaisqhgT+AEnOuT4CJ+4?=
 =?us-ascii?Q?MvyK6i+GnjJgdnp3T8MmIzE//mOgIGQwtttMv9Ut71YUastCx3JV2cj8z9kv?=
 =?us-ascii?Q?c/o3/EAHRbBdX30QpIBnYcTxPBY+mvYVGa2zltzeTeiBUBh+djp1DNEMlgGK?=
 =?us-ascii?Q?5zG2j6AzD6o80vCFK00CjYBM9gEi1OBSGOjp7l5nkbmrsObybYxPXY1vT8hm?=
 =?us-ascii?Q?O/ojujC2BO7tyisgZCsLh4Tuiie8RarF/3K4AirQ0RrtxTVY+mGsBWm2+OWg?=
 =?us-ascii?Q?73hi/5xUd7eWUA3zlwshPJ0EmRK9UraaVUqhILw/muaBngR6TUrFxf5c4Ngt?=
 =?us-ascii?Q?XQmqXWYFKj1wPNaRcoE5uaxj13x7jS/elKPB+VFZvx9QPJLOdUYdo8PeNXeb?=
 =?us-ascii?Q?CBdToSiXnT569FSwQZ8zLo0xZWrIRqNy8VSo7BaF+9YeKIe5pHDNgLk323O+?=
 =?us-ascii?Q?TfZmBUurPUHq8hFyTaVPAdSPTcgrxOHrLIys08p53zoAtR0RI2bAomppYYW0?=
 =?us-ascii?Q?j7D0DdieaP01nqj/Q2GVnHeF7lNkORqsLHa4WTF7RM9kJswDgZr11OETPeJg?=
 =?us-ascii?Q?5jikghuCkNSU0X4e3OKwjD+65FkqaY1ScycYvds1VCR9nkRn445ZRjDL7lB8?=
 =?us-ascii?Q?HtmVoEYz84Wp9ApUnNR7mCl7OATgiIBYDocDGTp0EI65PuG4AiHEPa+WgZ3D?=
 =?us-ascii?Q?2tW2TRKJxFH2z7MDkuPovvlyN5uWgP+Uia1vZjPg67BCN/zZJcnCZbS50Hb6?=
 =?us-ascii?Q?91ZoD9BBTO6ctWFrs7rnXUv2xcivmkCJfuPMzwGvlLCDQrG4JTTShHA0FvKf?=
 =?us-ascii?Q?APGezmBehpTqQ79iPAAnrQWTcwkr5AewK+3r3I1x+mddzyi2wfjluEns6D7A?=
 =?us-ascii?Q?4p7Tv5aO/hF8ye7Z09InigHB824OvjPxlzoJMt5Yocie2c8MDyNvOGT3fX5M?=
 =?us-ascii?Q?474V5+24Emq/2IvaCxfSaLCRsJdV9j8PEs+g5YVjsMqQQAdIjRRSyFRLXwJ+?=
 =?us-ascii?Q?W7tfKtLjT3shFrHZ2XHDw1E8KiGWth39/pFuzT8tTVxJott+Fs/5jhRgJ4Eu?=
 =?us-ascii?Q?iLh1PpAuUCdnEg59NznMPul3s0gVygqZExsfpjE4PBeVe9g21oxYDX1W25eT?=
 =?us-ascii?Q?OlL0zfXr3J780nstIT1s6Zwd60NFddolgeG/cZ1Fa1XNKeL2tg1497PrOjno?=
 =?us-ascii?Q?6OtVTG7IjF6c5EGpgGCtCciKSn5c0yz+P4lKsyaRZw18Z94RqPxQyjnoKkDI?=
 =?us-ascii?Q?0PQeKSssYur9JBF2L9FfytD8NhbfIXi9xKDeI/r7pjhW0LJkdmwlcYAvUXvd?=
 =?us-ascii?Q?usQ7XxXZn6m4zEiFPh9CMnFEUZwFLEze1PQLGQqz+oz8eRrHvaDm9Wk/EdE6?=
 =?us-ascii?Q?iFs53ugXJgYszV/7GpGWl/NDZq7xNjrAwBmSk2s9ddpUINzlZRPnA80KeHWt?=
 =?us-ascii?Q?kIqi7cu5yJ2PZdtoj7XZSUWMuXFyJXzZi8PRo7Zbimz67iQFrkzLRABhTytj?=
 =?us-ascii?Q?Dubzu2e8Rk5KN8BnHrYtb2nmH38m1Oc5+HRsbBk+4ohERdd9DwhsoCZRO1K+?=
 =?us-ascii?Q?7g=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 963d4f0b-c7a3-4c8d-dadd-08dcecc0498e
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2024 02:22:59.2570
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Kn3y1wX+oEC9xLyouZvruVsLdFvNzxnMMhIwmn7Dkkbim2kT8GymRBG+Mq1vdtIIgPPiszf629ymF1zb9JgmZEPZYcBpjAEPtb8aNv7dS50=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB6693
X-OriginatorOrg: intel.com

Ming Lei wrote:
> On Mon, Oct 14, 2024 at 07:09:08PM +0100, Robin Murphy wrote:
> > On 14/10/2024 8:58 am, Ming Lei wrote:
> > > On Mon, Oct 14, 2024 at 09:41:51AM +0200, Christoph Hellwig wrote:
> > > > On Mon, Oct 14, 2024 at 09:23:14AM +0200, Hannes Reinecke wrote:
> > > > > > 3) some storage utilities
> > > > > > - dm thin provisioning utility of thin_check
> > > > > > - `dt`(https://github.com/RobinTMiller/dt)
> > > > > > 
> > > > > > I looks like same user buffer is used in more than 1 dio.
> > > > > > 
> > > > > > 4) some self cooked test code which does same thing with 1)
> > > > > > 
> > > > > > In storage stack, the buffer provider is far away from the actual DMA
> > > > > > controller operating code, which doesn't have the knowledge if
> > > > > > DMA_ATTR_SKIP_CPU_SYNC should be set.
> > > > > > 
> > > > > > And suggestions for avoiding this noise?
> > > > > > 
> > > > > Can you check if this is the NULL page? Operations like 'discard' will
> > > > > create bios with several bvecs all pointing to the same NULL page.
> > > > > That would be the most obvious culprit.
> > > > 
> > > > The only case I fully understand without looking into the details
> > > > is raid1, and that will obviously map the same data multiple times
> > > 
> > > The other cases should be concurrent DIOs on same userspace buffer.
> > 
> > active_cacheline_insert() does already bail out for DMA_TO_DEVICE, so it
> > returning -EEXIST to tickle the warning would seem to genuinely imply these
> > are DMA mappings requesting to *write* the same cacheline concurrently,
> > which is indeed broken in general.
> 
> The two io_uring tests are READ, and the dm thin_check are READ too.

"READ from the device" == "WRITE to the page" (DMA_FROM_DEVICE).

> For the raid1 case, the warning is from raid1_sync_request() which may
> have both READ/WRITE IO.

I don't see an easy way out of this without instrumenting archs that
can not support overlapping mappings to opt-in to bounce buffering for
these cases.

Archs that can support this can skip the opt-in and quiet this test, but
some of the value is being able to catch boundary conditions on more
widely available systems.

