Return-Path: <io-uring+bounces-9366-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id EBD34B391E4
	for <lists+io-uring@lfdr.de>; Thu, 28 Aug 2025 04:51:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 3A83B4E17B3
	for <lists+io-uring@lfdr.de>; Thu, 28 Aug 2025 02:51:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC63E18C03F;
	Thu, 28 Aug 2025 02:51:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="to2CZCD1"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFF9526A088
	for <io-uring@vger.kernel.org>; Thu, 28 Aug 2025 02:51:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756349502; cv=none; b=P8NfjmxP2eatM6XaIDuwRJquNKY8WnvfBE1WJYyNdE7lOd3Z+sqWuKSOxwy4hms72n7+WUFIX9MKOfXwxZH/yBiYPY1pCyOpurbEvE1jnuNJcN4mY7322k/GLDm0kdCx/cyu5VjTUexddf1Rk1ROKAwSQX5CIej6ozVcn5ABXkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756349502; c=relaxed/simple;
	bh=4Gr5X0X/YuN7qEFwS9LooNKr47OT1oPAxdRNgqfMrMU=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Cc:Content-Type; b=pRpt++0CCKrVX391wkzr6m/el0m6PqPO+0Ue35oZksXuJQ4iEX8sedRuuuwX2GZYOYeAiVEIko8Qd3MtPgommbM/hx8xkM1Vvxm8T3xfvqqnvB/g2B4FqRsuvwsqWsi0nQewiPjEcfO/bkuMwbi7PRWxOLAtU/G7dbIrp1K1j58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=to2CZCD1; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2449978aceaso3688145ad.2
        for <io-uring@vger.kernel.org>; Wed, 27 Aug 2025 19:51:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1756349500; x=1756954300; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1zBwWoTd95xpm66fJ4wEvL2niUCRsz7qt4CwnNb4+ac=;
        b=to2CZCD10UzzlkE50xStU3Mo+RVQdb5YksgV3KxLx/HF864R05CDM/+hP09eAVY15I
         wNT1kmNMSIwtQ4qVe1xk8E9vISRnL7EiEfsf49Cd1TlYhAW9jRpLGCyh737wjaVnUJa8
         28ykcL/8eR23+Okw8kavoqYZu+9sYFMbe4Onsy33iKbGpK71pr/o67aPj5KeZgs0T45a
         MzwVM/D3gmhiaEwaDfnZRQegr+Ek8exIc99ev2Ns5q6Q2AZFK7Q+mh03bBHd+KTxaW97
         pOGSdzWgR4AqoOg2IqWkrWm/q/wQbc5k14s+SAkto4w4HoeheoverREOAGIwWJ2MZJE8
         hANw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756349500; x=1756954300;
        h=content-transfer-encoding:cc:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=1zBwWoTd95xpm66fJ4wEvL2niUCRsz7qt4CwnNb4+ac=;
        b=a7YBi4gWlKPEk57GiHHrGD4mb8UE/Qv+br36AjbihztzrORVBZE8mePQ0AS/DlAEtT
         rlqWjpfswhRiGN1AqYBQ5SPRDRX9CfxBePMYHFArzp4H+Kc5S7Zx5EQ/KMyVR5tHeE/J
         l7bWvVynRsCSA1a6A86ggufinO3/c/2Jn4cIHWzGTq71XUAS3UnpmzjK4IYS8o0o/XP6
         Lhv9lq/bSICmCcPWFosLjyUeHoX/A96HUbZz4uXSamJ/37c8dzBRFussPnjerdioFxjx
         gXEIdn73wOhta7MFK1QaqiLby0gJnKLiT/6SouH/SJtYQ0TgTVjXzJuvPheO+/vDsBBI
         nIrA==
X-Gm-Message-State: AOJu0YxNmP4aiiV6k3CVL+tRQyRCLTabqQCv0KbGwsxw04OfmA43fUo3
	eeE1aErI1C6Zk513lhB90L8pNxtKk16mlifN2fegxiX4+xmR0sXPyuS2lMjpo4Cpa5sfeEl8nkq
	t/1P8
