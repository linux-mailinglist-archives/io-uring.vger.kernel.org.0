Return-Path: <io-uring+bounces-2297-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 02C449104F6
	for <lists+io-uring@lfdr.de>; Thu, 20 Jun 2024 15:00:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0D8181C231C2
	for <lists+io-uring@lfdr.de>; Thu, 20 Jun 2024 13:00:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4CD51B1504;
	Thu, 20 Jun 2024 12:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="iHapryNn";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="EIjJfsPU"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74A241B142F;
	Thu, 20 Jun 2024 12:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718888179; cv=fail; b=YuEAjbBQmAD+FSCH1bW0WAnVn1pA5OSG9DbMwMsmQ7Y1UWY3vIjTtYCsHWFF5yGCWFjZB6s5YG/McsnL9TsSPV5ZyWsQzP3B502VrRmMGuOlcWaHgQ2jTFf1tEaA8gVu/DfSUMRCiwoOoq2eUh963y4E7X5YR2iCOqlTIpDFC9I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718888179; c=relaxed/simple;
	bh=ze9em5INdycc48t3W3uOuCvW1UPjbfeWzsmvGwvfStw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=dLCB/O70jBvIinJAcA/1LenrukR5oDw6+djwPNorsFD30hMFzyFO5X05TggXOc/grGDD3uiSRJmkYFWOUcRYlcTbfhlDxOdpweH1ktczifMJlaCGZssbV/FepUKKf0yIKEZ9tov4WRhJiid6or+JMp7gt/EyBXiPiMkx0iIBljA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=iHapryNn; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=EIjJfsPU; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45K5GFeQ006627;
	Thu, 20 Jun 2024 12:54:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=858Jelol0qWBsezANnyRhQGnX93d8f8HkvjudIBABTE=; b=
	iHapryNn+qZWhKyueDK3TYwc4ChGHkabp02JAxxUVR6rrCEqLK5kjuBrsZnVkYfO
	2jk2E0QHx6NVOavFe/3+rJA1lbXUHP1pouXOj1KvkFJNJ31nK+mQmDDBHSHAlmWb
	D1NIseXBoOO7KlcGQzS2ppUiLiu64SFvEqhLUh2GYAwkZUMuegwvXnIX2H4gntaJ
	DKy1HtpJVNlftHH/u3o6gIj1HCj5cwFwJJpEd0G1h5DNXEDNRuuOi/VLoAsDIdiP
	YjFGrlXAOnzbPh6I2rcioExb1Pmy9ASQAbC5ZqgpPTJe006fqy2VQU/kQH4Z3M5S
	uXbNdAZlvBO3LQiOOZo3TA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3yuj9jb3yx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Jun 2024 12:54:42 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 45KC7uth032824;
	Thu, 20 Jun 2024 12:54:41 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2040.outbound.protection.outlook.com [104.47.56.40])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ys1dae6nh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Jun 2024 12:54:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W8lrBHIrXMz2XFCi8w9AUSMFo7spwWy16NZSt8e5u94gpoazRkAlLt5/TnH9j69D6bNLb83yEw0S86wbydrYHAjrYXpJQ/1Hdwe/CkRGSpL0X1+nRycdk9Tq6GffxgKrz6F01TxnnJOmZOjOn9ZcXyT3tzQnpXyHIt3uq4UfMmmsssnJSa6y1nzrR0gRFW8brP4Jgm9GfABQTwobyrpCk2ieWJRv9RyMY2nKzwvZdkObFSAjkSmBHg7Wo0JUadHvgc9rsuoG7xbzzAqg2JCQAXvXK7wQAUHo1RSa92hVRkhl8kpJ8f4FTYlCM97h1e8v4WpbylT4Z5KSGnzr2IvxJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=858Jelol0qWBsezANnyRhQGnX93d8f8HkvjudIBABTE=;
 b=bTA4D4dw+P3NSAc+a97prs55doDnH4ITsxHsma4LWAm6pHOsod5Aa+OHc4RyjJHuG+/0wj1lv/LaMRCm5OZHcOqeWV44Fhxmoj0qmQdo2m4aA3eKA/M7U3SJECVWFJ/P+bbsAGyvSNV7uHldawiMC2qcp/aSuF4Icfjv/ItA2j+NYt8vFk5b+AqCIxPx6VviVgjcxxloZGexcFRbbZP6rvvTkofBNSUzJOublFJwravAeG3rIJ25Sy/k9+gPJ4Qk88RTMNNcvWjUCytr2VSnVQjCeJSeNSFnmfnmyp3UFMVPav55MbDtCo1IsNmnjpLBxbbsgLib0txeQlzJxr7QZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=858Jelol0qWBsezANnyRhQGnX93d8f8HkvjudIBABTE=;
 b=EIjJfsPUiPJC4amAfgN6GOXKmboFKAd2R6laFcj1e8qGST4A51RvrbtU7/jTWWCU81Ib/AZb9DeWKyUD29dW8r7g3V4cwJiDbRBuDmmybe0cx2Qy5wErywtuYC6ZfjOWHLfXaQveX0mBsMPLnOBTS2HSApYw21YQS2MIXDLddCY=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by PH7PR10MB7695.namprd10.prod.outlook.com (2603:10b6:510:2e5::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.31; Thu, 20 Jun
 2024 12:54:37 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%6]) with mapi id 15.20.7698.020; Thu, 20 Jun 2024
 12:54:37 +0000
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
Subject: [Patch v9 09/10] scsi: scsi_debug: Atomic write support
Date: Thu, 20 Jun 2024 12:53:58 +0000
Message-Id: <20240620125359.2684798-10-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240620125359.2684798-1-john.g.garry@oracle.com>
References: <20240620125359.2684798-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR16CA0026.namprd16.prod.outlook.com
 (2603:10b6:208:134::39) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|PH7PR10MB7695:EE_
