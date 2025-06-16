Return-Path: <io-uring+bounces-8377-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 28571ADB953
	for <lists+io-uring@lfdr.de>; Mon, 16 Jun 2025 21:07:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 24FEF3B604C
	for <lists+io-uring@lfdr.de>; Mon, 16 Jun 2025 19:07:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB1A01E51EE;
	Mon, 16 Jun 2025 19:07:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="GsKcvLqN"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f52.google.com (mail-io1-f52.google.com [209.85.166.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDBF83208
	for <io-uring@vger.kernel.org>; Mon, 16 Jun 2025 19:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750100863; cv=none; b=sGZJzPusYDfDly3RYlneL0iqOWYGlmYVE87LaClnGoWVB3X0qSQCCFJbzED8qX1RBD5YV/Mlwg2wFCnjyahB2TbnauKazmv5d0DmzxhKrlr2u8001EU6JLj+soXJPNNAEbkeAoDhN6qX24ZgEnvd9Oizl2bxkZ6NkdeuuO0r+Es=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750100863; c=relaxed/simple;
	bh=tojlh8I7B+L6io83lX0RvZLU6DolLnvgOchK37yfwKk=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=EtKEtp8b73g/9sJrbNSd7dmM/fUh8AJ89DjItDfChDwFNU4F6/3bGWlgz0tElUj7Rub2QwiV6/J3gv5Brfzp9PNh2znNxCWHkMhUe6mz6SC625jHwcq2Z0lSwefaLHJAh0k97DwAJHXocJ4PMo7aIj99jlzQl+bdeF2dzUlOMAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=GsKcvLqN; arc=none smtp.client-ip=209.85.166.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f52.google.com with SMTP id ca18e2360f4ac-86efcef9194so164808939f.0
        for <io-uring@vger.kernel.org>; Mon, 16 Jun 2025 12:07:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1750100858; x=1750705658; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cwlkdRRfFDC8VZfDg3O1DZe/1dOaA00Eu5rM8YdKb8A=;
        b=GsKcvLqN/mJBL0wC0wlwU+XWZtY4CdzY9b0j9jdewxGAdMlZJ0ylKc/bJjcDGpMDGR
         +PsEKL83qLIMd9wmG6VnjillqCroHO02zWXIrQtWnfobHpvYpH4kY+TMsennOWBeRE2V
         sCvkYtbU6f0G2o2qJ2GWOC2eWT5pysi+Qama/c4rStYDQbw64OirrzhOCcawE5g7eNgn
         AI6Cw7W0P4+gA6mS+qVLQu0/KpDNqOMTN8fOBLynDkaSUzSrhqhErMzaZ6xpLHbO1DJt
         +mZSIa519gvpr1FefnRrcu10x7+cNhuSX8rh3xT/nLJzMmYDWDzKMPHMo/WLCr8dW4xo
         C18w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750100858; x=1750705658;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=cwlkdRRfFDC8VZfDg3O1DZe/1dOaA00Eu5rM8YdKb8A=;
        b=NB9Rf8kow7VAMvmt3/4bnbRIG3FPH9F1V6i+FLQNPVjLRXPUIkW2UChvi2Ga7b1XLH
         airuTtyx0s0Vg37TR9wH59wOJ6Tw+3Au0SZ2dABqGuFzCBBxhJH+GbWFD4l0CNnXQ6IW
         Kvu329B2awDKso7OqiGRZWzMNfmAMqsKFKKnqki3n97DsMq2nMBGTKbudpwuxDAQo437
         NmpPImY706TM8wKQx4QIKOOHBRAZbcouHYqOg1OFwuTZSvWfbFeS3tE8WsqoxJpvqVeB
         ftRrymgNNabEVB51oniT58sSh8Qii3PMs2l/4zPYHW5PER6IIO9OT3KWwDMcqmTXzVGO
         MCmg==
X-Gm-Message-State: AOJu0YxBTKk5i8sn2DU2U1EfV9QH6fmhqcZUWMhCfDfbXEaSKWsjd3xW
	ic650D9U0LvBwRatGr7HPCZlLIkh3ESh3x2w8GjEfRs8V3HKbYRSBxPRrrQMdlOQ0iWJIlXFRhz
	9lRQ3
X-Gm-Gg: ASbGncurYTDHL0Vv/LDxWU55iy1P2HD2ukPOI42sDl7wfg4BODzvQwYuT+eAj0hn8yg
	AYaR4zATTSNpRfZZaW++iyIbVZkObOtKawkyPFnCFrl/WisNZwEZvg4PbpR1OgOG5IM0mrDRzcS
	1rD05+PggCTDA8CrzE0CmqkPsyANbYAHRPbByaZACz6a8Q/0nftWr2UPLdYG9G6xWn3YDywOEB1
	2g9T5kwjULKKAuSUs6wFYjBXCzgvRXkiWqChQq4r4RG+6VB3Gql2G0PFNd3/rniTQCYFa32rqpU
	1RNUb+VW74F+kL0esuJmAxZy9VPXzjLGWw+IJRzwOf6y2mawFgRomjJY1gw=
X-Google-Smtp-Source: AGHT+IHU79veWZ2c2g/C/nACc1+Q5mVe8jgex7QnuW3qPpagO2x+4sb1bHUHaot7G23ykVvGIFElCQ==
X-Received: by 2002:a05:6602:3a0d:b0:875:bd67:2abe with SMTP id ca18e2360f4ac-875ded92a3amr1149079739f.11.1750100858163;
        Mon, 16 Jun 2025 12:07:38 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-875d572b7f3sm191674639f.16.2025.06.16.12.07.37
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Jun 2025 12:07:37 -0700 (PDT)
Message-ID: <deb4cb2b-ea20-475e-b460-3dae58c588bb@kernel.dk>
Date: Mon, 16 Jun 2025 13:07:36 -0600
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
Subject: [PATCH] io_uring/nop: add IORING_NOP_TW completion flag
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

To test and profile the overhead of io_uring task_work and the various
types of it, add IORING_NOP_TW which tells nop to signal completions
through task_work rather than complete them inline.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index cfd17e382082..8c3d43caab02 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -449,6 +449,7 @@ enum io_uring_msg_ring_flags {
 #define IORING_NOP_FILE			(1U << 1)
 #define IORING_NOP_FIXED_FILE		(1U << 2)
 #define IORING_NOP_FIXED_BUFFER		(1U << 3)
+#define IORING_NOP_TW			(1U << 4)
 
 /*
  * IO completion data structure (Completion Queue Entry)
diff --git a/io_uring/nop.c b/io_uring/nop.c
index 6ac2de761fd3..20ed0f85b1c2 100644
--- a/io_uring/nop.c
+++ b/io_uring/nop.c
@@ -20,7 +20,8 @@ struct io_nop {
 };
 
 #define NOP_FLAGS	(IORING_NOP_INJECT_RESULT | IORING_NOP_FIXED_FILE | \
-			 IORING_NOP_FIXED_BUFFER | IORING_NOP_FILE)
+			 IORING_NOP_FIXED_BUFFER | IORING_NOP_FILE | \
+			 IORING_NOP_TW)
 
 int io_nop_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
@@ -68,5 +69,10 @@ int io_nop(struct io_kiocb *req, unsigned int issue_flags)
 	if (ret < 0)
 		req_set_fail(req);
 	io_req_set_res(req, nop->result, 0);
+	if (nop->flags & IORING_NOP_TW) {
+		req->io_task_work.func = io_req_task_complete;
+		io_req_task_work_add(req);
+		return IOU_ISSUE_SKIP_COMPLETE;
+	}
 	return IOU_COMPLETE;
 }

-- 
Jens Axboe


