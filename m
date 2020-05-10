Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4608C1CCCD0
	for <lists+io-uring@lfdr.de>; Sun, 10 May 2020 20:11:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728385AbgEJSLn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 10 May 2020 14:11:43 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:60997 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728381AbgEJSLn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 10 May 2020 14:11:43 -0400
Received: from compute7.internal (compute7.nyi.internal [10.202.2.47])
        by mailout.west.internal (Postfix) with ESMTP id 2A3E051C;
        Sun, 10 May 2020 14:11:42 -0400 (EDT)
Received: from imap21 ([10.202.2.71])
  by compute7.internal (MEProxy); Sun, 10 May 2020 14:11:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.com; h=
        mime-version:message-id:in-reply-to:references:date:from:to:cc
        :subject:content-type; s=fm2; bh=GsP8mDRu84QRmiCjOp7W0e7n6crRhgm
        IhMd/4Oez5zA=; b=k78SJHlgkzJXz90Mn+hdXctx4NiJntOQJMaTF4XkZrccClh
        wXSm4/mVO2KpBHwmOgwJXVhlGpKblaFpQliIDxfEonqKKAOR3z5pTU4jju1FK3Oj
        CY13oWFi7pm7D5JT8qDmPg91rklHuJXYEhBkvGlelvaaWkC9zjvHF7uxg5dRTj3V
        Cmyn1L4HJw7+ipUiHR69LKkw7UsVOG8kyFDq50qny5cNNm4EFJGXPX63/9Wsybm2
        Cr/bryh9IUKAEGyl3vplnWoz55lLndbqeZggzRhyJGY0leIJkqjqLi92lvBBDdek
        mBLUqjXHEpVuLi11llanbo4EXxfH9v1NF728PtA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=GsP8mD
        Ru84QRmiCjOp7W0e7n6crRhgmIhMd/4Oez5zA=; b=hb0WsNnHxycAXjKH9a1mmC
        y3w5PNU32QKH8cvqKN5SYaNroSkRk7Y7EdDRR79gnp0tSxJt+CQWhD3R9MA6zWtx
        rh7cebC83kNFe3+/Qq8dA8R/ak00AE+YdUYscShyk7tUyqFrHqu1KwBgLt0YkIZg
        jC/XbDBrNamETx/PHQ2SOxTxMFisbVEOd9kDRQzwTPG5RswHHuaUKh+Wh6Yt4eON
        tzcC/qjqM6wIBN3uS7Cu+FojG/WdgqqkSthHP/gV1IU0mVJSpUwL6ODvqfNMKJ1h
        hMLN6uuvwThmk+cBlVLn4b+KgTpl7j/2PNWLgx9v8Qll4PJEccIci+UCT0YUtAfg
        ==
X-ME-Sender: <xms:3UO4Xs9Cjgwv0_qZiFjSq48JQhZWT5pwkt0Lvzh6bAYHclks9fD5Lw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrkeekgdduvdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvffutgesthdtredtreerjeenucfhrhhomhepfdfjrdcu
    uggvucggrhhivghsfdcuoehhuggvvhhrihgvshesfhgrshhtmhgrihhlrdgtohhmqeenuc
    ggtffrrghtthgvrhhnpeektefhjefhfefgfefgtdeigeegleetleejjeehieejkeduveek
    gfeukeehvdekleenucffohhmrghinhepghhithhhuhgsrdgtohhmpdhkvghrnhgvlhdrug
    hknecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhephhgu
    vghvrhhivghssehfrghsthhmrghilhdrtghomh
X-ME-Proxy: <xmx:3UO4XmOWDcfnYe_e7C9wjAentN07eBgWssEG9Jy-pNbIr5cpcywSKw>
    <xmx:3UO4XiG3P6hLk-OdNh30lk2yy4jO_mbURENQPqnUkjK7i4Zi0-L2bQ>
    <xmx:3UO4XsT4EFYygralW-gW0_WXwNcjeMC1N-SFWhFGYz9BJ9U1L-6BmA>
    <xmx:3UO4Xqw4bqbjHL_qieugu0k4e8-74PC20TN-zQYe57jYa_juCfEDbg>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 1E14A660069; Sun, 10 May 2020 14:11:41 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.3.0-dev0-413-g750b809-fmstable-20200507v1
Mime-Version: 1.0
Message-Id: <3d667681-cdc8-4ac2-854d-ebe882b02da3@www.fastmail.com>
In-Reply-To: <5828e2de-5976-20ae-e920-bf185c0bc52d@kernel.dk>
References: <6132351e-75e6-9d4d-781b-d6a183d87846@linux.alibaba.com>
 <5828e2de-5976-20ae-e920-bf185c0bc52d@kernel.dk>
Date:   Sun, 10 May 2020 20:10:43 +0200
From:   "H. de Vries" <hdevries@fastmail.com>
To:     "Jens Axboe" <axboe@kernel.dk>,
        "Xiaoguang Wang" <xiaoguang.wang@linux.alibaba.com>,
        io-uring <io-uring@vger.kernel.org>
