Return-Path: <io-uring+bounces-9681-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F869B50462
	for <lists+io-uring@lfdr.de>; Tue,  9 Sep 2025 19:25:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 950497A320F
	for <lists+io-uring@lfdr.de>; Tue,  9 Sep 2025 17:23:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 383DB34DCFF;
	Tue,  9 Sep 2025 17:25:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Wxq/P2um"
X-Original-To: io-uring@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E0A131CA7D;
	Tue,  9 Sep 2025 17:25:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757438719; cv=fail; b=snvP2X8eFdhtumeq6fMFsoamK5uvjhlf8AvV+oPiGKnA2Bqcxwkl4WXRDi62ygChe/BuuVScBMXZSKc6BtIMHnSbiXFoX1l8d+oh0Jwy5bUNXQA/TwqgygxsRnpShNMDF4eMbmfy/2x9pk8+sOMe5O4fVV/6dK9pX8qOUOlFRDE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757438719; c=relaxed/simple;
	bh=EWvnKiEokZpAHSJxGJUluuHjkTrS8nuOhCkQlgIuUKc=;
	h=From:Date:To:CC:Message-ID:In-Reply-To:References:Subject:
	 Content-Type:MIME-Version; b=uu+GeJL7JX3OirfVKHQqG84hHKWf4Z8QgJYaamQrdZmv+Jdg6ZwVE0wmwZR3giuE8A0t8fqk54LTXtrSGEI0MDCRPdLhPFJ5vioiZexedsqUzsMi9pT4klM3D9Bg8FBh9bSi0e//D/KkPj6al/UBQwdSTUPlaUffK66+R2HAiFY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Wxq/P2um; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757438718; x=1788974718;
  h=from:date:to:cc:message-id:in-reply-to:references:
   subject:content-transfer-encoding:mime-version;
  bh=EWvnKiEokZpAHSJxGJUluuHjkTrS8nuOhCkQlgIuUKc=;
  b=Wxq/P2umv8Gg6KmjLkcIAPxZYlzPe/WgQvUSoa2+xyaGb10okQ0M7s71
   7j4JKn9kPAh6yjmJfsSRFztaDBZ1fRHzMRMvBPrEnU4BKL5pvTdwNNUA4
   BCO8DKX2uVGYKIzCIgSKcxfkzq/6kFpG1ZvnYYIvj1urc8lPgXObtJC29
   3qhT2zgaMKWVozSPh2D+cBz0SSQyDqLxGK1UDYEyLg+wjYbJFq40ESXmS
   bSg12wIzf/yzick38c1ngUOx++A8o2BN6C71sA8ZLGwBqmrHFk9AyjPii
   vrhPTVajXXYPROAPcF8s91I2uTt8eQOfkT5XZR2vXOC4VNfV1/yW3KGn1
   g==;
X-CSE-ConnectionGUID: UVLOs2qvRhi9doqJl4bGTg==
X-CSE-MsgGUID: GthTlkfMSqmrrpHDLPi4oA==
X-IronPort-AV: E=McAfee;i="6800,10657,11548"; a="59878414"
X-IronPort-AV: E=Sophos;i="6.18,251,1751266800"; 
   d="scan'208";a="59878414"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2025 10:25:17 -0700
