Return-Path: <io-uring+bounces-1225-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A3FEC88C3CF
	for <lists+io-uring@lfdr.de>; Tue, 26 Mar 2024 14:42:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5B0BE2E6EDB
	for <lists+io-uring@lfdr.de>; Tue, 26 Mar 2024 13:42:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7930C763E8;
	Tue, 26 Mar 2024 13:40:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZmIDVcRK";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="T2XAel6Q"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A0741272CF;
	Tue, 26 Mar 2024 13:40:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711460408; cv=fail; b=Mk4KmiG9QIrkj+TdJk72TuejKzNWJJNI0Urqq8IJV/gOL4wquE8CoJgIXWOgchRzjoFsdSNjU2GLj1VyCFx2X3OLmGRg4cv3JkFV3gHBwm487z63MAx3kgYP1jyfz866YsxTTTmS7WrwjCOL1K11vow5MdNpElHbILApGbs8Gfc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711460408; c=relaxed/simple;
	bh=HjfnezAHn9RxDU2UOEkwlhLrVy2rB++8Il/EAmBotic=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=YyKA70xvnDG7lI/Z9lMqaKF4rulPXNGD7QR4CUzWwFVSinV3Ot7p61NXQUk8QCozQjnBaEBTeC/zWxg1IDYjnbWJWkRb8Zk8Luu9Z+eWhKQSblHZS2C2Wedid155+5WqL8INKrasfMaQZ0Bafr80AMGbfcUbAOE/rFkBOss6KfU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ZmIDVcRK; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=T2XAel6Q; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42QBnf8U005487;
	Tue, 26 Mar 2024 13:39:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-11-20; bh=04dgZaUgnUSJOVKkaIMbfFyxv3q9iwm7mAseByauNjI=;
 b=ZmIDVcRKpV9/ykAV/BPIvSykwF1AiElWZ/Su19+AbtvkPynaelDsMEkv+cDzvBcbN24/
 3HSFRFQ6lrT7Cx6LhBha9hEMVFY6t/5aDUw+StlSw6U9fr9mmyDuupSjvFkzPVNa65FA
 89/9+GiPGaFvDqIb5Mj+wSx6TDGwTskYlqy/zcJw9ZmLUxjmE+qxc6ePGHKIEtx74FPM
 LTdiCcWZoufaENxYTInOVNcecFMN61teUEqFlhUFIOqktyZWKarnAiZ9NS8e6V2hMsY/
 izBhhO8uZO6D8i0fVk49nMfNqr12XM5+EbCO33d3gqW0VQWKThPDUumLsEUAYqBkjEJ9 9w== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3x2s9gufjm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 26 Mar 2024 13:39:25 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 42QCMTOW013260;
	Tue, 26 Mar 2024 13:39:24 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3x1nhd8unv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 26 Mar 2024 13:39:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DD4WATvnp+O72sx7CHBQeKN6ilxlQUL7VlFk9blOmGRYNkqnEhmDRpHkSOB5mUUtBC7TvDofKByCeeE1Gfkt1v+RpR4WLrE1XsiBP3djUTToUaukBTtkce/8FI4Ro0PH5xCoUtvRnhmltOpygzKqrM5B4DAr4vyT7Qax26cDW1Ozi9vmkeOtwO2r4sA8O/pQGVbF9oMD/hSBJ7qEdCK8EqSHySmem92KiRBDvkk0shY1BjqkmgDT2hVO6tLbeo6PH32d/IJk+XLY0fiovyW+FmKbyx+D6jYCjTxN77Eemx8Ks20doE0GP0Ff/uAE55cVBGcDMAcZGSbYc/Ay9NO7FA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=04dgZaUgnUSJOVKkaIMbfFyxv3q9iwm7mAseByauNjI=;
 b=St5o+63iNwSobTF1minhiFDoEViqMDgsdGSpXKeSAuCCdqMGSb7sfg90fu2MvgDTAMopo+y/pn3AFkUweD/o6t9p5iL82Tejsb8zS7su/6YB7P9Ic+tKIVG99yKMvmnD6MuLShIGqGD5l9BFhCbPfRtqnE+qxtlBQhzMMMDIiajP6eHWUYLngQo1Kinc/TyXh+1EdK6JgrWAvojKepAEn8fXFUQOASa9x456vD98zfp58uoD65GuGQVzHZC/qPEigjegtRklOwh/MBPniTAvnfVIDtq+wUzHDbkyHwSgWtIz3QnQk/FUE5dMriNt8ZcvAUcFct02fglekkG8rl0SYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=04dgZaUgnUSJOVKkaIMbfFyxv3q9iwm7mAseByauNjI=;
 b=T2XAel6QzXGLnX+ZWE85Hzm1lvokYBHpOqNR0BTQ9FEIzgGpeZBvWdMBju4fbrqLyaoEAiqenqCXnXgUVdRFQfdt9IIlbWVs7/nlnFVSfTUGvEUYDHhq4RTReJP9Gm2iKaWYULjDnZB35/zcbG9VcZIIgt2LhkxW++nC6o1VLCM=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SJ0PR10MB4749.namprd10.prod.outlook.com (2603:10b6:a03:2da::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.31; Tue, 26 Mar
 2024 13:39:21 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ae68:7d51:133f:324]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ae68:7d51:133f:324%4]) with mapi id 15.20.7409.031; Tue, 26 Mar 2024
 13:39:20 +0000
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
        John Garry <john.g.garry@oracle.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>
