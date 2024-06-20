Return-Path: <io-uring+bounces-2295-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EDBDC9104D7
	for <lists+io-uring@lfdr.de>; Thu, 20 Jun 2024 14:58:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 99A13286DCF
	for <lists+io-uring@lfdr.de>; Thu, 20 Jun 2024 12:58:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E7B51AF6AB;
	Thu, 20 Jun 2024 12:55:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZOzDPRgS";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="RhYo1New"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 598A21AED54;
	Thu, 20 Jun 2024 12:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718888113; cv=fail; b=Uytap/R2WC8QKQ7+egiigF9YFlc1qojxKgbv8euv+Gj6v5XsH/aHSunB6KiG72FLaGSJ+d6dIWqJJKWLjsr2F2qKUZ1L55/LMWUB/K1kvFMwMQdK1jHFaSlVyr+AaqTfK3EtYh5T10H+JgEd4ZJEaCdK3LAOWA52Wfdq6ouKM38=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718888113; c=relaxed/simple;
	bh=8KSc8a/Rya2oJUvCyyrt8iGzudHItq+VtCAidAfLNn4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=qnBa0Npz8fZUpWpmToJyuduELSb5n4P25D3e4WjqB6oe9d4JxnoUEvCPofRvTLmFJeDdA2k+kChm8vWzEdM2NIwKFGqtLyvmXS1tXok0Lo6S1eH/OtYeOZqOHuTYXlO7WhPY7oWPMaGGfVdtva2t8amJVpBpdmX1JQG3qx4FmX0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ZOzDPRgS; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=RhYo1New; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45K5FHeA018254;
	Thu, 20 Jun 2024 12:54:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=H995haILi1kcMMYMLd04ROHekDQAV1cD97v6pfBgazY=; b=
	ZOzDPRgSIwBeHZNiyYpL2YP9yzQgaPaSMm2BIWIZ02XQQxNC/7tfP1HnI/enlZoC
	/C3MbFr6Tb45cpuHx6Ybw3AxxlBhrQwU70ltPkpX9yRKDeXFD/or/AyUXbaxk4xv
	w2Xl3srLpTSqwK6YW+CDqYMiU1jVEDaNX2ODcoMg4vI6lvhW8gDdtYocCsNA3x07
	XHUmsQWEaMpwEYMvrlg412y4AiwQ/L9k+dqYL2BCSkCzwpdL/WLkF+fj3PwHpTow
	v9KJq5m7flsKthH4tSS8PdLHY1C37TRoglKjr7yWYnqn/JSaB/kGfyA/Tegse+Ig
	OIDJkQc3LZx08GGOLaH+mA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3yujc0b440-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Jun 2024 12:54:39 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 45KC2M1w034751;
	Thu, 20 Jun 2024 12:54:38 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2040.outbound.protection.outlook.com [104.47.56.40])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ys1dap46t-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Jun 2024 12:54:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fJdhZJXJ3GGbYAWGd3+3dg56DsVjjLW4ft+dDxPcPc1FtoOwQnGT0rmJbJVrqaHL50qTcT2GOlfKesZEkkLa0DTGToOFbjLX8rMz6Fbp+93Mbp9Tun7w/Gm8x7eMzvus5cROcYvGYli8bMCukQhCmZtZxu0yhRNSr628FoWYTWzpUyqrmY5dS6fPN8QGRUQoFJSFQQMx0tANxsFsxb0q/z0FXJp7kRiPtRi8aaPvRD4/3tlrILFGmTSX4uXeGd9Uq4Tkf1hlM2/TCsQ6t6gHQPLOpR8qIiZgKQHEWiK2M9wGHTUETDVn3JvrNGSOVdGZ126RdFveRHcp3UXuYyYY9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H995haILi1kcMMYMLd04ROHekDQAV1cD97v6pfBgazY=;
 b=UET2kLgXAahVl8nI8cOapv2BMSUXYaJUZWyf/JArSMx5afWMVIW284ovKDAT7C3o38ULA+mrOpN1YqkOuR3dGXb8li0MeX5NzrSDQ4l3nsWAcxC5TlwwWH7SMdjuOTXEOu1TQet/4tKbI+Bv7+ppvSFf6AngUksHF2cXlRk4fvZ2BGck8wtvuZFNO1uRYM0mktaIcIiMG8lHeddwK5KkG9dv6RLlBFzqrlMZ+tvAdYCNBypPgDnShEKBih/udOhYEc6PQMpXkVD83ap4U7D2scJTMzhzEirGH851ls86K2DpKfXLNic0825WH0wBwG58xeXAWo6PZ7PNV26HahW2Kg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H995haILi1kcMMYMLd04ROHekDQAV1cD97v6pfBgazY=;
 b=RhYo1NewjyBQatT0obdomdtGcdJhSAhlgmT3KeVhRVfnty4ARTWUFe3WhIGei+gsn6euAsFW/uPeTe5YoSeop3f0UUm5jgVB6K2rBjQcaaDH87Vi6WWY/cyEA7pXf11dbLgbtv9gJgqENJpKo/8CtweSMs2+LL6AIYua3ElkTCU=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by PH7PR10MB7695.namprd10.prod.outlook.com (2603:10b6:510:2e5::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.31; Thu, 20 Jun
 2024 12:54:36 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%6]) with mapi id 15.20.7698.020; Thu, 20 Jun 2024
 12:54:36 +0000
