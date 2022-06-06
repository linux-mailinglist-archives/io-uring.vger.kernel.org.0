Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBB4853EE5F
	for <lists+io-uring@lfdr.de>; Mon,  6 Jun 2022 21:18:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229928AbiFFTS3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 6 Jun 2022 15:18:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230475AbiFFTS2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 6 Jun 2022 15:18:28 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69939AFAF8;
        Mon,  6 Jun 2022 12:18:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Y8ptkrk4XEC5HIV2odtW0wPcnRHidH2SG3SnYcDw0Hs=; b=QdoGU4CiwUKCth0VhVwplDeCdu
        zCK2eocNCW437F9lFD8iWu41aTBLdaa/9qKsfP3RNJlu+lSUBroQLT2R4wXUa6NQbqfkM2BfyxPzY
        A4VQmBpcUqeHsBjgTmjFxC/BcjGBUsUk2L86FhL5RYTRCtGaSElPT5ho/T5aHRPH1A3yt3q0LaVcV
        xXENhNaFeSjubGSi2fyCfbeDEGDUmcnx+aU6eR+F22y0v7wNxXip7aqyeDCH1cY949dfZsLTHHcGm
        AOruk84wSlZ3VlWQdZXM5Q4PHoxwVM9UTzNOgQ87q6fTDJdgmUUCH4xTsmzYTf6SJ7HGDd4EmLtSw
        EEGh+4LQ==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nyIEw-00AwKS-7d; Mon, 06 Jun 2022 19:18:14 +0000
Date:   Mon, 6 Jun 2022 20:18:14 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Stefan Roesch <shr@fb.com>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com, jack@suse.cz, hch@infradead.org,
        axboe@kernel.dk
Subject: Re: [PATCH v7 06/15] iomap: Return error code from iomap_write_iter()
Message-ID: <Yp5S9pRPKHbAgcsU@casper.infradead.org>
References: <20220601210141.3773402-1-shr@fb.com>
 <20220601210141.3773402-7-shr@fb.com>
 <YpivQhqhZxwvdDUm@casper.infradead.org>
 <0f83316c-3aa2-3cb6-ede1-c2dd2dd3ab31@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0f83316c-3aa2-3cb6-ede1-c2dd2dd3ab31@fb.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Jun 06, 2022 at 09:39:03AM -0700, Stefan Roesch wrote:
> 
> 
> On 6/2/22 5:38 AM, Matthew Wilcox wrote:
> > On Wed, Jun 01, 2022 at 02:01:32PM -0700, Stefan Roesch wrote:
> >> Change the signature of iomap_write_iter() to return an error code. In
> >> case we cannot allocate a page in iomap_write_begin(), we will not retry
> >> the memory alloction in iomap_write_begin().
> > 
> > loff_t can already represent an error code.  And it's already used like
> > that.
> > 
> >> @@ -829,7 +830,8 @@ static loff_t iomap_write_iter(struct iomap_iter *iter, struct iov_iter *i)
> >>  		length -= status;
> >>  	} while (iov_iter_count(i) && length);
> >>  
> >> -	return written ? written : status;
> >> +	*processed = written ? written : error;
> >> +	return error;
> > 
> > I think the change you really want is:
> > 
> > 	if (status == -EAGAIN)
> > 		return -EAGAIN;
> > 	if (written)
> > 		return written;
> > 	return status;
> > 
> 
> I think the change needs to be:
> 
> -    return written ? written : status;
> +    if (status == -EAGAIN) {
> +        iov_iter_revert(i, written);
> +        return -EAGAIN;
> +    }
> +    if (written)
> +        return written;
> +    return status;

Ah yes, I think you're right.

Does it work to leave everything the way it is, call back into the
iomap_write_iter() after having done a short write, get the -EAGAIN at
that point and pass the already-advanced iterator to the worker thread?
I haven't looked into the details of how that works, so maybe you just
can't do that.
