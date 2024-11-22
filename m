Return-Path: <io-uring+bounces-4972-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D84F9D5F5B
	for <lists+io-uring@lfdr.de>; Fri, 22 Nov 2024 13:56:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9A0031F2226C
	for <lists+io-uring@lfdr.de>; Fri, 22 Nov 2024 12:56:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A02C1DE3DE;
	Fri, 22 Nov 2024 12:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="aS/riZmB";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="vZww8BMh"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A72FB1DE2DF;
	Fri, 22 Nov 2024 12:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732280205; cv=fail; b=CB8WIZcU5dO+4yHOK/Qa0BLFx5OFmFlFfGgRqpRuFt4P9ZZ5rCGEKEvrmdrB0hr9nI65gG7rx441FhMpYUE0542yG1zh/hTE3ntGr2RQZGzAtEeAWCpKiO6sT9dUt+FQStWteeFWzRfGsWjW93aBP1FR56YXg6ONN9afQdjipIs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732280205; c=relaxed/simple;
	bh=lQlzAR4FUEPSY3+F9MJ204sR316sgpTyUhM+mvHuAkQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=pRYUNX8tY8A5HFhU7ZGETbV4WseexOO0VJk6iUQlWFOpaGqYl1Bs9nxBQPDnPnlKN1hXtDQjjDasIpgG9XNQK2rHLNF/6wbH9DWdK5fE0OBltPn4OYMd8nuS7WbXEigXLuM7fpb8PY0HWStQSQPoCmW6AFsFt8WlLqoDAQ5kqmw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=aS/riZmB; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=vZww8BMh; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4AM1tmeL019539;
	Fri, 22 Nov 2024 12:56:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=lQlzAR4FUEPSY3+F9MJ204sR316sgpTyUhM+mvHuAkQ=; b=
	aS/riZmB/hvXs5gI2tW49Ki6VKcLzV6djJJQFNIMFUrIQ+LLnueRJJ38/ZrXPwyV
	kY5oEyEpPgJ7Shj4AwHALq7FiCsztmVRQw6pckXMW8Op9KazpNJkC9qg2ulUfDgn
	3ZBrtiy6C0VUQjADclQDJ80QIeaSYO2iKSIZNvEf/l7uIVjT5SVXzjTX+JhsjC+1
	q/QavWitOv57P0JLQDp9WSqs3IBODSCJNsVjL5G0ubj7evMgrKUDNums6MRpK63G
	uDCVQWJmqi/CPxgnVHFllyUFU05QXud9JAlpIjJeqX/3dbtJjB6TdSL22T3AxUVg
	T+Q3tMhew3dCLJi8Sh/tKg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42xjaabv5k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 22 Nov 2024 12:56:04 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4AMBNVgM037280;
	Fri, 22 Nov 2024 12:56:03 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2170.outbound.protection.outlook.com [104.47.56.170])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 42xhuda4cf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 22 Nov 2024 12:56:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vQpzd9KCO6Qz4zMTJ2g/YF3jEpCXXSWDq1FZwETXTQk3JsGav1KWReVS/h3CWi7j3JSGIUXvOIKxHUIIi7lhcim5Lzg6wSBHldllu7Q+KsAsNRrmI05imH/B359B+oNypemw0LYSiIfvi0jSS24AC5oOrqXaTKtVAktDXspkxiCs8JWAi2X7L+CuB6rVC23/aiKhstIZTXTO7aeeQr+Fi1RVuz/yLWHsS/kxuIMBhlwhCFlf5Ss5fo/vZAKKQfXC/dlByDcsuYYqE1lduGVBBUJvYN9sxDT7Re7Bse2MGrijQAHOnWOqHFNoHQygkUvky6Zk9blVy4lFqx47ZP+iCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lQlzAR4FUEPSY3+F9MJ204sR316sgpTyUhM+mvHuAkQ=;
 b=nGUZjR60Zb7nr01CzaR1Um5KYe8y6RBSppOzbSvQ8orhTr+E28CGfTne9lKXIsaCgLRSHWUBVyWjGw3Oi8dqOnmv6xvRrMK2LNTY1HHZmmf62DFu6ab4i92kYxjnu/fwk6i4Wpqq7ItH4/DafnJR+mxMztAptsCm9kQlnyDKspxFaTuhPQ+dEkPwy+Aq0g37sV3SCqf8aTuBiQ4NNERKSHuzwUHS1VIG0g/OZuxsXrP4fu2BrKTqjxogSFcs27wji9R8XoLABpxmIDaf1HjgcjdB3F73I8pKR+nxS1HTpVg+ldzyN+MJXK01FSwpf0zVIxo9q/rskI81RwSZohPPww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lQlzAR4FUEPSY3+F9MJ204sR316sgpTyUhM+mvHuAkQ=;
 b=vZww8BMhZsG7t6VwZZMgPqii1vsUErGrRa3XwrscT6ciyT6PMZCv6QxqSTiKgO5+r41inlVeZqMGNvTfTlVUYCE93vL1qoUXg2xGt5QRH0ojnH+DcK864Dl3QUmeRPo+XOfEnx2UIutMwQmZUXxszci3PddgXRwM/xSeiYyWE0g=
