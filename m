Return-Path: <io-uring+bounces-1624-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D0A538B2182
	for <lists+io-uring@lfdr.de>; Thu, 25 Apr 2024 14:19:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D5B17B23150
	for <lists+io-uring@lfdr.de>; Thu, 25 Apr 2024 12:19:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B43712C475;
	Thu, 25 Apr 2024 12:19:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="BC4e7i3m";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="kjVe+JoD";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="BC4e7i3m";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="kjVe+JoD"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BD8912C460
	for <io-uring@vger.kernel.org>; Thu, 25 Apr 2024 12:19:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714047583; cv=none; b=cwZqzo/+QSZB4igyhEMYOw5wUaTkp3U7LucCdOYEjwmxVy5EK/uwyQV9tygZsAxTcB23zbudRNffQ3qcHND8FAPMYpJHfHGq5n4gEvxnc7oZ5BLxVU1as6XZYuXXGcw55Pvs1wzTA77MbBWKAZpan7BDJWv88JjadaL+/zZG/yU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714047583; c=relaxed/simple;
	bh=fAYpmbEfaOad3uOs973lAK/Sv+6XHhgwRsbSDTu0F7k=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=YPa1rJIb/YStiE+xBlmBc+p6xl0BqdNcVYCDj4eVEvcJdiELvEv8W3O8NL9wdMjxcWrntVPmNpmjtyH5N+3g+EaR9qIB6NCtgclUWoQusMONqO8f66tuSDpCw1oVXBL8g1LPTAQ1XFlQ8YmUnRjtDuCD7YoCB93ZR2oTY2bE54E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=BC4e7i3m; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=kjVe+JoD; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=BC4e7i3m; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=kjVe+JoD; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 7660320B46;
	Thu, 25 Apr 2024 12:19:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1714047579; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xiOtR+TPnvS30irRjYe83LDGunHmjhF9DX3AbWN6p/Q=;
	b=BC4e7i3mgEhJdTyyWBHQM7fS8sr7Al93WEoWcSKiKAbOu422fw2u4TOL6/gPx1pUKNmxp1
	Am0BNYweccZKpDxR15nDCiqGfHyFl3j7S1mMChj+61Yct2Gm8xbxRTw1+QyX7XqCRCXL1I
	QF7Iitnpx9ifROHr+TbKpwEvMULwYDI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1714047579;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xiOtR+TPnvS30irRjYe83LDGunHmjhF9DX3AbWN6p/Q=;
	b=kjVe+JoDlfBhYvdPrc6sXipHigwtQvOgUVUjLMyRzZqKWDhKOTlgwz56kQAH9lVdGiKtsb
	s64AORNKSZ+2eNAA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=BC4e7i3m;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=kjVe+JoD
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1714047579; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xiOtR+TPnvS30irRjYe83LDGunHmjhF9DX3AbWN6p/Q=;
	b=BC4e7i3mgEhJdTyyWBHQM7fS8sr7Al93WEoWcSKiKAbOu422fw2u4TOL6/gPx1pUKNmxp1
	Am0BNYweccZKpDxR15nDCiqGfHyFl3j7S1mMChj+61Yct2Gm8xbxRTw1+QyX7XqCRCXL1I
	QF7Iitnpx9ifROHr+TbKpwEvMULwYDI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1714047579;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xiOtR+TPnvS30irRjYe83LDGunHmjhF9DX3AbWN6p/Q=;
	b=kjVe+JoDlfBhYvdPrc6sXipHigwtQvOgUVUjLMyRzZqKWDhKOTlgwz56kQAH9lVdGiKtsb
	s64AORNKSZ+2eNAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6C37C13991;
	Thu, 25 Apr 2024 12:19:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id wXJlGltKKmYMXgAAD6G6ig
	(envelope-from <krisman@suse.de>); Thu, 25 Apr 2024 12:19:39 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org
Subject: Re: [PATCH 2/5] io_uring/net: add provided buffer support for
 IORING_OP_SEND
In-Reply-To: <878r11zmdj.fsf@mailhost.krisman.be> (Gabriel Krisman Bertazi's
	message of "Thu, 25 Apr 2024 13:56:40 +0200")
References: <20240420133233.500590-2-axboe@kernel.dk>
	<20240420133233.500590-4-axboe@kernel.dk>
	<878r11zmdj.fsf@mailhost.krisman.be>
Date: Thu, 25 Apr 2024 14:19:39 +0200
Message-ID: <87cyqdzlb8.fsf@mailhost.krisman.be>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Level: 
X-Spamd-Result: default: False [-4.62 / 50.00];
	DWL_DNSWL_MED(-2.00)[suse.de:dkim];
	BAYES_HAM(-1.11)[88.30%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-0.998];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_TLS_ALL(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RCPT_COUNT_TWO(0.00)[2];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 7660320B46
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spam-Score: -4.62

Gabriel Krisman Bertazi <krisman@suse.de> writes:

...

> situation where the buffers and requests mismatch,  and only one buffer
> gets sent.

Sorry, here I meant that *only part of a buffer* might get sent because
we truncate to sqe->len.  As in the example I gave.

-- 
Gabriel Krisman Bertazi

