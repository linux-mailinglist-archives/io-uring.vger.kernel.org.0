Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC84A3168A9
	for <lists+io-uring@lfdr.de>; Wed, 10 Feb 2021 15:05:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230184AbhBJOF2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 10 Feb 2021 09:05:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229465AbhBJOFZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 10 Feb 2021 09:05:25 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 737ADC061756
        for <io-uring@vger.kernel.org>; Wed, 10 Feb 2021 06:04:44 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id o24so1934191wmh.5
        for <io-uring@vger.kernel.org>; Wed, 10 Feb 2021 06:04:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:references:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LI98HBATDD9tQu7cNPl8tSULT7KPrtqHTNHlPgiu0Jk=;
        b=sOOw38OwztXxZhBnj6GGfr/8npU/dic5qW0cJWazXweBMHKy53vNQpbyiXzY/u1AQx
         M5AnZHnpJ/cGGyPVRW74xlHixnfssr7Yk319zqkqsZYWIXzUd0PHV40yqxa3GBmr1HkK
         6Mp+FNoQuwzgGVIuX9B6uQ2GQn6pXjfxIar5T5uNXIzN3FYlo/y0NWhg/pI2541Lbsov
         XscMSKRvwQnd4mCv5V01r1htX8/TwjSi2RPiPl7C9MO1WPOVNtwXC4pN5HfCzQQUILqi
         +0t1xffxZomsbn7xcBdTkZc3amEOqUK4JHEJL9J347PC5QCSioqTQyvIMUlK1AA3e7o+
         Zg5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LI98HBATDD9tQu7cNPl8tSULT7KPrtqHTNHlPgiu0Jk=;
        b=DMcht4ysnDN4CZg5tpx72dtXBIBoZ74XrgyOEeIv0Mag/zKUDXvTsNIJmb2UjJXg1s
         fEDB+1SfoS1qz0bh9aNhObA/TEndv8MBq307dTm+wy9wQ1JfqqG2rYXGRAb7xWbcYqWy
         Jo+T2pHiQCt7axxV3nJWgI9xTKCXCql2fecd+iVJ3pJqVzTG65NyKPdJIW2ye3VCf0A9
         ZdI++MTjObGgS9LdY8uyAYad87umEfqxzoleNJ0+hyA30M+1RriJ7kJdKkn2iUVi6Auo
         UJvoQvBWgwxcCCyyJT1Xl046NbwXdawEIbsOj4QV22NSSBlidhclBco7gWK7ZozCoyOI
         8Gkw==
X-Gm-Message-State: AOAM5329evNTeYow8CuoNxkrmZptckpUayFPSuSuJCw39uQ/94XPbBbo
        wm/RR3qtWP4ydm4KHHm5Z/I8KHCBwNBV9w==
X-Google-Smtp-Source: ABdhPJztoS3pywMPcQNg3t5WhC82dIdz2VV1ALvx4NTACxkNHaYP4A4eIzY5FCDOY2yl/9lZfrcylQ==
X-Received: by 2002:a1c:2c05:: with SMTP id s5mr374240wms.70.1612965882943;
        Wed, 10 Feb 2021 06:04:42 -0800 (PST)
Received: from [192.168.8.194] ([148.252.132.126])
        by smtp.gmail.com with ESMTPSA id h14sm2330628wmq.39.2021.02.10.06.04.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Feb 2021 06:04:42 -0800 (PST)
Subject: Re: [PATCH 03/17] io_uring: don't propagate io_comp_state
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1612915326.git.asml.silence@gmail.com>
 <275f9bbb7d9a74b1912a51acb1f90c1f1a47594e.1612915326.git.asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <240e3851-0f37-72c4-7b32-2cfa567cab79@gmail.com>
Date:   Wed, 10 Feb 2021 14:00:56 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <275f9bbb7d9a74b1912a51acb1f90c1f1a47594e.1612915326.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/02/2021 00:03, Pavel Begunkov wrote:
> There is no reason to drag io_comp_state into opcode handlers, we just
> need a flag and the actual work will be done in __io_queue_sqe().
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>

Jens, can you fold it in? Doesn't build currently for !CONFIG_NET


diff --git a/fs/io_uring.c b/fs/io_uring.c
index e5f9f04e2e2d..8fb1c845fa5b 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5145,14 +5145,12 @@ static int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	return -EOPNOTSUPP;
 }
 
-static int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags,
-		      struct io_comp_state *cs)
+static int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
 {
 	return -EOPNOTSUPP;
 }
 
-static int io_send(struct io_kiocb *req, unsigned int issue_flags,
-		   struct io_comp_state *cs)
+static int io_send(struct io_kiocb *req, unsigned int issue_flags)
 {
 	return -EOPNOTSUPP;
 }
@@ -5163,14 +5161,12 @@ static int io_recvmsg_prep(struct io_kiocb *req,
 	return -EOPNOTSUPP;
 }
 
-static int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags,
-		      struct io_comp_state *cs)
+static int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 {
 	return -EOPNOTSUPP;
 }
 
-static int io_recv(struct io_kiocb *req, unsigned int issue_flags,
-		   struct io_comp_state *cs)
+static int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 {
 	return -EOPNOTSUPP;
 }
@@ -5180,8 +5176,7 @@ static int io_accept_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	return -EOPNOTSUPP;
 }
 
-static int io_accept(struct io_kiocb *req, unsigned int issue_flags,
-		     struct io_comp_state *cs)
+static int io_accept(struct io_kiocb *req, unsigned int issue_flags)
 {
 	return -EOPNOTSUPP;
 }
@@ -5191,8 +5186,7 @@ static int io_connect_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	return -EOPNOTSUPP;
 }
 
-static int io_connect(struct io_kiocb *req, unsigned int issue_flags,
-		      struct io_comp_state *cs)
+static int io_connect(struct io_kiocb *req, unsigned int issue_flags)
 {
 	return -EOPNOTSUPP;
 }

-- 
Pavel Begunkov
