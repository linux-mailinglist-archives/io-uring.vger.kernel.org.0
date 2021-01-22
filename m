Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 987B5301069
	for <lists+io-uring@lfdr.de>; Fri, 22 Jan 2021 23:57:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728458AbhAVW5S (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 22 Jan 2021 17:57:18 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:52884 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728508AbhAVW4D (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 22 Jan 2021 17:56:03 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10MMt2Yx154566;
        Fri, 22 Jan 2021 22:55:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=TIPPnRmqt+n1HjHoZ308ZuQ0MhwLDTZ9T6Q2TKoJ2cI=;
 b=d3z3FOHpoNPM6+UqbjV0dc3OGXIEpnpMmgcCrvRv5rK4qR3RxykvseWKedjgy3Puy4Y6
 vAb7ZbYIKXIWAYqwJKpWoaFu9wP2UT00SpBPreh6nSplLQZ1Qw+arUNtdkRlAoK1/U9x
 QLjVbx8fMaB8ozqv+quIKPg36QY/z2CpylSvJlm3s4XX9w0obek1FmZysGG1yo2xY9lV
 NeKfntsV7g0qTz1db2PDpBNfqqNqO6eX+IVTrWwIL0ah80e0MqfDBmQtv/iAOnT8sTRS
 wseWiK1JGIi0cYZPQDhskDBz2VqxrD9FXdxY2B3HQD11wHLqsTH10YWuNeYBam8tDvyr zQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 3668qrpj70-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Jan 2021 22:55:06 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10MMjsIJ062865;
        Fri, 22 Jan 2021 22:55:05 GMT
Received: from nam04-co1-obe.outbound.protection.outlook.com (mail-co1nam04lp2059.outbound.protection.outlook.com [104.47.45.59])
        by userp3030.oracle.com with ESMTP id 3668rhjqpt-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Jan 2021 22:55:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rd5hCQVSBY148q88iaiFooY05B3gvEf2k3WvMSMrCE/RfyMYUnOaf5pzstQLRTHFav88XxfMBeSlsujLkRJgC5y4gqT1aSTJUeujHSYkHxgD0w3kXCgioWisw3KCl56Ohd3p0WvKuo2WozBG0Pou5hEDUTGY2e1VM06qM0xyGOllrBdhmTm4HbB5xx585NfC1cYcdfcxCRYi1A1VgFk02Bl5T/O2EfRbGBEcmX0rgIULz4XrjBVMq0z/aIigi/ZRBtzMxH/q+N56f9iNcbyh3vJAu99JSacae8tJtz5rFZ8Fe7QKjbl/DM6mbCtIran9Jcfwb7dhpMXOSYN8zM7CCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TIPPnRmqt+n1HjHoZ308ZuQ0MhwLDTZ9T6Q2TKoJ2cI=;
 b=c78LWjZgiMUF/YXuQNymGUe++0+f50Pl0F667dIccdFIxThxRh78okcd8nXZR8I6f/LJRPP1iX/taUieCWuztJvusGUaUxXjzlLB98qQq1UBw1CNhURvqcJXFdZasb6LcfVq/MaD9naSCjKntgLy8LB9bISJlgyt3mXc1JvcBSL8izxJgIv+qryHnSkdKeTtz0NTmBycRFaCjqRqic3CDRLfr7Uyxarn12rfAIAiE6WL8ptsDGgeF2xRx0A4YTRegi+BAC/MPgc++Sr8NzY5b0nAfVA8ZSwlowH8NC0wWdxi5iGlaPC6JK2SvpIS2M7kAknsMnSXo0wJFHBx+zfWTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TIPPnRmqt+n1HjHoZ308ZuQ0MhwLDTZ9T6Q2TKoJ2cI=;
 b=QXsiBPwtnBC8fp52ZZrVbMunR0/miKl30mKGOUFk6LfsMRyI2uXWl+9VDPvMEM3G8ONOXhT2crUk0BhfhXzFAnfOmc8fiwBX1AhqpxmWwTbmTpXLbBtNMIZjmIxrvBduRMjmqk3jH18ZPLs5SKhT3YT6Ybf7vJSsLwpFphO6VCk=
Authentication-Results: kernel.dk; dkim=none (message not signed)
 header.d=none;kernel.dk; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3606.namprd10.prod.outlook.com (2603:10b6:a03:11b::27)
 by BY5PR10MB3827.namprd10.prod.outlook.com (2603:10b6:a03:1b4::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.15; Fri, 22 Jan
 2021 22:55:03 +0000
Received: from BYAPR10MB3606.namprd10.prod.outlook.com
 ([fe80::359f:18a0:4d25:9978]) by BYAPR10MB3606.namprd10.prod.outlook.com
 ([fe80::359f:18a0:4d25:9978%6]) with mapi id 15.20.3784.013; Fri, 22 Jan 2021
 22:55:03 +0000
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
To:     axboe@kernel.dk, io-uring@vger.kernel.org
Subject: [PATCH v2 01/10] liburing: support buffer registration updates
Date:   Fri, 22 Jan 2021 14:54:50 -0800
Message-Id: <1611356099-60732-2-git-send-email-bijan.mottahedeh@oracle.com>
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
Received: from ca-ldom147.us.oracle.com (138.3.200.3) by CH0PR04CA0047.namprd04.prod.outlook.com (2603:10b6:610:77::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.11 via Frontend Transport; Fri, 22 Jan 2021 22:55:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 31338477-2312-405d-b318-08d8bf28c11c
X-MS-TrafficTypeDiagnostic: BY5PR10MB3827:
X-Microsoft-Antispam-PRVS: <BY5PR10MB38279B5AB5EF4279E2F2EDA4E4A09@BY5PR10MB3827.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gfyZeVtyietnNHFRC9Q2gt0g3DvV9EqzufmwBDn3KiV6S6syIvKwsvnrdcvQ9tJXiokaE4SsLmKzRg4mpSUh3RJ3/Q2Aov8yqXvmysCgRZFcKUaBMfmMPwF0asQ2N1Rhh9R/KJiKPOgJz3on8vvlUjg2Ow0DsjDRr/x+D+Ni4eX4Ii3aIE2xZ2TKL8DnvRmCv52FBxv3I0grj+pkv4Ga+mOvHIKygtOOwwox4z7nM7HS9gNRhoBofpRyiQbwBPKeQjJ7+8MZJ2Efv+nIyRp2eCT5126z2R1e6y9YZfd/GqjbQBH5gvvMwWhaOOcJodYH6LQ8Pdf2VtsYX0McOxVAiHXj6VhflnNQK5V2lhodilaJlCfKSYutflG4NQJfHupy5G4a9OrnDxlZ3Zm6SYR+Qw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3606.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(366004)(39860400002)(376002)(346002)(83380400001)(44832011)(316002)(52116002)(36756003)(7696005)(2616005)(956004)(15650500001)(6666004)(66556008)(66946007)(66476007)(2906002)(478600001)(26005)(86362001)(5660300002)(8936002)(8676002)(16526019)(6486002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?dcyNNKUKC/rJ+ZkSmYTU0yqLw4WNdyBDZu6JWGPZoZjqncZbO+uqFYh8Y8Bk?=
 =?us-ascii?Q?I2iwx8ur5nzoEt58VuWzrqvW+J/TVH87BsmecU90QdJ+BNwXJBaj036q1nJh?=
 =?us-ascii?Q?/dgS7e1e+2412pGwzHzNhToHh/4/AwBw84ee0JT0KCYdganqHRts9sKgj72O?=
 =?us-ascii?Q?6uGQIMrEl9Nj+wE48UHpBJ+npYPutq3RmIFJxep13YiHPIFmJAOzEREnsyfs?=
 =?us-ascii?Q?7wWz1svnvmPrrs0EaWbS5BXi7BzSIAQwk6HlT4XIm5t4s333awtapc2MDcl8?=
 =?us-ascii?Q?1d7yZahSEwtDXkI+zHA72WiWVLaydwdo2khShG2TPzcC/S8WOVO25/LPapLr?=
 =?us-ascii?Q?2swN9mKlH2dPNGWqwCSHsFJbE5fsIs2DQ6/sPqO8snjbf87ANNXKsJIYb5gh?=
 =?us-ascii?Q?ZhSO1bcr+oaJyGxbVSz9+qxak7oHFQ7zguA0cGa/7p4FTUQqRVroUxAW1edU?=
 =?us-ascii?Q?6UjOQiRZd36/0bDr2i9eRH0Zgx9Y56oVM5pBMW4HBXQ9iI1/UUj/TMJMoJyN?=
 =?us-ascii?Q?IETWDfCrLDpzAn0TvwqnlyBFovbRSOIkQejOg6O0vP6KdjSapz6o0l6wnWxz?=
 =?us-ascii?Q?lerZbcJf5r5MG3Dys2AusC7fIcxLHO4kCR91e8yXDmPL8Ed+worHqaR25PjJ?=
 =?us-ascii?Q?rVsvbuUNfMIUIvZtoTNiv0iVJWn0SBUNg+Njx2x8udiQS2JKWmEzWXzBo6e9?=
 =?us-ascii?Q?3qmMWeTPoRJVZxXpQpHb2tKqBBzDqbVpbghnmzk7Zlnwsw1Mr+c3XAknVqpH?=
 =?us-ascii?Q?lPnUWZkD9Zl6htjopHmIKtC6znUZDirGx1GXQJuRTpWRs23UIz1zrCUBnVsV?=
 =?us-ascii?Q?PcyKQRlJ7PjR1bZ4VEOqEIrZIrh8r6MAQETlmLzm08fJ5q8kXrlcrqWWl+I6?=
 =?us-ascii?Q?N2Ujcg1VT3p9H5rqPmfQaJM1e8UHdH6MWWl983/+HzH5+7trs0Cafdy+h60o?=
 =?us-ascii?Q?VWNFHBcvpJ6LeTBblomPNpu3fDs3CG/I1jB/XZeGOm0=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31338477-2312-405d-b318-08d8bf28c11c
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3606.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2021 22:55:03.4904
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Rg+smvALx8obJyMZX8DM3vT4cAGOTEIOkgr+YbrYr/eC0WWSMiomj/EkqUc6Jey6A4peR7fR72SazAcQucJ1Jv2PcIGDYoId5AIN/89peAI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3827
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9872 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 spamscore=0
 suspectscore=0 phishscore=0 adultscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101220117
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9872 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 lowpriorityscore=0 bulkscore=0 adultscore=0 spamscore=0
 phishscore=0 priorityscore=1501 impostorscore=0 malwarescore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101220118
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Signed-off-by: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
---
 src/include/liburing.h          | 12 ++++++++++++
 src/include/liburing/io_uring.h |  9 +++++++++
 src/register.c                  | 29 +++++++++++++++++++++++++++--
 3 files changed, 48 insertions(+), 2 deletions(-)

diff --git a/src/include/liburing.h b/src/include/liburing.h
index 90403bc..c1e01ab 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -122,6 +122,9 @@ extern int io_uring_register_buffers(struct io_uring *ring,
 					const struct iovec *iovecs,
 					unsigned nr_iovecs);
 extern int io_uring_unregister_buffers(struct io_uring *ring);
+extern int io_uring_register_buffers_update(struct io_uring *ring, unsigned off,
+					struct iovec *iovecs,
+					unsigned nr_iovecs);
 extern int io_uring_register_files(struct io_uring *ring, const int *files,
 					unsigned nr_files);
 extern int io_uring_unregister_files(struct io_uring *ring);
@@ -382,6 +385,15 @@ static inline void io_uring_prep_files_update(struct io_uring_sqe *sqe,
 	io_uring_prep_rw(IORING_OP_FILES_UPDATE, sqe, -1, fds, nr_fds, offset);
 }
 
+static inline void io_uring_prep_buffers_update(struct io_uring_sqe *sqe,
+						struct iovec *iovs,
+						unsigned nr_iovs,
+						int offset)
+{
+	io_uring_prep_rw(IORING_OP_BUFFERS_UPDATE, sqe, -1, iovs, nr_iovs,
+			 offset);
+}
+
 static inline void io_uring_prep_fallocate(struct io_uring_sqe *sqe, int fd,
 					   int mode, off_t offset, off_t len)
 {
diff --git a/src/include/liburing/io_uring.h b/src/include/liburing/io_uring.h
index 0bb55b0..1ee9a0f 100644
--- a/src/include/liburing/io_uring.h
+++ b/src/include/liburing/io_uring.h
@@ -141,6 +141,7 @@ enum {
 	IORING_OP_SHUTDOWN,
 	IORING_OP_RENAMEAT,
 	IORING_OP_UNLINKAT,
+	IORING_OP_BUFFERS_UPDATE,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
@@ -284,17 +285,25 @@ enum {
 	IORING_UNREGISTER_PERSONALITY		= 10,
 	IORING_REGISTER_RESTRICTIONS		= 11,
 	IORING_REGISTER_ENABLE_RINGS		= 12,
+	IORING_REGISTER_BUFFERS_UPDATE		= 13,
 
 	/* this goes last */
 	IORING_REGISTER_LAST
 };
 
+/* deprecated, see struct io_uring_rsrc_update */
 struct io_uring_files_update {
 	__u32 offset;
 	__u32 resv;
 	__aligned_u64 /* __s32 * */ fds;
 };
 
+struct io_uring_rsrc_update {
+	__u32 offset;
+	__u32 resv;
+	__aligned_u64 data;
+};
+
 #define IO_URING_OP_SUPPORTED	(1U << 0)
 
 struct io_uring_probe_op {
diff --git a/src/register.c b/src/register.c
index 994aaff..45cf114 100644
--- a/src/register.c
+++ b/src/register.c
@@ -14,6 +14,31 @@
 
 #include "syscall.h"
 
+/*
+ * Register an update for an existing buffer set. The updates will start at
+ * 'off' in the original array, and 'nr_iovecs' is the number of buffers we'll
+ * update.
+ *
+ * Returns number of files updated on success, -ERROR on failure.
+ */
+int io_uring_register_buffers_update(struct io_uring *ring, unsigned off,
+				     struct iovec *iovecs, unsigned nr_iovecs)
+{
+	struct io_uring_rsrc_update up = {
+		.offset	= off,
+		.data	= (unsigned long) iovecs,
+	};
+	int ret;
+
+	ret = __sys_io_uring_register(ring->ring_fd,
+					IORING_REGISTER_BUFFERS_UPDATE, &up,
+					nr_iovecs);
+	if (ret < 0)
+		return -errno;
+
+	return ret;
+}
+
 int io_uring_register_buffers(struct io_uring *ring, const struct iovec *iovecs,
 			      unsigned nr_iovecs)
 {
@@ -49,9 +74,9 @@ int io_uring_unregister_buffers(struct io_uring *ring)
 int io_uring_register_files_update(struct io_uring *ring, unsigned off,
 				   int *files, unsigned nr_files)
 {
-	struct io_uring_files_update up = {
+	struct io_uring_rsrc_update up = {
 		.offset	= off,
-		.fds	= (unsigned long) files,
+		.data	= (unsigned long) files,
 	};
 	int ret;
 
-- 
1.8.3.1

