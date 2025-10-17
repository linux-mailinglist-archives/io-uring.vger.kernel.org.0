Return-Path: <io-uring+bounces-10053-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A105BEB3F1
	for <lists+io-uring@lfdr.de>; Fri, 17 Oct 2025 20:37:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EE44E1AA7468
	for <lists+io-uring@lfdr.de>; Fri, 17 Oct 2025 18:37:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 520032877C2;
	Fri, 17 Oct 2025 18:37:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ju/rKFrn";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="qv+ISDRX"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91E91331A5F
	for <io-uring@vger.kernel.org>; Fri, 17 Oct 2025 18:37:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760726235; cv=fail; b=K5Vt8OALqEWRVDPTyJMv3nUZnuECBhfg2UXnSXu3qslcHM41FmMlbIW2qbmFQi0RjrUYbZ4ChlMoCLIrBzVXi4mKtfkXN9YC9hSG81ipsZJK//FCTiDtSxAohef0NQ30fZgdaUUQDHB7pFpnyHj4V0fonvuPe/SR9zg+LPxJHaw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760726235; c=relaxed/simple;
	bh=gD8cFLDjxkE27a6OLkSRkQ0EAduRs0XfHPqdVtkcB+g=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=R52i8mghnrrinIP0zEHk6sNaq6IZrI0K7prKkYdBts1FScnZlPKRFVb+g3EP8ZIFWNki4MtggnlaeqiXaNiVi/O4wVLD/MIZIKYyDohl/TVBTyl3467gDrgRFxWfOrRLaAeoVYYDNNMWnPjig4SsOvNlNxV/t6raxKXhTyF7W70=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ju/rKFrn; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=qv+ISDRX; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59HCdbnL006048;
	Fri, 17 Oct 2025 18:37:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=vtKQ01OCyRkLGv4VBsEtq+Bgd7YtfN+he38Q4H81dwk=; b=
	ju/rKFrn1dNV+N0g9qJ0zJcxr3aHrq/mxs/ReYuLLhDMJ7T2tB2lXszEgR1KKiFH
	CHbVVshFRH4Kw1R1IJa1n1IfO/iJJPI7RJVkmLGpzxlY6cIECOf4bgp5VcG5NYQ5
	3D8scfRy3xKEAOH3rBbkbXP5PpxIWDrE2lPLB55M+w2BJHSmYUN808gfjHBl8cfU
	UxxSw+ZqtavU5IUOOYirlIDBgMs40OtQvIpMh1CXkvDGJfWbpjtQJ9fQjNaKpXc3
	hB6uB/IrcPShS68sQNyJWpvw4DdkHJvU01cZqAbaZNnoY0Fg7z0XJ8NJeuxjJObh
	auv0TdS75qsxCkWT33eDWg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49qdtyuj2c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 17 Oct 2025 18:37:01 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59HIUF6t000649;
	Fri, 17 Oct 2025 18:37:00 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010064.outbound.protection.outlook.com [52.101.85.64])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 49qdpdedhh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 17 Oct 2025 18:37:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mhsYZj0TO6twkJR3M+iP4ofn8aPLl0LyF3Xew55YyLDiwEOiG8SA1q2d1eodLrIyCnpDmf7HpSIagXZMFg0VWjcWIk9oaWXcqGknKI6YtcOsrnnoA7FqsF/U/OzcYq8CVLyaaVBDVCo73SbokGwifPnNTpp6tfhf2NLZ1qo6L8UBw3482WuhQ202ghMYRT60qZhlXLRnuz+fUpklaKZwqcJIb630s1bt8bSCaG/5me4AB0vVK9VD6Lqw/ndqAJtdwTSNokAF7dyqOoLCu4hU+lXwTRSdjjfXW/+yrR+JegD1A+nS84/PbdyLLF5enxpc2/7kiuxkHea8geb/5TIF4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vtKQ01OCyRkLGv4VBsEtq+Bgd7YtfN+he38Q4H81dwk=;
 b=D5RkQ9SYVelom3KeJ+akb5koJaBw1GZpC0HTmzxnnR2xeg8g4YflLwcvXY+PlTrqi1b0RBk9e1gwxzlP6K79slEXRXk/bW6m1ZZnXuGs9XDGLZXlMhT1+i81iTn7gEihcUqKcXOgcXwjqT4XOrhPEJ41XyPt4fhm1vuDDihKR0ldfWPJ3kyGC/fp8Xbz17xn2am9RDbWfjvNtDuIL7aKIOngK+rl8Cx6r6v/XK6qY4XkRjRoyK4e1x/0BzsXIUCNtMXU3F5Lv8WNQO57dGhktVSCgieBQEPZEjIj+fYQZT7yCd7Af2fQRH+EX9E++UQCgzMTXfmALBjw5Xy5yoPTSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vtKQ01OCyRkLGv4VBsEtq+Bgd7YtfN+he38Q4H81dwk=;
 b=qv+ISDRXqqZb5EkdTww9yDNZa2BwAb82mbptBoV350E3s9aZI3CPZt0k6Y+xjL5FHXdZlTNYVO9m8IlQyemkdK+K3DZO28BEeIiyxDbJcbYQqd2SniCjCNJ9RMg8rkUzCfmOs23+Gd+p/Izk1ZJhSo0gYPjnYbBYtfEbJIhydvg=
