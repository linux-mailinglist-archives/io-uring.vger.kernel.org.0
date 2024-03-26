Return-Path: <io-uring+bounces-1227-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B43A688C3DB
	for <lists+io-uring@lfdr.de>; Tue, 26 Mar 2024 14:43:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D758C1C3958E
	for <lists+io-uring@lfdr.de>; Tue, 26 Mar 2024 13:43:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF111128821;
	Tue, 26 Mar 2024 13:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BznG6CU7";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="igPSKwQs"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF7EF128381;
	Tue, 26 Mar 2024 13:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711460423; cv=fail; b=IM3c4CXYpzaW6vRgOWLyFXrFzE5v8W75ynXu0zPL87i+dbK4lWO0L10qKO11o6rJ2hI4Li9H7ZQ+m+SlyuujJYd7y5ljOpvkvbats1SHpr7km77swxBGMmkFsjDo+9DnKQX+pVac6XTdsi1ASivnEzlHPpQ/yPe5uqe7JOP0l9Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711460423; c=relaxed/simple;
	bh=JXSNxK9cDtJSoN/UbWRvXS7b5x/okZx5VtGDsx4kt0U=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=b4TPdIKGh6jq4w1T8yAA74Alm0823AaqMJgwbJeMihjF1nXRUuwuPMnG+KjAy1zU3ZBm2KSK5jbxPRttRHOmAOEMwOpaMdLoZdFSR1bVrAFtW838bo7pegzqCJVQZhpZ/iXt1kRRInYUEoKdQ0UIgnYz5QyBbYrfJM4xa5gwOd4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=BznG6CU7; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=igPSKwQs; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42QBnktw012046;
	Tue, 26 Mar 2024 13:39:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-11-20; bh=ufvOEddQUi4BQyDLIyJUOOMPVlMZbkOLPpmXrIN9h2o=;
 b=BznG6CU7cec+GVz1HQsJpylA17Mf8QGaBs9MjIkdXF4A9jndJmPFj4/gIi2gxMAeCgFm
 Mz71rUdakcn6D3QJvSWXxRxkohUX3PSAJt7mqZK2WZOF9tWKWXOxnbjud4a8DwJMMrkY
 KDwaUN7aKRKhDwmybAqf6h1Xyp2gq7PnkoMcLd9Vp80wGwWOztns1aO+INPq5pf2Q4zD
 Ipu8itu3KqeOyUH6JHPeCbjv/ye0H0+pooQNz2XXzK7R53Sm/Cb4HuTyVgr5RiTCOUZA
 W2XJjH+XFrHdGiPZMvtSdYLem3u9FuH/wFD5HI9FttSguE+aaQhJttfFtjUO6T1/w82e Pg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3x1pybmxfp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 26 Mar 2024 13:39:36 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 42QCMRsG017540;
	Tue, 26 Mar 2024 13:39:35 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3x1nh77x2e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 26 Mar 2024 13:39:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KkUynzSuSiiQvYmmw1VTfREz8xZiyyN5EifVi5YCICnaYI8dmP8/86jAk7Hrqq6dHju9VWmdD/TAMR11ODuudRMPWLXoia122CT2GXAD6AK47IGtj1K/yuVOV90+cm5A34Xf02cTRk8os+4+hqhUORIrlOM7izMESXcHOROCbsmEok9dIGinB2zj0DaPlMx2tGmtGBCxw+/UXdezRUheE977Gro3HvWcsd6QLR9pAxYWmtV7BVDZwlsqgB7/jqHgED8P2r00WilW6zLOmq/Xdzec+aPX/7rjg1m//YFCYH5wkGCaCjNgoS7JJxKtxyFnwro7EJaWkiVZS20h24Gliw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ufvOEddQUi4BQyDLIyJUOOMPVlMZbkOLPpmXrIN9h2o=;
 b=ZRJ5ad9+zPSK8KLconxdS+sIVj0e/U3eRZLAuZR+HBYXUthS71x1puldVXbo7i+nEcYHEvOvxXTt3WpFealDMBKrDkK7Bfs0+E5HBkDGs9PKa/ndXQ9oaMDgI7oNREftefyDmxdfAGuLzkJp+u0tiNSqzODyjgOjVnG3SQnXp5V52yP0XA0W0Af4ljstHYsmfpytostGOojgqrDY4u9wxXGVXgRwQ0k71AlyK4JktPyOjw9R6gKNEK24hHrSTl8cu4IdCwiiMninYFfL6C4TIZRebj2LcQLaFZC76ofxzszW6+ABnov4F95ZIOdaTJpofGrCJfvFHKTgOLg1xTgLUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ufvOEddQUi4BQyDLIyJUOOMPVlMZbkOLPpmXrIN9h2o=;
 b=igPSKwQs1IPSwUWxQRd7RW/G4zheOKPY16AKbYQEv/MBDqxr+2yzzZunCKE8BW8TvnZeT/vOKPezr3uuf/+OWQKXGCup17KoIB8pKIaQ0W1umQVFkkobLfCqATF0tzhfkT+1UshvbJYn+H3QZ7FhIGfFvqrs69kDWqAndzT2Pko=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SJ0PR10MB4749.namprd10.prod.outlook.com (2603:10b6:a03:2da::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.31; Tue, 26 Mar
 2024 13:39:32 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ae68:7d51:133f:324]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ae68:7d51:133f:324%4]) with mapi id 15.20.7409.031; Tue, 26 Mar 2024
 13:39:32 +0000
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
Subject: [PATCH v6 08/10] scsi: sd: Atomic write support
Date: Tue, 26 Mar 2024 13:38:11 +0000
Message-Id: <20240326133813.3224593-9-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240326133813.3224593-1-john.g.garry@oracle.com>
References: <20240326133813.3224593-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0004.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:150::9) To DM6PR10MB4313.namprd10.prod.outlook.com
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
	9UrGTh58tq1OzkJPqky6jgV2qvK983Ls2L4pxS3wBy4hEJQectNBmPfKV5Eh/Tsgto5D6C2zFvRNvIR4XMOnZwGOrk4LV6Rw+uSacp7n9S1CbBvsI5pBi4E1eMQJ4J2pKtRDIQVjFAV3j2rFHgN3gJQa9WxwHqnmOtM3uGoYMB8lFRZLTRTCxTyaOWW3MvlMe0YFbbKfjw50w9zpSrJ2dgUwH+IhVAmNi6seLZTArKEVCKF/qw14we9LK+afgUwwdo0ow/3x6xIh5DFY4rN7tgAr+yzvUntyqzPPBI4dUpL5j/To5DM7+/iQuRrw0lYRagrSzDKe5Dgm7K94qjvqe2QZg/jYwfzQ3BRHq3suCatXKFs/CDVNEtCIbvSgX8nCihAI6uHnERADdglbYpc5qUuZ+yqWOBlguTDSPdmO3d5pyQ9HWgukjIWyQ/SZmXh2KlC9U50jwLkBozwGlr1KyTExlw8sPqmplOh//kFC4GwIpU6stZI1MnTt1ktHMLoWfrR1bF416pWgxlCkyXExJo9GVG/jl6mNcJMXbgfmMomvctT/1L17oITczvXSd2sxG+GlkOGzsRv61IUQZWKPxV6V0FRintzDaIKWOK0+8CYkDLCBz7IteKYE/SMEE8YILfstTI3CUAMiALeohKjbLzY2w46+2RX9zEKmvAgcgJG+oD9sSIDmE+UU1rOCDAllHEFeaGqvTFDFFacXNIFkdA==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(7416005)(1800799015)(921011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?K3+AseqdM/NyMLV7HkXjnJfMgiQLHFpzIwV8fJZBCrPJ7ZlTlAqO0M2uyy/2?=
 =?us-ascii?Q?H7ileAcKeWIarWexHlwL7Tk31YIGxG6e4ngE8ZgQ8YQeYTXBNzIh7KXlwkuY?=
 =?us-ascii?Q?p2trafAloDDkaw4z/2HnjJ2n3TTUOC+YV02PxIbV9PuQTZr3KZbYBRD4L3W+?=
 =?us-ascii?Q?fMqeQhhIGnq18lotq7SZC9QmHI7MNny7NTVoj85IkDwxBNDEH/OnNgFhrJVI?=
 =?us-ascii?Q?qFWb66sNTrL0phJRJFAzEVcdq8vN3Cdvs9o830YQBhIcavAX5gSFnz/giBuH?=
 =?us-ascii?Q?z9EC+79bPpx5XTQ6qd02qxBNWA6y80xMUgXlWtmb+WIOHqmNeWu2bEu2DjEo?=
 =?us-ascii?Q?NrrvTZiwiGtcCVm2i/aF2zNVTipw4+1Ak8xIjVFF5LgyDC4Jets5TRYdqLBz?=
 =?us-ascii?Q?uQClM4MT3JZ5UNeNnUV1Ej7h5h1zosVbgSk+xOxC7rUEfZ210vFero/4/Q2o?=
 =?us-ascii?Q?OzXEQLILh/QVwYWtD51TuEE2OJYNJo0wcLAVydHDsYC3LZKz5uZbAx/KabQK?=
 =?us-ascii?Q?em4+w8ZFiUXKfHDUvE+MjYFVV26qcszZKR4c42UunuL4FkjjpF9qMUgSfqMK?=
 =?us-ascii?Q?xVez9SvPTaZytzSOiqZLs3S4rbtDPqt8QTAja2YbAsZ0KG6jbC3nsdaQ7Jxe?=
 =?us-ascii?Q?U8AnZWCkhPJwAx0ixOIpwTlWcV32g7sP1OH+oyRPIbsBVPqClqcrpSyetku/?=
 =?us-ascii?Q?URvXm6UChIlD4uzPviqEsT21PRkgK1M0wLcCkFkRmZeGxVmN18gkL/rzZGeV?=
 =?us-ascii?Q?z4MmVQ4iVN/vkKQuhMdUWHxNEBAnEQni9g+pAp2yvf00ngr8Xo1fn6SeiV8s?=
 =?us-ascii?Q?UxyUQRutw5+iN4ZUyAhA/dHnitl7TbmlAj7iEnQkIhdcY5XAkb2IOFmu2cXI?=
 =?us-ascii?Q?o83p0p/uZnOEn+9qzmUBp/pIbDJPRf8pfJXUsrxqHQnFPdeGq/kk9as6TiE4?=
 =?us-ascii?Q?JR+graxiNNj0f3bOQohQCtTVw6X77OMLufw9X8iSmM5Tkb4UO4W++NzyxYFy?=
 =?us-ascii?Q?wr6iB9VVRtDxs1//18lp9iaA9yQeY4wWkoP/aqkv7+jvuZvKDwgp2Apof50C?=
 =?us-ascii?Q?yudEeZOPZE5RwFTlFuPw3VBMHZFsgBjYEpu7VdpwwH4CtY3s5rbdDxiWdNq5?=
 =?us-ascii?Q?Dcy8xusp4Cg2J6Iod6KHPCBf4iEE/r6NSjDnbL12mrV3Z8Z4JAID9t84m+es?=
 =?us-ascii?Q?z+Jprsvec81QHneGUKIcZOkX9Ltxc/nvPMI4t/ANmuQhoMAPxuD+KFtNokS4?=
 =?us-ascii?Q?IB2K6TGdOrrP3PtCMjyVqsG7hoPty9n5ldMOCpEuQpkhezxbeh5s4QnOe0gO?=
 =?us-ascii?Q?vZTlZeor7KZVTakkyEm+EMlbTC40p3S5T7mK7XKiTODspMtVmaGPjhDOGKrC?=
 =?us-ascii?Q?NUxPGWPwUZsFN1ea59XscmNhkXcUadyL+5n3B6JENnD0kJw/dEcbYGA1UfYy?=
 =?us-ascii?Q?mrUVbesZwV0wpdJb4WMWaPxhxrB7lUOQJoEdJMltMXhTCByFlNynTmNDfw64?=
 =?us-ascii?Q?tzYvkaQ0QgrfVTxFXCi6QWSgyn38f6Xv/zCJIwehbdlkoTNJxzAzZVFiT0zA?=
 =?us-ascii?Q?9X+ro457gcZWmpQkgsI7ziznmPXVoixbW+lu/+lHnsMwweG5Ql1WhRXZVcOt?=
 =?us-ascii?Q?Ig=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	Kwt6HmdBbiAjfQ2G2v4cj6gfvMpKwHijNde01GW0ifvPRkproLgNGNm1gXFWRdxoR1Fk8WQ0GcvvBWnjeld5InZjVA1Ygg6onCjvRSUl0dLFhUnTJts7JCJMODcvCoGJdsA9J1pUQoRSS4ZEn4TGgAaUoMM9l8ljjHdPcf0G8+kZnF6XLzht1SLAOJuNeufXdFALR7Cfz/r5h11VlzetKe2OFWBVCqcIgVPoEtTSpaE4FQKdJMijmFGpq2c1LgDsLiBH1WOM3rKeFOBwizJi/66hKhHN/bsddN4vr+RYxyLDlu2ZYNpsUjUSyj3PVFmRJYK31tpzpqevTo/WZf4ohkg1V5vPZpc4WAW2Jh0R2081DKr0VOH+Ik+GCWSTE1NWKP1TEH7AqfghiFnuHSEsL++/Pt7nwlX4dw2R9gDpNL/2bdHsXwGs8Hyv/3qdDK+4tXRJanmD9o/ZNGw+KhAi9MfM0PnHvj1BFpOVzbGp1H5OoTpNrqsL0Ap8MbiykHut42MdpaCzRdH6NCcR1qTMNaD/zVvETslsCJjVvc6j8JG9MUV33UnWnLv5WF4krbUCJ8a9kg0d1vbMWHZD1GV9veues5dAuZowd0hSLbs/Xs0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 265f7778-ea66-433a-1ad2-08dc4d9a2ae2
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2024 13:39:32.2395
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9GPbfy07pXoy54EDp0lU9FTtD/dTKPF5Tywl6HhwHNxFPBwsnSx4suEzcni4tUe3w0RjWWcuZBTiKhu0Y4omdg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4749
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-26_06,2024-03-21_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 mlxscore=0 adultscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2403210000 definitions=main-2403260095
X-Proofpoint-GUID: 9OJN8y4faa2TxX0uyeJjKBsMWn-Z4ICJ
X-Proofpoint-ORIG-GUID: 9OJN8y4faa2TxX0uyeJjKBsMWn-Z4ICJ

