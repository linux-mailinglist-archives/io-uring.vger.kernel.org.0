Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B469583E71
	for <lists+io-uring@lfdr.de>; Thu, 28 Jul 2022 14:16:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237088AbiG1MQ3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 28 Jul 2022 08:16:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235640AbiG1MQ1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 28 Jul 2022 08:16:27 -0400
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F2EC52DFB
        for <io-uring@vger.kernel.org>; Thu, 28 Jul 2022 05:16:26 -0700 (PDT)
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20220728121624epoutp04f352d7015e2eef8f38127c717a13b0ef~F-VYoAYjy2114421144epoutp04T
        for <io-uring@vger.kernel.org>; Thu, 28 Jul 2022 12:16:24 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20220728121624epoutp04f352d7015e2eef8f38127c717a13b0ef~F-VYoAYjy2114421144epoutp04T
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1659010584;
        bh=ixo8XHXbvOE6FhFRDIheWX1l8RdvQY5+Z50btTxzHsU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YxA77ifoMiuxgZxL5J4IKT9JkrZZfG1Zs2j4pNX98qA43UOoGCt05Ji4AqNs9pYlk
         3pECyvCOnNI1BVaM5KkSDnfk1VkUD7p66v/K/KaCMFOPg5REPF+KpVgV/na5kWdVgb
         01aAnPMBfWjzv+yNOD951PcMBl6WG1Z0ovL3eHWY=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20220728121623epcas5p4945b9794fb0cb1cce21255debe7f597e~F-VYDELR10551505515epcas5p4H;
        Thu, 28 Jul 2022 12:16:23 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.175]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4LtqPb5f1bz4x9Pr; Thu, 28 Jul
        2022 12:16:19 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        6E.EC.09662.31E72E26; Thu, 28 Jul 2022 21:16:19 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20220728093906epcas5p3fb607ddd16054ca7e6cbf26b53306062~F9MDC_j_E2634226342epcas5p3E;
        Thu, 28 Jul 2022 09:39:06 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220728093906epsmtrp2e7292a413294c57aa95f7db24c544326~F9MDCQhJG3160631606epsmtrp2H;
        Thu, 28 Jul 2022 09:39:06 +0000 (GMT)
X-AuditID: b6c32a49-885ff700000025be-e6-62e27e13ec25
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        27.7B.08802.A3952E26; Thu, 28 Jul 2022 18:39:06 +0900 (KST)
Received: from test-zns.sa.corp.samsungelectronics.net (unknown
        [107.110.206.5]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20220728093905epsmtip1e7defd0632d7fc0501cdc90b6f2dd8cf~F9MCOiMZE1284412844epsmtip1H;
        Thu, 28 Jul 2022 09:39:05 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk
Cc:     io-uring@vger.kernel.org, joshi.k@samsung.com,
        Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH liburing v3 3/5] nvme: add nvme opcodes, structures and
 helper functions
