Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26D9579802C
	for <lists+io-uring@lfdr.de>; Fri,  8 Sep 2023 03:30:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232179AbjIHBah (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 7 Sep 2023 21:30:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230062AbjIHBag (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 7 Sep 2023 21:30:36 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CE481BD2
        for <io-uring@vger.kernel.org>; Thu,  7 Sep 2023 18:30:32 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 3BB54218E0;
        Fri,  8 Sep 2023 01:30:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1694136631; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TiOQyZ9xNVRULnFLw0J2J5z4vx68PcdZDqO7r7uy914=;
        b=jDf1HXWGw7FkenuqmpbAaPN/40ODq58x5gx22RnzpLUQgh8gmjM5IEUinpttuA89gUCE8e
        o2V58PJT58GPKkedqJi7FPwAXD6nh1sZpfCuymie3EHRDKYWMzwiVGAvPar1d6uA8UV1o8
        YjzimENSafQ/LCzRyrfBfUPDZtoEeXs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1694136631;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TiOQyZ9xNVRULnFLw0J2J5z4vx68PcdZDqO7r7uy914=;
        b=ieTvx753FBwn7HCbvGv/TNGUjhJi66h8YY42HR/DS3/VnOO3+r2hOfY8mtSInKELizb3Fb
        Fe3SqPeweSxp0DCw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 061B713357;
        Fri,  8 Sep 2023 01:30:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id oHl4NzZ5+mSbfQAAMHmgww
        (envelope-from <krisman@suse.de>); Fri, 08 Sep 2023 01:30:30 +0000
From:   Gabriel Krisman Bertazi <krisman@suse.de>
To:     Jeff Moyer <jmoyer@redhat.com>
Cc:     axboe@kernel.dk, io-uring@vger.kernel.org
Subject: Re: [PATCH] io_uring: Use slab for struct io_buffer objects
In-Reply-To: <x49o7id3ja8.fsf@segfault.boston.devel.redhat.com> (Jeff Moyer's
        message of "Thu, 07 Sep 2023 14:55:27 -0400")
Organization: SUSE
References: <20230830003634.31568-1-krisman@suse.de>
        <x49o7id3ja8.fsf@segfault.boston.devel.redhat.com>
Date:   Thu, 07 Sep 2023 21:30:29 -0400
Message-ID: <87o7ida1u2.fsf@suse.de>
User-Agent: Gnus/5.13 (Gnus v5.13)
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

Jeff Moyer <jmoyer@redhat.com> writes:

> Hi, Gabriel,
>
> I just have a couple of comments.  I don't have an opinion on whether it
> makes sense to replace the existing allocator.
>
> -Jeff
>
>> @@ -362,11 +363,12 @@ int io_provide_buffers_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe
>>  	return 0;
>>  }
>>  
>> +#define IO_BUFFER_ALLOC_BATCH (PAGE_SIZE/sizeof(struct io_buffer))
>> +
>>  static int io_refill_buffer_cache(struct io_ring_ctx *ctx)
>>  {
>> -	struct io_buffer *buf;
>> -	struct page *page;
>> -	int bufs_in_page;
>> +	struct io_buffer *bufs[IO_BUFFER_ALLOC_BATCH];
>
> That's a pretty large on-stack allocation.

Indeed, that is definitely too large. Thanks for pointing it out.

Also,  I just noticed the define above should actually read:

#define IO_BUFFER_ALLOC_BATCH (PAGE_SIZE/sizeof(struct io_buffer *))

I'll follow up with a v2, after I retest the impact a smaller allocation
batch would have.

>
>> +	allocated = kmem_cache_alloc_bulk(io_buf_cachep, GFP_KERNEL_ACCOUNT,
>> +					  ARRAY_SIZE(bufs), (void **) bufs);
>> +	if (unlikely(allocated <= 0)) {
>
> Can't be less than 0.

Thanks, will fix.

>

-- 
Gabriel Krisman Bertazi
