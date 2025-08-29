Return-Path: <io-uring+bounces-9454-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 44F95B3BAE0
	for <lists+io-uring@lfdr.de>; Fri, 29 Aug 2025 14:10:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F0376685269
	for <lists+io-uring@lfdr.de>; Fri, 29 Aug 2025 12:10:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 517843148D0;
	Fri, 29 Aug 2025 12:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="P1l5O0V8";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="bEdg7kJF"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C3F12D739F;
	Fri, 29 Aug 2025 12:10:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756469450; cv=fail; b=LVCluPHIRwHVA/bkm6yvAoLOi8F37HBclaRiIXrS2oWFQ7pccPb4Lqle8VJRSb85B6LGjtiLQM79pwilsWVY0WpUMNAv+ABaXrYInMB1O4cctkqN0QfofYK6G2Pfz+qUiiojmw5DL2rwcH3jhroFyO8wLufQQr/oIgn3VdsEMQo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756469450; c=relaxed/simple;
	bh=mUki2QRz24dKbsKGswwE6UnmIubSZY9UjlrDShBsH4Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ZicWg6qJMUXy/t3Hp/BtDA5qZbFke/rwKIaEmvOPuDfs8sAXcWsMAD29WTg23vZQl+Ao557hjSurWp8bnRSmKZTW0N3t4gfroZAUHrCukWTYvNkXcKWtpm9jJg9hUif+hQGNgopaUZopPnYgKhBMgy89pV8J/F35HevNmLYROts=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=P1l5O0V8; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=bEdg7kJF; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57TAYL7B015748;
	Fri, 29 Aug 2025 12:10:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=mUki2QRz24dKbsKGsw
	wE6UnmIubSZY9UjlrDShBsH4Y=; b=P1l5O0V8q7XN4qSAUE5W3G49rno7hAxVuu
	iHdT+jeDfGqdkgyTGFQeW+5LbMro/1V3T+f5RJGK5G7+c/rx3QytRxf8KOmir5NP
	B4gCL0o076ML6CQl7PK3DxAM6tQCRS1oXSqonDqiiIm4oVjlSO7+tjGkaFNT18Ek
	NdY+JcX3PHy1rc/hJGRKLKylHIF90CwnHYD+1g1a/KrCG48hcd07rOsNG4rUmuWt
	OBkgnc9YBxuRO6GbR9PLv6GFfF4uaph92w0fWgBj9mxrWSxYFGdlJ3vAa4wIy+mt
	MRZsbrsaTuH53gjGj2SDF9avMdaWA0OB7trUAHyTnWNqJRArOKww==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48q5ptaj1c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 29 Aug 2025 12:10:14 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57TBl0tB027332;
	Fri, 29 Aug 2025 12:10:14 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10on2052.outbound.protection.outlook.com [40.107.93.52])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48q43cwvty-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 29 Aug 2025 12:10:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=h5bAFcX5ZOp9xX0YTaiIbYTTLY4a0IfsXlp0jihGYLwhlhDQZtR6F7QURoSjls9yfzUAfWzV1iaoGqRwQLwxKlrNmlpOLQYLPs/brZG0vXaORDfPPZWbO832VcSUHX8hrAl955xYfsAwJD9/jXKQuW7DwMn9AeDxM6CCEj3HP0wP7e2A95bY0PNJzMlrPJ0Y5heDYcn9qzjl304V7L3T49otm0TpYBR8ar8T35NRda+Dg9iix7eQHkY17xKixoCpx3CfYpu0lw53QQPqWdGUlGoBXN7Gufjd19qxe4oG6Bno/mR51X+Q2sVXMfLBfgea5wEBeW4M0XHgK3ZqQcdtvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mUki2QRz24dKbsKGswwE6UnmIubSZY9UjlrDShBsH4Y=;
 b=VSrQt87kPJWvgYNYsra5tVf31hd/bQV0KTfcKiW7Hhc886WY8Y3IW0D/XHbj83epxWLXUHXPKUPHexnH9tl/WQC3Dv7xty4tsWPNh5Wxc9hc2MzobJ/oZTLlAsJ3g/SNhJJGdIaQbRLyVpjaWzfyy2ZlGK1yX5hIRP9MhOdv77VGVLbxf09aaM9kAIE3g+ud+Wg+3x0xWnvEFPi5l332+qJpsuPfxilLi8Bm9U137OmIwHRzRBWZHX1EXs+2xK66djOdNLmh/NlFyEAVP0zlLmNW4sARQbkQFKnooZxu9L+3wGZtAmaQcXLqKA9SHUjubIn5cJjreOC5gcoDrs2U2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mUki2QRz24dKbsKGswwE6UnmIubSZY9UjlrDShBsH4Y=;
 b=bEdg7kJFHnJ10NNiE6igHvyKxtbTEcFjHA3y4i9L2Q1iNuiZyxKHWa6wMQDNlysh3rNC/rOdFdsQoBXOkkVw36OQnIr04YMrsA5ARiIA7nQ07jW3eczqR6sbUUPaqvxKz6CmQJ3rHPFHUX5YhtLPUfb1Ptuz3l6qETJPpg17oT8=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by BLAPR10MB4913.namprd10.prod.outlook.com (2603:10b6:208:307::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.25; Fri, 29 Aug
 2025 12:10:01 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9052.019; Fri, 29 Aug 2025
 12:10:01 +0000
Date: Fri, 29 Aug 2025 13:09:59 +0100
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
Subject: Re: [PATCH v1 15/36] fs: hugetlbfs: remove nth_page() usage within
 folio in adjust_range_hwpoison()
Message-ID: <5dd50f11-22bd-4a83-8484-2d23bdf5c10e@lucifer.local>
References: <20250827220141.262669-1-david@redhat.com>
 <20250827220141.262669-16-david@redhat.com>
 <1d74a0e2-51ff-462f-8f3c-75639fd21221@lucifer.local>
 <d2bc788e-abea-4453-86fa-daa68e280d52@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d2bc788e-abea-4453-86fa-daa68e280d52@redhat.com>
X-ClientProxiedBy: LO4P123CA0400.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:189::9) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|BLAPR10MB4913:EE_
X-MS-Office365-Filtering-Correlation-Id: 944f638b-e497-4230-fe90-08dde6f4fb37
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Q41ECGeUXhoyJpruvzg8TQzzcVyewoD7khN67VtX3JMRMj29sbcb1Yr6gc9K?=
 =?us-ascii?Q?soz2KRlWMw0AactbvTcJ/3gxw6v99hrzyuRkh6/L1ifJjGfymHW01JtJ1dgu?=
 =?us-ascii?Q?Ue41ev/0gReYPWbzwAATbtVgr/7DytNcVg/2fZ3UIXggLPImvuHWmyp0ay32?=
 =?us-ascii?Q?VKuZhIYTClXAF3m0bRU2D1lheCz7FYnrr7EEyeYCak2dXy1WPTF9SS4W7EPK?=
 =?us-ascii?Q?4dfWATaJesQWQFpMi5n7hW+gvciwdoifii7rc+0NIoASFP3JpfpvJ8bxTIUo?=
 =?us-ascii?Q?abvSjmqxDxb/I0UuHHUyrrzWOBr5DCO40QF+Xi6IUkFDa+86urWsXPF0ZDtV?=
 =?us-ascii?Q?QEzVMMG/6K855qzbBrdktqv7MSNOkhNkuqLgtPlctY/n8kCc7OB+VV6POoeD?=
 =?us-ascii?Q?Y3oEpIx67tkVBsXn8r/2hfOjcwF4eAZoa5Xersi8+ZChK82BCZKuf+C+Wtdg?=
 =?us-ascii?Q?gHQOiQZNv5h8syQ+AaASeYL4+IJMfEjKKLGIUrckaWNgy9dt/880D6aG0WdM?=
 =?us-ascii?Q?Io19tOcscasQ76bTyH0Qdci3fzOhtE2WMoTJ3VxpfAACXu7Hj5I9K7sVA+JF?=
 =?us-ascii?Q?NvFm1ggp05GFfwuGdZZQtvB/LybFJWMqEAW9bF23AXB8OijEtP0yCQX6hd7/?=
 =?us-ascii?Q?V/bCmMSFdvhclfLPDV8CocGBK/ct2io/88cs9b1zEkHyllg+3PxHr+SUtF6a?=
 =?us-ascii?Q?NzEixv6c7GobHw2j+uEbea3sfM43wXsOw9CwVMdwGBnZGoA2tvY3mwlprpVR?=
 =?us-ascii?Q?wyMcMl1pwL594HBxlPpRL8u2yHQ6KSobxQVtQuswd5es+srh838KIOSNm5Ds?=
 =?us-ascii?Q?tWkjeLkqi+KZbCmnbz3DWB9FYedMOujEn04BaZ/invRviv01udeFhPvp8EMH?=
 =?us-ascii?Q?41PjXkFfnfT7Rx3+/yu/sqPEPn+KiFz0rWadvdOFrxhogqZW/k7ugbIPw0K2?=
 =?us-ascii?Q?GKzxsxLfXuAXCcQy2KqO4TKf4W+6J/5B5ZNbKqoUk35HJI0D6TVNhPAWA/+G?=
 =?us-ascii?Q?RtpSj+RyI/7lRPgJxYwv7Lw6lDyDIsIf3iWdBCv3elqtJY6i+X8QFAOr/kFm?=
 =?us-ascii?Q?lVSao8NskV/6TWZbRZvXBL5jTKUd+gRI3klSQs8BvcZ3ywKW1so6yOtleDHa?=
 =?us-ascii?Q?y/GlSJ1jJqieC+v6MonSnE0GgsbaGUq8Jq5K8gV3Q8d2XuPBTe1Z8ZJ3PR1O?=
 =?us-ascii?Q?hsXa9/S+4Z2C99WUBR0fl5O//qyamZJZveCelFxzBQ4qr2U2cS9nIh7/pcSp?=
 =?us-ascii?Q?f5a8SKU6Us+jtcoU//U2sPO1UM7MrC7kNwRBMhoYwqFr5Db6xA641BkyUTtA?=
 =?us-ascii?Q?YTwbK+waxdSJLDV9XY01q8NJkAqLsFDyX1CrxQ0Sw1M5tc6iJBc+QisTcTMS?=
 =?us-ascii?Q?f0+xLc2gpyxRpLKcsa5yRCKNd89Anjcg/9zqpr6Fk3e5kF+42TbItbYdc4Cl?=
 =?us-ascii?Q?mo3ZuKYrnAU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?4zZjzbFtSdbSFJnHSsDNmnt+t2D7Qp7f83tfATU3xvphJpBVCJzzY9E6N1i2?=
 =?us-ascii?Q?00o032FVVDX2EAYxWjgjTGeLt9sj+mRzCNBPvQZ58EI4zrqSHI5HyuL3GiKr?=
 =?us-ascii?Q?7Yl9XL2S9RS7mFvMeXYOOvoxfHrdWM3QrS9iAz/h+wsFXztrgT5XTJzKx/wJ?=
 =?us-ascii?Q?BynX9JcBvzt+xxMzAyyghIqRVgF0CSCilJ8EuM1qI10Yo6E83Th/o4mv93u4?=
 =?us-ascii?Q?yeI+y0F1YHLPZPl3JqQ+o63egeVJBzQm2tUNogy6JPg7thUYlbHUqcJewmWs?=
 =?us-ascii?Q?e3u64XkloM2hLtiDUVDcn2SsQQB1yD0DBm85yg1xh2aW4dgUxWqUqWr/HtOy?=
 =?us-ascii?Q?GggrHzvGAOxqR82yt7gJa/E+5eVIDBL5MvVEUyeu7PXYHiQ4NdD+zwsV6tm9?=
 =?us-ascii?Q?0RRG422sjpbrQcAh+5IBj84cLg7oJmUJmj32VhGh/4Y0/k6xR2PiwCyjArDr?=
 =?us-ascii?Q?JwU4sHCRPyeWRba77fpiIQ0ZgLwxczqAT2eHh61J+OqlOw5baHELK4KgVSoh?=
 =?us-ascii?Q?wFJtDZWiIf4paTWxLwqN4eBYY/9JvDwm0iHamwLL/+ADauQ+BETDLJaV1tI2?=
 =?us-ascii?Q?uzV3bWNqTHvsZ+ApPR+W+xSsKVdnZzHMGrxetx+k01uGC8MF7uqKIQK326SQ?=
 =?us-ascii?Q?JULwGLGH3GvCAuRqDo4LpA31c+JZr8M662c2R1GfDWje3KxyZ1UxVmPma80Z?=
 =?us-ascii?Q?pki7P1MQkZfh75AFdqFjDtek6n0Bh6s0mM/dEfkFu3qnuqg/97D7jwOVCy5B?=
 =?us-ascii?Q?MulB/wW1AAv9d8p2O8nhhcnRSy7VvoAqnzv+oop3OZPthZXtOYBo7/KqyAWn?=
 =?us-ascii?Q?b6CJPa2FtiCoNisouWPNU8JFGmaQRBpl3cSLFyRwF2/KnByu9KRGP5SGgf8r?=
 =?us-ascii?Q?5znRdwnVMdZHgtQiyfXgZF0f/0QOE24LQXnBeOMTNV8An905GMS3Pc2wMZJC?=
 =?us-ascii?Q?RVWSUuqt3kCG1olfIG1q4SebEk1f5FQ6GT6RT8ISaVxcScU/0erDacrzMfKi?=
 =?us-ascii?Q?BInlj1t4t3yq1Oj9Mpu3aA6fHbMlfskn30Fz6e7RFovNqOhzLpoKeyf3Kpom?=
 =?us-ascii?Q?Q/rP6MzxKEZ5OG6FJc94xee8AxIpViYg7Lxel7k9/0JcMDdSzPY4BBJUG9PR?=
 =?us-ascii?Q?yiSv7mMsqHwSukPxxfD7BVv/OmqR73mWenPVeI6M9+yIWfITgyVgBBY1qNt2?=
 =?us-ascii?Q?qzjRsspQ2R5nQKSk7uHey9fWMLdMlkVRrDjxjdcItON6f9RTE7xLcrT0JeGJ?=
 =?us-ascii?Q?1IbZt0/30X6pNZRdl5+Jrr5fPp56ZdKI11dHYrcAxKTUJKmnYSPiQkkrs5gS?=
 =?us-ascii?Q?K1xh+7z+J9Ru0Dh/glDAvV/Rk3tv/Po1n9D21eyw6J0kdstXpkjZnlB4oE7G?=
 =?us-ascii?Q?b046JfqZc5mxugXGW2croTI8Rq2r9ocvOuq7QrD9gigNub9yuG7dHIV8PW0V?=
 =?us-ascii?Q?pxY8Z5IV5kum2iqcsX2ld3v2VR08A4EvOi51V2Dl6rucRnzYjOTLyzfxSOTg?=
 =?us-ascii?Q?9Yen1AgmN7xTF+a5VgYSJyjvB2269/LJty6JR2VAugzIEkDPKjkEQoOwEi0n?=
 =?us-ascii?Q?GTMN9E5tyEZqjhWBDh+lnV2UDMGjU04V0f1VxtKDzOuVAHtmd4VZ2MbiZrDA?=
 =?us-ascii?Q?BA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	kS3l9IioL/LE4gV4Rzg4J8kDd1TRvxp9ZWEC/vvUd7klarP/AarIyDKCCnYCBwB+UzUHh3QJ4B22ZNEfCrlK4twARlolRa2l+4/f7itOBxoOH/g/KnXnjwGtCcD5yfVR+00gPYPtoeerOBQPVNIiqpNyOkwGiyvy6dXS1rsxQmNBha83z+TGQ1J1cAVqdDnW0Pd4/QbF4sDabxIi1Sb0Z8MwXA+PYsrOrdP9GJ7hAbBIzlg+OFEGwbrp9FLr48MzFmqkaDHaSDgDAjsCeY38khDp16qXrEGY1/CdJSghALPWpmAzlA8clSvI/n/20dc3Qnt4xB7/2zQYav7fUcin0IdUhbeJkhU32UI1MeIU937m4koUuyHiegMREhcHczTHwSXz6n1+KvYve4sB2qPYvZNV0h4kcgACGDjpYuQSlKYe1TkKKl49uQLaGPdfzJxVf/aEHW2OPlqe1hhpbdLwKrew6k7YvO0TE6RUEZFlqXdK/pvY2XXpa6vHXGataNDYogWjsxtfG6iorQg6zQ6wTN65yiAJP1Kc+I6Nc5gGhKEjH6Di9dtSVtR80dzDaPpaGiLDk8gRez4T6c1uX6jsVwzoI/11v8zlYbTgoGNZyKE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 944f638b-e497-4230-fe90-08dde6f4fb37
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2025 12:10:01.8281
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ui45Uaembc1yN60S/Q/MZq6640aIJ+0zssBDxL3xLkAPxuXMasDw1YmDmLXKyspq2ThmAvdv6tcFukb41Nb6xzzGGKaX3CMTLzhOwZQvMnA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4913
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-29_04,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 malwarescore=0
 adultscore=0 phishscore=0 suspectscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2508290102
