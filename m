Return-Path: <io-uring+bounces-2358-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2212A9189F3
	for <lists+io-uring@lfdr.de>; Wed, 26 Jun 2024 19:17:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CB4CB2854A4
	for <lists+io-uring@lfdr.de>; Wed, 26 Jun 2024 17:17:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5232C18FDC8;
	Wed, 26 Jun 2024 17:17:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="ii9pCUro";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="/HBLR4wi";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="hHuqArdz";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="ue0EyvPp"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59350190047;
	Wed, 26 Jun 2024 17:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719422258; cv=none; b=JtfH6J8VXJUBntTie4hn5EprfRKAUddqQA0o07Eob0csZgdDZS+qR4VdqaED32iTaWPv34Z7trtN7doXud9TyP8hZHOrW/6jzjxtlZ+bMeNLck8TNdJTy78ga9nPvSZVgwkmzKPJjvLYQQUYkZvpJZLWq0T4v9DqmLaBK271LI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719422258; c=relaxed/simple;
	bh=GpeZhrulOlXBfGexVpGjpazhJnwi7OM07pnieAgX1Sw=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=pAcDEOeIobNfcg1q5M+iC9A+JAZjNcRCyVy+CJHYSWw+r7+Fw4a4DVFLLoTUAPt55LeTXlLAeyvMIeqvYobjL0bnMZk2n7uX0L6Wxqi04LhnJpPeDck1g5XP5fQOz95GA1YpsFTcRJVn+xva2ZzJHzPplNOjfBUUw9NOPPqEnso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=ii9pCUro; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=/HBLR4wi; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=hHuqArdz; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=ue0EyvPp; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A11591FB6E;
	Wed, 26 Jun 2024 17:17:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1719422251; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NcQeDRhLMlH4Z7xqdQnN7buLz2LWXR3v3A1y122z5XA=;
	b=ii9pCUrowURihyt6Ysfsc7oquo//MHDhsg5yKlc+RN04UB6T/pFx3gvSqwe7WliAbdm12I
	JRdf8mOzRDZraZj7ojcNbc+Vb99Gn+Ox8pzkheM+oEKpSIKcSWFKQJ3cUgDzWnmU7nBuE5
	gp6mx+4thmlZdhkVI3thm0lFHbB9sA0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1719422251;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NcQeDRhLMlH4Z7xqdQnN7buLz2LWXR3v3A1y122z5XA=;
	b=/HBLR4wioAoy8UJsW2fc5BPsaNRtC5u1vUD8SNY36OPqKghid4LCj9htqkJz0mHgd8lxT2
	Q0+0u78ZyEvO8MBw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1719422249; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NcQeDRhLMlH4Z7xqdQnN7buLz2LWXR3v3A1y122z5XA=;
	b=hHuqArdzT+WLgVXnSCFHa2GL+j7nmbbpGhnHesWla7PrXhIKoaDS98Xn1xONRtC3UIifNF
	be3hGVlNduGQmjthrXdK7o95Uk8WfdDBJF3Lk96wceRCHnp4O9V7hmvjqPOiI+R+W/xaba
	Ztap4CeP09kU+qCjT5xOXH3V1jXxOUg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1719422249;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NcQeDRhLMlH4Z7xqdQnN7buLz2LWXR3v3A1y122z5XA=;
	b=ue0EyvPp+5AueWmylmFT+01yYgfjVYd9PJzoPgzXE1d3Sn9113ztvzKN2UWxifWEMpdgqN
	5vXcrQyYD1B2ZjDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5DE81139C2;
	Wed, 26 Jun 2024 17:17:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id w9XAEClNfGakDAAAD6G6ig
	(envelope-from <krisman@suse.de>); Wed, 26 Jun 2024 17:17:29 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: Anuj Gupta <anuj20.g@samsung.com>
Cc: asml.silence@gmail.com,  mpatocka@redhat.com,  axboe@kernel.dk,
  hch@lst.de,  kbusch@kernel.org,  martin.petersen@oracle.com,
  io-uring@vger.kernel.org,  linux-nvme@lists.infradead.org,
  linux-block@vger.kernel.org,  Kanchan Joshi <joshi.k@samsung.com>
Subject: Re: [PATCH v2 08/10] io_uring/rw: add support to send meta along
 with read/write
In-Reply-To: <20240626100700.3629-9-anuj20.g@samsung.com> (Anuj Gupta's
	message of "Wed, 26 Jun 2024 15:36:58 +0530")
