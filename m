Return-Path: <io-uring+bounces-5168-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 492C09E1120
	for <lists+io-uring@lfdr.de>; Tue,  3 Dec 2024 03:13:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0E49D164883
	for <lists+io-uring@lfdr.de>; Tue,  3 Dec 2024 02:13:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F1967DA67;
	Tue,  3 Dec 2024 02:13:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AVYSoxZR";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="HQepNAQK"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 604AB17555;
	Tue,  3 Dec 2024 02:13:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733192017; cv=fail; b=W3xkiSYB+rWsE/DaGT2wwitxQeHJb1xNKcIVAnCeVg3XOwf0smtJGSfgSmrVG96S0Phs91zBon4v5qVuJ8r0EvNIcIghqv8dF0fUb3gADZ283TfrseG8GvtCMk7vjSpegpLl9Wtai9zh5QXPrK0BnXziGC3A2SfhUQmagA5GEsE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733192017; c=relaxed/simple;
	bh=jDGjLot+qRPK06B1y+fpkomJw5gjZ0aKGwonGyvJeQw=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=kBCoS8CPn+IqPeccp+1tR3aANrsDo9MJiZmgo1xslOp6BFifbC7dMnYPgA35wHm0zaxxCpKSrYoJzWJHibkLTFEsjpNjsaQb+I+DMpAxNH3AfSksj312QJd93b4AzZfMDRL0My07F/jkzl49FLza/H7izqTkq48JbR4CiF5cDoA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=AVYSoxZR; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=HQepNAQK; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4B2MtbIW028545;
	Tue, 3 Dec 2024 02:13:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=gCAWLvvQppmXku66Hz
	VFhu1/HwL3K6iIsAuNiopaV20=; b=AVYSoxZRciVtEG2jv6zMKOvTszvL889QuU
	4bbaEFUB2OLavsc5QMDV65HunGfuytI/dhF8/zQxhNyUYXSCjLHe+4PmXdX3Fbjv
	yfgEbucZ18epRtnUYzqGPTkA/5sPJpqlQOwxAJoiE4qBehYusbz2/Y47dQfgdI7m
	wF39J0fJGVxvpL/oZsS/kiAS4R2tYZF1pib8jQareReCTyJ6vfuEAn4SklKum3r9
	Gfm+9vsC4OyPn5Yi2cznS/9MrbkW7j22orPokdDVVASyZpyadEqMadqNJFvUXVDp
	h4Zfv5vrcy7/hQYvJLIzV2MT5WmGfNET9EdjVZGz1wVoUUK1Y0Cg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 437sg25450-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 03 Dec 2024 02:13:19 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4B30f3Pm000836;
	Tue, 3 Dec 2024 02:13:18 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2046.outbound.protection.outlook.com [104.47.70.46])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 437s57a9qt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 03 Dec 2024 02:13:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EIG2HM2YkdXqFlBrpOs2+Zi4kKUbdPiS7y/5eCspqk2OMOxkaO+wvW01+qifrQ+tunzVBJfeBE8Qy8Lmee3fojITk23fDrS5onpbSddu0lbHHN8KZ8Urxwf5rIDOrmxhRXsrI+1/pBwMWhib+Lqdlln6/IOBo2vEtiP3UmXHPWDnbsPJvM3od0+sQzCAyQ1PeUxAdUuygAAoqgH2t70RN1OY8li1ua+vm6c4iBd8HuvU3ag+/eRAEnGtM/xp//P0+kr03t0/KcBjAw49kAjxIntB/L6X7AKKhE8wKH4/mM/hz6Muq2igi1a9NluDOYmoNwIn87h8T1bkv+zq00lh7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gCAWLvvQppmXku66HzVFhu1/HwL3K6iIsAuNiopaV20=;
 b=TNQ4co0GDP3u8kQK/eJkwMhS4hpH4sDIBqY0q8ty6PCrhQok3roPFAESlLMIYSlrzdjYpB0YZPnQl9EB8Da8jeQSObF1tKL+ZTtol0klcLQp6eTlywKqkrwYna2PXC4cEtEtKzEB/PlDnBdpt1+FgWlOMSEme7IUcMY8nUIFUMT88px4mzHQD4M5dGg81CGt60E6mRBgWfPIMD8F03SJoAgLAhaXsPxVkoY4QFVQLPTfnwD1iGzpOBAY45PQRGeiwYs0FPygXBxMEUPrSK649FRlSn21U496XtSMlMlaUyFmUpespTiundoDXoYpSoBYes2Xa5xnrkC4eAOWeipjQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gCAWLvvQppmXku66HzVFhu1/HwL3K6iIsAuNiopaV20=;
 b=HQepNAQKybCwhh5RtRuz+gyZPL33TE+IzvZPV1QceQMCkk7XZQp0zLmP96i7ZyoLq12YsqUjzpiSORTEFZ6lYgiNG2XgxTzegHg1e5s0QwMhRN+I52FwVzO8F5SghJH0H3rTD3Rt8Bf5ZD52mwHvzklrk0FxynkxgwhqiFWbljw=
