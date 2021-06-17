Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99CE93ABB33
	for <lists+io-uring@lfdr.de>; Thu, 17 Jun 2021 20:11:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232339AbhFQSNN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 17 Jun 2021 14:13:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232317AbhFQSNL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 17 Jun 2021 14:13:11 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50761C061574;
        Thu, 17 Jun 2021 11:11:02 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id j18so3843708wms.3;
        Thu, 17 Jun 2021 11:11:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:subject:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=FoKuKYc+BPPyd7lTl1f3+SqZVhtdYo1VgkqZGafgdiI=;
        b=P+/fjNVxFhnnnB5YkN5YIZuNWCXnUNUkhK5qMJLHoghGJPVIIZYvoD07iP0wYTHFOP
         C8gxzRUpkHjyvbGmpMWBNBo2OYAPYoPPCxfhUXvtA2HsL+zWNP+JZ0soirQzTIE3iNoh
         SEqUX6Ejx3mrP9nKGg+mmU0y4/D7IQfPpk7CuYsGgsLCurZyphrREoeiUW9isyYhV0lB
         DbVKV+gNWc8D1byP090Ae+GtISh/3yzUJC6e1gvMMBqsGLT5BnmM3V61aDrtdwteJK0g
         ptwqz/66F8PC6Kw1Z04NBJ9XLHi3ZGI3LDtJMYvpx4i2zHegJrEnKU0kzCeL9I+Ui999
         CG+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FoKuKYc+BPPyd7lTl1f3+SqZVhtdYo1VgkqZGafgdiI=;
        b=qp0EJGWLRhTSDRUgeHIJumqiBhUU2CM83C9KJi7agaF3A/u2PuPRNn4aLE8N6Q/7fp
         LBjMXMxFXrKgbYTntn09DhI+t7z/41ejg8FmOwDjBh/C0z2K+OMVWK8nrcxtcpA574Wf
         c73IpJkobABEcEEvGrlXT4xmCv1Yvn7oy5ERCq7hkpbbUAfteIvN8LckOrv+/ghSWCYd
         dXsElR/rujNdqSrcUPCsm2YlkXrMnfq1GKt5zaQKTRkXa5xfQnf5qoHmF1M53n1iyFwb
         7zKIHeaZsW7ckz/8QkiG/V7G2HCHjydx1gWigKZT47UE3s7sIrVdgcadmN0pmBYeQEK1
         7FwQ==
X-Gm-Message-State: AOAM531nDFrU8krzZ5RJpy90vxqIeah9wTYHLxZu01N8Z/avs4Brv4yN
        nlbtDRxXXlU3qpOghNOCkUUJ6U1O0M/z2g==
X-Google-Smtp-Source: ABdhPJzdAgxvU5FHUnM0wjs50H8yVV7R7C+dhD5svkG101dp2hWpRhQ7Z/JpEFxBELrtr+2trWt9gw==
X-Received: by 2002:a1c:cc02:: with SMTP id h2mr6580293wmb.39.1623953460318;
        Thu, 17 Jun 2021 11:11:00 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.132.93])
        by smtp.gmail.com with ESMTPSA id m7sm6798429wrv.35.2021.06.17.11.10.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Jun 2021 11:10:59 -0700 (PDT)
To:     Olivier Langlois <olivier@trillion01.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <60c13bec.1c69fb81.73967.f06dSMTPIN_ADDED_MISSING@mx.google.com>
 <84e42313-d738-fb19-c398-08a4ed0e0d9c@gmail.com>
 <4b5644bff43e072a98a19d7a5ca36bb5e11497ec.camel@trillion01.com>
 <a7d6f2fd-b59e-e6fa-475a-23962d45b6fa@gmail.com>
 <9938f22a0bb09f344fa5c9c5c1b91f0d12e7566f.camel@trillion01.com>
 <a12e218a-518d-1dac-5e8c-d9784c9850b0@gmail.com>
 <b0a8c92cffb3dc1b48b081e5e19b016fee4c6511.camel@trillion01.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH] io_uring: reduce latency by reissueing the operation
Message-ID: <7d9a481b-ae8c-873e-5c61-ab0a57243905@gmail.com>
Date:   Thu, 17 Jun 2021 19:10:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <b0a8c92cffb3dc1b48b081e5e19b016fee4c6511.camel@trillion01.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/11/21 4:55 AM, Olivier Langlois wrote:
> On Thu, 2021-06-10 at 20:32 +0100, Pavel Begunkov wrote:
>> On 6/10/21 6:56 PM, Olivier Langlois wrote:
>>>
>>>
>>> Can you think of other numbers that would be useful to know to
>>> evaluate
>>> the patch performance?
>>
>> If throughput + latency (avg + several nines) are better (or any
>> other measurable improvement), it's a good enough argument to me,
>> but not sure what test case you're looking at. Single threaded?
>> Does it saturate your CPU?
>>
> I don't know what are the ideal answers to your 2 last questions ;-)
> 
> I have several possible configurations to my application.
> 
> The most complex one is a 2 threads setup each having their own
> io_uring instance where one of the threads is managing 50-85 TCP
> connections over which JSON stream encapsulated in the WebSocket
> protocol are received.
> 
> That more complex setup is also using IORING_SETUP_ATTACH_WQ to share
> the sqpoll thread between the 2 instances.
> 
> In that more complex config, the sqpoll thread is running at 85-95% of
> its dedicated CPU.
> 
> For the patch performance testing I did use the simplest config:
> Single thread, 1 TCP connection, no sqpoll.

