Return-Path: <io-uring+bounces-1221-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DFECE88C3AB
	for <lists+io-uring@lfdr.de>; Tue, 26 Mar 2024 14:40:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6D8AD1F3C70E
	for <lists+io-uring@lfdr.de>; Tue, 26 Mar 2024 13:40:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A902874C05;
	Tue, 26 Mar 2024 13:39:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VF8OMS2r";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="E+pg2pFx"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9161780056;
	Tue, 26 Mar 2024 13:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711460384; cv=fail; b=aCUSQ+kegQYU2pRZrfJzVUqIVfiVJKp0e6dxzzc3wCUBKVVxNgSw2MPOQG7jVyZ7D7rqii0C+8kryLtD+FmJuhu6wiUj181JuwofIUOzjXqKVpfB71EftW/HfGjsbnwM2sTUHKdLs69LraX/JOhEql6QMUUObCD2nNdOMK/rUSw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711460384; c=relaxed/simple;
	bh=eNy4vc7v4MD91pZQkkuJdnbfyPXXwYtwTqQW1aKAr58=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=UzaAfyz+c5Ed+19s0fBdSNAW6CVSXOaqYZUtUMZQS/fP3SCcJfrXFUMflNuK566YMb6FlUOItsk9Qrr8Zm3aaCZdokhw2WckCCJqbyEucw03nDx4mDs6HBh4gVYjT6eINDUhzlznoS5+FPBwVYi89X/RomhLfw8/zNehMrGUa+o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=VF8OMS2r; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=E+pg2pFx; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42QBnTO2002350;
	Tue, 26 Mar 2024 13:39:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-11-20; bh=lJFqGDQVuP+5yQVTw87t6ocgSqxEdIXA7qhdZHCTSo0=;
 b=VF8OMS2rP45dlI0ZtTLl8JjYbP+AZ0aYknDIui2Gcfs7M9Ottw1YpSgPgRG4kVANQEVx
 4U/+BhQ983wfOkKKz7adKATmVGhoOzPnxodg+8kRFUGXv5TPTzQ8SnOcQSSF5hTdC4ea
 Gq48YUHMvAHKpI9t8sPRpmb7c54Gqhcq+ffoXhP9iVNOKruGk5OdHglt5slIYnkynqUt
 zWjTtXbohDB3pbncMPa4egkvqCCZC2kAYgw3L29wy2Ai7PGCkThy6e0yc8uoSP+/+s8i
 d0BP+JoIfC1V8+HeE4pJriqSyEFBOXRJWexXWMf+KrqD/+7WLaNz2zUQGDwo1AP0rTW4 YA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3x2f6h3xcp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 26 Mar 2024 13:39:16 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 42QCMTQN024583;
	Tue, 26 Mar 2024 13:39:16 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2041.outbound.protection.outlook.com [104.47.51.41])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3x1nh70ptm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 26 Mar 2024 13:39:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fTuAPLC6VuP6asbdFC+BJYplcs/Ra84Qi6OjUcp03KUR5xm52s2ddiI/AcMeR/so+ZusO8nY5pDwMd4ukX91XxY1kmFV9qMhjth4iwgoXTJuYbAzjOcDF4RYnnFKQ/H7Kx9jR1zomQfBDmjKybtuYwfHTADKT6skZTJ4vn3HDvHfQ6v1rzkYV5Z2+i6nUuqwPs+6OqrZ/AadhmiLYlbRyaRoojV6LIVzLg19Xuu5ggdXT3ujHa8MK3zYYgxqabRPolea/D7KY0ZMPwko6Vq7umFqn2cGqYxJw5lLKGRZNghCtQqfyqiJGK8FkLGY/+f0n0kGsBWR64z5JERDsFP/+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lJFqGDQVuP+5yQVTw87t6ocgSqxEdIXA7qhdZHCTSo0=;
 b=gBGh+NVtcmXaReBfzV9FUlxo2R3C0UqTDDCa4yWYOb4o7vhLN0Ktz8Inxk8mdiWrw3BwaOmGXiW/E1rLPRkoS8N6fkoaKcTRpFGN8JQww0QL4CGjQXjnwBvjOiSHcB36WFmizq6oDOIv14S08kgQv7N+QR1Kqy7BnAkiK+u/dcJsdsl79XsglVjz3txcDKdFXqsxC3yOtauoK1Jh1KoqU2DdEYCM195EoUy9RJ80DHteoOkKI6vkDMk9COpfhH0Jmw9XEFHeOYPNAv+rjbrtCQmB4wTRSaFoxlJ4ej41SB/nBK3RT49IqgkPMfxhRshNdTxmNa1iFl24O4XTWB6ezA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lJFqGDQVuP+5yQVTw87t6ocgSqxEdIXA7qhdZHCTSo0=;
 b=E+pg2pFxxIWfXcJ9nxay1940xXKfadWvpIQOtIOHsRiGk5iC4IyYT3gt4+bkHywbPeepwGFT51Z0Uyapy0/sF0fZotftWhoSusuSLAH0yBxrhuQyxCJ1EmfVTYb4gV0gO1a7/JmBEjV9yqEED0e28hgyqVbj3YM/RUQl3hx+ijg=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SN7PR10MB6666.namprd10.prod.outlook.com (2603:10b6:806:298::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.33; Tue, 26 Mar
 2024 13:39:13 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ae68:7d51:133f:324]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ae68:7d51:133f:324%4]) with mapi id 15.20.7409.031; Tue, 26 Mar 2024
 13:39:13 +0000
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
        nilay@linux.ibm.com, ritesh.list@gmail.com, willy@infradead.org,
        Prasad Singamsetty <prasad.singamsetty@oracle.com>,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v6 03/10] fs: Initial atomic write support
