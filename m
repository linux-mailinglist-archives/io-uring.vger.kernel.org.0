Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85A2F535016
	for <lists+io-uring@lfdr.de>; Thu, 26 May 2022 15:39:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239537AbiEZNjl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 26 May 2022 09:39:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231466AbiEZNjk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 26 May 2022 09:39:40 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7ADA5E75D;
        Thu, 26 May 2022 06:39:39 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 836C41F8D6;
        Thu, 26 May 2022 13:39:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1653572378; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=EXgsltI1EydYTLlZIVMiKvkGRiYB66sbbcE1wLmYWJM=;
        b=b+fUN704H2bSX5WCorToflDv4rxnd9dG/Pssx4gITvr/2G8VyQJkWT2dvl0tGI72bgBQ/r
        KAB08iupTTN9u8VHbKmrWQbmP7Rw12kePJURw8FHiymNxXjHCxO8XdLaEDUKaMQIi+T6Fo
        WMG0NgSHWJAYcOoKtn3IU+y5gtfyXz8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1653572378;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=EXgsltI1EydYTLlZIVMiKvkGRiYB66sbbcE1wLmYWJM=;
        b=bXnW+z7Tqd/Ioj7YiGWNRgVoY6KeQ74/6Kdmx0kB5R27Bmq/Q4TGGl52873+ciniqGkczc
        5NaLd3EYxuBjvyAg==
Received: from quack3.suse.cz (unknown [10.100.224.230])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 3A6A22C141;
        Thu, 26 May 2022 13:39:38 +0000 (UTC)
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id 88DC4A0632; Thu, 26 May 2022 15:39:37 +0200 (CEST)
Date:   Thu, 26 May 2022 15:39:37 +0200
From:   Jan Kara <jack@suse.cz>
To:     Stefan Roesch <shr@fb.com>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com, jack@suse.cz, hch@infradead.org
Subject: Re: [PATCH v5 05/16] iomap: Add async buffered write support
Message-ID: <20220526133937.a524uiczmiphzgxr@quack3.lan>
References: <20220525223432.205676-1-shr@fb.com>
 <20220525223432.205676-6-shr@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220525223432.205676-6-shr@fb.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed 25-05-22 15:34:21, Stefan Roesch wrote:
> This adds async buffered write support to iomap.
> 
> This replaces the call to balance_dirty_pages_ratelimited() with the
> call to balance_dirty_pages_ratelimited_flags. This allows to specify if
> the write request is async or not.
> 
> In addition this also moves the above function call to the beginning of
> the function. If the function call is at the end of the function and the
> decision is made to throttle writes, then there is no request that
> io-uring can wait on. By moving it to the beginning of the function, the
> write request is not issued, but returns -EAGAIN instead. io-uring will
> punt the request and process it in the io-worker.
> 
> By moving the function call to the beginning of the function, the write
> throttling will happen one page later.
> 
> Signed-off-by: Stefan Roesch <shr@fb.com>

Looks good to me. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
