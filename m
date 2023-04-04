Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 544076D697A
	for <lists+io-uring@lfdr.de>; Tue,  4 Apr 2023 18:53:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232492AbjDDQxZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 4 Apr 2023 12:53:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232948AbjDDQxV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 4 Apr 2023 12:53:21 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB2234EDA;
        Tue,  4 Apr 2023 09:53:06 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 13D8822B58;
        Tue,  4 Apr 2023 16:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1680627185; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=78dQWLSB6oQp4OcUU5xJyej+ZlYTHH1wrdIzEgJYSsQ=;
        b=AXF5c/dk9Oa+GjjICmzmuB6PdDFIqMq0D64a/vp8FEl4X3u9F/MK2eSQStBWJXaj+t2ig0
        v/FLLWmV+dPujEALGpJYdGC/H6OWDg0ZHBEBjNB/u2nOaSp6jplDCz2St2CKE5heJJ6c+q
        TfqWh4UXdbewmSisCwegelBi1iwGQCQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1680627185;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=78dQWLSB6oQp4OcUU5xJyej+ZlYTHH1wrdIzEgJYSsQ=;
        b=MXtXJVXm7P++lHLtS21Jj0xKTK/H5v7ZWHuEqmUC5FE66w45nsTVeNt6G9IAzNW+U36395
        FjX6fIXJRK+tjyCA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 7688D1391A;
        Tue,  4 Apr 2023 16:53:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id bQc3CfBVLGTOMAAAMHmgww
        (envelope-from <krisman@suse.de>); Tue, 04 Apr 2023 16:53:04 +0000
From:   Gabriel Krisman Bertazi <krisman@suse.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/11] io_uring/rsrc: cache struct io_rsrc_node
Organization: SUSE
References: <cover.1680187408.git.asml.silence@gmail.com>
        <7f5eb1b89e8dcf93739607c79bbf7aec1784cbbe.1680187408.git.asml.silence@gmail.com>
        <87cz4p1083.fsf@suse.de>
        <6eaadad2-d6a6-dfbb-88aa-8ae68af2f89d@gmail.com>
        <87wn2wzcv3.fsf@suse.de>
        <4cc86e76-46b7-09ce-65f9-cd27ffe4b26e@gmail.com>
        <87h6tvzm0g.fsf@suse.de>
        <1e9a6dd5-b8c4-ef63-bf76-075ba0d42093@kernel.dk>
Date:   Tue, 04 Apr 2023 13:53:01 -0300
In-Reply-To: <1e9a6dd5-b8c4-ef63-bf76-075ba0d42093@kernel.dk> (Jens Axboe's
        message of "Tue, 4 Apr 2023 09:52:55 -0600")
Message-ID: <87cz4jzj0y.fsf@suse.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Jens Axboe <axboe@kernel.dk> writes:

> On 4/4/23 9:48?AM, Gabriel Krisman Bertazi wrote:
>> Pavel Begunkov <asml.silence@gmail.com> writes:
>> 
>>> On 4/1/23 01:04, Gabriel Krisman Bertazi wrote:
>>>> Pavel Begunkov <asml.silence@gmail.com> writes:
>> 
>>>>> I didn't try it, but kmem_cache vs kmalloc, IIRC, doesn't bring us
>>>>> much, definitely doesn't spare from locking, and the overhead
>>>>> definitely wasn't satisfactory for requests before.
>>>> There is no locks in the fast path of slub, as far as I know.  it has
>>>> a
>>>> per-cpu cache that is refilled once empty, quite similar to the fastpath
>>>> of this cache.  I imagine the performance hit in slub comes from the
>>>> barrier and atomic operations?
>>>
>>> Yeah, I mean all kinds of synchronisation. And I don't think
>>> that's the main offender here, the test is single threaded without
>>> contention and the system was mostly idle.
>>>
>>>> kmem_cache works fine for most hot paths of the kernel.  I think this
>>>
>>> It doesn't for io_uring. There are caches for the net side and now
>>> in the block layer as well. I wouldn't say it necessarily halves
>>> performance but definitely takes a share of CPU.
>> 
>> Right.  My point is that all these caches (block, io_uring) duplicate
>> what the slab cache is meant to do.  Since slab became a bottleneck, I'm
>> looking at how to improve the situation on their side, to see if we can
>> drop the caching here and in block/.
>
> That would certainly be a worthy goal, and I do agree that these caches
> are (largely) working around deficiencies. One important point that you
> may miss is that most of this caching gets its performance from both
> avoiding atomics in slub, but also because we can guarantee that both
> alloc and free happen from process context. The block IRQ bits are a bit
> different, but apart from that, it's true elsewhere. Caching that needs
> to even disable IRQs locally generally doesn't beat out slub by much,
> the big wins are the cases where we know free+alloc is done in process
> context.

Yes, I noticed that.  I was thinking of exposing a flag at kmem_cache
creation-time to tell slab the user promises not to use it in IRQ
context, so it doesn't need to worry about nested invocation in the
allocation/free path.  Then, for those caches, have a
kmem_cache_alloc_locked variant, where the synchronization is maintained
by the caller (i.e. by ->uring_lock here), so it can manipulate the
cache without atomics.

I was looking at your implementation of the block cache for inspiration
and saw how you kept a second list for IRQ.  I'm thinking how to fit a
similar change inside slub.  But for now, I want to get the simpler
case, which is all io_uring need.

I'll try to get a prototype before lsfmm and see if I get the MM folks
input there.

-- 
Gabriel Krisman Bertazi
