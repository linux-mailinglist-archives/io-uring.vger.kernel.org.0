Return-Path: <io-uring+bounces-1224-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E400B88C3C5
	for <lists+io-uring@lfdr.de>; Tue, 26 Mar 2024 14:41:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 728BF1F3B45D
	for <lists+io-uring@lfdr.de>; Tue, 26 Mar 2024 13:41:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D07785276;
	Tue, 26 Mar 2024 13:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="acfjtXlk";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="qA/TZTcH"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90DB582D67;
	Tue, 26 Mar 2024 13:39:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711460399; cv=fail; b=jxTdAZj2vLkPHTG6QnX9YTFF5K1T0qf8qG2ENfjwBCMqeShM4iyR/N0ANOpa97L5Yj0saTGYkBPWGn7ziEh59rdcnGDxeXrFmEcfBA2OwkWaD8vH6QK5j5gaYPdpm9vsxuuEbf9niy9QZMgUBKZZptQtOQH/OIqFSEpPQMNJBic=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711460399; c=relaxed/simple;
	bh=jsHc9p33HPAreiir5GCT0BSbW1c/dsvLyIdIer6Zu9M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=sH05AX4M7m3ICNnoUFEJYJNENMSfcy2CKbveRpKj+GroiRhaqXzPfHZVl8l7u9/TNo4K0Mj5z8473a+CCscVKOPz1Lc2quKEQn+eG+mqC7G4E5C5KMRvpkyNyXMCLfvdyOjYl5B99lfHsVSDdmKOpqSB8CkVTquTWMCa84WSm9g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=acfjtXlk; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=qA/TZTcH; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42QBo6rJ026832;
	Tue, 26 Mar 2024 13:39:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-11-20; bh=IFXxLSY+dH6Wp/TvsZw0MMxRZOJBurWqbfRz1rH17aQ=;
 b=acfjtXlk4g2KC+0qXaQ3hBFp0dUnVYd7ZNif12LWC1809JtJglFL3xdkLhHKsepWCzcG
 77T1lRaCzQnawhK199S0LEcVKotx+lVEJGcVXUQIy+xUc4MxupxppxckYsIcwhTS1B2q
 StV2pYgSIoJtclKdGgX7yfJqH4VGcBCGtaTdulGcYPhe0aHkjvJDVzVQTkBw9+wuWOOK
 K24v1wEJJgWigCEYxYf4UC18KranN/55dizTtECdHnOhfInqJJBCvTRq1Qe+EB4cjeq3
 WK4H4wpRQV2pTbOQatxuKpr5KszivSu1SXqYLJXYct4GVvxYF7jqSzCGG0QTen/fxUK4 MA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3x1np2d1uc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 26 Mar 2024 13:39:22 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 42QCMRqb017553;
	Tue, 26 Mar 2024 13:39:21 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2040.outbound.protection.outlook.com [104.47.51.40])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3x1nh77wtf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 26 Mar 2024 13:39:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i6gdpUFj8zF2sagc7gnDjd7dC215dKCKXRWHjp6h0BNttwAeGaK+plI2nJZZgWzLKSzJbF8x/k03wNhIQHFIcRLl3stLkcPINdLdZU0eyjXNdcRdhtngxyv74ayz/8iRApzi2eGhUg7lCgI4FUrEYIgFN0pBDaJd3rYEhCsGTzML/lCgVPmJ3uFOljG1O1ZOTJBs7WGuZauCcjjf7vKMgoOG7yBIv/w4dno/YM4+1tvu8BRuNenKXAoMk+3T77CmIxlFg5gfHRDrrNxApKCTDRvKFboO0vh6TSarDx/0dJDK1pZ13gv9kAlZ9aQNRBNGlcGL3SXflLMfFgfO/rj0Tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IFXxLSY+dH6Wp/TvsZw0MMxRZOJBurWqbfRz1rH17aQ=;
 b=lMUERJYxwj2G0e+bA8HDITPUyrI5P85uZDewRsavjlcFr/saxOrmwgkD64tNPhWdWGf8vPvheJGY/01kX8OQmcWNpzTyxMKjYlvBRvVCEspaCGIn0IbQ6YFyZRIZ0nQ59OKTQTIv45r/RX5vtr+DXzddes7zwcTjvM1fUYDBiastJMPZqLTnuaLbOKiGBqnpKNmu0r6hppBPDGrxzGXfCME/63Xl40FsSehiQY6/LUZH2K5rSwRCUNiYbUB3PSSVCMhqBvrvkzYls+cTZ5IwKI/MlV5oquD7nbCS+QNRX7vXdjNBn974DhB5TEtbg97qRR59Q+nenhck0/9edNSy2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IFXxLSY+dH6Wp/TvsZw0MMxRZOJBurWqbfRz1rH17aQ=;
 b=qA/TZTcHnqoakDKNZDpDmsCsTppePALS5rFdaad4A3brzTf/PCwjrnWWv+ltSvNWbrRQxETg6rLKGJiI5lZ/NJCmMJrRnpKTKcZDHK4rpdA99Af+Lbr3qYppJxCSLrokzfWpe7TfnWUjn27cLgWIAY7zAv0V4IAxR4qtDCL99Dg=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SN7PR10MB6666.namprd10.prod.outlook.com (2603:10b6:806:298::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.33; Tue, 26 Mar
 2024 13:39:17 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ae68:7d51:133f:324]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ae68:7d51:133f:324%4]) with mapi id 15.20.7409.031; Tue, 26 Mar 2024
 13:39:17 +0000
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
        Prasad Singamsetty <prasad.singamsetty@oracle.com>,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v6 04/10] fs: Add initial atomic write support info to statx
