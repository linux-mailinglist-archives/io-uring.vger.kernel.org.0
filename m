Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F0E969325A
	for <lists+io-uring@lfdr.de>; Sat, 11 Feb 2023 17:14:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbjBKQOI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 11 Feb 2023 11:14:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229754AbjBKQOH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 11 Feb 2023 11:14:07 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5AF114229
        for <io-uring@vger.kernel.org>; Sat, 11 Feb 2023 08:13:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676131998;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=n2+4p6tuOdfdL0+JUikQKtK4MBR6Zsz8tsVUNpkaHfE=;
        b=GPI4+EzQKE5PkYVfItQ7MbweDGFsjZg227pHAnLU0ARKHllT/a//EkVkMAFpSFh3g+9h+r
        ivYkDPgSTpPYgQMb9l6TnjYMZTIr1YtGtVcT5S9ZkwQ8C3fHZ9ApAmfSIrp30upmmElpoK
        s8qqp5PRZRrVvYSGMbzcscoYL/qScOA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-338-5oYo3BdmOjO89oM-8FfxNQ-1; Sat, 11 Feb 2023 11:13:12 -0500
X-MC-Unique: 5oYo3BdmOjO89oM-8FfxNQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EA3F429A9D48;
        Sat, 11 Feb 2023 16:13:11 +0000 (UTC)
Received: from T590 (ovpn-8-18.pek2.redhat.com [10.72.8.18])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EBB1A2166B26;
        Sat, 11 Feb 2023 16:13:04 +0000 (UTC)
Date:   Sun, 12 Feb 2023 00:12:59 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Bernd Schubert <bschubert@ddn.com>,
        Nitesh Shetty <nj.shetty@samsung.com>,
        Christoph Hellwig <hch@lst.de>,
        Ziyang Zhang <ZiyangZhang@linux.alibaba.com>,
        ming.lei@redhat.com
Subject: Re: [PATCH 3/4] io_uring: add IORING_OP_READ[WRITE]_SPLICE_BUF
Message-ID: <Y+e+i5BXQHcqdDGo@T590>
References: <20230210153212.733006-1-ming.lei@redhat.com>
 <20230210153212.733006-4-ming.lei@redhat.com>
 <a487261c-cc0e-134b-cd8e-26460fe7cf59@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a487261c-cc0e-134b-cd8e-26460fe7cf59@kernel.dk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sat, Feb 11, 2023 at 08:45:18AM -0700, Jens Axboe wrote:
> On 2/10/23 8:32?AM, Ming Lei wrote:
> > IORING_OP_READ_SPLICE_BUF: read to buffer which is built from
> > ->read_splice() of specified fd, so user needs to provide (splice_fd, offset, len)
> > for building buffer.
> > 
> > IORING_OP_WRITE_SPLICE_BUF: write from buffer which is built from
> > ->read_splice() of specified fd, so user needs to provide (splice_fd, offset, len)
> > for building buffer.
> > 
> > The typical use case is for supporting ublk/fuse io_uring zero copy,
> > and READ/WRITE OP retrieves ublk/fuse request buffer via direct pipe
> > from device->read_splice(), then READ/WRITE can be done to/from this
> > buffer directly.
> 
> Main question here - would this be better not plumbed up through the rw
> path? Might be cleaner, even if it either requires a bit of helper
> refactoring or accepting a bit of duplication. But would still be better
> than polluting the rw fast path imho.

The buffer is actually IO buffer, which has to be plumbed up in IO path,
and it can't be done like the registered buffer.

The only affect on fast path is :

		if (io_rw_splice_buf(req))	//which just check opcode
              return io_prep_rw_splice_buf(req, sqe);

and the cleanup code which is only done for the two new OPs.

Or maybe I misunderstand your point? Or any detailed suggestion?

Actually the code should be factored into generic helper, since net.c
need to use them too. Probably it needs to move to rsrc.c?

