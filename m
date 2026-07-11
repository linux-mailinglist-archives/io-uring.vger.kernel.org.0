Return-Path: <io-uring+bounces-13959-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id ucz6KrgdUmqOMAMAu9opvQ
	(envelope-from <io-uring+bounces-13959-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2026 12:40:56 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id A0031741403
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2026 12:40:55 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KyHrPPTE;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13959-lists+io-uring=lfdr.de@vger.kernel.org" designates 104.64.211.4 as permitted sender) smtp.mailfrom="io-uring+bounces-13959-lists+io-uring=lfdr.de@vger.kernel.org";
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 929F630091E1
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2026 10:40:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B31E3BADA7;
	Sat, 11 Jul 2026 10:40:38 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81CE43BB9F1
	for <io-uring@vger.kernel.org>; Sat, 11 Jul 2026 10:40:36 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783766438; cv=none; b=Wg8odS3uMnR/ViSoQhz4cqX7AJDPMESuuPBFGNa2O4aruou6z8GdkQv56Ilj2VKrWLp3qcKW9gFCzFZDzGP7pBITWE44+MQ9++Q+/+1+scSX28txvbbi+8TAEYRMRJ99WL6dzxWwp91ytH5Ah7iWLgPEGLXL++DAKEjUkKtnHzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783766438; c=relaxed/simple;
	bh=9u/CgzNLweE2bHe16o0shDoOVpp7jtVmWikbjcRPcwc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yl5uQ3jIuiojExh5HCsz3hhhIHZqRgYryyQx2/LAaAUAQGT9CmylG6+CsFWeTtMiQJr6tNvRsqoaGUtco7LnX3NH48g+GE/w/T2zVrB9/fJRcGSlNiCuKjiu3EPmg5n96vEHQ+xNhRXoNyj1NvgDPk0xLt6Vv9+wplUNcMtm0ao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KyHrPPTE; arc=none smtp.client-ip=209.85.218.43
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-c15f360851aso248261266b.2
        for <io-uring@vger.kernel.org>; Sat, 11 Jul 2026 03:40:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783766435; x=1784371235; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=REzXyFdz7dKZUYmmyceB7y7FvYAAlICsxOnPzqdIdiY=;
        b=KyHrPPTESGCwXBF4xhEksFSj9IY7lyL98885vtAG6q55kqy+h5JeZPSPzVsvgPLXhw
         Eqcq1z2Emu6hLXBNF10W19+KqPViv760QM2b1fI2T58WdwQEeuUyB6xQlX3rxUfQG5cG
         njqRdiIEsvFx14zbwx+AiTudmEo7UdE+BzlD+isnH7lhffSeA5Uqt4NDT5yCmdFp5c2T
         8Hi0mTXFw88ukZkPxXIKOfKrBRyh61S5B19JkGRWz2bQBDRCwxJatofNMpp2ogmWTFt3
         0pQ0cFkEe4BBY9pfewV4egsSPB84ISzTCO/J48LS9Wc8+mApNddXDIF/ORyqMDhRFbjA
         hMjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783766435; x=1784371235;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=REzXyFdz7dKZUYmmyceB7y7FvYAAlICsxOnPzqdIdiY=;
        b=Bwxhz1DeeYd3HdvaHsXJnnC/Fg4b+ok9g8Z5b/6jUwQs/gV+hxec5hz9+SqBEH4fLc
         TaNR8CJ/tgSxucvzOJEIEjRnqXE/wA4aq8BwDWKzzt8771M0isWvBWhWGudrPogBY/zp
         Y7cl2SzisYwE40xGcpKNRt9BbI98HAx3unqaEf+DZbgyyvRYl2K0A+2WFxqciULkplzG
         tI2opkzpbr3AK25QzzG8JBiNipJsh1MYo4M0WgLeYQ09L3/e7vtJhx1MduSvDuxI0t3v
         tJaGRM13lZD0KOhx5BF/XRZcEBxobHHkUhKLRJ81s4F1IRoGz/ieMtStfrKR76RQSSqp
         8p8A==
X-Gm-Message-State: AOJu0YzfyaxJUu9gLJswfkG6VJ8gKn9NZaSSZJ+BTG7PY/Cj8fmMP+Yg
	6PsIC1gjTVTPZCk1bebBBw86ztDnz4myhkbAW4kj1Rz67N62t22PM2nPGFPAJg==
X-Gm-Gg: AfdE7clYZMyrTPd+PgfbN/6JdYHUgps2m0fD2EwTDwZQ3zJziaQnvO4odx7F1TSIG2G
	kIawP/JeOmMYUG9K5ILWlaaoD3plTZSaPzNMUAKP/WPSQVSwVQcndbUFSWPJNZhFoLNuq7ekiKB
	s1C2WUeGK1E4l/Hr1bAU4jgAhenJhgxo3DDQ9yiI8tJglJghsr63aQtJ8RV0xAlf64eQtGGpLaL
	jsnHtBZLLUp6ciUICnERoh0l63zv0PJCZMH976FKVlFCZVbOPyF/9Rjf5B24Nh0oFUqdaEV9ZqN
	buhMeeOHLdiON/ke4merBnmgsqUFq1iYznU5Azn2YO7O5i1sA6CwqffXlc4YA1hl8OavU51qyrA
	9K8uIFRzdvJfGsIgFgftHEQoZKkf0Q4rJlJGznPktl9WIo3TJCBQiVPfm8VXLqX2uoVueSfG7PF
	cNNPIqwFVH4DyjCzGFuFJMqYAgtdRg4Kf7+yLM2/zNGPgIgjLoYgZDpSqdMwFDTsU1yxyhDLEK3
	RmeMIwGXHqvHcbayyXxuQsGTfNucUOuUeXJuMVbNyJ7rM0IrQ==
X-Received: by 2002:a17:907:9622:b0:c12:da4a:97d5 with SMTP id a640c23a62f3a-c161f404f86mr86595766b.50.1783766434892;
        Sat, 11 Jul 2026 03:40:34 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-222-132.dab.02.net. [82.132.222.132])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c15d5de95e6sm483041566b.39.2026.07.11.03.40.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Jul 2026 03:40:33 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	netdev@vger.kernel.org