Date: Tue, 26 Mar 2024 13:38:06 +0000
Message-Id: <20240326133813.3224593-4-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240326133813.3224593-1-john.g.garry@oracle.com>
References: <20240326133813.3224593-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0080.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:190::13) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SN7PR10MB6666:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	nTddXkxPNiIHznduM1EGdtcsHYXrwfNyFlqB0fSp5JLg6dYViZ3tPjgGh8sQ0gxLRDKbsswRHvJ5TNBEWTk6YIaKanoesx4bvc2nhm5hOINHM9Nl6Y9sOpQ/PUsOjodJ/Y3zKrKrPEX7Lc3zIzmvoGiGAuBt155+xF7PUwqcgwPPhlsi4trbY7iHyEvt3P7/IhXlJDrq6i7eFu3y6nV/9gJEPh+glEax1ACCa3WNn5jFz8KFdHZIhh0ax00OrqvFmF24CKjZwBr2+1oHFzc770hCDmWSq2EJZUH0702PhgeyPgBn3Yyat+15S8gplXJvuuljDZnLumFKC+DcfVzWNlzRKADklrDWFswnXoWzm3RgzETNvSK4Ay2Inh6r4TCG8VbvhnB/Jt2rOMgf5R0rPncRcnGghpYSnHQsiiO2o+YKq4aojUCgBcIR5JvXHE3g/CEHHJa4vsX6RNqewgu+m68nws3/yCMaoLWhjJ19ypDK9oxv7biIIu/KI10iQ/TtvclhdUzEWR7Vgj1Z0VTUnh0+PGR1cqR84Bp8419F8LPlKD7AfWf/4sZiVYpGrOqnkA4BsADVKbpcS3dIdF/wCt288DcL93m7r9aNBvq67kulcLe4WkV6l/ufAFChjgUx8P19omxgG3txebgtSJK0j7AWYah9Kl7tviKfVgPb7x4T79knm3k/iHioyk2CIvkRhQElXNvqT/olY5NcRa0tDA==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015)(7416005)(921011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?NqgxPkHyG1PTqS9EyhE6F95pEOl7vcPSqG7efHBDVNg6brLBJgtEQgWxgtY/?=
 =?us-ascii?Q?KnrA//SYcMz4TlB9mpA8ljwgJgLS3AIdhFtXf1N2NbqLVp7dOg2Un0PgFdLn?=
 =?us-ascii?Q?Qu2Zu9FgmeVenZI95qy+tCiAocvU59oLiHjf4jpmsGeqT8WP2d01NXtOV5el?=
 =?us-ascii?Q?/kNkpD0PeTEu7Er+PWhdPXEXN2C7TY5ZmN5spuSG0OgcdNHe6s7+T5j+ixzj?=
 =?us-ascii?Q?wMdk8FWz3jcaH6afRxV9rHsCpJTWQAD614Q0U9z0c4rTXsEWRmFZ4tC00KSQ?=
 =?us-ascii?Q?80q15o/q3CpzH5dWyHXsInMXfo0IBCUeZI19Nz0oqWFBA9i09nW0b+RjAUQT?=
 =?us-ascii?Q?HHmbgMbgObMIbm5cVu29PgKtOHZ5ZPUOYsGRfkw/BSleem4oTrVc0rx3o8Nx?=
 =?us-ascii?Q?S6kLiy2pLRQrhxzKeqlQ5vAfmPFC8OxNgY0N5IHX0+d0jYxyjBcFt8ZlqPrQ?=
 =?us-ascii?Q?uhxchGqi1Rgv80CxR1Zc/qQqivHK30T3rkMF3SLffXmXGCK/K1Vu1M2/SJiW?=
 =?us-ascii?Q?mSkfFUEXXkEo9iW9eC1z7vFtvtKh0VXjDuR4bpqIlfXLwo1pckLpDiRXsQDw?=
 =?us-ascii?Q?YrNZwRYt2cENx6i+rqo9SvbGkYv98x0A3sWJXLtmqNuOeI6PobAB6fZhafqb?=
 =?us-ascii?Q?XntHI9fKzwwKMsVByLfNmdGcZeoXuPE+Z47VFBVvAvu+CEceYXwzgM4/ma57?=
 =?us-ascii?Q?j2xSai9eZcpcn2wE5bwdRDlLCQ5NAkLxDY1DoGnsSEr+xsPQaGG7shhTN76j?=
 =?us-ascii?Q?+W+Avug0NkiHY8Xb7RiunrgsI1BbmHJyQ8gcggiUYj7gi6iZ67eIfFViVY5F?=
 =?us-ascii?Q?aD8o1zuOjY80eJhYbtP3pM4klehGkzGG99UZ20mlx3E5p6smRLzTnK+EN//m?=
 =?us-ascii?Q?81S8nbpuE8ZxbYfaMwdrZJQPIvKxmpw91Ss9io8ufe11thV3H+Oe6A8pwY3n?=
 =?us-ascii?Q?acq6jbUWPylNxa5MdeVlXxiSnYGtk+mwCrURAQzTm2oUJkqxgnOdSkSQFnG6?=
 =?us-ascii?Q?5hu2IwAJ5/kL9hmhCdyq5cVKbnFYC70aJPhf4cNxpxXDN0ZFRb0GU2wMrTES?=
 =?us-ascii?Q?UtwpjwJFfzueyc733vERNcLZeSMRKumsMSaBj7EkqV7Kq+pbg4IxgQCKldHq?=
 =?us-ascii?Q?YPnVF9vQPNs7k35D5v0xpmHbpVozqpRRRKGwmzGE1v4DYrDXvwJqBkvVPaOY?=
 =?us-ascii?Q?II7pO37GzbVkklSCFSZLF13ZOew5zEPe5qji4EAsWqozwnnT8TZx3WhLKxrs?=
 =?us-ascii?Q?/leXjJ6yjzP8yQsaA8iri/O4bY2LiGoH1Vao4f62X1BgeSd2NmVxdllvzvPv?=
 =?us-ascii?Q?94Xy3ciZ/g+kUCb0IIYWVwESDRc8v5+O9B6CbQR14qXdA0sCflRkGKz9/suR?=
 =?us-ascii?Q?kdUiuxOQ8Ax+g5pRui8Jq40bhp6srye7duGnOVqZ4MCofv2Dg+D7rda2S8tN?=
 =?us-ascii?Q?d33uuS4RbUVpQuFfTREmjo5juwKtFN8IAj427z/S9V6KTS09MM+OSTO4czDP?=
 =?us-ascii?Q?vL601cazhfpFVZQBeKfCym8Y911VN0+j/SxkmNNhnxgIq6PNWoepsENvCVzt?=
 =?us-ascii?Q?C7sGC8NwUpCUB0aXDtheDLHhEsZmE+Ud/CSNKEiEuqxh+Z9JR3EWCgznZDBg?=
 =?us-ascii?Q?tw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	LpD3HnEnN5/yLyQE53uSy1bJrc6s63awy0o5I/i6aFSe5x0yOuq4EiIQqxHbfpFz3rNWhVhuIXY8eLkW1cMuus/GVrn90q9+WxVbS51CW4pfKgPKZYBSd5Gz/1jhypcY1ZmftW3XOBG3KtSeTz6OEJ+tPKRm1uAQ3EegQd6kDkKCv2zdUaE6EPLkmXnTChLvJbK3XaqcPR/wBI5c6rWoA6LivCU5ATbOD3JNlHMj/IEpyH+XgxGnpqt4aKM8DLLzpHWkvL/nm1aVc8VQrzqcfO+/OaWUJU1ONkN+piRTSUGf9cEhfra/zJ/ty9sW6rsNyCaExCnmngQwON56fjjc3CGQLyvKWZcVlK7Wx3wLbMX4YDkB8Z01mB0vCm06jTGZCBpXSsnbCEu/mPxl9/FECih9jrjrbIWs6BYuVeaQHP9bsq3h4LmvjKwmym26XZpcPYGu8qwsxsa2hTQbWd8beoFLy0A/zFuZUqRuVnQAhWysSXCm6ePqSrKHDQ7PVQzdo6B0XL4aRZObV2qtD7t0NNFULv3hmPPITM619Un7kdgkkUCytxIElNe06qQN6A2lLBR0YP6DlUB9+ZO40OyrHZUFAlmuVs1WEV90PoKB2mk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ba5cdca-e015-49e6-b21a-08dc4d9a1fc8
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2024 13:39:13.4946
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 11IgkXFJivE/PS22MAb6YfoKRxRCxvWBmKw00tenn2N89S7zsJyypa3hA+a1izlTHjZlpAuxFKonDNi5sbah0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6666
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-26_06,2024-03-21_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 mlxscore=0 mlxlogscore=999 spamscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2403210000 definitions=main-2403260095
X-Proofpoint-GUID: TPJVMxuv8El5xsMmHwuSYF9cKliUh3v-
X-Proofpoint-ORIG-GUID: TPJVMxuv8El5xsMmHwuSYF9cKliUh3v-

From: Prasad Singamsetty <prasad.singamsetty@oracle.com>

An atomic write is a write issued with torn-write protection, meaning
that for a power failure or any other hardware failure, all or none of the
data from the write will be stored, but never a mix of old and new data.

Userspace may add flag RWF_ATOMIC to pwritev2() to indicate that the
write is to be issued with torn-write prevention, according to special
alignment and length rules.

For any syscall interface utilizing struct iocb, add IOCB_ATOMIC for
iocb->ki_flags field to indicate the same.

A call to statx will give the relevant atomic write info for a file:
- atomic_write_unit_min
- atomic_write_unit_max
- atomic_write_segments_max

Both min and max values must be a power-of-2.

Applications can avail of atomic write feature by ensuring that the total
length of a write is a power-of-2 in size and also sized between
atomic_write_unit_min and atomic_write_unit_max, inclusive. Applications
must ensure that the write is at a naturally-aligned offset in the file
wrt the total write length. The value in atomic_write_segments_max
indicates the upper limit for IOV_ITER iovcnt.

Add file mode flag FMODE_CAN_ATOMIC_WRITE, so files which do not have the
flag set will have RWF_ATOMIC rejected and not just ignored.

Add a type argument to kiocb_set_rw_flags() to allows reads which have
RWF_ATOMIC set to be rejected.

Helper function generic_atomic_write_valid() can be used by FSes to verify
compliant writes. There we check for iov_iter type is for ubuf, which
implies iovcnt==1 for pwritev2(), which is an initial restriction for
atomic_write_segments_max. Initially the only user will be bdev file
operations write handler. We will rely on the block BIO submission path to
ensure write sizes are compliant for the bdev, so we don't need to check
atomic writes sizes yet.

Signed-off-by: Prasad Singamsetty <prasad.singamsetty@oracle.com>
jpg: merge into single patch and much rewrite
Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 fs/aio.c                |  8 ++++----
 fs/btrfs/ioctl.c        |  2 +-
 fs/read_write.c         |  2 +-
 include/linux/fs.h      | 33 ++++++++++++++++++++++++++++++++-
 include/uapi/linux/fs.h |  5 ++++-
 io_uring/rw.c           |  8 ++++----
 6 files changed, 46 insertions(+), 12 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index 9cdaa2faa536..631e9aa34421 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -1513,7 +1513,7 @@ static void aio_complete_rw(struct kiocb *kiocb, long res)
 	iocb_put(iocb);
 }
 
