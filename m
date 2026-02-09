Return-Path: <io-uring+bounces-12101-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EBvEM5PciWkGCwAAu9opvQ
	(envelope-from <io-uring+bounces-12101-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 09 Feb 2026 14:09:39 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 64C3410F714
	for <lists+io-uring@lfdr.de>; Mon, 09 Feb 2026 14:09:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id AE8D330054FB
	for <lists+io-uring@lfdr.de>; Mon,  9 Feb 2026 13:09:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA6633624DE;
	Mon,  9 Feb 2026 13:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="wa8o2JWK"
X-Original-To: io-uring@vger.kernel.org
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010066.outbound.protection.outlook.com [52.101.193.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 617962459DD;
	Mon,  9 Feb 2026 13:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770642577; cv=fail; b=Rhyz+PzsFhNWXDI1vnkkaPVn2awkqqD251fQU6zCp5rqdntV+hD6DEMwAXA+KeR0dNb4SHxDAnt0JacyHUMpj0XbNeZx5BIYJCOYlBPw/mkG75Gi6Ac/54X9S9W5f98ggEmyMgl5iKkFTEK6rHmqFSRQNMs7pwDYw29zCq12NDk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770642577; c=relaxed/simple;
	bh=IQh/HCmcMllqd/kXY6oddSksmUVWvdRQsskZ3MM5pxA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=CUOdFdEFdlf5Dg1Y5G9SNC+toirgeD/st/tNKv6hhozoZR6mFMDpEcG+PQmA2sX37Bge1HkMPKxREuwf82u1i1E7TEJPJJcJMBTJhzuC3AASSLGvy6Zok9StAZbg+Cth/8i+m1vN6X2g4t714KOnGDFTIrhCpFfF7WGMH1Cji8k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=wa8o2JWK; arc=fail smtp.client-ip=52.101.193.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hOnpEAmyil3Jfk1bc1RqNzNaCsb3rjHsDl/n7m8ce/iBl0IIHOWURafaBhv8CpjFt9ua1c700EzMiU0mlFlmRDY5YRiMgprJ5jIYhpbmj1E7t/53qvVFthX4hrLABjhTYZGflS4HK+Ol5P+M3qEu2rulnjFMIWpcMmmJjr5bu5hgx0XD/F0nPlpxvmH3BIxsJqcZvyuKKN5yCNRIx0IT3nKtaSOehJ0Z8hxbdICgVmyKpEBBJ8lSiFgzEtHENZOLsysVhjxQjWvszBHZrZr5vobxkseMoJXJOGvqPCQ/P6KIEBfBpNFT/EJQttuMrD7bEDsDdK+434DsdnnBDTUC2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=maLJGrPtktjiwjnOQJSeI0oAQkHKdZQuN5o2pmGjNh8=;
 b=Jcg5hItnrDzADv9WR+CGMEPZUhvRiGTgPB+UFSpJltzN69IMZCiHm5e1H7Z7xDKicbBsqRF0Sizr/07H8kvbrXsnAJ+hwbx6Ys7FWzcS0J3Me0xK6Q7SapdEl9heb2xmK/YeWr4lYFaxTXHQqwmVPpXr7zRSDd6ym65zlFhuMzvfFi4uhlqFyYFWs6vbn9TT0goxkp5qtsqT4y76BAX9bONQzdZvzJbaG/OvDsMiD7DbvU5t+3XBzs3sFoQlDYZaJFwY3swfuTjPYMP6pcb/8DMwmG5Oa5Vc8Il2dpCA7y/HAaSPPVs2IB4ev5oZqZJZCNHaeK3K8IssWFO8FuSt7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=maLJGrPtktjiwjnOQJSeI0oAQkHKdZQuN5o2pmGjNh8=;
 b=wa8o2JWKam2lGbvZSZ+G1h6gfmscefEcJRLjCxMhD9XSwmSRaax6+PlqcWzb37V5knE+Ko/hVEkujbjXmgH7SDIcIlviz5Je7KGkwSOU4v68DxZIwGnH9GZlpFpDDuyNxzam1msdgtrB8TdVvl4EZORET4mWyy/R9nPhGyirypA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB5685.namprd12.prod.outlook.com (2603:10b6:510:13c::22)
 by PH7PR12MB9104.namprd12.prod.outlook.com (2603:10b6:510:2f3::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.13; Mon, 9 Feb
 2026 13:09:30 +0000
Received: from PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c]) by PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c%5]) with mapi id 15.20.9587.017; Mon, 9 Feb 2026
 13:09:29 +0000
