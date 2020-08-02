Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 664AE2359B6
	for <lists+io-uring@lfdr.de>; Sun,  2 Aug 2020 20:09:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726345AbgHBSJS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 2 Aug 2020 14:09:18 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:22005 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726163AbgHBSJS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 2 Aug 2020 14:09:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596391755;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=63FRSIjJgIws/T8GWZC6LViBQSutCw5Hd18zfq1Vt3M=;
        b=PdyRW4iaE9BUZzLsmLeh0eJPTPndQG1oxHUrtjE5rr9wxuUfasOo5r/k7C40CcAyKbF9OC
        uSSoYwBOiHhi9UFH1RBax2x0OPOdKH+H1x5Yn8qTmX2nsSeJeOwqu9rsclv69tK8MMCrWO
        YPtYhXXtqMo7pmov0+GD+FUM8LyJ7sw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-205-__2FgH8gO4-sO3Tqn0gZFA-1; Sun, 02 Aug 2020 14:09:13 -0400
X-MC-Unique: __2FgH8gO4-sO3Tqn0gZFA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7810257;
        Sun,  2 Aug 2020 18:09:12 +0000 (UTC)
Received: from localhost (dhcp-12-102.nay.redhat.com [10.66.12.102])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E494C60C05;
        Sun,  2 Aug 2020 18:09:11 +0000 (UTC)
Date:   Mon, 3 Aug 2020 02:21:42 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     fstests@vger.kernel.org
Cc:     io-uring@vger.kernel.org, jmoyer@redhat.com
Subject: Re: [PATCH 4/4] fsx: add IO_URING test
Message-ID: <20200802182142.GO2937@dhcp-12-102.nay.redhat.com>
Mail-Followup-To: fstests@vger.kernel.org, io-uring@vger.kernel.org,
        jmoyer@redhat.com
References: <20200728182320.8762-1-zlang@redhat.com>
 <20200728182320.8762-5-zlang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200728182320.8762-5-zlang@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Jul 29, 2020 at 02:23:20AM +0800, Zorro Lang wrote:
