Return-Path: <io-uring+bounces-12103-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kPdkDl3niWmdDwAAu9opvQ
	(envelope-from <io-uring+bounces-12103-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 09 Feb 2026 14:55:41 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 9665A10FEBB
	for <lists+io-uring@lfdr.de>; Mon, 09 Feb 2026 14:55:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 22E7530078C8
	for <lists+io-uring@lfdr.de>; Mon,  9 Feb 2026 13:55:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 703BF3793DD;
	Mon,  9 Feb 2026 13:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="wXDzlVcV"
X-Original-To: io-uring@vger.kernel.org
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013050.outbound.protection.outlook.com [40.93.196.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FF9B2264DC;
	Mon,  9 Feb 2026 13:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770645338; cv=fail; b=seE5gwlp9KUHmWVzaR61aXqnDKqIZx/IsMkIoj5XnhqbMmyjwEBQa0FmD4+9Xop0joNwZagPAoInUk4tbX1criFfCTyMrxri4QSUsIAjay8h18IBhTcXGmgnAvAWIr3wuxMZYrW/Tc3AKg95E+yZqXm6+p5jWMK0Vr+XF2L+dqs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770645338; c=relaxed/simple;
	bh=KX1dg+6gJcHfZhbIQHal9hOQQU2GE+ez2GzDcverZCI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=jJxZKdijARpWS/RcMIT7vSP5C/fpn4nO3lO23xlPYK/4GplKT38noL8G3cOQT13OOPFcvRvuBB1sNKfU8AZuZEzT79vrfj8C6WFVX47zNhphByv2iEmztoyoHZ99OY/p92u1fXjUprlPHOE8fETxfcNic3AnnwlMUPXLNuNi5jA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=wXDzlVcV; arc=fail smtp.client-ip=40.93.196.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=g7E+YCNI4kZTW10HB+EfwaEXH0S7VR7LDMed8lDC+JQCFdpMvcsTIkVIQPoRchDwEt3bFbtb5rhgTZNEVfqfDhPi3NU5eDpFxw80BG6sHU1KVJtK0E8xhb93FgY8U/xU+tn1bZp2cHX2UQhExCUCMTGOP6idgFeacQJJYcNU1cO0l2SPfsKP+9c98c2z9nIGyOrIICVeJmxRBc+wphS+LeWywF/qqh/BYTHmcsUzX4BzYE5ugNHZDVPdxbyKL/SJV4q7RU4lv3HDG9PDzQWW9+2RsXub7ODVkk3aq/Me1mcZ6BM5OdnLtOY5oC57pLzbW9ydDuht9JEd6OfR8avupw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rgV6NNpG6DQWpiasCoqdENoM/qkr0MMgIl94vQ9jqzs=;
 b=F++Hjac1SnW2mjb7pQCCk3mAawivytg5OVyvSwA0DGw+stJnT342+qOFrGKmzGwzAMU/wEUeh01VH2ZkV0FKxAyk3aS3bziG0/OeQs797fBD9zsn7dX/kzXuemXifIB1bBC2cx3NLfD2NuuqoUzWlWGvtTugYh961MldTKCOwYB/wpxkelbS98MNMaeqlDq01XqOdempTAQlwXFoRylOXHA04QyWuPzOmm9NY/Vh6xsqn2dzkU4Y+CnBhQjt9ZLBtMSAgbaXDYa3GxdlunDJrAA6Hhq+FoflNG1Wv25Oy0YlaI6OR7WBg3l1h+aG8TB7blzSp4EgVhNAvl5qsqj/8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rgV6NNpG6DQWpiasCoqdENoM/qkr0MMgIl94vQ9jqzs=;
 b=wXDzlVcVNurKXmI6SG/zJxTyBDm+Eb9h6YkHbiPQuC9PpWhzQB2m6t4aVJCgd3GY4oivU7K8CsmVCzrsYnyDXZSYE9nurCb1VXJM0Yrl+YvvjPQwuigYG/7H0CjRWUFhX6VWWoT5po5g8mpMdTTi70Mc7jiHn/kLLj01PaZ8Hv8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB5685.namprd12.prod.outlook.com (2603:10b6:510:13c::22)
 by DM4PR12MB7720.namprd12.prod.outlook.com (2603:10b6:8:100::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.16; Mon, 9 Feb
 2026 13:55:31 +0000
Received: from PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c]) by PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c%5]) with mapi id 15.20.9587.017; Mon, 9 Feb 2026
 13:55:31 +0000
