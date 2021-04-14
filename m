Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9865A35FD48
	for <lists+io-uring@lfdr.de>; Wed, 14 Apr 2021 23:29:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236715AbhDNV3g (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 14 Apr 2021 17:29:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231280AbhDNV3L (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 14 Apr 2021 17:29:11 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98172C061574;
        Wed, 14 Apr 2021 14:28:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Date:Message-ID:From:Cc:To;
        bh=D+qmhSLHSu+1CnAqjnLDBxCE3Mdynw4Pw6wcaorfuag=; b=ghUgd7fJ41vVNijubQPYKzMTB8
        FTGlqYIHRDs9Z8ifFZcnQc0p9ppoxcDgV+vMpbFEHK2IFXZ+/o8oN6jaOG9kxgUTBeRYbaqhG22iH
        LeTF5yqj6oPFgIK9s8aVZYmakToG6OWbKDp06uYRhyuCkzPOGECgDfdO3mRowFyae5X5SYHAaHeWs
        QUsMLJqMehAv4i7dzjDRbEGf5fTpDYKxyOMqPHQqHo5KGkOOwBIUTPp/IY2LZPhgyuSZqwXBvQ3an
        HDgaxjWbvLt2qacFxpDkByNgUT+ZislJPhIoXkKisP7mPHKjU9spPCSU6bNEpsnr9P3Pm0EkssV0L
        xDpVf/K8kXrO35aXjH1XQwjvclBl2Hb8OYzwwys7aNJasVECbv+dO8UmwP2ZU+btctu4S2cHxnvs8
        wxdt9LxJ0YK69RSlhijnH4SWoN5nl5xEWx0/wrKtYgmUZABlyI8WjW9n0AM1GvNi3gKi+9R/FIl4i
        eEvS+sYJ57HxRuM5TtgZlvLK;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1lWn41-0005p5-OQ; Wed, 14 Apr 2021 21:28:45 +0000
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>
Cc:     linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
References: <20210411152705.2448053-1-metze@samba.org>
From:   Stefan Metzmacher <metze@samba.org>
Subject: Re: [PATCH] io_thread/x86: don't reset 'cs', 'ss', 'ds' and 'es'
 registers for io_threads
Message-ID: <b5e70a29-e2ad-15a8-2291-37571fa361cc@samba.org>
Date:   Wed, 14 Apr 2021 23:28:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210411152705.2448053-1-metze@samba.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Jens, hi Linus,

any comments on that patch?

On a system with 'uname -m -p -i -r'

  5.12.0-rc7 x86_64 x86_64 x86_64

and a ubuntu 20.04 amd64 userspace.

I compiled 3 versions of liburing + the following diff:

diff --git a/examples/io_uring-cp.c b/examples/io_uring-cp.c
index 2a44c30d0089..91722a79b2bd 100644
--- a/examples/io_uring-cp.c
+++ b/examples/io_uring-cp.c
@@ -116,13 +116,16 @@ static void queue_write(struct io_uring *ring, struct io_data *data)
 	io_uring_submit(ring);
 }

-static int copy_file(struct io_uring *ring, off_t insize)
+static int copy_file(struct io_uring *ring, off_t _insize)
 {
+	off_t insize = _insize;
 	unsigned long reads, writes;
 	struct io_uring_cqe *cqe;
 	off_t write_left, offset;
 	int ret;

+again:
+	insize = _insize;
 	write_left = insize;
 	writes = reads = offset = 0;

@@ -176,6 +179,7 @@ static int copy_file(struct io_uring *ring, off_t insize)
 					ret = 0;
 				}
 			}
+			if (ret == -EINTR) { cqe = NULL; ret = 0; }
 			if (ret < 0) {
 				fprintf(stderr, "io_uring_peek_cqe: %s\n",
 							strerror(-ret));
@@ -239,6 +243,7 @@ static int copy_file(struct io_uring *ring, off_t insize)
 		writes--;
 		io_uring_cqe_seen(ring, cqe);
 	}
+	goto again;

 	return 0;
 }

I compiled it in 3 versions:

CFLAGS="-g -m32" CXX=false make
=> file examples/io_uring-cp
examples/io_uring-cp: ELF 32-bit LSB shared object, Intel 80386, version 1 (SYSV), dynamically linked, interpreter /lib/ld-linux.so.2,
BuildID[sha1]=1a5cabd082925497d146a041fd5c5cff6ded75da, for GNU/Linux 3.2.0, with debug_info, not stripped

