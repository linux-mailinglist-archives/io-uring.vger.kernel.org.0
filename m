Return-Path: <io-uring+bounces-9395-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A129B3A19F
	for <lists+io-uring@lfdr.de>; Thu, 28 Aug 2025 16:26:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A0B7AB6186F
	for <lists+io-uring@lfdr.de>; Thu, 28 Aug 2025 14:20:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 500C631CA65;
	Thu, 28 Aug 2025 14:13:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mhMOJsyF";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Mk5AMWXO"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 968E731CA4E;
	Thu, 28 Aug 2025 14:13:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756390429; cv=fail; b=Kc2dgQOMUX9ok/Zc+PabyijRAn8H1m6IsAVHnULPOcnKqGmZhs9BGddogJ/pa8M2THRH442IbZyTnaehYc/ozvFFP2WLj8SrwuVGOhISHbMni9Bx+fZ3srH3y586WJ7wVrTdgtZlxsPu8EewzqsnNYwyHLEzz1pw82k2WtthbwU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756390429; c=relaxed/simple;
	bh=aiYw3LffghxFi33vD4R90I+lJob/yY6iW86NHylqxhk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Y5wLUOaVe8DN+7xOl76mVgVxQN5h7Yv52CAAuCgJY6mnP1DR9PUdSU8UFkRkhdSoNKT5eApGgAIL+CTw1N2LHtkRCvKWhMzaiDwPNpCAJ8P+0yPf70EgUZUTLYBc/WeS3OQRQZlTOVapti9Yd8sZMzvb3ZFMYsR+Gns2c7VSJrY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=mhMOJsyF; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Mk5AMWXO; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57SCivfP023326;
	Thu, 28 Aug 2025 14:13:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=Vwuta87SoO+OM5t4cY
	BUjiDWzh1pb4vYINT0cG7zvRQ=; b=mhMOJsyF4ZM0QZhCZVoOyvEaz3lJh997zt
	8EfRJP4BhEafQOHk/kvboY4K7fqnVfNWPk8a+rEUNUCQb12iNoFX3TmEW2han3/U
	aAr9Cmel8NYzQ1MFeRcNYl7RNw/1fEGuC/BsVLlzeJ/gMob7Oyd+1odnGUDISO+h
	gUOZOwJtJvCibAPG0B1rx1TyBMCsFPo1NoTjRpQUzd63x4tWFc5BGttHLNr3ccNN
	KBX38dz23YeDd29cwA3H1ZugxrlMKKn4ejqimJdsNjKxlbq1OyiXxs95BZpZ736x
	YPKZ45p0NJ0h3g33lLodJVvcWKDRXvW8C3dZYxkLgdEZy3uwfIeQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48q42t8f6w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Aug 2025 14:13:08 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57SD72tr018982;
	Thu, 28 Aug 2025 14:13:07 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11on2072.outbound.protection.outlook.com [40.107.236.72])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48q43c1qfj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Aug 2025 14:13:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VLbyPs3ltHjg7E/HBFQg2TdzwtXftnPkJh6NhmwiXQPtYg2JWSZlEJvp995/MHeKO4PgMcxIVzB/BcpfsqLdrA1T7xL/T21IXEEZtX1+82A4/tSlQxngLKQ6sY0cIS8DV1aEsao6fyC31kTQRKaWsSUa+fwoveL9/XT6nWUrTlxNYYRqaCuVldsX7Cm0vRgB5DGYCcaXQt6sypkULImIJqJoOEHZvZxUaOTPD52nRJhwWyiLaidjF416HKFfatXj5eTAelwopR+LaeuY2QSBp203zB3Nk9nCfzAX9MZy2orZEhNyLgvMrMyPY2p9c4/J0Y2kZtL7XPGLZr8crIHs1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vwuta87SoO+OM5t4cYBUjiDWzh1pb4vYINT0cG7zvRQ=;
 b=o1ElHyGwN7gJySuq16jTrba3V4z8/sXayqgWVmbjfpjIuyLwdNX6sNXgMy7bhyJijzbQW0ZsvjtqxKm3qeQr+1UsKt4Gsk++FUwvcYL81yYSmxmq5b7KLr44lqLwvwBh+a6EjLGJC9PeZl49S228rgmoZGPSNgJaP628r6BzQWxXd7qTMdBSyK3JphlwsfvvYeKVqnKIa3EIIGlMKWjqgkMxjBcKuAvDu8EU1l9RPVTsoinLDOdTYfNZ6GX5jQlDA8igwsSkvterf+d7cO2oaBcxN4FibltMtwkmmJxHbRveB5TraJQYCwhF+Pjn6G47UVOJnQbKvS57PeIFLZmEqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vwuta87SoO+OM5t4cYBUjiDWzh1pb4vYINT0cG7zvRQ=;
 b=Mk5AMWXOspv2penpEB/ooDt2k11nXyIpcCNGMaKK7wUbOUfkHRX0MN4m8+NAdGKqqGy5WwqbJklkMX13C3ftavZkp1tCxcloKV2RCvwwQp7JuR9CGpXTrLVvKu0tV3pTdlttIijuKF9dL1nrPWdy6sEUn1BbqAgO5DaQrKhpZ48=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by BN0PR10MB4933.namprd10.prod.outlook.com (2603:10b6:408:125::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.15; Thu, 28 Aug
 2025 14:12:59 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9052.019; Thu, 28 Aug 2025
 14:12:59 +0000
Date: Thu, 28 Aug 2025 15:12:49 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
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
        wireguard@lists.zx2c4.com, x86@kernel.org, Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH v1 03/36] s390/Kconfig: drop superfluous "select
 SPARSEMEM_VMEMMAP"
