Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55FBF7B6E64
	for <lists+io-uring@lfdr.de>; Tue,  3 Oct 2023 18:25:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240371AbjJCQZ2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 3 Oct 2023 12:25:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240393AbjJCQZ1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 3 Oct 2023 12:25:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C042AE4
        for <io-uring@vger.kernel.org>; Tue,  3 Oct 2023 09:24:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696350277;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4DzOwwrGl+rWC4Xvdqgvja1SHqj8VZmooGCS0fYik8Q=;
        b=M8SW/zVrzy5gnHedMkfPA5XiYarkvydyJ/CCKvXP+MZ5LQLBqOYllixnf7x2r3gUXqIdd1
        dVELpTQYCwvFLMlRgNPil3Ef54cIW9tmQuVsaoMIQAJAN/Tx6bTk13cykItmi8lsMt4JLa
        7tPFoC+fxk5XRz4RJ7NtDJA+htMaLHc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-610-QxZWxcVFNxaRc4Ypbpjc5w-1; Tue, 03 Oct 2023 12:24:18 -0400
X-MC-Unique: QxZWxcVFNxaRc4Ypbpjc5w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 402A1811E7B;
        Tue,  3 Oct 2023 16:24:18 +0000 (UTC)
Received: from segfault.boston.devel.redhat.com (segfault.boston.devel.redhat.com [10.19.60.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2643140C6EA8;
        Tue,  3 Oct 2023 16:24:18 +0000 (UTC)
From:   Jeff Moyer <jmoyer@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>
Subject: Re: [PATCH] io_uring: don't allow IORING_SETUP_NO_MMAP rings on highmem pages
References: <4c9eddf5-75d8-44cf-9365-a0dd3d0b4c05@kernel.dk>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
Date:   Tue, 03 Oct 2023 12:30:02 -0400
In-Reply-To: <4c9eddf5-75d8-44cf-9365-a0dd3d0b4c05@kernel.dk> (Jens Axboe's
        message of "Tue, 3 Oct 2023 10:02:35 -0600")
Message-ID: <x49edibpt2t.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi, Jens,

Jens Axboe <axboe@kernel.dk> writes:

> On at least arm32, but presumably any arch with highmem, if the
> application passes in memory that resides in highmem for the rings,
> then we should fail that ring creation. We fail it with -EINVAL, which
> is what kernels that don't support IORING_SETUP_NO_MMAP will do as well.
>
> Cc: stable@vger.kernel.org
> Fixes: 03d89a2de25b ("io_uring: support for user allocated memory for rings/sqes")
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>
> ---
>
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index 783ed0fff71b..d839a80a6751 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -2686,7 +2686,7 @@ static void *__io_uaddr_map(struct page ***pages, unsigned short *npages,
>  {
>  	struct page **page_array;
>  	unsigned int nr_pages;
> -	int ret;
> +	int ret, i;
>  
>  	*npages = 0;
>  
> @@ -2716,6 +2716,20 @@ static void *__io_uaddr_map(struct page ***pages, unsigned short *npages,
>  	 */
>  	if (page_array[0] != page_array[ret - 1])
>  		goto err;
> +
> +	/*
> +	 * Can't support mapping user allocated ring memory on 32-bit archs
> +	 * where it could potentially reside in highmem. Just fail those with
> +	 * -EINVAL, just like we did on kernels that didn't support this
> +	 * feature.
> +	 */
> +	for (i = 0; i < nr_pages; i++) {
> +		if (PageHighMem(page_array[i])) {
> +			ret = -EINVAL;
> +			goto err;
> +		}
> +	}
> +

What do you think about throwing a printk_once in there that explains
the problem?  I'm worried that this will fail somewhat randomly, and it
may not be apparent to the user why.  We should also add documentation,
of course, and encourage developers to add fallbacks for this case.

-Jeff

