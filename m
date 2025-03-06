Return-Path: <io-uring+bounces-6973-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B7150A54769
	for <lists+io-uring@lfdr.de>; Thu,  6 Mar 2025 11:13:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4485F3B15D8
	for <lists+io-uring@lfdr.de>; Thu,  6 Mar 2025 10:12:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12A4C1FCFE6;
	Thu,  6 Mar 2025 10:13:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TR/Y5/Gz";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="OhjrvabQ"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43EAC1FDE37
	for <io-uring@vger.kernel.org>; Thu,  6 Mar 2025 10:12:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741255981; cv=fail; b=IGLp0EQsAgBQRzg/OjKtv+iz9dU1TzI+Km1rZev9YrAN5JLFJFTQ4n/+7HhvqXVSp/gQCLOXn52MU8LQvmvILjbtmlkHqDi8cmmpso4t7Uns7VgnV5+IViWbrKQ9svbSmNXV44R6z1fFRaogInMTNB+3lBCofXcGG1tCXvli2eo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741255981; c=relaxed/simple;
	bh=raPJkZY7Hzi3lia6JTpLZZLgN9RbN7zuLNA7xKOQNcA=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=qzjqdXhVj3dwiO/GWg5/u+JTIO9o8rsgCPPv/EIloA0Vmr2oWy3HlEv7Qq3VcJ/l3ul2Y5NvtWttp0GbK2D55ebBxYPsMa6VLsTwDgNDFOx2fbc6V1N/cfKMzf+ByA5L6QeOwt+dFf3hSBsZkeV1EF44cQyY4tCEo8KgS8OtAhY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=TR/Y5/Gz; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=OhjrvabQ; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 526ACZqS001359;
	Thu, 6 Mar 2025 10:12:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=5qvWIJwBtFUC+lFTxInVG8cuDUqZv0G2QRKGHSYTVhI=; b=
	TR/Y5/GzUVsPQWlpNsK1pdFvka0pDXvWQcNN/Idm3AAq8KO7kz3XJ/cWSu9X/LbP
	La9Gf7HGmYizYXf5v5EFpJLPMOd5w4K7VKDI/GXwdEfEdrfbmnT1i0iCdLUNq1t6
	DpFowN+vgx3diT3tYnt6D4iu3Slw9M+1nO0uwU8zig03AZkObpzPU9cxtpT1YSMx
	f9tZUYTdAaSZdP5pKtAGVCOZ0utT3oRkxf8E9vw4LGS05a6DQiVlrVFFjuJlEZJ7
	tR9YbkE5SJ01eUq5Oty9reOnJmFjL3Ama/fmtKzA4fqpP1fS0JGLlk9BSqtae9b/
	pmVqM9NgPFY4XHwRxM6uQw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 453u821u6e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 06 Mar 2025 10:12:57 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 52687JB4039727;
	Thu, 6 Mar 2025 10:12:56 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2049.outbound.protection.outlook.com [104.47.74.49])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 453rpcm9nd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 06 Mar 2025 10:12:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AVyTsR1KdzEslUbLN9p1ZHCI9dsPZtev0RB2Gm4iwSlCRsELJTCY8Sl9/Xkgz4jeW5EfPHFM4Ng6KPWISsC38LPyVgubj3EHdYhRXw8hkj0o/RmWyslLLNwekdqQ2U9sFtLbwsrZIXEMnLws+j5vKAeGzNjOCg/3+imbeRV61tckO8zIMtt51QBtb4H/W+P62xO0JsTyArmFnHrueVxFpY7S9JmQBLrFmC+zfce2ucwSkwd4XsL8vCA4r2ZOvNfYEt1uCMsV1Jp958wg29u/wX0wAxxtizLExxaKsPGAMrT0SYq6pPr4E3hs2G7DJDmPexzg5PlMLgcN4pobmIFSag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5qvWIJwBtFUC+lFTxInVG8cuDUqZv0G2QRKGHSYTVhI=;
 b=DM/je/JCleQ6Whtkm5zC1tUZYHBrEHskkiBnQp5jcIn4DRDxEz3Mh6T70ME4puK11S6DmYk+S3Eri+dZ+kLdN9QtKn+CNiR5F64SutUqt109iPvNf49Os0WW7H+kumJWdUcZJOjuDheu6SEp9pQ7kJgtCIlyPTvapfQo+zREY2a3Gn8tk0/OUx+NgEFz8YexmQe/Z3IE9szFWJyUPUsCI/UBmLTisw5zE4CH0iNG85s5p3hqZEzJEyAp0c3sDezZQEUEX+MAZP3SpGCp+0Ljn0iwjMTJ2/S8DwoorY01DUHyqcNlfL2Hlux1Ma7aKUuAMP39090e4GbXPrWBtIFM0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5qvWIJwBtFUC+lFTxInVG8cuDUqZv0G2QRKGHSYTVhI=;
 b=OhjrvabQf7ufft43LTjdxE+IMRAh1WaUOHMaMJqtHxJCTKoN9W9ZHUTc4Mxwu5A73uusnjVDzAwkpGERGZx1W6jHY7UneWP2F5oe4Pp6PSR4jZgwcpUritf6ZMFsRsLcVxg90b0ZXsnFFPS790M0t5cEJs+ZjdpFFiGkBnNxapg=
