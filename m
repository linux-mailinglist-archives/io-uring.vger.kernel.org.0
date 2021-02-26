Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B804326604
	for <lists+io-uring@lfdr.de>; Fri, 26 Feb 2021 18:03:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229566AbhBZRDH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 26 Feb 2021 12:03:07 -0500
Received: from mx2.suse.de ([195.135.220.15]:56846 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229545AbhBZRDG (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Fri, 26 Feb 2021 12:03:06 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 1931AAF30;
        Fri, 26 Feb 2021 17:02:24 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id C5767DA7FF; Fri, 26 Feb 2021 18:00:30 +0100 (CET)
Date:   Fri, 26 Feb 2021 18:00:30 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Martin Raiber <martin@urbackup.org>
Cc:     linux-btrfs@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [PATCH] btrfs: Prevent nowait or async read from doing sync IO
Message-ID: <20210226170030.GN7604@twin.jikos.cz>
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
> 
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
> supporting buffered async reads") with 5.9. Io_uring will read
> the data via worker threads if it can't be read without sync IO
> this way.
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
> +		if (ret == 0)
> +			ret = -EAGAIN;
> +	}

Christoph has some doubts about the code,
https://lore.kernel.org/lkml/20210226051626.GA2072@lst.de/

The patch has been in for-next but as I'm not sure it's correct and
don't have a reproducer, I'll remove it again. We do want to fix the
warning, maybe there's only something trivial missing but we need to be
sure, I don't have enough expertise here.