Message-ID: <9020b3cb-42e1-4c14-a748-c9a392d6f0be@amd.com>
Date: Mon, 9 Feb 2026 14:55:26 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [LSF/MM/BPF TOPIC] dmabuf backed read/write
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Pavel Begunkov <asml.silence@gmail.com>, linux-block@vger.kernel.org,
 io-uring <io-uring@vger.kernel.org>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 "Gohad, Tushar" <tushar.gohad@intel.com>, Christoph Hellwig <hch@lst.de>,
 Kanchan Joshi <joshi.k@samsung.com>, Anuj Gupta <anuj20.g@samsung.com>,
 Nitesh Shetty <nj.shetty@samsung.com>,
 "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>
References: <20260205174135.GA444713@nvidia.com>
 <dbcc2912-e1df-491d-b1e0-7812279297de@gmail.com>
 <20260205235647.GA4177530@nvidia.com>
 <3281a845-a1b8-468c-a528-b9f6003cddea@gmail.com>
 <20260206152041.GA1874040@nvidia.com>
 <df7fe4d7-ca28-408e-bed3-bd1fa23e7588@gmail.com>
 <20260206183756.GB1874040@nvidia.com>
 <4736af5c-4bf8-4e9b-8f82-4b89a75d2cdb@gmail.com>
 <20260209130607.GF1874040@nvidia.com>
 <6246cc2b-0d6e-4062-ac24-74c7148dc47d@amd.com>
 <20260209132417.GA3076640@nvidia.com>
Content-Language: en-US
From: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
In-Reply-To: <20260209132417.GA3076640@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR2P281CA0072.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9a::11) To PH7PR12MB5685.namprd12.prod.outlook.com
 (2603:10b6:510:13c::22)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5685:EE_|DM4PR12MB7720:EE_
