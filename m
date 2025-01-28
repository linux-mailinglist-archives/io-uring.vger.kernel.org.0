Return-Path: <io-uring+bounces-6170-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F23AA213C9
	for <lists+io-uring@lfdr.de>; Tue, 28 Jan 2025 23:00:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CD7371888ED6
	for <lists+io-uring@lfdr.de>; Tue, 28 Jan 2025 22:00:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CEC8C19755B;
	Tue, 28 Jan 2025 22:00:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="eSUBPTJ9";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="SR353Ox3";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="eSUBPTJ9";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="SR353Ox3"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAF18195B1A
	for <io-uring@vger.kernel.org>; Tue, 28 Jan 2025 22:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738101612; cv=none; b=E+c++3jSHG+8UzhaNZsbYvU4cL0BOmG1cK5IwQGEAwlqbrQEe2l/3T8sKGw9KxaOpeRx8Y/ySc/fCYpK2+CkiTFyEuTS+Y8H8my3BB5Se0zxteRPYp1aV1b46mvMBB2d3enAR2k3eS/94nfcPSyvrKTWEAflaf3ZkL37bZRcIm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738101612; c=relaxed/simple;
	bh=PZKWuVYSszWy2CvJHY7avE1267Q/of+QQhh3Klj6L1U=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=U0EiYdQSn10AjqvgZ2i+Y73W7f4eLaMazoQTcsInjFp/hiIHxoCmoGy7I5KKysHluIqvk+PMC/z8WwWsG9urRe6XDmdSe9TfwsaTNybso/q9+qHkry/o3cB6komadaKVlBkaPX4M2f+dIVyVQVbfuKcudGt38ued38dUntzBHc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=eSUBPTJ9; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=SR353Ox3; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=eSUBPTJ9; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=SR353Ox3; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D0317218D6;
	Tue, 28 Jan 2025 22:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1738101608; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zPH3bPIG3i45BD+kkHmEbvYMehvKo7na8uuxkl2gyq0=;
	b=eSUBPTJ9XkpZricQ6OmeKhQUnwbYbSGDA219X9rrf8JJDZtX7q/qHJ1oPKEEZYVZAz49tt
	TpbdoVWeoUTHsqA5WzD/9ek2inHClLpaHuEqza26U2nH1FfT/0EHzzmLp+CS7bqOL1t/hX
	gjW2vHocQB0pBSPsS1eQ4YpkA8JV3uk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1738101608;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zPH3bPIG3i45BD+kkHmEbvYMehvKo7na8uuxkl2gyq0=;
	b=SR353Ox3UhXoWyeOxbnRK3/ng2B1odMiUtmDESwOhSeZ9SZPm5ZjH78M/jEtKpt7TPD5Ug
	VvJL4LLhXtNHjACQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1738101608; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zPH3bPIG3i45BD+kkHmEbvYMehvKo7na8uuxkl2gyq0=;
	b=eSUBPTJ9XkpZricQ6OmeKhQUnwbYbSGDA219X9rrf8JJDZtX7q/qHJ1oPKEEZYVZAz49tt
	TpbdoVWeoUTHsqA5WzD/9ek2inHClLpaHuEqza26U2nH1FfT/0EHzzmLp+CS7bqOL1t/hX
	gjW2vHocQB0pBSPsS1eQ4YpkA8JV3uk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1738101608;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zPH3bPIG3i45BD+kkHmEbvYMehvKo7na8uuxkl2gyq0=;
	b=SR353Ox3UhXoWyeOxbnRK3/ng2B1odMiUtmDESwOhSeZ9SZPm5ZjH78M/jEtKpt7TPD5Ug
	VvJL4LLhXtNHjACQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 99CA913A60;
	Tue, 28 Jan 2025 22:00:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id M7aaH2hTmWeTKQAAD6G6ig
	(envelope-from <krisman@suse.de>); Tue, 28 Jan 2025 22:00:08 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org
Subject: Re: [PATCH 0/8] alloc cache and iovec assorted cleanups
In-Reply-To: <cover.1738087204.git.asml.silence@gmail.com> (Pavel Begunkov's
	message of "Tue, 28 Jan 2025 20:56:08 +0000")
References: <cover.1738087204.git.asml.silence@gmail.com>
Date: Tue, 28 Jan 2025 16:59:59 -0500
Message-ID: <874j1ik3a8.fsf@mailhost.krisman.be>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Score: -4.30
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-0.999];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FREEMAIL_TO(0.00)[gmail.com];
	TAGGED_RCPT(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email]
X-Spam-Flag: NO
X-Spam-Level: 

Pavel Begunkov <asml.silence@gmail.com> writes:

> A bunch of patches cleaning allocation caches and various bits
> related to io vectors.

Reviewed-by: Gabriel Krisman Bertazi <krisman@suse.de>

>
> Pavel Begunkov (8):
>   io_uring: include all deps for alloc_cache.h
>   io_uring: dont ifdef io_alloc_cache_kasan()
>   io_uring: add alloc_cache.c
>   io_uring/net: make io_net_vec_assign() return void
>   io_uring/net: clean io_msg_copy_hdr()
>   io_uring/net: extract io_send_select_buffer()
>   io_uring: remove !KASAN guards from cache free
>   io_uring/rw: simplify io_rw_recycle()
>
>  io_uring/Makefile      |   2 +-
>  io_uring/alloc_cache.c |  44 +++++++++++++++++
>  io_uring/alloc_cache.h |  60 +++++++----------------
>  io_uring/net.c         | 105 +++++++++++++++++++++++------------------
>  io_uring/rw.c          |  18 ++-----
>  5 files changed, 123 insertions(+), 106 deletions(-)
>  create mode 100644 io_uring/alloc_cache.c

-- 
Gabriel Krisman Bertazi

