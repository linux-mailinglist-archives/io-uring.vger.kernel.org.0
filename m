Return-Path: <io-uring+bounces-1681-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C52558B6F20
	for <lists+io-uring@lfdr.de>; Tue, 30 Apr 2024 12:09:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5BED61F240F0
	for <lists+io-uring@lfdr.de>; Tue, 30 Apr 2024 10:09:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E78A41292EE;
	Tue, 30 Apr 2024 10:09:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="vqeIBGjX";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Y4Kk2Nxd";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="vqeIBGjX";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Y4Kk2Nxd"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EAF41292D2;
	Tue, 30 Apr 2024 10:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714471746; cv=none; b=KaNj+aypUkEfNo2NrHq261CP3NJiWi5N2mYkHWXQ6PHJujb6Od8sLmT3NJ3HtBWZssBTi3tHWJ9w1uGLWCNHK0vBFzBBPERR7+cQdgXF2o6nsDXkfiCS1uqr371ZyA74st6r6Wq1tO0leNn0x0cdxyepAYRyRvlAoTuwlEMkm+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714471746; c=relaxed/simple;
	bh=Y2+hS4qRZuLrKbWWMcpktJxJo5s+UAVeM+RZTE4OeK0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LNNUvR1Uqle1LdnqILH4BFZJ4W5Hnak1XB6YDa8YHh3xyoQdLAq2Y5jlERygrE6yEGDBEFBxseqoMAaBL7+YFuR/Pte8jzpvJd7tnFBOwdg59FYq36DWeWBkTeuhYy8Dk+w9r0vA+ANSp4kAJ5ExchF0vZj37jOC1EZJqzpbH90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=vqeIBGjX; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Y4Kk2Nxd; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=vqeIBGjX; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Y4Kk2Nxd; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 94A5233F55;
	Tue, 30 Apr 2024 10:09:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1714471742; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PTUPyaWcpZDKUukiVIneGRzBea/lmcCk8kXRR619DJk=;
	b=vqeIBGjXPKb0XycMvacAW428uolNoqtaN+EBo2mJHjf74TxTIQVlt1MpATsa4IuUZcKLzy
	UJEys7GFBXXE5vubiBV2DPs1hUa/STmWvTjbv7yEWIAwLpxqDSUen9/F+c160SQUX7J9ZM
	gWZoQjDIPJgvZSToK75KO55SPRn2Kws=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1714471742;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PTUPyaWcpZDKUukiVIneGRzBea/lmcCk8kXRR619DJk=;
	b=Y4Kk2NxdcsJrpGpYXQLpbXlde7mZBRQhy/lhK6wfFaRvxYGJW/MWwnAVpk3q6wgGY68wCh
	8DrbHfPc84XlzxAg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1714471742; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PTUPyaWcpZDKUukiVIneGRzBea/lmcCk8kXRR619DJk=;
	b=vqeIBGjXPKb0XycMvacAW428uolNoqtaN+EBo2mJHjf74TxTIQVlt1MpATsa4IuUZcKLzy
	UJEys7GFBXXE5vubiBV2DPs1hUa/STmWvTjbv7yEWIAwLpxqDSUen9/F+c160SQUX7J9ZM
	gWZoQjDIPJgvZSToK75KO55SPRn2Kws=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1714471742;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PTUPyaWcpZDKUukiVIneGRzBea/lmcCk8kXRR619DJk=;
	b=Y4Kk2NxdcsJrpGpYXQLpbXlde7mZBRQhy/lhK6wfFaRvxYGJW/MWwnAVpk3q6wgGY68wCh
	8DrbHfPc84XlzxAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 86112137BA;
	Tue, 30 Apr 2024 10:09:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id CkR2ID7DMGa6bAAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 30 Apr 2024 10:09:02 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 32814A06D4; Tue, 30 Apr 2024 12:09:02 +0200 (CEST)
Date: Tue, 30 Apr 2024 12:09:02 +0200
From: Jan Kara <jack@suse.cz>
To: cgzones@googlemail.com
Cc: x86@kernel.org, linux-alpha@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-ia64@vger.kernel.org, linux-m68k@lists.linux-m68k.org,
	linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
	linux-sh@vger.kernel.org, sparclinux@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, audit@vger.kernel.org,
	linux-arch@vger.kernel.org, linux-api@vger.kernel.org,
	linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
	Richard Henderson <richard.henderson@linaro.org>,
	Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
	Matt Turner <mattst88@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Michal Simek <monstr@monstr.eu>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Helge Deller <deller@gmx.de>, Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	"Naveen N. Rao" <naveen.n.rao@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	Rich Felker <dalias@libc.org>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	"David S. Miller" <davem@davemloft.net>,
	Andreas Larsson <andreas@gaisler.com>,
	Andy Lutomirski <luto@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>, Chris Zankel <chris@zankel.net>,
	Max Filippov <jcmvbkbc@gmail.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Paul Moore <paul@paul-moore.com>, Eric Paris <eparis@redhat.com>,
	Arnd Bergmann <arnd@arndb.de>, Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Sohil Mehta <sohil.mehta@intel.com>,
	Palmer Dabbelt <palmer@sifive.com>,
	Miklos Szeredi <mszeredi@redhat.com>, Nhat Pham <nphamcs@gmail.com>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Kees Cook <keescook@chromium.org>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Mark Rutland <mark.rutland@arm.com>, io-uring@vger.kernel.org
