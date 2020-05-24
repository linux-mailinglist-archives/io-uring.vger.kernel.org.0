Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCEF71DFEBE
	for <lists+io-uring@lfdr.de>; Sun, 24 May 2020 13:47:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728091AbgEXLrj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 24 May 2020 07:47:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727916AbgEXLri (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 24 May 2020 07:47:38 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDB29C061A0E
        for <io-uring@vger.kernel.org>; Sun, 24 May 2020 04:47:37 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id u188so14397741wmu.1
        for <io-uring@vger.kernel.org>; Sun, 24 May 2020 04:47:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xzEydixWgdWTnKO5AO8Gg5OWM3y4Zu2LDRyMZ2jVXiU=;
        b=YOgU3v/ql3rbt6532PXrsJLtGifeONq0ypsN7X4g6WAsBtCQsKvbtTbP3u9m1orJ1L
         2f46eiU1wf5rjPwaoBcPKCxk7SLp9ZYz8sAC4V5Yfzydt+vUdWp4CZcXlKQG3KTfOryY
         hDS/IEztGEWpunzxV+t/4n8ezDKpiFGNjflsjUWHmqdm3lVPeQ4KBGyeqJTZiC/nVkMC
         c6PiwJDaolS02CGFyqAeyZgzVvXTmTT7UAZjcx8w783BbdibPVXhwQB4AnnKat5Nz2wM
         zjhUms/Bhe2+ba+OsmDHkMmH8yyZaLxvIODKA7zm0jVOzM6INE7cSj2Yc1y6ssXbvp0Q
         /Xkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=xzEydixWgdWTnKO5AO8Gg5OWM3y4Zu2LDRyMZ2jVXiU=;
        b=M2ogCrj46obtHKMmX2y7gqeSq8l1DZVclx6sgR0oQcNA4W0lZ7mklG2MiBy3SRYBic
         70/6g42Adk7mO8WB8Kvi02hZuvxJbrNmWgtS3EnrGHhnn7+oYszrpcnm5JQtRKvMequp
         nInL8dEs8cIw2KfW+qhGP/vN/r5b3u7odlYyMSw7+8qKK3Gnpd8hwWsuQvHIgJhioQ4A
         dMD9U9Q4tZ7+QMG+O2HykIP41ZzT78Ja/xw8kJa14WwoXWTIvkSGz14YBvEVV3MEes9+
         Ok/dKyqbGMhyGsrUTQ9MMuuPrRNTb06xuQTvQ3hIc+l5UQnH6gjHQmohsz/cyFPoB9R5
         RYww==
X-Gm-Message-State: AOAM531yxx5jtDge3JnkcCAghd0hyeEm0fzi6LaKM5eQfY75aMbkBy7J
        XOVVPLnJYS31gbPEblHw6R/HGsAs
X-Google-Smtp-Source: ABdhPJzieXBG+PEeyqpnCk44GCDIcvCg/J0ZYZ++rmRmMLnzrtOYwD+tvCJ501Dpo23MGcdahheoZQ==
X-Received: by 2002:a1c:29c2:: with SMTP id p185mr19688104wmp.7.1590320854946;
        Sun, 24 May 2020 04:47:34 -0700 (PDT)
Received: from [192.168.1.141] ([82.209.196.123])
        by smtp.gmail.com with ESMTPSA id l204sm4913283wmf.19.2020.05.24.04.47.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 24 May 2020 04:47:34 -0700 (PDT)
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, joseph.qi@linux.alibaba.com, yujian.wu1@gmail.com
References: <20200520115648.6140-1-xiaoguang.wang@linux.alibaba.com>
 <3bea8be7-2a82-cf24-a8b6-327672a64535@gmail.com>
 <242c17f3-b9b3-30cb-ff3d-a33aeef36ad1@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH] io_uring: create percpu io sq thread when
 IORING_SETUP_SQ_AFF is flagged
Message-ID: <13dd7a1f-63df-6a0c-74ed-d5ff12a0bf96@gmail.com>
Date:   Sun, 24 May 2020 14:46:17 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <242c17f3-b9b3-30cb-ff3d-a33aeef36ad1@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 22/05/2020 11:33, Xiaoguang Wang wrote:
> hi Pavel,
> 
> First thanks for reviewing!

sure, you're welcome!

