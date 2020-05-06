Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 133391C7339
	for <lists+io-uring@lfdr.de>; Wed,  6 May 2020 16:46:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729103AbgEFOqN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 6 May 2020 10:46:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728769AbgEFOqN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 6 May 2020 10:46:13 -0400
X-Greylist: delayed 169 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 06 May 2020 07:46:12 PDT
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0F9FC061A0F
        for <io-uring@vger.kernel.org>; Wed,  6 May 2020 07:46:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-ID:Date:Cc:To:From;
        bh=zlenTLWGk+kuHrOXaXe7UKtKqL57QpdlqqCH3B1Lw38=; b=gxLI4N20vI+hJB/uXEpqXUuVEe
        9pa+9RQCu2G+m0fLOVVOaytDc4kIupIqlG0p4220hV47uGDuzCu6tFq3dnpUdDFTX53Fgn6/ZN75j
        CpIb8zZlhUlUIfj6VLfX1UktDSOTRY2mXRwJn8PemoGacUCJ8DTd3ppRPz6GEPoPmT6YXIlVoYHrp
        shadFY2tsAbXfRtsnY2/fEALtoT90szvmb6vWaGta/g6xPFf1Mx4FQLdiZN8TvpCQvcImIpA0RxX2
        2yCc5JODsixCOEwuHOgAZDrtBKIcM635NqdMlxiVO3d3zKhU4WlKkhpJ7ovV6hSjlcldrqEryz1U0
        3iicCkYt8JJCF3Y1jjbkwT1E07BIqKzs38EXkvCCIOfw37pSfDYR0taEp3Ugq94tyW7W/KfiGUXxq
        yf/RGzHNU6cFFRTU7bFt+rELLj8f9zj3msHpUKKiNuXbmmrMvUemnSPxtz+j0i03fqnc8Azxxwarq
        s+5lkHytNt5/ZytB1YxaNRR5;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1jWLJK-0006kU-KM; Wed, 06 May 2020 14:46:10 +0000
From:   Andreas Schneider <asn@samba.org>
To:     Anoop C S <anoopcs@cryptolab.net>, Jeremy Allison <jra@samba.org>,
        samba-technical@lists.samba.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Samba Technical <samba-technical@lists.samba.org>,
        io-uring <io-uring@vger.kernel.org>,
        Stefan Metzmacher <metze@samba.org>
Subject: Re: Data Corruption bug with Samba's vfs_iouring and Linux 5.6.7/5.7rc3
Date:   Wed, 06 May 2020 16:46:10 +0200
Message-ID: <27882183.aulKxNbigu@magrathea>
In-Reply-To: <36fd1c62-abfb-931c-ac31-f6afbbb313fb@samba.org>
References: <0009f6b7-9139-35c7-c0b1-b29df2a67f70@samba.org> <62e94d8a6cecf60cfba7e5ca083e90bc8f216d61.camel@cryptolab.net> <36fd1c62-abfb-931c-ac31-f6afbbb313fb@samba.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wednesday, 6 May 2020 16:08:03 CEST Stefan Metzmacher via samba-technical 
wrote:
> Am 06.05.20 um 14:41 schrieb Anoop C S:
> > On Wed, 2020-05-06 at 12:33 +0200, Stefan Metzmacher wrote:
> >> Hi Anoop,
> >> 
> >>> I could reproduce the difference in SHA256 checksum after copying a
> >>> directory with 100 copies of test file(provided by reporter) from
> >>> io_uring VFS module enabled share using Windows explorer(right-
> >>> click-
> >>> 
> >>>> copy/paste). Only 5 out of 100 files had correct checksum after
> >>>> copy
> >>> 
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
> > [2020/05/06 17:27:28.130248,  1]
> > ../../source3/modules/vfs_io_uring.c:103(vfs_io_uring_finish_req)> 
> >   vfs_io_uring_finish_req: pread ofs=0 (0x0) len=32768 (0x8000)
> >   nread=32768 (0x32768) eof=10000000 (0x989680) blks=4096 blocks=19536
> >   dir/1.bin fnum 1607026405> 
> > [2020/05/06 17:27:28.131049,  1]
> > ../../source3/modules/vfs_io_uring.c:103(vfs_io_uring_finish_req)> 
> >   vfs_io_uring_finish_req: pread ofs=9969664 (0x982000) len=30336 (0x7680)
> >   nread=30336 (0x30336) eof=10000000 (0x989680) blks=4096 blocks=19536
> >   dir/1.bin fnum 1607026405> 
> > [2020/05/06 17:27:28.133679,  1]
> > ../../source3/modules/vfs_io_uring.c:103(vfs_io_uring_finish_req)> 
> >   vfs_io_uring_finish_req: pread ofs=61440 (0xf000) len=32768 (0x8000)
> >   nread=32768 (0x32768) eof=10000000 (0x989680) blks=4096 blocks=19536
> >   dir/1.bin fnum 1607026405> 
> > [2020/05/06 17:27:28.140184,  0]
> > ../../source3/modules/vfs_io_uring.c:88(vfs_io_uring_finish_req)> 
> >   vfs_io_uring_finish_req: Invalid pread ofs=0 (0x0) len=1048576
> >   (0x100000) nread=32768 (0x32768) eof=10000000 (0x989680) blks=4096
> >   blocks=19536 dir/1.bin fnum 1607026405
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
> 
> |................|
> 
> *
> 00000400
> smbclient //172.31.9.167/uringff -Uroot%test -c "get ff1.dat"
> 
> results in this log entries:
> > [2020/05/06 06:51:57.069990,  0]
> > ../../source3/modules/vfs_io_uring.c:89(vfs_io_uring_finish_req)> 
> >   vfs_io_uring_finish_req: Invalid pread ofs=0 (0x0) len=8388608
> >   (0x800000) nread=16384 (0x4000) eof=8388608 (0x800000) blks=4096
> >   blocks=16384 ff1.dat fnum 840153065> 
> > [2020/05/06 06:51:57.076882,  1]
> > ../../source3/modules/vfs_io_uring.c:104(vfs_io_uring_finish_req)> 
> >   vfs_io_uring_finish_req: pread ofs=16384 (0x4000) len=8372224 (0x7fc000)
> >   nread=8372224 (0x7fc000) eof=8388608 (0x800000) blks=4096 blocks=16384
> >   ff1.dat fnum 840153065
> smbclient is just smart enough to recover itself from the short read.
> But the windows client isn't.
> 
> The attached test against liburing (git://git.kernel.dk/liburing) should
> be able to demonstrate the problem. It can also be found in
> https://github.com/metze-samba/liburing/tree/implicit-rwf-nowaithttps://gith
> ub.com/metze-samba/liburing/commit/eb06dcfde747e46bd08bedf9def2e6cb536c39e3
> 
> 
> I added the sqe->rw_flags = RWF_NOWAIT; line in order to demonstrate it
> against the Ubuntu 5.3 and 5.4 kernels. They both seem to have the bug.
> 
> Can someone run the unmodified test/implicit-rwf_nowait against
> a newer kernel?

$ uname -a
Linux magrathea 5.6.8-1-default #1 SMP Thu Apr 30 10:47:01 UTC 2020 (63116ab) 
x86_64 x86_64 x86_64 GNU/Linux
$ ./a.out 
cqe res=4096 != 8192


	Andreas

-- 
Andreas Schneider                      asn@samba.org
Samba Team                             www.samba.org
GPG-ID:     8DFF53E18F2ABC8D8F3C92237EE0FC4DCC014E3D


