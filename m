Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F72E430596
	for <lists+io-uring@lfdr.de>; Sun, 17 Oct 2021 01:17:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235661AbhJPXTs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 16 Oct 2021 19:19:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235619AbhJPXTr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 16 Oct 2021 19:19:47 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6BFDC061765
        for <io-uring@vger.kernel.org>; Sat, 16 Oct 2021 16:17:38 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id g10so54034429edj.1
        for <io-uring@vger.kernel.org>; Sat, 16 Oct 2021 16:17:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=lO+JeZon3Yw+W2Ls04bPNSrFa5gQ48lttN3f2ez8GWI=;
        b=htF81CK/PiiFz10aajG5iWaEV5VK6wNyfinH08CTh6LuEZbAjdT/gbJ7ktXHwF3oxm
         lnYwB12eS99gBA3RqR/s+KdVVlpKVMKcSDLKaJ50HcLwONi0XKzS95S1f88VF0QuR0ee
         YNATFS2vB2cuPd+5Z/hjJpph72lQAY4pwT2WvzrMNeTg0Cy3hkX5xLknm5lLjmC8IYNB
         DHdWeSy3r2OOXf8bTs1cG/YELM40tNyhLQyiSbkure7otd2kY4H1d/bYtDf9ep5e/TCz
         rkQwdDZvBS/uDN3OniafeQgHpAG77OpkIz3UTTzzJoa7qjSHSj2HayfmmnprZYmlFMSb
         UnrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=lO+JeZon3Yw+W2Ls04bPNSrFa5gQ48lttN3f2ez8GWI=;
        b=aLyieVs+rh62U+cbT71S072IxUY2QV2xznSFfTcYxRVMIRehoS/M0AegkIkPYzS2xz
         A9rLElR+3J9d2IEiGSh1OuKf2hvIEz3fyc8ZAKLXEmZd+c955Ir6/tkIXgagp5n5jc3r
         6rC86B8Us/IUUxGO1e9t4PAkj/DvcwkTYwXXr/EScRrHXMuPn7E37VoL/oI/EMxH/lr9
         w9Kl9v+esW5g7oY146pdjnLuVtTMISF5IODwvFoD2RPDm2e/lVI+KJX6HuKsdIpXoXUv
         oz40k8/wG1w5ZWvUJ6jHRkAxQr2B/FgHlZv/2xJ7/LqEryAu89CIhVEjkJPjlrcubq2L
         h5Mg==
X-Gm-Message-State: AOAM530XKuB/nFjtb2g2KKkA+WKS/YG7SwW6kh/tdmv+gmg3gBV7NEUh
        IZ4K2+8cdALZLyryYOJJsZs=
X-Google-Smtp-Source: ABdhPJwlNRK0TK7R+oXK0FXvDBdAopvnWwXjHNJAs5jE7zacq57XH4vhVtZE/IX173EGX2jRngROYg==
X-Received: by 2002:a17:906:7c86:: with SMTP id w6mr17962183ejo.283.1634426257275;
        Sat, 16 Oct 2021 16:17:37 -0700 (PDT)
Received: from [192.168.8.197] ([185.69.145.201])
        by smtp.gmail.com with ESMTPSA id d22sm7078312ejj.47.2021.10.16.16.17.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 Oct 2021 16:17:36 -0700 (PDT)
Message-ID: <dcc08d20-fd0c-e4d2-6500-2139aca4903e@gmail.com>
Date:   Sun, 17 Oct 2021 00:16:57 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.2
Subject: Re: [PATCH 7/8] io_uring: arm poll for non-nowait files
Content-Language: en-US
To:     Noah Goldstein <goldstein.w.n@gmail.com>
Cc:     "open list:IO_URING" <io-uring@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
References: <cover.1634314022.git.asml.silence@gmail.com>
 <6e72153f8de78d836b9b7595a2a6f1c6a9f137b1.1634314022.git.asml.silence@gmail.com>
 <CAFUsyfLH46EOJHvGJRToE0GApdjdX4UhO7DgnV9S4di4O1CCMQ@mail.gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CAFUsyfLH46EOJHvGJRToE0GApdjdX4UhO7DgnV9S4di4O1CCMQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/16/21 23:57, Noah Goldstein wrote:
> On Sat, Oct 16, 2021 at 5:19 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>> @@ -3238,7 +3220,8 @@ static ssize_t loop_rw_iter(int rw, struct io_kiocb *req, struct iov_iter *iter)
>>           */
>>          if (kiocb->ki_flags & IOCB_HIPRI)
>>                  return -EOPNOTSUPP;
>> -       if (kiocb->ki_flags & IOCB_NOWAIT)
>> +       if ((kiocb->ki_flags & IOCB_NOWAIT) &&
>> +           !(kiocb->ki_filp->f_flags & O_NONBLOCK))
>>                  return -EAGAIN;
> 
> Instead of 2x branches on what appears to be the error (not hot path)

The whole loop_rw_iter() is a slow path, we don't care enough

-- 
Pavel Begunkov
