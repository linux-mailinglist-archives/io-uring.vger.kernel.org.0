Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 268E077E85F
	for <lists+io-uring@lfdr.de>; Wed, 16 Aug 2023 20:11:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344291AbjHPSLL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Aug 2023 14:11:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344392AbjHPSKm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Aug 2023 14:10:42 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4398FE4C;
        Wed, 16 Aug 2023 11:10:41 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id DAC321F74A;
        Wed, 16 Aug 2023 18:10:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1692209439; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GA+lA+X5klcJsHYhvodnqY7nRG/CebjFbGv9hxHM5Mo=;
        b=QmB5iDu8SPF3+fvpVS5SddkhGCWu9OPoorDmgLqq/rPnNKIZba9FNwHbFJGaiONa4iIsCB
        P7kS1oTxBpBqUUpCeL6TiaT5IqYWQlKI1SS1/ulcSbdpkw9Cb2RkFXKLvkFLiaYAIkgMZx
        nWmdZKFewpA5kIl7cDgtjKrQTxnOr3o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1692209439;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GA+lA+X5klcJsHYhvodnqY7nRG/CebjFbGv9hxHM5Mo=;
        b=sh5hran2dYylPF3oJPzpcJgLlHVK7RoopWqScxu7qWwqbP8THRHQVXjL0UWXC3WvHE4t+U
        r76LLZUhPy2Oq4BA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 9F25C133F2;
        Wed, 16 Aug 2023 18:10:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id ooOzIB8R3WR/ZgAAMHmgww
        (envelope-from <krisman@suse.de>); Wed, 16 Aug 2023 18:10:39 +0000
From:   Gabriel Krisman Bertazi <krisman@suse.de>
To:     Jeff Moyer <jmoyer@redhat.com>
Cc:     matteorizzo@google.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
        axboe@kernel.dk, asml.silence@gmail.com, corbet@lwn.net,
        akpm@linux-foundation.org, keescook@chromium.org,
        ribalda@chromium.org, rostedt@goodmis.org, jannh@google.com,
        chenhuacai@kernel.org, gpiccoli@igalia.com, ldufour@linux.ibm.com,
        evn@google.com, poprdi@google.com, jordyzomer@google.com,
        andres@anarazel.de
Subject: Re: [PATCH v4] io_uring: add a sysctl to disable io_uring system-wide
In-Reply-To: <x49wmxuub14.fsf@segfault.boston.devel.redhat.com> (Jeff Moyer's
        message of "Wed, 16 Aug 2023 13:55:51 -0400")
Organization: SUSE
References: <x49wmxuub14.fsf@segfault.boston.devel.redhat.com>
Date:   Wed, 16 Aug 2023 14:10:38 -0400
Message-ID: <87cyzm504h.fsf@suse.de>
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

Jeff Moyer <jmoyer@redhat.com> writes:

> From: Matteo Rizzo <matteorizzo@google.com>
>
> Introduce a new sysctl (io_uring_disabled) which can be either 0, 1, or
> 2. When 0 (the default), all processes are allowed to create io_uring
> instances, which is the current behavior.  When 1, io_uring creation is
> disabled (io_uring_setup() will fail with -EPERM) for processes not in
> the kernel.io_uring_group group.  When 2, calls to io_uring_setup() fail
> with -EPERM regardless of privilege.
>
> Signed-off-by: Matteo Rizzo <matteorizzo@google.com>
> [JEM: modified to add io_uring_group]
> Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
>
> ---
> v4:
>
> * Add a kernel.io_uring_group sysctl to hold a group id that is allowed
>   to use io_uring.  One thing worth pointing out is that, when a group
>   is specified, only users in that group can create an io_uring.  That
>   means that if the root user is not in that group, root can not make
>   use of io_uring.

Rejecting root if it's not in the group doesn't make much sense to
me. Of course, root can always just add itself to the group, so it is
not a security feature. But I'd expect 'sudo <smth>' to not start giving
EPERM based on user group settings.  Can you make CAP_SYS_ADMIN
always allowed for option 1?

>   I also wrote unit tests for liburing.  I'll post that as well if there
>   is consensus on this approach.

I'm fine with this approach as it allow me to easily reject non-root users.

-- 
Gabriel Krisman Bertazi
