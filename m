Return-Path: <io-uring+bounces-9697-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0714FB50A1B
	for <lists+io-uring@lfdr.de>; Wed, 10 Sep 2025 03:12:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 12C241BC7FF7
	for <lists+io-uring@lfdr.de>; Wed, 10 Sep 2025 01:12:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EDCE1E1E16;
	Wed, 10 Sep 2025 01:12:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gjUau4Qx"
X-Original-To: io-uring@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3A0B1E32B7;
	Wed, 10 Sep 2025 01:12:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757466745; cv=fail; b=cwUTLNoT5WnChVpcu4Yxe4AjerfzQNCHhvRzTMFMooTNcFvpkYLJ1vY6JtnAFnlYPw+v6bGhSE+sV7TeCcR3mjtAlFlwggDhWjdOzM6jKMhkFC3inbjtsZRj2y16eupllXIqvOWvBI9UXyjoPqFDfqKcA5DfqKHlNIlsKNho9QE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757466745; c=relaxed/simple;
	bh=BeiPWTNQdqW5Q7sUzz1Dl0x60rbAPm/GEnx+lQBdoLg=;
	h=From:Date:To:CC:Message-ID:In-Reply-To:References:Subject:
	 Content-Type:MIME-Version; b=VNiUUsP7R8wMGKvc3sy9eXr97eN4/PB+DzC4PjYQ8gb4ukTU2tZtzD4nV6VLnNajPqquuBA9M5UMwd4inrFHz7N/ULsYbIzNFedRSz50InHUB2vQvNk2/AY98sZHVYugXLOM86lTrZJBCqPA8WhIRAKtRQq1+ce/r7c2qtXx3K4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gjUau4Qx; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757466743; x=1789002743;
  h=from:date:to:cc:message-id:in-reply-to:references:
   subject:content-transfer-encoding:mime-version;
  bh=BeiPWTNQdqW5Q7sUzz1Dl0x60rbAPm/GEnx+lQBdoLg=;
  b=gjUau4Qxaq0zhJ0Tq3Rt5qp/+Ws/lkYfVqhhjAnCyuBNP7VwjGXcQ3qG
   30Pk/JTD38KECBPKLVXIxar8WsiY8KcYZEiAoZ7fJOosBMOUNdpxQJpNA
   waS5De6uTd9chW81u/1f3bYgYNn4En7yFKQhx9GsxNf1pCV1sjDW7Wzl9
   CMBNHJK0rLfPcboLqeJbrZUTgrNb4E1OOSCIP0jO0Twx53uWkyiI/VE4h
   gtWeu5aoTGKtpmEyjiaRj0LNxJ9IGeW1cLnhr0vY7y1ohfZjzwJ/FteRb
   vJpSXdxJJ5x0xV9Hlf+BeKkJIkQc9UbV1LOtAoyrPgMcjiex3xaKojmqb
   Q==;
X-CSE-ConnectionGUID: wWmVhkoOQdaL6ljD7tQ9SA==
X-CSE-MsgGUID: viZLx6HTQTe/u0Nzy756wQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11548"; a="63397515"
X-IronPort-AV: E=Sophos;i="6.18,252,1751266800"; 
   d="scan'208";a="63397515"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2025 18:12:22 -0700
