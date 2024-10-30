Return-Path: <io-uring+bounces-4175-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 59B4F9B590C
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 02:23:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 35956B226F8
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 01:22:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5F47145FE8;
	Wed, 30 Oct 2024 01:22:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SqOeIYdq";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="s5fYOgdt"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53FFE1EB56;
	Wed, 30 Oct 2024 01:22:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730251373; cv=fail; b=E162vkWqAM91xgIW7a3LOVOrODT8QsCHI31JZyxs/IFd9TMODp20T2W4WyC7zE2Qt7auLhqeMNMeulJ5E1vk1qKghffDv8Rga66e6dY26UbwYFH1mFWX0q4oYhTBDXss3N6MZJ32MD+sE5vD7Mcnf16zFCBvZC3bXNSz1m8Cxm8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730251373; c=relaxed/simple;
	bh=P56LG8D5rulmP1eiTaARDtp3xk2Sos9K9XRqC9XGfDM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=n1a91PfttuOLYUqq6Opf+fcSyjNEEXUZaY8yi9qT2pbbMV7qb47dAYMizZK6u5ieohEtu75Q8Rm7IwC/+7OuYFJ67FeamNWzshf7hD5uYoGnk2Cw0yKnLE5cGbl5/VdzjWprYup3MY39iJHEQ2t9Z9mfcxEE/vrNflegj9j2Q3Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=SqOeIYdq; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=s5fYOgdt; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49TGfgGL003822;
	Wed, 30 Oct 2024 01:22:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=D9A7nghMvMTs4JuXQGucU7PYruq9y1xIYU4Z1U0pCoQ=; b=
	SqOeIYdqb4S7Nazc/eLejGqh9MS5UpxxP66EsJfJAoRJ6QYYpKtcjS2MbmjB0dT2
	RiP/uAcwV6X4nDXzWjG9KK9VwMUG3rVPH5QDQQxFejJYa6SCAKHEdZDgaERzKbJp
	HIPflWqQO6Vf9ox8lq6/hqQz/OaPuCz+6paQFw10yGT5foKvzxVAZEthghUh69kt
	a7dJ7r7zVzL9KZ2pkcVmK1SQB9t84n6RH18Sy5xBIXj9OxLvHrNmZeAphF4XPZBh
	Qo0J8uZxhHmtL6zfDsvqqLTjT7qfqcug+DSVx6LwxjdgAA2mDRHmad/cwneAbhTC
	iABSdVMawkJNlLkh1UAaow==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42grgweu1k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 30 Oct 2024 01:22:48 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49U1COV9010236;
	Wed, 30 Oct 2024 01:22:47 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2045.outbound.protection.outlook.com [104.47.56.45])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 42hn8xp21m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 30 Oct 2024 01:22:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HAh0bdJ5/nNggWKJfUW0FUUVNO2OWZzGIA8Hrq1828KxiLE5MEdAA7KoXMO/bbq0efCfIH6pue5Nd3AGdZjRWgLzN8mhh+GEg5mx8juSaCBz3IDltTqEMMKfLJvHpqF6TPyx9L8C76gqX+ZCKCAs1s3mPP7cb9Ko4vH9q2ziLfvBblNkgLt+ymeNtivW6+5ct32khAFTGzXZudZu0D2S15AG8QFkkGAfbMQoF4kf+MLD+rnwmIO8bJNMDJnqvTRudKb5lPZ3l6+U6qIXykOXFlS1hgYr/OQ5L6IommjgyzBlEiaw5dASjf5mgqirJ/8x5pJ22ftA9q+niNChvZAOrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D9A7nghMvMTs4JuXQGucU7PYruq9y1xIYU4Z1U0pCoQ=;
 b=YrzHPmK+zUL3KXPTV68L10RHY5yBGq+FPasJAF9fpdsEXTAj4fCsBag7BHQKlQQlQjNCNxhkHLVpAV0mfyxCNEMPUyZqefRCiZRFCtz47Wm7HCNhc+5Hx9euoLhpco1UGRKvgJHgKo0KMGgpDKCPrbXBd/TseoPofTHTKMGCpN8OcveH7GvENxer7vIF6i83q/YUxoJlYVIdEMzKkaRz8259rbPJcFCJPssIlKKPqVpXCuhPEudguQiEL3wAtIB8YcIios84U0T7l9x4vrxkbxZZ/ir82Qismd3vRJfpxQmMFFbcuROI/I+QBOX/p+LEtcdxq4beYWv9dUsOuSb4jg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D9A7nghMvMTs4JuXQGucU7PYruq9y1xIYU4Z1U0pCoQ=;
 b=s5fYOgdtcXf32ccgcntAvBy9cg5WVKiMeGfDIfy/y7vtUb0X0G6PRSiOTC7kNRjRO24OFSJ4jhnh0hbHCHVe19nbt/8LGpAEk5OooIPcgxwHRBgBPCmFz75apdDQB1SCcrMaEQlhU1Vlpkuh917MpqoxwjN0FjwQdf2G7nhS/dI=
