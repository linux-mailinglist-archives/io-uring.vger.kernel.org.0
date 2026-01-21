Return-Path: <io-uring+bounces-11864-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OMTqImclcWl8eQAAu9opvQ
	(envelope-from <io-uring+bounces-11864-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 21 Jan 2026 20:13:43 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 33F195BE91
	for <lists+io-uring@lfdr.de>; Wed, 21 Jan 2026 20:13:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 31F1A769E4F
	for <lists+io-uring@lfdr.de>; Wed, 21 Jan 2026 18:21:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3F10245005;
	Wed, 21 Jan 2026 18:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="XWuQ1L19";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="ysWZe5/i";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Cqw/Dj0M";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="QXJChWkQ"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE31438A704
	for <io-uring@vger.kernel.org>; Wed, 21 Jan 2026 18:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769019654; cv=none; b=IEuDV7y1+FidqGX+Dfi4d8AKDlEIvPvQWMuNp6WvDpwDmFhABTr2ew6Oa/Vgh0EmuBogo497CwuWTZL6oD/PZ1O9bmKQM4H1BS1WKlF91/5btfVlOTHxanv2/UPGohdx2L+laL/9uLQXboOn2BLejeTy873jUrVDbeY3nnCCZiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769019654; c=relaxed/simple;
	bh=VwvrOM3S3d0J4OD2Rvi36AIm/M+S5dgqlGAfrdp+F/M=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=j+aQlI2JacmZQXHjorWAKTt7uqPnlrh95cWeESJgr6PVVyFDb/Anc5+mvnD6jB+ZhSA5z4ONa1BA2ELjEy4mVBDCj062qmnFqsAs7qtDtLHLbjWp8D4gGX/K4liGl9k5e+BrxdTLM5QY4SQ00bpa3MkoOHlKQ9e31lPd78WwU4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=XWuQ1L19; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=ysWZe5/i; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Cqw/Dj0M; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=QXJChWkQ; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id ED04B5BD5A;
	Wed, 21 Jan 2026 18:20:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1769019651; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JC1zXQLlqvYLrEM9LmyCTwA01dupR24tNMoIn0XEt74=;
	b=XWuQ1L19PFN1lopZhGw5WFNjVgTD64hODvMnUaOcEGgNYTv7qt63uVFP35re7BIvjk3A3F
	iQqDk1Slm5ERDs+RR8m1X3wvGzFYVJRrvl4FsL8FRG8yLcP4ze51s1t1gzTwx94HetunZl
	cVt0h2ewoHzu7TJK95GpU2SBUn9lbxY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1769019651;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JC1zXQLlqvYLrEM9LmyCTwA01dupR24tNMoIn0XEt74=;
	b=ysWZe5/iy+20FlPnBwRnicPQGFYdFWyTBtV3kkk4ifvb3CPkslxLOpjLS0+OhT0QcwIXYr
	BrEd0lLH/9tL1rAQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1769019650; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JC1zXQLlqvYLrEM9LmyCTwA01dupR24tNMoIn0XEt74=;
	b=Cqw/Dj0MWW6nFmf77bUUtkzjk/WYC5S8XF6qelhu9Jx2nhRrrlfw0fFMwsYM7q6eaRw6my
	kBN7dI4u5PgvPJ8X75XbWrp8Pm35oyT1EB7KVHvhojLgWx03vDLKz6jrYAhAXm+VKvU04c
	JQZmSapVJodtXR7rx6JeSWGNANYGlqM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1769019650;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JC1zXQLlqvYLrEM9LmyCTwA01dupR24tNMoIn0XEt74=;
	b=QXJChWkQz5R6tN+jLe/bjFnEuIaVDYN9yyu1Hlk962FN9SceU5o5OEIpKRGeaNUc39a16a
	Ql3pn0uQK8JqzAAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9C35A3EA63;
	Wed, 21 Jan 2026 18:20:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id qon3GQIZcWlnTwAAD6G6ig
	(envelope-from <krisman@suse.de>); Wed, 21 Jan 2026 18:20:50 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org,  axboe@kernel.dk
Subject: Re: [PATCH v3 1/1] io_uring: introduce non-circular SQ
In-Reply-To: <b7a5502ee3da7ef096455498cd1ad3efbdbee288.1768940337.git.asml.silence@gmail.com>
	(Pavel Begunkov's message of "Tue, 20 Jan 2026 20:47:40 +0000")
References: <b7a5502ee3da7ef096455498cd1ad3efbdbee288.1768940337.git.asml.silence@gmail.com>
Date: Wed, 21 Jan 2026 13:20:48 -0500
Message-ID: <87a4y6esjj.fsf@mailhost.krisman.be>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Score: -4.30
X-Spam-Level: 
X-Spam-Flag: NO
X-Spamd-Result: default: False [-1.46 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-11864-lists,io-uring=lfdr.de];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_POLICY_ALLOW(0.00)[suse.de,none];
	FREEMAIL_TO(0.00)[gmail.com];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[suse.de:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	RCVD_COUNT_FIVE(0.00)[6];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:7979, ipnet:213.196.21.0/24, country:US];
	FROM_NEQ_ENVFROM(0.00)[krisman@suse.de,io-uring@vger.kernel.org];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[]
X-Rspamd-Queue-Id: 33F195BE91
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Pavel Begunkov <asml.silence@gmail.com> writes:

> Outside of SQPOLL, normally SQ entries are consumed by the time the
> submission syscall returns. For those cases we don't need a circular
> buffer and the head/tail tracking, instead the kernel can assume that
> entries always start from the beginning of the SQ at index 0. This patch
> introduces a setup flag doing exactly that. It's a simpler and helps
> to keeps SQEs hot in cache.
>
> The feature is optional and enabled by setting IORING_SETUP_SQ_REWIND.
> The flag is rejected if passed together with SQPOLL as it'd require
> waiting for SQ before each submission. It also requires
> IORING_SETUP_NO_SQARRAY, which can be supported but it's unlikely there
> will be users, so leave more space for future optimisations.

This patch got me wondering if it would make sense to have a way to
point to different buffers as the SQE map and execute them.  This way
the user could initialize a set of operations in a specific region of
the sq ring (or a separate buffer) once and have them repeatedly
executed with a single command, similar to a procedure call.

Say we have a preloaded ring with some sqes to accept a new connection,
and immediately some fixed data, etc.  When I want to run it, I push a
SQE OP_EXECUTE pointing to this buffer to the "main" ring and io_uring
will queue everything in this pre-registered buffer.

I imagine it would save nothing beyond SQ initialization. just curious
if you see a use case for something like this?

-- 
Gabriel Krisman Bertazi

