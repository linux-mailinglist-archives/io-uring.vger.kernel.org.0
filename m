Return-Path: <io-uring+bounces-4669-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 472B79C8159
	for <lists+io-uring@lfdr.de>; Thu, 14 Nov 2024 04:10:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B901F1F22A86
	for <lists+io-uring@lfdr.de>; Thu, 14 Nov 2024 03:10:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F29D21E7C33;
	Thu, 14 Nov 2024 03:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WkCXdHbV";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="R+fU2+xc"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AF1D4C85;
	Thu, 14 Nov 2024 03:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731553819; cv=fail; b=bVhZxWKcosPiPSul1uSC+ea/mnzsjwL5VnppMPsig9GgV1VdKcSJRBM3OH79ONZI7RQRMe6JfpkgCDzhTDQS6pnIaj0wyCY1QFdVwA3kRSIg/PFbdi2VwlvLYImhwafVkcZwcRQQDTav4EEQAD3t+KwWbVSJNjCmTa26TOR+OZ0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731553819; c=relaxed/simple;
	bh=q0CKsucFM+z75HO0JgNMtKi2uI1G8xIvUNdRNKaS76w=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=m3Svo2tUb85XGTiuArGS37UwbWDRsGKLpiFSHu7aI6rj1zClKkDBRo+JTcnlNwWH7jA4TjxKgppmmBkCjLS9FCld/e9mgUamniT+5raomCMc02iYR8RcMBl2BsEI72PxYuT5Ud7RjGL+1QIVPpvXk9IVpdCQK5fggBFdlpr/nzQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=WkCXdHbV; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=R+fU2+xc; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4AE1fmTs008430;
	Thu, 14 Nov 2024 03:10:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=pTGSXPKraJoKHh+aTV
	XUu06d+gHMhpsGF3zae9u+/XI=; b=WkCXdHbVJsvgU4n0wEG1fb6+TNsfBJ6+Ep
	XWdUcZ9/kSpbXnAOYX2VAZex5BrdPOxCVpSy7F11yz177CKg5/a+EljRMqGHYtdX
	MkEVxJ78JtyHGpwf0vTwbp52NfGaKYQb5R2HKaPeyTCFY5enWK7CDsVBcrh1swG2
	Sjhw55ClEtg5ethKVkepvW/YCXFCUaCTdqSKNhcWA134zuLoG0rfiUtbxzWMAbTy
	o8OR+j5KrE8LElw55m8aE6VPeTxsj1UH0Zkqnw7YmjCE3MH5FFSxQa+i8/Lg+Rjn
	BC8GS6Lp7ECAJaQ6FN3oOlzm69DvoF86tfLVT24G65F4egJZGmlw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42t0n5091j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 14 Nov 2024 03:10:01 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4AE1HEqX022699;
	Thu, 14 Nov 2024 03:10:01 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2177.outbound.protection.outlook.com [104.47.58.177])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 42vuw0pkd2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 14 Nov 2024 03:10:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Uc6SMa6sGtlJpITCMt1WymdsvwSsarMHiICAscHKinyVxni1sxw7o1WdQmoLYPLIFmRgHtjYZGqlxClhM4uK6F49YcLnzBi1vOLFrazxMU4535zNwACeuxC3Ap/m1fCsa1O+iBfOvC3XANfP7PQX7scRhemnjKI1d2deilht1nUqabn6UV67VQLxQmABmVQqPVaSfIuDMTKIApPPw6780BukmQBqpKOrmtxXh+2vk2sim35Z6k+jdQVW+dTUykpIwFj8jhVCSHCUOlcq1iXDT0z8ZcZPeJpkWq7FjYHBenh1RmUr44cN4mglGAGQLjwCc3EzHJGkw6twp+/H+uXLXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pTGSXPKraJoKHh+aTVXUu06d+gHMhpsGF3zae9u+/XI=;
 b=dh+kE6/g1mq9zt6p47f2hraa7G+/ui5lDbbsf74sdk8WUFEyY2jNNhHMXyJ94FUWMZylZQoXnQyspaBkNL4Z4swILGelZYU6Rhp8p1l8GDLjUhCX0gpbZRgUsznZR5kqP1+JkVvdqxDELYrNymLP5+Q/RiyWcO6btX1Sez1wqFBBxWAk6ydN34hqUL4q6sLTV6+pBvHP5Yv1f5vOv52nbPW/nHRikshyZTocN1d/FAjkluo5l9mHQKKDnzojwL14kEDZv79M5LYzuU+MVvOqiRxk1AiwGLlqVwA6wqjDIdqWyBYsWqatQ8co0vVV2nHOtz9I8NkxsriKxARyUHc+Zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pTGSXPKraJoKHh+aTVXUu06d+gHMhpsGF3zae9u+/XI=;
 b=R+fU2+xcbC0qslb5HQF2U3p9Hipw2FuA93YSQ1A7hc5U36esG5mYFRAuieCZzE75AUTbAOhR6OYrTyJZhDkOlu5HDRg/1zN44O7JS9Qb0SCp5+jW592p+dNhHRnS6y4K6YS7LZw3PW80M016yxX9JOMYZgpMwtwHGvWI0KQgE3k=
