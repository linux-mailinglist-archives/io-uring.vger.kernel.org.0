Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27037797C14
	for <lists+io-uring@lfdr.de>; Thu,  7 Sep 2023 20:39:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344211AbjIGSjU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 7 Sep 2023 14:39:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230447AbjIGSjR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 7 Sep 2023 14:39:17 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9087D90
        for <io-uring@vger.kernel.org>; Thu,  7 Sep 2023 11:39:13 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 4B5691F461;
        Thu,  7 Sep 2023 18:39:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1694111952; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=H438xnbvcbk+6PRBQftcP2C9ONqpKcwrvOTCmHnCzw0=;
        b=zUYnPJkpMHApXqycX+voaorRDb1BOyMkHHx64b47jsSeqBLoEqR2GU48lFHxl/XFYCf/qM
        cCVQDOgnBLyTuu6LV/Z9UC+0nG6G1htU1/1kxOHknhansq1kQ2jX4O1K+PwkdVXvVs1hvj
        1R/DUfc9dxg5mgYmIfNuovWUruv65m8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1694111952;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=H438xnbvcbk+6PRBQftcP2C9ONqpKcwrvOTCmHnCzw0=;
        b=zm/MtEvfdJ68Orx8XM8730g04/FfMa4rBuk9eZAYPAkeANfUPjbSizh7MkXCJF0Li6Yor9
        gIjnpHVfFpt9iwCA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 168B0138F9;
        Thu,  7 Sep 2023 18:39:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id l5mLO88Y+mRKWgAAMHmgww
        (envelope-from <krisman@suse.de>); Thu, 07 Sep 2023 18:39:11 +0000
From:   Gabriel Krisman Bertazi <krisman@suse.de>
To:     axboe@kernel.dk
Cc:     io-uring@vger.kernel.org
Subject: Re: [PATCH] io_uring: Use slab for struct io_buffer objects
In-Reply-To: <20230830003634.31568-1-krisman@suse.de> (Gabriel Krisman
        Bertazi's message of "Tue, 29 Aug 2023 20:36:34 -0400")
References: <20230830003634.31568-1-krisman@suse.de>
Date:   Thu, 07 Sep 2023 14:39:10 -0400
Message-ID: <87sf7pakvl.fsf@suse.de>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Gabriel Krisman Bertazi <krisman@suse.de> writes:

> The allocation of struct io_buffer for metadata of provided buffers is
> done through a custom allocator that directly gets pages and
> fragments them.  But, slab would do just fine, as this is not a hot path
> (in fact, it is a deprecated feature) and, by keeping a custom allocator
> implementation we lose benefits like tracking, poisoning,
> sanitizers. Finally, the custom code is more complex and requires
> keeping the list of pages in struct ctx for no good reason.  This patch
> cleans this path up and just uses slab.
>
> I microbenchmarked it by forcing the allocation of a large number of
> objects with the least number of io_uring commands possible (keeping
> nbufs=USHRT_MAX), with and without the patch.  There is a slight
> increase in time spent in the allocation with slab, of course, but even
> when allocating to system resources exhaustion, which is not very
> realistic and happened around 1/2 billion provided buffers for me, it
> wasn't a significant hit in system time.  Specially if we think of a
> real-world scenario, an application doing register/unregister of
> provided buffers will hit ctx->io_buffers_cache more often than actually
> going to slab.
>
> Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>

Hi Jens,

Any feedback on this?

-- 
Gabriel Krisman Bertazi