Received: from CH2PR10MB4312.namprd10.prod.outlook.com (2603:10b6:610:7b::9)
 by SN7PR10MB7074.namprd10.prod.outlook.com (2603:10b6:806:34c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.28; Thu, 6 Mar
 2025 10:12:54 +0000
Received: from CH2PR10MB4312.namprd10.prod.outlook.com
 ([fe80::fd5e:682a:f1ac:d0a2]) by CH2PR10MB4312.namprd10.prod.outlook.com
 ([fe80::fd5e:682a:f1ac:d0a2%5]) with mapi id 15.20.8511.017; Thu, 6 Mar 2025
 10:12:54 +0000
Message-ID: <c57d06f8-b9b7-48f8-bb8d-05e2c40ef254@oracle.com>
Date: Thu, 6 Mar 2025 10:12:51 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/rw: ensure reissue path is correctly handled for
 IOPOLL
To: Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
References: <92b0a330-4782-45e9-8de7-3b90a94208c2@kernel.dk>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <92b0a330-4782-45e9-8de7-3b90a94208c2@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0178.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18a::21) To CH2PR10MB4312.namprd10.prod.outlook.com
 (2603:10b6:610:7b::9)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PR10MB4312:EE_|SN7PR10MB7074:EE_
X-MS-Office365-Filtering-Correlation-Id: 14b63d77-0368-4c3b-7365-08dd5c97756f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?OXlqRnZuVXZHT1J1djFrdE1GamgvSWNxRHZybDVndUFCY0JEWnJtdGlGMDd3?=
 =?utf-8?B?Ym5mMm1TRmlmYWhGbzU4WXlzQS9ld2dYb1ltVzVVaDd6a1lXaDRjc0l6TW1n?=
 =?utf-8?B?alBQbDZTYm1LYmxCcUhuUURnajlkZWlKNXIxWDhDMEhvMWZSNGJNU3E4Q0lS?=
 =?utf-8?B?OVhOb0E2c0llZnFEVVRjMmk2eWJndUw5VUgyUFpicnVKcWgwUlFHVmdrdWFj?=
 =?utf-8?B?Szg5UDhSZE1xL1Z2TUJkMjNaM0RNNGxqVVZMZ2JSWHl1MmhHZFNDZGNTNG5t?=
 =?utf-8?B?RmNreGFyWWo5UUc4cWMvQW5WeTdWd2RhY2tDZXBySTUyRm5qa081VGdGYldB?=
 =?utf-8?B?ZVlVQkZOeUdhcml3cEk2ZStHd1RPN0NkSXNhdWhuOStBTUFSeUtOVDNBL2dC?=
 =?utf-8?B?K3FDVGIvTnlnQmdZNnQxekhvNWF5Snp0eXhsY3RDMERJMTNoT242Mk8rVUQ4?=
 =?utf-8?B?ZVMyb1FLenVhd0NQY3kzYjF3U0M5MlRId3RHZlVCSjRLZis4R1l4QXN6QmNo?=
 =?utf-8?B?NkhZSGI2K3ZpVk5mUmJhRk5CNTVvUCtNcHA3dVhFeFB4eElLdWlrMVRXdHVy?=
 =?utf-8?B?RGJDbGFVVUw0ZkF0bG05Vm9uWi9CdHd0dWVURVBRd05sMDk4NXFNVU0yaEtB?=
 =?utf-8?B?clBkRnp6NmtGVjNKaUJ4NW5YRjJ1WTJZUDFHMkFuV3JiS3NCUnZrUXY5Ri9Q?=
 =?utf-8?B?VHU0M1V2bXJ0MlNKRlh0MXZ4NUxEWmJBUVc0cnMzR3Z1eTYwT010bnFLTG8r?=
 =?utf-8?B?eTlFZnRyblp5eFkwWlBaNFJlcS9kZjhvMVYrVjJLVkNOeG5abXFISTZja3BC?=
 =?utf-8?B?bXdHc3FGL1FGRDJEZW9HVWdOVVB6d01CQ0NUVmRwRndEOUJjQzk2NTNLUko4?=
 =?utf-8?B?VXhiNFI4MXpUaFVFUnZ2dWtyYXVIQnVHbTh2STR0SnpCcE95ZmIxQXUwYTdk?=
 =?utf-8?B?cGlocG9UNnBiQ0lhNTkyNnZpSzdkbERzNTlNb3BOakJONFNxSVd2NEtSNGxL?=
 =?utf-8?B?aC9YeUM1NnZlRzdqZnk0RnhueUZieDdKcTZpVVphTUtzbkNBMUw5SGJsWXlP?=
 =?utf-8?B?V0Z2WGFOR2V5dzR0TDVlZkJHNjNjanVsMzBuZFFvNEpDNU5uSVRMTldSRU5N?=
 =?utf-8?B?WlFMQ1kyblh6dTdlZXg5T0x4cCtUeEdHaEZ4Z3lPdHB2aTBPSDNhV2luRFhU?=
 =?utf-8?B?VGF4YUtsbFJOS0JDdUV5Zi9veC9Xa2gvWGxmL1JENnVxZVJ3dXhNWDRNWXFk?=
 =?utf-8?B?VjFDbnBtaE00cHhYL3NwaFdEcE43blJRaStibkw0V3JzQkhISGhGU09SWURO?=
 =?utf-8?B?RTNycXE5VU14ZmRJeW9WT1RhTVJoOE5mZjluS1lCTkNzMnh3YUhDeExESCtl?=
 =?utf-8?B?SGdjUFpCNHltS0RPRDNQUXZKNW52Sjl3TGdJdHVDYTZaKzdscFFXTTFZbThK?=
 =?utf-8?B?bWpPU2phdHpBdloyTnRsTWRqb0paZmVhRENSeXpKVzcvM1pTdndQeVZtMVhU?=
 =?utf-8?B?U2U0T1c1R0JsYVQ2dEprSDN5WXRLRzB5S1gxNGw3dERldXgvbSs4M1o0UFdv?=
 =?utf-8?B?Wi81Z0dxQnRQMHUxT05xZjdYeTRHT0J5OGpwS3pEK2VoYzhNMDk0QmNlNEx4?=
 =?utf-8?B?YWJlNms3dDVJaTlMWEhWVHF4SzRYYnJlaGhNVkNkQUtDaFh3c0lzQ3NCbmUv?=
 =?utf-8?B?cE9XQkJyVEtlKzJvUHBWL0hDMXJFSHd3RDFRTjNOd0UwM3pUcDRNMmpadTNN?=
 =?utf-8?Q?8tBX39Ssp0TkjPNWjeu65AgsC8f3Os6maCtuspV?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR10MB4312.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QlhtSjY3ZzROSlZpNkdhVG12RHc4OXZzNXZzcTZ5endPUHNxWENOWDdWMExt?=
 =?utf-8?B?NHNmbDZldlNmNUszeDdYRTdQUzgvUHUvMWRWc3d6d1NFOW9CNCtPT0dYTlpC?=
 =?utf-8?B?Vk85QVZxR2NJNGw0TTY5dTZuVllyaDREOG9NZzRCTmZzSVFuRUJQV0ZnYWdB?=
 =?utf-8?B?MnM5UFozMWxHNC9hVHdFSGk5MVNYdksvS2Y1QXVUazl4Tkt0R0s5TFQxaENt?=
 =?utf-8?B?Nk91QUtuNzBINWFtU3ZmRUlFUEtsdEVZRWpDNVlQcFZsVzRwRnJSQmU3eU1k?=
 =?utf-8?B?TG10bHl5WGNvMDR5WE5nM0ZaSGl2R3c5TmpydkNURFJ0UTg1NFRXaUx0QklO?=
 =?utf-8?B?S0xOVXJKL21GMEltME1zTkhmKzJIS3FVRGVPaC9RUVNaNFQ4UUU1OFJqMEt0?=
 =?utf-8?B?Y080d0JvTkNSd1VnNUYybnB6L2U2MzRoa2k0aFdDUitBR3EwQzNMdkRoRXBX?=
 =?utf-8?B?VGdEcEU0SDBjZWNJWUFsV2xHM3VySmRET3VWU2p5VUxpWTZMYWZaRFoxU1Vu?=
 =?utf-8?B?ME8yam1xTUUvZDczRnR1K1ZYaitlS1gyK01SenJZOEd1WXlURDQ2eXBSbnh2?=
 =?utf-8?B?VzJQSTJsc09XeERKRytGSFc3bk5JLzA5V2tmdDQ4ditONFpYK0hBLzhwM1pS?=
 =?utf-8?B?ellEeWZDbjR3aXRIaFlVaUs0THRxcGJhQzVwQ2lPY013alF0TlZPeStORTV2?=
 =?utf-8?B?bGxzc0pUUDg3UWs2TlRwNU5NbWRFeU1OT25sbEYwcitBb2NHYjYzTCs1TGxj?=
 =?utf-8?B?QTB5a2MxQVhsUTBaYVhGQmJyTU5mNm11SzlBQ2N0M2JoaTNmRndtYkorSWRT?=
 =?utf-8?B?UklsejJOZnpRQnJVNGYxQXZYUStadGQ5QytSdDc2UGNsWk1YMmlSOTZyaUNt?=
 =?utf-8?B?RHhHU0x1Szg2aUNLaHFOUnNoZFNYM0pONnc5b3lDYjlKVnRRdWV0bmdVbVR2?=
 =?utf-8?B?U1ZyTEJnOWZwUFNJMzRHQ25lUFJ4QllONHVUNHVrQWVFbEt6ZVBKakVCOHNL?=
 =?utf-8?B?bHFhYUZ2T2srcGJxTHJUMHhGQnRDRXc4WTZueUZJTkd2SnhHcW1sQVM4SndR?=
 =?utf-8?B?b05FSjFGMW9VamZBRkthb1hLT0hLZjhRR3hmY2dCejRGbm4ydXQ0LzF6NTlN?=
 =?utf-8?B?Z0c3eGVtZFhKa0tucGplbTZKcnRhTmYxQTV0UjdZaWQxSk93NU53Y0NZWWJM?=
 =?utf-8?B?RHUwWnZzOFU3cVRRejJ2VDFJQ09KVmN0c1lLVWx5RWdxemE3WkxlT3lpVG16?=
 =?utf-8?B?Nk9GQXM5amlnL2JxK1owTnBNcHlGeTVTMVZaZWJmcVdtdFFPczBmOXgvV1kw?=
 =?utf-8?B?YlNveWhPZkhHN3VzV1l1eVlHbnlnbHNyOCtxZG1zK0NWRjdUQSttZzdFVmx6?=
 =?utf-8?B?dk1nSFBCSFlkcll2dmFIQzlXbk9pNjROYWMzK2JEVkxDMmF2MDgzdFMycHZJ?=
 =?utf-8?B?bEwrSXV5OHBqNkFSQWhxU2JPSld0Qk0rQmZyeUtDWnV1bkMwQXNEWW84Nldh?=
 =?utf-8?B?V1pGRWNJTC95blNZcDZPRGJRcVNtcFRoODlicjMzYlFFeXF2eDI5amxsL0VE?=
 =?utf-8?B?RnRMRlN2T0lYYTA2Qk40NVJvQUxYNTFqMHRIN01RK1lRSURhZVJTUkJBWFFr?=
 =?utf-8?B?YjhQcytVeXJlZExvUWd6U2Z3eC80MW5vdlorelpaRnZ5WmpRb2kwbzA0NDRX?=
 =?utf-8?B?d05GRXJ6N1dwNDZnbE0rQ2JrTm1FM2dWSHdtNjdLVXJvOE1TQzJBcGwwWm42?=
 =?utf-8?B?WEN0VjN4Um1VTTk4QUhBUktRemYyRExsbVNvZ2UyT0JJb0luZFZscVVYckFo?=
 =?utf-8?B?aHpJS2pBS0JSMGNqWmhBNE5oOFRzN3dEQmdKRXI3T1RqR2ttY0NuenE1d2NV?=
 =?utf-8?B?eVFkUWU5WmlZRFBEU2FCS1dIa0luWERFYWl2U3dFdUM2SDNKTWVsSHdLa2t5?=
 =?utf-8?B?L0hlL2RzZjM3N1FneWZiSWlFdVJLL21WTHdSaXBYdVJpNytGUnpvRTRUeUpO?=
 =?utf-8?B?U2wwYnRZKzdnQ2FIcVVseHhBdm1UOHlWdTdrOFRFeUM2ZThVK0gwVFlESUFm?=
 =?utf-8?B?NjBZek90VERZd0ZuLzQweEhJRkNlSFNwdUJJby9JUDJqTXdhZzFHMEhuUTRD?=
 =?utf-8?Q?ei5EQI1NG10aiHs8dbOil11lX?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	tPzss+30/bV/8ARp4JISmYZO8EDZ88GP4Mwkqj9dm9376/EikfLuWrdEg09wvof6C1f7yMCL+K+P0Reqz9PIiIab9JKXWSEL//KvBwkzQ2HR4mgsAq1ShiKgvbOsP6pBIA3eA3ClFWaCGIPaObx0v9LEeA1+i2KGkDoLxOg3oLbBs1OHGC48u7r9dhLsUdAAjLOk3h5BJIqxydUaX6S1W72Vllxr5yVccBdXEJtFDo7Chbzld0gphArQ+lR4S6rUsAsie6fSywshdcYgzZ+jPV1HYIfDYHmhnN3T1zn7fMjDnkWjP40LaXmkVd9LXzmoZRnYuPLuNA3gIDqillE7GKO9HHFjicyrtF1UHB/EUqVt4xokGmhTgMFkfJhD9xsvOOmKiSSh1t4RAnc6GbOvD/DkTftK33rpHdeJ1/Cdsje0bdb8C841T0IHVf4PzviMAeoDzMHHB/JMCqE11zVgLHeMAeVser+PUTpq6FlrmmYeEus7IckLZB5iEyse83Y/3zAZqyxVoW6OyZ0MuT1ACVXmt8yGGNRagSwCQjm/vePpxKTht+f6P8NaA4Hhy1iplK/9oMKfChhLUCUn3qxCaHasvoSyFi4xSeO0/f1BcS8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14b63d77-0368-4c3b-7365-08dd5c97756f
