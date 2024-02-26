Return-Path: <io-uring+bounces-744-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7BA10867EBC
	for <lists+io-uring@lfdr.de>; Mon, 26 Feb 2024 18:37:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9F3A71C2B08A
	for <lists+io-uring@lfdr.de>; Mon, 26 Feb 2024 17:37:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2222612F362;
	Mon, 26 Feb 2024 17:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hyhZBblb";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="EScKHqJm"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 699E212C55E;
	Mon, 26 Feb 2024 17:37:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708969049; cv=fail; b=Xfs/ebGENnrsETrMkv5A3H09gLrX1FgyPCnb0LnKEwEQCIuH3yIy2D3OWJ85/obFVvU+T5WlyPNjj+CojrbMi/ziAOAYlijuaE5wQgZk6R7CasL0jfhi0xwWHzzVPhi+jDdDqOurDw7WMu8fxTdJVdsHqR/oyB3pwF8a9njP3IE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708969049; c=relaxed/simple;
	bh=zIoU3/EuT+G6psR8/SEtCUH1Td8wEaAFcfypUik1Xz4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=dLnJcKkRXXfGHMPepdawJyu9M1KsFO8zMupi9LQTVSXIWIw9wnAEE5qs2K055JqNvt4nRtUopixwQmL2fVOaLzbwcnyIbSWKffj4dW50qP2mSsL2Pytt9aVvMjgfzcKTtfFMksx5YZNRe9UuSl0rLB90ZxVbpPGWh9PQ+yVl62o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=hyhZBblb; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=EScKHqJm; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 41QGnP2V021423;
	Mon, 26 Feb 2024 17:36:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-11-20; bh=Coa9gYE3QHfYsDoksI78oxav6vW7nNHzCNG+kE95xZI=;
 b=hyhZBblbcQ+K/0xHFlrv7zQDiSNjM4OTIKHX6cUx9gPsKQYxp43yX1lgwZP/7xDBae/t
 8+7DbMoWzVWzXhmn1FGhlxFJt9uy5baBOM6jBoPoDJcW/Vk8pg5wdZHzGMrux0EZRVGm
 oBxXu/P3dmpoSyBDPxBlVbQuRHOgoG10e6hitsdTbqodd0g4ZpB95AlfF5abKJSZ483F
 0JwEuBclsCGBjIKhcKHDfLMIxvWy6v5mZzzWhpyfdT2QlfhGq61fMzXzHsZbB1yF074C
 naWZpZmclEe48QA3+LvJWtsTN6uGlbzhxkrW70e97QdTV6gcyBbPNLv2y8DFFpcFLNK8 ow== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3wf722d657-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 26 Feb 2024 17:36:45 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 41QGwcM3022363;
	Mon, 26 Feb 2024 17:36:44 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3wf6w61t9q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 26 Feb 2024 17:36:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mnI6avE5WRk2O/fzmg6S+bwxjiuK86b5jUgG9Jp+d8bv9GReAbD2DM9le1NJI5+537xWhwaEsk4Ih7HxCm2T2ahI2f0LQuWGi8Y313JMD5TxSPHOlY/VexaH8d/O2nShsfCTi7qNBLP2jat9sjMw9OlylDkMzgA/DZ3+D4JNrS2X+nekFR6u+RV52LM3jSF0ky2isNyUYG2klt+VBEcc2dZxgpYBA3qlYXBm1pjTc7rDd3aoFKHMP11h852yv8JXuYEay0o6g4PG+MJerA/jZYpO83Tf+PtPMHKglB0ch16WWitd0PW4+g0tmEk8nj3xwASvtOyt6WZ1qETv8QXQvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Coa9gYE3QHfYsDoksI78oxav6vW7nNHzCNG+kE95xZI=;
 b=J/9Hp8uA9EQSeVp4YfgwjqBF1qLRfO90x4JsHrgYqJPVpreM3lpTcnGBgWp2fNEo9JgtX2i6dfgLmleMpSGMrC8T0eFYI9auWAuQhEMrypJPqcbBZ4rYRUEgWG6pdii8N7EGcOi/7+oQz6AInSt6Jl7lpimnQeH6DpROZGwdbhKEz1G3PV8cRe0AH9Ox+EpnFTBkvO5ZCij8l3vkCUpsdCC7etSiQct6QMxPIoKBV7P+mEqrlv8dHY/OJdZimO01pL9glHn+94PtMAHWnjU7FahuHYnJ+iiPHAmW9/KxUcRkQiTrnpgjk8tvt8G6v4FTcmll9x8ifrCDs5Iopio2zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Coa9gYE3QHfYsDoksI78oxav6vW7nNHzCNG+kE95xZI=;
 b=EScKHqJmy7eSs8Y6pvckEAZrTDf2D2RaRSjcv+dmYR+wGTMmmZVTYzCdZCmniJ98GUPZ9ZFg0HN2wjXTGn4/R6HgnuTZ4aVCAqVRFD7ggFjztQ8g7D2z29ozTlRaxEp8wZ7aKO7+9wLFhqx4kKJUtLsji87qRH/gcSB7CnFyVfU=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by MW4PR10MB6298.namprd10.prod.outlook.com (2603:10b6:303:1e3::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.34; Mon, 26 Feb
 2024 17:36:42 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::97a0:a2a2:315e:7aff]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::97a0:a2a2:315e:7aff%3]) with mapi id 15.20.7316.034; Mon, 26 Feb 2024
 17:36:42 +0000
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
Subject: [PATCH v5 02/10] block: Call blkdev_dio_unaligned() from blkdev_direct_IO()
Date: Mon, 26 Feb 2024 17:36:04 +0000
Message-Id: <20240226173612.1478858-3-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240226173612.1478858-1-john.g.garry@oracle.com>
References: <20240226173612.1478858-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH0P220CA0027.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:d3::10) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|MW4PR10MB6298:EE_
X-MS-Office365-Filtering-Correlation-Id: ec86ca45-bc3b-4a83-3e58-08dc36f17ec6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	Ux1GB5gtfk6QUygcidjaCOAnwhJLgwKzwRNZT2Y/uKhh6n98vZ8k9EQ9xtpz8RTvoqTmZMXSNUK5pj2yigPLYMtwUI7rzPo4ywD0Zh5NzPwW6l3+1PSp+Zuj+ijemV/Yw35QPweyr5ovyrVqe+1Oo4jbqzooLEPTq2clJHX/qyf00W+N71fi5J18wfabuj2RhC+Zj0oVizxsNnP/hMRQCHtdk68TKPcpEIas7D384xMPmRX+OyXjjB/Lwts8WBN/+gYwhFKGPzNF7syHAYJEaiRv1IRRr3jpOSmDzKmKUeFbsZZQ25k/xgSFoMq+Cl5snG8XZDqti4u1pznjUrx7sHDQ8A5Pa7g2QENFBh6nscaapPaOLFjcXXfToGefFnI6bRRoMrVxdWPb/TBtMmHfBsOhLyj9p4/1fmcq2qdbh1OqtQ19EOeQ8n4pZT07vHZKxTBsr71cz74pmkFoXSuCIV8Hdq0yR4HTrhkvZRMDXgVNDL3bNSvz12Dk0ZP3JEhmiSExukV1R307fvMg97AeYYW+i5uIv7KQF2VMwAC0DSiUR+zx9Z0JPLsBI+XNJ+/GcM/8qcY3N+Hd+IMD4odZ66XaPbQHSj7/XqD5vFpefsVWXs6GEmMcop50a6IuhAMJphkrIw3CUfj1WXjd2ZytGRXwtKkX0tCXFy9TCtWqgnGdFVRekhzpn8dKoSLNRwXgj3vD8VcAIZNLJi6/aMVIww==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(921011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?uZR/wuerVa4oDaN/SxKj0dZV1hMD6i+X5V+T3UFi7qP5HgNa9Q1NVrE5r9Wo?=
 =?us-ascii?Q?rKx8Cz99DCIWwJxELGEjVolrhpxLfZOzWLc8EB3LffYXwfgKh7GW+vEB/xoQ?=
 =?us-ascii?Q?b+hncrvalCSxL6CGOjJ6nuC8UWzd0QHKYEKW8jsC/sd1wEaB16STMRYWzTAy?=
 =?us-ascii?Q?ljGsw5bzjwq50iqHBH0R/62NWC1f8wofL/7p3dVFkocyHxQviLXLy1uqMYkl?=
 =?us-ascii?Q?lYN6u+8daGpHHGrinEGjQ7bBYEFTH6muSXmBF9vI7AYQQ4+T2FDgfBC5xlMk?=
 =?us-ascii?Q?ua9kz8Wb9bOELEV5X/+oWHIuPZEmcbfEfoVmU+YwgtlvdvGeET4BiJBYVwaz?=
 =?us-ascii?Q?ynZk48DsLciuNrdDE5HMGJNGZOKYVrEha4FbIo2NyE4MoOzL1zTeAL33rHFz?=
 =?us-ascii?Q?0ThHD9FmkWFNhsejgpdoYHz651XRvZ1E8hKBUTy9Fx0a8yhhba9vlt3NuwVv?=
 =?us-ascii?Q?WKGEcu8DSbUuSXfsBULWed9kyOwHXsHTXj0BqeWEQZ31RAPDntBfq6GKImsI?=
 =?us-ascii?Q?2NCyzrb291R283pzVze4IzXBjE0TcWbPStNvsAZzUjTGRLYAONQETJSlBG8k?=
 =?us-ascii?Q?xq9ZL5kmRP6oJDsc6k+U0RtrcAKGVbB8qug0GzJwjJZrM1oX+ufKlBn7i9y/?=
 =?us-ascii?Q?2aPpS1gi9Ml1VndJZzIZD1RJnN4HUTB53hM597UK0UvdOIB0v20ltUDJKfnH?=
 =?us-ascii?Q?J07WudTyx78ICsfKXpEIdHMeIDwCGvwqQY4UwzizqFywQOjE/acBjYlQ66+T?=
 =?us-ascii?Q?N/kb/yfnik10+l+8I5fE4rcMjovrF1F7H7k4M6JGGLn6uh9zgSH0n5ns1nBV?=
 =?us-ascii?Q?BOVZ7blp/XBtaFVg9vKvgJQiDDVtLOA77dBOKnDiiTM/4snKc2lczBMyF2nJ?=
 =?us-ascii?Q?JwKrNimg8s6i9Mdjd2XAgS2xE2bbrVTyOSmndWWJSi9kwLuMBg5flnr/IOfw?=
 =?us-ascii?Q?RQmbhckddOFdwL2jE+zaxIF2TsxJLZGnU4dFjwZ0Rqo/0lt3NPqR9+mAHESf?=
 =?us-ascii?Q?owQZmLE+XOI1qJgmgYygb06CMqMRTMzvl5Ue9stoSTOgfseOdWl47PsylX40?=
 =?us-ascii?Q?kP4iDaNxStsenwi/4UttlbGEQYHQYjPNDeXCoRLrP/+5pMP1dY2pPN6pfGUO?=
 =?us-ascii?Q?yJchJftXIAct4olRDsMqatHl0AdfbSlU3VKWX54k2VSSMhE29OfErgPZgtL9?=
 =?us-ascii?Q?omVLJoVnFmxKhTC/vhFF6cazMh43YM+1zswf1Lt+edqEUWWTTNs5BUguHhO1?=
 =?us-ascii?Q?s76s4lLR7Zd6fyMW2nWUPSNZH9LFg1BDVR4vDH7Bu108VAi6rSOGfk5jhVgN?=
 =?us-ascii?Q?WqGJGHRw4cEjKpLSeaXemXPhno2MXo+QALbBtPlaee+sOxAZVE46UZ51d3Uw?=
 =?us-ascii?Q?PeS/wQIzSLykx9oUR+wG0REDiWYjev0KFt9eM6efbLZGiOuSSMdNb+t3DYxU?=
 =?us-ascii?Q?DTfO2R/rjGa0+LKi5dme+RU6WXFoW41pWoIuOqtDR6AfO/SLbEg5GzS+bd+g?=
 =?us-ascii?Q?tqJZIrW8cJFIw4Lg2EcMPKRohpDIZcHgxZVXC7xmEIJ6ha/iKdN8Vhyyfa4i?=
 =?us-ascii?Q?Md6Fv6X7pK4yvbsj5RkFChRHabVbZ7IfxUsCvieezA1ACJWWW8IDcU9YOsnG?=
 =?us-ascii?Q?MA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	N2aOFV324Av+ISbAGpLrVs43WCBsz7GHu36mo1w1cG6omN1s4dippo7ovtRisweH9N/eHVz5P8oqaAjQCJKoJ/2s+XDZZW+dJBMSXRyVXrpFQJ8S5i0eaIKZJankaMbnLdUweC1k1fXb8L6LvlB3LsAH14gsxeYRK1NYIDi3LVH3Qs4niuXtXldLg5HlGvSjkOA+0BxFapOG9UjdhDL8rdGV03tTzoBVcQ7onfJWi+0ayO19Bh5eOrItqoIQzjnXQUgcI2QBy6T1t7bYqbyOJyVlcfKvJc0H8KoWVX/qf9o8YQRphGcoCm/qELPuOhHiyDYHWc2ef4ZcmTliStA/fVSwl4y2VasodifwP8dZjt1Xqm9V18QtZc9dMHlMu+pTSF4tudyl5KTOAPHOVFRFh47n6Qys/Etfl6AY9uqGq1+HegaU4x+6uJwY21tj6bolCl+3cCkdoJ4Mz5SzMQnrX8em49ylKsK1nvgTNxYEWHZ+4biDkhL5OZOFUBdQXbfiA0saenriZDfIFc68zyZLPzKV+8ZtabY4GS09dltKeuiMqoFuAeqxcNO3ishsBeXSd+Z/nMjyb6qaNLnqBmjF29YLck1kpZBbVmjVFLKhzpY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec86ca45-bc3b-4a83-3e58-08dc36f17ec6
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2024 17:36:42.2526
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nAmIXPyEc0lb9LZDLfyvA6V1IkZsT22foLObW3GfLLP7INHGDoV6fiBYrQkEcw0mfHhgMaRDvNczgMuJBKQ4oQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6298
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-26_11,2024-02-26_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 spamscore=0
 mlxlogscore=999 adultscore=0 mlxscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2402260134
X-Proofpoint-ORIG-GUID: 0CyouJ1CFlKPERxj29i2nnopRWW5Yb7t
X-Proofpoint-GUID: 0CyouJ1CFlKPERxj29i2nnopRWW5Yb7t

blkdev_dio_unaligned() is called from __blkdev_direct_IO(),
__blkdev_direct_IO_simple(), and __blkdev_direct_IO_async(), and all these
are only called from blkdev_direct_IO().

Move the blkdev_dio_unaligned() call to the common callsite,
blkdev_direct_IO().

Pass those functions the bdev pointer from blkdev_direct_IO() as it is non-
trivial to calculate.

Reviewed-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 block/fops.c | 29 ++++++++++++-----------------
 1 file changed, 12 insertions(+), 17 deletions(-)

diff --git a/block/fops.c b/block/fops.c
index 0cf8cf72cdfa..42955b6a1f5e 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -44,18 +44,15 @@ static bool blkdev_dio_unaligned(struct block_device *bdev, loff_t pos,
 #define DIO_INLINE_BIO_VECS 4
 
 static ssize_t __blkdev_direct_IO_simple(struct kiocb *iocb,
-		struct iov_iter *iter, unsigned int nr_pages)
+		struct iov_iter *iter, struct block_device *bdev,
+		unsigned int nr_pages)
 {
-	struct block_device *bdev = I_BDEV(iocb->ki_filp->f_mapping->host);
 	struct bio_vec inline_vecs[DIO_INLINE_BIO_VECS], *vecs;
 	loff_t pos = iocb->ki_pos;
 	bool should_dirty = false;
 	struct bio bio;
 	ssize_t ret;
 
-	if (blkdev_dio_unaligned(bdev, pos, iter))
-		return -EINVAL;
-
 	if (nr_pages <= DIO_INLINE_BIO_VECS)
 		vecs = inline_vecs;
 	else {
@@ -160,9 +157,8 @@ static void blkdev_bio_end_io(struct bio *bio)
 }
 
 static ssize_t __blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter,
-		unsigned int nr_pages)
+		struct block_device *bdev, unsigned int nr_pages)
 {
-	struct block_device *bdev = I_BDEV(iocb->ki_filp->f_mapping->host);
 	struct blk_plug plug;
 	struct blkdev_dio *dio;
 	struct bio *bio;
@@ -171,9 +167,6 @@ static ssize_t __blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter,
 	loff_t pos = iocb->ki_pos;
 	int ret = 0;
 
-	if (blkdev_dio_unaligned(bdev, pos, iter))
-		return -EINVAL;
-
 	if (iocb->ki_flags & IOCB_ALLOC_CACHE)
 		opf |= REQ_ALLOC_CACHE;
 	bio = bio_alloc_bioset(bdev, nr_pages, opf, GFP_KERNEL,
@@ -300,9 +293,9 @@ static void blkdev_bio_end_io_async(struct bio *bio)
 
 static ssize_t __blkdev_direct_IO_async(struct kiocb *iocb,
 					struct iov_iter *iter,
+					struct block_device *bdev,
 					unsigned int nr_pages)
 {
-	struct block_device *bdev = I_BDEV(iocb->ki_filp->f_mapping->host);
 	bool is_read = iov_iter_rw(iter) == READ;
 	blk_opf_t opf = is_read ? REQ_OP_READ : dio_bio_write_op(iocb);
 	struct blkdev_dio *dio;
@@ -310,9 +303,6 @@ static ssize_t __blkdev_direct_IO_async(struct kiocb *iocb,
 	loff_t pos = iocb->ki_pos;
 	int ret = 0;
 
-	if (blkdev_dio_unaligned(bdev, pos, iter))
-		return -EINVAL;
-
 	if (iocb->ki_flags & IOCB_ALLOC_CACHE)
 		opf |= REQ_ALLOC_CACHE;
 	bio = bio_alloc_bioset(bdev, nr_pages, opf, GFP_KERNEL,
@@ -365,18 +355,23 @@ static ssize_t __blkdev_direct_IO_async(struct kiocb *iocb,
 
 static ssize_t blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 {
+	struct block_device *bdev = I_BDEV(iocb->ki_filp->f_mapping->host);
 	unsigned int nr_pages;
 
 	if (!iov_iter_count(iter))
 		return 0;
 
+	if (blkdev_dio_unaligned(bdev, iocb->ki_pos, iter))
+		return -EINVAL;
+
 	nr_pages = bio_iov_vecs_to_alloc(iter, BIO_MAX_VECS + 1);
 	if (likely(nr_pages <= BIO_MAX_VECS)) {
 		if (is_sync_kiocb(iocb))
-			return __blkdev_direct_IO_simple(iocb, iter, nr_pages);
-		return __blkdev_direct_IO_async(iocb, iter, nr_pages);
+			return __blkdev_direct_IO_simple(iocb, iter, bdev,
+							nr_pages);
+		return __blkdev_direct_IO_async(iocb, iter, bdev, nr_pages);
 	}
-	return __blkdev_direct_IO(iocb, iter, bio_max_segs(nr_pages));
+	return __blkdev_direct_IO(iocb, iter, bdev, bio_max_segs(nr_pages));
 }
 
 static int blkdev_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
-- 
2.31.1