Message-ID: <6b835163-58e4-45e6-920b-c0594f97d315@lucifer.local>
References: <20250827220141.262669-1-david@redhat.com>
 <20250827220141.262669-4-david@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250827220141.262669-4-david@redhat.com>
X-ClientProxiedBy: LO4P123CA0548.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:319::11) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|BN0PR10MB4933:EE_
X-MS-Office365-Filtering-Correlation-Id: ec218813-1ec5-4acf-6d71-08dde63cfdea
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?0CXq/eF9XGlwKcZqMiCdFEVb8Yb8dC9nBuDCTbegSF2am1i2sf4lRvxJSOKB?=
 =?us-ascii?Q?8FrLdKjC6Z+PyprktXtYOojs4MTAhKAoa+uWBuUwTacC8L//pP/FKcLGtAAP?=
 =?us-ascii?Q?Euf2k3NsYySJiFrCNPk0E4dScE+rXtII+plRhFRHgUMKSFUq6QZGcv8hO23a?=
 =?us-ascii?Q?/6/cVn/e1M2D8O2n9/WcJq8sK9XMpXtyF0BWKY58wf1rECwlxtLqmkuaqMw8?=
 =?us-ascii?Q?J5TGamMNDI7YLOtkUEOSAkt3gy2IFTkKNX/Ksp+mtDzbn0rOiT6hz3xVrEkE?=
 =?us-ascii?Q?U/++AiHN+iH8g4J6kWEqe6mA4vlRyjghGl1VBbMoLWSk4PYJ14XPk40C6hJx?=
 =?us-ascii?Q?r1YslIS8Zx6BVM191jcZNg2j2I7wA2LZ+LKGRTx7AYVIesPr+y8Al+PwmJLa?=
 =?us-ascii?Q?kxCCn5DpjKf0TcoKAmMjv8wdn3UiMsb5f+fFXxCWe2MOac2ADJxdqYdUBfQc?=
 =?us-ascii?Q?C18mWhUuoCsQf3mbQM1C5KcoEhxvG0qgCiLy0UpjyPUodGFIXZ14+Z+IAZbM?=
 =?us-ascii?Q?ueK3ZvyUnQ9JbtYBmq4/kpouzykiZftcT27ofLOn0Tblxw1zc7M5P6WVgYwK?=
 =?us-ascii?Q?d0aLVlAokBRPqxoZ7npBpguQgdKvAtTE1rPb4Xi/B++J2IOQtprA4whtHJHK?=
 =?us-ascii?Q?5UUrpLwo64FICBfu2cqDpopMICQgJRNYtv28RNm2QPY3M6GXaBCq16HJNg1G?=
 =?us-ascii?Q?WNAgy9bTu+UvBVTbzrzRIpiC43ja4WqH1sSm1WHQaMvgQxWgeZ1aEXjYZtBp?=
 =?us-ascii?Q?YKZ4gHltg3rckaXHATyAc7i6Wn0bX2H7otNLU1ewetlZFicjUDp0uLEsBsid?=
 =?us-ascii?Q?XwWJ51w1kwd2hSDVHlUPaKTqcVwqgZQYJgOMx8hcHd7gwKGzoM86Sp0zug37?=
 =?us-ascii?Q?8ZV2gjaYSkiTPvOp1pCMF0aRWyovDEWhQESBDlGhuTrDY8HL9QZPcXHV1VYK?=
 =?us-ascii?Q?0aiRXFnhygtDkbFyBY59S8mOmIxBXXS+A/YUj7lOXFwLd6oWJlf9MMBhxoux?=
 =?us-ascii?Q?MbzQ8O+4AIxY5S0VHCIWHytTO8EtHZu0kLLKbPEPnQxbSyCgpYFw/87N41wn?=
 =?us-ascii?Q?koMefnfTQh0kNufGrCc0l/i68PUSAbtD3epGXjrb29OHNVVSns6uyxBHFtYe?=
 =?us-ascii?Q?6Hmjt7oh1fL/EEqJ+ZiBZvn257ZD3Dm51GTSHVW462xyUKTygdjCbVRWpHcD?=
 =?us-ascii?Q?O6yZGStq3UhQp3jpbLsmjiIS1kC7tZNbmQyuCjtVmgLXjkJCabNDTbxEDH1+?=
 =?us-ascii?Q?MrM2XhKR49R6AjQXgLXQpaJfA2Js/iP7HFAGYSwF52DmNIF1NoJH9r1IYVMw?=
 =?us-ascii?Q?x5KievTo0njgrTJH3LRvwjFi1UGvryriyNnE3TGPZaT6lT93qwK1v64QWmsq?=
 =?us-ascii?Q?uV90NQiuSChZiidIoh9n3jAtXPevauDjKqzcKw/f6KomGqTOFFC0JoHNIngL?=
 =?us-ascii?Q?9LRBt4fFPho=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?u8/ooHo50V3zIfJyKxVton5d0ZdFhVLThqgpYKATELEWYo3/24y9HIVaGw9c?=
 =?us-ascii?Q?SRokc4i5Lr2AVh87U8zN4V6AZGqekfYhsfx1L+Tj4a8NfCXxzk5vfBdSCzt2?=
 =?us-ascii?Q?481AkxqJlQh4MRiiIvsgH3VD7c/t7xb38R1FKSllTsuKZpuYF+jOc9D6eib4?=
 =?us-ascii?Q?n34DNcbPJjjm+wjAZAOKbGdJfonEOhzv3WEVpxuj2PDYrmqeHOxD81x0EVQM?=
 =?us-ascii?Q?C6yo9V+0yaxPeeuW3Yqw5262IyLlr1k9jlIFPpq5Z4FcKkN/3JF6Yu6cI5ZO?=
 =?us-ascii?Q?AZZGunE5qKDa4dmxNnRkSND6HqUQE9laX26OhrsHJ+neF/xXL32UPB6Rkdyj?=
 =?us-ascii?Q?sd3TUbUKlDIEdXVsJkDIij9GuIE5fBHhlZs0aYk/BDnttOaSi+fpYPSte8ov?=
 =?us-ascii?Q?TIz8UMBZiWa9bXhpLjzIfN6fRVJ/sgHqZYWtLdhqF2SQhY4K7lKpiWpjzbRD?=
 =?us-ascii?Q?3XhgL8XEYMdglW9rzWiFiN4FAcrOZxV/gecYGuguPMGzFPqtf+9JsCtpjhsK?=
 =?us-ascii?Q?8CYwcEMOIxhJ+Q2ALWvDTycENz99OplwreiZA1nRPlfeopDz7GxR5wrLoDua?=
 =?us-ascii?Q?H2JBCFi/IuYYyFCISmrZd+ppnGYt26Epxd1m0RbWC0NGlEnVjrGkEKzdK8yA?=
 =?us-ascii?Q?jwJ6j22TR92d4twPKAkuLwljtBGHVEZ0UjoA6aA4ITil377eKba8PeiKwhJi?=
 =?us-ascii?Q?abhNWc4meigTbnLSglSmGY9oG7S3oQWxOLrdxEUsdFaoRhybP2l2+FgBG206?=
 =?us-ascii?Q?zcXoQ44ePn8zfKIp+68t22dk/+ot/AzhaNe6Y4llSvhcWneop0WF1P97pRLH?=
 =?us-ascii?Q?BH2PjG27cD3oaPzY0tdeJPw1ByJactdstWOeVWIqz8wR58AjsZVyPWYFv3L7?=
 =?us-ascii?Q?/fEdRWB+5LpsJ3DK0ISxPr+IQ3Oa+H3661ayKHnzBAENg077UmZvRE4EC64m?=
 =?us-ascii?Q?D3LupbyDK90Hj4Yj/sZtUpXUg7oH0KYK3RfHAIvYoQeRV9ytlKwavg0FCg3U?=
 =?us-ascii?Q?5P/PJmUFKdDuLGSzxQ4QbPd8Oi1VDo5a4ROmEsBTKH045NELcDnSk+7nbkP2?=
 =?us-ascii?Q?1V24LVGpzEw624Z5VK9jXSLUXiQr0r/FCInF1y9QslrbQcx7q5f8momvZXUr?=
 =?us-ascii?Q?x+eXT2oAdnlUSV2qJnaKQCHwHBP2v1GkA1gqZPauYMVPhrtF6wX0W1G71hLC?=
 =?us-ascii?Q?tF0OJCl+il3qnTKgaPYVrpgTtPI4ybeiF9srJmsp7Qb1fqZhSH8Y/vjfGubV?=
 =?us-ascii?Q?FZmAHHeU+7fgDjuAuSh8xoiXiKgsxkROnfUmqhes7Sst/VH3w85oTLqpq5ZQ?=
 =?us-ascii?Q?rEwCy4iTAuZOAJxejV168VW06JlExb7LtHTmE5sj4NuU1DiAdMVKERF/fqmZ?=
 =?us-ascii?Q?77jEHzvcNQVvNZZlEDNQVdTjIEou2GmLEuEHExOMaQPqvZ0jSVJz7lXInZKC?=
 =?us-ascii?Q?qkS+wWqA+NEUZh3KIdQsuOG5gPLiSqEJTh3G7oaklx1+mEtoziwFGNL9VIG3?=
 =?us-ascii?Q?5Oh/P9ketEqmb+HHrxv9bJR4E1fZr/BmO+jINqhcFL99z01aA2Kz5XEEXIH9?=
 =?us-ascii?Q?aEHsTK0+gNXQv4xvQp89x5xhD4MtnK7Hkrz/3QDwoQgRp6RwzAXbbAsXfbrI?=
 =?us-ascii?Q?Ng=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	UhSoWtzdCVaQrcM49wigN0lnHiEBLOXY9+BeGwvNrh5VynFKnfQgu2rsWANqLZL3mghXMCLc+JT7MWHKsVM4+iMLNIA7ap+TOLSTXyTYe+sjjguLwFxurhfmE7XyIo2ZGV1fvvNy19U/vETXX6RYrVDxPt4kG6xobbFCmeeYoOIVjm55t/wCYVpSG+UEtvVJIquV9/qv6Btm+uYUBYmEpiuekgiIqHHsIkeoo0rr/xEXZxC1CGYqGlGF2a7J+MWHFAhd+5jex+gsBWQQe7Cpje2gvT1pvRBsonvMc4v+zdv8nwIbg2UlinPa7TxyAJL5popSw78ebmTffaSrkiYPdYWZfDhXoXF2LlxX/X3el4gjHJwzWXsTEL6vjvA9Hg6JFyu6EGLRY171lHHafqwi5BsS5TkKsjiwICuLFiUHi3/HtHerMtFDYDEesHXxqfHhO+mTWsdwPzFLHR6NeQvwh/0dQ9CT2ulxTCWeNtCK0QYUUhVwFa0b1i7Ku4luD83Dp91DEuj/NLCcicPPaaTu9gEYU8UuBFd21OoLA3GeFIHoFUIAb2zo9Ho6k8v5/1wH5X48RjxCRwwRoG/4dfSez+JKYxA+y0g/RnxwGdB1X7s=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec218813-1ec5-4acf-6d71-08dde63cfdea
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2025 14:12:58.9590
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SakifnTJ1ZiFEF6NCafu/Tg4g3nbinV1/ygobW4RB7wePRMFenYOoF7xMwF+VZ3zMN/G0eAGJWWo0HXfBlWBp+Eu+Pk7KUQHrinoy1xVbrU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB4933
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-28_04,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=977 suspectscore=0
 mlxscore=0 phishscore=0 bulkscore=0 malwarescore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2508280119
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAxMyBTYWx0ZWRfX6gCWr1BwrVuN
 tMiSez95+GCsWN2bXUFReodau+Rrgw0eGtNJWl7eC1sjpTy+ffa5Y4krhl1Z+oGjyQPCGRP2rHF
 NnPwl9BC6ls7qZLX7eLymfRU2uyRiITNrp6Yv/+m6bu9lk1bMl2O5Dri1kvhpSTF066lv13xwA2
 mFIQgrXBSNosctyZippYd8nkpxDJRllPED/tNSZgnkk9NFkj6knaGBLmTCqStZAwjLJYjoq1WGK
 IEEgMZkO29ISWIVgdPfcErutdRQGd4MhS2l5UbhLd0vb7CwgWGhVwyI0lRwJ+wHWE4lb5qKWV1W
 RvZckVJZ5O/QIMM6SsF3XiyQr4nT1PLDnRz7sotdsVJP4XNg6yf5WOLaOhIjlwW98yVbVHQVaYV
 ppjOiqdb
