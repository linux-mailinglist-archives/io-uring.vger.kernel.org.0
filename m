Return-Path: <io-uring+bounces-2298-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D0EE9104FF
	for <lists+io-uring@lfdr.de>; Thu, 20 Jun 2024 15:01:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F2C09287B47
	for <lists+io-uring@lfdr.de>; Thu, 20 Jun 2024 13:01:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 442111B29CB;
	Thu, 20 Jun 2024 12:56:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="e1AbHarY";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="zEgXscnz"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75AB41B14FD;
	Thu, 20 Jun 2024 12:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718888181; cv=fail; b=kBhJT+qoGEM/Q6HabJFTt2XgY8wgnVBspjBM2fQve8kS5x12DGa+kBm6ECujzFW39NoGcDuNG0hZbNyk+srORLhhx7aWzbYBSRKhvGgFVnj1TbgM0zUsiSXmjwW9sxRALgLIUkAkIEdKVI5ooYVj78uu1t3J0nU9NTXNLZR1HGw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718888181; c=relaxed/simple;
	bh=lqISxX5YEW/WeNeJDQSw1eC99xDJXb80NYGmqhZ9p5c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=iQ2dorIELyZYAbQ0N/i4vF8kW0AdSjyC2R1eu6aEGoWdIA0Tc0VS/x2E9Az9ym2jtSiHchoSrKZNqQ3NCEYCGVVLfYdnXcAQ6kQW8L7dW69AE5vCpseBGDeVfyGalz+18RMoCyhwapYQFmWm5nz7AAV2K5jV9tSiPNnn7PD11Z4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=e1AbHarY; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=zEgXscnz; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45K5Fik1002321;
	Thu, 20 Jun 2024 12:54:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=CeXcO95RprRpKSW+3sToKcTkGBFVJhtusSrxlskOoZE=; b=
	e1AbHarY76DbR5zemdvNUoFUU5D6HTCfPdO+bmvWmMZUZIOEhtrcXlt0IFC0Qb6X
	wfthagKmN61ibUbTk6csgbz4LhHEfqfyPGazysoK+MVJgzL6uMsrYN4NrlezUkmv
	sY0z84Jzn0Tn9dIXOeb6OZ6s1HPrQ6qG/K7eoUTl74wqSVplxRWOx59pfPbMlS3W
	KO7OcdraihYD92EVsFIirtfGu//DwzCY2w4mHeoCPYHyM0rrmlBo2LkjLFip6oPR
	zh6iD6W1pumGzGxe9BZ/Y7wbEAn6YAHMZ+Q7BUqABSdXInsGCD3n0WvSgoqwq9r1
	BxoZLHCxHRfgG24YDoq3tw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3yuj9r34ha-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Jun 2024 12:54:42 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 45KC7uti032824;
	Thu, 20 Jun 2024 12:54:42 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2040.outbound.protection.outlook.com [104.47.56.40])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ys1dae6nh-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Jun 2024 12:54:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kku7jG3OpQ5oBSCk8mS2PI4gdLOJfdEayGL5F4ti+3BWGfZEETl7K4k/ay2jWnBinC5iOzafc90JMW3gBP5Z+CfgAqJf7UiJoI+sOt8TVhw5lk52ZnktVoZ1yoV1SXO2Ir2nOWRMOujw5POtbNEWwyEKJvZF2wTgJsVesNay2YmoyifKZ21CzUk1A84axwVN1S0xeKC1LrcPv5cr1cOgVbi3eYUYmBF3FUpSXisAIK1g4lhQeLZcaLVew80tgTLsBSVZyT59fmRXAcyrpYjDR0mDkH9nDu0ulOjtNzMwtHlcpcTpwiB3/Ol1rVr6jHiMiTEZ8umt6BF45/8vi1tsSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CeXcO95RprRpKSW+3sToKcTkGBFVJhtusSrxlskOoZE=;
 b=B37tuutpy+kBlWIOEsXEwYxEzXDh9Ck5U0UOJz6Ts75LRQnTxM3vuZ0oPnrA8g/7qcVPAlYgUYycQHUb6PCN8IHVk3QfaqfDtsxaBJMwlzVpUKspPSDXpB6dMIM6dz4yO743Tmzi0N9PliSg7ChsMTeg10Z5mXQKpDO8UyKHCl3qMbvELZ35FL+kmf/Aqt/wQVIzqNtKLf03wqyf7RJYxSvhYzi0laVkzVaUk4uhZR4lCG07CDHC1rGF/j7lZJ3QCTKfktKlYstxaJ7iQpcs1/bUsYaZepUTLx2Q9WXY4yD26vRhuZYD5vU9TbxOjPhzmh3fhfyqOvHi4gWbD7AENQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CeXcO95RprRpKSW+3sToKcTkGBFVJhtusSrxlskOoZE=;
 b=zEgXscnz0krTwBbSznqUSL14IjNs1VKsIxMGdqcuJTC1DnQLQwsVKzr2pBLWyjPQg3G8U7wsTo/WEoLUgo/CdZtz6PfZxXDRRJ9cvftrzbXM90/Pp4K00g18ul06KiSzkEaLgfZKuv+k5bv2ARtRzJgtrwopjKyOiUX97blb5AE=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by PH7PR10MB7695.namprd10.prod.outlook.com (2603:10b6:510:2e5::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.31; Thu, 20 Jun
 2024 12:54:39 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%6]) with mapi id 15.20.7698.020; Thu, 20 Jun 2024
 12:54:39 +0000