Received: from PH0PR10MB5706.namprd10.prod.outlook.com (2603:10b6:510:148::10)
 by BLAPR10MB5169.namprd10.prod.outlook.com (2603:10b6:208:331::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.20; Wed, 30 Oct
 2024 01:22:39 +0000
Received: from PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::fea:df00:2d94:cb65]) by PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::fea:df00:2d94:cb65%5]) with mapi id 15.20.8114.015; Wed, 30 Oct 2024
 01:22:39 +0000
Message-ID: <2117807e-3863-4809-8447-a7dd2bec436a@oracle.com>
Date: Wed, 30 Oct 2024 09:22:36 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/5] btrfs: io_uring interface for encoded reads
To: Mark Harmstone <maharmstone@fb.com>
Cc: io-uring@vger.kernel.org, linux-btrfs@vger.kernel.org
References: <20241022145024.1046883-1-maharmstone@fb.com>
Content-Language: en-US
From: Anand Jain <anand.jain@oracle.com>
In-Reply-To: <20241022145024.1046883-1-maharmstone@fb.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR04CA0200.apcprd04.prod.outlook.com
 (2603:1096:4:187::15) To PH0PR10MB5706.namprd10.prod.outlook.com
 (2603:10b6:510:148::10)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5706:EE_|BLAPR10MB5169:EE_
