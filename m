Return-Path: <io-uring+bounces-7919-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D00EAB0272
	for <lists+io-uring@lfdr.de>; Thu,  8 May 2025 20:17:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B44091890432
	for <lists+io-uring@lfdr.de>; Thu,  8 May 2025 18:17:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6494286D62;
	Thu,  8 May 2025 18:15:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="I4yTrXY1";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="qGet/Qm0";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="I4yTrXY1";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="qGet/Qm0"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3628286D5F
	for <io-uring@vger.kernel.org>; Thu,  8 May 2025 18:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746728101; cv=none; b=XMWPknfdcWrvtzus+7op36CIWRWPsRLOXZqmhiPFVPwPVyWLH6Lwj3VOtxfWk8qZUHUAsPfMGpzne8Myh/885bFkxbmAndle6Etyv34GMmA6Yuq5HXJ9Q2qHMeZj0q4V6NyWsLr4FOCX76IcNxbW7XXqqJKUo/Nx7Wz0hLI+KT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746728101; c=relaxed/simple;
	bh=bIqxo+buTy+uXo1IcC1wenNXw4ZyXcFbVtzv3AQ2aZ8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=eZItdvk7YGs0qQus6nsJlA3hUH+5TDKCZlQKRGvEHHQRcV1JYOdLiQM1rpZFRIfgBiq48oajF1LCMxb6GxPOOlVpswBxLowSQydb5lzbNK/UAZFIrhJk/nYn8EoIl6w9ZlDjPZxMqU8KmxpDIm/hXqZHRgv4/PN2j4mj5Vnb1w0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=I4yTrXY1; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=qGet/Qm0; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=I4yTrXY1; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=qGet/Qm0; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id DEAA11F456;
	Thu,  8 May 2025 18:14:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1746728097; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ECwNebCFMlvogOQSSqjF2wiMnTU+foAxuudsjL7T7AU=;
	b=I4yTrXY1jlajvZYvQypr9lTq9i6jeeBOYayPHTdJ0D1Xy+7VvqpBFR7UL0o4cWrMtUVMTW
	WDvwfPEUUJMmUVb7NHiX0Deb8dHW+f+ZrhriAv5jLGFFJrz0T7GRvCI6KzgNGYZKTQfYm8
	jz58dZDJa8RkRoIw0k3Uy7USXwXUyKI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1746728097;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ECwNebCFMlvogOQSSqjF2wiMnTU+foAxuudsjL7T7AU=;
	b=qGet/Qm0Mn838RvEPe19KgMEWMUZuHl3uQfH0EJjYB/zGE7Jk4Cy4aQxQqzhCRD2msQgrW
	qmAMLTzlnNCnrXDQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1746728097; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ECwNebCFMlvogOQSSqjF2wiMnTU+foAxuudsjL7T7AU=;
	b=I4yTrXY1jlajvZYvQypr9lTq9i6jeeBOYayPHTdJ0D1Xy+7VvqpBFR7UL0o4cWrMtUVMTW
	WDvwfPEUUJMmUVb7NHiX0Deb8dHW+f+ZrhriAv5jLGFFJrz0T7GRvCI6KzgNGYZKTQfYm8
	jz58dZDJa8RkRoIw0k3Uy7USXwXUyKI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1746728097;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ECwNebCFMlvogOQSSqjF2wiMnTU+foAxuudsjL7T7AU=;
	b=qGet/Qm0Mn838RvEPe19KgMEWMUZuHl3uQfH0EJjYB/zGE7Jk4Cy4aQxQqzhCRD2msQgrW
	qmAMLTzlnNCnrXDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 97A1D13712;
	Thu,  8 May 2025 18:14:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id FcPLG6H0HGiwBwAAD6G6ig
	(envelope-from <krisman@suse.de>); Thu, 08 May 2025 18:14:57 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: axboe@kernel.dk
Cc: asml.silence@gmail.com,  io-uring@vger.kernel.org
Subject: Re: [PATCH] io_uring/sqpoll: Increase task_work submission batch size
In-Reply-To: <20250508181203.3785544-1-krisman@suse.de> (Gabriel Krisman
	Bertazi's message of "Thu, 8 May 2025 14:12:03 -0400")
Organization: SUSE
References: <20250508181203.3785544-1-krisman@suse.de>
Date: Thu, 08 May 2025 14:14:56 -0400
Message-ID: <87h61vrmu7.fsf@mailhost.krisman.be>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Flag: NO
X-Spam-Score: -4.30
X-Spam-Level: 
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TAGGED_RCPT(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	HAS_ORG_HEADER(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_THREE(0.00)[3];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,imap1.dmz-prg2.suse.org:helo]

Gabriel Krisman Bertazi <krisman@suse.de> writes:

> Our QA team reported a 10%-23%, throughput reduction on an io_uring
> sqpoll testcase doing IO to a null_blk, that I traced back to a
> reduction of the device submission queue depth utilization. It turns out
> that, after commit af5d68f8892f ("io_uring/sqpoll: manage task_work
> privately"), we capped the number of task_work entries that can be
> completed from a single spin of sqpoll to only 8 entries, before the
> sqpoll goes around to (potentially) sleep.  While this cap doesn't drive
> the submission side directly, it impacts the completion behavior, which
> affects the number of IO queued by fio per sqpoll cycle on the
> submission side, and io_uring ends up seeing less ios per sqpoll cycle.
> As a result, block layer plugging is less effective, and we see more
> time spent inside the block layer in profilings charts, and increased
> submission latency measured by fio.

Uh, this should have been tagged as v2.  The original submission and
some discussion available at:

  https://lore.kernel.org/all/94da2142-d7c1-46bb-bc35-05d0d1c28182@kernel.dk/

-- 
Gabriel Krisman Bertazi

