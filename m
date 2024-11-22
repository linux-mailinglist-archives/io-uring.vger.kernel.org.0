Return-Path: <io-uring+bounces-4970-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4BD3A9D5C1D
	for <lists+io-uring@lfdr.de>; Fri, 22 Nov 2024 10:46:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 97AB2B20B39
	for <lists+io-uring@lfdr.de>; Fri, 22 Nov 2024 09:46:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9429F15ADA6;
	Fri, 22 Nov 2024 09:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="n0Ncbd1A";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="J2JjQ0WS"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C2644207A;
	Fri, 22 Nov 2024 09:46:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732268804; cv=fail; b=MxWgDsdqqfE5KGpNe7D3Sqy11ZxvUbz+06j2og1YrxThEXPbO77ksO7bm2QIW7ANaCzhNXAJGwBf2yaxamgeOh9CR3OrHxkH1ssNsX5DApMLp8KYvlp2cXPXo+mevmH3TGH8nAEQ8IfOVJyHhhFmNhA1fWXTgcDsQqHS0jgMfAo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732268804; c=relaxed/simple;
	bh=j3mYHc0gHppUHCQ0bU5G0mUKn5vcDfI8uEc8+NPj1nc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=hsTCCO5AQRmg1Wu+v7pIZy5HjFhkZMxO8A1NR+ibwA3ktCTi1EeMZQ3Uy0aSEPsOn84PbkQ9V+ByNGjQCh/LdmVs7H5h4K8VhTN/xs4JUgAxSAahkYOs00GiRY7FRYZL3Z7kU3A06Fi14AiGSlC6j3aFW+akm1kn/mdWRf9A84E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=n0Ncbd1A; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=J2JjQ0WS; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4AM1tkIU026658;
	Fri, 22 Nov 2024 09:46:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=j3mYHc0gHppUHCQ0bU5G0mUKn5vcDfI8uEc8+NPj1nc=; b=
	n0Ncbd1ASU8wSszg4QfCVfgwWJQb5HSQNJNUSkkN4quhDzROnzzJvoczjsrR9W8f
	TiYGozeDPG+THnon8IDsZEwJ0A4tVP/e4c4GFFKwKfJbAQIXW5taViQ3J6xxX6x/
	yy9icVE1OXGQ6JmId62AgMVC+EwX+QGo8e3XiPNIHOePdyeLmRp90mLFkTQS9kgP
	TiGHbPc5MwWndZ38QwN4Mihx5hG+F+agDYhdMKUqMM6SU+vW5WdEgy56Hm9ZdJI6
	siPgoQexvYMPbJvlEZULUa1KiG4KUjtrd+I56G+J1rVMDS88agRgurA618XdVL7S
	as9CkH5MovdyGcX799a5aQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 430rs5f21y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 22 Nov 2024 09:46:01 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4AM7UtZ4023209;
	Fri, 22 Nov 2024 09:45:59 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2042.outbound.protection.outlook.com [104.47.58.42])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 42xhudject-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 22 Nov 2024 09:45:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tsXjgx7zTvSs2shxBWjEqEA3ecxRPmwa7Lt2PS01k4zqda6KSkFNxZ9WFl+eIEDW8bH9q+u4PyxMODkLrMpOzqE3J619b34uncOfZDXUdvlgUCoMmYravhJP3C4xcIvPIx+fZe2rnWtr65D/gazgqHVPvRYBH10NnsFECDpDZUFiw79QtOTkrDv5Cmz2KXx7Vj/S4sv46frwFIvAauEEpul/qxJvW6P32E2kTqsbOSyVxHPLvfLhmput+zEshkopPC2dGU4+cwgiqWSsHFnEcKEkpl8YlYxNbBYqsub9fd6YnKnpJJJ4zy5Gza2wE7TGFuowR1gxUbXdG5R/WEHsdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j3mYHc0gHppUHCQ0bU5G0mUKn5vcDfI8uEc8+NPj1nc=;
 b=aIG46Mia2w18BhA3DEUs5ehJl6tgp2pDdw2S6hgUqF17h7z4h5qghc22aIMcuznkoEul12arhekAbFM/lRA1FwiYAkwB/s/Qz2GI7wGl6CwaS373mRpgyh867cYWYuHgzOg7j8ESbHUMIL7C1OnVY0hIOx2c316/OWAA258fCnTBNMhvsx3jxJhhYUfU/b42UQqbII4ehybd1VQmqZT9/QiV9imaBS5rt0HCur1PndYc0LfLCC5TwAAiJRszJUGBQyC1nAEoQPdh65opvi1GV3Y3uKauVZI/SuR/p8mgORZfCaIbKqP3Qi+AAKtyAJIGAzNFg8Qr4kwfR7HHr4za1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j3mYHc0gHppUHCQ0bU5G0mUKn5vcDfI8uEc8+NPj1nc=;
 b=J2JjQ0WSakvZLRqS/GhzSWyQZGdZhOjvikIgRgPxBvQ8iGpQqepurShxLeUiVFyQ3vuDZTMVzwq4pAeyecjMynZz2j6l1OfTdNmchWpH+wz5x3cNgEjwzSplZENarrT28EN+vqZt1g+joAh0CY7tZKFishApfqFqbUEszuZF6NU=
