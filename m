Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D00B9357940
	for <lists+io-uring@lfdr.de>; Thu,  8 Apr 2021 02:59:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229968AbhDHA7K (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 7 Apr 2021 20:59:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbhDHA7J (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 7 Apr 2021 20:59:09 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA87AC061761
        for <io-uring@vger.kernel.org>; Wed,  7 Apr 2021 17:58:57 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id 12so329581wmf.5
        for <io-uring@vger.kernel.org>; Wed, 07 Apr 2021 17:58:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=fLZ0eRwT5qLyXjZvlBJLo7B//SsRqsqrw9ZqxvUu+Sw=;
        b=SwBwea7Et8Z/LdgTydVXPWOHWqCX4vhNW7t6M1MX3VqUEuN9MVCCiNYfqCI/+OlajM
         nEhNlrwwVZuGre1fACIad0kZ7BT0hKEKfQetUx+sU366fpUON8yMwTetN/uGoHKz+i1e
         NUGYLaC9asExiEmANvXPUCex6faG1KmLAkdCM5oP2zBONpx3pQVE9NFFegfVuXfrqzHG
         Bb8rBbP9fNIkL4UzQjZyzAmmLmkXtLFIJP+VXOsRltG5VibCdm1mT9JslcSodpA0ZRLl
         NmCpILGBVt/r5nWhZ8ALjNzOo84FmZHWm5gEWZx023Od3m/u5MUsRD3cLcw1k9fDIqIT
         YybA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fLZ0eRwT5qLyXjZvlBJLo7B//SsRqsqrw9ZqxvUu+Sw=;
        b=MuUZCG/Q02S6yorusdCzOwvwc6BgZ64/77sVr2dWLmM9hN8Wz25QPjj4FyQnO5HhgT
         VNjCUqUhPXSsjtyGuiJgWjIKSIG12x3/u2hLt3jVLFhHFHx6/ppLWd97/LdV6YYPGS8l
         Ck1h/WDSl4XAdprgwcgRxEcaDsNZHNWt1DIjOiRiWXuU5DOmuh+AnBih8WeYSToZTwh0
         IDIhFtj6erbFjs0HIy36h+nPsVZTirYEVMpkO1vDj9+FsuSo2pqBP+UcvIBklJudbvf6
         gt46BnKE2uiD5Daxh9veXlbr4JVVniiQ6aZg31dPq4syGBnp5zBNptez48io6S7GGjaf
         iCiw==
X-Gm-Message-State: AOAM532dXDADzbjEfxSb14yIHC+DYluXaynyXO8zOz5GH6goomYgMdoJ
        tZOd/yP6sMGXcgnwKjlHedeTymWoNRuXWQ==
X-Google-Smtp-Source: ABdhPJz8QQOBt5ro3xosPrcmtziaMRJQj5iYcM7JcF/j5Ba6a27i94BovhqKUeS/0QpsGg6SR4vKCA==
X-Received: by 2002:a05:600c:4107:: with SMTP id j7mr5549359wmi.25.1617843536466;
        Wed, 07 Apr 2021 17:58:56 -0700 (PDT)
Received: from localhost.localdomain ([148.252.132.202])
        by smtp.gmail.com with ESMTPSA id s9sm12219287wmh.31.2021.04.07.17.58.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Apr 2021 17:58:56 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 2/4] io_uring: fix rw req completion
Date:   Thu,  8 Apr 2021 01:54:40 +0100
Message-Id: <f602250d292f8a84cca9a01d747744d1e797be26.1617842918.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1617842918.git.asml.silence@gmail.com>
References: <cover.1617842918.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

WARNING: at fs/io_uring.c:8578 io_ring_exit_work.cold+0x0/0x18

As reissuing is now passed back by REQ_F_REISSUE, kiocb_done() may just
set the flag and do nothing leaving dangling requests. The handling is a
bit fragile, e.g. can't just complete them because the case of reading
beyond file boundary needs blocking context to return 0, otherwise it
may be -EAGAIN.

Go the easy way for now, just emulate how it was by io_rw_reissue() in
kiocb_done()

Fixes: 230d50d448ac ("io_uring: move reissue into regular IO path")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index f1881ac0744b..de5822350345 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2762,6 +2762,7 @@ static void kiocb_done(struct kiocb *kiocb, ssize_t ret,
 {
 	struct io_kiocb *req = container_of(kiocb, struct io_kiocb, rw.kiocb);
 	struct io_async_rw *io = req->async_data;
+	bool check_reissue = (kiocb->ki_complete == io_complete_rw);
 
 	/* add previously done IO, if any */
 	if (io && io->bytes_done > 0) {
@@ -2777,6 +2778,11 @@ static void kiocb_done(struct kiocb *kiocb, ssize_t ret,
 		__io_complete_rw(req, ret, 0, issue_flags);
 	else
 		io_rw_done(kiocb, ret);
+
+	if (check_reissue && req->flags & REQ_F_REISSUE) {
+		req->flags &= ~REQ_F_REISSUE;
+		io_rw_reissue(req);
+	}
 }
 
 static int io_import_fixed(struct io_kiocb *req, int rw, struct iov_iter *iter)
-- 
2.24.0

