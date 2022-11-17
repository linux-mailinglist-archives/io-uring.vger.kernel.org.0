Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A92B362E5F2
	for <lists+io-uring@lfdr.de>; Thu, 17 Nov 2022 21:32:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240645AbiKQUcz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 17 Nov 2022 15:32:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240658AbiKQUch (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 17 Nov 2022 15:32:37 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFF2213E12
        for <io-uring@vger.kernel.org>; Thu, 17 Nov 2022 12:31:31 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 0BE0E1F381;
        Thu, 17 Nov 2022 20:31:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1668717090; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=N7P/KrmC70wCuJdDFCr9km/PfpwfScdIbaq+b7wQ1qc=;
        b=T+vISyHT91dYMvTliyKyd86zrnxFRJ/5Q7XjkWfdm+6oyH32xjtqWt2WmioRoY8yFu9orc
        uG3sJ3C9NLbusLXNjNg4ZV8BTtjtKJ2YQDI/DTccvfmhyBELa2bM2WnE85wq7ZqXEJCwZZ
        ZsOHOzdOV1HAaOGU3YJ6UNCBDZtXbf0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1668717090;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=N7P/KrmC70wCuJdDFCr9km/PfpwfScdIbaq+b7wQ1qc=;
        b=y4h1zJBU2sGQSifyFAFryH3sdSdxJVDklnmtS6+jvyTm301pBLowSJI6z/NzFf0aj57gGp
        dKTpJ+i/GauXasBw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 83D6C13A12;
        Thu, 17 Nov 2022 20:31:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id TcBuEyGadmNNEgAAMHmgww
        (envelope-from <krisman@suse.de>); Thu, 17 Nov 2022 20:31:29 +0000
From:   Gabriel Krisman Bertazi <krisman@suse.de>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH for-6.1 1/4] io_uring: update res mask in
 io_poll_check_events
References: <cover.1668710222.git.asml.silence@gmail.com>
        <2dac97e8f691231049cb259c4ae57e79e40b537c.1668710222.git.asml.silence@gmail.com>
Date:   Thu, 17 Nov 2022 15:31:24 -0500
In-Reply-To: <2dac97e8f691231049cb259c4ae57e79e40b537c.1668710222.git.asml.silence@gmail.com>
        (Pavel Begunkov's message of "Thu, 17 Nov 2022 18:40:14 +0000")
Message-ID: <87iljdwcf7.fsf@suse.de>
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

> When io_poll_check_events() collides with someone attempting to queue a
> task work, it'll spin for one more time. However, it'll continue to use
> the mask from the first iteration instead of updating it. For example,
> if the first wake up was a EPOLLIN and the second EPOLLOUT, the
> userspace will not get EPOLLOUT in time.
>
> Clear the mask for all subsequent iterations to force vfs_poll().

Do we have a reproducer for it in liburing?  Either way, I checked the
code, it looks good to me.

Reviewed-by: Gabriel Krisman Bertazi <krisman@suse.de>

>
> Cc: stable@vger.kernel.org
> Fixes: aa43477b04025 ("io_uring: poll rework")
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  io_uring/poll.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/io_uring/poll.c b/io_uring/poll.c
> index f500506984ec..90920abf91ff 100644
> --- a/io_uring/poll.c
> +++ b/io_uring/poll.c
> @@ -258,6 +258,9 @@ static int io_poll_check_events(struct io_kiocb *req, bool *locked)
>  				return ret;
>  		}
>  
> +		/* force the next iteration to vfs_poll() */
> +		req->cqe.res = 0;
> +
>  		/*
>  		 * Release all references, retry if someone tried to restart
>  		 * task_work while we were executing it.

-- 
Gabriel Krisman Bertazi
