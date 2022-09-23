Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 583BF5E7E4F
	for <lists+io-uring@lfdr.de>; Fri, 23 Sep 2022 17:24:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229507AbiIWPY5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 23 Sep 2022 11:24:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231392AbiIWPYz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 23 Sep 2022 11:24:55 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E850C760FA
        for <io-uring@vger.kernel.org>; Fri, 23 Sep 2022 08:24:54 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id l8so461542wmi.2
        for <io-uring@vger.kernel.org>; Fri, 23 Sep 2022 08:24:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=t6FGNWMCdKGOCPkqauCnhALpSopCNLftgjMxt06NOzM=;
        b=MhJd051Uy/+PQpeZssQaFQxthBsDW/9Cu4o43OWMnWB8TfD0IFNM/m+BRb2u5LNSUr
         WmX2zsGvndTNdwvYFjL0gNRKpoKQXQorBGlIr3gLYcK+jYcl81Lv+f0MrbWXwnvVk08Y
         4CjsBS4arklqNc0YCbvQD0hC3iSAsFRN7KW6wcCEfEVBbyI9dD0O2CvMhX/s/Eq+nu6T
         +bxJ5SmaB8Xb8MCRmGnk1fzihlB82qllciF0mJ0Oh5cdnDkPvGbE+fdTqz27mWYZaTNN
         go1cSFmWBCBOj9UmwaNeV6Uzo7hYTd3qboy+EqycPe+XlyQNzCgclOQuZaG96NE6E9iY
         jCWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=t6FGNWMCdKGOCPkqauCnhALpSopCNLftgjMxt06NOzM=;
        b=N/dYWFbya25UnzYfFbuWdVejimZ1609W3yp2hy5lXMwxg9mA7m512+hrdSFqhCAbpP
         JCKlHLqMhOAthDonqgbh5H/HkLWzzXrolEIiVN61eHXLC+ExEvLjOS1+Uh6GWv53FrLp
         bwdlcqjO2W1SkshtG5W8bN9Yl5itiKnuGziPkHfCkRLeQ6kZcVviOd+nUhBr+QrzVSzW
         hQmbP0VMcQNtniOT1ikhSRUxrWDYWZbKDViL0lAYGtKpSy/JJD5HaM4vkIybTCDf+/8f
         mwYJAQLEPqnEu0NaJ9YM/Tn0M1UdKaVDq+rOYvRy9sgf3PlWJQy1jixjtzRjRUubtwNh
         c5AA==
X-Gm-Message-State: ACrzQf21Q45fAFuBGafH+njBCQX7z8NTwyUSqE1oN6Y0WXt34ZrMBXVB
        DtP7XSweGIj5eFKGXp/qlzu/n2J2A1g=
X-Google-Smtp-Source: AMsMyM7ZEn0DRGILVaTwHOAWwIkzWE7eoh2NZZn/RoMhdp03+Y4SFqllSOnETUxP9Clzbn71hbbUdg==
X-Received: by 2002:a7b:ce0d:0:b0:3b4:8728:3e7e with SMTP id m13-20020a7bce0d000000b003b487283e7emr6042885wmc.182.1663946693210;
        Fri, 23 Sep 2022 08:24:53 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.201.74.threembb.co.uk. [188.28.201.74])
        by smtp.gmail.com with ESMTPSA id t11-20020a05600c41cb00b003b31fc77407sm2631684wmh.30.2022.09.23.08.24.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Sep 2022 08:24:52 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com,
        Dylan Yudaken <dylany@fb.com>,
        syzbot+4c597a574a3f5a251bda@syzkaller.appspotmail.com
Subject: [PATCH for-next v2] io_uring/net: fix UAF in io_sendrecv_fail()
Date:   Fri, 23 Sep 2022 16:23:34 +0100
Message-Id: <23ab8346e407ea50b1198a172c8a97e1cf22915b.1663945875.git.asml.silence@gmail.com>
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

v2: remove unused variable

 io_uring/net.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 757a300578f4..2af56661590a 100644
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
@@ -1202,7 +1204,6 @@ int io_sendmsg_zc(struct io_kiocb *req, unsigned int issue_flags)
 void io_sendrecv_fail(struct io_kiocb *req)
 {
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
-	struct io_async_msghdr *io;
 	int res = req->cqe.res;
 
 	if (req->flags & REQ_F_PARTIAL_IO)
@@ -1215,12 +1216,6 @@ void io_sendrecv_fail(struct io_kiocb *req)
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

