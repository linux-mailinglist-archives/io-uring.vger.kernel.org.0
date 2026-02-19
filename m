Return-Path: <io-uring+bounces-12343-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ENrvKmdcl2lexQIAu9opvQ
	(envelope-from <io-uring+bounces-12343-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 19 Feb 2026 19:54:31 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1EF20161CE3
	for <lists+io-uring@lfdr.de>; Thu, 19 Feb 2026 19:54:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 0C5703043D67
	for <lists+io-uring@lfdr.de>; Thu, 19 Feb 2026 18:53:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B0B52D24B7;
	Thu, 19 Feb 2026 18:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IQf/gr63"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 683602765D4;
	Thu, 19 Feb 2026 18:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771527238; cv=none; b=b8/M8IuI5+rVNFu9tr3VSy3qqiJCOSUOAv5PRrQrR6+2Gh7Rb1fO++U/JoVAe+KuoWVdG3dtCJVsEIB0D3emoSbQuizZXi3En3krvO9DbSnLBW7pWAer7uom8oTeBBVFV6sFZtsmwKtxyCLLdnCyxPHcQPgwfxNrvi4UrlQtCHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771527238; c=relaxed/simple;
	bh=q2p4YLQpc1deAky6X6orGiHXlQp6BVexlA8VrWYCULA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FQXtb9Smof5WV/1EWrL6vQ8hWZhW04G6SApHBL92/0gFKmhxreikZ4/4rr7zbRNeH+/FPHMEAbHtAU3TWspUiSE0dqrcR+ZWTsmbqNkhOR2jBjTOwj08+/PI5oqOU6zEdGQf84kR9Q5x9LT6dJ8mlQ/aVueiowjuDCnwBOVi0VU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IQf/gr63; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02B34C4CEF7;
	Thu, 19 Feb 2026 18:53:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771527238;
	bh=q2p4YLQpc1deAky6X6orGiHXlQp6BVexlA8VrWYCULA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IQf/gr63yVvsVA9eEOpTZPWuFd3kTK1QBtqfPalnFO4TB9GxfwihGEOqTqVP82GvK
	 tNnH4i/FC9Ispf/rPx0nf8pzip3JvOR6D+jTwkoR3qg7ABjseA+X04yLbwMu4w2ZPn
	 wxxKVGm9jDSicpyvgyoeyH2xCfzTR3j1LGjG09PojFvam+CqBcyHcnuJL+1tyoAeui
	 F+0rA8eh2IpNlLkFYz6tRb8umP3gF+bkwg33S5Y8264LtMQeyH9HPmaZ2S1dQ/FSOB
	 qr/LPuy0XCXTBcZprBnVqsewxisG+k9YB5uwRrWF+dFNRKjA64s4lqI7svshCrt2rm
	 Uu8D52VMnMG2w==
Date: Thu, 19 Feb 2026 10:53:57 -0800
From: Kees Cook <kees@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: syzbot <syzbot+0a4c46806941297fecb9@syzkaller.appspotmail.com>,
	io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
	luto@amacapital.net, syzkaller-bugs@googlegroups.com,
	wad@chromium.org
Subject: Re: [syzbot] [io-uring?] WARNING in __secure_computing
Message-ID: <202602191048.395EE1E@keescook>
References: <69953966.a70a0220.2c38d7.0111.GAE@google.com>
 <c71fc714-25b2-4c56-b48a-6d9da1d40d60@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c71fc714-25b2-4c56-b48a-6d9da1d40d60@kernel.dk>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12343-lists,io-uring=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,syzkaller.appspot.com:url];
	RCVD_COUNT_THREE(0.00)[4];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
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
X-Rspamd-Queue-Id: 1EF20161CE3
X-Rspamd-Action: no action

On Wed, Feb 18, 2026 at 09:27:07AM -0700, Jens Axboe wrote:
> On 2/17/26 9:00 PM, syzbot wrote:
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13256722580000
> > [...]
> > WARNING: kernel/seccomp.c:1407 at __secure_computing+0x2ae/0x2e0 kernel/seccomp.c:1407, CPU#1: syz.0.17/6077

This is:

        /* Surviving SECCOMP_RET_KILL_* must be proactively impossible. */
        case SECCOMP_MODE_DEAD:
                WARN_ON_ONCE(1);
                do_exit(SIGKILL);
                return -1;

It's nice to see we caught an impossible state! :) Now we just need to
figure out what the repro is doing.

> Not io_uring, no seccomp label that I can find...

Why do you say this? The reproducer sets up io_uring and then calls
seccomp:

int main(void)
{
...
  //  io_uring_enter arguments: [
  //    fd: fd_io_uring (resource)
  //    to_submit: int32 = 0x847ba (4 bytes)
  //    min_complete: int32 = 0x0 (4 bytes)
  //    flags: io_uring_enter_flags = 0xe (8 bytes)
  //    sigmask: nil
  //    size: len = 0x0 (8 bytes)
  //  ]
  syscall(
      __NR_io_uring_enter, /*fd=*/r[1], /*to_submit=*/0x847ba,
      /*min_complete=*/0,
      /*flags=IORING_ENTER_EXT_ARG|IORING_ENTER_SQ_WAIT|IORING_ENTER_SQ_WAKEUP*/
      0xeul, /*sigmask=*/0ul, /*size=*/0ul);
  //  seccomp$SECCOMP_SET_MODE_FILTER_LISTENER arguments: [
  //    op: const = 0x1 (8 bytes)
  //    flags: seccomp_flags_listener = 0x0 (8 bytes)
  //    arg: ptr[in, sock_fprog] {
  //      sock_fprog {
  //        len: len = 0x1 (2 bytes)
  //        pad = 0x0 (6 bytes)
  //        filter: ptr[in, array[sock_filter]] {
  //          array[sock_filter] {
  //            sock_filter {
  //              code: int16 = 0x6 (2 bytes)
  //              jt: int8 = 0xff (1 bytes)
  //              jf: int8 = 0x1 (1 bytes)
  //              k: int32 = 0x3fff0000 (4 bytes)
  //            }
  //          }
  //        }
  //      }
  //    }
  //  ]
  //  returns fd_seccomp
  NONFAILING(*(uint16_t*)0x200000000240 = 1);
  NONFAILING(*(uint64_t*)0x200000000248 = 0x2000000003c0);
  NONFAILING(*(uint16_t*)0x2000000003c0 = 6);
  NONFAILING(*(uint8_t*)0x2000000003c2 = -1);
  NONFAILING(*(uint8_t*)0x2000000003c3 = 1);
  NONFAILING(*(uint32_t*)0x2000000003c4 = 0x3fff0000);
  syscall(__NR_seccomp, /*op=*/1ul, /*flags=*/0ul, /*arg=*/0x200000000240ul);
  return 0;
}

So something has gone weird here, I assume related to seccomp listener
vs io_uring and process death.

-Kees

-- 
Kees Cook

