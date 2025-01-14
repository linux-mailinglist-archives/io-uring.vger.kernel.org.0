Return-Path: <io-uring+bounces-5862-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 417ACA11071
	for <lists+io-uring@lfdr.de>; Tue, 14 Jan 2025 19:47:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 51DE616414F
	for <lists+io-uring@lfdr.de>; Tue, 14 Jan 2025 18:47:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F19D1CAA9B;
	Tue, 14 Jan 2025 18:47:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="m1FeVerO";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Hwu5/GDX"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35C5618952C;
	Tue, 14 Jan 2025 18:47:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736880466; cv=fail; b=W0OFsXbheIPoni0GXsI5VBayMgogevqgQRcOdgHpql8MXu2BkjGVV5nU5hvSnvSr/I3WAFLAnGY57yBWT1TjOQSzGU7fDbThQYQR16cPugyh+QyJWQZJqKZy1sNRqQOO8kTINCxmVqZLQofcKXqJvx75eBawCxvO0LSdgVvM97A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736880466; c=relaxed/simple;
	bh=TUh+/FHKxBr9CgWH16G7pSb+r4iOThKoe+/Ti83Rv1g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=etvlDUFPctrBXfpBttlWEKKCF5SVFG/qyEtCb5fjf1ioBdSkIyUNtcDPKhEsCPu0x7tN9xYdIMJKttMVezdQ8ve7gC+bA5Sryl+ji5vkQ65CaXBlUu3dB//KQ2EMkrb5CtNtYUnzjMIxlX+tKnP4Huv6faEouMpyJQWL7xvy9dE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=m1FeVerO; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Hwu5/GDX; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50EIY8j3019662;
	Tue, 14 Jan 2025 18:47:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=pzsAXJmXl5Ho/5Cnpp
	iloweqGRxlJ9WAuPyTTIP8WiI=; b=m1FeVerOgKCTAEknxt+5eYi3KY1ZK3o3/H
	4IkIaAptSs14+Wr0iZOKyy+T6WS6XqPwsQpFg2jVa54oUIE0g2EmlIzwQ7ocvO9W
	IAFBL/U4nr+o0cyEJc9fDBVAjEdD42Y+oekujiIoThzeEH1xtxAbG+LwB9G0e9vF
	vNmrRoshvcoeQSoMuSGHa0uvcZFPmOQAMiyf17RzTo26yTrEnG+R3RLBgjUES5U6
	c4FlVh9fEUSpyA7OKfYa45/2viaacgT9797CwJuNjrik953Zf+YrBCeYVK7XLJTv
	PIExhUkN6aX7qr0IsRH20/Gu+iffuMoo7Acd7gbSbVDnpV0tsb1A==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 443f2bxdd0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 Jan 2025 18:47:21 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 50EH8JIK020430;
	Tue, 14 Jan 2025 18:47:20 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2175.outbound.protection.outlook.com [104.47.57.175])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 443f3et8rw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 Jan 2025 18:47:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=r2yM3MiNSDfPft41poroUd/BLy/gWLSapDmUktsi19lGjLAyhKcjfUE7xWbZ2HqmlUbm6fhFz8oF4QScT0314dhDHNNA9353diAib6GlzNsuC6qevp2gMVXjHlPTuNoafiFxIp/u6fto63BdBZpPMoztRdHH0BQh4zKWDeQPlkNg9BxLcohHBKcZWfJh4WQ78PoKSpUFZ3oNqswdGXwMMxhk3zinPIwDwgXzj3YLyuXx+lL5KG1T47wezZzx0QVUEvyLiDamp3iBsSFZLrmrcYdxpEPVOcsQrncupb9PyyUg5tR5Lbz1FrJ0ZqtUy5ylf7xmsNOAuCjY5EEng+09Jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pzsAXJmXl5Ho/5CnppiloweqGRxlJ9WAuPyTTIP8WiI=;
 b=cKz/GL/rYuufm0bmNSlVrtMraiPmviLUFpzKcii59pSTjVHGQ00r+4SfAErQtn0ZjI/IpLqHplwaSWiKIJVgVEedEjwlotpT6lf8caz5aqH9MiHn0t1uevcq2lkMCV6JjqOO7idFxzqHrbrbiEW8WQgvGXAdL3YVI2X3r+LkDjDTm1myqBqnYGqnjOuKA0737kOxscm30ZXme+a61roxOhCN2AfJo/lm4b+mMHkuzygUlQuyA4Qu6LKj6PWlmpsii3/3oh+T3C5vs/rKaJhix2LP6oWhhWsyJhxf1ko7wiZEL8EuC+XOTq1sznw9TRVizqCJ+xx+9084kt1r35UXZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pzsAXJmXl5Ho/5CnppiloweqGRxlJ9WAuPyTTIP8WiI=;
 b=Hwu5/GDXPKTlE8FsvTKlFn5ot3ur+3X5ODyFYCBQNJFICUqIAaueuFlOJvf809ePr2gNyfg2S4j3wEHz4o84ch7fdt0Im+K3VJrycrvhpbvWDaD6BPXZ1kNEUChSYIdh0EQqDvdd0COvrXXl5w03U59rxpP6VMWPiwYXwmPn2wc=