From: John Garry <john.g.garry@oracle.com>
To: axboe@kernel.dk, kbusch@kernel.org, hch@lst.de, sagi@grimberg.me,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        viro@zeniv.linux.org.uk, brauner@kernel.org, dchinner@redhat.com,
        jack@suse.cz
Cc: djwong@kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-fsdevel@vger.kernel.org, tytso@mit.edu, jbongio@google.com,
        linux-scsi@vger.kernel.org, ojaswin@linux.ibm.com, linux-aio@kvack.org,
        linux-btrfs@vger.kernel.org, io-uring@vger.kernel.org,
        nilay@linux.ibm.com, ritesh.list@gmail.com, willy@infradead.org,
        agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com,
        dm-devel@lists.linux.dev, hare@suse.de,
        John Garry <john.g.garry@oracle.com>
Subject: [Patch v9 08/10] scsi: sd: Atomic write support
Date: Thu, 20 Jun 2024 12:53:57 +0000
Message-Id: <20240620125359.2684798-9-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240620125359.2684798-1-john.g.garry@oracle.com>
References: <20240620125359.2684798-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1P221CA0003.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:2c5::9) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|PH7PR10MB7695:EE_
X-MS-Office365-Filtering-Correlation-Id: e8ba7b6c-c8e8-4ddd-d5bc-08dc91282383
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: 
	BCL:0;ARA:13230037|376011|7416011|1800799021|366013|921017;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?9NI5pADxDkfhzQOYYtXELt3ffPbPNBgCRiZFXDP3gsqEmvLDx/+OUYZ7R7Br?=
 =?us-ascii?Q?6Zw+WtGW5xl2fWwcepfi352laWJ0RAmyzrFAFYGdxmLnxHhK8T2M1S1OoZBF?=
 =?us-ascii?Q?P7927KcpN/IWpHE0HmH8RMjBycXnY/kpdUYNtUMW94Zz9CwTPNOsHXbcpX8d?=
 =?us-ascii?Q?BiW4OSfezR7+uy0OrcTDvA3CqN1JPKqo0qYsT2QBGccqeiJKYaz30FcF56/F?=
 =?us-ascii?Q?AYadMmXxgn82n6/7kBuaiwXv8CWWrVpQyRsV01ARbwf6bvx+gOI48vvsPxwL?=
 =?us-ascii?Q?2XxJpjQo9nFr2KAnmyZuaNllMTU6sKT+dEZTq99pju1G2RUH8E7SP5eqxhix?=
 =?us-ascii?Q?ekK02U533MJOfkgCpz1Pfj88RIDxQXAazGRwdxDr4wMZ23u+M2sbEl3Lcd78?=
 =?us-ascii?Q?m2gwUO63bjsqZQpRc+MONBN5u38mhbLTZzj3JqwPakGVggoJU4J3/24NN/fI?=
 =?us-ascii?Q?pq+gOO8KOD2e2uGwULLGU/66yNvzcecXf/zi/s2teAbpAI2C53zO745XqJ7H?=
 =?us-ascii?Q?J4qwfcFfwToFA/zvryawxG9l5nkz2BVxiyUeYZ5VKfQlD72IBw0qqE3u6Cdm?=
 =?us-ascii?Q?ehMePbI9VSXAdnCt/R9HVznhm4eNcEuBKphBfOkX6avBMJxw47NNHUZbSkwU?=
 =?us-ascii?Q?HEKCDPKEu31flSQ6LrPfMNbEuAHbmx/WMYnSgpbt+g72enOwK18uebFN4oy7?=
 =?us-ascii?Q?QWAo3iJF54Ypf4N94nLGF4GGoO5QAf0vWWcc6fczE0BPbuG8pFNJQ/lE5kgD?=
 =?us-ascii?Q?3LU+5Gof0Ly1pweiD56prcmpeDS9+2B11VLy48i1HV+6RveQkYITWCHQELUm?=
 =?us-ascii?Q?B7PkDV0FlD+j0IE+//V/B0FUH3zsREfvqEJ5q5L/B/DQ6ovuEbaX/JLXP6SU?=
 =?us-ascii?Q?H8GdmC1d9UdnDLb56UM8K67nhVnGmvKXxoNUp+eR6Dy5OG8uQjNYS5ro2BZt?=
 =?us-ascii?Q?wV/WwSidaXVgKFawOb8w2r54ePW/qfn2V6jj7xNY1qpKiYfa5eKiVi2vdLgC?=
 =?us-ascii?Q?XwqWURksnVSLcB2e+2IH/ZfJfV1PXI1KrXOETD/xFhG9dPENZ5fGhJeKw99M?=
 =?us-ascii?Q?ynmVg9qKTKdeMqmU+YtElxHTSOo4n6ktUY6xOqLk0FPse64Hn2imUAUhSQP0?=
 =?us-ascii?Q?6m9hScDdKCWz4GKSUKQuQc4EcXT6R4qZKdF7UlJIUKQnEG099GjI3CZxjJ04?=
 =?us-ascii?Q?3HqWVNKq6MRyJdSRpVXeXxgvaP2fmTNHu5BrD8+4qFLkC8T6hp63CClLOkfE?=
 =?us-ascii?Q?IR2bNd6J9F5/Ah3s8PAAsozqZg1jI/3nF6I3tp2m/NZ4nN4+9XPtDBQ08P2R?=
 =?us-ascii?Q?9YWure+YiaQeMZ507yqtQOIM87rTy1bviZA622FxdwZrfgvrKUEy1Tb+FN5J?=
 =?us-ascii?Q?Cn5AiWg=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(376011)(7416011)(1800799021)(366013)(921017);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?Ih2o6cOknyfmEAItgq0ffiJogw/03MP8h78vJcR5piN3SZYMKS//OYIcNq1Y?=
 =?us-ascii?Q?iYsnim2jer07rjqJPCPSXXJOAH28+MtsUCJjD8IVeGlYWHWkC9tbJyc7b//Z?=
 =?us-ascii?Q?bOmexDrCzlm5wifVHx3Qc8ze838Gorl/GT09r41qHoach0BqCj9un2CchtBv?=
 =?us-ascii?Q?lnmW8yLcCUWNSjPTyvVZke+oyW3Z2Rw29TWmIJuyBKL5U2wgekrO0T7Y1gON?=
 =?us-ascii?Q?6r/q6bTmVqcM5eXcSwLjst5hGqqw2LGDmDERVVQxXKdYVWaxHzgbyAyQfoy/?=
 =?us-ascii?Q?yeQ5EDhuLAyRnkXTp27GCeHyy1aM3Bim/FsSQrUPYAM+jCY5ECZGna1sp9y1?=
 =?us-ascii?Q?tc7aPKSefEx0F49M65q1CcqH0az5Ut4Hq19RAQHY05nKeex/YjuS8MlFqprW?=
 =?us-ascii?Q?vryHyc7G2NmJTMF53MPkD407KVRDWF07DCM7FBkna2fcEcAbVjdlrkIsbNKO?=
 =?us-ascii?Q?qvX3w1awx1q+b+9BKN4H4UXMYzOQQ3E4R323DLmgPohL2W2q2Cd+qq0qb8bm?=
 =?us-ascii?Q?YMBKkEsDqNzqXedzZ20IveIv7BJSl793I3YVQUoEbB9p5cimMLueL1ffyzOb?=
 =?us-ascii?Q?KUYO12JOMP3tY04Xv5Yyyy9IcAhlmua8dSzKuvtVh75nTkfxM1YgUSwyDvpS?=
 =?us-ascii?Q?THz+ijbSNFAmIll8cn3J2le+ckVudl7Q2kl9b/hdN977gP2LaHrHJd4MiDAb?=
 =?us-ascii?Q?u7FRR5Alrp6N+Oqd/Jog0+GqG+TMvcCdtoXc7PBBcy8h1RJvQUHQ6mi8U50l?=
 =?us-ascii?Q?C3uBSidU3cUfAO3E+HBsnYMMphzyVTuqZikUsRZCGuIBqx/tCEifNDgBL8Mq?=
 =?us-ascii?Q?RIPfJwS7D/fE8CbnlFMYqafGpV2SV64KoBk3lyyNMQ/z9l1E1G1ftdB5GUEZ?=
 =?us-ascii?Q?uG+gDmnPRndugKktBhUYn3q1AJ5AtYdRTW6BdJsvyGv8JoyJPbZcRB2eAlVS?=
 =?us-ascii?Q?xDy/B55lXIXhUuFU2ilZCR7vk4dHu7OfMmD1D6MDs9D6PqTef5KTA4ReKCut?=
 =?us-ascii?Q?ter68oTyfaiD9fgveh3ZYZl51GGaOnQ/9hZO6hxwft5cKblFmiHYA50jRPZD?=
 =?us-ascii?Q?2esYVqI1kuPtFpRHNK222TjLbyaq7Rq2HR6nUfsQTXiBFH0CG3aIamXkshnt?=
 =?us-ascii?Q?uGlBPbGpNwush90KZHYQyJrzl4HbcIC2NNVNEepFFNS0DTEEAR98K+0CJOVP?=
 =?us-ascii?Q?JQbxGEgd1K+pC2C1X7kVFGMzCdukFV+JFfAMaDyMcAJBqmfs6/YmcdurQ6s8?=
 =?us-ascii?Q?OrzmqOioOhgIhCDm368+Y36x8MEh5pri2ByDy9u1OY3taUzmR9UE7VYgWmUV?=
 =?us-ascii?Q?LoEZdUyMiI+l7VwF9C64A4uyBmaKK+7HKrI89oUgLPxVZCLyBGg8XOYErvpG?=
 =?us-ascii?Q?nhmebDzoQpdkvAiJwH5L7SbSf4uUAQoDThQdfYQpYTjEfCDUaVVpkF/bSR67?=
 =?us-ascii?Q?EpIgFdhND9pzbBF8UmViDHabjcKvEfQexGkHPi2rzyIPivKtqwQGNcOjwzpy?=
 =?us-ascii?Q?XgxmB32TVHwahsdTN2o9TFdoz7PslPfXnJ3gcjz4j2UFDOt9d5yAouALJhe/?=
 =?us-ascii?Q?jz/P/TxR/vLLTdkBgYd9uN26OeDIs1WLxeoeZ7Yjw7XxqOdscN5k809DhNrM?=
 =?us-ascii?Q?uw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	Hah4cg0Gp+Aw+2bVU3lcQ/Lv0lb/q0zHc6fnASn7kGzdQcs620oiXTKwfZyxZZYN3zVIo44TXWsa8Pp/oUajVDdBtuGT/XxH0OlP/Pgc7InpS3OHm/GKnm7qMWYLBQYt+LTWp9BGNwVjTsF0jNjBFqjwmGOambXM2UQ4DY3PqxnV8eKbIwpanCSyArp0wTAMLqqV2PgWp7FO9lYOT7u9Zf26SO4OZhsKf+LCc1sy8DL1UtXdVu+wzwpstHzseZIX1qNH8blmcoGp1l1or5BrSv0QBRmvnktgnM3O2GAewMt8v8TRT0qdNt02CF3HrmZrxSQzWK1i5P3dtJMOn/UWp+20zsFeeEWQTj6wWGSGdiUscdrLFRZTNTzn2TPkkthErxCPv1O1JM2CKeq/5yqK9oUjK/luuY5UcAN/gaIhoIMQFaQq1klZYPZG0+EXkJ7MDy2XzxLe+fNtQe9qiGA1CxQ5KvFB2tcZvMU52fSpMLclI/03E+yijJBrgr2W3yolDGkWDw0zh+Ez3rAhAK8wzuwfgMaXqdeOeIZS6PPp533p2ZdCmXuLF6Zh8ebk1UL24r42ENsIS9PNuoG424xJ7ptQcx9qQsohuNyvMK+4Djs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e8ba7b6c-c8e8-4ddd-d5bc-08dc91282383
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2024 12:54:36.1757
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PRF/WiHZ5B28wWsbRxy8ZPsyC2eelY33IRqMurjL8wXKWHnXeTbcKZvUtT1fbymR3BXCCnxzpz1/wpgx15SP0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB7695
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-20_07,2024-06-20_03,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 malwarescore=0 phishscore=0 spamscore=0 mlxscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2406200092
X-Proofpoint-ORIG-GUID: VliTFc8u8QHrmPJ9yzQS1ioQu9ZPC5Cc
X-Proofpoint-GUID: VliTFc8u8QHrmPJ9yzQS1ioQu9ZPC5Cc