Date: Tue, 26 Mar 2024 13:38:07 +0000
Message-Id: <20240326133813.3224593-5-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240326133813.3224593-1-john.g.garry@oracle.com>
References: <20240326133813.3224593-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0465.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1aa::20) To DM6PR10MB4313.namprd10.prod.outlook.com
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
	6/SD5f93uOKJNX1iLL6QB1/W24ZToeib9KHKYmFvJhUc+3IFwO0wd067K3UXcV2HwwtRdRtH0FA44GA8TXhsNwxVLS8eliISdTYAvzs6+9MHx7Q16nn5ULzEr8v9g6a+A52xEUbAmomOcGtosTmyF7eGvLLO70aewTDEHyLZz99zeyHHp437GbGa/diUpDmB6bWVsTyNhKndODSZFPF2szNmCobyP6Ii/vPr/GG2Al6Fl9WBRnIL3RzpkpQeN/2Fy8qCGYRAMm+4PLxRlZtZ1G+9PhM+mAa/AvC8DVBKuE0UeeahtUmcPtQriq6C6OJAbDMg87PvbnnMIJSVwjDQYE2A0IOaiGvV5Lw4Frwmq8BBjCCuqtLFxJOiqn4Lm2+1G3PviJAsdoKKl0HcQ/P0ini4zQBF1iZTnFmfEnOHtyIRczf1BZdVVTqMp9dRSNA5ofCYVu+daDoT+f4JMjaM7szOnn/JHbkxJ5J1PfHPOdOCriEVy//d7cI8deqWkx95jeOmI/NCL2ar8ZG8l0QgsQtyMttD8jwj2OE1vpJk27q1HG0zJXKlEsdQTPSGcqGq5M3dWwbWcP8e+dgKbJwW3J7bVtqkUkKbliizIqpuHDwm2/XUSKz3U6vRW4xzOxXve+gpYJARQJWy8+KCFc+pW4Hvq2F98O66rv3MmZEXYWRgafwHh5LvBWyN7rwnhx9nqEHSJXjDXnMdTxnDPfLC8A==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015)(7416005)(921011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?4f3EjVzohTxrWzr05J9mpDo/nNua/RTdJIkRvaa30mQ0y3FJTVz7UDQQMEsY?=
 =?us-ascii?Q?Z25E5d8SDFhtebCEMo+qcQPcjmjjnsryllb8J7hNXOg3OiFgrfLYWq4FTwsv?=
 =?us-ascii?Q?jWhLaCYZrS8j8lGbXkdzMEW+0DAFjg/tik20VN3EQnsLM0OgjGzB7O9ILyHU?=
 =?us-ascii?Q?gqsGNApdKzKX72uORdkyZiaJGQlzgCV/srX8r2asP4MwrPkJXWjxRQUcExN1?=
 =?us-ascii?Q?QXA73IetnYB4elzvqLD6TQCupAvfGl3tncot1+QZ6rL3erCMVXLALaB29scS?=
 =?us-ascii?Q?PfKWmZ8Gy85HOqKcl/C1j130+RcbiYgj8xtclFS0UupkNra1qeSZ6ib4pjTR?=
 =?us-ascii?Q?DTcBCwZ1IVq1GL2g2jXm/8OefkWnB2ZXy0PYBhYNDzbszHQjISmh0WqjO8rj?=
 =?us-ascii?Q?D1n3g513dnMkyAdaUopAG0cRFpgb2NS9yeUc9RUym+PtmQf7coJMKee6NJfS?=
 =?us-ascii?Q?h0/TBVuqrertTedsezEceFiULi7bDJZu2jEkLBBL2KQOBiyg98cWfPSdYqEe?=
 =?us-ascii?Q?RtHsxYlS2mqJQG3Dcq6gXUL28AcDobETAVhUQFuHAMDVOEQ/bL61R9guvjg6?=
 =?us-ascii?Q?88qDPa3thIbyuoZPtUlD79M7wBrCXXDSlG6/P3+UhW3R2A7zonASKHe1p33+?=
 =?us-ascii?Q?CBZL0gBOnjjJerq7Vi68qJeWOjEfb3q6GC8hC0TRk056/87eNR8WB0T3/Wjc?=
 =?us-ascii?Q?liNmNFEb2eqx6122cLCCdYMemd8KMWMxueD52TnT6i/azGGVTUZ3RR45yZB3?=
 =?us-ascii?Q?mrfxOkEDip58t7XFOaTe8iKj/NkTLLWLbttgaQEZNi82GuXSa6P19JHz6tQG?=
 =?us-ascii?Q?TihryVHZ8zrpxLUl7WGPGUyA5iG1mEAaSr9zDXdEqV3SamMVShGmLsJmTGec?=
 =?us-ascii?Q?wWIcF38XDio5M3x+ZO7n5yDdiQe1eBjKOkbNU2AQmxITc/iJ9SuMx0Mfa6Ld?=
 =?us-ascii?Q?2V+cY2mb4z8E+IZ+SGnJUMo/jHLkFLEttOF8EQr/YQ/b7Dwse0aYwR6c3Vpk?=
 =?us-ascii?Q?0l1B11rHi/T76KWRk+tZY+xG7fJ0SI98lmz5B97+xnRYYjlhLkTPMV98hJXR?=
 =?us-ascii?Q?zokfAsO2RrlavMMTcOkqJ5BfTOIcIX4XCfuR/GAlraAerjiTIYswOuSMWvJj?=
 =?us-ascii?Q?IQe5PY5gu5/zFg5hb4YRjtFdc2WXlH6DyhOWfgL2tWo4ur8/r1xTX/FDGL2u?=
 =?us-ascii?Q?ri7ACOEiY1DY1aFpzRKsXIVTcpC/LZiHsHTIZ2ccH1xgzHgnFZcLO1WvIKUZ?=
 =?us-ascii?Q?u/UdaYsIvgF9AFTzjk0hOJx2d/JMpjRyheMX1DMGSpZS851nC/KzeIgwJyDi?=
 =?us-ascii?Q?qaVP/IuKVvsnq2LHv1BZ2gxuJm2nqcKCFdhC1rGH2fhbX65vOViGQzoKGEiZ?=
 =?us-ascii?Q?qIGA8IrcPyPgoX6QprZQnYPAnP2k9Xvtt5ueml3opWNSe/pcFyA6HlOkxY/c?=
 =?us-ascii?Q?yA+DBCQ2gG0+4D5XMHGetJOSm2OeA0VbsKA/eR6WplH+0O8J5w65gEFJNBLF?=
 =?us-ascii?Q?yW5YFpcZT6IL7tMn4EDVCYPKg0RtsU1kGBqWq0SBaKfEs0fH/32YG7Ux8eUk?=
 =?us-ascii?Q?+8a73hQkPt8AHgx7dOH0dZsFfXMXVyxBJCZyZ8reANlnjpxSFRwCqGJLOnxe?=
 =?us-ascii?Q?dw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	xoforwYZla8rYpZCVsLod9x36n4XBM3E9/UppDCyqC8ncbXXM9uYPJ3l9PP2fVcgpX+Cv63VmGz9ACce46ribz26UGjeUmj5SgPUBfsCyFLqUl4RaH6LzDmvvajEAvbszjB7KKrGHQdvhSqKBmDED68Ch3+SYrP0tsTDl9IGsDq44MEltFe24IsPLyzC5/aPpBOiVMGI7oRlB30rT1Y7iImb8DfVNZamLl9e6AL+ypsLzhUD7WiAtzaVOungMqQMlsJg5WgRmE7h2z188ZRqdou3ud+fP3ThxtisMZFfSudBcj28xKGnDn/COz7+At03/H+YrXw/33MnB0wsqm3RtkFIpILjlyRFumBTyoVszT9Q+Y6QMA11GS33bBZhWzqBMxHXNqEvXMtYLOCg8Y+T3LuyTpuU7zrBh93N8Y9ALhaq5cOoSXRK4DTKVWl/92hLfIvipj7qH8lNcDydwwlFDq726A9tZ+TaE8qQ7vbzcT/vSgMma7tv8wpeRkOhbiH4CYEIhh/AEusiBxje5SImQPiNDmn8p7KruxPshRvpwP9n/EdNJSrFNlMm8PtpkljjzSn1wjFRhI2C6S0U0zfPObQwdTV/laoOnp+BRkbpDoI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 16724b96-3a5f-4d28-de69-08dc4d9a21d7
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2024 13:39:16.9607
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DMKFtduwvZ2Hk+rmKeLl6HyQ4BWtjXB3+WuB1m2U9iYMZrhmefBLUAgUteaEseJtmLronMjd8UjttuIHFPGMiQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6666
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-26_06,2024-03-21_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 mlxscore=0 adultscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2403210000 definitions=main-2403260095
X-Proofpoint-GUID: Whb6ArGNl-0zIrqSjJBXOCYnd7Dtz-ty
X-Proofpoint-ORIG-GUID: Whb6ArGNl-0zIrqSjJBXOCYnd7Dtz-ty

