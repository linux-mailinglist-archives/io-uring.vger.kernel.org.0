Return-Path: <io-uring+bounces-9420-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 18995B3A935
	for <lists+io-uring@lfdr.de>; Thu, 28 Aug 2025 20:00:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 34E611B27A46
	for <lists+io-uring@lfdr.de>; Thu, 28 Aug 2025 18:01:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3FDB25BEE8;
	Thu, 28 Aug 2025 18:00:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UPGdT7nH";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="c36bSQNu"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08DCA9463;
	Thu, 28 Aug 2025 18:00:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756404039; cv=fail; b=Q1j0CpOCW0tij2fTWasts9pLoCxt7HN9WC8ENO09xZdBX70GTar0mZkqJX3pfp5llCZfGYLP+xm+emQ5DbWglmwQjmYP15S9nkNkUiNNKrzeLGWiYc9QoNrxELv/CuLBkICemKsNeEZwM/JJ5KvgjHD/A7+/08jM/GvOxjZ1TM4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756404039; c=relaxed/simple;
	bh=60AVWmHE44A4GYXdjOm7Mkx3SAu0aREA/jeEaOhk/V0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=VzAeE4lFc1pya4ZnjV1mor8yEgWhW0l8az/y8nHW9yN4G32nkmj8t4XESxg7ZFUraq07O0ElCClVzDoPSxuJDdU2xNBt4HeYZ+T08cwbXUda6S04AuTlRZS0l8qCY1fmaKUuMZ0N4QgiioOjaxYj+tBWHk6lqvsKRDRohMZR5BQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=UPGdT7nH; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=c36bSQNu; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57SHMwRk023482;
	Thu, 28 Aug 2025 17:59:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=qQzUElC6pCUB3XbLm2
	x+LA+4L6Azg/Rd2vAT4sjIF9s=; b=UPGdT7nH2kt/MPOXS4xQ+9n4moBeNVgTHc
	pTDcJg+dki8iswT48dy0dhg8sYXyjAL4nfU6OFZYlJh5a58s6vCq75Gjck8bd+1K
	/Hs25Dfk9xVwCbe3mur9fQT4jQ7MKzwy5Z9S5dHWsm+t40MF0cHN1BPXc2tKfqz3
	D+8Xu0oNTaNFSjjJZ/fayzfcHpcwyNndZJpTs4/R41AHqICY4Nt10zsXsNUEfUX6
	F2Hs0WM9MnAJpMN7KNo3CriQgftT83IjF41kk0U93Ynd3I67AlTdnYAIlbrUs8HL
	w4VSg4S+CptkHq4NpNKpB3Bjezx6mrfba0PNA3YidMj/P2Vui5Mg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48q5pt98jn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Aug 2025 17:59:56 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57SHLApm012211;
	Thu, 28 Aug 2025 17:59:55 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12on2051.outbound.protection.outlook.com [40.107.244.51])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48q43c6e6x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Aug 2025 17:59:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=et9HlDmq5eBqpM42b+e64ZZVEnkUlbSLJlt65KYRLoaguEp+DrOM+BYuetBC37wHj9puXd9nXr6BfW42saAZOZdWHSmN05BL9FLVbItg1P1wtxqKfYFdMbFkCDBZRfC6MXtX/+4yx+Gan29UYrd8TcP7/gJCETLLu6lHM+raHj4STpK/ZYKE69ZY0frbm9dJp+PUTw2Nz6twoZ4F6KRFQTWR1Xxp+Dls3kUI07m+mBX3NGgJFdPm8+dFlTC7XlIXJ/4HjX0qdOso7s8Py2rqVmP5b/wwr8oismc2lSHquE7aQeVzC5Xttf0pgwoesquCceUEflWlZn9eLOB3GY0EYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qQzUElC6pCUB3XbLm2x+LA+4L6Azg/Rd2vAT4sjIF9s=;
 b=TfPAZigmEo2vS7nwDN4EWnKbSZlxY6X9Xs1+/XkPsTwYAzDKeo6i5W4ra3S4DAITTLmAtHZdPvFGZ0lGh1HfrHfNgKoZarh8EihNQSJrEUO7NsqJyAT8clxCTYLxXYK0c6dzLVrV1JouidyWCWZHjBHjGpgEpnzKo/oTHt4td9SB0/zdw32w81b6/sUloqiGnPu7wruMyrHAaIswFIDQpTb5/JaThM/ZOCfrlBRGlhUuNCmn+B58yMADhzShxDmyI6k9l4P/MJj3Xsdo63r0/TVtDVkFqSJiLa+D8TTCmbOaqXYH0xR0KzCTnD3R0c5vW+05bmv2KD43hQUhhUU3qw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qQzUElC6pCUB3XbLm2x+LA+4L6Azg/Rd2vAT4sjIF9s=;
 b=c36bSQNuYnf4wM14xNuNywCXa8dRlzROMfkMMKR615vm5x4z6CyIhWmnux66Tq06z3Jg3y3VZTATmiYK0mBoTBTn0O7ZPW9rAAyKc7Y42S0m9Cm8/Vduk8/RcxP+VQATMYg21EtH+2EcaHNADq4sJu1EQ3bCnAYcs2Ve19LDnS0=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by CH0PR10MB5147.namprd10.prod.outlook.com (2603:10b6:610:c2::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.13; Thu, 28 Aug
 2025 17:59:47 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9052.019; Thu, 28 Aug 2025
 17:59:47 +0000
Date: Thu, 28 Aug 2025 18:59:38 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>,
        Alex Dubov <oakad@yahoo.com>, Jesper Nilsson <jesper.nilsson@axis.com>,
        Lars Persson <lars.persson@axis.com>,
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
        Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
        Muchun Song <muchun.song@linux.dev>, netdev@vger.kernel.org,
        Oscar Salvador <osalvador@suse.de>, Peter Xu <peterx@redhat.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
        virtualization@lists.linux.dev, Vlastimil Babka <vbabka@suse.cz>,
        wireguard@lists.zx2c4.com, x86@kernel.org, Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH v1 28/36] mmc: drop nth_page() usage within SG entry
