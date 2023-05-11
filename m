Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF9FC6FF05D
	for <lists+io-uring@lfdr.de>; Thu, 11 May 2023 13:03:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237922AbjEKLDo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 11 May 2023 07:03:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231843AbjEKLDn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 11 May 2023 07:03:43 -0400
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2897119A7;
        Thu, 11 May 2023 04:03:41 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id C49A5C022; Thu, 11 May 2023 13:03:36 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1683803016; bh=TnIrx9Sr+YwwzAQRDNPaH1tRKUc6B/kK4MrTl299Rxw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=F8Y0+TDyglj+K7TYRcAp2F8QRXeMW6KtRemZyFSOPMgyiGjspL9vNXHiKPz5HfgeI
         LFTMEz/GEz81Jkgdz/bNgGGjiBYEaQrYUkZ+cH7yAtr9pLxvzttLf7BS3748tcVSAl
         zhDq+J4UbZwTofkXjqi/DdDB/HJIBPYZ3d0B0stkA38f+OqPQe8RCT80fyOqU0fZzS
         HkpQmKfI+en05cqhSgrNIuK+wl82j155kLl/sasC31eUJTwo37wvQbG2Is4I6CoKu2
         RZWkCp8VyrTqMjUdmrOAw+K2j6/bNIUEZgDWIvjAisiNf7wzz7LPf9WNOBRc8Q249f
         A8CMx2NQrt5sA==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id 3701FC009;
        Thu, 11 May 2023 13:03:30 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1683803015; bh=TnIrx9Sr+YwwzAQRDNPaH1tRKUc6B/kK4MrTl299Rxw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oQ/6YFNhh9mzDIpaoH5x4Kg19O3IfuS82T1GpMQb5Ys0ZQBcEcRnpZDWjQPlzkKT/
         ZO5goO37qZ8q2L46V6Wta2u2HgWbGtW9IREcTNF4v8xBwrInU/UOf6RkdKc8iKaY16
         TDDMNSmLhbXTtvW59vNTZw8RS71xoZGQhry7OJHShcWAzztCKNYMR8+qxJm7VOBUzf
         YyLzRrRdw4HTCgiGTD2wOutiRk9G8muBeAxp6sIq8lm43fR5d6YenRFK9hQG7X2GlD
         KMn/jtBl7M4Lva99br/zai15tpVfPN6anZ99n7YrrmMbAaasTWvDuYUc+pukNGJcb7
         KiGouyFg2JD9Q==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id 12b1c2ba;
        Thu, 11 May 2023 11:03:27 +0000 (UTC)
Date:   Thu, 11 May 2023 20:03:12 +0900
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     Dan Carpenter <dan.carpenter@linaro.org>
Cc:     oe-kbuild@lists.linux.dev,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Stefan Roesch <shr@fb.com>, lkp@intel.com,
        oe-kbuild-all@lists.linux.dev, Clay Harris <bugs@claycon.org>,
        Dave Chinner <david@fromorbit.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org
Subject: Re: [PATCH v2 4/6] kernfs: implement readdir FMODE_NOWAIT
Message-ID: <ZFzLcLHvzwqM-uek@codewreck.org>
References: <20230422-uring-getdents-v2-4-2db1e37dc55e@codewreck.org>
 <4e88ec58-be22-4b0c-968d-fa9a52764c98@kili.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4e88ec58-be22-4b0c-968d-fa9a52764c98@kili.mountain>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Dan Carpenter wrote on Thu, May 11, 2023 at 01:55:57PM +0300:
> fd7b9f7b9776b1 Tejun Heo          2013-11-28  1850  		if (!dir_emit(ctx, name, len, ino, type))
> fd7b9f7b9776b1 Tejun Heo          2013-11-28  1851  			return 0;
> 393c3714081a53 Minchan Kim        2021-11-18  1852  		down_read(&root->kernfs_rwsem);
>                                                                 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> Needs to be deleted.

Uh, yes, sorry; I'm not sure how I let that slip, I guess I didn't hit
any dead lock because nothing ever tried to take a write lock after
getdents...
Thanks!

I expect there'll be other comments (this might not make it at all), so
I'll keep the v3 of this patch with this fix locally and resend after
other comments.

> a551138c4b3b9f Dominique Martinet 2023-05-10  1853  		if (ctx->flags & DIR_CONTEXT_F_NOWAIT) {
> a551138c4b3b9f Dominique Martinet 2023-05-10  1854  			if (!down_read_trylock(&root->kernfs_rwsem))
> a551138c4b3b9f Dominique Martinet 2023-05-10  1855  				return 0;
> 
> It's a bit strange the this doesn't return -EAGAIN;

That is on purpose: the getdents did work (dir_emit returned success at
least once), so the caller can process whatever was filled in the buffer
before calling iterate_shared() again.

If we were to return -EAGAIN here, we'd actually be throwing out the
entries we just filled in, and that's not what we want.

-- 
Dominique Martinet | Asmadeus
