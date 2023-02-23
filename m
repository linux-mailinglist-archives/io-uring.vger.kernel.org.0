Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7D606A1002
	for <lists+io-uring@lfdr.de>; Thu, 23 Feb 2023 20:02:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229516AbjBWTCe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 23 Feb 2023 14:02:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjBWTCe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 23 Feb 2023 14:02:34 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAA813B0FE;
        Thu, 23 Feb 2023 11:02:29 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 77F5D339CF;
        Thu, 23 Feb 2023 19:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1677178948; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=P02lDBmsHtB0LY1+D/Fd48m1wsVE8BrW8yUGVQS7FRk=;
        b=WaukZiuoTTNbGSDoL/K+o+Sl1K3p/sasDDnFfJ+8SyrKXJE9wcJXkHmWckDrrjjLiq0jXo
        UY+Wy835wZBTXGJOoROa9SIvXf3w2cRomqkgNG7MTqphdI4kO6LkhbjwjRqrsdld7uJ5yu
        rXiT5AGZP9FmxXynXyIYT9VuvTJEL1A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1677178948;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=P02lDBmsHtB0LY1+D/Fd48m1wsVE8BrW8yUGVQS7FRk=;
        b=La6S6HEBUtqyPtE6Oo4P+upqHRf+fLzvRL9fjBfob72U7K+KIWOGS5k1VF5VP2KNTM+HxW
        yIK1mxurVPrFV/CQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 057BA13928;
        Thu, 23 Feb 2023 19:02:27 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id niFGMEO492M8NAAAMHmgww
        (envelope-from <krisman@suse.de>); Thu, 23 Feb 2023 19:02:27 +0000
From:   Gabriel Krisman Bertazi <krisman@suse.de>
To:     Breno Leitao <leitao@debian.org>
Cc:     axboe@kernel.dk, asml.silence@gmail.com, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, gustavold@meta.com, leit@meta.com,
        kasan-dev@googlegroups.com
Subject: Re: [PATCH v3 1/2] io_uring: Move from hlist to io_wq_work_node
References: <20230223164353.2839177-1-leitao@debian.org>
        <20230223164353.2839177-2-leitao@debian.org>
Date:   Thu, 23 Feb 2023 16:02:25 -0300
In-Reply-To: <20230223164353.2839177-2-leitao@debian.org> (Breno Leitao's
        message of "Thu, 23 Feb 2023 08:43:52 -0800")
Message-ID: <87wn48ryri.fsf@suse.de>
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

> Having cache entries linked using the hlist format brings no benefit, and
> also requires an unnecessary extra pointer address per cache entry.
>
> Use the internal io_wq_work_node single-linked list for the internal
> alloc caches (async_msghdr and async_poll)
>
> This is required to be able to use KASAN on cache entries, since we do
> not need to touch unused (and poisoned) cache entries when adding more
> entries to the list.
>

Looking at this patch, I wonder if it could go in the opposite direction
instead, and drop io_wq_work_node entirely in favor of list_head. :)

Do we gain anything other than avoiding the backpointer with a custom
linked implementation, instead of using the interface available in
list.h, that developers know how to use and has other features like
poisoning and extra debug checks?


>  static inline struct io_cache_entry *io_alloc_cache_get(struct io_alloc_cache *cache)
>  {
> -	if (!hlist_empty(&cache->list)) {
> -		struct hlist_node *node = cache->list.first;
> +	if (cache->list.next) {
> +		struct io_cache_entry *entry;
>  
> -		hlist_del(node);
> -		return container_of(node, struct io_cache_entry, node);
> +		entry = container_of(cache->list.next, struct io_cache_entry, node);
> +		cache->list.next = cache->list.next->next;
> +		return entry;
>  	}

From a quick look, I think you could use wq_stack_extract() here

-- 
Gabriel Krisman Bertazi
