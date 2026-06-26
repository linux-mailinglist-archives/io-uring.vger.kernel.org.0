Return-Path: <io-uring+bounces-13844-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id yBWkCkujPmq9JQkAu9opvQ
	(envelope-from <io-uring+bounces-13844-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 26 Jun 2026 18:05:31 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8478C6CEC37
	for <lists+io-uring@lfdr.de>; Fri, 26 Jun 2026 18:05:30 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ikBDEUN0;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13844-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c04:e001:36c::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13844-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 892983014135
	for <lists+io-uring@lfdr.de>; Fri, 26 Jun 2026 16:05:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B231C37BE7D;
	Fri, 26 Jun 2026 16:05:26 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7BC33812EB;
	Fri, 26 Jun 2026 16:05:25 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782489926; cv=none; b=QP3KwFz8QzFrp3Qn5pEIjH9eCIPFKpd9RbhUsyvkeY8jKIbI2N2iUoF1jwZChOHEV20/ReElQDB1RJLkZ4Hef+MP26rWDpGIyEu0j/D+MAZyyphLudHVBXUQerz8CgcaSjiLhm5h4Q8Vix8rDPtkdiIdGRhlEYAzOp3NFJF6DU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782489926; c=relaxed/simple;
	bh=fzet0BfZ5liznQQD86D86jm9+I5k6NDc+MubaimMd6M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XrHH3JSOUQT84qWf9Ko7awuYrV9vkbMj9miKfgl4HPSosFKJ05TIsVxI8IZX/7KokmeJxDQvBVuxbGaXW6FgK8tG75YFLzorVbxPMYAbXTdnRjKC9kCezvP/3NrqPB4i2d9lPqD8lBqBL4b8y1QhV1MdyOwCwJ5d8uJKcFzmJ9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ikBDEUN0; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 528011F000E9;
	Fri, 26 Jun 2026 16:05:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782489925;
	bh=MQxhqWJDp3E2oy2FCt/1Pb6g2ywBUfWHcqVmGNlFYWQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ikBDEUN0N96urrn/HhcKcG93mc4rufDhJ/DYa3WB1aOI3fEVoRmlpV4o7RTb73Swv
	 pOCbe4OEinzl1bj/n/2NTQfB3k8RqIhUmWJ017+6ylpT7ErotNpis1YZjLJqouXay8
	 RipQnwIzPwwTO1mGzpvIK0WuO62J2RfLQ/sUjAVrTJXBmWbbnd0WpOZDvaVUJZjKGG
	 0X9xxZocsPEZzd04VvhAcmrX4BVsaVVblP3CsPRVAsVtTzJmz/udL8yQTUE14/xt+Y
	 wT4vNMpHgfT+fUBC2Ydtm61bZ4UXzL5NWiG4apcF2e0kZ1w3O7nKr/Fb/J2wOKZGCX
	 Ytt2aG14PPCCA==
Date: Fri, 26 Jun 2026 10:05:23 -0600
From: Keith Busch <kbusch@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Ben Carey <benjamin.james.carey3@gmail.com>, io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [BUG] RCU hang with io_uring nvme polling
Message-ID: <aj6jQyJd3zmZFcwx@kbusch-mbp>
References: <20260626150946.287781-1-benjamin.james.carey3@gmail.com>
 <85d1f999-7778-4c74-9d72-b8ac8500de31@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <85d1f999-7778-4c74-9d72-b8ac8500de31@kernel.dk>
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-4.66 / 15.00];
	WHITELIST_SPF_DKIM(-3.00)[kernel.org:d:+,kernel.org:s:+];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20260515];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13844-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER(0.00)[kbusch@kernel.org,io-uring@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS(0.00)[m:axboe@kernel.dk,m:benjamin.james.carey3@gmail.com,m:io-uring@vger.kernel.org,m:linux-kernel@vger.kernel.org,m:benjaminjamescarey3@gmail.com,s:lists@lfdr.de];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kbusch@kernel.org,io-uring@vger.kernel.org];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	TAGGED_RCPT(0.00)[io-uring];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,kbusch-mbp:mid]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 8478C6CEC37

On Fri, Jun 26, 2026 at 09:17:35AM -0600, Jens Axboe wrote:
> On 6/26/26 9:09 AM, Ben Carey wrote:
> > From a running QEMU image with the latest kernel:
> > 1. Attach GDB to the running instance.
> > 2. Enable io polling via sysfs (echo 1 > /sys/block/nvme0n1/queue/io_poll).
> 
> That's not how that works at all. You need to setup poll queues on the
> nvme driver side, using the nvme.poll_queues=XX kernel parameter, or if
> using nvme as a module, load the module with poll_queues=XX where XX is
> the number of poll queues. You're not doing any polled IO as-is, and the
> above should also have dumped a dmesg message about how that does
> absolutely nothing.
> 
> That said, it should still work, just not doing polled IO. I'll take a
> look sometime next week, OOO right now.

Yeah, the sysfs attribute does nothing, but Ben mentioned they had the
correct kernel command line:

  BOOT_IMAGE=/vmlinuz-7.1.0-g3996771b8f75 root=/dev/mapper/ubuntu--vg-ubuntu--lv \
    ro nvme.poll_queues=1 nokaslr

So they did enable polling, but the "echo" step is just confusing and
unnecessary.

I tried out the test, and there does appear to be a problem here, so I'm
looking into it.