Subject: [PATCH v6 05/10] block: Add core atomic write support
Date: Tue, 26 Mar 2024 13:38:08 +0000
Message-Id: <20240326133813.3224593-6-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240326133813.3224593-1-john.g.garry@oracle.com>
References: <20240326133813.3224593-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P265CA0112.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2c3::15) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SJ0PR10MB4749:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	U4BBeVnCQsDCj2cbKUoi14PqbJ4+WyBMOnkGTXJdVJlMMqBBGJ/dHYezOV+n9tgn92T+EG/bkREAzGSkzb/JA35/s3Mh4L/QmREVZMNwiiHdY/YlALfcplgZZKqvvJaF84n3B6UbncP9HIV4yL6MLUrdL7Y8hQUVTpkZ6jY/BqLjREXv8OaA6Vz6haMPTK8fWyxJN5nhe6GEKZQtmynvU86YcX7w3FlaG/GUqoBXmqszKqTLpD1RqI6wslIaEIxGCDKqAsJtoM4hrt6jbAVSDpZe/pilQDs0cGxg877yi/TkEA6m1q+KJ+c0q0pB3ohTxnFdVnrsB36RE0o98dqiJxkciiElQOwN7EcaEAKlhk9lqPEfwp2RvMS6FWBuWXiU3QIzvNi09jxEUVGM2NT3GuzIwgee4PxHx0AF+BKHm3krXdNHYRAsLqQDEjW58NpzByA/xx62eijis363XVT8G9eqc1m8/cdGU+JukV+QvR0BFvlXdJiJwlfZp8Ajp1aHOTfcBHtl/yQAQ9LufIVOnJ9fSl29oGRAUmI3EffLZd7Ug2uPDjtMIRc6q//MT3cbE1J53lmlcED3rG6bgsI0z90Trt2nnmsAAQWwBHHO+coqYoTxCl4ahnz5xewlpE574KsolIfqRGLMWDB05wZCMeVM4LQL4e5BXDfqbZNgsIYWTV4RgBJTwgj2C72HUPLGPxpbKPKG8vKCZ9twtaThcQ==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(7416005)(1800799015)(921011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?EEliE7LDv8vNgE+kIU7iaTRhy4PK46eK+7apHWLrUeVEeoqkB96/M8fKY83Q?=
 =?us-ascii?Q?emLlZRCNL3HcsKyPpwX1biT1QDyLEFzy+jLDsBhucnneQYe8JRyRDZS99Yj/?=
 =?us-ascii?Q?bps187JVB6zCmVPGy22uhYV6gdzFDpeH9ROIV+mKNwGSRp2Ff4SyUSQDzU8C?=
 =?us-ascii?Q?9HqwGGC+f3VDVa+SrItwz3a8SpkGyzHZ9WUXEA4XdIaDn9LfVszwjWy5pFjj?=
 =?us-ascii?Q?O0G1ruLvwY+4ZNPJEbJW42uEfhvqDZ9oKkpMUnKUwmxkUuKheXrFNJDHhAAj?=
 =?us-ascii?Q?73gIMD0vSVmcFNCcYyvC10vVj39lIu/mxt86vTzFZEZQmIu6B/a+t/Mq5B9d?=
 =?us-ascii?Q?lUf2KGJJnX4YXwcm55E++rps22ZYgfc2Ztwg1zkqVS4iwvallv2S6rJeyZ9X?=
 =?us-ascii?Q?lueq3Ls3PfZSK6kLOKYY9Xk5TPXelVKhQ6yXFWyTYmVKAhMl1Z8NRHuckDMR?=
 =?us-ascii?Q?ftRl32FVkLsas+2YYgLkdS74fjkI0VuWZT0XEs5nZkS57FK0ouD5IezxXVwg?=
 =?us-ascii?Q?K4TR9zghAZcNNB5BzlTzXGuCvhAwmfQK1tBrhq1gBhjhNUTpB9oU7iq4rnb2?=
 =?us-ascii?Q?cFYpiU0hhnavAv7030oOLFkz06EF3EbW10uCxvl/B4FmlVuLEMdP0fShSPnD?=
 =?us-ascii?Q?jIcnODgdOOw/OU7KFC9j+eIe15Jh29pC3io26HTfLCa+JojXWrDE/8aUWmb7?=
 =?us-ascii?Q?OnxPSkdHDHEclir33q7GkvK+s4pMdnWfBoYd9N5pvqEWPH6DS8pDa9zHe/VD?=
 =?us-ascii?Q?xi/wBhPU0nuWEZeUv6tmo02gao+DQFQVhnNPLRQ4kEfmQj9CENMwhgF8A6TV?=
 =?us-ascii?Q?K1M9RZ9rh/6JBz4CUcWGhDjqWZ6LmN93bB5HXGygBVB58CEFURWrTHL7Pyun?=
 =?us-ascii?Q?I7OKmXBEpR/b5OUcdi7ccUtlz5dFatWuhSKy4z9TbveSb843SVyuwPqkuEy0?=
 =?us-ascii?Q?ZojmFQgY085NZxn/V+smDgu7rISWoqdKltH7ArxibzNpsnRzYNbQtw84+lVc?=
 =?us-ascii?Q?enctsQmSugGEvLR4z5q27tIrEAQo4baWgTFjnB3ntRorNCbDcQ3esqdOmd0t?=
 =?us-ascii?Q?NXGINZDQOYmA1/2jdy1Y8xSEjits/qi4HfexOjUv6GiiZcpcjg7KjzK4WhIa?=
 =?us-ascii?Q?iXeG9z2BE1BnSz9ZIoutJ9mw3nGaZsmHFcgnS+xLBEGinwju8Vqn7EyxN7Ym?=
 =?us-ascii?Q?DjMisK3OXN9WWW6m4uNIpP+l5XxCL8a31RGJ1Yqkl3Gse34mo5fRexb5hqO9?=
 =?us-ascii?Q?rRM/Ujkj9Mb3a0rQODPwhpYPVGistJE8h3MsVvYsS0LPAcrtNJw6qvJ3TlQE?=
 =?us-ascii?Q?ZezKCAIghRW5Diet181PPmspStWPTl0B68E73PGV74LVMZk1PuGooblPRx6c?=
 =?us-ascii?Q?1ZboDHNbmDUWD/3KuQ0ij5bRN0ypS+8Cr2pGYB99ccxdhHa/6LLG3KIavrpv?=
 =?us-ascii?Q?ztxng0WC23ZLITVDhSdmFjP49BmjJ4JOAYBveKLKgNKiOg+Dywfu1jcZP/C5?=
 =?us-ascii?Q?0UD7R8xaYLAbHaGNcegp3ehqddS7nrLjN4Tnl7yjqAnepd1odxix4e9ORDnU?=
 =?us-ascii?Q?2oy+lmoK0x9ZRR85NbmWkQYmu4IsSnT2UZewyIxCY/gEUbw2djE6kQ9AlQWc?=
 =?us-ascii?Q?lA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	yC9O0HgYFLXSpVN4U5p3aIM0Qe39mgoJoydGxtKSm5/HtRmh+zDdc/xFTQcxVUGGuOGqlmXwwjwx54u8Q/DF8i+LyttgNj9SrszvT87jZOjurihV33fafRZ7JVYHnurt6fHGyUFd1AHw2g0c9sLDyhI8Z1PY7dGaedkdTfDkSc+FlJPXQy6R4Aemk3aMhojjokRA4E6mv+zhzsVNpM9+BcVZjabAFsrtdHo8kOCN6w3lRwjyNyTzghK5GQuH55P+EIQCN+TghJvNGN+prPB7L/cBKwNZx25dJpCVTPeUu1t6RA/V5H/C4f1PicZaBcyFbfwwCZmSvx0BKE6DPdQQfQbQT+OZwrBYOSiPouZbSCOjzYv3SDsVgEIOCmEbnsqxqzxguL21ZMuHeaWjbB2VhSy3fCp2ESZfbm2miliu5hrYd2Y5AXfrWGTesR9CeVtoiIL/B4ErWMpAbZA60AgFUqYWzUdjfZZmNdEv+FSRT8JPQvsiynT94YE7zbmMYvJ+6tN3zmJOxZXG4pp6gfh8OzLfW8nahSoB4n61in7vY8buxQdk9tpM/DJC+XXv07avPSjnyIlitkJpKrLiVvHLhaOoKnpvqI36dtFxtu2GGAI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 17853eef-187c-40e5-30a5-08dc4d9a2400
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2024 13:39:20.6986
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CFbNpRQjxYOjXCrYgbfrjUJ+ci/w8NUvAS34N0DcZD2Y7hjWiZOY8nCnM2JeV1Nm4c6jstcf3xeOnfywHIDWDg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4749
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-26_06,2024-03-21_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 adultscore=0 mlxscore=0 phishscore=0 malwarescore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2403210000 definitions=main-2403260095
X-Proofpoint-GUID: cuTgvIPuBNfij5IGwlOsdi_auJtZl2YE
X-Proofpoint-ORIG-GUID: cuTgvIPuBNfij5IGwlOsdi_auJtZl2YE

