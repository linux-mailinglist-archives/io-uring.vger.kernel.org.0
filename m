Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D83BD481B32
	for <lists+io-uring@lfdr.de>; Thu, 30 Dec 2021 10:41:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238345AbhL3Jl5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Dec 2021 04:41:57 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:55808 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234584AbhL3Jl5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Dec 2021 04:41:57 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 392F66164B;
        Thu, 30 Dec 2021 09:41:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2DAFC36AEA;
        Thu, 30 Dec 2021 09:41:54 +0000 (UTC)
Date:   Thu, 30 Dec 2021 10:41:51 +0100
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Stefan Roesch <shr@fb.com>, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, kernel-team@fb.com,
        torvalds@linux-foundation.org
Subject: Re: [PATCH v10 2/5] fs: split off setxattr_copy and do_setxattr
 function from setxattr
Message-ID: <20211230094151.z7frfjxv3xhlgckx@wittgenstein>
References: <20211229203002.4110839-1-shr@fb.com>
 <20211229203002.4110839-3-shr@fb.com>
 <Yc0IHp2igNlXqyKV@zeniv-ca.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Yc0IHp2igNlXqyKV@zeniv-ca.linux.org.uk>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Dec 30, 2021 at 01:15:10AM +0000, Al Viro wrote:
> On Wed, Dec 29, 2021 at 12:29:59PM -0800, Stefan Roesch wrote:
> > +	if (ctx->size) {
> > +		if (ctx->size > XATTR_SIZE_MAX)
> >  			return -E2BIG;
> > -		kvalue = kvmalloc(size, GFP_KERNEL);
> > -		if (!kvalue)
> > +
> > +		ctx->kvalue = kvmalloc(ctx->size, GFP_KERNEL);
> > +		if (!ctx->kvalue)
> >  			return -ENOMEM;
> > -		if (copy_from_user(kvalue, value, size)) {
> > -			error = -EFAULT;
> > -			goto out;
> > +
> > +		if (copy_from_user(ctx->kvalue, ctx->value, ctx->size)) {
> > +			kvfree(ctx->kvalue);
> > +			return -EFAULT;
> 
> BTW, what's wrong with using vmemdup_user() here?

Nothing? It's simply timing paired with that specific code not needing
to be touched:

- in 2005 that code was kmalloc(GFP_KERNEL) + copy_from_user()
- in 2009 it was changed to memdup_user(GFP_USER)
- in 2012 it was changed to kvmalloc(GFP_KERNEL) + copy_from_user()

In 2018 you added vmemdup_user() and noone has updated that codepath. :)
