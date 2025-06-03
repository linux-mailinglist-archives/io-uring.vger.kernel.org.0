Return-Path: <io-uring+bounces-8193-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 578C1ACC82A
	for <lists+io-uring@lfdr.de>; Tue,  3 Jun 2025 15:45:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 107A03A21F4
	for <lists+io-uring@lfdr.de>; Tue,  3 Jun 2025 13:45:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F2B9221F06;
	Tue,  3 Jun 2025 13:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="u5NdKfu3"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f182.google.com (mail-il1-f182.google.com [209.85.166.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB1CF26290
	for <io-uring@vger.kernel.org>; Tue,  3 Jun 2025 13:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748958326; cv=none; b=puw5wXyD7/dZaBA+BVhm0EB5glYGgxHFWGOW3hBZGgrWU5XwovkkH5kPjVnA0zxgPMb4Pb0OItcepyEy2RK5lpeIkdVszWBzZ1NvG1G/df79Rb6O6udUJ18Axds2YnmrxOXcwBqPVdxGEGsB1b0FvSi8fZyi42gJoxwT7tRbsNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748958326; c=relaxed/simple;
	bh=Kfu09hM5HtVVWb4TYVCHP6LWdna8oWSWrV7WWpxnw9Y=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=IUFAdgFpCVE0YkGbYbIOz076NgwZVNc9OOg7TJpixI3gh7u6ikHpiUeChG69IfTCk4erOCOj4IBL5vpbvlmuAATKxvyx82MOZAmpCTj1Jf78sc7scJxIk6tuqkfCwdYVbqs5FxHgRMlgwXMpi0duS1/TmIZj0UkknoDdXDg0Y+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=u5NdKfu3; arc=none smtp.client-ip=209.85.166.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f182.google.com with SMTP id e9e14a558f8ab-3ddb5f6f008so10311785ab.0
        for <io-uring@vger.kernel.org>; Tue, 03 Jun 2025 06:45:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1748958321; x=1749563121; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0orroggcvj8CvRMkZXjIaFPdpoxK6aZZKJBUumP0MZA=;
        b=u5NdKfu3LHjQl/sIulGW06TI9kaV0wc6EUyXY0DVqO88++PAUG1N0H6eQSYq5mO5Vk
         vbi4vrfJs9+AIFDT0mp+l7aEaFhtS+C9xG8AQbGbc1mQPy/7bojq973gJdA5fGBifM1k
         vKASy2b5SZGjf58AZUJm95GWo3PcFcJbIjdrM3sgjrUWwomgkgHuFAcNZnWmNQX0uq7P
         FzM9PIp3/6I5VHbj6uNBsqtISS/DpWFcyfH8VggcjAKEjdRyfghrWvUk2IBqvpfvR2mo
         Ib0w0TBA+bbNHRu4QnWSxko2HzdvoKirgqslB4cIJrnE2n7bLIZR9liHclxdWGyZeDcS
         7dHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748958321; x=1749563121;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=0orroggcvj8CvRMkZXjIaFPdpoxK6aZZKJBUumP0MZA=;
        b=ILV6CFJhioFa3/wDOEySHCbI5zrVkUJHAA9v5ct9Md+7GI7hfUfxjtgH/HnoH4njYF
         TWlx+sZls/28h/7p1u589rEpR0DPy5jJ5JJcGebJhc5QT5cHFGI5exl4OjPdi8NgPzlV
         J2WMXMkq87oausS7gvARHmRofLofatBIJWt2dRKBvrR0a2jiI/CrM7xo/aMOnRTVXGaI
         psn+AKdvL6csIRGuVsPw802qutPc3qdUZTAnEJMNUjXzq51iAcYlp66pPC31Qqiv/Wsc
         aCnf5e+G6XaicYSgZW1baGQrNZIX0M+cCYCvdM2DH+IQdUva2QsuM3520UK7kxByCR6E
         DgQw==
X-Gm-Message-State: AOJu0Yxcc86HsPn2wm8mIYdfCaGSWXTKZI0sZHRsoui/JXXmoBB2E/p+
	ztSC0KcO4NPt/bYotzMxjE18gbC/nlxNbpJEHUwK+7/LDY7yxY58wDGlLww2gV9FLy5OyjP/YsB
	rArN1
X-Gm-Gg: ASbGnctXGZ5FZOBHkoQR9kgLKHx3CzQVT0ynnv9+vYOyLbvH4ivWf3gfRvQEsUs7cD4
	rpxdADtOOYNwd4Pj9U0tJzhCbRW9rFv2cBN3gq2KaDGLylLUDBcjwADnF6Fy6Mgcdz4yolCnOtE
	2722ZG1BgYksEaTHDg+j96PSum/ugSKPDP7v7AyzoruXFeci4yfEg7CEIoiEAn4ZBl3I/SVH8AC
	JPibrTB1S202qYub7RwFxS3GGOF8XBYtCvAoTE+Jbfn6w9A4a4g+Tr6Da4V4HE8sxZvaO7K7TD/
	qB+54V/olD4S9ezoAdupI4xeZo3Ug+UD7LILpbnHs2YpweoT/tu+ERDBrQ==
X-Google-Smtp-Source: AGHT+IE7LR00lMCwMBFOjpMB3p62nluM2F95/ZcOsCgB7Hgu+qfEInM5vPVs6exuRV7HPuVjkr4C+g==
X-Received: by 2002:a05:6e02:4508:20b0:3dc:7b3d:6a37 with SMTP id e9e14a558f8ab-3dd9c993681mr121866295ab.8.1748958321226;
        Tue, 03 Jun 2025 06:45:21 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4fdd7ed8111sm2220817173.102.2025.06.03.06.45.20
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Jun 2025 06:45:20 -0700 (PDT)
Message-ID: <3e697273-5574-43fe-b310-ddc7e22ab5c0@kernel.dk>
Date: Tue, 3 Jun 2025 07:45:20 -0600
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
Subject: [PATCH] io_uring/kbuf: limit legacy provided buffer lists to
 USHRT_MAX
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

The buffer ID for a provided buffer is an unsigned short, and hence
there can only be 64k added to any given buffer list before having
duplicate BIDs. Cap the legacy provided buffers at 64k in the list.
This is mostly to prevent silly stall reports from syzbot, which
likes to dump tons of buffers into a list and then have kernels with
lockdep and kasan churning through them and hitting long wait times
for buffer pruning at ring exit time.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 8cce3ebd813f..1e123ea94233 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -108,6 +108,7 @@ bool io_kbuf_recycle_legacy(struct io_kiocb *req, unsigned issue_flags)
 	buf = req->kbuf;
 	bl = io_buffer_get_list(ctx, buf->bgid);
 	list_add(&buf->list, &bl->buf_list);
+	bl->nbufs++;
 	req->flags &= ~REQ_F_BUFFER_SELECTED;
 
 	io_ring_submit_unlock(ctx, issue_flags);
@@ -122,6 +123,7 @@ static void __user *io_provided_buffer_select(struct io_kiocb *req, size_t *len,
 
 		kbuf = list_first_entry(&bl->buf_list, struct io_buffer, list);
 		list_del(&kbuf->list);
+		bl->nbufs--;
 		if (*len == 0 || *len > kbuf->len)
 			*len = kbuf->len;
 		if (list_empty(&bl->buf_list))
@@ -390,6 +392,7 @@ static int io_remove_buffers_legacy(struct io_ring_ctx *ctx,
 	for (i = 0; i < nbufs && !list_empty(&bl->buf_list); i++) {
 		nxt = list_first_entry(&bl->buf_list, struct io_buffer, list);
 		list_del(&nxt->list);
+		bl->nbufs--;
 		kfree(nxt);
 		cond_resched();
 	}
@@ -491,14 +494,24 @@ static int io_add_buffers(struct io_ring_ctx *ctx, struct io_provide_buf *pbuf,
 {
 	struct io_buffer *buf;
 	u64 addr = pbuf->addr;
-	int i, bid = pbuf->bid;
+	int ret = -ENOMEM, i, bid = pbuf->bid;
 
 	for (i = 0; i < pbuf->nbufs; i++) {
+		/*
+		 * Nonsensical to have more than sizeof(bid) buffers in a
+		 * buffer list, as the application then has no way of knowing
+		 * which duplicate bid refers to what buffer.
+		 */
+		if (bl->nbufs == USHRT_MAX) {
+			ret = -EOVERFLOW;
+			break;
+		}
 		buf = kmalloc(sizeof(*buf), GFP_KERNEL_ACCOUNT);
 		if (!buf)
 			break;
 
 		list_add_tail(&buf->list, &bl->buf_list);
+		bl->nbufs++;
 		buf->addr = addr;
 		buf->len = min_t(__u32, pbuf->len, MAX_RW_COUNT);
 		buf->bid = bid;
diff --git a/io_uring/kbuf.h b/io_uring/kbuf.h
index 4d2c209d1a41..5d83c7adc739 100644
--- a/io_uring/kbuf.h
+++ b/io_uring/kbuf.h
@@ -21,6 +21,9 @@ struct io_buffer_list {
 		struct list_head buf_list;
 		struct io_uring_buf_ring *buf_ring;
 	};
+	/* count of classic/legacy buffers in buffer list */
+	int nbufs;
+
 	__u16 bgid;
 
 	/* below is for ring provided buffers */

-- 
Jens Axboe


