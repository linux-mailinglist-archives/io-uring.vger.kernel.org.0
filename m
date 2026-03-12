Return-Path: <io-uring+bounces-12649-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4PTdKVzdsmmtQQAAu9opvQ
	(envelope-from <io-uring+bounces-12649-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 12 Mar 2026 16:35:56 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A9309274986
	for <lists+io-uring@lfdr.de>; Thu, 12 Mar 2026 16:35:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 24232308F2DD
	for <lists+io-uring@lfdr.de>; Thu, 12 Mar 2026 15:24:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 688093845CB;
	Thu, 12 Mar 2026 15:24:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EVdn0v0z"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4393D399013;
	Thu, 12 Mar 2026 15:24:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773329064; cv=none; b=EO5Wk2LTP7tONdPBzm3A98umGtDad2QbLjg8Qxml2OY5/cbY148BgkHF2eR4l6XJhgghcVNA24SVnUQhYcsRrm4/8A+AAfXHTe+oDlI8iFzO/dHBACo8gkyEoglMM9SKg1gREyMa1/jSY5FM1NNIT+gvk863gohk5avbA2BNJFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773329064; c=relaxed/simple;
	bh=cN0KMaLzaUcJbNNpmje9MQ0FALTu2rXzl0SOp/23i1k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q/P3q3rlD7Zna1NAvktT6M4VOg6e7gPEDsFkPFW/uLF5ssQHzsdl5Off++bthWUUmHv1df9bUc2u/dlCwLRQLN6OEUXIdsXdv+I2xLMZrwfSqsKIinZjMV/QORbmBTQnru81xuUaW5c0SeEt+sCZyqqtcMexQ5dogyT93qw9xMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EVdn0v0z; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A67CCC4CEF7;
	Thu, 12 Mar 2026 15:24:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773329064;
	bh=cN0KMaLzaUcJbNNpmje9MQ0FALTu2rXzl0SOp/23i1k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EVdn0v0z/kVnpPSRvBwBMLT/TyFi4iWnnCtXnS03ygImp276Okr6QIgFmbyh8YUuQ
	 fRl5p6xDUo6dkMDRtf6BVK8HlilV2NbnI5mhT2UPI+dZ1pC8aLr3uZKVgsk4AhQMX4
	 4pt3j/SbVUZkEr1rRXYBOB3MLB02fjh3RjtB1UtM0/bTcKLiyFzo2gZYPsvIvkuiFw
	 jgCKZC4iBR3IhmflZQsPnAc1T/mtScrETJcX496IP7reRdtDUEhAZVcuQroEHZ6MzP
	 fIIg4CN+V43IJcflWBCtidXBNE0bzCZi4utXQMgBG/O0vM35eDTGpPKmKn2a1qukeH
	 PEWbRcdz+grdQ==
Date: Thu, 12 Mar 2026 09:24:21 -0600
From: Keith Busch <kbusch@kernel.org>
To: "Vineeth Pillai (Google)" <vineeth@bitbyteword.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Peter Zijlstra <peterz@infradead.org>, Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH 03/15] io_uring: Use trace_invoke_##name() at guarded
 tracepoint call sites
Message-ID: <abLapcC7YGYDyJ3L@kbusch-mbp>
References: <20260312150523.2054552-1-vineeth@bitbyteword.org>
 <20260312150523.2054552-4-vineeth@bitbyteword.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260312150523.2054552-4-vineeth@bitbyteword.org>
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12649-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kbusch@kernel.org,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: A9309274986
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Thu, Mar 12, 2026 at 11:04:58AM -0400, Vineeth Pillai (Google) wrote:
>  	if (trace_io_uring_complete_enabled())
> -		trace_io_uring_complete(req->ctx, req, cqe);
> +		trace_invoke_io_uring_complete(req->ctx, req, cqe);

Curious, this one doesn't follow that pattern of "if (enabed && cond)"
that this cover letter said it was addressing, so why doesn't this call
just drop the 'if' check and go straight to trace_io_uring_complete()? I
followed this usage to commit a0730c738309a06, which says that the
compiler was generating code to move args before checking if the trace
was enabled. That commit was a while ago though, and suggests to remove
the check if that problem is solved. Is it still a problem?