> 
> Also seems like this should be separately testable. We can't add new
> opcodes that don't have a feature test at least, and should also have
> various corner case tests. A bit of commenting outside of this below.

OK, I will write/add one very simple ublk userspace to liburing for
test purpose.

> 
> > diff --git a/io_uring/opdef.c b/io_uring/opdef.c
> > index 5238ecd7af6a..91e8d8f96134 100644
> > --- a/io_uring/opdef.c
> > +++ b/io_uring/opdef.c
> > @@ -427,6 +427,31 @@ const struct io_issue_def io_issue_defs[] = {
> >  		.prep			= io_eopnotsupp_prep,
> >  #endif
> >  	},
> > +	[IORING_OP_READ_SPLICE_BUF] = {
> > +		.needs_file		= 1,
> > +		.unbound_nonreg_file	= 1,
> > +		.pollin			= 1,
> > +		.plug			= 1,
> > +		.audit_skip		= 1,
> > +		.ioprio			= 1,
> > +		.iopoll			= 1,
> > +		.iopoll_queue		= 1,
> > +		.prep			= io_prep_rw,
> > +		.issue			= io_read,
> > +	},
> > +	[IORING_OP_WRITE_SPLICE_BUF] = {
> > +		.needs_file		= 1,
> > +		.hash_reg_file		= 1,
> > +		.unbound_nonreg_file	= 1,
> > +		.pollout		= 1,
> > +		.plug			= 1,
> > +		.audit_skip		= 1,
> > +		.ioprio			= 1,
> > +		.iopoll			= 1,
> > +		.iopoll_queue		= 1,
> > +		.prep			= io_prep_rw,
> > +		.issue			= io_write,
> > +	},
> 
> Are these really safe with iopoll?

Yeah, after the buffer is built, the handling is basically
same with IORING_OP_WRITE_FIXED, so I think it is safe.

> 
> > +static int io_prep_rw_splice_buf(struct io_kiocb *req,
> > +				 const struct io_uring_sqe *sqe)
> > +{
> > +	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
> > +	unsigned nr_pages = io_rw_splice_buf_nr_bvecs(rw->len);
> > +	loff_t splice_off = READ_ONCE(sqe->splice_off_in);
> > +	struct io_rw_splice_buf_data data;
> > +	struct io_mapped_ubuf *imu;
> > +	struct fd splice_fd;
> > +	int ret;
> > +
> > +	splice_fd = fdget(READ_ONCE(sqe->splice_fd_in));
> > +	if (!splice_fd.file)
> > +		return -EBADF;
> 
> Seems like this should check for SPLICE_F_FD_IN_FIXED, and also use
> io_file_get_normal() for the non-fixed case in case someone passed in an
> io_uring fd.

SPLICE_F_FD_IN_FIXED needs one extra word for holding splice flags, if
we can use sqe->addr3, I think it is doable.

> 
> > +	data.imu = &imu;
> > +
> > +	rw->addr = 0;
> > +	req->flags |= REQ_F_NEED_CLEANUP;
> > +
> > +	ret = __io_prep_rw_splice_buf(req, &data, splice_fd.file, rw->len,
> > +			splice_off);
> > +	imu = *data.imu;
> > +	imu->acct_pages = 0;
> > +	imu->ubuf = 0;
> > +	imu->ubuf_end = data.total;
> > +	rw->len = data.total;
> > +	req->imu = imu;
> > +	if (!data.total) {
> > +		io_rw_cleanup_splice_buf(req);
> > +	} else  {
> > +		ret = 0;
> > +	}
> > +out_put_fd:
> > +	if (splice_fd.file)
> > +		fdput(splice_fd);
> > +
> > +	return ret;
> > +}
> 
> If the operation is done, clear NEED_CLEANUP and do the cleanup here?
> That'll be faster.

The buffer has to be cleaned up after req is completed, since bvec
table is needed for bio, and page reference need to be dropped after
IO is done too.


thanks,
Ming

