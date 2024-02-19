Return-Path: <io-uring+bounces-633-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8935785A446
	for <lists+io-uring@lfdr.de>; Mon, 19 Feb 2024 14:06:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 42048280DFB
	for <lists+io-uring@lfdr.de>; Mon, 19 Feb 2024 13:06:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D31422E85A;
	Mon, 19 Feb 2024 13:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RGR84Oh8";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="FbM845Ga"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EC1C35F18;
	Mon, 19 Feb 2024 13:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708347997; cv=fail; b=K5MP+rTbuV3M8k84BGUjGyqaFg/r+JBDGRowPlhM0lcRKvF+7l4M6ZzD5J3EJnenZok2ZaH5ui8BvOlN4if8CCw9+W9cRDXq3CAQT9a9s+hfRaRGVVMqleI7BGsUXA6jcFNpP/UclBSlNh0TZbz6YkQtCUjBhzbkIQfpf0lh/Ec=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708347997; c=relaxed/simple;
	bh=osqt/KEPKpYT908h1OVHuS6x3u208/7rOeW/5ZhF0qc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=OvieVsmDeaBO6PLnZgPVZXXsSpwITZIucXprAFGVONULempyWRTDMZ5i+oN4VE+5Dzo5UNzYopo0d5bgmWzSf7nBWGJrSP7zZsXcNMib6tuCUfXZK9TGO9dm+8/BGBYcOT0zM6NGtR8tJPfDzUcS1tiumvqb+zon/tU5wjxLUjQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=RGR84Oh8; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=FbM845Ga; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 41J8OEHG010920;
	Mon, 19 Feb 2024 13:01:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-11-20; bh=asRInoX1uAIZeiE1Dz13rdALnWRZiM8Q5vfcI0+DzDM=;
 b=RGR84Oh8Q+Ew+EgeHcCyWahzclg48TWKIq3+fBAlyvdlnXBxaI1Ffi88xVilhvFS3eHH
 sPEvtvEqAQtHsp3tcYJ8wKPvojBDJrpq1a5yOhz+BhduHclcmqY6DmWzHto1o9DOEGRW
 FjYbT1gZxQHVI3e0da3HvNE01nji31rYHEieNK+ZIWKVq9NN5iXnMToDfZkJ5eMofgWQ
 L5z3hxQ/bm4vJtv+aJmqeylbuLkCnU5hKqVwJsH4YFeDyELfbJGCIcZ8uD0kfqPjLH3U
 trrIKUH+CgpjMRB/65wgxNQznqp39DwuhViczkS8TNsdx9VYI+cI/TSohtOlzYI7z1Wy Zw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3wak7ec4hb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 19 Feb 2024 13:01:46 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 41JCPE4W006609;
	Mon, 19 Feb 2024 13:01:45 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3wak864kt4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 19 Feb 2024 13:01:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DdZZxgPNkFIgLRq9Zr5IPLCBzj28dDSvmoKkjvQTNiKY4+gj362Qwr1OIGNMr5DS1Xu1Na+MAmzFoA1Pf1w2nfuI+Z8/NrA6L/bpauox+4HxjCJhvvcNhlvI4+XhbE7rMQaE/BBocsVGAqkseOnoGZHoliZt38t21QaJsh0r0TQh9SGVLxA9UODpU4RbzjLAwHII/Z2N3QkESneUarI/cp4rBalLxiau5ImVb1/lZyrQm50UZYSzBcpZnaXaO31aBolgzeIucV3sBhw59tIVkODzpvBYEZIRd9e/I0KjSRKYdkot4vAHgG3i8IydtcgMVpAW5UfJmI9MQs/rl7FAjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=asRInoX1uAIZeiE1Dz13rdALnWRZiM8Q5vfcI0+DzDM=;
 b=lOFYevTpn/pDYoKz1zIAz+hr8rmE0kJp+yDRnSwTJ0lyoXVDWP7IZFTDZ0s9Uehuo57R1l7Mo1uiGHIx+zktmLPo9q4AjBAq1+LcJM94T2pNDw183wGBNQNLg1yFQNeKRKoUySpFZOqxiOB5xj52hegCvUqAGtm9FnYtq0uP6hGMPYN5dm2oA7E85pUStvwv+qgnATOx2uy2+j65uqDGJUPf6aMRal+1fdZL2xEKf0JLQ7Oir4pDT+gyaToOxfYlWFQn4px8Cglh3Bl/u9fD5lghIDOaekVCdDwtKnAlMiqxR5UD369XSu41DhZzWE+O8QGQi9MitsBZZirbfvbzyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=asRInoX1uAIZeiE1Dz13rdALnWRZiM8Q5vfcI0+DzDM=;
 b=FbM845Ga35HhJYpSSuq8eA4uIf2X/R1bTVnVEsCWTtQjo+P7kWZBkBGqbAcxQC9pYQek8RHvD9YnCA12UclfbXdwZd1WwBDnxhpUx6M+52NQQWZw3UE3qWC3vg/GEmO/yOQoI93E3+WgYC9p+SoapxXde8iy1ik4khA1a45N8EM=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DS0PR10MB6894.namprd10.prod.outlook.com (2603:10b6:8:134::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.38; Mon, 19 Feb
 2024 13:01:42 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::56f9:2210:db18:61c4]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::56f9:2210:db18:61c4%4]) with mapi id 15.20.7292.036; Mon, 19 Feb 2024
 13:01:42 +0000
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
Subject: [PATCH v4 05/11] block: Add core atomic write support
Date: Mon, 19 Feb 2024 13:01:03 +0000
Message-Id: <20240219130109.341523-6-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240219130109.341523-1-john.g.garry@oracle.com>
References: <20240219130109.341523-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0279.namprd03.prod.outlook.com
 (2603:10b6:a03:39e::14) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DS0PR10MB6894:EE_
