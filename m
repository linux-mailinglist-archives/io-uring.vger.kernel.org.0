Return-Path: <io-uring+bounces-12908-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qNF1GqJXzGkjSgYAu9opvQ
	(envelope-from <io-uring+bounces-12908-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 01 Apr 2026 01:24:18 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id D8CEC372C15
	for <lists+io-uring@lfdr.de>; Wed, 01 Apr 2026 01:24:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 2E1C33019170
	for <lists+io-uring@lfdr.de>; Tue, 31 Mar 2026 23:24:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 877B34657C0;
	Tue, 31 Mar 2026 23:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gEyQ/yqX"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82C3D37BE85
	for <io-uring@vger.kernel.org>; Tue, 31 Mar 2026 23:24:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774999454; cv=none; b=Tc/qXj08qdL2bCQgODXeluSAjSf3McRmXlnQ8LwngnYYu6a7STQfXO6sQjpFh9PDLmcesrZssDGcFjZ6YDJhaExS30/FUloT/rhAHGI1VstNafc3CNnY0dlEDJdRGZipogHd5tdi6P4xxQwhPOpNz4vMuAu2Qi4W57vYKHY3YtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774999454; c=relaxed/simple;
	bh=A9WKWCPMZ4yP8kEIwbgc1DxVchY2jrnn+UyR0ClVPiw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=uLghEE8VoYTiZXsogQq8VBZkiZUgC2R4RCEBnHvYxTRlT4TZA95XJ3mnOXU/1uI2jhz6woLVmHEq4ZqU7YoDLGfHCuHUan3ihEhKKK9aoqbPA7uxg5skX/Jpb9xyzqMKIUlMcBr+9ZqntmKI86gzsABj1JQIj14JBrESFGGLi/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gEyQ/yqX; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-48558d6ef83so62656515e9.3
        for <io-uring@vger.kernel.org>; Tue, 31 Mar 2026 16:24:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774999451; x=1775604251; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=jhmDSgWcC+Wz4bmkvwPB4KxSbIJjzE9xZ7OXZsX6sT4=;
        b=gEyQ/yqXAxBTvdBoB4QUQcIOuCcWAKUELNJKGkqkNnzNVOgSqHkCGU3gf5r0uUnOCX
         gSzm5+62nUEXb4fjsJFQUznSOvMRSTZpVpzrPuTiP7Zljf4uFub+PlRYVa1bxtzreWgv
         /9uGE+AscGMXxh31bXMYjKM3J6B8KOntt7hXBvQUbEiA91/OtVe7SfV8vUgTD8ez/Ae4
         mHrXMRkMi81lFAOFhTzvz+ZUiSGPgNRInKm9blOzVjBRrmBQP2vVeyUBWpaK4FhdR0Lr
         BUHvjjvDWGXPG9Jvl5GwP5Q4MLf6NhaZxzjT0fpdtN3v/gS0OU02YnZgf854bd2ilJQK
         ZRDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774999451; x=1775604251;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jhmDSgWcC+Wz4bmkvwPB4KxSbIJjzE9xZ7OXZsX6sT4=;
        b=fYTqctV34DPpJmoBc0nkZZDLJ71Kp9Gs1neZVKYTt4AjWvUNOxVA7IP4PcZrCN6j+y
         95urDaedgNWkGqI1zTfcphIfevWGfDtlwnTZXA58kZ38504d09DjXyhXiSwAN4kkQX73
         uQIGhk/Hldi9bmu//bnUScBmp+P6xl0CZxQ8Olc8be7Axi/HbdKRGKiCBrreo8sF0nxk
         lEI2ekTZt6ZNP5zqH0c5LTGTXNswEU5I4QE4NhzQze6Md7GRfn4gWnBqXWre4e52Sd0v
         rjvxGMb5JInQvdaJhK41k6hhOnWLK/DS4DluJ3lNl6u/4t+ZsYmKvdoSgPVr13+GrEoJ
         h4mA==
X-Gm-Message-State: AOJu0YzKpaf7gcICqseAitjVeXVYdCLeWAV8iRCHR4TJicW44+/HEVAB
	BEpLZggwhodUSSfRa3IgNiNkS6bJEvyZVJR2a9u49AdcXDU00Iuqk34Z
X-Gm-Gg: ATEYQzxIwuOwomsOKQrPEZeFn+1GqHeVbrZMHIqyQVnqcFBmLT4MyEyfkPgMRaL059p
	ZS0f07wp2m11LY5VT40ShyeXZuf+zFo/Go9Pf8hOE2aJnRX8l6t9BfA1BDCYhAtfRJ0qCclYHmp
	f0/kR+z0fau7pawFwGwQh7GITyKxqlPOMfP9kp/IcGWmBjZEUO0sdG5WSMejVJxcyjv7y7pc/KI
	g1toag4nFsVCzkraVLoUohwWRAXG0MlSFAaOZlR74LqteW7IEqE7tpbrAv8xu02DaudlYU9iZX1
	mgqAwcp/SGUzSvM1UhfI8PSYfYs0SL9XBZ2POCJcyMB/a26AzsmrqoA4f213c1F/5RB8t9oOwKr
	w0jhxqJEiRbGn3t3shfltfwYNYsrUB01sthzYD0IoHJQALtfc/aT3iDhcV8IAX2HSMmfT15S8za
	0fIHKgGvX7iBE1WgE=
X-Received: by 2002:a05:600c:a088:b0:486:fdca:ea8d with SMTP id 5b1f17b1804b1-488835cd366mr18131285e9.25.1774999450630;
        Tue, 31 Mar 2026 16:24:10 -0700 (PDT)
Received: from reolab.localdomain ([2a01:4f8:c17:7e89::1])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43cf330872asm28456862f8f.17.2026.03.31.16.24.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Mar 2026 16:24:10 -0700 (PDT)
From: Amir Mohammad Jahangirzad <a.jahangirzad@gmail.com>
To: axboe@kernel.dk
Cc: io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Amir Mohammad Jahangirzad <a.jahangirzad@gmail.com>
Subject: [PATCH] io_uring/cancel: validate opcode for IORING_ASYNC_CANCEL_OP
Date: Wed,  1 Apr 2026 02:51:13 +0330
Message-ID: <20260331232113.615972-1-a.jahangirzad@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12908-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[vger.kernel.org,gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	FROM_NEQ_ENVFROM(0.00)[ajahangirzad@gmail.com,io-uring@vger.kernel.org];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_COUNT_FIVE(0.00)[5];
	DKIM_TRACE(0.00)[gmail.com:+];
	TAGGED_RCPT(0.00)[io-uring];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: D8CEC372C15
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

io_async_cancel_prep() reads the opcode selector from sqe->len and
stores it in cancel->opcode, which is an 8-bit field. Since sqe->len
is a 32-bit value, values larger than U8_MAX are implicitly truncated.

This can cause unintended opcode matches when the truncated value
corresponds to a valid io_uring opcode. For example, submitting a value
such as 0x10b will be truncated to 0x0b (IORING_OP_TIMEOUT), allowing a
cancel request to match operations it did not intend to target.
Validate the opcode value before assigning it to the 8-bit field and
reject values outside the valid io_uring opcode range.

Signed-off-by: Amir Mohammad Jahangirzad <a.jahangirzad@gmail.com>
---
 io_uring/cancel.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/io_uring/cancel.c b/io_uring/cancel.c
index 65e04063e..5e5eb9cfc 100644
--- a/io_uring/cancel.c
+++ b/io_uring/cancel.c
@@ -156,9 +156,16 @@ int io_async_cancel_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		cancel->fd = READ_ONCE(sqe->fd);
 	}
 	if (cancel->flags & IORING_ASYNC_CANCEL_OP) {
+		u32 op;
+
 		if (cancel->flags & IORING_ASYNC_CANCEL_ANY)
 			return -EINVAL;
-		cancel->opcode = READ_ONCE(sqe->len);
+
+		op = READ_ONCE(sqe->len);
+		if (op >= IORING_OP_LAST)
+			return -EINVAL;
+
+		cancel->opcode = op;
 	}
 
 	return 0;
-- 
2.53.0


