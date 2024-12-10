Return-Path: <io-uring+bounces-5376-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 97B829EA50A
	for <lists+io-uring@lfdr.de>; Tue, 10 Dec 2024 03:21:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 22A802856C1
	for <lists+io-uring@lfdr.de>; Tue, 10 Dec 2024 02:21:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DE5B339A1;
	Tue, 10 Dec 2024 02:21:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Yk1KpuBE";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="uVtSlPrJ"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99C57233159;
	Tue, 10 Dec 2024 02:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733797284; cv=fail; b=Ju35QAyI4TSDFMzQ/i2vQ916dIwZOvpvhtK9lyRfE4sVU2Rz9ZtqDRmMNO3HpHrIMj/WakqwedLqpSo25/S4vtJSxdDav6u0HcCBxIM6cFZWZegGHMu+URdJgZl9k2z8g4bs88wQ9k+rnkoSQInUNCTi+IylWlr/TePBhVTrfY0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733797284; c=relaxed/simple;
	bh=1ynfhOa4DGUcJ8z5X3lt+jb2nJMqPooQNZ+C5DtGWLA=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=RoLFNHUiMpPS333bJimPMb9D/iP8uSuahCgHMuSsvuw7DyEJ/50tPr/uO+gS5D06PSg+DbaGU73kO9s7i/GfSDVUPQE91d3Jf7iMLuREdVCatFeEOS5rlPFCWCTdMVu92k4U2fB7ph7cOHXfg7Jc9302RDxcQzhPVYW+Qef39eE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Yk1KpuBE; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=uVtSlPrJ; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4BA1CH3R025289;
	Tue, 10 Dec 2024 02:20:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=0w/k9WaDZxf10Mg7gp
	cFZyvRUr0+uXDtcpFVZImkn3c=; b=Yk1KpuBEAoudNqdg9RBFGDiNQNNUsjlxFd
	XJR6wN7k0CC2+RXjtKEqrshDBPDQ5dwSWn/JLwcGusl9CUBEQZKUeG171QZUlab1
	Yl8LgPG0CFB/R7k8P3VNewVAviOpjM0MCo57tRgTcsvVbdYrsM3Sq+t6ClvSGJog
	E4UC2odn0KARgINP/ongZEb1SwPrDPE/iOasfk1/GLijt/+Hn5c875XlDiHN25O/
	9mI34fm3xoomoCZy/7jLRqCVkoP+ypksqgVagskvz2EKejqzSqEM5ySKwXVf6NGi
	zefN6K1poyzYo2UGFIP8uu+DB92wBDeoIOCxlWMbW/KO/WfB+i+w==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43cewt4q1r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Dec 2024 02:20:49 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4BA1jAY6035082;
	Tue, 10 Dec 2024 02:20:48 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2046.outbound.protection.outlook.com [104.47.70.46])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 43cctf7ntg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Dec 2024 02:20:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hMFXy4opyIZI8TQUMxykAQwn3nqxtJs4hIgFwaBze4k37wY4jdP/oz5H+byjru+oG/NFwb9mYw0RwWOI0csZbBSJHNUambFjGuC0wBoGy1Aed4A6P5W4w+Zx4gDHECnnnNpkwb8tw0BPdWh3AVQYGtmjFvhNU6rWIHi4JsVkdKi6EsxgIbbV+XnD7PoyuCJtvBPFEYVuvqT2yJY4Cpwlvy0AFwcRXFSN8axFedyVaYUA7F2Bz4p6O7yGXNUbrB3O82AqN7uySNq0jPf8zoVCyNgkDiTUZJ/orede1MmSa+R2ReVSV0EfD8+fnXYi1kVvCCeDgVtalrmcCC3K/cp77g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0w/k9WaDZxf10Mg7gpcFZyvRUr0+uXDtcpFVZImkn3c=;
 b=YDXw042mje2K+B+mWdcFDH33KttJ5NiglAO8sz5cItGY+7dni7vB01FtsApsJ3w2r1FLulvS9gYQHMVdoJPoqGcrK4KGY7yvWanTyO7uZ6qysbNlOlMxf+WQiVJKknqcYVYadPLp0O3AaAWH+dWiAI1RtNEpUaGCu0ce+8yhcqUj17WMcGuGNpgT4EFawVbITzAA+JEJl0sgN+mxOWEMFvN4IwkRrtWoX7tbO+ejJfA7ckxlGpl03WIxUffRf2P+F1EDU/MGIcvTKtHbFLnMeJI39X3sBSoEBt+GkcHTY8it9Qg2wCFD15p4kX570wCPQR2VIn9tAlYJLE5IRjKKBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0w/k9WaDZxf10Mg7gpcFZyvRUr0+uXDtcpFVZImkn3c=;
 b=uVtSlPrJ8VL3MNZS5/d8M5UVN+tTVsmwBnRJIIYeFvn2hGsS13QeqZnGjJQeoDJ1vCIRpDLAjGR+rqxmr3nKqm+fWMB5+mdregaVCvSuZzdXk2kRfxn/AaIAhj+25vXlpc8hdiBj1OB/8JpUwAbOPdbSXxxluXXg/bvD66kWqvQ=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SJ0PR10MB4654.namprd10.prod.outlook.com (2603:10b6:a03:2d2::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8230.11; Tue, 10 Dec
 2024 02:20:45 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%5]) with mapi id 15.20.8230.016; Tue, 10 Dec 2024
 02:20:45 +0000
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        Nitesh Shetty
 <nj.shetty@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>,
        Matthew Wilcox <willy@infradead.org>, Keith Busch <kbusch@kernel.org>,
        Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@meta.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "joshi.k@samsung.com" <joshi.k@samsung.com>
