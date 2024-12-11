Return-Path: <io-uring+bounces-5432-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 252EB9EC79A
	for <lists+io-uring@lfdr.de>; Wed, 11 Dec 2024 09:47:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0329F168A71
	for <lists+io-uring@lfdr.de>; Wed, 11 Dec 2024 08:47:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18C971DF723;
	Wed, 11 Dec 2024 08:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FC+W6Pgm";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="UcBJtdyT"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 503B41DE3C3;
	Wed, 11 Dec 2024 08:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733906839; cv=fail; b=MOO5VdqTLnqzHIJBVs5sXgwwVTK7bjDVI/p27jFelWhrBLME3KAxkh+tURFI8eCsgcr/MHaHjBU/WTkSwTTysA2GPpXc++SB5Z+GT+DeYuYzn00RhXh0MpK+32B139ZDIh0B3j7pzvZqykYl6u3lQN74fjxWyYfV9LZ7lg9uIuY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733906839; c=relaxed/simple;
	bh=brXq0YYgd5gUm20DOv+e2GFwpA/Ykx7mCkoRjLcRc0o=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=IWy4mrCZEUnDkDEmi9PXEq7LeOviFvMGJh3C5oqH1W61Tbgjy94Eo6ceOUJsx1YMVKjyYPaZtYW9nXmF1GVOe8XTo6bGijHlHoVJOTEZ3VYRc10ont0GC5cxLwFR4lhJIcCZatMlC/XJr0l8dzFrH7wqJEJakDBrX5m+QdDJg/k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=FC+W6Pgm; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=UcBJtdyT; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4BB8RaGh005464;
	Wed, 11 Dec 2024 08:46:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=EjPZenMQQQzce9bm12nCpuq0/amiUdOpHs58hljseV8=; b=
	FC+W6Pgmurl4u21Q2qcRuQZyGOJrSNxmAPka3G1BtX3zehcEV7fPm4dQ2zybMsoG
	aY4pcWylI/NC+yP8mM3RqhbRLCQkHppjckUNTZXjrEBc4SwQCY2WjjhTZySu7h2P
	tvl+73v+1RptfQk2hTyQ9vDTSEvYHgBxMNX7aHOdYz1Qeq2iHEuDMa6BqMyYUky8
	HrU1YzSmfN9FEROhk2ybCHQTZF46o/3iK9KcteCvqQW6M1shSCMPZAmzcub8IxKd
	WV/x+ogjEra/xu8WubZ8nkc+hR5EnHCswU3Eodn6UceEnqVGUrEhUaJo4m18J3Rs
	oTBDSmWCsoYkZW/IuNZEIQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43dx5s55xf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 11 Dec 2024 08:46:55 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4BB6GwB5034970;
	Wed, 11 Dec 2024 08:46:54 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2177.outbound.protection.outlook.com [104.47.56.177])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 43cctgwnbq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 11 Dec 2024 08:46:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xqw2QAZFVh0zVA7wCCtKbRz+AyNwAig8tsJC/7a+tjGBHFaD+iaOKs0Md2b6MAjhs6VAkaoj53/2gFPyk87znp1zS1bo196CPpF1xJvbjnNice1cKQSyTBsAChYqeXYi6IicSibK2/umIERdw0iPtNEu/Ts0IdpLNnWbBjWn7FiTSvT5I9sVk375GYhwmTEblfySaewqBFUYjh4dkHgAWnGcIiCNXuIYqY5Nq2BO1TEE0jM1YNVtQLMrB6TWnGSLfZSLMNreiseivEKgLz7uh8l0yPUjqxqbPP0J1keqd1H6uxFcodVgG89PNqsriKjm1S3Rkq/B6EE2i6e991uBTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EjPZenMQQQzce9bm12nCpuq0/amiUdOpHs58hljseV8=;
 b=DsT8FU06Ny5aA/ocGaHgnn8UJ+alx5ghh51/jz9tadFETU7mWNHMgsOuhKjqj1lo7ZJiuh+F4CxKgQcr/1D2HRyk08WfV8Em8aKIEpKgyW+PgYpIdaIDeghehBJqDYl0dmKNXx1oT7qZF4Nwi9Ntbh8dCJr/Fy0GYWKJzH2cPR2/A194COgxROKy36r3J0OQaTCczFelDySuXLpPijQxgkcQ8YhA4In8D/2Cev488vlFi5yddnugRnsuduERYswRfEdjPf0OHRQIn08IJ0iRSI+TTd3rrHCddP6zBj37tKtoeKZMw+hxdSS52008Fk1du9MUGqO4ttlUQcX0DGdUWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EjPZenMQQQzce9bm12nCpuq0/amiUdOpHs58hljseV8=;
 b=UcBJtdyTylUBhclLkYAzK2hXujaen92gw3GQHEAiv4GBHR0Uh45d/fH0f8JTRS5lbiqIY3e2SZzLVJQmE6+q7zWbplXrk4/VyHtsOC8Y6tq1DZzsjiZjMlq012i1nLkkneEzUNPG1dbzJEgvooM9779RkcfT5+7OAr1WZvQciYo=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by MW4PR10MB6297.namprd10.prod.outlook.com (2603:10b6:303:1e1::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8251.15; Wed, 11 Dec
 2024 08:46:51 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%4]) with mapi id 15.20.8230.016; Wed, 11 Dec 2024
 08:46:51 +0000
