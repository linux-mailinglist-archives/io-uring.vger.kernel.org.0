Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FDBD301067
	for <lists+io-uring@lfdr.de>; Fri, 22 Jan 2021 23:57:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728270AbhAVW5Q (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 22 Jan 2021 17:57:16 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:40976 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728924AbhAVW4E (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 22 Jan 2021 17:56:04 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10MMreO0154335;
        Fri, 22 Jan 2021 22:55:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=8WVy1sSWJW8MsxWfulKRtA4kjnpy3P0kyMz1rdFVmho=;
 b=HsjqN/+8RRc/y7+c2AhUZ9N2Ick1+GUte4kb47TvuZC4M1JTG/5qH3JqzPcvl8yumfni
 i1XNVuOgFQ91pKwayIcrGJDATjQKhm98FCxckGWn2WevjuUjFFZJDuLLsPmw12eG008E
 xXPu+24yu1pM2SGqX1ejY3Dk4JSUUOJKbJj3VWQMMj6Liyoa7WNGKuxk6tcG3hPaBDUA
 WS831SPjKzLCtYTd8f8txkEiOAzG40kJjFJwX79TKC8H1zyUjmP4j8VZOPFZhGnGTLJo
 bbFi4NLsy2It85Lp4sUY1s8FzwGfix9oBMe51JuzIDlAAOgYwpd+jCJvocCNXGWkQeDo ag== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 3668qaphp9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Jan 2021 22:55:07 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10MMjsIL062865;
        Fri, 22 Jan 2021 22:55:06 GMT
Received: from nam04-co1-obe.outbound.protection.outlook.com (mail-co1nam04lp2059.outbound.protection.outlook.com [104.47.45.59])
        by userp3030.oracle.com with ESMTP id 3668rhjqpt-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Jan 2021 22:55:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MZz8MDtQ1SQpdO0Tfda40wXuiz18NAnIqSHFE/ukfR5pivk0cO2ejc51XeF+9Yeu09Fe2abesut/NY8pFCV4A0ZkDe4nRxaXosTZ3ht/ZnyVWQ+m6Y2WzFn2xHmCKot62iJMyFDdUP6G1GtwPXOpr5//2p+Uo0q5Z6WfmNEU8QMDyS0J/LTk9NeKBac59md+NIVd46RADbrWceWUMQdwzQxCkNoCx9Y9A4CVzRJua85X2cWD5sUNCQB1wUoVwknIttqDQikLICI95DLlitQEG8t5lCYcXZjgWRKqijQuMXNNbP05rh5itegwJVdJBVAXLq7c2gVU9Dvwtxmu5/4IWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8WVy1sSWJW8MsxWfulKRtA4kjnpy3P0kyMz1rdFVmho=;
 b=Yz2nmv+3JOil2zRn3mNcsN4t1Kk3PA/MTpC/MjolWI4lmt65np0TlIXZMw/s1UXhXoDIO3dhqIX+9n3eYT5Z7sd3Wn+eswKrgbo5Fm13McJn4NGUE9z0DOQBN3qloaPxfVCPF+axxBu3nwKq2mfKoZMzFLD+AqcI2SfEYVW/2J2ufcPdKZqgOjcEJGAXM7NW8J/L3mUxnftgP7IzyhjbupeHBBMGFTkcrpUn71xcmD/kIPo0R27R2CAYaPN1LEOKEFBD73/Vf0EjJW3eshHzoEmhP9rLuGCl2pv/fVXSLZQC14yyKrYZe9SskEVekkr8hCpvL60gQkImoVAmoADtDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8WVy1sSWJW8MsxWfulKRtA4kjnpy3P0kyMz1rdFVmho=;
 b=JrBl1t4OtUIgzGNYCzCzSoS+KQRVLbWYS5dYnlvvX3tpgzTmoN18LocBRrCmMUuGZPq+54rHrBnhuauytXP6peaJxYEcTKoBI0M62NrCEThqHk17/pnOuoenhlJ8ijStSSJgGeLJueVXPeVMlgFbWSSapn/wB+NT+H8Dp69+Y0s=
Authentication-Results: kernel.dk; dkim=none (message not signed)
 header.d=none;kernel.dk; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3606.namprd10.prod.outlook.com (2603:10b6:a03:11b::27)
 by BY5PR10MB3827.namprd10.prod.outlook.com (2603:10b6:a03:1b4::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.15; Fri, 22 Jan
 2021 22:55:05 +0000
Received: from BYAPR10MB3606.namprd10.prod.outlook.com
 ([fe80::359f:18a0:4d25:9978]) by BYAPR10MB3606.namprd10.prod.outlook.com
 ([fe80::359f:18a0:4d25:9978%6]) with mapi id 15.20.3784.013; Fri, 22 Jan 2021
 22:55:05 +0000
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
To:     axboe@kernel.dk, io-uring@vger.kernel.org
Subject: [PATCH v2 03/10] test/buffer-register: add buffer registration test
Date:   Fri, 22 Jan 2021 14:54:52 -0800
Message-Id: <1611356099-60732-4-git-send-email-bijan.mottahedeh@oracle.com>
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
Received: from ca-ldom147.us.oracle.com (138.3.200.3) by CH0PR04CA0047.namprd04.prod.outlook.com (2603:10b6:610:77::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.11 via Frontend Transport; Fri, 22 Jan 2021 22:55:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 703081e4-fc8e-4d94-4607-08d8bf28c252
X-MS-TrafficTypeDiagnostic: BY5PR10MB3827:
X-Microsoft-Antispam-PRVS: <BY5PR10MB3827CEDA2F47B387630C7B80E4A09@BY5PR10MB3827.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:639;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +jUVVHCuCIbTn6PK1qdQUNLwRuvqmzsksw14N3WX8g/picGjFBktFh7FZb/J5+Du+t5b6gLTlfI2Zkwh6kVmETabJuK4TKNuw6n500GdeRcnpXUHmzxz7TkHmlBe39nk+eKJVt7LkP3L2+R/d0hBEcn/rPWsrgcMN9mRjvc6chx64UkkL6NTvnGZgcKWnzH8Dtc6H8GncumDUytgEM+nqzoCW9tSKpGD+yF9G27XToqjgni0Dban9I9mKxcGkQ6nsXB0Jx7WEZmN2bacxHwVkULAQPjlCMFSucILe0iBSMhtjTU72zjwyiTBVFzRhQMgJLjXXXnp4MgUVsk4Pk/4UMcd6s+xBM0GWw+G1ciIOC5MHJvl2mge7l445l/oONKhs9gfDwkUK8I8zQip4tf5rg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3606.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(366004)(39860400002)(376002)(346002)(83380400001)(44832011)(316002)(52116002)(36756003)(7696005)(2616005)(956004)(6666004)(66556008)(66946007)(66476007)(2906002)(478600001)(26005)(86362001)(5660300002)(8936002)(8676002)(16526019)(30864003)(6486002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?wJfUvrDAMEXzNQrb4POUscxpCfhGwo/EwOXUtzrohJNbd+CQCIDdxOgZLxGG?=
 =?us-ascii?Q?DzPg7xbZVMVNROD//LZz6x0hW4v3KGPy4meJsPvawxMueElC14F6CJ5YgsW9?=
 =?us-ascii?Q?1N1QXfrzlrQuZJUVohyPf7IAK2QUiWUVaDUayS4+27VmtMW43c9mS0KHVSZ6?=
 =?us-ascii?Q?0hN6/ZB/Wu0IdrlSU7q/0YaW/knCXP7h4LzyjzrGHckZRIqmU7c+hlbbtAgs?=
 =?us-ascii?Q?d56BRs4xAvccDkj/BWyCEycgTQ8KsK5r6mavIz3nwkrOHOnPg/X/gC1SoN3Y?=
 =?us-ascii?Q?ZfK6UL18RjJoZ0lvX8Iw24vNWipDFtxuG8ZUHSk7JJLpDxU0QvmYphyk6qDw?=
 =?us-ascii?Q?t2SgXGxSabcEOo9x82Q0AUarrzHRfE10/5F6nC8FPZ5xIa2DMqCImrwV6DXH?=
 =?us-ascii?Q?p1ItBf80eaq7XM2JqUT3610c2k+nSuqIar3M+Q2EP992gC/iwz05K5PpQxvS?=
 =?us-ascii?Q?eTtGXOUcuEdX+m+u687Wn2uauhN1DcHDJgXHkqH+AyXjEOD6WaLUjidppCSV?=
 =?us-ascii?Q?8u/hrznX7hysDe+GlYukbKCTGkW2E35nwhiGuJyZTvhqxB568ZH7nul1Q/sG?=
 =?us-ascii?Q?eAYWK3+Ozs+8BaMRwsMW+Dd1E5Vmcii3et1tDuV7VjSNGCsrPGyv3cIZ5svU?=
 =?us-ascii?Q?J7zHKsP4h9h0gefuGOBAHKb6nzokZCNX8Zb1N7U+bbgEffiCG9yMmLdM+yQx?=
 =?us-ascii?Q?M7xPiUB9pVyj0abIdufpmynezYsyFKUbmSlhkWA7iiKf3R6FZqH74qhb0nUk?=
 =?us-ascii?Q?G2Tgc6EtYqpTyhI29Vgf9rPL/qxaExE8WavT+nHmmD/GVOgoceIntuSFLaqy?=
 =?us-ascii?Q?nJ6hx/U990v7IPWx05SM5kPq86oxQ8k4EnwbR63w+NfynGtRwYNbKOF6iy6h?=
 =?us-ascii?Q?r2NWMqzXJMTY4C0uqcgUp+BbLnriv/pzapsjdRWJCR6bZlJKgGmHUYhnVHxn?=
 =?us-ascii?Q?edYdcPW7wDFo0vst4k/MyDvq37/rhhO0qBrfjaKWuYE=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 703081e4-fc8e-4d94-4607-08d8bf28c252
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3606.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2021 22:55:05.4872
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n6iN+R/liXxlbImq4+9Pafpev8+g+GlIUYGzaEA4dIhFNTNlt4ScZIiA2Ao8YfxYS/MebUKpa6YhPh4Js+x+4wDZWzBGS1fsstIWBaAW8nE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3827
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9872 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 spamscore=0
 suspectscore=0 phishscore=0 adultscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101220117
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
 .gitignore             |   1 +
 test/Makefile          |   2 +
 test/buffer-register.c | 701 +++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 704 insertions(+)
 create mode 100644 test/buffer-register.c

diff --git a/.gitignore b/.gitignore
index 360064a..9d30cf7 100644
--- a/.gitignore
+++ b/.gitignore
@@ -30,6 +30,7 @@
 /test/across-fork
 /test/b19062a56726-test
 /test/b5837bd5311d-test
+/test/buffer-register
 /test/ce593a6c480a-test
 /test/close-opath
 /test/config.local
diff --git a/test/Makefile b/test/Makefile
index ce5d9e3..4e1529d 100644
--- a/test/Makefile
+++ b/test/Makefile
@@ -29,6 +29,7 @@ test_targets += \
 	across-fork splice \
 	b19062a56726-test \
 	b5837bd5311d-test \
+	buffer-register \
 	ce593a6c480a-test \
 	close-opath \
 	connect \
@@ -152,6 +153,7 @@ test_srcs := \
 	across-fork.c \
 	b19062a56726-test.c \
 	b5837bd5311d-test.c \
+	buffer-register.c \
 	ce593a6c480a-test.c \
 	close-opath.c \
 	connect.c \
diff --git a/test/buffer-register.c b/test/buffer-register.c
new file mode 100644
index 0000000..35176a1
--- /dev/null
+++ b/test/buffer-register.c
@@ -0,0 +1,701 @@
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
+static int pagesize;
+
+static void free_bufs(struct iovec *iovs, int nr_bufs)
+{
+	int i;
+
+	if (!iovs)
+		return;
+
+	for (i = 0; i < nr_bufs; i++)
+		if (iovs[i].iov_base)
+			free(iovs[i].iov_base);
+
+	free(iovs);
+}
+
+static struct iovec *alloc_bufs(int nr_bufs, int extra)
+{
+	struct iovec *iovs;
+	void *buf;
+	int i;
+
+	iovs = calloc(nr_bufs + extra, sizeof(struct iovec));
+	if (!iovs) {
+		perror("malloc");
+		return NULL;
+	}
+
+	for (i = 0; i < nr_bufs; i++) {
+		buf = malloc(pagesize);
+		if (!buf) {
+			perror("malloc");
+			break;
+		}
+		iovs[i].iov_base = buf;
+		iovs[i].iov_len = pagesize;
+	}
+
+	/* extra buffers already set to zero */
+
+	if (i < nr_bufs) {
+		free_bufs(iovs, nr_bufs);
+		iovs = NULL;
+	}
+
+	return iovs;
+}
+
+static int test_shrink(struct io_uring *ring)
+{
+	int ret, off;
+	struct iovec *iovs, iov = {0};
+
+	iovs = alloc_bufs(50, 0);
+	if (!iovs)
+		return 1;
+	ret = io_uring_register_buffers(ring, iovs, 50);
+	if (ret) {
+		fprintf(stderr, "%s: register ret=%d\n", __FUNCTION__, ret);
+		goto err;
+	}
+
+	off = 0;
+	do {
+		ret = io_uring_register_buffers_update(ring, off, &iov, 1);
+		if (ret != 1) {
+			if (off == 50 && ret == -EINVAL)
+				break;
+			fprintf(stderr, "%s: update ret=%d\n", __FUNCTION__,
+				ret);
+			break;
+		}
+		off++;
+	} while (1);
+
+	ret = io_uring_unregister_buffers(ring);
+	if (ret) {
+		fprintf(stderr, "%s: unregister ret=%d\n", __FUNCTION__, ret);
+		goto err;
+	}
+
+	free_bufs(iovs, 50);
+	return 0;
+err:
+	free_bufs(iovs, 50);
+	return 1;
+}
+
+static int test_grow(struct io_uring *ring)
+{
+	int ret, off, i;
+	struct iovec *iovs, *ups = NULL;
+
+	iovs = alloc_bufs(50, 250);
+	if (!iovs)
+		return 1;
+	ret = io_uring_register_buffers(ring, iovs, 300);
+	if (ret) {
+		fprintf(stderr, "%s: register ret=%d\n", __FUNCTION__, ret);
+		goto err;
+	}
+
+	ups = alloc_bufs(250, 0);
+	if (!ups)
+		goto err;
+	i = 0;
+	off = 50;
+	do {
+		ret = io_uring_register_buffers_update(ring, off, ups + i, 1);
+		if (ret != 1) {
+			if (off == 300 && ret == -EINVAL)
+				break;
+			fprintf(stderr, "%s: update ret=%d\n", __FUNCTION__,
+				ret);
+			break;
+		}
+		if (off >= 300) {
+			fprintf(stderr, "%s: Succeeded beyond end-of-list?\n",
+				__FUNCTION__);
+			goto err;
+		}
+		off++;
+		i++;
+	} while (1);
+
+	ret = io_uring_unregister_buffers(ring);
+	if (ret) {
+		fprintf(stderr, "%s: unregister ret=%d\n", __FUNCTION__, ret);
+		goto err;
+	}
+
+	free_bufs(iovs, 300);
+	free_bufs(ups, 250);
+	return 0;
+err:
+	free_bufs(iovs, 300);
+	free_bufs(ups, 250);
+	return 1;
+}
+
+static int test_replace_all(struct io_uring *ring)
+{
+	struct iovec *iovs, *ups = NULL;
+	int ret;
+
+	iovs = alloc_bufs(100, 0);
+	if (!iovs)
+		return 1;
+	ret = io_uring_register_buffers(ring, iovs, 100);
+	if (ret) {
+		fprintf(stderr, "%s: register ret=%d\n", __FUNCTION__, ret);
+		goto err;
+	}
+
+	ups = alloc_bufs(0, 100);
+
+	ret = io_uring_register_buffers_update(ring, 0, ups, 100);
+	if (ret != 100) {
+		fprintf(stderr, "%s: update ret=%d\n", __FUNCTION__, ret);
+		goto err;
+	}
+
+	ret = io_uring_unregister_buffers(ring);
+	if (ret) {
+		fprintf(stderr, "%s: unregister ret=%d\n", __FUNCTION__, ret);
+		goto err;
+	}
+
+	free_bufs(iovs, 100);
+	free_bufs(ups, 100);
+	return 0;
+err:
+	free_bufs(iovs, 100);
+	free_bufs(ups, 100);
+	return 1;
+}
+
+static int test_replace(struct io_uring *ring)
+{
+	struct iovec *iovs, *ups = NULL;
+	int ret;
+
+	iovs = alloc_bufs(100, 0);
+	if (!iovs)
+		return 1;
+	ret = io_uring_register_buffers(ring, iovs, 100);
+	if (ret) {
+		fprintf(stderr, "%s: register ret=%d\n", __FUNCTION__, ret);
+		goto err;
+	}
+
+	ups = alloc_bufs(10, 0);
+	if (!ups)
+		goto err;
+	ret = io_uring_register_buffers_update(ring, 90, ups, 10);
+	if (ret != 10) {
+		fprintf(stderr, "%s: update ret=%d\n", __FUNCTION__, ret);
+		goto err;
+	}
+
+	ret = io_uring_unregister_buffers(ring);
+	if (ret) {
+		fprintf(stderr, "%s: unregister ret=%d\n", __FUNCTION__, ret);
+		goto err;
+	}
+
+	free_bufs(iovs, 100);
+	free_bufs(ups, 10);
+	return 0;
+err:
+	free_bufs(iovs, 100);
+	free_bufs(ups, 10);
+	return 1;
+}
+
+static int test_removals(struct io_uring *ring)
+{
+	struct iovec *iovs, *ups = NULL;
+	int ret;
+
+	iovs = alloc_bufs(100, 0);
+	if (!iovs)
+		return 1;
+	ret = io_uring_register_buffers(ring, iovs, 100);
+	if (ret) {
+		fprintf(stderr, "%s: register ret=%d\n", __FUNCTION__, ret);
+		goto err;
+	}
+
+	ups = alloc_bufs(0, 10);
+	if (!ups)
+		goto err;
+	ret = io_uring_register_buffers_update(ring, 50, ups, 10);
+	if (ret != 10) {
+		fprintf(stderr, "%s: update ret=%d\n", __FUNCTION__, ret);
+		goto err;
+	}
+
+	ret = io_uring_unregister_buffers(ring);
+	if (ret) {
+		fprintf(stderr, "%s: unregister ret=%d\n", __FUNCTION__, ret);
+		goto err;
+	}
+
+	free_bufs(iovs, 100);
+	free_bufs(ups, 0);
+	return 0;
+err:
+	free_bufs(iovs, 100);
+	free_bufs(ups, 0);
+	return 1;
+}
+
+static int test_additions(struct io_uring *ring)
+{
+	struct iovec *iovs, *ups = NULL;
+	int ret;
+
+	iovs = alloc_bufs(100, 100);
+	if (!iovs)
+		return 1;
+	ret = io_uring_register_buffers(ring, iovs, 200);
+	if (ret) {
+		fprintf(stderr, "%s: register ret=%d\n", __FUNCTION__, ret);
+		goto err;
+	}
+
+	ups = alloc_bufs(2, 0);
+	if (!ups)
+		goto err;
+	ret = io_uring_register_buffers_update(ring, 100, ups, 2);
+	if (ret != 2) {
+		fprintf(stderr, "%s: update ret=%d\n", __FUNCTION__, ret);
+		goto err;
+	}
+
+	ret = io_uring_unregister_buffers(ring);
+	if (ret) {
+		fprintf(stderr, "%s: unregister ret=%d\n", __FUNCTION__, ret);
+		goto err;
+	}
+
+	free_bufs(iovs, 100);
+	free_bufs(ups, 2);
+	return 0;
+err:
+	free_bufs(iovs, 100);
+	free_bufs(ups, 2);
+	return 1;
+}
+
+static int test_sparse(struct io_uring *ring)
+{
+	struct iovec *iovs;
+	int ret;
+
+	iovs = alloc_bufs(100, 100);
+	if (!iovs)
+		return 1;
+	ret = io_uring_register_buffers(ring, iovs, 200);
+	if (ret) {
+		fprintf(stderr, "%s: register ret=%d\n", __FUNCTION__, ret);
+		goto err;
+	}
+	ret = io_uring_unregister_buffers(ring);
+	if (ret) {
+		fprintf(stderr, "%s: unregister ret=%d\n", __FUNCTION__, ret);
+		goto err;
+	}
+	free_bufs(iovs, 100);
+	return 0;
+err:
+	free_bufs(iovs, 100);
+	return 1;
+}
+
+static int test_basic_many(struct io_uring *ring)
+{
+	struct iovec *iovs;
+	int ret;
+
+	iovs = alloc_bufs(1024, 0);
+	ret = io_uring_register_buffers(ring, iovs, 768);
+	if (ret) {
+		fprintf(stderr, "%s: register %d\n", __FUNCTION__, ret);
+		goto err;
+	}
+	ret = io_uring_unregister_buffers(ring);
+	if (ret) {
+		fprintf(stderr, "%s: unregister %d\n", __FUNCTION__, ret);
+		goto err;
+	}
+	free_bufs(iovs, 1024);
+	return 0;
+err:
+	free_bufs(iovs, 1024);
+	return 1;
+}
+
+static int test_basic(struct io_uring *ring)
+{
+	struct iovec *iovs;
+	int ret;
+
+	iovs = alloc_bufs(100, 0);
+	ret = io_uring_register_buffers(ring, iovs, 100);
+	if (ret) {
+		fprintf(stderr, "%s: register %d\n", __FUNCTION__, ret);
+		goto err;
+	}
+	ret = io_uring_unregister_buffers(ring);
+	if (ret) {
+		fprintf(stderr, "%s: unregister %d\n", __FUNCTION__, ret);
+		goto err;
+	}
+	free_bufs(iovs, 100);
+	return 0;
+err:
+	free_bufs(iovs, 100);
+	return 1;
+}
+
+/*
+ * Register 0 buffers, but reserve space for 10.  Then add one buffer.
+ */
+static int test_zero(struct io_uring *ring)
+{
+	struct iovec *iovs, *ups = NULL;
+	int ret;
+
+	iovs = alloc_bufs(0, 10);
+	if (!iovs)
+		return 1;
+	ret = io_uring_register_buffers(ring, iovs, 10);
+	if (ret) {
+		fprintf(stderr, "%s: register ret=%d\n", __FUNCTION__, ret);
+		goto err;
+	}
+
+	ups = alloc_bufs(1, 0);
+	if (!ups)
+		return 1;
+	ret = io_uring_register_buffers_update(ring, 0, ups, 1);
+	if (ret != 1) {
+		fprintf(stderr, "%s: update ret=%d\n", __FUNCTION__, ret);
+		goto err;
+	}
+
+	ret = io_uring_unregister_buffers(ring);
+	if (ret) {
+		fprintf(stderr, "%s: unregister ret=%d\n", __FUNCTION__, ret);
+		goto err;
+	}
+
+	free_bufs(iovs, 0);
+	free_bufs(ups, 1);
+	return 0;
+err:
+	free_bufs(iovs, 0);
+	free_bufs(ups, 1);
+	return 1;
+}
+
+static int test_fixed_read_write(struct io_uring *ring, int fd,
+				 struct iovec *iovs, int index)
+{
+	struct io_uring_sqe *sqe;
+	struct io_uring_cqe *cqe;
+	struct iovec *iov;
+	int ret;
+
+	sqe = io_uring_get_sqe(ring);
+	if (!sqe) {
+		fprintf(stderr, "%s: failed to get sqe\n", __FUNCTION__);
+		return 1;
+	}
+	iov = &iovs[index];
+	io_uring_prep_write_fixed(sqe, fd, iov->iov_base, iov->iov_len, 0,
+				  index);
+	sqe->user_data = 1;
+
+	ret = io_uring_submit(ring);
+	if (ret != 1) {
+		fprintf(stderr, "%s: got %d, wanted 1\n", __FUNCTION__, ret);
+		return 1;
+	}
+
+	ret = io_uring_wait_cqe(ring, &cqe);
+	if (ret < 0) {
+		fprintf(stderr, "%s: io_uring_wait_cqe=%d\n", __FUNCTION__,
+			ret);
+		return 1;
+	}
+	if (cqe->res != pagesize) {
+		fprintf(stderr, "%s: write cqe->res=%d\n", __FUNCTION__,
+			cqe->res);
+		return 1;
+	}
+	io_uring_cqe_seen(ring, cqe);
+
+	sqe = io_uring_get_sqe(ring);
+	if (!sqe) {
+		fprintf(stderr, "%s: failed to get sqe\n", __FUNCTION__);
+		return 1;
+	}
+	iov = &iovs[index + 1];
+	io_uring_prep_read_fixed(sqe, fd, iov->iov_base, iov->iov_len, 0,
+				  index + 1);
+	sqe->user_data = 2;
+
+	ret = io_uring_submit(ring);
+	if (ret != 1) {
+		fprintf(stderr, "%s: got %d, wanted 1\n", __FUNCTION__, ret);
+		return 1;
+	}
+
+	ret = io_uring_wait_cqe(ring, &cqe);
+	if (ret < 0) {
+		fprintf(stderr, "%s: io_uring_wait_cqe=%d\n", __FUNCTION__,
+			ret);
+		return 1;
+	}
+	if (cqe->res != pagesize) {
+		fprintf(stderr, "%s: read cqe->res=%d\n", __FUNCTION__,
+			cqe->res);
+		return 1;
+	}
+	io_uring_cqe_seen(ring, cqe);
+
+	return 0;
+}
+
+/*
+ * Register 1k of sparse buffers, update one at a random spot, then do some
+ * file IO to verify it works.
+ */
+static int test_huge(struct io_uring *ring)
+{
+	struct iovec *iovs, *ups = NULL;
+	int ret, fd;
+
+	iovs = alloc_bufs(0, UIO_MAXIOV);
+	if (!iovs)
+		return 1;
+	ret = io_uring_register_buffers(ring, iovs, UIO_MAXIOV);
+	if (ret) {
+		fprintf(stderr, "%s: register ret=%d\n", __FUNCTION__, ret);
+		goto err;
+	}
+	fd = open(".reg.768", O_RDWR | O_CREAT, 0644);
+	if (fd < 0) {
+		fprintf(stderr, "%s: open=%d\n", __FUNCTION__, errno);
+		goto err;
+	}
+
+	ups = alloc_bufs(2, 0);
+	if (!ups) {
+		fprintf(stderr, "%s: malloc=%d\n", __FUNCTION__, errno);
+		goto err;
+	}
+	memset(ups[0].iov_base, 0x5a, pagesize);
+
+	ret = io_uring_register_buffers_update(ring, 768, ups, 2);
+	if (ret != 2) {
+		fprintf(stderr, "%s: update ret=%d\n", __FUNCTION__, ret);
+		goto err;
+	}
+
+	iovs[768].iov_base = ups[0].iov_base;
+	iovs[768].iov_len = pagesize;
+	iovs[769].iov_base = ups[1].iov_base;
+	iovs[769].iov_len = pagesize;
+
+	if (test_fixed_read_write(ring, fd, iovs, 768))
+		goto err;
+
+	if (memcmp(ups[0].iov_base, ups[1].iov_base, pagesize)) {
+		fprintf(stderr, "%s: data mismatch\n", __FUNCTION__);
+		goto err;
+	}
+
+	ret = io_uring_unregister_buffers(ring);
+	if (ret) {
+		fprintf(stderr, "%s: unregister ret=%d\n", __FUNCTION__, ret);
+		goto err;
+	}
+
+	if (fd != -1) {
+		close(fd);
+		unlink(".reg.768");
+	}
+	free_bufs(iovs, 0);
+	free_bufs(ups, 2);
+	return 0;
+err:
+	free_bufs(iovs, 0);
+	free_bufs(ups, 2);
+	return 1;
+}
+
+static int test_sparse_updates(void)
+{
+	struct iovec *iovs, *ups = NULL;
+	struct io_uring ring;
+	int ret, i;
+
+	ret = io_uring_queue_init(8, &ring, 0);
+	if (ret) {
+		fprintf(stderr, "queue_init: %d\n", ret);
+		return ret;
+	}
+
+	iovs = alloc_bufs(0, 256);
+
+	ret = io_uring_register_buffers(&ring, iovs, 256);
+	if (ret) {
+		fprintf(stderr, "buffer_register: %d\n", ret);
+		return ret;
+	}
+
+	ups = alloc_bufs(1, 0);
+	for (i = 0; i < 256; i++) {
+		ret = io_uring_register_buffers_update(&ring, i, ups, 1);
+		if (ret != 1) {
+			fprintf(stderr, "buffer_update: %d\n", ret);
+			return ret;
+		}
+	}
+	io_uring_unregister_buffers(&ring);
+
+	for (i = 0; i < 256; i++)
+		iovs[i] = ups[0];
+
+	ret = io_uring_register_buffers(&ring, iovs, 256);
+	if (ret) {
+		fprintf(stderr, "buffer_register: %d\n", ret);
+		return ret;
+	}
+
+	free_bufs(ups, 1);
+	ups = alloc_bufs(0, 1);
+	for (i = 0; i < 256; i++) {
+		ret = io_uring_register_buffers_update(&ring, i, ups, 1);
+		if (ret != 1) {
+			fprintf(stderr, "buffer_update: %d\n", ret);
+			goto done;
+		}
+	}
+	ret = 0;
+done:
+	free_bufs(ups, 0);
+	io_uring_unregister_buffers(&ring);
+
+	io_uring_queue_exit(&ring);
+	return ret;
+}
+
+int main(int argc, char *argv[])
+{
+	struct io_uring ring;
+	int ret;
+
+	if (argc > 1)
+		return 0;
+
+	pagesize = getpagesize();
+
+	ret = io_uring_queue_init(8, &ring, 0);
+	if (ret) {
+		printf("ring setup failed\n");
+		return 1;
+	}
+
+	ret = test_basic(&ring);
+	if (ret) {
+		printf("test_basic failed\n");
+		return ret;
+	}
+
+	ret = test_basic_many(&ring);
+	if (ret) {
+		printf("test_basic_many failed\n");
+		return ret;
+	}
+
+	ret = test_sparse(&ring);
+	if (ret) {
+		printf("test_sparse failed\n");
+		return ret;
+	}
+
+	ret = test_additions(&ring);
+	if (ret) {
+		printf("test_additions failed\n");
+		return ret;
+	}
+
+	ret = test_removals(&ring);
+	if (ret) {
+		printf("test_removals failed\n");
+		return ret;
+	}
+
+	ret = test_replace(&ring);
+	if (ret) {
+		printf("test_replace failed\n");
+		return ret;
+	}
+
+	ret = test_replace_all(&ring);
+	if (ret) {
+		printf("test_replace_all failed\n");
+		return ret;
+	}
+
+	ret = test_grow(&ring);
+	if (ret) {
+		printf("test_grow failed\n");
+		return ret;
+	}
+
+	ret = test_shrink(&ring);
+	if (ret) {
+		printf("test_shrink failed\n");
+		return ret;
+	}
+
+	ret = test_zero(&ring);
+	if (ret) {
+		printf("test_zero failed\n");
+		return ret;
+	}
+
+	ret = test_huge(&ring);
+	if (ret) {
+		printf("test_huge failed\n");
+		return ret;
+	}
+
+	ret = test_sparse_updates();
+	if (ret) {
+		printf("test_sparse_updates failed\n");
+		return ret;
+	}
+
+	return 0;
+}
-- 
1.8.3.1

