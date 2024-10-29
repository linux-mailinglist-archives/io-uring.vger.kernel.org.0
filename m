Return-Path: <io-uring+bounces-4091-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E6F089B405E
	for <lists+io-uring@lfdr.de>; Tue, 29 Oct 2024 03:25:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 57604B221DD
	for <lists+io-uring@lfdr.de>; Tue, 29 Oct 2024 02:25:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 756142BAE3;
	Tue, 29 Oct 2024 02:25:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VXFMa+Fa";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="jWdmveKc"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5214718DF62;
	Tue, 29 Oct 2024 02:24:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730168701; cv=fail; b=NU5DPKXH+XDC9TdAKXIYLYxXEVneybYNIpZ9DMGq+v08PsD7uic/aW+n4NnMcgl+I4hKDwqDQ+FLmhzgp33dkGMG8ixQ9A+v/IQ8oWzObwhLDAYdOIN9I22a/A0YNk7aj9wJ3yMkJ3YpZXFCZSEl8hKPz7QysUf2wBFDfBurn2c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730168701; c=relaxed/simple;
	bh=BrrqjRc3FoutqeC18W9radUqKnrk6XBXcPrjWLyJQFM=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=q9OptDglsFQIV9wNRCNt/F0xMuRTB2SNZ4LMjTQgAxzH5cwRqO1aPfoZwOFsE5vqGXoiI3B8KenighgiORtz9QqA7MVqjeeqgWALunVXZPH7nbbdNBc1hyqZU8rr6fMi4jIOb4ItS0ILpWIGiWk/7TfmHeZxJ8EfoipSQNSUr4o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=VXFMa+Fa; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=jWdmveKc; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49SKtiH4032601;
	Tue, 29 Oct 2024 02:24:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=qiBSqHiw8KGu3o1XFP
	BC/QtMl8iLL6pxZ33H6Xs2q8U=; b=VXFMa+FaomlP67gZE60shk4s0jyxNCTTD+
	zkCk+KVa+Oyex5y0ut3Vg1w1E4yI06rSi3aiCiY2JV5AS+0DxDeaQjcr/zWHG/5c
	d7caIf6hf58REOyaBJZGwf53p0G3KHI/WJbco0qqzPO2EN6lSzCJd5IW43cNFMLp
	tqMZIxdam6zwSzoP1otHuK1zXKn0uxFSUUCoYUPVMC9iXJm5WDQGu/cyLQXuRli3
	PD1n86YgHi+lBhgafP+hBN7ptbLPxhgUMqIo1doEuUGz+HhwyO8t11Clu67hM52w
	pfCnhr+0oCp3fADa5/kPQNxQxrQjD8akIVuTqBhOe+33YrkzCVKg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42grc1va2m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 29 Oct 2024 02:24:41 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49T28GkF010281;
	Tue, 29 Oct 2024 02:24:40 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2171.outbound.protection.outlook.com [104.47.56.171])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 42hn8w5h75-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 29 Oct 2024 02:24:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iKWUhcmpfIrQH5n7TVI0qiSI3ssI17pqj3rFwLm6/BVlm1y+KJwUaSnQRB3hsCqgG83c/KvQH3A/jdhbosptLiw1ZU3wE7dotgBRyRYni+iraV9LVHWN9tIBusfbDXgAhxyCtzJpvPZvrl+X0g3y0oX7ZFK1QGXUUHaetv3pe19YnsCxUgIOmaflIAQxF/eQ0cWxuxv35ZLzrbWo2AlH/J5dlwFSzH3DMnxh1D5mEGkO7cVvefegJkPIAZKiI6IZvHuCG74DxnUosjVeD8nmPLoPe7WKIx1IldYM2aGOgOQM+1LY0acfEd7v8EBohWWxNn9ve+1xVGNwh6mB45sLfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qiBSqHiw8KGu3o1XFPBC/QtMl8iLL6pxZ33H6Xs2q8U=;
 b=rr8niOor7/Ogv+hKCgLUrOgZ6JV+VDUKzG05Qo9wMVZu3bLooa429tDV/yOVh7fEzG22EuDDD4oN7Mz40gdE6qbiEHzNk1i4PUh8aBCby7vkjp0xLAhEfeOK6NbS8NEeB5xlxIT8gnaogJLEEfIgje9QoS7Y1ZK+Amp4EEh9LhkIktvDySLl2BcmCVkjlQXVUtEJrXh7HqB7m5D9CErkroqyir68UftdMW0Okm8uLxzlL2cKvvPN9Qk/vuNvKohWPh7iVhd4hqzysxLe8QUWOgN3Du2puoRSq3DmQH/jih3nORqOc++Zpk0icci+nSLhC5o3axK9U1DtZcmWCj3Cbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qiBSqHiw8KGu3o1XFPBC/QtMl8iLL6pxZ33H6Xs2q8U=;
 b=jWdmveKcocjOaeFphyfkB3+hsWCGDNlp06DWcxlZUUxWdnNimoYx2zpLaaULeXHMMxfR6gK5yy/is3/AL8FaUIRyk2CaqYDD6RRRw3TebQgkWNmjP5HzLvpQ82e00PzDu35t8uoqJBjO/9/fxcG5kvoN5IB4x0EseuODnU5zVI0=