CFLAGS="-g -mx32" CXX=false make
=> file examples/io_uring-cp
examples/io_uring-cp: ELF 32-bit LSB shared object, x86-64, version 1 (SYSV), dynamically linked, interpreter /libx32/ld-linux-x32.so.2,
BuildID[sha1]=a8bf06124c44364a8d7aedfeb3faa736feff6452, for GNU/Linux 3.4.0, with debug_info, not stripped

CFLAGS="-g -m64" CXX=false make
=> file examples/io_uring-cp
examples/io_uring-cp: ELF 64-bit LSB shared object, x86-64, version 1 (SYSV), dynamically linked, interpreter /lib64/ld-linux-x86-64.so.2,
BuildID[sha1]=638c682173adad3c09c67af4d1888fbb3b260627, for GNU/Linux 3.2.0, with debug_info, not stripped

With a plain 5.12-rc7 gcc prints the following output:

With -m64:

# gdb -q --batch --ex="set height 0" --ex="thread apply all bt" --pid 8743
[New LWP 8744]
[New LWP 8745]

warning: Selected architecture i386:x86-64 is not compatible with reported target architecture i386

warning: Architecture rejected target-supplied description
syscall () at ../sysdeps/unix/sysv/linux/x86_64/syscall.S:38
38      ../sysdeps/unix/sysv/linux/x86_64/syscall.S: No such file or directory.

Thread 3 (LWP 8745):
#0  0x0000000000000000 in ?? ()
Backtrace stopped: Cannot access memory at address 0x0

Thread 2 (LWP 8744):
#0  0x0000000000000000 in ?? ()
Backtrace stopped: Cannot access memory at address 0x0

Thread 1 (LWP 8743):
#0  syscall () at ../sysdeps/unix/sysv/linux/x86_64/syscall.S:38
#1  0x000055b78731042b in __sys_io_uring_enter2 (fd=5, to_submit=0, min_complete=1, flags=1, sig=0x0, sz=8) at syscall.c:54
#2  0x000055b78730fc52 in _io_uring_get_cqe (ring=0x7ffd91bce680, cqe_ptr=0x7ffd91bce600, data=0x7ffd91bce560) at queue.c:122
#3  0x000055b78730fd19 in __io_uring_get_cqe (ring=0x7ffd91bce680, cqe_ptr=0x7ffd91bce600, submit=0, wait_nr=1, sigmask=0x0) at queue.c:150
#4  0x000055b78730e58c in io_uring_wait_cqe_nr (ring=0x7ffd91bce680, cqe_ptr=0x7ffd91bce600, wait_nr=1) at ../src/include/liburing.h:635
#5  0x000055b78730e5e0 in io_uring_wait_cqe (ring=0x7ffd91bce680, cqe_ptr=0x7ffd91bce600) at ../src/include/liburing.h:655
#6  0x000055b78730ecf2 in copy_file (ring=0x7ffd91bce680, _insize=24) at io_uring-cp.c:232
#7  0x000055b78730eef5 in main (argc=3, argv=0x7ffd91bce858) at io_uring-cp.c:278
[Inferior 1 (process 8743) detached]

With -mx32:

gdb -q --batch --ex="set height 0" --ex="thread apply all bt" --pid 8821
[New LWP 8822]
[New LWP 8823]

warning: Selected architecture i386:x64-32 is not compatible with reported target architecture i386

warning: Architecture rejected target-supplied description
0xf7e66d1d in syscall () from /libx32/libc.so.6

Thread 3 (LWP 8823):
#0  0x00000000 in ?? ()
Backtrace stopped: Cannot access memory at address 0x0

Thread 2 (LWP 8822):
#0  0x00000000 in ?? ()
Backtrace stopped: Cannot access memory at address 0x0

Thread 1 (LWP 8821):
#0  0xf7e66d1d in syscall () from /libx32/libc.so.6
#1  0x5659663d in __sys_io_uring_enter2 (fd=5, to_submit=0, min_complete=1, flags=1, sig=0x0, sz=8) at syscall.c:54
#2  0x56595dbe in _io_uring_get_cqe (ring=0xffc4feb0, cqe_ptr=0xffc4fe38, data=0xffc4fdb0) at queue.c:122
#3  0x56595e9b in __io_uring_get_cqe (ring=0xffc4feb0, cqe_ptr=0xffc4fe38, submit=0, wait_nr=1, sigmask=0x0) at queue.c:150
#4  0x565945d8 in io_uring_wait_cqe_nr (ring=0xffc4feb0, cqe_ptr=0xffc4fe38, wait_nr=1) at ../src/include/liburing.h:635
#5  0x56594634 in io_uring_wait_cqe (ring=0xffc4feb0, cqe_ptr=0xffc4fe38) at ../src/include/liburing.h:655
#6  0x56594dc5 in copy_file (ring=0xffc4feb0, _insize=24) at io_uring-cp.c:232
#7  0x56594ff1 in main (argc=3, argv=0xffc50024) at io_uring-cp.c:278
[Inferior 1 (process 8821) detached]

