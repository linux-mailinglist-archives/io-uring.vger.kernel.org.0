Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72833393275
	for <lists+io-uring@lfdr.de>; Thu, 27 May 2021 17:30:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235894AbhE0Pbu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 27 May 2021 11:31:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234705AbhE0Pbt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 27 May 2021 11:31:49 -0400
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C8AEC061574
        for <io-uring@vger.kernel.org>; Thu, 27 May 2021 08:30:16 -0700 (PDT)
Received: by mail-oi1-x231.google.com with SMTP id w127so1107395oig.12
        for <io-uring@vger.kernel.org>; Thu, 27 May 2021 08:30:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=8Op4gnoaksdh+U4uxBaqZw6x+/2lPI5nN0JuZIQFbB8=;
        b=ftbzGVXVapQHfjABpJplpIhe9rGYm/CFIzFI1r7uc4HRf8hXK5qre6sTQzNf8MHREw
         HNJHRp8vmCtTbn3s6cKFePNAhTQD3r7wtXcFMj6UWu8rlKfOWHE1VSMmGZlmdtse5mci
         7Sv7XhR7mtmgLMoim9CJH413G41rwl39cGJeYZYNPLDliRv18tUc3FhTq81zjJevzZ4H
         SK2TXYIVxyDLpZX2VZxqyeENnH7dr3HqejjFhlDTPbJZ4MRy6ZidlxgDaPMD0IuAiDAn
         Lnj4FAubI8vbgAhBh2+K9bAuebv8X+wCZTGipWVUYM2hwAtNx+PnLRVCRWmV8cjDFEPw
         gk7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8Op4gnoaksdh+U4uxBaqZw6x+/2lPI5nN0JuZIQFbB8=;
        b=P3UdvMmIok6R/JHLC1cpIDJ+amrB63BJl6i5J4h2VjLjonSF5FYHfqI0yGvz1gIvia
         5zdEQU0ftWWDkuQrRyL8J+zZ7HQJTxU5sa9ZDHZymACZLp5xC2UXohGKPE8s3GlZ9hLW
         Gd/Txr46CYXlf80jhfuxWgMZEOurrwWrO2GMedsliFO8QUXZnCcUQ/LZX+PfGJEL2f1P
         P47Mjy8lF7V70M+HcxvkyLwE7wcVnFUc74xYXDUpmbxTTEMAdzN/Q23fnxf7cZ6b5HRf
         0WVdNnzDMYZeGieuHZXXhhEuqU2N9Uq0yr0QKWgTZImzdl4jlIKjwf3Bn3RMUdEEjrL4
         goQg==
X-Gm-Message-State: AOAM533z1NlOpZYCf9CLyDxsBiX50KJi+5Jx/mp4y77klkOtI9dFgPYd
        5dgvAsUGxX/Zj7uni8uvPac8Mg==
X-Google-Smtp-Source: ABdhPJyOMWKYlsBpZmjH/V0BtdExO+1W1NzPRHjkisI4EHVFLVPW4jEsaDT53gQtzfyezBL0luGdnA==
X-Received: by 2002:a54:4e10:: with SMTP id a16mr6051687oiy.48.1622129415549;
        Thu, 27 May 2021 08:30:15 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.233.147])
        by smtp.gmail.com with ESMTPSA id t39sm476798ooi.42.2021.05.27.08.30.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 May 2021 08:30:15 -0700 (PDT)
Subject: Re: [PATCH] io_uring: handle signals before letting io-worker exit
To:     Olivier Langlois <olivier@trillion01.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <60ae94d1.1c69fb81.94f7a.2a35SMTPIN_ADDED_MISSING@mx.google.com>
 <3d1bd9e2-b711-0aac-628e-89b95ff8dbc3@kernel.dk>
 <1e5c308bd25055ac8a899d40f00df08fc755e066.camel@trillion01.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <7e10ffd2-5948-3869-b0dc-fd81d693fe33@kernel.dk>