-static int aio_prep_rw(struct kiocb *req, const struct iocb *iocb)
+static int aio_prep_rw(struct kiocb *req, const struct iocb *iocb, int rw_type)
 {
 	int ret;
 
@@ -1539,7 +1539,7 @@ static int aio_prep_rw(struct kiocb *req, const struct iocb *iocb)
 	} else
 		req->ki_ioprio = get_current_ioprio();
 
-	ret = kiocb_set_rw_flags(req, iocb->aio_rw_flags);
+	ret = kiocb_set_rw_flags(req, iocb->aio_rw_flags, rw_type);
 	if (unlikely(ret))
 		return ret;
 
@@ -1591,7 +1591,7 @@ static int aio_read(struct kiocb *req, const struct iocb *iocb,
 	struct file *file;
 	int ret;
 
-	ret = aio_prep_rw(req, iocb);
+	ret = aio_prep_rw(req, iocb, READ);
 	if (ret)
 		return ret;
 	file = req->ki_filp;
@@ -1618,7 +1618,7 @@ static int aio_write(struct kiocb *req, const struct iocb *iocb,
 	struct file *file;
 	int ret;
 
-	ret = aio_prep_rw(req, iocb);
+	ret = aio_prep_rw(req, iocb, WRITE);
 	if (ret)
 		return ret;
 	file = req->ki_filp;
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 294e31edec9d..058a27a30d21 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4581,7 +4581,7 @@ static int btrfs_ioctl_encoded_write(struct file *file, void __user *argp, bool
 		goto out_iov;
 
 	init_sync_kiocb(&kiocb, file);
-	ret = kiocb_set_rw_flags(&kiocb, 0);
+	ret = kiocb_set_rw_flags(&kiocb, 0, WRITE);
 	if (ret)
 		goto out_iov;
 	kiocb.ki_pos = pos;
diff --git a/fs/read_write.c b/fs/read_write.c
index d4c036e82b6c..a7dc1819192d 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -730,7 +730,7 @@ static ssize_t do_iter_readv_writev(struct file *filp, struct iov_iter *iter,
 	ssize_t ret;
 
 	init_sync_kiocb(&kiocb, filp);
-	ret = kiocb_set_rw_flags(&kiocb, flags);
+	ret = kiocb_set_rw_flags(&kiocb, flags, type);
 	if (ret)
 		return ret;
 	kiocb.ki_pos = (ppos ? *ppos : 0);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 00fc429b0af0..c0a7083a62c6 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -45,6 +45,7 @@
 #include <linux/slab.h>
 #include <linux/maple_tree.h>
 #include <linux/rw_hint.h>
+#include <linux/uio.h>
 
 #include <asm/byteorder.h>
 #include <uapi/linux/fs.h>
@@ -121,6 +122,10 @@ typedef int (dio_iodone_t)(struct kiocb *iocb, loff_t offset,
 #define FMODE_PWRITE		((__force fmode_t)0x10)
 /* File is opened for execution with sys_execve / sys_uselib */
 #define FMODE_EXEC		((__force fmode_t)0x20)
+
+/* File supports atomic writes */
+#define FMODE_CAN_ATOMIC_WRITE	((__force fmode_t)0x40)
+
 /* 32bit hashes as llseek() offset (for directories) */
 #define FMODE_32BITHASH         ((__force fmode_t)0x200)
 /* 64bit hashes as llseek() offset (for directories) */
@@ -317,6 +322,7 @@ struct readahead_control;
 #define IOCB_SYNC		(__force int) RWF_SYNC
 #define IOCB_NOWAIT		(__force int) RWF_NOWAIT
 #define IOCB_APPEND		(__force int) RWF_APPEND
+#define IOCB_ATOMIC		(__force int) RWF_ATOMIC
 
 /* non-RWF related bits - start at 16 */
 #define IOCB_EVENTFD		(1 << 16)
@@ -351,6 +357,7 @@ struct readahead_control;
 	{ IOCB_SYNC,		"SYNC" }, \
 	{ IOCB_NOWAIT,		"NOWAIT" }, \
 	{ IOCB_APPEND,		"APPEND" }, \
+	{ IOCB_ATOMIC,		"ATOMIC"}, \
 	{ IOCB_EVENTFD,		"EVENTFD"}, \
 	{ IOCB_DIRECT,		"DIRECT" }, \
 	{ IOCB_WRITE,		"WRITE" }, \
@@ -3404,7 +3411,8 @@ static inline int iocb_flags(struct file *file)
 	return res;
 }
 
-static inline int kiocb_set_rw_flags(struct kiocb *ki, rwf_t flags)
+static inline int kiocb_set_rw_flags(struct kiocb *ki, rwf_t flags,
+				     int rw_type)
 {
 	int kiocb_flags = 0;
 
@@ -3423,6 +3431,12 @@ static inline int kiocb_set_rw_flags(struct kiocb *ki, rwf_t flags)
 			return -EOPNOTSUPP;
 		kiocb_flags |= IOCB_NOIO;
 	}
+	if (flags & RWF_ATOMIC) {
+		if (rw_type != WRITE)
+			return -EOPNOTSUPP;
+		if (!(ki->ki_filp->f_mode & FMODE_CAN_ATOMIC_WRITE))
+			return -EOPNOTSUPP;
+	}
 	kiocb_flags |= (__force int) (flags & RWF_SUPPORTED);
 	if (flags & RWF_SYNC)
 		kiocb_flags |= IOCB_DSYNC;
@@ -3614,4 +3628,21 @@ extern int vfs_fadvise(struct file *file, loff_t offset, loff_t len,
 extern int generic_fadvise(struct file *file, loff_t offset, loff_t len,
 			   int advice);
 
+static inline
+bool generic_atomic_write_valid(loff_t pos, struct iov_iter *iter)
+{
+	size_t len = iov_iter_count(iter);
+
+	if (!iter_is_ubuf(iter))
+		return false;
+
+	if (!is_power_of_2(len))
+		return false;
+
+	if (!IS_ALIGNED(pos, len))
+		return false;
+
+	return true;
+}
+
 #endif /* _LINUX_FS_H */
diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
index 45e4e64fd664..191a7e88a8ab 100644
--- a/include/uapi/linux/fs.h
+++ b/include/uapi/linux/fs.h
@@ -329,9 +329,12 @@ typedef int __bitwise __kernel_rwf_t;
 /* per-IO negation of O_APPEND */
 #define RWF_NOAPPEND	((__force __kernel_rwf_t)0x00000020)
 
+/* Atomic Write */
+#define RWF_ATOMIC	((__force __kernel_rwf_t)0x00000040)
+
 /* mask of flags supported by the kernel */
 #define RWF_SUPPORTED	(RWF_HIPRI | RWF_DSYNC | RWF_SYNC | RWF_NOWAIT |\
-			 RWF_APPEND | RWF_NOAPPEND)
+			 RWF_APPEND | RWF_NOAPPEND | RWF_ATOMIC)
 
 /* Pagemap ioctl */
 #define PAGEMAP_SCAN	_IOWR('f', 16, struct pm_scan_arg)
diff --git a/io_uring/rw.c b/io_uring/rw.c
index 0585ebcc9773..2ad2256d4acf 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -714,7 +714,7 @@ static bool need_complete_io(struct io_kiocb *req)
 		S_ISBLK(file_inode(req->file)->i_mode);
 }
 
-static int io_rw_init_file(struct io_kiocb *req, fmode_t mode)
+static int io_rw_init_file(struct io_kiocb *req, fmode_t mode, int rw_type)
 {
 	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
 	struct kiocb *kiocb = &rw->kiocb;
@@ -729,7 +729,7 @@ static int io_rw_init_file(struct io_kiocb *req, fmode_t mode)
 		req->flags |= io_file_get_flags(file);
 
 	kiocb->ki_flags = file->f_iocb_flags;
-	ret = kiocb_set_rw_flags(kiocb, rw->flags);
+	ret = kiocb_set_rw_flags(kiocb, rw->flags, rw_type);
 	if (unlikely(ret))
 		return ret;
 	kiocb->ki_flags |= IOCB_ALLOC_CACHE;
@@ -797,7 +797,7 @@ static int __io_read(struct io_kiocb *req, unsigned int issue_flags)
 		iov_iter_restore(&s->iter, &s->iter_state);
 		iovec = NULL;
 	}
-	ret = io_rw_init_file(req, FMODE_READ);
+	ret = io_rw_init_file(req, FMODE_READ, READ);
 	if (unlikely(ret)) {
 		kfree(iovec);
 		return ret;
@@ -1010,7 +1010,7 @@ int io_write(struct io_kiocb *req, unsigned int issue_flags)
 		iov_iter_restore(&s->iter, &s->iter_state);
 		iovec = NULL;
 	}
-	ret = io_rw_init_file(req, FMODE_WRITE);
+	ret = io_rw_init_file(req, FMODE_WRITE, WRITE);
 	if (unlikely(ret)) {
 		kfree(iovec);
 		return ret;
-- 
2.31.1