Support is divided into two main areas:
- reading VPD pages and setting sdev request_queue limits
- support WRITE ATOMIC (16) command and tracing

The relevant block limits VPD page need to be read to allow the block layer
request_queue atomic write limits to be set. These VPD page limits are
described in sbc4r22 section 6.6.4 - Block limits VPD page.

There are five limits of interest:
- MAXIMUM ATOMIC TRANSFER LENGTH
- ATOMIC ALIGNMENT
- ATOMIC TRANSFER LENGTH GRANULARITY
- MAXIMUM ATOMIC TRANSFER LENGTH WITH BOUNDARY
- MAXIMUM ATOMIC BOUNDARY SIZE

MAXIMUM ATOMIC TRANSFER LENGTH is the maximum length for a WRITE ATOMIC
(16) command. It will not be greater than the device MAXIMUM TRANSFER
LENGTH.

ATOMIC ALIGNMENT and ATOMIC TRANSFER LENGTH GRANULARITY are the minimum
alignment and length values for an atomic write in terms of logical blocks.

Unlike NVMe, SCSI does not specify an LBA space boundary, but does specify
a per-IO boundary granularity. The maximum boundary size is specified in
MAXIMUM ATOMIC BOUNDARY SIZE. When used, this boundary value is set in the
WRITE ATOMIC (16) ATOMIC BOUNDARY field - layout for the WRITE_ATOMIC_16
command can be found in sbc4r22 section 5.48. This boundary value is the
granularity size at which the device may atomically write the data. A value
of zero in WRITE ATOMIC (16) ATOMIC BOUNDARY field means that all data must
be atomically written together.

