Return-Path: <io-uring+bounces-4808-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7DA259D1DEB
	for <lists+io-uring@lfdr.de>; Tue, 19 Nov 2024 03:04:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3DF242828AC
	for <lists+io-uring@lfdr.de>; Tue, 19 Nov 2024 02:04:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 207DB2E406;
	Tue, 19 Nov 2024 02:04:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IXmriSqK";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="YcPBHxRi"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 415663FF1;
	Tue, 19 Nov 2024 02:04:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731981847; cv=fail; b=nF2nZJSLku44LcecaK1o5I5ht3l6Ss10lkBN59LToq0P49KkIBcijspdGO1b9++7sb6GBONV1jsLW6GNCkMzSuST3fFiEUrXMqz0NZFyrU97PSmsM8/yBGiPSHSVOODi3gvprnNtseTH1+D9vFORQam2TEsTZPTVK4h5U+DVfmE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731981847; c=relaxed/simple;
	bh=rmbH7uLbw/sQbbAwkx3H43wLm/OPuY9OPgQZj/BJU6I=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=meC14RjuFUD7NxaQih1ShGGpUH39QSblNuQ7oy5Mf+OJKCkhBZDBNDH/W2L6i0bfhDMwdozY+6/aJofRXD+va7rimLrGe1u0pVt4L36YmWVAyDiHQK1DrgSG5KGypdUkC1BKitLjtB0Ahmfn3VKGjRjfCkJ2cYxZotcMUgaNi2s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=IXmriSqK; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=YcPBHxRi; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4AJ1MiiR026895;
	Tue, 19 Nov 2024 02:03:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=T5kd8MNqVTchAzpXQu
	lU3AA6q9ia0NP+DXCcwjkSD68=; b=IXmriSqKvrNgi0zYKP+EOVL/vCpB0umq0g
	DlLfWQomyCBuDeA+X2Pz9Qx1c/Tpyy50pV5jDURfH+kT48kpXBPjc6/TC++Pdbba
	NrE6XCo2TBTrxH1PGr4HE46ZrkxMoYpDwJ9QaVGEBkunk+SXyIfkhIg3VGRwUSb8
	uJG/0qbVtmklMDEZzF2OClmbEzhM9WrEzUJ39wwFD86wf/h1NFKmQwcEfpYdDp+M
	6UvcZHJo5P3mjrO+XvHJAa4mEXv/tPruiu22DUdk4ajvG3/xzCWDuxPKSgaYUKxA
	6snXtmPXY+pRou5+Dh4RnzdY1jCgUSj8lz7+BRDgQBCYSisP2ggA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42xhtc41tp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 19 Nov 2024 02:03:34 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4AJ0olFI039198;
	Tue, 19 Nov 2024 02:03:33 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2170.outbound.protection.outlook.com [104.47.57.170])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 42xhu7upse-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 19 Nov 2024 02:03:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OGYtMtw8+5mWPXtYUehZJGW+e5kGN9QPqN6WVwo/Dlwd8QjbvsXdERD6Y0TXSwkVbj+UvPh7J39lzvDX+k1aUy/TDUb/gU5SRWNerLI5JtSM597JBfVajgE2xvT2lBzQ7R25Cwo2eUH47a/kN0xSUN6clUpV5ajzcQvO2qfklU6iZhU25xFEXtImKX63WOO1J2F+d0Ii/B0UZ4eCOk/CNDao7y0xscAizPWoJ4FGvBKeULHeEDZNzcZ3NqfBSMIZpljCpTRxGLaQR3bX7q4TLbkaGhWn6i/0hKQdYkJntvbALu+wwbvvPy3sDjAFfZhBUhzGMd0aGWAAmeAy+CNHMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T5kd8MNqVTchAzpXQulU3AA6q9ia0NP+DXCcwjkSD68=;
 b=ESYlFPmHDac18/4QgrjmjiemQu7fn/1H7ANtLidU3n8r2qa2atdENtpQmESLfL9oU7Sm1fZPsjYjivwJB5u64pB4z8JcHNF3bQ3LA++mhudb6l7BX+7RoqzWZ3d0xIVkB3x7889v+rePrKakAhbOzIqSZXZf5a8lJqR2jOP6HcbKOCulxrwcodQyAGHJM4injN8w8bANVd+n4/h4RrPDARL7scYHqdh+M5Bp2eqAWB06vkY1ZA3dQHtDXOvmc4q9ARFQ//3G34PQAS5UDZgmzkWg0ciWX5olh6INH/IhiQD5VSEnjcnjsyPL4RZBA/DIx4qJXuvs8+pzyq3RdWkEeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T5kd8MNqVTchAzpXQulU3AA6q9ia0NP+DXCcwjkSD68=;
 b=YcPBHxRiyex5cmzEHPDT0BU+oItWC6Q2IdFZzhx7rN0GIob6NzhF3N/dyMXjFMwaStc2cUTU2CnGVANMtvIConqT6Dg5Tggp+T4mvOG7xU82TK8tk1bZk9k79ACZ86DT85xDAn8L+/i9kTL0orRGm30dfvtAwgQBlACXVxHcp5c=
