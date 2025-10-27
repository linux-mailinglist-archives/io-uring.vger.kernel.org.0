Return-Path: <io-uring+bounces-10234-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 82990C0EAB6
	for <lists+io-uring@lfdr.de>; Mon, 27 Oct 2025 15:57:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8F43E462886
	for <lists+io-uring@lfdr.de>; Mon, 27 Oct 2025 14:50:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73FFC21C9E1;
	Mon, 27 Oct 2025 14:49:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dZAPsp2v";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="BaE6tFZm"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B0C13081DE;
	Mon, 27 Oct 2025 14:49:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761576576; cv=fail; b=Lw9CFY0l9U4VMfI4gmHbvZJLLFAsZAFDEkm9RiQa1k3nPw0SXazK/p7Ai0EaVsbgCeVkPCyaxSlx8wkc8paZUaq41ImDttDZDMk2g9KlotNQvG+PL7lImvhZA37WSojd/zPObSKpHtbimIXFpy1f6wK1WGqo0P7OnpD14UHmrlY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761576576; c=relaxed/simple;
	bh=3HN9bdG1igLBbvxovJsO/raEutwGIfEjLIwAI3hZbo8=;
	h=Message-ID:Date:To:From:Subject:Cc:Content-Type:MIME-Version; b=h5fny7f6ny6TZeyA1/JCUMXbc6vp5v02JmT66IRTcQg9aT5E3vBDReflNGlR21m7xwogTleDUa1Qgz8S6oHPk/Dn57z6NLRc9dYp0Bo5ED9v8LXTS8ZiaT/deKFVwJSHLQDt16lDRNinIny58gE2kCp9yzUIzihG3KGnsaP3lC8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=dZAPsp2v; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=BaE6tFZm; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59RDY9pk005535;
	Mon, 27 Oct 2025 14:49:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=F42Z/6JUzRJqh6H+
	h3veB9Q/X555O/IlVX/wIIFz618=; b=dZAPsp2vT0Mv+tJGplHj+jG34kB60LCt
	4YJcmD9PZPIioAKaEgIqlDqOua0mUyE/iwtMtUST4Can7x8DE5gcdRm4xsbmRtH8
	IRPQNjNC9xQhqC3ejOZ072hqXepbUqp3H4+cbb/kfPTf05775t01ElPdGz3HPUrx
	nYFrinaTWkHYlHo7kT4XK7CR+KAz5r3pZcffjB2ASbKCKVIhqah5bES74az0Q/7T
	T6T28BM6k6V0F46sRdcSm1T9UcyqeL6OSWQefr4JJ191JfccZWcj1dMyWL8Er9r/
	BzCUnZa8j3VcOOviUV5IIFpnBQuDHJ4ONnFperKRm+mMV0L3qJo3/w==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a22uwh49f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Oct 2025 14:49:24 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59RD29Sd037516;
	Mon, 27 Oct 2025 14:49:23 GMT
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012000.outbound.protection.outlook.com [52.101.53.0])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a0n06w5yj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Oct 2025 14:49:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CjbuaPlgHZXWEKZ9v7YE9CCLZAOStm5cz4DBS5qpHLHkwxD+4qb/nWr0ggsIdFg1iWOhhnughSDc++DzC6Kt+0pTYns9DDT7xXHUQvXsiCeeUmgutdjYRqrXu6UOsFyOmBkz79lNZUhXW1x0N+14+pOIyP4frZImEFloT8PoKDS/zyjXQdDbpixQ/C6VqBdGe61EbAukAVfpVDCJq4MhMA2AFbjm/t5HFXZEJK/hYLHrPMFH2lUhC18p0qvowYqvIuvxMMk49uXaPbGA6vzNFfdY/7AEBDbRr75oVfWKNc7Pqj1LsGasK/uT3WElJPvbT+f1C0Fl9DgYSn8svIWwOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F42Z/6JUzRJqh6H+h3veB9Q/X555O/IlVX/wIIFz618=;
 b=FQtHhDUZYPpM9BGaGnCFJbWP2hPVl1yF8omATBBW7tpaZRO7LCQVw5OzMCXs/CV5tNKgO9skqZ+PEZJG4ernKc36VLndp/On01gnX+NlHbM6vf3VO2MCkFaS8FfjJ04z5dAgW9xqubJSDrtVm5lqnzapQ4lhrOdEWxr7dgYUislFiKBLyDV8S+y3Hgiv2rkXdk1eZei9owh4wwpQmBPO1RVPBzNzMO/N3xUqrQGTdqQmUnGMfjE7uWpCyJXz+i0Q+EaJE75na/24BImT7uK6n5GOxMxZVazWJHlmwcBSGqQOIKDn7c6dTOsVDkGNJyNO26f1TRRcj39IncljRctcng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F42Z/6JUzRJqh6H+h3veB9Q/X555O/IlVX/wIIFz618=;
 b=BaE6tFZmQwSZVLWE+01cxLaEhDQPN46HRk/Mpd9kbpFuEu+4irNsl++TX5ZoUUbIcFszBBW3XULdWRqg0b2JwIwLyBiZ6RqWAt9AHiH/HE4Ub8bfL7Z5IP/br82AIudG+ycPXRUNDi+CQOjUxajmwotepkSeJEBzvk4OfCFG8Qc=
