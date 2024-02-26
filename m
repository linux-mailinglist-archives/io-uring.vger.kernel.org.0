Return-Path: <io-uring+bounces-749-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A3CC0867EF0
	for <lists+io-uring@lfdr.de>; Mon, 26 Feb 2024 18:40:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C74BD1C2C675
	for <lists+io-uring@lfdr.de>; Mon, 26 Feb 2024 17:40:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BFE412E1ED;
	Mon, 26 Feb 2024 17:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="m0ZeUM4k";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="bgt2peXC"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41AE0131E27;
	Mon, 26 Feb 2024 17:37:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708969062; cv=fail; b=OPoMlnBsKj2vaw4J1/hz6uzukQRsnFzXAaBvrCmGnzYMu1/e7PXl30+yCKPoIdoXhkqrSgZVPBffdky2Xn9b3gP6XtglKBpXPuHHVwa46hIpd5+exMi5kafzF5Gzb/31apOOjBkd0w9Z13rJdNqpBtjfHucPhkKAVCZg3vMHSwk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708969062; c=relaxed/simple;
	bh=odZlsa/cx2ncQ/+LrbueYmXjt6zmVVz7xjnIBIcC384=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=hYFgyWjQxJR3wqx9X1Jy4qb+v+aML7LNLjA8F4aM8dSE+84nBsX5dNnBulLOr/87tV5GKNT/UaNdXf+iioVBmjfOiksGkJwpK2kzCxZO4clAbQERiFs6ghAhDEXfbnHKPo1CY7miffn8j7eP+jHRLsX1bAiHy/5rhJioIyd40Hg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=m0ZeUM4k; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=bgt2peXC; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 41QGnPQP021404;
	Mon, 26 Feb 2024 17:37:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-11-20; bh=DIdDKea3cdStt5bdShr2QzUfCq9xDEYo8CdFe8lEs7M=;
 b=m0ZeUM4kjR5/i+KWnNDBCa3yXKjsj62/ElbTUrFE6b+VHXM7akmC+GAkE1B3Oqfw7EHU
 54kSDnRC4smvWRXoYcn2jCg6efE0KjZ7ImbeQ+qPu29ULUKFTY/JLS+p/yu7eLD+2I6r
 kBEVg9IX6kjEUQUokPhKcq3/i5rOOFkcolwrIzZpBibTz9V6qHVQ0Eo+kgzotcpxGTtS
 r3JOBIAQKkf6xqVVsYpmB0yjMJ7tR8AE1bwplpiPVkvpjjR1IO4SQ8Jt3WErFYP+VmUT
 SOrJGdZsn/Mr5pXASZ37/QQhzZcSxVR8Mbb/G4vkJNiZ3S69OB3InDfE5SUMhBfX4cT5 hA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3wf722d664-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 26 Feb 2024 17:36:59 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 41QHKxUB015331;
	Mon, 26 Feb 2024 17:36:58 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3wf6w64um4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 26 Feb 2024 17:36:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FldQrySl+1bHUGEe17UGdV3iG7bWFRuh5uhOJnNDcLxBN8so6El8/tV4YXdd+ocKuWrCnYGd7Jbk8hOZETrh57pIbjJpj1OKbuyBPYjVYIG9Cj0qDK4h+v+yC5A2zE+DKQcupDxDptFZn5Apefv48R+oXA9j1l3AaJlQZa8J8AafTEt7ckpU2wH3KwFKMKO7t9qswnR4zzWwPteAdwqr/xLW23nIz9v7oBCLWypAGJ4ayNsoPOWLHEFNO3SnSoYnAJfAY6m5qeIAfZumU+5ttOCYttggOuxjqOROX8Rrx+i+uQmyUyvwye0QsTp8pitlFd80FBsGJdKKowxx0yPNNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DIdDKea3cdStt5bdShr2QzUfCq9xDEYo8CdFe8lEs7M=;
 b=hGFk/xA05hKW6gjSumK7dSCQE/akK3xyAgqMpoEzPqkpnLtbX5cwzmPwAPSS30pML/E56pKmkbARr4ITq3VQaLLHpnF1hTmPYdi/DaxplEO1dwxuGgFjcpOOJoGKJYBmI5s5C8bw8FVp82/H0gQ3DNOxD/eanxSZwewF3cYHpGQmFfsLruyJ191N7EEJcjVdbv29IMeiOwsZVaEc9gR50NOe9ih6t9Sc1PT4OmDzaNgkeBpoWsjs7Lk7OBW98ih9umywtVzBmKFf970Rt6vTgUQz5BxsmRhzsu9dNwO090FMuO56f0dIjJ6XtXrNlnYW+Mj8egjhvZuMMK+aFTbmuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DIdDKea3cdStt5bdShr2QzUfCq9xDEYo8CdFe8lEs7M=;
 b=bgt2peXCrhImba7nR3qIibxzRs3RnK80MeAi2lgH3Ej8L2y4Xk4Xhhst9lzof9jGAb5DeC4p4QvJKkWaOX37mrbwCDmii7+ZtDTBgDDeoFrWV/Gz97svMl/T5Z6hbnODstl31IJyYQ8Htiigm8zDjpSCauGBB1HYJKBW/ZknK1I=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by MW4PR10MB6298.namprd10.prod.outlook.com (2603:10b6:303:1e3::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.34; Mon, 26 Feb
 2024 17:36:55 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::97a0:a2a2:315e:7aff]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::97a0:a2a2:315e:7aff%3]) with mapi id 15.20.7316.034; Mon, 26 Feb 2024
 17:36:55 +0000
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
Subject: [PATCH v5 08/10] scsi: sd: Atomic write support
Date: Mon, 26 Feb 2024 17:36:10 +0000
Message-Id: <20240226173612.1478858-9-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240226173612.1478858-1-john.g.garry@oracle.com>
References: <20240226173612.1478858-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH8PR07CA0015.namprd07.prod.outlook.com
 (2603:10b6:510:2cd::20) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|MW4PR10MB6298:EE_
