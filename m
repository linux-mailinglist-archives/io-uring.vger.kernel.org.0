Return-Path: <io-uring+bounces-9434-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E655EB3AF1D
	for <lists+io-uring@lfdr.de>; Fri, 29 Aug 2025 02:26:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9C9D73BE85B
	for <lists+io-uring@lfdr.de>; Fri, 29 Aug 2025 00:26:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CB61225D6;
	Fri, 29 Aug 2025 00:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Ly9Hd7B/";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Lu1yLvL1"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FEB213D512;
	Fri, 29 Aug 2025 00:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756427210; cv=fail; b=RwyWcM+w7wYV0SK9fslQbjL4w7WfrODDgnXIxdDDfuHow7nQJBO0xkKRF7Bs+4gq1ecqkXd7BRq/l8t3I1uAPHrzr29HgwTWwHx1pECmkBYGpCRCJLDPil1uHH1XuwImZMqKjomuMWEQwgjWBocq7at6D+TUyyCysVCCT3rTgvY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756427210; c=relaxed/simple;
	bh=CHOSIlFDciBDfP9c6UbLZUSVugA1QMmUIMBaKawkbC0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=jb1vOPPDRUWGLDJWLD71A57qKuAdoMoP7DrSYTvqGvBWhVa91kZMQ1h7FXMKmvTM17bC97PqYHL4OKaYxVyFRnJw+wCFsaMRRVq/vcFSOkMmKdSzpIE7TgOZZy/e1SR5dyRz5/16Waj+o+pZAiqDumzZ+2Zs1xDgPbSMguijioM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Ly9Hd7B/; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Lu1yLvL1; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57SNjdFZ003921;
	Fri, 29 Aug 2025 00:26:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=7WzTD6ZWd9axqxJvOi
	/47IKvcT0TJ7Bxqohox481SGY=; b=Ly9Hd7B/cC7L0eo2KKcEzqi+43EA0vvJIK
	UV4k3q9hq6UUxGN1XsBXXJr7j+7YDBl5G3uZF3GQh/k2FKhDDZDsWFL3MNH7AW7K
	W8jCx1+eI7/IrxyqQ1CAfRKEspeQp6uHPfJdFjTXu/w0o0HAgPmxXYWzHGGdVpXV
	eenW/AJYShKkEtRe34jwg7jxbEyNzoVRIxSjReCX5qsXvGZFBNScbOoHaekhJ4U8
	dGxn9uzr9nQwAkVG/l/b2KJfk9VagOHCgD//4sKW/vRt0BRFeSem33CytRJtXphO
	8XpvvNlualyCsRgXLCHRTDSVX62sjtN3lrBcQaAUpfNPdCvDBzhw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48q4e29pvr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 29 Aug 2025 00:26:38 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57SMIcsa014593;
	Fri, 29 Aug 2025 00:26:38 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12on2082.outbound.protection.outlook.com [40.107.237.82])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48q43chyd3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 29 Aug 2025 00:26:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=t6dygJFWSxpawEWzxdVpehp46DlWBjl8+Imxp3jRT6zFcGxmUhcsR7hbxYjDWkN14IpzXwQrwmul9Gnl/L4jSD45NXZocU0GXaZz1qmP0ZOLJjBbQ0Bp7CTEFSggWVfz4XBAr4BUSO5au64P5it3y6elBm1taxwoTtBwwNAV5bcsxNcxKURPN2QZdrgSZeLJ2XocdO6o2nDvq+svteBuRHMoPrCkcvtZ/bN9dDYolDsl10GGUEBOLedLyqieBFtXTsjXE3MdzyWbWyjrE3+roejKOyiU8XzE0KhXsfT0sJZftqjid4PmdIjXYSZx5+h6mLPs9FJm/GlkbBWUHCX8hw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7WzTD6ZWd9axqxJvOi/47IKvcT0TJ7Bxqohox481SGY=;
 b=jpGSW8pTGvjdHOnteT5WUr7Kd8HfwGjqSba55Lu5A1SqNEIus2StTp/sPMXfMIopwdjKXq7+4ml27FIbCPqdDlpWJWneVsDUuR0XRrCjzMEGXqHs7ykiPXkLLfuu8AnbIkfJNfnegrFGKA94ngNkR3pf9aThZjc2fF8dQ3mh3Tw3GBiKaDGdkTlzDc//kHmeraAtHqqjq2xWElBGP2aqsYPdOVpwTGD3q98kdjLWmLkLyAb550gPRherTGiuXcWqOglT7QbUdLM+QfZ2ZaTFzF3MWCFZs0ncMXGILq3G2YpczUBWVbopcqTg0LWSPcG8LYA7lsqYQ8kQjP53odB0dA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7WzTD6ZWd9axqxJvOi/47IKvcT0TJ7Bxqohox481SGY=;
 b=Lu1yLvL1AKxMApxlBycS7TN+0rUz8aWS4Fr8TyWiMjssa9h2MnJnBaEazoj0Pr8DXRH41ZPHNOEPFdbVvr2+dz92w3TY658HTMC6TGoOJrLjmswN1m7ZIoEPjD05gQ6tpCRXxb3gGBYObW9e9hw+T4DSbCVJ4AqWP9EBkodkTn8=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by PH7PR10MB6481.namprd10.prod.outlook.com (2603:10b6:510:1ec::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.17; Fri, 29 Aug
 2025 00:26:30 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%5]) with mapi id 15.20.9052.019; Fri, 29 Aug 2025
 00:26:30 +0000
