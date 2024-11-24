Return-Path: <io-uring+bounces-5010-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9ABF89D7837
	for <lists+io-uring@lfdr.de>; Sun, 24 Nov 2024 22:12:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 61199281B0C
	for <lists+io-uring@lfdr.de>; Sun, 24 Nov 2024 21:12:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D84DE14F136;
	Sun, 24 Nov 2024 21:12:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kowIrtKs"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 184FF165EFC
	for <io-uring@vger.kernel.org>; Sun, 24 Nov 2024 21:12:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732482728; cv=none; b=ndNQZJMlzlf0Q0/TOZf81U4t0gUj0fIb4+t7HPU5Co9SOgyoq3B3oTwtlKI5mTdgdznpz0Uahwok3/AxTr1L+dBPKL0YrqnzJVSpeHsm1IoeKYjvDF0dMaTjByXtFys1iDSwm2MqoA/MGq03xBBsblxTR6FdCSEmg+o+TIBG2eY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732482728; c=relaxed/simple;
	bh=1gdiLeCNSwVhK3nzWHMR4xFD8ClHJFNdvlyHODABro0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A0hefYjvqqSN2nPjRGdH79tuGB7qEVOj91AQW/8yvQ+z9N4Opq9IxoyTZKOINgr55yDCgu7mqKYi5BhOPd5zYqxFqYobn1fZoVLj9MuGHLQBilARlGNlmOUoz8x+rJx95OUWdHr0ErF7laKCzsyPTUinBIB6uyh7oWn4/XH/Efk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kowIrtKs; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-43168d9c6c9so34993105e9.3
        for <io-uring@vger.kernel.org>; Sun, 24 Nov 2024 13:12:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732482725; x=1733087525; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=usEgNxoUAlzm7LvnyJowdrWjygvIn9+DGkjQ7Uu9NSo=;
        b=kowIrtKsk1htJr6Rtl5vLTfbIf+RNfEUmzAMmirUcZot1JtH5heR9jbDTHlrOQODfj
         hiGs0m9Z22fNXf1AN9SNM4zL/dlnZ5yisjUeDcsvRE/Kxm/niGL9i6lAglSwamr/udlg
         uV9+GIbVxwEySop6Mbqa/B8rSjn4IYgxUZl4gsKqoYm3UqdIVgaJhm9oIaMMq+Ky5MHt
         dDbnDztI89zI2NETcPprAJk4NMjWxdFSPIoBUX13r/+G5yHVvD/C0OCqWqm/49coFkrU
         LFuoatO4mN6WOLxXzgjNvs30SePAmVw1pw9xcnaZTP0UozS9mifDDbgFGw6yL9ngIW2R
         uBFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732482725; x=1733087525;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=usEgNxoUAlzm7LvnyJowdrWjygvIn9+DGkjQ7Uu9NSo=;
        b=RyVjsSBEx8uYHu9M93Oj8oGELqyxPA6LX4ZSPwdV8graGIVMGK6eekXKXSIrR0n9D2
         sBLVQk+KF0eHWVjj2cHSIEGyaH/YY8f2a9D44tEpzxCH/jN0/ZKuYkfaNVjqmnmrm3+v
         VS4mp46/AgwGQoALd8QKWBgAjSpUAKkU/x2Y5dGiTgFP2x50aaAy7RZYujTc/THu/rnK
         LbvK8igmnrnKOd5SoNRekzpV5awemxx30rIlu0b5Dfqx81XX279ZldWzBd2OxFsVMbQm
         RC95tKM9Bk6G3fQaj+DissA7OsyfQQy6SmYqoiTi6VYl5B5hTFKK/5treTR8OeNTkGOv
         IRyg==
X-Gm-Message-State: AOJu0YytWWOFA6pdnRoR3TJzKUT42/ZLdwozHVSv8Lr4Aq+opeplzG7B
	VOtwk3A1ONpYUtcNJjesxm2naLQuusuDK7lUv6cDS2niwluzWhE3VB1PiA==
X-Gm-Gg: ASbGncs6lf6rTPpiLpF4J5HfC3wRJJZ5AG7VjYG+AO651aMmT1HlEcAX0Z0z6kWsyYr
	w3sNT1uyIRceAfcTTeGeK5VHjuu5Uoy/okzAM7c9+jlpz7WA92AnNEJUNVeORcK0WCRfWJkSTpi
	yzEhnxhisvrfmKZs7daPzcK1vxNp1UbXtQsetW29+9ye1tTqAYMwPeC+T+LlE0MG9cPzAKXYX7m
	wJDWk5EC4n9CC6zFNDsRX7qXmZR8pnlLgYbtmfWkCCD+xYjfOzEf3E/W0Xm0Yc=
X-Google-Smtp-Source: AGHT+IF6S6c25dScAr6hUeKDZYVyQyU446CpUJC+pjEmxe1svaNtuFSzcIIeLiF5i3Ao4SmfseEwIA==
X-Received: by 2002:a05:600c:3c92:b0:42c:b905:2bf9 with SMTP id 5b1f17b1804b1-433ce42883fmr102884415e9.16.1732482725039;
        Sun, 24 Nov 2024 13:12:05 -0800 (PST)
Received: from 127.0.0.1localhost ([85.255.235.224])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-432f643b299sm132733745e9.0.2024.11.24.13.12.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Nov 2024 13:12:04 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v2 04/18] io_uring/memmap: flag regions with user pages
Date: Sun, 24 Nov 2024 21:12:21 +0000
Message-ID: <29de51f8d8b328125f647226e76850b21f554423.1732481694.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <cover.1732481694.git.asml.silence@gmail.com>
References: <cover.1732481694.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In preparation to kernel allocated regions add a flag telling if
the region contains user pinned pages or not.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/memmap.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/io_uring/memmap.c b/io_uring/memmap.c
index 21353ea09b39..f76bee5a861a 100644
--- a/io_uring/memmap.c
+++ b/io_uring/memmap.c
@@ -197,12 +197,16 @@ void *__io_uaddr_map(struct page ***pages, unsigned short *npages,
 
 enum {
 	IO_REGION_F_VMAP			= 1,
+	IO_REGION_F_USER_PINNED			= 2,
 };
 
 void io_free_region(struct io_ring_ctx *ctx, struct io_mapped_region *mr)
 {
 	if (mr->pages) {
-		unpin_user_pages(mr->pages, mr->nr_pages);
+		if (mr->flags & IO_REGION_F_USER_PINNED)
+			unpin_user_pages(mr->pages, mr->nr_pages);
+		else
+			release_pages(mr->pages, mr->nr_pages);
 		kvfree(mr->pages);
 	}
 	if ((mr->flags & IO_REGION_F_VMAP) && mr->ptr)
@@ -259,7 +263,7 @@ int io_create_region(struct io_ring_ctx *ctx, struct io_mapped_region *mr,
 	mr->pages = pages;
 	mr->ptr = vptr;
 	mr->nr_pages = nr_pages;
-	mr->flags |= IO_REGION_F_VMAP;
+	mr->flags |= IO_REGION_F_VMAP | IO_REGION_F_USER_PINNED;
 	return 0;
 out_free:
 	if (pages_accounted)
-- 
2.46.0


