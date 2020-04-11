Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F15C11A4D72
	for <lists+io-uring@lfdr.de>; Sat, 11 Apr 2020 04:17:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726648AbgDKCRc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 10 Apr 2020 22:17:32 -0400
Received: from mail-pl1-f176.google.com ([209.85.214.176]:34465 "EHLO
        mail-pl1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726657AbgDKCRc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 10 Apr 2020 22:17:32 -0400
Received: by mail-pl1-f176.google.com with SMTP id a23so1253587plm.1
        for <io-uring@vger.kernel.org>; Fri, 10 Apr 2020 19:17:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=nIJzViPl5LCFKrjUDKoYJVeq6tP7ZZRKC21A/+X0Fcc=;
        b=iCuaCs0ijLNiQmdZU+ETUtDsTI6u22cMBqBBdRUudjzaQv4pyWguGIDmqhqArfQyJJ
         uOgzxnrPs2VSEQ2krbmwoutnfzjzh7rfZ/t5sLnGjAI+TpOZ0KR9TOAZgtYPG8Xfmr9X
         cSGeOoauyPhfKkAZIleYopDCaTxcFm9uNsB5H3Bkm1aDWQXekw5fpq0WIShHVVeHL5qo
         efrPYmNU2EqnGD2Q4A0b3Uxby5am+a8izjjzvrK3PpoLtop3VO+TuJls4c0yIEVsjwIN
         S5pFllN/276TDX28ODMA2rZUh6K91FHcMOZL2KdAb5HNrY4OVdl/Ar568IFiuY2pRvZ+
         5TCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nIJzViPl5LCFKrjUDKoYJVeq6tP7ZZRKC21A/+X0Fcc=;
        b=OQamA85GmdTZLxSKQ9bl0uAOp46pmkUysTp/uYgrqTyfVBFovLZidl2/J+c7YhpnKF
         1xX+NPb/IItLyzQfDyb/7rthUNNUWJ0WlR4p+mnhHiglkolswe5MGrpb0rI03RVwu0hd
         TkFjHOJkzlTJ9ydq9IXiMJ0V0LbjMyrzpjy4ED8OBzrtLSute9dEeukUq7A/xwibKS88
         j4IUs4xH8HNJ1154BrpUv9oNdmkaQJY9OWyD9pdfHln/tCp2UCVwXC1JxznDEhmEEmev
         4/JoEkSE/lJuZ6mVWmafSnepKqIDcW8raebSJw/6mOS2+ZDxgISlOmoPUMorup23B6xi
         99FA==
X-Gm-Message-State: AGi0PuaHbZ7Tnt86EYSpvgkz/lZjbzTn7PFcfjs3coddmE04pw2pc6zO
        TvTmNdiXGzZcQybXuihAVuk61w==
X-Google-Smtp-Source: APiQypIkU/0nw98jq1jPDAOJdrildrHeZriWeUSEGYWOIpwNMReeJ3f6ZKTszNjQOJuekNIie5hIRQ==
X-Received: by 2002:a17:902:8213:: with SMTP id x19mr7328859pln.224.1586571451642;
        Fri, 10 Apr 2020 19:17:31 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id np4sm2903351pjb.48.2020.04.10.19.17.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Apr 2020 19:17:30 -0700 (PDT)
Subject: Re: [RFC 1/1] io_uring: preserve work->mm since actual work
 processing may need it
To:     Bijan Mottahedeh <bijan.mottahedeh@oracle.com>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring@vger.kernel.org, Minchan Kim <minchan@kernel.org>
References: <1586469817-59280-1-git-send-email-bijan.mottahedeh@oracle.com>
 <1586469817-59280-2-git-send-email-bijan.mottahedeh@oracle.com>
 <f38056cf-b240-7494-d23b-c663867451cf@gmail.com>
 <465d7f4f-e0a4-9518-7b0c-fe908e317720@oracle.com>
 <dbcf7351-aba2-a64e-ecd9-26666b30469f@gmail.com>
 <e8ca3475-5372-3f99-ff95-c383d3599552@oracle.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <46e5b8bf-0f14-caff-f706-91794191e730@kernel.dk>
Date:   Fri, 10 Apr 2020 20:17:29 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <e8ca3475-5372-3f99-ff95-c383d3599552@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/10/20 12:09 PM, Bijan Mottahedeh wrote:
> On 4/10/2020 10:51 AM, Pavel Begunkov wrote:
>> On 10/04/2020 19:54, Bijan Mottahedeh wrote:
>>>> As I see, this down_read() from the trace is
>>>> down_read(&current->mm->mmap_sem), where current->mm is set by use_mm()
>>>> just several lines above your change. So, what do you mean by passing? I
>>>> don't see do_madvise() __explicitly__ accepting mm as an argument.
>>> I think the sequence is:
>>>
>>> io_madvise()
>>> -> do_madvise(NULL, req->work.mm, ma->addr, ma->len, ma->advice)
>>>                      ^^^^^^^^^^^^
>>>     -> down_read(&mm->mmap_sem)
>>>
>>> I added an assert in do_madvise() for a NULL mm value and hit it running the test.
>>>
>>>> What tree do you use? Extra patches on top?
>>> I'm using next-20200409 with no patches.
>> I see, it came from 676a179 ("mm: pass task and mm to do_madvise"), which isn't
>> in Jen's tree.
>>
>> I don't think your patch will do, because it changes mm refcounting with extra
>> mmdrop() in io_req_work_drop_env(). That's assuming it worked well before.
>>
>> Better fix then is to make it ```do_madvise(NULL, current->mm, ...)```
>> as it actually was at some point in the mentioned patch (v5).
>>
> Ok. Jens had suggested to use req->work.mm in the patch comments so 
> let's just get him to confirm:
> 
> "I think we want to use req->work.mm here - it'll be the same as
> current->mm at this point, but it makes it clear that we're using a
> grabbed mm."

We should just use current->mm, as that matches at that point anyway
since IORING_OP_MADVISE had needs_mm set.

Minchan, can you please make that change?

-- 
Jens Axboe

