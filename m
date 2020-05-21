Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7031D1DD7D5
	for <lists+io-uring@lfdr.de>; Thu, 21 May 2020 22:01:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730310AbgEUUA5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 21 May 2020 16:00:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729780AbgEUUA5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 21 May 2020 16:00:57 -0400
Received: from Galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA9A1C061A0E;
        Thu, 21 May 2020 13:00:56 -0700 (PDT)
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jbrMP-0008Jj-44; Thu, 21 May 2020 22:00:09 +0200
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
        id 57046100C2D; Thu, 21 May 2020 22:00:08 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org,
        linux-block@vger.kernel.org, John Garry <john.garry@huawei.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.com>, io-uring@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: io_uring vs CPU hotplug, was Re: [PATCH 5/9] blk-mq: don't set data->ctx and data->hctx in blk_mq_alloc_request_hctx
In-Reply-To: <15f9f975-1baf-dc90-5730-00df08829523@kernel.dk>
References: <20200520011823.GA415158@T590> <20200520030424.GI416136@T590> <20200520080357.GA4197@lst.de> <8f893bb8-66a9-d311-ebd8-d5ccd8302a0d@kernel.dk> <448d3660-0d83-889b-001f-a09ea53fa117@kernel.dk> <87tv0av1gu.fsf@nanos.tec.linutronix.de> <2a12a7aa-c339-1e51-de0d-9bc6ced14c64@kernel.dk> <87eereuudh.fsf@nanos.tec.linutronix.de> <20200521022746.GA730422@T590> <87367tvh6g.fsf@nanos.tec.linutronix.de> <20200521092340.GA751297@T590> <87pnaxt9nv.fsf@nanos.tec.linutronix.de> <15f9f975-1baf-dc90-5730-00df08829523@kernel.dk>
Date:   Thu, 21 May 2020 22:00:08 +0200
Message-ID: <87k115t5x3.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Jens Axboe <axboe@kernel.dk> writes:
> Again, this is mixing up io_uring and blk-mq. Maybe it's the fact that
> both use 'ctx' that makes this confusing. On the blk-mq side, the 'ctx'
> is the per-cpu queue context, for io_uring it's the io_uring instance.

Yes, that got me horribly confused. :)

> io_sq_thread() doesn't care about any sort of percpu mappings, it's
> happy as long as it'll keep running regardless of whether or not the
> optional pinned CPU is selected and then offlined.

Fair enough.

So aside of the potential spin forever if the uring thread is lifted to
an RT scheduling class, this looks all good.

Though I assume that if that thread is pinned and an admin pushs it into
RT scheduling the spinning live lock can happen independent of cpu
hotplug.

Thanks,

        tglx