Received: from SN6PR10MB2957.namprd10.prod.outlook.com (2603:10b6:805:cb::19)
 by SA1PR10MB7593.namprd10.prod.outlook.com (2603:10b6:806:385::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.18; Tue, 3 Dec
 2024 02:13:16 +0000
Received: from SN6PR10MB2957.namprd10.prod.outlook.com
 ([fe80::72ff:b8f4:e34b:18c]) by SN6PR10MB2957.namprd10.prod.outlook.com
 ([fe80::72ff:b8f4:e34b:18c%4]) with mapi id 15.20.8182.018; Tue, 3 Dec 2024
 02:13:16 +0000
To: Anuj Gupta <anuj20.g@samsung.com>
Cc: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org, martin.petersen@oracle.com,
        asml.silence@gmail.com, anuj1072538@gmail.com, brauner@kernel.org,
        jack@suse.cz, viro@zeniv.linux.org.uk, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
        gost.dev@samsung.com, linux-scsi@vger.kernel.org, vishak.g@samsung.com,
        linux-fsdevel@vger.kernel.org, Kanchan Joshi <joshi.k@samsung.com>
Subject: Re: [PATCH v11 06/10] io_uring: introduce attributes for read/write
 and PI support
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20241128112240.8867-7-anuj20.g@samsung.com> (Anuj Gupta's
	message of "Thu, 28 Nov 2024 16:52:36 +0530")
Organization: Oracle Corporation
Message-ID: <yq1r06psey3.fsf@ca-mkp.ca.oracle.com>
References: <20241128112240.8867-1-anuj20.g@samsung.com>
	<CGME20241128113109epcas5p46022c85174da65853c85a8848b32f164@epcas5p4.samsung.com>
	<20241128112240.8867-7-anuj20.g@samsung.com>
Date: Mon, 02 Dec 2024 21:13:14 -0500
Content-Type: text/plain
X-ClientProxiedBy: MN2PR15CA0019.namprd15.prod.outlook.com
 (2603:10b6:208:1b4::32) To SN6PR10MB2957.namprd10.prod.outlook.com
 (2603:10b6:805:cb::19)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR10MB2957:EE_|SA1PR10MB7593:EE_
X-MS-Office365-Filtering-Correlation-Id: fe96473b-6cb8-4489-28b2-08dd13400c43
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?2rYycSbXI0htiY2viRsw8IHcd+EaUkf8rzIqFWareuJ2NGMAiCRYZ8MWpHX6?=
 =?us-ascii?Q?1aHsMxSTlmRdYFHEnPBzoE+mDEujMAwFqzR9ObpN/9QdQ7AgC+KuX/YEmIfY?=
 =?us-ascii?Q?+BjpykxnCfxY6KjVr2aSjxb2YrsvWFwKG0JRk3ubnfcu9dxSl2lZLgfVHSaY?=
 =?us-ascii?Q?M35mFGu69Qk7a0/ntRH/8tJwYipo7M9WnvRy1bB3iFXfaC5qSyqBYWgluJDT?=
 =?us-ascii?Q?sF4Ko5pTIlK/TEZHuWu1TMdRh9zQnoU7xytciLnO4bUWkq4v2q3fJSR4yq9M?=
 =?us-ascii?Q?NZRy0eyRkYhPEa9SkCZ/C0FoQtT7ZN6XGI4sKn5VZLv/XvasZ+vgeMoaF3Wf?=
 =?us-ascii?Q?176aEoW+Mmh/yTr1AuC3ewtP6kGsQdnAF2JyoDPc3r23gTOgdqe2cLKlASAV?=
 =?us-ascii?Q?bFnjtDThLuq3h5CSwPCRMSJAZHY4MlrFdI9iBXlydqQm66knnOG04hWqsK07?=
 =?us-ascii?Q?5xE78YdDMklKwKf/wLxtolGbR+yRVpLnJHx7qw/mPg8GUowFotMaGY/MCyYE?=
 =?us-ascii?Q?f+ln4/kER7VTdSupClI9aTmN9XMiiKb/oR5JPjKsVJZLTwd0NekvOU5NxOMT?=
 =?us-ascii?Q?mhkqGyCbvIvEts84vqNevApLSjHv8eTKK5s1RGK88TRfPoIvwucC9kzsCbJ+?=
 =?us-ascii?Q?hz2ea7baJmssvNI93YxH4dRtxayBbcae8rA1gPWrEZGGW6KQpCPhKw99+m5I?=
 =?us-ascii?Q?mQxma411OQhOZrkr2cYMd7l3c2thMsSpHrwpumKbJ2pXzuO99cqpT7Q76Wu2?=
 =?us-ascii?Q?BHyzOEGBFf4B85WOVbXRlth/i9ongyO3OIKi7GcW5ZUJ2xPdAuQ061DR9mvB?=
 =?us-ascii?Q?jgti+zwjOb/EdZUuN1o3YaXiiZxoX/uJB3jL+L3V8UjV86fkmuVmGPiqGUp/?=
 =?us-ascii?Q?lpTqtTe4sTqy7fQVFxxUHuSy7Ck+yIS+T2ER4h2E4Sku2ZUkAYFxxQfe8dhI?=
 =?us-ascii?Q?b7VNGeasfUx3XHPVM8ekFUw3i90bLFh2uzkbAaz/1rESzH9fQcCF4VOmf7mn?=
 =?us-ascii?Q?rfW4rQX8P9uPoSB+fGt0soSlhcpQzrezwMNCL3sZ6P754mk0bre4OOF2mE63?=
 =?us-ascii?Q?He+9IQScDfkY31Ik6Em/6HyFxucG2tnvFtNgR4qByGuM1BC+iTjzaBpaCdQ7?=
 =?us-ascii?Q?wrWVwCJCD9M9fFnL6j9FqyNdLZIN66EjRbt2tSi8OXIz/NIPDukoeldGz1ou?=
 =?us-ascii?Q?xgvsr1IiCEyYbbqqcS205HcH/L/FO+w7n/2Adg07VoiUfPYafM/eXHfqc+Pu?=
 =?us-ascii?Q?GxunMLvxPQKi1h9gpPoLchRN0qURsNi+/NTEeptZfKXqYprBx/bg5ZYDArfa?=
 =?us-ascii?Q?UAUdlrvlJAX3F3+IlUC1XETfScWo12FfX2L/KLcC6cmGjA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2957.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?IbcfjOVZPvd3+o9O/xJB1smmKzqb1KS/aSgq47ZTvjRaOKwLCqtmaLi9mE/y?=
 =?us-ascii?Q?morYXtRrojfhmXLONXi4onriEmWYGd+0n4G8Sh7I5TMbDuhGlN+01cr8CN0M?=
 =?us-ascii?Q?TyUP1bYHck8sItMbYU5Q+IngWseJy0naSNClL2vhJLaqBKwP5iaduv7Z1Ybn?=
 =?us-ascii?Q?GbQjByKzc90y2Uqocn/0oy5deNP3Vg7AJWpJkmJPl04y71g4yqkrnxce7n83?=
 =?us-ascii?Q?luHgLTWyL7ngaRWKHloWP7mS51M33H60lYr+oO0o3cMkgf+n1NvpcHq4B+ik?=
 =?us-ascii?Q?GFKO21CF1JPHwG7pNTbtSKy046m/4MPq6gOhO/0y809nwnqWknFWFzaspkwc?=
 =?us-ascii?Q?ohljnbKH8XCa3DNYaCiQWdA2HCSjz7jGU0kkDOE0Pm4TdORF4EgMKFetGO6N?=
 =?us-ascii?Q?HTU+TfZ9P+zQBR1NIYFULtklWnCMN9WVPgco/I5cAy6xvEoe7CK3r+aKck6I?=
 =?us-ascii?Q?RH6jUpAmoWXQH60hIbNVi2feiu/gww7kw9JPGMMWTaO07AeWxyiI9MmarsLO?=
 =?us-ascii?Q?geI1UXOHRilb2zBrJZtLqPPxWDUoLK9Ta7Fb+hr1yLavp/StoaY3aXwbYOb6?=
 =?us-ascii?Q?NWG9ImOA4c+yfHzeT04UTMAFu8uGsK0X2uSbJYoczKlaEJ/eDQF85oITLqQ5?=
 =?us-ascii?Q?GsEO0I43WrIgUshYsFRBfMMqL7G72p9RZGwLXwDkflWtGf57/0cC7/6GvrQT?=
 =?us-ascii?Q?JQsHoDt2DOJ49J9KuaBABfxKZH04JmvjINepc1qeYfKBLgfkfVyoCJnMgjX1?=
 =?us-ascii?Q?QONGyfc7wJv+1zeu1YClylDU82hS24BnlNGuIFa7eoyPqMQcDRd/N6J62qiy?=
 =?us-ascii?Q?JHPWt+8vw5OJNbzpvU1ZTQ0clcDjKvyIJoMGiIoPYdyP2EBPODfKEle1u483?=
 =?us-ascii?Q?+NgpODl4lIOt9XXU+UsQVVxmGIWz903Gzs4KeDr9xl84BfZiycnNik36Kgub?=
 =?us-ascii?Q?ZQKbmSUCeULVy+H49S1gUXXdjlOb62UeQQvbItVs4QonxvwsHV8g7gz23abA?=
 =?us-ascii?Q?YjM1m6wZ0ETyUtD29htzBELlrzRPlFVA4UxWlkpIQ5lDLee89uueYNPGuTap?=
 =?us-ascii?Q?XWeoE99w4QXDhfvv9BdGgpli8E0z/5Ziz7ZQPk/EJLBhR8MAGX5VzstfXtlr?=
 =?us-ascii?Q?38MqoTCv/todgbaiPrcrVM+oOTmv8DE7O2ROjTif8F4JNr+vYZiwkpMIZl8B?=
 =?us-ascii?Q?pwXCN4HMtILzgchsV6g1OdcRdtv5yU7xb18yZzLWF8LMGgMd8fxBHxIZybPh?=
 =?us-ascii?Q?dwrmmKkb8kPttERCw+rM+V4vmLDKhH7fL/5xDK0o1BcC7VgHVhebiTWzXj01?=
 =?us-ascii?Q?AWXh1SFpTIYywxm4SHHiCYR9dWsgjVmyiYROAes4s/t9fw+OYR/ks9hUyUQ6?=
 =?us-ascii?Q?NeeRip9FnrgHrbgK+uGXZC3Zuu5DwtTq9fKNn6A6MSQ/rsI8nu4Z1dqgisr1?=
 =?us-ascii?Q?UFsLalLo2G2qfNie+XChzQGYKQTKM0YJQcV67N7FTI3sz4j5AUH2Ej+CyIbN?=
 =?us-ascii?Q?3otpNc557rnC7eTS/KyM31EgyBBTcSVd0HzCQBRKYw3TUi7Gh4xTjsUcHrEY?=
 =?us-ascii?Q?R0H8gdZm9OMPeRGvvK0EUMSQg2DGNvz7EFkvbPNXjAjQX5mHIkw77/+HLEX7?=
 =?us-ascii?Q?HQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	hToOVxp2/ZhJNkWQQI7b8dRKdZwDw4+cW0y2b1dF9xycDfaCWtiDqXaclTgOrvouCIi6gvtpdf0pA0OXX/cXJ8uMynXd24WdBxAfJF2klnysEMtEYDnqiDBfSS+9Axi/p5dpmkv8vYvLhTLZX5gPJKSYt2GOLVRlHALkPot1FURIF/WPjlbIjom2gT+ZeuvZQBnEvF4G4WzcIDAUG7nuChwecuBhPLoLKX1o/6Dc3dF74xr2NgNmPeA7rswHAAEPJcxpLM5q+knlvhQhKA3DCxHk00wkwNdhWvDx4UrXa74yFPE2bUmPipbsHB/E8xOjvcpIRkrbOLn0bI5fZp1s4RNJOTWyirs0xX36tzK8dcOOdINx7gRcibOnXce/ZI16HrrTsry4rXU4FjZRu8WQbTcTJou3T2Y5ITx6SMFLmFxGPoZtZ/BQM4vHUP0SPtcyLGmX6t9WviL1VwOddw4iLKTgegx8gs8sCi+DG2tq7iAXBLO7W+TBRNr4lL1oHz6UFFHiG/xa5QtbGh8vjYeUqJZZSD3Vqp9MEIblRAlqczlLtXjZBSRg6YKjndOutC+U102d0Y2Jz5z3WgO/SMvsa2T6o6qQIMp2V9nYanZYbOk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe96473b-6cb8-4489-28b2-08dd13400c43
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2957.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2024 02:13:16.3199
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5HpMUHD4GXqnKz054pE3XRASsyZ80Uv/W3cWbipDksShsO18zbLIxmcxfKKesShUHvxYGEVMHN6LSheBC5erI9o+V0AKPWWkkAQZ2F78OK0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB7593
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2024-12-02_14,2024-12-02_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 adultscore=0 mlxscore=0 spamscore=0 suspectscore=0 malwarescore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2411120000 definitions=main-2412030017
X-Proofpoint-ORIG-GUID: gfFO5Ow3fn5peyRi8LqCitFRkbK9Qq_n
X-Proofpoint-GUID: gfFO5Ow3fn5peyRi8LqCitFRkbK9Qq_n


Anuj,

> Add the ability to pass additional attributes along with read/write.
> Application can prepare attibute specific information and pass its
> address using the SQE field:
> 	__u64	attr_ptr;
>
> Along with setting a mask indicating attributes being passed:
> 	__u64	attr_type_mask;
>
> Overall 64 attributes are allowed and currently one attribute
> 'IORING_RW_ATTR_FLAG_PI' is supported.

I have things running on my end on top of Jens' tree (without error
injection, that's to come).

One question, though: How am I to determine that the kernel supports
attr_ptr and IORING_RW_ATTR_FLAG_PI? Now that we no longer have separate
IORING_OP_{READ,WRITE}_META commands I can't use IO_URING_OP_SUPPORTED
to find out whether the running kernel supports PI passthrough.

-- 
Martin K. Petersen	Oracle Linux Engineering

