Return-Path: <io-uring+bounces-9394-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D2011B3A130
	for <lists+io-uring@lfdr.de>; Thu, 28 Aug 2025 16:20:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 44021188A091
	for <lists+io-uring@lfdr.de>; Thu, 28 Aug 2025 14:21:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8F9C31A552;
	Thu, 28 Aug 2025 14:13:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NFJYpWID";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="bFpbLBoJ"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3484631A069;
	Thu, 28 Aug 2025 14:13:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756390392; cv=fail; b=C/hNS2pYl+jHvSPQL0iOWeF6sxdS86DPZEZaUPgvubia3cjY7AynUR5YenX3mcqPFaI2fH5liKPxjwJv9N39MPekWbuLf7DcHiEc/lhtz+6JlSZ6EopYiPFjuaqdoxESSa9c45oOqcNfKFBeG/exYD1I42R83+NFpNggDHpTY8o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756390392; c=relaxed/simple;
	bh=x6DRUG6R9JCiIjWMhZrPe5MO4vWRZkFJMuP0ihTW5SE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Ja9piekCGBulB1Gun9NUKUn35AKACxvF4heSiiVUBf99XJaDwdZU/ZXTpnFGnT1IrM4FUu9KVKwDRR16SxFnkZY5KdN3UIjEfUVs8m03GVM+ZbyUNwntWialM9vXaQWRugtlODHa7pM7NtCbTMxI6hv5RrhB4bi00RovSe3/3x8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=NFJYpWID; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=bFpbLBoJ; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57SCisK7023288;
	Thu, 28 Aug 2025 14:12:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=yOlSoNj7xRkg1LgJGs
	lfqgGpe6Rs7LEYJFOIYyxNVE0=; b=NFJYpWIDpQij+YWSH8jxf/45OU/ydiMSMI
	3k/GMR6xJq60jOrmQcXN0crr+AvKqkPUL+nP5Wof70EDbyA7YoOIEmV0VvWM//0O
	vh3b4G/kUwlOXrAMxEKJ/a0I3jueNwFZ9vva6MzYpwSeSxJ+pYu/OdHP1cPwRpq5
	YpadbGiLzQyj5f3XyN9fDNtCyhFGnzCJ/VCXfViYXNLJb4atlPM7Yv73tjTQD4FZ
	U4H1yE6rnHY4son35cMA+DWAXEVWGLG10eRLDPkkMUvivQVAtJQDPsU0IxOA+zEa
	x5L6A4T7dhj9vE7DRbtR/clAsjajc08lzc9z90XIWX35umbUr7+g==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48q42t8f54-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Aug 2025 14:12:35 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57SD8L13005044;
	Thu, 28 Aug 2025 14:12:34 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12on2073.outbound.protection.outlook.com [40.107.237.73])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48qj8c6ksf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Aug 2025 14:12:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ykeuGttpnFmGu/W5b1JVe1hUj2dHHO7lYNLTzc/iC/uMRRkFOXs70meWkNq6D6YJnIXpVp58mPa0Caw/nqXHVJfXJ+yRyaJlEqpe3AENLtORMyMcFe5/TaVcDz8y1hioLVtfFr0wqStiwmqLksTfsSgLb+0pqxyzU29vl3lWsKphjVCY3kAoLtCpm4pqow3Z02iGKwyMvyOUYs1fDwoD31Al3q/CjyMcQCwVeAccF43PHHJxJymUI6ywMLYfZ9QWkZAVYOdzE1wFv/YLz2T6hG96LrWe4+E62pnCkHN0nEN1olJn2MpXvt9yMcCnpW2faQ9vXs5rfr2vxwqgkXg4IA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yOlSoNj7xRkg1LgJGslfqgGpe6Rs7LEYJFOIYyxNVE0=;
 b=IeQEeRXhmDrp4jISSmi21NKzyDjogHjZhzhjQu3waEJucYZS7+GAn+dBEqF0p+ghTJZnjAtkmi2WCEwBRBeVQjf/xDqq1tVwy86+qxyiwwRYhAQt1/P7sS04SNVsaENAEpkjNTz4hVg4I8OxQSZzKRsQkCOrdH+9jXvQYnD0IXp/bm56ySpRXN1vFnXjpaXf546XhMHvOzzPfpXmZwfiNOjVnfrCY2KwopwVHFAeKQO+fVLGBC5bPeWYtWhwXyU5tveIa7n9gjS8Ut+ErhrH1W9ClD7gsn3B/SeiMIWWmZvKkI2JS+B927lByR2W3LJc6QqyUcdQGgpOP6iqQAoW9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yOlSoNj7xRkg1LgJGslfqgGpe6Rs7LEYJFOIYyxNVE0=;
 b=bFpbLBoJ+1eiBOFy1DhMe5rCvuRzpwGgVFXe/EUh3SiMdqHTNI0qwII+Oi586Mbu5ea25Dwp8oqNphCEfvDlumBrNnB01ZaXZuGglHuGQD/92H90w0/fxOBXQFXGaRf2I2Vo7uBC/2CZrm9K/Y8qMUblSU8y486QI/RlOaN0G6M=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DM4PR10MB5944.namprd10.prod.outlook.com (2603:10b6:8:aa::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.15; Thu, 28 Aug
 2025 14:12:27 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9052.019; Thu, 28 Aug 2025
 14:12:27 +0000
Date: Thu, 28 Aug 2025 15:12:18 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Alexander Potapenko <glider@google.com>,
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
        Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
        netdev@vger.kernel.org, Oscar Salvador <osalvador@suse.de>,
        Peter Xu <peterx@redhat.com>, Robin Murphy <robin.murphy@arm.com>,
        Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
        virtualization@lists.linux.dev, Vlastimil Babka <vbabka@suse.cz>,
        wireguard@lists.zx2c4.com, x86@kernel.org, Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH v1 02/36] arm64: Kconfig: drop superfluous "select
 SPARSEMEM_VMEMMAP"
