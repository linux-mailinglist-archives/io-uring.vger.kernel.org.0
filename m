Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43D851A2133
	for <lists+io-uring@lfdr.de>; Wed,  8 Apr 2020 14:02:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727952AbgDHMBs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Apr 2020 08:01:48 -0400
Received: from mout-p-102.mailbox.org ([80.241.56.152]:21864 "EHLO
        mout-p-102.mailbox.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727851AbgDHMBH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Apr 2020 08:01:07 -0400
Received: from smtp2.mailbox.org (smtp2.mailbox.org [IPv6:2001:67c:2050:105:465:1:2:0])
        (using TLSv1.2 with cipher ECDHE-RSA-CHACHA20-POLY1305 (256/256 bits))
        (No client certificate requested)
        by mout-p-102.mailbox.org (Postfix) with ESMTPS id 48y2t74TPKzKmdH;
        Wed,  8 Apr 2020 14:01:03 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp2.mailbox.org ([80.241.60.241])
        by spamfilter04.heinlein-hosting.de (spamfilter04.heinlein-hosting.de [80.241.56.122]) (amavisd-new, port 10030)
        with ESMTP id JMljsTy5xozk; Wed,  8 Apr 2020 14:00:59 +0200 (CEST)
Date:   Wed, 8 Apr 2020 22:00:40 +1000
From:   Aleksa Sarai <cyphar@cyphar.com>
To:     Josh Triplett <josh@joshtriplett.org>
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org, linux-arch@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v3 1/3] fs: Support setting a minimum fd for "lowest
 available fd" allocation
Message-ID: <20200408120040.mtkqmymfazrv3lqk@yavin.dot.cyphar.com>
References: <cover.1586321767.git.josh@joshtriplett.org>
 <90bf6fd43343ca862e7f61b0834baf2bdbd0e24c.1586321767.git.josh@joshtriplett.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ds6ea26cc6xch3fv"
Content-Disposition: inline
In-Reply-To: <90bf6fd43343ca862e7f61b0834baf2bdbd0e24c.1586321767.git.josh@joshtriplett.org>
X-Rspamd-Queue-Id: F39C7178F
X-Rspamd-Score: -7.27 / 15.00 / 15.00
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


--ds6ea26cc6xch3fv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2020-04-07, Josh Triplett <josh@joshtriplett.org> wrote:
> Some applications want to prevent the usual "lowest available fd"
> allocation from allocating certain file descriptors. For instance, they
> may want to prevent allocation of a closed fd 0, 1, or 2 other than via
> dup2/dup3, or reserve some low file descriptors for other purposes.
>=20
> Add a prctl to increase the minimum fd and return the previous minimum.
>=20
> System calls that allocate a specific file descriptor, such as
> dup2/dup3, ignore this minimum.
>=20
> exec resets the minimum fd, to prevent one program from interfering with
> another program's expectations about fd allocation.

Why is it implemented as an "increase the value" interface? It feels
like this is meant to avoid some kind of security trap (with a library
reducing the value) but it means that if you want to temporarily raise
the minimum fd number it's not possible (without re-exec()ing yourself,
which is hardly a fun thing to do).

Then again, this might've been discussed before and I missed it...

