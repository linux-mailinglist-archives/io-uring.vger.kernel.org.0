Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCCAB590D72
	for <lists+io-uring@lfdr.de>; Fri, 12 Aug 2022 10:35:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236015AbiHLIf1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 12 Aug 2022 04:35:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236197AbiHLIf0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 12 Aug 2022 04:35:26 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86CEE12D39
        for <io-uring@vger.kernel.org>; Fri, 12 Aug 2022 01:35:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-Id:Date:Cc:To:From;
        bh=ff7Nc2RhtxW7fQcgYHeopNtDiVRD4BMoeDN12LLnR/Y=; b=uc0RKq3m7TSQE1kXo5cQRjDfgQ
        KTSTpBJdPKdG+O5snCnxwqQt6/Zj6155xTYi7l+KL1cdOugDn70d1EiHBBTg7lQlQd/fU3E8b0Cb6
        K8F7ytkzRcpL/9zg7jJbTJwxTgxviCkOAusWeE7vQy0LvxDWCGUjou2wk7tOt/fYapGacx/4Xapx/
        JzoZ/NP8N+1pUfPBrnfpk/cOpJhf2Lf8IpUNj0Zo4q5rNnGoEghnt8/RxjN+/1SBIts/4N/0sp1U7
        3rpVoAqwolYcP9qHOdHTGJweZCnjZI3IvdZgNauTg1QdpH6SX0eZds1I/M7g1ezT6jx4X2YCkIO+1
        PURaGmNnXZRPVQD1OiFfaHPCM07Q3bRtOHK8DKQkfmjUjE54uEgmcnOCceXK9R0a3Leg4PP0jSX9x
        jWnVgFuZEpX3nquI7geej/v9LVh015V4G9YIEKKRE44Dk2Q3Y9X94OletIF+CCAVkhvKQfI3MdyaM
        5c7QxCs1t7mDK6KTQZEocxfU;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1oMQ8Z-009Jbt-7v; Fri, 12 Aug 2022 08:35:23 +0000
From:   Stefan Metzmacher <metze@samba.org>
To:     io-uring@vger.kernel.org, axboe@kernel.dk
Cc:     Stefan Metzmacher <metze@samba.org>
Subject: [RFC PATCH 6/8] io_uring: add BUILD_BUG_SQE_HDR_COMMON() macro
Date:   Fri, 12 Aug 2022 10:34:30 +0200
Message-Id: <3d34b306c65ccf095646ba01b08cdf473a54957b.1660291547.git.metze@samba.org>
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

This will be used in the next commits in order to
check common fields of opcode specific struct io_uring_sqe
union arms.

Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 io_uring/io_uring.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index f82173bde393..8e1a8800b252 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3916,6 +3916,20 @@ static int __init io_uring_init(void)
 #define BUILD_BUG_SQE_LEGACY_ALIAS(eoffset, etype, ename, lname) \
 	__BUILD_BUG_VERIFY_ALIAS(struct io_uring_sqe, eoffset, sizeof(etype), ename, legacy.lname)
 
+#define BUILD_BUG_SQE_HDR_COMMON(subtype, subname) do { \
+	BUILD_BUG_ON(sizeof(subtype) != 64); \
+	BUILD_BUG_SQE_ELEM(0,  subtype, subname); \
+	BUILD_BUG_SQE_ELEM(0,  struct io_uring_sqe_hdr, subname.hdr); \
+	BUILD_BUG_SQE_ALIAS(0,  __u8,   subname.hdr.opcode, hdr.opcode); \
+	BUILD_BUG_SQE_ALIAS(1,  __u8,   subname.hdr.flags, hdr.flags); \
+	BUILD_BUG_SQE_ALIAS(2,  __u16,  subname.hdr.ioprio, hdr.ioprio); \
+	BUILD_BUG_SQE_ALIAS(4,  __s32,  subname.hdr.fd, hdr.fd); \
+	BUILD_BUG_SQE_ELEM(32, struct io_uring_sqe_common, subname.common); \
+	BUILD_BUG_SQE_ALIAS(32, __u64,  subname.common.user_data, common.user_data); \
+	BUILD_BUG_SQE_ALIAS(40, __u16,  subname.common.buf_info, common.buf_info); \
+	BUILD_BUG_SQE_ALIAS(42, __u16,  subname.common.personality, common.personality); \
+} while (0)
+
 	BUILD_BUG_ON(sizeof(struct io_uring_sqe_hdr) != 8);
 	BUILD_BUG_SQE_HDR_ELEM(0,  __u8,   opcode);
 	BUILD_BUG_SQE_HDR_ELEM(1,  __u8,   flags);
-- 
2.34.1

