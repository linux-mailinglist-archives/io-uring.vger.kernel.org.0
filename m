Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAD047A9A9E
	for <lists+io-uring@lfdr.de>; Thu, 21 Sep 2023 20:46:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229508AbjIUSqn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 21 Sep 2023 14:46:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbjIUSqm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 21 Sep 2023 14:46:42 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22912EE808;
        Thu, 21 Sep 2023 11:46:34 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id CCDB8218FC;
        Thu, 21 Sep 2023 18:46:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1695321992; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UOeRcNA6z4fQ4wZ/y9y2/tuq46PWNNqvjziVWS+zisg=;
        b=lEU121qIwPtgg66osXBkWjt2yg6FMzT36F9Mfvs3PYqSqhA73YAkBLD34q9mzmfn4GAV3j
        Zxrz+WsfZ/nDx3DngL+2m+hS4INh64Mn4mRCTHMhAZ+lGiKbVfOqH6pn/x8RmmfSegXq15
        k+MXQRLAoq/HfPF4+Z1Oc6TllDiATtY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1695321992;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UOeRcNA6z4fQ4wZ/y9y2/tuq46PWNNqvjziVWS+zisg=;
        b=oWeTtrg04IMG8eMriDRFA0OJbQKmvGgNl7nPxJAkn8bAgsztvSLT2m4DKOZ8hNVobFfm3Z
        wSbz0kXQacoephAQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 9734E13513;
        Thu, 21 Sep 2023 18:46:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id l88gH4iPDGW0XQAAMHmgww
        (envelope-from <krisman@suse.de>); Thu, 21 Sep 2023 18:46:32 +0000
From:   Gabriel Krisman Bertazi <krisman@suse.de>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org
Subject: Re: [PATCH] io_uring: cancelable uring_cmd
In-Reply-To: <20230921042434.2500190-1-ming.lei@redhat.com> (Ming Lei's
        message of "Thu, 21 Sep 2023 12:24:34 +0800")
References: <20230921042434.2500190-1-ming.lei@redhat.com>
Date:   Thu, 21 Sep 2023 14:46:31 -0400
Message-ID: <878r8znz3s.fsf@suse.de>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Ming Lei <ming.lei@redhat.com> writes:

> uring_cmd may never complete, such as ublk, in which uring cmd isn't
> completed until one new block request is coming from ublk block device.
>
> Add cancelable uring_cmd to provide mechanism to driver to cancel
> pending commands in its own way.
>
> Add API of io_uring_cmd_mark_cancelable() for driver to mark one
> command as cancelable, then io_uring will cancel this command in
> io_uring_cancel_generic(). Driver callback is provided for canceling
> command in driver's way, meantime driver gets notified with exiting of
> io_uring task or context.
>
> Suggested-by: Jens Axboe <axboe@kernel.dk>
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>
> ublk patches:
>
> 	https://github.com/ming1/linux/commits/uring_exit_and_ublk
>
>  include/linux/io_uring.h       | 22 +++++++++++++++++-
>  include/linux/io_uring_types.h |  6 +++++
>  include/uapi/linux/io_uring.h  |  7 ++++--
>  io_uring/io_uring.c            | 30 ++++++++++++++++++++++++
>  io_uring/uring_cmd.c           | 42 ++++++++++++++++++++++++++++++++++
>  5 files changed, 104 insertions(+), 3 deletions(-)
>
> diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
> index 106cdc55ff3b..5b98308a154f 100644
> --- a/include/linux/io_uring.h
> +++ b/include/linux/io_uring.h
> @@ -22,6 +22,9 @@ enum io_uring_cmd_flags {
>  	IO_URING_F_IOPOLL		= (1 << 10),
>  };
>  
> +typedef void (uring_cmd_cancel_fn)(struct io_uring_cmd *,
> +		unsigned int issue_flags, struct task_struct *task);
> +

Hi Ming,

I wonder if uring_cmd_cancel shouldn't just be a new file operation, pairing
with f_op->uring_cmd.  it would, of course, also mean don't need to pass
it here occupying the pdu or explicitly registering it. iiuc, would also
allow you to drop the flag and just assume it is cancelable if the operation
exists, further simplifying the code.

> +static bool io_uring_try_cancel_uring_cmd(struct io_ring_ctx *ctx,
> +					  struct task_struct *task,
> +					  bool cancel_all)
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
> +
> +		if (!cancel_all && req->task != task)
> +			continue;
> +
> +		/* safe to call ->cancel_fn() since cmd isn't done yet */
> +		if (cmd->flags & IORING_URING_CMD_CANCELABLE) {
> +			cmd->cancel_fn(cmd, 0, task);

I find it weird to pass task here.  Also, it seems you use it only to
sanity check it is the same as ubq->ubq_daemon.  Can you just recover it
from cmd_to_io_kiocb(cmd)->task? it should be guaranteed to be the same
as task by the check immediately before.

Thanks,

-- 
Gabriel Krisman Bertazi