Received: from BYAPR10MB3366.namprd10.prod.outlook.com (2603:10b6:a03:14f::25)
 by CY8PR10MB6778.namprd10.prod.outlook.com (2603:10b6:930:99::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8335.18; Tue, 14 Jan
 2025 18:47:18 +0000
Received: from BYAPR10MB3366.namprd10.prod.outlook.com
 ([fe80::baf2:dff1:d471:1c9]) by BYAPR10MB3366.namprd10.prod.outlook.com
 ([fe80::baf2:dff1:d471:1c9%4]) with mapi id 15.20.8335.017; Tue, 14 Jan 2025
 18:47:18 +0000
Date: Tue, 14 Jan 2025 18:47:15 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: SeongJae Park <sj@kernel.org>, David Hildenbrand <david@redhat.com>,
        Liam.Howlett@oracle.com, Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>,
        damon@lists.linux.dev, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH] mm/madvise: remove redundant mmap_lock operations
 from process_madvise()
Message-ID: <d1a2d831-dec3-4c63-a712-3adff835f549@lucifer.local>
References: <20250111004618.1566-1-sj@kernel.org>
 <awmc5u2j2jmn3xir2tmmxivxpastptevay5kgspgtembiw4et7@5ryv5dnjzdcv>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <awmc5u2j2jmn3xir2tmmxivxpastptevay5kgspgtembiw4et7@5ryv5dnjzdcv>
X-ClientProxiedBy: LO2P265CA0056.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:60::20) To BYAPR10MB3366.namprd10.prod.outlook.com
 (2603:10b6:a03:14f::25)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR10MB3366:EE_|CY8PR10MB6778:EE_