MAXIMUM ATOMIC TRANSFER LENGTH WITH BOUNDARY is the maximum atomic write
length if a non-zero boundary value is set.

For atomic write support, the WRITE ATOMIC (16) boundary is not of much
interest, as the block layer expects each request submitted to be executed
atomically. However, the SCSI spec does leave itself open to a quirky
scenario where MAXIMUM ATOMIC TRANSFER LENGTH is zero, yet MAXIMUM ATOMIC
TRANSFER LENGTH WITH BOUNDARY and MAXIMUM ATOMIC BOUNDARY SIZE are both
non-zero. This case will be supported.

To set the block layer request_queue atomic write capabilities, sanitize
the VPD page limits and set limits as follows:
- atomic_write_unit_min is derived from granularity and alignment values.
  If no granularity value is not set, use physical block size
- atomic_write_unit_max is derived from MAXIMUM ATOMIC TRANSFER LENGTH. In
  the scenario where MAXIMUM ATOMIC TRANSFER LENGTH is zero and boundary
  limits are non-zero, use MAXIMUM ATOMIC BOUNDARY SIZE for
  atomic_write_unit_max. New flag scsi_disk.use_atomic_write_boundary is
  set for this scenario.
- atomic_write_boundary_bytes is set to zero always

SCSI also supports a WRITE ATOMIC (32) command, which is for type 2
protection enabled. This is not going to be supported now, so check for
T10_PI_TYPE2_PROTECTION when setting any request_queue limits.