Subject: Re: [PATCHv10 0/9] write hints with nvme fdp, scsi streams
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <d9cc57b5-d998-4896-b5ec-efa5fa06d5a5@acm.org> (Bart Van Assche's
	message of "Mon, 9 Dec 2024 16:58:44 -0800")
Organization: Oracle Corporation
Message-ID: <yq1frmwl1zf.fsf@ca-mkp.ca.oracle.com>
References: <d7b7a759dd9a45a7845e95e693ec29d7@CAMSVWEXC02.scsc.local>
	<2b5a365a-215a-48de-acb1-b846a4f24680@acm.org>
	<20241111093154.zbsp42gfiv2enb5a@ArmHalley.local>
	<a7ebd158-692c-494c-8cc0-a82f9adf4db0@acm.org>
	<20241112135233.2iwgwe443rnuivyb@ubuntu>
	<yq1ed38roc9.fsf@ca-mkp.ca.oracle.com>
	<9d61a62f-6d95-4588-bcd8-de4433a9c1bb@acm.org>
	<yq1plmhv3ah.fsf@ca-mkp.ca.oracle.com>
	<8ef1ec5b-4b39-46db-a4ed-abf88cbba2cd@acm.org>
	<yq1jzcov5am.fsf@ca-mkp.ca.oracle.com>
	<CGME20241205081138epcas5p2a47090e70c3cf19e562f63cd9fc495d1@epcas5p2.samsung.com>
	<20241205080342.7gccjmyqydt2hb7z@ubuntu>
	<yq1a5d9op6p.fsf@ca-mkp.ca.oracle.com>
	<d9cc57b5-d998-4896-b5ec-efa5fa06d5a5@acm.org>
