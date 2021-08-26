Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 842BB3F7FB3
	for <lists+io-uring@lfdr.de>; Thu, 26 Aug 2021 03:16:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235809AbhHZBRo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 25 Aug 2021 21:17:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47070 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235677AbhHZBRn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 25 Aug 2021 21:17:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629940615;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xGZ4blQfD1SQzAW+8oNrI9+DDA2xYpM8Bz8tQolg2hE=;
        b=U3aTaaVCJvn7O7eAjU52TUDn2HKjQWVlIFtYg0r1848/p5Fw/Xzk1bpdpnKLblwjHCHSOA
        0LNmvjzmBZQnm3fwxiE86q+MK6+sLyPCweOUp5ULal2LlYXeYa+Rmr7BLEvFDE5GQFFgTQ
        Ee+eezqkoe75XXgx6lephzF1y7EmZss=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-541-Olw_4qIKPzy6iyhZV81APw-1; Wed, 25 Aug 2021 21:16:54 -0400
X-MC-Unique: Olw_4qIKPzy6iyhZV81APw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BB9BA8015C7;
        Thu, 26 Aug 2021 01:16:52 +0000 (UTC)
Received: from madcap2.tricolour.ca (unknown [10.3.128.14])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1B16060843;
        Thu, 26 Aug 2021 01:16:41 +0000 (UTC)
Date:   Wed, 25 Aug 2021 21:16:39 -0400
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Paul Moore <paul@paul-moore.com>
Cc:     linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        linux-audit@redhat.com, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [RFC PATCH v2 0/9] Add LSM access controls and auditing to
 io_uring
Message-ID: <20210826011639.GE490529@madcap2.tricolour.ca>
References: <162871480969.63873.9434591871437326374.stgit@olly>
 <20210824205724.GB490529@madcap2.tricolour.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210824205724.GB490529@madcap2.tricolour.ca>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2021-08-24 16:57, Richard Guy Briggs wrote:
