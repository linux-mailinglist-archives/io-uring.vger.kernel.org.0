Return-Path: <io-uring+bounces-13830-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id ZQGeJYHaO2rbeAgAu9opvQ
	(envelope-from <io-uring+bounces-13830-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 24 Jun 2026 15:24:17 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D8056BE8F1
	for <lists+io-uring@lfdr.de>; Wed, 24 Jun 2026 15:24:16 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=amd.com header.s=selector1 header.b=Dc94bJtD;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13830-lists+io-uring=lfdr.de@vger.kernel.org" designates 104.64.211.4 as permitted sender) smtp.mailfrom="io-uring+bounces-13830-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=reject ("cv is fail on i=2")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 758A8300721B
	for <lists+io-uring@lfdr.de>; Wed, 24 Jun 2026 13:24:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 304543B27C6;
	Wed, 24 Jun 2026 13:24:09 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012049.outbound.protection.outlook.com [52.101.48.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D6961DF736;
	Wed, 24 Jun 2026 13:24:05 +0000 (UTC)
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782307449; cv=fail; b=MqassYjNgYgM4A0iLJnQq1GgcjByPW0hXaKse8Wqmui5CTO1MLqdi3sySzrUpJbHVp/X+7CrieX4Sxoqqu/o74gNEEJnloqJbriNt5vK7S4+jDRWZCAczPzHXliZLFa05d3BvE18rMujlCz0fQQxG/HYPetveM0sz1WydCEUNFM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782307449; c=relaxed/simple;
	bh=fa+S84HJ16sURB3PNA9C1IyPsffcIgr7c2Etm3JmKEY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=L0gCvisSSTG3J1SvZz7tLsLkSfbzU40ffJjmc3aeYG6GKzzKsSNRtnpUdjc9FiKf8hFk6eg54bIBocEOLXv7OPxNwZUNPVDTC53OTFI9o87fmhYbVjwP/ZVxl8cmn9LcsKAa/Odp8NPtRPDYM/feAQ40E2iSWi9l5j25gAh1x4A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Dc94bJtD; arc=fail smtp.client-ip=52.101.48.49
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tdaAv+ecVA6DZauEGCo9T7B1nQOcCSUU7hNraj6tRtvtEUHeUQj+rFIXvoWnfPqY2jhC6wTt7R5+xcBY+VelRctKrARIr4wFZbaANqvwzrGcUf8rtxtOhVqHYalcx7RfsOmd6Os93RNh+K5OUkebyCKH5NBEKXytYF2j5Rl+jRyvcQ+Gg7v73Tj8YrP+mR/51jOvdRVdZWEAYjMDLVFBpPhzlgphh9Ezf7NC47k8IaCF0Cb/w30LBjYjWpROP/SPaCTetRgg0ltq47Ri5yeOwV9IFjbZYyh7A9G7Qtv/+Nc4zu08kN5H6K8BBSZyZ3m2G2dF3Zq4uRjqZvsALTPMuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d81CM1+AT4WllJ72uDv8AXVKFPVvGK8TiKbKmP7zRcI=;
 b=sFfEVVxRwsOYnMcorSkPi3qRpCppWOTlauZ7YwzcPjJrepWy2banawSRiQaamujWLzH7Yovh7ENxhyducOetDdXtV1XFbL6iapW7G5HTFQCirdpvpTOYs0YHy+RcrflhBaARVWO1RdbVKvKoyb0fO3BmNMTIBGYfvpvol1u53nhVZ42cRILUOyxRtQ74yozN+rK428+aL8CCErpNEkNAh3+LLelktq5N4ng84SmLdBgXMssQz2zLSrS/mxXQQA3bLevLyLpOyjc+nB7gvgns33sblaC7Wq4xCrlSwG65uV7dd0XfLPQl5XraQD47voUHwmBSQWUTshtT8HLMy4gGog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d81CM1+AT4WllJ72uDv8AXVKFPVvGK8TiKbKmP7zRcI=;
 b=Dc94bJtDtzGF6zztoUX5l/0+u8PChmvdYrmw4RV69JMcqBPpaCuwM6m7FYCD96iE76/DFmIb1NLF2TM8ns09RKOhlAtoUYlKIt5NKISj2tBRmfTa33pXQr/2q01X23GhzczSPuaJVh7I8h1G2u/xxf1sPPYPTJNjJHQLYY2EQXs=
Received: from PH7PR12MB5685.namprd12.prod.outlook.com (2603:10b6:510:13c::22)
 by CH3PR12MB7570.namprd12.prod.outlook.com (2603:10b6:610:149::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.14; Wed, 24 Jun
 2026 13:24:01 +0000
Received: from PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c]) by PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c%5]) with mapi id 15.21.0139.018; Wed, 24 Jun 2026
 13:24:01 +0000
