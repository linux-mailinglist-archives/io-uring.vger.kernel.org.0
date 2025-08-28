Return-Path: <io-uring+bounces-9425-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D8E59B3A99C
	for <lists+io-uring@lfdr.de>; Thu, 28 Aug 2025 20:10:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A0D3A567635
	for <lists+io-uring@lfdr.de>; Thu, 28 Aug 2025 18:10:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BA59262FE9;
	Thu, 28 Aug 2025 18:10:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ivvV7fsy";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="WAFot5C+"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61DFE2641E7;
	Thu, 28 Aug 2025 18:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756404610; cv=fail; b=iUBzdkwTiuHts9iD/HK2e/AkMrY3S7PGxUbCEH4a0c8D1BOXEnTwyj8A0imUP5ojhhStix5xgorlntWrMkONFDQFKZND2gHfFE0jS6lUZJddW59wx2EOV5gJ3cI0VazFwpSwbsWtv2z7wpVxOiq8XVskp27lDedzQUUy0lm2oWo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756404610; c=relaxed/simple;
	bh=eoECjsHJGDm/EJJfV77Z5JWNZhYHNiAjjbzQcwhKuNc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=PKX8dsfGqP6lNNCqk+a5qne1WOB10pyus8y4eeWTZGzbuaegHpKl4WYmnqwVOFo6A1iLV1F+MRCyh9OQKEPe9X3koGpBnTX4nz1I5vZt1y6+YdGOAs8AFQ6Nb2a3QiEI1jOOxk+b3VSwp3WTpjlLPXBxD6VTOnCoObn3K2hNhF8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ivvV7fsy; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=WAFot5C+; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57SHMq8w006549;
	Thu, 28 Aug 2025 18:09:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=dBlHNDpgCRsvIkYZ7l
	bLBAD07QGfmM/wXwQ0KUmlyLk=; b=ivvV7fsyzxUMYiCtuVBEsTIEnOwPRELxCB
	lIMI1Acz3Qaqfl5Ir8YChea3FgWhubRR/rG+7CkwWLTc/fYI6gFyygLVi0iDHF3g
	66j8v3yhgO4sKRFzJ0uvhzloiqD8oord1xs4XwblUXjo2F77f6g2Z+Kf6S6+tbWk
	0lo8ygnwXTFWU3ZC1Jo97lJnf+gITdCkIcYySHzPnptvGzKXDh0JHEcrx2V3exs1
	g1OYDQ3UwANgFbP9lfXWhZsUP+hIabiXVWse8pkHptvSxfextVaUtU8UeOUBu92k
	z0Tek/3hF+zMFDV6WT4Cg4RUfR9Iy7vkO8rsllSChGTxqxMs8MnA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48q42t8y92-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Aug 2025 18:09:35 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57SGbGSo026710;
	Thu, 28 Aug 2025 18:09:34 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011007.outbound.protection.outlook.com [40.93.194.7])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48q43c3gr0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Aug 2025 18:09:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=M6jm8DORsohkhz/lt14vBBlOmDo4pKovobnv/skvq3fc/LP+L87NaqyXu36llA9mvEKr95O7ve0msNyFca/5yAPUh9B4N4w4K6Gj5v4M1mtcFgkRM2auE0CtSl7VSnDY31qrLyWvX+HflnHXj9Rtw6jVADgM83mGF4UmzOWEhNBDb1IFxhdfU52sym1JJBERIS3pd2bwHH1zaF1NglYqjyAo08eTqZ+JqRqorI8vhIFIYYw1Rco3qt9JX7uezjZbr8CRyN8MskYlBWeExX+/NyVt6nocZD4C7d5+LG8cP41xkvdK4H+7d/237t+gtd3891Eqi/3KopC1wuCashajhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dBlHNDpgCRsvIkYZ7lbLBAD07QGfmM/wXwQ0KUmlyLk=;
 b=uFTerBosI07Twrk3sGGY1yd11mrD9ezw6e38QbxcDCxdE9aqRFtEL5xJ3M3niMrHHN4n8OpVBBrWQsfi/PYq7n/MjyTj90jGKdGwcDF1TeROrJ4+ooxfjyVwzGW2h9F0cxWzkXohDUuVMNvEiRHZe5sL3be3pmYgNQppba/q+rtJ/rT/BF6U21K9o+vqqXGlm/mYdK2SvJQG3lfF+M81Hy72stw4Nkop31JocS15GG96CAeJq1ZuM1xy83GkixhtdwmRvH3d87TzpjnrsU3CsFF52jlEH4I673IuC5mB9DhfxnrGD/O2mPW1xyGNSZRXAgVYKnrhwb8Wr7J0UD+2Qg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dBlHNDpgCRsvIkYZ7lbLBAD07QGfmM/wXwQ0KUmlyLk=;
 b=WAFot5C+sdpoHejze90YsICnPReEOSE36VdwYCqayVeHIViZYKDDA23ik9niFBpL3bCQZ50t1EXcqGUbgj99GYVmgjjgkudeIJi4JB2v+1cVdh1haF79PBnxqLEQ+MarHGc4YTglKLeXPZ+PfKqAr62+ap3iFuSknoaG8piOOYI=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SA1PR10MB5760.namprd10.prod.outlook.com (2603:10b6:806:23f::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.17; Thu, 28 Aug
 2025 18:09:30 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9052.019; Thu, 28 Aug 2025
 18:09:30 +0000
Date: Thu, 28 Aug 2025 19:09:20 +0100
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
Subject: Re: [PATCH v1 33/36] mm/gup: drop nth_page() usage in
 unpin_user_page_range_dirty_lock()
Message-ID: <c9527014-9a29-48f4-8ca9-a6226f962c00@lucifer.local>
References: <20250827220141.262669-1-david@redhat.com>
 <20250827220141.262669-34-david@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250827220141.262669-34-david@redhat.com>
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
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SA1PR10MB5760:EE_
X-MS-Office365-Filtering-Correlation-Id: d1116965-9097-434e-04d0-08dde65e0866
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?e5fpY6ewYYK63DTg2BPQtRebQXr1eGee63Xts4qbpw3IS9UCKQCyaZX6LM99?=
 =?us-ascii?Q?C9AEdSI0te/z5b5BOKe5KByGyirdBMU286eC0Tcsaof/rC2Sr3XiyEySC3h2?=
 =?us-ascii?Q?r9HcHFSmd6D9i6qR9ZtiXl2M3KzHbQoPbFxfvmOO+uoEC3EmjaSPfuSaDkRd?=
 =?us-ascii?Q?B6U4W4Ct6e2spB6j2CpNqDwBjOo2XhCC33GCGH5vRVp1xmTZTlEdXmMGJYdS?=
 =?us-ascii?Q?bz1O8Q8zEfMYyO4s8hcCO732YFy/+o98t9P7ac+gAoC9PTdv98MAT773Q/Bd?=
 =?us-ascii?Q?Onl/3W//mGTq4RnS+89KkB9YL0C7F6VSewGbHRWSDPzutiUHomVw/ti+qo2Q?=
 =?us-ascii?Q?xR4O3obZztjUL6UBljIFm8wPhm4WpaFaWg6ovubXc1/tz7VMXSF9zWdhFV5A?=
 =?us-ascii?Q?7fnaCQcB+U6OPg6dz3tSa34Vl5GsDCviliOYDtDJZiwXvMXx6tdVyw3UxyWd?=
 =?us-ascii?Q?1YBud0OSYZspC7mik5ujaMYXxxRvrEgyuRlxh0u17oXfi6zOj94BFpe8voMn?=
 =?us-ascii?Q?1O/S7opERjxE66ynb9Z1I1oVR56oLx1dRx8td2JO3onB4IZCorUp6T70a6bo?=
 =?us-ascii?Q?DLLLhwzggKG5Ux6FTSuCFZAw5HLpZE4+JqHFpHqeDYR7O5Ot2N2VP2UCvNIo?=
 =?us-ascii?Q?g+ovKlIhYhPo2Wvie9KzIpDGg7wKWahOlm5V+U/cNE8NLjhIovkHrblVgHhk?=
 =?us-ascii?Q?1ir40WvCkoL4o/tEE6oHC83+pdFo6LOPC6rG2LcVpKajty+bxvgT18wZHVuf?=
 =?us-ascii?Q?0IcvInQgFI5Ez/KXq1Qh1K7NJlWSjhyhyqzCvyOuBFqZh3mrs3op6AJKhJOG?=
 =?us-ascii?Q?gkYippAb44q57TThkfr/beF+xDVERjTsURT4RxSpCo8Uu0P2O83E46gxvs9k?=
 =?us-ascii?Q?leueLTYbKheXCOEGUyoR0zvIPAduiqgMIg6nhd8ewbYWCnsgT6L1DgqniCv8?=
 =?us-ascii?Q?B7fU8/emwtl5s5hi5NdgdsnJ8pdWgWNwfR2Z0wLSRKnSeolP5NI6wwZYDkS6?=
 =?us-ascii?Q?uZP9LykgeRxllyNJTOiw7HQtMPniP+RwhTYgBTRp5XJH0qtXlFXmm77adpB2?=
 =?us-ascii?Q?j1xnYHkIU8LXkUrZ1m3gqwoMSVQYJr7nCiYHULhfZn+gcu7s7EcC1qdn1z4W?=
 =?us-ascii?Q?zJdXSq0CHRyxdYYmZiYoc8Ec3ti6IMcwBj38iiX3Jy8u4ZVMhZFy5KfyoAnG?=
 =?us-ascii?Q?ge5eXpRlzYw5ydLIBMazn4K7uBXhJHenPRJsx1WjQcch0lnwhloffElh4ME0?=
 =?us-ascii?Q?w8V9jJvFQ2H+tEPtxZe9Eb3Y9AW2Oy7fERS1zLRb+cH4vdIcsfT9ghSGz9Tr?=
 =?us-ascii?Q?rNGfR7KGdkpiwlHtWUhfTHL2vaN82M9HLrmDh/gJsen/+0bmqBej0h8Uj5OQ?=
 =?us-ascii?Q?Ixqmls30W5Jr7h1GiNN7WS6vLl9nJXbcyzxHX8v/qD6+RdCpwFP7KO3b9TOu?=
 =?us-ascii?Q?S58BMhgqrkE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?s/KCusIVBDnKMxXXZ7IgB1TBirvR0ErjS39bJdcKWmeBFAopMbfmP771l4GF?=
 =?us-ascii?Q?ObuZ6E8RZBcz/kf1h116uLcnU/OhLq+pKu8iegFcKhYSfhlPCpB/DuH7Jrdz?=
 =?us-ascii?Q?VGHJaly38+8HoVFAd3tg3iNK1BUeDjPOjq3tRW4in88f9r5XLPo31jND+pXQ?=
 =?us-ascii?Q?grzNI/1lziMA3kvI3v35h3CxjxG5pTO0shX9+AeT99VxFKnUmzeCsxwnTWFp?=
 =?us-ascii?Q?PCd4XX2IEC1DmvGyxu570N671M99YuCOuzKRT+wOo318U/24AMXGDvxVGWdV?=
 =?us-ascii?Q?IofKDmmtumZgKbqLKNFQBgxfDrLIfhymm/zwpML6TYdXNPhq7iS1q9DOZeuS?=
 =?us-ascii?Q?fCRehP19Dqf7HzgB6J9TdlbcDwkobjdfnhwdpAOb+k4ADLz8CPoDMYBtrEW9?=
 =?us-ascii?Q?z2TgrfmVhBFXBC5sjZb4zJQZRYpLCjYNjfIBpYqIo5URxsmUtT5EMnDmcer9?=
 =?us-ascii?Q?ZPrxE7yymMdhDTdXriEgY2BW0H0VM6qtUZ7/tkrpSVt/6pgRCioS/UXZH+Nx?=
 =?us-ascii?Q?SEKz6QCe1DosRtK2SS3IZMr9OsqbiDGt1xZeyZUpl4ZcIZhmun7ADmEqEeVE?=
 =?us-ascii?Q?izYJP4cPsOCV/COF7VmZdODDw4G3sc/s3z8SxGPfzpSw/XhGvY1hY4SHsOKO?=
 =?us-ascii?Q?jF8tfDk9yXyJCGGqEkxzYaQ2f2vhKt2sxCIfZbutHW467Uxd8vBxocqRXJr/?=
 =?us-ascii?Q?DKwGlBXGMd14TJJygJDoBJoJiTSP/913zVRdbuP+YNCekDkN4vgFGM7CCUT3?=
 =?us-ascii?Q?jTu+m4v2lLtAum1aqvFY8MNTDY927gNfat2oPBXXqFg04aimhLfz4ReEDHvD?=
 =?us-ascii?Q?0D51Wj+DfMDjNhG1AZoeUTXCI2+NaaZd+ZmRfB5LeXDPoUCdp8v/vW/2S9+V?=
 =?us-ascii?Q?2chnQWQ0g9akJ9WsPW7JKTfWzqq07cKzEXhXG81mTHNLd237F6s9BsOnefzU?=
 =?us-ascii?Q?9E7WB6/UeNA5j4P6BANUJoXxaYn5AILSVL3w3cCJyvo9gOZrTbkJhtxQm10v?=
 =?us-ascii?Q?mCZyJb61d1jyqh4rasjOlWY3fuLEBHPDGVTj3L5AUc8gZmMpZupGh5wd8GiH?=
 =?us-ascii?Q?riLl7MBnBp+OtjXZQv353OFc45ke3XXSajr62cGT1jYoskZUpr67QEui8RoE?=
 =?us-ascii?Q?aaezTSvkkS5+ImRrlwH071hpiyRIB9AQIeRDSNtEPZWMNaXz7NMWqD2UP8hC?=
 =?us-ascii?Q?5nw3Hd8nMrI4q0knhqrsbx2LHOJ+e1x1MlzzoiIkVNdv+WitZkmhiqXzlRxt?=
 =?us-ascii?Q?HOJ1jkzb96tai84b24QP/fEoZp3QqZvhaZ8nfjJaepz1Wfh4PszgVcvyO3VV?=
 =?us-ascii?Q?S3LSDrqrE0H5EQWJbXiFzBLAhu4yE25i4IfRyD+1fs7Ug3J9+6AO4HMOap9T?=
 =?us-ascii?Q?55MHOcR9D1YgMQQiNXvaBfl28iAP+61IoM1mGp13Tkbn6cSVNGU1LB8uE1mS?=
 =?us-ascii?Q?w88VIxmdsg2GMmIOh8qvSd/nIGsZj0J+Vnxq/U/skKdQG5Zps1Hx5drboq+A?=
 =?us-ascii?Q?Du5wj4Y4p7btdbUW/TwZuELoVsBt9G5PE0kqhPdTyOSC+V0doE/3PqN70XAS?=
 =?us-ascii?Q?0do+AR+9I2NjIfjqNLC4semZpiz7orREgkKawCuBnWZtVayUDVZnF1QCDdc0?=
 =?us-ascii?Q?tA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Yze1aqQNp82ilDwc97GNDPaCbHx7le7DLqD3hq5OoOxkdk1d7ZlMdDBWvY2Z0U50IDf2iypAQUQ6jUweENH+80yDvZ6eBJ4BAC8QKOowiur48x37tPHjr9bM3B4sZWkV+HUBRudFiDxFpwp5Spto2+hoRM/nB0G9uM/XGfn4poAcR59Q6deVVG5ngiSJAbnd2nBsofsTUywZnRPKi5K8nuDhkAbBwuKHPN9SzD26cXezMma0k6kLi+t2PqQzy5He60aQy86nuq/QLxJHoETgCeOfZCyZ5tMaxZ0dn704xuUyJ+VoFoBPvr4TiFuuuw6mJYc2EJHUYY+vUUD/XuPxyTu0wyA8VmmENLaIrKw+5AgoPz4uaV0Fypb9+J37qjsBN0tiXrf4WYjf0iI8ixOj8Jxm7cfT4ftqpHxL/liWE2WbamhHXp8ZlpwwjbLcWNbZ2DPatAi8hiGwihxQHFxYuby5TK0zMTQYWBUSv6qGt24e4UnL0mHEyDCorKqOu4nYHWNJ17nYPGCH8he52Kb1CH3D9vrX4EpEweVoQI/YGzovyESKh/JOV+fCmqWf+XtHRrU95FyBwe5r9XoOKP1TOORUE0vxLTYB4DK7KbNqz/o=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1116965-9097-434e-04d0-08dde65e0866
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2025 18:09:29.9312
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7MVGIjYK+P7d0jR7ERykypbUuHmT4K9JvpRnG9312NW6zgEv3WLKBLiM2nrMpkLZygrCcjGHYMApsH/Z3lDqIuXzq8a7TgtLhlq3+kH3Jnk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB5760
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-28_04,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 malwarescore=0
 adultscore=0 phishscore=0 suspectscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2508280152
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAxMyBTYWx0ZWRfX61yb/jBxqNYv
 UrZUGfCSxhhG8QhSW9mCyNIxdRzGz/R+EIAJsV06zSacvr0ruSma92otQMoAogmk40UApPceN2r
 lP8pCTyNyPJirxwK1r9oGkO6XHbA3AaC36zzu5wQRso3X5XWGKQ4lI7V0ELAtxjwW5ncubmEP73
 yX1jWe31J3En+E6E57+2SaBnR6dIW6LS2WqetyKfg33M3zYEc3vWos7FvR0eSCuXPJhvd5qBnMi
 m02IC+NrjXzLv8G3ACVARjx0W3xphseRjwn8+0WX9xT+eGoHrwJWkfWkECsEsjgifMeEuZNe8ro
 aUa2qABrjzS69qmNs9COfV/e4Zf1jK/w+Vsx44LvQ5CmxwA5QLHGXOA2PhHDEYtqvAphrF7OaLJ
 J+RBqCsV
X-Proofpoint-ORIG-GUID: KSGOl-sS-XZ_rfImcHSL-PMY8u2OAdbM
X-Authority-Analysis: v=2.4 cv=RqfFLDmK c=1 sm=1 tr=0 ts=68b09b5f cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8
 a=RXLy_cWdbC9eJWi9IxIA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: KSGOl-sS-XZ_rfImcHSL-PMY8u2OAdbM

On Thu, Aug 28, 2025 at 12:01:37AM +0200, David Hildenbrand wrote:
> There is the concern that unpin_user_page_range_dirty_lock() might do
> some weird merging of PFN ranges -- either now or in the future -- such
> that PFN range is contiguous but the page range might not be.
>
> Let's sanity-check for that and drop the nth_page() usage.
>
> Signed-off-by: David Hildenbrand <david@redhat.com>

Seems one user uses SG and the other is IOMMU and in each instance you'd
expect physical contiguity (maybe Jason G. or somebody else more familiar
with these uses can also chime in).

Anyway, on that basis, LGTM (though 1 small nit below), so:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

> ---
>  mm/gup.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/mm/gup.c b/mm/gup.c
> index 89ca0813791ab..c24f6009a7a44 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -237,7 +237,7 @@ void folio_add_pin(struct folio *folio)
>  static inline struct folio *gup_folio_range_next(struct page *start,
>  		unsigned long npages, unsigned long i, unsigned int *ntails)
>  {
> -	struct page *next = nth_page(start, i);
> +	struct page *next = start + i;
>  	struct folio *folio = page_folio(next);
>  	unsigned int nr = 1;
>
> @@ -342,6 +342,9 @@ EXPORT_SYMBOL(unpin_user_pages_dirty_lock);
>   * "gup-pinned page range" refers to a range of pages that has had one of the
>   * pin_user_pages() variants called on that page.
>   *
> + * The page range must be truly contiguous: the page range corresponds

NIT: maybe 'physically contiguous'?

> + * to a contiguous PFN range and all pages can be iterated naturally.
> + *
>   * For the page ranges defined by [page .. page+npages], make that range (or
>   * its head pages, if a compound page) dirty, if @make_dirty is true, and if the
>   * page range was previously listed as clean.
> @@ -359,6 +362,8 @@ void unpin_user_page_range_dirty_lock(struct page *page, unsigned long npages,
>  	struct folio *folio;
>  	unsigned int nr;
>
> +	VM_WARN_ON_ONCE(!page_range_contiguous(page, npages));
> +
>  	for (i = 0; i < npages; i += nr) {
>  		folio = gup_folio_range_next(page, npages, i, &nr);
>  		if (make_dirty && !folio_test_dirty(folio)) {
> --
> 2.50.1
>

