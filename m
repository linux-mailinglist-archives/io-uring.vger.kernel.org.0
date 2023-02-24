Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D96EA6A218B
	for <lists+io-uring@lfdr.de>; Fri, 24 Feb 2023 19:32:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229533AbjBXSc5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Feb 2023 13:32:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229872AbjBXSc4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Feb 2023 13:32:56 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B9762D7E;
        Fri, 24 Feb 2023 10:32:51 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 375DC38947;
        Fri, 24 Feb 2023 18:32:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1677263570; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IwljiIh1fS+2NOwzceHLVqy8Ve5Q5t96iwJ4JuzYLq0=;
        b=RwI0RqcNlUU0utIdjpsaTVCw+iniqt0jauvlB7csQiGHZibjHcYsgDlO9DgUOkS+irS/fd
        W1H3e+qve5djSRAnDYFdlUYBx3USSXHrJCj0w1mB4JZBbJOFRNFF2EwLG6ATk30qC9p4F3
        mF67v1sPeZDapmaKWqADNrpYlk2p2us=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1677263570;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IwljiIh1fS+2NOwzceHLVqy8Ve5Q5t96iwJ4JuzYLq0=;
        b=4CqLLgv8o49Zz8tQN1NCxV7j5ZXyYT4fOH6aEQcT0stUQ7fRDz9YcN+4cioS+xbYQOy+yh
        6PaKtGYaklgm7CDw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id BBA0413246;
        Fri, 24 Feb 2023 18:32:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id p64CIdEC+WNvbAAAMHmgww
        (envelope-from <krisman@suse.de>); Fri, 24 Feb 2023 18:32:49 +0000
From:   Gabriel Krisman Bertazi <krisman@suse.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Breno Leitao <leitao@debian.org>, asml.silence@gmail.com,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        gustavold@meta.com, leit@meta.com, kasan-dev@googlegroups.com
Subject: Re: [PATCH v3 1/2] io_uring: Move from hlist to io_wq_work_node
References: <20230223164353.2839177-1-leitao@debian.org>
        <20230223164353.2839177-2-leitao@debian.org> <87wn48ryri.fsf@suse.de>
        <8404f520-2ef7-b556-08f6-5829a2225647@kernel.dk>
Date:   Fri, 24 Feb 2023 15:32:47 -0300
In-Reply-To: <8404f520-2ef7-b556-08f6-5829a2225647@kernel.dk> (Jens Axboe's
        message of "Thu, 23 Feb 2023 12:39:25 -0700")
Message-ID: <87mt52syls.fsf@suse.de>
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

Jens Axboe <axboe@kernel.dk> writes:

> On 2/23/23 12:02?PM, Gabriel Krisman Bertazi wrote:
>> Breno Leitao <leitao@debian.org> writes:
>> 
>>> Having cache entries linked using the hlist format brings no benefit, and
>>> also requires an unnecessary extra pointer address per cache entry.
>>>
>>> Use the internal io_wq_work_node single-linked list for the internal
>>> alloc caches (async_msghdr and async_poll)
>>>
>>> This is required to be able to use KASAN on cache entries, since we do
>>> not need to touch unused (and poisoned) cache entries when adding more
>>> entries to the list.
>>>
>> 
>> Looking at this patch, I wonder if it could go in the opposite direction
>> instead, and drop io_wq_work_node entirely in favor of list_head. :)
>> 
>> Do we gain anything other than avoiding the backpointer with a custom
>> linked implementation, instead of using the interface available in
>> list.h, that developers know how to use and has other features like
>> poisoning and extra debug checks?
>
> list_head is twice as big, that's the main motivation. This impacts
> memory usage (obviously), but also caches when adding/removing
> entries.

Right. But this is true all around the kernel.  Many (Most?)  places
that use list_head don't even need to touch list_head->prev.  And
list_head is usually embedded in larger structures where the cost of
the extra pointer is insignificant.  I suspect the memory
footprint shouldn't really be the problem.

This specific patch is extending io_wq_work_node to io_cache_entry,
where the increased size will not matter.  In fact, for the cached
structures, the cache layout and memory footprint don't even seem to
change, as io_cache_entry is already in a union larger than itself, that
is not crossing cachelines, (io_async_msghdr, async_poll).

The other structures currently embedding struct io_work_node are
io_kiocb (216 bytes long, per request) and io_ring_ctx (1472 bytes long,
per ring). so it is not like we are saving a lot of memory with a single
linked list. A more compact cache line still makes sense, though, but I
think the only case (if any) where there might be any gain is io_kiocb?

I don't severely oppose this patch, of course. But I think it'd be worth
killing io_uring/slist.h entirely in the future instead of adding more
users.  I intend to give that approach a try, if there's a way to keep
the size of io_kiocb.

-- 
Gabriel Krisman Bertazi