Received: from DS7PR10MB5328.namprd10.prod.outlook.com (2603:10b6:5:3a6::12)
 by DS0PR10MB8200.namprd10.prod.outlook.com (2603:10b6:8:1fc::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.12; Fri, 17 Oct
 2025 18:36:57 +0000
Received: from DS7PR10MB5328.namprd10.prod.outlook.com
 ([fe80::ea13:c6c1:9956:b29c]) by DS7PR10MB5328.namprd10.prod.outlook.com
 ([fe80::ea13:c6c1:9956:b29c%6]) with mapi id 15.20.9228.009; Fri, 17 Oct 2025
 18:36:57 +0000
Message-ID: <acdc65fc-372c-4bdc-a350-bd2dc75635e1@oracle.com>
Date: Sat, 18 Oct 2025 00:06:51 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [External] : Re: [PATCH] io_uring: fix incorrect unlikely() usage
 in io_waitid_prep()
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: axboe@kernel.dk, io-uring@vger.kernel.org
References: <20251017124117.1435973-1-alok.a.tiwari@oracle.com>
 <CADUfDZruQ7baruoBhSMBt6HcP-E-KiM1MHV=L9hn6OxFgEaXcw@mail.gmail.com>
Content-Language: en-US
From: ALOK TIWARI <alok.a.tiwari@oracle.com>
In-Reply-To: <CADUfDZruQ7baruoBhSMBt6HcP-E-KiM1MHV=L9hn6OxFgEaXcw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P123CA0090.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:190::23) To DS7PR10MB5328.namprd10.prod.outlook.com
 (2603:10b6:5:3a6::12)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB5328:EE_|DS0PR10MB8200:EE_
