Return-Path: <io-uring+bounces-12239-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0DeSEI8Dk2nF0wEAu9opvQ
	(envelope-from <io-uring+bounces-12239-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 16 Feb 2026 12:46:23 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id ECDDF1431BC
	for <lists+io-uring@lfdr.de>; Mon, 16 Feb 2026 12:46:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 987233012BF5
	for <lists+io-uring@lfdr.de>; Mon, 16 Feb 2026 11:46:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 410201DDC1D;
	Mon, 16 Feb 2026 11:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DsyqvshD"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA9432D9EE7
	for <io-uring@vger.kernel.org>; Mon, 16 Feb 2026 11:46:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771242376; cv=none; b=T43uc5sjPm70OJIj0/GNhfaYQJD98Tnh6jpDMeelB80f2DB8sdUdJtofAmP/3UJs91M3w/cHpLwWNn14oir1MtcGtfRxAkgG8kCjB3T+wNcrNdjU0xz915Yotv3lzYlvRYoCpsvVcQ+RAmLZYLmvAB/Wxi7O7HX6pxQINknDzz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771242376; c=relaxed/simple;
	bh=ieQp+vvXqo1GP1mTLnYwoReQllVI90Xd5+PKr84WJmo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qwfXPNh9MvBhH+VTQwSrj3i4JiIL4VjIZV7yumlW3H9+mv5kBBvaK0rZKx1RzlNYRYBmLG+aGcepXbp3KPQkzZD+zkO7QolfhG1y8UooKZaKd27GEeFxdFlsKuD35FfCxPhFE22Tuspsj1rM9YjgdovPgfbrOKn+D0rF751Mde0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DsyqvshD; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-4359249bbacso3452306f8f.0
        for <io-uring@vger.kernel.org>; Mon, 16 Feb 2026 03:46:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771242372; x=1771847172; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DsHjkT44Ov3h+uSZg2E3H9+MeNSWOqhyCAo9pq7O6a0=;
        b=DsyqvshDu6MhqIFtknYGaWoMjVqJ67fdVvtxIDvMR90WVLWJUZSssMgKdBnjUzZuTf
         UDIgGhhkLBQFAxZ1e9Y61qWApzai0tTXVz7ELRZKDFo9BzIQIM7z9yBp6VsAz6q1zHgh
         W76FiUDXJDMIWth8TjxBUNWIFacjmKMCWa9ofW+pDSCjOx0/I+/H3DDC1eCdcFzTW107
         EV//W2JUUn76GmEelFlv0XpHRSmH+n/FsVFfDRJDKvlb0tDVbp0NcbmVlJv7uD7EDEzv
         z0Fw09xpov9PoTQuDGbahSURoT3sKcTLJ0+ToSSmctGn2027G8cBrMUaxFWHwnpVHL8X
         xJbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771242372; x=1771847172;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=DsHjkT44Ov3h+uSZg2E3H9+MeNSWOqhyCAo9pq7O6a0=;
        b=d7LR0wz8m72ITxmJs4K3Kd8TQACpEESLzN4RInAE66zWrlm/iHPWY3EoIIic7WSQI7
         opyP6DFJQBVPSQOOLZA5O5Ys+eFUx47idWZEhyP5Stt/GNGiMwYpPX8wdG2sax67209y
         RTwcfIYKSktKo3qSmZLerNMnOFtWyoOziJyy/KrmC4pKxCLDFpBct4mZ5Wjx6l6O4Cqc
         8dibbVMZCQhvADBGlGmgPjuENi1IDJZ6trVOjSctmk1gpgIbe+A9OsPRgrLxgLZLgLzf
         LHr/NuBT3v6gZ6fra20sy57f/Bkq0UoNJZCzAn+3zV9OCMUPp5vbXTjJapiaiMy9dONI
         thwQ==
X-Gm-Message-State: AOJu0Yx63hK95foJLvFrwSb5J+Q9Q16cRRXGz9Ew8tRyhhLGLfytAQNm
	0a4L0GeCLY4mYlwlEaBbKl9LpI4AxtyAqeR6AYBJdzWyzAMyULq8P747cKBCug==
X-Gm-Gg: AZuq6aJ1jBdNfMLNB4LIGNot2QQ87mUM+9lAcfptPgOg5b84CnWaIih0JJ5Z7lwmSQd
	2S813YwLQ4ePaXTm3GlTtUBK6UaS4zbsWOS4RRWnMlth03LlXn8QLuQxqZ4IzvdVkvI6dCcWZnk
	pq7lmG+fYuHXJXBf1kCB3uW3yCqeGomYcNiwSBpYT4Bz6Tz1S+4C+rBYGPyFMBydOOZnibIOkNz
	/kA/YQiTIFvTvCeKGVnY1kXQwc1PIXOjTeP4JmTUYW492Klsd9fCruUezU/OfWSQotDJJ3hlZ9m
	/mmOc+Jp/FQ6yTZYxZJP19p/IqqyI7iFpaQivr7K2eROOFCFzZ/bBG5pzMUFbSFKx2Y6Hsndez5
	zuM9FPbPy/JuHJvmpiAgJoJbdDQjfYt39sWzW5aJIjZlH9YKmrRnqVnLoVEIUOUTltYpcpM4K/h
	EXTL8tf/cnhg5547Ux04JkobF9N8RL0h3Vn0eXTBxupNUMbUpcwdEwH0HBo2kRYotW4zcwf8JBv
	5cSavls
X-Received: by 2002:a5d:5f87:0:b0:437:6b6e:d108 with SMTP id ffacd0b85a97d-4379d5e38b5mr14069265f8f.8.1771242371364;
        Mon, 16 Feb 2026 03:46:11 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:c3fa])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43796a5b4cdsm28991802f8f.8.2026.02.16.03.46.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Feb 2026 03:46:10 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk,
	Dylan Yudaken <dyudaken@gmail.com>
