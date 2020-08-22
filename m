Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73E5024E92D
	for <lists+io-uring@lfdr.de>; Sat, 22 Aug 2020 20:02:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727945AbgHVSCG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 22 Aug 2020 14:02:06 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:33173 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728120AbgHVSCF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 22 Aug 2020 14:02:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598119323;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=W6lgVmh2wlooy/jOjkjYLUIvHE4cxHds3iJ0UWbp83U=;
        b=S823tc4CFNRquckVaci8+YgjtDKB1n5/hutbTvxfimlaYAiuxDZOwjgbjcSv1danDYERx9
        rEMqSd+UGBdVZz2Osd+35bVxzKffBYAj9cOSXN5SfaVIl8/DkWeN9Rb+Z4pd6WMm7qJoU/
        DrDS3hFyZrDWh/NfJUr4uHeUiLOPhUM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-313-EsJCpst0MDqaXtzRlbEOFw-1; Sat, 22 Aug 2020 14:02:00 -0400
X-MC-Unique: EsJCpst0MDqaXtzRlbEOFw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 10FE51876562;
        Sat, 22 Aug 2020 18:01:37 +0000 (UTC)
Received: from localhost (dhcp-12-102.nay.redhat.com [10.66.12.102])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7FD537AEFE;
        Sat, 22 Aug 2020 18:01:35 +0000 (UTC)
Date:   Sun, 23 Aug 2020 02:14:46 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     fstests@vger.kernel.org, io-uring@vger.kernel.org,
        jmoyer@redhat.com
Subject: Re: [PATCH v2 1/4] fsstress: add IO_URING read and write operations
Message-ID: <20200822181445.GS2937@dhcp-12-102.nay.redhat.com>
Mail-Followup-To: Jens Axboe <axboe@kernel.dk>, fstests@vger.kernel.org,
        io-uring@vger.kernel.org, jmoyer@redhat.com
References: <20200809063040.15521-1-zlang@redhat.com>
 <20200809063040.15521-2-zlang@redhat.com>
 <01c7353f-338b-99cd-d7d1-fe92b0badd84@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <01c7353f-338b-99cd-d7d1-fe92b0badd84@kernel.dk>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sun, Aug 09, 2020 at 11:51:45AM -0600, Jens Axboe wrote:
> On 8/9/20 12:30 AM, Zorro Lang wrote:
> > @@ -2170,6 +2189,108 @@ do_aio_rw(int opno, long r, int flags)
> >  }
> >  #endif
> >  
> > +#ifdef URING
> > +void
> > +do_uring_rw(int opno, long r, int flags)
> > +{
> > +	char		*buf;
> > +	int		e;
> > +	pathname_t	f;
> > +	int		fd;
> > +	size_t		len;
> > +	int64_t		lr;
> > +	off64_t		off;
> > +	struct stat64	stb;
> > +	int		v;
> > +	char		st[1024];
> > +	struct io_uring_sqe	*sqe;
> > +	struct io_uring_cqe	*cqe;
> > +	struct iovec	iovec;
> > +	int		iswrite = (flags & (O_WRONLY | O_RDWR)) ? 1 : 0;
> > +
> > +	init_pathname(&f);
> > +	if (!get_fname(FT_REGFILE, r, &f, NULL, NULL, &v)) {
> > +		if (v)
> > +			printf("%d/%d: do_uring_rw - no filename\n", procid, opno);
> > +		goto uring_out3;
> > +	}
> > +	fd = open_path(&f, flags);
> > +	e = fd < 0 ? errno : 0;
> > +	check_cwd();
> > +	if (fd < 0) {
> > +		if (v)
> > +			printf("%d/%d: do_uring_rw - open %s failed %d\n",
> > +			       procid, opno, f.path, e);
> > +		goto uring_out3;
> > +	}
> > +	if (fstat64(fd, &stb) < 0) {
> > +		if (v)
> > +			printf("%d/%d: do_uring_rw - fstat64 %s failed %d\n",
> > +			       procid, opno, f.path, errno);
> > +		goto uring_out2;
> > +	}
> > +	inode_info(st, sizeof(st), &stb, v);
> > +	if (!iswrite && stb.st_size == 0) {
> > +		if (v)
> > +			printf("%d/%d: do_uring_rw - %s%s zero size\n", procid, opno,
> > +			       f.path, st);
> > +		goto uring_out2;
> > +	}
> > +	sqe = io_uring_get_sqe(&ring);
> > +	if (!sqe) {
> > +		if (v)
> > +			printf("%d/%d: do_uring_rw - io_uring_get_sqe failed\n",
> > +			       procid, opno);
> > +		goto uring_out2;
> > +	}
> > +	lr = ((int64_t)random() << 32) + random();
> > +	len = (random() % FILELEN_MAX) + 1;
> > +	buf = malloc(len);
> > +	if (!buf) {
> > +		if (v)
> > +			printf("%d/%d: do_uring_rw - malloc failed\n",
> > +			       procid, opno);
> > +		goto uring_out2;
> > +	}
> > +	iovec.iov_base = buf;
> > +	iovec.iov_len = len;
> > +	if (iswrite) {
> > +		off = (off64_t)(lr % MIN(stb.st_size + (1024 * 1024), MAXFSIZE));
> > +		off %= maxfsize;
> > +		memset(buf, nameseq & 0xff, len);
> > +		io_uring_prep_writev(sqe, fd, &iovec, 1, off);
> > +	} else {
> > +		off = (off64_t)(lr % stb.st_size);
> > +		io_uring_prep_readv(sqe, fd, &iovec, 1, off);
> > +	}
> > +
> > +	if ((e = io_uring_submit(&ring)) != 1) {
> > +		if (v)
> > +			printf("%d/%d: %s - io_uring_submit failed %d\n", procid, opno,
> > +			       iswrite ? "uring_write" : "uring_read", e);
> > +		goto uring_out1;
> > +	}
> > +	if ((e = io_uring_wait_cqe(&ring, &cqe)) < 0) {
> > +		if (v)
> > +			printf("%d/%d: %s - io_uring_wait_cqe failed %d\n", procid, opno,
> > +			       iswrite ? "uring_write" : "uring_read", e);
> > +		goto uring_out1;
> > +	}
> 
> You could use io_uring_submit_and_wait() here, that'll save a system
> call for sync IO. Same comment goes for 4/4.

Hi Jens,

Sorry I think I haven't learned about io_uring enough, why the
io_uring_submit_and_wait can save a system call? Is it same with
io_uring_submit(), except a wait_nr ? The io_uring_wait_cqe() and
io_uring_cqe_seen() are still needed, right?

Thanks,
Zorro

> 
> Apart from that, looks pretty straight forward to me.
> 
> -- 
> Jens Axboe
> 