X-CSE-ConnectionGUID: 4Yb0I16vRkSPwCdGtn/grA==
X-CSE-MsgGUID: EfvGRXFWT1GPO4RkIhPexQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,252,1751266800"; 
   d="scan'208";a="172834383"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2025 18:12:21 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 9 Sep 2025 18:12:20 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Tue, 9 Sep 2025 18:12:20 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (40.107.223.88)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 9 Sep 2025 18:12:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TXpnsVD0DfbRk3I0Jnjj2l/SH8hDGBy2MVA0GjSbwDKbflkwaKUj6lGUjM6cVbzFH3gFrYqsyKP6iBr33DY4VxKMnEHrkE4jDHxxHzLRwTUrYTXHfcwZhOlL/lS/zd96+Yjd6gXvr0AzlqzkJpAnlzKirCw3DurquGziqZ2+JZZCk74RF3Pjbb+TIhq466C4Rg9i+wgBvxaJTYR87PBifmAeE9c/R06ZCxwModBXRBnTLyEoaZh9USunmHss+6RwzUtipc5EorkoPlccSxcd/cha4sFiKShjSNuJgUXxCZ+dmhVmGU9FUvd+03Gh6zBHQOLzQw2rPvHShiLQqRRLxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2krcDivsz2hfsfGYakF95j69YiMWq/30UQCNxXtuhY8=;
 b=u8PEsv1sFFS+8KIShnl8rvRGG8o3ZHdUW14jem/Ix29qFKGoBZkyDqtaNuIgNct4CJbUR98UVOHEc9y1KxRa7OX777YIxJyLT5I7udam+lw+B90XUOk38WZafsetUZ2p2vYKn7os82w2CnqnxRQttvD2EMIDiC2sACQH/+Xb0txwOBtg7SVSSOiKb2y7slrwIWx6GiFihMNgYC07vdNHNrb0OZ0QqjUu4mamGVgkEr+T2LiQXNSZ4var1RcltZ2WiC2HHTXuhSZ2w+n1dfUBSCFiMX5GZkhbVqpv0iFwTHWoniffei74LQCW9sNDMDBOsl0qEx/c+1xvjTZPdQF41g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by DM4PR11MB5262.namprd11.prod.outlook.com (2603:10b6:5:389::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Wed, 10 Sep
 2025 01:12:18 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%2]) with mapi id 15.20.9094.021; Wed, 10 Sep 2025
 01:12:18 +0000
From: <dan.j.williams@intel.com>
Date: Tue, 9 Sep 2025 18:12:19 -0700
To: Konstantin Ryabitsev <konstantin@linuxfoundation.org>, Linus Torvalds
	<torvalds@linux-foundation.org>
CC: Mark Brown <broonie@kernel.org>, Jens Axboe <axboe@kernel.dk>, "Vlastimil
 Babka" <vbabka@suse.cz>, Jakub Kicinski <kuba@kernel.org>, "Rafael J.
 Wysocki" <rafael@kernel.org>, <dan.j.williams@intel.com>, Caleb Sander Mateos
	<csander@purestorage.com>, io-uring <io-uring@vger.kernel.org>,
	<workflows@vger.kernel.org>
Message-ID: <68c0d07372c8d_4224d100dc@dwillia2-mobl4.notmuch>
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
X-ClientProxiedBy: SJ0PR03CA0148.namprd03.prod.outlook.com
 (2603:10b6:a03:33c::33) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|DM4PR11MB5262:EE_
