Return-Path: <io-uring+bounces-7882-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BFC9AAE239
	for <lists+io-uring@lfdr.de>; Wed,  7 May 2025 16:14:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 69FBA1B62AB3
	for <lists+io-uring@lfdr.de>; Wed,  7 May 2025 14:11:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2801428B3F4;
	Wed,  7 May 2025 13:57:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="z/d1XNzG"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f170.google.com (mail-oi1-f170.google.com [209.85.167.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F2F8286D6C
	for <io-uring@vger.kernel.org>; Wed,  7 May 2025 13:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746626233; cv=none; b=N3qFtZAdqNvl0uajlJpsSJaO/mPa1KY72jKyNukZkOG9ZvyHzW2f/9OxmnjIIlMSUFNpmnvoSIkf5Zb+wCNo0qISH01YE8NjoaLyuUtEI2q5jDuNO+D/d1NQgXYw6I4nGq/ng9dxXB356p7bF6HSZ/5b7F0dWYExHyeZxc2Cc6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746626233; c=relaxed/simple;
	bh=0kj06/dKDqbqxSLkCpFBBjHKXRWg3MuGKVMgUcBy/50=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=SuarFDZxSzCkdbWalO7kPxAzYG5BtKa1msYTSXArTBZwm8OOBUbM9oAaSURkJ9yk+QIqG5U3naJnQagP4DWCnjS7EY/94pyfod/wVdgxBAyFQ1UWz9z9G12fF7czHHxTYNYQiOa6gJ5BDWyPAqQXMzUc5hwiVXyLl8dlBPuPgtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=z/d1XNzG; arc=none smtp.client-ip=209.85.167.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f170.google.com with SMTP id 5614622812f47-400fa6eafa9so5004888b6e.1
        for <io-uring@vger.kernel.org>; Wed, 07 May 2025 06:57:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1746626228; x=1747231028; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sVvr7tPpvGOhSgcJGCbBkI8QeHf9Jw28Z06uvMrCxuw=;
        b=z/d1XNzGEcAk6fpZxqePb4lhGPvrOh01zgLDjZMWIoe6pSBeRcvefo9enWcCVfIb84
         OQ2U/yuIQVwcxu/GbnBM8/+KcO9bmKqh3nTczhyxoLdJyp7PdLrjNAIRhq0QKq8bwIcr
         BcWfG8h3Bo76fiiajRKRYS09l38ZiPZ17otY6RmEe34pHQcbjCDp5AsYgadhZeeKwp43
         fzxOrqjETnKpEj/RF2MBJsCqTsbpO/mWlaMJQA+MXtqbX1l7rPl4lsVlj05Ugni3ryTY
         C2Q7ylWQRVRjPY+OJBn7FW5LGjSk3pIUguauutzuELD/znTdQJbFFonxeAYn9VriXs1T
         /Z8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746626228; x=1747231028;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=sVvr7tPpvGOhSgcJGCbBkI8QeHf9Jw28Z06uvMrCxuw=;
        b=RTK9RzNXkHonRkOoHRYLgtWvi7bFMEqwLKKFLv7Yeu61nn3kSg2dyGkb3GRbh3XaNb
         nOjRJevt9YFlLdklW+1hkpkL6agCTv6WFTV8pEdyDiHQE4/nGrMxctfaLP86AuPum2lX
         Nb3YROAdH8rQ4lqPjMeHyWQliX8KFcb+rJSaOsK2uRQOsRKvdCvPggxxugNw1QmgwSU5
         sGsbCa6u3vnjpHrKzKKJjhGBfOssDL9llViiwfK/g/SpA4/Zp99wpO4IzuaPSPyNPtg1
         THT4E/pcsXwg17ol5JXWJoCmo5SDVCQA/BirFoyPgYDibR3fXfGbaMymJRZhGMMtH7SK
         yXwg==
X-Gm-Message-State: AOJu0Yy04UjZ8AWT/jIgmtMTeWrlObIbzOQcJIw8A8Ks7I7NmZXKkl5r
	szOYRQCNf/K57aHD1h9i5BHpXK5eshxvI5ipFHwWPR1WWWAWllSxO6bqZKx4qQQddVddziJ1adq
	N
X-Gm-Gg: ASbGnct1f3gmASABcMX8R6XlgkNSpOIGDZ9fCK0jUBeCR7s2CRFdrs0XAPQY445JY57
	bwYNRVG+K6xBZh7TGSpFG5cOIxUkopzMqSzKUL11qgoqEbTn198xeHkuWs9BuU1QxMaW9lXpGTJ
	N7C07tTQ1jNAtZxJg2gkTLyFC/TUqIqPoJV5zkGBQ45oB/LDoXaxp6hTkSimZ1l7qOlImNuuVjl
	7DI3fFgagFt/Je6w7+Fb4AEpn4NPnKxN1uxwx1RZdrKKD+zDpnLkIPF4S/N5IjBeDT18+Jnrsnk
	l2u8Vp+gFFfpXdj8u1KiNHqlGGnnqSvJGfLd
X-Google-Smtp-Source: AGHT+IH7YnyQ4QiN2fWMQYSO0aEkIyUVxkbcna0Bsl2sCdWWpitA4Z/Ql6JI4/Cq/2opg5jVXzmHYw==
X-Received: by 2002:a05:6e02:1a62:b0:3d9:659d:86de with SMTP id e9e14a558f8ab-3da73933d7cmr33923885ab.20.1746626217613;
        Wed, 07 May 2025 06:56:57 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3d975e2a1a5sm30632255ab.6.2025.05.07.06.56.56
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 May 2025 06:56:56 -0700 (PDT)
Message-ID: <a1dffa40-0c30-40d0-87b4-0a03698fd85f@kernel.dk>
Date: Wed, 7 May 2025 07:56:56 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: io-uring <io-uring@vger.kernel.org>
From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: ensure deferred completions are flushed for
 multishot
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Multishot normally uses io_req_post_cqe() to post completions, but when
stopping it, it may finish up with a deferred completion. This is fine,
except if another multishot event triggers before the deferred completions
get flushed. If this occurs, then CQEs may get reordered in the CQ ring,
as new multishot completions get posted before the deferred ones are
flushed. This can cause confusion on the application side, if strict
ordering is required for the use case.

When multishot posting via io_req_post_cqe(), flush any pending deferred
completions first, if any.

Cc: stable@vger.kernel.org # 6.1+
Reported-by: Norman Maurer <norman_maurer@apple.com>
Reported-by: Christian Mazakas <christian.mazakas@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 769814d71153..541e65a1eebf 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -848,6 +848,14 @@ bool io_req_post_cqe(struct io_kiocb *req, s32 res, u32 cflags)
 	struct io_ring_ctx *ctx = req->ctx;
 	bool posted;
 
+	/*
+	 * If multishot has already posted deferred completions, ensure that
+	 * those are flushed first before posting this one. If not, CQEs
+	 * could get reordered.
+	 */
+	if (!wq_list_empty(&ctx->submit_state.compl_reqs))
+		__io_submit_flush_completions(ctx);
+
 	lockdep_assert(!io_wq_current_is_worker());
 	lockdep_assert_held(&ctx->uring_lock);
 
-- 
Jens Axboe