Cc:     "Pavel Begunkov" <asml.silence@gmail.com>,
        "joseph qi" <joseph.qi@linux.alibaba.com>,
        "Jiufei Xue" <jiufei.xue@linux.alibaba.com>
Subject: =?UTF-8?Q?Re:_Is_io=5Furing_framework_becoming_bloated_gradually=3F_and_?=
 =?UTF-8?Q?introduces_performace_regression?=
Content-Type: text/plain
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Xiaoguang,

Why exactly you don't get the performance [1] is referring to could have many reasons. It seems your nop test code quite different from the echo server that is used for [1]. [1] employs and event loop (single thread) specifically for networking. It saves an expensive call to epoll in each iteration of the loop. I glanced at your test program, what is the performance difference with IOSQE_ASYNC vs without IOSQE_ASYNC? 

[1]: https://github.com/frevib/io_uring-echo-server/blob/io-uring-feat-fast-poll/benchmarks/benchmarks.md.

--
Hielke de Vries


On Fri, May 8, 2020, at 18:37, Jens Axboe wrote:
> On 5/8/20 9:18 AM, Xiaoguang Wang wrote:
> > hi,
> > 
> > This issue was found when I tested IORING_FEAT_FAST_POLL feature, with
> > the newest upstream codes, indeed I find that io_uring's performace
> > improvement is not obvious compared to epoll in my test environment,
> > most of the time they are similar.  Test cases basically comes from:
> > https://github.com/frevib/io_uring-echo-server/blob/io-uring-feat-fast-poll/benchmarks/benchmarks.md.
> > In above url, the author's test results shows that io_uring will get a
> > big performace improvement compared to epoll. I'm still looking into
> > why I don't get the big improvement, currently don't know why, but I
> > find some obvious regression issue.
> > 
> > I wrote a simple tool based io_uring nop operation to evaluate
> > io_uring framework in v5.1 and 5.7.0-rc4+(jens's io_uring-5.7 branch),
> > I see a obvious performace regression:
> >
> > v5.1 kernel:
> >      $sudo taskset -c 60 ./io_uring_nop_stress -r 300 # run 300 seconds
> >      total ios: 1832524960
> >      IOPS:      6108416
> > 5.7.0-rc4+
> >      $sudo taskset -c 60 ./io_uring_nop_stress -r 300
> >      total ios: 1597672304
> >      IOPS:      5325574
> > it's about 12% performance regression.
> 
> For sure there's a bit more bloat in 5.7+ compared to the initial slim
> version, and focus has been on features to a certain extent recently.
> The poll rework for 5.7 will really improve performance for the
> networked side though, so it's not like it's just piling on features
> that add bloat.
> 
> That said, I do think it's time for a revisit on overhead. It's been a
> while since I've done my disk IO testing. The nop testing isn't _that_
> interesting by itself, as a micro benchmark it does yield some results
> though. Are you running on bare metal or in a VM?
> 
> > Using perf can see many performance bottlenecks, for example,
> > io_submit_sqes is one.  For now, I did't make many analysis yet, just
> > have a look at io_submit_sqes(), there are many assignment operations
> > in io_init_req(), but I'm not sure whether they are all needed when
> > req is not needed to be punt to io-wq, for example,
> > INIT_IO_WORK(&req->work, io_wq_submit_work); # a whole struct
> > assignment from perf annotate tool, it's an expensive operation, I
> > think reqs that use fast poll feature use task-work function, so the
> > INIT_IO_WORK maybe not necessary.
> 
> I'm sure there's some low hanging fruit there, and I'd love to take
> patches for it.
> 
> > Above is just one issue, what I worry is that whether io_uring is
> > becoming more bloated gradually, and will not that better to aio. In
> > https://kernel.dk/io_uring.pdf, it says that io_uring will eliminate
> > 104 bytes copy compared to aio, but see currenct io_init_req(),
> > io_uring maybe copy more, introducing more overhead? Or does we need
> > to carefully re-design struct io_kiocb, to reduce overhead as soon as
> > possible.
> 
> The copy refers to the data structures coming in and out, both io_uring
> and io_uring inititalize their main io_kiocb/aio_kiocb structure as
> well. The io_uring is slightly bigger, but not much, and it's the same
> number of cachelines. So should not be a huge difference there. The
> copying on the aio side is basically first the pointer copy, then the
> user side kiocb structure. io_uring doesn't need to do that. The
> completion side is also slimmer. We also don't need as many system calls
> to do the same thing, for example.
> 
> So no, we should always been substantially slimmer than aio, just by the
> very nature of the API.
> 
> One major thing I've been thinking about for io_uring is io_kiocb
> recycling. We're hitting the memory allocator for alloc+free for each
> request, even though that can be somewhat amortized by doing batched
> submissions, and polling for instance can also do batched frees. But I'm
> pretty sure we can find some gains here by having some io_kiocb caching
> that is persistent across operations.
> 
> Outside of that, runtime analysis and speeding up the normal path
> through io_uring will probably also easily yield us an extra 5% (or
> more).
> 
> -- 
> Jens Axboe
> 
>
