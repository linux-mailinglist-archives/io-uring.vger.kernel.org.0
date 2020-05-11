Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A2B41CD150
	for <lists+io-uring@lfdr.de>; Mon, 11 May 2020 07:43:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726013AbgEKFnD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 11 May 2020 01:43:03 -0400
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:39503 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725916AbgEKFnD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 11 May 2020 01:43:03 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e07488;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0Ty8ajSG_1589175780;
Received: from 30.225.32.143(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0Ty8ajSG_1589175780)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 11 May 2020 13:43:00 +0800
Subject: Re: Is io_uring framework becoming bloated gradually? and introduces
 performace regression
To:     "H. de Vries" <hdevries@fastmail.com>,
        Jens Axboe <axboe@kernel.dk>,
        io-uring <io-uring@vger.kernel.org>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        joseph qi <joseph.qi@linux.alibaba.com>,
        Jiufei Xue <jiufei.xue@linux.alibaba.com>
References: <6132351e-75e6-9d4d-781b-d6a183d87846@linux.alibaba.com>
 <5828e2de-5976-20ae-e920-bf185c0bc52d@kernel.dk>
 <3d667681-cdc8-4ac2-854d-ebe882b02da3@www.fastmail.com>
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Message-ID: <e0459427-1ad3-2995-87cb-33ed58c2e5ee@linux.alibaba.com>
Date:   Mon, 11 May 2020 13:43:00 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <3d667681-cdc8-4ac2-854d-ebe882b02da3@www.fastmail.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

hi,

> Hi Xiaoguang,
> 
> Why exactly you don't get the performance [1] is referring to could have many reasons. 
Yes, I think so, and I'll keep looking into it.

> It seems your nop test code quite different from the echo server that is used for [1]. [1] employs and event loop (single thread) specifically for networking. It saves an expensive call to epoll in each iteration of the loop. 
This nop testcase is just writtent to evaluate io_uring framework.
I have added codes to count the number of syscalls in io_uring_echo_server.c and
io_uring really reduces syscalls tremendously, so that's my question that why I still
don't see the obvious improvements though io_uring reduces many syscalls, then I wrote
the mail to discuss io_uring framework's self overhead :)

> I glanced at your test program, what is the performance difference with IOSQE_ASYNC vs without IOSQE_ASYNC?
If IOSQE_ASYNC is flagged, io_uring will complete nop operations in io_uring
internal thread pool, so it'll be a bit slower.

> 
> [1]: https://github.com/frevib/io_uring-echo-server/blob/io-uring-feat-fast-poll/benchmarks/benchmarks.md.
Do you have free time to have a test in newest kernel upstream in your test environment?
Or do you still remember the head kernel commit you tested?

And in your io-uring-feat-fast-poll branch, you use:
// tell kernel we have put a sqe on the submission ring
    io_uring_submit(&ring);

    // wait for new cqe to become available
    ret = io_uring_wait_cqe(&ring, &cqe);
    if (ret != 0)
    {
         perror("Error io_uring_wait_cqe\n");
         exit(1);
     }

Indeed you can use:
ret = io_uring_submit_and_wait(&ring, 1);
if (ret < 0) {
     perror("Error io_uring_wait_cqe\n");
     exit(1);
}
then we can reduce syscall more.

Regards,
Xiaoguang Wang

> 
> --
> Hielke de Vries
> 
> 
> On Fri, May 8, 2020, at 18:37, Jens Axboe wrote:
>> On 5/8/20 9:18 AM, Xiaoguang Wang wrote:
>>> hi,
>>>
>>> This issue was found when I tested IORING_FEAT_FAST_POLL feature, with
>>> the newest upstream codes, indeed I find that io_uring's performace
>>> improvement is not obvious compared to epoll in my test environment,
>>> most of the time they are similar.  Test cases basically comes from:
>>> https://github.com/frevib/io_uring-echo-server/blob/io-uring-feat-fast-poll/benchmarks/benchmarks.md.
>>> In above url, the author's test results shows that io_uring will get a
>>> big performace improvement compared to epoll. I'm still looking into
>>> why I don't get the big improvement, currently don't know why, but I
>>> find some obvious regression issue.
>>>
>>> I wrote a simple tool based io_uring nop operation to evaluate
>>> io_uring framework in v5.1 and 5.7.0-rc4+(jens's io_uring-5.7 branch),
>>> I see a obvious performace regression:
>>>
>>> v5.1 kernel:
>>>       $sudo taskset -c 60 ./io_uring_nop_stress -r 300 # run 300 seconds
>>>       total ios: 1832524960
>>>       IOPS:      6108416
>>> 5.7.0-rc4+
>>>       $sudo taskset -c 60 ./io_uring_nop_stress -r 300
>>>       total ios: 1597672304
>>>       IOPS:      5325574
>>> it's about 12% performance regression.
>>
>> For sure there's a bit more bloat in 5.7+ compared to the initial slim
>> version, and focus has been on features to a certain extent recently.
>> The poll rework for 5.7 will really improve performance for the
>> networked side though, so it's not like it's just piling on features
>> that add bloat.
>>
>> That said, I do think it's time for a revisit on overhead. It's been a
>> while since I've done my disk IO testing. The nop testing isn't _that_
>> interesting by itself, as a micro benchmark it does yield some results
>> though. Are you running on bare metal or in a VM?
>>
>>> Using perf can see many performance bottlenecks, for example,
>>> io_submit_sqes is one.  For now, I did't make many analysis yet, just
>>> have a look at io_submit_sqes(), there are many assignment operations
>>> in io_init_req(), but I'm not sure whether they are all needed when
>>> req is not needed to be punt to io-wq, for example,
>>> INIT_IO_WORK(&req->work, io_wq_submit_work); # a whole struct
>>> assignment from perf annotate tool, it's an expensive operation, I
>>> think reqs that use fast poll feature use task-work function, so the
>>> INIT_IO_WORK maybe not necessary.
>>
>> I'm sure there's some low hanging fruit there, and I'd love to take
>> patches for it.
>>
>>> Above is just one issue, what I worry is that whether io_uring is
>>> becoming more bloated gradually, and will not that better to aio. In
>>> https://kernel.dk/io_uring.pdf, it says that io_uring will eliminate
>>> 104 bytes copy compared to aio, but see currenct io_init_req(),
>>> io_uring maybe copy more, introducing more overhead? Or does we need
>>> to carefully re-design struct io_kiocb, to reduce overhead as soon as
>>> possible.
>>
>> The copy refers to the data structures coming in and out, both io_uring
>> and io_uring inititalize their main io_kiocb/aio_kiocb structure as
>> well. The io_uring is slightly bigger, but not much, and it's the same
>> number of cachelines. So should not be a huge difference there. The
>> copying on the aio side is basically first the pointer copy, then the
>> user side kiocb structure. io_uring doesn't need to do that. The
>> completion side is also slimmer. We also don't need as many system calls
>> to do the same thing, for example.
>>
>> So no, we should always been substantially slimmer than aio, just by the
>> very nature of the API.
>>
>> One major thing I've been thinking about for io_uring is io_kiocb
>> recycling. We're hitting the memory allocator for alloc+free for each
>> request, even though that can be somewhat amortized by doing batched
>> submissions, and polling for instance can also do batched frees. But I'm
>> pretty sure we can find some gains here by having some io_kiocb caching
>> that is persistent across operations.
>>
>> Outside of that, runtime analysis and speeding up the normal path
>> through io_uring will probably also easily yield us an extra 5% (or
>> more).
>>
>> -- 
>> Jens Axboe
>>
>>
