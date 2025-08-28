Return-Path: <io-uring+bounces-9401-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EF262B3A2E6
	for <lists+io-uring@lfdr.de>; Thu, 28 Aug 2025 16:57:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 567511C83FE5
	for <lists+io-uring@lfdr.de>; Thu, 28 Aug 2025 14:57:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F17803164A2;
	Thu, 28 Aug 2025 14:55:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="oJl7cT+d";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="KFAF+g5e"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EFC431577D;
	Thu, 28 Aug 2025 14:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756392951; cv=fail; b=CgZ7Y6SF18lk5sNypJZ8vM3q8SLFakNolTIl7SKfJBcIndPW1hfFp7W6YGSjGqLoCPGqL2r3DTk9NEikRS6WZlDXgCkZFxVG0BQSgLq/RDGRWRbLef5UyG+RiNgrl6cXrx3hYPx+ApPbjmmF3nnw2M1hp+7Na7YPtWQbWetQ+VI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756392951; c=relaxed/simple;
	bh=INvOmSnZmMjtrv7TwrMknxSFZawokDXCn26VegzIyQ8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=kS9SowHjEY9vj4qR3gUPDk7gG9jtB+RunVjyGp6c6UNFLdUVceUfmrqo6DKlYu40H126eTK8aQDjyKPsXQ+rghWsMuULb0ykvGNwRl0YLWR44gQ4hBez/clRXGxIldt7LAwYw45gKY/3HN5z/Pm+hmmMj1MsRdTsUeI8owbwL2I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=oJl7cT+d; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=KFAF+g5e; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57SEN2Tn029807;
	Thu, 28 Aug 2025 14:55:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=ZpC58Tw8w9aBvYs96E
	dXoLVscSFIyT6HH1Qh3l1zYp4=; b=oJl7cT+dz1Px7I2INLrSUf09//QYreDPod
	nQImdEvVpTiKQ/D9Ss121GThhCeS3S5vz2N+FuS1WszdQVrS4xq98NQFqq3iLNth
	sTdaqtoUk/AreWwqp8f/4WntR5RKdP4YX0pwpH2F7borKCwF1A3qg4a8xLeUboM8
	A1ssVRoXksRabZQsQg5ou7TJr2L3q5UyCuvVRZW7pL+JN8X9BxsQGEcuKTvTp7+s
	BzKzGAbYBdUFS8CAE7/JnAvIxYkNnxCERJmgI5NbhIEMt56TSHX+lodmTyM7jUGF
	26y63+Wk3J38h2rhNlFDe/Dd4F0MUhwkrAS9Q/dIcsiPxI8vayDA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48q5pt8v2h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Aug 2025 14:55:14 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57SDWNB8005033;
	Thu, 28 Aug 2025 14:55:14 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12on2047.outbound.protection.outlook.com [40.107.244.47])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48qj8c82d0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Aug 2025 14:55:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EeDNzNGk/nnxc49T0TFxKGMGxHMnUodybS9Qh3Md+4gfo4ymhF9zL8VukxdRbOC4FUa79STQKn9HcVLfDxe5boJsHtzefCIGweF10s6xVZk8gax6vKTuoah5ftZ19iYAOr3Ch3hy0shESDBzbCUlnH61/VkC9pHck5xYwVXcPyxjpHe7Wnysy5BjBpAjT/1FKSm6rg/fuzY7la5MxCCEnSt8NPO2askICGIu76trZr+hhNd6n5sAaWUaUEZVYCciNSBNy9K4cbtrI82fal1wulgrXGAxu1gHUTSVjPBK35ZM+bz4MQBU5IRvZyOzoRyfrVZkm3BA6xbgfX5AVcoM4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZpC58Tw8w9aBvYs96EdXoLVscSFIyT6HH1Qh3l1zYp4=;
 b=XnPGGGkZt//PyFEZEdXUDLDqlXXrWTyw4fjzQFRwdKSpSLRYfET8kJAI6Xh8BujmraQn31VzAZSXYAfNCa6hhTirfgKkcX9VzT6fad6DtHq5UTZ9JprMLPJkP3k1XEsrG0UpHqKL79z5DU9dm/M2KkPFkhlpgQWeK9lTMRrMSeJkCp8/Yllqfk0Y8PQ0K3+Vf4itV9BrzoKdOGvGL7Jubk7PoaLmbPw3QzaOM+y0qS69ig769RudBxSrc01bXNrIVLSyGRCiQWKYWeOGJOsguOVqup62L9Xzm68DhJtg94LxbblWXQA7icEDdkYMkmq7U9AfSxP33xnptUdLK1PVLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZpC58Tw8w9aBvYs96EdXoLVscSFIyT6HH1Qh3l1zYp4=;
 b=KFAF+g5eeW3cNmxFEDNyYHJQZXoE9lxUoUyxYdbqkNRMS7ZwTR33UWzTyYLfPgppEh63optrIn+t5MyJA2oR130UYR8pqDlTdOyAzqBE6T9A638eDeoM2UX6M5KtDsodwPqg3cvRS8KIJPNcM5VkxU/ovaLuqBoRkjr5v0FuZSU=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by MN6PR10MB8071.namprd10.prod.outlook.com (2603:10b6:208:4ef::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.21; Thu, 28 Aug
 2025 14:55:05 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9052.019; Thu, 28 Aug 2025
 14:55:05 +0000
Date: Thu, 28 Aug 2025 15:54:57 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org,
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
        wireguard@lists.zx2c4.com, x86@kernel.org, Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH v1 09/36] mm/mm_init: make memmap_init_compound() look
 more like prep_compound_page()
