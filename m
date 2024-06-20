Return-Path: <io-uring+bounces-2289-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A9ABA9104AF
	for <lists+io-uring@lfdr.de>; Thu, 20 Jun 2024 14:55:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 378151F23EDD
	for <lists+io-uring@lfdr.de>; Thu, 20 Jun 2024 12:55:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF4CF1AD41C;
	Thu, 20 Jun 2024 12:55:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CAXxfhPj";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="M/dq4gTM"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 359FD1ACE9B;
	Thu, 20 Jun 2024 12:55:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718888103; cv=fail; b=CLPmAPVBt+BRWCkgUy0GDvD/GcwhovEA6RNPNcGvpmP1mM8+QJXE0trOxU2YKMF+jASZhpIuKsgEsQFgM3x1a+s3Oq/lMeJjRwNfH+9EE1zNQ1WMb49VBFZ4ZCr50nEeivKgLRRIL2FRgaiH6KHUxGONYOczgI5pizz0hmDagxI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718888103; c=relaxed/simple;
	bh=60dMqvzOApVi5JKuVDRuSxfef4xdEAXizRRSE3oooZs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=bkx+MN+UIzQmLJeQdDc61mbfEHTlXWhr0HEsDsmIiI5qWE9qThNOJEz/hAM2uqk7jiuLqy9cGcvF4WQRLTai5s/BZAC9m+u3r3NP+PB3oXNZjShytzsHlof4dJoLBfE13g/rKiqvf4nAf7tpH+Fhz/sJfZKc7frsfqrvGz1gbFk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=CAXxfhPj; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=M/dq4gTM; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45K5FGqf004954;
	Thu, 20 Jun 2024 12:54:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=AIIb9rF3V3HBQIgW17CjTt0sui879UkFkIeDM++OUNY=; b=
	CAXxfhPjm4vnwr/h0cmQAQACnhwPJhhSEb6+ojEwHu+4Qt8tT0cazyuunMhKCNgo
	WgfoZJSSforWI+QSVxYKKaVvHaTNmLNFEvpNBaqLXquMbTAULce4PhLdwpMRJNe/
	tRylMWlLk8YWOjOwNHAzOZp3Kks81M7JbKroHwwPp5gsy7f2F0AWz/r5ufqNScij
	1XrAjMtPFj5GAxmxBjT2ZH0kkoor6+B84BkXLIdmbtHqnzRdgSXr9N9cMHE9DUms
	EBs2716slIp+HzOLB97MStnonPJ4FRP88+N6G/t3YFpUUp6cgZEVribdxsDGy1OW
	7UWpw3buOT+YCu/ifhuCYA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3yuj9ju2uq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Jun 2024 12:54:31 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 45KCUOi2034795;
	Thu, 20 Jun 2024 12:54:30 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2041.outbound.protection.outlook.com [104.47.56.41])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ys1dap437-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Jun 2024 12:54:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lwm5teYBOd1fKhN5Jz5Vel77PZFiUVdt9I7Po+SKEZexYRedsXgaZ5QuCF9zItbratT+xCQnieCJqm2OA/2KRmqUQEdQanKeT6oiB9kbr52gbDwBJyebTY/duHsnfsOdFInrGOkSyW8K30OEX5ruTJ7fhjLLlYu83/y12hyOh93jX2fxW/P+YP4YhK9aWA00Ggr81vCV6rG7bmcD9YxDiiVhFLlDpHfmvYQHvb4vLdq+RSy1Afw6HooCY/cLqcZcYk4EJAt1sZDcasKi48AFN5Z0u9eKmYGCLFrp9oImq5g+08GJ+Mhas8y2549sec5ItPaJbKhcFRvmSvC7rPUEFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AIIb9rF3V3HBQIgW17CjTt0sui879UkFkIeDM++OUNY=;
 b=AzSfoBORjiQ1XEsdJDoEgikVNkY1FRDyW/p69J12iZVsSlUdktHHqmGhpojfOWcxGWFI6ELSjrglKuhu+Sn/bNu1MZj/RpucgfN1BN3KRJ0tHDflhIxt1aRNGC3MhDfYLtKWe4dNvTt4AnmVjYViMd04FcjrxtShUVFLIEXhfAfigv65kmqU34BEXkgM59PmFa4jo9Q3ne+lEstmEN/zhRC00jPDj5rK1hEuUmB9at3HbmuPQFAVrL24KKrHdWulB0vyuZwPKt4wLN8PGmKMOmZsOwnssOugpNx0KHaPFckOVWpse1qSyjBAJPfH4OPZu6Yu/eOoQGYqDEixEmv6iQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AIIb9rF3V3HBQIgW17CjTt0sui879UkFkIeDM++OUNY=;
 b=M/dq4gTMQ3FWYsIB8MIkUFvVeO2P8vLVdNHK+VrmgJSP6d6Fd1KD/4L46f0U+ALIJkj19KXgPmduzyVXm0xVW3OPdKT+PbFl4PrJGyyKvd41HQAsphaMvpJNJetRMEaiJXCFthoCpw/lc+D12GoHu1wH12HbpRohbqI9VRqJ6rI=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by PH7PR10MB7695.namprd10.prod.outlook.com (2603:10b6:510:2e5::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.31; Thu, 20 Jun
 2024 12:54:27 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%6]) with mapi id 15.20.7698.020; Thu, 20 Jun 2024
 12:54:27 +0000
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
        John Garry <john.g.garry@oracle.com>
