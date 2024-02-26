Return-Path: <io-uring+bounces-750-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id BAA58867F2D
	for <lists+io-uring@lfdr.de>; Mon, 26 Feb 2024 18:48:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 90E64B2A019
	for <lists+io-uring@lfdr.de>; Mon, 26 Feb 2024 17:41:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24398132C05;
	Mon, 26 Feb 2024 17:37:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Nm7LIt90";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="eA5K8uYL"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C8D113247C;
	Mon, 26 Feb 2024 17:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708969065; cv=fail; b=r8o70Yci7yl5P1l26drA94Tr3Wc7TQydSt3p+IDTHyk/Fev840kWrt2isfQfWPnCqlHX4ZS2896c4gDuEXjd2HOhNiAZFb+w5aD0NAzoq9Ynw2Jb0mw6cmHyRkN0AcpTiDkT8yR+FyzcMEi4I+qv9QGK6O5+jZURcTaqIXJMLDw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708969065; c=relaxed/simple;
	bh=kWoLfB5p2KVwYd6PBvFkO+dbwwC8N014PUSCGUPq0AA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=MwGBmd3GbVzgzn4tcTdsF4KBODaUxcKnwGfBGRzxu11mmpq4Hc5AcHGKp/ADqvngAu78cpi21Bq838mirlCU+cg0y8BiZz4ixHMUh0KhPYaJlA14igrmKfe012YBsp1Eoc+qESZ9srQmXDIakYeD+ekzbeUxpZU3h5pFpQPb3wU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Nm7LIt90; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=eA5K8uYL; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 41QGnPsD021398;
	Mon, 26 Feb 2024 17:36:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-11-20; bh=4ZfGhdFSU+QwN07Y6UT2PnyEVbwomXG8FOr9tGvECgM=;
 b=Nm7LIt90vgT9nOy4UGRVOrDaPNntRylzyphOAmDTTYHd2uS6ReHG2zvonZ9vEh4oIuP2
 XW1TzmNvPND7RQEeQtZmO1TmB2mjL0wPWUJkgRq1+aix+A+5aQpvqa6bTCWMD8gPMuRG
 aOA/V1SEhkxbzwZ9wIyrlGtzeu/KIuSKMUFUv+up5sGB1t2fmWuye+cX+Y90ajDlGnwh
 OtPClzwM5T0ebdO9yw6/p/Y+sVdtIO60drM+Qmjb8M6yfmK3w5KgBqhSRMljQpcuq/qm
 EREA8jKf57ihVAHisYx3rBq4Pr9VdvTAZoLS0WZoI/aYTzhY12JarnHRpxGbp02aqSXO hw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3wf722d65n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 26 Feb 2024 17:36:52 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 41QHOTtY009826;
	Mon, 26 Feb 2024 17:36:51 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3wf6w5wa79-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 26 Feb 2024 17:36:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X97hcc1Ps7aLHcSx4n7g5iCu048rRR5AJJ225VzZ4YnyyKfmNn0HZIKpfgrH53x46XA+GvImGTnkqiL14SgjzLBr/ZaI5HoufWBT4em+ibKQgn4NQLworPtX0yTgZ0cgKBnLF8wTENEKuLNadwEpwJ3t90ScM+HC1huk8UuY5MeiJ5Wg4euJZdl0FwXJKQAIHMW0zd2pU92mu//YA0N01KoAJ6yxk1ie/iQW/VH28IUoJC/stBz83sbLSOX1RZu2IqZkELv8wEVVJAj2Dr6RIUfM3q42Gkky30Lkk3w36GliEjP47RR7R1E7N2QATvRchggbY1np74MNubr7UbEH8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4ZfGhdFSU+QwN07Y6UT2PnyEVbwomXG8FOr9tGvECgM=;
 b=hOw8KnsdGSeIjPriaX6b6neHBInDTYvFofLHFG4Xq4uolU63nivtyvZ38ln/mNR/EIjdMp41DMcrmpWOEc7asYPctqgNCDh1aIze7bdXIP9ysCrdQ9fUfY3XaD+mbXkOawCcG4Y9EHbokmGeISTllRR2n3UYamzLcr56+UElSBw5zyU4FgsuskFm4Io0rK4Hh3wFs8CPNi7elMcPEsGXGP4faMyB+yMFy8smkSlLD7yCRPJxpX4N1k/B6MngideWxP2F+C9GkR/ddNWeWFsNZHZRoKDirT/8nH6oDZnlk5Uu57FzFVXbS7ymovmU1tLYLBMpixNyBnKWQiUStuKGIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4ZfGhdFSU+QwN07Y6UT2PnyEVbwomXG8FOr9tGvECgM=;
 b=eA5K8uYLsn8N86KrQ3wJLvFSCP+z+o0xhnXlJSJcdWpkIGnvxmH02wqxsrUZASiQgbk3A61b0hyL1p9otIrydCIu55yzI0PQVvEdUdp/djJpaiClBxmv/MqcBYaDLIP5Y+a/i+ksWUKwe+z5O8cCn9tnTO+3qkFIE53TARVq7cg=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by MW4PR10MB6298.namprd10.prod.outlook.com (2603:10b6:303:1e3::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.34; Mon, 26 Feb
 2024 17:36:49 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::97a0:a2a2:315e:7aff]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::97a0:a2a2:315e:7aff%3]) with mapi id 15.20.7316.034; Mon, 26 Feb 2024
 17:36:49 +0000
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
        John Garry <john.g.garry@oracle.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>
