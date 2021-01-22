Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B1B230106A
	for <lists+io-uring@lfdr.de>; Fri, 22 Jan 2021 23:57:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728359AbhAVW5U (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 22 Jan 2021 17:57:20 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:52978 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729051AbhAVW4D (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 22 Jan 2021 17:56:03 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10MMt8hg154623;
        Fri, 22 Jan 2021 22:55:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=/z3pNIbNuu/BvkvKvm4iiliNM/70vJzWZBMIOG8h5WQ=;
 b=iwZtiblHma/FLeK7Kl/8lXZeerD/4pioU+o4FD5etSEGVC4nilcsYfIWkG+nwmcSZHvM
 gZvZZsLH99Wql6qakd47Gxplm81YM+ZS3CrtUlXqPW6Adz8Xct+iRmi+V0TZHvEORIMm
 F15SQHV9JB9vHu8/B4qWmSm4X4Z4V8eWfdno7TYzrVQeuOowgtrqnPdUT7OOiWUrhvix
 BjO7HQ381SkIwOoT3qPA5A4WMIFoK/LoYSKn8drgEKrridSZnAnYxk+WoD2/jfOHH/lw
 k7xgVeLV222ZVFRcfjpcrpyFZ9NKldbZdlQMweviWo0XgyYuzzZKhReDa8V4/6PTCjcD Sg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 3668qrpj7j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Jan 2021 22:55:13 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10MMt0Ot162490;
        Fri, 22 Jan 2021 22:55:12 GMT
Received: from nam04-co1-obe.outbound.protection.outlook.com (mail-co1nam04lp2054.outbound.protection.outlook.com [104.47.45.54])
        by userp3020.oracle.com with ESMTP id 3668r1pqjp-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Jan 2021 22:55:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mcrTCK3vHhZorz18S2sExT6r40Kgv8TIqBtICg1BD5tpmGs48rO8umNNQFyU3o6Qw9TI1dGkyQ4GojDw/MkjJLQG/DpBX8xJR/hxGQ+dr1p7TNW7hOKDPhDguflVyANZDpzLB2+4mLxo9OM0rxkVGkj5UBreBXrI0P2jH+Y7iIhg2UPxsUCQF5ZCHKxNNxsGU0W7W6Ofdk8amJFmZnh/e0MKcUcvZpf1cj+096a0cAVlbp7pCJXmi3D/bmePi4uIXJJsyHBMbQQlwd1yEpRIYbzs7HyNxrdN/+ok1q3JZbxMyTMRcHf5L2HAkGXr8ZHA2vi5Q6xZIbLY3zJyccpEAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/z3pNIbNuu/BvkvKvm4iiliNM/70vJzWZBMIOG8h5WQ=;
 b=ltYE7K/QRnmozX/hRrYbXF7Sy2zLv+ZKaTn6hbS+s+CYPJtD2QDv1qzZ7X04X8kVTC418KCiCc5HgadBRWLK/oPhSnyZstv9oO/DNkabpU+MUY7Cm2Phh+VR+cTXvhPgW5YKvd5sTcVCo0QWdzLkFQB6DCUS0Iy9FZjb/A32F/mZ202Sz/IzI7KBGg4IfO7GGoF+U7PHqy7tZe6H8TzDljbjDtshehVWS8DHf/0SNYR70mQyNAKATBCOVT0VNUxkxYFlyr6cfWe/TI+F/xXrTMKIKK9DvVTa5PVTISrSrdRhdgJPS5odlR3s6HXTGUO1ppDMiju8HfKmTP9zu5OFGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/z3pNIbNuu/BvkvKvm4iiliNM/70vJzWZBMIOG8h5WQ=;
 b=EjKOkhZyE1UjMbEjgFoTfu2oLIJ+YOhz9VrVcRJoabVTB4v00y8uwa8DRJHHvwUwXLdogoJkJwvJwhCUXlatthXltArd+Cb675mRS6QULuG7YdtE4wLJrBRk6/TAk9JBe8uprcWav3ZqFpqbkSq9R1XmXXMfQ9rU1Cw1oj9qytY=
Authentication-Results: kernel.dk; dkim=none (message not signed)
 header.d=none;kernel.dk; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3606.namprd10.prod.outlook.com (2603:10b6:a03:11b::27)
 by BY5PR10MB3827.namprd10.prod.outlook.com (2603:10b6:a03:1b4::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.15; Fri, 22 Jan
 2021 22:55:11 +0000
Received: from BYAPR10MB3606.namprd10.prod.outlook.com
 ([fe80::359f:18a0:4d25:9978]) by BYAPR10MB3606.namprd10.prod.outlook.com
 ([fe80::359f:18a0:4d25:9978%6]) with mapi id 15.20.3784.013; Fri, 22 Jan 2021
 22:55:11 +0000
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
To:     axboe@kernel.dk, io-uring@vger.kernel.org
Subject: [PATCH v2 09/10] man/io_uring_register.2: document buffer registration updates
Date:   Fri, 22 Jan 2021 14:54:58 -0800
Message-Id: <1611356099-60732-10-git-send-email-bijan.mottahedeh@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1611356099-60732-1-git-send-email-bijan.mottahedeh@oracle.com>
References: <1611356099-60732-1-git-send-email-bijan.mottahedeh@oracle.com>
Content-Type: text/plain
X-Originating-IP: [138.3.200.3]
X-ClientProxiedBy: CH0PR04CA0047.namprd04.prod.outlook.com
 (2603:10b6:610:77::22) To BYAPR10MB3606.namprd10.prod.outlook.com
 (2603:10b6:a03:11b::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-ldom147.us.oracle.com (138.3.200.3) by CH0PR04CA0047.namprd04.prod.outlook.com (2603:10b6:610:77::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.11 via Frontend Transport; Fri, 22 Jan 2021 22:55:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7356d44d-af5c-4ed0-c02e-08d8bf28c594
X-MS-TrafficTypeDiagnostic: BY5PR10MB3827:
X-Microsoft-Antispam-PRVS: <BY5PR10MB3827255F0DCFB1C76B810B42E4A09@BY5PR10MB3827.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 86a4XhJ29Z+V0ZOF8K4V7UOYH2gT5N6CYdfpNTv95OW/dPOqSKaLeAmJ2u/g23ykgPr2srSURJy98xvbpMdRyoywZrT2xry7gD5pTEkprkI5bvLPrpdznJ9c1wgb36EiJbgLcrHs13H6GhuVGwc27lVB4Jq+y82rnz9iGSwRXgeO0mGLzwtKQmOpljJeRwctJFNTT4m6847mVtxWBvKSb2mAIxZxredOcpdSdLKrHVbpZ/6I/wPAzaqWpy72Dgykfqht2vw9fKztlwmf5NwKAtsQyH+MtqLGd46zLf1x/gdWh+HUDRGF7m7lTi6iNNYekRLavQ5yDVsrrbG+Uwv2lBhHbNEvqyp0HKFRmztYVcMflTnXYc/MTyf0goG9IM1ltLKBXZ8KPgkHWQOFPNNPcA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3606.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(366004)(39860400002)(376002)(346002)(83380400001)(44832011)(316002)(52116002)(36756003)(7696005)(2616005)(956004)(15650500001)(6666004)(66556008)(66946007)(66476007)(2906002)(478600001)(26005)(86362001)(5660300002)(8936002)(8676002)(16526019)(6486002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?ioOXfUC9uvc3NzAijRwg+HxcTBb9xRot0mjhJDLGVjmC0Eyj6YaT1Ge9u+e4?=
 =?us-ascii?Q?lD95XnqhoOf8sUxvAOj5IbTgeislpBV5SC1Hkrfy+FSjCww2alS+HcQJFfeb?=
 =?us-ascii?Q?6TgVm0omCRYMbny3v9yyu1xnAXJJd4Rnk98Rm1L6jQ3G6BE6VI+fjnzEFmjY?=
 =?us-ascii?Q?5d7UqjftRDlx7BrfOP9aRDovqeT1aGdTLdD44kNrVhxUkNYRXBA+VGlnaWaS?=
 =?us-ascii?Q?uS9KKPqm8p9JHP+FpbSYdgmdTAhV7TAHoHPTCorM2uxZA72Fm6TqMs0abNbI?=
 =?us-ascii?Q?ZRXg1lcpKuT+HkNdLpcijKgr8cnyhDFxuHZGgS4c0Sxy9czQ3XDHVBzuRxti?=
 =?us-ascii?Q?7JzAFR7yt7cMSq2/bJ90BsbMlPunoYjQS5NN3K4MQ69egmv18FlY+Ayvlnyy?=
 =?us-ascii?Q?o4OW8Xllo6Bmjt50pKm6XuDbtUEprhiBhCbkScP/sQIZch0L08I/O3N9gFzz?=
 =?us-ascii?Q?fourg5sfyou4dZqWdDL36AQ6uBJiiQoCcE+380t1KGOUtAqgaH+hOQldXmE9?=
 =?us-ascii?Q?NrvQr+b2ExALLol48JtDIFOwuEWVM/hBEEsSDhKxRmrubW6rR8m/UtzjEn0G?=
 =?us-ascii?Q?X43i3hKk4V0PLTiLh5ubD1NLjAbs0FoiI9Dzong4SiHyT4KMZ9S8BMNRswGR?=
 =?us-ascii?Q?mWH6pguk7gTF39YQyLVDmS81PtXz/0qHyr7ZwRbUp+nU2RjVSMrlFXpMzYAd?=
 =?us-ascii?Q?Gi73Ef7UJS3X5ug0sagdufTNXnidWlcu20rOTlo6LuQeMUz25J0FF4uC3xQ3?=
 =?us-ascii?Q?J8yr7OVfEYLVcBn6zNlaZk998QIMGw4ra34hUo12Bj/QVUvNVuwH/dpUT3aB?=
 =?us-ascii?Q?pTG/odTYKhihmBbg0+JSlbUzHRvPrQIaY275N2IZRM/01zn6CqjVzLoUm7an?=
 =?us-ascii?Q?u6J884C+Ok2N6WRQV2xGnOyin0Hx4L9iXqn3bqYKrrwOmBulNTmcOtZTMuAB?=
 =?us-ascii?Q?juRIcaxwBiwWu2k9IMogfycZvr9D8nlxDZuV++Tb3rs=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7356d44d-af5c-4ed0-c02e-08d8bf28c594
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3606.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2021 22:55:10.9810
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EjF+YNw9ggoxrCpkJmHE/V8kVhh+dFyxVXJVfTrv2Ud4iAUtwQp4ODuyEmRrOnbd6yDlfdhELOQUMDk35AZMaKDo/E1hDZzZ0odMVFUuYdM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3827
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9872 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 adultscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101220118
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9872 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 lowpriorityscore=0 bulkscore=0 adultscore=0 spamscore=0
 phishscore=0 priorityscore=1501 impostorscore=0 malwarescore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101220118
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Document sparse buffer registrations and IORING_REGISER_BUFFER_UPDATE.

Signed-off-by: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
---
 man/io_uring_register.2 | 29 ++++++++++++++++++++++++-----
 1 file changed, 24 insertions(+), 5 deletions(-)

diff --git a/man/io_uring_register.2 b/man/io_uring_register.2
index 225e461..5c7a39e 100644
--- a/man/io_uring_register.2
+++ b/man/io_uring_register.2
@@ -82,11 +82,13 @@ It is perfectly valid to setup a large buffer and then only use part
 of it for an I/O, as long as the range is within the originally mapped
 region.
 
-An application can increase or decrease the size or number of
-registered buffers by first unregistering the existing buffers, and
-then issuing a new call to
-.BR io_uring_register ()
-with the new buffers.
+The buffer set may be sparse, meaning that the
+.B iovec
+address and size fields in the array may be set to
+.B 0.
+See
+.B IORING_REGISTER_BUFFERS_UPDATE
+for how to update buffers in place.
 
 Note that registering buffers will wait for the ring to idle. If the application
 currently has requests in-flight, the registration will wait for those to
@@ -103,6 +105,20 @@ must be passed as NULL.  All previously registered buffers associated
 with the io_uring instance will be released. Available since 5.1.
 
 .TP
+.B IORING_REGISTER_BUFFERS_UPDATE
+This operation replaces existing iovecs in the registered buffer set with
+new ones, either turning a sparse entry (one where iovec base and len
+are equal to 0) into a real one, removing an existing entry (new one is
+set to 0), or replacing an existing entry with a new existing entry.
+.I arg
+must contain a pointer to a struct io_uring_rsrc_update, which contains
+an offset on which to start the update, and an array of iovecs to
+use for the update.
+.I nr_args
+must contain the number of iovecs in the passed in array. Available
+since 5.12.
+
+.TP
 .B IORING_REGISTER_FILES
 Register files for I/O.
 .I arg
@@ -152,6 +168,9 @@ use for the update.
 must contain the number of descriptors in the passed in array. Available
 since 5.5.
 
+Note that struct io_uring_files_update is deprecated since 5.12 and that
+io_uring_rsrc_update must be used instead.
+
 .TP
 .B IORING_UNREGISTER_FILES
 This operation requires no argument, and
-- 
1.8.3.1

