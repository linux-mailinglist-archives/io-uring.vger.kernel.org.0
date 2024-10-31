Return-Path: <io-uring+bounces-4275-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C02059B7EA4
	for <lists+io-uring@lfdr.de>; Thu, 31 Oct 2024 16:37:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DD8DE1C208D3
	for <lists+io-uring@lfdr.de>; Thu, 31 Oct 2024 15:37:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70A0019AA53;
	Thu, 31 Oct 2024 15:37:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sh.cz header.i=@sh.cz header.b="kgCmmRAe"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-internal.sh.cz (mail-internal.sh.cz [95.168.196.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA03113342F
	for <io-uring@vger.kernel.org>; Thu, 31 Oct 2024 15:37:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.168.196.40
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730389065; cv=none; b=vAiZbtNIT+nBBgs7fSDj9PFz02WxkMI0mqJC452tDsCOLbdXBiMWKIGb3n2t/LPjje8mkQ3L8wWqXGimZ7Pz+oFwYO5rWY1PqsbU+WMMt12tJed4NXXVfixb3PYriAlXqmufM/e0pCQ1j1TmoVuOdd+GGp0qJH/MhyMDghedUNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730389065; c=relaxed/simple;
	bh=hUWWnDeFP6ChFApRbKNzaHt1H5R7y8ffLUWuxkdVnmw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tv5u8tPsb4kOfjNhnUhAnscyt6qcZN28+mTatUJsFXHSqG4Qrq3fPCmqRr7qVtcKI60rgw51J9VWrqSMl+2Bs6ICerYnaMgo9aENhtiMBB6LC7WuhQ7YbnYU9/NTRprQOZdXISTIQiWwXPCvwH5PoCOpGRXVhXAXkQ3hV/fCoeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sh.cz; spf=pass smtp.mailfrom=sh.cz; dkim=pass (2048-bit key) header.d=sh.cz header.i=@sh.cz header.b=kgCmmRAe; arc=none smtp.client-ip=95.168.196.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sh.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sh.cz
DKIM-Signature: a=rsa-sha256; t=1730389054; x=1730993854; s=mail; d=sh.cz; c=relaxed/relaxed; v=1; bh=no3IeC9WdAHTKqskEYsrrREeUBXhpmO3m0vPZjMfeXY=; h=From:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References;
   b=kgCmmRAeY230dm7rfyABAMb13vK1ZHkfLrH8P77Kh/mVmRW0EBA3fdnHqH42fzleeyAvM4Ah0s3KK+xAGqsz9/SMOEIIypVCe32ytA+rcZ0HPjc4JPzvGPkKpcPq0FZCYMuHHuBxjjhcy+3N6/l3O0KGbyC+Hn37tyQ0RiuV0O+ElaGPOysAl1U2sYPLqzp+9wop1NF4GdjCCdYoTQCnR5iaxIBEEXF5KdFyC7+UkLXZhWRek3QlFtJzYN6BjH8dedXIlS7gxoah65hcs/T6a/gjyE4xLxDrUadmuWyx3g6XbYeFjfbmNyTzSnKw/Gr9tJgTyVO3GFIs/4mb5a+mdw==
Received: from [10.0.5.228] ([95.168.203.222])
        by mail.sh.cz (14.1.0 build 12 ) with ASMTP (SSL) id 202410311637343388;
        Thu, 31 Oct 2024 16:37:34 +0100
Message-ID: <d3ff0512-47fe-4913-ae64-acece8e8a1c6@sh.cz>
Date: Thu, 31 Oct 2024 16:37:33 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [bug report] io_uring: fsfreeze deadlocks when performing
 O_DIRECT writes
To: Jens Axboe <axboe@kernel.dk>
Cc: asml.silence@gmail.com, io-uring@vger.kernel.org
References: <38c94aec-81c9-4f62-b44e-1d87f5597644@sh.cz>
 <a9dec476-59ec-49c3-a3bd-8f05ccc61b19@kernel.dk>
 <3c27875c-f58b-4beb-b24a-7d248292280b@kernel.dk>
Content-Language: en-US
From: Peter Mann <peter.mann@sh.cz>
In-Reply-To: <3c27875c-f58b-4beb-b24a-7d248292280b@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/31/24 15:02, Jens Axboe wrote:
> On 10/31/24 7:54 AM, Jens Axboe wrote:
>> On 10/31/24 5:20 AM, Peter Mann wrote:
>>> Hello,
>>>
>>> it appears that there is a high probability of a deadlock occuring when performing fsfreeze on a filesystem which is currently performing multiple io_uring O_DIRECT writes.
>>>
>>> Steps to reproduce:
>>> 1. Mount xfs or ext4 filesystem on /mnt
>>>
>>> 2. Start writing to the filesystem. Must use io_uring, direct io and iodepth>1 to reproduce:
>>> fio --ioengine=io_uring --direct=1 --bs=4k --size=100M --rw=randwrite --loops=100000 --iodepth=32 --name=test --filename=/mnt/fio_test
>>>
>>> 3. Run this in another shell. For me it deadlocks almost immediately:
>>> while true; do fsfreeze -f /mnt/; echo froze; fsfreeze -u /mnt/; echo unfroze; done
>>>
>>> 4. Fsfreeze and all tasks attempting to write /mnt get stuck:
>>> At this point all stuck processes cannot be killed by SIGKILL and they are stuck in uninterruptible sleep.
>>> If you try 'touch /mnt/a' for example, the new process gets stuck in the exact same way as well.
>>>
>>> This gets printed when running 6.11.4 with some debug options enabled:
>>> [  539.586122] Showing all locks held in the system:
>>> [  539.612972] 1 lock held by khungtaskd/35:
>>> [  539.626204]  #0: ffffffffb3b1c100 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x32/0x1e0
>>> [  539.640561] 1 lock held by dmesg/640:
>>> [  539.654282]  #0: ffff9fd541a8e0e0 (&user->lock){+.+.}-{3:3}, at: devkmsg_read+0x74/0x2d0
>>> [  539.669220] 2 locks held by fio/647:
>>> [  539.684253]  #0: ffff9fd54fe720b0 (&ctx->uring_lock){+.+.}-{3:3}, at: __do_sys_io_uring_enter+0x5c2/0x820
>>> [  539.699565]  #1: ffff9fd541a8d450 (sb_writers#15){++++}-{0:0}, at: io_issue_sqe+0x9c/0x780
>>> [  539.715587] 2 locks held by fio/648:
>>> [  539.732293]  #0: ffff9fd54fe710b0 (&ctx->uring_lock){+.+.}-{3:3}, at: __do_sys_io_uring_enter+0x5c2/0x820
>>> [  539.749121]  #1: ffff9fd541a8d450 (sb_writers#15){++++}-{0:0}, at: io_issue_sqe+0x9c/0x780
>>> [  539.765484] 2 locks held by fio/649:
>>> [  539.781483]  #0: ffff9fd541a8f0b0 (&ctx->uring_lock){+.+.}-{3:3}, at: __do_sys_io_uring_enter+0x5c2/0x820
>>> [  539.798785]  #1: ffff9fd541a8d450 (sb_writers#15){++++}-{0:0}, at: io_issue_sqe+0x9c/0x780
>>> [  539.815466] 2 locks held by fio/650:
>>> [  539.831966]  #0: ffff9fd54fe740b0 (&ctx->uring_lock){+.+.}-{3:3}, at: __do_sys_io_uring_enter+0x5c2/0x820
>>> [  539.849527]  #1: ffff9fd541a8d450 (sb_writers#15){++++}-{0:0}, at: io_issue_sqe+0x9c/0x780
>>> [  539.867469] 1 lock held by fsfreeze/696:
>>> [  539.884565]  #0: ffff9fd541a8d450 (sb_writers#15){++++}-{0:0}, at: freeze_super+0x20a/0x600
>>>
>>> I reproduced this bug on nvme, sata ssd, virtio disks and lvm logical volumes.
>>> It deadlocks on all kernels that I tried (all on amd64):
>>> 6.12-rc5 (compiled from kernel.org)
>>> 6.11.4 (compiled from kernel.org)
>>> 6.10.11-1~bpo12+1 (debian)
>>> 6.1.0-23 (debian)
>>> 5.14.0-427.40.1.el9_4.x86_64 (rocky linux)
>>> 5.10.0-33-amd64 (debian)
>>>
>>> I tried to compile some older ones to check if it's a regression, but
>>> those either didn't compile or didn't boot in my VM, sorry about that.
>>> If you have anything specific for me to try, I'm happy to help.
>>>
>>> Found this issue as well, so it seems like it's not just me:
>>> https://gitlab.com/qemu-project/qemu/-/issues/881
>>> Note that mariadb 10.6 adds support for io_uring, and that proxmox backups perform fsfreeze in the guest VM.
>>>
>>> Originally I discovered this after a scheduled lvm snapshot of mariadb
>>> got stuck. It appears that lvm calls dm_suspend, which then calls
>>> freeze_super, so it looks like the same bug to me. I discovered the
>>> simpler fsfreeze/fio reproduction method when I tried to find a
>>> workaround.
>> Thanks for the report! I'm pretty sure this is due to the freezing not
>> allowing task_work to run, which prevents completions from being run.
>> Hence you run into a situation where freezing isn't running the very IO
>> completions that will free up the rwsem, with IO issue being stuck on
>> the freeze having started.
>>
>> I'll take a look...
> Can you try the below? Probably easiest on 6.12-rc5 as you already
> tested that and should apply directly.
>
> diff --git a/io_uring/rw.c b/io_uring/rw.c
> index 30448f343c7f..ea057ec4365f 100644
> --- a/io_uring/rw.c
> +++ b/io_uring/rw.c
> @@ -1013,6 +1013,18 @@ int io_read_mshot(struct io_kiocb *req, unsigned int issue_flags)
>   	return IOU_OK;
>   }
>   
> +static bool io_kiocb_start_write(struct io_kiocb *req, struct kiocb *kiocb)
> +{
> +	if (!(req->flags & REQ_F_ISREG))
> +		return true;
> +	if (!(kiocb->ki_flags & IOCB_NOWAIT)) {
> +		kiocb_start_write(kiocb);
> +		return true;
> +	}
> +
> +	return sb_start_write_trylock(file_inode(kiocb->ki_filp)->i_sb);
> +}
> +
>   int io_write(struct io_kiocb *req, unsigned int issue_flags)
>   {
>   	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
> @@ -1050,8 +1062,8 @@ int io_write(struct io_kiocb *req, unsigned int issue_flags)
>   	if (unlikely(ret))
>   		return ret;
>   
> -	if (req->flags & REQ_F_ISREG)
> -		kiocb_start_write(kiocb);
> +	if (unlikely(!io_kiocb_start_write(req, kiocb)))
> +		return -EAGAIN;
>   	kiocb->ki_flags |= IOCB_WRITE;
>   
>   	if (likely(req->file->f_op->write_iter))
>

I can confirm this fixes both the fsfreeze and lvm snapshot issues.

Thank you very much!

-- 
Peter Mann

