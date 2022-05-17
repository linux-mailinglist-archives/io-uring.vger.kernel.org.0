Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7D55529F7C
	for <lists+io-uring@lfdr.de>; Tue, 17 May 2022 12:32:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344021AbiEQKcO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 17 May 2022 06:32:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245157AbiEQKcJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 17 May 2022 06:32:09 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33E6C220F5;
        Tue, 17 May 2022 03:32:07 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id er5so8260125edb.12;
        Tue, 17 May 2022 03:32:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=uEnEZY/dd9ktvryiUzy6yTJg5bkVk4uxrlpwIrViCCI=;
        b=B3zXpBqc/0bY2f91SoaokEvsoUPNyo8v3elAImRA7021+gVr+nNVSVPT2QGU35HzM2
         CZ85KGEgOUfj7gtG/WcZU0Dkr/ICJvYxzMu4WkjXdKZfbsZgU0rrPtFpBZrdmtEB5+PA
         Y0VVTue6JCOFiBnqblmaAbk9uAweK5Fly/COTu4EX22hNcyuttm3S3JzwIxE0IuACZNZ
         eql/0LxeY7Th7NmpSbw68sK9tKXfUnqdZiDPC+PHU6MccBJzpwZMEeVLtIm1fScdq0Wi
         6Pvwmy5hFMq7KYP+u6bL9fDVXiS7774byB5JInkgVFTmiPqZrdp/+7nl0Jmu3joUNx7X
         lzog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=uEnEZY/dd9ktvryiUzy6yTJg5bkVk4uxrlpwIrViCCI=;
        b=Flk69V+/HAcEyQ68Ww3GC2h4Rh+DkUqmQ9oMguV24fibHCPpa4OCnI7XR9k49YWZME
         xgkVe908NsfOPMtLx3ltSeZwjV60Iiq4DfMdjIlrc5lKIAmgb0WrPweLZRmzlCKKml9L
         o+sgRgJiqeb9Yef5jpWykmWXhjHoQ6J+s4qR3mwtMWE/i5luqNKoucq+VKs9jPyTuKlq
         +IUazSPd+ESaKiFLStOojojA2rYj0ShTHsg4wvRGqCku5scVbRwNRJYQzB0BUJEWnAhB
         5qiHZKwoFafHR1XBUIy4rV73FF5dblW8LfHv197ZDqf1gIgYzKphH/RhplCaN9R8GwV/
         ta9Q==
X-Gm-Message-State: AOAM532L0y/7XVv34yQkskzqQtqj9G2HuszC+MMwTrHfpduMHegmNcC4
        Iknxssw1k2W0JDp0yzyM7Dg=
X-Google-Smtp-Source: ABdhPJypOkBB/juKM3PDlVQ4TJo3gdQuSTl+xu58nb70Gj2qpGpJk52Tamd1vhdzCn8q+q9OUYO1Qg==
X-Received: by 2002:a05:6402:330b:b0:42a:b061:6e89 with SMTP id e11-20020a056402330b00b0042ab0616e89mr10985525eda.47.1652783525564;
        Tue, 17 May 2022 03:32:05 -0700 (PDT)
Received: from [192.168.8.198] ([85.255.232.74])
        by smtp.gmail.com with ESMTPSA id s2-20020aa7cb02000000b0042617ba63a5sm6545168edt.47.2022.05.17.03.32.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 May 2022 03:32:05 -0700 (PDT)
Message-ID: <73daf2cb-bcc8-afef-eddd-151f39e8eaed@gmail.com>
Date:   Tue, 17 May 2022 11:31:35 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [REGRESSION] lxc-stop hang on 5.17.x kernels
Content-Language: en-US
To:     Christian Brauner <brauner@kernel.org>,
        Daniel Harding <dharding@living180.net>,
        Jens Axboe <axboe@kernel.dk>,
        Thorsten Leemhuis <regressions@leemhuis.info>