X-MS-Office365-Filtering-Correlation-Id: 58221ab0-2498-42c6-6726-08dc314aeb50
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	3NApbs6Agr53Y1HY7xtVf+3cDI31OGEkXxzsBiVnJmw1Dh6Vi7oiXm7txxl6KUUCelnZglOgGXxWv11xTWFGH3AReV3NgwKwF4nn4PIUlYyZ/wvN9EcENugi3kyVCPzPFAxXXIn2CefmKgTNg8AuYf2B2p5o6yqL4EEt8MIC+R6EMSTNl8TSTc+9/phl2rMabnSgPpPslFztEenlXjDBN+oqampgKuMkU2D/rmUJUjeKMP60hcPz+WfXB+oGo6ViDy4GCK1bIN48WD9MbMkpXQw4EJX1yt21Bz4m5JDweRHncml5tWkt/Apm8qxuK8lIsrx1/YUWGGsApSThsVRL6VQ1Ody7zc5+kOqSicBgAzIi8jt4WQ/iDtWHbRaaut15IXCA2gGEVmz7b3HQDUdDNTWp+yjyqQYSeAAFvZwiZZ4eqO9bO+GCyDEiokf5FyjO0Uw6tGJ7Y7jVL2qNABJN6N6ZCcxQd2M9xCWVBCtQ56/vAYloJtjrdhUDnvBQjUr08hS6sAD2xZBOqFSPwlPzhArUUR6M9zbsOshcML15qYVYXopDirUDb5LLpx53F6yOjMK2vgAvmvK7cMEU8dfmcipSlfi7EzEcI4JeRA0fL44=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(921011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?XqkVdHgO4fI0uJnaldQozejx50Oyje5lo3qQZFUU86KvdPQHOn+8WXDV23+m?=
 =?us-ascii?Q?PBIlST+7XicDgq0+FAsMYCKHackBhxG/2v1MF86FxAYkhSKc+QnyWcQ8Hg0q?=
 =?us-ascii?Q?v0SOlcZgJKgXdqnPdd9FECFC9ykFm8k1tEr4OX2idoVcT8W4WP1bQPuIDFDw?=
 =?us-ascii?Q?qMWMT1z4ebWNWs2d/DqYIPkcyEMzUGMTYUqxA6A5qFItlpg/GrGomZlf5Dp7?=
 =?us-ascii?Q?otxtfV0miBTDG1LqNd79RMODVrxGLjktadCvdEoZYRe8KwDYoW4dTtPdS0FD?=
 =?us-ascii?Q?sehiA2gFIz/gE/acPpwJWAEEEvMAdBkwR6yD9Zf7LXDJHpUXlpKyDlRVSlsV?=
 =?us-ascii?Q?ou66mD9bgG8NUXHn7V3mE7AyjjvBFq/JQs5YdtSM4k6m936mGV3yN8L1tLSK?=
 =?us-ascii?Q?sEijLXv9zO09zISDjTaSBOqRA3QiB0P7pFePcMwRhM2mR2weWclhAA4Fu6VO?=
 =?us-ascii?Q?4olhbgtjLplI613SvFRwD/Q5HGDdxN5q7eEHkdJdzabYuG+LgxpLMuN/B1yL?=
 =?us-ascii?Q?0mrpLwJbvAzChhVOCV5XZzYkQYiR3DRiwKy3gSmKn/fbilFkI0XzGZMXQUZB?=
 =?us-ascii?Q?HXL7mhWAJDYl79qlMha9EGIlS2o9JrFuhjg9TvHCSYLPHZHzLd0ipC5GehYq?=
 =?us-ascii?Q?RDXmf8yBcQpiTobcYitCIsbOsmnLczNlyI46qYbCnM6PXG6oR3+Gt0guvpX9?=
 =?us-ascii?Q?Dkd/0/OYURfXawYEjtlgxqNwBeY1fydG4IOMeKRiWQsRZg9GFcWD3NIvkVfV?=
 =?us-ascii?Q?Q2KQozu4wWL7EAvBEQ69B49ilPUNar12Xlg05ZjxG7PojCU0l3jaAa9ICFqo?=
 =?us-ascii?Q?h0oEtkf4w/n5YNJTN+724Pu61XTy2R76r4y0XcqCTmAT6bodz1egFWe9+O0P?=
 =?us-ascii?Q?trT/xbh+0jIL0UM/ztOQq8OBBRT9MMwAGwSQNjBcanRjUrdpxf7i74FNWS3L?=
 =?us-ascii?Q?2ZmD6uPkDnJQF+AHOHzfLuXtrzenczKdS0MgDeShD8OxkB5rOHFUQspF89mq?=
 =?us-ascii?Q?YH4Mt+87T2l8YQGfUUlVSLIT60fyinUiKhgMiFQ9upt+oS7W9PQx+6vm5pnL?=
 =?us-ascii?Q?Ap718XRpZOoeByeTcbEsY06Kis64SkYiF3cNFwZpeBYtHDzyTSEVjHBpKqbh?=
 =?us-ascii?Q?3mQt9EDwt8Vw/Z9sGsc4IapIExKbdeA3s1wg69b/nof9d3EWolr20FWzou/p?=
 =?us-ascii?Q?yU5EP/SP7NSuK8iZJYOlaXk8yjtQyEtfusVEhOWOOscHpbXojrEoJhZCw7kM?=
 =?us-ascii?Q?K5XZG3p/opbGYFA39BbN/3/K66YebHRTanuINGDRhyExV6Ac2vf4wk25JdJ2?=
 =?us-ascii?Q?twscxnbQTHXrWXDAxn97wEeJKWucwN+JbApclSVMbRfXh9WMg19gvIG4xikd?=
 =?us-ascii?Q?YZccRpVd9Ojz13xU7Nxq4J2FgJNd1fU+oxaxTvUH8WYoGlxPJtFtaosIHYto?=
 =?us-ascii?Q?P2AiV7ZvGMLBGWAf6wop8PbikSibzNkpL71rd6vzBaJpSkAba7cZmAikoX0d?=
 =?us-ascii?Q?SQ+tRKCQet4qC7pDLIHo/xm4DyFZecNV5g6eURUKETxtqrSlhPq0cf3r1Z/b?=
 =?us-ascii?Q?vS1AJFx8RBEqFUNdI42exYL951lv+WlMXsM2Tnks3XrK4Ne6LXa3K2Em+V+Z?=
 =?us-ascii?Q?Tw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	i7uFtbaRDhERcNn1b4the5Terb82lHimvOW3wyDghgdyQeJ48Yr0gXRKfbYwyESzIpaAd34GSUBGDQWHLUp2uFdRRHFWXH8XKxwWMLkGdaifm6Kerwt3dls31Yv1cpgAtw2aLYwWHwi+vioquraiZGQKFHxsuX+sPlKh2Q5stw6ybGvO31FTgT0aX9PfBmNEqIf/lQUIq+kFwGtBEhsVCS1uT9a4eJWkko5wNQRAnX8O16yd6X5iBOcfEisjIXxK+pBNBnGqRCTsLgMndnrOkgO9WLjgCpAcWW4BXxEHLPQR5whgJAo3UK5SaFG2+BwfvVSm/JXM756YG5zgzq47VMNnTRYUzf2PVrd03ugK1VLWCKPsYmnHhZHKxbAlvGIJhiekQGNWGk7g5pjBCG50mpwPjtUodZb2k4SnqlXfO+Ny4h6DBW5QW64XYnsq5ebS1VVM4XQskSkRt1Gk+IrQXvf4TEgL6ikRBPfeFcr5DcdtD6s0LS+i8TEnfliB98MdPTkbWwITETiFm5dMEnuHXcydU7D9HdjxDmEVPhxizZfKqHXACjVyZ8v1alq+StRvnkhvy8d5MxEbUgs2S5D9tdXRS3iYTl6e200/Vtjo3TI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 58221ab0-2498-42c6-6726-08dc314aeb50
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2024 13:01:42.7097
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +/v8gf+rC+hANMXt0lDgqYLtYfyZICY6FjHZEigGsUctubldm1fbqs9y/ujzIs+5Fn+/xALga61y9wEA/guwcg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6894
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-19_09,2024-02-19_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 mlxscore=0 spamscore=0 mlxlogscore=999 phishscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2402190096
X-Proofpoint-GUID: rJUtsP8qNqK4mObDL-ztjvjbP_mgCMkw
X-Proofpoint-ORIG-GUID: rJUtsP8qNqK4mObDL-ztjvjbP_mgCMkw

Add atomic write support as follows:
- report request_queue atomic write support limits to sysfs and udpate Doc
- add helper functions to get request_queue atomic write limits
- support to safely merge atomic writes
- add a per-request atomic write flag
- deal with splitting atomic writes
- misc helper functions

New sysfs files are added to report the following atomic write limits:
- atomic_write_boundary_bytes
- atomic_write_max_bytes
- atomic_write_unit_max_bytes
- atomic_write_unit_min_bytes

atomic_write_unit_{min,max}_bytes report the min and max atomic write
support size, inclusive, and are primarily dictated by HW capability. Both
values must be a power-of-2. atomic_write_boundary_bytes, if non-zero,
indicates an LBA space boundary at which an atomic write straddles no
longer is atomically executed by the disk. atomic_write_max_bytes is the
maximum merged size for an atomic write. Often it will be the same value as
atomic_write_unit_max_bytes.

atomic_write_unit_max_bytes is capped at the maximum data size which we are
guaranteed to be able to fit in a BIO, as an atomic write must always be
submitted as a single BIO. This BIO max size is dictated by the number of
segments allowed which the request queue can support and the number of
bvecs a BIO can fit, BIO_MAX_VECS. Currently we rely on userspace issuing a
write with iovcnt=1 for IOV_ITER - as such, we can rely on each segment
containing PAGE_SIZE of data, apart from the first+last, which each can
fit logical block size of data. Note that here we rely on the direct IO
rule for alignment, that each iovec needs to be logical block size
aligned/length multiple. Atomic writes may be supported for buffered IO in
future, but it would still make sense to apply that direct IO rule there.

atomic_write_max_sectors is capped at max_hw_sectors, but is not also
capped at max_sectors. The value in max_sectors can be controlled from
userspace, and it would only cause trouble if userspace could limit
atomic_write_unit_max_bytes and the other atomic write limits.

Atomic writes may be merged under the following conditions:
- total request length <= atomic_write_max_bytes
- the merged write does not straddle a boundary, if any

It is only permissible to merge an atomic writes with another atomic
write, i.e. it is not possible to merge an atomic and non-atomic write.
There are many reasons for this, like:
- SCSI has a dedicated atomic write command, so a merged atomic and
  non-atomic needs to be issued as an atomic write, putting an unnecessary
  burden on the disk to issue the merged write atomically
- Dimensions of the merged non-atomic write need to be checked for size/
  offset to conform to atomic write rules, which adds overhead
- Typically only atomic writes or non-atomic writes are expected for a
  file during normal processing, so not any expected use-case to cater for.

Functions get_max_io_size() and blk_queue_get_max_sectors() are modified to
handle atomic writes max length - those functions are used by the merge
code.

An atomic write cannot be split under any circumstances. In the case that
an atomic write needs to be split, we reject the IO. If any atomic write
needs to be split, it is most likely because of either:
- atomic_write_unit_max_bytes reported is incorrect.
- whoever submitted the atomic write BIO did not properly adhere to the
  request_queue limits.

All atomic writes limits are by default set 0 to indicate no atomic write
support. Even though it is assumed by Linux that a logical block can always
be atomically written, we ignore this as it is not of particular interest.
Stacked devices are just not supported either for now.

Flag REQ_ATOMIC is used for indicating an atomic write.

Helper function bdev_can_atomic_write() is added to indicate whether
atomic writes may be issued to a bdev. It ensures that if the bdev is a
partition, that the partition is properly aligned with
atomic_write_unit_min_sectors and atomic_write_hw_boundary_sectors.

Contains significant contributions from:
Himanshu Madhani <himanshu.madhani@oracle.com>

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 Documentation/ABI/stable/sysfs-block |  52 ++++++++++++++
 block/blk-merge.c                    |  91 ++++++++++++++++++++++-
 block/blk-settings.c                 | 103 +++++++++++++++++++++++++++
 block/blk-sysfs.c                    |  33 +++++++++
 block/blk.h                          |   3 +
 include/linux/blk_types.h            |   2 +
 include/linux/blkdev.h               |  60 ++++++++++++++++
 7 files changed, 343 insertions(+), 1 deletion(-)

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
index 74e9e775f13d..12a75a252ca2 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -18,6 +18,42 @@
 #include "blk-rq-qos.h"
 #include "blk-throttle.h"
 
+static bool rq_straddles_atomic_write_boundary(struct request *rq,
+					unsigned int front,
+					unsigned int back)
+{
+	unsigned int boundary = queue_atomic_write_boundary_bytes(rq->q);
+	unsigned int mask, imask;
+	loff_t start, end;
+
+	if (!boundary)
+		return false;
+
+	start = rq->__sector << SECTOR_SHIFT;
+	end = start + rq->__data_len;
+
+	start -= front;
+	end += back;
+
+	/* We're longer than the boundary, so must be crossing it */
+	if (end - start > boundary)
+		return true;
+
+	mask = boundary - 1;
+
+	/* start/end are boundary-aligned, so cannot be crossing */
+	if (!(start & mask) || !(end & mask))
+		return false;
+
+	imask = ~mask;
+
+	/* Top bits are different, so crossed a boundary */
+	if ((start & imask) != (end & imask))
+		return true;
+
+	return false;
+}
+
 static inline void bio_get_first_bvec(struct bio *bio, struct bio_vec *bv)
 {
 	*bv = mp_bvec_iter_bvec(bio->bi_io_vec, bio->bi_iter);
@@ -167,7 +203,16 @@ static inline unsigned get_max_io_size(struct bio *bio,
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
@@ -305,6 +350,11 @@ struct bio *bio_split_rw(struct bio *bio, const struct queue_limits *lim,
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
@@ -645,6 +695,13 @@ int ll_back_merge_fn(struct request *req, struct bio *bio, unsigned int nr_segs)
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
 
@@ -664,6 +721,13 @@ static int ll_front_merge_fn(struct request *req, struct bio *bio,
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
 
@@ -700,6 +764,13 @@ static int ll_merge_requests_fn(struct request_queue *q, struct request *req,
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
@@ -795,6 +866,18 @@ static enum elv_merge blk_try_req_merge(struct request *req,
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
@@ -814,6 +897,9 @@ static struct request *attempt_merge(struct request_queue *q,
 	if (req->ioprio != next->ioprio)
 		return NULL;
 
+	if (!blk_atomic_write_mergeable_rqs(req, next))
+		return NULL;
+
 	/*
 	 * If we are allowed to merge, then append bio list
 	 * from next to rq and release next. merge_requests_fn
@@ -941,6 +1027,9 @@ bool blk_rq_merge_ok(struct request *rq, struct bio *bio)
 	if (rq->ioprio != bio_prio(bio))
 		return false;
 
+	if (blk_atomic_write_mergeable_rq_bio(rq, bio) == false)
+		return false;
+
 	return true;
 }
 
diff --git a/block/blk-settings.c b/block/blk-settings.c
index 06ea91e51b8b..176f26374abc 100644
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
@@ -101,6 +108,44 @@ void blk_queue_bounce_limit(struct request_queue *q, enum blk_bounce bounce)
 }
 EXPORT_SYMBOL(blk_queue_bounce_limit);
 
+
+/*
+ * Returns max guaranteed sectors which we can fit in a bio. For convenience of
+ * users, rounddown_pow_of_two() the return value.
+ *
+ * We always assume that we can fit in at least PAGE_SIZE in a segment, apart
+ * from first and last segments.
+ */
+static unsigned int blk_queue_max_guaranteed_bio_sectors(
+					struct queue_limits *limits,
+					struct request_queue *q)
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
@@ -145,6 +190,8 @@ void blk_queue_max_hw_sectors(struct request_queue *q, unsigned int max_hw_secto
 				 limits->logical_block_size >> SECTOR_SHIFT);
 	limits->max_sectors = max_sectors;
 
+	blk_atomic_writes_update_limits(q);
+
 	if (!q->disk)
 		return;
 	q->disk->bdi->io_pages = max_sectors >> (PAGE_SHIFT - 9);
@@ -182,6 +229,62 @@ void blk_queue_max_discard_sectors(struct request_queue *q,
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
+
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
index f288c94374b3..cd7cceb8565d 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -422,6 +422,7 @@ enum req_flag_bits {
 	__REQ_DRV,		/* for driver use */
 	__REQ_FS_PRIVATE,	/* for file system (submitter) use */
 
+	__REQ_ATOMIC,		/* for atomic write operations */
 	/*
 	 * Command specific flags, keep last:
 	 */
@@ -448,6 +449,7 @@ enum req_flag_bits {
 #define REQ_RAHEAD	(__force blk_opf_t)(1ULL << __REQ_RAHEAD)
 #define REQ_BACKGROUND	(__force blk_opf_t)(1ULL << __REQ_BACKGROUND)
 #define REQ_NOWAIT	(__force blk_opf_t)(1ULL << __REQ_NOWAIT)
+#define REQ_ATOMIC	(__force blk_opf_t)(1ULL << __REQ_ATOMIC)
 #define REQ_POLLED	(__force blk_opf_t)(1ULL << __REQ_POLLED)
 #define REQ_ALLOC_CACHE	(__force blk_opf_t)(1ULL << __REQ_ALLOC_CACHE)
 #define REQ_SWAP	(__force blk_opf_t)(1ULL << __REQ_SWAP)
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 99e4f5e72213..40ed56ef4937 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -299,6 +299,14 @@ struct queue_limits {
 	unsigned int		discard_alignment;
 	unsigned int		zone_write_granularity;
 
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
@@ -885,6 +893,14 @@ void blk_queue_zone_write_granularity(struct request_queue *q,
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
@@ -1291,6 +1307,30 @@ static inline int queue_dma_alignment(const struct request_queue *q)
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
@@ -1540,6 +1580,26 @@ struct io_comp_batch {
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
+		unsigned int granularity = max(
+				limits->atomic_write_unit_min_sectors,
+				limits->atomic_write_hw_boundary_sectors);
+		if (do_div(bd_start_sect, granularity))
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