X-MS-Office365-Filtering-Correlation-Id: 33968ea7-1db5-4483-68e3-08dd34cbdf22
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?LeLpk+zIqcemlp3v161Sa3JW3kGMTfwxA//PL1Sh3iOBL3LVRLZBrZ8TXIbX?=
 =?us-ascii?Q?D4gpDW5QASlMi3VPxr1lzX8DYwJP5osIrQ1frqsm9cxGHe940R6+opPbP4u0?=
 =?us-ascii?Q?JgG1n2k8nWdr/dc4WuST9NawE+Ew24jX3sk+tQ/3vDTfcbYiUcMP9zqp4FKF?=
 =?us-ascii?Q?bzh8QqbzYyE8bKBu291lnCBYo/4QukSKw+u9c4DQx6Jk+kUJccaNHBdn/jF+?=
 =?us-ascii?Q?m3mMQZuoFvuX0i5g0aoDLCp4wCQLw2B6YFNbB7sUhTuBtWdGrt/EzCi65TxG?=
 =?us-ascii?Q?iQ9sqGLl+7V52UrlkaHjk4eZQtEv2BF2tMTriw3tJCcFbEKJY3xhs08Qgehp?=
 =?us-ascii?Q?Lc4iRbv/tFlJogk1z1K/tagTdzG3PIOJ9Ob1StP5Bj7sypeEZE6a79CvgA8v?=
 =?us-ascii?Q?NSLc1EUIvokatoEo/GN9iQr6h3Jk0DH+WCoFUvWukAf+a59GlSmV2ILZBVxz?=
 =?us-ascii?Q?gbS9fjQ0DEfWvjbEvG1bcraL+YfHYDC3qFJPV/xkDsRNjAlT7QYcuPVbtnC7?=
 =?us-ascii?Q?ZS9lPyPyDW7yMcmPo6AWTL4WaFXthJwir+zgHcs2zJ3Y8eeKxPaTbBkaoFRP?=
 =?us-ascii?Q?RmtKe6ISQzo19Zzn3U5y7ctk0cN68mEv7tz+vA0pWDbHu7tv+JoGmrpBglqd?=
 =?us-ascii?Q?wlA7w6EYvhnfq9oCNjbJV9NJSexlu8aFMSzLjiBptcR+m0Hzn6usGQ7/o9oU?=
 =?us-ascii?Q?jYPkauZJlnX3itSvPhqLGrzbYKIH1ywijOxMHRWtPYF84vBnP7yCSksI15ms?=
 =?us-ascii?Q?dpsboVjpf1e1m/YfqEIAuRak7qkn92JG+y0w4lQByhVsty9NK4SpZH+MAzC4?=
 =?us-ascii?Q?d+4qCn7Qfz2V+SstNEvnhwjJgNlsfnPcXazJ1BoYpltzKOaE8HDHIo6V9GN/?=
 =?us-ascii?Q?YBmpDbHH50iSX2BoM28ew5cMtjmGL0vT4Ng8TiiqxGi0bBE5kqlot6Xr37X7?=
 =?us-ascii?Q?jECQQbu02YuQTg6mVrOqCSBzvBvDaZ2GW8Tta/yyZq4VRVrVZUnehJchah13?=
 =?us-ascii?Q?nEXCTbX9eueAXPgMiK7IRfxN10N0nepkkvOirJK1MAE/7h437azsvrz49CqX?=
 =?us-ascii?Q?24T8I9x89wgXKy0ehPBeroQEZN7koR51XbAnfNUf9j0zYkaFT4zMs5GC/NAC?=
 =?us-ascii?Q?ZqiKVq12WcghuylY2d0ZqM4LQV5azAprzFJngmm+ySdLZQmn0QJ74Jwya4GG?=
 =?us-ascii?Q?oqdxWlXtKUFjoQXU30JNprcJRKIuwKV5Vb86OuOmswultYB7Ji0JRDRMjUT3?=
 =?us-ascii?Q?AlE1u+/qiLKdn6s7ibwOsslvgUrZF094x2wOu6BTmWNrkWAR7C59q8W/M0So?=
 =?us-ascii?Q?W5X7EqE2/kPI6Y51S89i/McQSGXHG0PQBo6R3esfqKairg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3366.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?LmLy7B58HuTzEWjQGelGp7UqypP5jgtwhVtxa7838xAY1ARpzvFkshUojyrM?=
 =?us-ascii?Q?/jKzCOc7Ozx8fOLFQ1NPftC6pLak1rxBD6lDYgi9rb7L9DBMWANQsWaoa3Hd?=
 =?us-ascii?Q?on0/BeQWlAO57n1QdQYCv8szUznzffH4BaX70Fqu4Vt1GhlhemV2fnZnHj3Q?=
 =?us-ascii?Q?D+u+xdz6zNLsrLqweHnTuqnNWyxsTQiSO/jIquq/BglUZc8/KRm7EPcRrMsX?=
 =?us-ascii?Q?1UIYuBKx263HxkAnehp8S8UcWo9s2QZpFmGf+Xckw+mckwTh4SUbBOXgoZ9e?=
 =?us-ascii?Q?1SE826pLFmz25/4s7ON58hf+nQ4LRdy+FRoQ07oa89lmzarO3JrTG/U+R7ft?=
 =?us-ascii?Q?VjHmKQ2JVs/0rc0K0PEQVLJk4Gna/EiORMVToinAuP20nwhpYinD9qTBJMYl?=
 =?us-ascii?Q?7/G75nnzRKVI7mQIdUh0McuD2FqSIEhvOKBv3rP1JYxH/PJYRTvvjbxDxhPi?=
 =?us-ascii?Q?IGDKx0DmQG5s7gMYpBtc0emoYMAiS3pMT2svmb31zepFsGbG3xINhuYwlL2A?=
 =?us-ascii?Q?rhYxmZ+ehPgcOeLniS/OE5ulswhuxQoQzhibDIllfhm8QZh6H5eYPA3qnu9P?=
 =?us-ascii?Q?N6vPEs+gdKVpheAHmx7h/ACqZfKt5mFMAfYnhDebWNf38r/SSheJ7HHlaUGb?=
 =?us-ascii?Q?ryUf5lw3xQKEOlieHFHr5GYC8WKaZB87nJp+fYAifZGcHt+nkMpy1rmDgA9X?=
 =?us-ascii?Q?STA3yLW/ym/Zdbbq8BYQ7n0shslOLIeAZcrvrEgRKmyhRFADmB00UVAmVBd+?=
 =?us-ascii?Q?XjjzOJ5P41t95UDAYff2F2G1dcx5BT1cTMhc3lx57dmO6aycA8uap05PK0Hn?=
 =?us-ascii?Q?fdI5ieFvg/nVjDY0cNXIsHoRmbyVAjwhyzJwqlLYILMkp4QbjlNorNxvFkoU?=
 =?us-ascii?Q?TEt8p71JF//GWcHPa0hDe2OMgEU1uJOpmCX2tjUMXo9ugw75GV0hCa/mVX49?=
 =?us-ascii?Q?tn5gb2ox5Vuru5quokjDVic4gUr/gQ+fIi0QaFoXJ5Ct0iyc6wB55akvld04?=
 =?us-ascii?Q?jpKVfLT0xLrCvUG9RygQD6/eEJV8LiKHb1r3X1R2GjvyYEmpGkdbFn/CcR5P?=
 =?us-ascii?Q?kLZhDx0hieCoZ93/npUYakJlgDEXA82onK1djKn7GOZLHy7KTMg3ekRpLpeu?=
 =?us-ascii?Q?ejyt1z+m4PFMdTMlII3vUHgI5YjCKZAEdX3KOw6jsT+/3OfbjvlaUMBdiRdP?=
 =?us-ascii?Q?4qO4J0SiXVVXQZgMsdQxqxjjYHdzRVCdPAwJOY8iRejjNt5YdCLmRb2SheGR?=
 =?us-ascii?Q?q7+JQIQD0S5/o93z5sMU2xVtcoCf2nXdUWxsKcyxPqbsoz2m2lh5ZbUUSjzH?=
 =?us-ascii?Q?qlaWqLLmbBJDjeFGrL/NgBuUe/lzWNHDmqxMJTTiefg4wtTsUkIDwB2XCOUO?=
 =?us-ascii?Q?Ppy7jDSyDcq+6bH0ShydR3Z1bjNKPzdmkcD5NuEyvyzPu85KUsBm/HKQ/occ?=
 =?us-ascii?Q?ZX7lLhQBxuLZ79E+2/G5snwn2paSkMdgmjVF7/bWUQEz1n2E7sl69o7eRBjy?=
 =?us-ascii?Q?JlKgFiy8aKgfWvBah9x06dJwOLiMACZC2A5/Bx3O3vRkT/Rj+9aB1YYrWd6S?=
 =?us-ascii?Q?HRLORsgMWhs5v0zByRGa/fqESu/4cAM6tj2QMybC+g2mcs7OxreIDSdf3pkk?=
 =?us-ascii?Q?PQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	r9QVQTu8cJd/5/IXnWbATW0eN4kX1Cl2Umm4C6PXBaKgERj5IpEB/F04iUwrLn6Z+KGi8L/a6ELjYYhDNDwk8KVn1dgU+ezgkeTwi+ItBWUX/IHnrlPlbtoL1MOsHpJu4Qp2TpiQSAzppT3ks6XL/zhlZB+PvexVkEkaKR/Mdr0qsFCAwhOURij+E7/OETKAy32WEUQl1+cZDeGU2hUJ757IK4Xx7KCJHrU0P8oaQgtZphS8e0LZ/Nj/Ek6nv+sR34S1VHXbl3UbjvydnEPjtXDCAjik7pQP38AcGojzwoLmRwC0mTxi/pgd0jDYl5Szofa1AXbJNsdoXwIPd6TtFem64zcpgAyo1P5fYqUHyHug1BFJblOMH5wuHMEfOFECjIKH/68fYLsYsw4WfpIINrdq0JKYNVihpiec6AKzstx8O7yCFnUwey1bCVuckNcvQbQuJW/UvlPthnKxoqGPEnQlKVkZr4DNk2pnVuseSkhifRx99CrsalY4mJwtBXUFRZL71O/NFjupehBhpyAwHvIP632wLhqS48H3NOujBoT65ewWYliQgUv+DyscLToAqODgaEjj4NTps0/dFGzmScIQhWlLu7M0EJYD+YScMPk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33968ea7-1db5-4483-68e3-08dd34cbdf22
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3366.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jan 2025 18:47:18.4307
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P3ne+K3zETTCBDpkZB+cLOjp/TvmmB/HjAeSyEWQwuXoq/+LvBxMB4oC4gwXiJscZhTIoKZLCqmAq8UW2jCkX+YpJGPalCiIVFlceOuWghE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6778
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-14_06,2025-01-13_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 spamscore=0
 suspectscore=0 phishscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501140143