> Test program:
>=20
>     #include <err.h>
>     #include <fcntl.h>
>     #include <stdio.h>
>     #include <sys/prctl.h>
>=20
>     int main(int argc, char *argv[])
>     {
>         if (prctl(PR_INCREASE_MIN_FD, 100, 0, 0, 0) < 0)
>             err(1, "prctl");
>         int fd =3D open("/dev/null", O_RDONLY);
>         if (fd < 0)
>             err(1, "open");
>         printf("%d\n", fd); // prints 100
>         return 0;
>     }
>=20
> Signed-off-by: Josh Triplett <josh@joshtriplett.org>
> ---
>  fs/file.c                  | 23 +++++++++++++++++------
>  include/linux/fdtable.h    |  1 +
>  include/linux/file.h       |  1 +
>  include/uapi/linux/prctl.h |  3 +++
>  kernel/sys.c               |  5 +++++
>  5 files changed, 27 insertions(+), 6 deletions(-)
>=20
> diff --git a/fs/file.c b/fs/file.c
> index c8a4e4c86e55..ba06140d89af 100644
> --- a/fs/file.c
> +++ b/fs/file.c
> @@ -286,7 +286,6 @@ struct files_struct *dup_fd(struct files_struct *oldf=
, int *errorp)
>  	spin_lock_init(&newf->file_lock);
>  	newf->resize_in_progress =3D false;
>  	init_waitqueue_head(&newf->resize_wait);
> -	newf->next_fd =3D 0;
>  	new_fdt =3D &newf->fdtab;
>  	new_fdt->max_fds =3D NR_OPEN_DEFAULT;
>  	new_fdt->close_on_exec =3D newf->close_on_exec_init;
> @@ -295,6 +294,7 @@ struct files_struct *dup_fd(struct files_struct *oldf=
, int *errorp)
>  	new_fdt->fd =3D &newf->fd_array[0];
> =20
>  	spin_lock(&oldf->file_lock);
> +	newf->next_fd =3D newf->min_fd =3D oldf->min_fd;
>  	old_fdt =3D files_fdtable(oldf);
>  	open_files =3D count_open_files(old_fdt);
> =20
> @@ -487,9 +487,7 @@ int __alloc_fd(struct files_struct *files,
>  	spin_lock(&files->file_lock);
>  repeat:
>  	fdt =3D files_fdtable(files);
> -	fd =3D start;
> -	if (fd < files->next_fd)
> -		fd =3D files->next_fd;
> +	fd =3D max3(start, files->min_fd, files->next_fd);
> =20
>  	if (fd < fdt->max_fds)
>  		fd =3D find_next_fd(fdt, fd);
> @@ -514,7 +512,7 @@ int __alloc_fd(struct files_struct *files,
>  		goto repeat;
> =20
>  	if (start <=3D files->next_fd)
> -		files->next_fd =3D fd + 1;
> +		files->next_fd =3D max(fd + 1, files->min_fd);
> =20
>  	__set_open_fd(fd, fdt);
>  	if (flags & O_CLOEXEC)
> @@ -555,7 +553,7 @@ static void __put_unused_fd(struct files_struct *file=
s, unsigned int fd)
>  {
>  	struct fdtable *fdt =3D files_fdtable(files);
>  	__clear_open_fd(fd, fdt);
> -	if (fd < files->next_fd)
> +	if (fd < files->next_fd && fd >=3D files->min_fd)
>  		files->next_fd =3D fd;
>  }
> =20
> @@ -684,6 +682,7 @@ void do_close_on_exec(struct files_struct *files)
> =20
>  	/* exec unshares first */
>  	spin_lock(&files->file_lock);
> +	files->min_fd =3D 0;
>  	for (i =3D 0; ; i++) {
>  		unsigned long set;
>  		unsigned fd =3D i * BITS_PER_LONG;
> @@ -865,6 +864,18 @@ bool get_close_on_exec(unsigned int fd)
>  	return res;
>  }
> =20
> +unsigned int increase_min_fd(unsigned int num)
> +{
> +	struct files_struct *files =3D current->files;
> +	unsigned int old_min_fd;
> +
> +	spin_lock(&files->file_lock);
> +	old_min_fd =3D files->min_fd;
> +	files->min_fd +=3D num;
> +	spin_unlock(&files->file_lock);
> +	return old_min_fd;
> +}
> +
>  static int do_dup2(struct files_struct *files,
>  	struct file *file, unsigned fd, unsigned flags)
>  __releases(&files->file_lock)
> diff --git a/include/linux/fdtable.h b/include/linux/fdtable.h
> index f07c55ea0c22..d1980443d8b3 100644
> --- a/include/linux/fdtable.h
> +++ b/include/linux/fdtable.h
> @@ -60,6 +60,7 @@ struct files_struct {
>     */
>  	spinlock_t file_lock ____cacheline_aligned_in_smp;
>  	unsigned int next_fd;
> +	unsigned int min_fd; /* min for "lowest available fd" allocation */
>  	unsigned long close_on_exec_init[1];
>  	unsigned long open_fds_init[1];
>  	unsigned long full_fds_bits_init[1];
> diff --git a/include/linux/file.h b/include/linux/file.h
> index 142d102f285e..b67986f818d2 100644
> --- a/include/linux/file.h
> +++ b/include/linux/file.h
> @@ -88,6 +88,7 @@ extern bool get_close_on_exec(unsigned int fd);
>  extern int __get_unused_fd_flags(unsigned flags, unsigned long nofile);
>  extern int get_unused_fd_flags(unsigned flags);
>  extern void put_unused_fd(unsigned int fd);
> +extern unsigned int increase_min_fd(unsigned int num);
> =20
>  extern void fd_install(unsigned int fd, struct file *file);
> =20
> diff --git a/include/uapi/linux/prctl.h b/include/uapi/linux/prctl.h
> index 07b4f8131e36..916327272d21 100644
> --- a/include/uapi/linux/prctl.h
> +++ b/include/uapi/linux/prctl.h
> @@ -238,4 +238,7 @@ struct prctl_mm_map {
>  #define PR_SET_IO_FLUSHER		57
>  #define PR_GET_IO_FLUSHER		58
> =20
> +/* Increase minimum file descriptor for "lowest available fd" allocation=
 */
> +#define PR_INCREASE_MIN_FD		59
> +
>  #endif /* _LINUX_PRCTL_H */
> diff --git a/kernel/sys.c b/kernel/sys.c
> index d325f3ab624a..daa0ce43cecc 100644
> --- a/kernel/sys.c
> +++ b/kernel/sys.c
> @@ -2514,6 +2514,11 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long,=
 arg2, unsigned long, arg3,
> =20
>  		error =3D (current->flags & PR_IO_FLUSHER) =3D=3D PR_IO_FLUSHER;
>  		break;
> +	case PR_INCREASE_MIN_FD:
> +		if (arg3 || arg4 || arg5)
> +			return -EINVAL;
> +		error =3D increase_min_fd((unsigned int)arg2);
> +		break;
>  	default:
>  		error =3D -EINVAL;
>  		break;
> --=20
> 2.26.0
>=20


--=20
Aleksa Sarai
Senior Software Engineer (Containers)
SUSE Linux GmbH
<https://www.cyphar.com/>

--ds6ea26cc6xch3fv
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSxZm6dtfE8gxLLfYqdlLljIbnQEgUCXo282wAKCRCdlLljIbnQ
Erv6AP92+InVSN/fAcGC4fMQvLY3+Y+CWC4jEQleGa+Nske6fgEA9FGpiJkLNedH
c/1zMZ/W9gr5n+kMEquw+xMVdw5PSQQ=
=R7U+
-----END PGP SIGNATURE-----

--ds6ea26cc6xch3fv--