X-MS-Office365-Filtering-Correlation-Id: 74a35cef-bbc9-4d3c-8326-08dcf8815849
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WjFpNTdLN2hHa0IzbzhXRGs1eUlBVU0ybUUyc21kYnVRSW05QTNTVVdZZGVm?=
 =?utf-8?B?enNqZkcrajkvcW1wWlFOU3RRanQ0SmtVRXE5NTY2TEw1cU45eGhkWGxiYjRo?=
 =?utf-8?B?WGE3dWJkbnN3QWFHZ3p2ek5XcWdJRHNqZGorNmxNYVlTeFVXQkU0VytEOTdy?=
 =?utf-8?B?U3RqaUNyZVhiMlQwS0lkWEM0M3J3MUhYQ2ExaWVYWktCUnFxa0JTVVJ1aW96?=
 =?utf-8?B?SjFKK3hzK29iaHlzcWhUTkxvL3VQMHRHdjgxeGVJR0NDcXZHazZoV3FnOWpW?=
 =?utf-8?B?V0pxSlVteHlReEtFYnJ5R3h3d0E0QWR5cHZxUFo2Y0tDYnZyWG9YbCtzOGt2?=
 =?utf-8?B?UHFqM0RGZGhvdVVEM1FPTUpwREtZbXFSbEdxRUYxYmxaVTF2Zm1uZXJjaCtv?=
 =?utf-8?B?Nm9FTUNqU2YrSVRmcHZEN3BXZXhyaittajk2eUZ3cHhOU3dSSklVRWFlUGRI?=
 =?utf-8?B?b2tvVmZZWmZhZFU1ZzdVb05pWlJWQXUyanp0ZEVSSnpqcGlMNi8xTEhFZk05?=
 =?utf-8?B?SjlPMGtyb1RQVmRMYWRBTXhEeFlXcGJrbHRRaWpsYzdYVC93SlN6cW5NNE85?=
 =?utf-8?B?blV1UnpMeHRZeHZJcnQzWjRNOTQvTEk4bGszc2RuYm1PMHZPUEtWbkFMaEtI?=
 =?utf-8?B?TlpjSUp5ZDVuZW4xek9yeGJ6ajVqSGpWbldDVzNqdVhqSVp3d0YrUWhSOTlG?=
 =?utf-8?B?cFAxdUtSL0NiSXJGY2QvTGM4OEc0RURIeHRjeHV4MUNOTU5NTHROeldIa3ho?=
 =?utf-8?B?aHVSVTZ2Q3JOVlpTOEFqWkFyR1l6TUFINlpJc1JRVzExc1FuSGsyU0hKSjB5?=
 =?utf-8?B?TXh6NEhaaGtmaC9SSytoS1R5dmxlL3EyMlBVb1k5emw2cTVEVy9TWEZiS2dN?=
 =?utf-8?B?cjdZOCtCRVR4TEpaLzM3SnRvcHJkRVNTVzZqUEttMkx5WkxadDhZMzAwNlpo?=
 =?utf-8?B?azhEUnIxNjdhbUNPbmZubC9kSWRSblcvYXB5MTNkQU4vQ1JHQ05nQTl1VHlw?=
 =?utf-8?B?SzZ5TmZPamUrbWhxZE5VT3M2dldxekFtSER5TXlUL0xNRlZVZ2RqZ1JSQmZx?=
 =?utf-8?B?Y215aVRsYjZhOUNzMHk5ak5Uc3gzeTh6S21LSmgxVk5SMldTTmJ0dWlpM2lW?=
 =?utf-8?B?Mjk2azZvS0pQTWVNclhvU284V2JqcjI0YzZaZDc0WEZESjIyKzJrSXlkMGNz?=
 =?utf-8?B?Vlc4NFJSU2FrRnNybVhHLzBIbDVmUUZtVWRPdWYrSHE2bitsS05XKzVubmtx?=
 =?utf-8?B?Q2pqQnNyVmxhVlQ0Nmk1YWNlL0lBS0JIVld1cU52U0JwSUgzYTF5OWNvZWZG?=
 =?utf-8?B?VlNmY3gxbjdLNExyOWU3NUFydUtoNzRpa0dJcXFwTjU2b1JwSVk1UmFGOGx0?=
 =?utf-8?B?cnIzcU5UeVpGM2RybmdaYWwrWVduQTArS3RtQTVIZGwyMDFmOTJTcFdOUENq?=
 =?utf-8?B?T05zWStVUEhYTWZOb045WG5PY1l6ZmJZdHc0N25iTFRRQ3FteUFNRUtIQ3B3?=
 =?utf-8?B?WWFGYWIxL0lQbU93Vm1ZNmlVTjgveHl6TnNuSGRnTm8wSWNFWGxIdjIvV3NL?=
 =?utf-8?B?b29seGZYc3JmVUxNTWhOZkpPZWpuU2ZZcW5zcVdGR2lXSXo5bGcvV3V6K2NP?=
 =?utf-8?B?YXhlOWF3bjhFWWliR2F0MHlMQ09XY2FmTjBIbEhHOWxML1JrdkJWV1hBYUFz?=
 =?utf-8?Q?OZusoNfOyUWs49f0Ef7X?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5706.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?a2JFT0pFeGM5eWlmNDB1V0F0TlY0K2Y1SVZBUW9mdkNnRW1xdFZkcHZUR3Fo?=
 =?utf-8?B?a0pqc0VRYmp1cHVOUUcvT2diRVlVUmZ0dUE2bmltUkpOSkZnT0hldlZFS3k0?=
 =?utf-8?B?OGtrYmFDNE11ZS9nc1RLZExWRXkvdGlQVnI4ejJDTk8xWW0wQmRxT29CZVVE?=
 =?utf-8?B?Ti8yN3FtV0ovcG9wTnpMcjNPa01Nb3VudlpBeDIwYm9VdjB3MVgxZDl4M2tq?=
 =?utf-8?B?bjFMdzFVamNxM2ZXYURNU2VKNkYyU09oUzlIeUZBY0VkNUhYa1NpaFFMeWtn?=
 =?utf-8?B?V3ZCV3l4azdVcWZ6L04ydkJObXd3UzMxdERiem5WSGVVaVBLNTVvbHJ5dkNy?=
 =?utf-8?B?UG5zMGw0T05SQXBoZHBYNEV0U2crZWhnT2dnVHdCS09BTkpZVVpXUkxxZ3ZC?=
 =?utf-8?B?akdVTmZIdGlPMm04L2h2Q214MDIySlNJSG5RMFBYd2dOdEVQVHBHTDJxL0lQ?=
 =?utf-8?B?OEhzVmVjWFNkb241ZDVyOVV4RlRQOVlJYmQ2WEpCSkxxb0RUQlk1YWRIcUEv?=
 =?utf-8?B?ZE5GL0JHSEpkckNGc3JBcFhIQysyRDFDNm50OFpNaEFhVUlVVjBnL1lOeEZC?=
 =?utf-8?B?Tmp0NlRZVFpYVEZaOWMwV3psd0ZpcjcyTytVT2dCakIybUlCZU5zekNjVS82?=
 =?utf-8?B?dDByVHVDM1BheCtQeXJMNHBsaTZOR00zaitYSFlZTk10aUJFMkRLOU0xbVFC?=
 =?utf-8?B?NUhPSmNIUnBXS0RSMVNWWmFtQTFUa1hEVUgxbk1iTVRMb0d6MmN5aFc3amls?=
 =?utf-8?B?ZnJHNXJHdHQ5MkY2RHNmUnZaTkxIVmVpbmZyUTZ4WmlTcWZyY2ZlUlNPcW1a?=
 =?utf-8?B?OTlHV1BkdTFhN1N2ZDFjMk9Fa01YSm5MbXpRcFBzSU0wQ1lxRkc2Qjc3QmEw?=
 =?utf-8?B?c2l6NUtNencxVFdyNWQ2d1AxcGg2dXozZWYrVUZuN0RBY3QwNnEzb0N1VENH?=
 =?utf-8?B?am9BYnBXMUpJbU8vSkdHNnNyZW4wZWhoTUFlRjg4WG51azE4MS9rZjgwM3VP?=
 =?utf-8?B?UkhsUEdUUVJzdEIrand1eXZNQjFqUWlpZjNROHFUZGFIeC8vQnNwMXRRb1Nq?=
 =?utf-8?B?TFVKdGtMOWZFR3JPNXZUSUlsZjJ5d2FCejhiTW5zcVZkclo0SjYxa2VjTWFp?=
 =?utf-8?B?TTJRTitkSitXa0tRbVpKdlZKRWtvK2tyVGkwTHQ5UmxhMHh0QllwUUF4SnB5?=
 =?utf-8?B?aU16R3JlNWtxUXNaUkEvaE9pdmdJTDNCcFZQY2RVMjZXTWNmVmdBOHJMSUVR?=
 =?utf-8?B?RkQzaGdtWGgxTXZ6SEJMWmFKaUNhT3FjdGJhSklHRGxoaitmd2ZlUEc2NGY1?=
 =?utf-8?B?UjBMVGVuODN2aGNkRUh3UFo2T0lpemlEQU5CS082QnJsR3o5Y3JaTjlicU1r?=
 =?utf-8?B?Q2lQWWhEV0FWUWZ0ZkdXRjBHSE1yZGlJNnFQVmJpcTNhRXZYU3RDNjI3WEVC?=
 =?utf-8?B?SDRSMDR3Tnc0R00zb2VvaWR0ckhUT0tMNHhtRFp1ZHhFNTE4NktHSUYxcjd6?=
 =?utf-8?B?YjRHTFRyRDEzdG5LUW1zRmVBM0NzZlNNWHJ1ZWd0VndsM09jS2d4WXZUM1BM?=
 =?utf-8?B?eHZjV05zL3JVRFZxRGRPaEZheUZha0RQZ2tpUEk4aVBnR2o4SXRFeEh1SHFG?=
 =?utf-8?B?Ykl3VVc4RE5CMUNIVTEvMG5FRTZlWkdrZS9EV0lmbm1FQVc5UmVKdFhCeTk4?=
 =?utf-8?B?WEJlNHJ6L0F1VGhCVGxsRW5OdGpLRWhReUFGWFp4QlNzM2xGQmc2NHpoQzVj?=
 =?utf-8?B?NElDcWhaQmxFaTJQdC9TeWhlelR2c1ZIL251alBvVEd0T3RVZzErQUtQcTMw?=
 =?utf-8?B?V3crUVJ1S3dCK0IwSjVPVUhWOUpvcy9lMFF1ZEliQ3l5R1ltTTM5Z0QrZmZp?=
 =?utf-8?B?QVNDVFVVbUdjZWF3QUxqUmRBQlUvNFExQTF5Lzg4WE5rMnRzbFFyUWFseG0r?=
 =?utf-8?B?SWZrNmVKZU5XN2wrN1VRSHNFWG84Zk1VSXY2YW5XYUJSMW1pNXhKVXpDWktI?=
 =?utf-8?B?WWdlSGxRck92NTNCQ2xzV3hDdENNUXREazBkU0RFdUx1TjVGbWNOZ3ZZRHlZ?=
 =?utf-8?B?QnpPYXBvSll3d2VDczFpTWQxa2tKS0VOR1BYWHRraWxuT2ppVzRua1FMRVZZ?=
 =?utf-8?Q?2EdbXS8RQyLffWnLti1EfwUHE?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	C7uGx4cgqBTuGWek8eYKn4C/WnqbL0kZ65dh7K0PGMhxzBo38h8IdwXYg3gjDeq2rjXyD/p5LxsfvKNFy0SyXM5glZhvAwUg4nR5w5C4DLDpwqHsuDvx5kmFLLTFDG6ASiqVYrGj8DyU2Cwq5Co1ty9lc+lImkI34YVoMwYt1AjtXgOQ7XTt8Ur1nGxgxRR2Yi4wTXaK3eK0QElHFM/R+lp60dqG2qYjGb87iRGyydrLCjO1uWeulAPgVhf1HhkdNM8wgOR5U9u7dInJD7NsJXm4ZyHetXE7pGlo7C8eveKmcBWxDnRb0VBDnqjL3XTcIo7HxMwJoL7PcRmlYYoESSN4mpOhLWYZ3Kmpj16tPJvpqh80cvBmK3xOLzF8QGMxYuNWo2QGpQ3e2ueTwWsVXM0Vld+z0SMYpfTYyLnMSHn+oVF2dTfU/CRB1bsLz2Uh6WjNnG/2+KOyHxmFpGOjVzWpI5rC8WLKeOMmUjl9moS+BGSgLhEme4e2VNl3qI5jPrBTy0BhEv3CM1/x6BZ9N+uvgtytX8wwIXZcwvrNEQsCMSoydgWVtHFjo/Ksunm5OQiVRHzvR9dxYpGa9qSZQqunNdh0NRUr5w1uBpwxx1s=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 74a35cef-bbc9-4d3c-8326-08dcf8815849
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5706.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2024 01:22:39.8184
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Kb1zefQ39Pc6dVZohgcq9A6RGemqxL6qgekQQEmIxh9U5rkyqMT0fxxgaQeFQ79Od3xbPHhOjSMA/0i1bdsz8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5169
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-29_20,2024-10-29_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=990 mlxscore=0 spamscore=0
 phishscore=0 suspectscore=0 malwarescore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2410300009
