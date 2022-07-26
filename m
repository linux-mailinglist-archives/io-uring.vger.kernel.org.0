Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89465581258
	for <lists+io-uring@lfdr.de>; Tue, 26 Jul 2022 13:51:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232759AbiGZLvL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 Jul 2022 07:51:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238919AbiGZLvK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 Jul 2022 07:51:10 -0400
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42AE432ED9
        for <io-uring@vger.kernel.org>; Tue, 26 Jul 2022 04:51:09 -0700 (PDT)
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20220726115106epoutp0448a61d55bb96f7445c68f75a82606d1f~FXsurH1Dx0128801288epoutp047
        for <io-uring@vger.kernel.org>; Tue, 26 Jul 2022 11:51:06 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20220726115106epoutp0448a61d55bb96f7445c68f75a82606d1f~FXsurH1Dx0128801288epoutp047
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1658836266;
        bh=8ZRJ2yAa5YlNjP+lRsTxBfnnFz5zvSEZd11Xx72zjSU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mPpNidHOaAR/KUb6hETdBwDHLfU2xN5LYbT0jy+fT079pl3H+aXGzNz0EkQmhlQlB
         ZOXF7krU7gETdpIAyDqGdz/vkl7IXtXxfkBN32nNUxL58cqRqgREHEPNLiCONUfi1i
         Q9kp8F7WgfZ77IJrbFjrABihAhjbA0Jfy1o/LQxE=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20220726115105epcas5p1af17983335de3e7e3cc779ca7dd6b58e~FXsuDksnq2881828818epcas5p1h;
        Tue, 26 Jul 2022 11:51:05 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.175]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4LsZxM2w4fz4x9Pt; Tue, 26 Jul
        2022 11:51:03 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        92.58.09566.525DFD26; Tue, 26 Jul 2022 20:51:01 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20220726105815epcas5p2e19ff2fe748cfeb69517124370de3b7f~FW_lu3TMZ3232132321epcas5p20;
        Tue, 26 Jul 2022 10:58:15 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220726105815epsmtrp11363e7f0314d62473ab7076b6c87a3e5~FW_luTVcI0116501165epsmtrp1Z;
        Tue, 26 Jul 2022 10:58:15 +0000 (GMT)
X-AuditID: b6c32a4a-ba3ff7000000255e-3a-62dfd52518b5
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        90.E9.08905.7C8CFD26; Tue, 26 Jul 2022 19:58:15 +0900 (KST)
Received: from test-zns.sa.corp.samsungelectronics.net (unknown
        [107.110.206.5]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20220726105815epsmtip1cfe10782a0c3effe98f87a22e2d7d254~FW_lAQ16b1956519565epsmtip1G;
        Tue, 26 Jul 2022 10:58:14 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk
Cc:     io-uring@vger.kernel.org, joshi.k@samsung.com,
        Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH liburing v2 3/5] nvme: add nvme opcodes, structures and
 helper functions
