Return-Path: <io-uring+bounces-13009-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id Mep/KWk412nwLggAu9opvQ
	(envelope-from <io-uring+bounces-13009-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 09 Apr 2026 07:26:01 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B1F23C649E
	for <lists+io-uring@lfdr.de>; Thu, 09 Apr 2026 07:26:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 59B593006811
	for <lists+io-uring@lfdr.de>; Thu,  9 Apr 2026 05:25:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67EE02EA749;
	Thu,  9 Apr 2026 05:25:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tHvwpOMH"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 439732E6116;
	Thu,  9 Apr 2026 05:25:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775712353; cv=none; b=cUBVwhvAJr7ytJEKffv+ssPllvR++gfa40spidx5YU5Iic+EYlth6tUseNagO7H71v3ZUASegHjSwyrPXiQAUnJ1+4WAyiorySRk0IB29yA+uanhu440gIhRMfFWGY9//4wRpbhy+3bgzy5f5IMmF6sMx0WZ/wKTltIifDzr25A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775712353; c=relaxed/simple;
	bh=61jn/T6HMExD0N1OR8QEuhK/jJNdnZLEiElDMKxafwI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LV0JM3GPSSNaMXW1Qzo55wMpQkw4kojK9YcCnI/tzWen2tz1h5rt0o8xIlCrxnd5k7tR3v2fzEfd8ReK3bphs03rkD4Xe0apXBmC3Y4NxC6GR+SEA5GBJFefeub8UIjkLywPYO4cGExhMVrwz9oowggtlC0Lcbbf30NuIkQFskE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tHvwpOMH; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35A21C4CEF7;
	Thu,  9 Apr 2026 05:25:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775712352;
	bh=61jn/T6HMExD0N1OR8QEuhK/jJNdnZLEiElDMKxafwI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tHvwpOMHJU39pnS3CKS4GYTFcBQs5TwL9CDFbEpz7L+bk0yPt/GGhxcXjon2PJQtj
	 /L83kLAtsXNhlCmBx1rrnyWaXSpyZDHeumaTGFJR9pdEvnDf/5yej2B+RJID3GQP7u
	 zVrH2SlxYqAhCZfVVwCQ1+mBfzl2kOWtxLnT8/mg=
Date: Thu, 9 Apr 2026 07:25:23 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sidong Yang <sidong.yang@furiosa.ai>
Cc: Jens Axboe <axboe@kernel.dk>,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Caleb Sander Mateos <csander@purestorage.com>,
	Benno Lossin <lossin@kernel.org>, Miguel Ojeda <ojeda@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>, rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [PATCH v4 0/5] Rust io_uring command abstraction for miscdevice
Message-ID: <2026040925-taunt-exit-0cb9@gregkh>
References: <20260408140007.8401-1-sidong.yang@furiosa.ai>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260408140007.8401-1-sidong.yang@furiosa.ai>
X-Spamd-Result: default: False [2.34 / 15.00];
	MID_END_EQ_FROM_USER_PART(4.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[linuxfoundation.org,none];
	R_DKIM_ALLOW(-0.20)[linuxfoundation.org:s=korg];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	TAGGED_FROM(0.00)[bounces-13009-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[linuxfoundation.org:+];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[gregkh@linuxfoundation.org,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[10];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 9B1F23C649E
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Wed, Apr 08, 2026 at 01:59:57PM +0000, Sidong Yang wrote:
> This series introduces Rust abstractions for io_uring commands
> (`IORING_OP_URING_CMD`) and wires them up to the miscdevice framework,
> allowing Rust drivers to handle io_uring passthrough commands.
> 
> The series is structured as follows:
> 
> 1. Add io_uring C headers to Rust bindings.
> 2. Zero-init pdu in io_uring_cmd_prep() to avoid UB from stale data.
> 3. Core io_uring Rust abstractions (IoUringCmd, QueuedIoUringCmd,
>    IoUringSqe, UringCmdAction type-state pattern).
> 4. MiscDevice trait extension with uring_cmd callback.
> 5. Sample demonstrating async uring_cmd handling via workqueue.
> 
> The sample completes asynchronously using a workqueue rather than
> `io_uring_cmd_complete_in_task()`.  The latter is primarily needed
> when completion originates from IRQ/softirq context (e.g. NVMe),
> whereas workqueue workers already run in process context and can
> safely call `io_uring_cmd_done()` directly.  A Rust binding for
> `complete_in_task` can be added in a follow-up series.
> 
> Copy-based `read_pdu()`/`write_pdu()` are kept instead of returning
> `&T`/`&mut T` references because the PDU is a `[u8; 32]` byte array
> whose alignment may not satisfy `T`'s requirements.

Samples are great and all, but I would really like to see a real user of
this before adding any more miscdev apis to the kernel.  Can you submit
this as a series that also adds the driver that needs this at the same
time?

thanks,

greg k-h

