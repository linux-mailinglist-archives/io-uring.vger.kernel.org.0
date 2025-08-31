Return-Path: <io-uring+bounces-9486-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1627DB3D06D
	for <lists+io-uring@lfdr.de>; Sun, 31 Aug 2025 03:04:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C76F8164385
	for <lists+io-uring@lfdr.de>; Sun, 31 Aug 2025 01:04:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E57841494C3;
	Sun, 31 Aug 2025 01:04:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dCMaUt51";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="MMOGPjXP"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33024C2C9;
	Sun, 31 Aug 2025 01:04:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756602292; cv=fail; b=RrRhWNsEe7TNsuRSKGFMo0/bWkhyVF/2XzO5MRkn35M9xoUfV9169DS/wfqxy3zGP9sm5FtaRe/ygjdK2Ypm1bYFMq6Je2swXzvChFV4Eycuvp7EbX6ok1psZo/qEI7h1fKKz/NuUiNfZHJlktCH/NHVjrLubOnvqsVGTBDMr3U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756602292; c=relaxed/simple;
	bh=RSBu7ja5FFPK9+l1sV/efxFLOn+HydmJJ/ApFqAi89g=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=Z1mwOoBsM7SdUwChqBkjRkGuzmZ6I2zPJA27xtKLy/d6g/U7eYro+5nY2t9IzaSo15hYSpVkaA37B6AnPcYOx3T9lQKPuvzqjLIMs1H3HLaRZOADNI68MABh5XTcLcszYRsa8+M+2rkBKwVW6p+uT7GKJ5IVJ2iUYVCq143I5DY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=dCMaUt51; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=MMOGPjXP; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57V0oq1u020715;
	Sun, 31 Aug 2025 01:03:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=ih+9mrJHIMYhOBGLjR
	SUtXFUe62l3IoPjGyIQeApiQg=; b=dCMaUt51Vl++5+wA0KMmUqdwRAp0N6XX/l
	irwkzvJ4ZFm1H/R1DHVRs+qW58jLPF3MwSP82NbgU0HZHenAFePpUtbWg69PuErY
	03h9aLVoV0Qm+dxk45yHh61nhYNKpHkeIZ4YNevMOu1Yoy2kdBXx4Y44kxF91f2A
	UpmPXDZwi4ZnaeGb/LA+/1m6yvp091yn0bkExWYQ/O19NQ2HOH2kr8ryT2ETh1gh
	ikfWTa2iKBNgRGBs8Q1lW15npEzAOhQKhLLqIHNsvIj7627xFwllz/CppwZpWGLV
	vYleeCtqlHOAV99iHkjen2ouDYLI2Ciceeo1aBmWBQm6TBEXsUgw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48ushvrkjt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 31 Aug 2025 01:03:57 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57UJMDWl032178;
	Sun, 31 Aug 2025 01:03:56 GMT
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012016.outbound.protection.outlook.com [52.101.48.16])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrd9jqw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 31 Aug 2025 01:03:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=k5lKH5oX129fkKRbMCLAPvLYg06VTAKTjoNFKW8u2hcrqWEsnSBPPb/dVNWt4wJwcqpOMzqWmKADRIlL4eqtZHjKOu+ibPDlxO5rykxC6xjoMUakMVlWG1395TnqE6Yk2NXhehPSZHpfxf10hVI7UuhDsS4b9MQGxEI2A45xIzynRcSVIlDf8aGeMyM913GaIThAyf6bGr3IGoQ26mvqVFAJyXYKxoWKWYDCqr3fcVd3a+1SbUkNd4hvc/VyH+5kPOH/HDdRLyPR9W9VmRLrNg+u7l3AIdGxv6+cfWNyhHQ16EHuRuEJH0hGmHuDoO5hkamt2NminG1KbOTYYCHyKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ih+9mrJHIMYhOBGLjRSUtXFUe62l3IoPjGyIQeApiQg=;
 b=tFJC9/rW+yDkl3OSlpfdPSXUrUb8iaqxjR0cYmhGGE8DrU0lP/80iWVBlzOT8IN9k27tZSlalNKXGw4c7BqpyfC/v5IJ765NSj4Pnx1gHsx//WxaN6pQnTa26ixHQyOnEwMJfxuFDoabPZHfexpMTzTNDAcCpN0NCsj0agkBYsGWJO3JZS6uiOxyjJ4fEPck0Jh1Pgw/tiX0nHJzaXuDS7A7ts4LpJImDxu1NvD80W6BT5E80sJresxK9YLlY5GohbmUnj+fVgwnxRH6rhDOEBJhvPTKJVxMZWa6B6pXt/vXAw1Ftf1TREH8/zYVawPl2Wk215KkIjLWg0mZSs7G2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ih+9mrJHIMYhOBGLjRSUtXFUe62l3IoPjGyIQeApiQg=;
 b=MMOGPjXPWohVBWxeeejoqnDDtUg7o56iJSIjG90K60HaRKoqtja4AsirLZZL7JrgDh+8i7qHbqqyBCt3NJ55h81GyhPu7iG73JyPG5AOSK9htZ2n3Y1+5/N1nQWJJ/HWPETIzGhW1FBv8Jw5TPDos+9aYJekhtYL8jVjTwPDsac=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SN7PR10MB6450.namprd10.prod.outlook.com (2603:10b6:806:2a1::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.25; Sun, 31 Aug
 2025 01:03:52 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9073.021; Sun, 31 Aug 2025
 01:03:47 +0000
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin
 K. Petersen" <martin.petersen@oracle.com>,
        Alexander Potapenko
 <glider@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Brendan
 Jackman <jackmanb@google.com>,
        Christoph Lameter <cl@gentwo.org>, Dennis
 Zhou <dennis@kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, iommu@lists.linux.dev,
        io-uring@vger.kernel.org, Jason Gunthorpe
 <jgg@nvidia.com>,
        Jens Axboe <axboe@kernel.dk>, Johannes Weiner
 <hannes@cmpxchg.org>,
        John Hubbard <jhubbard@nvidia.com>, kasan-dev@googlegroups.com,
        kvm@vger.kernel.org, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>,
        Linus Torvalds
 <torvalds@linux-foundation.org>,
        linux-arm-kernel@axis.com, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-mm@kvack.org,
        linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        Lorenzo Stoakes
 <lorenzo.stoakes@oracle.com>,
        Marco Elver <elver@google.com>,
        Marek
 Szyprowski <m.szyprowski@samsung.com>,
        Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
        Muchun Song <muchun.song@linux.dev>, netdev@vger.kernel.org,
        Oscar Salvador <osalvador@suse.de>, Peter Xu
 <peterx@redhat.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Suren
 Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
        virtualization@lists.linux.dev, Vlastimil Babka <vbabka@suse.cz>,
        wireguard@lists.zx2c4.com, x86@kernel.org, Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH v1 29/36] scsi: scsi_lib: drop nth_page() usage within
 SG entry
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250827220141.262669-30-david@redhat.com> (David Hildenbrand's
	message of "Thu, 28 Aug 2025 00:01:33 +0200")
