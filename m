Return-Path: <io-uring+bounces-630-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E3A6C85A42A
	for <lists+io-uring@lfdr.de>; Mon, 19 Feb 2024 14:04:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5C07B1F20613
	for <lists+io-uring@lfdr.de>; Mon, 19 Feb 2024 13:04:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC4F439AF9;
	Mon, 19 Feb 2024 13:02:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NWoYR8ya";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="d/nzw7aI"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ED32383A6;
	Mon, 19 Feb 2024 13:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708347768; cv=fail; b=Uaw3nW2s75DT8ztiYLpjgcb9wT32ACZWj1mRwTYuit7GbhJ1kX+SNlbeW+79OfrJOzBOqlG0pSENs1Y/5zaF0tHTATqwo7G0petF6/o/jfZBFoMb8/5mD7gh99mYYkBirEqftBhROD3729St1Og/RDduhD+qNgi0ONj8G9T3dDk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708347768; c=relaxed/simple;
	bh=uT+Cfio807eeLInUynlSjGeeEzH9oz2qyfwW6Xyf65o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=J0gc9EygehRjGttmbnO0XVVTopAvR2rlkmi+OlpzHYUWXflD4YOCPi/FZBZtQoTO6LeeIuD/c2pu0h1FpuAj59krBbJ1g7JszoorYHw46q6QKT73jH8bwNez6IkSUVTNpplUQOT8491x6Z/LRMxLLghz7/P9SGcSK75rD61q/zo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=NWoYR8ya; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=d/nzw7aI; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 41J8OAVe022474;
	Mon, 19 Feb 2024 13:01:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-11-20; bh=2z/8eSSYabRkF+uqNk0U/lhIklmfGyq2q8zki9qeB9k=;
 b=NWoYR8yabiql00PLH9af0yAMNnFUYFB9M7wDgrz9J1DjRZlrTW9aIjYxKgmz5NBSBKDI
 Grgt41VazNfYcxcwQ7mjTCUDQsA00Exy+ZH0KBZuFDFGlT5ZFvwRAkiCiRt5IG+IGAxU
 qWdB3lkTPC7hMfZEz/ZZjw1GpD+TXWvzyb2T4Qt6B/u9kSvDJay+Mc8ZKF6H0B4SHAAU
 DtF0DzikNX6WiCYscZKHlAxYpULBS44I4flBe2POvJ6dMT5EgluHsvMrFwEiQRhUlwZB
 Zb9r+vW03OUbyLxKA/xwi+EV51eNnnsF57nEBEA90N2wBEvLW4ys5BumuGaweXZkh+Yn FQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3wamdtv3bx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 19 Feb 2024 13:01:50 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 41JCPHxg013054;
	Mon, 19 Feb 2024 13:01:49 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3wak85vtss-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 19 Feb 2024 13:01:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S4oA2C00Ge9fVZVI0zscgSrEhruT/yAUoSxMz4wMraiMPrTILUOyF5AqMLWgTY8SfpH42RsU9GZlifYVvdhSbo3bwiefXAJXVRQxjfeI6n51zbMuh7UClAx7U3N1v9U0HXSQlOMQhoCDO6ZsJB4H7BpCcBQevHd4C7TBbGXsy/FdHOouyQ+aPYS7OJLnkD/LoFjq+Ejpg5/JwyJHZlQGrcsBq8BwTtsgouLL8B5sNcQmxvx11ujRYcBIQWaYIkM0QG7AoAAqhUYRQg8zNJrlgdRsB/0waJBkOYPGpcavtxD3oMH7TMTYnbY/OL8iZiHJMZhe/xo0yLlSGGL19/27xA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2z/8eSSYabRkF+uqNk0U/lhIklmfGyq2q8zki9qeB9k=;
 b=nUlvkAMxUZiffBMoPYOgEYTcrg4IHSdejciIpUJnWDQql7TMnBQazK5KqbVMu7pj7Pf3ttTNsY3vSJwc4tJD3Jdl2el2A9NV3Z1VP44yBEoqHVrqHamRON3RDkHbUrJ0+GH9FmM2XMecKzHpLTR6tcZG8HKK82p+nTVDjJoPl3iq6Wt8RspyWDLKTXmWbkzZwJlmBAAbCabkbGYTdscHIgzIu4WBkTFRbStq2gFawPXExJknITODrYQAXXeIk/9e78Erfsm1cjx0vtUStvw3gm3R1J/xHyICUIqCl5H+bjrgg3SyxWELsqtYzfvtvcAl0yUvL+rLWYjezyzZAF2eNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2z/8eSSYabRkF+uqNk0U/lhIklmfGyq2q8zki9qeB9k=;
 b=d/nzw7aI7qnIHls7+O/ulx6u/OQh8ICSD3aGHfNlNnfJ7nqODx+dFAAvqOZCqPkMe5DHtebDqy2K/8v6m6QIsmWhF0PePT9G40Bc4wBhhmibvlqrOIKHbZd3v8Rjh1p6oq6XWoLEee4e/eUURQ8HXGzu1WXIMAovv0574IAN00Q=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DS0PR10MB6894.namprd10.prod.outlook.com (2603:10b6:8:134::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.38; Mon, 19 Feb
 2024 13:01:46 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::56f9:2210:db18:61c4]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::56f9:2210:db18:61c4%4]) with mapi id 15.20.7292.036; Mon, 19 Feb 2024
 13:01:46 +0000