Message-ID: <b0ff494d-9e34-46ea-8b32-bd650bc3b74a@lucifer.local>
References: <20250827220141.262669-1-david@redhat.com>
 <20250827220141.262669-29-david@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250827220141.262669-29-david@redhat.com>
X-ClientProxiedBy: LO2P123CA0063.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1::27) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|CH0PR10MB5147:EE_
X-MS-Office365-Filtering-Correlation-Id: 0730e9a2-7a91-4992-1dab-08dde65cacfe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Vl5cda6i8GoQqy1IIA5YEyiqnp4fCJzrVLrAaC97a/W/yaQSrKlu0DwZBxAl?=
 =?us-ascii?Q?9TCz+t+16CMf/zefYpQkTYiWvW/+Na9oorKos3vGKTtZk8GwjPFOvk3Kg0dE?=
 =?us-ascii?Q?YVYL5vRARhPdsmUEujsRUmZuuBQ1mPjrr/bjutOH96FPTMKwSfNnoUZmo+Rk?=
 =?us-ascii?Q?x1Ep1rPiT6W8gCS/ZMAZpj95Jh8OYI2dURfejeuWI15Hs5f3Ql93Tdhr7iSL?=
 =?us-ascii?Q?sFWg7nacgR1YomZsrBarhKV+NrPHSO+/fh3EtNtT+prwH8pfhtY+uwb75FkR?=
 =?us-ascii?Q?d23b3jAJTHKZJo8hTJahtgBusrrpYgMnAgrqg8LktEr6UbbEnr9w//iCs4tp?=
 =?us-ascii?Q?fLVj/YvNvnBP/uO1KH8QFLYlP95CFzzN7cSl/qxU6bIn9dar1qiO4X6Mmc7z?=
 =?us-ascii?Q?xZwW4SUnVgaJi8vgyCnFLHz5xSucStT8a3HcHFdvLQ+NZmqt7YCNUTDR45gu?=
 =?us-ascii?Q?eZ2zoMnEbGDIMuuFJ1/lm/Qq0HWeyNtFyXZTgudpUdX6kjv5jr8PI49TP4OL?=
 =?us-ascii?Q?65b/2UyH52FmpFmR1m7uupHpU8+VSUGLrJgNaUJKHt82hIGxBqQiUZ4/SXJj?=
 =?us-ascii?Q?PY7jl83UZCWhlYvKMfs4CBhqYeqxkcLS6cFwKgOEg1aZbai6hINwi2byH9ah?=
 =?us-ascii?Q?TaMKGbXeOEtG7wp53aG081xmmfTCwpoOC9ofKDUlqKRFhfky7X7fz1l7cfiG?=
 =?us-ascii?Q?cQO9kUJwtY02s1W6CF+Dcvc0zvuYL7naNCQjTTY1YWpsQUt/4TmCIb1DNleM?=
 =?us-ascii?Q?5Ys0BXagrcGdDUofp8ASdbWxOpzL2g2lYRscpfPj4NMTnBFUIiracl61q9Gd?=
 =?us-ascii?Q?MOHIPasUwriAnq1I13ciqNAyHQ0MVkiAJKMrOjoLtpmNwI13tFkVHaZmgyd2?=
 =?us-ascii?Q?pAxfMp4igwfMMgzvjJRCuZC8j428AALHe2Yw7lfP2qvqA3kpnkICluL5msUu?=
 =?us-ascii?Q?knq1Jxf02kCVDiNinKsS9A9PjpvfamBVPhQAMdWEd0jCQasluSTUrKj5v4+V?=
 =?us-ascii?Q?UKMwBxV7bOMgBNhM7pj56AjaqnQW6Z8rn6ju4NeCMMBzy3w0euWvg8erfMCq?=
 =?us-ascii?Q?Hq03/OFPZAdM5w5mDV534pfqNgU1A78fCAP9NVUOd9RnQXMCf9t5DuFczX6v?=
 =?us-ascii?Q?3fRazDNbh4xKYjrxKEv048uPKv2sHrt1A9zDycDSeVvPiCXNaibeLciL8nTE?=
 =?us-ascii?Q?sYC8Q0MoWQqEecdaW5p/ujpOwKr9Uenhni9Zo3HxsCOTbxd8cf1M4O08se1H?=
 =?us-ascii?Q?Bg3ySUsBmU5Kk/cPy0eApZhIIrbWRAgZMSORj55i+/th9Olku5hdHG0XXhPW?=
 =?us-ascii?Q?9SglojtUkuY/AWYcyu2FcgNN4K5mwhlHx/GOG3cwt4aPpptR3zrcunI35p5A?=
 =?us-ascii?Q?teyFPtZieNIuPchKEUMWNSjxpqiGK1pT/5VVxItoiua5t+21omg5xHEsvmoL?=
 =?us-ascii?Q?/iEeVj0exbI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?dqz1yiI94OtfmA64SQLjdOornQ+bKNWQ8EjWr5WgUS7ZrdWeoBHcjevzqsS/?=
 =?us-ascii?Q?py65BpJ2RTmijA8hfCz6vcLXiGi65gMD5Q4KS3ol2mX+iEapa0qhbAZfCW/B?=
 =?us-ascii?Q?Nu2hHwNnCOAIUzbADlCGktVZNe2kLAmWjV8+wx90xRm+PzIl/H7rYWUATPfZ?=
 =?us-ascii?Q?SQ7AH1LYqN3Aj3r9Nus2oOrTqBR6yZl/vXHmD6ziqlrfiUEEYwVFqfJQ/BxD?=
 =?us-ascii?Q?v4AutK+wcHiTikA5totdGJjUN+Y56KEey+gBu2Fa6fGYOX+met0GHXL42LG4?=
 =?us-ascii?Q?pumSJup9I6e6er3dk+9Vl2jVtglG7r0eCGL+NANqeYHR1gcTyVcTLJErQV6k?=
 =?us-ascii?Q?9XbqUMfAOHUZ8Cs3LowAYUpXMezWrM+Vi5vXXZPMXiSIHj95Fr2OtTVNbJyE?=
 =?us-ascii?Q?AkvFgUEvEvZOFoN+uexFKoN+8+VhKBH25RuC72PBU2jnrydbvNsZsElsgD44?=
 =?us-ascii?Q?WC2vsvYzNykUROBNmWV/BaMlT7xWpF3hTSKWlcbXkE5OTjK3mIqm3+VzMf7r?=
 =?us-ascii?Q?GozHDni7KoCM1K2UjL+6b/pnetdqy3WCSKzkIdjO1yF0oDhGE8rUbqRQecMZ?=
 =?us-ascii?Q?6sYdHmDCecmfpdLPQ8kCMxLl1sTLJQ5gZ3vtb+Kn6KBHt17VOMELhcjuIUuG?=
 =?us-ascii?Q?BL3NSrwVuht7AfqZtFcDI/vlCElYXsLLYzHt+wAq9AAgcqG+B2gQw5SKclob?=
 =?us-ascii?Q?h2+4YSnFxMJZAHYBTcNX4rc0KrB8Rt8hcxQcQAu8BaVIR5UbE2CYtvxNg/J/?=
 =?us-ascii?Q?s5om76c+uGRwHREnEw5ZToSqGt27S2snTzq1E3kkt2CHcVM9oSEREsEYnm2B?=
 =?us-ascii?Q?vCyVrjNKjgkPnEC/rTTtXqllH6fIsgHha2n33vqLT9K9WCn3C42KRIKuF8XK?=
 =?us-ascii?Q?AAV7oehAtt5kZJgByUyhruiNnxzmXlR4Q3u7thUk4x2KtO/ZeU7KlcuLbd46?=
 =?us-ascii?Q?ZIYejFQ0ehCQs6vXm/iOGpsqdednkGLkNPUY9wpT8XVV5EBOwoSsbIItXACk?=
 =?us-ascii?Q?a6khoQ9hw6BpZpcbs5HLvawPIbP2O5CN8hjNU36xeslDosCFEopsHODjl1rm?=
 =?us-ascii?Q?1VFSsRpPfhd7MiYSssZjCX/SmRvUq3bg0XksWf0TJOzY7cpvsbG0lvMW4zXP?=
 =?us-ascii?Q?vjjjTjsa4oHM86skoHP1Oc6QgcVJn+/YDTyfR+EKAMBgtPS01vzvjtzdMbsp?=
 =?us-ascii?Q?pxjDbtVbf+wSu/O3gg1bA31LB3qA/CFrbV6ZW2axuE1EheSiRJO5M8HBuUj1?=
 =?us-ascii?Q?GUTYByVCTbD/21vxJiMRo4JGTm+MMcnJt6ZgletYlkWOOlbwC0UKb+MX/rZs?=
 =?us-ascii?Q?GcxkrVr3wapdLXRSrCqNPRJhkliBwZF7rOg4SXX6Xt5Fo4YW6csJPrPDIMb1?=
 =?us-ascii?Q?KHi6LjRRPAWaqA6yKncCa5dx6pPSH3XGuAZfpvYaH3T/B6BiUZI2YEpT0Ele?=
 =?us-ascii?Q?q4stEqK2WfPuO6w0GvFeDVOrSFldgCAPJpOqoy5RBSiWbEKhITO7yDAg7pQO?=
 =?us-ascii?Q?vzzMIbac3BYWcEQUVUqz/hQXJJP5fVyW4Z3O2lrBx2VPco9gJP5XoxdVDd00?=
 =?us-ascii?Q?UlHZaYUJtQCD9Mk688t8meML8Yc8RWGT99qRWAy4XpOqrpEEjhg6BaptWLKD?=
 =?us-ascii?Q?kg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	u8VR+8Yp0JVZ8yh+xUzBCUgOKwZEpRwCmfIlOMZIUgGdiXA3N/Oa7ieflPnlwCUzbYmpRy7KJslsQPiCn+fX9tybxQ/o1emQu+3yxMuykuVJS84GjNFwQYRaPRy3H0xh5+2wzhDPq/sumaY7EwCcQPVNtyiao1jexRuFefNl+ZrFmaFHg9FEPiqsdrQDZhl/e89k4dGPW6TsQmYtxh7DdLfZPm26Y605YK6ep8bl9ePi1KLMWf+sX0f5FiVDXpERA3aUOpisbZHFyS7WcWDmJ3hG8w+iPalfbJ9/q/HZh0PWbjBp/PDEpOSlv2FX/vBIt+0RA0wAvUCBStdEyh9Y4+kxhOQ0zVttPn+keBXCJ6VVnDP+Fy5zBqg4TapZUeHwOy2u4k1R/XudvYO1vxqJFlN5EWjS7ZZHY4+3U8TklEo6GCiU077NbX8f5iFenpXtC0All+rLpy6Jl7nv7HFM0ziqqWLfsvfQ75ttv3l/6Jz+dxWl/shI9h6yickOmsMDkIZW43dfD1373LthcdUYV4fZlOWMReOF5sqMdwEMtT052OqwPwVEkpa3HAyeb3vUyYHczeyf6EeyMom610rodCiMw1lDqB6xWjnumvRnRAw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0730e9a2-7a91-4992-1dab-08dde65cacfe
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2025 17:59:47.0938
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WiiyKdUBOBRvxCEqv3S1smNsqim3UknNZrPJPpSlTfDU7ss1npDr2RYUqoSFY5RR6G5OIkghr8Ck+tMTjYmw2rHUPdlldxcGbBAOSQY19js=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5147
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-28_04,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 bulkscore=0
 adultscore=0 mlxlogscore=999 spamscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2508280151
