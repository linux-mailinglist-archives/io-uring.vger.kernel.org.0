Return-Path: <io-uring+bounces-9148-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B88FFB2EB2E
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 04:25:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EDCFC3AD087
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 02:24:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A989E23815B;
	Thu, 21 Aug 2025 02:24:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="SlLF+jYE"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11A2D22425E
	for <io-uring@vger.kernel.org>; Thu, 21 Aug 2025 02:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755743073; cv=none; b=pR0s6D5B+yvrSFptmaWRKoF/m2uHf/bPUDDNYQIzuPqAsjJVfeQPs4Obtud8z6mbT1a4jKtBrRXiwfHBRmX8dWk3Nv1Xsv3ROPF4jeQHe/Q0CwhtgbaqE6AW1cNPMHzmSWGYw9fmlH1mVXmapKxjTDfGfGbWC1tRnQZw69QaZD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755743073; c=relaxed/simple;
	bh=G3NTAetjuQiWGClD9ImuJ/L1VZQ7xBtqR5oYu9YkuQM=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=lFP7ccD9vCxnFaQf5PY5sGA7TrTWVMJrXn/SXRp7sudv/qbi/M+I/dwQjQmts7XUPl58zE3ua/o7uGybZswgw/r41RoMOFfWRs7b9uwEgAj/Xr3coioNClfJ9HKQZM9s/IKdUCLJ0CQTfrPDesR5GmAVPTbaNhS+VI42sxdeUWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=SlLF+jYE; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-76e2e614b84so580271b3a.0
        for <io-uring@vger.kernel.org>; Wed, 20 Aug 2025 19:24:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1755743067; x=1756347867; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=itc+1fD4oNFDTgqgwyBifKn99E79AULRWMmvOOo8vVs=;
        b=SlLF+jYEetmnNQ+1U9tUr6YmTF+zuqZ31gfN2rInjgRwdy6pTkDW2j2Hmwm9cm4346
         RXIxKGjBzn5yK49WrnGHo56DMkRbv6ck6LfE8z6QCKpjlvrGcM1xeZivGpPl/3/DdVwu
         BQcg3uCi5x2NOIGTAmvCP0KMIWnn3cFwbgCUp3Gw7lF33r5laIphN3YDimczoOfkV+1x
         64E91Nu4cN7BF4hpTfhB1jsR4rRNVpoVwHYb0R9vyhNoo8/xt+mky3+5IjkPN8o3qdkK
         osn7V7ipnlb3KsEvzQJF3ENIFucVy1HhaBlPG1zKLPmmmY/gKjkQ9afiQy8hL47Vcgam
         uJsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755743067; x=1756347867;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=itc+1fD4oNFDTgqgwyBifKn99E79AULRWMmvOOo8vVs=;
        b=OEUCEg3hheLJMXUsjgfvNuXAjkcm/WjkCf7TIegDq0QtaK7igPujRdZ5R4kftw78Uh
         99a81veqJE0Xn0JH3HVApL01chWXil+Ura+H1uQIDzJvJWvzbLciftXnDsR86hWA5JJm
         Lcc6h7rPnlJvFZKh80erIim4paxDOhqHLjkkhMhhh1w/qkpH/uGRa0lZiXn+t/L0uaSe
         anNLb+YiBufnWg3a4R/xJ4HoJDyILzIZ+1nQHdod1L9RzAkyxnhbQNCNsUFcbHz8QREf
         rEfXVPcjIUmFUvSi04K5StDpia9GuCJJ4tyJpNbzrVVJh3NRTWqlpOJXRP8iMS8llvJe
         aS/w==
X-Forwarded-Encrypted: i=1; AJvYcCUV7PItu69fjhMREaT82vnG2fNZ3FFm/zV1sHaJDwR/9B9bdXNgCusUlRW8P3Fl8eoMJC7GtqrSqw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxtk6yj8PdrM9+UXReVJxv5U5cJ6bkIcXIFo7yO7ETAHMHlMprY
	tIl2P6A8ox/OO92DLj8Fl3ECXCb7KpACL1xgfo78JDC7cleYnFpGydk41/IwwztvHI4=
