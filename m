Return-Path: <io-uring+bounces-11623-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D537D1B668
	for <lists+io-uring@lfdr.de>; Tue, 13 Jan 2026 22:31:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 2AECE3034188
	for <lists+io-uring@lfdr.de>; Tue, 13 Jan 2026 21:31:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7EBAE274B37;
	Tue, 13 Jan 2026 21:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="IKuARoap";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="WBcMAv3v";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="IKuARoap";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="WBcMAv3v"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 088E51B6D1A
	for <io-uring@vger.kernel.org>; Tue, 13 Jan 2026 21:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768339903; cv=none; b=ColdVJv7gTWnvgRd2zHnuthP0yLV1cz8WhjTrMAfqsdTmuRgDhsNmesERinLtCP74gW1eEJOZ5KmVSCHiTb/P1fRCwFqSAR1WyQJ9Af7UwPMr37uDMTFVwqQ21i8m7YEUlmGsMUGf3CSFg4mLUMMqdrStJZf14SLqxrA1p9RW2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768339903; c=relaxed/simple;
	bh=/V7AlGNVHsQsMHKMR47Ssy89ZFLlXiYyH9cSLsKkh1k=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=cXKHF/k6TNv5R1we6b52KQElTGStHERzUZaAL6iSbydJRRgWUUJcKhF51fQjSDlw54avKTMpo5lUGw39c2646nRIQ42fdxBJBekc8/iN4qGMSM+neovgz2gNsEkENXlxm7dWWDHyhICAEBd0hbqWiPxhUprJbCkGwLPINUVBE/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=IKuARoap; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=WBcMAv3v; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=IKuARoap; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=WBcMAv3v; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 4CBDB33713;
	Tue, 13 Jan 2026 21:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1768339900; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zI3J7Hz5Nnn+IR3eSgs9/6yZpNwYjekecoXF4KJRTE8=;
	b=IKuARoapWn7lLwwZFVslBjdfFu7H7hawGIDAv+YMNlnjkETXwRiHL7BryyZFMoHuq848Zl
	zAsJZJTG0eDwCBNVksqpWbzJ9Wqvibjvy6KR/7EjpUC27yDCaz3+xkD09xgOvxlrsrnple
	XQ0px3cR8O6SaZFNMaCr1Md2/p5703Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1768339900;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zI3J7Hz5Nnn+IR3eSgs9/6yZpNwYjekecoXF4KJRTE8=;
	b=WBcMAv3vCLtfs+N8XdXfx4X9CTFuADdYeSLSuR3NQB4OP5Yun5r6VRmEyC2tPn1nWwQjP2
	THK8EL1GiPNNP5Dw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1768339900; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zI3J7Hz5Nnn+IR3eSgs9/6yZpNwYjekecoXF4KJRTE8=;
	b=IKuARoapWn7lLwwZFVslBjdfFu7H7hawGIDAv+YMNlnjkETXwRiHL7BryyZFMoHuq848Zl
	zAsJZJTG0eDwCBNVksqpWbzJ9Wqvibjvy6KR/7EjpUC27yDCaz3+xkD09xgOvxlrsrnple
	XQ0px3cR8O6SaZFNMaCr1Md2/p5703Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1768339900;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zI3J7Hz5Nnn+IR3eSgs9/6yZpNwYjekecoXF4KJRTE8=;
	b=WBcMAv3vCLtfs+N8XdXfx4X9CTFuADdYeSLSuR3NQB4OP5Yun5r6VRmEyC2tPn1nWwQjP2
	THK8EL1GiPNNP5Dw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id EA3DA3EA63;
	Tue, 13 Jan 2026 21:31:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id bU2SLru5Zmk9aQAAD6G6ig
	(envelope-from <krisman@suse.de>); Tue, 13 Jan 2026 21:31:39 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org,  axboe@kernel.dk