From: John Garry <john.g.garry@oracle.com>
To: axboe@kernel.dk, kbusch@kernel.org, hch@lst.de, sagi@grimberg.me,
        jejb@linux.ibm.com, martin.petersen@oracle.com, djwong@kernel.org,
        viro@zeniv.linux.org.uk, brauner@kernel.org, dchinner@redhat.com,
        jack@suse.cz
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        tytso@mit.edu, jbongio@google.com, linux-scsi@vger.kernel.org,
        ojaswin@linux.ibm.com, linux-aio@kvack.org,
        linux-btrfs@vger.kernel.org, io-uring@vger.kernel.org,
        nilay@linux.ibm.com, ritesh.list@gmail.com,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v4 07/11] block: Add fops atomic write support
Date: Mon, 19 Feb 2024 13:01:05 +0000
Message-Id: <20240219130109.341523-8-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240219130109.341523-1-john.g.garry@oracle.com>
References: <20240219130109.341523-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0289.namprd03.prod.outlook.com
 (2603:10b6:a03:39e::24) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DS0PR10MB6894:EE_
X-MS-Office365-Filtering-Correlation-Id: d5a34c4a-6fe7-4ef6-d1ff-08dc314aeda6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	YLp7VDbt4QAW2a8l46UXG5wa3FRIAqtrRisaNDAw00a1gCSwiSfk33g3zro5WufBy8j2az0GUELKw9iZ0WrGlrdz7F9ebBv9pys0ZtouTjbYSiwIAG2JBg0hVXhqH4RoUQWDjaFK7gbrKCkT61FDcai7lQhKzaQDuxCJmzq3HkW6lmJsy74z6uOnFSd+7Vh9wO9OQqCutkDAqFppBbLGtmaxq0prfRqnBWHfgefjVYXxLo4D0EOPyt0RSuTp5ti6jFU2vr5/RFAfP8YJyGavs0ljdwbAuGklHmlXXQHwApdt2/HY3KV+dNcxkdYD3XxT9rBorSd49PX2uQxA8XAsOgteqjl07P/CxbDF/LQBPfbJYPFp6gQf3ToU5taBixZH9Edj636EBpBPMz0wuYwf+0tcs2ZAT6UbrcuxNFPHomNpWlelRkg6vS0Su6vWRx5De/DCBl5tvkjfgXxEWy9MADeEDAjDQpjb4qFZPIyklw97ZUvE2SCKSgVtbVN4r45YADTMqiT5DGUyS8ev2fv8vbin5ifKDQstovAPPG4HpB5TmPGIb+DzPvi43IIyYiZysEetDtDRP+osiIXaRZ0RKUjN4cO8rnF74IZrXTQc6tc=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(921011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?SEfco3GNnYVYKg9fflKq5HK12KZ+NwVCOQ7LfEDcCa+Rvw7eFhx+DbSeYBhc?=
 =?us-ascii?Q?W565ODdCBwfT8A6BCEPmCYwOci4K6BsFXJ4rSp/tdcDqCGV40KP6xrS3hD2Z?=
 =?us-ascii?Q?je3qjGd7E5lBFh8oJ3fg5lK3owALv7ZM50bxGZilkHjWh5ywuEqtWMFndZ7R?=
 =?us-ascii?Q?OC5HMZcQjLgD8tjxOr3u/THxl3X+VwoZIfcE305LZr7l+E+jyUerO4PKv+gr?=
 =?us-ascii?Q?Nt/A0cBdZ/4j44qi8kVdbXBZ9V6E4DveWoRprYVo8Rof+ui7CHEfgov5TO0v?=
 =?us-ascii?Q?c9bpdkIYG4wDbTCaxfMEEqoihkUvtqql9cEb/ZO43ECA7zZiHU4sC/iJ9u5S?=
 =?us-ascii?Q?r4Z+r3GktcsQ9IafnpfSRjNiKuBJnuvf3SFpe4qPi5ZumtAsGW6h3+S61Cua?=
 =?us-ascii?Q?yO7Teaz6RQKXhA9YblkfbXO85zSK1kyRPaTswQVoJ3kNBwo6dyZZE/7GSzh1?=
 =?us-ascii?Q?E8evc6/l6gTTotHjB9ox0WiqENsOYzhry66fVjLRPf9xRX8oZULxIoZDYbsl?=
 =?us-ascii?Q?gmjeqR3wtaG5RqxN9qOdVQqXAXkbgqkUxX7igZq5DsDdW3Q2UtL+TejH7ADX?=
 =?us-ascii?Q?xgAyB3yA4gmNOn+EpDwl02pZ7mK18W/Hg1jE80DxTyLFytX2H5hEZNhED4M3?=
 =?us-ascii?Q?snSiHEOUJU6uWCV7Q+cRDVMBaFL68pJpnoztF0E9V91FXqWmx3JDgtBWbxe0?=
 =?us-ascii?Q?sqKaPYDjPWnv3giOhEv9FCKBjRrN8Vzedkls5g/Es8m+hByQm4Q7FwDCf6DM?=
 =?us-ascii?Q?oliup92YNHs77PPE0kHNAr0L2aODN6TD92QAFwo3P/w3n3Mj3ZhyBwa9Brv1?=
 =?us-ascii?Q?oqWm1XzVpwevmJ2+M0gNGfYmjfvNH5E05uDSjkLjzHr9EMTk0wLLafpZPCxh?=
 =?us-ascii?Q?NodyAxWiUMZLLO28wir1IYmvhRHGqORIRFMzRPv+QlnEVaPfzIJ2sMSnDTOh?=
 =?us-ascii?Q?VsCi2W4sl4PVjPU6dwAuBj4FwPdpy9/dHPPENie/5rDJ4SFWKlV0c+JpmRqH?=
 =?us-ascii?Q?nhoK0g1zxoJ5dRO72r1pFVWmFCIJQHD441rCjm8x5GNxkv2i9gCF4XrZ0bsX?=
 =?us-ascii?Q?JlETvIC/J/fjT52xoFAoQklQRFB/w2HVMIZdFZg3SmRpN5DrG+SaID+bUKLu?=
 =?us-ascii?Q?GzjlGlBu1JQPodFNwnh9kmqQqnhAaxe8NkZLIoeOZMAqX0PlDPd+a8v4Zy+Y?=
 =?us-ascii?Q?mYjH6vRMGcIeoPBEgO/Vd/qnIhflkNMtrK1YzNUCuNpv3KO/Hvlx7/mwTBlQ?=
 =?us-ascii?Q?8yGZGwjAELyhg632UGRXi2EpQnZfUVWtEs2ec8ST7vvOFj8vQ6S1MOabWk3r?=
 =?us-ascii?Q?jNqLXm6JLZyUYzd+0Zb4z87+H3aOMtzB2mObngYSw0P9ufdOTeR68Y/VZq1x?=
 =?us-ascii?Q?sp2KzowYIRr6sOcsxkaXs2lrvnPkk0GMyVulExBQava51iJao4jGyKXtSI3N?=
 =?us-ascii?Q?mywYS5cXZDBdt1oQnLEabNT4blWwE0vgSsQKmd4UUcle48SCfCjjO1btr8bf?=
 =?us-ascii?Q?8rKTgIsY1F5RGK6fzb8fl5TSViBB3gXtfCtgJ92+NEClcLVJfW2HWBE6y7IV?=
 =?us-ascii?Q?MQqgMv34LZiN9DrzD08BGsnsp6qq+UtFalc7Rfk8ggc8QwdwBGwfqZ9qmm1V?=
 =?us-ascii?Q?hA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	z9ftk0wB79MKBJSJeN1YTUyOvM8zEEoLyadd1BOmR/95mn1eMcnAj+4j1K2QtWvLOa26wko4ux07OMZoqoYKHItdAZncgau7yEcFv5CukTbH9jchlAuMLQf1p4GAIM3l7iuCb2YPtQA3rWKK9iG7XGHAryoNGGo9EvDoNS/kTQM6IigT+S82kwoCq2MJbBWbJj4z3gC6W333otRqKz+j2/3CfVXOnDuPAV0wAwgE/kGLEnMK+BQdL++QI69HuSGPs1+g4Xyzf7w+C4nedSXglAElsIV+/ggOnPxSFXXZ2eOyQhZUgP1an6TMB8V2HSMyvDJyJ4B5h9hb7yBvTQKyhyH7Ii8MPCSo808hs29BF2DA4LmnLTm/ZJcjmpMu/PQW1JnbavG+MtJrb0fbG/MVq3q4Kh8xW71pcW0/At+G0dGc4n9kHwyPAyAoSa27l3m0T7ktFzgUYkernwnmOcdfyTXncKRaanyRKIzywQS86XJGq9o0tUNaCRgluLWeuQF8e4k+1JM1IjKyqmrQ9GnjeDBIAsoOp5p/ZGzH5+MxFEprQhRSRZ+gjMSVxK0gE8c1VENcVifqPt9O34x8KNoaiZkPgRdg9gljMfP7mFv/Pxk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5a34c4a-6fe7-4ef6-d1ff-08dc314aeda6
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2024 13:01:46.5694
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aRmnCAcJWs6PrPwyjKfGdIFlU/2QTkBTDnzJSheI2x8lHgKLw50/D/IteU9xnLs9bm6X4/AmkoMqfbC9SAkzSQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6894
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-19_09,2024-02-19_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 mlxscore=0 mlxlogscore=999 adultscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2402190096
X-Proofpoint-GUID: n2dauEaZCTSIuI2_iot595EEUVaHbAT-
X-Proofpoint-ORIG-GUID: n2dauEaZCTSIuI2_iot595EEUVaHbAT-

Support atomic writes by submitting a single BIO with the REQ_ATOMIC set.

It must be ensured that the atomic write adheres to its rules, like
naturally aligned offset, so call blkdev_dio_invalid() ->
blkdev_atomic_write_valid() [with renaming blkdev_dio_unaligned() to
blkdev_dio_invalid()] for this purpose.

In blkdev_direct_IO(), if the nr_pages exceeds BIO_MAX_VECS, then we cannot
produce a single BIO, so error in this case.

Finally set FMODE_CAN_ATOMIC_WRITE when the bdev can support atomic writes
and the associated file flag is for O_DIRECT.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 block/fops.c | 31 ++++++++++++++++++++++++++++---
 1 file changed, 28 insertions(+), 3 deletions(-)

diff --git a/block/fops.c b/block/fops.c
index 28382b4d097a..563189c2fc5a 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -34,13 +34,27 @@ static blk_opf_t dio_bio_write_op(struct kiocb *iocb)
 	return opf;
 }
 
