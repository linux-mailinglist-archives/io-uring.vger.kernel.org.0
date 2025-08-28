Return-Path: <io-uring+bounces-9411-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 47D22B3A6DA
	for <lists+io-uring@lfdr.de>; Thu, 28 Aug 2025 18:50:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0D4AC56303D
	for <lists+io-uring@lfdr.de>; Thu, 28 Aug 2025 16:50:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F2A33090D1;
	Thu, 28 Aug 2025 16:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KdWBpK2r";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="rTkofyyR"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E91130CD95;
	Thu, 28 Aug 2025 16:49:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756399796; cv=fail; b=Xwy3n8dDJE36/PipjJ2IXc9qvIR2tx5s7CYk9RHVyLW1CoJ1QG4AsZyyk5vGbTUcm23rhJX44pCvREG2CAu1mo/hcuIr+O6+mGDc6mKZhuUSLfhD5Cg0+9zsyHEBgr4hfueyxZIZScbM3sE6HJ9bAVMwvlZr+PxP23QBNXyYq9I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756399796; c=relaxed/simple;
	bh=a1Z6Fob5hnSE8TA69tDeSeErRWnbR9wOG2RA47VDyRM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=QaRklXG1lWIkozFwBp0Vf0dTPyYd9/i+QGT9XxZIzIBcy7ikJe5GkTFovlTFR8DiO1gVtt4pCufM4Vhmm9Ugkt5Ji+Mrf53w+iALDJ9+nrc52Y88ZlcET/MJaT9JZtK9T+gwVUDBNUGxEL3U4N4f/hqJ4h+VhDnOZcaytwY8qr0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=KdWBpK2r; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=rTkofyyR; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57SGfxdO021545;
	Thu, 28 Aug 2025 16:49:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=z/kKdVny9czxoV5y1K
	KriERorz1lE4RPzGm246axNEo=; b=KdWBpK2rZ7FbU9gAd1hK6b1UCuFbAV43oF
	V/xAe1XPFWeYvmsdeM3yLqL5JWv0o2v2VwL+Pi5RYuArDu2vkhRRT3f+R2XZ5cwW
	7rZAN0VOSiD3WGO9aLRGfy11BFJnbnCVcF8LGQqaF0OMQOyQSrYnqAHwHd42/L3D
	rBj7vOHJmO64hhovNK0SBmW+pXYkATbmeNuFuGR5siPsPtP7KwRzvEJRlxklhGpj
	1uYq49qm2u6bQ9uIyz9m79TXP5LI1Mwma6WuCIHnSmQKV4fNlZRzfgLkSSmIsK3q
	qB/dTL+DBXcGq6rIn+arOzpnPys34CPuaHQqxOXjIPeJ5fHPPPAA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48q5pt944e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Aug 2025 16:49:13 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57SFYUXI005292;
	Thu, 28 Aug 2025 16:49:13 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10on2051.outbound.protection.outlook.com [40.107.93.51])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48qj8cc72e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Aug 2025 16:49:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MpusY2vSnm138MvesJY3o06jb0EAaB2W41EFreJD4PIGgAvA2rpSd0wB/E9IEiBx7QO1siOGtI5f8ErY8/uxi3NUkKzKdm4ofBRaeMxVo0Unm4dFgcdxu7Y8o3X9zASrfbYrNddA41yCkK+CVW++tXh9s/t8jUiQZ+Zds4NH7KcwL+nYQzHvgohTiXpm59PC/uW0JDASLuZ/N9XYl7EweLwkw4M3mrK6GXG+kUTFOSu4I0XyPiE5gVAmbVclwcHrWhdidPgwOrkohU37p4uw/qHvO31oaC32G23YP1HucwlX+6oI8Vv0I125ZerhsG2YVg+3hizqgqKVYV3g8wE7Qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z/kKdVny9czxoV5y1KKriERorz1lE4RPzGm246axNEo=;
 b=iDm0hOi7YFP2ZpeIxYXIQPtx9BvFHRqKx9b3ykn0452RU5cMfdQn6IBq7SqHeOZaBFPu5joF46YT3qvSs710nvD7KyHnBfo8WPJhmrhY0Pz67J8nzJw1CivUCM2GPHMB5azB3D2QWyufaqt8+8/8+zNjYGDJgKXffoTsNNJxhsbFlmEPbpYH3gFlmuVQCEL5aL9xibClHfOebLVVvR+mN18a0DAukiyiMa7orCELKsuuGgVJ6RnBdj6JashmnjkzVoqB4py4C0iWyO+F01ed0sE6YmL3cfhSSy5Ovr7DiaYOslKMmz2MrRzFVlcgUAUpPwifpfPZPK1qhY2KmmfyGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z/kKdVny9czxoV5y1KKriERorz1lE4RPzGm246axNEo=;
 b=rTkofyyRey4n6fyCJDJvylrtM38/MpUYCNiZp/jrO9jfZg4XUZpapyvmAoEC5v74/6w7Z52DpOCYhMXCESsUuAw/DCWkgLOhPrBkYW5J8Gkw0ZkIFXZhzDhC23B2bt4d4CyN3GTmCWXlefPZuj7cAq8G5576CRa7B1/hGZf+ZC4=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by PH7PR10MB6676.namprd10.prod.outlook.com (2603:10b6:510:20e::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.21; Thu, 28 Aug
 2025 16:49:04 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9052.019; Thu, 28 Aug 2025
 16:49:04 +0000
Date: Thu, 28 Aug 2025 17:48:56 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Alexander Potapenko <glider@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Brendan Jackman <jackmanb@google.com>,
        Christoph Lameter <cl@gentwo.org>, Dennis Zhou <dennis@kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, iommu@lists.linux.dev,
        io-uring@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        John Hubbard <jhubbard@nvidia.com>, kasan-dev@googlegroups.com,
        kvm@vger.kernel.org, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-arm-kernel@axis.com, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-mm@kvack.org,
        linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
        linux-scsi@vger.kernel.org, Marco Elver <elver@google.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
        Muchun Song <muchun.song@linux.dev>, netdev@vger.kernel.org,
        Oscar Salvador <osalvador@suse.de>, Peter Xu <peterx@redhat.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
        virtualization@lists.linux.dev, Vlastimil Babka <vbabka@suse.cz>,
        wireguard@lists.zx2c4.com, x86@kernel.org, Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH v1 19/36] io_uring/zcrx: remove nth_page() usage within
 folio
