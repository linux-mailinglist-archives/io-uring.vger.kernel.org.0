Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31F26281ABC
	for <lists+io-uring@lfdr.de>; Fri,  2 Oct 2020 20:19:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387929AbgJBSTx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 2 Oct 2020 14:19:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59359 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1733260AbgJBSTx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 2 Oct 2020 14:19:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601662792;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PfjQHxjhLus3eBBSP2s+UwyiILQseGx1geJl30A8R2A=;
        b=QF4GVhjW5A0uOjk+Lu4hN2eMIgf1Bnrf/gbjhYzop5ygxlNEAmAwnOWfdDPHRHMj3WeXAR
        EVndoF1gN3+Q/Oqp7y1QebIT+31SiyBLMyjc4VkD+dPL0dfelfTrPFCMNwW/zLkuy7m0uf
        rqlYydrKzjz618BBHgEQSmxcUWUN3oA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-271-WsZgbmF-NlGYsZML8U1NAw-1; Fri, 02 Oct 2020 14:19:50 -0400
X-MC-Unique: WsZgbmF-NlGYsZML8U1NAw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8E8D5802B71;
        Fri,  2 Oct 2020 18:19:49 +0000 (UTC)
Received: from bfoster (ovpn-114-177.rdu2.redhat.com [10.10.114.177])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 129CB60C15;
        Fri,  2 Oct 2020 18:19:48 +0000 (UTC)
Date:   Fri, 2 Oct 2020 14:19:47 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Zorro Lang <zlang@redhat.com>
Cc:     fstests@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [PATCH 1/3] src/feature: add IO_URING feature checking
Message-ID: <20201002181947.GC4708@bfoster>
References: <20200916171443.29546-1-zlang@redhat.com>
 <20200916171443.29546-2-zlang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200916171443.29546-2-zlang@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Sep 17, 2020 at 01:14:41AM +0800, Zorro Lang wrote:
> IO_URING is a new feature for GNU/Linux system, if someone case of
> xfstests tests this feature, better to check if current system
> supports it, or need _notrun.
> 
> Signed-off-by: Zorro Lang <zlang@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  src/Makefile  |  4 ++++
>  src/feature.c | 41 ++++++++++++++++++++++++++++++++++++++---
>  2 files changed, 42 insertions(+), 3 deletions(-)
> 
> diff --git a/src/Makefile b/src/Makefile
> index 643c1916..f1422c5c 100644
> --- a/src/Makefile
> +++ b/src/Makefile
> @@ -65,6 +65,10 @@ SUBDIRS += aio-dio-regress
>  LLDLIBS += -laio
>  endif
>  
> +ifeq ($(HAVE_URING), true)
> +LLDLIBS += -luring
> +endif
> +
>  CFILES = $(TARGETS:=.c)
>  LDIRT = $(TARGETS) fssum
>  
> diff --git a/src/feature.c b/src/feature.c
> index a7eb7595..df550cf6 100644
> --- a/src/feature.c
> +++ b/src/feature.c
> @@ -19,6 +19,7 @@
>   *
>   * Test for machine features
>   *   -A  test whether AIO syscalls are available
> + *   -R  test whether IO_URING syscalls are available
>   *   -o  report a number of online cpus
>   *   -s  report pagesize
>   *   -w  report bits per long
> @@ -39,6 +40,10 @@
>  #include <libaio.h>
>  #endif
>  
> +#ifdef HAVE_LIBURING_H
> +#include <liburing.h>
> +#endif
> +
>  #ifndef USRQUOTA
>  #define USRQUOTA  0
>  #endif
> @@ -59,7 +64,7 @@ usage(void)
>  	fprintf(stderr, "Usage: feature [-v] -<q|u|g|p|U|G|P> <filesystem>\n");
>  	fprintf(stderr, "       feature [-v] -c <file>\n");
>  	fprintf(stderr, "       feature [-v] -t <file>\n");
> -	fprintf(stderr, "       feature -A | -o | -s | -w\n");
> +	fprintf(stderr, "       feature -A | -R | -o | -s | -w\n");
>  	exit(1);
>  }
>  
> @@ -215,6 +220,29 @@ check_aio_support(void)
>  #endif
>  }
>  
> +static int
> +check_uring_support(void)
> +{
> +#ifdef HAVE_LIBURING_H
> +	struct io_uring ring;
> +	int err;
> +
> +	err = io_uring_queue_init(1, &ring, 0);
> +	if (err == 0)
> +		return 0;
> +
> +	if (err == -ENOSYS) /* CONFIG_IO_URING=n */
> +		return 1;
> +
> +	fprintf(stderr, "unexpected error from io_uring_queue_init(): %s\n",
> +		strerror(-err));
> +	return 2;
> +#else
> +	/* liburing is unavailable, assume IO_URING is unsupported */
> +	return 1;
> +#endif
> +}
> +
>  
>  int
>  main(int argc, char **argv)
> @@ -228,6 +256,7 @@ main(int argc, char **argv)
>  	int	pflag = 0;
>  	int	Pflag = 0;
>  	int	qflag = 0;
> +	int	Rflag = 0;
>  	int	sflag = 0;
>  	int	uflag = 0;
>  	int	Uflag = 0;
> @@ -235,7 +264,7 @@ main(int argc, char **argv)
>  	int	oflag = 0;
>  	char	*fs = NULL;
>  
> -	while ((c = getopt(argc, argv, "ActgGopPqsuUvw")) != EOF) {
> +	while ((c = getopt(argc, argv, "ActgGopPqRsuUvw")) != EOF) {
>  		switch (c) {
>  		case 'A':
>  			Aflag++;
> @@ -264,6 +293,9 @@ main(int argc, char **argv)
>  		case 'q':
>  			qflag++;
>  			break;
> +		case 'R':
> +			Rflag++;
> +			break;
>  		case 's':
>  			sflag++;
>  			break;
> @@ -289,7 +321,7 @@ main(int argc, char **argv)
>  		if (optind != argc-1)	/* need a device */
>  			usage();
>  		fs = argv[argc-1];
> -	} else if (Aflag || wflag || sflag || oflag) {
> +	} else if (Aflag || Rflag || wflag || sflag || oflag) {
>  		if (optind != argc)
>  			usage();
>  	} else 
> @@ -317,6 +349,9 @@ main(int argc, char **argv)
>  	if (Aflag)
>  		return(check_aio_support());
>  
> +	if (Rflag)
> +		return(check_uring_support());
> +
>  	if (sflag) {
>  		printf("%d\n", getpagesize());
>  		exit(0);
> -- 
> 2.20.1
> 

