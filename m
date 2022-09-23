Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66A8C5E7C71
	for <lists+io-uring@lfdr.de>; Fri, 23 Sep 2022 16:02:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231281AbiIWOBh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 23 Sep 2022 10:01:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231264AbiIWOBF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 23 Sep 2022 10:01:05 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E547E13A380
        for <io-uring@vger.kernel.org>; Fri, 23 Sep 2022 07:01:03 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id t4so279873wmj.5
        for <io-uring@vger.kernel.org>; Fri, 23 Sep 2022 07:01:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=xjQgavGDEZ3Jv7HpRnffo3TrxDyP8dp7Z6tA7yca9p0=;
        b=IQF0S7c5sbwOCqb0cF8zlsTin5OahEIGmfX5OSqH/6+KYLTVYqZ+6dj2I+ZzgoG7uV
         h7MIs5PiBFFKLXowzrYBarxVYJUbQgtQgIbtLyK/xfJoPOoIxqHYSTa6WNHEW9O48EYv
         rTIyblEvA0L+9oCBanwqdhuQxfAiQYYqmqaMVlG2PQDZhgWny0UaNTp6oM979pRPpAJv
         K4gkJ1jY9Mo4bzlQw4v0wL5DK95aC2DD9sqF/MJVhWJcq/6aDscXdY3ATvCv1q5Q+KSW
         WC9pICZClVAITNd98Q99WhbLJJoYTtUUdpfutmoY0N8fwobUG3UUBWo4XWspAI3hLWJH
         UuNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=xjQgavGDEZ3Jv7HpRnffo3TrxDyP8dp7Z6tA7yca9p0=;
        b=5BAXOYRcKReszq8srXuVTMSuZfR9xQxcyXJqFNnMoIXNogNeJrWReAKP8QGwfwE5IX
         6H+VuOScd8vAyOB7kjOYWFD70e41WGZHeGx6pfSME1GvYSMfycCCnxshM9JhjyrL2+70
         y5+kp32QuCQyssl8ILOQleyYaiDUwAp/mG+bfnFL2cfCJC2uE+TkePnj/0YesY2a5EVp
         lM1isRl55I9uWWt0Uj+OQJTYc9PXvV41xvBgy43wwXqUAYOwnVf8Plcbc5FAgZa/ywOQ
         SwBEBQZei+5GvEWxhBTw85DcVCcev6RZRMW5jOyYRXB7Ak9dzBS+MwQpAUAE4UZBxWu3
         7Xcg==
X-Gm-Message-State: ACrzQf2SrbGjCtd1RjBACAoePKLO5MQlnaMqw31tO1534jEbILP6DSxk
        sJN079tdezL5FKAHdKvW+ZmVeXYHMOo=
X-Google-Smtp-Source: AMsMyM4s3fBkQcyaDLtoefFRvpMtQRlxGzcigohAWBlWtHPDa+g8QF9zplOAC6a45fQK6MlYQWkftg==
X-Received: by 2002:a1c:7c12:0:b0:3b4:73e1:bdd7 with SMTP id x18-20020a1c7c12000000b003b473e1bdd7mr13490913wmc.32.1663941662104;
        Fri, 23 Sep 2022 07:01:02 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.201.74.threembb.co.uk. [188.28.201.74])
        by smtp.gmail.com with ESMTPSA id k22-20020a05600c1c9600b003b340f00f10sm2806917wms.31.2022.09.23.07.01.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Sep 2022 07:01:01 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com,
        Dylan Yudaken <dylany@fb.com>,
        syzbot+4c597a574a3f5a251bda@syzkaller.appspotmail.com
Subject: [PATCH for-next 1/1] io_uring/net: fix UAF in io_sendrecv_fail()
Date:   Fri, 23 Sep 2022 14:59:47 +0100
Message-Id: <49ee34929051a668e4829b6549dcd3eba49bf95b.1663941567.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We should not assume anything about ->free_iov just from
REQ_F_ASYNC_DATA but rather rely on REQ_F_NEED_CLEANUP, as we may
allocate ->async_data but failed init would leave the field in not
consistent state. The easiest solution is to remove removing
REQ_F_NEED_CLEANUP and so ->async_data dealloc from io_sendrecv_fail()
and let io_send_zc_cleanup() do the job. The catch here is that we also
need to prevent double notif flushing, just test it for NULL and zero
where it's needed.

BUG: KASAN: use-after-free in io_sendrecv_fail+0x3b0/0x3e0 io_uring/net.c:1221
Write of size 8 at addr ffff8880771b4080 by task syz-executor.3/30199

CPU: 1 PID: 30199 Comm: syz-executor.3 Not tainted 6.0.0-rc6-next-20220923-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/26/2022
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 print_address_description mm/kasan/report.c:284 [inline]
 print_report+0x15e/0x45d mm/kasan/report.c:395
 kasan_report+0xbb/0x1f0 mm/kasan/report.c:495
 io_sendrecv_fail+0x3b0/0x3e0 io_uring/net.c:1221
 io_req_complete_failed+0x155/0x1b0 io_uring/io_uring.c:873
 io_drain_req io_uring/io_uring.c:1648 [inline]
 io_queue_sqe_fallback.cold+0x29f/0x788 io_uring/io_uring.c:1931
 io_submit_sqe io_uring/io_uring.c:2160 [inline]
 io_submit_sqes+0x1180/0x1df0 io_uring/io_uring.c:2276
 __do_sys_io_uring_enter+0xac6/0x2410 io_uring/io_uring.c:3216
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Fixes: c4c0009e0b56e ("io_uring/net: combine fail handlers")
Reported-by: syzbot+4c597a574a3f5a251bda@syzkaller.appspotmail.com
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/net.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 757a300578f4..e9e66bace45f 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -915,9 +915,11 @@ void io_send_zc_cleanup(struct io_kiocb *req)
 		io = req->async_data;
 		kfree(io->free_iov);
 	}
-	zc->notif->flags |= REQ_F_CQE_SKIP;
-	io_notif_flush(zc->notif);
-	zc->notif = NULL;
+	if (zc->notif) {
+		zc->notif->flags |= REQ_F_CQE_SKIP;
+		io_notif_flush(zc->notif);
+		zc->notif = NULL;
+	}
 }
 
 int io_send_zc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
@@ -1215,12 +1217,6 @@ void io_sendrecv_fail(struct io_kiocb *req)
 		io_notif_flush(sr->notif);
 		sr->notif = NULL;
 	}
-	if (req_has_async_data(req)) {
-		io = req->async_data;
-		kfree(io->free_iov);
-		io->free_iov = NULL;
-	}
-	req->flags &= ~REQ_F_NEED_CLEANUP;
 	io_req_set_res(req, res, req->cqe.flags);
 }
 
-- 
2.37.2

