Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DD4B140FC5
	for <lists+io-uring@lfdr.de>; Fri, 17 Jan 2020 18:20:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726559AbgAQRU5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 17 Jan 2020 12:20:57 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:49888 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726603AbgAQRU5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 17 Jan 2020 12:20:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579281655;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4MKBYGW9AfwPelhJaUrQ06rvksfa+J1vrvTOgyHuB9A=;
        b=IrHGVhDSZBwAF+HOQZX5jXP7kru2VJ4puwGDduF5PWmtroE8x+I7WV+k9ZPn4TVi3kUDXU
        kMtqlDIGtbm8coBu/M79rb1yvHJYztvLrEbxm+gAQ6Bcp8pPJoXlqUF4RSqBKXEzWJQmnP
        9JCF10Cx0nrNjvrwxo6+S9YppoBkk+0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-405-bffoTwb0N7qCWdl2oHGU1g-1; Fri, 17 Jan 2020 12:20:52 -0500
X-MC-Unique: bffoTwb0N7qCWdl2oHGU1g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 18C63800D41;
        Fri, 17 Jan 2020 17:20:51 +0000 (UTC)
Received: from segfault.boston.devel.redhat.com (segfault.boston.devel.redhat.com [10.19.60.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8E8EC60BE1;
        Fri, 17 Jan 2020 17:20:50 +0000 (UTC)
From:   Jeff Moyer <jmoyer@redhat.com>
To:     Mark Papadakis <markuspapadakis@icloud.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>,
        Stefan Metzmacher <metze@samba.org>
Subject: Re: [PATCH v2] io_uring: add support for probing opcodes
References: <886e284c-4b1f-b90e-507e-05e5c74b9599@kernel.dk>
        <76278FD6-7707-483E-ADDA-DF98A19F0860@icloud.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
Date:   Fri, 17 Jan 2020 12:20:49 -0500
In-Reply-To: <76278FD6-7707-483E-ADDA-DF98A19F0860@icloud.com> (Mark
        Papadakis's message of "Fri, 17 Jan 2020 09:42:50 +0200")
Message-ID: <x49wo9q2e4u.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Mark Papadakis <markuspapadakis@icloud.com> writes:

> I 've been thinking about this earlier.
> I think the most realistic solution would be to have kind of
> website/page(libiouring.org?), which lists all SQE OPs, the kernel
> release that first implemented support for it, and (if necessary)
> notes about compatibility.
>
> - There will be, hopefully, a lot more such OPS implemented in the future
> - By having this list readily available, one can determine the lowest
> Linux Kernel release required(target) for a specific set of OPs they
> need for their program. If I want support for readv, writev, accept,
> and connect - say - then I should be able to quickly figure out that
> e.g 5.5 is the minimum LK release I must require

This falls apart when you start looking at distro kernels.  RHEL and
SuSe routinely backport features and fixes, and there may be subsets of
functionality available.  Feature testing really is the best way.

> - Subtle issues may be discovered, or other such important specifics
> may be to be called out -- e.g readv works for < 5.5 for disk I/O but
> (e.g) "broken" for 5.4.3. This should be included in that table

That's true.  I had wondered whether you should be able to specify an
fd, to see if an operation was supported for that particular thing
(file, socket, whatever).  However, I'm not sure how easy that would be
to implement.

One other thing that might be useful is to ask about a specific op.
The way this is implemented, you have to get an entire table, and then
look up the op in that table.  I don't think it's a big deal, though.

> Testing against specific SQE OPs support alone won't be enough, and it
> will likely also get convoluted fast.  liburing could provide a simple
> utility function that returns the (major, minor) LK release for
> convenience.

Again, that model doesn't work for all kernels.

Cheers,
Jeff

