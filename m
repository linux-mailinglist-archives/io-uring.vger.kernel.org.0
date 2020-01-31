Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1358F14F475
	for <lists+io-uring@lfdr.de>; Fri, 31 Jan 2020 23:17:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726387AbgAaWQs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 31 Jan 2020 17:16:48 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:34862 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726180AbgAaWQr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 31 Jan 2020 17:16:47 -0500
Received: by mail-wr1-f65.google.com with SMTP id g17so10477371wro.2;
        Fri, 31 Jan 2020 14:16:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=6MeHJyDXmp1NZj7XQrK6TMcMB6wCFDU/56SpsuKEG+o=;
        b=Ua7KiMfS8pI32/zmiTMy+XKt0rIP7MqRqcHhVu5owfJsKX8bch8jPcSIVjufzOaCXt
         rUh+X3KL+E0ZjbCK84KnIWEC1run+hTYsU1DPhf5O1XEJOOfQIp76VhauPa/q+GhUbH0
         Aa0yBHoPLsLt5p/sNRex/bVct1Lxfb6YsYFfYSJGvee+Ho9zW3gYzBXocut5BHvLNhSc
         t8WAyq/iHJCkS+EIMr3sAM/HetypMJiCrs6kuAOFbk4HTUyAPoJR/FY6XD85CCV7CBzT
         6ocfL8mN055qnOLN4KXG9nKjRiyqA+dKpwBcwLKf/yE75MPoalIEerfs5mPFOUSw/+WN
         l8fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6MeHJyDXmp1NZj7XQrK6TMcMB6wCFDU/56SpsuKEG+o=;
        b=awxk6KvmDdXHTjvkUjIdQzgYgksi1KEmbF3c7LGrT8oIBFxIM3sLtq9QNuWlHxSrGY
         pEDJxoWVqhRrvL16DeHQcbDhotwIIm1YcfoX8UI+xxF9EPeIFe4Z3qR6LldbgJBhV7XZ
         RgqBDDceRjV3LPlTktuansDwYPxQOhaf9h7JCY0QVKldY7N3vaCc31XuJ59SrxI+T4Kb
         8/hZVSZSdLg4KsDwbr36FsP7jzhXKSr10svAW01jRV7CGlvGWbeKNJaNYbHQTT8v2hBk
         zs2ez33ZhQaYaauKAX7GSitHeymr9ilZkL8efgGVnZFCKqOrAv0oRAA7LVEUzbelK5cU
         xUGg==
X-Gm-Message-State: APjAAAVYjupw/msaHff8J21Hp/G8RMiERndTL+XCoMlQ2SSdXYAAqD3u
        2g1ixeBKIE53InFkXC+D+MP7Lyzi
X-Google-Smtp-Source: APXvYqwHHfp36sm1OsJ21wLh1FqsyBqBrTGOvf5K7CQkpIH5b6Lazb5ZcfzuMFqfPDlxuN/DZJ21+Q==
X-Received: by 2002:a5d:4ed0:: with SMTP id s16mr554556wrv.144.1580509005243;
        Fri, 31 Jan 2020 14:16:45 -0800 (PST)
Received: from localhost.localdomain ([109.126.145.157])
        by smtp.gmail.com with ESMTPSA id e6sm12328001wme.3.2020.01.31.14.16.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jan 2020 14:16:44 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 1/6] io_uring: always pass non-null io_submit_state
Date:   Sat,  1 Feb 2020 01:15:50 +0300
Message-Id: <d88bfd05c00ea072ddaced3a40226bfb29b611f7.1580508735.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1580508735.git.asml.silence@gmail.com>
References: <cover.1580508735.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

