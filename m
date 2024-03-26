Return-Path: <io-uring+bounces-1228-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E5D5588C3E6
	for <lists+io-uring@lfdr.de>; Tue, 26 Mar 2024 14:44:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 70D1D1F3F4D0
	for <lists+io-uring@lfdr.de>; Tue, 26 Mar 2024 13:44:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF47A757EB;
	Tue, 26 Mar 2024 13:41:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZHoWPy2y";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Etr9fFCX"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0592974E03;
	Tue, 26 Mar 2024 13:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711460470; cv=fail; b=joaIQyHKMG/xC6S8zZKPtYrS8hxriLf+xiYbvFVbnHMGvQpr75piS4RbUhZJn3Hroz73A6XKXphePqUfjVGL0H48WUBC+QBRtjxO/EzB/zi31EsvzQy+p1Bp/2gzEvhiT7Fmjyi2VKBKcAAHtEW6jYlls9A8FJJO8HYTmFsW/GQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711460470; c=relaxed/simple;
	bh=xJuoyL3PVMUwPxMDLvExBeqFnhSyGc/ugQWKDqRVEFg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=fpLuXVacNlzdKvgrKHTQNjW0ovV2dKVRMoepy+DLCaTJKvv/0G0NX2JftayIAyn4UjIBf2Y7I69otvndOypRO/PUklQNS3il3b24jPfK8t7vWfBibddGzdvV7MIAwvnI4fnoI3YWSVqlGWiIFJ/ibexlSG0p7ML0t6POtlb0L7Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ZHoWPy2y; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Etr9fFCX; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42QBnX9j005405;
	Tue, 26 Mar 2024 13:39:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-11-20; bh=2UEAXMQrzzKW8qOpzGvlPgwNC1E5B9xoTu8Ke0cdPNM=;
 b=ZHoWPy2yBZrjjfQ4uiJb1F7PE9HSBUIL65prujO6Ng/a8A8EvkRF1bgJuJD9Xp9g7ID7
 3eIEq8d2lkOfsF3STbijwjwvSNQLGtPdeMR8m5PG60ehSWtxxnloUDBNwaEa5UtQ9fod
 znarXdSL4XHDYDgDCq8xqG7XRXVV5ak/hZ0hTHpBcCVfhLCr5N1DhYli1KS6uK+eJyC4
 SfifZgtafjR+pJrXMOTis1dQ6FFYHo/lBayPF5IvTgrrI0xyk0JQvDm4TqrW9eQLHwUe
 XEx8Ql4RZzrKCV7MqG2JHD0REm6nqzXimGalLz7dapTfquoqobmnEhT0IDdFWydJZUIZ Eg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3x2s9gufjy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 26 Mar 2024 13:39:32 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 42QCMVdh030948;
	Tue, 26 Mar 2024 13:39:31 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3x1nhd8mv2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 26 Mar 2024 13:39:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MoogeVJ7GeWhLFS8Ai32GADkP689/eW+fftXcooMOyWadKqTtIvLF7i2lB/xvLAl7D+QriwKwvMMmVM7BkGzGuQyDVShQT7SlKcZIGoQDvBR8LYbQv88T978oiDcfNOkdPnh2B59BGDcai9RCGvKG9L95zgY6IckJX+bucC7+AXnABsmOMmDl0ztWTdHZymyqksnAo8GMm5paxnDW9WyCUNHQWlIFLpRO75Aw/oxXwldnSmLj31LozDHohCNLSqxde+G7aMN+Xs8r2xGYMku0V3zPlxgEMi5lp6Jk1wkFrjgIKHE1VsAHSPuDcNeQ9G0FhlfkrgX2h6VjsVZsQCjGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2UEAXMQrzzKW8qOpzGvlPgwNC1E5B9xoTu8Ke0cdPNM=;
 b=UJeisGGLdi72CLFOTMDHcnCymvYGjho2eNOlO4zAjBHjjab/CkWhDqXrYARpqGpO0nUfuP4LP0L5HJfSywmCOI2qQOvSZMrDD/qxsjLmD+75FL4QJ1fLWqh9H20PcBam/tS5ug7hGDDSCfOjaYBtDw9NKLOPPs6Vn29tybLn88g5iQ8RXDWVvWTPLR1X6yJEH8xXhyCQ2yMcqtOhAV3RpMUPWL41FmxGLAcHfAzn8h1vST0PLWKmLdj2LVl3rpVyAVYD82pXmqhCD2dUb57PuTn8tGkdwTqP5Qz2gB+WOMW3Ut4mb/TpR1mWunrEgGy7u5Yi+9xhuUhxI+QYBXCANA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2UEAXMQrzzKW8qOpzGvlPgwNC1E5B9xoTu8Ke0cdPNM=;
 b=Etr9fFCXvGJEkQ5uasBHRXCWzfmjw7SSWhoPqc5eJI8Sdy50HqqyH6d7yiuzZ1sLqPkbJyl8QxVpk5GGmSPMuPYnXuARisMzbai2hMSuEzngvi2W45JLtgkeCnTsWWELR3MzM7xihPDB7zYoPRED4pA3VvUFjCaKSU3dLnym5dE=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SJ0PR10MB4749.namprd10.prod.outlook.com (2603:10b6:a03:2da::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.31; Tue, 26 Mar
 2024 13:39:28 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ae68:7d51:133f:324]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ae68:7d51:133f:324%4]) with mapi id 15.20.7409.031; Tue, 26 Mar 2024
 13:39:28 +0000
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
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v6 07/10] block: Add fops atomic write support
Date: Tue, 26 Mar 2024 13:38:10 +0000
Message-Id: <20240326133813.3224593-8-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240326133813.3224593-1-john.g.garry@oracle.com>
References: <20240326133813.3224593-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P302CA0042.GBRP302.PROD.OUTLOOK.COM
 (2603:10a6:600:317::14) To DM6PR10MB4313.namprd10.prod.outlook.com
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
	wpWZFFCOGWW/xVa+7hnII0KUqvkJZZ0vgSA1Gv8ZuLt2cv+P7fYhEWxnXnAWysE5PA1uw1zHnGqGkh/i6ry2r43TfSICDD7VRAK/qIEtXwF8XO2ICrblhmPInwWBsGmtujZ5N6NP5YWm4JkgOiEuz1zGJcpHLN3x9znJvEtBci3HmBxFwLvPSy+qxy7nZYSLe3w+28ID5aSaeEpZpNVrbFk6OXXwMfOXsX4rQrb9dnq2Pd3AxC1GtFBRfDx1o1dQXTdZ4xHFYgrFwd21anxbbg72po/ORUfF84q9ydNHMrRZz8WMiolJr0godlJizQr1rMEe266z0l365hQKWlJth6hqKBTSsMINl1zuOvFVTOO2x8PTgMaaJJJgjavMerWGNpxu4p/YuW52C0XhqTp09Tbtu/8HELc8ocwdOU88/W4IgsDRCzdXSeRz532XiSDjq47u8D9IoQA5pp6Cd6SYTt2AFWslECQCZFvisuDlZir/iwpkQpByDL80x+V/QUQovZEWmRM4lprcjgsHQe7Xa0/IqsT1fzzCSGFJziw+zNFlsyv9EP8coy+z4vw2g4BQWm2iG/GW4rJvnJX3gcGm/hqgVftllG2YYyYuhU2XdT6V69xtSO4rHR7DLEVCnOS6EsBCuP+4eK294m6nk3Yc2IXF1WHM3fIDUQrsyBA/yDkLQ2zLV10CXxj7HtVGPfbRoYPoMhyg9Jg9etnUFZ3QFw==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(7416005)(1800799015)(921011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?ICBqZWwzK3jCpFaWezpYMmApGUNe4xYT9m2zIAiS7XLk2q1Ek5HU46XELnLB?=
 =?us-ascii?Q?qdBCABw/vv+sna6dInhbirBYAS4x7wOrdgugs9n06AFiSS6GV8ykuUa9JWeH?=
 =?us-ascii?Q?AraYWwS01JCCXbLmamdMQzTWwyUHvGTvV4BOVNb1rAK1KyckV2Lv0sGIC+N1?=
 =?us-ascii?Q?EVz7E3+ilWTLAgn+5jzmYp6g20HimO4POE9V9EjA+ilsMqyg53tjZ4ZPNo+6?=
 =?us-ascii?Q?YiBcE7YlAJ7xGvixAb0ttP4RAj69EgwdRrmXyAmOEVl1B4vF6MFO6XVYigVz?=
 =?us-ascii?Q?0/hKw3Csebh2kfoj7F93mfaV8pIZstoVXz6PFsEalkZ9sxjUXD3H1ZJzFFrZ?=
 =?us-ascii?Q?jklmD4SfwiHIJV9VZIGnw7AxEJd5Ac0UssRQEdLnMMmr1iIO4U47qw3ckRMA?=
 =?us-ascii?Q?7hsZcYD6jDuQz6lC23jdk/ehjq1egjNVtOB4vDpkQ3GZCbCtEtof/cM0VQ6X?=
 =?us-ascii?Q?9Umbp9bNcgJjSDn9pnFqCwwb5LdD7IS9RxHLbySxoxihqA2X7XvXlx1PBhzm?=
 =?us-ascii?Q?wFzor9sb8+XOuFy2DiI/bFma3oq8zbZYyfIhX5Ea5bkh4AD7w8951vM5bo9q?=
 =?us-ascii?Q?z58fBlwbvdIxcAdtlYNeLkD2VtDxnOe7K3YDWbeUEy3hg6xAULmw4hJAKe+s?=
 =?us-ascii?Q?OU/U22AZVCAVG9FtpQaepCtNL34xS+CoRwhpvQ7Y3OXmdluE0zwZdCQSytyK?=
 =?us-ascii?Q?XrFPSXXlwyhq0oYdYWqnDsxS/m9c6FQmN84f+PipJ5OBUHRD12JaTtNzuaAQ?=
 =?us-ascii?Q?cfPc8UXtf79gpPau7D7dHvnQm87C91l3YKpEY1akfoBudrS7+OhGwJxoUwcu?=
 =?us-ascii?Q?ohX3XkNSL/4tyScN35b4azGnCFH6yF/ZFIl8riKYmcbG3YrggGCcntxvLuFb?=
 =?us-ascii?Q?w9kTdCwkk7ZFBBZxSqw05poo7UYVGqwfrPPyP+1Y2Zaum1F/terKODv5Rv0D?=
 =?us-ascii?Q?5PV95z/H8ObWML/ubPG5FsxXpMU65PWluJZh7flARWm5YeE5o7WfmACEohOY?=
 =?us-ascii?Q?CQ9uopuVhPtKVzW0vzStWmqtHVQZKjdSYP6r+lyuXV4tWAzLFpxOofKQ/9Sk?=
 =?us-ascii?Q?jqT6+fMBugPKThGm4AlctzO4vQ3PJgmyow6WjGwCW2nAplZiv4OPdddIYga2?=
 =?us-ascii?Q?iRCOjDk1oWqmzqbOAGxQEytfZb1DxYKojzHuVQp9j3xrBRbZt7183vPfa2lz?=
 =?us-ascii?Q?zEA6VrSzRnSm6UOpWTCG+awQOvH08cH1pXWJz9UUzEWVwG1167469MUyZgC8?=
 =?us-ascii?Q?WerLbq3grHVVq2jCXmKBPdRnG11Mak3kh9xN/pDS84LdxJ3kDPCdqXoGv1cV?=
 =?us-ascii?Q?J/bhYpZ4kBzFgq+IR966suRuu/KWcVbvPr9t+FUUXOat3GmXoAtPkhAJY/r4?=
 =?us-ascii?Q?Lk1kwF0UoLJA8HTWHzdly3QvAOZHnjoBLUqSZcg6MFc4ArkKqBzWqVyEK/gR?=
 =?us-ascii?Q?JLEQjipABVfwiSvBq974NJ2HEDqgFm3d9lt+0IHj0gSCbl9C8oQKSBPvlIqX?=
 =?us-ascii?Q?sxqTd8S0d5//sBflzpx5Uz9I3+SPehk9wsYFRZSmmLJwnixVpkO1Q9XbZzxc?=
 =?us-ascii?Q?l4kzKLHzvL5OAxS0herUQWhJ8JxAqQkIeUL3IK0h55V33xVFVkdcPTvPyOFj?=
 =?us-ascii?Q?EA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	q/9cBShCsG4bNqeBAvNPw8X2dMPGwHqGgq0W3AGrXuLos6k3UlokcF8avPGk8t+Tm8V6tQcSCHSABCjk4UxuZvkMTNY6uIhZ3w5gJli47HK0d4TO4wPC3mKAxbfVCfZswCVm6iQZ3b0VDMHI3HSPR7bTZcU8EJKIIVHDZGtKXmQRoF3328h+/FgoB7AnEiJWa6zH/egtBF15rQcDwkG3IXCSH53ha9O748N6YmrJFSwbLgXWFBBPEEuHdQFTGUcn+ldLiEbDsHsQtGF17Q63hSYKXeICXQCQ5EZB5ELyK14szo0GV+vyTSQNFv25I5xO7gLJ8mSHZYa1g2LrbNwq3es6XZRPsEpWE4DoudScrcjvyLZwSY6q/WyYNkyNyx1MWQHVGSmO6GYJe2GSbuqLBIKZkJ6OHCNjti2Uqygurw0sO70k24JpDMxNOiGdzVMwaRswn6YjvLeN8vtbIrkhlmytK6N8+jxNRTDh/RQRVeyX9S8eOBE89KUz7+Mc5S51492e6R9ekCT+cYnTGhtnn9Xi29lu2+I/1L3egHsgDvf4PIZ3LTWAwBiLd9hdAsf+s9UMIq+xVzvKAIFG0/DkTBSwBor125YcaCxBB96H68Q=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed19ad93-1d38-4e99-f99d-08dc4d9a28b1
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2024 13:39:28.5404
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WV+ytPJWXbmzfjaCN1P91X/DNYXNNCMTXRVFpQmq8q2dGXuk/gqp15LazWtogYxIDuWNKc+qmT+syGFY13RqQg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4749
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-26_06,2024-03-21_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 spamscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2403210000
 definitions=main-2403260095
X-Proofpoint-GUID: WtbpovwVzsDrv32sZBONnlFbRTF0GYl5
X-Proofpoint-ORIG-GUID: WtbpovwVzsDrv32sZBONnlFbRTF0GYl5

Support atomic writes by submitting a single BIO with the REQ_ATOMIC set.

It must be ensured that the atomic write adheres to its rules, like
naturally aligned offset, so call blkdev_dio_invalid() ->
blkdev_atomic_write_valid() [with renaming blkdev_dio_unaligned() to
blkdev_dio_invalid()] for this purpose. The BIO submission path currently
checks for atomic writes which are too large, so no need to check here.

In blkdev_direct_IO(), if the nr_pages exceeds BIO_MAX_VECS, then we cannot
produce a single BIO, so error in this case.

Finally set FMODE_CAN_ATOMIC_WRITE when the bdev can support atomic writes
and the associated file flag is for O_DIRECT.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 block/fops.c | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/block/fops.c b/block/fops.c
index c091ea43bca3..34f788348352 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -34,9 +34,12 @@ static blk_opf_t dio_bio_write_op(struct kiocb *iocb)
 	return opf;
 }
 
