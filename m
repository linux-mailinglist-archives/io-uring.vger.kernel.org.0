Return-Path: <io-uring+bounces-13221-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CBcRJU5H+GmJsAIAu9opvQ
	(envelope-from <io-uring+bounces-13221-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 04 May 2026 09:14:22 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 301374B936D
	for <lists+io-uring@lfdr.de>; Mon, 04 May 2026 09:14:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 946633001446
	for <lists+io-uring@lfdr.de>; Mon,  4 May 2026 07:14:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B3822D877D;
	Mon,  4 May 2026 07:14:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="XZjDas2O"
X-Original-To: io-uring@vger.kernel.org
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011005.outbound.protection.outlook.com [40.107.208.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C92D22BEC27;
	Mon,  4 May 2026 07:14:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777878858; cv=fail; b=Ucl42y/wu+TQN/ka9UzeXSMGo9nW8Te7H/e8zUEHlz8ul8hDHsNl43q4TeHtl1ODp13nVwUYMyFFt1NZvnFoM2fw1NR8U0sOxM2BPZY98Z9Z1FNox+14e4qUWTLvtbbO2ERotYPun677kyXGC8jCkxlEk/PMen03FB6x7fPTu9E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777878858; c=relaxed/simple;
	bh=NgXU1M5PncPzsomB/XcjGdC0ZLGNvx7d3snwYW0GNrw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=SZo2nPhVCemETd7taYodEdzvwome6mGuDhSW7pMgN7pVXEzIMVMoUL85xglJmgqNjzKv/HEkXXIbgbb6gftdcfgisgY5yvqNcdwompdOreLzX9mbWYXjiY9beR1D/kd4/vUvms8OcW4v4ibR/OwGnRXRZ7uSdX+/ixa/LM0XNbQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=XZjDas2O; arc=fail smtp.client-ip=40.107.208.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gq10awCoJJKWUeWc0PE5Ip6Ml365LQ++qnr00yQsnBisU2/RPCUfyrZzToMpRjFmwTS2JfFzq7H5NDgovSVz9KUT8AfI4ky1pR+o6iSjjjMx3mjL5j+ZULRDcHQgKUSJUmVuhkkPcd7fTc5x4d7HolkJfpmWdZ6d7OPyoR/BCQyK/1+pOBjAU+qS/QXQdqMjX/rtdPppY9YERtmZe5WQvKQF2hdluCSit34qyZfU6MNTGHUheUwbIEwighMllJj9PtzHjavDGz8tojiHzM4EExHMF+dgmIgpoYYwa+7hHOYa9w+zfwN7lFqSc0XXs2gcbAzrqalyGmg79uWQMpSzBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LNbYfKTDh8lupKfUI5nB6tm8EchhiVPSTMZ6+Xt9Ad0=;
 b=cdxDma+p9Ref/w1byHoWwxoYH+pA9Et1nXiXdrzoMk6vL8WJ4s8ViQUtZDXEbyoE41pq9jBYQiwncckOl+ibZGpnVR2bJm0efgsTKf8sATUe9HpAfY46b9001u3K8hFP/1r1PbEkIn/AIoMioyCW3pzkdmrJtESEMPShXT/L/UgbwMdjxGZUOPIvXZiQqHeW5cZJMLoI/6wejmEtUWBUIgjvd5RxDOzhX22r3TVEbvPO4H6SyllrmhQaozezLwZ2egT8YawGhVCUyCXdPY2zJUlj8zEn1baYhjh1Mnj5CqzyBJUhiaFF+FxDF0KCHjxX9uCUSuWmKSW7Aunjscd+bg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LNbYfKTDh8lupKfUI5nB6tm8EchhiVPSTMZ6+Xt9Ad0=;
 b=XZjDas2OOov17NjE+Vb4hDNp3tO/LS5Aj4QW/Fwwr3rI99iW5uectTpPMQ31q3EgGYnn0utZd5ZUuvlB0udmWuXtDE96DhL3XSd0R/LynX+7M6E+iHJocfS2JeBAegEc1J2MuBp45OtaKavg+Kt0XZlbfgAm8jwT+JwGoSCAvzA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB5685.namprd12.prod.outlook.com (2603:10b6:510:13c::22)
 by PH8PR12MB7375.namprd12.prod.outlook.com (2603:10b6:510:215::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.25; Mon, 4 May
 2026 07:14:13 +0000
Received: from PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c]) by PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c%5]) with mapi id 15.20.9870.023; Mon, 4 May 2026
 07:14:13 +0000