X-MS-Office365-Filtering-Correlation-Id: d822dd19-9fab-4cf6-3bef-08dc9128248a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: 
	BCL:0;ARA:13230037|376011|7416011|1800799021|366013|921017;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?d4yuUcybs+2IATS3A2Cp09g3XUnmB9fHj7QUbiuGCHjRqAUezXm4RG8DNbK2?=
 =?us-ascii?Q?P/q0wKxqPY63EATiu+Fm0gdxhKfD24HiyO0AX+2gWEyJSpSSfj09i+FRSiw1?=
 =?us-ascii?Q?nIZ+IcoX5RS3y6CSBUXSdBvIxAhmOT5rZqm7Pc5evceLbzWXsUbhI2LhQlUX?=
 =?us-ascii?Q?ByvVk7fT8j9+xLhYZcbb9crU7enqulrtYznogogYTHqwhwzve7IIrFsXl+NT?=
 =?us-ascii?Q?nODdHGSUo6OItvQPSJbnam519MBecJYi3/laThAUtgMGErUed74cLE+Pw88H?=
 =?us-ascii?Q?FPGe16XtIf1pdEVXkjPTW8/TNy6MCVwk4+AoBngilrISAUQ0Z6riAVjXJw6H?=
 =?us-ascii?Q?nDJlc9PS+JsrVcZKrYaEqntPffYs5fBu5fo6SYRRXLswlg8AXIIuO7zB/zxn?=
 =?us-ascii?Q?+Pna9xaQML3lw4KaeGwlZP6Q9wcYUaUJT8GFYS4M61iXhue2oLDG+K0mpusG?=
 =?us-ascii?Q?VbcLukMkIfYxZhzdxgH1geowgJp7s1NSfrpzaoNS6PhMceLvOcz9hS3iMWmO?=
 =?us-ascii?Q?QlXaOX+tgLBkrvNz/8sk6mAQ3WEVejQ5sTy7yf8ng8oV2lOsVSwyVUHQv/YZ?=
 =?us-ascii?Q?FDmI1zU+7McjYiWyzfLARW7cYbxJXAXU5MhRuQRBogoPSulPBBTz+xMjrP2N?=
 =?us-ascii?Q?8A5VwDJfBRarqYiF8cKV3Hi3F1LpXqvPlXUYAYy14NOt8BbtKsYw1avzWe+Q?=
 =?us-ascii?Q?X8pGUZxBAUt26ILwAZtc5+WJ/a8BCs4gvXHgIUIJgqsUhUQQsJc5vYK9K41E?=
 =?us-ascii?Q?YgfxVf/VN1PcGVgzjzFtz1P0b+GgfnXL+P9GdkBlXUJr+JzKOUH2EzB10A/J?=
 =?us-ascii?Q?6NIaMA3NzcxJ75EaGT9iMDaRxvtqbQPt1lHpaxY4d1ye84jk1XVW+6kffEN9?=
 =?us-ascii?Q?AA90zqrLtTiHqv0mNOKnRSD3VnYcjueh/tifdsqHkDBhy53AyVDokMzWsOtp?=
 =?us-ascii?Q?7/HF9zJhLlPZH0UeEeStK1nZdGPaWJbAxrc5DkzO1W6RrSeU4jZE3Y46USgQ?=
 =?us-ascii?Q?wNH8RPqyrXCza+WZdJpQAwjQQG3kSej6CsbJypihreZf/Ok50aHJwcIC36gE?=
 =?us-ascii?Q?A07UydKqY0YwdaynQC5uM8Q1viaLQ8P1Ie7H4o5hipwTuS8NjKamINzRj7s1?=
 =?us-ascii?Q?Unk2VchskZcn0dqaG1zZ4qDZmjSRMJT+ibugZdf4Sz2Pgl/o5BzOg8HL6Cql?=
 =?us-ascii?Q?V7L0CnKEsupk+tOgWGfslmn4VG6HiXjAaPMxvWiPtUUFBzjBXiZdCpHsb3wU?=
 =?us-ascii?Q?9wyaqKqEV/hbuZoPk19jzDXEWxLSuF3gmitFpXAVKsSVSQtcC2m/Bt9wU4ei?=
 =?us-ascii?Q?+OUfCcV62q7wl2AhjKB/bfydceChi/CPXJ5fJM8ij/mPZtEFqzE2u3yTPvOb?=
 =?us-ascii?Q?1eXvoxk=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(376011)(7416011)(1800799021)(366013)(921017);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?khULbn95oECqU4MYKloh5FlAA7pH9ww4Je4DhDOUb0htKqa+KpFLqQnMYS0S?=
 =?us-ascii?Q?UD9rkc7rvws2EoPsoS/rUQJAAIg8bZPI3npQNYAUUL1XBGD/bVSiql9im8cy?=
 =?us-ascii?Q?GkEo/xZf4kgipR55by13iqLv7N4TA/EceVsQzyVbpxdle5Scjf0GWTA4TXpo?=
 =?us-ascii?Q?xA7Oc1Y8BLXFocjoxkgBWgYJB2zjaWW47Ycfc1u4HMVjqgJyTdrwgqdWvZQ5?=
 =?us-ascii?Q?G6uSdof1ZagzPEIW+NVtEkGkiP00VhEwqNZ/c7pdDZfRIrcYHhRFsPPumE1E?=
 =?us-ascii?Q?vBKfTPFKQi48IKnMWmVHPrPGtpPyQAg6YU3Xic8T4kqHGx/EEIk7ve/pJ2F3?=
 =?us-ascii?Q?0hHy4AWKgVP956JWxMhOsJ8ww17Zg2yfRx07/VzNR8wERPfwQ3AOHuHtawMw?=
 =?us-ascii?Q?iWe8DlpVGBxTkWux4rz4lSPcxyVmiK8SaXQQswDOr6iCLQ+drIujq7PfMxjH?=
 =?us-ascii?Q?JRO9NDggU78KCRUY+KBnBEu9FiQfmZUkcQfatSTEUs9/9PtCSe7FGrd2rqY1?=
 =?us-ascii?Q?h/bygLLkdoMBOT4yIJrZhqwUVayqTdodkAujL20eMi0DkD4jGvo/XSisXm8X?=
 =?us-ascii?Q?r4Lme1aCNT+sfspmsJI8zMlA18lQKcCGWV6ylBOsWPpNemp+Gkdab4MVpKex?=
 =?us-ascii?Q?b1IMUhtCcdAHYcEStfHatKAgiYcx2gR7KZhne7Y7HHdTVTDqahIj5Eapbfez?=
 =?us-ascii?Q?R3RMF3mW5yusKM8M+qFUbOYKTYvrGzEEgr5wTDXwWEOmc8j0cBO6f+tjDuVo?=
 =?us-ascii?Q?DsN3P8o06k8oOtlB7sEw2BXyElOCka4XVsc3OHJ3NtzYtpLQhapXrT7FYKKm?=
 =?us-ascii?Q?ho5NOci2pd4HJbFPcGkuFJSwnbiCwYbtPgoT+HgMZcCQaGp8jqEp4chBG8sM?=
 =?us-ascii?Q?wIkkiYHUaVjYhoKZecBP+6A3q42wL3sIswfdXWnwHdsD2y2uc1JO6XPDL7c9?=
 =?us-ascii?Q?p4TToPzmPayTTOqU27u9GE9A1Nf6S8R2B4wcy3H2qHriqR0n5qP+PiJC6XKg?=
 =?us-ascii?Q?cBuY9CzA+LbgPv6YFfZi0gAmqktyqHPPS17OGkay0Smoi5EWiKLQhe1FaoaY?=
 =?us-ascii?Q?i0C//Rq1zKUTUYRgTgokl3yuTwwQKiTYopUh5SrFYy/O+1uPRFvTgr2oHwv6?=
 =?us-ascii?Q?8sc2BTrwkpEjSs1jIWFktZqnPrWfREZJ8JOx3lidjHFWhK7aqzSECTu11zen?=
 =?us-ascii?Q?XphZRM6g7j2ZiNWFxHdarP9yxB+ngfDKSthwoSo9i1SYCCFZXPXU/1Q3Zsw/?=
 =?us-ascii?Q?jjqMCZd4sHO/PV6p1olKe8c7KyQzDKiGEgMZrvc7SR4lSw3ay+p8mmWGVIod?=
 =?us-ascii?Q?+2lZowDacaZZUlo8YDIw0gKnSKzRwrnTpc+h6of1u3vI6Tku94GwSvx1ne2W?=
 =?us-ascii?Q?0gYTdJ325G+a+n86oe8ueoWAfwt2d11lRXI6aDzt17m5uUYfk+NwOVQBx+NS?=
 =?us-ascii?Q?RarKbqEH4l0U/5ILYscE/cnF0i1UryQae8Ok8q3Fb48CmQ0kbAUnkQZv5IDj?=
 =?us-ascii?Q?YMtRv1fd2jl3tBrstFGOD/V9O1IClV5J5nmHYqWFQI3tiX2nzs9Ma0J7uIh2?=
 =?us-ascii?Q?t7HudTNnAJoccdat7lp7pOh/pedhn1XVKwWqyE7KKxjYrYrQV39pPxaaC+NL?=
 =?us-ascii?Q?HA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	tzvE9d+CP0jzIMwvtWjMct7cyWpZNZtsrvSohcFFj5vFd0fZA395kGkYmxYviDQMXE5JYfysJZBqmjOCCT3+Hpz/fqeoyxJKGAjlr01c14S/JKwpbJAVKGmKX8SZjS8Tajm2hSRSbo9jWcF/KGuGRsZEIqmFsDtIHYSaDISe47xxoK5nNzmdo2TWynCvXriyd+Av5R2wa5+t5jH78g/lkQbatqdNt9qocuYF4xaa53GTtGGKMI+YyTPuyGqpiAmJIQos4RQ0imWgmEAqk+4Ndv32uU9fSb3ws5Cw+Ak44Up8f6/e2EBeO7jN0RnHDjvex9I9s65kGdaEM9B/VuD/yRRBu1I8Id0iPYGRpjDYujqiJ77Uijy0+ik3g13+4glxaPNWxeehPcq/KJaZ550OFW3wQUr8a4alkGBTZja0yJ4B6PAx1WMT87nMXqmKzv+msTvPmRQrtyHISf4FKccwYDWM3oMUkSMiSQDWbM3rwNZ1QmTc3H59iSOeLtMT0fMpLpHtmEhPCb8fz8quaAZ6hzG5gUnLkQ0crGwM8H1w2N/z1VZdx52VDCyb/L/2H7lhaJeI4/ACpf+R2q1zIX3oihYssF/KwVcZd9IXGqEz1Z4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d822dd19-9fab-4cf6-3bef-08dc9128248a
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2024 12:54:37.8845
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s9iU9zXVOFBepC9z0YXo2d54STqPfT/4ksJvtc/t/MbyrmC4ppqg1GSYho+4ZtdFqwWcbbQMmj1EVUVzTI3lHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB7695
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-20_07,2024-06-20_03,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 spamscore=0
 mlxlogscore=999 mlxscore=0 phishscore=0 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2405010000
 definitions=main-2406200092
