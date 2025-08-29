Return-Path: <io-uring+bounces-9470-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 866C5B3BE7F
	for <lists+io-uring@lfdr.de>; Fri, 29 Aug 2025 16:49:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B194AB638A1
	for <lists+io-uring@lfdr.de>; Fri, 29 Aug 2025 14:46:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0060D321F5F;
	Fri, 29 Aug 2025 14:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bLW/tg/5";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="nsWAJNdn"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBF0631E10A;
	Fri, 29 Aug 2025 14:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756478724; cv=fail; b=ootFxEZaJKI6BqjHqZExTh1Ufwd8hvhKkQ5X0/tQUdlEPcv7m60GpKaY5rIpWaaULi/SDgmG2yhd0DIug+J6R3HhMNjHuG2Emev9irZnTCkvrVRrUUmF9P9iw5IFbSfvi9o2SjacbImzv8ZJ9fcbFeGnMTbj2uL8YykswB0q/B4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756478724; c=relaxed/simple;
	bh=iC9AEcbT/GHiMRyTNcM65cX7nlxHeAzgGCdPlAIpa/g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=fDXpdHvcQ53MoG5OxCfRbNmAuJbs7s/WLL/L1/c7ht3JWeKoSDpejHGBSwp8+m1bOmn2R4YNBZ/25TtmXylYqXoC0VWMz9+OeXgQ8pdiooXUkq1Rhv29rDLUl+HZDBZuL6R7YWDDJwRfyfim8fT5dIOHXeG9n1dyFCWnHZvizE4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=bLW/tg/5; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=nsWAJNdn; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57TCtjuI000564;
	Fri, 29 Aug 2025 14:44:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=uj6OrTQ4wFKg/KfhJ3
	5mUWIkNj3n6F0HN0B8kXPqQBQ=; b=bLW/tg/5dM2MvqS0r+1jlqn4EGwb2xY78K
	/dg8oYTrWlsMvndPE2STUD6oeuPtKUg8xqRUUAcDDgOl/MFkfPZqbnc6OCUNnCb7
	X7I1GDmKGua7x0bPJgRbgUt41fOe6EqxclaolPJdq4q+VCI8KJiLe8XH9f4M3r+P
	sS6ZU6G80uoUSKlqHWIAGZt9QoDL4Yx0pTxPnD95ixMz0hY0cLKHkaH90fgg6F7G
	GN+EO7HgVmDd1XwUK1O4TfTzUL0PteBF5Q3LLKlwgYmuThTC3jdUEVt+isw7Bxid
	A2ZL7SSvXO10qWn0hkIlOt7Bs+jBALgc708QyPrDWO3/9MxK9veA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48q42tagk3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 29 Aug 2025 14:44:37 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57TEOUMA018987;
	Fri, 29 Aug 2025 14:44:36 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12on2071.outbound.protection.outlook.com [40.107.244.71])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48q43daega-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 29 Aug 2025 14:44:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RQCdrQQwOnTAyrPIqbHuLX5uC+vb0GYql/MmHIVeGshboHuF/kOU5UGOon0EHa2ORn71JSgEqqmWzWhy2orIOcXHCIeLWFU4ZLGHBIbonBoaDc3MAsPQvUKfGikpQtiMLYnuK4whwmx+Rr7B8IT+tM4pVgJZA3eNlmy6OEKIUKAd4SQdsU2JYrx/l4vAIq5OvhlPUkS3Vny6PSLCmAXBG1h7HH9KQp/f/8+awuGqhS2Yqynmm3pBtfJOFtAX9mZR6kAUVTgHfjmvYlunmHO2iR/JM9coMDh6VFtk3sCj6HP7cqyIwB07hs55vq/zP8xvG24CewiwPaDsHM3TqXuU4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uj6OrTQ4wFKg/KfhJ35mUWIkNj3n6F0HN0B8kXPqQBQ=;
 b=iXg2ympZu9SoXjAX5N368DtlOKTfpoMDNQeqVhwCi2nambXVVSKJbhoW6wbcUO97R6qgWLfbTbbpHFaQSTKB9Ev10JslAdDfIAS0lvkfyGnKuJsl6ATY2m27xafP5zxKadDUpgZazmFY67+21kLbzkIqtpm4XI+HbZbj8MCS5XQffG79T3UexvTKALuQOXRMYgnicDUFpkyS6UmToiJ4QZgZzVdP/lA1CWTouT3xthpLTp4AB4l9qafjj3tRYcKePZLD3SbaHIv1xNrA7/pgBLfrg6DY4sj3GiFxuYtEklrLk0QSVhXsUeGUsi9RY+K/RARuxjPP278sEpNHebw/WQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uj6OrTQ4wFKg/KfhJ35mUWIkNj3n6F0HN0B8kXPqQBQ=;
 b=nsWAJNdno6Vn7Dsn7hHL8HrXQJrgFxU1AybeFaUi+eaR3o2NOW9Bwz3CAiAifPMkg9+bTYyINy7b60GbdijIEncsZS/rKMCCD6/Z7KehPEj8oqu0QAyDnd25C5aSGSVjAm4OgKtYjlAJkZ2P/AcwHw60sNs2TVxIjAANLHGu58g=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by CH2PR10MB4165.namprd10.prod.outlook.com (2603:10b6:610:a5::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.21; Fri, 29 Aug
 2025 14:44:28 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9052.019; Fri, 29 Aug 2025
 14:44:28 +0000
Date: Fri, 29 Aug 2025 15:44:26 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, Alexandru Elisei <alexandru.elisei@arm.com>,
        Alexander Potapenko <glider@google.com>,
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
Subject: Re: [PATCH v1 21/36] mm/cma: refuse handing out non-contiguous page
 ranges
Message-ID: <ae9412bc-45ee-4520-b9df-65b8faa52e8d@lucifer.local>
References: <20250827220141.262669-1-david@redhat.com>
 <20250827220141.262669-22-david@redhat.com>
 <b772a0c0-6e09-4fa4-a113-fe5adf9c7fe0@lucifer.local>
 <62fad23f-e8dc-4fd5-a82f-6419376465b5@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <62fad23f-e8dc-4fd5-a82f-6419376465b5@redhat.com>
X-ClientProxiedBy: LO4P123CA0592.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:295::9) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|CH2PR10MB4165:EE_
X-MS-Office365-Filtering-Correlation-Id: c01110e5-ea76-4b8a-d69f-08dde70a8e7e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?UrOVPkfOUX85RY6jlwECgHuENImuF+KSddRu/GH51kVMeGb30YpU/iRN6tym?=
 =?us-ascii?Q?DwqRfrxunw3itb0nxFf79DsSY+j/tjPPv+6AT4w0fyNH7Lt1Jbtb/HUc6cKf?=
 =?us-ascii?Q?VXxhwUubq0JV4vXzeg3OPic2WvMQMe7oyez00cfrhJQHBgePGZn8nQfS8v+L?=
 =?us-ascii?Q?bK8rwBC/mgD4hN8Upq2wVTWfRIXZlRv+paMdT50ClIVLOj3i0FltLwBL+buC?=
 =?us-ascii?Q?AFpuPMKoScpMJ9qYtk0peda91YZskZ/sb3uDmedM4sNLnipODbAaSTMXMDIu?=
 =?us-ascii?Q?t4l8c+KTEwOQfC1gqQOBmoREobtwU/RBa8Ymv8Qx440KFndkLB5EJI86M4vK?=
 =?us-ascii?Q?/+ojfKQNVFd5Y4162XmKW5T8tW0boz6rlCmWaewD+JaJs7GFcLtjmZbWHYIj?=
 =?us-ascii?Q?pyjbcOdMh2Xx3eiBN0iNVdTkwhC0+TvfGBsxc2slMu643fTo4xxywgBh+jBK?=
 =?us-ascii?Q?M9FP2Bk94qrQHYYHZPDZY+WK+AdMNXPz9Q+wdeubym1d765vEcxaABWobFvC?=
 =?us-ascii?Q?o0M6SjyyH1+MYOxwIEs114Nv34/D8O4FwZxVI4C8RhnehuDI61JJGixpPIF4?=
 =?us-ascii?Q?S5dN09bUWmA6qNS7tDul6En/U8Ed9pW7vitrDB2dkhP+mivXUsrB/HtSSzem?=
 =?us-ascii?Q?ClgO/s3kvwOrEGhdQz0piWKDcg3K5+f1LorvvdO8qGj/WGHZAZCR5ddbXdiC?=
 =?us-ascii?Q?zcWdUPpWoAhM7NI/48yxzCufH2LhzYZTsO3TxgV6s5jKrp1UN5UQip13QrYJ?=
 =?us-ascii?Q?tBMd86ARRb0lrNGl2DWtRsO9WRarkLKCVgytX+6XDOzkpZXAfPm/3ubpJ1IP?=
 =?us-ascii?Q?ykeHdWDTY8CRHEbgFs3sdDxYJdSYpFI0zJv5wPD+D2GKkDjEy5gGaUeH4jef?=
 =?us-ascii?Q?70jP1p6EIPmoQwNNy1XN/t0WgvaMAYChJgGgDk3qZ9FitV610Mk8QgmViOLF?=
 =?us-ascii?Q?uGRdQZNaJ0qdGinQdIfzL4/Po4tgFpXn956pYasXNXwX0Z+d6YSbXLf4/Nwh?=
 =?us-ascii?Q?Z5kfjJiQ6GSGM6kcwlET5109t0iKIUEEiuM9QtcMI9mKhsyk9SsyDKWqxLX8?=
 =?us-ascii?Q?ua0GpP59HG/MQrTf4fGJoWZzRm7t/GJgNXTALObkMHU75tQ/+GybmiS6pxA0?=
 =?us-ascii?Q?P8o8xachwSrKTwveUt9YCXi7Gm/ADpZ3TV/W6JmM/zVgS/vaW4mbQmrIqjt6?=
 =?us-ascii?Q?IPp8xmnIjyl0XXV5/TcOKfKM1Dg/IcbCzO7O6RxskUFanUCYNqy6E3tJlhz0?=
 =?us-ascii?Q?2U/E8X++a6gI7N+L+cknvYmAJdOqzpavkJncaJT5t8GxVAtW2NX1ZrXCdWVn?=
 =?us-ascii?Q?SF5+zCQjvJD7z/WL1qiwx0sCCmk/NsJwkCtB8CAqMzF6Ulwh8UmAsqh91wTw?=
 =?us-ascii?Q?e5CY17zlIEyTFcya4F0jNyhp8kcC7Zs87FHln3Pp0R2aiQi6sQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?P87gTrNvlF5s20yRVu8Mrwcfc89ASoAAskTalSNuWSXlDszHMSSZNQ2+9Vft?=
 =?us-ascii?Q?LA6+dR1j4/0BvEZdJdItrCtC9ilrzzghXoOYjK/I1FxC+QU/hCu6kcP1r+0X?=
 =?us-ascii?Q?rpWvRa+eWdHTepfpVq3GkT7eo2yL74ntiDekLiNNCObuWi8XPZWULtz4mO6h?=
 =?us-ascii?Q?pFny2S+kbytRj+zfJyIOktUWgfjbrevVWxo6up/1sCzjGw3AS0lYDIYZwJaw?=
 =?us-ascii?Q?IEVehaT7I2WVl0UhAtJey9i2UOgsekJ+QP81ppGIpxIl/lkk3yOUMSOR08u1?=
 =?us-ascii?Q?gy/zzDRVTc5R4J+5CJK8MAbYmOPyrfiwVIS7A6C/V179pigOxs+Kam6w8edc?=
 =?us-ascii?Q?Pnna6VWF2DF7W8ihGBINelC8Aua5tAz/WX5Q9ThgGX5HnJu7guaUou6l8eGb?=
 =?us-ascii?Q?nK2TLCyde5UBTpmlERcQlQPiYZhA3PwJs9SdepTlJOzyfmg4aOjqHKCr7zR5?=
 =?us-ascii?Q?8lVfNQD+OZL2TWENch3UUsLGw84t8EA4SdhaHNxJzQRjnlIL1aWsslXKq244?=
 =?us-ascii?Q?bz2EjQa3xHHMukHduIKVMGeQTgIohpWqiPKLYwXhoHrIO+IgCtfcSR8dLkVv?=
 =?us-ascii?Q?Afnv2Fii+Jm+B3srZCeC9el50cB8oNfo+ivjPgf3sjP4WVUK4PIw0We4BluB?=
 =?us-ascii?Q?jzfpPq75kbIdR9I2x8ygQKFArcLxDGKFBS1wXcESYWlMf7Aw4VLtGMz3jHAw?=
 =?us-ascii?Q?6EcKiFJq/itKtIGfwCayAI0ea5RAkJGqGpVqWhU/APNkCn02jTiYGv1MkXbZ?=
 =?us-ascii?Q?xwEw1IlzaDdRlK4JMnB6XVphsbibSZPwgXKzQBiFTaSRkqrWtkwNiMXdBF5Z?=
 =?us-ascii?Q?Wp+m8qZjZTF6WHI37Q7MPuH0/A4Yf65QMxCksa+uj2bwi1qX7PgZUAtFioK6?=
 =?us-ascii?Q?lEEr7+ohD3SSmyNP+eznn9yAj4rHsJtBsbPuqrxbk8WfSItPFltxtDzvQmWY?=
 =?us-ascii?Q?hNF/IdV4Icp6gfC10YjhsaGbPS7K2uLDLNZyOOGccKKUCXbqs2zdkWzvwRxx?=
 =?us-ascii?Q?r76ZzwMOhGbIHEQ0bJ+9ABpVMZkP8UH5fCSfxbG6HVnvTf6tZkCfTYp93RRS?=
 =?us-ascii?Q?AgQW30Y1ne8HpOt4ytTzhSZPOFaYcStyehuCvZeYU/U0GqZzw+f1TrRJnoeG?=
 =?us-ascii?Q?4woCOt2xiYa3P3hunehcJqL2qGaSsCW6KwLtBusDF1ODNpUcsZEJYB17NtCP?=
 =?us-ascii?Q?oTV48ydCoS+ZWcroeDUw5VLFJQyxiF6m2wHvxls9H9iPddS78ilw9nz1Mu75?=
 =?us-ascii?Q?Acu1aMQ2858cqxAiugXkVhVex3wCfa1nSFniywJq5mSyE7f4u4BkBPdE95aB?=
 =?us-ascii?Q?mGhBqJRc69p61KLaPxsfVIhiOTymxuGLvPcq/c9i+lwF6PySZ+DZtsYDMigU?=
 =?us-ascii?Q?Ic8rOktiLanuNyVJSIR7hNiFUTd+tIhkrxmYm4rhEfdrab1nWI/Hpf/841Rj?=
 =?us-ascii?Q?qg7pGeN3gdFECV/cvkMygsmGteNjuLFIZg3+KEEmidsa1AM2Zz/g51Q846er?=
 =?us-ascii?Q?Jt4wym+iU1l81uB9NZ8kEzZfeH/L3wAJgre++rVvY/HIP1s1FclZdieEWz48?=
 =?us-ascii?Q?jN/oMnM5dQpFVil6Z6vUEv5HWULowlcHH9jU85jtJHLxbMK5yX1+4EpotxMs?=
 =?us-ascii?Q?2Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	5Tdm8it+V+HExrkNXFnEPZ6fgStCuDlM9BkM5oTWwVzh8Z0zbThMKl/aRx2ZmuS63UNHfP3sPRobOgYLP59CF7TA6eAaa1g3wtyFW9KC7S6TVwujojerGnSiaUZna9FxvsCsw/IFHqS8Kxc0tYnTHT4cREyUy4t/JoX+RV/s2UvArURgMnpp7PB48v6b1lHsj98LgNIM01q19xVkyXvjsxsS+PBYJLEk9Q3V3l/FpfBzlk9L4Knb8nRgaWIfKFINcaQnmrjYl+Qx38r+Acagrpz5cvMajCI19JucLJh1f6BCF5pJ/Lifr0IbjT2xUyoiFWD9V4FdHYyEQ2BqtEw7dZLvpDQ7OcrMMTf/pj9D7UDyfihmlweF/jW4zXGa4OKSf1skC53gC6u5bH8A9da9l3LxPcxy9tdRvutVexnBHs7QjwuBiHlUJiqdPlUP2xFORUIh6A7QIKRIihJ3Ikyuklyf2HjvXSmO7Onp9IULETCAB4IZAXaya7cA749hudauhIR/HHRP4NlYiEKkKuk8ra/FNWIcVK16C3fO6DuTUtSgi7zRvUpk6ho0r+2FhhFJJRX7yjgjnn4cn+/4Gi2bEALOmJ9rpsCDlw93USptlCE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c01110e5-ea76-4b8a-d69f-08dde70a8e7e
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2025 14:44:28.4559
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X869oi7uS8ygclHf8mvm0vZD6rd3qLq8zsSv4yFRjWc5uOfp+vc3YnK0PYvtMk4nAh+pKG+VXQ0RP4dt2rBmhYtb29rfdY30O18WqD4VPCY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4165
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-29_05,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 phishscore=0 bulkscore=0 malwarescore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2508290124
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAxMyBTYWx0ZWRfX+Mcc/l27mv7u
 PiGIObLxzSX1s0utr5DmZwkqh8NixBA0RqNVzTAI20r62gLumVGE4iGVsnRXiowQMOl9/kZ7Fmx
 8LkCqyT2uLooP1WBhQm5GzESwJ4d0oJB8CHnyvDAUbipbU00gJHsuqhS7B/mhXrm7qb43zpPGo9
 8FeOjTCIM0oqp7YK2FEVRT8OBqrZDc541QWc1R9Qxe8PF9cwD46a52ALzorv16o/9f13zlHlyUb
 5FoOr284AmbLTMg0rj0fjVH/RyiHqdIgC7jqkV2MiKxdjMR4kb0Xp3FMrWwLXVl6TXcibfTqKpf
 KrSGxBsmKUGzRGikwppfR6VtTU0zMZ+DsV/mGFtkMPPLy/MTW2WiqdbgkaHSRl4UwhGcFbf+5Mg
 ddfmhVj+