Support is divided into two main areas:
- reading VPD pages and setting sdev request_queue limits
- support WRITE ATOMIC (16) command and tracing

The relevant block limits VPD page need to be read to allow the block layer
request_queue atomic write limits to be set. These VPD page limits are
described in sbc4r22 section 6.6.4 - Block limits VPD page.

There are five limits of interest:
- MAXIMUM ATOMIC TRANSFER LENGTH
- ATOMIC ALIGNMENT
- ATOMIC TRANSFER LENGTH GRANULARITY
- MAXIMUM ATOMIC TRANSFER LENGTH WITH BOUNDARY
- MAXIMUM ATOMIC BOUNDARY SIZE

MAXIMUM ATOMIC TRANSFER LENGTH is the maximum length for a WRITE ATOMIC
(16) command. It will not be greater than the device MAXIMUM TRANSFER
LENGTH.

ATOMIC ALIGNMENT and ATOMIC TRANSFER LENGTH GRANULARITY are the minimum
alignment and length values for an atomic write in terms of logical blocks.

Unlike NVMe, SCSI does not specify an LBA space boundary, but does specify
a per-IO boundary granularity. The maximum boundary size is specified in
MAXIMUM ATOMIC BOUNDARY SIZE. When used, this boundary value is set in the
WRITE ATOMIC (16) ATOMIC BOUNDARY field - layout for the WRITE_ATOMIC_16
command can be found in sbc4r22 section 5.48. This boundary value is the
granularity size at which the device may atomically write the data. A value
of zero in WRITE ATOMIC (16) ATOMIC BOUNDARY field means that all data must
be atomically written together.