Message-ID: <cf8467c7-b98f-44a5-9cf9-60b43b5da711@amd.com>
Date: Wed, 24 Jun 2026 15:23:47 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/7] list: Add mutable iterator variants
To: Kaitao Cheng <kaitao.cheng@linux.dev>,
 David Laight <david.laight.linux@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 Tejun Heo <tj@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
 Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>,
 Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
 Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Paul Moore <paul@paul-moore.com>,
 Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
 "Paul E. McKenney" <paulmck@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>, David Howells <dhowells@redhat.com>,
 Simona Vetter <simona.vetter@ffwll.ch>, Randy Dunlap
 <rdunlap@infradead.org>, Luca Ceresoli <luca.ceresoli@bootlin.com>,
 Philipp Stanner <phasta@kernel.org>, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
 linux-ntfs-dev@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
 io-uring@vger.kernel.org, audit@vger.kernel.org, bpf@vger.kernel.org,
 netdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
 linux-perf-users@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 kexec@lists.infradead.org, live-patching@vger.kernel.org,
 linux-modules@vger.kernel.org, linux-crypto@vger.kernel.org,
 linux-pm@vger.kernel.org, rcu@vger.kernel.org, sched-ext@lists.linux.dev,
 linux-mm@kvack.org, virtualization@lists.linux.dev, damon@lists.linux.dev,
 llvm@lists.linux.dev, Kaitao Cheng <chengkaitao@kylinos.cn>
References: <20260622040533.29824-1-kaitao.cheng@linux.dev>
 <20260622040533.29824-2-kaitao.cheng@linux.dev>
 <20260622094242.64531b9a@pumpkin>
 <351a6b67-b394-4c58-aee2-88b6c8089ad5@linux.dev>
Content-Language: en-US
From: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
In-Reply-To: <351a6b67-b394-4c58-aee2-88b6c8089ad5@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BL1PR13CA0270.namprd13.prod.outlook.com
 (2603:10b6:208:2ba::35) To PH7PR12MB5685.namprd12.prod.outlook.com
 (2603:10b6:510:13c::22)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5685:EE_|CH3PR12MB7570:EE_