Date: Thu, 28 Aug 2025 20:26:22 -0400
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, Zi Yan <ziy@nvidia.com>,
        "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
        SeongJae Park <sj@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        WANG Xuerui <kernel@xen0n.name>,
        Madhavan Srinivasan <maddy@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin <npiggin@gmail.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
        Alexandre Ghiti <alex@ghiti.fr>,
        "David S. Miller" <davem@davemloft.net>,
        Andreas Larsson <andreas@gaisler.com>,
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
        Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
        netdev@vger.kernel.org, Oscar Salvador <osalvador@suse.de>,
        Peter Xu <peterx@redhat.com>, Robin Murphy <robin.murphy@arm.com>,
        Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
        virtualization@lists.linux.dev, Vlastimil Babka <vbabka@suse.cz>,
        wireguard@lists.zx2c4.com, x86@kernel.org
Subject: Re: [PATCH v1 01/36] mm: stop making SPARSEMEM_VMEMMAP
 user-selectable
Message-ID: <imcmdidialtrylnkj4sjqmciwwgbpzsplavazyxkdlebrc7mey@jnm7wh6bjk3p>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org, Zi Yan <ziy@nvidia.com>, 
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>, SeongJae Park <sj@kernel.org>, 
	Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>, 
	Madhavan Srinivasan <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, 
	Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <christophe.leroy@csgroup.eu>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, 
	"David S. Miller" <davem@davemloft.net>, Andreas Larsson <andreas@gaisler.com>, 
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
	Marek Szyprowski <m.szyprowski@samsung.com>, Michal Hocko <mhocko@suse.com>, 
	Muchun Song <muchun.song@linux.dev>, netdev@vger.kernel.org, Oscar Salvador <osalvador@suse.de>, 
	Peter Xu <peterx@redhat.com>, Robin Murphy <robin.murphy@arm.com>, 
	Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>, virtualization@lists.linux.dev, 
	Vlastimil Babka <vbabka@suse.cz>, wireguard@lists.zx2c4.com, x86@kernel.org
References: <20250827220141.262669-1-david@redhat.com>
 <20250827220141.262669-2-david@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250827220141.262669-2-david@redhat.com>