From: John Garry <john.g.garry@oracle.com>
To: axboe@kernel.dk, kbusch@kernel.org, hch@lst.de, sagi@grimberg.me,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        viro@zeniv.linux.org.uk, brauner@kernel.org, dchinner@redhat.com,
        jack@suse.cz
Cc: djwong@kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-fsdevel@vger.kernel.org, tytso@mit.edu, jbongio@google.com,
        linux-scsi@vger.kernel.org, ojaswin@linux.ibm.com, linux-aio@kvack.org,
        linux-btrfs@vger.kernel.org, io-uring@vger.kernel.org,
        nilay@linux.ibm.com, ritesh.list@gmail.com, willy@infradead.org,
        agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com,
        dm-devel@lists.linux.dev, hare@suse.de,
        Alan Adamson <alan.adamson@oracle.com>,
        John Garry <john.g.garry@oracle.com>
Subject: [Patch v9 10/10] nvme: Atomic write support
Date: Thu, 20 Jun 2024 12:53:59 +0000
Message-Id: <20240620125359.2684798-11-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240620125359.2684798-1-john.g.garry@oracle.com>
References: <20240620125359.2684798-1-john.g.garry@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BL1PR13CA0303.namprd13.prod.outlook.com
 (2603:10b6:208:2c1::8) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|PH7PR10MB7695:EE_