X-Proofpoint-ORIG-GUID: hL4O1qHn_UB_By6q-HsMp_neGp1F759l
X-Proofpoint-GUID: hL4O1qHn_UB_By6q-HsMp_neGp1F759l
X-Authority-Analysis: v=2.4 cv=EcXIQOmC c=1 sm=1 tr=0 ts=68b0991c b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=KKAkSRfTAAAA:8 a=CjxXgO3LAAAA:8
 a=3-RhneuVAAAA:8 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8 a=yANhqKo5vcweqC94BmkA:9
 a=CjuIK1q_8ugA:10 a=cvBusfyB2V15izCimMoJ:22 a=VLVLkjT_5ZicWzSuYqSo:22 cc=ntf
 awl=host:12069
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAzMCBTYWx0ZWRfX607QxTUu38Hs
 2C2cN0Dy1lW67Q/90U9c7AS7/brf6GuzQtTM5BMPQugqvIRccTd96/d1QuVon++C20U3i9adb0p
 8i3RnvANQmVjMe+hgPCNU3ialBiZ0Lyp4XcOpVhZYLSp2kbyMa0XEhAgxXIVp/zgrpvR6z+ChMn
 2kcWEmp98sO/yeW3VYL66d7PN9SzYiwptNoluY2uofVd2g7FtQ5utnaP5FjqiuMPSP0lwhIVR/6
 RbLi+GXiIhM+WLM7fmQRyXtEUHJ9wCuBlptTMt8aBZbdOY29X2MhMHSOeA7waNg3MmSBEVafszY
 LuCtew/e8FzEGbvFU5itb8z9Nw4VrW+wcuuABWKzyTDdYpJrOY5OAfFbo3PR2841rkJz5QKpUu0
 c4bhHS9fG0oFopFjybNQZErXF1zKFQ==