To handle an atomic write request, add support for WRITE ATOMIC (16)
command in handler sd_setup_atomic_cmnd(). Flag use_atomic_write_boundary
is checked here for encoding ATOMIC BOUNDARY field.

Trace info is also added for WRITE_ATOMIC_16 command.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/scsi_trace.c   | 22 +++++++++
 drivers/scsi/sd.c           | 93 ++++++++++++++++++++++++++++++++++++-
 drivers/scsi/sd.h           |  8 ++++
 include/scsi/scsi_proto.h   |  1 +
 include/trace/events/scsi.h |  1 +
 5 files changed, 124 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_trace.c b/drivers/scsi/scsi_trace.c
index 41a950075913..3e47c4472a80 100644
--- a/drivers/scsi/scsi_trace.c
+++ b/drivers/scsi/scsi_trace.c
@@ -325,6 +325,26 @@ scsi_trace_zbc_out(struct trace_seq *p, unsigned char *cdb, int len)
 	return ret;
 }
 
+static const char *
+scsi_trace_atomic_write16_out(struct trace_seq *p, unsigned char *cdb, int len)
+{
+	const char *ret = trace_seq_buffer_ptr(p);
+	unsigned int boundary_size;
+	unsigned int nr_blocks;
+	sector_t lba;
+
+	lba = get_unaligned_be64(&cdb[2]);
+	boundary_size = get_unaligned_be16(&cdb[10]);
+	nr_blocks = get_unaligned_be16(&cdb[12]);
+
+	trace_seq_printf(p, "lba=%llu txlen=%u boundary_size=%u",
+			  lba, nr_blocks, boundary_size);
+
+	trace_seq_putc(p, 0);
+
+	return ret;
+}
+
 static const char *
 scsi_trace_varlen(struct trace_seq *p, unsigned char *cdb, int len)
 {
@@ -385,6 +405,8 @@ scsi_trace_parse_cdb(struct trace_seq *p, unsigned char *cdb, int len)
 		return scsi_trace_zbc_in(p, cdb, len);
 	case ZBC_OUT:
 		return scsi_trace_zbc_out(p, cdb, len);
+	case WRITE_ATOMIC_16:
+		return scsi_trace_atomic_write16_out(p, cdb, len);
 	default:
 		return scsi_trace_misc(p, cdb, len);
 	}
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index a27f1c7f1b61..525f48c97f5e 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -939,6 +939,64 @@ static blk_status_t sd_setup_unmap_cmnd(struct scsi_cmnd *cmd)
 	return scsi_alloc_sgtables(cmd);
 }
 
