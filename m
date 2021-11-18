Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49F6F455341
	for <lists+io-uring@lfdr.de>; Thu, 18 Nov 2021 04:14:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242110AbhKRDRW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 17 Nov 2021 22:17:22 -0500
Received: from dcvr.yhbt.net ([64.71.152.64]:45360 "EHLO dcvr.yhbt.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241907AbhKRDRU (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Wed, 17 Nov 2021 22:17:20 -0500
Received: from localhost (dcvr.yhbt.net [127.0.0.1])
        by dcvr.yhbt.net (Postfix) with ESMTP id 3DB3D1F9F4;
        Thu, 18 Nov 2021 03:14:21 +0000 (UTC)
Date:   Thu, 18 Nov 2021 03:14:21 +0000
From:   Eric Wong <e@80x24.org>
To:     Stefan Metzmacher <metze@samba.org>
Cc:     io-uring@vger.kernel.org,
        Liu Changcheng <changcheng.liu@aliyun.com>
Subject: Re: [PATCH 2/4] debian: avoid prompting package builder for signature
Message-ID: <20211118031421.M150205@dcvr>
References: <20211116224456.244746-1-e@80x24.org>
 <20211116224456.244746-3-e@80x24.org>
 <8882014a-fab9-2afa-abd4-05f6941c2aa2@samba.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <8882014a-fab9-2afa-abd4-05f6941c2aa2@samba.org>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Stefan Metzmacher <metze@samba.org> wrote:
> Hi Eric,
> 
> > diff --git a/make-debs.sh b/make-debs.sh
> > index 136b79e..aea05f0 100755
> > --- a/make-debs.sh
> > +++ b/make-debs.sh
> > @@ -20,7 +20,10 @@ set -o pipefail
> >  
> >  # Create dir for build
> >  base=${1:-/tmp/release}
> > -codename=$(lsb_release -sc)
> > +
> > +# UNRELEASED here means debuild won't prompt for signing
> > +codename=UNRELEASED
> > +
> >  releasedir=$base/$(lsb_release -si)/liburing
> >  rm -rf $releasedir
> >  mkdir -p $releasedir
> 
> You can use DEBUILD_DPKG_BUILDPACKAGE_OPTS="--no-sign" in ~/.devscripts
> 
> Or we could make it possible to pass arguments down to 'debuild',
> e.g. '-us -uc'. I'm also fine with doing that by default.

Yes, I extended the commit message in v2 to note "UNRELEASED"
is also helpful in communicating the package is an unofficial
Debian package.  This is helpful tidbit since an official Debian
package now exists.
