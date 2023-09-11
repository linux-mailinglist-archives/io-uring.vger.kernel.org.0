Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 972A779ACC0
	for <lists+io-uring@lfdr.de>; Tue, 12 Sep 2023 01:37:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242012AbjIKWKS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 11 Sep 2023 18:10:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242487AbjIKPmb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 11 Sep 2023 11:42:31 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BBC8127;
        Mon, 11 Sep 2023 08:42:26 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 952BA1F38D;
        Mon, 11 Sep 2023 15:42:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1694446944; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3xXDQka3gqHzTmbM91PUqKCNwVv5hIrQkTXz5vFWWz8=;
        b=orN+6SbhdVggei5E57EsUfJsiLKTfW08RYjOOVA2l8f5lm4UfC3hRJ+PgTzyTzumbZxOVf
        hw2/anP2YoMQmfbw/oEoIkjQAjkKyUlv1CCqvhF94l0asZBV7znF7pojvRbfmPrbNwvkMB
        yCzM3NajV41At+jdrDQo6tcy1auUN6Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1694446944;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3xXDQka3gqHzTmbM91PUqKCNwVv5hIrQkTXz5vFWWz8=;
        b=I5E+uNod2iDLygEjzr91eL5+LUNmI9G2s0LFeHtadKJI35gQJJK8PtD4iudTJn+PMwDkrg
        VR7P/MbAY4Au9YBw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 5DF3E13780;
        Mon, 11 Sep 2023 15:42:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id dO12EWA1/2Q9cQAAMHmgww
        (envelope-from <krisman@suse.de>); Mon, 11 Sep 2023 15:42:24 +0000
From:   Gabriel Krisman Bertazi <krisman@suse.de>
To:     Breno Leitao <leitao@debian.org>
Cc:     sdf@google.com, axboe@kernel.dk, asml.silence@gmail.com,
        willemdebruijn.kernel@gmail.com, kuba@kernel.org,
        martin.lau@linux.dev, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        io-uring@vger.kernel.org, pabeni@redhat.com
Subject: Re: [PATCH v5 3/8] io_uring/cmd: Pass compat mode in issue_flags
In-Reply-To: <20230911103407.1393149-4-leitao@debian.org> (Breno Leitao's
        message of "Mon, 11 Sep 2023 03:34:02 -0700")
Organization: SUSE
References: <20230911103407.1393149-1-leitao@debian.org>
        <20230911103407.1393149-4-leitao@debian.org>
Date:   Mon, 11 Sep 2023 11:42:23 -0400
Message-ID: <87v8cg90o0.fsf@suse.de>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Breno Leitao <leitao@debian.org> writes:

> Create a new flag to track if the operation is running compat mode.
> This basically check the context->compat and pass it to the issue_flags,
> so, it could be queried later in the callbacks.
>
> Signed-off-by: Breno Leitao <leitao@debian.org>

Reviewed-by: Gabriel Krisman Bertazi <krisman@suse.de>


> ---
>  include/linux/io_uring.h | 1 +
>  io_uring/uring_cmd.c     | 2 ++
>  2 files changed, 3 insertions(+)
>
> diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
> index 106cdc55ff3b..bc53b35966ed 100644
> --- a/include/linux/io_uring.h
> +++ b/include/linux/io_uring.h
> @@ -20,6 +20,7 @@ enum io_uring_cmd_flags {
>  	IO_URING_F_SQE128		= (1 << 8),
>  	IO_URING_F_CQE32		= (1 << 9),
>  	IO_URING_F_IOPOLL		= (1 << 10),
> +	IO_URING_F_COMPAT		= (1 << 11),
>  };
>  
>  struct io_uring_cmd {
> diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
> index 537795fddc87..60f843a357e0 100644
> --- a/io_uring/uring_cmd.c
> +++ b/io_uring/uring_cmd.c
> @@ -128,6 +128,8 @@ int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags)
>  		issue_flags |= IO_URING_F_SQE128;
>  	if (ctx->flags & IORING_SETUP_CQE32)
>  		issue_flags |= IO_URING_F_CQE32;
> +	if (ctx->compat)
> +		issue_flags |= IO_URING_F_COMPAT;
>  	if (ctx->flags & IORING_SETUP_IOPOLL) {
>  		if (!file->f_op->uring_cmd_iopoll)
>  			return -EOPNOTSUPP;

-- 
Gabriel Krisman Bertazi