Cc:     regressions@lists.linux.dev, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <a204ba93-7261-5c6e-1baf-e5427e26b124@living180.net>
 <bd932b5a-9508-e58f-05f8-001503e4bd2b@gmail.com>
 <12a57dd9-4423-a13d-559b-2b1dd2fb0ef3@living180.net>
 <897dc597-fc0a-34ec-84b8-7e1c4901e0fc@leemhuis.info>
 <c2f956e2-b235-9937-d554-424ae44c68e4@living180.net>
 <41c86189-0d1f-60f0-ca8e-f80b3ccf5130@gmail.com>
 <da56fa5f-0624-413e-74a1-545993940d27@gmail.com>
 <3fc08243-f9e0-9cec-4207-883c55ccff78@living180.net>
 <13028ff4-3565-f09e-818c-19e5f95fa60f@living180.net>
 <152e8d96-28e9-0dda-8782-10690195643b@gmail.com>
 <20220517081900.j3n2277g34wno4md@wittgenstein>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20220517081900.j3n2277g34wno4md@wittgenstein>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/17/22 09:19, Christian Brauner wrote:
> On Mon, May 16, 2022 at 07:13:05PM +0100, Pavel Begunkov wrote:
>> On 5/16/22 16:13, Daniel Harding wrote:
>>> On 5/16/22 16:57, Daniel Harding wrote:
>>>> On 5/16/22 16:25, Pavel Begunkov wrote:
>>>>> On 5/16/22 13:12, Pavel Begunkov wrote:
>>>>>> On 5/15/22 19:34, Daniel Harding wrote:
>>>>>>> On 5/15/22 11:20, Thorsten Leemhuis wrote:
>>>>>>>> On 04.05.22 08:54, Daniel Harding wrote:
>>>>>>>>> On 5/3/22 17:14, Pavel Begunkov wrote:
>>>>>>>>>> On 5/3/22 08:37, Daniel Harding wrote:
>>>>>>>>>>> [Resend with a smaller trace]
>>>>>>>>>>> On 5/3/22 02:14, Pavel Begunkov wrote:
>>>>>>>>>>>> On 5/2/22 19:49, Daniel Harding wrote:
>>>>>>>>>>>>> On 5/2/22 20:40, Pavel Begunkov wrote:
>>>>>>>>>>>>>> On 5/2/22 18:00, Jens Axboe wrote:
>>>>>>>>>>>>>>> On 5/2/22 7:59 AM, Jens Axboe wrote:
>>>>>>>>>>>>>>>> On 5/2/22 7:36 AM, Daniel Harding wrote:
>>>>>>>>>>>>>>>>> On 5/2/22 16:26, Jens Axboe wrote:
>>>>>>>>>>>>>>>>>> On 5/2/22 7:17 AM, Daniel Harding wrote:
>>>>>>>>>>>>>>>>>>> I use lxc-4.0.12 on Gentoo, built with io-uring support
>>>>>>>>>>>>>>>>>>> (--enable-liburing), targeting liburing-2.1.  My kernel
>>>>>>>>>>>>>>>>>>> config is a
>>>>>>>>>>>>>>>>>>> very lightly modified version of Fedora's generic kernel
>>>>>>>>>>>>>>>>>>> config. After
>>>>>>>>>>>>>>>>>>> moving from the 5.16.x series to the 5.17.x kernel series, I
>>>>>>>>>>>>>>>>>>> started
>>>>>>>>>>>>>>>>>>> noticed frequent hangs in lxc-stop. It doesn't happen 100%
>>>>>>>>>>>>>>>>>>> of the
>>>>>>>>>>>>>>>>>>> time, but definitely more than 50% of the time. Bisecting
>>>>>>>>>>>>>>>>>>> narrowed
>>>>>>>>>>>>>>>>>>> down the issue to commit
>>>>>>>>>>>>>>>>>>> aa43477b040251f451db0d844073ac00a8ab66ee:
>>>>>>>>>>>>>>>>>>> io_uring: poll rework. Testing indicates the problem is still
>>>>>>>>>>>>>>>>>>> present
>>>>>>>>>>>>>>>>>>> in 5.18-rc5. Unfortunately I do not have the expertise with the
>>>>>>>>>>>>>>>>>>> codebases of either lxc or io-uring to try to debug the problem
>>>>>>>>>>>>>>>>>>> further on my own, but I can easily apply patches to any of the
>>>>>>>>>>>>>>>>>>> involved components (lxc, liburing, kernel) and rebuild for
>>>>>>>>>>>>>>>>>>> testing or
>>>>>>>>>>>>>>>>>>> validation.  I am also happy to provide any further
>>>>>>>>>>>>>>>>>>> information that
>>>>>>>>>>>>>>>>>>> would be helpful with reproducing or debugging the problem.
>>>>>>>>>>>>>>>>>> Do you have a recipe to reproduce the hang? That would make it
>>>>>>>>>>>>>>>>>> significantly easier to figure out.
>>>>>>>>>>>>>>>>> I can reproduce it with just the following:
>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>        sudo lxc-create --n lxc-test --template download --bdev
>>>>>>>>>>>>>>>>> dir --dir /var/lib/lxc/lxc-test/rootfs -- -d ubuntu -r bionic
>>>>>>>>>>>>>>>>> -a amd64
>>>>>>>>>>>>>>>>>        sudo lxc-start -n lxc-test
>>>>>>>>>>>>>>>>>        sudo lxc-stop -n lxc-test
>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>> The lxc-stop command never exits and the container continues
>>>>>>>>>>>>>>>>> running.
>>>>>>>>>>>>>>>>> If that isn't sufficient to reproduce, please let me know.
>>>>>>>>>>>>>>>> Thanks, that's useful! I'm at a conference this week and hence have
>>>>>>>>>>>>>>>> limited amount of time to debug, hopefully Pavel has time to
>>>>>>>>>>>>>>>> take a look
>>>>>>>>>>>>>>>> at this.
>>>>>>>>>>>>>>> Didn't manage to reproduce. Can you try, on both the good and bad
>>>>>>>>>>>>>>> kernel, to do:
>>>>>>>>>>>>>> Same here, it doesn't reproduce for me
>>>>>>>>>>>>> OK, sorry it wasn't something simple.
>>>>>>>>>>>>>> # echo 1 > /sys/kernel/debug/tracing/events/io_uring/enable
>>>>>>>>>>>>>>> run lxc-stop
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> # cp /sys/kernel/debug/tracing/trace ~/iou-trace
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> so we can see what's going on? Looking at the source, lxc is just
>>>>>>>>>>>>>>> using
>>>>>>>>>>>>>>> plain POLL_ADD, so I'm guessing it's not getting a notification
>>>>>>>>>>>>>>> when it
>>>>>>>>>>>>>>> expects to, or it's POLL_REMOVE not doing its job. If we have a
>>>>>>>>>>>>>>> trace
>>>>>>>>>>>>>>> from both a working and broken kernel, that might shed some light
>>>>>>>>>>>>>>> on it.
>>>>>>>>>>>>> It's late in my timezone, but I'll try to work on getting those
>>>>>>>>>>>>> traces tomorrow.
>>>>>>>>>>>> I think I got it, I've attached a trace.
>>>>>>>>>>>>
>>>>>>>>>>>> What's interesting is that it issues a multi shot poll but I don't
>>>>>>>>>>>> see any kind of cancellation, neither cancel requests nor task/ring
>>>>>>>>>>>> exit. Perhaps have to go look at lxc to see how it's supposed
>>>>>>>>>>>> to work
>>>>>>>>>>> Yes, that looks exactly like my bad trace.  I've attached good trace
>>>>>>>>>>> (captured with linux-5.16.19) and a bad trace (captured with
>>>>>>>>>>> linux-5.17.5).  These are the differences I noticed with just a
>>>>>>>>>>> visual scan:
>>>>>>>>>>>
>>>>>>>>>>> * Both traces have three io_uring_submit_sqe calls at the very
>>>>>>>>>>> beginning, but in the good trace, there are further
>>>>>>>>>>> io_uring_submit_sqe calls throughout the trace, while in the bad
>>>>>>>>>>> trace, there are none.
>>>>>>>>>>> * The good trace uses a mask of c3 for io_uring_task_add much more
>>>>>>>>>>> often than the bad trace:  the bad trace uses a mask of c3 only for
>>>>>>>>>>> the very last call to io_uring_task_add, but a mask of 41 for the
>>>>>>>>>>> other calls.
>>>>>>>>>>> * In the good trace, many of the io_uring_complete calls have a
>>>>>>>>>>> result of 195, while in the bad trace, they all have a result of 1.
>>>>>>>>>>>
>>>>>>>>>>> I don't know whether any of those things are significant or not, but
>>>>>>>>>>> that's what jumped out at me.
>>>>>>>>>>>
>>>>>>>>>>> I have also attached a copy of the script I used to generate the
>>>>>>>>>>> traces.  If there is anything further I can to do help debug, please
>>>>>>>>>>> let me know.
>>>>>>>>>> Good observations! thanks for traces.
>>>>>>>>>>
>>>>>>>>>> It sounds like multi-shot poll requests were getting downgraded
>>>>>>>>>> to one-shot, which is a valid behaviour and was so because we
>>>>>>>>>> didn't fully support some cases. If that's the reason, than
>>>>>>>>>> the userspace/lxc is misusing the ABI. At least, that's the
>>>>>>>>>> working hypothesis for now, need to check lxc.
>>>>>>>>> So, I looked at the lxc source code, and it appears to at least try to
>>>>>>>>> handle the case of multi-shot being downgraded to one-shot.  I don't
>>>>>>>>> know enough to know if the code is actually correct however:
>>>>>>>>>
>>>>>>>>> https://github.com/lxc/lxc/blob/7e37cc96bb94175a8e351025d26cc35dc2d10543/src/lxc/mainloop.c#L165-L189
>>>>>>>>> https://github.com/lxc/lxc/blob/7e37cc96bb94175a8e351025d26cc35dc2d10543/src/lxc/mainloop.c#L254
>>>>>>>>> https://github.com/lxc/lxc/blob/7e37cc96bb94175a8e351025d26cc35dc2d10543/src/lxc/mainloop.c#L288-L290
>>>>>>>> Hi, this is your Linux kernel regression tracker. Nothing happened here
>>>>>>>> for round about ten days now afaics; or did the discussion continue
>>>>>>>> somewhere else.
>>>>>>>>
>>>>>>>>   From what I gathered from this discussion is seems the root cause might
>>>>>>>> be in LXC, but it was exposed by kernel change. That makes it sill a
>>>>>>>> kernel regression that should be fixed; or is there a strong reason why
>>>>>>>> we should let this one slip?
>>>>>>>
>>>>>>> No, there hasn't been any discussion since the email you
>>>>>>> replied to. I've done a bit more testing on my end, but
>>>>>>> without anything conclusive.  The one thing I can say is
>>>>>>> that my testing shows that LXC does correctly handle
>>>>>>> multi-shot poll requests which were being downgraded to
>>>>>>> one-shot in 5.16.x kernels, which I think invalidates
>>>>>>> Pavel's theory.  In 5.17.x kernels, those same poll
>>>>>>> requests are no longer being downgraded to one-shot
>>>>>>> requests, and thus under 5.17.x LXC is no longer
>>>>>>> re-arming those poll requests (but also shouldn't need
>>>>>>> to, according to what is being returned by the kernel).
>>>>>>> I don't know if this change in kernel behavior is
>>>>>>> related to the hang, or if it is just a side effect of
>>>>>>> other io-uring changes that made it into 5.17.  Nothing
>>>>>>> in the LXC's usage of io-uring seems obviously incorrect
>>>>>>> to me, but I am far from an expert.  I also did some
>>>>>>> work toward creating a simpler reproducer, without
>>>>>>> success (I was able to get a simple program using
>>>>>>> io-uring running, but never could get it to hang).  ISTM
>>>>>>> that this is still a kernel regression, unless someone
>>>>>>> can point out a definite fault in the way LXC is using
>>>>>>> io-uring.
>>>>>>
>>>>>> Haven't had time to debug it. Apparently LXC is stuck on
>>>>>> read(2) terminal fd. Not yet clear what is the reason.
>>>>>
>>>>> How it was with oneshots:
>>>>>
>>>>> 1: kernel: poll fires, add a CQE
>>>>> 2: kernel: remove poll
>>>>> 3: userspace: get CQE
>>>>> 4: userspace: read(terminal_fd);
>>>>> 5: userspace: add new poll
>>>>> 6: goto 1)
>>>>>
>>>>> What might happen and actually happens with multishot:
>>>>>
>>>>> 1: kernel: poll fires, add CQE1
>>>>> 2: kernel: poll fires again, add CQE2
>>>>> 3: userspace: get CQE1
>>>>> 4: userspace: read(terminal_fd); // reads all data, for both CQE1 and CQE2
>>>>> 5: userspace: get CQE2
>>>>> 6: userspace: read(terminal_fd); // nothing to read, hangs here
> 
> Ah, gotcha.
> So "5: userspace: get CQE2" what's the correct way to handle this
> problem surfacing in 6? Is it simply to use non-blocking fds and then
> handle EAGAIN/EWOULDBLOCK or is there a better way I'm missing?