X-CSE-ConnectionGUID: C9CT0QQ7QW2vsc9sClGphA==
X-CSE-MsgGUID: EaK9hYKvRom8//jZzOz9Ew==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,251,1751266800"; 
   d="scan'208";a="173058218"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2025 10:25:17 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 9 Sep 2025 10:25:16 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Tue, 9 Sep 2025 10:25:16 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (40.107.220.59)
 by edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 9 Sep 2025 10:25:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lCBqorQhi7z2Rm2G0cS3/NFebFwKQm6EFdo2fNtyBF+BP0+bivgt0NmlLcLkxyYutvkgbsKWf2Kh31eR5JJOqVEEudO5qYciPhU5aE2gPsDMlQ/okxVSsPSKAdBrOWKMnYwNdLvYR5SXxcbAEN8H59QyvA04pal19s7cAWfU7o44Lwc1h41f+DTgdGg8OVp4TG6FGbrQASgkKM7IzHEsBgwlw6VcIJWvWo+tnMCitLHiKrmNABDeLKPdSaBF+qSsEIrY96sTHHyCjiKHUalNfKhEeotUDPHbIcruce4u+FtNUqgm5rovn6Pil0V9BxXYXt65QM3qmh37Ywii3VfDCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=50GxkO/potxKWgInj5Uib89bTunez6X0qXr3vp1sTQE=;
 b=djNnteKYukAGgJhhr/sZ2orNb4ZDmyzw3gFEH5CW2nikjzg7UbnHbOYARLceFrZrsYMAuUHpcteuv/WyUdJCqXKPB570Q1y7mPE4JkHv9DFww3tTkmhXuebGoCITB5a5ScMazeu2FB4Jm15qiuO2BjUSYEdwwjAsQTwdTEkfKzLnnZc5SxQfeW/Mb6JhbL4emXGg7ETKnrEwCyjbYmuLqJBGCA1zTrwHDJbk0adfAEZT0tGf+kt56uRUinLjhz6ZDGlxbVCaWSDOtUpSTG5dAcIsQnMHEgAiNA79NWFMssOZgR6kxtBYk3510sWn3gsmFo/DnX5zFwITqDak96LBAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by CY8PR11MB6889.namprd11.prod.outlook.com (2603:10b6:930:5e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Tue, 9 Sep
 2025 17:25:13 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%2]) with mapi id 15.20.9094.021; Tue, 9 Sep 2025
 17:25:13 +0000
From: <dan.j.williams@intel.com>
Date: Tue, 9 Sep 2025 10:25:11 -0700
To: Linus Torvalds <torvalds@linux-foundation.org>, Jens Axboe
	<axboe@kernel.dk>
CC: Vlastimil Babka <vbabka@suse.cz>, Konstantin Ryabitsev
	<konstantin@linuxfoundation.org>, Jakub Kicinski <kuba@kernel.org>, "Rafael
 J. Wysocki" <rafael@kernel.org>, <dan.j.williams@intel.com>, "Caleb Sander
 Mateos" <csander@purestorage.com>, io-uring <io-uring@vger.kernel.org>,
	<workflows@vger.kernel.org>
Message-ID: <68c062f7725c7_75db100eb@dwillia2-mobl4.notmuch>
In-Reply-To: <CAHk-=whP2zoFm+-EmgQ69-00cxM5jgoEGWyAYVQ8bQYFbb2j=Q@mail.gmail.com>
References: <9ef87524-d15c-4b2c-9f86-00417dad9c48@kernel.dk>
 <20250905-sparkling-stalwart-galago-8a87e0@lemur>
 <68bf3854f101b_4224d100d7@dwillia2-mobl4.notmuch>
 <5922560.DvuYhMxLoT@rafael.j.wysocki>
 <20250909071818.15507ee6@kernel.org>
 <92dc8570-84a2-4015-9c7a-6e7da784869a@kernel.dk>
 <20250909-green-oriole-of-speed-85cd6d@lemur>
 <497c9c10-3309-49b9-8d4f-ff0bc34df4e5@suse.cz>
 <be98399d-3886-496e-9cf4-5ec909124418@kernel.dk>
 <CAHk-=whP2zoFm+-EmgQ69-00cxM5jgoEGWyAYVQ8bQYFbb2j=Q@mail.gmail.com>
Subject: Re: Link trailers revisited (was Re: [GIT PULL] io_uring fix for
 6.17-rc5)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0205.namprd05.prod.outlook.com
 (2603:10b6:a03:330::30) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|CY8PR11MB6889:EE_