There is more harm than merit from conditionally passing
io_submit_state. Always pass non-null pointer. It shouldn't affect
performance, but even if so the gap will be closed by the following
commits. Also, in prepartion move plugging out of it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 33 ++++++++++++---------------------
 1 file changed, 12 insertions(+), 21 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 05b9fb0764e1..6f3998e6475a 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -579,8 +579,6 @@ struct io_kiocb {
 #define IO_IOPOLL_BATCH			8
 
 struct io_submit_state {
-	struct blk_plug		plug;
-
 	/*
 	 * io_kiocb alloc cache
 	 */
@@ -1166,11 +1164,7 @@ static struct io_kiocb *io_get_req(struct io_ring_ctx *ctx,
 	gfp_t gfp = GFP_KERNEL | __GFP_NOWARN;
 	struct io_kiocb *req;
 
-	if (!state) {
-		req = kmem_cache_alloc(req_cachep, gfp);
-		if (unlikely(!req))
-			goto fallback;
-	} else if (!state->free_reqs) {
+	if (!state->free_reqs) {
 		size_t sz;
 		int ret;
 
@@ -1813,9 +1807,6 @@ static void io_file_put(struct io_submit_state *state)
  */
 static struct file *io_file_get(struct io_submit_state *state, int fd)
 {
-	if (!state)
-		return fget(fd);
-
 	if (state->file) {
 		if (state->fd == fd) {
 			state->used_refs++;
@@ -4834,7 +4825,6 @@ static bool io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
  */
 static void io_submit_state_end(struct io_submit_state *state)
 {
-	blk_finish_plug(&state->plug);
 	io_file_put(state);
 	if (state->free_reqs)
 		kmem_cache_free_bulk(req_cachep, state->free_reqs,
@@ -4847,7 +4837,6 @@ static void io_submit_state_end(struct io_submit_state *state)
 static void io_submit_state_start(struct io_submit_state *state,
 				  unsigned int max_ios)
 {
-	blk_start_plug(&state->plug);
 	state->free_reqs = 0;
 	state->file = NULL;
 	state->ios_left = max_ios;
@@ -4913,7 +4902,8 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
 			  struct file *ring_file, int ring_fd,
 			  struct mm_struct **mm, bool async)
 {
-	struct io_submit_state state, *statep = NULL;
+	struct blk_plug plug;
+	struct io_submit_state state;
 	struct io_kiocb *link = NULL;
 	int i, submitted = 0;
 	bool mm_fault = false;
@@ -4931,10 +4921,9 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
 	if (!percpu_ref_tryget_many(&ctx->refs, nr))
 		return -EAGAIN;
 
-	if (nr > IO_PLUG_THRESHOLD) {
-		io_submit_state_start(&state, nr);
-		statep = &state;
-	}
+	io_submit_state_start(&state, nr);
+	if (nr > IO_PLUG_THRESHOLD)
+		blk_start_plug(&plug);
 
 	ctx->ring_fd = ring_fd;
 	ctx->ring_file = ring_file;
@@ -4943,7 +4932,7 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
 		const struct io_uring_sqe *sqe;
 		struct io_kiocb *req;
 
-		req = io_get_req(ctx, statep);
+		req = io_get_req(ctx, &state);
 		if (unlikely(!req)) {
 			if (!submitted)
 				submitted = -EAGAIN;
@@ -4976,7 +4965,7 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
 		req->needs_fixed_file = async;
 		trace_io_uring_submit_sqe(ctx, req->opcode, req->user_data,
 						true, async);
-		if (!io_submit_sqe(req, sqe, statep, &link))
+		if (!io_submit_sqe(req, sqe, &state, &link))
 			break;
 	}
 
@@ -4987,8 +4976,10 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
 	}
 	if (link)
 		io_queue_link_head(link);
-	if (statep)
-		io_submit_state_end(&state);
+
+	io_submit_state_end(&state);
+	if (nr > IO_PLUG_THRESHOLD)
+		blk_finish_plug(&plug);
 
 	 /* Commit SQ ring head once we've consumed and submitted all SQEs */
 	io_commit_sqring(ctx);
-- 
2.24.0

