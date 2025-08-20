Return-Path: <io-uring+bounces-9127-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 90C0DB2E586
	for <lists+io-uring@lfdr.de>; Wed, 20 Aug 2025 21:18:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2BD061BC1651
	for <lists+io-uring@lfdr.de>; Wed, 20 Aug 2025 19:18:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E87D22D9F1;
	Wed, 20 Aug 2025 19:18:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="aUCuw4Ow"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f46.google.com (mail-oo1-f46.google.com [209.85.161.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 480DF36CE01
	for <io-uring@vger.kernel.org>; Wed, 20 Aug 2025 19:17:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755717479; cv=none; b=FR3jklElCI6Lu184I51uojcWCdiOWcjd2vOZSL7gOoZPsgH56mLocZiYntk7BU8S5PDzQezaezfGOfprcev4ZY/ZE4u7/3COSyYe9+fnUpwr7J8/2XYE2xQaV12CGsIBhOyda2WViYawJ0UAtm8qQMCnoUAxOoPGM7Zgev8XVG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755717479; c=relaxed/simple;
	bh=BQCiEaDWvSLcKsbjSmCRSIIQWIQY31yQ4nRpM51L8yo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QE0hWBjr5/LIFzaOc1hYJI/Z0Qhz7NeCOephvYxbTb1vDXgBsD8yq3LVTkRA7PRtpbCq2suIBIkSgWSABtBcf9K3urpGIA/kZNGDX6kkhH2W4ZVYBQ1jZAzGbXaEKSgql4PJEMtxutMedRsQvh9NUnHyxqKxkyo6ixav5oB0EhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=aUCuw4Ow; arc=none smtp.client-ip=209.85.161.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oo1-f46.google.com with SMTP id 006d021491bc7-61da74ac09fso84444eaf.2
        for <io-uring@vger.kernel.org>; Wed, 20 Aug 2025 12:17:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1755717475; x=1756322275; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=po5RaFFdO3vXAnmclbUTZdoM9ppJOrYJK5GBM2WXDUI=;
        b=aUCuw4Ow3yxAuVT9ZaqFK3tx71Paop7Jq6ujaN7t/Qhw8kTErqcoR44GQFQzMPvdj6
         oAfVupTEhlaBT2KNA94ctaxaZAmYYvxjEiZz4gIymYOHPAFAUcxJ4CnFImOHZswPmxHr
         6VFXI/+WATLTgee3DU4ExJEOUlkAgX+P1ERKuE9pyYFtMfbTc3eL5GctuzBJxNFRveQA
         bMT7DG4pXObHg7ZBwbsXE9zqT0Go9WoOOv0O38d3DA9pNCUS933uxmE2IBVkWQiFZufX
         6JFERwYxQJKTaE9/dY1GMaSQAyj7vh0Mwx0jdDff043avJuEVepXX3nigiA/8dBniUeR
         XoRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755717475; x=1756322275;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=po5RaFFdO3vXAnmclbUTZdoM9ppJOrYJK5GBM2WXDUI=;
        b=uvRTgnxIm1DYoVSbcjkh7XhWXZyW6BP+zMmGwAigT3rNaGLSNteM0tcJqpb7bwldeb
         FHJhTdQixT3QJDX6zTZ8VsybmTgLM1VIoI6/9KHFjCHh3OAncVbvNvi4DSLof3+FDBY0
         v5rysNHS0rvjOLo0Ig4rlNcoMI0vaXPvdiOLhWn1O8Odb5glbBkXduMDOmjIGNsFWO9a
         Mgadhe6G1VyXQmIDAsAx2qT5rBTrzkFT/Q+S/kqUZ+P5zijYULOUuQgs+eDysHLBw1ru
         SpRfXnxhnAyM6cXa4ljYr1ABGATGiqBBbgoHtNpvZvb+eKDvvpOAT1HOd2ClVYW4xJq5
         Jdpg==
X-Forwarded-Encrypted: i=1; AJvYcCVPIcGbKiFFvy2RShxOnngWnAmmontjjmjeXwt5IYtJd2MfIYsirwpiw8UDcwVz82dNggrripTnmg==@vger.kernel.org
X-Gm-Message-State: AOJu0YykzBVIS3ylTbnPNf4Be76rRFrhi4JvUkqNcctLiGN5oFDlu/sY
	WfR7lSjMIjwl7Tn+d8+yfGeRGgqnIcFaIlFxYefAahcBtyTCIDC1f9OTQDlGY3CB68M=
X-Gm-Gg: ASbGnct9zv/B/zG7xZefkrdFWfmg7yaDhjyt9fFOYvHX/qjSRKeD4osyZiUM6R08CVR
	X6mWSCMFgyv4TAX1DvUk5sf9J/1Jbx7NBvm7HuzSey5BIM9WfPFvOredKhaHvm/7xUsziDOa4zc
	hFgWY1zUIyy9EhqY1n4hZoAVLXgJMVOGkw69bQ0VCizagZYjhfo9AawYuv1a2ec1Jjk/B7YR9/C
	J0aKKiX310WGZ2Xt1vKqX7p8nbOKU1ziMcgNbUcDZBafrDWjHNvqX08LONpjRxsi/1br13Vsrg8
	I9VFt3nsYvhc2cto4ey9mxLEI5LpmtHmZL4E6ALI1Drw54iVLXgDyL+tPothC4uTGM41fcrdbtY
	ZmzD+7Dssq9JEJgDKPOg=
X-Google-Smtp-Source: AGHT+IE0pEQ6tpjavmwKFVUsNCLjEoGWGwTE29S+/X4R2X3w2PpQXamib1OyJ32n5EnLyFSpbZFpmw==
X-Received: by 2002:a05:6808:1485:b0:434:d39:63af with SMTP id 5614622812f47-4377200b8d0mr2030858b6e.15.1755717474986;
        Wed, 20 Aug 2025 12:17:54 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-50c947b3790sm4300714173.25.2025.08.20.12.17.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Aug 2025 12:17:54 -0700 (PDT)
Message-ID: <087e7eb4-c3bb-4953-be9f-d936377cf0d4@kernel.dk>
Date: Wed, 20 Aug 2025 13:17:53 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V4] io_uring: uring_cmd: add multishot support
To: Ming Lei <ming.lei@redhat.com>, io-uring@vger.kernel.org,
 Pavel Begunkov <asml.silence@gmail.com>
Cc: Caleb Sander Mateos <csander@purestorage.com>
References: <20250820154005.1086709-1-ming.lei@redhat.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20250820154005.1086709-1-ming.lei@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/20/25 9:40 AM, Ming Lei wrote:
> Add UAPI flag IORING_URING_CMD_MULTISHOT for supporting multishot
> uring_cmd operations with provided buffer.
> 
> This enables drivers to post multiple completion events from a single
> uring_cmd submission, which is useful for:
> 
> - Notifying userspace of device events (e.g., interrupt handling)
> - Supporting devices with multiple event sources (e.g., multi-queue devices)
> - Avoiding the need for device poll() support when events originate
>   from multiple sources device-wide
> 
> The implementation adds two new APIs:
> - io_uring_cmd_select_buffer(): selects a buffer from the provided
>   buffer group for multishot uring_cmd
> - io_uring_mshot_cmd_post_cqe(): posts a CQE after event data is
>   pushed to the provided buffer
> 
> Multishot uring_cmd must be used with buffer select (IOSQE_BUFFER_SELECT)
> and is mutually exclusive with IORING_URING_CMD_FIXED for now.
> 
> The ublk driver will be the first user of this functionality:
> 
> 	https://github.com/ming1/linux/commits/ublk-devel/
> 
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
> V4:
> - add io_do_buffer_select() check in io_uring_cmd_select_buffer(()
> - comments that the two APIs should work together for committing buffer
>   upfront(Jens)
> 
> V3:
> - enhance buffer select check(Jens)
> 
> V2:
> - Fixed static inline return type
> - Updated UAPI comments: Clarified that IORING_URING_CMD_MULTISHOT must be used with buffer select
> - Refactored validation checks: Moved the mutual exclusion checks into the individual flag validation
> sections for better code organization
> - Added missing req_set_fail(): Added the missing failure handling in io_uring_mshot_cmd_post_cqe
> - Improved commit message: Rewrote the commit message to be clearer, more technical, and better explain
> the use cases and API changes
> 
>  include/linux/io_uring/cmd.h  | 28 ++++++++++++
>  include/uapi/linux/io_uring.h |  6 ++-
>  io_uring/opdef.c              |  1 +
>  io_uring/uring_cmd.c          | 81 ++++++++++++++++++++++++++++++++++-
>  4 files changed, 114 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
> index cfa6d0c0c322..72832757f8ef 100644
> --- a/include/linux/io_uring/cmd.h
> +++ b/include/linux/io_uring/cmd.h
> @@ -70,6 +70,22 @@ void io_uring_cmd_mark_cancelable(struct io_uring_cmd *cmd,
>  /* Execute the request from a blocking context */
>  void io_uring_cmd_issue_blocking(struct io_uring_cmd *ioucmd);
>  
> +/*
> + * Select a buffer from the provided buffer group for multishot uring_cmd.
> + * Returns the selected buffer address and size.
> + */
> +int io_uring_cmd_select_buffer(struct io_uring_cmd *ioucmd,
> +			       unsigned buf_group,
> +			       void **buf, size_t *len,
> +			       unsigned int issue_flags);
> +
> +/*
> + * Complete a multishot uring_cmd event. This will post a CQE to the completion
> + * queue and update the provided buffer.
> + */
> +bool io_uring_mshot_cmd_post_cqe(struct io_uring_cmd *ioucmd,
> +				 ssize_t ret, unsigned int issue_flags);
> +
>  #else
>  static inline int
>  io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
> @@ -102,6 +118,18 @@ static inline void io_uring_cmd_mark_cancelable(struct io_uring_cmd *cmd,
>  static inline void io_uring_cmd_issue_blocking(struct io_uring_cmd *ioucmd)
>  {
>  }
> +static inline int io_uring_cmd_select_buffer(struct io_uring_cmd *ioucmd,
> +				unsigned buf_group,
> +				void **buf, size_t *len,
> +				unsigned int issue_flags)
> +{
> +	return -EOPNOTSUPP;
> +}
> +static inline bool io_uring_mshot_cmd_post_cqe(struct io_uring_cmd *ioucmd,
> +				ssize_t ret, unsigned int issue_flags)
> +{
> +	return true;
> +}
>  #endif
>  
>  /*
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> index 6957dc539d83..1e935f8901c5 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -298,9 +298,13 @@ enum io_uring_op {
>   * sqe->uring_cmd_flags		top 8bits aren't available for userspace
>   * IORING_URING_CMD_FIXED	use registered buffer; pass this flag
>   *				along with setting sqe->buf_index.
> + * IORING_URING_CMD_MULTISHOT	must be used with buffer select, like other
> + *				multishot commands. Not compatible with
> + *				IORING_URING_CMD_FIXED, for now.
>   */
>  #define IORING_URING_CMD_FIXED	(1U << 0)
> -#define IORING_URING_CMD_MASK	IORING_URING_CMD_FIXED
> +#define IORING_URING_CMD_MULTISHOT	(1U << 1)
> +#define IORING_URING_CMD_MASK	(IORING_URING_CMD_FIXED | IORING_URING_CMD_MULTISHOT)
>  
>  
>  /*
> diff --git a/io_uring/opdef.c b/io_uring/opdef.c
> index 9568785810d9..932319633eac 100644
> --- a/io_uring/opdef.c
> +++ b/io_uring/opdef.c
> @@ -413,6 +413,7 @@ const struct io_issue_def io_issue_defs[] = {
>  #endif
>  	},
>  	[IORING_OP_URING_CMD] = {
> +		.buffer_select		= 1,
>  		.needs_file		= 1,
>  		.plug			= 1,
>  		.iopoll			= 1,
> diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
> index 053bac89b6c0..babb6a4b3542 100644
> --- a/io_uring/uring_cmd.c
> +++ b/io_uring/uring_cmd.c
> @@ -11,6 +11,7 @@
>  #include "io_uring.h"
>  #include "alloc_cache.h"
>  #include "rsrc.h"
> +#include "kbuf.h"
>  #include "uring_cmd.h"
>  #include "poll.h"
>  
> @@ -194,8 +195,21 @@ int io_uring_cmd_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>  	if (ioucmd->flags & ~IORING_URING_CMD_MASK)
>  		return -EINVAL;
>  
> -	if (ioucmd->flags & IORING_URING_CMD_FIXED)
> +	if (ioucmd->flags & IORING_URING_CMD_FIXED) {
> +		if (ioucmd->flags & IORING_URING_CMD_MULTISHOT)
> +			return -EINVAL;
>  		req->buf_index = READ_ONCE(sqe->buf_index);
> +	}
> +
> +	if (ioucmd->flags & IORING_URING_CMD_MULTISHOT) {
> +		if (ioucmd->flags & IORING_URING_CMD_FIXED)
> +			return -EINVAL;
> +		if (!(req->flags & REQ_F_BUFFER_SELECT))
> +			return -EINVAL;
> +	} else {
> +		if (req->flags & REQ_F_BUFFER_SELECT)
> +			return -EINVAL;
> +	}
>  
>  	ioucmd->cmd_op = READ_ONCE(sqe->cmd_op);
>  
> @@ -251,6 +265,11 @@ int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags)
>  	}
>  
>  	ret = file->f_op->uring_cmd(ioucmd, issue_flags);
> +	if (ioucmd->flags & IORING_URING_CMD_MULTISHOT) {
> +		if (ret >= 0)
> +			return IOU_ISSUE_SKIP_COMPLETE;
> +		io_kbuf_recycle(req, issue_flags);
> +	}
>  	if (ret == -EAGAIN) {
>  		ioucmd->flags |= IORING_URING_CMD_REISSUE;
>  		return ret;
> @@ -333,3 +352,63 @@ bool io_uring_cmd_post_mshot_cqe32(struct io_uring_cmd *cmd,
>  		return false;
>  	return io_req_post_cqe32(req, cqe);
>  }
> +
> +/*
> + * Work with io_uring_mshot_cmd_post_cqe() together for committing the
> + * provided buffer upfront
> + *
> + * The two must be paired, and both must be called within the same
> + * uring_cmd submission context.
> + */
> +int io_uring_cmd_select_buffer(struct io_uring_cmd *ioucmd,
> +			       unsigned buf_group,
> +			       void __user **buf, size_t *len,
> +			       unsigned int issue_flags)
> +{
> +	struct io_kiocb *req = cmd_to_io_kiocb(ioucmd);
> +	void __user *ubuf;
> +
> +	if (!(ioucmd->flags & IORING_URING_CMD_MULTISHOT))
> +		return -EINVAL;
> +
> +	if (WARN_ON_ONCE(!io_do_buffer_select(req)))
> +		return -EINVAL;
> +
> +	ubuf = io_buffer_select(req, len, buf_group, issue_flags);
> +	if (!ubuf)
> +		return -ENOBUFS;
> +
> +	*buf = ubuf;
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(io_uring_cmd_select_buffer);
> +
> +/*
> + * Return true if this multishot uring_cmd needs to be completed, otherwise
> + * the event CQE is posted successfully.
> + *
> + * This function must be paired with io_uring_cmd_select_buffer(), and both
> + * must be called within the same uring_cmd submission context.
> + */
> +bool io_uring_mshot_cmd_post_cqe(struct io_uring_cmd *ioucmd,
> +				 ssize_t ret, unsigned int issue_flags)
> +{
> +	struct io_kiocb *req = cmd_to_io_kiocb(ioucmd);
> +	unsigned int cflags = 0;
> +
> +	if (!(ioucmd->flags & IORING_URING_CMD_MULTISHOT))
> +		return true;
> +
> +	if (ret > 0) {
> +		cflags = io_put_kbuf(req, ret, issue_flags);
> +		if (io_req_post_cqe(req, ret, cflags | IORING_CQE_F_MORE))
> +			return false;
> +	}
> +
> +	io_kbuf_recycle(req, issue_flags);
> +	if (ret < 0)
> +		req_set_fail(req);
> +	io_req_set_res(req, ret, cflags);
> +	return true;
> +}
> +EXPORT_SYMBOL_GPL(io_uring_mshot_cmd_post_cqe);

I posted the series I talked about, which wraps this in struct
io_br_sel:

https://lore.kernel.org/io-uring/20250820182601.442933-1-axboe@kernel.dk/T/#m1001f151693606f7a73b48ab939be5caf8d182c3

and with that in mind, I don't think the CQE posting is the place to do
it. Even before that series, I don't think it's the right spot. I'd keep
that as just posting the CQE.

In any case, on top of the current patches, you'd do something ala:

struct io_br_sel sel;

sel = io_uring_cmd_select_buffer(cmd, group, &len, issue_flags);

and sel.addr would be your buffer on return, and sel would hold the
buffer_list (or have it committed already and NULL) after the fact.
sel.

Then once you're ready to do so, call:

cflags = io_put_kbuf(req, ret, sel.buf_list, issue_flags);
io_uring_mshot_cmd_post_cqe(cmd, ret, cflags);

in that same context. As mentioned, I'd keep that outside of the CQE
posting, leaving that as:

bool io_uring_mshot_cmd_post_cqe(struct io_uring_cmd *ioucmd,
				 ssize_t ret, unsigned int cflags)
{
	struct io_kiocb *req = cmd_to_io_kiocb(ioucmd);

	if (!(ioucmd->flags & IORING_URING_CMD_MULTISHOT))
		return true;

	if (ret > 0) {
		if (io_req_post_cqe(req, ret, cflags | IORING_CQE_F_MORE))
			return false;
	}

	if (ret < 0)
		req_set_fail(req);
	io_req_set_res(req, ret, cflags);
	return true;
}

With that, it should be completely clear that the usage of
io_buffer_list is always sane, and it forces you to do the right thing
wrt how the buffer is retrieved and committed. This avoids any issues
with the current patch in terms of buffer list UAF, and makes it so that
future users of this helper is also forced to get it right rather than
need to understand all the minute details around that.

Hope that makes sense...

-- 
Jens Axboe

