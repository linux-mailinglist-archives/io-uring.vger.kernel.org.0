Return-Path: <io-uring+bounces-13145-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SLGnEwLf7ml7ywAAu9opvQ
	(envelope-from <io-uring+bounces-13145-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 27 Apr 2026 05:58:58 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id B4DA046CB64
	for <lists+io-uring@lfdr.de>; Mon, 27 Apr 2026 05:58:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id C62B5307205F
	for <lists+io-uring@lfdr.de>; Mon, 27 Apr 2026 03:53:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 657163921ED;
	Mon, 27 Apr 2026 03:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RX0ITJdY"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 415DA2E11D2;
	Mon, 27 Apr 2026 03:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777261915; cv=none; b=gWuxN5a6JVwRLERBe7ylzbC+baeYpx64cUXWyIrzLxljFVnrrIb4IyLO3sqyi1JwaZl1tA5TVC1b6JeCiaOeqkwMAtSCYwWq3KWYVTLjdhf60+ON08azVUsQ2Ibv/VaPkgO4Yfb/30Strm0Ff4hNij/VU3xSsT4896KCbmX+Auo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777261915; c=relaxed/simple;
	bh=M8Y2bVaRN3BHzbG9WhM57RI4hQEP/BIAN+z/3IRxhVU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tAiV0FOLOZ95OQ9qLvNlnLDg/D9qnT4jokVZKHAF/yK4FgsqgUffR9x9GK58UYVUtk5kPetbHSYP/IfSAr9ry9ABZdK5++pq+ckbVG9IXk+tyLrLQo8X0WmfrPb2HK/0R5NPbpUmFofwkvzcCJYA6bTGOWzhMN7S9e6PYBqPhg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RX0ITJdY; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F12FC2BCB5;
	Mon, 27 Apr 2026 03:51:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777261915;
	bh=M8Y2bVaRN3BHzbG9WhM57RI4hQEP/BIAN+z/3IRxhVU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RX0ITJdYgQxbVhaqqEQsYEYuFbUgyWEFB2u9vGigzKDnGx90P+G2+knsGhuUl9jYB
	 rAvT/+E740GIrT/IRMxPF6161NlxS03m0P7K9UcsxqpfxcpFjWi+2XmTKyQJqnnEaD
	 kFEwW5b45rj+u4QeRXilM3iOA59dlcRnehewHOrs=
Date: Sun, 26 Apr 2026 23:30:22 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sidong Yang <sidong.yang@furiosa.ai>
Cc: Jens Axboe <axboe@kernel.dk>,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Caleb Sander Mateos <csander@purestorage.com>,
	Benno Lossin <lossin@kernel.org>, Miguel Ojeda <ojeda@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>, rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [PATCH v5 0/4] Rust io_uring command abstraction for miscdevice
Message-ID: <2026042602-harness-chest-bfcf@gregkh>
References: <20260415090851.4897-1-sidong.yang@furiosa.ai>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260415090851.4897-1-sidong.yang@furiosa.ai>
X-Rspamd-Queue-Id: B4DA046CB64
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
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
	TAGGED_FROM(0.00)[bounces-13145-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[linuxfoundation.org:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[gregkh@linuxfoundation.org,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[10];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linuxfoundation.org:dkim,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]

On Wed, Apr 15, 2026 at 09:02:11AM +0000, Sidong Yang wrote:
> This series introduces Rust abstractions for io_uring commands
> (`IORING_OP_URING_CMD`) and wires them up to the miscdevice framework,
> allowing Rust drivers to handle io_uring passthrough commands.
> 
> The series is structured as follows:
> 
> 1. Add io_uring C headers to Rust bindings.
> 2. Core io_uring Rust abstractions (IoUringCmd, QueuedIoUringCmd,
>    IoUringSqe, UringCmdAction type-state pattern, IoUringTaskWork trait).
> 3. MiscDevice trait extension with uring_cmd callback.
> 4. Sample demonstrating async uring_cmd handling via workqueue.

Again, I can't take this until we have a "real" user.  Please wait to
submit it at that point in time.

thanks,

greg k-h

