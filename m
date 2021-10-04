Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC0D44204C3
	for <lists+io-uring@lfdr.de>; Mon,  4 Oct 2021 03:35:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231935AbhJDBhm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 3 Oct 2021 21:37:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbhJDBhm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 3 Oct 2021 21:37:42 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1014AC0613EC
        for <io-uring@vger.kernel.org>; Sun,  3 Oct 2021 18:35:54 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id p1so7060570pfh.8
        for <io-uring@vger.kernel.org>; Sun, 03 Oct 2021 18:35:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amikom.ac.id; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=D1PLQwQBkvVsTQu1t5WjXPD+Pa6glsD1yRrV7Doi6zQ=;
        b=diY98aJyknGQFo4C4AhfCG3np4iVepWcAfdh7DLzEclUlY+SZEBmfeLxJNuGNEBgy2
         jlg5CKwMivRHp7kcbF0Uw6PnEnqtP5/4h0fPixyFKG+gVqghfSweOM5mCRZZHVFFG7lu
         o+9iOAgNyjnlBwRX5WFZLl89tPIvUNX5otMFPfaBRtynVriif83aqkGWWAx8vZwmpiGg
         I+hJtmKvGJ+G3mYg3oawwCRf1OHGhJXL2XUHsI7cqIo39W6WD9aF8v/7xHEsm746A3b4
         1SiAoowZRYAPZnDMyUdpmdzBAhTkbFQUv6ppHHrzIXvyv480FA2G9bqBp0zJML80Jg6G
         ik5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=D1PLQwQBkvVsTQu1t5WjXPD+Pa6glsD1yRrV7Doi6zQ=;
        b=vsmfvsDlpwgdEfMo/+PMDY4LsYoChFRgrGz5D54kfz5jalnl/0X4jnXPF/+UuRcnGe
         2XUZ0Ulw/iNPV4WuEgygWbVWGccwovz+QwiQzvcsQIwThNrbhX9GYRw1nKhYK+lCaxJk
         gUgeHdbM6OymnO8HpQlHmHrhSeZTE/AuJ8xf/iyoxM+ydf7IB6MrAAfRQbitnhEmNzEQ
         122lontDF1ziC3mOMmAYn2biJl+pmAllTbCe4KrZ9ru81vKO2e3fJApzZC9VUEVtn9W5
         YL8yfwF/on+kKX4dR6wFCzOqVdEsVjbiRwUVAnrTDoN0t1SeQpuwI9R329rSXhdW9dy3
         ApUg==
X-Gm-Message-State: AOAM532uBafHp1N/K1QdghqZ6IJ7WseLxGjw56lTx2p9nS1o8Ufnhi+v
        Z9Z37DRADFnMZPvvKP4bCX0KvQ==
X-Google-Smtp-Source: ABdhPJzmv1cIMvNTbMQYctkX4ECgXoKv9Eju03lO/hw3zmKjYz+ghVeXqcTB8uJaRBo9Bw7yUOoR6w==
X-Received: by 2002:a63:24a:: with SMTP id 71mr8718770pgc.285.1633311353479;
        Sun, 03 Oct 2021 18:35:53 -0700 (PDT)
Received: from integral.. ([182.2.73.133])
        by smtp.gmail.com with ESMTPSA id s17sm11797934pge.50.2021.10.03.18.35.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Oct 2021 18:35:53 -0700 (PDT)
From:   Ammar Faizi <ammar.faizi@students.amikom.ac.id>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring Mailing List <io-uring@vger.kernel.org>,
        Ammar Faizi <ammar.faizi@students.amikom.ac.id>
Subject: [PATCH liburing] src/syscall: Add `close` syscall wrapper
Date:   Mon,  4 Oct 2021 08:35:10 +0700
Message-Id: <20211004013510.428077-1-ammar.faizi@students.amikom.ac.id>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

In commit 0c210dbae26a80ee82dbc7430828ab6fd7012548 ("Wrap all syscalls
in a kernel style return value"), we forgot to add a syscall wrapper
for `close()`. Add it.

Fixes: cccf0fa1762aac3f14323fbfc5cef2c99a03efe4 ("Wrap all syscalls in a kernel style return value")
Signed-off-by: Ammar Faizi <ammar.faizi@students.amikom.ac.id>
---
 src/setup.c   | 4 ++--
 src/syscall.h | 8 ++++++++
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/src/setup.c b/src/setup.c
index bdbf97c..4f006de 100644
--- a/src/setup.c
+++ b/src/setup.c
@@ -145,7 +145,7 @@ int io_uring_queue_init_params(unsigned entries, struct io_uring *ring,
 
 	ret = io_uring_queue_mmap(fd, p, ring);
 	if (ret) {
-		close(fd);
+		uring_close(fd);
 		return ret;
 	}
 
@@ -174,7 +174,7 @@ void io_uring_queue_exit(struct io_uring *ring)
 
 	uring_munmap(sq->sqes, *sq->kring_entries * sizeof(struct io_uring_sqe));
 	io_uring_unmap_rings(sq, cq);
-	close(ring->ring_fd);
+	uring_close(ring->ring_fd);
 }
 
 struct io_uring_probe *io_uring_get_probe_ring(struct io_uring *ring)
diff --git a/src/syscall.h b/src/syscall.h
index a9dd280..9eff968 100644
--- a/src/syscall.h
+++ b/src/syscall.h
@@ -156,4 +156,12 @@ static inline int uring_setrlimit(int resource, const struct rlimit *rlim)
 	return (ret < 0) ? -errno : ret;
 }
 
+static inline int uring_close(int fd)
+{
+	int ret;
+
+	ret = close(fd);
+	return (ret < 0) ? -errno : ret;
+}
+
 #endif
-- 
2.30.2

