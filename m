Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA3251DB837
	for <lists+io-uring@lfdr.de>; Wed, 20 May 2020 17:31:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726881AbgETPb1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 20 May 2020 11:31:27 -0400
Received: from verein.lst.de ([213.95.11.211]:50373 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726596AbgETPb0 (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Wed, 20 May 2020 11:31:26 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 69DAB68BEB; Wed, 20 May 2020 17:31:23 +0200 (CEST)
Date:   Wed, 20 May 2020 17:31:23 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        linux-block@vger.kernel.org, John Garry <john.garry@huawei.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.com>, io-uring@vger.kernel.org
Subject: Re: io_uring vs CPU hotplug, was Re: [PATCH 5/9] blk-mq: don't set
 data->ctx and data->hctx in blk_mq_alloc_request_hctx
Message-ID: <20200520153123.GA2340@lst.de>
References: <20200518131634.GA645@lst.de> <20200518141107.GA50374@T590> <20200518165619.GA17465@lst.de> <20200519015420.GA70957@T590> <20200519153000.GB22286@lst.de> <20200520011823.GA415158@T590> <20200520030424.GI416136@T590> <20200520080357.GA4197@lst.de> <8f893bb8-66a9-d311-ebd8-d5ccd8302a0d@kernel.dk> <448d3660-0d83-889b-001f-a09ea53fa117@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <448d3660-0d83-889b-001f-a09ea53fa117@kernel.dk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, May 20, 2020 at 09:20:50AM -0600, Jens Axboe wrote:
> Just checked, and it works fine for me. If I create an SQPOLL ring with
> SQ_AFF set and bound to CPU 3, if CPU 3 goes offline, then the kthread
> just appears unbound but runs just fine. When CPU 3 comes online again,
> the mask appears correct.
> 
> So don't think there's anything wrong on that side. The affinity is a
> performance optimization, not a correctness issue. Really not much we
> can do if the chosen CPU is offlined, apart from continue to chug along.

Ok, that sounds pretty sensible.
