Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D48DB15FEA8
	for <lists+io-uring@lfdr.de>; Sat, 15 Feb 2020 14:50:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726162AbgBONuY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 15 Feb 2020 08:50:24 -0500
Received: from master.debian.org ([82.195.75.110]:51224 "EHLO
        master.debian.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726143AbgBONuX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 15 Feb 2020 08:50:23 -0500
Received: from guillem by master.debian.org with local (Exim 4.92)
        (envelope-from <guillem@master.debian.org>)
        id 1j2xpu-0002bs-2L; Sat, 15 Feb 2020 13:50:22 +0000
Date:   Sat, 15 Feb 2020 14:48:36 +0100
From:   Guillem Jover <guillem@debian.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
Subject: Re: liburing packaging issues
Message-ID: <20200215134836.GA15122@gaara.hadrons.org>
Mail-Followup-To: Guillem Jover <guillem@debian.org>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <20200208173608.GA1390571@thunder.hadrons.org>
 <67b1f314-31df-acef-b3f9-256bdf951b76@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <67b1f314-31df-acef-b3f9-256bdf951b76@kernel.dk>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sat, 2020-02-08 at 13:02:15 -0700, Jens Axboe wrote:
> On 2/8/20 10:36 AM, Guillem Jover wrote:
> > Stefan Metzmacher asked whether I could package and upload liburing
> > for Debian (and as a side effect Ubuntu). And here are some of the
> > things I've noticed that would be nice to get fixed or improved
> > before I upload it there.
> > 
> >   * The README states that the license is LGPL (I assume 2.1+ in
> >     contrast to 2.1?) and MIT, but there's at least one header that's
> >     GPL-2.0 + Linux-syscall-note, which I assume is due to it coming
> >     from the kernel headers. Would be nice to have every file with an
> >     explicit license grant, say at least with an SPDX tag, and update
> >     the README.
> 
> OK, I can clarify that and add SPDX headers.

Thanks for those.

I see now almost all code files are marked as MIT, the man pages as
LGPL-2.1 (not clear whether >= or not), and one header with GPL-2.0
with Linux-syscall-note or MIT. But there's no COPYING for the GPL,
only for the LGPL, and the README does not reflect the above. Could
you either add the missing COPYING if necessary, clarify the license
for the files, or the README and RPM spec so that they are consistent
(I guess you might want to do that on the debian/ directory too, but
it's not a problem for the Debian packaging as we'll be overriding it
completely anyway).

I'm sorry to be a pain on this, but this is going to be the thing most
scrutinized by the Debian ftp-masters on the first upload for manual
acceptance, which tends to take a while, so I'd like to get any
inconsistencies sorted out before that. :)

> >   * From the RPM spec file and the debian packaging in the repo, I
> >     assume there is no actual release tarball (didn't see on in
> >     kernel.dk nor kernel.org)? It would be nice to have one with a
> >     detached OpenPGP signature, so that we can include it in the
> >     Debian source package, to chain and verify the provenance from
> >     upstream.
> 
> I do generate release tar balls with a detached signature, see:
> 
> https://brick.kernel.dk/snaps/

Ah great, thanks. It was not obvious before. (Perhaps add a mention to
the README too? And another for places where patches can be sent to,
say the list and github? :)

> >   * The test suite fails for me on the following unit tests:
> > 
> >       read-write accept-link poll-many poll-v-poll short-read send_recv
> > 
> >     while running on Linux 5.5.0-rc0. I read from the README it is not
> >     supposed to work on old kernels, and might even crash them. But it
> >     would still be nice if these tests would get SKIPPED, so that I can
> >     enable them unconditionally to catch possible regressions and so they
> >     do not make the package fail to build from source on the Debian build
> >     daemons due to too old kernels, which in most cases will be one from
> >     a Debian stable release (Linux 4.19.x or so).
> 
> The tests should build fine on any system, they just won't pass on any
> system. So I don't think this is a packaging issue, don't run them as
> part of building the package.

I'd really like to run these both at build-time, and at "install-time"
as part of our CI infra (https://ci.debian.net/), so that we can catch
possible regressions or similar. Even if they still fail for now, I'd
probably still run them at build-time but as non-fatal (like I'm doing
with libaio), so that we can have visibility over all our ports.

After the merge requests I sent I'm now only seeing two problems on the
above mentioned Linux version (from Debian experimental):

  - short-read always fails with "Read failed: 0".
  - there seems to be some kind of resource leak or similar, because
    after running the tests multiple times, almost if not all of them
    start to fail with -ENOMEM from io_uring_setup().

Thanks,
Guillem