X-Gm-Gg: ASbGncu13fZ7htRu/0iYI0UQhDf6qktsVS+hgRRI08ApHepskJECXEizqC1j+a4ll76
	NrTLlfH5VRAM0AwEd5e3o9YfFQFlJr/ItHYGDt1OThyId8oQJjTVt2+RXuv3wNTyMCXXX+9HSVi
	Hdn5/2zGYm8KXdVasQyvAbpdYy+CF0CbTBL7N66ydM4mmHiqF+FpzyVTCBqYYffjkpjcSjO3BIN
	TSPgfroWohrk1agq4lvzEJb2n3j6pWluMu9aiWSWcJXzVAckxqHI3ZO/SND72LnijxR5bJERwcE
	dHR1T1aHupB1x+/sVc+5bQsmgGFXccswB5g/jiJx4okJmjmFeQZbZBrj08boy0hcfOJPi8Mn83O
	Yhz4iD+QfWvXjAeNfoMjMNxicjbCTint+eZezGG4MNw==
X-Google-Smtp-Source: AGHT+IHTiBPpzC7ibS5xRL7Cq86de78Q/ZBQncFSx/CJDtMg2cn2ATe3KpBym/+ZUY1C4RAzH33HQQ==
X-Received: by 2002:a05:6a20:734f:b0:240:aa7:ba66 with SMTP id adf61e73a8af0-243308c09edmr907635637.16.1755743067054;
        Wed, 20 Aug 2025 19:24:27 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-76e7d0d1735sm6847210b3a.9.2025.08.20.19.24.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Aug 2025 19:24:26 -0700 (PDT)
Message-ID: <2a3e4ad9-9679-43cf-b368-237167c2f544@kernel.dk>
Date: Wed, 20 Aug 2025 20:24:25 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V4] io_uring: uring_cmd: add multishot support
From: Jens Axboe <axboe@kernel.dk>
To: Ming Lei <ming.lei@redhat.com>, io-uring@vger.kernel.org,
 Pavel Begunkov <asml.silence@gmail.com>
Cc: Caleb Sander Mateos <csander@purestorage.com>
References: <20250820154005.1086709-1-ming.lei@redhat.com>
 <087e7eb4-c3bb-4953-be9f-d936377cf0d4@kernel.dk>
