Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4F0B1D2037
	for <lists+io-uring@lfdr.de>; Wed, 13 May 2020 22:32:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725977AbgEMUcE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 13 May 2020 16:32:04 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:60655 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725952AbgEMUcE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 13 May 2020 16:32:04 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailforward.nyi.internal (Postfix) with ESMTP id 2DC4F194048A;
        Wed, 13 May 2020 16:32:03 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 13 May 2020 16:32:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; bh=8/uT6Fyu1iz5eMYwmwTdiVaY95eH7ssrm/l9QXJ0X
        kc=; b=yHPT6i5JEuO123spClgY1e/ykbHQXZ2iW+mV7slkqCziGEpSxtbc8z2kC
        3C3H7CRY6elioS4GJEc0FxGIXXzU3jFDtPz0L2UVDyNwQUmPqqFNajOe2/nueUux
        dkjjjELuK1zs5a6QVooAhmiPXd1iEy3N53xNWyH30hmxZB4+V/AT5oIJ3K3Da2V4
        WVEeU+meGYOG5rY0P5b0Zu7KrPAc5SKac1CwZy8kr5dhKQsdxp/Ppwxe5PsVtnP8
        cDzq82jrmF7nlIZVXTwHBtYVLpefzf5PkRm6+VVtkHozqFnklSBA7AAiZ0OeOt+a
        gvFTYcwIw6SWmkDK28MRjEd3oQarg==
X-ME-Sender: <xms:QVm8XjH0PIh1KIE0N3gC4SFfkOEvN2gMaxDyRRKOY94NfzQdnM-t9Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrleeggddugeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepuffvfhfhkffffgggjggtgfesthejredttdefjeenucfhrhhomheprfgvkhhk
    rgcugfhnsggvrhhguceophgvnhgsvghrghesihhkihdrfhhiqeenucggtffrrghtthgvrh
    hnpefhveegtdehhfdtfeeuleegfffhtdegkeefleehfeehieelgefgfffhgfehudefteen
    ucfkphepkeelrddvjedrfeefrddujeefnecuvehluhhsthgvrhfuihiivgeptdenucfrrg
    hrrghmpehmrghilhhfrhhomhepphgvnhgsvghrghesihhkihdrfhhi
X-ME-Proxy: <xmx:QVm8XgUbeqiTdzIOYi5uZFpm2N4t0KC4GA3jJi7zuZ0MZnQWyxM0Gw>
    <xmx:QVm8XlJXQKYi34vxsRm0Ak85boJMNI-l3ZPm8Py12HwWPPSkqYZ4gQ>
    <xmx:QVm8XhFGVHik4F9GrMmTC3RSAvqaqe-lmJUTDbKMBtLuXwAX2s8SHw>
    <xmx:Q1m8XhQNu3LyF08sn1hudj1T8Okv1ue4v3qJl_5A9U1BhvwW9jw8HrKPMms>
Received: from [192.168.1.105] (89-27-33-173.bb.dnainternet.fi [89.27.33.173])
        by mail.messagingengine.com (Postfix) with ESMTPA id 63489306631F;
        Wed, 13 May 2020 16:31:59 -0400 (EDT)
Subject: Re: [PATCH RFC} io_uring: io_kiocb alloc cache
To:     Jens Axboe <axboe@kernel.dk>, Jann Horn <jannh@google.com>
Cc:     io-uring <io-uring@vger.kernel.org>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        joseph qi <joseph.qi@linux.alibaba.com>,
        Jiufei Xue <jiufei.xue@linux.alibaba.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>
References: <492bb956-a670-8730-a35f-1d878c27175f@kernel.dk>
 <CAG48ez0eGT60a50GAkL3FVvRzpXwhufdr+68k_X_qTgxyZ-oQQ@mail.gmail.com>
 <20200513191919.GA10975@nero>
 <fb43ddb4-693b-5c07-775f-3142502495de@kernel.dk>
From:   Pekka Enberg <penberg@iki.fi>
Message-ID: <d3ff604d-2955-f8f6-dcbd-25ae90569dc3@iki.fi>
Date:   Wed, 13 May 2020 23:31:58 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <fb43ddb4-693b-5c07-775f-3142502495de@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Jens,

On 5/13/20 1:20 PM, Pekka Enberg wrote:
>> So I assume if someone does "perf record", they will see significant
>> reduction in page allocator activity with Jens' patch. One possible way
>> around that is forcing the page allocation order to be much higher. IOW,
>> something like the following completely untested patch:

On 5/13/20 11:09 PM, Jens Axboe wrote:
> Now tested, I gave it a shot. This seems to bring performance to
> basically what the io_uring patch does, so that's great! Again, just in
> the microbenchmark test case, so freshly booted and just running the
> case.

Great, thanks for testing!

On 5/13/20 11:09 PM, Jens Axboe wrote:
> Will this patch introduce latencies or non-deterministic behavior for a
> fragmented system?

You have to talk to someone who is more up-to-date with how the page 
allocator operates today. But yeah, I assume people still want to avoid 
higher-order allocations as much as possible, because they make 
allocation harder when memory is fragmented.

That said, perhaps it's not going to the page allocator as much as I 
thought, but the problem is that the per-CPU cache size is just to small 
for these allocations, forcing do_slab_free() to take the slow path 
often. Would be interesting to know if CONFIG_SLAB does better here 
because the per-CPU cache size is much larger IIRC.

- Pekka
