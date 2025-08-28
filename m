Return-Path: <io-uring+bounces-9400-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F410EB3A2B4
	for <lists+io-uring@lfdr.de>; Thu, 28 Aug 2025 16:52:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5BF5D986442
	for <lists+io-uring@lfdr.de>; Thu, 28 Aug 2025 14:48:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECB5B31A04C;
	Thu, 28 Aug 2025 14:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="q8KoGuqQ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="XxG0pQFp"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04BBB314B66;
	Thu, 28 Aug 2025 14:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756392399; cv=fail; b=PvwWu0cGqMKZEq34wUozx0+aTmuvHSMQdVh5O8H9qpSOuHoNiTWP95GFIdEoNmsz0RXFlG0ZzX8Db92qOrf/VSQzMW9K2rcXorfvkkG2F6YkvDddXombftmYgeNC9dOHISi85oXYt+KNHBeTn0VcmSJ9Z1ig/3jLxGtljmu7H/Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756392399; c=relaxed/simple;
	bh=G11Lz7f9yBxQzgQM1+vqq23H2jiz2W4KEPzMj0OjGkw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=bi5lyh4CimJE6xPWCoR85emUuzEn6v2KNdP7hhLk8x9KgKEw8ZCxHl+NzHeSa7i+mXgiml3wuUBdMgWuYSdXEzzcVxuGFWMRQgam2wvs+aY1caWgRblNYyD5YfUE7+F7O80D52QCLyYpz4jkas3zbM62xvtoSjB8jxE/5t4fPLk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=q8KoGuqQ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=XxG0pQFp; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57SENH1k024524;
	Thu, 28 Aug 2025 14:45:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=wOJ0ZfETJtm2MQBK//
	l66cwel20ugHvoMZ5M+Vvu2Zw=; b=q8KoGuqQwskYXFqLpWIcML9Ozqguvj1l39
	ryNj300rIR08i0AjsZ3JjQktoTToxsSnAgrz5uOPdJ7SWxxpq6IIXvbksHs5Ge6s
	JsIyUVQ9j4R9Tn46Qz0JurpOB4N/PAMTkP6DpImoC+YwjZrmkgdkv2OtSCg43497
	wS/sp6yel44BC9xdy75Rr+zC1k5Y05ihKQm+6E5gh6IuZ5sZUbKKyMr77B6+Ti08
	MrZSbQVkZ+gBib9CD8jLthBSYF/cruhcli5vm/X8DrNz/seGpbRDCGz9DdSVKPsZ
	VnMR8aYPjD0ohhB/8uRsZLD7XxcDRoaKRivR52zQfB0/GkaP8dDQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48q48errxx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Aug 2025 14:45:55 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57SDtQ5E027313;
	Thu, 28 Aug 2025 14:45:54 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10on2043.outbound.protection.outlook.com [40.107.94.43])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48q43burj4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Aug 2025 14:45:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sU4TVzZ7eBK2NKH/joqJJoi1F927Adma6LoQ5lIGdNnBuZAArvtzcetZP1lHNAGW3Z6iWDniNgoVEk7Dcz2r4zAshfkhisU8PyErFoTbIS38LkmAYJ648/leqhcs8MLaJpLHcOaZ+8y0PJ7BKb1D46yNlASFhyiIsR1Fay/hmVz310EPRZH/m4MH5mBrRtbWcHphkEmZmO2DZ/RbWOGBNjLrAkN70Mle9RlXnOs/INQLGrN9wDKUsXfbBhiwDu34nr7K/YRubvOkXvNs1bEnI4U2B2hZVubdDCTtLpQpcelgcR0G4ovnR2IorhYrJ9fkAKeTiCBrRxcwH+dFBvvThQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wOJ0ZfETJtm2MQBK//l66cwel20ugHvoMZ5M+Vvu2Zw=;
 b=dGOjHfb5yI/APwVS4Rsz3TH+xHNjL9Yqqw9ACfgZ1QK/BaewpOBtsbBcFC838BsK95kAbAXWYyahqaWlopsXDXd57Od3T34F/sJGPXsp5oZURRRSW/dVQWxsF+9DUjOymI+c4gxn4LO2rXqKUl87tONuCR2iF8iBqIckzqmfZLcDiTOOPdkL+9IoGOqzZW4YRaiL2hluQYx9d9rWmNDtXZs/DF0jhz0jS/c8q4GKZExHrjeZHLEKZXCSYs7eUWfPsL4RoNfzESd3FJIlwRRtHw7DbheFv+/GSS4p/ZXT6BRLX0vZ/brzMEMpRyDefDDlttnTHgD/TUiFyDZVqpguQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wOJ0ZfETJtm2MQBK//l66cwel20ugHvoMZ5M+Vvu2Zw=;
 b=XxG0pQFpT7JhlLGIEb5VTK5+bYlkK+PRTMH2ThGrtfY+zQPtO21XkP8f4Vm0RWj3RZR2+Rz4d/fAjZojbL0qjDpi+gxzcSQhDcUjtfONmZi/NgPQy1qHaYGC74sOzCKhFYr/zHvXqDIdscrQ0Ff0AWoCjvY/t6E70oHQL1HZ4Ww=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by CH3PR10MB7530.namprd10.prod.outlook.com (2603:10b6:610:155::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.13; Thu, 28 Aug
 2025 14:45:47 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9052.019; Thu, 28 Aug 2025
 14:45:47 +0000
Date: Thu, 28 Aug 2025 15:45:39 +0100
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
Subject: Re: [PATCH v1 08/36] mm/hugetlb: check for unreasonable folio sizes
 when registering hstate
Message-ID: <fa3425dd-df25-4a0b-a27e-614c81d301c4@lucifer.local>
References: <20250827220141.262669-1-david@redhat.com>
 <20250827220141.262669-9-david@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250827220141.262669-9-david@redhat.com>
X-ClientProxiedBy: LO4P123CA0422.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18b::13) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|CH3PR10MB7530:EE_
X-MS-Office365-Filtering-Correlation-Id: 40cc3033-4fe2-46c8-871b-08dde641930d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?sVaOtQgISIAtr1D8WGPkgV8r9k9NkDcDY4YsgvlcDHKBPHOojGeneot0ASdL?=
 =?us-ascii?Q?14OSc7znWUlv4xO7pzB9t6KH45Jv6YLApk06cchu5RQh4ogXUi3y5a3/Sz95?=
 =?us-ascii?Q?e0XRZrRYLwZwb9PMGloQKqnvrs9mxXL9oiqT1x9H2bSnLBPZUADP2ZuYp2g8?=
 =?us-ascii?Q?+wcrj/dHIXPapccVMnvSvUnRNvtctDCEAxRtWzf+jNLycM3BBqKBugy0Fff4?=
 =?us-ascii?Q?TFlm9l6TiL0jpdDd9PPwSlB7Huh0fsR9+fJjro0gcYB9lRHpVGXTS8ysanGt?=
 =?us-ascii?Q?QVDRMX06Pq5rRDqbG5dwaK/kFlwldiM3zEVr7PImAJ+QPX/0pXxxxVkUBYFx?=
 =?us-ascii?Q?Y43/fNyx/+mwvdxMqCXyvjvoWrl199jpsci7lpPWQ8oceGb0Tv4C621cDXDG?=
 =?us-ascii?Q?PwtrmwoUfFB3M8MrEW6MHB9VO/PR2LcIIMnaCz71t5Je84CjsreuNeJaPbgR?=
 =?us-ascii?Q?YcDLI/6YevuWEwPkiIgmLdSlhM7NEhcoUL+jZ+D5yfi4QyB6GwUQfVSbjc+0?=
 =?us-ascii?Q?89bUcYzzvKa5PfOktxtZWLu0ol2N/3oXPSyfFJfmHUV13bE7Bhg5+JSIOd4Z?=
 =?us-ascii?Q?W6V/jwHq+RP2+UlM2hKF8vICGGYzoVIiDSUwjd+ZB7VrjF8tTtmu85hAw3jh?=
 =?us-ascii?Q?gv84D+9tvKZ29cwOC0VOXpsyJr7S/Uw12lbROOUgeYcOnZ07rYmooLmXfgcH?=
 =?us-ascii?Q?PRYHq3yMDjjUhtFt2YhKvj5ktHPeiFrGspJJLSb8ujEPzIn4/evH8i1nC+Jx?=
 =?us-ascii?Q?1T8X11UJHSCHKO0oMyspIRlX9n0dl1B8wRayWB2pzwWuSRDzSTixQoMWaH/K?=
 =?us-ascii?Q?AU5NctfBanOlX/XUV1uEY0aYcGfqDb/mGFmw5t/PuILRilP3qYjlYhHwdk4q?=
 =?us-ascii?Q?sPhblrrh6PX+cSC/frWA25YQsPcmi89cQLif8TeOLE7BRNWkx6EDJVmLr7fe?=
 =?us-ascii?Q?UHK6pQHPW5tqJ327WKqV/WbpJ0wBHgTdweHtCB8XMP8LGtyPSmenqvO6wMfe?=
 =?us-ascii?Q?483I8DYcYu6/rwwkIX3i3J4Q04pn9Zc4hhXQdpNO+YbT0fOFO3NvX6rDHE+h?=
 =?us-ascii?Q?7RcPi/JJGGwoFaed2Em/j7qr30DdIDyCcvocTNuEGOWbeCIboVatkFmlfTgM?=
 =?us-ascii?Q?8WbzwrNFMOVdF58XJ4diwlvz2HrfdXQTONoskX4nOGWv4TfX8QBflkwUM0XN?=
 =?us-ascii?Q?s9UBda8LE+Uqopjf4hkI+x9Ru+0ZJtbSxxvmdu96rYe4C4QXpi2Dh0aqYdBo?=
 =?us-ascii?Q?jLxStXyoVDlsFPy6ZLbOjQc8IkIn7jLSz/tkrLWsd1Bx/fmufnMt7T/u+sJR?=
 =?us-ascii?Q?Ba3hhipffsslwxDkJA8nq+pWffgK7jz9pEu1jxv/pSxrOnpzwMWXX+NyjMwu?=
 =?us-ascii?Q?7RjipgBQPq5XQZWdEpOrzhFfwwiDMVq/7WVN1dghBT2+B52B9GGNvGqbjjSY?=
 =?us-ascii?Q?ci4epALYN70=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Y5ikJeMC3zmMyoqeBaQYjUa+pqQeAqkLMmSpQVZ32Om/8Cnrvpt4weU9NYSi?=
 =?us-ascii?Q?e+oH8QunvWLjVOjsHEBJAjW6XlZALMo6e9nYWW75ZGINg5cAmP1Aynry3zEz?=
 =?us-ascii?Q?hS3K4bvtHVthKH3xbLGHjCrnMfifTOOyZki8cZWvggHAwjGMBut+brQRWBii?=
 =?us-ascii?Q?FwcxGOq9c8fz3c5hr/EINNVzIbgBYvK22/2gWKB//s9mhi67ffPVtZnWSPJ1?=
 =?us-ascii?Q?f0zyUWDHAeI7oG5FjtXVDBhBQnCiSBD7lccVLscsU+1suSpq2OpMTsVD3G99?=
 =?us-ascii?Q?EgrkZbydJfEG7NIQ8NyrE4GHYtZu9peEM+FMFB7CXIcY+IoxCwm/Sq9G4vTg?=
 =?us-ascii?Q?vXJC5xpAZz+rqEPTW47p802pubSkeao8A07YAoSwy4q/IB0FE0OYYUJnHcQH?=
 =?us-ascii?Q?sDgKjL5FGCHjGIqEAnyUIsuwuYFzwa0rfHomyjWEcpOE0yLqBUUROGn3XIyO?=
 =?us-ascii?Q?DWpebCAKIXgz9VQX2NiOLLmWCBfEAE0VHXuxShzz5BECFy2idVptaxOXr+XS?=
 =?us-ascii?Q?gtPv4RuCdYRAY23KUNxB4xJzlZ50ZD/eeMv3XOThM3lgqKLq6XXohckcVhQT?=
 =?us-ascii?Q?RKt5ydSfIN4kH2D8BV4n6nTPPJjOhnIDGAUBVKhMGqYMzqcjaQpBEgDc2w2O?=
 =?us-ascii?Q?eL6Hyxc5iUiweD5tnPCnsNq8qG/ZwxJA+xrTidjs8cGFQxWFVxxxENuUzUZ0?=
 =?us-ascii?Q?94j8vYLKDgluHJ34eiEJs4O+eSq7IIS934QZUztzLBD6Xm4v3u6outQP/+QM?=
 =?us-ascii?Q?Po1X3QUg4qXL6H5lq7fVFMfxq4nlNtyqy8+KF9yGAMJiERFH5Q1vnnWOIoR+?=
 =?us-ascii?Q?xN3DyNywZVtb+HobPrCGz1ubKNeugIonnOmEqVCwq8R02DmTbKOB3w80zTiW?=
 =?us-ascii?Q?+kYjSQ+t6f/OQ4iB18pUOKKp6dHcDxOOPGjar+omccJZGLmxRcBtkHK7z1ve?=
 =?us-ascii?Q?KCnxKTS56m541tlp/Kce5QX/rZ82F7/Yo0tH4Z+X0tATwsodtSAfZrRLyHpZ?=
 =?us-ascii?Q?2RuKSyPJcBjIC0Fm1RUHnXiFsF0hcIIRnjcPJdBSGTzTdgQJGjFFJYn29duD?=
 =?us-ascii?Q?lbq+JAZJ4EeFUoJAu+lpYTL5KM8ZT+RxqwMLzOdhBFNtPpJosHzs4/aKIeqs?=
 =?us-ascii?Q?a8h8CLSM/U6fkbQXwQYJ/VLsljUMa2jKsIj9aUY+vLPaq8QmZNt3Suo5i0Md?=
 =?us-ascii?Q?DSF7CRLUfkYmlyvP+U24V5DHddVT+VeIylq+/1drcssNZ6jIpZSj5d4IU8j2?=
 =?us-ascii?Q?6UMFCzXYH1FGGD9RJBZgyNtZP9GMcQD4Z8srapAWG/371iJJWrbxURAJHxX8?=
 =?us-ascii?Q?1ztZkE1eaokXRFGNrgJhlA3mIeGpf1NDs7TQaq5EDV1DdkYuNmqyKgdQhaW6?=
 =?us-ascii?Q?/4EdtDYK5WHsOEskwZPvJIVPt3kifkn9nOAyFvjOLG1wxLvS8l76fsYwKQ7a?=
 =?us-ascii?Q?VEdzU/1s+0Z7mqczmCmc1B3NYGIhCjdRGDRZ+nxdZZ7J87myAbUaoLlbqKBs?=
 =?us-ascii?Q?x3Xkw+qroupWY2ZG5fMxbCWvIW54xbFiFl0eLTNem9TG4bnBomZImYRzm+mQ?=
 =?us-ascii?Q?N4rxz4hyIfwG1CoAZVRLG+Sj86H5tZ6wue/1uBxq9nOVHNhD2dlvH+hOlDXV?=
 =?us-ascii?Q?Rg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	7YiiDieuljhinE+0Eg0agrUS5WxqXKbmNwN1pADXO4BMqniudB6OQYXmMjgbIU6bcGHYYHt+XFOURGgoAAVDPNlpNAoMz2VXUOYqeYN3Q8xKPFefaV+hqULk2UyWIArqgwd9OOzh5/ASpuYMdRkJAeNy6ws2p1RAlJRqMr+2r4dFABWzQDInoAPvQB6e5CbF033twlrIts69Wl6wGo9X01yrwrLFIpez0BOhndwk67ld8uto2cNo39segCrCA1FbuAbXg0Z1epvMynq/fqoizQQ5Wb9tP7vbsEzgI55xr1SL1jShUUsonRW2gGJYoAHrWfPjlpexfdsdmDJKPKgSrzH7fw6vywu9h5SPkuyj9KXj4RP1QYlIAYz6U9U2TNIYdpM8E6efIP1KXcLZYbOkpPBtW1dTTR9XWuaQ6QLlLJT5RMJMfGf/kLw7dzIXHjAF1k3FIxUi0zEcrwIXKzb2S4CQJ0FAZ8qgl0BPYc/31xC+qjopo+crZe0bR/UvcN5htmx1kXb6yeRIA1QGczNUNJ7EjU8iHMz5KocIqjBNVCG9B/ksNQKtArcsurSlzx65KyRj1hxHSQDuoumPOgl/0s5eC++5qA+YiO8LB2aSHxE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40cc3033-4fe2-46c8-871b-08dde641930d
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2025 14:45:47.1735
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: toN5GIq5HdgHC/+W/X1VH5g6PItucSbripLmPDmzNyEVLnSdNy2UaNqDsEvUQXL5KzHEtGGMLQf2AJOiEvrXA6xDkYvVVDUKBtT+xWtLAeQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7530
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-28_04,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 malwarescore=0
 adultscore=0 phishscore=0 suspectscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2508280124
