Return-Path: <io-uring+bounces-9435-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7ECA4B3AF37
	for <lists+io-uring@lfdr.de>; Fri, 29 Aug 2025 02:28:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A52611C282EB
	for <lists+io-uring@lfdr.de>; Fri, 29 Aug 2025 00:28:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65AE21534EC;
	Fri, 29 Aug 2025 00:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NdN6+9Ko";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="wC9djTqP"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEEF93D6F;
	Fri, 29 Aug 2025 00:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756427308; cv=fail; b=ovu97G3NPHQiVMX3voN5Dxgj3nFfvAfneuAC7mjaMWvl4O3I+OJPVn6Ouro7kztRKT08c2qmUitCMWyL/dlqr2BGxVxJ0rS16K8/ASUw0dztp92UpEmOViuSf7xlujzogr5BMV4tOlh+bC9L//wcF7K7haarcNED9pYhd5zkoyI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756427308; c=relaxed/simple;
	bh=2aagfA5HbtVsNYeSzQTRdR0bA9NlDk5c3KoZ9DwCVX8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=MXgn9pMKrUMD0sJtUg6gobKxDhxCzt/fPQEM2fHmfRdRA+iyQ0hBr9D7difxNDI/UARiFnAS2v7uBpaFPE6fL3/EZKOBhNHJD+BU3NP824PZMRcWvlUhhJY+zWLVFMprIv1A2ZxegBESlkGLjvaoP8szCB3MoQ4nNnhhZBUKTWk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=NdN6+9Ko; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=wC9djTqP; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57SLUx3R023944;
	Fri, 29 Aug 2025 00:27:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=rh3cbw0IP2MeFqbBzS
	dcqwD+iITv8+gpMYKAk3IYmFk=; b=NdN6+9KoYImLdK+bSMYr/qOM6ywFs/UV5F
	fhGh+xuD4PcoZm8mq9UKehdZWCpa1vXrDc15cAVI7gZWcJe8Wd+PqdNDduWhUZZf
	l7hQWzjfP5WO8xIVlfFwnOhLSYeHyF4pRNFw7Ssh0z2piShqL2i6gjm21VPPGsEi
	2SWMFscQ4myifIa4WTnTdT1XKIh1zt/Q2VtV//e7IJyk+iiLAnguVkOU9hwRpdA7
	vbZMufizRbQWPJZqKpbMg/aanmcHt2XiEG+6lCrnoeyRVL721fAd3wQNGb3oG4ai
	aruZtasf0dMoPuhAbPryD02mOhPtRuuliNX4kPdsgDCbiV7NyBjw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48q42t9ekd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 29 Aug 2025 00:27:27 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57SM8JtQ026739;
	Fri, 29 Aug 2025 00:27:25 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10on2070.outbound.protection.outlook.com [40.107.92.70])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48q43cdph7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 29 Aug 2025 00:27:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TLmRlhYrxURzbw2L8iosbDU9ctcl7+W4TexopuuLF1iJ9Lo0SDg8EtDg7SfAOWmYBnHYngf6LoWlkQtCWT08etS6i3ZPoE3jvjpbB3p8QjjpcTacXhPzDjDjSCz+bxoiHrkhMANhQrfjg6rw/zn3c/NQ1dxhKPxFxhvUh4Qa3KCIFxkssKSEVUT/ki/m9WdJN0IoKzqaQcXT3hFZP0aKzvtBnuVyVKgZsyCE8hRR1lgpjwJIgjYSG+J5qS8Xu08Qwy8XdUYEGHWKNtxbIHQU29PdBild5QQQv/5WixTmJXFHrtMKTvearRFA9Ukiqse/6y8/E+ROEAh06a9yXaJO4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rh3cbw0IP2MeFqbBzSdcqwD+iITv8+gpMYKAk3IYmFk=;
 b=C7/BphbnuTQaHQN0UVRTkvaBdeZQc4x1VJMbgdeLTf0mPzVEA5b4n8m0p8iaamYnD9gR/COYqbZlVRRCic2Mp8jhOnJ7X5toCSPLMDo6aEVxrAD7Z6Hso90MOFkNedRMrXhACwK7K2wrcdHdeM1nVGb6ErLd94Qm47PSijyy3VrJbk92twLserBYrsrbvuF4wqILyNKNRYjAuFxapiLmd5OLq+U+c7WhtDA5Hiwprb/yUEvxR7lgshJgE599AYrNmOUrhtNEWq5/FW+/b7dWpX29wqIJGOZMxEf33PBqMOzGQz0i/J1UuJDfxsoN9s++QL0UXTGxxo+40pOrUkamBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rh3cbw0IP2MeFqbBzSdcqwD+iITv8+gpMYKAk3IYmFk=;
 b=wC9djTqP4mdVNU7NMopYCAd65vg5ppmQdC+W7/3wjL8zp7+vizgUd5J1Al1TNK4H8DLflLpy82/yZK8QXtFILnsHl/KzJVb3a7CsqwQ2+sHElAQmcayqn4a6Ui8sAIwzZRKpIeepjw0bN0X1Lh86Laz+lA1Dlzosx7AedWTb9Og=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by PH7PR10MB6481.namprd10.prod.outlook.com (2603:10b6:510:1ec::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.17; Fri, 29 Aug
 2025 00:27:18 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%5]) with mapi id 15.20.9052.019; Fri, 29 Aug 2025
 00:27:18 +0000
