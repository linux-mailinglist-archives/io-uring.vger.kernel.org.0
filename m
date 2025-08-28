Return-Path: <io-uring+bounces-9408-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 684C5B3A60B
	for <lists+io-uring@lfdr.de>; Thu, 28 Aug 2025 18:21:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A5284167B63
	for <lists+io-uring@lfdr.de>; Thu, 28 Aug 2025 16:21:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED66832255D;
	Thu, 28 Aug 2025 16:21:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="E1aaH6HA";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="WOeO3jCA"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED1223218D7;
	Thu, 28 Aug 2025 16:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756398070; cv=fail; b=hvvduMx5DeuXXFf1L5S5HoYZPlNqAtWoTOdk1vl6gRY+1FxjkVrNZnOhxSr8NESxhVWCVx05w+DcV+BZimI7Qm/DCfdSXSUX7mM+7MQuKkcnWM06QDforADuVTe9eWcShYM/QxpLcGWxVMO8OI1q3zBC12//mgcLZxe5nLDnxZk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756398070; c=relaxed/simple;
	bh=RAZHYuSQh7k/VDtsCn8z+6qTPZkIkbvzKeoE7c6ZbMk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=W+4vSIsnS0o+aXPLHHMeIv97Wj1re+rofXGdmO5QQx005j69wmSvY8PVcg21P7BwA7wIeqCWaeX+YHVC96q+7eWfp23TGuxWVl83xvoUO7kZtlR9pRtuIVuZN8ymcShBPNOGS8CAqg6/+QFxnQXo2PFUhWOVgeK2VmC5UQHQZ2M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=E1aaH6HA; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=WOeO3jCA; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57SENDHJ016420;
	Thu, 28 Aug 2025 16:20:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=Xp7lUKA+KtgGsRXQ3e
	zsLJOkhR6uF5Q/nZbtY+Zn6yA=; b=E1aaH6HA7rVKzpbsGw/nx49M4QSx8tKA53
	ZwRLrlnXaHrYBFCXPnN2YgGzGXdyH1hXXa97g5YDazPzvOS98TRI8qyuZKOIv+5X
	jvYKCo++06JBNAHRHJLgW612gqlJkM/ynnVbSp5RFNIfGCQU3AirfWVWACYVZgUl
	+iexDMcpLXxligP7fy9NEa4XzqxtYY9HHTzrx183NtGHUVIYAGVGa1fQm0uFYNJH
	klBBpKJQTT8nYCB4/thj4aZ1bYm/gshL7FyWf6sihkW7lcsRe8RLXdu7Mdw7d+Cp
	XUauf/rJlHJWK9ZqswIKUuWTUw7JL2RJbIXaKObV3HwDlS2PWAgw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48q42t8r7b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Aug 2025 16:20:33 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57SF52gT014619;
	Thu, 28 Aug 2025 16:20:32 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011017.outbound.protection.outlook.com [40.93.194.17])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48q43c36h7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Aug 2025 16:20:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IrrNkVRSLLlHGx+vtFTCkB6TS0N0LNV9qhL1FXNvrBYZwtnj6oqS1fMH6fNAzn56RbptlZXM+D1A5ejzIZBY5WZdzRdNkMQx+4TJoXbmN7VumZVIpvcnAjxZLq/24BNnTMC24GjrLK0zsli/uq5HkhWdfdAlygCMCFoHq1vNses3mpObfXqzuPD5Je6BXEpxfFLcpohfwbgsnPBGCzIkU8UZW3nzWMlu54M3sIazNsU5Qp2qdvHONbNBQzl97k4SYO/S6TeAGZFaplOecxJfQprrCk7wgompvdFlBOJqjImjjbZTtZET0OI3T8Whrf9UAYlpBGpX+pSzTn8stpyzCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xp7lUKA+KtgGsRXQ3ezsLJOkhR6uF5Q/nZbtY+Zn6yA=;
 b=Z51v7eUcD8rn5nrMmz1VIedHhwRME0lZb01GDTBX7r/azGucT2+v6PV54PZeSFMlQtWCbG15ieytf7E47EGJQI2K6JXDODjXvlimGTjlahoqODImx1lCPAS2I4uxq2Oqvm+MTlt6Lo8NFDYppnENLOs1IAn+o2QLh9vKUf11JxXcfhJ/Pkyo7poP+n+p2y9hJK/h3w1l7OZwbW+6gmxyIwLdCOFcXaGHXvCviPz75AEVHXViXqCxtX+mklYuhIQj6ND0eG3oOwuMdHHx62Y+tS7VGP33CxogPt2o4bf3oZphVPdE/CCxC1ErxY0wFI53/8XCY6kOLrXkLVSwVqTeyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xp7lUKA+KtgGsRXQ3ezsLJOkhR6uF5Q/nZbtY+Zn6yA=;
 b=WOeO3jCAnM11onacvBc34LEPcnbw1bAiZNC9LjU4m5eEzSfYX+4LfKTban7WzExuRVQJFn+3/7belkxKuIaTOVxqTfiIm2MPWaGJbUMndJct89XbjHmGd+f98wzCb9MNSbG5JIWjpPEc7cLskEjdjda9MGlMoZ+/ue7yMmy+39o=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by BLAPR10MB5059.namprd10.prod.outlook.com (2603:10b6:208:327::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.17; Thu, 28 Aug
 2025 16:20:23 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9052.019; Thu, 28 Aug 2025
 16:20:23 +0000
Date: Thu, 28 Aug 2025 17:20:15 +0100
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
Subject: Re: [PATCH v1 16/36] fs: hugetlbfs: cleanup folio in
 adjust_range_hwpoison()
Message-ID: <71cf3600-d9cf-4d16-951c-44582b46c0fa@lucifer.local>
References: <20250827220141.262669-1-david@redhat.com>
 <20250827220141.262669-17-david@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250827220141.262669-17-david@redhat.com>
X-ClientProxiedBy: LO2P265CA0381.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a3::33) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|BLAPR10MB5059:EE_
X-MS-Office365-Filtering-Correlation-Id: 31661a5e-f021-4095-4a7d-08dde64eca55
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?3Rc+d35pXCodKHpt5533xnEfSiu8AoPeDSNO373QcrN1oY3xTGUITGOlV6Bn?=
 =?us-ascii?Q?cVS+LDGrsEMp0GQ8+knthZnGsCDpaZJQHQRMqMXj/t9YO4XRGcW9aRWc9Fmk?=
 =?us-ascii?Q?ugGpGV8T3qVXvTRGuhTrQF4AhY6ApGxCP2UvtIUOQGyKqURlr0w+sKhwuf16?=
 =?us-ascii?Q?bd1To+9a6Wn175uMBETg/NOeIQBhF3vAXvVqsofAv7y/69Hte3b8BwoFAYQ2?=
 =?us-ascii?Q?yAkVJ0mKPvj895yy8Fn2p0uhG/8dwmXqiiMxQsDeNDi6M1yJRXSy/sJ0R1TY?=
 =?us-ascii?Q?8mtXbqVJpsjgmo8Ec8TsnQ4rBlZifeMabIg3uHiCIMKMDox7XMIjulDZdvFo?=
 =?us-ascii?Q?PmhZRZkZZvJm2TzSwy1gnOGBz8gx0bi/R/+DIL2j5OBIyN9/63/8E0mcvUnZ?=
 =?us-ascii?Q?OVK+xzSAVyJ2W14qE9xX5uTXHrpZnxLkt3wa36eaDFoEEoFZmFPVC7XGrsh/?=
 =?us-ascii?Q?cPHyUidlnw+9sK0DpPrIbFyDfg7NqKtkZycFfcIISSk7MPWPHiLbSFIoTKPW?=
 =?us-ascii?Q?FfMnoGvglkbfPliKEXThAAxMQdRFyLJ0P/QdommE4/rtlEQEgO8t4q/6KARq?=
 =?us-ascii?Q?f7M6HtShfcdrYUlQO52WsVdny+FEEzmPX2p9hU+UzsHPmORcQ0Db/INFKU9I?=
 =?us-ascii?Q?QcSt95jNkn37PtBlJmciw0a+9EcbxcbAU8qF4KZOVEjrwqVERHAVOosQl5ke?=
 =?us-ascii?Q?D7GCU6o0sTBT4xhkT8wLDLqHryvjQ1/b/3lqHBuf/i0cQ0FqTQGwtluJxe3L?=
 =?us-ascii?Q?3iqM6/9M+5/wejJ99vAR1P5Lcc8XOxHMjY6kVtKOcSdjVzI5REWPUWapZBEo?=
 =?us-ascii?Q?6A2GGFIHI/CEbMGcb1bmMGt/98k2Jsqm/8d45ByinRYRvhpxU1zEbUksP8t3?=
 =?us-ascii?Q?LrSKfA+pHY2BiYc8j2bMzmt2vTi/dmRAiZdCDm8zCMmX+ctgGvDwbOnngFcd?=
 =?us-ascii?Q?eqaJjAIDlIUP3hwMKLC8rdeXgFRAa8porZjbRxqWCPXiEuPi/XuginaTlxNv?=
 =?us-ascii?Q?Z2yq39Pm8DM20VY+OU/AW77pXFwGBDf/02gln1gKGrgnAvlddH2Zo7R60wQA?=
 =?us-ascii?Q?Ltit9OO8PO/KrpTZ466pTCv70Yvb4VFYFR5BP3B+OBCcGToKk92yO77OW74V?=
 =?us-ascii?Q?Fvh9QRNLPskfRSxBNWw9HeGwcV6gqzr9CNmuq2pDoeGX8XW+CkkA4VKsl3xM?=
 =?us-ascii?Q?nB5GzVvTEp3Mu3tnQjoJVnvL4IHod7QCmFTEyuVmsEbWzPm/7AiXrTAHhRss?=
 =?us-ascii?Q?mmR96aP3U49xjJcNMKPDWOWf3KkUgzXlkH1aGUkbyANlryE9KigaaWrjmP6X?=
 =?us-ascii?Q?hsUZJW0TuMUjlutxwi6y1WFyh54Hq6EZ5qXSN/vR6aW897p5PI4RaN6Qv8qc?=
 =?us-ascii?Q?fcVfBaMHcEHJyHmphJgJwMs2lEfkdQG16IptC37aUT1AEXcuUIG9m9ojHY13?=
 =?us-ascii?Q?KGAZ/P6+1mw=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?mbxtARXl/31bS/t4xoQE2XVNmEOFi44Vczjq1MRodPHAi+eGqbll1ZgUrJDa?=
 =?us-ascii?Q?xMBwpLQwd0npxkWCPZuGzMSR9V7RiehY4CRkb2rP1OCl3Yx/THgQn3/ZKldZ?=
 =?us-ascii?Q?bTmCZEqQc1bv74Wux7FynVVFTB+bDT5fTmZ6p8vTFd0fozrc24mkg5YXAY0c?=
 =?us-ascii?Q?DsaSXd454sp46siCzwTiP5+Qa1bQv65Pq3fM0+4jpqPskTes9BqfceI873Nu?=
 =?us-ascii?Q?63IKhf3dJsoX+RBoR294w53yfse5sTku82UGEgnrhBpjaLkMdyOMS3NgSNCQ?=
 =?us-ascii?Q?2H7kXvkVMzf82W86thkKULxBxNYuhnHuCH+FyU6Lyl5r5HWCSkY4hUpdg7go?=
 =?us-ascii?Q?0cgVi1Cr8A6Rkf0SZ4+cvy1XUgFqEgnrSYA8Mh8SH8xrvAl5dolrpGG0oCBQ?=
 =?us-ascii?Q?iRIGR6V70AWBUPdmKlsQd8UZPvLe2LEc6Bm7jHiRzVEmTTwEvZ5fJpqTwsp0?=
 =?us-ascii?Q?o4Y4fPTliW2h/XnWBnbyZRYSVgRc4J8sEgCc9o7R7NIQv/eMgLsoK0BItw7P?=
 =?us-ascii?Q?zJnojubhBdN/4ibyxdU5XxaoWFbA4KtvZ4j4bRqhGmLYPiMtpwfXOEfO4rqo?=
 =?us-ascii?Q?hlR+7XnNmVqJP4b9VfHo+ZatmTu9ziReqrGXcNOJisKqjdVxnBQJo1lL8CMI?=
 =?us-ascii?Q?oOwA/3jiWzN1j0boneRsLd7sjkQtNnsGifVRlM7KVXfqTOQt0VJlt/SGI6my?=
 =?us-ascii?Q?6xWWlV2mfWXvyzTz+j4S5imR2R4VVJ6FAlfBE4EZz4Py5uDO95PdozunQAZk?=
 =?us-ascii?Q?4uP/MHMzATLotLI0JGlKMVPs+RPyuaZwTinRItkEGVH8O3973Gwdqt6zTY0b?=
 =?us-ascii?Q?bOuopnSpHTUxkF+rieMKONWmcZfBviV0ZDUdpTsayT6YZMxBGpoPHV1tNVd8?=
 =?us-ascii?Q?jCMzuWxnfEBDZkp/tYBLByAaf3v4opIx6mBD+nuSCSeyxEHFpvr0Ll/yi9Uc?=
 =?us-ascii?Q?0f4WWA47x5Zxtst6cVgdV3qqTe771ymVslYyndr84Apqp5Nz/tYZmwICUWuh?=
 =?us-ascii?Q?3rkA96q0gK5OI/jkh6EyWv50H2ZyNI8gV/1nqctk7qjaGtjn4QE6NGyZ4ySa?=
 =?us-ascii?Q?zBCZ6Vi+MNM4f2t4R0Pbp5lpbrQOHGHGibDwj6MDbMntoQppHr19fOwO6L/C?=
 =?us-ascii?Q?YDqyBdDrisKxpWzrTWZ+CqOb/ndBrgJcpdDashKO3xKKYihDZ4JdethBUuoo?=
 =?us-ascii?Q?2DHUNJKl6UzkAEE1SlNxOFhdM0vlDh/HobkOk5RFE0+TqRwW5CZ699Bxsi0p?=
 =?us-ascii?Q?ml6gmeKiL67t5tkypp7+LIEy/Vh57n3GyhFKpnP/9D5JtbMOxAjg9Xewz3b+?=
 =?us-ascii?Q?b0JWD6WeIb//yWyZ0OLrqNFLFp/qtwz652B2uz/4L+LFl7837G5cWe7z/gJI?=
 =?us-ascii?Q?iKvDkoyxMaeAi2Fr7LhtyUqhx7WKnppU5WzdjvHuprICgbXYjhD+lOCJxme3?=
 =?us-ascii?Q?HQKCW3ZSj39GN2wrVDEKQ132Q49zFCjY5yXgTVDZ+8xJK/1kLR+HtkwWNPCw?=
 =?us-ascii?Q?4CJ4JUZt9M4QsYjR1SiHNyBos2lg3yXbnJIGiRM8GQibwtwNENEnZh9ZUNWy?=
 =?us-ascii?Q?RsXHOYowYXjfayLoenYFBsib9CWLHN5U8wCbiFbeju8f45708MDLGjlR+uDC?=
 =?us-ascii?Q?tw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	YkrDIVQz93RAAUrKrByyBvfi1DF+6WE+B7lO6Gd0NLiWLdCcOCopXdT+YGQI146Zf9Ul9rZInIPMKlV+aWoknFZWCNAjuiBT++iDamKzvRQJJfyyAdVKV0jE0u4qRxzylEb3vjZN3H/TjJFMD+lTL/9Z8Y2lF0dL3VabmdGJ6Sh61IWcdvZWzu4x9dH/EtqCJHFHgW9s8dFptgOs7xYhhsIHxW1llSL8h88hpl1jOpI1owY6s/txaMzSCMNi78p885bHEsMAyy0ranY6U9yKXRkiRyFhnuJSe6zsI0B8d+RMeDJMWGQjB8sg9BnOiuZNJemzoAA6oFNk+xzI6jePf2HxalK7xcmjpjPAl2ba8GazYamOZsLHUGWuxqYuq9LNAh5SrCI3YpJslJdu83P0kUN13YKXpNzkDfh5HG3uw5lQSqP6KirIjM3dJ2vDDKy/uBjpWGW8Y2dCtwV2cw7YdjvQ1X4ODgBhTeQWNr07ke1KILjfykJ94+rQaU30+5u5yoeP1ERFGYH2GJbhM3gag1Wrzh1aXOFxWdDOx76reWsUsXVaGsDXzfQDc5YMdPK57NwHu7e0JquPjJLA34k8c1EQrO8kkVz3M1iYOZBO4Nc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31661a5e-f021-4095-4a7d-08dde64eca55
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2025 16:20:23.3581
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d0wrPpz88LMS0ODpa4F26J3Sgoy7GWK5hvHb8Hj1zXKPYRzhENpSeGGI/rbk1tD87PYnzYnxWjggApe7FnN6c9ipxAgBuQSL/2Wwuu/3UfU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5059
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-28_04,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 mlxscore=0 bulkscore=0 phishscore=0 adultscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2508280136
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAxMyBTYWx0ZWRfX9TtFJgHraphu
 ZXY50YnYlmWaUWQvcqUqPAYzpSm0BiKJrNAyaEoW+uSDglAS+PDPkWyM1WdL93o0ORiK4o8epKX
 krs86y0tljmiTP+pxX7OHC99vfab83ZanTNRqPP0kUT/4axjvdnRXH/KCnojVc1+X3FYSyxqElp
 3uTGzsW6ug7XuAG7mRkrF4EIqa7yzADrqm1G1m0vy5OJfAXOpZTBuvUt2N0oBdR6LoUeTgj60/0
 VeDAkbyoCij2gCi/IOloCOoUkiXaucNEFG/s7UKjjFFThsZuunfJo7DE0YVBlTroJdzG1S46mVQ
 M7A/8444vtpASGAaS4nhFaMtdjjx7GjbyJTlsLi0q3cKGtRhikM2s1QBN5328LOB5whsyXNdgXv
 b3GGYFA7Yriji1eo9eKY+79fzlL6kA==
