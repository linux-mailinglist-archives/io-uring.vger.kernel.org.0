Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBC503AFED7
	for <lists+io-uring@lfdr.de>; Tue, 22 Jun 2021 10:12:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230251AbhFVIPB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 22 Jun 2021 04:15:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:43040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230123AbhFVIPA (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Tue, 22 Jun 2021 04:15:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5769F61289;
        Tue, 22 Jun 2021 08:12:43 +0000 (UTC)
Date:   Tue, 22 Jun 2021 10:12:40 +0200
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Dmitry Kadashev <dkadashev@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        linux-fsdevel@vger.kernel.org, io-uring <io-uring@vger.kernel.org>
Subject: Re: [PATCH v5 00/10] io_uring: add mkdir, [sym]linkat and mknodat
 support
Message-ID: <20210622081240.c7tzq7e7gt3y3u7j@wittgenstein>
References: <20210603051836.2614535-1-dkadashev@gmail.com>
 <CAOKbgA69B=nnNOaHH239vegj5_dRd=9Y-AcQBCD3viLxcH=LiQ@mail.gmail.com>
 <2c4d5933-965e-29b5-0c76-3f2e5f518fe8@kernel.dk>
 <a459abe3-b051-ea60-d8d9-412562a255d5@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <a459abe3-b051-ea60-d8d9-412562a255d5@kernel.dk>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Jun 21, 2021 at 09:21:23AM -0600, Jens Axboe wrote:
> On 6/18/21 10:10 AM, Jens Axboe wrote:
> > On 6/18/21 12:24 AM, Dmitry Kadashev wrote:
> >> On Thu, Jun 3, 2021 at 12:18 PM Dmitry Kadashev <dkadashev@gmail.com> wrote:
> >>>
> >>> This started out as an attempt to add mkdirat support to io_uring which
> >>> is heavily based on renameat() / unlinkat() support.
> >>>
> >>> During the review process more operations were added (linkat, symlinkat,
> >>> mknodat) mainly to keep things uniform internally (in namei.c), and
> >>> with things changed in namei.c adding support for these operations to
> >>> io_uring is trivial, so that was done too. See
> >>> https://lore.kernel.org/io-uring/20210514145259.wtl4xcsp52woi6ab@wittgenstein/
> >>
> >> Ping. Jens, are we waiting for the audit change to be merged before this
> >> can go in?
> > 
> > Not necessarily, as that should go in for 5.14 anyway.
> > 
> > Al, are you OK with the generic changes?
> 
> I have tentatively queued this up.

Hey Dmitry,
hey Jens,

The additional op codes and suggested rework is partially on me. So I
should share the blame in case this gets a NAK:

Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