X-Proofpoint-GUID: sgo-roy4YH4y3zn3WCFSdnDr5oQBaSvu
X-Proofpoint-ORIG-GUID: sgo-roy4YH4y3zn3WCFSdnDr5oQBaSvu

Add initial support for atomic writes.

As is standard method, feed device properties via modules param, those
being:
- atomic_max_size_blks
- atomic_alignment_blks
- atomic_granularity_blks
- atomic_max_size_with_boundary_blks
- atomic_max_boundary_blks

These just match sbc4r22 section 6.6.4 - Block limits VPD page.

We just support ATOMIC WRITE (16).

The major change in the driver is how we lock the device for RW accesses.

Currently the driver uses a per-device lock for accessing device metadata
and "media" data (calls to do_device_access()) atomically for the duration
of the whole read/write command.

This should not suit verifying atomic writes. Reason being that currently
all reads/writes are atomic, so using atomic writes does not prove
anything.

Change device access model to basis that regular writes only atomic on a
per-sector basis, while reads and atomic writes are fully atomic.

As mentioned, since accessing metadata and device media is atomic,
continue to have regular writes involving metadata - like discard or PI -
as atomic. We can improve this later.

Currently we only support model where overlapping going reads or writes
wait for current access to complete before commencing an atomic write.
This is described in 4.29.3.2 section of the SBC. However, we simplify,
things and wait for all accesses to complete (when issuing an atomic
write).

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/scsi_debug.c | 588 +++++++++++++++++++++++++++++---------
 1 file changed, 454 insertions(+), 134 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 7f340a59fdc5..fcc9640fa18a 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -69,6 +69,8 @@ static const char *sdebug_version_date = "20210520";
 
 /* Additional Sense Code (ASC) */
 #define NO_ADDITIONAL_SENSE 0x0
+#define OVERLAP_ATOMIC_COMMAND_ASC 0x0
+#define OVERLAP_ATOMIC_COMMAND_ASCQ 0x23
 #define LOGICAL_UNIT_NOT_READY 0x4
 #define LOGICAL_UNIT_COMMUNICATION_FAILURE 0x8
 #define UNRECOVERED_READ_ERR 0x11
@@ -103,6 +105,7 @@ static const char *sdebug_version_date = "20210520";
 #define READ_BOUNDARY_ASCQ 0x7
 #define ATTEMPT_ACCESS_GAP 0x9
 #define INSUFF_ZONE_ASCQ 0xe
+/* see drivers/scsi/sense_codes.h */
 
 /* Additional Sense Code Qualifier (ASCQ) */
 #define ACK_NAK_TO 0x3
@@ -152,6 +155,12 @@ static const char *sdebug_version_date = "20210520";
 #define DEF_VIRTUAL_GB   0
 #define DEF_VPD_USE_HOSTNO 1
 #define DEF_WRITESAME_LENGTH 0xFFFF
+#define DEF_ATOMIC_WR 0
+#define DEF_ATOMIC_WR_MAX_LENGTH 8192
+#define DEF_ATOMIC_WR_ALIGN 2
+#define DEF_ATOMIC_WR_GRAN 2
+#define DEF_ATOMIC_WR_MAX_LENGTH_BNDRY (DEF_ATOMIC_WR_MAX_LENGTH)
+#define DEF_ATOMIC_WR_MAX_BNDRY 128
 #define DEF_STRICT 0
 #define DEF_STATISTICS false
 #define DEF_SUBMIT_QUEUES 1
