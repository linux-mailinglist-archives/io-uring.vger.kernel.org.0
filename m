Return-Path: <io-uring+bounces-3382-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3923398DFC3
	for <lists+io-uring@lfdr.de>; Wed,  2 Oct 2024 17:51:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BD3181F2A290
	for <lists+io-uring@lfdr.de>; Wed,  2 Oct 2024 15:51:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B0761D151F;
	Wed,  2 Oct 2024 15:48:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="A4rf4YXY";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="LdAxJ6a/"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 453171D1E81;
	Wed,  2 Oct 2024 15:48:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727884106; cv=fail; b=uSCNLrlq5kyRsMQ18/rVWiP9qTKOHfNMvHN+O7PAD7IxVl9VlhH7G3e0BcCdqiuhi4QYUHSBG0UApVQjBDFgzytr5RZd8tcKsB76BTkQQmfGHoV9U9rr1KrDKkupS0j5tQdcGmZaYMxcbeAqoAI2X+2LEzN6XhXZvE15/X2dQR4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727884106; c=relaxed/simple;
	bh=Lnxf6AfK1WK05yYxdmRKtWP8vQS3DaHG34gQ96MpvdE=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=lQ2DAnFtQmSWHZNjKIp2xJatgYGwWrrDnAmdbvbL9MaJwl9PPAA4DuBqs1kTdiXQti2SVAgvdNvUsJizbOqanW6VFNt4tCTNXEMmC4Q7qIRHbVxHQOZKU8IgYCHvufMJRQBFQ4N1Uf4hXzs/4Tm2OCFdVgLoZ0okce7wRHOLG9Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=A4rf4YXY; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=LdAxJ6a/; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 492FfY49010106;
	Wed, 2 Oct 2024 15:47:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=JHpD3lmL/8Z//W
	kHjsc8zPntUrr73cRrfNvXW+1CVuw=; b=A4rf4YXYjHcIyeZImUBs+u2B67fSC3
	AUsDN8bYJobd1qRjHTBDzdoVkVtJHMvf42OKNt2HR7FLU/uh1nO2QFJcRudtt+k9
	qRPCKHDSHI+R+9Lgb8IITZoUnlgMZk8JPIlpaAZ8EXQybE3J1vVJP7KlR8EQAt/M
	Gv9GeJxFSfgCUQMF8i6SWmF+ykqc0cv7sY/R8X85Sf5tiQg98xfd9GHmI3D9X9eu
	bxJf77l/yKdb56FP3A09AwL0YGaY3aBmgkkjYjhcbqM2RnCUiLIYenzMYsR++AS1
	kACUv5zuNPJnzZ2tzDoJCbxPwple80dvSLyCL3SlWeoCTkHH8/4X8Yaw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41x8k39u2x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 02 Oct 2024 15:47:39 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 492FU0X4028397;
	Wed, 2 Oct 2024 15:47:38 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2042.outbound.protection.outlook.com [104.47.70.42])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 41x8898r10-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 02 Oct 2024 15:47:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AyxHG9rdKx2DC/4sc/lQTwPx9oTEjgj2mkKaTp4D6UmAw+FvItPh1dZNHq+Ueyv9hK3OsYoe8nOItKjst8kJw77p1uPH5niMjkXAMTxaw+39cbNRvCbbvJ2Kdau39TIcSbEmwUo+Jlqy4s1yS/XzEITia/j0d0zGjdSMb0wZOnr7ZilODQbjfGJRepnr+Yax9589GwewpM7Uke5kC1TN3HkMN6oYO3MLsoKmnVN5ep0yXKc266kMDsEKU6eYxZK/awnvkJEZA/Bv8ZcE3a9r9gW18TTBcrxVSukIi+4/ZtJgBiYlbmLW1fM6+doZ7yIagAcN63tF7ghSAMPvd3o8Tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JHpD3lmL/8Z//WkHjsc8zPntUrr73cRrfNvXW+1CVuw=;
 b=nElPxPMQI+QJjt+f0ikVqrruYqxKlc0vWiB/E28pYmqFriX1e43SrCxLlLgHn3IDoEQYDBiF4/PaXDnkdB+SryGtXf30cFLqbd458edGnR3P31hMuzheBJMVPZ2v2fpewDAja+9h+T+MeOPRqrOC0xmPip4fqaD+eZC39/39z4WvukQnHvNUoc3X3ZRC2IrA5WRsh+hBv+hTT0SsBJL5h6ylnJfzICtS3imQ4+m+e8kaFzl92mUzPYEFCfMbCinkFTjJ5jeaI08VnFrJ4kqar5PdIXLxuISE3dIOZiuBTZNQVusgfjNd9VhpGmL+iIRNwruTPpWgXww4m8DKnLg78w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JHpD3lmL/8Z//WkHjsc8zPntUrr73cRrfNvXW+1CVuw=;
 b=LdAxJ6a/Pi5+2snEBzrbhpD1d7AetIbu9unyGTV+yPlkK8SMd2VGtFEMXikDJNx1R79OT5IL6jX764opXCAxtWiy6pYaoF8xs3DllKuc06MLTGUKa5aHqVFVlzb7IXQEtJy588Hqok0yO791ryuxbML4+/0HOoXwdLSeApcN/mY=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by IA1PR10MB6123.namprd10.prod.outlook.com (2603:10b6:208:3a9::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8026.16; Wed, 2 Oct
 2024 15:47:35 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%3]) with mapi id 15.20.8026.016; Wed, 2 Oct 2024
 15:47:34 +0000
