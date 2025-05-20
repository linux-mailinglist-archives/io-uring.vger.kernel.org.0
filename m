Return-Path: <io-uring+bounces-8048-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CAEEDABE3C5
	for <lists+io-uring@lfdr.de>; Tue, 20 May 2025 21:33:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 78D8C4C104F
	for <lists+io-uring@lfdr.de>; Tue, 20 May 2025 19:33:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0354326F473;
	Tue, 20 May 2025 19:33:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="ZaJpf29t"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-yw1-f227.google.com (mail-yw1-f227.google.com [209.85.128.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA5461E50B
	for <io-uring@vger.kernel.org>; Tue, 20 May 2025 19:33:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747769625; cv=none; b=QZlG6ypY+ZG8PP8syc7QIv96Vlj5724mzFSqZhC5+FwPoY0x0DWgMwPM467kqCYi+FWLmxOHvSsEK2TErD1hNDYc6/W1HpwVN4k0dRGNm9iSw+GZJYO5KuEdK7irFUgogrdyJdbP977U3915JLZ70bSxtN7cenwaaC9WZ+YF1oE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747769625; c=relaxed/simple;
	bh=l+qROxyg0ykG2Mdiot91acNqc4DuZpFYb+lXFeYrL9M=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=W24OpeDQtYkEfm+ktev/BkYJmEAGMf5DC1IfyRfT/49xxIPkvEcnYK7SMF1lI5fGY3yW6BRX/M1DDXFj78X5EZYBwo7D0gfQQlaXXXL819BMXzOgVAhNDmBcjeDy4Bq7ixz4RDRgT3lYzg38APn9+2ot4nVoXc8UZEWhRrHbdo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=ZaJpf29t; arc=none smtp.client-ip=209.85.128.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-yw1-f227.google.com with SMTP id 00721157ae682-70cb8b94416so2950937b3.0
        for <io-uring@vger.kernel.org>; Tue, 20 May 2025 12:33:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1747769621; x=1748374421; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=6mWsxB/jvz+1DvjRqofhZH3x2dukYd3c9R9FoQWshso=;
        b=ZaJpf29tnEy0P00YIglsr/wr2nAuEipKt0gvk3ukCjM9A7vt9qFHFjfFFiPcbbOI/r
         GjpHVEU4zQ8vwDTLkiNBHq54+C8gzgavHeBF2R2AfivdWt5keJXr+kdkI489AVt5UXeq
         hxFD/CmYazLpQDoFBa2XPbHF0CSctuBIzK8zvv1chxXHXq3sQfNiCO0RrWppXEmM8gjo
         MhKO8SzeaoK+fr5QQLU5x2RpsVsxJccfHQDBpWaLCVEKYLcRjBOA4DsKj8EogEwbCWYm
         iXzVtDFlEwIGHnmSZkzdPck6pscr2Y9XSvo4Pxnk54dWEGNPOjwKn/Y3Nma7hhVWpLS+
         b99g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747769621; x=1748374421;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6mWsxB/jvz+1DvjRqofhZH3x2dukYd3c9R9FoQWshso=;
        b=cMTQ18qyGefXxeuMlSlpyT/GvTkJD0TU0JGctwtCk0aSjaFexZ32r5BVQbC4upUxif
         lHcSpiu9cJRnC3WSL7JplvLMku74EpSUX+AC18491HHVncCmi43UKs4/rMcaz0fz8ueD
         PCXRxqpp1HgGEdgjCPAqFLk0oWU1cEUgh/LCsWKRBNpaMA2RAav6P7fEfFbWxOvl7a89
         cBeDNLLb7yoNUZqzMe4+swR1WAfktNbLGjyYl+Jz7VXtDWbA+iPCd+yOCvs5HdTnifr3
         vS5hzEeA7fGfQzzmfEcDJu6BnTpVUrvroqwrx++G1oadOvAwgyWauY7KEZ1mVwwCJJr5
         OLzg==
X-Forwarded-Encrypted: i=1; AJvYcCVM5MoLtj2AttGSb194qVygqH1pN4HpHxKNn1xzz+l1ogUy5qxpsbRAvOOr9BTWKl1wU+/b6RJfPQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzgnVeMcPYpe7wBBKh7i8uNBdOOOGro3HayWy4Wf1tJDpzKDnuH
	nAIyfGoQF+80s+KNvsaaTz2D4E7xYlgZ9PGtPwtnVvFxooctDYnAoB0dCsDVij4wuy0tkcGbh30
	KjWSnTa70F7W2jA1gUrZT7wUJdZAWCT+wva5QEdvXg4g72pCBe9Jb
X-Gm-Gg: ASbGncsbm3KJ8sHf4uQYTF57ox0Ph2O/iENMgEtV6ZMY/gg3IgzKCkqFOPvk92Sbvgx
	64f6ZCQmnt9zC1wtEbO0y5i9k/LAyXRUgw77at0ea00chmf/il+gmuA0WqNZa2OMem7RDei9Hsc
	tppZl6dGnsnJCprIUylRyE0vwwsvm6NoJsymF1b8GfmnB+VKhm5XKH1rkbfKgI4aXoELZsnVXBw
	iI8GUrXDSZpX0dHOcvi43IwW4sWifF4iJD88XBK6BkhJC6ov8LvrFS5K8vHtQyNSNOJhHb9LfWs
	ZlxOVtmBWXD2TTTNfjXzgpxXRG/jRg==
X-Google-Smtp-Source: AGHT+IEUva7c4rpdUdj0LTfCEBCJ0Q+y2yyHuXGIJcNMe/w5WuNfZ6Q+mBZ5Es7cTzaGxsdJNmpHcyG2e6Ch
X-Received: by 2002:a05:690c:74c8:b0:706:cc3d:61ef with SMTP id 00721157ae682-70ca7be358emr131945217b3.8.1747769620584;
        Tue, 20 May 2025 12:33:40 -0700 (PDT)
Received: from c7-smtp-2023.dev.purestorage.com ([2620:125:9017:12:36:3:5:0])
        by smtp-relay.gmail.com with ESMTPS id 00721157ae682-70ca84bee70sm1876407b3.52.2025.05.20.12.33.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 May 2025 12:33:40 -0700 (PDT)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (unknown [IPv6:2620:125:9007:640:ffff::418a])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id F1119340441;
	Tue, 20 May 2025 13:33:39 -0600 (MDT)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id E3389E41C7B; Tue, 20 May 2025 13:33:39 -0600 (MDT)
From: Caleb Sander Mateos <csander@purestorage.com>
To: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>
Cc: Caleb Sander Mateos <csander@purestorage.com>,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] io_uring/cmd: axe duplicate io_uring_cmd_import_fixed_vec() declaration
Date: Tue, 20 May 2025 13:33:36 -0600
Message-ID: <20250520193337.1374509-1-csander@purestorage.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

io_uring_cmd_import_fixed_vec() is declared in both
include/linux/io_uring/cmd.h and io_uring/uring_cmd.h. The declarations
are identical (if redundant) for CONFIG_IO_URING=y. But if
CONFIG_IO_URING=N, include/linux/io_uring/cmd.h declares the function as
static inline while io_uring/uring_cmd.h declares it as extern. This
causes linker errors if the declaration in io_uring/uring_cmd.h is used.

Remove the declaration in io_uring/uring_cmd.h to avoid linker errors
and prevent the declarations getting out of sync.

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
Fixes: ef4902752972 ("io_uring/cmd: introduce io_uring_cmd_import_fixed_vec")
---
 io_uring/uring_cmd.h | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/io_uring/uring_cmd.h b/io_uring/uring_cmd.h
index b04686b6b5d2..e6a5142c890e 100644
--- a/io_uring/uring_cmd.h
+++ b/io_uring/uring_cmd.h
@@ -15,11 +15,5 @@ void io_uring_cmd_cleanup(struct io_kiocb *req);
 
 bool io_uring_try_cancel_uring_cmd(struct io_ring_ctx *ctx,
 				   struct io_uring_task *tctx, bool cancel_all);
 
 void io_cmd_cache_free(const void *entry);
-
-int io_uring_cmd_import_fixed_vec(struct io_uring_cmd *ioucmd,
-				  const struct iovec __user *uvec,
-				  size_t uvec_segs,
-				  int ddir, struct iov_iter *iter,
-				  unsigned issue_flags);
-- 
2.45.2


