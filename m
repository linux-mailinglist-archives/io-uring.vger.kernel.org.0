Return-Path: <io-uring+bounces-9428-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F00C3B3A9F3
	for <lists+io-uring@lfdr.de>; Thu, 28 Aug 2025 20:26:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AA581165C67
	for <lists+io-uring@lfdr.de>; Thu, 28 Aug 2025 18:26:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2AD562727E4;
	Thu, 28 Aug 2025 18:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="M2xCNDW/";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="HB4NuIDy"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6762E625;
	Thu, 28 Aug 2025 18:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756405566; cv=fail; b=pcanVbzJYIBUsR6n5iwWaYi5fbP1DE68NgQeo9IjhbaOqUe2jHs/6rTFWMvvOWDguDKx5Wfq8GuRcipRTuMJH6FZyPgVy50BNj61qMD8o/L/QkjCLKnuCUxuMtR0CxmhnetBsi06anAPg7m80LmBNtw/EyksOXZvIG2QoUoLcMk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756405566; c=relaxed/simple;
	bh=jhkJ8LFqZvRrkur3LskAmt1pynTn46WyySEAN5vmsYc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=tkIVJEeMOMXMv6yd2te03zSUEN0BdKyIGCWmI990rRvQegnJ6yicf3ze0h8OYeHSGTQNtknEKqZoas54YwMttR2r41XLgin2EeoW2KnbUHf1k+adnxkUUTi/0WZOVOOed0Vt/YbrGi0Nom6AXURGiOvfm26C1KsY36G1VRps3l0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=M2xCNDW/; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=HB4NuIDy; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57SHMqiH030390;
	Thu, 28 Aug 2025 18:25:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=5Wzj7I6omxHBLPSuBf
	5OyOAftJjkQzQ3dAldM03YV9Y=; b=M2xCNDW/taJvdwehAGunrmzjrqG4xboFyl
	fILtb8A5x5nm9Chbm6Ja061Ku2ARBArHrrePzes5F90FH4hpPMNJ+M7rx/S1cH0H
	lxQEtpohHrGAWn2BWyMstfCIEtaZvFs+ljFlv0lHyEbrV1YJEQPQdlSLawmL69AP
	DXWTwuIDsAiM88EMVa9sUEap4ZCvJV1CFHu6LU9MrpgBjFaksgZSMmKKmIHpTAYP
	J6J2qC6jFeETY/wLOjDXS+BuoBNh78bTztVuzZ9ys21Eft7AtBzcAv0QcYBy1XtA
	/aaag1A6miB8OxYkTjls5KF8zL0UZ/JAadoQgOim///HVpalCbNg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48q58s94mu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Aug 2025 18:25:28 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57SI1Wuh012167;
	Thu, 28 Aug 2025 18:25:27 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10on2066.outbound.protection.outlook.com [40.107.94.66])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48q43c7fke-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Aug 2025 18:25:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DIjqqBrvUMfVYKnDBxMYLTCloE9zainXgXIpx+hidF7+d5EXacyJS1gcJkEAbl+dZ9QGwmH1eLr4pzC3Fop9g+o3eFHFMqLQ5PY4hZ9NnR+Q7kWIbTeCvr8ZtpSA/wviR3oW8i6RopJN7N+AQn4tz7oVfFn55RUQ95YwOJmQUVREsr/VV6qpYvYtH+QFmgiS/CzY8ByqMNzZzAB/sV+/8v9H+1QrVFj07oaxsR9HF0JEe3wGQsDMd51RMjcvZoGEk0m3Nx6dClnBV2mrVJpZ6dusW/WC+ns9jK2uZDwpwCv2s1nw/N8flAw+BjRSYIQ5lSVkUu46uoutz0X4cbxlvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5Wzj7I6omxHBLPSuBf5OyOAftJjkQzQ3dAldM03YV9Y=;
 b=sNOhkrq/iriiSkhcfTY/2Fu4hIWt33a2dLmYQXIYbG/ilSmtc0sOgS/tjYFE2kkJFds/tWe1colInRUzWHrjrF9wFMdFZk95fHe4lTaK2kB15wJUrbtwx/gNtsi00PDPUvFQXydZV14YKRLG89n8RnROXOfs/aBQnvjsWOHTcJ5RBMznp74vYbJkDQuQOOTvWjeZIfJ7EJSbMf+LOnY9+NnqYgMACORn2wLu8/eS/QnR91ery6M47HiRmEDm15p4/qmYG/z/V7TsxZtt54y/TM4xH7KhVSKs//tZ9FRwX6y4C7HtA1bu3Qmdu7XNAlabnSaE3me3oIyJTPu+xwXWIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5Wzj7I6omxHBLPSuBf5OyOAftJjkQzQ3dAldM03YV9Y=;
 b=HB4NuIDynqUCttR0isfhfgWRLQCz+PmIzvyLmUG4E1hZA2RSD6rSvLVTRvOuH8Xzs2t8dazr5A4xgiXGYVy5U/gy5UXuVG/i2Q2K4uFUo6SFrZCrbTCUfpMF5jHJ9yHRdqg7U73jz3K9NLttI4WEIcFluZNC6tmjNTb6hws57aA=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SJ0PR10MB4621.namprd10.prod.outlook.com (2603:10b6:a03:2d1::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.16; Thu, 28 Aug
 2025 18:25:20 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9052.019; Thu, 28 Aug 2025
 18:25:20 +0000
Date: Thu, 28 Aug 2025 19:25:12 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, Alexander Potapenko <glider@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Brendan Jackman <jackmanb@google.com>,
        Christoph Lameter <cl@gentwo.org>, Dennis Zhou <dennis@kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, iommu@lists.linux.dev,
        io-uring@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>,
        Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>,
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
Subject: Re: [PATCH v1 36/36] mm: remove nth_page()
Message-ID: <18c6a175-507f-464c-b776-67d346863ddf@lucifer.local>
References: <20250827220141.262669-1-david@redhat.com>
 <20250827220141.262669-37-david@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250827220141.262669-37-david@redhat.com>
X-ClientProxiedBy: LO4P123CA0380.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18f::7) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SJ0PR10MB4621:EE_
X-MS-Office365-Filtering-Correlation-Id: 31387df9-81e8-401a-e121-08dde6603eed
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?1EJmPwV/EbfWaaoErR0D+4FYLifVyZqPVqz2aFCycHpsDWif73B9rcds74tK?=
 =?us-ascii?Q?BYQI7XzQpgw3UqtbG5XQ6zsn4o69Qw4OdtZ6SQCyfiplLw65Im4OaFb2L68j?=
 =?us-ascii?Q?5+NXpr7DPczCMwYOEN90Tls1zkIEJCVnkykrL1U8sTQXje1exGjXO9wf2d3n?=
 =?us-ascii?Q?MVaoqhalC4JHhlKkiTlCpOmlh5QR+WHYKefGdJxyh4hFxsP3V9C2PutC/6VO?=
 =?us-ascii?Q?1sMWFlWJDl+cAyX96M17bRuQC155DXa6HYGC8Nu2J8Oz0PbuE3go42rsC7ap?=
 =?us-ascii?Q?GL/VXqQ9qwaC0rgt/gZvpFbgPTvnGcYcKd2QdPW1rw7PLZ09CSMT2u1UkPbj?=
 =?us-ascii?Q?tHZiKRglYptfzz1SrUtxOjl+XdUZ8WWzBLWANkiHKybXKV9r+yrvIbZACYNd?=
 =?us-ascii?Q?oFTDNy7ILgC6B5Wd1zba6YyC3H5/UlVEIbUR3SndSfLD6a1j7zItY8QNeHyT?=
 =?us-ascii?Q?f3LyGu3cQHbinjKNwZfOxfNde+eliTfPoBtu2BvPkRb0qStlmV213Wq2xvp8?=
 =?us-ascii?Q?ukX3SDESibPGz53LXACyY+568dm0cUYUXQJFHbF+Bvf0p0wfjEPXb9CxhzJU?=
 =?us-ascii?Q?BEMRQrvmObIkCGEgmT1ersxVbTOEFiEWLHV4rsMAbh0VVXC2GJ3UXabhH6vU?=
 =?us-ascii?Q?LKeggWDQrxb23Gy6YLO35drVXM8GAgODM5VkbSTOm6tYNGEez982VNtLRdyD?=
 =?us-ascii?Q?zIF2uOorU2WJmqEoEAuvni6poXjJY86LzLUsd5TkLc5V0clYxX4Vn8ikN/Uz?=
 =?us-ascii?Q?EkUBrBv3B9rxom1sI0/raxy0LiO5nhty1uGd2Wh+Rsj0BM/Wp/iAfWmKG6s1?=
 =?us-ascii?Q?MHuJB8A4qHWULvzSRZzvbACbVmBk/zpjn/fQwbM3onI09N+EvkP009LBRwH4?=
 =?us-ascii?Q?lTO3ciDfi1X5gbFya/eda8GIRKH9FBEIdn3TsFSaAYNMbvjz6fpkBxHf0oy3?=
 =?us-ascii?Q?+/6LvMazE9rWImBwEGRa64JUsLpt0X5O3nLwhWHwb/cnwtnFOCfHf+4atnQy?=
 =?us-ascii?Q?rwptC/ZO1lAbTmBOxfrKXsanmkVO0CNE7maRXLvZhueIIMChwwISfr+0JvLZ?=
 =?us-ascii?Q?72vnRLZzQhLz7mBOdRhjeJQp2qv1w+MoC1nCQqtCcPMGZztlxGducSIeuiPn?=
 =?us-ascii?Q?uVSZC+KK3K/Dp4bKHYgCV+QTUBoOGlGcLH7wdybJFlb0Dkpc+9TAYp12O1jt?=
 =?us-ascii?Q?TR7ySNboqmcUgG0Dc1LOiCWjSdv4P74AOjYybC1vZz1XsVVUyLhB8/UupUt+?=
 =?us-ascii?Q?uL3D8JE/4D2ZbkdtX8nQITv+HtO98/tbbxLqsJ7ev+wwb8CKr4NWtynoVRQZ?=
 =?us-ascii?Q?tCpFd40SFGBtWRF3R3taaOX7uDRzothQsxL4Uo7weJuJSHZLodFuoiZkyS/0?=
 =?us-ascii?Q?96TzOMory52x3pxgpw/tikxz1byEKunysKqCBHhyyFAAnf0QsistDk6sBJHx?=
 =?us-ascii?Q?ZdSJv0rtiAo=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?1pLSc7vL82gALLDAkkRYwEJKqZJmghG+iymABWPDKcJaGqacLOiLSlPLWMyE?=
 =?us-ascii?Q?+0qDC8135Rmta+rp/UnQU6LVbZB1CSHDMiQ6jQtaoMZF4qpLc5iWTuJzHK9I?=
 =?us-ascii?Q?h+g6Ak+XBSTB29KpoyyX5zMpvuNhF/Od6iw6Ah8j573n6b5HAX4wUVfC837z?=
 =?us-ascii?Q?iVL9VwEnC1jiVVz1aRA1S9dgu02t9Y955Pn117sfztibPrBFCYOB3ghop/pa?=
 =?us-ascii?Q?AzeACYkHJjCPCMQj4+Fdth1/uxbfE+S4Di4Q+vl3iVyHRnjVJAJVY6fR2sjM?=
 =?us-ascii?Q?eQApaEMwqj0+AVrd0PKtyuvsiW28Lj8uFJX18VTFwxdspnBTu5X9i9gNZomS?=
 =?us-ascii?Q?lzG1z+a2CsN1VrVNQ3F2BZcb5X+hcqonDgE2CZRyCM4DWQqthjmY5P7dbKNm?=
 =?us-ascii?Q?YetavIOq3d6E2SVsjInfvp6lf4m+cnhtPQT7yYtPjwj/v0+VI4qW4uK1uBdU?=
 =?us-ascii?Q?dZ/a+YVBGpN8MXInDJNF33RZV8tgdYelE7vmAW8e/2MQrMAfUFcrV7JyNttY?=
 =?us-ascii?Q?svqEjuZBc+ynrRFLpWnQzTgsLhv5s7FmRjyiDw7/EV5CtD/OHKS+OROw9l4K?=
 =?us-ascii?Q?wQL7HDDwi+SQsnir3VoK3xRMNrRR4U7po56fliKDMnmOwZHXIm70d9OnMIuI?=
 =?us-ascii?Q?7g5eS/UltH4Bi80IoyJWLTFLkPxDq0nrRZTXHyhN+kX03j4qmozrgiRAxVBc?=
 =?us-ascii?Q?9CJvl8guKSZBMFyNxFo8ucOY1LqrhZXT2qsk1sGHNn9/8VF0UV9ZmMBzqYUc?=
 =?us-ascii?Q?aljfVLaUto/KEan3FJ4/T4G/bSWBXBxufDW3KN6kAnfBWmBWaslDzCk+DPpn?=
 =?us-ascii?Q?UgbFIF5ZsA1YouzI+FLTdEmYBKzEvR88jtXXekJLIx4Y1LEV7aVxj1gl6OXG?=
 =?us-ascii?Q?i0z3ZzQ1HqoLKOvVLZ6eF32ZSDyijyI2qraWfSXb62W2/6giNmJajyzNaXYh?=
 =?us-ascii?Q?iX8bQ5c+1tVJlF2gowozhiWKr4immpAnaEuXqNmP1vLif+3w8ksz71RUmO7L?=
 =?us-ascii?Q?cJlkKBjIsPfuZIBFuF3TKvGSEBhpt5/J9smcRXT87JmiDA/kIP8/1Wd2lVga?=
 =?us-ascii?Q?tM7Xb7YdHDhVMTxM7zv08dFtDKf6uVegRLIZAmalncOvbd3+woj65Vc9B0gP?=
 =?us-ascii?Q?PkDwKCsNPqaW/hB+EhMdYbY7WoUsytkpRnJMfsuQjwcrK5pEJW5vP9NubUYI?=
 =?us-ascii?Q?Y1nCxzaCioA0kWFKeuh0nYezjmjLsOX/sB99ODiOnbVwub912QaB6rmTniXG?=
 =?us-ascii?Q?LoHFO955jHkjH2EFXb0Ha1jLXH9jme1aNVH4A8Kf0jzZ3xdOM5LGdyjWrau1?=
 =?us-ascii?Q?aYV121BaQHrDbHkXRR87Ve09NmAKVVVHlLfnxt7uLcl5XsG5/t/0PF0/mH28?=
 =?us-ascii?Q?BTzIj+u8GJxFxhzOZ5aIWeSTCLLZRl2ssfgi2YSM9FiOwjuiwLTOMXQbNy0u?=
 =?us-ascii?Q?q+JU1BC3YpFyKtRF1QbQeWN/s3VqI0m29rSOqQwnENWbL5+5BKGMUdhapxGk?=
 =?us-ascii?Q?sIxybevKhk4ES9Fp7aMBxNc1osW7S+InLsZez7LMgBl+ZqHjtJU6BpV207Et?=
 =?us-ascii?Q?tpoUfz+d/UfNnYTr96fvdylb+tzNRcz3REn0Qhq+iWOuliJDHcgPmMmzpLeC?=
 =?us-ascii?Q?CQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	y+eEmb6IYTQM2uWwtJWs00QOxhFqJd4nJ5ZSNuRSPZFjIOanlVnUzJsG8Nyf6h0MN83hYx3Q+ewpeuAaDvLM/scIDnYFW+bGuF1ukkvQk01Eb3g6qzBLGr6TR9E4zsyHHVwxiLWusiYd7hPpb7k//Oj/v/o+J5vtfZ8SfdR1ARBcpPwvZV+1e6jH6MzEhZynGXalkTDMgNskNU7sf9VkofsJbfATxKWjomHsfd4hFF+8w85LejzVEYDBPShdRmKaIfn87/PiumPdJW67JQJikDZkB3AS3N+nq2xxk6pQkK1EeyqhPsy+MjO6Qvt+UqWUekzNTRtH0pqL9WIaH+fgyJgCg2PTPo6kdUHm9w1s4lM4tY+rkyO6mnTvhenjg6VJF0SmvyqEKyMyCoI0C7WDWoVkKvxeZ1DmXQrqcpmkE4yHEh6OwAs/TyRq8aozETfeat1gyXG/ysAY2xqyOv4LaTru8L3hncKSVA/oFQen1tIo6SxLiD/OXViFX5Lk5cFLq0JgMqOKDlq4qsENO5cksdhOLIHtQ+v6Aa14gRydkbJG6zzR9ePvJdBEmcl07efAFJwprdAiutXLzg6fbUy6dWctz1OD7jaA7hF43O/pYbY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31387df9-81e8-401a-e121-08dde6603eed
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2025 18:25:20.4366
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0O5qaH+do0+1IWmRXgKK5GoFj3OQET+hlp4IZ8kLgtYtMJbv080YLPP5WTVbQOg5QjK5pFVBZLaxk91iTwATfJYvG5zsTa3r4Okmzn6JkUo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4621
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-28_04,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 bulkscore=0
 adultscore=0 mlxlogscore=999 spamscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2508280154