>> On 20/05/2020 14:56, Xiaoguang Wang wrote:
>>>
>>> To fix this issue, when io_uring instance uses IORING_SETUP_SQ_AFF to specify a
>>> cpu,  we create a percpu io sq_thread to handle multiple io_uring instances' io
>>> requests serially. With this patch, in same environment, we get a huge
>>> improvement:
>>
>> Consider that a user can issue a long sequence of requests, say 2^15 of them,
>> and all of them will happen in a single call to io_submit_sqes(). Just preparing
>> them would take much time, apart from that it can do some effective work for
>> each of them, e.g. copying a page. And now there is another io_uring, caring
>> much about latencies and nevertheless waiting for _very_ long for its turn.
> Indeed I had thought this case before and don't clearly know how to optimize it
> yet.
> But I think if user has above usage scenarios, they probably shouldn't make
> io_uring
> instances share same cpu core. I'd like to explain more about our usage scenarios.

IIRC, you create _globally_ available per-cpu threads, so 2 totally independent
users may greatly affect each other, e.g. 2 docker containers in a hosted
server, and that would be nasty. But if it's limited to a "single user", it'd be
fine by me, see below for more details.

BTW, out of curiosity, what's the performance\latency impact of disabling SQPOLL
at all for your app? Say, comparing with non contended case.

> In a physical machine, say there are 96 cores, and it runs multiple cgroups, every
> cgroup run same application and will monopoly 16 cpu cores. This application will
> create 16 io threads and every io thread will create an io_uring instance and every
> thread will be bound to a different cpu core, these io threads will receive io
> requests.
> If we enable SQPOLL for these io threads, we allocate one or two cpu cores for
> these
> io_uring instances at most, so they must share allocated cpu core. It's totally
> disaster
> that some io_uring instances' busy loop in their sq_thread_idle period will
> impact other
> io_uring instances which have io requests to handle.
> 
>>
>> Another problem is that with it a user can't even guess when its SQ would be
>> emptied, and would need to constantly poll.
> In this patch, in every iteration, we only handle io requests already queued,
> will not constantly poll.

I was talking about a user polling _from userspace_ its full SQ, to understand
when it can submit more. That's if it doesn't want to wait for CQEs yet for some
reason (e.g. useful for net apps).

> 
>>
>> In essence, the problem is in bypassing thread scheduling, and re-implementing
>> poor man's version of it (round robin by io_uring).
> Yes :) Currently I use round robin strategy to handle multiple io_uring instance
> in every iteration.
> 
>> The idea and the reasoning are compelling, but I think we need to do something
>> about unrelated io_uring instances obstructing each other. At least not making
>> it mandatory behaviour.
>>
>> E.g. it's totally fine by me, if a sqpoll kthread is shared between specified
>> bunch of io_urings -- the user would be responsible for binding them and not
>> screwing up latencies/whatever. Most probably there won't be much (priviledged)
>> users using SQPOLL, and they all be a part of a single app, e.g. with
>> multiple/per-thread io_urings.
> Did you read my patch? In this patch, I have implemented this idea :)

Took a glance, may have overlooked things. I meant to do as in your patch, but
not sharing threads between ALL io_uring in the system, but rather between a
specified set of them. In other words, making yours @percpu_threads not global,
but rather binding to a set of io_urings.

e.g. create 2 independent per-cpu sets of threads. 1st one for {a1,a2,a3}, 2nd
for {b1,b2,b3}.

a1 = create_uring()
a2 = create_uring(shared_sq_threads=a1)
a3 = create_uring(shared_sq_threads=a1)

b1 = create_uring()
b2 = create_uring(shared_sq_threads=b1)
b3 = create_uring(shared_sq_threads=b1)

And then:
- it somehow solves the problem. As long as it doesn't effect much other users,
it's ok to let userspace screw itself by submitting 2^16 requests.

- there is still a problem with a simple round robin. E.g. >100 io_urings per
such set. Even though, a user may decide for itself, it worth to think about. I
don't want another scheduling framework here. E.g. first round-robin, then
weighted one, etc.

- it's actually not a set of threads (i.e. per-cpu) the API should operate on,
but just binding io_urings to a single SQPOLL thread.

- there is no need to restrict it to cpu-pinned case.

>>
>> Another way would be to switch between io_urings faster, e.g. after processing
>> not all requests but 1 or some N of them. But that's very thin ice, and I
>> already see other bag of issues.
> Sounds good, could you please lift detailed issues? Thanks.

Sounds terrible, TBH. Especially with arbitrary length links.


-- 
Pavel Begunkov
