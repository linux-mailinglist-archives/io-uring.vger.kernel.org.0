Return-Path: <io-uring+bounces-5184-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 876C89E1D7F
	for <lists+io-uring@lfdr.de>; Tue,  3 Dec 2024 14:26:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id ED830B3DC6D
	for <lists+io-uring@lfdr.de>; Tue,  3 Dec 2024 13:23:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC354224F0;
	Tue,  3 Dec 2024 13:23:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UUvIawxD"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 060E31F12E2;
	Tue,  3 Dec 2024 13:23:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733232192; cv=none; b=jXgYLnDWMqKxwpvaRxcr0MQfpJSA6K5nuqWDNSUBtRjd2A9gpLCwQHM5u+lWbS14n7x0HjWsi/Ap8Ft0D0dV5KF/ZoW7WR6HrF8y8z9gBIUPzyPv0ULj5IAKpA+Yoz6rr0vyM27a+tLbfvck3t7nk9erc4ZeXL9JAEkmqkhXEIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733232192; c=relaxed/simple;
	bh=hVExwU4PI6GjUb13EsWe6DqP9a7hItKS8Csqx4fKfTQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HDsZX4VUMduJx5B0lsBiig7vMsY8yjA6HlrYdpunJw1pTdXGmwm46In2QO9esvFxeLYXW9YtVtV/X1pDZ2mfOfPwpFNvMlrHidhoJGqYpVc2zVQXL3fiX9riZ8oH6vndu9EWdJP4CkePC2dneN8pVRduBx4rOlsq/D+Q8rrD94o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UUvIawxD; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-aa51bf95ce1so275545466b.3;
        Tue, 03 Dec 2024 05:23:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733232189; x=1733836989; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gODcQrkU9DdcAnBdfMaXCqlqusA/WL/FIZhbiXwrlNA=;
        b=UUvIawxDco2lOLmTpiSS/Pa8mooVUeZr7ErapQeGXK8AOZe8ulyBxQMUHsgVIca2JC
         YEfHobh4CmH80cUoZhvWQgvpRLOccYwtyb1TrWr1RmE15Oxq6Dt+XvyQG98viVRO7+SG
         doETXeCCKSsO1j2pF+fdQa6WB15YJUKd4fIZc26CUU/z5hbyi3KgeArUdPVX5NXjdlhn
         4g63/altP22D1RQWmFcfK6pthItLpBNgIhde8ADCEnBS7P1qWRf9N6vKNyM+A9ewMI90
         m1NM62nA/xq6V/SP3mc26yxT1xLiv/AgdEoaLYNWznGqxMUN/mzSojAfbtdEWqjavVJa
         1nUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733232189; x=1733836989;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gODcQrkU9DdcAnBdfMaXCqlqusA/WL/FIZhbiXwrlNA=;
        b=OIl2KSCdMt5s1TC5XdywJhfoS4pQ+pod4hzPGVPrLkJ5T8nBIdYlIi/Qr6/67it/90
         5sQ6Tz4AyildnV5o3U8IXE+G8USOYzm0UESNW76QM4Xf8kCHtQ/B8BMQzHAEVNw1YRig
         OYY3norAv7e+nlpZOb6k2DqMvMJDGZc33wNVM80bVUSV4qzPi5kXwWeciszr+g9jGH6u
         eu8MShv3yiCR8jczyzuoJ6OPjmJEbxxv+RY46yym8F1IPkcS0pwJVczNGlbbjuj55afg
         sppgzD8K/QHzJx2ZkJ9b1o4JQAojkhRu+oBzpc0rFD+fb4Iz2kDjkN4DdK+yGttelwr5
         id9g==
X-Forwarded-Encrypted: i=1; AJvYcCUGFaJFFkeL7kstICg+w8mSoNU069B+O5vJf4ech1S5p7NnSSnxuEyRRwIgCgFEkWsQcVArptEPxQhusVlsJw==@vger.kernel.org, AJvYcCVAhAwItMNxKo/P6xHYOq8j+oHtSBMkBAsL59Cyq/hWahbRPTjBLWg/9cAO9//Zi5UMm/xfkvFKdw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxlUf/vNcmk2Q8fehkSwbVIMsiPJbnEF3gtYfz6VbgfDh7B0YAY
	RWfLf7QhPKJidiplUvRtozMqcPZ0YyuEW9yZq0ovnZRgzc3Hl34X
