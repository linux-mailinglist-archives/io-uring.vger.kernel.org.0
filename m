Return-Path: <io-uring+bounces-5664-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 709EFA00C4E
	for <lists+io-uring@lfdr.de>; Fri,  3 Jan 2025 17:41:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 448B9164373
	for <lists+io-uring@lfdr.de>; Fri,  3 Jan 2025 16:41:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83D9C169397;
	Fri,  3 Jan 2025 16:41:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="YQRNR4S4"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD1F359B71
	for <io-uring@vger.kernel.org>; Fri,  3 Jan 2025 16:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735922498; cv=none; b=PXQd7HunAfPZpfhDV3ADzszEvjlfeFrKcR2iCCuRCwHfcYO8yjEN3pgcNDooo4w2KwX12SpgFeuEdoXkN2UYFlnfM7PSdAkVlwZuEwIH1mItJ1CS1jwKvDLXVvcgAzf0ZLlFid4AbfxQkEhr9S7Yg/VnEKiNV2oIEC6vtMVGBBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735922498; c=relaxed/simple;
	bh=kUym3lrU/7IMm1z4SKUoAWrsHA5jsICPmi9XietQ92g=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=ebnjw4MLACxrfw2EJGUvfcLzypQgi7/SjgTHE81UiPXMANfVzT173yeCf3rpuI5G0jS2W2FpQkPlLLppunZqI5YOQNbzMJ0SB/+SYrCk6mbVTIHfFZl97zcpWEaAr0M4zoQzii7eNjf21/y2FJfk0Yy5VENBv2d34O5FHy690tA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=YQRNR4S4; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-21644aca3a0so97014295ad.3
        for <io-uring@vger.kernel.org>; Fri, 03 Jan 2025 08:41:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1735922493; x=1736527293; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rLY2QukIitdH7A50Yx+8NoP7Y5sF2x2qAPa60MYQtM8=;
        b=YQRNR4S4/hYKMG/ydJ37RAjrFk5SjX3eAgON5phiHqsB5m6JWwU3NUIwVek/jFsxE6
         HBmcHAftQq5E5fg7R+FWLsSQRbIGP7AUzkbeTSSZE7/Vgp/rtoUUe8gR4KtGG4tXwZSS
         eYEQwifKO60yMqBZJ4lYnHb5bGa+RIxNWmugsbLisPS4S2lYs6KuN2LlOwtl+50Ao9ZE
         vNTAkAyPGTGA9pFXBt3h2yDrnm2tYr0XgKV9esrIDwwMPFwvUrv99wfGZ+CeEVzivtfZ
         ygAekly2Z5eGwCrABucUqvzLHkuHXCKW/+e5ArPysFmGDqldD9fd5psMDKJKOW5Qb5dN
         08zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735922493; x=1736527293;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=rLY2QukIitdH7A50Yx+8NoP7Y5sF2x2qAPa60MYQtM8=;
        b=BH2jkTN17g0+wbX2yQM5jHlGODEx4jE++6xUC+HEtkfwqfxk509kvWaR+e/5eGrKku
         pLR2jKzAIf2cJoDaB8fRjopTF8Kgat6anC7jMg/JTjOGV4Up4r5Ki4sojB9zvU2e8of/
         yHFJ853qNPtXHW8y3trm/yBXaCgQS4zFmaVzeGCsLWc8ovUtk26GbkyNuNEVYC3Q5ome
         0jF/FS2i2/WVaHmvkO3ZN4BETgoy0AVvC1sJuph7olynawFvkHwe5Sllk/jXou8Yp+At
         YpUcsRuzqHiclmO0IqVyNEajg8ghLuhBVO6WtAckPGl6E32PqqyzhRuYcWlXoPIoScRs
         8ijg==
X-Gm-Message-State: AOJu0YzLfMoCUBR7X0dJ55VWmwCJQzW/N3Usd0b7JYV9Q5BmV8nq7STL
	UzlasktI5MxtcB3BhvC59I1vsS0mjZ17XdNcrG8OQsk2hYDFRKI3/o0FMw8uxIh00/frfiT7fcL
	K
