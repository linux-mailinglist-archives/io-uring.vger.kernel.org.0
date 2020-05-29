Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88BA51E77E8
	for <lists+io-uring@lfdr.de>; Fri, 29 May 2020 10:10:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725306AbgE2IKj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 29 May 2020 04:10:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725601AbgE2IKh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 29 May 2020 04:10:37 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 420DEC03E969
        for <io-uring@vger.kernel.org>; Fri, 29 May 2020 01:10:35 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id r15so2255994wmh.5
        for <io-uring@vger.kernel.org>; Fri, 29 May 2020 01:10:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=CzGTM4jxkpwc+8FgVjCcYao1d7bKCvy5YXvgUKGa+/k=;
        b=tJ4pGiy7Wl0AGQAdYfmLKVBmPLm3HSmJ6KU/inE79nfkJmN5OIiwzXpIidVdhrc7u9
         psTWkw3F1rsWwdThtjW8lLKQGuC9e1Rp/FbPAYP/eP3ix/ugO4RS2pLNjUfehK35U02f
         v5kJHTEQmdEJZYN5ODxy0AhiHXc5jPM/2O6kuDDnYD4XgxmEi4Auznxs797epCYyLb9b
         qTc9l43LKU2sD+9uo9m5btScDTCAOiFibE7SDg4aRuh86j21SArCTPWSQZNzebYGPuWJ
         pS0b2hV+CMaQdfDrArsXBlVHkC9WbxXkxIo1NLBzqc5RZfh8ZIo+e5bnuTl/BFcxHkDK
         txfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=CzGTM4jxkpwc+8FgVjCcYao1d7bKCvy5YXvgUKGa+/k=;
        b=HJjdPSGaswrluhf5Kuc387N9wmkRf7RJFxnieBtJRolrw8ZrOUyTTgpHw4fkkmc2L+
         S3UukZD50uaGAYWufmmyvkDGk04ftKROW5Gqi4I0kueRyY3NuVn8+ty3/7fWUM+fzN/Z
         2jFX05rx1jFhbPZdVFD49/aY5cOUJKFLRDVQ5CxJpD7sWWpw01M8usIYVGRXoK4/ZQzu
         cvYPg3b6BHhNKkrN5BriIMHln/sYoGZMGNByfKxu9w2vjO1QJzCj/AMNzFjv2pXuAYD1
         k2CkPCGM8NAF49MxbRHYL/tHZ4kbxcqvBgL/O1At1SFTwMDUywswyppzlXrxvZ4tPtzy
         v9PA==
X-Gm-Message-State: AOAM532uBdSbCHUUiLl4Bnri+452djBf3234RMhlua/HMffaTxDwvIMR
        72yDafVJVR0nztegKL+5tbM=
X-Google-Smtp-Source: ABdhPJyrnlE4TuPIQowt62tRN4+RGbFZFJG1atF/nY1he1i+OPoh/T9LdztuT0Sch83NyipsdHA8MA==
X-Received: by 2002:a1c:658a:: with SMTP id z132mr7192892wmb.20.1590739833888;
        Fri, 29 May 2020 01:10:33 -0700 (PDT)
Received: from [192.168.43.204] ([5.100.193.151])
        by smtp.gmail.com with ESMTPSA id 186sm4937750wma.45.2020.05.29.01.10.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 May 2020 01:10:33 -0700 (PDT)
To:     Jann Horn <jannh@google.com>
Cc:     io-uring <io-uring@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
References: <94f75705-3506-4c58-c1ff-cced9c045956@gmail.com>
 <CAG48ez24_NGyYEXyO+AaWZNEkK=CVmvOQDoGUoaJxtORoLU=OA@mail.gmail.com>
 <ab91ac71-def9-9e78-539d-05aebe7eda67@gmail.com>
 <CAG48ez0-2jcGk3qTqQqrDr+j1UWv4K4wF6rm0xkifVtkFz76Wg@mail.gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [RFC] .flush and io_uring_cancel_files
