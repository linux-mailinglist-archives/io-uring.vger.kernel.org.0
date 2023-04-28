Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CAF26F1692
	for <lists+io-uring@lfdr.de>; Fri, 28 Apr 2023 13:28:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240110AbjD1L2Z (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 28 Apr 2023 07:28:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234872AbjD1L2X (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 28 Apr 2023 07:28:23 -0400
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C552F4ECD;
        Fri, 28 Apr 2023 04:28:19 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id 545A9C01C; Fri, 28 Apr 2023 13:28:16 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1682681296; bh=OxVs+X25hHVqwJowVcFwN1ACu7t2ri8zooDOLSkhFz0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cGbIet42WfZdwF6rAWTpbheaM4GWpIHLI5Brfm0TQjZBJxbbSVYMpEQYi1v2EgLKO
         xKjYTLGr3azJjRlRP1IemMMTXFBP97lAuB8xktn3TNJYFT3oiFbxqrQtJZ9yZo7OF4
         1gZNjuKoc2BDrHhwbjw/o10IIqbQ1Ojoro4JfuCDqm+yjLJQlBWh8DfeMuGA/va6Fj
         a1yK69WCVybtJg+uRV3ASt7maKkFg8KAPsL4eCA7SgqrWR1WQ6cTKoayz7rofnQusG
         LGzJLnQ0UVh1Uq2e1RGP4TqH4PrbRqskGTse10F6DdJF1eda7TCsTr/reg2dS/N/2g
         lrAZLbulOU1GA==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id 95F15C009;
        Fri, 28 Apr 2023 13:28:12 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1682681295; bh=OxVs+X25hHVqwJowVcFwN1ACu7t2ri8zooDOLSkhFz0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LoGUL+lMPl+njrYxiE4BVjc2glW8XPsIAxixyUyHoLtelHM4UD7+JyyBfifrC6XOu
         pMAa4iuX0/8mqvqwESCj5wTkbUPmbCn2vqgPU2lKQUgefQY2UiiS0pAcpjrTdm3Pe7
         fFCQeLsWYHaAXKNv7GGgy0jbnaXoOVwcx5Ly8BWRoIjEC7mzMWjrZcHRR/Kk8HSWX9
         254Xhdg15GEzB3RhDz+t1cW1T7J24O4mYkPYtS3NWGJiWeyAbidQtWXSPbJ2NZFE9l
         qXVHgxC9IsqhBU+k63cuTmrGpmTydqqPSJcPLN20oKrNHhSFMiZz8N9FVtPABXSt2H
         18SLq4YHA7Ztw==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id 549ff8b9;
        Fri, 28 Apr 2023 11:28:08 +0000 (UTC)
Date:   Fri, 28 Apr 2023 20:27:53 +0900
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Stefan Roesch <shr@fb.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [PATCH RFC 2/2] io_uring: add support for getdents
Message-ID: <ZEutuerMIcKpWAfP@codewreck.org>
References: <20230422-uring-getdents-v1-0-14c1db36e98c@codewreck.org>
 <20230422-uring-getdents-v1-2-14c1db36e98c@codewreck.org>
 <20230423224045.GS447837@dread.disaster.area>
 <ZEXChAJfCRPv9vbs@codewreck.org>
 <20230428050640.GA1969623@dread.disaster.area>
 <ZEtkXJ1vMsFR3tkN@codewreck.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZEtkXJ1vMsFR3tkN@codewreck.org>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Dominique Martinet wrote on Fri, Apr 28, 2023 at 03:14:52PM +0900:
> > We already pass a struct dir_context to ->iterate_shared(), so we
> > have a simple way to add context specific flags down the filesystem
> > from iterate_dir(). This is similar to the iocb for file data IO
> > that contains the flags field that holds the IOCB_NOWAIT context for
> > io_uring based IO. So the infrastructure to plumb it all the way
> > down the fs implementation of ->iterate_shared is already there.
> 
> Sure, that sounds like a good approach that isn't breaking the API (not
> breaking iterate/iterate_shared implementations that don't look at the
> flags and allowing the fs that want to look at it to do so)

Hmm actually I said that, but io_getdents() needs to know if the flag
will be honored or not (if it will be honored, we can call this when
issue_flags & IO_URING_F_NONBLOCK but if we're not sure the fs handles
it then we risk blocking)

I'm not familiar with this part of the VFS, but I do not see any kind of
flags for the filesystem to signal if it'll handle it or not -- this is
actually similar to iterate vs. iterate_shared so that'll mean adding
iterate_shared_hasnonblock or something, which is getting silly.

I'm sure you understand this better than me and I'm missing something
obvious here, but I don't think I'll be able to make something I'm happy
with here (in a reasonable timeframe anyway).


Thanks,
-- 
Dominique Martinet | Asmadeus