Received: from BYAPR10MB3366.namprd10.prod.outlook.com (2603:10b6:a03:14f::25)
 by DS7PR10MB6000.namprd10.prod.outlook.com (2603:10b6:8:9c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.22; Fri, 22 Nov
 2024 12:56:00 +0000
Received: from BYAPR10MB3366.namprd10.prod.outlook.com
 ([fe80::baf2:dff1:d471:1c9]) by BYAPR10MB3366.namprd10.prod.outlook.com
 ([fe80::baf2:dff1:d471:1c9%7]) with mapi id 15.20.8158.023; Fri, 22 Nov 2024
 12:56:00 +0000
Date: Fri, 22 Nov 2024 12:55:45 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        "Christoph Lameter (Ampere)" <cl@gentwo.org>,
        Vlastimil Babka <vbabka@suse.cz>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Hyeonggon Yoo <42.hyeyoo@gmail.com>, Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Mike Rapoport <rppt@kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        Kees Cook <keescook@chromium.org>, Jann Horn <jannh@google.com>,
        linux-mm@kvack.org, io-uring@vger.kernel.org,
        linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] slab: Fix too strict alignment check in create_cache()
Message-ID: <bdec868f-d366-40d0-82ca-0bf19422410c@lucifer.local>
References: <80c767a5d5927c099aea5178fbf2c897b459fa90.1732106544.git.geert@linux-m68k.org>
 <4f70f8d3-4ba5-43dc-af1c-f8e207d27e9f@suse.cz>
 <2e704ffc-2e79-27f7-159e-8fe167d5a450@gentwo.org>
 <CAMuHMdWQisrjqaPPd0xLgtSAxRwnxCPdsqnWSncMiPYLnre2MA@mail.gmail.com>
 <693a6243-b2bd-7f2b-2b69-c7e2308d0f58@gentwo.org>
 <f602e322-af21-4bb3-86d4-52795a581354@roeck-us.net>
 <CAMuHMdXDmLoNAcKHpjp2O4D05nAd5SOZ=Xqdbb2O_3B09yU1Gw@mail.gmail.com>
 <508aa9c4-4176-4336-8948-a31f9791dd39@roeck-us.net>
 <4535df8b-0ca2-4c3c-9523-d27d3de2b9c7@roeck-us.net>
 <9be80a9f-1587-4e8a-98cb-edf4920e587e@lucifer.local>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9be80a9f-1587-4e8a-98cb-edf4920e587e@lucifer.local>
X-ClientProxiedBy: LO4P123CA0514.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:272::21) To BYAPR10MB3366.namprd10.prod.outlook.com
 (2603:10b6:a03:14f::25)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR10MB3366:EE_|DS7PR10MB6000:EE_
