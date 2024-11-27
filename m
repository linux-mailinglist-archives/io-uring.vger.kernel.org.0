Return-Path: <io-uring+bounces-5088-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5707B9DAE63
	for <lists+io-uring@lfdr.de>; Wed, 27 Nov 2024 21:14:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 16DC22812BE
	for <lists+io-uring@lfdr.de>; Wed, 27 Nov 2024 20:14:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DD9E13D518;
	Wed, 27 Nov 2024 20:14:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jaDgrDmO";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="FK0sUz29"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3338912E1E0;
	Wed, 27 Nov 2024 20:14:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732738487; cv=fail; b=kNqk6ABRipTr9OCprQAs/+Qt9rF5Ly6MgoYtU4vCTN32iszpn+oBpYLHuICcE4CtwlKtBUHCyrQcC87uOcC/3AcHnR9IX1LXbVxUJPHrJmcgUMIJ/Swv9T6J5BIFfni2ZLbm8BSQ/jbQBOHJPGld9I1qzG42F20iOHQF1M7HyGg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732738487; c=relaxed/simple;
	bh=R1TLxMHMmruD7GTN/DgJapqsE3up7n+kYC44fnsJgWg=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=D7QMh9SY3AldrhXGB3KuWACcdnVey+PGT8dBdnwycvhGhIqtm4h5wL/WV5rTVIMq67uK6vTOgujpJ36ZYSSaFv7YUDI94i8FZFBtwu5jg7OWKmUAdjZ1oO9H6yT7Qhqm5vEHtajFEN/JhETuLUlluxRGfI5XjuhCcS/E0UWV4KA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=jaDgrDmO; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=FK0sUz29; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4ARICeoh012275;
	Wed, 27 Nov 2024 20:14:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=MkVpfqsx6kmEIhvCnj
	x2kxBltWbYivGxa/YClZCUjBs=; b=jaDgrDmOxmHZVPNDVfnpfU1xZ0YRgiCXVz
	FncOn5jukxS7mHbm1+P4k0z5T/Z/UAYAbjyNmr7xmuaTUrXWqDwyxfZmyNDzFOwa
	tln54ESN8e0eZYFs4leo4j7EjJoh06AxdUijmV2HXV25Y3FqGN+CwufjeoggeNg5
	7gvjrxgP11DHjqxKjGpg0rbJj7bs24SaRqsJ9YDDXuaQqs1EVEEozEINgbAoyr0e
	ya/4T+EZYv4tuFmHuXEJN0eh8PcR6MMBCV8To+EQqssX3EoIIqpRD7XVx5QtQc+q
	o//5uWugvVMWSUcKqtAtW5VpTkHqw/p5KqDly6jv76E9+vztDBEg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4366xy8ehn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 27 Nov 2024 20:14:15 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4ARK4SnI039338;
	Wed, 27 Nov 2024 20:14:14 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2041.outbound.protection.outlook.com [104.47.70.41])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4367058bas-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 27 Nov 2024 20:14:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CifQSs74nw9VlI9T7rJUXj0Y7jCd6Lb/oooNOoxjqx4F+jdtP+vAVK5O1JuHgx7CfPrfMHEUkHq46xXFo1FMqiv/jASGTzkM2kAjkdkM1TSDSqd4/u3krJ1gvroQyGUZco0NZcvrwLRcGeqDNvFeE8QUUSYPCBGVyCZ9vLU6YAvBxrGj/v3nAS/lgtP6h+Co6kmF8dGe+vxdNSI3ZAuuNjACmR5UVCAuGQobXr914gdMEga6cADIH4KfKT2hKr0LzWvPflyOv5t54n6Q4ifYv5TgYDYpUFQtQMfyxFSinBZ2uZnFAdufOzaXjSdLakCxEFDa7+woasvye3zwiO8jnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MkVpfqsx6kmEIhvCnjx2kxBltWbYivGxa/YClZCUjBs=;
 b=jCttnOhEM0+nKTsYPPkMkArvgZBxLKWwhE/R5rKkE1hITIqwrbKzJDkrF8+xP3ns+cdGEJoJB9dI5ADNZPFuM0AdfdBC1m9HRr1uVz0mZ1qk0Sc1SuXb+g/rH4WVxj0dlTSrIV07twslQBZJMUiWLTcusHix3QH0LeF9LH1uQjBQiD4K6PUEhBjzjJAO+63QO4VVe3sRhbNiDcFfXPuWGgh1PHwtGae7zw1KNsdUn2d2jgJweQDzklFsODbZraLyScmzzXWPp/07cgXVvb9+aiSEmXuE5/RPA74IPIwH3Q1LWrH8UP1n4uMjmSqENk36CF+xcwU+AQYrGbbxcaqO+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MkVpfqsx6kmEIhvCnjx2kxBltWbYivGxa/YClZCUjBs=;
 b=FK0sUz29j4McU1CsdH29nLl1fK6TmFVa/IsVbPn6wJ2ridZYypzMjjGnyzoCeYhP93QKiKgCsiKNYSpwf8W+IpM0F/O/1uvoGxKQj22B16qdoHcLNFn1hQikCXurZLU3XFEXmJ2PvgJjQAAVHIyuc2KMXSJRKS8cUphTJOkAHiE=
