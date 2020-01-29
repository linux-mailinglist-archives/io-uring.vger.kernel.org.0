Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD2B514CB58
	for <lists+io-uring@lfdr.de>; Wed, 29 Jan 2020 14:23:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726145AbgA2NXY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 29 Jan 2020 08:23:24 -0500
Received: from hr2.samba.org ([144.76.82.148]:53944 "EHLO hr2.samba.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726140AbgA2NXX (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Wed, 29 Jan 2020 08:23:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-Id:Date:Cc:To:From;
        bh=C+G/l5Zn2TiOPCkYAN67WNACgy8+uxz9w1WPqbqYh4U=; b=BnPw4mpJi99ln//QiInA5j3+aX
        WBJ2+u6dURjMO/fWoplVVlPP5n9LLpiyR/eCycG1P38RDZFpykNM97FqagmY7zpCrErosZ7ouirfE
        ObmO/HP0Kf7RaOw4zdRwCpCKpAl84HlAFDwCmdZ6ZAwCoVlTBnuXn385w50M29nOJ4jK651qGTGx0
        ai8Fyox7r9js/j8KY8miUKlgysanBX1qPexod06xMW8zStaqANfObMDcLPyAPzE71udiJc9Zwe7Jn
        XXC0UEqza97jyndq2Lo6HzSmOU54+eF5eZ/k6EgM3At8XpdZFkHKaZOstidbKLo/zqheOCpnS9bcP
        0ZuCaH81nPmq6vc9e8jD+sDuaUpWbVtv7SwiWkkEHFAZqXOSo2iiPQh/Zq/3zYpmFEq19Rss7yCP8
        vZ3lLoNJ/tRKeOlHUDhOsOKHZNRH/gpmDtMg2XfDp3rHLu2Bo7GlmY/dDNIkRxGd+lR3lfzbARMul
        6dtJz/pvliRzisO+D3+J/Pca;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1iwnJR-0005f7-QA; Wed, 29 Jan 2020 13:23:21 +0000
From:   Stefan Metzmacher <metze@samba.org>
To:     io-uring@vger.kernel.org
Cc:     Stefan Metzmacher <metze@samba.org>
Subject: [PATCH] io_uring: add BUILD_BUG_ON() to assert the layout of struct io_uring_sqe
Date:   Wed, 29 Jan 2020 14:22:53 +0100
Message-Id: <20200129132253.7638-1-metze@samba.org>
X-Mailer: git-send-email 2.17.1
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

With nesting of anonymous unions and structs it's hard to
review layout changes. It's better to ask the compiler
for these things.

Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/io_uring.c | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 9479b5481ad2..791bbc28c0b7 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6882,6 +6882,39 @@ SYSCALL_DEFINE4(io_uring_register, unsigned int, fd, unsigned int, opcode,
 
 static int __init io_uring_init(void)
 {
+#define __BUILD_BUG_VERIFY_ELEMENT(stype, eoffset, etype, ename) do { \
+	BUILD_BUG_ON(offsetof(stype, ename) != eoffset); \
+	BUILD_BUG_ON(sizeof(etype) != sizeof_field(stype, ename)); \
+} while (0)
+
+#define BUILD_BUG_SQE_ELEM(eoffset, etype, ename) \
+	__BUILD_BUG_VERIFY_ELEMENT(struct io_uring_sqe, eoffset, etype, ename)
+	BUILD_BUG_ON(sizeof(struct io_uring_sqe) != 64);
+	BUILD_BUG_SQE_ELEM(0,  __u8,   opcode);
+	BUILD_BUG_SQE_ELEM(1,  __u8,   flags);
+	BUILD_BUG_SQE_ELEM(2,  __u16,  ioprio);
+	BUILD_BUG_SQE_ELEM(4,  __s32,  fd);
+	BUILD_BUG_SQE_ELEM(8,  __u64,  off);
+	BUILD_BUG_SQE_ELEM(8,  __u64,  addr2);
+	BUILD_BUG_SQE_ELEM(16, __u64,  addr);
+	BUILD_BUG_SQE_ELEM(24, __u32,  len);
+	BUILD_BUG_SQE_ELEM(28,    __kernel_rwf_t,  rw_flags);
+	BUILD_BUG_SQE_ELEM(28, /* compat */   int, rw_flags);
+	BUILD_BUG_SQE_ELEM(28, /* compat */ __u32, rw_flags);
+	BUILD_BUG_SQE_ELEM(28, __u32,  fsync_flags);
+	BUILD_BUG_SQE_ELEM(28, __u16,  poll_events);
+	BUILD_BUG_SQE_ELEM(28, __u32,  sync_range_flags);
+	BUILD_BUG_SQE_ELEM(28, __u32,  msg_flags);
+	BUILD_BUG_SQE_ELEM(28, __u32,  timeout_flags);
+	BUILD_BUG_SQE_ELEM(28, __u32,  accept_flags);
+	BUILD_BUG_SQE_ELEM(28, __u32,  cancel_flags);
+	BUILD_BUG_SQE_ELEM(28, __u32,  open_flags);
+	BUILD_BUG_SQE_ELEM(28, __u32,  statx_flags);
+	BUILD_BUG_SQE_ELEM(28, __u32,  fadvise_advice);
+	BUILD_BUG_SQE_ELEM(32, __u64,  user_data);
+	BUILD_BUG_SQE_ELEM(40, __u16,  buf_index);
+	BUILD_BUG_SQE_ELEM(42, __u16,  personality);
+
 	BUILD_BUG_ON(ARRAY_SIZE(io_op_defs) != IORING_OP_LAST);
 	req_cachep = KMEM_CACHE(io_kiocb, SLAB_HWCACHE_ALIGN | SLAB_PANIC);
 	return 0;
-- 
2.17.1

