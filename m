Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D127C48383A
	for <lists+io-uring@lfdr.de>; Mon,  3 Jan 2022 22:12:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229731AbiACVMu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 3 Jan 2022 16:12:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229677AbiACVMu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 3 Jan 2022 16:12:50 -0500
Received: from zeniv-ca.linux.org.uk (zeniv-ca.linux.org.uk [IPv6:2607:5300:60:148a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B556C061761;
        Mon,  3 Jan 2022 13:12:50 -0800 (PST)
Received: from viro by zeniv-ca.linux.org.uk with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1n4UdJ-00H1C4-0I; Mon, 03 Jan 2022 21:12:45 +0000
Date:   Mon, 3 Jan 2022 21:12:44 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Jann Horn <jannh@google.com>
Cc:     Jens Axboe <axboe@kernel.dk>, Stefan Roesch <shr@fb.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH v7 0/3] io_uring: add getdents64 support
Message-ID: <YdNmzESyEHeN2Gcv@zeniv-ca.linux.org.uk>
References: <20211221164004.119663-1-shr@fb.com>
 <CAHk-=wgHC_niLQqhmJRPTDULF7K9n8XRDfHV=SCOWvCPugUv5Q@mail.gmail.com>
 <Yc+PK4kRo5ViXu0O@zeniv-ca.linux.org.uk>
 <YdCyoQNPNcaM9rqD@zeniv-ca.linux.org.uk>
 <CAG48ez1O9VxSuWuLXBjke23YxUA8EhMP+6RCHo5PNQBf3B0pDQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG48ez1O9VxSuWuLXBjke23YxUA8EhMP+6RCHo5PNQBf3B0pDQ@mail.gmail.com>
Sender: Al Viro <viro@ftp.linux.org.uk>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Jan 03, 2022 at 08:03:51AM +0100, Jann Horn wrote:

> io_prep_rw() grabs file->f_pos; then later, io_read() calls
> io_iter_do_read() (which will fail with -EINVAL), and then the error
> path goes through kiocb_done(), which writes the position back to
> req->file->f_pos. So I think the following race might work:

Why does it touch ->f_pos on failure, anyway?  It's a bug, plain and
simple; note that read(2) and write(2) are explicitly requested to
leave IO position alone if they return an error.  See e.g.
fs/read_write.c:ksys_read() -
                ret = vfs_read(f.file, buf, count, ppos);
		if (ret >= 0 && ppos)
			f.file->f_pos = pos;
		fdput_pos(f);
Position update happens only on success (and only for non-stream
files, at that).

No matter how special io-uring is (it's not covered by POSIX, for
obvious reasons), this is simply wrong, directories or no directories.