X-Gm-Gg: ASbGncuVpeLHQvM/6fUsYPsxjL0A9e/zdnRqItcK51wuoNmNz/6z8OnZkho8QagEM+7
	yiiICcOGyrxazGg2an1aBNyEd1DU53lwlvxNG1wKmw2ylZIheoBIFbSf4gbO1HPCZMTzYRD0qYt
	8cChi2FhKsnK1PlgTb4iyk9OWPrPDl7kxOck/6i/tVGYqYyBHL7s8BRZ3yHzqiyeW0DGdSID+jv
	pyyXVK6vIsQbpbeHk4R8iyyIeoe2Dq1qvvcG7UgYWYAG8vHMJKd7Q==
X-Google-Smtp-Source: AGHT+IGD4rtcqXc9PqUBWXj9WvJxFKjzche0R0JE8jBztU+CnuQtrewUbkHA4nRM3tU8j5Lk+P9w0Q==
X-Received: by 2002:a17:903:41c6:b0:215:b75f:a1e0 with SMTP id d9443c01a7336-219e6e894e9mr489501305ad.7.1735922492483;
        Fri, 03 Jan 2025 08:41:32 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-219dc971751sm246348765ad.109.2025.01.03.08.41.31
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Jan 2025 08:41:31 -0800 (PST)
Message-ID: <10c8ed15-56ea-4f2c-ad1b-605fbf212b88@kernel.dk>
Date: Fri, 3 Jan 2025 09:41:30 -0700
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
Subject: [PATCH] io_uring/kbuf: use pre-committed buffer address for
 non-pollable file
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

For non-pollable files, buffer ring consumption will commit upfront.
This is fine, but io_ring_buffer_select() will return the address of the
buffer after having committed it. For incrementally consumed buffers,
this is incorrect as it will modify the buffer address.

Store the pre-committed value and return that. If that isn't done, then
the initial part of the buffer is not used and the application will
correctly assume the content arrived at the start of the userspace
buffer, but the kernel will have put it later in the buffer. Or it can
cause a spurious -EFAULT returned in the CQE, depending on the buffer
size. As bounds are suitably checked for doing the actual IO, no adverse
side effects are possible - it's just a data misplacement within the
existing buffer.

Reported-by: Gwendal Fernet <gwendalfernet@gmail.com>
Cc: stable@vger.kernel.org
Fixes: ae98dbf43d75 ("io_uring/kbuf: add support for incremental buffer consumption")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index d407576ddfb7..eec5eb7de843 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -139,6 +139,7 @@ static void __user *io_ring_buffer_select(struct io_kiocb *req, size_t *len,
 	struct io_uring_buf_ring *br = bl->buf_ring;
 	__u16 tail, head = bl->head;
 	struct io_uring_buf *buf;
+	void __user *ret;
 
 	tail = smp_load_acquire(&br->tail);
 	if (unlikely(tail == head))
@@ -153,6 +154,7 @@ static void __user *io_ring_buffer_select(struct io_kiocb *req, size_t *len,
 	req->flags |= REQ_F_BUFFER_RING | REQ_F_BUFFERS_COMMIT;
 	req->buf_list = bl;
 	req->buf_index = buf->bid;
+	ret = u64_to_user_ptr(buf->addr);
 
 	if (issue_flags & IO_URING_F_UNLOCKED || !io_file_can_poll(req)) {
 		/*
@@ -168,7 +170,7 @@ static void __user *io_ring_buffer_select(struct io_kiocb *req, size_t *len,
 		io_kbuf_commit(req, bl, *len, 1);
 		req->buf_list = NULL;
 	}
-	return u64_to_user_ptr(buf->addr);
+	return ret;
 }
 
 void __user *io_buffer_select(struct io_kiocb *req, size_t *len,
-- 
Jens Axboe


