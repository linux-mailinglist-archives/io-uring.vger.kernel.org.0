Return-Path: <io-uring+bounces-9457-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0AEB0B3BB66
	for <lists+io-uring@lfdr.de>; Fri, 29 Aug 2025 14:32:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 05F9A174846
	for <lists+io-uring@lfdr.de>; Fri, 29 Aug 2025 12:32:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53D1831A054;
	Fri, 29 Aug 2025 12:32:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DXb7Nu/s";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="o7bDNTwY"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DD9D31A041;
	Fri, 29 Aug 2025 12:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756470753; cv=fail; b=XascKiyt7KDmwKfEKJjKhUeckTcOZxwFi5qyPPKLOU2LKmf/Oi/BYrHbB974BZSPBFysDIT1K4Z3KDzfDfR4r2d7JPnw+9B6XuOLdalHchGbEfB23PQPVXPOmoe3d+sMblDLLd2ugO6hrHYasQQW057+pBb7GMTze1/5qPAbswk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756470753; c=relaxed/simple;
	bh=UUHcsuYyghxw+X323vYcFn8Nkb/ksc/RlHoE0hHPcrI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=mBVaTZOXNKw21Q1TX6V9bmWIYRsug5vl50f5W9iVhVQUYU557cSMf74WFcP8L3ai16CictqkRyRtqRT7BSFIjOfVcQiEE3WpRlZsJj9H6zKF4i7d4hK+HFDBulBLXV6a/Ek7XA1Z2oeRXnQxhGjUDfWNzfgysnRy/r6Alr6VgSY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=DXb7Nu/s; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=o7bDNTwY; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57TAYWJx005312;
	Fri, 29 Aug 2025 12:31:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=orpgKLmV82VuLR2k0q
	LRR81BE7TYGJ+swyLH+mFZUKs=; b=DXb7Nu/sA69OpqXl7EbzkGSPwnrQRtlGt+
	bY8k27kyHxVXDcvKHlaLtZxL9zykST58S9s2DGUuXTD/WrCaKefzX1kY08cb6YaN
	1GxBpFhvGzXiI6PvcbRz4AKOiZ1sIoTZmkwFpIIaVA76dkLgRTqYjzhO+GBe80JD
	t50D3RrtbZoXwc6ELCOjiN2hMAHAjAXzCAkZPFgzh+MU5EUGoG4p8OyEtiw5iPLK
	fKv/YcY0Okmq3q7GuXyQTJblkgn/fjkCTMSeD0XhjcZDxCiaZ20YtJPw6ja2ULwS
	xN1EYHwnoJaOd9NMUbbT/v2LDlDXjP1OBNCr1oh7bccflov90E+A==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48r8twh3fq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 29 Aug 2025 12:31:51 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57TAaSjA018956;
	Fri, 29 Aug 2025 12:31:50 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12on2055.outbound.protection.outlook.com [40.107.243.55])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48q43d61fx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 29 Aug 2025 12:31:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Z9FkNx8EEiIzOEfE2Z6/NEs3dmGv8C7yXrapRDZzQEcWYWkMXMWhWWv3HgO4s7AlrnOd1g7NeB/rIhGVfQt9uXlBuKAq9tQnNlbzR/2r+mGSd5mxIynCv1L2PPxatzqdBpX44kr18l+HuyU6Vo+8sGHiC3uDHxaw958moTCrcRc3GFayTZAeLI/9SwUtEQG5HICICmbngW1YCR/lRzjEmGKfKEaSuLglymzeMGU0illw4t7ZUJh6xyIRP4XNd/zRdMHysX0ZR2mR5Y/2rdGY61eaGN47GBt3kahPILk4GPfvv+/+yIQQVDG46UZiU5AV0ToFTCbi4f0Znql2yuaowA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=orpgKLmV82VuLR2k0qLRR81BE7TYGJ+swyLH+mFZUKs=;
 b=Q3CJzTIIgKMJ4AVQiX1JSlZ0hUd05GwK4jAL2asq/f+BCGQ9Y+CsBNbO0l4T9gdVmfAwMXXXS8zMijZZ5voh+pSQ5GPbHjhIV61w4CWJtmkK616/pxrX2hID3LQW+NUa6qgU/Q3ffBBo1ylY7nG6a3HDFG/JLUrT1hHbeuf/f6L2iVGc81KORr5Te4QuIgm70M7gcQppxpKSuIsFI0T+FJdUs0ICtdapR46g51yDubGgzwebcR0H2pFDQRv3Zl0ZUXGXwWSoCoswEL256NodAj4yRSJjh71rDlK/Wig8Pp8er429HKfEoiL2KCbWDx9EWPJ1Wm5dxp085Ew2jbLd2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=orpgKLmV82VuLR2k0qLRR81BE7TYGJ+swyLH+mFZUKs=;
 b=o7bDNTwYLarS2uq0vSRkJ4c1VwBLw9UgXe1JxbK1iUTLgnziTGo03EX/EhoCXbAx4ncCwW1Hz1RsSpIETOeL7/xroxXrSfePRMmuqKiq6CleegJtLGVwYrVPWrLNM2/Itx0bsBSNc+bb4PYkYzAYhzuhHPLnGKNZ7b9mk78qjOg=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by CH0PR10MB7409.namprd10.prod.outlook.com (2603:10b6:610:183::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.16; Fri, 29 Aug
 2025 12:31:43 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9052.019; Fri, 29 Aug 2025
 12:31:43 +0000
Date: Fri, 29 Aug 2025 13:31:41 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, Zi Yan <ziy@nvidia.com>,
        SeongJae Park <sj@kernel.org>, Alexander Potapenko <glider@google.com>,
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
        wireguard@lists.zx2c4.com, x86@kernel.org
Subject: Re: [PATCH v1 06/36] mm/page_alloc: reject unreasonable
 folio/compound page sizes in alloc_contig_range_noprof()
Message-ID: <34edaa0d-0d5f-4041-9a3d-fb5b2dd584e8@lucifer.local>
References: <20250827220141.262669-1-david@redhat.com>
 <20250827220141.262669-7-david@redhat.com>
 <f195300e-42e2-4eaa-84c8-c37501c3339c@lucifer.local>
 <547145e0-9b0e-40ca-8201-e94cc5d19356@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <547145e0-9b0e-40ca-8201-e94cc5d19356@redhat.com>
X-ClientProxiedBy: LO4P123CA0508.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:272::10) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|CH0PR10MB7409:EE_
X-MS-Office365-Filtering-Correlation-Id: e7d163dd-e9b2-4011-7dca-08dde6f802f5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ZskdaTkEL0+NeiOEeLkqiK0ypBrVLFRHFe2FOCHcRKGGGpXQetTWfHW3s4IR?=
 =?us-ascii?Q?bKyWBv08n6yWbPD/Dy/GC/yvytqNuCXGWRocxinAN7C4IISV2vBl2W2N01qg?=
 =?us-ascii?Q?1OJld0efhEKveiEjipq/F7y+pSWQynwMcJ9K0cpcnkuy8V83uKfiU5bNGT/z?=
 =?us-ascii?Q?j3u6zqeGp0NYaxx3IctYKzg8FhTMDAxk7on+uVC8FQqp9T7YddjmsHFIrB3O?=
 =?us-ascii?Q?jvUX772d4Pgj/OelJf5EIfWmk1RUGfcwONSpVxJcaDFLhWznJtgbk4/RBq30?=
 =?us-ascii?Q?VIJFl5eEKnoygAKZCTLeWVgzigqZT1SLHVCkIzqLhRbVG5Md/9bGa9iOzElh?=
 =?us-ascii?Q?eZlwOlLKPckozkRWZw9eQ/2OkHo19DjsUe/X2F0x3FRHXSO7Xg8l0oa4kMTq?=
 =?us-ascii?Q?Gl4n+H/mgZ8k0zBku7gkTRDnBcWpsnz7sAu1SVC808eW+GterYEqAPDvszhg?=
 =?us-ascii?Q?TCNQN52jbRYMmbSWE2DvCTNQa75I8Uj8JJ9odAaXjsYmYYKVLZO1Xiz85Cle?=
 =?us-ascii?Q?K3OGhSjG0V3uEXTAtoSIbmkFgYze+y9Den6lBIo+bBQYtl+e7+Eb/llrAjIn?=
 =?us-ascii?Q?/NIcaM6spwaf86MR6pvCg0sDG6+03GqIirBXXjjKUCp4vGKtO1wWM9Wa97rM?=
 =?us-ascii?Q?+iwp54yiyDFmvhB2b5ArTINZWC4Pr0SEXyQtwWrRdtwumYMk20t3edJYa5H7?=
 =?us-ascii?Q?k6KoSh7HY9nSduMTVCDE57viBMdptUGD1nEkqXMYc5OpASerR75qrHW/h9kv?=
 =?us-ascii?Q?ESha0l88k5LSqjYDmuZhyDkoVSYiiLfWhlmxd0eBXn0X0tWgbD+dhZ5Z8Ci1?=
 =?us-ascii?Q?kl7oPSlSkHWY0ZR2lH+jh4YdbYYgA/4+di3cRSqREDR17MjGb0frSXBZ1dfo?=
 =?us-ascii?Q?QMwfvj4RHYdM26g76J/mtbJKBLIr04jzEQuyDqTXYc0CE86kpt6lwU+0ofIQ?=
 =?us-ascii?Q?3RDN2qzMJUzAfwYGrB1kOzAw51OQZLg5W9F7UTHKdVG/GAtj1UmQGSeBBPn+?=
 =?us-ascii?Q?wLIsAEbHhl1q8lTXgewU2g2f2TDZ4f+jr0W+M14w2Ko0++81Cj1dwz1I2vOu?=
 =?us-ascii?Q?V4uqs6xQNId9T/7v+QSfcJcbhT/uJdLErNAc+XghlA0+IF9xF2b1MEyBjGUW?=
 =?us-ascii?Q?V8TQ1qfMhIS0zHz6Ow/zzKt0rX0dlxpXGsdnrwopsD8rO7Twt4i/ckRwVOsZ?=
 =?us-ascii?Q?FFH+ERQp8/w4h2Mt0HpI4btsyXh21DD8YndsPkSvty0tAznPVdo0j3kGeXso?=
 =?us-ascii?Q?0NXl/T0nf+K/OUsVg77inoUSSDkb8YeWdqalLwqnEvQCWf7HPMhv0I1438e1?=
 =?us-ascii?Q?7ip+zd2chDFM+RHBSkyAnn514dCIAb74/p/5y6b5PyxpDynAu6Dhk1+Xu3Oo?=
 =?us-ascii?Q?GW+sFaN6jW8yCpJY6DEVA4flos7bIDx5Gs37Wxy3q1hpq+I6QQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?6AggJ3DsPojRRtSf9UsEzwHY2fLgrsHl8v++ZkP6YYeTANJuA5lzzY4bOXAX?=
 =?us-ascii?Q?VUIyG/a2AIhGwC9kJqB6SNrbaqgCG7nBjNfATHwu4DN/FLQg8lOlFeuJUeMJ?=
 =?us-ascii?Q?INqbsAYe1DXGLYEmhn5dXu5Nf9PrsnrWzMYsphpcoY6ikTMZ6Cx2TCRvFbhC?=
 =?us-ascii?Q?7sBAREGhrkpXCLYnHhuJYDQzBzQNUI4SK5lChAKOkDcASn+DUUABA6/mlzVV?=
 =?us-ascii?Q?vF3lH4ltZlV/P6T3G3i7dwOCEjsuQuUOTlt76lLRJb+Us465RZ4QMNKVMA8H?=
 =?us-ascii?Q?XgRURqSsurzWiLElc+1FBrIFF74ZCEDzskXZIGF5d/+TQ09ioJDO3hyjYhNw?=
 =?us-ascii?Q?skKXxdon4Khia/rqxpxWrQgi+CWyOrwDwz3xXc1KVM7vD8wb8xPfBAFrcUHR?=
 =?us-ascii?Q?KvdrSREhqmLqmy1zvTJppHqncwqI90gurrFCh41vmy3LOSBRHWoDkrGGT/hL?=
 =?us-ascii?Q?YxVtWbB6I3cOFfzr6tEeVlnPwzLvx3Ts+naOyEQ4cgD99VGSXRbmwtJy86IX?=
 =?us-ascii?Q?eeEEkGRBbvq1vcvg0PkqRG3rK/0S2toX7W3iOejd4526aCK4OXA+lvzSP4xI?=
 =?us-ascii?Q?Vc5Az5rh2auihu7WWTPDchxrTS5q4Uy7zafUk0gLk+R5hDm/vbbdzbCBzift?=
 =?us-ascii?Q?5lM/MSeot582yuKqvZOrgrNjxLekVOWCIULJdBhGnnVq52ky+MabmQZKTsmd?=
 =?us-ascii?Q?GPuQiEU0owSN53hX/7+8MC5QWriYKFrVXnBggM5Bopc9p+XUpn2k+sRMEiXH?=
 =?us-ascii?Q?Vb8UxQBW/gTDcT90Gn9w0feg+gEDwWeBX8dizJQ2whiotUjhKV+A1a9ko1bS?=
 =?us-ascii?Q?T8F4udpgVdKsmeZ1CEE8q26RaMJ6iwMlWu63bZzycnY3N63tMMFpU9gl3nuB?=
 =?us-ascii?Q?4TJ7z6FuHYyKAGYrOlIkaGcZLs5fLBuKiXLDzCHN+qqM9uShVNYFUASDFpR/?=
 =?us-ascii?Q?1HcVwYvIxDr2E2GBzYzunx5jADhqCU0QyoYJs7u75HtSSoa9WZ857/xa8J9n?=
 =?us-ascii?Q?PcU4gzqHpCRXXoqxBVy4CTVK+mVzbM2gIb9igxmEm5KHNVqf6q+cD6/wlf37?=
 =?us-ascii?Q?N4S0++GD9Kt3pG6qpVifJzNDb1HTuyAKiRj+DnBGWyh8yvgV4gqB7151S3GG?=
 =?us-ascii?Q?qy8Io87pxZy+2tyLAHeb68FMbvQXVTDdooF1lk//Sua/5tDjfKMI7uaWjHer?=
 =?us-ascii?Q?ih1ebm7TeYk18VERlOyzcDbSvURTiTuQbNvpmVQBfQZePQF89dKpXfWJXGnD?=
 =?us-ascii?Q?ri5AtRPZFYx5WFOPLw7H1btUrJk4cP5VJGqpWFhQ+pYVZ/TT1R8nVm6KqLlN?=
 =?us-ascii?Q?QxgMGmihbEwMgldopGW8Yjqd2exPz8d5BP3miRmcjSNQALsuMjBzmaQC3b5D?=
 =?us-ascii?Q?v1AFXQKs1GEOn3i/3uhtbyAmfTuYn1JHjkaWUG0+/ImVy8EdqwFI2y/8VBfv?=
 =?us-ascii?Q?TUO9j0oVIU962gL03fpSmXo7Tn5ioLaKoawXNmgzg4vLeT5Q+/zVcuWd1RRk?=
 =?us-ascii?Q?5XQIZXxEP3k/Ly0LsyMwkYcwxLlfDxFBCjC34qsQKsnIkCFDjpm+EIq0NdEg?=
 =?us-ascii?Q?bMnLnJAyiUlIO2p+vlEPhrG1DIt0yLpMUWFaaVNLInhpUygl85XyuEY10w0b?=
 =?us-ascii?Q?6Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	TOjJteM9qtkKeY1IcKlyBbmkbY1w0VIDKyD6OsFdFYYsel+XHJHKsoXjiWU+ofp70/UQ54veP39fZXZH7Kf02BscEaGGEMPOZfT7ajq4vdCIe5yH8TFQeld7L5u07h/PWeq/R1UwUDV6vDQfdZwLebQVsqaRw2yF+3vmOQKwyxfcAHm9ErKALrK2pJan1F36aP12Jy9WnBsn9mjnxQWWvCOg97j+2yqxe3KoiUVQgMCxDR0olqdUWO6LaG3576J2ljYrbGbqrXjfjUvUHrS/PrM8PBbX4meJJ4fWgoyLShVkf8qu+NBxDWw7B4U2US4T+0/uG8Ce8iVIvjPtWGyl0XxHlicUImJSLEZ/Tjzgwo8lwjrAq+DZjG2p0HnNvokCIb3bbmFcf/xhuLauDfRnNCe0zWNbpq2s3rhwBunzoXLaA9CXIy2tLOYwnFrO/v/q8MDY9il0LXd0oKJ1I1Y4BLXBF6RxnE9fCYbbpN87lxd8f8CmVsuzRL4UVMQbiFEgKog3KxNacGVrVCcBXV68ugOwc5wCAtnoD4By0/wRKF25Vk3AlazlDafBKTppOPNhhxv8nBHP5Y12xDMp08dx7hPbfaUx6XNWG7R0XoMo0r0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7d163dd-e9b2-4011-7dca-08dde6f802f5
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2025 12:31:43.3107
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5kg9fS/gTvAQHLESh1Il8Ie4nodJd+TP/JZL6GDou+ZvS04sLln/uOW8FzrNmedmjE3WosoJKqCwkhax5EgfffaDDjQBi+Zq+H1QuicUbmw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB7409
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-29_04,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 phishscore=0 bulkscore=0 malwarescore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2508290104
X-Proofpoint-ORIG-GUID: QpfLnd3bTgLqMAbd2QZaeWOxDlNlI2bl
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODI0MDE4NCBTYWx0ZWRfX1uSAu6kvGuUK
 SiNC1prRdbw0b1/IxSKvLaqUeMO+t/k7RhrXw3p1hdXHXp24qAkY7Wwc3aEdG99fVBIfxesA349
 gcbpyHG066Jqz8MOM75P26vupHx1buOf4r2rnyNS3kez/00DhOCDFOtICTKeO0IIzFchU7OAxhA
 r5lyEH7rwV+S7+HyeIS5CGw5hbvlLGwH/EqHjIZ55oioRJFBsNCUKJ5oXEGgUO+5VMlOtMQx/at
 MJUbl6I+a/Yl7OyYWt+ZhLf91iX7dghJrC7yATb2XAoWvgClmAXjwR0m/xNBRDI7usTUerHFkBy
 AOwGqhgYj1p7kPsZdfmQCmjKxP8deo9lZ5tjvu1vvMWIcZhbwwu1H67O2Ac0K58jVIm0sXjNoek
 Z1mJKzSf