From: Prasad Singamsetty <prasad.singamsetty@oracle.com>

Extend statx system call to return additional info for atomic write support
support for a file.

Helper function generic_fill_statx_atomic_writes() can be used by FSes to
fill in the relevant statx fields. For now atomic_write_segments_max will
always be 1, otherwise some rules would need to be imposed on iovec length
and alignment, which we don't want now.

Signed-off-by: Prasad Singamsetty <prasad.singamsetty@oracle.com>
jpg: relocate bdev support to another patch
Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 fs/stat.c                 | 34 ++++++++++++++++++++++++++++++++++
 include/linux/fs.h        |  3 +++
 include/linux/stat.h      |  3 +++
 include/uapi/linux/stat.h |  9 ++++++++-
 4 files changed, 48 insertions(+), 1 deletion(-)

diff --git a/fs/stat.c b/fs/stat.c
index 77cdc69eb422..83aaa555711d 100644
--- a/fs/stat.c
+++ b/fs/stat.c
@@ -89,6 +89,37 @@ void generic_fill_statx_attr(struct inode *inode, struct kstat *stat)
 }
 EXPORT_SYMBOL(generic_fill_statx_attr);
 
+/**
+ * generic_fill_statx_atomic_writes - Fill in atomic writes statx attributes
+ * @stat:	Where to fill in the attribute flags
+ * @unit_min:	Minimum supported atomic write length in bytes
+ * @unit_max:	Maximum supported atomic write length in bytes
+ *
+ * Fill in the STATX{_ATTR}_WRITE_ATOMIC flags in the kstat structure from
+ * atomic write unit_min and unit_max values.
+ */
+void generic_fill_statx_atomic_writes(struct kstat *stat,
+				      unsigned int unit_min,
+				      unsigned int unit_max)
+{
+	/* Confirm that the request type is known */
+	stat->result_mask |= STATX_WRITE_ATOMIC;
+
+	/* Confirm that the file attribute type is known */
+	stat->attributes_mask |= STATX_ATTR_WRITE_ATOMIC;
+
+	if (unit_min) {
+		stat->atomic_write_unit_min = unit_min;
+		stat->atomic_write_unit_max = unit_max;
+		/* Initially only allow 1x segment */
+		stat->atomic_write_segments_max = 1;
+
+		/* Confirm atomic writes are actually supported */
+		stat->attributes |= STATX_ATTR_WRITE_ATOMIC;
+	}
+}
+EXPORT_SYMBOL_GPL(generic_fill_statx_atomic_writes);
+
 /**
  * vfs_getattr_nosec - getattr without security checks
  * @path: file to get attributes from
@@ -658,6 +689,9 @@ cp_statx(const struct kstat *stat, struct statx __user *buffer)
 	tmp.stx_mnt_id = stat->mnt_id;
 	tmp.stx_dio_mem_align = stat->dio_mem_align;
 	tmp.stx_dio_offset_align = stat->dio_offset_align;
+	tmp.stx_atomic_write_unit_min = stat->atomic_write_unit_min;
+	tmp.stx_atomic_write_unit_max = stat->atomic_write_unit_max;
+	tmp.stx_atomic_write_segments_max = stat->atomic_write_segments_max;
 
 	return copy_to_user(buffer, &tmp, sizeof(tmp)) ? -EFAULT : 0;
 }
diff --git a/include/linux/fs.h b/include/linux/fs.h
index c0a7083a62c6..6ebefb079740 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -3241,6 +3241,9 @@ extern const struct inode_operations page_symlink_inode_operations;
 extern void kfree_link(void *);
 void generic_fillattr(struct mnt_idmap *, u32, struct inode *, struct kstat *);
 void generic_fill_statx_attr(struct inode *inode, struct kstat *stat);
+void generic_fill_statx_atomic_writes(struct kstat *stat,
+				      unsigned int unit_min,
+				      unsigned int unit_max);
 extern int vfs_getattr_nosec(const struct path *, struct kstat *, u32, unsigned int);
 extern int vfs_getattr(const struct path *, struct kstat *, u32, unsigned int);
 void __inode_add_bytes(struct inode *inode, loff_t bytes);
diff --git a/include/linux/stat.h b/include/linux/stat.h
index 52150570d37a..2c5e2b8c6559 100644
--- a/include/linux/stat.h
+++ b/include/linux/stat.h
@@ -53,6 +53,9 @@ struct kstat {
 	u32		dio_mem_align;
 	u32		dio_offset_align;
 	u64		change_cookie;
+	u32		atomic_write_unit_min;
+	u32		atomic_write_unit_max;
+	u32		atomic_write_segments_max;
 };
 
 /* These definitions are internal to the kernel for now. Mainly used by nfsd. */
