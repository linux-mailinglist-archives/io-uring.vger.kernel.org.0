Return-Path: <io-uring+bounces-9464-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3399FB3BDBA
	for <lists+io-uring@lfdr.de>; Fri, 29 Aug 2025 16:30:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6C2C75A067A
	for <lists+io-uring@lfdr.de>; Fri, 29 Aug 2025 14:30:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41AA8320CBD;
	Fri, 29 Aug 2025 14:29:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nds0xCUV";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="B6BJxGGf"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B743320398;
	Fri, 29 Aug 2025 14:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756477755; cv=fail; b=mVyBlBTXR17JBUQUyvw81HpGpxV/7qx5hUOdgeV5fKSOB0k5y1+k58oRdtzQ68CYTiof9hzZMXxdkSn0QO83oQWLnAAFULCfHBJ+sd4LHY68qEt6J/lMFnHqa1UvvtPuO8PXx0iB9f0fmiPsxkSrRBS/JsznJ7oYgDTDeT4qR8Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756477755; c=relaxed/simple;
	bh=Csh1gWcrNpmUqOFWWY87krOxdrr39oj+RUZQ/Wobq2A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=SA/Q4uH8STL2tOVRsbLFzCGrMsift7S576RKiQ5dWjLtD82KL0+ZPTqgS11A1WCJugAGe/OHCw3jfX4jR/t7PuurM4Ypuk7YzudKqsoc69rCyMFuzF4RS9Hn+PkYIfb89XZpOh9PAuK5PI5PfTCHsKIj3N/YzhUCxHsGjYUvXVE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=nds0xCUV; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=B6BJxGGf; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57TCuGPf023146;
	Fri, 29 Aug 2025 14:28:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=y/Wfj+DqHyE+g9KzLP
	vXttB1erXuztGJeeF0e9b4zJ8=; b=nds0xCUVRZ1e1Pv6VUQuTUYc+TTpTaTojk
	h5hvr3sQ/HMDTR9Ez/0YJSg9MzrGroPEKzDkaiBFjcfmkG3LPt3TM8m548e3E72p
	IeY925Fla4L8ARE4C6ph9C3P3nVzqS/fOfY+KFVoHHAsj5Wf3kucN84/OrgkqLZc
	mxIZ4+AFoUxIeRczPue3i/qEZdjwnB2MJ4XsTItultk1IHsbQw3xMH82OfzB2nBM
	uOnT24eFBjxYu3W/Tx90jiy+RNM2xJJ5HOnGG1U3sczTaC03yzMDTN8NtPJNxgDG
	MgUDEUU5wjCQnpfL5j5TYqochqgv9mKOTzXKpT1+BQLuX4K0mujw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48q4jatmmq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 29 Aug 2025 14:28:29 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57TCp7tq005063;
	Fri, 29 Aug 2025 14:28:28 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12on2074.outbound.protection.outlook.com [40.107.243.74])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48q43dag76-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 29 Aug 2025 14:28:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Pfd3vEsL4viNEO22ImXle4lKhZ6KsYPUByq4Hbz2jDXjVLPPhpj9scPmi4rJZ3lO+IHWxT0Lq5GMFL0YLeW533FgGbgwO/TGv+Bgy3VzuzHylUonLf53niI6vHwastyaiD62FoTJd0p2+0CEc0yj7yTmDnR0u7AqINwgaCwke0K/D9zcAsnHrRA6xf/wCwQ9ytTrR4DWTJvF61pRKuLv9badTEH/877ydUwNBIaJta/FQ+Ra09MSmC085SPqJ0JC5F6mSWu9qVtfPSZ0n2F5agYWmVpdIQWJg9NZ2K5XCLrWgzSPYCnK4yV/SZ70rE3tEfbH5hgQu1dGhygRlULxcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y/Wfj+DqHyE+g9KzLPvXttB1erXuztGJeeF0e9b4zJ8=;
 b=mYIBAmp1ZxMo7/iH0ERBW9LEgqs6IBG9LDFiF4BUtQK0392tUan/TgpxPBrW2y7y7VzP905al2kZBgQbOIjpNtynG5bRcK5YHvEur4HCQjBWQMSdWGRGIehYjq69p9MCkLSWOWS0uR1iimFxhpF4nYdB0YV+AJc51YbETwJ5SoroGu32CB7/fSbWVqpPItSgfbBKi7VMELr2qkD6TNy1+tev+hWOtXVVbCuiH7NHi4vG/yKOcJKEXxd76wDSdKcWTNV+FFOdtkhxTPuURGZQHMc+vRYh08U29fIYALUqwEni+JBHggyPadFjtk8Hoc21swj+iMMh54fVlwACQruAeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y/Wfj+DqHyE+g9KzLPvXttB1erXuztGJeeF0e9b4zJ8=;
 b=B6BJxGGfyOjSJKhSzKbiIr1HFHVBtl9LyqOt3+s/20lKfVmVF4CtXdJZtqJJW9tVeX8X1S5GtA97T4gM87A0ehdVehwM2bDvhe8rYy1PtkY31saTas5+sfJQg67FoKMWyR15nC7z0vD/c/8wnFyON7FFew5xfga/Cu1MNTyaqDo=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by PH7PR10MB5877.namprd10.prod.outlook.com (2603:10b6:510:126::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.21; Fri, 29 Aug
 2025 14:27:52 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%5]) with mapi id 15.20.9052.019; Fri, 29 Aug 2025
 14:27:52 +0000
