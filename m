Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAAA440BBAD
	for <lists+io-uring@lfdr.de>; Wed, 15 Sep 2021 00:35:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235825AbhINWgp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Sep 2021 18:36:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235464AbhINWg3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Sep 2021 18:36:29 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 403DFC0613D9
        for <io-uring@vger.kernel.org>; Tue, 14 Sep 2021 15:35:11 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id d21so643860wra.12
        for <io-uring@vger.kernel.org>; Tue, 14 Sep 2021 15:35:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HZo/ZeJp31CR43d/9BybAMPl+IS1ufGUfYdoyLTDmEQ=;
        b=Ar63n343SICx+HhhXTLTqEgBRqNf7QbSKibQvZJXA5EYtHs06XqR4khT9C7AcW0ibM
         j5OBAlhITm/lxd3mBeniY47vntqtPwUskk3Jr8w588SO77x6kFE/1OldogIAkmSX4nYI
         Mev5W42eu6F6Ss2I+sVzwLBO0NvP9lRM2jJOJ1VjXM2WRrxrdRiCm0URbh0rpsJFPne9
         clmKdOrD9zVx9UwF0v2VbNk3G/eo5fNweAFYf4nZlkYISG7eVbGFBHCwINaKaVPotLdd
         8F8lTxcZd+jH0R3JKeVGb5gfieQmJjeBRdQCnsrkA8Wr4i7g89hjuGKrQpCpeJ3Pc0ff
         L99g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HZo/ZeJp31CR43d/9BybAMPl+IS1ufGUfYdoyLTDmEQ=;
        b=xLCM6/rP51qmiDar9/nTGKFQTViwiN6uQYFBpoL7g+PbvtjHzWTeSrbq8Go8gL7l42
         L/3Lo9ijGC2aWx1qjwjqjaWMGRVRLkmM3F4Xb0bCvMyNv2wG/hOdKRn/SNtUa/o7wsJK
         fobM/oWpCZnrPvv0EGa+V6TIqgYFbkRT/2ZDI7qLEbqgyMKqopjTiF7Tr+x4CJq2Fh09
         TJYxd1BnIQvffWCvNLmcHAf22rQ2i6Y9Ulb36Yj6YiLBfDyNgxehs3kPK4MR70GjAdMc
         LEW/7ebp4S+wH0z1Jmzg7jiUMfwEHUkbITJsppueXOLzz85quqS3/9x8kJC0ErKfy9bn
         SPJQ==
X-Gm-Message-State: AOAM533B3lVs7QnJBc5a2P/4/larCVld884k3BMMBHmgwtc8o+L8JFCu
        F9fwVjL9H8wl0uc3/1AKo+EmMpzZHM0=
X-Google-Smtp-Source: ABdhPJwvC+Dny91DpKBb3ryAr199yEOktM3fbhvpL2NnM/YAsyxLSFOXnLTksNyDln7rnS2WVWjTmQ==
X-Received: by 2002:a5d:4b0b:: with SMTP id v11mr1478081wrq.359.1631658909694;
        Tue, 14 Sep 2021 15:35:09 -0700 (PDT)
Received: from localhost.localdomain ([185.69.144.239])
        by smtp.gmail.com with ESMTPSA id m4sm2505665wml.28.2021.09.14.15.35.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 15:35:09 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH] io_uring: move iopoll reissue into regular IO path
Date:   Tue, 14 Sep 2021 23:34:25 +0100
Message-Id: <09c645bdf78117a5933490aff0eea10c4f1ceb0a.1631658805.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

230d50d448acb ("io_uring: move reissue into regular IO path")
made non-IOPOLL I/O to not retry from ki_complete handler. Follow it
steps and do the same for IOPOLL. Same problems, same implementation,
same -EAGAIN assumptions.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---