Received: from DS7PR10MB5328.namprd10.prod.outlook.com (2603:10b6:5:3a6::12)
 by IA1PR10MB6686.namprd10.prod.outlook.com (2603:10b6:208:41a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.18; Mon, 27 Oct
 2025 14:49:17 +0000
Received: from DS7PR10MB5328.namprd10.prod.outlook.com
 ([fe80::ea13:c6c1:9956:b29c]) by DS7PR10MB5328.namprd10.prod.outlook.com
 ([fe80::ea13:c6c1:9956:b29c%6]) with mapi id 15.20.9253.017; Mon, 27 Oct 2025
 14:49:16 +0000
Message-ID: <04b7104c-95e3-4b0c-a8a2-f240a1994c68@oracle.com>
Date: Mon, 27 Oct 2025 20:19:10 +0530
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: bschubert@ddn.com, miklos@szeredi.hu, linux-fsdevel@vger.kernel.org,
        asml.silence@gmail.com, luis@igalia.com, io-uring@vger.kernel.org
From: ALOK TIWARI <alok.a.tiwari@oracle.com>
Subject: [query] payload size check in fuse_uring_create_ring_ent
Cc: alok.a.tiwari@oracle.com
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0545.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:319::13) To DS7PR10MB5328.namprd10.prod.outlook.com
 (2603:10b6:5:3a6::12)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB5328:EE_|IA1PR10MB6686:EE_
