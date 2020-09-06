Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1BCB25EEC6
	for <lists+io-uring@lfdr.de>; Sun,  6 Sep 2020 17:43:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726931AbgIFPnV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 6 Sep 2020 11:43:21 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:58705 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729059AbgIFPly (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 6 Sep 2020 11:41:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599406901;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JamLZLf63jPiRb0BK/eb2cghYFWk5z2iOGAO2liVolw=;
        b=GvbodaWCsQ6U5boEvxnVBnXDF83G8qKo/eX7CdeLWwJ8kESpq6+fLTCWwbqUk58GzvTT3J
        yl+phpuzD1UOJo7BUP7lrPkkSozETQ+KqFCr8sP7Ltk+jQxePB0KWcgNgfGoGEHmNRPKj7
        GupQ2ekXCHdpV9PBSUZPjgfC5nSeqmE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-341-7YqMtamnMz6rtftuYtA0Ew-1; Sun, 06 Sep 2020 11:41:39 -0400
X-MC-Unique: 7YqMtamnMz6rtftuYtA0Ew-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 44D2E801AAC;
        Sun,  6 Sep 2020 15:41:38 +0000 (UTC)
Received: from localhost (dhcp-12-102.nay.redhat.com [10.66.12.102])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 871975C225;
        Sun,  6 Sep 2020 15:41:37 +0000 (UTC)
Date:   Sun, 6 Sep 2020 23:55:16 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     fstests@vger.kernel.org, axboe@kernel.dk, io-uring@vger.kernel.org
Subject: Re: [PATCH v3 4/4] fsx: add IO_URING test
Message-ID: <20200906155516.GB2937@dhcp-12-102.nay.redhat.com>
Mail-Followup-To: Brian Foster <bfoster@redhat.com>,
        fstests@vger.kernel.org, axboe@kernel.dk, io-uring@vger.kernel.org
References: <20200823063032.17297-1-zlang@redhat.com>
 <20200823063032.17297-5-zlang@redhat.com>
 <20200903124413.GD444163@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200903124413.GD444163@bfoster>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Sep 03, 2020 at 08:44:13AM -0400, Brian Foster wrote:
> On Sun, Aug 23, 2020 at 02:30:32PM +0800, Zorro Lang wrote:
> > New IO_URING test for fsx, use -U option to enable IO_URING test.
> > 
> > Signed-off-by: Zorro Lang <zlang@redhat.com>
> > ---
> 
> Note that this one doesn't compile if one of the ifdefs doesn't evaluate
> true:
> 
> fsx.c:2551:6: error: #elif with no expression
>  2551 | #elif
>       |      ^
>     [CC]    fsx
> fsx.c: In function 'fsx_rw':
> fsx.c:2551:6: error: #elif with no expression
>  2551 | #elif
>       |      ^
> gmake[2]: *** [Makefile:52: fsx] Error 1
> gmake[1]: *** [include/buildrules:30: ltp] Error 2
> make: *** [Makefile:53: default] Error 2
> 
> I suspect you want to replace both of those with #else. Otherwise mostly
> some aesthetic comments...

Sorry, that's truely a mistake, I'll fix it :)

> 
> >  ltp/fsx.c | 158 +++++++++++++++++++++++++++++++++++++++++++++++++-----
> >  1 file changed, 144 insertions(+), 14 deletions(-)
> > 
> > diff --git a/ltp/fsx.c b/ltp/fsx.c
> > index 7c76655a..05663528 100644
> > --- a/ltp/fsx.c
> > +++ b/ltp/fsx.c
> ...
> > @@ -176,21 +179,17 @@ int	integrity = 0;			/* -i flag */
> >  int	fsxgoodfd = 0;
> >  int	o_direct;			/* -Z */
> >  int	aio = 0;
> > +int	uring = 0;
> >  int	mark_nr = 0;
> >  
> >  int page_size;
> >  int page_mask;
> >  int mmap_mask;
> > -#ifdef AIO
> > -int aio_rw(int rw, int fd, char *buf, unsigned len, unsigned offset);
> > +int fsx_rw(int rw, int fd, char *buf, unsigned len, unsigned offset);
> >  #define READ 0
> >  #define WRITE 1
> > -#define fsxread(a,b,c,d)	aio_rw(READ, a,b,c,d)
> > -#define fsxwrite(a,b,c,d)	aio_rw(WRITE, a,b,c,d)
> > -#else
> > -#define fsxread(a,b,c,d)	read(a,b,c)
> > -#define fsxwrite(a,b,c,d)	write(a,b,c)
> > -#endif
> > +#define fsxread(a,b,c,d)	fsx_rw(READ, a,b,c,d)
> > +#define fsxwrite(a,b,c,d)	fsx_rw(WRITE, a,b,c,d)
> >  
> 
> Could we do the refactoring that introduces fsx_rw and shuffles around
> some of the existing AIO in an initial refactoring patch?

