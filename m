Return-Path: <io-uring+bounces-1223-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A06A288C3BD
	for <lists+io-uring@lfdr.de>; Tue, 26 Mar 2024 14:41:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 508DF2E5A63
	for <lists+io-uring@lfdr.de>; Tue, 26 Mar 2024 13:41:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81EE08288B;
	Tue, 26 Mar 2024 13:39:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Wg1GJEBf";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="hrjZvV3z"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3D44823D8;
	Tue, 26 Mar 2024 13:39:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711460397; cv=fail; b=Z/8emr1L6j7/pE5HAqW6W4ZpG6xCTCEdsF/daid984FLOaQhLJ5rEy/vssddGRn5sKblee1k8BCgZ+5yVVSmIeSyKkSRKRzuOD/aXkIJcbPsY7uLGNJ4r4YQgxMaF5z2CXT4hphTLdR+dDf39rXe1NxfWckJJTF76YWfnjpoi+8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711460397; c=relaxed/simple;
	bh=3cAxuLAfQ3oCXhkW84Deid5lrqEaKr1Rlnalqs7AcxU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=FFGqAht0UtnpoeYHUr/FOR3FVup1ujEb5G/wWZtdFBXt55ZPmIm6yBcQy9xMGPoAOsZlvtBOR/OWdOjPRVsxHOI2RP8KM/nS+6kCdJjhgwin/CsW+fus7ir3DxT/9SVBRtBDQ/nXanwbLYBEM01uCaWU5utsGdT2F8RfFwvnhu4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Wg1GJEBf; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=hrjZvV3z; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42QBnhZq020670;
	Tue, 26 Mar 2024 13:39:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-11-20; bh=Fr54FxUWLT52JWHUXn2QR2++EZM85WeiAnL4rlrMdEQ=;
 b=Wg1GJEBfVYCdv3SUioF/oGMWrWyRKrFi+vJOGujUxIp/rKvBM/LHROQP+ilZeoQwDbyd
 m12b3UBsszyk05/bxbxw7A2X3iUeGCZPhYKlsU2Prrr+RUAOFdcLQPyy5dSIJ0q5zuwy
 /3r8rNv5ysa7yKllOZlPwhPN12E6VTgO5COLErklqQAuk2kgiHN1XHbu0NQIcIoJ/Sng
 45a0TsrV5klz0mYdOVgeMnvlj1emvnJ08yLP9J0/HW2IZP5CzvuhP3iYkdYVv+ZViBD8
 Zur0FgvfSg7ghHFwIaMCt2DW8Xrn4ahK2URHsZGdmlguAdB7E4XSHAH9owv2y+/vJX2S zw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3x1np2d1us-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 26 Mar 2024 13:39:28 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 42QCMUlL030916;
	Tue, 26 Mar 2024 13:39:27 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3x1nhd8ms1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 26 Mar 2024 13:39:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bsEcen+8AyBrDQ3WeeCiDHDsUAVclBpgSNXHZIVvkW1xUvdEfmyVNj6NOvXNOWvqst0oU8vHF4CAmgU51WoVQGMhdVxFTfmLYV273R3gW6/f70/RX/jaqueE3OMoUypt7+XANYvhuUZTrrX6Q2DpcpL4RLVixqtGeHHymOB4qgxaRDjb7db0kO4vK3B7qdHU8BNm2Zd4+2YY/FqrrDJelofVqpNhx6MieS+XDtrFqumOZJXwhKKYfGZ4zMxH5vLvDs7RpXB16855dbjJzC3mn38ONtvzK7DPumUqJow5Q0CvZnLb0Un+A2F0pEuIoIuMOI2GdgkdZQSXmRlsdFSLTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fr54FxUWLT52JWHUXn2QR2++EZM85WeiAnL4rlrMdEQ=;
 b=KUDrY2j25XDi+Xo+BViAjV1fukQ98CV7G/Whqe8MNVQOdHRs39zjwQZpStEmxolg1BmMUi6wCkjWPAjqV6ez/igBS5Avcjn+E9jSp69b31KNdwl4LmWQWMDVWV6nuy2LdUFsYPHv2I9R/SE+rtKe9bw1c/Em+iSKyJ+COydjFByRe97CMBSs/7tAGybSKdrpEPlqSTwti9SREwzD8L4VEkmzpD00NigVIotobTqg5Z6+ofwMwlwgj7pdM693MDkKBnLhhT79SQJAkgFVDASHzy1pTrUatQa3suORZQd0G1GPmBKzVa7vG7BSMdi0JL9No1IziqKnbBn0nQMBD/ntXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fr54FxUWLT52JWHUXn2QR2++EZM85WeiAnL4rlrMdEQ=;
 b=hrjZvV3zDKd45CxybEr67Kf3dcxZKkyI4iZ6TQ3kzVNX4A7kT7l3uqXHtr2wyT+armUav3FuF0FF2uzDMOrwuwRS97yvovubrFobPc96PvqxtN3/0jr3aJvWwUzHn6jCMBGAD2nwBt5p+t3qSF9ydQVB1OzFiDSpO76y/lP5qXE=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SJ0PR10MB4749.namprd10.prod.outlook.com (2603:10b6:a03:2da::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.31; Tue, 26 Mar
 2024 13:39:24 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ae68:7d51:133f:324]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ae68:7d51:133f:324%4]) with mapi id 15.20.7409.031; Tue, 26 Mar 2024
 13:39:24 +0000
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
        Prasad Singamsetty <prasad.singamsetty@oracle.com>,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v6 06/10] block: Add atomic write support for statx
