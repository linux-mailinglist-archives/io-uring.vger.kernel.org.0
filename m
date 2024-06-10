Return-Path: <io-uring+bounces-2152-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F616901FC0
	for <lists+io-uring@lfdr.de>; Mon, 10 Jun 2024 12:48:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F39DA280DF7
	for <lists+io-uring@lfdr.de>; Mon, 10 Jun 2024 10:48:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1805213210E;
	Mon, 10 Jun 2024 10:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UV+BZ6b5";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="bgx3YNnp"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BF0680C16;
	Mon, 10 Jun 2024 10:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718016290; cv=fail; b=W+TnNM/jSuc+sounOFEtoeDvMM14wuWLZeUv5KCPgAiyWk9lVj+S6X9Ntdgf8h067jpNwbJ876TUm8jmorep5eTDmZ2E7gkshOnvcaBTfWzs3N3odz95ht24zmLGAqApjqbW5NqHGsaB4J/4wJL6zMD3fAqUWK2vXrFvFWv5j2I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718016290; c=relaxed/simple;
	bh=sYzv2/7CLjhTxrPCvjggytRPAhhChubeQp/fn06W5vk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=BQvwagxnPdDBXQEd+MJ/da9+Ha7W4UR+oLeZHADnSMjCIpOjhNZBgX52b7O+n1jTjDQRv4PxvmNM7vtOfxsdgGw/l6A1PrfMEAubHJLYo2/i0ztaW0epEKWla89c+VEYrkd28AEDshera4aBk1nvd877MvJKrbh9YX5Tly5ntpc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=UV+BZ6b5; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=bgx3YNnp; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45A4DB7f027821;
	Mon, 10 Jun 2024 10:43:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=shf0PkL9/9+tX8AihW0X6p7w8J03sVGQV65DSX6gEZI=; b=
	UV+BZ6b561LrbwDz7KwslczJFYoGkd6cCY4Be7mzhLatmOhoic7Sxj8aD5A0GJcS
	GKO0sfAJR78l6C1Lrl0GVUcTtOCdWNNEeViM1tlpotsXZT2WlqKjT54yf6JdVYy7
	JfedoZ97ALf0s3aZuuKFwZOvtQabm2weUsLOjKGo/3F7Z/e5D1EV+zK3YTGDgNa4
	Q9iaJtr9JXM6/ljlcsdgwMHD3Ux+CKAMeVxY/bHztzemk+W3yABeBUl+u/sfkacc
	bQlEfZ1ZhuH1oRh0WuQBsIaT+jhMFVNpFMRvV2SSJwdmsuZ8sSxhsq7pWmbgmX50
	Sfm4GcW2ErMZnj0NMGfFQQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ymh1gaag3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Jun 2024 10:43:54 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 45AA37Ov020460;
	Mon, 10 Jun 2024 10:43:53 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3yncasued1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Jun 2024 10:43:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lfi7tUASTmU4EjSjKE77jdCIVbHYVpZcZfnvrY+qu8m4YObdSJyq9a2tm9RlZLU6O3rs+QYodpms1AfTy+OjrqX/KP0lVBGC0etA4vkcNBc+ZCh9B4NFwCyDXxsYEhkiubzraeCNNkhICBOYZRtq4B3piUHc5lnNVXkqqCAQ9RRn11VSLp6e0tF6ebLvbUomzI3Ag1R25yQwKECsyw1Tb/kysZf0I5CI8rsZktFmVNaUaNdymtUqA2qJRSnqIoWsLEnkfQj+noz0giAPNnJ7qDupg2j9D5Z/cHTa2vj6VyU4gSFV/tZ+0kKPbFJMJMrm7fUm6oLU/5B/TH8IiuA1jQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=shf0PkL9/9+tX8AihW0X6p7w8J03sVGQV65DSX6gEZI=;
 b=kNe0sUkNVrF2EfsS+R8FasdJyEURNbpSz5imSF1tAmsbo41n1aDzayWrL8rk8xVM+XTKLGCrQblnhOJlDJPA+ZJBpWSPsu6IdKMA98ILL+FO+7FUPeDs3Ruo9GCAHWDji0Te33fhQjAJQsuCgnVbaouC1kbLTHTAHZnlFw1uvnECBV2oXNzJlYYqQ6Cs3WviiVz6UNE7yiwAbDMEzmn1p9etYnGv6P3N7vzoRxM9n30VS5J/ZMxC3Dm3XsbJ5e1SNDTPgdvF3giCESgBSUImjR8tMiqabB90bZAuEvWruAXgYhUoLkJ8DLyAfc+FxjB3XG4B+AAeo/GNXkZSfedHqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=shf0PkL9/9+tX8AihW0X6p7w8J03sVGQV65DSX6gEZI=;
 b=bgx3YNnpK3q22vPje56hzHlCBPwWefAdC4fBq9ic/A6nhk9IN2Ut0/4KrV0ia9ht88M6cmpbfhn5LkPmfM2jW4WnVeBi/p2Naib5qMf3ultGX7067rJ8Mk0NBoczqDyXldbsfDo1DDwzAOzm2Fk+3J0YaUiUy70Ay8h+HatsrJE=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SJ0PR10MB5613.namprd10.prod.outlook.com (2603:10b6:a03:3d0::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.31; Mon, 10 Jun
 2024 10:43:51 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%6]) with mapi id 15.20.7633.036; Mon, 10 Jun 2024
 10:43:51 +0000
