Return-Path: <io-uring+bounces-632-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BA2B85A43B
	for <lists+io-uring@lfdr.de>; Mon, 19 Feb 2024 14:05:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C06A71C215CD
	for <lists+io-uring@lfdr.de>; Mon, 19 Feb 2024 13:05:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5EFE37169;
	Mon, 19 Feb 2024 13:04:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YxOHRfT9";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="r4v+/1FW"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 094DD36123;
	Mon, 19 Feb 2024 13:04:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708347887; cv=fail; b=KyQpQswAuJbzazR2ZzZkAgFK+WYsplDnvYEE+ODGYi+k4BhvyXvGfHhme/vKIhdu/x9RoS8EhxMMikIaK2FD2AQ62xCxkWtiyci1fT7EtOtLBZPs4rQGZ2Byx6bd942X4KZa8QJU8omCGQIYglCV8IjncYfca6iwZ3xEID8nF5k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708347887; c=relaxed/simple;
	bh=ii52h2XLtoHW2s79JbKmifocxi7axDaSgYIG5NSFGMI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=LQ9b82ao5SbC25fz28SH44n0d6uPh87K3ucfrhZeWuQHhtHY1zCyCYhbue62vpEcZKvlCdjdsDXOUYtkuyK+NeyDeT44yDAjthY+Jq5GIr+eXpWVxUh5r+znC3huOPCMwhmnNtXgf6gT2t1GFIJU8Cx8ADkBmbzJfmt3Khmv8+s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=YxOHRfT9; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=r4v+/1FW; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 41J8O8V8020705;
	Mon, 19 Feb 2024 13:01:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-11-20; bh=RbOxBhNKnu1kZNbaDcGcZ9VeZjSzdg+2y1t3TMfiQpY=;
 b=YxOHRfT9fYPgB0NYWurgWCtvVuwvJns6tKJBSVjxColKGfTbW95Q9tcTHf0636qSNhqm
 /oUmgAhhEgqTUQOATe7Sa5b4OPXlwHxSKq5d3vrNTVLEn+tKZ4a+LWRfjGluggjsx1z/
 GB3c1er3SSQK/Bm+cx3AVsa+9IYz0jEmtjTy3BSTeRbUzC6QxOfqsWJunLT1LP9aqHf0
 kJSJKzmPtp78adSP/tV7Cb07RFi/CCK22E89+0x6pSj8kAdKd5OsmRh3bGV+2C96FmMB
 Hs76XqqiJ47wkMUeFZzlzudHHMRTVTKYEZT8n0obRYH1GAtsNxbJmh90Sc5J+lrQvgvV 9Q== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3wakk3v66b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 19 Feb 2024 13:01:43 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 41JCPDva032464;
	Mon, 19 Feb 2024 13:01:43 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3wak85w31w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 19 Feb 2024 13:01:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gbtu48JFyEs8D9a/0RTZ9sNb6L8YXPUF8R9Bn4iKh5RBgzwu7TPnlz9d3T4JITi1/ZBa0w1Jh7qRYiKL2topyVM5IvGu/0oJ5a7az4yEHNC1srlHowZUeLOuOexG9kNPlIL5QY/b2pIOOSmkYprpLuKy9C1MyFLEemKVhgAftBRbb08qQLWoN/KJ7gO+/84oLizWgYvqzmtDJdT1EE4d3hF1QI35xJESj+50mUF28JqakLQGBCdPigqV0GVtkx3WolKjz6UTg5SkyYda3k1+d4/wAub1X62d9I6W3BFF3TRq4rUpy9NzWNovAlnEiCy1nhcy8nVNOciZFlUUuRTm1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RbOxBhNKnu1kZNbaDcGcZ9VeZjSzdg+2y1t3TMfiQpY=;
 b=VirauZqVc4AVEEZMjrpYCyQkSiE+Hv2TjkTWj8j7pHEpGCBY9VHpL5pYHRIg2ULj9wSgp9bdWs3VNzA/HrMV+CbXFffNY5EoIRk/hOpRpN7FpAU6b9SYjdAw/ONRJyfiEIsBuMJT/XNa/8aANRe2JB5n9dWfAUNNO9UH53lgsPdEBVefrMjHPevdiRwJYJEquD3L02ctpGAJ0BAcDbYzqlL62DUgCMk9NOyDc6ty0kL9AHEuJ5kUqniROPUDZh/f6uM1WAXmOArmK0Jy5maedac6MWo4EuKtCqlXSjlbypSezJEzY1wM8cwEP1xu7Vp6Jx2KWKcFFrp02iVnkWi+aA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RbOxBhNKnu1kZNbaDcGcZ9VeZjSzdg+2y1t3TMfiQpY=;
 b=r4v+/1FWHSA6UAZR549yIdPCudwV8zHpyUWL/xZz2cnOK1vvj0rsUst4sdzY/k5gk2S+gM3JYfWQdghDjLkyakqr7TPmEMF+zZfEvMVUuuv1TPiQo0MOeHMhhZ8sdzd4kwa9bUu8eAo+FCVfGhvChg4Gk+hVy54nV5ZJocAbIgU=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DS0PR10MB6894.namprd10.prod.outlook.com (2603:10b6:8:134::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.38; Mon, 19 Feb
 2024 13:01:40 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::56f9:2210:db18:61c4]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::56f9:2210:db18:61c4%4]) with mapi id 15.20.7292.036; Mon, 19 Feb 2024
 13:01:40 +0000
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
        Prasad Singamsetty <prasad.singamsetty@oracle.com>,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v4 04/11] fs: Add initial atomic write support info to statx