Message-ID: <4f366255-5dd9-44ac-878c-e44e557b8484@lucifer.local>
References: <20250827220141.262669-1-david@redhat.com>
 <20250827220141.262669-20-david@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250827220141.262669-20-david@redhat.com>
X-ClientProxiedBy: LO4P265CA0327.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:390::10) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|PH7PR10MB6676:EE_
X-MS-Office365-Filtering-Correlation-Id: cc8a8a61-9506-49db-e569-08dde652cc29
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?5Gn5DcHCqjDgQbGOFBghS3c/dqswOSarGYMJdkg4G/nFOz4HvDv3MDA8oaqU?=
 =?us-ascii?Q?j/Fr7tzpkpR1ASqSDHSjH0WkON5wPoi0DYBln5bgAebpUBvEQ+FQJG6xZRpn?=
 =?us-ascii?Q?Ic8PxeyZlxbNsbbotBme9klNqnuHDcd4qlCuDxjtua6LlJKqN3RWp/gxjbF5?=
 =?us-ascii?Q?k4Jn4PrRSwOigi/WWYzIDjlulF8KPcaAnaXX+UEblozRDQ3jKNxzu/kz6HMn?=
 =?us-ascii?Q?bXVlJ009iLJ52AzgQg5r4pOIJyxLNDc7AGBRunE4+CvPsh3NN8468I5WkZ8t?=
 =?us-ascii?Q?HYO/+SBCUvIt6FDg+EEtODf1s7WQIJiXkPY8xt3sLN/cAPeRW2fg8zE7hvKd?=
 =?us-ascii?Q?Cr32zTXk4LrSfut5k24yuN3Qq72ns8epupd0op7izI8I6a3VJYcI8/s2mepI?=
 =?us-ascii?Q?um652DORW3jO+ZTKHtuvQRMB6BpXc7vFC0kPaiNBO8cfpV3ccaXmS7OIwFso?=
 =?us-ascii?Q?wQlmGFlIT48DVVie0kpR3KeJvFLCjEv+hfmmzospXXX/C8fWpUl4TrAxQX3Q?=
 =?us-ascii?Q?Vc3uaD+S08GhZI3p6nhFK33pKEfGm8jBhwwg6y8o5f300blTVj3XTG4QHfgX?=
 =?us-ascii?Q?LGmuord2mKr1OxrDAjSP33TT82iCdWbaY8IZc58cTlzrlDAbvDEOuZcM0XMD?=
 =?us-ascii?Q?WeKEC9wJI/jnn1vX7EW67Y1i2d+A3F80wCHR8YCfHCQoDOVR0HToD7+Ksjve?=
 =?us-ascii?Q?gzDhGI5V7kEOuGwTsdxZXTlL6uzHmSziLxxBDoxGaXXM2cZ5HJEHuOHYivUf?=
 =?us-ascii?Q?gcWYuqKRiyJajx3sdP5jzwwxz8dressc7YFN8nAzM88vmVnOY6aD8luwgcxb?=
 =?us-ascii?Q?nTOng3nBs4xE86Jw3UriFrdYgGatwu0HiIyIB7soq819c2RHF4/cHJLF88TK?=
 =?us-ascii?Q?4Vtchw/eRZq+zG3iZa9XFQJe3yaEshJY2SCdrCQhAUrLUeNrzfx0K8RUaf4L?=
 =?us-ascii?Q?0Zpc+vousRTjA8sjPBItaW+3nrokmW4+vQW01W1HPOz2OxjBv+4n6+UR46gd?=
 =?us-ascii?Q?WzNAxPRqgq4b64JYlP8WHWUb/DfxzP5cwInEuyzxTYcbPtqqTupGtzsZST2r?=
 =?us-ascii?Q?Hv3sXITqQ7/8KWm17VPvxO1L7FRlrtsACz92A0iIYUMSkFTP9hp9YisrZJ4v?=
 =?us-ascii?Q?4VTPv0tDVOzFcjsFCVRACL60LwTjdGwxuxvzajxiJdjoEDrTr7tJSFbJUEty?=
 =?us-ascii?Q?BSQUZg2pcz3qrvEJ2FS7BThm6IjkcEagIlnRaopF4V1mUvEn077yJ8+8B/dV?=
 =?us-ascii?Q?5NMwCjMrBJ0QVJCLEM4I0ajPxG+3A79xJbLdjRhKP26Oz0/8Mg0VcC4brAAX?=
 =?us-ascii?Q?V1w05cKMWCGGprNElOrXt9X460UotbawYR83akXmEo7P46X73356WV/QsVoh?=
 =?us-ascii?Q?3yDcVjEdh638s+mIE7W+Z6/5Fr24cbsw6B2PaoUi6AqCZ/CseOlKtQDONK/y?=
 =?us-ascii?Q?SfK02v2OD8Q=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?CZmBO6Z/UMwoafcs3vxpKx/mZJu0CyZl4cyl3+XeCg5sEsEZ0SPxro6Q9aHl?=
 =?us-ascii?Q?1mDK/l/jloVOArmWVin5R88EFYfNuN0/TTTRWfASSKNCXOWhmkkWMSkRTAWv?=
 =?us-ascii?Q?T34L/MhSrNvfgD2zv7y/boYh1PL6F0Vv10aua/lXxqXOfcKm2rWqjcRNJ4Px?=
 =?us-ascii?Q?kmZrou86zJWMUVlMCBcuL1FzeT2wbqLxhidqS0OCmR86jgdrEDYvYf361UxA?=
 =?us-ascii?Q?GoH7F/0PonX9Q93hmQfuLfUBIr0NAmx3JSfD7UanzU00HnaLhTUvTsFbBIGi?=
 =?us-ascii?Q?gagJsXk2+3Ka1pljna4w+kgWDTXu+lmk9abrXAYBOp9uMttHyBWhw+DLCmOP?=
 =?us-ascii?Q?2dTl8nxV3579pMVlvySsVChcrcOt3ttEm7+c8nyClOCqHV3LEDIKvc48jinB?=
 =?us-ascii?Q?ZDqNsosDFN71udB3zDm5Qfyues98E3DezhlL/ekL2+SxXw1yFl76aGrr+Hay?=
 =?us-ascii?Q?zbqcgUjreBkdwjWdQsSoT3+eTfp4CEnXXgS6GVdTGqyUM2YT+kbHsBol0Wm4?=
 =?us-ascii?Q?aq2sJ4gMnN76ZaDcHqFG8wzPq+Z4Xk60rIguc+DwUdu2fg2mdRXNr+pbV6Zb?=
 =?us-ascii?Q?6uZyEuqaWrnB/SjHnihpadde7oN/5QpAcb/e56Rm1yhW4cADSUkUNDBcgSkc?=
 =?us-ascii?Q?L+qTkg1UDWY3jUMy3ZVPJt7LyIW+WG1iQ3o3nnROeRMz9kXJFimCUBvaH+dS?=
 =?us-ascii?Q?67kUtii63fBdQrDTuaXvdjep31ETqTcu2D2PJGh8Jtq5mEv8+6qKOopvy37m?=
 =?us-ascii?Q?edqD/ojVgACQXjbYwqHYJr5hB8jM88upqTWTSIr1E+mP2weSANRbEs6LKI6y?=
 =?us-ascii?Q?CoQbbH00TzhXeUqkFVQKGWHmWWdu5Vy/oYO0ZYzeJ5+uAZybCSBuGRYAM6N5?=
 =?us-ascii?Q?xeW1+tCKtygBKlhtKl1fKSKlbnt6MQg7oT8x1JZIbwKTqZrM5WHdVu59urK5?=
 =?us-ascii?Q?IpiRu8AMP3/sfXAPrLwTCwemnZOfoRiVINRsalyhuGVq3XZz4rD12XeyMiCN?=
 =?us-ascii?Q?K/gXHZ12KwMhqurlnWMzg27OSADfBqcAyfFJ52XcsabXNEVzmR+/7WxIYL5t?=
 =?us-ascii?Q?jeSU8nRiHzEw3B2qM6dm+icuXmx2qXu1qbaQO0cLjUb4sP2I3KLfQWM0s4IP?=
 =?us-ascii?Q?CSXn/hILNnq39aKjjUIywbNc8jAZHkcoLGmVw/Xcy+YiaVLIjtDzNLeS0vLJ?=
 =?us-ascii?Q?/KwHNPMKXpqncvyFSVoKnK6P2lFMrHWspxBHSqvB1UeS/QeWjFvht6RZmFf1?=
 =?us-ascii?Q?gUeVikJKgJSA3g8Str86qQUe6Nm3k4SDNcfga8xGjpmzBd7owedY8zzLMjyN?=
 =?us-ascii?Q?FAG5QpyGHwiwQziSv5sCEopqH56Hr0mJhLD/WaFAVhj0ue3uKBFzqpZQqAxe?=
 =?us-ascii?Q?xgc0UT58T18oEJ1+8cIQHHJB7cFJdVN5vbfuSkGCtd9DXvcS0ctL2TRofC0l?=
 =?us-ascii?Q?afekDiKmavul0XM82i6qskg+nnKDC8DEsjkEwluMrt2swAzs+2h0DQAP0G7O?=
 =?us-ascii?Q?rfy97dEXaOvtRchP1URu0r33izhQ625hkvBPp0hZw0Ms7A/h4i0DxjL4hsxZ?=
 =?us-ascii?Q?gRoag3OnLgrO2jmX462jdO3Pct6jhGsz+aT9Ui3s8kDzaZKWCFzDbFBO37Cm?=
 =?us-ascii?Q?+w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	BhmjQvwxIAnLC0RcujaWHOU95rG3YtwA7Ob/4EhgJ77kvCqPMmFSDYnZEwT4Xe1f8/Q803wSCOd9hKnMhFqtSGnCQn+q41wB2m8daSQt7t8Neav1BTkxFj8Ka7lJTM7/uOGrMMUV9YwGE5jAl6C72o5FoKOc6ZI4vPDoAC6+5L+Wtmxvb7u1Fcvrv76NytsNQGY78BrADOb9cPfeWJsCvnnjgeINZGqE0pzN8Gcy5Yw714f9egxI8tuPub6vuAbIGKP4SVVN5QoYPyIGoFYZCj6X2Bv0M8W3YbQBEx2PuaOuqGieVOuNXLrt233Qd6x3jSQrbetQ2GQh7innMlqFacFU2+hzIdFK1Orj2WHOnC2rSeZ957fJ/xsw9R4kA/y5JO8akT4AU+pQG1NnLBRXE0YEO88TqX7TlbpRCfMydkquxUlxoU03de0Hwo3WzYlYSmtwohmOmi3Kn+GeXjDyH7IRppq+JbDUb/gvteUhinPW0PRW+yD7uesBRNyzdGZyVFR+qJV515LpOi6LOp0tzCqIxFUZ9q3nLljESIC8VsQsZuC0UzRSjFx1kzO0hthE0jxKJkBiB0XGbFfSuRzrdlTT40sntWBKpHJoiLG2gKo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc8a8a61-9506-49db-e569-08dde652cc29
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2025 16:49:04.4163
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7qoofzsFgYgh3L8BJCY6IRM74EAJL9VmM6QYqjZI2iqV9WEjrtQsqSES3l7rB8MQxCqY6qOTttAA1GDyKoGZ0Ulnu6D8CZIfTdPGZwgrPHY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6676
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-28_04,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 spamscore=0
 phishscore=0 bulkscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2508280140
