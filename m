Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 248B436B660
	for <lists+io-uring@lfdr.de>; Mon, 26 Apr 2021 18:02:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234510AbhDZQCQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 26 Apr 2021 12:02:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234502AbhDZQCP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 26 Apr 2021 12:02:15 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 327CEC061574
        for <io-uring@vger.kernel.org>; Mon, 26 Apr 2021 09:01:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Date:Message-ID:From:To:CC;
        bh=PauBmpIneSFC1tu0KfpvpZFo8XVxlxhN7j9VHy+uD3k=; b=BrKV/sftobXw0PwRgPahwGDohk
        vN4T4DT401sauGK8oRbd2UniJzHZVXJXbknn7JCJT5lOU47lKqGXdPkRnqpY9EVM6F9ydlPvKFb9Z
        gGQzxmUOgR+XNUZzy5WKuM7OzZ5vhoRRMBTKWrWwCQZhKJNF6suFUtzmyrLzpc04ud/nx99wmULrX
        bY2o07AMJDzeZbWkVxO68PzFXtBGg/a+zd9RRm50RFAM2gvjW/Q9Z/+sNh85SSsHxFqNgBxBqJnsI
        hMqpIoYCg8UYviIe4b44Zm8PzN5sv/HtdxuZN55uFltFD5OPByAlp+qOu1keCXPZSLxRAKuytGSJF
        beBuIE9ufOj9sRceCDRNeeQsFWs+nHkrQSqafVoExpcU2CVkOQEXkUjxhE3jj5aOVDxh1wgqOpNUZ
        p7yW47Xz1RDu46Nu0St3WtMDzS6vaTjEU7UdRHGaQu4Ip4vQ9YlBgI4Lr/B2uR1XqqH4TbU9zjJaw
        rAPsEMJK/+pJqT/1+LZmf0kH;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1lb3fu-0000WH-BZ; Mon, 26 Apr 2021 16:01:30 +0000
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1619306115.git.metze@samba.org>
 <9ba4228d-d346-766d-de5c-7d7d2bab92fa@kernel.dk>
From:   Stefan Metzmacher <metze@samba.org>
Subject: Re: [PATCH v3 0/6] Complete setup before calling wake_up_new_task()
Message-ID: <422fe390-11b4-203b-455c-5a1e456e6321@samba.org>
Date:   Mon, 26 Apr 2021 18:01:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <9ba4228d-d346-766d-de5c-7d7d2bab92fa@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Jens,

>> now that we have an explicit wake_up_new_task() in order to start the
>> result from create_io_thread(), we should set things up before calling
>> wake_up_new_task().
>>
>> Changes in v3:
>>  - rebased on for-5.13/io_uring.
>>  - I dropped this:
>>   fs/proc: hide PF_IO_WORKER in get_task_cmdline()
>>  - I added:
>>   set_task_comm() overflow checks
> 
> Looks good to me, a few comments:
> 
> 1) I agree with Pavel that the WARN on overflow is kinda silly,
>    it doesn't matter that much. So I'd rather drop those for now.

I think the overflow matters, the last time, it went unnoticed in
commit c5def4ab849494d3c97f6c9fc84b2ddb868fe78c

        worker->task = kthread_create_on_node(io_wqe_worker, worker, wqe->node,
-                                               "io_wqe_worker-%d", wqe->node);
+                               "io_wqe_worker-%d/%d", index, wqe->node);

With that "io_wqe_worker-0" or "io_wqe_worker-1" are still (up to 5.11)
reported to userspace. And between 5.3 and 5.4 the meaning changed,
the shown value is now unbound vs. bound, while it was the numa node before.

While I was debugging numa related problems, that took a long time to
figure out.

Now that we have the pid encoded in the name, it should not be truncated,
otherwise it will make it impossible to debug problems.

If the userspace application has 10 threads (with pids which would all cause
on overflow) and each uses io_uring (64 io-workers each), then we may have
640 io-workers all with the same name, which are all in the same userspace
process, and it's not possible to find which workers belong to which userspace
thread.

Currently we can ignore as there's no problem, so I'm fine with dropping
5-6 for now.

Maybe a better assertion would be BUILD_BUG_ON(PID_MAX_LIMIT > 9999999);
(or something similar) in order to prevent this from happening.

> 2) Would really love it to see some decent commit messages, quite
>    a few of them are empty. In general some reasoning is nice in
>    the commit message, when you don't have the context available.
> 
> Do you want to do a v4 with 5-6/6 dropped for now, and 3-4 having
> some reasoning? I can also just apply as-is and write some commit
> message myself, let me know. I'll add 1-2 for now.

I'm currently busy with other stuff, it would be great if you could
expand the commit messages!

Thanks!
metze
