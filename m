Return-Path: <io-uring+bounces-4582-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 34F3A9C32F3
	for <lists+io-uring@lfdr.de>; Sun, 10 Nov 2024 15:55:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BBAC11F2130D
	for <lists+io-uring@lfdr.de>; Sun, 10 Nov 2024 14:55:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B03E638FA6;
	Sun, 10 Nov 2024 14:55:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TsrBf3lS"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D32543A1BA
	for <io-uring@vger.kernel.org>; Sun, 10 Nov 2024 14:55:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731250544; cv=none; b=SYLSVqLM7bP9/vfSNx9lwl4yyF8/GHB15SwimgKFZjPivoaJvvPCguoqCEb7DnY1THdHTELIeiCwI6EVCPkfaV55DSEVe9HzAbOBzc6Mr/kDos/1O2kOIykLA7HPWzqgoEG6cEQr4VCVXtHOVDAeHfmGsGFzyK+QEtRA8g4fE9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731250544; c=relaxed/simple;
	bh=nKTClVBGhsX7zwCwaox4vBWPDBNgwgIEBPiBoPiSRTM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HlDaU6kWr9pSQU32e6F4FSxJaiG5bJ9m4Nm9jwWMp+8n3fWqle0CUJClVdR/I5b/aH5tJEaNEwcc77UYfpQBzwb84+gERSHulFqjc4eSwDaLk5I3Ax8vqha6kq0i2JgNKgoxBaefwq6L7kBXE5tW4mlPOjyIQa3ALUcZMCjF0L8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TsrBf3lS; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-37d4c482844so2536223f8f.0
        for <io-uring@vger.kernel.org>; Sun, 10 Nov 2024 06:55:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731250541; x=1731855341; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oN/036oZWg1nQl48c3sVtA0Ff5fx+R8e47nsnQGPmB0=;
        b=TsrBf3lSOVkVZro9ex53qvXBzZlJHYAjsFDjxVSlRx5H2EVGqXF22CD9dI0kCKjNJp
         GB7CgkWXkTPv/93k6HZALhdrLmYz9meut+y46hDWUinnLCPfj5x/IDxo0xOUzU8HCJW/
         tv+sSROmpYRybqD3diDUlamfFdWaen6rwGifV9alwv6JuBuH2fO++guqnTgtxPTOmG+n
         xGgZQcKpH+KyhWVUJ8/e0A/g4+Ki5MTdf9wJwksSSe1G54XZv/joUA2Bk9NTKym4hpqj
         BGGQX25gycnclwqjNUOPCOBLFJpCCFGaLgGiYQlU5z0KR7gxbuKe9Uk++NeuEU2/K9OA
         InpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731250541; x=1731855341;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oN/036oZWg1nQl48c3sVtA0Ff5fx+R8e47nsnQGPmB0=;
        b=HKMFFcxdN/Nl5o5OeSzaRb0H10eqn8N38TtXV9VUm791wrj0DMVsED18se2706Wy9b
         759idpg3yEOggvdOkSXVPkzW53qvtdV272EsF1a1pjdjGia2ZYihY6tP4lfLmOdH71E3
         2OcPy/TeDLu9DcAnY6OprcGIZJLb1FJ8wdRUBgYxtmZdMZmILjDUpRy5bphGdMwwfLth
         wwIfYY3nv1eAATL9uiU51YU3V0OsvdHnpBgQZqTPjAQZYgMB0ZvVIvJiDzuXB2MFM8p9
         e4D8nT/vj1V/pWrzyE6CZ8FfHbsZCaSycuIqmylUQOZPPfnrLF9Y6e8daXcRO5w+DmVV
         yeXQ==
X-Gm-Message-State: AOJu0YwoY2vXAaOhsUFqiHJpxd1IWD+47DjwVJTvxc0DbdfFyCkKvAux
	sU8FZYSBkiPPeLrdmlq1nfi4KF4IZ14vNbjNHFG5AM2bTK98BFxa5ZQgsA==
X-Google-Smtp-Source: AGHT+IHMtTRM/rssqmS0BRomNvXz9YfEGW3aupMAENcYewfPkSssM749yv0RQ/dhuX2iPeX1Sn69AQ==
X-Received: by 2002:a5d:648b:0:b0:37d:47ee:10d9 with SMTP id ffacd0b85a97d-381f1873485mr7798089f8f.34.1731250540857;
        Sun, 10 Nov 2024 06:55:40 -0800 (PST)
Received: from 127.0.0.1localhost ([85.255.234.98])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-432aa6beea6sm182445535e9.20.2024.11.10.06.55.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Nov 2024 06:55:40 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	Jens Axboe <axboe@kernel.dk>
Subject: [RFC 2/3] io_uring: add support for ignoring inline completions for waits
Date: Sun, 10 Nov 2024 14:56:21 +0000
Message-ID: <90bc3070b66b2a9f832716fd149184309ea6277d.1731205010.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <cover.1731205010.git.asml.silence@gmail.com>
References: <cover.1731205010.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jens Axboe <axboe@kernel.dk>