Message-ID: <cfa26853-7386-4d7c-be51-898800f7c03a@oracle.com>
Date: Wed, 11 Dec 2024 08:46:47 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv13 04/11] block: introduce a write_stream_granularity
 queue limit
To: Keith Busch <kbusch@meta.com>, axboe@kernel.dk, hch@lst.de,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org
Cc: sagi@grimberg.me, asml.silence@gmail.com, anuj20.g@samsung.com,
        joshi.k@samsung.com, Hannes Reinecke <hare@suse.de>,
        Nitesh Shetty <nj.shetty@samsung.com>, Keith Busch <kbusch@kernel.org>
References: <20241210194722.1905732-1-kbusch@meta.com>
 <20241210194722.1905732-5-kbusch@meta.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20241210194722.1905732-5-kbusch@meta.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR03CA0075.eurprd03.prod.outlook.com
 (2603:10a6:208:69::16) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|MW4PR10MB6297:EE_
X-MS-Office365-Filtering-Correlation-Id: f442e744-3463-43c3-e288-08dd19c05b0b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MExLVWxZNGFsNmFFOE56UytOaktBTmFIYWYxbk5YNGVIOGNqRktKc0NGdFNW?=
 =?utf-8?B?b0QxalBpWksreVVaVUdhNU50MFg0b1dNZXF1aTJjTWdrZUpUWDU1L3Z0TWlF?=
 =?utf-8?B?dE9iOG0xRmI0Y2tNa2M2YW9lRlE3V2NVS21WV3lvaTNiNnpLNkZBM3kxNUVx?=
 =?utf-8?B?M2hxdkIxMTdYb0Y4RlMvYkNLMEEwZ2lSd05yb1AxYjdrc1dKSEltZ3FwU1hr?=
 =?utf-8?B?VTg1SW1FZWw5d3p1eTh1MGpjNTVSYkV1RVN3Z0N3UEhFNnh2djBYbEo0Qjlr?=
 =?utf-8?B?d21lTVNwSmRlajJSNWNFdHo1cHR6SnJsOXpuVkl5Yy9vU2ZuOWs3OG15aEkv?=
 =?utf-8?B?TVVUUUxmRkRXWVpsQzhUMFhnT1Vja0ozcWwyb1ZibmJjSkwrWXI0bE1YeWJO?=
 =?utf-8?B?dWUxL2ovWnJZTk13cXdubWxHb0VnVDdVc01yZGdKNktvWjZZUkpvWkhQSXJY?=
 =?utf-8?B?R1VDWlBRVjFVRWVDYUtXZFdKOVBNS3NFNXN2QVdycmhTN1hsYk9hbDBzTkZI?=
 =?utf-8?B?TkNKWmNRSEZGN1NrYVhubldqK1FNQ0ROZHFKa1JBYlNpM0ZHV0hsanEvSUtW?=
 =?utf-8?B?NFRJbldQWW1FZXRXTGdEMzVaWXZZU1U3M3lEanZXT015dWl5TlhZcERuampp?=
 =?utf-8?B?WHFabDRmRlJmbERMMGQ3UUt5am44MmJmaXBQdXJ5SnZjaDV1d1NNZ0ZvZXVv?=
 =?utf-8?B?WFNDTU1DdXFncDFjMXQ1OEh1TmU2S1lIQnpXZ0NYZjB4MHc0Z3VIOFh0T0d5?=
 =?utf-8?B?NjVoOHpiQWRVWWJkRzFRMW9IVENjZkNNYmNISllOMFZiMEhaRGhuZHhvckVG?=
 =?utf-8?B?cVFVN0ZsTCt6UnZPTkQwZkJmSS9qQ1NOSDRhbWxhTFpDbk45RWR1WjFqRjRh?=
 =?utf-8?B?THlNdEVockNrQURWdnhQd0VKUDNOQWs3WmpjM2ROc2xCUTl6T2k4K01WelRu?=
 =?utf-8?B?SytSWjNpdnZySjZZWThJWERobFdJZHVsRXNLNUROa29taU9Pa2lXY1pHVzh3?=
 =?utf-8?B?TGFXQVFNem5UQjVYMnIrbXQyR1VOc1N2c1lXYW5qTVlaRndNM2tnaEdBMlRW?=
 =?utf-8?B?NEpsN2dYMjdtcVpOQktsckhKZmNZM1MxQUNOaVVEV3RZUms4VW1tNHBzMWxK?=
 =?utf-8?B?SHE4aDl5U245SXMyS0s1aTlBaWlFY2lwRGZxaDBKNTZWRTVUbXBtZDZBYklI?=
 =?utf-8?B?NXZnTGRPV2hna0lvR05GWVIzanc3bHh4djcxelUvQk05SUR5dk0zRVhabGFK?=
 =?utf-8?B?dHE3WjYzaW9uYjRjNzhqNHZmZzE0Zk15alI5SEgxVHFkT1U3ckE4NjhRc2M1?=
 =?utf-8?B?djJmcENqa0NkV3Q5dFkwMS95UCt3Q3RQRSsrNmdPOEZtZVpIekhHZlBDU0JL?=
 =?utf-8?B?SE1hV1dvblpuRm5xNy9FVFZrVHMxTUJTLyszdnV5ZWNhVEhCMGRUeVBMRHBy?=
 =?utf-8?B?R1VMRkNqTW56cWloTnRXbFVhMENpVGxrcmtJTVRqYlV6TDkxanc4emY0TlNk?=
 =?utf-8?B?UTNzL2RjMlVOdmErbno4Z1o4WVBPemMvVGZrTWtIclFaRXhCeWprTTdub3pV?=
 =?utf-8?B?QUdSSHpldVFOWitKVUsydDhIZVJHS3hDVEhGRUxBajlTR1dpa2M0dnloYXdN?=
 =?utf-8?B?YjM3eVhQTHhYMTdPVzFDTStSWXdVT05mQUVVUy9YdVB2SklpNFVKblV6Z01D?=
 =?utf-8?B?eWdhcVl3ei9nWDVKOStnalVaL2xRTmdmOW4rYzBrUGoyVlpNV3NxU1ZyYWpN?=
 =?utf-8?B?cTUwNDhPQ3VJZ3EreWJEc1VYclpJa3VadEJuRXZlTTJFZStwSnVaeHhoeEUy?=
 =?utf-8?B?Q2tIbldRQndRUDgvZ0tYUT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cGRYaEczaG9zaXFsSWJLbVRpNGd3VllMVC9FVlU4Z2hpR0RHQ1NVbWV2M0lC?=
 =?utf-8?B?cVdkOG9YVU51ZmpIUUV0eUlqSGJyVkhYTW5DM0RxaklUVXdVT3Q0ZmI5U0Z5?=
 =?utf-8?B?NEtUTEVkTXVJRG5BckdocVhoaS91MjlaNmF6ZkZ1YVpyT2QyaVBHVDNwWDRG?=
 =?utf-8?B?cTdDdUwzUkpoSWh5VmJpd0g5MjhOUnR1K3FWTFJUVmg1amdXckF2MlFnMHFu?=
 =?utf-8?B?NkRXTHVMSWJvVjFxdWVSdlU1L0Z2c2hKUHQ5Y3B5a0ppTEVvbnZpUGMxL1d2?=
 =?utf-8?B?MExhZGtSWFk4aTZFSjRJcWRzVkFJZU9kQXZNcS8ydGhxNk1ZdWM3RzE3am1X?=
 =?utf-8?B?NXBMaG1kdDhUdG8vYUdTRUkvcTFOSHU2YUFxWlNJeThWZERaM2J6M0wwQlR3?=
 =?utf-8?B?SlJmL1BhMGNsREpkTFNUYlM2U0UyeDVyanJlV1d6Q0J0d3VrZlJxbm5SSERh?=
 =?utf-8?B?R01IaEQvTVB1enlOZHJDNjlpZlJqck9PQ3hoeXY5TFBobi80eUljVjhaYVBS?=
 =?utf-8?B?VXJBVnEwb1psWU50b2NUNFB1NTUzVHA2aUFmMEtzOWxxTnBOcHJZYmorWFhS?=
 =?utf-8?B?NkxBdWtSL2dOR1JUVGJMTmNyd0hoeDVpdEpJZmErcUxXZTN5K29kcEs5RCtV?=
 =?utf-8?B?Snl2WXFtekQxcmFRS1YycnZHakpWSXBqbzZQamIyNHJIeXBHZlMreVdGL0ly?=
 =?utf-8?B?SnM0UG4rNDJRRTdzWjQ2dmZ3cmdlc0N1c1NXenprM2pOVmxmdSs3RmtxZjhz?=
 =?utf-8?B?TE9BbDhVZmJxSFZQdkVtbXdjQUpPSjhoWmtoMG1PUTFRamh3WGlxU0pzYk1o?=
 =?utf-8?B?QWJUbGN5YWlUU2FTbFh5OVp0Lzc3b0NRWHpYSXVDc09aZW1qK0pON3RYSmsy?=
 =?utf-8?B?QVRJZ09QUHBGMWh4SVMyTURlUjJFdlN4dWNpT1ZncjlyWTI3WmhrTkxIK09E?=
 =?utf-8?B?MFpBaWgyNDZxWk52c0c5VkREUVlvL1NsZzUrTUxvVnIzT1RjTndvOVdRRjZL?=
 =?utf-8?B?YTlETFMxM3ZXWWNINnVOSkhmS3hGNldMajJscFNHMDFSdlhuOW9hdmZrcXdV?=
 =?utf-8?B?dWUrMUNXTUVtZTZPdUdoQ1Q5Y2k5Z0dCVGNlUHJ4VzZaQzliR0FqcVEzUmpH?=
 =?utf-8?B?ODVwTnZEcW9PL1hmbjNSaVpjbDNMQmtOMWRQRGFFbFoxcVdOeHBOQmp1QlJU?=
 =?utf-8?B?cHFXNW1qa1JMNVRXbXU5Q0NEbi92OWdQdEl0TW1PZHc4b1YzTkIwZ3NwSHNr?=
 =?utf-8?B?ekFPT1BjRG9ucUtwcWlXem5ZNlYxZHdkOXVEdGo5Sk5rMjJ3OEx2NEpVWEYy?=
 =?utf-8?B?WmRXTEN5TmxReG1lOGhGUmpOMkxUckYzSTFlR0NYTXNMVUJSMjRnaFN4ZTJt?=
 =?utf-8?B?eWZnQitOMDEyejV3VGtlK2s4ZGpTb1RIYlorcmw3V1ZIWUVhTnVzbWlSRVBV?=
 =?utf-8?B?cjZwMGM4bWFqRFlXUVVNaEk3MW5jWEpTSHhSVWYxblZQR1FwNUNZSWExWmsv?=
 =?utf-8?B?WVhTZFBVQ0xrUHloMGpkSUwvT2R1ZFpXc3hTSDVrVE4wTDEyVDQ4OC9GS0lm?=
 =?utf-8?B?M3VDVTJqY1F0SVVCWHV5U2pWY0xnUXFYQkFNTTlsTnZxajBHUXFWU3d2ak56?=
 =?utf-8?B?am44ZkVKMHJYc21CZzRDa29yRXNTTjQxZk5FR2RFUGs5REJ1K2Zod05zMWk3?=
 =?utf-8?B?Qk5tSnd1NjdNQUl2WktnYWZUV0U2VnllWGJibm5JaC9QRkc5dVREdkEzZldR?=
 =?utf-8?B?a0V5cEl6dFNHNkdjaUJtdHhBS3Jmdk90OHRVVnJPWE42ZURzeTFialFGbGNk?=
 =?utf-8?B?eGgzcURBU05EbzlJeFpRSjlKZG1MbjhVT3ovZThzYXVRWVVhcWwwS3VKdmo1?=
 =?utf-8?B?RnBJZ2VpcDhBdFNFaXV2akxwSkNvWm9FK2NwbW9yNEpmN0VRek5Vd0ZtRzUx?=
 =?utf-8?B?OUFKTWZEMzdHNmtOUlRwZ095NlgybWxpSXJ6NGowZDYvODhRWHc5aUJ2ZG1p?=
 =?utf-8?B?eW40YmFReWIzc001bVhyc291R0c3OTFsUlJSeXBPUU1pajdqN2dROW1hK1Z0?=
 =?utf-8?B?djlOSlFPM0RMQWF1TU5WbTQ4NW5iVGlSa3JiRVlQZU1EZFhPd1lCRUFuZWJl?=
 =?utf-8?B?ZlY2QjZpTklJd0kxMnU2Uk8zRUxTUEhkTU9zUzlpYS9zZGhRVlRyTThBSlRW?=
 =?utf-8?B?UkE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ouNSTcHoRg38n/rxGritFlAB7WmkW1YAtWyjqqQv9JVvEAlP2cXQke1cDUYNhJ287dh8XQAM+TgZcSE6Khc6RM1sfWfe8VcQf+TJly6oLdjRcd5GbCB1sIFzRrWTeEjlcbay01Mq3KubF65y3oEWdoogugr3FzMIxH/vExa+kG9hLy9kp8SQuiEikpgbK8o1NMLb3iUhwGmepxGkxzH9cQVUg2tgk8wdq3ZCVWKeHM3S2t6g2A3L5segCEuR0Kpi3zs9AHfit+6HDupO03MI7iwZcqjauAvoaHJzw1ULyMjCAQVm2bQ56D/E+v9eluMxZpQNmeBPZgNKnrH7QNJMtzV2S4uaT5Fzf5sa6pNwE+BXRFn3ur+ScNZF2Be0mz5DTiuGHpNUWDg+Qy9KssvblY9G4Il++4Hfm9CbA9UzYlcQwpXbP3FoQ/yPg9J4rTemimazAVsZ/vFaOai7d4zjwWjTCDZPKH8O0tHVw4lr2pZywfwdCOFLamdwRg0MToJkClJPXHG+u6DvK9n8I3D+5yG6q/HmNo1+MoNcYgxd0Yi0tweIY+Iow0mt64e8y20UY+x4c04wv61jFz/LpIYIeQe0F9Cbmve/vCu1jEMQmMA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f442e744-3463-43c3-e288-08dd19c05b0b
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Dec 2024 08:46:51.0602
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5LYSPlNlqrjB6FJVVgStYGwf0iynbvKhGyjf+p38l4Qy/b16Twl8nLVb6fiuiqT/XBegtKeIQ0X1A6B4FWGCBg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6297
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2024-12-11_08,2024-12-10_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 malwarescore=0 suspectscore=0 spamscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2411120000 definitions=main-2412110065
X-Proofpoint-ORIG-GUID: JOhV3NZ_y_OvRrgF8B9e0lZ13QSUt9az
X-Proofpoint-GUID: JOhV3NZ_y_OvRrgF8B9e0lZ13QSUt9az


>   
>   	unsigned int		max_open_zones;
>   	unsigned int		max_active_zones;
> @@ -1249,6 +1250,12 @@ static inline unsigned short bdev_max_write_streams(struct block_device *bdev)
>   	return bdev_limits(bdev)->max_write_streams;
>   }
>   
> +static inline unsigned int
> +bdev_write_stream_granularity(struct block_device *bdev)

is this referenced anywhere?

I see that Nitesh mentioned something similar also previously

> +{
> +	return bdev_limits(bdev)->write_stream_granularity;
> +}
> +
>   static inline unsigned queue_logical_block_size(const struct request_queue *q)
>   {
>   	return q->limits.logical_block_size;


