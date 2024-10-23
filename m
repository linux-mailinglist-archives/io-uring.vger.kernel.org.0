Return-Path: <io-uring+bounces-3953-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E2D19ACFE6
	for <lists+io-uring@lfdr.de>; Wed, 23 Oct 2024 18:15:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 10201282A67
	for <lists+io-uring@lfdr.de>; Wed, 23 Oct 2024 16:15:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 085371CB301;
	Wed, 23 Oct 2024 16:15:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Ym7xq0fY"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f50.google.com (mail-io1-f50.google.com [209.85.166.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F37FD13B792
	for <io-uring@vger.kernel.org>; Wed, 23 Oct 2024 16:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729700132; cv=none; b=RM2S+muPft9G3s2NYauU3fPcH1bB6HWtSY6k7u4OshNN0uiKsw2Tv4uuwZtKVv0E1BcTczvm6Nvp8kgoNnU5SpIohv1xt3wSCrfwVV+pkPCtobD6g3W+trIwlP5KSRp2t+z3rbqK8Ynf+AdKwaCrqVoaQEDT/HgtCzs7pCEHT1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729700132; c=relaxed/simple;
	bh=4MeTIzSnWmTop4++lpux3qtYRZ5O2Q6nBnaomxslZhA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SPhsKGuo21caGhvajw9JPWiychBfEZ+rmPMbcOUMWqtKgw0CS6aiDEDLKIcdp9oeDGQptibSZwugM8ktM9+FI2kdUcvxIA3/GhXlo1hJjnEnjUFIzLKhWksMwOWjn0sFHaKx+ferAy4z+dyyrceCjWGZ6yOlL4E3VUBY/fREMqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Ym7xq0fY; arc=none smtp.client-ip=209.85.166.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f50.google.com with SMTP id ca18e2360f4ac-83abcfb9f37so222406939f.1
        for <io-uring@vger.kernel.org>; Wed, 23 Oct 2024 09:15:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1729700129; x=1730304929; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QWqkfKF2WSauZLqFPB/EzMlYFgRDbJMCOGF8XP6rgso=;
        b=Ym7xq0fYaJMhgTFesa2XCJcUzDsVpTkUSK5hLKctSc7t7i6+6tA8qBu0xdzE4vXmU8
         8xxFvzmXzoRnLV7RABCS5pUMVzpBm/F3T4zwFO4az7TCg5QKXEuZux/bj/kDU2li759K
         T6N0qvjQGf0UB+NRRY5Xhw1vYptvitIfbYDUsIe7D4foAWxrzLX0ec6QS4HpjSBiEbOr
         FeOXZv5W3PxVqdAHlgo+Gpi4ILKfmjXSkcAw/9DCAwWDSrIE8yiulhB9890/Nz+NwdFU
         vlxDHR25jwdQe8uWVx40m+UkU/c1uQ0uGXtvM7HDR+G6D3jGfnuiDC+2GV++WGhQesRL
         exwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729700129; x=1730304929;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QWqkfKF2WSauZLqFPB/EzMlYFgRDbJMCOGF8XP6rgso=;
        b=oGm2y2Q9/xepv2SY0eK8VytmzM5IKL+/vdo9FQNVDYh6NVLmwFdGPcGuOAACCJNr6y
         8IiYZ7HhmdxT87/4cfT05UPZtR73ZIXMZnp61/ivyv/6CRrDSuHIG62N+aqJKqDnVyhi
         J4NYs1tEFg12BWSaua4wskq9o2vXOHzcByK1TkxAjn4CDdOKL0t+rep9c0QTMwVXAqHn
         KISVQhkQZWlOdOsJoenRR/w18mNhRfqVbIHYapg8UW0VQAFr5jMjwC/kh5+dTF+maUjx
         gcv5KhdNq9X5FoCQqBSrT8BCL2vhP65HXONicRaZ5OdHt65Vb5TeVkUGn+V/dohIIJ8F
         VE6A==
X-Gm-Message-State: AOJu0Yz1x1j8Hv9X2GJ23NhYGbT/z17v9vr8zR9j68EZs7iG3iv04YLo
	3e2HWrThdosbm2qsotsPqAhZJU4YTvEcvRMqkJ8MEnokZrm6y3IYOsFZpIHhveBR3P60AP4Zzoa
	q
X-Google-Smtp-Source: AGHT+IHwjlo2gODfeugfhuzPJfhdacnHfQXEOfb9Sg1uZcFOWGCbs6ZStrXBM5DBiYVwsdHmQvopLw==
X-Received: by 2002:a05:6602:150d:b0:83a:b149:fcf9 with SMTP id ca18e2360f4ac-83af61f3613mr419658839f.11.1729700127774;
        Wed, 23 Oct 2024 09:15:27 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4dc2a556c29sm2138180173.43.2024.10.23.09.15.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Oct 2024 09:15:26 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/7] io_uring/kbuf: change io_provided_buffers_select() calling convention
Date: Wed, 23 Oct 2024 10:07:35 -0600
Message-ID: <20241023161522.1126423-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241023161522.1126423-1-axboe@kernel.dk>
References: <20241023161522.1126423-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Make it more like the ring provided buffers in what arguments it takes,
and use similar ordering as well. This makes the code more consistent

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/kbuf.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 1318b8ee2599..42579525c4bd 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -117,10 +117,11 @@ static void __user *io_provided_buffer_select(struct io_kiocb *req, size_t *len,
 	return NULL;
 }
 
-static int io_provided_buffers_select(struct io_kiocb *req, size_t *len,
-				      struct io_buffer_list *bl,
-				      struct iovec *iov)
+static int io_provided_buffers_select(struct io_kiocb *req,
+				      struct buf_sel_arg *arg,
+				      struct io_buffer_list *bl, size_t *len)
 {
+	struct iovec *iov = arg->iovs;
 	void __user *buf;
 
 	buf = io_provided_buffer_select(req, len, bl);
@@ -311,7 +312,7 @@ int io_buffers_select(struct io_kiocb *req, struct buf_sel_arg *arg,
 			io_kbuf_commit(req, bl, arg->out_len, ret);
 		}
 	} else {
-		ret = io_provided_buffers_select(req, &arg->out_len, bl, arg->iovs);
+		ret = io_provided_buffers_select(req, arg, bl, &arg->out_len);
 	}
 out_unlock:
 	io_ring_submit_unlock(ctx, issue_flags);
@@ -338,7 +339,7 @@ int io_buffers_peek(struct io_kiocb *req, struct buf_sel_arg *arg)
 	}
 
 	/* don't support multiple buffer selections for legacy */
-	return io_provided_buffers_select(req, &arg->max_len, bl, arg->iovs);
+	return io_provided_buffers_select(req, arg, bl, &arg->max_len);
 }
 
 static int __io_remove_buffers(struct io_ring_ctx *ctx,
-- 
2.45.2


