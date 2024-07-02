Return-Path: <io-uring+bounces-2416-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C92C9242A5
	for <lists+io-uring@lfdr.de>; Tue,  2 Jul 2024 17:43:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5E3F31C23B67
	for <lists+io-uring@lfdr.de>; Tue,  2 Jul 2024 15:43:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED7B814D42C;
	Tue,  2 Jul 2024 15:42:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="db/6pgi3"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com [209.85.210.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A9841BC062
	for <io-uring@vger.kernel.org>; Tue,  2 Jul 2024 15:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719934978; cv=none; b=R9Y9oFyzqv737Q9jemOT9nmSnQ9IXFGqSHSaFDGAemt9L5X1gPRbGQNC3i/P9ygGB6nKdgXr29RWeQE9FaGD3eEkP2xcdrSnQbEE16iARMuIXLrrxUGq7sL3x+lRWJYdzD/w/JoQZJ0FtYBW9MHxIAYwUV2JbM8MbDV1YZ/21qc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719934978; c=relaxed/simple;
	bh=svm3+lq6j9SChtLfjLdJYZdt8Lk6vxcGf6h7W/ryAdM=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=mNh0BRKtUGGv7kbG8G0KwE6ASnlpZtPuKYXVCV6qXrIHkTFxA7O+GeVyc32fv0gZH7PKBeKqU+kRuuXaFIcp0n9jpbHPWWznj7adFm97CcJpXgYDQNlBHIbPy9gbMMfja1aEG1xMy/gIk+Fp27OPpG6B/fCGdZVXkUWVnksr2Po=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=db/6pgi3; arc=none smtp.client-ip=209.85.210.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f46.google.com with SMTP id 46e09a7af769-700cee3c5f6so78885a34.1
        for <io-uring@vger.kernel.org>; Tue, 02 Jul 2024 08:42:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1719934974; x=1720539774; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o/z6a98yV7xkl1eyYXRXKo2VKH1LeqvoRbCjJUHkgIY=;
        b=db/6pgi3ZSGt5SrBXTXIKndP4zk+kcECT1pYSiVYEwH7Y+P2ClGcthkm/T1H6yhJMS
         ZxBhudl+bGzNzcsuU6aFQ94UVOgF7PLrXz02lBUsZyY7H4sF1sNqn6mYkTfzfUw68+xa
         xK5AxhWGV+zZK26ADhextr+jTuYv2q7f29uMvLHPaEG/LcmljCkOYzCf4F+o8OEIvRQ7
         qajSXaTexS7m+cPlL95K1vmDckKSqYlDfDcpuO9fzyulU8Vty3zykcjEmSYEf26F8gD6
         /c0D968w+4exkivShu9dqJkCdrahI80UEn20fmbYWkSEYOSPX3Pq5PrFCqPubb8SW/TD
         xgpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719934974; x=1720539774;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=o/z6a98yV7xkl1eyYXRXKo2VKH1LeqvoRbCjJUHkgIY=;
        b=jQ3ogrZrp3c7invp8BE/F9KuvoeYqLmHO8DWAnNet68gFJaKT0B1YgsNtSVPZyyW45
         E7sEa0TvlXeJeOfeARy6VjMF1Z6Z4M9VXdvTK3oxSiOqtGHvrIdPKkIOUNfovlua89LC
         Glppr3gQX5PeuMFmKAGHjRBUBENh6gL7HmS00htVcGs/JS72zQQHSxiAsuXZK9GxkwVO
         g2iN8tynlmi3G82wrqe7o7GvTRr84TtSlc5DCq9zc/8Q8/0yeeLy3LpolYV6lL3DXKxW
         jSo+keKiujdyFlZGD4Vgldbf612EfqICXswI6m1BOVusadCgYUeaqf42dIYvHhjJczJ2
         gP9w==
X-Gm-Message-State: AOJu0Yyu4JeKB7969psw+eYMauhIV5cLu/yRziEQdzbHZbGn+LsKV1XZ
	aic7btJ4JoDyfN5fLSwFwiUmgwgCkzCjjLuLXrjJV230OreJJdxHr9RR/KxV8827izL/ODvqiMT
	dxPc=
X-Google-Smtp-Source: AGHT+IG1xzJUxsxDnShwmTVA477aBCvtWq7O/gxro3imJazb+vwP0V9qP9X937GoG1P2AqvadnYZnQ==
X-Received: by 2002:a9d:65c5:0:b0:700:ca13:30bc with SMTP id 46e09a7af769-70207763b58mr9275914a34.2.1719934974446;
        Tue, 02 Jul 2024 08:42:54 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-701f7acbb20sm1709729a34.42.2024.07.02.08.42.53
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Jul 2024 08:42:54 -0700 (PDT)
Message-ID: <26770f6d-efd8-4173-8ac7-110523bd8805@kernel.dk>
Date: Tue, 2 Jul 2024 09:42:53 -0600
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
Subject: [PATCH for-next] io_uring/net: cleanup io_recv_finish() bundle
 handling
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Combine the two cases that check for whether or not this is a bundle,
rather than having them as separate checks. This is easier to reduce,
and it reduces the text associated with it as well.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/net.c b/io_uring/net.c
index db4a4a03ce3a..25223e11958f 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -827,20 +827,20 @@ static inline bool io_recv_finish(struct io_kiocb *req, int *ret,
 				  bool mshot_finished, unsigned issue_flags)
 {
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
-	unsigned int cflags;
-
-	if (sr->flags & IORING_RECVSEND_BUNDLE)
-		cflags = io_put_kbufs(req, io_bundle_nbufs(kmsg, *ret),
-				      issue_flags);
-	else
-		cflags = io_put_kbuf(req, issue_flags);
+	unsigned int cflags = 0;
 
 	if (kmsg->msg.msg_inq > 0)
 		cflags |= IORING_CQE_F_SOCK_NONEMPTY;
 
-	/* bundle with no more immediate buffers, we're done */
-	if (sr->flags & IORING_RECVSEND_BUNDLE && req->flags & REQ_F_BL_EMPTY)
-		goto finish;
+	if (sr->flags & IORING_RECVSEND_BUNDLE) {
+		cflags |= io_put_kbufs(req, io_bundle_nbufs(kmsg, *ret),
+				      issue_flags);
+		/* bundle with no more immediate buffers, we're done */
+		if (req->flags & REQ_F_BL_EMPTY)
+			goto finish;
+	} else {
+		cflags |= io_put_kbuf(req, issue_flags);
+	}
 
 	/*
 	 * Fill CQE for this receive and see if we should keep trying to

-- 
Jens Axboe


