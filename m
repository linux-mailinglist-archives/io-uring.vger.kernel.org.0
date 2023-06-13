Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0692A72D788
	for <lists+io-uring@lfdr.de>; Tue, 13 Jun 2023 04:56:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238599AbjFMC4D (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 12 Jun 2023 22:56:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237581AbjFMC4C (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 12 Jun 2023 22:56:02 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F4D41728
        for <io-uring@vger.kernel.org>; Mon, 12 Jun 2023 19:55:52 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id F2D5622547;
        Tue, 13 Jun 2023 02:55:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1686624951; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=A1R3/UmN6IcLy09gUzR+rBnJEBoi7UhC8hvpFuVWQAY=;
        b=blxJIQd7Iz6b64ez6CEy+PUdPuejisMSgS25e54lCNhP3zSHVYFUALgELLtn1//t92wgsb
        NiLxXh8rZb/q630fFyw82iKeIEFvpmEsjVwSNB2TJEkMjB034JfKhTxI4fFakbh9LOV5ze
        XpFd2WUA13hcUElCU8feb4tlaAmmgZg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1686624951;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=A1R3/UmN6IcLy09gUzR+rBnJEBoi7UhC8hvpFuVWQAY=;
        b=76t+JiBf3Bn55Z4tmpOEYNcozAe/wgIqd5RGgPrFbv33eR4niYEvuWRMmiHqBTUK9Wy1bd
        AHujeuxtLa0nBzDQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id B62ED138EC;
        Tue, 13 Jun 2023 02:55:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id Vxs2Jrbah2QjLwAAMHmgww
        (envelope-from <krisman@suse.de>); Tue, 13 Jun 2023 02:55:50 +0000
From:   Gabriel Krisman Bertazi <krisman@suse.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, andres@anarazel.de
Subject: io_uring link semantics (was [PATCH 5/6] io_uring: add support for
 futex wake and wait)
Organization: SUSE
References: <20230609183125.673140-1-axboe@kernel.dk>
        <20230609183125.673140-6-axboe@kernel.dk> <87352w3bsg.fsf@suse.de>
        <dc043733-b892-3abd-6e3b-4104bec3de2e@kernel.dk>
        <87r0qg1e25.fsf@suse.de>
        <77293e8f-fbd2-be08-765a-513460781455@kernel.dk>
Date:   Mon, 12 Jun 2023 22:55:49 -0400
In-Reply-To: <77293e8f-fbd2-be08-765a-513460781455@kernel.dk> (Jens Axboe's
        message of "Mon, 12 Jun 2023 19:09:41 -0600")
Message-ID: <87ilbs1362.fsf_-_@suse.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,T_SPF_HELO_TEMPERROR,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Jens Axboe <axboe@kernel.dk> writes:

> On 6/12/23 5:00?PM, Gabriel Krisman Bertazi wrote:

>>>> Even with an asynchronous model, it might make sense to halt execution
>>>> of further queued operations until futex completes.  I think
>>>> IOSQE_IO_DRAIN is a barrier only against the submission part, so it
>>>> wouldn't hep.  Is there a way to ensure this ordering?
>>>
>>> You'd use link for that - link whatever depends on the wake to the futex
>>> wait. Or just queue it up once you reap the wait completion, when that
>>> is posted because we got woken.
>> 
>> The challenge of linked requests, in my opinion, is that once a link
>> chain starts, everything needs to be link together, and a single error
>> fails everything, which is ok when operations are related, but
>> not so much when doing IO to different files from the same ring.
>
> Not quite sure if you're misunderstanding links, or just have a
> different use case in mind. You can certainly have several independent
> chains of links.

I might be. Or my use case might be bogus. Please, correct me if either
is the case.

My understanding is that a link is a sequence of commands all carrying
the IOSQE_IO_LINK flag.  io_uring guarantees the ordering within the
link and, if a previous command fails, the rest of the link chain is
aborted.

But, if I have independent commands to submit in between, i.e. on a
different fd, I might want an intermediary operation to not be dependent
on the rest of the link without breaking the chain.  Most of the time I
know ahead of time the entire chain, and I can batch the operations
together.  But, I think it might be a problem specifically for some
unbounded commands like FUTEX_WAIT and recv.  I want a specific
operation to depend on a recv, but I might not be able to specify ahead
of time all of the dependent operations. I'd need to wait for a recv
command to complete and only then issue the dependency, to guarantee
ordering, or I make sure that everything I put on the ring in the
meantime is part of one big link submitted sequentially.

A related issue/example that comes to mind would be two recvs/sends
against the same socket.  When doing a syscall, I know the first recv
will return ahead of the second because it is, well, synchronous.  On
io_uring, I think it must be a link.  I might be recv'ing a huge stream
from the network, and I can't tell if the packet is done on a single
recv.  I could have to issue a second recv but I either make it linked
ahead of time, or I need to wait for the first recv to complete, to only
then submit the second one.  The problem is the ordering of recvs; from
my understanding of the code, I cannot assure the first recv will
complete before the second, without a link.

Sorry if I'm wrong and there are ways around it, but it is a struggling
points for me at the moment with using io_uring.

-- 
Gabriel Krisman Bertazi
