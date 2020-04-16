Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5F391AD110
	for <lists+io-uring@lfdr.de>; Thu, 16 Apr 2020 22:30:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726201AbgDPUa0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Apr 2020 16:30:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725991AbgDPUa0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Apr 2020 16:30:26 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CED8AC061A0C
        for <io-uring@vger.kernel.org>; Thu, 16 Apr 2020 13:30:24 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id t40so47587pjb.3
        for <io-uring@vger.kernel.org>; Thu, 16 Apr 2020 13:30:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JGNvycFlgnRfcz+VABV3DtzroaUtpX+m9V+nIyPggCY=;
        b=A9Nak+u0WThtX25Ohdr4J3cpJDosMTMQgMcbPBYwVeaWglpziFUpV+CDlvlE2sI8rB
         cudDGKrW9wX8+3jZ1uLkFr/1NrqLw61R7cqiK4/ARWdT5TeE1yVxVbGJc8yeQTNCA6EM
         qqkojS9X1GTyJZ3ec1W3mMv0xLGdA82xN3HGvqdB0rFPomU2h0BPGnKGAX0Tdvn2+8kp
         AAOO1SCL5Q6bDvMo0wTxaJLMSxoyaJfUpPkT2tM1bgj/KelKwx8KSf6zUyv2KRb4tV4P
         lTzGqJi3D7Xx0hfK6jPso1r6Ysar14Vw4OyjIGGcQ+TzqITD5eVpzl+Fx1T5sGbqaV0V
         ftKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JGNvycFlgnRfcz+VABV3DtzroaUtpX+m9V+nIyPggCY=;
        b=PmZ9a+NeV4n/ICjp6tZtRbV7fbUa7jtZfCHOOVpuUQp2KqvT3/t5l9XJpPflD1rC4B
         RMn1nLI8bAlMeRJrRPTdEEqBsiWze6Zy2A9NE2q4stMWjo0VFfaC29kLJETVbNN3zrS7
         zr1NF7Xz+bFLOd4QGZiVAyZmealgmVFYDHP2uQOtr70tyVi5Xg53eaN2kxpFkEvjLP1u
         W59Nsg5+xd200hdh8sK3jjLpuQY09FgO0m5bhJZP76fR+oSrfbMgJZrHMwaQNHjzwHD9
         IyKV9nIHBckb3ErSrW26chHU3pBBfhvnTawh0RUIYmvovi5JJs/iWNsFzYsqKtZ2vTca
         /48w==
X-Gm-Message-State: AGi0PuYuRmpCpW5EppdP4Mfv7Ke7wZ0oJop8QdmBNrIKDza6LCZGuY3L
        lfILGBp9qcUizvY8STVnPdzmniOvJjvbgA==
X-Google-Smtp-Source: APiQypLczrA3D6cvmI0CxnrUVTQp5Br4f8nqSeSyKFarhmQ1mKkKR418sU9pIBpekC045bvOtRQ/QQ==
X-Received: by 2002:a17:902:ac8d:: with SMTP id h13mr11622403plr.267.1587069023786;
        Thu, 16 Apr 2020 13:30:23 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id e16sm4563380pgg.1.2020.04.16.13.30.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Apr 2020 13:30:23 -0700 (PDT)
Subject: Re: [RFC 1/1] io_uring: preserve work->mm since actual work
 processing may need it
To:     Minchan Kim <minchan@kernel.org>
Cc:     Bijan Mottahedeh <bijan.mottahedeh@oracle.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org
References: <1586469817-59280-1-git-send-email-bijan.mottahedeh@oracle.com>
 <1586469817-59280-2-git-send-email-bijan.mottahedeh@oracle.com>
 <f38056cf-b240-7494-d23b-c663867451cf@gmail.com>
 <465d7f4f-e0a4-9518-7b0c-fe908e317720@oracle.com>
 <dbcf7351-aba2-a64e-ecd9-26666b30469f@gmail.com>
 <e8ca3475-5372-3f99-ff95-c383d3599552@oracle.com>
 <46e5b8bf-0f14-caff-f706-91794191e730@kernel.dk>
 <20200416202428.GA50092@google.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <f6453f94-1c90-b1b2-d886-fa5a70c4d6ef@kernel.dk>
Date:   Thu, 16 Apr 2020 14:30:21 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200416202428.GA50092@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/16/20 2:24 PM, Minchan Kim wrote:
> Hi Jens,
> 
> Sorry for the late.
> 
> On Fri, Apr 10, 2020 at 08:17:29PM -0600, Jens Axboe wrote:
>> On 4/10/20 12:09 PM, Bijan Mottahedeh wrote:
>>> On 4/10/2020 10:51 AM, Pavel Begunkov wrote:
>>>> On 10/04/2020 19:54, Bijan Mottahedeh wrote:
>>>>>> As I see, this down_read() from the trace is
>>>>>> down_read(&current->mm->mmap_sem), where current->mm is set by use_mm()
>>>>>> just several lines above your change. So, what do you mean by passing? I
>>>>>> don't see do_madvise() __explicitly__ accepting mm as an argument.
>>>>> I think the sequence is:
>>>>>
>>>>> io_madvise()
>>>>> -> do_madvise(NULL, req->work.mm, ma->addr, ma->len, ma->advice)
>>>>>                      ^^^^^^^^^^^^
>>>>>     -> down_read(&mm->mmap_sem)
>>>>>
>>>>> I added an assert in do_madvise() for a NULL mm value and hit it running the test.
>>>>>
>>>>>> What tree do you use? Extra patches on top?
>>>>> I'm using next-20200409 with no patches.
>>>> I see, it came from 676a179 ("mm: pass task and mm to do_madvise"), which isn't
>>>> in Jen's tree.
>>>>
>>>> I don't think your patch will do, because it changes mm refcounting with extra
>>>> mmdrop() in io_req_work_drop_env(). That's assuming it worked well before.
>>>>
>>>> Better fix then is to make it ```do_madvise(NULL, current->mm, ...)```
>>>> as it actually was at some point in the mentioned patch (v5).
>>>>
>>> Ok. Jens had suggested to use req->work.mm in the patch comments so 
>>> let's just get him to confirm:
>>>
>>> "I think we want to use req->work.mm here - it'll be the same as
>>> current->mm at this point, but it makes it clear that we're using a
>>> grabbed mm."
>>
>> We should just use current->mm, as that matches at that point anyway
>> since IORING_OP_MADVISE had needs_mm set.
>>
>> Minchan, can you please make that change?
> 
> Do you mean this?
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index a9537cd77aeb..3edbb4764993 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -3280,7 +3280,7 @@ static int io_madvise(struct io_kiocb *req, bool force_nonblock)
>         if (force_nonblock)
>                 return -EAGAIN;
> 
> -       ret = do_madvise(NULL, req->work.mm, ma->addr, ma->len, ma->advice);
> +       ret = do_madvise(NULL, current->mm, ma->addr, ma->len, ma->advice);
>         if (ret < 0)
>                 req_set_fail_links(req);
>         io_cqring_add_event(req, ret);
> 
> Since I have a plan to resend whole patchset again, I will carry on
> that.

Yeah exactly like that, thanks!

-- 
Jens Axboe

