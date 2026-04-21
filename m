Return-Path: <io-uring+bounces-13092-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qHikJjSm52kI+wEAu9opvQ
	(envelope-from <io-uring+bounces-13092-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 21 Apr 2026 18:30:44 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id F19BB43D5BA
	for <lists+io-uring@lfdr.de>; Tue, 21 Apr 2026 18:30:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A6A71300574C
	for <lists+io-uring@lfdr.de>; Tue, 21 Apr 2026 16:24:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 387C2363C4C;
	Tue, 21 Apr 2026 16:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QKmmX59a"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15E44363C40
	for <io-uring@vger.kernel.org>; Tue, 21 Apr 2026 16:24:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776788697; cv=none; b=gCIgxRKTQFoj7WkZ8vjMUbMQtdRszrZFKbqEBWdgb2KjSf4gzDGQpMvfqbb4sEMTwWQ83PhhW0XI2NFk3sMpnYVJixaJIYYWzHTGfi+WjgjULnghlh1KuR6T6yRgRSbRtjvqUSaUEHqorYHbH2J5OwLUt6qHkakwyXulkLFYjiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776788697; c=relaxed/simple;
	bh=z2y1VwfkWhq6BAusU15iNo8aRYVNST+SGFnT5aHunTI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ys636g/94c88yKVrzViXvyx6f4xMPppBV5YT3xBHk675t3BmHXCSnV1stCLj/Z/dxpjT6iA+zGS3hhqwYIJTeuOa3q95Dr8cArXQxAB3FwFXO9cCwwkBDVNzc/zyI5K197q+y0YtWs2X/xRlXus91p/e8cCYbzUquKVGivbJBJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QKmmX59a; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65D8EC2BCB0;
	Tue, 21 Apr 2026 16:24:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776788696;
	bh=z2y1VwfkWhq6BAusU15iNo8aRYVNST+SGFnT5aHunTI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QKmmX59a1HtyLP9jTg/m0/r9lzIaspWZdthkvLN+w4h3sNGTQEwXVXr3VwWYsz5yp
	 v07CCMx/MRWVHvyk+yTajRmUw7sYw5DF2qgnKx9sSdVixmsmB4e7JUcx1j+KrUqyXo
	 TtpinpvH0wng3Nkmn4yUJUpjgTuG4VhekgpUIqlM=
Date: Tue, 21 Apr 2026 18:24:54 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org
Subject: Re: [PATCH] io_uring: take page references for NOMMU pbuf_ring mmaps
Message-ID: <2026042125-disabled-conjure-67e4@gregkh>
References: <2026042115-body-attention-d15b@gregkh>
 <842a9dff-b12c-4cec-bc8d-8c1adb3ba280@kernel.dk>
 <2026042108-fiscally-unglazed-56c7@gregkh>
 <2026042140-arrogance-freehand-d8bd@gregkh>
 <c5077dde-0dfe-48d0-9504-76c7ff30b0e8@kernel.dk>
 <aed22e56-a39b-4c4b-a413-b5b1cd64deb4@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="Ul9QsasNEQXa0+rz"
Content-Disposition: inline
In-Reply-To: <aed22e56-a39b-4c4b-a413-b5b1cd64deb4@kernel.dk>
X-Spamd-Result: default: False [2.34 / 15.00];
	MID_END_EQ_FROM_USER_PART(4.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[linuxfoundation.org,none];
	MID_RHS_NOT_FQDN(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[linuxfoundation.org:s=korg];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[multipart/mixed,text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13092-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	MIME_TRACE(0.00)[0:+,1:+,2:+,3:+,4:+];
	DKIM_TRACE(0.00)[linuxfoundation.org:+];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[gregkh@linuxfoundation.org,io-uring@vger.kernel.org];
	HAS_ATTACHMENT(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linuxfoundation.org:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,vmlinux.lds:url]
X-Rspamd-Queue-Id: F19BB43D5BA
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr


--Ul9QsasNEQXa0+rz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 21, 2026 at 10:21:04AM -0600, Jens Axboe wrote:
> On 4/21/26 10:05 AM, Jens Axboe wrote:
> > On 4/21/26 10:01 AM, Greg Kroah-Hartman wrote:
> >> On Tue, Apr 21, 2026 at 03:55:38PM +0200, Greg Kroah-Hartman wrote:
> >>> On Tue, Apr 21, 2026 at 07:50:32AM -0600, Jens Axboe wrote:
> >>>> On 4/21/26 7:46 AM, Greg Kroah-Hartman wrote:
> >>>>> Note, I have no way of testing this, I'm only forwarding this on because
> >>>>> I got the bug report and was able to generate something that "seems"
> >>>>
> >>>> AI bug report I presume? Because I can't imagine anyone ever attempted
> >>>> to run this.
> >>>
> >>> Yes, I got a bunch of "non-mmu" bug reports, which is a bit odd but I
> >>> guess you can do that with qemu these days?  I should dig into that,
> >>> maybe that way I can test this and get a reproducer for you.  If not,
> >>> let's just bin the thing.
> >>>
> >>>>> correct, but it might be a total load of crap here, my knowledge of the
> >>>>> vm layer is very low so take this for where it is coming from (i.e. a
> >>>>> non-deterministic pattern matching system.)
> >>>>>
> >>>>> I do have another patch that just disables io_uring for !MMU systems, if
> >>>>> you want that instead?  Or is this feature something that !MMU devices
> >>>>> actually care about?
> >>>>
> >>>> I mean, who really cares about !MMU in the first place, we should just
> >>>> kill that off with a passion.
> >>>>
> >>>> Let me take a closer look at this and bounce it past some vm people, my
> >>>> nommu knowledge is close to zero as it's never been relevant in my
> >>>> professional life time. Which is saying something...
> >>>
> >>> Let me try to get a reproducer going first, let's not waste any more
> >>> human time on this just yet, sorry for sending this out without that
> >>> done first...
> >>
> >> Ok, attached is a poc.c and a script to run it.  If you run this on a
> >> 7.0 kernel today, it "should" crash. and then if you apply the patch it
> >> doesn't (or at least that's what happened in my testing.)
> >>
> >> Note, I have run this locally, and it seems to work, but be careful, I
> >> can't guarantee anything, it does seem quite odd in that it "crashes"
> >> the kernel with a sysrq call to show "proof".  Although that is a cool
> >> trick, I need to remember that...
> > 
> > I'll try and run a nommu qemu and see what pops out on my end. What a
> > waste of time for a nothing burger ;-)
> 
> What is fix-paddr.py? It's referenced in the build script.

Oops, this thing scattered crud all over the filesystem.  Here's what is
in the cross-wrap directory that it created.  If I forgot anything else,
let me know, sorry about that.  I need to clean up my working directory
for this box (which is rightfully air-gapped) as it's accumulated a lot
of cruft...

greg k-h

--Ul9QsasNEQXa0+rz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=fix-paddr.py

#!/usr/bin/env python3
# Set p_paddr = p_vaddr in every program header so qemu -kernel loads
# the ELF at its link address.  riscv vmlinux.lds sets LMA=VMA-LOAD_OFFSET
# for the Image target; we want qemu to honour VMA instead.
import sys, struct

with open(sys.argv[1], 'r+b') as f:
    f.seek(0x20); phoff, = struct.unpack('<Q', f.read(8))
    f.seek(0x36); phentsize, phnum = struct.unpack('<HH', f.read(4))
    for i in range(phnum):
        base = phoff + i * phentsize
        f.seek(base + 16); vaddr = f.read(8)
        f.seek(base + 24); f.write(vaddr)

--Ul9QsasNEQXa0+rz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=objcopy

#!/bin/sh
# Host objcopy lacks the riscv backend.  Force the generic elf64-little
# reader so it can parse the input, then restore e_machine/e_flags in
# the output (which objcopy writes as EM_NONE) from the input file.
#
# Kernel objcopy invocations are: objcopy [FLAGS] INPUT OUTPUT
# (cmd_objcopy in scripts/Makefile.lib).  The last two args are always
# the in/out files.

in=""
out=""
for a; do
	case "$a" in
	-*) ;;
	*)  in=$out; out=$a ;;
	esac
done

/usr/bin/objcopy -I elf64-little "$@" || exit $?

# If output is ELF, restore e_machine (0x12, 2 bytes) and e_flags
# (0x30, 4 bytes) from the input so lld recognises it as riscv.
if [ -n "$in" ] && [ -f "$in" ] && [ -f "$out" ] && \
   [ "$(head -c4 "$out" 2>/dev/null)" = "$(printf '\177ELF')" ]; then
	dd if="$in" of="$out" bs=1 skip=18 seek=18 count=2 conv=notrunc 2>/dev/null
	dd if="$in" of="$out" bs=1 skip=48 seek=48 count=4 conv=notrunc 2>/dev/null
fi
exit 0

--Ul9QsasNEQXa0+rz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=objdump

#!/bin/sh
exec /usr/bin/objdump -b elf64-little -m riscv "$@" 2>/dev/null || /usr/bin/objdump "$@"

--Ul9QsasNEQXa0+rz--