Received: from DM6PR10MB2954.namprd10.prod.outlook.com (2603:10b6:5:71::29) by
 SA2PR10MB4409.namprd10.prod.outlook.com (2603:10b6:806:11a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.27; Tue, 29 Oct
 2024 02:24:37 +0000
Received: from DM6PR10MB2954.namprd10.prod.outlook.com
 ([fe80::3d89:e811:9df9:6fc6]) by DM6PR10MB2954.namprd10.prod.outlook.com
 ([fe80::3d89:e811:9df9:6fc6%7]) with mapi id 15.20.8093.018; Tue, 29 Oct 2024
 02:24:37 +0000
To: Anuj Gupta <anuj20.g@samsung.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, axboe@kernel.dk,
        hch@lst.de, kbusch@kernel.org, asml.silence@gmail.com,
        anuj1072538@gmail.com, krisman@suse.de, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
        gost.dev@samsung.com, linux-scsi@vger.kernel.org, vishak.g@samsung.com
Subject: Re: [PATCH v4 11/11] scsi: add support for user-meta interface
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20241028073610.GB18956@green245> (Anuj Gupta's message of "Mon,
	28 Oct 2024 13:06:10 +0530")
Organization: Oracle Corporation
Message-ID: <yq134kfd4ub.fsf@ca-mkp.ca.oracle.com>
References: <20241016112912.63542-1-anuj20.g@samsung.com>
	<CGME20241016113757epcas5p42b95123c857e5d92d9cdec55e190ce4e@epcas5p4.samsung.com>
	<20241016112912.63542-12-anuj20.g@samsung.com>
	<yq1sesolxa6.fsf@ca-mkp.ca.oracle.com>
	<20241028073610.GB18956@green245>
Date: Mon, 28 Oct 2024 22:24:34 -0400
Content-Type: text/plain
X-ClientProxiedBy: LNXP265CA0047.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:5c::35) To DM6PR10MB2954.namprd10.prod.outlook.com
 (2603:10b6:5:71::29)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB2954:EE_|SA2PR10MB4409:EE_
X-MS-Office365-Filtering-Correlation-Id: 4c2afde2-0989-4266-a273-08dcf7c0d5dc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?QlxjiHiMGXsfE1xLs8W23e4xicfc1I6qIZsirFsdE7d/dU3o/pVgRJJoIzaw?=
 =?us-ascii?Q?9LeqBYT/mMz0HXkH+jZv1BnRgCiqi1+e/hqATcHTbWJ7fRcf2er5qFJ1vLou?=
 =?us-ascii?Q?3VTLjz6Bj1zwk1fHcxHa6NJK+oqDWpktBWZWdN8pioEYa6aq1YH/uSSq+xSo?=
 =?us-ascii?Q?1rpmWl2uhF+fxZrbjm+kjSFzqgmUBWRtozcRjnpnSftqEaQZxbPlcTZguv3k?=
 =?us-ascii?Q?8AMswA+uj0cfoT84cyinldFW0Yx8Ag/nqKpZs3CKoj81fmj6cBybBIELj0ys?=
 =?us-ascii?Q?AIzW+1TfDaa8eGvPdG29KLlHu14FgPaFjNEWYe8lgqIslikoVV1zdThVvv5y?=
 =?us-ascii?Q?SuGdDLsasctEohHhirg1cvuRpLnc3dns40tXjkp7eWOmlZgx29ruHrTDmCFh?=
 =?us-ascii?Q?KUHLqBLXlmVnxK4Ub6i2DewBQYsuJjBnrM3nquleAPy/f/FgzWi6TJSfdu4D?=
 =?us-ascii?Q?J/OBkqHv9rqkAQKIhUzQA1dO/FekfD53H+pObYf+7cCuI9AmFidkswVFSDKI?=
 =?us-ascii?Q?aCjDNip6ifjAqZp1KKpQInehzyMDVthZVg46AgtcKCSbKECbC80g3jomRHmw?=
 =?us-ascii?Q?QuCGcb9Hdy4wSiAP6MGF9XzUsjJjIrxZt8r7Mo3ojx19gTh3nrvnvd2mXaHR?=
 =?us-ascii?Q?glfW19APl23ZCJo6OHngF/w7u8MNe6xYDI858Fr8nlpha9K8DjiUpXg0pZCD?=
 =?us-ascii?Q?YSB0SZNs7KOiJIUwPlQ2c52AyrWfh987D/gYn9iP2hTrSCfTBKyt0WAV3tkc?=
 =?us-ascii?Q?i1A4gMYlhcHtV/n/bSbOGD09AFvpegJYd1TNhTrMwWb9rpEb8rpfLQwAHjXO?=
 =?us-ascii?Q?hILqGM3QVdOt7lZaUfGzbxTHcH6cY31lsTGeGyeFLYamTz/odQtqxb5Ps0fB?=
 =?us-ascii?Q?BLr5VLlHQvyw1O38B7v29rujBVmaaiVnjYm7z2lvDVY3976yhL/yhp6tcFCa?=
 =?us-ascii?Q?4zX21+W9EwZtzOsTFO4ixO6hIkPuhZ05NKKN7qZs3JtgczYroPDeKMGPbI3E?=
 =?us-ascii?Q?IkWf1JNicDYneW9D5vwy9jf2GYAlUsgKlMvlUMwlOt3Obp51WPwX1E2eaMQI?=
 =?us-ascii?Q?Vny6WAUqbpKZQKrTAaQa3BPE0Tj4kLBys3csP3gLCroUI+SQ1lxWJHIdkhJC?=
 =?us-ascii?Q?QbT/hEBCzQ0Jq1ipMvBsXTDud1+TrkWYzIxGJgaFtMzT8JYl1ndglJpfHebf?=
 =?us-ascii?Q?151slmZjaG55HOpyTC7V6ERzUuGVD2Xw1+OSRkh95/f1HaLBrc3lYV+UgDDk?=
 =?us-ascii?Q?yWlmdfuFtcS6mCZN4FYUWB8HOhs8+StT5s56oerkoSbZz2WB23pdysAHUxN3?=
 =?us-ascii?Q?354hMosO+fFz5RnVIjDvZ6HR?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB2954.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?SqetY7BisMX9kWQM7ltuq4iwM6JBy/abg5b5mtunCaFEP2jgo6Oepzo8Idzu?=
 =?us-ascii?Q?tBYwfVPYu5xhn/YP4lmkKDcXe6QkRGoABFXHZRVrsA6YSyzL3m0qzgxLKU3M?=
 =?us-ascii?Q?KdqwOruajKY7cGZt/Dxou5AUnU3X64bN36JPgv82Gur+SgQwEAc8uq6+PkV1?=
 =?us-ascii?Q?fj3QQC7kLDgYPHptiwrMchsGljZPbuNWwVjZ80qXOYeO0vTVEil/Sr2oOjuP?=
 =?us-ascii?Q?Ny8qABhWT5K3NzkmjgDP70xHCcfGkN3sXPdmdFZ06XJImBYhjQtaGkv+wuQH?=
 =?us-ascii?Q?XnI8uAjAsx3SDhawHjd4VuKXJhrjfWIU0BJnJkznLvIZ0Q65FobkccoVU/K0?=
 =?us-ascii?Q?ADPNWp70YWx7m+vFDJ069knW1aVCaJQYSkV02b4u8SpL8lU8BgfUQ49PgzP1?=
 =?us-ascii?Q?kBo07G9nPfLKpaj6VidSs4XKt48Ts1nSayYYTw3/a1Z0xbuskn08KmMmaDYb?=
 =?us-ascii?Q?PtuaCRRLTL5o2CSqh6zBiuBap/u3afRUI1zQBjM+TaowQdj55yX/KZO0JCtb?=
 =?us-ascii?Q?om3DHVK63DHD4qzxGd2taO6WufZi+UwxFNodP4tqhUMZ2dXpWcN8bFGlXLPj?=
 =?us-ascii?Q?JxDa02D6nb3dlB8UCUSgzHzTaVDdAgq9UBmY8DpifiX6VUIkVQDAAYbnufnz?=
 =?us-ascii?Q?rsLhyADYS7XOP4tFrgDSsBWZdOM71yh96Tr9DV4Wc61IvQr3ivg+n9Ebwl51?=
 =?us-ascii?Q?GRXkTMKjztE8OTRT+SVBSz6A79A62izjSlHcgx80mfi+ymDqn0XtH3eIS0EA?=
 =?us-ascii?Q?65wXG1RqxDYCXm7/gVCTy06P5WXAVbYZF/IkyT0QwKoZRuF0O04pv95wwW9s?=
 =?us-ascii?Q?VgVoVKk1jsQj/7rmiBS1ugSnOuSSNjT0s7tr+iQ06HI92jlHCg513YCuotlT?=
 =?us-ascii?Q?CHtCl6nSPV7sRD/a9dRC4LhjpiZ5eU8r4mIzRaW3OnAShq3ZWP1kNvT10CLo?=
 =?us-ascii?Q?6E8uDdjEC6n+8ZhX41NoHEU73rRySPwYVELv11oBVo5luQTznvpF9aQtmbc/?=
 =?us-ascii?Q?5PRmMgMW+jGbmCT3mKhOJIt++GfMGmTIELzvmjpEvqkxuWm5k89k0DnVqL8s?=
 =?us-ascii?Q?O1opaHDTEA6Q3TGsrBweBLAhRCqhvITw/pucSooTRtW8GTA7SIslstxopizn?=
 =?us-ascii?Q?A48OdSYAF+VekHb7U0GefObm8MhC0aeokTK+9HErhIlBD2Djt2MM14Pckpzq?=
 =?us-ascii?Q?9i4HdaRfJOaCjiQvjGZNLD5K8LIwWAGw0Pzaq8mopla0CamIXfD941JekDWW?=
 =?us-ascii?Q?du6YFnXylvjLA8sisakSgODdqnn+WeRx2td9+kfy5sRKuSxrMwKwJqleZOkI?=
 =?us-ascii?Q?iRAdo3ofSunjbaRfBegoepWIDO/w8OO6Sc0lEGfgWWgfgBH2zLMBRv7siQfR?=
 =?us-ascii?Q?3UBOIy6azZbjQvwDwmeJP36/f5mnTRLRs2wUJEfq8cjjePRBx6q0o7jPoL+k?=
 =?us-ascii?Q?tiC+4/tA/q8zu1wAb5q+P6ht3a//KkGiYO2QfKpayiIRTP4oQRjMF10qftEH?=
 =?us-ascii?Q?M0VtM4HOcoeVIY0WwIAoLR0MggY09LqnWOI2ZG18NlFs97F1pn2ShKWP1kkF?=
 =?us-ascii?Q?ohIXadWbjLL1AQq+Q06WaA7Ot6mDTIjeqoafD8cMLvp+u4x/UNHsF9/t08KM?=
 =?us-ascii?Q?5A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	usGhnSJ7ILc+tfWLjPvTT4J46mMpw9Cd4jsvWqIlfbmGBiRbm39D8nL94kKpJHk9254DZnptRgbBkrOOhVNwKCr2exkPQb2HTwCEBmM/C4pKLiAMI/fG7J1+oRX5ORybO5bJVB+9iebLd9bbD3VJmAxNGvNYfUaJS0/fnxDJLeuiqPEgyADJM0nzjqiP6rUzF1w462pcu9Zn7I8AQ/9F4fjUHpBq4LS44oKY0RCfm1dB29WOsZLNYScLUPldM8OA5C9r99GKlp6AJVSLAFsFhxQD8TbGQxW7NeHP/WrO2ZKjIeGwsR7qJC9ZCMekFca3nl8GUFKIGfpEd3t04go0jDOmJnMJ+jXoyJ1R2LFFT5pZinPozLZK1nfXZMGefYB1BxGYHUWW2VwCxfdWTLMwPbMe1bn29pohDk5Yr2UJ011Yj/WrZZ8KVRbz//sp5vYB/HlXbEFTUfmyev0JW3Aw+GiyuqV0QX3nLNj3Fg8lG2eJxSaY2l4lLspuw/8Qm7/ksOYrESd8mrquX7X6qdK2bcoV1OHvvsiuHh0Tgu7GM7RShBpDORuffmNqZkA6MLfyKFM07x+sZR4531JUgEtvB/qIvLqq7iIRmXoZ0c5FAI8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c2afde2-0989-4266-a273-08dcf7c0d5dc
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB2954.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2024 02:24:37.4871
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tsHob/Ei9wXTEwWtLqF+gw6KKtlrlCValV7ODCCmfqzApQ6R8pUv1wnFZXaf7HReP1qSijEBxlYqtY8PgvcFGXjyKvTbgE1z4D6H7QSIHho=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4409
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-29_01,2024-10-28_02,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=815 mlxscore=0 spamscore=0
 phishscore=0 suspectscore=0 malwarescore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2410290017
X-Proofpoint-GUID: HWlfNULtW_jbLIJZOKgRKXewPQpBVGvM
X-Proofpoint-ORIG-GUID: HWlfNULtW_jbLIJZOKgRKXewPQpBVGvM


Anuj,

> So I will keep the fine grained userspace/bip flags (which we have in
> this version). And drop the sd_prot_flags_valid() and BIP_CTRL_NOCHECK
> like below [1]. Hope that looks fine

Yep, that's fine. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering

