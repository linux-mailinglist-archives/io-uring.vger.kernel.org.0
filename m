Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B4437AB457
	for <lists+io-uring@lfdr.de>; Fri, 22 Sep 2023 17:03:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231912AbjIVPDE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 22 Sep 2023 11:03:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232752AbjIVPCz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 22 Sep 2023 11:02:55 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 321961B2
        for <io-uring@vger.kernel.org>; Fri, 22 Sep 2023 08:02:47 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id ca18e2360f4ac-79f8df47bfbso22959139f.0
        for <io-uring@vger.kernel.org>; Fri, 22 Sep 2023 08:02:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1695394966; x=1695999766; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/cn7RDtLNgUaHq/0FZFee9i4NEbPVgV5BQ8Kyxa83oU=;
        b=xSZhwlZAC1/2xqE5DiaBmfO2N0+oE8osZoG5Rs2QqFiOx9yL+1EbJcpkD7zdzF4X3Y
         xW+DuUZmyui0VlH/u3FkcEfHs/td5YcMkaS6m6GtcQ5Go4K7QT42S56nDnwcmN3wnYlV
         iCu1oAGYSSiv1tgszCccjRxOBRAhtyU3v7LtjGdSTa1VF+RU8hmMAXovo0EuZshHlnRW
         5Ah7bIPQKpB98jxBaiSVu/l0RYxaiuonR3LobCOJoYHwD+upy/KOtk2nspmQjRiVXbLa
         qh3LjCiRVFFkyf2lyieRqlQJgyHw6fEzdGghpSBO0vYs7C74nnNTJejKCW2Iz48t9a4k
         wGQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695394966; x=1695999766;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/cn7RDtLNgUaHq/0FZFee9i4NEbPVgV5BQ8Kyxa83oU=;
        b=uNg08LKrcBArN5t0+MwS36xQUk6D2spx+ZXPPn2yriWY6VQsDjGeurxMoF6PBZqF5J
         GtdCYmBmvB+MihXwDpm2yAYJwnvq/J936p6Fgfe4s70hjQ3eLBiPQPXIMUfCCA4iB2yF
         JDGjdwAVt8JGjPxik/nnooBU+vKfsiIfuRNr2M+o4D+abvtrYwD+1U5NEYYtAdOatJza
         1iB0XJNZ28PC5x9p0rUO3KQ0Cn2/PSmE8ZSjpq/T0vib60jzVbAk00lqIMETIiqxeDWT
         KNK4HgCZwzYRxqWbuL7Gnq5yd2eAniNY/O9vLv9491vymzaUrhQzgU+6O6222A7WdQko
         megg==
X-Gm-Message-State: AOJu0YzVLJtx6abRkf5NVtMduJGBIj/J1pkhKknB3uryfrboPZdNJ+2z
        8FXU+0eomAXlfRqQUqGdLhLJ2nz2dcbZUj7KwtPzGw==
X-Google-Smtp-Source: AGHT+IH9YBVYfKzbwmPqnGwaAg56JduU0sVatzr2iErJldbRrRFe0IfddYWhSdtlcaoOZbXucr4eFg==
X-Received: by 2002:a92:d903:0:b0:350:f353:4017 with SMTP id s3-20020a92d903000000b00350f3534017mr8870617iln.0.1695394966426;
        Fri, 22 Sep 2023 08:02:46 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id t13-20020a02ccad000000b0042b4e2fc546sm1041947jap.140.2023.09.22.08.02.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Sep 2023 08:02:45 -0700 (PDT)
Message-ID: <dcdc42db-b3ac-4e91-b318-fb782aa9563e@kernel.dk>
Date:   Fri, 22 Sep 2023 09:02:44 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2] io_uring: cancelable uring_cmd
Content-Language: en-US
To:     Ming Lei <ming.lei@redhat.com>, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org
Cc:     Gabriel Krisman Bertazi <krisman@suse.de>
References: <20230922142816.2784777-1-ming.lei@redhat.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230922142816.2784777-1-ming.lei@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/22/23 8:28 AM, Ming Lei wrote:
> uring_cmd may never complete, such as ublk, in which uring cmd isn't
> completed until one new block request is coming from ublk block device.
> 
> Add cancelable uring_cmd to provide mechanism to driver for cancelling
> pending commands in its own way.
> 
> Add API of io_uring_cmd_mark_cancelable() for driver to mark one command as
> cancelable, then io_uring will cancel this command in
> io_uring_cancel_generic(). ->uring_cmd() callback is reused for canceling
> command in driver's way, then driver gets notified with the cancelling
> from io_uring.
> 
> Add API of io_uring_cmd_get_task() to help driver cancel handler
> deal with the canceling.

This looks better, a few comments:

> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> index 8e61f8b7c2ce..29a7a7e71f57 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -249,10 +249,13 @@ enum io_uring_op {
>   * sqe->uring_cmd_flags
>   * IORING_URING_CMD_FIXED	use registered buffer; pass this flag
>   *				along with setting sqe->buf_index.
> + * IORING_URING_CANCELABLE	not for userspace
>   * IORING_URING_CMD_POLLED	driver use only
>   */
> -#define IORING_URING_CMD_FIXED	(1U << 0)
> -#define IORING_URING_CMD_POLLED	(1U << 31)
> +#define IORING_URING_CMD_FIXED		(1U << 0)
> +/* set by driver, and handled by io_uring to cancel this cmd */
> +#define IORING_URING_CMD_CANCELABLE	(1U << 30)
> +#define IORING_URING_CMD_POLLED		(1U << 31)

If IORING_URING_CANCELABLE isn't UAPI, why stuff it in here? Should we
have a split where we retain the upper 8 bits for internal use, or
something like that?

> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index 783ed0fff71b..a3135fd47a4e 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -3256,6 +3256,40 @@ static __cold bool io_uring_try_cancel_iowq(struct io_ring_ctx *ctx)
>  	return ret;
>  }
>  
> +static bool io_uring_try_cancel_uring_cmd(struct io_ring_ctx *ctx,
> +		struct task_struct *task, bool cancel_all)
> +{
> +	struct hlist_node *tmp;
> +	struct io_kiocb *req;
> +	bool ret = false;
> +
> +	mutex_lock(&ctx->uring_lock);
> +	hlist_for_each_entry_safe(req, tmp, &ctx->cancelable_uring_cmd,
> +			hash_node) {
> +		struct io_uring_cmd *cmd = io_kiocb_to_cmd(req,
> +				struct io_uring_cmd);
> +		struct file *file = req->file;
> +
> +		if (WARN_ON_ONCE(!file->f_op->uring_cmd))
> +			continue;
> +
> +		if (!cancel_all && req->task != task)
> +			continue;
> +
> +		if (cmd->flags & IORING_URING_CMD_CANCELABLE) {
> +			/* ->sqe isn't available if no async data */
> +			if (!req_has_async_data(req))
> +				cmd->sqe = NULL;
> +			file->f_op->uring_cmd(cmd, IO_URING_F_CANCEL);
> +			ret = true;
> +		}
> +	}
> +	io_submit_flush_completions(ctx);
> +	mutex_unlock(&ctx->uring_lock);
> +
> +	return ret;
> +}

I think it'd be saner to drop uring_lock here, and then:

> @@ -3307,6 +3341,7 @@ static __cold bool io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
>  	ret |= io_kill_timeouts(ctx, task, cancel_all);
>  	if (task)
>  		ret |= io_run_task_work() > 0;
> +	ret |= io_uring_try_cancel_uring_cmd(ctx, task, cancel_all);
>  	return ret;
>  }

move this hunk into the uring_lock section. Also ensure that we do run
task_work for cancelation, should the uring_cmd side require that
(either now or eventually).

> diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
> index 537795fddc87..d6b200a0be33 100644
> --- a/io_uring/uring_cmd.c
> +++ b/io_uring/uring_cmd.c
> @@ -13,6 +13,52 @@
>  #include "rsrc.h"
>  #include "uring_cmd.h"
>  
> +static void io_uring_cmd_del_cancelable(struct io_uring_cmd *cmd,
> +		unsigned int issue_flags)
> +{
> +	if (cmd->flags & IORING_URING_CMD_CANCELABLE) {
> +		struct io_kiocb *req = cmd_to_io_kiocb(cmd);
> +		struct io_ring_ctx *ctx = req->ctx;
> +
> +		io_ring_submit_lock(ctx, issue_flags);
> +		cmd->flags &= ~IORING_URING_CMD_CANCELABLE;
> +		hlist_del(&req->hash_node);
> +		io_ring_submit_unlock(ctx, issue_flags);
> +	}
> +}

static void io_uring_cmd_del_cancelable(struct io_uring_cmd *cmd,
		unsigned int issue_flags)
{
	struct io_kiocb *req = cmd_to_io_kiocb(cmd);
	struct io_ring_ctx *ctx = req->ctx;

	if (!(cmd->flags & IORING_URING_CMD_CANCELABLE))
		return;

	io_ring_submit_lock(ctx, issue_flags);
	cmd->flags &= ~IORING_URING_CMD_CANCELABLE;
	hlist_del(&req->hash_node);
	io_ring_submit_unlock(ctx, issue_flags);
}

is cleaner imho. Minor nit.

> +
> +/*
> + * Mark this command as concelable, then io_uring_try_cancel_uring_cmd()
> + * will try to cancel this issued command by sending ->uring_cmd() with
> + * issue_flags of IO_URING_F_CANCEL.
> + *
> + * The command is guaranteed to not be done when calling ->uring_cmd()
> + * with IO_URING_F_CANCEL, but it is driver's responsibility to deal
> + * with race between io_uring canceling and normal completion.
> + */
> +int io_uring_cmd_mark_cancelable(struct io_uring_cmd *cmd,
> +		unsigned int issue_flags)
> +{
> +	struct io_kiocb *req = cmd_to_io_kiocb(cmd);
> +	struct io_ring_ctx *ctx = req->ctx;
> +
> +	io_ring_submit_lock(ctx, issue_flags);
> +	if (!(cmd->flags & IORING_URING_CMD_CANCELABLE)) {
> +		cmd->flags |= IORING_URING_CMD_CANCELABLE;
> +		hlist_add_head(&req->hash_node, &ctx->cancelable_uring_cmd);
> +	}
> +	io_ring_submit_unlock(ctx, issue_flags);
> +
> +	return 0;
> +}

A bit inconsistent here in terms of the locking. I'm assuming the
marking happens within issue, in which case it should be fine to do:

int io_uring_cmd_mark_cancelable(struct io_uring_cmd *cmd,
		unsigned int issue_flags)
{
	struct io_kiocb *req = cmd_to_io_kiocb(cmd);
	struct io_ring_ctx *ctx = req->ctx;

	if (!(cmd->flags & IORING_URING_CMD_CANCELABLE)) {
		cmd->flags |= IORING_URING_CMD_CANCELABLE;
		io_ring_submit_lock(ctx, issue_flags);
		hlist_add_head(&req->hash_node, &ctx->cancelable_uring_cmd);
		io_ring_submit_unlock(ctx, issue_flags);
	}

	return 0;
}

-- 
Jens Axboe

