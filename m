Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 317C6453BBE
	for <lists+io-uring@lfdr.de>; Tue, 16 Nov 2021 22:37:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229868AbhKPVku (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 16 Nov 2021 16:40:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:58114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229605AbhKPVku (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Tue, 16 Nov 2021 16:40:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5D63461263;
        Tue, 16 Nov 2021 21:37:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637098672;
        bh=aut4rZmVSqmvPDGWnVKMPUXMUilpN5ktFpJnFx75cyU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=0cKcHMIi8KdXlMQJmAQdEEfbVfjIlTVsKC0Kx1JFgqNshbstFV1fP76hzsonyFdGs
         /dGMQBYUTB0DwhJnNblcxR70uOwpNPliVVx0/JfYSKRUI0tjhd6EvqzmZmX25+QaQU
         jq+DnMujwUeBzPZ1fp2YzvFGPyAGomB+JyiSvtfI=
Date:   Tue, 16 Nov 2021 13:37:50 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     "Drew DeVault" <sir@cmpwn.com>
Cc:     "Ammar Faizi" <ammarfaizi2@gnuweeb.org>,
        <linux-kernel@vger.kernel.org>, <linux-api@vger.kernel.org>,
        "io_uring Mailing List" <io-uring@vger.kernel.org>,
        "Jens Axboe" <axboe@kernel.dk>,
        "Pavel Begunkov" <asml.silence@gmail.com>, <linux-mm@kvack.org>
Subject: Re: [PATCH] Increase default MLOCK_LIMIT to 8 MiB
Message-Id: <20211116133750.0f625f73a1e4843daf13b8f7@linux-foundation.org>
In-Reply-To: <CFRGQ58D9IFX.PEH1JI9FGHV4@taiga>
References: <20211028080813.15966-1-sir@cmpwn.com>
        <CAFBCWQ+=2T4U7iNQz_vsBsGVQ72s+QiECndy_3AMFV98bMOLow@mail.gmail.com>
        <CFII8LNSW5XH.3OTIVFYX8P65Y@taiga>
        <593aea3b-e4a4-65ce-0eda-cb3885ff81cd@gnuweeb.org>
        <20211115203530.62ff33fdae14927b48ef6e5f@linux-foundation.org>
        <CFQZSHV700KV.18Y62SACP8KOO@taiga>
        <20211116114727.601021d0763be1f1efe2a6f9@linux-foundation.org>
        <CFRGQ58D9IFX.PEH1JI9FGHV4@taiga>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, 16 Nov 2021 20:48:48 +0100 "Drew DeVault" <sir@cmpwn.com> wrote:

> On Tue Nov 16, 2021 at 8:47 PM CET, Andrew Morton wrote:
> > Well, why change the default? Surely anyone who cares is altering it
> > at runtime anyway. And if they are not, we should encourage them to do
> > so?
> 
> I addressed this question in the original patch's commit message.

Kinda.

We're never going to get this right, are we?  The only person who can
decide on a system's appropriate setting is the operator of that
system.  Haphazardly increasing the limit every few years mainly
reduces incentive for people to get this right.

And people who test their software on 5.17 kernels will later find that
it doesn't work on 5.16 and earlier, so they still need to tell their
users to configure their systems appropriately.  Until 5.16 is
obsolete, by which time we're looking at increasing the default again.

I don't see how this change gets us closer to the desired state:
getting distros and their users to configure their systems
appropriately.