X-MS-Office365-Filtering-Correlation-Id: 1bb6d433-2e7a-44b9-c0c7-08de0dac26f8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ak5TdkN4ak9jQWNBV3Y4MkpqbUVlT25HVnRkNTB2alZER2JQeUk1dVFoNFJT?=
 =?utf-8?B?UnhSTlNFTWtGVkEzNjVSazN1Ym5lUVVDZDRoRUE3NlBnSGdaUDlVOFFVR3RF?=
 =?utf-8?B?NEZ6U3JwQk0vbm1RcDlqQmlmSFllSUZRcHdXVzRtbFhpUzFqb2g2SEtVWTJT?=
 =?utf-8?B?UHNmeWtqQkJCZWcvRjJwUTJFNkVjeEFCRFhwV1FPdEhEUCt0MUNoYUNoYzNv?=
 =?utf-8?B?M1FPQXJTRE9vRFpsTmJHV3RMOGpTU1owcjNob2hCZE9scHRvVTJWd2ovSEZS?=
 =?utf-8?B?UzNnbnpJWUhOQzV2bXlBVFJWaWJBb3pMbGFkMFR1S2haT3kyVkFsVU5Mclc0?=
 =?utf-8?B?R1QzMGNkMmo4anQ5Q3RaUk9GTExHSFJiODJEdWFBWHZ2NUJhejU1REg4NEN1?=
 =?utf-8?B?enhmOEpnK3lCQXB4RjMxTTM2QVF2bjhYVHlBVU5JZzFRbHMxK1pXaFJNelFy?=
 =?utf-8?B?Sy9FZ2YxQ1MvQ1hWanoxK1p4czJKWnFSRjNPTTd3UW56eDFTUUtJU1pvdlpy?=
 =?utf-8?B?WFNJbDk0MGRVeWpJTy82bkFxb2pwbHM2YmlIQnVITmVQcDlabGh1Ykd0SDlt?=
 =?utf-8?B?SjdLZ2NOMUtkZFZweGVFVWF6c2QyNHo0UkcvTk1qWUxCa3NiSzJuaUVVUm5S?=
 =?utf-8?B?R2p3WHpXd1Bjem5Sb0JnWHJESTNMaHFtTmRnTlFTVW5wUU0vVGJWSGdnY1NY?=
 =?utf-8?B?L2lqSCtqR1VIYUYrTklMakM1SkhabSt3L0I2WURWUE44eUJlVkF6SEhJcDR3?=
 =?utf-8?B?cUhnVW0wN3YzNSt4aE1HODlhaEtqNmJJYThvcVd2WEJLbmhFbHh3QVcvU0gv?=
 =?utf-8?B?MFc5MXVsZXBHTnd1emxzdHU4YVZyb2ZSYk9wekgrc0ljY2h3VUpmNllUR3BL?=
 =?utf-8?B?RExwczlQMkc0ZlFldTdReG9wSi9XU2pVU0Q2VzV3ZnVKOW0rSGtZbDFuMXVi?=
 =?utf-8?B?dXBqR2hPSHJZeEE5MjVNQ1lLM1Z1M1cwS3h1OHp6TTRrNnR0QTl2SlVDTW1V?=
 =?utf-8?B?OTkrQTZLWGxrNGtmQjhibE9KVk5GOEFzdUdOT0pXSWU3QldaTHNsajZCbHJq?=
 =?utf-8?B?OEZmT1ltRndGY0ljemRTaWduLzRqSUNhTmlRTjN1ejZsNUtVQU1BckJheXNx?=
 =?utf-8?B?S3V1Q1laREE3RHdNazZhNyt2Q3ZmazNNNU9nZktJSUNtZGh4MEV5a21MWFB6?=
 =?utf-8?B?ZFh6alh5MStYRTd3NWMxbXFjZGI2Ly9wU0FDQ1ZjYnVwd3hzajBCdDhESnJ6?=
 =?utf-8?B?SUFmeE1KazY0VkIyS0Q4ejBDTXYvalMzelovcXpNWDVYTmh3QWhNdjkxcUg1?=
 =?utf-8?B?Q2xlS3BEWGNGUTBPbkRGNm93ckdRRThRMVdoZzFuNUkxRGJBcHFqRmJkMjlJ?=
 =?utf-8?B?VVd3Q1Z4c1g3NW9JNm5jRVFXUUpnN0c5Z0trTmNIYjhtdDBEZlNXNUhWa29N?=
 =?utf-8?B?NXpTS1pyOGMzYTljUUFEdkExaXByUDlkcVFLektOTzFGa2kySFlTcWd4L0xR?=
 =?utf-8?B?ekpJUkxpdUJyN01YdXd2UVlnYzBVQUp2NEhWYWZzNkR0U0pVbTJLckxIR1dx?=
 =?utf-8?B?Z2E1UkJVUnhHRGhtdEtnVUlLMi92UnZIVXF2Y3J2dW55YUVLZ1FlbzBVMFVD?=
 =?utf-8?B?MmZWTlUzQlZYMVZJeW9na3Y4aXdrZW82M0JtUzhya0UweGdBV2NRWFVPMFBZ?=
 =?utf-8?B?R2NYL3FBcTF2Kzd1ZlhLRDJmL0I0SmsvVkl2MDIrOVNPSnJoU1UzZ00ySTJi?=
 =?utf-8?B?K2dlelc0NGo2bXl4VGpDRGxqRUU1YUIyeHU1OVRZSjVpcGxDdnROdmVHZG14?=
 =?utf-8?B?VkFick9FcW1USTlTdTFDSWl3SUo4UkVMelpEQ1NDZEJmZjVtYTJSV05leXJL?=
 =?utf-8?B?UGxaZzhIaEwyTHhBb2M0cjFpQ2dmVDVoSDlGL1JTVHQ0RFZIaUI5bmNnMEE4?=
 =?utf-8?Q?eZmoTOUHF6iZ/D+ab/GMT1OcwvaByOcx?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5328.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VUNCcDlRSGlUSWdqTk9Md3RFU21hZFMxeGtLczRDM1JWQW1rU0I2VCt4NjBB?=
 =?utf-8?B?VzNPWGllKzUwT3lqVXEwZldxT3h1eDRNaEhFLzYyMmg5QVFsYVdadXhUd1RP?=
 =?utf-8?B?Wk0zdTU2SHpZT0hxMUtYbjRZY1dEc2VNNjZkWHBud0JXRUwxQ0FFVVVwUXJO?=
 =?utf-8?B?M3ZIZ3pMYjc0ZVVCK283OWUzVnppWXNneU5qR3NWeUtmZ3g2OER2V21aWHJp?=
 =?utf-8?B?ZHVOQ2Mvd1ZrdnJaaVkxS1Q2TU9vcVoya2kwYy96SlVYNHdOenVQMGFvVDd2?=
 =?utf-8?B?RXAwcE1LQUlwT3pLVmtvRnlXSEh3bVk0bCtkNzFNUE9NbmZDWWZ2aGtTRFBt?=
 =?utf-8?B?eWpGbC9vbk41T2dNcnNPUnQ1eFdObHp6eS9sbHlWenFUT3IyZ2Zjcmc1K2p6?=
 =?utf-8?B?SFNGVFlXZjVueEJGK1BQWkFTQm42YmJHTzZZdi9aSkoyVWREVW8vY2tCN2ls?=
 =?utf-8?B?UktiYURuRWNmSW9rR1VreWJtZ3E4b01hMEN2d0FSUXBWaStkdEg5bGhYa3pE?=
 =?utf-8?B?YzRZeUFJUHFBbXNieEpiZmNqRmhROUJFcWJEM2hMN0tOdDl0djEwTUxxMjU3?=
 =?utf-8?B?WEZzSjJCa0wxTUZSYUgxYUFSUmJkNzBnTU81Y0RXNC9TaUtKSk9OTXRiUmM3?=
 =?utf-8?B?L0l4THk3eG9WY2ZaQ3pHK2tBMzdzY0p6dXlhaDlGTTQvVjk3Z0lNckM1aGtv?=
 =?utf-8?B?bHVJZFlRTS9xQS9aV0lCaEY4SjNWd2l0SWZvcWc1a3Nvb29pZ1pPV0VFWkVE?=
 =?utf-8?B?djc4eURVN0JYVXhtMExHeWt4TmJGdUE0cWVXeXNFR2dqTW5vR1BFMnBnQUhT?=
 =?utf-8?B?NE1tc0RDUzVmc2RlWGYxME5MbFRza1pSY1pyTDl5QzZvWEFPYzZVejhnVkQ5?=
 =?utf-8?B?bkQ3RUg5RGxtNXp3aVRyR2VsTjNtbHNYajlDVHRGd0Y0UzRKNFdRMnpiQTBP?=
 =?utf-8?B?VEgyQW50S1p5WlNyTXFJYStSellNQ096V0ZlWXN5RWVONlRnMk9HdUdadXFE?=
 =?utf-8?B?TlRIVzd4ZVVwWmx2cWVhNkVURmI2bkxQOU1QNjNDVSs2dGxhODJubThCaGxh?=
 =?utf-8?B?ZHZqTjcvVHhFbnUxcUdqZXBJcXY1Y2pjMkR1Q0N1MTJYR212YjJKU1JUZXpt?=
 =?utf-8?B?M1RhZXF4c1h2amYvd2sxN2o5V1ArRldWcFZmMEVRNFp0SlFMRHpkak16U3kz?=
 =?utf-8?B?b3gzUkw2K0RyaGloc0ltajhTYW43UTZtQlFWa3pscnE0dG5uWWtDbzYxVTNo?=
 =?utf-8?B?VW4vdjcxRWtkRzdaTTRUZmdUMXppaUZnWUtJcG9hSWVnVVRoS2hsVzFTeDdM?=
 =?utf-8?B?dHF1VlRRMWJsY2krN2JNOWRsTUZJNmN4MVRQWDVBUTlXdEFKaUU0b0k0bUli?=
 =?utf-8?B?SDc2Y294MWVyL2MyaE9RQ3JZbytDYmlwcmkxdnl3NzdtM2pCZW9veS85RFFa?=
 =?utf-8?B?RkhtcWxlOHprck9GQ0NvSmk2cmlTcEhRUHZyZUxmbmxVMkRZS2ZyZGdFNWp3?=
 =?utf-8?B?NUEyNFpYNU9kNHZ5cFl1SGM4QUNpcWJjUmRmR1phWjh2TjhYR2ZNNFdWaWhL?=
 =?utf-8?B?bDh0d01xRnVHaGZqRHNFOEl0am8zNmtab0t2a3R3U3pOUVZ3QlRDcUF4UDhW?=
 =?utf-8?B?YnM3VTZEYVB5a2l1VzlGWUY3UWNBSTE1V0ZGV3IrYTd5MVhFeFJRUWZoUzVa?=
 =?utf-8?B?VTg4Ui8vYkFxQVVBUnVDTWE1TDlENlFnVWJIdzRQNC8zVHFIZjh2M1M2U1JG?=
 =?utf-8?B?T0Nnb09qc2lkSWIxZkRFeWZyenoxdjRQcDlDTlRGSzd3b0dLOHMwa21vZDBy?=
 =?utf-8?B?aTlnd1BRek5vaUNoNStWVGJPL2Y3MVpBNGV6V2F0bHpZQ1o1NFowZlpQU1h6?=
 =?utf-8?B?Z2VGM1pMWXJHN2Z6UGl2SCtQcjAxb05hcGhvMzRFRVRhc29aejVHbXlQNmFa?=
 =?utf-8?B?bEcyU0lGaCtCMkRFeWJYOWd3a1E1OWRSM3R1bDdWQjQycHJtM3g2Yy92dmkv?=
 =?utf-8?B?YlM4R2pRMFNpRU4wdW52SDArdTB2Z2wzcXE4TkJEbkdhMENnWlR1U2hKVytO?=
 =?utf-8?B?bCttblJuQ3pPZTBPMkgraEtJV3J6NWFpTXhralI4VDVlZjBZOXFNUGZDOFJk?=
 =?utf-8?B?TzBOdE5OcHh6QnB1NlpGWGFrUE0yTnVPUFFReGZxdFBjaEM1UkFMbnRhNWRX?=
 =?utf-8?B?OXc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	mMPKnDp54Z5Q8+zntJKIgbz5mQoTpDxr4iaP1f0TUtXSk9emtPGix/aHJL3Ie/gejmtsIuQ3KwIdM2NZJlTgKVL3aEcTeuInXsbSLh978KLkeObtuRiNELwaSGhriyhx/3T/3mAi31/5b7nl0McGD4imIIXpEXd5LhgNbSSNPo83G7zzg6743ybRVS7EafDkNbnqS0L0W6hdV1ax+NdLwPsfFWpb/83MWzkhOUSx/VCxk/vAaPuQvjtyZEGRwZeHFtR2BfuiSJt2dIjZ/qw9v7BA1oKt6ZGV6znbNWFwuvbBqdAUnkSv2KePQBiarik7PL6eN1SmNcuZSvFclfw2a85UuGyHas75MfBjuKR6Aj0Su9pflHL0ePvrEPchxBpUiax9I8AU6Qjtpe64Gim7PrlVYgEmGS9XDffFSpap4jusBnwmDjv8RdIlbKXSPPI1Wh6qSq7+rCGqglGNAPbO0diwFKYPww4hBX25yHXPw/RuOISkbco0e8DjhkJOhOkPrMOLxtNUxHYUbD/FRnUMwyCFaUa62YexZhi54XrjcYtymMbv3zNVkIu4f76UEepU3HBYy3EB9K91WWZzPGBGUy0Z4GhJeO22tmyhnyP3hl8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1bb6d433-2e7a-44b9-c0c7-08de0dac26f8
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5328.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2025 18:36:57.4632
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JtG11ZxyOyWIgNnOmwa2xrNlBAk/t38r9AcUDPkWKedNeh6CYOQePebgY+lak3K2hIU1zce1H/KMbmMeBmSlmA3yQjXxIAxRMys246ezNqA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB8200
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-17_06,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 mlxscore=0
 adultscore=0 phishscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510020000
 definitions=main-2510170141
