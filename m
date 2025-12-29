Return-Path: <io-uring+bounces-11317-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 142EECE623E
	for <lists+io-uring@lfdr.de>; Mon, 29 Dec 2025 08:32:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B1D8F3007C6D
	for <lists+io-uring@lfdr.de>; Mon, 29 Dec 2025 07:27:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED9E3246BC7;
	Mon, 29 Dec 2025 07:27:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mT4GZNCl"
X-Original-To: io-uring@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02D0E2459CF;
	Mon, 29 Dec 2025 07:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766993272; cv=fail; b=FaTsdxyipS/C3Pv1CNLyESvYmNpYKShX22zzyT0/U4D9pFII23TFQnCkzvl74Zu28w3Se3b8/2DfJM2UehNLm/SzndSipUIm0ssGgsOpZjeSOaxLIAPqEjVWBVyO+0E6PcVsLHpCCqIRtllMG1EsfqW6DndlY23CLlWdXv/iMBw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766993272; c=relaxed/simple;
	bh=Tkyo9THZwT916ffiGh4BmjNLz2IeKnaARa+q6S/ArTI=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ATEbSMsngwXGebPUeQaAP32yRFsGQo4gAyDG3S/fKHLONdrewtJN6keheEXu92j10GTGnYYbllGLKTI1PeFNQXEKTBzr4A8WywP0URxKU2l+ylSDFfOs6qdvAJM/nXY/mlKnvRItNelv3m5xt9Nke6+BQDqw1Ko8YZyJ5Nd09N4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mT4GZNCl; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766993271; x=1798529271;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   mime-version;
  bh=Tkyo9THZwT916ffiGh4BmjNLz2IeKnaARa+q6S/ArTI=;
  b=mT4GZNClEyNocEhWVevjCZCFvT8vc8pQa41v+oE+biF2/XorNl0Eg2lg
   wMnBsDXxnDvPsCncNQ4AjP+crg2fPMi5R8cfEnmWN38l1U3/32mgfVDRc
   1ewIBi6Z5jInrPdRTQ1MGc+nJ0SD+VYjK9/FtrhVA/XcUC1X9HFBhdJW3
   ve2Iauc4ReKZyGrXP4nnqJJh0qAeVrZzpRGdVpEVOc8gli2r+NfDPAPkW
   /b6IAcRcSeF9GRMN0uKcYP71NwNVYMtdH6YXM6kKibom5J+dnwRcfNJet
   P3wChs0ipnOBxYCgPD2+yoKPvT9NBOpzBThw50nn0Npygahd9y0jPTp3P
   Q==;
X-CSE-ConnectionGUID: tl9Z9svzQlWkTJVkeCuXUw==
X-CSE-MsgGUID: bAVM3qdpQTyv/nl5djc0GA==
X-IronPort-AV: E=McAfee;i="6800,10657,11655"; a="86184396"
X-IronPort-AV: E=Sophos;i="6.21,185,1763452800"; 
   d="scan'208";a="86184396"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Dec 2025 23:27:50 -0800
X-CSE-ConnectionGUID: WetOiFKNRRG8xrkYQ0fcGg==
X-CSE-MsgGUID: eaTUJTj6Q6acBqr9zDnkCA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,185,1763452800"; 
   d="scan'208";a="201781492"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Dec 2025 23:27:50 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Sun, 28 Dec 2025 23:27:49 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Sun, 28 Dec 2025 23:27:49 -0800
