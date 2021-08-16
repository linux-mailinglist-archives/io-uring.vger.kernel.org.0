Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 181833EDCF5
	for <lists+io-uring@lfdr.de>; Mon, 16 Aug 2021 20:16:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229790AbhHPSRS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 16 Aug 2021 14:17:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbhHPSRR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 16 Aug 2021 14:17:17 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0AE0C061764
        for <io-uring@vger.kernel.org>; Mon, 16 Aug 2021 11:16:45 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id h13so24939035wrp.1
        for <io-uring@vger.kernel.org>; Mon, 16 Aug 2021 11:16:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RxMdjisT9UAZNQr8erw9TgBzXrGc1aEjT2RycAgKm24=;
        b=EnDQWibkFF80a6PlnTT38Xsa9+A0Sz+NDG9nRz+bpyRa9t6m7JNjL9p5k0kulZ08Z1
         EGNcAgTXtBjhO6ivHAB5Lnjjrf3XsKN+AofZNYkGr0BC8xx+CKGZVfl2t+w0SpPdjUUJ
         DSjbICNjS4iTYja4zAZ3XUe458E5SBr1bdEsk2vsohHHlqNz30WQ7toH7qQm7cI5WmUP
         x33Nfu9w+LL1pyWBFeGRj9X6nIUFBl+e5xuyI1vCz9zT09+DzdPMAHMdFZmnN9qNv4ak
         5XCbXspKp+2VTtdUMsqV6IF345A0zmqYtsRaBDCUdMkm54OiZFWkF8mgvev+joWbSRkf
         gwhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RxMdjisT9UAZNQr8erw9TgBzXrGc1aEjT2RycAgKm24=;
        b=EF/1r1LtOHk9DfxM+SUQof2s0ishTtMhnUXzQhr84jmf36o4PxklzhwRcj3yN5dFEB
         MkJI+4H+BfX9NMaT6QDQMIHsc2YwG4hbtk3rIO4tNoRDzOs9EsnvAqy/nuxz8rGF4GZc
         tzFsHhlfWGtzq2Dcp09iaR8dynZv5ztV+uLoZk9tmdzta/zAjxnc+CvWoFkH/5rNxl88
         9NyGppP97nPXBUNXAtUem2H5ZopYkSeNYQYqVhUs2PUJKMJ0OPH4gYf5qp58i+e2w8ZV
         Vw32SGFK+VbCkaKdF59qXjnA1bcMyBG0+H6jiE64Z/O/qbtJu/Oe2LvlPQ9opWSlhL+F
         cA+g==
X-Gm-Message-State: AOAM532nFOGD8SBLU/o+u6SmebYqNQLZLm3EGqlbwHFCDcZWvB+KClXu
        V0I6k68MiKqghc0C4K7bqRLVyio85/g=
X-Google-Smtp-Source: ABdhPJztjJTE+tjW+yLcG+1UGH3bQJ6VZ/+gA/FqG4M8GKURMuU6B+209y4V2uorRrq4y2WC7kES/g==
X-Received: by 2002:a5d:4b01:: with SMTP id v1mr19418655wrq.377.1629137804350;
        Mon, 16 Aug 2021 11:16:44 -0700 (PDT)
Received: from localhost.localdomain ([85.255.233.12])
        by smtp.gmail.com with ESMTPSA id b20sm254779wmj.48.2021.08.16.11.16.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Aug 2021 11:16:43 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     syzbot+2b85e9379c34945fe38f@syzkaller.appspotmail.com
Subject: [PATCH 5.15] io_uring: don't forget to clear REQ_F_ARM_LTIMEOUT
Date:   Mon, 16 Aug 2021 19:16:08 +0100
Message-Id: <614f650abdd5fee97aa5a6a87028a2c47d2a6c94.1629137586.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Even though it should be safe to poke into req->link after
io_issue_sqe() in terms of races, it may end up retiring a request, e.g.
when someone calls io_req_complete(). It'll be placed into an internal
request cache, so the memory would be valid with other guarantees, but
the request will be actually dismantled and with requests linked removed
and enqueued.

Hence, don't forget to remove REQ_F_ARM_LTIMEOUT after a linked timeout
got disarmed, otherwise following io_prep_linked_timeout() will expect
req->link to be not-zero and so fault.

Fixes: 19bfc9a0d26c5 ("io_uring: optimise io_prep_linked_timeout()")
Reported-by: syzbot+2b85e9379c34945fe38f@syzkaller.appspotmail.com
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---

Not sure whether it fixes the syzbot report, but hopefully it'll
find a repro soon.

 fs/io_uring.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 17d0125c331a..29e3ec6e9dbf 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1311,6 +1311,9 @@ static inline void io_unprep_linked_timeout(struct io_kiocb *req)
 
 static struct io_kiocb *__io_prep_linked_timeout(struct io_kiocb *req)
 {
+	if (WARN_ON_ONCE(!req->link))
+		return NULL;
+
 	req->flags &= ~REQ_F_ARM_LTIMEOUT;
 	req->flags |= REQ_F_LINK_TIMEOUT;
 
@@ -1935,6 +1938,7 @@ static bool io_disarm_next(struct io_kiocb *req)
 	if (req->flags & REQ_F_ARM_LTIMEOUT) {
 		struct io_kiocb *link = req->link;
 
+		req->flags &= ~REQ_F_ARM_LTIMEOUT;
 		if (link && link->opcode == IORING_OP_LINK_TIMEOUT) {
 			io_remove_next_linked(req);
 			io_cqring_fill_event(link->ctx, link->user_data,
-- 
2.32.0

