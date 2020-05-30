Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF43F1E937D
	for <lists+io-uring@lfdr.de>; Sat, 30 May 2020 21:46:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728998AbgE3Tqy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 30 May 2020 15:46:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726898AbgE3Tqy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 30 May 2020 15:46:54 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF37BC03E969
        for <io-uring@vger.kernel.org>; Sat, 30 May 2020 12:46:53 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id l26so7015434wme.3
        for <io-uring@vger.kernel.org>; Sat, 30 May 2020 12:46:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:from:autocrypt:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=5/yzlnAaUxZysUtEwHs9wEdhEX3nW12xiLPztKNdXGU=;
        b=biq/rjZhTnGEQ/o1IHkXs/xWCok2HK07RK4UxyiiYFjd0w6nJ2yJS53g3jAbpQYT74
         mB41Cp2e2F5lKSdBsoa7EmBMKhY7mXLFb7NGVFygxImYpDtrYoqbBFk3ucrOkQ7Y1I+j
         Lvu2tCWgaZanncc/xn0iCvgckKRXtsXcXEnnT3C1DLtO8W/ppTWLWUk1sM7SXuwuIX2j
         66NexZ+3sLq/Nvp5nCoqh18+BDM2/1I4VAn54nKx6wY3jY5FFwy3DdRKbgcQpIG/cJjE
         lYsJgQqdw6VaV+CO/ihm5g65ofTSDEBTkopViFrEm2WqUj4gNfJ29eot8R9jxvELM5TZ
         qRDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:autocrypt:subject:message-id:date
         :user-agent:mime-version:content-language:content-transfer-encoding;
        bh=5/yzlnAaUxZysUtEwHs9wEdhEX3nW12xiLPztKNdXGU=;
        b=VQcSt5s8nyB13N69oE+cKafPwY3tA+37QMQJbL+4rqdeqBwvMUwce06GlYIaJIMbaI
         mBq3Ndhw7Hf1nbS6VSgO8xiwaYe8/ByeZrYniB1HPg7VgBGHxyjvt2zS98BHZixma3lg
         OdGOweiVgxbJxNyCmhcHrE1w1tFQHH/MdbzwIitzF5Cv1lPD3H7tBHSA1xlLREbmF1f7
         ir5zdxdbpsqNUcbrPK82oeFbTj7XwfijqsIaCienIApZ/+nt6iv1CwqbszJNW2PaJCTQ
         fQpKmOohSuP+OY1OHv3sbBGqUOoWlPSGRLtqhY2DM13FR5MENZ0vRbwpiGcLgrQFNGBC
         ImXg==
X-Gm-Message-State: AOAM5300ZtKHu51Fj6HWsbKYLkkplT2S835TGdOrGoDsipcVdnjfFDZj
        nA2/b/1QTDZ2wsQZ7Ob2nSO5WOCz
X-Google-Smtp-Source: ABdhPJxqHPoThJws8Sbe2l/gh3D1w0z5MqmqHT1LT7BkuGRCN7qdMJXIB8EFpgK7sdPYEXmQ9BxUMg==
X-Received: by 2002:a05:600c:1008:: with SMTP id c8mr14366242wmc.95.1590868012251;
        Sat, 30 May 2020 12:46:52 -0700 (PDT)
Received: from [192.168.43.60] ([5.100.193.151])
        by smtp.gmail.com with ESMTPSA id b18sm14361923wrn.88.2020.05.30.12.46.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 30 May 2020 12:46:51 -0700 (PDT)
To:     Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: io_uring: open/close and SQPOLL
Message-ID: <b5860d6a-8db7-edf2-d58a-2d7d8b35edc1@gmail.com>
Date:   Sat, 30 May 2020 22:45:36 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Do I miss something, or open/close/etc need an explicit check
for IORING_SETUP_SQPOLL? E.g., now an open() request somehow
returns -EFAULT, and that doesn't seem good.


diff --git a/fs/io_uring.c b/fs/io_uring.c
index 732ec73ec3c0..e841fd03d976 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3023,6 +3023,8 @@ static int io_openat2_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	size_t len;
 	int ret;
 
+	if (unlikely(req->ctx->flags & (IORING_SETUP_IOPOLL|IORING_SETUP_SQPOLL)))
+		return -EINVAL;
 	if (sqe->ioprio || sqe->buf_index)
 		return -EINVAL;
 	if (req->flags & REQ_F_FIXED_FILE)
@@ -3417,6 +3419,8 @@ static int io_close_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	 */
 	req->work.flags |= IO_WQ_WORK_NO_CANCEL;
 
+	if (unlikely(req->ctx->flags & (IORING_SETUP_IOPOLL|IORING_SETUP_SQPOLL)))
+		return -EINVAL;
 	if (sqe->ioprio || sqe->off || sqe->addr || sqe->len ||
 	    sqe->rw_flags || sqe->buf_index)
 		return -EINVAL;

-- 
Pavel Begunkov
