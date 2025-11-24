Return-Path: <io-uring+bounces-10751-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id BEBEBC7FE90
	for <lists+io-uring@lfdr.de>; Mon, 24 Nov 2025 11:33:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 43996344CAB
	for <lists+io-uring@lfdr.de>; Mon, 24 Nov 2025 10:33:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABAF820125F;
	Mon, 24 Nov 2025 10:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="TXW9wUFP"
X-Original-To: io-uring@vger.kernel.org
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012059.outbound.protection.outlook.com [52.101.48.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0270F1D555;
	Mon, 24 Nov 2025 10:33:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763980393; cv=fail; b=uFApqat8bWEFLwXXeK1Cs03VeK+EoXDqxymOqkTq1/K8o0NBWSiHcL+bA6OPWu37UH2aEW6Gh1fhC+Xa6UnhB/db/NzOQBGZBBc3tYv28kzQrVVif0wl2CiIt1LsjaNgzzTd5x+ZWjrEY+d00kHveY/cXA6Ap/LXNMijHVm2kLs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763980393; c=relaxed/simple;
	bh=NNYdhrYXulG0q8r9kjP/RK7/TUjg3n4XDFQfRf4svM0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=GXly4OYzuIi0xznojK0J94/XPNLL4J0w8MEjOMeNzJJojPNtyRPiQXqxe8YXASoB1YkCzJVTQFmnEi7+JStThlUyt/+smsZGXA8Gbb2BjBoq//8+W3nqJoV5zhegEq3DCYqSg4yQLCufDZO4GSYFJEL/fFseqL8bH9MQlB+cueU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=TXW9wUFP; arc=fail smtp.client-ip=52.101.48.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qnOlXKSfloUY0xYMgW0W+oxzXa6sUIb2h1FHpwqvi6Ol/HPpsthULFLG9vQgYyeHMSkDYouZYHciw/6fEpscpnbszZbtJC0QwA1hozTZcRA+BvgSmLF6k75w/qopDGtm4Mi0kqM2g7fbpAyHEI8+Bq9LC9b0CCCzLsyCN232wYqivQi6MXN/c33pQ9zE+xNoryONLvFfOtQPPy3fFsCKmGRPZ6Fo0cJvjyLXQvvys1YPg9110NrMBtnSoY/84PzRB63j9TH8yI1lstWPvISEZ19e1sJ7ISkAAOe1aK8BaOTu0yZxY6O84STSDujlkX83orrWg4p4qxrb8TDPb112zQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gLu4irSg1OoQhtnCzTWt7TxaharY3fiK+9cCnHhBvwM=;
 b=pUv+WJW3/GdNJKvTmfhcXXn4ho7POmBDRP88OMGnbMWGjo0OvRJo7OeAiv2tbRC6RWkjhJK3ZBQGD+xOk4nGnkZBZtG1cknbrbhsFoGKOKECt/YF8jw6f68mPAOxJ8fB6GbGB3F8fvokG12asLc5kgzpMaYKCKJynqrsb8Ro7C65lLxSpBn9/pbVmM/jpJPXC2T+dFoPt3PEQUpFmDPZ/xLuQH7tGneWF0qofrD3DBZjGZFoxqLRiweRvPZ7SeL5pt+kfhhh0KU1yPHeeXzZSxzMt09l6GX86MI9wg6rhNM0iFX4lw02DNwcUnhYFWKvAWKpVbRgJyLOqm1mjpoyfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gLu4irSg1OoQhtnCzTWt7TxaharY3fiK+9cCnHhBvwM=;
 b=TXW9wUFPbpv7llj+6BTYuQHcpmyyuI6dgucKbXCAPfn28dLqy07FJZnvvbe87hIpw4mqbVePbpvxkyZrn+qAZnU5mg7BueL2DSkfv8LZMI+GrVZXzZLBMsfsl3d/kH36XrYFGHDDmsM3F1vLvtNakLPD+NS6vaxPsdJy8hVKDbY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB5685.namprd12.prod.outlook.com (2603:10b6:510:13c::22)
 by SJ0PR12MB6965.namprd12.prod.outlook.com (2603:10b6:a03:448::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.16; Mon, 24 Nov
 2025 10:33:09 +0000
Received: from PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::46fb:96f2:7667:7ca5]) by PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::46fb:96f2:7667:7ca5%4]) with mapi id 15.20.9343.016; Mon, 24 Nov 2025
 10:33:09 +0000