On Thu, Aug 28, 2025 at 12:01:32AM +0200, David Hildenbrand wrote:
> It's no longer required to use nth_page() when iterating pages within a
> single SG entry, so let's drop the nth_page() usage.
>
> Acked-by: Ulf Hansson <ulf.hansson@linaro.org>
> Cc: Alex Dubov <oakad@yahoo.com>
> Cc: Ulf Hansson <ulf.hansson@linaro.org>
> Cc: Jesper Nilsson <jesper.nilsson@axis.com>
> Cc: Lars Persson <lars.persson@axis.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>

LGTM, so:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

> ---
>  drivers/mmc/host/tifm_sd.c    | 4 ++--
>  drivers/mmc/host/usdhi6rol0.c | 4 ++--
>  2 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/mmc/host/tifm_sd.c b/drivers/mmc/host/tifm_sd.c
> index ac636efd911d3..2cd69c9e9571b 100644
> --- a/drivers/mmc/host/tifm_sd.c
> +++ b/drivers/mmc/host/tifm_sd.c
> @@ -191,7 +191,7 @@ static void tifm_sd_transfer_data(struct tifm_sd *host)
>  		}
>  		off = sg[host->sg_pos].offset + host->block_pos;
>
> -		pg = nth_page(sg_page(&sg[host->sg_pos]), off >> PAGE_SHIFT);
> +		pg = sg_page(&sg[host->sg_pos]) + (off >> PAGE_SHIFT);
>  		p_off = offset_in_page(off);
>  		p_cnt = PAGE_SIZE - p_off;
>  		p_cnt = min(p_cnt, cnt);
> @@ -240,7 +240,7 @@ static void tifm_sd_bounce_block(struct tifm_sd *host, struct mmc_data *r_data)
>  		}
>  		off = sg[host->sg_pos].offset + host->block_pos;
>
> -		pg = nth_page(sg_page(&sg[host->sg_pos]), off >> PAGE_SHIFT);
> +		pg = sg_page(&sg[host->sg_pos]) + (off >> PAGE_SHIFT);
>  		p_off = offset_in_page(off);
>  		p_cnt = PAGE_SIZE - p_off;
>  		p_cnt = min(p_cnt, cnt);
> diff --git a/drivers/mmc/host/usdhi6rol0.c b/drivers/mmc/host/usdhi6rol0.c
> index 85b49c07918b3..3bccf800339ba 100644
> --- a/drivers/mmc/host/usdhi6rol0.c
> +++ b/drivers/mmc/host/usdhi6rol0.c
> @@ -323,7 +323,7 @@ static void usdhi6_blk_bounce(struct usdhi6_host *host,
>
>  	host->head_pg.page	= host->pg.page;
>  	host->head_pg.mapped	= host->pg.mapped;
> -	host->pg.page		= nth_page(host->pg.page, 1);
> +	host->pg.page		= host->pg.page + 1;
>  	host->pg.mapped		= kmap(host->pg.page);
>
>  	host->blk_page = host->bounce_buf;
> @@ -503,7 +503,7 @@ static void usdhi6_sg_advance(struct usdhi6_host *host)
>  	/* We cannot get here after crossing a page border */
>
>  	/* Next page in the same SG */
> -	host->pg.page = nth_page(sg_page(host->sg), host->page_idx);
> +	host->pg.page = sg_page(host->sg) + host->page_idx;
>  	host->pg.mapped = kmap(host->pg.page);
>  	host->blk_page = host->pg.mapped;
>
> --
> 2.50.1
>