X-MS-Office365-Filtering-Correlation-Id: 6cba38a3-da64-4c9b-ff1b-08dc91282529
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: 
	BCL:0;ARA:13230037|376011|7416011|1800799021|366013|921017;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?WXJaaFcrMlE1T1pCVTQvMWFrQzNGNDFFNXIxcGc0VkR0UlA0UFFtajlWMFoy?=
 =?utf-8?B?Ujk3NGhaRC81aUNWNGFZa0VQdGlGZUNLSENsUzQvWVlYbVZRcEZCdEk1YXpC?=
 =?utf-8?B?V29NM2U4VmVYcWFNSHdDbU13emZDb2VMcG5UYmlIczRDaXdnUVVLY3ltSGh1?=
 =?utf-8?B?a0dvTXlnNHMzOGZzRDJtbVNxQXZ1QjJ0V0I5d0hLbFR5Q2xzV3k2T3RWYlpj?=
 =?utf-8?B?UHU1TGJ4TzJqdmV5N3FzQUxJY2krb2VqaVhRckVYWW14UVg5MVhjZHZwd3Rv?=
 =?utf-8?B?emVIdEYzNlNCTnNJcUh1d2t6MXNpRWo5MmVyYkdVdUU2MG5VUGxpTTRuV1lm?=
 =?utf-8?B?UmQraXlmN1M0MUVFOHZqZjFYVGlRZ2kzYk5kRytPYm8rZFdNNXIvOGRZZVdm?=
 =?utf-8?B?bmZ5ZHg5Z1p4dHY2TkZNTHBndVNPSFlxMi9ONjZ4RWl0QUFvWTQ2YWlYVDdB?=
 =?utf-8?B?TzE4R3pRMjhNMmpMODJNQ25kU0FYdmlDZTNqeUo3ci9NS1NNaWV6S1UxWExo?=
 =?utf-8?B?VXZubzVpblVGdXlzNWdxMXdNTStQbUdEejJnaThxVWc5eW05ckdldStDYTF1?=
 =?utf-8?B?ai9Zdm5oMGlRTndKaWxOUFJ2Rk5uS3ZtWmZ1VXB4U1MxSlBaci9iaTlWaW9I?=
 =?utf-8?B?Mm1HZGNVMXhvcGNFZHBhUVJPWGZzdGlzSjVQdi8rQUVJM1puclZwUFZpQXgx?=
 =?utf-8?B?ZGRnRWJRckY4ZTRoM09PbDRxWVFFWkNWbmZLeXd4NFFnQ05WUXZOODBNUmZF?=
 =?utf-8?B?M3laeVRlNEFlMENvd1NvYU0rQXVBRDA3S292OW80WVZITjBpQVVxR0c4ZWtU?=
 =?utf-8?B?eGlLWHYyQW94SThmcG8xWnk5MTNkWFVheGpIVFNKVlpNOTY4S0JpQmp4S2Jl?=
 =?utf-8?B?R0JjT1JnSlhBTU1GVGZsSnZXTERDL3NOYTlMWU9vWGUrenQ2aFlOT091MTZJ?=
 =?utf-8?B?NDNHVXd1OGxMcGwwaFRwbDZHT3M4RVFaa05jaXFzOGZKV0p2bXBlT3ltWXpM?=
 =?utf-8?B?bjRkNkdtSFphVFZvYUg1WmF4MkU5WnlvMHNDd1lKTk9idWsyTWp4UlhEZ1Fu?=
 =?utf-8?B?ekc4dUo3djlHeTRMaE5vRGllTEZWem40WHV6TUxBQjNJWnFldEQ5c0w0a1RU?=
 =?utf-8?B?T0pJUHFoVmlIdDJERXNzQjBjUEMwOXFldWtROGRVSHg0NzZ3N1MxZ21uRHpW?=
 =?utf-8?B?OEw5VHF1UENZR0NrSXVHMHpRejNub01PSHdSMzRGNjBwTDkrdERJNjc5VDBF?=
 =?utf-8?B?RURwOEhOMHh1emhQT2Evc2NsWnRGemdaODQ5U1Vub0VwSlh0V0hWOVdMb2dj?=
 =?utf-8?B?SDhSd2MzLzhrMEFMRklQNThwVlJnS1FPaEI2NnVGWFlSMDJTdDdCWnR1ckl3?=
 =?utf-8?B?WUxCdFQ5LzdraWY4S1FHWkFERnN3eWxObUw5VlNodm9SQ1BLZGQ5NEhiQ1Vp?=
 =?utf-8?B?UUhKWWl4WmdnV000MjdwUTFFT1B6VFNkbW9zUFlwTTI3QzkvQnFHOVNycms1?=
 =?utf-8?B?RXIzVkRBN1RkK05Hb3paNnQwcFhFbE5tUlpRZTdBNzBVS2ZaRW1XcnpjNXhG?=
 =?utf-8?B?Ukl6SHhnNUE4cFhFUndISzRTWTQ5SWtBWjdNaDFVQjBvS01obmlCY1R5aXVx?=
 =?utf-8?B?eFRLcUIrZkJ2dDR2dEFzL29oS3ZJZ2tqWEt6aXR2SVVGa2hoSzVKTE5WdXNP?=
 =?utf-8?B?dy9tMjBwbmlWbStWSjFZTTZoejk4OTZiNDhjU1ZndGg4bGRJRVd0akxYdDI0?=
 =?utf-8?B?R2RiQTc1VEFWRWEwVlMreGZlOC9Rajc1eDRQWHNObFNPcW96Q2c5a1AwVmxH?=
 =?utf-8?Q?qWVIXB9W3NnPko02K3IKQa0sqBW1TTBWEJxX0=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(376011)(7416011)(1800799021)(366013)(921017);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?eEN3cVJzMzB1Y200dFVjS2g2ekpjUWZQUUhuWjJSNGt5Tm5ZbHBnVHU1NklE?=
 =?utf-8?B?WHVkQlBZMXJYUXRTMUVXL1FFdXI0ditnblY5ZXJVeStrRmUwY2ZEOGtOWFhp?=
 =?utf-8?B?L0J5Njh1bks0dENHMmhYaC9wTVh3YU5GQVhTaHNYNWI0b2tlQkkxdTZoM3Rv?=
 =?utf-8?B?bVAxbU9nY3VTQ2hFTkdGc2VCNXp0Zmw4NGJJWk9VU0hNT3ZxT240amxydHRr?=
 =?utf-8?B?NVRxaFVTUWJWMzRZc1JjWUI3Y3pUQ2FLT2hKNWQ1SDY1KzRjOU5VMXJhdTQx?=
 =?utf-8?B?ekFZcjREZWxiN1BGWk9McSs5WERxNTNPZkprS0pYRWNhR0tHNWh1a3lTeEUv?=
 =?utf-8?B?bGRsMnFicllWTnhKUjZZZzQrRkFta09RbExnSGtNbERVVlVaV3U5eFZCYjdC?=
 =?utf-8?B?Y0VJQ1JqR1E0Ykh3UTBmNGVwR1JsSVViK05zMW9rVytTZXIzMmJNVFBZRzhx?=
 =?utf-8?B?dE4rWEw2RjNsMFVONUZBWkI2TnowL3F0WGRaNE52QmNRR0tLYzRDc2tSbkRl?=
 =?utf-8?B?SDhqZnlQTUk4SVcrRExKVks0RXBnZytpRnRIY1BXU2FSMDlpOE5Vc2hZWFBk?=
 =?utf-8?B?YWtWNWtzaGVsOFRjd3J4ZVhPQ0lNbHoxOTNsTXBadC8zYXozT0w0Z1VvQlc3?=
 =?utf-8?B?RlhmcGZ5M3JKYnVWNStuS3FqeVFKd0NjY1pZM29DaDQ4K2dzVmVCczc4dmk5?=
 =?utf-8?B?L3EyTElrREVtMmRyS2VxQ1k5YkJBNExvM3BhMUJwVXV2R0R3Q3hNUlBIVzND?=
 =?utf-8?B?RDVqakNUU1g2M0hyZjhjdUZ4SVBFdm1rcmlqRU8wOElVa1RlUmRhY05kZ1k5?=
 =?utf-8?B?TTkxQlk3MVJRN28xU0o2UG0zVG5Ma0paRk1NeXRqV0liSHZNMDJJU3pkM0pr?=
 =?utf-8?B?cER3VmorOVV0Rk0rZXBlaGxacjJGcFJlTU1BT0tLa2tDblpxcGxMZWxPUkNI?=
 =?utf-8?B?Z0V5VkRNMjNpTzV3NkJUS2k2b0VremRDNlNnOWRWcmVLQS8zaDZ4dlJlMkpy?=
 =?utf-8?B?TThuWGYxTXhHeXM5VUhtODlZa2lRclhhNm9mTnkrbGFHS0kzeGQ5UXZ2Nzdw?=
 =?utf-8?B?OWI4eWc1cklWUTNiSE9NQmlpYTk4eFcxM0x4WjlmL3RJczhTSzc3UjUvak1j?=
 =?utf-8?B?YkhVcUNpZnJVeW04OXJlSHovVDJURUlLbTF0MGpRNUgwVlRmaWV5ZDZ2TlJJ?=
 =?utf-8?B?QXlRb3c0WnhRRWw2QmJIZFFlUUhQZ3EzeTBuV0ZuL25OeUFwYnA5TGsrVTVh?=
 =?utf-8?B?NFp4V09HaE9NaWtXRFFSUjJwaWlBVUhzTU95MU50L3FHbFZuQUhzU0I1T1J6?=
 =?utf-8?B?L0VpMEZ4dG9wU1N3NnJDb3hZQWxlK0ZkMmlXdjBCWTFJL0ROZzR6NGhNRitk?=
 =?utf-8?B?SFRNbTRGb2xNS0Z0VUZQdmpqd0l6UmJ6SWlZRjhqTU9aa1d4VnhUTmREY3Fa?=
 =?utf-8?B?S0VwTUhUeUFDb0FFRyt4UU1DOGdTZzRBdUhGMiswYnJQblAwQXFxcE5ZejhV?=
 =?utf-8?B?UjhvSDdxc2xWeUo5VE1BaUFCSWo3Zm80QTd1L0x5TmxRM3FMcGdqWG5mU2tS?=
 =?utf-8?B?Tit6L0RsVjBjeTZ0em0ybW9lOWxTRkpDN3dueTc3NStoWXR1M1pnV1ZEa3Vl?=
 =?utf-8?B?c05wYlRaV2piK0FQYWc1a2svVHQ2aTlwSEt3KzBVdGI1MitXUkVtZEN4a0dI?=
 =?utf-8?B?WGM0R3Byczh4UjQ4TlV3aGIwZmNWKzNkWEtUKzFlMHFqc2JVN0FJQkNjNkNF?=
 =?utf-8?B?MmNiVVpYTWZScjFneGJnQXpadWkwQ1VXR1JZTjNlc2ltdzJtTnlrUVlSc2lh?=
 =?utf-8?B?U21ROXdyZjJMYzl5T0RTSHRuWU5sY0JjaE1YbXpPSVRmbFBKNG82ZE0ySHdy?=
 =?utf-8?B?bkxZVjk1MmZSQmVML2xOZFk2NW1ROSs5R2JpbjA3NGl1aXd5Ymcvd0F4SXl5?=
 =?utf-8?B?WjlYK3VRMURJODBXc1ovN3ZBVkxnSXg4MFhoQ2RaaWRERTZ0SU4vQXFBRkdV?=
 =?utf-8?B?bU1DdzFtbHVhcC9WWnA2OVBoNXlWRTNKNXIybDFYaUVlOG9WOE81eG9Yd1JS?=
 =?utf-8?B?VlhOTTZDK2YrMzljb1RBU0I1UTNiSmtFYTRzU1hxSWdwUUc4U1hwQkxhL241?=
 =?utf-8?B?UWlDemwzb2lSV0hGNW1Sc1dNVjNRY2luMVZvTlZvaCtnL1JzZEhTMVZmQmFU?=
 =?utf-8?B?enc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	x20jWBJC09w9UpRIKzf0lOi2nqqKQCZobEXt7URmxjAHTs3HfJCU6loI+xqVvRHYAoKRX5Tp7icCF9cc3uTH+7mJS47xDwFmyuiqrDDLj33vKcW0088tFkxcirCVcP95u+lhclSfbXSlsbKkmH4Jc21pFCaz5Ys5YhCx7MvhKIGmNH81sarUxU1rk4lRJh1vZWveg/NSBgBz4Pl7eeZoDS/bH7dXLfksZPdktN0h6YGnvksyFg76ovSzbMmXt6RYhZ2Q/cmTPNIaLq/LqFc6rQpCy/fYB59Qk6RTo6nG1cfGea7d0d2XjxYnFisoFpH3QLwNZKpenXbmTolNFyUiI2FGvuVZGz+jb0twBzeqKVyo3UAxMhx1mCe5vlEzcNyBlPuPanE6SQyw2GoLdc1deuAaDgAYH3kHxWDD4RU+0JzXp8Fuj2R3bR7SOmJ2NHAa1gMgaeC1Uk4m1nox76pICuCFICpcH1nUgv32anP6Arn42VtvNkyxpp9xHc1TgXZ0/c7AuJ0vPHBwTKUnSQRJfxU76tp/N0/TFPOwBoC3bmUGBxBv/TN+U9xakTbSsSNBcaqCFCDXEFUW7eOzmQ/Jt+JzxOhJQV5AtESYlpUITbk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6cba38a3-da64-4c9b-ff1b-08dc91282529
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2024 12:54:39.0004
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ThZraPXp9QLH9lUzfTz2C+sMxdaVhZcZ/Q9+wFsdXCVpDw/n7bkfa1SE0MVC4Aouo5iBwtVkMedvNpRB5fxA7A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB7695
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-20_07,2024-06-20_03,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 spamscore=0
 mlxlogscore=999 mlxscore=0 phishscore=0 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2405010000
 definitions=main-2406200092
