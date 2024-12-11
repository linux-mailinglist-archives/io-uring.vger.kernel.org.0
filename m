Return-Path: <io-uring+bounces-5437-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F3D469ECD67
	for <lists+io-uring@lfdr.de>; Wed, 11 Dec 2024 14:38:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 61132169FFB
	for <lists+io-uring@lfdr.de>; Wed, 11 Dec 2024 13:38:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7B56233696;
	Wed, 11 Dec 2024 13:36:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="brIUU4ZL"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F027232378
	for <io-uring@vger.kernel.org>; Wed, 11 Dec 2024 13:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733924214; cv=none; b=SCjrD/SnnYAHRubvlNzgHpSCv5xwxkVdYq5X4ogmVxBTc9xj2pZW794UV4ZBk0jiViLOtmMs9ltaJy6JNPJp4HO9nI6EMpLHYrmKUIHpBJ1aamAUE109BUaI+ZaK+kQ7oD2xtO50dmvTAicZBy98Gb/fbzv0c53GFEQDSaV4fqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733924214; c=relaxed/simple;
	bh=DEB7dhomxzBwDMea+vamRBSN1Gzcizrwi3kQeZCBMXU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KhqY2fbqfSoq4Us+TCgXfC563vbFPmMDhkxmi/g+AS8JPCBdqTmJV6ij/ZZd99+c/4/n0WmXbegdoBOkKohW/Xmf0+foopMTsWFeKtktQeyXitTgXHpyUJVxPvGt/TIOU1YsgEMEH4mXEQcqxoX0kMCRFhwiuGbCxtUwQLQbvWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=brIUU4ZL; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-aa684b6d9c7so620489366b.2
        for <io-uring@vger.kernel.org>; Wed, 11 Dec 2024 05:36:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733924211; x=1734529011; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0+NlZN56m1qf1JVFw0KlDneHuQgvHWFZ9+MFtWBsLyU=;
        b=brIUU4ZLWLRZvWuLbCncSgIE99ZQd/CM+VibIkk97/hjAZJ4sKP3f5KsiGMByrz4Fx
         Du9UZ+EyZTdnDGlCGOCkqvhnNpNNoos2Ng/Oy7xZJ/uIPaOEpnTjH9rs1dYQa3MtPCv2
         aQI0d+TaCUm58yUukg+B5Hs+A9a5WK0e/JM2Xmut1ljIH9JXsBAVUH7miKwgGTUJ38GQ
         ZhPyxCl4yk5+/4DLHPnMbygsRzddnFznzIL/uO+qOH1v3vbrZ8c/DPwrzUAfhvhA5SLm
         mWH9w+uH2mvHKxVDWwwJcQBgKuOwx4tuYxzx+4Xf1J82rns7DvNVQ4X4bkG2rt3Z1XAC
         bztA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733924211; x=1734529011;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0+NlZN56m1qf1JVFw0KlDneHuQgvHWFZ9+MFtWBsLyU=;
        b=ccXHROjTIU1Xh4+QAys/8TdNsqmNXR7UAnYyeGt8W9y1FW6+Dsoub+SyFNv750JfBu
         Ri+ooAO/jEUV+nf0aLNGW5lbh7XxRvvMyXUMXGn9FFulCYuBUYSB/zfnJA2NFr88hC//
         24QJM3G3CX55pBjpY6Bcy4QgILzDBC0UaseLz96UHNW9lRs6K7ZnSmyOpruMBzXRIrDo
         wKCJncFzswdrw2sXbc+mOZS3WXZIuBYz/4aZvoh45PYrJjocJguu2tAPXPILwo8F4Ubl
         8YE1fJ+UzldedbFN66iU/H+A9o3WZeHmPE7xpnlfYXp2wy0gINsReqCXgSG3IxAeiQDj
         ZnSA==
X-Gm-Message-State: AOJu0YwTpu/FBtTI/xXtim4hqsdyzbSLbQSVAnikhmJNAkSlZ8tv2t6Z
	NpGGchdb2RRnm4jU7Thud4nSJMkCRFIknfpIRmzslsUeaVEWmeyex5ZQjg==
