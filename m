Return-Path: <io-uring+bounces-9406-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B726DB3A4CA
	for <lists+io-uring@lfdr.de>; Thu, 28 Aug 2025 17:45:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5516C7A5677
	for <lists+io-uring@lfdr.de>; Thu, 28 Aug 2025 15:43:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CAF01C5499;
	Thu, 28 Aug 2025 15:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TJ1nvdR8";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="VMNn8kP+"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92962625;
	Thu, 28 Aug 2025 15:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756395893; cv=fail; b=GCuvbX0tLu/qIehSRozE41bGa9UNN9dVhhfYrJY7AxYsIGx2LmW3pfYi8/eiadcEpNbr2fw3guZIxAZkZj/4wZTMFP4fkIlGlAmlMjEltcZlsutmHCx5Vwb4roL6vSpZ9VpVmtV0Gqmm4sWmk5rmaTZmK2ORUCN5MlQdEYbdZ48=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756395893; c=relaxed/simple;
	bh=6ZGwv9aJphVIQTAskkXbiIK4FxB+9Zc4sNEKPOWlty4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=AUh9c0v290j+e+XkOhvj7FZU3hdiG3+Ds4lPCpJa3hwqVrq3OAuSaqIAoWcZOnrQgv8Lk/4vhpdsQh1UpiKVg/vQxAydc80XvfzrrklaOg0XgQvbhmztosDOqVkcCy4c5xbmGogpNYtFt0rQFzit7aB3DxLxzLjxR/OmF0QpoCo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=TJ1nvdR8; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=VMNn8kP+; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57SEMxt5029591;
	Thu, 28 Aug 2025 15:44:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=DHwVa/lVACCrZEaOy+
	hxxXoimWg8nh1PzsZ7tjd5Fbk=; b=TJ1nvdR8oyccOziVQIxbQ2z3qZQu4v3tjx
	/RznoEf/tRdh+FAQfQ76KC7WD6MtOs/Y7STpJlPXbOSfmC4OVQ0oS/pgaoxbD1Il
	Vk7RY4YArRos7Pd3lCkk9itvfoNbeGWmOe/dDdGVoHfkQuZ1MnJtMpCvo9GJ73+H
	4wwWI/DN9qmhbm+20j4e2DhjAtUXEDleMqNA8Dv2NnI1vtJjyeJuXmaPemh+aE0j
	VABmiUmUQ24RA3em1XIdZz9QvPe/0x9f+j0BhcnK7uCVUcH8y2IbCNoHnINvIZRb
	itgAQ0CM5QzqPemZQIi7Nehw3aAmMGhRHPwcSaiJnfQA6/vLXqMQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48q5pt8yt9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Aug 2025 15:44:12 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57SEGDMH012325;
	Thu, 28 Aug 2025 15:44:11 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02on2063.outbound.protection.outlook.com [40.107.95.63])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48q43c11ep-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Aug 2025 15:44:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MjGULiD/pca6V0uT1lfAaA0/NSi1qO/oIb8xomuKAwlKVFSeSFmrFuWiu8wg+mQLX4ZkJ4yAO0jfbh8L9PLT7BvKt8HVJYnjOnGbTpx9BfnKmj62hjAjilFqJijq+/nEjcPzFUIor42eZs4qxHjU1rTkGSvigRpjukrq7aqh3y6kN0Q74wQaoYsbcvxsPeD1p3vvPKZ9BaSBKO3hAVzYaXGuKCR1TsNuFZ/xAMeX6k+Z0fETsV5l+YPHTkU0dzpQIjqzYoSBzZJaXUIgey6Izu7d8XaIDlOh3tOj2dpbLFwg5b5UmQYvyJ9Fo4Hl5Nyr5s0eBgck3Kg2k3o8W0E+hQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DHwVa/lVACCrZEaOy+hxxXoimWg8nh1PzsZ7tjd5Fbk=;
 b=x4kmXWwYNJCxtMCISYeaZXmNqOxQtF9CNofW2c7/H6asvt1LAU/565Xam+Tw9cch4i4Vw2kC2YoMb98r6FBdhtgn7ndwLsUwTTBRu3LGlAqECa/0/rH9sf0YCf89c6EDoMgp6XzDpnUf6GHSRZBqIlUADI0f/QnsJbqOx19Aj8vqleO2kFmZCO9VPVGs2zwxoekm4fN44YCdK7bVNMMaGRXk54gZWa8I9XmBXcbIj5rJIB1yrfu+2kYQjY+32Lsm36bHzm2xU0xvN0kMrwJn70WGIFGdSGG/1vPFFge8znPSVOxp/TN0DhAV+1+swezWODJt/btIOZot9MIfngVSdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DHwVa/lVACCrZEaOy+hxxXoimWg8nh1PzsZ7tjd5Fbk=;
 b=VMNn8kP+wxVpAGmXCwsOnxrCepPVI2Qp6ymiyID/nftPKqQFBKyueINi+6vWWXqVQRglL7PJ2L4fF79Y08UtPkrweeL14lTDMKfX3angzpd6oFENws+nSYBxwEKGjVTgV3KU7M2CSwUVcfDUvbL08rHBJHdT98cSKRWuSdWaVXE=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by IA1PR10MB5921.namprd10.prod.outlook.com (2603:10b6:208:3d7::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.13; Thu, 28 Aug
 2025 15:44:03 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9052.019; Thu, 28 Aug 2025
 15:44:03 +0000
Date: Thu, 28 Aug 2025 16:43:55 +0100
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
Subject: Re: [PATCH v1 14/36] mm/mm/percpu-km: drop nth_page() usage within
 single allocation
Message-ID: <2ee63b0d-f5d8-41ee-ae7a-0e917638cebc@lucifer.local>
References: <20250827220141.262669-1-david@redhat.com>
 <20250827220141.262669-15-david@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250827220141.262669-15-david@redhat.com>
X-ClientProxiedBy: LO2P265CA0357.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:d::33) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|IA1PR10MB5921:EE_
X-MS-Office365-Filtering-Correlation-Id: 5beafdb5-1229-4ba6-3685-08dde649b710
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?vnwzyE9PPSU8rAInLuQl0dYN0TQOuu112vJi44oLYEYtvwuUNS7t80lOOB7B?=
 =?us-ascii?Q?afwCGgaBZHkgn7dTivQrrWFM119a/FUS8kl2QvkxzdUJz45Yh2fkjUUB4L+n?=
 =?us-ascii?Q?mgNEH3+vSbocZdX01L00K+1bvlWz7W3Qk9Gafp0JSPNhoayIr49EQQF85Vdy?=
 =?us-ascii?Q?AhJk4hwY1ighdmv2uA1PqQe4Hd9VJIRWKjykysgcH8pK+Z+GlGW+avE8WkJz?=
 =?us-ascii?Q?FGC/WVjMA1zX5XraAXvQUt+wj5P65il0md26xrM4KvBMha1il2uhO2WOks6J?=
 =?us-ascii?Q?VqzJ6irlmyjs15DqufGXHlE7ZX6oiQ5mcw4+IUpOm8npEqEUihyTB/uMH+bL?=
 =?us-ascii?Q?aUWL0rbr1SlL8NJxrvLrTEtvYMBR0DoyEGhpe00hyD+Al3jXeUPueI7cWgt3?=
 =?us-ascii?Q?Ennn0Ya5KXsQCqOoB/x79ypEKMHDnUlC9AUfvKOZ3rX+PTeb9cC15R0hFqj3?=
 =?us-ascii?Q?QVlApBCIBCUP2BGlPNbKvWPFp6G7V9jk0EHB3ZsuYy3a+7GJ8Q5vr5P1GkFN?=
 =?us-ascii?Q?Ooqidjwjtm97xrgRlwI1j3AEZtImKeTTCM/FCUJzJ10x8ZEKorJWPmVG6STe?=
 =?us-ascii?Q?u+tf0H2xGuHRGfa5XHeee58WJjWN+C9PaEVOy6DKViMI+K7DW5cNo65EOP8n?=
 =?us-ascii?Q?U4mteCgd9WNDzJ8U3DjDY7741TrC0Gi4WNQK0GdDLXhgzjnhZMphCyNSOYkE?=
 =?us-ascii?Q?SeQj4BrsBqTEisourm3Nf694CQJL8GgMil4goaqOrf+0a96JAtKTl2VgHUGQ?=
 =?us-ascii?Q?Rd4sYEXO+VoS+4qNISt6nHtR1Z7+tj9w8PRbUOu+by6ZpSG7v/xOCIX2GTN/?=
 =?us-ascii?Q?W0h3urSOH3MsnjchtxpY7ekc0J5WS7jRD6oL7TLxgDm4xcFd2CUqgoV3dSz6?=
 =?us-ascii?Q?WWzWY/ZhI4AQoAEPzFvBTIObx3p96+ZFsZqEx1Hd93BRjBVlf/QYxReP+fKZ?=
 =?us-ascii?Q?7Sz8XDW9ww4DqMlMBJGF1kXe0iEmf1FTVQ4W4SKy/X1RqlyP6l0NmHx1UzPp?=
 =?us-ascii?Q?N9HgQgGYAhwTi+5fMRVA46ZhDf2TfzDUtT86KzSRaDjwdFCzjbOyWrBrqt3F?=
 =?us-ascii?Q?v+VnTWQrBPDny/pRr5qvPFuekpYfu/teuiRiGVONjO4QaS1abf9w8Y4uPmKZ?=
 =?us-ascii?Q?Yuo4klYo9nqCrw40Y80AhbZNQ7SJ60/btJ7yS5uH7laZqypMbffeYYWLWmoJ?=
 =?us-ascii?Q?X3+8NnJlkxvo+JCldrHW0CSglmQHTIrxciOrgk7LfriqSYppH1U3FrFg9HdC?=
 =?us-ascii?Q?sKXrVyWX2Zd31qOOCTxAKfFrcB/dKyPNvDwm2PJ3Vh6MFdo9pEiq5w0Ypino?=
 =?us-ascii?Q?qtrWlGSHmFmFSYj5Cu2/Tmp6MXQ2Q3iA+B9OSt8LCbdMX6w35CVI9fPkluNh?=
 =?us-ascii?Q?LjK+O8AO3dU4xNNEdSxEJW+6smFzUGp5sJ77xcKPzOqf4rc2BwomPcBO3wca?=
 =?us-ascii?Q?bp1peVuPDME=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Mpv7KamN2euzudnwsqsI+jFV2e7lUffC+17j+Co0LkVnsdM03glaWmQWuKZ9?=
 =?us-ascii?Q?wn/s36YVCdsQww5VhYUIahMXv8eGRmCzBawzmcVB0VjTNja64uaZgGbO9h7F?=
 =?us-ascii?Q?ID0vifbH335s/MyGY2YCMG0a8CHR1uGpifcznkyx0akYEdkXH/OtuyJweFCR?=
 =?us-ascii?Q?rEKrdX2C6o3mSVG7SUjNl8J/UuTPmX+OLjYqIgfKVdWwzKESr9QOUF0qJFwW?=
 =?us-ascii?Q?a37MHiCPVQEXOX9XM0JwLJiIOWU83/ZLUvk78WP22WlfTMKYURsxa0cw98Aj?=
 =?us-ascii?Q?i4aMVyEndEGK4Sq3NPKg4eG1+ic01KTQ3Epmi5ZKoHzHwT4EKHWUVsnqlwmG?=
 =?us-ascii?Q?2EGJzkVnA9TSDVxTmCMnCuLe0xlTz1l4oXUqUKVIXljq8c78lYwzhoYQMghX?=
 =?us-ascii?Q?wJctscVvDqSaSFsUbH6HDWjwbSEPE2+L7rIkyKWkdO1AH2IarP0kP9YyUmTy?=
 =?us-ascii?Q?wyfTiIOZmbekKFm7VSfskJoJqZBbPV5eqK1j1DRAw40x4YoFLxN4EqZXHM2n?=
 =?us-ascii?Q?Gg2zW4dHStTQnQILrpZwDDWHSDFO31DaN3U9ej0Gk5p8h4f73G1Bch5Su6YA?=
 =?us-ascii?Q?wfI2R5PROFTXsqbD2gVTauFTRDb72H6gH9QOUruOBjdby6BDf6qKHUDrL+eA?=
 =?us-ascii?Q?9F9RgeaORhYmElTZT37caSIPem0wTRPVJL2jJeGgaM3EMMEUmFkbArWmCF4K?=
 =?us-ascii?Q?9VDl9ECpsmGCIzG+vuVnbJ3TDMVgatO5n3VktXw7iV4r6Q+xa3oO5VpPZ8us?=
 =?us-ascii?Q?qEdtL5cMtD2QUSujkQWZx6jz3Utuzn6amph4sENV/x94DN1kUB7cbvVJCsFU?=
 =?us-ascii?Q?Ss5Qc19xDTsebd5H7H1qo7pmhPw8vcWoBnG4SzJ91fDdHIqTdUW3zZnw7EDh?=
 =?us-ascii?Q?JWz+gSFevVgcNKdaGryHqCeCErQtcHW6RlE7H1fj4N4P7iQmZlOKyjWXgui6?=
 =?us-ascii?Q?BqjLP+rxMKzdO7169s+MTs3gMfw5q0AiOEPbXeoy2Si05qKdiWwEKLW5RwXT?=
 =?us-ascii?Q?hTkLs4wPIhjjqWd9wm11vBZB3GKLs9ELzE99aqj8IukQye34Ykrzr7WdcSkf?=
 =?us-ascii?Q?3hOKKaHkr/XIuakmAeWkC8zXsE3h3XknEZVSZ0iEYrd5mstmT+hU/KOXXSrj?=
 =?us-ascii?Q?AnTCV+up7OYjUFvIcaBi2+8+tkurWKGdjiksw7c43bAvO9TUOBIPngOqmlDn?=
 =?us-ascii?Q?fP8L7vN0UzQAkeMca0210KiIq6ANAFks1Dja732Z0LrZdnkxleYnzZMJaZdY?=
 =?us-ascii?Q?R2u3FqDm0ydturng4tKY2wFc5q1CPKnWg6AauGTWnqZbPYV+kQdHgR7NQqLt?=
 =?us-ascii?Q?sYlvbG2stBZNdKqTjcC9DnIp32zGdpbiIFEgbikLLsR/xhlfSiUhpYLqG6AY?=
 =?us-ascii?Q?ZJ6GFZBcooHMTEtI4zjcXW/H91N9ETjnYumM/NbFLkx5OZN7VGK1pzfj4xFd?=
 =?us-ascii?Q?FASQ9cE4TAbN1XLdg6S4z3oEvMEvdVTV2ZFNLWS4Yk40zGo7z2IF2uQwlwvL?=
 =?us-ascii?Q?dVV5JbVMhLGQIArR56HsX8Vh49fUbl3biW7egidCH9zPxBgSwevZJNTLQm0h?=
 =?us-ascii?Q?O0KdinKEK+AdcZiGQKo54tPCDWrqUXtMg8WWIueAVpWUH8VUXlA8k7WFV350?=
 =?us-ascii?Q?3w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	xiNyBB1J0z5xUbQy9XkvopyZdYswxe/TQmf1Hkv9Kfi/jBtjgfB9QOAnnV3TT+VOzDUuLKtlMhBqUdB9y/ICigN8XNxxrfD7IDgBfZTiB4kuzpGkkWL95kJfqYYpi87tA44WNsqMxD1Mg3P5myD43oWfjMKQ6aKCNudg10rOOICUj/MB6Z9PPc2C/yzaiF8wt0odDrN1dGr0A8WkOQpUsUl5w1neUyjnCgXxBe03k+aNsvRIjloo9GdE5+MlwTeKOe2iETP2059Lw5grbY+QmaLnQN3waG5eihCa5hckFpO/KZ40ic4qj5uWFCzKzLBei5xIYD8jFbBAToMSiIosIFddFYaHE7miwoNbfnq6b96UfylIHmP7JZ9rRFpcyx1NefZa67srDOeZSKNuYBM8u9T3/9pdmEuyGZ2Iuh5WWILZxEL2l/Ceyv8Lb9/f1PdarnM/SYYVlbaTqRBME1gYpqTTueR5pr9cn5ywpNrFj6B2r4Fy1PGoTmvNGWB8OS33aU461FLv1ldYPMcRVWeUx2VxgJk0CHIO0gbK6EejzNW8Q51Kgc1Phk0332unT2wXGN3DWR+83AlJdEUuAvvFe8s9YT6yN6aThsyt9cxVMbc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5beafdb5-1229-4ba6-3685-08dde649b710
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2025 15:44:03.6737
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7qXj3HFkZC0Kdr49tSPAIQhX1KfgoXA4Rv10qHeeGHODwjzf9h0dnFbJz6t2lv9J5j9vBl3ShVplxPDk/fyOp8rCSKRwle136jMNeU+JWVQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB5921
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-28_04,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 bulkscore=0
 adultscore=0 mlxlogscore=999 spamscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2508280131