X-Proofpoint-ORIG-GUID: 4PU-sQ8P4bL0tqdmPDlrRJJhLDT8MNzk
X-Authority-Analysis: v=2.4 cv=RqfFLDmK c=1 sm=1 tr=0 ts=68b081d1 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8
 a=qYJzKVg878kw0ASOTM4A:9 a=CjuIK1q_8ugA:10 cc=ntf awl=host:13602
X-Proofpoint-GUID: 4PU-sQ8P4bL0tqdmPDlrRJJhLDT8MNzk

On Thu, Aug 28, 2025 at 12:01:20AM +0200, David Hildenbrand wrote:
> Let's cleanup and simplify the function a bit.

Ah I guess you separated this out from the previous patch? :)

I feel like it might be worth talking about the implementation here in the
commit message as it took me a while to figure this out.

>
> Signed-off-by: David Hildenbrand <david@redhat.com>


This original implementation is SO GROSS.

God this hurts my mind

		n = min(bytes, (size_t)PAGE_SIZE - offset);

So either it'll be remaining bytes in page or we're only spanning one page first
time round

Then we

		res += n;
		bytes -= n;

So bytes comes to end of page if spanning multiple

Then offset if spanning multiple pages will be PAGE_SIZE -offset + offset (!!!)
therefore PAGE_SIZE And we move to the next page and reset offset to 0:

		offset += n;
		if (offset == PAGE_SIZE) {
			page = nth_page(page, 1);
			offset = 0;
		}