Add atomic write support, as follows:
- add helper functions to get request_queue atomic write limits
- report request_queue atomic write support limits to sysfs and update Doc
- support to safely merge atomic writes
- deal with splitting atomic writes
- misc helper functions
- add a per-request atomic write flag

New request_queue limits are added, as follows:
- atomic_write_hw_max is set by the block driver and is the maximum length
  of an atomic write which the device may support. It is not
  necessarily a power-of-2.
- atomic_write_max_sectors is derived from atomic_write_hw_max_sectors and
  max_hw_sectors. It is always a power-of-2. Atomic writes may be merged,
  and atomic_write_max_sectors would be the limit on a merged atomic write
  request size. This value is not capped at max_sectors, as the value in
  max_sectors can be controlled from userspace, and it would only cause
  trouble if userspace could limit atomic_write_unit_max_bytes and the
  other atomic write limits.
- atomic_write_hw_unit_{min,max} are set by the block driver and are the
  min/max length of an atomic write unit which the device may support. They
  both must be a power-of-2. Typically atomic_write_hw_unit_max will hold
  the same value as atomic_write_hw_max.
- atomic_write_unit_{min,max} are derived from
  atomic_write_hw_unit_{min,max}, max_hw_sectors, and block core limits.
  Both min and max values must be a power-of-2.
- atomic_write_hw_boundary is set by the block driver. If non-zero, it
  indicates an LBA space boundary at which an atomic write straddles no
  longer is atomically executed by the disk. The value must be a
  power-of-2. Note that it would be acceptable to enforce a rule that
  atomic_write_hw_boundary_sectors is a multiple of
  atomic_write_hw_unit_max, but the resultant code would be more
  complicated.

All atomic writes limits are by default set 0 to indicate no atomic write
support. Even though it is assumed by Linux that a logical block can always
be atomically written, we ignore this as it is not of particular interest.
Stacked devices are just not supported either for now.

