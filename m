Return-Path: <io-uring+bounces-6155-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E8C6A20B68
	for <lists+io-uring@lfdr.de>; Tue, 28 Jan 2025 14:40:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2523F3A6B45
	for <lists+io-uring@lfdr.de>; Tue, 28 Jan 2025 13:40:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BB3D1B041E;
	Tue, 28 Jan 2025 13:39:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="ESgk9t6D"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A67C1AA1C9
	for <io-uring@vger.kernel.org>; Tue, 28 Jan 2025 13:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738071584; cv=none; b=CLCyKNTIde5fJqYhqycRirvjwwHJGqcxjrn0aRpsGfDJSvZ5KSgmpcV9iGBR82OJh9LzlcmP7gYTMC/L4SZCZcvPSaxhhzdLPAEQiBOqqCpu85r/wGrmAK2Fz34RIRLWE0uSwBXaDitz/OC+BV5Y11jnf8TyolnQt6yvJfngwkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738071584; c=relaxed/simple;
	bh=QvShGw/EU0/4HTfEl3fvb7iVkBbHr4NN1IvQ8AYev8w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XYRHUNxrQ3fL8/gPDlqdpOCvUeWZAyEZddnZlmshyXSjf9h3vWoM2iCiGYpSLRKtBE2+kCQaxh3ahB2V7VKlrigfdaJlNQ0GzZHeKCzyPppoWUyTbHpmVRnpTqYZfyDISVEdtE57vjWuUL8RJ27X0ckvZ7yA0FV8lnZQx7X94AA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=ESgk9t6D; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-43618283d48so40088465e9.1
        for <io-uring@vger.kernel.org>; Tue, 28 Jan 2025 05:39:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1738071580; x=1738676380; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nS1iDaKH7nB32Am/xLOSbCNtV3WCrSwFl1dM6W+hV7k=;
        b=ESgk9t6DiKX8rLuTNAF2oT8EQEnbyzmpKlBXT+8IhN7W8JKQtDoYt3MXKR28UlyY+v
         cPtr7wxjfmedipqL7p9pVw7looUhWP9AoVvccS7+YHYpzX7S9Z9jPqi5A7fdXm5OC3JI
         ofrk+96xTYsNjjiPayhraiaQnx+IuKttTGI8ti3PcKkzmmvWWbQ5SBPWJ8ACY5xxTRm1
         Qdhwgbc9DRKxz9up9KO7GHy+Iy2/sGK3QIEZic9J7BCryzscn050a0aiU0DLQ3yX0cj+
         acIZIV3Fd2YYyazye5Ea/cg6qMK5dmsH8yhc4ZhXcLj5FtVTvkYw55RmOaQijzb7tTW0
         vYjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738071580; x=1738676380;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nS1iDaKH7nB32Am/xLOSbCNtV3WCrSwFl1dM6W+hV7k=;
        b=eDqEQF0RB1NGO9N7j9w8SSgSEdavYkDAV9Ur0tTOxUVDXXlMCpAGv9dzfIugU/kqls
         0TiJGlyfYmFLPoR6XE+bUezfigNeFMWZ0rfBRJ/hCUN1UYbNXa04fDvYy/7cjZLrX5Sx
         9pIKcoYl5vWxKlJgUqLAmP3kiSjddPT6QAJQnPrVlQwUvx3jkd24olfihS5Q0lqtnWim
         nkVA93DlmEaN6r6iikd5wxKVvIL9LcmyLRKwe/nphDZvKXCzw/xCaDnNN7e7JxvTTLfZ
         HZtD+QBiR9S2j6qfxwtZhfrF2fjuYBABIG91mQD+UHTyrWk1bPAsHn6gi71PR3zKdzKH
         m44A==
X-Forwarded-Encrypted: i=1; AJvYcCWYlVQTRz+oHVlw1IU7+bqfCLYs7S/qspI7j+yYoSd8SxBltVGa9Zj3P7SW9S45ceI7cIOBguPjbg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx04n1aH3N7zM4ZVsyBVN2stmC/mscjxKBxrQPNw13w0Ne/fiKd
	z83iV3vKqmWDEUcq3ENGDlnbSh07d00ouhPnmUYS2l1C2psU/kDE9T8TA7LCh6Q=
