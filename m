Return-Path: <io-uring+bounces-7941-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7AFE1AB2717
	for <lists+io-uring@lfdr.de>; Sun, 11 May 2025 10:00:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DD6171896F1F
	for <lists+io-uring@lfdr.de>; Sun, 11 May 2025 08:00:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12DA217C210;
	Sun, 11 May 2025 08:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PJZxR9yd"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44E951A76D4
	for <io-uring@vger.kernel.org>; Sun, 11 May 2025 08:00:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746950423; cv=none; b=JfRjc6chvI/YvmzyAAuf6g3o1zQaaBhKFSYbXzMDH94a/1XsppMyeA3bgee/YGOzLy6ylMi8tVlm8UQakcloEePMxwMrOf4wIglv1E7ZjFPIi2e+86sUQNbTtoGuYSELLl/lnaIsJp9asb1KY4Bx/e2OhQnamMsHgznejlPdICI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746950423; c=relaxed/simple;
	bh=410DiToQau1LlFkv9tBaFFbH32yPc0cG0ijXtVjC87o=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LUkWMWdbsvPg9adAXTJ0Dwez5iiX8sWqhQ3yYjOI+hkLoild3JsfG6Reo0mIdpQlFs4v27FSCu0JIy+NGUa/C+H3BeaYFu0mfRnJ5A0n1X67LxEcu3oAYnjysei38qYZKDasS/MXxPAfmgBJQxKKfhxjovx35WYyQvwObAMtvbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PJZxR9yd; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-3a1fa0d8884so1160729f8f.3
        for <io-uring@vger.kernel.org>; Sun, 11 May 2025 01:00:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746950415; x=1747555215; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=SfLLIQV62cnCOkQSEdkdtWwIbkFAh81KZgiHlxBH1Cw=;
        b=PJZxR9ydfZ5f2yYUSkc15i/zCLsKtfVD/BZ8/h98c4wBz6P+ng+CYJ97rbeHz998J4
         z/XLbZukIyeX5nZrDXmA9Jv0F9yuBejRhO1UWK6nEipMINzjO2jxyjmk6BzOz2aRSUoI
         SSFocCZbzdMyApk5pAK14Qa4zHU8GZRfIYImp0Ql6ORf8uNhOFZJMt0/kQm8DvvhQaEJ
         JEACQxyj4ZmsTgZ92J7wDvKomQjcxKT/yr7kp7xdg3Wr04i/GGObecYN3RkmLug+J5jX
         uyBrhCkDRqJnp9yEKzcUjgGKjq7XY+xnlLvxvv2j4IArUhPgA1gHuUP7AS5hz0iUNdC2
         ysfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746950415; x=1747555215;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SfLLIQV62cnCOkQSEdkdtWwIbkFAh81KZgiHlxBH1Cw=;
        b=jOFAs1+unjLoGS4JjYxGlJZMGA5mrkfJN5qJa0Itj6V+HZ3+MxTIt/sACQRbcSi9F8
         Hx9pv0yEUMwqDIQCxhw+mHd9Wgol2mfBERGfSvFJ9A6GDOp9QxbIZQo5jqhCWFsQ9Oka
         o8uoq8pMSHiG2n3EawOmglqeX/3b3fJ4WuVulPl2cou1HZjI7Sbm+NRmDgdsS5FjrimE
         mSCsEtuBW6Xynjrnbqm+bfxuG0V44Q09VSfrBLojQt18qZs25JroLtDlWiVY22g18PK+
         3VcgzyGACgX/cz0X479wtfcUXqB6072fQCcat7AVRBBQKgxHE6DonIgKHzCipGt8UB3l
         BAeg==
X-Gm-Message-State: AOJu0YzpApNTKj9gy5Mp2oh2PMeVJZFZKSo5UlwdVPvetqgzp+D6Mqfq
	I7rC2SLVJqurBqWpGrOjtt9a5O44KCSQmpSFzZVMSysDa2vDbqfNio5rZg==
X-Gm-Gg: ASbGncsI+yUeEC4FcuXXy5CuepovUZp6Rca5VlPZ3vdUHrMkJxtxU2cdbb7w3NVd+0f
	BaBlu9XGQ3pE+Rt3Te2kkTMJR9B2cG8ks85BGKnq4kQBSM3+Ai2W4wKFqVlFQNTrfVzgZx3R5ME
	mdNa6eKyQ4UPTBM1T5HfDP5q6RpDsBj5rFM9/MEa0d06TenJMXwEMgo82B0PifJXkhsI/5Fke3B
	rs36IqmbdkPO7b2zMJc3+YdCLO22luyJw3okCH7UT7Rht2BkcckHTQcLwiz9DZQyymKgOGiByii
	dPRy+hkC0jw5olyuQboUgBpYqLRX+8CZ/Kf3j95wdZFtZQ2LFQW4q/AjjqkEgSMZ
X-Google-Smtp-Source: AGHT+IF5qsNs5nSlqeKBAuA1mbtowqE1g77vHARzaJEAlZMJKDVPvD1+Dv1DrE6aKNKrJx8YZBfkuA==
X-Received: by 2002:a05:6000:2207:b0:3a1:4c72:9072 with SMTP id ffacd0b85a97d-3a1f6438490mr7657759f8f.17.1746950414671;
        Sun, 11 May 2025 01:00:14 -0700 (PDT)
Received: from 127.0.0.1localhost ([185.69.145.145])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a1f5a2d37fsm8651720f8f.68.2025.05.11.01.00.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 May 2025 01:00:13 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH] io_uring: remove dead code after drain rework
Date: Sun, 11 May 2025 09:01:23 +0100
Message-ID: <24497b04b004bceada496033d3c9d09ff8e81ae9.1746944903.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

io_drain_req() uses a helper function for counting the number of
requests in a link, remove unused open coded accounting that
was accidentially left.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202505100200.cyy3V6oJ-lkp@intel.com/
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---

Should also be fine to squash into the original patch

 io_uring/io_uring.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 0fda1b1a33ae..41f8709abfc5 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1649,8 +1649,6 @@ static __cold void io_drain_req(struct io_kiocb *req)
 	struct io_ring_ctx *ctx = req->ctx;
 	bool drain = req->flags & IOSQE_IO_DRAIN;
 	struct io_defer_entry *de;
-	struct io_kiocb *tmp;
-	int nr = 0;
 
 	de = kmalloc(sizeof(*de), GFP_KERNEL_ACCOUNT);
 	if (!de) {
@@ -1658,8 +1656,6 @@ static __cold void io_drain_req(struct io_kiocb *req)
 		return;
 	}
 
-	io_for_each_link(tmp, req)
-		nr++;
 	io_prep_async_link(req);
 	trace_io_uring_defer(req);
 	de->req = req;
-- 
2.49.0


