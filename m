Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 821A81C7754
	for <lists+io-uring@lfdr.de>; Wed,  6 May 2020 19:03:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729644AbgEFRDz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 6 May 2020 13:03:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727984AbgEFRDz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 6 May 2020 13:03:55 -0400
X-Greylist: delayed 83712 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 06 May 2020 10:03:54 PDT
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED679C061A0F
        for <io-uring@vger.kernel.org>; Wed,  6 May 2020 10:03:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-ID:Cc:To:From:Date;
        bh=pTnESlR5+j5OrllY6L54TWF5eBXLRvw9LXHrkFmdR7I=; b=0lvoaQOF3C3UyUm+evfRCi/pgB
        gr2Sz4klLIzr4+ZdrjTcxFQ3/8AtaD8yu/1n+7ify13ePi6yGSOjT90FgUQIDiUynhxbTnJV2/AKn
        1c429ncl0CTCw+aDer2SbUp7xD01KwZ0JxfFiHNIUoMkQyDBE6H5eilWA1HE83ZFBBs4mVfMX1uWe
        9D/H2LeL0Y0suXb5Tqo9eL+u3EIWJnM8uCtqIWbqlDG8GehQV6dqkYngYc2EVOuzpy/IiFMZrvaIs
        DWksPZ871I6OUuf0cBFXjqRZTddmrgQk0YF97uI8TBiZoB5gtFOncXlcaHjvkZ98rs+T0c5NTxn2P
        /+V6gRMZpJsLT4cqcSGHfFk0tbCBjT8fms1lMsXyGFmKFhZ676xUlGGTHTB55ASrob49WQL+z3Use
        19iJhYARjFdTRly7CkoVkcryz9WcsoiGVegfX4pTA1Aoaz1YKeriU3q+iCMPWMi6C9oqci1iPF3Qd
        eYrzmIACr7uWHZF7pFbTtWyr;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1jWNSZ-000826-La; Wed, 06 May 2020 17:03:52 +0000
Date:   Wed, 6 May 2020 10:03:44 -0700
From:   Jeremy Allison <jra@samba.org>
To:     Stefan Metzmacher <metze@samba.org>
Cc:     Anoop C S <anoopcs@cryptolab.net>,
        Samba Technical <samba-technical@lists.samba.org>,
        io-uring <io-uring@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, jra@samba.org
Subject: Re: Data Corruption bug with Samba's vfs_iouring and Linux
 5.6.7/5.7rc3
Message-ID: <20200506170344.GA32399@jeremy-acer>
Reply-To: Jeremy Allison <jra@samba.org>
References: <0009f6b7-9139-35c7-c0b1-b29df2a67f70@samba.org>
 <102c824b-b2f5-bbb1-02da-d2a78c3ff460@kernel.dk>
 <7ed7267d-a0ae-72ac-2106-2476773f544f@kernel.dk>
 <cd53de09-5f4c-f2f0-41ef-9e0bfca9a37d@kernel.dk>
 <f782fc6d-0f89-dca7-3bb0-58ef8f662392@kernel.dk>
 <20200505174832.GC7920@jeremy-acer>
 <3a3e311c7a4bc4d4df371b95ca0c66a792fab986.camel@cryptolab.net>
 <48c9ddf2-31a3-55f7-aa18-5b332c6be6a6@samba.org>
 <62e94d8a6cecf60cfba7e5ca083e90bc8f216d61.camel@cryptolab.net>
 <36fd1c62-abfb-931c-ac31-f6afbbb313fb@samba.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <36fd1c62-abfb-931c-ac31-f6afbbb313fb@samba.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, May 06, 2020 at 04:08:03PM +0200, Stefan Metzmacher wrote:
> Am 06.05.20 um 14:41 schrieb Anoop C S:
> > On Wed, 2020-05-06 at 12:33 +0200, Stefan Metzmacher wrote:
> >> Hi Anoop,
> >>
> >>> I could reproduce the difference in SHA256 checksum after copying a
> >>> directory with 100 copies of test file(provided by reporter) from
> >>> io_uring VFS module enabled share using Windows explorer(right-
> >>> click-
> >>>> copy/paste). Only 5 out of 100 files had correct checksum after
> >>>> copy
> >>> operation :-/
> >>
> >> Great! Can you please try to collect level 1 log files with
> >> the patch https://bugzilla.samba.org/attachment.cgi?id=15955
> >> applied?
> > 
> > I have attached three log files.
> > log.io_uring.smbd -- Copy using Windows explorer
> > log.io_uring-mget.smd -- Copy using smbclient
> > log.io_uring-powershell.smd -- Copy using `Copy-Item`
> 
> Thanks! All of them show short reads like:
> 
> > [2020/05/06 17:27:28.130248,  1] ../../source3/modules/vfs_io_uring.c:103(vfs_io_uring_finish_req)
> >   vfs_io_uring_finish_req: pread ofs=0 (0x0) len=32768 (0x8000) nread=32768 (0x32768) eof=10000000 (0x989680) blks=4096 blocks=19536 dir/1.bin fnum 1607026405
> > [2020/05/06 17:27:28.131049,  1] ../../source3/modules/vfs_io_uring.c:103(vfs_io_uring_finish_req)
> >   vfs_io_uring_finish_req: pread ofs=9969664 (0x982000) len=30336 (0x7680) nread=30336 (0x30336) eof=10000000 (0x989680) blks=4096 blocks=19536 dir/1.bin fnum 1607026405
> > [2020/05/06 17:27:28.133679,  1] ../../source3/modules/vfs_io_uring.c:103(vfs_io_uring_finish_req)
> >   vfs_io_uring_finish_req: pread ofs=61440 (0xf000) len=32768 (0x8000) nread=32768 (0x32768) eof=10000000 (0x989680) blks=4096 blocks=19536 dir/1.bin fnum 1607026405
> > [2020/05/06 17:27:28.140184,  0] ../../source3/modules/vfs_io_uring.c:88(vfs_io_uring_finish_req)
> >   vfs_io_uring_finish_req: Invalid pread ofs=0 (0x0) len=1048576 (0x100000) nread=32768 (0x32768) eof=10000000 (0x989680) blks=4096 blocks=19536 dir/1.bin fnum 1607026405
> 
> It seems the first request is at ofs=0 len=32768 (0x8000) and we get
> 32768 back.
> A follow up request with ofs=0 len=1048576 (0x100000) only gets the
> first 32768 bytes which are already in the page cache.
> 
> I can easily reproduce this with the Ubuntu 5.4 kernel once I add
> state->ur.sqe.rw_flags |= RWF_NOWAIT; to vfs_io_uring_pread_send()
> and use this.
> 
> echo 1 > /proc/sys/vm/drop_caches
> head -c 1024 /root/samba-test/ff1.dat | hexdump -C
> 00000000  ff ff ff ff ff ff ff ff  ff ff ff ff ff ff ff ff
> |................|
> *
> 00000400
> smbclient //172.31.9.167/uringff -Uroot%test -c "get ff1.dat"
> 
> results in this log entries:
> > [2020/05/06 06:51:57.069990,  0] ../../source3/modules/vfs_io_uring.c:89(vfs_io_uring_finish_req)
> >   vfs_io_uring_finish_req: Invalid pread ofs=0 (0x0) len=8388608 (0x800000) nread=16384 (0x4000) eof=8388608 (0x800000) blks=4096 blocks=16384 ff1.dat fnum 840153065
> > [2020/05/06 06:51:57.076882,  1] ../../source3/modules/vfs_io_uring.c:104(vfs_io_uring_finish_req)
> >   vfs_io_uring_finish_req: pread ofs=16384 (0x4000) len=8372224 (0x7fc000) nread=8372224 (0x7fc000) eof=8388608 (0x800000) blks=4096 blocks=16384 ff1.dat fnum 840153065
> 
> smbclient is just smart enough to recover itself from the short read.
> But the windows client isn't.

Well we pay attention to the amount of data returned
and only increment the next read request by the amount
actually returned.

I'm amazed that the Windows client doesn't seem to
check this !

> The attached test against liburing (git://git.kernel.dk/liburing) should
> be able to demonstrate the problem. It can also be found in
> https://github.com/metze-samba/liburing/tree/implicit-rwf-nowaithttps://github.com/metze-samba/liburing/commit/eb06dcfde747e46bd08bedf9def2e6cb536c39e3
> 
> 
> I added the sqe->rw_flags = RWF_NOWAIT; line in order to demonstrate it
> against the Ubuntu 5.3 and 5.4 kernels. They both seem to have the bug.
> 
> Can someone run the unmodified test/implicit-rwf_nowait against
> a newer kernel?

Aha. I wondered about the short read issue when this
was first reported but I could never catch it in the
act.

If the Windows client doesn't check and the kernel
returns short reads I guess we'll have to add logic
similar to tstream_readv_send()/tstream_writev_send()
that ensure all bytes requested/send actually go through
the interface and from/into the kernel unless a read
returns 0 (EOF) or a write returns an error.

What a pain though :-(. SMB2+ server implementors
really need to take note that Windows clients will corrupt
files if they get a short read/write return.

The fact that early kernels don't return short
reads on io_uring but later kernels do makes it
even worse :-(.

There's even an SMB2 protocol field in SMB2_READ:

"MinimumCount (4 bytes): The minimum number of bytes to be read for this operation to be
successful. If fewer than the minimum number of bytes are read by the server, the server
MUST return an error rather than the bytes read."

We correctly return EOF if the amount read from
the kernel is less than SMB2_READ.MinimumCount
so I'm guessing they're not using it or looking
at it (or setting it to zero).

MinimumCount is supposed to allow the client to cope with
this. Anoop, do you have wireshark traces so we can
see what the Windows clients are setting here ?

Jeremy.
