Return-Path: <io-uring+bounces-12391-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CK1jKPDrnGnqMAQAu9opvQ
	(envelope-from <io-uring+bounces-12391-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 24 Feb 2026 01:08:16 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 06916180223
	for <lists+io-uring@lfdr.de>; Tue, 24 Feb 2026 01:08:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B26EA30479E0
	for <lists+io-uring@lfdr.de>; Tue, 24 Feb 2026 00:08:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B5BC288B8;
	Tue, 24 Feb 2026 00:08:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CE81yvUx"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28F61171CD;
	Tue, 24 Feb 2026 00:08:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771891694; cv=none; b=XTf94Xk3+/tb8kjK2iIhraJ/NWUM+ixF8Z9/Us+Rs3Gvjl0JfIvX0XNmgcbzmtaX4t8Z3LhNUoxmD8ZHkYHhnoJdMTYa62Qj1lZq+OjSb02KUo5GJf8+vcBQcOFhjCXxCs1LyvFOxZIloPJA7Sw8UXAzgXydWOaB1k42taVLWJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771891694; c=relaxed/simple;
	bh=RrKFNu8wljY6BzmgmvHsn7OGcp6Np7qFZUML1yypRaU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V1TGPI+LrHv/9LS44FpjlsA3YcfoUPkOWoX7K7vQGX6xHj8GJENCVNBA7h2YJKxZyM4LbssAgkHQxPpqDGbV/9C7W6iUeLKdPhvxvnLd9WuZUTDskaHdqQHPgc6rMOF6sZiOWtqQ/UzV6t1FyC/gyh0p5WgQ41EUCOyeY+MRzGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CE81yvUx; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF508C116C6;
	Tue, 24 Feb 2026 00:08:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771891693;
	bh=RrKFNu8wljY6BzmgmvHsn7OGcp6Np7qFZUML1yypRaU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CE81yvUx2kaTj8blr5TMB32FXqc2VQydLwr1XchIw7GgDyAFlw8u7SOtY03Vp5YXE
	 JvuBI/pDIHjQms805qkY/C3vH7sJXKdm6UrVqZvZfF6jwj/DeKfLotg1cu/LyXw3e6
	 nIxa7sWgA3Wwyk52epFVlxSdJfj6BH976+nnq+Q1WVxXNe796Xk0nTwvxBugWx/+YV
	 FP/1isXqJtPnJIMIAgDgPaQBgpopEKzFGVlRcI09lflMqZN0QR6hUdi7I1a5cXqRMA
	 dYVc5ZHBrurrU9j65AQth2/+xqcfrCofkGNfvFbI9WR7p1h8jhtVUb4KTp/UojLWyV
	 jiCVDqfCpZYNw==
Date: Mon, 23 Feb 2026 16:08:13 -0800
From: Kees Cook <kees@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: syzbot <syzbot+0a4c46806941297fecb9@syzkaller.appspotmail.com>,
	io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
	luto@amacapital.net, syzkaller-bugs@googlegroups.com,
	wad@chromium.org
Subject: Re: [syzbot] [io-uring?] WARNING in __secure_computing
Message-ID: <202602231607.2B1D3BF@keescook>
References: <69953966.a70a0220.2c38d7.0111.GAE@google.com>
 <c71fc714-25b2-4c56-b48a-6d9da1d40d60@kernel.dk>
 <202602191048.395EE1E@keescook>
 <7d955b00-8cbf-4b09-9733-2c0d65e84e6e@kernel.dk>
 <e5b8042c-09b6-4d9a-bab9-c9693fbffa52@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e5b8042c-09b6-4d9a-bab9-c9693fbffa52@kernel.dk>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12391-lists,io-uring=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,syzkaller.appspot.com:url];
	RCVD_COUNT_THREE(0.00)[4];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kees@kernel.org,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring,0a4c46806941297fecb9];
	RCPT_COUNT_SEVEN(0.00)[7];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	SUBJECT_HAS_QUESTION(0.00)[]
X-Rspamd-Queue-Id: 06916180223
X-Rspamd-Action: no action

