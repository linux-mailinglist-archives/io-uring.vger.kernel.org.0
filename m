Return-Path: <io-uring+bounces-13336-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gHbdJjrZBWpOcQIAu9opvQ
	(envelope-from <io-uring+bounces-13336-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 14 May 2026 16:16:26 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C439542EFF
	for <lists+io-uring@lfdr.de>; Thu, 14 May 2026 16:16:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 26680305EAA0
	for <lists+io-uring@lfdr.de>; Thu, 14 May 2026 14:09:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1E413FF8AF;
	Thu, 14 May 2026 14:08:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="Z4YV4v1U"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com [209.85.167.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFE6A3FB05B
	for <io-uring@vger.kernel.org>; Thu, 14 May 2026 14:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778767720; cv=none; b=Lp0cPBPQ8/CfNHNYqejM+WcuiC27CVr4KQ6d/KP8oofQgDPixurt63EHszdtuQEnVi3ZSVfWu6Fv6n3p+VsxDT1BTL70tYCjYlT5NgczYI2uTBwenEHKGFc2NBUCEsGD4/ADLPBbNTIdWmXyzgq2q+ITHNDcSACJdOCRPQf9Rfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778767720; c=relaxed/simple;
	bh=/9VfzpV2H+WPsSxhE+4SCnCxhE3ukDNuaFCEvOKUOkY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XINbftJmTnBNzN5eafGDn6Jml+wxMrLyqDxi9/H1ETHtsMeWHceycbUUDxuTN4OWxMKUL+5/V9PFER7kfcyucuMyIzpAozE+gsKW9KlZiNvTM8vfzBiRmWS0JMbOUTBZA8PEl79m6MYYsp3eqkTeoaXDdI76yswH1L64YpYz1pQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=Z4YV4v1U; arc=none smtp.client-ip=209.85.167.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f174.google.com with SMTP id 5614622812f47-479dc6d26e3so4609950b6e.0
        for <io-uring@vger.kernel.org>; Thu, 14 May 2026 07:08:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1778767711; x=1779372511; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2VdLEtsSXXTD97ARZvp4Fn3QjxPGTsPjgq3lLYXDC9w=;
        b=Z4YV4v1ULnxFXcktTdrKbAqKWnuyZPIkDlBbVm/eeL41FbRmX7kGwS2QcQcdyiI3rD
         3jeb7nW3nPpIvlGaIrDIM3/C+/OtuJ/ebhtB8ddoPm/4o+PJrA5yfRo5Cc6zoKrPPL7j
         Cx2cVNjxQ2ODAPj5Bg2Ux+A9jceE9hnJ7NAxit1zbUGDp1vxjtK6Vw9UsZJUgAathlbS
         jiZEB2kbzomAW4z2RTS7wfWtn38w5MVqIFxSKfGr5Isr/6uYqNUzvoySuNampLFIfCgw
         ErS+QUggYHVmHKTmXisX89rnqBASjQEzwb4giE9iKbQQfI9DjiyR0tBzSV3aY+VAIMDy
         Kh0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778767711; x=1779372511;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2VdLEtsSXXTD97ARZvp4Fn3QjxPGTsPjgq3lLYXDC9w=;
        b=cboz7Zc0EpJ4M5o6OZp2756Ep4P1/Kr+Y8egY1aPpilnIplXH4LkCmrUT3PUTN6d/x
         1zQLIfHI2nanOUzzlxd4lTAbI/xlmgyJLvp8u7XdrhPl5xY5ePyx84/8hyeoHmVB7yFz
         xjJ9l0GqG4O7uTlopUTsZBnH0k+oScqgRhFig9SfO6NXyJfqfiRmET4qEu3cHiObPRUw
         k7M2mOtQ+wbXZ3GFuFucqJKc19EVv/s1ynsAFqeif4jjpKciIHSJbUEXjOd3hJsgsRFi
         S9tg2t3ABOz+5cadR8mom8DAG/cjh7Ky10jOZiKZv35zKSLC38vOvwK5YlXBL4YiPftE
         mNOA==
X-Gm-Message-State: AOJu0YzS1Y4DjOPvljmYj4Q8GDxoMITOh3EP0p64tfa3LNEoGTukHqLH
	kvlUic+NgJZEBHobvP9r157sVV8btOUYamBIG687Bwx5/0rvL6IZwHqFp78bvoFHvt1BnUzZuJU
	hEOxu
X-Gm-Gg: Acq92OHZnUyER6BUukrF86jWvZl+jKrLL9o4Yh+GqgD/KvaOAk2mTc9yR6RDGyf+jVt
	PwSY0gvuE4FwC05Bz79vy8l8n9/dH8MjV00OHCuBRuIIs4Gda1febOm4KRtHrcLhNSmktd0MhWI
	yLZ33kuehsV9v2qSixqOEfxmkgueeApyA2RnWVYPGOm4Dc7OVVLLCZANYUvpDTLv4+zPjfDveih
	g4q/hUTZEXVUqkOt7PLLs0NX3wKUO0HGmMc92Ep9MHLKv0YWhcHdbmeYQ8Yob0jZXFtbCzpSd5H
	aT21AF6b1NsYNtRTmq8lzGnAbhRNnCOv3aTaHqQzJ0QFYrWMUDajr4hOigRbvUJnjtrdQULySzH
	gN/e5B56Bf2Szya80CUEcI4grZ47oexlQ6xzYUcc2a4BdFcN7PuOQfut4V/LIYj6XKTy88IEigX
	UlhwLUsJO09Pkmzj/nNIjnyZQxvtBaFzWCUdi6cbO8p/cEVlo+Jb9dUiOnCHvsraM6HH0=
X-Received: by 2002:a05:6808:2218:b0:479:f80c:7891 with SMTP id 5614622812f47-482b61c6de2mr4739352b6e.28.1778767710651;
        Thu, 14 May 2026 07:08:30 -0700 (PDT)
Received: from m2max ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-482d379f062sm1394956b6e.6.2026.05.14.07.08.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2026 07:08:30 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org,
	brauner@kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 6/6] io_uring/epoll: disallow adding an epoll file to an epoll context
Date: Thu, 14 May 2026 08:07:22 -0600
Message-ID: <20260514140817.623026-7-axboe@kernel.dk>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260514140817.623026-1-axboe@kernel.dk>
References: <20260514140817.623026-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7C439542EFF
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DMARC_NA(0.00)[kernel.dk];
	RCVD_TLS_LAST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-13336-lists,io-uring=lfdr.de];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_COUNT_FIVE(0.00)[5];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	TAGGED_RCPT(0.00)[io-uring];
	RCPT_COUNT_FIVE(0.00)[5];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel-dk.20251104.gappssmtp.com:dkim,kernel.dk:email,kernel.dk:mid,linux-foundation.org:email,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Action: no action

One of the nastier things about epoll is how it allows adding epoll
files to epoll contexts. This leads to all sorts of loop detection
code, and has been a source of issues in the past.

Arguably adding IORING_EPOLL_CTL is a historical mistake on the
io_uring side, but we're kind of stuck with it now as it does seem
to be in use according to code searches. But we can at least minimize
the damage a bit and just disallow this part of epoll, where nesting
issues can arise.

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/epoll.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/io_uring/epoll.c b/io_uring/epoll.c
index b9db8bde27ec..eecd748cad01 100644
--- a/io_uring/epoll.c
+++ b/io_uring/epoll.c
@@ -62,6 +62,9 @@ int io_epoll_ctl(struct io_kiocb *req, unsigned int issue_flags)
 	CLASS(fd, tf)(ie->fd);
 	if (fd_empty(tf))
 		return -EBADF;
+	/* disallow adding an epoll context to another epoll context */
+	if (ie->op == EPOLL_CTL_ADD && is_file_epoll(fd_file(tf)))
+		return -EINVAL;
 
 	key.file = fd_file(tf);
 	key.fd = ie->fd;
-- 
2.53.0


