Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E2BA52A024
	for <lists+io-uring@lfdr.de>; Tue, 17 May 2022 13:15:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244671AbiEQLPA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 17 May 2022 07:15:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343821AbiEQLOu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 17 May 2022 07:14:50 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A171B4B1EE;
        Tue, 17 May 2022 04:14:49 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 51B4D1F383;
        Tue, 17 May 2022 11:14:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1652786088; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yA+3NgBf3IrpMWWgGDxlwJ/B12UU7TeQ4+mIhyTdo/w=;
        b=EsnrGk4LGgGW4gH6NhxulNpyVbPhOUhrK7XBH390IIvHalNrRGPskDOCmKyJZ7TqXBLFf5
        dOlICJaxM0omjE8nCLU/0Y4+MlE1eoqAwtfwFkmNfhUJeet4Ct8wQ1kY+/VWEjbRb1VqB/
        EYo8b/RRtTAfSRyLnXgI9KKyVi9iJK4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1652786088;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yA+3NgBf3IrpMWWgGDxlwJ/B12UU7TeQ4+mIhyTdo/w=;
        b=+SUXYUymaY7d3Y4hn5yYLYxdt5z4zyefgezKKodncu/m1PKzpiRSRv6J8QhHA1/e0mcBIN
        BszDOF4oxq/q5vCw==
Received: from quack3.suse.cz (unknown [10.163.43.118])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 260612C141;
        Tue, 17 May 2022 11:14:48 +0000 (UTC)
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id 97AB4A0631; Tue, 17 May 2022 13:14:47 +0200 (CEST)
Date:   Tue, 17 May 2022 13:14:47 +0200
From:   Jan Kara <jack@suse.cz>
To:     Stefan Roesch <shr@fb.com>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com, jack@suse.cz
Subject: Re: [RFC PATCH v2 04/16] iomap: add async buffered write support
Message-ID: <20220517111447.bzzmdbmx6cebnugc@quack3.lan>
References: <20220516164718.2419891-1-shr@fb.com>
 <20220516164718.2419891-5-shr@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220516164718.2419891-5-shr@fb.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon 16-05-22 09:47:06, Stefan Roesch wrote:
> This adds async buffered write support to iomap. The support is focused
> on the changes necessary to support XFS with iomap.
> 
> Support for other filesystems might require additional changes.
> 
> Signed-off-by: Stefan Roesch <shr@fb.com>
> ---
>  fs/iomap/buffered-io.c | 21 ++++++++++++++++++++-
>  1 file changed, 20 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> index 1ffdc7078e7d..ceb3091f94c2 100644
> --- a/fs/iomap/buffered-io.c
> +++ b/fs/iomap/buffered-io.c
> @@ -580,13 +580,20 @@ static int __iomap_write_begin(const struct iomap_iter *iter, loff_t pos,
>  	size_t from = offset_in_folio(folio, pos), to = from + len;
>  	size_t poff, plen;
>  	gfp_t  gfp = GFP_NOFS | __GFP_NOFAIL;
> +	bool no_wait = (iter->flags & IOMAP_NOWAIT);
> +
> +	if (no_wait)
> +		gfp = GFP_NOIO;

GFP_NOIO means that direct reclaim is still allowed. Not sure whether you
want to enter direct reclaim from io_uring fast path because in theory that
can still sleep. GFP_NOWAIT would be a more natural choice...

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