With -m32:

gdb -q --batch --ex="set height 0" --ex="thread apply all bt" --pid 8831
[New LWP 8832]
[New LWP 8833]
0xf7f16549 in __kernel_vsyscall ()

Thread 3 (LWP 8833):
#0  0x00000000 in ?? ()

Thread 2 (LWP 8832):
#0  0x00000000 in ?? ()

Thread 1 (LWP 8831):
#0  0xf7f16549 in __kernel_vsyscall ()
#1  0xf7e14efb in syscall () at ../sysdeps/unix/sysv/linux/i386/syscall.S:29
#2  0x5657d297 in __sys_io_uring_enter2 (fd=5, to_submit=0, min_complete=1, flags=1, sig=0x0, sz=8) at syscall.c:54
#3  0x5657cb32 in _io_uring_get_cqe (ring=0xff9557b0, cqe_ptr=0xff95573c, data=0xff955698) at queue.c:122
#4  0x5657cbf5 in __io_uring_get_cqe (ring=0xff9557b0, cqe_ptr=0xff95573c, submit=0, wait_nr=1, sigmask=0x0) at queue.c:150
#5  0x5657b5f2 in io_uring_wait_cqe_nr (ring=0xff9557b0, cqe_ptr=0xff95573c, wait_nr=1) at ../src/include/liburing.h:635
#6  0x5657b63f in io_uring_wait_cqe (ring=0xff9557b0, cqe_ptr=0xff95573c) at ../src/include/liburing.h:655
#7  0x5657bcbe in copy_file (ring=0xff9557b0, _insize=24) at io_uring-cp.c:232
#8  0x5657becd in main (argc=3, argv=0xff9558f4) at io_uring-cp.c:278
[Inferior 1 (process 8831) detached]

So the gdb autodetects 'i386/-m32' and warns in all other cases (including the default of -m64)

As a debugged this deeply now, I know (at least printing a backtrace works anyway),
but for any random advanced admin or userspace developer warnings like this:

  warning: Selected architecture i386:x86-64 is not compatible with reported target architecture i386

  warning: Architecture rejected target-supplied description

typically indicate that something in the system is deeply broken.

With the version proposed by Linus:

+		childregs->cs = __USER_CS;
+		childregs->ss = __USER_DS;
+#ifdef CONFIG_X86_32
+		childregs->ds = __USER_DS;
+		childregs->es = __USER_DS;
+#endif

-m64 and -mx32 are fine, but i386/-m32 generates this:

# gdb -q --batch --ex="set height 0" --ex="thread apply all bt" --pid 984
[New LWP 985]
[New LWP 986]
[New LWP 987]

warning: Selected architecture i386 is not compatible with reported target architecture i386:x64-32

warning: Architecture rejected target-supplied description
0xf7f58549 in __kernel_vsyscall ()

Thread 4 (LWP 987):
#0  0x00000000 in ?? ()

Thread 3 (LWP 986):
#0  0x00000000 in ?? ()

Thread 2 (LWP 985):
#0  0x00000000 in ?? ()

Thread 1 (LWP 984):
#0  0xf7f58549 in __kernel_vsyscall ()
#1  0xf7e56efb in syscall () at ../sysdeps/unix/sysv/linux/i386/syscall.S:29
#2  0x5656c297 in __sys_io_uring_enter2 (fd=5, to_submit=0, min_complete=1, flags=1, sig=0x0, sz=8) at syscall.c:54
#3  0x5656bb32 in _io_uring_get_cqe (ring=0xffc42ce0, cqe_ptr=0xffc42c6c, data=0xffc42bc8) at queue.c:122
#4  0x5656bbf5 in __io_uring_get_cqe (ring=0xffc42ce0, cqe_ptr=0xffc42c6c, submit=0, wait_nr=1, sigmask=0x0) at queue.c:150
#5  0x5656a5f2 in io_uring_wait_cqe_nr (ring=0xffc42ce0, cqe_ptr=0xffc42c6c, wait_nr=1) at ../src/include/liburing.h:635
#6  0x5656a63f in io_uring_wait_cqe (ring=0xffc42ce0, cqe_ptr=0xffc42c6c) at ../src/include/liburing.h:655
#7  0x5656acbe in copy_file (ring=0xffc42ce0, _insize=24) at io_uring-cp.c:232
#8  0x5656aecd in main (argc=3, argv=0xffc42e24) at io_uring-cp.c:278
[Inferior 1 (process 984) detached]