Subject: [PATCH 2/3] io_uring/zctx: move vec regbuf import into io_send_zc_import
Date: Mon, 16 Feb 2026 11:45:54 +0000
Message-ID: <a2422664639e10375fc08e949a2ab0fd78d8df2a.1771240334.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1771240334.git.asml.silence@gmail.com>
References: <cover.1771240334.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,kernel.dk];
	TAGGED_FROM(0.00)[bounces-12239-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCPT_COUNT_THREE(0.00)[4];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: ECDDF1431BC
X-Rspamd-Action: no action

Unify send and sendmsg zerocopy paths for importing registered buffers
and make io_send_zc_import() responsible for that. It's a preparation
patch making the next change simpler.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/net.c | 41 +++++++++++++++++++++++++----------------
 1 file changed, 25 insertions(+), 16 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 5f7f02e2c034..88962b18965e 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1439,17 +1439,34 @@ static int io_sg_from_iter(struct sk_buff *skb,
 	return ret;
 }
 
-static int io_send_zc_import(struct io_kiocb *req, unsigned int issue_flags)
+static int io_send_zc_import(struct io_kiocb *req,
+			     struct io_async_msghdr *kmsg,
+			     unsigned int issue_flags)
 {
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
-	struct io_async_msghdr *kmsg = req->async_data;
+	struct io_kiocb *notif = sr->notif;
+	int ret;
 
 	WARN_ON_ONCE(!(sr->flags & IORING_RECVSEND_FIXED_BUF));
 
-	sr->notif->buf_index = req->buf_index;
-	return io_import_reg_buf(sr->notif, &kmsg->msg.msg_iter,
-				(u64)(uintptr_t)sr->buf, sr->len,
-				ITER_SOURCE, issue_flags);
+	notif->buf_index = req->buf_index;
+
+	if (req->opcode == IORING_OP_SEND_ZC) {
+		ret = io_import_reg_buf(notif, &kmsg->msg.msg_iter,
+					(u64)(uintptr_t)sr->buf, sr->len,
+					ITER_SOURCE, issue_flags);
+	} else {
+		unsigned uvec_segs = kmsg->msg.msg_iter.nr_segs;
+
+		ret = io_import_reg_vec(ITER_SOURCE, &kmsg->msg.msg_iter,
+					notif, &kmsg->vec, uvec_segs,
+					issue_flags);
+	}
+
+	if (unlikely(ret))
+		return ret;
+	req->flags &= ~REQ_F_IMPORT_BUFFER;
+	return 0;
 }
 
 int io_send_zc(struct io_kiocb *req, unsigned int issue_flags)
@@ -1471,8 +1488,7 @@ int io_send_zc(struct io_kiocb *req, unsigned int issue_flags)
 		return -EAGAIN;
 
 	if (req->flags & REQ_F_IMPORT_BUFFER) {
-		req->flags &= ~REQ_F_IMPORT_BUFFER;
-		ret = io_send_zc_import(req, issue_flags);
+		ret = io_send_zc_import(req, kmsg, issue_flags);
 		if (unlikely(ret))
 			return ret;
 	}
@@ -1528,16 +1544,9 @@ int io_sendmsg_zc(struct io_kiocb *req, unsigned int issue_flags)
 	int ret, min_ret = 0;
 
 	if (req->flags & REQ_F_IMPORT_BUFFER) {
-		unsigned uvec_segs = kmsg->msg.msg_iter.nr_segs;
-		int ret;
-
-		sr->notif->buf_index = req->buf_index;
-		ret = io_import_reg_vec(ITER_SOURCE, &kmsg->msg.msg_iter,
-					sr->notif, &kmsg->vec, uvec_segs,
-					issue_flags);
+		ret = io_send_zc_import(req, kmsg, issue_flags);
 		if (unlikely(ret))
 			return ret;
-		req->flags &= ~REQ_F_IMPORT_BUFFER;
 	}
 
 	sock = sock_from_file(req->file);
-- 
2.52.0


