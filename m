Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76C7D70E733
	for <lists+io-uring@lfdr.de>; Tue, 23 May 2023 23:14:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233285AbjEWVOX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 23 May 2023 17:14:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230214AbjEWVOV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 23 May 2023 17:14:21 -0400
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C84BBBB;
        Tue, 23 May 2023 14:14:20 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id 59AE9C01D; Tue, 23 May 2023 23:14:18 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1684876458; bh=d4s2m+nbJHAqCaA6dUpYb+/BNv9KUfRLhvVNcs9u5Yg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xBzYWVZ6raAGtNotKAvv1yd2+9E3TVUjIU/xZzApSvgcOzMRbYdul81JfqhJdE7AR
         hNHg53A41dJwGdhglZKbaPxQkzYUX+EjO9wQDRU0PeVRFLbJ6q0L5gjBVK9EM7HrrQ
         qKCZDOGGbSZbIFNJj8k9kwqShGlgdRZ7HtEPCeNbhTqGf4FpSFTBUNmzf2+hSQHRTb
         ks8ab4X26L+gFlROJOChbGSjo19CHMiIFb+EvJYdxSYiDucO/iRr3KMmW3Hi2StRxS
         0cVtu7E0V5JAFAYJf8mnVMHHd4IyOWYv86YTtcfv7ejMJCYSHgIrxe+4D9G2khu8Qe
         fgcoV6e57Pgew==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id D2E85C009;
        Tue, 23 May 2023 23:14:14 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1684876457; bh=d4s2m+nbJHAqCaA6dUpYb+/BNv9KUfRLhvVNcs9u5Yg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UTgAaSyZSylhrf3SxgeRNSeU9GQ3Yc/UEC/h3WDhVCn/8Ya1odxoHOJgNj3U38otg
         8TgidFduj5M8lwlcTzAUTdXqOnKLQf8IXBXTP06D4G6VU6A2mg8RCCas2QN5DsU90t
         vZJ/ZPBgeLmz0Rm78iDHZfR7wp+TNvOtUaSxl48eSqQFapb5DhqU6Ss02Nx9gdmfq/
         4972kaL9+jaWNRVfulawiGUX9vY5tVSHA71rrLDHiDKorA6DMNMM1udznRshl+wONQ
         DsDKUjPLywKDnxprU0GJ8vjLchGRn3bcHmp9kI/LckphzeUy4Gx/XMpCNDBBoOokUP
         GFXaUzT0lEe9Q==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id b4ec0871;
        Tue, 23 May 2023 21:14:12 +0000 (UTC)
Date:   Wed, 24 May 2023 06:13:57 +0900
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     Christian Brauner <brauner@kernel.org>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Stefan Roesch <shr@fb.com>, Clay Harris <bugs@claycon.org>,
        Dave Chinner <david@fromorbit.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org
Subject: Re: [PATCH v2 1/6] fs: split off vfs_getdents function of getdents64
 syscall
Message-ID: <ZG0slV2BhSZkRL_y@codewreck.org>
References: <20230422-uring-getdents-v2-0-2db1e37dc55e@codewreck.org>
 <20230422-uring-getdents-v2-1-2db1e37dc55e@codewreck.org>
 <20230523-entzug-komodowaran-96d003250f70@brauner>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230523-entzug-komodowaran-96d003250f70@brauner>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Christian Brauner wrote on Tue, May 23, 2023 at 05:39:08PM +0200:
> > @@ -362,11 +369,7 @@ SYSCALL_DEFINE3(getdents64, unsigned int, fd,
> >  	};
> >  	int error;
> >  
> > -	f = fdget_pos(fd);
> > -	if (!f.file)
> > -		return -EBADF;
> > -
> > -	error = iterate_dir(f.file, &buf.ctx);
> > +	error = iterate_dir(file, &buf.ctx);
> 
> So afaict this isn't enough.
> If you look into iterate_shared() you should see that it uses and
> updates f_pos. But that can't work for io_uring and also isn't how
> io_uring handles read and write. You probably need to use a local pos
> similar to what io_uring does in rw.c for rw->kiocb.ki_pos. But in
> contrast simply disallow any offsets for getdents completely. Thus not
> relying on f_pos anywhere at all.

Using a private offset from the sqe was the previous implementation
discussed around here[1], and Al Viro pointed out that the iterate
filesystem implementations don't validate the offset makes sense as it's
either costly or for some filesystems downright impossible, so I went
into a don't let users modify it approach.

[1] https://lore.kernel.org/all/20211221164004.119663-1-shr@fb.com/T/#m517583f23502f32b040c819d930359313b3db00c


I agree it's not how io_uring usually works -- it dislikes global
states -- but it works perfectly well as long as you don't have multiple
users on the same file, which the application can take care of.

Not having any offsets would work for small directories but make reading
large directories impossible so some sort of continuation is required,
which means we need to keep the offset around; I also suggested keeping
the offset in argument as the previous version but only allowing the
last known offset (... so ultimately still updating f_pos anyway as we
don't have anywhere else to store it) or 0, but if we're going to do
that it looks much simpler to me to expose the same API as getdents.

-- 
Dominique Martinet | Asmadeus
