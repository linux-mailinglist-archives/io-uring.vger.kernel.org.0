Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C10B975BEB8
	for <lists+io-uring@lfdr.de>; Fri, 21 Jul 2023 08:21:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230470AbjGUGV2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 21 Jul 2023 02:21:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230476AbjGUGVF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 21 Jul 2023 02:21:05 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D30244AD;
        Thu, 20 Jul 2023 23:18:07 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 4E31D6732D; Fri, 21 Jul 2023 08:18:04 +0200 (CEST)
Date:   Fri, 21 Jul 2023 08:18:04 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de,
        andres@anarazel.de, david@fromorbit.com
Subject: Re: [PATCH 5/8] iomap: only set iocb->private for polled bio
Message-ID: <20230721061804.GE20600@lst.de>
References: <20230720181310.71589-1-axboe@kernel.dk> <20230720181310.71589-6-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230720181310.71589-6-axboe@kernel.dk>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Jul 20, 2023 at 12:13:07PM -0600, Jens Axboe wrote:
> iocb->private is only used for polled IO, where the completer will
> find the bio to poll through that field.
> 
> Assign it when we're submitting a polled bio, and get rid of the
> dio->poll_bio indirection.

Nice, with the current shape of the code poll_bio can indeed go away.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
