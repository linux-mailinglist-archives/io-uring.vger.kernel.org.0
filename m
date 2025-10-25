Return-Path: <io-uring+bounces-10212-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6CC5EC09F1C
	for <lists+io-uring@lfdr.de>; Sat, 25 Oct 2025 21:15:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E74A91B261A9
	for <lists+io-uring@lfdr.de>; Sat, 25 Oct 2025 19:16:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD04E3074BE;
	Sat, 25 Oct 2025 19:15:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="uPOtzORs"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f180.google.com (mail-oi1-f180.google.com [209.85.167.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36B06305E2F
	for <io-uring@vger.kernel.org>; Sat, 25 Oct 2025 19:15:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761419717; cv=none; b=Tmt2c72/AVvBzg2ZLkc1JoH1/YXiwGeH/tyUxYskeRR9oUOVJcCj071ktQOWzmYGXB/o+2HOv+gOBAF4J0pcBzG/ob0I9Tq0NYuCGo/kdXYaDPZRg5arknwJcYyUyLMyXWeF7GenUvsvhLtlq1EUyXmhmWwmZCiayH0czjPXO/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761419717; c=relaxed/simple;
	bh=WTDNM0tr/INgV5OTYW/ZlWdr+6NafVTLdbzbyoyRu8g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MHhXfD5gBHasuRtjBAPPTd4WMzcNjZ8Z/x01ZLMXw4QxEs3IgrVaawDsbTL7yXXY53hq2r9GmkWq7ytEsghh1fwquIWqmYAwZOCfxBb0bwTuyfT+qlfJsIFG5rJg/pi5pKO3fFgHDX3/Apa0eRpF7SuayVcwoHncTIOZc6U5wc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=uPOtzORs; arc=none smtp.client-ip=209.85.167.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-oi1-f180.google.com with SMTP id 5614622812f47-4444887d8d1so1857993b6e.1
        for <io-uring@vger.kernel.org>; Sat, 25 Oct 2025 12:15:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1761419715; x=1762024515; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/2SzGzX4o+SmFbTrBRXjjlJNGzurz8IutLnIyEojtEM=;
        b=uPOtzORs7pvzZE3Lr2PlhsjQ7zaF0FyAn8M89VQ0bN+87kw0q0Rm2G68YYXuXRFyVq
         4KVA7eiE09bigjkj2aKSO+nVOs28IdmQ4lwCfGTME42vlAW6JSurMtfFW2UVsM1CHVJO
         nqzCfvT2drmlVLZfqpZ4b1QdJ6JXSOBxK1jNOheTdh8yMqIMNbV06xQE9Fok/LwHjsiU
         1J/iROV3qS5ZQwpq6SNYyak8M5PQxgb71S4CsLLspTzjZ80r8omILa3LsiNnCE4ZmtfA
         j0shY83MCrrOQeEMP8xnsdR/gP/nmwq42hnHt7SjD1mhobhDpnOmt9H7Id+2AKUCkfQd
         +qUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761419715; x=1762024515;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/2SzGzX4o+SmFbTrBRXjjlJNGzurz8IutLnIyEojtEM=;
        b=ku9E9mQnXZgy8vehwN0E+xK9+BJsPifNWW7jUlwC4jGvzYelA8zpI+qfQoOlYCDfMO
         MPTtG6ykadmllXfBFKa7XaoqrhnbksPzK4Wh9MZc2hO2+IpkzWf5yL1uL6XIFhihcZ8T
         d0TV28+4vC434sfqKFIXGcWDzxgPj6119/QjF/cosDwi1USJLJAhp5PHkVMukNs+0Pdi
         y97lwcum//JDMrpxD39jFXjyu4soFLbEPK9hEU/sLt8/M/kwXv6BPu9A2gKInzl+mulT
         /jCaE8rdM9ZenxM9ux78xdYuA8OLF43czZtaT02Hbtf1zT4ixv6AX5R2KkfjBZkqs/2s
         ob6w==
X-Gm-Message-State: AOJu0YyleHDAh+FI+ouWgLnX2f/9dvYZ8Syjo9sD6zvYilViA1mu+W+x
	ICpm7ssxIviMBYx8ZyRC7ZTchhnee6R9JOtbVBde7SiM07dG4yhCBGNh8oaMU91cltsT/MbOP1S
	5+B1B
X-Gm-Gg: ASbGncvvf1uSi1DJParZxheEAtwWgpWuQWGmO2esScTaIKqEUgU5isJBfdacxocZsLN
	othKSV+Ohq8cbPpSeB+DH54JsHqP6e3feJRO5tPu3caXy7MhzUwJlcojvgAfsrgAihGGpjyFacx
	Q5jaTwZcjwYfoTe/bOOMxu9hhrYjbPvaxQYnShi2RdsgHUShreEyC7BcOTNPNd1yZ2cpDrAd4Fy
	86fatTGAQEE9bsRADi5fNb4tUzpmSPNMroBZwcUEPv1GmfermenXoQbvqznM6GRzzzTct89fETU
	qvGLlNhlFfN5BvGMD0svdczINBm1M8tUCjkBpVLS74DEIItnLc6a0LxjTBEuZS0kcQigywJc0zV
	S8wJRmrivwiNFPe8aEdgCUWqaYkCToCtGT4/qEU1rp5npnAhSLRiEq7yEbgJh18f2RC94PnpO1w
	tm2ueac7cMdaCP1bL3XcY=
X-Google-Smtp-Source: AGHT+IGMWeQ40VXo50EDlyowTbWMhv9Icclx7VY02gK0gDsjo+EjMOo5ZkmWECFH/FkXBkoi56h6dw==
X-Received: by 2002:a05:6808:2122:b0:441:8f74:fac with SMTP id 5614622812f47-44bd433199dmr5000811b6e.57.1761419715369;
        Sat, 25 Oct 2025 12:15:15 -0700 (PDT)
Received: from localhost ([2a03:2880:12ff:72::])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-44da3e9ccd4sm646578b6e.19.2025.10.25.12.15.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Oct 2025 12:15:14 -0700 (PDT)
From: David Wei <dw@davidwei.uk>
To: io-uring@vger.kernel.org,
	netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH v2 4/5] io_uring/zcrx: redirect io_recvzc on proxy ifq to src ifq
Date: Sat, 25 Oct 2025 12:15:03 -0700
Message-ID: <20251025191504.3024224-5-dw@davidwei.uk>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251025191504.3024224-1-dw@davidwei.uk>
References: <20251025191504.3024224-1-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Technically there is no reason why one ring can't issue io_recvzc on a
socket that is steered into a zero copy HW RX queue bound to an ifq in
another ring. No ifq locks are taken in the happy zero copy path; only
socket locks. If copy fallback is needed the freelist spinlock is taken,
which ensures multiple contexts can synchronise access.

Writing to the tail of the refill ring needs to be synchronised, though
that can be done purely from userspace.

The only thing preventing this today is a check in io_zcrx_recv_frag()
that returns EFAULT if the ifq of the net_iov in an skb doesn't match.
This is the ifq that owns the memory provider bound to a HW RX queue.

The previous patches added a proxy ifq that has a ptr to the src ifq.
Therefore to pass this check, use the src ifq in io_recvzc.

Signed-off-by: David Wei <dw@davidwei.uk>
---
 io_uring/net.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/io_uring/net.c b/io_uring/net.c
index a95cc9ca2a4d..8eb6145e0f4d 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1250,6 +1250,8 @@ int io_recvzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	zc->ifq = xa_load(&req->ctx->zcrx_ctxs, ifq_idx);
 	if (!zc->ifq)
 		return -EINVAL;
+	if (zc->ifq->proxy)
+		zc->ifq = zc->ifq->proxy;
 
 	zc->len = READ_ONCE(sqe->len);
 	zc->flags = READ_ONCE(sqe->ioprio);
-- 
2.47.3


