Return-Path: <io-uring+bounces-6117-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 48064A1BC79
	for <lists+io-uring@lfdr.de>; Fri, 24 Jan 2025 19:53:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 55B9518904B9
	for <lists+io-uring@lfdr.de>; Fri, 24 Jan 2025 18:53:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBFE51D54D8;
	Fri, 24 Jan 2025 18:53:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H6NCs46k"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40A3B146A9B;
	Fri, 24 Jan 2025 18:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737744818; cv=none; b=INdKRhXogKLGX+xnPKr0WuuvW84fSbLAn3Vit9SMjqHoPONfD94YVBOaWix9LvftFlAbkHgsWgPVERXV2cGdrFnjA0ML7M/dl486lbyUL1knKsQ/Kfsk9UDVgQLhNxVFzWCvGH/o5XecbO4IokJXFie+iOtz+DyBFmSWS+x5X/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737744818; c=relaxed/simple;
	bh=U3qVEW0/wa8Sw4O5Zk6F+Bi7rQA/gwwJ+Q3Zs0TVniQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IKXoQOFbUoV1+GJisJnBMaP8lw8lvZcUwnjsAxizhDnYpw6ZOC2SI2fa4wDaZn2ciARb/ovJ+MFPB1wJMfMRW3DumcfSqU9yhKynSTbNMkWvq1n+zCYjyhuRNFCyUeBnrbESUR8h+LzU6mZ5IwFXcAN/A7O7a8vAqk3ZVBqphnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=H6NCs46k; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-436249df846so16640105e9.3;
        Fri, 24 Jan 2025 10:53:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737744814; x=1738349614; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=XMLPuUT3d2AnF2eXRgJOzlbcZfjko/BgkONjKBbrmiY=;
        b=H6NCs46kSUMAc9OC2S/Bd5x4QW+T20v4p52TuWjqL8oV+vAb+uuNTPFoHD/iDAEkTC
         MXcdxKKKVx+xMHsPOZEhmv9bc0sB8ghuCsfcbogM9pT4198uycCl7YlNzIiGF1W3sIya
         Va5mlrXb4DT+dqUvHuFp4aiUkSgnJcyqWgahLXwgfoxSNegRxfLO+yRwChB/h1uE9GUu
         9y7NclOMEY9j78x5xhstrIKymTe4gR1HvrMF1MYK3ZkjYO6hVmadXmOXL+201fPZPaF9
         J077jKzKtHlzvbfrtk9pojSzo53jUS7AHQ5ckwULtLLy58rETZu9OA8sLjwC28jlf79/
         O+sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737744814; x=1738349614;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XMLPuUT3d2AnF2eXRgJOzlbcZfjko/BgkONjKBbrmiY=;
        b=FJS3vh4BtkaGus8qtinon8R8QTvbl+2MH0OfboaD/ZNKVExibP6BKh5OZaYZ8NIbxz
         pcARt/L2NGEmF8K/nYqy8DM6YgWwv/NI9KVaB/lhLqX/8MX+zTatuL5LinfwQ3Ru/Bv5
         xYjV/Sw738nmXIfJC5KPrxa6IPfHbV3btC73wVCVtyY4PLE0HzQnuwDS82Al4zQYMrqe
         1WBrzj1rQvjTVlE9r63/j1IrJgPthlw9YizNnhYPFNLvjV/RWvVltavkQLL+apc3XBPp
         OMy9bjRRYtDvfmvI036R+tehQvGdmm1tnmSU1SJdhtZOIElHr2GfxZhXw6PKTmgChFSC
         kFyA==
X-Forwarded-Encrypted: i=1; AJvYcCXtb7QdIpT+QhmL8zyhD+o2FhehcOn5nHPwSA+mxVnzHAtJjEqT0d0rlEOxE8eETVjtMXk/qaA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxiwtnz3WxKRgN0ziRJNtxR1vaUPi3kB7io4QPiz9VUHe5WyQWe
	7FNaiddfG4ZpNy9Kd/ZuMW/mWmiF1QZEWTiSao9xpSiPCVG/wLgnFjKHXQ==
X-Gm-Gg: ASbGncurZkfj9+AnCMlMz4HNUkEW2ULvjCDw1iOAR6o7TSpVdrMQcwq2Vogig9mZnOS
	DA1P0h3QWJZ9sPj9ImRfKanSUIhI/Nlups0fUPupKTX1h+RAkJPluTiYfY+WMVumCSriY/Z17Sj
	yQYWDLx7WZEuXDKxmWIC/NfdtHklKMNv6KAByiarY+E5oCQ7kGnz//+QLdfTV6SwOSpuJTqpsOq
	nKnS9RB93VpN03VArp65cqjDv5Qaa3KElfqgpfnBQ4jPNFvdObJF6mPYwp96Py+sO6liMLxnojD
	5pbgK5sxNQesCRXDhA==
X-Google-Smtp-Source: AGHT+IHZ1/g6+aic9arDvtZZ58BNt0yfa8fxO2HenoIqml9Vjiaky7Tfl3fw3gZ0YHYNfI2oNSGWGQ==
X-Received: by 2002:a05:600c:218b:b0:436:e751:e417 with SMTP id 5b1f17b1804b1-43891919404mr306690835e9.7.1737744813596;
        Fri, 24 Jan 2025 10:53:33 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.128.79])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-438bd5082d3sm34830795e9.22.2025.01.24.10.53.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jan 2025 10:53:33 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org,
	stable@vger.kernel.org
Cc: asml.silence@gmail.com,
	Xan Charbonnet <xan@charbonnet.com>,
	Salvatore Bonaccorso <carnil@debian.org>
Subject: [PATCH stable-6.1 1/1] io_uring: fix waiters missing wake ups
Date: Fri, 24 Jan 2025 18:53:57 +0000
Message-ID: <760086647776a5aebfa77cfff728837d476a4fd8.1737718881.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

[ upstream commit 3181e22fb79910c7071e84a43af93ac89e8a7106 ]

There are reports of mariadb hangs, which is caused by a missing
barrier in the waking code resulting in waiters losing events.

The problem was introduced in a backport
3ab9326f93ec4 ("io_uring: wake up optimisations"),
and the change restores the barrier present in the original commit
3ab9326f93ec4 ("io_uring: wake up optimisations")

Reported by: Xan Charbonnet <xan@charbonnet.com>
Fixes: 3ab9326f93ec4 ("io_uring: wake up optimisations")
Link: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1093243#99
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 9b58ba4616d40..e5a8ee944ef59 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -592,8 +592,10 @@ static inline void __io_cq_unlock_post_flush(struct io_ring_ctx *ctx)
 	io_commit_cqring(ctx);
 	spin_unlock(&ctx->completion_lock);
 	io_commit_cqring_flush(ctx);
-	if (!(ctx->flags & IORING_SETUP_DEFER_TASKRUN))
+	if (!(ctx->flags & IORING_SETUP_DEFER_TASKRUN)) {
+		smp_mb();
 		__io_cqring_wake(ctx);
+	}
 }
 
 void io_cq_unlock_post(struct io_ring_ctx *ctx)
-- 
2.47.1