Date: Fri, 29 Aug 2025 10:27:46 -0400
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
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
Subject: Re: [PATCH v1 11/36] mm: limit folio/compound page sizes in
 problematic kernel configs
Message-ID: <le23yqshxkwqzdoj3pgv3kt6epxtshfu5omxcr4egkhuhh3wyb@afauanocxw34>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org, Zi Yan <ziy@nvidia.com>, 
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>, Alexander Potapenko <glider@google.com>, 
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
	Vlastimil Babka <vbabka@suse.cz>, wireguard@lists.zx2c4.com, x86@kernel.org
References: <20250827220141.262669-1-david@redhat.com>
 <20250827220141.262669-12-david@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250827220141.262669-12-david@redhat.com>
User-Agent: NeoMutt/20250510
X-ClientProxiedBy: YT4PR01CA0405.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:108::18) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|PH7PR10MB5877:EE_
X-MS-Office365-Filtering-Correlation-Id: f920132e-b2b7-403d-5915-08dde7083cc8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?77iYJeh+lHITMhQo0FuLWjWfdeJksPMAB2i2Bc6NapuPom2SENqXbygVGGae?=
 =?us-ascii?Q?4SI55wE5NVQ/8IH4TbFTOttSbM6PsX5iW1I839xKHr82bHzP7cAe0F0sgdtI?=
 =?us-ascii?Q?CGP7yWZx1mlN03llNGA31A+88WIcwhb+4NHmPiyJo0K3HkZuxhccQ+sCRS92?=
 =?us-ascii?Q?ilyWtBJeqtflgnshBJJl6qY46yyJLzmcxbHVweEn038BhrZbeJodgPPwRTiv?=
 =?us-ascii?Q?dXQpnadivR+bmQ/LpApkPHC7/8NCXQmtOin9O1CGXincSIa0XvkPgcVSfXQq?=
 =?us-ascii?Q?4RFx/assL8kyBMfG0te5Q94vI+QOY+eL9nPRaQA32Y6PKFJaEKqMupuR/HXr?=
 =?us-ascii?Q?mXp/ZQf/8PskP/CW4eB4MGeuOtCBIcL6qDk1pmM76qRIF00dccgU1/9GT/Ma?=
 =?us-ascii?Q?PRokHOYSLf5RaTVvioDl1Xcv4/+oEVQnmGwrnEFNKqkDRs387onr32hWoPAE?=
 =?us-ascii?Q?qJ7ADWHMzVkJmltA0Xu0hsxesbnzcdmobSrERNkUv2NxxXDSbX4GjPGkQ3yC?=
 =?us-ascii?Q?CmspXRk9Xm7RKn/PLxWZ9lA/eRVRhRtb65DLhhZUkqpTCEcxpV1tC95ZMJBD?=
 =?us-ascii?Q?jD3r1kawXXoALKxR7clwe9p+8tCt+AMj6xyadvwFPL0kGv/KHOMpi2nGF9lv?=
 =?us-ascii?Q?2/xhi6EmaS4zZYHWmZ+KmcUxI1evP9ZuYE3L711yYFbji7+N7AtkWpJVGr68?=
 =?us-ascii?Q?1Z/PDEPyR7WLCNB+MApTNQKolXtrVfm21Mgnp7LW5u8GNQ82eUhZv2Ty1hBf?=
 =?us-ascii?Q?xDN1rncQSDcoGoam/Fo5KZcNlTyxpJ4MeHBtHvBhz3HraetX2mSaruGQnGY+?=
 =?us-ascii?Q?atLmVtXeP6j6MIqNWtFw7mA14Huc/wiWfWQLptCS4jrtAt2DHZZbqfgijpiM?=
 =?us-ascii?Q?zgqisMxF6mV9UQA5l+7PxoZJQZ0netNTcef0JHYq6LffUepa4xRIg2kIh8yF?=
 =?us-ascii?Q?BPQEBxHIl/rdGjfmbIYizaKysDrMVuyeKYIFLXwv16wH26Y3sgqIrLsZWUP/?=
 =?us-ascii?Q?Jn/oTsaT6Mp+0MUEtHOGoZEYeszI5B5Z7oVIwHnFCRmPj/G7ZdyCEjjlFX4J?=
 =?us-ascii?Q?xD0/j7tHjXN7q7b9MlBAikitc4rN/9fcr+U0Mw78tFyb+lrH7MrDNLDnZovW?=
 =?us-ascii?Q?pPYppjUmQKRVY5ELaO3NQyC7rbonA/jyu08NkjIQ24Yn9WPKwh6HsD7lksFL?=
 =?us-ascii?Q?mz/YBZiv5unrTB1V+ODAbqOi1SWkqpD3hcDCnAWbWdK84Xvocpe+EfNd3wPQ?=
 =?us-ascii?Q?mfNnH7v0UHIUbLkwZvjkk9Dg4CzX7UMaUApJXkzEnEZixAHbF6RcOt0qgfc+?=
 =?us-ascii?Q?L4wDQ/S3p9lUvQVyK3fiLeWWv1vm1itp6ZntBhPe2ePhrTBNZoXiLI7t/cmO?=
 =?us-ascii?Q?tUAUJRtWiTKkjc0v9ENqq/O25RK7xLP66C2QUy+tI89iY4mVo4+pNHygnoPn?=
 =?us-ascii?Q?gIIXCem+Ajk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?hzK33oZVfT7z5cMuNgwmco2IANa1iZRBD55DlmW6Hd7YQ6nmkHMF6kcjvZyJ?=
 =?us-ascii?Q?GODhVt67wEklC3F6z5pBG84mhJ9ViHj7ioKb5QgNYyK7v0z5X+ftStmWUhIm?=
 =?us-ascii?Q?B57ZJRQ/kUMoKM2X5nOdKOYCYf0ixj82Xf3EM75IH1PiYBsj+4cPcfdJZ64s?=
 =?us-ascii?Q?SOO2yUGkgnQwdQNauDHogFRWgQAMSFsiGkBOvOhXNwnOcLMlicakVvVhYfo4?=
 =?us-ascii?Q?ZzJFSF3MG2MVcW7oWumCfCl7EKp5hDwJVKwI2bW/wwuhp9c2nL9GhiQqP8oj?=
 =?us-ascii?Q?wrwUfwpyPjq0GkY35FLL4dklfmREwr5EUS4kqqZcFJXlgUhJEXiy1fpyK3na?=
 =?us-ascii?Q?zyRU9aRPVhAGH64HQMOleJ+lzcOaoq7zEs6qk3SwJnWcIDIng0xDIpyxVFxT?=
 =?us-ascii?Q?9EPXZ2AcWYOZHGaPkPspUnOzLwyQfsHfECd0YYuSk9ABK1aqv7BZcZz3K5UA?=
 =?us-ascii?Q?h6wcJsDvhKczPJu1RyBmsXTMbl1srUxZU5QNNXMi+ZUNjmmhvDKvoS9mINhr?=
 =?us-ascii?Q?vHL5S6Eu50hqKq7oWhAQedqjtubHxC0Jo1oI218HXFuz/7SxIY1y1mI0OvJ+?=
 =?us-ascii?Q?nFn3+2TYERYiLg2B19DANgwUB0B0HpKvbvErpRtaONaLLuZkUTXW7uDCRazK?=
 =?us-ascii?Q?+63CD2+I4NusIz9qF3OhdgauTPMkYYRojjqsH6Gd+PBzWufKcXjkt1LxETiS?=
 =?us-ascii?Q?R1BvOr2GJI86q3eZa2dZp1FUGIS0J4VXZirGG7+/1brV71xpWWS0Inwe4ls+?=
 =?us-ascii?Q?5l7nQuBLIzRdWnx0pCVkBEwoJm6CoFEI9f4Yura6JlcGyTNU7SjQpmAgHFFq?=
 =?us-ascii?Q?frEmiEKNXfKmVEs+iN09SG4JADM9IC9i64R2i6SoqWUFQebVX/dLbcj+t1Cf?=
 =?us-ascii?Q?vuAJe/1Yq+FCnvTnxVdViXa3erlBDCIdch625nintxJX9P21rawyC2hJP/6m?=
 =?us-ascii?Q?3WZ7PTlOxBNJXUPddq++terOR5E2lfD/o6VOkPzLq/2CAdpLmSlcbrXA/+eT?=
 =?us-ascii?Q?XRhucwsNohF/T9wpkZvp5JEgajh8FztUPnfwu5dzAOUHjdZwsVrDaLLL0+Ko?=
 =?us-ascii?Q?lYzZB0Ydki/msO8qMVKWvVyv9zZblfltHAPgtzNp1L59OYIzOBgMHgkLsfeE?=
 =?us-ascii?Q?pgdvhyhyFL8YmBxOReWI0Vp0L4g2NXgtqXfk7XRnLmY+HY5vP73Y701uclMl?=
 =?us-ascii?Q?ZiXY2QIE01bu/MEj07iKva16F9q+1V6nQDtF9iOC2V4ioGeYme0/BkdGT4HL?=
 =?us-ascii?Q?sUEZLMbKUxYq8yoD1jJvZx1vtyc5Jk377bOBBOmUnePJ3hMyUYWaamrFBgEy?=
 =?us-ascii?Q?tzNwpV6/YEokbgab2KVVobSviq85oSLTDZzF96JNVtwR4dtrEUDUytXgBv/c?=
 =?us-ascii?Q?lRYYH8ynYG55arg+xkuZjkj7ZIYmrxO3g0iBP6ia2pfWAhuAo6MIqNcPXkDX?=
 =?us-ascii?Q?Z6n1CT/GnJ3GGuCXFbfWcp4Rs8iNWVqmvd1DmkyLbexb81JeManSGvzrUP6h?=
 =?us-ascii?Q?dlVZGo2eb2lMKDbzuz/C9y2D0s6hqzSIdE989CfN+Y+ImzjdFJwCz3VvciCm?=
 =?us-ascii?Q?k8JMJBRFHOB2QFOqk0I84mkbKuCCHUCMBHl3sIW8jtrLk0HnirzP98nW8McA?=
 =?us-ascii?Q?Kw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	CM9+eeAmsHCrjgdrpQoqJxRhFjPIUHx46sE8vXOiWOKCHrxl9cp0LoqyhAZR4z9HB0cIisKxWeLojNf22iEk+jH4PSHDBcLEnJLhEsJOKWJyMNmC0iNnAxAnwduma7NysBartUxUERk+nvGwELV30BV/3veOus9c94+llSeR1nkuCcnUzhSrD0g2A+oQOIdIvIylCvSMUALBqZO8Pr3LoJTGhje1l8dn8mYpy3HykKEWyGRysEmbCagqLQu/PhRwHYB1CRgsC5zzgFjGTVqRGlz+KQgruH/TrmR3JycKdSysLiYYgxLgV1WXXynWnbXBCkQJhoiewD0NCibnlkAweNe/1lrg0gILJgiGz4r3fMCcCZMSUOi1l3+WjNyjeM9F/XsB1s0F3MtgpPesS68iIKq3QnaogpC7nZn+JWYFl4yWom1Le1sgyN7SJRmK7+BLqA5nxSwAXKxcuczaunho5VEb5gl0my/hG9gimo0dRe2h6FKNSqVWf5wtcb+AexhCj3VDPWlsKzgsnEk3yB+7ftXs1LtLWpVA0Ts+lQQPE1nlQn9lTTjpsSAj8TdxUlhid3O10TdkX7FiisKOneAzh2bLCAKLMNT967gLVREQMXQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f920132e-b2b7-403d-5915-08dde7083cc8
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2025 14:27:52.4488
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WBFwAHM2aFI/RuisfwnVC/KHoP9Ls02Ew+mRytRE0n3ODpUdN+hgL5AkRIMRh/qi1/Mx3mjUuai0oCrLOqZCxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB5877
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-29_05,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0
 mlxlogscore=999 spamscore=0 suspectscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2508290122
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAxOCBTYWx0ZWRfX0kGIo2LINChF
 jttR8BCcoxS4HBdNElwUZ9wc9y4GfL5DO+YUF6drwMZyasyW0KOL0j2AhpeS+4nXei5t+XBZB91
 s7BKqH6zDWXV1eZmsvghG0Qz9D1+i9bBwGGHh2HBzTWCxGbMjb0EFltCqvLgRt2C82GYmuyRmB1
 tKpw3NFGxJgpwvqCU35UWH1S0dRSbgFAy/W9WpLZwh0jK4DlNqosQy+73xK7uC3517aTYbsV/44
 doIy1h6Jo1YWgLfIeUY8JtRLyjWskB8Gi39I/0W3r/yQsTP3pxzNKrQln9ChEfzKThRvu606NLR
 vngWVG59+tJ1hhSJOEmb0h0PARA63+d6L7oPvm+Cq8tNWuqGtUn4+rY3gTbtPxwPoC93UTMvBQN
 yV2d3l0O
