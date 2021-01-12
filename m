Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA43A2F3450
	for <lists+io-uring@lfdr.de>; Tue, 12 Jan 2021 16:39:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391795AbhALPil (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 12 Jan 2021 10:38:41 -0500
Received: from mx2.suse.de ([195.135.220.15]:59718 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391683AbhALPil (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Tue, 12 Jan 2021 10:38:41 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 3F008AC24;
        Tue, 12 Jan 2021 15:37:59 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id DBDE0DA87C; Tue, 12 Jan 2021 16:36:06 +0100 (CET)
Date:   Tue, 12 Jan 2021 16:36:06 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Martin Raiber <martin@urbackup.org>
Cc:     linux-btrfs@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [PATCH] btrfs: Prevent nowait or async read from doing sync IO
Message-ID: <20210112153606.GS6430@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Martin Raiber <martin@urbackup.org>,
        linux-btrfs@vger.kernel.org, io-uring@vger.kernel.org
References: <01020176df4d86ba-658b4ef1-1b4a-464f-afe4-fb69ca60e04e-000000@eu-west-1.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <01020176df4d86ba-658b4ef1-1b4a-464f-afe4-fb69ca60e04e-000000@eu-west-1.amazonses.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Jan 08, 2021 at 12:02:48AM +0000, Martin Raiber wrote:
> When reading from btrfs file via io_uring I get following
> call traces:

Is there a way to reproduce by common tools (fio) or is a specialized
one needed?

> [<0>] wait_on_page_bit+0x12b/0x270
> [<0>] read_extent_buffer_pages+0x2ad/0x360
> [<0>] btree_read_extent_buffer_pages+0x97/0x110
> [<0>] read_tree_block+0x36/0x60
> [<0>] read_block_for_search.isra.0+0x1a9/0x360
> [<0>] btrfs_search_slot+0x23d/0x9f0
> [<0>] btrfs_lookup_csum+0x75/0x170
> [<0>] btrfs_lookup_bio_sums+0x23d/0x630
> [<0>] btrfs_submit_data_bio+0x109/0x180
> [<0>] submit_one_bio+0x44/0x70
> [<0>] extent_readahead+0x37a/0x3a0
> [<0>] read_pages+0x8e/0x1f0
> [<0>] page_cache_ra_unbounded+0x1aa/0x1f0
> [<0>] generic_file_buffered_read+0x3eb/0x830
> [<0>] io_iter_do_read+0x1a/0x40
> [<0>] io_read+0xde/0x350
> [<0>] io_issue_sqe+0x5cd/0xed0
> [<0>] __io_queue_sqe+0xf9/0x370
> [<0>] io_submit_sqes+0x637/0x910
> [<0>] __x64_sys_io_uring_enter+0x22e/0x390
> [<0>] do_syscall_64+0x33/0x80
> [<0>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> Prevent those by setting IOCB_NOIO before calling
> generic_file_buffered_read.
> 
> Async read has the same problem. So disable that by removing
> FMODE_BUF_RASYNC. This was added with commit
> 8730f12b7962b21ea9ad2756abce1e205d22db84 ("btrfs: flag files as

Oh yeah that's the commit that went to btrfs code out-of-band. I am not
familiar with the io_uring support and have no good idea what the new
flag was supposed to do.

> supporting buffered async reads") with 5.9. Io_uring will read
> the data via worker threads if it can't be read without sync IO
> this way.

What are the implications of that? Like more context switching (due to
the worker threads) or other potential performance related problems?

> 
> Signed-off-by: Martin Raiber <martin@urbackup.org>
> ---
>  fs/btrfs/file.c | 15 +++++++++++++--
>  1 file changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index 0e41459b8..8bb561f6d 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -3589,7 +3589,7 @@ static loff_t btrfs_file_llseek(struct file *file, loff_t offset, int whence)
>  
>  static int btrfs_file_open(struct inode *inode, struct file *filp)
>  {
> -	filp->f_mode |= FMODE_NOWAIT | FMODE_BUF_RASYNC;
> +	filp->f_mode |= FMODE_NOWAIT;
>  	return generic_file_open(inode, filp);
>  }
>  
> @@ -3639,7 +3639,18 @@ static ssize_t btrfs_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
>  			return ret;
>  	}
>  

> -	return generic_file_buffered_read(iocb, to, ret);
> +	if (iocb->ki_flags & IOCB_NOWAIT)
> +		iocb->ki_flags |= IOCB_NOIO;
> +
> +	ret = generic_file_buffered_read(iocb, to, ret);
> +
> +	if (iocb->ki_flags & IOCB_NOWAIT) {
> +		iocb->ki_flags &= ~IOCB_NOIO;

This should probably use the original value of iocb->ki_flags, as the
NOIO flag is set unconditionally and if it were set initially, now it
would be lost. I haven't checked if this is actually possible as the
iocb code is inside kernel, but just from the safety POV it would be
better to use original value.

> +		if (ret == 0)
> +			ret = -EAGAIN;
> +	}
