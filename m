Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D21E590D70
	for <lists+io-uring@lfdr.de>; Fri, 12 Aug 2022 10:35:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235029AbiHLIfO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 12 Aug 2022 04:35:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236197AbiHLIfN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 12 Aug 2022 04:35:13 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59B9625D
        for <io-uring@vger.kernel.org>; Fri, 12 Aug 2022 01:35:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-Id:Date:Cc:To:From;
        bh=o0kR3zMUJZLoDs14oQ3YI4u4jgNsc7SoiXcSckYuZIs=; b=QnykvwJs8lDXLy71TgY8VeEsP5
        9mwQNBZOPQSATXPUEwVYUpn3cZZwyshBvggLPXdBIT2CmuKDFd3Cv4sLOW3p578nQYjU/PeDYD8IU
        v5i5xRktZowjqu4CHCf/dxbN3HCpshH+So7HtwQCHSuOF325pJOCIyVkevXTI5lPcRCgR3Ld7gFjl
        BPKZWhy9Ia5KTD9eieOyUdwmIE6bjw3V1/kJdw5WHHqHFzuuwxS8cIg5jA6QnWMR/CUN7B8FtUD4D
        a7ky0g+sIzY0jMIGszECWFS6ANr7nKl12CcG4cCFf366u6gR3+x/xQE/dSriyaY1Pp7QL7NyliW+3
        b/Zg8id6Sly+CCGXS+fhF3k6ncHl88ESjPeOoRismvqLMj32uWZ0Km1rMHO55xWyUBD83caco723x
        f/ZGeWyg2JSJRutYY+IUUDiS2MfgVxOXk6Y/QB0RIRwEtjiWR0RFfYlEhJHduxL2Z9B3xxGgTRI5k
        IkOUbaH8QN5CdDV8UJPpCbgx;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1oMQ8L-009Jbd-2k; Fri, 12 Aug 2022 08:35:09 +0000
From:   Stefan Metzmacher <metze@samba.org>
To:     io-uring@vger.kernel.org, axboe@kernel.dk
Cc:     Stefan Metzmacher <metze@samba.org>
Subject: [RFC PATCH 4/8] io_uring: only make use generic struct io_uring_sqe elements for tracing
Date:   Fri, 12 Aug 2022 10:34:28 +0200
Message-Id: <0910d8ca0ab2894101e088bee685df87eaf351cb.1660291547.git.metze@samba.org>
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

In the long run we might change the output, but for now just
prepare that defining IO_URING_SQE_HIDE_LEGACY would be possible.

Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 include/trace/events/io_uring.h | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/include/trace/events/io_uring.h b/include/trace/events/io_uring.h
index c5b21ff0ac85..12ffbe4e69cc 100644
--- a/include/trace/events/io_uring.h
+++ b/include/trace/events/io_uring.h
@@ -520,28 +520,28 @@ TRACE_EVENT(io_uring_req_failed,
 		__field( u64,			addr3		)
 		__field( int,			error		)
 
-		__string( op_str, io_uring_get_opcode(sqe->opcode) )
+		__string( op_str, io_uring_get_opcode(sqe->hdr.opcode) )
 	),
 
 	TP_fast_assign(
 		__entry->ctx		= req->ctx;
 		__entry->req		= req;
-		__entry->user_data	= sqe->user_data;
-		__entry->opcode		= sqe->opcode;
-		__entry->flags		= sqe->flags;
-		__entry->ioprio		= sqe->ioprio;
-		__entry->off		= sqe->off;
-		__entry->addr		= sqe->addr;
-		__entry->len		= sqe->len;
-		__entry->op_flags	= sqe->poll32_events;
-		__entry->buf_index	= sqe->buf_index;
-		__entry->personality	= sqe->personality;
-		__entry->file_index	= sqe->file_index;
-		__entry->pad1		= sqe->__pad2[0];
-		__entry->addr3		= sqe->addr3;
+		__entry->user_data	= sqe->common.user_data;
+		__entry->opcode		= sqe->hdr.opcode;
+		__entry->flags		= sqe->hdr.flags;
+		__entry->ioprio		= sqe->hdr.ioprio;
+		__entry->off		= sqe->u64_ofs08;
+		__entry->addr		= sqe->u64_ofs16;
+		__entry->len		= sqe->u32_ofs24;
+		__entry->op_flags	= sqe->u32_ofs28;
+		__entry->buf_index	= sqe->common.buf_info;
+		__entry->personality	= sqe->common.personality;
+		__entry->file_index	= sqe->u32_ofs44;
+		__entry->pad1		= sqe->u64_ofs56;
+		__entry->addr3		= sqe->u64_ofs48;
 		__entry->error		= error;
 
-		__assign_str(op_str, io_uring_get_opcode(sqe->opcode));
+		__assign_str(op_str, io_uring_get_opcode(sqe->hdr.opcode));
 	),
 
 	TP_printk("ring %p, req %p, user_data 0x%llx, "
-- 
2.34.1

