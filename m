Return-Path: <io-uring+bounces-13187-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MImbMtXw8mmwvwEAu9opvQ
	(envelope-from <io-uring+bounces-13187-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 30 Apr 2026 08:04:05 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F44E49DD34
	for <lists+io-uring@lfdr.de>; Thu, 30 Apr 2026 08:04:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 98715300CC0F
	for <lists+io-uring@lfdr.de>; Thu, 30 Apr 2026 06:04:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12FBD279917;
	Thu, 30 Apr 2026 06:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="TW/MgvAa"
X-Original-To: io-uring@vger.kernel.org
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012034.outbound.protection.outlook.com [40.107.209.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 946026FC5;
	Thu, 30 Apr 2026 06:04:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.34
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777529043; cv=fail; b=FQyp5ocSQHmYvUoWgMG3eo0D64q4LnQ7fdF10gnYEVUVWKzeSnAYOu4y4a8MGn0x38PBnqjFapgHvyoXddkIT5y1Lcfo0BPJyjEJL4NSA5+O4Mls1O9PwYEvwu3oJuWQyIUo5lEnfvMt75iQ7/SGbgdH27cZKph4YXfk/sVXx/M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777529043; c=relaxed/simple;
	bh=CkE2njFrNxtacYptG+fynN6MRyIdNrD5/EnJGT2DjJk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=UzjtxE6cbKVnSFVnPg0TdeYEKxePYAojeHh+7WThP0DALFg20ycHrKsIUd5dwf0VlJ8w2Hm6kX/N4IzJ5tFhTbm7UCRYFX2vk6wc5fRyDpHAdSBYyGRq/btI2+1snFFeeEEdj1sOEljY9f4l+SB/Ma0Qx2m07mNLRUrE2k0yelk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=TW/MgvAa; arc=fail smtp.client-ip=40.107.209.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ug6UGsZj9ZmQkqE4NOMZEqxby9ocGm3Z+i8r08dK28U2iSDSYc/2Ub3UxZeOcHjZlMp5r4YtdaiMcNrORbhy3dtacdNaL3yakIUTliuIL8tWBp+2QYudXf+8Rl3A5q/QvRwGdOBHBRSlq2Di9M+optVQsupdWCLK1XjuXIEvNOA+F1sSfEwYxgo3d+ox7cZJsqaHK9CCQxyfzIPO95HBQPNPH/khQt44lwUSBSFSTs0FSER+fqHHy5cxz12WpjtRAwuCUplOX4IEHuf/T74jJth84wXMpbkQh5Ibrs/ZlAXHrRK/yXUBsnhoTex9zr0Ka8j5k2wfxnvzyxPWflg6Cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u9lC75TgHXestJFdYXvOH+AE0yP0KFvdVluZb/Y/OiE=;
 b=I/4w+oHrrVQJDpHT7uba8fwpodS0H62dChCJ6mCvqGmW6NC+ble+EzTm3nGVbzuN0dUGqWVjjtl9XC1A6RGjTvNdBxLs0Ulc87C8nyF5EPDNgysN+TF0s+mcnNdvBwP9d8FOWAIZ+4RmFPMVySo05hx8fL8dFebcdIuF1FpGSU8TheeuG8fHa+cNZsEZHs8OCZMnjfjr43/TKHE479wC2mFvmfk1m/SnAqHy69VrzJe9cRny65TaMCFNfRKMMUdqkvaj3oH3zFQ2W4k0pK+dbBOCrbtydN30n9oZSBAuOY+rnNrIdrqlxM0+yP78zT7a0tNxxamVlaSN83N2HfudHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u9lC75TgHXestJFdYXvOH+AE0yP0KFvdVluZb/Y/OiE=;
 b=TW/MgvAaXd8LGMd2f2+Ajkd6zBwA2PAa362uUKmHMqZAIat25VRjd3NNPF612S03JzekszgZDC3eq7gJGkXMw5MET+jCml1o4FJNZPRPxgCw++pzImSo3aheN6YxgEAVGZdL/cpKivTLkHzOkzrf/tzp2rcKOGdvJMsO16EhClU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB5685.namprd12.prod.outlook.com (2603:10b6:510:13c::22)
 by DS7PR12MB8419.namprd12.prod.outlook.com (2603:10b6:8:e9::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.20; Thu, 30 Apr
 2026 06:03:57 +0000
Received: from PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c]) by PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c%5]) with mapi id 15.20.9870.020; Thu, 30 Apr 2026
 06:03:55 +0000
