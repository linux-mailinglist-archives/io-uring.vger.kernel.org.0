Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64C07590118
	for <lists+io-uring@lfdr.de>; Thu, 11 Aug 2022 17:52:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236695AbiHKPtq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 11 Aug 2022 11:49:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236651AbiHKPrp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 11 Aug 2022 11:47:45 -0400
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D986799257
        for <io-uring@vger.kernel.org>; Thu, 11 Aug 2022 08:41:40 -0700 (PDT)
Received: by mail-il1-x134.google.com with SMTP id d4so10143954ilc.8
        for <io-uring@vger.kernel.org>; Thu, 11 Aug 2022 08:41:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=RTT7+zmODbaYBRXOi2mBaSvbEGfH2m4oaESkivpOFK0=;
        b=k4VcTzmJAF0QbnrcgMbHraqcamIW+G6IhTmAT4XOjdaUJIJRgqyVjAyj9cq+L0hqCv
         4F/elIW0d0B+OsQEXI85JASEvOCoBJKvTdGPbHxZmOBHByHf9JOR1CVslBxhDbuqgRt9
         0y7gJKaqCxd3KDak8WX894EN1nL8QtOk8leVMOuHtYvhiRCacGLraP6YGaxn8w2oCDZo
         TGey/4rZzROzLPy5Mna3e5Rn2+Yw20KGzZPNSmMX6Wc7rFsvtrIxj4W8/RY4GcPuvBAw
         w51+C/sKcLFo9QQo/dHE5nDPPj1b7vK/y0jZ0SK7Q4cWad/sHTHGPpTIb5g/+ykhCFJ7
         VhyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=RTT7+zmODbaYBRXOi2mBaSvbEGfH2m4oaESkivpOFK0=;
        b=nnSl1A7APb/JCJh8qDovykZCE0FozMOUKTKqL397Eb8gIiZcMFJwei15BFfStxUQ5N
         93TSSNZNYOAEAx9qrbE2GIXv4xmVsAGqf5sX1yhA7P4PPGWEtADIqjEUYIweQSNEz5g3
         i5MJpryvoIFQ9IXjXnNYfU2u1YPZP1bAUhkAcRDzrJRA9GAkW9nQ7LoJQHEivH3zYCCF
         2XeDKupheW0lD5+GY6uQuhQ+2Ul0X26LGJdP3haWHnehq895phGi/g2p7EhafsnWDfol
         ggarBUz9PwEj8oFlOOAdEhxXPS+g7qhI6/Xoy3cEL/gqoyNToNk4sKD9QHonavNK/QJW
         FLIQ==
X-Gm-Message-State: ACgBeo16vvjPSxRmpecMnR9shT/FMuyyG9PNar5fD/bjVLkCvMA08t2G
        OrTHCvSZK8832Kx/QgBnWqBP0nyAkVttTg==
X-Google-Smtp-Source: AA6agR4FZsdtqkq3Ho6PTNYBe3yE06cxzSBqfyXK1oz0gKpICAgWMmTtexNviq+rdefhaAChwkzqig==
X-Received: by 2002:a05:6e02:180a:b0:2de:533a:dcb6 with SMTP id a10-20020a056e02180a00b002de533adcb6mr15284519ilv.277.1660232500162;
        Thu, 11 Aug 2022 08:41:40 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id l16-20020a92d950000000b002df5a4c59f5sm3420813ilq.7.2022.08.11.08.41.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Aug 2022 08:41:39 -0700 (PDT)
Message-ID: <8f3d1bf5-48f6-411d-674e-1568e3841d75@kernel.dk>
Date:   Thu, 11 Aug 2022 09:41:38 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH] Modify the return value ret to EOPNOTSUPP when
 initialized to reduce repeated assignment of errno
Content-Language: en-US
To:     Stefano Garzarella <sgarzare@redhat.com>,
        Zhang chunchao <chunchao@nfschina.com>
Cc:     asml.silence@gmail.com, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel@nfschina.com
References: <20220811075638.36450-1-chunchao@nfschina.com>
 <20220811150242.giygjmy4vimxtrzg@sgarzare-redhat>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220811150242.giygjmy4vimxtrzg@sgarzare-redhat>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/11/22 9:02 AM, Stefano Garzarella wrote:
> On Thu, Aug 11, 2022 at 03:56:38PM +0800, Zhang chunchao wrote:
>> Remove unnecessary initialization assignments.
>>
>> Signed-off-by: Zhang chunchao <chunchao@nfschina.com>
>> ---
>> io_uring/io_uring.c | 3 +--
>> 1 file changed, 1 insertion(+), 2 deletions(-)
>>
>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>> index b54218da075c..8c267af06401 100644
>> --- a/io_uring/io_uring.c
>> +++ b/io_uring/io_uring.c
>> @@ -3859,14 +3859,13 @@ SYSCALL_DEFINE4(io_uring_register, unsigned int, fd, unsigned int, opcode,
>>         void __user *, arg, unsigned int, nr_args)
>> {
>>     struct io_ring_ctx *ctx;
>> -    long ret = -EBADF;
>> +    long ret = -EOPNOTSUPP;
>>     struct fd f;
>>
>>     f = fdget(fd);
>>     if (!f.file)
>>         return -EBADF;
>>
>> -    ret = -EOPNOTSUPP;
>>     if (!io_is_uring_fops(f.file))
>>         goto out_fput;
>>
> 
> What about remove the initialization and assign it in the if branch?
> I find it a bit easier to read.
> 
> I mean something like this:
> 
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -3859,16 +3859,17 @@ SYSCALL_DEFINE4(io_uring_register, unsigned int, fd, unsigned int, opcode,
>                 void __user *, arg, unsigned int, nr_args)
>  {
>         struct io_ring_ctx *ctx;
> -       long ret = -EBADF;
> +       long ret;
>         struct fd f;
> 
>         f = fdget(fd);
>         if (!f.file)
>                 return -EBADF;
> 
> -       ret = -EOPNOTSUPP;
> -       if (!io_is_uring_fops(f.file))
> +       if (!io_is_uring_fops(f.file)) {
> +               ret = -EOPNOTSUPP;
>                 goto out_fput;
> +       }
> 
>         ctx = f.file->private_data;
> 
> 
> Otherwise remove the initialization, but leave the assignment as it is now.

Generally the kernel likes to do:

err = -EFOO;
if (something)
	goto err_out;

rather than put it inside the if clause. I guess the rationale is it
makes it harder to forget to init the error value. I don't feel too
strongly, I'm fine with your patch too. Can you send it as a real patch?

-- 
Jens Axboe

