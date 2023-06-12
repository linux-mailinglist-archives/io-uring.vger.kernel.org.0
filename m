Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 371DD72D4BA
	for <lists+io-uring@lfdr.de>; Tue, 13 Jun 2023 01:00:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233202AbjFLXAk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 12 Jun 2023 19:00:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbjFLXAi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 12 Jun 2023 19:00:38 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60A1D13E
        for <io-uring@vger.kernel.org>; Mon, 12 Jun 2023 16:00:37 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 115CB22619;
        Mon, 12 Jun 2023 23:00:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1686610836; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wP10jaevsTpD7U56FJbNc+g/Cc5qkHBBtSI4J0GzeFQ=;
        b=wYjbGDN0iiwl7DifNVVpqQD42BtpIsgwkS3wB5KefebuJINGA5oJ9xye/CKI0xF3Mea/p3
        izYghFhjWz+/o4LD2WqPU39Kh4maswjZbYInav469peRifn9PTizf1ZLL96nqe37qU8CzC
        d0XabDjfJQdXdCewwdpMkxaTjR22O8o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1686610836;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wP10jaevsTpD7U56FJbNc+g/Cc5qkHBBtSI4J0GzeFQ=;
        b=dirqKJFt1MCWJt6YAMp0H77ysK/O/0MTxeHFtiPdQ9wcCt9ieKPz9yq4ovfCEgdJ+U8UQg
        Qk5A7ws6+wO6W3DA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id CDF531357F;
        Mon, 12 Jun 2023 23:00:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id eLanLJOjh2RyZQAAMHmgww
        (envelope-from <krisman@suse.de>); Mon, 12 Jun 2023 23:00:35 +0000
From:   Gabriel Krisman Bertazi <krisman@suse.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, andres@anarazel.de
Subject: Re: [PATCH 5/6] io_uring: add support for futex wake and wait
Organization: SUSE
References: <20230609183125.673140-1-axboe@kernel.dk>
        <20230609183125.673140-6-axboe@kernel.dk> <87352w3bsg.fsf@suse.de>
        <dc043733-b892-3abd-6e3b-4104bec3de2e@kernel.dk>
Date:   Mon, 12 Jun 2023 19:00:34 -0400
In-Reply-To: <dc043733-b892-3abd-6e3b-4104bec3de2e@kernel.dk> (Jens Axboe's
        message of "Mon, 12 Jun 2023 14:37:51 -0600")
Message-ID: <87r0qg1e25.fsf@suse.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Jens Axboe <axboe@kernel.dk> writes:

> On 6/12/23 10:06?AM, Gabriel Krisman Bertazi wrote:
>> Jens Axboe <axboe@kernel.dk> writes:
>> 
>>> Add support for FUTEX_WAKE/WAIT primitives.
>> 
>> This is great.  I was so sure io_uring had this support already for some
>> reason.  I might have dreamed it.
>
> I think you did :-)

Premonitory!  Still, there should be better things to dream about than
with the kernel code.

>> Even with an asynchronous model, it might make sense to halt execution
>> of further queued operations until futex completes.  I think
>> IOSQE_IO_DRAIN is a barrier only against the submission part, so it
>> wouldn't hep.  Is there a way to ensure this ordering?
>
> You'd use link for that - link whatever depends on the wake to the futex
> wait. Or just queue it up once you reap the wait completion, when that
> is posted because we got woken.

The challenge of linked requests, in my opinion, is that once a link
chain starts, everything needs to be link together, and a single error
fails everything, which is ok when operations are related, but
not so much when doing IO to different files from the same ring.

>>> Cancelations are supported, both from the application point-of-view,
>>> but also to be able to cancel pending waits if the ring exits before
>>> all events have occurred.
>>>
>>> This is just the barebones wait/wake support. Features to be added
>>> later:
>> 
>> One item high on my wishlist would be the futexv semantics (wait on any
>> of a set of futexes).  It cannot be implemented by issuing several
>> FUTEX_WAIT.
>
> Yep, I do think that one is interesting enough to consider upfront.
>Unfortunately the internal implementation of that does not look that
>great, though I'm sure we can make that work.  ?  But would likely
>require some futexv refactoring to make it work. I can take a look at
>it.

No disagreement here.  To be fair, the main challenge was making the new
interface compatible with a futex being waited on/waked the original
interface. At some point, we had a really nice design for a single
object, but we spent two years bikesheding over the interface and ended
up merging something pretty much similar to the proposal from two years
prior.

> You could obviously do futexv with this patchset, just posting N futex
> waits and canceling N-1 when you get woken by one. Though that's of
> course not very pretty or nice to use, but design wise it would totally
> work as you don't actually block on these with io_uring.

Yes, but at that point, i guess it'd make more sense to implement the
same semantics by polling over a set of eventfds or having a single
futex and doing dispatch in userspace.

thanks,

-- 
Gabriel Krisman Bertazi
