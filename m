Return-Path: <io-uring+bounces-12765-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IEHmHDOTvWnY+wIAu9opvQ
	(envelope-from <io-uring+bounces-12765-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 20 Mar 2026 19:34:27 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 20FAD2DF7E1
	for <lists+io-uring@lfdr.de>; Fri, 20 Mar 2026 19:34:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1F684308CBEA
	for <lists+io-uring@lfdr.de>; Fri, 20 Mar 2026 18:28:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32A403E7144;
	Fri, 20 Mar 2026 18:28:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kiq1qhDH"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D93233E714B
	for <io-uring@vger.kernel.org>; Fri, 20 Mar 2026 18:28:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774031328; cv=none; b=qIFYRw/iyWhdXQlFqfA6R59zp9x+xLJGfWzsLn7LNkhX/7Gh8I6dgXPdxCN53l5ZBHFfWN5/UuVibreFsFqnhZozDnkGQOklTnYf9RqiJzgwMUPHzshHV6IVffWMVdNgUBYeIptVAtAli3vWfADf84IY/M56V24PN2zbZBYh2uw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774031328; c=relaxed/simple;
	bh=ROMfGYd1LZZDpizt5KvMI5Hvlep5QW6GFQbuJzEUyh0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hLjBdK+GorEw/HwTJWE8JDBgB03dI2K2mLPQD5+CKPUbmf2y6fXRb2HMmlnqKEi0q/ICNhI3EbcVlpocAQPixnyEV5qRWyk5NWvUHYro30yR9Fgl3ec5lVIwD/Yd7aflc55K6bSTSEVnYPHA+rMeshasA1TEWPv6IiETEid0R+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kiq1qhDH; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-486507134e4so27317535e9.0
        for <io-uring@vger.kernel.org>; Fri, 20 Mar 2026 11:28:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774031325; x=1774636125; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DdQSJEHFZ7rSPNbXPhY3/Q7gh3hfhmNkmSd9kla/fNA=;
        b=kiq1qhDHMxyv+TXqHSQ3/+VxQssA/c3hODQzoef8y1KceErs1PocrAL4N+qIeBYLYm
         JrhrPcIWk/1GHDmcGhb76FxEvKSt+21JUUa+hLEQ7WxoOmRMFn6etEHhH1FMJcQ6ae1s
         GhKYBp0hpZIvlMyoRQ06bUVlSxSEy05lARUSAqr6CbOfAc7F0/sIfI7f7hBHTzb7FNhO
         WjSI9SNIHnbNqGSjcgN7oLUcZDSe/rGzr5Jp4fvatg/wVfYpLG2GbmBMKX9qt39Myvab
         n4hy9B+UqQueaC3uFzHRc56epTRcNJJvBETW3hYX4ptHlXlrgNE6MJVjYn8f07U4mh3Y
         mQzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774031325; x=1774636125;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=DdQSJEHFZ7rSPNbXPhY3/Q7gh3hfhmNkmSd9kla/fNA=;
        b=WvYxQCKed9+P8sTBLRnOJUCeKAV6A+eoN60X+ThMayTS9qji5xSdWM5tr0ye8/HjMr
         s+TazA8ZVeMrZy+xn83NW0gA85RsIRii248goifyWWVGBx/x1xtHUkM1dINAHQbLfNnb
         JchEfQ57weO8icuae8qkJvCUwMtovfCb7hI/ASidWog/+EoK1Ypd+GPveIF+hDtFwmru
         F5T7XN2QviZuAW9hyA9ntXxAG8ak8uWJni9II+XyzN6K7GjwkA0oIQTCP7tFKM7vVWa/
         I34CvHF4BqPMlte04WkD64MK1AEWluhuloAUExhO90fbKgDb5oWJdzUofp02jdzdgCgo
         19Hg==
X-Gm-Message-State: AOJu0YwMvtz/EHAla9qlRjlCRXslhX3/W1Nm8BeXdJ+RPDQr/BbnSh74
	yQcw0/k3tO+w20sW2F/l9lrPrp0JCHRD7lWLUz3ZCHn9Epc+0mOSGOr6f5IFGnvFza4=
X-Gm-Gg: ATEYQzzd1QF0nnIwPs4HEPiNJbFAMQ9GkYoD9uSozM0lbgv3nT5bWNibmttw26cim+r
	sJmlKeWzyMaQP1sF8t/Gtr+4dcwWRFyxza4gsswceUpUtC3Bau+PBhpSX7fxSl7pm53u2KO9wff
	JAF7atvXQwflvj3Y2BN/ifC6hXMfi148xZaUGUqKscBMeBKWR4SKYKgz9j3dRe6nNrXZm+M2NOA
	kEN0HFGnbwp2UNJOOFWRCCuUsu2nZ+/Xddt9hERCtvhAtDDNLAE2m6TkejkcQ835vdf963/FBW7
	rMZpeOxtEvpAJuC87+3wxfXOXNYcZB76GDsR7kSbBrUlKe0yVVyAU72ZK64sUNZiO9S81wbxrur
	nQCO4Knsba0BJiYGM7Keuc6P8uKIYgzaPA8L0ub8GGFB9uLh8FAWDM68n3dGLpVFX1lmcr0y9mN
	eXN3xM0qUHvfPHvd9uIV2kjCEeIoTotdbvT5PDXZIwRDZ0K2uPYunbWK7Ipg==
X-Received: by 2002:a05:600c:5288:b0:485:3bb5:92cf with SMTP id 5b1f17b1804b1-486fedc9a5fmr66441895e9.12.1774031324726;
        Fri, 20 Mar 2026 11:28:44 -0700 (PDT)
Received: from ddp-thinkpad.tail20b0d.ts.net ([80.208.222.2])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-486fe7e2665sm92433725e9.6.2026.03.20.11.28.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Mar 2026 11:28:44 -0700 (PDT)
From: Daniele Di Proietto <daniele.di.proietto@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Keith Busch <kbusch@kernel.org>,
	Pavel Begunkov <asml.silence@gmail.com>,
	linux-fsdevel@vger.kernel.org,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Daniele Di Proietto <daniele.di.proietto@gmail.com>
Subject: [PATCH v2 1/2] io_uring: Extract io_file_get_fixed_node helper
Date: Fri, 20 Mar 2026 18:23:40 +0000
Message-ID: <20260320182341.780295-2-daniele.di.proietto@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260320182341.780295-1-daniele.di.proietto@gmail.com>
References: <20260320182341.780295-1-daniele.di.proietto@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TAGGED_FROM(0.00)[bounces-12765-lists,io-uring=lfdr.de];
	RCVD_COUNT_FIVE(0.00)[5];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[kernel.dk,kernel.org,gmail.com,vger.kernel.org,zeniv.linux.org.uk,suse.cz];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[danielediproietto@gmail.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[9];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.776];
	DKIM_TRACE(0.00)[gmail.com:+];
	TAGGED_RCPT(0.00)[io-uring];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 20FAD2DF7E1
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

This has two users and it's about to have a third in a future commit.

Reading io_slot_flags() and io_slot_file() outside of
io_ring_submit_lock() should be fine after a reference has been
acquired, as those are immutable.

Signed-off-by: Daniele Di Proietto <daniele.di.proietto@gmail.com>
---
 io_uring/io_uring.c | 20 ++++++++++++++++----
 io_uring/io_uring.h |  2 ++
 io_uring/splice.c   |  6 +-----
 3 files changed, 19 insertions(+), 9 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 9a37035e76c0..726245a28b87 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1553,22 +1553,34 @@ void io_wq_submit_work(struct io_wq_work *work)
 		io_req_task_queue_fail(req, ret);
 }
 