Needs more testing and with NVMe. It's on top of io_uring-5.15 for now,
we'll be rebased on whatever is needed after we're happy with everything

 fs/io_uring.c | 23 +++++------------------
 1 file changed, 5 insertions(+), 18 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index f6fae01c039c..7fb5f2acd274 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -736,7 +736,6 @@ enum {
 	REQ_F_BUFFER_SELECTED_BIT,
 	REQ_F_COMPLETE_INLINE_BIT,
 	REQ_F_REISSUE_BIT,
-	REQ_F_DONT_REISSUE_BIT,
 	REQ_F_CREDS_BIT,
 	REQ_F_REFCOUNT_BIT,
 	REQ_F_ARM_LTIMEOUT_BIT,
@@ -783,8 +782,6 @@ enum {
 	REQ_F_COMPLETE_INLINE	= BIT(REQ_F_COMPLETE_INLINE_BIT),
 	/* caller should reissue async */
 	REQ_F_REISSUE		= BIT(REQ_F_REISSUE_BIT),
-	/* don't attempt request reissue, see io_rw_reissue() */
-	REQ_F_DONT_REISSUE	= BIT(REQ_F_DONT_REISSUE_BIT),
 	/* supports async reads */
 	REQ_F_NOWAIT_READ	= BIT(REQ_F_NOWAIT_READ_BIT),
 	/* supports async writes */
@@ -2428,14 +2425,6 @@ static void io_iopoll_complete(struct io_ring_ctx *ctx, unsigned int *nr_events,
 	while (!list_empty(done)) {
 		req = list_first_entry(done, struct io_kiocb, inflight_entry);
 		list_del(&req->inflight_entry);
-
-		if (READ_ONCE(req->result) == -EAGAIN &&
-		    !(req->flags & REQ_F_DONT_REISSUE)) {
-			req->iopoll_completed = 0;
-			io_req_task_queue_reissue(req);
-			continue;
-		}
-
 		__io_fill_cqe(ctx, req->user_data, req->result,
 			      io_put_rw_kbuf(req));
 		(*nr_events)++;
@@ -2699,10 +2688,9 @@ static void io_complete_rw_iopoll(struct kiocb *kiocb, long res, long res2)
 	if (kiocb->ki_flags & IOCB_WRITE)
 		kiocb_end_write(req);
 	if (unlikely(res != req->result)) {
-		if (!(res == -EAGAIN && io_rw_should_reissue(req) &&
-		    io_resubmit_prep(req))) {
-			req_set_fail(req);
-			req->flags |= REQ_F_DONT_REISSUE;
+		if (res == -EAGAIN && io_rw_should_reissue(req)) {
+			req->flags |= REQ_F_REISSUE;
+			return;
 		}
 	}
 
@@ -2916,7 +2904,6 @@ static void kiocb_done(struct kiocb *kiocb, ssize_t ret,
 {
 	struct io_kiocb *req = container_of(kiocb, struct io_kiocb, rw.kiocb);
 	struct io_async_rw *io = req->async_data;
-	bool check_reissue = kiocb->ki_complete == io_complete_rw;
 
 	/* add previously done IO, if any */
 	if (io && io->bytes_done > 0) {
@@ -2928,12 +2915,12 @@ static void kiocb_done(struct kiocb *kiocb, ssize_t ret,
 
 	if (req->flags & REQ_F_CUR_POS)
 		req->file->f_pos = kiocb->ki_pos;
-	if (ret >= 0 && check_reissue)
+	if (ret >= 0 && (kiocb->ki_complete == io_complete_rw))
 		__io_complete_rw(req, ret, 0, issue_flags);
 	else
 		io_rw_done(kiocb, ret);
 
-	if (check_reissue && (req->flags & REQ_F_REISSUE)) {
+	if (req->flags & REQ_F_REISSUE) {
 		req->flags &= ~REQ_F_REISSUE;
 		if (io_resubmit_prep(req)) {
 			io_req_task_queue_reissue(req);
-- 
2.33.0