Subject: [Patch v9 02/10] block: Generalize chunk_sectors support as boundary support
Date: Thu, 20 Jun 2024 12:53:51 +0000
Message-Id: <20240620125359.2684798-3-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240620125359.2684798-1-john.g.garry@oracle.com>
References: <20240620125359.2684798-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0358.namprd13.prod.outlook.com
 (2603:10b6:208:2c6::33) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|PH7PR10MB7695:EE_
X-MS-Office365-Filtering-Correlation-Id: 1fe2fde9-54fa-4266-0951-08dc91281e58
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: 
	BCL:0;ARA:13230037|376011|7416011|1800799021|366013|921017;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?2gsIRBzyUQg82MC5Z1nw7CfqO8YLCZs9qUQGQkd/tkTb12mFW07x7JOWJ8DL?=
 =?us-ascii?Q?OD0A7Enx5k2flft/KwpMeM5Rj2a4dEHDivXiu77KoUA6/9/o3tIetg4EPHp8?=
 =?us-ascii?Q?MPs42dUY3fI0ov6q526zTAYYTF6zMsMP/TEWSY85YR6+ZNjpjj48Z5rflenD?=
 =?us-ascii?Q?GLZ8bGEiGXDAHJ2ZejXm1Rjf1mmV0v5LXZsiJEwllTcd2ZDyzfw2l6QaAIUh?=
 =?us-ascii?Q?dcUmxj9n9jczIBcp8MNB4TuGh+UkCzMb8OPwWc9ZBTBCc6E1gIZLT6eqcx2j?=
 =?us-ascii?Q?nnzBh6U0QAsQqzossE9etW/9UyO/Pl0pmvF253Vlskp6o2bJ0VGh1dIXRbqB?=
 =?us-ascii?Q?UsrUwwqujJfiQn520m2nZ0zDV0Fg47jSHr+izwJvDR99h5285++fNCS0z+4C?=
 =?us-ascii?Q?q3WsCWEcurxEkPjdt/PRIJjXJTSzARo2qty3mbbcjSsbGuGwDyvtJbsuIcjV?=
 =?us-ascii?Q?cLI3JFXwJ2VldgtywZ9yCOiSPc+lYPaT8YeZue3DDyNPv9zH9HmnNDFRT6IF?=
 =?us-ascii?Q?tCQcYw5TSybVFCqC55A/PcmGy4GJU2jKwowvJeNxr6b4NgLhiCvJTY7fl0cY?=
 =?us-ascii?Q?ouwftVwxz2icziWExhv57XL78iSX6CwLLrspkVX4W3rjEiPIMl6QAZmXJaOw?=
 =?us-ascii?Q?HGh119OmBdmaJnH6/HAhi7jgCPThRGS3CAFk5dV2p4H177V+rCvNVKUGxHsU?=
 =?us-ascii?Q?hzdamBZWc2ygDmd27+IVE/9ZQEx1s0iTLG4mpGvYea+Cc/EOHesMPYD6ivw2?=
 =?us-ascii?Q?MWsDyp8ceuk7tV+C3QO4qqggDqVqaGsPS2l2oo2wAwQZV1D+WoP00fFNTBTx?=
 =?us-ascii?Q?Jq475U62FXQJq9KjeoC3rfhsH7XrUeKUcX09y8D0TzbUXTO8+b219vh/9a5R?=
 =?us-ascii?Q?HS9Ct4XTHLE3Nv1Ypmv8Lreti7bDeB2uRYNVcj9xNHLg+hcur/bbeR6gkUyt?=
 =?us-ascii?Q?WKXSF90SJRbEETROJOWP9gEN2dqJgzWnKY8jVbAzrFnxTk4dozrdrpP0FXKm?=
 =?us-ascii?Q?NUl7Hrm3vJBUibt9gFVmJgXAKdP5gCFheRzAJnk/kw7vZG/hm/dr/0R98hqF?=
 =?us-ascii?Q?hRSchgs8OORvU5NRXSRHw+VxD4LEYn7lN+fDbLJyWTSyD04p3FHrtkcJ6wpw?=
 =?us-ascii?Q?TDyo09nY3lgBf6P3AC+W9PvRkAFQskOXQ82bQNuOL9btPXpxjairE2vhCoAj?=
 =?us-ascii?Q?DQ0MAmYGQzBswjxfu9bgXX8od/2w9/IfAohruZtsHAacRsYcKheL7ppt5xr8?=
 =?us-ascii?Q?3JO/e+UQJ0Z9PayftEKnC50dVtwEFT36bfZQQ+WX+v4b1DPXQneGnykLeODF?=
 =?us-ascii?Q?eGv0qGGQoEoZLqEhmZTUdTSHjq/qbmaGI9BDoAHBS2vTMr1JHMEzjW/uG5RJ?=
 =?us-ascii?Q?4Hji9eA=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(376011)(7416011)(1800799021)(366013)(921017);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?uC1Br6xu9kUNJBmSYBW1DyicCUUYGVxLwWBUMug8uebW1Kzp0R87yxKTmBiO?=
 =?us-ascii?Q?7OnQGMak8QfGwsHddfjXJo9e1Thb7IdeHZS0yTliMSdUj3wjiJNKkSxTq+GD?=
 =?us-ascii?Q?Xerus00BSwl8ShZ38NgwbIgHaL+mllzv+2eoLKJSrkiFqoHgT3zxfVghVdMs?=
 =?us-ascii?Q?Nl6Z2gb0lKuMNQOpaO8VGtSaO0yXCBe3uqByc4KnBmUsYuiNhny4Nn4o61ys?=
 =?us-ascii?Q?B1lo842rVIyNYZRGrPaPBI58tjqIPgQWtYJzXS7UEzx6ujjFOpJEnJJcFCLe?=
 =?us-ascii?Q?SLm+cY1dYShJuywBU1zePEhk5/TvODDcHm9wUYZ5QkbKDCorw5nfwn+YMFys?=
 =?us-ascii?Q?YUd+svLbomk4J/lNtJRw6D0lpMMr9vAczkKARGQJkCWMm3dnvRDCRSqQfZUv?=
 =?us-ascii?Q?fSOu9y8j4BTebM7Yd8ZWAY4uDm3NjLU14Igs0dGjKGsZfKJzyBEaY7XjCTnS?=
 =?us-ascii?Q?f/t1d97PRKhznzZS8OOcPx3Qf0natVbA8t5uuHrKU1DFfbSA+O0gODeyNLiQ?=
 =?us-ascii?Q?kyoVC/DFw1IPIbUxy+0lePvA5nBtVB6xjUBzDKM96qyfwf+AzFU4rn5RsMbt?=
 =?us-ascii?Q?8aDxJ2l4N62HniUS6Cy8zcSi7E9veBrwWPUcGS8IEqWGDPS1azmn6/4zMipg?=
 =?us-ascii?Q?76esTcFTnO1Uccoujy0aazD+qN/lNU71N0Ot0ZM+HqfJKKvV9P7/ua5hZ2N8?=
 =?us-ascii?Q?IuaIQmzzPHPlV0hTbAvoOGbc13GJgzsfgBXCbI6wl8HynrUMBb+vsmBRUwLQ?=
 =?us-ascii?Q?IOyr2cQceNZbhn8q8OEU5EOLWuKyXjCTCSrjLPSHByr9G3uXlThY1/UmnjbY?=
 =?us-ascii?Q?jzzibTYx9EdznnxJkMP+1fAaem3NsuJP3KgP0qyd6SjWr29ue0xATuxumCjf?=
 =?us-ascii?Q?oX1U3kHan/92CqWVJ9iZeqjwjOCgpHUQPdaS7ZxlxYgimtYFac/NZOU0acsY?=
 =?us-ascii?Q?YUgUSjq+QDgUrSyP8Veu3njpQuPq7l378KkRUC0ijqGnQEoC6H5ZGrACSVi4?=
 =?us-ascii?Q?YNUCU+QqADa+75qyQomszqXyOpk7bYZi7O8aKzngM58gRyWCyC2jRBg9z6LQ?=
 =?us-ascii?Q?VTTZQK0AJUHK8g8dog0dVqhXDVxy52l4sa0Wp2avYFuEKQc1GJjfWsGk10NH?=
 =?us-ascii?Q?Tk95A+Cv3OzIPkKOaJnBQAYCTLyx/3tdN7EWUEDD9gswPrurVHXRdPXpktNZ?=
 =?us-ascii?Q?MmtD+jyPAal1jx5axtpNC6wUA6vjNM0pX7XbkIwbzgDd/JS+k6ZNnZ0VkRjE?=
 =?us-ascii?Q?N/FBQwJJwzuFWlKs6/HopWSq1LmZW1RKtANrwPq36V1QYxw1EsqErlBTMUR7?=
 =?us-ascii?Q?iZIK1lj76UGQa5UJPtbnPAnf5W+eN65TRKjHK/kRChPKPZXZZsT0RDoHH1Tn?=
 =?us-ascii?Q?KG2qVDpqw6VLAjgms88RJCvsbZofupDkMxrA3eSVTXGg6kP6b1ZsIDCehOnL?=
 =?us-ascii?Q?s+A5W/yTtulbudGTrkiRitexYvklZNX/TxJ4pMjIpMmyO1LF5NUPvgALVblK?=
 =?us-ascii?Q?h4I+bjyEfxYpByxeUwNPcozIlsKtQStNPftV4Kh4B2hoiGntugOzIKC4N+Aj?=
 =?us-ascii?Q?pjmLERJd+OHrh/FHD9edl1nAiuzLsYOcysxLWy/ERTP2VYSU8PVUW43XPwOY?=
 =?us-ascii?Q?RA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	IKX9CnVmQ84A/9eZ591uoc6qOUgm6X07I51C8Zpe2/W8f3EJOZCPe2eeiV29RhP9m9z8kPj7lHCYTAxsxRsaZZV5R0fkO4vOXq5vzgRiBN1aVb5PLd5yXC4RFA4xTUMb/KILh+dx1/8LPmwsZ486E7JbNcfdPqQXhgNtl4UTR0QEAJgtFg11elhlASdmDW7DdBRdMTo5TW4d3mQDhEeyP2Va6Aw+5ZXJgxcr+w23qFoPVWy41D5vqdDA/cymdPOHUKMGcZZUHG8SDJFwKRB5Rmae5Tfs9Sh1whBl3kE3rU0bg4GJF6TNeTmssBGzgkSOvuKOGaq+K4k4zpZgWz0WfB2118yyD2LWlSBEpFcxS92ntJDnUQzqjO4l3fE+G81gY2X+jCONxCnjpIsI6tAV+ZCHOyqjL/WQkfp1LK2Bp4aFAuPjkMMcF5n2IDaKIn5SpSOhL3VJx7qI5yTYcV15jufc/aEV1ulFryzZ/bHknMJnmhSHMFALO5SgXHtYHCDYveA/eSKkXLzO2Aw4MVww3bbB2+n5DiKyGI0D862gPdMuuVwsZAgJNdbq6yQDe0y++MF4lVd8/e7BCXO0sMbLMpQfx3EEUqb5qTthiAvFguI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1fe2fde9-54fa-4266-0951-08dc91281e58
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2024 12:54:27.4774
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RJqOB4xOWt96bXMB+HCXDUdRRwEytd91Bpz6m72O8hu+MnV4kjLxiBGswzqU1oGllWowtL+P6o/GmJNEwvqX4Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB7695
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-20_07,2024-06-20_03,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 malwarescore=0 phishscore=0 spamscore=0 mlxscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2406200092
X-Proofpoint-ORIG-GUID: -XYMrkC1BRon8-FyDOv5enwcIGA0Anxh
X-Proofpoint-GUID: -XYMrkC1BRon8-FyDOv5enwcIGA0Anxh

