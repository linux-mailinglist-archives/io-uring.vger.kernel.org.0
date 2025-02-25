Return-Path: <io-uring+bounces-6731-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 011ABA43811
	for <lists+io-uring@lfdr.de>; Tue, 25 Feb 2025 09:50:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EB0843A298F
	for <lists+io-uring@lfdr.de>; Tue, 25 Feb 2025 08:50:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02B71260A39;
	Tue, 25 Feb 2025 08:50:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="bzTO+tZl"
X-Original-To: io-uring@vger.kernel.org
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2078.outbound.protection.outlook.com [40.107.212.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E28872153C1;
	Tue, 25 Feb 2025 08:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.78
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740473416; cv=fail; b=UbPiyihXb4pwuedTbRxdQYxvgxNWGwiAMFAml9UxtlcowYCmOmtCXbhSRmZOQOgmNDrEzui4qSd92IzvIYEegJB7kn+kNfCl+daSl4sdWxJqK3icP6N61nPgLAagPcUqNbl8g9AwAAdH26hebhL/1WAUlM8WAt9IkNH8O4BfeG8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740473416; c=relaxed/simple;
	bh=2yHZqznM7aSsAbEXJw5QzPjBV3K6ZWo5ZCosSeqydno=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=sj79wlo+LTInjRlPBtmkdrkZQFwKjRZBKOsJ3WMkfoIPay/r1LwLxerjoCSMndJSvSMjnvk475ZamVpY/9Ou4QTmoMRy53PRv2EpaGIxoQbgvMBacUpVc7UzD4o5pxSWuZjgVoLkolqUYnGBHZbmDBuswj0bcpgrwwSPbw/klLI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=bzTO+tZl; arc=fail smtp.client-ip=40.107.212.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=B7kV8Z0Kmhfxf6cv7W8f0oLTHHlyFuDgiQsThdSZaDvfmZsoGYrFJYpGdrnrBNBi42b+Ql69TWxuzbj1DBOXhwCHRmUgl1QDVPKwSRjN/4YDXLxNd0enwLEhJYALBPNDQZ6m8qEdfm4/6YJrcjYMOqX334qkGmZJe/C7klCsGJGvrl2pBCE48xIqFZC110N6z9gQspAOAKJvjCJyKGi6JRMnBC3p+wbQLnHgsLOAfU7e2KsKxat/a+yQ54ugZKQInA8Yw967Jk29T7jZGA69Zsqkm5FluBEry+hxQJ5xs1XYFO+wyoYWQndElHya5F479BSh2ZR1ZvCcmxZI+PqqYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CPPnpkIIWsuSTbA+XykXKd3HCCPneqeovcbbHL5P+lc=;
 b=xziG0tgv00s0pk8uGYlmr6gW+U3QvhSDCBsYmJaGBl6XqWc2sZamh1+87s5RoFlfNfaiN651BkVVxtG7Ko/zbXIzJzVtE2KJQyeZ8N3/wzyIH7gjVS/36VkrdWeqea4vPjw5ip9CuXkKaWBmSZIs5zOyr5oJ+IKBAXulDS5xvOwdI8PNFrVGAovsYpLhbPBJo5drFfp+JGYIAT9vimE6VQXy1Z9G9ElL74SZ2FoHPzn58hbImuO0p+B+mUnfHqmhNHK9PVWCl/0rWUoU5vDiqkWIPHuzc483vU0Koxaxa7aQpmNkW6M8LRi1J6xsw6yBcidwdc5PZIFri86FASqRNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CPPnpkIIWsuSTbA+XykXKd3HCCPneqeovcbbHL5P+lc=;
 b=bzTO+tZlDdw2SgDU0uKhdG/uNk8PKQeoAMApIkwVLjNNi9mlsszdJReXuIo/AM4kie9Tw7Em2eRKfBBU/YD1tBpuNNilXQapTVZAAtmbybJJyPcvvxeojLOT7JHbG4Dn0DqeUF5sQnfMYLhzttmvf71YpUy+pnBdGxCnGyMkrRw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH2PR12MB4262.namprd12.prod.outlook.com (2603:10b6:610:af::8)
 by DM6PR12MB4298.namprd12.prod.outlook.com (2603:10b6:5:21e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.20; Tue, 25 Feb
 2025 08:50:10 +0000
Received: from CH2PR12MB4262.namprd12.prod.outlook.com
 ([fe80::3bdb:bf3d:8bde:7870]) by CH2PR12MB4262.namprd12.prod.outlook.com
 ([fe80::3bdb:bf3d:8bde:7870%5]) with mapi id 15.20.8489.018; Tue, 25 Feb 2025
 08:50:09 +0000
Message-ID: <90f8e4f9-c439-479e-873d-e110871ece4d@amd.com>
Date: Tue, 25 Feb 2025 14:20:00 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [io-uring?] [mm?] general protection fault in
 lock_vma_under_rcu
To: syzbot <syzbot+556fda2d78f9b0daa141@syzkaller.appspotmail.com>,
 akpm@linux-foundation.org, asml.silence@gmail.com, axboe@kernel.dk,
 io-uring@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 surenb@google.com, syzkaller-bugs@googlegroups.com
References: <67bd7af0.050a0220.bbfd1.009e.GAE@google.com>
Content-Language: en-US
From: Shivank Garg <shivankg@amd.com>
In-Reply-To: <67bd7af0.050a0220.bbfd1.009e.GAE@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0239.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:eb::18) To CH2PR12MB4262.namprd12.prod.outlook.com
 (2603:10b6:610:af::8)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PR12MB4262:EE_|DM6PR12MB4298:EE_
X-MS-Office365-Filtering-Correlation-Id: d0a18300-b24c-4efe-d1dc-08dd55796805
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dC8rUlgvQWpRa0QvTFF5YWxKdGhuTVhhUXA3ZmZZT2tnN3hzc1pwZUFQemll?=
 =?utf-8?B?Y0pmdFEraWlNT0dBRG00SDRMUndNcGtZbHFYTzNpTzBlc3VteFQ1U0k2ZlVu?=
 =?utf-8?B?QW1DWWticmoxTEZKN1BJUXRSOGw3aThpTUZrbitzajVvZlNnZnRNMTBxdWRy?=
 =?utf-8?B?OGp6OThOMU5tMlNwdmJGRitzcnd6TnM4amxFYzlKWThKejRLRmlieVVvR0tq?=
 =?utf-8?B?TWZHN01sbGk5Y1UrNnBtN2xYblRlZGdrZi90U1FMZmRPUEdxbURROVN0Sm4z?=
 =?utf-8?B?a2RMU2FSYWdUYVJ0UUd6eXBPeWJCLzgzTm4ySG4ycFJ6aTFLVGF0R3o1QUhj?=
 =?utf-8?B?OHY5eUdNVUJQQ3N6eWdMYWFKb1NDbWhkb3hJRTM0cVliTmYrQ3JUNFhvMUl6?=
 =?utf-8?B?MFJFNkRwbFQySFlpOUJVN1oxM1Z5elY5OWtoclo4SjN0WXJBdXdaZFJpSUV4?=
 =?utf-8?B?bkpxUmdyalBMK3NWZkpXVmpvSFNwd3RCMExrdlYzMHpnWmpBVTg2b1cxWGFj?=
 =?utf-8?B?UHF5NTZjc09GT2h2SnkvT1R3ZzJVYXFsRkF6Sm5qMlFKYTUwdjdhWnVnR1Na?=
 =?utf-8?B?VDJneTJid1J4VGFFWTlVTjNpVS8wK1ZrL3AxbVRsbzM0TS9CODVvN2VYa3ZB?=
 =?utf-8?B?ZHdkbmVKT0JjSzRRWTNHWTNsN3ZEb1hkWWlKMWFIZHJBS2Q1b0xiZ2RhNEdy?=
 =?utf-8?B?Y0Ixd2JuY0xPcWpVeHJQMlRVVjF6ZWZQcG9OdHZjQWFOZDFrSFZBbStMSlA1?=
 =?utf-8?B?end2UyswbmNyRUhIRTJmc2QwOWRZN2szcHhIem5mNzlMWXBpRHdxUmpvYzVn?=
 =?utf-8?B?V3dyeFhQemM1bStsUUN4Y1djWXkxSmhHcVFLUVRpVWdZY0Z3cjlEZ3BmN0pv?=
 =?utf-8?B?Q3ExOGJaQUhpNjRUTVl3Q0lKYXE3U3JVOWdreTdxNDRPd1d2SStIenhNdE51?=
 =?utf-8?B?bGxvbW1ldXloVEhKN1VPWERTWWltODA3aW5qME43bnl5VFYvWTczdERCQ2dy?=
 =?utf-8?B?aWZ4T3RTNStYMktPM3ZpYmpJQU9mSE1QbURPamE3REdvSEl5Y1pPeGdSZjM2?=
 =?utf-8?B?RGpQZHViM21aeThWdXplT3VZN252VW1KMHhxMzVGVTh3MzIvN3czcnFHOHJ5?=
 =?utf-8?B?RWlXKyt1SWN4SUx6T3l6VDVTSWNjZ1Uzek9XRVJoY3MzejFJaVRXdXBXMWRR?=
 =?utf-8?B?SzhqSnNINUF6amYyUkpiOGJ5SEdqQS9LeUlNU2s3eGxMVVhjREZlV0l1WnJv?=
 =?utf-8?B?NU5VVFVGcWowK1NiMWx6SlE5b0ZiU0wwOXJMb1FoTmJuTlkvcGpJOG9qSDI3?=
 =?utf-8?B?cG40M2dnczVBc3hHaHZwekJyTXFmMCsrL0lpY28zTnJNUVZQTXRWSjVHeGQ0?=
 =?utf-8?B?aTVrbWRpOTM2ejlEY2VZNm5XL3IrdmtyeWlqUG03VXdhZDgvNFRvY0NnbVFh?=
 =?utf-8?B?T1FObGQwM0ZHSG1HSlRwUVNsdFI4K1NCQXFDMitndEFqNnZzdEZKZlU4V013?=
 =?utf-8?B?VUFjNTAvTzM2VExRTEZxdGlHa3RINjRIdmhFRklXOG1CSHY2amdkSmRmVzRl?=
 =?utf-8?B?OUh6SjkrV0FTM0dIRzEvTmhBbG5sU1ZiWXFSaG5Wd3JsTGxxa1hZWGZmOGN2?=
 =?utf-8?B?QmNyTHpRaU9pMTRZUGExdUpsMFNhYkVLRWZzQk9YajRHaktkYXI5Z3JOV0lo?=
 =?utf-8?B?S0xKQkx3MVdrNy8zV0M4aTVsTFVmN3FLSG05OFFMdnZIVGJoYkk4SzFNTmkr?=
 =?utf-8?B?VkEvbEpNUWFBeWVPQkdqa3h6dUVDcEt2di94NVZCQ2U4ZE1DRVRTL3IxTDFN?=
 =?utf-8?B?NDlaRnhUaWYxN29adTk0dz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB4262.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Sk1oZ2pFMDRrbVJUelU2cnBteGNUb0M0RU1QY1lKY000M21jQ2Q1Y3RGN3Ex?=
 =?utf-8?B?OWdYcmJRNFhWQ3oraWh2Z2h4bWdUeE5MeUpFZWFmclZZUDNEOTY1bG1ZcGJO?=
 =?utf-8?B?b3lDcEdWdks3NE5DU1RjOFFLcXRkaU0xa3phYnc4Sm9ZMWZ6SmtWY3JTOENH?=
 =?utf-8?B?bytrd0hoak4zc3JJdUtwS3NiV1AwelVBdlBVRXlkMkV1Z0VyNmRwT044dGR0?=
 =?utf-8?B?M3ZhbmlxZnR2SGtBTVFyb0NRZGxyZk1jRTJTOFNvdWZiZERUSTVDNm5wS09t?=
 =?utf-8?B?Y0dEcisyWVlaZ1BkOTFiZVoxZzVrUERHemdzcFZNUEozVmNudURVa1pTQlB2?=
 =?utf-8?B?dldTbWliUTBtUXkwQTlIcjVqZTk5ZWdXTWNNZFJRdGhFajVQMDNTUm55TkZR?=
 =?utf-8?B?VGExL3dlbEN5NVdNQzVNai81dTJ3Rm03dUxZVzkzeVZsZFI2UmNrOWlpL1pH?=
 =?utf-8?B?TGJKSURBV1Yrak80UzlpR29uckw4UWFwVW5IY3BNbk9SV1JDQ1Q5QVh0WmdZ?=
 =?utf-8?B?Y0FoeENTL3FxcUU3UmdrMXhQa1lCcTQvMWdNaHdTbDJBWkhUV21wS3g3U1I2?=
 =?utf-8?B?QzFHMDZ3UTZOYlByUlkwM0QzUlZlVSs5d2Nud2hXNWFBZi94MEpsbFoxTjJw?=
 =?utf-8?B?TWpON1ZnaU83TFQ4aE8zWXEzMU91b1I0R09qaEFOeHRubitDSnNEdkpyYVhn?=
 =?utf-8?B?K1p6cG5idFVLeHdZbUlzZ1dQb0REdElpMEhJUFlrMEcxUEM1SHN3enNDUmFC?=
 =?utf-8?B?NHcweXIrQVI4TjN1VEhxWTBFSFB6N1N1bTN6c1FsckJwNWc1MHB6anJwS2RX?=
 =?utf-8?B?YW1jb0tOSk9CVnFjOEk5UUpjMFByMXlWU1g2MEFYYWF2Ujc3c09tYkpleGxq?=
 =?utf-8?B?QTVlODl5dEJycmFIbFVlaEhjOVM1L3VERG5uMXBvamJMWWdjRTRobHZPMHF6?=
 =?utf-8?B?K1Z1d3VFUDQ1T1FDUnptTFlwMDYvYjZSdFJLOVRaekQ4WE56K1ZvSnc0bHdG?=
 =?utf-8?B?cG5qNlNNSm9QV3dBaUxyalZFT0tXNEJMcVhkRUk3M3FWcmRFa0NZb0JsSjRy?=
 =?utf-8?B?OUxoTnNhbG1OaGsxRVZiNDFudTBEdGczaUdOaURxYnhjb0x3NnlWRERrSVJL?=
 =?utf-8?B?QmFDZ3BsaVY1Z1hOeVg0cVYrdnBkRzNLUVcxa0ZhcG9oUWdqZDFHY04ycmJZ?=
 =?utf-8?B?SjMvalVQUktBQ1UrUlNVbDRFRXB2UERoM3dBckt4bTdDdlN4ZjNLNVo3TDhN?=
 =?utf-8?B?cHlTdE5vTnpxb1ZJTVFTS2ZvbURFbExXRUZ3bXFpSVBmRVJ2L2tBVmxtT2lG?=
 =?utf-8?B?RmFvTDNSUFJpWDVXaFN3OGJGKzN1WHkxVk5QK2k0dUIxTTZBejZoTVBUeTBu?=
 =?utf-8?B?K2JhTllNdGpERGJXQUgrd0xQbSthZnMrUkJxby9UMkJ1ZjVra09tb1g2M1do?=
 =?utf-8?B?UFRWTWdVdU4yNmtRdWdiY2JtQ2lkZGYwbXJoVDNkVDBmT2dkQnpwTWpCdTQ0?=
 =?utf-8?B?Q1cra2luS3ozUitzakR2ak9kUWhPN0J4VDJneC9zc0poY3FpaDhwUzhVT2hC?=
 =?utf-8?B?UUdsc2dua0F6eEtQdWRiWmt2cG9SdnU0akMxR3hQTjE3S2JxL0hZZDIvMG9j?=
 =?utf-8?B?TTlMN2NBR01Ca09OSlpqUWhaT3JXNERIajc3MnNIWG1TYUM3MXJpdmRJN3BM?=
 =?utf-8?B?ZFNHZE9sdk51YnY3bkliSm81YmhUVTBGb2ZJa05RUDNjVkxxOEp3Q2dVbEwx?=
 =?utf-8?B?cW51eGRXV1FkMlJIaUVqT3YrVnBaVU4xY2tVd00xTTVET2dmOWlyTzZObjdX?=
 =?utf-8?B?L2U5OW82bjhEU3FGcTZJdHVRZHVlZkpnZDQxNHBoc1VlZitaSjFpdThkOWJG?=
 =?utf-8?B?aTFTSGx2WDdZUGduTDBZd3d1dyt1NGYvUXpQRDFnd0Y4aC80ZDcxcHFnVXA0?=
 =?utf-8?B?WE1GMEtiZzRxbzdrZ1JvTDA2Yit2QUY3RERMSWhUV1ZSdHVzNTFFbmdxQ05k?=
 =?utf-8?B?M3Zwek1ZS0ZIVHVidWwvamI2c2dSVStKclpOeU1RdnloTGR6ZTA0NG5Sait4?=
 =?utf-8?B?WXJZR0JTUkUyTktiZjIvVkNkYnh0VTRFNWVUMHd5M3VlMW1LYXVKcTh4OWJx?=
 =?utf-8?Q?iU11GilPq6p7OnAsEf7jIUlCw?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0a18300-b24c-4efe-d1dc-08dd55796805
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB4262.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2025 08:50:09.8206
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tL2Owwj1pAGLVV4gDEcyUVxmJbw0zRpCYdWqA+xnoK1F+VI9FrMJiN7F1wTO2P2x97xdrjJFqyHWLEaMXsUOpw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4298



On 2/25/2025 1:40 PM, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    e5d3fd687aac Add linux-next specific files for 20250218
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=1643b498580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=4e945b2fe8e5992f
> dashboard link: https://syzkaller.appspot.com/bug?extid=556fda2d78f9b0daa141
> compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=138207a4580000
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/ef079ccd2725/disk-e5d3fd68.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/99f2123d6831/vmlinux-e5d3fd68.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/eadfc9520358/bzImage-e5d3fd68.xz
> 
> The issue was bisected to:
> 
> commit 0670f2f4d6ff1cd6aa351389130ba7bbafb02320
> Author: Suren Baghdasaryan <surenb@google.com>
> Date:   Thu Feb 13 22:46:49 2025 +0000
> 
>     mm: replace vm_lock and detached flag with a reference count
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1355bfdf980000
> final oops:     https://syzkaller.appspot.com/x/report.txt?x=10d5bfdf980000
> console output: https://syzkaller.appspot.com/x/log.txt?x=1755bfdf980000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+556fda2d78f9b0daa141@syzkaller.appspotmail.com
> Fixes: 0670f2f4d6ff ("mm: replace vm_lock and detached flag with a reference count")
> 
> Oops: general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] PREEMPT SMP KASAN PTI
> KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
> CPU: 0 UID: 0 PID: 27018 Comm: syz.1.4414 Not tainted 6.14.0-rc3-next-20250218-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 02/12/2025
> RIP: 0010:vma_refcount_put include/linux/mm.h:712 [inline]
> RIP: 0010:vma_end_read include/linux/mm.h:811 [inline]
> RIP: 0010:lock_vma_under_rcu+0x578/0xac0 mm/memory.c:6454
> Code: be 5d b1 ff 49 be 00 00 00 00 00 fc ff df 4d 85 ff 74 0d 49 81 ff 01 f0 ff ff 0f 82 a3 02 00 00 49 83 ff f5 0f 85 55 03 00 00 <41> 80 3e 00 74 0a bf 05 00 00 00 e8 28 df 18 00 4c 8b 34 25 05 00
> RSP: 0000:ffffc9000b837d80 EFLAGS: 00010246
> RAX: fffffffffffffff5 RBX: 0000000000000000 RCX: ffff888079eb8000
> RDX: ffff888079eb8000 RSI: 0000000000000000 RDI: 0000000000000000
> RBP: ffffc9000b837ed8 R08: ffffffff8210a26a R09: 1ffff110068be328
> R10: dffffc0000000000 R11: ffffed10068be329 R12: ffffc9000b837e10
> R13: ffff88802890aa20 R14: dffffc0000000000 R15: fffffffffffffff5
> FS:  00005555908b1500(0000) GS:ffff8880b8600000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000400000002fc0 CR3: 0000000011df6000 CR4: 00000000003526f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  <TASK>
>  do_user_addr_fault arch/x86/mm/fault.c:1328 [inline]
>  handle_page_fault arch/x86/mm/fault.c:1480 [inline]
>  exc_page_fault+0x17b/0x920 arch/x86/mm/fault.c:1538
>  asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:623
> RIP: 0033:0x7f617a954ed8
> Code: fc 89 37 c3 c5 fa 6f 06 c5 fa 6f 4c 16 f0 c5 fa 7f 07 c5 fa 7f 4c 17 f0 c3 66 0f 1f 84 00 00 00 00 00 48 8b 4c 16 f8 48 8b 36 <48> 89 37 48 89 4c 17 f8 c3 c5 fe 6f 54 16 e0 c5 fe 6f 5c 16 c0 c5
> RSP: 002b:00007ffc20f24718 EFLAGS: 00010246
> RAX: 0000400000002fc0 RBX: 0000000000000004 RCX: 0031313230386c6e
> RDX: 0000000000000008 RSI: 0031313230386c6e RDI: 0000400000002fc0
> RBP: 0000000000000000 R08: 00007f617a800000 R09: 0000000000000001
> R10: 0000000000000001 R11: 0000000000000009 R12: 00007f617aba5fac
> R13: 00007f617aba5fa0 R14: fffffffffffffffe R15: 0000000000000006
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:vma_refcount_put include/linux/mm.h:712 [inline]
> RIP: 0010:vma_end_read include/linux/mm.h:811 [inline]
> RIP: 0010:lock_vma_under_rcu+0x578/0xac0 mm/memory.c:6454
> Code: be 5d b1 ff 49 be 00 00 00 00 00 fc ff df 4d 85 ff 74 0d 49 81 ff 01 f0 ff ff 0f 82 a3 02 00 00 49 83 ff f5 0f 85 55 03 00 00 <41> 80 3e 00 74 0a bf 05 00 00 00 e8 28 df 18 00 4c 8b 34 25 05 00
> RSP: 0000:ffffc9000b837d80 EFLAGS: 00010246
> RAX: fffffffffffffff5 RBX: 0000000000000000 RCX: ffff888079eb8000
> RDX: ffff888079eb8000 RSI: 0000000000000000 RDI: 0000000000000000
> RBP: ffffc9000b837ed8 R08: ffffffff8210a26a R09: 1ffff110068be328
> R10: dffffc0000000000 R11: ffffed10068be329 R12: ffffc9000b837e10
> R13: ffff88802890aa20 R14: dffffc0000000000 R15: fffffffffffffff5
> FS:  00005555908b1500(0000) GS:ffff8880b8600000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007ff182f3cf98 CR3: 0000000011df6000 CR4: 00000000003526f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> ----------------
> Code disassembly (best guess), 1 bytes skipped:
>    0:	5d                   	pop    %rbp
>    1:	b1 ff                	mov    $0xff,%cl
>    3:	49 be 00 00 00 00 00 	movabs $0xdffffc0000000000,%r14
>    a:	fc ff df
>    d:	4d 85 ff             	test   %r15,%r15
>   10:	74 0d                	je     0x1f
>   12:	49 81 ff 01 f0 ff ff 	cmp    $0xfffffffffffff001,%r15
>   19:	0f 82 a3 02 00 00    	jb     0x2c2
>   1f:	49 83 ff f5          	cmp    $0xfffffffffffffff5,%r15
>   23:	0f 85 55 03 00 00    	jne    0x37e
> * 29:	41 80 3e 00          	cmpb   $0x0,(%r14) <-- trapping instruction
>   2d:	74 0a                	je     0x39
>   2f:	bf 05 00 00 00       	mov    $0x5,%edi
>   34:	e8 28 df 18 00       	call   0x18df61
>   39:	4c                   	rex.WR
>   3a:	8b                   	.byte 0x8b
>   3b:	34 25                	xor    $0x25,%al
>   3d:	05                   	.byte 0x5

Hi, 

This issue is fixed by this patch:
https://lore.kernel.org/all/20250220200208.323769-1-surenb@google.com

#syz fix: mm: fix a crash due to vma_end_read() that should have been removed

Thanks,
Shivank