X-Proofpoint-ORIG-GUID: q2Y5hYE-CKjh3nZHTOMUvzWgjXZhBCOv
X-Proofpoint-GUID: q2Y5hYE-CKjh3nZHTOMUvzWgjXZhBCOv

On Tue, Jan 14, 2025 at 10:13:40AM -0800, Shakeel Butt wrote:
> Ccing relevant folks.

Thanks Shakeel!

A side-note, I really wish there was a better way to get cc'd, since I
fundamentally changed process_madvise() recently and was the main person
changing this code lately, but on the other hand -
scripts/get_maintainers.pl gets really really noisy if you try to use this
kind of stat - so I in no way blame SJ for missing me.

Thankfully Shakeel kindly stepped in to make me aware :)

SJ - I will come back to you later, as it's late here and my brain is fried
- but I was already thinking of doing something _like_ this, as I noticed
for the purposes of self-process_madvise() operations (which I unrestricted
for guard page purposes) - we are hammering locks in a way that we know we
don't necessarily need to do.

So this is serendipitous for me! :) But I need to dig into your actual
implementation to give feedback here.

Will come back to this in due course :)

>
> On Fri, Jan 10, 2025 at 04:46:18PM -0800, SeongJae Park wrote:
> > process_madvise() calls do_madvise() for each address range.  Then, each
> > do_madvise() invocation holds and releases same mmap_lock.  Optimize the
> > redundant lock operations by doing the locking in process_madvise(), and
> > inform do_madvise() that the lock is already held and therefore can be
> > skipped.
> >
> > Evaluation
> > ==========
> >
> > I measured the time to apply MADV_DONTNEED advice to 256 MiB memory
> > using multiple madvise() calls, 4 KiB per each call.  I also do the same
> > with process_madvise(), but with varying iovec size from 1 to 1024.
> > The source code for the measurement is available at GitHub[1].
> >
> > The measurement results are as below.  'sz_batches' column shows the
> > iovec size of process_madvise() calls.  '0' is for madvise() calls case.
> > 'before' and 'after' columns are the measured time to apply
> > MADV_DONTNEED to the 256 MiB memory buffer in nanoseconds, on kernels
> > that built without and with this patch, respectively.  So lower value
> > means better efficiency.  'after/before' column is the ratio of 'after'
> > to 'before'.
> >
> >     sz_batches  before     after      after/before
> >     0           124062365  96670188   0.779206393494111
> >     1           136341258  113915688  0.835518827323714
> >     2           105314942  78898211   0.749164453796119
> >     4           82012858   59778998   0.728897875989153
> >     8           82562651   51003069   0.617749895167489
> >     16          71474930   47575960   0.665631431888076
> >     32          71391211   42902076   0.600943385033768
> >     64          68225932   41337835   0.605896230190011
> >     128         71053578   42467240   0.597679120395598
> >     256         85094126   41630463   0.489228398679364
> >     512         68531628   44049763   0.6427654542221
> >     1024        79338892   43370866   0.546653285755491
> >
> > The measurement shows this patch reduces the process_madvise() latency,
> > proportional to the batching size, from about 25% with the batch size 2
> > to about 55% with the batch size 1,024.  The trend is somewhat we can
> > expect.
> >
> > Interestingly, this patch has also optimize madvise() and single batch
> > size process_madvise(), though.  I ran this test multiple times, but the
> > results are consistent.  I'm still investigating if there are something
> > I'm missing.  But I believe the investigation may not necessarily be a
> > blocker of this RFC, so just posting this.  I will add updates of the
> > madvise() and single batch size process_madvise() investigation later.
> >
> > [1] https://github.com/sjp38/eval_proc_madvise
> >
> > Signed-off-by: SeongJae Park <sj@kernel.org>
> > ---
> >  include/linux/mm.h |  3 ++-
> >  io_uring/advise.c  |  2 +-
> >  mm/damon/vaddr.c   |  2 +-
> >  mm/madvise.c       | 54 +++++++++++++++++++++++++++++++++++-----------
> >  4 files changed, 45 insertions(+), 16 deletions(-)
> >
> > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > index 612b513ebfbd..e3ca5967ebd4 100644
> > --- a/include/linux/mm.h
> > +++ b/include/linux/mm.h
> > @@ -3459,7 +3459,8 @@ int do_vmi_align_munmap(struct vma_iterator *vmi, struct vm_area_struct *vma,
> >  		    unsigned long end, struct list_head *uf, bool unlock);
> >  extern int do_munmap(struct mm_struct *, unsigned long, size_t,
> >  		     struct list_head *uf);
> > -extern int do_madvise(struct mm_struct *mm, unsigned long start, size_t len_in, int behavior);
> > +extern int do_madvise(struct mm_struct *mm, unsigned long start, size_t len_in,
> > +		int behavior, bool lock_held);
> >
> >  #ifdef CONFIG_MMU
> >  extern int __mm_populate(unsigned long addr, unsigned long len,
> > diff --git a/io_uring/advise.c b/io_uring/advise.c
> > index cb7b881665e5..010b55d5a26e 100644
> > --- a/io_uring/advise.c
> > +++ b/io_uring/advise.c
> > @@ -56,7 +56,7 @@ int io_madvise(struct io_kiocb *req, unsigned int issue_flags)
> >
> >  	WARN_ON_ONCE(issue_flags & IO_URING_F_NONBLOCK);
> >
> > -	ret = do_madvise(current->mm, ma->addr, ma->len, ma->advice);
> > +	ret = do_madvise(current->mm, ma->addr, ma->len, ma->advice, false);
> >  	io_req_set_res(req, ret, 0);
> >  	return IOU_OK;
> >  #else
> > diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
> > index a6174f725bd7..30b5a251d73e 100644
> > --- a/mm/damon/vaddr.c
> > +++ b/mm/damon/vaddr.c
> > @@ -646,7 +646,7 @@ static unsigned long damos_madvise(struct damon_target *target,
> >  	if (!mm)
> >  		return 0;
> >
> > -	applied = do_madvise(mm, start, len, behavior) ? 0 : len;
> > +	applied = do_madvise(mm, start, len, behavior, false) ? 0 : len;
> >  	mmput(mm);
> >
> >  	return applied;
> > diff --git a/mm/madvise.c b/mm/madvise.c
> > index 49f3a75046f6..c107376db9d5 100644
> > --- a/mm/madvise.c
> > +++ b/mm/madvise.c
> > @@ -1637,7 +1637,8 @@ int madvise_set_anon_name(struct mm_struct *mm, unsigned long start,
> >   *  -EAGAIN - a kernel resource was temporarily unavailable.
> >   *  -EPERM  - memory is sealed.
> >   */
> > -int do_madvise(struct mm_struct *mm, unsigned long start, size_t len_in, int behavior)
> > +int do_madvise(struct mm_struct *mm, unsigned long start, size_t len_in,
> > +		int behavior, bool lock_held)
> >  {
> >  	unsigned long end;
> >  	int error;
> > @@ -1668,12 +1669,14 @@ int do_madvise(struct mm_struct *mm, unsigned long start, size_t len_in, int beh
> >  		return madvise_inject_error(behavior, start, start + len_in);
> >  #endif
> >
> > -	write = madvise_need_mmap_write(behavior);
> > -	if (write) {
> > -		if (mmap_write_lock_killable(mm))
> > -			return -EINTR;
> > -	} else {
> > -		mmap_read_lock(mm);
> > +	if (!lock_held) {
> > +		write = madvise_need_mmap_write(behavior);
> > +		if (write) {
> > +			if (mmap_write_lock_killable(mm))
> > +				return -EINTR;
> > +		} else {
> > +			mmap_read_lock(mm);
> > +		}
> >  	}
> >
> >  	start = untagged_addr_remote(mm, start);
> > @@ -1692,17 +1695,19 @@ int do_madvise(struct mm_struct *mm, unsigned long start, size_t len_in, int beh
> >  	}
> >  	blk_finish_plug(&plug);
> >
> > -	if (write)
> > -		mmap_write_unlock(mm);
> > -	else
> > -		mmap_read_unlock(mm);
> > +	if (!lock_held) {
> > +		if (write)
> > +			mmap_write_unlock(mm);
> > +		else
> > +			mmap_read_unlock(mm);
> > +	}
> >
> >  	return error;
> >  }
> >
> >  SYSCALL_DEFINE3(madvise, unsigned long, start, size_t, len_in, int, behavior)
> >  {
> > -	return do_madvise(current->mm, start, len_in, behavior);
> > +	return do_madvise(current->mm, start, len_in, behavior, false);
> >  }
> >
> >  /* Perform an madvise operation over a vector of addresses and lengths. */
> > @@ -1711,12 +1716,28 @@ static ssize_t vector_madvise(struct mm_struct *mm, struct iov_iter *iter,
> >  {
> >  	ssize_t ret = 0;
> >  	size_t total_len;
> > +	bool hold_lock = true;
> > +	int write;
> >
> >  	total_len = iov_iter_count(iter);
> >
> > +#ifdef CONFIG_MEMORY_FAILURE
> > +	if (behavior == MADV_HWPOISON || behavior == MADV_SOFT_OFFLINE)
> > +		hold_lock = false;
> > +#endif
> > +	if (hold_lock) {
> > +		write = madvise_need_mmap_write(behavior);
> > +		if (write) {
> > +			if (mmap_write_lock_killable(mm))
> > +				return -EINTR;
> > +		} else {
> > +			mmap_read_lock(mm);
> > +		}
> > +	}
> > +
> >  	while (iov_iter_count(iter)) {
> >  		ret = do_madvise(mm, (unsigned long)iter_iov_addr(iter),
> > -				 iter_iov_len(iter), behavior);
> > +				 iter_iov_len(iter), behavior, hold_lock);
> >  		/*
> >  		 * An madvise operation is attempting to restart the syscall,
> >  		 * but we cannot proceed as it would not be correct to repeat
> > @@ -1739,6 +1760,13 @@ static ssize_t vector_madvise(struct mm_struct *mm, struct iov_iter *iter,
> >  		iov_iter_advance(iter, iter_iov_len(iter));
> >  	}
> >
> > +	if (hold_lock) {
> > +		if (write)
> > +			mmap_write_unlock(mm);
> > +		else
> > +			mmap_read_unlock(mm);
> > +	}
> > +
> >  	ret = (total_len - iov_iter_count(iter)) ? : ret;
> >
> >  	return ret;
> > --
> > 2.39.5