Message-ID: <c1a9a48a-e7a4-cc7c-3bb5-b2b8271ba5bc@gmail.com>
Date:   Fri, 29 May 2020 11:09:18 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <CAG48ez0-2jcGk3qTqQqrDr+j1UWv4K4wF6rm0xkifVtkFz76Wg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 27/05/2020 21:04, Jann Horn wrote:
> On Wed, May 27, 2020 at 12:14 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>> On 27/05/2020 01:04, Jann Horn wrote:
>>> On Tue, May 26, 2020 at 8:11 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>>> It looks like taking ->uring_lock should work like kind of grace
>>>> period for struct files_struct and io_uring_flush(), and that would
>>>> solve the race with "fcheck(ctx->ring_fd) == ctx->ring_file".
>>>>
>>>> Can you take a look? If you like it, I'll send a proper patch
>>>> and a bunch of cleanups on top.
>>>>
>>>>
>>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>>> index a3dbd5f40391..012af200dc72 100644
>>>> --- a/fs/io_uring.c
>>>> +++ b/fs/io_uring.c
>>>> @@ -5557,12 +5557,11 @@ static int io_grab_files(struct io_kiocb *req)
>>>>          * the fd has changed since we started down this path, and disallow
>>>>          * this operation if it has.
>>>>          */
>>>> -       if (fcheck(ctx->ring_fd) == ctx->ring_file) {
>>>> -               list_add(&req->inflight_entry, &ctx->inflight_list);
>>>> -               req->flags |= REQ_F_INFLIGHT;
>>>> -               req->work.files = current->files;
>>>> -               ret = 0;
>>>> -       }
>>>> +       list_add(&req->inflight_entry, &ctx->inflight_list);
>>>> +       req->flags |= REQ_F_INFLIGHT;
>>>> +       req->work.files = current->files;
>>>> +       ret = 0;
>>>> +
>>>>         spin_unlock_irq(&ctx->inflight_lock);
>>>>         rcu_read_unlock();
>>>>
>>>> @@ -7479,6 +7478,10 @@ static int io_uring_release(struct inode *inode, struct
>>>> file *file)
>>>>  static void io_uring_cancel_files(struct io_ring_ctx *ctx,
>>>>                                   struct files_struct *files)
>>>>  {
>>>> +       /* wait all submitters that can race for @files */
>>>> +       mutex_lock(&ctx->uring_lock);
>>>> +       mutex_unlock(&ctx->uring_lock);
>>>> +
>>>>         while (!list_empty_careful(&ctx->inflight_list)) {
>>>>                 struct io_kiocb *cancel_req = NULL, *req;
>>>>                 DEFINE_WAIT(wait);
>>>
>>> First off: You're removing a check in io_grab_files() without changing
>>> the comment that describes the check; and the new comment you're
>>> adding in io_uring_cancel_files() is IMO too short to be useful.
>>
>> Obviously, it was stripped down to show the idea, nobody is talking about
>> commiting it as is. I hoped Jens remembers it well enough to understand.
>> Let me describe it in more details then:
>>
>>>
>>> I'm trying to figure out how your change is supposed to work, and I
>>> don't get it. If a submitter is just past fdget() (at which point no
>>> locks are held), the ->flush() caller can instantly take and drop the
>>> ->uring_lock, and then later the rest of the submission path will grab
>>> an unprotected pointer to the files_struct. Am I missing something?
>>
>> old = tsk->files;
>> task_lock(tsk);
>> tsk->files = files;
>> task_unlock(tsk);
>> put_files_struct(old); (i.e. ->flush(old))
>>
>> It's from reset_files_struct(), and I presume the whole idea of
>> io_uring->flush() is to protect against racing for similarly going away @old
>> files. I.e. ensuring of not having io_uring requests holding @old files.
> 
> Kind of. We use the ->flush() handler to be notified when the
> files_struct goes away, so that instead of holding a reference to the
> files_struct (which would cause a reference loop), we can clean up our
> references when it goes away.
> 
>> The only place, where current->files are accessed and copied by io_uring, is
>> io_grab_files(), which is called in the submission path. And the whole
>> submission path is done under @uring_mtx.
> 
> No it isn't. We do fdget(fd) at the start of the io_uring_enter
> syscall, and at that point we obviously can't hold the uring_mtx yet.

__directly__ accessing ->files, or hand-coded. fdget() by itself shouldn't be a
problem.

> 
>> For your case, the submitter will take @uring_mtx only after this lock/unlock
>> happened, so it won't see old files (happens-before by locking mutex).
> 
> No, it will see the old files. The concurrent operation we're worried

From what you wrote below, it will see the old files just because nobody would
try to replace them. Is that it?

> about is not that the files_struct goes away somehow (that can't
> happen); what we want to guard against is a concurrent close() or
> dup2() or so removing the uring fd from the files_struct, because if
> someone calls close() before we stash a pointer to current->files,
> that pointer isn't protected anymore.

Let me guess, you mean maintenance of ->files itself, such as expand_files()?

> 
> 
>> The thing I don't know is why current->files is originally accessed without
>> protection in io_grab_files(), but presumably rcu_read_lock() there is for that
>> reason.
> 
> No, it's because current->files can never change under you; pretty
> much the only places where current->files can change are unshare() and
> execve().

I see, good to know


-- 
Pavel Begunkov
