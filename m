Return-Path: <io-uring+bounces-9595-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CA014B45670
	for <lists+io-uring@lfdr.de>; Fri,  5 Sep 2025 13:35:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7AA5FA06320
	for <lists+io-uring@lfdr.de>; Fri,  5 Sep 2025 11:35:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67255342CB5;
	Fri,  5 Sep 2025 11:35:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WjaB/8bc";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="LUrxIl/e"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74FB71805A;
	Fri,  5 Sep 2025 11:35:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757072129; cv=fail; b=TOsSVNozITKsneCH2P3CwWBwD2jJ+Gy6xR0P6QwNEIhMnqd4aeXp8PqPnoB8iQ/kBtD8YAAO8zSlXvu2pGQEbWERKfYr2oSqVi647OMrDUtpvDcAgvAnpvMETcsJqAu/XfYzRbBqE0ghbbjhvsIfvNBf285XdSaCOfTd75B3Ib4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757072129; c=relaxed/simple;
	bh=LPpp10hu6EpbSMSInREZVDp9E4wjLwuDpXcRugCttBw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=AgcmowlmFrk0zDyua9Hysq53rGDXvrmgqnN+I0BV9PdmjQc3u49bmya9VLOR1LY/Kfs9Iwr3jIpdqcf6nPoKyuXxJpjVjlpB1M8YSpNgF4HDF0Jusp2XbeejU9zrTCY6VHbbmS590TyRHXGNE9CNLrh+9vgMsbC/gMy4bmnxfjk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=WjaB/8bc; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=LUrxIl/e; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 585B6eaA030693;
	Fri, 5 Sep 2025 11:34:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=IY6U1ACtmi0wEcJgO8
	cZpkBn5MdwxPZ6DPvM8VuuWEg=; b=WjaB/8bcvUQhLFfMd0KkeHtXRIcoZQ+Sbf
	j0hgSMbHhFdWhJSTOMciPEgocuBOY5fMgkpeCxGjU0vvjBq6pbTmrQTbJhRyfj9Z
	cl6+31ZWtXDYrRQkesefIFxv88vaZ/D4xfWd6tVzTISyWgs8Gg3FDBgJvwX+F/eu
	cYN3QqW4RXb25dk3rHenT4TjmPXC97tSZAigQ02Q+n8P9ZK4c1W5U3XwuzS63vQd
	MWBcvOQVei/NRBHfEV2vWxiVc5YYfRchzQiad5SrbjgfKaxoU0vc4XuhLbW2/q4E
	jkH3tJHi88XQyCkPC8C65oe1CG8MzjtI/Sp0D1gTtfSLeKsYiNPw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48yxpqg19w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 05 Sep 2025 11:34:50 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5859Jbl8019642;
	Fri, 5 Sep 2025 11:34:49 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12on2078.outbound.protection.outlook.com [40.107.244.78])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrcrrn4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 05 Sep 2025 11:34:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=L0wmG0cnCDzUsvGlBgF5bDHF7bRxOJaJJszbYMY3okdYyUFd01iDVzB6bcGKxOCAYjZLk4OlbOkFiidhRjDdVVbs3aE/sQZ85KduHacU6jN8iYZQwIJ5Pf46P/9kp1/XZzDT5ZJ9lUONwHvZdS1ALjtKO0WCzuUy2gbypL6RFM6T03LQPyfjbRUtHA1TZc8vId5+WlIGtXl4bFEXllLkz8vR6f6/l2U7PBcIOa2vs/As/2qVagmX3amQ9xRW+XlUHTuGie50lTSsKfl3tjPlFsoTVe0r/dFZgeliInAvJGgOs6zmenrFlG1HNoxa8fpjLqlM0tZ5sVVUhPohmYSYww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IY6U1ACtmi0wEcJgO8cZpkBn5MdwxPZ6DPvM8VuuWEg=;
 b=ekqTOxPG9f90dWzG/aJ551u9TuuROq7IQiQJmYYNN3Mt4jtgmWbJkkmDFLCqcsPa1v8Pje8fz3hz7tB45obwqfI53zyb0xldG93FVe5Xku80cyWg8tx3Nm1inPyj1LfiTDisYcJSZUnrs4JFQ6Qj30v/ZdeLoGXwaAioDdOuJ7thnLy4GCBxHHLhX+FUawrak6Plr/jpDO/ZDRoy2dmIKu02JyycF/3H/H8Gmp9bU8i91bSw4/GX89tFl0/MsXuFKTG/aoyaRde6xeJN0K5IE1ctJmPPgE2e3QjbFuG6RL9a5uE/xoA9ENqNSdtUCWqGLzIiYLlewfz4mPtbMti4zQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IY6U1ACtmi0wEcJgO8cZpkBn5MdwxPZ6DPvM8VuuWEg=;
 b=LUrxIl/eTMB3utgTstGajQrMvilcApcpBoKXvLim5V+DXDgW5zBMkGlZI5pS6glsn2Tjh/LDrgp9AeeFaxVqriGoTlUI1Fkkl67U325FdEV78w/PX4nfQ0/imsV3J956cRphVgRj3A3ojvPjhFiiaTR2ILbbW53wZ99kDjP0bq4=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by CH0PR10MB5001.namprd10.prod.outlook.com (2603:10b6:610:c2::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.27; Fri, 5 Sep
 2025 11:34:43 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9094.016; Fri, 5 Sep 2025
 11:34:43 +0000
Date: Fri, 5 Sep 2025 12:34:39 +0100
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
Subject: Re: [PATCH v2 19/37] mm/gup: remove record_subpages()
Message-ID: <b7544f6d-beac-46af-aa43-27da6d96467e@lucifer.local>
References: <20250901150359.867252-1-david@redhat.com>
 <20250901150359.867252-20-david@redhat.com>
 <5090355d-546a-4d06-99e1-064354d156b5@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5090355d-546a-4d06-99e1-064354d156b5@redhat.com>
X-ClientProxiedBy: LO4P123CA0085.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:190::18) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|CH0PR10MB5001:EE_
X-MS-Office365-Filtering-Correlation-Id: b18a52ec-6fd6-4183-0f35-08ddec70356d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Eo3GwVpBaeEJ6AQEEdGZgDlpQGYcAU4wlTt4fX+gmTJs2sass3bUoWKVcj1I?=
 =?us-ascii?Q?2lH66OUSBwKc/n64IKWfEsP6UHtUHjt3XqAVehYPr5Cz0BXiaRgSzdZKwVCn?=
 =?us-ascii?Q?+m+9LORfMr3HOX8GGf+EO7KG2VowMS2FN3f+Z4xvajMzdZ7hB1kxyjW20Igu?=
 =?us-ascii?Q?wUNSSeEPRYbMSJPA9Mr0f9Tyb3Adg7xnnVdGs7S9cae47RbP9r+WZon/jwNL?=
 =?us-ascii?Q?GyNwUs33A5+fKLuY7EwzO1L1IETzimRDf0Iyw3fBor9ZDPvw+cwXG0vx6A2R?=
 =?us-ascii?Q?/lEL2degZp5kvkwzwogQ84UI2iQmQaATbqiVpXNN78h1TnKeSVq1GddwE2Br?=
 =?us-ascii?Q?mem1/UH2gthwJE+WSpvVs7MWFiiUQU2q6l1QoXc63Bp0CGtsqdpLVV2+z6gr?=
 =?us-ascii?Q?m8h8cCAyjObyBxMkIJ2Pad9mTQy8nGkXUPckoI9NIMZsVd3u8lxCoP/6IVu6?=
 =?us-ascii?Q?/TNZJsSPZZLaJd7QFOO+XK1b0Gh+9A15/PKN6Tf/I2dMiSWAOzWe8tlnn0Q3?=
 =?us-ascii?Q?0Js+5Ida2F4iLcdNjCplW2H6irJ5Nc7WN+31T/tHD8vva3yQvlcEq14LwTHE?=
 =?us-ascii?Q?sa2jCuAc3biX8+QjTQ6lQYpHFNAKdOFIVbRGn9YD8yLF9uPHtnVGS2hp7mwa?=
 =?us-ascii?Q?HzMktH/gzcGA8N5iw74AH9vcmH+KQfqG2E3N0FcPU4ibGXC+0fp3MMnN9av2?=
 =?us-ascii?Q?57qzxUa0771645Yqyp00t85wAjhXshRosxPbFU/OHRJnyno20agX6TAqAXNg?=
 =?us-ascii?Q?5uYQa6oY1WdxOaofwZzUQT8beLWCytrw8IAD/fuB7boNI9saNEVi6M0D1/g3?=
 =?us-ascii?Q?IIrHmLQ0n0alPgTbfknGs+YstZkFcxRH2yZ2s57iQ2ZTRstsL6lqiKaQ5C2V?=
 =?us-ascii?Q?+QHrmUayhIBHtq2ya/7fBRhsJhrxLVa3rwj4+PLgTaTRIZTfqv8ehUVE+Lsm?=
 =?us-ascii?Q?ri6ME4nrhJF0hL2WcsSCdkzDcMe7S7hHuEAuxhqM8A2RjlbcvvVQzHfpAlLz?=
 =?us-ascii?Q?2ooz9vKbwiIGlymkN+Xh5vlWJGlnvftyuEqF0HBR8VH/jwmQfhhrwxAyrvCv?=
 =?us-ascii?Q?Jb1tuSfsbzkS2/2OfEk62bg31dje2PA6tkMuprKuvp7bIeQSBpk+UliRtMs9?=
 =?us-ascii?Q?1A+AJmEjIjsZnnHU2Ucp9suXEqAg0l5s8xbWq+nydSz0cX2H4JVI4H6OtDfA?=
 =?us-ascii?Q?1pxD4xTvPCWQBfvaRJzlKQtsemkspMnF3EpsxuH8FSngyjsN9xJd9EkowMd/?=
 =?us-ascii?Q?0bkJ02TIyNyLkVHaHqOePCMQSDXT2dw5d6qFe5J1IPz/R38TKndR3xBnNhkD?=
 =?us-ascii?Q?JBP8btApuimZRwpQ/fBARi+2gEJNgIRZKkE7y+B4URyNpsSTFestGdJm8g5T?=
 =?us-ascii?Q?lnzhxtsMOtnAwu0NLlZE+8adk4L8kQlzq/WKstLHY0Ml2xgd1A=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?lNyvjA3wwUB9rr40qd9SpxJJ4/w/uQSleyLOOUTw1UJQS/SOmF9HjoBSpm05?=
 =?us-ascii?Q?I5dh/tegT+DreNzV+wFCDmmyElwFkJLc05mloVSGOQvdoOPFz7zJODEXdLXW?=
 =?us-ascii?Q?Y+hmMsu1mpOqVeWyM8Q/hNMG5GOayb53UF3LaV0btLcxmnM/X8RQKzsAwWwa?=
 =?us-ascii?Q?ti5Ws7amxbBgZYiIpUXU01UXbbSGZ8+YF5Fl9qRupZCT6hTVGRJzDq+IW6cZ?=
 =?us-ascii?Q?oqPbehsZyjx92J4/jxM25jneTjB/XYf+aLkV/ox5N7y2X6/5urOjMw0IC9CS?=
 =?us-ascii?Q?OcjdEu5m56+xQGAZp07N9DzVofsiX095buISHOLp4VfXXOOsKbNl6XcfbqAM?=
 =?us-ascii?Q?OpNDEZ2Et+Y1R9arW+5uyN03kAs6L3MjLQVEuyYkVFKZ59PGj1vNf71u8T9e?=
 =?us-ascii?Q?vNYE0r8ut3nAhzkDeCbiQJQ0DNJCrJe3bppeUcu9NBDmpTeTLTVl8DEM6ZqR?=
 =?us-ascii?Q?vdN52K+dbRFn03aOEBaetJesImY/vQr6tOrLtyxrOZK5HiIjjdVPaz94Ksha?=
 =?us-ascii?Q?Mei/Yq6BXd+h9p/qQee0nZrnippA5aIrhZyCIgVysoHcLj/UG60T9W0fMNAd?=
 =?us-ascii?Q?mQrBEb+Q1mN+s9K0hGx1vpig7XOFTdJ1YOybuPzdg9e0Z7cmASC+ZiLNDgNY?=
 =?us-ascii?Q?n6i3T5iaPDMjBx8PbiV89oIBAe+CNNGYr4tJInpOnj7KYeJSnG7UsgUhNy/A?=
 =?us-ascii?Q?QlMK3BU2pM446yGRav/aq6GRb5rp6iud72PT1x5S5orhOJCctU7VF3m7J2pS?=
 =?us-ascii?Q?u6gTIMxBHnb6rH1MhCfbNZrwS2usF4POHJX5Wt9+15SkCNS9+L8R9leOS/iV?=
 =?us-ascii?Q?ju3joU+o19KqdFg4PAsVCuRfQd8gYNpV+i/dLQzooeTO15m2BGhZpjxgvx01?=
 =?us-ascii?Q?pzHcJSzvoQ8jvemNONlhToUUHIlcKorf+NppMUiB0AbZxbnZlKtrdq12tP4H?=
 =?us-ascii?Q?t1Ox/Gupw80f9v3yDqtFhTGb78mW0mMThIXwadPw44GGhcbyyWWGaNoZ1Bsi?=
 =?us-ascii?Q?/h1cxfIJUYB7ASOwUZoSHI3t8aYLwe4rUZgdsGQqKdYn2f20qHwXuyJx8ZGc?=
 =?us-ascii?Q?qfNu48ouQrzaodGDcTqD7k3nVLW1BqVTrGsScIc5g/vjFjZAI7TLNYXrP3hJ?=
 =?us-ascii?Q?WcqWZ3H7eOwgztrdPn8Vgpc8fi4ow7nl1VxFfmX3S+ueQ9DeKqYKzWy54502?=
 =?us-ascii?Q?CtqysBYtf6YnUc7TIguSwnmfpjImdpOxkdU+asZ/AN5G0sHZR03OK/mv0tBI?=
 =?us-ascii?Q?2tJWBKXREzSpHJCvklBT0siK9Vv27uEzXnGLzqIgWsc84jJflTTn35lhoHBR?=
 =?us-ascii?Q?4DWLWAMGsS36ZmXUO2kt3EcsS/GuNr+z6PbFL1bbfqj2AnA4TLdxR0hIHTOE?=
 =?us-ascii?Q?ba1GrwI9iNFDXExBxDg46O7zm/LHQhXwEkldJ2dgXzY5HcX8WWj+HS8WZGC1?=
 =?us-ascii?Q?X5Jfr8+7CsnmfMNOuEN0vkwvR4ezJVydH9hqQaPHFeyt3HxeR2gTrros4fDM?=
 =?us-ascii?Q?tn8xfEZinfzwDEzXvaFoKfV4CsLt861s9dL2lzgzvS/L4CGVZjzx2o+1/A4Y?=
 =?us-ascii?Q?QgEN4OVPm8IwjwcR/miv1kB0lVlZSx4QKYsYz7c/lkSS/FZ+XVPdkw+AGlqa?=
 =?us-ascii?Q?3g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	850i3DuLyIrTngsE0Kn7GIncNRfavzNdDPrW3trA8D+CLc9BDOVRg+CAUIfKSSplW2cBlqxOAsje6SHwm93+6vlUH3pKVejHKAXFZV4jj9irNwRaHUh4pFlJCYWwMQOSHynKtLCxRIkJSv2lCnSzhfDzu2ZJPEabMA1uqE0Z+zge0djTjQkSv19CpnSPRDFohZATYN/AOp2yPV6848PWBRdne8CdobdH7zr0kIXo6ZM6iZi+iL6pWeQBY+Kcc+CooFtsR8yKE7yz+epPt0dtBSIVUKdfE8gxBBU0cW8dbKbJoUGvBc9othp4SkyrJ6376EevPjg1r0g5e31mgkjvDCqE8maBS+vSmcNv0mJ9QQ6bI6/KEwPOBFF6v3cUWLD2PYYi3gYeyAnqk0Ng+YjqVI7XswQLzZugTiEalvF/1YfzA84O5Hw3MRa9nCIuIySXM3bJpI9rLlEwNNIABnATraYCpVisCKUYjb5mXlOtaAuFqLfbDnKEpjhBxCY5CpLp+Ooqw3dkBuvZdu9khANXpQj9o+8ctPmQN1DaC3sy++g+/pzM6eg+jcr572zjrfHMWmH/rKvaa/WBNYIp/WhaRmksB2shrEskUYJApZfzi2o=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b18a52ec-6fd6-4183-0f35-08ddec70356d
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2025 11:34:43.4044
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uJWKTHZlXDGjytfRpQ14YsveF6Yf7On9gcOey4wEZr1BArL6E+TDuKndzellzRDkM7/MaZAD0jb/2xe4J2f+zW+i7c2c///w1ZklPctEmIQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5001
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-05_03,2025-09-04_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0
 suspectscore=0 mlxlogscore=999 spamscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2509050113