Date: Tue, 26 Mar 2024 13:38:09 +0000
Message-Id: <20240326133813.3224593-7-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240326133813.3224593-1-john.g.garry@oracle.com>
References: <20240326133813.3224593-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0427.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a0::31) To DM6PR10MB4313.namprd10.prod.outlook.com
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
	QeiWE8YV/Hpu0tizzf4Iyv1BwACtJo5R+YLKJCqJxACS7QnvhhU3e3X4c7jLlab6ESmbPxn9SII7cnF+ETI7pA1/spkp2cBwttu9cIwZt2Zse8VOEkiHMKuNBnWPivkHUUDRMiIpZje2Qar3NzQOqlx4GedSI4dUrGOYJIBLneO1BM87hnX4WQ+q5A9d9Y6DiFsslbHHdAK8WwiYLSDrdvltSgor8b17daqtIdS0vmyjbV86MT89gC32AVtKzJKIeGVFKNiE0yVgMq2ldDKNdiJGqKz12VoBTx9wSQdfMCgLVUtbhj3I3NZkZY9Ovc+aEnPCYwO6mfbvDOCM1URgMsJAiflcQ8F+BUv1WJf/Yy6wokVAdvPl7QEpSdSR9RNC2EmTdxEGZWm9bwh8LyojsRvwsSNzQFb+bpAjQ4p3hwPiDKSVhfFeolTE9PTJgG9SEWzcEi3VPGtSfzBVH5USxwR1EC6OZMJos3F4pC2bUOBlY8pv6qpV0KusQL+zDVbx4OT1m/spsisWYnLO1YxoAh7RmIOVrZjT34piS4go3oqLvF6QPO8h8hUkKRyQbnBQP+0OobLyq/xrdSUG+EO6maa2+zZdeoH4OJULfjB0eaQwUnuMRsLo4BpNTzHj1kJROsYDFd6zqfPc4SlmXDTgNxlIq18z28YjeQOmCoWfLrSJurCMmYxEjBryz5bZk9eunPOZe+QlfcWWc32Hr+BMfA==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(7416005)(1800799015)(921011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?8feuZROfENmivh9lEuT2t1PmMCyXSr7LC99rebYy5rE4S4ZDSQObJ+iEpKDK?=
 =?us-ascii?Q?i6NXWB3nZHFmz9jXh3Z36nKucRTWCvMCGsL3TmphYU0FwB0UDjch0pAbFxQP?=
 =?us-ascii?Q?OjkTct1tY5cTrh31QF0P0bm2m9zBAVHqvxKNNIDiyOZsKCb1+KJBsjlspytC?=
 =?us-ascii?Q?hXe6zTP0lyb3+13xFt7uYncrWvH4f/KW728NXf9bVIA4HvRLXL4seSlypOhn?=
 =?us-ascii?Q?TAV49N6dVhr94B4DdZLY5pmqLwFqyxVC2ShDBGvlQ8p+ttly7bhchZo8W4a1?=
 =?us-ascii?Q?aZ7V4ZYSBITSt79bgo7lXl1QtGT/g0tppP6SqFDkQ2S/NbDDSijQR90jOlk5?=
 =?us-ascii?Q?bGky+7NKUz9b6Q2CXeLho+YqJI1xCFxfx6q7O6jNhGuU7J6uoNe8GdVgYH9i?=
 =?us-ascii?Q?ph0u8hhTMC9jLuSyoW3tsyxnaxxDPFo9mePwn4P1QbF+Vr1lJWvvjGeUHaSB?=
 =?us-ascii?Q?uRIyHKqhDgEVVvAkWayCd77nz5eGxnXeDRryb/yWel+3XR/6cpiT2cdUTQIi?=
 =?us-ascii?Q?yflFxtGbB1nitGQ5RGgl+sXbI1gtT5n578UK+Xeg8AR+u/o+wwaB9S9xDbMF?=
 =?us-ascii?Q?UmhV5H3jAQtQ7fgq8sUhOu5jEzeM3idjMMRuxyQD5f6Tkpu0aAACkdHzruMg?=
 =?us-ascii?Q?RNPLzbIh+cylQLGweeM692TSrSIj0DbGVjlwnJBi+41gOPeuDjuYLEpwdlWU?=
 =?us-ascii?Q?pTbepOASVdTyGFksTZ7VpWcN5z3km3cnlZG6crjGPKXMSLDEb7F4MVYU6HjI?=
 =?us-ascii?Q?+FtxRwr0q4zdb+lo1+SINyLhBAj8ZhtcdD2NlzegtH1Ah3PGZPTvso0QVTyd?=
 =?us-ascii?Q?U07HVOkNLuIhyAHKuJCkPz0kBJt96t+/a+rV2ir30B2fiSgK10kP9UgwScMX?=
 =?us-ascii?Q?GoT6JoRlMJP66N2wD0lZAiaz/EvMKScawhVpxna5eosoONXiGrxoUT8YLYrJ?=
 =?us-ascii?Q?NVuyMKNubLKEmumQAoEdV2AD8PuTic6jH+KBbKOSJsH9AqCU99IszXjkuoMc?=
 =?us-ascii?Q?nufsdxl3uJgkPy53wXDqKa+dv4DwR7MRaszdGwNSWnHDpPTDyJLt68xTqDug?=
 =?us-ascii?Q?dGquQDIo3vG3DiknfYQeGPDjEmAVKFAzg3DE/+mqJVKqtjQM7MpW5Pyxnuxp?=
 =?us-ascii?Q?ng06mlqk3RCN4FCdaNJxpcDOhDAkVBdsIPqAwxNWKQtWFEQ5vTl5+w/MzMB8?=
 =?us-ascii?Q?d/tz+hod8+wgllUw18M53UVHFApRMY36KlD7ioNfJLOvvlqJEJjh57J3nGUp?=
 =?us-ascii?Q?reo1GplIp73zSUGzBrZy7hDMdjje7cAB4ilJ99GF3IEFmda+lFiSLPq1tTbz?=
 =?us-ascii?Q?TEYyZ0/FYwgNzI7TY6on0tlMoAU1LC7BPhHQyXFEUMpOZTbLDDSgBmcGp7Rv?=
 =?us-ascii?Q?X4Wa1RC5DWSGhgfK0wWMYYP84p87WKkYPfr76fNMI6TZwE/4Sveofn6Iib4t?=
 =?us-ascii?Q?rjsKG4d3+J/CcvnOzR3b3ru7GbKyd+LPP0BShiKnNzeVnCC65BAxnV4q9/ED?=
 =?us-ascii?Q?WR20FGuM2zEsrDSyOk9BvEI9QVpMeNSHsjKkAARElu+udXSyxb9apQW4NxBH?=
 =?us-ascii?Q?/DEXAcMfAMMONtX6yVryG1yfWVMc2PhBxiG8qIOKqDOt4i5O3ZKp2yGmqQve?=
 =?us-ascii?Q?gQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	mcu7IA9wl9F0ouj1JrXxtibZQ/b+xwJ/6kV4BdtM7EPq95dl+PzTPM2Yjlmo4YOXLLlgRGNFsDo0eJex4kUEruliGJd8Uec0LRdU/2IoRZnlEL2vJ9yS4vT0TLBtyD5ko2niKx1BqtyiEHjex+p6vG6xdFtb1Yni3TGUDIbV0LoPbjEnj6amXOPHJtTNu0ke9kQbp185K6vxXH51hRr7g1o9NAWzfMkcHBNQKQfi+jN9Ae94F1mKNmNTDfmnxy6PhBK/mmTohishlEX3Tbm3sf5jITVxbxFluf6/VmLfGm/vl12KZJZXjgvUK4Hre1KfWd0wOYnGrIJ70ZQHHbksD9Y9Y3wI8+1uSr/LvIsLYBmBG0JZcBTbIL9DnI04KdZlr8rxu7jHatOD6qq7OIlWW1WYVW4wheaNuiA+Zdu2Vm2+hDN0pSerKT8UnfidzG+eMnjHHCUwe6KLFdal97l9y1dnIez4p2lAM3lCvCC8x5akaaPLUeAOvX0ISLhm6PYrsG4MOv9TM/3vg/a+Pc6lkJQUFeLymQBNrTN0mUuw/81s1fSkDon5VqjJ8aQGABqCDJugaBC72f6vSLU66vpfyTFtx2GkpabDbkX5aq06h2U=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db865a8f-9e54-439b-f84c-08dc4d9a2673
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2024 13:39:24.6118
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IxxdKyBQJAxMU6Fk+vgShypIBBFgkzmJz00nEfiGjx9QhDo+pqbED/bPwhXHyvgrxXPB+6kT2bY+q3wMHp+Gxg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4749
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-26_06,2024-03-21_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 spamscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2403210000
 definitions=main-2403260095
X-Proofpoint-GUID: 8YYgz4Fw3dkvOzl7EvdHNmNx5iR5wjTg
X-Proofpoint-ORIG-GUID: 8YYgz4Fw3dkvOzl7EvdHNmNx5iR5wjTg

From: Prasad Singamsetty <prasad.singamsetty@oracle.com>

Extend statx system call to return additional info for atomic write support
support if the specified file is a block device.

Signed-off-by: Prasad Singamsetty <prasad.singamsetty@oracle.com>
Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 block/bdev.c           | 36 ++++++++++++++++++++++++++----------
 fs/stat.c              | 16 +++++++++-------
 include/linux/blkdev.h |  6 ++++--
 3 files changed, 39 insertions(+), 19 deletions(-)

diff --git a/block/bdev.c b/block/bdev.c
index 7a5f611c3d2e..f3dd9f3c8838 100644
--- a/block/bdev.c
+++ b/block/bdev.c
@@ -1182,23 +1182,39 @@ void sync_bdevs(bool wait)
 }
 
 /*
- * Handle STATX_DIOALIGN for block devices.
- *
- * Note that the inode passed to this is the inode of a block device node file,
- * not the block device's internal inode.  Therefore it is *not* valid to use
- * I_BDEV() here; the block device has to be looked up by i_rdev instead.
+ * Handle STATX_{DIOALIGN, WRITE_ATOMIC} for block devices.
  */
