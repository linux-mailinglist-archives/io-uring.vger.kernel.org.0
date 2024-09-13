Return-Path: <io-uring+bounces-3184-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DECD39776B6
	for <lists+io-uring@lfdr.de>; Fri, 13 Sep 2024 04:05:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0AF4B1C2104F
	for <lists+io-uring@lfdr.de>; Fri, 13 Sep 2024 02:05:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C33817BEA7;
	Fri, 13 Sep 2024 02:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NcSQqAoH";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="e1jQyVEi"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFBD1EAEB;
	Fri, 13 Sep 2024 02:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726193129; cv=fail; b=p57ZO1/VeG8V0keZMrpjAJX1Cz6TG4rVcD9rbl/JtkJ3SkbKfpXKsuexkVYyc3YjzJ3rz+lcT1BUal4/b/klyVUCZo24s2bOA13aKpL1xvykfoXfot8CGEv+K1NiZrkWy3dDvz35o3/3bcVbgMVr3+DvMzNPRupC3xUlyMyXlA4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726193129; c=relaxed/simple;
	bh=fGT2pP4K6/X8J5HYvRteheKfv1gh0rWdiRDRRicJy4A=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=EBxXhyVh9qCiWH4ghpbL7ty1cU4dU8uDXUEJVlxpJ5W5uZ2bM1qYe45nfgTubSXOH0TD+jBpNbQNtUrHl2pi7Y65Jc27JUvGFltb1tnWvltpyw9MvQjyc9Ew+XKvB4tEhUPFnQ/fYSVWKKLA9PQJvNF2SG3EeLZZ97xA7d7LYwA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=NcSQqAoH; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=e1jQyVEi; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48CMBY4D003222;
	Fri, 13 Sep 2024 02:05:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=nlIWYwIZKmTtSS
	ktZFewpneH7PDMw2AOIGHP1BmK2iY=; b=NcSQqAoHT+vMlVnXyn2SfZoMXjSZFJ
	XBufAHRYUMvmDOq6HH8uZLsfihRUsxz/6nsCtQRXF393aVcERiYoSHAC0i8RxDDu
	RQfKu3aZbGNYGP3uCGFlV8qozGvZe9JUMp+VyQmnxgAgtIBsaw9Wvlb2RnSl7FPt
	+fLSW7XTYnJ7c2u+WymN6qM2zInUlB2MssX5L7vX8R7320f2+Ns9/q+pcw3fJpxb
	ApYX6NiN/y6jrPg8phmNrya0ZeUXXa6mcforiGvw+XNpO1FsjR3HyfA6AeAcCs20
	Ra948dvWwyBeuhxxYkY6cojn8/BkAOvKoH8cJLhSv9ktSMV1mEfRhecQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41gjbuv3e0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 13 Sep 2024 02:05:12 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 48CNYRX7036194;
	Fri, 13 Sep 2024 02:05:11 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2172.outbound.protection.outlook.com [104.47.55.172])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 41gd9c2h2j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 13 Sep 2024 02:05:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DNLDqJmcl7+GXnWfBdYAhiY68juv5WvDd+E33VEXoNKTaXbn1VNK7tdgkmuuSheh1P0IGulH2ETumCPt9VFk1+xThnhYPPBVJcI5bXh2X4QDxlp7r3BBqSwcONZqmKLSnpA/BASN3cKC2Kud2VBAAZjZ+YPu3ARfImJYEk9cBVR40r7mnnHL9RlWR/+0SJOb6VvAfbUgbh1069W9wZ+r/nxDFoML/Qu7b1FzgwdOI1qe27oVbtZq+5xVZ6vEf4R4Np/jsZK9oBmiNd/o/aFuJTLXP0OVqBUKrs3ZQ6vtumFud0F5+fhaQFz/ZOV60MeAL4D3AM+TvJYkieHbTpgMfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nlIWYwIZKmTtSSktZFewpneH7PDMw2AOIGHP1BmK2iY=;
 b=FUM23M3rR0P8EnemMO8TGd6adEXA70cD6yXs9smVh5hbK2g4gEQkjBPoR+dLjOFYYiOF15e/bft0ZGuSziEspn95f8ihGADAUMBPJOba/oENBATGz2JT7JdVsd7dU0UZynwldxP8OtTPwY5MJIXTrfJT6asec0mrhgAWqw027E7wJuTWFA+Eiz9QhQA141On5Gklw/9Ib7zJlo9cuJF1dfXHxJPTs0Cr2gcAkgaiFUed32sfAt+TQjLpLJt208Pcb/Ds6WQHkD4i/k7+lypHslGGl2ZrP/Z/Rq/K0ts9J9xUWwWdbm/RFXOhhAmEE9hVkyWbWt5FKhTXApg/LrbYkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nlIWYwIZKmTtSSktZFewpneH7PDMw2AOIGHP1BmK2iY=;
 b=e1jQyVEimW+DlRi10YzYFyvjNY6AsJ50lqTyTjurA/1VL02U5KU5XpPHaC2W04fZAQJFvbG9Zl3yq2tweLGkPTsbfctAhiTgLaYEsJ20c+7NOtg8H4KZDidBjxXnzKAtKazY9MSbfA1CEQH16GZYwbpRDDQA6dg4Psz0wNT2Wu8=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by IA1PR10MB6146.namprd10.prod.outlook.com (2603:10b6:208:3aa::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.14; Fri, 13 Sep
 2024 02:05:08 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%3]) with mapi id 15.20.7962.016; Fri, 13 Sep 2024
 02:05:07 +0000