X-MS-Office365-Filtering-Correlation-Id: abffeaca-282f-4d75-ac87-08de156800c0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dFFpM3Q5cm9scUNEVjhHNU9LaWVyOHhYSWkwbWkyZTJCS25TdVF6cUtZenV5?=
 =?utf-8?B?bnZKYWhwYjFNWWJiS0VuUVV2RVpqNUwya3FSdzBmenNYUE5Qb3FrZHI0QjRr?=
 =?utf-8?B?R2tjTjdLTEc2ckxDWnd4dzJ0U205NlpJNWlXUzVxaXl6d20xck1nYzVrTXA0?=
 =?utf-8?B?UXlSMXNnbTh2WW5nbHhNelZweTdoZ2JydFlmeVgrd0RsRDU3cE5kY1ExRWxv?=
 =?utf-8?B?N0M5Z0lZV1h6WTRJUFRubDZlcjVSMkJ6T3J6NkpXRExFZk9sQkNRV0NWSWxV?=
 =?utf-8?B?QmJ0MzM2OHR2cytLR2VzeFFDTnVQYzRyWUpFZzhiQkdJVC9aSGVRRVRVbEZi?=
 =?utf-8?B?bWZHeW1yMEtYVTlqZ25xZXZOUTR5UkZqU3JsOXBKMzY5YVoyTlRKUHE3YmJw?=
 =?utf-8?B?UW9ZSGpyMWhkQmUvY2djVkNYRlNEb1JkcFZ2QjAvU2pRSE15NGZpNkNCWlVs?=
 =?utf-8?B?cDJEYzZFaWF4OC8zUFZQMEJ6VmVSQU4zbGRNV3JIT1RPbklMSWh5T3FIejZx?=
 =?utf-8?B?M2dBbm9CTDhac1JvT1U3UU01bVFDWVN2VEJrcU1lU2R2UGZmeG9UZXV1TTU3?=
 =?utf-8?B?NFlqR2ZKRTErcFlXd2FUR3huRXVBUmNWNzEyNTZHRkFrMHJLVFZ0NkF4SnRS?=
 =?utf-8?B?cmx1RGVLNkQ0Uis4OVRCZE1FNzFlbjIxSWExbEkxNGxNcEJ1Z0lxbWpUUHl1?=
 =?utf-8?B?T1RXTDJMVFVWRC9PQm5lRCtLY01UQWVPTjBqbGFwT3pmRCtjOXo2ZkNPR0E3?=
 =?utf-8?B?bkYvVnpJNjhvaXRpcUo4b2duZ0piQ1F3dGI4Y0tLUFB2bjRFRGgwaXJ3a0Rq?=
 =?utf-8?B?dVM2NzJjMEtQRk1qZ3UyczB1NllzdzM1WG9HanJaN1NxZjZBT3pRT3NKaUZN?=
 =?utf-8?B?bUU2a3l0cjVwUnlHdUlKZThuUTAvMG92WE9TNDJsRWJxN3c1NzErRmdtNnRa?=
 =?utf-8?B?a3cwdUxNRWtLNXFUSEJDQmlxY0FhT084djErRVIzcCt0c1RBQW9NczY3QkI3?=
 =?utf-8?B?NDVXMDBXNzZCQzNlNk5adnVjZlRqb0tZQmlEYW1JSzU2ZWptM2tsN1ROMjcx?=
 =?utf-8?B?QXAvZkFCL0pwMWVpL3BJdm0yaEppNDRzeWducTJmQ2lTb29Ldms3a1FXMVVU?=
 =?utf-8?B?UUxUNHN6WDE3cXoyZ0h4SzRlTDUxS1hXY2hUalJKTEJ5VDQ1NnFvbjMvY0M5?=
 =?utf-8?B?aFM1bldPTjZOWldjd1p5bHA2TWJhQVMzc0REYVBtcnpIM3NacDhONDU1WURR?=
 =?utf-8?B?bS80ajgzUnpOMWJ1cnVDZjQvTEhGd3JrQTlrc0MwenNVVkNMUVJvc0dEclV6?=
 =?utf-8?B?cU1IU04rb2VmRW0rMEpqT3hQZEJXZUFuNW43UmdvZlFUOEVLdDJmNXVQeUxZ?=
 =?utf-8?B?Z3QwRitnQWJCa1JBOXFwSVlsMmZXL2trWHBVaCsra2JpQW9yOG1OdVlBZ0JV?=
 =?utf-8?B?ejN0MFpoVzV2UVJKL0lPcFdLcnk5TkZYc3g1SDhzN2tETG8wNlpMdGNJdksv?=
 =?utf-8?B?WnpaYmM4Rm1aWnlITkJ6L0E1Ly9la2ZmRmNMeTY5NGVSRjFEQnpVTG1kNlFJ?=
 =?utf-8?B?Y1Q3QkI1S3RHTFovRkt1dzhHZm5kNW5wa1RUWUIwb01Oc0djVUk5RmVERmxi?=
 =?utf-8?B?N1dabU1oWjFja2haMDA4ejVnNytGWmpKdlNPR0VzVm9kbXcveTEvQi9iOGdz?=
 =?utf-8?B?Z2ZBbXQ5MTlqeGZTekM1RStNdjRIZ1JaaVFPK1B3VXNMWTNuTVNlL0ttUWQy?=
 =?utf-8?B?WlBQeDlqc0dHaWEzdFRRODVsb1Zxb1BWR3dQV2g4NWlRZ0QzZ3JtS3JDK21N?=
 =?utf-8?B?cGNma0JQdFpVZXIrckV2eWtFYkVDd0M1ZEZzWngrZktwSmI5WmZkMTZnVUo2?=
 =?utf-8?B?bUE4QncvcFZNSjlQQkdJSndjNitoZkRyWTBWU2Z1cVpJVUJiamQwUCtZbHJI?=
 =?utf-8?Q?iWSQx5HCKkAbKkWQLBeOuNen+dwA4Ghx?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5328.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZDV6Q2JGQ1JzL1hXSVc0ckFDcWZZWmNyL212ekg4OGowVlRoUXlBTzFJOWU2?=
 =?utf-8?B?elcvdXo1TVBoV3ZWRE9lMDQ3R1k5TUx2WGNIdHlRMkNSQmdwNXFQOW9mSFcv?=
 =?utf-8?B?QWExcGx6UVRjVUFNK2xDMjhwVWtuSVJKaXRod3NVZXR5V0tuWDFGbHVGelI1?=
 =?utf-8?B?NTFTcTBPeVFuU2poREMycDlXOWwwV215V1VPZ2JqSTd2Nzg4R3YzcVNSOGo4?=
 =?utf-8?B?c0RSMDc0NWdmcjFTR3lDSlVGYTlsNUJZeklXRWVDYjZoY2ZpVWp2WGlwLzNs?=
 =?utf-8?B?QXZqT2txUnRPdlA1UDJrZWV6NkpDbkMwTHFoTi9aaDI2Y25MS3BHZGZPWUFF?=
 =?utf-8?B?bEcvQTFqZTlQZE5kcFdPbDZFellRaDM5UTBPQ0l6cjFNRlJCdnpqUkhOcDU1?=
 =?utf-8?B?VDFsZ1F2NFhXeTJ6dllhMFQ3WXFMUS9lc05nK3dlZzZsRUZ6MnlwRWdFQkxr?=
 =?utf-8?B?dzl6Z0twdVBRQ3VIZ3ovM2FMd0xvOU5SRW8vWktDRCs1cGRMMktFRlhpMW5z?=
 =?utf-8?B?UDZGREppcVcxQ2ZMcWNRRlB1cWV0dVQxSkthSW1XbUR6OUF5VG9CdVNFUW9i?=
 =?utf-8?B?TW9iVWpJYUdmRzVTYkFxQ2t5K1BwWmtocFJuMnRuVGR4UitmS0tPNG4rMWN6?=
 =?utf-8?B?TzVjYUl3Q0ZTRjFEVElFaDRHMW1CMUlMOEZINWZKWlc4Q2YvMzR0elpXSTA1?=
 =?utf-8?B?ZmpyeTVGKzFtTTRISlUxTGFjbEwzOGpLWnptWmF1ZEpTUThaVkRIRUhUNjll?=
 =?utf-8?B?bUducWh0SzJVUEpjOTZMdGl1TnFONExUMU1zb3lvYmFWaGxXRitoOWRuWnF2?=
 =?utf-8?B?UmZ4KzlHMmVDYVZaWW9ESmVMeVJDOHlFQ3g1ZFBJaUt0ZzBUcm9wMEdoV2tY?=
 =?utf-8?B?Qk1XUEtQYndpL2o0Nlh0dUFiaDBSTTl4TkdJaDFwSktodFMvYVpjUmtOcFBS?=
 =?utf-8?B?ZnlnUGJVWWVzZzdROHdwYXh5ZktMRER3MTAvQ2xPTjlCcjJoSlNMMkVUbFRu?=
 =?utf-8?B?M2x0ZTlJSjJZTEt4ZWF2cjVGWEdHUjhQQ3A1QWdWWnVVMXgvcWlyTXI3N3Y2?=
 =?utf-8?B?SUZSZ2dER2JuM0lFZkZVQXRPWTNXUmFjYVNuQkVMSW9wZEpqNEQ5UFFFd2xY?=
 =?utf-8?B?aXJ2VnRtZktySEdpQkw5YmNTZzkzcDNhUElqbXQ5RTZReHFGK3VDQ244TnRh?=
 =?utf-8?B?Sm1HcTFZRGkwYW9wNGFqTWtuQk9PU2xtcXdHVnRhUVY3dW5HRGpxKzBYbmFN?=
 =?utf-8?B?a2NBK3hzTm9ieWJ0NHdNcUdTa1J2MGMzVWhpdGRHdXIrZ1RPL1VocTJVeE5H?=
 =?utf-8?B?NnZ0UzBiNXUxRFRPKy9ReE4yWUt5MVdUcjRIbXBZR3BQOXBvWnJIb1JGUGY0?=
 =?utf-8?B?TCtQM3hnbUdhckFJbzdyU0FBK3h4dFRBa0lvWTgrTHlCYUZrU2NmMjAwc3F2?=
 =?utf-8?B?MnZIR2N2TVc2dHh4M1l3Q3ZwQUtVQzZLaC9jdWhTTlh4WFMyU091QkYySTli?=
 =?utf-8?B?ajc4dGZSQUo0LzBNYjl3YU1US0I5N2ZnQmo5US9xS1J6UkI2N2tlcnpEQ1pR?=
 =?utf-8?B?OU5URnlERGYzLzlocjAxL0hzZVpyM2cvZnRoclFyVzR4TGlwbGt0Z1kyaDhC?=
 =?utf-8?B?OVJLSnRYaTQrcmk3V2JCQVlkL1hrNXNXYjFZWEw5OWRzUlVVRWRqYXg1WjBY?=
 =?utf-8?B?QmsyZy9lZ2toL012Tk92eTIvV2ZVUjA1cUJnSG5DWmtjVTJFLzJROXA4VXp2?=
 =?utf-8?B?cUhJTCtyN3Y0emZmMmNrajludVlleDlpUUN2Q2l6ZUJHeGJ2R29nSWliY3pF?=
 =?utf-8?B?SnYxckhoRitYU2R3dHQyTm5wRkVmWlhLTytRdThlV2ZVeldpdUNENDc4eS9a?=
 =?utf-8?B?SXhxeXRLSkpLNWY5bCt2TE9URmdkb0NZNjMyUDlLRTZaZ1Rvd2lURzZYajNj?=
 =?utf-8?B?bWlWSGsxMkJaNVhjRlg4WU9rYzZVUzRXTFgxNGdpb1VFRmFPTU1QMTBKai9p?=
 =?utf-8?B?UGNEd2ZySHY0di9RcnVGOERSME9uSGNLeTFaano3S0dDRCtjQk11a2dkZTZJ?=
 =?utf-8?B?a24zcjg4R01XRGw3WGt4OU9yZDJOdFhjdzEyM3o3Tk93eER0TEtjMmJScE93?=
 =?utf-8?B?ZEd1bUNMV1ZySXlFOWc5Z3QzNk1ROWFKekgwK0VIV2hyZ1N2eHRJamZMSHhv?=
 =?utf-8?B?SUE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	KJTk1dDgJs1EzkG6sSB433wjeAyKVN7NDWIdoihvzGvk10eKq9VmgQYzvitYLwTq20Wr5VeSMGy739LRmQHRISup7pEaXoXYgGoK8h4O0DvqYncd/O5fMqB34Br/jNpTyi3izhnQ5zAafecaGO64G/6fSQJEnPqrz7I/zd077UFoG1l/xtriWfG5MM1ipoWON2TmD6ZpEpuceCgTbGNRtX8yoLGMGHF2gyrUAm2O+GWa++g3Te9bZviteOU4Tx83kVhDFc1CUVHylRnvrtyZTH33OArAe5EyykvEnoAJ25aWq9RgFhURXXyNQ2LgfqT5/BXpBe5ONaEIO8OJOxNnTROdaHGQu3ZoBh+gaK8P7h9UyqAKv85opc6sz/rVnyg7DiQuulHV0vsRFzs6TefXPfWiqJlAwplMhkuU0PAzGbiEG2kq7yBa27pvfBzIbZR1QgYBk2emiqa7d35hn5xjPrh2LVb1//G5+9LuXg2p6EYODd/oi21wYJVJLTwxENMEzdi+oaIgqDi64qRLRxCiA8NWF2ZJo8mMlZEcF68MYwXG74O6IvNr9eHpIfDRweftwrqKxm13RI4UFLdHSRww1tumZegdRlmGcf6pGhSnRvU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: abffeaca-282f-4d75-ac87-08de156800c0
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5328.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2025 14:49:16.9142
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l5KARaAqYOcLFmNoMOcukLnpm29xc8pvriyVlOVUXa1JBHtS3xJciZhtpj330D3VWhpf+6bgUIHo10r0BuYUQqGZH+WvM8OIY98jPF4hnG8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6686
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-27_06,2025-10-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 suspectscore=0
 malwarescore=0 adultscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510020000
 definitions=main-2510270137
