Return-Path: <io-uring+bounces-5815-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 96504A09DB0
	for <lists+io-uring@lfdr.de>; Fri, 10 Jan 2025 23:22:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 954DD167049
	for <lists+io-uring@lfdr.de>; Fri, 10 Jan 2025 22:22:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFAD420A5DD;
	Fri, 10 Jan 2025 22:21:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="C8yjZNTM";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="FXiNu8+k"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8038208978
	for <io-uring@vger.kernel.org>; Fri, 10 Jan 2025 22:21:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736547718; cv=fail; b=fxGncxEA647GCIXUwkGlY5iTSypTiJVM443uVNyPNT2W0+A4MOuwNJXndaHSvLGjliGPa4bqfC/ppJx1tCVGS5S7r7gVi1vy+3sMoATndYtIDA4vKrM9CHnwSXKe4APzQzxf9S7RXuykLr5dw9kP3zyI4nb+ZVS5qOBENjvj4Cg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736547718; c=relaxed/simple;
	bh=gVHUsw5p02ku14xj+qEXeN5g01/UNiyOlerkDj1AnSU=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=Q9XK9gCqiUbXEuY88/r0KgFiIf+uuBGJ5GnKtrgyrhhWWqj5m5n8erV4QSMZGeRknyL4wEEdmAAyheHigEy5qvxK8Utj8MrX9b8KFx89pNWOqnh5rJjANf/A2a1XRQ7ulTAR7PSqKfoLg6G3SXwfwIaNhIRXDidcw4qS9UuH/34=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=C8yjZNTM; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=FXiNu8+k; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50ALBuVs005969;
	Fri, 10 Jan 2025 22:21:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=+hDfM4exhpDR5Eghko
	rkf1a5F6hdPFhKcI0uUJf7HZ8=; b=C8yjZNTMD4ezBpaF3yFyXmMmZIc2kX88LN
	jJOexbUhm4zk57wm2VzGliYtCET7uzjK8UpxQyyKybrAZVHLFMwzMM1zXYejAYSJ
	Q4WOZRDldnMNrtywsXCS1NUxs6WPpgGFMrgKykSc9NffI3Ir4L1b/8dfp1Sdo6g1
	jmyDoWGyKBRsr/bO/zWlUsVjCxQvkS4ht9njGyO6wRANKWVwq2rOUqxIK+WGb0ln
	K7WeH8kC2d4UBi+KF8kRx6IDEO/JWmtXR8OF1kKki7mi0NRrL22wq55lkSv63c62
	lLj8Mo5QMAkWHgf0AR7cONVJ22PjSECwss2EuiF/a8JVNhCBB7QA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 442gy5ttsg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Jan 2025 22:21:52 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 50AM6nlf027558;
	Fri, 10 Jan 2025 22:21:51 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2041.outbound.protection.outlook.com [104.47.55.41])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 43xued7h1f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Jan 2025 22:21:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RIPmctj6MT+C2UxcGcCc0JWvQC+yfbMiKXbAED2pHHOE5MbWT/syWFD5hskJBLBpkZyeCQTOfue8UsRrq52njFhqVdbJuHU8VftETXhzUKJiQ8xbiuyFQtc/75+RlHUj0N6oa+CqFIDTb2/zyQAeBXhANwjlDRj6aiUhbmY/GaoGVtRd5xdKzOn4c9/9sK4G6xnKomIyoVDgHFZSAMqRNOujuO6k/iXsee+WVbBfF3xwNjvgYp3LdWevoYINl2FZerxQgEjzsYJ9wVhPWJrzcsKS6LvkId54eNk/7Mq8NvD/Uao0KbkYFh9ugp1E2f1otSzkiv9gP+tRNhlsMET9tA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+hDfM4exhpDR5Eghkorkf1a5F6hdPFhKcI0uUJf7HZ8=;
 b=Gmz2yTKZNgBp2SfM8afC2HRW0VTfnLg8PVdoabG/LKOlkCavQV+5QXoym7Z1z2RiFcbLbLM2m9kf7ZMvgpCNr3wDZjuZo56iRqp1lr+wAuYWxd1cOgv9t5/cWUIxAQI1JaPoChoYCs/U/y4iFeLeXtzBbg2KxSFtMe39hVg7GtWP5u/Db+CA7ZzH6bsw4KV2JSeO8DmMn2k0lTCAjr3cdyVcnlczLcYdXlKVI9oEl+RUHoK25bdiP2quG/iCn5jSfd8hsqpGXWFBBbHGo9kdqN4MsUQRTys2KX8Zza4Op2IlMLeRWLZmzxz1fAGypbW8kFwoOW/fQrYHFai1RomqSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+hDfM4exhpDR5Eghkorkf1a5F6hdPFhKcI0uUJf7HZ8=;
 b=FXiNu8+k7bDhtL2RfxT9JNR8ooapwzUmSP/kwI/zebbOWIpeT1PbI4NuVKPQXKZRBRp4tqbx6D6/Yo0bnCXspT9JDMAqZD3LLqT8Uq0/a+JPiGCotWWnEZ9+8XPnHgog31X5GUVHmc0hj43KQUGNajxTa4JJtoYa+0WCQsNVCZc=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by LV3PR10MB8059.namprd10.prod.outlook.com (2603:10b6:408:290::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8335.13; Fri, 10 Jan
 2025 22:21:49 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.8335.012; Fri, 10 Jan 2025
 22:21:49 +0000
To: axboe@kernel.dk, asml.silence@gmail.com
Cc: Anuj Gupta <anuj20.g@samsung.com>, <anuj1072538@gmail.com>,
        <io-uring@vger.kernel.org>, <vishak.g@samsung.com>
Subject: Re: [PATCH] io_uring: expose read/write attribute capability
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <yq17c7cewsl.fsf@ca-mkp.ca.oracle.com> (Martin K. Petersen's
	message of "Thu, 2 Jan 2025 16:22:57 -0500")
Organization: Oracle Corporation
Message-ID: <yq11pxa5n3i.fsf@ca-mkp.ca.oracle.com>
References: <CGME20241205062910epcas5p2aed41bc2f50a58cb1966543dfd31c316@epcas5p2.samsung.com>
	<20241205062109.1788-1-anuj20.g@samsung.com>
	<yq17c7cewsl.fsf@ca-mkp.ca.oracle.com>
Date: Fri, 10 Jan 2025 17:21:46 -0500
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0096.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:191::11) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|LV3PR10MB8059:EE_
X-MS-Office365-Filtering-Correlation-Id: 5ab54772-cf4a-4220-099d-08dd31c52d26
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?fsIh/G3TapaQwMOQ0hYxCBO7O98WmoXDW/hbERiEtlDp+VsD10BDP/dm/Hnj?=
 =?us-ascii?Q?gTvtTWYmvakBxNC0Nzz2Y9+/GUW3HTMQUFL0w8lSbfByel7qXpc7wP2lkORj?=
 =?us-ascii?Q?bSaI/zEY6LleGG4ENm43R5+3kwILH/OnpJyCHeq7gngDV891Sl/41myfamGF?=
 =?us-ascii?Q?9q4eV2mP2RDb49+3IaVldnk5HhwgFPjrNn80FuydlXY8xB2cKHiFHcxvmBFu?=
 =?us-ascii?Q?Pqj/XdVrQLV5ImhvDBnQqb9EGK9CtKN/QyH+M/1/zUQa42ICLPxOXRHSNijF?=
 =?us-ascii?Q?7T1j7VDxKL2Qdh/fOmicf0PFo3okTA0X+vc3u8gBtmYvDv+C3xp6H6qvZ2CK?=
 =?us-ascii?Q?wh6llqSfR9W8/ijHjFqu5NW3TF4oPGqmfkIdhVhBP8oHshUD+rg8CiRMu+Xv?=
 =?us-ascii?Q?Ka8lfc7S8r1TW1P0TjOQsrRNIqlHcfLe+AGgTU7B2kp+QUUCOPT8YJHdB7ei?=
 =?us-ascii?Q?C32+T8E2qrZu0MGAcWVN2ZdPExVvygygiZaM+7Z0r3j4wkq97lJH9FdjUS50?=
 =?us-ascii?Q?0oGNrMQPOjim2/5FksIXj1T22jFeh7semZBRTeh/RfL45hz8tvq2p5GYs5Oc?=
 =?us-ascii?Q?OlGq8WdXLshi0KHiUJGKW9H1Aep4DDukNaEi/BCm/h3SzpimD9gdVCtsiRVg?=
 =?us-ascii?Q?Gl9Bo8LCFtWgjIkbBalLzdbTC4LLxBZCz/SJ2WvWwPYKKxv3D7a5lpFioVIQ?=
 =?us-ascii?Q?45x5Q3dSbUriE7KwWSpw87GDXKHMxpuVp2J3vsBiDf/iZdW+Avw86B4JFSAC?=
 =?us-ascii?Q?rlkGAS55/J8Wvm1elb0mkkLrKve7/MpaoGHcf3YvkSpwEVxDqFnc/uzDzz4W?=
 =?us-ascii?Q?vbt1EXQwlK84+XZqxa0f5UVOKju0cGMGPYchqwOpz8u/tNiYXYwgVLheEX65?=
 =?us-ascii?Q?bWEDOmZjVDQIaiaax8aYyH4uaTUQXjJLy2C5OeLDHpDfkfiSFKoDShshQwBF?=
 =?us-ascii?Q?aHehqxmszMUS/Lj5DRhidxuiejbTSbz5cCpfq4XEd1zcSPBjLLfx5ZJhXpmG?=
 =?us-ascii?Q?TDIVF1TJ23gbkMvP0gjhOFEl5yYESVhXHS1j/7TsoOSwS73kttkP633ULzV3?=
 =?us-ascii?Q?cn5FwxuYELYFCwXfPbu4CNB2oHGTBT1mTcL6M3L2g9OwwKhhLAkbM4xsCALi?=
 =?us-ascii?Q?dJzn/M9WVtVhOiOrTVKnJVK/NcYp4hdLWNvqOEynl6fyTRQ6hHsYrsqpzjZ2?=
 =?us-ascii?Q?m8D3O53beEv/0cOlcnDAOV2+omZ8XlTbyF0Aha+c0nydy4ZOAW0GpMM0TuHK?=
 =?us-ascii?Q?JhIBvgBfIt5bWuo0EzI6b9aHVyVTwNCpnZUdfKurxDr1QUiD/bvnTY7scHdL?=
 =?us-ascii?Q?V7zmLa02ldjXEZzSbOW/68/1h7/dJkTibjbzKUFrYGaS1w81p1vB+l26ESDK?=
 =?us-ascii?Q?3RV1l8SzBYic6//dx80Qa3svaclW?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Ct0gwSkDWQGJ9Kduh+iH4lUSTIfFiT5R1BSGJnmfq9wpQoXuPe/A5gRsnnGF?=
 =?us-ascii?Q?EVsnda8Y2bADnuLFiLuxKpWdNAhkUR1PiHR4dKRrfsCignFFCuXZGoPuFMVb?=
 =?us-ascii?Q?aQZMIOtBxCwDcyNEepHhAA3ghaYTPu9AhbJeC4wbB2oy/KxJJZzhWTa2CSMG?=
 =?us-ascii?Q?qlra2RKCm8wa9JTFTUgk6oObwG9bmnNor0nrnG/DjeXF0h6CY+ZxBbMhY/f/?=
 =?us-ascii?Q?15h/XtW5Z6eAOutk4TZ6H/ZEo6Ly6iW3HYEjp43dbwSz0TvWc6+xPjoQdGW8?=
 =?us-ascii?Q?zzU7RkCYm4Mu9xLzRBFHadUk7+VUeNBzsYGwPbuw2H/Ps4fn+BiEF3hytoux?=
 =?us-ascii?Q?ztUrxX1gddaTliejXbTVJZXcJZr1xDGuucY2tvtANZvzhQprKC4CxHMjvpT3?=
 =?us-ascii?Q?+nB/6jankgoft2Q5I8oycKL3sUzHNT1mt3ZRj3OBMu33W1XJpvDBR8ByYFqe?=
 =?us-ascii?Q?y/GkwPD/znZtlKHA0CNYNpEl2jF0WpFD/JH87VQ19+fctj/p+4elEY9db8ct?=
 =?us-ascii?Q?kHEPfTagce+4sDWkFWny3YSpgL9LqP2wYWT/DUzeh5s/65XTpnaN8ixjOwfV?=
 =?us-ascii?Q?U4B1il20RwVFF6hHcUAaWt06/Skp6Nb582FK0cDrDC1PXXWZ/Rh4Aw7gk/Y+?=
 =?us-ascii?Q?vStWVnJDYd0DKJs9jPe4It8ET2sanSVzcDj+wq5KnGqUzjlzNPdLHteW2OaV?=
 =?us-ascii?Q?XzKIx+i1dvRHS0Vm4lD120xsD3DPTBQ6duVqymRhnvnN3CONBEZEox8qWb+v?=
 =?us-ascii?Q?BCUavjLUJcMhDYjDiKWQW9/dz+e66Om9ghiPkx4grkxgLgqfoTpmQNzhe5d0?=
 =?us-ascii?Q?DezychWsuvAOjiz7RYSsG/uS6sVnZlyzq7rRYttzmUfFEf2OASml86no3szo?=
 =?us-ascii?Q?+VM+OMHGwkAcKwfT5gi3wIHvshTFb1STXH38HPlTJb5RiLoGYniEtdeuilfC?=
 =?us-ascii?Q?wgyIy9aAr59EFPTrg9DMc8alkQw2lo/v/k+9T9wZT6DtJt7cLmH3m84TW4VL?=
 =?us-ascii?Q?97wy8PD6cyo4dCiw6IYTiZ4nUri+Lx3zncwL3Krul0TOTDlrzRCuBDyh9FcS?=
 =?us-ascii?Q?FGXvlR1OUkQ8w65xYM3xHc1CSvw4tPLRYuC/E8q26ZQNeqV4XoLHtdUT502h?=
 =?us-ascii?Q?+gd8e4ZBIWKvNjBoXuAlDshJVM6Ncy7s8mzsQRY2CQcSHbUYZ3Wshri/FRCe?=
 =?us-ascii?Q?qO3UZS6DWlUWGbDEEb/P9OsLuq2VHfptWTwkTK6SmjV8LI7iWoW/u69Kgry6?=
 =?us-ascii?Q?5x2ivRqI+1bXvviR3Iah98F5Dp1sxS4Ud/4s8qJarXA5MQh3lycbiKM4QPZ3?=
 =?us-ascii?Q?1Mq01gx2sVUFfUpN0TQpI3qV6N/sf3amqQhpj3JCpDqmis3WB4r0vGbwkSSZ?=
 =?us-ascii?Q?wn0EXCeI/b+hxyjAbUH7AovsM5vRiyx7k5y5Lxu6Yi7bEScsrRsmIrhFilkx?=
 =?us-ascii?Q?pth8Jae9bAVYLApdr8TzKc3R34eNz7u22kcrckMD1l8OnB7D0ralhgQE40Uc?=
 =?us-ascii?Q?+SXXsxhCBmJy/Sc/ia2U4laHtVgwrGJThEnVtn9Layianw6LGZFe5d07xssj?=
 =?us-ascii?Q?ye0ODQPRWj0tsvf1WwU5k3rMG/aP3MC/t/cVlBathCG7iujN4SG0nqxCNbJ4?=
 =?us-ascii?Q?Kw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	7BHM9RYvK7b78IlaVni4G+gp99kfL97QQ0TGstKzekn2ekgB/nWJtV2wBSkYMG4sWA7j2QuhoQgjaoM9eJv8xYS3yapposIuNPty8yHEdNUFdrlLnraqa2dx9TjAqY2MB95wgjpvTCVbvFjva8fpBEF0K0elEqaO70L2CU1klIraGLxpgBIlN1Pyd+nhHrPZLRbPSlA4PBjYksydlBAqJuD9qGDtfP5vmwow78dtyzaOoFyzYmlYZPcg5psjkJcY6vhEwwSwABUgJA5fT156PuOduTY28VFBRWRw/b/4BMA+MuZT8X3WpJE/hfH4kUw5uH9biuEnAhDCRwXwGxZpcFrxoSr9NPJtZJrXcuF3yRPWx0pdtALQuwpaUTTAQnwebABf5ORmusZVodeKuUPyw3irFTlIZb+yTEAed0BQs2fETAKcRExNs5PGlcyJwWQ66Bypv3poX53wNi0iIDW36J0ymi0oT/HNe6cXNOxtYy3bCGu/oHlDYo09wVOLK7+8DBzhKN523iKPbKkefoDZUzdncKt0aoM5RLehqpKhZym9JMPxksXN5JAvRlp9Ogd0CSRcuu/vYtIAgWTXs3l9pkwmkBHndIu+hGPK3GwtCM0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ab54772-cf4a-4220-099d-08dd31c52d26
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2025 22:21:49.3387
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LNiSXVow819oEQLDPrElGOSdcMuUESulRbMxjxKCrM1nadLOMYkinwho5QpXA20fVbf3QQveDH3c+GgWITyWVQWNNI1eXpDOJhZApA64tVA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB8059
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-10_09,2025-01-10_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 adultscore=0
 malwarescore=0 phishscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501100172
X-Proofpoint-GUID: qUdBT6Zsii6HU64sj3bUHZ-FbmHTXUHr
X-Proofpoint-ORIG-GUID: qUdBT6Zsii6HU64sj3bUHZ-FbmHTXUHr


>> After commit 9a213d3b80c0, we can pass additional attributes along
>> with read/write. However, userspace doesn't know that. Add a new
>> feature flag IORING_FEAT_RW_ATTR, to notify the userspace that the
>> kernel has this ability.
>
> Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
> Tested-by: Martin K. Petersen <martin.petersen@oracle.com>

Jens/Pavel: Ping? Would be good to get this into 6.14.

-- 
Martin K. Petersen	Oracle Linux Engineering