Message-ID: <a1ea7621-6791-4075-91e1-7cff372ffdd0@lucifer.local>
References: <20250827220141.262669-1-david@redhat.com>
 <20250827220141.262669-10-david@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250827220141.262669-10-david@redhat.com>
X-ClientProxiedBy: LO4P123CA0094.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:191::9) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|MN6PR10MB8071:EE_
X-MS-Office365-Filtering-Correlation-Id: 4d467589-2662-44b7-0bf8-08dde642dff1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?YNvnxXtcOuyhW/p54G5ItHgg/3WFtr7B8C+1rSC2FzVIHExCTmq3LPlXMLWL?=
 =?us-ascii?Q?Z7ccg+nEJExyYqhfpLWPb9PLKnM+z9H1kJfLIXfr7fpS5VDs8cMw0jhnec5z?=
 =?us-ascii?Q?kgRE9W7b6nIFcAry59ENkVB7QYMnK7CZOhu345S8JXtFNGfmva/rR1zcNVI/?=
 =?us-ascii?Q?+HpEi7NwaFluMjnCz4obP3V2COnt+HOOUm3OVY/xy5aIcmam3TVismOXoBza?=
 =?us-ascii?Q?8nssm3S8rZ+/Cdw1++oNul2+Y5K8sozaOBLWqF11SKWEubPdlEsz3fjWXdT5?=
 =?us-ascii?Q?isUSAoktVeeZlhYkg7GM9YG+PXfRR3Gc5UWkl6sI7YKJZMyCQUrAL1YpNU2m?=
 =?us-ascii?Q?6aWcWLxQBlCG7nvDMf1XHeKTiJTJtvaqXEhYHN2IkZ/7dsRHkGY1UdRc3C26?=
 =?us-ascii?Q?mOwbOQSjLZO5ch8h6QGeBzJE4P+78mbc1Hi+uXhTQ6tBKhsLfiJXjeXw90WH?=
 =?us-ascii?Q?aL+X3vPgsyXfl8FEC3rr9njdzO8C4BW2EG2DthmZriFpTf8dmPG7rgS0XqpI?=
 =?us-ascii?Q?JYdzs1h3Y2INjLdVWy44mqcFOPS18f41QEpZHHPIWzKgcrA+Fq5yqNnvo+qB?=
 =?us-ascii?Q?+9fn2ccatjyDJ/yKlIFZGAhqpbe+bkpnrpuERmlwSSTjkzVmjd7u3wqGxd0O?=
 =?us-ascii?Q?ort+x+fHiNLWeKf7m45ZmI6ApQei0YYY7XDWZnW+BozjBzQ6L6m6BJRXZrZ7?=
 =?us-ascii?Q?1pZ1Awa0TJKAs4h9s72jJI8YlwyPeNbhu2Sl/HVke09QBSkDZx3iMOEJxQyj?=
 =?us-ascii?Q?wjmhYVjdPwDKJp12P9FL8iko4q7uQWL6e4zpEExj2OlEf0K5Kv91RbrW5xLO?=
 =?us-ascii?Q?aNfIKFgwo6Y9RFDWaLIIIXPJfDn55qUXSg3/Wnf1wwzzXY7kyXn230CP9J9N?=
 =?us-ascii?Q?yLRsYV+jBP3CfZjN4cMdAr/xWCQPswp/iKlTeHKP0NTmgNk+TTIvryMbHCIP?=
 =?us-ascii?Q?QMwvto6SwMfsXNoVDQJDdFMZqwzheGBbC2kawpf/j8lGDH1OZftwD9DYx8U0?=
 =?us-ascii?Q?enz07a+jHecr60hA7iDWxdFK0agCGJTblJBBERC4KI4SOuK34rOsyBFc2lq0?=
 =?us-ascii?Q?ouVwR++soE2eHs0iuv09u84OXP/qrDvSvtFWgn14ZD2uDgEEqyiSrjPmsEKc?=
 =?us-ascii?Q?hAP5iRhkgQ72psdWaMbkf/thncA6BUthKkWlJIqXQGvnGqEFRvFfeh+MUC2T?=
 =?us-ascii?Q?ozL2B0LbqLqS/yhFv517JJKJtCsuPoentgKogWHvsVGTLBzNZMActFK3wESG?=
 =?us-ascii?Q?v7tpt1QK8RBOiveSi/8hq/IR6jdsR6qLVSa6IsUp9JcBmegLG0ggRZIWb8rm?=
 =?us-ascii?Q?9LSoy3Z6A5xAM2QvcyBcj5ex5JbDinV+mnve6uq2tnOxT6vAYd8ArR6QiJXv?=
 =?us-ascii?Q?g+Wm31SOPMo/gcvUxZO2XvnxC7Mu34hJboLiSiCoqXkzRKMKmbP5mL2JO0nt?=
 =?us-ascii?Q?ETHBzkFKlBs=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?YqYtCEWBHUuuEWu+iRe5nBHyfTSGBNINaJVwXzuSmvW+RJyF+fO+E6Xj3qCn?=
 =?us-ascii?Q?9BB5eyXkpBUsUvVfuVsePqsAbwZ5OZOiUukffyUfFTh7KE264E1TOsWCP+bp?=
 =?us-ascii?Q?fzOxFg7M0hB9PvVpM875WH5FW3/5SQveb2ptWyDe/9b2ExXS5twdtg+ZyS+a?=
 =?us-ascii?Q?E3ws+h1qq+/9GZBK9FUCjkO22fCW6JCZEA3iUXNaILkjEjJYF/EO9FV34Vjp?=
 =?us-ascii?Q?9myAwzKiDHj0WTe/ROVRs1Q202bJx/DS/XUNvF2hFqcaDY/f/cheqd2MX+N8?=
 =?us-ascii?Q?SIkQpGqA0re3qUKFRWuECeyG3qvR/wso3mA8hlWarIiAoaIh044K0aB+6wp0?=
 =?us-ascii?Q?GVvMjfzAdtzrf77eeNpfB37tJbse9FQq7EU1gKFLr5b8k1ZG6x380sSoWZee?=
 =?us-ascii?Q?ftQln2WzstPMaTEw89R6rnrSo1sMqebebU3imr2dodw9g0rl7f/tNs4zLPrf?=
 =?us-ascii?Q?TGX0jikXrlspbWU3uTacEY4dT+grmaSRlVBxa0dvgHd4lF0a49PyGKftuv/K?=
 =?us-ascii?Q?HpqVtNnqjq87aG6A5SU4iVBUDLcAPdI5fK8L/9PTOCyRuu0kHRvL5q5tGrXz?=
 =?us-ascii?Q?sSEJL7VDEBKn/4lRpQwheGSbHE5LzLMiKqop+BCKpXBzDeBtucywjrx3lBqt?=
 =?us-ascii?Q?AOKDf2+Y9rcmHBs4Ygv2rVME80+mwOlQ+9RZNr0a1RULGn+Tix2+gN9uqABA?=
 =?us-ascii?Q?e+gx6CVcd9Q5rxbGlS2VY4tsHaDDaq91QRx6ZWtniu/H8xOLA6RI05c2cGU+?=
 =?us-ascii?Q?wLxMbja9J2EuxJwRETc2lK+VLZifAhrAoa3hn9fVFSlMB+5r1Y4c4Kss0agE?=
 =?us-ascii?Q?7SdYOBjpvGoJAhW6KmMSvifqji0D0E7clxrL4nhJwvNg54209yMwd4MJ9ovB?=
 =?us-ascii?Q?JNfQlY+uFDl4s3EVR46OxdUaA/aXwOk82Uo+VrRtwlGRRJ59GTidUOqtYRvI?=
 =?us-ascii?Q?JQ20g1fs6b7kLOn+WwysAytK9CXbdu1/7Y5jOhcZXrWZxMVHZ6nfhDlq80aw?=
 =?us-ascii?Q?yHZ9DxL1OyVuoqf2Erzrv6Z+ZDxPYY7RjDT6X0Fh2bt7BmN9GRFa4QfNi+wj?=
 =?us-ascii?Q?2dGex7lay2XlWt55J7J+o55yUUf+D6KAKfjM4PrCbqmVjM9am3gMsfJucqxw?=
 =?us-ascii?Q?MPM7VJRCUMqDNuQHP3tgyDHK4VlGB7wgbq4AaiyI0V1xNMlp873IQPfijTKH?=
 =?us-ascii?Q?afq4UcL4jShX3aUFceW5d8yqLmhGA7Fi+o4TXPthteeDwwU3E/mAmjA7Ug22?=
 =?us-ascii?Q?bTzkErBvRCY/5GSjUwkW1pulcD49DE503H9NyullmhAnWaSyrnH1AQAbzUir?=
 =?us-ascii?Q?CStsTEOFlnQgRB7x6tx/HKUv2HQrRNw1f0awBE/uBlmll8qSTYSlc9iaO5r6?=
 =?us-ascii?Q?KLw4uSSvbaeSbPP9tKxEI1j+YaDMmUDPTQhlRWrVs245t9ej8PUaJFwGxZkh?=
 =?us-ascii?Q?mcnllhSjtDhP9jHnl6oUjfMQJlhLGpcT5yj30mKbdl5Fps3KXqmPKXJ9aEEg?=
 =?us-ascii?Q?phHeQgep7tRwQT570vKBZJ1021D3GvWGt2CimiyAPO+ZI4Yvxz6rS62h118y?=
 =?us-ascii?Q?XrwqqdQcjoNdU0hXdcYQUofz8z9wFPLsqiKf/MrcedA9bNNN0/mGGLgEp9VU?=
 =?us-ascii?Q?xg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Vxyc0It8LgbzQNgCzhAaJQJpy0nkKiy0SDFHQRcso5fw905GmeHnZsgOhlW4nJurQfQRwqR5fxh+4BSDehKhIoJgRjp8FDlDI10eMKsqT3fJtEYGsiRqcgQ8SrZgSnEO6zTP6el0NyOtRK7LvD1q1x1wuqHvBrfPgKRs9IscWbipfZ6IQ5vtiKpB+eVpOVtLsGZ21TKzOcL3PPzuuuOzcv1TTvpAQLr4rSXOMld2esJrLH+f14MyejHMNpPtdLiSDTE7PKaZ2QyklDjxxF9BJ2gK5q+N283ro1VGtvxf9vMplscWLzJo5ohdd0m6S+Rel7ISz6Bbk5U1WHKo+mMrA1h/jDkb5h9Qr0IgaTBNlsJO48Qu0r7KfzucGxYSc8AHqgF43qtuTrqoxJguuiHUDY6/B9eCHgNJ04XKTJNIZ6bIEJcT4Q8mcNRTh8nnD/Fb1Qb11MTZc2u4/xYO5+UuJdsemK7h0FdCqtZxABeGVA1UNsR8LBobKOZiri+R6HbPcPmYlv0qxWXlK3EB+N8XWEmqgmhiusp/XR3BceP/WACkacodggYCPxltNUcamuiP9O7+ldbPKCP1Aku/57Y9VAjP8S4ycoba9MUbcPMxqoI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d467589-2662-44b7-0bf8-08dde642dff1
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2025 14:55:05.6455
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sJHC+nWnTZe2rlMgksqHg87xJmTN4H+5OR8UwPKPkdhAV8lRIGo6i9w16xZCrp5phKye5ob7SgavNDnyYz3qva99/CcirltVmDags6vqjM0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR10MB8071
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-28_04,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 spamscore=0
 phishscore=0 bulkscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2508280125
