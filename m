Return-Path: <io-uring+bounces-1222-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6593488C3B4
	for <lists+io-uring@lfdr.de>; Tue, 26 Mar 2024 14:41:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E43142E5DBA
	for <lists+io-uring@lfdr.de>; Tue, 26 Mar 2024 13:40:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C48775807;
	Tue, 26 Mar 2024 13:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="J9Duf6aO";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="OcUm1El4"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3E1381ADD;
	Tue, 26 Mar 2024 13:39:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711460394; cv=fail; b=N/lu6q7+3OWc2+ilkavtavBudGndXWIZcNLLMOiywjrdNVBJP/ARUmvw/4gYpAw2G9XRN9o2OZz7xz+H7yXFElRMRU7v77se7AnRmOD5XGTHd6ARYB1euPnQhuTMqA6IZ59ncQ16RF3Bz44UF2u4AWWA3lu1IZeHlfFWhPkbzIg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711460394; c=relaxed/simple;
	bh=jZu2x9dq4gx1tNyj0bQAAyplntekELCBatKU52MN8X4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=A+v/pCwjbgTE1nQmPY0GwxFpM0ue4Q9GSfydoBkLV8GS0VLCh9WtBEQjMBX9PqmZy9hQuej3H/M2+t2fPLqN2gjosT703Kf/OfD2qJvt2Gydb5KrUdZLHDrObtpawZLADwVPB0oGk4OlLczjPzZkxBNGTnLv4N/ovmumrUbjWmI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=J9Duf6aO; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=OcUm1El4; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42QBnhdS020657;
	Tue, 26 Mar 2024 13:39:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-11-20; bh=J/TUfMjb+2DjOF3xWM5G/RwHma3NQe/UvvJbfwLYN3c=;
 b=J9Duf6aOnjM/z1XmsjIitRCpTsVh8a+kXfErWEEokxdf4Djh+lNVndEc90hZt3OV4FmT
 pYbewvqm+UJqfELlG91huJvNpz4cAUmkXMRLe9yNlbi1W2RdEIKqd6A0KTk6UDssXgum
 ZVrflxxVXl57AsGH1pOaz1cguQbnRrRt+u4FZkJfp5TpDt1WX7/AA2CPh7e9aOInvHiN
 aVVmHS2YV0Q+lvoE2wjpb8nDvHGMeGV83/DJ2kHrBkng3JbhsTQCS7WZnnYpdWwwO/M/
 BYJVIXLoL/36S+jGhGlZnFtGaUI+xukvG3zLhLcX/X2jFw+7dc3YBcKegmon3h3srTfO 8g== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3x1np2d1u1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 26 Mar 2024 13:39:14 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 42QCMUKt017835;
	Tue, 26 Mar 2024 13:39:13 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2101.outbound.protection.outlook.com [104.47.70.101])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3x1nh77wku-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 26 Mar 2024 13:39:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h6cT4/bjUGNmTzxwH/rNouJBQRsgXh9QPk/OOvpCgoe0Duslp8p7oCbBhNt4vEVGMuz+OtDjwgzDjoNVRICrVo7IqvqWkEidy8mEsCdFSo3BLldKGbyWtRbcxSrMQxoBg8H6vau1oNrv9Oe+jShOAX+/15e3X294PEwlva2uIM9iRkItrUePnm9pBTlMI5EMYqY64bf60pa7ZR/Y2KDjY4OZ/Z7KBaf+sTAxoh93fFTH4N2Xkt3X9mO1jtOJEvMS+S7NTrxhT4r4EHz63SBvBRRZIsjIu6jTrCvjF1sHBuipAtYo3OzF10HdoR+gubK6d3gG+zEQJb/s3nVmwfJKoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J/TUfMjb+2DjOF3xWM5G/RwHma3NQe/UvvJbfwLYN3c=;
 b=iroSNQtdbVKa2OKXcOMWlxTDzoE/jsoXsvcVZfRA00CHb1neqbbnfEyt1BmwIwggfdcj4N9LrTFw++PD/A+20UYYa8nzOxuV6jl4IydIG95HqQyMZOHj2gyBZC062m8aNmwRphUuoJxmwV9mOE8L5HX6lwBGRRZkM36kMwuGLFfla/ClK/fCad1biUvPcvvreJ7eZCIJAcfF20FUQbrEGPGHzRLtHeutYXhpKiW2ov/aTEh6djRDj8kEcb8Qqpr48DgeF2e4vcGn75+OUi0cZnSQRqFoXtkLqtD4OLdi2KaWuYI3cMxFpPTeJo9GYiNO8cuD5xIISSHFopqEQsjYhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J/TUfMjb+2DjOF3xWM5G/RwHma3NQe/UvvJbfwLYN3c=;
 b=OcUm1El4nQIkdQ6jDmziwNr+Cbm50U2+wIHiVTP+10AXXTEMGKq0UFEOgSXXUJjRyKdgqG2D2fsmGZyj6q7/Hyjii0ogElKtFbvnRho1/cdpzEEFsUiq4/Gz90jKW898zB9WGhjvfTh/zxCS17nOoGdjfV2P/13ozCMeLZdNnus=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SN7PR10MB6666.namprd10.prod.outlook.com (2603:10b6:806:298::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.33; Tue, 26 Mar
 2024 13:39:10 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ae68:7d51:133f:324]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ae68:7d51:133f:324%4]) with mapi id 15.20.7409.031; Tue, 26 Mar 2024
 13:39:10 +0000
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
Subject: [PATCH v6 02/10] block: Call blkdev_dio_unaligned() from blkdev_direct_IO()
Date: Tue, 26 Mar 2024 13:38:05 +0000
Message-Id: <20240326133813.3224593-3-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240326133813.3224593-1-john.g.garry@oracle.com>
References: <20240326133813.3224593-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO0P123CA0003.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:354::11) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SN7PR10MB6666:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	zkKX3Wr5fBPL2tMvIDauoQnAEBuDGtCqIh+WDz4eAbEmJxFYFl6myrDn76LK4/XtZXwRwMHm0v0ITCsUMvbonwFO0pF2oOrb6wQx6DNLDd+5Iyxd4ECWWukF4mZedB2OS21eNa8ZKMvgofetVGpJ7ih8Sx28nCQkdCQCFyOfrTJotG7h0xogp6oswW/ZzktqyuywHp1qlWAb9bZ+RclXDQ66opqPE+NberBZymbewbvB/plYHPWASTjXGdeRd5+8KIagzZ+AeILbxeBmIblAGCCnUFy5AsLCWYHy/o1nOnMcjTRhxxzvJf6zWjkeMeG4NmGAUqxHKsQmp5wsMnWvWOtcqCl9oPt8HT649nstTgwKu+UpaZSYv57LUfIB2GyNtqTKmtiXUOqKo69MCUFIf1pIGmIJSH0Ah2iekABZgEABKDWwZGvZInYMoWyHGJGQzagrjWXg4VVbIAcUtYD9mnnEn9RI0NVQHcLQsHqmGB6KSuNVMFrS5WS5V6iulkw7/O6GtCJasKm4ezsK8nhew6L6IS6ZBo7vk+b+Jm64WVhdXANpsBwELqkQc83PlJIb4SgvXPuD7yFAjkVcG4/NZvS0RSSzhORp/kcvFqu9NoV1JkK2DVEhnrr3Kpw0GdCvgILMFZKAA8O3VOdGkv9xImnhOKAgBp2EufUupDRfOB7WFntN+5B7ktAH0yrv5YcHcQEPQYvUmu5AVimnunmDfg==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015)(7416005)(921011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?d3MqOsj5kf2E7vPND72IicNtot2LZrrX4fHQkFKU2fkGx8ni7pLQqs4jLYsk?=
 =?us-ascii?Q?IX0+ipcJ1vGIrhvkqgbmeLYAoH59EOWIyJwe7g8+FGB3T2W7/dGOO/CX730j?=
 =?us-ascii?Q?GEonHCFaRF3LZI7zuRvlikwFFvDtbEScdqmVrYzSNndO2fEtDy9dmz6UdHlh?=
 =?us-ascii?Q?pla/h4ifjZsHJOyujmmDAjwjkAfdO2zBBgy3cWdtGBXXpYDRJluxvgNS+R9O?=
 =?us-ascii?Q?Err/xxnt3SLvg4SoyaZenUhWa4OyBjca3kOBFRuISOW/qgVOazszViD7iA6W?=
 =?us-ascii?Q?84JU3rOikPKbHBam5puRQbu3//LP7sRDFgNWx1OlaJk7tBVzEsuPZEzLjRqh?=
 =?us-ascii?Q?97cFN+wtw2HS3TLyQgoksCnZxgsgtFiCyGpQ2/lOywgVi02daF/UwXATtNfE?=
 =?us-ascii?Q?8HxfBvrzt6cqxChmZzSn9LewBBiijRXBv2yPIp8OBunfDf7dDULcQHdU4SOa?=
 =?us-ascii?Q?gQJLurLSfS6318vga0UhLYbnE0NBeAyYWjZ2pD1TDsmI1w7ZrquZToBgRqK2?=
 =?us-ascii?Q?gzlijQI6TySL/xpymoG0EN53P7+bRqIYbIT3tqZTPsZJwsDTqEwucP4Rfy2V?=
 =?us-ascii?Q?5xmsRZ4No+RTeVcGfPxOifqa4hjVIQSUi14Ra9Dcb6phUreV8vXfE6xA0Zqc?=
 =?us-ascii?Q?IfnXEPezDYiE0CFNPPuVTLkecDIzkWgkfApD7snNhC36AyiKQiFaf3ux5OY9?=
 =?us-ascii?Q?aRoAzal/7bvZV3y1g65oCqX7cnEdDBHwvdjpF1zXp3RjG8KQtr7aQmjOEqsn?=
 =?us-ascii?Q?H5c87f6OG1GWfkwyNhrJjz7LH2+26A66P51AYLCMVF9v5ADuyE4ARS4phu/o?=
 =?us-ascii?Q?kS68b3NEfZ1q+c9kh9COpJiKSZ8tCvWFsvK5iQ8EaGqDIrAOAxEnaWmMd9Ri?=
 =?us-ascii?Q?tHkKhpcwmKznYQVXdy5cSw/osLYMpztKK0+4PvBLUAitdLO/duVGKvX2SEwd?=
 =?us-ascii?Q?Sq8q0LcKfxkHUBhXFwYVS/pZeEj70RT+V8R1S7ZjgATLTjlruxndEQjXk0v7?=
 =?us-ascii?Q?LBLjePgpTvr9cTGWihKSZ0ohL0Zsl1VPvXAsLNoM1VhiyFBl/qqZADGz0/2r?=
 =?us-ascii?Q?El4l3gkGZ/TWIiTk//tpoWga/RxidbfXPnxOnUGO0+ZuwZAGDeRtK+owaSoy?=
 =?us-ascii?Q?P+qwrWi5Pvb73O8dvuaIlAKbmZ70YMHNkeWCXJ+LIwBK5F/FAmmcq3KmUB/E?=
 =?us-ascii?Q?CvQnyYijHACbclmwDeY0wL2GxUpSI5ktfdQVd8J2/0YQFIAKdNggyQqLFKZS?=
 =?us-ascii?Q?qwXVCKw9mPixlOUx+IATeZpFKlo2TOqxhAHl0tA5b29/ZOA2Ljbh86FOc/Bq?=
 =?us-ascii?Q?EB2OymZw0RbB1du0HX7zGoPPMjt0s0pDH83KwkyxbdnonUFAEsc8p8JRaGL2?=
 =?us-ascii?Q?rbgilqf4xn7OVV7WxqLVZD1iH1c776pBEmbNZrTr3ZyFFe9f4PUemVqK+ub5?=
 =?us-ascii?Q?oDUbhh8TK3vjY00no8bI/qJX0SSlhls75d4tn40+0K7WxRxr2r0z3qVT/9SW?=
 =?us-ascii?Q?faHHCAL5cMdFVbvtzpeZPmfCXfiignUYtZgEpeQhIS75IB/qusquegosqCW8?=
 =?us-ascii?Q?0ilQ7fGjE61nx6xNida0qli+wU14Zz/xlj0AKTPEtvQqNe5jnc2+KJguatzF?=
 =?us-ascii?Q?qg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	+E/UQAa8L8gM/I4N1optlIghwUZ+EpDKnXCReZRAaSMCK3ybbNnfS1zCm3dUftY3D8tdzH9TsEP59QtjrMGS5Yx50ETk44tigbbG6iag0G5Vgw/Sy+tOujnKF3GpZwFru7BGWXTG6d1B0kqasFSZfrWSxY4NnUTAQyBJa+4vx3ORgaf8TAUoGRUt5U/UUEsBGltl6fqBRAGkVfmdjgu0Qas6cscdkTKZqgiSpGndsget1uL+l8JmP1YiaWOtrgel2RR7pySIXz6DXpXcxYReVxgV16AGmjkKZ1MDPOhAvjOQiGYKQQ0+9IuakoM3rlz9wP1pU0VU/GKzYuUgjULX2yNbV+kFUUx+AHQ8lfhqNMheFVR4nucDCVdQTVExPItFSMPfTgEM3LwJXZZ0AHM0zv3qho/yEG13lHKUQwaV2A6c8C188YW7wuhFuQsZmuIo8JsEqqTNVC9qEVqM95nqyd1oxsbL7fVqJhi5Pjvn3WOFGWYkMRb2j7UmXnd2AgzcYWY8gns56sGfUaQNYzHNJ3eT/WiPOmLu4xUTtkfqdaLS5orMfJGAqp1FW/e+qb/NMoOEiF77nPW4h3RiyVhE0GvJApVcMCAIkhwUYEuLn8A=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fddac6ce-7ccd-42fb-a288-08dc4d9a1dc3
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2024 13:39:10.1283
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wTug9TCEiai1OH+CTI0kSK3Tj0VK4+8HjEP2v0bbkyNlzqMM0JDoq8+cS12aCXqbgFgKXD+WcF0Ymj7SpCgKDg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6666
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-26_06,2024-03-21_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 mlxscore=0 adultscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2403210000 definitions=main-2403260095
X-Proofpoint-GUID: fD-Lx_yZaoTbg0m8CmJRz6KPv2ZEv8nO
X-Proofpoint-ORIG-GUID: fD-Lx_yZaoTbg0m8CmJRz6KPv2ZEv8nO

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
index 679d9b752fe8..c091ea43bca3 100644
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
@@ -161,9 +158,8 @@ static void blkdev_bio_end_io(struct bio *bio)
 }
 
 static ssize_t __blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter,
