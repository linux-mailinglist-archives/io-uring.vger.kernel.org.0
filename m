Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 211B958F828
	for <lists+io-uring@lfdr.de>; Thu, 11 Aug 2022 09:12:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233655AbiHKHMn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 11 Aug 2022 03:12:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbiHKHMm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 11 Aug 2022 03:12:42 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ABE08F942
        for <io-uring@vger.kernel.org>; Thu, 11 Aug 2022 00:12:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-Id:Date:Cc:To:From;
        bh=vPaAGGJ+Pb0iLKVfSSsxu/ZO9qxFs6rQq/jjoXkBJfI=; b=Rjm0B38opTYrgpRFUC1wwTnGsE
        5/w7XxVsfv5w5qVxd724FNYUqB1ZvAsACCmusnCWIdPVCejwSJjRS4IgYXRaB/+NZ0AtNhPuSrxdh
        mZJDLMPmTulip04U+nwVzuuq/9zFh4cCMh3wzyWro7mLyNzD49qaqHG6ekX6/5t4RdVWpwM3Of8cO
        x/YwrLczogNHomgFbbKeZm9Wvq8a96Yp1fpCAJLlBrsXs1lwZEWOEJThnW9F4JPXgeKxnyXTQtZyO
        XprG2jh7p0Y85vvka8J4MfMBemHBGazX4SSIsILyEx6m1BVDTle/NlxTWh64RJd3iLPpJgSpr3xrB
        apZMUORYb2RIcTy6f5i7vjZ5Cs71t5DLFK4MK7lu/o1gTTN3zFrnaqOb3f4GkjpKfy7XHw5nWH5FI
        sdeQYN6TLFl3WMgMfaWm1Wr1LqS7cXObZcnS2HlU6koICM9MlqfFh6uQ0T/hHCqDHC0LCikPGrW9I
        SNSk6TGppeFnktgsix4A2k0D;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1oM2Mv-0099v4-HF; Thu, 11 Aug 2022 07:12:38 +0000
From:   Stefan Metzmacher <metze@samba.org>
To:     io-uring@vger.kernel.org, axboe@kernel.dk
Cc:     Stefan Metzmacher <metze@samba.org>
Subject: [PATCH 3/3] io_uring: add missing BUILD_BUG_ON() checks for new io_uring_sqe fields
Date:   Thu, 11 Aug 2022 09:11:16 +0200
Message-Id: <ffcaf8dc4778db4af673822df60dbda6efdd3065.1660201408.git.metze@samba.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1660201408.git.metze@samba.org>
References: <cover.1660201408.git.metze@samba.org>
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

Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 io_uring/io_uring.c  | 19 ++++++++++++++++---
 io_uring/uring_cmd.c |  3 +++
 2 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index b54218da075c..ebfdb2212ec2 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3885,13 +3885,15 @@ SYSCALL_DEFINE4(io_uring_register, unsigned int, fd, unsigned int, opcode,
 
 static int __init io_uring_init(void)
 {
-#define __BUILD_BUG_VERIFY_ELEMENT(stype, eoffset, etype, ename) do { \
+#define __BUILD_BUG_VERIFY_OFFSET_SIZE(stype, eoffset, esize, ename) do { \
 	BUILD_BUG_ON(offsetof(stype, ename) != eoffset); \
-	BUILD_BUG_ON(sizeof(etype) != sizeof_field(stype, ename)); \
+	BUILD_BUG_ON(sizeof_field(stype, ename) != esize); \
 } while (0)
 
 #define BUILD_BUG_SQE_ELEM(eoffset, etype, ename) \
-	__BUILD_BUG_VERIFY_ELEMENT(struct io_uring_sqe, eoffset, etype, ename)
+	__BUILD_BUG_VERIFY_OFFSET_SIZE(struct io_uring_sqe, eoffset, sizeof(etype), ename)
+#define BUILD_BUG_SQE_ELEM_SIZE(eoffset, esize, ename) \
+	__BUILD_BUG_VERIFY_OFFSET_SIZE(struct io_uring_sqe, eoffset, esize, ename)
 	BUILD_BUG_ON(sizeof(struct io_uring_sqe) != 64);
 	BUILD_BUG_SQE_ELEM(0,  __u8,   opcode);
 	BUILD_BUG_SQE_ELEM(1,  __u8,   flags);
@@ -3899,6 +3901,8 @@ static int __init io_uring_init(void)
 	BUILD_BUG_SQE_ELEM(4,  __s32,  fd);
 	BUILD_BUG_SQE_ELEM(8,  __u64,  off);
 	BUILD_BUG_SQE_ELEM(8,  __u64,  addr2);
+	BUILD_BUG_SQE_ELEM(8,  __u32,  cmd_op);
+	BUILD_BUG_SQE_ELEM(12, __u32, __pad1);
 	BUILD_BUG_SQE_ELEM(16, __u64,  addr);
 	BUILD_BUG_SQE_ELEM(16, __u64,  splice_off_in);
 	BUILD_BUG_SQE_ELEM(24, __u32,  len);
@@ -3917,13 +3921,22 @@ static int __init io_uring_init(void)
 	BUILD_BUG_SQE_ELEM(28, __u32,  statx_flags);
 	BUILD_BUG_SQE_ELEM(28, __u32,  fadvise_advice);
 	BUILD_BUG_SQE_ELEM(28, __u32,  splice_flags);
+	BUILD_BUG_SQE_ELEM(28, __u32,  rename_flags);
+	BUILD_BUG_SQE_ELEM(28, __u32,  unlink_flags);
+	BUILD_BUG_SQE_ELEM(28, __u32,  hardlink_flags);
+	BUILD_BUG_SQE_ELEM(28, __u32,  xattr_flags);
+	BUILD_BUG_SQE_ELEM(28, __u32,  msg_ring_flags);
 	BUILD_BUG_SQE_ELEM(32, __u64,  user_data);
 	BUILD_BUG_SQE_ELEM(40, __u16,  buf_index);
 	BUILD_BUG_SQE_ELEM(40, __u16,  buf_group);
 	BUILD_BUG_SQE_ELEM(42, __u16,  personality);
 	BUILD_BUG_SQE_ELEM(44, __s32,  splice_fd_in);
 	BUILD_BUG_SQE_ELEM(44, __u32,  file_index);
+	BUILD_BUG_SQE_ELEM(44, __u16,  notification_idx);
+	BUILD_BUG_SQE_ELEM(46, __u16,  addr_len);
 	BUILD_BUG_SQE_ELEM(48, __u64,  addr3);
+	BUILD_BUG_SQE_ELEM_SIZE(48, 0, cmd);
+	BUILD_BUG_SQE_ELEM(56, __u64,  __pad2);
 
 	BUILD_BUG_ON(sizeof(struct io_uring_files_update) !=
 		     sizeof(struct io_uring_rsrc_update));
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 219e9ebbb44a..03f5f69a4003 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -58,6 +58,9 @@ int io_uring_cmd_prep_async(struct io_kiocb *req)
 	struct io_uring_cmd *ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
 	size_t cmd_size;
 
+	BUILD_BUG_ON(uring_cmd_pdu_size(0) != 16);
+	BUILD_BUG_ON(uring_cmd_pdu_size(1) != 80);
+
 	cmd_size = uring_cmd_pdu_size(req->ctx->flags & IORING_SETUP_SQE128);
 
 	memcpy(req->async_data, ioucmd->cmd, cmd_size);
-- 
2.34.1