X-Proofpoint-GUID: QpfLnd3bTgLqMAbd2QZaeWOxDlNlI2bl
X-Authority-Analysis: v=2.4 cv=IciHWXqa c=1 sm=1 tr=0 ts=68b19db7 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=Ikd4Dj_1AAAA:8 a=VwQbUJbxAAAA:8
 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8 a=rETdNREuKLJ_9UWFzBsA:9 a=CjuIK1q_8ugA:10

On Fri, Aug 29, 2025 at 12:06:21PM +0200, David Hildenbrand wrote:
> On 28.08.25 16:37, Lorenzo Stoakes wrote:
> > On Thu, Aug 28, 2025 at 12:01:10AM +0200, David Hildenbrand wrote:
> > > Let's reject them early, which in turn makes folio_alloc_gigantic() reject
> > > them properly.
> > >
> > > To avoid converting from order to nr_pages, let's just add MAX_FOLIO_ORDER
> > > and calculate MAX_FOLIO_NR_PAGES based on that.
> > >
> > > Reviewed-by: Zi Yan <ziy@nvidia.com>
> > > Acked-by: SeongJae Park <sj@kernel.org>
> > > Signed-off-by: David Hildenbrand <david@redhat.com>
> >
> > Some nits, but overall LGTM so:
> >
> > Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> >
> > > ---
> > >   include/linux/mm.h | 6 ++++--
> > >   mm/page_alloc.c    | 5 ++++-
> > >   2 files changed, 8 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > > index 00c8a54127d37..77737cbf2216a 100644
> > > --- a/include/linux/mm.h
> > > +++ b/include/linux/mm.h
> > > @@ -2055,11 +2055,13 @@ static inline long folio_nr_pages(const struct folio *folio)
> > >
> > >   /* Only hugetlbfs can allocate folios larger than MAX_ORDER */
> > >   #ifdef CONFIG_ARCH_HAS_GIGANTIC_PAGE
> > > -#define MAX_FOLIO_NR_PAGES	(1UL << PUD_ORDER)
> > > +#define MAX_FOLIO_ORDER		PUD_ORDER
> > >   #else
> > > -#define MAX_FOLIO_NR_PAGES	MAX_ORDER_NR_PAGES
> > > +#define MAX_FOLIO_ORDER		MAX_PAGE_ORDER
> > >   #endif
> > >
> > > +#define MAX_FOLIO_NR_PAGES	(1UL << MAX_FOLIO_ORDER)
> >
> > BIT()?
>
> I don't think we want to use BIT whenever we convert from order -> folio --
> which is why we also don't do that in other code.