Subject: [PATCH review-only 02/17] io_uring/zcrx: move RQ head/tail to separate cache lines
Date: Sat, 11 Jul 2026 11:39:55 +0100
Message-ID: <9b892fd443ac63428885d1ade94066125923a8f1.1783616211.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1783616211.git.asml.silence@gmail.com>
References: <cover.1783616211.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13959-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:io-uring@vger.kernel.org,m:asml.silence@gmail.com,m:netdev@vger.kernel.org,m:asmlsilence@gmail.com,s:lists@lfdr.de];
	FORGED_SENDER(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	TO_DN_NONE(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: A0031741403

RQ head and tail are currently put into the same cache line, which can
cause false sharing problems when refill is run on another CPU. Put them
into separate cache lines.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/query.c | 2 +-
 io_uring/zcrx.c  | 8 ++++----
 io_uring/zcrx.h  | 7 ++++++-
 3 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/io_uring/query.c b/io_uring/query.c
index d529d94aa8f4..2e7b893cc8f0 100644
--- a/io_uring/query.c
+++ b/io_uring/query.c
@@ -38,7 +38,7 @@ static ssize_t io_query_zcrx(union io_query_data *data)
 	e->register_flags = ZCRX_SUPPORTED_REG_FLAGS;
 	e->area_flags = IORING_ZCRX_AREA_DMABUF;
 	e->nr_ctrl_opcodes = __ZCRX_CTRL_LAST;
-	e->rq_hdr_size = sizeof(struct io_uring);
+	e->rq_hdr_size = sizeof(struct zcrx_rq_hdr);
 	e->rq_hdr_alignment = L1_CACHE_BYTES;
 	e->features = ZCRX_FEATURES;
 	e->__resv2 = 0;
diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 8348413d6d24..c4a9a663eba4 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -380,9 +380,9 @@ static void io_zcrx_get_niov_uref(struct net_iov *niov)
 
 static void io_fill_zcrx_offsets(struct io_uring_zcrx_offsets *offsets)
 {
-	offsets->head = offsetof(struct io_uring, head);
-	offsets->tail = offsetof(struct io_uring, tail);
-	offsets->rqes = ALIGN(sizeof(struct io_uring), L1_CACHE_BYTES);
+	offsets->head = offsetof(struct zcrx_rq_hdr, head);
+	offsets->tail = offsetof(struct zcrx_rq_hdr, tail);
+	offsets->rqes = ALIGN(sizeof(struct zcrx_rq_hdr), L1_CACHE_BYTES);
 }
 
 static int io_allocate_rbuf_ring(struct io_ring_ctx *ctx,
@@ -410,7 +410,7 @@ static int io_allocate_rbuf_ring(struct io_ring_ctx *ctx,
 		return ret;
 
 	ptr = io_region_get_ptr(&ifq->rq_region);
-	ifq->rq.ring = (struct io_uring *)ptr;
+	ifq->rq.ring = (struct zcrx_rq_hdr *)ptr;
 	ifq->rq.rqes = (struct io_uring_zcrx_rqe *)(ptr + off);
 
 	memset(ifq->rq.ring, 0, sizeof(*ifq->rq.ring));
diff --git a/io_uring/zcrx.h b/io_uring/zcrx.h
index fa00900e479e..3cdfa4415d62 100644
--- a/io_uring/zcrx.h
+++ b/io_uring/zcrx.h
@@ -43,9 +43,14 @@ struct io_zcrx_area {
 	struct io_zcrx_mem	mem;
 };
 
+struct zcrx_rq_hdr {
+	u32		head ____cacheline_aligned_in_smp;
+	u32		tail ____cacheline_aligned_in_smp;
+};
+
 struct zcrx_rq {
 	spinlock_t			lock;
-	struct io_uring			*ring;
+	struct zcrx_rq_hdr		*ring;
 	struct io_uring_zcrx_rqe	*rqes;
 	u32				cached_head;
 	u32				nr_entries;
-- 
2.54.0


