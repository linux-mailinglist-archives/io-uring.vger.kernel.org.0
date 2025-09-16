Return-Path: <io-uring+bounces-9816-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 08669B59A48
	for <lists+io-uring@lfdr.de>; Tue, 16 Sep 2025 16:34:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6A0D83A17F9
	for <lists+io-uring@lfdr.de>; Tue, 16 Sep 2025 14:28:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FF8F3469F8;
	Tue, 16 Sep 2025 14:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aFQGEsQX"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48F3C34572F
	for <io-uring@vger.kernel.org>; Tue, 16 Sep 2025 14:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758032831; cv=none; b=gVdh0feGMiUC7DBzmoaUtkujeOx/tp9cH1TQDPI1e6EKgA29Cmrql8mM7hqJOUvt3GQXjArGkk3EDPOHc6bHFIPEm5nBrwpeo8LkJRmG0MNRIKnzSbVhwuZzdEKU8OXlCJc18bjnAOSh7cBQFEsaUffVcaXjF/SA7MTyZrm9HZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758032831; c=relaxed/simple;
	bh=v/YMCwLavCvPgKGXZ2nD5LZC/gIQj7PqhbZm31yXB10=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I27wIs4bt0qXy3pxQGWQ8z/FSNXTuwWMfOGHoBkTquoiEzDFT/UxadnDZ0ydupjycHllrzvJJaUT7bOHTn72keMcT844CRoWukYHc/hWo0SGEoXXVYKWJM7NG5XEVXo1E6LTUWee8tj1pHwda39mZMkaKdG8VVpSDaxil4lwT/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aFQGEsQX; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-45f31adf368so10385015e9.3
        for <io-uring@vger.kernel.org>; Tue, 16 Sep 2025 07:27:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758032828; x=1758637628; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cHzv1mxKGLEW8JJwpv8dDY0SEvmqthDcIzx+/LnldxE=;
        b=aFQGEsQXeclC9LUO+9khvJT0hoBlruS8Hoa8U/E+slCZJogEiQkDK5CASygWs2xW1f
         Lc+9KPgKxcQXN0i2gThmxAaHZYFdmaIMPEHRSR8anAvxHr1VQpAKGddofdWx0NBCVPzT
         KFmzrs9U/NwKKoV7bWs4DqeRwtYQbSsL0mN7vCuwpAVCwzj+OoKy9oJK64Lji21tnBT8
         IKo+6dOZHmkBse4v16Tp8+VyZrFmcas6LuMd0BWwkWoziGt39JsJuNzsX292DLdi7DoT
         C9WtxF3lgz10xYtgjfps/RrWRJZq7g3FbHALSuvZMGfeDItnRJRJ7q8NFg4mE+C/essF
         ceXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758032828; x=1758637628;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cHzv1mxKGLEW8JJwpv8dDY0SEvmqthDcIzx+/LnldxE=;
        b=gkc+jQ+vE+uxE21RJwYArxUtv/G1VUMXg8mTAQfqxo/dVMqfUyTYQcx3mTxNKQSBTX
         73Z4inhR1/CvIEdKXKkNmwMgvcVqRo9Qs0QqGASkFkzLLJHB+QgN9MudYFaqteuRIMv8
         SzJ/69NXlk4a95EAaMIn72X6Z60UHg3poDMX8EJ23duwWJY7qR7oYTldmXfnhMuTbCMD
         JU+NV2DtBbOG4FKBcwqhKCxNRZMBkQQX0plLY8OWZQbKjmUbYR/mZ33g14SgNc/3q67Y
         Q8Aj2zVFuJu7fsx5L/EJHsBT/jgeW/LEwowcc+GSlVx5IIcMJO4r0ql/6tLl5/q2az3Z
         y0zg==
X-Gm-Message-State: AOJu0YyZwIApqTZcpc9kY+tnbVF6gDJVr2ftNTK4JjCNf7ll7jZsQJvR
	jZbNl/QmEl/QOx03lEIi1tgRG2mpkPRdFHPMWdx42rjXVjsP6X6kS49z/cCWwg==
X-Gm-Gg: ASbGnctzSbI90Z81zgDBOTYdWRes13TmKrd4UWXomCK3qBDQG4pXMgfJ3Amo1GsRsrU
	p6nHUGUFasrq/KWslq1aX/S6QzBnyY09I83hmCPA/6skjgx/1ck3rIqCxZVzSlFcgIOCGH6hdOV
	+0n5Pxm10p690Mu14bdiktGZ1//PLL99YhsIFAsbt1Ub5s2lN8GB0LlYvpmELrB+CadGgECgEFf
	PoXEA+WZCzMeZBJZFFg8SrAZbTT8dI281uqHYx3MZXCjvoA1XVzpYuE7MOFTwO9BqrEDURCUK8W
	ZQdvwCRNdPx/MshPxWm8G/JuXTKIR+M2V/NPmMimaD4UV7eYda3INCCMKWvmY5OU9Wlj950JUa9
	79e2BJg==
X-Google-Smtp-Source: AGHT+IF+E+ylpaZ7V5O6WSo9feM1P/qw8LF9KFpdpWrzthxfrS8CsDlcTUDrazvi/34A9BXRcDoQOg==
X-Received: by 2002:a7b:cc88:0:b0:45d:84ca:8a7 with SMTP id 5b1f17b1804b1-45f211d5743mr121420925e9.14.1758032828054;
        Tue, 16 Sep 2025 07:27:08 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:8149])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3ecdc967411sm327971f8f.46.2025.09.16.07.27.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Sep 2025 07:27:07 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk,
	netdev@vger.kernel.org
Subject: [PATCH io_uring for-6.18 16/20] io_uring/zcrx: use guards for the refill lock
Date: Tue, 16 Sep 2025 15:27:59 +0100
Message-ID: <aa967b683e189558babce55288dd4e1e6cad8687.1758030357.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1758030357.git.asml.silence@gmail.com>
References: <cover.1758030357.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use guards for rq_lock in io_zcrx_ring_refill(), makes it a tad simpler.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 5f99fc7b43ee..630b19ebb47e 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -756,14 +756,12 @@ static void io_zcrx_ring_refill(struct page_pool *pp,
 	unsigned int mask = ifq->rq_entries - 1;
 	unsigned int entries;
 
-	spin_lock_bh(&ifq->rq_lock);
+	guard(spinlock_bh)(&ifq->rq_lock);
 
 	entries = io_zcrx_rqring_entries(ifq);
 	entries = min_t(unsigned, entries, PP_ALLOC_CACHE_REFILL - pp->alloc.count);
-	if (unlikely(!entries)) {
-		spin_unlock_bh(&ifq->rq_lock);
+	if (unlikely(!entries))
 		return;
-	}
 
 	do {
 		struct io_uring_zcrx_rqe *rqe = io_zcrx_get_rqe(ifq, mask);
@@ -801,7 +799,6 @@ static void io_zcrx_ring_refill(struct page_pool *pp,
 	} while (--entries);
 
 	smp_store_release(&ifq->rq_ring->head, ifq->cached_rq_head);
-	spin_unlock_bh(&ifq->rq_lock);
 }
 
 static void io_zcrx_refill_slow(struct page_pool *pp, struct io_zcrx_ifq *ifq)
-- 
2.49.0


