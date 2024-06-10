Return-Path: <io-uring+bounces-2148-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6466C901FA6
	for <lists+io-uring@lfdr.de>; Mon, 10 Jun 2024 12:46:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 032AC2856EB
	for <lists+io-uring@lfdr.de>; Mon, 10 Jun 2024 10:46:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27E8F7E0EA;
	Mon, 10 Jun 2024 10:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="e3dfueCG";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="TWxxxSm8"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 439877D08F;
	Mon, 10 Jun 2024 10:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718016286; cv=fail; b=n2SSUILJLCKZFpmai+cTq8VccU71ORWEtYKHpmSm2x2Z1VDS9jHRY9KVs63e+fLPATt7hAEwRTnOSBiNKKOR5X+3/AwhpYYQTVME10tmOuxN/NpDOwyOgLwtzRvedUWJUYPA6qhaglUk85+1I93vIfDFfpvhKMv4El6tA7p3zow=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718016286; c=relaxed/simple;
	bh=EGk9YcHxjcmZilKfGPFTkymr8vlgyBhAc7MPLlD3E1Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=uldkpIfZbJa68zuxmSYXTnccZA1oIEbkajK11FMNATbN6b2H+wX0B1/Ht1ki55xQiSpdNJpdEhqmKJGDQHCn3xzeaGKCCM+aNpQ4nIdBkqhHXYExN+jsKjVnZesMPo2v8cNoZv6FoemWdLZTUJBxGirNrbgv+l2KYRs+JaZAFQA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=e3dfueCG; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=TWxxxSm8; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45A4CxBa027095;
	Mon, 10 Jun 2024 10:43:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=o4M53ZUAEJG9jj6Zs1sWMLUGMl7ET22Sv5RjhoHAXkA=; b=
	e3dfueCG3fHnyDSYkGZc7RWGgzoqPYn815brv6m4O6EkZc5EBLKemiNoe8qRmh7Q
	VinasocQOHjYDKzG+wwoe+p3RQ+LB9PWISAH+Ozq+4pCuSg6xbIPd2yfvvxCMPfZ
	cWKV/xmyJcCQm4A4Tb32OWjy0LcAoMLFium8PG3cEYNVHvzk/YZJrUCUaHY/GAnw
	iiOHOubtizW0c2ftXZoUv4Q99WfYzAuuDh7qwSuYUGYZ9jSlUCCoeqMTk/ukGJbR
	YgPvEx/MSNHSrXp/Qt4R+ubIB9D7ZJOk3EqhCW8v4bHT9Crm+3nW9nfUqJmIZz06
	PscqmHdSbDYahAdvKKNM0w==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ymh1ma9w2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Jun 2024 10:43:57 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 45AA76t2021119;
	Mon, 10 Jun 2024 10:43:56 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2040.outbound.protection.outlook.com [104.47.73.40])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3yncasuedp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Jun 2024 10:43:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TzcO7OFXdh+vWcw61ZSlUTJEl5mYAAD5hgFLc29e6CGd2yP4YuUkEAmkkUZX5ot6NS9qYS232a46tsLo0mQ8n4Ykgdd0ZhuoxPls87C0z8mPZ/62TCxTo8YoIylHq4acmgR0voTsb1aE2mXmL05p9OlJHcC3US0YZOOdQSxJDuFQMQBS9FI6Dd3a2g0C/aWFeesE6giTj+6Bekg8wtvVfd5SxhEzI8sb2hguRy8SM7oE/xfkvr1/7gMBhlMC8anf53UzvAbb3KsYrpiKzDnfupkIi1optXa/l6CI5htqAfbUqvnMtaduNxhE625LtgJXzbNzL63/Yk7bYLKQjJOUcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o4M53ZUAEJG9jj6Zs1sWMLUGMl7ET22Sv5RjhoHAXkA=;
 b=iVPWc6mHhPggFFVelErbw4jMbhqI+2C1cXF/AYxHU1T11lFqyCe9jc/hF8FsV+mqFKvM7rBpQEoG594FJOaTCYyBjG19gxLREN466EyQt2igN1B57ye9cFDIERgCViVp2CEuQGT4+uIsvcDjBhNb3JIGVGwmesQp+eOuOQeqVPGUJ4spjctTsU8Qf7RI0YXfrZMj51XUT22z4RaKV6iPXaP7wzYd+rQBaimDfhsP9CBsGdoDfvKafPgpxobLEsrNqAWd6nSU2a/JpPPKEp8onlRMwShvXSx68suEZaUUvXeGafHcgL47H0SEEsFDnZAqXta+BeDfUu/OWj1Yu2Vj6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o4M53ZUAEJG9jj6Zs1sWMLUGMl7ET22Sv5RjhoHAXkA=;
 b=TWxxxSm8DPuF9fMpJ0qncB8B3IV/ubkTsKHjDGoUjJt6E+iOcV9zVXou9lnakb0IVH7rrjIPkteoWR1D7HahIILJsW1bEPYDaWYRP5Av+pOjzjMGFmdfTa1yEP7wa3AYJ/XkLjFVmMas5uEdDP4FtYmg8ES8/WF68r1yHaDh4lQ=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SJ0PR10MB5613.namprd10.prod.outlook.com (2603:10b6:a03:3d0::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.31; Mon, 10 Jun
 2024 10:43:54 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%6]) with mapi id 15.20.7633.036; Mon, 10 Jun 2024
 10:43:53 +0000
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
        Prasad Singamsetty <prasad.singamsetty@oracle.com>,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v8 03/10] fs: Initial atomic write support
