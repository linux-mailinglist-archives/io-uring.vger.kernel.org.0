Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E4443223F3
	for <lists+io-uring@lfdr.de>; Tue, 23 Feb 2021 03:00:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229999AbhBWCAe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 22 Feb 2021 21:00:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230099AbhBWCAa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 22 Feb 2021 21:00:30 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0857AC06178A
        for <io-uring@vger.kernel.org>; Mon, 22 Feb 2021 17:59:50 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id b3so20988928wrj.5
        for <io-uring@vger.kernel.org>; Mon, 22 Feb 2021 17:59:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=pRj6Oxyt8WcxzX7lULLOwOGFt4IvfucoNQvtZc4mKh0=;
        b=dBIN+m8AS/9+4naJHXGP6wy+UfVXbHc48jsXl9RLpLLour3RuwYk8NB1DHwZ56TVCm
         Huy5j643qmPMfVX3invI6L442ajDB/yCyj6St9fivTxiNsazMWJmBsNAaDhG8WLiDRbT
         GA8aCEfRtfuZQ6geUP1KOaCueDeNc15uF/OUvORcgP2oY95/U7eRKxQ81htQg7nEZ7aw
         iIMNs5eKMfH3ObxVyoTbYGA5gjQzBoBWl/aaEsThE4dJd5BmhDOaSIt8QhiNro+Jk+nH
         M2sh7mIBZxsd/itpRoDP5Y0bnVaDCIgDlciOBKEaDUdAoSpFJtZZkAV9F9ahP68HTdVy
         tmlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pRj6Oxyt8WcxzX7lULLOwOGFt4IvfucoNQvtZc4mKh0=;
        b=t2wbDDVA7xvDj7FVKY6aZUIYxvEjWycJyNFyMYXYfnFhgUj5aW4UyIY0GPD14aShwY
         Hwuaf+pN7KdchknxPwT2iy0udTbYFEDfTBjG6O4B5lhZ2GbbcGwUupReiSgl6Raid9dM
         nf489y9vbdQiFGflreAFAGD/UlK1xwobIBGF/RMZNaNiD+LrLDtPCHtqXp7kSeUT6T/i
         9MVAgAlYCFxNdVp2vFZsbdpwlEWe/arG/zDHAcLXCeMyMkH2dPjliO4CzfEQNbi1fqbx
         UfMNbnm+9FyRf6oSKH5RYmLU5ijKwUk5qvlTvqUaxswP4bpI9iJGZLDiWhloyKDP1Z4G
         HDQA==
X-Gm-Message-State: AOAM532mzedbJusy4P6MTtXFhcRbrnuR9aOBk9W/npRvyBh2WUlk+7V2
        eh761VdkJu9yO3ItDKpv2AA=
X-Google-Smtp-Source: ABdhPJy8PzEWJDc4pimVa67F1NTajw0dPLUZ3a2wzrQpnsrloxqcgcZBkiFTLfTSEp0KcgJrQNWMBQ==
X-Received: by 2002:a5d:6ac3:: with SMTP id u3mr4495588wrw.361.1614045588871;
        Mon, 22 Feb 2021 17:59:48 -0800 (PST)
Received: from localhost.localdomain ([148.252.132.56])
        by smtp.gmail.com with ESMTPSA id 4sm32425501wrr.27.2021.02.22.17.59.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Feb 2021 17:59:48 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 03/13] io_uring: reuse io_req_task_queue_fail()
Date:   Tue, 23 Feb 2021 01:55:38 +0000
Message-Id: <f654607fd5fbcbabecbd81b74a2fea2d14fe5b98.1614045169.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1614045169.git.asml.silence@gmail.com>
References: <cover.1614045169.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Use io_req_task_queue_fail() on the fail path of io_req_task_queue().
It's unlikely to happen, so don't care about additional overhead, but
allows to keep all the req->result invariant in a single function.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 2d66d0afc6c0..aa2ad863af96 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2036,25 +2036,21 @@ static void io_req_task_submit(struct callback_head *cb)
 	__io_req_task_submit(req);
 }
 
-static void io_req_task_queue(struct io_kiocb *req)
+static void io_req_task_queue_fail(struct io_kiocb *req, int ret)
 {
-	int ret;
+	req->result = ret;
+	req->task_work.func = io_req_task_cancel;
 
-	req->task_work.func = io_req_task_submit;
-	ret = io_req_task_work_add(req);
-	if (unlikely(ret)) {
-		req->result = -ECANCELED;
+	if (unlikely(io_req_task_work_add(req)))
 		io_req_task_work_add_fallback(req, io_req_task_cancel);
-	}
 }
 
-static void io_req_task_queue_fail(struct io_kiocb *req, int ret)
+static void io_req_task_queue(struct io_kiocb *req)
 {
-	req->result = ret;
-	req->task_work.func = io_req_task_cancel;
+	req->task_work.func = io_req_task_submit;
 
 	if (unlikely(io_req_task_work_add(req)))
-		io_req_task_work_add_fallback(req, io_req_task_cancel);
+		io_req_task_queue_fail(req, -ECANCELED);
 }
 
 static inline void io_queue_next(struct io_kiocb *req)
-- 
2.24.0

