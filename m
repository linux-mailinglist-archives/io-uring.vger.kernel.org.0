Return-Path: <io-uring+bounces-11969-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0PYcDVmXe2nOGAIAu9opvQ
	(envelope-from <io-uring+bounces-11969-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 29 Jan 2026 18:22:33 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id AE2B0B2C89
	for <lists+io-uring@lfdr.de>; Thu, 29 Jan 2026 18:22:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 10BF630474CD
	for <lists+io-uring@lfdr.de>; Thu, 29 Jan 2026 17:19:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA36328DC4;
	Thu, 29 Jan 2026 17:19:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ncV7rl7n"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84208344033
	for <io-uring@vger.kernel.org>; Thu, 29 Jan 2026 17:19:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769707196; cv=none; b=P4Ir3OTut5g8C0/EAIlITql/mB8HwG94+VGPF0P5P8x1kJR/Mree581GBkz/ozsUijxVqiEmeIG5UMH50DWpGbvyYCStmsBqRh6JuiBTinJvBcaawtdkx0mdV4CqzxmA7v62mdHU2r7KhmTw5t4E8s1aK66y0MzzfdC8R4A6f3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769707196; c=relaxed/simple;
	bh=J5V54AVusBTd7IX5+KsNO4vlAWxyRj1CC+muvurYzrg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=I5CwjR2do8V6a+cUF6PKJqJv+LYjBLb47hWOR51yAgCQjHlrwVK1hYF+DSt1npny15gERTg6QOPqoGWTJCu0lC6ZadFGTq7w//GvN62EjoQZE6SB2HzR5B0HkzMIKormOp1YH37GMvkQfumLiJHtPNzfSCDk3px9nZqx83Ysp8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ncV7rl7n; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-42fbc305914so1163459f8f.0
        for <io-uring@vger.kernel.org>; Thu, 29 Jan 2026 09:19:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769707191; x=1770311991; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=rlQfZ9OPMT3oE9N+HgVfUzAffIHwD8+SOeEdx4S+Y/g=;
        b=ncV7rl7nmtTJD4zOXVkMr3HlG65vwcgYHzVbdKk6bgoJyijrZ0B9K9OJ8Z6EcG4Vqs
         dcGnSxUDRNgml/SOC2VRJz9EWTeiKhEowoNTPJKkewStTaCyC8j1MCXBW+z66W7D3y7q
         3sMAaw81hOk1A3eg2b+c42UBxvVgI8rYPN6q815FbUOGno+zdTMOVW1kWJYEpfXfptJv
         HyJV/zh3kVByOL+kFdBEonu/E+IMsObzukvuHMYwWhRnZMoRGOs5xN1Z5Z0vl5rResIm
         c1SCixG5o+9l1lpeYO2VjjKitHLtg7VsVIXMR01ZVC4+oOsDx0V2XBdjKz8CLi6vAS1z
         DVgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769707191; x=1770311991;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rlQfZ9OPMT3oE9N+HgVfUzAffIHwD8+SOeEdx4S+Y/g=;
        b=UuWglgHRtkv2KbmZIe4WYr+GNncrzO1H/alYLSou6R2t7CwKjKt3SYUQ8z4EXz3+pu
         c+JgGOaambibdVYeQFPZIg9BWr7ssXz91xOosUS5+ByYyrz2pbkNwFebHr78angOyNGI
         vSW3Tbu/CTnQzeaJDiJcARf2qHn8w2N7Eg7K24Gnd8BzKIAsx/nq/vHQtZlkoxw03E0j
         cOmaO5DaybdzmemZ4/Ww9iiXYQVwUbnJ+2GQXcnslFRQoJ/yPJ5qx749/4bfXvGz6j4s
         gzdAcmHZ6aeWpIHp85KAlHCtUyfH3jlYMvS0/CjkJopSSNh2pMdOob2gPgaYr5Rd2J29
         y9Uw==
X-Gm-Message-State: AOJu0YyZHAMI0IYrktrZ27reJJKTzwxg6ZumTrtT9HqzHJ5rAae/EZ1X
	qCki/napmyKx1uNikipy16qU9oay94zOYyTfIuuH6eBqXejiThczuLuId7Ead79X
X-Gm-Gg: AZuq6aJnXyX5oUTalJT+9ciC9A1HRnl5S2NnIXXdkPz4R2PnVlHSFLmUYQzEPOCCoE0
	bP/6FC/e0ulS2jsFlp8K6qjohTgpJUaEh9hxOtwyIoZnm3RJJvdA67fdH2vJq61dG0S+tntIrdf
	boH/g41w3WSiu4waKodkaQIeej93yQQhD3FKA0lTRO/Zc7i7fhWl4URSgNQ0DEql6fYqAdXHmD3
	/GqWUzRDetuWyBNOYSI2/9nvFcTaMQxvT/YqJ8T5jHBQJiEqlMdFVH67gvvWnO7DB5lysjh7DqF
	XeTfdtuOg4JehXdgaZFjPgQaADc4b2ooOeZvBnGoRKbEQhRx7VZRjZxKgidrVXn246dDjZbTRCr
	sodhFHeSGElj8qN9m2eiQMOdwn48wOCIUV7sjVJtv5dfDbO+dcGhdWWR4W0SoWKIbJuQg7eseSo
	qPHTlAGcByk4KYleuJ7jS6aNZaXMxrhg5n/VFq7zslg8lVipq+8zMM0K64sCOu7OkFLsD6Qw==
X-Received: by 2002:a05:6000:40da:b0:435:9bf5:b32c with SMTP id ffacd0b85a97d-435f3ab283amr540533f8f.29.1769707191133;
        Thu, 29 Jan 2026 09:19:51 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:2887])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-435e10e476dsm15806554f8f.4.2026.01.29.09.19.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jan 2026 09:19:50 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk
Subject: [PATCH liburing 1/1] src/queue: simplify IORING_SETUP_SQ_REWIND handling
Date: Thu, 29 Jan 2026 17:19:31 +0000
Message-ID: <6fcdfda380cb636b3ddcb9d446907abdb63782c5.1769707053.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[gmail.com:+];
	TAGGED_FROM(0.00)[bounces-11969-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,kernel.dk];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: AE2B0B2C89
X-Rspamd-Action: no action

io_uring_load_sq_head() shouldn't need a IORING_SETUP_SQ_REWIND check
as the SQ head should already be zero. Also, add a couple of words about
the tail resetting logic.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 src/include/liburing.h | 3 ---
 src/queue.c            | 7 +++++++
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/src/include/liburing.h b/src/include/liburing.h
index b41958ce..8d45d400 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -1684,9 +1684,6 @@ IOURINGINLINE void io_uring_prep_pipe_direct(struct io_uring_sqe *sqe, int *fds,
 IOURINGINLINE unsigned io_uring_load_sq_head(const struct io_uring *ring)
 	LIBURING_NOEXCEPT
 {
-	if (ring->flags & IORING_SETUP_SQ_REWIND)
-		return 0;
-
 	/*
 	 * Without acquire ordering, we could overwrite a SQE before the kernel
 	 * finished reading it. We don't need the acquire ordering for
diff --git a/src/queue.c b/src/queue.c
index 00995ace..87b4dbbe 100644
--- a/src/queue.c
+++ b/src/queue.c
@@ -205,6 +205,13 @@ static unsigned __io_uring_flush_sq(struct io_uring *ring)
 	struct io_uring_sq *sq = &ring->sq;
 	unsigned tail = sq->sqe_tail;
 
+	/*
+	 * With IORING_SETUP_SQ_REWIND, the kernel ignores the SQ head / tail
+	 * and submits entries from the beginning of the queue. Continue using
+	 * the indices as before but reset the tail on submission. With the
+	 * head kept to be zero, io_uring_get_sqe() / etc. will work without
+	 * any extra changes.
+	 */
 	if (ring->flags & IORING_SETUP_SQ_REWIND) {
 		sq->sqe_tail = 0;
 		return tail;
-- 
2.52.0


