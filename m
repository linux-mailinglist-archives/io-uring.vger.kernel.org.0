Return-Path: <io-uring+bounces-9452-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EF01EB3BAAB
	for <lists+io-uring@lfdr.de>; Fri, 29 Aug 2025 14:03:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A5934A05FAC
	for <lists+io-uring@lfdr.de>; Fri, 29 Aug 2025 12:03:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 137A03128B5;
	Fri, 29 Aug 2025 12:02:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZwJf76Cg";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="O8BRZ0+/"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 239A426F28A;
	Fri, 29 Aug 2025 12:02:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756468979; cv=fail; b=Y7sBLZZJg0hzf1QrLwB6fldBxUOd79QB0cdW9KQ237vdcyOqeEcOjeJ3W3eLaVUdQEW0aikhkitE7J1jRL2zGxHcrIHsyQF1INOPJmB/tcLpfMGuOYlcy5xBZvHozbA/lnQ6USOsWp5iubaN/mjvexYL+aGwH3f5B6NIeuZTQAo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756468979; c=relaxed/simple;
	bh=C2/v4+zi+YlafEN9lNUZGYZF2PzK6zfwSUNTCU4J73Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=bgp3ANorfY380D/uCBYEcAm/6z1XO9qRx0g4pe3UrxDOJKEzaTyH6H5F9TEHvY3Hm3KjAhehe0eDRilsrevBTl+sIKswaP+6Ioz8Cd04jf+KQBup2CwgWasAXKBiQxBJeiCadDhDMW9r/SBQm05CRwRKTED3YYhMgPCM1zFmA2E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ZwJf76Cg; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=O8BRZ0+/; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57TAYCRD026346;
	Fri, 29 Aug 2025 12:02:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=ropssV1kW0825QBDmL
	OMyjtvK70rbb6S6HbYXYLI1wA=; b=ZwJf76CgcTUvjFKfqYZcxxq1SpnTlLP+Mu
	xMRoKVFw3IABG1KKuFdGpd+VceHZbDLlGjSmfdz8FrQNKN2TV/vgqkg+ftDWO0Sd
	aQVD5Gb3pyVVedi9wABALgf3zqT5pHm7c3d/a1uj5awdUbZEUkrlgzirC92z2YfI
	USUJXaiqzLguDZpAiuiAA27v4vMO1StrF3HMHnTPVGvVmLv9jbZmwbioJHqdd/7t
	Y6bacDKskAqmaE8wPWhVXeYjXbEYFXnu4PROGK3zTzPQbnggM/fKyLufKvNT2s1z
	64xBgsJqF+r/enikfu/qN/rqOMPh26V8dEYwcWIQ/HG6n5QGYulw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48q48eteks-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 29 Aug 2025 12:02:07 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57TAEKse012170;
	Fri, 29 Aug 2025 12:02:06 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02on2073.outbound.protection.outlook.com [40.107.95.73])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48q43d1fv0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 29 Aug 2025 12:02:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=M6U3ZXyRDu9118P0PGgLkIwuZiDctgr6IleZUZ2ljEjkTGwSMV8Cnl3jbnImlgcWrBEmZb31HCbH3y7DjLVJXf0uHDpUsygLc0COXb7oz7BggmV8XaahrmAQYpJhNiXP4CWiNkH+ugnr6Yd3Q25GYDFrJ+ELKbWVzzplpWYASxFNq/BBJlXiZwNDpcZVddqYpwb2SNHFuVWrgnL/m5apyv9/yjHUPgl1CtULMlKsft7EHR/2A1E0rk6KLTa+p20vd6NxsU/O6mmLp2uv9j1Knk6r+fhXcNjElO0qUILFcMPBe5RVOoL09ZRH5xyjqDs7RtvSZHdLlChtxcqQvfYeDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ropssV1kW0825QBDmLOMyjtvK70rbb6S6HbYXYLI1wA=;
 b=UxLziyFMCoS3xPwXMyrFxLORZcfnKHRtLK1olmCRGfch9r5S36vkh8SPxbA91J4H8DRVD0PeKCeZPlqaEKpPmTXMo555DhRdcCiFLGi/LL7vInhZ3QEt/Lo07969hQSc8BAZ8NebkVs9oWk1sm4ZFQzu/PHy+54uRzfdfhub/1GXt1MtqPOQ7Lu5DuxjLP2XiYAZ0yMGdZaEzTIKBkQ4R+wC+Z73zHWjzS5K+bUS+eSTPpxI8j1GA8VSrH8WOdbeAEgKjp41+oi6wZu15Kp59i5QXOAtRU8BeJBE+k4/7ZJJWMDZd2jvT6k6em46UTAcjurWBK5330ygr1H4kJJgQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ropssV1kW0825QBDmLOMyjtvK70rbb6S6HbYXYLI1wA=;
 b=O8BRZ0+/R05ouceSeUB5JXuxjxLAi+u5cLP+VVFpIcPT3ELXNcIxb4Rfm9kNUEGF5NoxYmjYO7ayHMvQyuPQXU5w4DaOW1v7LyNokjS85Ps9JWLi2+/Z84EWQp9WFssDWvR0Uq9RJHTr5Pic9pVf33sAJtigAkUxb7+J5oDArPI=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by CY8PR10MB6803.namprd10.prod.outlook.com (2603:10b6:930:9a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.16; Fri, 29 Aug
 2025 12:01:55 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9052.019; Fri, 29 Aug 2025
 12:01:55 +0000
Date: Fri, 29 Aug 2025 13:01:53 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, Zi Yan <ziy@nvidia.com>,
        "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
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
        Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
        netdev@vger.kernel.org, Oscar Salvador <osalvador@suse.de>,
        Peter Xu <peterx@redhat.com>, Robin Murphy <robin.murphy@arm.com>,
        Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
        virtualization@lists.linux.dev, Vlastimil Babka <vbabka@suse.cz>,
        wireguard@lists.zx2c4.com, x86@kernel.org
Subject: Re: [PATCH v1 11/36] mm: limit folio/compound page sizes in
 problematic kernel configs
Message-ID: <32fbe774-d0e4-498e-873f-f028347c1fcb@lucifer.local>
References: <20250827220141.262669-1-david@redhat.com>
 <20250827220141.262669-12-david@redhat.com>
 <baa1b6cf-2fde-4149-8cdf-4b54e2d7c60d@lucifer.local>
 <eff8badd-0ddd-4a5f-a2ef-0e3ded39687a@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eff8badd-0ddd-4a5f-a2ef-0e3ded39687a@redhat.com>
X-ClientProxiedBy: LO4P123CA0194.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a4::19) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|CY8PR10MB6803:EE_
X-MS-Office365-Filtering-Correlation-Id: be3fef25-365f-45c4-baea-08dde6f3d959
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?97rj377hH6VGdTR6VwmgQtK+wmj9vaOa+HA9Zrh3cav0U6YXAI+Bz6fLjBXB?=
 =?us-ascii?Q?wHSBB9uKiDQDURJsjasx66TPGHwN6AJVinXd/d1FELV3DxvW3HBCT9z06AtA?=
 =?us-ascii?Q?fEbnoVLLy2TBAzoc6SW01QiuH++u18609az1yKU+lhLsTlkaRwEU4qPS/E87?=
 =?us-ascii?Q?zunrTTAp+6x6a33XtbpwfzUlTeUDRHH3e6H3DxZwte4JaENSA4H8y3drQJ0d?=
 =?us-ascii?Q?6Dh2VvA3p+AO4iJX/e741zfNF7wesNCaFhNihfHAK/ur3ICHYjElrz5XZDr9?=
 =?us-ascii?Q?qQlFczD63I4Bw0voBgrmBhTsoMIIEfFH6tQSFm8iwwO7zjj9Gtu0A+xKIcuh?=
 =?us-ascii?Q?ntRNDsKBU6ZhFeniklMcjqHp+2ab964FFmGC5WzoqqMk7BbLg29VW9DVs0do?=
 =?us-ascii?Q?QAeh3fVgrVUGmrebarUUryP6bNLLdfAFb/Pbm/PfpwI/uQKXywMgJZLVYu8i?=
 =?us-ascii?Q?GTHh3T8GXwshGPqsfaRXLeqkkygEXU+nrn6pHo8BITBuSOvowkp0uNyXcGsv?=
 =?us-ascii?Q?Xu6YXJPiHFyQJLx5zLsqVkMksTDbgUU+IJQofmv52oixjEdE9E4Vkq1Uc5uw?=
 =?us-ascii?Q?AVWcEGNNDTo7cfI3pITd3wbbZ2evFC2xc1qx0+ZnxvZSWpeaXfkACGBzJjhE?=
 =?us-ascii?Q?IacpaiCya5Rxvp03U7eKmupE67SafIVidYTkhFe7hAN+pQAgce4nxnlJiQPj?=
 =?us-ascii?Q?5TLX0heQiMvEhh1gXLXBfRKqM8krNYh0ZQMKCYMl3WU+C090EyZn4xiTqxUj?=
 =?us-ascii?Q?p7u5S07fL3dEGKd7dSesG7yPplOT5k23WKOu/fhEaI2TkV4o8S9l6CWEHsJB?=
 =?us-ascii?Q?bqJGVfPDY155PFDaO6oagDS/wrIHTY+5DfJNKGpO/aJchb94nvbCtPsKumEP?=
 =?us-ascii?Q?BMWwi8Q/a9ZXdDY7/ENO9H+1F1fr+YyWvZw5eW5qY9a9vmxv7DSSCEXPlnbk?=
 =?us-ascii?Q?mL90cUUwmZUYseF/qxOV67wXuTsucsBVdZve1N0eI386uoi7JjCaZQEQoRyC?=
 =?us-ascii?Q?KBZ7OXw1+bjOE/292AxOzMBDYih3bKART2eJN+TlPREd0bF6O4gdHOTxResh?=
 =?us-ascii?Q?Sz4HEHU+JkeaPm1lG86ZTgur1dXWtNUXN5hLjReXiyO3F6G/yeMN59GSDQGx?=
 =?us-ascii?Q?50rD5mfT4sV1rg5ejLePZvTvjtZ3DqQrh9Lz4AcGTIZzx+D5OyPdeclA5MyP?=
 =?us-ascii?Q?QEjd7z7iCUqoj+kFA2oNPbgcP57+r25tsJ8DYIkUcssc+slhu9yTM8/Ibg0/?=
 =?us-ascii?Q?2ZHiLBBBU4d90bux2bmPTg2QKK4GuNevPk02XGv+0An2Gw415HxRcZeRw8Ym?=
 =?us-ascii?Q?xZUn0VvBVRg5ZNSZ2hSXwUjirHmjUIB/R6b1yHBedMn5JYZ+USaVrsl/poVj?=
 =?us-ascii?Q?U1Rc79IApF0jN7dbaN1uWzgpVbz7jCrmXAGYxPNJXLk175udzviEqAQsr9nR?=
 =?us-ascii?Q?qzSp13MADo0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Xn7taUqYmBX3564HZnOx1Mp6c+hpJYPDpK1BSVr7n+1rrJMg7LtJ7qkMu1Jd?=
 =?us-ascii?Q?kxbyFJU0z2vfm8Jpo+uy96QjFdNb/pNjww0dhY4KHC/iivyynS+ExsBr5TvC?=
 =?us-ascii?Q?W9qz61UQlGENHi1kAVNLo4lPUxi5rARTZOE2Hd2cNmVo5EfFBwWfn0UR/DWe?=
 =?us-ascii?Q?mUVHGMcmVVJmWUg5FYGpiKobo3LaL/6HdqEAiQuuM6dSS2SdnFL66Lor6+6W?=
 =?us-ascii?Q?9yaRdDFEkJORGiMJtt35n1G/z8WkxXSnWPM1yVtrCApnQ9Wmn/ZYe1Xtj1NU?=
 =?us-ascii?Q?yB52ujOYbw48L9Lxxfp6w9WM1++NCGPLJWClnYjnIO34RS5hdzBqy34tRwLQ?=
 =?us-ascii?Q?irIZv8mxzz1PP6eV84hpOKwhRtg+9Qd8ErY/6EjNIVvsgfGVvtVtRy1c8wfG?=
 =?us-ascii?Q?nn7Jt5YzJQhlacWmKUXQRrW7d+zXqdakH9xuqUtWLmDw7Qs88TCekwZqk0jg?=
 =?us-ascii?Q?r618YYThiYqEbr5PNKI/xcL2Wzt2Ry02qheSS+5ipo2MTyiV9AseHhAdc+9x?=
 =?us-ascii?Q?x93JklWNfLTDTXq8otjNFmdGVB9JhbbPOGl+K6Qne4Dx65ogBCYPNPpZSnbu?=
 =?us-ascii?Q?lg3aDTXLHAVetlnxXXwWNcU+kHZ/5WjKNz/I1uDz7+eEcbBPaAYOqveCAKrM?=
 =?us-ascii?Q?mYhChRW3THXBWrdQLx3ZXZtpgyG18d5VnKIHkaR5YosOLQxfKsTfUzxOAIwg?=
 =?us-ascii?Q?h4aDndH4U5pXDzBnVBEuNsU3bzHL2xlmJwNltWuZhib0guI/2tUi+PqupMfM?=
 =?us-ascii?Q?DWoMpD2wUVkm/y4ul1Ze6YBwy9XjqGO4QHVRqvr1JezjbDiuOIbqAxjOZ+Y+?=
 =?us-ascii?Q?Fh2fsPspG826FCFOVx35KU2GUxTarsWsqq09+f86y19REzotRjLtWof2TdXW?=
 =?us-ascii?Q?wqKEEMKQvfwHbbfpA979hkU76hPL43HrI6BIELn4I9C7kBkJhKSJceX42yoh?=
 =?us-ascii?Q?js8kS0not2uNQQNTiHcaUKGffnQz+dSgqDq1YXNoW+7xy4Qy1lZIZQwi4fP0?=
 =?us-ascii?Q?jUZQfGDtWuqHcRkrNdw63r5E4+QmKkr5eb40F7+XRd69Xp4/3PuQXeD0PXoN?=
 =?us-ascii?Q?nf3BYgfAK3sFj3vktrWtcYtvQdHKI4a0TKm/OpO0NcmEBrAnXD5znYLnvM9S?=
 =?us-ascii?Q?0ZYtCLJkmg8JswlbsN36+Ol6wodrCNqrKpbIMN0gFAClKXyfFVKPMRFzxyF5?=
 =?us-ascii?Q?6Q1OJ93pVQQPDGCioybWolMxl7nzCQhAN8BszwgVMoxo3omCJE8F3UCOcr54?=
 =?us-ascii?Q?JKy463p32mpcuxqXqRJWk8NCQnXYnzTIgGpuTL2ASvE7IBb5TjlN9dWjdYVq?=
 =?us-ascii?Q?3wXXakFs2WR5Zwj/vsMfJgQACHaAnDpiEPVixpdDuOkCef81lI1MDoDbmtYf?=
 =?us-ascii?Q?sN/jd9w32Ut2DDzL8vy47LH8hHkk8g4lSoO1iLynj6tfx384/QmIalgpj+6T?=
 =?us-ascii?Q?AeB7QrP8ZOxrAiGejPwR/rAHoULQpEmyOaAybZ3+CnixdjeXQWDshl0CJvDk?=
 =?us-ascii?Q?Ct8nLU9ytI2yBRLGUtO0W+CxANZl8Fyn7DkLUUWLhWK6rxR9PvxxtPzrk61O?=
 =?us-ascii?Q?wcEuX4U+IIyqXTMizU5gSDczXSyRzSdKv73saHPXtlFMSlPSfmmbPnvzTnfz?=
 =?us-ascii?Q?/w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	bfeOa9TkTp4K9bSEiVEzFrC7nf1FSG4Xi7c98CB/Jm9jItzz8+h02UZpsS1eUoBL6vWLRQgj9yPiVhwqD/6I4mvQr77yGjLP9ZxlAZ0296zAPPnXbG1fdcOwVP6NA/8GhJyRA2okw0D4NysenS2C3fKVHjv7GYYTHUvX8y2JSTBLh0tgTaQesMKSLjEHo2rvhphluFU5JEws6a1WcCsQCRy9zTe2V05xQSS3RoXenRYW6CqibShqUuEGt1XR+BD4FuLPlTwk+OB3tVH5ev7pVhFwKOO8bhRts5wWHNxOJMxgoPT52wkoIVhAjIQ0zdIMTWOd/GR8CVx6aSbRnt4DIdrqbevVA2M0iyPuPuEH6nEmnzzngU9bmdp4Tc66PW9ni7gWE/+fxeuior0FU4ByDOmor/mEToTTw3OG9CIZGfaCu4CigZDB4GpHmjvXZPyz559WhcWVpVDL78xfzG6DZwvMGsx8sdwhY7JmuCzkNC17NFy8XFs0ASXOBwns9HwStGh7py3itq4/9B8FDnjU0038SMQNmEHZL3bBmjACml9MDYa7Yc9wK221rcN9Vmg3D0Y+NDuU4/K7WH0nIOulo9xXZV5ze2XVmSBVPfRYDqo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be3fef25-365f-45c4-baea-08dde6f3d959
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2025 12:01:55.5355
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w1TKci2/N3PDNdb9Suw8LDqh/VuVK+Hb0gS9gIOAb7P7El5Nx7fQqBxAoAXqhQVGNQpE9lWz17pDLQc0nDAtEB+N6p0xwttlYrmEY9+Tnxw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6803
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-29_04,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 bulkscore=0
 adultscore=0 mlxlogscore=999 spamscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2508290101
