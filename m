Return-Path: <io-uring+bounces-10568-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E154C56DD2
	for <lists+io-uring@lfdr.de>; Thu, 13 Nov 2025 11:32:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 4567F352769
	for <lists+io-uring@lfdr.de>; Thu, 13 Nov 2025 10:30:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 265872DCF44;
	Thu, 13 Nov 2025 10:29:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="QZaJU+UA";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="n6v53ajO";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="QZaJU+UA";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="n6v53ajO"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 564D22D7DC0
	for <io-uring@vger.kernel.org>; Thu, 13 Nov 2025 10:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763029774; cv=none; b=WLF9iB35Vonx0VsGC2Srfl5PXQo3m9BFUadKe2ZMBh2v2jVLB26piqh5ZBzOhTW3iojB7aHr2WzyvItM/xlPOAfdvuPYyP5ma2jEx7KZpyjxuB34/rlvHCrT9QwWDp8F+k8fm1zs8mfeOZEraHpQec2Oly4MQEhdJ2Aa9L1s/ZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763029774; c=relaxed/simple;
	bh=EdxMMYP3OMDgOn1dWGY93xT1/GTro01KrpeZCiNIn6w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E9rbQ/IDyk1HKCG0Qmi+L0RJt/v1/YTaK0PFD6D6M5btcDfJtYfjpl6mJeH2nrYneJnm4VJYk2as85dnfkzn6iODFF1jDcAzRWfNbUpOwVhIiS6nbCazN9Y3RUdyS5wHBi49Dv7/1y5Ky1oeV2o/V5k+dV2Gu1WxIY06alr9lR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=QZaJU+UA; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=n6v53ajO; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=QZaJU+UA; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=n6v53ajO; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 6B2781F388;
	Thu, 13 Nov 2025 10:29:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1763029770; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8CfwcUgjTUIb4jzzyZq2CHKhB+J/WEr0oALzTrcVKzU=;
	b=QZaJU+UArIlJ2roAt9yu1epWm/KonJzOMEXxJ/yEflz1gVntfH2F9+9mGoeAfammbhc/8T
	N24qCK9ST7IwmDIlFrWaGbu9eQorVQmY9qGLPYexIOqOyoG+Wofqqp/jhfJc2rf8hmzlFT
	YIZI3XkipzUSVtkiYGOUBipmtm6zCPw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1763029770;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8CfwcUgjTUIb4jzzyZq2CHKhB+J/WEr0oALzTrcVKzU=;
	b=n6v53ajOrrZh+BOwczXO5VKxRKHuxTi0wa/Z5I6Hnw9RxLosSQ06yWQjxHUDrLT3VSR9sp
	RXjg0zPC0avzobCA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1763029770; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8CfwcUgjTUIb4jzzyZq2CHKhB+J/WEr0oALzTrcVKzU=;
	b=QZaJU+UArIlJ2roAt9yu1epWm/KonJzOMEXxJ/yEflz1gVntfH2F9+9mGoeAfammbhc/8T
	N24qCK9ST7IwmDIlFrWaGbu9eQorVQmY9qGLPYexIOqOyoG+Wofqqp/jhfJc2rf8hmzlFT
	YIZI3XkipzUSVtkiYGOUBipmtm6zCPw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1763029770;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8CfwcUgjTUIb4jzzyZq2CHKhB+J/WEr0oALzTrcVKzU=;
	b=n6v53ajOrrZh+BOwczXO5VKxRKHuxTi0wa/Z5I6Hnw9RxLosSQ06yWQjxHUDrLT3VSR9sp
	RXjg0zPC0avzobCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5C29B3EA61;
	Thu, 13 Nov 2025 10:29:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id +Tt3FgqzFWnHMAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 13 Nov 2025 10:29:30 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 0EC7BA0976; Thu, 13 Nov 2025 11:29:30 +0100 (CET)
Date: Thu, 13 Nov 2025 11:29:30 +0100
From: Jan Kara <jack@suse.cz>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, torvalds@linux-foundation.org, 
	brauner@kernel.org, jack@suse.cz, mjguzik@gmail.com, paul@paul-moore.com, 
	axboe@kernel.dk, audit@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [RFC][PATCH 10/13] get rid of audit_reusename()
Message-ID: <pytwvcwr5z4ax6fwcpvsgsinmvpjlxtey2f6hiqu6hczw6sxxg@bw6wblwhlfr7>
References: <20251109063745.2089578-1-viro@zeniv.linux.org.uk>
 <20251109063745.2089578-11-viro@zeniv.linux.org.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251109063745.2089578-11-viro@zeniv.linux.org.uk>
X-Spamd-Result: default: False [-3.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_COUNT_THREE(0.00)[3];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[vger.kernel.org,linux-foundation.org,kernel.org,suse.cz,gmail.com,paul-moore.com,kernel.dk];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[10];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.cz:email,linux.org.uk:email,suse.com:email]
X-Spam-Flag: NO
X-Spam-Score: -3.80
X-Spam-Level: 