-static bool blkdev_dio_unaligned(struct block_device *bdev, loff_t pos,
-			      struct iov_iter *iter)
+static bool blkdev_atomic_write_valid(struct block_device *bdev, loff_t pos,
+				      struct iov_iter *iter)
 {
+	struct request_queue *q = bdev_get_queue(bdev);
+	unsigned int min_bytes = queue_atomic_write_unit_min_bytes(q);
+	unsigned int max_bytes = queue_atomic_write_unit_max_bytes(q);
+
+	return atomic_write_valid(pos, iter, min_bytes, max_bytes);
+}
+
+static bool blkdev_dio_invalid(struct block_device *bdev, loff_t pos,
+				struct iov_iter *iter, bool atomic_write)
+{
+	if (atomic_write && !blkdev_atomic_write_valid(bdev, pos, iter))
+		return true;
+
 	return pos & (bdev_logical_block_size(bdev) - 1) ||
 		!bdev_iter_is_aligned(bdev, iter);
 }
 
+
 #define DIO_INLINE_BIO_VECS 4
 
 static ssize_t __blkdev_direct_IO_simple(struct kiocb *iocb,
@@ -71,6 +85,8 @@ static ssize_t __blkdev_direct_IO_simple(struct kiocb *iocb,
 	}
 	bio.bi_iter.bi_sector = pos >> SECTOR_SHIFT;
 	bio.bi_ioprio = iocb->ki_ioprio;
+	if (iocb->ki_flags & IOCB_ATOMIC)
+		bio.bi_opf |= REQ_ATOMIC;
 
 	ret = bio_iov_iter_get_pages(&bio, iter);
 	if (unlikely(ret))
@@ -341,6 +357,9 @@ static ssize_t __blkdev_direct_IO_async(struct kiocb *iocb,
 		task_io_account_write(bio->bi_iter.bi_size);
 	}
 
+	if (iocb->ki_flags & IOCB_ATOMIC)
+		bio->bi_opf |= REQ_ATOMIC;
+
 	if (iocb->ki_flags & IOCB_NOWAIT)
 		bio->bi_opf |= REQ_NOWAIT;
 
@@ -357,13 +376,14 @@ static ssize_t __blkdev_direct_IO_async(struct kiocb *iocb,
 static ssize_t blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 {
 	struct block_device *bdev = I_BDEV(iocb->ki_filp->f_mapping->host);
+	bool atomic_write = iocb->ki_flags & IOCB_ATOMIC;
 	loff_t pos = iocb->ki_pos;
 	unsigned int nr_pages;
 
 	if (!iov_iter_count(iter))
 		return 0;
 
-	if (blkdev_dio_unaligned(bdev, pos, iter))
+	if (blkdev_dio_invalid(bdev, pos, iter, atomic_write))
 		return -EINVAL;
 
 	nr_pages = bio_iov_vecs_to_alloc(iter, BIO_MAX_VECS + 1);
@@ -371,6 +391,8 @@ static ssize_t blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 		if (is_sync_kiocb(iocb))
 			return __blkdev_direct_IO_simple(iocb, iter, nr_pages);
 		return __blkdev_direct_IO_async(iocb, iter, nr_pages);
+	} else if (atomic_write) {
+		return -EINVAL;
 	}
 	return __blkdev_direct_IO(iocb, iter, bio_max_segs(nr_pages));
 }
@@ -616,6 +638,9 @@ static int blkdev_open(struct inode *inode, struct file *filp)
 	if (bdev_nowait(handle->bdev))
 		filp->f_mode |= FMODE_NOWAIT;
 
+	if (bdev_can_atomic_write(handle->bdev) && filp->f_flags & O_DIRECT)
+		filp->f_mode |= FMODE_CAN_ATOMIC_WRITE;
+
 	filp->f_mapping = handle->bdev->bd_inode->i_mapping;
 	filp->f_wb_err = filemap_sample_wb_err(filp->f_mapping);
 	filp->private_data = handle;
-- 
2.31.1