X-Proofpoint-GUID: yQnYmdM59FIFN2b72gyTz9eZgPiBrH7V
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAxNCBTYWx0ZWRfX9BmadXgLxoDJ
 8wpr5mCGKA9bMfQ6BmLotOLpS0Uoedmj+4kAN0X5o9pZZ1ln/lCvElhBwGjNHEFZBlGGgygpzuO
 F+aJJihdhrW9/A/kf2npbiqzhiKiMl0xCjP0fDeaC0b4w15E5HuhUBXpItrIObXFakttAN/zLz8
 OraWSi3XvpaZvDVj2vwOK8EXBa3yuNt1xGsaTmN1ELziUIr7duxC9IsaynoXmVE3iWQN0jJnWHj
 9LiyC2zG0CZwMDdKdIrbB/O0Fg+WW0AlQW2b5HsG3TtDxQZjmFQAWFkrJ/+x7P8s6WEPGb3UY4O
 MRsTzfUMXNJMPkKe+7t34RbQclcz7omTFZ8xr4Wt1CTL5eYwwBAE+rgvLmP9Bs0jtFeWOcgo6gI
 4yBo/FLr6QHuqgKn7Xf/aLxSXxObnA==
X-Authority-Analysis: v=2.4 cv=FtgF/3rq c=1 sm=1 tr=0 ts=68b196bf b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=Ikd4Dj_1AAAA:8 a=VwQbUJbxAAAA:8
 a=20KFwNOVAAAA:8 a=zVLJaIZTk6tPunSsBkoA:9 a=CjuIK1q_8ugA:10 cc=ntf
 awl=host:12069
