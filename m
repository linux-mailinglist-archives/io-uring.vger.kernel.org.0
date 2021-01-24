Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C5E0301E5C
	for <lists+io-uring@lfdr.de>; Sun, 24 Jan 2021 20:11:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725986AbhAXTKk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 24 Jan 2021 14:10:40 -0500
Received: from a4-4.smtp-out.eu-west-1.amazonses.com ([54.240.4.4]:55731 "EHLO
        a4-4.smtp-out.eu-west-1.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725911AbhAXTKj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 24 Jan 2021 14:10:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=pqvuhxtqt36lwjpmqkszlz7wxaih4qwj; d=urbackup.org; t=1611515361;
        h=Subject:To:References:From:Message-ID:Date:MIME-Version:In-Reply-To:Content-Type:Content-Transfer-Encoding;
        bh=H0TQhGY5jNrdRyJguaP+hG7mrHnPq6xQX3muXBIpopo=;
        b=QrN89O9XES0A9yaQQI1u5/HVimbus4GGdCX9Bboi9+cA5BwQkOHpx+ddT4WCzf6H
        hviFmTEk30gxRLXWWLSwjfibc9Jr5cK+QkkDyO3BV3BUydWa+so+vM7XTbAwaIQ+L42
        ovbc0R/SRHyVAM2LMRjjjSnsSRgVgCnK+ZjppjZg=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=shh3fegwg5fppqsuzphvschd53n6ihuv; d=amazonses.com; t=1611515361;
        h=Subject:To:References:From:Message-ID:Date:MIME-Version:In-Reply-To:Content-Type:Content-Transfer-Encoding:Feedback-ID;
        bh=H0TQhGY5jNrdRyJguaP+hG7mrHnPq6xQX3muXBIpopo=;
        b=llcuNoQLsdfi94v1iUIUcIeMWd6rDkf37qFpRdQVqLNyfrG8d9svILC4grcVuNWU
        Pvh8sdbR+xxrh62c4tRwS9zYXzwnKiUi2rLBgWzYvJFK93zqDuhbPnJafYofTT4v7QR
        ZzoR9QvXH70lEVy3c8s8ws2Ha+laZRsCNxqT5qEw=
Subject: Re: [PATCH] btrfs: Prevent nowait or async read from doing sync IO
To:     Pavel Begunkov <asml.silence@gmail.com>, dsterba@suse.cz,
        linux-btrfs@vger.kernel.org, io-uring@vger.kernel.org
References: <01020176df4d86ba-658b4ef1-1b4a-464f-afe4-fb69ca60e04e-000000@eu-west-1.amazonses.com>
 <20210112153606.GS6430@twin.jikos.cz>
 <206bd726-e77c-da24-6560-69faee5281e0@gmail.com>
From:   Martin Raiber <martin@urbackup.org>
Message-ID: <0102017735ccf7af-19f01fac-9247-4818-85fa-7903fb44b4c9-000000@eu-west-1.amazonses.com>
Date:   Sun, 24 Jan 2021 19:09:21 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <206bd726-e77c-da24-6560-69faee5281e0@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-SES-Outgoing: 2021.01.24-54.240.4.4
Feedback-ID: 1.eu-west-1.zKMZH6MF2g3oUhhjaE2f3oQ8IBjABPbvixQzV8APwT0=:AmazonSES
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12.01.2021 18:01 Pavel Begunkov wrote:
> On 12/01/2021 15:36, David Sterba wrote:
>> On Fri, Jan 08, 2021 at 12:02:48AM +0000, Martin Raiber wrote:
>>> When reading from btrfs file via io_uring I get following
>>> call traces:
>> Is there a way to reproduce by common tools (fio) or is a specialized
>> one needed?
> I'm not familiar with this particular issue, but:
> should _probably_ be reproducible with fio with io_uring engine
> or fio/t/io_uring tool.
>
>>> [<0>] wait_on_page_bit+0x12b/0x270
>>> [<0>] read_extent_buffer_pages+0x2ad/0x360
>>> [<0>] btree_read_extent_buffer_pages+0x97/0x110
>>> [<0>] read_tree_block+0x36/0x60
>>> [<0>] read_block_for_search.isra.0+0x1a9/0x360
>>> [<0>] btrfs_search_slot+0x23d/0x9f0
>>> [<0>] btrfs_lookup_csum+0x75/0x170
>>> [<0>] btrfs_lookup_bio_sums+0x23d/0x630
>>> [<0>] btrfs_submit_data_bio+0x109/0x180
>>> [<0>] submit_one_bio+0x44/0x70
>>> [<0>] extent_readahead+0x37a/0x3a0
>>> [<0>] read_pages+0x8e/0x1f0
>>> [<0>] page_cache_ra_unbounded+0x1aa/0x1f0
>>> [<0>] generic_file_buffered_read+0x3eb/0x830
>>> [<0>] io_iter_do_read+0x1a/0x40
>>> [<0>] io_read+0xde/0x350
>>> [<0>] io_issue_sqe+0x5cd/0xed0
>>> [<0>] __io_queue_sqe+0xf9/0x370
>>> [<0>] io_submit_sqes+0x637/0x910
>>> [<0>] __x64_sys_io_uring_enter+0x22e/0x390
>>> [<0>] do_syscall_64+0x33/0x80
>>> [<0>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
>>>
>>> Prevent those by setting IOCB_NOIO before calling
>>> generic_file_buffered_read.
>>>
>>> Async read has the same problem. So disable that by removing
>>> FMODE_BUF_RASYNC. This was added with commit
>>> 8730f12b7962b21ea9ad2756abce1e205d22db84 ("btrfs: flag files as
>> Oh yeah that's the commit that went to btrfs code out-of-band. I am not
>> familiar with the io_uring support and have no good idea what the new
>> flag was supposed to do.
> iirc, Jens did make buffered IO asynchronous by waiting on a page
> with wait_page_queue, but don't remember well enough.
>
>>> supporting buffered async reads") with 5.9. Io_uring will read
>>> the data via worker threads if it can't be read without sync IO
>>> this way.
>> What are the implications of that? Like more context switching (due to
>> the worker threads) or other potential performance related problems?
> io_uring splits submission and completion steps and usually expect
> submissions to happen quick and not block (at least for long),
> otherwise it can't submit other requests, that reduces QD and so
> forth. In the worst case it can serialise it to QD1. I guess the
> same can be applied to AIO.

Io_submit historically had the problem that it is truely async only for 
certain operations. That's why everyone only uses it only for async 
direct I/O with preallocated files (and even then e.g. Mysql has 
innodb_use_native_aio as tuning option that replaces io_submit with a 
userspace thread pool). Io_uring is fixing that by making everything 
async, so the thread calling io_uring_enter never should do any io (only 
read from page cache etc.). The idea is that one can build e.g. a web 
server that uses only one thread and does all (former blocking) syscalls 
via io_uring and handles a large amount of connections. If btrfs does 
blocking io in this one thread this web server wouldn't work well with 
btrfs since the blocking call would e.g. delay accepting new connections.

Specifically w.r.t. read() io_uring has following logic:

  * Try read_iter with RWF_NOWAIT/IOCB_NOWAIT.
  * If read_iter returns -EAGAIN. Look at the FMODE_BUF_RASYNC flag. If
    set do the read with IOCB_WAITQ and callback set (AIO).
  * If FMODE_BUF_RASYNC is not set, sync read in a io_uring worker thread.

My guess is that since btrfs needs to do the checksum calculations in a 
worker anyway, that it's best/simpler to not support the AIO submission 
(so not set the FMODE_BUF_RASYNC).

W.r.t. RWF_NOWAIT the problem is that it synchronously reads the csum 
before async submitting the page reads. When reading randomly from a 
(large) file this means at least one synchronous read per io_uring 
submission. I guess the same happens for preadv2 with RWF_NOWAIT (and 
io_submit), man page:

> *RWF_NOWAIT *(since Linux 4.14)
>                Do not wait for data which is not immediately available.
>                If this flag is specified, the*preadv2*() system call will
>                return instantly if it would have to read data from the
>                backing storage or wait for a lock.  If some data was
>                successfully read, it will return the number of bytes
>                read.  If no bytes were read, it will return -1 and set
>                /errno <https://man7.org/linux/man-pages/man3/errno.3.html>/  to*EAGAIN*.  Currently, this flag is meaningful only
>                for*preadv2*().

I haven't tested this, but the same would probably happen if it doesn't 
have the extents in cache, though that might happen seldom enough that 
it's not worth fixing (for now).

I did also look at how ext4 with fs-verity handles this and it does it 
about the same as btrfs (synchronously reading the csum/hash before 
submitting the read), so same problem there.

One could probably set the FMODE_BUF_RASYNC for files without checksums, 
though idk if compressed extents are a problem.

