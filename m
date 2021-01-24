Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E7E8301941
	for <lists+io-uring@lfdr.de>; Sun, 24 Jan 2021 03:57:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726412AbhAXC5D (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 23 Jan 2021 21:57:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725943AbhAXC5D (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 23 Jan 2021 21:57:03 -0500
X-Greylist: delayed 3421 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 23 Jan 2021 18:56:23 PST
Received: from zeniv-ca.linux.org.uk (zeniv-ca.linux.org.uk [IPv6:2607:5300:60:148a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 159C4C0613D6;
        Sat, 23 Jan 2021 18:56:23 -0800 (PST)
Received: from viro by zeniv-ca.linux.org.uk with local (Exim 4.94 #2 (Red Hat Linux))
        id 1l3UgD-005Cgl-3r; Sun, 24 Jan 2021 01:59:05 +0000
Date:   Sun, 24 Jan 2021 01:59:05 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Andres Freund <andres@anarazel.de>
Cc:     Lennert Buytenhek <buytenh@wantstofly.org>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: Re: [RFC PATCH] io_uring: add support for IORING_OP_GETDENTS64
Message-ID: <20210124015905.GH740243@zeniv-ca>
References: <20210123114152.GA120281@wantstofly.org>
 <20210123235055.azmz5jm2lwyujygc@alap3.anarazel.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210123235055.azmz5jm2lwyujygc@alap3.anarazel.de>
Sender: Al Viro <viro@ftp.linux.org.uk>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sat, Jan 23, 2021 at 03:50:55PM -0800, Andres Freund wrote:

> As there's only a shared lock, seems like both would end up with the
> same ctx->pos and end up updating f_pos to the same offset (assuming the
> same count).
> 
> Am I missing something?

This:
        f = fdget_pos(fd);
        if (!f.file)
                return -EBADF;
in the callers.  Protection of struct file contents belongs to struct file,
*not* struct inode.  Specifically, file->f_pos_lock.  *IF* struct file
in question happens to be shared and the file is a regular or directory
(sockets don't need any exclusion on read(2), etc.)
