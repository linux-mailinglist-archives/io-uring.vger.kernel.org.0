Return-Path: <io-uring+bounces-6271-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id ECFA5A28967
	for <lists+io-uring@lfdr.de>; Wed,  5 Feb 2025 12:37:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DEB0E3A5D7C
	for <lists+io-uring@lfdr.de>; Wed,  5 Feb 2025 11:36:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 214F022A7EF;
	Wed,  5 Feb 2025 11:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m1Pe77WP"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52C4B22ACD4
	for <io-uring@vger.kernel.org>; Wed,  5 Feb 2025 11:36:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738755419; cv=none; b=TBWgneZ53ak5x7+Ovn53LwWx2BUt6/BaUk/p9J3PjitLSojTkLLZfyZucSkATt4Q6pgPR+tL+DESpipMdt7zNWXlLLCZ7Y0t4dHaZ+brKZoxvHE8rfJy44R2TRGn1TBnTej69V3GO87ODFJJFkNkAkdVEdx8gICGbrMcoh1WoLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738755419; c=relaxed/simple;
	bh=TuwebxuLayIpG5s1JE+nmTZZQ7IcGyYFTxgLxNjKK7w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JmJH/7066nRXSBIeD0bFhAa3EtI6PosO5PmUW9mRA2XWklxDlNb7DieroGEb2Nn1/9+LNfDHz4ksyjtc/ds5dUaHwuSuSb/PAunsrRce0Y10QeXBXoXceCBx96YkCdicmW33AOvQBLzXdA7wz0ImE12VdPrAj/abAYKVVLrwX18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=m1Pe77WP; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-436202dd730so47005435e9.2
        for <io-uring@vger.kernel.org>; Wed, 05 Feb 2025 03:36:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738755415; x=1739360215; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3mldhM/2N7G4MxKkTBk2LFxpjmmTPM9Ga/RGmVFsZrY=;
        b=m1Pe77WPR8EnACmKU1mnVrDM9cg+SesRr04i205g+alX0to1B8Nw3i9VMfptEHMtox
         TLFdqFkZkHoEjuvYexNOUYX/HPuTinX9T6qjp1/jCwbbDX/m+EtpgrtBc4oSK4dzPf9J
         e5eXQy2MPxzJ0EMdCeJGKR/Ro65VzScl+smgTfgZHvacqukUXRfKBuDVbKWx9G+Bb4FY
         DwAWOhhiSnwn7UDNg9+feTzeDNwQ0vCIcjS5guFQ6Yn9ju3wkIVdNSf4QZc5vB1mQLUK
         FJywoVS4lJlBmIAkFEFRRiltOhZYte+6qJwwzAPHfqoH3cNInmYclpTs53gRsFUrL0MO
         GwXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738755415; x=1739360215;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3mldhM/2N7G4MxKkTBk2LFxpjmmTPM9Ga/RGmVFsZrY=;
        b=w8aVcMrrE+9laLp5euXAEnGhhkMyutFrViDW7uZLz44od0vWCD9v5DZXTCDFQENJTT
         MNqEo62SOIyYgl47F3wiNAp2Cs0wM2nJrd8bYVfL/rMN2XlIfV3rFrvv/y8IbU86XH8s
         HOQh1VZ7XhZwj1Q3hRykm7IorBdgA75Of9vRPMXuhDIQAehM0WbrKRvrbCS+gOL2fpiL
         5fZIBYhdffFVwsZiTMDsjRrGffU6luhDkRmz+lpJj/RIKjsTeK3AskC1GFyUJH/qV0CS
         OibYWDQJHyw7DWP7TeUqLy3dOiM5NFpKZAeGMK2rZ3mhBOLXXqP7uSTB9QLOvQbvfLdS
         Mk0w==
X-Gm-Message-State: AOJu0YzHaIAEhmTpLc4Jn1TGb2oumE7EjUrVKymZOv3fIzI9OOaoEgqa
	fU6l1u75B7sUd18kej8DVOeioKTAshZZtjOpv5aFC+xQiR06EHuKiKW9MA==
X-Gm-Gg: ASbGnctEQsT2L7psJqk3BwQUfJ/4tX0ejx8k158ckctCFWrUkUmzzRw1kqJUa3rsCbC
	DfnzoasWIqbEJgoJJLkjORszMcunO0ZAhLPMfCbjWwIA7Y1q85BtKCrmWaHGZIZ1e1egYz7bIC8
	iJ+UyT+/QXXa9wasX8TE+cZ42fx5uWYRXdkeR68XWCoMD3nDC7retcGEG7QthxR5UxgVBR+8F0a
	t/6+82taRYig2OWCfaHZFb8J+0KacnrwdJ0Eao6llqpHgu5v4k98RSZOBE9GdkowLMjkdRrxBWl
	ZdySxDEJ7A4M1Ceg6Ci1dsbqRFE=
X-Google-Smtp-Source: AGHT+IEfRL7tOvJWCYumhVI2ixkw4mblXtyeNOA38KdTOiI98WuRP+/QG602YWtiN9IOQtgdHfjYug==
X-Received: by 2002:a05:600c:5254:b0:438:a913:a99 with SMTP id 5b1f17b1804b1-4390d5b2fa8mr19414765e9.31.1738755414788;
        Wed, 05 Feb 2025 03:36:54 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.128.4])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4390d94d7d4sm18514505e9.10.2025.02.05.03.36.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Feb 2025 03:36:54 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 6/8] io_uring/kbuf: open code __io_put_kbuf()
Date: Wed,  5 Feb 2025 11:36:47 +0000
Message-ID: <9dc17380272b48d56c95992c6f9eaacd5546e1d3.1738724373.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <cover.1738724373.git.asml.silence@gmail.com>
References: <cover.1738724373.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

__io_put_kbuf() is a trivial wrapper, open code it into
__io_put_kbufs().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/kbuf.c | 5 -----
 io_uring/kbuf.h | 4 +---
 2 files changed, 1 insertion(+), 8 deletions(-)

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index ef0c06d1bc86f..f41c141ae8eda 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -68,11 +68,6 @@ bool io_kbuf_recycle_legacy(struct io_kiocb *req, unsigned issue_flags)
 	return true;
 }
 
-void __io_put_kbuf(struct io_kiocb *req, int len, unsigned issue_flags)
-{
-	__io_put_kbuf_list(req, len);
-}
-
 static void __user *io_provided_buffer_select(struct io_kiocb *req, size_t *len,
 					      struct io_buffer_list *bl)
 {
diff --git a/io_uring/kbuf.h b/io_uring/kbuf.h
index c0b9636c5c4ae..055b7a672f2e0 100644
--- a/io_uring/kbuf.h
+++ b/io_uring/kbuf.h
@@ -74,8 +74,6 @@ int io_register_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg);
 int io_unregister_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg);
 int io_register_pbuf_status(struct io_ring_ctx *ctx, void __user *arg);
 
-void __io_put_kbuf(struct io_kiocb *req, int len, unsigned issue_flags);
-
 bool io_kbuf_recycle_legacy(struct io_kiocb *req, unsigned issue_flags);
 
 struct io_mapped_region *io_pbuf_get_region(struct io_ring_ctx *ctx,
@@ -194,7 +192,7 @@ static inline unsigned int __io_put_kbufs(struct io_kiocb *req, int len,
 		if (!__io_put_kbuf_ring(req, len, nbufs))
 			ret |= IORING_CQE_F_BUF_MORE;
 	} else {
-		__io_put_kbuf(req, len, issue_flags);
+		__io_put_kbuf_list(req, len);
 	}
 	return ret;
 }
-- 
2.47.1


