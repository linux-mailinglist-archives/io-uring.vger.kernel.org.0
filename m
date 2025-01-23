Return-Path: <io-uring+bounces-6051-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 81BA1A19BAC
	for <lists+io-uring@lfdr.de>; Thu, 23 Jan 2025 01:06:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F14063A6286
	for <lists+io-uring@lfdr.de>; Thu, 23 Jan 2025 00:06:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F9EE629;
	Thu, 23 Jan 2025 00:06:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="mIGFGqJD"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53FAA8C0B
	for <io-uring@vger.kernel.org>; Thu, 23 Jan 2025 00:06:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737590795; cv=none; b=LJXDo+QS8vlVkaAIz5LlYVNVj43rzkUgGFy9d0Y/FNelPeyhz5qTp5UVugMi8W3kzL/zL1gIvHClXnn4ycnQkcyO6SLliNNMzMwy8qKZ5hfl11p/9dnUuxF/3Gz9tdwm5o94UNKHHnEEmGogdhVr5c5CuK1IH1XenhczAJiN9vo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737590795; c=relaxed/simple;
	bh=vgfmsuqRK0rMcPQEXRHYXAX331vuT2hw9nJdazZ0ThY=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Cc:Content-Type; b=jEjroo5k/DUJYHXjFrdzEd4G0WkHfA5JLESUnuyZs4NqnlFS5KFSGMV28Y0sEDSYhG0sv8EOmCtLlSpY/+nVYERRVlzvrjaKTZhxXQCtZT++GwGEmmjPbRLoCMl0KKsI0F+EF0WS4tOS4ntjaG9OBmrr7s7gtyeSGc8kG0aRHxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=mIGFGqJD; arc=none smtp.client-ip=209.85.166.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f53.google.com with SMTP id ca18e2360f4ac-84a012f7232so44375039f.0
        for <io-uring@vger.kernel.org>; Wed, 22 Jan 2025 16:06:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1737590792; x=1738195592; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p3fw5jyOaHvx94kWv9860SIllGr5PU7oQ3eVhxbBZl8=;
        b=mIGFGqJDsYPsUDK6KxMxE7tIrMKGNiPCifqC0Y+2lT9qq59OG3OrSqV4Yf5BhAxU9r
         l+sHrwpMpWFn4p/PF1h+Unw0k0Nwh652T83syTBc3qxy4MBNwcej+FPmg5MkU8Z8yBCI
         b7z9ftOcDGYucAYrXHEUCd4WgDf7PR15YTTRJrMWQkTzsZAionHMhaHfobqTxqAK7Xke
         L8/RZjUBnChm6yeQZDgwRnU6Qrh1e58hxBtEbVA0gZMaQtIC9UKxdVDwbQx/PhYEYXNM
         T6noPYd9KEeyS7slLOv3bOjuZHYvfXrumEe87eGEyELxkfhwi9iUhspWJ6VATHaVc6ZA
         yD4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737590792; x=1738195592;
        h=content-transfer-encoding:cc:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=p3fw5jyOaHvx94kWv9860SIllGr5PU7oQ3eVhxbBZl8=;
        b=lud6q4FbFpNiy3AayYk0U1Yu9VXbySHip2zX9aaCu9P0GsMDhBo76+3aPiOnUdLfMC
         zOREY4DavMO3JxkiqHHH1A/xEqmfVFTdo/1yqgikMcQ7hltZyrylivs2YBSnQmG9JfVB
         O098XGTfNbhtePyZewBiuLn5mqpf8kKcYCcwsvl4WEYNWLkb5i55viAadITsFyDHreGr
         V7JW5k8XgtFhPQCGGfIAQO4wPDMGTnhTpjEaSYqB2yxOBz5uxFMbvTb4tMDdGrXTeOQ5
         b13zMl4kmMY8xHxFuegn1dY+iyBd9n2rScC37mZsrmPaVYY+yk+psDIL4o8SowfJui48
         AOsA==
X-Gm-Message-State: AOJu0Yzcaju2h/mLhOlnVkHtqsa9hZXDWAOV4ErlQ/1Cl2EoryoHkna6
	jRKCuxI+Q/o7MfGhPVe8E+DkUwhP72IjaDFPFSnxbOkShnFBMw0Gct7bf8qWe6HtA5UJx26Yi06
	x
X-Gm-Gg: ASbGncs+Xgz6uKesaJY38++wWDQPfyqW7wWy4o+HYFMFDJbrxzMdo7/nFr5I1IE097P
	PMVQkzG7bQCc7dGAXa4lKrifvtdUl+5/ogMf/EPio+oa0p5uVUziyyRiIfq4Du0UbC7dQUW/uOd
	3IuyhInWZZvr1btUo+6doS2vlm/3sl77TMoKEVI8yh4aomTFNZ2dzF9OvZAfZYG8RvY0SAiBQq6
	m4rhQBmi6gzYa912BJrrBXhxXatMWKVuf0tRA2k/JUNoBUljvYwMDpcRJG2xvlBrrw=
X-Google-Smtp-Source: AGHT+IELj0abMsMWyGxuceKl2LJc49YsugqBvYLUDqOUhX9WuM9UWu1IEVPP8npfd5FCg+FkuZ1QIQ==
X-Received: by 2002:a05:6602:1415:b0:84a:7a0d:cc67 with SMTP id ca18e2360f4ac-8520be683e4mr122234139f.8.1737590791959;
        Wed, 22 Jan 2025 16:06:31 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ea7566e53fsm4490298173.125.2025.01.22.16.06.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jan 2025 16:06:31 -0800 (PST)
Message-ID: <80c22d3e-3cb7-4a48-9cfd-94495f453487@kernel.dk>
Date: Wed, 22 Jan 2025 17:06:30 -0700
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
Subject: [PATCH] io_uring/msg_ring: don't leave potentially dangling ->tctx
 pointer
Cc: Jann Horn <jannh@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

For remote posting of messages, req->tctx is assigned even though it
is never used. Rather than leave a dangling pointer, just clear it to
NULL and use the previous check for a valid submitter_task to gate on
whether or not the request should be terminated.

Reported-by: Jann Horn <jannh@google.com>
Fixes: b6f58a3f4aa8 ("io_uring: move struct io_kiocb from task_struct to io_uring_task")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/msg_ring.c b/io_uring/msg_ring.c
index bd3cd78d2dba..7e6f68e911f1 100644
--- a/io_uring/msg_ring.c
+++ b/io_uring/msg_ring.c
@@ -89,8 +89,7 @@ static void io_msg_tw_complete(struct io_kiocb *req, struct io_tw_state *ts)
 static int io_msg_remote_post(struct io_ring_ctx *ctx, struct io_kiocb *req,
 			      int res, u32 cflags, u64 user_data)
 {
-	req->tctx = READ_ONCE(ctx->submitter_task->io_uring);
-	if (!req->tctx) {
+	if (!READ_ONCE(ctx->submitter_task)) {
 		kmem_cache_free(req_cachep, req);
 		return -EOWNERDEAD;
 	}
@@ -98,6 +97,7 @@ static int io_msg_remote_post(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	io_req_set_res(req, res, cflags);
 	percpu_ref_get(&ctx->refs);
 	req->ctx = ctx;
+	req->tctx = NULL;
 	req->io_task_work.func = io_msg_tw_complete;
 	io_req_task_work_add_remote(req, ctx, IOU_F_TWQ_LAZY_WAKE);
 	return 0;
-- 
Jens Axboe


