Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51A834BEAA5
	for <lists+io-uring@lfdr.de>; Mon, 21 Feb 2022 20:36:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233062AbiBUTa1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 21 Feb 2022 14:30:27 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbiBUTa0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 21 Feb 2022 14:30:26 -0500
Received: from cloud48395.mywhc.ca (cloud48395.mywhc.ca [173.209.37.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5420E65FC;
        Mon, 21 Feb 2022 11:30:02 -0800 (PST)
Received: from [45.44.224.220] (port=44686 helo=[192.168.1.179])
        by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <olivier@trillion01.com>)
        id 1nMENj-0008Ff-VX; Mon, 21 Feb 2022 14:30:00 -0500
Message-ID: <cfa4268754a9884d22ac901a42817716ee33ab5f.camel@trillion01.com>
Subject: Re: [PATCH v1] io_uring: Add support for napi_busy_poll
From:   Olivier Langlois <olivier@trillion01.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Hao Xu <haoxu@linux.alibaba.com>,
        io-uring <io-uring@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date:   Mon, 21 Feb 2022 14:29:59 -0500
In-Reply-To: <76456775-a0c5-7925-0160-9037512e7e4d@kernel.dk>
References: <d11e31bd59c75b2cce994dd90a07e769d4e039db.1645257310.git.olivier@trillion01.com>
         <cbf791fb3cd495f156eb4aeb4dd01c42fca22cd4.camel@trillion01.com>
         <f070354c-b65b-f8b3-e597-2e756bcfa705@kernel.dk>
         <b674472d8c52a84002908e2248fd81ce11247569.camel@trillion01.com>
         <76456775-a0c5-7925-0160-9037512e7e4d@kernel.dk>
Organization: Trillion01 Inc
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.42.3 
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
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sun, 2022-02-20 at 12:38 -0700, Jens Axboe wrote:
> 
> OK, that's a pretty good improvement in both latency and
> deviation/consistency. Is this using SQPOLL, or is it using polling
> off
> cqring_wait from the task itself? Also something to consider for the
> test benchmark app, should be able to run both (which is usually just
> setting the SETUP_SQPOLL flag or not, if done right).
> 
> 
The answer to your question is complex. This is one of the external
factor that I was refering too.

1 thread is managing 49 TCP sockets. This thread io_uring context is
configured with SQPOLL. Upon receiving a packet of interest, it will
wake up thread #2 with an eventfd installed into a private non SQPOLL 
io_uring context and will send a request to a 50th TCP socket.

Both threads are now busy polling NAPI. One from the SQPOLL code and
the other with the io_cqring_wait() code.

If it was not enough, since I have discovered busy poll benefits and
that to reschedule a sleeping task takes about 5-10 uSecs, thread #1 is
also busy polling io_uring instead of blocking in io_uring_enter().

Thx for suggesting designing the benchmark to be able to test both
SQPOLL and non SQPOLL busy polling. This is something that I already in
mind.

I have completed 3 small improvements for the patch v2. I need to check
the kernel test bot and Hao comments to see if I have more to work on
but if all is good, I only need to complete the benchmark program. I
might able to send v2 later today.

Greetings,

