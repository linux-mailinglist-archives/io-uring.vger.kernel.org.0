Return-Path: <io-uring+bounces-1920-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CDD8E8C8C5D
	for <lists+io-uring@lfdr.de>; Fri, 17 May 2024 20:52:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 27E69B21FED
	for <lists+io-uring@lfdr.de>; Fri, 17 May 2024 18:52:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D952101CF;
	Fri, 17 May 2024 18:51:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="jYhN3ago";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="9PR70E+K";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="jYhN3ago";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="9PR70E+K"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81859DDD2
	for <io-uring@vger.kernel.org>; Fri, 17 May 2024 18:51:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715971918; cv=none; b=fdPWlhndcxDirS2w7PetWCP9DEXX3EfNtZDJvPaEQe+5Ei+jL1ZDbqvQycx2l6xOTvjcHoor5rSmxaxW994RwHtWwPEpwTAx6P96yoa9TJvrKQfc7f8fujEL1INL/IgVYFlyGB3i1jAluR3UURbrgzNpZYyWaMjcHfHpWS2qo9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715971918; c=relaxed/simple;
	bh=by4Pp9SdfOp4S9LnNLreruRUEsnadjQ/YUcy3Y99e7w=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type; b=YXQlen56ndZGaIFFRJu/DCqcfee8FVMUPQk/TBUsjLNRFO60OmxNebrELRiTIWOH79+jM/f5O+70FBHGFR8iqCOp1XUKaXVXzCBt9NpIPxoXZ28ImuBs0kK6NCe3XBkkcWTep1SVzFgnWTTNE0Hnj/FD07OXwPSQdqQVbL7NxOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=jYhN3ago; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=9PR70E+K; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=jYhN3ago; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=9PR70E+K; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 698973776E
	for <io-uring@vger.kernel.org>; Fri, 17 May 2024 18:51:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1715971914; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type;
	bh=WXo9oSowbV+8reCp8i9+VTeVJ3PIt/2iHnE11AqrC/0=;
	b=jYhN3agoRhpKSExIK5wMVwSVsGUexWABanHsvs7qXDKye7c2dKedl/EvDwUzxfXw8XBHDn
	4gNPnh/4Kb0lXpYgFQlWgr2E8TjG2D0oVfqygs/7rRehZiIna1nZbknYuVsYvPYlcGFAEG
	o4XIHawx6GzC8aY5B3fQfVjOEa9beoE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1715971914;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type;
	bh=WXo9oSowbV+8reCp8i9+VTeVJ3PIt/2iHnE11AqrC/0=;
	b=9PR70E+Kmfh1wGN7qKB7H5k9+CNzCRHksvtnUZlc4kHhHhq/vD1hCX+Im6lyRR4beeASf3
	G+P8ftN9Gi/jVbAA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1715971914; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type;
	bh=WXo9oSowbV+8reCp8i9+VTeVJ3PIt/2iHnE11AqrC/0=;
	b=jYhN3agoRhpKSExIK5wMVwSVsGUexWABanHsvs7qXDKye7c2dKedl/EvDwUzxfXw8XBHDn
	4gNPnh/4Kb0lXpYgFQlWgr2E8TjG2D0oVfqygs/7rRehZiIna1nZbknYuVsYvPYlcGFAEG
	o4XIHawx6GzC8aY5B3fQfVjOEa9beoE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1715971914;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type;
	bh=WXo9oSowbV+8reCp8i9+VTeVJ3PIt/2iHnE11AqrC/0=;
	b=9PR70E+Kmfh1wGN7qKB7H5k9+CNzCRHksvtnUZlc4kHhHhq/vD1hCX+Im6lyRR4beeASf3
	G+P8ftN9Gi/jVbAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2EC8E13942
	for <io-uring@vger.kernel.org>; Fri, 17 May 2024 18:51:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id /jl+BUqnR2bAagAAD6G6ig
	(envelope-from <krisman@suse.de>)
	for <io-uring@vger.kernel.org>; Fri, 17 May 2024 18:51:54 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: io-uring@vger.kernel.org
Subject: [Announcement] io_uring Discord chat
Date: Fri, 17 May 2024 14:51:47 -0400
Message-ID: <8734qguv98.fsf@mailhost.krisman.be>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Flag: NO
X-Spam-Score: 0.94
X-Spam-Level: 
X-Spamd-Result: default: False [0.94 / 50.00];
	SEM_URIBL(3.50)[discord.gg:url];
	BAYES_HAM(-1.26)[89.70%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	PREVIOUSLY_DELIVERED(0.00)[io-uring@vger.kernel.org];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[]

Following our LSFMM conversation, I've created a Discord chat for topics
that could benefit from a more informal, live discussion space than the
mailing list might offer.  The idea is to keep this new channel alive for a
while and see if it does indeed benefit the broader io_uring audience.

The following is an open invite link:

 https://discord.gg/8EwbZ6gkfX

Which might be revoked in the future.  If it no longer works, drop me an
email for a new one.

Once we have some key people around, I intend to add an invite code to
the liburing internal documentation.

Thanks,

-- 
Gabriel Krisman Bertazi

