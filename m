Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BEA1301068
	for <lists+io-uring@lfdr.de>; Fri, 22 Jan 2021 23:57:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728310AbhAVW5Q (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 22 Jan 2021 17:57:16 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:41012 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729007AbhAVW4E (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 22 Jan 2021 17:56:04 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10MMreaY154351;
        Fri, 22 Jan 2021 22:55:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=biLaMWDJUXkVa3hRoliSX2eJ/DJjVK2HMKRItcJHnwM=;
 b=tfQRYGy+7Htwg5IeVDlUgNgnbf6GSkC0mSc406kE+qpfrzuNaFcvDUO+pcjwPBAnFE3g
 UeX96HYaxHDzBqjPZO6yonwlyZPJQCpEDRy6hI8qgE3Me7QQvPYBOM94Hlbke8XRmLGO
 DnZRQpvs7HHGv0xDautD9tC+bhdh4iyPRP9VQ5pSCy5RIZyHGLWkRdUO4digiWWeXh5P
 CU0sG2n12OHJbP3O4ClE+NbJ4mrpomzrZo1a7SV+CI8N3UC5LnM3g5X4Vr65jJUpJybQ
 +5ZY8zfNM786nqyq7XKxwCySW+ErK03QlC6vEjYsaJ6ucGZhRa5ZA0HVS/JcEt/7wQDo vQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 3668qaphpe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Jan 2021 22:55:09 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10MMt0Oo162490;
        Fri, 22 Jan 2021 22:55:08 GMT
Received: from nam04-co1-obe.outbound.protection.outlook.com (mail-co1nam04lp2054.outbound.protection.outlook.com [104.47.45.54])
        by userp3020.oracle.com with ESMTP id 3668r1pqjp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Jan 2021 22:55:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fmIXrc/BLLKxkW3z7l9Vodpi4zh6qzVGcKxbggUrYXTf/25UCtkeNkyKv3edT4SVhhEAAGm/VhjS6V249TxSiEmts18SNtW5NKVOccyb/PRlHDNPEsTVYoAILTga4h2z6x0n4axJjg1jx5c4bQLndaIwl1bOnQp5+oEzoYuIXVTie0lJc64VMP0QGizPHN91ShODYmepAc0nm4q/u0kIAM1JN7XnMp5MFuMggQWoI4rjOJktthVANb7UKOYvjiIi6O0uQW6PwW7f0KLS092n+kEo+ENngD6AN7NYuvHZaGSoao6ngAslA0msYJAc6fqpvz6dEEiNFcp33ku9spLqmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=biLaMWDJUXkVa3hRoliSX2eJ/DJjVK2HMKRItcJHnwM=;
 b=TXZPb58B2oEKASF1ghS5PYEzQX95WLnkcw/9GzRssh5Gp0YuJy/lUWtcj2eIQdQ74EC0hJUy8bvUK2s+RuXBQ9KnItiWAW4TcrjsQ8lYaW/lvTxHF06fWMhhf92UpvFHB7lrE6auNP/COWAgaPBsxnOhak1vIdPSU6zQ+Q4nQuJPRP0KdDKoeCpHsqrsm7yTOVr4PcYf3Ko+L3D1KIZ3+YM2BKEUfrEqJUHYgaAYNyAVmah+vDv0lWfgkffDed4zR5WZXqNhOd7XZifLuGX2jsLVPYiiNklNAOF+VwvhAT8Q+edEt4sYal++2hWUxDgdo2B0Rfg2MJDZbGvXpEcvtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=biLaMWDJUXkVa3hRoliSX2eJ/DJjVK2HMKRItcJHnwM=;
 b=rWzhh53CBsoAqQAtAkWvE6t3AKaA8R7A31CjnRZg8489mBVzHeqZOj0w/GJhEtWLtmOc8vbbMd0v6Gnvqn50n5dX/PE1KYry0FXqW3CwaS3o93v3Kkzhn3K1Td72SybNXEJFJZ6hI4gOPIx/Z9RFl+K9T+DsRJti1qhi/57gQpo=
Authentication-Results: kernel.dk; dkim=none (message not signed)
 header.d=none;kernel.dk; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3606.namprd10.prod.outlook.com (2603:10b6:a03:11b::27)
 by BY5PR10MB3827.namprd10.prod.outlook.com (2603:10b6:a03:1b4::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.15; Fri, 22 Jan
 2021 22:55:06 +0000
Received: from BYAPR10MB3606.namprd10.prod.outlook.com
 ([fe80::359f:18a0:4d25:9978]) by BYAPR10MB3606.namprd10.prod.outlook.com
 ([fe80::359f:18a0:4d25:9978%6]) with mapi id 15.20.3784.013; Fri, 22 Jan 2021
 22:55:06 +0000
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
To:     axboe@kernel.dk, io-uring@vger.kernel.org
Subject: [PATCH v2 04/10] test/buffer-update: add buffer registration update test
Date:   Fri, 22 Jan 2021 14:54:53 -0800
Message-Id: <1611356099-60732-5-git-send-email-bijan.mottahedeh@oracle.com>
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
Received: from ca-ldom147.us.oracle.com (138.3.200.3) by CH0PR04CA0047.namprd04.prod.outlook.com (2603:10b6:610:77::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.11 via Frontend Transport; Fri, 22 Jan 2021 22:55:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4bcd5be7-7ece-4a05-a3fe-08d8bf28c2df
X-MS-TrafficTypeDiagnostic: BY5PR10MB3827:
X-Microsoft-Antispam-PRVS: <BY5PR10MB3827E452BBE390C08F6E52FEE4A09@BY5PR10MB3827.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:250;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CI0mEjtVRX0dckvDHEcPajV/28m5KrBHS4T6BIL1Tkb8JWgGfxIhLovTpWUBZGDvSH3vPlc5dNNqVE+UwxSxycKxQ95YnEDix1rVT9BESfd98MBk1bIR2gPCwG4qXI4VcyJ38PXcqBqp/GYMKJ7dc1OqN1n5KQQIA5B6NQ8GoVwifDqIU7e42OihBsOe1+QtDGD2ZHpASkFzf2jiSSwklS+/mCZvWuFsoZ42T70m8G7/vjABpcl0jXQsDFAAg2t5sdPyK1qA559lnhGbPYZFfdjezkNuLj6IhPl2wVVcAomzcMI0MP7jzoNhoHj1Qmt1GOgqQ2kzjRuGSRdsboVEGFKPpDkcNUw6pDWQR4eShvv8EUWaS7uUbYPHEMNRTZbCHWNH/Lv9/MTOxramKT/pTA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3606.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(366004)(39860400002)(376002)(346002)(83380400001)(44832011)(316002)(52116002)(36756003)(7696005)(2616005)(956004)(15650500001)(6666004)(66556008)(66946007)(66476007)(2906002)(478600001)(26005)(86362001)(5660300002)(8936002)(8676002)(16526019)(6486002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?HS01Azc70/llChGPU/xXm8M4g0huAovsQhBNDp8Yjo4Yzydo+YrJfdnDNW5G?=
 =?us-ascii?Q?+S5SqdD1KsyU6lnCpW0zBap5rK8PSPW3gnV/O482QCenPnUwAHSpHSMq/oSW?=
 =?us-ascii?Q?w7jOmaM/L4a0asWyzMPc/MAQ2A8azXhEl1wocIkXaBOGFlVvD4Co0ECcFShk?=
 =?us-ascii?Q?YVchMX3QC1Mi2t5/WzAJX+LZn2kiHA5LOZmVE/iaktalID58Zt2rgPYOg1w4?=
 =?us-ascii?Q?JyY/+wrFJqJcy3fnsm3BstMUmCmNNYAtENmdpE0A/qoUIWIQtHqvmwdHxbzd?=
 =?us-ascii?Q?FDk8llQQe3e4bXXWlkf3uVL88gTC316fP/AQc/CamnnwpIJ3XJuWNF5nMI03?=
 =?us-ascii?Q?kfdV/SU9r7ikVVkfD6pjmPfFqD2qHvJuOUQGCKUulu39i4lvfyhBlLhYVRMx?=
 =?us-ascii?Q?pmT275ijGXYIg0wiD5jpRzjRF6xbWitxQcK4NedY+GifIJBTVzkKOUiULwFF?=
 =?us-ascii?Q?3nYwvt2kuVLOcGaeiQYvPf4xYS+oYlaUPmG70L7H/cVbByIt8/Yx4UDpmxKZ?=
 =?us-ascii?Q?DsbQHhTUyosDHAt/xLrYxF+bpf0Xa6r0a4EXsV0UnI9HYJPgMGoePjC2oXSA?=
 =?us-ascii?Q?Fknk24fhob/4m0KzrgqPMiic4oLhRFHL9hbNS3/7Pd4hPvVOkCKhOy6A5dUB?=
 =?us-ascii?Q?g4GvNJb16i4kbExvth3em6xmkAG/3T2MoErKh7qa3tExtlOTykpHIDt5piLz?=
 =?us-ascii?Q?jvkM760cMVm2i/mh7jU24u+M/dkhzcILl5Glt4xcDhz5lNlCYE8KTmqciS02?=
 =?us-ascii?Q?RrqAqMC8CjLc6P9ZTRCu4Oc7RlhteUEXVyr25iu8xdp7hDrWgwlYw4rBtOmH?=
 =?us-ascii?Q?zNYaWUAxm67HOi12KriYBjb8necyJsKbw5CU6zHGc/GrevMnBeHgnmLJE1aW?=
 =?us-ascii?Q?xBGy+RsZdcULaY/TvkFWAbuKhnin/ufMT3vggotapELnv85d9Bl908GEBJ4i?=
 =?us-ascii?Q?pLUmk9iXuzA0/VsUFgbgZnHRKRzLsHrcwxxrs040jeI=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4bcd5be7-7ece-4a05-a3fe-08d8bf28c2df
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3606.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2021 22:55:06.3457
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SPMHQvgbYZeRkWtmpL8NWqNFDH+7dX0MNPBM8bka0kqtb3tA92s6tZ3tIdFY4W7Kq2hj2XsVRqNzthEjXz+7l9bRDT2M5xYcuVTppj+4wx0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3827
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9872 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 adultscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101220118
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9872 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 impostorscore=0 mlxscore=0 priorityscore=1501 phishscore=0 mlxlogscore=999
 lowpriorityscore=0 malwarescore=0 adultscore=0 clxscore=1015 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101220118
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Signed-off-by: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
---
 .gitignore           |   1 +
 test/Makefile        |   2 +
 test/buffer-update.c | 165 +++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 168 insertions(+)
 create mode 100644 test/buffer-update.c

diff --git a/.gitignore b/.gitignore
index 9d30cf7..b44560e 100644
--- a/.gitignore
+++ b/.gitignore
@@ -31,6 +31,7 @@
 /test/b19062a56726-test
 /test/b5837bd5311d-test
 /test/buffer-register
+/test/buffer-update
 /test/ce593a6c480a-test
 /test/close-opath
 /test/config.local
diff --git a/test/Makefile b/test/Makefile
index 4e1529d..79e3e00 100644
--- a/test/Makefile
+++ b/test/Makefile
@@ -30,6 +30,7 @@ test_targets += \
 	b19062a56726-test \
 	b5837bd5311d-test \
 	buffer-register \
+	buffer-update \
 	ce593a6c480a-test \
 	close-opath \
 	connect \
@@ -154,6 +155,7 @@ test_srcs := \
 	b19062a56726-test.c \
 	b5837bd5311d-test.c \
 	buffer-register.c \
+	buffer-update.c \
 	ce593a6c480a-test.c \
 	close-opath.c \
 	connect.c \
diff --git a/test/buffer-update.c b/test/buffer-update.c
new file mode 100644
index 0000000..5f926aa
--- /dev/null
+++ b/test/buffer-update.c
@@ -0,0 +1,165 @@
+/* SPDX-License-Identifier: MIT */
+/*
+ * Description: run various buffer registration tests
+ *
+ */
+#include <errno.h>
+#include <stdio.h>
+#include <unistd.h>
+#include <stdlib.h>
+#include <string.h>
+#include <fcntl.h>
+
+#include "liburing.h"
+
+#define NBUFS	10
+
+static int pagesize;
+
+static struct iovec *alloc_bufs(int nr_bufs)
+{
+	struct iovec *iovs;
+	void *buf;
+	int i;
+
+	iovs = calloc(nr_bufs, sizeof(struct iovec));
+	if (!iovs) {
+		perror("malloc");
+		return NULL;
+	}
+
+	for (i = 0; i < nr_bufs; i++) {
+		buf = malloc(pagesize);
+		if (!buf) {
+			perror("malloc");
+			iovs = NULL;
+			break;
+		}
+		iovs[i].iov_base = buf;
+		iovs[i].iov_len = pagesize;
+	}
+
+	return iovs;
+}
+
+static void free_bufs(struct iovec *iovs, int nr_bufs)
+{
+	int i;
+
+	for (i = 0; i < nr_bufs; i++)
+		free(iovs[i].iov_base);
+}
+
+static int test_update_multiring(struct io_uring *r1, struct io_uring *r2,
+				 struct io_uring *r3, int do_unreg)
+{
+	struct iovec *iovs, *newiovs;
+
+	iovs = alloc_bufs(NBUFS);
+	newiovs = alloc_bufs(NBUFS);
+
+	if (io_uring_register_buffers(r1, iovs, NBUFS) ||
+	    io_uring_register_buffers(r2, iovs, NBUFS) ||
+	    io_uring_register_buffers(r3, iovs, NBUFS)) {
+		fprintf(stderr, "%s: register buffers failed\n", __FUNCTION__);
+		goto err;
+	}
+
+	if (io_uring_register_buffers_update(r1, 0, newiovs, NBUFS) != NBUFS ||
+	    io_uring_register_buffers_update(r2, 0, newiovs, NBUFS) != NBUFS ||
+	    io_uring_register_buffers_update(r3, 0, newiovs, NBUFS) != NBUFS) {
+		fprintf(stderr, "%s: update buffers failed\n", __FUNCTION__);
+		goto err;
+	}
+
+	if (!do_unreg)
+		goto done;
+
+	if (io_uring_unregister_buffers(r1) ||
+	    io_uring_unregister_buffers(r2) ||
+	    io_uring_unregister_buffers(r3)) {
+		fprintf(stderr, "%s: unregister buffers failed\n",
+			__FUNCTION__);
+		goto err;
+	}
+
+done:
+	free_bufs(iovs, NBUFS);
+	free_bufs(newiovs, NBUFS);
+	return 0;
+err:
+	free_bufs(iovs, NBUFS);
+	free_bufs(newiovs, NBUFS);
+	return 1;
+}
+
+static int test_sqe_update(struct io_uring *ring)
+{
+	struct io_uring_sqe *sqe;
+	struct io_uring_cqe *cqe;
+	struct iovec *iovs;
+	int ret;
+
+	iovs = calloc(NBUFS, sizeof(struct iovec));
+
+	sqe = io_uring_get_sqe(ring);
+	io_uring_prep_buffers_update(sqe, iovs, NBUFS, 0);
+	ret = io_uring_submit(ring);
+	if (ret != 1) {
+		fprintf(stderr, "submit: %d\n", ret);
+		return 1;
+	}
+
+	ret = io_uring_wait_cqe(ring, &cqe);
+	if (ret) {
+		fprintf(stderr, "wait: %d\n", ret);
+		return 1;
+	}
+
+	ret = cqe->res;
+	io_uring_cqe_seen(ring, cqe);
+	if (ret == -EINVAL) {
+		fprintf(stdout, "IORING_OP_BUFFERSS_UPDATE not supported" \
+			", skipping\n");
+		return 0;
+	}
+	return ret != NBUFS;
+}
+
+int main(int argc, char *argv[])
+{
+	struct io_uring r1, r2, r3;
+	int ret;
+
+	if (argc > 1)
+		return 0;
+
+	pagesize = getpagesize();
+
+	if (io_uring_queue_init(8, &r1, 0) ||
+	    io_uring_queue_init(8, &r2, 0) ||
+	    io_uring_queue_init(8, &r3, 0)) {
+		fprintf(stderr, "ring setup failed\n");
+		return 1;
+	}
+
+	ret = test_update_multiring(&r1, &r2, &r3, 1);
+	if (ret) {
+		fprintf(stderr, "test_update_multiring w/unreg\n");
+		return ret;
+	}
+
+	ret = test_update_multiring(&r1, &r2, &r3, 0);
+	if (ret) {
+		fprintf(stderr, "test_update_multiring wo/unreg\n");
+		return ret;
+	}
+
+	ret = test_sqe_update(&r1);
+	if (ret) {
+		fprintf(stderr, "test_sqe_update failed\n");
+		return ret;
+	}
+
+	return 0;
+}
-- 
1.8.3.1

