Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5B1E590D6E
	for <lists+io-uring@lfdr.de>; Fri, 12 Aug 2022 10:35:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230049AbiHLIfA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 12 Aug 2022 04:35:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231283AbiHLIe7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 12 Aug 2022 04:34:59 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F5E8A721B
        for <io-uring@vger.kernel.org>; Fri, 12 Aug 2022 01:34:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-Id:Date:Cc:To:From;
        bh=NcZnmmzwhcR1lsU32RrYbOAQ2U9wKjl1y4pt/PTN1Cg=; b=o7ZApuStLZwZ6NMbF8QeTj7k8h
        jzZpWjhT61yRO7TR6hheoN/l43pC/vM2nHHDoDfPMMRqPZaGObblx1MqhPjcwtLXB6YYBAQ30/bzG
        ql9xJy5XNK3DBxPEjAzYN5nwAp0Y6oyxeBaO2OvDBH9+iIZXPTp29Oyq63zVY8BdAMaJxrdR09Y82
        rZvt3SZFX6ZF9MEEpqU5oQr5M3GOA8DIxrCvZc0t7+u+T9WizZv9QZiBSsaVpeJab2Sg6eORGSHR/
        sT/QlLDnk8S++D3j1/LDbsXUQ+oBanohOhrEbAfkliDM4Uf3TkwxUJ7mjCM6rXuaEI4q45tCiDkNE
        KNmJ371ExXpE9sWZdtYTgZFw1l6jAEiUuohiUGF3qFyPMQHi91cNPdMDDDyqzeVWG/T4s6n4NvB68
        zwlpq0Tp4qNxJr3uB6EtyefFpZu3bWiQSEkAqSO8GTej/DvKA5Cxw+pUpUPl0kOgfpqYlX+6G9NJG
        DZa8xpIH4P4QJLeXnPpyFMNb;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1oMQ88-009JbG-EJ; Fri, 12 Aug 2022 08:34:56 +0000
From:   Stefan Metzmacher <metze@samba.org>
To:     io-uring@vger.kernel.org, axboe@kernel.dk
Cc:     Stefan Metzmacher <metze@samba.org>
Subject: [RFC PATCH 2/8] io_uring: add a generic structure for struct io_uring_sqe
Date:   Fri, 12 Aug 2022 10:34:26 +0200
Message-Id: <eab2a418cec03cf74a4a80fd17e9aacc35e91750.1660291547.git.metze@samba.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1660291547.git.metze@samba.org>
References: <cover.1660291547.git.metze@samba.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This makes it visible, which fields are used by every opcode.

Until everything is converted individual files can define
IO_URING_SQE_HIDE_LEGACY in order to hide all legacy fields
under a named union arm.

Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 include/uapi/linux/io_uring.h | 30 +++++++++++++++++++++++
 io_uring/io_uring.c           | 46 +++++++++++++++++++++++++++++++++++
 2 files changed, 76 insertions(+)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 83f16bce3dc7..4dcad4929bc7 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -15,6 +15,12 @@
 /*
  * IO submission data structure (Submission Queue Entry)
  */
+#ifdef IO_URING_SQE_HIDE_LEGACY
+#define __io_uring_sqe_legacy legacy
+#else
+#define __io_uring_sqe_legacy
+#endif
+
 struct io_uring_sqe {
 	union {
 		/* This is the legacy structure */
@@ -85,6 +91,30 @@ struct io_uring_sqe {
 				 */
 				__u8	cmd[0];
 			};
+		} __io_uring_sqe_legacy;
+
+		struct { /* This is the structure showing the generic fields */
+			struct io_uring_sqe_hdr {
+				__u8	opcode;		/* type of operation for this sqe */
+				__u8	flags;		/* IOSQE_ flags */
+				__u16	ioprio;		/* ioprio for the request */
+				__s32	fd;		/* file descriptor to do IO on */
+			} __attribute__((packed)) hdr;
+
+			__u64	u64_ofs08;
+			__u64	u64_ofs16;
+			__u32	u32_ofs24;
+			__u32	u32_ofs28;
+
+			struct io_uring_sqe_common {
+				__u64	user_data;	/* data to be passed back at completion time */
+				__u16	buf_info;	/* buf_index or buf_group */
+				__u16	personality;	/* the personality to run this request under */
+			} __attribute__((packed)) common;
+
+			__u32	u32_ofs44;
+			__u64	u64_ofs48;
+			__u64	u64_ofs56;
 		};
 	};
 };
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index ebfdb2212ec2..427dde7dfbd1 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3890,11 +3890,57 @@ static int __init io_uring_init(void)
 	BUILD_BUG_ON(sizeof_field(stype, ename) != esize); \
 } while (0)
 