An atomic write must always be submitted to the block driver as part of a
single request. As such, only a single BIO must be submitted to the block
layer for an atomic write. When a single atomic write BIO is submitted, it
cannot be split. As such, atomic_write_unit_{max, min}_bytes are limited
by the maximum guaranteed BIO size which will not be required to be split.
This max size is calculated by request_queue max segments and the number
of bvecs a BIO can fit, BIO_MAX_VECS. Currently we rely on userspace
issuing a write with iovcnt=1 for pwritev2() - as such, we can rely on each
segment containing PAGE_SIZE of data, apart from the first+last, which each
can fit logical block size of data. The first+last will be LBS
length/aligned as we rely on direct IO alignment rules also.

New sysfs files are added to report the following atomic write limits:
- atomic_write_unit_max_bytes - same as atomic_write_unit_max_sectors in
				bytes
- atomic_write_unit_min_bytes - same as atomic_write_unit_min_sectors in
				bytes
- atomic_write_boundary_bytes - same as atomic_write_hw_boundary_sectors in
				bytes
- atomic_write_max_bytes      - same as atomic_write_max_sectors in bytes

Atomic writes may only be merged with other atomic writes and only under
the following conditions:
- total resultant request length <= atomic_write_max_bytes
- the merged write does not straddle a boundary

Helper function bdev_can_atomic_write() is added to indicate whether
atomic writes may be issued to a bdev. If a bdev is a partition, the
partition start must be aligned with both atomic_write_unit_min_sectors
and atomic_write_hw_boundary_sectors.

FSes will rely on the block layer to validate that an atomic write BIO
submitted will be of valid size, so add blk_validate_atomic_write_op_size()
for this purpose. Userspace expects an atomic write which is of invalid
size to be rejected with -EINVAL, so add BLK_STS_INVAL for this. Also use
BLK_STS_INVAL for when a BIO needs to be split, as this should mean an
invalid size BIO.

Flag REQ_ATOMIC is used for indicating an atomic write.

Co-developed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 Documentation/ABI/stable/sysfs-block |  52 +++++++++++++
 block/blk-core.c                     |  19 +++++
 block/blk-merge.c                    |  95 ++++++++++++++++++++++-
 block/blk-settings.c                 | 109 +++++++++++++++++++++++++++
 block/blk-sysfs.c                    |  33 ++++++++
 block/blk.h                          |   3 +
 include/linux/blk_types.h            |   8 +-
 include/linux/blkdev.h               |  61 +++++++++++++++
 8 files changed, 378 insertions(+), 2 deletions(-)

diff --git a/Documentation/ABI/stable/sysfs-block b/Documentation/ABI/stable/sysfs-block
index 1fe9a553c37b..4c775f4bdefe 100644
--- a/Documentation/ABI/stable/sysfs-block
+++ b/Documentation/ABI/stable/sysfs-block
@@ -21,6 +21,58 @@ Description:
 		device is offset from the internal allocation unit's
 		natural alignment.
 
+What:		/sys/block/<disk>/atomic_write_max_bytes
+Date:		February 2024
+Contact:	Himanshu Madhani <himanshu.madhani@oracle.com>
+Description:
+		[RO] This parameter specifies the maximum atomic write
+		size reported by the device. This parameter is relevant
+		for merging of writes, where a merged atomic write
+		operation must not exceed this number of bytes.
+		This parameter may be greater to the value in
+		atomic_write_unit_max_bytes as
+		atomic_write_unit_max_bytes will be rounded down to a
+		power-of-two and atomic_write_unit_max_bytes may also be
+		limited by some other queue limits, such as max_segments.
+		This parameter - along with atomic_write_unit_min_bytes
+		and atomic_write_unit_max_bytes - will not be larger than
+		max_hw_sectors_kb, but may be larger than max_sectors_kb.
+
+
+What:		/sys/block/<disk>/atomic_write_unit_min_bytes
+Date:		February 2024
+Contact:	Himanshu Madhani <himanshu.madhani@oracle.com>
+Description:
+		[RO] This parameter specifies the smallest block which can
+		be written atomically with an atomic write operation. All
+		atomic write operations must begin at a
+		atomic_write_unit_min boundary and must be multiples of
+		atomic_write_unit_min. This value must be a power-of-two.
+
+
+What:		/sys/block/<disk>/atomic_write_unit_max_bytes
+Date:		February 2024
+Contact:	Himanshu Madhani <himanshu.madhani@oracle.com>
+Description:
+		[RO] This parameter defines the largest block which can be
+		written atomically with an atomic write operation. This
+		value must be a multiple of atomic_write_unit_min and must
+		be a power-of-two. This value will not be larger than
+		atomic_write_max_bytes.
+
+
+What:		/sys/block/<disk>/atomic_write_boundary_bytes
+Date:		February 2024
+Contact:	Himanshu Madhani <himanshu.madhani@oracle.com>
+Description:
+		[RO] A device may need to internally split I/Os which
+		straddle a given logical block address boundary. In that
+		case a single atomic write operation will be processed as
+		one of more sub-operations which each complete atomically.
+		This parameter specifies the size in bytes of the atomic
+		boundary if one is reported by the device. This value must
+		be a power-of-two.
+
 
 What:		/sys/block/<disk>/diskseq
 Date:		February 2021