Received: from BYAPR10MB3366.namprd10.prod.outlook.com (2603:10b6:a03:14f::25)
 by SJ0PR10MB5788.namprd10.prod.outlook.com (2603:10b6:a03:3df::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8182.18; Fri, 22 Nov
 2024 09:45:56 +0000
Received: from BYAPR10MB3366.namprd10.prod.outlook.com
 ([fe80::baf2:dff1:d471:1c9]) by BYAPR10MB3366.namprd10.prod.outlook.com
 ([fe80::baf2:dff1:d471:1c9%7]) with mapi id 15.20.8158.023; Fri, 22 Nov 2024
 09:45:56 +0000
Date: Fri, 22 Nov 2024 09:45:52 +0000
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
Message-ID: <9be80a9f-1587-4e8a-98cb-edf4920e587e@lucifer.local>
References: <80c767a5d5927c099aea5178fbf2c897b459fa90.1732106544.git.geert@linux-m68k.org>
 <4f70f8d3-4ba5-43dc-af1c-f8e207d27e9f@suse.cz>
 <2e704ffc-2e79-27f7-159e-8fe167d5a450@gentwo.org>
 <CAMuHMdWQisrjqaPPd0xLgtSAxRwnxCPdsqnWSncMiPYLnre2MA@mail.gmail.com>
 <693a6243-b2bd-7f2b-2b69-c7e2308d0f58@gentwo.org>
 <f602e322-af21-4bb3-86d4-52795a581354@roeck-us.net>
 <CAMuHMdXDmLoNAcKHpjp2O4D05nAd5SOZ=Xqdbb2O_3B09yU1Gw@mail.gmail.com>
 <508aa9c4-4176-4336-8948-a31f9791dd39@roeck-us.net>
 <4535df8b-0ca2-4c3c-9523-d27d3de2b9c7@roeck-us.net>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4535df8b-0ca2-4c3c-9523-d27d3de2b9c7@roeck-us.net>
X-ClientProxiedBy: LO6P123CA0016.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:313::6) To BYAPR10MB3366.namprd10.prod.outlook.com
 (2603:10b6:a03:14f::25)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR10MB3366:EE_|SJ0PR10MB5788:EE_
