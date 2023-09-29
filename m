Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77BA77B2D46
	for <lists+io-uring@lfdr.de>; Fri, 29 Sep 2023 09:53:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232606AbjI2Hxe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 29 Sep 2023 03:53:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232490AbjI2Hxd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 29 Sep 2023 03:53:33 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6444F19F;
        Fri, 29 Sep 2023 00:53:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=2Pkb5DnV71k1tu3U6IYRm3wbQQKNuRrD4LWkd3PbO1E=; b=MfVFZhqwg5X38MlA8cNjuskPhH
        ZK9Mv9TTx2MzK6dmDdlpNX7iVMjx4WKEUVdhfZ72rO0zA/ihGIKKpjjIgC38dDwofWXgHo9ubXXn2
        /2c+Jk+RLQkA9ZRCdPUlHcTPPffJcyBUpQG8szSqrQTPYd5xveMhBzDUWm4dV6jtqBvrQMZDw1y2F
        zTyOMyd7vc87sTqIO3CjtLa+vIp9zyqPtm6MakDk6yS/OOQVx+9saWi5d2c1gXkv+qadlW2mNzvRY
        bKysQyMP6f0tufCQTGTHEbr2p+GE3nf7jFhjYb3k0Oqc6kJE224kwcjfAqGJE56oHGEiw4WBaM4AX
        x00Kcrww==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1qm8JI-005wNq-0l;
        Fri, 29 Sep 2023 07:53:18 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
        id 5FC2830030F; Fri, 29 Sep 2023 09:53:17 +0200 (CEST)
Date:   Fri, 29 Sep 2023 09:53:17 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        andres@anarazel.de, tglx@linutronix.de
Subject: Re: [PATCHSET v6] Add io_uring futex/futexv support
Message-ID: <20230929075317.GA6282@noisy.programming.kicks-ass.net>
References: <20230928172517.961093-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230928172517.961093-1-axboe@kernel.dk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Sep 28, 2023 at 11:25:09AM -0600, Jens Axboe wrote:

>  include/linux/io_uring_types.h |   5 +
>  include/uapi/linux/io_uring.h  |   4 +
>  io_uring/Makefile              |   1 +
>  io_uring/cancel.c              |   5 +
>  io_uring/cancel.h              |   4 +
>  io_uring/futex.c               | 386 +++++++++++++++++++++++++++++++++
>  io_uring/futex.h               |  36 +++
>  io_uring/io_uring.c            |   7 +
>  io_uring/opdef.c               |  34 +++
>  kernel/futex/futex.h           |  20 ++
>  kernel/futex/requeue.c         |   3 +-
>  kernel/futex/syscalls.c        |  18 +-
>  kernel/futex/waitwake.c        |  49 +++--
>  13 files changed, 545 insertions(+), 27 deletions(-)

Thanks for bearing with us on the futex2 thing!

Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