May I save this pre-patch, if you don't insist on that :-P

> 
> >  const char *replayops = NULL;
> >  const char *recordops = NULL;
> ...
> > @@ -2425,13 +2427,131 @@ out_error:
> >  	errno = -ret;
> >  	return -1;
> >  }
> > +#endif
> > +
> > +#ifdef URING
> 
> A whitespace line here...
> 
> > +struct io_uring ring;
> > +#define URING_ENTRIES	1024
> 
> ... and here would help readability.
> 
> > +int
> > +uring_setup()
> > +{
> > +	int ret;
> > +
> > +	ret = io_uring_queue_init(URING_ENTRIES, &ring, 0);
> > +	if (ret != 0) {
> > +		fprintf(stderr, "uring_setup: io_uring_queue_init failed: %s\n",
> > +                        strerror(ret));
> > +                return -1;
> > +        }
> > +        return 0;
> 
> Looks like some whitespace damage here.
> 
> Also, the fsstress patch has a io_uring_queue_exit() call but I don't
> see one in this patch. Is that not needed?

There's not aio_destroy() either. I think due to fsstress is a multi-process
test, so it'd like to destroy io_uring or aio at each process end. But fsx is
a pure single process test, the io_uring or aio will destroyed when fsx exit.
I can add io_uring_queue_exit() and aio_destroy() if you think it would be
better.

> 
> > +}
> >  
> > -int aio_rw(int rw, int fd, char *buf, unsigned len, unsigned offset)
> > +int
> > +__uring_rw(int rw, int fd, char *buf, unsigned len, unsigned offset)
> 
> Do we still need the __ in the function names here and for __aio_rw()?

I don't think it's needed. I use the "__" just due to the old __aio_rw() has. I
can remove both "__" of __aio_rw and __uring_rw.

