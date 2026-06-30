Return-Path: <io-uring+bounces-13855-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id ysdRKayFQ2onaAoAu9opvQ
	(envelope-from <io-uring+bounces-13855-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 30 Jun 2026 11:00:28 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B2F26E1DCD
	for <lists+io-uring@lfdr.de>; Tue, 30 Jun 2026 11:00:27 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=iZrsH3kT;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=IM8PTSe2;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=KBYgwT7+;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=BxEi7nWk;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13855-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.234.253.10 as permitted sender) smtp.mailfrom="io-uring+bounces-13855-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=none) header.from=suse.de;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E28D830125C6
	for <lists+io-uring@lfdr.de>; Tue, 30 Jun 2026 09:00:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9550437C112;
	Tue, 30 Jun 2026 09:00:25 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 197F53438A4
	for <io-uring@vger.kernel.org>; Tue, 30 Jun 2026 09:00:23 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782810025; cv=none; b=ITNkuU2A6+fVnZOJhwyoUQrc+RyfpRrFszCUqwaw5R6W/hNB1b0BcthzyxGMEk1canvGNWcdcigq5cEYgAzHIE22ETSjOwZgNbDzGwaRNPACvd2o9IuCybJelLqKIhNVe+w35Ns5X+D33U1IGixc+c5lb1iK5bY77YuQ4x/6g6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782810025; c=relaxed/simple;
	bh=kOe29cC4sJhOm3plC50LoMxQwm0D9HhrkW+nvEm8NGs=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=GtaXnVZoasq+pYVD6L9IcGFPlJ7NEJhPAWbpegbhl24/F1hIKAYZvce/ydOQl7umkvYQzmGyeC+VYhn6FZuQ2gWh55cxZDeDvtbBqIVHepV46lpDgZgAG6mhqhaZJcj/NE92v7zd3akUnHcdqk/xGZh5DDhcF7BTGD2sVQLSGzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=iZrsH3kT; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=IM8PTSe2; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=KBYgwT7+; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=BxEi7nWk; arc=none smtp.client-ip=195.135.223.131
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E60A975EBB;
	Tue, 30 Jun 2026 09:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782810022; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=f1+O2WCp9jiLEOwPjE3ABodaDR6p6VbAmBaUKVlsie4=;
	b=iZrsH3kTRWJTpx766NI8TyrOlLaLZ5VUcpBu9Sw2qc7AnRlqsosoY9Ec22mhvrKau5VJmw
	xbapFWkgnuVfHuzJ/4r/yGSDz2DQjAT4O6xHbJIUtSW3trZyZlXO6Q/SSlBF2ayYz45N//
	2GOWNoYyzWYHS63EMHyjtUTt721Xz3s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782810022;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=f1+O2WCp9jiLEOwPjE3ABodaDR6p6VbAmBaUKVlsie4=;
	b=IM8PTSe2OkKMMoWMjgTQ340E2VkwrjgyfXp5dOhLnFKTagEEx8x+6x62mqdgzh4+l60B/x
	isjhVwngRxkFNYAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782810021; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=f1+O2WCp9jiLEOwPjE3ABodaDR6p6VbAmBaUKVlsie4=;
	b=KBYgwT7+TD3BYLgoovg7SP35qhm2ewzny4Il6Xukeu+VIfiyRXDKVgPwK9DnnF09DpYjZL
	MrOWbNGjQWQxt1e9rVAfIwkMIHOyG9N1K1Wd4q2tMpvN2ysritL3IOZc5A/Stf0+/1rdG+
	hLyjex44IPDd68goH7fGx3vbKD+Oxl0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782810021;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=f1+O2WCp9jiLEOwPjE3ABodaDR6p6VbAmBaUKVlsie4=;
	b=BxEi7nWkG8C10rx5ci6JWPSnYQHaSNAWnOPMt9Dqkfmcu49Ou3P49hZRd8CZA3UlZ+iGkV
	BiS13sx6ctwTzLDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CE66A779A8;
	Tue, 30 Jun 2026 09:00:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id BiqfMKWFQ2oWNAAAD6G6ig
	(envelope-from <krisman@suse.de>); Tue, 30 Jun 2026 09:00:21 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: Yi Xie <xieyi@kylinos.cn>, axboe@kernel.dk
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org, Yi Xie
 <xieyi@kylinos.cn>
Subject: Re: [PATCH] io_uring/memmap: return PTR_ERR() from get_unmapped_area()
In-Reply-To: <20260630065700.97360-1-xieyi@kylinos.cn>
Organization: SUSE
References: <20260630065700.97360-1-xieyi@kylinos.cn>
Date: Tue, 30 Jun 2026 05:00:20 -0400
Message-ID: <87jyrg5rob.fsf@mailhost.krisman.be>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Flag: NO
X-Spam-Level: 
X-Spam-Score: -4.51
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[suse.de,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13855-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS(0.00)[m:xieyi@kylinos.cn,m:axboe@kernel.dk,m:io-uring@vger.kernel.org,m:linux-kernel@vger.kernel.org,s:lists@lfdr.de];
	FORGED_SENDER(0.00)[krisman@suse.de,io-uring@vger.kernel.org];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	HAS_ORG_HEADER(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[suse.de:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[krisman@suse.de,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	ALIAS_RESOLVED(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,suse.de:dkim,suse.de:from_mime,kylinos.cn:email]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 9B2F26E1DCD

Yi Xie <xieyi@kylinos.cn> writes:

> Use PTR_ERR() on validate failure, like io_uring_mmap().

FWIW, this is not about using PTR_ERR, but about changing the return on
error to -EINVAL, which is what is returned by
io_uring_validate_mmap_request.  The commit message should reflect that,
specially because this is returned to userspace eventually, and might
break some application checks..


> Signed-off-by: Yi Xie <xieyi@kylinos.cn>
> ---
>  io_uring/memmap.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/io_uring/memmap.c b/io_uring/memmap.c
> index da1f6c5d07f8..23e8a85111bc 100644
> --- a/io_uring/memmap.c
> +++ b/io_uring/memmap.c
> @@ -337,7 +337,7 @@ unsigned long io_uring_get_unmapped_area(struct file *filp, unsigned long addr,
>  
>  	ptr = io_uring_validate_mmap_request(filp, pgoff);
>  	if (IS_ERR(ptr))
> -		return -ENOMEM;
> +		return PTR_ERR(ptr);
>  
>  	/*
>  	 * Some architectures have strong cache aliasing requirements.
> -- 
> 2.25.1
>

-- 
Gabriel Krisman Bertazi