X-Proofpoint-ORIG-GUID: fC1-RTBglQPxmorE2TRXX_ZoC697qOiW
X-Proofpoint-GUID: fC1-RTBglQPxmorE2TRXX_ZoC697qOiW
X-Authority-Analysis: v=2.4 cv=EcXIQOmC c=1 sm=1 tr=0 ts=68b06dd2 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
 a=yPCof4ZbAAAA:8 a=MUwqMjFMAyFyvTEu_WwA:9 a=CjuIK1q_8ugA:10 cc=ntf
 awl=host:12068
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAzMCBTYWx0ZWRfX6fMn6lRmFXm/
 SxaQ13VNe2Y0yrIHJ9wvnzzX0OumKVEjdulsBICgKr/z4MsiY3KjjP+AaXbwpZcwCeJgoVH1ANa
 0ZuqfrgNI0sZf8O8xcv51yWJSQH6QUFozqkVgY6bjArJ+vblRtqq/2ltdx5RRmtPdN/2DUzxRu6
 dUuClUdUsfijO1z7O/6L8zf/aRLbGzCz85fqE/dYRoRJ6sKPP94jyk1ypzqSH6WqyCoCOPA+CuA
 0onbsPheGVjxYumJKJh3AzTmw2+ev89Zp4qGlEwAKwq75GndboYL8HJ2/AIceIIEDm+2OqKP/mE
 6mfphgVPTlk+vzuypMNP5nvvnJrsefqvgo1KwUUuAN1djbsqhFtTwhbYPk31LG6YZHLG++0Z90u
 nSX0oiX/dYWqRqTocxbnkIZW9wWz/Q==

