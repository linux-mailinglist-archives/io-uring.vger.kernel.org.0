Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 357FD380C50
	for <lists+io-uring@lfdr.de>; Fri, 14 May 2021 16:53:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233033AbhENOyQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 14 May 2021 10:54:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:51894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233187AbhENOyP (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Fri, 14 May 2021 10:54:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 120E86148E;
        Fri, 14 May 2021 14:53:01 +0000 (UTC)
Date:   Fri, 14 May 2021 16:52:59 +0200
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Dmitry Kadashev <dkadashev@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [PATCH v4 0/6] io_uring: add mkdirat support
Message-ID: <20210514145259.wtl4xcsp52woi6ab@wittgenstein>
References: <20210513110612.688851-1-dkadashev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210513110612.688851-1-dkadashev@gmail.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, May 13, 2021 at 06:06:06PM +0700, Dmitry Kadashev wrote:
> This adds mkdirat support to io_uring and is heavily based on recently
> added renameat() / unlinkat() support.
> 
> The first patch is preparation with no functional changes, makes
> do_mkdirat accept struct filename pointer rather than the user string.
> 
> The second one leverages that to implement mkdirat in io_uring.
> 
> The rest of the patches just convert other similar do_* functions in
> namei.c to accept struct filename, for uniformity with do_mkdirat,
> do_renameat and do_unlinkat. No functional changes there.
> 
> Based on io_uring-5.13.
> 
> v4:
> - update do_mknodat, do_symlinkat and do_linkat to accept struct
>   filename for uniformity with do_mkdirat, do_renameat and do_unlinkat;

Dmitry,

If Jens prefers to just run with the conversion of do_mkdirat() and
ignore the rest that's quite alright of course. But I really appreciate
the time spent on the additional conversions.
One question I have is whether we shouldn't just be honest and add
support for linkat, symlinkat, and mknodat in one go instead of being
shy about it. uring does already have mkdirat, renamat2(), and we
already have open(). It seems kinda silly to delay the others... Unless
there's genuinely no interest or need of course.

Christian
