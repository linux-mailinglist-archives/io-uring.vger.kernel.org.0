Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B318B453A22
	for <lists+io-uring@lfdr.de>; Tue, 16 Nov 2021 20:26:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239838AbhKPT2f (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 16 Nov 2021 14:28:35 -0500
Received: from out0.migadu.com ([94.23.1.103]:47314 "EHLO out0.migadu.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229663AbhKPT2f (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Tue, 16 Nov 2021 14:28:35 -0500
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cmpwn.com; s=key1;
        t=1637090734;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NH4D06+wvki1Y2o8G9uIKdZSfom0w6wnccvPwaGoNTQ=;
        b=tC1QclNLGPZYG5G+lNBUu61UJQoA9aD6mERtdhl9mxWXld6jHcG39WfFWPkGgYDgX9hYva
        JBRnijENUJGIvCEjF0s3QXXdwgG8+cPey/+vjUSO+xevG07WiuwOwkHMiWmQxslOweAY9+
        YKIgiIwhCh1/YmseHtmKc/sxvw6Pyw+liAK7Mmjhj1M2V04m4wMfm6qQ4UzAMT5qU6fYc+
        dhyqsi7KqM+xDTLD55r2/gEymAt1xTQb2DUPYuuU8QfSxkwA3JVi1tyvD6e95Xys2ZAU84
        44YhrkldU32fCmxtoRnPAV+hFr0lsyxdCnWK+XwfvrnV4XfUX4lLE5V1q4bw3Q==
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date:   Tue, 16 Nov 2021 20:25:33 +0100
Message-Id: <CFRG8CM6QUPN.1Z75SA6XN02W1@taiga>
Subject: Re: [PATCH] Increase default MLOCK_LIMIT to 8 MiB
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   "Drew DeVault" <sir@cmpwn.com>
To:     "Vito Caputo" <vcaputo@pengaru.com>, "Jens Axboe" <axboe@kernel.dk>
Cc:     "Matthew Wilcox" <willy@infradead.org>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Ammar Faizi" <ammarfaizi2@gnuweeb.org>,
        <linux-kernel@vger.kernel.org>, <linux-api@vger.kernel.org>,
        "io_uring Mailing List" <io-uring@vger.kernel.org>,
        "Pavel Begunkov" <asml.silence@gmail.com>, <linux-mm@kvack.org>
References: <20211028080813.15966-1-sir@cmpwn.com>
 <CAFBCWQ+=2T4U7iNQz_vsBsGVQ72s+QiECndy_3AMFV98bMOLow@mail.gmail.com>
 <CFII8LNSW5XH.3OTIVFYX8P65Y@taiga>
 <593aea3b-e4a4-65ce-0eda-cb3885ff81cd@gnuweeb.org>
 <20211115203530.62ff33fdae14927b48ef6e5f@linux-foundation.org>
 <YZP6JSd4h45cyvsy@casper.infradead.org>
 <b97f1b15-fbcc-92a4-96ca-e918c2f6c7a3@kernel.dk>
 <20211116192148.vjdlng7pesbgjs6b@shells.gnugeneration.com>
In-Reply-To: <20211116192148.vjdlng7pesbgjs6b@shells.gnugeneration.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: sir@cmpwn.com
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue Nov 16, 2021 at 8:21 PM CET, Vito Caputo wrote:
> Considering a single fullscreen 32bpp 4K-resolution framebuffer is
> ~32MiB, I'm not convinced this is really correct in nearly 2022.

Can you name a practical use-case where you'll be doing I/O with
uncompressed 4K framebuffers? The kind of I/O which is supported by
io_uring, to be specific, not, say, handing it off to libdrm.
