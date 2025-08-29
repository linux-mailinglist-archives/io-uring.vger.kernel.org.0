Return-Path: <io-uring+bounces-9440-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 814B6B3AFA9
	for <lists+io-uring@lfdr.de>; Fri, 29 Aug 2025 02:36:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BFA0D5E680D
	for <lists+io-uring@lfdr.de>; Fri, 29 Aug 2025 00:35:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3421E19C55E;
	Fri, 29 Aug 2025 00:35:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="G4Gpk46i";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="kv+qBy5/"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46A7C84D02;
	Fri, 29 Aug 2025 00:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756427718; cv=fail; b=ErS3B/EVJ5eyG3Gn8DSLcZAJTk6w6DIkRYk4Be8QUysBo5dHFneI7X3yDR4XEGZnmCcS64f2JJpI1q/0ryFjW6aNdFHxYIynkSDFqldcQ1NzgDKaf9ruJSDksIV79Ku/mEZQuhAUUOims9r0wbbng9eh4yWtBlbc1Sl2uNhtmW8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756427718; c=relaxed/simple;
	bh=DYtJQgr5Ge7zVpiyqLMP5NWeZLD4Ya0PUJ7QpOzuvRM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=myeJ1SRBgEMUJzDlMbfDQ8SXPvHpe9cCJFHHVjGyDAVBKD7By8Cx2d6GPnA9ROvo6sqSuaGakkdHZMwe5n9aNeEr6DxCjaf6CK56SEPs+royQYB+iS5J7VfVS2x7YX82nOOWOfaIxpW8eKxU7MoXXL4SgSz5ifw4UQ5RKkv5O4Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=G4Gpk46i; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=kv+qBy5/; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57SLVCvl007464;
	Fri, 29 Aug 2025 00:34:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=bf+dZtkY792uznI9Dk
	y40qn+EPBn7tT6SvULiVUBMDk=; b=G4Gpk46ice1E8+n9mChbyg5VkrSxqHV8LZ
	ImJIUIOypzONV53E0UWfXF1qsN7vQ1EGJAmtKJCd1KUI+BV6dEsbtkSIONOx9dN+
	rD390hgo+PHx+Ofmspd75E52LUeV9zfzR6hGV3iKty/2c1mPAjVZE4B4vsl59Cx4
	c47B+2qO43Hz01dE0DC/p5J1X9U5jodugkzOlyn0zRaw0DNbEJrX+zaiZa6wmLt8
	c4PvwoipB3msn/S5J9+/gaBpKjOVzpihIKlH9QmAaRT1FNDLhogw3s8nowhrRNWU
	rYGUjD2W3OaRTL6oFfGP777nhi847t+sn27iSg6/wEhUbuImZg4g==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48q4e29qa3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 29 Aug 2025 00:34:45 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57SNK8FO027318;
	Fri, 29 Aug 2025 00:34:44 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02on2084.outbound.protection.outlook.com [40.107.212.84])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48q43cdvcu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 29 Aug 2025 00:34:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Kh6Zn6DRO8Y3Uk5gb/TLb2jw+JGHWqT2pgIc/IKBmHpRVedURC8HKUcs0Hn1Dk6W/RqN5PQFY06CPzx7sr2EdCE6/nCpQ5UZ0p30/3Mx7wVDtc/puIY3nw/KKtfp7+p9Vt2AmA/gzppUgamfM75I764q4wllrkyxyAYmi0SLU8UWilsSIkGRvUeyOFoEMldI3tnuOE43MkeBYg5mMAZl1duNbC4w52mjm9qMu7/mwAFltVZxdq+0RZH5rG2m9XyjXiXwVtFJFaHcJ6s6PiXlbYJhppXSLbx1mSE9LE/nwkpmMXz2mCUeEH1zeWc6goWudVWnXhE9FVVNOwYguBGDXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bf+dZtkY792uznI9Dky40qn+EPBn7tT6SvULiVUBMDk=;
 b=RBt1amcvCu3DnqOHdNoW6YJqVJM3f11Z7xDcuw2o3qDfWOPi57Ea9TFYfARQt1M7IKOhXpbHy4lY/oLZtg+ZBbMpDA37TEt+YGwU2YRZrcC9zL+P6TOCAVksmBTyu5nDL/fz1ht8id+P9Jvt1+9jLajF4PzxQw+AiRL2eMhLcVTxzjGtUfDoXwef4czm3Y/p5rmqKov3tQK3d0jQpuDzoJqFW8+GPSFcEdeqqY4ClDbQrppyAaGrnja5SQip7TIyNzXfJaTKrVdyW6V2cYlj3CLBVYUixeNiBQ8HSG+C0fq8X+e5baDNShEumdiVZCvoPuWwJoJdz1hrcxNku8QNWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bf+dZtkY792uznI9Dky40qn+EPBn7tT6SvULiVUBMDk=;
 b=kv+qBy5/jkdN5FQ1ZgOz11EuYBmPOrTO9kKSvyOzyBkMO2mcPq3URgKMp6VcPJGGr21zqmQuS/xezsCDBv1yjR49O8mjB4hJ7cfS2Rbh+TVHJ4Qwq9LWae4i3b6MN/Hxrfaz95cWctuF9zP08n9OG9DGX/qw21n0AqcmY4IELaI=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by DS0PR10MB7019.namprd10.prod.outlook.com (2603:10b6:8:14c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.13; Fri, 29 Aug
 2025 00:34:37 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%5]) with mapi id 15.20.9052.019; Fri, 29 Aug 2025
 00:34:37 +0000
