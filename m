Return-Path: <io-uring+bounces-9427-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BF335B3A9E1
	for <lists+io-uring@lfdr.de>; Thu, 28 Aug 2025 20:21:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3F4021B2843E
	for <lists+io-uring@lfdr.de>; Thu, 28 Aug 2025 18:21:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8089A274FC2;
	Thu, 28 Aug 2025 18:20:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Lcsdx0rF";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="tCIDek7J"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EA0A26FD8E;
	Thu, 28 Aug 2025 18:20:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756405247; cv=fail; b=rTytkwIEGh7kuSs6dkFdipPNR2aTP7lvZKMtLtIPSJOAHCoZz3LqYe06w0RWto2d6+fKDz04HMO0EAWQXQD0mSGzPU6iP579wyZaD1V8bCUqYcYqOjMpM3QFHwMosjykwYzMB6rhuINQNeHSRThvI2NOB+rUcA9V/+Xc1m+UQKw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756405247; c=relaxed/simple;
	bh=VIR84sMXfp6dTP2ivlhhPtz0xeWc04oY7QelMB906Sc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=o9X3PFUlHfarne8GQim0pUMJXDJ8vmMQ28qNM0Q1uKEYIX+s2KaZstxmk4B6plQBxFcV3Pf3B4tOs0mBOlcqd3LfAZnkN8uOuoy30ZoSnT5oxrDuCddpd8tuEqCs1NTdD9WqL4QVj2XPpLkdhlDTo/oL49wsYs/E6DDreyhMj3E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Lcsdx0rF; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=tCIDek7J; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57SHMrS4030398;
	Thu, 28 Aug 2025 18:20:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=DcrJWHg4KrF31L+Y6C
	f2HWcEwNLBYuFUg6R/SHgEH8k=; b=Lcsdx0rFzwVNNDvNdS2syl1oJ4mz/EhDcY
	FzBq3CJxQHvyXGkKv1c+/nRM65PVP8B5JmOdYaTchNtHQjWl9WObvQgU0jDudgrn
	vCx7RLadXZVB+/+RQm8QMUk36MvPq6+WkvdDVwmQi+JJODplEkLU3cNoFuN7etzt
	9rATupSPVN5LJYYFDUpxGbNHYaOqvP4lIgz62uTlBkEgQ+8lTMVYyQdPdXCb7wEX
	PJlqCkZtnoKOXYiYCAWeFmndIf6h0ndPOdQ5PnJgjCL1/QoduoXRPIEErkGJ1iZy
	6ArOmSIFmkm9KL3OM1qzq1qlm4Dyh7yRXhIbOTjuQPRoixmYSbOQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48q58s94b1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Aug 2025 18:20:08 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57SHW7Lu005049;
	Thu, 28 Aug 2025 18:20:07 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10on2079.outbound.protection.outlook.com [40.107.94.79])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48qj8cfynv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Aug 2025 18:20:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WkV5T36bCKMqkoBvHkCMgYI15JJnipiv3VnlFysyMhoiwISsMG+unYQiLJyfd10kxDjqfwQ5myeG1P/nMTge+if/12RgN2GEAwksQ50Nhei3Nd5kaZDLPaKjVcJLJ7sTw5kq+pwgZ1L8yye9rNBjKQmuKz20yLQgSp0dMIAlbYgdNEYWxuvArD1RDtPKKd/OSDnkm32PiFzUcnMfED9m29fS+kDQdwD2QH4bwJfgg5i27Aw9uF5+Uj2pnpidcVi2Qc3/FiaC/rDRidbE9T9VBAEMGjoC4q9x4paT35mbBiIaBGhqiggMqDhnsZT2JMmhlwpJbY9A7n7SO0rG1K+olg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DcrJWHg4KrF31L+Y6Cf2HWcEwNLBYuFUg6R/SHgEH8k=;
 b=njgamkRefvwUHRwaVP9zrlr1Cw3EieiSrFciuPBMqRk17vY0KUDyBc0HwWgDlfDX4aD2QLxovn65SVT3ZALJCBjuHEarebUcvvdWSy0NB3RhUP3x1+wmQ48liEtTeDJ4nzGynBIIDQiOxhkpnh3QqmUSHYkexmtxFw0Ich+RZgIviAeDyTfr2ZMOvJJgw+S01YCK9a8nuiRlqem+1Ecb5E8tvTx3d7naxraGTFPmP3paqH7Bxi+enIgztexLW8F1ZhBlhl1/BrIWlRFqQIGUQgiY8o8tjgEchmE+eqhOSupvNmNz/7svXaSI/RVGEJ5KFbCFwIgCBkRnTc9OKNxPVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DcrJWHg4KrF31L+Y6Cf2HWcEwNLBYuFUg6R/SHgEH8k=;
 b=tCIDek7J9fWST96LKdinUbvM6JdxgzDPznTv8Vwsrrh9qeGoo3cLsm4GWdHRlk+Feubh26aDJNwPvBlBXIIP593czTOIpKLkxGjNwKLVLckeH4Nj7HRWwnF+qIRTMRBSiDf75I5Q8b3Y4kMVi/ivfRZ92Mg2Uo9SYF/V5XGcoOk=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DS7PR10MB4847.namprd10.prod.outlook.com (2603:10b6:5:3aa::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.15; Thu, 28 Aug
 2025 18:20:02 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9052.019; Thu, 28 Aug 2025
 18:20:01 +0000
Date: Thu, 28 Aug 2025 19:19:54 +0100
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
Subject: Re: [PATCH v1 35/36] block: update comment of "struct bio_vec"
 regarding nth_page()
Message-ID: <c37fc8db-6a3e-48ec-8587-f7f515314b18@lucifer.local>
References: <20250827220141.262669-1-david@redhat.com>
 <20250827220141.262669-36-david@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250827220141.262669-36-david@redhat.com>
X-ClientProxiedBy: LO2P123CA0071.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1::35) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DS7PR10MB4847:EE_
X-MS-Office365-Filtering-Correlation-Id: 7b3d0400-7e38-4033-dbd8-08dde65f810f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?LVGpi0QiH/NShVFWkUJcGJNim6guvNooX5sDPCkA61nKrrLEWDNpMX5O+qrs?=
 =?us-ascii?Q?J/Hl+aMSB3MGWiAW6plDmob96XITNkkS7Kgml8usX35qrAgwjVLhgeTZzI8L?=
 =?us-ascii?Q?4XdObZOOcuINSIY9Ur3ulnHsu49HMzOOoMRgM88a/XzGnf9caOCi2UNWC2lR?=
 =?us-ascii?Q?hj4k1pehgFAKJFq1ZrBXLmX2yTBq8t75y9jw4Aj/uUNIRe8p+Kh83kvaDs3/?=
 =?us-ascii?Q?8NHy7XjaSYyVPZwBlazixoLanNuU0bHS35mLXiHBHoaq/QjlrWZOCh0L370t?=
 =?us-ascii?Q?wghIj9NMy+mpL9LbQck1dRsvm9wFbWRFHWUjApeBiNe6tmOx+Pvps9plYbuF?=
 =?us-ascii?Q?LvFAXt357uONXNqdILXFRa6jwzmFvYEAdp6HKjz/7yzRInzviBFWCGwsmord?=
 =?us-ascii?Q?fXuz7pIkW/yYA6Id41E6rsZV7gxjyU/0xJRYDGru7VBGY7qfDCPi7aSf3eS3?=
 =?us-ascii?Q?8ZUcRejKziIpAoWwaC57fwGUufvBOlips+UFBdK1pE4rsQU4SgMcHQGFWkRX?=
 =?us-ascii?Q?bE1IyV51wGbF1VbHqcCwqRHbc75tFY3zY5WDNuCgftrVVkZdGzmAgOGPIZsV?=
 =?us-ascii?Q?HPzdYWxvkdSuZqobvo9ggvwyEDA/pHsKXSNA+9DLiKyS7nzMVCI3DLcRA9G1?=
 =?us-ascii?Q?z/BxVrtOvzp7Lq0PC/VP/SQbovO3MRbRBG3lxp+efD6UutNJJehE0CvLVVv7?=
 =?us-ascii?Q?2ykwDH2qehgGkJUGr+R81w5J1mq5sfTWKJrwHEpKeSXLTF9yIZ7DXWSpfjX/?=
 =?us-ascii?Q?FD7SwV8Xh3vqCouibRUrw8Y1ztT0VF3/iF5IXn/kRuc/tA/wBYTFsqEZwqRS?=
 =?us-ascii?Q?/WuprKQ4WjXymWUG/xLZJXPLYQQlywtIpWd+RWII/vK9h+3uFbzunvJrds3J?=
 =?us-ascii?Q?iqNdpzMs6nmoGQnYh/jR/UX3hd/n8k1EwSsKkVf/7TKIXhJ+lNeZ4vQAVMBQ?=
 =?us-ascii?Q?/IJJzUsoQvmBnsUaNZZy2O6RVpOHoQgL+YHqG1WYYoMIn8W2mgymg2ulOv8R?=
 =?us-ascii?Q?G5tS2NUJk3hf/szp5TfMdja1bcbk2yt1bCEtrSG8rHA3qQf0yO8xMubNgdCU?=
 =?us-ascii?Q?rTyCwRmWcBGSBNYp84hnmuq698J9S1/RJBk1wwQSKW4UFs1P7hlT194DqF0P?=
 =?us-ascii?Q?gEP1YWVsuNLhRRXCfvDVZd2ZXg444d44Lk4/PCJfmRlns/WEdEpx5PPmkKrl?=
 =?us-ascii?Q?X4bos3zgbOs7yiTzLEghwDBTFAgmDFO81/jMcgEOnwQy6xQEcFK7AukE2HoP?=
 =?us-ascii?Q?fBmOqBEnGx0gLz34kD0OHNIJA5GwDNGPJQCGI2BQyL+9s0gHrbjsfT+eBhnI?=
 =?us-ascii?Q?Fk3qk15qL5Cr3iXmm9mCVXQdfrMxQTneLqhAlpm8sjKIm65A4WcH09QmKZkO?=
 =?us-ascii?Q?U90/e2DsAKyfQaSA7aOqcPmCy7dfgbJz3xaNmXK+Z69hmp5bYA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?5Z/0P7hwGQvh0FEOLKVPpWaAtkDSRHwfnX3GUGgrzhRCAjy8PRaxmLU6lGja?=
 =?us-ascii?Q?/opu8aDNAwOZTTvyYPVIxeUGtpSZz1pCZHY8j5srNK7vnA+/OmH7tIgW2+1P?=
 =?us-ascii?Q?kYQOddNJIeuueSDruuzghAZen+pLEopQnjXeAMWqMsIOIMa28A5AP+8/pSid?=
 =?us-ascii?Q?+Db7qd7VAY9FZEY6obfPaXJUPanLQ93J8hLndXiX7BMQpD/GsYwvnthmKYrG?=
 =?us-ascii?Q?NMRcGJVd28gM+9PYBobNCH9bez5UdFzRZFJJUcivSmybeadD5Yt27iJOOoo7?=
 =?us-ascii?Q?jd53MAMbCv8r2eGUQZbU77arOHaPhgdmWTXMDb/2HqAUJeU80pD4CnQg3slg?=
 =?us-ascii?Q?83MS9A+MJ4jOGfkH4Hs+zEgVZ5FJ1n3oRyMjsb6w7OBBGbrXttslh3drPxcr?=
 =?us-ascii?Q?KhB3sFjIWpHWRs/rtsA3k1Sh6/xW8Ufj8uFvE+Vt2qN7gM+53DyfT47J0+Km?=
 =?us-ascii?Q?2cDSA+20WNPNKgWWqiByT/nPI19kngKP6zrKOr4Ca70HRnHfacb5Qj2VI8Eb?=
 =?us-ascii?Q?+LD8CgTQW/sQV1E/veviMFdHBHo4Yeqhr9mtqv/Z9U4YtMTp16oAov06IvMR?=
 =?us-ascii?Q?XAhrqmBqffKlwYvMToLckByTw8pyXAiy7BK+st0eReffp7b9oOqBxCicqGSC?=
 =?us-ascii?Q?iG8XEhySU+ZOk3dFeHzTFFYh9/Ig4tn5cchXvOA4YG9hoYMb04RpX8rA9QCa?=
 =?us-ascii?Q?F8c97R7Q02TTqXIf0Fu+UpGRureBKM9r0rT54qSZ6toAR9ByBbRKR3Cp7EXF?=
 =?us-ascii?Q?VOAaFJaM2XYEwDuTKu0m6+vJ3A5N1edpa77dLVSy+eOEpCCUdgbnqBaivjUl?=
 =?us-ascii?Q?fsqjAJHJE8YU9dvQ4Cr169hP/BXB25OuyZsrglLVDtCz++yFrTUIoa+Z3HVo?=
 =?us-ascii?Q?qwh4LweKnLkievVcrOuMW3PPqtYB/2VLmrvVpl3c2k06F5Hkn+qKR38fCwAB?=
 =?us-ascii?Q?ttT/2HeBviPhkaedxlrzaxI8e1/sNmDCAlvWgv6wBuoIqUtV0GuomAiHWIko?=
 =?us-ascii?Q?pwMexj+P54AdiAT445B8cCGrs5/tCUYzh7uKu/03DDdrvEQeioblFpEB4V9z?=
 =?us-ascii?Q?UEEcGh0IFFvswA+dv2l8YlcIBsZrt+9ViKL2wm2y+LkNvkrL0vMMSe2QEhuU?=
 =?us-ascii?Q?hjEl1z0UqvbdiTZMYFGfWyB0w6lu5SwHa0BwKjC0Ed4nViUqHOpjlRDFLRUa?=
 =?us-ascii?Q?Avl9Erm03bJ5l4smPVfPGmCZycJOiidMdAs9fqLQLgswdUWgX18VZqGbwj3d?=
 =?us-ascii?Q?UJgPvmXfQklAzmYsLfhdDqST23aynj5+CZJC5dapIMJfK1ADLMPryxcG9yGp?=
 =?us-ascii?Q?6Cpx3NmODmPp2dr2KW5p8suzVSgLwBzv+huh7g64DRabHDbe13sp0LCf7Z06?=
 =?us-ascii?Q?wyzsmoD3cLX8SjFqGQjAzKrmsSx6FJM3DvMLwPfy/zT1yByMJW8D7Lym5RPC?=
 =?us-ascii?Q?pql8gTgL4uTUtX1kRV7QzW0gvTGXTaISyReBuhvJ2Pf4ssQ3b/5152vXMYbL?=
 =?us-ascii?Q?UbAyfUKWgzOSiO+Yu8I9CIS+q0iozysinreUsgzLrU6S5wqLJjtJQGYq+7E4?=
 =?us-ascii?Q?u4eIGK3Vui3I8+AmSVcRvVXHeOx08L/NLPuAw38oNg45FqCC87gp7ov2IEi3?=
 =?us-ascii?Q?oQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	lMSIL4FrkozA7magkv/9McrXQyzB3EUEW4ETKsPGfFKK1U3p7RgwQ8mRtYNGWrx/oK3LPDN0njVDujTLxwm9lEPQc1tq9ky0Lye8FAr3BCRWKhDTS74ldKNoQN7k4HFb95Lnv5evbatZcv4VlpUPkuJx6t5jOhYK7Mjpp6nG7ePTdn3ipb6Uphnl174PDad5JR9rUnuCd8xPQILTG2ul13CitI1acqiWyCy1DuxLlSlrAJg1ySr8V/oDf4rA8+DAv8pgp/AHNWD/F5BedRL5CXfHSyxBBvN1RLglgK8DiMgoNw+RX3IbfN4AtagWIX2xALA94/nsxJmlGkwh0REofZ4TBud4AAk02obWKJXOe9SKzACL40lCcYmpn6C+/WbWsI5LmH350BpScKIwmfZ4Tj+ToZrpj7H54lcdRkpuVznyQZuBXMPe0dnR2TXh1cGPe4JbLsXTNDw17/9t3+sbs3P611NzRw3AFI4XeAbRPM4LVWXttyTrVo2rs6DwjiYqNxCEFMaCgJWmpl6W0dazKdVTrD0zCxqj1466GXZcw5YTC0BSCpi8Eo7K3EbLt8TCRi4HDPigbmhjW8JooXYbHDH6ubDZARe4LxO8VEJJ+6U=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b3d0400-7e38-4033-dbd8-08dde65f810f
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2025 18:20:01.8810
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 218cXSrrpyDSCa42DLtiwc9peitfjrKT/HkcQXOpXCwks5P1Yj7uLArdPM5VH5bI7a3v1PDQJQazxOdbUqgFU0CIcMjvBkq/rzhXvpb65pY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4847
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-28_04,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 spamscore=0
 phishscore=0 bulkscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2508280153
