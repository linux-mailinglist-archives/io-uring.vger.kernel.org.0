Return-Path: <io-uring+bounces-13881-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id fKUPA2Y8SWoQzgAAu9opvQ
	(envelope-from <io-uring+bounces-13881-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 04 Jul 2026 19:01:26 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 9ABE2708063
	for <lists+io-uring@lfdr.de>; Sat, 04 Jul 2026 19:01:25 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=USwQqrc0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13881-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.232.135.74 as permitted sender) smtp.mailfrom="io-uring+bounces-13881-lists+io-uring=lfdr.de@vger.kernel.org";
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id EC0C230071C9
	for <lists+io-uring@lfdr.de>; Sat,  4 Jul 2026 17:01:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96F36279DC9;
	Sat,  4 Jul 2026 17:01:21 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ED1D25B09A;
	Sat,  4 Jul 2026 17:01:20 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783184481; cv=none; b=GRy5jZIOJllUp68NiCAEptCP9qoQExiM3nsdZwC3dSw2Fqj3jo9Iec0VLQK6kgNhY7HSQHYVybIKut4WEZhm6uuIYgaWtMM1cQ0YFgzul2OIZKuTshI9eKoaE5kLfWph4irZtrlJsdlfCKjyxddKg/tFr9kv82ZcsDw3MIwE5Ac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783184481; c=relaxed/simple;
	bh=U+uPYYtyKjOwDVtqFJheK7I//0Wze1thj/WXxYHLjLI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iKwEHFvo+gaW1m5gK7cgtGwzWNzMTlhsYGSWVcTsBm84jrZ+bIGSwqkopl60709MeSN0UigA2EN/8AVC3B6tk3naJvuXX7jD/kKfKU6etH0kKxBoaFeSmeUwm2lzAx1F/Hu1sPS4YxvLlojFfldiHBnuBAZVSbg9SGDXNigfQs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=USwQqrc0; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1E1A1F000E9;
	Sat,  4 Jul 2026 17:01:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783184480;
	bh=rMN02CbW0x4zESSpqcA4jAOm9MavLi9M+SczfZuVy40=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=USwQqrc07rG7KoJ2LBvQM6iXiNH1zYPyMz4Cw7azJYj41mWlKiQy7bV6E6g4pB40N
	 rJBmcBhn/k+CVhIgQWtltKdmdvVEQpc7uP3ETOt2BmlSUoYLXWQSn0enVx42eK07Zu
	 ZLwuZ/VPSLkQJ1n40li4x/Fx2Kue4kHtk1wq8DAF39fbg6d2Jk/zAEKeczYRCVLdgv
	 03M8SQ6rP3qHhmCKxppnoE3YvwzoHSMjZGn252BJq4DflA4BfmI7ezK/bXEZQG5kGe
	 U0TsH0ZzTc4aCRYQXLak/rb+TqzkT0EqkPfRidfh6lEy6itRxxCcdMXAAiJt3qBjI+
	 cmrkYgOMbx/1A==
Date: Sat, 4 Jul 2026 11:01:18 -0600
From: Keith Busch <kbusch@kernel.org>
To: Ben Carey <benjamin.james.carey3@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [BUG] RCU hang with io_uring nvme polling
Message-ID: <akk8Xhyntk9_weMp@kbusch-mbp>
References: <20260626150946.287781-1-benjamin.james.carey3@gmail.com>
 <85d1f999-7778-4c74-9d72-b8ac8500de31@kernel.dk>
 <aj6jQyJd3zmZFcwx@kbusch-mbp>
 <1932a509-4e27-485e-8e09-1da67e0082c8@kernel.dk>
 <aj6p3kZy1a8Mf68S@kbusch-mbp>
 <94614dd9-9351-4a64-83dc-4fc87e377e59@kernel.dk>
 <aj6tTiAB2NIol9Tf@kbusch-mbp>
 <CA+KFGSoyCSRzgamm-38oyAtEsqd7wZZ8awL79P40x7a819EK4w@mail.gmail.com>
 <CA+KFGSoZXejMvA5WNBSy=TVxiEiJs1-bxHXkewk8HtCR5m8sEw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+KFGSoZXejMvA5WNBSy=TVxiEiJs1-bxHXkewk8HtCR5m8sEw@mail.gmail.com>
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-4.66 / 15.00];
	WHITELIST_SPF_DKIM(-3.00)[kernel.org:d:+,kernel.org:s:+];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20260515];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
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
	TAGGED_FROM(0.00)[bounces-13881-lists,io-uring=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,vger.kernel.org:from_smtp]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 9ABE2708063

On Fri, Jul 03, 2026 at 01:20:24PM -0400, Ben Carey wrote:
> While testing the patch we decided to trace the amount of time a workload
> spends in blk_hctx_poll. We found that, for a test case with 8 jobs running for
> 10 seconds, it spent ~71% of its runtime in that function alone. We ran this
> test with an Intel Optane mounted with NVMe over PCIe target but have observed
> similar behavior on a VM, measured by:
> 
> perf record -F 99 -a -g -- \
>   fio --bs=1K --direct=1 --iodepth=1 --runtime=10 --rw=randread --time_based \
>     --ioengine=io_uring --hipri=1 --fixedbufs=0 --registerfiles=0 \
>       --sqthread_poll=0 \
>     --numjobs=8 --name=job0 --output-format=json --clocksource=clock_gettime \
>     --filename=/dev/nvme0n1
> 
> Again, this was tested with nvme.poll_queues=1, but similar behavior occurs
> with higher poll_queues, and also on a VM.
> 
> This bug seems to pollute our experimental results, and thus stands as
> something needing to be fixed for us to continue our research. Do you all think
> there's a different solution than the timeout?

What exactly do you have in mind? Shouldn't you expect to spend most of
your CPU time in the polling loop? As long as you keep the queues busy,
there's something to poll, so blk_hctx_poll is exactly where you want to
see the software be in a perf report. Seeing a high poll CPU utilization
means the software is efficient compared to the hardware. If we spend
very little time in the polling loop, then either you have incredibly
quick hardware, and let's face it, Optane SSDs are EOL and a generation
behind on link speeds so that's not gonna get there anymore, or our
software dispatch stack has an inefficiency somewhere.

If you have many pollers competing against a very low utilized queue,
then I think you have an application level problem mismatched to the
feature.

If you want to spend less time in the poll loop, then set the hybrid
poll sleep time. It should result in less polling time, but it'll push
your average latency higher.

The only thing the jiffie timeout may show a problem is when you stop
dispatching, which should only affect the time to close the ring when it
lost the polling race with a peer on the last IO it is looking for, but
should not affect individual IO latency.

