Return-Path: <io-uring+bounces-9988-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B510DBD5ADC
	for <lists+io-uring@lfdr.de>; Mon, 13 Oct 2025 20:18:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6DE84420DD0
	for <lists+io-uring@lfdr.de>; Mon, 13 Oct 2025 18:18:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA6D52D3EF1;
	Mon, 13 Oct 2025 18:17:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="Ds+BxQsr"
X-Original-To: io-uring@vger.kernel.org
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2EF52D46A2;
	Mon, 13 Oct 2025 18:17:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760379447; cv=none; b=O1o3ZVgPrMIhekaZegTjUH2IKfn4K8AAjzPgf1wr6h/7lh2KPRBWFbvq35iNz5DELIIPiMlbrjDQMGAewtX4VG2Ct/lenlfzDJQgqMtuAsFeK3o6t9VLlxCx7Y6kOzc2UZq9wZ0EM+LTulUM42s9z8DdTmXRpN/2kXJaoUqhfps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760379447; c=relaxed/simple;
	bh=92tEy1PaWUfTI9jWDoPQt8aah4Mj39xpzZOKHYvLan0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aqmnFkbSEn+Hy1StkCc4Eg8p19fLBIDu7k+DaE5f/kRSAIgpwoontlHGcEHI0lyExVh2j4hlZaeopOFGzNvB7wywhik32qEGzgXHZqWGJ2mf+pG1+ACnHoD1Zz12I56FkZlZKubmnlEiZ8HZU3bpXEm5XnWBIe4JH1yjm9DIf5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=none smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=Ds+BxQsr; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=8JbiAu/wsrNPa4Xt6ePk77R1LZWIO8n4C/tJUdPIOnU=; b=Ds+BxQsrk6ZW5MWVLnncfbMi9/
	4CCYqbuoxsMIHN6s3wi1i6XdPYe3VzF/eIdpZZxnsJJLwjsn3IAd+mwZgXVt1tcGRFpbNMCVWBwkl
	2w4Qll3eOh0uBRL0VnYH30oGS3xarrIRPwSPLvJdHJcVKdtbHMd8LoUqFRlyJNHiBc3dlzqd4b+dM
	+mCNPpWPr7iyVjD1e/Nwn9yIfZQ59POVAXHibibejvK99vv/YIrIGNxQmUqD7rCOcjX+/d27LwDpR
	L451BM38kYSNzmIGA7kiSQgufnpOsXTAfP8oweimludAXNjoD1G3a1togm0L5L0gSZ9fNBGFRUT3y
	0qkztz+Q==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <carnil@debian.org>)
	id 1v8MdY-000Lpv-9G; Mon, 13 Oct 2025 17:47:07 +0000
Received: by eldamar.lan (Postfix, from userid 1000)
	id 14461BE2DE0; Mon, 13 Oct 2025 19:47:06 +0200 (CEST)
Date: Mon, 13 Oct 2025 19:47:06 +0200
From: Salvatore Bonaccorso <carnil@debian.org>
To: Kevin Lumik <kevin@xf.ee>, Jens Axboe <axboe@kernel.dk>
Cc: 1116358@bugs.debian.org, io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org, regressions@lists.linux.dev,
	stable@vger.kernel.org