Date: Mon, 09 Dec 2024 21:20:42 -0500
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0577.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:276::21) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SJ0PR10MB4654:EE_
X-MS-Office365-Filtering-Correlation-Id: 4bd57c3a-89b4-423d-a929-08dd18c1411b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?wH84wfl8pZNEWtScaQn/Jdc4O/nOs/sSri8qnEUmwEeG01td8CitQ9Bvlomg?=
 =?us-ascii?Q?Ob1XNFfStnQSqou6ltR8UJxYABvFDkOK8bINqTZkn7jA6ctrlSxP4jOFWxU9?=
 =?us-ascii?Q?e53zV1U7sb0mZdjK+jFxS8S9/T4fz89g7OGDkQWQivLoGOS7+UFOAq56wwpj?=
 =?us-ascii?Q?ym4UcPnx2ia37Q/6E7GDxKCh6RkFLk9vHukuI1UyvFyOpQ/odzNL2PwtQYUS?=
 =?us-ascii?Q?ij2i1HtY7UcWwWwMO+aeHaUz1+YPjUenNaO3HQK032wu7a4SPPpzfzySzxKh?=
 =?us-ascii?Q?vjK3Nizw+djKOdnhSy+n+JdYgX2vlWR0j3noiIj30dGDTecUIOoe+nRpc+au?=
 =?us-ascii?Q?IPqFFZLQ609hsFPjdqkkIjEnwYIzWzZlghlnX82g9O1GOQf9P47wBspmKIPY?=
 =?us-ascii?Q?vG8FwQDYqBW3VlA+qtByoJ8p2LQvrsLLXeA56hlQJZH680hXK4s7D95OgYBI?=
 =?us-ascii?Q?UvBE3VAH2Su3s5J3/76OgGoIJjuQDm3OsVOJVhVxZEJxAV0UBO4wHmgAWSEb?=
 =?us-ascii?Q?MUVWY1XezzMP4s6rzXCtoqWucnqn6C41vpc0w+CwZUkSO5xhW1srXN4ptRgN?=
 =?us-ascii?Q?eG6xOdHmC2Ixs86IdOsIsbZvOmkf8Bf4lY3CSfmF8otiqyug2vEGnSWZJvxl?=
 =?us-ascii?Q?5Cr/+9XLXyuhdSyXMQ6lxPPC0+SVP6oK41F/divcWvlM4HsVAZRlZqX/wCXc?=
 =?us-ascii?Q?9zMspbi94oWK2qIOFxnZ6lz8kZPmLSCtIRJtC8JRaZ56oR0cTGt/i0tOF1KQ?=
 =?us-ascii?Q?tHz6AsYuSvPfq/tZ1/aNa2HGUO2VuIPTgNYhoFw7dY4a847oWnw7tcZ0y5AM?=
 =?us-ascii?Q?RdF7xz0Ps/y+Y+asJqoUI3RxWTMmGvplfmxxM1VjyBvSd9Wap/P/cWJ7nj85?=
 =?us-ascii?Q?Rne7mxJHUIrTUcoPRZc65m3U7Me90Uq24vZbx6P7dekKe5eDdDZ9VVadoFZU?=
 =?us-ascii?Q?lRrcoUdYSXRMT7zYfTPwHs7aYb5WoYz3KUB8ToXHuADWnOBsgSMzQubshfEy?=
 =?us-ascii?Q?UDmrSoeCPcGmUF0atib45tp0JSNphyiB9Wy4h043vlXiWKvToo6LDlFh6pcg?=
 =?us-ascii?Q?2JwV0tI4aaO4CtFwOGmof790WJZ1shQm687IP0Eu+nIbwoFh7HWiOsV4qcm8?=
 =?us-ascii?Q?iSzWTIgCRhfqwHLuuul83X4kDGPFyp+s501B+VvbIVpRpFwn0OUrl9eHzd9v?=
 =?us-ascii?Q?ITOyRuR71wJa4UevSE11lfZ/FbwnDwvcWOXBuvmIYRk9XV5Pjgi4VUujr0Cq?=
 =?us-ascii?Q?AVaJp4JllZbgv/18JIKYi31jKSMLD2eHhisGMmS2FF/wIlPOmHgQXhQESzql?=
 =?us-ascii?Q?P9MXpvKy1CmP75SUyS/YXrMno8LeckTWsUvnu4j2zgS+8A=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?gey3old+0y82Kx+NxajNih5N4TvMrNKv9Pz5tGKvYmM6l1fthIfJWkKi+COk?=
 =?us-ascii?Q?X0Urj74FCqqwc8DwkY2iAvHSNEG3FiijWX24BDHw3VnfY9uR+UA7RW0RsZs4?=
 =?us-ascii?Q?vMTJdljbvEvbqkHmlB8XSj0+RI0aD4USuIRtDG2iYPKjoTqDRZV3Gx0XW9SL?=
 =?us-ascii?Q?J9BG9nBfRN0Tyq3emx54h71+sM5CRPrYlN8whphE+7T+OmigTaTUaUVu8vDu?=
 =?us-ascii?Q?NqDstC46Wtk6vwyA4XKnDv0/SSgSICXJL3WUJ5ABR9MxwZAnU1D3hp3ZENPP?=
 =?us-ascii?Q?Q6ft6/yxqi3GAMNSE/mSUOVYzzt4O9GXOf2TgxBj9eujppirf0sxfocC5Qu3?=
 =?us-ascii?Q?umERPlOcLSfUtQLlC4g8Kd1l9fkJ0WEi/01TtgTM266CeZjBSmwJ9RY5gNZX?=
 =?us-ascii?Q?7kXVGeN0/sKS1bqv6SezO4AE3cxPdtothWz5UQ188EsZbhrolQ8jCP4Wc//G?=
 =?us-ascii?Q?7VWnqAxOh0Wr60sT7brhwUCK4km0zD0BWqvPMWyLumuIlGAJu7PnZgYXbVHg?=
 =?us-ascii?Q?5aqeuQsTm2sCNCe94MCYtdBteqxFr++Q0lMR+NOZYOkIkElR6JDpWR5ZL3GS?=
 =?us-ascii?Q?khVj8Ip2YSbJ6FNkAmcbo9Cxk3pQiOA2OtHiK4Hy4kzdY3T3H7uRDU/zqTPg?=
 =?us-ascii?Q?5BVMVduROP+63RxIQbNBTkE4LedFIqFsEwUBi8IwTz3fWRMYpwWhRL7fV+yo?=
 =?us-ascii?Q?q5MJKC38S1qdBVFeNCgTIJMkmQE9edtBNCdF/niYLbejW/00yVxxEIKkH8g0?=
 =?us-ascii?Q?e7zrrhQ89XDkEj8blgAXlMDWy6oiilDU6/U929Fnq4jPCw0gUqY3+58dmbNY?=
 =?us-ascii?Q?6eRhyxeVgZoyG4eLTMr3poPLqNO5jH6mgJtDnYleN2Qb0U7Z1bwEd3KPvFTS?=
 =?us-ascii?Q?vW5uPgi9YoEoCloOV1OJtoxQp3L12uC1QrG8/nEru11472VxGuRMPvIK3Mz4?=
 =?us-ascii?Q?+K647wnr2Zxh7jPgNMBwhGfosbl7hVri79NcisNXZZAdjF+0n5nbspRucSTB?=
 =?us-ascii?Q?Mu/2VspD4JGzhagL5s4gG+RQX7EA84qJZ4s9sBIqulamTLBuvmXfrEAICnn2?=
 =?us-ascii?Q?jB91xmfVlMgpuqzuNoYdfsdOwtFy2TbyyvfsZF50CP9AwpMY3/xoVSyOs/5o?=
 =?us-ascii?Q?RU3LZmfIYSm2AkJV7bmaZpYhltcNzohE6U7S54Kw/tG8hc7JA26wHYIY+41w?=
 =?us-ascii?Q?jrXIAyiw74uFdXUWZz1r+/ijoisy9ltrlhEOVHeb/vM5gKn6Vsz4KC8xwyAo?=
 =?us-ascii?Q?DcogV/t5yn6dtkf2gWJWWq+1taHiaIZRr9ygNX/7BEFnpZkY9QAnn+9Uvydn?=
 =?us-ascii?Q?KE7KjlRSm2v7WAu31Q2ic1J9Tmys+BgUCaiZsAFKljqGjFWHxwZopCfMfcE0?=
 =?us-ascii?Q?ttgCevSmVry97DyhrvgNerBC2tvypRVWhFgn8H0+6sjqJ/s6OHDgZa/L712C?=
 =?us-ascii?Q?+NaQjsYEn3ZKGr5FGuaDrJH1qMYSFI/HXZu0kHSucbIiJ/Lr2kDhWkvf3fxY?=
 =?us-ascii?Q?iOV4yimVrk/5vfjAxKUIofC0A0hBkYbkDA0Gh7m4miNyqULYYpwAW1RUV5sd?=
 =?us-ascii?Q?1L3CZhVZySznZ/XEMQ2YfHrb5vCXpEHsiPniM/xT3m813BIpEgBx1Pov1mx5?=
 =?us-ascii?Q?Fw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	WZ9LZgSxe5znf1OZaxV5xgbN9D3jjp4tKxQKIZRfC4O1xbUJejLWFojPN82abTCVIdF8+dpYbXyndzCk4ZTfL2TFj1axgrLplCs18g0qQ+RydBSlZK0rPr3wwQOaVIUZrwMHd0y8iK40dJlzjBFZv9Mtr3i+/A4oTwvECz0wNSwrXDt8/RvJFYs8QVl+/iWl19JBOGJGpCnB1FmHzCULV5Q7hsEqwn/BdK/5cTMdGApal+eCIiqPEQtsea5B+MvRBMfJCOIKknI0P7V2pzno8vvsvIOOlZ6V5UuQsPs9vzFSJKfyWiq/ZQ+fbW9coTk0YIrYO1/BLQqRPlN41migmlY7/cr40Wd1ZD6FMDWEMVutG4Hh2wE1rt4w/dwSS9U6d6KgoKOfz5yqnwffhNuIV4e4mdxuUTfV+qZxA+uHuqzuM+AZWUxQ23pBc/4wH5xa4Z3SWYvhyc9gYLVC8pHg3rpdEe45HxZWvcZ4GBpSwNH9VESPY/FIKIfLSpUHE30immd/4tqZGs3dn5zTOi9uyovABtwG+5cD1Um/ciia/Pbs/2aylA+lUfoIAN+48rpruAlgtLDEeJlZsIhk6Ch07bxPTzLHCPWX3Y86BS2f0R4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4bd57c3a-89b4-423d-a929-08dd18c1411b
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2024 02:20:45.8222
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3N3tRRdWfHrqOh94iDBFid10FULXOop2Ta8Egn7oXioLNxNwazxu15vTII+AELdLo1FE9r03WencHK32qmXyndxLaeTiwjriT8+1tjF+ts8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4654
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2024-12-09_22,2024-12-09_05,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=886 adultscore=0
 phishscore=0 malwarescore=0 suspectscore=0 spamscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2411120000 definitions=main-2412100015
X-Proofpoint-ORIG-GUID: jlF8wy-FFZjb-nmtATGO5OvrZs_danoM
X-Proofpoint-GUID: jlF8wy-FFZjb-nmtATGO5OvrZs_danoM


Bart,

> Does "cookie" refer to the SCSI ROD token? Storing the ROD token in
> the REQ_OP_COPY_DST bio implies that the REQ_OP_COPY_DST bio is only
> submitted after the REQ_OP_COPY_SRC bio has completed.

Obviously. You can't issue a WRITE USING TOKEN until you have the token.

> NVMe users may prefer that REQ_OP_COPY_SRC and REQ_OP_COPY_DST bios
> are submitted simultaneously.

What would be the benefit of submitting these operations concurrently?
As I have explained, it adds substantial complexity and object lifetime
issues throughout the stack. To what end?

-- 
Martin K. Petersen	Oracle Linux Engineering