X-Proofpoint-ORIG-GUID: RXNLFA9YcQOdpUaQnmB-t6wQOEulJM3U
X-Authority-Analysis: v=2.4 cv=RqfFLDmK c=1 sm=1 tr=0 ts=68b1bcd5 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=7CQSdrXTAAAA:8 a=20KFwNOVAAAA:8
 a=yPCof4ZbAAAA:8 a=tpO3Aoaa9ue-Jl-dp4cA:9 a=CjuIK1q_8ugA:10
 a=a-qgeE7W1pNrGK8U0ZQC:22
X-Proofpoint-GUID: RXNLFA9YcQOdpUaQnmB-t6wQOEulJM3U

On Fri, Aug 29, 2025 at 04:34:54PM +0200, David Hildenbrand wrote:
> On 28.08.25 19:28, Lorenzo Stoakes wrote:
> > On Thu, Aug 28, 2025 at 12:01:25AM +0200, David Hildenbrand wrote:
> > > Let's disallow handing out PFN ranges with non-contiguous pages, so we
> > > can remove the nth-page usage in __cma_alloc(), and so any callers don't
> > > have to worry about that either when wanting to blindly iterate pages.
> > >
> > > This is really only a problem in configs with SPARSEMEM but without
> > > SPARSEMEM_VMEMMAP, and only when we would cross memory sections in some
> > > cases.
> >
> > I'm guessing this is something that we don't need to worry about in
> > reality?
>
> That my theory yes.

