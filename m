Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BFCE174906
	for <lists+io-uring@lfdr.de>; Sat, 29 Feb 2020 20:49:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727252AbgB2Ttk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 29 Feb 2020 14:49:40 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:32889 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726663AbgB2Ttk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 29 Feb 2020 14:49:40 -0500
Received: by mail-wr1-f65.google.com with SMTP id x7so7560177wrr.0;
        Sat, 29 Feb 2020 11:49:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HF9TR+cuxNWTzEGKhi1O+qaHNvsycP3lUbuHZcTsNJs=;
        b=E5EAIC2OlGesClpHg0uzvcu39fkQQPPMYzYLaiDiU/o8FTpWWmfO8mvjThlU4J8CX4
         BZxSEiHe9BLvtO4T3zdDfgFkR1d8pZinhWhaKrZ169PFikd81CxUv1b5MseoTNCqXqJq
         6vn/e7GE6LkpE80M3zxAkeIjuaGPCQO2ddXfX83722wZFmLPu6oqm59pNThwXN8KPyia
         b7KgynleGYWAVjnB+jQk9QAQ3U7tTS0f63apc/OsKVc7HlPw6on7gJBDuZdo/OXiW8so
         EXC4IZ/glNgAInihqYKqtqfEyS50RL+bl5/Ps6wBPMKupGYPpxYKDwvYVT+6ebyRYy6z
         iHSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HF9TR+cuxNWTzEGKhi1O+qaHNvsycP3lUbuHZcTsNJs=;
        b=DbKQinlgrVeL1qb143YaP8x4gW/IvwRBk+vlv5RM0vMpfAsN2EZAd11ixhtySsdGD4
         vR9wPSpU6QxhU0pnwB1/MpBW3fwRpDReMOyInw6QlssQasGVBsE9Ha+HXC0ykTpf1xrd
         Quqk10MBNCyNfh08RMC/wzwliNiZFQzD92KAvgQRjucqJe/Hx1lFPxbaLPVeUX9Mr8sS
         88WIIuYaWWOC+WmvRlQXV0OJ0yX3Sz+EBgpPQEuoUp7WTXveXcHloe3Rmfk5+jHhzIbr
         r7BAcx+i21uhRLHSxE56BUEuTb72T+X2g//U/4c+dBsXokMDkqtfXHq5JF6b3TGdFxOf
         WP0A==
X-Gm-Message-State: APjAAAWQ/w3tMi3KGCzf4DqwYjMGXpZKTvX8s8tKDma1yN5YzhRMIxCO
        ETgmza1B40eUljvKOp1CpyneurXn
X-Google-Smtp-Source: APXvYqzUyFKcrZPdkhDJl4JU8Qwv9mX4J0hwEclYoNJ72Ck/ez8IZB9hu8P73Lxh50PESpCiwF9QXg==
X-Received: by 2002:adf:fc10:: with SMTP id i16mr8544595wrr.331.1583005778611;
        Sat, 29 Feb 2020 11:49:38 -0800 (PST)
Received: from localhost.localdomain ([109.126.130.242])
        by smtp.gmail.com with ESMTPSA id x21sm7081549wmi.30.2020.02.29.11.49.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Feb 2020 11:49:38 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] io_uring: remove io_prep_next_work()
Date:   Sat, 29 Feb 2020 22:48:45 +0300
Message-Id: <d5893319c019695321a357cb1f09e76ed40715d1.1583005556.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io-wq cares about IO_WQ_WORK_UNBOUND flag only while enqueueing, so
it's useless setting it for a next req of a link. Thus, removed it
from io_prep_linked_timeout(), and inline the function.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 74498c9cd023..9bbef21bad5b 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -999,17 +999,6 @@ static inline void io_req_work_drop_env(struct io_kiocb *req)
 	}
 }
 
-static inline void io_prep_next_work(struct io_kiocb *req,
-				     struct io_kiocb **link)
-{
-	const struct io_op_def *def = &io_op_defs[req->opcode];
-
-	if (!(req->flags & REQ_F_ISREG) && def->unbound_nonreg_file)
-		req->work.flags |= IO_WQ_WORK_UNBOUND;
-
-	*link = io_prep_linked_timeout(req);
-}
-
 static inline bool io_prep_async_work(struct io_kiocb *req,
 				      struct io_kiocb **link)
 {
@@ -2581,8 +2570,8 @@ static void io_wq_assign_next(struct io_wq_work **workptr, struct io_kiocb *nxt)
 {
 	struct io_kiocb *link;
 
-	io_prep_next_work(nxt, &link);
 	*workptr = &nxt->work;
+	link = io_prep_linked_timeout(req);
 	if (link) {
 		nxt->work.func = io_link_work_cb;
 		nxt->work.data = link;
-- 
2.24.0

