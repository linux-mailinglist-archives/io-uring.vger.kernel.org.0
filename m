Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1360D797C4A
	for <lists+io-uring@lfdr.de>; Thu,  7 Sep 2023 20:51:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244731AbjIGSvA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 7 Sep 2023 14:51:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344421AbjIGSur (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 7 Sep 2023 14:50:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00AF01BD1
        for <io-uring@vger.kernel.org>; Thu,  7 Sep 2023 11:49:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694112584;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MgF7bCMb4pj31paw0oQyBY/lYPsH+puq7BD0dtlG0ms=;
        b=N7HwgVssMlMWnUwKgF1yAi7nR/8frJyi3eg2JdCRSgWOwalR6HNMFIUtTPbUYyztNBYmdF
        qykbnKGdZGXfRPE/QOHK6GvXsq/zhbAlJJ5gOsitwZeqegXUWKRgXsXRp5AMwDAahWivUX
        xdQc4WtUQHgr3Dg0pS53JwjXifhtBpk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-6-7LUNnwDiMxKs1VT-pUITlA-1; Thu, 07 Sep 2023 14:49:42 -0400
X-MC-Unique: 7LUNnwDiMxKs1VT-pUITlA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C8229957841;
        Thu,  7 Sep 2023 18:49:41 +0000 (UTC)
Received: from segfault.boston.devel.redhat.com (segfault.boston.devel.redhat.com [10.19.60.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A89567B62;
        Thu,  7 Sep 2023 18:49:41 +0000 (UTC)
From:   Jeff Moyer <jmoyer@redhat.com>
To:     Gabriel Krisman Bertazi <krisman@suse.de>
Cc:     axboe@kernel.dk, io-uring@vger.kernel.org
Subject: Re: [PATCH] io_uring: Use slab for struct io_buffer objects
References: <20230830003634.31568-1-krisman@suse.de>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
Date:   Thu, 07 Sep 2023 14:55:27 -0400
In-Reply-To: <20230830003634.31568-1-krisman@suse.de> (Gabriel Krisman
        Bertazi's message of "Tue, 29 Aug 2023 20:36:34 -0400")
Message-ID: <x49o7id3ja8.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi, Gabriel,

I just have a couple of comments.  I don't have an opinion on whether it
makes sense to replace the existing allocator.

-Jeff

> @@ -362,11 +363,12 @@ int io_provide_buffers_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe
>  	return 0;
>  }
>  
> +#define IO_BUFFER_ALLOC_BATCH (PAGE_SIZE/sizeof(struct io_buffer))
> +
>  static int io_refill_buffer_cache(struct io_ring_ctx *ctx)
>  {
> -	struct io_buffer *buf;
> -	struct page *page;
> -	int bufs_in_page;
> +	struct io_buffer *bufs[IO_BUFFER_ALLOC_BATCH];

That's a pretty large on-stack allocation.

> +	allocated = kmem_cache_alloc_bulk(io_buf_cachep, GFP_KERNEL_ACCOUNT,
> +					  ARRAY_SIZE(bufs), (void **) bufs);
> +	if (unlikely(allocated <= 0)) {

Can't be less than 0.