Date:   Tue, 26 Jul 2022 16:22:28 +0530
Message-Id: <20220726105230.12025-4-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220726105230.12025-1-ankit.kumar@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGKsWRmVeSWpSXmKPExsWy7bCmuq7q1ftJBocbpS3WXPnNbrH6bj+b
        xbvWcywWR/+/ZXNg8bh8ttSjb8sqRo/Pm+QCmKOybTJSE1NSixRS85LzUzLz0m2VvIPjneNN
        zQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOAlikplCXmlAKFAhKLi5X07WyK8ktLUhUy8otLbJVS
        C1JyCkwK9IoTc4tL89L18lJLrAwNDIxMgQoTsjPWvHzJWLBRrmLWtkOsDYyzxLsYOTkkBEwk
        midNY+ti5OIQEtjNKLHq3hd2COcTo8SlxuesEM43RomnB/4wwrQ83n8Vqmovo8SungawhJBA
        K5PE/TlgNpuAtsSrtzeYQWwRAWGJ/R2tLCA2s0CUxJpXZ8FqhIHs5w9usILYLAKqEn9vnGcH
        sXkFbCSuvNzIBrFMXmL1hgNgczgFbCWaXk4Bu0hCYBG7xLf9n6GKXCTmXHsLdZ2wxKvjW9gh
        bCmJl/1tUHa2xKaHP5kg7AKJIy96mSFse4nWU/1ANgfQcZoS63fpQ4RlJaaeWscEcTOfRO/v
        J1CtvBI75sHYQDffu80CYUtL3Hx3Fcr2kNg/4SUjJIAmMEq0vJvAPIFRbhbCigWMjKsYJVML
        inPTU4tNC4zyUsvhsZacn7uJEZygtLx2MD588EHvECMTB+MhRgkOZiUR3oTo+0lCvCmJlVWp
        RfnxRaU5qcWHGE2BATiRWUo0OR+YIvNK4g1NLA1MzMzMTCyNzQyVxHm9rm5KEhJITyxJzU5N
        LUgtgulj4uCUamDawH609HL/H7vfwsybhTmfrGIuOSr+tZPljvyP3OXHJtrs8d3LvKVhxmXn
        X9E3O+5msZ70855htnHeDM2yVSqHg20zNtWsumu8Vdo7yG3Ws/ATshPtn3UU2m6utW3eLrMq
        9tHprgDRHQXLj2bN+sGww1H9qOiW7G7Gyswnl/6JLVFdrdNVW3j3g+bMILPz8rn3dlu95X/Y
        rX32w5xDB5J1zL/ZZP9e2dmRf0viYp60avGsj27t+w0vs4YEWd9NnZMl8/jSF09VM04O0Xd7
        akvU+HbG6s/hmts2df+izS2Pv4kc59FgcD/26V75pu8PehXl5k+zM+taF33kAJuFWMPxZ0cr
        ir0ku6Z/uvUx7/5RJZbijERDLeai4kQAuUnJzdkDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDJMWRmVeSWpSXmKPExsWy7bCSnO7xE/eTDD6+NbZYc+U3u8Xqu/1s
        Fu9az7FYHP3/ls2BxePy2VKPvi2rGD0+b5ILYI7isklJzcksSy3St0vgyljz8iVjwUa5ilnb
        DrE2MM4S72Lk5JAQMJF4vP8qexcjF4eQwG5GiY0nJgA5HEAJaYmF6xMhaoQlVv57DlXTzCTx
        8fojZpAEm4C2xKu3N8BsEaCi/R2tLCA2s0CMxNQjh8FsYYEIiRnr3jKC2CwCqhJ/b5xnB7F5
        BWwkrrzcyAaxQF5i9YYDYHM4BWwlml5OYQWxhYBq/h46xjaBkW8BI8MqRsnUguLc9NxiwwLD
        vNRyveLE3OLSvHS95PzcTYzgANLS3MG4fdUHvUOMTByMhxglOJiVRHgTou8nCfGmJFZWpRbl
        xxeV5qQWH2KU5mBREue90HUyXkggPbEkNTs1tSC1CCbLxMEp1cDEniH5MapMtlVXa9v+nH9M
        5hHbN+/If+qT1JT56b+YybuUR9wHClmYbGc86N1Z6b9lYfjOJWXnS70Orssv/TlBR7jPIOt9
        UvSyNZ9FBa5n8Uos6Ci+zF71Jnleee9yPoHCUP7kS2ayUfO/3+k9ITtzY/TjjMLD03c/uzF3
        le76imiDPyHVb5LXrxYxr/Yy+FIddP/aZY5m+fP2+6XDzn+ylXn89MGj017dHz8wsfJU5Yqc
        Tz4V1Pmv9Jfxc9a2cz6bfh51CfePvfuw9UmSePOvKd2pE7fU3V0wK2C+8qmnKt0yN8K28e/L
        bA09ZuXr5vPo1veTAvxzmQXWTingdi6ez9o3o3DNK62ym948Sw2UWIozEg21mIuKEwEyvMj3
        jwIAAA==
X-CMS-MailID: 20220726105815epcas5p2e19ff2fe748cfeb69517124370de3b7f
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220726105815epcas5p2e19ff2fe748cfeb69517124370de3b7f
References: <20220726105230.12025-1-ankit.kumar@samsung.com>
        <CGME20220726105815epcas5p2e19ff2fe748cfeb69517124370de3b7f@epcas5p2.samsung.com>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