X-MS-Office365-Filtering-Correlation-Id: abbc8c04-0969-48a1-fe4c-08dd0ada7648
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?d0NNV0h6NEtCeUNKSGdxVW9RVmpudDRJZE9rTHFYS29WSzg3VVhpNWlFZ2Y5?=
 =?utf-8?B?S3FwT3Q1TnNBdTExcHV3a1gzVzg4NUR4OGVKeEtKcVUxODRsSjY1dU92eERW?=
 =?utf-8?B?dmxxSmpDREVob1lvdDhvTk01N1g5aTVMaTNzZWdmLzl2WGN0OXBlalpPaHlX?=
 =?utf-8?B?RzhSMS8yYnI3Qk5hS3BMelAvWkx4KzU0UWYxUnRBRnFNNVFTcXN4cVVRcEhF?=
 =?utf-8?B?MTFkOTZWOTRUS1NZNVhwVjUzSmp3NTlmRmtxQ0dPU2sycDhhQzJMNzFJbXFl?=
 =?utf-8?B?VDZLZmM0cWJrSzlRcW9OcWdOOFJVY3JDbmk4TlVJMkRMQ3pBVTNmY0h3aTZJ?=
 =?utf-8?B?QWgrWjJJVVBocm03czB1UEhjb3kzTFJxZmdXNFNibVNYOHdrSmtJblhsMlpV?=
 =?utf-8?B?MFhja25ESkozdWdHUFlvaXd1RmRMVC9yMGtJblZTdVFVektQc080S0lxd2RS?=
 =?utf-8?B?dWtUWXJRWkZVTFZVaTFhZnZHcGpHYUZMTldBRHVEbnVoKzhxbUVkZm81VTRs?=
 =?utf-8?B?anhIdklwZzdHMDBMQ29Vdi9kYjloL1BSOEpTWGpTOFk3WXM2VVN4aTd5cVFJ?=
 =?utf-8?B?R3R4MDArbFZhSkNRaFdCa25VeG5Dd1ZBdXdHM2FVY0Ixc3dmeGRmZldrNDhR?=
 =?utf-8?B?K3lNY1N3M3VFLzN0Nmo1RjA5cEFId2g5Q2pIR1RUMnlOVjhkS0dRYnpOdXBJ?=
 =?utf-8?B?ZDJFVjFJU1lEbFU5bVhJWmVDMElNVWZhcGgzZUx0ZTVlQ2RubU1VT0dEZmNN?=
 =?utf-8?B?OVd3QXBsMUVmV3lFUkpOYm5oZ1RiTG5uL1NUR3hXa1d0alV4bXVuL3ZJeGJE?=
 =?utf-8?B?c0MvOVNPLzRzRVZ3ZVBzbzlhSUV2M0F1UE1wVSsvOTY5WlJUZnhnc2NmNzUv?=
 =?utf-8?B?ZW1lQ2cxUUZGUGhUdm01V3MxRXZlM0dOQ1VVV2lIVDZmK085ZE1FOEJKekpG?=
 =?utf-8?B?Zi95dUZxNWZDSzZtL2RtV3RjaXEyY2d0Zm5Za1FyRFFpZXFaUHB1dEpVUkFR?=
 =?utf-8?B?NUFFWjVJTXpia2FuUzJwci9Jcjl2SnFKMWtCWWN4cFloSzA4Q1E0WmE0Tzlm?=
 =?utf-8?B?VExHSTJDZDVLRXgxUGtxdnV0WkdGVmIxVGdXVmFHSCs3aExGQ0NzTGNJdzY4?=
 =?utf-8?B?T05sK29hclMrbk8vcWttUDRsdFd0bEhISzFsbzdsT2dZQ0s4djJ2RWVKek5E?=
 =?utf-8?B?Ym0ydlZybHN6RGpVRzJwR0VjVHBMQTRiVis3bUdGUTdndE9vVW5QL09KekY0?=
 =?utf-8?B?dXE3TXZtZVhlTFVHMmtwcHEzTlFsNm1NKzFTaEVMN1VGWWZYYXdBMlU2cDgv?=
 =?utf-8?B?OUI0c2swQXNhRTlUMElQT3o2dWliNm5lMWgvMC9kTnVuV1FqdlJvWmUrOTVj?=
 =?utf-8?B?OU8wU1dDbGF4SDY5OGhyWkVBTUJ0aGZmRHlhNzBoYXZPUVJwYTZqWlBlTjJS?=
 =?utf-8?B?SHFvSzB5OFJ1azFqTFAxK3huMlJrdjQ4ZnNVVUViTTh6ZHdwRWdGbzZrWVFv?=
 =?utf-8?B?MFdIbGZma29TK1FvQm1jNkJVaFZIWktmd2lVQnRWbUN0ck5wUWM2UXFVaFhN?=
 =?utf-8?B?SkNrMFRQR3FuN1RnZVFaRG91OUxQKzFrUXo0K01ZUHF2UlR2a2w1QU85QkdR?=
 =?utf-8?B?SFQ1MmR1MldpKzBUZnpOVS95V0gveThHbmFwQ201VWV4d2llbTR4ZFdHSjN0?=
 =?utf-8?B?Y2FoSXpRa1FEQzI4dXpRWkppUjVaZDZQTnVyQThIVXhHRldKU1NVeU9zVzdS?=
 =?utf-8?Q?MJcsUp2lwBDGwRx11U=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3366.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Wkl2RHFhWlhLZGJsbTVjS1NFMEZNaUw3YWFLWERrOUhkWUhyamduV25SdlJT?=
 =?utf-8?B?Vkh3VmUxUXl4VThRVDQ4Q3ZkMlE4MjU3K1JyTWNTbUxSdG4wQUJBS3poU0Yv?=
 =?utf-8?B?eFBGOHkwaVhEZTF0WTZ6MjB5WWE5ajI2N3Npb1BQc1VuaVlwVTVPRlYwa0ty?=
 =?utf-8?B?b3o4N1pkczhiYytwZ3hlYVpPTEcyT00vMVlaVDh5UG1TQ2JkYXJYVHJ3cEky?=
 =?utf-8?B?YkpDaG5tRGNGWkpBRG02M3N0cGltZ0RhaGVkUm1mSmMrNmxtSHIxdGxNWHVk?=
 =?utf-8?B?OFNKZmVtcmNUNGpTNlIzL3BzbGpXczFDYk9ISE1Ba3pFKzJFNFBUaG5CbEsy?=
 =?utf-8?B?c2w3SnVYbzJ0KzNmL05UUE9sK3dKbElabk82MnJKSnJScUhkZC9leHBtbzNh?=
 =?utf-8?B?emMzYkY3cjgvZUhmaS8zTHlYS0NZajRMMHRVY3ltQk96RlJnOUR6amNmZzlZ?=
 =?utf-8?B?NjNEbk1MWE5EOGVkNk9TZDYrK3prUEpCQWw4d2xhUW9DNG9HS3Y2ai9YNGs3?=
 =?utf-8?B?MjBiQWhaMDRlUmhVUVBQcVlhbC9oLzBJRzJSM0V0UVNLb3AzT2E2N2NsOGJa?=
 =?utf-8?B?WC9yTW5TZytuOFlTMkVFMmVpcEx3QVVWbitFYkJ2eWVsN0l6eW0zaGhmRTNp?=
 =?utf-8?B?NmNZMXU1TWRSUE5FcjIyVVpmUllxTm9TYW9ONFo4Zm1jNmgvanVCa1hNalBi?=
 =?utf-8?B?Z1o1aktVTWNkR01QVlpoUUljWVptZGx4TUVEaVk2VlowV2pqQWpoZDgvZ1lB?=
 =?utf-8?B?cUxaVkY2WTZqa25wc2RuenlxZzFELzV3TGI0dE92bktlTG5uZExic2YwcHNw?=
 =?utf-8?B?UFl0Q2NSREpvZWNpOHpFcGxQS0FKdDlVL1BlWnY2OTdKWDZYOGJvMnluemIr?=
 =?utf-8?B?TlRnOW1NS3hLdHhPcUtrR0pvYVVIT1BKQ0xSNWJyRkdGVVQ3WlE5ZWs1aEpz?=
 =?utf-8?B?aUVPL0VHQUdQR05HMDlVZGpXSndOUmpYeW44WEQ0cFRJZXZyWnVIV25tN1NF?=
 =?utf-8?B?TEV2Q0JOelBtdmZBT0RDK29ndEI4WVFrN0hpbW5hcFV6QnJJbHdNbk9UaXpO?=
 =?utf-8?B?S1NucWUwOHJRaEU4dmQzMUFuLzhnWWV2MzhaRElWWTJWcDZyWld0eEgyNjZB?=
 =?utf-8?B?eFBkbjlEamREcUZqMmtiV2hHd2RsZUNybm90K1VzT2t5TU9ybDZ3ZXBwUVZN?=
 =?utf-8?B?QitVbDJIVXhHWW9ld3c5OGRHMlJ1M0pxZGV0RGZBeEpWWldYbUxYbkFVMFFE?=
 =?utf-8?B?VWkxRGZta09mQVZQMlc2aUNuNEpSOXZzcTFTbXFFRWxjVTVzOHZud094TjJn?=
 =?utf-8?B?Y3krYXE1aEp4QVBQeGZoWlh6N2RueDI0c2swcmc0UjFVc1E1L1d0TFcvRE44?=
 =?utf-8?B?WEhZQTJtVnczYXNvRTI5aGFXU0tRc1RvcmgzZ21xNXY2RVp4RDBYWFNVcDd1?=
 =?utf-8?B?cFZOamNLQ3F5TDRDV2tGZ29wWTNVSUx3ZTV6ZVFnOUNxc2N1dmJzZHQ2S3pi?=
 =?utf-8?B?SGRiZ1JxV0Y1dXdVZU9DU2hrY1dXNWtqZE12Rk94allUVmVpd0dzcHlnUG5K?=
 =?utf-8?B?QnpLUWN6SWgvaWdNNk9HZGZ5K21YOVZTNDRVc0d5THdRNHd6K21UMEM2ajZa?=
 =?utf-8?B?YTd6b3dQNm16Y3RKMHpMVkZkdzhRczNNUFVEQ28zRGQ3cEo0cnM5ekttcENX?=
 =?utf-8?B?ZCtDTVB2VjhXOEpwYXU2cVpkTFkvOVhNRG1oYlBTSmJ2OEFmdjFualVJd3dV?=
 =?utf-8?B?WUtUdjFFMUlmSmdwTnJHVGhiK1AvUVhvZUZneHhNYWJ3cDJDeXRrSWFQRzht?=
 =?utf-8?B?WU94dko4TlNhVTkrMG1HMFRRcUFnS21xY24rbzNLazdjOHhEUUxIRVhNVmNC?=
 =?utf-8?B?eWJVcXpLQ09mdHFCZXdrNitPY1VoR3pSYkp1eVNCRUY0ZGdXdVZOM3NYSDJI?=
 =?utf-8?B?Vm9DanhzYnVueVBjTURKa1ZyN2hLY3BNMzNZUEdiQ0c1TXJoalB1bkNUa0sr?=
 =?utf-8?B?cEF5aVhQc2NGSnNibGpEVDBlYUlDMWN3b2pPcTlSNDEwdFJNSjNFVzlZTGl0?=
 =?utf-8?B?a0lwWVJSMVNGVnRYOXRXbVhrUXllbFBLMFE4MnRLR1dJQldocHRiRFphUDZJ?=
 =?utf-8?B?WXVmOGhmREFpRVBtaUJlbU5ZNzZJODdrYXVHbFZOVWh2by91OW5Ua0N0UnNL?=
 =?utf-8?B?L3c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	w25dOjPdk8axH6D8iKIlztWlBHgIFgEGpo0X2LjyPpCcqepmrR0jjel8CFi/SZCt3/2spXMaujSLBD4IO/Vg5rvk6GfFy1PqWPb5P9UMAeEHwFnzQn+XX+KSvhvtC3dCkCPHYdoCQZWDwaOH4rsROkp+KQ+7n9KWQKGTXVdGVIknSyWcygDKXJIWboyrHHDHY1KNy6Vp1JcjqUD5Lo57o6Jcu3u+5lwhr5vU+oSpkI+CHclaNdbqMOyactathxtYm+AJTlZTnRi5h68OK54XM85Uxmra4MQn9ROG06OL7+mxZfVuWHxUkutOFtVZq+7jylsC5adaHEv2zCxmSqvweUmh+VcGK3gi5H1NY5Crhzl33RNQ2BbqjVQ3Xs26JxAsgOV64jkZZNzRkkQ6FNkR2s1EiZHEj78nmTLmyX8lB+Y2m1p0zpyS80e5fmnu0bOXgsFXNZlqujBzzJp05M+udzshlZK09VPZ3XZroPHxYf34FnBzV8pi57jBSw12FzItO6jS5r8DBSCcgGFjvp3vRvmmNQ5Tgkzj6g/zcGVwBuxycG0ZMVlEFdmxp8ROVw13b++5Okp9QmdLZi4VcXoJa3dgcLhU31uvUw+EOTTynGk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: abbc8c04-0969-48a1-fe4c-08dd0ada7648
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3366.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2024 09:45:56.3125
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Qf/wBVP0B9RfxnXzFtliJSY0KwWalVDOZu8r9BG1IMbzhdy2Ch6ws5uvFCnJbcvjQ3sbXnG0OforhZRlkqKKYfDvjddjFwXDoCmagUEUfVo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5788
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-22_04,2024-11-21_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 suspectscore=0
 phishscore=0 spamscore=0 mlxscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2411220082
