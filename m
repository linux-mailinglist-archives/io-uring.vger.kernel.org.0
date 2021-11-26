Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A810045E9A4
	for <lists+io-uring@lfdr.de>; Fri, 26 Nov 2021 09:52:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345536AbhKZIzs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 26 Nov 2021 03:55:48 -0500
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:55700 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1353511AbhKZIxr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 26 Nov 2021 03:53:47 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UyLw5Vf_1637916631;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UyLw5Vf_1637916631)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 26 Nov 2021 16:50:32 +0800
Subject: Re: Question about sendfile
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
References: <6a7ceb04-3503-7300-8089-86c106a95e96@linux.alibaba.com>
 <4831bcfd-ce4a-c386-c5b2-a1417a23c500@gmail.com>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <1414c8f9-e454-fb5a-7e44-cead5bbd61ea@linux.alibaba.com>
Date:   Fri, 26 Nov 2021 16:50:31 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
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
Hi Pavel,
Could you explain this question a little bit.., is there any special
concern? What I thought is sendfile does what it does,when it fails,
it will return -1 and errno is set appropriately.
> 
> Though, workers are now much more alike to user threads, so there
> should be less of concern. And even though my gut feeling don't like
> them, it may actually be useful. Do you have a good use case where
> explicit pipes don't work well?
> 

