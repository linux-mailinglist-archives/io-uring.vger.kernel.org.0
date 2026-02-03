Return-Path: <io-uring+bounces-12037-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IKn/DlU2gmmVQgMAu9opvQ
	(envelope-from <io-uring+bounces-12037-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 03 Feb 2026 18:54:29 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C91B4DD2AE
	for <lists+io-uring@lfdr.de>; Tue, 03 Feb 2026 18:54:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id D151830078B0
	for <lists+io-uring@lfdr.de>; Tue,  3 Feb 2026 17:54:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCA883644CF;
	Tue,  3 Feb 2026 17:54:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R+eggeGP"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 884AE363C74
	for <io-uring@vger.kernel.org>; Tue,  3 Feb 2026 17:54:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770141265; cv=none; b=cxkS4ND4QcZNDCAbj+MM2Y2pNkql++2YJ+DIv1SeeW261PbbHrwtCsS8ZZjrVTE9e6naBw8WuYl4EufjKqnhsfkuon8t59LWKwdFMvZM3kERG/7aImV0csmnKAJccVN/ZJWe5csfgk6Y35ycRGVr6sm4zknDC9f/EGtEcgLLPWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770141265; c=relaxed/simple;
	bh=kAwbIAViO3sjprs2y6acDJbLiu8FtRGtQ1zYMQlFdVE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MIgZgSbjuUFin8YFvG2EQqCve97AgVYMG6EaHM47VsA9nRvxRXMfm0bL7OuDvLBFoKhuMsu/oy6AT+3NwY094gDCeg4LG8NqXAECJUooAE8G8L9vbhIVgK/i6wOlHaxXLz87sV8Bx20DRrqi1RS2hVxV6n40e8O/78prI++JS6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R+eggeGP; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDF8FC116D0;
	Tue,  3 Feb 2026 17:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770141265;
	bh=kAwbIAViO3sjprs2y6acDJbLiu8FtRGtQ1zYMQlFdVE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=R+eggeGPlG+tE93Vzfg6HZyYQA/j4lAtrAUZMw63bdMt1Wzqc2lIZEzTateKCvz78
	 2mmfZPpT0XhaAX1xKhGCO5zZUwRyX9dUUpB5Mazllk8L9k4czm+zHc2SgA+dLAmajs
	 /p3YzDGTlA1sOlcIMDhdSrjFiLSw70IObn7MpXUgSO1al7kAeBLdhtl/QtVWs5l9jh
	 KSmLyZrR+TzLK0w7YtOAsefauLFES4hRAuVCsSh1QEYnV4omnSeHk7H0m2l4HF6SAZ
	 Lu+N69tft2b0GPBgnsROaylrNkqClq0z7reU6L1lJJRwFmfiS8/5Mxml3cjlLVSl1Z
	 4FQEvvnY5Tt1w==
Date: Tue, 3 Feb 2026 10:54:23 -0700
From: Keith Busch <kbusch@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring <io-uring@vger.kernel.org>,
	=?utf-8?B?5piv5Y+C5beu?= <shicenci@gmail.com>
Subject: Re: [PATCH] io_uring/fdinfo: be a bit nicer when looping a lot of
 SQEs/CQEs
Message-ID: <aYI2T75jvb-xeHmr@kbusch-mbp>
References: <f8f9a810-3e66-4010-b6c8-47cd9d1c9292@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f8f9a810-3e66-4010-b6c8-47cd9d1c9292@kernel.dk>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_ALL(0.00)[];
	TAGGED_FROM(0.00)[bounces-12037-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,gmail.com];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	MIME_TRACE(0.00)[0:+];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kbusch@kernel.org,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_RCPT(0.00)[io-uring];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: C91B4DD2AE
X-Rspamd-Action: no action

On Tue, Feb 03, 2026 at 10:06:18AM -0700, Jens Axboe wrote:
> Add cond_resched() in those dump loops, just in case a lot of entries
> are being dumped. And detect invalid CQ ring head/tail entries, to avoid

Hey, another cond_resched that lazy preemption would make unnecessary!
Looks good anyway.

Reviewed-by: Keith Busch <kbusch@kernel.org>