-inline struct file *io_file_get_fixed(struct io_kiocb *req, int fd,
-				      unsigned int issue_flags)
+inline struct io_rsrc_node *io_file_get_fixed_node(struct io_kiocb *req, int fd,
+						   unsigned int issue_flags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_rsrc_node *node;
-	struct file *file = NULL;
 
 	io_ring_submit_lock(ctx, issue_flags);
 	node = io_rsrc_node_lookup(&ctx->file_table.data, fd);
 	if (node) {
 		node->refs++;
+	}
+	io_ring_submit_unlock(ctx, issue_flags);
+
+	return node;
+}
+
+inline struct file *io_file_get_fixed(struct io_kiocb *req, int fd,
+				      unsigned int issue_flags)
+{
+	struct io_rsrc_node *node;
+	struct file *file = NULL;
+
+	node = io_file_get_fixed_node(req, fd, issue_flags);
+	if (node) {
 		req->file_node = node;
 		req->flags |= io_slot_flags(node);
 		file = io_slot_file(node);
 	}
-	io_ring_submit_unlock(ctx, issue_flags);
 	return file;
 }
 
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 0fa844faf287..1ed44201fa77 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -170,6 +170,8 @@ void __io_commit_cqring_flush(struct io_ring_ctx *ctx);
 
 unsigned io_linked_nr(struct io_kiocb *req);
 void io_req_track_inflight(struct io_kiocb *req);
+struct io_rsrc_node *io_file_get_fixed_node(struct io_kiocb *req, int fd,
+					    unsigned int issue_flags);
 struct file *io_file_get_normal(struct io_kiocb *req, int fd);
 struct file *io_file_get_fixed(struct io_kiocb *req, int fd,
 			       unsigned issue_flags);
diff --git a/io_uring/splice.c b/io_uring/splice.c
index e81ebbb91925..3c5021a46e79 100644
--- a/io_uring/splice.c
+++ b/io_uring/splice.c
@@ -60,22 +60,18 @@ static struct file *io_splice_get_file(struct io_kiocb *req,
 				       unsigned int issue_flags)
 {
 	struct io_splice *sp = io_kiocb_to_cmd(req, struct io_splice);
-	struct io_ring_ctx *ctx = req->ctx;
 	struct io_rsrc_node *node;
 	struct file *file = NULL;
 
 	if (!(sp->flags & SPLICE_F_FD_IN_FIXED))
 		return io_file_get_normal(req, sp->splice_fd_in);
 
-	io_ring_submit_lock(ctx, issue_flags);
-	node = io_rsrc_node_lookup(&ctx->file_table.data, sp->splice_fd_in);
+	node = io_file_get_fixed_node(req, sp->splice_fd_in, issue_flags);
 	if (node) {
-		node->refs++;
 		sp->rsrc_node = node;
 		file = io_slot_file(node);
 		req->flags |= REQ_F_NEED_CLEANUP;
 	}
-	io_ring_submit_unlock(ctx, issue_flags);
 	return file;
 }
 
-- 
2.43.0


