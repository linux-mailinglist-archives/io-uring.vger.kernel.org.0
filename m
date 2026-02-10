Return-Path: <io-uring+bounces-12116-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oItiCHJ8imk4LAAAu9opvQ
	(envelope-from <io-uring+bounces-12116-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 10 Feb 2026 01:31:46 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id C9A621159F6
	for <lists+io-uring@lfdr.de>; Tue, 10 Feb 2026 01:31:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 4863E3021992
	for <lists+io-uring@lfdr.de>; Tue, 10 Feb 2026 00:31:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11E5818E02A;
	Tue, 10 Feb 2026 00:31:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SfyCM0pl"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4165186E58
	for <io-uring@vger.kernel.org>; Tue, 10 Feb 2026 00:31:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770683504; cv=none; b=EX5D7s1mTR5h7j0Xk1gy7jcvtUfnk2XR7JTyGIMCeI15Zkty3PPQdE0lGQPC58GuCOYYUfm2wWKIBlo4zpfkF0hEQLhJDp1K2o1ZzfHThajAn0w7jc8wa0epBqHXdg8dfvK+zN5LnilemOu9EHSutpoVeBeyhqkb8NGEdcBkA6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770683504; c=relaxed/simple;
	bh=kas0noC8vFvaZbY37+QZYlpA3ed/Khc6fhCYvK7FStM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y9nUZGFEzxFh7ldrHVal6nClyQoSM9FSA93eKaRtFh4DBfkubgv/vLk5K9QzZzhHPGp13RondR+NJUsNw9I/nICMSdCa4bymZqeR2b6AJBM0W2RcCSb+oW4p+HqMKjbpl8aTy3XyPN+XT9YvrLl3h3TJAgOI1xCc56pA+3fy26A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SfyCM0pl; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2a95de4b5cbso28927685ad.1
        for <io-uring@vger.kernel.org>; Mon, 09 Feb 2026 16:31:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770683502; x=1771288302; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RTmoEdcwayJZ9NG4SkJibowq1qwaRSn+WkhxuA4u/eA=;
        b=SfyCM0pllqjxQBywIENBENlw8pgkW5Nr5C94FC17Ldgz9V+UnEgB9cV687zXVkEqax
         yUKPi7OtkvCDsbQINvjJcUwpNrN3w2JkUfcoTLDBrPGIm9ttMOw+o2+sDvvHBN8XGW1X
         XwJODQqKYtdcpzepyAM8ZJsX/FmmEHnka9800xQ0jJgrgJnkqY8iyGvAxiQAWcaK6rN+
         YAelGLcbtkHj6yv4OnQ7IIG5IfVX2bllFPBzqN1VinhKC3AFEzrtdTo0LsPVfVOMtQ9o
         aQ/K+7c7PGAhpIwA5Ja4tCp1uUBBJd+Vp5Ou34fanGIPe0ofAdGtjsU1YwE+1qM/UEwN
         71gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770683502; x=1771288302;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=RTmoEdcwayJZ9NG4SkJibowq1qwaRSn+WkhxuA4u/eA=;
        b=CoXKfqkH26YiEBnqg3zb0VoX1N9MNiMxzzTWay0DgjLmGU7X/psacE1O6PUF6DmgoY
         Jz29fVCZNfNMbVF+5MofuJhkI6FW4HBCzMyLyQ5zPZ9SQ/7mbGPSFWwF1FE1xq3Lijk5
         G6nMhQF0EKEF+PCr85MEIZaYsvcM8lctU69hWKgh75EfgOqRv2JXIddrFsnVTxcxK14G
         glkRSbqw0lC0Wqj3E9XYvL/3ak1D4+zh2xwVa3avcJQt/6MlIk8KiLKBxh44Ep1VLV4w
         MTFCHRTtjDU7nia3+ZfT9syBPl9qIyzc5tcFSj0f/Q5uEJlba+sBM5NlkZXG0MjKWdlu
         WITQ==
X-Forwarded-Encrypted: i=1; AJvYcCXmccqDBNXoGm4o+ifbFxaTulltdhyoIJYMGd4x4a5Zh0LoTJcaq9uHbwtwbFDw7lE+yj/dKcZ02g==@vger.kernel.org
X-Gm-Message-State: AOJu0YzG8l1E5jhM/s1DcgQo0BJuVjkPF+mNKkXoUKWIoABZ2PcAEEti
	7MeswEYZVXcDwfFjL6Rx/4aMbuR0kkKzHPbIm5MPZ5aRCRy4UUx1w3Yg
X-Gm-Gg: AZuq6aLGvtxgS6dK1Kw75HMY71wMYuFUEDZ3xJDgUU4pc9IltvyHv600JYcds6wMnp5
	Rf8sCd2704mKrV0s+ffR6wFPgPWUCgQLVcT7TM/cGGsN4acLUzmRlwjc7K/T+o6h3rAUmEyIUeU
	pRU8c0YUjZg6DwbVcTAGcjDHUc/WpXn3dl8pa2JtzvpfInB5VrGBLqCY884YeLgGwwWPTZHKr+1
	mbf0GAI3rh1ou65KioESe3eAedPzY2VtKiJS8kOU/dvBCnIbeUCWkZK2iOxUmS8QV1gu8vnxOzm
	REJQmJQw/qLdZVat/bRl46cB6jBR7R14XGAztfd3EWiVOdA9izNQimZdQ5wpNQF8Gwb+Er9J6l/
	uS23V9ClCBUjgv7cwMsNnaXNadxhUrdkkTbaS+f7QpeIQW49mVTqo/zgeiWx3f3TJkK7KiHy6k7
	hT8Momkg==
X-Received: by 2002:a17:902:d2c1:b0:2a9:4507:3e86 with SMTP id d9443c01a7336-2ab10590269mr5123715ad.19.1770683502249;
        Mon, 09 Feb 2026 16:31:42 -0800 (PST)
Received: from localhost ([2a03:2880:ff:40::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a9521f8cb6sm122611245ad.79.2026.02.09.16.31.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Feb 2026 16:31:41 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: axboe@kernel.dk,
	io-uring@vger.kernel.org
Cc: csander@purestorage.com,
	krisman@suse.de,
	bernd@bsbernd.com,
	hch@infradead.org,
	asml.silence@gmail.com,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v1 02/11] io_uring/kbuf: rename io_unregister_pbuf_ring() to io_unregister_buf_ring()
Date: Mon,  9 Feb 2026 16:28:43 -0800
Message-ID: <20260210002852.1394504-3-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260210002852.1394504-1-joannelkoong@gmail.com>
References: <20260210002852.1394504-1-joannelkoong@gmail.com>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[purestorage.com,suse.de,bsbernd.com,infradead.org,gmail.com,vger.kernel.org];
	RCVD_TLS_LAST(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12116-lists,io-uring=lfdr.de];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	FREEMAIL_FROM(0.00)[gmail.com];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[joannelkoong@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	RCPT_COUNT_SEVEN(0.00)[8];
	TO_DN_NONE(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: C9A621159F6
X-Rspamd-Action: no action

Use the more generic name io_unregister_buf_ring() as this function will
be used for unregistering both provided buffer rings and kernel-managed
buffer rings.

This is a preparatory change for upcoming kernel-managed buffer ring
support.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 io_uring/kbuf.c     | 2 +-
 io_uring/kbuf.h     | 2 +-
 io_uring/register.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 850b836f32ee..aa9b70b72db4 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -719,7 +719,7 @@ int io_register_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg)
 	return ret;
 }
 
-int io_unregister_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg)
+int io_unregister_buf_ring(struct io_ring_ctx *ctx, void __user *arg)
 {
 	struct io_uring_buf_reg reg;
 	struct io_buffer_list *bl;
diff --git a/io_uring/kbuf.h b/io_uring/kbuf.h
index bf15e26520d3..40b44f4fdb15 100644
--- a/io_uring/kbuf.h
+++ b/io_uring/kbuf.h
@@ -74,7 +74,7 @@ int io_provide_buffers_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe
 int io_manage_buffers_legacy(struct io_kiocb *req, unsigned int issue_flags);
 
 int io_register_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg);
-int io_unregister_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg);
+int io_unregister_buf_ring(struct io_ring_ctx *ctx, void __user *arg);
 int io_register_pbuf_status(struct io_ring_ctx *ctx, void __user *arg);
 
 bool io_kbuf_recycle_legacy(struct io_kiocb *req, unsigned issue_flags);
diff --git a/io_uring/register.c b/io_uring/register.c
index 594b1f2ce875..0882cb34f851 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -841,7 +841,7 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 		ret = -EINVAL;
 		if (!arg || nr_args != 1)
 			break;
-		ret = io_unregister_pbuf_ring(ctx, arg);
+		ret = io_unregister_buf_ring(ctx, arg);
 		break;
 	case IORING_REGISTER_SYNC_CANCEL:
 		ret = -EINVAL;
-- 
2.47.3


