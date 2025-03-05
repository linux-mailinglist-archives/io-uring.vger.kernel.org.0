Return-Path: <io-uring+bounces-6969-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B98D7A505CF
	for <lists+io-uring@lfdr.de>; Wed,  5 Mar 2025 17:58:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 95EF51888D78
	for <lists+io-uring@lfdr.de>; Wed,  5 Mar 2025 16:58:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FC1B1A5BB5;
	Wed,  5 Mar 2025 16:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="e6dF56A/";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="U/f6KGU1"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19DE0FC0A;
	Wed,  5 Mar 2025 16:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741193890; cv=fail; b=o8qnS44VNS8pQ55w3xuV759xs+Dvdido4uM+JBWs1mw5epguLzDvzXpTWUvGnPu7Nzw7bxPiWZDxYc9hXnpg4+PW9eJTIgKHUI1DIHsSOfAbrlsnrc9C8h6bun5sC64gwKCQGfVOhP5tnUxbajR0PXxUxL/AG1vAWVE4Mfg3xUs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741193890; c=relaxed/simple;
	bh=049zH+sR6KROtTKRj9MXsq6qZ3gaJ3JgYyAGEjHbm0o=;
	h=Message-ID:Date:Subject:From:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=K0gOXolNiAQMIkyd/OGUUsDX6hRxQ+zFjs3Md1FFFNs9jDXwvi/ICsEwZoEUifX0lOmmWnZ53764RVV9Ln1Yl8HmYwY69Io82vvGiEk0R8/cas/3ddoguF25Jy1HYtIeh67duyAvIlJkRkV4lCnC8XI4CkiLljLuSXsAoL2bKHQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=e6dF56A/; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=U/f6KGU1; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 525FtgHE022229;
	Wed, 5 Mar 2025 16:57:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=Q9GFChd+lc/o1eNgQOfZuyvhlBlB1H+12djqubBBzS8=; b=
	e6dF56A/I5G1ckZg4Zdqw5pg+xkvBN4NplXuF4M8vxTPeWj2yWeM49l2vRPq9VvA
	FJ+TSQL0Q3e5Mjir363t8D1K5zmj8njPMUJOSpCIZwC9v4FIupzSVBjir1ddKq+y
	F7j+RE2MWsxusph/Yfh1lyQFouWeCG9XzFy1j8PEXXAUamTOxTyeKPfTO9eLmigT
	RqFwbChLqQu+M5x4UU10UoY4hMVMuAtnFFf6/cbzDsB4k/9MDTLpL5ohmwTwvcnH
	GzwekAqr5ie94L3HHZEictc6xk+ImFfdLzXAj8tLRlj1wDYnmeZN8ZtRsTEhcOHr
	iuXeQyWx6Rzhl5tcY1x/jQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 453u8wr1ap-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Mar 2025 16:57:56 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 525Gpddi039763;
	Wed, 5 Mar 2025 16:57:55 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2172.outbound.protection.outlook.com [104.47.59.172])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 453rpbbstg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Mar 2025 16:57:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xXtAEOPaZ0qqCuVksy/zALy2U8jAT0kRkBbFjb7pG1KpQRpkn61nCpprqx25rNLO8txmvtLLI2C+sub6Ss9SALhYRk7rRpclsg497xGal4t4t5aMHM51QlahXBIIuTSqdn6fSpsqyq6KPHshhAJz0m8GuWORqgXv4nmUTTgZSt5UXHqryTSVfG5ahgAuIrOQx8a2FuBKjYxU5S/uR6I6qpuSeQ6DobvhG4SUa13PAmSt5kxaHK+i9x0nzqX/l1GnaahIoW6nWh/JxoEMJMYz+hEil9/fJCGf1FTj7JQPC4splraxg/Zo2Z7XWOUgL3mMDatFfXz6aDSpBR5B1YhUmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q9GFChd+lc/o1eNgQOfZuyvhlBlB1H+12djqubBBzS8=;
 b=Yj5CZDa0mROm1HZLisTu9BduZBOMMMFR6Qasm0Diq+/1t1sE3CpWSI4Da1O0/Fk2aoprQ2cTbvvboow/erLTfdFrcZcBycqUIgDx17JmOsyxBFLGjMiWwYIPMIhDT9DeouaUMs+QtJsK8dfpIm4/6TvgzHctsYH7ip+GQXmDvPAsYTN1LWclrXanjB8T7UXMUbCq8TeQQH1RRTqcSrOsVtol/8UfyWujP5da3ffPJjK36uZU1UxiNatGLadf8Oj8ZZKUZtd4VV6XJAurqCKweuTrmzPScPjsTeJCV2pGzhEOueyGbzvxIh+0vK6K6wegGYpoRMfvin8Iy7piWMRfCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q9GFChd+lc/o1eNgQOfZuyvhlBlB1H+12djqubBBzS8=;
 b=U/f6KGU1td2mCC8TWAU+jnrYPujfOjTdDYmHV3+nczh4bOBiFOlUB5Vlq5wvZpP+QUa1K5BMjVIlAggkKqeC0g+y4JqA9drhtpZ2h7N4wTiIAEyGMEbIlEryIlUW/s+oEOwVdEl73ZF1bzu2ghri0L2vAJpGfoM3MdP41OjyzqQ=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CYYPR10MB7606.namprd10.prod.outlook.com (2603:10b6:930:c4::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.17; Wed, 5 Mar
 2025 16:57:53 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%6]) with mapi id 15.20.8511.017; Wed, 5 Mar 2025
 16:57:53 +0000
Message-ID: <c64a86d1-36cd-46b1-82fa-4ac4a4cf9cd2@oracle.com>
Date: Wed, 5 Mar 2025 16:57:50 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] io_uring/rw: handle -EAGAIN retry at IO completion
 time
From: John Garry <john.g.garry@oracle.com>
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org
References: <20250109181940.552635-1-axboe@kernel.dk>
 <20250109181940.552635-3-axboe@kernel.dk>
 <2b43ccfa-644d-4a09-8f8f-39ad71810f41@oracle.com>