+static void sd_config_atomic(struct scsi_disk *sdkp, struct queue_limits *lim)
+{
+	unsigned int logical_block_size = sdkp->device->sector_size,
+		physical_block_size_sectors, max_atomic, unit_min, unit_max;
+
+	if ((!sdkp->max_atomic && !sdkp->max_atomic_with_boundary) ||
+	    sdkp->protection_type == T10_PI_TYPE2_PROTECTION)
+		return;
+
+	physical_block_size_sectors = sdkp->physical_block_size /
+					sdkp->device->sector_size;
+
+	unit_min = rounddown_pow_of_two(sdkp->atomic_granularity ?
+					sdkp->atomic_granularity :
+					physical_block_size_sectors);
+
+	/*
+	 * Only use atomic boundary when we have the odd scenario of
+	 * sdkp->max_atomic == 0, which the spec does permit.
+	 */
+	if (sdkp->max_atomic) {
+		max_atomic = sdkp->max_atomic;
+		unit_max = rounddown_pow_of_two(sdkp->max_atomic);
+		sdkp->use_atomic_write_boundary = 0;
+	} else {
+		max_atomic = sdkp->max_atomic_with_boundary;
+		unit_max = rounddown_pow_of_two(sdkp->max_atomic_boundary);
+		sdkp->use_atomic_write_boundary = 1;
+	}
+
+	/*
+	 * Ensure compliance with granularity and alignment. For now, keep it
+	 * simple and just don't support atomic writes for values mismatched
+	 * with max_{boundary}atomic, physical block size, and
+	 * atomic_granularity itself.
+	 *
+	 * We're really being distrustful by checking unit_max also...
+	 */
+	if (sdkp->atomic_granularity > 1) {
+		if (unit_min > 1 && unit_min % sdkp->atomic_granularity)
+			return;
+		if (unit_max > 1 && unit_max % sdkp->atomic_granularity)
+			return;
+	}
+
+	if (sdkp->atomic_alignment > 1) {
+		if (unit_min > 1 && unit_min % sdkp->atomic_alignment)
+			return;
+		if (unit_max > 1 && unit_max % sdkp->atomic_alignment)
+			return;
+	}
+
+	lim->atomic_write_hw_max = max_atomic * logical_block_size;
+	lim->atomic_write_hw_boundary = 0;
+	lim->atomic_write_hw_unit_min = unit_min * logical_block_size;
+	lim->atomic_write_hw_unit_max = unit_max * logical_block_size;
+}
+
 static blk_status_t sd_setup_write_same16_cmnd(struct scsi_cmnd *cmd,
 		bool unmap)
 {
@@ -1237,6 +1295,26 @@ static int sd_cdl_dld(struct scsi_disk *sdkp, struct scsi_cmnd *scmd)
 	return (hint - IOPRIO_HINT_DEV_DURATION_LIMIT_1) + 1;
 }
 
