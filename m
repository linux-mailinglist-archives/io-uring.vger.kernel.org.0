Return-Path: <io-uring+bounces-5617-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C88189FDBC2
	for <lists+io-uring@lfdr.de>; Sat, 28 Dec 2024 18:36:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BCE3A7A112D
	for <lists+io-uring@lfdr.de>; Sat, 28 Dec 2024 17:35:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8557118C939;
	Sat, 28 Dec 2024 17:35:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IvZjVBzh"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5F20190468
	for <io-uring@vger.kernel.org>; Sat, 28 Dec 2024 17:35:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735407358; cv=none; b=qNEY8LuHZoFFuHVP3phz+kIYZEUg7Bt7ih1xn3BmTQ5aPwAtzYg8w08quNT00t5ScdkFp3xeMlEFAajDhCyreuLeqWO+IMf2dhuT6ZJSQncOKszA2H6NcH16MyuE0cc5r4pKB0JgiVCIlLWzLo3k4o28BQCtz/TH3rm0ZYPdZGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735407358; c=relaxed/simple;
	bh=wVtG8RZTdzfojjxjVDb08uOHNZqKQq4AG2vs1DsXkNI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UA5AZo/eI8jMjyAI7sWzWRsYYm8na15FQUaSHWbptdmVvtF2TSRO2E5a06qNqzAIH9OSUMhGk/81W/6qeWlU3f8Lb6Ap0lm5g8ikkb6NCZjj8UK6Lr+csEKe0XzLMbM7zI9PhEhcujXbIXoxsui913YdkJoHDwS0EYjiDJEeAl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IvZjVBzh; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-435f8f29f8aso58392395e9.2
        for <io-uring@vger.kernel.org>; Sat, 28 Dec 2024 09:35:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1735407354; x=1736012154; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=2d6Kzd7WOCWi+ZQYpHuOGRWN6KdesE668C50bh0DRto=;
        b=IvZjVBzhtot/lPlvmcajeg1DdEnEFArkhWeyLkFF3rzHGpYTPpFUbjkicFmZIZTTQ2
         DITd1myKjgAQIbsK+uMzku4QsaIoXb6cCkd9tOeh0asr/2AubUlL27DY4QgORTEpDrPg
         ubz7+H5Qx6jsbA1ZSdLQU9t5zp+B99G6Jfk1wT2vTxMR96A2Ren2UJ9l3aWz470FdbkH
         A6EJjvh0jC+ubTBxezsEn9Un9H2hRKz/EFGWZ5D2y9+TEtM29NoVPziJ29agCdXjZ+rb
         FBgf9QBJDHsQeWdmbJqqUn6eFVcKPZZGVsCwcaGersXhuhGiT7ZE3qkQIe1lo1A6kO+P
         SmUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735407354; x=1736012154;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2d6Kzd7WOCWi+ZQYpHuOGRWN6KdesE668C50bh0DRto=;
        b=CfXUEIZcaA/R65KvpJ3ip/X8kvLELKOcuwkuGCV1bMl/D0g9rIrvIBFVnWMGrWwPUI
         7tjYLcY0uLrJz8D64Vx7MYVwV1mV547QYQ+FeW8SazpXMvhw/VHz1MJ4r0c0Bwalkv+l
         RQ3pmO+ERnJ8+77QKvxZnR2ti+bMl9o4LlqM70P7sKJ4cvNSC4VWWg5wzzo+yLkge2z3
         qJ/BGhyKX2vWLbFbt/jLeene/egnYW63RsWcMDd/I7VNJs04iMPh5oZ8uNaNIxvl4Pjn
         Ji6IxoX/ml97GvhlUaAE7ogvkTQBS156hg94FJEDrIdpg2foRxIkuebRUsmzmfC4on4X
         R+HQ==
X-Gm-Message-State: AOJu0YxyvXpw3TELAijAhhL2hmvKl1isQM4vYSaKi01DuJajlT9Ey8SO
	r5V8w3GlrJoD8vW18RTEAbyyaD1HQZNAfZ+xWfIWq8cqqVgpXEqnYscagA==
X-Gm-Gg: ASbGncsdmFNZp4eKlS2jbiFnaiDJF96yQKueu0O2Nl3Br8C0H1ust6mxAX1QHajek6w
	1B4Sl143VLDS5ZPWQOMgFyi7vd92v4X5c03JqySXbGSaJz62Ubi8W1St8XBJj3A9++tMK4I84E9
	hOzJVc5R6VjzllKLdgZQ3YbUN/0WSs/5/GCTeZvFK/zn9hQD8HbP5ix1/So/XGr/2CYif9zbipN
	mGWsPwuBEcI5ke5FE+ZgQr3ADwn8XLpqO4hAkiqbZJF9+ntehYJcUHhiQAdWAwfTCvax64=
X-Google-Smtp-Source: AGHT+IGml0YE6ClmrHBBrtBG4M0pIR8Fauck4q4cp10qfbqIC95KeY5RRATOnqzPkyY5VFyqv8gE0w==
X-Received: by 2002:a5d:47a9:0:b0:385:d7f9:f166 with SMTP id ffacd0b85a97d-38a221fa11cmr22647082f8f.17.1735407354132;
        Sat, 28 Dec 2024 09:35:54 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.146.249])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38a1c89e4ebsm25504835f8f.85.2024.12.28.09.35.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Dec 2024 09:35:53 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	chase xd <sl1589472800@gmail.com>
Subject: [PATCH 1/1] io_uring/rw: fix downgraded mshot read
Date: Sat, 28 Dec 2024 17:36:39 +0000
Message-ID: <594cc3cae8b479df473ac7711ede07e85bc6e266.1735407348.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The iowq path can downgrade a multishot request to the oneshot mode,
however io_read_mshot() doesn't handle that and would still post
multiple CQEs. That's not allowed, because io_req_post_cqe() requires
stricter context requirements.

The described can only happen with pollable files that don't support
FMODE_NOWAIT, which is an odd combination, so if even allowed it should
be fairly rare.

Cc: stable@vger.kernel.org
Reported-by: chase xd <sl1589472800@gmail.com>
Fixes: bee1d5becdf5b ("io_uring: disable io-wq execution of multishot NOWAIT requests")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/rw.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/io_uring/rw.c b/io_uring/rw.c
index b1db4595788b..c212d57df6e5 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -1066,6 +1066,8 @@ int io_read_mshot(struct io_kiocb *req, unsigned int issue_flags)
 		io_kbuf_recycle(req, issue_flags);
 		if (ret < 0)
 			req_set_fail(req);
+	} else if (req->flags & REQ_F_APOLL_MULTISHOT) {
+		cflags = io_put_kbuf(req, ret, issue_flags);
 	} else {
 		/*
 		 * Any successful return value will keep the multishot read
-- 
2.47.1


