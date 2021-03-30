Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA0ED34E1F6
	for <lists+io-uring@lfdr.de>; Tue, 30 Mar 2021 09:17:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231259AbhC3HRW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 30 Mar 2021 03:17:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:54268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229483AbhC3HRF (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Tue, 30 Mar 2021 03:17:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5789961989;
        Tue, 30 Mar 2021 07:17:03 +0000 (UTC)
Date:   Tue, 30 Mar 2021 09:17:00 +0200
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Dmitry Kadashev <dkadashev@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [PATCH v3 1/2] fs: make do_mkdirat() take struct filename
Message-ID: <20210330071700.kpjoyp5zlni7uejm@wittgenstein>
References: <20210330055957.3684579-1-dkadashev@gmail.com>
 <20210330055957.3684579-2-dkadashev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210330055957.3684579-2-dkadashev@gmail.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Mar 30, 2021 at 12:59:56PM +0700, Dmitry Kadashev wrote:
> Pass in the struct filename pointers instead of the user string, and
> update the three callers to do the same. This is heavily based on
> commit dbea8d345177 ("fs: make do_renameat2() take struct filename").
> 
> This behaves like do_unlinkat() and do_renameat2().
> 
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Signed-off-by: Dmitry Kadashev <dkadashev@gmail.com>
> ---
>  fs/internal.h |  1 +
>  fs/namei.c    | 25 +++++++++++++++++++------
>  2 files changed, 20 insertions(+), 6 deletions(-)

The only thing that is a bit unpleasant here is that this change
breaks the consistency between the creation helpers:

do_mkdirat()
do_symlinkat()
do_linkat()
do_mknodat()

All but of them currently take
const char __user *pathname
and call
user_path_create()
with that do_mkdirat() change that's no longer true. One of the major
benefits over the recent years in this code is naming and type consistency.
And since it's just matter of time until io_uring will also gain support
for do_{symlinkat,linkat,mknodat} I would think switching all of them to
take a struct filename
and then have all do_* helpers call getname() might just be nicer in the
long run.

Christian
