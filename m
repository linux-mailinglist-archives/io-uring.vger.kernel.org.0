Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF10448261C
	for <lists+io-uring@lfdr.de>; Sat,  1 Jan 2022 00:15:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231143AbhLaXP6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 31 Dec 2021 18:15:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230094AbhLaXP5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 31 Dec 2021 18:15:57 -0500
Received: from zeniv-ca.linux.org.uk (zeniv-ca.linux.org.uk [IPv6:2607:5300:60:148a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83D3AC061574;
        Fri, 31 Dec 2021 15:15:57 -0800 (PST)
Received: from viro by zeniv-ca.linux.org.uk with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1n3R7r-00GK93-A1; Fri, 31 Dec 2021 23:15:55 +0000
Date:   Fri, 31 Dec 2021 23:15:55 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Stefan Roesch <shr@fb.com>, io-uring <io-uring@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH v7 0/3] io_uring: add getdents64 support
Message-ID: <Yc+PK4kRo5ViXu0O@zeniv-ca.linux.org.uk>
References: <20211221164004.119663-1-shr@fb.com>
 <CAHk-=wgHC_niLQqhmJRPTDULF7K9n8XRDfHV=SCOWvCPugUv5Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wgHC_niLQqhmJRPTDULF7K9n8XRDfHV=SCOWvCPugUv5Q@mail.gmail.com>
Sender: Al Viro <viro@ftp.linux.org.uk>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Dec 21, 2021 at 09:15:24AM -0800, Linus Torvalds wrote:
> On Tue, Dec 21, 2021 at 8:40 AM Stefan Roesch <shr@fb.com> wrote:
> >
> > This series adds support for getdents64 in liburing. The intent is to
> > provide a more complete I/O interface for io_uring.
> 
> Ack, this series looks much more natural to me now.
> 
> I think some of the callers of "iterate_dir()" could probably be
> cleaned up with the added argument, but for this series I prefer that
> mindless approach of just doing "&(arg1)->f_pos" as the third argument
> that is clearly a no-op.
> 
> So the end result is perhaps not as beautiful as it could be, but I
> think the patch series DTRT.

It really does not.  Think what happens if you pass e.g. an odd position
to that on e.g. ext2/3/4.  Or just use it on tmpfs, for that matter.