User-Agent: NeoMutt/20250510
X-ClientProxiedBy: YQXP288CA0015.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:c00:41::31) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|PH7PR10MB6481:EE_
X-MS-Office365-Filtering-Correlation-Id: 337fe588-fdfe-40b1-d678-08dde692b357
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?7PdM898Jd3u4PTlJM5FPal/V/unlSYcLlusdxt7aCDBJPRsyiVRNISQHmLdU?=
 =?us-ascii?Q?Rh/W7WSB6rVSFmfY3ziwBzbUISlsk/BPIiZod1dan3xQWQ0jTlaPFORTIA7V?=
 =?us-ascii?Q?4RiEdp/0z9EbErlyebNyabzv8un6VpMaICQmdGmxwr2OTt/hBzZfrPjSKJTw?=
 =?us-ascii?Q?N6i9fnGU5y8wTLN5Dp5RQuMsB0FKwvOwIUpFv5XeueG5lCeIYBurDlUlI3pn?=
 =?us-ascii?Q?7SDtOXJdLL8VW9XYYGH0DDAG6i5ZgyLMze4UoeHtsf+Rt0/SFZlOSo8zmKQR?=
 =?us-ascii?Q?34Lll/hvHlLsOEYDxFrcWT/JRpFi6zYvQAzqKUPMWF9cz5nIF8Trg+VU6vOC?=
 =?us-ascii?Q?E3e1VjhP4BSeiOdaoC9+eS9RIgP8sCsRXdsug8hQJDD2dsjAmLxi2q7kr5Ug?=
 =?us-ascii?Q?jY3MwG67DIMCkicNjrLYJ9kNyQWL5NdcFOGrTZYoTKk/xwMGLgtFNF0XIU0x?=
 =?us-ascii?Q?RzVfMcOzmIdc5r9L9FrDv9YPmahjukcppXW29Uo3FA1uPjgYvHyZ624+YCY7?=
 =?us-ascii?Q?8Z436fMAdH/+tCL8Z3al1y7GcPxe/pzm9j+np4i8fix3q21wQS9lyMyUbfBt?=
 =?us-ascii?Q?rrqYENzTmk818O9mvdRVxntQTUSfLZUTwXxcCRIFYGsZSAUWZudyeY/uI0OZ?=
 =?us-ascii?Q?n52b+YnIlyaX/A7/yoM0clchknJ+s+4Q71AZPvUeGPGOQBFWBr8tUBMxC0rl?=
 =?us-ascii?Q?CkW67+7qmEORHr9wDRDwgc0B2bjxVKr11Tj94Sq1H/go2IWE53MItTjFTIlR?=
 =?us-ascii?Q?8FUP5LAOP43HBNFog6a/rDfc+Wed9KG2GdpsI/jN70NHXuVtt2KRJpNaBPkG?=
 =?us-ascii?Q?LFz/QCzkjr8R1Tm15H3tl3LEOklLVwlkKZX8A5IFelVrt/QXcvjk/dNzg706?=
 =?us-ascii?Q?XC3+Is+uvqkYrm6DS88d0k4h560xTxb7AKMXZxjkk5wsuux1uzT3SadsIbym?=
 =?us-ascii?Q?9NOtuTgF1U3eDr4xBo+AIpazV2CoyHoblN0O7OaaXka1b6ZetcIWMae3rHD7?=
 =?us-ascii?Q?aQoICvXb3F1zQw3VIoCH8vqpACT+cPaLK1YpKHrxjoo9y68bQw8dV6AfznX5?=
 =?us-ascii?Q?Hv+fjdInIFSW/wafJVh6KTj0i+HZKHPXIIgKH+/qoEaXLdYcHWUErjl5QlCS?=
 =?us-ascii?Q?ft3OXaDfM8vQdavYrzk+p1TFgxjz1gYqMhjzlCp3/hWC5NUF4vCRCeJbnRka?=
 =?us-ascii?Q?OXDkBARXSfqD04pyn7OX1r6TFkReFvskOJyh1MswJnIyXsMOEpzrZafuyrze?=
 =?us-ascii?Q?kwlME9gYSYdjSj/ChuUGnhNSGiPsWWyhdnCxxyam1I0C1NH/Ry8gwx89vJcY?=
 =?us-ascii?Q?X4uUlEwprDdmqA5/K00waNgdXlck2tvsPiydgLU1TYu160x4ukqh6XyN3Y3f?=
 =?us-ascii?Q?0FfqOC6ZtYZyHMa4ZGNRLhYlLl8hxMaUEDWLlaAxGx/0REFwLYDF019bdni6?=
 =?us-ascii?Q?kmr+6Y1kbE0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?b3FDyHmZEm4Oowh3gHKp/axtPWPkN5DAogkN06CYLJu8pT1Zfg+5DMGddkU7?=
 =?us-ascii?Q?9GrCLP7fhFWEZv/ZUEEy3FE5UuND1IQeOcUqX3YFsW7fr23drBvdQXigUB60?=
 =?us-ascii?Q?FuNgpRYsNK1b6OCbdGP+gVlV2q3mQY6SI42fJaqLnqH55hjfku9ZAhbzVgYB?=
 =?us-ascii?Q?O3VdKQsDNdPnoPpdoNfpVLbSOgjsZI9A3aD69m+U12jX3ThsyomUVejte3Uz?=
 =?us-ascii?Q?hKZeZN/sw/HNJdLXuJHtJOEpx70N1A7ffVG7dsdNr/6I4Fci5DqtD2Nu54U+?=
 =?us-ascii?Q?noQNkmL9lfcldQc/ABjIOq0WCKahAOUK0Y99eWua9rlgTMmBvcbB2wveDCes?=
 =?us-ascii?Q?/TNwWGa3P6zxtk/BfFgBt06CRK5e+8wiOgrJStm46TCeZ1Jf7vQOCAcaSJmG?=
 =?us-ascii?Q?s1rd6N597AqjqjXn8UqtpilyxQz9jNwGd5ON2yajHhNElXXjuwH4vONmeK/T?=
 =?us-ascii?Q?SzFgUM84MX5R0zR+qYD7u24XOGj0VD+OXaqiUKVNGEp2LYXfk+mIbEnzd/fi?=
 =?us-ascii?Q?tdMXukb4VMBC3VQVECSitME7bVspUHx0NLsaeeQ30Gk8qquhMuIp5shXZyY8?=
 =?us-ascii?Q?YmkQXmPhaSZiDN4UbwfhVou41OTQQH3ZtTZu3En4PPp3X6d4OCJPuZzt0Ytk?=
 =?us-ascii?Q?j/os6kBk+rsYuifuqe+5+QeCcsNa1KQGyZvtuoUViWe4z9Fs89Hnb0CiBftM?=
 =?us-ascii?Q?9RVOMUlfubLv8a0s7/xmya/50ZnjhW3KHuVqUCVc3dpMVstLssTMgyz4npel?=
 =?us-ascii?Q?XtLhg9/HS32Ax3zkGRLeXGZ9XlizulJEwn8Sg+eIhi0HhKDU0B64jUXJMGzD?=
 =?us-ascii?Q?uGKXGcJ6PlzSmKv78cXB6oHILMhpX/5rW3vAOZUkGCq2Ls8ZHL3QPqkF0d2Q?=
 =?us-ascii?Q?MMb+xk2cSBzjGmw5JkBZZTeR6qh7IIGZRjeo3FDa8I3YYGCjLIXmOWDPE+Rf?=
 =?us-ascii?Q?1LIye5REsZcWw/rOHgsUdvnNN2/uAwtXpkeejdnay+YM40cs6fupCamy8ALy?=
 =?us-ascii?Q?cqOt0xL2NUQsGD1h7yEIzgpaM+qetm/25YhiHFvF2Vt0rxa+V9IaVYLAZz51?=
 =?us-ascii?Q?Yg+IHtSmgJmn729aF14rrwWGHNongo4Jgi2++XR47ChJqege8WxQPHdK4gs8?=
 =?us-ascii?Q?cfuaGD26CHKWPkBUepv05hIC19v290jBMcEj3W+hKo2RBp2FodiQbSICA5v0?=
 =?us-ascii?Q?8n3Dm2dAZbJRrJxYAsv7+f84YuzkqfXkFa8odSD8hFMCxyJ35IeNiI04aoIa?=
 =?us-ascii?Q?MzPJPBMOUvPg7fHgfpucD8MDREnJOrEXLWfeRzgQayj8HJC8uvyrUJXWbZa6?=
 =?us-ascii?Q?k4KdbNxHXSnvyxf3NZSzQ6jU3LfN0eWqEtfdM8oVRyDnhD03K/NDfD/HaFUB?=
 =?us-ascii?Q?rvTYSLQK8IqLXRhwjHX1Q23vjK87v45P2e5sb74+UQIiDulCY1cDqlqJbIjX?=
 =?us-ascii?Q?VgOc3ltx9t8SYH5m9AgIE1iYR73FtiZQTPu6PiSmiVUUE4DXuManaq/BAxIo?=
 =?us-ascii?Q?gdCBI6LlozWvtKJ+duVc+L6tOoqxNyf1tzWQ1cOANWpBGcsymkhRK/4hcyq9?=
 =?us-ascii?Q?VN6lkZKV1kb71iHK4BTzUPxpQEPRbPlpohSrKsbdh3Q597kOOg0OwAKXStVA?=
 =?us-ascii?Q?qw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	EEVfXIvSvw+jnauws45hnF2tbxeNJ6cnRmv81PWW2uanoc9QiaWFD1UZR6Sjz79OhEKTjo23XYPwdIogExkQwKpaSdvYcI7X9P2yKbN59lozxTHeKZNhhariGbiFYmm8BDPmwLncHsPi9Scy84DcOhVe+qPsaffjjL51msTXCDtMg7X64myiAd2U6n1MuIpc6LZSEOJgqzPSEVUb8ZrrY+XhbamO0YhQAOMURtAaRWkn8c/UxfLGiTJLRa3PXhkORGddCzCqaTbf28YBjVqxpUTFgDWiCVcKWPGkOwTYjyo7+lWs1R7nt573t9KSOg1FuC+8HVv2QSvnKgO8b7pDTvQF4PTsRSd//v2q6OQhM6LdYuT47epXonFOh4GG12oREJ+c76PdMwcUuJxXzcT3vhCcDpG5SCxQuieAYgwlR3YSu0/D2who1S/i/RFDPrTjDOCBYBBRJVJps6+ZD7tURisC3+dSG6hVQKuEc0CzrxCEGYlH7So3f6L2GqWZ3KeNaPwdHCZS6+TsoDkBOIXzocUdGr7KUoBiod3cRPmmihRwP8QX7Rko3gZicnYkz2Dt8ulczZjrCzL2djS/F7Cl3xe5H5PrfVl15tgRgoOP+oI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 337fe588-fdfe-40b1-d678-08dde692b357
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2025 00:26:30.6784
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VwdVTNhN/b8RTlQvwoAkc0KBGjsllb8bvRp29OAstWP/++DcLmavzIsQSo+sEVLzDiYkmozIAnBndBVb56UNrg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6481
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-28_04,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 mlxscore=0 bulkscore=0 phishscore=0 adultscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2508290001
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAxNyBTYWx0ZWRfX1q+9rx6daZBS
 9MK6RwSiD8cEeHW9uXO38R7KlyLMl6w/U1eKEaAsft5jmlvdWqYFPy4tGibMwlS61JujvhVeK9z
 wPeVID7GjeEXFaTS/khcfQAo7RrlQ08Rb9s4WaFYqHH9HIJcrk7R9nU8Qr2d4HFdWXMgtNsul5P
 Bo1aFj47M2l2D9m82zL4X+c13Dnn99A9nXxqrm/RfsGSjGUYYWnjSxLKh4N4kwJyDaP9vgkQi6g
 izJ/zbtYfLxglHZU5i4a1Z+WCyrU/0dilQRgkNLLVgILR6ojuBZGX2QzvLXyt1N6I+Mk1cvLked
 qcJ+ADnCKgWUSu2bnv+pKT73+ecnG9QqTg0PEWQ3YY5ZpuuipUmUiuyQ2pznR7r3Sfh2S4q92Eu
 4PPfDY+fg6nWmVsBcB5GueDjbndWXA==
