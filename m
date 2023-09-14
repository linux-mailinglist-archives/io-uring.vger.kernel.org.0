Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDB4F7A04DF
	for <lists+io-uring@lfdr.de>; Thu, 14 Sep 2023 15:04:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238603AbjINNEa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 14 Sep 2023 09:04:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238534AbjINNE3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 14 Sep 2023 09:04:29 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 214761FD0
        for <io-uring@vger.kernel.org>; Thu, 14 Sep 2023 06:04:25 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id a640c23a62f3a-9ad810be221so127811666b.2
        for <io-uring@vger.kernel.org>; Thu, 14 Sep 2023 06:04:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694696663; x=1695301463; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Is6g3VCm3z9HeOsEgMKUYA90NVNLmD0nu8SMsA0vlX4=;
        b=mf+9K/GzwPIMxDHr8kzauGQaMCXYw4GFeHTft0IsDiK2Ghb/mPM+57RfLAEL1IGi4m
         G6FDMQ+00P/J8QiLbirTWh50AgHRw6A/z0DaNsnxkbWcr6COv9kydUGCoRP3JVbnVtkf
         QWp+puwy10fPHBmHmAIER5LJGB+OJremJWfDo5s1BIj1CTywP8NfOoV7Sbgw1mqiwrGu
         qKUXNnhsCm+RZ5p81qFg/ehIt3t1zuY+8EKKJ77g/Frq5wF1xjkazemJHXfrj1cwA6D+
         fZH8uxsIdW4rONELUYG3vbuhvUsRjEqP24fwzBqakXz7TKL+tegBDEefL3st2nxsXR++
         inUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694696663; x=1695301463;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Is6g3VCm3z9HeOsEgMKUYA90NVNLmD0nu8SMsA0vlX4=;
        b=gzn+DN1cYuXiRBkdrts0KZ4EfUj2HKINGF7uJ0+B/MOZVgWeXMnruj23xhqcpz9Xk5
         Q/ojfVPQqDiCqvVnrJRl3mD3lieEMejcscH3PkdkwVn8HnenFaPPI31bc6yDXVpcqXJb
         Tx1wsH1Wj+kJAK4Ns8DVmvJsc91nO4zfoEdRkvdAXKEm67iPKCodja/+ZuBOIUJ52jR3
         bGkeml7G+SIGrOVHUYp24MUUzoh9qu0b2NE9DtWjae4sHdUm8F3h/ls12owpcDHzJLEK
         8jTHjWN+xRee14RZxB97urVNNqIAnqJhczjQpjMVjNVIuajqwmufu3oyuIbuiXnr2H90
         B5iQ==
X-Gm-Message-State: AOJu0Yz0kaki1NEhceBGslh05r1t0oqvMVKbLVpE7A+7zK+19rSsSed5
        pr5N+S3FhEGsYhjZn/+vcZU=
X-Google-Smtp-Source: AGHT+IFWlht1cX/2IGXKzum+hBZpASW5bnGRJyKACIc0A4tV/P3PUIdya6POjHCSoqBJwIP0VGrn5A==
X-Received: by 2002:a17:906:197:b0:9a2:2635:dab6 with SMTP id 23-20020a170906019700b009a22635dab6mr5284548ejb.47.1694696663206;
        Thu, 14 Sep 2023 06:04:23 -0700 (PDT)
Received: from [192.168.8.100] ([148.252.128.120])
        by smtp.gmail.com with ESMTPSA id x8-20020a1709065ac800b0099bccb03eadsm969406ejs.205.2023.09.14.06.04.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Sep 2023 06:04:22 -0700 (PDT)
Message-ID: <a7d1a399-8f4a-19de-a20e-5ce76a55a781@gmail.com>
Date:   Thu, 14 Sep 2023 14:02:26 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/7] io_uring/net: don't overflow multishot recv
To:     Jiri Slaby <jirislaby@kernel.org>, io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
References: <cover.1691757663.git.asml.silence@gmail.com>
 <0b295634e8f1b71aa764c984608c22d85f88f75c.1691757663.git.asml.silence@gmail.com>
 <037c9d5c-5910-49e0-af3b-70a48c36b0ca@kernel.org>
Content-Language: en-US
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <037c9d5c-5910-49e0-af3b-70a48c36b0ca@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/14/23 09:34, Jiri Slaby wrote:
> On 11. 08. 23, 14:53, Pavel Begunkov wrote:
>> Don't allow overflowing multishot recv CQEs, it might get out of
>> hand, hurt performanece, and in the worst case scenario OOM the task.
>>
>> Cc: stable@vger.kernel.org
>> Fixes: b3fdea6ecb55c ("io_uring: multishot recv")
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> ---
>>   io_uring/net.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/io_uring/net.c b/io_uring/net.c
>> index 1599493544a5..8c419c01a5db 100644
>> --- a/io_uring/net.c
>> +++ b/io_uring/net.c
>> @@ -642,7 +642,7 @@ static inline bool io_recv_finish(struct io_kiocb *req, int *ret,
>>       if (!mshot_finished) {
>>           if (io_aux_cqe(req, issue_flags & IO_URING_F_COMPLETE_DEFER,
>> -                   *ret, cflags | IORING_CQE_F_MORE, true)) {
>> +                   *ret, cflags | IORING_CQE_F_MORE, false)) {
> 
> This one breaks iouring's recv-multishot.t test:
> Running test recv-multishot.t                                       MORE flag not set
> test stream=0 wait_each=0 recvmsg=0 early_error=4  defer=0 failed
> Test recv-multishot.t failed with ret 1
> 
> Is the commit or the test broken ;)?

The test is not right. I fixed it up while sending the kernel patch,
but a new liburing version hasn't been cut yet and I assume you're
not using upstream version?

> 
>>               io_recv_prep_retry(req);
>>               /* Known not-empty or unknown state, retry */
>>               if (cflags & IORING_CQE_F_SOCK_NONEMPTY ||
> 
> thanks,

-- 
Pavel Begunkov