+static blk_status_t sd_setup_atomic_cmnd(struct scsi_cmnd *cmd,
+					sector_t lba, unsigned int nr_blocks,
+					bool boundary, unsigned char flags)
+{
+	cmd->cmd_len  = 16;
+	cmd->cmnd[0]  = WRITE_ATOMIC_16;
+	cmd->cmnd[1]  = flags;
+	put_unaligned_be64(lba, &cmd->cmnd[2]);
+	put_unaligned_be16(nr_blocks, &cmd->cmnd[12]);
+	if (boundary)
+		put_unaligned_be16(nr_blocks, &cmd->cmnd[10]);
+	else
+		put_unaligned_be16(0, &cmd->cmnd[10]);
+	put_unaligned_be16(nr_blocks, &cmd->cmnd[12]);
+	cmd->cmnd[14] = 0;
+	cmd->cmnd[15] = 0;
+
+	return BLK_STS_OK;
+}
+
 static blk_status_t sd_setup_read_write_cmnd(struct scsi_cmnd *cmd)
 {
 	struct request *rq = scsi_cmd_to_rq(cmd);
@@ -1302,6 +1380,10 @@ static blk_status_t sd_setup_read_write_cmnd(struct scsi_cmnd *cmd)
 	if (protect && sdkp->protection_type == T10_PI_TYPE2_PROTECTION) {
 		ret = sd_setup_rw32_cmnd(cmd, write, lba, nr_blocks,
 					 protect | fua, dld);
+	} else if (rq->cmd_flags & REQ_ATOMIC && write) {
+		ret = sd_setup_atomic_cmnd(cmd, lba, nr_blocks,
+				sdkp->use_atomic_write_boundary,
+				protect | fua);
 	} else if (sdp->use_16_for_rw || (nr_blocks > 0xffff)) {
 		ret = sd_setup_rw16_cmnd(cmd, write, lba, nr_blocks,
 					 protect | fua, dld);
@@ -3264,7 +3346,7 @@ static void sd_read_block_limits(struct scsi_disk *sdkp,
 		sdkp->max_ws_blocks = (u32)get_unaligned_be64(&vpd->data[36]);
 
 		if (!sdkp->lbpme)
-			goto out;
+			goto config_atomic;
 
 		lba_count = get_unaligned_be32(&vpd->data[20]);
 		desc_count = get_unaligned_be32(&vpd->data[24]);
@@ -3279,6 +3361,15 @@ static void sd_read_block_limits(struct scsi_disk *sdkp,
 				get_unaligned_be32(&vpd->data[32]) & ~(1 << 31);
 
 		sd_config_discard(sdkp, lim, sd_discard_mode(sdkp));
+
+config_atomic:
+		sdkp->max_atomic = get_unaligned_be32(&vpd->data[44]);
+		sdkp->atomic_alignment = get_unaligned_be32(&vpd->data[48]);
+		sdkp->atomic_granularity = get_unaligned_be32(&vpd->data[52]);
+		sdkp->max_atomic_with_boundary = get_unaligned_be32(&vpd->data[56]);
+		sdkp->max_atomic_boundary = get_unaligned_be32(&vpd->data[60]);
+
+		sd_config_atomic(sdkp, lim);
 	}
 
  out:
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index 7603b3c67b23..36382eca941c 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -115,6 +115,13 @@ struct scsi_disk {
 	u32		max_unmap_blocks;
 	u32		unmap_granularity;
 	u32		unmap_alignment;
+
+	u32		max_atomic;
+	u32		atomic_alignment;
+	u32		atomic_granularity;
+	u32		max_atomic_with_boundary;
+	u32		max_atomic_boundary;
+
 	u32		index;
 	unsigned int	physical_block_size;
 	unsigned int	max_medium_access_timeouts;
@@ -148,6 +155,7 @@ struct scsi_disk {
 	unsigned	security : 1;
 	unsigned	ignore_medium_access_errors : 1;
 	unsigned	rscs : 1; /* reduced stream control support */
+	unsigned	use_atomic_write_boundary : 1;
 };
 #define to_scsi_disk(obj) container_of(obj, struct scsi_disk, disk_dev)
 
diff --git a/include/scsi/scsi_proto.h b/include/scsi/scsi_proto.h
index 843106e1109f..70e1262b2e20 100644
--- a/include/scsi/scsi_proto.h
+++ b/include/scsi/scsi_proto.h
@@ -120,6 +120,7 @@
 #define WRITE_SAME_16	      0x93
 #define ZBC_OUT		      0x94
 #define ZBC_IN		      0x95
+#define WRITE_ATOMIC_16	0x9c
 #define SERVICE_ACTION_BIDIRECTIONAL 0x9d
 #define SERVICE_ACTION_IN_16  0x9e
 #define SERVICE_ACTION_OUT_16 0x9f
diff --git a/include/trace/events/scsi.h b/include/trace/events/scsi.h
index 8e2d9b1b0e77..05f1945ed204 100644
--- a/include/trace/events/scsi.h
+++ b/include/trace/events/scsi.h
@@ -102,6 +102,7 @@
 		scsi_opcode_name(WRITE_32),			\
 		scsi_opcode_name(WRITE_SAME_32),		\
 		scsi_opcode_name(ATA_16),			\
+		scsi_opcode_name(WRITE_ATOMIC_16),		\
 		scsi_opcode_name(ATA_12))
 
 #define scsi_hostbyte_name(result)	{ result, #result }
-- 
2.31.1


