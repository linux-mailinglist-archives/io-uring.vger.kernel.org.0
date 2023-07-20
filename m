Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D8D075A535
	for <lists+io-uring@lfdr.de>; Thu, 20 Jul 2023 06:50:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229638AbjGTEuk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 Jul 2023 00:50:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbjGTEuj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 20 Jul 2023 00:50:39 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 979521FD2;
        Wed, 19 Jul 2023 21:50:38 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 40BF767373; Thu, 20 Jul 2023 06:50:35 +0200 (CEST)
Date:   Thu, 20 Jul 2023 06:50:35 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de,
        andres@anarazel.de, david@fromorbit.com
Subject: Re: [PATCH 1/6] iomap: cleanup up iomap_dio_bio_end_io()
Message-ID: <20230720045035.GA1811@lst.de>
References: <20230719195417.1704513-1-axboe@kernel.dk> <20230719195417.1704513-2-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230719195417.1704513-2-axboe@kernel.dk>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

> +	/*
> +	 * Synchronous dio, task itself will handle any completion work
> +	 * that needs after IO. All we need to do is wake the task.
> +	 */
> +	if (dio->wait_for_completion) {
> +		struct task_struct *waiter = dio->submit.waiter;
> +		WRITE_ONCE(dio->submit.waiter, NULL);

I know the existing code got it wrong, but can you please add an empty
line after the variable declaration here?

> +	/*
> +	 * If this dio is an async write, queue completion work for async
> +	 * handling. Reads can always complete inline.
> +	 */
> +	if (dio->flags & IOMAP_DIO_WRITE) {
> +		struct inode *inode = file_inode(iocb->ki_filp);
> +
> +		WRITE_ONCE(iocb->private, NULL);
> +		INIT_WORK(&dio->aio.work, iomap_dio_complete_work);
> +		queue_work(inode->i_sb->s_dio_done_wq, &dio->aio.work);
> +	} else {

If we already do the goto style I'd probably do it here as well instead
of the else.

Otherwise this looks good to me.