X-Proofpoint-GUID: cZCVOuo0B2Xe5gMZz6jd9mdyQtRexYcA
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDExMDAwNyBTYWx0ZWRfX51GUDKh1D55M
 FQGQzmsjRoVuNvTw6VWPN+QwW6vzMts0OzPrEU5imrvYDmBPmSLmNhjoon8/IM2kJbpo9k8wnri
 KFdiW7IuDIlWTZ74nsjDsgAAMdPkZVDWsmnILzEEZ8UAlV2oVbycp1ppluB+3hRafg9AjJo4s2C
 t0CoHdRscC5aUHt68/ohzQ7Se0YEwN0ztgaIYbaEzUCxU18w4IcF0JvZaog7QA1bBHuNXpbN/rl
 UDuXdVsFj9kuxAxJpmkyJU05Q0j+UMYFhaSHJgJr9JF71eH5pLBtIrl6LPCV6i5G9KD+US/OlrV
 RD3n16ZRGiTIjULMBO00JJxdWdKvtjNP3wIx9Fr8ZYtFxnG/T7aICvF2bHyALql6g3gDErY4LXU
 zNzkniwhyy8NTcdvLPe0wBpWRo3sOw==
X-Authority-Analysis: v=2.4 cv=OolCCi/t c=1 sm=1 tr=0 ts=68f28ccd cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=4tsV6wtTsOyYLjq2oc8A:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: cZCVOuo0B2Xe5gMZz6jd9mdyQtRexYcA



On 10/17/2025 8:52 PM, Caleb Sander Mateos wrote:
> On Fri, Oct 17, 2025 at 5:41 AM Alok Tiwari<alok.a.tiwari@oracle.com> wrote:
>> The negation operator incorrectly places outside the unlikely() macro:
>>
>>      if (!unlikely(iwa))
>>
>> This caused the compiler hint to be applied to the constant result
>> of the negation rather than the pointer check itself.
> Not sure what you mean by "constant". But yes, applying !unlikely(iwa)
> inverts the hint, saying iwa is unlikely to be non-NULL and therefore
> the if branch is likely. It certainly seems more likely that the whole
> if condition was meant to me marked unlikely.
> 
> Best,
> Caleb
> 

Thanks Caleb.
you are right, "constant result" was a misleading choice of words.
I will update commit message and send a v2 patch.

>> Fix it by moving the negation inside unlikely(), matching the usual
>> kernel pattern:
>>
>>      if (unlikely(!iwa))
>>
>> Fixes: 2b4fc4cd43f2 ("io_uring/waitid: setup async data in the prep handler")
>> Signed-off-by: Alok Tiwari<alok.a.tiwari@oracle.com>
>> ---
>>   io_uring/waitid.c | 2 +-


Thanks,
Alok