Date: Mon, 19 Feb 2024 13:01:02 +0000
Message-Id: <20240219130109.341523-5-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240219130109.341523-1-john.g.garry@oracle.com>
References: <20240219130109.341523-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR06CA0015.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::28) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DS0PR10MB6894:EE_
X-MS-Office365-Filtering-Correlation-Id: 36347baa-c3f0-4623-fd9e-08dc314aea09
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	8p4jeLVaYNY1Q3KRzANy9aIi7eHamCwO1yxCG0fXPYjtSEaOrShUFa/3J5uQ8HO+dc057+actwsC3kBFU7fXm8zhFMzuQXcDoBDoqenpaNPbaGN4tDbR0ti/ZzwEdiUOqpmCWy54g0PO4eBELo4Pjw4yfGNSuT0nGYEN+sosQmRWTuuZFbsEkO7CSHrEmwoh6rX/F1INr7qL+xw9LI/+Vw3kSGkeKH5GOr9/GvPkND27hlD4fRgg4GuBaMrbym55HPzh0gWTUmLewdI7TmawOkgTOB4B64jr8/C1XkDI6MxpnkCtZ+6SB+0zXv9LAtXwoUt7OXsntKz3BehSNzkq9rxURs7pqSwAuZ3vAv4j7q3Oho+I6WwNylqgv+UNjkqMSy0h8Ov2rqlCt1xwJRXpzsp/zAJ1plomh8p87Nycq1rzGXUifTJNtBweIHY2ML1TDTYdLJ9MXMahCP3vlq5YWrRE3TROeTVIvLS4Frz8vuYaI/qpmRiyoBjk9oN5AS83ZGmzKUNFmHswf59vDhPPUuHzeMT7xxKh3L5BddNzlOtYeBmXqB/JSRBnyP0hQkZ3VeyPHG1tCJqXXsm/9io99TUw+7FCJSK/1F+0ecY9Izk=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(921011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?S4zbKl4B3bPlhk5iYW4EL7U1PuYh2mpuDHWpRffi3hN7pCf4tw0/EMe34ZeH?=
 =?us-ascii?Q?+pTknZ6lvyp8RV+c0b3uwmk/7ly+Zw764mUy3kjk9sEGWGiviK/kvxhtRHfw?=
 =?us-ascii?Q?Ul37XfA5dcEmBqLQ3gTc3eLefSrz8zGiHmqEbypbIxv5ZGUotEe6AfqUiPIL?=
 =?us-ascii?Q?CvM/m+yMRCxDnxSDhfCWuBOOxn9FOtTwNnfLW/+Sz7EJIz4Put1xnwGNY9Ym?=
 =?us-ascii?Q?7VTWQuQLAaqJc3AJi5WVx07PPhfhgzZ9sra05dMR69GPcY+pebVW08NZVuQr?=
 =?us-ascii?Q?ZDWQi7dTgA4JewWYj4Knb68waIe+WIsd5gDqEDHqGVWRpGVi4xc9gUAzpMNe?=
 =?us-ascii?Q?tVvxG5CGVo1BFSr6+OMaN4GU9wVjTvGyD7Pj0dbuOk19I/rcVWuFyh4mh+sp?=
 =?us-ascii?Q?pMk4ezpLDdDZvbtT1UCFVKe2pslV2vGaxDkw0aEEWIfAtjMjMxlsI1a4F3Qf?=
 =?us-ascii?Q?WlurqcD3LDkwML4/JZVc/80LkViZ8P732s9bu0qbSBeEQ45WQkUrhqxyswEX?=
 =?us-ascii?Q?uehLb6V9MBpMHGynnhs5UQgkUp4Rj4SQS8kSw0AzmOKKlrG2iuXjS8nW8rfS?=
 =?us-ascii?Q?QsfRw81EksJRv0OUiZ91isgR5VG+hIevK7bjsHAldCtzntfKRgLXIWttBrZd?=
 =?us-ascii?Q?rCPAPgwVijvmc6uK4rJ6KyDpmIjWUEFWCSi3z3gJGs85JAL2SZFewmqKK2xH?=
 =?us-ascii?Q?GXz7+pLvadJCbXY8A7fRyIp8yqmk24xYM+z+qDlNarlpk3JyZeN9zaUrVRDU?=
 =?us-ascii?Q?0Hsr5bw9JzCBvG4GS6ae6jqqvEJwWk29399CtDt4bV8A//8RbUPYxHW16HLb?=
 =?us-ascii?Q?XH7VUwo2pxHy5wPd9mCstNqDG1sVuINC+EG9TQxGoRhvWWC2ay3QZEylTF3w?=
 =?us-ascii?Q?uHKEOKzKMX3Pj1uOBDa4SQiYm6WO4jxy/2OKFagosFXVjdYeotKjuggTyGSR?=
 =?us-ascii?Q?iImG1LidI34aYKFhocE2VM/+19MLCJpTPRZV3hJ8e9aHRAb8IHvSLqdt0UzN?=
 =?us-ascii?Q?ohnUgNcYxbPxq+PzkC//ZUWVeLvn08c8zd1GA3ctiv+TJ7jgl2jnxJKJMoT1?=
 =?us-ascii?Q?NYL47x6m9pwLQFnYC2vKDMx7wA5RjscsgD8uGa5g4Y/w791JqNn5faYjJG98?=
 =?us-ascii?Q?c/j1UpfXGO8SuyoLua6Fl0jTTqKehcY9s9kAYMWzCXMeKm1VwCv5cEm9TWla?=
 =?us-ascii?Q?T939gQAWrbaBHAtVItOaekEoay56PwmD/0pi6YB7LUA965+eLcphQijigM17?=
 =?us-ascii?Q?a0JZeOQhuDTY5RE4YB5AEl9y5CZf254fSyiWm65S61F4YhI4LGw/pn6N7Pbv?=
 =?us-ascii?Q?/xnUImJRaP7KoVRWxelkcOfn3f4LoHJO/GCXxGrMAX0u/vbcNgxJ4OUpvY+B?=
 =?us-ascii?Q?ZB9QzLOdB9kHqgt8UyDX+bgNeVXdo+7UyLSUIusKvnfKY9IFMExcR1nPVpxM?=
 =?us-ascii?Q?Pt/qtUg7+RIv0CPLduFM428byG0gJ7o/wbz9/Ky2E5Ube9X0zp5i6gHUbgrA?=
 =?us-ascii?Q?mJMpRlNXc92GK+dTJPg+qNeBf7A6PNRDaR/ZmwHR6xr2W55mYYKupX2bRlml?=
 =?us-ascii?Q?JSE5+ChbXYtm/V6Pgm+CvteghGqeMtBlacgE6AxtRsJIvQczEqk574qrmu74?=
 =?us-ascii?Q?eQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	e/X15lLPFXHjaxQEHwSDzvC6CF/G4NkhariSc8O8hwea2BFYsMY0nnefKCp/cBo4HwSwNlgfMu9Kr3+7FL8PLrssYnkVeu5u/RDEAyec2cnJcOEMpagme0MBApcJUhiKiNgXokk+s5YBTb1unFmtlYfxwrpGB5I5wPv8O8oa/GhiaR2hPGrkhrc9TYjvqvXgJqNH1tKZvGeAlsbHT9LPRA+iruxg5y/d+x8v2PiTewyl9hq4rVKIoxyASIROEBfBuFQtx7Ei0JTGnZPUitNkU8ZzNJDDciEgd49sJEujxVtRIJpaPrZeABOsWD0Dm8N8waGdHG4K2v4JFSnX1xNoLMNsbaQXHGEK/i+StBDKwZEE5qvemSD8MQMkkgmvCJYdTj91j4und7B4unjjw0TwR3Dy32CSfJFYPIK/D2gh6f6xJovs1lxJYQUVFdoixzQEF51Drqr1X1V5v1Z/HqRtpBb0Cz5cmy5LFmT9eQJpsRrFvbjDZQCpWviWdXZzN0k9NpeSE6z05/4mRT7K595v/0TuqU+HkeDX2Hb7TxM28wDB7c39rnwiARoItlooaKWXcajHsl6aXylYJAaXpMq5YT5S7p614h5OSj1z3vfUg1E=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36347baa-c3f0-4623-fd9e-08dc314aea09
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2024 13:01:40.4775
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jIKWho3pQgIy+/ND/ouViy9d7rkYCrD4Hm0OTcuStcTcp7sZRzs37oZHBWPQ7I7+mbxInsmX7jVBSvOvAqQ5MQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6894
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-19_09,2024-02-19_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 malwarescore=0
 bulkscore=0 adultscore=0 suspectscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2402190096
X-Proofpoint-ORIG-GUID: zHqz47fZzbMjV5r3YvqP9RTIJ5QBYfg7
X-Proofpoint-GUID: zHqz47fZzbMjV5r3YvqP9RTIJ5QBYfg7

From: Prasad Singamsetty <prasad.singamsetty@oracle.com>

Extend statx system call to return additional info for atomic write support
support for a file.

Helper function generic_fill_statx_atomic_writes() can be used by FSes to
fill in the relevant statx fields.

Signed-off-by: Prasad Singamsetty <prasad.singamsetty@oracle.com>
#jpg: relocate bdev support to another patch
Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 fs/stat.c                 | 34 ++++++++++++++++++++++++++++++++++
 include/linux/fs.h        |  3 +++
 include/linux/stat.h      |  3 +++
 include/uapi/linux/stat.h |  9 ++++++++-
 4 files changed, 48 insertions(+), 1 deletion(-)

diff --git a/fs/stat.c b/fs/stat.c
index 77cdc69eb422..522787a4ab6a 100644
--- a/fs/stat.c
+++ b/fs/stat.c
@@ -89,6 +89,37 @@ void generic_fill_statx_attr(struct inode *inode, struct kstat *stat)
 }
 EXPORT_SYMBOL(generic_fill_statx_attr);
 
