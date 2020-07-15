Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DA7122135C
	for <lists+io-uring@lfdr.de>; Wed, 15 Jul 2020 19:11:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725838AbgGORLl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Jul 2020 13:11:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725770AbgGORLk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Jul 2020 13:11:40 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4394C061755;
        Wed, 15 Jul 2020 10:11:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=/3C71ZT3/i2h5AJy/cEm92ILo4xf+uGspmUX8gIFfeA=; b=MAVaNZA+4wpy8N4a8DV7/Ey1CO
        GcBUwEULIN7wwZiVhAlrDdIJFQD9VpE3iPyjIIGRbhVdrbIZuUM38ANGXN5h7cYqbCSfuiKOa/nqA
        fmwc29uOkslNoqgBO46J36qQjj44j+13NO7DbCzSI+GnahliapIMXgNYoHkZ6MM7Jw1O9gwKlyqna
        TfloKaHI+Mqvj+ASJdKE89s34OEQ0qPFsHatLjeKnZoULJs77ihoOz1LmVhGvxpsEotOUlx/CCC2I
        X3mBTnliBCoyp9ymhP+9TSGaUc+j+L2wOHjgrvaoMPJmMFy7xGA1TUlTtz3X8DpGZT2lNo5ZWdUGD
        uLnap6ng==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jvkwM-00022G-Uq; Wed, 15 Jul 2020 17:11:31 +0000
Date:   Wed, 15 Jul 2020 18:11:30 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Andy Lutomirski <luto@amacapital.net>
Cc:     Stefano Garzarella <sgarzare@redhat.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Kees Cook <keescook@chromium.org>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        strace-devel@lists.strace.io, io-uring@vger.kernel.org,
        Pavel Begunkov <asml.silence@gmail.com>,
        Linux API <linux-api@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: strace of io_uring events?
Message-ID: <20200715171130.GG12769@casper.infradead.org>
References: <CAJfpegu3EwbBFTSJiPhm7eMyTK2MzijLUp1gcboOo3meMF_+Qg@mail.gmail.com>
 <D9FAB37B-D059-4137-A115-616237D78640@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <D9FAB37B-D059-4137-A115-616237D78640@amacapital.net>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Jul 15, 2020 at 07:35:50AM -0700, Andy Lutomirski wrote:
> > On Jul 15, 2020, at 4:12 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> > 
> > <feff>Hi,

feff?  Are we doing WTF-16 in email now?  ;-)

> > 
> > This thread is to discuss the possibility of stracing requests
> > submitted through io_uring.   I'm not directly involved in io_uring
> > development, so I'm posting this out of  interest in using strace on
> > processes utilizing io_uring.
> > 
> > io_uring gives the developer a way to bypass the syscall interface,
> > which results in loss of information when tracing.  This is a strace
> > fragment on  "io_uring-cp" from liburing:
> > 
> > io_uring_enter(5, 40, 0, 0, NULL, 8)    = 40
> > io_uring_enter(5, 1, 0, 0, NULL, 8)     = 1
> > io_uring_enter(5, 1, 0, 0, NULL, 8)     = 1
> > ...
> > 
> > What really happens are read + write requests.  Without that
> > information the strace output is mostly useless.
> > 
> > This loss of information is not new, e.g. calls through the vdso or
> > futext fast paths are also invisible to strace.  But losing filesystem
> > I/O calls are a major blow, imo.
> > 
> > What do people think?
> > 
> > From what I can tell, listing the submitted requests on
> > io_uring_enter() would not be hard.  Request completion is
> > asynchronous, however, and may not require  io_uring_enter() syscall.
> > Am I correct?
> > 
> > Is there some existing tracing infrastructure that strace could use to
> > get async completion events?  Should we be introducing one?
> > 
> > 
> 
> Let’s add some seccomp folks. We probably also want to be able to run seccomp-like filters on io_uring requests. So maybe io_uring should call into seccomp-and-tracing code for each action.

Adding Stefano since he had a complementary proposal for iouring
restrictions that weren't exactly seccomp.