X-Gm-Gg: ASbGncvfb9tEKgyb06kpfXb+n7SnQt2pxfrPXBwqAIrJr1iGHDkeOKPQUWdOFMgCSyz
	wKjjkdszdaLmLEOFajEjxj8D9TS186OXdO9hjsLInRhzgZp22Tb8OjooApWrPIwKj3k3/JJqOfK
	ouZtG8F4cj6kTYtghhUtYvkEXFyg1fkJatlpj+iEQNStn2R3kCiBsUoBpWjf8zWwtvVn6+Tlb7A
	sOrZujoRwTq3SQq2ZUbomqjlonQVTX/D3qMC7YAOH/RHHGFm+LpREi2aZDItceMomNvFz2lOQOc
	/BkGgFSn37nFoAe6O0SRdVk9x+z8cp6Ks2l2nkz0jxNX66OTXgVJQUvUgWOfioaEAPOugypK6O7
	SRwJQn3CgbRK7Be96xXrdoNEu2rISMA0=
X-Google-Smtp-Source: AGHT+IHEGCrjR68LM2517o+97LmtQTFIZNYVYHpByZT59dkml9i/RBm9QNNHtJm0XXtcLiMmLwN1kw==
X-Received: by 2002:a17:903:94e:b0:246:ae6e:e5db with SMTP id d9443c01a7336-246ae6ee847mr203112975ad.42.1756349499721;
        Wed, 27 Aug 2025 19:51:39 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-327af91f6ffsm269085a91.4.2025.08.27.19.51.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Aug 2025 19:51:39 -0700 (PDT)
Message-ID: <97dfa04b-25b0-4660-b3be-6fadfdd08a31@kernel.dk>
Date: Wed, 27 Aug 2025 20:51:38 -0600
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
Subject: [PATCH] io_uring/kbuf: always use READ_ONCE() to read ring provided
 buffer lengths
Cc: Suoxing Zhang <aftern00n@qq.com>, Qingyue Zhang <chunzhennn@qq.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Since the buffers are mapped from userspace, it is prudent to use
READ_ONCE() to read the value into a local variable, and use that for
any other actions taken. Having a stable read of the buffer length
avoids worrying about it changing after checking, or being read multiple
times.

Similarly, the buffer may well change in between it being picked and
being committed. Ensure the looping for incremental ring buffer commit
stops if it hits a zero sized buffer, as no further progress can be made
at that point.

Fixes: ae98dbf43d75 ("io_uring/kbuf: add support for incremental buffer consumption")
Link: https://lore.kernel.org/io-uring/tencent_000C02641F6250C856D0C26228DE29A3D30A@qq.com/
Reported-by: Qingyue Zhang <chunzhennn@qq.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 81a13338dfab..19a8bde5e1e1 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -36,15 +36,19 @@ static bool io_kbuf_inc_commit(struct io_buffer_list *bl, int len)
 {
 	while (len) {
 		struct io_uring_buf *buf;
-		u32 this_len;
+		u32 buf_len, this_len;
 
 		buf = io_ring_head_to_buf(bl->buf_ring, bl->head, bl->mask);
-		this_len = min_t(u32, len, buf->len);
-		buf->len -= this_len;
-		if (buf->len) {
+		buf_len = READ_ONCE(buf->len);
+		this_len = min_t(u32, len, buf_len);
+		buf_len -= this_len;
+		/* Stop looping for invalid buffer length of 0 */
+		if (buf_len || !this_len) {
 			buf->addr += this_len;
+			buf->len = buf_len;
 			return false;
 		}
+		buf->len = 0;
 		bl->head++;
 		len -= this_len;
 	}
@@ -159,6 +163,7 @@ static void __user *io_ring_buffer_select(struct io_kiocb *req, size_t *len,
 	__u16 tail, head = bl->head;
 	struct io_uring_buf *buf;
 	void __user *ret;
+	u32 buf_len;
 
 	tail = smp_load_acquire(&br->tail);
 	if (unlikely(tail == head))
@@ -168,8 +173,9 @@ static void __user *io_ring_buffer_select(struct io_kiocb *req, size_t *len,
 		req->flags |= REQ_F_BL_EMPTY;
 
 	buf = io_ring_head_to_buf(br, head, bl->mask);
-	if (*len == 0 || *len > buf->len)
-		*len = buf->len;
+	buf_len = READ_ONCE(buf->len);
+	if (*len == 0 || *len > buf_len)
+		*len = buf_len;
 	req->flags |= REQ_F_BUFFER_RING | REQ_F_BUFFERS_COMMIT;
 	req->buf_list = bl;
 	req->buf_index = buf->bid;
@@ -265,7 +271,7 @@ static int io_ring_buffers_peek(struct io_kiocb *req, struct buf_sel_arg *arg,
 
 	req->buf_index = buf->bid;
 	do {
-		u32 len = buf->len;
+		u32 len = READ_ONCE(buf->len);
 
 		/* truncate end piece, if needed, for non partial buffers */
 		if (len > arg->max_len) {

-- 
Jens Axboe


