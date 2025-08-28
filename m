Return-Path: <io-uring+bounces-9424-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 410D1B3A986
	for <lists+io-uring@lfdr.de>; Thu, 28 Aug 2025 20:05:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BF5E7580C6B
	for <lists+io-uring@lfdr.de>; Thu, 28 Aug 2025 18:05:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F3ED26C38D;
	Thu, 28 Aug 2025 18:04:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UQBBgUx1";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="h8g2otnq"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FFAF264609;
	Thu, 28 Aug 2025 18:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756404241; cv=fail; b=diQLMaiV+KS/LcPyCQX4rwDh7nkQ7cUVGXHnFFp8D6N5qDDMoSiZnaKk+xgHCyf9TRs/0Ev4UwoGTfh704KG3wEiiu16ZDWEP9LnDUJICkK+YPKEmiJUH/2yomy8XK1XARBrCJTP1KyOfvL8qmhkKKiHGbfAnh+hMWpvyWUB4L8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756404241; c=relaxed/simple;
	bh=E1rz64jN5TzrUxddc9MbNR7hHKHw1srPY9LdLyc1F5g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=jBj2CRVRFdmHIoJbQTJLDderHVmZux+/EGhGbdXT+oFtgfetfayP5QJEGl23UaGmjtWcFEAsO4ojX/hsJAOttBMP+TbFI84gAF3uTx4g4EZkI7YmlN6asJ/uO4Eo4r31Zf/r0yr/fdWwA6pV6X73YzdftrlYqPmad3Mg27HJ2Oo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=UQBBgUx1; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=h8g2otnq; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57SHMq7v006549;
	Thu, 28 Aug 2025 18:03:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=+IlMzfo8R9Z8vQy577
	0WotPbv/824y71VpiLgnIKk2M=; b=UQBBgUx1iIaLEA6hJkvjG2Lk1ZCnxJ9eZE
	bbg+zSGbqo04t+2E2PNnUPoljDd0DfVNsmYZhqbrdQA0FxTAktf12Dd2rWJXB4Ig
	DYk3PgHWUVqVE60pEBDkFI4gOJs7shgncv+OHntxWtwRD5lteDZD75Om/tn49Ow6
	IypFfa1uPdyGMF4+pq2qAVmToTnHPtGGe5PsdyLGKd/Dl51401xQN6ByL/suG9uK
	iuchwpKnnqaHIqoeiUNmLCoMBNnPQMV/yqEZg69FYY4mqGSoCJA4TrVvxlyO+XFI
	rosCK/Ol+WS4Q//P9sDl0KKKf/X5aKHiTQFBnIWr1wm4y4f3w5Ng==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48q42t8xtw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Aug 2025 18:03:16 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57SH3I61014543;
	Thu, 28 Aug 2025 18:03:16 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010037.outbound.protection.outlook.com [52.101.56.37])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48q43c79ch-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Aug 2025 18:03:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HRN93g7P3K2CSfpTX27ynje0YJLudWzDS8Z9ytJQHFAIvoueT6GNB4oUnsLV1AnHJZIr2fjFv/GFNrneDDir7ToK7iP6emf9cncX92/D4sAtl7Ue6sDFbF8Cn/LFWyB3paNXGYiyKEwheQ7mmAYV+lfjKHh4t4QHD8yLIu7IywuH2dtXeM5yIT1Tdy+l5+lEPVq/WAg1S4OJgPEkPaInJqYt3Zdo2wV1/jiRcz0ANFl+xijmVDWiJQ9UkGW7gSusGgBNDS2nfyLlFyZNGER/UhjWfpSjenr/VM/ancu85VkBFTL1LPCRjZcyS7nJM79M6e8A66lyYiARSldTMSibeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+IlMzfo8R9Z8vQy5770WotPbv/824y71VpiLgnIKk2M=;
 b=TM3bWdfiq/3RuAYyUSEpOUpJHWiI0ELt1nGBPNajKYPM811SVyCrlkvyCzV1ETo1/clZjAyiHdwBIMb3GvyQRuYy0jEZg6BKpFA86EVeXZOI4xf07gnE5e1f5++1VKiAABARFcponPSqV5eG6B74KMh7DinoSgMmRgrK5qFXPzPhBehoKLQc0xra4H3l0ABBthv/5ZpZ9EIn+qz2NDRe3RO1ofJNJ782i8i0ed9iO6i9PXP3BfpmHR4aGLCU8amL8uLMsVtXT/9oz/o+hMNAdPbYjC/5SUinoRdCHCG3O2y2pdY6FVzZADrvaR6938IYOjS0tOBx0aJMU5T8HpI8zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+IlMzfo8R9Z8vQy5770WotPbv/824y71VpiLgnIKk2M=;
 b=h8g2otnqVzZ9hO72fWO5G7AT60gQtQY4hmsU4uJ69HzhkdNOqP+phh6GLMz7oIaptFW6a97aJOLGBE+Hu6TGCRkUMIsCHbemg+cJDdm5Ptu/pvL5hpwZyP+pn/UMbbZXrExWoaqePRTT2F9m7SplQyakHJWStSS3rmU3Zg8nm2U=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SA1PR10MB5760.namprd10.prod.outlook.com (2603:10b6:806:23f::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.17; Thu, 28 Aug
 2025 18:03:08 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9052.019; Thu, 28 Aug 2025
 18:03:07 +0000
Date: Thu, 28 Aug 2025 19:02:59 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
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
Subject: Re: [PATCH v1 32/36] crypto: remove nth_page() usage within SG entry
Message-ID: <9bfd5683-0eb6-4566-939d-fff01454849f@lucifer.local>
References: <20250827220141.262669-1-david@redhat.com>
 <20250827220141.262669-33-david@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250827220141.262669-33-david@redhat.com>
X-ClientProxiedBy: LO4P123CA0144.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:193::23) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SA1PR10MB5760:EE_
X-MS-Office365-Filtering-Correlation-Id: 536dacb6-64fd-4f0b-c1b8-08dde65d249b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?W5JBK97xaSeA5upUXDWxTiIgHOYXx8JRLDHCw2sNCjs4KWE5x96++tB9jVCg?=
 =?us-ascii?Q?R7PzpDztX/RncjoTGmer0JIBNht2j3bOs++KAFOMdyMB41mCGAdf+RKZFv1y?=
 =?us-ascii?Q?GHtey/LVPCrkW2GH2GKJxwYzYVNnd9PagakjyzLMF6ydf/SAWC/G5z76V/n6?=
 =?us-ascii?Q?XP2LsB29lVWtcQWxK6CtIjfBuJlg0lfXmlv3xLUVatHnNeT35Z9huafW/mPT?=
 =?us-ascii?Q?ieQ4DOpK6gHjdszAahR89DZfyfLVqIwRLWqf84FOWAjE+816NeerJT0UX+XX?=
 =?us-ascii?Q?jwDzLZj4PjHyBKdvW4UD2pcCrSi5KSxCU1ZU/6uBEBzphBYZ2dvfN4HDwRwl?=
 =?us-ascii?Q?0Xjr/spSa37BE1AByH4qzBpD59Zfxc60ZCOla5R3YZRI4+KigA1wZXVNeDyz?=
 =?us-ascii?Q?U0pmrHbsB95F6omaDPVsAfoYWLtARVkeGC8fnSeimQfMcRLffqheb5b3kReh?=
 =?us-ascii?Q?BplZROc4x+wGSSv8JPrP5xrBLh7gVYFgoV6b2PFLfuwf23PysWEjLiRhqh3B?=
 =?us-ascii?Q?XRp99A8bZ44RrLsefKmH5LVOayy2dZST/T/iKnEdHHeTPYinx5bDt56MmWom?=
 =?us-ascii?Q?p5vxH++q/4Kqc2r4JSWgJBpdpjiGkA0dVAf+Yujpq/LNsz75Bn2coy7ddzpd?=
 =?us-ascii?Q?k6auSX/zhoL31Wq8GT7RmD1ZyMXnc5ysy0bDs6aBecmqdatlRAhQkWJChEpm?=
 =?us-ascii?Q?nD6l7LPuuZ5OMw0MeDsQSr6q95fSVqEUJzcqJuGnX8vrqe6fAYltZ8HuO/hK?=
 =?us-ascii?Q?f4+9BW/YHbsJN9ABfsbpWUjJ0n+yfA0NHS7aGL2wiv3BeRJ7EtsqZ8yEtgKc?=
 =?us-ascii?Q?pcF9qqtr55BnZtkvJWFI3kPQBEmWKkP8In21GPdl7MPUc+mNW28zIKQPe5Np?=
 =?us-ascii?Q?fE1guAubBzXVinUMfl+rm6cr+0Wd93mjZVHEI28tflNzNu3FyD+YhaPHffEp?=
 =?us-ascii?Q?ED2VDOA0utYJ8E6LpnIUhqQAaYMRC/Q5Sqpp3HAja83BPCmSF9hGJ3STZwQ9?=
 =?us-ascii?Q?FLlT4Y5iTrLJPmfhbUc6aayDR/nsxnBNyB/qPTfEb7GZ5SLkLpJZQ9w0svBW?=
 =?us-ascii?Q?irlup16kXIhqfOp6kgfUfMBY/1TwL0Q/excYR9kC1YKVOa62LqiIYRfgYPUO?=
 =?us-ascii?Q?z+5HYgXMbZmC5vONxHDJJ+N2KwS0w65+UvrxstfWSkC45F44lCYr1GMa/mtp?=
 =?us-ascii?Q?Mb4XnAscEFeU4JIvODDiEtpkqLtkpJa6d4V5d4G190rfgr8WJOdgHF6ZSTv8?=
 =?us-ascii?Q?yQhXxmgMxEEAHFk6Pg9rga7WJbmJu0azXiZEc73Ku5HFYoVm17Pps2o/H88f?=
 =?us-ascii?Q?AnGtC1Na8oeBIY/cFcArybQbe2lboaFsM7UJfoRTzo/+Lp7CHDfmxafE6Xua?=
 =?us-ascii?Q?uxe5BM3WnFI51+5CCk/ELj/wpOzeG8LZB2ANSX0oPWEsMrQDIw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?jXfATVIjLkydZ4jDzpoLXt028NxjEtaGOg5tmBtjbMokTjqj8y5a06Q/IaSs?=
 =?us-ascii?Q?/6sLoXW3vszUlZYLrkJeFCLTAvH1Fy1YIndQbYpd68pf/g8tAqONXsuRxd5i?=
 =?us-ascii?Q?XWGzMuy14LOZS/RQREzbM+BOtA0mpv3I3A/XFKjpWWyowVoHY2bMHo1dqqAO?=
 =?us-ascii?Q?JRrrY3OMuId3+R/5u2mUrNeWJxXdUQcM2UOHpnkA61TLrIjLg97R1wWPb9oP?=
 =?us-ascii?Q?2bh5WijYPQLHokCAkNXwFWhcFjpqf6OvQvwWJNZKC01nHYnkTxDjH9r+jkSm?=
 =?us-ascii?Q?laW+Ppl9kQoOfrVvv5eRb1nDI9yfPGR/KGteKeT8w3YYku+MP9jiVuUtrzyy?=
 =?us-ascii?Q?zyoR8XJso3Bq0VxsLdbY9jz+ndintP/QF3RC3V+2bQHgYYTz9U0s564A2Opf?=
 =?us-ascii?Q?VxekYUuBWTZcA+LNtBD9kxoHeSzkpaiBGxQC28WU6MkasJG04mgrCGzs0e9s?=
 =?us-ascii?Q?tL8EzNnrmpnvUg57Cqe3ZN5+VclsoqsevEUnVskEVwXm8OwCx1tbSugykDmw?=
 =?us-ascii?Q?20waUL0+8mKq6HRUVGuMPGnitxfHdCMlaxWvXvBjhmG6rzokkVJXcKYq2Z2r?=
 =?us-ascii?Q?VJOZivq097eEJ1ub4PNXQUy3EvGB3HZgGIb00NIOOXz2QnUysEcHOkfjeVJc?=
 =?us-ascii?Q?/7zFyGOwOE9+OJ5AJDSH8HIKrfRXMlWvd0xT+HRzBAuL+Ys3FCV5yQV/BYi4?=
 =?us-ascii?Q?aSW7ab4BYnb0NrAKrJM2zZPKoET17SA/59M/MxlcZ7LLKd3SptDylAGGBGzn?=
 =?us-ascii?Q?zkrPSj7xksgSPzVIbz4wmROLOdB3v11fbFm4t+TW8pZshWjRgW068WSalekQ?=
 =?us-ascii?Q?+bwcc2U3yyiZ2MtKQwBQhhX9KgrfWDDwNjKRlAMrrsHCXHH6BsZBsNU7Wn7m?=
 =?us-ascii?Q?wsrhxxxkpQTIqzIQFOpNT0HXP70Iu8mOJCjCRrmzfUwlwR499Wn8SWU++IK9?=
 =?us-ascii?Q?GaPQD/iiNMjWHSj9+e4jPjX4PPPdHak6QCVNDmR8q/W7gHRHwQviH7w5XUsK?=
 =?us-ascii?Q?zMuwBPMKSOgXgA+LGt62Z50hZlFv7COQA4/ze3QzVOoWmzgoTq1r8EUCU793?=
 =?us-ascii?Q?eQOAkrMBx4s4xU0L6wcZWpsV50vo37tP0TNoW2J6JfO+yKpWiAdKC376SoaW?=
 =?us-ascii?Q?nooD13G/Ig2/0umKB9U95CL6WF7JzG2xsvUjgYISd+ZpBmkLTuFzOw579mhh?=
 =?us-ascii?Q?LxKILmMru+L77pGwhDNrvE/sxUvtjYkpNWnus5UJWtOy75R103ZAbxDOOHFR?=
 =?us-ascii?Q?Qjh3oNBRrnkD+ol7hnaMsN8Y71J7gKZFn0BMUREmFr6Pauc6sC7POhgCiVTi?=
 =?us-ascii?Q?SdcK+z+lhomXNyBjfkolIIN+q04p0qY7Jb10wQkosUtpfSvm3yV8lgBztGVN?=
 =?us-ascii?Q?MrCGNLm1hTDcIjJj3zuReh4Na/LGwGbe/s1bIs3M+QmlnFwZXrNVv6ZX0yKT?=
 =?us-ascii?Q?UZPluWdtIksWVKVEkK1BzrJRZQD3kuCEXzvmWJtiSqRLYVxi3XQw4XL38v+N?=
 =?us-ascii?Q?8IVCKyIqaNHv5yVLJTEVsZnGgan5woCc7x4lYm7RjPikObE+DwM38u5y7Ktq?=
 =?us-ascii?Q?565S7MT1pvDPAPSEWEiYAMXfYZ22s3jtJqMCn1ubJA47rPur6UUUm4KJPSYC?=
 =?us-ascii?Q?rg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	8F7KvjIJP6oBjeu3wCHYcnrzHMOSMjb8j3fB4Z0Y6TbT81k6BtqNr8mTBNz50JXmKLGuICg/Z5Tcg1Vs/4Su5LGphakwMHO68GLNLqFgBv4eeuziK2LsS0IspzyVi/oQ0jKAni25y557TJAWyjoN0C4kr2tHLg+AEFDtIlY4wab12S2wY9CZrIWn4sl3BFZzs2PxENXoKCm+z9wqacdbfqiZNbb/By5kbsZ3eMre9GsUblbBL0WWKOwwltwVoAnvgqm10n2GGv7y2xVu2GK7eYycZaYcLiEVOkwLU7vV4iZmwgrrwDU3zvLyW7vC4GuGIOK0vZnJYjF5V+/IPGYZMhU3pFJce+DR+34U2cgL2ol704KqldMoRXk7Di8q4609kbH6DhOZYaxzmjBKSUvI7ieXtgmdPo+FnuwaVpsODxfTmUV8qvENBMLMpfr2O3xzKel5nrd/2OjEDFrT/qVXAp8seRt9UWiiHlOnCqWCg3Za1wTC77MobiadjPw3wmZVcCPBFdwPePENsDp+I9EaeAxd4hMH1LRGg8bI3Ujs+LnfxuWHkLv/aGxObvdVt8gZWtAPefY8E4PHX7aYEx1v0rTpsfGJK9aK+P68VfVtSYI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 536dacb6-64fd-4f0b-c1b8-08dde65d249b
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2025 18:03:07.7687
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DRzDft2t4V1neTjeBWytoDOzXvGme1sFibmS4YUJ8oqEC3VtZo8KYiFJJROwyV1SRfIwJi0pZHedfoqvbaCbwddtDfvF9/IyrXHGHjMdILk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB5760
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-28_04,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 mlxscore=0 bulkscore=0 phishscore=0 adultscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2508280151
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAxMyBTYWx0ZWRfX0YvCc1i8VXkJ
 l7EdXqUuuShPD4jQooqM2WoIukgbUGqGNzRKHRFIuTgzLt39Wn2pH269Xb5evMo1ils4r39hWFC
 uXsb3JFF8hXL3RBMc4u67b0U3kyVGPxSck+gmt8XvThgeuV8+mhThTkiCu0eOM+jI23JDp+XLAF
 T/cNObEkbJobdwoChn0qjB7Hb480d9JdPk2d5nN+t75iidYDN5OxlOxKWk1Dw18SxoZ79C02DAV
 /9MWK9PExJAhlimIf7MA2TKoJuPkhY/phztQivUaMBT6qU2Y+PJd4SCQiJgO1eHBGd+DJ+bzHgM
 HTGKtSeV5l0+liXArH+7Rm5pm1NgW/bDvVm0QEMgz5BfrFA7SM6hfo9lQJvSDYE9Q1J9ObqfV5O
 O9q0ueIEnkvqwcRWCpJZ5PcQ+aecWA==