Received: from CH1PR05CU001.outbound.protection.outlook.com (52.101.193.5) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Sun, 28 Dec 2025 23:27:49 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OHJbKAs6Znrt8C9a2lkS8JVwSOWDeUUkQayAF4nPJTPEz1qHubL8VfAO6T1comfq0VXCNPVOdI1On7Uyd94bMpYhHkPboTSeZHsok+ytZWB6Fj4ZWf1Zu9/cNIt4Tu72jT3udk2Nedr4dElL8Dv2VyAhogIys4qlSE718cMGtgRnyiq6aM3XqArQL7ziwWSYhPI8yexyafimMFhokKS2RiVekp2IDOJwc+xWSmGC0nzXRhiaIt2iulk4h7SJFs5ElqxBUAVdRU7tXypREUToQe//GyJGM1YKg0o8TxD+5+pJwrruR4nKTawl7fuu1w2GHbQV2M/lgZC9fpQ3V4Nnug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v9qHGvngzUnnki2PndYIPWmVSBj50EQIQNLaB3YVbX4=;
 b=QFjZTOhMdXBO5wIf9Yo+H6qfcaQpbhizU837+LINLOLiDXzL7D5H6Ep14wRg4PgZgWXWzaVX7X4Bklzczw5Y0sn/qjbQFXAwHcLXZCs4fh35Pu901e2zqT9b67SmFhYpFzm0vpk7OrGq9KqkklF63ZRcaP9s0v1GZpMBitthJls0EScvC/XVDpUIhkV0CjPSuW5Q3roVm3X50EkejxatRRss0i4Q0D49kVQGxpQGI5Py7edh2M/+yHEqok3PBqjn+MMjiftSZtf8B7X/IC08yXIjyUwvccirOtTT9EaLi0x31wsMCzjw05TE3w/gDLqLO09EehH36nayzajGE37lrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by IA3PR11MB8894.namprd11.prod.outlook.com (2603:10b6:208:574::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9456.14; Mon, 29 Dec
 2025 07:27:47 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c%5]) with mapi id 15.20.9456.013; Mon, 29 Dec 2025
 07:27:47 +0000
Date: Mon, 29 Dec 2025 15:27:33 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Christoph Hellwig <hch@lst.de>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <linux-btrfs@vger.kernel.org>,
	<linux-fsdevel@vger.kernel.org>, <linux-nfs@vger.kernel.org>,
	<devel@lists.orangefs.org>, <linux-mtd@lists.infradead.org>, "Christian
 Brauner" <brauner@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, David
 Sterba <dsterba@suse.com>, Jan Kara <jack@suse.cz>, Mike Marshall
	<hubcap@omnibond.com>, Martin Brandenburg <martin@omnibond.com>, "Carlos
 Maiolino" <cem@kernel.org>, Stefan Roesch <shr@fb.com>, Jeff Layton
	<jlayton@kernel.org>, <linux-kernel@vger.kernel.org>, <gfs2@lists.linux.dev>,
	<io-uring@vger.kernel.org>, <linux-unionfs@vger.kernel.org>,
	<linux-xfs@vger.kernel.org>, <oliver.sang@intel.com>
Subject: Re: [PATCH 05/11] fs: return I_DIRTY_* and allow error returns from
 inode_update_timestamps
Message-ID: <202512291537.9abd5523-lkp@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251223003756.409543-6-hch@lst.de>
X-ClientProxiedBy: KUZPR04CA0003.apcprd04.prod.outlook.com
 (2603:1096:d10:32::15) To LV3PR11MB8603.namprd11.prod.outlook.com
 (2603:10b6:408:1b6::9)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|IA3PR11MB8894:EE_
