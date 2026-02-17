Return-Path: <io-uring+bounces-12293-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OBkdADpvlGk0DwIAu9opvQ
	(envelope-from <io-uring+bounces-12293-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 17 Feb 2026 14:38:02 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D30514CAC4
	for <lists+io-uring@lfdr.de>; Tue, 17 Feb 2026 14:38:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 567123002D71
	for <lists+io-uring@lfdr.de>; Tue, 17 Feb 2026 13:38:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8D2733858F;
	Tue, 17 Feb 2026 13:37:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YIRXLJ8a"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86AC335893;
	Tue, 17 Feb 2026 13:37:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771335479; cv=none; b=AvJvPlkt9AT8ZH8LEXRQgBRKhxXGdC42Dqn+YTF0RoIIoHDNSDyxPXGknp/KYsnt9sk/hsAGmE0zq1y44q38loEkXHqqMuOZOSdcReoF1vdGUqDmeb9BdUhsFgzv/zROsoM/QUDFsndqwnNyF5U/aXHa/va7TgyEhM/G35F04kM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771335479; c=relaxed/simple;
	bh=wcR4qGrHwZOyvoCtwBO9htdeycxsmLc+iKmsIqP+p+g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SwTqx6uC57+exb4veeXP3n0IQKa2ncl/ukgzFbPwsGgC3KjJEprIltwvuiSPKgMaqQyk0e4JPHU4bAGBOOVr8zY5bMYMus67rwvHTwU7DSCx/8xe3seegKdnuqEosUZHfI1V7PZT/3xLPskb2ntUdv0WYM7kx+dcc7qiMky2Ebg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YIRXLJ8a; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFC0BC4CEF7;
	Tue, 17 Feb 2026 13:37:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771335479;
	bh=wcR4qGrHwZOyvoCtwBO9htdeycxsmLc+iKmsIqP+p+g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YIRXLJ8a02qOy8qD4apy6w0fEQemk0beIqHM00xcUG8P+Um7fWeQiaLXIAXb9KWHk
	 WGzaslygRh2tjCuoXb30H8MFhRIDkOhF08fIbNfxrJqp0OS8cNWxjK0ooxfLrhJzv2
	 jCDR65X3DZGM6Jo1tl6k1vKdHiyw3waSWduHyQjMEhhRg8vVXG0/lokx9EhNxV9KGm
	 4gsmPzLJOsMiWRwLQL1DcvlxsK6hlCf9bt8lyVhi464bjSS3UDEQLB/vEPl5+2t6eq
	 5jI1EJfiE71T4zfH1QbOcn8GAYVMg2wD5tFliS/uhjvhtVGFhkrP/n1IXJ/x622gDD
	 IfEvXUg1JoinA==
Date: Tue, 17 Feb 2026 14:37:55 +0100
From: Christian Brauner <brauner@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] io_uring/bpf_filter: pass in expected filter payload
 size
Message-ID: <20260217-gesandt-mitangeklagt-eba91f5667be@brauner>
References: <20260211150626.136826-1-axboe@kernel.dk>
 <20260211150626.136826-3-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260211150626.136826-3-axboe@kernel.dk>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [2.34 / 15.00];
	MID_END_EQ_FROM_USER_PART(4.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12293-lists,io-uring=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[brauner@kernel.org,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_RCPT(0.00)[io-uring];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 6D30514CAC4
X-Rspamd-Action: no action

On Wed, Feb 11, 2026 at 08:01:18AM -0700, Jens Axboe wrote:
> It's quite possible that opcodes that have payloads attached to them,
> like IORING_OP_OPENAT/OPENAT2 or IORING_OP_SOCKET, that these paylods
> can change over time. For example, on the openat/openat2 side, the
> struct open_how argument is extensible, and could be extended in the
> future to allow further arguments to be passed in.
> 
> Allow registration of a cBPF filter to give the size of the filter as
> seen by userspace. If that filter is for an opcode that takes extra
> payload data, allow it if the application payload expectation is the
> same size than the kernels. If that is the case, the kernel supports
> filtering on the payload that the application expects. If the size
> differs, the behavior depends on the IO_URING_BPF_FILTER_SZ_STRICT flag:
> 
> 1) If IO_URING_BPF_FILTER_SZ_STRICT is set and the size expectation
>    differs, fail the attempt to load the filter.
> 
> 2) If IO_URING_BPF_FILTER_SZ_STRICT isn't set, allow the filter if
>    the userspace pdu size is smaller than what the kernel offers.
> 
> 3) Regardless if IO_URING_BPF_FILTER_SZ_STRICT, fail loading the filter
>    if the userspace pdu size is bigger than what the kernel supports.
> 
> An attempt to load a filter due to sizing will error with -EMSGSIZE.
> For that error, the registration struct will have filter->pdu_size
> populated with the pdu size that the kernel uses.
> 
> Reported-by: Christian Brauner <brauner@kernel.org>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>  include/uapi/linux/io_uring/bpf_filter.h |  8 ++-
>  io_uring/bpf_filter.c                    | 65 ++++++++++++++++++------
>  2 files changed, 56 insertions(+), 17 deletions(-)
> 
> diff --git a/include/uapi/linux/io_uring/bpf_filter.h b/include/uapi/linux/io_uring/bpf_filter.h
> index 220351b81bc0..1b461d792a7b 100644
> --- a/include/uapi/linux/io_uring/bpf_filter.h
> +++ b/include/uapi/linux/io_uring/bpf_filter.h
> @@ -35,13 +35,19 @@ enum {
>  	 * If set, any currently unset opcode will have a deny filter attached
>  	 */
>  	IO_URING_BPF_FILTER_DENY_REST	= 1,
> +	/*
> +	 * If set, if kernel and application don't agree on pdu_size for
> +	 * the given opcode, fail the registration of the filter.
> +	 */
> +	IO_URING_BPF_FILTER_SZ_STRICT	= 2,
>  };
>  
>  struct io_uring_bpf_filter {
>  	__u32	opcode;		/* io_uring opcode to filter */
>  	__u32	flags;
>  	__u32	filter_len;	/* number of BPF instructions */
> -	__u32	resv;
> +	__u8	pdu_size;	/* expected pdu size for opcode */
> +	__u8	resv[3];
>  	__u64	filter_ptr;	/* pointer to BPF filter */
>  	__u64	resv2[5];
>  };