It seems a bit arbitrary, like we open-code this (at risk of making a mistake)
in some places but not others.

>
> BIT() is nice in the context of flags and bitmaps, but not really in the
> context of converting orders to pages.

It's nice for setting a specific bit :)

>
> One could argue that maybe one would want a order_to_pages() helper (that
> could use BIT() internally), but I am certainly not someone that would
> suggest that at this point ...  :)

I mean maybe.

Anyway as I said none of this is massively important, the open-coding here is
correct, just seems silly.

>
> >
> > > +
> > >   /*
> > >    * compound_nr() returns the number of pages in this potentially compound
> > >    * page.  compound_nr() can be called on a tail page, and is defined to
> > > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > > index baead29b3e67b..426bc404b80cc 100644
> > > --- a/mm/page_alloc.c
> > > +++ b/mm/page_alloc.c
> > > @@ -6833,6 +6833,7 @@ static int __alloc_contig_verify_gfp_mask(gfp_t gfp_mask, gfp_t *gfp_cc_mask)
> > >   int alloc_contig_range_noprof(unsigned long start, unsigned long end,
> > >   			      acr_flags_t alloc_flags, gfp_t gfp_mask)

Funny btw th

> > >   {
> > > +	const unsigned int order = ilog2(end - start);
> > >   	unsigned long outer_start, outer_end;
> > >   	int ret = 0;
> > >
> > > @@ -6850,6 +6851,9 @@ int alloc_contig_range_noprof(unsigned long start, unsigned long end,
> > >   					    PB_ISOLATE_MODE_CMA_ALLOC :
> > >   					    PB_ISOLATE_MODE_OTHER;
> > >
> > > +	if (WARN_ON_ONCE((gfp_mask & __GFP_COMP) && order > MAX_FOLIO_ORDER))
> > > +		return -EINVAL;
> >
> > Possibly not worth it for a one off, but be nice to have this as a helper function, like:
> >
> > static bool is_valid_order(gfp_t gfp_mask, unsigned int order)
> > {
> > 	return !(gfp_mask & __GFP_COMP) || order <= MAX_FOLIO_ORDER;
> > }
> >
> > Then makes this:
> >
> > 	if (WARN_ON_ONCE(!is_valid_order(gfp_mask, order)))
> > 		return -EINVAL;
> >
> > Kinda self-documenting!
>
> I don't like it -- especially forwarding __GFP_COMP.
>
> is_valid_folio_order() to wrap the order check? Also not sure.

OK, it's not a big deal.

Can we have a comment explaining this though? As people might be confused
as to why we check this here and not elsewhere.
>
> So I'll leave it as is I think.

Right fine.

>
> Thanks for all the review!
>
> --
> Cheers
>
> David / dhildenb
>