X-Gm-Gg: ASbGnctDX4pnGmEpXNLLFZH1g7cm4rKTfdDtyReN/HqWCfxi7cS90UVjb+SZjLyP+Sg
	5TAoxC1EHQnoYE+454a3+5kiuEyNaRsUJSM7FiaDJCxn6ACMcILK+rgamdldyxQzpYnOvfEJEuP
	ifmrKYzx0xfCQuPwvcf7XkVJuwVN6UAVKZs5jRJVZdhNHH5DAZIYxgaVyYgmQYzpIdQOw1w8ned
	en94l6n1NcfgwewSDiiYyQ0MNifFqUZvDCjJ3LtVyZvR7L9uKRzpYj9tcQk6g==
X-Google-Smtp-Source: AGHT+IEzZ3HQwzBFe9vOaNHJcNJOQfowGZGJPzTTaom7UJPW3dH59u6D8Mdn7GA5pyZDjBQgGXMK0g==
X-Received: by 2002:a17:907:aa2:b0:aa5:4ea6:fcae with SMTP id a640c23a62f3a-aa60181a7c3mr19843966b.28.1733232189153;
        Tue, 03 Dec 2024 05:23:09 -0800 (PST)
Received: from [192.168.42.149] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5d097dd617asm6081618a12.42.2024.12.03.05.23.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Dec 2024 05:23:08 -0800 (PST)
Message-ID: <42d5cd02-a1b9-4cd9-ae92-99bdcac65305@gmail.com>
Date: Tue, 3 Dec 2024 13:24:04 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v7 06/16] fuse: {uring} Handle SQEs - register
 commands
To: Bernd Schubert <bschubert@ddn.com>, Miklos Szeredi <miklos@szeredi.hu>
Cc: Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
 io-uring@vger.kernel.org, Joanne Koong <joannelkoong@gmail.com>,
 Josef Bacik <josef@toxicpanda.com>, Amir Goldstein <amir73il@gmail.com>,
 Ming Lei <tom.leiming@gmail.com>, David Wei <dw@davidwei.uk>,
 bernd@bsbernd.com
References: <20241127-fuse-uring-for-6-10-rfc4-v7-0-934b3a69baca@ddn.com>
 <20241127-fuse-uring-for-6-10-rfc4-v7-6-934b3a69baca@ddn.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20241127-fuse-uring-for-6-10-rfc4-v7-6-934b3a69baca@ddn.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/27/24 13:40, Bernd Schubert wrote:
> This adds basic support for ring SQEs (with opcode=IORING_OP_URING_CMD).
> For now only FUSE_URING_REQ_FETCH is handled to register queue entries.
> 
> Signed-off-by: Bernd Schubert <bschubert@ddn.com>
> ---
>   fs/fuse/Kconfig           |  12 ++
>   fs/fuse/Makefile          |   1 +
>   fs/fuse/dev.c             |   4 +
>   fs/fuse/dev_uring.c       | 318 ++++++++++++++++++++++++++++++++++++++++++++++
>   fs/fuse/dev_uring_i.h     | 115 +++++++++++++++++
>   fs/fuse/fuse_i.h          |   5 +
>   fs/fuse/inode.c           |  10 ++
>   include/uapi/linux/fuse.h |  67 ++++++++++
>   8 files changed, 532 insertions(+)
> 

  diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