Date: Mon, 10 Jun 2024 10:43:22 +0000
Message-Id: <20240610104329.3555488-4-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240610104329.3555488-1-john.g.garry@oracle.com>
References: <20240610104329.3555488-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR13CA0022.namprd13.prod.outlook.com
 (2603:10b6:208:160::35) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SJ0PR10MB5613:EE_
X-MS-Office365-Filtering-Correlation-Id: f617c6fe-eb5e-4085-ae09-08dc893a3909
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: 
	BCL:0;ARA:13230031|7416005|376005|1800799015|366007|921011;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?4vsO4lbz8gUFyV+TD4jCt7zCbMslj+SRT+DNhUNF/LxaN0Qfe8KzF2jR7TEq?=
 =?us-ascii?Q?LDbJGD6t5Ev5YfOK/xZkPmWmclHljG1xCKeGdYXYQ3HWCizJDYbu/YCs8Dvx?=
 =?us-ascii?Q?MsjnGJf+ZbCZoWj6/Oy+qNgh5j1j/pW50uPYHmrs1xL/lCat7yqIKGLHBCwF?=
 =?us-ascii?Q?7785MX7dvsJSD2VDeI5qlbH/lUawr/vNDCfQS/tAGu5V8KI6GNO8/3oqSiEu?=
 =?us-ascii?Q?TPWy416RkfphXeiNAch6kJj2Mj6HgJxGqNJfd6hZlJ25zuEknAywmHpkDDvK?=
 =?us-ascii?Q?rMD0s0xcvQ4dHvbnVf1uPSfOiUjzSLl1Yyk8jPMmWqHyLnwBc/ckvZblMKBB?=
 =?us-ascii?Q?VXIDJhPIlDDN2g9JSwK8Nr6KVC/NczrtKjX8CpwJNndddjxqKPfjJAZbrEUx?=
 =?us-ascii?Q?Gue1Jt9gijYq/05ZS6rM7Q9qLpxt04YYttWmn90vysAfnJXdJ/vV66Eyp+lp?=
 =?us-ascii?Q?wtSIN4tU2svI95h2q973+n2cVL0ppDTe1YRkmn1BdjzmuKU3VghS5x1ip1iq?=
 =?us-ascii?Q?Mane4VZOn5K8X7QUJoQH7Lv0sT0FwS+dca4yQ4z05KVM4IUZ5NUtC6T2c/fL?=
 =?us-ascii?Q?1Z70cQ8vYej0JChhhRvI4sl/rG5aiIuP7fjEVdKfVhDXXVVib0pi8o4rzmul?=
 =?us-ascii?Q?/wL2IWx0uxlOxtnxdpJct7OabJ1PJVo2tlShZOcmSiKru2XDYUuiWvvK7nB4?=
 =?us-ascii?Q?FR2kqOkCyAkhC6T4IqFPNh25UMrYWeN4gxSc0Ouy5lL9FPEqftaKt6ktY6F8?=
 =?us-ascii?Q?/OBM/S17y9veA+TVN7SP2x8ft1odzpJrjHTAp1hqm3+cpwdKhuY86BSFy2gf?=
 =?us-ascii?Q?L7RMgXjV1izKbXnA3mBO5e+xTOuzhbDl1BwGFtYxtmbTUQc4iMHq9P2K99dg?=
 =?us-ascii?Q?BAx4N4A0TW8QG44WXs5ppGl1lTFJPVfXgKpfZx8VzWDkyupIDWHB8iGIwvKq?=
 =?us-ascii?Q?dh41zQx8E4B1TT5HN6Jp61Kqw6N3wjEqGWgPIEmppXBjFjfm+ZjKb9Yvtpac?=
 =?us-ascii?Q?vj5DFtLDBJX9oxLoisbxRncrxcOTfdbXeP2/O4k2M7J5PSbndy4eiUc3+b+K?=
 =?us-ascii?Q?3vQrzV/NMcsVO/PyZawFH1yikjVuZbuRbH1wdy2wn4R1sv/7Vdx5RlKKhliP?=
 =?us-ascii?Q?5kq60hw1WDhaEUniLTR5DH+FkYXG/ZW5hUCUcrra8ndWHQDGBRdai7rcYdM/?=
 =?us-ascii?Q?5mp6A5041p1+YJWZcwD0i8B32MpbsaTfFbb77r4Y3tAZFoGn/GEDOZ2KIjmf?=
 =?us-ascii?Q?RTuH/HaHJOOBvwmRRKGvbmp0kaSYXnWgxj3Tc9Zv72pVK3yILWF17wnXlKmt?=
 =?us-ascii?Q?ZnY/a5ozLahjzoWZ8Kj4SQGm5CJ7lg1c1Lctv2BI++8vcayfyfq7cBhr2e1B?=
 =?us-ascii?Q?wxKYyuc=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(376005)(1800799015)(366007)(921011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?BKfz2t3gGuUo0CJ1s5qlR5AHlnpOqc3HXSKdsZKChhd6vNz93Uu2sj1Efxmw?=
 =?us-ascii?Q?caELI9AFOiolrwpprRvJyUdAfJjfkp2ZVeJQxy4XaFE5XVcFBRTT7N9/K3xs?=
 =?us-ascii?Q?Zbf/FIicaQHPhsqKwsovPD0H3Yz55Vs23zMMM9YoExx6jRuEEsp25iudEXiF?=
 =?us-ascii?Q?CdSU/If66Uv5rdh+HmePVNetMEDNNG4bRPJl+jVIXK9E03/+/Z9D7kKIHhXf?=
 =?us-ascii?Q?k+3R3rVvIYR7zE965o676eV4bYtIxPCoY5cWfT5OcWwNizdMnoK5ksrlSb7T?=
 =?us-ascii?Q?2JbqKbqUsBwL1ph6xaY2DLITkDuE9nNOrII/aq1KMjJU2/VaStWnaD7HUMDe?=
 =?us-ascii?Q?3On1c0MCCK4FvGnrcEOyeSR4hQG2knXctfQqoVF2Q/WWZ1s3ss+pk4LosQvE?=
 =?us-ascii?Q?cRgvwu0eKs8R0MBCa1U0rNkr21RTYvAsN6i5d7Grf48izWEg6R4pilI4Vgyj?=
 =?us-ascii?Q?0zhWJz66IeWpOnlQm0X1roNbNpB6knNxLHOBnWp7RtIIWQ3OBSAcfsJy6qcg?=
 =?us-ascii?Q?M5cvtRgRJcWClRCg1cVa/GieNnfAN8yjJi2cttZexZkdvZxCcD2au2S7VY8l?=
 =?us-ascii?Q?UorFZDPuV1Z2V/HTUJbDhoTf2qOIOzdhWfR7RbYXYLheov9xBytweXbMsQch?=
 =?us-ascii?Q?CfZhE3WgL0B3mLUZrIwivkea5h5zgucGUTEjQRoSjmMFnodWzrVUqLreJAmx?=
 =?us-ascii?Q?S0rkUh9syX3Z3o9vwgVWqbeoNJrRpfFUgm35afDKPhK0I3n+cgopoZ25JUqA?=
 =?us-ascii?Q?Vr9ceBuB7/DyPRM+lgzaFYLGzw5by/EViLwaW+ooFm5/MUiyYkXX7Ry8/Ugx?=
 =?us-ascii?Q?8z5411XULZ1k+tTNOAD0reFYD5e60v2b4MqU1/hnguwt8ERCdnFg5hQya2W8?=
 =?us-ascii?Q?XwiRNujEQXSafTasv1u6j6Yg1pB0sUaN5fFAcfVkbjwaXA3LNvo4o/j1btCV?=
 =?us-ascii?Q?lzpJal+4tNNZgkcwdIGWYTA+t6N4IbQODUii93LTCpsaOFhPt6mH1oeQcuin?=
 =?us-ascii?Q?//5RCbQhP+/RoqygO9DFWulLpBvIX6v6+0P04+p5yibqqV3SzCQ6p/OCbaBb?=
 =?us-ascii?Q?ELjA835U8R57DhCsI1NVw28wP4pNzrYn58/j8pDD/K9Wf7JKunMvoOVnQlST?=
 =?us-ascii?Q?q/B4gUPlB0hXp5+h3Dxfq7CGrEcpgjLzlTaeH6Hk2nv/5ef8Y8d4lkmKaJJt?=
 =?us-ascii?Q?4EyFJxp7Y/Ft84tQyZjsA5u5XmoDe1SKpilo/L8rqKpunQajW73ikaloxUfe?=
 =?us-ascii?Q?qmnWkQZNjKbwKYygassNQSJ7UHyxE+VHRWMaH96nqSFOtkx1Rg1k6NCM/QnF?=
 =?us-ascii?Q?dOeHJd5Ipol8DiXN+11iScMrskyNik0batsMOmrQuzCJ1fDpCOPd4utoN5Wr?=
 =?us-ascii?Q?G2vHmB2ZXA4kMirvUbUzDAaGGTuPgS5OGgVhimVfA1/HDyXTRT26na3a4hRp?=
 =?us-ascii?Q?y4VvNMYuw86J9GPgjr/3SsL13UOMKvWzSIrxmAWNpMh4624mfZ51GRewZk7z?=
 =?us-ascii?Q?As/Q8/FRiEY9hCRn+ukKcCdocMw4uwTG/renPBYHG/No+q55As0MxAW9+f+t?=
 =?us-ascii?Q?ftoX94qJ2Bw3i2LBDySS3faMjXnpmHbyQF8vSGZj6rikWGmeAR0FzGpg9NKr?=
 =?us-ascii?Q?FQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	/ZllUAGv52aNpYeUFolpyl3JSYUgipBf8OGp/lzpRkPqraCSwc+ShT2pGKoc4u1jMa0KUnKv82P+M59Cea83zzkk+6DUtM51Gd6ci1LHnEA8Q4EABUqoCmGWdbelmROEhN9YRqC9KD/xXCorwqvGbt31IWJggM/HgWhIX6Hmgs/NsudbJR51pW3avqa1QDCotwkuUImPyCw69q2u3XYC77AsMUxAC60fQJcM1e8PNRrztVv9wbZVKwPmQu4QkwEY7bpWrZH8oLjYz9akp4+u0ZmFFB8mVkZ0Fss4IJaEOGSwsMt9zvcXSXAaptA1XkVur22h2FOF4KQi3VBKujHCigFqxqSczpQbDl/UjYpeFqGAFV2etVyaqOPu7aOL50WSkYE88XFCr+DEH5mbyG/NJzrvBQFVtSVt9WnU0Ar26QtfN31aD2ub1nMMNcfnJEQF1pN64gUKqUHc8AqVK3BFOJ/CWqZ5ENlkPaG70ck6WOAG3yNDMn5MkGJZAmqDPMj+E8ZKiteba15dEnS6H1TI2E+ujeD5mgx1kbcQZQ78dAx3mkaJPccEQAgJ5AqvTwLYst5VkoR7p9iyxtA0i69uxkyqdtW97M2F59EtUplRmGY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f617c6fe-eb5e-4085-ae09-08dc893a3909
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2024 10:43:53.8625
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lOWZYKTlFsZZUp2mHAmefSsh+5Ou5nPASWuXJ1YTqRbeaEnHE4tjDpfkz5dqRyXaoU8QgD8n20nnEo8IcEUN+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5613
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-10_02,2024-06-10_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 malwarescore=0 spamscore=0 mlxscore=0 phishscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2406100081
X-Proofpoint-ORIG-GUID: HFAEe8-QM4BRrzaq-KJ0jAHwPZguQq1g
X-Proofpoint-GUID: HFAEe8-QM4BRrzaq-KJ0jAHwPZguQq1g

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
 fs/read_write.c         | 18 +++++++++++++++++-
 include/linux/fs.h      | 17 +++++++++++++++--
 include/uapi/linux/fs.h |  5 ++++-
 io_uring/rw.c           |  9 ++++-----
 6 files changed, 45 insertions(+), 14 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index 57c9f7c077e6..93ef59d358b3 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -1516,7 +1516,7 @@ static void aio_complete_rw(struct kiocb *kiocb, long res)
 	iocb_put(iocb);
 }
 