To: Christoph Hellwig <hch@lst.de>
Cc: Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Kanchan
 Joshi <joshi.k@samsung.com>, hare@suse.de, sagi@grimberg.me,
        martin.petersen@oracle.com, brauner@kernel.org,
        viro@zeniv.linux.org.uk, jack@suse.cz, jaegeuk@kernel.org,
        bcrl@kvack.org, dhowells@redhat.com, bvanassche@acm.org,
        asml.silence@gmail.com, linux-nvme@lists.infradead.org,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org, linux-aio@kvack.org, gost.dev@samsung.com,
        vishak.g@samsung.com, javier.gonz@samsung.com
Subject: Re: [PATCH v7 0/3] FDP and per-io hints
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20241002151949.GA20877@lst.de> (Christoph Hellwig's message of
	"Wed, 2 Oct 2024 17:19:49 +0200")
Organization: Oracle Corporation
Message-ID: <yq17caq5xvg.fsf@ca-mkp.ca.oracle.com>
References: <CGME20240930182052epcas5p37edefa7556b87c3fbb543275756ac736@epcas5p3.samsung.com>
	<20240930181305.17286-1-joshi.k@samsung.com>
	<20241001092047.GA23730@lst.de>
	<99c95f26-d6fb-4354-822d-eac94fdba765@kernel.dk>
	<20241002075140.GB20819@lst.de>
	<f14a246b-10bf-40c1-bf8f-19101194a6dc@kernel.dk>
	<20241002151344.GA20364@lst.de>
	<Zv1kD8iLeu0xd7eP@kbusch-mbp.dhcp.thefacebook.com>
	<20241002151949.GA20877@lst.de>