MAXIMUM ATOMIC TRANSFER LENGTH WITH BOUNDARY is the maximum atomic write
length if a non-zero boundary value is set.

For atomic write support, the WRITE ATOMIC (16) boundary is not of much
interest, as the block layer expects each request submitted to be executed
atomically. However, the SCSI spec does leave itself open to a quirky
scenario where MAXIMUM ATOMIC TRANSFER LENGTH is zero, yet MAXIMUM ATOMIC
TRANSFER LENGTH WITH BOUNDARY and MAXIMUM ATOMIC BOUNDARY SIZE are both
non-zero. This case will be supported.

To set the block layer request_queue atomic write capabilities, sanitize
the VPD page limits and set limits as follows:
- atomic_write_unit_min is derived from granularity and alignment values.
  If no granularity value is not set, use physical block size
- atomic_write_unit_max is derived from MAXIMUM ATOMIC TRANSFER LENGTH. In
  the scenario where MAXIMUM ATOMIC TRANSFER LENGTH is zero and boundary
  limits are non-zero, use MAXIMUM ATOMIC BOUNDARY SIZE for
  atomic_write_unit_max. New flag scsi_disk.use_atomic_write_boundary is
  set for this scenario.
- atomic_write_boundary_bytes is set to zero always

SCSI also supports a WRITE ATOMIC (32) command, which is for type 2
protection enabled. This is not going to be supported now, so check for
T10_PI_TYPE2_PROTECTION when setting any request_queue limits.

