Return-Path: <io-uring+bounces-9544-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E18BB40FA0
	for <lists+io-uring@lfdr.de>; Tue,  2 Sep 2025 23:51:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 287211B623C4
	for <lists+io-uring@lfdr.de>; Tue,  2 Sep 2025 21:52:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A694334716;
	Tue,  2 Sep 2025 21:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="CImJ5N2e"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qv1-f99.google.com (mail-qv1-f99.google.com [209.85.219.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4DCA253F11
	for <io-uring@vger.kernel.org>; Tue,  2 Sep 2025 21:51:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756849909; cv=none; b=qkIZS6kpg96glX4TpPGv5X4ratoN9DYKtJcAKMh1OcUadE04AgwfDXLakXLVV7Tc8tQkehr+NYC+5HTj+n0WUo2zhrH4fVZ8dIQJX+L2iWvfre1IqVyCh0zHesfmMbLeRspkyZljLLQNe5iEEsgmQOXB/snSAXqFVPA+11clOJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756849909; c=relaxed/simple;
	bh=QZwJ65JxNPKb5u2CytpFi0TWnOlDdgMgBHjgsBIYfC0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bqtXhwzeBTzl0qyzzGCa4KI+U7xnbMuXonM0lLGbb3e/RwcxTrc2pgASv7g+Rseu+K0OSZDYZ8YG8niqJBS5ShBo+7juw9Avsuamki0IoBp1VYao7dXIcMcBdQ6mt8mNic3pCMzwD0v/Y72m4FpzOYjDu/FfMzwpmH5211+Hgmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=CImJ5N2e; arc=none smtp.client-ip=209.85.219.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-qv1-f99.google.com with SMTP id 6a1803df08f44-70dbf08600cso6343746d6.1
        for <io-uring@vger.kernel.org>; Tue, 02 Sep 2025 14:51:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1756849906; x=1757454706; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=aOZlBcAtEanj5yYe7eggShXZAMSmi3kdQq4Ul++tTlc=;
        b=CImJ5N2eRYeGJM74LG5yqK5I+9mReJ163H0GXY4DkOTU3BaF7s6scC6DpVXvbeLjFJ
         PTfGjjM0Nj6r7FS8EMmMbVqDVrncSMristicEv6t9i6Ignk7DqBB9cEYAe7xZ/rQfhJV
         lMm526BSuwOWyDAkWGrvX4J7fQLEu/qQovrTtXFWpf6Oar+zD7lKcC1zWUDJrnO3x6ms
         Co5YjG1lxPNLBC7Az4gPgbRDk5GeV1dxjjtJN4LmCsFey5Gcrq3J1U9afJDispOuOePr
         i/2pqGoOHxqRaRT455wihbin2MxIOQV47L3Xy8NyrkXjsbNPUgLc+g1FvNmNVN8jK4fb
         AvCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756849906; x=1757454706;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aOZlBcAtEanj5yYe7eggShXZAMSmi3kdQq4Ul++tTlc=;
        b=t7aNzTk2Yp6PwASW2PHffbTfXMZ9P/2f8Pu15lKVuyKNFalN8Uvm9yRlSa6d/j6qx2
         D1kcPtdMeYYW2bl55NEuhYvv9MGgANN2nbA+yd6LTMf9NNj6TktHEU2FCRMoxKclyMdu
         KSB4IrxXkeUw69/y/2mZfmN7LH2zAbJrKp5i0X+lZUft2OlYWushdQlU/uN7agXFDjCa
         ORTjzAUB27AkpwLSAShOi+neDLPpeyQErzZcg/ufnWqmDKuVt2gkejpt4D5znWAva+Be
         P8y4dJ1hHxQdZtShPCZNpwenWhQNC15jo2Bip+xMJYfzdjUhwrWAgthPFS4kThcXX+xK
         2kPA==
X-Forwarded-Encrypted: i=1; AJvYcCVftqtRTcP8GjGOrb9YkKj7MOKY+SY4JWdyQW9zErUJb3cfTmuo0wT1zbIIezi8noOPoNx8qmDnQQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz5ApldgURPKLqx3BUkw4nC8s2f6AXD9bAhnYcSiT9jogqM8cki
	+rMUrQ34M3Tnk/PMMxltLmBslyqVW4qc3IU3K6fQrbjvdr40U8XjOIekDXcehD5iefjp4d0wYSV
	xFjXBWlbXIJ15JvGYfohLQZyKGOplZ01VwMyh8/AW69QLAg3PYTOg
X-Gm-Gg: ASbGncvuh1qVfPajt4p8TBZl/BA52j7nCyAQxCqK1zz5teRmhzYhhdasQVtweT2vZVa
	pJv+Q5ndabNbNb2LZu/Aa513AI0i/0Bf05kdRLo74+pLyh6bKe5Ns3gYyPRqxO5E4f8T5XLbfSN
	5OIr/tJ4ZINCWc1YUQXf8yGtJBV9xfNTrbyNgxNrdLOoEQlvb+MPKrCRm9IGTZNko9upXNtQcvC
	jJyGY0Wz2niaC/2i4eIPlooMNZr6yJH2jS5+KMIDKaO2fvCi3abnNp7kG1TzGnsOn9RHxk8q+Yk
	/2xLF1eTyzGIXhrpCfGBT1G0uF/TvRHwSWzT/miXqDsSbAdbvEwU6CWyaA==
X-Google-Smtp-Source: AGHT+IHZjwnPrlK2a7cuwK4+laIcrO9YM9p4cXpMMVKzY6nhXG6FkegMJ6dW4dmPQ42j+bOosCwun6Lt3RjN
X-Received: by 2002:ad4:5cc9:0:b0:722:48a9:31a2 with SMTP id 6a1803df08f44-72248a93264mr11614246d6.0.1756849906454;
        Tue, 02 Sep 2025 14:51:46 -0700 (PDT)
Received: from c7-smtp-2023.dev.purestorage.com ([2620:125:9017:12:36:3:5:0])
        by smtp-relay.gmail.com with ESMTPS id 6a1803df08f44-720b4a40d6csm1955946d6.32.2025.09.02.14.51.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Sep 2025 14:51:46 -0700 (PDT)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (dev-csander.dev.purestorage.com [10.7.70.37])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id CDF36340328;
	Tue,  2 Sep 2025 15:51:45 -0600 (MDT)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id CC23BE4159F; Tue,  2 Sep 2025 15:51:45 -0600 (MDT)
From: Caleb Sander Mateos <csander@purestorage.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Caleb Sander Mateos <csander@purestorage.com>,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] io_uring: remove WRITE_ONCE() in io_uring_create()
Date: Tue,  2 Sep 2025 15:51:43 -0600
Message-ID: <20250902215144.1925256-1-csander@purestorage.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There's no need to use WRITE_ONCE() to set ctx->submitter_task in
io_uring_create() since no other thread can access the io_ring_ctx until
a file descriptor is associated with it. So use a normal assignment
instead of WRITE_ONCE().

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
---
 io_uring/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 6c07efac977c..545a7d5eefec 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3890,11 +3890,11 @@ static __cold int io_uring_create(unsigned entries, struct io_uring_params *p,
 		goto err;
 	}
 
 	if (ctx->flags & IORING_SETUP_SINGLE_ISSUER
 	    && !(ctx->flags & IORING_SETUP_R_DISABLED))
-		WRITE_ONCE(ctx->submitter_task, get_task_struct(current));
+		ctx->submitter_task = get_task_struct(current);
 
 	file = io_uring_get_file(ctx);
 	if (IS_ERR(file)) {
 		ret = PTR_ERR(file);
 		goto err;
-- 
2.45.2


