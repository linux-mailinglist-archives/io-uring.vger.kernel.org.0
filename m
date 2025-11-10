Return-Path: <io-uring+bounces-10508-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AE68EC496E2
	for <lists+io-uring@lfdr.de>; Mon, 10 Nov 2025 22:37:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6C46C3A10D1
	for <lists+io-uring@lfdr.de>; Mon, 10 Nov 2025 21:37:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B163A1A9F91;
	Mon, 10 Nov 2025 21:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Y/iIGgAI"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1299532D0C4
	for <io-uring@vger.kernel.org>; Mon, 10 Nov 2025 21:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762810646; cv=none; b=KKGxxIqBmKVwqd4iHLtdCQ2LDg+06CREsyCQbxs/6MU9gnLbhipkTBgeMsxAH39/tamF++aQe+qwmdgDOPx+uc6L/E8NZP0rZk812/HrOt82/vuaEp5YZ8x3KGaqeKYyn4YZ5Xz8mVdRT652KqLw5F+lu3VXuHHK0/HzsbSMZJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762810646; c=relaxed/simple;
	bh=uykky/uKBB88vCLPIGvRKuK4PKrmrY0/6UriifhVbWM=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=t29vUptfml4CuG16R43jmVCiEJ6Xr0gnmDHsCTDQFWvnIn7ub2kDGzd5GB8WAEencUaUz2mWIJYR1bxp8Nu43ja4roPJCVvYIkU9dv/7joKV+WyAWNNCFIVGDQgpw+WgIpV5LVR4s7w+qwW/+4WJgz1a0XXy7BwFMrPqAr/CDls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Y/iIGgAI; arc=none smtp.client-ip=209.85.166.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f51.google.com with SMTP id ca18e2360f4ac-93e7e87c21bso186416339f.3
        for <io-uring@vger.kernel.org>; Mon, 10 Nov 2025 13:37:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1762810641; x=1763415441; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M5t86lbKFmPTN8AZBvJXeG/ljoL5ltEPP3yaeU4g2Lg=;
        b=Y/iIGgAIHW7i6X+Ri1YshHZIskbRd3apdB6k6ilNkTNrYJ17AJCkyAp4VbncUTxPx2
         IbqgML+Je+iG+MMDwgjDjHhdkVPk77jEijnUxtxkTo+W147VTh8vvqhxCwYl9b1k8Hmz
         OPpCtugR2Epf70Qigdc0s6arNOmg9LpLFRXonwfSyIHd2It2U+4A+3GCRGyCQs9UsjMI
         nTKjKYyZXSNzcPGNy/sahbcssUx8sUu2v3X20YvbUYhlpH4khjzYWQe3HOgJIoqMQq2g
         T4l9x13dEKgdJiglh2cCWoxnFqbdI28Sf4OJLMwhA4nLDB5VzX2ri6CVB9FYZg+LzgDd
         4+6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762810641; x=1763415441;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=M5t86lbKFmPTN8AZBvJXeG/ljoL5ltEPP3yaeU4g2Lg=;
        b=DKIA8Qz9ghcdxrPSih8TEfwQSvjoEp8d/Wn/H731DTetsS9bKg7lSMgv1OumxifXiN
         eM4paTlCQAprwrWiDFgbmOlTuzs+AEMR7ihv8RlBOnl5h0o8zz1u63Eimna/ODzhhIWF
         6ohs4fFQ/Yy1LwKryuOyubzsSINXfijfv059x2nRO30LsBG1pwaGfC0brHa1x6iotjcZ
         R4atCVBOZ/7znVPCE6U1/Ev/gwAbFdsAODrWWwK/75lRRFaF+jfPcGl+FLCp+lA9lv53
         jw3ZkFQXxVbnh7TB7qOPUUvFlUk/h7OeKk8JqgXk0/WHTnmO2N4TukcdvNgKOVw5L2pk
         Va5g==
X-Gm-Message-State: AOJu0Yz8WBJW9s3an3eXQShfyzSXkqwweA/XMDzuxDAvRftX9cX09YDU
	w5pDUtMEV5Gma1UcJVIIFkDjZsGgOH7YcXVG9qzfAXoHprtrQeqUylAxynZlGgPoezNNveaz5ZD
	clV1L
X-Gm-Gg: ASbGncuM/4upK2xB6xYQguIaDqldOuaGW/WBhRcJVeiUFHK3UHPViqtWt0Ev3GwfeO8
	iN+skBJmguf3Qk/iU0lbu+QS3KYIyLEKRQeSImIkWpV7L6cO7oQyXX92rmfJErSxmBkT6nD8Q+e
	PvOqp2pwL0txl3T4yxr7x9a0RL4iUEkT1TxBPKoKAw8iSKkjJrR6x3uj02IMD0xFqW8KIdcOggY
	buFox32R6Yx6Rf3U3r7DkMXth+a7oy90hT3u5I/27CbAMjKXSQXlqgj/R6Sp27KALpXEh+KD8Q3
	LHBeCIL6s8AtqwMQwUbIHSRlBucNE2ne/4ibLJeNQ5QfsOPE9jFXstBpEOzO/OOMt4HUq0eZgXb
	kZtgCMf6Tu+nFmr3bNf/BNzRIHeHiGc8E9c6dSs0jdqD9Vaw7VbwGswCg7hLkbncAcQ3gBI6Qid
	wUqttSyF4=
X-Google-Smtp-Source: AGHT+IF/qUP5EuoSqb5a9GjP8gfDD1N+3DNUZ5YnNGLY8Mc2tLFjsGCaLlHbpRvfwTs8VUX0LGWsqw==
X-Received: by 2002:a05:6602:3f8e:b0:93e:8c1e:cc5d with SMTP id ca18e2360f4ac-94895fcd9a2mr1364657139f.5.1762810641640;
        Mon, 10 Nov 2025 13:37:21 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-5b7467d4900sm5461472173.5.2025.11.10.13.37.19
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Nov 2025 13:37:19 -0800 (PST)
Message-ID: <ebc2ae15-ef88-4f21-b027-dfe86a5db555@kernel.dk>
Date: Mon, 10 Nov 2025 14:37:19 -0700
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
Subject: [PATCH] io_uring/rw: ensure allocated iovec gets cleared for early
 failure
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

A previous commit reused the recyling infrastructure for early cleanup,
but this is not enough for the case where our internal caches have
overflowed. If this happens, then the allocated iovec can get leaked if
the request is also aborted early.

Reinstate the previous forced free of the iovec for that situation.

Cc: stable@vger.kernel.org
Reported-by: syzbot+3c93637d7648c24e1fd0@syzkaller.appspotmail.com
Fixes: 9ac273ae3dc2 ("io_uring/rw: use io_rw_recycle() from cleanup path")
Link: https://lore.kernel.org/io-uring/69122a59.a70a0220.22f260.00fd.GAE@google.com/
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/rw.c b/io_uring/rw.c
index 5b2241a5813c..abe68ba9c9dc 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -463,7 +463,10 @@ int io_read_mshot_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 void io_readv_writev_cleanup(struct io_kiocb *req)
 {
+	struct io_async_rw *rw = req->async_data;
+
 	lockdep_assert_held(&req->ctx->uring_lock);
+	io_vec_free(&rw->vec);
 	io_rw_recycle(req, 0);
 }
 
-- 
Jens Axboe


