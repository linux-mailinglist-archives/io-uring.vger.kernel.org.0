Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F66935FE6E
	for <lists+io-uring@lfdr.de>; Thu, 15 Apr 2021 01:27:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237629AbhDNX11 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 14 Apr 2021 19:27:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237554AbhDNX10 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 14 Apr 2021 19:27:26 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47518C061574
        for <io-uring@vger.kernel.org>; Wed, 14 Apr 2021 16:27:04 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id s7so21307426wru.6
        for <io-uring@vger.kernel.org>; Wed, 14 Apr 2021 16:27:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xxO1eQifE15mqFgDeUegFvEwi1YyrXts/RTYX9gshT4=;
        b=qL8XKbXGi4x4f7wK4h7n33MJ/9s5s7SHi/9eZ/du7ldmLc9Jrn4yWlGVmtAPlAqKMD
         uR4FoK4Yg+7xKc5vxSgV5n2PICt8eoPDzvbXUmzM8qDFHRRCspMEKWBc254UyWEvTKE1
         pU/zlQCEVEG6x5QkcIxT2wqV/J15qg1nYeYV0duMS07msVxmWaN0v4n/ZVN+0MdGf1lp
         SpsJeTEsAbq5RX2BYhGWdPtQJg5lTVjngalD4KICfo5sKR10QzvixnDKGvFHcs1Zebon
         tUoWLJ/RK6k9yATJ3ZIaMzg+dHYQkY9pWCH/UzawpAWuSmH4c/j+AjIOmrOdrrxD/DsY
         hIug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xxO1eQifE15mqFgDeUegFvEwi1YyrXts/RTYX9gshT4=;
        b=ibBawvC6GT8oN0bcXTYQGQTggdkfaP36Zk9639W08tIF2nKK7qadKnesNDUGCtHjIZ
         bjMwAqoA9+DsRtyYfJhHaxGr/M1RyeYUsIn/iP6nPj5vaZzczmuEsySR0jZ5N+Abjetb
         UDAhWGo3v8l93dVPVwovFG1QltOZcbydwHXN4IZAhr0Io91GjZ0K8zT8tYxKQbxAiAWg
         1hLYiFvnhXMvecXHn2tJze1ojKpyYhdNj+UQszRRSzJg356J7/cIAnUb7kDV66PAbuUp
         0YJkHdD1AUtH68+2CB/wBgj0vyVyiZJc7zmkOBtoN4+sBVHzZMZ32js2tXjokD6QapJr
         5ong==
X-Gm-Message-State: AOAM532muRaOTW0hM1hRR2w4qO1TqXdW4ekY7nrpFfM95XVDDQ5zuynU
        rdoXch9cwGzroTSbbAWpPrl87h+y6g7uDQ==
X-Google-Smtp-Source: ABdhPJyQvmsFGOtSGY97UVOhWnCtYbK4KJhm3vhpWiCydrAaVRhjClcJqtgSVScKH8Bc06ObDgOlmw==
X-Received: by 2002:adf:dfc2:: with SMTP id q2mr316702wrn.128.1618442823024;
        Wed, 14 Apr 2021 16:27:03 -0700 (PDT)
Received: from localhost.localdomain ([185.69.144.21])
        by smtp.gmail.com with ESMTPSA id m3sm667143wme.40.2021.04.14.16.27.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Apr 2021 16:27:02 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH liburing] tests/poll: poll update as a part of poll remove
Date:   Thu, 15 Apr 2021 00:22:47 +0100
Message-Id: <3d7646712081cf84346f13d94098cda257cab11a.1618442414.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Fix up poll-mshot-update test doing poll updates as we moved poll
updates under IORING_OP_POLL_REMOVE. And add a helper for updates.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 src/include/liburing.h   | 13 +++++++++++++
 test/poll-mshot-update.c |  7 +++----
 2 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/src/include/liburing.h b/src/include/liburing.h
index 5b96e02..5bda635 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -329,6 +329,19 @@ static inline void io_uring_prep_poll_remove(struct io_uring_sqe *sqe,
 	io_uring_prep_rw(IORING_OP_POLL_REMOVE, sqe, -1, user_data, 0, 0);
 }
 
+static inline void io_uring_prep_poll_update(struct io_uring_sqe *sqe,
+					     void *old_user_data,
+					     void *new_user_data,
+					     unsigned poll_mask, unsigned flags)
+{
+	io_uring_prep_rw(IORING_OP_POLL_REMOVE, sqe, -1, old_user_data, flags,
+			 (__u64)new_user_data);
+#if __BYTE_ORDER == __BIG_ENDIAN
+	poll_mask = __swahw32(poll_mask);
+#endif
+	sqe->poll32_events = poll_mask;
+}
+
 static inline void io_uring_prep_fsync(struct io_uring_sqe *sqe, int fd,
 				       unsigned fsync_flags)
 {
diff --git a/test/poll-mshot-update.c b/test/poll-mshot-update.c
index bfe96c8..1a9ea0a 100644
--- a/test/poll-mshot-update.c
+++ b/test/poll-mshot-update.c
@@ -56,11 +56,10 @@ static int reap_polls(struct io_uring *ring)
 		struct io_uring_sqe *sqe;
 
 		sqe = io_uring_get_sqe(ring);
-		io_uring_prep_poll_add(sqe, p[i].fd[0], POLLIN);
+		/* update event */
+		io_uring_prep_poll_update(sqe, (void *)(unsigned long)i, NULL,
+					  POLLIN, 2);
 		sqe->user_data = 0x12345678;
-		sqe->addr = i;
-		sqe->off = POLLIN;
-		sqe->len = 2;
 	}
 
 	ret = io_uring_submit(ring);
-- 
2.24.0