X-Gm-Gg: ASbGncvmw2czeoJt1xqiE4Gi4h2RyIUyJeZyeSpL7K0GgrQiR5N3WrOoNK+ofQr0EQ/
	HIjFejRWEbyZ6HdptZ6CPc7STtKBhsV4pPxunhrW5SVdMVFq302gsY/qZ2wVWGQW+sw0FSMQOuK
	KtIRajXUPj5kdWoSQTW9ZLyIsBAKCN9gzvSzAH2P3nnOek0j80A4AmTNcTWltsgiro3Iiqrj8wy
	9HSy3f2P984j3jFALqXwAV8dcT1Z4rsgYcZ8c0I27hfMnUlsaWEn8BqQdhWhsaVBxrXosp6VmbX
	Pegy4eTMS6jLle9SU8TuYkaWvpjXNO9Z8IPCWHdM150NPJ6lQWRz66HVXDZ6k5Pv6T1aRI9L7IQ
	O1qBJkAqvCT8qh1c=
X-Google-Smtp-Source: AGHT+IELMGr2JQgRmVorvVpEasrvqebsINTeORiuGFoCYQ4dH896syZvGAFKMrBLk3f1laP5h34SAg==
X-Received: by 2002:a05:6000:186f:b0:386:373f:47c4 with SMTP id ffacd0b85a97d-38bf57c934fmr43407679f8f.49.1738071580600;
        Tue, 28 Jan 2025 05:39:40 -0800 (PST)
Received: from raven.intern.cm-ag (p200300dc6f2b6900023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f2b:6900:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38c2a1bb02dsm14160780f8f.70.2025.01.28.05.39.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jan 2025 05:39:40 -0800 (PST)
From: Max Kellermann <max.kellermann@ionos.com>
To: axboe@kernel.dk,
	asml.silence@gmail.com,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Max Kellermann <max.kellermann@ionos.com>
Subject: [PATCH 5/8] io_uring/io-wq: do not use bogus hash value
Date: Tue, 28 Jan 2025 14:39:24 +0100
Message-ID: <20250128133927.3989681-6-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250128133927.3989681-1-max.kellermann@ionos.com>
References: <20250128133927.3989681-1-max.kellermann@ionos.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Previously, the `hash` variable was initialized with `-1` and only
updated by io_get_next_work() if the current work was hashed.  Commit
60cf46ae6054 ("io-wq: hash dependent work") changed this to always
call io_get_work_hash() even if the work was not hashed.  This caused
the `hash != -1U` check to always be true, adding some overhead for
the `hash->wait` code.

This patch fixes the regression by checking the `IO_WQ_WORK_HASHED`
flag.

Perf diff for a flood of `IORING_OP_NOP` with `IOSQE_ASYNC`:

    38.55%     -1.57%  [kernel.kallsyms]  [k] queued_spin_lock_slowpath
     6.86%     -0.72%  [kernel.kallsyms]  [k] io_worker_handle_work
     0.10%     +0.67%  [kernel.kallsyms]  [k] put_prev_entity
     1.96%     +0.59%  [kernel.kallsyms]  [k] io_nop_prep
     3.31%     -0.51%  [kernel.kallsyms]  [k] try_to_wake_up
     7.18%     -0.47%  [kernel.kallsyms]  [k] io_wq_free_work

Fixes: 60cf46ae6054 ("io-wq: hash dependent work")
Cc: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
---
 io_uring/io-wq.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
index ba9974e6f521..6e31f312b61a 100644
--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -604,7 +604,9 @@ static void io_worker_handle_work(struct io_wq_acct *acct,
 		do {
 			struct io_wq_work *next_hashed, *linked;
 			unsigned int work_flags = atomic_read(&work->flags);
-			unsigned int hash = __io_get_work_hash(work_flags);
+			unsigned int hash = __io_wq_is_hashed(work_flags)
+				? __io_get_work_hash(work_flags)
+				: -1U;
 
 			next_hashed = wq_next_work(work);
 
-- 
2.45.2


