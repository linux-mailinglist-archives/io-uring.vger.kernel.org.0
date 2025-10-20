Return-Path: <io-uring+bounces-10063-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id D9A2DBF1F6F
	for <lists+io-uring@lfdr.de>; Mon, 20 Oct 2025 17:00:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 3CB6C4F6AA9
	for <lists+io-uring@lfdr.de>; Mon, 20 Oct 2025 15:00:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BC0523E342;
	Mon, 20 Oct 2025 15:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="S4fFpxWT";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="XMQyAlEE";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Jl+/UGnV";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="cX8FpQkm"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 549B723D7CA
	for <io-uring@vger.kernel.org>; Mon, 20 Oct 2025 15:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760972415; cv=none; b=aAGvVhULRhCvsOYrN0PGIb5d4tSeTKx6sSiJ9MBRPdBrAkazo5OVAUVj4VIXw0RrjywQbiVdl49fPGLuef7rL4HTVPWqsUhoG98qBgB8cV8ppyy1Anmj6gzL6UfGFOqMP3KChnVnpH+r/QEwBZJ1E0kjkBJBOhAhdR+aoPxB5+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760972415; c=relaxed/simple;
	bh=0fVHr2X4aDIF911o11vLZUtn8vmwaDh/Ss4KAK+I9c0=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=SwkBpZVkZbGR73uIrKgBPaXbIiycqF9z2GxL4iw8zbFwsZxm8MIBK3sDgypmjoJnBK3OaOi0PRnS4LyQpzIpjvoD9IqKmlSlMhpSRRK/Zub8wfV3SRCZkY1QDwN6k+5+ImLlMrXi4fa4wV+8ByRt7J7tEbTVCt8azyLc9HqkC8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=S4fFpxWT; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=XMQyAlEE; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Jl+/UGnV; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=cX8FpQkm; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 2F32F1F38D;
	Mon, 20 Oct 2025 15:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1760972407; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sTQF5JivMo0EJptP2dNl8c7K8BGbtDjP43m9I72526Y=;
	b=S4fFpxWT0WSrgH1COX6GNIuUVchp1PNGStUXhBw3ffT4zddvQXssaRzgCD3IFBa1nTQ9/T
	iRXjifzOveyJe0KeBzfnQkDCctWU6gvqEn2gOyX77GzV/ua037Wl+BdkOU8u5Qstj1zT/h
	vzxtTAZednSxr5qlgO590RfDalsm4jc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1760972407;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sTQF5JivMo0EJptP2dNl8c7K8BGbtDjP43m9I72526Y=;
	b=XMQyAlEERDp1Mz3gP8t97bpkH7v9nquyKTZCl7l2Huf57c7irGGHjfgllcU3bSXBWzfKad
	5FJwem6QmQJt+kAQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="Jl+/UGnV";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=cX8FpQkm
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1760972403; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sTQF5JivMo0EJptP2dNl8c7K8BGbtDjP43m9I72526Y=;
	b=Jl+/UGnVICmzcZXYAEmBWJvGt3PeC7IdmC97rYwnkjWXywrQX8Uza1lE1X+9fRVc+bVKuV
	MCG6p3oITSq7zc+Gyjhrex0MPwyy9nn8lnxkDisbz8gockq41MZ3GgNAzeZQPv8adLlYwb
	OZ4901wJtYg5F0dfLNIXLVJ3zyGH2oo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1760972403;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sTQF5JivMo0EJptP2dNl8c7K8BGbtDjP43m9I72526Y=;
	b=cX8FpQkmtPuaxCVmbtY8rCkgNM9sBsEWD0WDFNPsN2u/wHMjM2o2J+s61fnMeDHPjgOs43
	rONlVNJCptey3fDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CEB4313A8E;
	Mon, 20 Oct 2025 15:00:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id hSzAKHJO9miNQQAAD6G6ig
	(envelope-from <krisman@suse.de>); Mon, 20 Oct 2025 15:00:02 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: Alok Tiwari <alok.a.tiwari@oracle.com>
Cc: csander@purestorage.com,  axboe@kernel.dk,  io-uring@vger.kernel.org,
  alok.a.tiwarilinux@gmail.com
Subject: Re: [PATCH v2] io_uring: fix incorrect unlikely() usage in
 io_waitid_prep()
In-Reply-To: <20251018193300.1517312-1-alok.a.tiwari@oracle.com> (Alok
	Tiwari's message of "Sat, 18 Oct 2025 12:32:54 -0700")
References: <20251018193300.1517312-1-alok.a.tiwari@oracle.com>
Date: Mon, 20 Oct 2025 11:00:01 -0400
Message-ID: <87h5vt39fy.fsf@mailhost.krisman.be>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: 2F32F1F38D
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[purestorage.com,kernel.dk,vger.kernel.org,gmail.com];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[oracle.com:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:email,suse.de:dkim]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 

Alok Tiwari <alok.a.tiwari@oracle.com> writes:

> The negation operator incorrectly places outside the unlikely() macro:
>
>     if (!unlikely(iwa))
>
> This inverted the compiler branch prediction hint, marking the NULL
> case as likely instead of unlikely. The intent is to indicate that
> allocation failures are rare, consistent with common kernel patterns.
>
>  Moving the negation inside unlikely():
>
>     if (unlikely(!iwa))
>
> Fixes: 2b4fc4cd43f2 ("io_uring/waitid: setup async data in the prep handler")
> Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>

Reviewed-by: Gabriel Krisman Bertazi <krisman@suse.de>


-- 
Gabriel Krisman Bertazi