Content-Language: en-US
Organization: Oracle Corporation
In-Reply-To: <2b43ccfa-644d-4a09-8f8f-39ad71810f41@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P123CA0233.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a6::22) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CYYPR10MB7606:EE_
X-MS-Office365-Filtering-Correlation-Id: ded87e4b-2b00-4e92-c64d-08dd5c06de78
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WkZ3bFh3bnNBazhsYTZZS2RYU3ZBcnorNHdqMlpDMmFkOTBxLy9TZG1ESmNV?=
 =?utf-8?B?eDYzdFRYdDV6OFZPdVNFZXN3WnpuWGRXM054SDJDOForcG1nTjEzWXNGRHNZ?=
 =?utf-8?B?Sko5S01kajFEbzFUQ1N6NHB6TE1UQndhbE5iYy9aNm9sUE1zWVh5UlFWaGpq?=
 =?utf-8?B?RTl6NjlubjdSVHEzTWIzY1Z2YXNydDZ5WEhYVDRNNzc5VEZEdjdRN0pzOEx1?=
 =?utf-8?B?YUNmNVR3dEJBbHhkMlhTQitiWStyaEhLY0lCemFLT2hudktnbzM0UDZicFEw?=
 =?utf-8?B?ZVBlMWNnYVNBZXZpMHBieC9rOWVVMjNMQXA2UUpmOVNyb0VVaFhUb3JFQldm?=
 =?utf-8?B?Y2NJQ0psRUVEZ1JtTjExbDhtNjhWUHhScFEyd2pQUWFla0FBYVZNL1NTL2xH?=
 =?utf-8?B?YlhiTUh4RkxDWlQ3cWFtUi9PVC9KNFFhZ3h5WXdlaWEzUU45L0N4N1ZmVHhC?=
 =?utf-8?B?LzFhNHVSd3g0UDNrVmRVbWJOZ2lmUGxlV0UvY1lXdVFwRjVuQ096REVvR3RN?=
 =?utf-8?B?ckRMY0d3Sm1qOWg4OFBIckJvK0p3MUlTcVErUmpiSFlSZThyWXAxSy8vVWlN?=
 =?utf-8?B?dTU0Q0l0QTNsUjRsVVhPelBmL1MyRGVMMFhDbzVtc0FSbGNyaDBKSVlaa3Qy?=
 =?utf-8?B?WGlCT25JR3Q3R2JDVVFpY1NCRzFvaTFuZWZvdWtkRVYzYmF6VGxSTGRoNm1E?=
 =?utf-8?B?NkZmOC9wSWtkR1owWSt4VmVGRUE0RVZhNG1DemVGbUU1aXNDTm40b3NyNTJp?=
 =?utf-8?B?TjRUKzhkSWE4T0Y1cUlFemJpT0hmQXlCcXUwT09JYVVaT29GR1pOZlo1V3lT?=
 =?utf-8?B?RXhHM2Z6VCtkYUEvbGFMbnVQMzJKSDd5ZEY5UURJQU5OS2tTUUxOSUxXWUV5?=
 =?utf-8?B?SzZ3VGx4RzJqNHpEQThJWFNMZEZKQVdIeXZwbHEvWkJtSGVKeUYyRmJDeTVS?=
 =?utf-8?B?OHhDOTdGL1NrUEFBY2ZqWWxaZ1lRS3l0K0x2SUxBK2dXaUxRNVJDV1BpUUdv?=
 =?utf-8?B?eHExMUYwSHR3czBLRW1YdnBJRkpGc1VIMGhYNDJ1aDdpNUpFTEhBZmVjUDBV?=
 =?utf-8?B?ZEJpM2JVWitTN0M3dndpeG5XNWpxS0U3akorNVQ0UkVWRE9MY1p4em0xTncw?=
 =?utf-8?B?Y3ZGSmhHaHRBZmZ1Y0h1OEFpWmxob0x1bHZUWkV6S3NVT0hqNVRFZTBQdVE2?=
 =?utf-8?B?dFc3eDJwRXFDVFJpUnAzZGg3Z0tGY3NpczRFMytxOVl0amtKOGlvMzhFd2Vt?=
 =?utf-8?B?Mi93UkNsWFJrY0xtTFhPWkxwN3JpYUY3a0g4RzJubm5mSEI4NEtNZnlOK3VU?=
 =?utf-8?B?UkhoWGYxWDV6ZzJ6enkzcXlkVmpIa0Uvd0ZYWEFRSE55QWxEZ1U5cExPVTJq?=
 =?utf-8?B?bVNjUlRzNjlqWFN2MzlMZHdHellsZlVtUGhzUTdWbzN5NVRFOWNwZldBMGlj?=
 =?utf-8?B?a0dWMXpUYkZkSEI0bVJyU3RmQUxTcmtWOFVIY054Rm1jQnJ2eVpQSmc3UE1r?=
 =?utf-8?B?RVVYNGNYSDNKZHRmTm42L3NaRkF6UkVhNFBkUTZFMDBIT09UWVpINkU3NXVS?=
 =?utf-8?B?aEdEZXcreWJNdWZKSWJhYkIrN1dPTktJR0hxWHdPOHNqN3g5K2xjbGRjNVB2?=
 =?utf-8?B?V055RU9CYXJOTjVDeFNmV2svVjRQUjhkQmtlYmdSWXhibG9IcG4xSHZhS2xM?=
 =?utf-8?B?VWhKVHp4c2F4SlUyS3BVUGhITXM5RnRZRkJXbmg4YUxMZW9PWi9jdWZJU01j?=
 =?utf-8?B?Q0V0eDZQcWpFMTNsOWJ1R3hvMkw0aUpzNmQrWVNNc3FkNUViQjdwT1JSRmlo?=
 =?utf-8?B?Q0R6QkpOQ1pKcEpBWXhNNzZaeDRRNG0zNVZvamlBN1Btc2RSTkNyNGQvemNk?=
 =?utf-8?Q?rmPO2P6zmGtCv?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bmlZQk9ydmV3MWVhTldFZHJ2S1d6dTRNcFJCQk1kelp1QVN4bTljY21aMGd5?=
 =?utf-8?B?ckRHUjQyWHBrRnVLcmoyTmt2aW13MjAyRFk4elNkMzk5M0VvalB2WnQrNVVh?=
 =?utf-8?B?TDNVUWJUUHk1N3ppM1IxZWhDNkdVN0lWOTVwUllOaStNREpUVjJDQ3ljdEsw?=
 =?utf-8?B?bVArNTZWTG4rV21sQS9JcTZSSURpbWZFSnYxN3ltc2Z2dDhjUzhqVXlwYitz?=
 =?utf-8?B?dnlyKy9lY3hwdTR1RDlJaElZWkxvcjM3Z3AwNGg3ZGRuWUVXS01OMEE5WElR?=
 =?utf-8?B?RlJEVnBaK3VKR3FEZStWMEtmb1JTSnFlc1JJK3RTd2hxbVNQVUxFS3ZSS1Fz?=
 =?utf-8?B?bzJrNEl6WTZCSHl3OHRaSTE3R3JOb1ZPUnVtcUV4TVdWNG0ycmpJRGxiblJk?=
 =?utf-8?B?MEJYbDFzNy9UNFFBTCtHSks2cTYxUTNHWGxPV2tNUmRJc0h4MlpXWDgrdlRn?=
 =?utf-8?B?VnBucmVlRnJjQndSUjV1aW1yOVBCQVNIR0dGdDNNcG4yUE1SajFwanRCc0Ro?=
 =?utf-8?B?U2FiMkVPSGc5UkgzQk1OcVdlOGRtaXZnQnJSb0pGV3V2ak1CR05JWHkzNXZK?=
 =?utf-8?B?K2UzWm9wVy9DVzNaTFhVRUh6NmtJS2dObk9peXN1cDBnZ2J0THF3SDNjYWhu?=
 =?utf-8?B?anh6cEsxWWM2a0lvek5wVTd6UzJZaUsyNE83dG1Kejh2ajZ4Rllaa1RBSTRH?=
 =?utf-8?B?cHdpYSsyZk5RSWZ4Vk84eTVZTmpYbEZoZmNQVXpSOWVNaFBNMWx4WU1FeGhJ?=
 =?utf-8?B?UlhZSk9IMm9vU2pWWkMyUlZkTE1PTVg0WWgzaDZiTmdYWGp5UmlwRGljVmF0?=
 =?utf-8?B?SFJ5dVNTYlNOWDREbmZCZVhmQWhHSENPNVpPVDBuM3ZzbmJZRUR5NldIbEts?=
 =?utf-8?B?d2Q3bUhCdk1rWlI4KzRlTi9lbi8vZENpOXRDOGVvZTRaU2ViSnkrcFhyUktX?=
 =?utf-8?B?T1dQOGxUNlpOYm5IQmlRVGw1OG41LzhiVjRBanhQVXlJOFlHV2hJbkN4Zm9q?=
 =?utf-8?B?eW1pK3ZGZzRGL0YybjZaemIwZnhiSmdFT3hyTHlLc0RPQXlkekswNEtqVVdT?=
 =?utf-8?B?TVRIOWM4TllrK1FaNHYvOGRjakNZWXJOYXl1a3N3MG5tRVJOdStlbUF6S09v?=
 =?utf-8?B?aFg2N29CbXAvREtOTmY3aldmMlpKL1NTaExLRWFiR2dLZVIzSjhYczRKdng2?=
 =?utf-8?B?ZEdLUUd3YjdaVWhnWU94aTNCREpkRGw1emt6blA0MDBOMkdoN0wyc25COVkz?=
 =?utf-8?B?MEhNVHZWMWZ0QXJqaFBxZWhJbGJNN1JqOXhOYWl0dG16Rm9uRkwrM0xDT3lJ?=
 =?utf-8?B?cTV0YUxLQXV0VUwrUzVRZndUczRPaFVoaVhucE9CaFZ5K3o0RVNaZ2p4RnhO?=
 =?utf-8?B?YTEycnZWNkREWktXSUF6RXhFRDU2cWVYL25rRUV2b1hjZVhFZDhWODlaa1k3?=
 =?utf-8?B?Y0ZtWUp2NHJ6MmNnWVZwS08wdzFvUDlYanlySHJ4VHNNcVpETjhXRnp5R2Nt?=
 =?utf-8?B?MEkzK2YrOE5oRTM2bVpZNDRBNkpCMGlCaGIyRzdhNW5MVndZTE90UWovZ3JC?=
 =?utf-8?B?STZUWE5OZUdpa0k1dnRFRFVRb2pwY1BxTU9VYnVySWp2NmIvMGZWRFZLNFVl?=
 =?utf-8?B?Mk9jdEo2cHdiNlQ4OWpzeUNQK0VnNTkxWCtXSWdsblVmZUJoSElKOXZiZzFK?=
 =?utf-8?B?TEpkcjJVNkFLNXJUREpvTzRUSUF2L1F6UHBCM0NtbHRXUkVNV2lnWFp3b05s?=
 =?utf-8?B?SjBoMjEyMnU0a0g5OTU3bVkrSTNsWmNzMDNJTFRHTWFFZGZoRysvYTUxRzJW?=
 =?utf-8?B?UjBOdit6VHU0aEx6bzdWQlZWR2NjM2lPVE1VVnQwZG1mNVhpZ0hIREZyWE9J?=
 =?utf-8?B?cVZzcitNbTd5WU1ZVkJzbDJnZCtUV3JtTW56L0pGN2lYZ2xSc2RCYlZZbHVo?=
 =?utf-8?B?VFgyeXhrZmtiU2hpUWdaakNkcnkrdnZqVGh6RG5rSnBDVWMxQURFMnJWdzNX?=
 =?utf-8?B?WjJqRzhIdjRuVDZtcXkzNTh5WkZsWnRBdXBpUUt0RUQvWG1Tb1VjQWExR2p0?=
 =?utf-8?B?dFAzOHVoa2I4VnN0RytXRHhZME43ZlFqTG05Q2RONHhoL09heEwwQUtkRzJX?=
 =?utf-8?Q?yhqyu5FGisRt9gUmHX5ZWd4al?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	N9/UAXF/bntMfdarwVyzB4EQn07jjGjfbk/Lchsrpnm3vaY4xkeVvxsfwwOZ4j+oh1vZ+bOvjUPkCM4dr8lCp/usywtI+jCd4WO8Cj8J6aylh48bqDBNL7Uo0UDgSouzo/8DLLyeFPyC4ryCmx5mVsNmBQQDeVXjOa/r2NwIANhMJTdUQt0hBEnQHT7SkMVAA5VhklZycKKnii6r/ASPDCoIyeJKETrfH1pF/LHZJajZLCQJJAsmxGvVNHHhxyIZDFOw43tVilyyvouyFvT+G+wWZA1g1j1gfGiynAfpOJuMondaWDCwIR0oqCkh7csTOL2nyJMh2o4uF3J0v0O2sSbKSN1HgMQeknxLs7qNHYGHmAn5116zL473Xl0UdnMJEZGdp1CqCocwj4nUAur7mgHJJmdakeU7JUd3StCKb4DRWhxeP4E4KhZGuuXlaIdMGmjWDNzUJP6lg3xQ+fIiJEzAGsnus3Sj5HnuUfwRvvNyWivhRI40MJDi4hUYqk6wa/jKHaavxJYqTz29BhWLY7NB8xGc1erMbhNF6CcIHyCxZm7LWYvvNHhlHwZeXe6W6P626rmJIzxNit9VawhWjHobtzwYYwwpb8xrPOyEl2s=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ded87e4b-2b00-4e92-c64d-08dd5c06de78
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Mar 2025 16:57:53.1012
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1kDCbQ64ecnuwNt9o9sakJnM3vBJCVdsiNgtmEXY/Rbg9SlEKZM+AnPsTHVDRimV2Q2PlwkQ6gKIyioCp87uKw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR10MB7606
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-05_06,2025-03-05_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 spamscore=0
 mlxscore=0 mlxlogscore=999 adultscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502100000
 definitions=main-2503050130
