Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B9A6482E9B
	for <lists+io-uring@lfdr.de>; Mon,  3 Jan 2022 08:04:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231956AbiACHEV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 3 Jan 2022 02:04:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230088AbiACHEU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 3 Jan 2022 02:04:20 -0500
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D7EDC061784
        for <io-uring@vger.kernel.org>; Sun,  2 Jan 2022 23:04:20 -0800 (PST)
Received: by mail-lj1-x22b.google.com with SMTP id p7so53718571ljj.1
        for <io-uring@vger.kernel.org>; Sun, 02 Jan 2022 23:04:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=d2V9LvO8YtYpG4DLkn7mspHMkHvqdDbFhFbB3JNnpsI=;
        b=N5ssezi4kCySavnyWa1O0cMAH9tQyeyRHvwuhX7x4XGrFRJyjcxirmOU/zaBhWf2Lh
         6XPWsmRSj+fDcs0diDeSC0hgZoMC3o6U9Lz0bQYGbSLiBqokBjcHBwlmwItpTaneivHJ
         xs4gD9lba/rl55VG926EgoluCq/mVB2n7IrbxHfKZht/Psc5hd+5w6mT+oeQAq9VUMKN
         vBw8IC7d3ERmgIVs3pcFrpnOyoVCAh9lXn/e98xvj+7mUR23AaKTFR3Yez30mxLhU2/a
         HcS9vnN052MNHwdqgOJR5PpElcCa2p1ju98C9Q7HvJy2GOILbvwGRajE/5oj01foDd9G
         r2Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=d2V9LvO8YtYpG4DLkn7mspHMkHvqdDbFhFbB3JNnpsI=;
        b=ErZeBHgd64lPXLc3Ca2RXNC2un/IWuBM+hDKsIFGOMu6AcEBXuS+7ioBi/kGRpnI+Y
         DmFLIW4ZW48DzS0Yf+XMH0CYHNI72ednDQU4iu0X8hMiCN33hQVnv9dFqlVcLRH/+J6Q
         gLSBG+RWhnd9X6JnGexxdo4MvwQcVcYI8RVixVN/rLJWea/HyaQfTwx+K8SMlJX8f0FG
         2RtxKRBRB3d/iDIGVuVzkqcvkp0hL6yEZWtzqfxjOj/QBl1/V58ef5S/qRPyL8K0hi9y
         Aa7p6szmBL768QstkUwMPvDjjozym8xck2MfWkk7bTndfA1k51bkBq8sYi+K3i4OLaRG
         cD7g==
X-Gm-Message-State: AOAM530cQR4FWt85MdHitC7w0mjs9jAtSFciqPuP5D3yvDVI8HXg0/Rh
        iZWYULrasiRbaNiKvfiXOvw2OfMc9ngb72JcR+miNw==
X-Google-Smtp-Source: ABdhPJza+Ll9UHVtfPmQyXYiRpJ4qjYTpPHkj9Z2oztzHBSU6vKvsjax40fWWCUPAkhOv3gy80fOp/pbQxsWOI/oiTQ=
X-Received: by 2002:a05:651c:223:: with SMTP id z3mr18009116ljn.93.1641193458123;
 Sun, 02 Jan 2022 23:04:18 -0800 (PST)
MIME-Version: 1.0
References: <20211221164004.119663-1-shr@fb.com> <CAHk-=wgHC_niLQqhmJRPTDULF7K9n8XRDfHV=SCOWvCPugUv5Q@mail.gmail.com>
 <Yc+PK4kRo5ViXu0O@zeniv-ca.linux.org.uk> <YdCyoQNPNcaM9rqD@zeniv-ca.linux.org.uk>
In-Reply-To: <YdCyoQNPNcaM9rqD@zeniv-ca.linux.org.uk>
From:   Jann Horn <jannh@google.com>
Date:   Mon, 3 Jan 2022 08:03:51 +0100
Message-ID: <CAG48ez1O9VxSuWuLXBjke23YxUA8EhMP+6RCHo5PNQBf3B0pDQ@mail.gmail.com>
Subject: Re: [PATCH v7 0/3] io_uring: add getdents64 support
To:     Al Viro <viro@zeniv.linux.org.uk>, Jens Axboe <axboe@kernel.dk>,
        Stefan Roesch <shr@fb.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sat, Jan 1, 2022 at 8:59 PM Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Fri, Dec 31, 2021 at 11:15:55PM +0000, Al Viro wrote:
