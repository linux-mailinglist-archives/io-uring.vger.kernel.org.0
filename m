Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3D8C3AD55D
	for <lists+io-uring@lfdr.de>; Sat, 19 Jun 2021 00:45:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234252AbhFRWru (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 18 Jun 2021 18:47:50 -0400
Received: from cloud48395.mywhc.ca ([173.209.37.211]:43936 "EHLO
        cloud48395.mywhc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233160AbhFRWru (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 18 Jun 2021 18:47:50 -0400
Received: from modemcable064.203-130-66.mc.videotron.ca ([66.130.203.64]:33090 helo=[192.168.1.179])
        by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <olivier@trillion01.com>)
        id 1luNF5-0005uC-MD; Fri, 18 Jun 2021 18:45:39 -0400
Message-ID: <f511d34b1a1ae5f76c9c4ba1ab87bbf15046a588.camel@trillion01.com>
Subject: Re: [PATCH] io_uring: reduce latency by reissueing the operation
From:   Olivier Langlois <olivier@trillion01.com>
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Fri, 18 Jun 2021 18:45:39 -0400
In-Reply-To: <7d9a481b-ae8c-873e-5c61-ab0a57243905@gmail.com>
References: <60c13bec.1c69fb81.73967.f06dSMTPIN_ADDED_MISSING@mx.google.com>
         <84e42313-d738-fb19-c398-08a4ed0e0d9c@gmail.com>
         <4b5644bff43e072a98a19d7a5ca36bb5e11497ec.camel@trillion01.com>
         <a7d6f2fd-b59e-e6fa-475a-23962d45b6fa@gmail.com>
         <9938f22a0bb09f344fa5c9c5c1b91f0d12e7566f.camel@trillion01.com>
         <a12e218a-518d-1dac-5e8c-d9784c9850b0@gmail.com>
         <b0a8c92cffb3dc1b48b081e5e19b016fee4c6511.camel@trillion01.com>
         <7d9a481b-ae8c-873e-5c61-ab0a57243905@gmail.com>
Organization: Trillion01 Inc
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.40.2 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cloud48395.mywhc.ca
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - trillion01.com
X-Get-Message-Sender-Via: cloud48395.mywhc.ca: authenticated_id: olivier@trillion01.com
X-Authenticated-Sender: cloud48395.mywhc.ca: olivier@trillion01.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, 2021-06-17 at 19:10 +0100, Pavel Begunkov wrote:
> > 
> > For the patch performance testing I did use the simplest config:
> > Single thread, 1 TCP connection, no sqpoll.
> 
> Queue depth (QD) 1, right?

Since my io_uring usage is wrapped into a library and some parameters
are fixed and adjusted to be able to handle the largest use-case
scenario, QD was set to 256 for that test.

There is also few accessory fds such as 2 eventfd that are polled to
interrupt the framework event loop but in practice they were silent
during the whole testing period.

but no big batch submission for sure. At most maybe 2 sqes per
submission.

1 to provide back the buffer and the other to reinsert the read
operation.

> 
> > To process an incoming 5Mbps stream, it takes about 5% of the CPU.
> 
> I see, under utilised, and so your main concern is latency
> here.

YES! That is my main concern. That is THE reason why you now have me as
a io_uring power user.

My app was previously using epoll through libev. The idea to eliminate
all those syscalls did attract me.
> 
> > 
> > Here is the testing methodology:
> > add 2 fields in  struct io_rw:
> >     u64             startTs;
> >     u8              readType;
> > 
> > startTs is set with ktime_get_raw_fast_ns() in io_read_prep()
> > 
> > readType is set to:
> > 0: data ready
> > 1: use fast poll (we ignore those)
> > 2: reissue
> > 3: async
> > 
> > readType is used to know what type of measurement it is at the
> > recording point.
> > 
> > end time is measured at 3 recording point:
> > 1. In __io_queue_sqe() when io_issue_sqe() returns 0
> > 2. In __io_queue_sqe() after io_queue_async_work() call
> > 3. In io_wq_submit_work() after the while loop.
> > 
> > So I took 4 measurements.
> > 
> > 1. The time it takes to process a read request when data is already
> > available
> > 2. The time it takes to process by calling twice io_issue_sqe()
> > after
> > vfs_poll() indicated that data was available
> > 3. The time it takes to execute io_queue_async_work()
> > 4. The time it takes to complete a read request asynchronously
> > 
> > Before presenting the results, I want to mention that 2.25% of the
> > total number of my read requests ends up in the situation where the
> > read() syscall did return EAGAIN but data became available by the
> > time
> > vfs_poll gets called.
> > 
> > My expectations were that reissuing a sqe could be on par or a bit
> > more
> > expensive than placing it on io-wq for async processing and that
> > would
> > put the patch in some gray zone with pros and cons in terms of
> > performance.
> > 
> > The reality is instead super nice (numbers in nSec):
> > 
> > ready data (baseline)
> > avg     3657.94182918628
> > min     580
> > max     20098
> > stddev  1213.15975908162
> >         
> > reissue completion
> > average 7882.67567567568
> > min     2316
> > max     28811
> > stddev  1982.79172973284
> >         
> > insert io-wq time       
> > average 8983.82276995305
> > min     3324
> > max     87816
> > stddev  2551.60056552038
> >         
> > async time completion
> > average 24670.4758861127
> > min     10758
> > max     102612
> > stddev  3483.92416873804
> > 
> > Conclusion:
> > On average reissuing the sqe with the patch code is 1.1uSec faster
> > and
> > in the worse case scenario 59uSec faster than placing the request
> > on
> > io-wq
> > 
> > On average completion time by reissuing the sqe with the patch code
> > is
> > 16.79uSec faster and in the worse case scenario 73.8uSec faster
> > than
> > async completion.
> 
> Hah, you took it fundamentally. I'm trying to get it, correct me
> I am mistaken.
> 
> 1) it's avg completion for those 2.5%, not for all requests

Correct. Otherwise the executed path is identical to what it was prior
to the patch.
> 
> 2) Do they return equivalent number of bytes? And what the
> read/recv size (e.g. buffer size)?

