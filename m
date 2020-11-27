Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47F2D2C5ED8
	for <lists+io-uring@lfdr.de>; Fri, 27 Nov 2020 04:04:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392274AbgK0DDP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 26 Nov 2020 22:03:15 -0500
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:35240 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388638AbgK0DDP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 26 Nov 2020 22:03:15 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0UGeZIF-_1606446192;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UGeZIF-_1606446192)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 27 Nov 2020 11:03:12 +0800
Subject: Re: [PATCH] test/timeout-new: test for timeout feature
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <1606115273-164396-1-git-send-email-haoxu@linux.alibaba.com>
 <2562fb6f-fb84-07d7-39dc-597683773e12@kernel.dk>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <0a935061-c9b8-6c6f-7c38-ad99ebe341e7@linux.alibaba.com>
Date:   Fri, 27 Nov 2020 11:03:12 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <2562fb6f-fb84-07d7-39dc-597683773e12@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2020/11/27 上午1:39, Jens Axboe 写道:
> On 11/23/20 12:07 AM, Hao Xu wrote:
>> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
>> ---
>>
>> Hi Jens,
>> This is a simple test for the new getevent timeout feature. Sorry for
>> the delay.
> 
> We need a lot more in this test case, to be honest. Maybe test that
> it returns around 1 second? Test that if we have an event it doesn't
> wait, etc. This is as bare bones as it gets, a test case for a new
> addition/change really should test all the interesting cases around
> it.
> 
Agree, I'll consider more on this.
