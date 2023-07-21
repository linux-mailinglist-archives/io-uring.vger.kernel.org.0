Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2F8775CFFF
	for <lists+io-uring@lfdr.de>; Fri, 21 Jul 2023 18:47:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbjGUQrs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 21 Jul 2023 12:47:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbjGUQrr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 21 Jul 2023 12:47:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F2EF12F;
        Fri, 21 Jul 2023 09:47:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A137361D50;
        Fri, 21 Jul 2023 16:47:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09D3DC433C7;
        Fri, 21 Jul 2023 16:47:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689958065;
        bh=KUKwEaMykdwqNvUL+ZYHtoL8XBHJpadr1bnabFARW3I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=t4vI34FuRX7ajXljtzx+wEvVNXtZYK14oaglZDRUpFoETYdCfe7Igr6bNt6yRvMo0
         ljIRUD+yIzQP9FQeDay0bpOOJz5O8DMsw5IzD65uwqemJWdvqFMDQGD7qUghuaIxTX
         R0tyjAHuqZlisq3hZbjenhs3FM6yUNnISo4GQvoZFLoBW8+F4V37kWRJY5qNxlE9EH
         kwF4lnyJlczXbI++aERF4qsFD3P/piPK/Fre/UjJadIKDghK/+DNnXb0j3FCy4BfAl
         7760eDfvnRjbB7CiYjcvA8jlVlp2l2BafchHWxyG6l9lnPxTRUK++D9IDn0j1qb4D7
         l6q1Bp6qUmYTg==
Date:   Fri, 21 Jul 2023 09:47:44 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de,
        andres@anarazel.de, david@fromorbit.com
Subject: Re: [PATCH 3/9] iomap: treat a write through cache the same as FUA
Message-ID: <20230721164744.GW11352@frogsfrogsfrogs>
References: <20230721161650.319414-1-axboe@kernel.dk>
 <20230721161650.319414-4-axboe@kernel.dk>
 <20230721162553.GS11352@frogsfrogsfrogs>
 <4fcc44be-f2da-9a7c-03ca-f7e38ac147cb@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4fcc44be-f2da-9a7c-03ca-f7e38ac147cb@kernel.dk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Jul 21, 2023 at 10:27:16AM -0600, Jens Axboe wrote:
> On 7/21/23 10:25?AM, Darrick J. Wong wrote:
> >> @@ -560,12 +562,15 @@ __iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
> >>  
> >>  		       /*
> >>  			* For datasync only writes, we optimistically try
> >> -			* using FUA for this IO.  Any non-FUA write that
> >> -			* occurs will clear this flag, hence we know before
> >> -			* completion whether a cache flush is necessary.
> >> +			* using WRITE_THROUGH for this IO. Stable writes are
> > 
> > "...using WRITE_THROUGH for this IO.  This flag requires either FUA
> > writes through the device's write cache, or a normal write..."
> > 
> >> @@ -627,10 +632,10 @@ __iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
> >>  		iomap_dio_set_error(dio, ret);
> >>  
> >>  	/*
> >> -	 * If all the writes we issued were FUA, we don't need to flush the
> >> +	 * If all the writes we issued were stable, we don't need to flush the
> > 
> > "If all the writes we issued were already written through to the media,
> > we don't need to flush..."
> > 
> > With those fixes,
> > Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> 
> If you're queueing up this series, could you just make those two edits
> while applying? I don't want to spam resend with just a comment change,
> at least if I can avoid it...

How about pushing the updated branch, tagging it with the cover letter
as the message, and sending me a pull request?  Linus has been very
receptive to preserving cover letters this way.

--D

> -- 
> Jens Axboe
> 
