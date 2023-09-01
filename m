Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C88C4790303
	for <lists+io-uring@lfdr.de>; Fri,  1 Sep 2023 22:58:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229546AbjIAU6d (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 1 Sep 2023 16:58:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349004AbjIAU6b (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 1 Sep 2023 16:58:31 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52724173B
        for <io-uring@vger.kernel.org>; Fri,  1 Sep 2023 13:58:20 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 00C64211CE;
        Fri,  1 Sep 2023 20:58:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1693601899; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lMTfQ2cxFny6UGZ0lsNwQF1gnTFnhJYFVzas+IfeEDU=;
        b=pY/dmmOdLIj9YtTj2/XxPwwZdxqv3cuRCtBmYtRyjzHP7ZKuoeg+Qb6z1OZUpcSb4KYDkV
        0LOG5om325e7Z6pDvnyGMkD50XyuVtfy9EtDXFEPHkwGyuYOPJxSOFoOo+3Aa4ih6eU6EI
        vYImuhHIhJj6dcmC1e4in21kIMB9QHs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1693601899;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lMTfQ2cxFny6UGZ0lsNwQF1gnTFnhJYFVzas+IfeEDU=;
        b=BpvMrV8B9S6MgESz9GlxxvU6gW0t0uOuBlcC2wdycbU8haJUaJ8lbyPVKptVuE65gSd6nW
        ZqUo4j3Vk+x7U9BA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id B40CE13582;
        Fri,  1 Sep 2023 20:58:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id L3tNJmpQ8mReCQAAMHmgww
        (envelope-from <krisman@suse.de>); Fri, 01 Sep 2023 20:58:18 +0000
From:   Gabriel Krisman Bertazi <krisman@suse.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH] io_uring/fdinfo: only print ->sq_array[] if it's there
In-Reply-To: <6a715702-69e6-48a0-b278-5624d0c5c58d@kernel.dk> (Jens Axboe's
        message of "Fri, 1 Sep 2023 14:01:05 -0600")
References: <6a715702-69e6-48a0-b278-5624d0c5c58d@kernel.dk>
Date:   Fri, 01 Sep 2023 16:58:17 -0400
Message-ID: <87edjhbogm.fsf@suse.de>
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

Jens Axboe <axboe@kernel.dk> writes:

> If a ring is setup with IORING_SETUP_NO_SQARRAY, then we don't have
> the SQ array. Don't try to dump info from it through fdinfo if that
> is the case.
>
> Reported-by: syzbot+216e2ea6e0bf4a0acdd7@syzkaller.appspotmail.com
> Fixes: 2af89abda7d9 ("io_uring: add option to remove SQ indirection")
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>
> ---
>
> diff --git a/io_uring/fdinfo.c b/io_uring/fdinfo.c
> index 300455b4bc12..c53678875416 100644
> --- a/io_uring/fdinfo.c
> +++ b/io_uring/fdinfo.c
> @@ -93,6 +93,8 @@ __cold void io_uring_show_fdinfo(struct seq_file *m, struct file *f)
>  		struct io_uring_sqe *sqe;
>  		unsigned int sq_idx;
>  
> +		if (ctx->flags & IORING_SETUP_NO_SQARRAY)
> +			break;
>  		sq_idx = READ_ONCE(ctx->sq_array[entry & sq_mask]);
>  		if (sq_idx > sq_mask)
>  			continue;

Reviewed-by: Gabriel Krisman Bertazi <krisman@suse.de>


-- 
Gabriel Krisman Bertazi