X-Proofpoint-GUID: EqepPbb48ZF2ca4i9WPhQasAuAwE1Oam
X-Proofpoint-ORIG-GUID: EqepPbb48ZF2ca4i9WPhQasAuAwE1Oam

On Thu, Nov 21, 2024 at 11:22:58AM -0800, Guenter Roeck wrote:
> On Thu, Nov 21, 2024 at 11:08:54AM -0800, Guenter Roeck wrote:
> > On Thu, Nov 21, 2024 at 07:50:33PM +0100, Geert Uytterhoeven wrote:
> > > On Thu, Nov 21, 2024 at 7:30 PM Guenter Roeck <linux@roeck-us.net> wrote:
> > > > On Thu, Nov 21, 2024 at 09:23:28AM -0800, Christoph Lameter (Ampere) wrote:
> > > > > On Thu, 21 Nov 2024, Geert Uytterhoeven wrote:
> > > > > > Linux has supported m68k since last century.
> > > > >
> > > > > Yeah I fondly remember the 80s where 68K systems were always out of reach
> > > > > for me to have. The dream system that I never could get my hands on. The
> > > > > creme de la creme du jour. I just had to be content with the 6800 and
> > > > > 6502 processors. Then IBM started the sick road down the 8088, 8086
> > > > > that led from crap to more crap. Sigh.
> > > > >
> > > > > > Any new such assumptions are fixed quickly (at least in the kernel).
> > > > > > If you need a specific alignment, make sure to use __aligned and/or
> > > > > > appropriate padding in structures.
> > > > > > And yes, the compiler knows, and provides __alignof__.
> > > > > >
> > > > > > > How do you deal with torn reads/writes in such a scenario? Is this UP
> > > > > > > only?
> > > > > >
> > > > > > Linux does not support (rate) SMP m68k machines.
> > >
> > > s/rate/rare/
> > >
> > > > > Ah. Ok that explains it.
> > > > >
> > > > > Do we really need to maintain support for a platform that has been
> > > > > obsolete for decade and does not even support SMP?
> > > >
> > > > Since this keeps coming up, I think there is a much more important
> > > > question to ask:
> > > >
> > > > Do we really need to continue supporting nommu machines ? Is anyone
> > > > but me even boot testing those ?
> > >
> > > Not all m68k platform are nommu.
> > >
> > Yes, I wasn't trying to point to m68k, but to nommu in general.
> >
>
> For some more context: I think it is highly unlikely that anyone is really
> using a recent version of Linux on a nommu machine. Maybe that was the case
> 10 or 20 years ago, but nowadays there are other operating systems which are
> much better suited than Linux for such systems. Yet, there is a _lot_ of
> nommu code in the kernel. In comparison, supporting m68k (mmu based) is a no
> brainer, plus there are actually people like Geert actively supporting it.
>
> If we are talking about dropping m68k support, we should really talk about
> dropping nommu support first to get some _real_ benefit.
>
> Guenter
>
>

I couldn't agree more re: nommu, it is the real source of maintenance
issues at least for us in mm, and one I've personally run into many times.

An aside, but note that there is a proposal to add nommu support to UML,
which would entirely prevent our ability to eliminate it [0] (though it
would make testing it easier! :)

[0]:https://lore.kernel.org/all/cover.1731290567.git.thehajime@gmail.com/