Then from then on n = min(bytes, PAGE_SIZE) (!!!!!!)

So res = remaining safe bytes in first page + num other pages OR bytes if we
don't span more than 1.

Lord above.

Also semantics of 'if bytes == 0, then check first page anyway' which you do
capture.

OK think I have convinced myself this is right, so hopefully no deeply subtle
off-by-one issues here :P

Anyway, LGTM, so:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

> ---
>  fs/hugetlbfs/inode.c | 33 +++++++++++----------------------
>  1 file changed, 11 insertions(+), 22 deletions(-)
>
> diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
> index c5a46d10afaa0..6ca1f6b45c1e5 100644
> --- a/fs/hugetlbfs/inode.c
> +++ b/fs/hugetlbfs/inode.c
> @@ -198,31 +198,20 @@ hugetlb_get_unmapped_area(struct file *file, unsigned long addr,
>  static size_t adjust_range_hwpoison(struct folio *folio, size_t offset,
>  		size_t bytes)
>  {
> -	struct page *page;
> -	size_t n = 0;
> -	size_t res = 0;
> -
> -	/* First page to start the loop. */
> -	page = folio_page(folio, offset / PAGE_SIZE);
> -	offset %= PAGE_SIZE;
> -	while (1) {
> -		if (is_raw_hwpoison_page_in_hugepage(page))
> -			break;
> +	struct page *page = folio_page(folio, offset / PAGE_SIZE);
> +	size_t safe_bytes;
> +
> +	if (is_raw_hwpoison_page_in_hugepage(page))
> +		return 0;
> +	/* Safe to read the remaining bytes in this page. */
> +	safe_bytes = PAGE_SIZE - (offset % PAGE_SIZE);
> +	page++;
>
> -		/* Safe to read n bytes without touching HWPOISON subpage. */
> -		n = min(bytes, (size_t)PAGE_SIZE - offset);
> -		res += n;
> -		bytes -= n;
> -		if (!bytes || !n)
> +	for (; safe_bytes < bytes; safe_bytes += PAGE_SIZE, page++)

OK this is quite subtle - so if safe_bytes == bytes, this means we've confirmed
that all requested bytes are safe.

So offset=0, bytes = 4096 would fail this (as safe_bytes == 4096).

Maybe worth putting something like:

	/*
	 * Now we check page-by-page in the folio to see if any bytes we don't
	 * yet know to be safe are contained within posioned pages or not.
	 */

Above the loop. Or something like this.

> +		if (is_raw_hwpoison_page_in_hugepage(page))
>  			break;
> -		offset += n;
> -		if (offset == PAGE_SIZE) {
> -			page++;
> -			offset = 0;
> -		}
> -	}
>
> -	return res;
> +	return min(safe_bytes, bytes);

Yeah given above analysis this seems correct.

You must have torn your hair out over this :)

>  }
>
>  /*
> --
> 2.50.1
>

