Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B90A45653D
	for <lists+io-uring@lfdr.de>; Thu, 18 Nov 2021 22:58:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230105AbhKRWBu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 18 Nov 2021 17:01:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:49286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229472AbhKRWBt (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Thu, 18 Nov 2021 17:01:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DD99661220;
        Thu, 18 Nov 2021 21:58:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637272729;
        bh=qRyDXwaTe3qUn3q5rUCnxzGRTuX1TapIqNvlx4tcXq8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=xVqkWFkv5mEQQCTHGzAUSOSOOpzbkwrzNTEjZhCij945qEou5kB0ARDQ8HOY50KJs
         dFf7SMnq735dbLhsJv0UuGx5ni+N28ON008MIQI8nhme70J9p+5Jd4WCwE6i6TESmN
         TZXV5bsYmQAchyzzs6EI4mNzygJz9Bfs5eWqyRF4=
Date:   Thu, 18 Nov 2021 13:58:46 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Johannes Weiner <hannes@cmpxchg.org>,
        Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Drew DeVault <sir@cmpwn.com>, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org,
        io_uring Mailing List <io-uring@vger.kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>, linux-mm@kvack.org
Subject: Re: [PATCH] Increase default MLOCK_LIMIT to 8 MiB
Message-Id: <20211118135846.26da93737a70d486e68462bf@linux-foundation.org>
In-Reply-To: <ec24ff4e-8413-914c-7cdf-203a7a5f0586@kernel.dk>
References: <20211028080813.15966-1-sir@cmpwn.com>
        <CAFBCWQ+=2T4U7iNQz_vsBsGVQ72s+QiECndy_3AMFV98bMOLow@mail.gmail.com>
        <CFII8LNSW5XH.3OTIVFYX8P65Y@taiga>
        <593aea3b-e4a4-65ce-0eda-cb3885ff81cd@gnuweeb.org>
        <20211115203530.62ff33fdae14927b48ef6e5f@linux-foundation.org>
        <YZWBkZHdsh5LtWSG@cmpxchg.org>
        <ec24ff4e-8413-914c-7cdf-203a7a5f0586@kernel.dk>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, 17 Nov 2021 16:17:26 -0700 Jens Axboe <axboe@kernel.dk> wrote:

> On 11/17/21 3:26 PM, Johannes Weiner wrote:
> >> Link: https://lkml.kernel.org/r/20211028080813.15966-1-sir@cmpwn.com
> >> Signed-off-by: Drew DeVault <sir@cmpwn.com>
> >> Acked-by: Jens Axboe <axboe@kernel.dk>
> >> Acked-by: Cyril Hrubis <chrubis@suse.cz>
> >> Cc: Pavel Begunkov <asml.silence@gmail.com>
> >> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > 
> > Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> > 
> > As per above, I think basing it off of RAM size would be better, but
> > this increase is overdue given all the new users beyond mlock(), and
> > 8M is much better than the current value.
> 
> That's basically my reasoning too. Let's just get something going that
> will at least unblock some valid use cases, and not get bogged down with
> aiming for perfection. The latter can happen in parallel, but it should
> not hold it up imho.

Nobody's aiming for perfection.  We're discussing aiming for "better".

What we should have done on day one was to set the default MLOCK_LIMIT
to zero bytes.  Then everyone would have infrastructure to tune it from
userspace and we wouldn't ever have this discussion.
