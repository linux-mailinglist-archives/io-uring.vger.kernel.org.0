Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CC2B7505B2
	for <lists+io-uring@lfdr.de>; Wed, 12 Jul 2023 13:14:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232925AbjGLLOQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 12 Jul 2023 07:14:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232306AbjGLLOP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 12 Jul 2023 07:14:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 528D3170E;
        Wed, 12 Jul 2023 04:14:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DFF5961726;
        Wed, 12 Jul 2023 11:14:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06A09C433C7;
        Wed, 12 Jul 2023 11:14:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689160453;
        bh=2g4hvItDIsl1JzyfYXFBYYFzFtFTS+2jdGU+3jUBuC0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JcvUEfb9r74U8+EaMlzK1DO7Ti7ttoAVfaIijSuSFg0pXEcrWWueX9m0qrM7yNZhg
         LLMqBewHugws3yogq1o7TCYzYvSRLpyad8nkX5l3buth5mFjUOpp7ywfgZelFVO6JY
         3cz7Ag0gZ0ujMM4ThiS0se2f7kkGFt6ynk6uDf7t76X/JzRmkiZKC0q7DgD0EM3F5m
         8RWjsSpfHyIUjtK6FrC4yQdwj61rAhVEWtWibcHgRDacH9nWO3sJ08GIiujpq3viD7
         K2ebAo4X1eQSUYzDmId0STG6e8Izajw4/HHy6EYhS/iqcg9mv9IToi4mUxJxaBv37R
         +SYefr2vtzC7Q==
Date:   Wed, 12 Jul 2023 13:14:08 +0200
From:   Christian Brauner <brauner@kernel.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Dave Chinner <david@fromorbit.com>, Hao Xu <hao.xu@linux.dev>,
        io-uring@vger.kernel.org,
        Dominique Martinet <asmadeus@codewreck.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Stefan Roesch <shr@fb.com>, Clay Harris <bugs@claycon.org>,
        linux-fsdevel@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>
Subject: Re: [PATCH 1/3] fs: split off vfs_getdents function of getdents64
 syscall
Message-ID: <20230712-fortgehen-tischbein-f85329dfdab7@brauner>
References: <20230711114027.59945-1-hao.xu@linux.dev>
 <20230711114027.59945-2-hao.xu@linux.dev>
 <ZK3owSS5eENdH7YZ@dread.disaster.area>
 <7fa7d7fc-9a92-f48e-3535-b503f5689103@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <7fa7d7fc-9a92-f48e-3535-b503f5689103@kernel.dk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Jul 11, 2023 at 05:50:27PM -0600, Jens Axboe wrote:
> On 7/11/23 5:41?PM, Dave Chinner wrote:
> > On Tue, Jul 11, 2023 at 07:40:25PM +0800, Hao Xu wrote:
> >> From: Dominique Martinet <asmadeus@codewreck.org>
> >>
> >> This splits off the vfs_getdents function from the getdents64 system
> >> call.
> >> This will allow io_uring to call the vfs_getdents function.
> >>
> >> Co-developed-by: Stefan Roesch <shr@fb.com>
> >> Signed-off-by: Stefan Roesch <shr@fb.com>
> >> Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
> >> ---
> >>  fs/internal.h |  8 ++++++++
> >>  fs/readdir.c  | 34 ++++++++++++++++++++++++++--------
> >>  2 files changed, 34 insertions(+), 8 deletions(-)
> >>
> >> diff --git a/fs/internal.h b/fs/internal.h
> >> index f7a3dc111026..b1f66e52d61b 100644
> >> --- a/fs/internal.h
> >> +++ b/fs/internal.h
> >> @@ -304,3 +304,11 @@ ssize_t __kernel_write_iter(struct file *file, struct iov_iter *from, loff_t *po
> >>  struct mnt_idmap *alloc_mnt_idmap(struct user_namespace *mnt_userns);
> >>  struct mnt_idmap *mnt_idmap_get(struct mnt_idmap *idmap);
> >>  void mnt_idmap_put(struct mnt_idmap *idmap);
> >> +
> >> +/*
> >> + * fs/readdir.c
> >> + */
> >> +struct linux_dirent64;
> >> +
> >> +int vfs_getdents(struct file *file, struct linux_dirent64 __user *dirent,
> >> +		 unsigned int count);
> > 
> > Uh...
> > 
> > Since when have we allowed code outside fs/ to use fs/internal.h?
> 
> io_uring does use for things like open/close, statx, and xattr already.

Arguably though because you io_uring once used to be located under fs/.
In general though, we don't support anyone outside of fs/ to use that
header.
