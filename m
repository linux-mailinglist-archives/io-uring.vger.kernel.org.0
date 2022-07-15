Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD6215764B1
	for <lists+io-uring@lfdr.de>; Fri, 15 Jul 2022 17:45:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229573AbiGOPpF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 15 Jul 2022 11:45:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235771AbiGOPos (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 15 Jul 2022 11:44:48 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33A803B3;
        Fri, 15 Jul 2022 08:44:47 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id E15F220247;
        Fri, 15 Jul 2022 15:44:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1657899885; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nL34y1qYFraBx68T2BEQkpXsOQD15F7byblMz6APRsw=;
        b=tiAdnkdx/G9tsjwcOjDwBrX4tMh3u0Gj4OHzRtHLpRlZyHejpi/CsTEogQxckjnc0NKPOv
        YT/zJtIRKJ7s1KVtQhaeWIeVhxeex6ZDTn8WfKgAE6e5Uh6lhUkiatGsSmScWNn6/l5zU9
        DmllE/Be5BVGWwjxh86l2r8JWfNQ9/M=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id B937C13AC3;
        Fri, 15 Jul 2022 15:44:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id iloYLG2L0WJHYQAAMHmgww
        (envelope-from <mkoutny@suse.com>); Fri, 15 Jul 2022 15:44:45 +0000
Date:   Fri, 15 Jul 2022 17:44:44 +0200
From:   Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
To:     Usama Arif <usama.arif@bytedance.com>
Cc:     io-uring@vger.kernel.org, axboe@kernel.dk, asml.silence@gmail.com,
        linux-kernel@vger.kernel.org, fam.zheng@bytedance.com
Subject: Re: [PATCH v6 5/5] io_uring: remove ring quiesce for
 io_uring_register
Message-ID: <20220715154444.GA17123@blackbody.suse.cz>
References: <20220204145117.1186568-1-usama.arif@bytedance.com>
 <20220204145117.1186568-6-usama.arif@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220204145117.1186568-6-usama.arif@bytedance.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello.

On Fri, Feb 04, 2022 at 02:51:17PM +0000, Usama Arif <usama.arif@bytedance.com> wrote:
> -	percpu_ref_resurrect(ref);
> [...]
> -		percpu_ref_reinit(&ctx->refs);

It seems to me that this patch could have also changed

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1911,7 +1911,7 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
        ctx->dummy_ubuf->ubuf = -1UL;

        if (percpu_ref_init(&ctx->refs, io_ring_ctx_ref_free,
-                           PERCPU_REF_ALLOW_REINIT, GFP_KERNEL))
+                           0, GFP_KERNEL))
                goto err;

        ctx->flags = p->flags;

Or are there any plans to still use the reinit/resurrect functionality
of the percpu counter?

Thanks,
Michal
