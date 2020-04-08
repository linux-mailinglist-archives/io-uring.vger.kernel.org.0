Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 468701A2AEF
	for <lists+io-uring@lfdr.de>; Wed,  8 Apr 2020 23:19:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729533AbgDHVTn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Apr 2020 17:19:43 -0400
Received: from mail-pj1-f66.google.com ([209.85.216.66]:56162 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726663AbgDHVTn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Apr 2020 17:19:43 -0400
Received: by mail-pj1-f66.google.com with SMTP id a32so358457pje.5
        for <io-uring@vger.kernel.org>; Wed, 08 Apr 2020 14:19:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Ask9PlGmbkd/AkiHcWWGlX2KWHf6W994if/UTnJxs/o=;
        b=Oc0pd37eQgr3k+UcXzGjMoCeN556gq18SXcC9WW2v6lGI4JYE6DY+yRc79bF7TahVV
         MId/ot3yaq4W1suQVBrxiUxNctVGV4HckxbMba++lGRi9EQ55ebL8Ryf2GbvOOWzM9RU
         zBnnma6Ay5yYM/kJQoDn7+u9PwZjXnci7e2RwUrQi9B0ADbWY6lkXlSFqZZ5V/LNE7Ya
         xi1psutWCbCfdPpCn+USOCpQAHtcrEtdv00P9MEte+1DA50OsNsKlQgoyfRnYhZ8PAXM
         T0KeOQx5LyQGrZLVoXWlgKh6DXjvl3NH+xA9/I+dUPaL8Boecfiqb1fuJNf9K9drchJy
         4UuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ask9PlGmbkd/AkiHcWWGlX2KWHf6W994if/UTnJxs/o=;
        b=FaY8F9P6CkOMkQgkR14MkxTwGDuCm6yb4rJQvH+wfuuSUtR9LyhmE0/a+p0LTii2GI
         PWMpc36rR2oNeqmxtZLxPSFO22RJQ4c2DpAmZm7mSTbNWjUFyEZDR2h3htNEucGSixly
         yZvnUxXWmC0gVig4ii4RvjNoapceW1wDtVYyfVNxJRrxflwA4eKiR7e+9WhFAerRfyfi
         nUOoBJA7VEafLGkJPINQnkFOVKhWesQWMFmzoeMFGsgw5TTiSUKhI3XtknxU4QmfXiao
         mhXf5hKzDwtNqEG23rJBlL6E8orJC3eHgTX1imzTtYLYbo2111S2Iq44xR5mIUv2YYRn
         /Nwg==
X-Gm-Message-State: AGi0PuZALLrduSzEKK8DgZVGr28nQHRM6vt9nHQkRRNQ9NMJWJKdAcx+
        fzYmzLKhz+l2ZHfBPZXq5FLMDg==
X-Google-Smtp-Source: APiQypIo8FPGEcWN4KjpvT1sbCi7Yb62U/I26VHbLpRkK4/t2+nk8eiC5A3jAL9bkgk+7yj6icwuDg==
X-Received: by 2002:a17:90b:190c:: with SMTP id mp12mr1860350pjb.86.1586380782141;
        Wed, 08 Apr 2020 14:19:42 -0700 (PDT)
Received: from ?IPv6:2620:10d:c085:21c8::12dd? ([2620:10d:c090:400::5:607f])
        by smtp.gmail.com with ESMTPSA id 11sm17322964pfz.91.2020.04.08.14.19.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Apr 2020 14:19:41 -0700 (PDT)
Subject: Re: [PATCH 4/4] io_uring: flush task work before waiting for ring
 exit
From:   Jens Axboe <axboe@kernel.dk>
To:     Oleg Nesterov <oleg@redhat.com>
Cc:     io-uring@vger.kernel.org, viro@zeniv.linux.org.uk,
        Peter Zijlstra <peterz@infradead.org>
References: <20200407160258.933-1-axboe@kernel.dk>
 <20200407160258.933-5-axboe@kernel.dk> <20200407162405.GA9655@redhat.com>
 <20200407163816.GB9655@redhat.com>
 <4b70317a-d12a-6c29-1d7f-1394527f9676@kernel.dk>
 <20200408184049.GA25918@redhat.com>
 <a31dfee4-8125-a3c1-4be6-bd4a3f71b301@kernel.dk>
 <6d320b43-254d-2d42-cbad-d323f1532e65@kernel.dk>
 <20200408201734.GA21347@redhat.com>
 <884c70e0-2ec5-7ae6-7484-2bbbf4aa3e5d@kernel.dk>
Message-ID: <147ba8f3-4eb1-b58d-9534-f9d20b130ccd@kernel.dk>
Date:   Wed, 8 Apr 2020 14:19:39 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <884c70e0-2ec5-7ae6-7484-2bbbf4aa3e5d@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/8/20 1:25 PM, Jens Axboe wrote:
> On 4/8/20 1:17 PM, Oleg Nesterov wrote:
>> On 04/08, Jens Axboe wrote:
>>>
>>> Here's some more data. I added a WARN_ON_ONCE() for task->flags &
>>> PF_EXITING on task_work_add() success, and it triggers with the
>>> following backtrace:
>> ...
>>> which means that we've successfully added the task_work while the
>>> process is exiting.
>>
>> but this is fine, task_work_add(task) can succeed if task->flags & EXITING.
>>
>> task_work_add(task, work) should only fail if this "task" has already passed
>> exit_task_work(). Because if this task has already passed exit_task_work(),
>> nothing else can flush this work and call work->func().
> 
> So the question remains, we basically have this:
> 
> A			B
> task_work_run(tsk)
> 			task_work_add(tsk, io_poll_task_func())
> process cbs
> wait_for_completion()
> 
> with the last wait needing to flush the work added on the B side, since
> that isn't part of the initial list.
> 
> I don't I can fully close that race _without_ re-running task work
> there. Could do something ala:
> 
> A			B
> mark context "dead"
> task_work_run(tsk)
> 			if (context dead)
> 				task_work_add(helper, io_poll_task_func())
> 			else
> 				task_work_add(tsk, io_poll_task_func())
> process cbs
> wait_for_completion()
> 
> which would do the trick, but I still need to flush work after having
> marked the context dead.

Actually, I guess it's not enough to re-run the work, we could also
have ordering issues if we have io_poll_task_func() after the fput
of the ring. Maybe this could all work just fine if we just make
the ring exit non-blocking... Testing.

-- 
Jens Axboe

