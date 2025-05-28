Return-Path: <io-uring+bounces-8123-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 05633AC71FA
	for <lists+io-uring@lfdr.de>; Wed, 28 May 2025 22:15:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 106B9165212
	for <lists+io-uring@lfdr.de>; Wed, 28 May 2025 20:03:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55E12220687;
	Wed, 28 May 2025 20:02:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ff4AGcKQ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f182.google.com (mail-il1-f182.google.com [209.85.166.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D654220F2B
	for <io-uring@vger.kernel.org>; Wed, 28 May 2025 20:01:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748462520; cv=none; b=doT7Ftc5wA2IttoT3mf2fZq5SFtMf0YReg57H8CRZor+AqclI3D5u4ojqo7Bj82POZJUtiRLM6ol036ejEfW7DDVG/L1O7+7cLcNMJOosQO1/Pxk3zTuHjAjR5R5V2SlcZUsugM5kdwr6zLcooSEfrolroGY8MIPSMGSWRBRdC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748462520; c=relaxed/simple;
	bh=B2mqQWMeWrglIjCFFm4KYIBryEjNVxbNaa/Xles5CR8=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=sCOvEALS1Cfcu8EneGYDTnF0mK8YZSe8kigsaV2ioAUacer5uRzionO4cWGHaxZMgjevvYh5CorRGE8fIJTab3aCB0agu5cG9IqpuxwJc8Stx89k4MNNdh+O/dT8jeUv7j32s8xqGbRkoz55Tuw9SjcEFonm3jCmEZn+itDtxgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ff4AGcKQ; arc=none smtp.client-ip=209.85.166.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f182.google.com with SMTP id e9e14a558f8ab-3dc6f653152so703745ab.3
        for <io-uring@vger.kernel.org>; Wed, 28 May 2025 13:01:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1748462515; x=1749067315; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0XIj+NPn2xMr4zUJSyWaI9AseRjaSOC5SkMKdP4rj7c=;
        b=ff4AGcKQDpJQ52qX5S0sOzA7sGCRlP9Bi2j4h/K8Q+l06vhZHaZF85PmDS1hMQGmk6
         CJWHcDp11ThPhIXviYkUnPelDe5x6e8CXDSu05aj+8BlWnj0iedWQbrgaOvcaKo8vY80
         eu8Z0yIz55dozobdYCGEmXyLWOOUZ/DCr0R72VK7XIMkC7gq1RMVnEr5eaveSTh9I8NO
         QaxwtixbKNp/hUNkun0pJT2ByysGJYWb92+RN3d+QavpKzpeNarvLYvB8+ankV5ax9l1
         i71WqKvo4bB+Q7VGYIhzsWbkhBy7ykejFGr/PKl7TUIXoFXs2AM+lIb8/dUGKmRUum/w
         5pLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748462515; x=1749067315;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=0XIj+NPn2xMr4zUJSyWaI9AseRjaSOC5SkMKdP4rj7c=;
        b=RN7/GAx/R1xtZN1De63MHIAoT8Dr7Qm79Xo7wbqPZbAN1r9JZ5eZD9GPli5fVNU0HI
         1U8qwV/8juDglFErdAUiaGIPENcYiHBVyf1ipxmifvO7hQJnl5Eh3WTa3iYG45AhsMTf
         sLsrBrd0TLssqICv3zjknSz53XtHHpwMwxf0WXsw6t6DDoY8jb7+VY6BwN11i/Ch7WiV
         U1J+caJsmsV1QJxfCL/TYCu3kMiXiYVu3fd7OFqdT2wn2Ml9h4fAerdtB/zijQN+4jIk
         ylUtsPBIBo5uaDIqlEuu9TEPVxvzgQUyCCIcaR7IBwRn04eA60LdW79B6JB4mJzQnPzD
         EWwA==
X-Gm-Message-State: AOJu0Yydq4PzzRHXrbH5wmjtLA8amggMecK1kPVvJ2+bLutDjbr3uSMA
	9xYNrqYSkPTT0YXj134yNqOQoBQX/jB0fnCuWh61oe9WiSMhh8QlTGUvNvr1tdx2uISOHH8zqTX
	Ox+Ch
X-Gm-Gg: ASbGnctOK0xkFC1Fw08UL1R2lxvLkDY8uNcgVpNg2+OrVA+Exlkg6IUy8AP4Hq7hkCY
	0frft46Sx+t71IcOZ4wRTFsHOO7JrLUhyD/g1S35IIRxwcVp93ivWPOjTpeXbZptY4gIGg/YZkO
	u26dMXpkgVQ1Vct74KDaECmKhRgZgXKoW8YDerK/pXblnibU7O1RfPkOS2dbCNS67wW5IqMS3VA
	shlr3EnBWzK4IT3V54JKgRWuVPmqc3c4x92GHSxEaEFDEZyhEeWLElMxjyIIm8DJwyYlSVymOIV
	U08D834C9O8TQx0Hr+HUfOd+dEgF3ywnR5d/c5LDYOLAex2BhKPN5Kkobw==
X-Google-Smtp-Source: AGHT+IHZQH6yzQPN3ZdwvLSu47UgIcTUdp9NGivCkF52Vbd9FoZFgd142FHk7WL+MVdp/RnUzhYbgQ==
X-Received: by 2002:a05:6e02:398b:b0:3d9:36a8:3da0 with SMTP id e9e14a558f8ab-3dc9b67099dmr191120925ab.2.1748462514735;
        Wed, 28 May 2025 13:01:54 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3dd8c1f3a58sm4453955ab.56.2025.05.28.13.01.54
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 May 2025 13:01:54 -0700 (PDT)
Message-ID: <3586dce5-ea41-465c-9463-ed081b130482@kernel.dk>
Date: Wed, 28 May 2025 14:01:53 -0600
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
Subject: [PATCH] io_uring/net: only consider msg_inq if larger than 1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Currently retry and general validity of msg_inq is gated on it being
larger than zero, but it's entirely possible for this to be slightly
inaccurate. In particular, if FIN is received, it'll return 1.

Just use larger than 1 as the check. This covers both the FIN case, and
at the same time, it doesn't make much sense to retry a recv immediately
if there's even just a single 1 byte of valid data in the socket.

Leave the SOCK_NONEMPTY flagging when larger than 0 still, as an app may
use that for the final receive.

Cc: stable@vger.kernel.org
Reported-by: Christian Mazakas <christian.mazakas@gmail.com>
Fixes: 7c71a0af81ba ("io_uring/net: improve recv bundles")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/net.c b/io_uring/net.c
index d13f3e8f6c72..e16633fd6630 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -832,7 +832,7 @@ static inline bool io_recv_finish(struct io_kiocb *req, int *ret,
 		 * If more is available AND it was a full transfer, retry and
 		 * append to this one
 		 */
-		if (!sr->retry && kmsg->msg.msg_inq > 0 && this_ret > 0 &&
+		if (!sr->retry && kmsg->msg.msg_inq > 1 && this_ret > 0 &&
 		    !iov_iter_count(&kmsg->msg.msg_iter)) {
 			req->cqe.flags = cflags & ~CQE_F_MASK;
 			sr->len = kmsg->msg.msg_inq;
@@ -1070,7 +1070,7 @@ static int io_recv_buf_select(struct io_kiocb *req, struct io_async_msghdr *kmsg
 			arg.mode |= KBUF_MODE_FREE;
 		}
 
-		if (kmsg->msg.msg_inq > 0)
+		if (kmsg->msg.msg_inq > 1)
 			arg.max_len = min_not_zero(sr->len, kmsg->msg.msg_inq);
 
 		ret = io_buffers_peek(req, &arg);

-- 
Jens Axboe