Date: Wed, 02 Oct 2024 11:47:32 -0400
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0004.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::9) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|IA1PR10MB6123:EE_
X-MS-Office365-Filtering-Correlation-Id: 656a5316-cb9a-47ad-58b6-08dce2f988a0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?YVdBDPozqNnnSn6j8Ne3WzHZN6RcDaO+377KxwHtvlVbZfMk5b2UD5P175yx?=
 =?us-ascii?Q?YFgsylF4oi/2mrOjQHtF/oXPlnHb6F2th3ZdaOJJm1NxReY6/DelEZTpXRDJ?=
 =?us-ascii?Q?xxN4csDSIUFUC4IBSb1qKDnFXVvUsA3esp3/RHY3R1+vpRiSLlAIP5gXDkCN?=
 =?us-ascii?Q?eYKcwPUZB2IAPHD2ZkHHLziDR72C+c8chEabk4YvSI6gQQrN++/aRU4qBGJy?=
 =?us-ascii?Q?py/9gc/zZANnxBsCnmKeoL4dXy1+gISVYFNcQjwnQ1v0vSQggVDMrwRiuOg2?=
 =?us-ascii?Q?k6gZ+/RF9RjZadpvB33P1JVwC9Kac7O48ehG4tDiCD82QZHvF8SHqNLen2BA?=
 =?us-ascii?Q?n8hVVdLvV9q/PHwsKa2yGpj+tc+4YJ5K+oQUU76q6BO0G5iLJeW50OXFr+U+?=
 =?us-ascii?Q?2soqdaLCncjrgMukkGZz84mjxn29lLFZABj8ZHwSk0YIHi8njFUk/TIjAqrD?=
 =?us-ascii?Q?FS6QCG2A4+42kwIT20Y71YxnUvZkFccZ9L3tSixqouKwV3KO+267bsLEehzS?=
 =?us-ascii?Q?Pb0DOvJ1GFVOSsViYIYfnS6jLqh0qV0oPbLEyO8IL9rbGeEhF4gTMv4tazWA?=
 =?us-ascii?Q?WiLany+Gowg4ZOS5m6OtGtPPR8rkl9OK6rCJoUgYJJ/mrnv+1jtO7abvhgxS?=
 =?us-ascii?Q?TQR1HHtxq5eBkt9DGlwWoqXJb23QRGBdew6Ws/1ZJK1Dl3G07iU6NhfgKgpY?=
 =?us-ascii?Q?TVGfWlEGlm5sXpGijyKkoSi+OMjH5ymQGpsp66Z/m8fg6fDpJICFHNk64bCv?=
 =?us-ascii?Q?jxokGOlwP5IlIHzzPK1MUpbBMXOZw5ntjQ2+x9z1GwKxRYPKJssj1rITtmgd?=
 =?us-ascii?Q?sgpg5XMm29J00iKf1d2J71qpKcGU0DUG/OkWcNdENLOW6kF5hn+Udj869ZMa?=
 =?us-ascii?Q?55MVbMrIFYfbd4hz1SOsLaDAyW8PfrK6edeaDeK44Yqxh2b4Z6PC8VjfxBOQ?=
 =?us-ascii?Q?KDOfDt5N42xfh9pDMuMrnIuWBUSsqM4/y+320MW23TkIuOB4lzE5RYQujtIx?=
 =?us-ascii?Q?VT0jrNpcij/U+5FV+YoQTE2rI4O0he2Zn00WjkK1fXYx4qBDcaYS6vtqGDIN?=
 =?us-ascii?Q?Zo3jku1EOe/0Ze94je2kXCWgq5xOOhcdn02ZoJHQZ2d4m/OVFDck3T0hIuFg?=
 =?us-ascii?Q?apBk63i42vdIJrb/SfUhUPoXyvcugkQudd62Axbcq5imA1A+WgcIcGHU3ozX?=
 =?us-ascii?Q?LNgdu0ZdoxLL8pE0C4NDqa9nEz+rALCHYkBZBBHfJtqucjKYI+ySrGitAeUr?=
 =?us-ascii?Q?mXVQiBSIXP9/w1NebnkOYXymSb6vC5y7lAOVnSIQbQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?y+g6krfuI+UpQjXZc1SHrJeNxLtj/qPTEYTZR6crHssTjHLWROOFXBOsOOR1?=
 =?us-ascii?Q?cEzBu9itydZaFLqHJ2/DULQjMqr7rixaFqzUwsvhBzFtRp8IFBKyyUogND1V?=
 =?us-ascii?Q?b66LViJqkkCo+5fVD3geXGlPM1kGnh8PRjQxHgrvGM+9PT5JjNFpWbmnupqh?=
 =?us-ascii?Q?MKypiWM2WfATAjMw8FeF2W8+CDIPjbX9KtjvD/fMf2aV1YJVf5/X4dFVQOc6?=
 =?us-ascii?Q?AFMNlXNto5VCIRc8w9xnhbs3tMrffaxUxD72xwfa1+0cqf5wvcC+dz0GHHVd?=
 =?us-ascii?Q?VGKE2uvdvy8NNl1Vl7571xQJGII0adGNhvvDaPqC/W4s25PKju3F6fjldId7?=
 =?us-ascii?Q?Fi0iXPBtaS4K0uX/0v+de+aOeBZckvUTP9MASNLcEMzbegSv2bkQRlaW6+Ud?=
 =?us-ascii?Q?tHQJtDamRUGuLUYqLL/Puo4gXpljlluzEtLNOdaBJG/MkJtA/WX/owa5P/l7?=
 =?us-ascii?Q?u/Q3MgqkTVeh4wMhvWG0HLicPbu2u38PjCIi9Fsuy6CXyj46mhi+z55ekabL?=
 =?us-ascii?Q?4CJ8UwQJ5o+v7CQi9td/qiZ1wVUDmSvIbx0lAuZdl7G8Rnet6hK2EJXi7+OV?=
 =?us-ascii?Q?CIPXB7E1cyG7LJRBXSzrH608Qpm6EJ0ilVSGNBPjbvoftIFp2xXYinxPzDTK?=
 =?us-ascii?Q?kT8808c8TRewL4a41ecZIF0Kpd1BTKnS7c3CWNZ5EY3iShzWhKNWPfjuhYlW?=
 =?us-ascii?Q?Q4kPpVvg//RoVniRT1RUS3CBbvP6+ggu0pRoafxCchhV0Ov2F2jyKpC4hQyf?=
 =?us-ascii?Q?Nwf/4+Ps5RO3SKqaqQDSz7XTG7h/b0bs3SoceYeFZ/Btc6yhzx/a/GFtKgAb?=
 =?us-ascii?Q?NIiYxD47pe/UttolxRDnLTccRMAqQylVI14TsM/T+kZ+vj0VaXLxCIixCat9?=
 =?us-ascii?Q?NQMlPnYq7tDqz2qmRPPgujNWruNPW6kidimYlxPUG4VQnWa/WrpfYfd4Hu2y?=
 =?us-ascii?Q?MMa19dXhb+EGs8JnkOisH5VF3RxSsROO8KY/B4VgJDzTLDmuncuGJUYk/GCZ?=
 =?us-ascii?Q?uljAhWPxSLfaJE4RdqH/kjyV6tiUhuJfrZ245gcXDHXSqBPtpDKv1VkpZAMG?=
 =?us-ascii?Q?KyJpS1DP/LWIHB+dx0iVDwMZSHN3XmKCr5ivKIrv6nWUJ056ONfV5mOXGvda?=
 =?us-ascii?Q?EswZgKzLim4R3G1FU4/yNJaIkk7UtwPPgkLQvj1p9VfTWx5aisttBXFrWR81?=
 =?us-ascii?Q?GfEIWmvb6EBCeBt4wYdLod8B3WSn9F4CYqDl5t5exnv1R+agtUQlU539SB8r?=
 =?us-ascii?Q?nubdNMe4U6jr93R7UDTQObkQztaAR8JMl0zGNoa/YGzp/yBVqQzvs9a5rUPN?=
 =?us-ascii?Q?fsdFLfj2Uw2I31a8CkdYUp7q6V2T6Td0xi5CaYc7w68PEDdmJVYBpoMzMJBC?=
 =?us-ascii?Q?26GWBs5sFeSmHs3tVYpodOhmP/0B0kmZwumgAQSak7KdxN4yyXu+pQan0LlJ?=
 =?us-ascii?Q?/cqKgp1QgOCCYPDnNfRCGNX/juXRqc5Uj8A6S3+AwmIJu4bXHXIdeIamVxNa?=
 =?us-ascii?Q?7a2cfuifOn1OoQ7pmi+VAeMtP4Wnp9GKOdCgxWPbki9bIboD7+BY8cgmnMGf?=
 =?us-ascii?Q?YE848GwZChioSutgXr20NpfDQt3f1Or04SG4biq5MJ0AgIgoTiUOWmhpckpu?=
 =?us-ascii?Q?1Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	t80BEsSxKEFXkXeX5aJu/8NVOJJ8sG/Yje5aQXnPUu+k8xUVMY/FcKidMAxCwNyzRoPBJvDirF5CiIzujFkfxZYZnEcBDx9aZhZwxN+uwlQGlZEtlcmEr7GhlXXwxCBVfqHDiSi9QUY0HVSFL+bk6X5uHmjn3nmlzjVbyPKkEumGLmhUWNELiesSd+nYZC4yi/vcaLibWyvuW80EY5oszrd+nJsMErlude8gVnlwscFbnGlywKIRb3XNGgZ4QSDvTYa2QmI1W9y3pChfVI+Jmoh2v4MqgdwYHY74LKRXmfEhG7oEiqZl8ivKCgLj5t2xFP0PFHFUpAO5PWrG1R8jHUeMhiZIaVU5a7E57ENqsgmq5NxSLlZjv8C54tRORZtbTH8MXx6uK4TjakReh2Spha0Fqmfgx6ikM0jKWg4+IQbVAZaa8VXPFnnRN6jnXG/lgTnYoHW204LKLuU53jGHv2lcQEHEMY5/ztQ+YHCSlMl0bWw7iQmoYw+v9zG+wnd9oUKar7udwan1x6oqDIjiAz01I0bAZJtAy0as4pdqMy9Uiggi7n4vSn+6i7RdeoI5vQpj/+CuE61fZ6Akcf1HbE9577eZv8Se64CtJvVRWyw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 656a5316-cb9a-47ad-58b6-08dce2f988a0
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2024 15:47:34.8968
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: trRl17HwCNblVAUFGq1N5DRhL/GFmM96T4X3/FOVnB1PK+vwuEnYGyfpaQwMQrq6d5daa8UF6R5vprFv1/voIy7bFSvY3JjsuY0S4AVRAHw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6123
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-02_15,2024-09-30_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 malwarescore=0
 mlxlogscore=970 phishscore=0 suspectscore=0 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2408220000
 definitions=main-2410020115