Message-ID: <f0dd8f89-835e-4331-b593-4405ec59f4fe@amd.com>
Date: Thu, 30 Apr 2026 08:03:47 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 01/10] file: add callback for creating long-term dmabuf
 maps
To: Pavel Begunkov <asml.silence@gmail.com>, Jens Axboe <axboe@kernel.dk>,
 Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>,
 Sagi Grimberg <sagi@grimberg.me>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Sumit Semwal <sumit.semwal@linaro.org>, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
 linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
 linaro-mm-sig@lists.linaro.org
Cc: Nitesh Shetty <nj.shetty@samsung.com>, Kanchan Joshi
 <joshi.k@samsung.com>, Anuj Gupta <anuj20.g@samsung.com>,
 Tushar Gohad <tushar.gohad@intel.com>,
 William Power <william.power@intel.com>, Phil Cayton
 <phil.cayton@intel.com>, Jason Gunthorpe <jgg@nvidia.com>
References: <cover.1777475843.git.asml.silence@gmail.com>
 <ae941457cf6cacb9d4c16b6ec904da9ef7fed97f.1777475843.git.asml.silence@gmail.com>
Content-Language: en-US
From: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
In-Reply-To: <ae941457cf6cacb9d4c16b6ec904da9ef7fed97f.1777475843.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0162.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b3::9) To PH7PR12MB5685.namprd12.prod.outlook.com
 (2603:10b6:510:13c::22)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5685:EE_|DS7PR12MB8419:EE_