X-Proofpoint-ORIG-GUID: ZKcug2oQWMc6riyba7y5ksFYFxG79tb8
X-Proofpoint-GUID: ZKcug2oQWMc6riyba7y5ksFYFxG79tb8
X-Authority-Analysis: v=2.4 cv=EcXIQOmC c=1 sm=1 tr=0 ts=68b0794c b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8
 a=pe3YOxSbL00LKGLRwgEA:9 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12069
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAzMCBTYWx0ZWRfXwiWT+jBmSg5s
 yG1FLG0EqGDoZk41PBHqlZntnLzC1V1QpSDMRm5TYFVpvxhSiqhBgXfGA+fTbhdXfmY+1+CAsW7
 MhAsGYPEtkCeVnwkaFSGSptaElI1HVD2Pyi5aLA/0ft+7ZesZ+42IzFnVV6ZVoVYZodZ+QnviM+
 ZnJvMftHAW2FJJV3MCVN6dmvsrao5ilQyR1FJduEMp/wlqz+xzgGb0cYx/TtvdWcYgvNGvV7YjA
 40GoJ8od19RGsZLyK6gcjEeRF93BNrDvk0Rnum5qG51uzu2xszMOYc31gdsiql9TqdVV+8P5U0N
 2c3LK9S0kdJREsQRQs1gFMqmZVY/K4SWoB64BeXDM3syh0QYjZRJhj60btIV0hlzrWUs6A2VNyI
 d5SvJiAnIWhJWogr0mmCjz4Gcq6DAg==

On Thu, Aug 28, 2025 at 12:01:18AM +0200, David Hildenbrand wrote:
> We're allocating a higher-order page from the buddy. For these pages
> (that are guaranteed to not exceed a single memory section) there is no
> need to use nth_page().
>
> Signed-off-by: David Hildenbrand <david@redhat.com>

Oh hello! Now it all comes together :)

nth_tag():

LGTM, so:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

> ---
>  mm/percpu-km.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/mm/percpu-km.c b/mm/percpu-km.c
> index fe31aa19db81a..4efa74a495cb6 100644
> --- a/mm/percpu-km.c
> +++ b/mm/percpu-km.c
> @@ -69,7 +69,7 @@ static struct pcpu_chunk *pcpu_create_chunk(gfp_t gfp)
>  	}
>
>  	for (i = 0; i < nr_pages; i++)
> -		pcpu_set_page_chunk(nth_page(pages, i), chunk);
> +		pcpu_set_page_chunk(pages + i, chunk);
>
>  	chunk->data = pages;
>  	chunk->base_addr = page_address(pages);
> --
> 2.50.1
>

