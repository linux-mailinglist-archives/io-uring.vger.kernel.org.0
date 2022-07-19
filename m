Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D00C857AFB5
	for <lists+io-uring@lfdr.de>; Wed, 20 Jul 2022 06:10:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233851AbiGTEKR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 20 Jul 2022 00:10:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233788AbiGTEKQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 20 Jul 2022 00:10:16 -0400
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D59E22B2C
        for <io-uring@vger.kernel.org>; Tue, 19 Jul 2022 21:10:15 -0700 (PDT)
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20220720041013epoutp021eca17252649498e4b354f4963cb5572~Dbinfzn6h2117321173epoutp02C
        for <io-uring@vger.kernel.org>; Wed, 20 Jul 2022 04:10:13 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20220720041013epoutp021eca17252649498e4b354f4963cb5572~Dbinfzn6h2117321173epoutp02C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1658290213;
        bh=8ZRJ2yAa5YlNjP+lRsTxBfnnFz5zvSEZd11Xx72zjSU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TsLt0QpIga5PJrE+PWHWphV8CiJESw3I9ekgG/FhDWudSE0dcYAtUUymapRbfOH0Q
         WxqjzeKF704hmCvdYnstTe3ZPZn5pLNj9dDHaYKpjy8GEAL8/qxVfRtBQeQ+CPDJFQ
         EvRJy8n8WW2yClzu1DFm+/RL6w/W/LBYBzo4/qmg=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20220720041013epcas5p32e1470ce0d9ac763a2a086453bdaff96~DbinQcgnz1311613116epcas5p3e;
        Wed, 20 Jul 2022 04:10:13 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.180]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4Lnj0M0pkBz4x9QJ; Wed, 20 Jul
        2022 04:10:11 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        CF.8A.09639.91087D26; Wed, 20 Jul 2022 13:10:01 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20220719135835epcas5p2284cbb16a28c4290d3a886449bc7a6d8~DP7CStggm0590105901epcas5p2j;
        Tue, 19 Jul 2022 13:58:35 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220719135835epsmtrp1fdda31de767ec4574d2ebdd5452314fb~DP7CSFjoK1050910509epsmtrp1T;
        Tue, 19 Jul 2022 13:58:35 +0000 (GMT)
X-AuditID: b6c32a4b-e6dff700000025a7-ee-62d78019604c
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        74.3D.08802.B88B6D26; Tue, 19 Jul 2022 22:58:35 +0900 (KST)
Received: from test-zns.sa.corp.samsungelectronics.net (unknown
        [107.110.206.5]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20220719135834epsmtip189d509220611ec63c89aeedcf6161063~DP7BFlWKk2149321493epsmtip1c;
        Tue, 19 Jul 2022 13:58:33 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk
Cc:     io-uring@vger.kernel.org, paul@paul-moore.com,
        casey@schaufler-ca.com, joshi.k@samsung.com,
        Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH liburing 3/5] nvme: add nvme opcodes, structures and helper
 functions
