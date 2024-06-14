Return-Path: <io-uring+bounces-2208-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BB21090813D
	for <lists+io-uring@lfdr.de>; Fri, 14 Jun 2024 04:01:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B34551C21332
	for <lists+io-uring@lfdr.de>; Fri, 14 Jun 2024 02:01:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D1DF42042;
	Fri, 14 Jun 2024 02:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WDU00SPg";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="s2n4TI9H"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B99B119D880;
	Fri, 14 Jun 2024 02:01:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718330510; cv=fail; b=IXxiviSvKjvdFFWjdGr1b0b9FblNEpVgfORKveumVc0Egd4B2G85wT+t3tEC5b1WTIkXjA9oTcO9JDOwiTgb3GDuxfFFL6c8ee+E4rhFseAQh+4QkDs/X+bM5SHXTnpmGFyxsxUbedKP0p1hcDZ2nrNk1eFZYqOZQy7FojFxDW4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718330510; c=relaxed/simple;
	bh=c0UekFDmB2y1/WUBZpv4rXplaxF3W17+6UZY3A+KL34=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=rmSV/qKBDSkaxS4nKXnh6INUyzaUdhk69a+5MgLmBZ0mz7gRm67r125NH2ClJnbuI+NbUTYIhpn6SIgPdj7d+uDd+JdTVDQ63ibaVMFJu6H9QMwXjWy0+09vmWF/3DGZeXkssag9GuLTy47sePN1FMM/XiUWqsHbHusavdqahp0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=WDU00SPg; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=s2n4TI9H; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45E1fTGW022852;
	Fri, 14 Jun 2024 02:01:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=1g5Q6q21dNfUj4
	Y4bGsMCW/0FiD5XMRPmnzzV91clSs=; b=WDU00SPgzEZUqFgSE9TdrIMPEj/nci
	WRT2FKIXmV3LzDmsTmRtzW9GRvFzLHI4DpMtB6jfOawWpzYIxkj8r5ppPVJJYlkB
	wd1v0pWv544QhOYCPzo/L9Tamjj2++RzPqy/mr4D16UaBqhgHtDrmEskkk+yve26
	Yx7bY1PG5HR8HJ6AdIDrDRSm8VTWUAzOdrw2NK2gsiMajHQ+Q9fEWFiG/LtH7w/k
	jWh6vTcFFzhWteSYv7k7yZBTd1ohnVt+MC1T59qO6rebCK6rrZBipMbazoqQQKgA
	6WSOworS8Is3xLK2v1d4HP/50pJ9wF8m43QDxB0H/RGAGoX9tQqsrxBw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ymh7dtsrt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 14 Jun 2024 02:01:14 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 45DNNUUs014234;
	Fri, 14 Jun 2024 02:01:13 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2040.outbound.protection.outlook.com [104.47.57.40])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3yncexqtfu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 14 Jun 2024 02:01:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ieWkw825FhYRT6CrZGfdqufhUefq/aQOQDgbd13/r18JeOCz/sWMptw3MPwekPB4MyoSCW44XsFJnyjSuSFUfNFvC7j3DChZ/ndm/8mZSPA464/wyMN5txIy8/LYbE7t7J6j5Fo1Oe34HqlpctfGrYAxVQThjb7SiTYB7MPV1ey3hUD7uA/oXLfiG9Ll9cRm50Rhc34HGAbKIGe+SU1Kz/n/oKsEkBNuSCgGK5QwvL6BYNKatitDPhE3F11rnRYbTbMRHxZ257e/LdcxhPMx3WFioZNlBvcZMUpRWrX4Ge06DCEwbHfojNIvIU2YSCkXq19rHZ0s2eJc8mdQSC+WOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1g5Q6q21dNfUj4Y4bGsMCW/0FiD5XMRPmnzzV91clSs=;
 b=AVcIM978i9kUdYQZmaOjscWDicQ9qlqmr/aSvO4CpEw8T1Be2oAmw0IMyKANcdq4GSq8bA9a4rD36/fBiz3FUop3cvAL9CuYGj2jshQgZ1mgODf6/vvO8P1CI9nLUtgwtaHptXBMmuIZskkrKmJcz4pHLMB96iowBVqCf2CnKJ/1Ubd35g9V8XHCqIkOKS9GCQXFavuenmt2HLiIpv7cY+E6T0QDTOQ8q9djng8aUJlBQWM9DU0m1S60BPpQzoaKaqaaTsbuPnvukmNSISe9ksy5k9khnfX0ccdTkGEHOOW6Q+3UhlQy2MrtsCX+7UCTbpbv4+HDwr/qEjBEDs59sQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1g5Q6q21dNfUj4Y4bGsMCW/0FiD5XMRPmnzzV91clSs=;
 b=s2n4TI9HoFahgrC61DdxbTqPWVflNZobaV85NADPRIxvsCBjZpnsHoujcpvKSUXum9uUT0QGadtrIRZZ9iiHf+7js0JfJ3Hol+8/byqV1tJi0G19G5aMFK7Dkg+6FzV4KjucLAjGMnRIT1S8qCDyUfHoslsH0354M0Ze0c0d+Fs=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by SJ0PR10MB4607.namprd10.prod.outlook.com (2603:10b6:a03:2dc::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.36; Fri, 14 Jun
 2024 02:01:10 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%4]) with mapi id 15.20.7677.024; Fri, 14 Jun 2024
 02:01:10 +0000
To: John Garry <john.g.garry@oracle.com>
Cc: axboe@kernel.dk, kbusch@kernel.org, hch@lst.de, sagi@grimberg.me,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        viro@zeniv.linux.org.uk, brauner@kernel.org, dchinner@redhat.com,
        jack@suse.cz, djwong@kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-fsdevel@vger.kernel.org, tytso@mit.edu, jbongio@google.com,
        linux-scsi@vger.kernel.org, ojaswin@linux.ibm.com, linux-aio@kvack.org,
        linux-btrfs@vger.kernel.org, io-uring@vger.kernel.org,
        nilay@linux.ibm.com, ritesh.list@gmail.com, willy@infradead.org,
        agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com,
        dm-devel@lists.linux.dev, hare@suse.de
Subject: Re: [PATCH v8 00/10] block atomic writes
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240610104329.3555488-1-john.g.garry@oracle.com> (John Garry's
	message of "Mon, 10 Jun 2024 10:43:19 +0000")
Organization: Oracle Corporation
Message-ID: <yq1o784qo4n.fsf@ca-mkp.ca.oracle.com>
References: <20240610104329.3555488-1-john.g.garry@oracle.com>
Date: Thu, 13 Jun 2024 22:01:08 -0400
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0180.namprd13.prod.outlook.com
 (2603:10b6:a03:2c7::35) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|SJ0PR10MB4607:EE_
