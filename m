Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A24D3A3A91
	for <lists+io-uring@lfdr.de>; Fri, 11 Jun 2021 05:55:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231356AbhFKD5h (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 10 Jun 2021 23:57:37 -0400
Received: from cloud48395.mywhc.ca ([173.209.37.211]:59610 "EHLO
        cloud48395.mywhc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231309AbhFKD5g (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 10 Jun 2021 23:57:36 -0400
Received: from modemcable064.203-130-66.mc.videotron.ca ([66.130.203.64]:51986 helo=[192.168.1.179])
        by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <olivier@trillion01.com>)
        id 1lrYGg-0002KQ-QB; Thu, 10 Jun 2021 23:55:38 -0400
Message-ID: <b0a8c92cffb3dc1b48b081e5e19b016fee4c6511.camel@trillion01.com>
Subject: Re: [PATCH] io_uring: reduce latency by reissueing the operation
From:   Olivier Langlois <olivier@trillion01.com>
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 10 Jun 2021 23:55:38 -0400
In-Reply-To: <a12e218a-518d-1dac-5e8c-d9784c9850b0@gmail.com>
References: <60c13bec.1c69fb81.73967.f06dSMTPIN_ADDED_MISSING@mx.google.com>
         <84e42313-d738-fb19-c398-08a4ed0e0d9c@gmail.com>
         <4b5644bff43e072a98a19d7a5ca36bb5e11497ec.camel@trillion01.com>
         <a7d6f2fd-b59e-e6fa-475a-23962d45b6fa@gmail.com>
         <9938f22a0bb09f344fa5c9c5c1b91f0d12e7566f.camel@trillion01.com>
         <a12e218a-518d-1dac-5e8c-d9784c9850b0@gmail.com>
Organization: Trillion01 Inc
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.40.2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
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

On Thu, 2021-06-10 at 20:32 +0100, Pavel Begunkov wrote:
> On 6/10/21 6:56 PM, Olivier Langlois wrote:
> > 
> > 
> > Can you think of other numbers that would be useful to know to
> > evaluate
> > the patch performance?
> 
> If throughput + latency (avg + several nines) are better (or any
> other measurable improvement), it's a good enough argument to me,
> but not sure what test case you're looking at. Single threaded?
> Does it saturate your CPU?
> 
I don't know what are the ideal answers to your 2 last questions ;-)

I have several possible configurations to my application.

The most complex one is a 2 threads setup each having their own
io_uring instance where one of the threads is managing 50-85 TCP
connections over which JSON stream encapsulated in the WebSocket
protocol are received.

That more complex setup is also using IORING_SETUP_ATTACH_WQ to share
the sqpoll thread between the 2 instances.

In that more complex config, the sqpoll thread is running at 85-95% of
its dedicated CPU.

For the patch performance testing I did use the simplest config:
Single thread, 1 TCP connection, no sqpoll.

To process an incoming 5Mbps stream, it takes about 5% of the CPU.

Here is the testing methodology:
add 2 fields in  struct io_rw:
    u64             startTs;
    u8              readType;

startTs is set with ktime_get_raw_fast_ns() in io_read_prep()

readType is set to:
0: data ready
1: use fast poll (we ignore those)
2: reissue
3: async

readType is used to know what type of measurement it is at the
recording point.

end time is measured at 3 recording point:
1. In __io_queue_sqe() when io_issue_sqe() returns 0
2. In __io_queue_sqe() after io_queue_async_work() call
3. In io_wq_submit_work() after the while loop.

So I took 4 measurements.

1. The time it takes to process a read request when data is already
available
2. The time it takes to process by calling twice io_issue_sqe() after
vfs_poll() indicated that data was available
3. The time it takes to execute io_queue_async_work()
4. The time it takes to complete a read request asynchronously

Before presenting the results, I want to mention that 2.25% of the
total number of my read requests ends up in the situation where the
read() syscall did return EAGAIN but data became available by the time
vfs_poll gets called.

My expectations were that reissuing a sqe could be on par or a bit more
expensive than placing it on io-wq for async processing and that would
put the patch in some gray zone with pros and cons in terms of
performance.

The reality is instead super nice (numbers in nSec):

ready data (baseline)
avg	3657.94182918628
min	580
max	20098
stddev	1213.15975908162
	
reissue	completion
average	7882.67567567568
min	2316
max	28811
stddev	1982.79172973284
	
insert io-wq time	
average	8983.82276995305
min	3324
max	87816
stddev	2551.60056552038
	
async time completion
average	24670.4758861127
min	10758
max	102612
stddev	3483.92416873804

Conclusion:
On average reissuing the sqe with the patch code is 1.1uSec faster and
in the worse case scenario 59uSec faster than placing the request on
io-wq

On average completion time by reissuing the sqe with the patch code is
16.79uSec faster and in the worse case scenario 73.8uSec faster than
async completion.

One important detail to mention about the async completion time, in the
testing the ONLY way that a request can end up being completed async is
if vfs_poll() reports that the file is ready. Otherwise, the request
ends up being processed with io_uring fast poll feature.

So there does not seem to have any downside to the patch. TBH, at the
initial patch submission, I only did use my intuition to evaluate the
merit of my patch but, thx to your healthy skepticism, Pavel, this did
force me to actually measure the patch and it appears to incontestably
improve performance for both the reissued SQE and also all the other
sqes found in a batch submission.

Hopefully, the results will please you as much as they have for me!

Greetings,
Olivier

