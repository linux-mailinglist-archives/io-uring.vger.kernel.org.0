Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DB981DBE2E
	for <lists+io-uring@lfdr.de>; Wed, 20 May 2020 21:41:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726818AbgETTlS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 20 May 2020 15:41:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726548AbgETTlS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 20 May 2020 15:41:18 -0400
Received: from Galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A48FC061A0E;
        Wed, 20 May 2020 12:41:18 -0700 (PDT)
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jbUaQ-0001RU-Cr; Wed, 20 May 2020 21:41:06 +0200
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
        id D65F4100C99; Wed, 20 May 2020 21:41:05 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        Ming Lei <ming.lei@redhat.com>
Cc:     linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        John Garry <john.garry@huawei.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.com>, io-uring@vger.kernel.org
Subject: Re: io_uring vs CPU hotplug, was Re: [PATCH 5/9] blk-mq: don't set data->ctx and data->hctx in blk_mq_alloc_request_hctx
In-Reply-To: <448d3660-0d83-889b-001f-a09ea53fa117@kernel.dk>
References: <20200518093155.GB35380@T590> <87imgty15d.fsf@nanos.tec.linutronix.de> <20200518115454.GA46364@T590> <20200518131634.GA645@lst.de> <20200518141107.GA50374@T590> <20200518165619.GA17465@lst.de> <20200519015420.GA70957@T590> <20200519153000.GB22286@lst.de> <20200520011823.GA415158@T590> <20200520030424.GI416136@T590> <20200520080357.GA4197@lst.de> <8f893bb8-66a9-d311-ebd8-d5ccd8302a0d@kernel.dk> <448d3660-0d83-889b-001f-a09ea53fa117@kernel.dk>
Date:   Wed, 20 May 2020 21:41:05 +0200
Message-ID: <87tv0av1gu.fsf@nanos.tec.linutronix.de>
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
> On 5/20/20 8:45 AM, Jens Axboe wrote:
>> It just uses kthread_create_on_cpu(), nothing home grown. Pretty sure
>> they just break affinity if that CPU goes offline.
>
> Just checked, and it works fine for me. If I create an SQPOLL ring with
> SQ_AFF set and bound to CPU 3, if CPU 3 goes offline, then the kthread
> just appears unbound but runs just fine. When CPU 3 comes online again,
> the mask appears correct.

When exactly during the unplug operation is it unbound?

Thanks,

        tglx