Message-ID: <504d82f1-65c9-4835-9138-12f605b0aa54@lucifer.local>
References: <20250827220141.262669-1-david@redhat.com>
 <20250827220141.262669-3-david@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250827220141.262669-3-david@redhat.com>
X-ClientProxiedBy: LO2P265CA0190.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a::34) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DM4PR10MB5944:EE_
X-MS-Office365-Filtering-Correlation-Id: 53586d74-a051-4b1c-2091-08dde63ceaf2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?aVP4dVxTGoBUou3UXuB+T2bTwahiu+PDzdA2poMj1fzqDlbdfAb3I8nL7uva?=
 =?us-ascii?Q?ijYnOcJzZBY/JS8QLxyGHQD07ioo9RaMPhHqozG9Fr7JsCgMrujdKVeT4ITh?=
 =?us-ascii?Q?CA4BoYmQaMJ0OkCZD5gTriypSDLTgYX3t8T+tfaGrDabR0Wqj1o9761G9twL?=
 =?us-ascii?Q?pPiTCDJHtZKPgB/JWY1QT2Omafe/pU/+dVCf2KUacyk63GTh/DwUD9TCL9cS?=
 =?us-ascii?Q?2VKGI+g6EnK/A637Jfx4yNIYGNhbpel7RGgw50CeiDBHJaVNjU4PD4kNoqbO?=
 =?us-ascii?Q?0Ai7Kz8j+jeyCShf915KmS4KCjeWfnfscqWoOy340dxZetRAEWS2OlptEyDG?=
 =?us-ascii?Q?qALWiutlM5dvQR4MDCHZcVyGi8La4xEbCYHzp/aTJgj0SsQAg6ITDSTbZ6hh?=
 =?us-ascii?Q?kTOCSxnh+AZYRQorR2otdm3DPX8ihUm8zgexh/RTaamct5KmnbdHXB7JPgxv?=
 =?us-ascii?Q?6w9dklLuFV4PDRzWryITexhlDM/g1G4+TFKs1slGghYE0RIvYI2MnZx7WFGh?=
 =?us-ascii?Q?Ox4KSWKy4Z1y4fIXtxIIrhGGmsHwwYJ7vRy5TKCIko3dreY4xlMCjwiUVqSQ?=
 =?us-ascii?Q?ZjKwvYpeRXeuLqK3xmQG0VQHWPOqHTKX5A6a3XAsTq3XB6fwydd5fvqHUvGX?=
 =?us-ascii?Q?D9S2zhZa+1zoaXA0A1y9ZIkKXV3ZGnIL8A8ymmS1JCnSq5LU2YUPQk68wGt1?=
 =?us-ascii?Q?HetsDP5pMFmNlDGcTWcHCwAXGDUBtjkAIt4E25B348pbcp8WDECgFDMjbj1O?=
 =?us-ascii?Q?vpGtvAODIkjpVySQ5FDeaIGXdVP8GQ9Tbgmlbs0UHyUbv/LsrU7MZdQ8vKC9?=
 =?us-ascii?Q?Y1omzzYKHUJO8El89iYNRFafM8g59hmGZu6n1ybR6B8QIZn2x1FS/6APZwl8?=
 =?us-ascii?Q?jzoB5BVol+F1BnpjCajtktfZhYTIRD/iyb+fKRWEVBe5/VOiABTnCuDj7xSQ?=
 =?us-ascii?Q?p/r7qPD9kAmZvWf5+YimFfuUK9eWQxyj8nahXfJfFLjHCzszKbA8LYxlhrcj?=
 =?us-ascii?Q?SAA9FIv5xvZPK3DYGcT7kOsslR+PH+m6u9wTcgwGkrizYs9i2REz0UFwIzRj?=
 =?us-ascii?Q?WRdg/V0cOFe4rIrOCMMk2sF5BkHJ7p6V+T5ydpykT1p2SleHU7G7UD35jgSS?=
 =?us-ascii?Q?6F/rJyfAXSGgLt4E9deruetIh8SDCX4G1NI9oNT/kP4yqD4gcrF7JpUhzzc/?=
 =?us-ascii?Q?X/R0n5UQQ5RUrIIuXdpusiRRw1VQ+CkvIbziaoClgfnVf4Shu9SbXMOHa2sT?=
 =?us-ascii?Q?vjAXU+X11GuGeoDRNOdQ0SFSErncWBzIjF4XR2XZSjjqETYoeMouDvZAJoK9?=
 =?us-ascii?Q?72bQ41pQdCx1v+njKqiDMBfuFwdCKzOOrcfV1m3+c2WWZbigg+w96yUpUpCB?=
 =?us-ascii?Q?SX9i+qatUWvA/EqyAoONLwKOiNHh4ET63G+ePiFY8/5aIdttx2zjhaa6qiIC?=
 =?us-ascii?Q?P1CfR7+cuIk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?vC/g5pZAGe457+pv4kgoGS3DDUcoBYLGRjpStDgDMN3NW+2brEP9o/8j17+o?=
 =?us-ascii?Q?+jepdiiYLDIw7jU+BtA91ymdRovtkLBIFksIKJOx8fc2VrhPhgOP0kvbqLzj?=
 =?us-ascii?Q?keulKH8UUGYGyDttg+k6JrvYzRm83dzY+8G7cJnBCAXH0Ow2R2VEnQsZpo8i?=
 =?us-ascii?Q?lZxlSu8o815KF/C6uGx07n1vuAc0dbIX2hqXzQEAC7uiUCFO1EQD2Dm5l0F2?=
 =?us-ascii?Q?eyp2+Tz40GXmhLKyC8tijD5yrNeogCo9RyU7Jpx24k7CHS18MIbPjRYhX4h9?=
 =?us-ascii?Q?2bFTP/gQLq1kL+leo5+QUVsRa+K2U8mvgn9M8AL39iZOAaL79CxCJqams1AV?=
 =?us-ascii?Q?xlqzN89B6D1/QtHFSUN89kXLDUqGSDWFVwhZS0j5mJxdKmyLYFJtx4pDrnYj?=
 =?us-ascii?Q?Ve/hBZCjQktR7E9IS6xJjKv2jGx7CYKbeScVoRUjhlP4ok9N9+AgBJJ/3X9b?=
 =?us-ascii?Q?5A6E59E91zvUhadVgbeisiZlgq/FFG0rQ58YdtrZ87VBf805nyRhxSbMlgN7?=
 =?us-ascii?Q?CdZmKunplrpjUkPPVaIFYE7ufS6k2ZLpOYph9ZwMS7Yu3vMkZGhdypgodDDn?=
 =?us-ascii?Q?FPiLenDBz4fubR3mhxDj7ABobiafuPFNtz3bZIWmKm4HqMg2YMqsRe2O7AzF?=
 =?us-ascii?Q?zcY+qNmYHJl4efyw9L2wiR303kNvmEyrnBVHCoYwVJw42ITrH+XdfygI/8v0?=
 =?us-ascii?Q?MoEQ6ZheQ48UdtC7bMGaPMyMVwMBfA+XFDMLaKx11fe5i7cZKxRMDa6v1Nqd?=
 =?us-ascii?Q?TPyuV6BMqBMv+xvngFwi/8pBczmOjV8GFiPxiUalVnG5fu3yeimTddRUgtDh?=
 =?us-ascii?Q?dir64SWglOineZpSChYef9DsUCBt2jqR4OxJxEJSOO3jS6iYGwaoOQRTdapz?=
 =?us-ascii?Q?rjLDaXyW1qeS+CfyxobN7SaJrlO9bF9WKhbJ4HLZSIG/3SZ3YLj66K4iF2Rt?=
 =?us-ascii?Q?dMgu/c5KZN4bAIUpnbMKcXJoHSv3xvZ7XZDciEY0+5RGg0rZ/jCH6xHDAHF3?=
 =?us-ascii?Q?/5zomXVCHULh3VN1trKaD7VwCPOvBJD5ChK1N+ekWD/5nyNa/DMy/iQyAkTJ?=
 =?us-ascii?Q?TGdv36NA79AmtDXiaNU/kUWvmFluW6U12kxPaDqa7z80kh/4IhKSFojoYSAs?=
 =?us-ascii?Q?qJzhpovPA+r9PFSLYSyM1xjTkjfhjvfJXt3lc11OQ0hFkusx70w3usnUkHPe?=
 =?us-ascii?Q?4k62WETGiUsz3T3UhuCm1Lvot1R+XueTRRiqVykG4wIb3B97jd8lz8bPcjJj?=
 =?us-ascii?Q?NG1hhVeCwSCQRaLO1zMC5TVSyI3Xa0utV4nhfsa77C/q2QXiYcimLEBt3YWW?=
 =?us-ascii?Q?KcfFJdpDJtfm/MNcIBR8KXt1vW/DOTv6RWNafGZgs/Jf3QQNjwNcwYP3LMAI?=
 =?us-ascii?Q?FPSkEVCtCUaSn2Cw9FdxPIrkDvFEOTaje8Io6nIOcg3ktRnP/UKVV/PUoIEI?=
 =?us-ascii?Q?vl8R2jazlnnc2tWxXmdtWXj/oelF2/RpLiKsxa9dhcQpILeZG8wb1HaXGfqP?=
 =?us-ascii?Q?no0cLIIB3y/xEwnRP5P5QIMVvMXe6bFCUbZpCbUMS7xMDYQfWu21yevJk8Mb?=
 =?us-ascii?Q?5yP7ICiql23clemhxgka5oeSJGqggGlKSp19kdBoWfn8sCy37WY17xfpo1bZ?=
 =?us-ascii?Q?lg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	x2VY2myQUdtjdcb1ZCldm9uihI2Ikzs0z8NPY4FlW3C1kq7Pu30sxApzsTZenDKhxlWA1EMS3ZgNy8Xmv4MaVONxi9Q44HxR+XhB4687A7KpSr/eQRTs6aN6mB5TVLdI5lZjTbB5wsNU/r4DFDeMYvugdRBD1btVizq6GSCJJXxn2tf76Um6IoIOS+3MP8BZuCOPY/mZ+7aANPLUR/hS1dGFAT7MFRmue/ZQAYgiCt05UVeSCoco6dWB10aIV0qn28nl6208KYGJtSIt7A04p3B6pg+gVBLA+scx8Z6kFHf65zdA1gP5rkrlyrCX2Q9Q7D88DFR4kWoayuoP7Bw7iFng2GNsRZ7oq+a916dAfOAKT17cvPkpP31Ts2hDVT+TmJBSK0SkGyxXHvwAxawoiRA8r9eTb+TqahTuO9PBxJUmPZyIvoz1CyWsV1tNY78jo6+PDxnYi9vus+JUwoPwD4DkJu4+QX1cGpTDk96X/YyfxYholAyYLHdIsyOPnNC5TSlNlgU1IviP8Z4LtRBfGs5ycUYDOaAAQ/wHrJeWEQ+GGdF0SikfrOMhRZHxtmOGfg2y8lMG2/VXT0opNYvwp0wgsjnfhyeRCR8rsqTznkg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 53586d74-a051-4b1c-2091-08dde63ceaf2
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2025 14:12:27.1323
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: riHVoIIBB3o4/tQFuaemJUrSsesTMx9UKRHYXmpe0A5glIp/AfufpBMm/AcdrtrRAIgymf50rCDwf8c9f6+FGGCDwnaXrPsLHudHk7+oEnk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB5944
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-28_04,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 spamscore=0
 phishscore=0 bulkscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2508280119
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAxMyBTYWx0ZWRfX7AzXKf66jc4y
 U+5KTQ6vhy4plpMT+N7vwPUgDZOdRF/MGuR7ccqD5woF7s7U6lBEGg2ICc7vZJWJj0cKG1b4Yvm
 d1iDVRKSUFKb25YErb4LJ9ZJU7gHyBgdtEiTwTnLS7DRmO7tJpz55X8VT8EHxhDzKRv4/cEaYtc
 uv5ti+ew0pjZF+dXispGe4O8JCErkv6NXnksYgnH2DsVBt62V3+bW0oQ1FbhYVZRYD6ofvfQccY
 0q3UkjoMjU6wQdOlF3MiUO3I2NMfDdtgLlX1qoC0cRAVVHLqqJApJM/PhMTfWZRuS4wKlaO63GN
 mZNhrT7pmKi11KT5JlB4FncLpz8Plb3tGZT4nd8lwRRLbYNztHqjaS5sqicxfnaWEiTYw0o4c0R
 L+j7SMFvB2VOJfajyhot6Aa9h2PjFQ==
