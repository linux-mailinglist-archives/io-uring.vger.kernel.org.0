Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2D866A1021
	for <lists+io-uring@lfdr.de>; Thu, 23 Feb 2023 20:09:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231359AbjBWTJh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 23 Feb 2023 14:09:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231262AbjBWTJb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 23 Feb 2023 14:09:31 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F395D2CFD1;
        Thu, 23 Feb 2023 11:09:28 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 9B2A934971;
        Thu, 23 Feb 2023 19:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1677179367; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=R6BDDmrkkHAaryDO214Xsq4JWamUS2WCaTo7R6jDDQI=;
        b=H3TNPi0FCe7VrmuOIm2rz8kcFJ9drqFN27wR0GwQ1sN+nbwzj8QFYU98CXDUHrr2Sqy8Sk
        ePl9VHADkrPO1S32gePs28XnOfMHsKPewJZojtqo54xup/GLW1DN24s4Ct7v/nhcDb6CDV
        uDueMue4nL1b4/ZvwLsT+Tz4E8ug2UA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1677179367;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=R6BDDmrkkHAaryDO214Xsq4JWamUS2WCaTo7R6jDDQI=;
        b=HBRbEpj0u8Zw2ErAJRkCyDorKQJz1ArQmsr+kQHzXiwAdg+eBxdcMTtkpsNX3Gvv8jDS88
        Hdn8j2q8fkdICIDQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 2DC6613928;
        Thu, 23 Feb 2023 19:09:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id EQYtOua592OENwAAMHmgww
        (envelope-from <krisman@suse.de>); Thu, 23 Feb 2023 19:09:26 +0000
From:   Gabriel Krisman Bertazi <krisman@suse.de>
To:     Breno Leitao <leitao@debian.org>
Cc:     axboe@kernel.dk, asml.silence@gmail.com, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, gustavold@meta.com, leit@meta.com,
        kasan-dev@googlegroups.com
Subject: Re: [PATCH v3 2/2] io_uring: Add KASAN support for alloc_caches
References: <20230223164353.2839177-1-leitao@debian.org>
        <20230223164353.2839177-3-leitao@debian.org>
Date:   Thu, 23 Feb 2023 16:09:24 -0300
In-Reply-To: <20230223164353.2839177-3-leitao@debian.org> (Breno Leitao's
        message of "Thu, 23 Feb 2023 08:43:53 -0800")
Message-ID: <87sfewryfv.fsf@suse.de>
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

Breno Leitao <leitao@debian.org> writes:

> Add support for KASAN in the alloc_caches (apoll and netmsg_cache).
> Thus, if something touches the unused caches, it will raise a KASAN
> warning/exception.
>
> It poisons the object when the object is put to the cache, and unpoisons
> it when the object is gotten or freed.
>
> Signed-off-by: Breno Leitao <leitao@debian.org>
> ---
>  include/linux/io_uring_types.h | 1 +
>  io_uring/alloc_cache.h         | 6 +++++-
>  io_uring/io_uring.c            | 4 ++--
>  io_uring/net.h                 | 5 ++++-
>  4 files changed, 12 insertions(+), 4 deletions(-)
>
> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
> index efa66b6c32c9..35ebcfb46047 100644
> --- a/include/linux/io_uring_types.h
> +++ b/include/linux/io_uring_types.h
> @@ -190,6 +190,7 @@ struct io_ev_fd {
>  struct io_alloc_cache {
>  	struct io_wq_work_node	list;
>  	unsigned int		nr_cached;
> +	size_t			elem_size;
>  };
>  
>  struct io_ring_ctx {
> diff --git a/io_uring/alloc_cache.h b/io_uring/alloc_cache.h
> index 301855e94309..3aba7b356320 100644
> --- a/io_uring/alloc_cache.h
> +++ b/io_uring/alloc_cache.h
> @@ -16,6 +16,8 @@ static inline bool io_alloc_cache_put(struct io_alloc_cache *cache,
>  	if (cache->nr_cached < IO_ALLOC_CACHE_MAX) {
>  		cache->nr_cached++;
>  		wq_stack_add_head(&entry->node, &cache->list);
> +		/* KASAN poisons object */
> +		kasan_slab_free_mempool(entry);
>  		return true;
>  	}
>  	return false;
> @@ -27,6 +29,7 @@ static inline struct io_cache_entry *io_alloc_cache_get(struct io_alloc_cache *c
>  		struct io_cache_entry *entry;
>  
>  		entry = container_of(cache->list.next, struct io_cache_entry, node);
> +		kasan_unpoison_range(entry, cache->elem_size);

I kind of worry there is no type checking at the same time we are
unpoisoning a constant-size range.  Seems easy to misuse the API.  But it
does look much better now with elem_size cached inside io_alloc_cache.

>  
> -#if defined(CONFIG_NET)
>  struct io_async_msghdr {
> +#if defined(CONFIG_NET)
>  	union {
>  		struct iovec		fast_iov[UIO_FASTIOV];
>  		struct {
> @@ -22,8 +22,11 @@ struct io_async_msghdr {
>  	struct sockaddr __user		*uaddr;
>  	struct msghdr			msg;
>  	struct sockaddr_storage		addr;
> +#endif
>  };
>  
> +#if defined(CONFIG_NET)
> +

Nit, but you could have added an empty definition in the #else section
that already exists in the file, or just guarded the caching code
entirely when CONFIG_NET=n.

Just nits, and overall it is good to have this KASAN support!

Reviewed-by: Gabriel Krisman Bertazi <krisman@suse.de>

-- 
Gabriel Krisman Bertazi
