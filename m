Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 615B3221683
	for <lists+io-uring@lfdr.de>; Wed, 15 Jul 2020 22:46:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726798AbgGOUqU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Jul 2020 16:46:20 -0400
Received: from relay9-d.mail.gandi.net ([217.70.183.199]:54567 "EHLO
        relay9-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726370AbgGOUqU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Jul 2020 16:46:20 -0400
X-Originating-IP: 50.39.163.217
Received: from localhost (50-39-163-217.bvtn.or.frontiernet.net [50.39.163.217])
        (Authenticated sender: josh@joshtriplett.org)
        by relay9-d.mail.gandi.net (Postfix) with ESMTPSA id 1D7D0FF80F;
        Wed, 15 Jul 2020 20:46:15 +0000 (UTC)
Date:   Wed, 15 Jul 2020 13:46:14 -0700
From:   Josh Triplett <josh@joshtriplett.org>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: Re: [WIP PATCH] io_uring: Support opening a file into the fixed-file
 table
Message-ID: <20200715204614.GB350138@localhost>
References: <5e04f8fc6b0a2e218ace517bc9acf0d44530c430.1594759879.git.josh@joshtriplett.org>
 <3fa35c6e-58df-09c5-3b7b-ded4f57356e8@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3fa35c6e-58df-09c5-3b7b-ded4f57356e8@gmail.com>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Jul 15, 2020 at 10:54:21PM +0300, Pavel Begunkov wrote:
> On 15/07/2020 00:08, Josh Triplett wrote:
> > +static int io_openat2_fixed_file(struct io_kiocb *req, bool force_nonblock)
> > +{
> 
> How about having it in io_openat2()? There are almost identical, that would be
> just a couple of if's.

It's a little more complex than that. It would require making three
pieces of io_openat2 conditional, and the control flow would be
intertwined with whether the file descriptor (from get_unused_fd_flags)
has been initialized. It's absolutely *doable*, but the resulting
complexity didn't seem worth it.

> > +	struct io_open *open = &req->open;
> > +	struct open_flags op;
> > +	struct file *file;
> > +	int ret;
> > +
> > +	if (force_nonblock) {
> > +		/* only need file table for an actual valid fd */
> > +		if (open->dfd == -1 || open->dfd == AT_FDCWD)
> > +			req->flags |= REQ_F_NO_FILE_TABLE;
> > +		return -EAGAIN;
> > +	}
> > +
> > +	ret = build_open_flags(&open->how, &op);
> > +	if (ret)
> > +		goto err;
> > +
> > +	file = do_filp_open(open->dfd, open->filename, &op);
> > +	if (IS_ERR(file)) {
> > +		ret = PTR_ERR(file);
> > +	} else {
> > +		fsnotify_open(file);
> > +		ret = io_sqe_files_add_new(req->ctx, open->open_fixed_idx, file);
> > +		if (ret)
> > +			fput(file);
> > +	}
> > +err:
> > +	putname(open->filename);
> > +	req->flags &= ~REQ_F_NEED_CLEANUP;
> > +	if (ret < 0)
> > +		req_set_fail_links(req);
> > +	io_cqring_add_event(req, ret);
> > +	io_put_req(req);
> 
> These 2 lines are better to be replace with (since 5.9):
> 
> io_req_complete(req, ret);

This was directly copied from the same code in io_openat2.

> > +	return 0;
> > +}
> > +
> >  static int io_openat2(struct io_kiocb *req, bool force_nonblock)
> >  {
> >  	struct open_flags op;
> > @@ -5048,6 +5094,7 @@ static int io_req_defer_prep(struct io_kiocb *req,
> >  		ret = io_madvise_prep(req, sqe);
> >  		break;
> >  	case IORING_OP_OPENAT2:
> > +	case IORING_OP_OPENAT2_FIXED_FILE:
> >  		ret = io_openat2_prep(req, sqe);
> >  		break;
> >  	case IORING_OP_EPOLL_CTL:
> > @@ -5135,6 +5182,7 @@ static void io_cleanup_req(struct io_kiocb *req)
> >  		break;
> >  	case IORING_OP_OPENAT:
> >  	case IORING_OP_OPENAT2:
> > +	case IORING_OP_OPENAT2_FIXED_FILE:
> 
> These OPENAT cases weren't doing anything, so were killed,
> as should be this line.

Makes sense.

> >  		break;
> >  	case IORING_OP_SPLICE:
> >  	case IORING_OP_TEE:
> > @@ -5329,12 +5377,17 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
> >  		ret = io_madvise(req, force_nonblock);
> >  		break;
> >  	case IORING_OP_OPENAT2:
> > +	case IORING_OP_OPENAT2_FIXED_FILE:
> >  		if (sqe) {
> >  			ret = io_openat2_prep(req, sqe);
> >  			if (ret)
> >  				break;
> >  		}
> > -		ret = io_openat2(req, force_nonblock);
> > +		if (req->opcode == IORING_OP_OPENAT2) {
> > +			ret = io_openat2(req, force_nonblock);
> > +		} else {
> > +			ret = io_openat2_fixed_file(req, force_nonblock);
> > +		}
> 
> We don't need all these brackets for one liners

Habit; most codebases I work on *always* include the braces.

> > --- a/include/uapi/linux/io_uring.h
> > +++ b/include/uapi/linux/io_uring.h
> > @@ -54,7 +54,10 @@ struct io_uring_sqe {
> >  			} __attribute__((packed));
> >  			/* personality to use, if used */
> >  			__u16	personality;
> > -			__s32	splice_fd_in;
> > +			union {
> > +				__s32	splice_fd_in;
> > +				__s32	open_fixed_idx;
> > +			};
> >  		};
> >  		__u64	__pad2[3];
> >  	};
> > @@ -130,6 +133,7 @@ enum {
> >  	IORING_OP_PROVIDE_BUFFERS,
> >  	IORING_OP_REMOVE_BUFFERS,
> >  	IORING_OP_TEE,
> > +	IORING_OP_OPENAT2_FIXED_FILE,
> 
> I think, it's better to reuse IORING_OP_OPENAT2.
> E.g. fixed version if "open_fixed_idx != 0" or something similar.

As far as I can tell, nothing in today's handling of IORING_OP_OPENAT2
will give an EINVAL for splice_fd_in!=0. It might be possible to arrange
for it to be the same op via a new flag or something else that the
current IORING_OP_OPENAT2 wil reject (and if it's a flag or similar, all
other operations that don't involve opening a file would also need to
reject it).