On Mon, Feb 23, 2026 at 12:15:17PM -0700, Jens Axboe wrote:
> On 2/20/26 6:44 AM, Jens Axboe wrote:
> > On 2/19/26 11:53 AM, Kees Cook wrote:
> >> On Wed, Feb 18, 2026 at 09:27:07AM -0700, Jens Axboe wrote:
> >>> On 2/17/26 9:00 PM, syzbot wrote:
> >>>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13256722580000
> >>>> [...]
> >>>> WARNING: kernel/seccomp.c:1407 at __secure_computing+0x2ae/0x2e0 kernel/seccomp.c:1407, CPU#1: syz.0.17/6077
> >>
> >> This is:
> >>
> >>         /* Surviving SECCOMP_RET_KILL_* must be proactively impossible. */
> >>         case SECCOMP_MODE_DEAD:
> >>                 WARN_ON_ONCE(1);
> >>                 do_exit(SIGKILL);
> >>                 return -1;
> >>
> >> It's nice to see we caught an impossible state! :) Now we just need to
> >> figure out what the repro is doing.
> >>
> >>> Not io_uring, no seccomp label that I can find...
> >>
> >> Why do you say this? The reproducer sets up io_uring and then calls
> >> seccomp:
> > 
> > Because I don't see any related interaction there at all. As per usual,
> > the syz repro ends up doing some odd SQ tweaking, which results in a
> > bunch of readv and NOPs being issued. The former against signalfd. I
> > don't see anything odd on the io_uring side outside of that. Well
> > there's the usual nonsensical fuzzing io_uring_enter flag setting, like
> > SQ_* which don't make sense for the ring setup, but these are just
> > ignored.
> > 
> > It is possible that because of the tons of readv being queued that some
> > io-wq activity will be occuring, and that could slow down certain paths
> > like the signal handling. But seem orthogonal to me, as you could most
> > likely accomplish the same with userside threads too.
> > 
> > I could be wrong of course! Note that I'm gone until next week, so not
> > going to spend any time looking at this before then. Please do dive in
> > if you have time, though...
> > 
> >> int main(void)
> >> {
> >> ...
> >>   //  io_uring_enter arguments: [
> >>   //    fd: fd_io_uring (resource)
> >>   //    to_submit: int32 = 0x847ba (4 bytes)
> >>   //    min_complete: int32 = 0x0 (4 bytes)
> >>   //    flags: io_uring_enter_flags = 0xe (8 bytes)
> >>   //    sigmask: nil
> >>   //    size: len = 0x0 (8 bytes)
> >>   //  ]
> >>   syscall(
> >>       __NR_io_uring_enter, /*fd=*/r[1], /*to_submit=*/0x847ba,
> >>       /*min_complete=*/0,
> >>       /*flags=IORING_ENTER_EXT_ARG|IORING_ENTER_SQ_WAIT|IORING_ENTER_SQ_WAKEUP*/
> >>       0xeul, /*sigmask=*/0ul, /*size=*/0ul);
> >>   //  seccomp$SECCOMP_SET_MODE_FILTER_LISTENER arguments: [
> >>   //    op: const = 0x1 (8 bytes)
> >>   //    flags: seccomp_flags_listener = 0x0 (8 bytes)
> >>   //    arg: ptr[in, sock_fprog] {
> >>   //      sock_fprog {
> >>   //        len: len = 0x1 (2 bytes)
> >>   //        pad = 0x0 (6 bytes)
> >>   //        filter: ptr[in, array[sock_filter]] {
> >>   //          array[sock_filter] {
> >>   //            sock_filter {
> >>   //              code: int16 = 0x6 (2 bytes)
> >>   //              jt: int8 = 0xff (1 bytes)
> >>   //              jf: int8 = 0x1 (1 bytes)
> >>   //              k: int32 = 0x3fff0000 (4 bytes)
> >>   //            }
> >>   //          }
> >>   //        }
> >>   //      }
> >>   //    }
> >>   //  ]
> >>   //  returns fd_seccomp
> >>   NONFAILING(*(uint16_t*)0x200000000240 = 1);
> >>   NONFAILING(*(uint64_t*)0x200000000248 = 0x2000000003c0);
> >>   NONFAILING(*(uint16_t*)0x2000000003c0 = 6);
> >>   NONFAILING(*(uint8_t*)0x2000000003c2 = -1);
> >>   NONFAILING(*(uint8_t*)0x2000000003c3 = 1);
> >>   NONFAILING(*(uint32_t*)0x2000000003c4 = 0x3fff0000);
> >>   syscall(__NR_seccomp, /*op=*/1ul, /*flags=*/0ul, /*arg=*/0x200000000240ul);
> >>   return 0;
> >> }
> >>
> >> So something has gone weird here, I assume related to seccomp listener
> >> vs io_uring and process death.
> > 
> > See above on potentially lots of threads being kicked off. But probably
> > reproducing this first would be a good step towards fixing it.
> 
> No threads are being kicked off - from strace, this seems to be the key:
> 
> seccomp(SECCOMP_SET_MODE_FILTER, 0, {len=1, filter=0x2000000003c0}) = 0
> exit_group(0)                           = 231
> --- SIGSEGV {si_signo=SIGSEGV, si_code=SI_KERNEL, si_addr=NULL} ---
> exit_group(11)    
> 
> as that WARN_ON_ONCE() in the report is indeed triggered off the
> 2nd exit_group() syscall.

Thank you for tracking this down! I've been busy with fixing my rc1
kmalloc_obj breakages and didn't have time to look at this more.

-- 
Kees Cook