X-Proofpoint-ORIG-GUID: F-CIlqOJo7WSuF0c2l3D3jAAoWvF0WLn
X-Authority-Analysis: v=2.4 cv=RqfFLDmK c=1 sm=1 tr=0 ts=68b063f4 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8 a=oT2u5JrfrMdI38_HYMgA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: F-CIlqOJo7WSuF0c2l3D3jAAoWvF0WLn

On Thu, Aug 28, 2025 at 12:01:07AM +0200, David Hildenbrand wrote:
> Now handled by the core automatically once SPARSEMEM_VMEMMAP_ENABLE
> is selected.

Ah yes there are other cases :)

>
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Cc: Heiko Carstens <hca@linux.ibm.com>
> Cc: Vasily Gorbik <gor@linux.ibm.com>
> Cc: Alexander Gordeev <agordeev@linux.ibm.com>
> Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
> Cc: Sven Schnelle <svens@linux.ibm.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>

LGTM, so:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

> ---
>  arch/s390/Kconfig | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
> index bf680c26a33cf..145ca23c2fff6 100644
> --- a/arch/s390/Kconfig
> +++ b/arch/s390/Kconfig
> @@ -710,7 +710,6 @@ menu "Memory setup"
>  config ARCH_SPARSEMEM_ENABLE
>  	def_bool y
>  	select SPARSEMEM_VMEMMAP_ENABLE
> -	select SPARSEMEM_VMEMMAP
>
>  config ARCH_SPARSEMEM_DEFAULT
>  	def_bool y
> --
> 2.50.1
>