Date: Thu, 28 Aug 2025 20:34:31 -0400
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, SeongJae Park <sj@kernel.org>,
        Alexander Potapenko <glider@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Brendan Jackman <jackmanb@google.com>,
        Christoph Lameter <cl@gentwo.org>, Dennis Zhou <dennis@kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, iommu@lists.linux.dev,
        io-uring@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>,
        Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>,
        John Hubbard <jhubbard@nvidia.com>, kasan-dev@googlegroups.com,
        kvm@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>,
        linux-arm-kernel@axis.com, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-mm@kvack.org,
        linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Marco Elver <elver@google.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
        Muchun Song <muchun.song@linux.dev>, netdev@vger.kernel.org,
        Oscar Salvador <osalvador@suse.de>, Peter Xu <peterx@redhat.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
        virtualization@lists.linux.dev, Vlastimil Babka <vbabka@suse.cz>,
        wireguard@lists.zx2c4.com, x86@kernel.org, Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH v1 07/36] mm/memremap: reject unreasonable folio/compound
 page sizes in memremap_pages()
Message-ID: <4rjh3rjhz6c3iov3ukkrhwm7yyma6vfsbfynrzaciw2jkdw3f7@mipp5xo2zqbe>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org, SeongJae Park <sj@kernel.org>, 
	Alexander Potapenko <glider@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Brendan Jackman <jackmanb@google.com>, Christoph Lameter <cl@gentwo.org>, 
	Dennis Zhou <dennis@kernel.org>, Dmitry Vyukov <dvyukov@google.com>, 
	dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org, iommu@lists.linux.dev, 
	io-uring@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>, Jens Axboe <axboe@kernel.dk>, 
	Johannes Weiner <hannes@cmpxchg.org>, John Hubbard <jhubbard@nvidia.com>, kasan-dev@googlegroups.com, 
	kvm@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, 
	linux-arm-kernel@axis.com, linux-arm-kernel@lists.infradead.org, 
	linux-crypto@vger.kernel.org, linux-ide@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mips@vger.kernel.org, linux-mmc@vger.kernel.org, linux-mm@kvack.org, 
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Marco Elver <elver@google.com>, 
	Marek Szyprowski <m.szyprowski@samsung.com>, Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, netdev@vger.kernel.org, Oscar Salvador <osalvador@suse.de>, 
	Peter Xu <peterx@redhat.com>, Robin Murphy <robin.murphy@arm.com>, 
	Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>, virtualization@lists.linux.dev, 
	Vlastimil Babka <vbabka@suse.cz>, wireguard@lists.zx2c4.com, x86@kernel.org, 
	Zi Yan <ziy@nvidia.com>
References: <20250827220141.262669-1-david@redhat.com>
 <20250827220141.262669-8-david@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250827220141.262669-8-david@redhat.com>
User-Agent: NeoMutt/20250510
X-ClientProxiedBy: YT4PR01CA0064.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:111::6) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|DS0PR10MB7019:EE_
X-MS-Office365-Filtering-Correlation-Id: f48655be-60f9-4c8d-48cf-08dde693d565
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?u0edYF7STD20ATHZ1jIw01TST2Ai0Y+jMGnTLvOnfUKcM7G7YL7WGNoHK253?=
 =?us-ascii?Q?bzJHntFFVUVH0bwPQq5FAQ5OVDjAJNsKJWARN2tXNiEGjjZPpDUIwWsRoqnS?=
 =?us-ascii?Q?0ppKM8bAoMkxlP6ckARtiuJCnDC2+JpHBHBtp6SamNhtg5vxEzdcNZsXJsms?=
 =?us-ascii?Q?D5EU3jRaKDkZ2vVWiqfv1uaUrYfzv3udInVMZqX+ceNzl5o6mqhznla4YHzp?=
 =?us-ascii?Q?LUPdZfhKx8g2b+Z9ubvgVwvOTK/ryy7xiq4J3/uPGMqk5z8ndSk0xrRg+jav?=
 =?us-ascii?Q?QcFErQN2kJNTKI4Ag0Z2HNZnL//HzOrv+0PO1Xr8Qj3tLPEzTr30leEGjM3w?=
 =?us-ascii?Q?GkI4Vcgx5Tps/NERFyLLxHqzD+MHpTaOWxge1mPdAeFjyggz9pBWDc0+o1CY?=
 =?us-ascii?Q?pLwVC4+jeiBsJXkUMfYpN+9keZUjIs2D1QerkF/miCPSRDTXaiXbAqByOppa?=
 =?us-ascii?Q?qTDutptiXVIwLtHjTA798lO5xLFkMTHvzt7I84rWKWSkg3sJ5+1IOHUUsm6h?=
 =?us-ascii?Q?2x4DWsNT3typDDtjBhd4MaUbJJ8wb16QatAHo+BFb//iIuNFVNfPmjDP4HY6?=
 =?us-ascii?Q?zNhkSzXB2hAoKKPtW88zpwmz8al3K9tDhGvib5e04qzR+PJ6uNd6eZy5ddZE?=
 =?us-ascii?Q?qPSd0sTQHc3hVcgW89HB0tNUgpr/Zue7q3tO+c/y1LHIeJe0XRs7Rv/39MC2?=
 =?us-ascii?Q?wOr4n64ntBQ0KGDKbcwyyZbHAHrF/krTdbli9qAyOJMzHcApM1B5oYdU1SpK?=
 =?us-ascii?Q?8wrZkeiZN4h8PRLlTvr9eBpTeByDplYEsqd1uNqritALVoAB4kQZqo3/D5GI?=
 =?us-ascii?Q?FpM+AWr4NFuFKE6xZheSLQ67w8DU+45IehG/SELtuW3dAWWgUWR/U4jfViCh?=
 =?us-ascii?Q?etfR2Qd7WxxX7DjmHm0rZj8P38x+2WliaN4thulf5Mv2iv09w9Dtjiq0ei2l?=
 =?us-ascii?Q?tWwEOFF7o2eGfyxgOyRPozNU/5ZBFrIXpaewCgLCKLnWObx6ECU+xOrmZGIp?=
 =?us-ascii?Q?iCU+UsbvSarO++sFZUvVg3EOchJbaIB/l+1CkXzuoebnCaApd9m+3rCJozZU?=
 =?us-ascii?Q?Vc6bf3Ift+UkuLLDvBVMbjpylXO6eY+b/UmqmNn3vUcB+IOBcBe0+nmFXf97?=
 =?us-ascii?Q?DukzZNMv1vPsWus+Aa+01dSdTHKFihj5TiERz27S8G4hlFe7bHjb+YX9twfl?=
 =?us-ascii?Q?Wn91k5+ZUnCiRHvYUmYQem7cAYn7LQHIIlB1bZ007jbLtfpeZRL9LVZ4oV+Z?=
 =?us-ascii?Q?aYzNs3WGdJi2Tm64o2UpsRkq2JUONC2FrWtDzrjfbJiZfTJy79WRCD7yqBj1?=
 =?us-ascii?Q?K0suClL/rsj+wXrDexemsG8GBS/lOOoB7i7R0BQhEuzmU0bLnQP2+XiJ6XmS?=
 =?us-ascii?Q?SZL7c9G8ooQCshkzoV6tKjbOPIjaoOqX2VUJmHYM/F4Mj5Pa1X41hFgMv4j2?=
 =?us-ascii?Q?g8yLBE9plbU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?/MmsOcHmbQPr+BWY2S7jRV/h/Ejdq+Bn/6yS/vuaGDao9Xoe5HyVHex7vv0k?=
 =?us-ascii?Q?aiFh93HSTr6h320K2eozRRW1x4ijpDXLw1a22/3t1nmmU1Oks5/nLPDYi4xU?=
 =?us-ascii?Q?UUx09CgBVlG5eKcw0e5VSt0QArHPsQhAT5+LEi7hUpr4JVjP8drpdNTEf+50?=
 =?us-ascii?Q?HMbd/egCM0Dzb+1M8OACuG1jRcHHb4oaQt7Tiefzqh6wxju9dr+Plk3HVkDg?=
 =?us-ascii?Q?rOovJybX1jF2J6hsvzmKiQPOE+wM/jOvbNpkhhlB0w8mASq5Mh/bkHfNcIA0?=
 =?us-ascii?Q?rIjouPt0+tScGdh+AC91PgxYhdIrs2ZS3Xuj/peSdHzmcRfaTOo00QlfJOQ2?=
 =?us-ascii?Q?NdS7a6JBcvsO2CO4mXa1jyGRDlo5GFcEHp4nUYHXMbRRRsIoxZGgH+I/qKEy?=
 =?us-ascii?Q?Uy44OEQJwqkoX6f6K+upXK2AA+QGtTX+pCedV4FEh+SUKQYSQu0qyGwqz8ns?=
 =?us-ascii?Q?lSMya6hTXT7OUuhxmjD00PCtD7XO0RdJMyZIItlpMjNDCvV0NlHftE6BYCar?=
 =?us-ascii?Q?djqr4xfrqJgGzzKBpX1BukSZcZa8rjwphn/VNAP/D9exc8kRArRxaLqaikkk?=
 =?us-ascii?Q?Fes1+9tY1QUR3Vk6vF9z5npEubD2Su6NgxGYDCktT6UnOdl9kPspIqCiPcXh?=
 =?us-ascii?Q?ZKTT/TrCax10nT2/l5RG8aU8P2YZkFls+OCwrSRuIFYVQvT0KsEoM8lw6K78?=
 =?us-ascii?Q?NE9cfL7i36UVgeX1qwrILlhXoWHJK0yrrSmwjUcaMGXMaZ2oI9D850XBBJ/J?=
 =?us-ascii?Q?LySdXVM2TatQ/wOo9Uw/WW5WCjyZhc28r36rcc9e8EazVLlADWz/LfpOIcvH?=
 =?us-ascii?Q?LijOe7IxtvFj/8BP9P5nXMz4OBVKyyScnQyfbnfC82x1yZvrTKVHpBj2caL9?=
 =?us-ascii?Q?1WebMDsGUlZ9dLseuFass3Xep0EYQfsAi1Co1URKBm3+O2PtzcyR4n3DNun5?=
 =?us-ascii?Q?rHRzhU/QVu6QoTNIDoM7lRQnBp/WQvN1eTQ0G14hDZGpUz3035VPCak8Ko9w?=
 =?us-ascii?Q?uxn/lj/hPFHnPX2h+EBbLNoR4aiukXzd7X1xcLysxo4ntgKk1YwsNbgWxcHK?=
 =?us-ascii?Q?ZKh6cYvBir9dHyD9UAIIvLF81kBje+Uy/NXL10L6drNK2oNMb5noHjM6OYNd?=
 =?us-ascii?Q?XqOt8Jm330yGFvt94i93m21v1SrKxB/PF8fhDscFZg7mTL1ueU1lwUCll+Tm?=
 =?us-ascii?Q?SrtLl/j55MprTIz8iPxPO2w2pBr/fAR1QI8kJdjFNxVMlk6vuqCx1OdtEOzD?=
 =?us-ascii?Q?dzb/PY8yUtbjMA70/XfBbFuv67Yh4UfAzgkFFgleVkA0huCu+8JC7t4hOUAP?=
 =?us-ascii?Q?0zwwECGuXsIJ6DVRUO/JCmQ+ZpSrb84GNPAF75qFJcwpKciH9aRS4rJdAGXY?=
 =?us-ascii?Q?Lt2ehpk4hbTx5G+HM5nKekAeN5sjlu064HxvDd6P+gU0OyuNyDY5dIIF4ONi?=
 =?us-ascii?Q?v0p1Z7ageEM2ziudGFohNM63wOCRHQgWq2sLSHSKVmZaNQdh8iBzzarWo2GK?=
 =?us-ascii?Q?ALN75ia+Ov/OY/HGkNbLyspIpKxohF+8gVneZyqowLrgxJ5bsF+UYLg/SJgf?=
 =?us-ascii?Q?9WTzwNgjGRY9FjkjYQyxrmFfXAE50n0o4Bw/CmOJly7TVq2yIJYlV/GklnRY?=
 =?us-ascii?Q?og=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	yG6GTM/cbFzB+E7q7DZ1foBX0T+XGCHi5X+jKnW/2Wfj48qWr5UWRsdbivkbxhx0GSBbt4CO7yyp6mOUnNH2PRk9hbqDkDH1+h5hsbde8/zUYxAvhkq6hBbZZtZu6HgqkaPE/Ywtm4oxiyUyftvEN/Zk3Gj9iw2Uc1EUrWelD7W9F4Y77UBf4poexyobzj+w2ogtdStH/idiYnF3tbbib83oEdTb6tGNPnlCMV40LsdOmEZwlapTpnEKcXWP+S1q6fpt31C7ghDpz+6TBcpuLJuCAwNto0QQ7J0If01zX9MkKXfnW1d6vPG/KO3ZpEi2QdUSbgyQ8fwxzHoSe6PJbeLCsZ5zG3IeetMLDhocf4L82+zShqDBtHEGks2Pr7fQNHk30Sw/1Jm11RLu6oNgdm9MiFRnkvQmoiA1QSnYthhIsNx6T8C0YDIy1/pRg7TxJX0vZQHtP9gS6qDzmV9M0pXRy5QdmI/+NmPtechmiNRmlRMD/2NtaoYWZFt023DF//qumLm/IyAKda1t+KtwMDcz9DH3Gxj5lGuAyuQ0eO33mTM1pAGalRjsfR7tAXvz1JnLyVxSglobZQ3uT8jaL7oLLlF+7spr6yqgadf0KHw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f48655be-60f9-4c8d-48cf-08dde693d565
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2025 00:34:37.2640
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PYPgQBLppnAsuLiOvcauHEdZZjdXB3Nn5FR54GPZrjcPUnNXd7+sNTMCQx2/o/qU1y38uA2bRs22HvEZ4kJeJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7019
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-28_04,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 malwarescore=0
 adultscore=0 phishscore=0 suspectscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2508290003
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAxNyBTYWx0ZWRfX6vs+dLUxMQla
 Edo+GhDja4Nj0gy6ZxPdUdJ9AqLock2a9Y/3lHZojNutNBqTIKmpLXTlina6O33PDhdtdbimYmp
 fNZh62FVcaikLeIY0s+oINzgt2jE3j34U+uOJhrCGd1TWT4GFwAxP4qid413IsLPA4a4Cl87CLT
 V8gYv1dfQLCYtbbWtBvHCiFyDUv8vFS+7tH0zAz0wd9rQDc0W+dS4iA1w8EfSgSPLxYczTzIjrq
 3fXtbp2G0gIcp/p7yQyr/mdutclOZ/NAMTUERxRPtsAB7ibG6V0LdMbMvPAVnqmm2ximz/cBAIf
 VTrxZXvenuC/3UNkpsWXZY8YlSOYkXKX+KYepzNNspjbreJbGK9IoBTqYyGwjHxC9eDgje2wWcx
 virkeK2u
X-Proofpoint-ORIG-GUID: g4Nj1TYNJT5OoI10xo6wrOm9MzAqKl_1
X-Proofpoint-GUID: g4Nj1TYNJT5OoI10xo6wrOm9MzAqKl_1
X-Authority-Analysis: v=2.4 cv=IauHWXqa c=1 sm=1 tr=0 ts=68b0f5a5 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=f5y_YdlGBkd-IoBHTkIA:9 a=CjuIK1q_8ugA:10

* David Hildenbrand <david@redhat.com> [250827 18:04]:
> Let's reject unreasonable folio sizes early, where we can still fail.
> We'll add sanity checks to prepare_compound_head/prepare_compound_page
> next.
> 
> Is there a way to configure a system such that unreasonable folio sizes
> would be possible? It would already be rather questionable.
> 
> If so, we'd probably want to bail out earlier, where we can avoid a
> WARN and just report a proper error message that indicates where
> something went wrong such that we messed up.
> 
> Acked-by: SeongJae Park <sj@kernel.org>
> Signed-off-by: David Hildenbrand <david@redhat.com>

Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>

> ---
>  mm/memremap.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/mm/memremap.c b/mm/memremap.c
> index b0ce0d8254bd8..a2d4bb88f64b6 100644
> --- a/mm/memremap.c
> +++ b/mm/memremap.c
> @@ -275,6 +275,9 @@ void *memremap_pages(struct dev_pagemap *pgmap, int nid)
>  
>  	if (WARN_ONCE(!nr_range, "nr_range must be specified\n"))
>  		return ERR_PTR(-EINVAL);
> +	if (WARN_ONCE(pgmap->vmemmap_shift > MAX_FOLIO_ORDER,
> +		      "requested folio size unsupported\n"))
> +		return ERR_PTR(-EINVAL);
>  
>  	switch (pgmap->type) {
>  	case MEMORY_DEVICE_PRIVATE:
> -- 
> 2.50.1
> 

