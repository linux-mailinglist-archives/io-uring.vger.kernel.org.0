Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D86253C7D1B
	for <lists+io-uring@lfdr.de>; Wed, 14 Jul 2021 05:50:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237725AbhGNDxJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 13 Jul 2021 23:53:09 -0400
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:37557 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237655AbhGNDxJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 13 Jul 2021 23:53:09 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0Ufk6rVH_1626234615;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0Ufk6rVH_1626234615)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 14 Jul 2021 11:50:16 +0800
Subject: Re: Question about sendfile
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
References: <6a7ceb04-3503-7300-8089-86c106a95e96@linux.alibaba.com>
 <4831bcfd-ce4a-c386-c5b2-a1417a23c500@gmail.com>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <a76a623f-4ece-1ffe-9e1b-370022b35105@linux.alibaba.com>
Date:   Wed, 14 Jul 2021 11:50:15 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <4831bcfd-ce4a-c386-c5b2-a1417a23c500@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/7/7 下午10:16, Pavel Begunkov 写道:
> On 7/3/21 11:47 AM, Hao Xu wrote:
>> Hi Pavel,
>> I found this mail about sendfile in the maillist, may I ask why it's not
>> good to have one pipe each for a io-wq thread.
>> https://lore.kernel.org/io-uring/94dbbb15-4751-d03c-01fd-d25a0fe98e25@gmail.com/
> 
> IIRC, it's one page allocated for each such task, which is bearable but
> don't like yet another chunk of uncontrollable implicit state. If there
> not a bunch of active workers, IFAIK there is no way to force them to
> drop their pipes.
> 
> I also don't remember the restrictions on the sendfile and what's with
> the eternal question of "what to do if the write part of sendfile has
> failed".
I haven't dig into it deeply, will do some investigation.
> 
> Though, workers are now much more alike to user threads, so there
> should be less of concern. And even though my gut feeling don't like
> them, it may actually be useful. Do you have a good use case where
> explicit pipes don't work well?
The thing is two linked splice sqes may be cut off in shared sqthread
case.
> 