Organization: Oracle Corporation
Message-ID: <yq1v7m4fgks.fsf@ca-mkp.ca.oracle.com>
References: <20250827220141.262669-1-david@redhat.com>
	<20250827220141.262669-30-david@redhat.com>
Date: Sat, 30 Aug 2025 21:03:45 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQBPR0101CA0169.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:f::12) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SN7PR10MB6450:EE_
X-MS-Office365-Filtering-Correlation-Id: 81129496-9c7a-4417-60bf-08dde82a3d4b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?9TTrDd4C44ozzbCuQphKSA0nNvFjmAom0ZPQ8wWkKS7wbHdNiVK9IxMHq9gg?=
 =?us-ascii?Q?Fpoeqj+WJQ7X1rSpHHK6zOu4oryJZJKr+LVuQ48edScTRhH4eSBmSfwGf+GA?=
 =?us-ascii?Q?36/WZhnqcJU39RDr635oTemicQSYVHcC1vKTCmV/nVYLd3Jml+xweesMxhRQ?=
 =?us-ascii?Q?aQcEnNkpHpO1UQPWw+f5jpI8sKLOMsd3Tw9DHY+AB0TSRixJYI81ErurrXtk?=
 =?us-ascii?Q?BoNFmTZ+fqzTgNAPkDuyhaplT1HYraQaqrsmHm0hd1TIsy2GlsJT0zpv8D0c?=
 =?us-ascii?Q?JLFP6SA8cE3bERthz4YKcMWz/dPXtTVQfYkm/p5IaHM9vJdBdSMichQukMOa?=
 =?us-ascii?Q?h+KvE2LoOFODJtWSUsv78uRCyE/Okqh36vgH4T7XzwVU2v7OCz4Rm3TxGfLX?=
 =?us-ascii?Q?awH/DszopgR4O6ORKmmL3jedg1L1OCn2KY5lOZoGJINRRx7DKPLwUwPv7A/g?=
 =?us-ascii?Q?6p/+KhlycVpXua3m1vx5DAh/Tz3vfP6vde8aI17AeBLUoL3M48s/Owrg85Pu?=
 =?us-ascii?Q?fY3L7gsERWcZaYZF0lMkePmtPMYvHZursAeTg/2qq9qdKulE8X52U3a/pdAW?=
 =?us-ascii?Q?PwBzpAE/QTd5GNn41VM1Ua9e0frHY8cFVgPYYMu98acPyKyRQT5J3MKZmyMC?=
 =?us-ascii?Q?QA/dRpKz9oG0C0LehPWexPUuYpSQFlluLbGZibIHZ5Nw1gMcvyQPpUSLNtn5?=
 =?us-ascii?Q?ETYPg8yK6WHQ5UB1oHeubddGwMdYK+0b92lLFekCeB/hfWR3gnOuDr/eaW8/?=
 =?us-ascii?Q?YCRmuciNVRbbm/D55cN3wfrtGWFLykmNOuw4GLqpNKQue5hrmuVFEo/XjWRb?=
 =?us-ascii?Q?WCwny/vqbJYCYFOTVp0mOiG4UKnNmnNFk9ykFC77gtMqREa3hSYwtsOoq9G8?=
 =?us-ascii?Q?AIZ5v0yu94yHsmmiRaj89Law0IJEux/vjgfmSyUXZfF/TvEbqAusi2a0v1an?=
 =?us-ascii?Q?X75Hue34m5oNMul+FS0GC58AOehq+LFRAfhgQ2ffjUTfJtFwSt/eNJgeQ9+1?=
 =?us-ascii?Q?1524K4bauVa7vELidjXs9WH8bfoonz042uwfjh1Be9TAlRJ4cGIXU0bXojGN?=
 =?us-ascii?Q?ySoT1Lwa/YbgWeKYghjt0R5c4CRbX3JpE8aPZLeozDS/vefVNolyWmNUh3p2?=
 =?us-ascii?Q?45Kg90sJQaR2zboTHMFeqkj8ioHwdSVel8OJ3F0Rkh/+TPPgWEwfQWXu5p8Y?=
 =?us-ascii?Q?vQstEDNT0keGklC375TNwRAOPd/nJOifTrBNfmJz8OnhVfcVNLVuv0SAGz4S?=
 =?us-ascii?Q?tG0zA0U+m3GOrDyoWHbJpkIp1dCTZpC36DpfzLXFOP1k2ownnbrI5afgUXro?=
 =?us-ascii?Q?fwdbPqS0RD+LIvCLcMK6uVOvL4X0nfpZzxR9vDoBkVCJ6GjI6QHdEYXvEf4y?=
 =?us-ascii?Q?8JPUqOC/vRacUWRmcHUo37cUvUttRemrjCeFgp7WoDNsDkQL10smgfi1ra1c?=
 =?us-ascii?Q?0blZwYiFJLs=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?9cLZAXA9tqSCDRHa/ndHBD4rA86tyJzgTeaHEn11sx0+5wyW0hZqvWsOQDdC?=
 =?us-ascii?Q?mVfsRoPDH7eLUYV4/wUiDrLIYMTNfL6EEycGfcxUgyd5/Hnyu+r13HjCCdrs?=
 =?us-ascii?Q?XbjATNTYUo7wusO0tUa5lIVXBmTz+DNiVnWuBvb9HQBci7Ryo6E+mEngw341?=
 =?us-ascii?Q?7bK6rtqZb2gLSFIGAjIN0gBAcvpdJk0NALGn/+iDIBK7M2TeSN6bLd0Vw/Mz?=
 =?us-ascii?Q?UIQNxx/z4DspEhgl7fLFV9eRw6X5nFINjvhGbIEnhviScwBMWB/IjS2uYyuM?=
 =?us-ascii?Q?Zpq6KyNW5FmkS/VpmoqhT6XYRXZMa5iljA98gmtEa/T/oLgxKUnexnrGlM8k?=
 =?us-ascii?Q?ZnOakTleuGrxkFA7RfAQxg6zwSidnT3q2HWXni/MTX3QyAi7kycgxFq1Dc3e?=
 =?us-ascii?Q?BueNCJyfvPF8cPN8VQM3nID63SGT4+7DgTh4WIXaex0Q9jpXNDnD0R79jy4M?=
 =?us-ascii?Q?eiRNIjmYz7vTQraJMTnBroliHVAvsR1wd7ITecPTOEDYrRXpg0ga0pndukBa?=
 =?us-ascii?Q?Dlvc7O2fcPORPnjhMF5YlYqdf43BcaMxoyo+nfk7M5AyuR3T5o2/26byr2ut?=
 =?us-ascii?Q?L4k/xfqFdDqw6YOYfH5J1YIGeczsoyAiZgYems6L/UlPKf6aFHYLvn1DO4hG?=
 =?us-ascii?Q?63gkCtj1GyyPtBqafCZLw0JCOC3TzmqpH5ovTwdLmkCdI2abiB6GtHe6xZdl?=
 =?us-ascii?Q?TMsU2vBP++bgSmJs2TJaXA7LqVZQ3C8ACLt6qrL9JYwq40ETGmOEI9Od71Di?=
 =?us-ascii?Q?KA0wuseO9vR8dEBZmQL5fPqM/ofCg37xG38w9Kth4TRQcZSgEmfCsJmWPu2L?=
 =?us-ascii?Q?wSZNydN9m97Iw93cdBfrU+crlzHUPMwh94tcs6sQzVvLng6jblEMSqVX9xq7?=
 =?us-ascii?Q?vUdS1QLkVzyx3F+swh5+VqonB5OGEKtkR0VRfl2j569LGEVgX/uRIPl2gGUm?=
 =?us-ascii?Q?80GffgNa26mIQxigXF4sEFawxBw2B2CC3kQmjxggPuSJBjh/ozgNG8GoMISO?=
 =?us-ascii?Q?MR7oVfV+deSy+XGLpaiArIog0mlPwflIVdUPkrlsRwP/MX8for+A6VmDqYMu?=
 =?us-ascii?Q?e6BIhK3EK2h1+gEprFIM7Hxjil7lj+O6oeqADeQ5xD5lvfl6Rsy3SwNYGP6k?=
 =?us-ascii?Q?mqInnFkKFax70Awo790F1lsK5lFtyvK6PTD/IK1M1IZA/3kF2VSkS16X9lNI?=
 =?us-ascii?Q?zvT3MWOELuyebZ3O4aWQXkaIl+Z4ovzS/tLhRi69Q9kIMZllrfoKnvM3sL+D?=
 =?us-ascii?Q?9cbdxwlKSBZ3VXdHxK5hsyewWy4La2TV55I945REfEMfvgWIXDXZfdQPtZW6?=
 =?us-ascii?Q?hV+3y3zo82HzRaU8v2xia45LxSBu40xPFpRPvMD49M2/+gLwJRs3iqxpiD29?=
 =?us-ascii?Q?NkNvZG5BOxX2zi8jPYEVFk1id696Ouuet+EohLGOnK6ZWS3JIy3Lh1WSDCTt?=
 =?us-ascii?Q?pin3/17BRC5tu57/2W+wGutWYloVusnb+t6oE8C1s3DSf2AHHoF4acwi+fCK?=
 =?us-ascii?Q?h03p3W/2qrTbUbYWJfDslXuEsPOex/Q01aL3n1Ured1si1M+QB1/3of6AnXr?=
 =?us-ascii?Q?03kJ689zMT7hmZjFYcSG8AwMa/dc41O1FCaQ1ry9va21vITE3C2GTWUcibvz?=
 =?us-ascii?Q?Gw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	l4dv9I+JsdCJh9aEF7XzwM45RB5EzPo7o/zMAyugdvLjnhkGkwEHciz/7+vPpO8W1ZareqEWsXkUzDqudoKXD9r/+PsNwnXkfjbV+Z+hiRZn+W532NmSBnlQBeSYmivC6uzUrlUsVD1EQrYo2r4NCN3kbyLcmQI79Z3OiI/PKPNhIneJB1RGgRDsr8wagPc8i0AIhLib2LY7EPRpEtmCOLb/hj0R/H7tj+vPVSBb0SC/V5jrzJiqWX04SOSgofaarff1yaaU6Y/eiCyYV1n5vrdagkF8c9DXSJYU/LgqWMIDb1VK+5HsLRNbfK3c236ZtwfjRuR/boBumznQJ+4l7Cv9Mjp4GMKdKHVJw5lyYEWm3efWJ/+n/moKpivNWWv85Cb8+nhXHZuieZ8AfbrOcpgkQ2DMIl/tyTCcnSjf0yiftgCoN16xEKOUoTgT4g1mmSxYPaCQXnJ583ZRas+rkgKbIQxCGQr6//MYLrnt/geaYMUFQ84ltoxz59UzYBRQBzhCrJueFWW8UvUgGzrtPGD4/pYUsDcamgVXnN3JqqY2EPt30evTFl0QVhFr3EDEPBlLlF7jxRmFsu4WActVPVHxhd0AfN1WqWxirTdiFg4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81129496-9c7a-4417-60bf-08dde82a3d4b
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2025 01:03:47.2677
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EvLg1VX0u+uEcUFxmHgxslIMXMPXhhbpgzeUWx6rSqp9308e96YRefBmFApOOsMW8JL/h3EPONKEcFGGtRcM1XenklPAILbHKGqhJIcqpeA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6450
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-30_10,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 suspectscore=0 malwarescore=0 spamscore=0 mlxscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2508310009
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODMwMDAzMiBTYWx0ZWRfX9/byndKv5b/7
 o5oK++AxxGN1iHL1eYmNnunLyJ5G+J4V45deG/aMv1lUK2CdR5bU6N9/UoaHamQELwbZK/pieJ8
 KUaF/UOgcIp7+0XDYaNO60pq4HvKpY9p3maN17xrAoEK0+JxFfytg3ecIQ+MwVxTL73iQMTLU3Y
 jtdrPkkmluvnfl3PUDKQyPhf8Z0mz342xU47wLDLUuePKCs3attrKPo0ka5AzgTkGrRnOddMpUm
 OqMHn97xh8MT7jdfQEHApHvwbQ8NoyoETJtmH1O9hMImNnh/YQtJgvp61qYjvIxGy+4w902DCe2
 8d+1+qyjtNrUT77g92Iw5oI9X2luhLPBQ6goyvh35nnqdIpsX7Dv+C7/jWZdv+FkxSe07tU3cdM
 sTXZRLnTiGsMLZ2+nTRqfK5M77TZRA==
X-Authority-Analysis: v=2.4 cv=fZaty1QF c=1 sm=1 tr=0 ts=68b39f7d b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=2OwXVqhp2XgA:10
 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=5bH7z0BLeiDiQMqUfeQA:9 a=MTAcVbZMd_8A:10
 cc=ntf awl=host:12069
X-Proofpoint-ORIG-GUID: 9p9PHRMzohc9Y04qpUjtV87HOIWlw7x9
X-Proofpoint-GUID: 9p9PHRMzohc9Y04qpUjtV87HOIWlw7x9


David,

> It's no longer required to use nth_page() when iterating pages within a
> single SG entry, so let's drop the nth_page() usage.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen

