Return-Path: <io-uring+bounces-626-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B10C585A40F
	for <lists+io-uring@lfdr.de>; Mon, 19 Feb 2024 14:02:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A3F291C221A4
	for <lists+io-uring@lfdr.de>; Mon, 19 Feb 2024 13:02:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 490C8364AB;
	Mon, 19 Feb 2024 13:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZDemIUuI";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="w6Z0+fjy"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B56933CCF;
	Mon, 19 Feb 2024 13:02:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708347750; cv=fail; b=YYcZOzdi9KfbZfA2czmQX3/OWSKeRbfH5UOb8SoRHwyybWy94ofKbPHTZcHZrRAgS16V4jW4ULnGTleR6fQMmtzicR0ju3HHCj43PiWyfc/JWWcdhGbMLoeQ0QxfszKkvUdCsc/cDRRUhO1qifed13snpQjaWyTrV4/y/lyVCoU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708347750; c=relaxed/simple;
	bh=8u4guSDktnAtaKEvQwbYHsVOTGUC8JhenDHwA1jIYiA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=CGtEVsJPwoE2hFWOuEl/yCPnvjM5DTU6XtA2UsGCqQJxcaiJE3U3l/eC7NgjV3dJyOtVcBA+fHt4H8kwfqbhoDeZdY+JCv6QUepbItPM/BbANbVxb9WDBUDAaHw1g2tK1VSmnRKPL+jkdLGWd+x6Vp4bzmRfrMzx9qxF6syBpR0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ZDemIUuI; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=w6Z0+fjy; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 41J8ODLG003525;
	Mon, 19 Feb 2024 13:01:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-11-20; bh=o6NhbSPXUpYU4XkkJ4URgK1dyYmTzpwsYZQlwgir4Gc=;
 b=ZDemIUuI+xTpVfcavTWgeyOaK3CIv342PeJhnE2eKBKqWokORa3KO9AnIu2CIK5/0us8
 lAHPyLLSNKhy6D5FvhfNvUd0tQuE1MLsTEHqsOVuQh2fhTdYrst+dWZEX5m3JodJmI4z
 KoHX6GOJubfEN4pYyiTlmpR4Cg0a1B9+08HM6QSt5/CmMiKlQcy9RCcPMpFvsOblHKvi
 YbbfYtX2oPDdgnOFGN9ETbJ8Hy8SiyDw66CyVz95bFBoGWJoIykXY+jVZ7eg/XcR5LlL
 ++2RQU2Yyt9466h7uMkuoIW8Sv56WEBQHxP6wKXiLdY36cYre1OBAkCCXoAJq3i5TUSI pQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3wamucv3yw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 19 Feb 2024 13:01:37 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 41JCP5Mb039639;
	Mon, 19 Feb 2024 13:01:37 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3wak85w570-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 19 Feb 2024 13:01:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NuVHZDppRyyck7UvbIqUhOd2AtwzkJI+G/CmMFTdQ3+sfnDb9biHxgH92LmfgHhy7K6pc9U7bqa7S9rKbWbwD1ICItFQTIrDVvAIqNouZ+++iljeIt5UuYL/qm1qJmBDv3aDbD31+9lI9qy6rPczwKGcz0r9sRg2yp8gWj/8yxdg3eyTORgI7l9vh7XkCG+whp0PVujVUOvCynYRJcNebL391glvqMxOdkvevhdH3Dj4iXuKNyAi02eoQGuCdEYJDA1me5VqCfXCvbT6XJ1JG+weh0oP/VDmSpWvY2LIwAJElcGZ0D/dNmMeqZ9+sm1DjufXaizZK2Pb7sZHcuczVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o6NhbSPXUpYU4XkkJ4URgK1dyYmTzpwsYZQlwgir4Gc=;
 b=Ga9ggAlt+cR1dfJLxGAZ+uSZ6ta2MydAhnXbqel/MNV5+GZrCqXuVEWgO/4NNKnX2/YFD0FKfxWNDgeZ2dGPaZxXqOcCugunV78Wb4YyYc2YGVNQAwM0ejpItOABfwDNF9o352Eq/kO9K5YoJhTIAv3kr0ypzepVBqJoMheP1HyLkaOcbPAMF3YZOh8mveJ8Aq9XXVNhmJlFPaYSgiABC9Rx4qFl79Xs6b4sdtBa3FSUcDZfd4fusmz1TouQqzW7KrhBCU53inqTQg2QS/PTW2KLDkdtX8ITX3050HKTEPRBy1n97qKeCCDzaaTICZ0hlfVkD/aaDT9pzBiozq4MBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o6NhbSPXUpYU4XkkJ4URgK1dyYmTzpwsYZQlwgir4Gc=;
 b=w6Z0+fjya33hxk07xzD/IPN/o/wv52p5MQdimtrQGVTPzBRC2OBcubtmdPGg4rIto5CBnFPDvfYiYCuaCROJKiK5NDIPE4iVtP13QeEdlOpXzKF4DU94G/bZWPMxTvE346k35OAaOsMK3+6LcTJpXXWov/3gSACuvUFt8GfgfOo=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DS0PR10MB6894.namprd10.prod.outlook.com (2603:10b6:8:134::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.38; Mon, 19 Feb
 2024 13:01:34 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::56f9:2210:db18:61c4]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::56f9:2210:db18:61c4%4]) with mapi id 15.20.7292.036; Mon, 19 Feb 2024
 13:01:34 +0000
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
Subject: [PATCH v4 01/11] block: Pass blk_queue_get_max_sectors() a request pointer
Date: Mon, 19 Feb 2024 13:00:59 +0000
Message-Id: <20240219130109.341523-2-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240219130109.341523-1-john.g.garry@oracle.com>
References: <20240219130109.341523-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR10CA0007.namprd10.prod.outlook.com
 (2603:10b6:a03:255::12) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DS0PR10MB6894:EE_
X-MS-Office365-Filtering-Correlation-Id: a95746ba-ea73-4d5b-27d6-08dc314ae648
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	RMuRcod/vGEE5VQEAH+YryFzxYttZd5HAf8kG0LBAQwLMFYuTVeAPlcI3A2C8VLKAgLjhSkJvO/7T3u7wEgj+M5CTNlcsDWn33H7qWToOy7dL11/MFw2gadVqIQsjw9cVPboRQkvo9IBRif1ImfCZ61MJS6mI4mwygZLTMdcPJ9PI5nrMWtfqTX9PZGCklV2RSIlhwNzWwFmjBilMxjU4amnUcQu3BblwDHtkL/9Xi3iE7Vsw1lmLFtraX23qxPwlfMZUD64vM0KGS0ggE+8M7QbGkFCSWYq+ZTeZeE3cLKXiZIMDoVUsd5dJwcMGGf73wb+fK8lUWPOBPjcitEaPoN5xmS3o/2sMQ2xphnBbE6Cwl9AqmnK8S17UyB2Fd5ZedVpUPni/Cfq3Z9k54zRWq/8J0/17cDNIl33+1l1cRj3To3Yp29ia0j8m2q/1sfDV+2/8LzptSIacvHeN2xJn94o6P2pTcpWd1SYraUGcLXhQJjgQOWb4CSeffnSXZyeCdIfy3edGIAhP2y3iilca8Wc/IkE3GzugE5ZhpeiYeveXvKUQhcB1esRYMOkNumTJ91SKVCJfp3LTOK7rDkxoiMyn4eYFRUjJzqDuL2KuoY=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(921011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?PbphVVvFbrEgaGLOr3N8hye2OweAlS7usPsmMIRR6ONHfxHIOSR8l20LlXmS?=
 =?us-ascii?Q?lFblGkewy5mCsJbZuWzgbVCX69o9NtNKy9D8ubzfF3l4wnUXUX27xcK6pU8I?=
 =?us-ascii?Q?7bpYR1ftv3Fan0iXWfgMwvAz7fhrjXsSHDg9NBeDAH311nM0GEvQoAbHF/Zd?=
 =?us-ascii?Q?DVSG7dxtF5aG6YVECW+naQch3QOzb8SE60n/HD4cuRrDh6d7cII4vbxxOORz?=
 =?us-ascii?Q?LCGzQDXnYDqAYsa9pDtrspSU6gH8rh7PpI42Wo689hEekdqL59xErdVVIfeA?=
 =?us-ascii?Q?Svr0ZTGuWeEa6/l1b+xAXtZwu2QUv9Lf06mPAJPCdioKOU2JzbpW+mlUx+lg?=
 =?us-ascii?Q?FZyrXzJmecm2sr8uqWCn5PqZdTdHKqeh4NPnIqMVox6oO2Uc+7XX4jXgagPN?=
 =?us-ascii?Q?pD6/SxqUrSIzx6GZqn/+zg1q0YEvdLfitSS68RP52IQaggtoztbmHR+hNs6C?=
 =?us-ascii?Q?WnETE+ImBteyHtrFkzCH4VUjERINrcxLaC9rRuDBVHJjnM0X/6b3MaZxXavv?=
 =?us-ascii?Q?aWvmEvAMqVfobPnNmirfZtxbTtDUITIE8rcEA2Ga0IptNNo1rNRqC8YQ6U20?=
 =?us-ascii?Q?zh+xfKbLrGF6iQ52yW0Sq30Qja4nRhx+Y1ThiaTqmgU1j68XAo53NTvGGAql?=
 =?us-ascii?Q?aozNYhA7xMOa7I/pVpw/uG8QU2bU7/yZV88xahSEIuPzBilMAG3DNi4GYHX2?=
 =?us-ascii?Q?iMOxLwSPmbU3zhEyZH5yRnGlU1lXSQEbQSJEFsag/KfRHcFA7fHWoNoS8Lak?=
 =?us-ascii?Q?AryvTTVQmSsMOGVWr93qkHo2pvj3JIELfX8yYw4HZ7L5Gh8IkQtnOydczWjH?=
 =?us-ascii?Q?zSufainL7uUjVPZbJEinaktp6wXst8r96Jz1FN0TqHjz7AwcGnUOTb6vbxbZ?=
 =?us-ascii?Q?TqH44cAYofSrWzUahiXpNmY+dmMTKOeOH3FWxDJQyVmwYy3/cAtttzmC4UAV?=
 =?us-ascii?Q?v6bzON+GUmhXWcJewxZuwk6ER+p2EOOJq5JvHs7TbnDwxELINqvsVXmLS4iZ?=
 =?us-ascii?Q?NguxTuWQq1FBOmkEZT4sRcwj61A+Oeqytd12Qm7NfhFAe+bZkSKBBmxDYFuY?=
 =?us-ascii?Q?bjwGHQ9LztyY9Yj2inruPWxhHhlCijcD1Cqd1xZTvv6MQqnYrfx1RB1K00FD?=
 =?us-ascii?Q?TpKr4usligcGAg2uCRCaK4mIiSVtzwg7kz/UmhJTewOWC6pq+52RVCNwxRjp?=
 =?us-ascii?Q?KOx3Sr1XOLhhUkzZFHBTL8252bRTlaYawMlN/bFWRA3P6YOwb+GLk413Px0y?=
 =?us-ascii?Q?IMJi2BjNesJzW35s+H0ebEfYP591JVT2+dhIFk2EwKnG802DQfCwlygHRVeb?=
 =?us-ascii?Q?VZ8N7UkydD41bL1/dg9IVc3ipNfzSLY5MmSWTkEdWkw3kv8ShZIyZkpyQrqm?=
 =?us-ascii?Q?2QUgy5DZ6o/j3G8E+YZY5Jep5fye3iUO+6mZ79lyZwT+vJHIgY+ljcoMpPXf?=
 =?us-ascii?Q?vVyj/FNsH8VSPdWuKyJjpXhl2vBwq2F9bIHC0PZYshy82s76HNHF3AzNSBG5?=
 =?us-ascii?Q?Oj6T4RBjizJqf9LcDh2QdP1qH4VYzio+IUKxrt1pT4K/qF4UKhcTk+f5RMOV?=
 =?us-ascii?Q?bJCq9AwJEzeVGMZovMQdwmUuX78LeXP+tfLD0p08SjgjONzF/iFha+UvPfyK?=
 =?us-ascii?Q?1w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	3uUizWB1+fLTcdZg21xgGuy7lmNfjaq15HIPD+QinP8HiA+Qm+9gvEZcIbTz/0cCes3lUsqwpDnBrfECe7lrAO0Wd4jLDvas0mJo9BE2q6i5oBwxOqI9nVxWRRZo9AN2Myde6sSHUik7/H0al5Av232ysPHJcUgmBr5yADNEYxQXm8v4UwRCfzqTIXOaGZSySIvaFgNSYLK7aLSje7Z+khJ8gL+xbTmV+Xce1oXPtTpeZJNSPNGrGI51o3gTyJdjALEhzsbpJTEt78GigWDch3cYy3/0cK0KRZXTssNuX6ENbLN/oXhlBpuHu2tCpjYdyn6CK7K+a9ZXNdUzw8SSU7uZxavDgb4rE1y9kkcKG+yvQBDSnx9ChjwN//H+pWyYNTf9NuZ3+ogDvDRZfDb0WYyQbACUlew3TbeDa2cS7GfL2wwv0yfbyQFTfnjAB974YOzqDhi7KTB4cgm/stNgM5qnu6MmpMDye4yewVaBx8ElB23PS6LMcCl39h7LfzKS33LCC0kMoPorgOSrx94tdRnjimg2FwYE8s7pJc/kE2x3GZl2iFCV5WHc90HdeNTIyklPDt3ZMHmkmMtwcDVx1owvKs+wy4ukBaqu+XN7GE8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a95746ba-ea73-4d5b-27d6-08dc314ae648
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2024 13:01:34.1817
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yBuOVX4t3PSoQvqgJx0VHa5whmkVvd/j96fcts0CLoc4CGk1Zi4dxXHrwCiN9EL1rf+RJBHC1opWv70aa14xrg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6894
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-19_09,2024-02-19_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 suspectscore=0 mlxscore=0 bulkscore=0 spamscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2402190096
X-Proofpoint-GUID: 1kxUw0izmszh1idV_FVXpG3gSi8AhgJs
X-Proofpoint-ORIG-GUID: 1kxUw0izmszh1idV_FVXpG3gSi8AhgJs

Currently blk_queue_get_max_sectors() is passed a enum req_op. In future
the value returned from blk_queue_get_max_sectors() may depend on certain
request flags, so pass a request pointer.

Also use rq->cmd_flags instead of rq->bio->bi_opf when possible.

Signed-off-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-merge.c | 3 ++-
 block/blk-mq.c    | 2 +-
 block/blk.h       | 6 ++++--
 3 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/block/blk-merge.c b/block/blk-merge.c
index 2d470cf2173e..74e9e775f13d 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -592,7 +592,8 @@ static inline unsigned int blk_rq_get_max_sectors(struct request *rq,
 	if (blk_rq_is_passthrough(rq))
 		return q->limits.max_hw_sectors;
 
-	max_sectors = blk_queue_get_max_sectors(q, req_op(rq));
+	max_sectors = blk_queue_get_max_sectors(rq);
+
 	if (!q->limits.chunk_sectors ||
 	    req_op(rq) == REQ_OP_DISCARD ||
 	    req_op(rq) == REQ_OP_SECURE_ERASE)
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 2dc01551e27c..0855f75bcad7 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3046,7 +3046,7 @@ void blk_mq_submit_bio(struct bio *bio)
 blk_status_t blk_insert_cloned_request(struct request *rq)
 {
 	struct request_queue *q = rq->q;
-	unsigned int max_sectors = blk_queue_get_max_sectors(q, req_op(rq));
+	unsigned int max_sectors = blk_queue_get_max_sectors(rq);
 	unsigned int max_segments = blk_rq_get_max_segments(rq);
 	blk_status_t ret;
 
diff --git a/block/blk.h b/block/blk.h
index 1ef920f72e0f..050696131329 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -166,9 +166,11 @@ static inline unsigned int blk_rq_get_max_segments(struct request *rq)
 	return queue_max_segments(rq->q);
 }
 
-static inline unsigned int blk_queue_get_max_sectors(struct request_queue *q,
-						     enum req_op op)
+static inline unsigned int blk_queue_get_max_sectors(struct request *rq)
 {
+	struct request_queue *q = rq->q;
+	enum req_op op = req_op(rq);
+
 	if (unlikely(op == REQ_OP_DISCARD || op == REQ_OP_SECURE_ERASE))
 		return min(q->limits.max_discard_sectors,
 			   UINT_MAX >> SECTOR_SHIFT);
-- 
2.31.1


