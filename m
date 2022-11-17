Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36E0462E563
	for <lists+io-uring@lfdr.de>; Thu, 17 Nov 2022 20:45:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234007AbiKQTpM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 17 Nov 2022 14:45:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234710AbiKQTpM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 17 Nov 2022 14:45:12 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 232FA87571
        for <io-uring@vger.kernel.org>; Thu, 17 Nov 2022 11:45:11 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 52AA621921;
        Thu, 17 Nov 2022 19:45:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1668714309; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NDaPeUx9EQCPAaJDsOlYHj6Ing0L3O816O783kommYk=;
        b=WsKF9pnu8T3/N671NiXsFac2Ad6Gt+8BmtP8k2DvQPKpAuF9UKF5fFFaWKWBFKO28xUsLM
        qVEFFgYMYoOY6rHOYxx7aSOBJgqRpIcrgmsH6L9UMqXu92YteGNae+iTI7g8B2yPgD2XEX
        oztFu6aZ3O7QTUl6XfwsQEZlmHSMryo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1668714309;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NDaPeUx9EQCPAaJDsOlYHj6Ing0L3O816O783kommYk=;
        b=dQM65QY/uPfKE5r5r6ZlaDMQQwyCVm+dTP45aQTsdR0dT6z8KVR7R1TWi6/MhndXcNHd0z
        26BOdD1gPyECxgCA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id C5A9213A12;
        Thu, 17 Nov 2022 19:45:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 9R+VH0SPdmNrAgAAMHmgww
        (envelope-from <krisman@suse.de>); Thu, 17 Nov 2022 19:45:08 +0000
From:   Gabriel Krisman Bertazi <krisman@suse.de>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] io_uring: kill tw-related outdated comments
References: <deb4db0984b07e026d08b7bd1886cfc120d67f17.1668710788.git.asml.silence@gmail.com>
Date:   Thu, 17 Nov 2022 14:45:04 -0500
In-Reply-To: <deb4db0984b07e026d08b7bd1886cfc120d67f17.1668710788.git.asml.silence@gmail.com>
        (Pavel Begunkov's message of "Thu, 17 Nov 2022 18:47:04 +0000")
Message-ID: <87r0y1wekf.fsf@suse.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Pavel Begunkov <asml.silence@gmail.com> writes:

> task_work fallback is executed from a workqueue, so current and
> req->task are not necessarily the same. It's still safe to poke into it
> as the request holds a task_struct reference.

Makes sense to me.  Feel free to add

Reviewed-by: Gabriel Krisman Bertazi <krisman@suse.de>

>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  io_uring/io_uring.c | 2 +-
>  io_uring/poll.c     | 1 -
>  2 files changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index 94329c1ce91d..5a8a43fb6750 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -1249,7 +1249,7 @@ static void io_req_task_cancel(struct io_kiocb *req, bool *locked)
>  void io_req_task_submit(struct io_kiocb *req, bool *locked)
>  {
>  	io_tw_lock(req->ctx, locked);
> -	/* req->task == current here, checking PF_EXITING is safe */
> +
>  	if (likely(!(req->task->flags & PF_EXITING)))
>  		io_queue_sqe(req);
>  	else
> diff --git a/io_uring/poll.c b/io_uring/poll.c
> index 2830b7daf952..5d4a0a4a379a 100644
> --- a/io_uring/poll.c
> +++ b/io_uring/poll.c
> @@ -214,7 +214,6 @@ static int io_poll_check_events(struct io_kiocb *req, bool *locked)
>  	struct io_ring_ctx *ctx = req->ctx;
>  	int v, ret;
>  
> -	/* req->task == current here, checking PF_EXITING is safe */
>  	if (unlikely(req->task->flags & PF_EXITING))
>  		return -ECANCELED;

-- 
Gabriel Krisman Bertazi
