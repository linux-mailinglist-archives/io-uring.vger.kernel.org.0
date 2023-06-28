Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 980FA741301
	for <lists+io-uring@lfdr.de>; Wed, 28 Jun 2023 15:50:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231583AbjF1Nuo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 28 Jun 2023 09:50:44 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:58426 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229845AbjF1Nuk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 28 Jun 2023 09:50:40 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id C56542189A;
        Wed, 28 Jun 2023 13:50:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1687960238; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VkBXGlD0oggkcayYs7pBu1iDrnzl5z5B5f3CsfkM3Qk=;
        b=vmxpqRGHSrIk0MJ6BIwhVcjDHN0kyaV/LpTIdBczjKL+pdL5PQUEN48KMitsw+o1GEb/J2
        lW/ghisQa6LkuOEA8ULyHfIRoWy0zTPpIkNhokT4bn9a8qnLCCgoUQMm2NbaEBZvyeI6NG
        mZX8D69IhFSSTCybMcSXDW0yNpbbmZQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1687960238;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VkBXGlD0oggkcayYs7pBu1iDrnzl5z5B5f3CsfkM3Qk=;
        b=E3b6HytdPIOXwgM/OFchWEnEhNlTxHFVElAkORBeleDLqTurnRzWlloGvN1Z9EZDazaupL
        m8ES9d3VFhNV+QBw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 85150138E8;
        Wed, 28 Jun 2023 13:50:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id CsbhGq46nGQgDAAAMHmgww
        (envelope-from <krisman@suse.de>); Wed, 28 Jun 2023 13:50:38 +0000
From:   Gabriel Krisman Bertazi <krisman@suse.de>
To:     Matteo Rizzo <matteorizzo@google.com>
Cc:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org, jordyzomer@google.com, evn@google.com,
        poprdi@google.com, corbet@lwn.net, axboe@kernel.dk,
        asml.silence@gmail.com, akpm@linux-foundation.org,
        keescook@chromium.org, rostedt@goodmis.org,
        dave.hansen@linux.intel.com, ribalda@chromium.org,
        chenhuacai@kernel.org, steve@sk2.org, gpiccoli@igalia.com,
        ldufour@linux.ibm.com
Subject: Re: [PATCH 1/1] Add a new sysctl to disable io_uring system-wide
References: <20230627120058.2214509-1-matteorizzo@google.com>
        <20230627120058.2214509-2-matteorizzo@google.com>
Date:   Wed, 28 Jun 2023 09:50:37 -0400
In-Reply-To: <20230627120058.2214509-2-matteorizzo@google.com> (Matteo Rizzo's
        message of "Tue, 27 Jun 2023 12:00:58 +0000")
Message-ID: <87ilb7ofv6.fsf@suse.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Matteo Rizzo <matteorizzo@google.com> writes:

> diff --git a/Documentation/admin-guide/sysctl/kernel.rst b/Documentation/admin-guide/sysctl/kernel.rst
> index d85d90f5d000..3c53a238332a 100644
> --- a/Documentation/admin-guide/sysctl/kernel.rst
> +++ b/Documentation/admin-guide/sysctl/kernel.rst
> @@ -450,6 +450,20 @@ this allows system administrators to override the
>  ``IA64_THREAD_UAC_NOPRINT`` ``prctl`` and avoid logs being flooded.
>  
>  
> +io_uring_disabled
> +=========================
> +
> +Prevents all processes from creating new io_uring instances. Enabling this
> +shrinks the kernel's attack surface.
> +
> += =============================================================
> +0 All processes can create io_uring instances as normal. This is the default
> +  setting.
> +1 io_uring is disabled. io_uring_setup always fails with -EPERM. Existing
> +  io_uring instances can still be used.
> += =============================================================

I had an internal request for something like this recently.  If we go
this route, we could use a intermediary option that limits io_uring
to root processes only.

-- 
Gabriel Krisman Bertazi
