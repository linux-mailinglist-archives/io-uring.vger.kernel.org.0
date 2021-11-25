Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59F1345DD8E
	for <lists+io-uring@lfdr.de>; Thu, 25 Nov 2021 16:35:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234460AbhKYPin (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 25 Nov 2021 10:38:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356090AbhKYPgl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 25 Nov 2021 10:36:41 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6487C06179F
        for <io-uring@vger.kernel.org>; Thu, 25 Nov 2021 07:27:24 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id u1so12371654wru.13
        for <io-uring@vger.kernel.org>; Thu, 25 Nov 2021 07:27:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=cYcB2ZgnfTDBml5TyOPAffe8gl/G6CL3DwYuQBEmiv0=;
        b=PM5zpeHnWBFokTS64DpCBCjgyC7owtEr+YczuIqVVwDDodsa5LhBoAbpIGoAIyKP2n
         DKieN1xnRIT08KjCXUjyyj5xKpXii3P6MsgTg+fkxpkIGMawq913ayyylA82aqs8B+fJ
         52kXaZVqR+7NWSCvnh9C6JaYdnZDk7cpO+u3OtDXATotK717iD4/CMdeqUiuQT+v2gUn
         tZmkZkNd8F/o74VB1R614HwMBPrZwxEINdeSKY0b71ZD5hOTXuhRUj23p6bxD9z6vIWE
         OiBbpIkTwfTleSAV7PYBalH48Mu4iQI27N8Z1243fDd93wU5Wk9bX4OJf3LPVUH+YJAL
         IRcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=cYcB2ZgnfTDBml5TyOPAffe8gl/G6CL3DwYuQBEmiv0=;
        b=tL44UFAcnpEEJYl39MoLvApWRK1zzCKgDcE3grM1Az+Iyom7P2wPrqeaGhU5fCjN7D
         Mi2y0Cjt/ERg1LimZr2HMZvflVTlSqld2pXBdVBc5N7ia0y850f1XnhRH6cYMnfdZQIl
         u7FTWjOx6FO8Qgpq4lMgdXi4FmVdH2WJY0kMoiEtNYybDnkwBDsjlY9slbkVAN868L1Z
         ZypuIoI/zNacPuyQVqNSRewgx+ivn5EGrukYw3bk0yd+HGI7Qg7gO7ayZcoNpHbVq38e
         1d6vHkxP8WqO7YNTAeYIgW7XVg0ghPo5Ll4Ny9JgQEVuP7hOdtLcUznvC5Ta1D+khXPP
         aKuw==
X-Gm-Message-State: AOAM531JMnjJmoz5ghFUc7b6hLgHScg+0WCb0LC8HbdzPN1ojPMWuns+
        pOacP1g+gfYNHnnjZFEwvWc=
X-Google-Smtp-Source: ABdhPJxICdzLG0VMb6YbYbcU29SnMPyRCJnbzCMKWt+/FGgQZnpx3oflR83MZe7DnZHLO0xaSMyRjg==
X-Received: by 2002:a5d:54d0:: with SMTP id x16mr7410869wrv.606.1637854043558;
        Thu, 25 Nov 2021 07:27:23 -0800 (PST)
Received: from [192.168.43.77] (82-132-229-54.dab.02.net. [82.132.229.54])
        by smtp.gmail.com with ESMTPSA id o5sm2969367wrx.83.2021.11.25.07.27.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Nov 2021 07:27:23 -0800 (PST)
Message-ID: <876d367c-91d5-b0bf-9e88-acfaa98e77b9@gmail.com>
Date:   Thu, 25 Nov 2021 15:27:04 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH v5 0/6] task work optimization
Content-Language: en-US
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20211124122202.218756-1-haoxu@linux.alibaba.com>
 <28685b5a-5484-809c-38d7-ef60f359b535@gmail.com>
 <9682cd7d-bdc6-cbc9-b209-311e65a5fce9@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <9682cd7d-bdc6-cbc9-b209-311e65a5fce9@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/25/21 11:37, Hao Xu wrote:
> 在 2021/11/25 上午5:41, Pavel Begunkov 写道:
>> On 11/24/21 12:21, Hao Xu wrote:
>>> v4->v5
>>> - change the implementation of merge_wq_list
>>
>> They only concern I had was about 6/6 not using inline completion
>> infra, when it's faster to grab ->uring_lock. i.e.
>> io_submit_flush_completions(), which should be faster when batching
>> is good.
>>
>> Looking again through the code, the only user is SQPOLL
>>
>> io_req_task_work_add(req, !!(req->ctx->flags & IORING_SETUP_SQPOLL));
>>
>> And with SQPOLL the lock is mostly grabbed by the SQPOLL task only,
>> IOW for pure block rw there shouldn't be any contention.
> There still could be other type of task work, like async buffered reads.
> I considered generic situation where different kinds of task works mixed
> in the task list, then the inline completion infra always handle the
> completions at the end, while in this new batching, we first handle the
> completions and commit_cqring then do other task works.

I was talking about 6/6 in particular. The reordering (done by first
2 or 3 patches) sound plausible, but if compare say 1-5 vs same but
+ patch 6/6

> Btw, I'm not sure the inline completion infra is faster than this
> batching in pure rw completion(where all the task works are completion)
> case, from the code, seems they are similar. Any hints about this?

Was looking through, and apparently I placed task_put optimisation
into io_req_complete_post() as well, see io_put_task().

pros of io_submit_flush_completions:
1) batched rsrc refs put
2) a bit better on assembly
3) shorter spin section (separate loop)
4) enqueueing right into ctx->submit_state.free_list, so no
    1 io_flush_cached_reqs() per IO_COMPL_BATCH=32

pros of io_req_complete_post() path:
1) no uring_lock locking (not contended)
2) de-virtualisation
3) no extra (yet another) list traversal and io_req_complete_state()

So, with put_task optimised, indeed not so clear which would win.
Did you use fixed rsrc for testing? (files or buffers)

-- 
Pavel Begunkov
