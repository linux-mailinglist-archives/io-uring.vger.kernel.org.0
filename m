Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CB0E45398F
	for <lists+io-uring@lfdr.de>; Tue, 16 Nov 2021 19:45:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231964AbhKPSrg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 16 Nov 2021 13:47:36 -0500
Received: from out1.migadu.com ([91.121.223.63]:27632 "EHLO out1.migadu.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229539AbhKPSre (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Tue, 16 Nov 2021 13:47:34 -0500
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cmpwn.com; s=key1;
        t=1637088271;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XQ2XwIGTrPQqjukfYu8yG6Mr/vLUXkMcbZOfyR81sGQ=;
        b=Bz4DH332idjMiD26xYTJdvS+LwwwruKBZwnEFlp9MSVS2lBWnoIvL8+JityyEPhyftO/xx
        FB4ysT4dl1BYiQB2u+E+szQhcrJJkwaio1qIp1GZO+qcaR8lieIC+yWx2k6WmU8MkAyJEP
        AnaIDlt7RxekiQWwrpXGZtdJ9ZQb3MvvZlUZK7SasmlyD2b83ZMTiVoYJBhLvlylmceHhM
        B/xziRcTUVtNN4tNR6Kfx0e2XYWBrEaqsXxKm6PZ/15YYEIdQvPv+jMpbJK3racigRFx/2
        Tj3h9eADFud69HoTX3cPWWgHGSBE4KtlEiwqSn1z2wy/N2Iq8zjXix/1DBLFgw==
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date:   Tue, 16 Nov 2021 19:44:27 +0100
Message-Id: <CFRFCVQRMLRH.1Y7JHSFSRFKMH@taiga>
Cc:     "Ammar Faizi" <ammarfaizi2@gnuweeb.org>,
        <linux-kernel@vger.kernel.org>, <linux-api@vger.kernel.org>,
        "io_uring Mailing List" <io-uring@vger.kernel.org>,
        "Jens Axboe" <axboe@kernel.dk>,
        "Pavel Begunkov" <asml.silence@gmail.com>, <linux-mm@kvack.org>
Subject: Re: [PATCH] Increase default MLOCK_LIMIT to 8 MiB
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   "Drew DeVault" <sir@cmpwn.com>
To:     "Matthew Wilcox" <willy@infradead.org>,
        "Andrew Morton" <akpm@linux-foundation.org>
References: <20211028080813.15966-1-sir@cmpwn.com>
 <CAFBCWQ+=2T4U7iNQz_vsBsGVQ72s+QiECndy_3AMFV98bMOLow@mail.gmail.com>
 <CFII8LNSW5XH.3OTIVFYX8P65Y@taiga>
 <593aea3b-e4a4-65ce-0eda-cb3885ff81cd@gnuweeb.org>
 <20211115203530.62ff33fdae14927b48ef6e5f@linux-foundation.org>
 <YZP6JSd4h45cyvsy@casper.infradead.org>
In-Reply-To: <YZP6JSd4h45cyvsy@casper.infradead.org>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue Nov 16, 2021 at 7:36 PM CET, Matthew Wilcox wrote:
> On the one hand, processes can already allocate at least this much
> memory that is non-swappable, just by doing things like opening a lot of
> files (allocating struct file & fdtable), using a lot of address space
> (allocating page tables), so I don't have a problem with it per se.
>
> On the other hand, 64kB is available on anything larger than an IBM XT.
> Linux will still boot on machines with 4MB of RAM (eg routers). For
> someone with a machine with only, say, 32MB of memory, this allows a
> process to make a quarter of the memory unswappable, and maybe that's
> not a good idea. So perhaps this should scale over a certain range?

I feel like most of the uber-small machines which are still relevant are
not running arbitrary user code, so, something about an airtight hatch
goes here. On the other hand, consider your other hand: you can probably
find a way to allocate this much stuff anyway.

> Is 8MB a generally useful amount of memory for an iouring user anyway?
> If you're just playing with it, sure, but if you have, oh i don't know,
> a database, don't you want to pin the entire cache and allow IO to the
> whole thing?

If you're a databse, you're probably running as a daemon with some
integration with the service manager, most of which have provisions for
tuning the ulimits as necessary.

The purpose of this change is to provide an amount which is more useful
for end-user programs, which usually cannot adjust their ulimits by any
similarly convenient means. 8 MiB is not a lot, but it is enough to
allocate a modest handful of read/write buffers for a video game, mail
client, or something else along those lines of thought, perhaps
specifically narrowing in on the areas which demand the most
performance.

We could certainly go higher and find an even more useful (but still
realistic) value, but I felt it best to err on the side of a more
conservative improvements. Honestly, this number could go as high as we
want it to and applications would happily take it.