X-Proofpoint-GUID: mNS_5icj699YxJY16q4thhmq4cZy4-aS
X-Proofpoint-ORIG-GUID: mNS_5icj699YxJY16q4thhmq4cZy4-aS

From: Alan Adamson <alan.adamson@oracle.com>

Add support to set block layer request_queue atomic write limits. The
limits will be derived from either the namespace or controller atomic
parameters.

NVMe atomic-related parameters are grouped into "normal" and "power-fail"
(or PF) class of parameter. For atomic write support, only PF parameters
are of interest. The "normal" parameters are concerned with racing reads
and writes (which also applies to PF). See NVM Command Set Specification
Revision 1.0d section 2.1.4 for reference.

Whether to use per namespace or controller atomic parameters is decided by
NSFEAT bit 1 - see Figure 97: Identify – Identify Namespace Data
Structure, NVM Command Set.

NVMe namespaces may define an atomic boundary, whereby no atomic guarantees
are provided for a write which straddles this per-lba space boundary. The
block layer merging policy is such that no merges may occur in which the
resultant request would straddle such a boundary.

Unlike SCSI, NVMe specifies no granularity or alignment rules, apart from
atomic boundary rule. In addition, again unlike SCSI, there is no
dedicated atomic write command - a write which adheres to the atomic size
limit and boundary is implicitly atomic.

