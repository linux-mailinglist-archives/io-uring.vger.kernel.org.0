Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DB527766EE
	for <lists+io-uring@lfdr.de>; Wed,  9 Aug 2023 20:04:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229636AbjHISEg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 9 Aug 2023 14:04:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbjHISEg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 9 Aug 2023 14:04:36 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75ABA171D;
        Wed,  9 Aug 2023 11:04:35 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 3B3131F74B;
        Wed,  9 Aug 2023 18:04:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1691604274; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AO7oR/TuDgAue/fs6C3qS+7YNyq+qT7GS9MtqGPmkhE=;
        b=Aeq0QFmMguDxo395uqqBp+NGRQd2H0RXE5EndS/WhV9B1RpKfrriBiGGhNB7oQBq4ozL+B
        B7aenQze7zdcGwBOuouhoSYZcfmOTFIh9duncvB6EtEEe1s4+wY/KsBWywvZsokt8YspE2
        D2G+W5GDAI8/e7k29Uzue2XtQEEIbWA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1691604274;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AO7oR/TuDgAue/fs6C3qS+7YNyq+qT7GS9MtqGPmkhE=;
        b=PGj97HLDZNK2k3Av7tDdL+n4UfOzA+Q439IbXJD3FbLIxHZ1EclbLFTLqFEWcnSSDnk+LU
        yAXvStsS4bzEOPDQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 056BD13251;
        Wed,  9 Aug 2023 18:04:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id yqNyNzHV02TSDwAAMHmgww
        (envelope-from <krisman@suse.de>); Wed, 09 Aug 2023 18:04:33 +0000
From:   Gabriel Krisman Bertazi <krisman@suse.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        peterz@infradead.org, andres@anarazel.de, tglx@linutronix.de
Subject: Re: [PATCH 03/12] futex: Flag conversion
In-Reply-To: <20230728164235.1318118-4-axboe@kernel.dk> (Jens Axboe's message
        of "Fri, 28 Jul 2023 10:42:26 -0600")
References: <20230728164235.1318118-1-axboe@kernel.dk>
        <20230728164235.1318118-4-axboe@kernel.dk>
Date:   Wed, 09 Aug 2023 14:04:32 -0400
Message-ID: <87sf8s6qj3.fsf@suse.de>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Jens Axboe <axboe@kernel.dk> writes:

> From: Peter Zijlstra <peterz@infradead.org>
>
> Futex has 3 sets of flags:
>
>  - legacy futex op bits
>  - futex2 flags
>  - internal flags
>
> Add a few helpers to convert from the API flags into the internal
> flags.
>
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>  kernel/futex/futex.h    | 64 +++++++++++++++++++++++++++++++++++++++--
>  kernel/futex/syscalls.c | 24 ++++++----------
>  kernel/futex/waitwake.c |  4 +--
>  3 files changed, 72 insertions(+), 20 deletions(-)
>
> diff --git a/kernel/futex/futex.h b/kernel/futex/futex.h
> index b5379c0e6d6d..c0e04599904a 100644
> --- a/kernel/futex/futex.h
> +++ b/kernel/futex/futex.h
> @@ -5,6 +5,7 @@
>  #include <linux/futex.h>
>  #include <linux/rtmutex.h>
>  #include <linux/sched/wake_q.h>
> +#include <linux/compat.h>
>  
>  #ifdef CONFIG_PREEMPT_RT
>  #include <linux/rcuwait.h>
> @@ -16,8 +17,15 @@
>   * Futex flags used to encode options to functions and preserve them across
>   * restarts.
>   */
> +#define FLAGS_SIZE_8		0x00
> +#define FLAGS_SIZE_16		0x01
> +#define FLAGS_SIZE_32		0x02
> +#define FLAGS_SIZE_64		0x03
> +
> +#define FLAGS_SIZE_MASK		0x03
> +
>  #ifdef CONFIG_MMU
> -# define FLAGS_SHARED		0x01
> +# define FLAGS_SHARED		0x10
>  #else
>  /*
>   * NOMMU does not have per process address space. Let the compiler optimize
> @@ -25,8 +33,58 @@
>   */
>  # define FLAGS_SHARED		0x00
>  #endif
> -#define FLAGS_CLOCKRT		0x02
> -#define FLAGS_HAS_TIMEOUT	0x04
> +#define FLAGS_CLOCKRT		0x20
> +#define FLAGS_HAS_TIMEOUT	0x40
> +#define FLAGS_NUMA		0x80
> +
> +/* FUTEX_ to FLAGS_ */
> +static inline unsigned int futex_to_flags(unsigned int op)
> +{
> +	unsigned int flags = FLAGS_SIZE_32;
> +
> +	if (!(op & FUTEX_PRIVATE_FLAG))
> +		flags |= FLAGS_SHARED;
> +
> +	if (op & FUTEX_CLOCK_REALTIME)
> +		flags |= FLAGS_CLOCKRT;
> +
> +	return flags;
> +}
> +
> +/* FUTEX2_ to FLAGS_ */
> +static inline unsigned int futex2_to_flags(unsigned int flags2)
> +{
> +	unsigned int flags = flags2 & FUTEX2_64;

FUTEX2_64 -> FLAGS_SIZE_MASK

> +
> +	if (!(flags2 & FUTEX2_PRIVATE))
> +		flags |= FLAGS_SHARED;
> +
> +	if (flags2 & FUTEX2_NUMA)
> +		flags |= FLAGS_NUMA;
> +
> +	return flags;
> +}
> +
> +static inline bool futex_flags_valid(unsigned int flags)
> +{
> +	/* Only 64bit futexes for 64bit code */
> +	if (!IS_ENABLED(CONFIG_64BIT) || in_compat_syscall()) {
> +		if ((flags & FLAGS_SIZE_MASK) == FLAGS_SIZE_64)
> +			return false;
> +	}

I read the comment above as '64bit code can only have 64bit futexes',
which is obviously wrong and not what the code is checking.
Something like this would be better:

/* Reject 64bit futexes on !64bit code. */

Or Perhaps make it generic:

/* Don't allow futexes larger than the word size */
  if (futex_size(flags) > (__WORDSIZE/8) || in_compat_syscall())

-- 
Gabriel Krisman Bertazi
