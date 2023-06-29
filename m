Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1F6C742BF9
	for <lists+io-uring@lfdr.de>; Thu, 29 Jun 2023 20:38:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232761AbjF2Sg7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 29 Jun 2023 14:36:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232351AbjF2Sgl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 29 Jun 2023 14:36:41 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89511E4;
        Thu, 29 Jun 2023 11:36:40 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id F3D5A1F74C;
        Thu, 29 Jun 2023 18:36:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1688063799; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NpDYPW1OunBedfGdGzw//TqToXDXavsydJ4o33sx74A=;
        b=ipKHiUiQ6qzcSpd/TokouNutQLqy2LdK4UkX03Ga2GJb/az+OtniBt0jN0L0d9qgcL7mXI
        g0HUYfMcgVVnpNLJrPe25D90ZcbY93evm3xf4KHGazyF8rwOjbfGzXgdykHAVcWU3E/gNt
        VoPsxhY64T7hraqzjQaW+e995awKs1E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1688063799;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NpDYPW1OunBedfGdGzw//TqToXDXavsydJ4o33sx74A=;
        b=NHxMeELHtPZieSmsEYTo39T7CUlgWs3BqZPrJ380WjaUbIMxygZ8fW4JRT6VecAf2dDya+
        KG+JNzXg6IRvb8Dw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id B3AAB139FF;
        Thu, 29 Jun 2023 18:36:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id m/VpJjbPnWRXDgAAMHmgww
        (envelope-from <krisman@suse.de>); Thu, 29 Jun 2023 18:36:38 +0000
From:   Gabriel Krisman Bertazi <krisman@suse.de>
To:     Matteo Rizzo <matteorizzo@google.com>
Cc:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org, jordyzomer@google.com, evn@google.com,
        poprdi@google.com, corbet@lwn.net, axboe@kernel.dk,
        asml.silence@gmail.com, akpm@linux-foundation.org,
        keescook@chromium.org, rostedt@goodmis.org,
        dave.hansen@linux.intel.com, ribalda@chromium.org,
        chenhuacai@kernel.org, steve@sk2.org, gpiccoli@igalia.com,
        ldufour@linux.ibm.com, bhe@redhat.com, oleksandr@natalenko.name
Subject: Re: [PATCH v2 1/1] Add a new sysctl to disable io_uring system-wide
References: <20230629132711.1712536-1-matteorizzo@google.com>
        <20230629132711.1712536-2-matteorizzo@google.com>
Date:   Thu, 29 Jun 2023 14:36:37 -0400
In-Reply-To: <20230629132711.1712536-2-matteorizzo@google.com> (Matteo Rizzo's
        message of "Thu, 29 Jun 2023 13:27:11 +0000")
Message-ID: <87bkgyt8sq.fsf@suse.de>
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

Matteo Rizzo <matteorizzo@google.com> writes:

> Introduce a new sysctl (io_uring_disabled) which can be either 0, 1,
> or 2. When 0 (the default), all processes are allowed to create io_uring
> instances, which is the current behavior. When 1, all calls to
> io_uring_setup fail with -EPERM unless the calling process has
> CAP_SYS_ADMIN. When 2, calls to io_uring_setup fail with -EPERM
> regardless of privilege.
>
> Signed-off-by: Matteo Rizzo <matteorizzo@google.com>
> ---

Thanks for adding the extra level for root-only rings.

The patch looks good to me.

Reviewed-by: Gabriel Krisman Bertazi <krisman@suse.de>

-- 
Gabriel Krisman Bertazi