To handle an atomic write request, add support for WRITE ATOMIC (16)
command in handler sd_setup_atomic_cmnd(). Flag use_atomic_write_boundary
is checked here for encoding ATOMIC BOUNDARY field.

Trace info is also added for WRITE_ATOMIC_16 command.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/scsi_trace.c   | 22 +++++++++
 drivers/scsi/sd.c           | 93 ++++++++++++++++++++++++++++++++++++-
 drivers/scsi/sd.h           |  8 ++++
 include/scsi/scsi_proto.h   |  1 +
 include/trace/events/scsi.h |  1 +
 5 files changed, 124 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_trace.c b/drivers/scsi/scsi_trace.c
index 41a950075913..3e47c4472a80 100644
--- a/drivers/scsi/scsi_trace.c
+++ b/drivers/scsi/scsi_trace.c
@@ -325,6 +325,26 @@ scsi_trace_zbc_out(struct trace_seq *p, unsigned char *cdb, int len)
 	return ret;
 }
 
+static const char *
+scsi_trace_atomic_write16_out(struct trace_seq *p, unsigned char *cdb, int len)
+{
+	const char *ret = trace_seq_buffer_ptr(p);
+	unsigned int boundary_size;
+	unsigned int nr_blocks;
+	sector_t lba;
+
+	lba = get_unaligned_be64(&cdb[2]);
+	boundary_size = get_unaligned_be16(&cdb[10]);
+	nr_blocks = get_unaligned_be16(&cdb[12]);
+
+	trace_seq_printf(p, "lba=%llu txlen=%u boundary_size=%u",
+			  lba, nr_blocks, boundary_size);
+
+	trace_seq_putc(p, 0);
+
+	return ret;
+}
+
 static const char *
 scsi_trace_varlen(struct trace_seq *p, unsigned char *cdb, int len)
 {
@@ -385,6 +405,8 @@ scsi_trace_parse_cdb(struct trace_seq *p, unsigned char *cdb, int len)
 		return scsi_trace_zbc_in(p, cdb, len);
 	case ZBC_OUT:
 		return scsi_trace_zbc_out(p, cdb, len);
+	case WRITE_ATOMIC_16:
+		return scsi_trace_atomic_write16_out(p, cdb, len);
 	default:
 		return scsi_trace_misc(p, cdb, len);
 	}
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index ccff8f2e2e75..60046299844f 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -917,6 +917,65 @@ static blk_status_t sd_setup_unmap_cmnd(struct scsi_cmnd *cmd)
 	return scsi_alloc_sgtables(cmd);
 }
 
