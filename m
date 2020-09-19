Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CB97270FAE
	for <lists+io-uring@lfdr.de>; Sat, 19 Sep 2020 18:59:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726449AbgISQ7W (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 19 Sep 2020 12:59:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726408AbgISQ7W (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 19 Sep 2020 12:59:22 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F6DFC0613CE
        for <io-uring@vger.kernel.org>; Sat, 19 Sep 2020 09:59:22 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id l15so8761882wmh.1
        for <io-uring@vger.kernel.org>; Sat, 19 Sep 2020 09:59:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:references:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6YCgPDPT5grDgHhSGnpic+Cp6fFiMeIKMMVh2lG5eXA=;
        b=LQgqclM1gPzM8Kpk3WLPUVMnyvDytiQtPBlLbOK3A8OBCQjx5x15dSrLjYHGEZpaYN
         FzPjoIxIKuMuKjislHzDwBgrRCfTlx/xdXcolos2PI7j2UMcPsnVT+akE3jumez+AYt6
         OUsm4pkgt6V4KVx6ME+aSg9Yi1CHuhfftZMb/h15vcbwKCMvWMar+EJCurk/ZV2r7vm3
         IR1MCSI6a4juMajL9ep2MTNo6mhCgxdH4NbOY4KqWs6fIBFPbgWQ1KwmGt55/kfgd3rr
         n8xDR4F8WaslxUjX2y74ROPC3+YCA05FgDWaG6vaW8IhDhvloprRxldgPqIZQd2QIn7u
         cTqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6YCgPDPT5grDgHhSGnpic+Cp6fFiMeIKMMVh2lG5eXA=;
        b=LuKm2S9h/ptrbVTRO8a1TQAkGM1l/06QXptRLuTZmawVJiTduBjibzlmP8zg29lHis
         pigzT5K1L7mszJt1JJbgqc2Q2m+uw7ksW9vOLPgb+T6lXxAmh8ihMeVRgohxxyuLxlnr
         ZtXrqYN0cwmBhHmz1aKuQm0oVzEkv1E6ieA/ThXVm92PvA5G7Z/7d1cJOlvzHHPbK95W
         d0IwZx1PKnQV/p39YV2WA+H8/c17WNyYLinxPfOPYTIIzAobWd4JpHQRW+m+8HQma8Ly
         j0FyJxdmvm0reSMQZVBBLjXQUpor0IbfOExjhPbb0wUhmiUI6syGFDb9NeIytPYB9mkk
         DmiQ==
X-Gm-Message-State: AOAM530eWLm9bc9IcICNeHsjjPP0qWNaqUJYpAlcciYecFb5Lqers6SN
        bHDAJJ/sXXzoNyQklA4aUtDaujjKGnM=
X-Google-Smtp-Source: ABdhPJyBhdr6QQXoK/thSmACpxhfjE1/2B9dp4jYcc1Z3hq7olo01pcmhrSdqrk38SuuqvfieL+ZZw==
X-Received: by 2002:a05:600c:22d1:: with SMTP id 17mr21145606wmg.58.1600534758846;
        Sat, 19 Sep 2020 09:59:18 -0700 (PDT)
Received: from [192.168.43.240] ([5.100.192.109])
        by smtp.gmail.com with ESMTPSA id y68sm3847384wmd.39.2020.09.19.09.59.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 19 Sep 2020 09:59:18 -0700 (PDT)
Subject: Re: [PATCH 1/5] io_uring: grab any needed state during defer prep
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <20200914162555.1502094-1-axboe@kernel.dk>
 <20200914162555.1502094-2-axboe@kernel.dk>
 <77283ddd-77d9-41e1-31d2-2b9734ee2388@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <79e9d619-882b-8915-32df-ced1886e1eb3@gmail.com>
Date:   Sat, 19 Sep 2020 19:56:48 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <77283ddd-77d9-41e1-31d2-2b9734ee2388@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 19/09/2020 18:27, Pavel Begunkov wrote:
> On 14/09/2020 19:25, Jens Axboe wrote:
>> Always grab work environment for deferred links. The assumption that we
>> will be running it always from the task in question is false, as exiting
>> tasks may mean that we're deferring this one to a thread helper. And at
>> that point it's too late to grab the work environment.
> 
> That's a shame. Do you mean that's from lines like below?
> 
> int io_async_buf_func()
> {
>     ...
>     if (!io_req_task_work_add()) {
>         ...
>         tsk = io_wq_get_task(req->ctx->io_wq);
>         task_work_add(tsk, &req->task_work, 0);
>     }
> }
> 
> It looks like failing such requests would be a better option.
> io_uring_flush() would want them killed for PF_EXITING processes anyway.

Forgot that they will be cancelled there. So, how it could happen?
Is that the initial thread will run task_work but loosing
some resources like mm prior to that? e.g. in do_exit()

> 
>>
>> Fixes: debb85f496c9 ("io_uring: factor out grab_env() from defer_prep()")
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>> ---
>>  fs/io_uring.c | 2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index 175fb647d099..be9d628e7854 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -5449,6 +5449,8 @@ static int io_req_defer_prep(struct io_kiocb *req,
>>  	if (unlikely(ret))
>>  		return ret;
>>  
>> +	io_prep_async_work(req);
>> +
>>  	switch (req->opcode) {
>>  	case IORING_OP_NOP:
>>  		break;
>>
> 

-- 
Pavel Begunkov