References: <20240626100700.3629-1-anuj20.g@samsung.com>
	<CGME20240626101525epcas5p4dbcef84714e4e9214b951fe2ff649521@epcas5p4.samsung.com>
	<20240626100700.3629-9-anuj20.g@samsung.com>
Date: Wed, 26 Jun 2024 13:17:28 -0400
Message-ID: <87y16rmxnb.fsf@mailhost.krisman.be>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Score: -2.80
X-Spam-Level: 
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TAGGED_RCPT(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[11];
	ARC_NA(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,redhat.com,kernel.dk,lst.de,kernel.org,oracle.com,vger.kernel.org,lists.infradead.org,samsung.com];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,samsung.com:email]

Anuj Gupta <anuj20.g@samsung.com> writes:

> This patch adds the capability of sending meta along with read/write.
> This meta is represented by a newly introduced 'struct io_uring_meta'
> which specifies information such as meta type/flags/buffer/length and
> apptag.
> Application sets up a SQE128 ring, prepares io_uring_meta within the SQE
> at offset pointed by sqe->cmd.
> The patch processes the user-passed information to prepare uio_meta
> descriptor and passes it down using kiocb->private.
>
> Meta exchange is supported only for direct IO.
> Also vectored read/write operations with meta are not supported
> currently.
>
> Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
> Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
> ---
>  include/linux/fs.h            |  1 +
>  include/uapi/linux/io_uring.h | 30 +++++++++++++++-
>  io_uring/io_uring.c           |  7 ++++
>  io_uring/rw.c                 | 68 +++++++++++++++++++++++++++++++++--
>  io_uring/rw.h                 |  9 ++++-
>  5 files changed, 110 insertions(+), 5 deletions(-)
>
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index db26b4a70c62..0132565288c2 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -330,6 +330,7 @@ struct readahead_control;
>  #define IOCB_NOIO		(1 << 20)
>  /* can use bio alloc cache */
>  #define IOCB_ALLOC_CACHE	(1 << 21)
> +#define IOCB_HAS_META		(1 << 22)
>  /*
>   * IOCB_DIO_CALLER_COMP can be set by the iocb owner, to indicate that the
>   * iocb completion can be passed back to the owner for execution from a safe
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> index 2aaf7ee256ac..9140c66b315b 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -101,12 +101,40 @@ struct io_uring_sqe {
>  		__u64	optval;
>  		/*
>  		 * If the ring is initialized with IORING_SETUP_SQE128, then
> -		 * this field is used for 80 bytes of arbitrary command data
> +		 * this field is starting offset for 80 bytes of data.
> +		 * This data is opaque for uring command op. And for meta io,
> +		 * this contains 'struct io_uring_meta'.
>  		 */
>  		__u8	cmd[0];
>  	};
>  };
>  
> +enum io_uring_sqe_meta_type_bits {
> +	META_TYPE_INTEGRITY_BIT,
> +	/* not a real meta type; just to make sure that we don't overflow */
> +	META_TYPE_LAST_BIT,
> +};
> +
> +/* meta type flags */
> +#define META_TYPE_INTEGRITY	(1U << META_TYPE_INTEGRITY_BIT)
> +
> +struct io_uring_meta {
> +	__u16	meta_type;
> +	__u16	meta_flags;
> +	__u32	meta_len;
> +	__u64	meta_addr;
> +	/* the next 64 bytes goes to SQE128 */
> +	__u16	apptag;
> +	__u8	pad[62];
> +};
> +
> +/*
> + * flags for integrity meta
> + */
> +#define INTEGRITY_CHK_GUARD	(1U << 0)	/* enforce guard check */
> +#define INTEGRITY_CHK_APPTAG	(1U << 1)	/* enforce app tag check */
> +#define INTEGRITY_CHK_REFTAG	(1U << 2)	/* enforce ref tag check */
> +
>  /*
>   * If sqe->file_index is set to this for opcodes that instantiate a new
>   * direct descriptor (like openat/openat2/accept), then io_uring will allocate
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index 7ed1e009aaec..0d26ee1193ca 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -3704,6 +3704,13 @@ static int __init io_uring_init(void)
>  	/* top 8bits are for internal use */
>  	BUILD_BUG_ON((IORING_URING_CMD_MASK & 0xff000000) != 0);
>  
> +	BUILD_BUG_ON(sizeof(struct io_uring_meta) >
> +		     2 * sizeof(struct io_uring_sqe) -
> +		     offsetof(struct io_uring_sqe, cmd));
> +
> +	BUILD_BUG_ON(META_TYPE_LAST_BIT >
> +		     8 * sizeof_field(struct io_uring_meta, meta_type));
> +
>  	io_uring_optable_init();
>  
>  	/*
> diff --git a/io_uring/rw.c b/io_uring/rw.c
> index c004d21e2f12..e8f5b5af4d2f 100644
> --- a/io_uring/rw.c
> +++ b/io_uring/rw.c
> @@ -23,6 +23,8 @@
>  #include "poll.h"
>  #include "rw.h"
>  
> +#define	INTEGRITY_VALID_FLAGS (INTEGRITY_CHK_GUARD | INTEGRITY_CHK_APPTAG | \
> +			       INTEGRITY_CHK_REFTAG)
>  struct io_rw {
>  	/* NOTE: kiocb has the file as the first member, so don't do it here */
>  	struct kiocb			kiocb;
> @@ -247,6 +249,42 @@ static int io_prep_rw_setup(struct io_kiocb *req, int ddir, bool do_import)
>  	return 0;
>  }
>  
> +static int io_prep_rw_meta(struct io_kiocb *req, const struct io_uring_sqe *sqe,
> +			   struct io_rw *rw, int ddir)
> +{
> +	const struct io_uring_meta *md = (struct io_uring_meta *)sqe->cmd;
> +	u16 meta_type = READ_ONCE(md->meta_type);
> +	const struct io_issue_def *def;
> +	struct io_async_rw *io;
> +	int ret;
> +
> +	if (!meta_type)
> +		return 0;
> +	if (!(meta_type & META_TYPE_INTEGRITY))
> +		return -EINVAL;
> +
> +	/* should fit into two bytes */
> +	BUILD_BUG_ON(INTEGRITY_VALID_FLAGS >= (1 << 16));
> +
> +	def = &io_issue_defs[req->opcode];
> +	if (def->vectored)
> +		return -EOPNOTSUPP;
> +
> +	io = req->async_data;
> +	io->meta.flags = READ_ONCE(md->meta_flags);
> +	if (io->meta.flags & ~INTEGRITY_VALID_FLAGS)
> +		return -EINVAL;
> +
> +	io->meta.apptag = READ_ONCE(md->apptag);
> +	ret = import_ubuf(ddir, u64_to_user_ptr(READ_ONCE(md->meta_addr)),
> +			  READ_ONCE(md->meta_len), &io->meta.iter);
> +	if (unlikely(ret < 0))
> +		return ret;
> +	rw->kiocb.ki_flags |= IOCB_HAS_META;
> +	iov_iter_save_state(&io->meta.iter, &io->iter_meta_state);
> +	return ret;
> +}
> +
>  static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe,
>  		      int ddir, bool do_import)
>  {
> @@ -269,11 +307,16 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe,
>  		rw->kiocb.ki_ioprio = get_current_ioprio();
>  	}
>  	rw->kiocb.dio_complete = NULL;
> +	rw->kiocb.ki_flags = 0;
>  
>  	rw->addr = READ_ONCE(sqe->addr);
>  	rw->len = READ_ONCE(sqe->len);
>  	rw->flags = READ_ONCE(sqe->rw_flags);
> -	return io_prep_rw_setup(req, ddir, do_import);
> +	ret = io_prep_rw_setup(req, ddir, do_import);
> +
> +	if (unlikely(req->ctx->flags & IORING_SETUP_SQE128 && !ret))
> +		ret = io_prep_rw_meta(req, sqe, rw, ddir);
> +	return ret;

Would it be useful to have a flag to differentiate a malformed SQE from
a SQE with io_uring_meta, instead of assuming sqe->cmd has it? We don't
check for addr3 at the moment and differently from uring_cmd, userspace
will be mixing writes commands with and without metadata to different
files, so it would be useful to catch that.

Also, just styling, but can you turn that !ret into a separate if leg?
We are bound to add more code here eventually, and the next patch to
touch it will end up doing it anyway. I mean:

ret = io_prep_rw_setup(req, ddir, do_import);
if (unlikely(ret))
	return ret;
if (unlikely(req->ctx->flags & IORING_SETUP_SQE128))
	ret = io_prep_rw_meta(req, sqe, rw, ddir);
return ret;

-- 
Gabriel Krisman Bertazi

