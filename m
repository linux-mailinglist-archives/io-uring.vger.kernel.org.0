Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD64775BEAD
	for <lists+io-uring@lfdr.de>; Fri, 21 Jul 2023 08:19:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230394AbjGUGTY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 21 Jul 2023 02:19:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230400AbjGUGS4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 21 Jul 2023 02:18:56 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39A0635B7;
        Thu, 20 Jul 2023 23:15:57 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 840F56732D; Fri, 21 Jul 2023 08:15:54 +0200 (CEST)
Date:   Fri, 21 Jul 2023 08:15:54 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de,
        andres@anarazel.de, david@fromorbit.com
Subject: Re: [PATCH 3/8] iomap: treat a write through cache the same as FUA
Message-ID: <20230721061554.GC20600@lst.de>
References: <20230720181310.71589-1-axboe@kernel.dk> <20230720181310.71589-4-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230720181310.71589-4-axboe@kernel.dk>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Jul 20, 2023 at 12:13:05PM -0600, Jens Axboe wrote:
> Whether we have a write back cache and are using FUA or don't have
> a write back cache at all is the same situation. Treat them the same.
> 
> This makes the IOMAP_DIO_WRITE_FUA name a bit misleading, as we have
> two cases that provide stable writes:
> 
> 1) Volatile write cache with FUA writes
> 2) Normal write without a volatile write cache
> 
> Rename that flag to IOMAP_DIO_STABLE_WRITE to make that clearer, and
> update some of the FUA comments as well.

I would have preferred IOMAP_DIO_WRITE_THROUGH, STABLE_WRITES is a flag
we use in file systems and the page cache for cases where the page
can't be touched before writeback has completed, e.g.
QUEUE_FLAG_STABLE_WRITES and SB_I_STABLE_WRITES.

Otherwise this looks good to me:

Reviewed-by: Christoph Hellwig <hch@lst.de>
