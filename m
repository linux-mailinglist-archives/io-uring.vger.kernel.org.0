Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7637969CF86
	for <lists+io-uring@lfdr.de>; Mon, 20 Feb 2023 15:37:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231806AbjBTOh2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 20 Feb 2023 09:37:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231782AbjBTOh2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 20 Feb 2023 09:37:28 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35531CDD4
        for <io-uring@vger.kernel.org>; Mon, 20 Feb 2023 06:37:27 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 68193226C0;
        Mon, 20 Feb 2023 14:37:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1676903845; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/C61YAdZhdruz6ZGYHgJMdBBtcdpjrNQqMPvTuhS6bw=;
        b=o07b6UQyB/Lv0JCaYiXPU0D5+JF+shzZFqW4fbJ27WJwHU1OwLf1Y3w5HTG7Pod9pj9G/b
        ID6CsxOH54uRr3pk28rM4VOGfLgLYcLA6x0CeFjQvoiNfN2S3lWL/L5T6VsHTykWoZxAmR
        7kLhVVmHnpnWpsnrbPG8j42z+F3C/FM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1676903845;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/C61YAdZhdruz6ZGYHgJMdBBtcdpjrNQqMPvTuhS6bw=;
        b=ihif+NE0+9ev1yvoG9Z1D9BHiNds17gNdiU23erC6ZPVLY+N9QsvnrcLHMNAKwCM1PO474
        Lf3RF6Ac03SMmODw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id E6D74139DB;
        Mon, 20 Feb 2023 14:37:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id Cc9eK6SF82OhOAAAMHmgww
        (envelope-from <krisman@suse.de>); Mon, 20 Feb 2023 14:37:24 +0000
From:   Gabriel Krisman Bertazi <krisman@suse.de>
To:     Wojciech Lukowicz <wlukowicz01@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: Re: [PATCH] io_uring: fix size calculation when registering buf ring
References: <20230218184141.70891-1-wlukowicz01@gmail.com>
Date:   Mon, 20 Feb 2023 11:37:22 -0300
In-Reply-To: <20230218184141.70891-1-wlukowicz01@gmail.com> (Wojciech
        Lukowicz's message of "Sat, 18 Feb 2023 18:41:41 +0000")
Message-ID: <87edqke731.fsf@suse.de>
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

Wojciech Lukowicz <wlukowicz01@gmail.com> writes:

> Using struct_size() to calculate the size of io_uring_buf_ring will sum
> the size of the struct and of the bufs array. However, the struct's fields
> are overlaid with the array making the calculated size larger than it
> should be.
>
> When registering a ring with N * PAGE_SIZE / sizeof(struct io_uring_buf)
> entries, i.e. with fully filled pages, the calculated size will span one
> more page than it should and io_uring will try to pin the following page.
> Depending on how the application allocated the ring, it might succeed
> using an unrelated page or fail returning EFAULT.
>
> The size of the ring should be the product of ring_entries and the size
> of io_uring_buf, i.e. the size of the bufs array only.
>
> Fixes: c7fb19428d67 ("io_uring: add support for ring mapped supplied buffers")
> Signed-off-by: Wojciech Lukowicz <wlukowicz01@gmail.com>

Makes sense to me and tested. Feel free to add

Reviewed-by: Gabriel Krisman Bertazi <krisman@suse.de>


> ---
> I'll send a liburing test shortly.
>
>  io_uring/kbuf.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
> index 4a6401080c1f..3002dc827195 100644
> --- a/io_uring/kbuf.c
> +++ b/io_uring/kbuf.c
> @@ -505,7 +505,7 @@ int io_register_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg)
>  	}
>  
>  	pages = io_pin_pages(reg.ring_addr,
> -			     struct_size(br, bufs, reg.ring_entries),
> +			     flex_array_size(br, bufs, reg.ring_entries),
>  			     &nr_pages);
>  	if (IS_ERR(pages)) {
>  		kfree(free_bl);

-- 
Gabriel Krisman Bertazi