diff --git a/block/blk-core.c b/block/blk-core.c
index a16b5abdbbf5..de868c91a295 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -174,6 +174,8 @@ static const struct {
 	/* Command duration limit device-side timeout */
 	[BLK_STS_DURATION_LIMIT]	= { -ETIME, "duration limit exceeded" },
 
+	[BLK_STS_INVAL]		= { -EINVAL,	"invalid" },
+
 	/* everything else not covered above: */
 	[BLK_STS_IOERR]		= { -EIO,	"I/O" },
 };
@@ -729,6 +731,18 @@ void submit_bio_noacct_nocheck(struct bio *bio)
 		__submit_bio_noacct(bio);
 }
 
+static blk_status_t blk_validate_atomic_write_op_size(struct request_queue *q,
+						 struct bio *bio)
+{
+	if (bio->bi_iter.bi_size > queue_atomic_write_unit_max_bytes(q))
+		return BLK_STS_INVAL;
+
+	if (bio->bi_iter.bi_size % queue_atomic_write_unit_min_bytes(q))
+		return BLK_STS_INVAL;
+
+	return BLK_STS_OK;
+}
+
 /**
  * submit_bio_noacct - re-submit a bio to the block device layer for I/O
  * @bio:  The bio describing the location in memory and on the device.
@@ -786,6 +800,11 @@ void submit_bio_noacct(struct bio *bio)
 	switch (bio_op(bio)) {
 	case REQ_OP_READ:
 	case REQ_OP_WRITE:
+		if (bio->bi_opf & REQ_ATOMIC) {
+			status = blk_validate_atomic_write_op_size(q, bio);
+			if (status != BLK_STS_OK)
+				goto end_io;
+		}
 		break;
 	case REQ_OP_FLUSH:
 		/*
diff --git a/block/blk-merge.c b/block/blk-merge.c
index 6f9d9ca7922b..34a68e131168 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -18,6 +18,46 @@
 #include "blk-rq-qos.h"
 #include "blk-throttle.h"
 
+/*
+ * rq_straddles_atomic_write_boundary - check for boundary violation
+ * @rq: request to check
+ * @front: data size to be appended to front
+ * @back: data size to be appended to back
+ *
+ * Determine whether merging a request or bio into another request will result
+ * in a merged request which straddles an atomic write boundary.
+ *
+ * The value @front_adjust is the data which would be appended to the front of
+ * @rq, while the value @back_adjust is the data which would be appended to the
+ * back of @rq. Callers will typically only have either @front_adjust or
+ * @back_adjust as non-zero.
+ *
+ */
+static bool rq_straddles_atomic_write_boundary(struct request *rq,
+					unsigned int front_adjust,
+					unsigned int back_adjust)
+{
+	unsigned int boundary = queue_atomic_write_boundary_bytes(rq->q);
+	u64 mask, start_rq_pos, end_rq_pos;
+
+	if (!boundary)
+		return false;
+
+	start_rq_pos = blk_rq_pos(rq) << SECTOR_SHIFT;
+	end_rq_pos = start_rq_pos + blk_rq_bytes(rq) - 1;
+
+	start_rq_pos -= front_adjust;
+	end_rq_pos += back_adjust;
+
+	mask = ~(boundary - 1);
+
+	/* Top bits are different, so crossed a boundary */
+	if ((start_rq_pos & mask) != (end_rq_pos & mask))
+		return true;
+
+	return false;
+}
+
 static inline void bio_get_first_bvec(struct bio *bio, struct bio_vec *bv)
 {
 	*bv = mp_bvec_iter_bvec(bio->bi_io_vec, bio->bi_iter);
@@ -167,7 +207,16 @@ static inline unsigned get_max_io_size(struct bio *bio,
 {
 	unsigned pbs = lim->physical_block_size >> SECTOR_SHIFT;
 	unsigned lbs = lim->logical_block_size >> SECTOR_SHIFT;
-	unsigned max_sectors = lim->max_sectors, start, end;
+	unsigned max_sectors, start, end;
+
+	/*
+	 * We ignore lim->max_sectors for atomic writes simply because
+	 * it may less than the bio size, which we cannot tolerate.
+	 */
+	if (bio->bi_opf & REQ_ATOMIC)
+		max_sectors = lim->atomic_write_max_sectors;
+	else
+		max_sectors = lim->max_sectors;
 
 	if (lim->chunk_sectors) {
 		max_sectors = min(max_sectors,
@@ -305,6 +354,11 @@ struct bio *bio_split_rw(struct bio *bio, const struct queue_limits *lim,
 	*segs = nsegs;
 	return NULL;
 split:
+	if (bio->bi_opf & REQ_ATOMIC) {
+		bio->bi_status = BLK_STS_INVAL;
+		bio_endio(bio);
+		return ERR_PTR(-EINVAL);
+	}
 	/*
 	 * We can't sanely support splitting for a REQ_NOWAIT bio. End it
 	 * with EAGAIN if splitting is required and return an error pointer.
@@ -645,6 +699,13 @@ int ll_back_merge_fn(struct request *req, struct bio *bio, unsigned int nr_segs)
 		return 0;
 	}
 
+	if (req->cmd_flags & REQ_ATOMIC) {
+		if (rq_straddles_atomic_write_boundary(req,
+				0, bio->bi_iter.bi_size)) {
+			return 0;
+		}
+	}
+
 	return ll_new_hw_segment(req, bio, nr_segs);
 }
 
@@ -664,6 +725,13 @@ static int ll_front_merge_fn(struct request *req, struct bio *bio,
 		return 0;
 	}
 
+	if (req->cmd_flags & REQ_ATOMIC) {
+		if (rq_straddles_atomic_write_boundary(req,
+				bio->bi_iter.bi_size, 0)) {
+			return 0;
+		}
+	}
+
 	return ll_new_hw_segment(req, bio, nr_segs);
 }
 
@@ -700,6 +768,13 @@ static int ll_merge_requests_fn(struct request_queue *q, struct request *req,
 	    blk_rq_get_max_sectors(req, blk_rq_pos(req)))
 		return 0;
 
+	if (req->cmd_flags & REQ_ATOMIC) {
+		if (rq_straddles_atomic_write_boundary(req,
+				0, blk_rq_bytes(next))) {
+			return 0;
+		}
+	}
+
 	total_phys_segments = req->nr_phys_segments + next->nr_phys_segments;
 	if (total_phys_segments > blk_rq_get_max_segments(req))
 		return 0;
@@ -795,6 +870,18 @@ static enum elv_merge blk_try_req_merge(struct request *req,
 	return ELEVATOR_NO_MERGE;
 }
 
+static bool blk_atomic_write_mergeable_rq_bio(struct request *rq,
+					      struct bio *bio)
+{
+	return (rq->cmd_flags & REQ_ATOMIC) == (bio->bi_opf & REQ_ATOMIC);
+}
+
+static bool blk_atomic_write_mergeable_rqs(struct request *rq,
+					   struct request *next)
+{
+	return (rq->cmd_flags & REQ_ATOMIC) == (next->cmd_flags & REQ_ATOMIC);
+}
+
 /*
  * For non-mq, this has to be called with the request spinlock acquired.
  * For mq with scheduling, the appropriate queue wide lock should be held.
@@ -818,6 +905,9 @@ static struct request *attempt_merge(struct request_queue *q,
 	if (req->ioprio != next->ioprio)
 		return NULL;
 
+	if (!blk_atomic_write_mergeable_rqs(req, next))
+		return NULL;
+
 	/*
 	 * If we are allowed to merge, then append bio list
 	 * from next to rq and release next. merge_requests_fn
@@ -949,6 +1039,9 @@ bool blk_rq_merge_ok(struct request *rq, struct bio *bio)
 	if (rq->ioprio != bio_prio(bio))
 		return false;
 
+	if (blk_atomic_write_mergeable_rq_bio(rq, bio) == false)
+		return false;
+
 	return true;
 }
 
diff --git a/block/blk-settings.c b/block/blk-settings.c
index 3c7d8d638ab5..98d6c2f59ccf 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -97,6 +97,41 @@ static int blk_validate_zoned_limits(struct queue_limits *lim)
 	return 0;
 }
 
+/*
+ * Returns max guaranteed bytes which we can fit in a bio.
+ *
+ * We always assume that we can fit in at least PAGE_SIZE in a segment, apart
+ * from first and last segments.
+ */
+static
+unsigned int blk_queue_max_guaranteed_bio(struct queue_limits *limits)
+{
+	unsigned int max_segments = min(BIO_MAX_VECS, limits->max_segments);
+	unsigned int length;
+
+	length = min(max_segments, 2) * limits->logical_block_size;
+	if (max_segments > 2)
+		length += (max_segments - 2) * PAGE_SIZE;
+
+	return length;
+}
+
+static void blk_atomic_writes_update_limits(struct queue_limits *limits)
+{
+	unsigned int unit_limit = min(limits->max_hw_sectors << SECTOR_SHIFT,
+					blk_queue_max_guaranteed_bio(limits));
+
+	unit_limit = rounddown_pow_of_two(unit_limit);
+
+	limits->atomic_write_max_sectors =
+		min(limits->atomic_write_hw_max >> SECTOR_SHIFT,
+			limits->max_hw_sectors);
+	limits->atomic_write_unit_min =
+		min(limits->atomic_write_hw_unit_min, unit_limit);
+	limits->atomic_write_unit_max =
+		min(limits->atomic_write_hw_unit_max, unit_limit);
+}
+
 /*
  * Check that the limits in lim are valid, initialize defaults for unset
  * values, and cap values based on others where needed.
@@ -221,6 +256,23 @@ static int blk_validate_limits(struct queue_limits *lim)
 		lim->misaligned = 0;
 	}
 
+	/*
+	 * The atomic write boundary size just needs to be a multiple of
+	 * unit_max (and not necessarily a power-of-2), so this following check
+	 * could be relaxed in future.
+	 * Furthermore, if needed, unit_max could be reduced so that the
+	 * boundary size was compliant (with a !power-of-2 boundary).
+	 */
+	if (lim->atomic_write_hw_boundary &&
+	    !is_power_of_2(lim->atomic_write_hw_boundary)) {
+
+		lim->atomic_write_hw_max = 0;
+		lim->atomic_write_hw_boundary = 0;
+		lim->atomic_write_hw_unit_min = 0;
+		lim->atomic_write_hw_unit_max = 0;
+	}
+	blk_atomic_writes_update_limits(lim);
+
 	return blk_validate_zoned_limits(lim);
 }
 
@@ -344,6 +396,8 @@ void blk_queue_max_hw_sectors(struct request_queue *q, unsigned int max_hw_secto
 				 limits->logical_block_size >> SECTOR_SHIFT);
 	limits->max_sectors = max_sectors;
 
+	blk_atomic_writes_update_limits(limits);
+
 	if (!q->disk)
 		return;
 	q->disk->bdi->io_pages = max_sectors >> (PAGE_SHIFT - 9);
@@ -384,6 +438,61 @@ void blk_queue_max_discard_sectors(struct request_queue *q,
 }
 EXPORT_SYMBOL(blk_queue_max_discard_sectors);
 
+/**
+ * blk_queue_atomic_write_max_bytes - set max bytes supported by
+ * the device for atomic write operations.
+ * @q:  the request queue for the device
+ * @bytes: maximum bytes supported
+ */
+void blk_queue_atomic_write_max_bytes(struct request_queue *q,
+				      unsigned int bytes)
+{
+	q->limits.atomic_write_hw_max = bytes;
+	blk_atomic_writes_update_limits(&q->limits);
+}
+EXPORT_SYMBOL(blk_queue_atomic_write_max_bytes);
+
+/**
+ * blk_queue_atomic_write_boundary_bytes - Device's logical block address space
+ * which an atomic write should not cross.
+ * @q:  the request queue for the device
+ * @bytes: must be a power-of-two.
+ */
+void blk_queue_atomic_write_boundary_bytes(struct request_queue *q,
+					   unsigned int bytes)
+{
+	q->limits.atomic_write_hw_boundary = bytes;
+}
+EXPORT_SYMBOL(blk_queue_atomic_write_boundary_bytes);
+
+/**
+ * blk_queue_atomic_write_unit_min_bytes - smallest unit that can be written
+ * atomically to the device.
+ * @q:  the request queue for the device
+ * @bytes: must be a power-of-two.
+ */
+void blk_queue_atomic_write_unit_min_bytes(struct request_queue *q,
+					     unsigned int bytes)
+{
+	q->limits.atomic_write_hw_unit_min = bytes;
+	blk_atomic_writes_update_limits(&q->limits);
+}
+EXPORT_SYMBOL(blk_queue_atomic_write_unit_min_bytes);
+
+/*
+ * blk_queue_atomic_write_unit_max_bytes - largest unit that can be written
+ * atomically to the device.
+ * @q: the request queue for the device
+ * @bytes: must be a power-of-two.
+ */
+void blk_queue_atomic_write_unit_max_bytes(struct request_queue *q,
+					     unsigned int bytes)
+{
+	q->limits.atomic_write_hw_unit_max = bytes;
+	blk_atomic_writes_update_limits(&q->limits);
+}
+EXPORT_SYMBOL(blk_queue_atomic_write_unit_max_bytes);
+
 /**
  * blk_queue_max_secure_erase_sectors - set max sectors for a secure erase
  * @q:  the request queue for the device
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 8c8f69d8ba48..e2ff824ce02f 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -118,6 +118,30 @@ static ssize_t queue_max_discard_segments_show(struct request_queue *q,
 	return queue_var_show(queue_max_discard_segments(q), page);
 }
 
+static ssize_t queue_atomic_write_max_bytes_show(struct request_queue *q,
+						char *page)
+{
+	return queue_var_show(queue_atomic_write_max_bytes(q), page);
+}
+
+static ssize_t queue_atomic_write_boundary_show(struct request_queue *q,
+						char *page)
+{
+	return queue_var_show(queue_atomic_write_boundary_bytes(q), page);
+}
+
+static ssize_t queue_atomic_write_unit_min_show(struct request_queue *q,
+						char *page)
+{
+	return queue_var_show(queue_atomic_write_unit_min_bytes(q), page);
+}
+
+static ssize_t queue_atomic_write_unit_max_show(struct request_queue *q,
+						char *page)
+{
+	return queue_var_show(queue_atomic_write_unit_max_bytes(q), page);
+}
+
 static ssize_t queue_max_integrity_segments_show(struct request_queue *q, char *page)
 {
 	return queue_var_show(q->limits.max_integrity_segments, page);
@@ -495,6 +519,11 @@ QUEUE_RO_ENTRY(queue_discard_max_hw, "discard_max_hw_bytes");
 QUEUE_RW_ENTRY(queue_discard_max, "discard_max_bytes");
 QUEUE_RO_ENTRY(queue_discard_zeroes_data, "discard_zeroes_data");
 
+QUEUE_RO_ENTRY(queue_atomic_write_max_bytes, "atomic_write_max_bytes");
+QUEUE_RO_ENTRY(queue_atomic_write_boundary, "atomic_write_boundary_bytes");
+QUEUE_RO_ENTRY(queue_atomic_write_unit_max, "atomic_write_unit_max_bytes");
+QUEUE_RO_ENTRY(queue_atomic_write_unit_min, "atomic_write_unit_min_bytes");
+
 QUEUE_RO_ENTRY(queue_write_same_max, "write_same_max_bytes");
 QUEUE_RO_ENTRY(queue_write_zeroes_max, "write_zeroes_max_bytes");
 QUEUE_RO_ENTRY(queue_zone_append_max, "zone_append_max_bytes");
@@ -622,6 +651,10 @@ static struct attribute *queue_attrs[] = {
 	&queue_discard_max_entry.attr,
 	&queue_discard_max_hw_entry.attr,
 	&queue_discard_zeroes_data_entry.attr,
+	&queue_atomic_write_max_bytes_entry.attr,
+	&queue_atomic_write_boundary_entry.attr,
+	&queue_atomic_write_unit_min_entry.attr,
+	&queue_atomic_write_unit_max_entry.attr,
 	&queue_write_same_max_entry.attr,
 	&queue_write_zeroes_max_entry.attr,
 	&queue_zone_append_max_entry.attr,
diff --git a/block/blk.h b/block/blk.h
index dc2fa6f88adc..5e49c14525df 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -192,6 +192,9 @@ static inline unsigned int blk_queue_get_max_sectors(struct request *rq)
 	if (unlikely(op == REQ_OP_WRITE_ZEROES))
 		return q->limits.max_write_zeroes_sectors;
 
+	if (rq->cmd_flags & REQ_ATOMIC)
+		return q->limits.atomic_write_max_sectors;
+
 	return q->limits.max_sectors;
 }
 
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index cb1526ec44b5..b7d35ead4d1b 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -179,6 +179,11 @@ typedef u16 blk_short_t;
  */
 #define BLK_STS_DURATION_LIMIT	((__force blk_status_t)18)
 
+/*
+ * Invalid size or alignment.
+ */
+#define BLK_STS_INVAL	((__force blk_status_t)19)
+
 /**
  * blk_path_error - returns true if error may be path related
  * @error: status the request was completed with
@@ -381,7 +386,7 @@ enum req_flag_bits {
 	__REQ_SWAP,		/* swap I/O */
 	__REQ_DRV,		/* for driver use */
 	__REQ_FS_PRIVATE,	/* for file system (submitter) use */
-
+	__REQ_ATOMIC,		/* for atomic write operations */
 	/*
 	 * Command specific flags, keep last:
 	 */
@@ -413,6 +418,7 @@ enum req_flag_bits {
 #define REQ_SWAP	(__force blk_opf_t)(1ULL << __REQ_SWAP)
 #define REQ_DRV		(__force blk_opf_t)(1ULL << __REQ_DRV)
 #define REQ_FS_PRIVATE	(__force blk_opf_t)(1ULL << __REQ_FS_PRIVATE)
+#define REQ_ATOMIC	(__force blk_opf_t)(1ULL << __REQ_ATOMIC)
 
 #define REQ_NOUNMAP	(__force blk_opf_t)(1ULL << __REQ_NOUNMAP)
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index c3e8f7cf96be..07145b0acbc8 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -300,6 +300,15 @@ struct queue_limits {
 	unsigned int		discard_alignment;
 	unsigned int		zone_write_granularity;
 
+	/* atomic write limits */
+	unsigned int		atomic_write_hw_max;
+	unsigned int		atomic_write_max_sectors;
+	unsigned int		atomic_write_hw_boundary;
+	unsigned int		atomic_write_hw_unit_min;
+	unsigned int		atomic_write_unit_min;
+	unsigned int		atomic_write_hw_unit_max;
+	unsigned int		atomic_write_unit_max;
+
 	unsigned short		max_segments;
 	unsigned short		max_integrity_segments;
 	unsigned short		max_discard_segments;
@@ -916,6 +925,14 @@ void blk_queue_zone_write_granularity(struct request_queue *q,
 				      unsigned int size);
 extern void blk_queue_alignment_offset(struct request_queue *q,
 				       unsigned int alignment);
+void blk_queue_atomic_write_max_bytes(struct request_queue *q,
+				unsigned int bytes);
+void blk_queue_atomic_write_boundary_bytes(struct request_queue *q,
+				unsigned int bytes);
+void blk_queue_atomic_write_unit_max_bytes(struct request_queue *q,
+				unsigned int bytes);
+void blk_queue_atomic_write_unit_min_bytes(struct request_queue *q,
+				unsigned int bytes);
 void disk_update_readahead(struct gendisk *disk);
 extern void blk_limits_io_min(struct queue_limits *limits, unsigned int min);
 extern void blk_queue_io_min(struct request_queue *q, unsigned int min);
@@ -1339,6 +1356,30 @@ static inline int queue_dma_alignment(const struct request_queue *q)
 	return q ? q->limits.dma_alignment : 511;
 }
 
+static inline unsigned int
+queue_atomic_write_unit_max_bytes(const struct request_queue *q)
+{
+	return q->limits.atomic_write_unit_max;
+}
+
+static inline unsigned int
+queue_atomic_write_unit_min_bytes(const struct request_queue *q)
+{
+	return q->limits.atomic_write_unit_min;
+}
+
+static inline unsigned int
+queue_atomic_write_boundary_bytes(const struct request_queue *q)
+{
+	return q->limits.atomic_write_hw_boundary;
+}
+
+static inline unsigned int
+queue_atomic_write_max_bytes(const struct request_queue *q)
+{
+	return q->limits.atomic_write_max_sectors << SECTOR_SHIFT;
+}
+
 static inline unsigned int bdev_dma_alignment(struct block_device *bdev)
 {
 	return queue_dma_alignment(bdev_get_queue(bdev));
@@ -1592,6 +1633,26 @@ struct io_comp_batch {
 	void (*complete)(struct io_comp_batch *);
 };
 
+static inline bool bdev_can_atomic_write(struct block_device *bdev)
+{
+	struct request_queue *bd_queue = bdev->bd_queue;
+	struct queue_limits *limits = &bd_queue->limits;
+
+	if (!limits->atomic_write_unit_min)
+		return false;
+
+	if (bdev_is_partition(bdev)) {
+		sector_t bd_start_sect = bdev->bd_start_sect;
+		unsigned int alignment =
+			max(limits->atomic_write_unit_min,
+			    limits->atomic_write_hw_boundary);
+		if (!IS_ALIGNED(bd_start_sect, alignment))
+			return false;
+	}
+
+	return true;
+}
+
 #define DEFINE_IO_COMP_BATCH(name)	struct io_comp_batch name = { }
 
 #endif /* _LINUX_BLKDEV_H */
-- 
2.31.1