Subject: Re: [PATCH v3 2/2] fs/xattr: add *at family syscalls
Message-ID: <20240430100902.iwmeszr2jzv4wyo7@quack3>
References: <20240426162042.191916-1-cgoettsche@seltendoof.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240426162042.191916-1-cgoettsche@seltendoof.de>
X-Spam-Level: 
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FREEMAIL_CC(0.00)[kernel.org,vger.kernel.org,lists.infradead.org,lists.linux-m68k.org,lists.ozlabs.org,linaro.org,jurassic.park.msu.ru,gmail.com,armlinux.org.uk,arm.com,linux-m68k.org,monstr.eu,alpha.franken.de,HansenPartnership.com,gmx.de,ellerman.id.au,csgroup.eu,linux.ibm.com,users.sourceforge.jp,libc.org,physik.fu-berlin.de,davemloft.net,gaisler.com,linutronix.de,redhat.com,alien8.de,linux.intel.com,zytor.com,zankel.net,zeniv.linux.org.uk,suse.cz,paul-moore.com,arndb.de,kernel.dk,infradead.org,intel.com,sifive.com,schaufler-ca.com,broadcom.com,chromium.org];
	TAGGED_RCPT(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	FREEMAIL_TO(0.00)[googlemail.com];
	RCVD_COUNT_THREE(0.00)[3];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	TO_MATCH_ENVRCPT_SOME(0.00)[];
	RCPT_COUNT_GT_50(0.00)[72];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Spam-Score: -2.30
X-Spam-Flag: NO

On Fri 26-04-24 18:20:14, Christian Göttsche wrote:
> From: Christian Göttsche <cgzones@googlemail.com>
> 
> Add the four syscalls setxattrat(), getxattrat(), listxattrat() and
> removexattrat().  Those can be used to operate on extended attributes,
> especially security related ones, either relative to a pinned directory
> or on a file descriptor without read access, avoiding a
> /proc/<pid>/fd/<fd> detour, requiring a mounted procfs.
> 
> One use case will be setfiles(8) setting SELinux file contexts
> ("security.selinux") without race conditions and without a file
> descriptor opened with read access requiring SELinux read permission.
> 
> Use the do_{name}at() pattern from fs/open.c.
> 
> Pass the value of the extended attribute, its length, and for
> setxattrat(2) the command (XATTR_CREATE or XATTR_REPLACE) via an added
> struct xattr_args to not exceed six syscall arguments and not
> merging the AT_* and XATTR_* flags.
> 
> Signed-off-by: Christian Göttsche <cgzones@googlemail.com>

The patch looks good to me. Just a few nits below:

> -static int path_setxattr(const char __user *pathname,
> +static int do_setxattrat(int dfd, const char __user *pathname, unsigned int at_flags,

Can we please stay within 80 columns (happens in multiple places in the
patch)? I don't insist but it makes things easier to read in some setups so
I prefer it.

> @@ -852,13 +908,21 @@ listxattr(struct dentry *d, char __user *list, size_t size)
>  	return error;
>  }
>  
> -static ssize_t path_listxattr(const char __user *pathname, char __user *list,
> -			      size_t size, unsigned int lookup_flags)
> +static ssize_t do_listxattrat(int dfd, const char __user *pathname, char __user *list,
> +			      size_t size, int flags)

So I like how in previous syscalls you have 'at_flags', 'lookup_flags', and
'xattr_flags'. That makes things much easier to digest. Can you please stay
with that convention here as well and call this argument 'at_flags'? Also I
think the argument ordering like "dfd, pathname, at_flags, list, size" is
more consistent with other syscalls you define.

> @@ -870,16 +934,22 @@ static ssize_t path_listxattr(const char __user *pathname, char __user *list,
>  	return error;
>  }
>  
> +SYSCALL_DEFINE5(listxattrat, int, dfd, const char __user *, pathname, char __user *, list,
> +		size_t, size, int, flags)
> +{
> +	return do_listxattrat(dfd, pathname, list, size, flags);
> +}
> +

Same comment as above - "flags" -> "at_flags" and reorder args please.

> @@ -917,13 +987,21 @@ removexattr(struct mnt_idmap *idmap, struct dentry *d,
>  	return vfs_removexattr(idmap, d, kname);
>  }
>  
> -static int path_removexattr(const char __user *pathname,
> -			    const char __user *name, unsigned int lookup_flags)
> +static int do_removexattrat(int dfd, const char __user *pathname,
> +			    const char __user *name, int flags)
>  {

Same comment as above - "flags" -> "at_flags" and reorder args please.

> @@ -939,16 +1017,22 @@ static int path_removexattr(const char __user *pathname,
>  	return error;
>  }
>  
> +SYSCALL_DEFINE4(removexattrat, int, dfd, const char __user *, pathname,
> +		const char __user *, name, int, flags)
> +{

Same comment as above - "flags" -> "at_flags" and reorder args please.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

