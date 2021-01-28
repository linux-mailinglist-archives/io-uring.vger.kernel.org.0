Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66EE9308120
	for <lists+io-uring@lfdr.de>; Thu, 28 Jan 2021 23:32:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231185AbhA1WbH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 28 Jan 2021 17:31:07 -0500
Received: from hmm.wantstofly.org ([213.239.204.108]:50768 "EHLO
        mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbhA1WbG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 28 Jan 2021 17:31:06 -0500
Received: by mail.wantstofly.org (Postfix, from userid 1000)
        id 129A07F45D; Fri, 29 Jan 2021 00:30:20 +0200 (EET)
Date:   Fri, 29 Jan 2021 00:30:20 +0200
From:   Lennert Buytenhek <buytenh@wantstofly.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Matthew Wilcox <willy@infradead.org>, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: Re: [RFC PATCH] io_uring: add support for IORING_OP_GETDENTS64
Message-ID: <20210128223020.GG186627@wantstofly.org>
References: <20210123114152.GA120281@wantstofly.org>
 <20210123232754.GA308988@casper.infradead.org>
 <39a9b1da-bbcc-daa0-12e9-3eb776658564@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <39a9b1da-bbcc-daa0-12e9-3eb776658564@kernel.dk>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sat, Jan 23, 2021 at 04:33:34PM -0700, Jens Axboe wrote:

> >> IORING_OP_GETDENTS64 behaves like getdents64(2) and takes the same
> > 
> > Could we drop the '64'?  We don't, for example, have IOURING_OP_FADVISE64
> > even though that's the name of the syscall.
> 
> Agreed, only case we do mimic the names are for things like
> IORING_OP_OPENAT2 where it does carry meaning. For this one, it should
> just be IORING_OP_GETDENTS.

OK, I've made this change.