Subject: [regression] Regression from 90bfb28d5fa8 ("io_uring/rw: drop
 -EOPNOTSUPP check in __io_complete_rw_common()"): LVM snapshots causing I/O
 errors in KVM guest with aio=io_uring set
Message-ID: <aO07Gt9ZtECKuGkJ@eldamar.lan>
References: <f6e2bd310293b720cad7d193b3fdf8369d6bb3ac.camel@xf.ee>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f6e2bd310293b720cad7d193b3fdf8369d6bb3ac.camel@xf.ee>
X-Debian-User: carnil

Hi Jens,

Kevin Lumik reported in Debian the following issue (not exactly a
minimal reproducer, but bisection results follows):

On Fri, Sep 26, 2025 at 10:34:22AM +0300, Kevin Lumik wrote:
 
> Dear Maintainer,
> 
> After upgrading from Debian Bookworm to Trixie, an issue within KVM guests when creating an LVM snapshot of its volume
> has surfaced. When a LVM snapshot is taken from the host, the guest starts to get I/O errors. The issue seems to only
> appear when aio=io_uring is specified in the KVM drive parameters and also seems to resolve when downgrading the kernel
> package down to 6.1. The issue is also not reproducible when using aio=native. 
> 
> KVM args for the drive: "-drive id=drive-
> virtio0,format=raw,file=/dev/dom/vps_testsql,cache=none,aio=io_uring,index=0,media=disk,if=virtio"
> 
> An IO workload is being created in the VM using "fio --randrepeat=1 --ioengine=io_uring --direct=1 --gtod_reduce=1 --
> name=randwrite --filename=/root/test.bin --bs=4k --iodepth=64 --runtime=60 --numjobs=32 --readwrite=randwrite --size=1G
> --rwmixread=75 --group_reporting"
> 
> After running "lvcreate -s /dev/dom/vps_testsql -n test -L 1G" on the host we can observe fio erroring out:
> 
> ...
> fio: io_u error on file /root/test.bin: Input/output error: write offset=46977024, buflen=4096
> fio: pid=7367, err=5/file:io_u.c:1876, func=io_u error, error=Input/output error
> fio: io_u error on file /root/test.bin: Input/output error: write offset=261505024, buflen=4096
> fio: pid=7374, err=5/file:io_u.c:1876, func=io_u error, error=Input/output error
> fio: io_u error on file /root/test.bin: Input/output error: write offset=973840384, buflen=4096
> fio: io_u error on file /root/test.bin: Input/output error: write offset=9637888, buflen=4096
> fio: io_u error on file /root/test.bin: Input/output error: write offset=159965184, buflen=4096
> fio: io_u error on file /root/test.bin: Input/output error: write offset=857505792, buflen=4096
> fio: io_u error on file /root/test.bin: Input/output error: write offset=90787840, buflen=4096
> fio: io_u error on file /root/test.bin: Input/output error: write offset=26427392, buflen=4096
> fio: io_u error on file /root/test.bin: Input/output error: write offset=955621376, buflen=4096
> fio: io_u error on file /root/test.bin: Input/output error: write offset=96169984, buflen=4096
> fio: pid=7372, err=5/file:io_u.c:1876, func=io_u error, error=Input/output error
> fio: pid=7362, err=5/file:io_u.c:1876, func=io_u error, error=Input/output error
> fio: io_u error on file /root/test.bin: Input/output error: write offset=203702272, buflen=4096
> fio: io_u error on file /root/test.bin: Input/output error: write offset=814649344, buflen=4096
> fio: io_u error on file /root/test.bin: Input/output error: write offset=91467776, buflen=4096
> fio: io_u error on file /root/test.bin: Input/output error: write offset=948256768, buflen=4096
> fio: io_u error on file /root/test.bin: Input/output error: write offset=105295872, buflen=4096
> fio: io_u error on file /root/test.bin: Input/output error: write offset=75247616, buflen=4096
> fio: io_u error on file /root/test.bin: Input/output error: write offset=1062293504, buflen=4096
> fio: io_u error on file /root/test.bin: Input/output error: write offset=111955968, buflen=4096
> fio: io_u error on file /root/test.bin: Input/output error: write offset=942563328, buflen=4096
> fio: io_u error on file /root/test.bin: Input/output error: write offset=117354496, buflen=4096
> fio: io_u error on file /root/test.bin: Input/output error: write offset=1050402816, buflen=4096
> fio: io_u error on file /root/test.bin: Input/output error: write offset=125419520, buflen=4096
> fio: io_u error on file /root/test.bin: Input/output error: write offset=129044480, buflen=4096
> fio: pid=7369, err=5/file:io_u.c:1876, func=io_u error, error=Input/output error
> fio: pid=7373, err=5/file:io_u.c:1876, func=io_u error, error=Input/output error
> fio: pid=7348, err=5/file:io_u.c:1876, func=io_u error, error=Input/output error
> fio: pid=7375, err=5/file:io_u.c:1876, func=io_u error, error=Input/output error
> fio: pid=7358, err=5/file:io_u.c:1876, func=io_u error, error=Input/output error
> fio: pid=7359, err=5/file:io_u.c:1876, func=io_u error, error=Input/output error
> 
> randwrite: (groupid=0, jobs=32): err= 5 (file:io_u.c:1876, func=io_u error, error=Input/output error): pid=7344: Thu Sep
> 25 16:28:30 2025
>   write: IOPS=194k, BW=758MiB/s (795MB/s)(3976MiB/5244msec); 0 zone resets
>    bw (  KiB/s): min=657104, max=1009816, per=100.00%, avg=785345.80, stdev=4331.73, samples=320
>    iops        : min=164276, max=252454, avg=196336.40, stdev=1082.93, samples=320
>   cpu          : usr=0.33%, sys=1.07%, ctx=18912, majf=0, minf=455
>   IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=0.1%, >=64=99.8%
>      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>      complete  : 0=0.1%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.1%, >=64=0.0%
>      issued rwts: total=0,1019955,0,0 short=0,0,0,0 dropped=0,0,0,0
>      latency   : target=0, window=0, percentile=100.00%, depth=64
> 
> Run status group 0 (all jobs):
>   WRITE: bw=758MiB/s (795MB/s), 758MiB/s-758MiB/s (795MB/s-795MB/s), io=3976MiB (4169MB), run=5244-5244msec
> 
> Disk stats (read/write):
>   vda: ios=1/1001361, merge=0/2, ticks=0/10314531, in_queue=10314549, util=97.82%
> Bus error
> 
> ---
> 
> And the error is also visible in the kernel error log of the VM:
> [  361.962970] I/O error, dev vda, sector 83277192 op 0x1:(WRITE) flags 0x8800 phys_seg 1 prio class 2
> [  361.963945] I/O error, dev vda, sector 83067480 op 0x1:(WRITE) flags 0x8800 phys_seg 1 prio class 2
> [  361.964489] I/O error, dev vda, sector 82881208 op 0x1:(WRITE) flags 0x8800 phys_seg 1 prio class 2
> [  361.964499] I/O error, dev vda, sector 83031976 op 0x1:(WRITE) flags 0x8800 phys_seg 1 prio class 2
> [  361.964501] I/O error, dev vda, sector 83089832 op 0x1:(WRITE) flags 0x8800 phys_seg 1 prio class 2
> [  361.964503] I/O error, dev vda, sector 83156184 op 0x1:(WRITE) flags 0x8800 phys_seg 1 prio class 2
> [  361.964522] I/O error, dev vda, sector 83183384 op 0x1:(WRITE) flags 0x8800 phys_seg 1 prio class 2
> [  361.964524] I/O error, dev vda, sector 83310704 op 0x1:(WRITE) flags 0x8800 phys_seg 1 prio class 2
> [  361.964525] I/O error, dev vda, sector 83311144 op 0x1:(WRITE) flags 0x8800 phys_seg 1 prio class 2
> [  361.964532] I/O error, dev vda, sector 83315272 op 0x1:(WRITE) flags 0x8800 phys_seg 1 prio class 2
> 
> The host does not generate any erros, they only seem to occur within the VM.

Now I asked Kevin if a bisection is possible, and the following
results was found (https://bugs.debian.org/1116358#41):

I've identified the first bad commit using git bisect:

90bfb28d5fa8127a113a140c9791ea0b40ab156a is the first bad commit
commit 90bfb28d5fa8127a113a140c9791ea0b40ab156a
Author: Jens Axboe <axboe@kernel.dk>
Date:   Tue Sep 10 08:57:04 2024 -0600

    io_uring/rw: drop -EOPNOTSUPP check in __io_complete_rw_common()

    A recent change ensured that the necessary -EOPNOTSUPP -> -EAGAIN
    transformation happens inline on both the reader and writer side,
    and hence there's no need to check for both of these anymore on
    the completion handler side.

    Signed-off-by: Jens Axboe <axboe@kernel.dk>

 io_uring/rw.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)


Here is the git bisect log as well:

git bisect start
# status: waiting for both good and bad commits
# good: [98f7e32f20d28ec452afb208f9cffc08448a2652] Linux 6.11
git bisect good 98f7e32f20d28ec452afb208f9cffc08448a2652
# status: waiting for bad commit, 1 good commit known
# bad: [59b723cd2adbac2a34fc8e12c74ae26ae45bf230] Linux 6.12-rc6
git bisect bad 59b723cd2adbac2a34fc8e12c74ae26ae45bf230
# bad: [de848da12f752170c2ebe114804a985314fd5a6a] Merge tag 'drm-next-2024-09-19' of https://gitlab.freedesktop.org/drm/kernel
git bisect bad de848da12f752170c2ebe114804a985314fd5a6a
# bad: [7b17f5ebd5fc5e9275eaa5af3d0771f2a7b01bbf] Merge tag 'soc-dt-6.12' of git://git.kernel.org/pub/scm/linux/kernel/git/soc/soc
git bisect bad 7b17f5ebd5fc5e9275eaa5af3d0771f2a7b01bbf
# good: [64dd3b6a79f0907d36de481b0f15fab323a53e5a] Merge tag 'for-linus-non-x86' of git://git.kernel.org/pub/scm/virt/kvm/kvm
git bisect good 64dd3b6a79f0907d36de481b0f15fab323a53e5a
# bad: [daa394f0f9d3cb002c72e2d3db99972e2ee42862] Merge tag 'core-debugobjects-2024-09-16' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect bad daa394f0f9d3cb002c72e2d3db99972e2ee42862
# good: [effdcd5275ed645f6e0f8e8ce690b97795722197] Merge tag 'affs-for-6.12-tag' of git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux
git bisect good effdcd5275ed645f6e0f8e8ce690b97795722197
# bad: [26bb0d3f38a764b743a3ad5c8b6e5b5044d7ceb4] Merge tag 'for-6.12/block-20240913' of git://git.kernel.dk/linux
git bisect bad 26bb0d3f38a764b743a3ad5c8b6e5b5044d7ceb4
# bad: [3a4d319a8fb5a9bbdf5b31ef32841eb286b1dcc2] Merge tag 'for-6.12/io_uring-20240913' of git://git.kernel.dk/linux
git bisect bad 3a4d319a8fb5a9bbdf5b31ef32841eb286b1dcc2
# good: [df2825e98507d10cb037a308087ecd7cb3f6688d] btrfs: always pass readahead state to defrag
git bisect good df2825e98507d10cb037a308087ecd7cb3f6688d
# good: [69a3a0a45a2f72412c2ba31761cc9193bb746fef] Merge tag 'erofs-for-6.12-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs
git bisect good 69a3a0a45a2f72412c2ba31761cc9193bb746fef
# good: [ecd5c9b29643f383d39320e30d21b8615bd893da] io_uring/kbuf: add io_kbuf_commit() helper
git bisect good ecd5c9b29643f383d39320e30d21b8615bd893da
# good: [f011c9cf04c06f16b24f583d313d3c012e589e50] io_uring/sqpoll: do not allow pinning outside of cpuset
git bisect good f011c9cf04c06f16b24f583d313d3c012e589e50
# bad: [84eacf177faa605853c58e5b1c0d9544b88c16fd] io_uring/io-wq: inherit cpuset of cgroup in io worker
git bisect bad 84eacf177faa605853c58e5b1c0d9544b88c16fd
# bad: [90bfb28d5fa8127a113a140c9791ea0b40ab156a] io_uring/rw: drop - EOPNOTSUPP check in __io_complete_rw_common()
git bisect bad 90bfb28d5fa8127a113a140c9791ea0b40ab156a
# good: [c0a9d496e0fece67db777bd48550376cf2960c47] io_uring/rw: treat - EOPNOTSUPP for IOCB_NOWAIT like -EAGAIN
git bisect good c0a9d496e0fece67db777bd48550376cf2960c47
# first bad commit: [90bfb28d5fa8127a113a140c9791ea0b40ab156a] io_uring/rw: drop -EOPNOTSUPP check in __io_complete_rw_common()

#regzbot introduced: 90bfb28d5fa8127a113a140c9791ea0b40ab156a
#regzbot link: https://bugs.debian.org/1116358

Does thi ring any bell?

Regards,
Salvatore