io_uring treats all completions the same - they post a completion event,
or more, and anyone waiting on event completions will see each event as
it gets posted.

However, some events may be more interesting that others. For a request
and response type model, it's not uncommon to have send/write events
that are submitted with a recv/read type of request. While the app does
want to see a successful send/write completion eventually, it need not
handle it upfront as it would want to do with a recv/read, as it isn't
time sensitive. Generally, a send/write completion will just mean that
a buffer can get recycled/reused, whereas a recv/read completion needs
acting upon (and a response sent).

This can be somewhat tricky to handle if many requests and responses
are being handled, and the app generally needs to track the number of
pending sends/writes to be able to sanely wait on just new incoming
recv/read requests. And even with that, an application would still
like to see a completion for a short/failed send/write immediately.

Add infrastructure to account inline completions, such that they can
be deducted from the 'wait_nr' being passed in via a submit_and_wait()
type of situation. Inline completions are ones that complete directly
inline from submission, such as a send to a socket where there's
enough space to accomodate the data being sent.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
[pavel: rebased onto iosets]
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/io_uring_types.h |  1 +
 include/uapi/linux/io_uring.h  |  4 ++++
 io_uring/io_uring.c            | 12 ++++++++++--
 io_uring/register.c            |  2 +-
 4 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 79f38c07642d..f04444f9356a 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -213,6 +213,7 @@ struct io_submit_state {
 	bool			need_plug;
 	bool			cq_flush;
 	unsigned short		submit_nr;
+	unsigned short		inline_completions;
 	struct blk_plug		plug;
 };
 
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 6a432383e7c3..e6d10fba8ae2 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -899,6 +899,10 @@ struct io_uring_recvmsg_out {
 	__u32 flags;
 };
 
+enum {
+	IOSQE_SET_F_HINT_IGNORE_INLINE		= 1,
+};
+
 struct io_uring_ioset_reg {
 	__u64 flags;
 	__u64 __resv[3];
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index cf688a9ff737..6e89435c243d 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1575,6 +1575,9 @@ void __io_submit_flush_completions(struct io_ring_ctx *ctx)
 		struct io_kiocb *req = container_of(node, struct io_kiocb,
 					    comp_list);
 
+		if (req->ioset->flags & IOSQE_SET_F_HINT_IGNORE_INLINE)
+			state->inline_completions++;
+
 		if (unlikely(req->flags & (REQ_F_CQE_SKIP | REQ_F_GROUP))) {
 			if (req->flags & REQ_F_GROUP) {
 				io_complete_group_req(req);
@@ -2511,6 +2514,7 @@ static void io_submit_state_start(struct io_submit_state *state,
 	state->plug_started = false;
 	state->need_plug = max_ios > 2;
 	state->submit_nr = max_ios;
+	state->inline_completions = 0;
 	/* set only head, no need to init link_last in advance */
 	state->link.head = NULL;
 	state->group.head = NULL;
@@ -3611,6 +3615,7 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 		size_t, argsz)
 {
 	struct io_ring_ctx *ctx;
+	int inline_complete = 0;
 	struct file *file;
 	long ret;
 
@@ -3676,6 +3681,7 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 			mutex_unlock(&ctx->uring_lock);
 			goto out;
 		}
+		inline_complete = ctx->submit_state.inline_completions;
 		if (flags & IORING_ENTER_GETEVENTS) {
 			if (ctx->syscall_iopoll)
 				goto iopoll_locked;
@@ -3713,8 +3719,10 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 
 			ret2 = io_get_ext_arg(ctx, flags, argp, &ext_arg);
 			if (likely(!ret2)) {
-				min_complete = min(min_complete,
-						   ctx->cq_entries);
+				if (min_complete > ctx->cq_entries)
+					min_complete = ctx->cq_entries;
+				else
+					min_complete += inline_complete;
 				ret2 = io_cqring_wait(ctx, min_complete, flags,
 						      &ext_arg);
 			}
diff --git a/io_uring/register.c b/io_uring/register.c
index e7571dc46da5..f87ec7b773bd 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -92,7 +92,7 @@ static int io_update_ioset(struct io_ring_ctx *ctx,
 {
 	if (!(ctx->flags & IORING_SETUP_IOSET))
 		return -EINVAL;
-	if (reg->flags)
+	if (reg->flags & ~IOSQE_SET_F_HINT_IGNORE_INLINE)
 		return -EINVAL;
 	if (reg->__resv[0] || reg->__resv[1] || reg->__resv[2])
 		return -EINVAL;
-- 
2.46.0