Date:   Thu, 28 Jul 2022 15:03:25 +0530
Message-Id: <20220728093327.32580-4-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220728093327.32580-1-ankit.kumar@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCKsWRmVeSWpSXmKPExsWy7bCmuq5w3aMkg7vrNSzWXPnNbrH6bj+b
        xbvWcywWR/+/ZXNg8bh8ttSjb8sqRo/Pm+QCmKOybTJSE1NSixRS85LzUzLz0m2VvIPjneNN
        zQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOAlikplCXmlAKFAhKLi5X07WyK8ktLUhUy8otLbJVS
        C1JyCkwK9IoTc4tL89L18lJLrAwNDIxMgQoTsjM2v+1lLLgpW3F8Y3AD4ymxLkZODgkBE4n3
        Ry4ygthCArsZJRatzOxi5AKyPzFKfN9wjBnC+cwo8WHiYRaYjq79O1ggErsYJSY07WSCcFqZ
        JF5OmQ5WxSagLfHq7Q1mEFtEQFhif0crWJxZIEpizauzYPuEgez3V1aD1bAIqEpc/rUVrIZX
        wEbiwsY5UNvkJVZvOABWwylgK/Hp0QlGkGUSAsvYJTr/7GWFKHKRWHd1O1SDsMSr41vYIWwp
        ic/v9rJB2NkSmx7+ZIKwCySOvOhlhrDtJVpP9QPZHEDHaUqs36UPEZaVmHpqHRPEzXwSvb+f
        QLXySuyYB2OrSvy9dxtqrbTEzXdXWUDGSAh4SPxt1oaEyQRGiWV9R1kmMMrNQtiwgJFxFaNk
        akFxbnpqsWmBYV5qOTzOkvNzNzGCk5OW5w7Guw8+6B1iZOJgPMQowcGsJMKbEH0/SYg3JbGy
        KrUoP76oNCe1+BCjKTD8JjJLiSbnA9NjXkm8oYmlgYmZmZmJpbGZoZI4r9fVTUlCAumJJanZ
        qakFqUUwfUwcnFINTMtXT7p2SPN+0Y7lO1Nq7gakGl198Mvtq3jCG85JXNFSl1a3rBW8dL90
        XWH+vuv5Lf4rN09keFc467C+VyPfyXmh5Zd0VebPytj3rWtGz7YtPK8OTH5RL3H9VqmO5VeR
        5esNVS+6qJfe2rVyH2/onSKlBOddhUVCbqdU1ryzckgMYfPzeKPUENz3ZH7+aS6tLfNu3Kiz
        k9992qSM+81jURadP0f6N1UxvpijtG6a5X4vvvVVqr0eT90jrc/X/Lt+KtzARluOgffylrNL
        zj3f+VrXvJZfPmhC6RrzUvuARUonFBZ+P5TubaPzd1p6zGJRWUFzt9W3/979YhFusdyvv7Wt
        c8qdTw2rZhtfPPQtboYSS3FGoqEWc1FxIgCUY9SP1wMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFJMWRmVeSWpSXmKPExsWy7bCSnK5V5KMkg6WTRC3WXPnNbrH6bj+b
        xbvWcywWR/+/ZXNg8bh8ttSjb8sqRo/Pm+QCmKO4bFJSczLLUov07RK4Mja/7WUsuClbcXxj
        cAPjKbEuRk4OCQETia79O1i6GLk4hAR2MErM+7SXvYuRAyghLbFwfSJEjbDEyn/P2SFqmpkk
        HqydxAaSYBPQlnj19gYziC0CVLS/o5UFxGYWiJGYeuQwC8gcYYEIiZZtziBhFgFVicu/toKV
        8ArYSFzYOIcFYr68xOoNB8DGcArYSnx6dIIRxBYCqnk9aTvTBEa+BYwMqxglUwuKc9Nziw0L
        jPJSy/WKE3OLS/PS9ZLzczcxgoNHS2sH455VH/QOMTJxMB5ilOBgVhLhTYi+nyTEm5JYWZVa
        lB9fVJqTWnyIUZqDRUmc90LXyXghgfTEktTs1NSC1CKYLBMHp1QD09Qf+++eXJ//V831xi3f
        yWZ/9qWZyV3fHZ0Ufi/n513zas6a9TwyZ27tquONvfB6+/95ry4sEpU3PvRQ8l+Ran3c56iU
        Gf4iVn9fbVl0o2pP063uNX48qcmvF57IzWh7/WHhgr1Lp70vna76se5PYs+ztv3zdz1ZwyF8
        oXtZpPhevY9znwcKfjj517TK2C9ryhv3SIEqsbP7wzfNWLpk8rv5zJnXGwylHkad81zta39z
        ncxib1emiSfOarN89Lu13+KCj+lLr8V9AguNZq1wuLqgSpJNacLRQ36FbyeyKek899mfrTDd
        sezs/wPbo5h+KrXJzOTc8JpR81Ya43G9x4J2mVpNa03Pn9s0IZdT7uMHJZbijERDLeai4kQA
        mYJUO40CAAA=
X-CMS-MailID: 20220728093906epcas5p3fb607ddd16054ca7e6cbf26b53306062
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220728093906epcas5p3fb607ddd16054ca7e6cbf26b53306062
References: <20220728093327.32580-1-ankit.kumar@samsung.com>
        <CGME20220728093906epcas5p3fb607ddd16054ca7e6cbf26b53306062@epcas5p3.samsung.com>
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add bare minimum structures and helper functions required for
io_uring passthrough commands. This will enable the follow up
patch to add tests for nvme-ns generic character device.

Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
---
 test/nvme.h | 168 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 168 insertions(+)
 create mode 100644 test/nvme.h

