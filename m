Return-Path: <io-uring+bounces-628-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 249CD85A41C
	for <lists+io-uring@lfdr.de>; Mon, 19 Feb 2024 14:03:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4CCB4B25E5C
	for <lists+io-uring@lfdr.de>; Mon, 19 Feb 2024 13:03:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F76035F0C;
	Mon, 19 Feb 2024 13:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CPLVAO4W";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="XE4WvFDO"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9F34374EE;
	Mon, 19 Feb 2024 13:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708347757; cv=fail; b=FfKknQbKFGOjWnhHYbM/tjSTyu36O+TXx+M9b+MiVa6juXqtM7xHN0sttISycOEQ1h6HNACbHpun2WTXN2mytWs7+uBb7twA7oSfzbIhtqDk6xtPUqaXlZ72GhCupuNa22S1IpnrJDrj5yzKgSfdlq3dKTHAwUAgvuliVs8wiLc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708347757; c=relaxed/simple;
	bh=DINodFixriwgPdVej78MNFpcWXxAviYvrHiCO1rdPXo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=hk3intQZ7zv4yG9Ie7N0isyfEIKfJqiZ1t8HEpVSAb9uJcbQNWOyPw6UQJHWYjbS/E4QL2eM16b5PQimm2S3LE7RoevZap2gFky1yy2K+h4RP5skdbQk3fc3QDpWcmkuokRqVIChXaRlRQTE+enmqgAfGiU0/LmNxjEvC6kwv2c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=CPLVAO4W; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=XE4WvFDO; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 41J8OORD024966;
	Mon, 19 Feb 2024 13:01:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-11-20; bh=xvAyjGKrIx9nhPlasc+3TQqwBzTQ7CMe2n/W8bpB1Es=;
 b=CPLVAO4WoUHJKTlWWEgrdzTYg4cKc9Dx1zdstOQ3BEuL4zEGvlPJOGuXm4tqo9HiZ4hH
 Zlv9qgjXlMvWaUe/wjv0hoCvl23AzUf2sZqpXc1FPwfR8i0ERt3UzCECyqu4elWEf03J
 O6CyOuyiAcdwePnZwkHXp9kSuTDO7DodqJQLoJV7lpx+7D0UXUEEC31/Py3uWD5bbxKj
 TtxdYjjgmP5KHbjJL7bj7uS14k87azrT8E+ur04awdibGl//CDcAx0491pvAR5CqJ9kg
 ZUF4GenIMlNOOjHTebmA0l4bizxD1VI2hzCHAZ0ZKAb7zfSQEjyhTSyZqPTwqMaCI2OW mw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3wanbvbyjk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 19 Feb 2024 13:01:56 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 41JCPCav021143;
	Mon, 19 Feb 2024 13:01:55 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3wak860wh1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 19 Feb 2024 13:01:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XsA+4mrzdEYPoW/JXAQUdoAUduUn/OWevwFxtmOF0G5ULy3Xyksa2x8DklmskHAo8Tn4qCCd9SStbtw6oEVYFqtgj3iGeG6xqoyYurxdsIqYeJoVgZYu5ramtQXnaUoKX7l1iIOeoMjG5LOxRHiWkTYfNWrUCc6KKbk/2YNo1OckAbF/BXis1LOhtRyBq4slfIQb4q9zHfnFWh86qR7EmsFA7gjocYyvaMcXMEKcQ60rVIBV0O+whD4IbObLKG+X8Z1WuCtrSyaeA9gkbGruNiNiDzp9D+mFG+Lp8DoS1boAli9+pEdmgW+E2tOwHWh7jbQkwbQqIUQFqT5jGd/T5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xvAyjGKrIx9nhPlasc+3TQqwBzTQ7CMe2n/W8bpB1Es=;
 b=YAJD4ITP6sREG4/gulevzTJNSv8ZVAZQNbhFuojINKTdt0Qlf0QTztMJGrtzqNjAKLkFbIUhRu0A0tysc9yyWPyJuz8xrjOShCwU+15uTr/cdCg2sb+sDEVzRh5q/UuaUGAc4WZ8T42m0UvB4sYVDU5sS87keKmcKChuquaI0p2oaiaU9oapTWnZKah+GchygkPkx9nq6mbfJrqf+peruUeEyCsakp2FNSp/zpC2kHe6pSqAND7zXDEr+hd2+Dksleni+vW23gX2iaTODPhcGyuDEfBFAT0eOV0B2MdAfAu5KJ8gKbQvkzL/Wscv3z4jFslXRZCfhsA38dE5QgrYtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xvAyjGKrIx9nhPlasc+3TQqwBzTQ7CMe2n/W8bpB1Es=;
 b=XE4WvFDOXngFLaINTwweYNl4RIPTT9MGEwpDOVLMMu3GDJkfXRFyCF/m7pMoHtYiqUvgXq94JmQ1YM3KQx0RN9sLethUPe0cmM/9+eBESO68lkDmjJJz3GR40ox/D79yPRnoLh+KMBwg57cSHkrpHDZWm2uNG+kkx+RVB+SDFR4=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DS0PR10MB6894.namprd10.prod.outlook.com (2603:10b6:8:134::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.38; Mon, 19 Feb
 2024 13:01:51 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::56f9:2210:db18:61c4]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::56f9:2210:db18:61c4%4]) with mapi id 15.20.7292.036; Mon, 19 Feb 2024
 13:01:51 +0000
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
Subject: [PATCH v4 09/11] scsi: scsi_debug: Atomic write support
Date: Mon, 19 Feb 2024 13:01:07 +0000
Message-Id: <20240219130109.341523-10-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240219130109.341523-1-john.g.garry@oracle.com>
References: <20240219130109.341523-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR02CA0046.namprd02.prod.outlook.com
 (2603:10b6:a03:54::23) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DS0PR10MB6894:EE_
