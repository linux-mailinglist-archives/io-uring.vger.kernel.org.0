Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9D4B3CFB9B
	for <lists+io-uring@lfdr.de>; Tue, 20 Jul 2021 16:11:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239014AbhGTNWA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 20 Jul 2021 09:22:00 -0400
Received: from zeniv-ca.linux.org.uk ([142.44.231.140]:36110 "EHLO
        zeniv-ca.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239597AbhGTNTr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 20 Jul 2021 09:19:47 -0400
Received: from viro by zeniv-ca.linux.org.uk with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m5qDv-002KdW-Ld; Tue, 20 Jul 2021 13:55:51 +0000
Date:   Tue, 20 Jul 2021 13:55:51 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Dmitry Kadashev <dkadashev@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>
Subject: Re: [PATCH 05/14] namei: prepare do_mkdirat for refactoring
Message-ID: <YPbV5wnUNw3SsSfI@zeniv-ca.linux.org.uk>
References: <20210715103600.3570667-1-dkadashev@gmail.com>
 <20210715103600.3570667-6-dkadashev@gmail.com>
 <YPCX5/0NtbEySW9q@zeniv-ca.linux.org.uk>
 <CAOKbgA79ODk_swv9nsU50ZrRe9Xqv3n9-JOH+H0zyhUF2SYcRw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOKbgA79ODk_swv9nsU50ZrRe9Xqv3n9-JOH+H0zyhUF2SYcRw@mail.gmail.com>
Sender: Al Viro <viro@ftp.linux.org.uk>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Jul 20, 2021 at 01:59:29PM +0700, Dmitry Kadashev wrote:

> > This is the wrong way to go.  Really.  Look at it that way - LOOKUP_REVAL
> > is the final stage of escalation; if we had to go there, there's no
> > point being optimistic about the last dcache lookup, nevermind trying
> > to retry the parent pathwalk if we fail with -ESTALE doing it.
> >
> > I'm not saying that it's something worth optimizing for; the problem
> > is different - the logics makes no sense whatsoever that way.  It's
> > a matter of reader's cycles wasted on "what the fuck are we trying
> > to do here?", not the CPU cycles wasted on execution.
> >
> > While we are at it, it makes no sense for filename_parentat() and its
> > ilk to go for RCU and normal if it's been given LOOKUP_REVAL - I mean,
> > look at the sequence of calls in there.  And try to make sense of
> > it.  Especially of the "OK, RCU attempt told us to sod off and try normal;
> > here, let's call path_parentat() with LOOKUP_REVAL for flags and if it
> > says -ESTALE, call it again with exact same arguments" part.
> >
> > Seriously, look at that from the point of view of somebody who tries
> > to make sense of the entire thing
> 
> OK, let me try to venture down that "change the way ESTALE retries are
> done completely" path. The problem here is I'm not familiar with the
> code enough to be sure the conversion is 1-to-1 (i.e. that we can't get
> ESTALE from somewhere unexpected), and that retries are open-coded in
> quite a few places it seems. Anyway, I'll try and dig in and come back
> with either an RFC patch or some questions. Thanks for the feedback, Al.

I'd try to look at the primitives that go through RCU/normal/REVAL series.
They are all in fs/namei.c; filename_lookup(), filename_parentat(),
do_filp_open() and do_filo_open_root().  The latter pair almost certainly
is fine as-is.

retry_estale() crap is limited to user_path_at/user_path_at_empty users,
along with some filename_parentat() ones.

There we follow that series with something that might give us ESTALE,
and if it does, we want to repeat the whole thing in REVAL mode.

OTOH, there are callers (and fairly similar ones, at that - look at e.g.
AF_UNIX bind doing mknod) where we don't have that kind of logics.

Question 1: which of those are lacking retry_estale(), even though they
might arguably need it?  Note that e.g. AF_UNIX bind uses kern_path_create(),
so we need to look at all callchains leading to those, not just the ones
in fs/namei.c guts.

If most of those really want retry_estale, we'd be better off if we took
the REVAL fallback out of filename_lookup() and filename_parentat()
and turned massaged the users from
	do rcu/normal/reval lookups
	if failed, fuck off
	do other work
	if it fails with ESTALE
		do rcu/reval/reval (yes, really)
		if failed, fuck off
		do other work
into
	do rcu/normal lookups
	if not failed
		do other work
	if something (including initial lookup) failed with ESTALE
		repeat the entire thing with LOOKUP_REVAL in the mix
possibly with a helper function involved.
For the ones that need retry_estale that's a win; for the rest it'd
be boilerplate (that's basically the ones where "do other work" never
fails with ESTALE).

Question 2: how are "need retry_estale"/"fine just with ESTALE fallback
in filename_{lookup,parentat}()" cases are distributed?

If the majority is in "need retry_estale" class, then something similar
to what's been outlined above would probably be a decent solution.

Otherwise we'll need wrappers equivalent to current behaviour, and that's
where it can get unpleasant - at which level in call chain do we put
that wrapper?  Sure, we can add filename_lookup_as_it_fucking_used_to_be().
Except that it's not called directly by those "don't need retry_estale"
users, so we'd need to provide such counterparts for them as well ;-/

IOW, we need the call tree for filename_lookup()/filename_parentat(),
with leaves (originators of call chain) marked with "does that user
do retry_estale?" (and tracked far back for the answer to depend only
upon the call site - if an intermediate can come from both kinds
of places, we need to track back to its callers).

Then we'll be able to see at which levels do we want those "as it used
to behave" wrappers...

If you want to dig around, that would probably be a reasonable place to
start.
