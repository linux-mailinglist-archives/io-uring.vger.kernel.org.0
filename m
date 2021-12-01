Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE3AC4656C2
	for <lists+io-uring@lfdr.de>; Wed,  1 Dec 2021 20:52:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238837AbhLAT4Q (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 1 Dec 2021 14:56:16 -0500
Received: from bee.birch.relay.mailchannels.net ([23.83.209.14]:12207 "EHLO
        bee.birch.relay.mailchannels.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1352727AbhLAT4M (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 1 Dec 2021 14:56:12 -0500
X-Sender-Id: dreamhost|x-authsender|cosmos@claycon.org
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id D95218C1E0C;
        Wed,  1 Dec 2021 19:52:41 +0000 (UTC)
Received: from pdx1-sub0-mail-a238.dreamhost.com (unknown [127.0.0.6])
        (Authenticated sender: dreamhost)
        by relay.mailchannels.net (Postfix) with ESMTPA id 60BAC8C1DEC;
        Wed,  1 Dec 2021 19:52:41 +0000 (UTC)
X-Sender-Id: dreamhost|x-authsender|cosmos@claycon.org
Received: from pdx1-sub0-mail-a238.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
        by 100.114.196.229 (trex/6.4.3);
        Wed, 01 Dec 2021 19:52:41 +0000
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|cosmos@claycon.org
X-MailChannels-Auth-Id: dreamhost
X-Callous-Keen: 60690afb720acca1_1638388361739_2254961659
X-MC-Loop-Signature: 1638388361739:3640251298
X-MC-Ingress-Time: 1638388361739
Received: from ps29521.dreamhostps.com (ps29521.dreamhostps.com [69.163.186.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cosmos@claycon.org)
        by pdx1-sub0-mail-a238.dreamhost.com (Postfix) with ESMTPSA id 4J48rS66q3z2K;
        Wed,  1 Dec 2021 11:52:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed/relaxed; d=claycon.org;
        s=claycon.org; t=1638388361; bh=06EKC+aL0nYBr8NNM3/0TaMmdG0=;
        h=Date:From:To:Cc:Subject:Content-Type;
        b=Cjyc9wKctz/d2tTx8tQ3Py0oHEhngo8erzhnfIbH0HkmXQCg0IejkJg0/yDfyzj2N
         9Yfj2QBGhd/NjqjzGHBuDEMEXgYPcHBiXB1/s78/jRUVxb2o284JL8CmsHSk3nSgya
         Ga3dYxumWt5MuSSk22ECCKhTwqvpYa1vxnA7WrP4=
Date:   Wed, 1 Dec 2021 13:52:39 -0600
From:   Clay Harris <bugs@claycon.org>
To:     Stefan Metzmacher <metze@samba.org>
Cc:     Stefan Roesch <shr@fb.com>, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v1 0/5] io_uring: add xattr support
Message-ID: <20211201195239.mlgb4qwj2hk2d3tv@ps29521.dreamhostps.com>
References: <20211129221257.2536146-1-shr@fb.com>
 <20211130010836.jqp5nuemrse43aca@ps29521.dreamhostps.com>
 <2ba45a80-ce7a-a105-49e5-5507b4453e05@fb.com>
 <56e1aa77-c4c1-2c37-9fc0-96cf0dc0f289@samba.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <56e1aa77-c4c1-2c37-9fc0-96cf0dc0f289@samba.org>
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Dec 01 2021 at 13:19:03 +0100, Stefan Metzmacher quoth thus:

> Hi Stefan,
> 
> > On 11/29/21 5:08 PM, Clay Harris wrote:
> >> On Mon, Nov 29 2021 at 14:12:52 -0800, Stefan Roesch quoth thus:
> >>
> >>> This adds the xattr support to io_uring. The intent is to have a more
> >>> complete support for file operations in io_uring.
> >>>
> >>> This change adds support for the following functions to io_uring:
> >>> - fgetxattr
> >>> - fsetxattr
> >>> - getxattr
> >>> - setxattr
> >>
> >> You may wish to consider the following.
> >>
> >> Patching for these functions makes for an excellent opportunity
> >> to provide a better interface.  Rather than implement fXetattr
> >> at all, you could enable io_uring to use functions like:
> >>
> >> int Xetxattr(int dfd, const char *path, const char *name,
> >> 	[const] void *value, size_t size, int flags);
> >>
> >> Not only does this simplify the io_uring interface down to two
> >> functions, but modernizes and fixes a deficit in usability.
> >> In terms of io_uring, this is just changing internal interfaces.
> >>
> >> Although unnecessary for io_uring, it would be nice to at least
> >> consider what parts of this code could be leveraged for future
> >> Xetxattr2 syscalls.
> > 
> > Clay, 
> > 
> > while we can reduce the number of calls to 2, providing 4 calls will
> > ease the adoption of the interface. 
> > 
> > If you look at the userspace interface in liburing, you can see the
> > following function signature:
> > 
> > static inline void io_uring_prep_fgetxattr(struct io_uring_sqe *sqe,
> > 		                           int         fd,
> > 					   const char *name,
> > 					   const char *value,
> > 					   size_t      len)
> > 
> > This is very similar to what you proposed.
> 
> What's with lsetxattr and lgetxattr, why are they missing.
Do any filesystems even support xattrs on symbolic links?

> I'd assume that even 6 helper functions in liburing would be able
> to use just 2 low level iouring opcodes.
> 
> *listxattr is also missing, are there plans for them?
> 
> metze
