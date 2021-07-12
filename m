Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1835A3C652B
	for <lists+io-uring@lfdr.de>; Mon, 12 Jul 2021 22:53:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234106AbhGLUyz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 12 Jul 2021 16:54:55 -0400
Received: from zeniv-ca.linux.org.uk ([142.44.231.140]:48460 "EHLO
        zeniv-ca.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229910AbhGLUyz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 12 Jul 2021 16:54:55 -0400
X-Greylist: delayed 1311 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Jul 2021 16:54:55 EDT
Received: from viro by zeniv-ca.linux.org.uk with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m32Uv-0007dJ-Hn; Mon, 12 Jul 2021 20:25:49 +0000
Date:   Mon, 12 Jul 2021 20:25:49 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Dmitry Kadashev <dkadashev@gmail.com>,
        Jens Axboe <axboe@kernel.dk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>
Subject: Re: [PATCH 0/7] namei: clean up retry logic in various do_* functions
Message-ID: <YOylTZ3u0AVidHe2@zeniv-ca.linux.org.uk>
References: <20210712123649.1102392-1-dkadashev@gmail.com>
 <CAOKbgA4EqwLa3WDK_JcxFAU92pBw4hS8vjQ9p7B-w+5y7yX5Eg@mail.gmail.com>
 <CAHk-=wiGH-bYqLvjMOv2i48Wb1FQaAj8ukegSMLNbW0yri05rA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wiGH-bYqLvjMOv2i48Wb1FQaAj8ukegSMLNbW0yri05rA@mail.gmail.com>
Sender: Al Viro <viro@ftp.linux.org.uk>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Jul 12, 2021 at 12:01:52PM -0700, Linus Torvalds wrote:
> On Mon, Jul 12, 2021 at 5:41 AM Dmitry Kadashev <dkadashev@gmail.com> wrote:
> >
> > Since this is on top of the stuff that is going to be in the Jens' tree
> > only until the 5.15 merge window, I'm assuming this series should go
> > there as well.
> 
> Yeah. Unless Al wants to pick this whole series up.
> 
> See my comments about the individual patches - some of them change
> code flow, others do. And I think changing code flow as part of
> cleanup is ok, but it at the very least needs to be mentioned (and it
> might be good to do the "move code that is idempotent inside the
> retry" as a separate patch from documentation purposes)

TBH, my main problem with this is that ESTALE retry logics had never
felt right.  We ask e.g. filename_create() to get us the parent.  We
tell it whether we want it to be maximally suspicious or not.  It
still does the same RCU-normal-LOOKUP_REVAL sequence, only for "trust
no one" variant it's RCU-LOOKUP_REVAL-LOOKUP_REVAL instead.  We are
*not* told how far in that sequence did it have to get.  What's more,
even if we had to get all way up to LOOKUP_REVAL, we ignore that
when we do dcache lookup for the last component - only the argument
of filename_create() is looked at.

It really smells like the calling conventions are wrong.  I agree that
all of that is, by definition, a very slow path - it's just that the
logics makes me go "WTF?" every time I see it... ;-/

Hell knows - perhaps the lookup_flags thing wants to be passed by
reference (all the way into path_parentat()) and have the "we had
to go for LOOKUP_REVAL" returned that way.  Not sure...

Al, still crawling out of the bloody ptrace/asm glue horrors at the moment...