X-MS-Office365-Filtering-Correlation-Id: 06b5e2cb-1c68-4750-a58c-08dea67e42bf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|1800799024|376014|18002099003|56012099003|22082099003|921020;
X-Microsoft-Antispam-Message-Info:
	y3qRTqOnXr/59SqtrsyISWMUaVCIZO4DPkk61mZYRqEEW1GU9PCIR3QxETgNU5qABOCNcAf4n59zE9h/poXBEK7RhPwIhVyx8zsSV13NS59oR0ZRX7ffRgyxUKjjb9bI0V6svV3O9V5H+gpmGIilR4i4VRRODFXppnDMP9WtkEicNP9CVfJqElhHbxba7ZwKg+rpLwsO/zj7+A8SPsSbQOkNGwdykoUGnpwMxdgJIApj9fwWKIQ1dWhy6Iw5EFRbk90gjQWiXIrubxs6hVF/N/hI4eaysW4kZkS0PRCtQZBFMpxHXmep4EtJb+DJ/CiXVNBSTD/JsbT9WdtN8eEfyXiek08x3kp6ceAbU4ukaTE+delBRgGpuJVBxbK4SLDP74Ps3mNRaiF+bm+HbjJI+k9Rd+jQL/c9rkouVDJdgOwIr3kBKIWXZY0LvMTFtgPwDcavhm/5NAc77nM9/P94nF3vAuPfG0GwHPmAjvPNjfm+zns/Bbizbtxqx/+nsm0kQoeH0o5X0jkHZEd9bXwzhJEX7Girb2Qu89cH56s9ccMiZBYNFkyjc87N8ZLP6k56HbvEr7SdH7ShR3YOBsI+Lw0Pd+TV3Gh+IQkZWQyJwRyx6JOoSDe8Iw5RGDnePgwue/NpV2URJry7oUXxabWxveWBifQ64CKXtPHbYnaT6e0uyDdyK6WJqsVvJW5l/lcfYM1tbslfCmcGd+oxe1Z9/1IBFf9KFN2Mxmnu5ZNF/luTusbPhLZGchfVPkf1wrH46dj5A2ZldillkkJuzV9x5w==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5685.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(1800799024)(376014)(18002099003)(56012099003)(22082099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?N1NVdEJ0WmFCb2hsRXJuaDZ3QVgveDV3Y2JKZHgyYTFUdmVIT09yekRORFVa?=
 =?utf-8?B?NkNWY21DOWdGVUE5Y2FvMGFtN1lzSysyb2FTUDg1N2ZRNHh2eXNPWDhaR0V0?=
 =?utf-8?B?M2Fqb2F2bVdCZC9LQWhBb3ZJcFJLSWhZWmtlc2FlV0RYTHdaa1hqWTNOaCtF?=
 =?utf-8?B?QWlPWlpYMjltWkN6ZzJEcHhBNFVnOGlteVVaU2thZ1lTTW92dkFKZ0ZmdFRx?=
 =?utf-8?B?MGpwSXZxSGo3Q2wveDk5ZDdpL1RIdUhGK1lrYmg3Q1FEck8vbk5SZXVnalhl?=
 =?utf-8?B?OEVoK1dhVFpMdFFaTDBscm9BSmg1WFZUVEh1QVkwOUR1OWNBcEJCdXZWZ0ky?=
 =?utf-8?B?aFlVQVo5SkdSZU5iSVBWQ3gwWTBKS1gzMXp4bXFXSm9ESFlnN1o5VHIxcGtU?=
 =?utf-8?B?OWlsRWYxQWQ5Si9YSGszL1IxcTBrREdrcDRvUU1uaE5LbzU1MTZCOFRKcFB3?=
 =?utf-8?B?VE9xT0hFRUtHV3B6UVBlMkZiZk5xVGk0ekQ4SUFjT25walMzMEFiTUtqOHkx?=
 =?utf-8?B?NjlQUlcrRnZFdFZ6Y1g1OVFOYWJuK2RnQURYbDBqTGN6bURzZk5ZZVhVeEtD?=
 =?utf-8?B?bVNYYnlyYjd3VTE1V2VVSHhRY05GTGdvOXBXVlhTVGZTTUlXanBUbXZFVXFz?=
 =?utf-8?B?SUt2Sk9IbEI0Q244U0orU0MrbzZNTTdBWWsrWXVuVkRIK1VtUTk5NG5saVpu?=
 =?utf-8?B?YjU1ejZSUkU3TWFOM1cyZ0w1WVRCKzJSM0VZNmU1TEdyc0ZjSDYveEk5MTlC?=
 =?utf-8?B?NDQ1YUU0WW9YckZ0YWpxdjV6N2l6Kzc3MUJBYXZLalNMMzZMalA0a3hNMmli?=
 =?utf-8?B?RGMrU2R6Y0xVVE5tSDEyUVBjZTZIczNXeEpGTkJWZm9VRUdxNytLVm01M2xS?=
 =?utf-8?B?ODdtN0VsNFpXUXZRdkdFbittd29kczJhcTBFU0VnMnozOTl6cno4enZiMzVL?=
 =?utf-8?B?akxjL3VrdE01WENsM2U3NG9adWI4ZHdIRjh3Zko3TS8rbk1XRDhDZzBBTkZv?=
 =?utf-8?B?Q2owZTlxdzZOVzVwZERJNHAzOHphdUpiSGVMYWNEdCt2Zlg4bmJkYmpIUWQ4?=
 =?utf-8?B?R25taThYb1VielAremVCM0VGVGRvNC9icDM1anVoMEFMWXBtYVU2bGNHc1kx?=
 =?utf-8?B?WGZCZjV3aG53b1FKeWJWNjBIdEdlam9EN2FSV2NHT0h5aTJqbzFyeURvSnhC?=
 =?utf-8?B?UVZiRmUwR0Q5VmpWSGJINjZkNy9vTjhQWTc2TGtQbllrdHZuQ0dWNjdKaUlC?=
 =?utf-8?B?MTBDQThNYyszYlpCUWpPY2twUmVaYmxLZVVpUEk4NWVwQXpDanFyWmZ5SVhF?=
 =?utf-8?B?UFF5WVZpVmJhVlVyT1JBYXZxS3A5dWxMT2pESnp6Uy9LNXowOVUvdG5mSGhl?=
 =?utf-8?B?ZlU4VkxuOEdWMHdFQk5uemdQelI3ZHBkVjI2OEJHRUJBbHFmRGxTTFdpWTdl?=
 =?utf-8?B?OGsweTBmMkdTTEdyTU01OXZxWFdpT1RFU2Y1ckNwcFd4b1VISzJ2WGhVaVFj?=
 =?utf-8?B?K1ZXME9PR251T2hBZThtMno5ZHhlcGQ5SHZLRXJSTFRxOWQwQ1NueDl0Z2pY?=
 =?utf-8?B?dVVpaHhBZXYrMHRHOTRVZ2NpcEZBRTdicDRib1ROTjQ2aVU0YWV5UHp6NEVJ?=
 =?utf-8?B?SUhLSXVDbmJBb2tWUlBzUXRlVmFaZHRYN2tDM2dsTmFqOW05MHNIK0pBRjh5?=
 =?utf-8?B?N0VSMmQxcUkzR1JUTmZURmRpUVV4eHkrMkhGZWdYU0gzYzZSdEZHL3pDWUZB?=
 =?utf-8?B?bnpYSURlcDg3b0xxOE9ZWlRVem5qREF2dU01a09xMTNzSW9RWVJmWThuYTNy?=
 =?utf-8?B?Q1I2dXcxdnV6eGNXN3VaWW41cWZJNm1xNWJob0xQdlFJSWo1ZFZERytnemZl?=
 =?utf-8?B?N2w2K2FuTS9XMWFSVGdwdFNMVEFEMFJUZEJaUkdXYnBwb0doY1ZlTnRuTkVF?=
 =?utf-8?B?OG9MS2pOTlQ0bDkyTWcxbWRpLzcrUzBWSnAxYlZwSW9aM1BPS3JaK01vaWNk?=
 =?utf-8?B?K3ZwR0Mxd0JsZVAyTjNFUjc3RzhxNDNncmlRVEU1S1JPZVB3MzdCaFAwZDRp?=
 =?utf-8?B?SndGdGtwOXdraTZuMVF4U0hBa3BBdThJcGhEQUpzNk8vRjVIdWkxMjN1RGp4?=
 =?utf-8?B?c1YwbXZJNkl0Qk9rVk14VXdadjM2QUVRMFE3cFZYM0c1RlBtUWw0a2gvYU9U?=
 =?utf-8?B?SlVIa0Yxc3l4NVJNVnFtQ1JWZjFacjNlS0EwR3BLZWVNU3Y2WlorZUZ1anZr?=
 =?utf-8?B?VkEzemJ5QnZqVFNiUlFoeVRMYUY0THJ3Mi9NdEYrTjVCWU5lSXNhSkRYUVNP?=
 =?utf-8?Q?AEh1t6TmVo5wAItjC3?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06b5e2cb-1c68-4750-a58c-08dea67e42bf
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5685.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2026 06:03:55.0975
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tYuwUUPyokcXz9ITvIYe0pG4+c9AtBGN3uTDemo48ItiaxhDMKUJSZkwoCO6HEjL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8419
X-Rspamd-Queue-Id: 4F44E49DD34
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.34 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13187-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com,kernel.dk,kernel.org,lst.de,grimberg.me,zeniv.linux.org.uk,linux-foundation.org,linaro.org,vger.kernel.org,lists.infradead.org,lists.freedesktop.org,lists.linaro.org];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[24];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[christian.koenig@amd.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[amd.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[amd.com:dkim,amd.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]

On 4/29/26 17:25, Pavel Begunkov wrote:
> Introduce a new file callback that allows creating long-term dma
> mapping. All necessary information together with a dmabuf will be passed
> in the second argument of type struct io_dmabuf_token, which will be
> defined in following patches.

Well first of all the naming is probably not the best. Maybe rather call that dma-buf attachment or context or mappping.

Then the patch should probably define the full interface and not just add the callback here and then the structure in a follow up patch.

Regards,
Christian.

> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  include/linux/fs.h | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index b5b01bb22d12..c5558aab4628 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -1920,6 +1920,7 @@ struct dir_context {
>  
>  struct io_uring_cmd;
>  struct offset_ctx;
> +struct io_dmabuf_token;
>  
>  typedef unsigned int __bitwise fop_flags_t;
>  
> @@ -1967,6 +1968,7 @@ struct file_operations {
>  	int (*uring_cmd_iopoll)(struct io_uring_cmd *, struct io_comp_batch *,
>  				unsigned int poll_flags);
>  	int (*mmap_prepare)(struct vm_area_desc *);
> +	int (*create_dmabuf_token)(struct file *, struct io_dmabuf_token *);
>  } __randomize_layout;
>  
>  /* Supports async buffered reads */