Date: Thu, 28 Aug 2025 20:27:09 -0400
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
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
        wireguard@lists.zx2c4.com, x86@kernel.org, Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH v1 02/36] arm64: Kconfig: drop superfluous "select
 SPARSEMEM_VMEMMAP"
Message-ID: <ys73n4wetrgldfv6nwv4tr6tg2bmxcvujsxlzg5rl2727q32ht@htdtigepn62z>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org, 
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Alexander Potapenko <glider@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Brendan Jackman <jackmanb@google.com>, 
	Christoph Lameter <cl@gentwo.org>, Dennis Zhou <dennis@kernel.org>, 
	Dmitry Vyukov <dvyukov@google.com>, dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org, 
	iommu@lists.linux.dev, io-uring@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>, 
	Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>, 
	John Hubbard <jhubbard@nvidia.com>, kasan-dev@googlegroups.com, kvm@vger.kernel.org, 
	Linus Torvalds <torvalds@linux-foundation.org>, linux-arm-kernel@axis.com, linux-arm-kernel@lists.infradead.org, 
	linux-crypto@vger.kernel.org, linux-ide@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mips@vger.kernel.org, linux-mmc@vger.kernel.org, linux-mm@kvack.org, 
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Marco Elver <elver@google.com>, 
	Marek Szyprowski <m.szyprowski@samsung.com>, Michal Hocko <mhocko@suse.com>, 
	Muchun Song <muchun.song@linux.dev>, netdev@vger.kernel.org, Oscar Salvador <osalvador@suse.de>, 
	Peter Xu <peterx@redhat.com>, Robin Murphy <robin.murphy@arm.com>, 
	Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>, virtualization@lists.linux.dev, 
	Vlastimil Babka <vbabka@suse.cz>, wireguard@lists.zx2c4.com, x86@kernel.org, 
	Zi Yan <ziy@nvidia.com>
References: <20250827220141.262669-1-david@redhat.com>
 <20250827220141.262669-3-david@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250827220141.262669-3-david@redhat.com>
User-Agent: NeoMutt/20250510
X-ClientProxiedBy: MW2PR2101CA0030.namprd21.prod.outlook.com
 (2603:10b6:302:1::43) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|PH7PR10MB6481:EE_