-static bool blkdev_dio_unaligned(struct block_device *bdev, loff_t pos,
-			      struct iov_iter *iter)
+static bool blkdev_dio_invalid(struct block_device *bdev, loff_t pos,
+				struct iov_iter *iter, bool is_atomic)
 {
+	if (is_atomic && !generic_atomic_write_valid(pos, iter))
+		return true;
+
 	return pos & (bdev_logical_block_size(bdev) - 1) ||
 		!bdev_iter_is_aligned(bdev, iter);
 }
@@ -72,6 +75,8 @@ static ssize_t __blkdev_direct_IO_simple(struct kiocb *iocb,
 	bio.bi_iter.bi_sector = pos >> SECTOR_SHIFT;
 	bio.bi_write_hint = file_inode(iocb->ki_filp)->i_write_hint;
 	bio.bi_ioprio = iocb->ki_ioprio;
+	if (iocb->ki_flags & IOCB_ATOMIC)
+		bio.bi_opf |= REQ_ATOMIC;
 
 	ret = bio_iov_iter_get_pages(&bio, iter);
 	if (unlikely(ret))
@@ -343,6 +348,9 @@ static ssize_t __blkdev_direct_IO_async(struct kiocb *iocb,
 		task_io_account_write(bio->bi_iter.bi_size);
 	}
 
+	if (iocb->ki_flags & IOCB_ATOMIC)
+		bio->bi_opf |= REQ_ATOMIC;
+
 	if (iocb->ki_flags & IOCB_NOWAIT)
 		bio->bi_opf |= REQ_NOWAIT;
 
@@ -359,12 +367,13 @@ static ssize_t __blkdev_direct_IO_async(struct kiocb *iocb,
 static ssize_t blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 {
 	struct block_device *bdev = I_BDEV(iocb->ki_filp->f_mapping->host);
+	bool is_atomic = iocb->ki_flags & IOCB_ATOMIC;
 	unsigned int nr_pages;
 
 	if (!iov_iter_count(iter))
 		return 0;
 
-	if (blkdev_dio_unaligned(bdev, iocb->ki_pos, iter))
+	if (blkdev_dio_invalid(bdev, iocb->ki_pos, iter, is_atomic))
 		return -EINVAL;
 
 	nr_pages = bio_iov_vecs_to_alloc(iter, BIO_MAX_VECS + 1);
@@ -373,6 +382,8 @@ static ssize_t blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 			return __blkdev_direct_IO_simple(iocb, iter, bdev,
 							nr_pages);
 		return __blkdev_direct_IO_async(iocb, iter, bdev, nr_pages);
+	} else if (is_atomic) {
+		return -EINVAL;
 	}
 	return __blkdev_direct_IO(iocb, iter, bdev, bio_max_segs(nr_pages));
 }
@@ -612,6 +623,9 @@ static int blkdev_open(struct inode *inode, struct file *filp)
 	if (!bdev)
 		return -ENXIO;
 
+	if (bdev_can_atomic_write(bdev) && filp->f_flags & O_DIRECT)
+		filp->f_mode |= FMODE_CAN_ATOMIC_WRITE;
+
 	ret = bdev_open(bdev, mode, filp->private_data, NULL, filp);
 	if (ret)
 		blkdev_put_no_open(bdev);
-- 
2.31.1


