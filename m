Return-Path: <io-uring+bounces-9986-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4230ABD5A2A
	for <lists+io-uring@lfdr.de>; Mon, 13 Oct 2025 20:04:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6828B18A6439
	for <lists+io-uring@lfdr.de>; Mon, 13 Oct 2025 18:04:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54D792D0C9F;
	Mon, 13 Oct 2025 18:04:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ojpclt3l"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f181.google.com (mail-il1-f181.google.com [209.85.166.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBA072C15A3
	for <io-uring@vger.kernel.org>; Mon, 13 Oct 2025 18:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760378659; cv=none; b=ZrLkiuPb7TUrWFpeoUhnuCK2dtFXRYw0hMAPR4B3pam37zL4eIWs3rkipmgSub9rr7x22NTg0s4ybkPdMKVWUc50ufG6TGst12D7pc6sPgGiewstEp5aPN8XTfgKPybUIMBqKf+VpirBb0ua3Q63NEgWxDutcaL3vDAA4lx4rsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760378659; c=relaxed/simple;
	bh=m+yXzWPZoIycghwzGcPhv/NlAyi3SuK0XhoWLox95+Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qcVPp89lWVVfA8IkkE8zLzuAK8/HWujdnOK3ZI09gg0LM65gd9QN53NKcOBlPJLtpqqCJT6SoC+btrS7gnsh87MOT5s+RqQsEAAlyz3y1nQPuVYcD60PcwvbM7VW7i/Gwv8w1oCsX8WcvjD2b+U2fPByIjwN57mFgdqLmvsin3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ojpclt3l; arc=none smtp.client-ip=209.85.166.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f181.google.com with SMTP id e9e14a558f8ab-42f67e91ae7so48044195ab.0
        for <io-uring@vger.kernel.org>; Mon, 13 Oct 2025 11:04:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1760378655; x=1760983455; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=E8igWH8DcuinLwAD/oSviw5uom79r9hVi68AOlgT+Jg=;
        b=ojpclt3lQWzLkJNfxH0BIRWUE14hMs0hAoJLw1aIEJxLwkYLwrjSniG3YqK5hlCsJa
         B7x3fKfpO4FUgnzX4QaCgUj0PyegRL6IqgFNrRg9Q7c30MCAFd1GUcXZTWIy6RQ2SJ4V
         6PYmd5V3Xv8ztEajrbpZqGVnm5dleFnj7B9k4Hv41GGpmEJEA4iPO81LQYQUT8QiMXdE
         GQIWqrFXjpEEEK0ZAVK8i/qmEeWsFBoGEc/OHxmWXmY6AP3jzCcvJfd0EZUQTsLBvEP3
         5IoR4wqJqvYutl9vADGsEhA6Ykd4ucCOp4K84QNpJnHH6y/fCbF/wj7Q2AEm4sVt9vhC
         fYjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760378655; x=1760983455;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=E8igWH8DcuinLwAD/oSviw5uom79r9hVi68AOlgT+Jg=;
        b=dGZAcCCiYsUihEJ9PrAKxTvm2gUVcNwbw8jBulqY0GKiJhHZ9wUcw9/dOgrrEueBA9
         o4nFQklVw92zExkScSk31OLXb4EAGZWhkym8KuB0YublPz56LKlandBf+xUlDiSkflNs
         fVwpk6yvqM4B4adnlaOkdTUdd5puJZISsg75SExFBVZpf7OkFb+edJm7bq6wLM9yA6YQ
         GGT8/B9gQJg829dzuLEDcpDNJWCMoU8DRHt33o459UhVqvjZcIMIXLGG2usLtbAtFAAu
         hwwcH5ao7ozlIsKBbsBZPRqMnyj+r8C0DxGMNUZtssEQSZuVoGibNuAph9No71pCKymk
         TGJw==
X-Forwarded-Encrypted: i=1; AJvYcCXE4R/Fu7AhR0GMgDKV4+QN5/Hpz//F5wft2iDSNLJMUlyalwVZKLUg4Vc5510jCwBSlhtWNlXOcQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxtC/z2g1JLtTtvsec7QN9htpOfsIMMvbZMlgXywe4w9rowlGPy
	hymspoHaF8tbuF+MvE8Y7HGJUfuGW/JbB251BNXZ3jLcnMmM23sQTMTp5cXQLymH8BI=
