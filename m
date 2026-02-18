Return-Path: <io-uring+bounces-12306-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MPwVGHQqlWm2MQIAu9opvQ
	(envelope-from <io-uring+bounces-12306-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 18 Feb 2026 03:56:52 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1619C152C31
	for <lists+io-uring@lfdr.de>; Wed, 18 Feb 2026 03:56:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id E188A3039303
	for <lists+io-uring@lfdr.de>; Wed, 18 Feb 2026 02:56:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B0522874E0;
	Wed, 18 Feb 2026 02:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Vgzc/hbZ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0472D2DC352
	for <io-uring@vger.kernel.org>; Wed, 18 Feb 2026 02:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771383407; cv=none; b=KRGxZmFfqMms9aLz9SJ+Q1kD0KVG32MfNCuIERrP+0tE1SUzCM0TNXqaPkPRJA0MUc+Q4SZwKQR8rogpc5UaJLNYo+yyHU/fJ6LMHgRADZEGLtvWHdnIwZ2uUIKLAehrm7/cus8mWICPqL9I6prJkAu8A4RDaLXBy65RR0g45aY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771383407; c=relaxed/simple;
	bh=rJ2/SK1ehi3UQlDDja/ncg31JujFUa6c+IAO1P0gAIE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ely6LFYIqOtwx/mVv9mC3id71J/NvwHD/jk8D/jQDc8ZwPhcsTHkZH30rcMeKoaKImC/BUkt7Pnq/EwvVvVbdjsKgY4ltxd+5/tc1PvH56yOr7TjF63MdBUWy7k2KamRHNitReMcLwQSi13veBRgN0bZBvKQWZUjN4c19lbgpsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Vgzc/hbZ; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2a962230847so41135875ad.3
        for <io-uring@vger.kernel.org>; Tue, 17 Feb 2026 18:56:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771383405; x=1771988205; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IwsbzbH1ZQVfECzDphuhSq7a009gE7mrWEmezLvyKcQ=;
        b=Vgzc/hbZQMqF3dyKSI84jJ3Zr1dv4FIPwGdmTuU+4/nw1aHIjpPhRqJNlgqxRElAg1
         76EB7oOfQ33LqtjdhG7XXiJfdRI0BI2XLF1w4yVhnBCDryJEr0K+P9gYax6JbKJ2xGQT
         jWTFDnVJGmJkUnzhgL3Fd/EHs/mBJ9siP3pTHXvJQI42hBB27xqpJ0s6z/JIy4aF6TaT
         X4KYpO3k+ZQJUWNXvPXPeXJN16ZIp8eino98t4fnzU+Q7LqtPpWDJSsAhETXh6jtW5/C
         mfRJe4rAVkZtSrMEYLYnjW+Z+4Lh7b//osRSVzJYlRac42PWkq52jscpNJ4PrS42m28x
         pFWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771383405; x=1771988205;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=IwsbzbH1ZQVfECzDphuhSq7a009gE7mrWEmezLvyKcQ=;
        b=X8+RVFsWBvu5/b0CFjh3CZ5xFoOqV1DftXkUaQ4gs0GeCXompEuTJyr09tt7ETGtTQ
         q7jnUQAj8RsboUOGR8tvx7C14YJRpLcmntWgLGp4126FCfliC7gvGAw2rfJ11M5LLjRD
         0HKPdcarQXLrocTFWBfq2esKvsppGGcGS8vQwS2EILVcYy36CraBWDk87S4TZ9VfWN8s
         BMgl71TXg1v/+UbiOYpnedfZYLQFD98xD+KKLluDXMcWAqO8+LVvrBNkkSK8tz1AJJEj
         4hd5I5lTDnCj8Bn1torOH9MSRNpKygB2OTRhnxSz5s2sG3iwDjeGn3rgreVAL3xREldw
         5mRw==
X-Forwarded-Encrypted: i=1; AJvYcCVb/pm0F16yV57VLC+okBRwXNNPv2QigP7Nx2i8t/aoFNwI1hBTIsuSbUqsxJj8XdPZUwbUZMW/1A==@vger.kernel.org
X-Gm-Message-State: AOJu0YySFA7VB0if8ovDJnGXya27uYMzY46mZm8h+ANffi+T2vcet9SB
	YUnMXzaH6loESELh5u4ljNJDYChuFCqozOKuOwwGgAJ6T/3OY8uGtiVx
X-Gm-Gg: AZuq6aImB3+GGBKpSloZvqLQGwNlzzVhNsAenJDj1enUllu6Ozv6k2N0utperaDl232
	n3SGo1rmHhrSHqENUdOeJASGUm/yJwzAL0onhNhDDdHDoNSmJMwRRNPEpqQ2V3dsGTVsoq2txKF
	j0yM+YJ4FAw9eQ8poz6cgUVG0hDq1zrnySjKYJop4O4G0UWB0kFra9RUqnXLcps0ydLN+HLyaEt
	6n/IIryPcm0p0sr9GKuPT5hxoOqQpKo/Ky+UwNY6THlz51aXIRGfP7/0TbPW4E/YW6WQ2phNa6f
	CvYjtgL45vT4A0qtSkb+3u9g9r8K9Bw3ErxsMuvbHUHCehORcb1ntFbxAWuld1yYGz5U8UunJQi
	WMDd6yYKkCttEQvmonMFS/nBrCkEdphc4sRq61vE+C75+poUg6KvWJJ3fA3sjdvaWM7zjK7ULLp
	hA5c6pn6AIf/TfnUbvTA==
X-Received: by 2002:a17:902:d512:b0:2aa:fad8:7474 with SMTP id d9443c01a7336-2ad50f340c2mr3840575ad.33.1771383405421;
        Tue, 17 Feb 2026 18:56:45 -0800 (PST)
Received: from localhost ([2a03:2880:ff:45::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ad1aadd9e8sm118824395ad.74.2026.02.17.18.56.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Feb 2026 18:56:45 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: axboe@kernel.dk,
	io-uring@vger.kernel.org
Cc: csander@purestorage.com,
	bernd@bsbernd.com,
	hch@infradead.org,
	asml.silence@gmail.com
Subject: [PATCH v2 6/9] io_uring/kbuf: add recycling for kernel managed buffer rings
Date: Tue, 17 Feb 2026 18:52:04 -0800
Message-ID: <20260218025207.1425553-7-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260218025207.1425553-1-joannelkoong@gmail.com>
References: <20260218025207.1425553-1-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_CC(0.00)[purestorage.com,bsbernd.com,infradead.org,gmail.com];
	FREEMAIL_FROM(0.00)[gmail.com];
	MIME_TRACE(0.00)[0:+];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12306-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[joannelkoong@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[io-uring];
	TO_DN_NONE(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 1619C152C31
X-Rspamd-Action: no action

Add an interface for buffers to be recycled back into a kernel-managed
buffer ring.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 include/linux/io_uring/cmd.h | 11 +++++++++
 io_uring/kbuf.c              | 48 ++++++++++++++++++++++++++++++++++++
 2 files changed, 59 insertions(+)

diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
index 31f47cce99f5..5cebcd6d50e6 100644
--- a/include/linux/io_uring/cmd.h
+++ b/include/linux/io_uring/cmd.h
@@ -88,6 +88,10 @@ int io_uring_buf_ring_pin(struct io_uring_cmd *cmd, unsigned buf_group,
 			  unsigned issue_flags, struct io_buffer_list **out_bl);
 int io_uring_buf_ring_unpin(struct io_uring_cmd *cmd, unsigned buf_group,
 			    unsigned issue_flags);
+
+int io_uring_kmbuf_recycle(struct io_uring_cmd *cmd, unsigned int buf_group,
+			   u64 addr, unsigned int len, unsigned int bid,
+			   unsigned int issue_flags);
 #else
 static inline int
 io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
@@ -143,6 +147,13 @@ static inline int io_uring_buf_ring_unpin(struct io_uring_cmd *cmd,
 {
 	return -EOPNOTSUPP;
 }
+static inline int io_uring_kmbuf_recycle(struct io_uring_cmd *cmd,
+					 unsigned int buf_group, u64 addr,
+					 unsigned int len, unsigned int bid,
+					 unsigned int issue_flags)
+{
+	return -EOPNOTSUPP;
+}
 #endif
 
 static inline struct io_uring_cmd *io_uring_cmd_from_tw(struct io_tw_req tw_req)
diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index d20221f1b9b2..6e4dd1e003f4 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -102,6 +102,54 @@ void io_kbuf_drop_legacy(struct io_kiocb *req)
 	req->kbuf = NULL;
 }
 
+int io_uring_kmbuf_recycle(struct io_uring_cmd *cmd, unsigned int buf_group,
+			   u64 addr, unsigned int len, unsigned int bid,
+			   unsigned int issue_flags)
+{
+	struct io_kiocb *req = cmd_to_io_kiocb(cmd);
+	struct io_ring_ctx *ctx = req->ctx;
+	struct io_uring_buf_ring *br;
+	struct io_uring_buf *buf;
+	struct io_buffer_list *bl;
+	unsigned int required_flags;
+	int ret = -EINVAL;
+
+	if (WARN_ON_ONCE(req->flags & REQ_F_BUFFERS_COMMIT))
+		return ret;
+
+	io_ring_submit_lock(ctx, issue_flags);
+
+	bl = io_buffer_get_list(ctx, buf_group);
+
+	if (!bl)
+		goto err;
+
+	required_flags = IOBL_BUF_RING | IOBL_KERNEL_MANAGED;
+	if (WARN_ON_ONCE((bl->flags & required_flags) != required_flags))
+		goto err;
+
+	br = bl->buf_ring;
+
+	if (WARN_ON_ONCE((__u16)(br->tail - bl->head) >= bl->nr_entries))
+		goto err;
+
+	buf = &br->bufs[(br->tail) & bl->mask];
+
+	buf->addr = addr;
+	buf->len = len;
+	buf->bid = bid;
+
+	req->flags &= ~REQ_F_BUFFER_RING;
+
+	br->tail++;
+	ret = 0;
+
+err:
+	io_ring_submit_unlock(ctx, issue_flags);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(io_uring_kmbuf_recycle);
+
 bool io_kbuf_recycle_legacy(struct io_kiocb *req, unsigned issue_flags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
-- 
2.47.3