X-Proofpoint-GUID: UY-aZ_0k4KZBPJh5SQO_D9BXJ1eGFdM9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAxNCBTYWx0ZWRfXxVO9nhg6tKhm
 GWvB57uAbN1h8HfJQsqwVYi1kddfDdzMGbnAIIpf0s1luwOy7ejt8Ssy2TpQHfVjdZ5V22W8mPT
 dMRI6Z8stBaDnEtR26rFI0bbeTmKWzCD0y6t/ybf21wD0L2jY+iUTJ7+hP7Rd868bIHpMDuJfDD
 z6pTyxLP1VGrdEH8iFDR/6+C5bq6NKAWr13wdy89AvLHpscRZsKbjXK03TvIVVNGptU+ac/PhXU
 Lc80Ug5/48JOSVkfGbtaar3ODEcfd+LwH1SYjGpGIl23ivReju2iDjVfjnw1VmlUqHAgSq0Ef8J
 XFrkYUQKWqP1zOQl7qZti2T9O+ukcsHP3QW+i9X5820AbwE/d80DTgEsZf2J9tRJT+hcNsarkcr
 Aj9yWu+V
X-Authority-Analysis: v=2.4 cv=FtgF/3rq c=1 sm=1 tr=0 ts=68b06ba3 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8
 a=AC1hTx7W2U6TmaToLwYA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: UY-aZ_0k4KZBPJh5SQO_D9BXJ1eGFdM9

