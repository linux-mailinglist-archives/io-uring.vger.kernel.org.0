Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5B4445428C
	for <lists+io-uring@lfdr.de>; Wed, 17 Nov 2021 09:23:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233618AbhKQI0O (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 17 Nov 2021 03:26:14 -0500
Received: from out2.migadu.com ([188.165.223.204]:41107 "EHLO out2.migadu.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229944AbhKQI0O (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Wed, 17 Nov 2021 03:26:14 -0500
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cmpwn.com; s=key1;
        t=1637137387;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BSRVikFW+PtuaMJ8jR31T42CGK4h9hlbjbP7fMd5tsY=;
        b=pE+RmDQ5yxDXkJ04CzwDyD3ULKlPJMyiZvdma6M2k95dKX8HCCaX0U6ejdF0MfoTWK3ZNp
        6NlQkL0eUQvunYsiQwYnl4pWD//SWgN8jPnYR4WPlIBKJGRT8Xk8E14MDp0PTI/oo6HqYV
        ez/P9v9pXCV683l4zXAakhnG+9FRGlpGM45Kk49injCn8P7JYf0+myB0l4fa67IhJJ7OkY
        NFbA/a7B46CisVuAeO5vcGTLty/KUKy4GCr1RsyqQomkuaGI9GLxRr3Dh1VSfoALTpwyae
        iQEoBBdAhXIECB5bgo1ljoYZ8KEndVEzdYIxW8fqiQ2jcb16seQbgasBepTuzw==
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date:   Wed, 17 Nov 2021 09:23:07 +0100
Message-Id: <CFRWRP3RTFT4.3VWRBA26OUSND@taiga>
Cc:     "Ammar Faizi" <ammarfaizi2@gnuweeb.org>,
        <linux-kernel@vger.kernel.org>, <linux-api@vger.kernel.org>,
        "io_uring Mailing List" <io-uring@vger.kernel.org>,
        "Jens Axboe" <axboe@kernel.dk>,
        "Pavel Begunkov" <asml.silence@gmail.com>, <linux-mm@kvack.org>
Subject: Re: [PATCH] Increase default MLOCK_LIMIT to 8 MiB
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   "Drew DeVault" <sir@cmpwn.com>
To:     "Andrew Morton" <akpm@linux-foundation.org>
References: <20211028080813.15966-1-sir@cmpwn.com>
 <CAFBCWQ+=2T4U7iNQz_vsBsGVQ72s+QiECndy_3AMFV98bMOLow@mail.gmail.com>
 <CFII8LNSW5XH.3OTIVFYX8P65Y@taiga>
 <593aea3b-e4a4-65ce-0eda-cb3885ff81cd@gnuweeb.org>
 <20211115203530.62ff33fdae14927b48ef6e5f@linux-foundation.org>
 <CFQZSHV700KV.18Y62SACP8KOO@taiga>
 <20211116114727.601021d0763be1f1efe2a6f9@linux-foundation.org>
 <CFRGQ58D9IFX.PEH1JI9FGHV4@taiga>
 <20211116133750.0f625f73a1e4843daf13b8f7@linux-foundation.org>
In-Reply-To: <20211116133750.0f625f73a1e4843daf13b8f7@linux-foundation.org>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue Nov 16, 2021 at 10:37 PM CET, Andrew Morton wrote:
> We're never going to get this right, are we? The only person who can
> decide on a system's appropriate setting is the operator of that
> system. Haphazardly increasing the limit every few years mainly
> reduces incentive for people to get this right.
>
> And people who test their software on 5.17 kernels will later find that
> it doesn't work on 5.16 and earlier, so they still need to tell their
> users to configure their systems appropriately. Until 5.16 is
> obsolete, by which time we're looking at increasing the default again.
>
> I don't see how this change gets us closer to the desired state:
> getting distros and their users to configure their systems
> appropriately.

Perfect is the enemy of good. This is a very simple change we can make
to improve the status quo, and I think that's worth doing. I do not have
time to develop a more sophisticated solution which steers the defaults
based on memory present, and I definitely don't have the time to
petition every distro to configure a better default for their particular
needs. This is the easiest way to get broad adoption for a better
default.
