Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B31BA593101
	for <lists+io-uring@lfdr.de>; Mon, 15 Aug 2022 16:50:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229511AbiHOOuH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 15 Aug 2022 10:50:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiHOOuG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 15 Aug 2022 10:50:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88BE56541;
        Mon, 15 Aug 2022 07:50:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 361D6B80EC3;
        Mon, 15 Aug 2022 14:50:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 728FEC433D6;
        Mon, 15 Aug 2022 14:50:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660575001;
        bh=ylHwb8GnW4mKnvCGhekt3YkVExe8xUsilBbYoT7KZb4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EdyhId0BwPGiZ6A/BgzoEKxUa0LMIaolxjYwP4gNK5sjwxNNIxmM4zV2KkTHPQWLp
         TzbRtB8O3lurs1gUh2aDezNGVnRtirYSn0oy9mQVve2jjZuG7+VI+4f1guJLMLhU/C
         5yeJ47uCsVTO5Gpiy6gPs/nScuPYXgsgAEmS2vQkDVZMeqhg/mtQNfFdO7pZCQHsZe
         YhifxvemIhbZDcMhWHPvljQbKUjO5VHN2ryqkEWaor20jtmXxusuOi9sUOWL/Jc5Nj
         q8zuLefvl+TKks6GxvZiJoSTBNwhWnpC/NNy51gVB+NWLKgm/tAXn0If3hO8IOOH0Q
         Gtjcw1+1jeXGw==
Date:   Mon, 15 Aug 2022 08:49:58 -0600
From:   Keith Busch <kbusch@kernel.org>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Keith Busch <kbusch@fb.com>, axboe@kernel.dk,
        io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] fs: don't randomized kiocb fields
Message-ID: <YvpdFqsSafBnrNCj@kbusch-mbp.dhcp.thefacebook.com>
References: <20220812225633.3287847-1-kbusch@fb.com>
 <YvjP95SEuuEY7+Uo@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YvjP95SEuuEY7+Uo@casper.infradead.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sun, Aug 14, 2022 at 11:35:35AM +0100, Matthew Wilcox wrote:
> On Fri, Aug 12, 2022 at 03:56:33PM -0700, Keith Busch wrote:
> >  struct kiocb {
> >  	struct file		*ki_filp;
> > -
> > -	/* The 'ki_filp' pointer is shared in a union for aio */
> > -	randomized_struct_fields_start
> > -
> >  	loff_t			ki_pos;
> >  	void (*ki_complete)(struct kiocb *iocb, long ret);
> >  	void			*private;
> >  	int			ki_flags;
> >  	u16			ki_ioprio; /* See linux/ioprio.h */
> >  	struct wait_page_queue	*ki_waitq; /* for async buffered IO */
> > -	randomized_struct_fields_end
> >  };
> 
> Now that I've read the thread ...
> 
> If we care about struct size on 32-bit, we should fit something into
> the 32-bit hole before the 64-bit loff_t (assuming at least some 32-bit
> arches want loff_t to be 64-bit aligned; I thik x86 doesn't?)
> Easiest seems to be to put ki_complete before ki_pos?

Yes, that would be a better compact arrangment. The immediate need was just to
correct io_uring's max command struct size. The 32-bit verison isn't near the
limit, so no additional optimizations were done in this patch. 
