Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC6FD7CE113
	for <lists+io-uring@lfdr.de>; Wed, 18 Oct 2023 17:21:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231211AbjJRPVu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 18 Oct 2023 11:21:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230391AbjJRPVu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 18 Oct 2023 11:21:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56D83109
        for <io-uring@vger.kernel.org>; Wed, 18 Oct 2023 08:21:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697642467;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Y9nh+GkOxQtcsOD52MN13gcXAS4ZOsrtHzvndKTWUI4=;
        b=K3TAIyVb+fQMUzvLlCMXDrYW7ZfTIGPoNPfNH31yMVcYYRK7efiOczcEmNzcIed/9gSCXg
        rHLWRBxanTbxOFMpRAF5/x5zJvmV02s0OHIE2+H/MTRAXgCiRvlqY4iXV9hP2PNFvR9VbE
        2Hgfc9XsJWZ1o25Ry/ZhT4z8WNlA3oY=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-122-7U2nawSNMPWUzm4qn1PKkQ-1; Wed, 18 Oct 2023 11:20:58 -0400
X-MC-Unique: 7U2nawSNMPWUzm4qn1PKkQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2FB792825E92;
        Wed, 18 Oct 2023 15:20:58 +0000 (UTC)
Received: from segfault.boston.devel.redhat.com (segfault.boston.devel.redhat.com [10.19.60.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1222B1C060AE;
        Wed, 18 Oct 2023 15:20:58 +0000 (UTC)
From:   Jeff Moyer <jmoyer@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>, rtm@csail.mit.edu
Subject: Re: [PATCH] io_uring: fix crash with IORING_SETUP_NO_MMAP and invalid SQ ring address
References: <51bace4f-a976-48d5-8752-1fef2350c0e3@kernel.dk>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
Date:   Wed, 18 Oct 2023 11:26:41 -0400
In-Reply-To: <51bace4f-a976-48d5-8752-1fef2350c0e3@kernel.dk> (Jens Axboe's
        message of "Wed, 18 Oct 2023 08:18:06 -0600")
Message-ID: <x49edhslzny.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Jens Axboe <axboe@kernel.dk> writes:

> If we specify a valid CQ ring address but an invalid SQ ring address,
> we'll correctly spot this and free the allocated pages and clear them
> to NULL. However, we don't clear the ring page count, and hence will
> attempt to free the pages again. We've already cleared the address of
> the page array when freeing them, but we don't check for that. This
> causes the following crash:
>
> Unable to handle kernel NULL pointer dereference at virtual address 0000000000000000
> Oops [#1]
> Modules linked in:
> CPU: 0 PID: 20 Comm: kworker/u2:1 Not tainted 6.6.0-rc5-dirty #56
> Hardware name: ucbbar,riscvemu-bare (DT)
> Workqueue: events_unbound io_ring_exit_work
> epc : io_pages_free+0x2a/0x58
>  ra : io_rings_free+0x3a/0x50
>  epc : ffffffff808811a2 ra : ffffffff80881406 sp : ffff8f80000c3cd0
>  status: 0000000200000121 badaddr: 0000000000000000 cause: 000000000000000d
>  [<ffffffff808811a2>] io_pages_free+0x2a/0x58
>  [<ffffffff80881406>] io_rings_free+0x3a/0x50
>  [<ffffffff80882176>] io_ring_exit_work+0x37e/0x424
>  [<ffffffff80027234>] process_one_work+0x10c/0x1f4
>  [<ffffffff8002756e>] worker_thread+0x252/0x31c
>  [<ffffffff8002f5e4>] kthread+0xc4/0xe0
>  [<ffffffff8000332a>] ret_from_fork+0xa/0x1c
>
> Check for a NULL array in io_pages_free(), but also clear the page counts
> when we free them to be on the safer side.
>
> Reported-by: rtm@csail.mit.edu
> Fixes: 03d89a2de25b ("io_uring: support for user allocated memory for rings/sqes")
> Cc: stable@vger.kernel.org
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>
> ---
>
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index d839a80a6751..8d1bc6cdfe71 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -2674,7 +2674,11 @@ static void io_pages_free(struct page ***pages, int npages)
>  
>  	if (!pages)
>  		return;
> +
>  	page_array = *pages;
> +	if (!page_array)
> +		return;
> +
>  	for (i = 0; i < npages; i++)
>  		unpin_user_page(page_array[i]);
>  	kvfree(page_array);
> @@ -2758,7 +2762,9 @@ static void io_rings_free(struct io_ring_ctx *ctx)
>  		ctx->sq_sqes = NULL;
>  	} else {
>  		io_pages_free(&ctx->ring_pages, ctx->n_ring_pages);
> +		ctx->n_ring_pages = 0;
>  		io_pages_free(&ctx->sqe_pages, ctx->n_sqe_pages);
> +		ctx->n_sqe_pages = 0;
>  	}
>  }

Reviewed-by: Jeff Moyer <jmoyer@redhat.com>

