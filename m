Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9628204CC2
	for <lists+io-uring@lfdr.de>; Tue, 23 Jun 2020 10:42:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731827AbgFWIm7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 23 Jun 2020 04:42:59 -0400
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:58600 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731786AbgFWIm6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 23 Jun 2020 04:42:58 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R931e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0U0UUDI._1592901775;
Received: from fengidri.local(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0U0UUDI._1592901775)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 23 Jun 2020 16:42:56 +0800
Subject: Re: [RFC] io_commit_cqring __io_cqring_fill_event take up too much
 cpu
To:     Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
Cc:     Dust.li@linux.alibaba.com
References: <20200622132910.GA99461@e02h04398.eu6sqa>
 <bb4b567f-4337-6c9d-62aa-fa62db2882f3@kernel.dk>
 <c0859031-f4df-8c38-d5e1-aba8f82a9f98@kernel.dk>
From:   xuanzhuo <xuanzhuo@linux.alibaba.com>
Message-ID: <79751016-112a-7f9b-0cd9-d114ae88b2cb@linux.alibaba.com>
Date:   Tue, 23 Jun 2020 16:42:55 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <c0859031-f4df-8c38-d5e1-aba8f82a9f98@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 2020/6/23 上午1:11, Jens Axboe wrote:
> On 6/22/20 8:50 AM, Jens Axboe wrote:
>> On 6/22/20 7:29 AM, Xuan Zhuo wrote:
>>> Hi Jens,
>>> I found a problem, and I think it is necessary to solve it. But the change
>>> may be relatively large, so I would like to ask you and everyone for your
>>> opinions. Or everyone has other ideas about this issue:
>>>
>>> Problem description:
>>> ===================
>>> I found that in the sq thread mode, the CPU used by io_commit_cqring and
>>> __io_cqring_fill_event accounts for a relatively large amount. The reason is
>>> because a large number of calls to smp_store_release and WRITE_ONCE.
>>> These two functions are relatively slow, and we need to call smp_store_release
>>> every time we submit a cqe. This large number of calls has caused this
>>> problem to become very prominent.
>>>
>>> My test environment is in qemu, using io_uring to accept a large number of
>>> udp packets in sq thread mode, the speed is 800000pps. I submitted 100 sqes
>>> to recv udp packet at the beginning of the application, and every time I
>>> received a cqe, I submitted another sqe. The perf top result of sq thread is
>>> as follows:
>>>
>>>
>>>
>>> 17.97% [kernel] [k] copy_user_generic_unrolled
>>> 13.92% [kernel] [k] io_commit_cqring
>>> 11.04% [kernel] [k] __io_cqring_fill_event
>>> 10.33% [kernel] [k] udp_recvmsg
>>>    5.94% [kernel] [k] skb_release_data
>>>    4.31% [kernel] [k] udp_rmem_release
>>>    2.68% [kernel] [k] __check_object_size
>>>    2.24% [kernel] [k] __slab_free
>>>    2.22% [kernel] [k] _raw_spin_lock_bh
>>>    2.21% [kernel] [k] kmem_cache_free
>>>    2.13% [kernel] [k] free_pcppages_bulk
>>>    1.83% [kernel] [k] io_submit_sqes
>>>    1.38% [kernel] [k] page_frag_free
>>>    1.31% [kernel] [k] inet_recvmsg
>>>
>>>
>>>
>>> It can be seen that io_commit_cqring and __io_cqring_fill_event account
>>> for 24.96%. This is too much. In general, the proportion of syscall may not
>>> be so high, so we must solve this problem.
>>>
>>>
>>> Solution:
>>> =================
>>> I consider that when the nr of an io_submit_sqes is too large, we don't call
>>> io_cqring_add_event directly, we can put the completed req in the queue, and
>>> then call __io_cqring_fill_event for each req then call once io_commit_cqring
>>> at the end of the io_submit_sqes function. In this way my local simple test
>>> looks good.
>> I think the solution here is to defer the cq ring filling + commit to the
>> caller instead of deep down the stack, I think that's a nice win in general.
>> To do that, we need to be able to do it after io_submit_sqes() has been
>> called. We can either do that inline, by passing down a list or struct
>> that allows the caller to place the request there instead of filling
>> the event, or out-of-band by having eg a percpu struct that allows the
>> same thing. In both cases, the actual call site would do something ala:
>>
>> if (comp_list && successful_completion) {
>> 	req->result = ret;
>> 	list_add_tail(&req->list, comp_list);
>> } else {
>> 	io_cqring_add_event(req, ret);
>> 	if (!successful_completion)
>> 		req_set_fail_links(req);
>> 	io_put_req(req);
>> }
>>
>> and then have the caller iterate the list and fill completions, if it's
>> non-empty on return.
>>
>> I don't think this is necessarily hard, but to do it nicely it will
>> touch a bunch code and hence be quite a bit of churn. I do think the
>> reward is worth it though, as this applies to the "normal" submission
>> path as well, not just the SQPOLL variant.
> Something like this series. I'd be interested to hear if it makes your
> specific test case any better.
>
> Patches are against my for-5.9/io_uring branch.
>
I applied your patches on for-5.9/io_uring and performed the same test.
The data of io_sq_thread perf top is as follows:


    19.99% [kernel] [k] copy_user_generic_unrolled
    11.63% [kernel] [k] skb_release_data
     9.36% [kernel] [k] udp_rmem_release
     8.64% [kernel] [k] udp_recvmsg
     6.21% [kernel] [k] __slab_free
     4.39% [kernel] [k] __check_object_size
     3.64% [kernel] [k] free_pcppages_bulk
     2.41% [kernel] [k] kmem_cache_free
     2.00% [kernel] [k] io_submit_sqes
     1.95% [kernel] [k] page_frag_free
     1.54% [kernel] [k] io_put_req

     ...

     0.07% [kernel] [k] io_commit_cqring
     0.44% [kernel] [k] __io_cqring_fill_event


The ratio of io_commit_cqring and __io_cqring_fill_event has been
significantly reduced.

Due to the kernel of this version, setting the irq smb_affinity of the 
network card
has no effect, so the lock competition of udp receiving packets is 
relatively large,
which may be a bug. This leads to a large fluctuation in throughput, so 
I not provide
UDP packet receiving bandwidth.

Well done.
