Return-Path: <io-uring+bounces-5109-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 04CFA9DB15E
	for <lists+io-uring@lfdr.de>; Thu, 28 Nov 2024 03:10:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 601E2B2319C
	for <lists+io-uring@lfdr.de>; Thu, 28 Nov 2024 02:10:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 528A242065;
	Thu, 28 Nov 2024 02:10:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gQonMtnG";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="lpWuv4pK"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74ABE38DFC;
	Thu, 28 Nov 2024 02:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732759834; cv=fail; b=QAZEG0zzxznq4t8g2BA7wZRVpuzQJPzgSrdXUm0CrKL1FqQmR2XKhL3k/O5yhfoJ3lhHp7k5xdWTLG+wLZQK16Z1vyjiecHqCJ4DKJJddMxS/bv7ijg9qVU0o4WXT5l64mR8cp6FiCBpr0IAQ4G9qz69pUQiB7Gg9jkB6GfeBoE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732759834; c=relaxed/simple;
	bh=DI20/oYZsu27Sxxg18Y81V4Bat/kuEHwSna7i2h+AI0=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=KM9q/NHgSoRzLRB8tT6uOzXFvQEOI++AVNe6jWikwoaWE++c8LXV0hz3/2YLe7MjUrKmllZpTZ2TXjoYtIiFIoW+snuErBflywueUiHrQRoruKxj5uR+SbAOmeQjj9QcjrxN1dZ8CY8zZhZ7rRP92zetMVWZKJhs2q7AyhmyL2g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=gQonMtnG; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=lpWuv4pK; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4ARICQP9012141;
	Thu, 28 Nov 2024 02:10:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=4FKbdn4g5F3RdDSjvU
	c252B0H/DpRy3PkFeSwnl0gKg=; b=gQonMtnGJOcSp7Bn3+UnFbm/vnsG9rgHYX
	iWIEX70eiw9NqishDubXmieYOPbi3WN4h9Z4R7fF7MGb0gUg8BcsNWoOuSvP8q0n
	+Nc/aHRNFju6dveP4suYqbvHYlYUYlh8buCxNBpkG7CEgKL5cT2LeQ6GU9YVO+bc
	ucL3ijph3CValWRDVTsoPmWENM7HR8w5/WmFApiLj2fdCr2HPPn9+CBjSMw5/TJ1
	pnFTmGDURewdsJLspwzrneHS2IoUyGyu1WvtQS3hTJwTnN+EeirxET/S88vzvhf1
	rjkcNg1ModdjQCTALul0JwoSKD+sLveVRu1Mm7nva62aMKGzlXHg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4366xy8tv2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Nov 2024 02:10:02 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4ARMhTVa022425;
	Thu, 28 Nov 2024 02:10:01 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2040.outbound.protection.outlook.com [104.47.74.40])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 436707s8q1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Nov 2024 02:10:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mCI7nlqlGtgsRJPc5vklkugxgVrWr24BVOED32WQcgwtFb0pV1DLkeljfP5BsYg5PZGoSe0elCS6VY/MZbULF4KhXyfl8xpxb+m6MeotLa9QHPbbDO6YUWNBR20lwMBwgDv6nB8L6suwPnNTSTq2/elfONiHaK+dXvgoxxyBt3hRjseaGmmvtfJ8qZgkKZZ3Pfg587slpq94Aq0OJcJN7KUzyTAtoKLooTnXEomJ+o+nn8LT8bPU2aWfs2mu14pubyQIy4GSTW5Dp5SlYXOMJxaTqLVunkOb9yPMrW31L7s7X1dXGnMSwmwIIkHzyld4sRHtdjVGNUfILh+GnHRJ4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4FKbdn4g5F3RdDSjvUc252B0H/DpRy3PkFeSwnl0gKg=;
 b=CnWqhKhzYvTwrN4ev+yiBlvJ8bhWJg73bvQO7ZtiqKKptoTw6yFUX5hh3/kmEHrCuWynKZBIBhikSTBQrNJvC3688WArGGo5sv9IVHFvzUPEH2riaqCdKXP4RvHzRTNlBlgtq2goD6KMkoIZz0PBAY51cH3VQk9O0NV5tazAZdzirKkRqOPDaLd1X4ugNOYh0zirnxuAmKjC6T7pa0yhkloBoQG/HQPxnQ193SMohqQpil66szdC92sjBr6TCVpFxQPwEGIdWrjXnP+GkNPjCzbvwqmvTlw1vrxy28Ku6/KqP4RJbNXwNBx46NWcEJh5UMylfw5qvZad6g/ANYHMTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4FKbdn4g5F3RdDSjvUc252B0H/DpRy3PkFeSwnl0gKg=;
 b=lpWuv4pKh9nnwQL1ocT6r+NNtQS5RMqWjJBcKdWypE24qAEup6gD+f79jDo6bsflb2HuCD1X3EgdykfkIzeRoqia9/PxRjX6ZDd/UaBCAtzQnB+hr2kS7aju0jBjf5/V94Xe7T1oT3RJHrG9MRlV6xSddp8Mp38NrF+l/gqTpm0=
