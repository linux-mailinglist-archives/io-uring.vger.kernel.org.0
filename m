Return-Path: <io-uring+bounces-2985-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CD443966747
	for <lists+io-uring@lfdr.de>; Fri, 30 Aug 2024 18:48:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 770CF1F25A1C
	for <lists+io-uring@lfdr.de>; Fri, 30 Aug 2024 16:48:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D42CD192D69;
	Fri, 30 Aug 2024 16:48:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="xZcudHFz"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f170.google.com (mail-il1-f170.google.com [209.85.166.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B97E113BAE2
	for <io-uring@vger.kernel.org>; Fri, 30 Aug 2024 16:48:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725036494; cv=none; b=qfSBSTamcVIaCqfgjUvU2lV2Yjs10w1RKO/MUzUYMn7jB6LquMjvY+5D00/Y7H5y6LpJjQlWc8Nly8wuO8/piEzb/x1kfTPXNC7oToR7H1IlSaTBmTI2xkaUzgrjDb8r295qBC7wSzBhB/q1x5FObF60k1zHJcX+EFKFdxkFUI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725036494; c=relaxed/simple;
	bh=4tbAYmV+VDaLddU+GWYEylSO3vAy2V871Hgq5+Ewxqs=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=fqSW5tIjgxP7vc8sOFQZIrkGUNgX4TAfJboyXoTIoiUR/Xw47n31WdIvYIUhrgacSq/GPqtsjThK4rDu9+ZJfAcVk6+DKgEGQBhNal3TUgnMn1dK0XUfjsjjbw2ZyhqG1vO0OeDt1E7BZv+j8Tpc2Q/UbSSCtkhYAawsp5W8kWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=xZcudHFz; arc=none smtp.client-ip=209.85.166.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f170.google.com with SMTP id e9e14a558f8ab-39d380d4ffcso7951315ab.0
        for <io-uring@vger.kernel.org>; Fri, 30 Aug 2024 09:48:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1725036490; x=1725641290; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7dpVIV8kLBjMkuHb8WAJQDnu2q9xO0knLAuEByQvQ8w=;
        b=xZcudHFzssy18fnshgUJP+MV2qE+rwSX2z1N9tMZMlVx7myiXphQHV9EpFbOKkCqCt
         5QPF0tBrfiqWvdjT7DnrNITxFaIHfhKu1Og8YSJerVzWS24aiVAcdtJPj2igfrFlkmAQ
         jcQjWktmQBAqaIGsqL4OlC3RXe7zuSQq5QIMjcmAf1AS33XZNGnOio+hstyG8bb8oKIC
         1t0lnTmAPrjGjRFH8ink7K8ICalDcuXWxkEo0D2l/MUV/IpCpvHU5AKepAvFcxvesP4+
         vdGz8CMkC4DK1REG3O8FEcOMkMp0qaBW5raH20Wfl600tbwjHSy0izabKAt8w1HR1SVg
         nIRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725036490; x=1725641290;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=7dpVIV8kLBjMkuHb8WAJQDnu2q9xO0knLAuEByQvQ8w=;
        b=Z8oXldV4WJumb+U1tAxzC4ltNGhwt9sNesxOciK75MeXtvLVYTb/XHu+DuLxkBGwDy
         0dGCI8LnE1EMKmlzX8vooXLJR0NkDRIbKMpoDeg7h7QowEE/uxbHZ372ObyPsDs8NZuu
         Q4Q2o8pwVD1nbnSV5ITBCrjlom7KAnf1rKfE4EUv/cM/Bf1QpAJkLa3JHwQm4h8Khm/t
         KtRxpHViObm61mlRVyMoa6Zonylfb9yVy2c2TtXfQprhNNwkWYawPncidsDcL9SpEbeh
         a0w3GITzMR1aWTmADt75JOV+E6SSH3DdPPKjanlUAesiJu00QEweyL2sZ4PEnFKA7M0B
         DF1Q==
X-Gm-Message-State: AOJu0Yx49IaAXqwHkf08nJS12kVHxqGD5j7ZwU00OoKkKAYVp7LJ3XbN
	ttAWlyS/+Gpb4phBfCCgqtSOSwlJuFUCY2lsIUKuRfGASpHOiOCKZxmTRde173XM4AOTwLNV5E/
	W
X-Google-Smtp-Source: AGHT+IETujNKxN/6Ka4pvA3LyW6Sdr9/3YXpeOad9SPchMwDDzQ1Xt/KgvS6/b6X2EFi95AudP0Oxw==
X-Received: by 2002:a05:6e02:1c87:b0:39d:2387:c57a with SMTP id e9e14a558f8ab-39f378fd67cmr66494335ab.8.1725036490079;
        Fri, 30 Aug 2024 09:48:10 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-39f3b03f266sm9241675ab.57.2024.08.30.09.48.09
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Aug 2024 09:48:09 -0700 (PDT)
Message-ID: <0905527f-6119-41a2-b2e0-60e36bb96b1c@kernel.dk>
Date: Fri, 30 Aug 2024 10:48:08 -0600
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
Subject: [PATCH] io_uring/kbuf: return correct iovec count from classic buffer
 peek
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

io_provided_buffers_select() returns 0 to indicate success, but it should
be returning 1 to indicate that 1 vec was mapped. This causes peeking
to fail with classic provided buffers, and while that's not a use case
that anyone should use, it should still work correctly.

The end result is that no buffer will be selected, and hence a completion
with '0' as the result will be posted, without a buffer attached.

Fixes: 35c8711c8fc4 ("io_uring/kbuf: add helpers for getting/peeking multiple buffers")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 1af2bd56af44..bdfa30b38321 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -129,7 +129,7 @@ static int io_provided_buffers_select(struct io_kiocb *req, size_t *len,
 
 	iov[0].iov_base = buf;
 	iov[0].iov_len = *len;
-	return 0;
+	return 1;
 }
 
 static struct io_uring_buf *io_ring_head_to_buf(struct io_uring_buf_ring *br,

-- 
Jens Axboe