From: John Garry <john.g.garry@oracle.com>
To: axboe@kernel.dk, kbusch@kernel.org, hch@lst.de, sagi@grimberg.me,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        viro@zeniv.linux.org.uk, brauner@kernel.org, dchinner@redhat.com,
        jack@suse.cz
Cc: djwong@kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-fsdevel@vger.kernel.org, tytso@mit.edu, jbongio@google.com,
        linux-scsi@vger.kernel.org, ojaswin@linux.ibm.com, linux-aio@kvack.org,
        linux-btrfs@vger.kernel.org, io-uring@vger.kernel.org,
        nilay@linux.ibm.com, ritesh.list@gmail.com, willy@infradead.org,
        agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com,
        dm-devel@lists.linux.dev, hare@suse.de,
        John Garry <john.g.garry@oracle.com>,
        Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH v8 01/10] block: Pass blk_queue_get_max_sectors() a request pointer
Date: Mon, 10 Jun 2024 10:43:20 +0000
Message-Id: <20240610104329.3555488-2-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240610104329.3555488-1-john.g.garry@oracle.com>
References: <20240610104329.3555488-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR13CA0029.namprd13.prod.outlook.com
 (2603:10b6:208:160::42) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SJ0PR10MB5613:EE_
X-MS-Office365-Filtering-Correlation-Id: 0bbe35ae-5e2c-4dbc-1334-08dc893a3754
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: 
	BCL:0;ARA:13230031|7416005|376005|1800799015|366007|921011;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?pQhNsuAng96+4HS86xsnN07WI2deWkfqqv6VJ05JKg3bI5p0c58rS/oqLAau?=
 =?us-ascii?Q?jMgmUz2F6q6/Q2PPfpf5Qh8DGkOyD3gTcB/U8gHXGuVNSuaWhNlu9cT5lz36?=
 =?us-ascii?Q?YUkRC4RPfEgHlRiH1R5jw35tX+TgO7qpFye6vNIZqs1OUjWx0PBgqbaUFKcm?=
 =?us-ascii?Q?lKWoTb+YrseCqR4gotsXYqMpbgXTR47iPZs9PTG3MuDdJnmEauW4p6p9ZUR2?=
 =?us-ascii?Q?TAHdp6B4zhVX/ZelumNWtj4WoZqNgvNv3v4bQzXPEOPEJNhznWSiTDt5ZdDC?=
 =?us-ascii?Q?9wcu0M7UeX+jczHuApQmy/ZUUhhZcOnsLfA4d6EoR/VTOJFZXCeHMrEpzI2c?=
 =?us-ascii?Q?sBH/r/8kwnMlQhZj9hD5j9FkSJJvpcEO7yMBcX1zNZXB5ObpRuHoiT5PI9J1?=
 =?us-ascii?Q?U6oeYQevZ3lC/3fLKzP6V+cZwe8HOlngmBNXQ+T2ege0Kf1Zmfoze2bpLYjJ?=
 =?us-ascii?Q?ip/UgmFuVQ/bFGAMh1ywnhINiQdZ2kKn+XcbvuLziIeo+kEdi/ty9UZ+90Ff?=
 =?us-ascii?Q?oW0zLWJvkIVIHayzj+h0Bug/lJq4QNP96riFcEPYkPrfFGRlxoUygQaZtO1v?=
 =?us-ascii?Q?xNyvp+wyDWcpS+KtwH96CHMc9OivTpS5w559qqOT4kTbXPzoTnHRW3VKCVBx?=
 =?us-ascii?Q?8GwPUwM/s8HX0tU3Idw7sPeDkviOrY2aeyNmnIH6YKBJki04ugJmrGr8pxzv?=
 =?us-ascii?Q?ZsMsDIqdoHYeTVLfrNtxcn0cB5b6Dkh3BKYiE8pnqycQF1YjPsZLIjQJXLUH?=
 =?us-ascii?Q?xwo3cSwtvLSxDILNx+lr0n6CRBBOCZkS5zEfz3k5FW5f3iuxXrEUvj5lLj9u?=
 =?us-ascii?Q?xmbIbQ/IvafucL7+pAevj7ZjxqZ1OtCG59lSaTrarsh0+Hlc2pNe9Rftg+f7?=
 =?us-ascii?Q?x+k5tMi8iiBBKZYGy6ttTBxAqbFgy8pLN8nqI582eRx+3Yfmf27npw1YPSrw?=
 =?us-ascii?Q?ohT6gcku2NEoq2Y/0C5GgFnYMG/olHZWzQ2SmdpVVvWR94Voa6I90HZBEizF?=
 =?us-ascii?Q?HK/hGclKUaQa6yU37vmjH29f3nVtlw5yqkypKP2UICJQcxRqbCF9uxQt+h93?=
 =?us-ascii?Q?iCKf4tP8i/gyLKRFN2XjLNCKnwZZdAKhMe7FYVx3q30KhGsWIeuu4Mlvd5vA?=
 =?us-ascii?Q?w169R6qg3GSXvMbrR1aFHiM6pwjR3SppXMEfoEaYQdgSeMZuqk0mvb/7d5Ef?=
 =?us-ascii?Q?1A/mIRMr2XxeaQjbflbvJ2oETW7kr3/YyXsDsNLQ4RMidvnDhY+xNZhGbePH?=
 =?us-ascii?Q?9qvMAQM6J1nOg/eYmTRGoOGWGyZhJ731d9OpCxHsh99CJvaT2TX3tw3iwSvo?=
 =?us-ascii?Q?tJzB+30B1QWnU1Od/2z8pEI3Vy5MXxHzhKSpPW0l50/keihLTa+HAywJOpL3?=
 =?us-ascii?Q?GXwsL6Q=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(376005)(1800799015)(366007)(921011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?+jSrd3OD/vSVZeS1NONC7L9B/bd/EqSiGxOeKU1TED4ZvshFMCJ3XBe0ND8M?=
 =?us-ascii?Q?q1oQ2JorEiUeieJb//u5+Zrlt1vCUVZtim6mQzxw0W8WuRH7hnn8GJ85jVpJ?=
 =?us-ascii?Q?1h52SIfgFurqNp9VbFSF3u2rPK129juQNrk8GlFnQsT8YyLqHNFwxYY7hozg?=
 =?us-ascii?Q?cfOamAL60O3MecPquJ+qMacFGiN8lR+K1bLUpyf7GrPjcqtsNeJYk3HNb/ds?=
 =?us-ascii?Q?LllBoD0s+okZW5QX4aQJ8Xe/5wKHKJBHdV9aIXqd1mcQKlpEDam7+moNkkZJ?=
 =?us-ascii?Q?nIsdIaFwsJ2PoOSWVayhLLd+F3x0DI4tiTtVAKIIzu+APlxAj4ftJnMsKkPi?=
 =?us-ascii?Q?SEdNcVEA89pUUkD4TMSMWwLuJjYCw+6pLoX7x/MbelHkMz9vHiSEecKekA+q?=
 =?us-ascii?Q?TMuFlDZFkl4ZbJGK9WRoG54V/AeOtGQ0cP2SvJjCd7MKbhCoDC6QSKJCkwYs?=
 =?us-ascii?Q?NuEEC6HoYko30VUiFWnQ2qeYHIzlnzTwFtD5HLcKtCeCLxJY7Ss6PBnIKwrq?=
 =?us-ascii?Q?XUnVZSKPVd6x+CldDJb+Bg1toJuUJjWAlEe39iHi/Sg09brtlhgA1YrKRDGu?=
 =?us-ascii?Q?oD4LkNBqAzKIzmKovLwQrbZ4QPq4cDpK/QwmFDnv837DmUZxtqwrVnvdW9Nq?=
 =?us-ascii?Q?SrEwI002sct5gxD6GeA6U/cpE7uu3Us2stQPSFNOXYvXWk8k3OYjtDvblyyJ?=
 =?us-ascii?Q?tXiJZ6NhpnuEsqsvoDYhuUZet3iNnbrL3QLE8J6m1o48h2dPqyIwCShlUZ1U?=
 =?us-ascii?Q?pTvKlusqFC137uG7xujpr/rTNyVDSANrvs2Vi8wm+6BkD+14oQ+VnmmNuLu0?=
 =?us-ascii?Q?BLR6u0bDkZZ+xgS0CiDA16WQ9qHFhj+Z9dfLWfic5flQlrEfeO0vYD/CgDkG?=
 =?us-ascii?Q?K8M44WLQrrCjCzE+u6NVYIzTTQmuPN5XU1wv8BOEZ9hYYl6Ur+/HMG/PAtE+?=
 =?us-ascii?Q?WeGrDRFW2IjEoJIoFKho3BdzGz96IGcGNaJiXR1HZT1l0TzhQW/AjSmpFDsS?=
 =?us-ascii?Q?E/xOqeU40GYLoFuR7RikgzWCt9Vv/SODAV26P2qrIB8qkkB/pKRoIWwlZsfa?=
 =?us-ascii?Q?DHpqI8qOBGifqyplXRfM8w8U5qt2WAy0MZIt52LEnHUI9aNWimQBPBAiv60D?=
 =?us-ascii?Q?obMV71Ft9F6ARPmJOaOyb5AeGT7UvmF11FvMEiuS1rQs1DNfdMevZDlRFB5A?=
 =?us-ascii?Q?fBN1c5OC1z0ZYnzszPdp13ZtAFa8hGpz2x9lKc1Hfv0eHOb+byk53lOBo1Pz?=
 =?us-ascii?Q?AOwBeIGmy9OX+/GQ6Ns66nHHDVdjpRIodGS1parbcjzKf7h9QG7ox/SWytTV?=
 =?us-ascii?Q?Ddllw/3XrgS6R6eDAAxB3BAAVnliSg2Vjg5mynMyW8YcqylCa5r6zttDBN6F?=
 =?us-ascii?Q?TI4sW36L9k8K116BCtkom1rTJJ8AwzFnuXfPPzkR5xWqR0uu49nKLik2yAca?=
 =?us-ascii?Q?cPjyZ35NNCyr+m07W0JHPcel9ubJeU6LsOdGLCGixbjpUrVD8QyMHq5JGDSG?=
 =?us-ascii?Q?8O1ZejeOt0bQr5fMwaOcMjlAc1y4ujW1c5Ufx8JZXmCkZa3GvdST1nieqk+L?=
 =?us-ascii?Q?wac/Zsy2YjdGvt5YcpisgSh6bsnflDcslIm0uzWsyX/l8rv0XOF6Gu7uq8fs?=
 =?us-ascii?Q?Vw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	mWJWtGi3gWUC0pTdXm8IGR9jxhss26kawMDgfjuKnwAhho53r70WRDLgF81UqrfoUg5t8rVDXatH4U3ar7hLkgSGizlguCmHTOBBHTr74BeKfRh/fXWrS2gmUMhlgH2VWDUywkt5aS0NP/XcIJc1qqI3GWFVfcpan4c8sWHYfmTz+eUdI1RmoSLwJTy+zIL+EGMFonY6PQ9e/MO9efK2QVIaFYwfanEwiBJaVnBDmWjBGIH+5KlNQuwur3YtyO2Krq6D++d37EA/ll3fW4ynuLA1ulCU3R0sDLoZA3zK76UjrUkX+nCkw50JAqEvehaJDJkO++UbSwnQhkEd+3PAFmJ0GmM52fNlw57IR11R3tomPOEw5O9p1Dg9qrXPBbykgoLZhwDtPgl5gJgnwpVNeolWUWGn1c2oP9zBETMqPItftWu5JewtV+5fNMBkzLrLj5AerPsoMwrIIxErf20vsPix7MCWtlKFR3G6X5DY5bnhMNh9j90powGw7tBepYxtFyRX72rpWX52LOpol+kjyUsgQ2lUik1bXFRuifW7gqyiWHXExx1LPQ7KtirlR8JD91t/FPm3pFhATkZk0NJactFpaRUpzfih01q5lgN+iIM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0bbe35ae-5e2c-4dbc-1334-08dc893a3754
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2024 10:43:50.9891
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Qv11rfI0mLceuCMLaJSrbih2LIWx2jvjMdjo2WrSODQJ44OmICSU5f0ITh+8h/JVJQfFdVhGH2pbeahK25JLiw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5613
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-10_02,2024-06-10_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 malwarescore=0 spamscore=0 mlxscore=0 phishscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2406100081
X-Proofpoint-ORIG-GUID: SBTNCTweqM2gZC7gfSrOi-7aV67-YFpJ
X-Proofpoint-GUID: SBTNCTweqM2gZC7gfSrOi-7aV67-YFpJ

Currently blk_queue_get_max_sectors() is passed a enum req_op. In future
the value returned from blk_queue_get_max_sectors() may depend on certain
request flags, so pass a request pointer.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 block/blk-merge.c | 3 ++-
 block/blk-mq.c    | 2 +-
 block/blk.h       | 6 ++++--
 3 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/block/blk-merge.c b/block/blk-merge.c
index 8534c35e0497..8957e08e020c 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -593,7 +593,8 @@ static inline unsigned int blk_rq_get_max_sectors(struct request *rq,
 	if (blk_rq_is_passthrough(rq))
 		return q->limits.max_hw_sectors;
 
-	max_sectors = blk_queue_get_max_sectors(q, req_op(rq));
+	max_sectors = blk_queue_get_max_sectors(rq);
+
 	if (!q->limits.chunk_sectors ||
 	    req_op(rq) == REQ_OP_DISCARD ||
 	    req_op(rq) == REQ_OP_SECURE_ERASE)
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 3b4df8e5ac9e..e690b9c6afb7 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3041,7 +3041,7 @@ void blk_mq_submit_bio(struct bio *bio)
 blk_status_t blk_insert_cloned_request(struct request *rq)
 {
 	struct request_queue *q = rq->q;
-	unsigned int max_sectors = blk_queue_get_max_sectors(q, req_op(rq));
+	unsigned int max_sectors = blk_queue_get_max_sectors(rq);
 	unsigned int max_segments = blk_rq_get_max_segments(rq);
 	blk_status_t ret;
 
diff --git a/block/blk.h b/block/blk.h
index 189bc25beb50..75c1683fc320 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -181,9 +181,11 @@ static inline unsigned int blk_rq_get_max_segments(struct request *rq)
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


