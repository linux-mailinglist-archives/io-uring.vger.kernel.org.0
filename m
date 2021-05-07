Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EA453767CE
	for <lists+io-uring@lfdr.de>; Fri,  7 May 2021 17:19:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235288AbhEGPUs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 7 May 2021 11:20:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235044AbhEGPUl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 7 May 2021 11:20:41 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FD73C061574
        for <io-uring@vger.kernel.org>; Fri,  7 May 2021 08:19:39 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id h4so9642742wrt.12
        for <io-uring@vger.kernel.org>; Fri, 07 May 2021 08:19:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=a4rdBbPQkHF3rv5V637E0P8hfz6mQq/Xmp1P5lFc6Ds=;
        b=hguENvirD25k2cKNhnAE+HiDMCvMFGUoYJb7drsRWcGFIckmq6AwfJ7oH0LNLXR9Af
         gmxIlZl4+MBOKnCSjXCnZNEEo1fHGL4pWUoh0kje5r+/3O38V+D0pk/EC7jojOOMsSC9
         4p9UTWrwvQwHqqnoCaPXZ8Wv8c7tGoof3B6U9cWY2J+vL3RSc5M3bvidnlr++/BdNSJ6
         vgzLFMIgyTsAe16MWlIa80NnlQ7LcTOg9D4bbAWqCs73A5mqTVXJ3RCWcpvlrvN2dWb0
         P+morxlBqF1/etOWL8RLf9l972hb5atE8OtPGZP3jDhLiM/05HUe4/KhdPCq79jfiZtR
         LMng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=a4rdBbPQkHF3rv5V637E0P8hfz6mQq/Xmp1P5lFc6Ds=;
        b=PDEH/TkUIMM5c3LWeUeQ8bIah37H7dwRLH0nhYItcHyZUMlMPJuuYqhJoyHOHoL4j+
         l1S4+9kh0Bf14heiBnj9fvCk0PDrkauZmGIqGJLG48RU3dqUjj7mpbpUX2gyYTzmNHQ5
         bWgxuqEZUIyH6fIqq3XQKLlECZphmNN9zmIUXZePRAdqc0H6TFTgk9VUWvCMy+186Sv2
         5utplJhEl2bCbq2ux7a/dBJ5CzEzZ63oxS715cIzNChPMsg6vJtVau5CQI3wn9hfQTP6
         UvAj/BkoXXVUL/H/BMQMYjIKBtPTveDPH86W0Gbt5Yso1y96jfHXwmDDjWJidEav/L3y
         gezg==
X-Gm-Message-State: AOAM5326jKjPc6kILpmulLzzMOKTdga/9b+xLQ8WsNmyLeLnAEmpwAK7
        7AAZxx5lsrVlwIbkplofIhPcJoq7KhU=
X-Google-Smtp-Source: ABdhPJwtFRwCQKPJw8F+OyepL8QGpUfPDNrDF3LAbU4tAtU0oxWNcHHyQzRyLvaw/BFBGv3SAPH+HA==
X-Received: by 2002:a5d:64e5:: with SMTP id g5mr13300009wri.30.1620400778319;
        Fri, 07 May 2021 08:19:38 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.132.80])
        by smtp.gmail.com with ESMTPSA id n7sm8893091wri.14.2021.05.07.08.19.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 May 2021 08:19:37 -0700 (PDT)
Subject: Re: [PATCH RFC 5.13] io_uring: add IORING_REGISTER_PRIORITY
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <1620311593-46083-1-git-send-email-haoxu@linux.alibaba.com>
 <38e587bb-a484-24dc-1ea9-cc252b1639ba@kernel.dk>
 <92da0bd6-3de9-eedd-fca7-87d8ad99ba70@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <31f6454f-7de8-97b4-4042-b9e7a3e121da@gmail.com>
Date:   Fri, 7 May 2021 16:19:31 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <92da0bd6-3de9-eedd-fca7-87d8ad99ba70@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/6/21 8:20 PM, Hao Xu wrote:
> 在 2021/5/7 上午1:10, Jens Axboe 写道:
>> On 5/6/21 8:33 AM, Hao Xu wrote:
>>> Users may want a higher priority for sq_thread or io-worker. Provide a
>>> way to change the nice value(for SCHED_NORMAL) or scheduling policy.
>>
>> Silly question - why is this needed for sqpoll? With the threads now
>> being essentially user threads, why can't we just modify nice and
>> scheduler class from userspace instead? That should work now. I think
>> this is especially true for sqpoll where it's persistent, and argument
>> could be made for the io-wq worker threads that we'd need io_uring
>> support for that, as they come and go and there's no reliable way to
>> find and tweak the thread scheduler settings for that particular use
>> case.
>>
>> It may be more convenient to support this through io_uring, and that is
>> a valid argument. I do think that the better way would then be to simply
>> pass back the sqpoll pid after ring setup, because then it'd almost be
>> as simple to do it from the app itself using the regular system call
>> interfaces for that.
>>> It's my bad. I didn't realize this until I almost completed the patch,
> then I looked into io_uring_param, found just __u32 resv[3] can be
> leveraged. Not sure if it's neccessary to occupy one to do this, so I
> still sent this patch for comments.

io_uring_param is not a problem, can be extended.

>> In summary, I do think this _may_ make sense for the worker threads,
>> being able to pass in this information and have io-wq worker thread
>> setup perform the necessary tweaks when a thread is created, but it does
> I'm working on this(for the io-wq worker), have done part of it.

I'm not sure the io-wq part makes much sense,

1) they are per thread, so an instance not related to some particular
ring, and so should not be controlled by it. E.g. what if a ring
has two different rings and sets different schedulers?

2) io-wq is slow path in any case, don't think it's worth trinking
with it.

>> seem a bit silly to add this for sqpoll where it could just as easily be
>> achieved from the application itself without needing to add this
> It's beyond my knowledge, correct me if I'm wrong: if we do
> it from application, we have to search the pid of sq_thread by it's name
> which is iou-sqp-`sqd->task_pid`, and may be cut off because of
> TASK_COMM_LEN(would this macro value be possibly changed in the
> future?). And set_task_comm() is called when sq_thread runs, so there is
> very small chance(but there is) that set_task_comm() hasn't been called
> when application try to get the command name of sq_thread. Based on this
> (if it is not wrong...) I think return pid of sq_thread in io_uring
> level may be a better choice.

Right, we may return some id of sqpoll task back in io_uring_param,
though we need to be careful with namespaces.

-- 
Pavel Begunkov