You want this fixed-size?
You could use copy_struct_from_user() and copy_struct_to_user() and then
you can grow the struct on-demand without having to reserve space aka
the struct clone_args and struct mount_attr etc. model.

> diff --git a/io_uring/bpf_filter.c b/io_uring/bpf_filter.c
> index 8ac7d06de122..4e1dd955c8c4 100644
> --- a/io_uring/bpf_filter.c
> +++ b/io_uring/bpf_filter.c
> @@ -308,36 +308,69 @@ static struct io_bpf_filters *io_bpf_filter_cow(struct io_restriction *src)
>  	return ERR_PTR(-EBUSY);
>  }
>  
> -#define IO_URING_BPF_FILTER_FLAGS	IO_URING_BPF_FILTER_DENY_REST
> +#define IO_URING_BPF_FILTER_FLAGS	(IO_URING_BPF_FILTER_DENY_REST | \
> +					 IO_URING_BPF_FILTER_SZ_STRICT)
>  
> -int io_register_bpf_filter(struct io_restriction *res,
> -			   struct io_uring_bpf __user *arg)
> +static int io_bpf_filter_import(struct io_uring_bpf *reg,
> +				struct io_uring_bpf __user *arg)
>  {
> -	struct io_bpf_filters *filters, *old_filters = NULL;
> -	struct io_bpf_filter *filter, *old_filter;
> -	struct io_uring_bpf reg;
> -	struct bpf_prog *prog;
> -	struct sock_fprog fprog;
> +	const struct io_issue_def *def;
>  	int ret;
>  
> -	if (copy_from_user(&reg, arg, sizeof(reg)))
> +	if (copy_from_user(reg, arg, sizeof(*reg)))
>  		return -EFAULT;
> -	if (reg.cmd_type != IO_URING_BPF_CMD_FILTER)
> +	if (reg->cmd_type != IO_URING_BPF_CMD_FILTER)
>  		return -EINVAL;
> -	if (reg.cmd_flags || reg.resv)
> +	if (reg->cmd_flags || reg->resv)
>  		return -EINVAL;
>  
> -	if (reg.filter.opcode >= IORING_OP_LAST)
> +	if (reg->filter.opcode >= IORING_OP_LAST)
>  		return -EINVAL;
> -	if (reg.filter.flags & ~IO_URING_BPF_FILTER_FLAGS)
> +	if (reg->filter.flags & ~IO_URING_BPF_FILTER_FLAGS)
>  		return -EINVAL;
> -	if (reg.filter.resv)
> +	if (!mem_is_zero(reg->filter.resv, sizeof(reg->filter.resv)))
>  		return -EINVAL;
> -	if (!mem_is_zero(reg.filter.resv2, sizeof(reg.filter.resv2)))
> +	if (!mem_is_zero(reg->filter.resv2, sizeof(reg->filter.resv2)))
>  		return -EINVAL;
> -	if (!reg.filter.filter_len || reg.filter.filter_len > BPF_MAXINSNS)
> +	if (!reg->filter.filter_len || reg->filter.filter_len > BPF_MAXINSNS)
>  		return -EINVAL;
>  
> +	/* Verify filter size */
> +	def = &io_issue_defs[reg->filter.opcode];
> +
> +	/* same size, always ok */
> +	ret = 0;
> +	if (reg->filter.pdu_size == def->filter_pdu_size)
> +		;

Odd way of writing this if-else ladder :)


> +	/* size differs, fail in strict mode */
> +	else if (reg->filter.flags & IO_URING_BPF_FILTER_SZ_STRICT)
> +		ret = -EMSGSIZE;
> +	/* userspace filter is bigger, always disallow */
> +	else if (reg->filter.pdu_size > def->filter_pdu_size)
> +		ret = -EMSGSIZE;
> +
> +	/* copy back kernel filter size */
> +	reg->filter.pdu_size = def->filter_pdu_size;
> +	if (copy_to_user(&arg->filter, &reg->filter, sizeof(reg->filter)))
> +		return -EFAULT;
> +
> +	return ret;
> +}
> +
> +int io_register_bpf_filter(struct io_restriction *res,
> +			   struct io_uring_bpf __user *arg)
> +{
> +	struct io_bpf_filters *filters, *old_filters = NULL;
> +	struct io_bpf_filter *filter, *old_filter;
> +	struct io_uring_bpf reg;
> +	struct bpf_prog *prog;
> +	struct sock_fprog fprog;
> +	int ret;
> +
> +	ret = io_bpf_filter_import(&reg, arg);
> +	if (ret)
> +		return ret;
> +
>  	fprog.len = reg.filter.filter_len;
>  	fprog.filter = u64_to_user_ptr(reg.filter.filter_ptr);
>  
> -- 
> 2.51.0
> 

