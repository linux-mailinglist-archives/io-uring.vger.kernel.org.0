Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D19546C1EC1
	for <lists+io-uring@lfdr.de>; Mon, 20 Mar 2023 18:59:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230419AbjCTR7c (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 20 Mar 2023 13:59:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230128AbjCTR7L (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 20 Mar 2023 13:59:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A06B2ED50;
        Mon, 20 Mar 2023 10:54:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 766D56172A;
        Mon, 20 Mar 2023 17:52:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E289C433EF;
        Mon, 20 Mar 2023 17:52:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679334774;
        bh=fgu3bIXpq/CwTvowavZJdFC+5H2tqx5MhT0vWxeriWU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TGOUeQvqWM100G5iZzYS6ftLyF30Fzlimiu7rTF/4UrYERrI7DLDf9rfvMIIM9Bvg
         GNDLGibCG9mwVApBnVgGehG4amrnysRZBJo1jQc233mw9dooJn05Z72FpCp4U1PQp+
         lV9bMxB+F5kdKVQLb7CVmpdyP08xVgF3w1573Gd9AJESVRIGY1gFhb8saC6tD4AY2a
         6CyqEnw/zokZuoAD/DP7nzZN3KWf45iGTdFgXxFoMqmOApk0p7/WwwvEjWowHtefVH
         5J8bdJgH8l9oGyhrta5wnijiC3CRqWc4KfS6Y5Fd1RwF13WxumkCg4Ejn0ZGbC3Trd
         U9A4M3IYv2DEA==
Date:   Mon, 20 Mar 2023 11:52:52 -0600
From:   Keith Busch <kbusch@kernel.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Keith Busch <kbusch@meta.com>, linux-block@vger.kernel.org,
        io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH] blk-mq: remove hybrid polling
Message-ID: <ZBiddGnl0tEbhg43@kbusch-mbp.dhcp.thefacebook.com>
References: <20230320161205.1714865-1-kbusch@meta.com>
 <5aecde5b-c709-c8b3-28cd-5a361bd492b9@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5aecde5b-c709-c8b3-28cd-5a361bd492b9@kernel.dk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Mar 20, 2023 at 11:16:40AM -0600, Jens Axboe wrote:
> > diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
> > index f1fce1c7fa44b..c6c231f3d0f10 100644
> > --- a/block/blk-sysfs.c
> > +++ b/block/blk-sysfs.c
> > @@ -408,36 +408,7 @@ queue_rq_affinity_store(struct request_queue *q, const char *page, size_t count)
> >  
> >  static ssize_t queue_poll_delay_show(struct request_queue *q, char *page)
> >  {
> > -	int val;
> > -
> > -	if (q->poll_nsec == BLK_MQ_POLL_CLASSIC)
> > -		val = BLK_MQ_POLL_CLASSIC;
> > -	else
> > -		val = q->poll_nsec / 1000;
> > -
> > -	return sprintf(page, "%d\n", val);
> > -}
> > -
> > -static ssize_t queue_poll_delay_store(struct request_queue *q, const char *page,
> > -				size_t count)
> > -{
> > -	int err, val;
> > -
> > -	if (!q->mq_ops || !q->mq_ops->poll)
> > -		return -EINVAL;
> > -
> > -	err = kstrtoint(page, 10, &val);
> > -	if (err < 0)
> > -		return err;
> > -
> > -	if (val == BLK_MQ_POLL_CLASSIC)
> > -		q->poll_nsec = BLK_MQ_POLL_CLASSIC;
> > -	else if (val >= 0)
> > -		q->poll_nsec = val * 1000;
> > -	else
> > -		return -EINVAL;
> > -
> > -	return count;
> > +	return sprintf(page, "%d\n", -1);
> >  }
> 
> Do we want to retain the _store setting here to avoid breaking anything?

I was thinking users would want to know the kernel isn't going to honor the
requested value. Errors can already happen if you're using a stacked device, so
I assmued removing '_store' wouldn't break anyone using this interface.

But I can see it both ways though, so whichever you prefer. At the very least,
though, I need to update Documentation's sysfs-block, so I'll do that in the
v2.
