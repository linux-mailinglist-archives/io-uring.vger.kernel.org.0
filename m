Return-Path: <io-uring+bounces-7065-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 03204A5E114
	for <lists+io-uring@lfdr.de>; Wed, 12 Mar 2025 16:52:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 79C633A1EAE
	for <lists+io-uring@lfdr.de>; Wed, 12 Mar 2025 15:52:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52BC32566D5;
	Wed, 12 Mar 2025 15:51:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="fxMytm9d";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Yxo63xRQ";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="fxMytm9d";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Yxo63xRQ"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A413D254865
	for <io-uring@vger.kernel.org>; Wed, 12 Mar 2025 15:51:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741794690; cv=none; b=SzEFCGlC+LG/nSa2QT44pncORw6I8FV2LSRFNiRWZ0o9SRlekh7RRTZo5wfaoeIF78KV/+WM63G+acXHhIn08FjyWE9UvhSNgg0ypJSck9QRwl/xGiuQfEM+pc9rRJykIuCdPKifg3ma6JLYQB4u+wNTGZjjlmL7FGfyT0WHMLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741794690; c=relaxed/simple;
	bh=x0bzaDEk8aQvniRaJxUgWv0R2t78KM+JXoY5XWMzc4E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N376Lad152QhEapzDRYRdGcww0ZF83eeGv+uQKcWxbildzL85gqo69XNv86Xb6rpa/rYuS7dqn+pvHTATfonu6n/AQhpsiN3J2IfHzt5umXnl27/NQGJWW6V2okH2Nj2mR+I43FnlPqdkwehTDTWuXWlghF7xd9/5gWiK+YMEtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=fxMytm9d; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Yxo63xRQ; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=fxMytm9d; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Yxo63xRQ; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id BEDEB21195;
	Wed, 12 Mar 2025 15:51:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1741794686; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YAolITJtosWbgnrc4Sl1gW+rHyFKKmQ+Fk910mjL86Q=;
	b=fxMytm9dRWRHCGHtl03ouUJ/RAM32u41BjH5yWb28VwBeyGiIo3THR55jxsgi//yujU/3h
	MOlKmPR591vXtv1Abv73AKMvfFsVnQsYK+8PiKNoqORrr8pY7CAQuBZ0NjvqX+7MaI6vrm
	bB8XcjTb+z7Y+cm7LU07iE5w+daL9ww=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1741794686;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YAolITJtosWbgnrc4Sl1gW+rHyFKKmQ+Fk910mjL86Q=;
	b=Yxo63xRQgDxrt9B4y5UvKmUR34SS4Cs8MVqymB2MqaJUVmcrFeA6ivRuYCb/ilRM+74DEe
	t68JcSrFQne43BBA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=fxMytm9d;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Yxo63xRQ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1741794686; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YAolITJtosWbgnrc4Sl1gW+rHyFKKmQ+Fk910mjL86Q=;
	b=fxMytm9dRWRHCGHtl03ouUJ/RAM32u41BjH5yWb28VwBeyGiIo3THR55jxsgi//yujU/3h
	MOlKmPR591vXtv1Abv73AKMvfFsVnQsYK+8PiKNoqORrr8pY7CAQuBZ0NjvqX+7MaI6vrm
	bB8XcjTb+z7Y+cm7LU07iE5w+daL9ww=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1741794686;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YAolITJtosWbgnrc4Sl1gW+rHyFKKmQ+Fk910mjL86Q=;
	b=Yxo63xRQgDxrt9B4y5UvKmUR34SS4Cs8MVqymB2MqaJUVmcrFeA6ivRuYCb/ilRM+74DEe
	t68JcSrFQne43BBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B389313AA9;
	Wed, 12 Mar 2025 15:51:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id VcPOK36t0WenFAAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 12 Mar 2025 15:51:26 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 65CB5A0908; Wed, 12 Mar 2025 16:51:22 +0100 (CET)
Date: Wed, 12 Mar 2025 16:51:22 +0100
From: Jan Kara <jack@suse.cz>
To: Mateusz Guzik <mjguzik@gmail.com>
Cc: brauner@kernel.org, viro@zeniv.linux.org.uk, jack@suse.cz, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, 
	audit@vger.kernel.org, axboe@kernel.dk
Subject: Re: [PATCH] fs: dodge an atomic in putname if ref == 1
Message-ID: <naalmvyvolpfkwxoztkskhz2kyoznjjhm5y4zmfd44tyf5d24k@2jap6ty4nkwz>
References: <20250311181804.1165758-1-mjguzik@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250311181804.1165758-1-mjguzik@gmail.com>
X-Rspamd-Queue-Id: BEDEB21195
X-Spam-Score: -4.01
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_COUNT_THREE(0.00)[3];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[9];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spam-Level: 

On Tue 11-03-25 19:18:04, Mateusz Guzik wrote:
> While the structure is refcounted, the only consumer incrementing it is
> audit and even then the atomic operation is only needed when it
> interacts with io_uring.
> 
> If putname spots a count of 1, there is no legitimate way for anyone to
> bump it.
> 
> If audit is disabled, the count is guaranteed to be 1, which
> consistently elides the atomic for all path lookups. If audit is
> enabled, it still manages to elide the last decrement.
> 
> Note the patch does not do anything to prevent audit from suffering
> atomics. See [1] and [2] for a different approach.
> 
> Benchmarked on Sapphire Rapids issuing access() (ops/s):
> before: 5106246
> after:  5269678 (+3%)
> 
> Link 1:	https://lore.kernel.org/linux-fsdevel/20250307161155.760949-1-mjguzik@gmail.com/
> Link 2: https://lore.kernel.org/linux-fsdevel/20250307164216.GI2023217@ZenIV/
> Signed-off-by: Mateusz Guzik <mjguzik@gmail.com>

Yeah, I like this much more than the original. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> This is an alternative to the patch I linked above.
> 
> I think the improved commit message should also cover the feedback
> Christian previously shared concerning it.
> 
> This is a trivial win until the atomic issue gets resolved, I don't see
> any reason to NOT include it. At the same time I don't have that much
> interest arguing about it either.
> 
> That is to say, here is a different take, if you don't like it, I'm
> dropping the subject.
> 
> cheers
> 
>  fs/namei.c | 13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/namei.c b/fs/namei.c
> index 06765d320e7e..add90981cfcd 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -275,14 +275,19 @@ EXPORT_SYMBOL(getname_kernel);
>  
>  void putname(struct filename *name)
>  {
> +	int refcnt;
> +
>  	if (IS_ERR_OR_NULL(name))
>  		return;
>  
> -	if (WARN_ON_ONCE(!atomic_read(&name->refcnt)))
> -		return;
> +	refcnt = atomic_read(&name->refcnt);
> +	if (refcnt != 1) {
> +		if (WARN_ON_ONCE(!refcnt))
> +			return;
>  
> -	if (!atomic_dec_and_test(&name->refcnt))
> -		return;
> +		if (!atomic_dec_and_test(&name->refcnt))
> +			return;
> +	}
>  
>  	if (name->name != name->iname) {
>  		__putname(name->name);
> -- 
> 2.43.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

