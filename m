Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C30240820A
	for <lists+io-uring@lfdr.de>; Mon, 13 Sep 2021 00:24:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236620AbhILWZv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 12 Sep 2021 18:25:51 -0400
Received: from vmicros1.altlinux.org ([194.107.17.57]:48690 "EHLO
        vmicros1.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235898AbhILWZv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 12 Sep 2021 18:25:51 -0400
Received: from mua.local.altlinux.org (mua.local.altlinux.org [192.168.1.14])
        by vmicros1.altlinux.org (Postfix) with ESMTP id E567972C8B1;
        Mon, 13 Sep 2021 01:24:34 +0300 (MSK)
Received: by mua.local.altlinux.org (Postfix, from userid 508)
        id D64787CF786; Mon, 13 Sep 2021 01:24:34 +0300 (MSK)
Date:   Mon, 13 Sep 2021 01:24:34 +0300
From:   "Dmitry V. Levin" <ldv@altlinux.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Eugene Syromiatnikov <esyr@redhat.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org
Subject: Re: [PATCH] io-wq: expose IO_WQ_ACCT_* enumeration items to UAPI
Message-ID: <20210912222434.GD18053@altlinux.org>
References: <20210912122411.GA27679@asgard.redhat.com>
 <a6027db7-3ebc-6f12-2b58-4b068a346ee2@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a6027db7-3ebc-6f12-2b58-4b068a346ee2@kernel.dk>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sun, Sep 12, 2021 at 12:29:41PM -0600, Jens Axboe wrote:
> On 9/12/21 6:24 AM, Eugene Syromiatnikov wrote:
> > These are used to index aargument of IORING_REGISTER_IOWQ_MAX_WORKERS
> > io_uring_register command, so they are to be exposed in UAPI.
> 
> Not sure that's necessary, as it's really just a boolean values - is
> the worker type bounded or not. That said, not against making it
> available for userspace, but definitely not IO_WQ_ACCT_NR. It
> should probably just go in liburing, I guess.

If IO_WQ_ACCT_* were just boolean values, no enum would have been
introduced in the first place.  What's the benefit of hiding
the API in the implementation, or burying it inside liburing?


-- 
ldv
