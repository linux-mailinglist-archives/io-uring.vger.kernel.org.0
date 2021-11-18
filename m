Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A352C45522B
	for <lists+io-uring@lfdr.de>; Thu, 18 Nov 2021 02:25:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239172AbhKRB2w (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 17 Nov 2021 20:28:52 -0500
Received: from dcvr.yhbt.net ([64.71.152.64]:42446 "EHLO dcvr.yhbt.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232650AbhKRB2w (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Wed, 17 Nov 2021 20:28:52 -0500
Received: from localhost (dcvr.yhbt.net [127.0.0.1])
        by dcvr.yhbt.net (Postfix) with ESMTP id D609F1F9F4;
        Thu, 18 Nov 2021 01:25:52 +0000 (UTC)
Date:   Thu, 18 Nov 2021 01:25:52 +0000
From:   Eric Wong <e@80x24.org>
To:     Stefan Metzmacher <metze@samba.org>
Cc:     io-uring@vger.kernel.org,
        Liu Changcheng <changcheng.liu@aliyun.com>,
        Bikal Lem <gbikal+git@gmail.com>
Subject: Re: [PATCH 1/4] make-debs: fix version detection
Message-ID: <20211118012552.M795059@dcvr>
References: <20211116224456.244746-1-e@80x24.org>
 <20211116224456.244746-2-e@80x24.org>
 <0178c27e-4f22-ac44-1f9f-f2c8f5f176b5@samba.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <0178c27e-4f22-ac44-1f9f-f2c8f5f176b5@samba.org>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Stefan Metzmacher <metze@samba.org> wrote:
> 
> Hi Eric,
> 
> a comment on versioning in general not really about your commit.
> 
> Is it still correct to have liburing1* in debian/control, shouldn't
> it be liburing2 now?

Yes, I'll correct that in a reroll.

> Also shouldn't we get version= out of liburing.spec as that seems to contain the current
> version number... instead of using git describe --match "lib*" | cut -d '-' -f 2

Agreed.  I've also got patches on the way which will
allow building .debs without git at all.

> I also noticed that this
> commit c0b43df28a982747e081343f23289357ab4615db
> Author: Bikal Lem <gbikal+git@gmail.com>
> Date:   Mon Nov 15 13:09:30 2021 +0000
> 
>     src/Makefile: use VERSION variable consistently
> 
>     src/Makefile defines incorrect 'liburing.so' version, i.e 2.1 as
>     opposed to 2.2. This commit makes src/Makefile use correct version
>     defined in liburing.spec. Along the way we refactor the use of common
>     variables into Makefile.common and include it into both src/Makefile
>     and Makefile.
> 
>     Signed-off-by: Bikal Lem <gbikal+git@gmail.com>
> 
> changed the library soname from liburing.so.2 to just liburing.so, which seems wrong.

Separate issue, but yes, I'm inclined to agree with Stefan that
the ".2" should remain.  (I'm not an expert in library/packaging
issues by any means; I just want the ability to cleanly
uninstall/upgrade via debs)
