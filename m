Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AF2374E8F8
	for <lists+io-uring@lfdr.de>; Tue, 11 Jul 2023 10:24:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230388AbjGKIYx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 11 Jul 2023 04:24:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230345AbjGKIYw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 11 Jul 2023 04:24:52 -0400
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD70DE7A;
        Tue, 11 Jul 2023 01:24:49 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id 319A2C01D; Tue, 11 Jul 2023 10:24:46 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1689063886; bh=alhqvxL93kthMHPg3eS6oCrVpfIVGnVxw7Z8S7t+VlY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2h3h5YcKcoOgsHOAHB0hnAOrcofNqla+B1H+tcNKqpcW1U4ZhJpz/o2dpwpWg15I1
         FHt0vpwXrlYWs+NyK0XxI8BWbVpjTnEONqeT5IAGPWwagsDq6bAxQFXh5i+FVJbudt
         IjAeetojPJ2sUhxLXpNWCbGqnq96e6Uj0kW8JWS+2ORaT3jqbpFdy7uYxOokGqCrXJ
         B5zOngTwU/Mskytxj1bdNAWmV2knU/hIg2DmOCKE3z6ou9o+7AtzMb/OfYJZXu5/uB
         szjI1d73ys1TmNKw863GgIkvOzJFUUS/lW4sfuSgo6mVOoyav/nSBXAu5aE2i1TJrn
         7fILsETh9hJPQ==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id 4A867C009;
        Tue, 11 Jul 2023 10:24:42 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1689063885; bh=alhqvxL93kthMHPg3eS6oCrVpfIVGnVxw7Z8S7t+VlY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SF0S3fk7KIJIKCKxsV1TXltQgRLANRZvxN8sxmsqBCi+ASuLmDN0kReeeeNRYKR3i
         I0uNiPviUkoiOYrzOVxLzer74MGdzxAgWykGpy65PQRPV0t+SIu6MYA2L/ByG1Hym6
         /9IpeYr4VLY90SIlAxAuXqXgw5gNwVfYBkCd4SQ0ZvE/zGj04DCr3t4J5RQ82qhkVp
         omAuApNGq0x1fYBqm7ODmbcedcvFc9uVj6iHLUuriq7zWnZmeM+bEsf1wBDPEx5l8w
         xT0zyeAYTyvfDrfxa/yJKGPWL9B3VMS3gqbrXOL97brfKhnljbEzAiuIUipoYh2CLE
         6bjCcfsrHB2tQ==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id 3af70571;
        Tue, 11 Jul 2023 08:24:38 +0000 (UTC)
Date:   Tue, 11 Jul 2023 17:24:23 +0900
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     Hao Xu <hao.xu@linux.dev>
Cc:     Christian Brauner <brauner@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Stefan Roesch <shr@fb.com>, Clay Harris <bugs@claycon.org>,
        Dave Chinner <david@fromorbit.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org
Subject: Re: [PATCH v2 1/6] fs: split off vfs_getdents function of getdents64
 syscall
Message-ID: <ZK0RtwQza0mra2LF@codewreck.org>
References: <ZG0slV2BhSZkRL_y@codewreck.org>
 <ZG0qgniV1DzIbbzi@codewreck.org>
 <20230524-monolog-punkband-4ed95d8ea852@brauner>
 <ZG6DUfdbTHS-e5P7@codewreck.org>
 <20230525-funkanstalt-ertasten-a43443d045c8@brauner>
 <ZG8_su9Pq1oI-t5s@codewreck.org>
 <7b47fd90-5db5-ec52-8ac2-59ac54c38acb@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <7b47fd90-5db5-ec52-8ac2-59ac54c38acb@linux.dev>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hao Xu wrote on Tue, Jul 11, 2023 at 04:17:11PM +0800:
> > So to that someone: feel free to continue from these branches (I've
> > included the fix for kernfs_fop_readdir that Dan Carpenter reported):
> > https://github.com/martinetd/linux/commits/io_uring_getdents
> > https://github.com/martinetd/liburing/commits/getdents
> > 
> > Or just start over, there's not that much code now hopefully the
> > baseline requirements have gotten a little bit clearer.
> > 
> > 
> > Sorry for stirring the mess and leaving halfway, if nobody does continue
> > I might send a v3 when I have more time/energy in a few months, but it
> > won't be quick.
> 
> I'd like to take this if you don't mind.

Sure, I haven't been working on this lately, feel free to work on this.

Will be happy to review anything you send based on what came out of the
previous discussions to save Christian and others some time so you can
keep me in Cc if you'd like.

-- 
Dominique Martinet | Asmadeus