Content-Language: en-US
In-Reply-To: <087e7eb4-c3bb-4953-be9f-d936377cf0d4@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/20/25 1:17 PM, Jens Axboe wrote:
> On 8/20/25 9:40 AM, Ming Lei wrote:
>> Add UAPI flag IORING_URING_CMD_MULTISHOT for supporting multishot
>> uring_cmd operations with provided buffer.
>>
>> This enables drivers to post multiple completion events from a single
>> uring_cmd submission, which is useful for:
>>
>> - Notifying userspace of device events (e.g., interrupt handling)
>> - Supporting devices with multiple event sources (e.g., multi-queue devices)
>> - Avoiding the need for device poll() support when events originate
>>   from multiple sources device-wide
>>
>> The implementation adds two new APIs:
>> - io_uring_cmd_select_buffer(): selects a buffer from the provided
>>   buffer group for multishot uring_cmd
>> - io_uring_mshot_cmd_post_cqe(): posts a CQE after event data is
>>   pushed to the provided buffer
>>
>> Multishot uring_cmd must be used with buffer select (IOSQE_BUFFER_SELECT)
>> and is mutually exclusive with IORING_URING_CMD_FIXED for now.
>>
>> The ublk driver will be the first user of this functionality:
>>
>> 	https://github.com/ming1/linux/commits/ublk-devel/
>>
>> Signed-off-by: Ming Lei <ming.lei@redhat.com>
>> ---
>> V4:
>> - add io_do_buffer_select() check in io_uring_cmd_select_buffer(()
>> - comments that the two APIs should work together for committing buffer
>>   upfront(Jens)
>>
>> V3:
>> - enhance buffer select check(Jens)
>>
>> V2:
>> - Fixed static inline return type
>> - Updated UAPI comments: Clarified that IORING_URING_CMD_MULTISHOT must be used with buffer select
>> - Refactored validation checks: Moved the mutual exclusion checks into the individual flag validation
>> sections for better code organization
>> - Added missing req_set_fail(): Added the missing failure handling in io_uring_mshot_cmd_post_cqe
>> - Improved commit message: Rewrote the commit message to be clearer, more technical, and better explain
>> the use cases and API changes
>>
>>  include/linux/io_uring/cmd.h  | 28 ++++++++++++
>>  include/uapi/linux/io_uring.h |  6 ++-
>>  io_uring/opdef.c              |  1 +
>>  io_uring/uring_cmd.c          | 81 ++++++++++++++++++++++++++++++++++-
>>  4 files changed, 114 insertions(+), 2 deletions(-)
>>
>> diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
>> index cfa6d0c0c322..72832757f8ef 100644
>> --- a/include/linux/io_uring/cmd.h
>> +++ b/include/linux/io_uring/cmd.h
>> @@ -70,6 +70,22 @@ void io_uring_cmd_mark_cancelable(struct io_uring_cmd *cmd,
>>  /* Execute the request from a blocking context */
>>  void io_uring_cmd_issue_blocking(struct io_uring_cmd *ioucmd);
>>  
>> +/*
>> + * Select a buffer from the provided buffer group for multishot uring_cmd.
>> + * Returns the selected buffer address and size.
>> + */
>> +int io_uring_cmd_select_buffer(struct io_uring_cmd *ioucmd,
>> +			       unsigned buf_group,
>> +			       void **buf, size_t *len,
>> +			       unsigned int issue_flags);
>> +
>> +/*
>> + * Complete a multishot uring_cmd event. This will post a CQE to the completion
>> + * queue and update the provided buffer.
>> + */
>> +bool io_uring_mshot_cmd_post_cqe(struct io_uring_cmd *ioucmd,
>> +				 ssize_t ret, unsigned int issue_flags);
>> +
>>  #else
>>  static inline int
>>  io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
>> @@ -102,6 +118,18 @@ static inline void io_uring_cmd_mark_cancelable(struct io_uring_cmd *cmd,
>>  static inline void io_uring_cmd_issue_blocking(struct io_uring_cmd *ioucmd)
>>  {
>>  }
>> +static inline int io_uring_cmd_select_buffer(struct io_uring_cmd *ioucmd,
>> +				unsigned buf_group,
>> +				void **buf, size_t *len,
>> +				unsigned int issue_flags)
>> +{
>> +	return -EOPNOTSUPP;
>> +}
>> +static inline bool io_uring_mshot_cmd_post_cqe(struct io_uring_cmd *ioucmd,
>> +				ssize_t ret, unsigned int issue_flags)
>> +{
>> +	return true;
>> +}
>>  #endif
>>  
>>  /*
>> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
>> index 6957dc539d83..1e935f8901c5 100644
>> --- a/include/uapi/linux/io_uring.h
>> +++ b/include/uapi/linux/io_uring.h
>> @@ -298,9 +298,13 @@ enum io_uring_op {
>>   * sqe->uring_cmd_flags		top 8bits aren't available for userspace
>>   * IORING_URING_CMD_FIXED	use registered buffer; pass this flag
>>   *				along with setting sqe->buf_index.
>> + * IORING_URING_CMD_MULTISHOT	must be used with buffer select, like other
>> + *				multishot commands. Not compatible with
>> + *				IORING_URING_CMD_FIXED, for now.
>>   */
>>  #define IORING_URING_CMD_FIXED	(1U << 0)
>> -#define IORING_URING_CMD_MASK	IORING_URING_CMD_FIXED
>> +#define IORING_URING_CMD_MULTISHOT	(1U << 1)
>> +#define IORING_URING_CMD_MASK	(IORING_URING_CMD_FIXED | IORING_URING_CMD_MULTISHOT)
>>  
>>  
>>  /*
>> diff --git a/io_uring/opdef.c b/io_uring/opdef.c
>> index 9568785810d9..932319633eac 100644
>> --- a/io_uring/opdef.c
>> +++ b/io_uring/opdef.c
>> @@ -413,6 +413,7 @@ const struct io_issue_def io_issue_defs[] = {
>>  #endif
>>  	},
>>  	[IORING_OP_URING_CMD] = {
>> +		.buffer_select		= 1,
>>  		.needs_file		= 1,
>>  		.plug			= 1,
>>  		.iopoll			= 1,
>> diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
>> index 053bac89b6c0..babb6a4b3542 100644
>> --- a/io_uring/uring_cmd.c
>> +++ b/io_uring/uring_cmd.c
>> @@ -11,6 +11,7 @@
>>  #include "io_uring.h"
>>  #include "alloc_cache.h"
>>  #include "rsrc.h"
>> +#include "kbuf.h"
>>  #include "uring_cmd.h"
>>  #include "poll.h"
>>  
>> @@ -194,8 +195,21 @@ int io_uring_cmd_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>  	if (ioucmd->flags & ~IORING_URING_CMD_MASK)
>>  		return -EINVAL;
>>  
>> -	if (ioucmd->flags & IORING_URING_CMD_FIXED)
>> +	if (ioucmd->flags & IORING_URING_CMD_FIXED) {
>> +		if (ioucmd->flags & IORING_URING_CMD_MULTISHOT)
>> +			return -EINVAL;
>>  		req->buf_index = READ_ONCE(sqe->buf_index);
>> +	}
>> +
>> +	if (ioucmd->flags & IORING_URING_CMD_MULTISHOT) {
>> +		if (ioucmd->flags & IORING_URING_CMD_FIXED)
>> +			return -EINVAL;
>> +		if (!(req->flags & REQ_F_BUFFER_SELECT))
>> +			return -EINVAL;
>> +	} else {
>> +		if (req->flags & REQ_F_BUFFER_SELECT)
>> +			return -EINVAL;
>> +	}
>>  
>>  	ioucmd->cmd_op = READ_ONCE(sqe->cmd_op);
>>  
>> @@ -251,6 +265,11 @@ int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags)
>>  	}
>>  
>>  	ret = file->f_op->uring_cmd(ioucmd, issue_flags);
>> +	if (ioucmd->flags & IORING_URING_CMD_MULTISHOT) {
>> +		if (ret >= 0)
>> +			return IOU_ISSUE_SKIP_COMPLETE;
>> +		io_kbuf_recycle(req, issue_flags);
>> +	}
>>  	if (ret == -EAGAIN) {
>>  		ioucmd->flags |= IORING_URING_CMD_REISSUE;
>>  		return ret;
>> @@ -333,3 +352,63 @@ bool io_uring_cmd_post_mshot_cqe32(struct io_uring_cmd *cmd,
>>  		return false;
>>  	return io_req_post_cqe32(req, cqe);
>>  }
>> +
>> +/*
>> + * Work with io_uring_mshot_cmd_post_cqe() together for committing the
>> + * provided buffer upfront
>> + *
>> + * The two must be paired, and both must be called within the same
>> + * uring_cmd submission context.
>> + */
>> +int io_uring_cmd_select_buffer(struct io_uring_cmd *ioucmd,
>> +			       unsigned buf_group,
>> +			       void __user **buf, size_t *len,
>> +			       unsigned int issue_flags)
>> +{
>> +	struct io_kiocb *req = cmd_to_io_kiocb(ioucmd);
>> +	void __user *ubuf;
>> +
>> +	if (!(ioucmd->flags & IORING_URING_CMD_MULTISHOT))
>> +		return -EINVAL;
>> +
>> +	if (WARN_ON_ONCE(!io_do_buffer_select(req)))
>> +		return -EINVAL;
>> +
>> +	ubuf = io_buffer_select(req, len, buf_group, issue_flags);
>> +	if (!ubuf)
>> +		return -ENOBUFS;
>> +
>> +	*buf = ubuf;
>> +	return 0;
>> +}
>> +EXPORT_SYMBOL_GPL(io_uring_cmd_select_buffer);
>> +
>> +/*
>> + * Return true if this multishot uring_cmd needs to be completed, otherwise
>> + * the event CQE is posted successfully.
>> + *
>> + * This function must be paired with io_uring_cmd_select_buffer(), and both
>> + * must be called within the same uring_cmd submission context.
>> + */
>> +bool io_uring_mshot_cmd_post_cqe(struct io_uring_cmd *ioucmd,
>> +				 ssize_t ret, unsigned int issue_flags)
>> +{
>> +	struct io_kiocb *req = cmd_to_io_kiocb(ioucmd);
>> +	unsigned int cflags = 0;
>> +
>> +	if (!(ioucmd->flags & IORING_URING_CMD_MULTISHOT))
>> +		return true;
>> +
>> +	if (ret > 0) {
>> +		cflags = io_put_kbuf(req, ret, issue_flags);
>> +		if (io_req_post_cqe(req, ret, cflags | IORING_CQE_F_MORE))
>> +			return false;
>> +	}
>> +
>> +	io_kbuf_recycle(req, issue_flags);
>> +	if (ret < 0)
>> +		req_set_fail(req);
>> +	io_req_set_res(req, ret, cflags);
>> +	return true;
>> +}
>> +EXPORT_SYMBOL_GPL(io_uring_mshot_cmd_post_cqe);
> 
> I posted the series I talked about, which wraps this in struct
> io_br_sel:
> 
> https://lore.kernel.org/io-uring/20250820182601.442933-1-axboe@kernel.dk/T/#m1001f151693606f7a73b48ab939be5caf8d182c3
> 
> and with that in mind, I don't think the CQE posting is the place to do
> it. Even before that series, I don't think it's the right spot. I'd keep
> that as just posting the CQE.
> 
> In any case, on top of the current patches, you'd do something ala:
> 
> struct io_br_sel sel;
> 
> sel = io_uring_cmd_select_buffer(cmd, group, &len, issue_flags);
> 
> and sel.addr would be your buffer on return, and sel would hold the
> buffer_list (or have it committed already and NULL) after the fact.
> sel.
> 
> Then once you're ready to do so, call:
> 
> cflags = io_put_kbuf(req, ret, sel.buf_list, issue_flags);
> io_uring_mshot_cmd_post_cqe(cmd, ret, cflags);
> 
> in that same context. As mentioned, I'd keep that outside of the CQE
> posting, leaving that as:
> 
> bool io_uring_mshot_cmd_post_cqe(struct io_uring_cmd *ioucmd,
> 				 ssize_t ret, unsigned int cflags)
> {
> 	struct io_kiocb *req = cmd_to_io_kiocb(ioucmd);
> 
> 	if (!(ioucmd->flags & IORING_URING_CMD_MULTISHOT))
> 		return true;
> 
> 	if (ret > 0) {
> 		if (io_req_post_cqe(req, ret, cflags | IORING_CQE_F_MORE))
> 			return false;
> 	}
> 
> 	if (ret < 0)
> 		req_set_fail(req);
> 	io_req_set_res(req, ret, cflags);
> 	return true;
> }
> 
> With that, it should be completely clear that the usage of
> io_buffer_list is always sane, and it forces you to do the right thing
> wrt how the buffer is retrieved and committed. This avoids any issues
> with the current patch in terms of buffer list UAF, and makes it so that
> future users of this helper is also forced to get it right rather than
> need to understand all the minute details around that.
> 
> Hope that makes sense...

Something like this incremental on top of the current tree, where
obviously the kbuf.h io_br_sel move to io_uring_types.h is a separate
patch.

That:

- Gets rid of the recycle in the issue path. You can't recycle there,
  have the caller that selected the buffer do the recycling there, if
  needed.

- Naming io_uring_cmd_buffer_select() rather than
  io_uring_cmd_select_buffer() to closer follow the internal API.

- io_uring_cmd_buffer_select() will now return with a NULL ->addr,
  caller should just -ENOBUFS at that point. More of a stylistic
  choice...


diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
index 72832757f8ef..856d343b8e2a 100644
--- a/include/linux/io_uring/cmd.h
+++ b/include/linux/io_uring/cmd.h
@@ -74,17 +74,16 @@ void io_uring_cmd_issue_blocking(struct io_uring_cmd *ioucmd);
  * Select a buffer from the provided buffer group for multishot uring_cmd.
  * Returns the selected buffer address and size.
  */
-int io_uring_cmd_select_buffer(struct io_uring_cmd *ioucmd,
-			       unsigned buf_group,
-			       void **buf, size_t *len,
-			       unsigned int issue_flags);
+struct io_br_sel io_uring_cmd_buffer_select(struct io_uring_cmd *ioucmd,
+					    unsigned buf_group, size_t *len,
+					    unsigned int issue_flags);
 
 /*
  * Complete a multishot uring_cmd event. This will post a CQE to the completion
  * queue and update the provided buffer.
  */
 bool io_uring_mshot_cmd_post_cqe(struct io_uring_cmd *ioucmd,
-				 ssize_t ret, unsigned int issue_flags);
+				 struct io_br_sel *sel, unsigned int issue_flags);
 
 #else
 static inline int
diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 1d33984611bc..472a1e1383a4 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -85,6 +85,24 @@ struct io_mapped_region {
 	unsigned		flags;
 };
 
+/*
+ * Return value from io_buffer_list selection, to avoid stashing it in
+ * struct io_kiocb. For legacy/classic provided buffers, keeping a reference
+ * across execution contexts are fine. But for ring provided buffers, the
+ * list may go away as soon as ->uring_lock is dropped. As the io_kiocb
+ * persists, it's better to just keep the buffer local for those cases.
+ */
+struct io_br_sel {
+	struct io_buffer_list *buf_list;
+	/*
+	 * Some selection parts return the user address, others return an error.
+	 */
+	union {
+		void __user *addr;
+		ssize_t val;
+	};
+};
+
 /*
  * Arbitrary limit, can be raised if need be
  */
diff --git a/io_uring/kbuf.h b/io_uring/kbuf.h
index 32f73adbe1e9..ada382ff38d7 100644
--- a/io_uring/kbuf.h
+++ b/io_uring/kbuf.h
@@ -62,24 +62,6 @@ struct buf_sel_arg {
 	unsigned short partial_map;
 };
 
-/*
- * Return value from io_buffer_list selection, to avoid stashing it in
- * struct io_kiocb. For legacy/classic provided buffers, keeping a reference
- * across execution contexts are fine. But for ring provided buffers, the
- * list may go away as soon as ->uring_lock is dropped. As the io_kiocb
- * persists, it's better to just keep the buffer local for those cases.
- */
-struct io_br_sel {
-	struct io_buffer_list *buf_list;
-	/*
-	 * Some selection parts return the user address, others return an error.
-	 */
-	union {
-		void __user *addr;
-		ssize_t val;
-	};
-};
-
 struct io_br_sel io_buffer_select(struct io_kiocb *req, size_t *len,
 				  unsigned buf_group, unsigned int issue_flags);
 int io_buffers_select(struct io_kiocb *req, struct buf_sel_arg *arg,
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index babb6a4b3542..688fd1fad2a8 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -268,7 +268,6 @@ int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags)
 	if (ioucmd->flags & IORING_URING_CMD_MULTISHOT) {
 		if (ret >= 0)
 			return IOU_ISSUE_SKIP_COMPLETE;
-		io_kbuf_recycle(req, issue_flags);
 	}
 	if (ret == -EAGAIN) {
 		ioucmd->flags |= IORING_URING_CMD_REISSUE;
@@ -360,28 +359,21 @@ bool io_uring_cmd_post_mshot_cqe32(struct io_uring_cmd *cmd,
  * The two must be paired, and both must be called within the same
  * uring_cmd submission context.
  */
-int io_uring_cmd_select_buffer(struct io_uring_cmd *ioucmd,
-			       unsigned buf_group,
-			       void __user **buf, size_t *len,
-			       unsigned int issue_flags)
+struct io_br_sel io_uring_cmd_buffer_select(struct io_uring_cmd *ioucmd,
+					    unsigned buf_group, size_t *len,
+					    unsigned int issue_flags)
 {
 	struct io_kiocb *req = cmd_to_io_kiocb(ioucmd);
-	void __user *ubuf;
 
 	if (!(ioucmd->flags & IORING_URING_CMD_MULTISHOT))
-		return -EINVAL;
+		return (struct io_br_sel) { .val = -EINVAL };
 
 	if (WARN_ON_ONCE(!io_do_buffer_select(req)))
-		return -EINVAL;
-
-	ubuf = io_buffer_select(req, len, buf_group, issue_flags);
-	if (!ubuf)
-		return -ENOBUFS;
+		return (struct io_br_sel) { .val = -EINVAL };
 
-	*buf = ubuf;
-	return 0;
+	return io_buffer_select(req, len, buf_group, issue_flags);
 }
-EXPORT_SYMBOL_GPL(io_uring_cmd_select_buffer);
+EXPORT_SYMBOL_GPL(io_uring_cmd_buffer_select);
 
 /*
  * Return true if this multishot uring_cmd needs to be completed, otherwise
@@ -391,7 +383,7 @@ EXPORT_SYMBOL_GPL(io_uring_cmd_select_buffer);
  * must be called within the same uring_cmd submission context.
  */
 bool io_uring_mshot_cmd_post_cqe(struct io_uring_cmd *ioucmd,
-				 ssize_t ret, unsigned int issue_flags)
+				 struct io_br_sel *sel, unsigned int issue_flags)
 {
 	struct io_kiocb *req = cmd_to_io_kiocb(ioucmd);
 	unsigned int cflags = 0;
@@ -399,16 +391,16 @@ bool io_uring_mshot_cmd_post_cqe(struct io_uring_cmd *ioucmd,
 	if (!(ioucmd->flags & IORING_URING_CMD_MULTISHOT))
 		return true;
 
-	if (ret > 0) {
-		cflags = io_put_kbuf(req, ret, issue_flags);
-		if (io_req_post_cqe(req, ret, cflags | IORING_CQE_F_MORE))
+	if (sel->val > 0) {
+		cflags = io_put_kbuf(req, sel->val, sel->buf_list);
+		if (io_req_post_cqe(req, sel->val, cflags | IORING_CQE_F_MORE))
 			return false;
 	}
 
-	io_kbuf_recycle(req, issue_flags);
-	if (ret < 0)
+	io_kbuf_recycle(req, sel->buf_list, issue_flags);
+	if (sel->val < 0)
 		req_set_fail(req);
-	io_req_set_res(req, ret, cflags);
+	io_req_set_res(req, sel->val, cflags);
 	return true;
 }
 EXPORT_SYMBOL_GPL(io_uring_mshot_cmd_post_cqe);

-- 
Jens Axboe