+/**
+ * generic_fill_statx_atomic_writes - Fill in the atomic writes statx attributes
+ * @stat:	Where to fill in the attribute flags
+ * @unit_min:	Minimum supported atomic write length
+ * @unit_max:	Maximum supported atomic write length
+ *
+ * Fill in the STATX{_ATTR}_WRITE_ATOMIC flags in the kstat structure from
+ * atomic write unit_min and unit_max values.
+ */
+void generic_fill_statx_atomic_writes(struct kstat *stat,
+				      unsigned int unit_min,
+				      unsigned int unit_max)
+{
+	/* Confirm that the request type is known */
+	stat->result_mask |= STATX_WRITE_ATOMIC;
+
+	/* Confirm that the file attribute type is known */
+	stat->attributes_mask |= STATX_ATTR_WRITE_ATOMIC;
+
+	if (unit_min) {
+		stat->atomic_write_unit_min = unit_min;
+		stat->atomic_write_unit_max = unit_max;
+		/* Initially only allow 1x segment */
+		stat->atomic_write_segments_max = 1;
+
+		/* Confirm atomic writes are actually supported */
+		stat->attributes |= STATX_ATTR_WRITE_ATOMIC;
+	}
+}
+EXPORT_SYMBOL(generic_fill_statx_atomic_writes);
+
 /**
  * vfs_getattr_nosec - getattr without security checks
  * @path: file to get attributes from
@@ -658,6 +689,9 @@ cp_statx(const struct kstat *stat, struct statx __user *buffer)
 	tmp.stx_mnt_id = stat->mnt_id;
 	tmp.stx_dio_mem_align = stat->dio_mem_align;
 	tmp.stx_dio_offset_align = stat->dio_offset_align;
+	tmp.stx_atomic_write_unit_min = stat->atomic_write_unit_min;
+	tmp.stx_atomic_write_unit_max = stat->atomic_write_unit_max;
+	tmp.stx_atomic_write_segments_max = stat->atomic_write_segments_max;
 
 	return copy_to_user(buffer, &tmp, sizeof(tmp)) ? -EFAULT : 0;
 }
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 7271640fd600..531140a7e27a 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -3167,6 +3167,9 @@ extern const struct inode_operations page_symlink_inode_operations;
 extern void kfree_link(void *);
 void generic_fillattr(struct mnt_idmap *, u32, struct inode *, struct kstat *);
 void generic_fill_statx_attr(struct inode *inode, struct kstat *stat);
+void generic_fill_statx_atomic_writes(struct kstat *stat,
+				      unsigned int unit_min,
+				      unsigned int unit_max);
 extern int vfs_getattr_nosec(const struct path *, struct kstat *, u32, unsigned int);
 extern int vfs_getattr(const struct path *, struct kstat *, u32, unsigned int);
 void __inode_add_bytes(struct inode *inode, loff_t bytes);
diff --git a/include/linux/stat.h b/include/linux/stat.h
index 52150570d37a..2c5e2b8c6559 100644
--- a/include/linux/stat.h
+++ b/include/linux/stat.h
@@ -53,6 +53,9 @@ struct kstat {
 	u32		dio_mem_align;
 	u32		dio_offset_align;
 	u64		change_cookie;
+	u32		atomic_write_unit_min;
+	u32		atomic_write_unit_max;
+	u32		atomic_write_segments_max;
 };
 
 /* These definitions are internal to the kernel for now. Mainly used by nfsd. */
