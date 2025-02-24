Return-Path: <io-uring+bounces-6682-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B245A4275B
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 17:07:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 144317A8D21
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 16:06:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 411D926158E;
	Mon, 24 Feb 2025 16:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="M9I97/EN"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 664C725A625
	for <io-uring@vger.kernel.org>; Mon, 24 Feb 2025 16:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740413200; cv=none; b=OUkE+V7YyDnqI+PwzKYwMvE+syR5HLtxZu2Qj9MYngLCBrOHui1qh+3DEpV+z0TAHSJYLKHiYjtcjMeXlVJJLwd+xhqotGCmc+3giCQuho7LMAInC4SkqOysc3vDrzM+ESwlYEdGL+UiNcRDWQalf11I6x3Y0vYqsHznjv+HsLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740413200; c=relaxed/simple;
	bh=JmJIAh32myNNvoDyHd1rD5NGh99j0D+7ZJU8Yx75BOQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZOqb98C8HVN7BCLtvfy5P+9gIhASBws1mLvMjFIGqMspfA4HOgMMG19WVICwaJsnUjh9MC4ZoWl7v7l4BR4JK+OqulYYPTPn/LoCREuhUhQsA0XjOlzrYA+eqyPmx8ZpjaMCHQcRoTDUcZGyk+dUdVc2W+4jyIohRYFDkOW1+9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=M9I97/EN; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-aaecf50578eso901634766b.2
        for <io-uring@vger.kernel.org>; Mon, 24 Feb 2025 08:06:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740413196; x=1741017996; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IqBysNL4N/FiHuDdD1Yn9dA7GNQUgwsmQ1Zzh8zAUbU=;
        b=M9I97/ENqcSf3jfTCmw3lJyGwgONofNJij3zmxFOfocbYzLlxXHgjK6famCbND9ykW
         ZNK1kImdYFl282spOs2jGJ1CqrIq0v+Vq1H8VTg0wQfA232kx2I9QoZbwpFZqd4cAtKw
         o6CyTEmouNZZ99pMvjJPAAZWwZcjOH+JHJes2oiliWD6W5ZDM/zlQOHoupgMX2CR4X+U
         5INw/lKa7/znYIZkl6D+xL303clTXJ0GRnVwpFCLqS8c5cn0xzpGSEdhYaQtDfuDFGTd
         z+D2ZdZjXEk/LkajU/ScY1SEOGiFVZ1nTSJhwgs8nxABcV5gaEGwgwk28iWErlyHf5j5
         y0qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740413196; x=1741017996;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IqBysNL4N/FiHuDdD1Yn9dA7GNQUgwsmQ1Zzh8zAUbU=;
        b=e50Ht7yieasG7sRDssilwEQkCIAF/uKGqqpHvkD6GGE1ReN0a2Xep6eXp8vY0cMDsm
         9fpD4p57XU1DRBpu/+2ytJxAJg3LcRCTdXqgXLiaNVIornFfcWlgjVjqrqkLlXfQ/qCR
         38odTyOshRy3CXoGuYloaYCpp7NZQdfnNZwe/mVfbQ0kS/jS5jNM+xq+Nxc5jyWIatnh
         KOlxoPYgrpv5DhD7DmivzZllv86r2uCSrvV3uHvR/noRbTQVzMjPlkz4ajOT39A6mBTJ
         tOo1DgFUXPPTRDjrCgQq83MqVOAiG41GhM39kEsXzZxCsA5gBfhIA73BIUK59CnT883g
         Kueg==
X-Gm-Message-State: AOJu0YyIeeabGZ2Bh9S8pV0oOZYItMCJys3lNL07AvDORy6OuXmNWYl4
	XFm5zbGDGUHJAt1LijZ6bYYJuHovGspIP2LnmOrSm8E98ADBrqSz/ouhRA==
X-Gm-Gg: ASbGncu4CGa9Dsf4ggXwMmV2WYZfsIt5IIEk2u60HKhJ2Ef0JhZdn1WKIY2UG+hd7ZB
	EI0ZAxHxHYKCauxKTeQ7gv5wyDS9Q5kxkrHr0o6/SBL1NYRLZBKSeFdqw1P+u+VlqQEcXbj3tTs
	sqxPTK1c3gNxhya4ra8bvCgt4tkR1iKNJjk99cc+FtdPJT4I9WXdB3l1ysmZDMuOaBrEo3rpg8Q
	D+w5ukxm9VdEbFfrmg4HRyid2BRfsXzRbsCLkJH7P9cLqfiAUeHHD5f7n49hkuXMV5VykCDCH8w
	G0b5HsGWpg==
X-Google-Smtp-Source: AGHT+IHk7swaQCLWHaTkBo8uFir+pbTMZ+A2SIPZjEnaxJwog1tewwBI1KnRObGqllTHGw7iUX1K7g==
X-Received: by 2002:a17:906:3119:b0:abb:d04c:6947 with SMTP id a640c23a62f3a-abc0d994a14mr1034640366b.8.1740413195944;
        Mon, 24 Feb 2025 08:06:35 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:bd30])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-abb95cc7451sm1664684566b.92.2025.02.24.08.06.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2025 08:06:35 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 1/4] io_uring/rw: allocate async data in io_prep_rw()
Date: Mon, 24 Feb 2025 16:07:22 +0000
Message-ID: <2bedcfe941cd2b594c4ee1658276f5c1b008feb8.1740412523.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1740412523.git.asml.silence@gmail.com>
References: <cover.1740412523.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

io_prep_rw() relies on async_data being allocated in io_prep_rw_setup().
Be a bit more explicit and move the allocation earlier into io_prep_rw()
and don't hide it in a call chain.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/rw.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/io_uring/rw.c b/io_uring/rw.c
index 22612a956e75..7efc2337c5a0 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -203,9 +203,6 @@ static int io_prep_rw_setup(struct io_kiocb *req, int ddir, bool do_import)
 {
 	struct io_async_rw *rw;
 
-	if (io_rw_alloc_async(req))
-		return -ENOMEM;
-
 	if (!do_import || io_do_buffer_select(req))
 		return 0;
 
@@ -262,6 +259,9 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	u64 attr_type_mask;
 	int ret;
 
+	if (io_rw_alloc_async(req))
+		return -ENOMEM;
+
 	rw->kiocb.ki_pos = READ_ONCE(sqe->off);
 	/* used for fixed read/write too - just read unconditionally */
 	req->buf_index = READ_ONCE(sqe->buf_index);
-- 
2.48.1