On Thu, Aug 28, 2025 at 12:01:12AM +0200, David Hildenbrand wrote:
> Let's check that no hstate that corresponds to an unreasonable folio size
> is registered by an architecture. If we were to succeed registering, we
> could later try allocating an unsupported gigantic folio size.
>
> Further, let's add a BUILD_BUG_ON() for checking that HUGETLB_PAGE_ORDER
> is sane at build time. As HUGETLB_PAGE_ORDER is dynamic on powerpc, we have
> to use a BUILD_BUG_ON_INVALID() to make it compile.
>
> No existing kernel configuration should be able to trigger this check:
> either SPARSEMEM without SPARSEMEM_VMEMMAP cannot be configured or
> gigantic folios will not exceed a memory section (the case on sparse).

I am guessing it's implicit that MAX_FOLIO_ORDER <= section size?

>
> Signed-off-by: David Hildenbrand <david@redhat.com>

LGTM, so:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

> ---
>  mm/hugetlb.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 572b6f7772841..4a97e4f14c0dc 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -4657,6 +4657,7 @@ static int __init hugetlb_init(void)
>
>  	BUILD_BUG_ON(sizeof_field(struct page, private) * BITS_PER_BYTE <
>  			__NR_HPAGEFLAGS);
> +	BUILD_BUG_ON_INVALID(HUGETLB_PAGE_ORDER > MAX_FOLIO_ORDER);
>
>  	if (!hugepages_supported()) {
>  		if (hugetlb_max_hstate || default_hstate_max_huge_pages)
> @@ -4740,6 +4741,7 @@ void __init hugetlb_add_hstate(unsigned int order)
>  	}
>  	BUG_ON(hugetlb_max_hstate >= HUGE_MAX_HSTATE);
>  	BUG_ON(order < order_base_2(__NR_USED_SUBPAGE));
> +	WARN_ON(order > MAX_FOLIO_ORDER);
>  	h = &hstates[hugetlb_max_hstate++];
>  	__mutex_init(&h->resize_lock, "resize mutex", &h->resize_key);
>  	h->order = order;
> --
> 2.50.1
>