> New IO_URING test for fsx, use -U option to enable IO_URING test.
> 
> Signed-off-by: Zorro Lang <zlang@redhat.com>
> ---
>  ltp/fsx.c | 154 +++++++++++++++++++++++++++++++++++++++++++++++++-----
>  1 file changed, 140 insertions(+), 14 deletions(-)
> 
> diff --git a/ltp/fsx.c b/ltp/fsx.c
> index 7c76655a..1b7401a2 100644
> --- a/ltp/fsx.c
> +++ b/ltp/fsx.c
> @@ -34,6 +34,9 @@
>  #ifdef AIO
>  #include <libaio.h>
>  #endif
> +#ifdef URING
> +#include <liburing.h>
> +#endif
>  #include <sys/syscall.h>
>  
>  #ifndef MAP_FILE
> @@ -176,21 +179,17 @@ int	integrity = 0;			/* -i flag */
>  int	fsxgoodfd = 0;
>  int	o_direct;			/* -Z */
>  int	aio = 0;
> +int	uring = 0;
>  int	mark_nr = 0;
>  
>  int page_size;
>  int page_mask;
>  int mmap_mask;
> -#ifdef AIO
> -int aio_rw(int rw, int fd, char *buf, unsigned len, unsigned offset);
> +int fsx_rw(int rw, int fd, char *buf, unsigned len, unsigned offset);
>  #define READ 0
>  #define WRITE 1
> -#define fsxread(a,b,c,d)	aio_rw(READ, a,b,c,d)
> -#define fsxwrite(a,b,c,d)	aio_rw(WRITE, a,b,c,d)
> -#else
> -#define fsxread(a,b,c,d)	read(a,b,c)
> -#define fsxwrite(a,b,c,d)	write(a,b,c)
> -#endif
> +#define fsxread(a,b,c,d)	fsx_rw(READ, a,b,c,d)
> +#define fsxwrite(a,b,c,d)	fsx_rw(WRITE, a,b,c,d)
>  
>  const char *replayops = NULL;
>  const char *recordops = NULL;
> @@ -2242,7 +2241,7 @@ void
>  usage(void)
>  {
>  	fprintf(stdout, "usage: %s",
> -		"fsx [-dknqxABEFJLOWZ] [-b opnum] [-c Prob] [-g filldata] [-i logdev] [-j logid] [-l flen] [-m start:end] [-o oplen] [-p progressinterval] [-r readbdy] [-s style] [-t truncbdy] [-w writebdy] [-D startingop] [-N numops] [-P dirpath] [-S seed] fname\n\
> +		"fsx [-dknqxBEFJLOWZ][-A|-U] [-b opnum] [-c Prob] [-g filldata] [-i logdev] [-j logid] [-l flen] [-m start:end] [-o oplen] [-p progressinterval] [-r readbdy] [-s style] [-t truncbdy] [-w writebdy] [-D startingop] [-N numops] [-P dirpath] [-S seed] fname\n\
>  	-b opnum: beginning operation number (default 1)\n\
>  	-c P: 1 in P chance of file close+open at each op (default infinity)\n\
>  	-d: debug output for all operations\n\
> @@ -2265,7 +2264,10 @@ usage(void)
>  	-y synchronize changes to a file\n"
>  
>  #ifdef AIO
> -"	-A: Use the AIO system calls\n"
> +"	-A: Use the AIO system calls, -A excludes -U\n"
> +#endif
> +#ifdef URING
> +"	-U: Use the IO_URING system calls, -U excludes -A\n"
>  #endif
>  "	-D startingop: debug output starting at specified operation\n"
>  #ifdef HAVE_LINUX_FALLOC_H
> @@ -2425,13 +2427,127 @@ out_error:
>  	errno = -ret;
>  	return -1;
>  }
> +#endif
> +
> +#ifdef URING
> +struct io_uring ring;
> +#define URING_ENTRIES	1024
> +int
> +uring_setup()
> +{
> +	int ret;
> +
> +	ret = io_uring_queue_init(URING_ENTRIES, &ring, 0);
> +	if (ret != 0) {
> +		fprintf(stderr, "uring_setup: io_uring_queue_init failed: %s\n",
> +                        strerror(ret));
> +                return -1;
> +        }
> +        return 0;
> +}
>  
> -int aio_rw(int rw, int fd, char *buf, unsigned len, unsigned offset)
> +int
> +__uring_rw(int rw, int fd, char *buf, unsigned len, unsigned offset)
>  {
> +        struct io_uring_sqe	*sqe;
> +        struct io_uring_cqe	*cqe;
>  	int ret;
> +	int res, res2 = 0;
> +	char *p = buf;
> +	unsigned l = len;
> +	unsigned o = offset;
> +
> +	/*
> +	 * Due to io_uring tries non-blocking IOs (especially read), that
> +	 * always cause 'normal' short reading. To avoid this short read
> +	 * fail, try to loop read/write (escpecilly read) data.
> +	 */
> + uring_loop:
> +	sqe = io_uring_get_sqe(&ring);
> +	if (!sqe) {
> +		fprintf(stderr, "uring_rw: io_uring_get_sqe failed: %s\n",
> +		        strerror(errno));
> +		return -1;
> +        }
> +
> +	if (rw == READ) {
> +		io_uring_prep_read(sqe, fd, p, l, o);
> +	} else {
> +		io_uring_prep_write(sqe, fd, p, l, o);

I just found some old version liburing doesn't support io_uring_prep_read() and
io_uring_prep_write() functions:

  # make
  ...
  /tmp/ccmrsUN8.o: In function `__uring_rw':
  /home/xfstests-zlang/ltp/fsx.c:2474: undefined reference to `io_uring_prep_read'
  /home/xfstests-zlang/ltp/fsx.c:2476: undefined reference to `io_uring_prep_write'
  collect2: error: ld returned 1 exit status
  ...

  # grep -rsn io_uring_prep_read /usr/include/liburing.h
  189:static inline void io_uring_prep_readv(struct io_uring_sqe *sqe, int fd,
  196:static inline void io_uring_prep_read_fixed(struct io_uring_sqe *sqe, int fd,

  # rpm -q liburing
  liburing-0.2-2.xxx.xxxx

I'll turn to use io_uring_prep_readv() and io_uring_prep_writev() to get better
compatibility.

Thanks,
Zorro


> +	}
> +
> +	ret = io_uring_submit(&ring);
> +	if (ret != 1) {
> +		fprintf(stderr, "errcode=%d\n", -ret);
> +		fprintf(stderr, "uring %s: io_uring_submit failed: %s\n",
> +		        rw == READ ? "read":"write", strerror(-ret));
> +		goto uring_error;
> +	}
> +
> +	ret = io_uring_wait_cqe(&ring, &cqe);
> +	if (ret < 0) {
> +		if (ret == 0)
> +			fprintf(stderr, "uring %s: no events available\n",
> +			        rw == READ ? "read":"write");
> +		else {
> +			fprintf(stderr, "errcode=%d\n", -ret);
> +			fprintf(stderr, "uring %s: io_uring_wait_cqe failed: %s\n",
> +			        rw == READ ? "read":"write", strerror(-ret));
> +		}
> +		goto uring_error;
> +	}
> +	res = cqe->res;
> +	io_uring_cqe_seen(&ring, cqe);
> +
> +	res2 += res;
> +	if (len != res2) {
> +		if (res > 0) {
> +			o += res;
> +			l -= res;
> +			p += res;
> +			if (l > 0)
> +				goto uring_loop;
> +		} else if (res < 0) {
> +			ret = res;
> +			fprintf(stderr, "errcode=%d\n", -ret);
> +			fprintf(stderr, "uring %s: io_uring failed: %s\n",
> +			        rw == READ ? "read":"write", strerror(-ret));
> +			goto uring_error;
> +		} else {
> +			fprintf(stderr, "uring %s bad io length: %d instead of %u\n",
> +			        rw == READ ? "read":"write", res2, len);
> +		}
> +	}
> +	return res2;
> +
> + uring_error:
> +	/*
> +	 * The caller expects error return in traditional libc
> +	 * convention, i.e. -1 and the errno set to error.
> +	 */
> +	errno = -ret;
> +	return -1;
> +}
> +#endif
> +
> +int fsx_rw(int rw, int fd, char *buf, unsigned len, unsigned offset)
> +{
> +	int ret = -1;
>  
>  	if (aio) {
> +#ifdef AIO
>  		ret = __aio_rw(rw, fd, buf, len, offset);
> +#elif
> +		fprintf(stderr, "io_rw: need AIO support!\n");
> +		exit(111);
> +#endif
> +	} else if (uring) {
> +#ifdef URING
> +		ret = __uring_rw(rw, fd, buf, len, offset);
> +#elif
> +		fprintf(stderr, "io_rw: need IO_URING support!\n");
> +		exit(111);
> +#endif
>  	} else {
>  		if (rw == READ)
>  			ret = read(fd, buf, len);
> @@ -2441,8 +2557,6 @@ int aio_rw(int rw, int fd, char *buf, unsigned len, unsigned offset)
>  	return ret;
>  }
>  
> -#endif
> -
>  #define test_fallocate(mode) __test_fallocate(mode, #mode)
>  
>  int
> @@ -2496,7 +2610,7 @@ main(int argc, char **argv)
>  	setvbuf(stdout, (char *)0, _IOLBF, 0); /* line buffered stdout */
>  
>  	while ((ch = getopt_long(argc, argv,
> -				 "b:c:dfg:i:j:kl:m:no:p:qr:s:t:w:xyABD:EFJKHzCILN:OP:RS:WXZ",
> +				 "b:c:dfg:i:j:kl:m:no:p:qr:s:t:w:xyABD:EFJKHzCILN:OP:RS:UWXZ",
>  				 longopts, NULL)) != EOF)
>  		switch (ch) {
>  		case 'b':
> @@ -2604,6 +2718,9 @@ main(int argc, char **argv)
>  		case 'A':
>  		        aio = 1;
>  			break;
> +		case 'U':
> +		        uring = 1;
> +			break;
>  		case 'D':
>  			debugstart = getnum(optarg, &endp);
>  			if (debugstart < 1)
> @@ -2694,6 +2811,11 @@ main(int argc, char **argv)
>  	if (argc != 1)
>  		usage();
>  
> +	if (aio && uring) {
> +		fprintf(stderr, "-A and -U shouldn't be used together\n");
> +		usage();
> +	}
> +
>  	if (integrity && !dirpath) {
>  		fprintf(stderr, "option -i <logdev> requires -P <dirpath>\n");
>  		usage();
> @@ -2784,6 +2906,10 @@ main(int argc, char **argv)
>  	if (aio) 
>  		aio_setup();
>  #endif
> +#ifdef URING
> +	if (uring)
> +		uring_setup();
> +#endif
>  
>  	if (!(o_flags & O_TRUNC)) {
>  		off_t ret;
> -- 
> 2.20.1
> 

