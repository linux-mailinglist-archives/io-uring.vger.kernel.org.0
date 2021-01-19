Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56A642FBA81
	for <lists+io-uring@lfdr.de>; Tue, 19 Jan 2021 15:57:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391863AbhASOzs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 19 Jan 2021 09:55:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389412AbhASNik (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 19 Jan 2021 08:38:40 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0979EC061799
        for <io-uring@vger.kernel.org>; Tue, 19 Jan 2021 05:36:46 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id m187so10241019wme.2
        for <io-uring@vger.kernel.org>; Tue, 19 Jan 2021 05:36:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=S9BbKmM1G1kDOSSNGFqpsD26mfeCSV1FG6c7uGUAYko=;
        b=fZhmDyI+WqvfM0u71mBuTmifh+akpVCZwTFHeKXqdlD4u+vz33VfEv+odLG86ktLxd
         Kn8M3tbwab+Y0WR815tZMaYtZ99WUPOhoiOZIXJB7Af0mFawLRaUPmGM+4FJzeEsg5kT
         bhSAYhKMxFMOi2pmclZPW1lv5Jbt4VYQ7B0XenJxPzv1Uf4PLNQDolK5ulIj6ZXZ/qQZ
         nQRXsx7r06JLOkHntvHvBOTDn9V4TeXI2uQ9/h63DCs5nJCuLCyp2QocTPhjD5VK7Yh5
         C/EmRo1Ob6+VfdrpgnG1GjyTOXjUGzCpf4sw5ZsHtfz202lIkTjSbB3htNShAhk/bs0y
         1+Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=S9BbKmM1G1kDOSSNGFqpsD26mfeCSV1FG6c7uGUAYko=;
        b=qF5VuWSBugyW0GYmFdqXm2b6T5SvMXGFmCp6Wzu/QA0VxfuNbo6g+j4jQaEaMZNmP6
         b8jmiQv8bRvukeK3bsKWsM7kZPsfBkeczkCQg6HUKJ5+stFeCCYe1mRKe2iz3614NR/V
         FsV/0p7h3HwAxy7ud8bNrF5fc0HOf2oUC1wINkmNxtuVIwVNGhQsckv3NuAc9wGvmud8
         5qWdduCupJeCp/s1kmSZAZPbcArDAIQHur/3KRv2Q4K9kz+FhOrZfce/Z8dEwesCkboG
         7G0wYXZ0XGoFVXVG5wc/wY5eBEOoQz/OnyA/RiFNjj3/7/qY8uowbMDY7YDi2IqNyvCE
         DFeQ==
X-Gm-Message-State: AOAM53356tRRdXKzyBgwpk8DtnDG8hIHqcf1GboBrFnpj+140rZweWDG
        GJUgnUp807BSyR+q2vvKEds=
X-Google-Smtp-Source: ABdhPJw9AGpvUrNVFn2qHZVOP7gOeSqmT+tD3arZQN+dnTcJclrg6GRapuhpKJrkd7enuSXVGoTK4g==
X-Received: by 2002:a1c:f619:: with SMTP id w25mr4113785wmc.179.1611063404807;
        Tue, 19 Jan 2021 05:36:44 -0800 (PST)
Received: from localhost.localdomain ([85.255.234.152])
        by smtp.gmail.com with ESMTPSA id f68sm4988443wmf.6.2021.01.19.05.36.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jan 2021 05:36:44 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 14/14] io_uring: save atomic dec for inline executed reqs
Date:   Tue, 19 Jan 2021 13:32:47 +0000
Message-Id: <300674e8a1a53566f4ed10b0cafb44faf595d1be.1611062505.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1611062505.git.asml.silence@gmail.com>
References: <cover.1611062505.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

When a request is completed with comp_state, its completion reference
put is deferred to io_submit_flush_completions(), but the submission
is put not far from there, so do it together to save one atomic dec per
request. That targets requests that complete inline, e.g. buffered rw,
send/recv.

Proper benchmarking haven't been conducted but for nops(batch=32) it was
around 7901 vs 8117 KIOPS (~2.7%), or ~4% per perf profiling.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 1e46d471aa76..fb4e2a97e4f3 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -618,6 +618,7 @@ enum {
 	REQ_F_NO_FILE_TABLE_BIT,
 	REQ_F_WORK_INITIALIZED_BIT,
 	REQ_F_LTIMEOUT_ACTIVE_BIT,
+	REQ_F_COMPLETE_INLINE_BIT,
 
 	/* not a real bit, just to check we're not overflowing the space */
 	__REQ_F_LAST_BIT,
@@ -661,6 +662,8 @@ enum {
 	REQ_F_WORK_INITIALIZED	= BIT(REQ_F_WORK_INITIALIZED_BIT),
 	/* linked timeout is active, i.e. prepared by link's head */
 	REQ_F_LTIMEOUT_ACTIVE	= BIT(REQ_F_LTIMEOUT_ACTIVE_BIT),
+	/* completion is deferred through io_comp_state */
+	REQ_F_COMPLETE_INLINE	= BIT(REQ_F_COMPLETE_INLINE_BIT),
 };
 
 struct async_poll {
@@ -1899,14 +1902,15 @@ static void io_submit_flush_completions(struct io_comp_state *cs)
 		 * io_free_req() doesn't care about completion_lock unless one
 		 * of these flags is set. REQ_F_WORK_INITIALIZED is in the list
 		 * because of a potential deadlock with req->work.fs->lock
+		 * We defer both, completion and submission refs.
 		 */
 		if (req->flags & (REQ_F_FAIL_LINK|REQ_F_LINK_TIMEOUT
 				 |REQ_F_WORK_INITIALIZED)) {
 			spin_unlock_irq(&ctx->completion_lock);
-			io_put_req(req);
+			io_double_put_req(req);
 			spin_lock_irq(&ctx->completion_lock);
 		} else {
-			io_put_req(req);
+			io_double_put_req(req);
 		}
 	}
 	io_commit_cqring(ctx);
@@ -1922,8 +1926,7 @@ static void io_req_complete_state(struct io_kiocb *req, long res,
 	io_clean_op(req);
 	req->result = res;
 	req->compl.cflags = cflags;
-	list_add_tail(&req->compl.list, &cs->list);
-	cs->nr++;
+	req->flags |= REQ_F_COMPLETE_INLINE;
 }
 
 static inline void __io_req_complete(struct io_kiocb *req, long res,
@@ -6537,9 +6540,9 @@ static void __io_queue_sqe(struct io_kiocb *req, struct io_comp_state *cs)
 			io_queue_linked_timeout(linked_timeout);
 	} else if (likely(!ret)) {
 		/* drop submission reference */
-		if (cs) {
-			io_put_req(req);
-			if (cs->nr >= 32)
+		if (req->flags & REQ_F_COMPLETE_INLINE) {
+			list_add_tail(&req->compl.list, &cs->list);
+			if (++cs->nr >= 32)
 				io_submit_flush_completions(cs);
 			req = NULL;
 		} else {
-- 
2.24.0

