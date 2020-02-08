Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBC841565C9
	for <lists+io-uring@lfdr.de>; Sat,  8 Feb 2020 18:53:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727392AbgBHRxF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 8 Feb 2020 12:53:05 -0500
Received: from master.debian.org ([82.195.75.110]:35012 "EHLO
        master.debian.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727341AbgBHRxE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 8 Feb 2020 12:53:04 -0500
X-Greylist: delayed 1009 seconds by postgrey-1.27 at vger.kernel.org; Sat, 08 Feb 2020 12:53:04 EST
Received: from guillem by master.debian.org with local (Exim 4.89)
        (envelope-from <guillem@master.debian.org>)
        id 1j0U1e-0004rR-Qo
        for io-uring@vger.kernel.org; Sat, 08 Feb 2020 17:36:14 +0000
Date:   Sat, 8 Feb 2020 18:36:08 +0100
From:   Guillem Jover <guillem@debian.org>
To:     io-uring@vger.kernel.org
Subject: liburing packaging issues
Message-ID: <20200208173608.GA1390571@thunder.hadrons.org>
Mail-Followup-To: Guillem Jover <guillem@debian.org>,
        io-uring@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi!

Stefan Metzmacher asked whether I could package and upload liburing
for Debian (and as a side effect Ubuntu). And here are some of the
things I've noticed that would be nice to get fixed or improved
before I upload it there.

  * The README states that the license is LGPL (I assume 2.1+ in
    contrast to 2.1?) and MIT, but there's at least one header that's
    GPL-2.0 + Linux-syscall-note, which I assume is due to it coming
    from the kernel headers. Would be nice to have every file with an
    explicit license grant, say at least with an SPDX tag, and update
    the README.

  * From the RPM spec file and the debian packaging in the repo, I
    assume there is no actual release tarball (didn't see on in
    kernel.dk nor kernel.org)? It would be nice to have one with a
    detached OpenPGP signature, so that we can include it in the
    Debian source package, to chain and verify the provenance from
    upstream.

  * The test suite fails for me on the following unit tests:

      read-write accept-link poll-many poll-v-poll short-read send_recv

    while running on Linux 5.5.0-rc0. I read from the README it is not
    supposed to work on old kernels, and might even crash them. But it
    would still be nice if these tests would get SKIPPED, so that I can
    enable them unconditionally to catch possible regressions and so they
    do not make the package fail to build from source on the Debian build
    daemons due to too old kernels, which in most cases will be one from
    a Debian stable release (Linux 4.19.x or so).

There are a couple of issues with the build system, for which I'll be
sending out a couple of patches later.

Thanks,
Guillem