Date:   Tue, 19 Jul 2022 19:22:32 +0530
Message-Id: <20220719135234.14039-4-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220719135234.14039-1-ankit.kumar@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFKsWRmVeSWpSXmKPExsWy7bCmhq5kw/Ukg5OT2CzWXPnNbrH6bj+b
        xb1tv9gs3rWeY7E4+v8tm8XtSdNZHNg8Lp8t9Vi79wWjR9+WVYweR/cvYvP4vEkugDUq2yYj
        NTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMH6AAlhbLEnFKg
        UEBicbGSvp1NUX5pSapCRn5xia1SakFKToFJgV5xYm5xaV66Xl5qiZWhgYGRKVBhQnbGmpcv
        GQs2ylXM2naItYFxlngXIweHhICJRNOy8i5GLg4hgd2MEtPuHmGGcD4xSjy/PIUFwvnMKPGx
        eQ+QwwnWcXPidKjELkaJ9Uc3sUI4rUwSXd3TmUCq2AS0JV69vcEMYosICEvs72gF62AWaGeU
        +LDgCDvIcmGBcImzv/JBalgEVCXOrH3JDmLzCthItEw8A7VNXmL1hgNgczgFbCU+bH8Jdp+E
        wCF2idtLm5ghilwkzq/cAGULS7w6voUdwpaSeNnfBmVnS2x6+JMJwi6QOPKiF6reXqL1VD8z
        yD3MApoS63fpQ4RlJaaeWgdWzizAJ9H7+wlUK6/EjnkwtqrE33u3oe6Ulrj57iqU7SEx7dR2
        aDhOYJR4++gF8wRGuVkIKxYwMq5ilEwtKM5NTy02LTDOSy2Hx1pyfu4mRnAi0/LewfjowQe9
        Q4xMHIyHGCU4mJVEeJ8WXk8S4k1JrKxKLcqPLyrNSS0+xGgKDMCJzFKiyfnAVJpXEm9oYmlg
        YmZmZmJpbGaoJM7rdXVTkpBAemJJanZqakFqEUwfEwenVAPTkf9/25n+mK5aY8h1zqDLSKa7
        v8tw4ec/3ic/tqyyeJTdsUW4TlTPpZPXcn6tilPihrvfMp/Yr/3+b7qKx0sZ907DNvGDNbyt
        H9nPz3W8HaTT0m2nqNzZXGiax6+oczlCQKRCI77jx0kPgV91bNOdzDJs+ibULbJ14P5WEmBy
        Wln3ePbv6mUL8xV2b9x3KqbZSd/8+o9Cljq5kgTV0kztrRtvn678bOfL1LJeeP6EoM2svdcv
        B04OVYzbxNxx6739LrE1/fWSj4KfZb+qbX2Ywy7H17zv19WNajn9Gb13NB02dC9w3VS+6i3T
        3b+rPp1POtn0t+jwnucGT2/VP9D4YXRoQtzXh+8WM0vNPazEUpyRaKjFXFScCADmxotv7QMA
        AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprILMWRmVeSWpSXmKPExsWy7bCSnG73jmtJBlM3CVisufKb3WL13X42
        i3vbfrFZvGs9x2Jx9P9bNovbk6azOLB5XD5b6rF27wtGj74tqxg9ju5fxObxeZNcAGsUl01K
        ak5mWWqRvl0CV8aaly8ZCzbKVczadoi1gXGWeBcjJ4eEgInEzYnTWboYuTiEBHYwStzfvp2x
        i5EDKCEtsXB9IkSNsMTKf8/ZIWqamSQm3tjODJJgE9CWePX2BpgtAlS0v6MVbBCzQC+jxMr/
        R5hAEsICoRJH9qwHs1kEVCXOrH3JDmLzCthItEw8wwKxQV5i9YYDYIM4BWwlPmx/CWYLAdV8
        uzOTfQIj3wJGhlWMkqkFxbnpucWGBUZ5qeV6xYm5xaV56XrJ+bmbGMGhpqW1g3HPqg96hxiZ
        OBgPMUpwMCuJ8IrUXk4S4k1JrKxKLcqPLyrNSS0+xCjNwaIkznuh62S8kEB6YklqdmpqQWoR
        TJaJg1OqgSlX3UaCo/VwSuvrpslTEtrZ2Bnm35974elmcfkX3BMTzp84U+XqPevIh5Cj995/
        MN+7sCh56quZd/v17z25eUAhRsD0lmJ0UkZidojbI/3Ex0/dvQwFeU6zHArK3CfAfNagUHn6
        ya1CEzSK1IMb1p3ctOBAcGnnDCWB7uXCLDVWuT1i/EwW20ON8lUlD4jLxS1ZxGVduHTq1WtS
        Ew8IcRw/+ObWyaMGcaGKaqea9weKvSvVczafGl8l5s8nyavd92zfs739gh/YHn06mbmJ4/rl
        W7uNNi6f9m8BF8P/U7u3nb4tFF2/L9z4n8SyMy7yQhET+K44Toial8PeIiG7/HABW1xC1+cK
        Fe8Zjce8ViqxFGckGmoxFxUnAgDUFt59pAIAAA==
X-CMS-MailID: 20220719135835epcas5p2284cbb16a28c4290d3a886449bc7a6d8
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220719135835epcas5p2284cbb16a28c4290d3a886449bc7a6d8
References: <20220719135234.14039-1-ankit.kumar@samsung.com>
        <CGME20220719135835epcas5p2284cbb16a28c4290d3a886449bc7a6d8@epcas5p2.samsung.com>
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
index 0000000..866a7e6
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
+int fio_nvme_get_info(const char *file)
+{
+	struct nvme_id_ns ns;
+	int fd, err;
+	__u32 lba_size;
+
+	fd = open(file, O_RDONLY);
+	if (fd < 0)
+		return -errno;
+
+	nsid = ioctl(fd, NVME_IOCTL_ID);
+	if (nsid < 0) {
+		fprintf(stderr, "failed to fetch namespace-id\n");
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
+		fprintf(stderr, "failed to fetch identify namespace\n");
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