X-Gm-Gg: ASbGncvToTTOf8Y2Obp5P0Dd1d4V6g+A+5ZOkBnLfeardm8INK5BaTzW1ffAheTKnZC
	/2Jt++5oelIcx9f7JDun6gS8RFhEwxeZ1amWYrYcLJg+5/JgwHFhN6J+kwa6qSmCXpXSh8hfp29
	rR4zGoBwtMjOoygkzbYGBGEu/ahdVQKVn2iRN6m1hDcbh81TK1YVJRTBD78VkbVMaTkQjDy5Ali
	i+SBqmUNPmQVmgotgnJxxDb6XWkIR7iIySXrfaK6bzkl3mD54fFsElj04Scn7keh/748560gQK6
	QLR1NyHxT6YSGJcd38/ke8P4NPIxwe8+dSzU3CgEc6ve4U6sMegSVqsdg/+62HVIbbmbL/WrM/v
	dhLyK+AGSH1GXAoB8kr3KUfS5LRre96AYEjYWjQ==
X-Google-Smtp-Source: AGHT+IGvU54cMClEuUuP3c619ZbLtmf9IdAbnaPWCwj6ZE9MHLRB1SAO44OEies2s5PJ/JmGo7Rybg==
X-Received: by 2002:a05:6e02:16ca:b0:430:9f96:23b2 with SMTP id e9e14a558f8ab-4309f9624d6mr7417065ab.5.1760378654846;
        Mon, 13 Oct 2025 11:04:14 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-58f6cd58e48sm4015507173.17.2025.10.13.11.04.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Oct 2025 11:04:13 -0700 (PDT)
Message-ID: <cceb723c-051b-4de2-9a4c-4aa82e1619ee@kernel.dk>
Date: Mon, 13 Oct 2025 12:04:12 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [regression] Regression from 90bfb28d5fa8 ("io_uring/rw: drop
 -EOPNOTSUPP check in __io_complete_rw_common()"): LVM snapshots causing I/O
 errors in KVM guest with aio=io_uring set
To: Salvatore Bonaccorso <carnil@debian.org>, Kevin Lumik <kevin@xf.ee>
Cc: 1116358@bugs.debian.org, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org, regressions@lists.linux.dev,
 stable@vger.kernel.org
References: <f6e2bd310293b720cad7d193b3fdf8369d6bb3ac.camel@xf.ee>
 <aO07Gt9ZtECKuGkJ@eldamar.lan>
From: Jens Axboe <axboe@kernel.dk>
Content-Language: en-US
In-Reply-To: <aO07Gt9ZtECKuGkJ@eldamar.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/13/25 11:47 AM, Salvatore Bonaccorso wrote:
> Hi Jens,
> 
> Kevin Lumik reported in Debian the following issue (not exactly a
> minimal reproducer, but bisection results follows):
> 
> On Fri, Sep 26, 2025 at 10:34:22AM +0300, Kevin Lumik wrote:
>  
>> Dear Maintainer,
>>
>> After upgrading from Debian Bookworm to Trixie, an issue within KVM guests when creating an LVM snapshot of its volume
>> has surfaced. When a LVM snapshot is taken from the host, the guest starts to get I/O errors. The issue seems to only
>> appear when aio=io_uring is specified in the KVM drive parameters and also seems to resolve when downgrading the kernel
>> package down to 6.1. The issue is also not reproducible when using aio=native. 
>>
>> KVM args for the drive: "-drive id=drive-
>> virtio0,format=raw,file=/dev/dom/vps_testsql,cache=none,aio=io_uring,index=0,media=disk,if=virtio"
>>
>> An IO workload is being created in the VM using "fio --randrepeat=1 --ioengine=io_uring --direct=1 --gtod_reduce=1 --
>> name=randwrite --filename=/root/test.bin --bs=4k --iodepth=64 --runtime=60 --numjobs=32 --readwrite=randwrite --size=1G
>> --rwmixread=75 --group_reporting"
>>
>> After running "lvcreate -s /dev/dom/vps_testsql -n test -L 1G" on the host we can observe fio erroring out:
>>
>> ...
>> fio: io_u error on file /root/test.bin: Input/output error: write offset=46977024, buflen=4096
>> fio: pid=7367, err=5/file:io_u.c:1876, func=io_u error, error=Input/output error
>> fio: io_u error on file /root/test.bin: Input/output error: write offset=261505024, buflen=4096
>> fio: pid=7374, err=5/file:io_u.c:1876, func=io_u error, error=Input/output error
>> fio: io_u error on file /root/test.bin: Input/output error: write offset=973840384, buflen=4096
>> fio: io_u error on file /root/test.bin: Input/output error: write offset=9637888, buflen=4096
>> fio: io_u error on file /root/test.bin: Input/output error: write offset=159965184, buflen=4096
>> fio: io_u error on file /root/test.bin: Input/output error: write offset=857505792, buflen=4096
>> fio: io_u error on file /root/test.bin: Input/output error: write offset=90787840, buflen=4096
>> fio: io_u error on file /root/test.bin: Input/output error: write offset=26427392, buflen=4096
>> fio: io_u error on file /root/test.bin: Input/output error: write offset=955621376, buflen=4096
>> fio: io_u error on file /root/test.bin: Input/output error: write offset=96169984, buflen=4096
>> fio: pid=7372, err=5/file:io_u.c:1876, func=io_u error, error=Input/output error
>> fio: pid=7362, err=5/file:io_u.c:1876, func=io_u error, error=Input/output error
>> fio: io_u error on file /root/test.bin: Input/output error: write offset=203702272, buflen=4096
>> fio: io_u error on file /root/test.bin: Input/output error: write offset=814649344, buflen=4096
>> fio: io_u error on file /root/test.bin: Input/output error: write offset=91467776, buflen=4096
>> fio: io_u error on file /root/test.bin: Input/output error: write offset=948256768, buflen=4096
>> fio: io_u error on file /root/test.bin: Input/output error: write offset=105295872, buflen=4096
>> fio: io_u error on file /root/test.bin: Input/output error: write offset=75247616, buflen=4096
>> fio: io_u error on file /root/test.bin: Input/output error: write offset=1062293504, buflen=4096
>> fio: io_u error on file /root/test.bin: Input/output error: write offset=111955968, buflen=4096
>> fio: io_u error on file /root/test.bin: Input/output error: write offset=942563328, buflen=4096
>> fio: io_u error on file /root/test.bin: Input/output error: write offset=117354496, buflen=4096
>> fio: io_u error on file /root/test.bin: Input/output error: write offset=1050402816, buflen=4096
>> fio: io_u error on file /root/test.bin: Input/output error: write offset=125419520, buflen=4096
>> fio: io_u error on file /root/test.bin: Input/output error: write offset=129044480, buflen=4096
>> fio: pid=7369, err=5/file:io_u.c:1876, func=io_u error, error=Input/output error
>> fio: pid=7373, err=5/file:io_u.c:1876, func=io_u error, error=Input/output error
>> fio: pid=7348, err=5/file:io_u.c:1876, func=io_u error, error=Input/output error
>> fio: pid=7375, err=5/file:io_u.c:1876, func=io_u error, error=Input/output error
>> fio: pid=7358, err=5/file:io_u.c:1876, func=io_u error, error=Input/output error
>> fio: pid=7359, err=5/file:io_u.c:1876, func=io_u error, error=Input/output error
>>
>> randwrite: (groupid=0, jobs=32): err= 5 (file:io_u.c:1876, func=io_u error, error=Input/output error): pid=7344: Thu Sep
>> 25 16:28:30 2025
>>   write: IOPS=194k, BW=758MiB/s (795MB/s)(3976MiB/5244msec); 0 zone resets
>>    bw (  KiB/s): min=657104, max=1009816, per=100.00%, avg=785345.80, stdev=4331.73, samples=320
>>    iops        : min=164276, max=252454, avg=196336.40, stdev=1082.93, samples=320
>>   cpu          : usr=0.33%, sys=1.07%, ctx=18912, majf=0, minf=455
>>   IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=0.1%, >=64=99.8%
>>      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>>      complete  : 0=0.1%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.1%, >=64=0.0%
>>      issued rwts: total=0,1019955,0,0 short=0,0,0,0 dropped=0,0,0,0
>>      latency   : target=0, window=0, percentile=100.00%, depth=64
>>
>> Run status group 0 (all jobs):
>>   WRITE: bw=758MiB/s (795MB/s), 758MiB/s-758MiB/s (795MB/s-795MB/s), io=3976MiB (4169MB), run=5244-5244msec
>>
>> Disk stats (read/write):
>>   vda: ios=1/1001361, merge=0/2, ticks=0/10314531, in_queue=10314549, util=97.82%
>> Bus error
>>
>> ---
>>
>> And the error is also visible in the kernel error log of the VM:
>> [  361.962970] I/O error, dev vda, sector 83277192 op 0x1:(WRITE) flags 0x8800 phys_seg 1 prio class 2
>> [  361.963945] I/O error, dev vda, sector 83067480 op 0x1:(WRITE) flags 0x8800 phys_seg 1 prio class 2
>> [  361.964489] I/O error, dev vda, sector 82881208 op 0x1:(WRITE) flags 0x8800 phys_seg 1 prio class 2
>> [  361.964499] I/O error, dev vda, sector 83031976 op 0x1:(WRITE) flags 0x8800 phys_seg 1 prio class 2
>> [  361.964501] I/O error, dev vda, sector 83089832 op 0x1:(WRITE) flags 0x8800 phys_seg 1 prio class 2
>> [  361.964503] I/O error, dev vda, sector 83156184 op 0x1:(WRITE) flags 0x8800 phys_seg 1 prio class 2
>> [  361.964522] I/O error, dev vda, sector 83183384 op 0x1:(WRITE) flags 0x8800 phys_seg 1 prio class 2
>> [  361.964524] I/O error, dev vda, sector 83310704 op 0x1:(WRITE) flags 0x8800 phys_seg 1 prio class 2
>> [  361.964525] I/O error, dev vda, sector 83311144 op 0x1:(WRITE) flags 0x8800 phys_seg 1 prio class 2
>> [  361.964532] I/O error, dev vda, sector 83315272 op 0x1:(WRITE) flags 0x8800 phys_seg 1 prio class 2
>>
>> The host does not generate any erros, they only seem to occur within the VM.
> 
> Now I asked Kevin if a bisection is possible, and the following
> results was found (https://bugs.debian.org/1116358#41):
> 
> I've identified the first bad commit using git bisect:
> 
> 90bfb28d5fa8127a113a140c9791ea0b40ab156a is the first bad commit
> commit 90bfb28d5fa8127a113a140c9791ea0b40ab156a
> Author: Jens Axboe <axboe@kernel.dk>
> Date:   Tue Sep 10 08:57:04 2024 -0600
> 
>     io_uring/rw: drop -EOPNOTSUPP check in __io_complete_rw_common()
> 
>     A recent change ensured that the necessary -EOPNOTSUPP -> -EAGAIN
>     transformation happens inline on both the reader and writer side,
>     and hence there's no need to check for both of these anymore on
>     the completion handler side.
> 
>     Signed-off-by: Jens Axboe <axboe@kernel.dk>
> 
>  io_uring/rw.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> 
> Here is the git bisect log as well:
> 
> git bisect start
> # status: waiting for both good and bad commits
> # good: [98f7e32f20d28ec452afb208f9cffc08448a2652] Linux 6.11
> git bisect good 98f7e32f20d28ec452afb208f9cffc08448a2652
> # status: waiting for bad commit, 1 good commit known
> # bad: [59b723cd2adbac2a34fc8e12c74ae26ae45bf230] Linux 6.12-rc6
> git bisect bad 59b723cd2adbac2a34fc8e12c74ae26ae45bf230
> # bad: [de848da12f752170c2ebe114804a985314fd5a6a] Merge tag 'drm-next-2024-09-19' of https://gitlab.freedesktop.org/drm/kernel
> git bisect bad de848da12f752170c2ebe114804a985314fd5a6a
> # bad: [7b17f5ebd5fc5e9275eaa5af3d0771f2a7b01bbf] Merge tag 'soc-dt-6.12' of git://git.kernel.org/pub/scm/linux/kernel/git/soc/soc
> git bisect bad 7b17f5ebd5fc5e9275eaa5af3d0771f2a7b01bbf
> # good: [64dd3b6a79f0907d36de481b0f15fab323a53e5a] Merge tag 'for-linus-non-x86' of git://git.kernel.org/pub/scm/virt/kvm/kvm
> git bisect good 64dd3b6a79f0907d36de481b0f15fab323a53e5a
> # bad: [daa394f0f9d3cb002c72e2d3db99972e2ee42862] Merge tag 'core-debugobjects-2024-09-16' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
> git bisect bad daa394f0f9d3cb002c72e2d3db99972e2ee42862
> # good: [effdcd5275ed645f6e0f8e8ce690b97795722197] Merge tag 'affs-for-6.12-tag' of git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux
> git bisect good effdcd5275ed645f6e0f8e8ce690b97795722197
> # bad: [26bb0d3f38a764b743a3ad5c8b6e5b5044d7ceb4] Merge tag 'for-6.12/block-20240913' of git://git.kernel.dk/linux
> git bisect bad 26bb0d3f38a764b743a3ad5c8b6e5b5044d7ceb4
> # bad: [3a4d319a8fb5a9bbdf5b31ef32841eb286b1dcc2] Merge tag 'for-6.12/io_uring-20240913' of git://git.kernel.dk/linux
> git bisect bad 3a4d319a8fb5a9bbdf5b31ef32841eb286b1dcc2
> # good: [df2825e98507d10cb037a308087ecd7cb3f6688d] btrfs: always pass readahead state to defrag
> git bisect good df2825e98507d10cb037a308087ecd7cb3f6688d
> # good: [69a3a0a45a2f72412c2ba31761cc9193bb746fef] Merge tag 'erofs-for-6.12-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs
> git bisect good 69a3a0a45a2f72412c2ba31761cc9193bb746fef
> # good: [ecd5c9b29643f383d39320e30d21b8615bd893da] io_uring/kbuf: add io_kbuf_commit() helper
> git bisect good ecd5c9b29643f383d39320e30d21b8615bd893da
> # good: [f011c9cf04c06f16b24f583d313d3c012e589e50] io_uring/sqpoll: do not allow pinning outside of cpuset
> git bisect good f011c9cf04c06f16b24f583d313d3c012e589e50
> # bad: [84eacf177faa605853c58e5b1c0d9544b88c16fd] io_uring/io-wq: inherit cpuset of cgroup in io worker
> git bisect bad 84eacf177faa605853c58e5b1c0d9544b88c16fd
> # bad: [90bfb28d5fa8127a113a140c9791ea0b40ab156a] io_uring/rw: drop - EOPNOTSUPP check in __io_complete_rw_common()
> git bisect bad 90bfb28d5fa8127a113a140c9791ea0b40ab156a
> # good: [c0a9d496e0fece67db777bd48550376cf2960c47] io_uring/rw: treat - EOPNOTSUPP for IOCB_NOWAIT like -EAGAIN
> git bisect good c0a9d496e0fece67db777bd48550376cf2960c47
> # first bad commit: [90bfb28d5fa8127a113a140c9791ea0b40ab156a] io_uring/rw: drop -EOPNOTSUPP check in __io_complete_rw_common()
> 
> #regzbot introduced: 90bfb28d5fa8127a113a140c9791ea0b40ab156a
> #regzbot link: https://bugs.debian.org/1116358
> 
> Does thi ring any bell?

Thanks to both of you, this is very useful! I guess the original commit
is mistaken, there's still a bubbling up of EOPNOTSUPP there. I'd say
let's just revert that commit, I will do that upstream and have it buble
down to the stable kernels too.

I can always look into this later and reintroduce it, if need be.

-- 
Jens Axboe