+static void sd_config_atomic(struct scsi_disk *sdkp)
+{
+	unsigned int logical_block_size = sdkp->device->sector_size,
+		physical_block_size_sectors, max_atomic, unit_min, unit_max;
+	struct request_queue *q = sdkp->disk->queue;
+
+	if ((!sdkp->max_atomic && !sdkp->max_atomic_with_boundary) ||
+	    sdkp->protection_type == T10_PI_TYPE2_PROTECTION)
+		return;
+
+	physical_block_size_sectors = sdkp->physical_block_size /
+					sdkp->device->sector_size;
+
+	unit_min = rounddown_pow_of_two(sdkp->atomic_granularity ?
+					sdkp->atomic_granularity :
+					physical_block_size_sectors);
+
+	/*
+	 * Only use atomic boundary when we have the odd scenario of
+	 * sdkp->max_atomic == 0, which the spec does permit.
+	 */
+	if (sdkp->max_atomic) {
+		max_atomic = sdkp->max_atomic;
+		unit_max = rounddown_pow_of_two(sdkp->max_atomic);
+		sdkp->use_atomic_write_boundary = 0;
+	} else {
+		max_atomic = sdkp->max_atomic_with_boundary;
+		unit_max = rounddown_pow_of_two(sdkp->max_atomic_boundary);
+		sdkp->use_atomic_write_boundary = 1;
+	}
+
+	/*
+	 * Ensure compliance with granularity and alignment. For now, keep it
+	 * simple and just don't support atomic writes for values mismatched
+	 * with max_{boundary}atomic, physical block size, and
+	 * atomic_granularity itself.
+	 *
+	 * We're really being distrustful by checking unit_max also...
+	 */
+	if (sdkp->atomic_granularity > 1) {
+		if (unit_min > 1 && unit_min % sdkp->atomic_granularity)
+			return;
+		if (unit_max > 1 && unit_max % sdkp->atomic_granularity)
+			return;
+	}
+
+	if (sdkp->atomic_alignment > 1) {
+		if (unit_min > 1 && unit_min % sdkp->atomic_alignment)
+			return;
+		if (unit_max > 1 && unit_max % sdkp->atomic_alignment)
+			return;
+	}
+
+	blk_queue_atomic_write_max_bytes(q, max_atomic * logical_block_size);
+	blk_queue_atomic_write_unit_min_bytes(q, unit_min * logical_block_size);
+	blk_queue_atomic_write_unit_max_bytes(q, unit_max * logical_block_size);
+	blk_queue_atomic_write_boundary_bytes(q, 0);
+}
+
 static blk_status_t sd_setup_write_same16_cmnd(struct scsi_cmnd *cmd,
 		bool unmap)
 {
@@ -1208,6 +1267,26 @@ static int sd_cdl_dld(struct scsi_disk *sdkp, struct scsi_cmnd *scmd)
 	return (hint - IOPRIO_HINT_DEV_DURATION_LIMIT_1) + 1;
 }
 
