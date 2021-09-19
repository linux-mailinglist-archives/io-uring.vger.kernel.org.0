Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 886E8410C55
	for <lists+io-uring@lfdr.de>; Sun, 19 Sep 2021 18:10:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231255AbhISQLn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 19 Sep 2021 12:11:43 -0400
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:36465 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229933AbhISQLm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 19 Sep 2021 12:11:42 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0Uot2qWO_1632067814;
Received: from 192.168.31.215(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0Uot2qWO_1632067814)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 20 Sep 2021 00:10:15 +0800
Subject: Re: [PATCH 5/5] io_uring: leverage completion cache for poll requests
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210917193820.224671-1-haoxu@linux.alibaba.com>
 <20210917193820.224671-6-haoxu@linux.alibaba.com>
 <fe379c0c-0eeb-6412-ffd7-69be2746745f@gmail.com>
 <2ab8efb5-7927-cf1a-a1af-f4955f7d94f6@linux.alibaba.com>
 <166dc3e2-6eea-8354-ef12-07df49ec5aaf@gmail.com>
 <80237936-9a85-fd65-2b36-724d6caa279d@linux.alibaba.com>
Message-ID: <3b49c202-9dc9-10f9-08db-f524f894b46b@linux.alibaba.com>
Date:   Mon, 20 Sep 2021 00:10:14 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <80237936-9a85-fd65-2b36-724d6caa279d@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/9/19 下午11:52, Hao Xu 写道:
> 在 2021/9/19 下午8:04, Pavel Begunkov 写道:
>> On 9/18/21 7:11 AM, Hao Xu wrote:
>>> 在 2021/9/18 上午4:39, Pavel Begunkov 写道:
>>>> On 9/17/21 8:38 PM, Hao Xu wrote:
>>>>> Leverage completion cache to handle completions of poll requests in a
>>>>> batch.
>>>>> Good thing is we save compl_nr - 1 completion_lock and
>>>>> io_cqring_ev_posted.
>>>>> Bad thing is compl_nr extra ifs in flush_completion.
>>>>
>>>> It does something really wrong breaking all abstractions, we can't go
>>>> with this. Can we have one of those below?
>>>> - __io_req_complete(issue_flags), forwarding issue_flags from above
>>>> - or maybe io_req_task_complete(), if we're in tw
>>> Make sense. we may need to remove io_clean_op logic in
>>
>>> io_req_complete_state(), multishot reqs shouldn't do it, and it's ok for
>>> normal reqs since we do it later in __io_submit_flush_completions->
>>> io_req_free_batch->io_dismantle_req->io_clean_op, correct me if I'm
>>> wrong.
>>
>> req->compl.cflags is in the first 64B, i.e. aliased with req->rw and
>> others. We need to clean everything left in there before using the
>> space, that's what io_clean_op() there is for
> True, and that's why we souldn't do it for multishot reqs, since they
> are not completed yet, and we won't reuse the req resource until its
> final completion.
I see what you are saying now..yes, we shouldn't remove that
io_clean_op there.
>>