On Sun 09-11-25 06:37:42, Al Viro wrote:
> Originally we tried to avoid multiple insertions into audit names array
> during retry loop by a cute hack - memorize the userland pointer and
> if there already is a match, just grab an extra reference to it.
> 
> Cute as it had been, it had problems - two identical pointers had
> audit aux entries merged, two identical strings did not.  Having
> different behaviour for syscalls that differ only by addresses of
> otherwise identical string arguments is obviously wrong - if nothing
> else, compiler can decide to merge identical string literals.
> 
> Besides, this hack does nothing for non-audited processes - they get
> a fresh copy for retry.  It's not time-critical, but having behaviour
> subtly differ that way is bogus.
> 
> These days we have very few places that import filename more than once
> (9 functions total) and it's easy to massage them so we get rid of all
> re-imports.  With that done, we don't need audit_reusename() anymore.
> There's no need to memorize userland pointer either.
> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/namei.c            | 11 +++--------
>  include/linux/audit.h | 11 -----------
>  include/linux/fs.h    |  1 -
>  kernel/auditsc.c      | 23 -----------------------
>  4 files changed, 3 insertions(+), 43 deletions(-)
> 
> diff --git a/fs/namei.c b/fs/namei.c
> index 7377020a2cba..dd86e41deeeb 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -125,9 +125,8 @@
>  
>  #define EMBEDDED_NAME_MAX	(PATH_MAX - offsetof(struct filename, iname))
>  
> -static inline void initname(struct filename *name, const char __user *uptr)
> +static inline void initname(struct filename *name)
>  {
> -	name->uptr = uptr;
>  	name->aname = NULL;
>  	atomic_set(&name->refcnt, 1);
>  }
> @@ -139,10 +138,6 @@ getname_flags(const char __user *filename, int flags)
>  	char *kname;
>  	int len;
>  
> -	result = audit_reusename(filename);
> -	if (result)
> -		return result;
> -
>  	result = __getname();
>  	if (unlikely(!result))
>  		return ERR_PTR(-ENOMEM);
> @@ -210,7 +205,7 @@ getname_flags(const char __user *filename, int flags)
>  			return ERR_PTR(-ENAMETOOLONG);
>  		}
>  	}
> -	initname(result, filename);
> +	initname(result);
>  	audit_getname(result);
>  	return result;
>  }
> @@ -268,7 +263,7 @@ struct filename *getname_kernel(const char * filename)
>  		return ERR_PTR(-ENAMETOOLONG);
>  	}
>  	memcpy((char *)result->name, filename, len);
> -	initname(result, NULL);
> +	initname(result);
>  	audit_getname(result);
>  	return result;
>  }
> diff --git a/include/linux/audit.h b/include/linux/audit.h
> index 536f8ee8da81..d936a604d056 100644
> --- a/include/linux/audit.h
> +++ b/include/linux/audit.h
> @@ -316,7 +316,6 @@ extern void __audit_uring_exit(int success, long code);
>  extern void __audit_syscall_entry(int major, unsigned long a0, unsigned long a1,
>  				  unsigned long a2, unsigned long a3);
>  extern void __audit_syscall_exit(int ret_success, long ret_value);
> -extern struct filename *__audit_reusename(const __user char *uptr);
>  extern void __audit_getname(struct filename *name);
>  extern void __audit_inode(struct filename *name, const struct dentry *dentry,
>  				unsigned int flags);
> @@ -380,12 +379,6 @@ static inline void audit_syscall_exit(void *pt_regs)
>  		__audit_syscall_exit(success, return_code);
>  	}
>  }
> -static inline struct filename *audit_reusename(const __user char *name)
> -{
> -	if (unlikely(!audit_dummy_context()))
> -		return __audit_reusename(name);
> -	return NULL;
> -}
>  static inline void audit_getname(struct filename *name)
>  {
>  	if (unlikely(!audit_dummy_context()))
> @@ -624,10 +617,6 @@ static inline struct audit_context *audit_context(void)
>  {
>  	return NULL;
>  }
> -static inline struct filename *audit_reusename(const __user char *name)
> -{
> -	return NULL;
> -}
>  static inline void audit_getname(struct filename *name)
>  { }
>  static inline void audit_inode(struct filename *name,
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index c895146c1444..bbae3cfdc338 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -2835,7 +2835,6 @@ extern struct kobject *fs_kobj;
>  struct audit_names;
>  struct filename {
>  	const char		*name;	/* pointer to actual string */
> -	const __user char	*uptr;	/* original userland pointer */
>  	atomic_t		refcnt;
>  	struct audit_names	*aname;
>  	const char		iname[];
> diff --git a/kernel/auditsc.c b/kernel/auditsc.c
> index d1966144bdfe..e59a094bb9f7 100644
> --- a/kernel/auditsc.c
> +++ b/kernel/auditsc.c
> @@ -2169,29 +2169,6 @@ static struct audit_names *audit_alloc_name(struct audit_context *context,
>  	return aname;
>  }
>  
> -/**
> - * __audit_reusename - fill out filename with info from existing entry
> - * @uptr: userland ptr to pathname
> - *
> - * Search the audit_names list for the current audit context. If there is an
> - * existing entry with a matching "uptr" then return the filename
> - * associated with that audit_name. If not, return NULL.
> - */
> -struct filename *
> -__audit_reusename(const __user char *uptr)
> -{
> -	struct audit_context *context = audit_context();
> -	struct audit_names *n;
> -
> -	list_for_each_entry(n, &context->names_list, list) {
> -		if (!n->name)
> -			continue;
> -		if (n->name->uptr == uptr)
> -			return refname(n->name);
> -	}
> -	return NULL;
> -}
> -
>  /**
>   * __audit_getname - add a name to the list
>   * @name: name to add
> -- 
> 2.47.3
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