Let's hope correct haha, but seems reasonable.

>
> >
> > >
> > > Will this cause harm? Probably not, because it's mostly 32bit that does
> > > not support SPARSEMEM_VMEMMAP. If this ever becomes a problem we could
> > > look into allocating the memmap for the memory sections spanned by a
> > > single CMA region in one go from memblock.
> > >
> > > Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
> > > Signed-off-by: David Hildenbrand <david@redhat.com>
> >
> > LGTM other than refactoring point below.
> >
> > CMA stuff looks fine afaict after staring at it for a while, on proviso
> > that handing out ranges within the same section is always going to be the
> > case.
> >
> > Anyway overall,
> >
> > LGTM, so:
> >
> > Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> >
> >
> > > ---
> > >   include/linux/mm.h |  6 ++++++
> > >   mm/cma.c           | 39 ++++++++++++++++++++++++---------------
> > >   mm/util.c          | 33 +++++++++++++++++++++++++++++++++
> > >   3 files changed, 63 insertions(+), 15 deletions(-)
> > >
> > > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > > index f6880e3225c5c..2ca1eb2db63ec 100644
> > > --- a/include/linux/mm.h
> > > +++ b/include/linux/mm.h
> > > @@ -209,9 +209,15 @@ extern unsigned long sysctl_user_reserve_kbytes;
> > >   extern unsigned long sysctl_admin_reserve_kbytes;
> > >
> > >   #if defined(CONFIG_SPARSEMEM) && !defined(CONFIG_SPARSEMEM_VMEMMAP)
> > > +bool page_range_contiguous(const struct page *page, unsigned long nr_pages);
> > >   #define nth_page(page,n) pfn_to_page(page_to_pfn((page)) + (n))
> > >   #else
> > >   #define nth_page(page,n) ((page) + (n))
> > > +static inline bool page_range_contiguous(const struct page *page,
> > > +		unsigned long nr_pages)
> > > +{
> > > +	return true;
> > > +}
> > >   #endif
> > >
> > >   /* to align the pointer to the (next) page boundary */
> > > diff --git a/mm/cma.c b/mm/cma.c
> > > index e56ec64d0567e..813e6dc7b0954 100644
> > > --- a/mm/cma.c
> > > +++ b/mm/cma.c
> > > @@ -780,10 +780,8 @@ static int cma_range_alloc(struct cma *cma, struct cma_memrange *cmr,
> > >   				unsigned long count, unsigned int align,
> > >   				struct page **pagep, gfp_t gfp)
> > >   {
> > > -	unsigned long mask, offset;
> > > -	unsigned long pfn = -1;
> > > -	unsigned long start = 0;
> > >   	unsigned long bitmap_maxno, bitmap_no, bitmap_count;
> > > +	unsigned long start, pfn, mask, offset;
> > >   	int ret = -EBUSY;
> > >   	struct page *page = NULL;
> > >
> > > @@ -795,7 +793,7 @@ static int cma_range_alloc(struct cma *cma, struct cma_memrange *cmr,
> > >   	if (bitmap_count > bitmap_maxno)
> > >   		goto out;
> > >
> > > -	for (;;) {
> > > +	for (start = 0; ; start = bitmap_no + mask + 1) {
> > >   		spin_lock_irq(&cma->lock);
> > >   		/*
> > >   		 * If the request is larger than the available number
> > > @@ -812,6 +810,22 @@ static int cma_range_alloc(struct cma *cma, struct cma_memrange *cmr,
> > >   			spin_unlock_irq(&cma->lock);
> > >   			break;
> > >   		}
> > > +
> > > +		pfn = cmr->base_pfn + (bitmap_no << cma->order_per_bit);
> > > +		page = pfn_to_page(pfn);
> > > +
> > > +		/*
> > > +		 * Do not hand out page ranges that are not contiguous, so
> > > +		 * callers can just iterate the pages without having to worry
> > > +		 * about these corner cases.
> > > +		 */
> > > +		if (!page_range_contiguous(page, count)) {
> > > +			spin_unlock_irq(&cma->lock);
> > > +			pr_warn_ratelimited("%s: %s: skipping incompatible area [0x%lx-0x%lx]",
> > > +					    __func__, cma->name, pfn, pfn + count - 1);
> > > +			continue;
> > > +		}
> > > +
> > >   		bitmap_set(cmr->bitmap, bitmap_no, bitmap_count);
> > >   		cma->available_count -= count;
> > >   		/*
> > > @@ -821,29 +835,24 @@ static int cma_range_alloc(struct cma *cma, struct cma_memrange *cmr,
> > >   		 */
> > >   		spin_unlock_irq(&cma->lock);
> > >
> > > -		pfn = cmr->base_pfn + (bitmap_no << cma->order_per_bit);
> > >   		mutex_lock(&cma->alloc_mutex);
> > >   		ret = alloc_contig_range(pfn, pfn + count, ACR_FLAGS_CMA, gfp);
> > >   		mutex_unlock(&cma->alloc_mutex);
> > > -		if (ret == 0) {
> > > -			page = pfn_to_page(pfn);
> > > +		if (!ret)
> > >   			break;
> > > -		}
> > >
> > >   		cma_clear_bitmap(cma, cmr, pfn, count);
> > >   		if (ret != -EBUSY)
> > >   			break;
> > >
> > >   		pr_debug("%s(): memory range at pfn 0x%lx %p is busy, retrying\n",
> > > -			 __func__, pfn, pfn_to_page(pfn));
> > > +			 __func__, pfn, page);
> > >
> > > -		trace_cma_alloc_busy_retry(cma->name, pfn, pfn_to_page(pfn),
> > > -					   count, align);
> > > -		/* try again with a bit different memory target */
> > > -		start = bitmap_no + mask + 1;
> > > +		trace_cma_alloc_busy_retry(cma->name, pfn, page, count, align);
> > >   	}
> > >   out:
> > > -	*pagep = page;
> > > +	if (!ret)
> > > +		*pagep = page;
> > >   	return ret;
> > >   }
> > >
> > > @@ -882,7 +891,7 @@ static struct page *__cma_alloc(struct cma *cma, unsigned long count,
> > >   	 */
> > >   	if (page) {
> > >   		for (i = 0; i < count; i++)
> > > -			page_kasan_tag_reset(nth_page(page, i));
> > > +			page_kasan_tag_reset(page + i);
> > >   	}
> > >
> > >   	if (ret && !(gfp & __GFP_NOWARN)) {
> > > diff --git a/mm/util.c b/mm/util.c
> > > index d235b74f7aff7..0bf349b19b652 100644
> > > --- a/mm/util.c
> > > +++ b/mm/util.c
> > > @@ -1280,4 +1280,37 @@ unsigned int folio_pte_batch(struct folio *folio, pte_t *ptep, pte_t pte,
> > >   {
> > >   	return folio_pte_batch_flags(folio, NULL, ptep, &pte, max_nr, 0);
> > >   }
> > > +
> > > +#if defined(CONFIG_SPARSEMEM) && !defined(CONFIG_SPARSEMEM_VMEMMAP)
> > > +/**
> > > + * page_range_contiguous - test whether the page range is contiguous
> > > + * @page: the start of the page range.
> > > + * @nr_pages: the number of pages in the range.
> > > + *
> > > + * Test whether the page range is contiguous, such that they can be iterated
> > > + * naively, corresponding to iterating a contiguous PFN range.
> > > + *
> > > + * This function should primarily only be used for debug checks, or when
> > > + * working with page ranges that are not naturally contiguous (e.g., pages
> > > + * within a folio are).
> > > + *
> > > + * Returns true if contiguous, otherwise false.
> > > + */
> > > +bool page_range_contiguous(const struct page *page, unsigned long nr_pages)
> > > +{
> > > +	const unsigned long start_pfn = page_to_pfn(page);
> > > +	const unsigned long end_pfn = start_pfn + nr_pages;
> > > +	unsigned long pfn;
> > > +
> > > +	/*
> > > +	 * The memmap is allocated per memory section. We need to check
> > > +	 * each involved memory section once.
> > > +	 */
> > > +	for (pfn = ALIGN(start_pfn, PAGES_PER_SECTION);
> > > +	     pfn < end_pfn; pfn += PAGES_PER_SECTION)
> > > +		if (unlikely(page + (pfn - start_pfn) != pfn_to_page(pfn)))
> > > +			return false;
> >
> > I find this pretty confusing, my test for this is how many times I have to read
> > the code to understand what it's doing :)
> >
> > So we have something like:
> >
> >    (pfn of page)
> >     start_pfn        pfn = align UP
> >          |                 |
> >          v                 v
> >   |         section        |
> >          <----------------->
> >            pfn - start_pfn
> >
> > Then check page + (pfn - start_pfn) == pfn_to_page(pfn)
> >
> > And loop such that:
> >
> >    (pfn of page)
> >     start_pfn                                      pfn
> >          |                                          |
> >          v                                          v
> >   |         section        |         section        |
> >          <------------------------------------------>
> >                          pfn - start_pfn
> >
> > Again check page + (pfn - start_pfn) == pfn_to_page(pfn)
> >
> > And so on.
> >
> > So the logic looks good, but it's just... that took me a hot second to
> > parse :)
> >
> > I think a few simple fixups
> >
> > bool page_range_contiguous(const struct page *page, unsigned long nr_pages)
> > {
> > 	const unsigned long start_pfn = page_to_pfn(page);
> > 	const unsigned long end_pfn = start_pfn + nr_pages;
> > 	/* The PFN of the start of the next section. */
> > 	unsigned long pfn = ALIGN(start_pfn, PAGES_PER_SECTION);
> > 	/* The page we'd expected to see if the range were contiguous. */
> > 	struct page *expected = page + (pfn - start_pfn);
> >
> > 	/*
> > 	 * The memmap is allocated per memory section. We need to check
> > 	 * each involved memory section once.
> > 	 */
> > 	for (; pfn < end_pfn; pfn += PAGES_PER_SECTION, expected += PAGES_PER_SECTION)
> > 		if (unlikely(expected != pfn_to_page(pfn)))
> > 			return false;
> > 	return true;
> > }
> >
>
> Hm, I prefer my variant, especially where the pfn is calculated in the for loop. Likely a
> matter of personal taste.

Sure this is always a factor in code :)

>
> But I can see why skipping the first section might be a surprise when not
> having the semantics of ALIGN() in the cache.

Yup!

>
> So I'll add the following on top:
>
> diff --git a/mm/util.c b/mm/util.c
> index 0bf349b19b652..fbdb73aaf35fe 100644
> --- a/mm/util.c
> +++ b/mm/util.c
> @@ -1303,8 +1303,10 @@ bool page_range_contiguous(const struct page *page, unsigned long nr_pages)
>         unsigned long pfn;
>         /*
> -        * The memmap is allocated per memory section. We need to check
> -        * each involved memory section once.
> +        * The memmap is allocated per memory section, so no need to check
> +        * within the first section. However, we need to check each other
> +        * spanned memory section once, making sure the first page in a
> +        * section could similarly be reached by just iterating pages.
>          */
>         for (pfn = ALIGN(start_pfn, PAGES_PER_SECTION);
>              pfn < end_pfn; pfn += PAGES_PER_SECTION)

Cool this helps clarify things, that'll do fine!

>
> Thanks!
>
> --
> Cheers
>
> David / dhildenb
>
>

Cheers, Lorenzo

