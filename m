Return-Path: <io-uring+bounces-3429-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A9C33991BB0
	for <lists+io-uring@lfdr.de>; Sun,  6 Oct 2024 03:11:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 28C5D1F21E0F
	for <lists+io-uring@lfdr.de>; Sun,  6 Oct 2024 01:11:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2AC94A920;
	Sun,  6 Oct 2024 01:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="B5cBuiNs"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A91AB3D76
	for <io-uring@vger.kernel.org>; Sun,  6 Oct 2024 01:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728177100; cv=none; b=mcTSuEUvWEzYmUkM256A2gaTBJJ1viw26+E25ZxEnZwKkKmHk14VNGFzjAbd60kD+ksYbwLzZ5ahpXb/rz6z3pnZ9kR5KA+GXJqTDZ6cub6yLC31qG+fJsEwdkXq9t6kF1RtIdSHJvEu0RGcyPWt4CZyphJDNXjwU2CqNWNDtJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728177100; c=relaxed/simple;
	bh=lsg4tJkXpeQUl4p8OJFUt1yae6MeFb9IfjqkuaTkMEs=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=mpHtxpSwStm3yYfJvDVT+Q8dI2ZPLSf2JgYcBB2hAesZfXsJnB6F3ZbnZlGSF+2XzdNGhpJK+XAnNFfKhBj85XaU1zw6E/6qiR3+6XvPrfOypjiFRHjUZJRIh/B2PZ6uk2QDJ8llmj2qWSTeBmbEdXDpc+Nc0BGHSkzZcJbrpk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=B5cBuiNs; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-71ddfc61c78so2051768b3a.2
        for <io-uring@vger.kernel.org>; Sat, 05 Oct 2024 18:11:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1728177092; x=1728781892; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6qUxN6PMZAh4gnarROdDzMFQG22nP/PXd9amhHhgdsE=;
        b=B5cBuiNsfmVK0eXyDvnEB4SduMhIgdQaf1Z9wEU0BsIlHAAKn3i0GPbVaiC0u3jdjx
         Wry0uAgnjL6eCbQ1woYMoB7kg73JnHB1dYCgROrIOWI7ue1m1gg8fC+g/YfvwFot1c2j
         nO2Jvh9JDshbqJpyE4p9pyAzRAHNwda8EsWA/Ukg4vb02OxnjxTqlfGHIpxTHPxhyNxV
         BJjUT6/KA9hFX8x2dx6eBIOmbP+oK8ZgNGxe0pB7ee6dTDOiimWu1oIHYFc1/waLh9XX
         UYOmWJLY7ca1pnMnomXpCX8i0yloKmLmcvPzazxwF/6qaHMnGxGGxMwWtESLGBlL+jKi
         PfyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728177092; x=1728781892;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=6qUxN6PMZAh4gnarROdDzMFQG22nP/PXd9amhHhgdsE=;
        b=HhbobbHXk/Kj1vFbuIHQFplJy//oZQkACzcvEJPZx11C+RQfI3W7AJV9GrlPwFbj+J
         k+9XMZ5DAelU/N5NDReov2OU7XCpZ+YntF68e7tOExtoR2FOH3wphvSzv1rdtUbCWsy3
         JnLyzWJRHM8D4KUYCdFxI+R/9Dxu1lm5TxskTi5hVwtleGRNr3S8aqi77Cxkhhxhdsqt
         LshZzerjeHg1Sv1qknInXa/ZilJm/GlQ+rUsjA/ldOxnGJ348dnqHosXTbk/zaV4joNY
         gWYvMtzOWMVmSFLoyJGqKnXgH0SETlEibydJHPK0awKuM6IK8GyJijGmgaI/ydZIy3Qg
         7igA==
X-Gm-Message-State: AOJu0Yx87sBsAgEnViM0nU1y7htlJZcvt1kSVcKIDLyYK4ayDAYCe5GP
	LDZ6pThg5VayIQPQ81bHVLuMD222hKDsWAaMFZj7GpmODhp6ij3YylmYEGWvS+OuaTR154plQhn
	I3ZA=
X-Google-Smtp-Source: AGHT+IG3GltG2dXWcGw95PXumRNCSvhkIkgsahJH1JufXCdngvnwVlkdPsL0KScj1QYwbMFFC7Di4g==
X-Received: by 2002:a05:6a21:a4c1:b0:1d5:2d6d:1614 with SMTP id adf61e73a8af0-1d6dfa427ccmr11998517637.23.1728177092497;
        Sat, 05 Oct 2024 18:11:32 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7e9f6c3758esm2368437a12.74.2024.10.05.18.11.31
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 05 Oct 2024 18:11:31 -0700 (PDT)
Message-ID: <f6c8ec06-8826-4021-b36d-74e3612ac7d2@kernel.dk>
Date: Sat, 5 Oct 2024 19:11:31 -0600
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
Subject: [PATCH] io_uring/rw: fix cflags posting for single issue multishot
 read
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

If multishot gets disabled, and hence the request will get terminated
rather than persist for more iterations, then posting the CQE with the
right cflags is still important. Most notably, the buffer reference
needs to be included.

Refactor the return of __io_read() a bit, so that the provided buffer
is always put correctly, and hence returned to the application.

Link: https://github.com/axboe/liburing/issues/1257
Cc: stable@vger.kernel.org
Fixes: 2a975d426c82 ("io_uring/rw: don't allow multishot reads without NOWAIT support")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/rw.c b/io_uring/rw.c
index f023ff49c688..93ad92605884 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -972,17 +972,21 @@ int io_read_mshot(struct io_kiocb *req, unsigned int issue_flags)
 		if (issue_flags & IO_URING_F_MULTISHOT)
 			return IOU_ISSUE_SKIP_COMPLETE;
 		return -EAGAIN;
-	}
-
-	/*
-	 * Any successful return value will keep the multishot read armed.
-	 */
-	if (ret > 0 && req->flags & REQ_F_APOLL_MULTISHOT) {
+	} else if (ret <= 0) {
+		io_kbuf_recycle(req, issue_flags);
+		if (ret < 0)
+			req_set_fail(req);
+	} else {
 		/*
-		 * Put our buffer and post a CQE. If we fail to post a CQE, then
+		 * Any successful return value will keep the multishot read
+		 * armed, if it's still set. Put our buffer and post a CQE. If
+		 * we fail to post a CQE, or multishot is no longer set, then
 		 * jump to the termination path. This request is then done.
 		 */
 		cflags = io_put_kbuf(req, ret, issue_flags);
+		if (!(req->flags & REQ_F_APOLL_MULTISHOT))
+			goto done;
+
 		rw->len = 0; /* similarly to above, reset len to 0 */
 
 		if (io_req_post_cqe(req, ret, cflags | IORING_CQE_F_MORE)) {
@@ -1003,6 +1007,7 @@ int io_read_mshot(struct io_kiocb *req, unsigned int issue_flags)
 	 * Either an error, or we've hit overflow posting the CQE. For any
 	 * multishot request, hitting overflow will terminate it.
 	 */
+done:
 	io_req_set_res(req, ret, cflags);
 	io_req_rw_cleanup(req, issue_flags);
 	if (issue_flags & IO_URING_F_MULTISHOT)

-- 
Jens Axboe