X-Proofpoint-ORIG-GUID: YmSXYDPT2BQdSgTUrARPJhK_0XYf_Mrq
X-Proofpoint-GUID: YmSXYDPT2BQdSgTUrARPJhK_0XYf_Mrq
X-Authority-Analysis: v=2.4 cv=IauHWXqa c=1 sm=1 tr=0 ts=68b0f3be b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=20KFwNOVAAAA:8 a=Ikd4Dj_1AAAA:8
 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8 a=pGLkceISAAAA:8 a=1UX6Do5GAAAA:8
 a=pFyQfRViAAAA:8 a=_O3DOGVWAAAA:8 a=J1Y8HTJGAAAA:8 a=ebG-ZW-8AAAA:8
 a=yPCof4ZbAAAA:8 a=3kAz48_qQRIM5rfxVM0A:9 a=CjuIK1q_8ugA:10
 a=Et2XPkok5AAZYJIKzHr1:22 a=oJz5jJLG1JtSoe7EL652:22 a=2TKV-7w1aU1AVAwN0oqT:22
 a=y1Q9-5lHfBjTkpIzbSAN:22 a=Bj2TwAA_C77lQ_X2_dkp:22 cc=ntf awl=host:13602

* David Hildenbrand <david@redhat.com> [250827 18:03]:
> In an ideal world, we wouldn't have to deal with SPARSEMEM without
> SPARSEMEM_VMEMMAP, but in particular for 32bit SPARSEMEM_VMEMMAP is
> considered too costly and consequently not supported.
> 
> However, if an architecture does support SPARSEMEM with
> SPARSEMEM_VMEMMAP, let's forbid the user to disable VMEMMAP: just
> like we already do for arm64, s390 and x86.
> 
> So if SPARSEMEM_VMEMMAP is supported, don't allow to use SPARSEMEM without
> SPARSEMEM_VMEMMAP.
> 
> This implies that the option to not use SPARSEMEM_VMEMMAP will now be
> gone for loongarch, powerpc, riscv and sparc. All architectures only
> enable SPARSEMEM_VMEMMAP with 64bit support, so there should not really
> be a big downside to using the VMEMMAP (quite the contrary).
> 
> This is a preparation for not supporting
> 
> (1) folio sizes that exceed a single memory section
> (2) CMA allocations of non-contiguous page ranges
> 
> in SPARSEMEM without SPARSEMEM_VMEMMAP configs, whereby we
> want to limit possible impact as much as possible (e.g., gigantic hugetlb
> page allocations suddenly fails).
> 
> Acked-by: Zi Yan <ziy@nvidia.com>
> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Acked-by: SeongJae Park <sj@kernel.org>
> Cc: Huacai Chen <chenhuacai@kernel.org>
> Cc: WANG Xuerui <kernel@xen0n.name>
> Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Cc: Nicholas Piggin <npiggin@gmail.com>
> Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
> Cc: Paul Walmsley <paul.walmsley@sifive.com>
> Cc: Palmer Dabbelt <palmer@dabbelt.com>
> Cc: Albert Ou <aou@eecs.berkeley.edu>
> Cc: Alexandre Ghiti <alex@ghiti.fr>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Andreas Larsson <andreas@gaisler.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>

Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>


> ---
>  mm/Kconfig | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/mm/Kconfig b/mm/Kconfig
> index 4108bcd967848..330d0e698ef96 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -439,9 +439,8 @@ config SPARSEMEM_VMEMMAP_ENABLE
>  	bool
>  
>  config SPARSEMEM_VMEMMAP
> -	bool "Sparse Memory virtual memmap"
> +	def_bool y
>  	depends on SPARSEMEM && SPARSEMEM_VMEMMAP_ENABLE
> -	default y
>  	help
>  	  SPARSEMEM_VMEMMAP uses a virtually mapped memmap to optimise
>  	  pfn_to_page and page_to_pfn operations.  This is the most
> -- 
> 2.50.1
> 
> 