-void bdev_statx_dioalign(struct inode *inode, struct kstat *stat)
+void bdev_statx(struct inode *backing_inode, struct kstat *stat,
+		u32 request_mask)
 {
 	struct block_device *bdev;
 
-	bdev = blkdev_get_no_open(inode->i_rdev);
+	if (!(request_mask & (STATX_DIOALIGN | STATX_WRITE_ATOMIC)))
+		return;
+
+	/*
+	 * Note that backing_inode is the inode of a block device node file,
+	 * not the block device's internal inode.  Therefore it is *not* valid
+	 * to use I_BDEV() here; the block device has to be looked up by i_rdev
+	 * instead.
+	 */
+	bdev = blkdev_get_no_open(backing_inode->i_rdev);
 	if (!bdev)
 		return;
 
-	stat->dio_mem_align = bdev_dma_alignment(bdev) + 1;
-	stat->dio_offset_align = bdev_logical_block_size(bdev);
-	stat->result_mask |= STATX_DIOALIGN;
+	if (request_mask & STATX_DIOALIGN) {
+		stat->dio_mem_align = bdev_dma_alignment(bdev) + 1;
+		stat->dio_offset_align = bdev_logical_block_size(bdev);
+		stat->result_mask |= STATX_DIOALIGN;
+	}
+
+	if (request_mask & STATX_WRITE_ATOMIC && bdev_can_atomic_write(bdev)) {
+		struct request_queue *bd_queue = bdev->bd_queue;
+
+		generic_fill_statx_atomic_writes(stat,
+			queue_atomic_write_unit_min_bytes(bd_queue),
+			queue_atomic_write_unit_max_bytes(bd_queue));
+	}
 
 	blkdev_put_no_open(bdev);
 }
