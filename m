Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C530345696
	for <lists+io-uring@lfdr.de>; Tue, 23 Mar 2021 05:11:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229464AbhCWEKa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 23 Mar 2021 00:10:30 -0400
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:38438 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229500AbhCWEKC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 23 Mar 2021 00:10:02 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=alimailimapcm10staff010182156082;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0UT1nzlU_1616472598;
Received: from B-D1K7ML85-0059.local(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0UT1nzlU_1616472598)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 23 Mar 2021 12:09:59 +0800
Subject: Re: [ANNOUNCEMENT] io_uring SQPOLL sharing changes
To:     Jens Axboe <axboe@kernel.dk>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>,
        Hao Xu <haoxu@linux.alibaba.com>
References: <ca41ede6-7040-5eac-f4f0-9467427b1589@gmail.com>
 <30563957-709a-73a2-7d54-58419089d61a@linux.alibaba.com>
 <1afd5237-4363-9178-917e-3132ba1b89c3@kernel.dk>
From:   Joseph Qi <joseph.qi@linux.alibaba.com>
Message-ID: <293e88d8-7fa5-edf4-226c-1e42dec9af67@linux.alibaba.com>
Date:   Tue, 23 Mar 2021 12:09:58 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <1afd5237-4363-9178-917e-3132ba1b89c3@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 3/22/21 10:49 PM, Jens Axboe wrote:
> On 3/21/21 11:54 PM, Xiaoguang Wang wrote:
>> hi Pavel,
>>
>>> Hey,
>>>
>>> You may have already noticed, but there will be a change how SQPOLL
>>> is shared in 5.12. In particular, SQPOLL may be shared only by processes
>>> belonging to the same thread group. If this condition is not fulfilled,
>>> then it silently creates a new SQPOLL task.
>>
>> Thanks for your kindly reminder, currently we only share sqpoll thread
>> in threads belonging to one same process.
> 
> That's good to know, imho it is also the only thing that _really_ makes
> sense to do.
> 
> Since we're on the topic, are you actively using the percpu thread setup
> that you sent out patches for earlier? That could still work within
> the new scheme of having io threads, but I'd be curious to know first
> if you guys are actually using it.
> 

Yes, we've already used percpu sqthread feature in our production
environment, in which 16 application threads share the same sqthread,
and it gains ~20% rt improvement compared with libaio.

Thanks,
Joseph