X-MS-Office365-Filtering-Correlation-Id: ef259fad-3f50-4f69-c4b5-08de46abc3e7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?0Cd0s7A8fpyr8fOR804C5ol5oNxqbmarE3ISerrDNeRCs84mHQUEMoNI7X+x?=
 =?us-ascii?Q?z8BHO13jt0cWQPZGTF0y+BDNx2DF3fgOUvFJN03H7o/2zLDQu/1idw04iJAY?=
 =?us-ascii?Q?bWSv61kt2lhl1OUtStPNcYSfrZOj59SrBUfHEcWxBTLkl2CPV87t8NY7t4li?=
 =?us-ascii?Q?1JXpX55Ez6l0EKGsV48d3yeUynDLgU1EiVsiZywDT6iH/oDF9y7cm/+xcDPF?=
 =?us-ascii?Q?cmpwOAifWpbMuewyPyEwBu4xF6JZsKAW6mEeWA8mzWnaUnva4xSvNW0YxOHp?=
 =?us-ascii?Q?yAA75srv7WwXOwThZ+5ca5eg9iSBOKJFC3IObFd1Z1cP4Y2Wenf0OALKGyiv?=
 =?us-ascii?Q?MggOh2OZ9NlpPYq5L7cUb29SF9lGAFAZMXoOd7h4xn3lwBILWq0emVH22ckC?=
 =?us-ascii?Q?t1r8EW9qM6HnFTLT3/QspzHH4ktrCKMXMV2dOwNIKWNFZE+PYusifcfoen+w?=
 =?us-ascii?Q?wMlJ+ZC0xBcW3duALfo0LiPNWAkqjsXm52fAfwUGG6XzFHveCnb3k86t1Jnd?=
 =?us-ascii?Q?cE30j86B0qKLgg3TgwoztF7PK6MeZ0ARNq6Du9Uqq9xLmykVF1ttHypT/00D?=
 =?us-ascii?Q?uQK+vVMG82TTwYVPsT+E7H3MCnJBTJdFwDjsoIzD5B/Tt2Lja+kxioNL9kmx?=
 =?us-ascii?Q?tXokfaUcHWSdUCMm8GEcYA1J//AJF/Bid6w3YMmHe683Fzojo5ZeTl9EBTbV?=
 =?us-ascii?Q?Ixdg26qCsUMUZTPSTsEmXVCG5cu0hPtIfWyzZwmu8t10xoM8E4ee9ANj+XJQ?=
 =?us-ascii?Q?3xzZc2t1cdRLhr3tlEtDjIN244vCA1KkuYsNIzMgsbbF2+DzP9m2XsH4Chpc?=
 =?us-ascii?Q?CYy6KRjszupCErRRi8MghVo5fIe7+hf0jslVD0ATh5I5lxiTvflkhKnD0owB?=
 =?us-ascii?Q?oHZO8XUmRF5fMOmTMljlEmIHet7L45Dbx3RONS7GUF8NigqEueF9hlztQojx?=
 =?us-ascii?Q?sWLH4g0YOjITSy0RQh8XC4AqhRpvaO89BoWG5q9pyo5PweA/Ry/XzZ9FPv9g?=
 =?us-ascii?Q?zzg04V2/QLAggjqTq440Zvx0G8iT+e4k925QaoapKHij1E6MihMyaLirOYNK?=
 =?us-ascii?Q?gEpAvOEnAZxx2KmJ2VigZ1Z471rPBj2futzHC9XHJnTb4e2fKf3kw0WR5hPP?=
 =?us-ascii?Q?uIx8mVaboAjJRa5Xd4Z5BTx06Fq8+6sn0bpeCwIYNd79Gc3lqchooKtCQ93/?=
 =?us-ascii?Q?Yi2avbUtavdNRyGnXdLRyuH+s7gCP7P3XeCpHso6S1fBNz1ptLDFlAWtn1Jh?=
 =?us-ascii?Q?nZcMcMaqonSyLUan6K8m6aA5+o5FnpimSCONgT5oeVOMuly+xVD/YCtVoi5f?=
 =?us-ascii?Q?e1zyeQAn/pGyuq+wpJYGRU08tYNVLBJwxACsDzWeIgMO8mmSVCEeC63wMdI/?=
 =?us-ascii?Q?KIuMG46UjVuk1n/apP7rr74vrkBlvCOeyF2HlFpEacjr6O7SG1pQplpRoGvv?=
 =?us-ascii?Q?WGwlys4IuC0NEEdK7EAaYG1U6KEU264pcJuogmnAVr1kdZJ6zpM1bQ=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jpqS9jOs+CMkNdyFGj/NE6e0pEqpcUCzaOct7wZPeN5f/U+RqWqq4zoK8XUp?=
 =?us-ascii?Q?Sqyg8X1OlOKHZv4lo1Mnb/k3EoxAnAITVq3HdcOnoZUm2zwUHWC+xQ3Tis4V?=
 =?us-ascii?Q?OOMAaf3k2oHIFwtm3HcW5/mrfsFXwSsvsZ2aAK9nwYJGlHbx3d0Syt9ONgSG?=
 =?us-ascii?Q?akeUweGzvNqrOVknmLQf6/+2895et6ZzsyAeJPOWa2vfgHY7Wj3mxsPkRgXV?=
 =?us-ascii?Q?WtzthCqSiaqtXGU6LRfek3DD7hCrp1kK8i0LSPDPL/c/bmO5pLbSbtQBFkEm?=
 =?us-ascii?Q?y81JLLs+E4SxDooLepmvj6Rva2l9g968ChshbePSx9tdo7qhrPp27zkfV18t?=
 =?us-ascii?Q?/971rfy8KFwAQBprVkSX0AUKNk+zU7WWY3HC+vCn2Whk2P63j3QHwuVHjiq0?=
 =?us-ascii?Q?OFb/d/QHeNJVzfqaCLCSgfgrWxTG1N7h3KPXROvnuCsf869tZwtNEvM1qVq0?=
 =?us-ascii?Q?Qds3OiFxEjeNirH1+Tw0dhQr4rYXr/3bu/ajrrA7fqXgCcf0V0rZKd2WkjV+?=
 =?us-ascii?Q?G/DKf9KdJFMW2/RtLEDC/ZR3j8bkINoWLcmXOVCWCSY1YaNKJezv/sX6hZF4?=
 =?us-ascii?Q?CPN69gbJXOI8CCbD9ro5nhpcIXYbH6hsiHZZR13RTG+VjVT/xN+hS5U95p+T?=
 =?us-ascii?Q?nWkvL1uqq6AOssEFJqnGC35GZC8Kuf9XHl0DlBsgobc8Ot+W08mcOEuAUNFf?=
 =?us-ascii?Q?eV8lrnysSXxbdA4MbAvYVKpGXF07y8zBuwCJ1LPlQZT/XX9gDs3+MirllbSn?=
 =?us-ascii?Q?7fpaUfhAhJzUbGirmY55GZQ5Yj1HS0pX1EGZsIprDpApatMotmY9PVxgO81l?=
 =?us-ascii?Q?Zud42x2BUAFcdfKJddEp1vpRxg0mpSOUZ8lbgD+OC53qoByMnAlxnKITUBa4?=
 =?us-ascii?Q?J2hEe5kKPxr76z04PpHzNQt6pr4+vCqQCb+T/NXcRHQpWSfombhpFyMkGl95?=
 =?us-ascii?Q?5qJnR5WVhBQoOcfFOWXjzs4ZfMQSZ5koBRYGJEGV7TO94t6OgMsx1iaKa54y?=
 =?us-ascii?Q?HO0DmIY4DUucQKjOKfKvmGfOPsJIC5SzCsNSZpXlUig4JL4OzPNkZ4hu7IDs?=
 =?us-ascii?Q?gqZ5nhO1kj9o+GkvBO7PYlInFyyKfRggTuyFdeimbKQ2xi1S1feigVMPd8G6?=
 =?us-ascii?Q?KjGxVQQyWmKlsobFwHPC1nM7oGYsWoWW6qRZo69nTt/sd5p1SdbSO11Jwh2W?=
 =?us-ascii?Q?vj4uhLK/y4Qf6BFnwtLxorNo0RyXW2UMa8cUZFQ1mUw+iKosClDx0Xj4fU0P?=
 =?us-ascii?Q?a/Hp0IERyadn6rmFLiv8rgBH/GVjaHLB0RNjeQgGAAhJDx3Yb6TaqAcVGDpK?=
 =?us-ascii?Q?hETjT3ewgYjSBQ54O3FmyIMZtgo7ifqxggsLS20Ymtvj6E/Q7oPS4f48gEu8?=
 =?us-ascii?Q?+GNiPJ+RBm72F80tAYZqf26HQcvWqdVF2YWltQkB89iPD7iLfHAVwQAjvKip?=
 =?us-ascii?Q?5EoVECJ4xxm4R+gkek52KP2yDifDHntRjgBEaqau4hqZ2LLUYPeCGjKghVKg?=
 =?us-ascii?Q?sqzbLaOmqZ/ie7U8+Ht8vDPraNLpnTYsFMm4dugdsjA13MKyc37KxclvYcWM?=
 =?us-ascii?Q?630WhUWhpQYSL6Xe0iyMgyULkpOMGapr9G20q1Mw7Q4oKKFBcbUErJXHkQSb?=
 =?us-ascii?Q?c7WrsLtktixLAbokZD2m4OiEXkSQXUG6EDu94RLWe17hLaDdxDapzB6tvgtG?=
 =?us-ascii?Q?lyEx+/qP2uMtvh81vH8SXJv5hcOU9KSrDhFKcsZErrKXtKWy+WiSIgsxJX7Q?=
 =?us-ascii?Q?Br6l6y6HTg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ef259fad-3f50-4f69-c4b5-08de46abc3e7
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Dec 2025 07:27:47.4323
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QvxFjHdRXwb6I3oNgbfYVFyY+6YsZDiHHn9+niMYBElpmGuFm1HbCrElicGaBfWG1xJhZGD4/si2tkWpDqOp4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR11MB8894
X-OriginatorOrg: intel.com