X-Authority-Analysis: v=2.4 cv=J6mq7BnS c=1 sm=1 tr=0 ts=68b09dd8 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8
 a=zqtMLn23WNwUWXR7bYQA:9 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12068
X-Proofpoint-GUID: H9WyFh2hRduowhk1UsULpmX1Swkl4Sfk
X-Proofpoint-ORIG-GUID: H9WyFh2hRduowhk1UsULpmX1Swkl4Sfk
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAyNyBTYWx0ZWRfX1eY3TruhSM1V
 wp91JdsVr2FORWOJwXqU7qWyM7tzLEcJsiYRruVJ7P0ViIi5hqTGhvNrv128jJRje5LPiQL62wL
 4cx1oMdwF45/vV69U5hvDEcjm0le3xLNzunLrZoWhrUwjOBgDxWpWrNpbD+blmjd7GC+Atf/L4C
 QmU/SbZalIXWRfTTIIxXssF3H02qSgL0g8l5tSrz1iYwM55D2LylOApykZX9KG19KtYvG9Z9vIS
 VjSAAaCdvtYx5bUCEl+8crq5Y4+RNnpKJOQkmy0xZGuconBePY+VrSmITYlKtmVvK/RK9oD6Qr8
 jDuWF3y2Tuu/lDzXrDgVyzlrufA6wRkFkzBMZDK/GTcAx1lN681Os3GEAKXNe1ic2Z7yN016NVV
 0J3nI9EFUuTl9O9l+WpYK23Vs7vL0w==

