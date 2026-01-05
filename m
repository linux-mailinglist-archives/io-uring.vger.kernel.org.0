Return-Path: <io-uring+bounces-11378-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 017DBCF5D7F
	for <lists+io-uring@lfdr.de>; Mon, 05 Jan 2026 23:34:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D0132302EF7B
	for <lists+io-uring@lfdr.de>; Mon,  5 Jan 2026 22:34:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CE292749DC;
	Mon,  5 Jan 2026 22:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="sq+fXULg";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="grH2k2PN";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="sq+fXULg";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="grH2k2PN"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A0FD214204
	for <io-uring@vger.kernel.org>; Mon,  5 Jan 2026 22:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767652452; cv=none; b=UVOvwj6Nk/p9qNpasot++K4SWGlOQLtOemeToltisVjAIUyqU3++JL7W3FkcD2MCM940JCwu9oDuIq0N8Zn06CPrC3EQVK8aLJsugEA1VGrz8Y8qzxYBGpzO+QGavQoN7BYxLI8TbdoSeafyRTLh/lr7FkETndDyI7x5ACfTRfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767652452; c=relaxed/simple;
	bh=M2I8HRDRvAPDWmJO+6IF2/sSd3jXPJmhBuQsvkY9sy0=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=UQpCKt5gebYvJtAlxExWqCmRaEWi0xRogeF5WOtG/34RRnn1WSE2yKbjcR5G6oVjs49cTeRSh8jbjFuSQnK7CyfDYRob7I8Oq79mS2j4Me7w7cGu03QWju8667d13RgzAp7IHcW5Yss9bHbrWkcPaTVRwjU3IT6v+bDTD4X66oY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=sq+fXULg; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=grH2k2PN; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=sq+fXULg; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=grH2k2PN; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 670775BCC2;
	Mon,  5 Jan 2026 22:34:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1767652448; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zu1vGQPa5huHz93dG/7ZdznYOHEIfZYP3AH/zRoyCnY=;
	b=sq+fXULgpDplXzCl3zalETSDUnu8zI2XWVQv89DrxTWRnzHClhrFjpXlDxsLFBI/Y+YlTK
	V23INMwtlBNA4sXJc3FgBSITQLmuOggKdEmIP3vq/7lBAO8SyZZ9Pz7Oprh30zHACPF3rT
	Xf9HEGV9AA8c+dwPe03f32bH6h8JbPM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1767652448;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zu1vGQPa5huHz93dG/7ZdznYOHEIfZYP3AH/zRoyCnY=;
	b=grH2k2PN7rRNhBat0+nUUFm3rPKg1e+5rH5CC/LqVXg2+A69jKHE7FQeT5jVhypz7lhM46
	Xf9av+0QwSSFc+AQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=sq+fXULg;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=grH2k2PN
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1767652448; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zu1vGQPa5huHz93dG/7ZdznYOHEIfZYP3AH/zRoyCnY=;
	b=sq+fXULgpDplXzCl3zalETSDUnu8zI2XWVQv89DrxTWRnzHClhrFjpXlDxsLFBI/Y+YlTK
	V23INMwtlBNA4sXJc3FgBSITQLmuOggKdEmIP3vq/7lBAO8SyZZ9Pz7Oprh30zHACPF3rT
	Xf9HEGV9AA8c+dwPe03f32bH6h8JbPM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1767652448;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zu1vGQPa5huHz93dG/7ZdznYOHEIfZYP3AH/zRoyCnY=;
	b=grH2k2PN7rRNhBat0+nUUFm3rPKg1e+5rH5CC/LqVXg2+A69jKHE7FQeT5jVhypz7lhM46
	Xf9av+0QwSSFc+AQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0FC633EA63;
	Mon,  5 Jan 2026 22:34:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id QWiZOF88XGk8WwAAD6G6ig
	(envelope-from <krisman@suse.de>); Mon, 05 Jan 2026 22:34:07 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring <io-uring@vger.kernel.org>
Subject: Re: [PATCH] io_uring/io-wq: remove io_wq_for_each_worker() return
 value
In-Reply-To: <708b2a6d-7c87-4f94-8d15-c450228c6b6b@kernel.dk> (Jens Axboe's
	message of "Mon, 5 Jan 2026 11:45:50 -0700")
References: <708b2a6d-7c87-4f94-8d15-c450228c6b6b@kernel.dk>
Date: Mon, 05 Jan 2026 17:34:06 -0500
Message-ID: <87h5sz7kpt.fsf@mailhost.krisman.be>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Flag: NO
X-Spam-Score: -4.51
X-Rspamd-Queue-Id: 670775BCC2
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-0.997];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	ARC_NA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RCPT_COUNT_TWO(0.00)[2];
	TO_DN_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:email]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Level: 

Jens Axboe <axboe@kernel.dk> writes:

> The only use of this helper is to iterate all of the workers, and
> hence all callers will pass in a func that always returns false to do
> that. As none of the callers use the return value, get rid of it.
>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>

Looks good

Reviewed-by: Gabriel Krisman Bertazi <krisman@suse.de>

-- 
Gabriel Krisman Bertazi