X-Authority-Analysis: v=2.4 cv=J6mq7BnS c=1 sm=1 tr=0 ts=68b09f18 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8
 a=m2c6sf9u4xuizvxJlxgA:9 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12069
X-Proofpoint-GUID: 1AIOKZ7DiS7gajcwdpv0Ucz-0iIAbDNd
X-Proofpoint-ORIG-GUID: 1AIOKZ7DiS7gajcwdpv0Ucz-0iIAbDNd
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAyNyBTYWx0ZWRfX8c2JsYrZabso
 z4fEVpPiU6/wALxsXeQAWIB5TCOqMhaD/4QgO0GLe5rSsvBzdjUMCLAh3GuYtMm0OzM3wIXobgo
 ebhrX1TqO/dsbBbRJVIYnZZHNoodXIdTWTFEq7mlXqhD74wnmYmkQIT/3I/y9ZPyPO9GKvVlRTk
 zbVS+7Yo/PxoKZU/Suq2o8Q64xceWdQrwkXXY4Tkz5OUq9Zi2jmegTw3u8FhUmQfOyjto+eoKUi
 2HBQzM0L9bC/JkZhF4gQUb4wHJawMvzkrpML6ZokOe4mhK06D3cY0ZoYri1dh5WyvSGJb7oaB8z
 NU/elzeyiXLqQ+konRrfK8kusqz6LRuSqPOTEhbS2FocxiOMQ1J+8tYPuvLg1U6A8xMuB9D1rV2
 S0WOp4Yg14L8Ss43c6WfviVGa2FQMg==

