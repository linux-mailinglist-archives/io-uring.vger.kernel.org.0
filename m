Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE8B11A499A
	for <lists+io-uring@lfdr.de>; Fri, 10 Apr 2020 19:58:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726595AbgDJR6b (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 10 Apr 2020 13:58:31 -0400
Received: from mail-wm1-f51.google.com ([209.85.128.51]:35965 "EHLO
        mail-wm1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726142AbgDJR6b (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 10 Apr 2020 13:58:31 -0400
Received: by mail-wm1-f51.google.com with SMTP id a201so3095787wme.1
        for <io-uring@vger.kernel.org>; Fri, 10 Apr 2020 10:58:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ksGCvb56PVYa/+fsqCJrUwkz7/URen0/Be9VscR4gds=;
        b=izxW0emx5bD+px1DNYnA0RJA+WFNZ2TqtmNyt34ZyVAJpc8JI61L9MMiXU+AAAe/Xl
         7l5PY/3VmoCpJS7C0U+XYf0RoNlERcZsqkoMZff2shBrr0lv9cDgiPP3uh0LHqDFHMrC
         tisFjNpE7M2xK6WDYgP1ixvv7XBUAs563ZXSvQmP5tCOGfthXxiEgRrWGiC0IJdngeCf
         NYGqlHAaFCDGQG0YhcB8g4Xwa2E+ybODya5AV8CzWxpQi5IV+/68en/OqwsI+Y+r71NV
         /pj5kCMj4zGOJaJO1hkOjT84mBl149h8+PB1lOROp00IPnjYE/DvdbUL1LnuRNx3XrMF
         uo2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=ksGCvb56PVYa/+fsqCJrUwkz7/URen0/Be9VscR4gds=;
        b=mFTjUARhXn/Rf/iMG773Cgrsv182T7Cg8snJKkTy8cxXQWvNCk7vwTWPBzD4D2PTTs
         R0f/nUrJt4+Fvf5pCqx4YIYziRFk5i59OqAbLlG5QEkAUicd+j1Nsokqsjhu6SbZIULA
         Jt/uXgBmyabI0LiCk4vw813WNNM88YPYJ5OkDtNjoEEtQs5oBG10qemxEKy7ykUJStZq
         fihIxRgc/95TBnpQ+NKtxijQLYCJh2fg33UBLf/bcoH8OI5a8nlqZwm/uWFR6ItHI5Kq
         PuvzkcHjGWhi7rnas9hxWlfEJTSEmPe4pwu1/6b8QCQjbmLTukGQ4p/SdMpM2uzWDveA
         y2/g==
X-Gm-Message-State: AGi0PuYCCA6VPBpXIAzaUeE4Auo82TzxyQPna6Jei65wbumXTv+1oSqv
        Xo6yDHCT9302y0bopIZ++Id1qPAU
X-Google-Smtp-Source: APiQypL7DFdJ8qHUWq81I+rJ9EZDfceVXtP22TVxg9k2Pwknk8lFi6qA1V4Q9rlTOggK54JOIu22Vw==
X-Received: by 2002:a1c:4e06:: with SMTP id g6mr6066275wmh.186.1586541509620;
        Fri, 10 Apr 2020 10:58:29 -0700 (PDT)
Received: from [192.168.43.32] ([109.126.129.227])
        by smtp.gmail.com with ESMTPSA id a2sm3982273wra.71.2020.04.10.10.58.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Apr 2020 10:58:29 -0700 (PDT)
Subject: Re: [RFC 1/1] io_uring: preserve work->mm since actual work
 processing may need it
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Bijan Mottahedeh <bijan.mottahedeh@oracle.com>, axboe@kernel.dk
Cc:     io-uring@vger.kernel.org
References: <1586469817-59280-1-git-send-email-bijan.mottahedeh@oracle.com>
 <1586469817-59280-2-git-send-email-bijan.mottahedeh@oracle.com>
 <f38056cf-b240-7494-d23b-c663867451cf@gmail.com>
 <465d7f4f-e0a4-9518-7b0c-fe908e317720@oracle.com>
 <dbcf7351-aba2-a64e-ecd9-26666b30469f@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <a36ec903-c740-2bb3-ab97-890757c290ee@gmail.com>
Date:   Fri, 10 Apr 2020 20:57:29 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <dbcf7351-aba2-a64e-ecd9-26666b30469f@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/04/2020 20:51, Pavel Begunkov wrote:
>> I added an assert in do_madvise() for a NULL mm value and hit it running the test.
>>
>>> What tree do you use? Extra patches on top?
>>
>> I'm using next-20200409 with no patches.
> 
> I see, it came from 676a179 ("mm: pass task and mm to do_madvise"), which isn't
> in Jen's tree

oops, sorry for mistyping your name.

> 
> I don't think your patch will do, because it changes mm refcounting with extra
> mmdrop() in io_req_work_drop_env(). That's assuming it worked well before.
> 
> Better fix then is to make it ```do_madvise(NULL, current->mm, ...)```
> as it actually was at some point in the mentioned patch (v5). 

Jens, how this should be handled? Through what tree it has to go?

-- 
Pavel Begunkov