X-Proofpoint-ORIG-GUID: 45ImEszswt8yzbGwyBJxsV3iH9qygA6O
X-Proofpoint-GUID: 45ImEszswt8yzbGwyBJxsV3iH9qygA6O

On 04/03/2025 18:10, John Garry wrote:

+

> On 09/01/2025 18:15, Jens Axboe wrote:
>> Rather than try and have io_read/io_write turn REQ_F_REISSUE into
>> -EAGAIN, catch the REQ_F_REISSUE when the request is otherwise
>> considered as done. This is saner as we know this isn't happening
>> during an actual submission, and it removes the need to randomly
>> check REQ_F_REISSUE after read/write submission.
>>
>> If REQ_F_REISSUE is set, __io_submit_flush_completions() will skip over
>> this request in terms of posting a CQE, and the regular request
>> cleaning will ensure that it gets reissued via io-wq.
>>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> 

Further info, I can easily recreate this on latest block/io_uring-6.14 
on real NVMe HW:

[  215.439892] cloud-init[2675]: Cloud-init v. 24.4-0ubuntu1~22.04.1 
finished at Wed, 05 Mar 2025 16:48:44 +0000. Datasource 
DataSourceOracle.  Up 215.38 seconds
[  371.784849] 
==================================================================
[  371.871354] BUG: KASAN: slab-use-after-free in bio_poll+0x300/0x4c0
[  371.946393] Read of size 4 at addr ff11000170f75b74 by task fio/3372
[  372.022458]
[  372.040266] CPU: 7 UID: 0 PID: 3372 Comm: fio Not tainted 6.13.0+ #16
[  372.117374] Hardware name: Oracle Corporation ORACLE SERVER 
X9-2c/TLA,MB TRAY,X9-2c, BIOS 66040600 07/23/2021
[  372.236091] Call Trace:
[  372.265337]  <TASK>
[  372.290423]  dump_stack_lvl+0x76/0xa0
[  372.334246]  print_report+0xd1/0x630
[  372.377024]  ? bio_poll+0x300/0x4c0
[  372.418759]  ? kasan_complete_mode_report_info+0x6a/0x200
[  372.483382]  ? bio_poll+0x300/0x4c0
[  372.525110]  kasan_report+0xb8/0x100
[  372.567882]  ? bio_poll+0x300/0x4c0
[  372.609611]  __asan_report_load4_noabort+0x14/0x30
[  372.666946]  bio_poll+0x300/0x4c0
[  372.706597]  iocb_bio_iopoll+0x3c/0x70
[  372.751448]  io_uring_classic_poll+0xb0/0x190
[  372.803587]  io_do_iopoll+0x471/0x1080
[  372.848440]  ? __io_read+0x206/0x1050
[  372.892253]  ? fget+0x83/0x260
[  372.928786]  ? __pfx_io_do_iopoll+0x10/0x10
[  372.978840]  ? io_read+0x17/0x50
[  373.017454]  ? __kasan_check_write+0x14/0x30
[  373.068546]  ? mutex_lock+0x86/0xe0
[  373.110278]  ? __pfx_mutex_lock+0x10/0x10
[  373.158253]  __do_sys_io_uring_enter+0x7ca/0x14a0
[  373.214550]  ? __pfx___do_sys_io_uring_enter+0x10/0x10
[  373.276048]  ? __pfx___do_sys_io_uring_enter+0x10/0x10
[  373.337544]  ? __kasan_check_write+0x14/0x30
[  373.388637]  ? fput+0x1b/0x310
[  373.425168]  ? __do_sys_io_uring_enter+0x996/0x14a0
[  373.483546]  __x64_sys_io_uring_enter+0xe0/0x1b0
[  373.538800]  x64_sys_call+0x16a1/0x2540
[  373.584695]  do_syscall_64+0x7e/0x170
[  373.628511]  ? fpregs_assert_state_consistent+0x21/0xb0
[  373.691052]  ? syscall_exit_to_user_mode+0x4e/0x240
[  373.749435]  ? do_syscall_64+0x8a/0x170
[  373.795326]  ? __kasan_check_read+0x11/0x20
[  373.845378]  ? fpregs_assert_state_consistent+0x21/0xb0
[  373.907917]  ? syscall_exit_to_user_mode+0x4e/0x240
[  373.966292]  ? do_syscall_64+0x8a/0x170
[  374.012184]  ? __kasan_check_read+0x11/0x20
[  374.062842]  ? __kasan_check_read+0x11/0x20
[  374.113483]  ? fpregs_assert_state_consistent+0x21/0xb0
[  374.176597]  ? syscall_exit_to_user_mode+0x4e/0x240
[  374.235530]  ? do_syscall_64+0x8a/0x170
[  374.281951]  ? syscall_exit_to_user_mode+0x4e/0x240
[  374.340855]  ? do_syscall_64+0x8a/0x170
[  374.387264]  ? __kasan_check_read+0x11/0x20
[  374.437828]  ? fpregs_assert_state_consistent+0x21/0xb0
[  374.500868]  ? syscall_exit_to_user_mode+0x4e/0x240
[  374.559737]  ? clear_bhb_loop+0x15/0x70
[  374.606100]  ? clear_bhb_loop+0x15/0x70
[  374.652461]  ? clear_bhb_loop+0x15/0x70
[  374.698816]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[  374.759739] RIP: 0033:0x71871b11e88d
[  374.802982] Code: 5b 41 5c c3 66 0f 1f 84 00 00 00 00 00 f3 0f 1e fa 
48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 
05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 73 b5 0f 00 f7 d8 64 89 01 48
[  375.028802] RSP: 002b:00007ffd4a4cf298 EFLAGS: 00000246 ORIG_RAX: 
00000000000001aa
[  375.119949] RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 
000071871b11e88d
[  375.205904] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 
0000000000000006
[  375.291858] RBP: 0000718710f762c0 R08: 0000000000000000 R09: 
0000000000000000
[  375.377805] R10: 0000000000000001 R11: 0000000000000246 R12: 
0000000000000001
[  375.463754] R13: 0000000000000001 R14: 0000584669038c60 R15: 
0000000000000000
[  375.549701]  </TASK>
[  375.576358]
[  375.594687] Allocated by task 2986:
[  375.637027]
[  375.655357] Freed by task 3376:
[  375.693501]
[  375.711823] Last potentially related work creation:
[  375.770791]
[  375.789121] The buggy address belongs to the object at ff11000170f75b00
[  375.789121]  which belongs to the cache bio-264 of size 264
[  375.935951] The buggy address is located 116 bytes inside of
[  375.935951]  freed 264-byte region [ff11000170f75b00, ff11000170f75c08)
[  376.083858]
[  376.102233] The buggy address belongs to the physical page:
[  376.169531]
[  376.187916] Memory state around the buggy address:
[  376.245819]  ff11000170f75a00: 00 00 00 00 00 00 00 00 00 00 00 00 00 
00 00 00
[  376.332857]  ff11000170f75a80: 00 fc fc fc fc fc fc fc fc fc fc fc fc 
fc fc fc
[  376.419894] >ff11000170f75b00: fa fb fb fb fb fb fb fb fb fb fb fb fb 
fb fb fb
[  376.506945] 
    ^