X-MS-Office365-Filtering-Correlation-Id: abe71fec-6a4f-4731-0e99-08dc314af059
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	unxOjpjkv+cH70oSPer4zNS/dLS8ffuZ28mk38LCG/nyJG6Ry4ZXKpOLweXJLpZ365YOdrgqljw5dAQ1icYHi3IVI3vJi0z3hEfASofx6h67hdMyQi0bUomAEpOI5a38ZAi6tgGuKMa0156ScjidFGXvK2H7IshI7UFMxz/GeojzgK8dZn3eV/J3yaDqtfzjumYInYSPyLHBLdJvI/UH0rIhNvHAulu63JLLeM8hkSXsXswoe/UikabemNRho1QkZkcD4296KK5mu6iDVpOcW7pWAfpdBdGLql0nacWfeGvOUIiiMXaIfObj2YwlP7BGoI3VQ1P91X62qFFMMzNgcRh5sbyqn/ktkF4/1jwys1aXk9fuYCDj0xYhgx96tv2d4xQznjWc1Xzn4LVdYOgTmN5ujjoJYgFrLmA3zAHfbB7NPFQhQ9DcdYQ2LVywpCRTncHeM9+eMtLcASouOO5j8su3CrkF6WYnb7O236zEK3nYn/e1YibnFy30AGJHC1kVO6uYkZsEdUZ4TinmsvYiRihTNsO/F/ZSFszzmWlqUZeVfETqB8f0HB1V9cK4jyLmNJ886SYtETt79d2E1VBQYkbRbQ0bs3Uy65+6WiIZGU4=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(921011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?Sur/YpB6H/yhHm8WHXBjtq24b1Ih9YScr2KV4uz3UOjxrYkQgKHIruwEAULV?=
 =?us-ascii?Q?9qQlE/0djYkguK8BHUNfrgwPrSIymWcmTvpYP1aV5DwCEqmC5rlLePsKSI0M?=
 =?us-ascii?Q?5Q64BuMxJjVZGQRusiwL6twgNI+D1Kb1i7AQnk330B50SY2i9nl/NnAUVJSb?=
 =?us-ascii?Q?zkCT33VJgEx/l5naChOqoTXstuaEcSaETY0tDwka6gK3JZGh22oY4OUMaKFl?=
 =?us-ascii?Q?kZjt16VlG/hu90/rX21qFS8Kxtrv9ysMAZ7x7Ag/kNlqpHlrWaPi0AQZ3W3y?=
 =?us-ascii?Q?cPn9EWj7IUn1ZfbsXErNLaCP+wUC+RPUiJKVPLdwcJi/FhQBiElBynpaf/Y+?=
 =?us-ascii?Q?fBQnDwJFbvAVA3RuvxAQvpOdNEbnv34OgL/nqe565R1a8NU8PGISeqpyNuRy?=
 =?us-ascii?Q?FyBs2DBwZghaURyH91uJqUx1tHVuTEhj5VWJaM/LQylNj0WlDvh7R6st/10Q?=
 =?us-ascii?Q?VRLQ21b+FptAmXfZIWSjY36vgLJWGbp1L98JszTDn+PTLCr4oDuhUxdYb+sv?=
 =?us-ascii?Q?SFKvV5UGxUd7hwaKGr9sPsBGAxnTLYgBsoobphO24RTlhurRW5pz3AOZ6CIb?=
 =?us-ascii?Q?9AtzzJpx9eH6r5sM2hByqP/li7MdxgJxUWIz9hTrg+nbX4m/AS8+xW6u5QqE?=
 =?us-ascii?Q?xR3JeVxYRmKWzmjWBp5HfMT+pm3abBhR/7zpoGn00v/PDAzuUf4r4z1BUl+b?=
 =?us-ascii?Q?aRyaWu32PNPW9J60/YAVBT02ogDv4KfPCeuLf0F/7RvCYogY0ue7prGEUWHS?=
 =?us-ascii?Q?/CbopGRgSfQiiWVaSOF4h9DlvAzbx6cWToiYGvEBWnVZV3x1lpAInt6sP650?=
 =?us-ascii?Q?LgWdjWyYgpvxbIEe3QrWcH/MDLpo6XtSqsNyDtlpXuIbeAOPE0WuLnqa6N/H?=
 =?us-ascii?Q?tRubOt4o9zZi4bxQ0oiMaHi+sk+GuPueofbb+O5Cpd18Lid++vtSdrcpWyFQ?=
 =?us-ascii?Q?fUioKOYFG9XySQSipC9AkaGEIvp36QjZVjcCPRmxr7FLgoQpGR8I9g2VcuQU?=
 =?us-ascii?Q?RkVflpWfho0/shmTTfSmYgn0vDP/krbYJmLRJZAEvlDUsy3cs7k4zFcaa0hZ?=
 =?us-ascii?Q?A6HIfmfeSeQe9ib/Bp1ooaM31xpSB6BjQlZfwKErJQqH1bNyv6Lart98Aa8J?=
 =?us-ascii?Q?uz+hNptWmdsxTWLqiXQFfXWTbYII36cVeyUqIXLqBldL+4ZliZOru9C19SPZ?=
 =?us-ascii?Q?ZUTAqFqZhWsa/BeEnKdjpepNly1P9fjRV431Pmm3+h8O6TAwbG7eVFKp8NdR?=
 =?us-ascii?Q?GMzvT0vJb8ADwzWp8djMWRZh6numLz50KnqVu9HgsUrKgzRVin9ltDie0fSj?=
 =?us-ascii?Q?q8snAEBYXOYK3q79yUJIDMAmK70vmch1RPXyEZ12+qJpzxfKiWwxBfrm53dY?=
 =?us-ascii?Q?fhbZsqLvdvdSp1PVgCKfbSEOdvEk7Cbvw4OkQ+Y8MlGM0QIOvNZQTsG0lreJ?=
 =?us-ascii?Q?eNM+aW9/40x4POoIkKnHm23ypnbRJR1DiLxHOosyiOrXT74EoP6iJFH4mjWz?=
 =?us-ascii?Q?v/vHmQxKBXR6HB+Gkq4lcpCYcOvd0kEP74SstStrKpUJV4HbnyyvurGy0rnL?=
 =?us-ascii?Q?86uWexzBm826JRmy+cujYvJrpWsca+tUVIGnNqRKK/40Om8NH1Qvpq/Qb49r?=
 =?us-ascii?Q?bg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	3iy/QI7sQTuSdhx6WMGtCzxs0rRDJoh5LesJXzm4stlPjU6ZZ/fkBJBEnWfK8d9w730U0Hk5avB/2DIK29Bg16vdLSxD/T7VBocIVv5Nu0Tjz9ERuNp2ApUUcy591Tf/eRctCpK93nqmgDMzn/PQDidYUjtBNlinCmCMkVtWNLjBQnACYqu82idTzWKc6IgmYCVYZ/3mm3VGqbuBWDulSLFYlAO29L52zKYaOs63zLlm3+8pbjJHYTVRwaUqTTEE9MjDxrV6xWM8iL2VZekTTFbtLnxP2kNmvAV70zudtzELZLGfppnF2abbAKvg/i5QDmCcIp7pTLpYIUPcZHI288Gd3znlBgCHHF6o9qfG8x7D/BW/1aYGss2rWeFXs5hUQwNzXNBh6Tfvv326OCiMufZDytzuGyWgCQ9dA6HBvWCaPiEd7Rx2kj2JjiGibI8D+PxMs8GIaySTpHkOdwDshYO8xVfankaZmmO0UsDcRB6BgBhA0yBT/9ls+h17XTOoVrTovG7mLLANKtMt272fMghqreDoXIYBCzA8PkOpQHnFa+1Sf4hCPOKuNSiollnD/9eGYEy+f2Dnnd5JrW/H3jhmKW9vFGo5BnnB4IdVWC0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: abe71fec-6a4f-4731-0e99-08dc314af059
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2024 13:01:51.1915
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MoTxuTm7xWx8atMibBzsOYMBZlF93ZY1ZfWEHWJh07i28AH/Oqw2midXRnXb8DBTrb7H9CThSQkwVCfcsoem5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6894
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-19_09,2024-02-19_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 adultscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 phishscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2402190096
X-Proofpoint-GUID: zIZUQgjKKIU0zMMEap0CHiyb62Y8Myc-
X-Proofpoint-ORIG-GUID: zIZUQgjKKIU0zMMEap0CHiyb62Y8Myc-

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

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/scsi_debug.c | 589 +++++++++++++++++++++++++++++---------
 1 file changed, 456 insertions(+), 133 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 9070c0dc05ef..9568bcbf0821 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -68,6 +68,8 @@ static const char *sdebug_version_date = "20210520";
 
 /* Additional Sense Code (ASC) */
 #define NO_ADDITIONAL_SENSE 0x0
+#define OVERLAP_ATOMIC_COMMAND_ASC 0x0
+#define OVERLAP_ATOMIC_COMMAND_ASCQ 0x23
 #define LOGICAL_UNIT_NOT_READY 0x4
 #define LOGICAL_UNIT_COMMUNICATION_FAILURE 0x8
 #define UNRECOVERED_READ_ERR 0x11
@@ -102,6 +104,7 @@ static const char *sdebug_version_date = "20210520";
 #define READ_BOUNDARY_ASCQ 0x7
 #define ATTEMPT_ACCESS_GAP 0x9
 #define INSUFF_ZONE_ASCQ 0xe
+/* see drivers/scsi/sense_codes.h */
 
 /* Additional Sense Code Qualifier (ASCQ) */
 #define ACK_NAK_TO 0x3
@@ -151,6 +154,12 @@ static const char *sdebug_version_date = "20210520";
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
@@ -373,7 +382,9 @@ struct sdebug_host_info {
 
 /* There is an xarray of pointers to this struct's objects, one per host */
 struct sdeb_store_info {
-	rwlock_t macc_lck;	/* for atomic media access on this store */
+	rwlock_t macc_data_lck;	/* for media data access on this store */
+	rwlock_t macc_meta_lck;	/* for atomic media meta access on this store */
+	rwlock_t macc_sector_lck;	/* per-sector media data access on this store */
 	u8 *storep;		/* user data storage (ram) */
 	struct t10_pi_tuple *dif_storep; /* protection info */
 	void *map_storep;	/* provisioning map */
@@ -397,12 +408,20 @@ struct sdebug_defer {
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
@@ -462,7 +481,8 @@ enum sdeb_opcode_index {
 	SDEB_I_PRE_FETCH = 29,		/* 10, 16 */
 	SDEB_I_ZONE_OUT = 30,		/* 0x94+SA; includes no data xfer */
 	SDEB_I_ZONE_IN = 31,		/* 0x95+SA; all have data-in */
-	SDEB_I_LAST_ELEM_P1 = 32,	/* keep this last (previous + 1) */
+	SDEB_I_ATOMIC_WRITE_16 = 32,
+	SDEB_I_LAST_ELEM_P1 = 33,	/* keep this last (previous + 1) */
 };
 
 
@@ -496,7 +516,8 @@ static const unsigned char opcode_ind_arr[256] = {
 	0, 0, 0, SDEB_I_VERIFY,
 	SDEB_I_PRE_FETCH, SDEB_I_SYNC_CACHE, 0, SDEB_I_WRITE_SAME,
 	SDEB_I_ZONE_OUT, SDEB_I_ZONE_IN, 0, 0,
-	0, 0, 0, 0, 0, 0, SDEB_I_SERV_ACT_IN_16, SDEB_I_SERV_ACT_OUT_16,
+	0, 0, 0, 0,
+	SDEB_I_ATOMIC_WRITE_16, 0, SDEB_I_SERV_ACT_IN_16, SDEB_I_SERV_ACT_OUT_16,
 /* 0xa0; 0xa0->0xbf: 12 byte cdbs */
 	SDEB_I_REPORT_LUNS, SDEB_I_ATA_PT, 0, SDEB_I_MAINT_IN,
 	     SDEB_I_MAINT_OUT, 0, 0, 0,
@@ -544,6 +565,7 @@ static int resp_write_buffer(struct scsi_cmnd *, struct sdebug_dev_info *);
 static int resp_sync_cache(struct scsi_cmnd *, struct sdebug_dev_info *);
 static int resp_pre_fetch(struct scsi_cmnd *, struct sdebug_dev_info *);
 static int resp_report_zones(struct scsi_cmnd *, struct sdebug_dev_info *);
+static int resp_atomic_write(struct scsi_cmnd *, struct sdebug_dev_info *);
 static int resp_open_zone(struct scsi_cmnd *, struct sdebug_dev_info *);
 static int resp_close_zone(struct scsi_cmnd *, struct sdebug_dev_info *);
 static int resp_finish_zone(struct scsi_cmnd *, struct sdebug_dev_info *);
@@ -782,6 +804,11 @@ static const struct opcode_info_t opcode_info_arr[SDEB_I_LAST_ELEM_P1 + 1] = {
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
@@ -829,6 +856,13 @@ static unsigned int sdebug_unmap_granularity = DEF_UNMAP_GRANULARITY;
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
@@ -1180,6 +1214,11 @@ static inline bool scsi_debug_lbp(void)
 		(sdebug_lbpu || sdebug_lbpws || sdebug_lbpws10);
 }
 
+static inline bool scsi_debug_atomic_write(void)
+{
+	return 0 == sdebug_fake_rw && sdebug_atomic_wr;
+}
+
 static void *lba2fake_store(struct sdeb_store_info *sip,
 			    unsigned long long lba)
 {
@@ -1807,6 +1846,14 @@ static int inquiry_vpd_b0(unsigned char *arr)
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
 
@@ -3304,15 +3351,239 @@ static inline struct sdeb_store_info *devip2sip(struct sdebug_dev_info *devip,
 	return xa_load(per_store_ap, devip->sdbg_host->si_idx);
 }
 
+
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
+sdeb_data_lock(struct sdeb_store_info *sip, bool atomic_write)
+{
+	if (atomic_write)
+		sdeb_data_write_lock(sip);
+	else
+		sdeb_data_read_lock(sip);
+}
+
+static inline void
+sdeb_data_unlock(struct sdeb_store_info *sip, bool atomic_write)
+{
+	if (atomic_write)
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
-			    u32 sg_skip, u64 lba, u32 num, bool do_write)
+			    u32 sg_skip, u64 lba, u32 num, bool do_write,
+			    bool atomic_write)
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
+	if (!do_write && atomic_write)
+		return -1;
 
 	if (do_write) {
 		dir = DMA_TO_DEVICE;
@@ -3328,21 +3599,26 @@ static int do_device_access(struct sdeb_store_info *sip, struct scsi_cmnd *scp,
 	fsp = sip->storep;
 
 	block = do_div(lba, sdebug_store_sectors);
-	if (block + num > sdebug_store_sectors)
-		rest = block + num - sdebug_store_sectors;
 
-	ret = sg_copy_buffer(sdb->table.sgl, sdb->table.nents,
+	/* Only allow 1x atomic write or multiple non-atomic writes at any given time */
+	sdeb_data_lock(sip, atomic_write);
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
+	sdeb_data_unlock(sip, atomic_write);
 
 	return ret;
 }
@@ -3518,70 +3794,6 @@ static int prot_verify_read(struct scsi_cmnd *scp, sector_t start_sec,
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
@@ -3591,6 +3803,7 @@ static int resp_read_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	u64 lba;
 	struct sdeb_store_info *sip = devip2sip(devip, true);
 	u8 *cmd = scp->cmnd;
+	bool meta_data_locked = false;
 
 	switch (cmd[0]) {
 	case READ_16:
@@ -3649,6 +3862,10 @@ static int resp_read_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 		atomic_set(&sdeb_inject_pending, 0);
 	}
 
+	/*
+	 * When checking device access params, for reads we only check data
+	 * versus what is set at init time, so no need to lock.
+	 */
 	ret = check_device_access_params(scp, lba, num, false);
 	if (ret)
 		return ret;
@@ -3668,29 +3885,33 @@ static int resp_read_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
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
@@ -3698,8 +3919,9 @@ static int resp_read_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 		}
 	}
 
-	ret = do_device_access(sip, scp, 0, lba, num, false);
-	sdeb_read_unlock(sip);
+	ret = do_device_access(sip, scp, 0, lba, num, false, false);
+	if (meta_data_locked)
+		sdeb_meta_read_unlock(sip);
 	if (unlikely(ret == -1))
 		return DID_ERROR << 16;
 
@@ -3888,6 +4110,7 @@ static int resp_write_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	u64 lba;
 	struct sdeb_store_info *sip = devip2sip(devip, true);
 	u8 *cmd = scp->cmnd;
+	bool meta_data_locked = false;
 
 	switch (cmd[0]) {
 	case WRITE_16:
@@ -3941,10 +4164,17 @@ static int resp_write_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
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
 
@@ -3953,22 +4183,22 @@ static int resp_write_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
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
@@ -3976,13 +4206,16 @@ static int resp_write_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 		}
 	}
 
-	ret = do_device_access(sip, scp, 0, lba, num, true);
+	ret = do_device_access(sip, scp, 0, lba, num, true, false);
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
@@ -4089,7 +4322,8 @@ static int resp_write_scat(struct scsi_cmnd *scp,
 		goto err_out;
 	}
 
-	sdeb_write_lock(sip);
+	/* Just keep it simple and always lock for now */
+	sdeb_meta_write_lock(sip);
 	sg_off = lbdof_blen;
 	/* Spec says Buffer xfer Length field in number of LBs in dout */
 	cum_lb = 0;
@@ -4132,7 +4366,11 @@ static int resp_write_scat(struct scsi_cmnd *scp,
 			}
 		}
 
-		ret = do_device_access(sip, scp, sg_off, lba, num, true);
+		/*
+		 * Write ranges atomically to keep as close to pre-atomic
+		 * writes behaviour as possible.
+		 */
+		ret = do_device_access(sip, scp, sg_off, lba, num, true, true);
 		/* If ZBC zone then bump its write pointer */
 		if (sdebug_dev_is_zoned(devip))
 			zbc_inc_wp(devip, lba, num);
@@ -4171,7 +4409,7 @@ static int resp_write_scat(struct scsi_cmnd *scp,
 	}
 	ret = 0;
 err_out_unlock:
-	sdeb_write_unlock(sip);
+	sdeb_meta_write_unlock(sip);
 err_out:
 	kfree(lrdp);
 	return ret;
@@ -4190,14 +4428,16 @@ static int resp_write_same(struct scsi_cmnd *scp, u64 lba, u32 num,
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
@@ -4208,6 +4448,7 @@ static int resp_write_same(struct scsi_cmnd *scp, u64 lba, u32 num,
 	/* if ndob then zero 1 logical block, else fetch 1 logical block */
 	fsp = sip->storep;
 	fs1p = fsp + (block * lb_size);
+	sdeb_data_write_lock(sip);
 	if (ndob) {
 		memset(fs1p, 0, lb_size);
 		ret = 0;
@@ -4215,8 +4456,8 @@ static int resp_write_same(struct scsi_cmnd *scp, u64 lba, u32 num,
 		ret = fetch_to_dev_buffer(scp, fs1p, lb_size);
 
 	if (-1 == ret) {
-		sdeb_write_unlock(sip);
-		return DID_ERROR << 16;
+		ret = DID_ERROR << 16;
+		goto out;
 	} else if (sdebug_verbose && !ndob && (ret < lb_size))
 		sdev_printk(KERN_INFO, scp->device,
 			    "%s: %s: lb size=%u, IO sent=%d bytes\n",
@@ -4233,10 +4474,12 @@ static int resp_write_same(struct scsi_cmnd *scp, u64 lba, u32 num,
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
@@ -4379,25 +4622,30 @@ static int resp_comp_write(struct scsi_cmnd *scp,
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
@@ -4441,7 +4689,7 @@ static int resp_unmap(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 
 	desc = (void *)&buf[8];
 
-	sdeb_write_lock(sip);
+	sdeb_meta_write_lock(sip);
 
 	for (i = 0 ; i < descriptors ; i++) {
 		unsigned long long lba = get_unaligned_be64(&desc[i].lba);
@@ -4457,7 +4705,7 @@ static int resp_unmap(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	ret = 0;
 
 out:
-	sdeb_write_unlock(sip);
+	sdeb_meta_write_unlock(sip);
 	kfree(buf);
 
 	return ret;
@@ -4570,12 +4818,13 @@ static int resp_pre_fetch(struct scsi_cmnd *scp,
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
@@ -4734,7 +4983,7 @@ static int resp_verify(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 		return check_condition_result;
 	}
 	/* Not changing store, so only need read access */
-	sdeb_read_lock(sip);
+	sdeb_data_read_lock(sip);
 
 	ret = do_dout_fetch(scp, a_num, arr);
 	if (ret == -1) {
@@ -4756,7 +5005,7 @@ static int resp_verify(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 		goto cleanup;
 	}
 cleanup:
-	sdeb_read_unlock(sip);
+	sdeb_data_read_unlock(sip);
 	kfree(arr);
 	return ret;
 }
@@ -4802,7 +5051,7 @@ static int resp_report_zones(struct scsi_cmnd *scp,
 		return check_condition_result;
 	}
 
-	sdeb_read_lock(sip);
+	sdeb_meta_read_lock(sip);
 
 	desc = arr + 64;
 	for (lba = zs_lba; lba < sdebug_capacity;
@@ -4900,11 +5149,70 @@ static int resp_report_zones(struct scsi_cmnd *scp,
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
+	ret = do_device_access(sip, scp, 0, lba, len, true, true);
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
@@ -4931,8 +5239,7 @@ static int resp_open_zone(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 		mk_sense_invalid_opcode(scp);
 		return check_condition_result;
 	}
-
-	sdeb_write_lock(sip);
+	sdeb_meta_write_lock(sip);
 
 	if (all) {
 		/* Check if all closed zones can be open */
@@ -4981,7 +5288,7 @@ static int resp_open_zone(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 
 	zbc_open_zone(devip, zsp, true);
 fini:
-	sdeb_write_unlock(sip);
+	sdeb_meta_write_unlock(sip);
 	return res;
 }
 
@@ -5008,7 +5315,7 @@ static int resp_close_zone(struct scsi_cmnd *scp,
 		return check_condition_result;
 	}
 
-	sdeb_write_lock(sip);
+	sdeb_meta_write_lock(sip);
 
 	if (all) {
 		zbc_close_all(devip);
@@ -5037,7 +5344,7 @@ static int resp_close_zone(struct scsi_cmnd *scp,
 
 	zbc_close_zone(devip, zsp);
 fini:
-	sdeb_write_unlock(sip);
+	sdeb_meta_write_unlock(sip);
 	return res;
 }
 
@@ -5080,7 +5387,7 @@ static int resp_finish_zone(struct scsi_cmnd *scp,
 		return check_condition_result;
 	}
 
-	sdeb_write_lock(sip);
+	sdeb_meta_write_lock(sip);
 
 	if (all) {
 		zbc_finish_all(devip);
@@ -5109,7 +5416,7 @@ static int resp_finish_zone(struct scsi_cmnd *scp,
 
 	zbc_finish_zone(devip, zsp, true);
 fini:
-	sdeb_write_unlock(sip);
+	sdeb_meta_write_unlock(sip);
 	return res;
 }
 
@@ -5160,7 +5467,7 @@ static int resp_rwp_zone(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 		return check_condition_result;
 	}
 
-	sdeb_write_lock(sip);
+	sdeb_meta_write_lock(sip);
 
 	if (all) {
 		zbc_rwp_all(devip);
@@ -5188,7 +5495,7 @@ static int resp_rwp_zone(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 
 	zbc_rwp_zone(devip, zsp);
 fini:
-	sdeb_write_unlock(sip);
+	sdeb_meta_write_unlock(sip);
 	return res;
 }
 
@@ -5215,6 +5522,7 @@ static void sdebug_q_cmd_complete(struct sdebug_defer *sd_dp)
 	if (!scp) {
 		pr_err("scmd=NULL\n");
 		goto out;
+
 	}
 
 	sdsc = scsi_cmd_priv(scp);
@@ -6152,6 +6460,7 @@ module_param_named(lbprz, sdebug_lbprz, int, S_IRUGO);
 module_param_named(lbpu, sdebug_lbpu, int, S_IRUGO);
 module_param_named(lbpws, sdebug_lbpws, int, S_IRUGO);
 module_param_named(lbpws10, sdebug_lbpws10, int, S_IRUGO);
+module_param_named(atomic_wr, sdebug_atomic_wr, int, S_IRUGO);
 module_param_named(lowest_aligned, sdebug_lowest_aligned, int, S_IRUGO);
 module_param_named(lun_format, sdebug_lun_am_i, int, S_IRUGO | S_IWUSR);
 module_param_named(max_luns, sdebug_max_luns, int, S_IRUGO | S_IWUSR);
@@ -6186,6 +6495,11 @@ module_param_named(unmap_alignment, sdebug_unmap_alignment, int, S_IRUGO);
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
@@ -6229,6 +6543,7 @@ MODULE_PARM_DESC(lbprz,
 MODULE_PARM_DESC(lbpu, "enable LBP, support UNMAP command (def=0)");
 MODULE_PARM_DESC(lbpws, "enable LBP, support WRITE SAME(16) with UNMAP bit (def=0)");
 MODULE_PARM_DESC(lbpws10, "enable LBP, support WRITE SAME(10) with UNMAP bit (def=0)");
+MODULE_PARM_DESC(atomic_write, "enable ATOMIC WRITE support, support WRITE ATOMIC(16) (def=1)");
 MODULE_PARM_DESC(lowest_aligned, "lowest aligned lba (def=0)");
 MODULE_PARM_DESC(lun_format, "LUN format: 0->peripheral (def); 1 --> flat address method");
 MODULE_PARM_DESC(max_luns, "number of LUNs per target to simulate(def=1)");
@@ -6260,6 +6575,11 @@ MODULE_PARM_DESC(unmap_alignment, "lowest aligned thin provisioning lba (def=0)"
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
@@ -7406,6 +7726,7 @@ static int __init scsi_debug_init(void)
 			return -EINVAL;
 		}
 	}
+
 	xa_init_flags(per_store_ap, XA_FLAGS_ALLOC | XA_FLAGS_LOCK_IRQ);
 	if (want_store) {
 		idx = sdebug_add_store();
@@ -7613,7 +7934,9 @@ static int sdebug_add_store(void)
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