X-MS-Office365-Filtering-Correlation-Id: 715eed2d-514b-4810-2f08-08ded1f3da78
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|1800799024|376014|7416014|6133799003|18002099003|22082099003|56012099006|4143699003|11063799006;
X-Microsoft-Antispam-Message-Info:
	vjRMDzmTxaLO3rG//AE977uAg8zKrEwMP6cu1AOblab8SZ491Cs0rYGIPxYvAFRNxWSVQ1WdRjVkW8uINOWaaO1LcWyt/wIKFnqXxociABOHsobehPc8e61s3GnfEfviv/vYUJs1BYtORVJs0+rNk2XGq+ZYcvNpXg6oKMgBd60P6S9UAXXOjUalPunVJcruSBXhU+03Db/ZLAvwRMJ4LkyKp9X8urTD29nI1sVli23YRzfr6f7QlYt1NE8z2tjj+tTOuaopcIYaTyRREeh1LTyJGLjXPTHttj/0qGSJWH0dbU2PQ16weT2vE/oUJQOd55L87wLEkz7iKzhzNzwmoRCxnEYaTxhqUK/d7fhbS49r2+o+otSyW6oXmfcTSEh+A13SwWrC412pRamXap2Sq7vEAcnU53bRd7aSf1zOxgJJbd60qry1G7yF8/wahybuHwktLDMb87yqpcxhBNlskColY6z/ieQl9ZLrsRjxsFjJ4g1BGfi6PGkW4cNzSNGwUDfb3g0kKQ3RXayJ1mvTgK+cHwyZAOuPrNH+rmrGsOoC7gIXksGzl1YSqQT/guiSOvjYJs2VkcDleBwpXa21FkM2F/IXE9BjHNUkTuuA2CqTou5m5AUIIvTJkWTeEcpphCrCfaZcRkBjaZAv/XpqW1HguK/RVMJYVXXsSyz8H8k=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5685.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(376014)(7416014)(6133799003)(18002099003)(22082099003)(56012099006)(4143699003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YWxibmFPMnl4Z04zVXpKQXBkcXNhV1dTQ1o4RW0vQ3czTkIvQVQ4KytXc2dV?=
 =?utf-8?B?QlIwYmFNbGQwSVNPbVd3MXlQMmJjZWJNTXA3Z0VRTjZSQnVNU1FmejFKNzh3?=
 =?utf-8?B?ejRvMkY3NHNNSjNSaThtY0xPaTcvNU9BeldYNGx4VW8xZXJmSzJmaWNDV0Z1?=
 =?utf-8?B?QVdzQzZuUTljZUF6UXIyZzd4OEVwRS9oT2pFdWVPNERlUjBrZjVsSUZ4M1Aw?=
 =?utf-8?B?VmR2bFl4aFVEd2dmV2Q2NHNUWVE5d3BVTXQvcVFqR0E3blVnUXJRVUhKdmN3?=
 =?utf-8?B?U251WFF0SlhUc3J0MjdwdXB5UmFFbDRSeGxSckpQSHZ1RXlkTUV4RXZvdkxa?=
 =?utf-8?B?U1ZZK2NIWlB2cFZDUHNxL2J1MVEzRnp0Z2k2SzFCemtvN3I2M0htRUVrcWlE?=
 =?utf-8?B?TjVpOGhaNFdnUFR4Zk5WWGpEU2NObC9WM3Z6eHFsbVRkS0NxZGpENi8yR3Qz?=
 =?utf-8?B?Tmp0cEpqMFcrbnRhQStMV2xWYk1qTHhOdlh4dGtHQWNIS1VEVFJ5UzZXeVEw?=
 =?utf-8?B?RUc4aUtQS3BmMnlPTXVpNVFDcXJNbDRiR3FuWmVVLytDUm5CdFI3dGltV0xO?=
 =?utf-8?B?T25rMFhVNXpCaGxlUjM4cEJUK0ozdXF2SEdhRG9MLzNHdVphcDNGVjh3M1hj?=
 =?utf-8?B?YWozS3Nma2dZMmx2VmdhMmxaTXRVbTByalA5YklaM1hwVk9KNXNyQk1xbnli?=
 =?utf-8?B?eVFxWkIwdTJBckZuZFVsaEllNnl1cFhNdGkzeEdaeVVRckM0V0d1czZxaFRi?=
 =?utf-8?B?MmxjdHV1SjNnQnJieTE4K0w1YmdCK0FQbFZsL3QvcTB3dityclIrdHp2dFZo?=
 =?utf-8?B?WTV5Q043cFNaVm5keXZISjFLZXJzRDZKd3Q3R0pIYzVMZ2tBcDBvaG5vU2ll?=
 =?utf-8?B?b1VCOUV5VnRyVll5Y3lOTmE3c1RNbzlkWUFwVWRtWXdxSllWK3ZjOS93TUVw?=
 =?utf-8?B?dnMyekZZSHF1bHU3Q3kxVzZwWkZsWk9ndjZHV21aYzdlMDV2Q0MvVEFTWHVu?=
 =?utf-8?B?WkN5Qm9LOTZ1am5nL2NaYktHS0thc0FVNEtDcStzMEcrRWY3MDIzdklSL2I0?=
 =?utf-8?B?ak4xck1qd001enVONE1HeHJMc0xMa2tYTjRQTm9vMGZpNlR5WFV4KzA3aUhy?=
 =?utf-8?B?MitMSHc3MnFaSjRaemlZWDFRaXVEc0xEeHY4YlpoeHdxa0xEcjJrajVQYkM5?=
 =?utf-8?B?Qi9ISWE2ODFNYWV1aWNWQ1NGOExiM3E5YzhJODRjcVhOR3YyMk9IbFlFMG10?=
 =?utf-8?B?czFvWVhOd1UzQU1WU05ZYW1odXBrdXpObXZtVkIwcklLa21XNG5wSmphWHJD?=
 =?utf-8?B?aGJOajZqSTVmb2gvdHc0WTQySjlHQ2VIRWY3SHZScW1YUlBoL3ErdDFmYUFO?=
 =?utf-8?B?cTl6WHNGaEtZTVNvVk1sV1NXblB6WG0zRlZnNUVPV3hnSEJYRG10a3RhaXA2?=
 =?utf-8?B?WU82ZjFqYWdGaXZ6TExybGVNWTk2QzJRTlk4SE9WVUJtV1FRVU1tbkZlTnp1?=
 =?utf-8?B?bFhTczlvYUttdEU3bEZwTnp3ZjN1MmxQQnk4MGlMYk9Ga3h0YkdDUFk0bWJN?=
 =?utf-8?B?cWVmR1dWdHVWV1IveHlnWnBla3grZGtqWW85ZkYyQnhWSEtzTlRYa1dhenlP?=
 =?utf-8?B?Y3FDaXJxSkJiUjdQNktaNUpDVFk3eGpUYWNnOWtramhxZ0RWc0daaW4rY3BX?=
 =?utf-8?B?cEtsdG81L1lRNCtiTEMvYTNHcVY4MmpuaFZvVTVySlVpVVlkcTNQajhGb08w?=
 =?utf-8?B?WGFBNERTSGxLc3cvakQzZjRwbzEvMUMvZ2o2SnFzM3RHY1k1YWlYck1KQjJp?=
 =?utf-8?B?alVWRDFVYXFkOVBLRlY4MkRGQSsvb2Y4SEZ2T2pkemZNU3FnVjJTR2NWU2M1?=
 =?utf-8?B?RjVpMjdCemZBWXErMndvbkJkaFk5ZnJRck4yYXU5V2FqVzJ2Y1pjQkhSTUEx?=
 =?utf-8?B?ZmdFZ3lrc2JjL1lpb1R2alpYNUFidDVCNXdFaXdyNk9yWjl1Z2p4Y0FqdEZB?=
 =?utf-8?B?T0JmTk9xK3MwRGxrL0tqZGFWK3BXZlUyNWlITzBzUHY4ZjYzNkw4MW5ZVVFv?=
 =?utf-8?B?NFhsR2tPaEFKY3EwRDJOYlVhOU1LUUtDMVRqeVNCZXdnY2lML2k2VU9tbzFI?=
 =?utf-8?B?WlZOOXBScmUyd3B6bEl2eURzOVB2VzRnLzFGQTZaS1VVd0ZaaVplWExGZ1pQ?=
 =?utf-8?B?U3RTNWlFaitwNVRqREs4c0RHMFlKVjMyeENKbzk4bjIvL2FkRDExcitRdXA4?=
 =?utf-8?B?Yys0Rm5zUmtIRkpVYzVKSEhHNmlsbFVvZHpWTHl3SUZkdkxWNndJUUpENkl6?=
 =?utf-8?Q?cSgurPjmbMLoRmPxTI?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 715eed2d-514b-4810-2f08-08ded1f3da78
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5685.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2026 13:24:00.9068
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QVhBEK/2F/j8PEv/furwKNhQwAwxU3hZSEqW50n8SOx5hinzeiYl4lrFCu6sDpFf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7570
X-Rspamd-Action: no action
X-Spamd-Result: default: False [1.34 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13830-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:kaitao.cheng@linux.dev,m:david.laight.linux@gmail.com,m:akpm@linux-foundation.org,m:david@kernel.org,m:axboe@kernel.dk,m:tj@kernel.org,m:viro@zeniv.linux.org.uk,m:brauner@kernel.org,m:ast@kernel.org,m:daniel@iogearbox.net,m:andrii@kernel.org,m:hannes@cmpxchg.org,m:peterz@infradead.org,m:mingo@redhat.com,m:acme@kernel.org,m:namhyung@kernel.org,m:tglx@kernel.org,m:juri.lelli@redhat.com,m:vincent.guittot@linaro.org,m:paul@paul-moore.com,m:andriy.shevchenko@linux.intel.com,m:paulmck@kernel.org,m:shakeel.butt@linux.dev,m:dhowells@redhat.com,m:simona.vetter@ffwll.ch,m:rdunlap@infradead.org,m:luca.ceresoli@bootlin.com,m:phasta@kernel.org,m:linux-block@vger.kernel.org,m:linux-kernel@vger.kernel.org,m:cgroups@vger.kernel.org,m:linux-ntfs-dev@lists.sourceforge.net,m:linux-fsdevel@vger.kernel.org,m:io-uring@vger.kernel.org,m:audit@vger.kernel.org,m:bpf@vger.kernel.org,m:netdev@vger.kernel.org,m:dri-devel@lists.freedesktop.org,m:linux-perf-users@vger.kernel.org,m:linux
 -trace-kernel@vger.kernel.org,m:kexec@lists.infradead.org,m:live-patching@vger.kernel.org,m:linux-modules@vger.kernel.org,m:linux-crypto@vger.kernel.org,m:linux-pm@vger.kernel.org,m:rcu@vger.kernel.org,m:sched-ext@lists.linux.dev,m:linux-mm@kvack.org,m:virtualization@lists.linux.dev,m:damon@lists.linux.dev,m:llvm@lists.linux.dev,m:chengkaitao@kylinos.cn,m:davidlaightlinux@gmail.com,s:lists@lfdr.de];
	FORGED_SENDER(0.00)[christian.koenig@amd.com,io-uring@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_TO(0.00)[linux.dev,gmail.com];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[christian.koenig@amd.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[amd.com:+];
	RCPT_COUNT_GT_50(0.00)[52];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	ALIAS_RESOLVED(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo,linux.dev:email,amd.com:dkim,amd.com:mid,amd.com:from_mime,kylinos.cn:email]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 8D8056BE8F1

On 6/24/26 15:14, Kaitao Cheng wrote:
> 
> 
> 在 2026/6/22 16:42, David Laight 写道:
>> On Mon, 22 Jun 2026 12:05:31 +0800
>> Kaitao Cheng <kaitao.cheng@linux.dev> wrote:
>>
>>> From: Kaitao Cheng <chengkaitao@kylinos.cn>
>>>
>>> The list_for_each*_safe() helpers are used when the loop body may
>>> remove the current entry.  Their API exposes the temporary cursor at
>>> every call site, even though most users only need it for the iterator
>>> implementation and never reference it in the loop body.
>>>
>>> Add *_mutable() variants for list and hlist iteration.  The new helpers
>>> support both forms: callers may keep passing an explicit temporary cursor
>>> when they need to inspect or reset it, or omit it and let the helper use
>>> a unique internal cursor.
>>
>> I'm not really sure 'mutable' means anything either.
>> It is possible to make it valid for the loop body (or even other threads)
>> to delete arbitrary list items - but that needs significant extra overheads.
>>
>> It might be worth doing something that doesn't need the extra variable,
>> but there is little point doing all the churn just to rename things.
>>
>>>
>>> This makes call sites that only mutate the list through the current entry
>>> less noisy, while keeping the existing *_safe() helpers available for
>>> compatibility.
>>>
>>> Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
>>> ---
>>>  include/linux/list.h | 269 +++++++++++++++++++++++++++++++++++++------
>>>  1 file changed, 231 insertions(+), 38 deletions(-)
>>>
>>> diff --git a/include/linux/list.h b/include/linux/list.h
>>> index 09d979976b3b..1081def7cea9 100644
>>> --- a/include/linux/list.h
>>> +++ b/include/linux/list.h
>>> @@ -7,6 +7,7 @@
>>>  #include <linux/stddef.h>
>>>  #include <linux/poison.h>
>>>  #include <linux/const.h>
>>> +#include <linux/args.h>
>>>  
>>>  #include <asm/barrier.h>
>>>  
>>> @@ -763,28 +764,72 @@ static inline void list_splice_tail_init(struct list_head *list,
>>>  #define list_for_each_prev(pos, head) \
>>>  	for (pos = (head)->prev; !list_is_head(pos, (head)); pos = pos->prev)
>>>  
>>> -/**
>>> - * list_for_each_safe - iterate over a list safe against removal of list entry
>>> - * @pos:	the &struct list_head to use as a loop cursor.
>>> - * @n:		another &struct list_head to use as temporary storage
>>> - * @head:	the head for your list.
>>> +/*
>>> + * list_for_each_safe is an old interface, use list_for_each_mutable instead.
>>>   */
>>>  #define list_for_each_safe(pos, n, head) \
>>>  	for (pos = (head)->next, n = pos->next; \
>>>  	     !list_is_head(pos, (head)); \
>>>  	     pos = n, n = pos->next)
>>>  
>>> +#define __list_for_each_mutable_internal(pos, tmp, head)		\
>>> +	for (typeof(pos) tmp = (pos = (head)->next)->next;		\
>>
>> Use auto
>>
>>> +	     !list_is_head(pos, (head));				\
>>> +	     pos = tmp, tmp = pos->next)
>>> +
>>> +#define __list_for_each_mutable1(pos, head)				\
>>> +	__list_for_each_mutable_internal(pos, __UNIQUE_ID(next), head)
>>> +
>>> +#define __list_for_each_mutable2(pos, next, head)			\
>>> +	list_for_each_safe(pos, next, head)
>>> +
>>>  /**
>>> - * list_for_each_prev_safe - iterate over a list backwards safe against removal of list entry
>>> + * list_for_each_mutable - iterate over a list safe against entry removal
>>>   * @pos:	the &struct list_head to use as a loop cursor.
>>> - * @n:		another &struct list_head to use as temporary storage
>>> - * @head:	the head for your list.
>>> + * @...:	either (head) or (next, head)
>>> + *
>>> + * next:	another &struct list_head to use as optional temporary storage.
>>> + *		The temporary cursor is internal unless explicitly supplied by
>>> + *		the caller.
>>> + * head:	the head for your list.
>>> + */
>>> +#define list_for_each_mutable(pos, ...)					\
>>> +	CONCATENATE(__list_for_each_mutable, COUNT_ARGS(__VA_ARGS__))	\
>>> +		(pos, __VA_ARGS__)
>>
>> The variable argument count logic really just slows down compilation.
>> Maybe there aren't enough copies of this code to make that significant.
>> But just because you can do it doesn't mean it is a gooD idea.
>> I'm also not sure it really adds anything to the readability.
>>
>> And, it you are going to make the middle argument optional there is
>> no need to change the macro name.
> 
> Christian König and Jani Nikula also disagree with the variadic-argument
> implementation approach. If we abandon that method, it means we will
> inevitably need to add some new macros. If mutable is not a good name,
> suggestions for better alternatives would be welcome; coming up with a
> suitable name is indeed rather tricky.

I don't think you need to add a new macro for the specific use case that people want to modify the next element of the iteration.

If I remember your numbers correctly that is a really corner case and keeping using the existing *_safe() macros for that sounds perfectly fine to me.

Regards,
Christian.