> 
> >  {
> > +	struct io_uring_sqe	*sqe;
> > +	struct io_uring_cqe	*cqe;
> > +	struct iovec		iovec;
> >  	int ret;
> > +	int res, res2 = 0;
> > +	char *p = buf;
> > +	unsigned l = len;
> > +	unsigned o = offset;
> > +
> > +
> > +	/*
> > +	 * Due to io_uring tries non-blocking IOs (especially read), that
> > +	 * always cause 'normal' short reading. To avoid this short read
> > +	 * fail, try to loop read/write (escpecilly read) data.
> > +	 */
> > + uring_loop:
> > +	sqe = io_uring_get_sqe(&ring);
> > +	if (!sqe) {
> > +		fprintf(stderr, "uring_rw: io_uring_get_sqe failed: %s\n",
> > +		        strerror(errno));
> > +		return -1;
> > +        }
> > +
> > +	iovec.iov_base = p;
> > +	iovec.iov_len = l;
> > +	if (rw == READ) {
> > +		io_uring_prep_readv(sqe, fd, &iovec, 1, o);
> > +	} else {
> > +		io_uring_prep_writev(sqe, fd, &iovec, 1, o);
> > +	}
> > +
> > +	ret = io_uring_submit_and_wait(&ring, 1);
> > +	if (ret != 1) {
> > +		fprintf(stderr, "errcode=%d\n", -ret);
> > +		fprintf(stderr, "uring %s: io_uring_submit failed: %s\n",
> > +		        rw == READ ? "read":"write", strerror(-ret));
> > +		goto uring_error;
> > +	}
> > +
> > +	ret = io_uring_wait_cqe(&ring, &cqe);
> > +	if (ret < 0) {
> > +		if (ret == 0)
> 
> That doesn't look right since we only get here if ret < 0.

Thanks, it should be (ret <= 0)

> 
> > +			fprintf(stderr, "uring %s: no events available\n",
> > +			        rw == READ ? "read":"write");
> > +		else {
> > +			fprintf(stderr, "errcode=%d\n", -ret);
> > +			fprintf(stderr, "uring %s: io_uring_wait_cqe failed: %s\n",
> > +			        rw == READ ? "read":"write", strerror(-ret));
> > +		}
> > +		goto uring_error;
> > +	}
> > +	res = cqe->res;
> > +	io_uring_cqe_seen(&ring, cqe);
> > +
> > +	res2 += res;
> > +	if (len != res2) {
> > +		if (res > 0) {
> > +			o += res;
> > +			l -= res;
> > +			p += res;
> > +			if (l > 0)
> > +				goto uring_loop;
> > +		} else if (res < 0) {
> > +			ret = res;
> > +			fprintf(stderr, "errcode=%d\n", -ret);
> > +			fprintf(stderr, "uring %s: io_uring failed: %s\n",
> > +			        rw == READ ? "read":"write", strerror(-ret));
> > +			goto uring_error;
> 
> Can we elevate the error checks into the top level rather than nesting
> logic like this? It's a little confusing to read and it looks
> particularly odd since we've already done res2 += res before we get
> here.
> 
> Also I'm wondering if this whole function would read a little better as
> a do {} while() loop rather than using a label and goto.

Sure, I'll try to change that.

> 
> > +		} else {
> > +			fprintf(stderr, "uring %s bad io length: %d instead of %u\n",
> > +			        rw == READ ? "read":"write", res2, len);
> > +		}
> > +	}
> > +	return res2;
> > +
> > + uring_error:
> > +	/*
> > +	 * The caller expects error return in traditional libc
> > +	 * convention, i.e. -1 and the errno set to error.
> > +	 */
> > +	errno = -ret;
> > +	return -1;
> > +}
> > +#endif
> > +
> > +int fsx_rw(int rw, int fd, char *buf, unsigned len, unsigned offset)
> > +{
> > +	int ret = -1;
> >  
> >  	if (aio) {
> > +#ifdef AIO
> >  		ret = __aio_rw(rw, fd, buf, len, offset);
> > +#elif
> > +		fprintf(stderr, "io_rw: need AIO support!\n");
> > +		exit(111);
> > +#endif
> > +	} else if (uring) {
> > +#ifdef URING
> > +		ret = __uring_rw(rw, fd, buf, len, offset);
> > +#elif
> > +		fprintf(stderr, "io_rw: need IO_URING support!\n");
> > +		exit(111);
> > +#endif
> 
> I think the ifdefs would be cleaner if used to define stubbed out
> variants of the associated functions. E.g.:
> 
> #ifdef URING
> int
> __uring_rw(int rw, int fd, char *buf, unsigned len, unsigned offset)
> {
> 	<do uring I/O>
> }
> #else
> int
> __uring_rw(int rw, int fd, char *buf, unsigned len, unsigned offset)
> {
> 	fprintf(stderr, "io_rw: need IO_URING support!\n");
> 	exit(111);
> }
> #endif

Sure, will do that.

Thanks for your review, Brian!
Zorro

> 
> Brian
> 
> >  	} else {
> >  		if (rw == READ)
> >  			ret = read(fd, buf, len);
> > @@ -2441,8 +2561,6 @@ int aio_rw(int rw, int fd, char *buf, unsigned len, unsigned offset)
> >  	return ret;
> >  }
> >  
> > -#endif
> > -
> >  #define test_fallocate(mode) __test_fallocate(mode, #mode)
> >  
> >  int
> > @@ -2496,7 +2614,7 @@ main(int argc, char **argv)
> >  	setvbuf(stdout, (char *)0, _IOLBF, 0); /* line buffered stdout */
> >  
> >  	while ((ch = getopt_long(argc, argv,
> > -				 "b:c:dfg:i:j:kl:m:no:p:qr:s:t:w:xyABD:EFJKHzCILN:OP:RS:WXZ",
> > +				 "b:c:dfg:i:j:kl:m:no:p:qr:s:t:w:xyABD:EFJKHzCILN:OP:RS:UWXZ",
> >  				 longopts, NULL)) != EOF)
> >  		switch (ch) {
> >  		case 'b':
> > @@ -2604,6 +2722,9 @@ main(int argc, char **argv)
> >  		case 'A':
> >  		        aio = 1;
> >  			break;
> > +		case 'U':
> > +		        uring = 1;
> > +			break;
> >  		case 'D':
> >  			debugstart = getnum(optarg, &endp);
> >  			if (debugstart < 1)
> > @@ -2694,6 +2815,11 @@ main(int argc, char **argv)
> >  	if (argc != 1)
> >  		usage();
> >  
> > +	if (aio && uring) {
> > +		fprintf(stderr, "-A and -U shouldn't be used together\n");
> > +		usage();
> > +	}
> > +
> >  	if (integrity && !dirpath) {
> >  		fprintf(stderr, "option -i <logdev> requires -P <dirpath>\n");
> >  		usage();
> > @@ -2784,6 +2910,10 @@ main(int argc, char **argv)
> >  	if (aio) 
> >  		aio_setup();
> >  #endif
> > +#ifdef URING
> > +	if (uring)
> > +		uring_setup();
> > +#endif
> >  
> >  	if (!(o_flags & O_TRUNC)) {
> >  		off_t ret;
> > -- 
> > 2.20.1
> > 

