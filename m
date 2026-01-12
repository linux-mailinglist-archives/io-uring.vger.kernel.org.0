Return-Path: <io-uring+bounces-11590-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DE5F6D13BA8
	for <lists+io-uring@lfdr.de>; Mon, 12 Jan 2026 16:38:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3BB603129224
	for <lists+io-uring@lfdr.de>; Mon, 12 Jan 2026 15:21:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68D632EAD10;
	Mon, 12 Jan 2026 15:19:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="rPF0DEg4"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f182.google.com (mail-oi1-f182.google.com [209.85.167.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A89B2EAB83
	for <io-uring@vger.kernel.org>; Mon, 12 Jan 2026 15:19:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768231153; cv=none; b=TW1suGPNVWTmbMO5BjAMqqTZr6TH9e5fdKAxc+wZrXqvhD0g5T0QBx1dxxgGaUF9z5B+jEf793LnetGZU8CmlQ/vVNKakIH5oFrX6usQfRVrcZuIIn39Reb43Tv2vp1looDvGRkBPEhs1ExpC8HuNjorDWmPqEFskeHF35FSM9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768231153; c=relaxed/simple;
	bh=I7884bQYh186O1/1dJj67jaH05RMnQMHQlr7X77qWj8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PHh4PIlZqPb8LtK/fR8oA5t6pstyAwLxzXEXzU+c7N4Sfz6TZDFEaPX9hVs98E77VUAimS6RHU0iOMhmfH5FvRd8h7c7inKzY8yLod5DEYfF4V7xez9/INmS4VM+/DMkIqQNEM2gCYeBowuLliksidSvjl0TOSEXEMJXouW9OQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=rPF0DEg4; arc=none smtp.client-ip=209.85.167.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f182.google.com with SMTP id 5614622812f47-45a85a05a70so1188010b6e.3
        for <io-uring@vger.kernel.org>; Mon, 12 Jan 2026 07:19:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1768231149; x=1768835949; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L65thMWsWMvjpsWYEf3xGzI0QqAKYeSrzDHWI9QYDUM=;
        b=rPF0DEg4T9kKmfFNj+he2s7jBl+jNlKYURkUWCV2zvcJONqpkYlv+qRqw281bpHfpN
         l/0fE/GwK2RPsJYx2S9jtjq77Omepv7aStp2ZAIUyHxZRpWdoIhjJ7lGEZAKLuwCHbQq
         JhzQ2i/UgVqnNqWjfXqEqgBQrFn1xVSpbbBIrjpk4vE7ivQ54IPVqxk1Mw8i8sQE+Xz5
         oXX8lXkCAMt4E0gwDy36Rgl1XiOG4imtXc+VQoZREO56EsUz4xerYdYFR2k8QXTRWZMr
         s7yH24mWsX6zUgvApUUvfsJgg9SY1RdA6DRfTnOtMqVgMsoa1NgyeXqmjuX1NptAQ0P3
         fbDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768231149; x=1768835949;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=L65thMWsWMvjpsWYEf3xGzI0QqAKYeSrzDHWI9QYDUM=;
        b=la01JkMvN4FwtFMyhLJnFq/rU2v92E+dcQvXuwBQtkcHTBam6rZbK40UHS6P6LOkxO
         cUD9sjftDW0ojYLH6t6SX+zogy+nlOsh4OHGS1Mtg7KD6/YsePyju8aEFWkWzC1R6v4/
         C5NG/MdusLj4KFnPan6xiXl2hOX7YavEUN7F7bOB9ZZe3yIjJbTrTNqRKPatiQ/gJJZ3
         v9TH7aDBlIdtWQO8vuiN+2OCqIVTFm2wYSJg3wL0WZW8bJuUahYmiODnMWAF1Jq1qyOQ
         WWEJzpE0cbq1fbYhtD92bJ/6qFPbkGl1Ht/11ZqLkPnToQzoAeKtwoH66m42z3T/h93T
         9Btw==
X-Gm-Message-State: AOJu0YzxqPxjuglVJLmghYr+nqrKv3CTikBGyxJczsJocnU/8VkXdMKE
	ZG+xmQjWeht9JztX2dWy8p0l2ck7VhSP0Y9a/1KyH4jyQdQ8ENSikYtUH+A6m4hP32abS6cRFPA
	n6k0n
X-Gm-Gg: AY/fxX5oMZOpTc6NFlS8/8V7OaPtDWPwA1ksp98NpNL28twZQ/y/94b6uuIpD78o5Bp
	fnvQyjBpO16Mkf3B2P+LS0sLDhTOn8bNUcGZShuo5qnBq35QhI+C7saMxX/M3P/UAr1YocF7xZ9
	ocXm4FmYIShEgN2ka7Q/shQlVjHaAxrnBgeyMUuqSfAG7jCtT+qTv2oriRJLFhgbsCSzsjVXMWi
	WAxthZ8tiYcJJ6z1Ul0KyubTDk066THKBp9gFNcgBSRsDNaY6axpVKdUqvVXyISBVSivJ3pAo88
	GyQDyMR3b+Oot4OEQB5DThPwbVaHUyZIBCWbp9hNCFQxsb8oSIlaaCck8Zbwrje51rRdeEqRma6
	v/RhR866P78TdXf3kQxF94uePp2XdeUQac8pVZ/cCo4zeo8MEbgDMwicoxTkCUCslwXJmkMg=
X-Google-Smtp-Source: AGHT+IGS/6ZMTLPBVAjPMhkE1H5fdBY44PIkaf/dwQ4gj/g4aJjViVikyUD328HRZQ8mv+sOHcTHvg==
X-Received: by 2002:a05:6808:250b:b0:450:d833:6bb6 with SMTP id 5614622812f47-45a6bdbf35fmr9008445b6e.30.1768231149479;
        Mon, 12 Jan 2026 07:19:09 -0800 (PST)
Received: from m2max ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-45a8c6b3fdfsm4210561b6e.17.2026.01.12.07.19.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 07:19:08 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/5] io_uring/register: have io_parse_restrictions() return number of ops
Date: Mon, 12 Jan 2026 08:14:41 -0700
Message-ID: <20260112151905.200261-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260112151905.200261-1-axboe@kernel.dk>
References: <20260112151905.200261-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Rather than return 0 on success, return >= 0 for success, where the
return value is that number of parsed entries. As before, any < 0
return is an error.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/register.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/io_uring/register.c b/io_uring/register.c
index 62d39b3ff317..2611cf87ecf8 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -103,6 +103,10 @@ static int io_register_personality(struct io_ring_ctx *ctx)
 	return id;
 }
 
+/*
+ * Returns number of restrictions parsed and added on success, or < 0 for
+ * an error.
+ */
 static __cold int io_parse_restrictions(void __user *arg, unsigned int nr_args,
 					struct io_restriction *restrictions)
 {
@@ -145,9 +149,7 @@ static __cold int io_parse_restrictions(void __user *arg, unsigned int nr_args,
 			goto err;
 		}
 	}
-
-	ret = 0;
-
+	ret = nr_args;
 err:
 	kfree(res);
 	return ret;
@@ -168,11 +170,12 @@ static __cold int io_register_restrictions(struct io_ring_ctx *ctx,
 
 	ret = io_parse_restrictions(arg, nr_args, &ctx->restrictions);
 	/* Reset all restrictions if an error happened */
-	if (ret != 0)
+	if (ret < 0) {
 		memset(&ctx->restrictions, 0, sizeof(ctx->restrictions));
-	else
-		ctx->restrictions.registered = true;
-	return ret;
+		return ret;
+	}
+	ctx->restrictions.registered = true;
+	return 0;
 }
 
 static int io_register_enable_rings(struct io_ring_ctx *ctx)
-- 
2.51.0