To: Kanchan Joshi <joshi.k@samsung.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        Anuj Gupta
 <anuj20.g@samsung.com>, axboe@kernel.dk, hch@lst.de,
        kbusch@kernel.org, asml.silence@gmail.com, krisman@suse.de,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, gost.dev@samsung.com,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH v3 09/10] nvme: add handling for app_tag
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <efe8215a-9b02-9dfe-db84-988e15d4abcf@samsung.com> (Kanchan
	Joshi's message of "Thu, 29 Aug 2024 15:48:44 +0530")
Organization: Oracle Corporation
Message-ID: <yq1a5gctipx.fsf@ca-mkp.ca.oracle.com>
References: <20240823103811.2421-1-anuj20.g@samsung.com>
	<CGME20240823104636epcas5p4825a6d2dd9e45cfbcc97895264662d30@epcas5p4.samsung.com>
	<20240823103811.2421-11-anuj20.g@samsung.com>
	<yq1cylsc9w2.fsf@ca-mkp.ca.oracle.com>
	<efe8215a-9b02-9dfe-db84-988e15d4abcf@samsung.com>
Date: Thu, 12 Sep 2024 22:05:03 -0400
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0300.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a5::24) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|IA1PR10MB6146:EE_
X-MS-Office365-Filtering-Correlation-Id: fc098442-f3c9-42fd-cbef-08dcd3987d6b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?2s4fCWZZS2OyNSl1qQ9br2+zWB4X6bZXqgzW1hiV7gs9ZGkTMWuPWXhzAzLX?=
 =?us-ascii?Q?Dp6RsMiXXL9S/touXIGFzctJv3jhmZQ/iYfUZUM6TaGH+1WGrR5AHtEcf7xI?=
 =?us-ascii?Q?fe3RPaGDq32BlV7YsZWbjX5Is+CSfFwe4DLyBoe57QuJTyLoA1o4sodUpcHu?=
 =?us-ascii?Q?qi9DetcBl07c/KCkNKbSgA8S6kNgbk2jHrZCD+hZJKdZpCzgtchW2CkRmilN?=
 =?us-ascii?Q?Z8tzZiC9JSy1v8aa6c8/J1Kfjea/VPcATNZ1Pz2YUiJbcdzY1kcuyta5wZiI?=
 =?us-ascii?Q?XbjWxrvShTIoT0YUmHdR9iNoB3OeJZ6cw9/028KY/oH+0aslFCNCQGc43fao?=
 =?us-ascii?Q?qt+V4rdAUmU5JeJqit50y5gqkkb+gEMiqA2nvMhpilHABfQ+WuPBLTVIPKFa?=
 =?us-ascii?Q?295NrzKIgF36Nw+S/zmXfmqU8Nop5XikwLIyPPEU+KxMjc3w3lRUwLF2C7+h?=
 =?us-ascii?Q?XJ0r2ymWJrziMMTgsDoNdso/W8sNYFNnEkDdLyyyfZrI7iuV/I++k8Dwmzdf?=
 =?us-ascii?Q?nINsHEvwev3x7sNGIwlogAf3sZKjBw3/YEU4o9qJQE9fQ4ea1MuTltCO+2Zq?=
 =?us-ascii?Q?BGPwM3v7mkV9qtdo/yf3tOwcckJ53Kl1L2dm7PkyuN0ID8Ndt5bgxXJYfTiq?=
 =?us-ascii?Q?UwfQ4GiSoEZyn21r7HK11Vqs8ieeIw9NhkfWeg/fib2L7gcww2YJ/9TX2Ej/?=
 =?us-ascii?Q?3sF183arNeJV3WJmmatjBkkQVvjm/WVTQ9x5lR0sSS0ffEI1PEbQQy/aFCHr?=
 =?us-ascii?Q?qGp9IR1YZ30JGKXWqfv6RL/ldTwBrm5PNTDv8dPzFq5NF0mTSrfgVStzalcF?=
 =?us-ascii?Q?saQdqSzlxLCq3zulgO+qG/aOEtXNzPTaZeAqlyO/yOa60LGrjOUKQ9v1/FdW?=
 =?us-ascii?Q?mUNyvwcxPrcTtz4R6CV+6rWiZNPw7ojLXaZrhamyPF95Id4/NrD56ERCKPKw?=
 =?us-ascii?Q?T3/MI1xMMpHfaMFBrGpJFFFr9WKH+Mgqg9xoIWkOb/mWfsyR3xL4PxmOCQ/W?=
 =?us-ascii?Q?TELkgToM/Z8TizQi4J2MmMULMTUVFvYbkHgQSLPMWIgUwzjiE6sDrl5AGFEB?=
 =?us-ascii?Q?NJaHJgXQDLuTmYtgI0O6yknaut8f5vuTsC6G6rLgwSDLWVrZaFBC9Vpz0SGp?=
 =?us-ascii?Q?dY1JQ0wLvOYZWq/nm2WifQM5Zl7Iz6gezVNodo2Em58PXnmVgn71+U63jTtN?=
 =?us-ascii?Q?x2ei6aepflJxvZibRL0thxb9cxAuVZ9nxm5fE00GK+wg5T7nwlgLDFsodOoO?=
 =?us-ascii?Q?TXVsa9o1xb9cbtpTs+2d+9nbOvCSOlCQRbTEixFQAfmHuVfCf9gYQDGtymPR?=
 =?us-ascii?Q?T9mNVaXIEpHQupv3bH/kXkRCSMkLR96vNckX/mIX2qm+Zg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?8RYai0ft6T8ePfYOsB8u+9s+8g3pm9YMmvP2WnKQLKWyazOAPgqlRPzVHLRP?=
 =?us-ascii?Q?juL2R5MEY7a4n6tUfgVRkl3yiucWB0rYx821WSfYa98zY3zLsN5mUdpevyZd?=
 =?us-ascii?Q?tGlN+dSeDWk8OQYexrYPysxegLDNI/1pS+Z1usw+8tpTKbN5Mq6+IfOhbRk0?=
 =?us-ascii?Q?18rNlIQPTB2FDFaOLlP/qIHNj7rZhRz0EkaKGCBxI6WuioNjIUVSE0aKqyjw?=
 =?us-ascii?Q?5xt/JG0cKoOdF3j7xufRGa/Jam3kydPrxzwKGkr++h8z1niXb17EPAV4ZmQY?=
 =?us-ascii?Q?NXHP+zKXt8anmY0vNTxcIj/tLKDF4K10UepZJRwnTsXrL2cNypAh0wAXvYz7?=
 =?us-ascii?Q?2SG8wnplSJ9izhNJRl5EkDzgMYPKqiwXdprh9bNM2E5OPPVaS60uM/LVEjqe?=
 =?us-ascii?Q?BPUy+znKGQqdTqNos+N4jxz0Q2b9QnB7pyeEu2LuUqoztO1gi/jr6JWfYZz+?=
 =?us-ascii?Q?PZ/0urOIRVeEC6IlxzkFaqsGFMybk8BnJdjz9vQ7E0S4PQDLCEul8ciSra/f?=
 =?us-ascii?Q?DU9RP5dd0WX9ShNYVgRop40U1sR78hdow6iJr0Gd/EAh8mkFdPsszojL2Izv?=
 =?us-ascii?Q?sNO5+zUy49mhRORquSuhvytqbcyvQYfrohfibMoM2alRDsApw5eDWVk7Ya6V?=
 =?us-ascii?Q?twtgM3YczbC3meLQcTRz2Sf0d8gYEA4+/YeLanr3ME3Cz3hejyjR++/5DDfp?=
 =?us-ascii?Q?y8xj+p1Vjn6iIoL2wN+JI+Vq13XCRKbWtv2B11bV8YU3gFFulrEEjYcVBNt1?=
 =?us-ascii?Q?Wj7nn87yyOVmofWMVzRAsBezmw8LaMsI/a9dEY4yh7t1omGQAXRIfx2e7NTz?=
 =?us-ascii?Q?aOQ0hmWO7TKshZ7Qwhmh2jEQjuUILj75tqHxA8bXStwkRooMxfuauO6U8f+D?=
 =?us-ascii?Q?aln5ywvJe7lrWb/hdit9/S8FQiCyB3lJ1NkDg7DhHsFJz+U8ygoqKJJjbFFm?=
 =?us-ascii?Q?9f2lU1GARvgVDYJhTnM0Xp5gEVQr/69k9ZfxJjM42OJaOooNH0me0+ARwumo?=
 =?us-ascii?Q?AwUynutFmdaDnAVS+NQVy7EWXyEF+ST0iuylUOK0toKAGyFYvnZPBNiZz9Ef?=
 =?us-ascii?Q?zUMtP+4andZ4Xs+z66gcHkXUsXpOdNwP3+BD0OJQwHR8nUEzuuthdLsVxvWF?=
 =?us-ascii?Q?K6NF7BxJkXE+fKDSd2I/kGmjhmDw+TNAkU3vEJe/7XH18KT9/qozftFMp2+l?=
 =?us-ascii?Q?qk7Xp1Z9BdOuMmpThMS14OqYcCgxNvCGr6KCn0s3GWBZ4IXU5D3mUI3sHRIq?=
 =?us-ascii?Q?i2dlVnsXxZ9vEb1z8u5C/YypNbAA8q4ELukn3I11dzM3N6zj2I7oiJR/lsEZ?=
 =?us-ascii?Q?Subbhlxoz6gt+rH9S1AEDMl69qTcneMqlegEVzCLwMl2LxrtMI+EpRYDE5Ts?=
 =?us-ascii?Q?dxzkwKtAUtvR/1LkRPxe2xiH3kirioYBCwOA32cv8pDklAx/7ohgMXwY/3LV?=
 =?us-ascii?Q?hjShdnrX7rFfBDdO2TJ+gttcGaedpUGvI/tLTUe5IZ39XoMLjiQAS2iU4aeS?=
 =?us-ascii?Q?zZ70DVhHN7b/FGu7/IJcmg+NtOoSRaorjU1FqsZfm7XElgJm8H8IMPHPzN/a?=
 =?us-ascii?Q?AiBP2L3GtnqZlk6u4g/vjxfZuT1bpkiQOrTI3RK5SQJts2+d8tD+0StWmOyt?=
 =?us-ascii?Q?QQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	58Z9SZdQFy8fOnSz2gzoTfgY//6Q+nwxT9I2o2VQw4zehP+hIIpXiUn5wXhP6gUjX/q7bgeuBUsYXBZiWSxtf4GFmTONGZHKlTT7Q0x+SNcHmmeI+uNFJsSO5Ck0OiE/F8R+OORmXaTTamEPFw1hzsCOnoXkudlyJimSGQlguaP/3Tmtps5NckMbt21XvdlBQ+r7OCWkaqXNL1uIncdXnWT/BMs7spnJGkdngN/wi6PdlqGcMFk+F/WmaX7aFp2DL8tlzXMv8AOZ/QC1E6GIk1ddAo4LP17cGyZg3gjU5lsym3ZWxQ+SMeq0SLJy3A0yJOrxo2uoBHvClXgWOYaT2W2pxKXaZfMzcdbyFmYxhQh6C3uUR/SJ8ISsNRHrHk0XoqOUjIdvSsmASkZZSN/9OXJwFPweWGLaLxNAo9sOdvnpai0zwH0stRmiNG8djn4Ap38H+o9Xi1mSV0jFgepC/gqmJQcgitwqodtjCXlQ8LX87fcE9/tI+8/bc+7uJ/cbp7AIiSnJOqWMkHyhHH6sS40MgK5Bck7c0ofiqnPFj+uqRKgQGpOBk6+LJ8bLMhqhPM4uGn+7Sfuh2TBwu1VxlKSjEiTTz7pWxg3DCmq1rTY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc098442-f3c9-42fd-cbef-08dcd3987d6b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2024 02:05:07.4630
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wBFGBwGvm1PIZEPOqughSE+cDpQGXt/K4Yd232kadznPQWxxTJHuGNGZdsBL57gUI3oZHemErgL5LnJ7o8nKT6DgB16lnpMYPUPMg2SLkcI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6146
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-12_11,2024-09-12_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 phishscore=0
 spamscore=0 malwarescore=0 adultscore=0 mlxscore=0 mlxlogscore=987
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2408220000
 definitions=main-2409130014
X-Proofpoint-GUID: 9ASv8Ib7okKS2P2qFTBjar7JQ5eTvQIz
X-Proofpoint-ORIG-GUID: 9ASv8Ib7okKS2P2qFTBjar7JQ5eTvQIz


Kanchan,

>> This assumes the app tag is the same for every block in the I/O?
>> That's not how it's typically used (to the extent that it is used at
>> all due to the value 0xffff acting as escape).
>> 
>
> NVMe spec allows only one value to be passed in each read/write
> command (LBAT for write, and ELBAT for read). And that's what
> controller checks for the entire block range covered by one command.
> So per-io tag rather than per-block tag. The integrity buffer creator
> is supposed to put the same application-tag for each block if it is
> sending multi-block IO.

I am OK with that approach as long as the mask is only applied when
checking is enabled.

I.e. I don't have a use case for checking less than the full app tag.
But almost all users of PI I am aware of depend on being able to put
different values in the app tag for different blocks in the I/O when
checking is disabled.

-- 
Martin K. Petersen	Oracle Linux Engineering