X-Proofpoint-ORIG-GUID: ssSyhDvSUznUxOB-romg_QCGMIX_YaCu
X-Proofpoint-GUID: ssSyhDvSUznUxOB-romg_QCGMIX_YaCu
X-Authority-Analysis: v=2.4 cv=Xoj6OUF9 c=1 sm=1 tr=0 ts=68bacada b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8
 a=KpnUCH1KnHCLaL0r8cQA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA1MDEwOCBTYWx0ZWRfX+uiQFGHkNjP0
 XmN3trk+SFVIgjdP7833h4TAQnxOtSn19zEFaCfLnir5itX8oKJ4ziL1oHBJ0O75SyM58bVFr25
 lJ6MXgV6i16kXStVTGsLy+tmJBfO4mI2X1lIc5ZguPTNKCkQw0btPISbd2Y3YSzXjdy1N9lyRv6
 J0wCgflpiBmL1MlMIuox82tRyoTOr43JDIkrzJ/kOIuD3Xr6KPGWivLxysACDCMyIW1GpD+EBKh
 tQuJVRCuPU5gf04Y57E9w5lmpYeGooEUBNqHIhcy3ENBGQgWj2Kl2EFidRsTSdBDrCqUFl7KC2n
 gS8U0NoEwmkGugJYrPCt/2Q2zz1ofa6+Voe3zL+qlr37Ie6+AVWrLvA+uTSReI9tgXLEO+2krbT
 imZ+GLmy

