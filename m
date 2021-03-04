Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8D5532DB79
	for <lists+io-uring@lfdr.de>; Thu,  4 Mar 2021 21:56:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229599AbhCDUzT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 Mar 2021 15:55:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235186AbhCDUzG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 Mar 2021 15:55:06 -0500
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 244D1C061574
        for <io-uring@vger.kernel.org>; Thu,  4 Mar 2021 12:54:26 -0800 (PST)
Received: by mail-io1-xd2b.google.com with SMTP id u20so31297151iot.9
        for <io-uring@vger.kernel.org>; Thu, 04 Mar 2021 12:54:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=BTPIn/2M132pcwCADWrWKuy50i2lB1IDkAXuXSHAgVE=;
        b=erie58ilZke1tFf3zXFC1t+K5ek+YBmZAtImhqz1qZtSCjO7Wbtng67P3QFxns4odF
         B5L8OcU9djYJZnb0cmwbg/qfh9fWzR3DPLpaH02ljUAkW3rNGB4qk2izIAFaWAkTBR+Y
         Dmibi1hEQnx5cgZ3SoqGT5tvzQxhA0or8UZ+4w49sj5lRGuJu7eNCmNqujeScXDKxVsy
         XRw4+jZhuJRinJ5QEdNroMskYG2/TiG/ZBt28lBub/SoRmsSSPmYl0pCJFB07slrXyUu
         IW6039kXWeS80boPLywVeg8U6WZaC9sUfjuMoETMru8CKyNh9cxJBS420nSKVyjTgzgi
         NF1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BTPIn/2M132pcwCADWrWKuy50i2lB1IDkAXuXSHAgVE=;
        b=LPR+vqc1Ww5+0YOhAxrNBjlCT2OgQTVCE7hn3QIRmtr2vBAKW1I70lnzlPWi2BqutW
         QcJVdaUHbdbqjm2rkNbuP3erietcY8bwiKMaT6fSXM5NTtZn1DWbTg6PW8dGEecn/E7P
         9edmdbtCNQCE/Yv7HfIr45LMk/VPK1N5L6bQABhmJ6CGpNVgiSd9JBAWonoqWu581pJu
         L1FIMq6KzD3Vu04jbgEkNe9YvXQGkWqdiV6HvwarcIB5kM7grprx3rLHl8aS9AS5rvrl
         gYNqpNIzCBMkpKM+PW67EQW2XxYRw7bBhtEhUtkp7S1JH4FKh0w9ZznNZbQg9nejqjdG
         T3SA==
X-Gm-Message-State: AOAM532DPnj8Z4ICkv+yclS/Y2Wj3ZpZNnVL4TAyZDn2rn0SZvWvIyw1
        VbWoRD4nUQHdP+X8dd2g4eJzdA==
X-Google-Smtp-Source: ABdhPJwvORo1G037t/8qtEYPjkz9+T/fFq8XJF74wCOynrn+uB5d41sc9fRWoFk2IZW604gggho0OQ==
X-Received: by 2002:a02:910d:: with SMTP id a13mr6055103jag.18.1614891265579;
        Thu, 04 Mar 2021 12:54:25 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id o19sm206979ioh.47.2021.03.04.12.54.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Mar 2021 12:54:25 -0800 (PST)
Subject: Re: [PATCH 09/18] io-wq: fork worker threads from original task
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Stefan Metzmacher <metze@samba.org>,
        io-uring <io-uring@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Al Viro <viro@zeniv.linux.org.uk>
References: <20210219171010.281878-1-axboe@kernel.dk>
 <20210219171010.281878-10-axboe@kernel.dk>
 <85bc236d-94af-6878-928b-c69dbdcd46f9@samba.org>
 <d9704b9e-ae5e-0795-ba2e-029293f89616@kernel.dk>
 <a9f58269-b260-6281-4e83-43cb5e881d25@samba.org>
 <d3dfc422-8762-0078-bc80-989f1d71f006@samba.org>
 <32f1218b-49c3-eeb6-5866-3ec45acbc1c5@kernel.dk>
 <34857989-ff46-b2a7-9730-476636848acc@samba.org>
 <47c76a83-a449-3a65-5850-1d3dff4f3249@kernel.dk>
 <09579257-8d8e-8f25-6ceb-eea4f5596eb3@kernel.dk>
 <CAHk-=wgqJdq6GjydKoAb41K9QX5Q8XMLA2dPaM3a3xqQQa_ygg@mail.gmail.com>
 <f42dcb4e-5044-33ed-9563-c91b9f8b7e64@kernel.dk>
 <CAHk-=wj8BnbsSKWx=kUFPqpoohDdPchsW00c4L-x6ES8bOWLSg@mail.gmail.com>
 <bcab873a-eced-b906-217f-c52a113a95a9@kernel.dk>
 <CAHk-=wiDYfkuH1cAk_oZDZ8ZzZP1zuaXcQv34P5z_JJi038fZQ@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <397f1046-ee2b-d27e-2063-79567f7cfb98@kernel.dk>
Date:   Thu, 4 Mar 2021 13:54:24 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAHk-=wiDYfkuH1cAk_oZDZ8ZzZP1zuaXcQv34P5z_JJi038fZQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/4/21 1:50 PM, Linus Torvalds wrote:
> On Thu, Mar 4, 2021 at 11:54 AM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> I agree, here are the two current patches. Just need to add the signal
>> blocking, which I'd love to do in create_io_thread(), but seems to
>> require either an allocation or provide a helper to do it in the thread
>> itself (with an on-stack mask).
> 
> Hmm. Why do you set SIGCHLD in create_io_thread()? Do you actually use
> it? Shouldn't IO thread exit be a silent thing?

Good catch, I will drop that.

> And why do you have those task_thread_bound() and
> task_thread_unbound() functions? As far as I can tell, you have those
> two functions just to set the process worker flags.

Already dropped that, it's not in the current set.

> Why don't you just do that now inside create_io_worker(), and the
> whole task_thread_[un]bound() thing goes away, and you just always
> start the IO thread in task_thread() itself?

That's exactly what I did:

https://git.kernel.dk/cgit/linux-block/commit/?h=io_uring-5.12&id=dda3b920327093a2bb8c2e5db26db9203d7f60e6

-- 
Jens Axboe