Message-ID: <4c9c9840-944d-4736-a55a-74f5c05b528c@amd.com>
Date: Mon, 4 May 2026 09:14:04 +0200
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
 <f0dd8f89-835e-4331-b593-4405ec59f4fe@amd.com>
 <6cce2f4d-7400-4618-82ce-cbd5004c92a4@gmail.com>
Content-Language: en-US
From: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
In-Reply-To: <6cce2f4d-7400-4618-82ce-cbd5004c92a4@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR4P281CA0060.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:cc::20) To PH7PR12MB5685.namprd12.prod.outlook.com
 (2603:10b6:510:13c::22)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5685:EE_|PH8PR12MB7375:EE_
X-MS-Office365-Filtering-Correlation-Id: 6ca7ef87-0d2d-4c0a-88b1-08dea9acbe65
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|18002099003|921020|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	2r9jki0x8EOX/9SyWv65hye/iYyg2KP34dx3y5KvqmRMEStLAOPDrJzhJKeMdSVKF1xdzu0Rw1LXoEOJ39LDHpxEBfVXot9D88Ig/b1V+sRECoI3kSL1WShfWTeI6++YvB4LEgpomagrNITjY6S+wW3bZKD2eOmdQ8ZZzgoLOAQSQjUFPvJF0Y/cdzoIkyQ8Ec09nKZqfOtdAgo/1QbroHc3Xgf+iPa5PG5oxCTTfyYG1WPvpWHKivHMCd2BExKlsCxvducIYEpY2YGksuBWemnigytY7QdUsTwHy6AgxcDzEXF4RgMcCgm7/amBCYuP+icjFr0PNYyLFaieR+W6XXFAuGLQlQLcdwxd4t7HVn6KF6bbPaLB7h+9CZU51XtLfpr86+H5UPxZej75UdaRKwMq+BE+lwo36uAulKwR3TAPPhNiQoVOgw3poSEKjKhAd0eIGtOd76eBI4CPyPRAJW68P/hXE0hNOqlhrCIi73kebNfcFiCg4EuY1C7LnbRRgOfUv5wsHiDuzH8/55coDs6nx7hyOmmXZaKBrn3X9oZQFjUkogQxdUHuukWco/eEIOzTsPxageMt+zHIc21shI2SZ+SMCCOd5aXu/nq+z3w3jKF29LsbdeUkiAY5273/3fyy7ViIdfdLTRbqTkeYCrsCQHmD2xZ66mcGIk/cYkT/0+JAbnc5nR45rH3z2M79Z1Xi+jEqaiSVy2J1B95awYr+WfXjs64fWKm7//AjwFw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5685.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(18002099003)(921020)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eWs4QXBYbm53VTErcE1OODQxTWlEZmhzaWZiZDJUcnNnajl3UXhhcW1iRGk2?=
 =?utf-8?B?cjVLVWkvMlNZRHJvWm5VNzVpZzlyMHNkYi9DSTBwb1pWQngwRFFFM2ZZc3JS?=
 =?utf-8?B?UTJoUHdmQm5EM2kzWDRaU0tGNzhFVC9Rb3Eyb1F1cW81MjFCWE9yR1JMeFoz?=
 =?utf-8?B?S2Rqbk9DWGJuNXFzRGE3V2RyRi95ODlZeGRHUVoreHM1N0NLTmJCTHNmNnEz?=
 =?utf-8?B?cW9qdDZraEdKSFUzZVlQd1hObWxCSzJBQVJjZFBpdk9rTlhxWjZNM3lpblBP?=
 =?utf-8?B?TDNrRktwblpoU1Z4T3RrcGhWK1ROaWRMYm9ucUdiQXBMWnBLU2R1d2hlRllw?=
 =?utf-8?B?WW1HWUZNekVDUVF4WnFYOUw5L1dKMlVBc2ZWeG1jdXhDQUZHSCtneWFoUGw2?=
 =?utf-8?B?RWdQLzdQVGxJS0ptS3RLYlBrMHNEb3hBekl6MHkraUZ4L0p5Q1hnM0Fqcmll?=
 =?utf-8?B?dEJ5U1Q3alF1bUF1UVVDaWtiUmhNRHEvNVdRQ0tsTFVnaXdaaFEvSTN2WGZO?=
 =?utf-8?B?NThQMmFlazlkNlZ1eEFpcEc2Y3YrWkxoOTFnQVBZTFBYTjZjZi96S2s1d0Fy?=
 =?utf-8?B?NDNvaURjTWcrelVjSHdvOUswOTcvNk4xNDE1TEwrdTZHcHh0Z21lckkwY2Rw?=
 =?utf-8?B?eW5weFlmVzc1WVQ5NVE3NlhJOWl3M1ErMVNQUzNreUhnakgxLytKTHZDZEVj?=
 =?utf-8?B?aFE0NFdxZnBibGNyYjNLSUdhZWlGR2t1ek1WVGRzSG9MRmMrZk00MlgrT0tI?=
 =?utf-8?B?V3RteU8xQzlWU2h3THFkdFpHMHEzV3BpSE5hY0VjYVQyMkU1MjY4UW4rWUk3?=
 =?utf-8?B?NjRncURsZWdUVVJ0VlBiTFc2SzhTVitMV2VmbDllU1ZZWWU5aHg2a3VFOSsr?=
 =?utf-8?B?cVc5SXQ2SFVMdjBwQ0hpeFc1T2xsYlJKVDZ3TGFyc1kyaXFwVXp2NXV2MTJQ?=
 =?utf-8?B?YWkrWmszcVpDelpEWEFhTDRDb2RBQlVaT0lxWTVnQjJmZ1M2eWdkcTZIRm9J?=
 =?utf-8?B?ZXVyTGxMOXIwdFgxMmhVY2g3a2UvNFBOcmxqUFZiY25QaHoveDRmdGtlQ29p?=
 =?utf-8?B?UXFJK2k0ZXFRUk95L0dNeW5JSlBKVHFDa3FSSVR0VzF4VmVXNlhwTjZLRnZK?=
 =?utf-8?B?QTZSRWFTZTlqRHFLcUFiOTFlTjl5eWlrK3l6VUZHdnloL3hKZGo3UFlmNmZr?=
 =?utf-8?B?eFdOUFBhVDFGY3hNbGp1ZHpERExvWXVpQlhoVDIzL0dQSjFKdng2a29NdkZz?=
 =?utf-8?B?QWVScVVrMk03Y1BWSzlPc2tGbndwSkRGc09jQXZ6ei94Um4raFc4NlpoRkkw?=
 =?utf-8?B?dmh3SXYrVEZGMk9MbFUrY3dEUUF5cS9pTU9mdHYwTUV3M1hkYnZkeEYvNW9Q?=
 =?utf-8?B?WkFXY0tPL3pscm9oK3hvTnNPaFlwQnZnNlhYQTM2ejZxbEpWbEpleW5ibVNQ?=
 =?utf-8?B?V2JnUnF2bGk5YjB3QXhhZTBmLzBTaUtiSFEwMkZNZFlQRjJZQ3hWTVNoWWZW?=
 =?utf-8?B?RllwZFQ4ekczMDRiNGpVRlJMRE1aWFRaZTJ5ZlN4K0RtdHEraTk2cVJEN2J1?=
 =?utf-8?B?VGVCTGg3d1prNzhSaWNYVk0xQmpjaDgrd1VCZWtXcE5OQTFZdk9EdG45SUhD?=
 =?utf-8?B?NFl3aVJPOGNSTkoybUUyUDVkNGpta0d6V0kwQUdJaVNsWjk0VVBlWFVHeGpJ?=
 =?utf-8?B?M0dHRWNMZ0FGNEpxSmg0KzUwM1JEZyt3MmRVU1dhQW1xSk5ZWTlJN3ZSbFdk?=
 =?utf-8?B?KzRzSWFTMElGMDNYUW1CdlRHUHNXNmtxTnArdmhLS3NyajByQVhzazVWWmta?=
 =?utf-8?B?eW5JbXNac0VRamNobWZCMUpGWVFOYW93UUhXYnFoUXdYWmxscXF5SlVCUS9s?=
 =?utf-8?B?U0d4NjRVWWJPc2FIbkFLUUpraDdGdjZjQXU5SUk5YXBKWmoyYlJlUjRDekU5?=
 =?utf-8?B?RGhQNE9MRXZzSFA0SlRMUWtYZW5UTnZJb3RuSXM5VW02T2pndWRjWWp2bWNV?=
 =?utf-8?B?V3JTSUR1alNhUTdQK0RUY25kZjVKdnJRM2EybVJ1WlJDWEJuaXhOUnNFOE5n?=
 =?utf-8?B?SFBlcEgzZWZyS0NKbTVxVDdPcUswdEdNbXZKS20yMGRHZlV5NS90YVNOQ1Ba?=
 =?utf-8?B?UzJJT2dDYm1XdlVhcUg1S21VMEdTT1NHcXpMcitvZ1h1eHE3T0hIaVNDcXdh?=
 =?utf-8?B?aGgyVTNMVUFCRFFDUHB5aHlUYzRiTFQ0L1pFTHo4cTNoUmdHWXI0UmxlVmZU?=
 =?utf-8?B?SnJEb21ucVVOUHBuTW9iejM3R01oRTFLc2gzd3ZsV2pSbW51RVdjSDN5Zi9t?=
 =?utf-8?Q?lRCiD467FpyX1dqcfx?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ca7ef87-0d2d-4c0a-88b1-08dea9acbe65
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5685.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2026 07:14:12.9675
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: atoJyTpYzmKoD0wWHoKmRA5jtrN7JUjk5umOY7ZM0839xrt752Z9O+2B30jxhv5W
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7375
X-Rspamd-Queue-Id: 301374B936D
X-Rspamd-Action: no action
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
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-13221-lists,io-uring=lfdr.de];
	FREEMAIL_TO(0.00)[gmail.com,kernel.dk,kernel.org,lst.de,grimberg.me,zeniv.linux.org.uk,linux-foundation.org,linaro.org,vger.kernel.org,lists.infradead.org,lists.freedesktop.org,lists.linaro.org];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[24];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[christian.koenig@amd.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[amd.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	TO_DN_SOME(0.00)[]

On 4/30/26 20:33, Pavel Begunkov wrote:
> On 4/30/26 07:03, Christian König wrote:
>> On 4/29/26 17:25, Pavel Begunkov wrote:
>>> Introduce a new file callback that allows creating long-term dma
>>> mapping. All necessary information together with a dmabuf will be passed
>>> in the second argument of type struct io_dmabuf_token, which will be
>>> defined in following patches.
>>
>> Well first of all the naming is probably not the best. Maybe rather call that dma-buf attachment or context or mappping.
> 
> "Mapping" or "attachment" would be confusing as maps are created lazily
> together with struct io_dmabuf_map. I can name it create_dmabuf_ctx(),
> but I decided to use "token" not to collide with dmabuf terminology.
> e.g. I wouldn't be surprised to see some dmabuf ctx in the dmabuf
> implementation code. Maybe "*io_ctx" would be better.

Context or ctx sounds fine to me. IIRC we don't have a context in the DMA-buf subsystem yet.

But we do have the terminology context in other subsystems and components which build on top of DMA-buf similar to this patch set here. So I think that is a pretty good match.

> 
>> Then the patch should probably define the full interface and not just add the callback here and then the structure in a follow up patch.
> 
> I strongly prefer splitting patches so that they touch one tree at
> a time whenever possible.

Exactly that is what you should *not* do and is the background reason why I ask.

Making changes in a core header like include/linux/fs.h to add a new interface and then only later on explaining how that interface works is usually a pretty clear no-go for upstreaming.

Each patch should make one consistent change and upstream maintainers sometimes even require that you give an user for the interface in the same patch.

> tbh, I don't see much of a problem it being
> not defined as it's just forwarded in first patches, but I can shuffle
> it around in the series so that definitions come first.

That is not really a good idea either.

As far as I can see a good organization of the patches would look something like this:

1. The API between higher level and filesystem. Including all the functions, structures, enums etc.. necessary to give everybody reviewing it a solid picture of the general idea.

2. The higher level/frontend/uAPI. Again including all the stuff necessary to get a solid picture.

3. Eventually the glue code between #1 and #2. Depends on if you need it or not to understand those patches individually.

4. The backend implementation, which enables the new feature for a specific fs and/or storage device.

5. Updating Documentation/filesystems/api-summary.rst and eventually adding a new file to explain how the DMA-buf interaction with the fs layer works.

Regards,
Christian.

