Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAA173316EE
	for <lists+io-uring@lfdr.de>; Mon,  8 Mar 2021 20:04:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231201AbhCHTDv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 8 Mar 2021 14:03:51 -0500
Received: from a4-15.smtp-out.eu-west-1.amazonses.com ([54.240.4.15]:54257
        "EHLO a4-15.smtp-out.eu-west-1.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230510AbhCHTDb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 8 Mar 2021 14:03:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=pqvuhxtqt36lwjpmqkszlz7wxaih4qwj; d=urbackup.org; t=1615230210;
        h=Subject:To:References:From:Message-ID:Date:MIME-Version:In-Reply-To:Content-Type:Content-Transfer-Encoding;
        bh=lPhbjOHlM92E0MkykuScbNMwrY+lDu3fxNOoZQ54QEo=;
        b=ZCxCY6E26PULTcy1DzFi/YGKIkCL8V8XFfk9/NdYadShDWHQ82kKjDUGWBhBOiAK
        sVVDMmaOoAUo2fsWK+UmclRoI6zxMl/YOUWGjqy6y2VngLYZC8opRadzWJJoPH7bvRd
        n/NxLy0b/0Y/iP+GwAJzbAm4mALZP77fb6ZImz9o=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=shh3fegwg5fppqsuzphvschd53n6ihuv; d=amazonses.com; t=1615230210;
        h=Subject:To:References:From:Message-ID:Date:MIME-Version:In-Reply-To:Content-Type:Content-Transfer-Encoding:Feedback-ID;
        bh=lPhbjOHlM92E0MkykuScbNMwrY+lDu3fxNOoZQ54QEo=;
        b=qzzef09jUJv6DG25jxNe2ly7ZjtEcEg9D7W3TvrC+3sRdKD6SMPWgxlornhwDYyp
        vbv9kqquchGBXkmFo8OrugGkl6AgTLqZpQyLkt0Zxi8GWcFULTiegdj5z3JDvmzEB+L
        5rA8psCnqKnDpdKLTmkM6H1QZzTdlnRmHxCaStWA=
Subject: Re: [PATCH] btrfs: Prevent nowait or async read from doing sync IO
To:     dsterba@suse.cz, linux-btrfs@vger.kernel.org,
        io-uring@vger.kernel.org
References: <01020176df4d86ba-658b4ef1-1b4a-464f-afe4-fb69ca60e04e-000000@eu-west-1.amazonses.com>
 <20210226170030.GN7604@twin.jikos.cz>
From:   Martin Raiber <martin@urbackup.org>
Message-ID: <0102017813390ff7-879ae32a-99ac-4c52-a01d-58c85686d2f8-000000@eu-west-1.amazonses.com>
Date:   Mon, 8 Mar 2021 19:03:30 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210226170030.GN7604@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-SES-Outgoing: 2021.03.08-54.240.4.15
Feedback-ID: 1.eu-west-1.zKMZH6MF2g3oUhhjaE2f3oQ8IBjABPbvixQzV8APwT0=:AmazonSES
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 26.02.2021 18:00 David Sterba wrote:
> On Fri, Jan 08, 2021 at 12:02:48AM +0000, Martin Raiber wrote:
>> When reading from btrfs file via io_uring I get following
>> call traces:
>>
>> [<0>] wait_on_page_bit+0x12b/0x270
>> [<0>] read_extent_buffer_pages+0x2ad/0x360
>> [<0>] btree_read_extent_buffer_pages+0x97/0x110
>> [<0>] read_tree_block+0x36/0x60
>> [<0>] read_block_for_search.isra.0+0x1a9/0x360
>> [<0>] btrfs_search_slot+0x23d/0x9f0
>> [<0>] btrfs_lookup_csum+0x75/0x170
>> [<0>] btrfs_lookup_bio_sums+0x23d/0x630
>> [<0>] btrfs_submit_data_bio+0x109/0x180
>> [<0>] submit_one_bio+0x44/0x70
>> [<0>] extent_readahead+0x37a/0x3a0
>> [<0>] read_pages+0x8e/0x1f0
>> [<0>] page_cache_ra_unbounded+0x1aa/0x1f0
>> [<0>] generic_file_buffered_read+0x3eb/0x830
>> [<0>] io_iter_do_read+0x1a/0x40
>> [<0>] io_read+0xde/0x350
>> [<0>] io_issue_sqe+0x5cd/0xed0
>> [<0>] __io_queue_sqe+0xf9/0x370
>> [<0>] io_submit_sqes+0x637/0x910
>> [<0>] __x64_sys_io_uring_enter+0x22e/0x390
>> [<0>] do_syscall_64+0x33/0x80
>> [<0>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
>>
>> Prevent those by setting IOCB_NOIO before calling
>> generic_file_buffered_read.
>>
>> Async read has the same problem. So disable that by removing
>> FMODE_BUF_RASYNC. This was added with commit
>> 8730f12b7962b21ea9ad2756abce1e205d22db84 ("btrfs: flag files as
>> supporting buffered async reads") with 5.9. Io_uring will read
>> the data via worker threads if it can't be read without sync IO
>> this way.
>>
>> Signed-off-by: Martin Raiber <martin@urbackup.org>
>> ---
>>  fs/btrfs/file.c | 15 +++++++++++++--
>>  1 file changed, 13 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
>> index 0e41459b8..8bb561f6d 100644
>> --- a/fs/btrfs/file.c
>> +++ b/fs/btrfs/file.c
>> @@ -3589,7 +3589,7 @@ static loff_t btrfs_file_llseek(struct file *file, loff_t offset, int whence)
>>  
>>  static int btrfs_file_open(struct inode *inode, struct file *filp)
>>  {
>> -	filp->f_mode |= FMODE_NOWAIT | FMODE_BUF_RASYNC;
>> +	filp->f_mode |= FMODE_NOWAIT;
>>  	return generic_file_open(inode, filp);
>>  }
>>  
>> @@ -3639,7 +3639,18 @@ static ssize_t btrfs_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
>>  			return ret;
>>  	}
>>  
>> -	return generic_file_buffered_read(iocb, to, ret);
>> +	if (iocb->ki_flags & IOCB_NOWAIT)
>> +		iocb->ki_flags |= IOCB_NOIO;
>> +
>> +	ret = generic_file_buffered_read(iocb, to, ret);
>> +
>> +	if (iocb->ki_flags & IOCB_NOWAIT) {
>> +		iocb->ki_flags &= ~IOCB_NOIO;
>> +		if (ret == 0)
>> +			ret = -EAGAIN;
>> +	}
> Christoph has some doubts about the code,
> https://lore.kernel.org/lkml/20210226051626.GA2072@lst.de/
>
> The patch has been in for-next but as I'm not sure it's correct and
> don't have a reproducer, I'll remove it again. We do want to fix the
> warning, maybe there's only something trivial missing but we need to be
> sure, I don't have enough expertise here.

The general gist of the critism is kind of correct. It is generic_file_buffered_read/filemap_read that handles the IOCB_NOIO, however. It is only used from gfs2 since 5.8 and IOCB_NOIO was added to 5.8 with 41da51bce36f44eefc1e3d0f47d18841cbd065ba ....

However, I cannot see how to find out if readahead was called with IOCB_NOWAIT from extent_readahead/btrfs_readahead/readahead_control. So add an additional parameter to address_space_operations.readahead ? As mentioned, not too relevant to btrfs (because of the CRC calculation), but making readahead async in all cases (incl. IOCB_WAITQ) would be the proper solution.

W.r.t. testing: The most low-effort way I can think of is to add an io_uring switch to xfs_io, so that xfstests can be run using io_uring (where possible). Then check via tracing/perf that there aren't any call stacks with both io_uring_enter and wait_on_page_bit (or any other blocking call) in them.