Message-ID: <6246cc2b-0d6e-4062-ac24-74c7148dc47d@amd.com>
Date: Mon, 9 Feb 2026 14:09:24 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [LSF/MM/BPF TOPIC] dmabuf backed read/write
To: Jason Gunthorpe <jgg@nvidia.com>, Pavel Begunkov <asml.silence@gmail.com>
Cc: linux-block@vger.kernel.org, io-uring <io-uring@vger.kernel.org>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 "Gohad, Tushar" <tushar.gohad@intel.com>, Christoph Hellwig <hch@lst.de>,
 Kanchan Joshi <joshi.k@samsung.com>, Anuj Gupta <anuj20.g@samsung.com>,
 Nitesh Shetty <nj.shetty@samsung.com>,
 "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>
References: <4796d2f7-5300-4884-bd2e-3fcc7fdd7cea@gmail.com>
 <20260205174135.GA444713@nvidia.com>
 <dbcc2912-e1df-491d-b1e0-7812279297de@gmail.com>
 <20260205235647.GA4177530@nvidia.com>
 <3281a845-a1b8-468c-a528-b9f6003cddea@gmail.com>
 <20260206152041.GA1874040@nvidia.com>
 <df7fe4d7-ca28-408e-bed3-bd1fa23e7588@gmail.com>
 <20260206183756.GB1874040@nvidia.com>
 <4736af5c-4bf8-4e9b-8f82-4b89a75d2cdb@gmail.com>
 <20260209130607.GF1874040@nvidia.com>
Content-Language: en-US
From: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
In-Reply-To: <20260209130607.GF1874040@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0078.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9a::20) To PH7PR12MB5685.namprd12.prod.outlook.com
 (2603:10b6:510:13c::22)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5685:EE_|PH7PR12MB9104:EE_
