Return-Path: <io-uring+bounces-8332-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E847AD937F
	for <lists+io-uring@lfdr.de>; Fri, 13 Jun 2025 19:07:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8E7FE3BD79A
	for <lists+io-uring@lfdr.de>; Fri, 13 Jun 2025 17:07:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37DA61F4722;
	Fri, 13 Jun 2025 17:07:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="2myHWUiQ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f179.google.com (mail-il1-f179.google.com [209.85.166.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E878320B1F7
	for <io-uring@vger.kernel.org>; Fri, 13 Jun 2025 17:07:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749834441; cv=none; b=WN8FQw3NlgqZ3MouOoDWcIpiyO8gkvVA5QZMaqNAH3QSBFjPke9zZE6l6xz0/cUI8IwgkAjzLhULPgi9GY3yZi4fSe9SwGdXnTOmbQYGy/oXgIEanQewPLXYrjsTuJ3ZnY5+lr6n5sHrQz8qN4t3CFPxBCTLW4BgSo8eEoad6AQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749834441; c=relaxed/simple;
	bh=nCiRNxfMS/rfZHvlaFOtNDnC49HQR0iOKznGXG3vuPw=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=YcSSjLGn2G7t27IaBUQgj/qZSyk9vj4iAIvt2dEe9OlE7mkLmtA409g2JD7riyurWWAVG/fG4xefKr5vLnvC1dhpysodWCMBmuZWmEPl7PqM9f1ExonQlesrz70uo6FyLsXPO+kdL2cky6Y7UTGQDil6i8U0zaqoa/UK/U2B7oM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=2myHWUiQ; arc=none smtp.client-ip=209.85.166.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f179.google.com with SMTP id e9e14a558f8ab-3ddd68aeb4fso19003105ab.2
        for <io-uring@vger.kernel.org>; Fri, 13 Jun 2025 10:07:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1749834436; x=1750439236; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5LMjx9/y97NyYJB9C7X6g0EaSJUuqRlAxhLBfe1WOps=;
        b=2myHWUiQ6f9+4BBMGE8DmFVQNhK/2TN+8PCpurG8FQNxIt1sB1aS2+VpdPN5e7XHI0
         rbavFK2il9eMxsQA5jaQW9zfxJI7AfYGFwW+2PKQRMFZlzZzdRa5/evvtIlNDBInRItD
         YVMPwdMBeoFUWWUo78SSXv0/NILsWsBXfh27lJi5wU4iyF9/hLVcHt2VAVDI9Z/iGDFC
         0l1wcsbw77A//0GuRRQVSZSTHVG4xvsQowwCVHRJ7eghF4YENQesGM9fNeuyI90rjPIG
         4bJcdubzO77SgesxUIPIJ85FJLThYhEYzS9GHZUSYGfWycfAcMqCh/42jaxHbVnvjycW
         5Xqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749834436; x=1750439236;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=5LMjx9/y97NyYJB9C7X6g0EaSJUuqRlAxhLBfe1WOps=;
        b=XxsyZ0Ga7MH3yafxmjCSmduvDN7gfPLUg62X3vjwA5rVqWzne7UuR3FuZiG5QS80bI
         IMxtxWhEjT9cWbWlQVrsSRfbtFmvegsonrlBNQtAZJAmgats/RSF59T92sDcbn5dLzFJ
         Dr0AVhYlKVpjRaRyLvvPcovgxpUUIpubLNh7yCExKHMMJEG+3BtgFS1LeeI5RtmrDcTj
         wS9+nqAa8cuzpjOyiENrkJ4G9F4GHBmKcVk2S1gkxQMaOjlEB/tm6QWkdiobzFIyw1so
         cItc6KuORCcw75bS1tLc0aYGDpO94CmeR7GgDQO4E09VVdwbqfuyuaxua/Mz+IrTx5I8
         hfxQ==
X-Gm-Message-State: AOJu0YzC/X4loAd445UfoR+/mOf/CN4j/up/Og9aj0Hc6MwNmXMlD0pk
	BcprHhjqdWteg5hT99QGziqepkLe16UoSFQsh1vKC37QGb67Et2ZPaOEuzJ2ofFB6UQOQa9zqWt
	m/G6H
X-Gm-Gg: ASbGncuSNVudg5rPY8AM6wmU/Rgu4bIV8iVICo+EWuYH7sFvH8Mzriu5V2IufFzo1Jo
	L/UUI2C3WU8eda5+A3RAhtvJlvPzly2F/ii7p2ccYPTwQzk5BY2S7YRD0NpEesrvO8VfjQFZKkD
	CymmmBm6akOLaT/40A3MxsgSfbdzkM1F59TwCuYNF4qDzfo9mwdVBnw0ysRcJS5QypGaXuMrLv7
	vKFNep+B6ITv8WTHWzu/beit87Xif/6L7ebPJs/IbwgdOU2rU68OgSIUpaHxurntGjDkZT22OfT
	ah9UCXsdS3g8CEaH6yBGlbvrBJysxfcuPKVFvp6Ks9bCpGd2KDd1opuGCw==
X-Google-Smtp-Source: AGHT+IEefSTkxbuT2KI7N38yA9RJr1Xpyb20lc0fRGe4jAzIQ+GkfyI/YFIGC89ve6LF+kNIO88wcw==
X-Received: by 2002:a05:6e02:1aa4:b0:3dd:ecc8:9773 with SMTP id e9e14a558f8ab-3de07ccda59mr5093105ab.19.1749834436524;
        Fri, 13 Jun 2025 10:07:16 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-50149ca2a92sm386041173.124.2025.06.13.10.07.15
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Jun 2025 10:07:15 -0700 (PDT)
Message-ID: <eaa3b732-bcac-4478-94bd-94dae61ff8a4@kernel.dk>
Date: Fri, 13 Jun 2025 11:07:15 -0600
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
Subject: [PATCH] io_uring/kbuf: don't truncate end buffer for multiple buffer
 peeks
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

If peeking a bunch of buffers, normally io_ring_buffers_peek() will
truncate the end buffer. This isn't optimal as presumably more data will
be arriving later, and hence it's better to stop with the last full
buffer rather than truncate the end buffer.

Cc: stable@vger.kernel.org
Fixes: 35c8711c8fc4 ("io_uring/kbuf: add helpers for getting/peeking multiple buffers")
Reported-by: Christian Mazakas <christian.mazakas@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 2ea65f3cef72..ce95e3af44a9 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -270,8 +270,11 @@ static int io_ring_buffers_peek(struct io_kiocb *req, struct buf_sel_arg *arg,
 		/* truncate end piece, if needed, for non partial buffers */
 		if (len > arg->max_len) {
 			len = arg->max_len;
-			if (!(bl->flags & IOBL_INC))
+			if (!(bl->flags & IOBL_INC)) {
+				if (iov != arg->iovs)
+					break;
 				buf->len = len;
+			}
 		}
 
 		iov->iov_base = u64_to_user_ptr(buf->addr);

-- 
Jens Axboe