X-Proofpoint-GUID: kfjVQnUM0h9Wgf-o1QS3-oHL1i5USkVG
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDI3MDA1MSBTYWx0ZWRfX6GtOkOEvUPKL
 a1GlGltEFamwETMDUbVnn7sD9noFc5g9p8ktXPRbeI4o5VpRNLJoDvYa8nrur0+G8JiAs/Brhsv
 uneFOdlxnVlRYXSywLaWNaiRMGV4d8hB827bzBXazHxBBmqOOtviXw0goVUjLezpamf4CTShsLx
 wLn9jALvZsdm6GuWukI0rjDiHruW51R8S1AlUT2GESpCCiamureF2uJY4TaLwd2luOlsqja2ITK
 xcI2PQ18oXtrewiOgYhU/1DmJs3DAyVR/M7/jz5Nw/UCCfVMjkxJORWrPknUj+wLdRE767bTISq
 b6wIXDABSMBkdv7VCBGErgE/0eptphacsRYvntGsbvklsCjiGAautKttVPhMl4LUW1DkSXX67Xc
 556KBTKU/xoreiZSnwO2eLF1iaTWtA==
X-Proofpoint-ORIG-GUID: kfjVQnUM0h9Wgf-o1QS3-oHL1i5USkVG
X-Authority-Analysis: v=2.4 cv=Ae683nXG c=1 sm=1 tr=0 ts=68ff8674 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=MtyykAOHd1RQtSj7XGEA:9 a=QEXdDO2ut3YA:10 a=zZCYzV9kfG8A:10
 a=cPQSjfK2_nFv0Q5t_7PE:22 a=HhbK4dLum7pmb74im6QT:22 a=pHzHmUro8NiASowvMSCR:22
 a=Ew2E2A-JSTLzCXPT_086:22

Hi,

I am wondering if this condition is intentional.
It seems that ring->max_payload_sz represents the maximum allowed 
payload size, so rejecting payloads smaller than that looks unexpected.

Could you please confirm whether the current < check is correct or
if this should be > instead?

24fe962c86f5 ("fuse: {io-uring} Handle SQEs - register commands")

Thanks,
Alok
---
diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
index f6b12aebb8bb..4106fc80c1e8 100644
--- a/fs/fuse/dev_uring.c
+++ b/fs/fuse/dev_uring.c
@@ -1051,7 +1051,7 @@ fuse_uring_create_ring_ent(struct io_uring_cmd *cmd,
         }

         payload_size = iov[1].iov_len;
-       if (payload_size < ring->max_payload_sz) {
+       if (payload_size > ring->max_payload_sz) {
                 pr_info_ratelimited("Invalid req payload len %zu\n",
                                     payload_size);


