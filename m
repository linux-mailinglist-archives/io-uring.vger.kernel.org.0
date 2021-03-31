Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 870A63504F6
	for <lists+io-uring@lfdr.de>; Wed, 31 Mar 2021 18:47:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229486AbhCaQqv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 31 Mar 2021 12:46:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233891AbhCaQqc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 31 Mar 2021 12:46:32 -0400
Received: from zeniv-ca.linux.org.uk (zeniv-ca.linux.org.uk [IPv6:2607:5300:60:148a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CE5CC061574;
        Wed, 31 Mar 2021 09:46:32 -0700 (PDT)
Received: from viro by zeniv-ca.linux.org.uk with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lRdz9-001Pmf-Qf; Wed, 31 Mar 2021 16:46:27 +0000
Date:   Wed, 31 Mar 2021 16:46:27 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     Dmitry Kadashev <dkadashev@gmail.com>,
        Jens Axboe <axboe@kernel.dk>,
        io-uring <io-uring@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/2] fs: make do_mkdirat() take struct filename
Message-ID: <YGSnY22x62pEuTyD@zeniv-ca.linux.org.uk>
References: <20201116044529.1028783-1-dkadashev@gmail.com>
 <20201116044529.1028783-2-dkadashev@gmail.com>
 <027e8488-2654-12cd-d525-37f249954b4d@kernel.dk>
 <20210126225504.GM740243@zeniv-ca>
 <CAOKbgA4fTyiU4Xi7zqELT+WeU79S07JF4krhNv3Nq_DS61xa-A@mail.gmail.com>
 <20210201150042.GQ740243@zeniv-ca>
 <20210201152947.GR740243@zeniv-ca>
 <m1ft0bqodn.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1ft0bqodn.fsf@fess.ebiederm.org>
Sender: Al Viro <viro@ftp.linux.org.uk>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Mar 31, 2021 at 11:28:04AM -0500, Eric W. Biederman wrote:
> Al Viro <viro@zeniv.linux.org.uk> writes:
> 
> > On Mon, Feb 01, 2021 at 03:00:42PM +0000, Al Viro wrote:
> >
> >> The last one is the easiest to answer - we want to keep the imported strings
> >> around for audit.  It's not so much a proper refcounting as it is "we might
> >> want freeing delayed" implemented as refcount.
> >
> > BTW, regarding io_uring + audit interactions - just how is that supposed to
> > work if you offload any work that might lead to audit records (on permission
> > checks, etc.) to helper threads?
> 
> For people looking into these details.  Things have gotten much better
> recently.
> 
> The big change is that io_uring helper threads are now proper
> threads of the process that is using io_uring.  The io_uring helper
> threads just happen to never execute any userspace code.

audit context is per-thread (as it has to be, obviously - multiple threads
can have overlapping syscalls), so getname()/putname() interplay with that
is still not obvious.  I agree that these threads have gotten better,
though.
