Return-Path: <io-uring+bounces-11542-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D945D0664B
	for <lists+io-uring@lfdr.de>; Thu, 08 Jan 2026 23:06:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 12405300ACCA
	for <lists+io-uring@lfdr.de>; Thu,  8 Jan 2026 22:04:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8829133987;
	Thu,  8 Jan 2026 22:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="LvtN1/JQ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="YLVd2wY/";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="yr+TTXok";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="KJiW/eRP"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF28A275B05
	for <io-uring@vger.kernel.org>; Thu,  8 Jan 2026 22:04:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767909860; cv=none; b=E/Tt456d5CZzJccMsHuAvMu27BKWJ5tALPLyuUnekLjzyox3+AUCL+iq4fIz6mxRG3alhXqNhbdeOBOnECVGVab5YiTTooh6or1YDJ9X/MrMA22/awvNKMd2Ovaup9HPSSB8qxQD3uhvTUdeK31srBRLBCoGo5UO4BPP+JG6fmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767909860; c=relaxed/simple;
	bh=vGq4wp0+NLLOjlR7w6v/puI3twTXbJP8XBKZCgQfcIM=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=CJDIrkiy7gwXEXlFlU1ZZqxEydKbABxhJad/yZ5e7gNpRaRTpr/P0404zyUDJcNemr1ZdV/Q6iEi70ybxyqDH+0gWpx2JXwGul83HAXZPt+iL2ZE3v8jga4EH6ValuCctRn3XohdCEdIasLPN9hPWozHYrAq1JsvSqn/UuITEwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=LvtN1/JQ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=YLVd2wY/; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=yr+TTXok; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=KJiW/eRP; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id EF1C65CAC0;
	Thu,  8 Jan 2026 22:04:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1767909857; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TNrNc/emxnV8DRs1AxqoEqCBSaxtW/nti9paXFFGEis=;
	b=LvtN1/JQ780mmInSwIcNFEKhTYjzKMuqXgCuyUrtKhguN2ia2JnWGo5oWmCpzvqX/z56ny
	Ap+FtG5opHD+xzEFC+oSsXRTyu9SZkHehHAx7Lu+OTk4jomZhFk6MyJkelOR2v7VHcKEMR
	quUi3PMN0U3m7t2M4rqoHTEs5iK6gmU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1767909857;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TNrNc/emxnV8DRs1AxqoEqCBSaxtW/nti9paXFFGEis=;
	b=YLVd2wY/2E6vvVI3ADqC7soJvwpjPiKnvIC4Gzh7XkMB/qTXNMXfYxPZij93j75rjKlHd5
	+kYAY+1TrbQ8rDBQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1767909855; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TNrNc/emxnV8DRs1AxqoEqCBSaxtW/nti9paXFFGEis=;
	b=yr+TTXokdix52o4Z3ZUfqyJLRZ35qGwFTsRKvVmSNi7J+su/gEJVumQrCYZt66xFVr0Lcs
	ho3u3lcAocyu/v3l2YIQ13ca1gO++JZH5Yy6ME5illBcfYOaDSmUmiQU2h+x3i2I1vmF5B
	J1k6jq8kHNnOOSiUWjUMFdqMtrELOKA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1767909855;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TNrNc/emxnV8DRs1AxqoEqCBSaxtW/nti9paXFFGEis=;
	b=KJiW/eRPWTVPxLxX65GNbZm4XzCQtf1f650NjHWtbs3IbfiS+47FdcvrKSqX8xeeZX5c3/
	8J7YgPrthXv5UnDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AA8DF3EA63;
	Thu,  8 Jan 2026 22:04:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id /hsGI98pYGmQfgAAD6G6ig
	(envelope-from <krisman@suse.de>); Thu, 08 Jan 2026 22:04:15 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org
Subject: Re: [PATCHSET RFC 0/2] Per-task io_uring opcode restrictions
In-Reply-To: <20260108202944.288490-1-axboe@kernel.dk> (Jens Axboe's message
	of "Thu, 8 Jan 2026 13:17:23 -0700")
References: <20260108202944.288490-1-axboe@kernel.dk>
Date: Thu, 08 Jan 2026 17:04:14 -0500
Message-ID: <87pl7j4v8h.fsf@mailhost.krisman.be>
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
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCPT_COUNT_TWO(0.00)[2];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,mailhost.krisman.be:mid,kernel.dk:email]
X-Spam-Flag: NO
X-Spam-Score: -4.30
X-Spam-Level: 

Jens Axboe <axboe@kernel.dk> writes:

> Hi,
>
> One common complaint is that io_uring doesn't work with seccomp. Which
> is true, as seccomp is entirely designed around a classic sync syscall -
> if you can filter what you need based on a syscall number and the
> arguments, then it's fine. But for anything else, it doesn't really
> work. This means that solutions that rely on syscall filtering, eg
> docker, there's really not much you can do with seccomp outside of
> entirely disabling io_uring. That's not ideal.
>
> As I do think that's a gap we have that needs closing, here's an RFC
> attempt at that. Suggestions more than welcome! I want to arrive at
> something that works for the various use cases.
>
> io_uring already has a filtering mechanism for opcodes, however it needs
> to be done after a ring has been created. The ring is created in a
> disabled state, and then restrictions are applied, and finally the ring
> is enabled so it can get used. This is cumbersome and doesn't
> necessarily fit everybody's needs.
>
> This patch adds support for extending that same list of disallowed
> opcodes and register to something that can be applied to the task as a
> whole. Once applied, any ring created under that task will have these
> restrictions applied. Patch 1 adds the basic support for this, and patch
> 2 adds support for having the restrictions applied at fork or thread
> create time too, so any task or thread created under the current task
> will get the same restrictions.

Hi Jens,

Considering this is like to seccomp, a security mechanism, I don't see a
use case for running without IORING_REG_RESTRICTIONS_INHERIT.  Otherwise
there is a quick way around it by just execve'ing into itself.  IIRC,
seccomp also doesn't support disabling filters for the same reason.
So, unless someone has a use case, I'd suggest dropping the flag
and just making IORING_REG_RESTRICTIONS_INHERIT the default behavior.

Beyond that, adding more restrictions on an already restricted
application would be a useful use-case, so returning -EBUSY on
current->io_uring_restrict might not be doable long trem.  But feature
can be added later.

Finally, I suspect we will come quickly to the need of more complex
filtering of arguments, like seccomp.  Again, something that can be
added later but could be considered now for the interface.

> A few test cases can be found in liburing, in the task-restrictions
> branch:
>
> https://git.kernel.org/pub/scm/linux/kernel/git/axboe/liburing.git/log/?h=task-restrictions
>
>  include/linux/io_uring.h       |  2 +-
>  include/linux/io_uring_types.h |  2 ++
>  include/linux/sched.h          |  1 +
>  include/uapi/linux/io_uring.h  | 16 ++++++++++++++
>  io_uring/io_uring.c            | 10 +++++++++
>  io_uring/register.c            | 39 ++++++++++++++++++++++++++++++++++
>  io_uring/tctx.c                | 23 ++++++++++++--------
>  kernel/fork.c                  |  6 ++++++
>  8 files changed, 89 insertions(+), 10 deletions(-)

-- 
Gabriel Krisman Bertazi

