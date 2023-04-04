Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34BD26D67D6
	for <lists+io-uring@lfdr.de>; Tue,  4 Apr 2023 17:48:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235885AbjDDPsk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 4 Apr 2023 11:48:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233030AbjDDPsg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 4 Apr 2023 11:48:36 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFE6CEC;
        Tue,  4 Apr 2023 08:48:35 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 7EC1E20109;
        Tue,  4 Apr 2023 15:48:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1680623314; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HGw5LrR+1O1OLVrcrhC6gXtzTME++X55P6opcObz7ng=;
        b=emRAHFwNtsMVrNM56B7CzCQhpG4ZIuqnIE6yvWbpi+IAImCY3dS9WmOhVQHzoX0t8p1Im9
        aWL8NAh1uGdcYXsceZ2AW1XhxfHGGAWQr+D2tc/40m0VWV0k0sbBBPAl7DFgzcCQ+kPG6T
        VHQfQRMBYPg+bVogBaLh0htYdOqVOKI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1680623314;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HGw5LrR+1O1OLVrcrhC6gXtzTME++X55P6opcObz7ng=;
        b=zWuV2MiM+ox80WN8juSTEwLMflJTFQxpXHDxmKuPkfj3fGuS41yQ30AKFlDtq4lsrEDs4R
        71OKrEW6wZAG7iAA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id EFE0B1391A;
        Tue,  4 Apr 2023 15:48:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id F2MbK9FGLGSlEQAAMHmgww
        (envelope-from <krisman@suse.de>); Tue, 04 Apr 2023 15:48:33 +0000
From:   Gabriel Krisman Bertazi <krisman@suse.de>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/11] io_uring/rsrc: cache struct io_rsrc_node
Organization: SUSE
References: <cover.1680187408.git.asml.silence@gmail.com>
        <7f5eb1b89e8dcf93739607c79bbf7aec1784cbbe.1680187408.git.asml.silence@gmail.com>
        <87cz4p1083.fsf@suse.de>
        <6eaadad2-d6a6-dfbb-88aa-8ae68af2f89d@gmail.com>
        <87wn2wzcv3.fsf@suse.de>
        <4cc86e76-46b7-09ce-65f9-cd27ffe4b26e@gmail.com>
Date:   Tue, 04 Apr 2023 12:48:31 -0300
In-Reply-To: <4cc86e76-46b7-09ce-65f9-cd27ffe4b26e@gmail.com> (Pavel
        Begunkov's message of "Tue, 4 Apr 2023 14:21:41 +0100")
Message-ID: <87h6tvzm0g.fsf@suse.de>
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

Pavel Begunkov <asml.silence@gmail.com> writes:

> On 4/1/23 01:04, Gabriel Krisman Bertazi wrote:
>> Pavel Begunkov <asml.silence@gmail.com> writes:

>>> I didn't try it, but kmem_cache vs kmalloc, IIRC, doesn't bring us
>>> much, definitely doesn't spare from locking, and the overhead
>>> definitely wasn't satisfactory for requests before.
>> There is no locks in the fast path of slub, as far as I know.  it has
>> a
>> per-cpu cache that is refilled once empty, quite similar to the fastpath
>> of this cache.  I imagine the performance hit in slub comes from the
>> barrier and atomic operations?
>
> Yeah, I mean all kinds of synchronisation. And I don't think
> that's the main offender here, the test is single threaded without
> contention and the system was mostly idle.
>
>> kmem_cache works fine for most hot paths of the kernel.  I think this
>
> It doesn't for io_uring. There are caches for the net side and now
> in the block layer as well. I wouldn't say it necessarily halves
> performance but definitely takes a share of CPU.

Right.  My point is that all these caches (block, io_uring) duplicate
what the slab cache is meant to do.  Since slab became a bottleneck, I'm
looking at how to improve the situation on their side, to see if we can
drop the caching here and in block/.

>> If it is indeed a significant performance improvement, I guess it is
>> fine to have another user of the cache. But I'd be curious to know how
>> much of the performance improvement you mentioned in the cover letter is
>> due to this patch!
>
> It was definitely sticking out in profiles, 5-10% of cycles, maybe
> more

That's surprisingly high.  Hopefully we will can avoid this caching
soon.  For now, feel free to add to this patch:

Reviewed-by: Gabriel Krisman Bertazi <krisman@suse.de>

-- 
Gabriel Krisman Bertazi