X-Proofpoint-GUID: zgqGVBPymT5HwZ4KjaVN8DJezNtZeOtE
X-Proofpoint-ORIG-GUID: zgqGVBPymT5HwZ4KjaVN8DJezNtZeOtE


Christoph,

>> Nothing prevents future improvements in that direction. It just seems
>> out of scope for what Kanchan is trying to enable for his customer use
>> cases. This patch looks harmless.
>
> It's not really.  Once we wire it up like this we mess up the ability
> to use the feature in other ways.  Additionally the per-I/O hints are
> simply broken if you want a file system

Here is my take:

It is the kernel's job to manage the system's hardware resources and
arbitrate and share these resources optimally and fairly between all
running applications.

What irks me is defining application interfaces which fundamentally tell
the kernel that "these blocks are part of the same file".

The kernel already knows this. It is the very entity which provides that
abstraction. Why do we need an explicit interface to inform the kernel
that concurrent writes to the same file should have the same
"temperature" or need to go to the same "bin" on the storage device?
Shouldn't that just happen automatically?

Whether it's SCSI groups, streams, UFS hints, or NVMe FDP, it seems like
we are consistently failing to deliver something that actually works for
anything but a few specialized corner cases. I think that is a shame.

-- 
Martin K. Petersen	Oracle Linux Engineering

