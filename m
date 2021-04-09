Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2DCC35977C
	for <lists+io-uring@lfdr.de>; Fri,  9 Apr 2021 10:17:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229803AbhDIIRs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 9 Apr 2021 04:17:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232170AbhDIIRs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 9 Apr 2021 04:17:48 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92853C061761
        for <io-uring@vger.kernel.org>; Fri,  9 Apr 2021 01:17:35 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id j5so3744585wrn.4
        for <io-uring@vger.kernel.org>; Fri, 09 Apr 2021 01:17:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=x/sUcHIjy6GH/QgPhH2HHQ3MAhGBh8Uk5B4W6hvhJbU=;
        b=l0XHeNFJNQCVvPBJMhXo1Z5uNzSShtAklOyu7Zh0o24+CWIEHXblArH6RgTyv9uONw
         JkA/lH2XjZEzP3nHipFRv56A7+F5bbUDJH7x3s21rKdP3FH0CN0k/DQYVXK0Q4d0Bvl9
         lGUlQGTyZYT4UeUAeo2ekkjfp+pexsB7puL1UhYDhg2jqH3ZXgyBKkq3G5Lpp1JRv+q+
         eNxmTosfdBk0LxKBjPAcDzWbnWWIhHTnmMCuQzqdbId3JRf3oGIATOztSXkFUy+nCNpG
         MIo/ivvIPhvV3uP47F1YvSnukoG7+OTdogk15tlE44TWOLQBciVc1Sd9ZphqeqF+ejyY
         DnjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=x/sUcHIjy6GH/QgPhH2HHQ3MAhGBh8Uk5B4W6hvhJbU=;
        b=CDRYCqi+RyTavZlcPdeugUZ3LLI0TN6YxspauZLNfxZjprYQmx1BInr38V3ckzgFbj
         VKT8TbH/N9WKefUuO6pOUPpSUHsEs5p9Epjkr5bzk/oX2gBQy/WDQi0ntIXg+KmjuFqt
         6N592ZZe8MnRrcRYIikCiGkU3L8cV24MIy4G1CumHzo2CS6ZTDGBgWTUANy7BMayRra0
         5WekNAObXEIr4jSQ88Cs0tUJivBiDM/FAVGxL5EzppBS6l6ZkV1I/F2gUb0Jo3D6BtvU
         9lpIig1868nRy5dzm9285WGZF2Eig2PE6oJqyaZSX5rSS59fabtAEi854ogOC0j2IWfs
         zyUw==
X-Gm-Message-State: AOAM532UnKXhGH5UzIH03acHupH2jq8A4EbvU7UialCCdQxMIW9KpmzN
        ICOshfe/GquXodDt1gJ9a1aH+vG0nhGYzg==
X-Google-Smtp-Source: ABdhPJymEVuhO9cBksyH0w7D5XxiVe5DmFCAM+ep4Znngsh9n4LNbk86oCPV0cV3ULqO63vKFhqtYA==
X-Received: by 2002:a5d:4dcb:: with SMTP id f11mr8762584wru.129.1617956254446;
        Fri, 09 Apr 2021 01:17:34 -0700 (PDT)
Received: from localhost.localdomain ([148.252.128.224])
        by smtp.gmail.com with ESMTPSA id d2sm3262133wrq.26.2021.04.09.01.17.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Apr 2021 01:17:34 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 1/3] io_uring: clean up io_poll_task_func()
Date:   Fri,  9 Apr 2021 09:13:19 +0100
Message-Id: <07902fdec3207f0e11ff8e73b6a16a4a24f7ebac.1617955705.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1617955705.git.asml.silence@gmail.com>
References: <cover.1617955705.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_poll_complete() always fills an event (even an overflowed one), so we
always should do io_cqring_ev_posted() afterwards. And that's what is
currently happening, because second EPOLLONESHOT check is always true,
it can't return !done for oneshots.

Remove those branching, it's much easier to read.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 81e5d156af1c..f662b81bdc22 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4907,20 +4907,18 @@ static void io_poll_task_func(struct callback_head *cb)
 	if (io_poll_rewait(req, &req->poll)) {
 		spin_unlock_irq(&ctx->completion_lock);
 	} else {
-		bool done, post_ev;
+		bool done;
 
-		post_ev = done = io_poll_complete(req, req->result, 0);
+		done = io_poll_complete(req, req->result, 0);
 		if (done) {
 			hash_del(&req->hash_node);
-		} else if (!(req->poll.events & EPOLLONESHOT)) {
-			post_ev = true;
+		} else {
 			req->result = 0;
 			add_wait_queue(req->poll.head, &req->poll.wait);
 		}
 		spin_unlock_irq(&ctx->completion_lock);
+		io_cqring_ev_posted(ctx);
 
-		if (post_ev)
-			io_cqring_ev_posted(ctx);
 		if (done) {
 			nxt = io_put_req_find_next(req);
 			if (nxt)
-- 
2.24.0