X-Proofpoint-ORIG-GUID: 9O-sf2ReLjg2rIKrRw8D5-NG2RDW-m8M
X-Proofpoint-GUID: 9O-sf2ReLjg2rIKrRw8D5-NG2RDW-m8M
X-Authority-Analysis: v=2.4 cv=EcXIQOmC c=1 sm=1 tr=0 ts=68b0888a b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=pGLkceISAAAA:8 a=20KFwNOVAAAA:8
 a=yPCof4ZbAAAA:8 a=EXw04sjPN8ny6hS6K18A:9 a=CjuIK1q_8ugA:10 cc=ntf
 awl=host:12068
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAzMCBTYWx0ZWRfXxE0Gcrvu9ydx
 4LfTcDcy444N6G6bPLNPmOrCEsoCdorR11V6R2vSg5Emumn8uXKBdwbJfT2ySJtl+MG4Bqrepd1
 F0Nu66IhQD9b6OP7IKr6IA1NrTs2jVRADQSIDEsL4NCbnLlknh5ISsd5xoq6kw3NqvVTgH5JMSh
 Fwm2P+y9m0X/mYVjVHApBmFy4pv/h7BLz6YL9CpQ8sStpFoNJE7HlDl3RFeqHiY4nXPoOdraT1K
 NiVEGWVR7i0BaiEFvacb9fSnDVj6fogu1fMZMAHNLMTO+F2E9hD7N3emMJyMhccqJLfh33vHxHG
 PHE8nDIsLs0WaiGDckk8bj17cqdbpzVNzBJA8ziw0kMvtEh/qQ5F8n0wFjkQVIp58hz1pIHP870
 ZoflFjZYSf0AEGhl8wBRYLwA0zuuYg==