On Fri, Sep 05, 2025 at 08:41:23AM +0200, David Hildenbrand wrote:
> On 01.09.25 17:03, David Hildenbrand wrote:
> > We can just cleanup the code by calculating the #refs earlier,
> > so we can just inline what remains of record_subpages().
> >
> > Calculate the number of references/pages ahead of times, and record them
> > only once all our tests passed.
> >
> > Signed-off-by: David Hildenbrand <david@redhat.com>

So strange I thought I looked at this...!

> > ---
> >   mm/gup.c | 25 ++++++++-----------------
> >   1 file changed, 8 insertions(+), 17 deletions(-)
> >
> > diff --git a/mm/gup.c b/mm/gup.c
> > index c10cd969c1a3b..f0f4d1a68e094 100644
> > --- a/mm/gup.c
> > +++ b/mm/gup.c
> > @@ -484,19 +484,6 @@ static inline void mm_set_has_pinned_flag(struct mm_struct *mm)
> >   #ifdef CONFIG_MMU
> >   #ifdef CONFIG_HAVE_GUP_FAST
> > -static int record_subpages(struct page *page, unsigned long sz,
> > -			   unsigned long addr, unsigned long end,
> > -			   struct page **pages)
> > -{
> > -	int nr;
> > -
> > -	page += (addr & (sz - 1)) >> PAGE_SHIFT;
> > -	for (nr = 0; addr != end; nr++, addr += PAGE_SIZE)
> > -		pages[nr] = page++;
> > -
> > -	return nr;
> > -}
> > -
> >   /**
> >    * try_grab_folio_fast() - Attempt to get or pin a folio in fast path.
> >    * @page:  pointer to page to be grabbed
> > @@ -2967,8 +2954,8 @@ static int gup_fast_pmd_leaf(pmd_t orig, pmd_t *pmdp, unsigned long addr,
> >   	if (pmd_special(orig))
> >   		return 0;
> > -	page = pmd_page(orig);
> > -	refs = record_subpages(page, PMD_SIZE, addr, end, pages + *nr);
> > +	refs = (end - addr) >> PAGE_SHIFT;
> > +	page = pmd_page(orig) + ((addr & ~PMD_MASK) >> PAGE_SHIFT);
> >   	folio = try_grab_folio_fast(page, refs, flags);
> >   	if (!folio)
> > @@ -2989,6 +2976,8 @@ static int gup_fast_pmd_leaf(pmd_t orig, pmd_t *pmdp, unsigned long addr,
> >   	}
> >   	*nr += refs;
> > +	for (; refs; refs--)
> > +		*(pages++) = page++;
> >   	folio_set_referenced(folio);
> >   	return 1;
> >   }
> > @@ -3007,8 +2996,8 @@ static int gup_fast_pud_leaf(pud_t orig, pud_t *pudp, unsigned long addr,
> >   	if (pud_special(orig))
> >   		return 0;
> > -	page = pud_page(orig);
> > -	refs = record_subpages(page, PUD_SIZE, addr, end, pages + *nr);
> > +	refs = (end - addr) >> PAGE_SHIFT;
> > +	page = pud_page(orig) + ((addr & ~PUD_MASK) >> PAGE_SHIFT);
> >   	folio = try_grab_folio_fast(page, refs, flags);
> >   	if (!folio)
> > @@ -3030,6 +3019,8 @@ static int gup_fast_pud_leaf(pud_t orig, pud_t *pudp, unsigned long addr,
> >   	}
> >   	*nr += refs;
> > +	for (; refs; refs--)
> > +		*(pages++) = page++;
> >   	folio_set_referenced(folio);
> >   	return 1;
> >   }
>
> Okay, this code is nasty. We should rework this code to just return the nr and receive a the proper
> pages pointer, getting rid of the "*nr" parameter.
>
> For the time being, the following should do the trick:
>
> commit bfd07c995814354f6b66c5b6a72e96a7aa9fb73b (HEAD -> nth_page)
> Author: David Hildenbrand <david@redhat.com>
> Date:   Fri Sep 5 08:38:43 2025 +0200
>
>     fixup: mm/gup: remove record_subpages()
>     pages is not adjusted by the caller, but idnexed by existing *nr.
>     Signed-off-by: David Hildenbrand <david@redhat.com>
>
> diff --git a/mm/gup.c b/mm/gup.c
> index 010fe56f6e132..22420f2069ee1 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -2981,6 +2981,7 @@ static int gup_fast_pmd_leaf(pmd_t orig, pmd_t *pmdp, unsigned long addr,
>                 return 0;
>         }
> +       pages += *nr;
>         *nr += refs;
>         for (; refs; refs--)
>                 *(pages++) = page++;
> @@ -3024,6 +3025,7 @@ static int gup_fast_pud_leaf(pud_t orig, pud_t *pudp, unsigned long addr,
>                 return 0;
>         }
> +       pages += *nr;
>         *nr += refs;
>         for (; refs; refs--)
>                 *(pages++) = page++;

This looks correct.

But.

This is VERY nasty. Before we'd call record_subpages() with pages + *nr, where
it was clear we were offsetting by this, now we're making things imo way more
confusing.

This makes me less in love with this approach to be honest.

But perhaps it's the least worst thing for now until we can do a bigger
refactor...

So since this seems correct to me, and for the sake of moving things forward
(was this one patch dropped from mm-new or does mm-new just have an old version?
Confused):

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

For this patch obviously with the fix applied.

But can we PLEASE revisit this :)

>
>
> --
>
> Cheers
>
> David / dhildenb
>

Cheers, Lorenzo