@@ -374,7 +383,9 @@ struct sdebug_host_info {
 
 /* There is an xarray of pointers to this struct's objects, one per host */
 struct sdeb_store_info {
-	rwlock_t macc_lck;	/* for atomic media access on this store */
+	rwlock_t macc_data_lck;	/* for media data access on this store */
+	rwlock_t macc_meta_lck;	/* for atomic media meta access on this store */
+	rwlock_t macc_sector_lck;	/* per-sector media data access on this store */
 	u8 *storep;		/* user data storage (ram) */
 	struct t10_pi_tuple *dif_storep; /* protection info */
 	void *map_storep;	/* provisioning map */
@@ -398,12 +409,20 @@ struct sdebug_defer {
 	enum sdeb_defer_type defer_t;
 };
 
+struct sdebug_device_access_info {
+	bool atomic_write;
+	u64 lba;
+	u32 num;
+	struct scsi_cmnd *self;
+};
+
 struct sdebug_queued_cmd {
 	/* corresponding bit set in in_use_bm[] in owning struct sdebug_queue
 	 * instance indicates this slot is in use.
 	 */
 	struct sdebug_defer sd_dp;
 	struct scsi_cmnd *scmd;
+	struct sdebug_device_access_info *i;
 };
 
 struct sdebug_scsi_cmd {
@@ -463,7 +482,8 @@ enum sdeb_opcode_index {
 	SDEB_I_PRE_FETCH = 29,		/* 10, 16 */
 	SDEB_I_ZONE_OUT = 30,		/* 0x94+SA; includes no data xfer */
 	SDEB_I_ZONE_IN = 31,		/* 0x95+SA; all have data-in */
-	SDEB_I_LAST_ELEM_P1 = 32,	/* keep this last (previous + 1) */
+	SDEB_I_ATOMIC_WRITE_16 = 32,
+	SDEB_I_LAST_ELEM_P1 = 33,	/* keep this last (previous + 1) */
 };
 
 
@@ -497,7 +517,8 @@ static const unsigned char opcode_ind_arr[256] = {
 	0, 0, 0, SDEB_I_VERIFY,
 	SDEB_I_PRE_FETCH, SDEB_I_SYNC_CACHE, 0, SDEB_I_WRITE_SAME,
 	SDEB_I_ZONE_OUT, SDEB_I_ZONE_IN, 0, 0,
-	0, 0, 0, 0, 0, 0, SDEB_I_SERV_ACT_IN_16, SDEB_I_SERV_ACT_OUT_16,
+	0, 0, 0, 0,
+	SDEB_I_ATOMIC_WRITE_16, 0, SDEB_I_SERV_ACT_IN_16, SDEB_I_SERV_ACT_OUT_16,
 /* 0xa0; 0xa0->0xbf: 12 byte cdbs */
 	SDEB_I_REPORT_LUNS, SDEB_I_ATA_PT, 0, SDEB_I_MAINT_IN,
 	     SDEB_I_MAINT_OUT, 0, 0, 0,
@@ -547,6 +568,7 @@ static int resp_write_buffer(struct scsi_cmnd *, struct sdebug_dev_info *);
 static int resp_sync_cache(struct scsi_cmnd *, struct sdebug_dev_info *);
 static int resp_pre_fetch(struct scsi_cmnd *, struct sdebug_dev_info *);
 static int resp_report_zones(struct scsi_cmnd *, struct sdebug_dev_info *);
+static int resp_atomic_write(struct scsi_cmnd *, struct sdebug_dev_info *);
 static int resp_open_zone(struct scsi_cmnd *, struct sdebug_dev_info *);
 static int resp_close_zone(struct scsi_cmnd *, struct sdebug_dev_info *);
 static int resp_finish_zone(struct scsi_cmnd *, struct sdebug_dev_info *);
@@ -788,6 +810,11 @@ static const struct opcode_info_t opcode_info_arr[SDEB_I_LAST_ELEM_P1 + 1] = {
 	    resp_report_zones, zone_in_iarr, /* ZONE_IN(16), REPORT ZONES) */
 		{16,  0x0 /* SA */, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
 		 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xbf, 0xc7} },
+/* 31 */
+	{0, 0x0, 0x0, F_D_OUT | FF_MEDIA_IO,
+	    resp_atomic_write, NULL, /* ATOMIC WRITE 16 */
+		{16,  0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
+		 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff} },
 /* sentinel */
 	{0xff, 0, 0, 0, NULL, NULL,		/* terminating element */
 	    {0,  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0} },
@@ -835,6 +862,13 @@ static unsigned int sdebug_unmap_granularity = DEF_UNMAP_GRANULARITY;
 static unsigned int sdebug_unmap_max_blocks = DEF_UNMAP_MAX_BLOCKS;
 static unsigned int sdebug_unmap_max_desc = DEF_UNMAP_MAX_DESC;
 static unsigned int sdebug_write_same_length = DEF_WRITESAME_LENGTH;
+static unsigned int sdebug_atomic_wr = DEF_ATOMIC_WR;
+static unsigned int sdebug_atomic_wr_max_length = DEF_ATOMIC_WR_MAX_LENGTH;
+static unsigned int sdebug_atomic_wr_align = DEF_ATOMIC_WR_ALIGN;
+static unsigned int sdebug_atomic_wr_gran = DEF_ATOMIC_WR_GRAN;
+static unsigned int sdebug_atomic_wr_max_length_bndry =
+			DEF_ATOMIC_WR_MAX_LENGTH_BNDRY;
+static unsigned int sdebug_atomic_wr_max_bndry = DEF_ATOMIC_WR_MAX_BNDRY;
 static int sdebug_uuid_ctl = DEF_UUID_CTL;
 static bool sdebug_random = DEF_RANDOM;
 static bool sdebug_per_host_store = DEF_PER_HOST_STORE;
@@ -1188,6 +1222,11 @@ static inline bool scsi_debug_lbp(void)
 		(sdebug_lbpu || sdebug_lbpws || sdebug_lbpws10);
 }
 
+static inline bool scsi_debug_atomic_write(void)
+{
+	return sdebug_fake_rw == 0 && sdebug_atomic_wr;
+}
+
 static void *lba2fake_store(struct sdeb_store_info *sip,
 			    unsigned long long lba)
 {
@@ -1815,6 +1854,14 @@ static int inquiry_vpd_b0(unsigned char *arr)
 	/* Maximum WRITE SAME Length */
 	put_unaligned_be64(sdebug_write_same_length, &arr[32]);
 
+	if (sdebug_atomic_wr) {
+		put_unaligned_be32(sdebug_atomic_wr_max_length, &arr[40]);
+		put_unaligned_be32(sdebug_atomic_wr_align, &arr[44]);
+		put_unaligned_be32(sdebug_atomic_wr_gran, &arr[48]);
+		put_unaligned_be32(sdebug_atomic_wr_max_length_bndry, &arr[52]);
+		put_unaligned_be32(sdebug_atomic_wr_max_bndry, &arr[56]);
+	}
+
 	return 0x3c; /* Mandatory page length for Logical Block Provisioning */
 }
 
@@ -3377,16 +3424,238 @@ static inline struct sdeb_store_info *devip2sip(struct sdebug_dev_info *devip,
 	return xa_load(per_store_ap, devip->sdbg_host->si_idx);
 }
 
+static inline void
+sdeb_read_lock(rwlock_t *lock)
+{
+	if (sdebug_no_rwlock)
+		__acquire(lock);
+	else
+		read_lock(lock);
+}
+
+static inline void
+sdeb_read_unlock(rwlock_t *lock)
+{
+	if (sdebug_no_rwlock)
+		__release(lock);
+	else
+		read_unlock(lock);
+}
+
+static inline void
+sdeb_write_lock(rwlock_t *lock)
+{
+	if (sdebug_no_rwlock)
+		__acquire(lock);
+	else
+		write_lock(lock);
+}
+
+static inline void
+sdeb_write_unlock(rwlock_t *lock)
+{
+	if (sdebug_no_rwlock)
+		__release(lock);
+	else
+		write_unlock(lock);
+}
+
+static inline void
+sdeb_data_read_lock(struct sdeb_store_info *sip)
+{
+	BUG_ON(!sip);
+
+	sdeb_read_lock(&sip->macc_data_lck);
+}
+
+static inline void
+sdeb_data_read_unlock(struct sdeb_store_info *sip)
+{
+	BUG_ON(!sip);
+
+	sdeb_read_unlock(&sip->macc_data_lck);
+}
+
+static inline void
+sdeb_data_write_lock(struct sdeb_store_info *sip)
+{
+	BUG_ON(!sip);
+
+	sdeb_write_lock(&sip->macc_data_lck);
+}
+
+static inline void
+sdeb_data_write_unlock(struct sdeb_store_info *sip)
+{
+	BUG_ON(!sip);
+
+	sdeb_write_unlock(&sip->macc_data_lck);
+}
+
+static inline void
+sdeb_data_sector_read_lock(struct sdeb_store_info *sip)
+{
+	BUG_ON(!sip);
+
+	sdeb_read_lock(&sip->macc_sector_lck);
+}
+
+static inline void
+sdeb_data_sector_read_unlock(struct sdeb_store_info *sip)
+{
+	BUG_ON(!sip);
+
+	sdeb_read_unlock(&sip->macc_sector_lck);
+}
+
+static inline void
+sdeb_data_sector_write_lock(struct sdeb_store_info *sip)
+{
+	BUG_ON(!sip);
+
+	sdeb_write_lock(&sip->macc_sector_lck);
+}
+
+static inline void
+sdeb_data_sector_write_unlock(struct sdeb_store_info *sip)
+{
+	BUG_ON(!sip);
+
+	sdeb_write_unlock(&sip->macc_sector_lck);
+}
+
+/*
+ * Atomic locking:
+ * We simplify the atomic model to allow only 1x atomic write and many non-
+ * atomic reads or writes for all LBAs.
+
+ * A RW lock has a similar bahaviour:
+ * Only 1x writer and many readers.
+
+ * So use a RW lock for per-device read and write locking:
+ * An atomic access grabs the lock as a writer and non-atomic grabs the lock
+ * as a reader.
+ */
+
+static inline void
+sdeb_data_lock(struct sdeb_store_info *sip, bool atomic)
+{
+	if (atomic)
+		sdeb_data_write_lock(sip);
+	else
+		sdeb_data_read_lock(sip);
+}
+
+static inline void
+sdeb_data_unlock(struct sdeb_store_info *sip, bool atomic)
+{
+	if (atomic)
+		sdeb_data_write_unlock(sip);
+	else
+		sdeb_data_read_unlock(sip);
+}
+
+/* Allow many reads but only 1x write per sector */
+static inline void
+sdeb_data_sector_lock(struct sdeb_store_info *sip, bool do_write)
+{
+	if (do_write)
+		sdeb_data_sector_write_lock(sip);
+	else
+		sdeb_data_sector_read_lock(sip);
+}
+
+static inline void
+sdeb_data_sector_unlock(struct sdeb_store_info *sip, bool do_write)
+{
+	if (do_write)
+		sdeb_data_sector_write_unlock(sip);
+	else
+		sdeb_data_sector_read_unlock(sip);
+}
+
+static inline void
+sdeb_meta_read_lock(struct sdeb_store_info *sip)
+{
+	if (sdebug_no_rwlock) {
+		if (sip)
+			__acquire(&sip->macc_meta_lck);
+		else
+			__acquire(&sdeb_fake_rw_lck);
+	} else {
+		if (sip)
+			read_lock(&sip->macc_meta_lck);
+		else
+			read_lock(&sdeb_fake_rw_lck);
+	}
+}
+
+static inline void
+sdeb_meta_read_unlock(struct sdeb_store_info *sip)
+{
+	if (sdebug_no_rwlock) {
+		if (sip)
+			__release(&sip->macc_meta_lck);
+		else
+			__release(&sdeb_fake_rw_lck);
+	} else {
+		if (sip)
+			read_unlock(&sip->macc_meta_lck);
+		else
+			read_unlock(&sdeb_fake_rw_lck);
+	}
+}
+
+static inline void
+sdeb_meta_write_lock(struct sdeb_store_info *sip)
+{
+	if (sdebug_no_rwlock) {
+		if (sip)
+			__acquire(&sip->macc_meta_lck);
+		else
+			__acquire(&sdeb_fake_rw_lck);
+	} else {
+		if (sip)
+			write_lock(&sip->macc_meta_lck);
+		else
+			write_lock(&sdeb_fake_rw_lck);
+	}
+}
+
+static inline void
+sdeb_meta_write_unlock(struct sdeb_store_info *sip)
+{
+	if (sdebug_no_rwlock) {
+		if (sip)
+			__release(&sip->macc_meta_lck);
+		else
+			__release(&sdeb_fake_rw_lck);
+	} else {
+		if (sip)
+			write_unlock(&sip->macc_meta_lck);
+		else
+			write_unlock(&sdeb_fake_rw_lck);
+	}
+}
+
 /* Returns number of bytes copied or -1 if error. */
 static int do_device_access(struct sdeb_store_info *sip, struct scsi_cmnd *scp,
-			    u32 sg_skip, u64 lba, u32 num, bool do_write,
-			    u8 group_number)
+			    u32 sg_skip, u64 lba, u32 num, u8 group_number,
+			    bool do_write, bool atomic)
 {
 	int ret;
-	u64 block, rest = 0;
+	u64 block;
 	enum dma_data_direction dir;
 	struct scsi_data_buffer *sdb = &scp->sdb;
 	u8 *fsp;
+	int i;
+
+	/*
+	 * Even though reads are inherently atomic (in this driver), we expect
+	 * the atomic flag only for writes.
+	 */
+	if (!do_write && atomic)
+		return -1;
 
 	if (do_write) {
 		dir = DMA_TO_DEVICE;
@@ -3406,21 +3675,26 @@ static int do_device_access(struct sdeb_store_info *sip, struct scsi_cmnd *scp,
 	fsp = sip->storep;
 
 	block = do_div(lba, sdebug_store_sectors);
-	if (block + num > sdebug_store_sectors)
-		rest = block + num - sdebug_store_sectors;
 
-	ret = sg_copy_buffer(sdb->table.sgl, sdb->table.nents,
+	/* Only allow 1x atomic write or multiple non-atomic writes at any given time */
+	sdeb_data_lock(sip, atomic);
+	for (i = 0; i < num; i++) {
+		/* We shouldn't need to lock for atomic writes, but do it anyway */
+		sdeb_data_sector_lock(sip, do_write);
+		ret = sg_copy_buffer(sdb->table.sgl, sdb->table.nents,
 		   fsp + (block * sdebug_sector_size),
-		   (num - rest) * sdebug_sector_size, sg_skip, do_write);
-	if (ret != (num - rest) * sdebug_sector_size)
-		return ret;
-
-	if (rest) {
-		ret += sg_copy_buffer(sdb->table.sgl, sdb->table.nents,
-			    fsp, rest * sdebug_sector_size,
-			    sg_skip + ((num - rest) * sdebug_sector_size),
-			    do_write);
+		   sdebug_sector_size, sg_skip, do_write);
+		sdeb_data_sector_unlock(sip, do_write);
+		if (ret != sdebug_sector_size) {
+			ret += (i * sdebug_sector_size);
+			break;
+		}
+		sg_skip += sdebug_sector_size;
+		if (++block >= sdebug_store_sectors)
+			block = 0;
 	}
+	ret = num * sdebug_sector_size;
+	sdeb_data_unlock(sip, atomic);
 
 	return ret;
 }
@@ -3596,70 +3870,6 @@ static int prot_verify_read(struct scsi_cmnd *scp, sector_t start_sec,
 	return ret;
 }
 
-static inline void
-sdeb_read_lock(struct sdeb_store_info *sip)
-{
-	if (sdebug_no_rwlock) {
-		if (sip)
-			__acquire(&sip->macc_lck);
-		else
-			__acquire(&sdeb_fake_rw_lck);
-	} else {
-		if (sip)
-			read_lock(&sip->macc_lck);
-		else
-			read_lock(&sdeb_fake_rw_lck);
-	}
-}
-
-static inline void
-sdeb_read_unlock(struct sdeb_store_info *sip)
-{
-	if (sdebug_no_rwlock) {
-		if (sip)
-			__release(&sip->macc_lck);
-		else
-			__release(&sdeb_fake_rw_lck);
-	} else {
-		if (sip)
-			read_unlock(&sip->macc_lck);
-		else
-			read_unlock(&sdeb_fake_rw_lck);
-	}
-}
-
-static inline void
-sdeb_write_lock(struct sdeb_store_info *sip)
-{
-	if (sdebug_no_rwlock) {
-		if (sip)
-			__acquire(&sip->macc_lck);
-		else
-			__acquire(&sdeb_fake_rw_lck);
-	} else {
-		if (sip)
-			write_lock(&sip->macc_lck);
-		else
-			write_lock(&sdeb_fake_rw_lck);
-	}
-}
-
-static inline void
-sdeb_write_unlock(struct sdeb_store_info *sip)
-{
-	if (sdebug_no_rwlock) {
-		if (sip)
-			__release(&sip->macc_lck);
-		else
-			__release(&sdeb_fake_rw_lck);
-	} else {
-		if (sip)
-			write_unlock(&sip->macc_lck);
-		else
-			write_unlock(&sdeb_fake_rw_lck);
-	}
-}
-
 static int resp_read_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 {
 	bool check_prot;
@@ -3669,6 +3879,7 @@ static int resp_read_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	u64 lba;
 	struct sdeb_store_info *sip = devip2sip(devip, true);
 	u8 *cmd = scp->cmnd;
+	bool meta_data_locked = false;
 
 	switch (cmd[0]) {
 	case READ_16:
@@ -3727,6 +3938,10 @@ static int resp_read_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 		atomic_set(&sdeb_inject_pending, 0);
 	}
 
+	/*
+	 * When checking device access params, for reads we only check data
+	 * versus what is set at init time, so no need to lock.
+	 */
 	ret = check_device_access_params(scp, lba, num, false);
 	if (ret)
 		return ret;
@@ -3746,29 +3961,33 @@ static int resp_read_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 		return check_condition_result;
 	}
 
-	sdeb_read_lock(sip);
+	if (sdebug_dev_is_zoned(devip) ||
+	    (sdebug_dix && scsi_prot_sg_count(scp)))  {
+		sdeb_meta_read_lock(sip);
+		meta_data_locked = true;
+	}
 
 	/* DIX + T10 DIF */
 	if (unlikely(sdebug_dix && scsi_prot_sg_count(scp))) {
 		switch (prot_verify_read(scp, lba, num, ei_lba)) {
 		case 1: /* Guard tag error */
 			if (cmd[1] >> 5 != 3) { /* RDPROTECT != 3 */
-				sdeb_read_unlock(sip);
+				sdeb_meta_read_unlock(sip);
 				mk_sense_buffer(scp, ABORTED_COMMAND, 0x10, 1);
 				return check_condition_result;
 			} else if (scp->prot_flags & SCSI_PROT_GUARD_CHECK) {
-				sdeb_read_unlock(sip);
+				sdeb_meta_read_unlock(sip);
 				mk_sense_buffer(scp, ILLEGAL_REQUEST, 0x10, 1);
 				return illegal_condition_result;
 			}
 			break;
 		case 3: /* Reference tag error */
 			if (cmd[1] >> 5 != 3) { /* RDPROTECT != 3 */
-				sdeb_read_unlock(sip);
+				sdeb_meta_read_unlock(sip);
 				mk_sense_buffer(scp, ABORTED_COMMAND, 0x10, 3);
 				return check_condition_result;
 			} else if (scp->prot_flags & SCSI_PROT_REF_CHECK) {
-				sdeb_read_unlock(sip);
+				sdeb_meta_read_unlock(sip);
 				mk_sense_buffer(scp, ILLEGAL_REQUEST, 0x10, 3);
 				return illegal_condition_result;
 			}
@@ -3776,8 +3995,9 @@ static int resp_read_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 		}
 	}
 
-	ret = do_device_access(sip, scp, 0, lba, num, false, 0);
-	sdeb_read_unlock(sip);
+	ret = do_device_access(sip, scp, 0, lba, num, 0, false, false);
+	if (meta_data_locked)
+		sdeb_meta_read_unlock(sip);
 	if (unlikely(ret == -1))
 		return DID_ERROR << 16;
 
@@ -3967,6 +4187,7 @@ static int resp_write_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	u64 lba;
 	struct sdeb_store_info *sip = devip2sip(devip, true);
 	u8 *cmd = scp->cmnd;
+	bool meta_data_locked = false;
 
 	switch (cmd[0]) {
 	case WRITE_16:
@@ -4025,10 +4246,17 @@ static int resp_write_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 				    "to DIF device\n");
 	}
 
-	sdeb_write_lock(sip);
+	if (sdebug_dev_is_zoned(devip) ||
+	    (sdebug_dix && scsi_prot_sg_count(scp)) ||
+	    scsi_debug_lbp())  {
+		sdeb_meta_write_lock(sip);
+		meta_data_locked = true;
+	}
+
 	ret = check_device_access_params(scp, lba, num, true);
 	if (ret) {
-		sdeb_write_unlock(sip);
+		if (meta_data_locked)
+			sdeb_meta_write_unlock(sip);
 		return ret;
 	}
 
@@ -4037,22 +4265,22 @@ static int resp_write_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 		switch (prot_verify_write(scp, lba, num, ei_lba)) {
 		case 1: /* Guard tag error */
 			if (scp->prot_flags & SCSI_PROT_GUARD_CHECK) {
-				sdeb_write_unlock(sip);
+				sdeb_meta_write_unlock(sip);
 				mk_sense_buffer(scp, ILLEGAL_REQUEST, 0x10, 1);
 				return illegal_condition_result;
 			} else if (scp->cmnd[1] >> 5 != 3) { /* WRPROTECT != 3 */
-				sdeb_write_unlock(sip);
+				sdeb_meta_write_unlock(sip);
 				mk_sense_buffer(scp, ABORTED_COMMAND, 0x10, 1);
 				return check_condition_result;
 			}
 			break;
 		case 3: /* Reference tag error */
 			if (scp->prot_flags & SCSI_PROT_REF_CHECK) {
-				sdeb_write_unlock(sip);
+				sdeb_meta_write_unlock(sip);
 				mk_sense_buffer(scp, ILLEGAL_REQUEST, 0x10, 3);
 				return illegal_condition_result;
 			} else if (scp->cmnd[1] >> 5 != 3) { /* WRPROTECT != 3 */
-				sdeb_write_unlock(sip);
+				sdeb_meta_write_unlock(sip);
 				mk_sense_buffer(scp, ABORTED_COMMAND, 0x10, 3);
 				return check_condition_result;
 			}
@@ -4060,13 +4288,16 @@ static int resp_write_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 		}
 	}
 
-	ret = do_device_access(sip, scp, 0, lba, num, true, group);
+	ret = do_device_access(sip, scp, 0, lba, num, group, true, false);
 	if (unlikely(scsi_debug_lbp()))
 		map_region(sip, lba, num);
+
 	/* If ZBC zone then bump its write pointer */
 	if (sdebug_dev_is_zoned(devip))
 		zbc_inc_wp(devip, lba, num);
-	sdeb_write_unlock(sip);
+	if (meta_data_locked)
+		sdeb_meta_write_unlock(sip);
+
 	if (unlikely(-1 == ret))
 		return DID_ERROR << 16;
 	else if (unlikely(sdebug_verbose &&
@@ -4176,7 +4407,8 @@ static int resp_write_scat(struct scsi_cmnd *scp,
 		goto err_out;
 	}
 
-	sdeb_write_lock(sip);
+	/* Just keep it simple and always lock for now */
+	sdeb_meta_write_lock(sip);
 	sg_off = lbdof_blen;
 	/* Spec says Buffer xfer Length field in number of LBs in dout */
 	cum_lb = 0;
@@ -4219,7 +4451,11 @@ static int resp_write_scat(struct scsi_cmnd *scp,
 			}
 		}
 
-		ret = do_device_access(sip, scp, sg_off, lba, num, true, group);
+		/*
+		 * Write ranges atomically to keep as close to pre-atomic
+		 * writes behaviour as possible.
+		 */
+		ret = do_device_access(sip, scp, sg_off, lba, num, group, true, true);
 		/* If ZBC zone then bump its write pointer */
 		if (sdebug_dev_is_zoned(devip))
 			zbc_inc_wp(devip, lba, num);
@@ -4258,7 +4494,7 @@ static int resp_write_scat(struct scsi_cmnd *scp,
 	}
 	ret = 0;
 err_out_unlock:
-	sdeb_write_unlock(sip);
+	sdeb_meta_write_unlock(sip);
 err_out:
 	kfree(lrdp);
 	return ret;
@@ -4277,14 +4513,16 @@ static int resp_write_same(struct scsi_cmnd *scp, u64 lba, u32 num,
 						scp->device->hostdata, true);
 	u8 *fs1p;
 	u8 *fsp;
+	bool meta_data_locked = false;
 
-	sdeb_write_lock(sip);
+	if (sdebug_dev_is_zoned(devip) || scsi_debug_lbp()) {
+		sdeb_meta_write_lock(sip);
+		meta_data_locked = true;
+	}
 
 	ret = check_device_access_params(scp, lba, num, true);
-	if (ret) {
-		sdeb_write_unlock(sip);
-		return ret;
-	}
+	if (ret)
+		goto out;
 
 	if (unmap && scsi_debug_lbp()) {
 		unmap_region(sip, lba, num);
@@ -4295,6 +4533,7 @@ static int resp_write_same(struct scsi_cmnd *scp, u64 lba, u32 num,
 	/* if ndob then zero 1 logical block, else fetch 1 logical block */
 	fsp = sip->storep;
 	fs1p = fsp + (block * lb_size);
+	sdeb_data_write_lock(sip);
 	if (ndob) {
 		memset(fs1p, 0, lb_size);
 		ret = 0;
@@ -4302,8 +4541,8 @@ static int resp_write_same(struct scsi_cmnd *scp, u64 lba, u32 num,
 		ret = fetch_to_dev_buffer(scp, fs1p, lb_size);
 
 	if (-1 == ret) {
-		sdeb_write_unlock(sip);
-		return DID_ERROR << 16;
+		ret = DID_ERROR << 16;
+		goto out;
 	} else if (sdebug_verbose && !ndob && (ret < lb_size))
 		sdev_printk(KERN_INFO, scp->device,
 			    "%s: %s: lb size=%u, IO sent=%d bytes\n",
@@ -4320,10 +4559,12 @@ static int resp_write_same(struct scsi_cmnd *scp, u64 lba, u32 num,
 	/* If ZBC zone then bump its write pointer */
 	if (sdebug_dev_is_zoned(devip))
 		zbc_inc_wp(devip, lba, num);
+	sdeb_data_write_unlock(sip);
+	ret = 0;
 out:
-	sdeb_write_unlock(sip);
-
-	return 0;
+	if (meta_data_locked)
+		sdeb_meta_write_unlock(sip);
+	return ret;
 }
 
 static int resp_write_same_10(struct scsi_cmnd *scp,
@@ -4466,25 +4707,30 @@ static int resp_comp_write(struct scsi_cmnd *scp,
 		return check_condition_result;
 	}
 
-	sdeb_write_lock(sip);
-
 	ret = do_dout_fetch(scp, dnum, arr);
 	if (ret == -1) {
 		retval = DID_ERROR << 16;
-		goto cleanup;
+		goto cleanup_free;
 	} else if (sdebug_verbose && (ret < (dnum * lb_size)))
 		sdev_printk(KERN_INFO, scp->device, "%s: compare_write: cdb "
 			    "indicated=%u, IO sent=%d bytes\n", my_name,
 			    dnum * lb_size, ret);
+
+	sdeb_data_write_lock(sip);
+	sdeb_meta_write_lock(sip);
 	if (!comp_write_worker(sip, lba, num, arr, false)) {
 		mk_sense_buffer(scp, MISCOMPARE, MISCOMPARE_VERIFY_ASC, 0);
 		retval = check_condition_result;
-		goto cleanup;
+		goto cleanup_unlock;
 	}
+
+	/* Cover sip->map_storep (which map_region()) sets with data lock */
 	if (scsi_debug_lbp())
 		map_region(sip, lba, num);
-cleanup:
-	sdeb_write_unlock(sip);
+cleanup_unlock:
+	sdeb_meta_write_unlock(sip);
+	sdeb_data_write_unlock(sip);
+cleanup_free:
 	kfree(arr);
 	return retval;
 }
@@ -4528,7 +4774,7 @@ static int resp_unmap(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 
 	desc = (void *)&buf[8];
 
-	sdeb_write_lock(sip);
+	sdeb_meta_write_lock(sip);
 
 	for (i = 0 ; i < descriptors ; i++) {
 		unsigned long long lba = get_unaligned_be64(&desc[i].lba);
@@ -4544,7 +4790,7 @@ static int resp_unmap(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	ret = 0;
 
 out:
-	sdeb_write_unlock(sip);
+	sdeb_meta_write_unlock(sip);
 	kfree(buf);
 
 	return ret;
@@ -4702,12 +4948,13 @@ static int resp_pre_fetch(struct scsi_cmnd *scp,
 		rest = block + nblks - sdebug_store_sectors;
 
 	/* Try to bring the PRE-FETCH range into CPU's cache */
-	sdeb_read_lock(sip);
+	sdeb_data_read_lock(sip);
 	prefetch_range(fsp + (sdebug_sector_size * block),
 		       (nblks - rest) * sdebug_sector_size);
 	if (rest)
 		prefetch_range(fsp, rest * sdebug_sector_size);
-	sdeb_read_unlock(sip);
+
+	sdeb_data_read_unlock(sip);
 fini:
 	if (cmd[1] & 0x2)
 		res = SDEG_RES_IMMED_MASK;
@@ -4866,7 +5113,7 @@ static int resp_verify(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 		return check_condition_result;
 	}
 	/* Not changing store, so only need read access */
-	sdeb_read_lock(sip);
+	sdeb_data_read_lock(sip);
 
 	ret = do_dout_fetch(scp, a_num, arr);
 	if (ret == -1) {
@@ -4888,7 +5135,7 @@ static int resp_verify(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 		goto cleanup;
 	}
 cleanup:
-	sdeb_read_unlock(sip);
+	sdeb_data_read_unlock(sip);
 	kfree(arr);
 	return ret;
 }
@@ -4934,7 +5181,7 @@ static int resp_report_zones(struct scsi_cmnd *scp,
 		return check_condition_result;
 	}
 
-	sdeb_read_lock(sip);
+	sdeb_meta_read_lock(sip);
 
 	desc = arr + 64;
 	for (lba = zs_lba; lba < sdebug_capacity;
@@ -5032,11 +5279,70 @@ static int resp_report_zones(struct scsi_cmnd *scp,
 	ret = fill_from_dev_buffer(scp, arr, min_t(u32, alloc_len, rep_len));
 
 fini:
-	sdeb_read_unlock(sip);
+	sdeb_meta_read_unlock(sip);
 	kfree(arr);
 	return ret;
 }
 
+static int resp_atomic_write(struct scsi_cmnd *scp,
+			     struct sdebug_dev_info *devip)
+{
+	struct sdeb_store_info *sip;
+	u8 *cmd = scp->cmnd;
+	u16 boundary, len;
+	u64 lba, lba_tmp;
+	int ret;
+
+	if (!scsi_debug_atomic_write()) {
+		mk_sense_invalid_opcode(scp);
+		return check_condition_result;
+	}
+
+	sip = devip2sip(devip, true);
+
+	lba = get_unaligned_be64(cmd + 2);
+	boundary = get_unaligned_be16(cmd + 10);
+	len = get_unaligned_be16(cmd + 12);
+
+	lba_tmp = lba;
+	if (sdebug_atomic_wr_align &&
+	    do_div(lba_tmp, sdebug_atomic_wr_align)) {
+		/* Does not meet alignment requirement */
+		mk_sense_buffer(scp, ILLEGAL_REQUEST, INVALID_FIELD_IN_CDB, 0);
+		return check_condition_result;
+	}
+
+	if (sdebug_atomic_wr_gran && len % sdebug_atomic_wr_gran) {
+		/* Does not meet alignment requirement */
+		mk_sense_buffer(scp, ILLEGAL_REQUEST, INVALID_FIELD_IN_CDB, 0);
+		return check_condition_result;
+	}
+
+	if (boundary > 0) {
+		if (boundary > sdebug_atomic_wr_max_bndry) {
+			mk_sense_invalid_fld(scp, SDEB_IN_CDB, 12, -1);
+			return check_condition_result;
+		}
+
+		if (len > sdebug_atomic_wr_max_length_bndry) {
+			mk_sense_invalid_fld(scp, SDEB_IN_CDB, 12, -1);
+			return check_condition_result;
+		}
+	} else {
+		if (len > sdebug_atomic_wr_max_length) {
+			mk_sense_invalid_fld(scp, SDEB_IN_CDB, 12, -1);
+			return check_condition_result;
+		}
+	}
+
+	ret = do_device_access(sip, scp, 0, lba, len, 0, true, true);
+	if (unlikely(ret == -1))
+		return DID_ERROR << 16;
+	if (unlikely(ret != len * sdebug_sector_size))
+		return DID_ERROR << 16;
+	return 0;
+}
+
 /* Logic transplanted from tcmu-runner, file_zbc.c */
 static void zbc_open_all(struct sdebug_dev_info *devip)
 {
@@ -5063,8 +5369,7 @@ static int resp_open_zone(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 		mk_sense_invalid_opcode(scp);
 		return check_condition_result;
 	}
-
-	sdeb_write_lock(sip);
+	sdeb_meta_write_lock(sip);
 
 	if (all) {
 		/* Check if all closed zones can be open */
@@ -5113,7 +5418,7 @@ static int resp_open_zone(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 
 	zbc_open_zone(devip, zsp, true);
 fini:
-	sdeb_write_unlock(sip);
+	sdeb_meta_write_unlock(sip);
 	return res;
 }
 
@@ -5140,7 +5445,7 @@ static int resp_close_zone(struct scsi_cmnd *scp,
 		return check_condition_result;
 	}
 
-	sdeb_write_lock(sip);
+	sdeb_meta_write_lock(sip);
 
 	if (all) {
 		zbc_close_all(devip);
@@ -5169,7 +5474,7 @@ static int resp_close_zone(struct scsi_cmnd *scp,
 
 	zbc_close_zone(devip, zsp);
 fini:
-	sdeb_write_unlock(sip);
+	sdeb_meta_write_unlock(sip);
 	return res;
 }
 
@@ -5212,7 +5517,7 @@ static int resp_finish_zone(struct scsi_cmnd *scp,
 		return check_condition_result;
 	}
 
-	sdeb_write_lock(sip);
+	sdeb_meta_write_lock(sip);
 
 	if (all) {
 		zbc_finish_all(devip);
@@ -5241,7 +5546,7 @@ static int resp_finish_zone(struct scsi_cmnd *scp,
 
 	zbc_finish_zone(devip, zsp, true);
 fini:
-	sdeb_write_unlock(sip);
+	sdeb_meta_write_unlock(sip);
 	return res;
 }
 
@@ -5292,7 +5597,7 @@ static int resp_rwp_zone(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 		return check_condition_result;
 	}
 
-	sdeb_write_lock(sip);
+	sdeb_meta_write_lock(sip);
 
 	if (all) {
 		zbc_rwp_all(devip);
@@ -5320,7 +5625,7 @@ static int resp_rwp_zone(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 
 	zbc_rwp_zone(devip, zsp);
 fini:
-	sdeb_write_unlock(sip);
+	sdeb_meta_write_unlock(sip);
 	return res;
 }
 
@@ -6284,6 +6589,7 @@ module_param_named(lbprz, sdebug_lbprz, int, S_IRUGO);
 module_param_named(lbpu, sdebug_lbpu, int, S_IRUGO);
 module_param_named(lbpws, sdebug_lbpws, int, S_IRUGO);
 module_param_named(lbpws10, sdebug_lbpws10, int, S_IRUGO);
+module_param_named(atomic_wr, sdebug_atomic_wr, int, S_IRUGO);
 module_param_named(lowest_aligned, sdebug_lowest_aligned, int, S_IRUGO);
 module_param_named(lun_format, sdebug_lun_am_i, int, S_IRUGO | S_IWUSR);
 module_param_named(max_luns, sdebug_max_luns, int, S_IRUGO | S_IWUSR);
@@ -6318,6 +6624,11 @@ module_param_named(unmap_alignment, sdebug_unmap_alignment, int, S_IRUGO);
 module_param_named(unmap_granularity, sdebug_unmap_granularity, int, S_IRUGO);
 module_param_named(unmap_max_blocks, sdebug_unmap_max_blocks, int, S_IRUGO);
 module_param_named(unmap_max_desc, sdebug_unmap_max_desc, int, S_IRUGO);
+module_param_named(atomic_wr_max_length, sdebug_atomic_wr_max_length, int, S_IRUGO);
+module_param_named(atomic_wr_align, sdebug_atomic_wr_align, int, S_IRUGO);
+module_param_named(atomic_wr_gran, sdebug_atomic_wr_gran, int, S_IRUGO);
+module_param_named(atomic_wr_max_length_bndry, sdebug_atomic_wr_max_length_bndry, int, S_IRUGO);
+module_param_named(atomic_wr_max_bndry, sdebug_atomic_wr_max_bndry, int, S_IRUGO);
 module_param_named(uuid_ctl, sdebug_uuid_ctl, int, S_IRUGO);
 module_param_named(virtual_gb, sdebug_virtual_gb, int, S_IRUGO | S_IWUSR);
 module_param_named(vpd_use_hostno, sdebug_vpd_use_hostno, int,
@@ -6361,6 +6672,7 @@ MODULE_PARM_DESC(lbprz,
 MODULE_PARM_DESC(lbpu, "enable LBP, support UNMAP command (def=0)");
 MODULE_PARM_DESC(lbpws, "enable LBP, support WRITE SAME(16) with UNMAP bit (def=0)");
 MODULE_PARM_DESC(lbpws10, "enable LBP, support WRITE SAME(10) with UNMAP bit (def=0)");
+MODULE_PARM_DESC(atomic_write, "enable ATOMIC WRITE support, support WRITE ATOMIC(16) (def=0)");
 MODULE_PARM_DESC(lowest_aligned, "lowest aligned lba (def=0)");
 MODULE_PARM_DESC(lun_format, "LUN format: 0->peripheral (def); 1 --> flat address method");
 MODULE_PARM_DESC(max_luns, "number of LUNs per target to simulate(def=1)");
@@ -6392,6 +6704,11 @@ MODULE_PARM_DESC(unmap_alignment, "lowest aligned thin provisioning lba (def=0)"
 MODULE_PARM_DESC(unmap_granularity, "thin provisioning granularity in blocks (def=1)");
 MODULE_PARM_DESC(unmap_max_blocks, "max # of blocks can be unmapped in one cmd (def=0xffffffff)");
 MODULE_PARM_DESC(unmap_max_desc, "max # of ranges that can be unmapped in one cmd (def=256)");
+MODULE_PARM_DESC(atomic_wr_max_length, "max # of blocks can be atomically written in one cmd (def=8192)");
+MODULE_PARM_DESC(atomic_wr_align, "minimum alignment of atomic write in blocks (def=2)");
+MODULE_PARM_DESC(atomic_wr_gran, "minimum granularity of atomic write in blocks (def=2)");
+MODULE_PARM_DESC(atomic_wr_max_length_bndry, "max # of blocks can be atomically written in one cmd with boundary set (def=8192)");
+MODULE_PARM_DESC(atomic_wr_max_bndry, "max # boundaries per atomic write (def=128)");
 MODULE_PARM_DESC(uuid_ctl,
 		 "1->use uuid for lu name, 0->don't, 2->all use same (def=0)");
 MODULE_PARM_DESC(virtual_gb, "virtual gigabyte (GiB) size (def=0 -> use dev_size_mb)");
@@ -7563,6 +7880,7 @@ static int __init scsi_debug_init(void)
 			return -EINVAL;
 		}
 	}
+
 	xa_init_flags(per_store_ap, XA_FLAGS_ALLOC | XA_FLAGS_LOCK_IRQ);
 	if (want_store) {
 		idx = sdebug_add_store();
@@ -7770,7 +8088,9 @@ static int sdebug_add_store(void)
 			map_region(sip, 0, 2);
 	}
 
-	rwlock_init(&sip->macc_lck);
+	rwlock_init(&sip->macc_data_lck);
+	rwlock_init(&sip->macc_meta_lck);
+	rwlock_init(&sip->macc_sector_lck);
 	return (int)n_idx;
 err:
 	sdebug_erase_store((int)n_idx, sip);
-- 
2.31.1