> On 2021-08-11 16:48, Paul Moore wrote:
> > Draft #2 of the patchset which brings auditing and proper LSM access
> > controls to the io_uring subsystem.  The original patchset was posted
> > in late May and can be found via lore using the link below:
> > 
> > https://lore.kernel.org/linux-security-module/162163367115.8379.8459012634106035341.stgit@sifl/
> > 
> > This draft should incorporate all of the feedback from the original
> > posting as well as a few smaller things I noticed while playing
> > further with the code.  The big change is of course the selective
> > auditing in the io_uring op servicing, but that has already been
> > discussed quite a bit in the original thread so I won't go into
> > detail here; the important part is that we found a way to move
> > forward and this draft captures that.  For those of you looking to
> > play with these patches, they are based on Linus' v5.14-rc5 tag and
> > on my test system they boot and appear to function without problem;
> > they pass the selinux-testsuite and audit-testsuite and I have not
> > noticed any regressions in the normal use of the system.  If you want
> > to get a copy of these patches straight from git you can use the
> > "working-io_uring" branch in the repo below:
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/pcmoore/selinux.git
> > https://git.kernel.org/pub/scm/linux/kernel/git/pcmoore/selinux.git
> > 
> > Beyond the existing test suite tests mentioned above, I've cobbled
> > together some very basic, very crude tests to exercise some of the
> > things I care about from a LSM/audit perspective.  These tests are
> > pretty awful (I'm not kidding), but they might be helpful for the
> > other LSM/audit developers who want to test things:
> > 
> > https://drop.paul-moore.com/90.kUgq
> > 
> > There are currently two tests: 'iouring.2' and 'iouring.3';
> > 'iouring.1' was lost in a misguided and overzealous 'rm' command.
> > The first test is standalone and basically tests the SQPOLL
> > functionality while the second tests sharing io_urings across process
> > boundaries and the credential/personality sharing mechanism.  The
> > console output of both tests isn't particularly useful, the more
> > interesting bits are in the audit and LSM specific logs.  The
> > 'iouring.2' command requires no special arguments to run but the
> > 'iouring.3' test is split into a "server" and "client"; the server
> > should be run without argument:
> > 
> >   % ./iouring.3s
> >   >>> server started, pid = 11678
> >   >>> memfd created, fd = 3
> >   >>> io_uring created; fd = 5, creds = 1
> > 
> > ... while the client should be run with two arguments: the first is
> > the PID of the server process, the second is the "memfd" fd number:
> > 
> >   % ./iouring.3c 11678 3
> >   >>> client started, server_pid = 11678 server_memfd = 3
> >   >>> io_urings = 5 (server) / 5 (client)
> >   >>> io_uring ops using creds = 1
> >   >>> async op result: 36
> >   >>> async op result: 36
> >   >>> async op result: 36
> >   >>> async op result: 36
> >   >>> START file contents
> >   What is this life if, full of care,
> >   we have no time to stand and stare.
> >   >>> END file contents
> > 
> > The tests were hacked together from various sources online,
> > attribution and links to additional info can be found in the test
> > sources, but I expect these tests to die a fiery death in the not
> > to distant future as I work to add some proper tests to the SELinux
> > and audit test suites.
> > 
> > As I believe these patches should spend a full -rcX cycle in
> > linux-next, my current plan is to continue to solicit feedback on
> > these patches while they undergo additional testing (next up is
> > verification of the audit filter code for io_uring).  Assuming no
> > critical issues are found on the mailing lists or during testing, I
> > will post a proper patchset later with the idea of merging it into
> > selinux/next after the upcoming merge window closes.
> > 
> > Any comments, feedback, etc. are welcome.
> 
> Thanks for the tests.  I have a bunch of userspace patches to add to the
> last set I posted and these tests will help exercise them.  I also have
> one more kernel patch to post...  I'll dive back into that now.  I had
> wanted to post them before now but got distracted with AUDIT_TRIM
> breakage.

Please tell me about liburing.h that is needed for these.  There is one
in tools/io_uring/liburing.h but I don't think that one is right.

The next obvious one would be include/uapi/linux/io_uring.h

I must be missing something obvious here...

> > ---
> > 
> > Casey Schaufler (1):
> >       Smack: Brutalist io_uring support with debug
> > 
> > Paul Moore (8):
> >       audit: prepare audit_context for use in calling contexts beyond
> >              syscalls
> >       audit,io_uring,io-wq: add some basic audit support to io_uring
> >       audit: dev/test patch to force io_uring auditing
> >       audit: add filtering for io_uring records
> >       fs: add anon_inode_getfile_secure() similar to
> >           anon_inode_getfd_secure()
> >       io_uring: convert io_uring to the secure anon inode interface
> >       lsm,io_uring: add LSM hooks to io_uring
> >       selinux: add support for the io_uring access controls
> > 
> > 
> >  fs/anon_inodes.c                    |  29 ++
> >  fs/io-wq.c                          |   4 +
> >  fs/io_uring.c                       |  69 +++-
> >  include/linux/anon_inodes.h         |   4 +
> >  include/linux/audit.h               |  26 ++
> >  include/linux/lsm_hook_defs.h       |   5 +
> >  include/linux/lsm_hooks.h           |  13 +
> >  include/linux/security.h            |  16 +
> >  include/uapi/linux/audit.h          |   4 +-
> >  kernel/audit.h                      |   7 +-
> >  kernel/audit_tree.c                 |   3 +-
> >  kernel/audit_watch.c                |   3 +-
> >  kernel/auditfilter.c                |  15 +-
> >  kernel/auditsc.c                    | 483 +++++++++++++++++++-----
> >  security/security.c                 |  12 +
> >  security/selinux/hooks.c            |  34 ++
> >  security/selinux/include/classmap.h |   2 +
> >  security/smack/smack_lsm.c          |  64 ++++
> >  18 files changed, 678 insertions(+), 115 deletions(-)
> > 
> 
> - RGB
> 
> --
> Richard Guy Briggs <rgb@redhat.com>
> Sr. S/W Engineer, Kernel Security, Base Operating Systems
> Remote, Ottawa, Red Hat Canada
> IRC: rgb, SunRaycer
> Voice: +1.647.777.2635, Internal: (81) 32635
> 

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635

