Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3256D75CF60
	for <lists+io-uring@lfdr.de>; Fri, 21 Jul 2023 18:32:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230218AbjGUQcI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 21 Jul 2023 12:32:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbjGUQbw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 21 Jul 2023 12:31:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F28B2733;
        Fri, 21 Jul 2023 09:30:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3DB9461D2A;
        Fri, 21 Jul 2023 16:29:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D806C433C7;
        Fri, 21 Jul 2023 16:29:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689956944;
        bh=9Cjv9m6b89mw+zcZE1oGAUXtMQkvrgVZGh+qdl/HRFs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iV2MLLJfV2HL0M41RsMfzmkkhZgSXLXxxyVbRls3aPC/Biv1CIippiZwecsq/rb4G
         g1iEMhuSeue1eD8jQ5UNNZ8mDjx1Pa9gNfnU3ufyoued9PQZOgXV10irH9YSTB/zwS
         PJ+nSHonWTEwcdRQQ//JOM08kkLv5rKqztRRnpE8C1lHtjFD2UgcQs02Xosyuq/bry
         XRC8bk7HPq6OECR4udkzAUA9V3xkYUvoyREQOyqKlQRzew/mwgUEPZudtjo0MPf5Iz
         eVOps2HVKc/PEW/j/9pteMmFJfiUbt7P2wki1sikIMbWLhQv1RK+/zUjwwimzSqBke
         /3iMEhoV7ZdQw==
Date:   Fri, 21 Jul 2023 09:29:04 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de,
        andres@anarazel.de, david@fromorbit.com
Subject: Re: [PATCH 9/9] iomap: use an unsigned type for IOMAP_DIO_* defines
Message-ID: <20230721162904.GU11352@frogsfrogsfrogs>
References: <20230721161650.319414-1-axboe@kernel.dk>
 <20230721161650.319414-10-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230721161650.319414-10-axboe@kernel.dk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Jul 21, 2023 at 10:16:50AM -0600, Jens Axboe wrote:
> IOMAP_DIO_DIRTY shifts by 31 bits, which makes UBSAN unhappy. Clean up
> all the defines by making the shifted value an unsigned value.
> 
> Reported-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>

Thanks!
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/iomap/direct-io.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
> index ae9046d16d71..dc9fe2ac9136 100644
> --- a/fs/iomap/direct-io.c
> +++ b/fs/iomap/direct-io.c
> @@ -20,12 +20,12 @@
>   * Private flags for iomap_dio, must not overlap with the public ones in
>   * iomap.h:
>   */
> -#define IOMAP_DIO_CALLER_COMP	(1 << 26)
> -#define IOMAP_DIO_INLINE_COMP	(1 << 27)
> -#define IOMAP_DIO_WRITE_THROUGH	(1 << 28)
> -#define IOMAP_DIO_NEED_SYNC	(1 << 29)
> -#define IOMAP_DIO_WRITE		(1 << 30)
> -#define IOMAP_DIO_DIRTY		(1 << 31)
> +#define IOMAP_DIO_CALLER_COMP	(1U << 26)
> +#define IOMAP_DIO_INLINE_COMP	(1U << 27)
> +#define IOMAP_DIO_WRITE_THROUGH	(1U << 28)
> +#define IOMAP_DIO_NEED_SYNC	(1U << 29)
> +#define IOMAP_DIO_WRITE		(1U << 30)
> +#define IOMAP_DIO_DIRTY		(1U << 31)
>  
>  struct iomap_dio {
>  	struct kiocb		*iocb;
> -- 
> 2.40.1
> 