X-MS-Office365-Filtering-Correlation-Id: 7af3405b-df5c-4b82-e95d-08de67dc7572
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VXExTHlDZy9OeW5MYXdKVmhoY1pDWWtlbm84MEhRU3AwVm5HZ0hYUlNteVlM?=
 =?utf-8?B?Z09adlFLZjFOVDB5MkQ0YnVQUXhzWDExcVBrK0lZUWlTREg5SlFGTTZoMUFa?=
 =?utf-8?B?eGNMY1FmNk5jVXBIcmlBR0JXbVRwM3p4U0E3RzEyQWc5MThBYk9iZmt1bmFG?=
 =?utf-8?B?eDdkY0wzblMyYSsxS0VJSjFkQXdBM0NWSUgvUUhPdXpvM2lQZ3JYaGpEcVJB?=
 =?utf-8?B?OVRsekswVkdlWmViTGhSYXBLVHpoeUpib0FRZ0hmQis5SDBkdEJOby96YUU1?=
 =?utf-8?B?dmNWY2lFUnJIOHd3RXpjWWV3YU9vRHpUSDhDZEJSUWQ2aU5FRnMydm9WM1Q0?=
 =?utf-8?B?MElMaUtxRFVzdWcrSzYwS0VzZENaT09zOWlpTEZQelNSMi8wOWsyK3FiUm5I?=
 =?utf-8?B?dDB2ZG5xZUxxQXVzejhteVV6WU9LTFVxVWtwR0NCby82NURjOEVHbWJuWjFH?=
 =?utf-8?B?TnA0bUJnQnQxYytIVm9pSWJSL0hsOGR3WEF2T0h4ZS9weFZ4S2wzeURpYllG?=
 =?utf-8?B?bFBIRmZMU2crWTR0aUJSaGJkZnpIOHpoMm92YzR2NUJ5bWF0R1lZaEtndlN3?=
 =?utf-8?B?dy9wUElXSENaTUFHbXBJcDRIOUdmUUJtNzAxT0M4eWdIdmp6MDh1M1lhVWF6?=
 =?utf-8?B?eGo2dEgrcHl1a2JnTld4T3N0WmZETXBGNlhLRGlrK1dUN2xsbUlKUHFsOHdi?=
 =?utf-8?B?YUNMZThXakVCU05nSGRUZHMzRXhFRi9VS0RkYlN6UmNtbkV5dzB0UFgxZVJm?=
 =?utf-8?B?eWE4ZCsvSGtrelI0NkJUVk4ySHVodURWSU9Hb1NDa3VpLyt0NGV0dnBKaWdS?=
 =?utf-8?B?QktpQXFsYVRITmswV0hVa0p6RHZDWnN4Nkh0YytqSGY1aEMyZEFSQVJnaUZN?=
 =?utf-8?B?RFJDNTR6dGlJZjJpY050amF2bng2MzhTV3l3cE9ycVQ5Zno1MUtJZWNGdzBO?=
 =?utf-8?B?NEsvQk5pTGF2VE5PczdGQjMzNWx6aldzNWttMmtyeTNBdlBiR1NZV1F2dFNL?=
 =?utf-8?B?NksvVTFqM0dKVW80UVlNalNxWHBLNWM2WUxHZTJlMmRYY0ExOW41UW8xMWR0?=
 =?utf-8?B?M21EaGs2U0dDUld5cXRvQW1sM0JCRFVlUzFQU2t0RkdNN1BxSmdxaFFoQ0Va?=
 =?utf-8?B?UG4vcXljR3djZXBsbkZhZkJjdXZqdisxamxpSjRyYjY4a1dBdWx3RDlmMWt6?=
 =?utf-8?B?Tmd2TDQ1YXN5WSt2YmdwSFNIeGU4RHJuL3Y4RE11ZUlRVUJ3S21XUytHVDNC?=
 =?utf-8?B?S0NpNmpUQmZIUkEzUmYxaHR2bkNYSlBWNUdFNjlWYVV1cjRRT0hnN0pnQWJI?=
 =?utf-8?B?S0RSeHR0SE1vb0N6V2NyaU5QYmYyR3Nrc2NxY3hqWkpkSmFPZ2k5MlVrdFRa?=
 =?utf-8?B?ZU1yaDQyRjQ3QjF3SkQ3NEZNbjU0bVZxQW05bTRxV2dVOEdqQ2t1RTU1RUJQ?=
 =?utf-8?B?ekJybkJ5dFNaZW4rR0lGbkR1TXhQcE1YNTJHZUdjTDRKNUdibExlcFFZRGU4?=
 =?utf-8?B?OWVyMUJMek9aeUJUQ3Z3S0RsR0ZHeEhNQ1BDV2FhY0RscHZkRmhkRjFLWEFx?=
 =?utf-8?B?SVNtYkZsbHMxUVM4NnllSzhUS1h2ZGdyaUxGMG1yT2M0ZXFuQnl6SlVJSm9a?=
 =?utf-8?B?QVMvMmhiWU9OYnlmOXVYQ1lJZDJqa3ZpSngrbFBtZXZUdmxsdVBRMllaNEx0?=
 =?utf-8?B?WE1ybktLSWQ1M25wZnZhdk0yV214d0ZCTUdpSGRvS1UwT2lBdE1EQ20rSHdP?=
 =?utf-8?B?a1ZBSVRrRW1ieTQwZ2UrVDBjQm1YUlZNZStNalZJS0F3cHdXRVdlb0tzWUtz?=
 =?utf-8?B?WGZSTFZ1dWtLNDVvUldLeUgxSTR4N1BOSStIUkZtMXBZa1RrTGlNQVdmWm53?=
 =?utf-8?B?RGkvUnU1c1RYMFQyaWoxalhOOGdLYWoyNlhSNEtOZWlrQjdIbjZTQ2tpM2U5?=
 =?utf-8?B?NmtFMzlsQVFoN3Q3cU1rbnlDVFBmaHR5YmxDRWRwd2ZKTmd6WFo4M3l3SjVK?=
 =?utf-8?B?MkNRVlZwNjk2R3JGSExOTVA5YTZOMW1Wc1ovRDB4YWlrM3ZvTHI5bm5QMEF6?=
 =?utf-8?B?eXFZY0tVSy9kR1JQeWtqOHM0UEsrUlppQjVxRmNaclBRM0hDWjI3QkhsWEhJ?=
 =?utf-8?Q?vtjY=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5685.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bTFsckxiS24ycUd6Tjk4c0JxS3ZkdVBzZXl1OVIxdHMwMEIvZitNRjdSd1lS?=
 =?utf-8?B?NC83UFVGQzJuRGNsQW5ta1l5NEMzckhrQ0srSkgwbnlnTDFsNFI1WWN4MUtG?=
 =?utf-8?B?OHpPbEFidEw5RlBEQ0NpNjNwY01tdHRHMnY1U3Z4a1UwSElzSS9OU3FFUE1I?=
 =?utf-8?B?MGZJNjFlb1c5WlJ1N3RRK0wxL1RRem50cXlIRWR2RzI3RDhpOE9GT0xMa1hn?=
 =?utf-8?B?U2hhNGxLYmxKK1JFMTVsQU1Xb2pidjdZS2FzVUc5TkdkbnZnQVF5NU5CUE9o?=
 =?utf-8?B?Yk02TCswTDVWdXFzQkNJM29iWEludHZST3F2VjZ4aWZ4VklpS0p4eUVwN0dm?=
 =?utf-8?B?WHNySDU5VjNQc1cwZUF3SmR5UE85RHc2bEQyYnBJM1cxK0V5djNqOGw5VlRw?=
 =?utf-8?B?My9TRUtabjhaQnhHNGxaZlJjWklhbDlNbzVUYk5mTS80MFdYbWlSY3VNRHkz?=
 =?utf-8?B?OUVDMEk3K21pWDZLUStOeU9IM1ZNeGd5alZ3b3JYWUpGRlk5ZVZhOE9qQUgx?=
 =?utf-8?B?alhHNDdXZTh2UkQzcnpvMllJdFB2dGh1bENUcnBlWHNHTEFFMzBxK3RzRE9Q?=
 =?utf-8?B?UEFuamYrczlXaTZzcWM5ZHFCWjlwT25leG5pNndrSlloYkpGVUpZTDFXTFpv?=
 =?utf-8?B?QkF6NENvWGFINWs4L1l1LzBaQlhpVmdwV0haLzNHK05ZaitSaEEyeFlzUkZi?=
 =?utf-8?B?aVpyajB5eFdmVktJNUIvTzZBbU8zcUFrd2pZcHFnMU9LVStxb2NsWDVnUjFk?=
 =?utf-8?B?WVk4Z1VaSk41Y2FwTi9RbjA4bWsyOGtsN2gzV2MyZk5TclBmeDg0TXpyMmpl?=
 =?utf-8?B?OEQyWnpCRkdiNjVLQnNBaHBSdXY1cEw2QWVwak53VW5OTEpsdElZeDZLWjl1?=
 =?utf-8?B?R2xGZ1I2ZXpKYmhvakREYW9NL3d0emlZcitGbC9uSXpQTzBQL21Sc0pSemhS?=
 =?utf-8?B?N2tVQWhsVVJUd1NRcnE0ekU3QzRRRFpCRHRNRFBhQ3pZNFUxTW1FYmhsQ3Ni?=
 =?utf-8?B?d01VT1JRUEdWcHhBYkNBamVaYUhaYStpeWJDc0JMVXFUbW8yK3cwd3RyNlIv?=
 =?utf-8?B?c05IMHN3bG5OWEE0NWM3WU5OSkMra3ZHSEtmMHpmanZBeHgrSnhHdmFuaGtr?=
 =?utf-8?B?Q2J5QkNxdlN1VVNsWGRGb2JkYjJuSGxUNkdSLzhna2VLQlUxbTRmdGh2SGRJ?=
 =?utf-8?B?eFpWemV0c3o5YXhqaU1odU1zc0hWZW9VMTRMNDdYMzJFMWxqdFhxbXF4eHpC?=
 =?utf-8?B?WWNnaW9Cd2Jrc2tqbHBxdUNYcXZCK3Q2V2h2eGZiNmFqMGpFY25yOVJXMzc1?=
 =?utf-8?B?TEdkRUtMSFB0emRBTW9qV1VNczZaR3BtTGFIcm0wSTlsRW5kQzA1dzNPL1o0?=
 =?utf-8?B?NjJMMHdmcU9BeXE5OUdBaXRpMmtNYUZxR3V4VUp6bUJtMWxJWFZ3WWxJMENY?=
 =?utf-8?B?ZTN4czdXeUZzczNKY0NBd1VWSjRDTXhoM1BoNmR3bFFTRVFaMG1Gc1F2ckVu?=
 =?utf-8?B?YmR5Y2xJZ3hqKzAzL1dRYmxxS2VPV05XNndrclBQcDVmSXNvamFGVEgyY3NK?=
 =?utf-8?B?N0xTL2lEVm00ZFlXMllaV0tjK1Zsbm5wME02eXNUL2lLZWZxUmpJVnd4MmQy?=
 =?utf-8?B?SHlhRnV3RjgzZEg3Z3M1c2pkU0NyMEJzTnIvOHZwcy9Zd0pGaGZXVjNKc2tU?=
 =?utf-8?B?YlJyR0VtMWp4NElTOVVZQ21wZWRyOEtodmkwS2xyY05nTmg0eHRsMDJtUGs1?=
 =?utf-8?B?Q3dIbk1wRWU5YWpxaDNQcnBVOTVKc0F4Ny9VUm5hang4QWlidnYrQlV6ZUhq?=
 =?utf-8?B?RmM5Lzlja3RGVlhmYUwzRlQyREVDYyt0RmtWWXJEMTAyQjFaa0ZUVFNQbHg3?=
 =?utf-8?B?VEtWeUpTMUxrOUc2Y0Q2a2lKdmx3aWRyTzRSR0lKVWVDeExtZENzMkpSU3o3?=
 =?utf-8?B?bElhZDFYZ2t6MlZUdks1bEM1YVF4RjgwU1RTdnpWaWVzNUo0czl1WC9ZNEdk?=
 =?utf-8?B?ZEFtUmJtWVRqZUdFN2JTMDQvdkYyRldheUZJL0dhbXZPUTFBQWJRQndiUHhG?=
 =?utf-8?B?K3FHZ3FjQWdsalZvTHlqMlZEbm1wOUFnaE9UMGJrQlF3Ym8rN0pZSytMTHk3?=
 =?utf-8?B?REs2MnRMdGNVWTlHWUkxKzgreXNVSEJsV2JpbXoxbGFJc0Urc0JsNWFGaG5P?=
 =?utf-8?B?azB6d09RTndUWjQ5R2h3eDFFSVhGTlA0UzhSS29KbTRGd0lYMVNRMCtMT1Ey?=
 =?utf-8?B?cmYzYTVmWTVYcWdaVkRDTUt0bzlvUzZiZHFVeFZRMnIycVlaUWlFcVRCT1d2?=
 =?utf-8?Q?xDF04UpZmq6JH4VCSY?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7af3405b-df5c-4b82-e95d-08de67dc7572
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5685.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2026 13:09:29.5197
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nkwdMNXDq4/ROKWunowt+Xm8oMyLhPa0gMCaelqEWxzfaS+6fVLbdrMYrum8Zio+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB9104
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.34 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12101-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_TO(0.00)[nvidia.com,gmail.com];
	MIME_TRACE(0.00)[0:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[christian.koenig@amd.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[amd.com:+];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	RCPT_COUNT_SEVEN(0.00)[11];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[amd.com:mid,amd.com:dkim,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 64C3410F714
X-Rspamd-Action: no action

On 2/9/26 14:06, Jason Gunthorpe wrote:
> On Mon, Feb 09, 2026 at 10:59:53AM +0000, Pavel Begunkov wrote:
> 
>>> As a step forward I could imagine having a DMABUF handing out P2P
>>> pages and allowing io uring to "register" it complete with move
>>
>> Forcing dma-buf to have pages is a big step back, IMHO
> 
> Naw, some drivers already have them anyhow, and we are already looking
> at optional ways to allow a very limited select group of importers to
> access the underlying physical.

That is just between two specific exporters/importers and certainly won't be allowed as common interface.

> It is not a big leap from there to say io_uring pre-registration is a
> special importer that only interworks with drivers providing P2P
> pages.

Completely NAK from my side to that approach.

We have exercised and discussed this in absolutely detail and it is not going to fly anywhere.

The struct page based approach in fundamentally incompatible with driver managed exporters.

Regards,
Christian.

> 
> It could immediately address everything except pre-registration. And
> do you really care about pre-registration? Why? Running performance
> workloads with the iommu doing a DMA mapping is pretty unusual.
> 
>>> Pre-iommu-mapping the pool seems like an orthogonal project as it
>>> applies to everything coming from pre-registered io uring buffers,
>>> even normal cpu memory. You could have a next step of pre-mapping the
>>> P2P pages and CPU pages equally.
>>
>> It was already tried for normal user memory (not by me), but
>> the verdict was that it should be dma-buf based.
> 
> I'm not sure how DMA-buf helps anything here. It is the io uring layer
> that should be interacting with DMA-buf, the lower level stuff
> shouldn't touch it.
> 
> Jason


