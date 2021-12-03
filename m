Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8523546795A
	for <lists+io-uring@lfdr.de>; Fri,  3 Dec 2021 15:21:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381452AbhLCOYi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 3 Dec 2021 09:24:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239252AbhLCOYh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 3 Dec 2021 09:24:37 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89518C061359
        for <io-uring@vger.kernel.org>; Fri,  3 Dec 2021 06:21:13 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id o13so6001256wrs.12
        for <io-uring@vger.kernel.org>; Fri, 03 Dec 2021 06:21:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=PoHUgeJJzAxB40/z6R51ugv6vJleGlkExh7jxtBsiiE=;
        b=Ll/cNHCSWKbBWx1jpMJccHZ7/kcDS2jwWp9MLP4RS/i8pOjg2sE0vMHHDez+V6RRoN
         3lrQVRvCiKRIEyP7jnUVzLvI5fCxRAXWoLGr5jzDR/g5KInZpzbdO4IHirrrtLwYYnvE
         Ofuy+Zg0CfxiSOqVzOOgmJe3fz6kwUfFJyPLNdyHTsP4huM4M40Bj94CE5FXe53RM/Do
         Yk9Deh8alDnimhleR5q8dB7i0YLJ7MCT00lnDukJFQSOGewOTad7H6N7CcHWz+vwlfdC
         BFjKOUhZIWSnlRg9DgSWCQPXjxwo/VcMoTMOpETXe/eYYYdpbzP3wHtVY3F1VIVESa/H
         x+6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=PoHUgeJJzAxB40/z6R51ugv6vJleGlkExh7jxtBsiiE=;
        b=K6LVRsgyjcA18+AwcEMBEhgFvme2eLct9vCptwk8TUOpkrUnB2uMRM5LhP/fa0QQqM
         OG+p4VJQZE8ZNtolXLJsf2+AgXKGpaI+01TKbdwVzDxxeImZRQ7ufCNYqUQFLk2Ehg5L
         2xRfqV+jU8u7EutG20zFOgFcrOGb6uPvafr5P3gULSS2zu2g7T9Vj8XdRmYWEJ5E0B7k
         /YjbmZ4j/1sw2Lqo/4Own4D8FbVOeo8MU2ZpaoPhhZ93/D4ojNeagG9FmQuLKtAHKt5z
         OacwGswQqJ4wdonU5Zu+IeCTVsA0x4pY43C2hslW8c2hCpSGwG4EKoNYiBIfBh8rM2EH
         4iCg==
X-Gm-Message-State: AOAM531Rgnt4Of9bq6ky14z5qHQqgGk30jZrnhP84M1xnJYkvv2wv4RQ
        /M+uoImOguijDwZSpyCQE4bbxuknMnM=
X-Google-Smtp-Source: ABdhPJzUtRgc+Jd/2jc/exxNqqTlycN4lOWHmzx0rVlsWfSqutLFi8eZB+rKgYdNXTriMTpQ7wNRKQ==
X-Received: by 2002:a5d:6e01:: with SMTP id h1mr20973827wrz.403.1638541272046;
        Fri, 03 Dec 2021 06:21:12 -0800 (PST)
Received: from [192.168.8.198] ([148.252.132.146])
        by smtp.gmail.com with ESMTPSA id m20sm5790278wmq.11.2021.12.03.06.21.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Dec 2021 06:21:11 -0800 (PST)
Message-ID: <50cd05fb-243c-9b24-108f-15a1554ed7bc@gmail.com>
Date:   Fri, 3 Dec 2021 14:21:12 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH v6 0/6] task work optimization
Content-Language: en-US
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20211126100740.196550-1-haoxu@linux.alibaba.com>
 <e63b44a9-72ba-09fd-82d8-448fce356a9a@gmail.com>
 <a3515db3-2c22-fa32-746e-3210d84386e9@gmail.com>
 <8e22c1fa-faf0-4708-2101-86fd0d34ef86@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <8e22c1fa-faf0-4708-2101-86fd0d34ef86@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/3/21 07:30, Hao Xu wrote:
> 在 2021/12/3 上午10:01, Pavel Begunkov 写道:
>> On 12/3/21 01:39, Pavel Begunkov wrote:
>>> On 11/26/21 10:07, Hao Xu wrote:
>>>> v4->v5
>>>> - change the implementation of merge_wq_list
>>>>
[...]
>> But testing with liburing tests I'm getting the stuff below,
>> e.g. cq-overflow hits it every time. Double checked that
>> I took [RESEND] version of 6/6.
>>
>> [   30.360370] BUG: scheduling while atomic: cq-overflow/2082/0x00000000
>> [   30.360520] Call Trace:
>> [   30.360523]  <TASK>
>> [   30.360527]  dump_stack_lvl+0x4c/0x63
>> [   30.360536]  dump_stack+0x10/0x12
>> [   30.360540]  __schedule_bug.cold+0x50/0x5e
>> [   30.360545]  __schedule+0x754/0x900
>> [   30.360551]  ? __io_cqring_overflow_flush+0xb6/0x200
>> [   30.360558]  schedule+0x55/0xd0
>> [   30.360563]  schedule_timeout+0xf8/0x140
>> [   30.360567]  ? prepare_to_wait_exclusive+0x58/0xa0
>> [   30.360573]  __x64_sys_io_uring_enter+0x69c/0x8e0
>> [   30.360578]  ? io_rsrc_buf_put+0x30/0x30
>> [   30.360582]  do_syscall_64+0x3b/0x80
>> [   30.360588]  entry_SYSCALL_64_after_hwframe+0x44/0xae
>> [   30.360592] RIP: 0033:0x7f9f9680118d
>> [   30.360618]  </TASK>
>> [   30.362295] BUG: scheduling while atomic: cq-overflow/2082/0x7ffffffe
>> [   30.362396] Call Trace:
>> [   30.362397]  <TASK>
>> [   30.362399]  dump_stack_lvl+0x4c/0x63
>> [   30.362406]  dump_stack+0x10/0x12
>> [   30.362409]  __schedule_bug.cold+0x50/0x5e
>> [   30.362413]  __schedule+0x754/0x900
>> [   30.362419]  schedule+0x55/0xd0
>> [   30.362423]  schedule_timeout+0xf8/0x140
>> [   30.362427]  ? prepare_to_wait_exclusive+0x58/0xa0
>> [   30.362431]  __x64_sys_io_uring_enter+0x69c/0x8e0
>> [   30.362437]  ? io_rsrc_buf_put+0x30/0x30
>> [   30.362440]  do_syscall_64+0x3b/0x80
>> [   30.362445]  entry_SYSCALL_64_after_hwframe+0x44/0xae
>> [   30.362449] RIP: 0033:0x7f9f9680118d
>> [   30.362470]  </TASK>
>> <repeated>
>>
> cannot repro this, all the liburing tests work well on my side..

One problem is when on the first iteration tctx_task_work doen't
have anything in prior_task_list, it goes to handle_tw_list(),
which sets up @ctx but leaves @locked=false (say there is
contention). And then on the second iteration it goes to
handle_prior_tw_list() with non-NULL @ctx and @locked=false,
and tries to unlock not locked spin.

Not sure that's the exactly the problem from traces, but at
least a quick hack resetting the ctx at the beginning of
handle_prior_tw_list() heals it.

note: apart from the quick fix the diff below includes
a couple of lines to force it to go through the new path.


diff --git a/fs/io_uring.c b/fs/io_uring.c
index 66d119ac4424..3868123eef87 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2272,6 +2272,9 @@ static inline void ctx_commit_and_unlock(struct io_ring_ctx *ctx)
  static void handle_prior_tw_list(struct io_wq_work_node *node, struct io_ring_ctx **ctx,
                                  bool *locked)
  {
+       ctx_flush_and_put(*ctx, locked);
+       *ctx = NULL;
+
         do {
                 struct io_wq_work_node *next = node->next;
                 struct io_kiocb *req = container_of(node, struct io_kiocb,
@@ -2283,7 +2286,8 @@ static void handle_prior_tw_list(struct io_wq_work_node *node, struct io_ring_ct
                         ctx_flush_and_put(*ctx, locked);
                         *ctx = req->ctx;
                         /* if not contended, grab and improve batching */
-                       *locked = mutex_trylock(&(*ctx)->uring_lock);
+                       *locked = false;
+                       // *locked = mutex_trylock(&(*ctx)->uring_lock);
                         percpu_ref_get(&(*ctx)->refs);
                         if (unlikely(!*locked))
                                 spin_lock(&(*ctx)->completion_lock);
@@ -2840,7 +2844,7 @@ static void io_complete_rw(struct kiocb *kiocb, long res)
                 return;
         req->result = res;
         req->io_task_work.func = io_req_task_complete;
-       io_req_task_work_add(req, !!(req->ctx->flags & IORING_SETUP_SQPOLL));
+       io_req_task_work_add(req, true);
  }



-- 
Pavel Begunkov
