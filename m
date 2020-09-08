Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 628F8261A6C
	for <lists+io-uring@lfdr.de>; Tue,  8 Sep 2020 20:35:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731219AbgIHSfq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 8 Sep 2020 14:35:46 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:47030 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728164AbgIHSfH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 8 Sep 2020 14:35:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599590106;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=l0XHW41c6f+gjb9r8ZN7wT6ql3QbHwHSiktKn1mWqls=;
        b=OlABphukUswUA+LqKLETAYTNxniGvJb6ee21wNtnDd/0cRS0O7YoBYanEY6c3YmcZ99eVO
        m09X/I4jxye5gPIFQvYBaz/NNMXxxInsm5UUpPi47xNZgGS9Bx6EC6NCqPPHKwp8orXi5h
        ByHK9NjhfbAoiQy13tWgwb1AgwuYAKA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-576-lkUh3mT0N92oVuACH5FpMQ-1; Tue, 08 Sep 2020 14:34:56 -0400
X-MC-Unique: lkUh3mT0N92oVuACH5FpMQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A584110062B8;
        Tue,  8 Sep 2020 18:34:52 +0000 (UTC)
Received: from bfoster (ovpn-113-130.rdu2.redhat.com [10.10.113.130])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 34D3A8246B;
        Tue,  8 Sep 2020 18:34:52 +0000 (UTC)
Date:   Tue, 8 Sep 2020 14:34:50 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Zorro Lang <zlang@redhat.com>
Cc:     fstests@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [PATCH v4 1/5] fsstress: add IO_URING read and write operations
Message-ID: <20200908183450.GA737175@bfoster>
References: <20200906175513.17595-1-zlang@redhat.com>
 <20200906175513.17595-2-zlang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200906175513.17595-2-zlang@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Sep 07, 2020 at 01:55:09AM +0800, Zorro Lang wrote:
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
> index 709fdeec..2c584ef0 100644
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
...
> +
> + uring_out:
> +	if (buf)
> +		free(buf);
> +	if (fd > 0)

Nit: I'd replace this with (fd != -1), but otherwise:

Reviewed-by: Brian Foster <bfoster@redhat.com>

> +		close(fd);
> +	free_pathname(&f);
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