X-MS-Office365-Filtering-Correlation-Id: a20e8b0c-7c50-4fc3-a339-08ddefc5d5d3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?M3NURGVtazJzcmxYOStNa1JmSjRRYjVPY3BpWDZHMjFJYXR2S2d1dEs2bUYx?=
 =?utf-8?B?b0ZBeTVHVEt0L2NjcEl3cm9NN2tXWDlIM1FoNWxUcTd4Z1dtUkNnMllZRWtv?=
 =?utf-8?B?MFBibU1QbUpvR3Evb0JPZm9SaVNTYnVhSkRGRlI3cXlkclV5Ti9lSkkyV2lH?=
 =?utf-8?B?N0ZHSnV1UU4vbFdTOGI1ckJIbzdIQW9nU2MzeFJ6YWhLQ0k4ZVJ2V2t3Yllj?=
 =?utf-8?B?UFJwd0xCVi9ESHMrcjZiNEFQek1RMmVpRVhncnRZUnBjYUVMelV3bU1CU0Zv?=
 =?utf-8?B?WkRhYURQQXRHSVlHWEozRUVHcjkvd1lhSk1hcWp1KyswVlZDZ2ZZVVVxbDF4?=
 =?utf-8?B?UzlOb0ticmN6cGcxUFdacmhEMWlGRENmdWVpSnpsOVJ1bHpXVHNtaUkweWtW?=
 =?utf-8?B?UExtTUpZcEZMZGpyVHNsb051WWRsN0RBMjJtcjFyUzd1WjlqcGI5NGVISksz?=
 =?utf-8?B?SkloYkFhdXVJd0ZUc2ExNjlTWjlDaDFCdi9CQzN1K21LczFyblkrbGMzNnNT?=
 =?utf-8?B?SVEyWG1jdElUUFM0encraVRiS2ttR2JNOXB5QVNMOVRoSTJEWDJrNFRNTGJT?=
 =?utf-8?B?QWxCSGZoT3dwUVoxUzhiMEc2VmpPTnJTeUdqTU9nYW1wQW1SMks2THIxYnVx?=
 =?utf-8?B?WDFxV0ZTb2JCN0xUVWFhL21ReHFTcHg4WUQvbzBrS0o2RGJPNm5BaWF6RU1j?=
 =?utf-8?B?RUlPV0E3aW1kODd0MXpjbmpLTEJ2RC9iVi80VEVPcGc1V0wxeWNLRFMvZk44?=
 =?utf-8?B?dHdhTFZXU1YwYlR5VlcxWXdUZXowenZiSG80akd4VW4rTjhBZ1FoUTdDWFpx?=
 =?utf-8?B?QStOc1ZoL2RZNXk5TmdCVzl0cmlTeUJjVlowL2JmNHJIZGdCRnhQbnowWlp1?=
 =?utf-8?B?S1k5ZHgwdVlOYzE3akEzWUd2ZUVCaGFMbi9hNUhWdEoyWGF6QVJFS1pwT2tB?=
 =?utf-8?B?UW5uMkNIeDhTenphbm10aEtlR2F0aGV4REFlQjdjU2kxVFluUHh4UGwyclZh?=
 =?utf-8?B?a09pakdZTk8yQWZDQ0dpOXVEbWVZY0FhL0ZYb2x2REZjZllZQmlwbU83cnVo?=
 =?utf-8?B?eFIrdmJ2Q3MxRXAyeHRSTjU3d2QxMUVkTnBrdlRzVWZHNkxoZFBMQUY0eTZn?=
 =?utf-8?B?Wk1iU2pqVVgySnp4akVmNzRNTzI0WExNWjV4djhtOFRuNlhaYmpCcnZQKzdz?=
 =?utf-8?B?TFNwdHp3MTB2dEp5ZDBSemdLZDRCR2pGWkZZWGJNVjFHcUo3NDJiWTlYWThu?=
 =?utf-8?B?K09xenBKUHpKNDBuNWdPcnQzemY5L052MlhJT2xmUm9pbzh0OHdvbDNmQ3Fq?=
 =?utf-8?B?bFpQcEZnOFVTTkJ1cU45ZkJ6WlNlNk1PNzhmU3BVNE5WT1ZkMjNjTzBJRVZG?=
 =?utf-8?B?bjZMV1h3V2ZpdmU4dnN2RnFkdExYYi9TcnlzeGJjcFRhQWdLNUpndFFiNm1j?=
 =?utf-8?B?SDBQK3VKQjFPYnFiNTk3eThJdXVVdUNGN21jc0NXV3RsVVRiMlRLTUdibDI3?=
 =?utf-8?B?TXZvVUdmS1lEbzFYUkVTU3UyMUJsQXF1cGF4bGNpVVY1azc3ajRaTzQ2UE9Z?=
 =?utf-8?B?MWREakxoYm5kUG5kOEFWN2lvampaWXdwMDNoeWk2dkxGOTBRMzlya1BSN1dM?=
 =?utf-8?B?OCt4OFNWZWwybmhOWExmY1dqK2E2bzZXL1V5R0Z5eEdRcWNVTi9LRy81aTJU?=
 =?utf-8?B?RTU3VFlYZU5ETmJFSW5rOE1pbFRQZk52OFhnRzFpMWRmOW8yWlhMdHUweFNR?=
 =?utf-8?B?ZlhDQnNsd0R2U0txOGVVdTIvYmxlUEtrYkpEeng2eEdSdE5QZHZmbW5tRkkz?=
 =?utf-8?B?Vm5tN0FYRmwvYlo0WERseHdXTWpzMjV2UEFmOTIveFRwK2t3TGxFUkE4elVO?=
 =?utf-8?Q?yE3oiYCMr4LPD?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eEVzeW9NUEtZSUNDRmUzWlJRaFRURmRYMzQwbVlvWGlvYXBBcFhPcHFMTHRH?=
 =?utf-8?B?YVF3RVFJdjlSdE9RekdzOVE0ZVAyc2wxcVUrNzkzbkhrT2hEUS9QT2wrV3BB?=
 =?utf-8?B?VDNzNmwxWWhVVUlnWXQzeTFVRVNCWEdUdE8yaXRhY0RTRW5DajlwcHJWQ0RU?=
 =?utf-8?B?aUxiT2RSVk9vRFU3bWx3bjFsSWhJYVNRN3Y1Y1BaMWRlZFlOMjd2MS9VZ2Fh?=
 =?utf-8?B?K2E5dldVR0NIbWpSN0c5WnJBZUY5azdIdk9qV3ZLanJmVm1vdlBuSUE2QjNP?=
 =?utf-8?B?MHhsOGxGYWZDcmhsUzJJK1pKYlowY21Gb3ZTaXdDbnhOTDc3S1N5VDNqQWhN?=
 =?utf-8?B?RE5BV2l5a3ZRTzFYcTZRVEhoYnZaTk9mZjAwSkFXWmRmYkp2dGNib2xFSFBH?=
 =?utf-8?B?bkI2V1RlcDgvRTk3UWJlSnRjK01TRVk1Q1Vua3BiSmVDS0l5QnFSWHVWZnNp?=
 =?utf-8?B?OFdhcW1OeTd0dllQTWFYTFpRa2xjN0xBdHF1SExxRk5oazdZeDhTNjNXd1R6?=
 =?utf-8?B?STBvMVRESXAwT0o1bEdtbXE5bm1TUk9pUFV2a2JRbnRReG44eWxUWEJueGZR?=
 =?utf-8?B?bWJ1ZHVhZkJ4UFFMWHJOM0NjZUlYa3E4VzNIY2ZoWHF4dDJvQ1VMQmtRLzUz?=
 =?utf-8?B?OEJ0M3lCb2hPZDlnMkQwNnlZVUY2ODloRGFlVlpjdmQwUUJnMlYwMFltc1c5?=
 =?utf-8?B?bWFkbWM3Yzd3aVloYk9FNklFRUh5SWNJdXFjRW1CNzBrWnRQdDFoTHNYNlA1?=
 =?utf-8?B?enpXUUdwcDUraUNyY0pPUzNqNlEvcy85bElBTGJWNWc1bE1OT3hXdFYybUtz?=
 =?utf-8?B?Z3dUYVlUd3IwQ2ZON1UvWWsxR1dGdHlHUmNnSmJwUmtGWGpYdUpWUVFydXlN?=
 =?utf-8?B?N3VsdzMxek15bXFBQTVPZGlMU0grbHRqNG1vR1o5b0h1K2g5RmhBa1FJbW1w?=
 =?utf-8?B?WkF3eHR1ekQvR3lDS0Mra2NNYm1EZm44TjMxRGFXVzBFa2duK2pkMGdPSjRj?=
 =?utf-8?B?TXc5YUZjazJjbFRqSFUyWTBDYmV4NjB5ZTBZSjBSczJvdVdUNE5sbTNNMTMz?=
 =?utf-8?B?UU9uUSsyV1pGN0dWZDRNZ2M3RFdZVnFBRW1XU0RXV3BER3p4Ymg4d0p6dlEz?=
 =?utf-8?B?U01ENzgyRnJrcnpJQXRUeG1wa002cGU4RE1lVDlGNlRiTXNlZXdCR01pZ3JW?=
 =?utf-8?B?NmdFWkZQN3Y5MVFZZ0xzbmdKQWs1M2xmTDlnckNJakp4WDIxVlZTcVhCNGlQ?=
 =?utf-8?B?Mnl3UEpDQmxVd21zYU5YUVJVajBzMlRweVpSYlRZajE4SnE1VFNPMzlKNFRD?=
 =?utf-8?B?K0FMZzkwRjdBMWtkYkJiOWdwSG56TkdXTUthV3Zvei9BdFdRUDZMTmVoNkdh?=
 =?utf-8?B?Z2poaFdtQ2hTQzhENmpvbVp5UHBnQXJnMXg5bDl2WGxPQUVmeml2c2FZMFBr?=
 =?utf-8?B?Z3cxZmVHY3U1Z29CQjllR2pYL2I0VVlnQ2F3bjZIUjlZRFVHTHdJQkQ3SzFD?=
 =?utf-8?B?L0wyWk9GclcrY2diN0tPZXJXNWJoaGRoempGRzlSQllmT0NLcTVtZVVzNWFx?=
 =?utf-8?B?TzcxSW85c2xUc0lnS3hUUm83Y284QmpoS3lzcHRFZ2tVeU5keEkvVC9DdHkz?=
 =?utf-8?B?L1libktPQXRwZHUxRWphVEpmSHcyYlVjUDlvQ1FLMUZGM3g2cXkxVHpscEcv?=
 =?utf-8?B?OG9kdWFJT21hRTFsUCt5WUorTnBoWXIrQW1zbEVBTW5kNnFjVUR4amFQa3FM?=
 =?utf-8?B?YXlna2xyRUdjL3dpbk5oRUFadzNMNTFCK0FEN0JKWnh3RHNPYmEzWUJ2a3hM?=
 =?utf-8?B?V3ExTXdZcWxDOVZnMHZaM1pLNVhWZ2JUQnREbERKSm5TNkx2aWlET2xiMWR2?=
 =?utf-8?B?aG1qUGxmY2VObjhieVJ5c0xUTnlnbnVlUlQwZ2wramE3V0M1Ym5ENXJXdEVI?=
 =?utf-8?B?aDY2MVZxZ0Y5aGl2NC9EeG9HOGRpWjE5Rm44andNeUJTeTRBNXVNangzUUZZ?=
 =?utf-8?B?c2k5YUVadFBQdVVnVnpGVVpkNlZDUHo0NFZ3cHBaaEU1eVlQMnBFcjJkNWpr?=
 =?utf-8?B?MnJTNFBrbGRycE5vRDZHYkpaVExPek42UG1UbmlYR0ZLZ0Uvd3ZMSnpxZkpN?=
 =?utf-8?B?R0w1bFEvN3VwUm55TE5zUit0V21mNjJpcHhZYWlXNVZ0L3dxZkIza2lndlRo?=
 =?utf-8?B?MHc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a20e8b0c-7c50-4fc3-a339-08ddefc5d5d3
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2025 17:25:13.3294
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dwn4IxR+KZdMLBPWG+rdetWnYYFzpgRTDi+WlCickYm05GztNHIzJgFX/d0SnwyMa9Dl6JjejY4q50KcLL85kKmiGcj44mwHbY+Df53Q3zA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB6889
X-OriginatorOrg: intel.com