Subject: Re: [PATCH liburing 1/1] man: add io_uring_register_region.3
In-Reply-To: <6ba5f1669bfe047ed790ee47c37ca63fd65b05de.1768334542.git.asml.silence@gmail.com>
	(Pavel Begunkov's message of "Tue, 13 Jan 2026 20:05:05 +0000")
References: <6ba5f1669bfe047ed790ee47c37ca63fd65b05de.1768334542.git.asml.silence@gmail.com>
Date: Tue, 13 Jan 2026 16:31:38 -0500
Message-ID: <87ldi12o91.fsf@mailhost.krisman.be>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	TAGGED_RCPT(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_TLS_ALL(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Score: -4.30
X-Spam-Level: 

Pavel Begunkov <asml.silence@gmail.com> writes:

> Describe the region API. As it was created for a bunch of ideas in mind,
> it doesn't go into details about wait argument passing, which I assume
> will be a separate page the region description can refer to.
>

Hey, Pavel.


> diff --git a/man/io_uring_register_region.3 b/man/io_uring_register_region.3
> new file mode 100644
> index 00000000..06ebd466
> --- /dev/null
> +++ b/man/io_uring_register_region.3
> @@ -0,0 +1,123 @@
> +.\" Copyright (C) 2026 Pavel Begunkov <asml.silence@gmail.com>
> +.\"
> +.\" SPDX-License-Identifier: LGPL-2.0-or-later
> +.\"
> +.TH io_uring_register_region 3 "Jan 13, 2026" "liburing-2.14" "liburing Manual"
> +.SH NAME
> +io_uring_register_region \- register a memory region
> +.SH SYNOPSIS
> +.nf
> +.B #include <liburing.h>
> +.PP
> +.BI "int io_uring_register_region(struct io_uring *" ring ",
> +.BI "                             struct io_uring_mem_region_reg *" reg ");"
> +.fi
> +.SH DESCRIPTION
> +.PP
> +The
> +.BR io_uring_register_region (3)
> +function registers a memory region to io_uring. The memory region can after be
> +used, for example, to pass waiting parameters to the
> +.BR io_uring_enter (2)
> +system call in an efficient manner. The
> +.IR ring

.I ring

> +argument should point to the ring in question, and the
> +.IR reg

.I reg

> +argument should be a pointer to a
> +.B struct io_uring_mem_region_reg .

.IR  struct io_uring_mem_region_reg .

> +
> +The
> +.IR reg

.I reg

> +argument must be filled in with the appropriate information. It looks as
> +follows:
> +.PP
> +.in +4n
> +.EX
> +struct io_uring_mem_region_reg {
> +    __u64 region_uptr;
> +    __u64 flags;
> +    __u64 __resv[2];
> +};
> +.EE
> +.in
> +.PP
> +The
> +.I region_uptr
> +field must contain a pointer to an appropriately filled
> +.B struct io_uring_region_desc.

.IR struct io_uring_region_desc .

> +.PP
> +The
> +.I flags
> +field must contain a bitmask of the following values:
> +.TP
> +.B IORING_MEM_REGION_REG_WAIT_ARG
> +allows to use the region topass waiting parameters to the

"to pass"

> +.BR io_uring_enter (2)
> +system call. If set, the registration is only allowed while the ring
> +is in a disabled mode.

While the ring is disabled.

> + See
> +.B IORING_SETUP_R_DISABLED.

.BR IORING_SETUP_R_DISABLED .

> +.PP
> +The __resv fields must be filled with zeroes.
> +
> +.PP
> +.B struct io_uring_region_desc

.I struct io_uring_region_desc

> +is defined as following:
> +.PP
> +.in +4n
> +.EX
> +struct io_uring_region_desc {
> +    __u64 user_addr;
> +    __u64 size;
> +    __u32 flags;
> +    __u32 id;
> +    __u64 mmap_offset;
> +    __u64 __resv[4];
> +};
> +.EE
> +.in
> +
> +.PP
> +The
> +.I user_addr
> +field must contain a pointer to the memory the user wants to register. It's
> +only valid if
> +.B IORING_MEM_REGION_TYPE_USER
> +is set, and should be zero otherwise.

must be set to zero otherwise.

> +.PP
> +The
> +.I size
> +field should contain the size of the region.

must contain
> +
> +The
> +.I flags
> +field must contain a bitmask of the following values:
> +.TP
> +.B IORING_MEM_REGION_TYPE_USER
> +tells the kernel to use memory specified by the
> +.I user_addr
> +field. If not set, the kernel will allocate memory for the region, which can
> +then be mapped into the user space.
> +
> +.PP
> +On a successful registration of a region with kernel provided memory, the

"On success, the"

> +.I mmap_offset
> +field will contain an offset that can be passed to the
> +.B mmap(2)

.BR mmap (2)

> +system call to map the region into the user space.
> +
> +The
> +.I id
> +field is reserved and must be set to zero.
> +
> +The
> +.I __resv
> +fields must be filled with zeroes.
> +
> +Available since kernel 6.13.
> +
> +.SH RETURN VALUE
> +On success
> +.BR io_uring_register_region (3)
> +returns 0. On failure it returns
> +.BR -errno .

.I errno

-- 
Gabriel Krisman Bertazi