If NSFEAT bit 1 is set, the following parameters are of interest:
- NAWUPF (Namespace Atomic Write Unit Power Fail)
- NABSPF (Namespace Atomic Boundary Size Power Fail)
- NABO (Namespace Atomic Boundary Offset)

and we set request_queue limits as follows:
- atomic_write_unit_max = rounddown_pow_of_two(NAWUPF)
- atomic_write_max_bytes = NAWUPF
- atomic_write_boundary = NABSPF

If in the unlikely scenario that NABO is non-zero, then atomic writes will
not be supported at all as dealing with this adds extra complexity. This
policy may change in future.

In all cases, atomic_write_unit_min is set to the logical block size.

If NSFEAT bit 1 is unset, the following parameter is of interest:
- AWUPF (Atomic Write Unit Power Fail)

and we set request_queue limits as follows:
- atomic_write_unit_max = rounddown_pow_of_two(AWUPF)
- atomic_write_max_bytes = AWUPF
- atomic_write_boundary = 0

A new function, nvme_valid_atomic_write(), is also called from submission
path to verify that a request has been submitted to the driver will
actually be executed atomically. As mentioned, there is no dedicated NVMe
atomic write command (which may error for a command which exceeds the
controller atomic write limits).

Note on NABSPF:
There seems to be some vagueness in the spec as to whether NABSPF applies
for NSFEAT bit 1 being unset. Figure 97 does not explicitly mention NABSPF
and how it is affected by bit 1. However Figure 4 does tell to check Figure
97 for info about per-namespace parameters, which NABSPF is, so it is
implied. However currently nvme_update_disk_info() does check namespace
parameter NABO regardless of this bit.