On Thu, Aug 28, 2025 at 12:01:13AM +0200, David Hildenbrand wrote:
> Grepping for "prep_compound_page" leaves on clueless how devdax gets its
> compound pages initialized.
>
> Let's add a comment that might help finding this open-coded
> prep_compound_page() initialization more easily.
>
> Further, let's be less smart about the ordering of initialization and just
> perform the prep_compound_head() call after all tail pages were
> initialized: just like prep_compound_page() does.
>
> No need for a comment to describe the initialization order: again,
> just like prep_compound_page().

Wow this is great, thank you for putting a quality comment for this and
thinking of this :)

We have too much 'special case you just have to know' stuff sitting around,
so this kind of thing is always great to see.

>
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Signed-off-by: David Hildenbrand <david@redhat.com>

LGTM, so:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

> ---
>  mm/mm_init.c | 15 +++++++--------
>  1 file changed, 7 insertions(+), 8 deletions(-)
>
> diff --git a/mm/mm_init.c b/mm/mm_init.c
> index 5c21b3af216b2..df614556741a4 100644
> --- a/mm/mm_init.c
> +++ b/mm/mm_init.c
> @@ -1091,6 +1091,12 @@ static void __ref memmap_init_compound(struct page *head,
>  	unsigned long pfn, end_pfn = head_pfn + nr_pages;
>  	unsigned int order = pgmap->vmemmap_shift;
>
> +	/*
> +	 * We have to initialize the pages, including setting up page links.
> +	 * prep_compound_page() does not take care of that, so instead we
> +	 * open-code prep_compound_page() so we can take care of initializing
> +	 * the pages in the same go.
> +	 */
>  	__SetPageHead(head);
>  	for (pfn = head_pfn + 1; pfn < end_pfn; pfn++) {
>  		struct page *page = pfn_to_page(pfn);
> @@ -1098,15 +1104,8 @@ static void __ref memmap_init_compound(struct page *head,
>  		__init_zone_device_page(page, pfn, zone_idx, nid, pgmap);
>  		prep_compound_tail(head, pfn - head_pfn);
>  		set_page_count(page, 0);
> -
> -		/*
> -		 * The first tail page stores important compound page info.
> -		 * Call prep_compound_head() after the first tail page has
> -		 * been initialized, to not have the data overwritten.
> -		 */
> -		if (pfn == head_pfn + 1)
> -			prep_compound_head(head, order);
>  	}
> +	prep_compound_head(head, order);
>  }
>
>  void __ref memmap_init_zone_device(struct zone *zone,
> --
> 2.50.1
>