Nothing escape your eagle vision attention Pavel...

I set my read size to an arbitrarilly big size (20KB) just to be sure
that I should, most of the time, never end up with partial reads and
perform more syscalls that I could get away with big enough buffer
size.

TBH, I didn't pay that much attention to this detail. out of my head, I
would say that the average size is all over the place. It can go from
150 Bytes up to 15KB but I would think that the average must be between
1-2 MTU (around 2500 bytes).

That being said, the average read size must spread equally to the
packets going to the regular path vs those of take the new shortcut, so
I believe that the conclusion should still hold despite not having
considered this aspect in the test.
> 
> Because in theory can be that during a somewhat small delay for
> punting to io-wq, more data had arrived and so async completion
> pulls more data that takes more time. In that case the time
> difference should also account the difference in amount of
> data that it reads.

Good point. This did not even occur to me to consider this aspect but
how many more packets would the network stack had the time to receive
in an extra 16uSec period? (I am not on one of those crazy Fiber optic
200Gbps Mellanox card....) 1,2,3,4? We aren't talking multiple extra
MBs to copy here...
> 
> 3) Curious, why read but not recv as you're working with sockets

I have learn network programming with the classic Stevens book. As far
as I remember from what I have learned in the book, it is that the only
benefit of recv() over read() is if you need to specify one of the
funky flags that recv() allow you to provide to it, read() doesn't give
access to that functionality.

If there is a performance benefit to use recv() over read() for tcp
fds, that is something I am not aware of and if you confirm me that it
is the case, that would be very easy for me to change my read calls for
recv() ones...

Now that you ask the question, maybe read() is implemented with recv()
but AFAIK, the native network functions are sendmsg and recvmsg so
neither read() or recv() would have an edge over the other in that
department, AFAIK...

while we are talking about read() vs recv(), I am curious too about
something, while working on my other patch (store back buffer in case
of failure), I did notice that buffer address and bid weren't stored in
the same fields.

io_put_recv_kbuf() vs io_put_rw_kbuf()

I didn't figure out why those values weren't stored in the same
io_kiocb fields for recv operations...

Why is that?
> 
> 4) Did you do any userspace measurements. And a question to
> everyone in general, do we have any good net benchmarking tool
> that works with io_uring? Like netperf? Hopefully spitting
> out latency distribution.

No, I haven't.
> 
> 
> Also, not particularly about reissue stuff, but a note to myself:
> 59us is much, so I wonder where the overhead comes from.
> Definitely not the iowq queueing (i.e. putting into a list).
> - waking a worker?
> - creating a new worker? Do we manage workers sanely? e.g.
>   don't keep them constantly recreated and dying back.
> - scheduling a worker?

creating a new worker is for sure not free but I would remove that
cause from the suspect list as in my scenario, it was a one-shot event.
First measurement was even not significantly higher than all the other
measurements.
> 
> Olivier, for how long did you run the test? >1 min?

much more than 1 minute. I would say something between 20-25 minutes.

I wanted a big enough sample size for those 2.5% special path events so
that the conclusion could be statistically significant.