diff --git a/fs/stat.c b/fs/stat.c
index 83aaa555711d..0e296925a56b 100644
--- a/fs/stat.c
+++ b/fs/stat.c
@@ -265,6 +265,7 @@ static int vfs_statx(int dfd, struct filename *filename, int flags,
 {
 	struct path path;
 	unsigned int lookup_flags = getname_statx_lookup_flags(flags);
+	struct inode *backing_inode;
 	int error;
 
 	if (flags & ~(AT_SYMLINK_NOFOLLOW | AT_NO_AUTOMOUNT | AT_EMPTY_PATH |
@@ -290,13 +291,14 @@ static int vfs_statx(int dfd, struct filename *filename, int flags,
 		stat->attributes |= STATX_ATTR_MOUNT_ROOT;
 	stat->attributes_mask |= STATX_ATTR_MOUNT_ROOT;
 
-	/* Handle STATX_DIOALIGN for block devices. */
-	if (request_mask & STATX_DIOALIGN) {
-		struct inode *inode = d_backing_inode(path.dentry);
-
-		if (S_ISBLK(inode->i_mode))
-			bdev_statx_dioalign(inode, stat);
-	}
+	/*
+	 * If this is a block device inode, override the filesystem
+	 * attributes with the block device specific parameters that need to be
+	 * obtained from the bdev backing inode.
+	 */
+	backing_inode = d_backing_inode(path.dentry);
+	if (S_ISBLK(backing_inode->i_mode))
+		bdev_statx(backing_inode, stat, request_mask);
 
 	path_put(&path);
 	if (retry_estale(error, lookup_flags)) {
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 07145b0acbc8..d16b0c451b27 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1594,7 +1594,8 @@ int sync_blockdev(struct block_device *bdev);
 int sync_blockdev_range(struct block_device *bdev, loff_t lstart, loff_t lend);
 int sync_blockdev_nowait(struct block_device *bdev);
 void sync_bdevs(bool wait);
-void bdev_statx_dioalign(struct inode *inode, struct kstat *stat);
+void bdev_statx(struct inode *backing_inode, struct kstat *stat,
+		u32 request_mask);
 void printk_all_partitions(void);
 int __init early_lookup_bdev(const char *pathname, dev_t *dev);
 #else
@@ -1612,7 +1613,8 @@ static inline int sync_blockdev_nowait(struct block_device *bdev)
 static inline void sync_bdevs(bool wait)
 {
 }
-static inline void bdev_statx_dioalign(struct inode *inode, struct kstat *stat)
+static inline void bdev_statx(struct inode *backing_inode, struct kstat *stat,
+				u32 request_mask)
 {
 }
 static inline void printk_all_partitions(void)
-- 
2.31.1


