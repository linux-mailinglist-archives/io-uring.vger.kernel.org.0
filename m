Return-Path: <io-uring+bounces-629-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D5AD85A423
	for <lists+io-uring@lfdr.de>; Mon, 19 Feb 2024 14:04:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 77D631F21D15
	for <lists+io-uring@lfdr.de>; Mon, 19 Feb 2024 13:04:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D45EF36120;
	Mon, 19 Feb 2024 13:02:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YGriQ1eo";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="mQVbaLMu"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ED53383A9;
	Mon, 19 Feb 2024 13:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708347767; cv=fail; b=ped6sriddZOW3sK7VeYZai7b4bxXRhgCy5LDypO1Qz7apR/RnBEB80WSg3fX8xlq78LKdUxbBY8pBfL1WhYkgHZyvuWm+Oq5Xy/8uca0T/7bPPl/kaLGb95kc7T00qKs3H4+BFWBQon/T3Sj/ZDOAev8CzIZxaOlp5tNThHIeYA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708347767; c=relaxed/simple;
	bh=Wkc5MMHB1HAX2/RReeUT/+KLFXtSiPJ5p7+YQroxj1Y=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ZwdpGCXK43qb9A8ZjEKkKcKlOs+6elRs2mTWPZ4KQE2rqFJMRCy4Jc7DOJm1HHlRTrxU/P885FkRWEetTi/AToLMNvxR3jvsA23j1uBsXbHPtK8jVqEG5ApxxFiyOQhxFOu5uuRgJZGNWYMClj+C0/Km0VqTHtsNDINFkfovpl0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=YGriQ1eo; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=mQVbaLMu; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 41J8OEx7010905;
	Mon, 19 Feb 2024 13:01:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-11-20; bh=sP1AJlaC0urkwAzGkSHPhMNGvD8pV2TUkpVWholQImY=;
 b=YGriQ1eozKPzAT5Mkn5kVQsZUfJYzJv6iE3NVyt77d3jABEj1Hom2d2qoT/MBxi3m5Rp
 +yAIkxBQjdE1Fy802P9SBYSIWCRS3rFOKcgjnbOfyQXxTv4nwfen52IgnW1fbsUox5k0
 hxJZVVo6kUj1Lk3MdL5f79Byd66nif7IyBwGww+f6QsW0RP7IeHupwrKDvhEqg6mdmvF
 zeW0Y9I5+kkBHP7IRKAFf5ofZ1uo66VbYArj7TxGxhzpWHYpmOS/EIRGQI7hDK1h93Yx
 IbJfGvD+HflY5KrKAxUMvbATyAai1IivJaUXmJwXU4crTQjmnzY6lqexNCgM0j4BrPJE vg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3wak7ec4gt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 19 Feb 2024 13:01:38 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 41JCP5Mc039639;
	Mon, 19 Feb 2024 13:01:37 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3wak85w570-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 19 Feb 2024 13:01:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EPyc6xb+3H+sAjxkvoqDmWh6UlaGusyEd6aF/dzFFQaCLbRIHNRPSCS2uERi9WRHkGoSX6QkAQOb3jkVSSnFkCue9G4Ek/7IBzCDQ8Fv3+2yeSxvp8z8Ke7FEK7q1oY7gapgvMafeRtY5rg6HA387bPMRoIShoR1eJB02gvXsE/eXyKGFZENhxtv06r7aoysFf7uwMNni6M/k0EsPY+salBZsSMuG2gaRbQs7YWNAnEShoV+u8e33+E1hNpWUyAgHWQTNcpaow1tszwarwzW2Wze0CPnQGHKxc8KhgdwwafIZQnQkjRWm56Qo1+/XqpfaqxzoGXRb0+asyti9tT/PA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sP1AJlaC0urkwAzGkSHPhMNGvD8pV2TUkpVWholQImY=;
 b=U/GtbnFktwjuI2m/31erBJ5FccEFCHfVWyCQksPxEO6M0AQngDphstrtAGZXkEUbQs776LDerDgm4kuvZug1zR5qVtYXN3n1nKWMp6+sjQNP2+x8VIbGqEJKq6WLa7azB9I01uhcG6z8D1wzencL4yKn/Y4p1rdQxx+0nts5hUyuctbv7Zxm2ctiDNxOTDoVQecMhfQdxmxrNTGAWVwzdwbmd4D7qvAPlPws1qjgYkgffiybDndd39JVn6o1T03pkIRqusmbQcCnW2B7tDBjH6jxE/y2TlDvWZ5vJpaNgOTO5ajALzmsXkzNYvA2p5PB0G71gtapy+TWL6rOHiM0dg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sP1AJlaC0urkwAzGkSHPhMNGvD8pV2TUkpVWholQImY=;
 b=mQVbaLMu23/FkT0DhoCApzQkQZE9KWT+1izPOv3BMzP2bby9x98mImQcKI2UgM2WcifNgeebxn4tGBnnhvi7ww9rXtsL3Yk0enuEF4lCkT9xn/5Zt6usB8OD+1TWhTEcWAu3A79uBmyL5UQ+O0YS38KL1Of3xI3PmA7ZA/0H3qQ=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DS0PR10MB6894.namprd10.prod.outlook.com (2603:10b6:8:134::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.38; Mon, 19 Feb
 2024 13:01:36 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::56f9:2210:db18:61c4]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::56f9:2210:db18:61c4%4]) with mapi id 15.20.7292.036; Mon, 19 Feb 2024
 13:01:36 +0000
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
Subject: [PATCH v4 02/11] block: Call blkdev_dio_unaligned() from blkdev_direct_IO()
Date: Mon, 19 Feb 2024 13:01:00 +0000
Message-Id: <20240219130109.341523-3-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240219130109.341523-1-john.g.garry@oracle.com>
References: <20240219130109.341523-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0084.namprd03.prod.outlook.com
 (2603:10b6:a03:331::29) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DS0PR10MB6894:EE_