On Thu, Aug 28, 2025 at 12:01:40AM +0200, David Hildenbrand wrote:
> Now that all users are gone, let's remove it.
>
> Signed-off-by: David Hildenbrand <david@redhat.com>

HAPPY DAYYS!!!!

Happy to have reached this bit, great work! :)

LGTM, so:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

> ---
>  include/linux/mm.h                   | 2 --
>  tools/testing/scatterlist/linux/mm.h | 1 -
>  2 files changed, 3 deletions(-)
>
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 2ca1eb2db63ec..b26ca8b2162d9 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -210,9 +210,7 @@ extern unsigned long sysctl_admin_reserve_kbytes;
>
>  #if defined(CONFIG_SPARSEMEM) && !defined(CONFIG_SPARSEMEM_VMEMMAP)
>  bool page_range_contiguous(const struct page *page, unsigned long nr_pages);
> -#define nth_page(page,n) pfn_to_page(page_to_pfn((page)) + (n))
>  #else
> -#define nth_page(page,n) ((page) + (n))
>  static inline bool page_range_contiguous(const struct page *page,
>  		unsigned long nr_pages)
>  {
> diff --git a/tools/testing/scatterlist/linux/mm.h b/tools/testing/scatterlist/linux/mm.h
> index 5bd9e6e806254..121ae78d6e885 100644
> --- a/tools/testing/scatterlist/linux/mm.h
> +++ b/tools/testing/scatterlist/linux/mm.h
> @@ -51,7 +51,6 @@ static inline unsigned long page_to_phys(struct page *page)
>
>  #define page_to_pfn(page) ((unsigned long)(page) / PAGE_SIZE)
>  #define pfn_to_page(pfn) (void *)((pfn) * PAGE_SIZE)
> -#define nth_page(page,n) pfn_to_page(page_to_pfn((page)) + (n))
>
>  #define __min(t1, t2, min1, min2, x, y) ({              \
>  	t1 min1 = (x);                                  \
> --
> 2.50.1
>