Received: from SN6PR10MB2957.namprd10.prod.outlook.com (2603:10b6:805:cb::19)
 by PH0PR10MB4696.namprd10.prod.outlook.com (2603:10b6:510:3d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8182.23; Thu, 28 Nov
 2024 02:09:57 +0000
Received: from SN6PR10MB2957.namprd10.prod.outlook.com
 ([fe80::72ff:b8f4:e34b:18c]) by SN6PR10MB2957.namprd10.prod.outlook.com
 ([fe80::72ff:b8f4:e34b:18c%4]) with mapi id 15.20.8182.018; Thu, 28 Nov 2024
 02:09:57 +0000
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        Nitesh Shetty
 <nj.shetty@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>,
        Matthew Wilcox <willy@infradead.org>, Keith Busch <kbusch@kernel.org>,
        Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@meta.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "joshi.k@samsung.com" <joshi.k@samsung.com>
Subject: Re: [PATCHv10 0/9] write hints with nvme fdp, scsi streams
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <7835e7e2-2209-4727-ad74-57db09e4530f@acm.org> (Bart Van Assche's
	message of "Wed, 27 Nov 2024 13:06:17 -0800")
Organization: Oracle Corporation
Message-ID: <yq1ed2wupli.fsf@ca-mkp.ca.oracle.com>
References: <20241105155014.GA7310@lst.de> <Zy0k06wK0ymPm4BV@kbusch-mbp>
	<20241108141852.GA6578@lst.de> <Zy4zgwYKB1f6McTH@kbusch-mbp>
	<CGME20241108165444eucas1p183f631e2710142fbbc7dee9300baf77a@eucas1p1.samsung.com>
	<Zy5CSgNJtgUgBH3H@casper.infradead.org>
	<d7b7a759dd9a45a7845e95e693ec29d7@CAMSVWEXC02.scsc.local>
	<2b5a365a-215a-48de-acb1-b846a4f24680@acm.org>
	<20241111093154.zbsp42gfiv2enb5a@ArmHalley.local>
	<a7ebd158-692c-494c-8cc0-a82f9adf4db0@acm.org>
	<20241112135233.2iwgwe443rnuivyb@ubuntu>
	<yq1ed38roc9.fsf@ca-mkp.ca.oracle.com>
	<9d61a62f-6d95-4588-bcd8-de4433a9c1bb@acm.org>
	<yq1plmhv3ah.fsf@ca-mkp.ca.oracle.com>
	<8ef1ec5b-4b39-46db-a4ed-abf88cbba2cd@acm.org>
	<yq1jzcov5am.fsf@ca-mkp.ca.oracle.com>
	<7835e7e2-2209-4727-ad74-57db09e4530f@acm.org>
Date: Wed, 27 Nov 2024 21:09:55 -0500
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0303.namprd13.prod.outlook.com
 (2603:10b6:208:2c1::8) To SN6PR10MB2957.namprd10.prod.outlook.com
 (2603:10b6:805:cb::19)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR10MB2957:EE_|PH0PR10MB4696:EE_
X-MS-Office365-Filtering-Correlation-Id: ce20714b-b3cc-4e77-be20-08dd0f51c1c3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?TZJ9YJYXWaLUzOyEWgyJ6uW0jw646y1ZSoBKDkrYqL58D33Lopldv13N4b4o?=
 =?us-ascii?Q?Naz6P9wu+/UHKZuJBR0d87sJ2YPNc9jSjCjLO/YPu5l53scrlq6lWmHGHNVn?=
 =?us-ascii?Q?aJ9UZHdNPUBDHe3znGViyrigympeRuV7pDPdoRcSHXXIq0TDu2ywyGfVEh8/?=
 =?us-ascii?Q?BQw0HAUPNgX5uATHgm6CohS5zVg+GjBYGwOWBxqpwmeP9DGyu7TldH/lhj9Y?=
 =?us-ascii?Q?n1bBvg1325iXfyxRKhAd5andTSfT/N6b7TVS+odLyEtaXVpRiLg+CneOH6pc?=
 =?us-ascii?Q?VfJczljlUjf6FELf3yaf85EWVB3uqbk0l0bI48Pz3b+fowpfXNr82Tf7CM4W?=
 =?us-ascii?Q?TKQfATK+oYLPWQmy6jI7sekD5HSSsDEJIl0RpM43pCZkk3V9qvs+E9dImOPT?=
 =?us-ascii?Q?YpSV+5Adsptd/XuMV/4s8rniuP8/Q8RdkA6mk8x/f1asH/xSoqtztYoECMca?=
 =?us-ascii?Q?5Isy0e1VMZzv0XaAaO0TBpCLy7DB2/MmBhHDfydn+hoa0LvpLvZWYQl/jEkr?=
 =?us-ascii?Q?XuZ/7k88lfdQv93u8RPRnxQpAOUxsLjATDMYsbe8buPBKzBduUmSCSRp9Wtm?=
 =?us-ascii?Q?0bm1NCOVrG1C6E6sIUfSKtv8UlGOBJtve2CSYMAJVIsTcKBoJOqeM/1BmlCy?=
 =?us-ascii?Q?9rd4r/c+qD1oNCAtVRqesHgRBDbaDnUUkVde+563x/JzS1aAPZICjcLj5scM?=
 =?us-ascii?Q?qQ0NmScXSrV7NtMSY3oexrqcXn5ZNNwBdAyTl3fMvLdxfWvfJE2pBuYzhhb8?=
 =?us-ascii?Q?LTfiX8vLbAFPlUg2G/QCfJmXqz7BgcUsMJ3ufvqT5pEMFkvsaW4o1Iq+QYEG?=
 =?us-ascii?Q?5h8gGNvjSV0K8nmiYuBOQWvogI/56b5oAsbwgK3NQCRVUTzb+6ejiGbMgL92?=
 =?us-ascii?Q?RbA9aQyHr2SblYgqyVzOBMBxzxQ/9vQmynTFmSr5ofEo4npqL3K1oSE/Viyi?=
 =?us-ascii?Q?ovztTZM07RzuyuYs0K3ifkTD2nHm2+bzktcOvVCd187rOaFfz0BHUAQ4hTuX?=
 =?us-ascii?Q?y9D/S7Wd/r6Z3tcvkrxuRaz4p+Iliu3GSkWLdOkZU9lWF1xD1OyEumtBSGK6?=
 =?us-ascii?Q?/JcM/D/KISj0O9nYkxv4rVrctnuUuFMFB4Ogi4eyYE2DA/Y58cYZuMb2olPZ?=
 =?us-ascii?Q?Aphdz6i/kHJKjWkoY3hGiamswGJAlPY4lZjPRU+lzJjPI7w9qbJqYrab39hO?=
 =?us-ascii?Q?jUAu3yKA0opIE+wBdrQ7ygePrvn8DtFAf78aFBHWMq41yKZBQw7G0VobDb5M?=
 =?us-ascii?Q?o+XuTfSh2tVcj5Z0EwJ6ArtEaNpcWahS64Xiw4DHaMKrrfwNVaUt1SeOdE5B?=
 =?us-ascii?Q?oG3eTTDH1m+MkGKAnxkdjYegWDTSYt8ehAd8qyi6pyES7g=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2957.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?7Sbj8s3Z6bYYUTcZ6O5Kl4g44pzyfhkl2X3NKSiA5YSxL/DOdcJfQDB/7CjE?=
 =?us-ascii?Q?ciR+fOWJ4hNHhkH4W6LtG8DaAkYGzx5pyWoYg1cQ9PCoydnOLypH8W+yjqlM?=
 =?us-ascii?Q?iJVMf1X9WK9DKQzJbS/qIH56SgO45Jllw8MTAM8JH+LJlcNFtQa1aZHT0IID?=
 =?us-ascii?Q?zMwbxsRUBkgG/iCapLRKlVc0+j7HqWU0nV8ZkesVKX7nkAYkzgNPpov0Oi3y?=
 =?us-ascii?Q?g19fjtToviogRFfCajixs1R3SbPq8XPm1cXTCG23352HuXGM0ZjNT9rlCDKk?=
 =?us-ascii?Q?uowlL5wA7GbifqXIdbkJumhRUtQVRcnS9EaNyq+OmSVaA0UmIMgN8K4Iymk6?=
 =?us-ascii?Q?hIRYjEjmIFj8mEOPwBnSa8kw4FqgWND+0OvVBE78tVSqovkqloLlWz5uQeJ5?=
 =?us-ascii?Q?BvI1pP0wB45Sq7MLIbb7p72ZOuqw8db9UyjaeTML4hdF+vY7TaYGDUoQct6D?=
 =?us-ascii?Q?bh3Wk754czjMtqqCnFy1S0httLLPiPizw+OpTwz7Y2si3OuQ6aCK5dJjnW2r?=
 =?us-ascii?Q?kxtGukDUhkjCntX2p/tvup6NPsEAuSEQMrpyJkoG8JqUyqume6FxIKTiRSPA?=
 =?us-ascii?Q?XHUuXYCpPCNHLU4JCLB3N7pG+BMplwu6aD15dmQCHllO/p6Gk5Usbf/17PdO?=
 =?us-ascii?Q?q9zvwfCZonRBJeGFIPCEXtMiEJ1V+aeh46DcOJtWkqAr7q1QcqwB/6NHmvRR?=
 =?us-ascii?Q?dfqj2R7QVPD6NpTv5n0AMdhTdwkyNJAuEqWpDYNVQYn/2fvWfLGYw/0VimDy?=
 =?us-ascii?Q?3lzqeFWDxe5daGVLkNF7Fc8m1tZQvvbTEOinWw7nsE5kLzOaBdP6PKDwtmhf?=
 =?us-ascii?Q?hewazgGe3+TOdJ13/WWF58qSwei6BQiEhwDFVEBGBIC5GAUDFhIy56Aa9mxP?=
 =?us-ascii?Q?P042T375QOBqsKp5EwUaKOvS/ISy2AiFxnesZEFFLIAi6M41CtjRfIWalXFB?=
 =?us-ascii?Q?w6qsINl38cIrSqAVNyJ3kX9pBxmEWOfqtfzoc8n4x84d3BUnsUszL1ozRlrD?=
 =?us-ascii?Q?Fqsl7RRFMATiNMfLzGDXb8D+rCXttde2P24Ot8hzutjOW2GC/uJkJ/qEyjhX?=
 =?us-ascii?Q?dPz/FP0e3ksG9puYdafz1TPpLLywZuIlZ/GgDurnqAgycabe+UMskvT2w3g6?=
 =?us-ascii?Q?q9jj3hosUDsoAypfE/YN/AglC9gEHkDrKL98NV9bzfnglQY/oKbNnimy5KML?=
 =?us-ascii?Q?M6crIkcJrJwe9zdpUYelxxoaMx+lEspPAiQT0bW+D993sOu1LIro+Bhixjur?=
 =?us-ascii?Q?ouFppoVxOsdGNX62nPOF6L80SD1lhOcxwTNVbBKkF7Jj/ovBBinqU/cFM9SB?=
 =?us-ascii?Q?zYXYpW2kQ/T/xIOI4KuMJMBLhobk1v6s1r82tto5JDtotxdnoCBfY4sh1ZSe?=
 =?us-ascii?Q?t3LddcPRCAbJ1ajeVXHat2l96VqAKni2PIC0Jy5dxcDiPuNt30T/Ce4R9+Ml?=
 =?us-ascii?Q?dWjry2ElfCzLKfyWWozkVzMLjJ5xHa+cMOQAAaF5IZouEYoVDmEOrap/n93x?=
 =?us-ascii?Q?tVw/P8H6Kti8M0rao/ExbZNq0aPvubVnlOz0BGCiEuX1YszH+DtGFMcuhXUo?=
 =?us-ascii?Q?CFuznVDJoRqsUnFod5UGP2So43Px890nDl19XwPUVItNFCj7GD4v5A2jFcXc?=
 =?us-ascii?Q?hA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	+K5SDznmXI+UcWMCOCFlc9ttRbAsBiH35EQIb1gotags7GOlQDic5b0qZZonqb6DGWuwwY7KyIKrD7aN0Cg8nPJx7WgS6qItTGRgV+o4j/icGvQxGkx4txpd2S43leJzvWmciMikv80CKYgKm4dgM9DeG7SGEJjS1xX1jf/Uugn38MQQQMhyrKQFg6SOaSKel45AvWzf6B43K/QjokYjWrQITMgyc88VxBxv9QXuyVf6dNnmei856sg0fmimQQsOQV9QbJbRIqoeaNpe+7eKhQF2H2yoUkIy689acnPrtRZ6qfn4qHee80bb7Xm3uhB35/S0WSsUZ/989LVBnu5icrEDq4YRg9yvSq4lwNUQXuKZ6HCnB8Ouq9RwZGwixiHaUaGtjnc4Ue99h9shFMYjwCq4CdXEvkWYsac0Ub3UhgOxco3zilnMYBxFO3JLzGV6qejPaI+yvjrQ9v6/o1puSFleJuG+kUiovx+eEG8TgCf9RXx3zfg0d1B/2yMDD9zQ+2GHwen/98q9yklKy2sYlSpwSc4NH7r/j971526C8GKcwzf8RVuO7kxaih7nuzNDNHkXHeN9ZTqJcpY8UhWjO8A604nzWK6pIV300B3CweA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce20714b-b3cc-4e77-be20-08dd0f51c1c3
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2957.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Nov 2024 02:09:57.5257
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QYyUVN/SznoXW/bSgbFfW6fS3p72M9t7itV6ny+KF87tqZrVrJFHM3dYOi57prgFYW6bvimEGg/9e+HwJ7eUTBVxqE+j+4xOny7GGxgGQ4w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4696
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2024-11-28_01,2024-11-27_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 adultscore=0
 mlxlogscore=822 suspectscore=0 mlxscore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2411280016
X-Proofpoint-ORIG-GUID: C2vGKsNhocVJOx9Yp6UV-DC-FmnO0zYM
X-Proofpoint-GUID: C2vGKsNhocVJOx9Yp6UV-DC-FmnO0zYM


Bart,

> What if the source LBA range does not require splitting but the
> destination LBA range requires splitting, e.g. because it crosses a
> chunk_sectors boundary? Will the REQ_OP_COPY_IN operation succeed in
> this case and the REQ_OP_COPY_OUT operation fail?

Yes.

I experimented with approaching splitting in an iterative fashion. And
thus, if there was a split halfway through the COPY_IN I/O, we'd issue a
corresponding COPY_OUT up to the split point and hope that the write
subsequently didn't need a split. And then deal with the next segment.

However, given that copy offload offers diminishing returns for small
I/Os, it was not worth the hassle for the devices I used for
development. It was cleaner and faster to just fall back to regular
read/write when a split was required.

> Does this mean that a third operation is needed to cancel
> REQ_OP_COPY_IN operations if the REQ_OP_COPY_OUT operation fails?

No. The device times out the token.

> Additionally, how to handle bugs in REQ_OP_COPY_* submitters where a
> large number of REQ_OP_COPY_IN operations is submitted without
> corresponding REQ_OP_COPY_OUT operation? Is perhaps a mechanism
> required to discard unmatched REQ_OP_COPY_IN operations after a
> certain time?

See above.

For your EXTENDED COPY use case there is no token and thus the COPY_IN
completes immediately.

And for the token case, if you populate a million tokens and don't use
them before they time out, it sounds like your submitting code is badly
broken. But it doesn't matter because there are no I/Os in flight and
thus nothing to discard.

> Hmm ... we may each have a different opinion about whether or not the
> COPY_IN/COPY_OUT semantics are a requirement for token-based copy
> offloading.

Maybe. But you'll have a hard time convincing me to add any kind of
state machine or bio matching magic to the SCSI stack when the simplest
solution is to treat copying like a read followed by a write. There is
no concurrency, no kernel state, no dependency between two commands, nor
two scsi_disk/scsi_device object lifetimes to manage.

> Additionally, I'm not convinced that implementing COPY_IN/COPY_OUT for
> ODX devices is that simple. The COPY_IN and COPY_OUT operations have
> to be translated into three SCSI commands, isn't it? I'm referring to
> the POPULATE TOKEN, RECEIVE ROD TOKEN INFORMATION and WRITE USING
> TOKEN commands. What is your opinion about how to translate the two
> block layer operations into these three SCSI commands?

COPY_IN is translated to a NOP for devices implementing EXTENDED COPY
and a POPULATE TOKEN for devices using tokens.

COPY_OUT is translated to an EXTENDED COPY (or NVMe Copy) for devices
using a single command approach and WRITE USING TOKEN for devices using
tokens.

There is no need for RECEIVE ROD TOKEN INFORMATION.

I am not aware of UFS devices using the token-based approach. And for
EXTENDED COPY there is only a single command sent to the device. If you
want to do power management while that command is being processed,
please deal with that in UFS. The block layer doesn't deal with the
async variants of any of the other SCSI commands either...

-- 
Martin K. Petersen	Oracle Linux Engineering