X-MS-Office365-Filtering-Correlation-Id: 6a27069c-c98e-4ce1-f7e3-08dc8c15dcc2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230035|1800799019|366011|7416009|376009;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?63pC2hSh2lWa9jBuIR3FoWO77Wg9SGAmD/ucVOtGQKA6wYeU7C4OZHS54j93?=
 =?us-ascii?Q?kLzl1psHI03oaseqhIGXppGfzRuvKzVnxZXAW4SRBj/28LwikTCAAIAS+MRj?=
 =?us-ascii?Q?cilmF72A+FaZOD+5GfZNXeTSm2wYkH5HtftCJObEbQylTlBmMNnZDTsyZ76k?=
 =?us-ascii?Q?xjKxHxlWutEQSaVLhCsA8pKQyKRfowtxhXJGrjkhXxXaPDZV6OWQZZMO15DN?=
 =?us-ascii?Q?GwlvtO6rK73m6MzISLVt+eJ1qaH2KxFgnCYG5tUEiuYx11o0WE1Wk0vTi7jJ?=
 =?us-ascii?Q?reG+TlWlMDVPyfKOaGJOsKawVxflRSsNo+3i6aIufZx5ULZFlnp7d1xmoGJd?=
 =?us-ascii?Q?fQoE0Fe2yctQiFswJ4jBQdp2izLqYbMGcjduVfTghl1dZMcwgF80V94DMH2H?=
 =?us-ascii?Q?XZP8j/1blzk1ODU6whIKcqWmf6Do0bzM73pcMv961iREdqB5hbWdtzTczB7l?=
 =?us-ascii?Q?uLEC18M+FgEcYzn3bR7/rCi8MtBAwwwreQ74h8kSNR49w983M/GmPJWyu+eo?=
 =?us-ascii?Q?pDJYG4ukf9ZzAafIsNbs534giDdnGIqrzBaQTH0MyoN9JMd9bbIaO1lhoj/m?=
 =?us-ascii?Q?xUsrxeO+U2ZrngYRRqrf1t/d+WLPMdKr4wkFhKMORpkzEx7sVgETsjheRv2W?=
 =?us-ascii?Q?LwOtvtrgYsgGC646l4nF76Ib12VKEs1EXLRPZVx2FwTo6t73mv0fSVUa9tnr?=
 =?us-ascii?Q?gDH9ZEDejPREn1FG9iMZbk1m6XiyWnPPRWJdSnwSq7xMCM3TZexBMGEeYxaK?=
 =?us-ascii?Q?u9tWaqH8p5jH6cVamcXX2FDGPAGjUfwsRaYK+5/LYSCrpSTZUGWXRV/JQfgi?=
 =?us-ascii?Q?DYiTpHLwlDkD0wEiy+ShBek3Ed8BrCw/T+GzWchv8EmqfJBezL2q9DY+sIG7?=
 =?us-ascii?Q?wPCJfUYpivHUYlbJjAakWA62W0R774tT3pwqbUgZDo4HxKpr+Jk46dDZNY09?=
 =?us-ascii?Q?pqIcCKgpxNfX1v5mKKssGCCYrfTo76QFvrmuTplExmkfVqtiBnXn+RKCkU0d?=
 =?us-ascii?Q?2RBcau0pah9+CcVFC2QsFC3iVEoEojS8yRU7+a7eSR1fR6sWXVlFT8AypR4L?=
 =?us-ascii?Q?yzGaLGU6rWCJ3oFbu4B53ZdoxLcnUHrE2PuUXpDzBxebQFkL0Gyt0ycT5MKt?=
 =?us-ascii?Q?PenD+SmVvc6l8oXipL/Iw/ATLzOKRoUHpV4s1q6i4rj4tSjtWNdCs6zvJ1aZ?=
 =?us-ascii?Q?KmO1j5PNa7sSIoBq6q/EW1XC5biGi+RdRj/4zz9HZz18ipNlbGjK55gGoUwe?=
 =?us-ascii?Q?ENTt4UTqAxjYkYfgypxAAw5Avve9XqKtaClam92gU4E4gm83gMtCksOGbD4+?=
 =?us-ascii?Q?7xImeWtgAW+pLWxT9LuA2CcC?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230035)(1800799019)(366011)(7416009)(376009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?cxriaJhElXaui8w+6ps8B9zTyfH2I57s0yiThjyDsQ1NvNM59qoJJ+feFW+k?=
 =?us-ascii?Q?no4RDm/IUgCKagCHBZmMifYTqVTQJUGmSIP2wDON511/Yp9kHrVgKfn4beaH?=
 =?us-ascii?Q?FaeehNMfuh+yDERsCl6OoUi5KHUpXUacxRNQJA0EuBzolHLgP7YyrykNoigZ?=
 =?us-ascii?Q?Ysl7xgxxiRlIDYAYRGoKs4y9HFRx668e7LdVdVoFKdkZZVJdzjDkDXIgyRAK?=
 =?us-ascii?Q?pyGOHBPxiM0ngbebvG+bLP1Kt6fcpgXJEwkvL89Ro5uQ1WELm8Ck0Idvd472?=
 =?us-ascii?Q?UWmTyOw/kELxpMZziZO1V+Lp8MHr8h+mIEnDto9XhCWiOwSDZJ4PzauT7p4V?=
 =?us-ascii?Q?hZq1RPWQNYFCU7EtHWtRd4L46HpjeAIfiCrZFoSqETX12/7kd23VCclh8Lmh?=
 =?us-ascii?Q?16vcbCzsc/74yBCfYxvP048CecG6kgnXeh2yiPHVo70CFDtN0LBLxhMSMKPR?=
 =?us-ascii?Q?G7uivJLIxX1PWjsaKUF7lMMLhDYeGfuDq5f6bVqXldjZC4Jcnxazcb38tU1t?=
 =?us-ascii?Q?h5ftV66UO2ZXo4RQxLzMl3010NPdL3LD5gUL+mZUESdvF1dkYya+HDpamQzk?=
 =?us-ascii?Q?78Fysb9+uBJkjyw7uEb86SiZcJ1iI2lDwZspUbMcvlE6h5jYtYZj3YmYKI3/?=
 =?us-ascii?Q?aisOsLdA8CNeKKWhfdk16KR/3g18RHxEan4ic3eeMpSBEHhoI77DHAE7N2TY?=
 =?us-ascii?Q?yDpOFaaxnzrkYrGXIjtes8IsTHDrzZzy56IcQPa5RyGu6uiq2eXh6r5KBrvo?=
 =?us-ascii?Q?IkiJe5CFSzKKGfiZ86IIPCy6iisl4JXOLR61gDbtve6AtfxP6gfo/zSJbYQ/?=
 =?us-ascii?Q?v6yxWxr7y8l/zfc8y2S7ksSYdmy4spfwx/OlOB8gu8od1VTJUPMRv5hHAeeb?=
 =?us-ascii?Q?Z+cExIJHg6qotiGUi6ie04D7SxjgNo6LvxTMnFTHvpEBSkIZozJotAAq0nY5?=
 =?us-ascii?Q?eEe27SfHs/ihJ4iE+TCx2k0SL/2cZnUrUhzyYcyWPbHdlWPzseOwhsAvZOaK?=
 =?us-ascii?Q?ZrJCKGGCoAgep4+K8e92qkGCKlSg4Twj/zvnZbcpT1+K5t9kBQF5LYVJjffg?=
 =?us-ascii?Q?/L612rmf3PovUyBL13YPF4uY1T9f1dNAilaSlMh/g7CZX5R2bHCetBNX+CQZ?=
 =?us-ascii?Q?UAHg9kw8RMmxGnX0PTWB4pmqKoeS4roqDqjjo9BLtnfjjPJLSNWUuOUOJjwz?=
 =?us-ascii?Q?jhmEM2o845LoOTojEljniL0ABJNLqxG6V/G6asHKNk6v2qwL9BO+tiHnC8pB?=
 =?us-ascii?Q?/4LYFLlv7eN1LTFBZRTLfo/FQLsuwcq+Buwn9sEYDSOMwzCqN4FD87r/07aS?=
 =?us-ascii?Q?RcPk5BtYk/6VYzh86Oetbfs3JDAcSEXt83eow2Y1Z97fCvgYIsW1QqnImarH?=
 =?us-ascii?Q?xjjAjRpmrIhH+u2n5kO3qd5woY7X2xQHWp3IwsZ/ZVlRWJ9PfNvfC9q7zfky?=
 =?us-ascii?Q?tbowkPi1zvTI85jwqCry3uUz/X2h307ZpwTIb8NfJ9264x3KjM7MwsPZ+kgz?=
 =?us-ascii?Q?kMgPAdoc6Z3FBi41K3Tx+9kPUDPAHoef7n5iAq2mELHxguDaUCvGLqEptOqn?=
 =?us-ascii?Q?X78Lepe0ovR6orOblkDXW/dWHLGWXzZyiZ9NKkDVFl3+EQkafYlVKNsd0WZ6?=
 =?us-ascii?Q?xA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	iQgrdu9UCNyrX3UmE1uK3C0qofCt2s7+pZ2LZdJaQMTWlROiMZybhrX86i6h3fvNlMw3YaC5ZSeSRHaUObnUOUKEkkXiefaQRKaQDmSSMaXDPCGKHfiddx0XayJ/Gn140aNxb9RVfVPCua/wO+ybHEUnFPVaYUM+sG06r6NIo4mHbikdRtAZ6QMrKskrx9fZ4PfSqqX8XC0jbpmlVbcV2rZpzx0mpJ60QIxZGL/IrkMPdo0fAOf1k6hMDR+N3yN0NfXVVocD/hnw3Ey5qaHy50Pc+mdxBwurwvXNpnasDDy2AkzA5ov2bXvghmLpLWI/enDyZvDYIMxtgYHwkul7Rb3uiVEgibnNt3wk5Xx7yy8Wcw7RBNPIay6yQVfu9c41MX04eIfvCk3PYzhrsxHhy69n1F32sTvAlIDrbx/90ND01BXNON9NQUM3ZE7oKwS3G0ryIxM3gvaW8IzYg8hC0qTqTNMFTfLe8t130+19NLH0QhUfcgzhXX0VAHvA/BKUlL4yDAlkDnNuOwTAhEsGQcEkh9v2RmYKVQt0JvlyrNArH4+4cKgSJUktU3TEZHXFdPXv+r6suRsYrefSbiIPAPgQVnljlTad0v+ul3ET4l8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a27069c-c98e-4ce1-f7e3-08dc8c15dcc2
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2024 02:01:10.6888
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aQChr3/K0Aw/hWbImKv7PiJp9HfEoYHct1vXwuRNCKCSOeiB1+XpR+Q1oZXagLT3PLvxisMwr5l3gYaZZXU19G9F4wW1zeAnFcZ3EjAabBY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4607
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-13_15,2024-06-13_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 phishscore=0 bulkscore=0 malwarescore=0 spamscore=0 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2406140011
X-Proofpoint-GUID: eTjfDJYz809GXFf4rBFhT_Khl7tja-qb
X-Proofpoint-ORIG-GUID: eTjfDJYz809GXFf4rBFhT_Khl7tja-qb


John,

> This series introduces a proposal to implementing atomic writes in the
> kernel for torn-write protection.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering

