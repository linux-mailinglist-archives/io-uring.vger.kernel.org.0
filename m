Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11C2512B003
	for <lists+io-uring@lfdr.de>; Fri, 27 Dec 2019 01:42:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727274AbfL0AmJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 26 Dec 2019 19:42:09 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:52754 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726277AbfL0AmI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 26 Dec 2019 19:42:08 -0500
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ikdhe-0003Py-7X; Fri, 27 Dec 2019 00:42:06 +0000
Date:   Fri, 27 Dec 2019 00:42:06 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 03/10] fs: add namei support for doing a non-blocking
 path lookup
Message-ID: <20191227004206.GT4203@ZenIV.linux.org.uk>
References: <20191213183632.19441-1-axboe@kernel.dk>
 <20191213183632.19441-4-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191213183632.19441-4-axboe@kernel.dk>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Dec 13, 2019 at 11:36:25AM -0700, Jens Axboe wrote:
> If the fast lookup fails, then return -EAGAIN to have the caller retry
> the path lookup. This is in preparation for supporting non-blocking
> open.

NAK.  We are not littering fs/namei.c with incremental broken bits
and pieces with uncertain eventual use.

And it's broken - lookup_slow() is *NOT* the only place that can and
does block.  For starters, ->d_revalidate() can very well block and
it is called outside of lookup_slow().  So does ->d_automount().
So does ->d_manage().

I'm rather sceptical about the usefulness of non-blocking open, to be
honest, but in any case, one thing that is absolutely not going to
happen is piecewise introduction of such stuff without a discussion
of the entire design.