X-Proofpoint-ORIG-GUID: SE7XGkl0ZgpNEp1K7xWfzcifnDl5YFiP
X-Proofpoint-GUID: SE7XGkl0ZgpNEp1K7xWfzcifnDl5YFiP
X-Authority-Analysis: v=2.4 cv=EcXIQOmC c=1 sm=1 tr=0 ts=68b198a7 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=3y7LaOT5a0VcS-3dqRAA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAzMCBTYWx0ZWRfX/b0H430Ujg6e
 /few+EUp7HK2dmZUIXXD5QQe7eslYlz2PdbYMVIU7ZmTjY1O+1irZCITpTHQVVRGwBu42jiz90r
 VFrIzmX1lxD4R7aUU62yxHtCEjzaqKt4LVTzMlPjPW5xoRcbijN1/by6yC4vNPapbUFKjhJT59L
 L3qQGJC9ULkx6PM3I81vOhGOd0+fST3Z3riyalwOQtWcqRAFhju/t0w8p4aLRPDH0Wu3mZvYqcX
 ROpjBAH4OU3r0s8yKF6fuXiUmoV0UNb3BZpdUnlGJYkMRQfWKfsG1nhBBSbUqxm5iDbQam5A6PU
 xiGp6mAVJv2sgDaCmM5018RE6CUuGmJcUuLxEYW6KJi75txNDrY+K8bGOxO3JKqV7f6IJQU6DOV
 7L+ISIcC

On Fri, Aug 29, 2025 at 02:02:02PM +0200, David Hildenbrand wrote:
> On 28.08.25 17:45, Lorenzo Stoakes wrote:
> > On Thu, Aug 28, 2025 at 12:01:19AM +0200, David Hildenbrand wrote:
> > > The nth_page() is not really required anymore, so let's remove it.
> > > While at it, cleanup and simplify the code a bit.
> >
> > Hm Not sure which bit is the cleanup? Was there meant to be more here or?
>
> Thanks, leftover from the pre-split of this patch!

Thanks! :)

(Am replying even on 'not really needing a reply' like this so I know which
stuff I replied to :P)

>
> --
> Cheers
>
> David / dhildenb
>
>

Cheers, Lorenzo

