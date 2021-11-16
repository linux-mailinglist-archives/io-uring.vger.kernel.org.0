Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BF61453A64
	for <lists+io-uring@lfdr.de>; Tue, 16 Nov 2021 20:47:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240137AbhKPTu1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 16 Nov 2021 14:50:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:34728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235941AbhKPTu0 (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Tue, 16 Nov 2021 14:50:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0E37A619EC;
        Tue, 16 Nov 2021 19:47:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637092049;
        bh=YDwjjZPjbBosiDIc0ptER2N/y0HLsc2nGpu++ORg6UA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Am+Q1+gF0bxB8faVGlGR4Lb/Ye7/0XSKjJySMbdzB5QIqA8FLjasOzOTIo2oA9I2x
         OTnGTyJRKwYGfXRNhdlvx0Zz+7Z+/fu+/B/qbNQky52I5XRZefBoSPwcMR28m2YhJX
         wBFTARDE7/C+pO0dmxyAONM0SsZ4uImRG+oNe4wc=
Date:   Tue, 16 Nov 2021 11:47:27 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     "Drew DeVault" <sir@cmpwn.com>
Cc:     "Ammar Faizi" <ammarfaizi2@gnuweeb.org>,
        <linux-kernel@vger.kernel.org>, <linux-api@vger.kernel.org>,
        "io_uring Mailing List" <io-uring@vger.kernel.org>,
        "Jens Axboe" <axboe@kernel.dk>,
        "Pavel Begunkov" <asml.silence@gmail.com>, <linux-mm@kvack.org>
Subject: Re: [PATCH] Increase default MLOCK_LIMIT to 8 MiB
Message-Id: <20211116114727.601021d0763be1f1efe2a6f9@linux-foundation.org>
In-Reply-To: <CFQZSHV700KV.18Y62SACP8KOO@taiga>
References: <20211028080813.15966-1-sir@cmpwn.com>
        <CAFBCWQ+=2T4U7iNQz_vsBsGVQ72s+QiECndy_3AMFV98bMOLow@mail.gmail.com>
        <CFII8LNSW5XH.3OTIVFYX8P65Y@taiga>
        <593aea3b-e4a4-65ce-0eda-cb3885ff81cd@gnuweeb.org>
        <20211115203530.62ff33fdae14927b48ef6e5f@linux-foundation.org>
        <CFQZSHV700KV.18Y62SACP8KOO@taiga>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, 16 Nov 2021 07:32:33 +0100 "Drew DeVault" <sir@cmpwn.com> wrote:

> > And a question: rather than messing around with a constant which will
> > need to be increased again in a couple of years, can we solve this one
> > and for all? For example, permit root to set the system-wide
> > per-process max mlock size and depend upon initscripts to do this
> > appropriately.
> 
> Not sure I understand. Root and init scripts can already manage this
> number - the goal of this patch is just to provide a saner default.

Well, why change the default?  Surely anyone who cares is altering it
at runtime anyway.  And if they are not, we should encourage them to do
so?