diff --git a/include/uapi/linux/stat.h b/include/uapi/linux/stat.h
index 2f2ee82d5517..319ef4afb89e 100644
--- a/include/uapi/linux/stat.h
+++ b/include/uapi/linux/stat.h
@@ -127,7 +127,12 @@ struct statx {
 	__u32	stx_dio_mem_align;	/* Memory buffer alignment for direct I/O */
 	__u32	stx_dio_offset_align;	/* File offset alignment for direct I/O */
 	/* 0xa0 */
-	__u64	__spare3[12];	/* Spare space for future expansion */
+	__u32	stx_atomic_write_unit_min; /* Min atomic write unit in bytes */
+	__u32	stx_atomic_write_unit_max; /* Max atomic write unit in bytes */
+	__u32   stx_atomic_write_segments_max; /* Max atomic write segment count */
+	__u32   __spare2[1];
+	/* 0xb0 */
+	__u64	__spare3[10];	/* Spare space for future expansion */
 	/* 0x100 */
 };
 
@@ -155,6 +160,7 @@ struct statx {
 #define STATX_MNT_ID		0x00001000U	/* Got stx_mnt_id */
 #define STATX_DIOALIGN		0x00002000U	/* Want/got direct I/O alignment info */
 #define STATX_MNT_ID_UNIQUE	0x00004000U	/* Want/got extended stx_mount_id */
+#define STATX_WRITE_ATOMIC	0x00008000U	/* Want/got atomic_write_* fields */
 
 #define STATX__RESERVED		0x80000000U	/* Reserved for future struct statx expansion */
 
@@ -190,6 +196,7 @@ struct statx {
 #define STATX_ATTR_MOUNT_ROOT		0x00002000 /* Root of a mount */
 #define STATX_ATTR_VERITY		0x00100000 /* [I] Verity protected file */
 #define STATX_ATTR_DAX			0x00200000 /* File is currently in DAX state */
+#define STATX_ATTR_WRITE_ATOMIC		0x00400000 /* File supports atomic write operations */
 
 
 #endif /* _UAPI_LINUX_STAT_H */
-- 
2.31.1