Signed-off-by: Alan Adamson <alan.adamson@oracle.com>
Reviewed-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
jpg: total rewrite
Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/nvme/host/core.c | 52 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 52 insertions(+)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index bf410d10b120..89ebfa89613e 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -927,6 +927,36 @@ static inline blk_status_t nvme_setup_write_zeroes(struct nvme_ns *ns,
 	return BLK_STS_OK;
 }
 
+/*
+ * NVMe does not support a dedicated command to issue an atomic write. A write
+ * which does adhere to the device atomic limits will silently be executed
+ * non-atomically. The request issuer should ensure that the write is within
+ * the queue atomic writes limits, but just validate this in case it is not.
+ */
+static bool nvme_valid_atomic_write(struct request *req)
+{
+	struct request_queue *q = req->q;
+	u32 boundary_bytes = queue_atomic_write_boundary_bytes(q);
+
+	if (blk_rq_bytes(req) > queue_atomic_write_unit_max_bytes(q))
+		return false;
+
+	if (boundary_bytes) {
+		u64 mask = boundary_bytes - 1, imask = ~mask;
+		u64 start = blk_rq_pos(req) << SECTOR_SHIFT;
+		u64 end = start + blk_rq_bytes(req) - 1;
+
+		/* If greater then must be crossing a boundary */
+		if (blk_rq_bytes(req) > boundary_bytes)
+			return false;
+
+		if ((start & imask) != (end & imask))
+			return false;
+	}
+
+	return true;
+}
+
 static inline blk_status_t nvme_setup_rw(struct nvme_ns *ns,
 		struct request *req, struct nvme_command *cmnd,
 		enum nvme_opcode op)
