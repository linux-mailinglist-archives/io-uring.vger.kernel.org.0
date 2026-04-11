Return-Path: <io-uring+bounces-13025-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kwEXGys+2mlmzQgAu9opvQ
	(envelope-from <io-uring+bounces-13025-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 11 Apr 2026 14:27:23 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id F25673DFE38
	for <lists+io-uring@lfdr.de>; Sat, 11 Apr 2026 14:27:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 5622C30234D3
	for <lists+io-uring@lfdr.de>; Sat, 11 Apr 2026 12:27:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E88722FD681;
	Sat, 11 Apr 2026 12:27:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vnVY9jNT"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFBB0262A6;
	Sat, 11 Apr 2026 12:27:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775910437; cv=none; b=BaH4TNolN7trL0gHrFstJlTnADKBSoxFYErpmH0dfO17+KstcneAcj03x2gYojU86M70/7zyXSMK7VT7ulRqVsvoHz4zOlgrVNVOA2OPw4cUb+MmFwEGnEYHJwm/gBh8/7HdCF9HlZX1xKRWUfyHLOhzW8h/zJHSG/t4fQZQU/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775910437; c=relaxed/simple;
	bh=VtzimNT5eQ7TCZNVz/BzNo0/XktyL5aukzfakARjEPk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ch26iR3rolKC1kOFgPZkAvtkErqVZOPEOy1qLLnsuACwHDIdCovjDx5xrQBdINnkQhEDANdDKVl5pgvWtR6CJkUH8QN3V91UOSVFSSCU6rzN3x3rnghgiHhZWkgWmZdk88RrQeAY/8Jb1kFd3FnavVOJeQac3HHa9n4w3rPQDMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vnVY9jNT; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C554AC4CEF7;
	Sat, 11 Apr 2026 12:27:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775910437;
	bh=VtzimNT5eQ7TCZNVz/BzNo0/XktyL5aukzfakARjEPk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=vnVY9jNTqE09VVPFS9DJx4b4QQ2dfQr4Nr64BEo4Qw+7ScMnKsmDML0Jr0r6uIW1y
	 2jft7Va9GhkZZbgMZgcnTkoFbZRJzqaG5TzaxJtR8B+U8wBdznZbQqAyHiMbL6Md88
	 cMnE4iu8/wfr1nP0g3eOideRQCoO8Q39fmpCtx2U=
Date: Sat, 11 Apr 2026 14:27:14 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sidong Yang <sidong.yang@furiosa.ai>
Cc: Jens Axboe <axboe@kernel.dk>,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Caleb Sander Mateos <csander@purestorage.com>,
	Benno Lossin <lossin@kernel.org>, Miguel Ojeda <ojeda@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>, rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [PATCH v4 0/5] Rust io_uring command abstraction for miscdevice
Message-ID: <2026041153-scope-five-fd24@gregkh>
References: <20260408140007.8401-1-sidong.yang@furiosa.ai>
 <2026040925-taunt-exit-0cb9@gregkh>
 <ado7p6jV6aapelBU@sidong>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ado7p6jV6aapelBU@sidong>
X-Spamd-Result: default: False [2.34 / 15.00];
	MID_END_EQ_FROM_USER_PART(4.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[linuxfoundation.org,none];
	R_DKIM_ALLOW(-0.20)[linuxfoundation.org:s=korg];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	TAGGED_FROM(0.00)[bounces-13025-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[linuxfoundation.org:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[gregkh@linuxfoundation.org,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[10];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,linuxfoundation.org:dkim]
X-Rspamd-Queue-Id: F25673DFE38
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Sat, Apr 11, 2026 at 12:16:39PM +0000, Sidong Yang wrote:
> On Thu, Apr 09, 2026 at 07:25:23AM +0200, Greg Kroah-Hartman wrote:
> > On Wed, Apr 08, 2026 at 01:59:57PM +0000, Sidong Yang wrote:
> > > This series introduces Rust abstractions for io_uring commands
> > > (`IORING_OP_URING_CMD`) and wires them up to the miscdevice framework,
> > > allowing Rust drivers to handle io_uring passthrough commands.
> > > 
> > > The series is structured as follows:
> > > 
> > > 1. Add io_uring C headers to Rust bindings.
> > > 2. Zero-init pdu in io_uring_cmd_prep() to avoid UB from stale data.
> > > 3. Core io_uring Rust abstractions (IoUringCmd, QueuedIoUringCmd,
> > >    IoUringSqe, UringCmdAction type-state pattern).
> > > 4. MiscDevice trait extension with uring_cmd callback.
> > > 5. Sample demonstrating async uring_cmd handling via workqueue.
> > > 
> > > The sample completes asynchronously using a workqueue rather than
> > > `io_uring_cmd_complete_in_task()`.  The latter is primarily needed
> > > when completion originates from IRQ/softirq context (e.g. NVMe),
> > > whereas workqueue workers already run in process context and can
> > > safely call `io_uring_cmd_done()` directly.  A Rust binding for
> > > `complete_in_task` can be added in a follow-up series.
> > > 
> > > Copy-based `read_pdu()`/`write_pdu()` are kept instead of returning
> > > `&T`/`&mut T` references because the PDU is a `[u8; 32]` byte array
> > > whose alignment may not satisfy `T`'s requirements.
> > 
> > Samples are great and all, but I would really like to see a real user of
> > this before adding any more miscdev apis to the kernel.  Can you submit
> > this as a series that also adds the driver that needs this at the same
> > time?
> 
> Hi Greg,
> 
> Thank you for the review.
> 
> We have an out-of-tree C driver at Furiosa AI for our AI inference
> accelerator that uses uring_cmd.  This is our primary motivation for
> these abstractions.
> 
> We are considering upstreaming the driver and porting parts of it to
> Rust using these abstractions.  If we were to upstream the driver,
> would it need to be based on the accel subsystem (DRM)?  Or would a
> standalone PCI driver approach also be acceptable?

Yes, it must use the accel subsystem as that is the correct api for it.

thanks,

greg k-h