Queue depth (QD) 1, right?

> To process an incoming 5Mbps stream, it takes about 5% of the CPU.

I see, under utilised, and so your main concern is latency
here. 

> 
> Here is the testing methodology:
> add 2 fields in  struct io_rw:
>     u64             startTs;
>     u8              readType;
> 
> startTs is set with ktime_get_raw_fast_ns() in io_read_prep()
> 
> readType is set to:
> 0: data ready
> 1: use fast poll (we ignore those)
> 2: reissue
> 3: async
> 
> readType is used to know what type of measurement it is at the
> recording point.
> 
> end time is measured at 3 recording point:
> 1. In __io_queue_sqe() when io_issue_sqe() returns 0
> 2. In __io_queue_sqe() after io_queue_async_work() call
> 3. In io_wq_submit_work() after the while loop.
> 
> So I took 4 measurements.
> 
> 1. The time it takes to process a read request when data is already
> available
> 2. The time it takes to process by calling twice io_issue_sqe() after
> vfs_poll() indicated that data was available
> 3. The time it takes to execute io_queue_async_work()
> 4. The time it takes to complete a read request asynchronously
> 
> Before presenting the results, I want to mention that 2.25% of the
> total number of my read requests ends up in the situation where the
> read() syscall did return EAGAIN but data became available by the time
> vfs_poll gets called.
> 
> My expectations were that reissuing a sqe could be on par or a bit more
> expensive than placing it on io-wq for async processing and that would
> put the patch in some gray zone with pros and cons in terms of
> performance.
> 
> The reality is instead super nice (numbers in nSec):
> 
> ready data (baseline)
> avg	3657.94182918628
> min	580
> max	20098
> stddev	1213.15975908162
> 	
> reissue	completion
> average	7882.67567567568
> min	2316
> max	28811
> stddev	1982.79172973284
> 	
> insert io-wq time	
> average	8983.82276995305
> min	3324
> max	87816
> stddev	2551.60056552038
> 	
> async time completion
> average	24670.4758861127
> min	10758
> max	102612
> stddev	3483.92416873804
> 
> Conclusion:
> On average reissuing the sqe with the patch code is 1.1uSec faster and
> in the worse case scenario 59uSec faster than placing the request on
> io-wq
> 
> On average completion time by reissuing the sqe with the patch code is
> 16.79uSec faster and in the worse case scenario 73.8uSec faster than
> async completion.

Hah, you took it fundamentally. I'm trying to get it, correct me
I am mistaken.

1) it's avg completion for those 2.5%, not for all requests

2) Do they return equivalent number of bytes? And what the
read/recv size (e.g. buffer size)?

Because in theory can be that during a somewhat small delay for
punting to io-wq, more data had arrived and so async completion
pulls more data that takes more time. In that case the time
difference should also account the difference in amount of
data that it reads. 

3) Curious, why read but not recv as you're working with sockets

4) Did you do any userspace measurements. And a question to
everyone in general, do we have any good net benchmarking tool
that works with io_uring? Like netperf? Hopefully spitting
out latency distribution.


Also, not particularly about reissue stuff, but a note to myself:
59us is much, so I wonder where the overhead comes from.
Definitely not the iowq queueing (i.e. putting into a list).
- waking a worker?
- creating a new worker? Do we manage workers sanely? e.g.
  don't keep them constantly recreated and dying back.
- scheduling a worker?

Olivier, for how long did you run the test? >1 min?


> One important detail to mention about the async completion time, in the
> testing the ONLY way that a request can end up being completed async is
> if vfs_poll() reports that the file is ready. Otherwise, the request
> ends up being processed with io_uring fast poll feature.
> 
> So there does not seem to have any downside to the patch. TBH, at the
> initial patch submission, I only did use my intuition to evaluate the
> merit of my patch but, thx to your healthy skepticism, Pavel, this did
> force me to actually measure the patch and it appears to incontestably
> improve performance for both the reissued SQE and also all the other
> sqes found in a batch submission.

Interesting what would be a difference if done through
io_req_task_work_add(), and what would be a percent of such reqs
for a hi-QD workload.

But regardless, don't expect any harm, so sounds good to me.
Agree with Jens' comment about return value. I think it will
go in quickly once resubmitted with the adjustment.


> Hopefully, the results will please you as much as they have for me!

-- 
Pavel Begunkov