I don't see a better way, unfortunately. If you read via io_uring it'll
hide blocking from you, but it doesn't seem like a simple change and
won't be performance-optimal anyway as ttys don't support IOCB_NOWAIT


>>>>> It should be the read in lxc_terminal_ptx_io().
>>>>>
>>>>> IMHO, it's not a regression but a not perfect feature API and/or
>>>>> an API misuse.
>>>>>
>>>>> Cc: Christian Brauner
>>>>>
>>>>> Christian, in case you may have some input on the LXC side of things.
>>>>> Daniel reported an LXC problem when it uses io_uring multishot poll requests.
>>>>> Before aa43477b04025 ("io_uring: poll rework"), multishot poll requests for
>>>>> tty/pty and some other files were always downgraded to oneshots, which had
>>>>> been fixed by the commit and exposed the problem. I hope the example above
>>>>> explains it, but please let me know if it needs more details
>>>>
>>>> Pavel, I had actually just started a draft email with the same theory (although you stated it much more clearly than I could have).  I'm working on debugging the LXC side, but I'm pretty sure the issue is due to LXC using blocking reads and getting stuck exactly as you describe.  If I can confirm this, I'll go ahead and mark this regression as invalid and file an issue with LXC. Thanks for your help and patience.
>>>
>>> Yes, it does appear that was the problem.  The attach POC patch against LXC fixes the hang.  The kernel is working as intended.
>>
>> Daniel, that's great, thanks for confirming!
> 
> Daniel, Jens, Pavel, Thorsten,
> 
> Thanks for debugging this! I've received an issue on the LXC bug tracker
> for this.
> 
> Just a little bit of background: LXC defaults to epoll event loops
> currently still so users must explicitly at compile-time select that
> they want to use io_uring. I exepct that in the future we might simply
> switch to io_uring completely.
> 
> But the fact that it's not the default might be the reason the issue
> hasn't surfaced earlier if it could've always been triggered.
> 
> (Fwiw, the multishot to oneshot downgrade of pty/tty fds was a bit of a
> problem originally and I only found out about it because of a Twitter
> thread with Jens; but maybe I missed documentation around this.)

I bet it was quite a pain!

"The CQE flags field will have IORING_CQE_F_MORE set on completion if
the application should expect further CQE entries from the original
request. If this flag isn't set on completion, then the poll request
has been terminated and no further events will be generated."

The rule still applies, though now we don't immediately downgrade it
for a bunch of common cases like polling files with multiple wait
queues.

-- 
Pavel Begunkov