Date:   Thu, 27 May 2021 09:30:14 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1e5c308bd25055ac8a899d40f00df08fc755e066.camel@trillion01.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/27/21 9:21 AM, Olivier Langlois wrote:
> On Thu, 2021-05-27 at 07:46 -0600, Jens Axboe wrote:
>> On 5/26/21 12:21 PM, Olivier Langlois wrote:
>>> This is required for proper core dump generation.
>>>
>>> Because signals are normally serviced before resuming userspace and
>>> an
>>> io_worker thread will never resume userspace, it needs to
>>> explicitly
>>> call the signal servicing functions.
>>>
>>> Also, notice that it is possible to exit from the io_wqe_worker()
>>> function main loop while having a pending signal such as when
>>> the IO_WQ_BIT_EXIT bit is set.
>>>
>>> It is crucial to service any pending signal before calling
>>> do_exit()
>>> Proper coredump generation is relying on PF_SIGNALED to be set.
>>>
>>> More specifically, exit_mm() is using this flag to wait for the
>>> core dump completion before releasing its memory descriptor.
>>>
>>> Signed-off-by: Olivier Langlois <olivier@trillion01.com>
>>> ---
>>>  fs/io-wq.c | 22 ++++++++++++++++++++--
>>>  1 file changed, 20 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/fs/io-wq.c b/fs/io-wq.c
>>> index 5361a9b4b47b..b76c61e9aff2 100644
>>> --- a/fs/io-wq.c
>>> +++ b/fs/io-wq.c
>>> @@ -9,8 +9,6 @@
>>>  #include <linux/init.h>
>>>  #include <linux/errno.h>
>>>  #include <linux/sched/signal.h>
>>> -#include <linux/mm.h>
>>> -#include <linux/sched/mm.h>
>>>  #include <linux/percpu.h>
>>>  #include <linux/slab.h>
>>>  #include <linux/rculist_nulls.h>
>>> @@ -193,6 +191,26 @@ static void io_worker_exit(struct io_worker
>>> *worker)
>>>  
>>>         kfree_rcu(worker, rcu);
>>>         io_worker_ref_put(wqe->wq);
>>> +       /*
>>> +        * Because signals are normally serviced before resuming
>>> userspace and an
>>> +        * io_worker thread will never resume userspace, it needs
>>> to explicitly
>>> +        * call the signal servicing functions.
>>> +        *
>>> +        * Also notice that it is possible to exit from the
>>> io_wqe_worker()
>>> +        * function main loop while having a pending signal such as
>>> when
>>> +        * the IO_WQ_BIT_EXIT bit is set.
>>> +        *
>>> +        * It is crucial to service any pending signal before
>>> calling do_exit()
>>> +        * Proper coredump generation is relying on PF_SIGNALED to
>>> be set.
>>> +        *
>>> +        * More specifically, exit_mm() is using this flag to wait
>>> for the
>>> +        * core dump completion before releasing its memory
>>> descriptor.
>>> +        */
>>> +       if (signal_pending(current)) {
>>> +               struct ksignal ksig;
>>> +
>>> +               get_signal(&ksig);
>>> +       }
>>>         do_exit(0);
>>>  }
>>
>> Do we need the same thing in fs/io_uring.c:io_sq_thread()?
>>
> Jens,
> 
> You are 100% correct. In fact, this is the same problem for ALL
> currently existing and future io threads. Therefore, I start to think
> that the right place for the fix might be straight into do_exit()...

That is what I was getting at. To avoid poluting do_exit() with it, I
think it'd be best to add an io_thread_exit() that simply does:

void io_thread_exit(void)
{
	if (signal_pending(current)) {
		struct ksignal ksig;
		get_signal(&ksig);
	}
	do_exit(0);
}

and convert the do_exit() calls in io_uring/io-wq to io_thread_exit()
instead.

-- 
Jens Axboe

