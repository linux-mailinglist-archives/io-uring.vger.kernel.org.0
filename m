Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D355172CAFC
	for <lists+io-uring@lfdr.de>; Mon, 12 Jun 2023 18:06:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230295AbjFLQGn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 12 Jun 2023 12:06:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229877AbjFLQGn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 12 Jun 2023 12:06:43 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 099B4BB
        for <io-uring@vger.kernel.org>; Mon, 12 Jun 2023 09:06:42 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id B19422281C;
        Mon, 12 Jun 2023 16:06:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1686586000; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lW61fzkuIUGwTcNAoSwdAucD4HP0C4z1xBiSc7NSL+Y=;
        b=oA0fAef7SVpYzcDb1Wlqo8plfPhvVqGDrxJXPsQ2I8rzKo7h+1krkIWKb8NMA6ZamEz+R8
        z/wZM1WbMtSxXcb7YYhywk06H//i25vP8NdrYE3ZKPA8NgotCKF97jDhLhn6hUQX4DfqEP
        mYmr7PXYkNvDO2UQStek6C4biuQUAmg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1686586000;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lW61fzkuIUGwTcNAoSwdAucD4HP0C4z1xBiSc7NSL+Y=;
        b=zqYnR5J/ZxSZlBWGuiAVC6Nfs5qyt+wabeggvB/QQygBa+58HeWLF5a04W3v/8JTdw4LPh
        rrYWuJmYgHS4OYDA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 7A8351357F;
        Mon, 12 Jun 2023 16:06:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id g8s0GJBCh2Q6TAAAMHmgww
        (envelope-from <krisman@suse.de>); Mon, 12 Jun 2023 16:06:40 +0000
From:   Gabriel Krisman Bertazi <krisman@suse.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, andres@anarazel.de
Subject: Re: [PATCH 5/6] io_uring: add support for futex wake and wait
References: <20230609183125.673140-1-axboe@kernel.dk>
        <20230609183125.673140-6-axboe@kernel.dk>
Date:   Mon, 12 Jun 2023 12:06:39 -0400
In-Reply-To: <20230609183125.673140-6-axboe@kernel.dk> (Jens Axboe's message
        of "Fri, 9 Jun 2023 12:31:24 -0600")
Message-ID: <87352w3bsg.fsf@suse.de>
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

> Add support for FUTEX_WAKE/WAIT primitives.

This is great.  I was so sure io_uring had this support already for some
reason.  I might have dreamed it.

The semantics are tricky, though. You might want to CC peterZ and tglx
directly.

> IORING_OP_FUTEX_WAKE is mix of FUTEX_WAKE and FUTEX_WAKE_BITSET, as
> it does support passing in a bitset.

As far as I know, the _BITSET variant are not commonly used in the
current interface.  I haven't seen any code that really benefits from
it.

> Similary, IORING_OP_FUTEX_WAIT is a mix of FUTEX_WAIT and
> FUTEX_WAIT_BITSET.

But it is definitely safe to have a single one, basically with the
_BITSET semantics.

> FUTEX_WAKE is straight forward, as we can always just do those inline.
> FUTEX_WAIT will queue the futex with an appropriate callback, and
> that callback will in turn post a CQE when it has triggered.

Even with an asynchronous model, it might make sense to halt execution
of further queued operations until futex completes.  I think
IOSQE_IO_DRAIN is a barrier only against the submission part, so it
wouldn't hep.  Is there a way to ensure this ordering?

I know, it goes against the asynchronous nature of io_uring, but I think
it might be a valid use case. Say we extend FUTEX_WAIT with a way to
acquire the futex in kernel space.  Then, when the CQE returns, we know
the lock is acquired.  if we can queue dependencies on that (stronger
than the link semantics), we could queue operations to be executed once
the lock is taken. Makes sense?

> Cancelations are supported, both from the application point-of-view,
> but also to be able to cancel pending waits if the ring exits before
> all events have occurred.
>
> This is just the barebones wait/wake support. Features to be added
> later:

One item high on my wishlist would be the futexv semantics (wait on any
of a set of futexes).  It cannot be implemented by issuing several
FUTEX_WAIT.

-- 
Gabriel Krisman Bertazi
