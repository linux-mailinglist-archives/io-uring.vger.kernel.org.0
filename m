Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6335457E3FB
	for <lists+io-uring@lfdr.de>; Fri, 22 Jul 2022 17:59:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229937AbiGVP7R (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 22 Jul 2022 11:59:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229778AbiGVP7Q (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 22 Jul 2022 11:59:16 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FD1D3F328
        for <io-uring@vger.kernel.org>; Fri, 22 Jul 2022 08:59:16 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 050C468AFE; Fri, 22 Jul 2022 17:59:13 +0200 (CEST)
Date:   Fri, 22 Jul 2022 17:59:12 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Christoph Hellwig <hch@lst.de>, io-uring@vger.kernel.org
Subject: Re: __io_file_supports_nowait for regular files
Message-ID: <20220722155912.GA10020@lst.de>
References: <20220721153740.GA5900@lst.de> <62207ded-7bf8-9aa1-bfc0-90a0aa12c373@kernel.dk> <20220721162303.GA9289@lst.de> <6a8f5175-fd42-b114-b512-99c0edd9ebaf@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6a8f5175-fd42-b114-b512-99c0edd9ebaf@kernel.dk>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Jul 21, 2022 at 12:46:16PM -0600, Jens Axboe wrote:
> Looking a bit deeper at this, FMODE_NOWAIT is about the file.

Yes.

> The nowait
> check for the bdev is about whether the driver honors NOWAIT
> submissions. Any blk-mq driver will be fine, bio based ones probably
> not. You could very well end up blocking off the submit path in that
> case.

But do these submissions even matter for the high level interface?
We'd get -EAGAIN way more often without them (or all the time
for direct I/O), but does that strictly matter for the interface?

Note that for mny file systems (at least btrfs, f2fs and xfs) just
checking s_bdev is not enough any way as they can use multiple block
devices.

I'm also a little confused now that I'm looking more into this,
as iomap only uses REQ_NOWAIT for polled direct I/O to start with.
The legacy direct I/O code uses it for all writes as long as
IOCB_NOWAIT is set, so it seems like only the block device code
really makes extensive and most likely correct use of the
REQ_NOWAIT flag anyway.