@@ -942,6 +972,9 @@ static inline blk_status_t nvme_setup_rw(struct nvme_ns *ns,
 	if (req->cmd_flags & REQ_RAHEAD)
 		dsmgmt |= NVME_RW_DSM_FREQ_PREFETCH;
 
+	if (req->cmd_flags & REQ_ATOMIC && !nvme_valid_atomic_write(req))
+		return BLK_STS_INVAL;
+
 	cmnd->rw.opcode = op;
 	cmnd->rw.flags = 0;
 	cmnd->rw.nsid = cpu_to_le32(ns->head->ns_id);
@@ -1920,6 +1953,23 @@ static void nvme_configure_metadata(struct nvme_ctrl *ctrl,
 	}
 }
 
+
+static void nvme_update_atomic_write_disk_info(struct nvme_ns *ns,
+			struct nvme_id_ns *id, struct queue_limits *lim,
+			u32 bs, u32 atomic_bs)
+{
+	unsigned int boundary = 0;
+
+	if (id->nsfeat & NVME_NS_FEAT_ATOMICS && id->nawupf) {
+		if (le16_to_cpu(id->nabspf))
+			boundary = (le16_to_cpu(id->nabspf) + 1) * bs;
+	}
+	lim->atomic_write_hw_max = atomic_bs;
+	lim->atomic_write_hw_boundary = boundary;
+	lim->atomic_write_hw_unit_min = bs;
+	lim->atomic_write_hw_unit_max = rounddown_pow_of_two(atomic_bs);
+}
+
 static u32 nvme_max_drv_segments(struct nvme_ctrl *ctrl)
 {
 	return ctrl->max_hw_sectors / (NVME_CTRL_PAGE_SIZE >> SECTOR_SHIFT) + 1;
@@ -1966,6 +2016,8 @@ static bool nvme_update_disk_info(struct nvme_ns *ns, struct nvme_id_ns *id,
 			atomic_bs = (1 + le16_to_cpu(id->nawupf)) * bs;
 		else
 			atomic_bs = (1 + ns->ctrl->subsys->awupf) * bs;
+
+		nvme_update_atomic_write_disk_info(ns, id, lim, bs, atomic_bs);
 	}
 
 	if (id->nsfeat & NVME_NS_FEAT_IO_OPT) {
-- 
2.31.1