X-MS-Office365-Filtering-Correlation-Id: 3dafba27-f913-4390-6b49-08ddf007161a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?S3puWWcyOGRZM051eEZSN0tDOVlqSS91MlQya1BVdnoxVlhRTFJLZUtsRml2?=
 =?utf-8?B?N3F2aThuVWx4MmR0Z3BsOVRLWWhiRHgrTHJEc2FINENDZlNhQVcrRUVEbk9I?=
 =?utf-8?B?TzV6WURZQVJ6cWtPaFVGMnh1K2ZkdEpMOC9od2NqUEMzOVpEc3doVzNNS011?=
 =?utf-8?B?aWRUMzVrMnc5U096THlrelNhRUd6WXZMekRMUmw4TVBia0ZCa2NtU3ZwVXZp?=
 =?utf-8?B?UXY1MHVGTWxZOUFrRFUxVEdJcnpzVitZUmpxYlFtWmdNMnRaNExFWWxud1Fx?=
 =?utf-8?B?cE9PVXB4MFBwdGd3WEpOVThqNWl6MVI1biswOWdNK3h0dGxnL0Z6UjVCdmVv?=
 =?utf-8?B?VW5TQkJrcWI1MTU0L1c1a1JleDBrN2hJY09EUVVYNWcwK1JXeVk2U2lBUFlD?=
 =?utf-8?B?Vzc3VXVWVWYwMCt2NDF2YXdVeXpwbWRTNlhMMkdpempHRS9vNHFuSGJkcG1z?=
 =?utf-8?B?TDBGU0gyVTM4L2tQQTdjNFZYcjl3WE9JZEJZdzdsNE4vNFhROFFwaXlXVW51?=
 =?utf-8?B?a3pTNUFmeHpENlVVY05hVzlMcXVrbjY3SVU3a2N2UGYxUlBmREllcnFQTzJq?=
 =?utf-8?B?dmNCRFozbWZNb2FSVmZ0enhGNDFuU0F2Q2xjYXFJY1lwQmxia0hDcUwzUEx3?=
 =?utf-8?B?L3U2aFdzT3dPMjFjaHk0aVMxc05uQTlqclM5Z3JvNnY3NDJUMHhxZDlRU0Ev?=
 =?utf-8?B?U01BRkNoemdHSGhuRzNqbFlrdWIxaFRNOGlEamhjZExQankrUFV1SkM1V1BM?=
 =?utf-8?B?c3J1UHdBWVhHQy9JZ1B4b3hVM20wVlUwYVdrTzRwekF2MEtkeXJrMHJ0WUl6?=
 =?utf-8?B?dVZoWDZINDNudWF4ODlwcEFFaU5LRWdUOTdLMi8vSlZhOUI4eTZ5OFlUdk8x?=
 =?utf-8?B?RjVlT1l0blZCQ2l6YnlCeGV3NExQcjFKYlQ5cnRxQzBKMHhyTlNBZVVIRjBI?=
 =?utf-8?B?OGcybldOa2prdGs3QlN2TWFnQmJ6dlBUcTJlREx5bERoNVVDRDRNRHhqb3NE?=
 =?utf-8?B?eGFpKzRIWlJSUFdkb0xsR3Q5OUYzUmFtM3A5amlvcGJrUlVpcHBCWWdEaHpo?=
 =?utf-8?B?b204OVhDeW9MTTgyNmVaUUpwUkMxUXUyRGFtZ3JHZlMzcUVubkhvRDRRalBa?=
 =?utf-8?B?ZG43WXZqTk1STVpKTUpIWUE5dFovckJzcGxheSt4ZVptSFBrbHp3WjJ1blJL?=
 =?utf-8?B?ME1vRHhOVXdTR3p6aW50dS96bUZrd3ZoSUxlZ2Y3V3VZOHVrTUJ3N2VvWWls?=
 =?utf-8?B?Z2M1aCtjTUd2TnVWODhRMVlBZkdqWjU3Zm9rVDMyYkw5WXBDTU5kY2FRRDd2?=
 =?utf-8?B?SERsdlRMNEJwNHNUSkI1T2hxNHA5UjNhODhObXh1bkN5L1ZYUEtHcm5aZUts?=
 =?utf-8?B?Wm1JQWpLTDBBZitzeElDaU5uNXd3dHRHR2NVTlNZSzhQNmViUEVVcjVYeVRY?=
 =?utf-8?B?SU02V0FscC9kemhnVHREczgvazlGWGdMb1FpR1VMNlFkd1lXNFNKakJ1U1NS?=
 =?utf-8?B?OElFM1FrRktHZHQ0UStWUjByZkRNNUVQek80UU9MN25mczRSczMwS2ZZSHZa?=
 =?utf-8?B?dUQ1dmhBZzBHc3EvVUNHUEJWaTc1N3hxeFhGa01UTnRtbElSb3RBOEF6bW1z?=
 =?utf-8?B?SXZZaklLMWM4UUlFOENPQytzYXJaY1VYdTNQcFZaeVAvY1Q0Nm9KQm45ZVNW?=
 =?utf-8?B?azJMYWRTYVhhUXg1Q1M2dzdOMVZISkc3ZGxkUDhSQ1d5NWtNZkI3WCsxaDFx?=
 =?utf-8?B?QTdjWXVRUXFNY21rQWV1RDcxTHpYTHc3OEVqYlFCVW5OU0tsZUMyZVZqTzla?=
 =?utf-8?B?ZDM1a3M5b0tBdlE5SEtza2JxUytZaFl5SlUyQXJQa3EzRS9RZHV0dzR2N2dw?=
 =?utf-8?B?NXdwYy9mV05UQnMycWc4bkxFeE1ONTdoOEVMd1dFYlVrOGx3UnJ4Qkg0U3ho?=
 =?utf-8?Q?lsylhn3ryoA=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WFlTOEM4UlUycDcxNndwQmhhSlpQZ1BYRndwektWTlNvTXNuMzR3SXlmWnBj?=
 =?utf-8?B?YmFDcDNkajJnYTBTMUd6TTBxQUFjWENmTmtoZXl4Vy9KcDhnc2h1T2xRSkRV?=
 =?utf-8?B?bjhVb0xjMUVuRmg4VWRGdGNDL1hUajhEKzFWdlp1TVZUbUVYNTk3cUxmcWNa?=
 =?utf-8?B?MTU0MUZyUlZRaCt1UDMxazVlZU1Ub0RqNWhJMmhUS0RvamtWNEdoeGFNaVBr?=
 =?utf-8?B?U3VFWGFhSlorcmphVmMwV3BOd1dJbHJIbFZyZmdmWGE3TldHQWZJWXZhMC9J?=
 =?utf-8?B?SjFLMm45azBWY0o4MjFkSllvaTBYNnNSc2ZZVzN2Mzk2Q0pLTkt5S1NjQlRk?=
 =?utf-8?B?ZXRPdC9WL1RzQjlWY3FLQ3VtTzlSVzBha2xmYzhMVWcvUEhzdkZramtDRTRN?=
 =?utf-8?B?WEJYYVhyeGcrOVNGakpISC9ReWI2K25GSVdoeEFlNzJmUzA5NUlpUHF2NTla?=
 =?utf-8?B?d0RReTR2bUpaRkNxUG9DcXR3Qk50YmVvYm93WE9jTThBNVIwQ094dnlWS20z?=
 =?utf-8?B?azhSTXdILzEvK1AwS1V5TWtLT0xmMHNKcWhkL2kySG15cEptRWcwaUh5Nms4?=
 =?utf-8?B?dVlQMDFNUU9CUkxUL0UrWEMxUHl1MGZhb1MwNzJGc1R0ZXlycW9jd0ExdEls?=
 =?utf-8?B?Z0pNS3ZYTng3YzFDS242UXFJcEdIckwySjVEaUlSZURtcFZiQkVKWFZOSDVT?=
 =?utf-8?B?b0k2RDJxQlR0OWpOemUwRW9FVlM2RWlML2NvaE1RRFFrRWFtc2Fwa2p1U2k4?=
 =?utf-8?B?c0lXdEgzcVQ4T1FyUU56eXRQTklMenVFa0hvMkdPVkYvRFpTWHNFREt3cVpn?=
 =?utf-8?B?K080bElHSW9TR1F0NVFRUkl0cmdCbFM1aWNIMHQ3Wlo1VUMvYnJvRUkrOVlB?=
 =?utf-8?B?Rkk2R1NXQS9JMS9WbDNWbUl1aFhOeGo5UklTU1NKWnFJZ2wzTWpXYlhxSVEv?=
 =?utf-8?B?U29QemRydG9VLy9vc1J0bkVvQTY3cTczVkR6a1FtOHpTVkFCeTVVeDQvRldS?=
 =?utf-8?B?ejljdXFaM3BlcXpNT1MyNnBWM0UrNzdBZmM0WTh1Z3hvVlNXU2VINStPZmJP?=
 =?utf-8?B?VElBSnJ1OEtWL1dzVWxJUm5tRzJmTnJrYWorMng0Q2VOSXZrWmhkb2toY2s3?=
 =?utf-8?B?alo0SXlvNitFMTFJV3JYMWtDaXR5c1NVZnFPcGpNZnFvczVLQ3JyQjBZOE80?=
 =?utf-8?B?ZWdzUFA5VVlQbVlucmZINzRaT3Z2VzdBMmkzR20xRnhqSjV6R2hqY2Qyb2tU?=
 =?utf-8?B?MlR5RkkrbDduUzN0dVVoWFlra0twMVBJZ1BDeWl3VnhNdEpCNXN3bHlidXZq?=
 =?utf-8?B?bHVCZjMyajV1eWZrVnFHcGtNcjRZakNBRkphYTJOR24wNEhYSjY1NVdabndZ?=
 =?utf-8?B?cWdKNUhTUEhDMHlJYnZnL1g5WDJVWG5nU0cvM3R3SHpOclBuSFAwOW1ORXBx?=
 =?utf-8?B?eVBPbHk1M1BCbkRnUGNnd2IxVXZPR0EwL0dDcGpHODg0UHdZMWlSMFNJVHNz?=
 =?utf-8?B?ZzhiZUJ6Ky9Eb3lVeWFhL1ZCRW1uNVRBTStjMnVOb2U3QVY0eTA0VzhzeURE?=
 =?utf-8?B?c1BUWnh6YXJmaTVmUE5acit3b1k0OHpnL09YYTdITzFyMzRLWHoyUktsYkFB?=
 =?utf-8?B?bVZFajZHNnorYjhDNHdyK3JWVEE5UE9BaCtPU0tjRk91VHJFQm82cGtGY2ts?=
 =?utf-8?B?eUZ4OGpIeW14R2h0SXRwNTc0dVY0T0tTOFM3UCttdHFiUzBkYjFteEswa0tD?=
 =?utf-8?B?STN4NitSUXVKZ0FpRjdWeHpQMDVheXNWdzNhMG1zR2ZxQ2JhaTZGK09ad000?=
 =?utf-8?B?c3AxaHYrdVRSOFJ6SGM4Sktkd2VYUFdqV2didVlHcGh1ejNiR0l4bmgwdkZF?=
 =?utf-8?B?T1NWc1Y2ZDhVQWorZUdzY2lHNHpPRUVBSUs0cHBTaDFPcFhRTUdscEt2eTdz?=
 =?utf-8?B?S0tkeEtWK3ZSVlBJWUZIa1V5ekdUZFlzYzMzck9ZWUNuckVhWTkvbmxBVzNF?=
 =?utf-8?B?Wkx1M2VQeG00NFd3WkJVU2NEK2RiY1Q1VzZUc1JOdnVNTXIyL0lVRDl3Q0lt?=
 =?utf-8?B?UG1HQXIvQ1NsV25xTnJsT3FSei9NbFdYSHFnMmtrRlQ2MHY4S1FhQkZQNjdI?=
 =?utf-8?B?bm5oOFNtNVBiTzd5dDg3eUFmcWszb3FzajJVZUJzNHBJcXEvbEtJeFduNVlt?=
 =?utf-8?B?RlE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3dafba27-f913-4390-6b49-08ddf007161a
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2025 01:12:18.4482
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +Ux1Chh28gQ+2lyzN75s4fDwpASQ+3lKikjmLV0wqCOOSm4aWM1CF50Cq8oaczOUtFFHRRGQ4XbjEXaMwutZYKCAk2rbpYrgZ3CTzqQrgJY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5262
X-OriginatorOrg: intel.com

