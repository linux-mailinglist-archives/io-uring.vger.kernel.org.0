Return-Path: <io-uring+bounces-12777-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id AHlBGFUov2mDxAMAu9opvQ
	(envelope-from <io-uring+bounces-12777-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sun, 22 Mar 2026 00:23:01 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id D7DA52E7A27
	for <lists+io-uring@lfdr.de>; Sun, 22 Mar 2026 00:23:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 73EE0301C8B2
	for <lists+io-uring@lfdr.de>; Sat, 21 Mar 2026 23:22:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F40C92E9730;
	Sat, 21 Mar 2026 23:22:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bR8yaP1s"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A21752D979C
	for <io-uring@vger.kernel.org>; Sat, 21 Mar 2026 23:22:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774135355; cv=none; b=O+TIAv81S8/JBqodTlYUvNwQ+8lvII7sILOLwMhMdiYO1/vyCJVwl9RdC394y+RFOzew7fGOCqRY5Gq5/tFSc0wOmdKYXroqI5gp67Q06k0QUgthWNfrpWlz4hKWRpqGjh9M+9ba9jZ0Q/UH2T9CGCQbFZY3ira5tmfLFXdtv8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774135355; c=relaxed/simple;
	bh=ROMfGYd1LZZDpizt5KvMI5Hvlep5QW6GFQbuJzEUyh0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wru401iXs4MsmKZ+aXIXcEslaHjIUaaMmUKgEAGEpDq21Zk3wpbo59Q5NEs8VnO5f1ZpAhPZCgU7STF7zMkLm1toctbvpbEzu6q2+VVjKCZI9ZmNxs8TmyzgSdkeQEFyCt9U+6F3/bNBzMUEUXjZ5q6qGbB8lvfb7DfoHlc8WyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bR8yaP1s; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-43b48ac2727so2344790f8f.3
        for <io-uring@vger.kernel.org>; Sat, 21 Mar 2026 16:22:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774135353; x=1774740153; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DdQSJEHFZ7rSPNbXPhY3/Q7gh3hfhmNkmSd9kla/fNA=;
        b=bR8yaP1s+30hVqzDknmHx/kh56jaPd84wibErsEx96LwlnZPi1juWosuGXrdt0xa6i
         Qw1zv0Uyioxh7wzz25KwFbU4b6c16K3ak6dQC1LyEDnC1SZk+XmRe4OxWwEqXrIpQ4QW
         UO+PDYmDaXRw4+ZE50BuTgmlpoqyFEPCEKz4bCDRDWlFveAE1TSYQfta3ZCDrsZJ8yUJ
         fqPEON+Lm7VVIJmbJyL6XIiM8tnBd/NlmTXO8bKmeI7QP+Tu8LnXyj8FWlaP4/DcTVpo
         /ScZRPv6eDh74J0Jwjyd7FIv52L08MiL4xLSR01k2VERuPLQCLV/4aMl759pmgYK63u5
         uE9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774135353; x=1774740153;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=DdQSJEHFZ7rSPNbXPhY3/Q7gh3hfhmNkmSd9kla/fNA=;
        b=rTiCgAvQNFmjeAHZNpFi715AxYdjsp+dDUW14mN5tfv1XvzVIHElOqMegUOQ67zMVk
         QAY09vh91vKt8N3/QzRo4UwsKLcaCsuONSgT8kSmGnLJLybAigErHGdSJq4JyZtdZB68
         z2Wi2A2Sf54pgJHkF1vwp/UM1Ii9oQZZs7dtqJkxSr1iolcq2PFljTcSbYmiVMchW3QC
         is8r3oeRCTWgtpRBnBEB377qBmAXrG99caLTHUZ8lx3Izp9xmjkKS6H/sjBcCVt3DV+W
         wFKCKuXF2EVd6C+5+Wb1CyqJse2svJuHHRPjOHE/UXXN00kx9rK3eXj9rrVynmL6K9v3
         jI6A==
X-Gm-Message-State: AOJu0YxvSsxcaexTonqHtdXnDFSnMcftlF+pY4GXxreYJxaLoc4m47SE
	+YFWvMdGamOEEcIj0d2mx8bIbNZ5IqGQA2f7SQ8cglK4tI3iOXYY1XhAsqPi4elxej4=
X-Gm-Gg: ATEYQzynatm64plXkls8UfdXrIDoNLNw/kmXIUq6klAtACjwnsEA5xEugw/DalJe573
	lTsyIF2K31NbFv8g6t/MBjl/yqGf49lbPximm/q+e4jd80+z/GqmClreipdZe6MExshEik4ephy
	ztGDVaqjcBKZaPPL7pbCBG8R+yah+dkGXQ8QHcyhf5vG2FjB4xqWffaUhzIx12z/3vR2NAvxOK5
	Rud22YcVgVu7up0wrJBSDxgzQQamQFjugA+R8qtVfSrxaqid85Su5CYp+MPWONUJOiQQpPNHDBt
	0ABTn9Osg8a6RcdTTPZ2WOxwvofW9phMn79ryZhIXQT9hniRt+4fMtwgkkLO1e4Pf/LSOlBbdsD
	giKXhg3XndGgXlI/B9n+Xmgd0aahBq/lsOa5q7WBE6DG1oP4bagVCApJhiHUuRwaNQB/CiiRu1q
	Jh+IOIQDUJzUyFC7wHP7wPvjr4qBEWp+uCywb2iUGEh8eZt7+RR+QD5S+WNw8=
X-Received: by 2002:a05:6000:2f84:b0:43b:4d2e:a004 with SMTP id ffacd0b85a97d-43b64242f00mr11258972f8f.10.1774135352711;
        Sat, 21 Mar 2026 16:22:32 -0700 (PDT)
Received: from ddp-thinkpad.tail20b0d.ts.net ([95.141.20.197])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43b6425eeb4sm15609897f8f.0.2026.03.21.16.22.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Mar 2026 16:22:32 -0700 (PDT)
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
Subject: [PATCH v3 1/4] io_uring: Extract io_file_get_fixed_node() helper
Date: Sat, 21 Mar 2026 23:21:39 +0000
Message-ID: <20260321232142.911280-2-daniele.di.proietto@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260321232142.911280-1-daniele.di.proietto@gmail.com>
References: <20260321232142.911280-1-daniele.di.proietto@gmail.com>
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
	TAGGED_FROM(0.00)[bounces-12777-lists,io-uring=lfdr.de];
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
	NEURAL_HAM(-0.00)[-1.000];
	DKIM_TRACE(0.00)[gmail.com:+];
	TAGGED_RCPT(0.00)[io-uring];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: D7DA52E7A27
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