X-MS-Office365-Filtering-Correlation-Id: 9d83d116-7507-4dc4-94d2-08dc314ae766
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	fRF5lxhbxRhN1UwBNoeivj/0vEBBFD9av4q6DUq4HDiqoQmrloMgBkJwRFqqkeYppavJd62it95sUnZan7DgsCaLDxdGk6Rh4fM+UgZm0jRMkqVkthI0yYb+pKtPWEyYkwi/pno6MBJ3TbWCtbv3LTUEfOwkPnuQzG6vSNUeFpYK/wPZpBoz0R9iI8J8xci1XgGKF8HAfZaZjiL9nfEsIQKgy6U9Bn753rUKrDi7csndRUiems10W7DfUvYmxg3BN5rRuIZIep4v53t/8t7U0CH8eoypETYu+Q/3EJZ3L1ba7U7fS1Wzc6J8J/kqlVDNJm75Kaw0vtNniv50Li2uNhQIK5wPOKZlhrDK5e2/DkCcuNCkeE6d6L39lCI0Lwh87vXAGxumBYVtKXMXUzbrliBQtMFhGHJ+h/5+kFQOl3otVkpAoopLoe/MNzhyevjDWYvFGKk1nBIEnbSjL0DeaArM0JmC0WPjOQXP2dP5k32p0E8an/sNnOo1LbttTUL777qqWAjgCNOLCxndDXZ4NVs3yen6O78PcQg4X6L6VDbZn62xy6AvVG4YoBaJFTgCPiKpCCwGSwn00fY7S4id72P0HUInchK/sxZ+uAReCSI=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(921011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?7ChN3plqrxb9bWMX6vXqAvqrZGV1fzaIgqoD7iFO2xVomAfA1H2ZbtH+1gDY?=
 =?us-ascii?Q?6cnh33DJXFOfXm2/G8O9dvK5FOD2LcPYrZRZRLgmtAkXMJxMeJpGJmLCV/y3?=
 =?us-ascii?Q?MYVVMn7d6Y9XxFHccAWLZ9h/BHIiJSjC3Kl24TeIo6jxEYEcVxDY1e4YXmQW?=
 =?us-ascii?Q?5ZJI6KH7uJM5PXHa5iP9Ziji/EB0kWU8Se9xNvCUKOzh0uMen+C/sgHchft5?=
 =?us-ascii?Q?vQ8LKTtuk76cpyQFwnV5Xj9Ljldmat+7RKXnM+xgxf9bIPJjqa5LhUfwfypq?=
 =?us-ascii?Q?SMdfwNQueCEN2tWm0klFpepQfiDZ28msYfHDmhQ8U20oC9U7P+KQaqK+K5vv?=
 =?us-ascii?Q?Bg1F29ZYLvjEZvRqnIxCTj1Xuzh/UzuUORdrtGE1PW65QSazaK1y3j6crLyD?=
 =?us-ascii?Q?lEC65sfMKSNKzBSoEoizxZDyArQH3WS5N/Zy3yt9UtAevaWR4h9wwZZhAmtK?=
 =?us-ascii?Q?NnFuZuLEq1pPEqxIg5Y6M7iIcHycs8GlrgTOuNs1wA47Lg/qoYI7uV11W3Bw?=
 =?us-ascii?Q?dR+c4JxECgIjrjuTMVX8ce1DtFUiiIUSyo3Fy4BwR5wm3At8VLQb1hceF/ne?=
 =?us-ascii?Q?Iau2E8NyD5+ETl7Kbjj8z2vaMTNLI4AblS3tKEiYOe2I48fUT9awrz3/AjwW?=
 =?us-ascii?Q?ao6YfpC7PQbu5uDC7k2c+3MBzFv1HLlzNvEiALh25kHdHuLOAzba6Wew1Z6H?=
 =?us-ascii?Q?01a0itRTljBrSXonQXUUZ1vmeMZDOvO8vlP39buC7wVBpqP9kAm824rw++6L?=
 =?us-ascii?Q?PocW2I9uTrvcNWEIsnTMcJsGCuyPZlIGGl3XFuYc+D1zwkRBwUtd1fDTZPHC?=
 =?us-ascii?Q?MhFaWZPBws6epskeyZ90p6M3zkIhOloMkg87vRSIQK/MJMreQPbVGRVMDDGg?=
 =?us-ascii?Q?35F8j4ypCTtrcIncwVvyzMbWGI6f+rlWaf8DGBj5rJgHNmvn+Lww+WbDFe3G?=
 =?us-ascii?Q?ru2Vc+5/vC+EpiMVWjE3BtGo4kktuIjYyt1pYnEwRRZ5kEOpLfocLDkh4Rur?=
 =?us-ascii?Q?H7QWJc5bK6a5wwwQTj5ryEIjeaP+oHbrnZ+53BPkJs1QBagC5HkulQeyAwOg?=
 =?us-ascii?Q?KJ5/Pnq8GzKMujNVQnIVhE9fLI/yVlKmokRBvrY6NzPIomgPuwt/dNQSwtiY?=
 =?us-ascii?Q?WiSdnqS8Mfrf5pWsc28B+VylzOB6C03wnJ2DNhfkltcIEViBkaFLI0Wbp8uu?=
 =?us-ascii?Q?3j9IuXnUWlFn9HdS1FPkwZaHTRR9onSy1wvbTH/liu9P7xoFPtTiXyEcuuid?=
 =?us-ascii?Q?uwr/bfEffKW/1gzFOczRzaH4UZud6vnBTWuDFhZlniojwTWUxqDfYMJhjUJT?=
 =?us-ascii?Q?OaOza2TEvxvWRFpnlXbl09N3LPsYkXwZkOdfzf91GD0rRCfcHzkyIpM+NirA?=
 =?us-ascii?Q?3Ir2SDpqdYffK6tBYtUolFLdX8fxTgUgjcgHiVue6vxCc1c37V+/xmA9xL+4?=
 =?us-ascii?Q?AXtqNmEevFeMwkZovoO9lOycwW5px7n71ZHRuEQrRqCk9s4n/aKEuMV9BGN3?=
 =?us-ascii?Q?GtuD/yo8PVjB4cV0F3ty37Cb25um7prfM46ua6b/A0R2dD5Pr7cxuP9ivmkU?=
 =?us-ascii?Q?VR7P5VIsNuvHPPnb2qq2+4slf4K1EUlgG7hqUtLaRF6NwK2ZtFcBBWJEQC1f?=
 =?us-ascii?Q?LQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	RoEjpJV8yM7P/lSdav4fkHmzSpbRnQx81AsZYyMoxPh79aqatCK2sshkl49y0lXa5qG5ETw5Jd88NCc5rJQl5X5gr7ydtYj1nl9rZspbS3bCte3859+ciLdHfeAuxzaz11Q8R6nB6yXri8gpZ5WpSLJPhFes4LsBJiVtHkOFFeCMxYXQN529oqXA62SmS7S2LNjp7bzMD/CxH+oDUWQJvcUVnaRM3gGgYXF8Mv7SmfuWA4V/0cDObHn3O8G5YH09hHdlTFoSoZGSVZC7ttgr2ov3EkBDJwYRpL1Hc1H/r+lZqQMVQH4f6RjsDZe29zjCS90IOSGawnfYkDCGiUUctaPlz4STQ6k5ozskch8EIrH2eP8juABuoeQRbjQVndPQGwuozzukFioQrXu4o0x01fj7tZ6WNMlAwgQxwLh1G1q4gnWsiBggJtIF6T6X8T7C2DeLUGNpIl4nf2vEP3CNLqJhSAoVXbzkuPUwdFZiyf8zNA/4j/K5ral5qctreaAr9XQK2QHxiZyitOoSN3uE+zVBv/uBAxlsG/z3FKi2mZ8XiL6mSdrLYDosJU5EAV5f4GYGAaimEvCJNDod9PPKf99tWbxKtraWJ7AxaMxvBuQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d83d116-7507-4dc4-94d2-08dc314ae766
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2024 13:01:36.0480
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9pw9nuGcInqkxmxtu0vwaxEwcdOzwSwCCGMVw6mnEabV0X0xi5JEfW51aZmxWqrBylzPsYQVoPaOrWdiLXcAVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6894
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-19_09,2024-02-19_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 suspectscore=0 mlxscore=0 bulkscore=0 spamscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2402190096
X-Proofpoint-GUID: o7h1jLOmm7D_1Y-Px-c6UCE2kVVPIIxJ
X-Proofpoint-ORIG-GUID: o7h1jLOmm7D_1Y-Px-c6UCE2kVVPIIxJ

blkdev_dio_unaligned() is called from __blkdev_direct_IO(),
__blkdev_direct_IO_simple(), and __blkdev_direct_IO_async(), and all these
are only called from blkdev_direct_IO().

Move the blkdev_dio_unaligned() call to the common callsite,
blkdev_direct_IO().

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 block/fops.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/block/fops.c b/block/fops.c
index 0cf8cf72cdfa..28382b4d097a 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -53,9 +53,6 @@ static ssize_t __blkdev_direct_IO_simple(struct kiocb *iocb,
 	struct bio bio;
 	ssize_t ret;
 
-	if (blkdev_dio_unaligned(bdev, pos, iter))
-		return -EINVAL;
-
 	if (nr_pages <= DIO_INLINE_BIO_VECS)
 		vecs = inline_vecs;
 	else {
@@ -171,9 +168,6 @@ static ssize_t __blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter,
 	loff_t pos = iocb->ki_pos;
 	int ret = 0;
 
-	if (blkdev_dio_unaligned(bdev, pos, iter))
-		return -EINVAL;
-
 	if (iocb->ki_flags & IOCB_ALLOC_CACHE)
 		opf |= REQ_ALLOC_CACHE;
 	bio = bio_alloc_bioset(bdev, nr_pages, opf, GFP_KERNEL,
@@ -310,9 +304,6 @@ static ssize_t __blkdev_direct_IO_async(struct kiocb *iocb,
 	loff_t pos = iocb->ki_pos;
 	int ret = 0;
 
-	if (blkdev_dio_unaligned(bdev, pos, iter))
-		return -EINVAL;
-
 	if (iocb->ki_flags & IOCB_ALLOC_CACHE)
 		opf |= REQ_ALLOC_CACHE;
 	bio = bio_alloc_bioset(bdev, nr_pages, opf, GFP_KERNEL,
@@ -365,11 +356,16 @@ static ssize_t __blkdev_direct_IO_async(struct kiocb *iocb,
 
 static ssize_t blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 {
+	struct block_device *bdev = I_BDEV(iocb->ki_filp->f_mapping->host);
+	loff_t pos = iocb->ki_pos;
 	unsigned int nr_pages;
 
 	if (!iov_iter_count(iter))
 		return 0;
 
+	if (blkdev_dio_unaligned(bdev, pos, iter))
+		return -EINVAL;
+
 	nr_pages = bio_iov_vecs_to_alloc(iter, BIO_MAX_VECS + 1);
 	if (likely(nr_pages <= BIO_MAX_VECS)) {
 		if (is_sync_kiocb(iocb))
-- 
2.31.1