X-Gm-Gg: ASbGncuYLJw+7X3vmn8h5E62VwAPx1hApPKGFTGcC3jQXnOuWCA0CVvw5FEJCa+6z3T
	X64+ieVktqFNm5IRBfPMA+KTEVeglipOWcMt/MDx7RiE6wS/2QtokNzIuI93ws+Dla77ezzMXnR
	Z7lDwdMIGPiEj2mXUH2qvioORD7p9AD6MTk1Y6JAvkNUElGseBL57zE+DiPzXFvoTdjeAiAjAGB
	XRLIigHEo6h8zJTj7unHnkRMSA3sMhNXbksR6JEn19zpoA114bbCihKL5oqS/e5bg==
X-Google-Smtp-Source: AGHT+IHbeA0YWNEzUWY4D2Q51YHwB0YqEv+D1yP+QCBdI/anGPYp4wGea0sxO0dBaoaRv3lXXiyiKQ==
X-Received: by 2002:a17:906:3caa:b0:aa6:6ee6:1b7f with SMTP id a640c23a62f3a-aa6b11e483emr281876666b.33.1733924210533;
        Wed, 11 Dec 2024 05:36:50 -0800 (PST)
Received: from [192.168.42.162] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa6975b1f27sm370616366b.113.2024.12.11.05.36.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Dec 2024 05:36:49 -0800 (PST)
Message-ID: <4100233a-a715-4c62-89e4-ab1054f97fce@gmail.com>
Date: Wed, 11 Dec 2024 13:37:40 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 7/9] io_uring: Introduce IORING_OP_CLONE
To: Gabriel Krisman Bertazi <krisman@suse.de>, axboe@kernel.dk
Cc: io-uring@vger.kernel.org, josh@joshtriplett.org
References: <20241209234316.4132786-1-krisman@suse.de>
 <20241209234316.4132786-8-krisman@suse.de>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20241209234316.4132786-8-krisman@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 12/9/24 23:43, Gabriel Krisman Bertazi wrote:
> From: Josh Triplett <josh@joshtriplett.org>
> 
> This command spawns a short lived asynchronous context to execute
> following linked operations.  Once the link is completed, the task
> terminates.  This is specially useful to create new processes, by
> linking an IORING_OP_EXEC at the end of the chain. In this case, the
> task doesn't terminate, but returns to userspace, starting the new
> process.
> 
> This is different from the existing io workqueues in a few ways: First,
> it is completely separated from the io-wq code, and the task cannot be
> reused by a future link; Second, the task doesn't share the FDT, and
> other process structures with the rest of io_uring (except for the
> memory map); Finally, because of the limited context, it doesn't support
> executing requests asynchronously and requeing them. Every request must
> complete at ->issue time, or fail.  It also doesn't support task_work
> execution, for a similar reason.  The goal of this design allowing the
> user to close file descriptors, release locks and do other cleanups
> right before switching to a new process.
> 
> A big pitfall here, in my (Gabriel) opinion, is how this duplicates the
> logic of io_uring linked request dispatching.  I'd suggest I merge this
> into the io-wq code, as a special case of workqueue. But I'd like to get
> feedback on this idea from the maintainers before moving further with the
> implementation.
> 
> Signed-off-by: Josh Triplett <josh@joshtriplett.org>
> Co-developed-by: Gabriel Krisman Bertazi <krisman@suse.de>
> Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
> ---
...
> +static int io_uring_spawn_task(void *data)
> +{
> +	struct io_kiocb *head = data;
> +	struct io_clone *c = io_kiocb_to_cmd(head, struct io_clone);
> +	struct io_ring_ctx *ctx = head->ctx;
> +	struct io_kiocb *req, *next;
> +	int err;
> +
> +	set_task_comm(current, "iou-spawn");
> +
> +	mutex_lock(&ctx->uring_lock);
> +
> +	for (req = c->link; req; req = next) {
> +		int hardlink = req->flags & REQ_F_HARDLINK;
> +
> +		next = req->link;
> +		req->link = NULL;
> +		req->flags &= ~(REQ_F_HARDLINK | REQ_F_LINK);

Do you allow linked timeouts? If so, it'd need to take the lock.

Also, the current link impl assumes that the list only modified
when all refs to the head request are put, you can't just do it
without dropping refs first or adjusting the rest of core link
handling.

> +
> +		if (!(req->flags & REQ_F_FAIL)) {
> +			err = io_issue_sqe(req, IO_URING_F_COMPLETE_DEFER);

There should never be non IO_URING_F_NONBLOCK calls with ->uring_lock.

I'd even say that opcode handling shouldn't have any business with
digging so deep into internal infra, submitting requests, flushing
caches, processing links and so on. It complicates things.

Take defer taskrun, io_submit_flush_completions() will not wake
waiters, and we probably have or will have a bunch of optimisations
that it can break.

Also, do you block somewhere all other opcodes? If it's indeed
an under initialised task then it's not safe to run most of them,
and you'd never know in what way, unfortunately. An fs write
might need a net namespace, a send/recv might decide to touch
fs_struct and so on.

> +			/*
> +			 * We can't requeue a request from the spawn
> +			 * context.  Fail the whole chain.
> +			 */
> +			if (err) {
> +				req_fail_link_node(req, -ECANCELED);
> +				io_req_complete_defer(req);
> +			}
> +		}
> +		if (req->flags & REQ_F_FAIL) {
> +			if (!hardlink) {
> +				fail_link(next);
> +				break;
> +			}
> +		}
> +	}
> +
> +	io_submit_flush_completions(ctx);

Ordering with

> +	percpu_ref_put(&ctx->refs);
> +
> +	mutex_unlock(&ctx->uring_lock);
> +
> +	force_exit_sig(SIGKILL);
> +	return 0;
> +}
> +
> +int io_clone_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
> +{
> +	if (unlikely(sqe->fd || sqe->ioprio || sqe->addr2 || sqe->addr
> +		     || sqe->len || sqe->rw_flags || sqe->buf_index
> +		     || sqe->optlen || sqe->addr3))
> +		return -EINVAL;
> +
> +	if (unlikely(!(req->flags & (REQ_F_HARDLINK|REQ_F_LINK))))
> +		return -EINVAL;
> +
> +	if (unlikely(req->ctx->submit_state.link.head))
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +
> +int io_clone(struct io_kiocb *req, unsigned int issue_flags)
> +{
> +	struct io_clone *c = io_kiocb_to_cmd(req, struct io_clone);
> +	struct task_struct *tsk;
> +
> +	/* It is possible that we don't have any linked requests, depite
> +	 * checking during ->prep().  It would be harmless to continue,
> +	 * but we don't need even to create the worker thread in this
> +	 * case.
> +	 */
> +	if (!req->link)
> +		return IOU_OK;
> +
> +	/*
> +	 * Prevent the context from going away before the spawned task
> +	 * has had a chance to execute.  Dropped by io_uring_spawn_task.
> +	 */
> +	percpu_ref_get(&req->ctx->refs);
> +
> +	tsk = create_io_uring_spawn_task(io_uring_spawn_task, req);
> +	if (IS_ERR(tsk)) {
> +		percpu_ref_put(&req->ctx->refs);
> +
> +		req_set_fail(req);
> +		io_req_set_res(req, PTR_ERR(tsk), 0);
> +		return PTR_ERR(tsk);
> +	}
> +
> +	/*
> +	 * Steal the link from the io_uring dispatcher to have them
> +	 * submitted through the new thread.  Note we can no longer fail
> +	 * the clone, so the spawned task is responsible for completing
> +	 * these requests.
> +	 */
> +	c->link = req->link;
> +	req->flags &= ~(REQ_F_HARDLINK | REQ_F_LINK);
> +	req->link = NULL;
> +
> +	wake_up_new_task(tsk);

I assume from here onwards io_uring_spawn_task() might be
running in parallel. You're passing the req inside but free
it below by returning OK. Is there anything that prevents
io_uring_spawn_task() from accessing an already deallocated
request?

> +
> +	return IOU_OK;
> +
> +}
> diff --git a/io_uring/spawn.h b/io_uring/spawn.h
> new file mode 100644
> index 000000000000..9b7ddb776d1e
> --- /dev/null
> +++ b/io_uring/spawn.h
> @@ -0,0 +1,10 @@
> +/* SPDX-License-Identifier: GPL-2.0-or-later */
> +
> +/*
> + * Spawning a linked series of operations onto a dedicated task.
> + *
> + * Copyright © 2022 Josh Triplett
> + */
> +
> +int io_clone_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
> +int io_clone(struct io_kiocb *req, unsigned int issue_flags);

-- 
Pavel Begunkov


