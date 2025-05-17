Return-Path: <io-uring+bounces-8037-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E472ABAA0B
	for <lists+io-uring@lfdr.de>; Sat, 17 May 2025 14:27:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C8C071890C73
	for <lists+io-uring@lfdr.de>; Sat, 17 May 2025 12:27:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 235F34B1E7F;
	Sat, 17 May 2025 12:26:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XerXusRc"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 631B71FE461
	for <io-uring@vger.kernel.org>; Sat, 17 May 2025 12:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747484808; cv=none; b=Ans5HMZQK7koLRdyv2/ekcnqxc/vv8suZV4W5w4iFmDiwbXZsKIvi14CpcjkYf9epyoDUXSMAtV8946RwAiOYQKYuw67BJerSk0z9T1GqSBu4mwsJ0xg200aTSK4nxgNIeWRitVUUnb4X9kFqvhCN9iKfWHpy2Xm+bVuKvLrq1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747484808; c=relaxed/simple;
	bh=X519Z5EvVJ5Oc7+KzzGphSDUAOk+RrMOwmZrjNyk4p4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PE4ekgVnbRUKONf+GVrFTwMF6WHHbZyxWklUgbAtnqwNZZijgVnn6cYuy5HvrbjlN2WjzZAG40ddKp7FrxWzbrLxbfLxngN5xSy5jvcpnBIvG3ANp0MVaEDsJSAuf80xik2Y8hjS6KfIbp5ZXzcLjF9O3bMYmQzK1/de6KKOdGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XerXusRc; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-601470b6e93so3039353a12.3
        for <io-uring@vger.kernel.org>; Sat, 17 May 2025 05:26:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747484804; x=1748089604; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mvkyl2NsVVW8bACDwjSmS50UPQ1VN5YLYBWy0K75+ww=;
        b=XerXusRcIiYQjCoSIr/GuXWI8BFvZPnM3PfNwJybYq+MsS/m7tizixsCI5qoycIqHD
         Kr1Kw4FPjD5n/3+AWe10pGcp6Z14T0GjuDHGu7jXQBmQiMrGJYY19Os16/EfsVKQ/I0q
         7WkZybez46K9g10yDvMxqB211n15xyjssSa7FZAtAOOs7fCbUojnISrvsS/bCcmy3Shd
         3MHRdU2Jw7vttd6e2amjKBfJVilUYUPWwD0Fd90xHJ+CDVzBmoJkUy1hHh/MzohQCaCB
         vjAs07Wp80qT5a4bTG7nyILHCGqIQOqnsA9G8+yzgxMw6Yfmv5pbE1KqYlnQQjkyHafb
         UFoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747484804; x=1748089604;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mvkyl2NsVVW8bACDwjSmS50UPQ1VN5YLYBWy0K75+ww=;
        b=XN1Bvi3gE9XV8k752Bmq9UL3hy9/VpVDrOuyHI0hfYwyeTHAHJKUlMo+pRAYmvo/Ea
         nZD/Hxn74R+3x58829tcx3SAXXaOiebtInaLvjQXdItVgL4Sox64a/t0bZ/IlAbpQzDn
         GBexdhshr27zFYazjlLsPM4yllRrDnV4QFN6w30kZarqt8Erh6y4fKyEEw1tTslrjjl3
         g1ejmbXuQWttQmitfVzNcEJhS4vwWQj36TsZdKzv44eiTqLgJxeQWMQIOIJ/e5FREZGu
         HFgLeLwVj0KNnkANf8svqzOuVAw8lTqjVWYS/qbxyd9NZUAGQHE4UTIppRtNETFC9JjH
         dG1Q==
X-Gm-Message-State: AOJu0YzPv+GlxfsI7C+PddXwPzE9/++dmgDoegZ/Yc4X+Xkhf9/NKQjn
	Os+pgLXk+PEevOiLSs/3uxP7vdTCZ8N/J+t12YxhJtX8gVWuKIgDFQtcv3nJCw==
X-Gm-Gg: ASbGncvV23R2KPa4BL1jJuwu+1LoMgNUxqoPwtL48m7uA3z/Yjv3vgO6FQRRNnzytGJ
	ncticRTcfssksm7KSKYBhbGvaGLJDsQ35iE6yz1JktVoMBkSjRfKfb4zD183Zet1sOXFWmWV3aN
	Z2vq+pXtFcD1xd4uHEBAP9ZTThtue93xLMRY7iLoaxMR0/LF+y3QajHVrE8dR02gSgNngHbJQbI
	OvYFAIHXEqWT3nRtvsrX0Plnh4Es5auUGfybDCa7hbXaoWW8j1nqb1tvasGuNLuXWyUTpNlcW9e
	XMHhiGe89spB6uXmeSp8NHEifv7OmGzV/TqtsVEeAKfHcfhcVN7RxWByoeugkkE=
X-Google-Smtp-Source: AGHT+IGm1f7mbilJg2IHC3unVU7B9RcdtfdRLidYb24INNf8o0aKS3b0cFgMYAum2xFW426j2VlYJA==
X-Received: by 2002:a05:6402:40cd:b0:601:b0a6:f075 with SMTP id 4fb4d7f45d1cf-601b0a6f421mr260587a12.16.1747484804016;
        Sat, 17 May 2025 05:26:44 -0700 (PDT)
Received: from 127.0.0.1localhost ([85.255.234.71])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6005a6e6884sm2876604a12.46.2025.05.17.05.26.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 May 2025 05:26:43 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v2 7/7] io_uring: add lockdep warning for overflow posting
Date: Sat, 17 May 2025 13:27:43 +0100
Message-ID: <19c0dd16ab837eda7e2f5276bf462f709ad23d05.1747483784.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1747483784.git.asml.silence@gmail.com>
References: <cover.1747483784.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

io_cqring_event_overflow() must be called in the same CQ protection
section as the preceding io_get_cqe(), otherwise overflowed and normal
CQEs can get out of order. It's hard to debug check that exactly, but we
can verify that io_cqring_event_overflow() is called with the CQ locked,
which should be good enough to catch most cases of misuse.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 0e0b3e75010c..7f6b1fd37606 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -737,6 +737,8 @@ static bool io_cqring_event_overflow(struct io_ring_ctx *ctx, u64 user_data,
 	size_t ocq_size = sizeof(struct io_overflow_cqe);
 	bool is_cqe32 = (ctx->flags & IORING_SETUP_CQE32);
 
+	io_lockdep_assert_cq_locked(ctx);
+
 	if (is_cqe32)
 		ocq_size += sizeof(struct io_uring_cqe);
 
-- 
2.49.0