On Thu, Aug 28, 2025 at 12:01:23AM +0200, David Hildenbrand wrote:
> Within a folio/compound page, nth_page() is no longer required.
> Given that we call folio_test_partial_kmap()+kmap_local_page(), the code
> would already be problematic if the pages would span multiple folios.
>
> So let's just assume that all src pages belong to a single
> folio/compound page and can be iterated ordinarily. The dst page is
> currently always a single page, so we're not actually iterating
> anything.
>
> Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Pavel Begunkov <asml.silence@gmail.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>

On basis of src pages being within the same folio, LGTM, so:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

> ---
>  io_uring/zcrx.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
> index e5ff49f3425e0..18c12f4b56b6c 100644
> --- a/io_uring/zcrx.c
> +++ b/io_uring/zcrx.c
> @@ -975,9 +975,9 @@ static ssize_t io_copy_page(struct io_copy_cache *cc, struct page *src_page,
>
>  		if (folio_test_partial_kmap(page_folio(dst_page)) ||
>  		    folio_test_partial_kmap(page_folio(src_page))) {
> -			dst_page = nth_page(dst_page, dst_offset / PAGE_SIZE);
> +			dst_page += dst_offset / PAGE_SIZE;
>  			dst_offset = offset_in_page(dst_offset);
> -			src_page = nth_page(src_page, src_offset / PAGE_SIZE);
> +			src_page += src_offset / PAGE_SIZE;
>  			src_offset = offset_in_page(src_offset);
>  			n = min(PAGE_SIZE - src_offset, PAGE_SIZE - dst_offset);
>  			n = min(n, len);
> --
> 2.50.1
>

