Return-Path: <io-uring+bounces-9057-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 71160B2C023
	for <lists+io-uring@lfdr.de>; Tue, 19 Aug 2025 13:21:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DABD317926F
	for <lists+io-uring@lfdr.de>; Tue, 19 Aug 2025 11:20:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9774E49620;
	Tue, 19 Aug 2025 11:20:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DGyrj3Is"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EF8B79F5
	for <io-uring@vger.kernel.org>; Tue, 19 Aug 2025 11:20:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755602403; cv=none; b=E2euStyeY5RdLxQPn4DON0tq6SzlF565/e0estaDVKSklGR2B36zouFAITk/kCF3mjG6/t9XBeEWwQDJa+Bd4uyqLqAJDocOLDUleXISWsd0ACB/k93nBwJGXCFuTtsdtwrE277UMlMMRxdzPwBi74pu83TgERk0GSMrld6xt0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755602403; c=relaxed/simple;
	bh=RdxST4sdaoTz44z0zGse0mSfFwtoIFoEmKSIbyR+qHQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iIvWo0PTmZN3dG90YNVnkiUmu/SuWo0t9RWAEgJp3ZZK01IXDKoRsdcqr3pkvuWL0MZ3stoMp7Johx6XtkzpgdxPkKTCrESZ2PX998Z+oBX0wH8qdZSgfKQ+/IPY0hWS/IvcW9ZpowfVo++gpX3Lgr+7aBEBRoGh4qh9ZpTgOk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DGyrj3Is; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755602400;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mezweKekVPXMW4AshYHPevDxkcf0lzQs8sl04kkOH/4=;
	b=DGyrj3IsUleB1Jt6gWuFjLhHOPAyM/kIwUaBRrYMIEhLpNcsA7iqCW+zJR8183uBEQopOZ
	pdKXzVt1TY/ukNVMmDAkZt3KWcZhPG16ZphBzqdYttDvW4i0zfeQ3bumAJwAA3PwsoQQ/j
	FmRsWgAWYXwxAagjrHKKB2pHDnM1jOA=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-581-old-BzoyO0ObGcFJK7z1PA-1; Tue,
 19 Aug 2025 07:19:57 -0400
X-MC-Unique: old-BzoyO0ObGcFJK7z1PA-1
X-Mimecast-MFC-AGG-ID: old-BzoyO0ObGcFJK7z1PA_1755602396
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7E21F1800346;
	Tue, 19 Aug 2025 11:19:55 +0000 (UTC)
Received: from fedora (unknown [10.72.116.16])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 70E1730001A8;
	Tue, 19 Aug 2025 11:19:51 +0000 (UTC)
Date: Tue, 19 Aug 2025 19:19:47 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
	Caleb Sander Mateos <csander@purestorage.com>
Subject: Re: [PATCH] io_uring: uring_cmd: add multishot support without poll
Message-ID: <aKRd05_pzVwhPfxI@fedora>
References: <20250810025024.1659190-1-ming.lei@redhat.com>
 <393638fa-566a-4210-9f7e-79061de43bb4@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <393638fa-566a-4210-9f7e-79061de43bb4@kernel.dk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Mon, Aug 18, 2025 at 09:31:35AM -0600, Jens Axboe wrote:
> On 8/9/25 8:50 PM, Ming Lei wrote:
> > Add UAPI flag IORING_URING_CMD_MULTISHOT for supporting naive multishot
> > uring_cmd:
> > 
> > - for notifying userspace to handle event, typical use case is to notify
> > userspace for handle device interrupt event, really generic use case
> > 
> > - needn't device to support poll() because the event may be originated
> > from multiple source in device wide, such as multi queues
> > 
> > - add two APIs, io_uring_cmd_select_buffer() is for getting the provided
> > group buffer, io_uring_mshot_cmd_post_cqe() is for post CQE after event
> > data is pushed to the provided buffer
> > 
> > Follows one ublk use case:
> > 
> > https://github.com/ming1/linux/commits/ublk-devel/
> > 
> > Signed-off-by: Ming Lei <ming.lei@redhat.com>
> > ---
> >  include/linux/io_uring/cmd.h  | 27 +++++++++++++++
> >  include/uapi/linux/io_uring.h |  9 ++++-
> >  io_uring/opdef.c              |  1 +
> >  io_uring/uring_cmd.c          | 64 ++++++++++++++++++++++++++++++++++-
> >  4 files changed, 99 insertions(+), 2 deletions(-)
> > 
> > diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
> > index cfa6d0c0c322..5a72399bfa77 100644
> > --- a/include/linux/io_uring/cmd.h
> > +++ b/include/linux/io_uring/cmd.h
> > @@ -70,6 +70,22 @@ void io_uring_cmd_mark_cancelable(struct io_uring_cmd *cmd,
> >  /* Execute the request from a blocking context */
> >  void io_uring_cmd_issue_blocking(struct io_uring_cmd *ioucmd);
> >  
> > +/*
> > + * Select a buffer from the provided buffer group for multishot uring_cmd.
> > + * Returns the selected buffer address and size.
> > + */
> > +int io_uring_cmd_select_buffer(struct io_uring_cmd *ioucmd,
> > +			       unsigned buf_group,
> > +			       void **buf, size_t *len,
> > +			       unsigned int issue_flags);
> > +
> > +/*
> > + * Complete a multishot uring_cmd event. This will post a CQE to the completion
> > + * queue and update the provided buffer.
> > + */
> > +bool io_uring_mshot_cmd_post_cqe(struct io_uring_cmd *ioucmd,
> > +				 ssize_t ret, unsigned int issue_flags);
> > +
> >  #else
> >  static inline int
> >  io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
> > @@ -102,6 +118,17 @@ static inline void io_uring_cmd_mark_cancelable(struct io_uring_cmd *cmd,
> >  static inline void io_uring_cmd_issue_blocking(struct io_uring_cmd *ioucmd)
> >  {
> >  }
> > +static inline int io_uring_cmd_select_buffer(struct io_uring_cmd *ioucmd,
> > +				unsigned buf_group,
> > +				void **buf, size_t *len,
> > +				unsigned int issue_flags)
> > +{
> > +	return -EOPNOTSUPP;
> > +}
> > +static inline void io_uring_mshot_cmd_post_cqe(struct io_uring_cmd *ioucmd,
> > +				ssize_t ret, unsigned int issue_flags)
> > +{
> > +}
> >  #endif
> >  
> >  /*
> > diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> > index 6957dc539d83..e8afb4f5b56a 100644
> > --- a/include/uapi/linux/io_uring.h
> > +++ b/include/uapi/linux/io_uring.h
> > @@ -297,10 +297,17 @@ enum io_uring_op {
> >  /*
> >   * sqe->uring_cmd_flags		top 8bits aren't available for userspace
> >   * IORING_URING_CMD_FIXED	use registered buffer; pass this flag
> > + *				along with setting sqe->buf_index,
> > + *				IORING_URING_CMD_MULTISHOT can't be set
> > + *				at the same time
> > + * IORING_URING_CMD_MULTISHOT	use buffer select; pass this flag
> >   *				along with setting sqe->buf_index.
> > + *				IORING_URING_CMD_FIXED can't be set
> > + *				at the same time
> 
> This reads very confusingly, as if setting IORING_URING_CMD_MULTISHOT is
> what decides this request selects a buffer. In practice, the rule is
> that you MUST set IOSQE_BUFFER_SELECT, using IORING_URING_CMD_MULTISHOT
> without that is invalid. So I think that just needs a bit of updating.
> Something ala:
> 
> Must be used with buffer select, like other multishot commands. Not
> compatible with IORING_URING_CMD_FIXED, for now.

OK

> 
> > @@ -194,8 +195,20 @@ int io_uring_cmd_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
> >  	if (ioucmd->flags & ~IORING_URING_CMD_MASK)
> >  		return -EINVAL;
> >  
> > -	if (ioucmd->flags & IORING_URING_CMD_FIXED)
> > +	if ((ioucmd->flags & IORING_URING_CMD_FIXED) && (ioucmd->flags &
> > +				IORING_URING_CMD_MULTISHOT))
> > +		return -EINVAL;
> 
> I think the more idiomatic way to write that is:
> 
> 	if ((ioucmd->flags & (IORING_URING_CMD_FIXED|IORING_URING_CMD_MULTISHOT) == (IORING_URING_CMD_FIXED|IORING_URING_CMD_MULTISHOT)
> 
> But since you have the separate checks below, why not do fold that check
> into those instead? Eg in here:
> 
> > +	if (ioucmd->flags & IORING_URING_CMD_FIXED) {
> > +		if (req->flags & REQ_F_BUFFER_SELECT)
> > +			return -EINVAL;
> >  		req->buf_index = READ_ONCE(sqe->buf_index);
> > +	}
> > +
> > +	if (ioucmd->flags & IORING_URING_CMD_MULTISHOT) {
> > +		if (!(req->flags & REQ_F_BUFFER_SELECT))
> > +			return -EINVAL;
> > +	}
> 
> each section can just check the other flag.

OK

> 
> > @@ -251,6 +264,11 @@ int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags)
> >  	}
> >  
> >  	ret = file->f_op->uring_cmd(ioucmd, issue_flags);
> > +	if (ioucmd->flags & IORING_URING_CMD_MULTISHOT) {
> > +		if (ret >= 0)
> > +			return IOU_ISSUE_SKIP_COMPLETE;
> > +		io_kbuf_recycle(req, issue_flags);
> > +	}
> >  	if (ret == -EAGAIN) {
> >  		ioucmd->flags |= IORING_URING_CMD_REISSUE;
> >  		return ret;
> 
> Missing recycle for -EAGAIN?

io_kbuf_recycle() is done above if `ret < 0`

> 
> > @@ -333,3 +351,47 @@ bool io_uring_cmd_post_mshot_cqe32(struct io_uring_cmd *cmd,
> >  		return false;
> >  	return io_req_post_cqe32(req, cqe);
> >  }
> > +
> > +int io_uring_cmd_select_buffer(struct io_uring_cmd *ioucmd,
> > +			       unsigned buf_group,
> > +			       void __user **buf, size_t *len,
> > +			       unsigned int issue_flags)
> > +{
> > +	struct io_kiocb *req = cmd_to_io_kiocb(ioucmd);
> > +	void __user *ubuf;
> > +
> > +	if (!(req->flags & REQ_F_BUFFER_SELECT))
> > +		return -EINVAL;
> > +
> > +	ubuf = io_buffer_select(req, len, buf_group, issue_flags);
> > +	if (!ubuf)
> > +		return -ENOBUFS;
> > +
> > +	*buf = ubuf;
> > +	return 0;
> > +}
> > +EXPORT_SYMBOL_GPL(io_uring_cmd_select_buffer);
> > +
> > +/*
> > + * Return true if this multishot uring_cmd needs to be completed, otherwise
> > + * the event CQE is posted successfully.
> > + *
> > + * Should only be used from a task_work
> > + *
> > + */
> > +bool io_uring_mshot_cmd_post_cqe(struct io_uring_cmd *ioucmd,
> > +				 ssize_t ret, unsigned int issue_flags)
> > +{
> > +	struct io_kiocb *req = cmd_to_io_kiocb(ioucmd);
> > +	unsigned int cflags = 0;
> > +
> > +	if (ret > 0) {
> > +		cflags = io_put_kbuf(req, ret, issue_flags);
> > +		if (io_req_post_cqe(req, ret, cflags | IORING_CQE_F_MORE))
> > +			return false;
> > +	}
> > +
> > +	io_req_set_res(req, ret, cflags);
> > +	return true;
> > +}
> > +EXPORT_SYMBOL_GPL(io_uring_mshot_cmd_post_cqe);
> 
> Missing req_set_fail()?

Will add it.


Thanks, 
Ming