With my patch all 3 are fine.

It also feels more natural to me to just keep the values of
the copy_thread() caller.

Do you plan to do something about this before 5.12 final?

metze

Am 11.04.21 um 17:27 schrieb Stefan Metzmacher:
> This allows gdb attach to userspace processes using io-uring,
> which means that they have io_threads (PF_IO_WORKER), which appear
> just like normal as userspace threads.
> 
> See the code comment for more details.
> 
> Fixes: 4727dc20e04 ("arch: setup PF_IO_WORKER threads like PF_KTHREAD")
> Signed-off-by: Stefan Metzmacher <metze@samba.org>
> cc: Linus Torvalds <torvalds@linux-foundation.org>
> cc: Jens Axboe <axboe@kernel.dk>
> cc: linux-kernel@vger.kernel.org
> cc: io-uring@vger.kernel.org
> ---
>  arch/x86/kernel/process.c | 49 +++++++++++++++++++++++++++++++++++++++
>  1 file changed, 49 insertions(+)
> 
> diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
> index 9c214d7085a4..72120c4b7618 100644
> --- a/arch/x86/kernel/process.c
> +++ b/arch/x86/kernel/process.c
> @@ -163,6 +163,55 @@ int copy_thread(unsigned long clone_flags, unsigned long sp, unsigned long arg,
>  	/* Kernel thread ? */
>  	if (unlikely(p->flags & (PF_KTHREAD | PF_IO_WORKER))) {
>  		memset(childregs, 0, sizeof(struct pt_regs));
> +		/*
> +		 * gdb sees all userspace threads,
> +		 * including io threads (PF_IO_WORKER)!
> +		 *
> +		 * gdb uses:
> +		 * PTRACE_PEEKUSR, offsetof (struct user_regs_struct, cs)
> +		 *  returning with 0x33 (51) to detect 64 bit
> +		 * and:
> +		 * PTRACE_PEEKUSR, offsetof (struct user_regs_struct, ds)
> +		 *  returning 0x2b (43) to detect 32 bit.
> +		 *
> +		 * GDB relies on that the kernel returns the
> +		 * same values for all threads, which means
> +		 * we don't zero these out.
> +		 *
> +		 * Note that CONFIG_X86_64 handles 'es' and 'ds'
> +		 * differently, see the following above:
> +		 *   savesegment(es, p->thread.es);
> +		 *   savesegment(ds, p->thread.ds);
> +		 * and the CONFIG_X86_64 version of get_segment_reg().
> +		 *
> +		 * Linus proposed something like this:
> +		 * (https://lore.kernel.org/io-uring/CAHk-=whEObPkZBe4766DmR46-=5QTUiatWbSOaD468eTgYc1tg@mail.gmail.com/)
> +		 *
> +		 *   childregs->cs = __USER_CS;
> +		 *   childregs->ss = __USER_DS;
> +		 *   childregs->ds = __USER_DS;
> +		 *   childregs->es = __USER_DS;
> +		 *
> +		 * might make sense (just do it unconditionally, rather than making it
> +		 * special to PF_IO_WORKER).
> +		 *
> +		 * But that doesn't make gdb happy in all cases.
> +		 *
> +		 * While 32bit userspace on a 64bit kernel is legacy,
> +		 * it's still useful to allow 32bit libraries or nss modules
> +		 * use the same code as the 64bit version of that library, which
> +		 * can use io-uring just fine.
> +		 *
> +		 * So we better just inherit the values from
> +		 * the originating process instead of hardcoding
> +		 * values, which would imply 64bit userspace.
> +		 */
> +		childregs->cs = current_pt_regs()->cs;
> +		childregs->ss = current_pt_regs()->ss;
> +#ifdef CONFIG_X86_32
> +		childregs->ds = current_pt_regs()->ds;
> +		childregs->es = current_pt_regs()->es;
> +#endif
>  		kthread_frame_init(frame, sp, arg);
>  		return 0;
>  	}
> 