X-MS-Office365-Filtering-Correlation-Id: d5b462ac-2ad7-4694-3ed0-08dc36f186c0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	8N+BYY6bllzBxsjNfIglyjunELJnZuxU114Mt8Y8NuvYOR1VxWfBWEzSYInZeFEtWv04U18ez8sGkowC+B36zf4CsBiTlTVH9pW3bPMBevIy03b5b+5iYla/lT4Q1ePZ0Bc1l12D81/znluXAWHozxO4CUiDh3QyfOBblMdwfWcR2AmrZeVyw8ZjTkKdn56OyuO9UsqagKLVyQO8EUdLgQhCppEgX1B69i3qK+fQjSUB2FBY5OS8cCmjlEr/vujgkds30l7Ny6VvcsYpqc0VkmOI958acYGsu1M4KwrRFpiSzldqezBVey0pNTwWYckuK54r+D+lYk7u870ADiQLh6WutHNIYm02GveUMcS6jAsCFOscy9pxTG6sj9MPYGk/yIRUYCsfDegSd4k/7QYK7gy5qbbLSOfMHBuxkwjHTntIIu6RtWgjJzIBvEilnZTe1CmpoU1EoI8/46/YIxMW67tUmnGmVrJvWjMyFfmQyDhyNoKeqfiZyL5kd/JDhgVrLmgX11S43KNh5QWEwaF75RtCR8hxalcTOPQVnZlbYL+Q3MzUg12DgT8Uq39lYh1wWZluRIvHU87KxXsGrfIm5RYKK8+pvOpHn29snJT9ygDdlOzdP6PpNRyjwafqgjal8eWgzfpq8bsztI/qMXg0rcJv5bCvkNpsVcJ5rSSUSr1vPFdP/vbetTj/VUPaQtEjEAP3vTj9p8nALUKkzEU+xg==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(921011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?76U7p/kI04BOixMbv9YNNarnKYgCaEIutF1rqeyzrP9dY6fjyEt7Q/xlycnP?=
 =?us-ascii?Q?x1ZI4CApLu4saplO8gvo1YZBUqIA7NPCnXR+TTdHiAD7waE7dj86EPUfmBVx?=
 =?us-ascii?Q?kKiTkvc1fguKrKCHKGVle4ELsc7herSy0Y2ADRM7+qSlz1vDNHUDc87OrwxY?=
 =?us-ascii?Q?gfxMVCEOknfzVaL6FlMXwUwgIprspu7iE7UWADKxLIhI2y0EeQ9PWIgnhWn6?=
 =?us-ascii?Q?6Y+SV+35BOqI1xnOWH9ogN28YBsl4hLvxWzNBMTeHS3QPBRDbUR8jBM2/5wo?=
 =?us-ascii?Q?Ir5Pi3E6mE10GaMit2U7BP/B1X7FvVI6Mu9AJat1W0IQMd+TWnjb1gmtJV4n?=
 =?us-ascii?Q?qxivVqxcEeca4Kujst9VFLBHJM84JMMaE6BQGZZVpdsNPYDxejI9mTjOPf+g?=
 =?us-ascii?Q?rIeGJcM3Nb2BFpAcRAY1USk6xuTGqplrgk06GU5G7u496huoYU8GlRzmYUto?=
 =?us-ascii?Q?m6/Tk8M8K8HtQpfFn/x+8++xPBl4Z776fM+JH4CZ+2HeGxIs+CUXNKoNum5l?=
 =?us-ascii?Q?vehOXLjbYO94LqjJO/0cxeAu/YkPnas1DxPQ998c7OQFEDcZGbTVGu8UPM8t?=
 =?us-ascii?Q?ay9G4VM9HwbMdcopi05at1B6nt9lurPAb2w8GXDyweHvOugXQx5QuIB0c3/o?=
 =?us-ascii?Q?hfwSaF/rispiYzAMCqDlGFYVy5oXnFZBr5KidyjQDyNAgNp6h2vmz/+haRGd?=
 =?us-ascii?Q?MCb34XjVilUQV9q+nNJYNqsCndaw7zBuRn+EyEqRSz20DWAuFWcFED0kVNhr?=
 =?us-ascii?Q?1KHpZ3EDgwuf2HtxafH3C+vn7L1y0Ymx6+mYzKJYfqdSOAmSAS1K0H3ppzn7?=
 =?us-ascii?Q?1m9CynJOpaP2740/LhUjKVrDmS0Rw+rUMhTGIvEA3GL6hUPZPN9jXMSJs1mi?=
 =?us-ascii?Q?sqJZlJkWSOb6+93ePFdHiXGv3zn5HLwfCeczr/Z+mEcw1ncxm+gZfqm6E3ac?=
 =?us-ascii?Q?fuu73QZeL7IKUpc64cwOoZ5LWtqavYaC0d7oVhQ391Kjk58v3Pcuz775BYnu?=
 =?us-ascii?Q?C9Emwvrpr4Z2HOyNDNs1Xb6Ak8CuG0sUvpIKTnLJRfqZa1uhceKkQs4mHtKp?=
 =?us-ascii?Q?y+0eiXyIoewP5AvBhKdWVF/qvhWAyg1KbvH5QzfoiypHpQzKmEaphQJQI0Qc?=
 =?us-ascii?Q?aotuZ0p0E0Gm4REX5nLWRiEibe8vt2gkf3qqIOaunvXi4X9NMmcLT/+u4cJx?=
 =?us-ascii?Q?YwqpSABmv+XZkDc1GmI9Xa/N9ZwaiGBKX7puJr1TxY/v4G92pqgO1qB8QMwx?=
 =?us-ascii?Q?xaEW5/odog3t+Gz4fYT98eHIHEa7w5howE8cA0y752e2GcwRl2UQ+TA0I1sb?=
 =?us-ascii?Q?QMXCGOGZV9sylHscu0x72dX08qSPl2jWizVqtzxtq9b4xOsit6FYVE7QfgyM?=
 =?us-ascii?Q?p4cR07m8JyIcO98HukLE8gaPUPrYr87BueYDBK5jJkeZyJ07rdYz3ZSIRCOC?=
 =?us-ascii?Q?FWpz0g+mgg96zvBrmHy4snRhbAmbogYAqzVlqQ3Me+7CVgI2gTBA2NP3d3TI?=
 =?us-ascii?Q?Dnuufxu8VaNlG8Rd1q340JlkMvbtCB8cebb7o/rhA+kOBoB1LxOYFrXR1fcC?=
 =?us-ascii?Q?7XnQV/fsUmqIlBKny2B45xYU/JQXAbi/eXKhQVofGJ8ioMqUyHCsYvBs2bDD?=
 =?us-ascii?Q?6A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	Qowr4AZLLQj+UqPikrOM4ucL9GMDzidIf7GB7lPGlsDG5mVksPar1jWiSY6KFNuHEpcthT92n4x61HbLww+Wx3dNjKjwj8S3vyLfNf+865mxoxPUDh+FHyBPF6gTIVgfJex2f4ivVSIfXPy/NseZ36eYqZGyPyi0I4wnFdZdXFcIaa3mHCj3c/bOk/VUeNfoI8LAxdlcbDfrujkpJkuHm6JKLNXoYxhQP1B00YJiWwZnLdcxdEKWbMR1abVUDEps4hIpDFjEVuu9aNnA2MhNEqdI927GepPa8qQqJDC0+b/RczqSuVJsfc8mLbaGEmuxKkXbhwnLPjPrENFgf68JvlV9M3RJ53LH03FCbRfzYvvU9DIqrsWQDBCV/DELJszH1jY4pL/ncvve/FRivWPApAnHzB60VCzcWMkUrePZBoVPVG9YBS0MefnU+IiS589dA0wO9CLYGJYsn5O6+Il/kUu1yb5ruKqH63+dxS8au5R+7ADuc2D/xTkHJj1udcsAoVg+xD+cIqcgQqTu6hWWtUEW5HHcH501w4NAP/Q9HzCh58C6ELoH1UFd1Gl/OFH56BFhb8TvFo2TOT5S2ljyz8zIz/Fh0EPTW4/baS8lU3U=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5b462ac-2ad7-4694-3ed0-08dc36f186c0
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2024 17:36:55.7156
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0+k0JWDUpeklCiAEUXiP32Cce4RtsebKAJSVL3tUI4E7WpGRSVQDKVqhgwJWQykIQ8KL+tUt0dy0o79/Ey+dhQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6298
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-26_11,2024-02-26_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 phishscore=0
 spamscore=0 mlxlogscore=999 malwarescore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2402260134
X-Proofpoint-ORIG-GUID: jZzdI_Wlr3GJ7j1R35uewFlI5xSYNn7_
X-Proofpoint-GUID: jZzdI_Wlr3GJ7j1R35uewFlI5xSYNn7_

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
index bdd0acf7fa3c..08893b4a25c2 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -916,6 +916,65 @@ static blk_status_t sd_setup_unmap_cmnd(struct scsi_cmnd *cmd)
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
+	blk_queue_atomic_write_unit_min_sectors(q, unit_min);
+	blk_queue_atomic_write_unit_max_sectors(q, unit_max);
+	blk_queue_atomic_write_boundary_bytes(q, 0);
+}
+
 static blk_status_t sd_setup_write_same16_cmnd(struct scsi_cmnd *cmd,
 		bool unmap)
 {
@@ -1181,6 +1240,26 @@ static int sd_cdl_dld(struct scsi_disk *sdkp, struct scsi_cmnd *scmd)
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
@@ -1252,6 +1331,10 @@ static blk_status_t sd_setup_read_write_cmnd(struct scsi_cmnd *cmd)
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
@@ -3071,7 +3154,7 @@ static void sd_read_block_limits(struct scsi_disk *sdkp)
 		sdkp->max_ws_blocks = (u32)get_unaligned_be64(&vpd->data[36]);
 
 		if (!sdkp->lbpme)
-			goto out;
+			goto read_atomics;
 
 		lba_count = get_unaligned_be32(&vpd->data[20]);
 		desc_count = get_unaligned_be32(&vpd->data[24]);
@@ -3102,6 +3185,14 @@ static void sd_read_block_limits(struct scsi_disk *sdkp)
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
index 409dda5350d1..990188a56b51 100644
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
@@ -151,6 +158,7 @@ struct scsi_disk {
 	unsigned	urswrz : 1;
 	unsigned	security : 1;
 	unsigned	ignore_medium_access_errors : 1;
+	unsigned	use_atomic_write_boundary : 1;
 };
 #define to_scsi_disk(obj) container_of(obj, struct scsi_disk, disk_dev)
 
diff --git a/include/scsi/scsi_proto.h b/include/scsi/scsi_proto.h
index 07d65c1f59db..833de67305b5 100644
--- a/include/scsi/scsi_proto.h
+++ b/include/scsi/scsi_proto.h
@@ -119,6 +119,7 @@
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