Hello,

kernel test robot noticed "xfstests.generic.324.fail" on:

commit: 515788c3eccaa35a6a34f8eed75e2a598172dcb0 ("[PATCH 05/11] fs: return I_DIRTY_* and allow error returns from inode_update_timestamps")
url: https://github.com/intel-lab-lkp/linux/commits/Christoph-Hellwig/fs-allow-error-returns-from-generic_update_time/20251223-093805
base: https://git.kernel.org/cgit/fs/xfs/xfs-linux.git for-next
patch link: https://lore.kernel.org/all/20251223003756.409543-6-hch@lst.de/
patch subject: [PATCH 05/11] fs: return I_DIRTY_* and allow error returns from inode_update_timestamps

in testcase: xfstests
version: xfstests-x86_64-a668057f-1_20251209
with following parameters:

	disk: 4HDD
	fs: btrfs
	test: generic-324



config: x86_64-rhel-9.4-func
compiler: gcc-14
test machine: 4 threads Intel(R) Core(TM) i5-6500 CPU @ 3.20GHz (Skylake) with 32G memory

(please refer to attached dmesg/kmsg for entire log/backtrace)



If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202512291537.9abd5523-lkp@intel.com

2025-12-27 02:57:30 cd /lkp/benchmarks/xfstests
2025-12-27 02:57:30 export TEST_DIR=/fs/sdb1
2025-12-27 02:57:30 export TEST_DEV=/dev/sdb1
2025-12-27 02:57:30 export FSTYP=btrfs
2025-12-27 02:57:30 export SCRATCH_MNT=/fs/scratch
2025-12-27 02:57:30 mkdir /fs/scratch -p
2025-12-27 02:57:30 export SCRATCH_DEV_POOL="/dev/sdb2 /dev/sdb3 /dev/sdb4"
2025-12-27 02:57:30 echo generic/324
2025-12-27 02:57:30 ./check generic/324
FSTYP         -- btrfs
PLATFORM      -- Linux/x86_64 lkp-skl-d02 6.19.0-rc1-00022-g515788c3ecca #1 SMP PREEMPT_DYNAMIC Sat Dec 27 10:49:51 CST 2025
MKFS_OPTIONS  -- /dev/sdb2
MOUNT_OPTIONS -- /dev/sdb2 /fs/scratch

generic/324        [failed, exit status 1]- output mismatch (see /lkp/benchmarks/xfstests/results//generic/324.out.bad)
    --- tests/generic/324.out	2025-12-09 15:20:52.000000000 +0000
    +++ /lkp/benchmarks/xfstests/results//generic/324.out.bad	2025-12-27 02:57:33.966266526 +0000
    @@ -22,2509 +22,5 @@
     XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
     Before: in_range(10, 40)
     After: in_range(1, -1)
    -Defragment file with 250 * 2 fragments
    -wrote 1234/1234 bytes at offset 0
    -XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
    -wrote 1234/1234 bytes at offset 123400
    ...
    (Run 'diff -u /lkp/benchmarks/xfstests/tests/generic/324.out /lkp/benchmarks/xfstests/results//generic/324.out.bad'  to see the entire diff)
Ran: generic/324
Failures: generic/324
Failed 1 of 1 tests




The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20251229/202512291537.9abd5523-lkp@intel.com



-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


