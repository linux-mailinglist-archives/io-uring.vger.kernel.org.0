Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EF4B2675F1
	for <lists+io-uring@lfdr.de>; Sat, 12 Sep 2020 00:33:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725928AbgIKWdJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 11 Sep 2020 18:33:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725871AbgIKWdG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 11 Sep 2020 18:33:06 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4757C061573
        for <io-uring@vger.kernel.org>; Fri, 11 Sep 2020 15:33:05 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id d19so1546471pld.0
        for <io-uring@vger.kernel.org>; Fri, 11 Sep 2020 15:33:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Py8fTBOEMx6DrsjAYeg1N0Su7QTORsdKNbGjjgnh/18=;
        b=jnpkAX/qxJMXKCikew5jf20BNbTEXOA5nmWKej1w+3RbxcBIWFouo3XssA+PdtkWOx
         89p8Nv/K4W/8rH0wuoB5DTQAXF6FZkFZUz6V21sgKcShY7cs2+rda3GYnAeb7OfkdLNH
         6VMDPbbuAwIPBFLJzm59SKJqBryQY9imw1kpciLgK1UezYLtPdZ8VFs/Tp8ArfdyR7HU
         YP9fjY6G/I4JpxIeA9fQ2vnutEn/MywndEYXle251LmsFlO1Q5D1UY1s9mnZb9KLu0PY
         5JCuTaPGBe/GsSCGXr3iYZx56UNUNKq77LrL3Ijplv8n1yZvRKerqBgUvv7rk4iEaGel
         Xgxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Py8fTBOEMx6DrsjAYeg1N0Su7QTORsdKNbGjjgnh/18=;
        b=Di9eWcwNe7loG/N2TUVBtadA8QswxY58MzvVi3eMzKZpVXhcZ7tFeZknFA+ScZuMWp
         01YawEq2OLSFTCx3z5jvo5jYXsm6D5NCShndooLA2VdjnEQtiV6L6wlnjGdxgghgcby5
         1zpj87gvtE8PQmGZahQR1oKLagxbM6qy8DRPOBTTL2HOwuSkq2M+Eqvf8Jtxqf2UKMo9
         nYppq0vIC+5aed9FVBqkNGPmOqwYQQEbQUn8WYxEIJxk70yhKR0nNK4H+XnhSTlAazyH
         I7MDk2KeB2UdRvLyT3lgGOR9MqAHXO4N1Z3G1lIKkZMQfnOwATT1b1Okn+u7kifl8XQz
         blOQ==
X-Gm-Message-State: AOAM532O8v+hVpEAFZkskmtux61khnS3QmPY2VyrQBUH9w1sinKOFHL/
        DRdEN1Fgnn0h/JVwZxxMBEmyIQ==
X-Google-Smtp-Source: ABdhPJy7pHmja3uUb0bS7rsqxhKOazd5JzvxdExZ7oQCs5m1Dd9i58KlHgBvqjDT0A8DCjSKyCdrRA==
X-Received: by 2002:a17:90b:1988:: with SMTP id mv8mr4242806pjb.23.1599863585159;
        Fri, 11 Sep 2020 15:33:05 -0700 (PDT)
Received: from ?IPv6:2600:380:4955:1abc:b8c:928e:5fe6:fb78? ([2600:380:4955:1abc:b8c:928e:5fe6:fb78])
        by smtp.gmail.com with ESMTPSA id y202sm3223092pfc.179.2020.09.11.15.33.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Sep 2020 15:33:04 -0700 (PDT)
Subject: Re: [PATCH 2/2] io_uring: implement ->flush() sequence to handle
 ->files validity
To:     Jann Horn <jannh@google.com>
Cc:     io-uring <io-uring@vger.kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>
References: <20200911212625.630477-1-axboe@kernel.dk>
 <20200911212625.630477-3-axboe@kernel.dk>
 <CAG48ez06Pm1h7CH3nYojwqnSFrHhfrn1tcFxRrpu68Da=6tCGQ@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <62081d59-d793-b5bb-f4da-5cbe6e17e6c0@kernel.dk>
Date:   Fri, 11 Sep 2020 16:33:02 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAG48ez06Pm1h7CH3nYojwqnSFrHhfrn1tcFxRrpu68Da=6tCGQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/11/20 3:57 PM, Jann Horn wrote:
> On Fri, Sep 11, 2020 at 11:28 PM Jens Axboe <axboe@kernel.dk> wrote:
>> The current scheme stashes away ->ring_fd and ->ring_file, and uses
>> that to check against whether or not ->files could have changed. This
>> works, but doesn't work so well for SQPOLL. If the application does
>> close the ring_fd, then we require that applications enter the kernel
>> to refresh our state.
> 
> I don't understand the intent; please describe the scenario this is
> trying to fix. Is this something about applications that call dup()
> and close() on the uring fd, or something like that?

Sorry, I guess it should have been clearer. It's basically just a
replacement for the old fcheck(), to guard against dup and close between
when we grab the ->files and actually use them. So functionally it
should not be any different, unless I messed something up, but it allows
us to be a bit more flexible in how we handle it. The scope should be
more exact now, as it's between when we grab the ->files and when we
actually use them.

>> Add an atomic sequence for the ->flush() count on the ring fd, and if
>> we get a mismatch between checking this sequence before and after
>> grabbing the ->files, then we fail the request.
> 
> Is this expected to actually be possible during benign usage?

Doesn't introduce any new failure cases here. If you submit an IO that
needs to use the file table and close the ring fd in between, then the
IO _will_ get canceled.

>> This should offer the same protection that we currently have, with the
>> added benefit of being able to update the ->files automatically.
> 
> Please clarify what "update the ->files" is about.

async commands that need to use current->files - that means SQPOLL, and
it means regular uses cases that end up being punted to async execution.
Hope this helps?

>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>> ---
>>  fs/io_uring.c | 137 ++++++++++++++++++++++++++++++--------------------
>>  1 file changed, 83 insertions(+), 54 deletions(-)
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index 4958a9dca51a..49be5e21f166 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -308,8 +308,11 @@ struct io_ring_ctx {
>>          */
>>         struct fixed_file_data  *file_data;
>>         unsigned                nr_user_files;
>> -       int                     ring_fd;
>> -       struct file             *ring_file;
>> +
>> +       /* incremented when ->flush() is called */
>> +       atomic_t                files_seq;
> 
> If this ends up landing, all of this should probably use 64-bit types
> (atomic64_t and s64). 32-bit counters in fast syscalls can typically
> be wrapped around in a reasonable amount of time. (For example, the
> VMA cache sequence number wraparound issue
> <https://googleprojectzero.blogspot.com/2018/09/a-cache-invalidation-bug-in-linux.html>
> could be triggered in about an hour according to my blogpost from back
> then. For this sequence number, it should be significantly faster, I
> think.)

Yeah good point, we should use atomic64 and s64 for for the other parts.
I'll make that change right now, so I don't forget...

> (I haven't properly looked at the rest of this patch so far - I stared
> at it for a bit, but wasn't able to immediately figure out what's
> actually going on. So I figured I'd ask the more fundamental questions
> first.)

Hope the above helps!

-- 
Jens Axboe

