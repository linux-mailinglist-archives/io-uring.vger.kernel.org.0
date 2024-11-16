Return-Path: <io-uring+bounces-4758-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 11EF09D00F5
	for <lists+io-uring@lfdr.de>; Sat, 16 Nov 2024 22:27:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 67C891F234CC
	for <lists+io-uring@lfdr.de>; Sat, 16 Nov 2024 21:27:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 408D0196C9B;
	Sat, 16 Nov 2024 21:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Pk3Ex+aL"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91FF4199951
	for <io-uring@vger.kernel.org>; Sat, 16 Nov 2024 21:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731792434; cv=none; b=F5u4mMQM8nDW9emKQVcMDPs1R2qFkJNxmNqE4JBl9eOTLWXP/N0sP+N9TDFS/jaTYrIdQK8AT0K0YyboLOt0V11E3ZJK3FltzC3C6hG8Y/SnsT4Ex41hFi2J83l9XZqFOQeYIP6mQ9bHNU+5e53NaxM6V6cUj7THXE9bEziiEDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731792434; c=relaxed/simple;
	bh=EBjtApE+0ml2VVg5tZc0gb1Jm+KXzRBdLxw6ViaGhuA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bhhoN3o9Ei91TdYpXTnlBJ+khiCQXPLa2ofywe9HfmPVBaZzhYojKWck9e7od2Dd0nPoNbLsXJCE9TgrhoHfnFR9+6510+3xGJV7Xvgu3f1xtuOsX7HYZeZ7fuoXTGPAOzoxehAmALFhyqNvZVPtnp5/dAgVF1gOZ0FCtzqflWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Pk3Ex+aL; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-431616c23b5so16691355e9.0
        for <io-uring@vger.kernel.org>; Sat, 16 Nov 2024 13:27:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731792430; x=1732397230; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DOUfpRV7H9ek215nIoavPI9l7/2gX9TLCS2UpNr7zAc=;
        b=Pk3Ex+aLRc3laZBvu3/CedYXlYJNp2LMOdBSwlK3O92ySP5DtfN90MeRyLdq7RvcCH
         qCgi96Qb9KcDnad1YUyV6MAWwQIKnXLec9CttvbsLu6kNc724HSpZ+W8/cn+YPk6cheE
         zXZaMGPPmgtiZmzDp423r1anDIMNFuZxOn0HLxGgC1JUoQ1sEWsIwKHzsdRD1hgTcwN6
         C7DPCqJbZ9R1bcpHdBRHja6eMDMCCgUqhdN80NaLTdO+qzfl7c/eOykIM1fMip06keYJ
         ME+lD0jwSj1cIhWBbTWYjULjFbCYWAyei1y9MCb/XAXWHbfKNzoSoN0UU/EaDWYeLp3u
         200g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731792430; x=1732397230;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DOUfpRV7H9ek215nIoavPI9l7/2gX9TLCS2UpNr7zAc=;
        b=Ol6FQFOyIRaAfeIjP0NMf5eSB/Af28/I/QzpOQf4D87S6k44IRJf4/qxJx1uP/pnvG
         G5GxL1P2wVIhfYMWPWBo42nuxM1YfeF2rxeoUSa8V3rGebGmx466bVDHyWFCeJ0/sZhb
         gB/bx0X/KWL62raWpsWMWLq5Yqz8fte5bpk4NkEuB/xCjnLufqRJuZ8CmpsjmSG/by63
         aj6aPcVU6gnP6vRbijafMEZlvXlvCbpCzL3wO/jjkBFxtSLNMwEv5ygIo/BMhDCKjg4p
         Ll4yKwMlCEkqkxd/AHlg4OVX9i488MPT/fmGaYiVrlVCrhnQEmR7gUT2msIXHu+2XzUs
         o+IA==
X-Gm-Message-State: AOJu0Yy3pPcd6Rpb765ZGK7kohgLXR04/ws1hKqOXmddcfb3pC1v7Dpd
	v5Xa1RV0z9aJ4oJJxcpDEv5q+1OiUzuQjX4ygBZ7E8DSLG5cM/O4LQQJwA==
X-Google-Smtp-Source: AGHT+IF0z6m87URy1Xd5VUPGNw2SH/FqyT/guSTpCAv9RrRVk+tAPzM8nTfmQyXkeaZo9Rdji5oz+w==
X-Received: by 2002:a05:600c:1f88:b0:426:5e32:4857 with SMTP id 5b1f17b1804b1-432def7e5e8mr60412015e9.0.1731792429953;
        Sat, 16 Nov 2024 13:27:09 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.146.122])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-432dac0aef0sm101071325e9.28.2024.11.16.13.27.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Nov 2024 13:27:09 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH liburing 2/8] test/reg-wait: pass right timeout indexes
Date: Sat, 16 Nov 2024 21:27:42 +0000
Message-ID: <4a64eff75fbdd1fc93e1683f5b8b0f58794e27fe.1731792294.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <cover.1731792294.git.asml.silence@gmail.com>
References: <cover.1731792294.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/reg-wait.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/test/reg-wait.c b/test/reg-wait.c
index eef10e0..ec90019 100644
--- a/test/reg-wait.c
+++ b/test/reg-wait.c
@@ -72,10 +72,11 @@ static int test_offsets(struct io_uring *ring)
 
 	rw = reg + max_index;
 	memset(rw, 0, sizeof(*rw));
+	rw->flags = IORING_REG_WAIT_TS;
 	rw->ts.tv_sec = 0;
 	rw->ts.tv_nsec = 1000;
 
-	ret = io_uring_submit_and_wait_reg(ring, &cqe, 1, 0);
+	ret = io_uring_submit_and_wait_reg(ring, &cqe, 1, max_index);
 	if (ret != -EFAULT) {
 		fprintf(stderr, "max+1 index failed: %d\n", ret);
 		return T_EXIT_FAIL;
-- 
2.46.0


