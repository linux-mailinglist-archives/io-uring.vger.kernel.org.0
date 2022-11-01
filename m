Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CE1761450C
	for <lists+io-uring@lfdr.de>; Tue,  1 Nov 2022 08:30:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229553AbiKAHaD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 1 Nov 2022 03:30:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbiKAHaC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 1 Nov 2022 03:30:02 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC37B15704;
        Tue,  1 Nov 2022 00:30:00 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id s196so12741697pgs.3;
        Tue, 01 Nov 2022 00:30:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=/scyIPaJv7qVvjBPhsSoD7DikDGrxiZfHb4+iyUbI4c=;
        b=kbPVrtFSBxjGCOPh2ADxUrv+QfxgI+QlkyvOtkOPzyygPic8ltO0KoYOMDxFWUfLyw
         HL6B9SngK2XZZtCP4RN/tAD4JVEYfdC1Zibf36q6BBZwOsp5KPS9Qj05NUVMtZQkgyCV
         /3elH4fJp35qbwUcjYoZBdHTecv8VzABYr7GcYVwnAuf6MhJW/v04fKT6GCMqCq+GuYn
         Rrit8nSZF7O36GRtXBMCeANPfKlh4lEBIMepiKA8MWAzz9wrnKAuPNwc1Hlzia1Cr9io
         GWb+mDkSsOh460WEv/F4BJxSGByFtOUd5bDBSlXzUrjgfWx5fT5l+coZOxr/FZ53kQHZ
         djug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/scyIPaJv7qVvjBPhsSoD7DikDGrxiZfHb4+iyUbI4c=;
        b=hUAP9ob4P3UemaZhzqYTvD8XVg/TEXnwBPsoFf9xNVW3oO6naD8kwS1TShIZbB/Pxi
         naqS2VE1E20TCKrEmFqthRerzkBL8hk0vtFqejluS8nVl1tc629iXa5ObUy9oSkDF7mU
         QWDDHfYhOCMGCyrMVcVr9Zqnd1zvB6cO8EfHTgq/2v5m66KGNpI2338K2IsSov7I8HXE
         YNp86tDcCiSVn2F+KFVChKhB6CuI7LxQPiI8i8Thbux5NF30J9NNOXLNfIc6YRML1nNx
         nKM5E509Z1jsXkSzfcjH7UhrQjtehuxZhMKEipCV3IxfTeH1Hkm48HlQGcUiyxGk0miW
         Yu2w==
X-Gm-Message-State: ACrzQf2xCJ8djouCkgrVmc1CkSfNXVk5jt/C6cvb/bUalaNCG1rTFPSE
        J6cSdJh3moTcsSsuk0QlLcMNTyOTa5ETbcom
X-Google-Smtp-Source: AMsMyM5siB6AnHc9wFsMK0x5I9G3qzPaMMevRdpN1XZfCeLx40tCZ29QwaU64l0zwFAfNXnd2jIqfg==
X-Received: by 2002:a05:6a00:2315:b0:56d:a084:a77d with SMTP id h21-20020a056a00231500b0056da084a77dmr5795963pfh.53.1667287800210;
        Tue, 01 Nov 2022 00:30:00 -0700 (PDT)
Received: from localhost.localdomain ([43.132.98.40])
        by smtp.gmail.com with ESMTPSA id y4-20020aa79e04000000b0056c0d129edfsm5779133pfq.121.2022.11.01.00.29.58
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 01 Nov 2022 00:29:59 -0700 (PDT)
From:   korantwork@gmail.com
To:     axboe@kernel.dk
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xinghui Li <korantli@tencent.com>
Subject: [PATCH] io_uring: fix two assignments in if conditions
Date:   Tue,  1 Nov 2022 15:29:56 +0800
Message-Id: <20221101072956.13028-1-korantwork@gmail.com>
X-Mailer: git-send-email 2.36.1
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

From: Xinghui Li <korantli@tencent.com>

Fixs two error:

"ERROR: do not use assignment in if condition
#130: FILE: io_uring/net.c:130:
+       if (!(issue_flags & IO_URING_F_UNLOCKED) &&

ERROR: do not use assignment in if condition
#599: FILE: io_uring/poll.c:599:
+       } else if (!(issue_flags & IO_URING_F_UNLOCKED) &&"
reported by checkpatch.pl in net.c and poll.c .

Signed-off-by: Xinghui Li <korantli@tencent.com>
---
 io_uring/net.c  | 16 +++++++++-------
 io_uring/poll.c |  7 ++++---
 2 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 15dea91625e2..cbd655c88499 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -127,13 +127,15 @@ static struct io_async_msghdr *io_msg_alloc_async(struct io_kiocb *req,
 	struct io_cache_entry *entry;
 	struct io_async_msghdr *hdr;
 
-	if (!(issue_flags & IO_URING_F_UNLOCKED) &&
-	    (entry = io_alloc_cache_get(&ctx->netmsg_cache)) != NULL) {
-		hdr = container_of(entry, struct io_async_msghdr, cache);
-		hdr->free_iov = NULL;
-		req->flags |= REQ_F_ASYNC_DATA;
-		req->async_data = hdr;
-		return hdr;
+	if (!(issue_flags & IO_URING_F_UNLOCKED)) {
+		entry = io_alloc_cache_get(&ctx->netmsg_cache);
+		if (entry != NULL) {
+			hdr = container_of(entry, struct io_async_msghdr, cache);
+			hdr->free_iov = NULL;
+			req->flags |= REQ_F_ASYNC_DATA;
+			req->async_data = hdr;
+			return hdr;
+		}
 	}
 
 	if (!io_alloc_async_data(req)) {
diff --git a/io_uring/poll.c b/io_uring/poll.c
index 0d9f49c575e0..e1cb81cca44c 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -596,9 +596,10 @@ static struct async_poll *io_req_alloc_apoll(struct io_kiocb *req,
 	if (req->flags & REQ_F_POLLED) {
 		apoll = req->apoll;
 		kfree(apoll->double_poll);
-	} else if (!(issue_flags & IO_URING_F_UNLOCKED) &&
-		   (entry = io_alloc_cache_get(&ctx->apoll_cache)) != NULL) {
-		apoll = container_of(entry, struct async_poll, cache);
+	} else if (!(issue_flags & IO_URING_F_UNLOCKED)) {
+		entry = io_alloc_cache_get(&ctx->apoll_cache);
+		if (entry != NULL)
+			apoll = container_of(entry, struct async_poll, cache);
 	} else {
 		apoll = kmalloc(sizeof(*apoll), GFP_ATOMIC);
 		if (unlikely(!apoll))
-- 
2.36.1