-		unsigned int nr_pages)
+		struct block_device *bdev, unsigned int nr_pages)
 {
-	struct block_device *bdev = I_BDEV(iocb->ki_filp->f_mapping->host);
 	struct blk_plug plug;
 	struct blkdev_dio *dio;
 	struct bio *bio;
@@ -172,9 +168,6 @@ static ssize_t __blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter,
 	loff_t pos = iocb->ki_pos;
 	int ret = 0;
 
-	if (blkdev_dio_unaligned(bdev, pos, iter))
-		return -EINVAL;
-
 	if (iocb->ki_flags & IOCB_ALLOC_CACHE)
 		opf |= REQ_ALLOC_CACHE;
 	bio = bio_alloc_bioset(bdev, nr_pages, opf, GFP_KERNEL,
@@ -302,9 +295,9 @@ static void blkdev_bio_end_io_async(struct bio *bio)
 
 static ssize_t __blkdev_direct_IO_async(struct kiocb *iocb,
 					struct iov_iter *iter,
+					struct block_device *bdev,
 					unsigned int nr_pages)
 {
-	struct block_device *bdev = I_BDEV(iocb->ki_filp->f_mapping->host);
 	bool is_read = iov_iter_rw(iter) == READ;
 	blk_opf_t opf = is_read ? REQ_OP_READ : dio_bio_write_op(iocb);
 	struct blkdev_dio *dio;
@@ -312,9 +305,6 @@ static ssize_t __blkdev_direct_IO_async(struct kiocb *iocb,
 	loff_t pos = iocb->ki_pos;
 	int ret = 0;
 
-	if (blkdev_dio_unaligned(bdev, pos, iter))
-		return -EINVAL;
-
 	if (iocb->ki_flags & IOCB_ALLOC_CACHE)
 		opf |= REQ_ALLOC_CACHE;
 	bio = bio_alloc_bioset(bdev, nr_pages, opf, GFP_KERNEL,
@@ -368,18 +358,23 @@ static ssize_t __blkdev_direct_IO_async(struct kiocb *iocb,
 
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