diff --git a/include/uapi/linux/stat.h b/include/uapi/linux/stat.h
index 2f2ee82d5517..c0e8e10d1de6 100644
--- a/include/uapi/linux/stat.h
+++ b/include/uapi/linux/stat.h
@@ -127,7 +127,12 @@ struct statx {
 	__u32	stx_dio_mem_align;	/* Memory buffer alignment for direct I/O */
 	__u32	stx_dio_offset_align;	/* File offset alignment for direct I/O */
 	/* 0xa0 */
-	__u64	__spare3[12];	/* Spare space for future expansion */
+	__u32	stx_atomic_write_unit_min;
+	__u32	stx_atomic_write_unit_max;
+	__u32   stx_atomic_write_segments_max;
+	__u32   __spare1;
+	/* 0xb0 */
+	__u64	__spare3[10];	/* Spare space for future expansion */
 	/* 0x100 */
 };
 
@@ -155,6 +160,7 @@ struct statx {
 #define STATX_MNT_ID		0x00001000U	/* Got stx_mnt_id */
 #define STATX_DIOALIGN		0x00002000U	/* Want/got direct I/O alignment info */
 #define STATX_MNT_ID_UNIQUE	0x00004000U	/* Want/got extended stx_mount_id */
+#define STATX_WRITE_ATOMIC	0x00008000U	/* Want/got atomic_write_* fields */
 
 #define STATX__RESERVED		0x80000000U	/* Reserved for future struct statx expansion */
 
@@ -190,6 +196,7 @@ struct statx {
 #define STATX_ATTR_MOUNT_ROOT		0x00002000 /* Root of a mount */
 #define STATX_ATTR_VERITY		0x00100000 /* [I] Verity protected file */
 #define STATX_ATTR_DAX			0x00200000 /* File is currently in DAX state */
+#define STATX_ATTR_WRITE_ATOMIC		0x00400000 /* File supports atomic write operations */
 
 
 #endif /* _UAPI_LINUX_STAT_H */
-- 
2.31.1


