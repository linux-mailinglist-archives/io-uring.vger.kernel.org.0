Return-Path: <io-uring+bounces-13852-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id zCSuMuvrQmq/IQoAu9opvQ
	(envelope-from <io-uring+bounces-13852-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 30 Jun 2026 00:04:27 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 2899A6DEFAE
	for <lists+io-uring@lfdr.de>; Tue, 30 Jun 2026 00:04:27 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="LYyKjp5/";
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13852-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.105.105.114 as permitted sender) smtp.mailfrom="io-uring+bounces-13852-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 15736300DD51
	for <lists+io-uring@lfdr.de>; Mon, 29 Jun 2026 22:04:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6381287268;
	Mon, 29 Jun 2026 22:04:24 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6E7C17BA6;
	Mon, 29 Jun 2026 22:04:23 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782770664; cv=none; b=jYAr/ytw3oz5K0fhWzXwM3BLs8f6sSd8b1ut+Y2vUyg6QftCy50DFnOSBTIvffbUq61jX1rBlID3nFPyPU4k6D45SIcqsuNNnMwLFMfUEvNQa5u6inT7u07twtO3NX6MmSDj1cyAzNNqTdbOESWG9bUTeaYvLcJEiTTfgoYJhW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782770664; c=relaxed/simple;
	bh=RaDLV0XIVF9w8DS6dCV1vr5Iu593PPPC57+E/+TnWBQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P35gZsT3VDz/XWxteVx8/qW3rYo4a8lUNZuDulF4BaEXLfWUKoyEhOE3M3iYOiWrgkKTkvOdBuSgyS/wJ5p1EnueEDlbWSCaO/U0xNQXr2TfLGfaZDD95jE9SZxkAndwNxmOhwCKvyBCjVmeiq84e0kla1+3lmWcxxkLlWobsNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LYyKjp5/; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E7651F000E9;
	Mon, 29 Jun 2026 22:04:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782770663;
	bh=/9nL6QezwEKRsHZxvH7EKqbOqJ2VujfFoAEDiOrNAaY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LYyKjp5/ql8BzV+zHKM1DQribFcCkmKf7+CXBWaCK5qf3hkz+njaASZg0NYpIyzl5
	 iC5VjZuLz07q9AQ8bU4k5A0htF5T1ShO4PU8zXZciZpYH8WY0YxP0Elkiy6ywrIVFF
	 OqQhFSXwXuyViCopdB1h/CuzeyclVwnCCRxIoXXFFHvvJrB+ARMsLgNHjhPHVGXJ5l
	 elvlYxKoWyPI89OGSkM+RTS1Qjpfc+tOe/uV73upOgvOX0WT/+t7bhnFN/bsJc7Amv
	 4WOJPwplVfeI4I9Fmx/MqKfH5Dkt7boHmWVZHp8J0Wd0uw6bmDNlImQr+q4NkHZMBZ
	 AAkfbUNLBc9Jw==
Date: Mon, 29 Jun 2026 16:04:21 -0600
From: Keith Busch <kbusch@kernel.org>
To: Ben Carey <benjamin.james.carey3@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [BUG] RCU hang with io_uring nvme polling
Message-ID: <akLr5TCM5yOvIXeu@kbusch-mbp>
References: <20260626150946.287781-1-benjamin.james.carey3@gmail.com>
 <85d1f999-7778-4c74-9d72-b8ac8500de31@kernel.dk>
 <aj6jQyJd3zmZFcwx@kbusch-mbp>
 <1932a509-4e27-485e-8e09-1da67e0082c8@kernel.dk>
 <aj6p3kZy1a8Mf68S@kbusch-mbp>
 <CA+KFGSpgN7DChCfMK4itc39MB9ubxacbY3sWTByOkG58umvPkQ@mail.gmail.com>
 <akLmZDexipAtsex_@kbusch-mbp>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <akLmZDexipAtsex_@kbusch-mbp>
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-4.66 / 15.00];
	WHITELIST_SPF_DKIM(-3.00)[kernel.org:d:+,kernel.org:s:+];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20260515];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS(0.00)[m:benjamin.james.carey3@gmail.com,m:axboe@kernel.dk,m:io-uring@vger.kernel.org,m:linux-kernel@vger.kernel.org,m:benjaminjamescarey3@gmail.com,s:lists@lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	FORGED_SENDER(0.00)[kbusch@kernel.org,io-uring@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13852-lists,io-uring=lfdr.de];
	DKIM_TRACE(0.00)[kernel.org:+];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kbusch@kernel.org,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	TAGGED_RCPT(0.00)[io-uring];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,vger.kernel.org:from_smtp,kbusch-mbp:mid]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 2899A6DEFAE

On Mon, Jun 29, 2026 at 03:40:52PM -0600, Keith Busch wrote:
> On Mon, Jun 29, 2026 at 04:47:00PM -0400, Ben Carey wrote:
>
> > Putting
> > io_check_iopoll behind a spinlock seems to fix it, though I imagine a more
> > elegant fix is out there (reusing a different lock, not using expensive locks,
> > a smarter place to check for racing, etc.)
> 
> I can see why that resolves your observation, but I don't think we can
> do this. We're ultimately polling for a hardware event, and this layer
> is too high a level for serializing these things.

It's also worse than that; your proposal serializes within an
io_uring_ctx, so two completely different applications could have the
exact same problem you discovered.

I don't necessarily like the accepted solution as it is time bound on
jiffies for an idle device, which is an eternity for low-latency
storage, but what else can we do? It's too expensive to check for a
specific IO or idle on each polling iteration. I guess we're expecting a
hi-pri application is constantly feeding the queue such that this is a
non-issue.