Received: from SN6PR10MB2957.namprd10.prod.outlook.com (2603:10b6:805:cb::19)
 by CH3PR10MB7960.namprd10.prod.outlook.com (2603:10b6:610:1c2::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.22; Tue, 19 Nov
 2024 02:03:11 +0000
Received: from SN6PR10MB2957.namprd10.prod.outlook.com
 ([fe80::72ff:b8f4:e34b:18c]) by SN6PR10MB2957.namprd10.prod.outlook.com
 ([fe80::72ff:b8f4:e34b:18c%5]) with mapi id 15.20.8158.023; Tue, 19 Nov 2024
 02:03:10 +0000
To: Nitesh Shetty <nj.shetty@samsung.com>
Cc: Bart Van Assche <bvanassche@acm.org>,
        Javier Gonzalez
 <javier.gonz@samsung.com>,
        Matthew Wilcox <willy@infradead.org>, Keith
 Busch <kbusch@kernel.org>,
        Christoph Hellwig <hch@lst.de>, Keith Busch
 <kbusch@meta.com>,
        "linux-block@vger.kernel.org"
 <linux-block@vger.kernel.org>,
        "linux-nvme@lists.infradead.org"
 <linux-nvme@lists.infradead.org>,
        "linux-scsi@vger.kernel.org"
 <linux-scsi@vger.kernel.org>,
        "io-uring@vger.kernel.org"
 <io-uring@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org"
 <linux-fsdevel@vger.kernel.org>,
        "joshi.k@samsung.com"
 <joshi.k@samsung.com>
Subject: Re: [PATCHv10 0/9] write hints with nvme fdp, scsi streams
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20241112135233.2iwgwe443rnuivyb@ubuntu> (Nitesh Shetty's message
	of "Tue, 12 Nov 2024 19:22:33 +0530")
Organization: Oracle Corporation
Message-ID: <yq1ed38roc9.fsf@ca-mkp.ca.oracle.com>
References: <20241105155014.GA7310@lst.de> <Zy0k06wK0ymPm4BV@kbusch-mbp>
	<20241108141852.GA6578@lst.de> <Zy4zgwYKB1f6McTH@kbusch-mbp>
	<CGME20241108165444eucas1p183f631e2710142fbbc7dee9300baf77a@eucas1p1.samsung.com>
	<Zy5CSgNJtgUgBH3H@casper.infradead.org>
	<d7b7a759dd9a45a7845e95e693ec29d7@CAMSVWEXC02.scsc.local>
	<2b5a365a-215a-48de-acb1-b846a4f24680@acm.org>
	<20241111093154.zbsp42gfiv2enb5a@ArmHalley.local>
	<a7ebd158-692c-494c-8cc0-a82f9adf4db0@acm.org>
	<20241112135233.2iwgwe443rnuivyb@ubuntu>
Date: Mon, 18 Nov 2024 21:03:09 -0500
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0403.namprd13.prod.outlook.com
 (2603:10b6:208:2c2::18) To SN6PR10MB2957.namprd10.prod.outlook.com
 (2603:10b6:805:cb::19)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR10MB2957:EE_|CH3PR10MB7960:EE_
X-MS-Office365-Filtering-Correlation-Id: 78b0be88-4e43-4793-a98c-08dd083e51b0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?FEOB3niivM+mRdrGeXWOzAUAjGW+CoYjRmFInozG2nHD7fvmixDbL0F9qetB?=
 =?us-ascii?Q?5avRB02uqGjH11uNCwmC1lllNNb9NOWXeGZ1/QdMRTeci+dVbuRTzwuFEj5F?=
 =?us-ascii?Q?Wu6XPGJ1VPHFV36+fNJB+GYR5oZvRBgjd02DpY6+IlRgaYBNRQtJC+bSQcde?=
 =?us-ascii?Q?a/Z5aQjnFvM3hpCSE22xlB+HopNabu6lCVLzgzfZCXCuzAyiJ9xYcZfg+WzG?=
 =?us-ascii?Q?hb6V2Vet8QZTw2oBP2TY8p/4EgC8ybyeDp0FeD7HXCMf5ZJe03RPkGikM/qa?=
 =?us-ascii?Q?QEIYpontQBGLAOpEJSw1jnewkUGd4GIP9k2wvUqZ6lLUGiN8QsogmBGhvFnD?=
 =?us-ascii?Q?0SIZujPIkxXb9sJRC8DlMscO7g7uNKXZsT5T4rVcEK0bUrv2Gng7cGwtu3U4?=
 =?us-ascii?Q?pNKbw+zpZsyOReUd55hVOFn/18afdJ3D9eGTBXcUnCrnUAZ83vrAYTOaT6um?=
 =?us-ascii?Q?Vw4bn2AOSwWYYSKs/+FQcfYJtkMQfKni5AMc/rjg6ZfKY50b6zVkGwoRMrxS?=
 =?us-ascii?Q?LwMfCgiQpQJ32lj/AIeM2kg3IeTC/LQfLfj2y3lTGVOmecIUhB7N2l4TYvoi?=
 =?us-ascii?Q?RDXKpMdNjjuzPhRCU8fBNEjRY+42rjXNsiCwZQhhMoEn8HmQ1ZewXcDtw4xB?=
 =?us-ascii?Q?drG1AOTeAiBSx/bkm7n+nlCbw8zC7byZQOBAZThMyXWjVJRsn46i4/BpEjix?=
 =?us-ascii?Q?r/zBgCI3lJ/mbvf25yOxMkreMl5ASpCCdUYW0yklNyDFMC2mmYeyf1LJHZgs?=
 =?us-ascii?Q?i08Btr/nZiPDLOG86AJFLKeUGj4cRfavons6mS94N+VtCSJAmYtUKMaR4/W8?=
 =?us-ascii?Q?3s6de5HFMnXmZXmUIE7GlvHLUIleOiyjB2AHOmrn5v5UaQFjmRkT5Q65jj5o?=
 =?us-ascii?Q?dmSz2564gjTq7ghZChnqDYWLixqdPunFSDPRoJRpdDL1StY03L0X8ucoJWDJ?=
 =?us-ascii?Q?+qFoYeIfm3v7kkSne3UuGCcOOk8C46SyWUCyBF3aQo8dFe+gXeG7dAHh29rU?=
 =?us-ascii?Q?KknJRoPnDNVKTYLloK0hd8QCS2xHgSOTS9Pou/n5nHT7kDt8qGp/1rj5yVTC?=
 =?us-ascii?Q?/FSkA4itPy6T7G+2YpnqBEv+QIPhjo2xH6+r7DGMR2rwTfn5v0Yk+Y8yOuUt?=
 =?us-ascii?Q?ndQcLyAUTlRWXerEEFVNAva8TtL4DvU6TNAwk5M58xNOAE4dSq+V9RSDNYue?=
 =?us-ascii?Q?cNzGGmQLOVMqJ82KYdejtwZ5Zzuv5Zr9nOr4xRQXzsWWyAT+iaycNaEAgMV0?=
 =?us-ascii?Q?XuTto5M1M7ncIxwuhBDfxq7q2BAZ6KNMFiIr6sYVOJuJjGJinbvy7YIAGyvs?=
 =?us-ascii?Q?i6cEArFBUwQa9if9ah50FuLs?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2957.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ZC7jdaE/PNR9sZ0zKkPI1yeJ+ev9VOImGRueZdOq/qFbnNqPN74DbawSDMVm?=
 =?us-ascii?Q?2p6XFGPFl7asr/ahCHPf0ktkyDlZvgmv/iX3yuVdu/vllvg07TrYYRclCvqz?=
 =?us-ascii?Q?rMBuLzQv9R5Z18+Y9VVE/3/dTN6/lX/YZyHd1K1EeruXhjCs4Btcu4KeXAKI?=
 =?us-ascii?Q?pFLDY6q0YqhoevnZj2+ftJJNvdzDIXVVuzvuYBtmifS9PbtHXHHdefyw2oe2?=
 =?us-ascii?Q?rhLZXVrTRP0HOqnJpGN3O1xAU7OYa3LLzTr5/YKOo8054lz0+0HSCC7ClnuJ?=
 =?us-ascii?Q?J6Y79OmszrEitCqTqTN41mKALqFiNoAKXIangZVTC5r9S5vm3HCkdspJX71q?=
 =?us-ascii?Q?GCYBTI1XSsSBWiv9+lizUWlnzb85X0atb1+QEnSBb5JIcgNcb8jwM8dbfpGa?=
 =?us-ascii?Q?y2YAC/2VT1rKFciM9/wLmAKOQ/0aZSTH90f+8kxkUSV5c9vgvpZ71dHRvxll?=
 =?us-ascii?Q?uf+wjP+XmH1NVGPI0yyxGuWNPNE6rxFMDixvpm2O5u5scZXDkQvoZrfk+QOj?=
 =?us-ascii?Q?Gi5qQbzp9J2DYRX9p8vh8t9ccoOdU60mVXvgU6LH2bSYSgFxrIId3pTLzaYz?=
 =?us-ascii?Q?JxXq+VD9gyPTXRTOYHzH5J2HuPQ2uRN/75EEKdPiELIxmVwiBp05HPndzcj+?=
 =?us-ascii?Q?pjV9b6+aLNilrgJE+lO+2TBdUGi0ldIjRyO+3XBob8AHyDHNW0jqgw2LpS7y?=
 =?us-ascii?Q?JPxNOQM9gHuIJRKs2/HMzDp/xIQ9iJ/FTpvIogtooBioQTtU1N7AZM/mP0in?=
 =?us-ascii?Q?mo+ZS/c6TMMFUt8Qb/m+AAEWm8XUPqnNEH5bu7T80eR8WzS/pzcoHZCHeNkP?=
 =?us-ascii?Q?mwYsPDK5jNRslk1+e1aDwkMt/611wZhuZS0GOzobpBzu4Wyo+3MtuQTzjufR?=
 =?us-ascii?Q?THHcUAqooMPIOSdVcgKHYhPzWThYbCEBn8rhP19dyH91VkyDG+qTdf8j/9HF?=
 =?us-ascii?Q?58j+PBrlUOQEmgxqBdnDzRMI+vx1XDh93KxNvldjm/f6ReFEdQkFbXvKVxEz?=
 =?us-ascii?Q?N7iE6kDKDwI8pmLrqk3YhQrSzm5RqRDYmdu3RoJSC9BS5WTN4XEpHy4oiWyz?=
 =?us-ascii?Q?pOJvG65DsLbFZAIMJB3jyfDP2lDawjARVK61/ye+fMzn4JaLVnT88AGW4ABM?=
 =?us-ascii?Q?yFPynuMRSLAzXoM7W4apr1SnXIsY6ibt/4z59q7cBsz8uk3oqSBuLIZJs2KK?=
 =?us-ascii?Q?yiC7Br5bS4LyM7aoyuMTQY1C1ApcsdPPNfGaabxaPf3ic3QPvross/dmOoWk?=
 =?us-ascii?Q?Aqrwazq8jHcPDvxF/n/WZOME3ynCk5mMbQm5miWWoOGHviNkdom1WeKL1DEQ?=
 =?us-ascii?Q?yq0DEyiPbX+nD7DBx8dytrGGfG78CrINU4RV9PT1b3YAJZBJoBu8RA10lhA0?=
 =?us-ascii?Q?QiZGoTJP1L9Ri9eNuD690xnHwbbe5Gc4csX+4G/chjkcsSWKZTyQOFMVdFat?=
 =?us-ascii?Q?aW1l2q6rLKPyCN7is/QoAw4bhnhOz6FQMj1daCDl/8mbr2jVTo0afTay6ka2?=
 =?us-ascii?Q?tcCKzIgZZti/9kuy1POBb2I6SeGWfYiFllMdIzV6vEW5thOEWvr0xwge6+AV?=
 =?us-ascii?Q?v7QNwkCO4+OxB7BsyGEcSsHK0ZJ6in7Fnfhh7dMDay3xdAMN97gUPk0VirDM?=
 =?us-ascii?Q?cw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	rg4Fxm1UkAQ3KMmrFMOYhUCNxzZJAKLzzWzqdKi9MGl/3xT1JoNlamNjsbvRYp/s8KqYTgPVPfq586YWmvwzx3gvjBMu0ofUd0oVn3aLcV9bJF+OFtwm0r1m4f7WX2hQowr54j2dEuSk8RzQZn7nq8eKuw3oEDyxW4K+NgQUfzwO7u4RSDt5RYjzOuOHXQBTcmZ8RtRRw8kM8pNtPJE5UpDVHa08nIRgKLYO1ie7MxlA+RXGtoefFgVDq9kDRzdKHA03yZyj9u3NVahZnuTGHvq2koU6y7Iw0Txw7lthDrW2PKJvnUigD7AWOXs64g1eocnHsUyJWX+SzjVvbL5+sYo23renCBqLpFVa5EgI3izP+Nz1/axoNQcQpQ9N2BU4w7UF4yYiVs52fGsMcgNDDS8ZMGZWCiWE7CJJy9kNEYgxwAfM0DZ1e/nume0pUA1p5r5Aq+oqai5Qj5/L6er3T0qcU9l19iaGWnSxS91IKbLQj9IBnX4usMvzL2/bZqEDuvSPwxn9ZJ4eMabgNgTQYOVb+AxXVuTgO3FAU6HrVKYSqocJrqHmhtITKuVp1ZxOuY0GS6XJmcCfNIiW9eqagrg4FPNHwYOR2cUJiZpgDVg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78b0be88-4e43-4793-a98c-08dd083e51b0
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2957.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2024 02:03:10.9070
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aY7rdtfDeKel9TMBaDrnDVy20ext4uOsgiR59KFNwMrmZFidcP+428VjYp0VvRoirRQSG4ZVIEvog+pjfLEB28GryjdYXVODMirC3BU/qeY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7960
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-18_17,2024-11-18_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 phishscore=0
 adultscore=0 mlxlogscore=888 bulkscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2411190017
X-Proofpoint-GUID: 4tT9jaTfk3zjcp-TGQIeKRjNKvVtOaQa
X-Proofpoint-ORIG-GUID: 4tT9jaTfk3zjcp-TGQIeKRjNKvVtOaQa


Nitesh,

> 1.payload based approach:
>   a. Based on Mikulas patch, here a common payload is used for both source
>     and destination bio.
>   b. Initially we send source bio, upon reaching driver we update payload
>     and complete the bio.
>   c. Send destination bio, in driver layer we recover the source info
>     from the payload and send the copy command to device.
>
>   Drawback:
>   Request payload contains IO information rather than data.
>   Based on past experience Christoph and Bart suggested not a good way
>   forward.
>   Alternate suggestion from Christoph was to used separate BIOs for src
>   and destination and match them using token/id.
>   As Bart pointed, I find it hard how to match when the IO split happens.

In my experience the payload-based approach was what made things work. I
tried many things before settling on that. Also note that to support
token-based SCSI devices, you inevitably need to separate the
read/copy_in operation from the write/copy_out ditto and carry the token
in the payload.

For "single copy command" devices, you can just synthesize the token in
the driver. Although I don't really know what the point of the token is
in that case because as far as I'm concerned, the only interesting
information is that the read/copy_in operation made it down the stack
without being split.

Handling splits made things way too complicated for my taste. Especially
with a potential many-to-many mapping. Better to just fall back to
regular read/writes if either the copy_in or the copy_out operation
needs to be split. If your stacked storage is configured with a
prohibitively small stripe chunk size, then your copy performance is
just going to be approaching that of a regular read/write data movement.
Not a big deal as far as I'm concerned...

-- 
Martin K. Petersen	Oracle Linux Engineering