X-MS-Office365-Filtering-Correlation-Id: 27441bd9-8e0d-4f88-10db-08dd0af502f7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZXB0ZHJROEliSDdJMHNXWU85YmNVSXYyRGFEZnoxWnNTN3lob1YvS05QVWRm?=
 =?utf-8?B?VTFiQzVQWWlMY1RiUHNteU14YW9ucFU4MlBnTVZZVFJvMmJMQmVUVllkSmNl?=
 =?utf-8?B?eHc0Y0dTS1J3SDkwWXNIUkNGZlJHU0h4RFhvMzh6dGVFWWlSek54M0dHZ0Iw?=
 =?utf-8?B?WjVEWGh6U1oxVXdpRDhZUFlpTlZpUmtyQk9ETjZLeWpUOENlYjc2ZDFMTWV5?=
 =?utf-8?B?RVVMbnFJSGhMK3F4YU5DVzBUcDl6K3luWmpmU3J6VnM3OGFPZmFoZ2FGQ2Ev?=
 =?utf-8?B?VHprQ1dDdlBLTVRDWHphSWhJS3BUb0lETzgxN2ZHQ1hSYUk2dXg3b2QySVM0?=
 =?utf-8?B?dVhPeGFtY0U1dytDOVVoMFdYVHJVWE51aCtwenVRb21MOTV6a3RLczVYL0U2?=
 =?utf-8?B?Yy9UZnJkWEh3amhZcVE5M010NXRIY3FQcDVEM0ZoUGRVSVhVQlVzMmRTY0hs?=
 =?utf-8?B?OXFIZkdwRk5YMURRSTY2eTFDQ0tFaFRiR2pLVDhSbDM2QzBFUFBReXJlN2hn?=
 =?utf-8?B?SXk1ODhSYW5NWnlScU9VdjNlMTFaeG5Td00wN0lWSExBTU5NUFdoNHNzd3JD?=
 =?utf-8?B?ZW1TYlE2NWU1T3BhL21KdTJheE1oc09lZ2lqRFRYY3c3NmxvNE9yNURQbVFJ?=
 =?utf-8?B?OU1lN25FT0s1U1Qvbmx5WFYvYUJFc0RQVDJiZ0NEbEZEb0pNcVJrWW9TWUhR?=
 =?utf-8?B?UGlMSVJFNDMxOTJoUlJDNlFmWWtRaWQ5MmtPWVN3Y3RZdTZ3UUNReHZyVkJS?=
 =?utf-8?B?bk0yNTkzYkdBZ2xmT2hyTmdHNVR4cGdianRhd1BpdFNpTUwvMXBBeEhZRjZK?=
 =?utf-8?B?cCtzMmxhY2tIOWxuN3JkZHZRVHVoQ3BObUN4Z1dZUnNtaGY2OFlGeWh1S2RC?=
 =?utf-8?B?RWNvVlc2RzVkbG1tT2QyM211M0ovcVg2WHRFRWt0UzNwYU5BYXRJNkZxcytk?=
 =?utf-8?B?NGZQM21ZZUc2QVF2eUc4cG9adlJxU1Roa0FUMFBsUUFDN1B6RVhEbkVaT0s3?=
 =?utf-8?B?S2VoSUFwVU1xRUhzSW1DY0RBVUwzQkhPREdZVVVSTm9vMUFKUUlXZ1JNZUwy?=
 =?utf-8?B?aDVQcENkMlMyZitBc1lrTTdPb2tvS3VSQzVxTTEra0JZUjZqK3FWMEp3YUZk?=
 =?utf-8?B?M3BmRzN2OWhNekxEckxYNHRNY2hBdVRuUmh5SXordEl3U0ZJK3NpK3k5NGNx?=
 =?utf-8?B?b1d0Q0NJZUZ0YUxyMkxudnJnVDY5MFpKUExkTVNUK2tRSU9FYWRnblArQUpl?=
 =?utf-8?B?OU1xalI1ZkZZNUhUZ25Wb2ZVR1EwU3IrTmdocnY5K3lZNTlZN3IxVkNSQjN1?=
 =?utf-8?B?NUgrbHN5TDNlZGgyRnkwZ2F2M1IwWmJFMGIvZzZxZGo2bDRISzZ2MU80MUhh?=
 =?utf-8?B?dVB4TU9jeW9weDBwdW9RaUZ4QjFVUjhJWUw0M21YYjdmM2dtTnRLc2FmQWJj?=
 =?utf-8?B?SjZTR2YrSDZJNi91YjNjOExjM1RrcVdMc09xRVVQR2RZU0tPczdaTk4zc2ZL?=
 =?utf-8?B?WFROUjIxV1F5OHF3NHRLOW0vTDlHSEtMRk9Ceno3UGNNa1Zocy9rS3cxR2pl?=
 =?utf-8?B?WXl1bXQ2enBDTmxIOUNQZHgxbGUyYXFEZmQ3MEgxTTlUUEtRZ3QxRzdJcGU0?=
 =?utf-8?B?SktVNWtvKzZ5ZjVCa1NJSTEyWVNmQUp6Y0l6d09JUWhvRlE2YW5lYzl3TXFq?=
 =?utf-8?B?YTFHM1h2VWM5bW9Eamh5WkRwYnpkU3NWUitnaHZLbWcycnhkSTQrY1RnPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3366.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dFNTdFF3Rk4vbXIydHJ3anRHZkpUaWlFMzd2dDhabWo2b0gwNFU5QXltUG94?=
 =?utf-8?B?L0pTSEJrZEwwODBSNGwrK3Y4NTZNS2p2ZFJSYTJ1THZNQmNnSkdiVkR6RkNr?=
 =?utf-8?B?QlM4YUd4ZEJhU2NqUUlWWWNvbTN4Q2NwdEVnTVdyc3l1N09KWEVtVFlZcm9v?=
 =?utf-8?B?eExoNFg2ZUd3OXY4dWt3UDk1Nk9qTWc2enk5QzFZS1VXb2hkSVJpL2gyTk03?=
 =?utf-8?B?bFU0eDNGTitkbXZRUitJUktUeEFBZFpZSnM5Q2NmSEJCaDYrUHZGclJTYmFh?=
 =?utf-8?B?Sm5aTmxpelpBRGFmdmJMd1Rha0xmdEZFY3J2Q1B2THhHbEpGbEFETzM1dGZN?=
 =?utf-8?B?S0xzZWZwZjB3Ly92Yys2RzNKUlBFaUZqdFJZSVRvOWkwN1RlaGhhWTdYWnRs?=
 =?utf-8?B?S240aVNGQlJRRjYvWEdqZ1Z6Q0toeVFNRVpNVzVuZXc0OGZ6K29jSFc4YS9r?=
 =?utf-8?B?bEJ0NlJnQzBOWTBldUtaSEcyaC8zZmQ3Z0VvQTZNeDF2Sm9HdkRhMW5jTnE3?=
 =?utf-8?B?NTByMzEzZEVUSzdGWHZuR0ZwQXhuVjR4WFRtdk5kZkdmWWlkNnhPRGFjLzFH?=
 =?utf-8?B?R3JIV3RsQjF6ZGdVTUVrSkN0QmhxUmNRazBWZWQ1bjNmWXZWTjBENFFnaEIr?=
 =?utf-8?B?RGtkRENaUTZncUVmaVZrRGY3REdmblJLOXgxTVZhUkk0L2x2akg0ZXRWcVhu?=
 =?utf-8?B?T3d3R2QyS2UxRHFldU5EM29uaGR0YkpNSE44WHUyZWVXcnJOVjFyUlhFQmEx?=
 =?utf-8?B?MUg2RDUzTnNBaSs1MlBrbnIvRUNMYnpzalNicU4rYUI3dmg2RW1HVXVtbGNn?=
 =?utf-8?B?MXc3cXVKcDZIZGt6cSt1QUZpZk1jcXJ0TW0ydGhIeXVNdzVSbSt5YmFqTmx5?=
 =?utf-8?B?cS9WaEhSaUdadmRKejRWVFYzcWNXVDVSOS9BdGtvejRiUDhyYW1BODBQTTlz?=
 =?utf-8?B?TlpvY0c2Z2wrSytjOHVhWEU3bjh5V0NQenJuTzhLVXFabDN1cWkzVllVOGFS?=
 =?utf-8?B?MGhET2hhejZQYTlkNG1CSFlqaUVSOEVONHl6aUdDUkpCZFZuZ013WmQ4VFhs?=
 =?utf-8?B?VnUzRTFDKzZiUnRJNFNrNjNoQ3IzNzBjVXNHRWJqcFdBT21WbXVqWnNkeGpS?=
 =?utf-8?B?WkZoYndHMlZIM2lFZVdjWHpuZnRWU1pHaWRxNTJheCsvdllwZVFJWFo5V2Yr?=
 =?utf-8?B?VzFZbzlDbHNyTmdlRlRwMk5OMHdEb29neVlySmRqNmVHdExHNGI4eU83bTNq?=
 =?utf-8?B?T3FlSkkxT0VZL0w4SmtPYUFZYTF5aXJxRGpibW9YMi9MbGczMTBXWk9xLzZT?=
 =?utf-8?B?NDRqK2lJclNwaUZZT1daZTZsOStwUE9pUVN1U2NYTmZMc1lKTHlOdy9GYXV5?=
 =?utf-8?B?dEpTK0JsVWFHM1dMTTkyUndxcFF5T0RmdEhWTVNaSXpHbkJsb2VGTkxrOWlr?=
 =?utf-8?B?Rjl4WHhuSTE1Q1piOVFoQ3pSUzNHU3FUazFnMmhYNkRwZXdhL2NCYmNjUmF5?=
 =?utf-8?B?UmFwM3BqWE8wdC9vd252dVVoNlI4N0JyY2tmeXF4VG43aUVPMGNvWWJvTVdW?=
 =?utf-8?B?KzVlbUxXN2Z0OE11T2hybW1hZkFUeHB4YkZRMVpaU3oxVk9sVVlNL3ZFaWhl?=
 =?utf-8?B?RTJ5eDFGS0lwV2wxL2pHd1dxTFpSRFNZMGVLNjJrK3E5dzNrMDVIYkNlSTdI?=
 =?utf-8?B?WGN6VlJOTXNUM2pQZi96RjU2SEZWRkQxSEhFUFhjOWhYSUdJNXhyY095amxU?=
 =?utf-8?B?RVpjOFVBOGJjcnB4TnY1VXc3enhWWGlyNWQ3T1pwNUc2R01Ed0tZSTRqNElh?=
 =?utf-8?B?SVFqM0g1QytaZW5UQnQ0Zk5yY3JPTC9NcTBlbWs0YjVnU3R1SFpna1ZlNVgv?=
 =?utf-8?B?bFVQUjdjaFNzZUg2OGErbk9YM0RqNytDN2o3eUcwUDZyc3pac0VYNWxJUVJw?=
 =?utf-8?B?OG95b2kyUTBJeVREVHkyZ0tjUXJpQnlIdVNKTXJDcjc5d0E0aTV0Qk83emdH?=
 =?utf-8?B?V1FZMUU3eXZCTlFlRHZQcjZ5TUJYeUh5V1diQzM2WDk3bHRraHpWTmFqVFVs?=
 =?utf-8?B?eERGNDNOVS9rRGR6V211WlpDNkpmZUVHaFNjU0ZaNHZSUUVqQlV0ODFPUUh2?=
 =?utf-8?B?UW5GaUpkTWw3YTFET1dBclY5U3JvL2FIeXBIVkVxUlBycFpsbGo3U296eUpC?=
 =?utf-8?B?OHc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	9tUKKNTQojgInF+plZ7alUNSdbf1SanVCxQnga7sXcR0lClMq9023llTN+NED3ybKgkrpV95731xcNA+eDt8q4VD669ISk0bCWFE7+Gb4lKVyPKGudo5m+wKlV7srXEip8OpSXsaqzIZmVvSzL6JD7fpKOiw3l9jZ2sXw0sr2R0y/GBkTpcayy29FQXJD8SDLRMaTo522rZ9f1f3tuN7CFkUtElIUes8V8eodDHmURmDgD1aIuerX4I/VHv15KP36yJ+Qy4n/VzgJtcoszxsoqMB7z9jeLiMfLA16XsIe7qvSwdgq85L0iYeg2O+cp57xiN9bB/7AioC13kyI94TsaKGq0Uz6XjY/LjKbV3JA59zcVYUQlO7q4TtzDxeLlsDUstBUEIhvRasj50QAY5Gs9S77adGyZL/QyL34DEPMndpfuZZk9JeSg2o13DwczLItPevWSgoy+1I9bJkWeWkhkPZ67ZKpYe/NxJQrN5gIt7oCmBJTaEedj7p/9WLjMoKbWaIFmdpV0cidf0WM1vlf098L6TOQ8/+tAtLIeJURJ+Y3sF8aL16hPkYVmqal89EryP9qcbb436hq9lit6dvU98JsQSFvoZrC8xIr2qpd0s=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27441bd9-8e0d-4f88-10db-08dd0af502f7
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3366.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2024 12:56:00.0233
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cBMn1sAQdvbsV5oAAZ44byc37HMiK86pWgG0Q1dJXW7hCjI6s/Zy+3Tvl/HAeEQSJWnzWNTFs2iSccn3r0eR1L2YQDddH8YPcKwVOZICf/U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB6000
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-22_05,2024-11-21_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 adultscore=0
 suspectscore=0 mlxlogscore=999 phishscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2411220109