X-Proofpoint-ORIG-GUID: yQnYmdM59FIFN2b72gyTz9eZgPiBrH7V

On Fri, Aug 29, 2025 at 01:57:22PM +0200, David Hildenbrand wrote:
> On 28.08.25 17:10, Lorenzo Stoakes wrote:
> > On Thu, Aug 28, 2025 at 12:01:15AM +0200, David Hildenbrand wrote:
> > > Let's limit the maximum folio size in problematic kernel config where
> > > the memmap is allocated per memory section (SPARSEMEM without
> > > SPARSEMEM_VMEMMAP) to a single memory section.
> > >
> > > Currently, only a single architectures supports ARCH_HAS_GIGANTIC_PAGE
> > > but not SPARSEMEM_VMEMMAP: sh.
> > >
> > > Fortunately, the biggest hugetlb size sh supports is 64 MiB
> > > (HUGETLB_PAGE_SIZE_64MB) and the section size is at least 64 MiB
> > > (SECTION_SIZE_BITS == 26), so their use case is not degraded.
> > >
> > > As folios and memory sections are naturally aligned to their order-2 size
> > > in memory, consequently a single folio can no longer span multiple memory
> > > sections on these problematic kernel configs.
> > >
> > > nth_page() is no longer required when operating within a single compound
> > > page / folio.
> > >
> > > Reviewed-by: Zi Yan <ziy@nvidia.com>
> > > Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> > > Signed-off-by: David Hildenbrand <david@redhat.com>
> >
> > Realy great comments, like this!
> >
> > I wonder if we could have this be part of the first patch where you fiddle
> > with MAX_FOLIO_ORDER etc. but not a big deal.
>
> I think it belongs into this patch where we actually impose the
> restrictions.

Sure it's not a big deal.

>
> [...]
>
> > > +/*
> > > + * Only pages within a single memory section are guaranteed to be
> > > + * contiguous. By limiting folios to a single memory section, all folio
> > > + * pages are guaranteed to be contiguous.
> > > + */
> > > +#define MAX_FOLIO_ORDER		PFN_SECTION_SHIFT
> >
> > Hmmm, was this implicit before somehow? I mean surely by the fact as you say
> > that physical contiguity would not otherwise be guaranteed :))
>
> Well, my patches until this point made sure that any attempt to use a larger
> folio would fail in a way that we could spot now if there is any offender.

Ack yeah.

>
> That is why before this change, nth_page() was required within a folio.
>
> Hope that clarifies it, thanks!

Yes thanks! :)

>
> --
> Cheers
>
> David / dhildenb
>

Cheers, Lorenzo