Linus Torvalds wrote:
> On Tue, 9 Sept 2025 at 07:50, Jens Axboe <axboe@kernel.dk> wrote:
> >
> > I think we all know the answer to that one - it would've been EXACTLY
> > the same outcome. Not to put words in Linus' mouth, but it's not the
> > name of the tag that he finds repulsive, it's the very fact that a link
> > is there and it isn't useful _to him_.
> 
[..]
> Honestly people. Stop with the garbage already, and admit that your
> links were just worthless noise.
> 
> And if you have some workflow that used them, maybe we can really add
> scripting for those kinds of one-liners.
> 
> And maybe lore could even have particular indexing for the data you
> are interested in if that helps.
> 
> In my experience, Konstantin has been very responsive when people have
> asked for those kinds of things (both b4 and lore).

Hmm, good point. Lore does have patchid indexing. This needs some more
cleanup but could replace my usage of patch.msgid.link.

firefox http://lore.kernel.org/all/?q=patchid%3A$(awk '{ print $1 }' <<< $(git patch-id --stable <<< $(git show $commit)))

Now, it does drop one useful feature that you know apriori that the
maintainer did not commit a private version of a patch. However it
should work in most cases.

It would be nice if that was guaranteed to land on the latest version of
the patch just in case that patch was posted in several versions without
changing.

