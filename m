Return-Path: <io-uring+bounces-12651-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KORMKZ3esmncQQAAu9opvQ
	(envelope-from <io-uring+bounces-12651-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 12 Mar 2026 16:41:17 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 53AAC274BD0
	for <lists+io-uring@lfdr.de>; Thu, 12 Mar 2026 16:41:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D9F7E30480B9
	for <lists+io-uring@lfdr.de>; Thu, 12 Mar 2026 15:38:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 453DF3D8130;
	Thu, 12 Mar 2026 15:38:15 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25D153D8102;
	Thu, 12 Mar 2026 15:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773329894; cv=none; b=BYnGQRMMksmlQYZWYmcoeAHKhuP5Y9AdfepbZgN51zgDu4YyfNFI4vPUhcesSmI2eTBLmk9cOuVqaFZGdEpUS79jCl2L+t4+Ur77EUjDDb9JArCsJfUhIGDg/kYM0vrmdRho2+IWe+AwYjMmb3cfqNRZCI8HSLDvG1ep5ndYOus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773329894; c=relaxed/simple;
	bh=PR/f1n7uG57qlvm/xk14YeoZjXYQZnOzLHH28xdutTE=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nvPjpdWiq9hR4DbyOl+puGRyz2ubcaLc013pYHeqLVxhwjJ31O3PNjpyZI9Hdec8BHm5DpAoaYtGy4NyzIJnEllgKFPz6OHtJ4xiehBSyuUIZZXITvzpKLraK3kEJrJYg/R2CDcezh9fmrE0OW1wCf3GpKxIYO+no9mDikWv1Xc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A62055820E;
	Thu, 12 Mar 2026 15:38:04 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf08.hostedemail.com (Postfix) with ESMTPA id B18AD2002C;
	Thu, 12 Mar 2026 15:38:02 +0000 (UTC)
Date: Thu, 12 Mar 2026 11:38:16 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Keith Busch <kbusch@kernel.org>
Cc: "Vineeth Pillai (Google)" <vineeth@bitbyteword.org>, Peter Zijlstra
 <peterz@infradead.org>, Jens Axboe <axboe@kernel.dk>,
 io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH 03/15] io_uring: Use trace_invoke_##name() at guarded
 tracepoint call sites
Message-ID: <20260312113816.01de2b53@gandalf.local.home>
In-Reply-To: <abLapcC7YGYDyJ3L@kbusch-mbp>
References: <20260312150523.2054552-1-vineeth@bitbyteword.org>
	<20260312150523.2054552-4-vineeth@bitbyteword.org>
	<abLapcC7YGYDyJ3L@kbusch-mbp>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ydjzwf5dpd4o6ggwojmqg8uzfsd7tgre
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX19GYtGsO1dCswyGmSJxcmkqX4fLSPUIpq8=
X-HE-Tag: 1773329882-287988
X-HE-Meta: U2FsdGVkX18K7qiQD/6Xfxb0oECS8YNphCvdIFtE4W697E3JZrq5sCtXkBUFLj5HVywLNM5V12eNs6VYSo4DU8pbQWHqQJzFhKKzp0xbsubxSLYXVUZPcB/XmneTwQ6yPsmwmncU+XF9IaxOs2jozDpABWgZpNnRWRr/SxuCv1wRL/Wc371RyFwQHMlxrsft4DMUgmpDDjFEpZZIuIwzPDMxlaV+pIFOwBxo1G/NoqGfw0RfY4Y/B++oQAV2oLAB4WoGD+2ioQHyWuOG24fOA7mT1Td5OXozshyqh7BoQZFr+vzPxdZ+ahwBp2a8A2oQkTGpJ7auyOm/qKsX8ned0DeZiEQmKGGc
X-Spamd-Result: default: False [-1.36 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	DMARC_POLICY_SOFTFAIL(0.10)[goodmis.org : SPF not aligned (relaxed), No valid DKIM,none];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_RCPT(0.00)[io-uring];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	NEURAL_HAM(-0.00)[-0.976];
	R_DKIM_NA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[rostedt@goodmis.org,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_FROM(0.00)[bounces-12651-lists,io-uring=lfdr.de];
	RCVD_COUNT_FIVE(0.00)[5];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,gandalf.local.home:mid]
X-Rspamd-Queue-Id: 53AAC274BD0
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Thu, 12 Mar 2026 09:24:21 -0600
Keith Busch <kbusch@kernel.org> wrote:

> On Thu, Mar 12, 2026 at 11:04:58AM -0400, Vineeth Pillai (Google) wrote:
> >  	if (trace_io_uring_complete_enabled())
> > -		trace_io_uring_complete(req->ctx, req, cqe);
> > +		trace_invoke_io_uring_complete(req->ctx, req, cqe);  
> 
> Curious, this one doesn't follow that pattern of "if (enabed && cond)"
> that this cover letter said it was addressing, so why doesn't this call
> just drop the 'if' check and go straight to trace_io_uring_complete()? I
> followed this usage to commit a0730c738309a06, which says that the

You mean 'a0727c738309a06'? As I could not find the above 'a0730c738309a06'

> compiler was generating code to move args before checking if the trace
> was enabled. That commit was a while ago though, and suggests to remove

It was only 2023.

> the check if that problem is solved. Is it still a problem?

We should check. But also, tracepoints should never be in a header file.
That really should be:

#include <linux/tracepoint-defs.h>

DECLARE_TRACEPOINT(io_uring_complete);

[..]

	if (tracepoint_enabled(io_uring_complete))
		do_trace_io_uring_complete(...);

And in a C file, that should be:

void do_io_uring_complete(...)
{
	trace_inovke_io_uring_complete(...);
}


Which reminds me. There's other places that have that tracepoint_enabled()
in header files that do the above. The C wrapper functions should also
convert the callback to the trace_invoke_<event>() call.

-- Steve

