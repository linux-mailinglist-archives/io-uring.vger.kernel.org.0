Return-Path: <io-uring+bounces-343-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7307381BB5B
	for <lists+io-uring@lfdr.de>; Thu, 21 Dec 2023 16:53:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 08E461F21A20
	for <lists+io-uring@lfdr.de>; Thu, 21 Dec 2023 15:53:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 836314B13B;
	Thu, 21 Dec 2023 15:53:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ZsTiefAZ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDE2655E40
	for <io-uring@vger.kernel.org>; Thu, 21 Dec 2023 15:53:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-1d3b84173feso2037205ad.1
        for <io-uring@vger.kernel.org>; Thu, 21 Dec 2023 07:53:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1703174011; x=1703778811; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TFF1I/Yf4UXfVmpfnykGp9MEWffElxT/hy8ppF3VRn8=;
        b=ZsTiefAZc02SdQ6rIqOKLgT1T7bBCCvUNW9SkdL6eShPTUYNdFE3RHn1uGhR/qU6LF
         MpfGTSGkpOPtIodjG00o4c/r6DSni5FEektZaKQv2qda3TRraoDwOCRB0Ar5IscIt+op
         RIl8TSNPTce3daF9w0ZRKhJrvEl98L5BRfc42mvb7AjBJ8LjTtBd+DA5pfP4puM+CdCt
         M8vLwbHse4hpDNtvFjxGWfRK88ZtaPxV9r1lp3a5iiPHmUNKeEtu23swVAT24G1Vc9Sk
         ssgbeSRoz0sTEoHu+gkXG88ZcaNPgaSzUowjWuvSPcqW/5HtgnRSfYTl5Hr80NCUMb6G
         LLKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703174011; x=1703778811;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=TFF1I/Yf4UXfVmpfnykGp9MEWffElxT/hy8ppF3VRn8=;
        b=R55+HWcdZuQKya+30kn8KZIaRb9UkOWngdTQI5Dfl3lKOAGgM/1GtwKaP4d0h4djo3
         ShYy9X70OF0Z7Ov1zJqKrtAIgZhwEgvSZ5teOjjehNdE9ab8HfbUk8eBl+Hh5lubk0yx
         nqiGJTWWIbkL2DSOw+a9FAnQefLOoc+gBOxhrLfGSrvGACycAjvROjs8g6vNfsuTh4bX
         6AezThovG4erTLdcetTtACzQLTijrdfPNbK5lrWln0Z/mRlZUIW5ZpS/bCYoiR5aaG2v
         WdbECHUvxXTOj1CEs+fAB9kH2CXwpxsZYmF26mIawlQPLdBRW5FqXHZ4Sp+aJramHYEc
         9kxg==
X-Gm-Message-State: AOJu0Yz0UR/mNcguViN0+kDZvY/4N8mIRh5k1rC6XmBHJeS+TRPCiE9z
	CcqU67VoBSIOeLRcyY+r66GuN1sB1+t2weHZTLhYfw==
X-Google-Smtp-Source: AGHT+IELm88UYCCp8wyQDSFj/zMjZ0ST0GUqO3gYR9H0nFbwYOOd1+32bGJe+5Qd6Tkr606/tI2CSw==
X-Received: by 2002:a17:902:8a88:b0:1d0:8f0d:b6e0 with SMTP id p8-20020a1709028a8800b001d08f0db6e0mr43675142plo.1.1703174010624;
        Thu, 21 Dec 2023 07:53:30 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id h10-20020a170902748a00b001cfb93fa4fasm1802916pll.150.2023.12.21.07.53.29
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Dec 2023 07:53:29 -0800 (PST)
Message-ID: <175bbf4a-b0a9-4771-b91e-928ebdbf5319@kernel.dk>
Date: Thu, 21 Dec 2023 08:53:29 -0700
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
Subject: [PATCH] io_uring/rw: ensure io->bytes_done is always initialized
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

If IOSQE_ASYNC is set and we fail importing an iovec for a readv or
writev request, then we leave ->bytes_done uninitialized and hence the
eventual failure CQE posted can potentially have a random res value
rather than the expected -EINVAL.

Setup ->bytes_done before potentially failing, so we have a consistent
value if we fail the request early.

Cc: stable@vger.kernel.org
Reported-by: xingwei lee <xrivendell7@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/rw.c b/io_uring/rw.c
index 4943d683508b..0c856726b15d 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -589,15 +589,19 @@ static inline int io_rw_prep_async(struct io_kiocb *req, int rw)
 	struct iovec *iov;
 	int ret;
 
+	iorw->bytes_done = 0;
+	iorw->free_iovec = NULL;
+
 	/* submission path, ->uring_lock should already be taken */
 	ret = io_import_iovec(rw, req, &iov, &iorw->s, 0);
 	if (unlikely(ret < 0))
 		return ret;
 
-	iorw->bytes_done = 0;
-	iorw->free_iovec = iov;
-	if (iov)
+	if (iov) {
+		iorw->free_iovec = iov;
 		req->flags |= REQ_F_NEED_CLEANUP;
+	}
+
 	return 0;
 }
 
-- 
Jens Axboe