diff --git a/test/nvme.h b/test/nvme.h
new file mode 100644
index 0000000..14dc338
--- /dev/null
+++ b/test/nvme.h
@@ -0,0 +1,168 @@
+/* SPDX-License-Identifier: MIT */
+/*
+ * Description: Helpers for NVMe uring passthrough commands
+ */
+#ifndef LIBURING_NVME_H
+#define LIBURING_NVME_H
+
+#ifdef __cplusplus
+extern "C" {
+#endif
+
+#include <sys/ioctl.h>
+#include <linux/nvme_ioctl.h>
+
+/*
+ * If the uapi headers installed on the system lacks nvme uring command
+ * support, use the local version to prevent compilation issues.
+ */
+#ifndef CONFIG_HAVE_NVME_URING
+struct nvme_uring_cmd {
+	__u8	opcode;
+	__u8	flags;
+	__u16	rsvd1;
+	__u32	nsid;
+	__u32	cdw2;
+	__u32	cdw3;
+	__u64	metadata;
+	__u64	addr;
+	__u32	metadata_len;
+	__u32	data_len;
+	__u32	cdw10;
+	__u32	cdw11;
+	__u32	cdw12;
+	__u32	cdw13;
+	__u32	cdw14;
+	__u32	cdw15;
+	__u32	timeout_ms;
+	__u32   rsvd2;
+};
+
+#define NVME_URING_CMD_IO	_IOWR('N', 0x80, struct nvme_uring_cmd)
+#define NVME_URING_CMD_IO_VEC	_IOWR('N', 0x81, struct nvme_uring_cmd)
+#endif /* CONFIG_HAVE_NVME_URING */
+
+#define NVME_DEFAULT_IOCTL_TIMEOUT 0
+#define NVME_IDENTIFY_DATA_SIZE 4096
+#define NVME_IDENTIFY_CSI_SHIFT 24
+#define NVME_IDENTIFY_CNS_NS 0
+#define NVME_CSI_NVM 0
+
+enum nvme_admin_opcode {
+	nvme_admin_identify		= 0x06,
+};
+
+enum nvme_io_opcode {
+	nvme_cmd_write			= 0x01,
+	nvme_cmd_read			= 0x02,
+};
+
+int nsid;
+__u32 lba_shift;
+
+struct nvme_lbaf {
+	__le16			ms;
+	__u8			ds;
+	__u8			rp;
+};
+
+struct nvme_id_ns {
+	__le64			nsze;
+	__le64			ncap;
+	__le64			nuse;
+	__u8			nsfeat;
+	__u8			nlbaf;
+	__u8			flbas;
+	__u8			mc;
+	__u8			dpc;
+	__u8			dps;
+	__u8			nmic;
+	__u8			rescap;
+	__u8			fpi;
+	__u8			dlfeat;
+	__le16			nawun;
+	__le16			nawupf;
+	__le16			nacwu;
+	__le16			nabsn;
+	__le16			nabo;
+	__le16			nabspf;
+	__le16			noiob;
+	__u8			nvmcap[16];
+	__le16			npwg;
+	__le16			npwa;
+	__le16			npdg;
+	__le16			npda;
+	__le16			nows;
+	__le16			mssrl;
+	__le32			mcl;
+	__u8			msrc;
+	__u8			rsvd81[11];
+	__le32			anagrpid;
+	__u8			rsvd96[3];
+	__u8			nsattr;
+	__le16			nvmsetid;
+	__le16			endgid;
+	__u8			nguid[16];
+	__u8			eui64[8];
+	struct nvme_lbaf	lbaf[16];
+	__u8			rsvd192[192];
+	__u8			vs[3712];
+};
+
+static inline int ilog2(uint32_t i)
+{
+	int log = -1;
+
+	while (i) {
+		i >>= 1;
+		log++;
+	}
+	return log;
+}
+
+int nvme_get_info(const char *file)
+{
+	struct nvme_id_ns ns;
+	int fd, err;
+	__u32 lba_size;
+
+	fd = open(file, O_RDONLY);
+	if (fd < 0) {
+		perror("file open");
+		return -errno;
+	}
+
+	nsid = ioctl(fd, NVME_IOCTL_ID);
+	if (nsid < 0) {
+		close(fd);
+		return -errno;
+	}
+
+	struct nvme_passthru_cmd cmd = {
+		.opcode         = nvme_admin_identify,
+		.nsid           = nsid,
+		.addr           = (__u64)(uintptr_t)&ns,
+		.data_len       = NVME_IDENTIFY_DATA_SIZE,
+		.cdw10          = NVME_IDENTIFY_CNS_NS,
+		.cdw11          = NVME_CSI_NVM << NVME_IDENTIFY_CSI_SHIFT,
+		.timeout_ms     = NVME_DEFAULT_IOCTL_TIMEOUT,
+	};
+
+	err = ioctl(fd, NVME_IOCTL_ADMIN_CMD, &cmd);
+	if (err) {
+		close(fd);
+		return err;
+	}
+
+	lba_size = 1 << ns.lbaf[(ns.flbas & 0x0f)].ds;
+	lba_shift = ilog2(lba_size);
+
+	close(fd);
+	return 0;
+}
+
+#ifdef __cplusplus
+}
+#endif
+
+#endif
-- 
2.17.1