Message-ID: <fd10fe48-f278-4ed0-b96b-c4f5a91b7f95@amd.com>
Date: Mon, 24 Nov 2025 11:33:03 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC v2 00/11] Add dmabuf read/write via io_uring
To: Pavel Begunkov <asml.silence@gmail.com>, linux-block@vger.kernel.org,
 io-uring@vger.kernel.org
Cc: Vishal Verma <vishal1.verma@intel.com>, tushar.gohad@intel.com,
 Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Sumit Semwal <sumit.semwal@linaro.org>, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
 linaro-mm-sig@lists.linaro.org
References: <cover.1763725387.git.asml.silence@gmail.com>
Content-Language: en-US
From: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
In-Reply-To: <cover.1763725387.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0227.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:e9::8) To PH7PR12MB5685.namprd12.prod.outlook.com
 (2603:10b6:510:13c::22)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5685:EE_|SJ0PR12MB6965:EE_
X-MS-Office365-Filtering-Correlation-Id: effa3041-69f7-482c-2ae2-08de2b44dcc5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NjdCYnlOd25HZG9kVTlQc3hmOU0xU29sVVNReVJHOWVrNlgvQlV3MWRZWnJW?=
 =?utf-8?B?dElLbjNwT0RyT0ZRTkZwMlUzYk1nYU9nMVRmSVpYZUNXMEpmcVpOd3ZSSmxx?=
 =?utf-8?B?SjVNeURmUk9vU1h5ZnRVbWJyWGdwS0liaFppWWtYTm50ZE5tWFJXMmhXZ09B?=
 =?utf-8?B?dFZhYzFLbVZ6L2RTaXFmeStIYzNxVGg4QUhYVDF1bExEMDk5ZXVCZ29HSUxW?=
 =?utf-8?B?bVNMd2dTRUNuazlhaVpWKy9YM24rRlNLb3AzRHBwUWgxaE4yRjdIMjF5L2dv?=
 =?utf-8?B?WU5zTzVaclhuSUNuSXFNYmltQTJRV0tMTjNzU1NhTHZ2MjJ5N244Y2Mxdjh2?=
 =?utf-8?B?K0ozNFJFQWNxLy9NUWdvTUU3SUliYUxFM0MzdUFVL0FmQ29ML1hPTnVWd2lN?=
 =?utf-8?B?bVRINDNzY3BienZNZTNsdU1JSDFHS08yS3NOdytXTml3ZTMzRHBUU1o1d3Jx?=
 =?utf-8?B?YkpjUXNkUDNNMm16aU1hWTc4bWdmUmlsU3hxZ29lMVRFdGxPckZYcDh1UE03?=
 =?utf-8?B?azdvVlB0Q0tJV2ZXVDIxZndiWG5TcEt4TStDb2NMbys0R0N2VitKTFRGZ1lv?=
 =?utf-8?B?Y0dkamx1RDNqbHRNV1lIaWRONFZhMW9Wc3RWM1BlMSttZUloRFN1SlIvK0xP?=
 =?utf-8?B?VCtwbEQ1c0tZRHZZRDZrTkpEM1NlUjdBSk5GaW5kTTJxd2dtVTVSTG1UN2VX?=
 =?utf-8?B?TG04S0l0ajkzYStYMjdTdTZ3d0NpdjRPSlBZQ1VQUDJLb0g4d2VoUlRZZUJ2?=
 =?utf-8?B?elRYOURzdnlpemp2NTNNNFpDTFZDeStGRGpaMHV0dEQ1Wk16YlBDUUpYaksr?=
 =?utf-8?B?bXpBQTRQUm5lRnFDZW9yODhqeFozOHNsaTNiYW1qcVBobWZaQXZKbm12V2Ex?=
 =?utf-8?B?VFVTVWsyLzJGOGhySVZIY3RtdFgzTUZtVzdUeGd4WlhLNGtKRnBWU0Mvd1Fv?=
 =?utf-8?B?NDlHcHl2V0U5WElWL2ducDVLcWFadk9LcVN3ZFV4NXRUQTJEVUNWS1psRWVm?=
 =?utf-8?B?eG4vQU9JenpQajhyUW0zbWxRcExaT2lqeDIwVzhqcjhsUnJGcWN3NnRRNjRB?=
 =?utf-8?B?TFovQUZTcExzb0hMUmkxMjZnTzhRbFdFb2FwWi9GZHc3ZS8vUU0rVm1iZlRP?=
 =?utf-8?B?aXRsSXprL2tkb3oydHFXb0RmdERjOWFRdzI1RHRZUGlPSFBvOWhpRjlzRm5y?=
 =?utf-8?B?WE9aVkhOSDJCbnlKRmVSRW1TRHpkb3kveWVKV0ppYXg2SFZ3OXhnSnRMTjRs?=
 =?utf-8?B?QURxK2doSXZLOUdlak5tNTJSS1RCY0RaYjFiMVE5MlpMc3cveElDck1kTFdu?=
 =?utf-8?B?Mmk2UmJ6L2VLenhIOUl0SDdXNm16cVRYSWVnTUhPdUhmWHhRZUU1WmxjSU5N?=
 =?utf-8?B?bkFjalk4WUU0d25jYmtiWURkdk51blRLQ1dVSkRzZVN0VEpEMERyNWNDcmtv?=
 =?utf-8?B?V2VFZWJXU0ZxZ01tbjAvN1FDUHFjdCsrbmVIV1lTZ0FpOWlvL2d4Q1kzT2pk?=
 =?utf-8?B?VXdHMjBqUVhJQmtBT2x6STFQUG15V2JQUnhMNWtBQ1d4bEpRZ2RCVmFEaUFD?=
 =?utf-8?B?Y2hmbE0xZklhZ3daUkhLL0VnSFdaZDZuTlprQU5ub2k1YnZvSWpTZURTRncr?=
 =?utf-8?B?YW9NSUNzUHRYM1RWRFBSRU5FTEFseVNFYzJneEdVamVyNUNVUXIvMnQveGNK?=
 =?utf-8?B?dmlzOEwzZGNBeGlIN2p0bkdmMDZkbmIxSnY0ZkQreFEyclF1VDQ3NXcyMkIy?=
 =?utf-8?B?VnZCS2tvYXdVbE95ZlFBdlFRYnVHbWJ6Um1USVIwSHRwdkpXR083UjlJODI3?=
 =?utf-8?B?b1l6MTRNa0srTVViSmVoWFVBdmJCYmhTSmlBWXlETEd2Unlia1FVU0w3N05i?=
 =?utf-8?B?Z1RQZFV3dmZrK3dPanZNSTRJVnJpdzhZUmdwdzQ3b3dxa04vcHpiNTI3Nzdq?=
 =?utf-8?B?NVFDWndZK01FQVJVbkF2ckgrRWlzOEtiMmpFOUhjMmpveWlIcERqbGVRMkh2?=
 =?utf-8?B?bjhDSVN1azFRPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5685.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cEk2eENwT24rQWw1Z3c2UDhMWFJSM01qZHlrZGVSR1g0TzBNVWpvMkk4SzNU?=
 =?utf-8?B?bXNwdFBKbFVENC9YQlAzRm1MMUtNa29wZnp6bThKUU1ab3VsR1lnRnNBUHZC?=
 =?utf-8?B?enhMZ2tMSkcveFY3dFVObDEvbVptVkduTVRuME5XWTZIVVZkbHRqZWtHb2hy?=
 =?utf-8?B?azVsWXhXaVRVNEt4ZnorSmFoT3VuUWRFTGllS2JSN0tGNStYRXZlMDN6bHJt?=
 =?utf-8?B?c1BQTFI5RDd6YnFuVGNEWFdJM2xqck5DZHB3a2N1ZXZKekExUTBlWnZ5Q2Zs?=
 =?utf-8?B?c2h6N1lMTWlveDFyeUVralBPejBmc2xQc1BsS3ZSYnhhOHduM055UEttWWpo?=
 =?utf-8?B?WURNL1cxb1hhQ3V4TzlsaHJXVDVSV2ZTdC9Vamt0YlkwWjJ0KzBId0R3eHZH?=
 =?utf-8?B?WWVtdmhrK3JHMjE0eVQ0cjVnZGhaWWhKZ2JKUmF1bjZmYmVXWkNvcGQ2dkRD?=
 =?utf-8?B?TVRLR01BUzlVN1ZSWFZrL2VTczdXem5RbUhFQVdaUERuMVRLVXhoN3hmYjJp?=
 =?utf-8?B?ZjZ2c01hUUtVQ1dhYTNCY2ZmWElIZUVTR1MyVlFUK0NTSHdyV0ErTVpiUUhL?=
 =?utf-8?B?dWtqcUlIcHhJbWp0angvdEpKQzJUV1YyK2JvV01nYmtXVmJLV1Q5S1M4TklT?=
 =?utf-8?B?dWo3dDhqczIzeGEwcmZmOWc0dFhTcWVtZGdxTmpqNmxrZXprUVBSYloxREdL?=
 =?utf-8?B?dmNpNHRiR2t3QXZoL1hBY0VyZU05VXBMZDBkVTRRdE9qMG9lUDg0dXNMMmF0?=
 =?utf-8?B?aHp3WkVHdjd2RGtaZC9OTWFVVWQ4RkNkaldVU3VJMnNqMXFqM0FzbDY5K1N3?=
 =?utf-8?B?TWhQdmcrdXVtaEdqSzdZWHQ0L3BYd2dJd3pvdEQxSzlxTVlZdDB3enpUeTRy?=
 =?utf-8?B?ZnFtTWRsQjRmWDcyOExHY2MxUzk1c0t2dDRxaGcySzU0ckdJaElhU0hNV0ZE?=
 =?utf-8?B?WkNvR1JDS3VlQm5RS3VXdEJ5TmNHMS8rSzJmNlh6QXFxbnRJRlVMNGhjUmtx?=
 =?utf-8?B?dDk2WnBFMnBhMHNMaEljY2VDc1l4U0Y3bXNDend3SERXd3pCakRxZ3pYUHFD?=
 =?utf-8?B?ZVpla1pyNXRpMDN0dXd4TFNpYW1RclNQQWZ0SWMySXlBdGdaTUpEajFSS3dz?=
 =?utf-8?B?Z3dLTzd0SUs3UklzdlVJRlF6ZElrcTVJK3N1YU8zWktTZkwrK29RS3F2bnp3?=
 =?utf-8?B?NjZGcVUweXZCYy9sbnA1dUt6T3NpdUFYYlFTclhKOWdpMEZEbjE1RDhFYW9w?=
 =?utf-8?B?VERyRDBwUWdlOVlYMnd5UjQrc3pkdHcrY0kyS2YzTXpaMjk0WkEyUit2Y0dS?=
 =?utf-8?B?T1JnNk9CK2hMWFZZN1lxc2hkZnJsenRoQ2lmR0p2aUtFUnpvTWcvY0h6aFoy?=
 =?utf-8?B?VjYxTkJKYXY1b1YzTFNDbEIyMzNTK3E5bWpWUUhkREFwbnV3Rjl1akFBa0Rl?=
 =?utf-8?B?SnU0V3pDbVBEWWp1SkN1YnNiZUtTM3ltaTJ6STdrYUJ4YmtNRmpGTFkzVWN2?=
 =?utf-8?B?MHpLd0tGMEpWUE9JdmN3ODVjZnhYbVkzRzFOWFZHZ0Z3TnZrRFh1OWlweGdG?=
 =?utf-8?B?U2d6QTQvaWdSQnpmUEhHOUh0cG1NMnFQTkpjUmphOVZNc2NKaWp0bDFVS0th?=
 =?utf-8?B?QjUvMk9ucmtFMi9GTDE0ZXVmTi8ydE04QjRMb3FDTjVnaG05dEV0OUdzS0Jl?=
 =?utf-8?B?SDd1R1ZVR1pMdTh6cGc1SmhBeWhNOEFqT3d3a2lnc0g4N2VWZlRZaTROQ3dh?=
 =?utf-8?B?cEpqRVVtckxqNUJwbXVFV0pMMG1xdW9PMWNxeE5Sckh6cHZqbmh0T3d4Nmxv?=
 =?utf-8?B?bytzcCt4ak5WRy9STjR2RjFEVnViYkk4UlFVdFZJdEI1NTRQQ05mcys5dTRN?=
 =?utf-8?B?d0VGY2lzcUlsOTlZWmlQRmJRT3NLUldiTUJXQ0VNM0tJSE1VdWozVkRRZmNI?=
 =?utf-8?B?bDVJYXNWa1g2YlFXTFY3bUZuUjFrcE9JNVVOMERFVVFQTi82NytRQjh3cGhr?=
 =?utf-8?B?SktIZHJVa3RrWFRsWTNIS0M5cHRpZm5iZXpSZTVOMHZpZkhiUy83eUVYZ1h5?=
 =?utf-8?B?WS93TGNHNjNaMFg2bS9ueER5TngvUkJ4cDAvTnZBZlJnaitLbHgzcXExTC9t?=
 =?utf-8?Q?NUpE=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: effa3041-69f7-482c-2ae2-08de2b44dcc5
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5685.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2025 10:33:09.6770
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mSWB7wR+DfLSw6vPiOMT2BRhM86EOkrvQ4APoMVYixMuE9AyrAVgwsPVDgQ5mmmC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6965