Subject: [PATCH v5 05/10] block: Add core atomic write support
Date: Mon, 26 Feb 2024 17:36:07 +0000
Message-Id: <20240226173612.1478858-6-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240226173612.1478858-1-john.g.garry@oracle.com>
References: <20240226173612.1478858-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH0PR07CA0040.namprd07.prod.outlook.com
 (2603:10b6:510:e::15) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|MW4PR10MB6298:EE_
X-MS-Office365-Filtering-Correlation-Id: 4d33334d-e4e6-407d-2d5d-08dc36f182bf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	TWcxpQAdCvPPhh4B+r7L1juY2DQJrbiC9d8VZe3eQ3XuTcirBKgaUnoktmAT5cI0VbbFaCmtpu9+cuNt+7n6iDvKxFh4YSWM3n6rH2m6OfV7qIAAAOMemVTMW/BgnoB7H8fbaXXxYjfPAWyc4d7YN2m6CIVk9fZqWHNhUGVIqkmwIlGourrKg/FyZHsBC4c58lM6BY3I5hipsjwkiB72lKGPePXzTxztBRcaPk35w811Mbk/78p2NaDfhlYvd/kk6YUOB9M6Z1WUcOINHWvg2sbzO+NMB8RlQFEnnmfnoIBEL2RBWg6FMKkoTgJigvWSf02686Ac6Oi8p3vk2rPSx0Ndjl8vzOHO12mLNxy3/X23GK0EEqZOeRPpIdoHnX91IT5tcAJaclDgm0dGDkORVwd8kdJNAss+0qHY06ITKaftyHOaGZvgr7YAy2ADKLHO+T8C/45NXfGi0XlHtCedvu/JJr2clMzXW70E9x3ckclqrS2mVujE9Rnhy1E7CqB2vL7gQNwlq9lhPoAVxXvlAzWOci1P6Ut67RjCXhT4XcktSIWpBbyvWeB09/V1SUrROjH+WVkqU8Zj5ukCMdfd6T5inj0vgLD9mWKhQ9TCWKtVV2wgX4dOl8ex+PC5spdlVtbAEa+Mi4jUa8pHo3c2gOOBM4z1K3AUfdutuCAIcoeVkaqKbsUQZyTMs/lfK0DUsXXf4AmNmONOsOCUbms1/w==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(921011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?XQ6g+o3wVkKvSrdXP3JVYKx11hyz94iLCdMMOpSbZKOLxSiW8QBDhCSvsemc?=
 =?us-ascii?Q?i1Bz7DIri0Pyj/1QKHH5yVbJtKA7O0fx+yYT4C+aXOH+RWsYob2IZAMT17TQ?=
 =?us-ascii?Q?dziDlzdPH0yXBdtXZ61roQEGiRj++K2vveEW/zAmD9wLnwQOHDXfbiF9rZ+N?=
 =?us-ascii?Q?bNPufG7pbz6O/9ZRoMHuLqiPk9ZRJm2k0sQEqCWOL3B1lgmUihecgd3JOAwQ?=
 =?us-ascii?Q?eHnW+tx2bHcADWTqKSpV+wqq8MinNNwdrfuIWYRQ3xXsvEIdKjLRFtxaB4VK?=
 =?us-ascii?Q?LPESrrmaOnlIqJng9ez4av1qNBvlBOobiot5YJc8DyKwaC8i/8LLohtYs6gZ?=
 =?us-ascii?Q?KlV6JAXFH0bpaSfjQ36uTOUoPBCwxh3SXFk4m23d5+4uXSsy6ncgz9DGXXzh?=
 =?us-ascii?Q?rhuY+sNX0iVvqQ6AhG7AtUAUHIrqXeBKh6pR/D0b4O3EU26YbE5zOjhZr0YP?=
 =?us-ascii?Q?pd6vmb0kzh/WpObNK4KThgUp3WX7XeityovIxiY2cgYDRLz70zn2lQmjEMyw?=
 =?us-ascii?Q?n06LmQr+v0xEO/e5HQAEHjdvD8DQQiP5OC84N+TA4HIc5GZs48A8iZZJG7js?=
 =?us-ascii?Q?kXsclSxyA28WuF8nzUbmpy+Jv9fY4l6hIQp6cVRq892OQHosWiB70QOLPtlH?=
 =?us-ascii?Q?x6/V2QR1mOetSl5aqA7P58JpvOprqBU5s5I169ETA6MN1BVgYprGMCOS5o68?=
 =?us-ascii?Q?/eB2nemNGQHDQzzKHiLGJARZ+8uY3wV/yL3fNoHhV5l6cMtUtnExWGnICZtN?=
 =?us-ascii?Q?iEwjYsX7O9fwLvDujjPI8zfnmhgEG/gW1LcZ67EF6CF9mSs19KMLBruHytkT?=
 =?us-ascii?Q?6dbAx6dDtuSZnXgooiP7QX8fEZkF+/88HVv4Rt9pqtkK/f59/+rJ6X8N1kAx?=
 =?us-ascii?Q?kX4RQqmsw7/EbLypYtcqFRW/KX8WUPBlER47cyeFVW47JhcNi1a6tIdBijxf?=
 =?us-ascii?Q?yuFqVfBtrPLFIrgdTfvHrHDSLbveSD0Q+OYfRE06HFKRvZV0zkZpq1bkzT5Q?=
 =?us-ascii?Q?J8jEUWOCkwAaKVwMcxdNC4dwmR5fpdpntf5bx/j6H9ASttajcKtWgS8ldr5e?=
 =?us-ascii?Q?r7WndiYUNbcRPBkD3JldYBcoTekfzUFHr/V7GaIPn1iL2l6npZGX6bS/V7CH?=
 =?us-ascii?Q?ox3uDFjUHUJkk6LPnDla1myiV78J7mxw2gNOZ+LJByn7bosxo1GVFlg4p+u2?=
 =?us-ascii?Q?ng8vcd+9UxT/2Q7j0hNZKhBLOXfiHFB8a17OrAXi78yaIIpLhW5VwXlHr3ak?=
 =?us-ascii?Q?w+0IdaqgGqW9FO2tev9AzA3L4vv6Rs43IYrMtubM5xxw8QkRshgtMhyW0eAL?=
 =?us-ascii?Q?ZxNJYVHvn4bF9XTXeW2M118Q3HTNLf40/83Qz4T/VyR4Pv8pTUNYZKXSEyOU?=
 =?us-ascii?Q?kRG0GItsLvLatZL8Jedw+OJwcCL6xpWu2BesMzCOSxevb48PUFBi7NwnaQCs?=
 =?us-ascii?Q?1fXaS6Qqkop8BrFtM76OPGpQGO21Yp3RGAncfcq2CObYTTPNP/cwGPGPaHke?=
 =?us-ascii?Q?gZzh2cvnk6pC9dz4duE7hL5rZbYHvKEGxsR6XpSY/keNTUMzvsqm77HDUexs?=
 =?us-ascii?Q?yUTzqShfYuGXzmhmtkK+5r/eVQjgfFNt9vVMlewRWWj812PUJY+bS7PBRmRC?=
 =?us-ascii?Q?7Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	zjJqaOPkGYoQ3A1l/kaQNgjtj6lUUW5vPHoMmsYsPsh6OK30Ak0kwPZCgCyFps8lm0MSaSBuaeEr1iQFpTcw+fFSwq5acgWrXca/tZ9+ntZ1MnI7aiToPixDiwtEqGbpfMirIa3A11kcGW/r5Qookm0e+IglJtwXSqiRMiXmY7v+DLMHKKXjoXVUxYMYRp/RCr8oWENC3aMyTYIuAdz/FCPN0aJkRqOO26KSF8ivc5s7g2qmLmk1l5IUj0kEFtPQmo+7GNCzrLJkWOQPt7rOCJth3IWB5eYKmtkpZYQ5QS5SyOsLh5Z+XuOe//sx0dyyyJ+laQdnqSSCcBzodhx+RML+JMDVztIW3/KU4QipnaHFVrZaSfkLYysm6/ULi4B9MvFw5HhW0sJM5RyDftTe//Up0wysizCy9dv79R1PBM6cCNeSd9ANCjNxrgH9DO1j6foNgc2LAO8JoGvkDJF9PZImjm5Em9/d+P899jGODhAsXepMmsJrMXzQwDbgvZdQwFbmyNPbSaPHMCNSwgIl8KPfrP6jIsiLxm9Hs7P+tphZcNR1JhNk8FZ+ZLRpqI1wD1pH4P3Jpz5oAJSEak9EmluGzdd3O7BTW5aX+uJTY8c=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d33334d-e4e6-407d-2d5d-08dc36f182bf
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2024 17:36:49.0398
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Uez65IleAmsxDvMsuz/S4Nh4Dj/F72sbEyTgr9GUgOF41RhBz9cOphKb79/Yzf6ZmNNaUnC1Q8x0Hc4t+WwGHA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6298
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-26_11,2024-02-26_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 bulkscore=0
 spamscore=0 mlxlogscore=999 phishscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2402260134
X-Proofpoint-ORIG-GUID: sheCYFfU-Hf_noO8WVeE8mKEnmpUYQOA
X-Proofpoint-GUID: sheCYFfU-Hf_noO8WVeE8mKEnmpUYQOA

Add atomic write support, as follows:
- add helper functions to get request_queue atomic write limits
- report request_queue atomic write support limits to sysfs and update Doc
- support to safely merge atomic writes
- deal with splitting atomic writes
- misc helper functions
- add a per-request atomic write flag

New request_queue limits are added, as follows:
- atomic_write_hw_max_sectors is set by the block driver and is the
  maximum length of an atomic write which the device may support. It is not
  necessarily a power-of-2.
- atomic_write_max_sectors is derived from atomic_write_hw_max_sectors and
  max_hw_sectors. It is always a power-of-2. Atomic writes may be merged,
  and atomic_write_max_sectors would be the limit on a merged atomic write
  request size. This value is not capped at max_sectors, as the value in
  max_sectors can be controlled from userspace, and it would only cause
  trouble if userspace could limit atomic_write_max_sectors and the other
  atomic write limits.
- atomic_write_hw_unit_{min,max}_sectors are set by the block driver and
  are the min/max length of an atomic write unit which the device may
  support. They both must be a power-of-2. Typically
  atomic_write_hw_unit_max_sectors will be the same value as
  atomic_write_hw_max_sectors.
- atomic_write_unit_{min,max}_sectors are derived from
  atomic_write_hw_unit_{min,max}_sectors, max_hw_sectors, and block core
  limits. Both min and max values must be a power-of-2. Typically a FS
  will use these values for reporting atomic write limits in statx.
- atomic_write_hw_boundary_sectors is set by the block driver. If
  non-zero, it indicates an LBA space boundary at which an atomic write
  straddles no longer is atomically executed by the disk. The value must
  be a power-of-2. Note that it would be acceptable to enforce a rule
  that atomic_write_hw_boundary_sectors is a multiple of
  atomic_write_hw_unit_max, but the resultant code would be more
  complicated.

All atomic writes limits are by default set 0 to indicate no atomic write
support. Even though it is assumed by Linux that a logical block can always
be atomically written, we ignore this as it is not of particular interest.
Stacked devices are just not supported either for now.

An atomic write must always be submitted to the block driver as part of a
single request. As such, only a single BIO must be submitted to the block
layer for an atomic write. When a single atomic write BIO is submitted, it
cannot be split. As such, atomic_write_unit_{max, min}_sectors are limited
by the maximum guaranteed BIO size which will not be required to be
split. This max size is calculated by request_queue max segments and the
number of bvecs a BIO can fit, BIO_MAX_VECS. Currently we rely on
userspace issuing a write with iovcnt=1 for pwritev2() - and thus we can
rely on each segment containing PAGE_SIZE of data, apart from the
first+last, which we can only rely on to contain logical block size of
data as they are aligned according to direct IO alignment rules.

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

Flag REQ_ATOMIC is used for indicating an atomic write.

Co-developed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 Documentation/ABI/stable/sysfs-block |  52 ++++++++++++++
 block/blk-merge.c                    |  95 ++++++++++++++++++++++++-
 block/blk-settings.c                 | 101 +++++++++++++++++++++++++++
 block/blk-sysfs.c                    |  33 +++++++++
 block/blk.h                          |   3 +
 include/linux/blk_types.h            |   3 +-
 include/linux/blkdev.h               |  61 ++++++++++++++++
 7 files changed, 346 insertions(+), 2 deletions(-)

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
diff --git a/block/blk-merge.c b/block/blk-merge.c
index 74e9e775f13d..60cec13f1137 100644
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
+		bio->bi_status = BLK_STS_IOERR;
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
@@ -814,6 +901,9 @@ static struct request *attempt_merge(struct request_queue *q,
 	if (req->ioprio != next->ioprio)
 		return NULL;
 
+	if (!blk_atomic_write_mergeable_rqs(req, next))
+		return NULL;
+
 	/*
 	 * If we are allowed to merge, then append bio list
 	 * from next to rq and release next. merge_requests_fn
@@ -941,6 +1031,9 @@ bool blk_rq_merge_ok(struct request *rq, struct bio *bio)
 	if (rq->ioprio != bio_prio(bio))
 		return false;
 
+	if (blk_atomic_write_mergeable_rq_bio(rq, bio) == false)
+		return false;
+
 	return true;
 }
 
diff --git a/block/blk-settings.c b/block/blk-settings.c
index 06ea91e51b8b..a98a0c0eb4e3 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -59,6 +59,13 @@ void blk_set_default_limits(struct queue_limits *lim)
 	lim->zoned = false;
 	lim->zone_write_granularity = 0;
 	lim->dma_alignment = 511;
+	lim->atomic_write_hw_max_sectors = 0;
+	lim->atomic_write_max_sectors = 0;
+	lim->atomic_write_hw_boundary_sectors = 0;
+	lim->atomic_write_hw_unit_min_sectors = 0;
+	lim->atomic_write_unit_min_sectors = 0;
+	lim->atomic_write_hw_unit_max_sectors = 0;
+	lim->atomic_write_unit_max_sectors = 0;
 }
 
 /**
@@ -101,6 +108,43 @@ void blk_queue_bounce_limit(struct request_queue *q, enum blk_bounce bounce)
 }
 EXPORT_SYMBOL(blk_queue_bounce_limit);
 
+/*
+ * Returns max guaranteed sectors which we can fit in a bio. For convenience of
+ * users, rounddown_pow_of_two() the return value.
+ *
+ * We always assume that we can fit in at least PAGE_SIZE in a segment, apart
+ * from first and last segments.
+ */
+static
+unsigned int blk_queue_max_guaranteed_bio_sectors(struct queue_limits *limits,
+						struct request_queue *q)
+{
+	unsigned int max_segments = min(BIO_MAX_VECS, limits->max_segments);
+	unsigned int length;
+
+	length = min(max_segments, 2) * queue_logical_block_size(q);
+	if (max_segments > 2)
+		length += (max_segments - 2) * PAGE_SIZE;
+
+	return rounddown_pow_of_two(length >> SECTOR_SHIFT);
+}
+
+static void blk_atomic_writes_update_limits(struct request_queue *q)
+{
+	struct queue_limits *limits = &q->limits;
+	unsigned int max_hw_sectors =
+		rounddown_pow_of_two(limits->max_hw_sectors);
+	unsigned int unit_limit = min(max_hw_sectors,
+		blk_queue_max_guaranteed_bio_sectors(limits, q));
+
+	limits->atomic_write_max_sectors =
+		min(limits->atomic_write_hw_max_sectors, max_hw_sectors);
+	limits->atomic_write_unit_min_sectors =
+		min(limits->atomic_write_hw_unit_min_sectors, unit_limit);
+	limits->atomic_write_unit_max_sectors =
+		min(limits->atomic_write_hw_unit_max_sectors, unit_limit);
+}
+
 /**
  * blk_queue_max_hw_sectors - set max sectors for a request for this queue
  * @q:  the request queue for the device
@@ -145,6 +189,8 @@ void blk_queue_max_hw_sectors(struct request_queue *q, unsigned int max_hw_secto
 				 limits->logical_block_size >> SECTOR_SHIFT);
 	limits->max_sectors = max_sectors;
 
+	blk_atomic_writes_update_limits(q);
+
 	if (!q->disk)
 		return;
 	q->disk->bdi->io_pages = max_sectors >> (PAGE_SHIFT - 9);
@@ -182,6 +228,61 @@ void blk_queue_max_discard_sectors(struct request_queue *q,
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
+	q->limits.atomic_write_hw_max_sectors = bytes >> SECTOR_SHIFT;
+	blk_atomic_writes_update_limits(q);
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
+	q->limits.atomic_write_hw_boundary_sectors = bytes >> SECTOR_SHIFT;
+}
+EXPORT_SYMBOL(blk_queue_atomic_write_boundary_bytes);
+
+/**
+ * blk_queue_atomic_write_unit_min_sectors - smallest unit that can be written
+ * atomically to the device.
+ * @q:  the request queue for the device
+ * @sectors: must be a power-of-two.
+ */
+void blk_queue_atomic_write_unit_min_sectors(struct request_queue *q,
+					     unsigned int sectors)
+{
+	q->limits.atomic_write_hw_unit_min_sectors = sectors;
+	blk_atomic_writes_update_limits(q);
+}
+EXPORT_SYMBOL(blk_queue_atomic_write_unit_min_sectors);
+
+/*
+ * blk_queue_atomic_write_unit_max_sectors - largest unit that can be written
+ * atomically to the device.
+ * @q: the request queue for the device
+ * @sectors: must be a power-of-two.
+ */
+void blk_queue_atomic_write_unit_max_sectors(struct request_queue *q,
+					     unsigned int sectors)
+{
+	q->limits.atomic_write_hw_unit_max_sectors = sectors;
+	blk_atomic_writes_update_limits(q);
+}
+EXPORT_SYMBOL(blk_queue_atomic_write_unit_max_sectors);
+
 /**
  * blk_queue_max_secure_erase_sectors - set max sectors for a secure erase
  * @q:  the request queue for the device
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 6b2429cad81a..3978f14f9769 100644
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
@@ -502,6 +526,11 @@ QUEUE_RO_ENTRY(queue_discard_max_hw, "discard_max_hw_bytes");
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
@@ -629,6 +658,10 @@ static struct attribute *queue_attrs[] = {
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
index 050696131329..6ba8333fcf26 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -178,6 +178,9 @@ static inline unsigned int blk_queue_get_max_sectors(struct request *rq)
 	if (unlikely(op == REQ_OP_WRITE_ZEROES))
 		return q->limits.max_write_zeroes_sectors;
 
+	if (rq->cmd_flags & REQ_ATOMIC)
+		return q->limits.atomic_write_max_sectors;
+
 	return q->limits.max_sectors;
 }
 
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index f288c94374b3..905c3dd53983 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -421,7 +421,7 @@ enum req_flag_bits {
 	__REQ_SWAP,		/* swap I/O */
 	__REQ_DRV,		/* for driver use */
 	__REQ_FS_PRIVATE,	/* for file system (submitter) use */
-
+	__REQ_ATOMIC,		/* for atomic write operations */
 	/*
 	 * Command specific flags, keep last:
 	 */
@@ -453,6 +453,7 @@ enum req_flag_bits {
 #define REQ_SWAP	(__force blk_opf_t)(1ULL << __REQ_SWAP)
 #define REQ_DRV		(__force blk_opf_t)(1ULL << __REQ_DRV)
 #define REQ_FS_PRIVATE	(__force blk_opf_t)(1ULL << __REQ_FS_PRIVATE)
+#define REQ_ATOMIC	(__force blk_opf_t)(1ULL << __REQ_ATOMIC)
 
 #define REQ_NOUNMAP	(__force blk_opf_t)(1ULL << __REQ_NOUNMAP)
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 99e4f5e72213..dee88e27ad59 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -299,6 +299,15 @@ struct queue_limits {
 	unsigned int		discard_alignment;
 	unsigned int		zone_write_granularity;
 
+	/* atomic write limits */
+	unsigned int		atomic_write_hw_max_sectors;
+	unsigned int		atomic_write_max_sectors;
+	unsigned int		atomic_write_hw_boundary_sectors;
+	unsigned int		atomic_write_hw_unit_min_sectors;
+	unsigned int		atomic_write_unit_min_sectors;
+	unsigned int		atomic_write_hw_unit_max_sectors;
+	unsigned int		atomic_write_unit_max_sectors;
+
 	unsigned short		max_segments;
 	unsigned short		max_integrity_segments;
 	unsigned short		max_discard_segments;
@@ -885,6 +894,14 @@ void blk_queue_zone_write_granularity(struct request_queue *q,
 				      unsigned int size);
 extern void blk_queue_alignment_offset(struct request_queue *q,
 				       unsigned int alignment);
+void blk_queue_atomic_write_max_bytes(struct request_queue *q,
+				unsigned int bytes);
+void blk_queue_atomic_write_unit_max_sectors(struct request_queue *q,
+				unsigned int sectors);
+void blk_queue_atomic_write_unit_min_sectors(struct request_queue *q,
+				unsigned int sectors);
+void blk_queue_atomic_write_boundary_bytes(struct request_queue *q,
+				unsigned int bytes);
 void disk_update_readahead(struct gendisk *disk);
 extern void blk_limits_io_min(struct queue_limits *limits, unsigned int min);
 extern void blk_queue_io_min(struct request_queue *q, unsigned int min);
@@ -1291,6 +1308,30 @@ static inline int queue_dma_alignment(const struct request_queue *q)
 	return q ? q->limits.dma_alignment : 511;
 }
 
+static inline unsigned int
+queue_atomic_write_unit_max_bytes(const struct request_queue *q)
+{
+	return q->limits.atomic_write_unit_max_sectors << SECTOR_SHIFT;
+}
+
+static inline unsigned int
+queue_atomic_write_unit_min_bytes(const struct request_queue *q)
+{
+	return q->limits.atomic_write_unit_min_sectors << SECTOR_SHIFT;
+}
+
+static inline unsigned int
+queue_atomic_write_boundary_bytes(const struct request_queue *q)
+{
+	return q->limits.atomic_write_hw_boundary_sectors << SECTOR_SHIFT;
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
@@ -1540,6 +1581,26 @@ struct io_comp_batch {
 	void (*complete)(struct io_comp_batch *);
 };
 
+static inline bool bdev_can_atomic_write(struct block_device *bdev)
+{
+	struct request_queue *bd_queue = bdev->bd_queue;
+	struct queue_limits *limits = &bd_queue->limits;
+
+	if (!limits->atomic_write_unit_min_sectors)
+		return false;
+
+	if (bdev_is_partition(bdev)) {
+		sector_t bd_start_sect = bdev->bd_start_sect;
+		unsigned int align =
+			max(limits->atomic_write_unit_min_sectors,
+			    limits->atomic_write_hw_boundary_sectors);
+		if (!IS_ALIGNED(bd_start_sect, align))
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