The purpose of the chunk_sectors limit is to ensure that a mergeble request
fits within the boundary of the chunck_sector value.

Such a feature will be useful for other request_queue boundary limits, so
generalize the chunk_sectors merge code.

This idea was proposed by Hannes Reinecke.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 block/blk-merge.c      | 20 ++++++++++++++------
 drivers/md/dm.c        |  2 +-
 include/linux/blkdev.h | 13 +++++++------
 3 files changed, 22 insertions(+), 13 deletions(-)

diff --git a/block/blk-merge.c b/block/blk-merge.c
index 8957e08e020c..68969e27c831 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -154,6 +154,11 @@ static struct bio *bio_split_write_zeroes(struct bio *bio,
 	return bio_split(bio, lim->max_write_zeroes_sectors, GFP_NOIO, bs);
 }
 
+static inline unsigned int blk_boundary_sectors(const struct queue_limits *lim)
+{
+	return lim->chunk_sectors;
+}
+
 /*
  * Return the maximum number of sectors from the start of a bio that may be
  * submitted as a single request to a block device. If enough sectors remain,
@@ -167,12 +172,13 @@ static inline unsigned get_max_io_size(struct bio *bio,
 {
 	unsigned pbs = lim->physical_block_size >> SECTOR_SHIFT;
 	unsigned lbs = lim->logical_block_size >> SECTOR_SHIFT;
+	unsigned boundary_sectors = blk_boundary_sectors(lim);
 	unsigned max_sectors = lim->max_sectors, start, end;
 
-	if (lim->chunk_sectors) {
+	if (boundary_sectors) {
 		max_sectors = min(max_sectors,
-			blk_chunk_sectors_left(bio->bi_iter.bi_sector,
-					       lim->chunk_sectors));
+			blk_boundary_sectors_left(bio->bi_iter.bi_sector,
+					      boundary_sectors));
 	}
 
 	start = bio->bi_iter.bi_sector & (pbs - 1);
@@ -588,19 +594,21 @@ static inline unsigned int blk_rq_get_max_sectors(struct request *rq,
 						  sector_t offset)
 {
 	struct request_queue *q = rq->q;
-	unsigned int max_sectors;
+	struct queue_limits *lim = &q->limits;
+	unsigned int max_sectors, boundary_sectors;
 
 	if (blk_rq_is_passthrough(rq))
 		return q->limits.max_hw_sectors;
 
+	boundary_sectors = blk_boundary_sectors(lim);
 	max_sectors = blk_queue_get_max_sectors(rq);
 
-	if (!q->limits.chunk_sectors ||
+	if (!boundary_sectors ||
 	    req_op(rq) == REQ_OP_DISCARD ||
 	    req_op(rq) == REQ_OP_SECURE_ERASE)
 		return max_sectors;
 	return min(max_sectors,
-		   blk_chunk_sectors_left(offset, q->limits.chunk_sectors));
+		   blk_boundary_sectors_left(offset, boundary_sectors));
 }
 
 static inline int ll_new_hw_segment(struct request *req, struct bio *bio,
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 8a976cee448b..7d107ae06e1a 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1188,7 +1188,7 @@ static sector_t __max_io_len(struct dm_target *ti, sector_t sector,
 		return len;
 	return min_t(sector_t, len,
 		min(max_sectors ? : queue_max_sectors(ti->table->md->queue),
-		    blk_chunk_sectors_left(target_offset, max_granularity)));
+		    blk_boundary_sectors_left(target_offset, max_granularity)));
 }
 
 static inline sector_t max_io_len(struct dm_target *ti, sector_t sector)
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index e96ba7b97288..4ff5886d3ca4 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -912,14 +912,15 @@ static inline bool bio_straddles_zones(struct bio *bio)
 }
 
 /*
- * Return how much of the chunk is left to be used for I/O at a given offset.
+ * Return how much within the boundary is left to be used for I/O at a given
+ * offset.
  */
-static inline unsigned int blk_chunk_sectors_left(sector_t offset,
-		unsigned int chunk_sectors)
+static inline unsigned int blk_boundary_sectors_left(sector_t offset,
+		unsigned int boundary_sectors)
 {
-	if (unlikely(!is_power_of_2(chunk_sectors)))
-		return chunk_sectors - sector_div(offset, chunk_sectors);
-	return chunk_sectors - (offset & (chunk_sectors - 1));
+	if (unlikely(!is_power_of_2(boundary_sectors)))
+		return boundary_sectors - sector_div(offset, boundary_sectors);
+	return boundary_sectors - (offset & (boundary_sectors - 1));
 }
 
 /**
-- 
2.31.1


