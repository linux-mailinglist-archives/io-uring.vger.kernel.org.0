Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F11B41F3C6A
	for <lists+io-uring@lfdr.de>; Tue,  9 Jun 2020 15:29:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726937AbgFIN3K (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 9 Jun 2020 09:29:10 -0400
Received: from europe5.nedproductions.biz ([195.154.102.72]:54858 "EHLO
        mail.nedproductions.biz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726083AbgFIN3J (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 9 Jun 2020 09:29:09 -0400
X-Greylist: delayed 559 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Jun 2020 09:29:09 EDT
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 2FDDF5E766
        for <io-uring@vger.kernel.org>; Tue,  9 Jun 2020 14:19:49 +0100 (BST)
To:     io-uring@vger.kernel.org
From:   Niall Douglas <s_sourceforge@nedprod.com>
Subject: io_uring and POSIX read-write concurrency guarantees
Message-ID: <ff3be659-e054-88c3-7b4b-c511f679333d@nedprod.com>
Date:   Tue, 9 Jun 2020 14:19:48 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Last-TLS-Session-Version: TLSv1.3
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Dear io-uring mailing list,

My name is Niall Douglas, author of the std::file_handle and
std::mapped_file_handle proposal before WG21 for standardisation. I have
been collaborating with Eric Niebler, Kirk Shoop and Lewis Baker from
Facebook who author the Sender-Receiver proposal for standardised async
i/o in future C++ to implement an io_uring backend for file i/o. We
previously tried to email Jens Axboe privately about this on the 18th
May, 25th May and 28th May, but we received no response, hence we have
come here.

We are currently working on how best to implement async file i/o on
Linux with io_uring, such that std::file_handle, when used with
Sender-Receiver, does the right thing. To be specific, std::file_handle
specifically guarantees propagation of the system's implementation of
POSIX read-write concurrency guarantees, and indeed much file i/o code
implicitly assumes those guarantees i.e. that reads made by thread A
from the same inode will see the same sequence as writes made by thread
B to overlapping regions, and that concurrent reads never see a torn
write in progress up to IOV_MAX scatter-gather buffers.

These guarantees are implemented by a wide range of systems: FreeBSD,
Microsoft Windows and Mac OS have high quality implementations. Linux
varies by filesystem and O_DIRECT flag, so for example ext4 does not
implement the guarantees unless O_DIRECT is turned on. ZFS on Linux
always implements them.


What we would like to achieve is that process A using async file i/o
based on io_uring would experience the POSIX read-write concurrency
guarantees when interoperating with process B using sync file i/o upon
the same inode. In other words, whether io_uring is used, or not, should
have no apparent difference to C++ code.

The existing ordering, pacing and linking sqes in io_uring is
insufficient to achieve this goal because each io_uring ring buffer is
independent of other io_uring ring buffers, and indeed also independent
of the inode being i/o-ed upon.

What we think io_uring would need to implement POSIX read-write
concurrency guarantees for file i/o is the ability to create a global
submission queue per-inode. All i/o in the system, including from read()
and write(), would submit to that per-inode queue. Each inode would have
an as-if read-write mutex. Read i/o can be dispatched in parallel. Write
i/o waits until all preceding operations have completed, and writes then
occur one-at-a-time, per-inode.

(Strictly speaking, the POSIX read-write concurrency guarantees only
affect *overlapping* regions. If i/o is to non-overlapping regions, it
can execute in parallel. However, figuring out whether regions overlap
is slow, so the simpler mechanism above is probably the best balance of
performance to guarantee)


I wish to be clear here: this facility should be opt-out for code which
doesn't care about POSIX read-write concurrency guarantees e.g. if there
can only be one thread accessing a file, we only care about performance,
not concurrency. However, for files shared between processes, I think
the default on Linux ought to be the same as it is on all the other
major platforms. Then portable code works as-is on Linux. Failing that,
standard C++ library implementers ought to be able to implement those
guarantees for C++ code on Linux, and right now I don't believe they can
with io_uring, they would be forced to use a threadpool doing
synchronous i/o, which seems a shame.

Feedback and questions are welcome. My thanks in advance for your time.

Niall