Received: from SN6PR10MB2957.namprd10.prod.outlook.com (2603:10b6:805:cb::19)
 by CY8PR10MB6875.namprd10.prod.outlook.com (2603:10b6:930:86::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8182.20; Wed, 27 Nov
 2024 20:14:12 +0000
Received: from SN6PR10MB2957.namprd10.prod.outlook.com
 ([fe80::72ff:b8f4:e34b:18c]) by SN6PR10MB2957.namprd10.prod.outlook.com
 ([fe80::72ff:b8f4:e34b:18c%4]) with mapi id 15.20.8182.018; Wed, 27 Nov 2024
 20:14:12 +0000
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
In-Reply-To: <8ef1ec5b-4b39-46db-a4ed-abf88cbba2cd@acm.org> (Bart Van Assche's
	message of "Wed, 27 Nov 2024 10:42:34 -0800")
Organization: Oracle Corporation
Message-ID: <yq1jzcov5am.fsf@ca-mkp.ca.oracle.com>
References: <20241105155014.GA7310@lst.de> <Zy0k06wK0ymPm4BV@kbusch-mbp>
	<20241108141852.GA6578@lst.de> <Zy4zgwYKB1f6McTH@kbusch-mbp>
	<CGME20241108165444eucas1p183f631e2710142fbbc7dee9300baf77a@eucas1p1.samsung.com>
	<Zy5CSgNJtgUgBH3H@casper.infradead.org>
	<d7b7a759dd9a45a7845e95e693ec29d7@CAMSVWEXC02.scsc.local>
	<2b5a365a-215a-48de-acb1-b846a4f24680@acm.org>
	<20241111093154.zbsp42gfiv2enb5a@ArmHalley.local>
	<a7ebd158-692c-494c-8cc0-a82f9adf4db0@acm.org>
	<20241112135233.2iwgwe443rnuivyb@ubuntu>
	<yq1ed38roc9.fsf@ca-mkp.ca.oracle.com>
	<9d61a62f-6d95-4588-bcd8-de4433a9c1bb@acm.org>
	<yq1plmhv3ah.fsf@ca-mkp.ca.oracle.com>
	<8ef1ec5b-4b39-46db-a4ed-abf88cbba2cd@acm.org>
Date: Wed, 27 Nov 2024 15:14:09 -0500
Content-Type: text/plain
X-ClientProxiedBy: BYAPR21CA0023.namprd21.prod.outlook.com
 (2603:10b6:a03:114::33) To SN6PR10MB2957.namprd10.prod.outlook.com
 (2603:10b6:805:cb::19)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR10MB2957:EE_|CY8PR10MB6875:EE_
X-MS-Office365-Filtering-Correlation-Id: 92ac582c-6f97-480d-1536-08dd0f200ecf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?prpabFUVoySkBiJA9s1RTxKBSTNENkGwPLOb5VW/zBXDRBZU+LnwCZdPiI8U?=
 =?us-ascii?Q?dr13+/+habMarmeQOX49F6ASjC1IBRPpw5zVZYCXY9I+pIo+uOPRsTjdiHre?=
 =?us-ascii?Q?p5IBrsKPDZT+cH+U2VWn2N7ai52WRCzKY6j4TLLcxE1aDu+Pyhm+AiJ5e0Ld?=
 =?us-ascii?Q?LRrOyuG68RKU/MAFg/tgLrH6NPTFo2rl/q768QeTlKjeFACi9SH//br0iAUn?=
 =?us-ascii?Q?CIz4rPRO4EeDBW40TIApgifNgu0DUhVDJC3JoUsmIBUcZx8yueFuVH+CvY4j?=
 =?us-ascii?Q?F2gPGAcHQ9gCZZt74I7hzqEIzxJqj8xRqyTaC1i9dp2ePh1BV2ZjperXwMeu?=
 =?us-ascii?Q?xtypZBvXlYSbbs2LIRLOAdpymW/zKzp6nKpkYEAHh/LRjzcUrir0afJRb1gk?=
 =?us-ascii?Q?Q2IQWgXyS9o7x2poX6vtLH6tkTgqeXtsJaqHEAOGlJyQTXo/5SvUZRro7jHN?=
 =?us-ascii?Q?RSaI6ELRIlLIo8KuA6ZU7e6JPBZ3i7jex8MC3d+G89YX3DeuceBCDYAWXYFP?=
 =?us-ascii?Q?NnodoT1UfD/ZU6xjg5qgaHow6A+mw1ntbtjY50Jkrr/ezkRzMtxMlslDqr/e?=
 =?us-ascii?Q?7euDToImEExLcdLG+98VLlpNsV3S1vRUiGdAvOvNJ6E/7gnbRSKwVd3V8xEa?=
 =?us-ascii?Q?BxAPdfvtkUVl7n10UgyuHLZcVF5sQ/y8DITdWQXf4Fd3ivgjYw3go6psI/jw?=
 =?us-ascii?Q?wXpJ86F4IsnsY0cLSmVObeso1Io/Jt5OuIKb9Wv8jAWeFLj0pI2uvvSVQ7F1?=
 =?us-ascii?Q?zxWT/IoPCVX/YH3gUlQ5T1qL2E2TFu9W8vYjqz5mYuRy9NhYeZQb4aV6gRQo?=
 =?us-ascii?Q?CjA8xd7kFIjPxw35tJiqdm4ENiaLsQ3Pimgi2PRZT/b6iek3GzUDbRMoWxeL?=
 =?us-ascii?Q?+JEU6UQZreq9/Y76dQJTUinusfBVkNfowenk+d1hlabbO9vTc3AF+R60fP7S?=
 =?us-ascii?Q?kbwLZLub9Ti7567IDL8CBhA/C+YJ3gR86t/Wpc+dFyVHgPeuYY5WR9QlSQOj?=
 =?us-ascii?Q?HR0HesmGq3H7fXivWN6Sli1cDTtJv7Yo1kP/WT1uP7vRNeQMP2yb+xweDMVR?=
 =?us-ascii?Q?wg5gjb8CBg4FrxviUhyWHcOhH5TzcFDCZs/SQjOmIgtHaa6fn0G2qzO0brU8?=
 =?us-ascii?Q?opfDtRAhLVxnZ9g1S4+JURT+wl+aBuPNmdqXTntQ3+d9jwAP2CLRWOgg++BB?=
 =?us-ascii?Q?4RFDsyAJ0iUzgDdabIO/PgdIhASNeOWB1KznRDO/HpAexsf1u5OqUXt3owRo?=
 =?us-ascii?Q?p0pqzzwSYy38EIM5A20HTUKzrwoFMEHmXSWoCUrI7meU1rFt5VmfcIks1BH2?=
 =?us-ascii?Q?Jj340KH1vxY/w7nxgwQyoimz6TgQ2Kp2IP05veBIxvSPKQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2957.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?0OOAksWOt3C5dPYMBlhyOXjTG9ihWoEzb/P9sVRTNfkYoTUJKZlYgjPgTA1F?=
 =?us-ascii?Q?pZjfmUDPh4zk3+9YhZN8PLekRyRNzi9wF9EFr5SAepocApLH/NBmbLhBbGoJ?=
 =?us-ascii?Q?irkhtzX6oe5+Oo0DH3PSCmaVys8AHGlfSqvwcx9Iw1pA6XE3edvexqY6Cecq?=
 =?us-ascii?Q?jqUM2FBGsOgBgOCZK+/AQCvfJcYTfAPYS2+gErdJXxPG7TOt91y0gvKzdbeH?=
 =?us-ascii?Q?EHDZdD7S6yvC13nm7G9mAsqdLCXUttjxlGgrh+MnxMJS0A5STlumTJUEcocK?=
 =?us-ascii?Q?eCpvoV1B/R3+WbXc5f5WZmWZyYhkodTZSc+vKbTEVjQhSRrL/AqFO7P/wCv5?=
 =?us-ascii?Q?GjWFEsvJfNMET17GYViH5JcSAbP1CtZAk76ZzcHBzzfxIqrfVaQZHbaZ8ay+?=
 =?us-ascii?Q?CrELhlLuKeH98sJg+rwQM3cHO0lhiavUOy8I/UtG+D3WYJjjPVqLTOKb5Vwx?=
 =?us-ascii?Q?/Ss/SZwh0hwbIy7eSmfF87KpjNGkeIQOG8ZI5IvQoX+c+mq1iuukJJUMTYbi?=
 =?us-ascii?Q?W5nlW1vQ4u+dSjuf6/MOuwla/16D3/n88YrbIUHRe7/09tzE48KDlv73DRRi?=
 =?us-ascii?Q?x9rUFwiBujhSDh2kH8WkIYJmdiuXlrsh0RJF6dNkRz+xjeGFKlJaDbDlakma?=
 =?us-ascii?Q?kNfb9lHEH9+HnTyVIA6BCAGyxywChVgpYBOl6XzlROscfVhL3ihZ4FguBa8V?=
 =?us-ascii?Q?i0v6YATuxUxx/W/rvh7+Zov8qc6/nBwINv0Jw9cZS5sWN8Fm3I8C0z+6lGOW?=
 =?us-ascii?Q?yLSgm+RTECqzDc2bERaZKzuHwE6/+YqUlQnqpZfiS7OIcBk9brdy0FyLklmU?=
 =?us-ascii?Q?yU6C6zCF4ThwwB/IM8aKyktJfIgMxvfJnrLK0FlPYu7tug/bAkoMm9JkuNml?=
 =?us-ascii?Q?H8hXFFJm9Cfw1dvdupMBm6uyyjMylroGQwhfkjfWW6fRZgc7PSOMT2WY78gU?=
 =?us-ascii?Q?zeG9ZrIJb3CDGez97Gt+F3CgZAc7kB2Dd23Im2cod0q/cN7U3Z0lgt9t/YYg?=
 =?us-ascii?Q?2LkydBf6WGBJRm6hw0+YjRQZGXPyRZz3aStIU3qy0/68uL0mOPruPtrjc6cW?=
 =?us-ascii?Q?kJTnp65CwyPHTJXE35tr7a0bzfQK9FmwGeHfivpRWECtHAwMVcRhRbCz0nKb?=
 =?us-ascii?Q?lu4387cmqhImcZsJAFrmH3co+xjfyZjSaBSnQwirjYp5GbhPdCObw0PbuUqr?=
 =?us-ascii?Q?pTWfO8xKVxfyLtWrvlBQgpzZ+iD5mptZYrL58qDp7uLfMOt5jFru05g+GubX?=
 =?us-ascii?Q?NwtNjBxxIIOc5RBQDiHdmnb45Z1gdLFv3Y2jczfipwM0A7+yCMuPEgaOdhvG?=
 =?us-ascii?Q?ny2PMoweIPA/y5cU97sqLi0zZUAOFGvRq1IiB6mUhvrd+A6xHlwYltI/d0Wj?=
 =?us-ascii?Q?v/wtQWWXMKDLyuKJ/bku3txvrSchX0EyOgohXljnDOQhjImkXCa0DNC3wRkX?=
 =?us-ascii?Q?+uYXl3lk+WsKxGZgLMYBJSDXpEpZ00fMRTyGWm6dK5oD0VAjs7pJ8UqdrZMo?=
 =?us-ascii?Q?0uCHmdsv5/8eGF1ENV7tE6q4JzhWiaCbKtLkHavVtQrrNpe2RFsAhYVDrw2g?=
 =?us-ascii?Q?cJcHptxxn7YU9Xfkg1Cq8QymRT+U+u1BUxGq1z3R1dVaOt31BiVVe+dDKXtt?=
 =?us-ascii?Q?mg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	6ay4T63+hRc82dPjApd8DEU/G8KOyN+eJDwiF4clWuQOxHcXRX3YhBmur3a1h9+eWr5FzeeLKBYNBI53NSHweEeYMBIkwo2ldlFhlf/xofd1yakb/j4eiqzlaev8k4jV663Wy42xNa24/Kylm2NxktSO5f4OzPJGl27c5abL690Hiwsre/5mr8bqBSwYqgsgDYgNDu8BQzeblthSoQWkThrH8TzS6JvQps5wKIzHf1zs8dX1tcTsO5EWUUF1c6mAmfbV3sqrk3Fq3JlsMfNe5OGh7EY7Yagyq3AiVuBlVun/gGL46m7FPTzD0L5lgvtU2tCToh9UVVcq9d7cSG2nI39DuCBzDYkCkKzv2g6q5GMU9GM4uX+T06OaHvp/B26HfN6ZyyZDN30XBVJuMeWq885ltSr5s2waPiJBHFT1jofMUHuyy5paoVFOiO+uFQgIK+zM5X4B/LIFstlcLQzs+AGoDDZuVXL/HhXtpc5XdZrdjgT2rKY313xTfBUEp+mrpXJHPK7O66+Bs5oGL+sUUjwb1rUqa/l51SvIJUoJwX6JSIeoM0JAssnLB+kZjBAYxQBh25QyZR5sM1NTCySKhdI9AEZ1kahTUfPj31MNhLo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 92ac582c-6f97-480d-1536-08dd0f200ecf
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2957.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2024 20:14:11.9441
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VEUNknMjOXQ4fdgDraOPUlF0mt6TzNQYD5EL/hRY4jHTQt1D/jBiXX6S/FhOENmBbedKXCIun2dYNsfh3rx50hXnfdpPT+3DEQlKQtN+TDo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6875
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2024-11-27_10,2024-11-27_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 adultscore=0 bulkscore=0 mlxlogscore=916 spamscore=0 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2411120000 definitions=main-2411270156
X-Proofpoint-ORIG-GUID: BBFlK6PgeI3e7eDM931cgWlm1jYP_xfc
X-Proofpoint-GUID: BBFlK6PgeI3e7eDM931cgWlm1jYP_xfc


Bart,

> Submitting a copy operation as two bios or two requests means that
> there is a risk that one of the two operations never reaches the block
> driver at the bottom of the storage stack and hence that a deadlock
> occurs. I prefer not to introduce any mechanisms that can cause a
> deadlock.

How do you copy a block range without offload? You perform a READ to
read the data into memory. And once the READ completes, you do a WRITE
of the data to the new location.

Token-based copy offload works exactly the same way. You do a POPULATE
TOKEN which is identical to a READ except you get a cookie instead of
the actual data. And then once you have the cookie, you perform a WRITE
USING TOKEN to perform the write operation. Semantically, it's exactly
the same as a normal copy except for the lack of data movement. That's
the whole point!

Once I had support for token-based copy offload working, it became clear
to me that this approach is much simpler than pointer matching, bio
pairs, etc. The REQ_OP_COPY_IN operation and the REQ_OP_COPY_OUT
operation are never in flight at the same time. There are no
synchronization hassles, no lifetimes, no lookup tables in the sd
driver, no nonsense. Semantically, it's a read followed by a write.

For devices that implement single-command copy offload, the
REQ_OP_COPY_IN operation only serves as a validation that no splitting
took place. Once the bio reaches the ULD, the I/O is completed without
ever sending a command to the device. blk-lib then issues a
REQ_OP_COPY_OUT which gets turned into EXTENDED COPY or NVMe Copy and
sent to the destination device.

Aside from making things trivially simple, the COPY_IN/COPY_OUT semantic
is a *requirement* for token-based offload devices. Why would we even
consider having two incompatible sets of copy offload semantics coexist
in the block layer?

-- 
Martin K. Petersen	Oracle Linux Engineering