-static int aio_prep_rw(struct kiocb *req, const struct iocb *iocb)
+static int aio_prep_rw(struct kiocb *req, const struct iocb *iocb, int rw_type)
 {
 	int ret;
 
@@ -1542,7 +1542,7 @@ static int aio_prep_rw(struct kiocb *req, const struct iocb *iocb)
 	} else
 		req->ki_ioprio = get_current_ioprio();
 
-	ret = kiocb_set_rw_flags(req, iocb->aio_rw_flags);
+	ret = kiocb_set_rw_flags(req, iocb->aio_rw_flags, rw_type);
 	if (unlikely(ret))
 		return ret;
 
@@ -1594,7 +1594,7 @@ static int aio_read(struct kiocb *req, const struct iocb *iocb,
 	struct file *file;
 	int ret;
 
-	ret = aio_prep_rw(req, iocb);
+	ret = aio_prep_rw(req, iocb, READ);
 	if (ret)
 		return ret;
 	file = req->ki_filp;
@@ -1621,7 +1621,7 @@ static int aio_write(struct kiocb *req, const struct iocb *iocb,
 	struct file *file;
 	int ret;
 
-	ret = aio_prep_rw(req, iocb);
+	ret = aio_prep_rw(req, iocb, WRITE);
 	if (ret)
 		return ret;
 	file = req->ki_filp;
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index efd5d6e9589e..6ad524b894fc 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4627,7 +4627,7 @@ static int btrfs_ioctl_encoded_write(struct file *file, void __user *argp, bool
 		goto out_iov;
 
 	init_sync_kiocb(&kiocb, file);
-	ret = kiocb_set_rw_flags(&kiocb, 0);
+	ret = kiocb_set_rw_flags(&kiocb, 0, WRITE);
 	if (ret)
 		goto out_iov;
 	kiocb.ki_pos = pos;
diff --git a/fs/read_write.c b/fs/read_write.c
index ef6339391351..285b0f5a9a9c 100644
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
@@ -1736,3 +1736,19 @@ int generic_file_rw_checks(struct file *file_in, struct file *file_out)
 
 	return 0;
 }
+
+bool generic_atomic_write_valid(struct iov_iter *iter, loff_t pos)
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
\ No newline at end of file
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 0283cf366c2a..e049414bef7d 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -125,8 +125,10 @@ typedef int (dio_iodone_t)(struct kiocb *iocb, loff_t offset,
 #define FMODE_EXEC		((__force fmode_t)(1 << 5))
 /* File writes are restricted (block device specific) */
 #define FMODE_WRITE_RESTRICTED	((__force fmode_t)(1 << 6))
+/* File supports atomic writes */
+#define FMODE_CAN_ATOMIC_WRITE	((__force fmode_t)(1 << 7))
 
-/* FMODE_* bits 7 to 8 */
+/* FMODE_* bit 8 */
 
 /* 32bit hashes as llseek() offset (for directories) */
 #define FMODE_32BITHASH         ((__force fmode_t)(1 << 9))
@@ -317,6 +319,7 @@ struct readahead_control;
 #define IOCB_SYNC		(__force int) RWF_SYNC
 #define IOCB_NOWAIT		(__force int) RWF_NOWAIT
 #define IOCB_APPEND		(__force int) RWF_APPEND
+#define IOCB_ATOMIC		(__force int) RWF_ATOMIC
 
 /* non-RWF related bits - start at 16 */
 #define IOCB_EVENTFD		(1 << 16)
@@ -351,6 +354,7 @@ struct readahead_control;
 	{ IOCB_SYNC,		"SYNC" }, \
 	{ IOCB_NOWAIT,		"NOWAIT" }, \
 	{ IOCB_APPEND,		"APPEND" }, \
+	{ IOCB_ATOMIC,		"ATOMIC"}, \
 	{ IOCB_EVENTFD,		"EVENTFD"}, \
 	{ IOCB_DIRECT,		"DIRECT" }, \
 	{ IOCB_WRITE,		"WRITE" }, \
@@ -3403,7 +3407,8 @@ static inline int iocb_flags(struct file *file)
 	return res;
 }
 
-static inline int kiocb_set_rw_flags(struct kiocb *ki, rwf_t flags)
+static inline int kiocb_set_rw_flags(struct kiocb *ki, rwf_t flags,
+				     int rw_type)
 {
 	int kiocb_flags = 0;
 
@@ -3422,6 +3427,12 @@ static inline int kiocb_set_rw_flags(struct kiocb *ki, rwf_t flags)
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
@@ -3613,4 +3624,6 @@ extern int vfs_fadvise(struct file *file, loff_t offset, loff_t len,
 extern int generic_fadvise(struct file *file, loff_t offset, loff_t len,
 			   int advice);
 
+bool generic_atomic_write_valid(struct iov_iter *iter, loff_t pos);
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
index 1a2128459cb4..c004d21e2f12 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -772,7 +772,7 @@ static bool need_complete_io(struct io_kiocb *req)
 		S_ISBLK(file_inode(req->file)->i_mode);
 }
 
-static int io_rw_init_file(struct io_kiocb *req, fmode_t mode)
+static int io_rw_init_file(struct io_kiocb *req, fmode_t mode, int rw_type)
 {
 	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
 	struct kiocb *kiocb = &rw->kiocb;
@@ -787,7 +787,7 @@ static int io_rw_init_file(struct io_kiocb *req, fmode_t mode)
 		req->flags |= io_file_get_flags(file);
 
 	kiocb->ki_flags = file->f_iocb_flags;
-	ret = kiocb_set_rw_flags(kiocb, rw->flags);
+	ret = kiocb_set_rw_flags(kiocb, rw->flags, rw_type);
 	if (unlikely(ret))
 		return ret;
 	kiocb->ki_flags |= IOCB_ALLOC_CACHE;
@@ -832,8 +832,7 @@ static int __io_read(struct io_kiocb *req, unsigned int issue_flags)
 		if (unlikely(ret < 0))
 			return ret;
 	}
-
-	ret = io_rw_init_file(req, FMODE_READ);
+	ret = io_rw_init_file(req, FMODE_READ, READ);
 	if (unlikely(ret))
 		return ret;
 	req->cqe.res = iov_iter_count(&io->iter);
@@ -1013,7 +1012,7 @@ int io_write(struct io_kiocb *req, unsigned int issue_flags)
 	ssize_t ret, ret2;
 	loff_t *ppos;
 
-	ret = io_rw_init_file(req, FMODE_WRITE);
+	ret = io_rw_init_file(req, FMODE_WRITE, WRITE);
 	if (unlikely(ret))
 		return ret;
 	req->cqe.res = iov_iter_count(&io->iter);
-- 
2.31.1