Konstantin Ryabitsev wrote:
> On Tue, Sep 09, 2025 at 10:58:53AM -0700, Linus Torvalds wrote:
> > On Tue, 9 Sept 2025 at 10:50, Linus Torvalds
> > <torvalds@linux-foundation.org> wrote:
> > >
> > >    patchid=$(git diff-tree -p fef7ded169ed7e133612f90a032dc2af1ce19bef
> > > | git patch-id | cut -d' ' -f1)
> > 
> > Oh, and looking more at that, use Dan's version instead.  You almost
> > certainly want to use '--stable' like Dan did, although maybe
> > Konstantin can speak up on what option lore actually uses for
> > indexing.
> 
> It uses --stable.
> 
> > And you *can* screw up patchid matching. In particular, you can
> > generate patches different ways, and patch-id won't generate the same
> > thing for a rename patch and a add/delete patch, for example (again:
> > the traditional use case is that you generate the patch IDs all from
> > the same tree, so you control how you generate the patches)
> 
> We can't control how the patches are generated by submitters. If someone
> generates and sends them with --histogram, this won't work. Here's an example
> right from your tree:
> 
>     $ git show 1c67f9c54cdc70627e3f6472b89cd3d895df974c | git patch-id --stable | cut -d' ' -f1
>     57cb8d951fd1006d885f6bc7083283d3bc6040c1
> 
>     $ git show --histogram 1c67f9c54cdc70627e3f6472b89cd3d895df974c | git patch-id --stable | cut -d' ' -f1
>     47b4bfff33d1456d0a2bb30f8bd74e1cfe9eb31e
> 
> Or if someone generates with -U5 instead of the default (-U3):
> 
>     $ git show 1c67f9c54cdc70627e3f6472b89cd3d895df974c -U5 | git patch-id --stable | cut -d' ' -f1
>     0b68dd472dc791447c3091f7a671e7f1e5d7a3d2

Is this a matter of teach git send-email to generate a header, e.g.
"X-Patch-ID:", for a given stable diff format convention? That lets
submitters use any diff format they want, but the X-Patch-ID: is
constant. Then "git show $diff_opts_convention $commit" becomes more
reliable over time.

It still does not help the problem of maintainers massaging patches on
their way upstream, but patch.msgid.link does not help that either
because that Link: is not the patch that was merged. So if you care
about automated tooling being able to query lore for commits, the
maintainer simply needs to push modified patches back out to the list,
or accept the consequences of disconnecting the commit from the lore
lookups.