Received: from SN6PR10MB2957.namprd10.prod.outlook.com (2603:10b6:805:cb::19)
 by MN2PR10MB4222.namprd10.prod.outlook.com (2603:10b6:208:198::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.17; Thu, 14 Nov
 2024 03:09:58 +0000
Received: from SN6PR10MB2957.namprd10.prod.outlook.com
 ([fe80::72ff:b8f4:e34b:18c]) by SN6PR10MB2957.namprd10.prod.outlook.com
 ([fe80::72ff:b8f4:e34b:18c%5]) with mapi id 15.20.8158.013; Thu, 14 Nov 2024
 03:09:56 +0000
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>, Pierre Labat <plabat@micron.com>,
        Keith Busch <kbusch@kernel.org>, Kanchan Joshi <joshi.k@samsung.com>,
        Keith Busch <kbusch@meta.com>,
        "linux-block@vger.kernel.org"
 <linux-block@vger.kernel.org>,
        "linux-nvme@lists.infradead.org"
 <linux-nvme@lists.infradead.org>,
        "linux-scsi@vger.kernel.org"
 <linux-scsi@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org"
 <linux-fsdevel@vger.kernel.org>,
        "io-uring@vger.kernel.org"
 <io-uring@vger.kernel.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asml.silence@gmail.com" <asml.silence@gmail.com>,
        "javier.gonz@samsung.com" <javier.gonz@samsung.com>
Subject: Re: [EXT] Re: [PATCHv11 0/9] write hints with nvme fdp and scsi
 streams
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <ZzU7bZokkTN2s8qr@dread.disaster.area> (Dave Chinner's message of
	"Thu, 14 Nov 2024 10:51:09 +1100")
Organization: Oracle Corporation
Message-ID: <yq1seruttd1.fsf@ca-mkp.ca.oracle.com>
References: <20241108193629.3817619-1-kbusch@meta.com>
	<CGME20241111103051epcas5p341a23ed677f2dfd6bc6d4e5c4826327b@epcas5p3.samsung.com>
	<20241111102914.GA27870@lst.de>
	<7a2f6231-bb35-4438-ba50-3f9c4cc9789a@samsung.com>
	<20241112133439.GA4164@lst.de>
	<ZzNlaXZTn3Pjiofn@kbusch-mbp.dhcp.thefacebook.com>
	<DS0PR08MB854131CDA4CDDF2451CEB71DAB592@DS0PR08MB8541.namprd08.prod.outlook.com>
	<20241113044736.GA20212@lst.de> <ZzU7bZokkTN2s8qr@dread.disaster.area>
Date: Wed, 13 Nov 2024 22:09:55 -0500
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0605.namprd03.prod.outlook.com
 (2603:10b6:408:106::10) To SN6PR10MB2957.namprd10.prod.outlook.com
 (2603:10b6:805:cb::19)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR10MB2957:EE_|MN2PR10MB4222:EE_
X-MS-Office365-Filtering-Correlation-Id: 6e9edab0-9e1b-41cd-fdde-08dd0459d12f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?t2botBh/Qh7K4s5lGZDOR3Jn/2jE54mIhge0NHN5jp+c9vHdU6i6TSFiww/c?=
 =?us-ascii?Q?U9J9wnu8w/VpHeo4q3LmSKm4O0v6iFGSMEWHdXrNEn4W8hbQqcYKI/fHS/Ev?=
 =?us-ascii?Q?yIpH0qkWS8gVN3t74M63FVswICDT5R5a+q6ze36fu11FYzINTDdY8BpfAAAO?=
 =?us-ascii?Q?QWjpzr/VjeyusvN6baViZ54R/sUrNmk73teenCRI8TUBV4AfCXcYsGkIH+vW?=
 =?us-ascii?Q?0LdkUde7xOJEJGJdITR0pAQYejf56htAGDKpnjJ7y8fm2Cli1mFqczR4hlLY?=
 =?us-ascii?Q?u0LPKYqPcgJjome8HrAYx8qV34o0a9okfkoFM4s9sEeOSmWNm1fS2Tmv+Agc?=
 =?us-ascii?Q?VJns5RMCj0mkYrQ6dQky0TqdJQCNuAK7OaqwPFEMU2FBY+VL/z5i4g9eTQWE?=
 =?us-ascii?Q?1gARMxiJowcg02ey9bYd5ZXE/PALoz6diKwIhkOFrYRcb9YEsZFx3hSTE0fL?=
 =?us-ascii?Q?dEl/iB2etSEZ2QIZXYgcez0fP+MR8AY50QjA6wqZvatfyP2g0bDvRXkOpCMl?=
 =?us-ascii?Q?mjVkfoCyLLY4wNt8KnnacjDKBZQQW4l4O9vcL0y59WkXHqR+7nvtZvUC8tfA?=
 =?us-ascii?Q?t1BDyjtqVcrGZTbQekv7q1e5mqq4m8pHvgVdKJj/aulCnM+ON32XW67WJUf2?=
 =?us-ascii?Q?trXjVAFiPh5NdW5ihFNdoga6r5o1NIakNbIoZzRYm5ig/0ou84xIMXdRc2MW?=
 =?us-ascii?Q?uUUNRjgyqMTMzoFmSE4gg47X9zmA2u9x3K/n0+Pgu7q/71CzURB8EPs718ZS?=
 =?us-ascii?Q?GzNvnjaomMas+bWRedyF5OF3fgIL56FJ/XKm0qgfQLf/VzKPhe3PNHvQEW1Y?=
 =?us-ascii?Q?Mvi5G9vUxZpoT7oVFlvxvhtFTAD0AsyJf17W5KgPM3D9y6cd8kvvkrG1T2bt?=
 =?us-ascii?Q?sg2KG+uhea1AhXPFZq5PmAYPkS917nC+CHrNB+7sFnuDxnKqwnj7dToEx3Zb?=
 =?us-ascii?Q?ZOasI5+Tg0Q4ZB+ExUBTMaZN9XAuA7wu3DGfPDDC6WGO+jrG+13hL8znRRYi?=
 =?us-ascii?Q?ZTbmJFIV2waYosphi/Bg/iL9en0hxBXR+J7gguqRsrlgUwJKiCpd4UuFsVlV?=
 =?us-ascii?Q?sv6pg0i5Fc98y2mpeeybvoumTiGVrlxnJXgVkOAwUNPPhB1SLFJvSjxTATKM?=
 =?us-ascii?Q?qN1c6OuCqMKSbsNYaPT1InjfFPc/KzJeTIp6oc9zqpe13Vd3MAQHPoBGGSwu?=
 =?us-ascii?Q?PtkdJn18+xQKmMt2m3Aq9b+2+QmRAlb6/o/OLv37mq4Jq6NSp1SefFchIBZJ?=
 =?us-ascii?Q?BNnk/65wd2CeyPpveS3AbaRGGuSSlsUM2sIcoXZ6j+0nsu7wN0uHgBJdcHw3?=
 =?us-ascii?Q?gR1DSYJrLX0tcft/gVZF59vH?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2957.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?2cnJbP9v5DEsE+R2ghMx98XATZrCLg3IdMBpkZGQtPxbavqFlu8eyrE8BrOn?=
 =?us-ascii?Q?2GuFLZKM09QIqA59oJcbjXMhjzOi27hLwQCKaDc0UeoRCHUgfwNRk+0aQX5I?=
 =?us-ascii?Q?mIVel2Abfh5Zxo8Y8qsTEVB/ffjkIPHBcTuXWsXyLZm/Hna8dRQx2PxQEHck?=
 =?us-ascii?Q?rZGSSJrTr87pGAkUN+BJ/PZSTFTDg3xuu+dvNAc3c6HvS3rEG8k7XllfIA2B?=
 =?us-ascii?Q?TEteRwswZu93+BSz68y6WtK2VCOp1x+9x4LbGewXGq2CjurD1lzzB8D6hdpa?=
 =?us-ascii?Q?TWlPfGwwt9i5RTGLI0Z9HdzEm+UQ6YADtQMcw2TONAWkagZ2LXuAFvfIkgOj?=
 =?us-ascii?Q?cR/rCrSQoDyNoya6rvTsF6YLE45gKfk2Uqs+3tx551IwAD+nVT6JS9NvGbD7?=
 =?us-ascii?Q?LDRp+Cf7mMueAs/VtGcdaSy2A0R5QkECzv5LKD08stxDKpheNJt6DfoH5zhg?=
 =?us-ascii?Q?bvFp19qRlAiGesJwefYKjWZbRwfgo2kkg98vq3KF4ldcaF9jabUZNuVzC3ve?=
 =?us-ascii?Q?PbCxNCxqjHRbBDlzu6ubzA/6Y3eRQOl/wy09UjYs/5LxUc9klIxdb/MP1Fsu?=
 =?us-ascii?Q?ygcxhAnWwbM4TfOmfjGTuw0dcDOQtEpGRJPkFfD4gUlAkmHn4eqnu+LrA9lw?=
 =?us-ascii?Q?3fQxhY7T5SbI1zLC8ctjU5329vCP5IWYj5Hh19jSe+IL/PFU9MoCQ2CJUaxE?=
 =?us-ascii?Q?pPs3OdH0m9u1k8BgYlOfqG9PIRbObgYgpA9wh3WkPVjog9wYDXAq+xk1+4OC?=
 =?us-ascii?Q?zU7HzLFRoqoPpS74JrJdTobXe6BFz49u+PZy2DXpVUDen6kljh8xvzJhSoRv?=
 =?us-ascii?Q?LYeuwQjtSHhXhnPiZda1x2e31UWkFRYooAjhj3ZAhSVEvYdWSuh8nCfABSzZ?=
 =?us-ascii?Q?L71+ietBEjEXfS3pbm+8u9uXMGXgxRf0Ond/f24JdvR0tT8mJzPKR3Qv26Au?=
 =?us-ascii?Q?PcaGW7yWthKksxLmDBHS4e/uXnjTDRomMKeSa55YYkGzTVYzT/q5cMTlI2vM?=
 =?us-ascii?Q?jYTp61uAulkEEJA+9HxLrZoeqMO7KTpSh8rFReoXxJibjE1Jqw6+ZzsfKO1A?=
 =?us-ascii?Q?zwzXX8KD8+2zCjVHDq28NoSfvFaUSQm7tWUujmUHXKnrO7e5i9QivBQ/m6B2?=
 =?us-ascii?Q?P7XSEykQPOWndqFnEKyxS3KbT83sUsWjOxR6eKvnh8XNUFM7gan5nzelhtIq?=
 =?us-ascii?Q?kej62wU5MsUSohZyp+6xREvgfktBZAqILSfkndZBLSit2i5TVaseCSQLjI3C?=
 =?us-ascii?Q?9bD5dfI/PEqXZ3I+NHjtRJrdeBMovf0XFGhvl3Tp/YzvpF9TrHWMNCQtZ7UP?=
 =?us-ascii?Q?yT82e4Z3PT+GVbfPR842tjJt88IiAcPv6f687IPFlpqT8XK+gtkgLOfVIns1?=
 =?us-ascii?Q?DQC1LCvKwVRQt5o7KI0BW9ljVHgZQUvXuja81V8hFEBR9xAnW0TOXfv3W+Wd?=
 =?us-ascii?Q?Jat6arFLRx+MNEFI25wdXGn0178JpT6FpBxHN04Tpoukmu5z0eFZbkWl/XmI?=
 =?us-ascii?Q?TdpmCOjDQ1Gvs1seC/VYIr+YHn02wI/NYKDe4Sjf7/ajRPdUePGdvmjedskp?=
 =?us-ascii?Q?3E5P0KcfaqqYsVEwl2+QGPBiZbwc670f/dPYKiAgnlTQ3FWggXIxPXDGrOCH?=
 =?us-ascii?Q?dA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	g5QWJ+ink918ioTOIGzXJ8XKLdnl8GQxEd1A/aFHoskWU92+leJ5lkquX9ZQvJu/79bQP8tfmsWhNkIwNzWz7qbzJLY+w472anQZ1Mi12t7uDOOezwdSE15NIDkancKOlr+8hUHTlxU/1gAbqTUyOg7tNheVZsSiue9aJh1w0HD3eHbzAGZn9uAMK/WtG5qvLanJa8T2aphTo6jiyeyawJEn5TCA5bhR+I/d/cbNIN/TEjWrqECsFxCKFRKT0MqokN975I3mR3h8yIiCMEgwXlpyf9Q5wHLOvHFtptK51Vu2vT5MGc4x97VSTdqoY+R1fcyZFY2NT+e2kWAyU8cypj8Q1tcL8Bf2VvSVS+z5akMdasm50ZSKAFBlZ6UcJbeKeGQfBB28KZ8oYiSpvIaH0vOkVuM+CegApA3K1nmDqW/2i5aIQUYeb3P31LJwJOOL1x4dMvTC48TLDJS99NDrEbWItT0KjbU97cn8PWTgMY2IbIA/SeZ01UhLk5DwUN2XeM8z4gqSy+8xSzmQqW19Yb6zoLufX+R8JvisYWAVBCbM+gIRfg8S/zZ00yh0ZJu4rV2L9R18UmN+dJGDxKOu8gn+a7pDItqr2QnZ2rus8pI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e9edab0-9e1b-41cd-fdde-08dd0459d12f
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2957.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2024 03:09:56.6295
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0UAI1d5yhbv+NtjpzyJV2pL0m5uXB3u4Iyhh5p/Bio00DS2gTsRKRBI+hNwh+uDSsbsUU9xx5RHse6nXco6UNxzMP/376pmtx2Ns0/u64uc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4222
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-14_01,2024-11-13_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 spamscore=0
 adultscore=0 phishscore=0 malwarescore=0 mlxlogscore=900 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2411140022
X-Proofpoint-ORIG-GUID: fyd4oKUT93_p_S4bHSo8a9IlC9kgERzA
X-Proofpoint-GUID: fyd4oKUT93_p_S4bHSo8a9IlC9kgERzA


Dave,

> The OS hints/streams API needs to be aligned to the capabilities that
> filesystems already provide *as a primary design goal*. What the new
> hardware might support is a secondary concern. i.e. hardware driven
> software design is almost always a mistake: define the user API and
> abstractions first, then the OS can reduce it sanely down to what the
> specific hardware present is capable of supporting.

I agree completely.

-- 
Martin K. Petersen	Oracle Linux Engineering

