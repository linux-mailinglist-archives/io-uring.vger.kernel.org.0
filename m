Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8922A1A2218
	for <lists+io-uring@lfdr.de>; Wed,  8 Apr 2020 14:34:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728734AbgDHMex (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Apr 2020 08:34:53 -0400
Received: from mout-p-103.mailbox.org ([80.241.56.161]:58474 "EHLO
        mout-p-103.mailbox.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728207AbgDHMex (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Apr 2020 08:34:53 -0400
Received: from smtp2.mailbox.org (smtp2.mailbox.org [IPv6:2001:67c:2050:105:465:1:2:0])
        (using TLSv1.2 with cipher ECDHE-RSA-CHACHA20-POLY1305 (256/256 bits))
        (No client certificate requested)
        by mout-p-103.mailbox.org (Postfix) with ESMTPS id 48y3RT1xT9zKmXH;
        Wed,  8 Apr 2020 14:26:29 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp2.mailbox.org ([80.241.60.241])
        by gerste.heinlein-support.de (gerste.heinlein-support.de [91.198.250.173]) (amavisd-new, port 10030)
        with ESMTP id m9ZmrmVd4PFA; Wed,  8 Apr 2020 14:26:25 +0200 (CEST)
Date:   Wed, 8 Apr 2020 22:26:01 +1000
From:   Aleksa Sarai <cyphar@cyphar.com>
To:     Josh Triplett <josh@joshtriplett.org>
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org, linux-arch@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v3 0/3] Support userspace-selected fds
Message-ID: <20200408122601.kvrdjksjkl7ktgt4@yavin.dot.cyphar.com>
References: <cover.1586321767.git.josh@joshtriplett.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="753o2egv4zmh6vyt"
Content-Disposition: inline
In-Reply-To: <cover.1586321767.git.josh@joshtriplett.org>
X-Rspamd-Queue-Id: DDA58175B
X-Rspamd-Score: -6.44 / 15.00 / 15.00
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


--753o2egv4zmh6vyt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2020-04-07, Josh Triplett <josh@joshtriplett.org> wrote:
> (Note: numbering this updated version v3, to avoid confusion with Jens'
> v2 that built on my v1. Jens, if you like this approach, please feel
> free to stack your additional patches from the io_uring-fd-select branch
> atop this series. 5.8 material, not intended for the current merge window=
=2E)
>=20
> Inspired by the X protocol's handling of XIDs, allow userspace to select
> the file descriptor opened by a call like openat2, so that it can use
> the resulting file descriptor in subsequent system calls without waiting
> for the response to the initial openat2 syscall.
>=20
> The first patch is independent of the other two; it allows reserving
> file descriptors below a certain minimum for userspace-selected fd
> allocation only.
>=20
> The second patch implements userspace-selected fd allocation for
> openat2, introducing a new O_SPECIFIC_FD flag and an fd field in struct
> open_how. In io_uring, this allows sequences like openat2/read/close
> without waiting for the openat2 to complete. Multiple such sequences can
> overlap, as long as each uses a distinct file descriptor.
>=20
> The third patch adds userspace-selected fd allocation to pipe2 as well.
> I did this partly as a demonstration of how simple it is to wire up
> O_SPECIFIC_FD support for any fd-allocating system call, and partly in
> the hopes that this may make it more useful to wire up io_uring support
> for pipe2 in the future.
>=20
> If this gets accepted, I'm happy to also write corresponding manpage
> patches.
>=20
> v3:
> This new version has an API to atomically increase the minimum fd and
> return the previous minimum, rather than just getting and setting the
> minimum; this makes it easier to allocate a range. (A library that might
> initialize after the program has already opened other file descriptors
> may need to check for existing open fds in the range after reserving it,
> and reserve more fds if needed; this can be done entirely in userspace,
> and we can't really do anything simpler in the kernel due to limitations
> on file-descriptor semantics, so this patch series avoids introducing
> any extra complexity in the kernel.)
>=20
> This new version also supports a __get_specific_unused_fd_flags call
> which accepts the limit for RLIMIT_NOFILE as an argument, analogous to
> __get_unused_fd_flags, since io_uring needs that to correctly handle
> RLIMIT_NOFILE.
>=20
> Josh Triplett (3):
>   fs: Support setting a minimum fd for "lowest available fd" allocation
>   fs: openat2: Extend open_how to allow userspace-selected fds
>   fs: pipe2: Support O_SPECIFIC_FD

Aside from my specific comments and questions, the changes to openat2
deserve at least one or two selftests.

>  fs/fcntl.c                       |  2 +-
>  fs/file.c                        | 62 ++++++++++++++++++++++++++++----
>  fs/io_uring.c                    |  3 +-
>  fs/open.c                        |  6 ++--
>  fs/pipe.c                        | 16 ++++++---
>  include/linux/fcntl.h            |  5 +--
>  include/linux/fdtable.h          |  1 +
>  include/linux/file.h             |  4 +++
>  include/uapi/asm-generic/fcntl.h |  4 +++
>  include/uapi/linux/openat2.h     |  2 ++
>  include/uapi/linux/prctl.h       |  3 ++
>  kernel/sys.c                     |  5 +++
>  12 files changed, 97 insertions(+), 16 deletions(-)

--=20
Aleksa Sarai
Senior Software Engineer (Containers)
SUSE Linux GmbH
<https://www.cyphar.com/>

--753o2egv4zmh6vyt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSxZm6dtfE8gxLLfYqdlLljIbnQEgUCXo3C0QAKCRCdlLljIbnQ
EhhjAQDFUJ5VOPLwbFaGpNlrcUpjPunloiKcWks6ACx6gv1cSwEA9Ii9QQBfqGMO
K8HrFWauN6ip0V8Sf5777xDP7rGWww8=
=OtzS
-----END PGP SIGNATURE-----

--753o2egv4zmh6vyt--