+static blk_status_t sd_setup_atomic_cmnd(struct scsi_cmnd *cmd,
+					sector_t lba, unsigned int nr_blocks,
+					bool boundary, unsigned char flags)
+{
+	cmd->cmd_len  = 16;
+	cmd->cmnd[0]  = WRITE_ATOMIC_16;
+	cmd->cmnd[1]  = flags;
+	put_unaligned_be64(lba, &cmd->cmnd[2]);
+	put_unaligned_be16(nr_blocks, &cmd->cmnd[12]);
+	if (boundary)
+		put_unaligned_be16(nr_blocks, &cmd->cmnd[10]);
+	else
+		put_unaligned_be16(0, &cmd->cmnd[10]);
+	put_unaligned_be16(nr_blocks, &cmd->cmnd[12]);
+	cmd->cmnd[14] = 0;
+	cmd->cmnd[15] = 0;
+
+	return BLK_STS_OK;
+}
+
 static blk_status_t sd_setup_read_write_cmnd(struct scsi_cmnd *cmd)
 {
 	struct request *rq = scsi_cmd_to_rq(cmd);
@@ -1279,6 +1358,10 @@ static blk_status_t sd_setup_read_write_cmnd(struct scsi_cmnd *cmd)
 	if (protect && sdkp->protection_type == T10_PI_TYPE2_PROTECTION) {
 		ret = sd_setup_rw32_cmnd(cmd, write, lba, nr_blocks,
 					 protect | fua, dld);
+	} else if (rq->cmd_flags & REQ_ATOMIC && write) {
+		ret = sd_setup_atomic_cmnd(cmd, lba, nr_blocks,
+				sdkp->use_atomic_write_boundary,
+				protect | fua);
 	} else if (sdp->use_16_for_rw || (nr_blocks > 0xffff)) {
 		ret = sd_setup_rw16_cmnd(cmd, write, lba, nr_blocks,
 					 protect | fua, dld);
@@ -3220,7 +3303,7 @@ static void sd_read_block_limits(struct scsi_disk *sdkp)
 		sdkp->max_ws_blocks = (u32)get_unaligned_be64(&vpd->data[36]);
 
 		if (!sdkp->lbpme)
-			goto out;
+			goto read_atomics;
 
 		lba_count = get_unaligned_be32(&vpd->data[20]);
 		desc_count = get_unaligned_be32(&vpd->data[24]);
@@ -3251,6 +3334,14 @@ static void sd_read_block_limits(struct scsi_disk *sdkp)
 			else
 				sd_config_discard(sdkp, SD_LBP_DISABLE);
 		}
+read_atomics:
+		sdkp->max_atomic = get_unaligned_be32(&vpd->data[44]);
+		sdkp->atomic_alignment = get_unaligned_be32(&vpd->data[48]);
+		sdkp->atomic_granularity = get_unaligned_be32(&vpd->data[52]);
+		sdkp->max_atomic_with_boundary = get_unaligned_be32(&vpd->data[56]);
+		sdkp->max_atomic_boundary = get_unaligned_be32(&vpd->data[60]);
+
+		sd_config_atomic(sdkp);
 	}
 
  out:
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index 5c4285a582b2..bc376ebb37ac 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -121,6 +121,13 @@ struct scsi_disk {
 	u32		max_unmap_blocks;
 	u32		unmap_granularity;
 	u32		unmap_alignment;
+
+	u32		max_atomic;
+	u32		atomic_alignment;
+	u32		atomic_granularity;
+	u32		max_atomic_with_boundary;
+	u32		max_atomic_boundary;
+
 	u32		index;
 	unsigned int	physical_block_size;
 	unsigned int	max_medium_access_timeouts;
@@ -154,6 +161,7 @@ struct scsi_disk {
 	unsigned	security : 1;
 	unsigned	ignore_medium_access_errors : 1;
 	unsigned	rscs : 1; /* reduced stream control support */
+	unsigned	use_atomic_write_boundary : 1;
 };
 #define to_scsi_disk(obj) container_of(obj, struct scsi_disk, disk_dev)
 
diff --git a/include/scsi/scsi_proto.h b/include/scsi/scsi_proto.h
index 843106e1109f..70e1262b2e20 100644
--- a/include/scsi/scsi_proto.h
+++ b/include/scsi/scsi_proto.h
@@ -120,6 +120,7 @@
 #define WRITE_SAME_16	      0x93
 #define ZBC_OUT		      0x94
 #define ZBC_IN		      0x95
+#define WRITE_ATOMIC_16	0x9c
 #define SERVICE_ACTION_BIDIRECTIONAL 0x9d
 #define SERVICE_ACTION_IN_16  0x9e
 #define SERVICE_ACTION_OUT_16 0x9f
diff --git a/include/trace/events/scsi.h b/include/trace/events/scsi.h
index 8e2d9b1b0e77..05f1945ed204 100644
--- a/include/trace/events/scsi.h
+++ b/include/trace/events/scsi.h
@@ -102,6 +102,7 @@
 		scsi_opcode_name(WRITE_32),			\
 		scsi_opcode_name(WRITE_SAME_32),		\
 		scsi_opcode_name(ATA_16),			\
+		scsi_opcode_name(WRITE_ATOMIC_16),		\
 		scsi_opcode_name(ATA_12))
 
 #define scsi_hostbyte_name(result)	{ result, #result }
-- 
2.31.1