X-MS-Office365-Filtering-Correlation-Id: fa4d33f7-1b4f-4d84-7dba-08dde692cf90
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?2WmVn4VJEZ6ZtkisZprSXYEaSVW96Ensl35QyDyX9OSW8eVnLjwi+1JA0sta?=
 =?us-ascii?Q?S42EMo1lMEyOUb2xmf+olf1UnBhWNm7CF9H3kw851PuriSB2vGtQpO77j95d?=
 =?us-ascii?Q?JYzka8cOlGcZtSVwEXYzHvHl95Bwohi+Vv8293n3Yw+xINkSUj8IhIKpgd+7?=
 =?us-ascii?Q?JHgaIRZtSpyOCbIWjMzo1oMP2tcx79Zv3RbnnLN5xAK9VawTH8L0G0s9CN5+?=
 =?us-ascii?Q?2U0m40dPLUg5+lr1tz1XRDxpQghxVBDwBCZi68+Plkb7fcwqk8V98LAwdsZa?=
 =?us-ascii?Q?jT0gm6jYPn8uZ08KAQ0WoYtaSnVTam4fq+scYIU3mebWup7ACVfDe5XKWPdr?=
 =?us-ascii?Q?wathL1yXdJjbe94frjkH/oOSR9G+hqV1nOOJ5ZCszVcbA5cTLadUgHKDAtYq?=
 =?us-ascii?Q?73ujrjK2E8KDwVeu4e2ET5m+8K49XhNSaruOx6Z1NSLJEujkTu5MfORZXsFb?=
 =?us-ascii?Q?oGeBbDnO2GJtuQep55S38sphgNbTZmkJkH9Ctxtvx9JVyzPUaLWmEkDZSXkD?=
 =?us-ascii?Q?QG70IBY4lLozhk8hIEtZt9smFZBxOzPM5dpf5u7LNmhshuhk0U1yPsa2R0vr?=
 =?us-ascii?Q?5gaNCiMNvWvvZV+SgLOG8g9BzH0roeLwIjbq2fgby2DGTNTkxUzDx6D5Fb9Y?=
 =?us-ascii?Q?JxDQhLnkGjmdSNnAy5YdxT4dUwm79pyPdEDsXoQ3z7ILAlHcOahyu2ssaRQa?=
 =?us-ascii?Q?MPWJ9zMQrV3ziuC8iBqL2ff8wNuBmXsDeJlOlRNUd2ZlCpxbm5h5Fm/ZKp37?=
 =?us-ascii?Q?RSxePcot3aNUZgWS6x36mqh6957KhNqDbJZKItiRnn4hhO0WvtqBzxGhnPn1?=
 =?us-ascii?Q?AeP5aSWdk6w+xU0ZmIeDVs2Uewikk7vXVflfIps7MHmx8ZdFtPVsHXbLhprl?=
 =?us-ascii?Q?g5UQvrevQ8UO75BsBaCfo/T5cTtSSWE9PAKU3HxLa8YlU4QZk9zFOBDMxVrS?=
 =?us-ascii?Q?evgfs4X6Rx62RRFa6bgJD7I3+caVRzTGUK6QESmDrJa91RSnc2kK2Fr4+AXr?=
 =?us-ascii?Q?j0mxdHfzismbpOJQymbscI1hOIvYVmyEmquY9VV5s9cqOGVg9a9oB/o/fqj3?=
 =?us-ascii?Q?PIfXim/rg2H/Yg13BftsX+cyby4RQPuqoupU2XaxO7hVfgkXjji0q/8nlvKL?=
 =?us-ascii?Q?uCStmzwGI0XETU2X4R62gsCgdzX59JlHAPwaWi1UDLLNB9ybiz/Ioep9+/Ne?=
 =?us-ascii?Q?EZwHeaDCtzdNDOk2vo126DpaF8Rzl6mdP7KocFy2PeBlKsZaYrdrAbUPb+fK?=
 =?us-ascii?Q?T97LEe6GBpf8cwhJM47tdld3Tv/pWKgY9IPVu8WrvUmmpopfRrQru1BoTprb?=
 =?us-ascii?Q?mg5A/f43Wco+WTCBaJgPdhEj1O/UXWATVIa4bH3J0qh98jBUJCtSO2hJNLXl?=
 =?us-ascii?Q?jUMf2gbTMIaQP/K3UsYApNiBkivz4rDelxrinqKHIbyfy2Yb9WBpmufZKELU?=
 =?us-ascii?Q?blb4jdGFXxw=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ZunHePzqvpViwt2Ei8BMLsk97E7TmMqc1VazMVksZzZBV9QAXOLvx8gmbcxZ?=
 =?us-ascii?Q?FZWcIP8I8AZ9Jxnm/zJw6Pgu3EOdgAqzp4aTlAneHG8FO0yN/ANjtOq8a3RR?=
 =?us-ascii?Q?eA8alq48NLR8F/DKE7ZOoU8P/ShaCegI1PSUEjse7W54FR89+3Y71lcn2l8U?=
 =?us-ascii?Q?lKtzewW/fgctM4+aEIZkhStSkFxylPSp1bzWnHW4+FfKHf/5CV/78nnmh6FY?=
 =?us-ascii?Q?utDqgQoojqPKmMVeElkgRdKfMtC94OKgDek5OVrfJQrG3Aq7sn5/y3bdWWzq?=
 =?us-ascii?Q?0fYYcdSUPe4eTtF7+Q0ACJE9I33HuutXKs4E9iJqq3BEgmckNRcYCXCuA1as?=
 =?us-ascii?Q?FxnSiDCVSZKBVcBW0gg7Yh+VimSSI/zc3Gua0WzTGCkXCN3EVDOVboszFkum?=
 =?us-ascii?Q?D9DO74HbjlA7IVnTZ7qAmdDG6pNONe3xtXKKUev6wGY8jVdAplTisNANoG0j?=
 =?us-ascii?Q?O7XB8/mlvM+UN8wWe9+7b/+FMADymBflipAZRLYcRmlJm0E5v+97FtB6BC+h?=
 =?us-ascii?Q?R7+RuRNv1Gqs2QYvSkxyRxZDDtdalYMpimWzy+Fr161aWbbh9cJPonYQ2Oef?=
 =?us-ascii?Q?NkvmPZzHyUQAhbKCM3DTNjarawwfIUPwh5DhLN/Yt0uhqHoU//81LiWHoP32?=
 =?us-ascii?Q?U5Iu0RI6MUsKt5SVOLYPpvBJ9CbdBa1I3ZIqfl6pzNcVorz5fjLrW48LfsrN?=
 =?us-ascii?Q?lvXqUhwit1yIYBe1JNGkIv+HXpmM5BJQFOeahzqkFJNWRd1l/T0U8i1WRKhk?=
 =?us-ascii?Q?1gHhHY9O50KLuVodMC5cVyuybdYVTmUzXGxPAX+tgGj2khwULKrjA19JccT6?=
 =?us-ascii?Q?WPJp3rjHSfSNGfY+jUyZZjrAtd468eCDXHEmZh20x66zKZSTV0ddDeYavJxK?=
 =?us-ascii?Q?rluUwNqajMA6aNHeBWHPXV32t5YFF61Q+QWwZ8k1PM+2b3YqsUflKiDmkdQF?=
 =?us-ascii?Q?kkv6upUK9LrkwEPDoc4HjPv8/bnSIERxL41hu77qeuJQ8U0E2Cru9DgLXrzk?=
 =?us-ascii?Q?9wuhbaI094ebXmy13dm/KoaeTj0r0kvnmv6QXPtZbYqQFwFrgHJKh6cALBXy?=
 =?us-ascii?Q?rd7sxeBYN3OgExxDsD6LqR0Uz+M0Bb3vvSDqhU2TAiNrWS55PUz0SFQ6EG5A?=
 =?us-ascii?Q?M56AaMprv76Pi8EuvMnk6oSbU0aTFOGWqZjyN9Ep4RiIVjLw++2ujPnHccr+?=
 =?us-ascii?Q?epp7SZk3K6rqWji3K/4qvsSVwSp7Da/PhfHF1KiMenhAOE8vk/ajEwm+FGfH?=
 =?us-ascii?Q?QlJS/QJdBNy5CjwpUtplSaFIUUPfM1RIRpamT2EXLKBcqhaf32WGJVx/2JJ2?=
 =?us-ascii?Q?kph8uIPiRGQ2jyPkmPe9UEaKx6em4iNObUolxTQVbKjYYTIH86zIMEPTDd3T?=
 =?us-ascii?Q?UiauvYeGwsWJrqY6egQe14qJqs6u++DCg8h7aJrBn4HzMQB2dH4/uq9LuGCS?=
 =?us-ascii?Q?zBRoL9KEYsVuEAALxt8F2msd8j7h0EkmmbEJgUshx65lRyGDNZQJx4OOf4zI?=
 =?us-ascii?Q?S4nvNvWRIKTYQfvE6jhPAYYLv8kKFWfQpscBrBHJx+WHIAP/+5ky0hNxze/V?=
 =?us-ascii?Q?zaZ7XUeaKfF4Kx13ujPi6X6S5EuQqBUWBS3cL0buofJPA1muv1ysRfuKxNYU?=
 =?us-ascii?Q?cw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	tS3yEh2lFOLvze3e3MZTSR3CDU982zTimYfluYMZ/tjJpcHEh3vyi6K2syuyPt/0kyQloDXwuyFFJVy/vqLVKR8+CNrLh387mia72fz7rWlGOn+7ux8P4jHvKo8X1E7ijN7nzgKcqwMo+j8sKwgGyV2N56Ujr+bqaECgPffLPE4kS0xGh9YM2ZB4mSYoV6PIwBsN/+GZMx85J6yML97v4FRYG24ee9XVksCF2EIikWI+1Cd20NECroo9+XvRT0ou6NYi+cXDsoIjoennfX8lZXpqjSL5iURd9MgYGsy/j3LfaEw5uhy6eTsuVSGGw/WsK67PiJ3usg+KMYCRneAdyI8qimSsHbC9PRPCaG8xd3jEodMf6CiKdfWc+RwYN4EwvouKsnDFztY3lYx0+R7YcVrdmsVOuRYt1Ol7S54QArPCqSUIcZecR4u05rG1Xeld52QmEV20rKn8Ib1USUwuDabx5LgeZCbFvypAOJywEtp0rOY8ueJ6XOnb4F+CGRDJ6TcR8S6cg0VPwMDQgnYSP9SQLojFqWCR5do04KA0ZJGHbofGS+fOCfP3T1Bd3qvwqszqcsrrB4KFLyk/vHKdIqpkmXUroBP9nuXm50vFBuw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa4d33f7-1b4f-4d84-7dba-08dde692cf90
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2025 00:27:18.0494
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WzuwUaTzHdejdNSMIHaoYY2CZ0QWAO1Hq9QiQLnYEr5/6KwDb/wDigPO0pSBwY+x/tbhMaMU5Yj0oeQvqZcBGw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6481
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-28_04,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 malwarescore=0
 adultscore=0 phishscore=0 suspectscore=0 mlxlogscore=990 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2508290001
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAxMyBTYWx0ZWRfXy3Y8F1b3EHs9
 xDvh+t8ez49EhihTHEX58OMOaJ8CxtswlEaSAugFhv7CcRN0dXo44Zy6u7bkKdZIbbc3wBWW65T
 BJlEwQBglEIyxhAegbZHSM7yP9CtFaN+7N4PMVwtKQHoLCEorqrC0jW5iw434rxgJXkHDej2oGh
 xmsoTqlJ+Ni/u2EuD/90FpUi8DTwuJszLHVaGMaD5y/M3km2FTBI0OUTwXhTVDoKJEB/yuNDAhu
 mafy4kNMYvFX93vXR9vNX3BsrRjjmh+1Yv8ypC9KQLPhnTFRcLtfcZXtH+Pcfn8+0KUfWE/VgIF
 Qo4nA+qJBncwVuYK+OEOWQCB+ZHWuWmxEtDgIFDIFUkoKEn1k+fZ+G8WEcip2hkGW3BiplnQxCJ
 f7OCep9T
X-Proofpoint-ORIG-GUID: sj2jrhVQER3daSu4RGigvhz2XUSSGfh9
X-Authority-Analysis: v=2.4 cv=RqfFLDmK c=1 sm=1 tr=0 ts=68b0f3ef cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8
 a=7CQSdrXTAAAA:8 a=yPCof4ZbAAAA:8 a=PabHib_kXikMvU6VWLIA:9 a=CjuIK1q_8ugA:10
 a=a-qgeE7W1pNrGK8U0ZQC:22
X-Proofpoint-GUID: sj2jrhVQER3daSu4RGigvhz2XUSSGfh9

* David Hildenbrand <david@redhat.com> [250827 18:03]:
> Now handled by the core automatically once SPARSEMEM_VMEMMAP_ENABLE
> is selected.
> 
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Signed-off-by: David Hildenbrand <david@redhat.com>

Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>

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