[  376.589835]  ff11000170f75b80: fb fb fb fb fb fb fb fb fb fb fb fb fb 
fb fb fb
[  376.677180]  ff11000170f75c00: fb fc fc fc fc fc fc fc fc fc fc fc fc 
fc fc fc
[  376.764502] 
==================================================================

Note that I use hipri for fio, as below - without seems ok.

fio --filename=/dev/nvme0n1p3 --direct=1 --rw=read --bs=4k --iodepth=100 
--name=iops --numjobs=20 --loops=1000 --ioengine=io_uring 
--group_reporting --exitall_on_error --hipri

> JFYI, this patch causes or exposes an issue in scsi_debug where we get a 
> use-after-free:
> 
> Starting 10 processes
> [    9.445254] 
> ==================================================================
> [    9.446156] BUG: KASAN: slab-use-after-free in bio_poll+0x26b/0x420
> [    9.447188] Read of size 4 at addr ff1100014c9b46b4 by task fio/442
> [    9.447933]
> [    9.448121] CPU: 8 UID: 0 PID: 442 Comm: fio Not tainted 6.13.0- 
> rc4-00052-gfdf8fc8dce75 #3390
> [    9.449161] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 
> rel-1.16.3-0-ga6ed6b701f0a-prebuilt.qemu.org 04/01/2014
> [    9.450573] Call Trace:
> [    9.450876]  <TASK>
> [    9.451186]  dump_stack_lvl+0x53/0x70
> [    9.451644]  print_report+0xce/0x660
> [    9.452077]  ? sdebug_blk_mq_poll+0x92/0x100
> [    9.452639]  ? bio_poll+0x26b/0x420
> [    9.453077]  kasan_report+0xc6/0x100
> [    9.453537]  ? bio_poll+0x26b/0x420
> [    9.453955]  bio_poll+0x26b/0x420
> [    9.454374]  ? task_mm_cid_work+0x33e/0x750
> [    9.454879]  iocb_bio_iopoll+0x47/0x60
> [    9.455355]  io_do_iopoll+0x450/0x10a0
> [    9.455814]  ? _raw_spin_lock_irq+0x81/0xe0
> [    9.456359]  ? __pfx_io_do_iopoll+0x10/0x10
> [    9.456866]  ? mutex_lock+0x8c/0xe0
> [    9.457317]  ? __pfx_mutex_lock+0x10/0x10
> [    9.457799]  ? __pfx_mutex_unlock+0x10/0x10
> [    9.458316]  __do_sys_io_uring_enter+0x7b7/0x12e0
> [    9.458866]  ? __pfx___do_sys_io_uring_enter+0x10/0x10
> [    9.459515]  ? __pfx___rseq_handle_notify_resume+0x10/0x10
> [    9.460202]  ? handle_mm_fault+0x16f/0x400
> [    9.460696]  do_syscall_64+0xa6/0x1a0
> [    9.461149]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> [    9.461787] RIP: 0033:0x560572d148f8
> [    9.462234] Code: 1c 01 00 00 48 8b 04 24 83 78 38 00 0f 85 0e 01 00 
> 00 41 8b 3f 41 ba 01 00 00 00 45 31 c0 45 31 c9 b8 aa 01 00 00 89 ea 0f 
> 05 <89> c6 85 c0 0f 89 ec 00 00 00 89 44 24 0c e8 55 87 fa ff 8b 74 24
> [    9.464489] RSP: 002b:00007ffc5330a600 EFLAGS: 00000246 ORIG_RAX: 
> 00000000000001aa
> [    9.465400] RAX: ffffffffffffffda RBX: 00007f39cd9d9ac0 RCX: 
> 0000560572d148f8
> [    9.466254] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 
> 0000000000000006
> [    9.467114] RBP: 0000000000000001 R08: 0000000000000000 R09: 
> 0000000000000000
> [    9.467962] R10: 0000000000000001 R11: 0000000000000246 R12: 
> 0000000000000000
> [    9.468803] R13: 00007ffc5330a798 R14: 0000000000000001 R15: 
> 0000560577589630
> [    9.469672]  </TASK>
> [    9.469950]
> [    9.470168] Allocated by task 441:
> [    9.470577]  kasan_save_stack+0x33/0x60
> [    9.471033]  kasan_save_track+0x14/0x30
> [    9.471554]  __kasan_slab_alloc+0x6e/0x70
> [    9.472036]  kmem_cache_alloc_noprof+0xe9/0x300
> [    9.472599]  mempool_alloc_noprof+0x11a/0x2e0
> [    9.473161]  bio_alloc_bioset+0x1ab/0x780
> [    9.473634]  blkdev_direct_IO+0x456/0x2130
> [    9.474130]  blkdev_write_iter+0x54f/0xb90
> [    9.474647]  io_write+0x3b3/0xfe0
> [    9.475053]  io_issue_sqe+0x131/0x13e0
> [    9.475516]  io_submit_sqes+0x6f6/0x21e0
> [    9.475995]  __do_sys_io_uring_enter+0xa1e/0x12e0
> [    9.476602]  do_syscall_64+0xa6/0x1a0
> [    9.477043]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> [    9.477659]
> [    9.477848] Freed by task 441:
> [    9.478261]  kasan_save_stack+0x33/0x60
> [    9.478715]  kasan_save_track+0x14/0x30
> [    9.479197]  kasan_save_free_info+0x3b/0x60
> [    9.479692]  __kasan_slab_free+0x37/0x50
> [    9.480191]  slab_free_after_rcu_debug+0xb1/0x280
> [    9.480755]  rcu_core+0x610/0x1a80
> [    9.481215]  handle_softirqs+0x1b5/0x5c0
> [    9.481696]  irq_exit_rcu+0xaf/0xe0
> [    9.482119]  sysvec_apic_timer_interrupt+0x6c/0x80
> [    9.482729]  asm_sysvec_apic_timer_interrupt+0x1a/0x20
> [    9.483389]
> [    9.483581] Last potentially related work creation:
> [    9.484174]  kasan_save_stack+0x33/0x60
> [    9.484661]  __kasan_record_aux_stack+0x8e/0xa0
> [    9.485228]  kmem_cache_free+0x21c/0x370
> [    9.485713]  blk_update_request+0x22c/0x1070
> [    9.486280]  scsi_end_request+0x6b/0x5d0
> [    9.486762]  scsi_io_completion+0xa4/0xda0
> [    9.487285]  sdebug_blk_mq_poll_iter+0x189/0x2c0
> [    9.487851]  bt_tags_iter+0x15f/0x290
> [    9.488310]  __blk_mq_all_tag_iter+0x31d/0x960
> [    9.488869]  blk_mq_tagset_busy_iter+0xeb/0x140
> [    9.489448]  sdebug_blk_mq_poll+0x92/0x100
> [    9.489949]  blk_hctx_poll+0x160/0x330
> [    9.490446]  bio_poll+0x182/0x420
> [    9.490853]  iocb_bio_iopoll+0x47/0x60
> [    9.491343]  io_do_iopoll+0x450/0x10a0
> [    9.491798]  __do_sys_io_uring_enter+0x7b7/0x12e0
> [    9.492398]  do_syscall_64+0xa6/0x1a0
> [    9.492852]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> [    9.493484]
> [    9.493676] The buggy address belongs to the object at ff1100014c9b4640
> [    9.493676]  which belongs to the cache bio-248 of size 248
> [    9.495118] The buggy address is located 116 bytes inside of
> [    9.495118]  freed 248-byte region [ff1100014c9b4640, ff1100014c9b4738)
> [    9.496597]
> [    9.496784] The buggy address belongs to the physical page:
> [    9.497465] page: refcount:1 mapcount:0 mapping:0000000000000000 
> index:0x0 pfn:0x14c9b4
> [    9.498464] head: order:2 mapcount:0 entire_mapcount:0 
> nr_pages_mapped:0 pincount:0
> [    9.499421] flags: 0x200000000000040(head|node=0|zone=2)
> [    9.500053] page_type: f5(slab)
> [    9.500451] raw: 0200000000000040 ff110001052f8dc0 dead000000000122 
> 0000000000000000
> [    9.501386] raw: 0000000000000000 0000000080330033 00000001f5000000 
> 0000000000000000
> [    9.502333] head: 0200000000000040 ff110001052f8dc0 dead000000000122 
> 0000000000000000
> [    9.503261] head: 0000000000000000 0000000080330033 00000001f5000000 
> 0000000000000000
> [    9.504213] head: 0200000000000002 ffd4000005326d01 ffffffffffffffff 
> 0000000000000000
> [    9.505142] head: 0000000000000004 0000000000000000 00000000ffffffff 
> 0000000000000000
> [    9.506082] page dumped because: kasan: bad access detected
> [    9.506752]
> [    9.506939] Memory state around the buggy address:
> [    9.507560]  ff1100014c9b4580: 00 00 00 00 00 00 00 00 00 00 00 00 00 
> 00 00 fc
> [    9.508454]  ff1100014c9b4600: fc fc fc fc fc fc fc fc fa fb fb fb fb 
> fb fb fb
> [    9.509365] >ff1100014c9b4680: fb fb fb fb fb fb fb fb fb fb fb fb fb 
> fb fb fb
> [    9.510260]                                      ^
> [    9.510842]  ff1100014c9b4700: fb fb fb fb fb fb fb fc fc fc fc fc fc 
> fc fc fc
> [    9.511755]  ff1100014c9b4780: 00 00 00 00 00 00 00 00 00 00 00 00 00 
> 00 00 00
> [    9.512654] 
> ==================================================================
> [    9.513616] Disabling lock debugging due to kernel taint
> QEMU: Terminated
> 
> Now scsi_debug does something pretty unorthodox in the mq_poll callback 
> in that it calls blk_mq_tagset_busy_iter() ... -> scsi_done().
> 
> However, for qemu with nvme I get this:
> 
> fio-3.34
> Starting 10 processes
> [   30.887296] 
> ==================================================================
> [   30.907820] BUG: KASAN: slab-use-after-free in bio_poll+0x26b/0x420
> [   30.924793] Read of size 4 at addr ff1100015f775ab4 by task fio/458
> [   30.949904]
> [   30.952784] CPU: 11 UID: 0 PID: 458 Comm: fio Not tainted 6.13.0- 
> rc4-00053-gc9c268957b58 #3391
> [   31.036344] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 
> rel-1.16.3-0-ga6ed6b701f0a-prebuilt.qemu.org 04/01/2014
> [   31.090860] Call Trace:
> [   31.153928]  <TASK>
> [   31.180060]  dump_stack_lvl+0x53/0x70
> [   31.209414]  print_report+0xce/0x660
> [   31.220341]  ? bio_poll+0x26b/0x420
> [   31.236876]  kasan_report+0xc6/0x100
> [   31.253395]  ? bio_poll+0x26b/0x420
> [   31.283105]  bio_poll+0x26b/0x420
> [   31.304388]  iocb_bio_iopoll+0x47/0x60
> [   31.327575]  io_do_iopoll+0x450/0x10a0
> [   31.357706]  ? __pfx_io_do_iopoll+0x10/0x10
> [   31.381389]  ? io_submit_sqes+0x6f6/0x21e0
> [   31.397833]  ? mutex_lock+0x8c/0xe0
> [   31.436789]  ? __pfx_mutex_lock+0x10/0x10
> [   31.469967]  __do_sys_io_uring_enter+0x7b7/0x12e0
> [   31.506017]  ? __pfx___do_sys_io_uring_enter+0x10/0x10
> [   31.556819]  ? __pfx___rseq_handle_notify_resume+0x10/0x10
> [   31.599749]  ? handle_mm_fault+0x16f/0x400
> [   31.637617]  ? up_read+0x1a/0xb0
> [   31.658649]  do_syscall_64+0xa6/0x1a0
> [   31.715961]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> [   31.738610] RIP: 0033:0x558b29f538f8
> [   31.758298] Code: 1c 01 00 00 48 8b 04 24 83 78 38 00 0f 85 0e 01 00 
> 00 41 8b 3f 41 ba 01 00 00 00 45 31 c0 45 31 c9 b8 aa 01 00 00 89 ea 0f 
> 05 <89> c6 85 c0 0f 89 ec 00 00 00 89 44 24 0c e8 55 87 fa ff 8b 74 24
> [   31.868980] RSP: 002b:00007ffd37d51490 EFLAGS: 00000246 ORIG_RAX: 
> 00000000000001aa
> [   31.946356] RAX: ffffffffffffffda RBX: 00007f120ebfeb40 RCX: 
> 0000558b29f538f8
> [   32.044833] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 
> 0000000000000006
> [   32.086849] RBP: 0000000000000001 R08: 0000000000000000 R09: 
> 0000000000000000
> [   32.117522] R10: 0000000000000001 R11: 0000000000000246 R12: 
> 0000000000000000
> [   32.155554] R13: 00007ffd37d51628 R14: 0000000000000001 R15: 
> 0000558b3c3216b0
> [   32.174488]  </TASK>
> [   32.183180]
> [   32.193202] Allocated by task 458:
> [   32.205642]  kasan_save_stack+0x33/0x60
> [   32.215908]  kasan_save_track+0x14/0x30
> [   32.231828]  __kasan_slab_alloc+0x6e/0x70
> [   32.244998]  kmem_cache_alloc_noprof+0xe9/0x300
> [   32.263654]  mempool_alloc_noprof+0x11a/0x2e0
> [   32.274050]  bio_alloc_bioset+0x1ab/0x780
> [   32.286829]  blkdev_direct_IO+0x456/0x2130
> [   32.293655]  blkdev_write_iter+0x54f/0xb90
> [   32.299844]  io_write+0x3b3/0xfe0
> [   32.309428]  io_issue_sqe+0x131/0x13e0
> [   32.315319]  io_submit_sqes+0x6f6/0x21e0
> [   32.320913]  __do_sys_io_uring_enter+0xa1e/0x12e0
> [   32.328091]  do_syscall_64+0xa6/0x1a0
> [   32.336915]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> [   32.350460]
> [   32.355097] Freed by task 455:
> [   32.360331]  kasan_save_stack+0x33/0x60
> [   32.369595]  kasan_save_track+0x14/0x30
> [   32.377397]  kasan_save_free_info+0x3b/0x60
> [   32.386598]  __kasan_slab_free+0x37/0x50
> [   32.398562]  slab_free_after_rcu_debug+0xb1/0x280
> [   32.417108]  rcu_core+0x610/0x1a80
> [   32.424947]  handle_softirqs+0x1b5/0x5c0
> [   32.434754]  irq_exit_rcu+0xaf/0xe0
> [   32.438144]  sysvec_apic_timer_interrupt+0x6c/0x80
> [   32.443842]  asm_sysvec_apic_timer_interrupt+0x1a/0x20
> [   32.448109]
> [   32.449772] Last potentially related work creation:
> [   32.454800]  kasan_save_stack+0x33/0x60
> [   32.458743]  __kasan_record_aux_stack+0x8e/0xa0
> [   32.463802]  kmem_cache_free+0x21c/0x370
> [   32.468130]  blk_mq_end_request_batch+0x26b/0x13f0
> [   32.473935]  io_do_iopoll+0xa78/0x10a0
> [   32.477800]  __do_sys_io_uring_enter+0x7b7/0x12e0
> [   32.482678]  do_syscall_64+0xa6/0x1a0
> [   32.487671]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> [   32.492551]
> [   32.494058] The buggy address belongs to the object at ff1100015f775a40
> [   32.494058]  which belongs to the cache bio-248 of size 248
> [   32.504485] The buggy address is located 116 bytes inside of
> [   32.504485]  freed 248-byte region [ff1100015f775a40, ff1100015f775b38)
> [   32.518309]
> [   32.520370] The buggy address belongs to the physical page:
> [   32.526444] page: refcount:1 mapcount:0 mapping:0000000000000000 
> index:0x0 pfn:0x15f774
> [   32.535554] head: order:2 mapcount:0 entire_mapcount:0 
> nr_pages_mapped:0 pincount:0
> [   32.542517] flags: 0x200000000000040(head|node=0|zone=2)
> [   32.547971] page_type: f5(slab)
> [   32.551287] raw: 0200000000000040 ff1100010376af80 dead000000000122 
> 0000000000000000
> [   32.559290] raw: 0000000000000000 0000000000330033 00000001f5000000 
> 0000000000000000
> [   32.566773] head: 0200000000000040 ff1100010376af80 dead000000000122 
> 0000000000000000
> [   32.574046] head: 0000000000000000 0000000000330033 00000001f5000000 
> 0000000000000000
> [   32.581715] head: 0200000000000002 ffd40000057ddd01 ffffffffffffffff 
> 0000000000000000
> [   32.589588] head: 0000000000000004 0000000000000000 00000000ffffffff 
> 0000000000000000
> [   32.596963] page dumped because: kasan: bad access detected
> [   32.603473]
> [   32.604871] Memory state around the buggy address:
> [   32.609617]  ff1100015f775980: 00 00 00 00 00 00 00 00 00 00 00 00 00 
> 00 00 fc
> [   32.617652]  ff1100015f775a00: fc fc fc fc fc fc fc fc fa fb fb fb fb 
> fb fb fb
> [   32.625385] >ff1100015f775a80: fb fb fb fb fb fb fb fb fb fb fb fb fb 
> fb fb fb
> [   32.634014]                                      ^
> [   32.637444]  ff1100015f775b00: fb fb fb fb fb fb fb fc fc fc fc fc fc 
> fc fc fc
> [   32.644158]  ff1100015f775b80: 00 00 00 00 00 00 00 00 00 00 00 00 00 
> 00 00 00
> [   32.651115] 
> ==================================================================
> [   32.659002] Disabling lock debugging due to kernel taint
> QEMU: Terminated [W(10)][0.1%][w=150MiB/s][w=38.4k IOPS][eta 01h:24m:16s]
> root@jgarry-ubuntu-bm5-instance-20230215-1843:/home/ubuntu/linux#
> 
> Here's my git bisect log:
> 
> git bisect start
> # good: [1cbfb828e05171ca2dd77b5988d068e6872480fe] Merge tag
> 'for-6.14/block-20250118' of git://git.kernel.dk/linux
> git bisect good 1cbfb828e05171ca2dd77b5988d068e6872480fe
> # bad: [a312e1706ce6c124f04ec85ddece240f3bb2a696] Merge tag
> 'for-6.14/io_uring-20250119' of git://git.kernel.dk/linux
> git bisect bad a312e1706ce6c124f04ec85ddece240f3bb2a696
> # good: [3d8b5a22d40435b4a7e58f06ae2cd3506b222898] block: add support
> to pass user meta buffer
> git bisect good 3d8b5a22d40435b4a7e58f06ae2cd3506b222898
> # good: [ce9464081d5168ee0f279d6932ba82260a5b97c4] io_uring/msg_ring:
> Drop custom destructor
> git bisect good ce9464081d5168ee0f279d6932ba82260a5b97c4
> # bad: [d803d123948feffbd992213e144df224097f82b0] io_uring/rw: handle
> -EAGAIN retry at IO completion time
> git bisect bad d803d123948feffbd992213e144df224097f82b0
> # good: [c5f71916146033f9aba108075ff7087022075fd6] io_uring/rw: always
> clear ->bytes_done on io_async_rw setup
> git bisect good c5f71916146033f9aba108075ff7087022075fd6
> # good: [2a51c327d4a4a2eb62d67f4ea13a17efd0f25c5c] io_uring/rsrc:
> simplify the bvec iter count calculation
> git bisect good 2a51c327d4a4a2eb62d67f4ea13a17efd0f25c5c
> # good: [9ac273ae3dc296905b4d61e4c8e7a25592f6d183] io_uring/rw: use
> io_rw_recycle() from cleanup path
> git bisect good 9ac273ae3dc296905b4d61e4c8e7a25592f6d183
> # first bad commit: [d803d123948feffbd992213e144df224097f82b0]
> io_uring/rw: handle -EAGAIN retry at IO completion time
> john@localhost:~/mnt_sda4/john/kernel-dev2>
> 
> Thanks,
> John
> 
>> ---
>>   io_uring/io_uring.c | 15 +++++++--
>>   io_uring/rw.c       | 80 ++++++++++++++-------------------------------
>>   2 files changed, 38 insertions(+), 57 deletions(-)
>>
>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>> index db198bd435b5..92ba2fdcd087 100644
>> --- a/io_uring/io_uring.c
>> +++ b/io_uring/io_uring.c
>> @@ -115,7 +115,7 @@
>>                   REQ_F_ASYNC_DATA)
>>   #define IO_REQ_CLEAN_SLOW_FLAGS (REQ_F_REFCOUNT | REQ_F_LINK | 
>> REQ_F_HARDLINK |\
>> -                 IO_REQ_CLEAN_FLAGS)
>> +                 REQ_F_REISSUE | IO_REQ_CLEAN_FLAGS)
>>   #define IO_TCTX_REFS_CACHE_NR    (1U << 10)
>> @@ -1403,6 +1403,12 @@ static void io_free_batch_list(struct 
>> io_ring_ctx *ctx,
>>                               comp_list);
>>           if (unlikely(req->flags & IO_REQ_CLEAN_SLOW_FLAGS)) {
>> +            if (req->flags & REQ_F_REISSUE) {
>> +                node = req->comp_list.next;
>> +                req->flags &= ~REQ_F_REISSUE;
>> +                io_queue_iowq(req);
>> +                continue;
>> +            }
>>               if (req->flags & REQ_F_REFCOUNT) {
>>                   node = req->comp_list.next;
>>                   if (!req_ref_put_and_test(req))
>> @@ -1442,7 +1448,12 @@ void __io_submit_flush_completions(struct 
>> io_ring_ctx *ctx)
>>           struct io_kiocb *req = container_of(node, struct io_kiocb,
>>                           comp_list);
>> -        if (!(req->flags & REQ_F_CQE_SKIP) &&
>> +        /*
>> +         * Requests marked with REQUEUE should not post a CQE, they
>> +         * will go through the io-wq retry machinery and post one
>> +         * later.
>> +         */
>> +        if (!(req->flags & (REQ_F_CQE_SKIP | REQ_F_REISSUE)) &&
>>               unlikely(!io_fill_cqe_req(ctx, req))) {
>>               if (ctx->lockless_cq) {
>>                   spin_lock(&ctx->completion_lock);
>> diff --git a/io_uring/rw.c b/io_uring/rw.c
>> index afc669048c5d..c52c0515f0a2 100644
>> --- a/io_uring/rw.c
>> +++ b/io_uring/rw.c
>> @@ -202,7 +202,7 @@ static void io_req_rw_cleanup(struct io_kiocb 
>> *req, unsigned int issue_flags)
>>        * mean that the underlying data can be gone at any time. But that
>>        * should be fixed seperately, and then this check could be killed.
>>        */
>> -    if (!(req->flags & REQ_F_REFCOUNT)) {
>> +    if (!(req->flags & (REQ_F_REISSUE | REQ_F_REFCOUNT))) {
>>           req->flags &= ~REQ_F_NEED_CLEANUP;
>>           io_rw_recycle(req, issue_flags);
>>       }
>> @@ -455,19 +455,12 @@ static inline loff_t *io_kiocb_update_pos(struct 
>> io_kiocb *req)
>>       return NULL;
>>   }
>> -#ifdef CONFIG_BLOCK
>> -static void io_resubmit_prep(struct io_kiocb *req)
>> -{
>> -    struct io_async_rw *io = req->async_data;
>> -    struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
>> -
>> -    io_meta_restore(io, &rw->kiocb);
>> -    iov_iter_restore(&io->iter, &io->iter_state);
>> -}
>> -
>>   static bool io_rw_should_reissue(struct io_kiocb *req)
>>   {
>> +#ifdef CONFIG_BLOCK
>> +    struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
>>       umode_t mode = file_inode(req->file)->i_mode;
>> +    struct io_async_rw *io = req->async_data;
>>       struct io_ring_ctx *ctx = req->ctx;
>>       if (!S_ISBLK(mode) && !S_ISREG(mode))
>> @@ -488,17 +481,14 @@ static bool io_rw_should_reissue(struct io_kiocb 
>> *req)
>>        */
>>       if (!same_thread_group(req->tctx->task, current) || !in_task())
>>           return false;
>> +
>> +    io_meta_restore(io, &rw->kiocb);
>> +    iov_iter_restore(&io->iter, &io->iter_state);
>>       return true;
>> -}
>>   #else
>> -static void io_resubmit_prep(struct io_kiocb *req)
>> -{
>> -}
>> -static bool io_rw_should_reissue(struct io_kiocb *req)
>> -{
>>       return false;
>> -}
>>   #endif
>> +}
>>   static void io_req_end_write(struct io_kiocb *req)
>>   {
>> @@ -525,22 +515,16 @@ static void io_req_io_end(struct io_kiocb *req)
>>       }
>>   }
>> -static bool __io_complete_rw_common(struct io_kiocb *req, long res)
>> +static void __io_complete_rw_common(struct io_kiocb *req, long res)
>>   {
>> -    if (unlikely(res != req->cqe.res)) {
>> -        if (res == -EAGAIN && io_rw_should_reissue(req)) {
>> -            /*
>> -             * Reissue will start accounting again, finish the
>> -             * current cycle.
>> -             */
>> -            io_req_io_end(req);
>> -            req->flags |= REQ_F_REISSUE | REQ_F_BL_NO_RECYCLE;
>> -            return true;
>> -        }
>> +    if (res == req->cqe.res)
>> +        return;
>> +    if (res == -EAGAIN && io_rw_should_reissue(req)) {
>> +        req->flags |= REQ_F_REISSUE | REQ_F_BL_NO_RECYCLE;
>> +    } else {
>>           req_set_fail(req);
>>           req->cqe.res = res;
>>       }
>> -    return false;
>>   }
>>   static inline int io_fixup_rw_res(struct io_kiocb *req, long res)
>> @@ -583,8 +567,7 @@ static void io_complete_rw(struct kiocb *kiocb, 
>> long res)
>>       struct io_kiocb *req = cmd_to_io_kiocb(rw);
>>       if (!kiocb->dio_complete || !(kiocb->ki_flags & 
>> IOCB_DIO_CALLER_COMP)) {
>> -        if (__io_complete_rw_common(req, res))
>> -            return;
>> +        __io_complete_rw_common(req, res);
>>           io_req_set_res(req, io_fixup_rw_res(req, res), 0);
>>       }
>>       req->io_task_work.func = io_req_rw_complete;
>> @@ -646,26 +629,19 @@ static int kiocb_done(struct io_kiocb *req, 
>> ssize_t ret,
>>       if (ret >= 0 && req->flags & REQ_F_CUR_POS)
>>           req->file->f_pos = rw->kiocb.ki_pos;
>>       if (ret >= 0 && (rw->kiocb.ki_complete == io_complete_rw)) {
>> -        if (!__io_complete_rw_common(req, ret)) {
>> -            /*
>> -             * Safe to call io_end from here as we're inline
>> -             * from the submission path.
>> -             */
>> -            io_req_io_end(req);
>> -            io_req_set_res(req, final_ret,
>> -                       io_put_kbuf(req, ret, issue_flags));
>> -            io_req_rw_cleanup(req, issue_flags);
>> -            return IOU_OK;
>> -        }
>> +        __io_complete_rw_common(req, ret);
>> +        /*
>> +         * Safe to call io_end from here as we're inline
>> +         * from the submission path.
>> +         */
>> +        io_req_io_end(req);
>> +        io_req_set_res(req, final_ret, io_put_kbuf(req, ret, 
>> issue_flags));
>> +        io_req_rw_cleanup(req, issue_flags);
>> +        return IOU_OK;
>>       } else {
>>           io_rw_done(&rw->kiocb, ret);
>>       }
>> -    if (req->flags & REQ_F_REISSUE) {
>> -        req->flags &= ~REQ_F_REISSUE;
>> -        io_resubmit_prep(req);
>> -        return -EAGAIN;
>> -    }
>>       return IOU_ISSUE_SKIP_COMPLETE;
>>   }
>> @@ -944,8 +920,7 @@ static int __io_read(struct io_kiocb *req, 
>> unsigned int issue_flags)
>>       if (ret == -EOPNOTSUPP && force_nonblock)
>>           ret = -EAGAIN;
>> -    if (ret == -EAGAIN || (req->flags & REQ_F_REISSUE)) {
>> -        req->flags &= ~REQ_F_REISSUE;
>> +    if (ret == -EAGAIN) {
>>           /* If we can poll, just do that. */
>>           if (io_file_can_poll(req))
>>               return -EAGAIN;
>> @@ -1154,11 +1129,6 @@ int io_write(struct io_kiocb *req, unsigned int 
>> issue_flags)
>>       else
>>           ret2 = -EINVAL;
>> -    if (req->flags & REQ_F_REISSUE) {
>> -        req->flags &= ~REQ_F_REISSUE;
>> -        ret2 = -EAGAIN;
>> -    }
>> -
>>       /*
>>        * Raw bdev writes will return -EOPNOTSUPP for IOCB_NOWAIT. Just
>>        * retry them without IOCB_NOWAIT.
> 
> 


