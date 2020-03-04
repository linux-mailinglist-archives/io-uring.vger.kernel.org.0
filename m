Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2D59179951
	for <lists+io-uring@lfdr.de>; Wed,  4 Mar 2020 20:52:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387847AbgCDTv7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 4 Mar 2020 14:51:59 -0500
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:39591 "EHLO
        relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387905AbgCDTv7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 4 Mar 2020 14:51:59 -0500
X-Originating-IP: 92.243.9.8
Received: from localhost (joshtriplett.org [92.243.9.8])
        (Authenticated sender: josh@joshtriplett.org)
        by relay5-d.mail.gandi.net (Postfix) with ESMTPSA id 6DA831C0002;
        Wed,  4 Mar 2020 19:51:58 +0000 (UTC)
Date:   Wed, 4 Mar 2020 11:51:58 -0800
From:   Josh Triplett <josh@joshtriplett.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, jlayton@kernel.org
Subject: Re: [PATCH 6/6] io_uring: allow specific fd for IORING_OP_ACCEPT
Message-ID: <20200304195158.GA16527@localhost>
References: <20200304180016.28212-1-axboe@kernel.dk>
 <20200304180016.28212-7-axboe@kernel.dk>
 <20200304190223.GA16251@localhost>
 <54cbb2d9-e1d7-07b1-2806-6f430a420dd8@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54cbb2d9-e1d7-07b1-2806-6f430a420dd8@kernel.dk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Mar 04, 2020 at 12:09:14PM -0700, Jens Axboe wrote:
> On 3/4/20 12:02 PM, Josh Triplett wrote:
> > On Wed, Mar 04, 2020 at 11:00:16AM -0700, Jens Axboe wrote:
> >> sqe->len can be set to a specific fd we want to use for accept4(), so
> >> it uses that one instead of just assigning a free unused one.
> > [...]
> >> +	accept->open_fd = READ_ONCE(sqe->len);
> >> +	if (!accept->open_fd)
> >> +		accept->open_fd = -1;
> > 
> > 0 is a valid file descriptor. I realize that it seems unlikely, but I
> > went to a fair bit of trouble in my patch series to ensure that
> > userspace could use any valid file descriptor openat2, without a corner
> > case like "you can't open as file descriptor 0", even though it would
> > have been more convenient to just say "if you pass a non-zero fd in
> > open_how". Please consider accepting a flag to determine the validity of
> > open_fd.
> 
> Heh, I actually just changed this, just added that as a temporary hack to
> verify that things were working. Now SOCK_SPECIFIC_FD is required, and we
> just gate on that. OP_ACCEPT disallowed fd != 0 before, so we continue
> to do that if SOCK_SPECIFIC_FD isn't set:
> 
> https://git.kernel.dk/cgit/linux-block/log/?h=io_uring-fd-select
> 
> top two patches.

That looks much better, thank you!

For the entire 6-patch series through commit
2e4ccbb5e66eaa5963dbaf502e8adf1c063c086b:

Reviewed-by: Josh Triplett <josh@joshtriplett.org>