X-Proofpoint-ORIG-GUID: 6U9M0_3j6NbHR22RLroxER3bErSjvJ59
X-Authority-Analysis: v=2.4 cv=RqfFLDmK c=1 sm=1 tr=0 ts=68b063d3 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=7CQSdrXTAAAA:8
 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8 a=PabHib_kXikMvU6VWLIA:9 a=CjuIK1q_8ugA:10
 a=a-qgeE7W1pNrGK8U0ZQC:22 cc=ntf awl=host:12068
X-Proofpoint-GUID: 6U9M0_3j6NbHR22RLroxER3bErSjvJ59

On Thu, Aug 28, 2025 at 12:01:06AM +0200, David Hildenbrand wrote:
> Now handled by the core automatically once SPARSEMEM_VMEMMAP_ENABLE
> is selected.

Do you plan to do this for other cases then I guess? Or was this an
outlier? I guess I will see :)

>
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Signed-off-by: David Hildenbrand <david@redhat.com>

LGTM, so:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

> ---
>  arch/arm64/Kconfig | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index e9bbfacc35a64..b1d1f2ff2493b 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -1570,7 +1570,6 @@ source "kernel/Kconfig.hz"
>  config ARCH_SPARSEMEM_ENABLE
>  	def_bool y
>  	select SPARSEMEM_VMEMMAP_ENABLE
> -	select SPARSEMEM_VMEMMAP
>
>  config HW_PERF_EVENTS
>  	def_bool y
> --
> 2.50.1
>