+#define __BUILD_BUG_VERIFY_ALIAS(stype, eoffset, esize, ename, aname) do { \
+	__BUILD_BUG_VERIFY_OFFSET_SIZE(stype, eoffset, esize, ename); \
+	BUILD_BUG_ON(sizeof_field(stype, ename) != sizeof_field(stype, aname)); \
+	BUILD_BUG_ON(offsetof(stype, ename) != offsetof(stype, aname)); \
+} while (0)
+
+#define BUILD_BUG_SQE_HDR_ELEM(eoffset, etype, ename) \
+	__BUILD_BUG_VERIFY_OFFSET_SIZE(struct io_uring_sqe_hdr, eoffset, sizeof(etype), ename)
+#define BUILD_BUG_SQE_COMMON_ELEM(eoffset, etype, ename) \
+	__BUILD_BUG_VERIFY_OFFSET_SIZE(struct io_uring_sqe_common, eoffset, sizeof(etype), ename)
+
 #define BUILD_BUG_SQE_ELEM(eoffset, etype, ename) \
 	__BUILD_BUG_VERIFY_OFFSET_SIZE(struct io_uring_sqe, eoffset, sizeof(etype), ename)
 #define BUILD_BUG_SQE_ELEM_SIZE(eoffset, esize, ename) \
 	__BUILD_BUG_VERIFY_OFFSET_SIZE(struct io_uring_sqe, eoffset, esize, ename)
+#define BUILD_BUG_SQE_ALIAS(eoffset, etype, ename, aname) \
+	__BUILD_BUG_VERIFY_ALIAS(struct io_uring_sqe, eoffset, sizeof(etype), ename, aname)
+
+#define BUILD_BUG_SQE_LEGACY_ALIAS(eoffset, etype, ename, lname) \
+	__BUILD_BUG_VERIFY_ALIAS(struct io_uring_sqe, eoffset, sizeof(etype), ename, lname)
+
+	BUILD_BUG_ON(sizeof(struct io_uring_sqe_hdr) != 8);
+	BUILD_BUG_SQE_HDR_ELEM(0,  __u8,   opcode);
+	BUILD_BUG_SQE_HDR_ELEM(1,  __u8,   flags);
+	BUILD_BUG_SQE_HDR_ELEM(2,  __u16,  ioprio);
+	BUILD_BUG_SQE_HDR_ELEM(4,  __s32,  fd);
+
+	BUILD_BUG_ON(sizeof(struct io_uring_sqe_common) != 12);
+	BUILD_BUG_SQE_COMMON_ELEM(0,  __u64,  user_data);
+	BUILD_BUG_SQE_COMMON_ELEM(8,  __u16,  buf_info);
+	BUILD_BUG_SQE_COMMON_ELEM(10, __u16,  personality);
+
 	BUILD_BUG_ON(sizeof(struct io_uring_sqe) != 64);
+	/* generic layout */
+	BUILD_BUG_SQE_ELEM(0, struct io_uring_sqe_hdr, hdr);
+	BUILD_BUG_SQE_LEGACY_ALIAS(0,  __u8,   hdr.opcode, opcode);
+	BUILD_BUG_SQE_LEGACY_ALIAS(1,  __u8,   hdr.flags, flags);
+	BUILD_BUG_SQE_LEGACY_ALIAS(2,  __u16,  hdr.ioprio, ioprio);
+	BUILD_BUG_SQE_LEGACY_ALIAS(4,  __s32,  hdr.fd, fd);
+	BUILD_BUG_SQE_ELEM(8,  __u64,  u64_ofs08);
+	BUILD_BUG_SQE_ELEM(16, __u64,  u64_ofs16);
+	BUILD_BUG_SQE_ELEM(24, __u32,  u32_ofs24);
+	BUILD_BUG_SQE_ELEM(28, __u32,  u32_ofs28);
+	BUILD_BUG_SQE_ELEM(32, struct io_uring_sqe_common, common);
+	BUILD_BUG_SQE_LEGACY_ALIAS(32, __u64,  common.user_data, user_data);
+	BUILD_BUG_SQE_LEGACY_ALIAS(40, __u16,  common.buf_info, buf_index);
+	BUILD_BUG_SQE_LEGACY_ALIAS(42, __u16,  common.personality, personality);
+	BUILD_BUG_SQE_ELEM(44, __u32,  u32_ofs44);
+	BUILD_BUG_SQE_ELEM(48, __u64,  u64_ofs48);
+	BUILD_BUG_SQE_ELEM(56, __u64,  u64_ofs56);
+	/* Legacy layout */
 	BUILD_BUG_SQE_ELEM(0,  __u8,   opcode);
 	BUILD_BUG_SQE_ELEM(1,  __u8,   flags);
 	BUILD_BUG_SQE_ELEM(2,  __u16,  ioprio);
-- 
2.34.1

