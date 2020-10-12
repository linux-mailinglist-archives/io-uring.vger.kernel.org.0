Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53F8B28C484
	for <lists+io-uring@lfdr.de>; Tue, 13 Oct 2020 00:08:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732201AbgJLWIY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 12 Oct 2020 18:08:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729530AbgJLWIY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 12 Oct 2020 18:08:24 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8828BC0613D0
        for <io-uring@vger.kernel.org>; Mon, 12 Oct 2020 15:08:24 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id h6so15769795pgk.4
        for <io-uring@vger.kernel.org>; Mon, 12 Oct 2020 15:08:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4al7wfZVgfAERJ7vH/5/b26mpDMh+AZhQTop2OzSGok=;
        b=ABCRb/bgMiNaM/Q4FUEZP0lTEllOxp4wDCT0MyP7a+IUeMCIyc4jUa4V0IwGXdoLGT
         7v8da8DB1lY/ZCQEsy8W4jKRTUSmydVJKj5vkm3Unb+IRgnfB93Z/1dK8VNiq/7SKRjH
         deWDXBFq2VivShQDrDJ7LglwGlfblaF2c/2IYB2EWC7ByVGmLHOg34cH+n/lbmHmwzmA
         6IcGv2b7VzMuEp3kOA0799+nKsvr2GMJaIAtcYlp8nvn/QhpMLEDA0caa/PSd41yEZ61
         axchS7fsMvaT3CCM8/72I5USTv1I40Kj+YTky3D0KcTu6v3LOhJq3AXI6K4DtXEWEwfQ
         eGYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4al7wfZVgfAERJ7vH/5/b26mpDMh+AZhQTop2OzSGok=;
        b=rIauADnUdMh1Nizyc4UL9k/mWW7e3Qt4m5rEr6AJrcr477p0xhWNysQjaf9gh4ZEd6
         yDZ0piw/OH18ahkFP9eSa529satuUNNLlpN/INblr90CbM0VBk9iTv8jOeaV+EwUc8qX
         rRHBl7H6rZ3hks4ymWHTzhUAhb3mAkzfEWY2O9OpQc7GlNGuzYbQV+AZUDwVU5iuPlxg
         gcGX1gDJDr68rwlsksKWgoEzuYO6Q62dwz/N3IZ7N5MyZvDFWKp2KO6P4GeWehRfbYpU
         j+qn8t9wnS4YHtUsRvEKmtUr20MmdMozbL6HzBdCwrvK/6MU3+xDbQ6r3IG3F5a/kZzQ
         EjUw==
X-Gm-Message-State: AOAM533kREv6U4vQQGRriqosCp2Ki6v4FNHLID2DCmWPcG4ej2LNFekR
        7NW5+T1vt3m2G/auH40Ya1sIRw==
X-Google-Smtp-Source: ABdhPJybU/S7/3B6M9imwbG1p3QiYGan3uN2ngZwRPTwxtx/aTOgo670+sQDbVTmliHHuWHQiGm8VQ==
X-Received: by 2002:a17:90b:33d1:: with SMTP id lk17mr10677088pjb.181.1602540503979;
        Mon, 12 Oct 2020 15:08:23 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id b10sm19574487pgm.64.2020.10.12.15.08.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Oct 2020 15:08:23 -0700 (PDT)
Subject: Re: Loophole in async page I/O
To:     Matthew Wilcox <willy@infradead.org>, io-uring@vger.kernel.org
Cc:     Johannes Weiner <hannes@cmpxchg.org>
References: <20201012211355.GC20115@casper.infradead.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <14d97ab3-edf7-c72a-51eb-d335e2768b65@kernel.dk>
Date:   Mon, 12 Oct 2020 16:08:22 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201012211355.GC20115@casper.infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/12/20 3:13 PM, Matthew Wilcox wrote:
> This one's pretty unlikely, but there's a case in buffered reads where
> an IOCB_WAITQ read can end up sleeping.
> 
> generic_file_buffered_read():
>                 page = find_get_page(mapping, index);
> ...
>                 if (!PageUptodate(page)) {
> ...
>                         if (iocb->ki_flags & IOCB_WAITQ) {
> ...
>                                 error = wait_on_page_locked_async(page,
>                                                                 iocb->ki_waitq);
> wait_on_page_locked_async():
>         if (!PageLocked(page))
>                 return 0;
> (back to generic_file_buffered_read):
>                         if (!mapping->a_ops->is_partially_uptodate(page,
>                                                         offset, iter->count))
>                                 goto page_not_up_to_date_locked;
> 
> page_not_up_to_date_locked:
>                 if (iocb->ki_flags & (IOCB_NOIO | IOCB_NOWAIT)) {
>                         unlock_page(page);
>                         put_page(page);
>                         goto would_block;
>                 }
> ...
>                 error = mapping->a_ops->readpage(filp, page);
> (will unlock page on I/O completion)
>                 if (!PageUptodate(page)) {
>                         error = lock_page_killable(page);
> 
> So if we have IOCB_WAITQ set but IOCB_NOWAIT clear, we'll call ->readpage()
> and wait for the I/O to complete.  I can't quite figure out if this is
> intentional -- I think not; if I understand the semantics right, we
> should be returning -EIOCBQUEUED and punting to an I/O thread to
> kick off the I/O and wait.
> 
> I think the right fix is to return -EIOCBQUEUED from
> wait_on_page_locked_async() if the page isn't locked.  ie this:
> 
> @@ -1258,7 +1258,7 @@ static int wait_on_page_locked_async(struct page *page,
>                                      struct wait_page_queue *wait)
>  {
>         if (!PageLocked(page))
> -               return 0;
> +               return -EIOCBQUEUED;
>         return __wait_on_page_locked_async(compound_head(page), wait, false);
>  }
>  
> But as I said, I'm not sure what the semantics are supposed to be.

If NOWAIT isn't set, then the issue attempt is from the helper thread
already, and IOCB_WAITQ shouldn't be set either (the latter doesn't
matter for this discussion). So it's totally fine and expected to block
at that point.

Hmm actually, I believe that:

commit c8d317aa1887b40b188ec3aaa6e9e524333caed1
Author: Hao Xu <haoxu@linux.alibaba.com>
Date:   Tue Sep 29 20:00:45 2020 +0800

    io_uring: fix async buffered reads when readahead is disabled

maybe messed up that case, so we could block off the retry-path. I'll
take a closer look, looks like that can be the case if read-ahead is
disabled.

In general, we can only return -EIOCBQUEUED if the IO has been started
or is in progress already. That means we can safely rely on being told
when it's unlocked/done. If we need to block, we should be returning
-EAGAIN, which would punt to a worker thread.

-- 
Jens Axboe