X-Proofpoint-ORIG-GUID: rTjIeBxq3EIPeRZ35icz10rCKhnORVPp
X-Authority-Analysis: v=2.4 cv=RqfFLDmK c=1 sm=1 tr=0 ts=68b099e4 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=FNyBlpCuAAAA:8 a=J1Y8HTJGAAAA:8
 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8 a=TjiRknLQYJtMy9qA3PoA:9 a=CjuIK1q_8ugA:10
 a=RlW-AWeGUCXs_Nkyno-6:22 a=y1Q9-5lHfBjTkpIzbSAN:22 cc=ntf awl=host:13602
X-Proofpoint-GUID: rTjIeBxq3EIPeRZ35icz10rCKhnORVPp

On Thu, Aug 28, 2025 at 12:01:36AM +0200, David Hildenbrand wrote:
> It's no longer required to use nth_page() when iterating pages within a
> single SG entry, so let's drop the nth_page() usage.
>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: "David S. Miller" <davem@davemloft.net>
> Signed-off-by: David Hildenbrand <david@redhat.com>

LGTM, so:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

> ---
>  crypto/ahash.c               | 4 ++--
>  crypto/scompress.c           | 8 ++++----
>  include/crypto/scatterwalk.h | 4 ++--
>  3 files changed, 8 insertions(+), 8 deletions(-)
>
> diff --git a/crypto/ahash.c b/crypto/ahash.c
> index a227793d2c5b5..dfb4f5476428f 100644
> --- a/crypto/ahash.c
> +++ b/crypto/ahash.c
> @@ -88,7 +88,7 @@ static int hash_walk_new_entry(struct crypto_hash_walk *walk)
>
>  	sg = walk->sg;
>  	walk->offset = sg->offset;
> -	walk->pg = nth_page(sg_page(walk->sg), (walk->offset >> PAGE_SHIFT));
> +	walk->pg = sg_page(walk->sg) + (walk->offset >> PAGE_SHIFT);
>  	walk->offset = offset_in_page(walk->offset);
>  	walk->entrylen = sg->length;
>
> @@ -226,7 +226,7 @@ int shash_ahash_digest(struct ahash_request *req, struct shash_desc *desc)
>  	if (!IS_ENABLED(CONFIG_HIGHMEM))
>  		return crypto_shash_digest(desc, data, nbytes, req->result);
>
> -	page = nth_page(page, offset >> PAGE_SHIFT);
> +	page += offset >> PAGE_SHIFT;
>  	offset = offset_in_page(offset);
>
>  	if (nbytes > (unsigned int)PAGE_SIZE - offset)
> diff --git a/crypto/scompress.c b/crypto/scompress.c
> index c651e7f2197a9..1a7ed8ae65b07 100644
> --- a/crypto/scompress.c
> +++ b/crypto/scompress.c
> @@ -198,7 +198,7 @@ static int scomp_acomp_comp_decomp(struct acomp_req *req, int dir)
>  		} else
>  			return -ENOSYS;
>
> -		dpage = nth_page(dpage, doff / PAGE_SIZE);
> +		dpage += doff / PAGE_SIZE;
>  		doff = offset_in_page(doff);
>
>  		n = (dlen - 1) / PAGE_SIZE;
> @@ -220,12 +220,12 @@ static int scomp_acomp_comp_decomp(struct acomp_req *req, int dir)
>  			} else
>  				break;
>
> -			spage = nth_page(spage, soff / PAGE_SIZE);
> +			spage = spage + soff / PAGE_SIZE;
>  			soff = offset_in_page(soff);
>
>  			n = (slen - 1) / PAGE_SIZE;
>  			n += (offset_in_page(slen - 1) + soff) / PAGE_SIZE;
> -			if (PageHighMem(nth_page(spage, n)) &&
> +			if (PageHighMem(spage + n) &&
>  			    size_add(soff, slen) > PAGE_SIZE)
>  				break;
>  			src = kmap_local_page(spage) + soff;
> @@ -270,7 +270,7 @@ static int scomp_acomp_comp_decomp(struct acomp_req *req, int dir)
>  			if (dlen <= PAGE_SIZE)
>  				break;
>  			dlen -= PAGE_SIZE;
> -			dpage = nth_page(dpage, 1);
> +			dpage++;

Can't help but chuckle when I see this simplification each time, really nice! :)

>  		}
>  	}
>
> diff --git a/include/crypto/scatterwalk.h b/include/crypto/scatterwalk.h
> index 15ab743f68c8f..83d14376ff2bc 100644
> --- a/include/crypto/scatterwalk.h
> +++ b/include/crypto/scatterwalk.h
> @@ -159,7 +159,7 @@ static inline void scatterwalk_map(struct scatter_walk *walk)
>  	if (IS_ENABLED(CONFIG_HIGHMEM)) {
>  		struct page *page;
>
> -		page = nth_page(base_page, offset >> PAGE_SHIFT);
> +		page = base_page + (offset >> PAGE_SHIFT);
>  		offset = offset_in_page(offset);
>  		addr = kmap_local_page(page) + offset;
>  	} else {
> @@ -259,7 +259,7 @@ static inline void scatterwalk_done_dst(struct scatter_walk *walk,
>  		end += (offset_in_page(offset) + offset_in_page(nbytes) +
>  			PAGE_SIZE - 1) >> PAGE_SHIFT;
>  		for (i = start; i < end; i++)
> -			flush_dcache_page(nth_page(base_page, i));
> +			flush_dcache_page(base_page + i);
>  	}
>  	scatterwalk_advance(walk, nbytes);
>  }
> --
> 2.50.1
>

