Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 124A2407A9B
	for <lists+io-uring@lfdr.de>; Sun, 12 Sep 2021 00:04:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234204AbhIKWGE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 11 Sep 2021 18:06:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229800AbhIKWGE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 11 Sep 2021 18:06:04 -0400
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8017CC061574
        for <io-uring@vger.kernel.org>; Sat, 11 Sep 2021 15:04:51 -0700 (PDT)
Received: by mail-il1-x12d.google.com with SMTP id v16so1180267ilg.3
        for <io-uring@vger.kernel.org>; Sat, 11 Sep 2021 15:04:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=Of9poZmBCCwgxbtkuflQxLYrvRBVNvaxUckV0AcJi6Q=;
        b=k6TsZC8+iX3sQXcx/8qvtyGNNFJKY5EjzuwFQtJ9jrrX1mBQA3bliwipGqswMpWwpH
         l15aGsqJbLqDbIntr5+0lqx7w53B7/Sfxy0D5An50zH61qZ6BbzcZwkcQreUnv2s6JDl
         OERYjfu4kiBRCejaL0ed+kvlulJncuejd2tXPTz4TeBCmpI1TuuL8CTaFrnD9IBNase8
         KYc+VMjVYfk8TBuya6ht3tRNeVYa99pGfxa+MGFmf9bzpemFX1yeXomo3+l6wbqsZriA
         TlEAqbS541JdQIPhYfVCZ8Wk0TiK7u4uRVPx3BerwxMpmldyLhD0Qy2ltsRVuCIDCq9s
         yBTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=Of9poZmBCCwgxbtkuflQxLYrvRBVNvaxUckV0AcJi6Q=;
        b=SrUPdbwx+yYf3Y6Njk8Z43U7SCN3qfJkANQgjocpHUexsNpadsdguRgwIKAZKCdFOJ
         AYUNpGwX9pN09EmyJvjcZyKyowRAxniPUlNYLpWBzeUkKnFfdRPYu5IfLWzzccbyizSs
         cbTUyxTdY07TIlniwFhtovwiNtWurwXja0vlGBcFHVRiwgAucHTG/AVn2CcmO008YIRS
         aVrWPhg4aHO5UCo8ORheR8w+4KkEImwnFIVDak3tcrJneVkq8LShOSbqWdC9cR1XWqYL
         5wgRw1sNbex1zd46ZtS5sCEvr1QBNHQi4sMpa74OzN39LnMqpNZKf8HI3Ja0THJm1JR+
         6Uqw==
X-Gm-Message-State: AOAM533dipq5Filonw1Was4Q4KdqsU818aDL3WPVeXcFZB+EAbyI6s3U
        7mKCd81TkNvK01tJ2mTCOI5G/In1MBeGKA==
X-Google-Smtp-Source: ABdhPJzBfnUNHqrWLzbNf4tmsQWlZ8Ao/kfhH2j9gB71yXqpFdUjk6CAVHh4n97q1VZ5+8xUMveWMQ==
X-Received: by 2002:a92:d107:: with SMTP id a7mr2887011ilb.199.1631397890727;
        Sat, 11 Sep 2021 15:04:50 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id y11sm1580818ilh.5.2021.09.11.15.04.50
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Sep 2021 15:04:50 -0700 (PDT)
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: dump sqe contents if issue fails
Message-ID: <64e2ce80-b758-b7f1-b816-0bb0401fcecb@kernel.dk>
Date:   Sat, 11 Sep 2021 16:04:50 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

I recently had to look at a production problem where a request ended
up getting the dreaded -EINVAL error on submit. The most used and
hence useless of error codes, as it just tells you that something
was wrong with your request, but not more than that.

Let's dump the full sqe contents if we run into an issue failure,
that'll allow easier diagnosing of a wide variety of issues.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io_uring.c b/fs/io_uring.c
index f795ad281038..e4fb140c25bf 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7064,6 +7064,8 @@ static int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	ret = io_init_req(ctx, req, sqe);
 	if (unlikely(ret)) {
 fail_req:
+		trace_io_uring_req_failed(sqe, ret);
+
 		/* fail even hard links since we don't submit */
 		if (link->head) {
 			/*
diff --git a/include/trace/events/io_uring.h b/include/trace/events/io_uring.h
index 0dd30de00e5b..7346f0164cf4 100644
--- a/include/trace/events/io_uring.h
+++ b/include/trace/events/io_uring.h
@@ -6,6 +6,7 @@
 #define _TRACE_IO_URING_H
 
 #include <linux/tracepoint.h>
+#include <uapi/linux/io_uring.h>
 
 struct io_wq_work;
 
@@ -497,6 +498,66 @@ TRACE_EVENT(io_uring_task_run,
 		  (unsigned long long) __entry->user_data)
 );
 
+/*
+ * io_uring_req_failed - called when an sqe is errored dring submission
+ *
+ * @sqe:		pointer to the io_uring_sqe that failed
+ * @error:		error it failed with
+ *
+ * Allows easier diagnosing of malformed requests in production systems.
+ */
+TRACE_EVENT(io_uring_req_failed,
+
+	TP_PROTO(const struct io_uring_sqe *sqe, int error),
+
+	TP_ARGS(sqe, error),
+
+	TP_STRUCT__entry (
+		__field(  u8,	opcode )
+		__field(  u8,	flags )
+		__field(  u8,	ioprio )
+		__field( u64,	off )
+		__field( u64,	addr )
+		__field( u32,	len )
+		__field( u32,	op_flags )
+		__field( u64,	user_data )
+		__field( u16,	buf_index )
+		__field( u16,	personality )
+		__field( u32,	file_index )
+		__field( u64,	pad1 )
+		__field( u64,	pad2 )
+		__field( int,	error )
+	),
+
+	TP_fast_assign(
+		__entry->opcode		= sqe->opcode;
+		__entry->flags		= sqe->flags;
+		__entry->ioprio		= sqe->ioprio;
+		__entry->off		= sqe->off;
+		__entry->addr		= sqe->addr;
+		__entry->len		= sqe->len;
+		__entry->op_flags	= sqe->rw_flags;
+		__entry->user_data	= sqe->user_data;
+		__entry->buf_index	= sqe->buf_index;
+		__entry->personality	= sqe->personality;
+		__entry->file_index	= sqe->file_index;
+		__entry->pad1		= sqe->__pad2[0];
+		__entry->pad2		= sqe->__pad2[1];
+		__entry->error		= error;
+	),
+
+	TP_printk("op %d, flags=0x%x, prio=%d, off=%llu, addr=%llu, "
+		  "len=%u, rw_flags=0x%x, user_data=0x%llx, buf_index=%d, "
+		  "personality=%d, file_index=%d, pad=0x%llx/%llx, error=%d",
+		  __entry->opcode, __entry->flags, __entry->ioprio,
+		  (unsigned long long)__entry->off,
+		  (unsigned long long) __entry->addr, __entry->len,
+		  __entry->op_flags, (unsigned long long) __entry->user_data,
+		  __entry->buf_index, __entry->personality, __entry->file_index,
+		  (unsigned long long) __entry->pad1,
+		  (unsigned long long) __entry->pad2, __entry->error)
+);
+
 #endif /* _TRACE_IO_URING_H */
 
 /* This part must be outside protection */

-- 
Jens Axboe