X-Proofpoint-ORIG-GUID: XANu8yCyZpwMvqcbi7JO-3blpRCaQ7pK
X-Proofpoint-GUID: XANu8yCyZpwMvqcbi7JO-3blpRCaQ7pK

On 22/10/24 22:50, Mark Harmstone wrote:
> This is version 4 of a patch series to add an io_uring interface for
> encoded reads. The principal use case for this is to eventually allow

> btrfs send and receive to operate asynchronously,

How would you define an asynchronously operated Btrfs send and receive?
Are you referring to Btrfs send and receive the leveraging io_uring
asynchronous operation?

> the lack of io_uring
> encoded I/O being one of the main blockers for this.

> 
> I've written a test program for this, which demonstrates the ioctl and
> io_uring interface produce identical results: https://github.com/maharmstone/io_uring-encoded

Thanks, Anand


> 
> Changelog:
> v4:
> * Rewritten to avoid taking function pointer
> * Removed nowait parameter, as this could be derived from iocb flags
> * Fixed structure not getting properly initialized
> * Followed ioctl by capping uncompressed reads at EOF
> * Rebased against btrfs/for-next
> * Formatting fixes
> * Rearranged structs to minimize holes
> * Published test program
> * Fixed potential data race with userspace
> * Changed to use io_uring_cmd_to_pdu helper function
> * Added comments for potentially confusing parts of the code
> 
> v3:
> * Redo of previous versions
> 
> Mark Harmstone (5):
>    btrfs: remove pointless addition in btrfs_encoded_read
>    btrfs: change btrfs_encoded_read so that reading of extent is done by
>      caller
>    btrfs: don't sleep in btrfs_encoded_read if IOCB_NOWAIT set
>    btrfs: move priv off stack in btrfs_encoded_read_regular_fill_pages
>    btrfs: add io_uring command for encoded reads
> 
>   fs/btrfs/btrfs_inode.h |  13 +-
>   fs/btrfs/file.c        |   1 +
>   fs/btrfs/inode.c       | 175 ++++++++++++++-------
>   fs/btrfs/ioctl.c       | 342 ++++++++++++++++++++++++++++++++++++++++-
>   fs/btrfs/ioctl.h       |   2 +
>   fs/btrfs/send.c        |   3 +-
>   6 files changed, 473 insertions(+), 63 deletions(-)
> 