On Thu, Aug 28, 2025 at 12:01:39AM +0200, David Hildenbrand wrote:
> Ever since commit 858c708d9efb ("block: move the bi_size update out of
> __bio_try_merge_page"), page_is_mergeable() no longer exists, and the
> logic in bvec_try_merge_page() is now a simple page pointer
> comparison.
>
> Signed-off-by: David Hildenbrand <david@redhat.com>

Nice! :)

LGTM, so:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

> ---
>  include/linux/bvec.h | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
>
> diff --git a/include/linux/bvec.h b/include/linux/bvec.h
> index 0a80e1f9aa201..3fc0efa0825b1 100644
> --- a/include/linux/bvec.h
> +++ b/include/linux/bvec.h
> @@ -22,11 +22,8 @@ struct page;
>   * @bv_len:    Number of bytes in the address range.
>   * @bv_offset: Start of the address range relative to the start of @bv_page.
>   *
> - * The following holds for a bvec if n * PAGE_SIZE < bv_offset + bv_len:
> - *
> - *   nth_page(@bv_page, n) == @bv_page + n
> - *
> - * This holds because page_is_mergeable() checks the above property.
> + * All pages within a bio_vec starting from @bv_page are contiguous and
> + * can simply be iterated (see bvec_advance()).
>   */
>  struct bio_vec {
>  	struct page	*bv_page;
> --
> 2.50.1
>

