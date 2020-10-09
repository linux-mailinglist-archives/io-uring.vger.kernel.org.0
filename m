Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBE5D28901A
	for <lists+io-uring@lfdr.de>; Fri,  9 Oct 2020 19:37:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732934AbgJIRgf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 9 Oct 2020 13:36:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732882AbgJIRgW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 9 Oct 2020 13:36:22 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 942DFC0613D2;
        Fri,  9 Oct 2020 10:36:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=fpwKpB0QRMQy9tLZQv1g7PmBUfEuKMv/BEO55MnQHTc=; b=epj475FdxE/6piVligw7f/O1Gg
        C51sXJjusavAgwM0+vopbw1kAT6F8MeRMLuZqu9GF5kosFlBr0DMLgR2b+U5Cih/1Kg6WOrmU7ufb
        ceowujvqt7mbx32fx0QHFLbrRyRmMZ7GHavqZM/eb1rc9k+kpVfntqs8R9aKVI/A+Mt1LLcmAHwJ3
        pBzpV08VvjTAfGqihoUByDmRGPVtJNbnKEbbeYz9rCPLqWJ5x4g0YEHuNmtfXvgQ2Uy/yPxJF4E/c
        7MtAAMQ8f8VyU2MrKUfpkE7D6wq4rWwqK3OU7ICBl31srqQhYEPyab/V682eiyCfvlN2kjP2Rcugr
        SeLThKMA==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kQwJY-0001Eh-D3; Fri, 09 Oct 2020 17:36:20 +0000
Date:   Fri, 9 Oct 2020 18:36:20 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH 2/3] io_uring: Fix XArray usage in io_uring_add_task_file
Message-ID: <20201009173620.GV20115@casper.infradead.org>
References: <20201009124954.31830-1-willy@infradead.org>
 <20201009124954.31830-2-willy@infradead.org>
 <0746e0aa-cb81-0fde-5405-acb1e61b6854@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0746e0aa-cb81-0fde-5405-acb1e61b6854@kernel.dk>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Oct 09, 2020 at 08:57:55AM -0600, Jens Axboe wrote:
> > +	if (unlikely(!cur_uring)) {
> >  		int ret;
> >  
> >  		ret = io_uring_alloc_task_context(current);
> >  		if (unlikely(ret))
> >  			return ret;
> >  	}
> 
> I think this is missing a:
> 
> 	cur_uring = current->io_uring;
> 
> after the successful io_uring_alloc_task(). I'll also rename it to tctx
> like what is used in other spots.

Quite right!  I should have woken up a little bit more before writing code.

> Apart from that, series looks good to me, thanks Matthew!

NP.  At some point, I'd like to understand a bit better how you came
to write the code the way you did, so I can improve the documentation.
Maybe I just need to strengthen the warnings to stay away from the
advanced API unless you absolutely need it.
