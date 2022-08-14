Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BF67591F90
	for <lists+io-uring@lfdr.de>; Sun, 14 Aug 2022 12:35:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231372AbiHNKfu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 14 Aug 2022 06:35:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229723AbiHNKft (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 14 Aug 2022 06:35:49 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDAA963D7;
        Sun, 14 Aug 2022 03:35:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=unBpQX/o/jdFbi5PDF32+lpRec8s1wLKO6YAY+7b0pk=; b=hc5Hj2cpu/Sj+ozro2hjKywwA0
        VC1qciWJdmhx7yiF70Sekrt370qK6svkkAp+D0jU5UzGVz+ZOI20if+e/5tF7zzW5i7YHYJjBwEiw
        2bez5llQSrEhFvdt9JorFS6DZdvJ8Jz1CgC6GDrcsHYHCelX3E/PtPKXq6zCItgNgBT6kE2c9mA3o
        NoWeGR+U5g546aDMigFvyGdO8YhSKfLv37oQtst+cn9WviMbqSF65+TZb6gezsvwtUzHlsAzvvhL/
        dO22jlTWgxUb2iUy2DR3AL97EmqliwfYc9Yb0lDVev6PAGc/xH72cgB3BqIpkGikIqpyiNTWpcb55
        35b5CwJg==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oNAxz-004iD8-Ih; Sun, 14 Aug 2022 10:35:35 +0000
Date:   Sun, 14 Aug 2022 11:35:35 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Keith Busch <kbusch@fb.com>
Cc:     axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Keith Busch <kbusch@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] fs: don't randomized kiocb fields
Message-ID: <YvjP95SEuuEY7+Uo@casper.infradead.org>
References: <20220812225633.3287847-1-kbusch@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220812225633.3287847-1-kbusch@fb.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Aug 12, 2022 at 03:56:33PM -0700, Keith Busch wrote:
>  struct kiocb {
>  	struct file		*ki_filp;
> -
> -	/* The 'ki_filp' pointer is shared in a union for aio */
> -	randomized_struct_fields_start
> -
>  	loff_t			ki_pos;
>  	void (*ki_complete)(struct kiocb *iocb, long ret);
>  	void			*private;
>  	int			ki_flags;
>  	u16			ki_ioprio; /* See linux/ioprio.h */
>  	struct wait_page_queue	*ki_waitq; /* for async buffered IO */
> -	randomized_struct_fields_end
>  };

Now that I've read the thread ...

If we care about struct size on 32-bit, we should fit something into
the 32-bit hole before the 64-bit loff_t (assuming at least some 32-bit
arches want loff_t to be 64-bit aligned; I thik x86 doesn't?)
Easiest seems to be to put ki_complete before ki_pos?
