Return-Path: <io-uring+bounces-5048-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 138AB9D8F91
	for <lists+io-uring@lfdr.de>; Tue, 26 Nov 2024 01:33:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 84732B22FC5
	for <lists+io-uring@lfdr.de>; Tue, 26 Nov 2024 00:33:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB2D633E1;
	Tue, 26 Nov 2024 00:33:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fRHFC2OE"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 324AE8F40
	for <io-uring@vger.kernel.org>; Tue, 26 Nov 2024 00:33:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732581226; cv=none; b=dkIzaXEJo0BkMtgsHpiCX+nikBrlenSHfscyYIYtlnKgaRsh93feXmeaatTmzNmlLjWEAar3c0vXkEgY4rAu3JWC9b1wrgr+fq34eJx+p/u4st+RjcoicHvqtLbThAuSRLIZqa6nkUi6BrK48NhNbIcPkurvWd2A27m8hJ7qJro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732581226; c=relaxed/simple;
	bh=xh+BgNt7T7x8KYqx0WdQzcMC5Netg3UpuZcOl4HRWIY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=S4u3A4DnIT1JGUv5d+ZudCGWEdAfraAmkDR9DA4KxPTFv8WzltaCPB3mtt+p1wqyRwmA7MXdynWyrUhehZ+LRUsgeYMghahmgXyHMQ2JjZ+QU0ewm8QJyAM2Csd91pg/vLbSyOWtNlmmd4zngeZft6UbHsDdgIvdQBPbSpU4wHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fRHFC2OE; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-434a0fd9778so11171205e9.0
        for <io-uring@vger.kernel.org>; Mon, 25 Nov 2024 16:33:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732581223; x=1733186023; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=EPUrcPHSJaKzvH/I9dp8JZ8VkmU6A9g6QAxHuraeyE8=;
        b=fRHFC2OE3yzPt8L++lDdsO6Cx3rUhXqnsfDEGVhakbjkAMtUFcnF2NVCZ1l64Wff6D
         wrLd/pZ6YGhq4FSQ8re5kiCnFPWcQO30StV4uY3jd5ZKXNbGq6tpXG28A28ZZJWB1Ogs
         mkHDtfqk9EKFhihbTHeLKJ9oj/g2Qbqr3iAKWldQZBmxmN+Cuz7AxPoC/I7SpkXh6WiR
         3FZ7GteJRJTkCS/lnloVmnb+mn4mQWPXi69FtfCJz3la3LJB8RYS1cWwF6xnPlvSfMuC
         LhMMqrNvE+kNNYiBe8U9FG7LS+mRXlOARIr22w6HwZ87gtQsZnJUe2J8YcbWloccIkDd
         aAYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732581223; x=1733186023;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EPUrcPHSJaKzvH/I9dp8JZ8VkmU6A9g6QAxHuraeyE8=;
        b=oMYcAzaNm90quKQnCIs2N9L0iO5By0d3PVeob61F+W1hVfVotA0GtVsAGN+kJiYe19
         hs9SnKvher4qLPk6ZsihUpQ/jQL/fkEYKhiiZK0cRIO5WitnBMlOd1PX0M1dt7ymRXVv
         3inNwI/BZhJVmufEoU0ZR2i+Qwu6sV9ee6AI5q4adWZG22wcqokSnq76fY+d3GQqWsmj
         lRvsRbh+jTtboXET1UiX2DpjwbLcCnk84Emq40r3jfIYWmcnfcbmgUDSVrtwn/jjHc5A
         Lu8jBWtZv897250Jgo3H0+6VQFQK6tzSPtOXB02WyLO5s50llEDkSqrfc5Lo+jpCWS3v
         lc4A==
X-Gm-Message-State: AOJu0YwTLGQIhW/iu5syfhA5BF2qSnMSHCb/J7UR9HSH3IEO5/357dPp
	EEttVArEmZsCSgXqsRc+9RoK9zy6aq9OILCypKBpBvAwQ3VCMttPPiIbBA==
X-Gm-Gg: ASbGncu+NqlJbwBoaTHZpfl6geBO5LwxxeHJDROgOvkP7/N+ucKAcPQLG1IvKymnsD8
	XzPSa1jq4NKtKUQajLW4ZpYGBIIYbArOLanWRdVbwwNlV71LTRg5NI6Agj82GAv2mPqGZlbIlEP
	d1b/HvaOxoHwQjahBs8+eq62NkxYsx+OGevA752ZedtExIhBjJwV1vQmN8l/WWfnAyowxOvUyOE
	PewZdrbx/fZIkGKpSahisODFjvpM/eyZZ8nMYUxvhZsg2dDZxFaUGAP6dnn4A==
X-Google-Smtp-Source: AGHT+IEp+/N9VD9nHAd7OedT2NjJouJ7s65LpXzEIyyL5JtiSSadLgWjADlK272xJAt/UjuDm6zBeA==
X-Received: by 2002:a05:600c:4712:b0:432:7c08:d0ff with SMTP id 5b1f17b1804b1-433ce48ee2amr111951145e9.23.1732581223068;
        Mon, 25 Nov 2024 16:33:43 -0800 (PST)
Received: from 127.0.0.1localhost ([85.255.233.86])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4349de9d6a5sm69077635e9.20.2024.11.25.16.33.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Nov 2024 16:33:42 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	syzbot+2159cbb522b02847c053@syzkaller.appspotmail.com
Subject: [PATCH 1/1] io_uring: check for overflows in io_pin_pages
Date: Tue, 26 Nov 2024 00:34:18 +0000
Message-ID: <1b7520ddb168e1d537d64be47414a0629d0d8f8f.1732581026.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

WARNING: CPU: 0 PID: 5834 at io_uring/memmap.c:144 io_pin_pages+0x149/0x180 io_uring/memmap.c:144
CPU: 0 UID: 0 PID: 5834 Comm: syz-executor825 Not tainted 6.12.0-next-20241118-syzkaller #0
Call Trace:
 <TASK>
 __io_uaddr_map+0xfb/0x2d0 io_uring/memmap.c:183
 io_rings_map io_uring/io_uring.c:2611 [inline]
 io_allocate_scq_urings+0x1c0/0x650 io_uring/io_uring.c:3470
 io_uring_create+0x5b5/0xc00 io_uring/io_uring.c:3692
 io_uring_setup io_uring/io_uring.c:3781 [inline]
 ...
 </TASK>

io_pin_pages()'s uaddr parameter came directly from the user and can be
garbage. Don't just add size to it as it can overflow.

Cc: stable@vger.kernel.org
Reported-by: syzbot+2159cbb522b02847c053@syzkaller.appspotmail.com
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/memmap.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/io_uring/memmap.c b/io_uring/memmap.c
index 2b6be273e893..57de9bccbf50 100644
--- a/io_uring/memmap.c
+++ b/io_uring/memmap.c
@@ -138,7 +138,12 @@ struct page **io_pin_pages(unsigned long uaddr, unsigned long len, int *npages)
 	struct page **pages;
 	int ret;
 
-	end = (uaddr + len + PAGE_SIZE - 1) >> PAGE_SHIFT;
+	if (check_add_overflow(uaddr, len, &end))
+		return ERR_PTR(-EOVERFLOW);
+	if (check_add_overflow(end, PAGE_SIZE - 1, &end))
+		return ERR_PTR(-EOVERFLOW);
+
+	end = end >> PAGE_SHIFT;
 	start = uaddr >> PAGE_SHIFT;
 	nr_pages = end - start;
 	if (WARN_ON_ONCE(!nr_pages))
-- 
2.47.1