X-MS-Exchange-CrossTenant-AuthSource: CH2PR10MB4312.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2025 10:12:53.8943
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FyLEuR7i4+lDJtfz0EXjKTAQKs35J596KIubcGVFg7yaO+5QWyplT1OUji+atRwaRaFYmRittygp2Yg6itpwAw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB7074
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-06_04,2025-03-06_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 spamscore=0
 mlxscore=0 mlxlogscore=999 adultscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502100000
 definitions=main-2503060075
X-Proofpoint-GUID: DRskPooSjwm2gSWGLGgyyC_gvGfhWNVk
X-Proofpoint-ORIG-GUID: DRskPooSjwm2gSWGLGgyyC_gvGfhWNVk

On 05/03/2025 21:06, Jens Axboe wrote:
> The IOPOLL path posts CQEs when the io_kiocb is marked as completed,
> so it cannot rely on the usual retry that non-IOPOLL requests do for
> read/write requests.
> 
> If -EAGAIN is received and the request should be retried, go through
> the normal completion path and let the normal flush logic catch it and
> reissue it, like what is done for !IOPOLL reads or writes.
> 
> Fixes: d803d123948f ("io_uring/rw: handle -EAGAIN retry at IO completion time")
> Reported-by: John Garry<john.g.garry@oracle.com>
> Link:https://urldefense.com/v3/__https://lore.kernel.org/io- 
> uring/2b43ccfa-644d-4a09-8f8f-39ad71810f41@oracle.com/__;!! 
> ACWV5N9M2RV99hQ!J4rCZomS7jntxigOWFGkQC3hFMb5EZf3-aZG4hZCB6n_quTKHse9g- 
> WSxf46gMXpEfyzjaAQKTff2J9o0pg$ 
> Signed-off-by: Jens Axboe<axboe@kernel.dk>

This solves the issue which I was seeing, so:

Tested-by: John Garry <john.g.garry@oracle.com>

cheers

