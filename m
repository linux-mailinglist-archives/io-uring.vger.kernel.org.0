Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE91C2236D0
	for <lists+io-uring@lfdr.de>; Fri, 17 Jul 2020 10:18:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727853AbgGQIRd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 17 Jul 2020 04:17:33 -0400
Received: from mx2.suse.de ([195.135.220.15]:55866 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726113AbgGQIRd (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Fri, 17 Jul 2020 04:17:33 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 68C1AADF0;
        Fri, 17 Jul 2020 08:17:36 +0000 (UTC)
Date:   Fri, 17 Jul 2020 10:17:52 +0200
From:   Cyril Hrubis <chrubis@suse.cz>
To:     Aleksa Sarai <cyphar@cyphar.com>
Cc:     Kees Cook <keescook@chromium.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Matthew Wilcox <willy@infradead.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Jann Horn <jannh@google.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        strace-devel@lists.strace.io, io-uring@vger.kernel.org,
        Linux API <linux-api@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Kerrisk <mtk.manpages@gmail.com>
Subject: Re: strace of io_uring events?
Message-ID: <20200717081752.GA23090@yuki.lan>
References: <CAJfpegu3EwbBFTSJiPhm7eMyTK2MzijLUp1gcboOo3meMF_+Qg@mail.gmail.com>
 <D9FAB37B-D059-4137-A115-616237D78640@amacapital.net>
 <20200715171130.GG12769@casper.infradead.org>
 <7c09f6af-653f-db3f-2378-02dca2bc07f7@gmail.com>
 <CAJfpegt9=p4uo5U2GXqc-rwqOESzZCWAkGMRTY1r8H6fuXx96g@mail.gmail.com>
 <48cc7eea-5b28-a584-a66c-4eed3fac5e76@gmail.com>
 <202007151511.2AA7718@keescook>
 <20200716131755.l5tsyhupimpinlfi@yavin.dot.cyphar.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200716131755.l5tsyhupimpinlfi@yavin.dot.cyphar.com>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi!
> > - Why aren't the io_uring syscalls in the man-page git? (It seems like
> >   they're in liburing, but that's should document the _library_ not the
> >   syscalls, yes?)
> 
> I imagine because using the syscall requires specific memory barriers
> which we probably don't want most C programs to be fiddling with
> directly. Sort of similar to how iptables doesn't have a syscall-style
> man page.

Call me old fashioned but I would vote for having all syscalls
documented in man pages. At least for me it makes my life much easier as
I do not have to fish for documentation or read library source code when
debugging. Think of all the poor kernel QA folks that will cry in
despair when you decided not to submit manual pages.

There is plenty of stuff documented there that most C programmers
shouldn't touch, I do not consider this to be a valid excuse.

-- 
Cyril Hrubis
chrubis@suse.cz