X-Proofpoint-GUID: 1t32yqI8iiw3TUyJC_y4AtEWXZiUd87R
X-Authority-Analysis: v=2.4 cv=IZWHWXqa c=1 sm=1 tr=0 ts=68b1b90d b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=20KFwNOVAAAA:8 a=Ikd4Dj_1AAAA:8
 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=r2OVo3NODdYC9qRF9NoA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: 1t32yqI8iiw3TUyJC_y4AtEWXZiUd87R

* David Hildenbrand <david@redhat.com> [250827 18:05]:
> Let's limit the maximum folio size in problematic kernel config where
> the memmap is allocated per memory section (SPARSEMEM without
> SPARSEMEM_VMEMMAP) to a single memory section.
> 
> Currently, only a single architectures supports ARCH_HAS_GIGANTIC_PAGE
> but not SPARSEMEM_VMEMMAP: sh.
> 
> Fortunately, the biggest hugetlb size sh supports is 64 MiB
> (HUGETLB_PAGE_SIZE_64MB) and the section size is at least 64 MiB
> (SECTION_SIZE_BITS == 26), so their use case is not degraded.
> 
> As folios and memory sections are naturally aligned to their order-2 size
> in memory, consequently a single folio can no longer span multiple memory
> sections on these problematic kernel configs.
> 
> nth_page() is no longer required when operating within a single compound
> page / folio.
> 
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Signed-off-by: David Hildenbrand <david@redhat.com>


Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>

