Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 847EC1682DC
	for <lists+io-uring@lfdr.de>; Fri, 21 Feb 2020 17:12:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727137AbgBUQMG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 21 Feb 2020 11:12:06 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:36910 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727039AbgBUQMG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 21 Feb 2020 11:12:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=jO1rG1z8nFFcRcatXTx8R6dstzQDlOlE/07mv+ckS7E=; b=t/AspgcLoJczSqj/FCHd3S2H18
        SKwgLIlQbtvxxqwhwwCL2aiqnevVe7od3lHN3Wymv+KccPDjol06mcYgZxprteMQcqYrul89jDSQH
        yP/l1pjS+pETb9X6pRel31t7rHGVBRmPZ+n/qq/8E+MdmxJWZMd2dOGykJjkx+elyR1nJAkIr4TWf
        urbKOk36pxMr7IFbXwoXeeavzfDyjgoGesXJ7hP8xrGpuMhhm7KyAOmrc7iohjs3JTZ5aDOGy4Obr
        UzLg6pQn3Do4dVPyZL33XWfM9G3cRgFvLsd0FVEBqiLYbPmt/9dTVLnDFYFypvmzRaOzCoJnUEvP9
        WlHoMcuQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j5AuJ-0005OW-U8; Fri, 21 Feb 2020 16:12:04 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 0768A304D2C;
        Fri, 21 Feb 2020 17:10:09 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 4CFDF2B26B892; Fri, 21 Feb 2020 17:12:02 +0100 (CET)
Date:   Fri, 21 Feb 2020 17:12:02 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Jann Horn <jannh@google.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>,
        Glauber Costa <glauber@scylladb.com>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH 7/9] io_uring: add per-task callback handler
Message-ID: <20200221161202.GY14897@hirez.programming.kicks-ass.net>
References: <20200220203151.18709-1-axboe@kernel.dk>
 <20200220203151.18709-8-axboe@kernel.dk>
 <CAG48ez1sQi7ntGnLxyo9X_642-wr55+Kn662XyyEYGLyi0iLwQ@mail.gmail.com>
 <20200221104740.GE18400@hirez.programming.kicks-ass.net>
 <7e8d4355-fd2c-b155-b28c-57fd20db949d@kernel.dk>
 <CAG48ez3Bc6gCVX7Gd2mFDR=ktGE0M_H+s6pHao2NjUrbxub20w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG48ez3Bc6gCVX7Gd2mFDR=ktGE0M_H+s6pHao2NjUrbxub20w@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Feb 21, 2020 at 04:02:36PM +0100, Jann Horn wrote:
> On Fri, Feb 21, 2020 at 3:49 PM Jens Axboe <axboe@kernel.dk> wrote:
> > On 2/21/20 3:47 AM, Peter Zijlstra wrote:

> > > But I thought to understand that these sched_work things were only
> > > queued on tasks that were stuck waiting on POLL (or it's io_uring
> > > equivalent). Earlier patches were explicitly running things from
> > > io_cqring_wait(), which might have given me this impression.
> >
> > No, that is correct.
> 
> Really? I was pretty sure that io_uring does not force the calling
> thread to block on the io_uring operations to continue; and isn't that
> the whole point?
> 
> I think that when Peter says "stuck waiting on POLL", he really means
> "blocked in the context of sys_io_uring_enter() and can't go
> anywhere";

Exactly.

> while I think you interpret it as "has pending POLL work
> queued up in the background and may decide to wait for it in
> sys_io_uring_enter(), but might also be doing anything else".

In which case it can hit schedule() at some random point before it gets
to io_uring_cqring_wait().
