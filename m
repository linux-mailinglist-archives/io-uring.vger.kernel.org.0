Return-Path: <io-uring+bounces-11049-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id D88F8CBFADD
	for <lists+io-uring@lfdr.de>; Mon, 15 Dec 2025 21:10:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 41A7B3002B85
	for <lists+io-uring@lfdr.de>; Mon, 15 Dec 2025 20:10:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7093F30DEDE;
	Mon, 15 Dec 2025 20:10:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="D2R8823k"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-vs1-f97.google.com (mail-vs1-f97.google.com [209.85.217.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EBE82F12D9
	for <io-uring@vger.kernel.org>; Mon, 15 Dec 2025 20:10:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765829431; cv=none; b=OTHaZ2x5pBLSJYrJtwwgHYGx9+a91PAhBl3TYqKALPgKkQJU8+vagLFBG/dBzQ3Gf/akc2FlkZNf4VkzgkvgLoymd7xsYvA8Mxn1IcNGauExvePNgJYXkfw1pXQ7AWbCoypwW8ebldUXwe9rgp0TjxBkBj7XHktBoYG60m+fKD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765829431; c=relaxed/simple;
	bh=L5Uqu9+rr+DwT6pdOZXAwcq9nYIz91fuoF+OXKgDo4U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kgeezkcrhjBBBWh86y18C4LpBgHxrXKZxP94+1mTNGdP7oPqoolZnGQ/mOwgnifkVQLdpO/LBa4wXZJ0PEQnJTIYdzRn36sDAwKuyiIBBJuJAbucMKEHO0qRHAC3OmiSaomNppT5VkdeTMTZqv8XK1Q5VB6z+wRZj+JwLJZ7wlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=D2R8823k; arc=none smtp.client-ip=209.85.217.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-vs1-f97.google.com with SMTP id ada2fe7eead31-5dbd12dcdd5so186500137.1
        for <io-uring@vger.kernel.org>; Mon, 15 Dec 2025 12:10:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1765829428; x=1766434228; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8/b4bbf5Fpl1ur/4rCqqMbk9Yx0Nl8rzYgHyXMsZmA8=;
        b=D2R8823kiebbKgRlkM8K0puk0F56/RwS/dl3FTRxXrIKVIHUIdC5ND/uoVQPjhR0nb
         nH97znrM8QWQbUBSYy06IWvhQWCyLfD+3qGtFNaV4NZGriB7GwK8r7/lnzy+f46s+rTx
         FgF9yICYWblpvyEaSCDEhGwaFLZ64C22HjGSLeurvZMw/PVJai9m+EOhboaXodkiqscu
         zx5bqKZ0A2qZGrLzwQ5R0G8wmbGCaswBhSTBl9TBhXC7I8hEkOdm3LCrTu3SO4Hxiu0g
         07e0O6IOarAyOQVOBzAJb6KgNa5qRuohxew32yoOHAzwjUiY/6muCxdVMHweipjUqN1Q
         KY2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765829428; x=1766434228;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=8/b4bbf5Fpl1ur/4rCqqMbk9Yx0Nl8rzYgHyXMsZmA8=;
        b=d5MrImc0fqzqo3TMnPt4KGTN584YQSkfg1QbTxRMpEjrUvv4LliPKN/n4dhVjI5/UF
         cRKJdSXpartP0uAvw3omhMVGZSk3vR1UGXTJ8w/ZK0GPl+sS8zTNOCotbQ7+VqYgZZNC
         ubimDaUKLIjYRuukYcq9KH8LqkqsT9NbkADivIW1i9tJWah8fW1Inh6Ww8OJFpwgcsQJ
         qSb5YuwEoqBuXI6x8ZA1WZPMTCtywSMNao4wv+WBBnTC6xYWJoR3wc2LiV3WkGG6dOCw
         Lv4B8TH9rXNyD+XYeRwUPlgSiAtDOtyiXK3WPBOjld1E0RlRZAJCtx06WgHcTBUy1M4P
         3+HQ==
X-Forwarded-Encrypted: i=1; AJvYcCUe6f7FSy6cW9HjHIvZdqBx/z+Qt7e00FHzXZBTDPyTg89DB0aqCBh4WZ5Ipmxm2bmU1lR4B+JBTA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy5rIU4X0muL5HFJ0dF55PNP1G3rqt3AGSt4AuwHAyuANyuPYjp
	slXAXx74howF48wDJFDzUz0UXxvgd5KjlgejLjo0ljn1FFLNqe/6Q3xTPXyltokG6B7cHik74YR
	T2L3SxYrvcLMf1Nky9GSIxSvaGNe2/StkPERh
X-Gm-Gg: AY/fxX6m+2yllhZlJv3kEfIfH+OcIRHUzCkj4+IzevfGh9J81iymEaFmQ0h14AE/VBZ
	usdL1PaI5hASIVtoDfBZjRVeqyzIiRYAeL2D08J3ExwnpkokpAE7JIH1yEMy8l0nkOlZl+RgYQm
	bR9XxzzdtRFmIQpARxHZ7VN1TcOBMdR440fP98Nl4MFx9wpuZE/zSfmUx0F167DkIa+FuMVk9WY
	qjGmCI6jdQifJ8cMB/rB8fUxbmgGVbWjyd8PjiIuZA+KhcKMuJmVyIvm3vkSnifHaplzg0veLoP
	+0DKXRz/KvPLdViWlbLu6Gk78iYqA7LLaNO48ceUY3LOEJY2qXkl1z9MfvWfbsDiEhnO9mlrFTt
	uKJW5iG9SFI0+Txx/6wtUfyHdy946QjJMSOEtoa+0sQ==
X-Google-Smtp-Source: AGHT+IFKo5M5Rl8K/RJA2NKxyvyaJHy8f7f3xqa4502hQs2OTK/7NEPZO40ym/Kndj/mdUSjtyBo9OgDxpGI
X-Received: by 2002:a05:6102:1915:b0:5db:cc92:26f3 with SMTP id ada2fe7eead31-5e8277b9ea1mr2168153137.3.1765829427659;
        Mon, 15 Dec 2025 12:10:27 -0800 (PST)
Received: from c7-smtp-2023.dev.purestorage.com ([208.88.159.129])
        by smtp-relay.gmail.com with ESMTPS id ada2fe7eead31-5e81e5a1d6bsm1924476137.1.2025.12.15.12.10.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Dec 2025 12:10:27 -0800 (PST)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (dev-csander.dev.purestorage.com [10.7.70.37])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id 9DBEF34076B;
	Mon, 15 Dec 2025 13:10:26 -0700 (MST)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id 9BAC1E41D23; Mon, 15 Dec 2025 13:10:26 -0700 (MST)
From: Caleb Sander Mateos <csander@purestorage.com>
To: Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Joanne Koong <joannelkoong@gmail.com>,
	Caleb Sander Mateos <csander@purestorage.com>
Subject: [PATCH v5 2/6] io_uring: clear IORING_SETUP_SINGLE_ISSUER for IORING_SETUP_SQPOLL
Date: Mon, 15 Dec 2025 13:09:05 -0700
Message-ID: <20251215200909.3505001-3-csander@purestorage.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20251215200909.3505001-1-csander@purestorage.com>
References: <20251215200909.3505001-1-csander@purestorage.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

IORING_SETUP_SINGLE_ISSUER doesn't currently enable any optimizations,
but it will soon be used to avoid taking io_ring_ctx's uring_lock when
submitting from the single issuer task. If the IORING_SETUP_SQPOLL flag
is set, the SQ thread is the sole task issuing SQEs. However, other
tasks may make io_uring_register() syscalls, which must be synchronized
with SQE submission. So it wouldn't be safe to skip the uring_lock
around the SQ thread's submission even if IORING_SETUP_SINGLE_ISSUER is
set. Therefore, clear IORING_SETUP_SINGLE_ISSUER from the io_ring_ctx
flags if IORING_SETUP_SQPOLL is set.

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
---
 io_uring/io_uring.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 761b9612c5b6..44ff5756b328 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3478,10 +3478,19 @@ static int io_uring_sanitise_params(struct io_uring_params *p)
 	 */
 	if ((flags & (IORING_SETUP_SQE128|IORING_SETUP_SQE_MIXED)) ==
 	    (IORING_SETUP_SQE128|IORING_SETUP_SQE_MIXED))
 		return -EINVAL;
 
+	/*
+	 * If IORING_SETUP_SQPOLL is set, only the SQ thread issues SQEs,
+	 * but other threads may call io_uring_register() concurrently.
+	 * We still need ctx uring lock to synchronize these io_ring_ctx
+	 * accesses, so disable the single issuer optimizations.
+	 */
+	if (flags & IORING_SETUP_SQPOLL)
+		p->flags &= ~IORING_SETUP_SINGLE_ISSUER;
+
 	return 0;
 }
 
 static int io_uring_fill_params(struct io_uring_params *p)
 {
-- 
2.45.2