On 11/23/25 23:51, Pavel Begunkov wrote:
> Picking up the work on supporting dmabuf in the read/write path.

IIRC that work was completely stopped because it violated core dma_fence and DMA-buf rules and after some private discussion was considered not doable in general.

Or am I mixing something up here? Since I don't see any dma_fence implementation at all that might actually be the case.

On the other hand we have direct I/O from DMA-buf working for quite a while, just not upstream and without io_uring support.

Regards,
Christian.

> There
> are two main changes. First, it doesn't pass a dma addresss directly by
> rather wraps it into an opaque structure, which is extended and
> understood by the target driver.
> 
> The second big change is support for dynamic attachments, which added a
> good part of complexity (see Patch 5). I kept the main machinery in nvme
> at first, but move_notify can ask to kill the dma mapping asynchronously,
> and any new IO would need to wait during submission, thus it was moved
> to blk-mq. That also introduced an extra callback layer b/w driver and
> blk-mq.
> 
> There are some rough corners, and I'm not perfectly happy about the
> complexity and layering. For v3 I'll try to move the waiting up in the
> stack to io_uring wrapped into library helpers.
> 
> For now, I'm interested what is the best way to test move_notify? And
> how dma_resv_reserve_fences() errors should be handled in move_notify?
> 
> The uapi didn't change, after registration it looks like a normal
> io_uring registered buffer and can be used as such. Only non-vectored
> fixed reads/writes are allowed. Pseudo code:
> 
> // registration
> reg_buf_idx = 0;
> io_uring_update_buffer(ring, reg_buf_idx, { dma_buf_fd, file_fd });
> 
> // request creation
> io_uring_prep_read_fixed(sqe, file_fd, buffer_offset,
>                          buffer_size, file_offset, reg_buf_idx);
> 
> And as previously, a good bunch of code was taken from Keith's series [1].
> 
> liburing based example:
> 
> git: https://github.com/isilence/liburing.git dmabuf-rw
> link: https://github.com/isilence/liburing/tree/dmabuf-rw
> 
> [1] https://lore.kernel.org/io-uring/20220805162444.3985535-1-kbusch@fb.com/
> 
> Pavel Begunkov (11):
>   file: add callback for pre-mapping dmabuf
>   iov_iter: introduce iter type for pre-registered dma
>   block: move around bio flagging helpers
>   block: introduce dma token backed bio type
>   block: add infra to handle dmabuf tokens
>   nvme-pci: add support for dmabuf reggistration
>   nvme-pci: implement dma_token backed requests
>   io_uring/rsrc: add imu flags
>   io_uring/rsrc: extended reg buffer registration
>   io_uring/rsrc: add dmabuf-backed buffer registeration
>   io_uring/rsrc: implement dmabuf regbuf import
> 
>  block/Makefile                   |   1 +
>  block/bdev.c                     |  14 ++
>  block/bio.c                      |  21 +++
>  block/blk-merge.c                |  23 +++
>  block/blk-mq-dma-token.c         | 236 +++++++++++++++++++++++++++++++
>  block/blk-mq.c                   |  20 +++
>  block/blk.h                      |   3 +-
>  block/fops.c                     |   3 +
>  drivers/nvme/host/pci.c          | 217 ++++++++++++++++++++++++++++
>  include/linux/bio.h              |  49 ++++---
>  include/linux/blk-mq-dma-token.h |  60 ++++++++
>  include/linux/blk-mq.h           |  21 +++
>  include/linux/blk_types.h        |   8 +-
>  include/linux/blkdev.h           |   3 +
>  include/linux/dma_token.h        |  35 +++++
>  include/linux/fs.h               |   4 +
>  include/linux/uio.h              |  10 ++
>  include/uapi/linux/io_uring.h    |  13 +-
>  io_uring/rsrc.c                  | 201 +++++++++++++++++++++++---
>  io_uring/rsrc.h                  |  23 ++-
>  io_uring/rw.c                    |   7 +-
>  lib/iov_iter.c                   |  30 +++-
>  22 files changed, 948 insertions(+), 54 deletions(-)
>  create mode 100644 block/blk-mq-dma-token.c
>  create mode 100644 include/linux/blk-mq-dma-token.h
>  create mode 100644 include/linux/dma_token.h
> 


