Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 190CA25C13E
	for <lists+io-uring@lfdr.de>; Thu,  3 Sep 2020 14:46:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728955AbgICMqY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 3 Sep 2020 08:46:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:49998 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728927AbgICMpj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 3 Sep 2020 08:45:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599137104;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gLLlaUC6kgpja0Jy2m76JUTgKW/9yyssJ2ScaQ1W1hA=;
        b=iuPc9IssnbRjNrV4c4sYs+ht2xKBPul7/F77stKa7Yal11sROGxiyV4KXolnYyFVVlOlQP
        kYmJynirvzqm0Z2JZ7z4rIk38ugYeRBJ1fBOxmyD1rW1/gFVf8uaO8Z1a0m2SRLDZCGxEn
        P6RWzhEsC/2/jW204sGaJH2BI+Zh+dQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-202-vHqdFC9lOzCHWnpyRoUQ8w-1; Thu, 03 Sep 2020 08:42:51 -0400
X-MC-Unique: vHqdFC9lOzCHWnpyRoUQ8w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0EA6364086;
        Thu,  3 Sep 2020 12:42:50 +0000 (UTC)
Received: from bfoster (ovpn-113-130.rdu2.redhat.com [10.10.113.130])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3F1BC5C22D;
        Thu,  3 Sep 2020 12:42:49 +0000 (UTC)
Date:   Thu, 3 Sep 2020 08:42:47 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Zorro Lang <zlang@redhat.com>
Cc:     fstests@vger.kernel.org, axboe@kernel.dk, io-uring@vger.kernel.org
Subject: Re: [PATCH v3 1/4] fsstress: add IO_URING read and write operations
Message-ID: <20200903124247.GA444163@bfoster>
References: <20200823063032.17297-1-zlang@redhat.com>
 <20200823063032.17297-2-zlang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200823063032.17297-2-zlang@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sun, Aug 23, 2020 at 02:30:29PM +0800, Zorro Lang wrote:
> IO_URING is a new feature of curent linux kernel, add basic IO_URING
> read/write into fsstess to cover this kind of IO testing.
> 
> Signed-off-by: Zorro Lang <zlang@redhat.com>
> ---
>  README                 |   4 +-
>  configure.ac           |   1 +
>  include/builddefs.in   |   1 +
>  ltp/Makefile           |   5 ++
>  ltp/fsstress.c         | 139 ++++++++++++++++++++++++++++++++++++++++-
>  m4/Makefile            |   1 +
>  m4/package_liburing.m4 |   4 ++
>  7 files changed, 152 insertions(+), 3 deletions(-)
>  create mode 100644 m4/package_liburing.m4
> 
...
> diff --git a/ltp/fsstress.c b/ltp/fsstress.c
> index 709fdeec..7a0e278a 100644
> --- a/ltp/fsstress.c
> +++ b/ltp/fsstress.c
...
> @@ -2170,6 +2189,108 @@ do_aio_rw(int opno, long r, int flags)
>  }
>  #endif
>  
> +#ifdef URING
> +void
> +do_uring_rw(int opno, long r, int flags)
> +{
> +	char		*buf;
> +	int		e;
> +	pathname_t	f;
> +	int		fd;
> +	size_t		len;
> +	int64_t		lr;
> +	off64_t		off;
> +	struct stat64	stb;
> +	int		v;
> +	char		st[1024];
> +	struct io_uring_sqe	*sqe;
> +	struct io_uring_cqe	*cqe;
> +	struct iovec	iovec;
> +	int		iswrite = (flags & (O_WRONLY | O_RDWR)) ? 1 : 0;
> +
> +	init_pathname(&f);
> +	if (!get_fname(FT_REGFILE, r, &f, NULL, NULL, &v)) {
> +		if (v)
> +			printf("%d/%d: do_uring_rw - no filename\n", procid, opno);
> +		goto uring_out3;
> +	}
> +	fd = open_path(&f, flags);
> +	e = fd < 0 ? errno : 0;
> +	check_cwd();
> +	if (fd < 0) {
> +		if (v)
> +			printf("%d/%d: do_uring_rw - open %s failed %d\n",
> +			       procid, opno, f.path, e);
> +		goto uring_out3;
> +	}
> +	if (fstat64(fd, &stb) < 0) {
> +		if (v)
> +			printf("%d/%d: do_uring_rw - fstat64 %s failed %d\n",
> +			       procid, opno, f.path, errno);
> +		goto uring_out2;
> +	}
> +	inode_info(st, sizeof(st), &stb, v);
> +	if (!iswrite && stb.st_size == 0) {
> +		if (v)
> +			printf("%d/%d: do_uring_rw - %s%s zero size\n", procid, opno,
> +			       f.path, st);
> +		goto uring_out2;
> +	}
> +	sqe = io_uring_get_sqe(&ring);
> +	if (!sqe) {
> +		if (v)
> +			printf("%d/%d: do_uring_rw - io_uring_get_sqe failed\n",
> +			       procid, opno);
> +		goto uring_out2;
> +	}

I'm not familiar with the io_uring bits, but do we have to do anything
to clean up this sqe object (or the cqe) before we return?

> +	lr = ((int64_t)random() << 32) + random();
> +	len = (random() % FILELEN_MAX) + 1;
> +	buf = malloc(len);
> +	if (!buf) {
> +		if (v)
> +			printf("%d/%d: do_uring_rw - malloc failed\n",
> +			       procid, opno);
> +		goto uring_out2;
> +	}
> +	iovec.iov_base = buf;
> +	iovec.iov_len = len;
> +	if (iswrite) {
> +		off = (off64_t)(lr % MIN(stb.st_size + (1024 * 1024), MAXFSIZE));
> +		off %= maxfsize;
> +		memset(buf, nameseq & 0xff, len);
> +		io_uring_prep_writev(sqe, fd, &iovec, 1, off);
> +	} else {
> +		off = (off64_t)(lr % stb.st_size);
> +		io_uring_prep_readv(sqe, fd, &iovec, 1, off);
> +	}
> +
> +	if ((e = io_uring_submit_and_wait(&ring, 1)) != 1) {
> +		if (v)
> +			printf("%d/%d: %s - io_uring_submit failed %d\n", procid, opno,
> +			       iswrite ? "uring_write" : "uring_read", e);
> +		goto uring_out1;
> +	}
> +	if ((e = io_uring_wait_cqe(&ring, &cqe)) < 0) {
> +		if (v)
> +			printf("%d/%d: %s - io_uring_wait_cqe failed %d\n", procid, opno,
> +			       iswrite ? "uring_write" : "uring_read", e);
> +		goto uring_out1;
> +	}
> +	if (v)
> +		printf("%d/%d: %s %s%s [%lld, %d(res=%d)] %d\n",
> +		       procid, opno, iswrite ? "uring_write" : "uring_read",
> +		       f.path, st, (long long)off, (int)len, cqe->res, e);
> +	io_uring_cqe_seen(&ring, cqe);
> +
> + uring_out1:
> +	free(buf);
> + uring_out2:
> +	close(fd);
> + uring_out3:
> +	free_pathname(&f);

It looks like the free_pathname() call is unconditional on exit. Could
we just initialize the other two variables properly and have something
like:

{
	...
out:
	if (buf)
		free(buf);
	if (fd != -1)
		close(fd);
	free_pathname(&f);
}

... and then we don't have to worry about using three different exit
labels in the right places?

Brian

> +}
> +#endif
> +
>  void
>  aread_f(int opno, long r)
>  {
> @@ -5044,6 +5165,22 @@ unresvsp_f(int opno, long r)
>  	close(fd);
>  }
>  
> +void
> +uring_read_f(int opno, long r)
> +{
> +#ifdef URING
> +	do_uring_rw(opno, r, O_RDONLY);
> +#endif
> +}
> +
> +void
> +uring_write_f(int opno, long r)
> +{
> +#ifdef URING
> +	do_uring_rw(opno, r, O_WRONLY);
> +#endif
> +}
> +
>  void
>  write_f(int opno, long r)
>  {
> diff --git a/m4/Makefile b/m4/Makefile
> index 7fbff822..0352534d 100644
> --- a/m4/Makefile
> +++ b/m4/Makefile
> @@ -14,6 +14,7 @@ LSRCFILES = \
>  	package_dmapidev.m4 \
>  	package_globals.m4 \
>  	package_libcdev.m4 \
> +	package_liburing.m4 \
>  	package_ncurses.m4 \
>  	package_pthread.m4 \
>  	package_ssldev.m4 \
> diff --git a/m4/package_liburing.m4 b/m4/package_liburing.m4
> new file mode 100644
> index 00000000..c92cc02a
> --- /dev/null
> +++ b/m4/package_liburing.m4
> @@ -0,0 +1,4 @@
> +AC_DEFUN([AC_PACKAGE_WANT_URING],
> +  [ AC_CHECK_HEADERS(liburing.h, [ have_uring=true ], [ have_uring=false ])
> +    AC_SUBST(have_uring)
> +  ])
> -- 
> 2.20.1
> 

