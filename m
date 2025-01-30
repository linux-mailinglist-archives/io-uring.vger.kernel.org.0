Return-Path: <io-uring+bounces-6189-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 55760A23120
	for <lists+io-uring@lfdr.de>; Thu, 30 Jan 2025 16:44:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1B4FF7A2D67
	for <lists+io-uring@lfdr.de>; Thu, 30 Jan 2025 15:43:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FECC1E0B74;
	Thu, 30 Jan 2025 15:44:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="qFJIULuy"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f170.google.com (mail-il1-f170.google.com [209.85.166.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D94E1AA78E
	for <io-uring@vger.kernel.org>; Thu, 30 Jan 2025 15:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738251864; cv=none; b=DEttVDuLg2ywELgLUrfnnGfddPDEBSA4IrzLR4DJTj48abXKZhtEq+uLGg5oxqcKTdp987k4nFDLekDoo2nwv/kd71Y8QCHEDFeAE9mFRiT723/ZC6Br8oCZfMNEJnTFm/s7axrFYMWTZ6TkPlMO/oK/aEiXNTTslbhf5MEUsUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738251864; c=relaxed/simple;
	bh=dl4FEmx9PFfpUgvDcDbvCcOQE00M5r2VDb0GHKz98Ig=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=S268P4rAe3vsI3JchEOYG4ybE5VV8LMFIuJ3QidkPcsyTIFoZoud2JT2VoZyHsB/4jiO8QqlSix/aeaZhn9XEWHq3kjCqLFmWbtbIW4oOKlfoU7Md478Mg8XmWxDoW2Et+UV4FlXkbyMEi7kFkQYFzV6ZeHf6okyfUchUDZYjh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=qFJIULuy; arc=none smtp.client-ip=209.85.166.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f170.google.com with SMTP id e9e14a558f8ab-3a9cdcec53fso6438515ab.1
        for <io-uring@vger.kernel.org>; Thu, 30 Jan 2025 07:44:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1738251860; x=1738856660; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WMXfB7D/WfLQhviB04lqhbtXA5GyztocBGxuyevLvBA=;
        b=qFJIULuyE0WoQ3hCeyJiYJ2Yh/yMugZgP61j7jpqjjyOLyC4IhSRjaXg70I4rC+yoL
         vWL9e1J/t0nbkmPGIgNn9EX5wy+xDqM5dyM+NA2zTiMZ690BoaVMQpXecWSP8iOWVg1u
         IySMf15hT9fkzeuS/h0SNdD/vRgYmbjqwnEXVcKLoH3u5ZjwNsjkuZxpL9dq4ul2RYxq
         98jIoNhvGQr+3I8L8QDCs46Ms0lRku9TMyIL3IsjIe/8qNKlVAb1KYPnImkDM6O1Yloa
         nixedW4grV4WlIMXp/m6AiLVk7TU7TI9cWrleXV3jqC/hXQgxCkEYV88XSl8a+P/Xgn1
         OmXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738251860; x=1738856660;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=WMXfB7D/WfLQhviB04lqhbtXA5GyztocBGxuyevLvBA=;
        b=lMSCl6ZtbH1owZOpzhxSNuiZGaro/uaVGvsYynhCiFE4HtiZSuz2h0FrY5wjZGuYNm
         euL8L7AE1bsKHgxJfOjBvV3FSPnLOHMlB/g9otKisTBDxix0I4v2KS+p/KizlU2+wUZt
         TcRQZHG0ljp4JWuRpV5CaveUCUdMwQx45/oYteohYwv584pK6ckA1P+UQsJ/v0xD6qcs
         6mSmCFp2XqVKYbZBeiUU+PQiptoLTl6avFq1R/4BZQ9nPKyVwErFhNZm0EprSWzMofIE
         elFjsz8Z79ceiPVmXyNdEnVfCV/tOdScIb8T8auCh32ipMouKJlIV1+POy+JKi8fcHFF
         X0TA==
X-Gm-Message-State: AOJu0Yz5BWIbdo9atgceKT+e2K8Z2OrrSfq79fLo9Xby0VQjvpo2uZNw
	JRawgtaMQl0xNvzLwTRTQGTXcSoKMij2sKOBaEe0iFXNlxqOI5uREGVJXAmoaqb3YdooGbM4eZp
	E
X-Gm-Gg: ASbGncu07t0ciRPbX7i2ruCwuM7ZDc4NxYMYajFqrmS8jpi+kjVZ5Wmm0jlGLAJ+lUR
	GT3tx04uF8SFKvJWO2bOz8IIkxC56wPVT899mz4yuF62H7V76L3SBlt3DooKhcyFEbkq7VPXfdU
	y0hkXnAPBmfUuffnEhiKP8TNz9rA7dpkO1Mg+lMXVFROhXun9YRfKLAV0I4eNe65HX5JewV0RMN
	j3orsQ578VQC+hLxN4Hvmr7xUnW8XcyxbbYvgaagdDX5pxWzA6pca15zumU0gn8DWWFtsAjm4ma
	3HA2Ka5YAXY=
X-Google-Smtp-Source: AGHT+IF8SXx0cJeNpoA/D6BfMamcmLvmJxov2NsSU0BqeFyv4S8uiXHkLnTwuYBGFW12Tot8p5odEw==
X-Received: by 2002:a05:6e02:1f8a:b0:3cf:bb11:a3a4 with SMTP id e9e14a558f8ab-3cffe44792emr69820465ab.15.1738251860001;
        Thu, 30 Jan 2025 07:44:20 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ec746a0ab3sm391196173.88.2025.01.30.07.44.19
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jan 2025 07:44:19 -0800 (PST)
Message-ID: <36e9cdd2-258e-408a-9910-fc019adb7b8e@kernel.dk>
Date: Thu, 30 Jan 2025 08:44:19 -0700
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
Subject: [PATCH] io_uring/net: don't retry connect operation on EPOLLERR
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

If a socket is shutdown before the connection completes, POLLERR is set
in the poll mask. However, connect ignores this as it doesn't know, and
attempts the connection again. This may lead to a bogus -ETIMEDOUT
result, where it should have noticed the POLLERR and just returned
-ECONNRESET instead.

Have the poll logic check for whether or not POLLERR is set in the mask,
and if so, mark the request as failed. Then connect can appropriately
fail the request rather than retry it.

Cc: stable@vger.kernel.org
Link: https://github.com/axboe/liburing/discussions/1335
Fixes: 3fb1bd688172 ("io_uring/net: handle -EINPROGRESS correct for IORING_OP_CONNECT")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/net.c b/io_uring/net.c
index d89c39f853e3..17852a6616ff 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1710,6 +1710,11 @@ int io_connect(struct io_kiocb *req, unsigned int issue_flags)
 	int ret;
 	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
 
+	if (unlikely(req->flags & REQ_F_FAIL)) {
+		ret = -ECONNRESET;
+		goto out;
+	}
+
 	file_flags = force_nonblock ? O_NONBLOCK : 0;
 
 	ret = __sys_connect_file(req->file, &io->addr, connect->addr_len,
diff --git a/io_uring/poll.c b/io_uring/poll.c
index 31b118133bb0..bb1c0cd4f809 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -273,6 +273,8 @@ static int io_poll_check_events(struct io_kiocb *req, struct io_tw_state *ts)
 				return IOU_POLL_REISSUE;
 			}
 		}
+		if (unlikely(req->cqe.res & EPOLLERR))
+			req_set_fail(req);
 		if (req->apoll_events & EPOLLONESHOT)
 			return IOU_POLL_DONE;
 
-- 
Jens Axboe