> new file mode 100644
> index 0000000000000000000000000000000000000000..af9c5f116ba1dcf6c01d0359d1a06491c92c32f9
> --- /dev/null
> +++ b/fs/fuse/dev_uring.c
...
> +
> +/*
> + * fuse_uring_req_fetch command handling
> + */
> +static void _fuse_uring_fetch(struct fuse_ring_ent *ring_ent,
> +			      struct io_uring_cmd *cmd,
> +			      unsigned int issue_flags)
> +{
> +	struct fuse_ring_queue *queue = ring_ent->queue;
> +
> +	spin_lock(&queue->lock);
> +	fuse_uring_ent_avail(ring_ent, queue);
> +	ring_ent->cmd = cmd;
> +	spin_unlock(&queue->lock);
> +}
> +
> +/*
> + * sqe->addr is a ptr to an iovec array, iov[0] has the headers, iov[1]
> + * the payload
> + */
> +static int fuse_uring_get_iovec_from_sqe(const struct io_uring_sqe *sqe,
> +					 struct iovec iov[FUSE_URING_IOV_SEGS])
> +{
> +	struct iovec __user *uiov = u64_to_user_ptr(READ_ONCE(sqe->addr));
> +	struct iov_iter iter;
> +	ssize_t ret;
> +
> +	if (sqe->len != FUSE_URING_IOV_SEGS)
> +		return -EINVAL;
> +
> +	/*
> +	 * Direction for buffer access will actually be READ and WRITE,
> +	 * using write for the import should include READ access as well.
> +	 */
> +	ret = import_iovec(WRITE, uiov, FUSE_URING_IOV_SEGS,
> +			   FUSE_URING_IOV_SEGS, &iov, &iter);

You're throwing away the iterator, I'd be a bit cautious about it.
FUSE_URING_IOV_SEGS is 2, so it should avoid ITER_UBUF, but Jens
can say if it's abuse of the API or not.

Fwiw, it's not the first place I know of that just want to get
an iovec avoiding playing games with different iterator modes.


> +	if (ret < 0)
> +		return ret;
> +
> +	return 0;
> +}
> +
> +static int fuse_uring_fetch(struct io_uring_cmd *cmd, unsigned int issue_flags,
> +			    struct fuse_conn *fc)
> +{
> +	const struct fuse_uring_cmd_req *cmd_req = io_uring_sqe_cmd(cmd->sqe);

You need to check that the ring is setup with SQE128.

(!(issue_flags & IO_URING_F_SQE128))
	// fail

> +	struct fuse_ring *ring = fc->ring;
> +	struct fuse_ring_queue *queue;
> +	struct fuse_ring_ent *ring_ent;
> +	int err;
> +	struct iovec iov[FUSE_URING_IOV_SEGS];
> +
> +	err = fuse_uring_get_iovec_from_sqe(cmd->sqe, iov);
> +	if (err) {
> +		pr_info_ratelimited("Failed to get iovec from sqe, err=%d\n",
> +				    err);
> +		return err;
> +	}
> +
> +	err = -ENOMEM;
> +	if (!ring) {
> +		ring = fuse_uring_create(fc);
> +		if (!ring)
> +			return err;
> +	}
> +
> +	queue = ring->queues[cmd_req->qid];
> +	if (!queue) {
> +		queue = fuse_uring_create_queue(ring, cmd_req->qid);
> +		if (!queue)
> +			return err;
> +	}
> +
> +	/*
> +	 * The created queue above does not need to be destructed in
> +	 * case of entry errors below, will be done at ring destruction time.
> +	 */
> +
> +	ring_ent = kzalloc(sizeof(*ring_ent), GFP_KERNEL_ACCOUNT);
> +	if (ring_ent == NULL)
> +		return err;
> +
> +	INIT_LIST_HEAD(&ring_ent->list);
> +
> +	ring_ent->queue = queue;
> +	ring_ent->cmd = cmd;

nit: seems it's also set immediately after in
_fuse_uring_fetch().

> +
> +	err = -EINVAL;
> +	if (iov[0].iov_len < sizeof(struct fuse_uring_req_header)) {
> +		pr_info_ratelimited("Invalid header len %zu\n", iov[0].iov_len);
> +		goto err;
> +	}
> +
...
> +/*
> + * Entry function from io_uring to handle the given passthrough command
> + * (op cocde IORING_OP_URING_CMD)
> + */
> +int fuse_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
> +{
> +	struct fuse_dev *fud;
> +	struct fuse_conn *fc;
> +	u32 cmd_op = cmd->cmd_op;
> +	int err;
> +
> +	/* Disabled for now, especially as teardown is not implemented yet */
> +	pr_info_ratelimited("fuse-io-uring is not enabled yet\n");
> +	return -EOPNOTSUPP;

Do compilers give warnings about such things? Unreachable code, maybe.
I don't care much, but if they do to avoid breaking CONFIG_WERROR you
might want to do sth about it. E.g. I'd usually mark the function
__maybe_unused and not set it into fops until a later patch.

...
-- 
Pavel Begunkov


