Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A67D712CC28
	for <lists+io-uring@lfdr.de>; Mon, 30 Dec 2019 04:33:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727069AbfL3DdY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 29 Dec 2019 22:33:24 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:37627 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727065AbfL3DdY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 29 Dec 2019 22:33:24 -0500
Received: by mail-pj1-f67.google.com with SMTP id m13so7555503pjb.2;
        Sun, 29 Dec 2019 19:33:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=dTiS/bb9/IUvx30njlXM5Xv38N7wkzS/VlkisOuoWMY=;
        b=uBTj8C8TM2DJlBhULD6ZRwZiambfl6N5LgWATb8Yf64Ce7diTzA0G1woSQ5bEuA5ui
         xPjWveLyg3uRk3Kks72zu2VZ3r6ImHz8d42Jz+1ws7z8/6I/nfBRX7/zfRNwe36W82T9
         xWxC1Q0FOSAvwQS7cEd+RPHpZrRvtIg3jj0+b2I6BlHMMtyBAmDwuKVGN6NJwD8jKeV3
         jEDcUPISakBYA60yi14uqEn9QqS3HB2BrijQlMt2CxTtp2vRPw+lMyp5kF5g825ZM2Aa
         cCKwuB4TK6Ch8Tz7V8vjBulBABJo1pi20+W3r8feqxa1sedgM34w4iAIu+S6dTbJ9t1v
         lDng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=dTiS/bb9/IUvx30njlXM5Xv38N7wkzS/VlkisOuoWMY=;
        b=fCaR0vkzQxexqsv99kBD+PbISmbzD+uF6C1Grumw0axaC1DlXfKsQSOb2lFiOpFOg8
         4ha9wPDNYyuh8zMytP++1V6h3Bp8gJ7ZSLUu0d9sluZxMKT2BJezN4yx66egHX+rAXtY
         Mu6O5zzM8cJ1IYkilAWwHuA14/aS6HAfg93eGyaYM8J7yh0SvnDvRfjfZUpnjuRQuhmo
         B7iQrdfanyEEc9P7D3TrX6hkBbvL5iMmpBZeA9Qff6uQ6mLM9d6CAduWom/+4Md4F8Je
         qFJGR1nFVb/7Pp3WOn0R3++lGr9iCO0OI/bTpjnFXhbw/L5zXBSFe7E9oNI1RrGzRD+e
         8OZg==
X-Gm-Message-State: APjAAAWkXeICaozP3q7W4MI0ubDVBGjGwewQs/GRuy2IqUu9YJRSY+sg
        led5nwXviV0OYMMBOgO7g6Y=
X-Google-Smtp-Source: APXvYqyQ3LT8HrcWP6ZAYpoYYT6nU+ur+WsnY+DzoF0GtcfyTDItr1NfI+OZRBiUKICBreJWu64dMw==
X-Received: by 2002:a17:90b:258:: with SMTP id fz24mr41756743pjb.6.1577676803945;
        Sun, 29 Dec 2019 19:33:23 -0800 (PST)
Received: from lmao.redmond.corp.microsoft.com (c-24-143-123-17.customer.broadstripe.net. [24.143.123.17])
        by smtp.gmail.com with ESMTPSA id j6sm12993266pjv.10.2019.12.29.19.33.23
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 29 Dec 2019 19:33:23 -0800 (PST)
Date:   Sun, 29 Dec 2019 19:33:22 -0800
From:   Brian Gianforcaro <b.gianfo@gmail.com>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 2/2] io_uring: batch getting pcpu references
Message-ID: <20191230033321.kg2e4ijj2w3ut36l@lmao.redmond.corp.microsoft.com>
References: <cover.1577528535.git.asml.silence@gmail.com>
 <1250dad37e9b73d39066a8b464f6d2cab26eef8a.1577528535.git.asml.silence@gmail.com>
 <6facf552-924f-2af1-03e5-99957a90bfd0@gmail.com>
 <e0c5f132-b916-4710-a0f3-036e4df07c69@kernel.dk>
 <504de70b-f323-4ad1-6b40-4e73aa610643@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <504de70b-f323-4ad1-6b40-4e73aa610643@gmail.com>
User-Agent: NeoMutt/20171215
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sat, Dec 28, 2019 at 09:37:35PM +0300, Pavel Begunkov wrote:
> On 28/12/2019 20:03, Jens Axboe wrote:
> > On 12/28/19 4:15 AM, Pavel Begunkov wrote:
> >> On 28/12/2019 14:13, Pavel Begunkov wrote:
> >>> percpu_ref_tryget() has its own overhead. Instead getting a reference
> >>> for each request, grab a bunch once per io_submit_sqes().
> >>>
> >>> ~5% throughput boost for a "submit and wait 128 nops" benchmark.
> >>>
> >>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> >>> ---
> >>>  fs/io_uring.c | 26 +++++++++++++++++---------
> >>>  1 file changed, 17 insertions(+), 9 deletions(-)
> >>>
> >>> diff --git a/fs/io_uring.c b/fs/io_uring.c
> >>> index 7fc1158bf9a4..404946080e86 100644
> >>> --- a/fs/io_uring.c
> >>> +++ b/fs/io_uring.c
> >>> @@ -1080,9 +1080,6 @@ static struct io_kiocb *io_get_req(struct io_ring_ctx *ctx,
> >>>  	gfp_t gfp = GFP_KERNEL | __GFP_NOWARN;
> >>>  	struct io_kiocb *req;
> >>>  
> >>> -	if (!percpu_ref_tryget(&ctx->refs))
> >>> -		return NULL;
> >>> -
> >>>  	if (!state) {
> >>>  		req = kmem_cache_alloc(req_cachep, gfp);
> >>>  		if (unlikely(!req))
> >>> @@ -1141,6 +1138,14 @@ static void io_free_req_many(struct io_ring_ctx *ctx, void **reqs, int *nr)
> >>>  	}
> >>>  }
> >>>  
> >>> +static void __io_req_free_empty(struct io_kiocb *req)
> >>
> >> If anybody have better naming (or a better approach at all), I'm all ears.
> > 
> > __io_req_do_free()?
> 
> Not quite clear what's the difference with __io_req_free() then
> 
> > 
> > I think that's better than the empty, not quite sure what that means.
> 
> Probably, so. It was kind of "request without a bound sqe".
> Does io_free_{hollow,empty}_req() sound better?

Given your description, perhaps io_free_unbound_req() makes sense?