X-MS-Office365-Filtering-Correlation-Id: f19112f2-8a52-4419-720a-08de67e2e39f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aHhGSExuSkJyZlhNVi9BMlZFLzIvSHdxTFErYjlNYno3OGNSVTFncnhGZ29x?=
 =?utf-8?B?Q3BucmRYWUNlckxiMUs4T29VeWJZMUI5YTZFT2NaZS9SR2g4VWFCMG5hRnJS?=
 =?utf-8?B?WENJNHZzbXhvZmNNMWR6bWc3VjNKMitybmQ0UWlnQURhQ0JoWU54cXZDZ05O?=
 =?utf-8?B?Vlg3aG5sRFQ3TmhUSU5YUXVOOXFiY1JodUUzbTdORVVtSm9ocmJXYmlML1Nu?=
 =?utf-8?B?K0JZdkkxdmdKU2Y4aldpRmJkVjVxUEllQXBuSklUaUNoVGVhUVpFb1dwMHF2?=
 =?utf-8?B?ZGcrazF3WDRlb2oyR2N3Tytobm03eHl6dkZxdXNFOWFGanFpN3EzTW9LS2Jm?=
 =?utf-8?B?dGFob3dyek9yMXBSQjRDVkhFdGJ0MUQ4RjVyVGl3Z2hUbmhqUHVnZlJWeWVx?=
 =?utf-8?B?TXRUeUs2LzNJeW1PYTl1SjJzQWIxTDU5Mml3dE5TM0RoclJoMDl2YWoyKzlT?=
 =?utf-8?B?c0dhWGVVeDIrdWpIbUNoS3RXcmFod3ZqaEtGK1d4SFJweER6UmMvRW42SmRW?=
 =?utf-8?B?cm03a0NobGltbGFNcm90anJmQUpTQlNPRGY0R2FmSHI3Y1BsdFVrYUYyaUpk?=
 =?utf-8?B?dTVLRVBlYzdibzNDT0lyR3dMM1o0MEZoN2lJcjFwSm1hSmFJLy9pMStZaEtX?=
 =?utf-8?B?S2FFWE0zc3pjYTNUR3B2MjhZdS9wVTlsNUduWVhjKzVld2lXOTR2UzEza2Vy?=
 =?utf-8?B?TFh4N1o0L2RYeWhmenZSaDllMUFwQ2pUeWVBcG1FTS9pajBUVUxIYWFmUm5L?=
 =?utf-8?B?QUtHRm9odjg1TjE4UFFVamw2dmIxaGt0c2wxMWFWUUVpQlltdUxHNHJ1LzMw?=
 =?utf-8?B?aE1ibFl6WUhiY2ZGNkNlM09SZUprK1NzRWdHcTNUYnlCYVpTbFlHWkN3eTZy?=
 =?utf-8?B?RlNONTNCbTVndXpVZmJwcEh1cCtNM1hRYWdqTEYxUHlyVnU1UUFtYVlNMWxk?=
 =?utf-8?B?S0NXMkhOMlR6V3hnTnBrblhIQVY2d1BJK0Z0TktFZEF4ekhjTWFoaUp1ZDQw?=
 =?utf-8?B?S2UrbmRJMVhxRnBlc0tQekRROXQyRy93RElDckk1QXRtOHZ3eG1TNlgvcUFD?=
 =?utf-8?B?a1dOM0F6cnRZR3NzVHoxMVRvT0JsS1dkYUZJUVJ6aEZ6VjFVNzAyczZzNzdJ?=
 =?utf-8?B?aFpaODRXd2RKakJ0cHlUTWFEZ2ZVc1gvR3NFWU8wd3JBNGZUalFqa3FxVHBS?=
 =?utf-8?B?SnllUnRqajBoUGI0VHBaQ0hxZUxtRUxaQ2hKWDdjMTJBNVE4ZmplcmpiT2c2?=
 =?utf-8?B?NnZDdjYzY2VITStlUlFnUjJ5SkttaUVkWEgySDl0UFc2TDIvMHZGdVhOTjcx?=
 =?utf-8?B?NXpYczU5WjBTNGdYQXRCckRjUE5qQkh4U0RoYzkyQlg1dzRjQmVzNzZHQW4x?=
 =?utf-8?B?Mm5NMGFsVWQwTGlZUzFYVndFeGM2TzJrMURyd084L0NxRy9Ob1kvVkE2anBH?=
 =?utf-8?B?Y3F0UVhQL3cvUE5Gd0NTTzRlSzZycFVraHQ3THEyelpmelh6NFVGY2xJYlJ6?=
 =?utf-8?B?Qm14eHVLenBJeS9tbkJkNUxoaEhuUzRhTWtGK2VwN0doM2F3Y05RTWcvOHhE?=
 =?utf-8?B?ZUYwbXFLSmdsY2w4ZkVJSzBTRDZtOTJ1WFRRcVY3VUZRVVg3dktBN0NnOVVy?=
 =?utf-8?B?QUJSblNOMTNmL3QrRkVXTG54SjdaZGw1eXM4bWVFbVpaSWZWYzVBT3VxZVVo?=
 =?utf-8?B?T3ZobE5nRGY1bVI3Q0NyaDcxQjF6MWZPL0Znb0NBNGhWRGJXL0QwMUhYemxQ?=
 =?utf-8?B?Ulh3VEpRaTdWWUozN2ZBTXltQW5YUWhpR2VmSFpENHlrUUd1NGo5dmo3V3F4?=
 =?utf-8?B?OG52bHZ1UXF6blRQbnZUOVgySzJkUVJtNzAvT3dpL0RzckJBZlhpY1hINFhL?=
 =?utf-8?B?OFJrTVEzUzBkMEgxL1RVbWQ0dWN1TGZBUlNMMTVrY09xNTFDTWtkajBzMFpo?=
 =?utf-8?B?L0lObThGelF5WXh6dElkeWJzWVNudWhBUFBnaE5PSGZaOUZWMDJiNEhWeUQ0?=
 =?utf-8?B?bFVxK1ZySFFwbVFyRk00Nk9LOUJDTDB0RnlVTXAxNVU2RGpEcWhtVjhmbFpF?=
 =?utf-8?B?WVF4MHlKUDNyOFVsRGtkZi94anJTQ1FseEhub2tIUUg0SFlDbjd3NDdyMHcx?=
 =?utf-8?Q?YkP8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5685.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NUtXSnNFZUxBdU9BdVEvN1ViVTBBa3RBbHIyOG9FVU80WDBUZnFXdEF5T2hN?=
 =?utf-8?B?ZGFobVgrbm40djNvcVVpdHJEOG9vcmVWQ1VpeWlNVFhUZ1lmWnpQQVVxQXlQ?=
 =?utf-8?B?TndTY1JaM1M3ZFdPRUFHN3pCVUNDbEozZFVUMHdUQUVvQjNsRDJLNVlRMm9x?=
 =?utf-8?B?bTl5RzNRRlZOL1NDVkJHa3QyaDIxc3E3Q3Yrd1NObUV5WXhrQnhtOEJjRDIr?=
 =?utf-8?B?c2hQZkZuLzRWOWhCdTgzWVVGWDdubUM2ampvL2VUemZ2OVE2UkJLRFBsQzI2?=
 =?utf-8?B?YWdwRElqb0tBQ3Bqb3pRYXJYczVJUHlwcGNmWWNIOUI4VkZ3UGdWcHJRd0x3?=
 =?utf-8?B?U3o3M3BnRVhGTFl2REk5Szdiejk5UnAybEFDZTVEWFdHNEQwRG92QXRCdkND?=
 =?utf-8?B?Q3NzU2YvT1c5Q2pVTkxmUFA1eTA0QlQxZndWY3lzSVVRZEFRMUFvYzQzZVdB?=
 =?utf-8?B?Wk1SYThQOW1RYW5GcWxSMnQ0eWF2Y1ZxejBGMmtpR1dYNnpkbHdsS1Jnc0U3?=
 =?utf-8?B?K082RDdSTUQ3QU1YcGNvN3RrMnhJZmhhTVhNdVBxcDVNRUZ5ZFJQQnFvOUkx?=
 =?utf-8?B?cVo3M1dSaVVaOC90STBSOHFLdjdQenNoekZmVll6ZzQvRXFkRmIxSkZHUm1p?=
 =?utf-8?B?S2k0TElGMzdLdHNBUGQwQllYYlFVSy9DK3BPZkZvRkhjazMyaGMwVFZ5Uk5j?=
 =?utf-8?B?dk1TQkJCZ3FBL2xGQ2pjNll3b3lSaEY4SDN3UXJPR0orZGtmcjdOcmhtY2p2?=
 =?utf-8?B?UlFsVXpGeUJMcitab1h2WDJ4b3BmcFdUS1BNOCt0blBIelJhNDBCVk5wa21L?=
 =?utf-8?B?aDcxTURiWGFPWWRobWRwZFNNa0hOUGYrTlZOOU01OGRTV2psYzdGbEswRkd3?=
 =?utf-8?B?b1gyM3h6L1UxYmF2amlSTmZKdDFQSi83ckpyMmcxbG12SGVKazV6UW8ydm5w?=
 =?utf-8?B?WVZxQ2tjMitlOG1LMXM1YURyQ2IvUXNTczYyY1h5RSszZU9oS1ZXR1NtQVE2?=
 =?utf-8?B?bFJQNy9tNUF3TWduS0grc2tJRy9Nbk5yM1o5NTZ2UlpyZURXTTk4by9RckYz?=
 =?utf-8?B?YTNsNjdVd1JyVitYLzB6TkVJdGZMdXYzeWh5VkwzdHVVTzY1aHpaTnlSZVZ3?=
 =?utf-8?B?VFJtZmFFRVdMOUxHOGEzcTN0bU5tYzNmQnZVNzVFNWo1Y1VGcEsrMitmZTdn?=
 =?utf-8?B?RW11VEUvNS9wZkdaVWh0Sy9kc2ZGbGsxNlNKdTF3R05iMXR6bXUzcFV5SkRZ?=
 =?utf-8?B?KzFpamZ2QVRhV3VmQWdFcUwveUY0TWRpYzN5RVhKakhJbU1mdFRoNVF3dnNl?=
 =?utf-8?B?TnVsMnpKRmwybWEzVTNOd1VlNkxRZGdFc0tqdUFHbnlLcklpRzRUakpjYVBq?=
 =?utf-8?B?bmhLMnJudE82NS84OHVtN3hJQ3NhbnVJOEh3REM4c3E4Ni9rR01nY2lnaHlP?=
 =?utf-8?B?QnRQRnI4ZVhCcEZLVXloZnRqbzEveFl1ZldYeU0raXRhdUlRNFo5OTE0TFNX?=
 =?utf-8?B?aFJMcDZjemlMTlE2ZGN1cnVjVjk2UmtScjZubWg4U3JxNnBUSHIzREJhbTJT?=
 =?utf-8?B?MDk1VmcvWVlTTXQrVVRNdmVRRjEzWUJhR0ZsTUgwL3VpU1ZLVmEwWTBkL0lO?=
 =?utf-8?B?VHkzeURaOUkxaUx3Q0VxZkdGSE5VTEpGZmFOQUdlZ0ZOVjVneDQya2Y0QVVt?=
 =?utf-8?B?N2o0eW1sbFdQSmlmd1JiN1dFYjVGOFhRQ00wVzhDT1N1V2xDaDRsbkEvTys2?=
 =?utf-8?B?cVVIY21sekJCUkd3aHBnVngxQVEzYkR6QlVGdVRmTVZPUGFHRUtvWWVueFoy?=
 =?utf-8?B?WXJpN010YnpXK3RSRHhyYmhoWnJ6WUN0RjJPckViM3FlSExtRjhYd0FJcXVq?=
 =?utf-8?B?Wkh2NUNnVWc1Vkl6SllGbk9aWEFMTllCN0VJS2Ryak05TFFRKzVDdFRJNXNR?=
 =?utf-8?B?VTQwdldxQUZxbEJyYStPOGtGTlRjZHBwMGRRMHJoZlpuOVV2WjVuV1FJTkZ4?=
 =?utf-8?B?T1JRRlNyZFNrTmR2OVA3V3picFAycU40bmhiM2tHQjVsUFZSZTVrOFY4dmRN?=
 =?utf-8?B?STFnZ2E4Z1JHM0NNRFNkTGw0SlFjN3Z6Q1JDUXJNbXpUc1g5ZERDZ0NpbE1O?=
 =?utf-8?B?bVdQSHVGU0VUVWhKQVJKQ1JQQVkxZ3dRMnZuRWUxbi96bWlXajhwTHpkYkcv?=
 =?utf-8?B?TTBEY21hS0xlNnU0c1ZvY2hVa1RGalhGYzFhWDdUNFBHTzFmT1ArZ3NCUlZo?=
 =?utf-8?B?VGEwN1NUYmRLUmdLengxOUFMVzB5NVkvTk4vMDBiYXNiQXhSdzNFNUloeDhX?=
 =?utf-8?Q?hNB9dTOLVWkP5CuXoL?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f19112f2-8a52-4419-720a-08de67e2e39f
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5685.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2026 13:55:31.5307
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T1NZWLisguXvEDvDv//tKiLh44bw//kaFS3TMlVUXkhSlADEm2TAl3D7Vr/idD9u
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7720
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.34 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-12103-lists,io-uring=lfdr.de];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org,lists.infradead.org,intel.com,lst.de,samsung.com,lists.linux-foundation.org];
	RCVD_TLS_LAST(0.00)[];
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
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[amd.com:mid,amd.com:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 9665A10FEBB
X-Rspamd-Action: no action

On 2/9/26 14:24, Jason Gunthorpe wrote:
> On Mon, Feb 09, 2026 at 02:09:24PM +0100, Christian König wrote:
> 
>> We have exercised and discussed this in absolutely detail and it is
>> not going to fly anywhere.
> 
> Yes, I understand you concerns with struct page from past abuses.
>  
>> The struct page based approach in fundamentally incompatible with
>> driver managed exporters.
> 
> The *general* struct page system is incompatible - but that is not
> what I'm suggesting. I'm suggesting io_uring, and only io_uring could
> use this with it fully implementing all the lifecycle rules that are
> needed.  Including move_notify and fences so that the driver managed
> exporter has no issue.

Yeah, that is basically what everybody currently does with out of tree code.

The problem is that this requires internal knowledge of the exported buffer and how the I/O path is using it.

So to generalize this for upstreaming it would need something like a giant whitelist of exporter/importer combinations which are known to work together and not crash the kernel in surprising and hard to track down ways.

I had this conversation multiple times with both AMD internal as well as external people and just using an exporter specific io_uring (or whatever approach the exporter uses) implementation is just simpler.

> Reworking the block stack to not rely on page is also a good path, but
> probably alot harder. :\

Yeah, that would be really really nice to have and the latest patches for extending the struct file stuff actually looked quite promising.

Christian.

> 
> Jason