> > On Tue, Dec 21, 2021 at 09:15:24AM -0800, Linus Torvalds wrote:
> > > On Tue, Dec 21, 2021 at 8:40 AM Stefan Roesch <shr@fb.com> wrote:
> > > >
> > > > This series adds support for getdents64 in liburing. The intent is to
> > > > provide a more complete I/O interface for io_uring.
> > >
> > > Ack, this series looks much more natural to me now.
> > >
> > > I think some of the callers of "iterate_dir()" could probably be
> > > cleaned up with the added argument, but for this series I prefer that
> > > mindless approach of just doing "&(arg1)->f_pos" as the third argument
> > > that is clearly a no-op.
> > >
> > > So the end result is perhaps not as beautiful as it could be, but I
> > > think the patch series DTRT.
> >
> > It really does not.  Think what happens if you pass e.g. an odd position
> > to that on e.g. ext2/3/4.  Or just use it on tmpfs, for that matter.
>
> [A bit of a braindump follows; my apologies for reminding of some
> unpleasant parts of history]
>
> The real problem here is the userland ABI along the lines of pread for
> directories.  There's a good reason why we (as well as everybody else,
> AFAIK) do not have pgetdents(2).
>
> Handling of IO positions for directories had been causing trouble
> ever since the directory layouts had grown support for long names.
> Originally a directory had been an array of fixed-sized entries; back
> then ls(1) simply used read(2).  No special logics for handling offsets,
> other than "each entry is 16 bytes, so you want to read a multiple of
> 16 starting from offset that is a multiple of 16".
>
> As soon as FFS had introduced support for names longer than 14 characters,
> the things got more complicated - there's no predicting if given position
> is an entry boundary.  Worse, what used to have been an entry boundary
> might very well come to point to the middle of a name - all it takes is
> unlink()+creat() done since the time the position used to be OK.
>
> Details are filesystem-dependent; e.g. for original FFS all multiples of
> 512 are valid offsets, and each entry has its length stored in bytes 4
> and 5, so one needs to read the relevant 512 bytes of contents and walk
> the list of entries until they get to (or past) the position that needs
> to be validated.  For ext2 it's a bit more unpleasant, since the chunk
> size is not 512 bytes - it's a block size, i.e. might easily by 4Kb.
> For more complex layouts it gets even nastier.
>
> Having to do that kind of validation on each directory entry access would
> be too costly.  That's somewhat mitigated since the old readdir(2) is no
> longer used, and we return multiple entries per syscall (getdents(2)).
> With the exclusion between directory reads and modifications, that allows
> to limit validation to the first entry returned on that syscall.
>
> It's still too costly, though.  The next part of mitigation is to use
> the fact that valid position will remain valid until somebody modifies a
> directory, so we don't need to validate if directory hadn't been changed
> since the last time getdents(2) had gotten to this position.  Of course,
> explicit change of position since that last getdents(2) means that we
> can't skip validation.

And for this validation caching to work properly, AFAIU you need to
hold the file->f_pos_lock (or have exclusive access to the "struct
file"), which happens in the normal getdents() path via fdget_pos().
This guarantees that the readdir handler has exclusive access to the
file's ->f_version, which has to stay in sync with the position.

By the way, this makes me wonder: If I open() an ext4 directory and
then concurrently modify the directory, call readdir() on it, and
issue IORING_OP_READV SQEs with ->off == -1, can that cause ext4 to
think that filesystem corruption has occurred?

io_uring has some dodgy code that seems to be reading and writing
file->f_pos without holding the file->f_pos_lock. And even if the file
doesn't have an f_op->read or f_op->read_iter handler, I think you
might be able to read ->f_pos of an ext4 directory and write the value
back later, unless I'm missing a check somewhere?

io_prep_rw() grabs file->f_pos; then later, io_read() calls
io_iter_do_read() (which will fail with -EINVAL), and then the error
path goes through kiocb_done(), which writes the position back to
req->file->f_pos. So I think the following race might work:

First, open an FD referencing a directory on an ext4 filesystem. Read
part of the directory's entries from the FD with getdents(). Then
modify the directory such that the FD's ->f_version is now stale. Then
do the race:

task A: start a IORING_OP_READV op on the FD and let it grab the stale
offset from file->f_pos
task B: run getdents() on the FD. after this, ->f_version is
up-to-date and ->f_pos points to the start of a dentry
task A: continue handling the IORING_OP_READV: io_iter_do_read()
fails, kiocb_done() overwrites the valid ->f_pos with the stale value
while leaving ->f_version up-to-date

Afterwards, the file might have an ->f_pos pointing in the middle of a
dentry while ->f_version indicates that it is valid (meaning it's
supposed to point to the start of a dentry). If you then do another
getdents() call on the FD, I think you might get garbage back and/or
make the kernel think that the filesystem is corrupted (depending on
what's stored at that offset)?
