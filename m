Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EBC3453A60
	for <lists+io-uring@lfdr.de>; Tue, 16 Nov 2021 20:46:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236115AbhKPTtm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 16 Nov 2021 14:49:42 -0500
Received: from shells.gnugeneration.com ([66.240.222.126]:48570 "EHLO
        shells.gnugeneration.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235941AbhKPTtm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 16 Nov 2021 14:49:42 -0500
Received: by shells.gnugeneration.com (Postfix, from userid 1000)
        id AF72A1A40175; Tue, 16 Nov 2021 11:46:44 -0800 (PST)
Date:   Tue, 16 Nov 2021 11:46:44 -0800
From:   Vito Caputo <vcaputo@pengaru.com>
To:     Drew DeVault <sir@cmpwn.com>
Cc:     Jens Axboe <axboe@kernel.dk>, Matthew Wilcox <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        io_uring Mailing List <io-uring@vger.kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>, linux-mm@kvack.org
Subject: Re: [PATCH] Increase default MLOCK_LIMIT to 8 MiB
Message-ID: <20211116194644.uyvfz4zzzjlbfqbm@shells.gnugeneration.com>
References: <20211028080813.15966-1-sir@cmpwn.com>
 <CAFBCWQ+=2T4U7iNQz_vsBsGVQ72s+QiECndy_3AMFV98bMOLow@mail.gmail.com>
 <CFII8LNSW5XH.3OTIVFYX8P65Y@taiga>
 <593aea3b-e4a4-65ce-0eda-cb3885ff81cd@gnuweeb.org>
 <20211115203530.62ff33fdae14927b48ef6e5f@linux-foundation.org>
 <YZP6JSd4h45cyvsy@casper.infradead.org>
 <b97f1b15-fbcc-92a4-96ca-e918c2f6c7a3@kernel.dk>
 <20211116192148.vjdlng7pesbgjs6b@shells.gnugeneration.com>
 <CFRG8CM6QUPN.1Z75SA6XN02W1@taiga>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CFRG8CM6QUPN.1Z75SA6XN02W1@taiga>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Nov 16, 2021 at 08:25:33PM +0100, Drew DeVault wrote:
> On Tue Nov 16, 2021 at 8:21 PM CET, Vito Caputo wrote:
> > Considering a single fullscreen 32bpp 4K-resolution framebuffer is
> > ~32MiB, I'm not convinced this is really correct in nearly 2022.
> 
> Can you name a practical use-case where you'll be doing I/O with
> uncompressed 4K framebuffers? The kind of I/O which is supported by
> io_uring, to be specific, not, say, handing it off to libdrm.

Obviously video/image editing software tends to operate on raw frames,
and sometimes even persists them via filesystems.

I haven't given it a lot of thought, but a framebuffer is a commonly
used unit of memory allocation in code run on the CPU I've written
over the years.  Being able to pin those for something like io_uring
(or some other DMA-possible interface) seems like an obvious
memory-hungry thing to consider here if we're talking default upper
bounds.

Regards,
Vito Caputo
