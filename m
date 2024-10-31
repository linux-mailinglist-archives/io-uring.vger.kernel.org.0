Return-Path: <io-uring+bounces-4260-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 04D599B79A2
	for <lists+io-uring@lfdr.de>; Thu, 31 Oct 2024 12:26:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 79267B21532
	for <lists+io-uring@lfdr.de>; Thu, 31 Oct 2024 11:26:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72E5D19ABB7;
	Thu, 31 Oct 2024 11:26:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sh.cz header.i=@sh.cz header.b="h69vbvf/"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-internal.sh.cz (mail-internal.sh.cz [95.168.196.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28FD9155322
	for <io-uring@vger.kernel.org>; Thu, 31 Oct 2024 11:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.168.196.40
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730373972; cv=none; b=lzMsJm96AAublm2dt6FR9nEpPmw2Jtl6Xaj/cR+XHKPQus7EFAqTXTEH3fHlNTA9VTaUWjAwY0eT7xTjJ1NsXWKkXAILrYupL8e2Qg6alF0y/6tiloSmcf4/wGcKDoabit/UwIQvoXpzwqU+GLV891Wn3q7NtxG0sdvNc/caZJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730373972; c=relaxed/simple;
	bh=uAqyRFMpJDpDmy/5pU//AtZESC2sgNBq73tYitt4gLI=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:Content-Type; b=WAXRitY5exoWEs/blqhyzHYPF/1ItuBqB624aahyxLEzcVMZSsuKGrjGdOe33hnl9A5ElTVAI53vdbNBypX+zL6pli1odzQKZ2EJZc1UQd4y0wELgXPTNTgsiCk8Cpb++hXhJCMGcq+XCCS+QYrAmLV4v1RW+l49dAQbvVDb2CM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sh.cz; spf=pass smtp.mailfrom=sh.cz; dkim=pass (2048-bit key) header.d=sh.cz header.i=@sh.cz header.b=h69vbvf/; arc=none smtp.client-ip=95.168.196.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sh.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sh.cz
DKIM-Signature: a=rsa-sha256; t=1730373642; x=1730978442; s=mail; d=sh.cz; c=relaxed/relaxed; v=1; bh=HfSfvQZGYhCfTSqelCFuyZh1vP7Ic1onBws6dvyB0hE=; h=From:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding;
   b=h69vbvf/UefQV0e+hiWM3YYYAyEwC1fRlN7X6MBHcYs2l26IV6u3CppnSnlgJ30E3Ioaqx6QdXs9clG17DOcQEbU3hOtcEGdk2K9Uitju3gT4X8IjW+oYn0cAvvKmXAzGwH7ZnxyzLHVD8zt6/qwBhW5KUrrr3leWRQPoMVOA87sOdG2I4JHQKKmtE+2BmLV3YQKj9metwnCjfJLQPZdzr9koe5V0qu+MNAtcWA2lDO+6ekeWIucGW2d2emvimdtSNKyISAw7AmuDr7U1e1gsaCxelKfFFyU50UnSFIiPNrxQ12xATvI1r1oXRJX1ItumDWiX6mBJylsTQWlJ2Hmkw==
Received: from [10.0.5.228] ([95.168.203.222])
        by mail.sh.cz (14.1.0 build 12 ) with ASMTP (SSL) id 202410311220424384;
        Thu, 31 Oct 2024 12:20:42 +0100
Message-ID: <38c94aec-81c9-4f62-b44e-1d87f5597644@sh.cz>
Date: Thu, 31 Oct 2024 12:20:41 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Peter Mann <peter.mann@sh.cz>
Subject: [bug report] io_uring: fsfreeze deadlocks when performing O_DIRECT
 writes
Content-Language: en-US
To: axboe@kernel.dk
Cc: asml.silence@gmail.com, io-uring@vger.kernel.org
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hello,

it appears that there is a high probability of a deadlock occuring when 
performing fsfreeze on a filesystem which is currently performing 
multiple io_uring O_DIRECT writes.

Steps to reproduce:
1. Mount xfs or ext4 filesystem on /mnt

2. Start writing to the filesystem. Must use io_uring, direct io and 
iodepth>1 to reproduce:
fio --ioengine=io_uring --direct=1 --bs=4k --size=100M --rw=randwrite 
--loops=100000 --iodepth=32 --name=test --filename=/mnt/fio_test

3. Run this in another shell. For me it deadlocks almost immediately:
while true; do fsfreeze -f /mnt/; echo froze; fsfreeze -u /mnt/; echo 
unfroze; done

4. Fsfreeze and all tasks attempting to write /mnt get stuck:
At this point all stuck processes cannot be killed by SIGKILL and they 
are stuck in uninterruptible sleep.
If you try 'touch /mnt/a' for example, the new process gets stuck in the 
exact same way as well.

This gets printed when running 6.11.4 with some debug options enabled:
[  539.586122] Showing all locks held in the system:
[  539.612972] 1 lock held by khungtaskd/35:
[  539.626204]  #0: ffffffffb3b1c100 (rcu_read_lock){....}-{1:2}, at: 
debug_show_all_locks+0x32/0x1e0
[  539.640561] 1 lock held by dmesg/640:
[  539.654282]  #0: ffff9fd541a8e0e0 (&user->lock){+.+.}-{3:3}, at: 
devkmsg_read+0x74/0x2d0
[  539.669220] 2 locks held by fio/647:
[  539.684253]  #0: ffff9fd54fe720b0 (&ctx->uring_lock){+.+.}-{3:3}, at: 
__do_sys_io_uring_enter+0x5c2/0x820
[  539.699565]  #1: ffff9fd541a8d450 (sb_writers#15){++++}-{0:0}, at: 
io_issue_sqe+0x9c/0x780
[  539.715587] 2 locks held by fio/648:
[  539.732293]  #0: ffff9fd54fe710b0 (&ctx->uring_lock){+.+.}-{3:3}, at: 
__do_sys_io_uring_enter+0x5c2/0x820
[  539.749121]  #1: ffff9fd541a8d450 (sb_writers#15){++++}-{0:0}, at: 
io_issue_sqe+0x9c/0x780
[  539.765484] 2 locks held by fio/649:
[  539.781483]  #0: ffff9fd541a8f0b0 (&ctx->uring_lock){+.+.}-{3:3}, at: 
__do_sys_io_uring_enter+0x5c2/0x820
[  539.798785]  #1: ffff9fd541a8d450 (sb_writers#15){++++}-{0:0}, at: 
io_issue_sqe+0x9c/0x780
[  539.815466] 2 locks held by fio/650:
[  539.831966]  #0: ffff9fd54fe740b0 (&ctx->uring_lock){+.+.}-{3:3}, at: 
__do_sys_io_uring_enter+0x5c2/0x820
[  539.849527]  #1: ffff9fd541a8d450 (sb_writers#15){++++}-{0:0}, at: 
io_issue_sqe+0x9c/0x780
[  539.867469] 1 lock held by fsfreeze/696:
[  539.884565]  #0: ffff9fd541a8d450 (sb_writers#15){++++}-{0:0}, at: 
freeze_super+0x20a/0x600

I reproduced this bug on nvme, sata ssd, virtio disks and lvm logical 
volumes.
It deadlocks on all kernels that I tried (all on amd64):
6.12-rc5 (compiled from kernel.org)
6.11.4 (compiled from kernel.org)
6.10.11-1~bpo12+1 (debian)
6.1.0-23 (debian)
5.14.0-427.40.1.el9_4.x86_64 (rocky linux)
5.10.0-33-amd64 (debian)

I tried to compile some older ones to check if it's a regression, but 
those either didn't compile or didn't boot in my VM, sorry about that.
If you have anything specific for me to try, I'm happy to help.

Found this issue as well, so it seems like it's not just me:
https://gitlab.com/qemu-project/qemu/-/issues/881
Note that mariadb 10.6 adds support for io_uring, and that proxmox 
backups perform fsfreeze in the guest VM.

Originally I discovered this after a scheduled lvm snapshot of mariadb 
got stuck.
It appears that lvm calls dm_suspend, which then calls freeze_super, so 
it looks like the same bug to me.
I discovered the simpler fsfreeze/fio reproduction method when I tried 
to find a workaround.

Regards,
Peter Mann


