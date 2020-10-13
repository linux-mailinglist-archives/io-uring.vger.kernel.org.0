Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E29228CDA3
	for <lists+io-uring@lfdr.de>; Tue, 13 Oct 2020 14:02:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727440AbgJMMBZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 13 Oct 2020 08:01:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728880AbgJMMBW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 13 Oct 2020 08:01:22 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17DD1C0613D0
        for <io-uring@vger.kernel.org>; Tue, 13 Oct 2020 05:01:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=nGSQDj4jA0m6sANkGtqZGLzb1UI0qYH2Ar16VGRbXF4=; b=csFRzz8WMszJ5i6gxkQGMgqTD6
        /LvPP7UhO/574MHoHGQ1DSaFJZbURVNqhiR4Dkf3qDKdog/Hwf+SZaAK3klEoP8JzlAhD+jCSt2eQ
        GubisM65AP9UzOo6H1Z9UYe8bDMA+INWD+HotblhC3SP/DCFwvXXz7vig+lgxlengw0417Sib9xL8
        dIX6dGGL9Vs/w0Eir2FRV2b3lWNQqJ6lfc/anFlE6p/CjkC/9+Y3rOIXFApjBw/WV/LgoHgHNauIT
        y/m+JrqDtEno/9IsLa5ivTpgcb5QwW9hVTLHu1G5Q9iFMIFCkt+To18ebXTi1Lu8cLLY3RzavV6ZU
        abJGshEA==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kSIzX-0004IL-Oq; Tue, 13 Oct 2020 12:01:19 +0000
Date:   Tue, 13 Oct 2020 13:01:19 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Hao_Xu <haoxu@linux.alibaba.com>
Cc:     io-uring@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: Loophole in async page I/O
Message-ID: <20201013120119.GD20115@casper.infradead.org>
References: <20201012211355.GC20115@casper.infradead.org>
 <6e341fd1-bd2a-7774-5323-41f3a0531295@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6e341fd1-bd2a-7774-5323-41f3a0531295@linux.alibaba.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Oct 13, 2020 at 01:13:48PM +0800, Hao_Xu wrote:
> 在 2020/10/13 上午5:13, Matthew Wilcox 写道:
> > This one's pretty unlikely, but there's a case in buffered reads where
> > an IOCB_WAITQ read can end up sleeping.
> > 
> > generic_file_buffered_read():
> >                  page = find_get_page(mapping, index);
> > ...
> >                  if (!PageUptodate(page)) {
> > ...
> >                          if (iocb->ki_flags & IOCB_WAITQ) {
> > ...
> >                                  error = wait_on_page_locked_async(page,
> >                                                                  iocb->ki_waitq);
> > wait_on_page_locked_async():
> >          if (!PageLocked(page))
> >                  return 0;
> > (back to generic_file_buffered_read):
> >                          if (!mapping->a_ops->is_partially_uptodate(page,
> >                                                          offset, iter->count))
> >                                  goto page_not_up_to_date_locked;
> > 
> > page_not_up_to_date_locked:
> >                  if (iocb->ki_flags & (IOCB_NOIO | IOCB_NOWAIT)) {
> >                          unlock_page(page);
> >                          put_page(page);
> >                          goto would_block;
> >                  }
> > ...
> >                  error = mapping->a_ops->readpage(filp, page);
> > (will unlock page on I/O completion)
> >                  if (!PageUptodate(page)) {
> >                          error = lock_page_killable(page);
> > 
> > So if we have IOCB_WAITQ set but IOCB_NOWAIT clear, we'll call ->readpage()
> > and wait for the I/O to complete.  I can't quite figure out if this is
> > intentional -- I think not; if I understand the semantics right, we
> > should be returning -EIOCBQUEUED and punting to an I/O thread to
> > kick off the I/O and wait.
> > 
> > I think the right fix is to return -EIOCBQUEUED from
> > wait_on_page_locked_async() if the page isn't locked.  ie this:
> > 
> > @@ -1258,7 +1258,7 @@ static int wait_on_page_locked_async(struct page *page,
> >                                       struct wait_page_queue *wait)
> >   {
> >          if (!PageLocked(page))
> > -               return 0;
> > +               return -EIOCBQUEUED;
> >          return __wait_on_page_locked_async(compound_head(page), wait, false);
> >   }
> > But as I said, I'm not sure what the semantics are supposed to be.
> > 
> Hi Matthew,
> which kernel version are you use, I believe I've fixed this case in the
> commit c8d317aa1887b40b188ec3aaa6e9e524333caed1

Ah, I don't have that commit in my tree.

Nevertheless, there is still a problem.  The ->readpage implementation
is not required to execute asynchronously.  For example, it may enter
page reclaim by using GFP_KERNEL.  Indeed, I feel it is better if it
works synchronously as it can then report the actual error from an I/O
instead of the almost-meaningless -EIO.

This patch series documents 12 filesystems which implement ->readpage
in a synchronous way today (for at least some cases) and converts iomap
to be synchronous (making two more filesystems synchronous).

https://lore.kernel.org/linux-fsdevel/20201009143104.22673-1-willy@infradead.org/