> ---
>  include/linux/mm.h | 22 ++++++++++++++++++----
>  1 file changed, 18 insertions(+), 4 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 77737cbf2216a..2dee79fa2efcf 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -2053,11 +2053,25 @@ static inline long folio_nr_pages(const struct folio *folio)
>  	return folio_large_nr_pages(folio);
>  }
>  
> -/* Only hugetlbfs can allocate folios larger than MAX_ORDER */
> -#ifdef CONFIG_ARCH_HAS_GIGANTIC_PAGE
> -#define MAX_FOLIO_ORDER		PUD_ORDER
> -#else
> +#if !defined(CONFIG_ARCH_HAS_GIGANTIC_PAGE)
> +/*
> + * We don't expect any folios that exceed buddy sizes (and consequently
> + * memory sections).
> + */
>  #define MAX_FOLIO_ORDER		MAX_PAGE_ORDER
> +#elif defined(CONFIG_SPARSEMEM) && !defined(CONFIG_SPARSEMEM_VMEMMAP)
> +/*
> + * Only pages within a single memory section are guaranteed to be
> + * contiguous. By limiting folios to a single memory section, all folio
> + * pages are guaranteed to be contiguous.
> + */
> +#define MAX_FOLIO_ORDER		PFN_SECTION_SHIFT
> +#else
> +/*
> + * There is no real limit on the folio size. We limit them to the maximum we
> + * currently expect (e.g., hugetlb, dax).
> + */
> +#define MAX_FOLIO_ORDER		PUD_ORDER
>  #endif
>  
>  #define MAX_FOLIO_NR_PAGES	(1UL << MAX_FOLIO_ORDER)
> -- 
> 2.50.1
> 

