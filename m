Return-Path: <io-uring+bounces-3692-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2099499F0AB
	for <lists+io-uring@lfdr.de>; Tue, 15 Oct 2024 17:07:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B8A121F24348
	for <lists+io-uring@lfdr.de>; Tue, 15 Oct 2024 15:07:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FBFA1CB9E4;
	Tue, 15 Oct 2024 15:07:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="0O54f4W9"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f48.google.com (mail-io1-f48.google.com [209.85.166.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0227D1CB9F6
	for <io-uring@vger.kernel.org>; Tue, 15 Oct 2024 15:07:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729004834; cv=none; b=Hhw2PcCGotKSE+2oggM2S7AjM9w51kiHXWfauLR0MqvbRqvP6PDmWerRNVIRhemFjyk+4/VEwZB9W7PF+dXEUI4PW5rFd6CJSmRk2d7b5Qs7eYaYTdHjqOBBLBmPEm9DiEgO+TuFQ4gqp3iA6n5NX47i9NiFZo2SGIeNjE4s3zc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729004834; c=relaxed/simple;
	bh=yjrtRH/n6WVgd5OQ1X5wJJxibmlOGW/9CkdgjKaLNI4=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=PmdCQbLR5gX+BKC4qyZbkp6wRTihO9znq35UC406RaQdj6SS2Qhc87mq2iK8aTgc4rXFwugNZqgBCd5T46gxYoX6TQJrJdnIA2Aj7oV7ohsKGd0y5T9Nicj0Le4MDGgSN5lpWYMUh0bauh69BfZg/KHn3UGK8VQNTYM2eKlm4vE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=0O54f4W9; arc=none smtp.client-ip=209.85.166.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f48.google.com with SMTP id ca18e2360f4ac-8369b14fb91so167873239f.3
        for <io-uring@vger.kernel.org>; Tue, 15 Oct 2024 08:07:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1729004829; x=1729609629; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TygBA5Es8wgbCSRRzF9PQCFR5bEkOLoAJJZFtowkJMg=;
        b=0O54f4W9ZqqZ8ZT0QjFM+vYoYjr0G8VLy+ZVXRnAidcx7bqH/ECvo5KEdv1/SAZ80G
         n9YopeyPp7pL0bmRx4G46ZK32WZbG93qJJ4TWFTWqb2RJYoGTC0Q02RGDUhEFspEZ7xj
         0tyRLxiC4N5MrZP/zyVmAuxwkf0AuZ2ZQhXCptrMnFk2iFHOWPPLC8BA6FGR1wEMHKvN
         6h5jIUxiXmV02R80XKgb5bJrGxwcZogzsjXJRhYegZa7Lgr+nvsPRE0sIVzzQQ9+lkrv
         7ftNE2KyRvlxfeEODCeInsFJQuAi5RZ0eKPu1VYi1Uv4S4VqFGHscASN42rVXr2HIG3i
         d7mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729004829; x=1729609629;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=TygBA5Es8wgbCSRRzF9PQCFR5bEkOLoAJJZFtowkJMg=;
        b=cK9RFge0Zef9YrWtj8dIefBw8GGRW0RXXHvroW01WaC7nsrHd+kb+8W9KeV6dGyEp7
         00IVu5YWqFCCCle8u4Vncx+voN2Nf0baiJB7G3Q5VCRTglOh8RB50nbA/I1gCm5BieLh
         6QKt9eOuXwQx+41i3R8NNWffPg2c1y3Mc9qLlgEx8efySu3wRRgZRCSNiGj7o+qRRAKV
         1QGKrwx734byIH8bv1r2rIoKdKyFMkv9sKRWmXkuJ/ICoig7i1DVSX3S7kFIDp7IyWZd
         s1v1c3+vs1EDWEWkAGNc+IJevKy/0ufnF4g+rzzccrbWvscxzByBRYh2S6NydE/9hH9M
         7BDw==
X-Gm-Message-State: AOJu0Ywh07ZIbSbp0yfM/oCvsYihbeHN/W5Oqm06FVoLTISeER5PDPrG
	d6Dk/AY68AsU4EQ/NRzONhAq5WK99GqD2JZYztnD/kUNP6kHVLnJ894O1c04F7Th/tB0Nl1EwwM
	M
X-Google-Smtp-Source: AGHT+IFVw+AKyF8h5ojgPhIHItkGH6QDtlzWzTxlSArbvfFLyR/vvkHIoAdO9SIOxEIFS5vtBmNe1A==
X-Received: by 2002:a05:6e02:3b06:b0:3a3:be8a:8717 with SMTP id e9e14a558f8ab-3a3dc4d5afbmr6721055ab.15.1729004829006;
        Tue, 15 Oct 2024 08:07:09 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4dbec9b24c2sm349439173.58.2024.10.15.08.07.08
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Oct 2024 08:07:08 -0700 (PDT)
Message-ID: <78b04485-ad25-448a-88d4-1649f446883c@kernel.dk>
Date: Tue, 15 Oct 2024 09:07:07 -0600
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
Subject: [PATCH] io_uring/sqpoll: close race on waiting for sqring entries
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

When an application uses SQPOLL, it must wait for the SQPOLL thread to
consume SQE entries, if it fails to get an sqe when calling
io_uring_get_sqe(). It can do so by calling io_uring_enter(2) with the
flag value of IORING_ENTER_SQ_WAIT. In liburing, this is generally done
with io_uring_sqring_wait(). There's a natural expectation that once
this call returns, a new SQE entry can be retrieved, filled out, and
submitted. However, the kernel uses the cached sq head to determine if
the SQRING is full or not. If the SQPOLL thread is currently in the
process of submitting SQE entries, it may have updated the cached sq
head, but not yet committed it to the SQ ring. Hence the kernel may find
that there are SQE entries ready to be consumed, and return successfully
to the application. If the SQPOLL thread hasn't yet committed the SQ
ring entries by the time the application returns to userspace and
attempts to get a new SQE, it will fail getting a new SQE.

Fix this by having io_sqring_full() always use the user visible SQ ring
head entry, rather than the internally cached one.

Cc: stable@vger.kernel.org # 5.10+
Link: https://github.com/axboe/liburing/discussions/1267
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 9d70b2cf7b1e..913dbcebe5c9 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -284,7 +284,14 @@ static inline bool io_sqring_full(struct io_ring_ctx *ctx)
 {
 	struct io_rings *r = ctx->rings;
 
-	return READ_ONCE(r->sq.tail) - ctx->cached_sq_head == ctx->sq_entries;
+	/*
+	 * SQPOLL must use the actual sqring head, as using the cached_sq_head
+	 * is race prone if the SQPOLL thread has grabbed entries but not yet
+	 * committed them to the ring. For !SQPOLL, this doesn't matter, but
+	 * since this helper is just used for SQPOLL sqring waits (or POLLOUT),
+	 * just read the actual sqring head unconditionally.
+	 */
+	return READ_ONCE(r->sq.tail) - READ_ONCE(r->sq.head) == ctx->sq_entries;
 }
 
 static inline unsigned int io_sqring_entries(struct io_ring_ctx *ctx)

-- 
Jens Axboe


