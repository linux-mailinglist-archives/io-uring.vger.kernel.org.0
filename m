Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C08543F7FF0
	for <lists+io-uring@lfdr.de>; Thu, 26 Aug 2021 03:34:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235917AbhHZBff (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 25 Aug 2021 21:35:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235695AbhHZBfe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 25 Aug 2021 21:35:34 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AD71C0613C1
        for <io-uring@vger.kernel.org>; Wed, 25 Aug 2021 18:34:48 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id t19so2471236ejr.8
        for <io-uring@vger.kernel.org>; Wed, 25 Aug 2021 18:34:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OdpPAw8AF8pl2PyKEL1hUSGpJT552rYtVLGch5FQNUg=;
        b=s89enEjVtwLIczScDXvlL5in2XUoikWwI1bI+2XIGm2ig7sM5+jzPbFrXyNmfNdt2B
         TDlubVQ+1eZq248F/C+SNj6f+K+RdXGRYLkkW5UKa6L2motdIlcnIwPZwir7Xi/cnEXH
         XD0B8/HiUxBqhBHG2IY8riO83umDevioXM/2sMa2lTEKgVdF3YD0N9Tcz/70f50m1Coq
         SQJ8qkY/a+ny0ogrYPNQKm7wO7kz1foyig/wKcNgz8MBzJjYWe9Z/YKJx9ausGyx+0Iw
         aPO7Q9koxTNXa0W0ZJe7DARZulbU3i7KDNBRiWkzx777xyYYbk1YQlgkfNuV87hvcXeU
         htBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OdpPAw8AF8pl2PyKEL1hUSGpJT552rYtVLGch5FQNUg=;
        b=CLExkRDMU4iGb4+xEJT1pv6cweU6j5kz+BufIrhDdCHtTRL67Q44GMbmuuy2YKljkj
         NhjOlIxVZG1dpfI5HHGY0W5cXC8yVv1odfJKUJ1w4J2E+5uzxRk9x/Fi0OcX9JbS6zwE
         n/w9pbkLbcbK1Mn0kupvPL3jxwPj+7zVvKrbYWVBahO4ppzJydV0YDcftUBKF503LTtx
         4VJPN9nb58dAvrG0gaLs6PZxJKB6njhKK1dLId2PFe5yNEhCjHjWxJa1Q+egj9vJZGMo
         iN6QT2/ucaz7NjCwwfYyZLiVvdlvaVK/ULwrbbTYlveJqja1U54XfYDkM6U7tpPHfcdp
         8M3Q==
X-Gm-Message-State: AOAM532E0szibbtG4aMHDx06iHRBIY15pM3Db/A3zHqRXw7lGmzkcDEI
        STreWGt6D0lDYcNKltLA0EMo9NItgF9p+cuV9Zpm
X-Google-Smtp-Source: ABdhPJwkxAUzZb4BAOoTmtyvge3L60MS4GRf3O1WiYNyf8fZr3jqwYlcLQ7K6iZEQJc0kSAgJ9KIlKQXtyNl3hpd2NQ=
X-Received: by 2002:a17:906:2cd6:: with SMTP id r22mr1559201ejr.398.1629941686387;
 Wed, 25 Aug 2021 18:34:46 -0700 (PDT)
MIME-Version: 1.0
References: <162871480969.63873.9434591871437326374.stgit@olly>
 <20210824205724.GB490529@madcap2.tricolour.ca> <20210826011639.GE490529@madcap2.tricolour.ca>
In-Reply-To: <20210826011639.GE490529@madcap2.tricolour.ca>
From:   Paul Moore <paul@paul-moore.com>
Date:   Wed, 25 Aug 2021 21:34:35 -0400
Message-ID: <CAHC9VhSADQsudmD52hP8GQWWR4+=sJ7mvNkh9xDXuahS+iERVA@mail.gmail.com>
Subject: Re: [RFC PATCH v2 0/9] Add LSM access controls and auditing to io_uring
To:     Richard Guy Briggs <rgb@redhat.com>
Cc:     linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        linux-audit@redhat.com, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Aug 25, 2021 at 9:16 PM Richard Guy Briggs <rgb@redhat.com> wrote:
>
> On 2021-08-24 16:57, Richard Guy Briggs wrote:
> > On 2021-08-11 16:48, Paul Moore wrote:
> > > Draft #2 of the patchset which brings auditing and proper LSM access
> > > controls to the io_uring subsystem.  The original patchset was posted
> > > in late May and can be found via lore using the link below:
> > >
> > > https://lore.kernel.org/linux-security-module/162163367115.8379.8459012634106035341.stgit@sifl/
> > >
> > > This draft should incorporate all of the feedback from the original
> > > posting as well as a few smaller things I noticed while playing
> > > further with the code.  The big change is of course the selective
> > > auditing in the io_uring op servicing, but that has already been
> > > discussed quite a bit in the original thread so I won't go into
> > > detail here; the important part is that we found a way to move
> > > forward and this draft captures that.  For those of you looking to
> > > play with these patches, they are based on Linus' v5.14-rc5 tag and
> > > on my test system they boot and appear to function without problem;
> > > they pass the selinux-testsuite and audit-testsuite and I have not
> > > noticed any regressions in the normal use of the system.  If you want
> > > to get a copy of these patches straight from git you can use the
> > > "working-io_uring" branch in the repo below:
> > >
> > > git://git.kernel.org/pub/scm/linux/kernel/git/pcmoore/selinux.git
> > > https://git.kernel.org/pub/scm/linux/kernel/git/pcmoore/selinux.git
> > >
> > > Beyond the existing test suite tests mentioned above, I've cobbled
> > > together some very basic, very crude tests to exercise some of the
> > > things I care about from a LSM/audit perspective.  These tests are
> > > pretty awful (I'm not kidding), but they might be helpful for the
> > > other LSM/audit developers who want to test things:
> > >
> > > https://drop.paul-moore.com/90.kUgq
> > >
> > > There are currently two tests: 'iouring.2' and 'iouring.3';
> > > 'iouring.1' was lost in a misguided and overzealous 'rm' command.
> > > The first test is standalone and basically tests the SQPOLL
> > > functionality while the second tests sharing io_urings across process
> > > boundaries and the credential/personality sharing mechanism.  The
> > > console output of both tests isn't particularly useful, the more
> > > interesting bits are in the audit and LSM specific logs.  The
> > > 'iouring.2' command requires no special arguments to run but the
> > > 'iouring.3' test is split into a "server" and "client"; the server
> > > should be run without argument:
> > >
> > >   % ./iouring.3s
> > >   >>> server started, pid = 11678
> > >   >>> memfd created, fd = 3
> > >   >>> io_uring created; fd = 5, creds = 1
> > >
> > > ... while the client should be run with two arguments: the first is
> > > the PID of the server process, the second is the "memfd" fd number:
> > >
> > >   % ./iouring.3c 11678 3
> > >   >>> client started, server_pid = 11678 server_memfd = 3
> > >   >>> io_urings = 5 (server) / 5 (client)
> > >   >>> io_uring ops using creds = 1
> > >   >>> async op result: 36
> > >   >>> async op result: 36
> > >   >>> async op result: 36
> > >   >>> async op result: 36
> > >   >>> START file contents
> > >   What is this life if, full of care,
> > >   we have no time to stand and stare.
> > >   >>> END file contents
> > >
> > > The tests were hacked together from various sources online,
> > > attribution and links to additional info can be found in the test
> > > sources, but I expect these tests to die a fiery death in the not
> > > to distant future as I work to add some proper tests to the SELinux
> > > and audit test suites.
> > >
> > > As I believe these patches should spend a full -rcX cycle in
> > > linux-next, my current plan is to continue to solicit feedback on
> > > these patches while they undergo additional testing (next up is
> > > verification of the audit filter code for io_uring).  Assuming no
> > > critical issues are found on the mailing lists or during testing, I
> > > will post a proper patchset later with the idea of merging it into
> > > selinux/next after the upcoming merge window closes.
> > >
> > > Any comments, feedback, etc. are welcome.
> >
> > Thanks for the tests.  I have a bunch of userspace patches to add to the
> > last set I posted and these tests will help exercise them.  I also have
> > one more kernel patch to post...  I'll dive back into that now.  I had
> > wanted to post them before now but got distracted with AUDIT_TRIM
> > breakage.
>
> Please tell me about liburing.h that is needed for these.  There is one
> in tools/io_uring/liburing.h but I don't think that one is right.
>
> The next obvious one would be include/uapi/linux/io_uring.h
>
> I must be missing something obvious here...

You are looking for the liburing header files, the upstream is here:
-> https://github.com/axboe/liburing

If you are on a RH/IBM based distro it is likely called liburing[-devel]:

% dnf whatprovides */liburing.h
Last metadata expiration check: 0:38:37 ago on Wed 25 Aug 2021 08:54:22 PM EDT.
liburing-devel-2.0-2.fc35.i686 : Development files for Linux-native io_uring I/O
                              : access library
Repo        : rawhide
Matched from:
Filename    : /usr/include/liburing.h

liburing-devel-2.0-2.fc35.x86_64 : Development files for Linux-native io_uring
                                : I/O access library
Repo        : @System
Matched from:
Filename    : /usr/include/liburing.h

liburing-devel-2.0-2.fc35.x86_64 : Development files for Linux-native io_uring
                                : I/O access library
Repo        : rawhide
Matched from:
Filename    : /usr/include/liburing.h

-- 
paul moore
www.paul-moore.com