X-Proofpoint-ORIG-GUID: Crn3Up36ETyzupOXjPsztFDr09JFqnD8
X-Proofpoint-GUID: Crn3Up36ETyzupOXjPsztFDr09JFqnD8

On Fri, Nov 22, 2024 at 09:45:52AM +0000, Lorenzo Stoakes wrote:
> On Thu, Nov 21, 2024 at 11:22:58AM -0800, Guenter Roeck wrote:
> > On Thu, Nov 21, 2024 at 11:08:54AM -0800, Guenter Roeck wrote:
> > > On Thu, Nov 21, 2024 at 07:50:33PM +0100, Geert Uytterhoeven wrote:
> > > > On Thu, Nov 21, 2024 at 7:30 PM Guenter Roeck <linux@roeck-us.net> wrote:
> > > > > On Thu, Nov 21, 2024 at 09:23:28AM -0800, Christoph Lameter (Ampere) wrote:
> > > > > > On Thu, 21 Nov 2024, Geert Uytterhoeven wrote:
> > > > > > > Linux has supported m68k since last century.
> > > > > >
> > > > > > Yeah I fondly remember the 80s where 68K systems were always out of reach
> > > > > > for me to have. The dream system that I never could get my hands on. The
> > > > > > creme de la creme du jour. I just had to be content with the 6800 and
> > > > > > 6502 processors. Then IBM started the sick road down the 8088, 8086
> > > > > > that led from crap to more crap. Sigh.
> > > > > >
> > > > > > > Any new such assumptions are fixed quickly (at least in the kernel).
> > > > > > > If you need a specific alignment, make sure to use __aligned and/or
> > > > > > > appropriate padding in structures.
> > > > > > > And yes, the compiler knows, and provides __alignof__.
> > > > > > >
> > > > > > > > How do you deal with torn reads/writes in such a scenario? Is this UP
> > > > > > > > only?
> > > > > > >
> > > > > > > Linux does not support (rate) SMP m68k machines.
> > > >
> > > > s/rate/rare/
> > > >
> > > > > > Ah. Ok that explains it.
> > > > > >
> > > > > > Do we really need to maintain support for a platform that has been
> > > > > > obsolete for decade and does not even support SMP?
> > > > >
> > > > > Since this keeps coming up, I think there is a much more important
> > > > > question to ask:
> > > > >
> > > > > Do we really need to continue supporting nommu machines ? Is anyone
> > > > > but me even boot testing those ?
> > > >
> > > > Not all m68k platform are nommu.
> > > >
> > > Yes, I wasn't trying to point to m68k, but to nommu in general.
> > >
> >
> > For some more context: I think it is highly unlikely that anyone is really
> > using a recent version of Linux on a nommu machine. Maybe that was the case
> > 10 or 20 years ago, but nowadays there are other operating systems which are
> > much better suited than Linux for such systems. Yet, there is a _lot_ of
> > nommu code in the kernel. In comparison, supporting m68k (mmu based) is a no
> > brainer, plus there are actually people like Geert actively supporting it.
> >
> > If we are talking about dropping m68k support, we should really talk about
> > dropping nommu support first to get some _real_ benefit.
> >
> > Guenter
> >
> >
>
> I couldn't agree more re: nommu, it is the real source of maintenance
> issues at least for us in mm, and one I've personally run into many times.
>
> An aside, but note that there is a proposal to add nommu support to UML,
> which would entirely prevent our ability to eliminate it [0] (though it
> would make testing it easier! :)
>
> [0]:https://lore.kernel.org/all/cover.1731290567.git.thehajime@gmail.com/

To update, some interesting discussion in this thread suggests that indeed,
there is an ongoing need for nommu regardless [1].

In which case this nommu uml series is rather helpful for testing :)

[1]:https://lore.kernel.org/linux-mm/09060fcf-47e4-424f-9ab7-ee2f7919dbf5@lucifer.local/T/#m0cb0ace28f3905182369790ddc1b494d408587b9

