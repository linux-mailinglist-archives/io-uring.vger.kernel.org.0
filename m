Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C88162625F2
	for <lists+io-uring@lfdr.de>; Wed,  9 Sep 2020 05:44:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbgIIDoc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 8 Sep 2020 23:44:32 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:54733 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725984AbgIIDo2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 8 Sep 2020 23:44:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599623066;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kl3ykfqlCfmI1FYDEWFA5ocyrEq9f27pvma5ikAQwbE=;
        b=GkgHXFkucu3w+9GZ65bghCcx5iaxKBQvL8JhsMsutJZTIrKB3y2liDjNBMg4vBNFTa/C3q
        63spG0DZdp/ysHMLyAk/5HtgG0hRjJQQootWEUkyY9r4W6S2h9SntBnWP1+LcXOP/HWsqI
        uPNMJmdKAtG7ne0SVM+5IAqpRMNyp6A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-391-a_jamZHCMBKhDM0QnDJW-Q-1; Tue, 08 Sep 2020 23:44:24 -0400
X-MC-Unique: a_jamZHCMBKhDM0QnDJW-Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 674561019632;
        Wed,  9 Sep 2020 03:44:23 +0000 (UTC)
Received: from localhost (dhcp-12-102.nay.redhat.com [10.66.12.102])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D4CEF7E46E;
        Wed,  9 Sep 2020 03:44:22 +0000 (UTC)
Date:   Wed, 9 Sep 2020 11:58:07 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     fstests@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [PATCH v4 5/5] fsx: add IO_URING test
Message-ID: <20200909035807.GE2937@dhcp-12-102.nay.redhat.com>
Mail-Followup-To: Brian Foster <bfoster@redhat.com>,
        fstests@vger.kernel.org, io-uring@vger.kernel.org
References: <20200906175513.17595-1-zlang@redhat.com>
 <20200906175513.17595-6-zlang@redhat.com>
 <20200908183625.GE737175@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200908183625.GE737175@bfoster>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Sep 08, 2020 at 02:36:25PM -0400, Brian Foster wrote:
> On Mon, Sep 07, 2020 at 01:55:13AM +0800, Zorro Lang wrote:
> > New IO_URING test for fsx, use -U option to enable IO_URING test.
> > 
> > Signed-off-by: Zorro Lang <zlang@redhat.com>
> > ---
> 
> Just a couple nits...
> 
> >  ltp/fsx.c | 134 ++++++++++++++++++++++++++++++++++++++++++++++++++++--
> >  1 file changed, 131 insertions(+), 3 deletions(-)
> > 
> > diff --git a/ltp/fsx.c b/ltp/fsx.c
> > index 92f506ba..e7f23d15 100644
> > --- a/ltp/fsx.c
> > +++ b/ltp/fsx.c
> ...
> > @@ -2429,6 +2436,113 @@ aio_rw(int rw, int fd, char *buf, unsigned len, unsigned offset)
> ...
> > +int
> > +uring_rw(int rw, int fd, char *buf, unsigned len, unsigned offset)
> > +{
> > +	struct io_uring_sqe     *sqe;
> > +	struct io_uring_cqe     *cqe;
> > +	struct iovec            iovec;
> > +	int ret;
> > +	int res, res2 = 0;
> > +	char *p = buf;
> > +	unsigned l = len;
> > +	unsigned o = offset;
> 
> It looks a little odd that some variable names are aligned with tabs
> while others use a single space.. I'm not sure we care one way or
> another for xfstests, but perhaps use one approach or the other..?
> 
> > +
> > +	/*
> > +	 * Due to io_uring tries non-blocking IOs (especially read), that
> > +	 * always cause 'normal' short reading. To avoid this short read
> > +	 * fail, try to loop read/write (escpecilly read) data.
> > +	 */
> > +	while (l > 0) {
> > +		sqe = io_uring_get_sqe(&ring);
> > +		if (!sqe) {
> > +			fprintf(stderr, "uring_rw: io_uring_get_sqe failed: %s\n",
> > +					strerror(errno));
> > +			return -1;
> > +		}
> > +
> > +		iovec.iov_base = p;
> > +		iovec.iov_len = l;
> > +		if (rw == READ) {
> > +			io_uring_prep_readv(sqe, fd, &iovec, 1, o);
> > +		} else {
> > +			io_uring_prep_writev(sqe, fd, &iovec, 1, o);
> > +		}
> > +
> > +		ret = io_uring_submit_and_wait(&ring, 1);
> > +		if (ret != 1) {
> > +			fprintf(stderr, "errcode=%d\n", -ret);
> > +			fprintf(stderr, "uring %s: io_uring_submit failed: %s\n",
> > +					rw == READ ? "read":"write", strerror(-ret));
> > +			goto uring_error;
> > +		}
> > +
> > +		ret = io_uring_wait_cqe(&ring, &cqe);
> > +		if (ret != 0) {
> > +			fprintf(stderr, "errcode=%d\n", -ret);
> > +			fprintf(stderr, "uring %s: io_uring_wait_cqe failed: %s\n",
> > +					rw == READ ? "read":"write", strerror(-ret));
> > +			goto uring_error;
> > +		}
> > +
> > +		res = cqe->res;
> 
> If we assign ret here instead of res, it looks like we could optimize
> away res entirely.

I think you're right, I'll think more about that, then send V5 patches out.
As you've ACKed this patchset, I'll add "Reviewed-by Brian" in V5, many
thanks for your review :)

> 
> Nits and my limited experience with uring aside, the patch otherwise
> LGTM. Are you planning any new tests to take advantage of this,
> particularly since it looks like -A (-U disabled) is the default? In any
> event, a quick test run of fsstress/fsx doesn't seem to explode:

Yes, I'm preparing more patches to use the -U option of fsx. I'll send them
out after this patchset get merged :)

> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> 
> > +		io_uring_cqe_seen(&ring, cqe);
> > +
> > +		if (res > 0) {
> > +			o += res;
> > +			l -= res;
> > +			p += res;
> > +			res2 += res;
> > +		} else if (res < 0) {
> > +			ret = res;
> > +			fprintf(stderr, "errcode=%d\n", -ret);
> > +			fprintf(stderr, "uring %s: io_uring failed: %s\n",
> > +					rw == READ ? "read":"write", strerror(-ret));
> > +			goto uring_error;
> > +		} else {
> > +			fprintf(stderr, "uring %s bad io length: %d instead of %u\n",
> > +					rw == READ ? "read":"write", res2, len);
> > +			break;
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
> > +#else
> > +int
> > +uring_rw(int rw, int fd, char *buf, unsigned len, unsigned offset)
> > +{
> > +	fprintf(stderr, "io_rw: need IO_URING support!\n");
> > +	exit(111);
> > +}
> > +#endif
> > +
> >  int
> >  fsx_rw(int rw, int fd, char *buf, unsigned len, unsigned offset)
> >  {
> > @@ -2436,6 +2550,8 @@ fsx_rw(int rw, int fd, char *buf, unsigned len, unsigned offset)
> >  
> >  	if (aio) {
> >  		ret = aio_rw(rw, fd, buf, len, offset);
> > +	} else if (uring) {
> > +		ret = uring_rw(rw, fd, buf, len, offset);
> >  	} else {
> >  		if (rw == READ)
> >  			ret = read(fd, buf, len);
> > @@ -2498,7 +2614,7 @@ main(int argc, char **argv)
> >  	setvbuf(stdout, (char *)0, _IOLBF, 0); /* line buffered stdout */
> >  
> >  	while ((ch = getopt_long(argc, argv,
> > -				 "b:c:dfg:i:j:kl:m:no:p:qr:s:t:w:xyABD:EFJKHzCILN:OP:RS:WXZ",
> > +				 "b:c:dfg:i:j:kl:m:no:p:qr:s:t:w:xyABD:EFJKHzCILN:OP:RS:UWXZ",
> >  				 longopts, NULL)) != EOF)
> >  		switch (ch) {
> >  		case 'b':
> > @@ -2606,6 +2722,9 @@ main(int argc, char **argv)
> >  		case 'A':
> >  			aio = 1;
> >  			break;
> > +		case 'U':
> > +			uring = 1;
> > +			break;
> >  		case 'D':
> >  			debugstart = getnum(optarg, &endp);
> >  			if (debugstart < 1)
> > @@ -2696,6 +2815,11 @@ main(int argc, char **argv)
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
> > @@ -2786,6 +2910,10 @@ main(int argc, char **argv)
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
> 

