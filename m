Return-Path: <io-uring+bounces-9041-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D1B05B2ACDD
	for <lists+io-uring@lfdr.de>; Mon, 18 Aug 2025 17:36:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B5CC71B246EB
	for <lists+io-uring@lfdr.de>; Mon, 18 Aug 2025 15:32:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E5CA25B302;
	Mon, 18 Aug 2025 15:32:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="kZZk6Nk2"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f41.google.com (mail-io1-f41.google.com [209.85.166.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9ECC255E53
	for <io-uring@vger.kernel.org>; Mon, 18 Aug 2025 15:32:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755531147; cv=none; b=D9VzlTky/ZbUt4HbGYiFRWinte6qgHHXyK+lAuMB4qxZjkXd0H6r0agP+J92qvIUCoz5pjmXYtPKzsF7ABAIVzSYpTDbV5FiBGm6YYQtK8zqXd/+Vg7tY7WMmz+QnJHowZpzU6ou8Xp6GbA/xJUzA1b8AUI/Lo/NDLRlpARKDWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755531147; c=relaxed/simple;
	bh=aFJEFlaf2HhcwaDfNQYm8TgImWNkykAjIh5L0XksGWc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iD1v0HhF92TJzmlLWuH4QfiEBaEYnJBpgOHSzhVOhzqY2l7WJYssrbXcfvzQwoRf+V9Z1WXTthEhwWVH98k84o5e9W6MhPjaMY37/OpKqTHzRWhBI6SouqVtapD5jstOVpVvNpp80rqJHqPHN20g8WAuaQU9kOe4GdHPjqKjdvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=kZZk6Nk2; arc=none smtp.client-ip=209.85.166.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f41.google.com with SMTP id ca18e2360f4ac-88432e27c77so112903539f.2
        for <io-uring@vger.kernel.org>; Mon, 18 Aug 2025 08:32:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1755531143; x=1756135943; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xWAuzOTiBu2L+nUwMsNF8mIj+3BJlQLocL3QTTHPfc8=;
        b=kZZk6Nk2pok8FgLYXjHIkvM5/h3Nz1AikaynOy5qmxZIsC8xEJ8hota8MmzUYu4vx2
         K7dyLcEUwyWMI/uGY5ZC8E1eZ8SAWKk7QhLweTMbmMAgWRvBAmIMPTR1wQSlRvBuA6m2
         km8WDaWt20qzXQWaW/xTjbR1MiAS42c1/HunBVSBqVzoHa0lMPkm9IVDwEHsmxJ5xq69
         96Kxfl3a3ozOB1mBQQcmqpgfbhHC0I3tcNOLnFQr+8EKBIh1C8sdmmAnUstz4+PLwoHs
         HK+1TJ3wjPMEmcwWWDGDIeJrEQTUXsz6QogQ5q0K3LCYWH9obeJVCb4VimhbLyOyApKC
         b1YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755531143; x=1756135943;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xWAuzOTiBu2L+nUwMsNF8mIj+3BJlQLocL3QTTHPfc8=;
        b=BYMvRerpRC1a5Kq6Sa5EUG7RQuvpSf1allAOnKZ68PqFo+YpkoA4Bd6nn/hONgAR2h
         MPY/GdHAmh5vcF9UFimsD/Mgp3CqPEz/2ILQo96VNmGDrmxgdkXLT5W3esNKI+vqd38p
         H3ewzAbePWb10N/IwvuyW6zDwvnBZWn3p3oUQ4yDmtGHflc+6+Q0KswdHk7rjMai8HfA
         dzqgmHu5afNXUESQUO5OBJ6wG6jkh0MUUG+c7roadc1mSlVZB40Z+vfymY77xmUJ1OUd
         CdZ25JeZ4h4KbHbIIPTMOv8eB0S3H++xtqqlpW8z7MtDdzMkWnB6SPk8w/1gkr6BX3zS
         Bi5w==
X-Forwarded-Encrypted: i=1; AJvYcCU4gCQ7vcwrLl7Wk+JAoquIfJAJc95xkYe8vg6HLRr/ZPsOM6p6H4V0A6vhiDbe7U3oyZ32kWmKZg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxXwMC0eO4fRwh+eB7DucLuBeX7br1nQm3OpaFC2emjNu31Hvrj
	PYDUd0LeA4hHpzuHyZUT8ld/bdcGvKY/Z//9XkD2HkQMSuTnYtJcwRc/VXWPNXHNiXw=
X-Gm-Gg: ASbGnctoLNDmOgWE6gNWgAyXZw41H1da/3fXosuobg52ZT/QQ0geHf1bq91aNUuuBPy
	0b9PddHLil/dAGOZ9ohq283SwRLPSsJgOKthqKsLKhHL0w3PYuU3BW4cQeCPcDee2wg6bmmkfBS
	Ag42wOq/RuipddwuHLHlgIysm80xEZ+snekXW96EeavzcSJngkY1VtwM0uALMFDxuJSRwXC35BZ
	+CG4nG/vA2eHIcL+alPyiMZzM6QNEV7uIEmNjj0H4EYb3tKJmZ0WVD6FyqduK8fEaycoB/HSl8N
	953Kr2TdIqxCgnO6sr/aSTssbaFCPS8hcWxyEoc417pKBzaQQtR14sbIAF7/Z4JeuWZqJJ5v1FL
	cb6Qne5IIxthkqPTtIuKhjKNrOcpNag==
X-Google-Smtp-Source: AGHT+IHpiCBUCMk51gCHh0MtfplTpHuoevR+X1pym70rORy1/VwjergNCaIWjcfWI/AXB2zOywXNTQ==
X-Received: by 2002:a05:6602:15d2:b0:884:315d:e433 with SMTP id ca18e2360f4ac-8843e518482mr2057528439f.12.1755531097024;
        Mon, 18 Aug 2025 08:31:37 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-8843f7f811esm311279639f.2.2025.08.18.08.31.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Aug 2025 08:31:35 -0700 (PDT)
Message-ID: <393638fa-566a-4210-9f7e-79061de43bb4@kernel.dk>
Date: Mon, 18 Aug 2025 09:31:35 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: uring_cmd: add multishot support without poll
To: Ming Lei <ming.lei@redhat.com>, io-uring@vger.kernel.org,
 Pavel Begunkov <asml.silence@gmail.com>
Cc: Caleb Sander Mateos <csander@purestorage.com>
References: <20250810025024.1659190-1-ming.lei@redhat.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20250810025024.1659190-1-ming.lei@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/9/25 8:50 PM, Ming Lei wrote:
> Add UAPI flag IORING_URING_CMD_MULTISHOT for supporting naive multishot
> uring_cmd:
> 
> - for notifying userspace to handle event, typical use case is to notify
> userspace for handle device interrupt event, really generic use case
> 
> - needn't device to support poll() because the event may be originated
> from multiple source in device wide, such as multi queues
> 
> - add two APIs, io_uring_cmd_select_buffer() is for getting the provided
> group buffer, io_uring_mshot_cmd_post_cqe() is for post CQE after event
> data is pushed to the provided buffer
> 
> Follows one ublk use case:
> 
> https://github.com/ming1/linux/commits/ublk-devel/
> 
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>  include/linux/io_uring/cmd.h  | 27 +++++++++++++++
>  include/uapi/linux/io_uring.h |  9 ++++-
>  io_uring/opdef.c              |  1 +
>  io_uring/uring_cmd.c          | 64 ++++++++++++++++++++++++++++++++++-
>  4 files changed, 99 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
> index cfa6d0c0c322..5a72399bfa77 100644
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
> @@ -102,6 +118,17 @@ static inline void io_uring_cmd_mark_cancelable(struct io_uring_cmd *cmd,
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
> +static inline void io_uring_mshot_cmd_post_cqe(struct io_uring_cmd *ioucmd,
> +				ssize_t ret, unsigned int issue_flags)
> +{
> +}
>  #endif
>  
>  /*
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> index 6957dc539d83..e8afb4f5b56a 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -297,10 +297,17 @@ enum io_uring_op {
>  /*
>   * sqe->uring_cmd_flags		top 8bits aren't available for userspace
>   * IORING_URING_CMD_FIXED	use registered buffer; pass this flag
> + *				along with setting sqe->buf_index,
> + *				IORING_URING_CMD_MULTISHOT can't be set
> + *				at the same time
> + * IORING_URING_CMD_MULTISHOT	use buffer select; pass this flag
>   *				along with setting sqe->buf_index.
> + *				IORING_URING_CMD_FIXED can't be set
> + *				at the same time

This reads very confusingly, as if setting IORING_URING_CMD_MULTISHOT is
what decides this request selects a buffer. In practice, the rule is
that you MUST set IOSQE_BUFFER_SELECT, using IORING_URING_CMD_MULTISHOT
without that is invalid. So I think that just needs a bit of updating.
Something ala:

Must be used with buffer select, like other multishot commands. Not
compatible with IORING_URING_CMD_FIXED, for now.

> @@ -194,8 +195,20 @@ int io_uring_cmd_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>  	if (ioucmd->flags & ~IORING_URING_CMD_MASK)
>  		return -EINVAL;
>  
> -	if (ioucmd->flags & IORING_URING_CMD_FIXED)
> +	if ((ioucmd->flags & IORING_URING_CMD_FIXED) && (ioucmd->flags &
> +				IORING_URING_CMD_MULTISHOT))
> +		return -EINVAL;

I think the more idiomatic way to write that is:

	if ((ioucmd->flags & (IORING_URING_CMD_FIXED|IORING_URING_CMD_MULTISHOT) == (IORING_URING_CMD_FIXED|IORING_URING_CMD_MULTISHOT)

But since you have the separate checks below, why not do fold that check
into those instead? Eg in here:

> +	if (ioucmd->flags & IORING_URING_CMD_FIXED) {
> +		if (req->flags & REQ_F_BUFFER_SELECT)
> +			return -EINVAL;
>  		req->buf_index = READ_ONCE(sqe->buf_index);
> +	}
> +
> +	if (ioucmd->flags & IORING_URING_CMD_MULTISHOT) {
> +		if (!(req->flags & REQ_F_BUFFER_SELECT))
> +			return -EINVAL;
> +	}

each section can just check the other flag.

> @@ -251,6 +264,11 @@ int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags)
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

Missing recycle for -EAGAIN?

> @@ -333,3 +351,47 @@ bool io_uring_cmd_post_mshot_cqe32(struct io_uring_cmd *cmd,
>  		return false;
>  	return io_req_post_cqe32(req, cqe);
>  }
> +
> +int io_uring_cmd_select_buffer(struct io_uring_cmd *ioucmd,
> +			       unsigned buf_group,
> +			       void __user **buf, size_t *len,
> +			       unsigned int issue_flags)
> +{
> +	struct io_kiocb *req = cmd_to_io_kiocb(ioucmd);
> +	void __user *ubuf;
> +
> +	if (!(req->flags & REQ_F_BUFFER_SELECT))
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
> + * Should only be used from a task_work
> + *
> + */
> +bool io_uring_mshot_cmd_post_cqe(struct io_uring_cmd *ioucmd,
> +				 ssize_t ret, unsigned int issue_flags)
> +{
> +	struct io_kiocb *req = cmd_to_io_kiocb(ioucmd);
> +	unsigned int cflags = 0;
> +
> +	if (ret > 0) {
> +		cflags = io_put_kbuf(req, ret, issue_flags);
> +		if (io_req_post_cqe(req, ret, cflags | IORING_CQE_F_MORE))
> +			return false;
> +	}
> +
> +	io_req_set_res(req, ret, cflags);
> +	return true;
> +}
> +EXPORT_SYMBOL_GPL(io_uring_mshot_cmd_post_cqe);

Missing req_set_fail()?

-- 
Jens Axboe

