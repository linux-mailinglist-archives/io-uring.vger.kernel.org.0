Return-Path: <io-uring+bounces-1682-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 71F678B6F2D
	for <lists+io-uring@lfdr.de>; Tue, 30 Apr 2024 12:09:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E7AF51F24284
	for <lists+io-uring@lfdr.de>; Tue, 30 Apr 2024 10:09:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 411621292F2;
	Tue, 30 Apr 2024 10:09:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="T0LGj1+c";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="xsEL/I3c";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="T0LGj1+c";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="xsEL/I3c"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76AE71292D2;
	Tue, 30 Apr 2024 10:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714471767; cv=none; b=VjLZ2SBDAcPcKlHePsLSwYrcsxxLcz4XQ+QbWQMOlg2oGeqFDuaRN6S1G8Ev2MDc6+imYtx+yeXMY5eO7cTnzMIJ1Y/RtI7HMlKXonyz9nYqAyAISq6stG0o0ZGmBk6KRrt1KzzV7kNeYwjMm/XZa+RlOQNgSEvjLOeLbifkNOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714471767; c=relaxed/simple;
	bh=7cqAnoVHtALLuHUE1367X0BXWtsk3rzDAdHLXRqdiTw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Drq2gi/qarWHKa4WUcbAVrz3iaqmJtAqQC95xIEFD/T2QhtYP8uqg3WuF8Lac+TidSTBdIQHbSIRjNcxfBZs0891U3OmdP118fphUoxq2PeKui9v2TwUXRwujOunagRsaXFsrQAGRQwgTOFmYJkpWA2MqfugNp/Hqpwm7QFyPAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=T0LGj1+c; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=xsEL/I3c; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=T0LGj1+c; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=xsEL/I3c; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A192B33F52;
	Tue, 30 Apr 2024 10:09:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1714471763; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VdamuZShmEKASPNJ3qfzKU8SAVhaj6hqs+uiGH2CDG4=;
	b=T0LGj1+cWgIzl0wY6knQ+UO1Yu+GkaVQPA1Alaiuko+nrqPEDzzbXYTShOV8PCk0ZllngE
	QDblOgpya34TOryPiTJADfHbHw7Do66JAR1oo9i5hMlrswyICuQr5mjrlU2SernUFaPsoS
	dzySxcI2L2CzZjOI4vziTheV+8Izwtw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1714471763;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VdamuZShmEKASPNJ3qfzKU8SAVhaj6hqs+uiGH2CDG4=;
	b=xsEL/I3cfWp9LQQvJmViQ6WSYa0GPzjsiIAxkBmDYyEyZngbgFPHCqLrBidZRkBxqc2f+S
	Yb/SaUA3ViSuCiAA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=T0LGj1+c;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="xsEL/I3c"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1714471763; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VdamuZShmEKASPNJ3qfzKU8SAVhaj6hqs+uiGH2CDG4=;
	b=T0LGj1+cWgIzl0wY6knQ+UO1Yu+GkaVQPA1Alaiuko+nrqPEDzzbXYTShOV8PCk0ZllngE
	QDblOgpya34TOryPiTJADfHbHw7Do66JAR1oo9i5hMlrswyICuQr5mjrlU2SernUFaPsoS
	dzySxcI2L2CzZjOI4vziTheV+8Izwtw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1714471763;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VdamuZShmEKASPNJ3qfzKU8SAVhaj6hqs+uiGH2CDG4=;
	b=xsEL/I3cfWp9LQQvJmViQ6WSYa0GPzjsiIAxkBmDYyEyZngbgFPHCqLrBidZRkBxqc2f+S
	Yb/SaUA3ViSuCiAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 96EEC136A8;
	Tue, 30 Apr 2024 10:09:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id KQPYJFPDMGbUbAAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 30 Apr 2024 10:09:23 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 5FCA3A06D4; Tue, 30 Apr 2024 12:09:19 +0200 (CEST)
Date: Tue, 30 Apr 2024 12:09:19 +0200
From: Jan Kara <jack@suse.cz>
To: cgzones@googlemail.com
Cc: Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org
Subject: Re: [PATCH v3 1/2] fs: rename struct xattr_ctx to kernel_xattr_ctx
Message-ID: <20240430100919.6kd23ho25qfnyjyz@quack3>
References: <20240426162042.191916-1-cgoettsche@seltendoof.de>
 <20240426162042.191916-2-cgoettsche@seltendoof.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240426162042.191916-2-cgoettsche@seltendoof.de>
X-Spam-Flag: NO
X-Spam-Score: -2.51
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: A192B33F52
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-2.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_COUNT_THREE(0.00)[3];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FREEMAIL_TO(0.00)[googlemail.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_SEVEN(0.00)[9];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TAGGED_RCPT(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_CC(0.00)[kernel.org,zeniv.linux.org.uk,suse.cz,kernel.dk,gmail.com,vger.kernel.org];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.cz:dkim,suse.cz:email]

On Fri 26-04-24 18:20:15, Christian Göttsche wrote:
> From: Christian Göttsche <cgzones@googlemail.com>
> 
> Rename the struct xattr_ctx to increase distinction with the about to be
> added user API struct xattr_args.
> 
> No functional change.
> 
> Suggested-by: Christian Brauner <brauner@kernel.org>
> Signed-off-by: Christian Göttsche <cgzones@googlemail.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
> v3: added based on feedback
> ---
>  fs/internal.h    |  8 ++++----
>  fs/xattr.c       | 10 +++++-----
>  io_uring/xattr.c |  2 +-
>  3 files changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/internal.h b/fs/internal.h
> index 7ca738904e34..1caa6a8f666f 100644
> --- a/fs/internal.h
> +++ b/fs/internal.h
> @@ -260,7 +260,7 @@ struct xattr_name {
>  	char name[XATTR_NAME_MAX + 1];
>  };
>  
> -struct xattr_ctx {
> +struct kernel_xattr_ctx {
>  	/* Value of attribute */
>  	union {
>  		const void __user *cvalue;
> @@ -276,11 +276,11 @@ struct xattr_ctx {
>  
>  ssize_t do_getxattr(struct mnt_idmap *idmap,
>  		    struct dentry *d,
> -		    struct xattr_ctx *ctx);
> +		    struct kernel_xattr_ctx *ctx);
>  
> -int setxattr_copy(const char __user *name, struct xattr_ctx *ctx);
> +int setxattr_copy(const char __user *name, struct kernel_xattr_ctx *ctx);
>  int do_setxattr(struct mnt_idmap *idmap, struct dentry *dentry,
> -		struct xattr_ctx *ctx);
> +		struct kernel_xattr_ctx *ctx);
>  int may_write_xattr(struct mnt_idmap *idmap, struct inode *inode);
>  
>  #ifdef CONFIG_FS_POSIX_ACL
> diff --git a/fs/xattr.c b/fs/xattr.c
> index f8b643f91a98..941aab719da0 100644
> --- a/fs/xattr.c
> +++ b/fs/xattr.c
> @@ -590,7 +590,7 @@ EXPORT_SYMBOL_GPL(vfs_removexattr);
>   * Extended attribute SET operations
>   */
>  
> -int setxattr_copy(const char __user *name, struct xattr_ctx *ctx)
> +int setxattr_copy(const char __user *name, struct kernel_xattr_ctx *ctx)
>  {
>  	int error;
>  
> @@ -620,7 +620,7 @@ int setxattr_copy(const char __user *name, struct xattr_ctx *ctx)
>  }
>  
>  int do_setxattr(struct mnt_idmap *idmap, struct dentry *dentry,
> -		struct xattr_ctx *ctx)
> +		struct kernel_xattr_ctx *ctx)
>  {
>  	if (is_posix_acl_xattr(ctx->kname->name))
>  		return do_set_acl(idmap, dentry, ctx->kname->name,
> @@ -636,7 +636,7 @@ setxattr(struct mnt_idmap *idmap, struct dentry *d,
>  	int flags)
>  {
>  	struct xattr_name kname;
> -	struct xattr_ctx ctx = {
> +	struct kernel_xattr_ctx ctx = {
>  		.cvalue   = value,
>  		.kvalue   = NULL,
>  		.size     = size,
> @@ -719,7 +719,7 @@ SYSCALL_DEFINE5(fsetxattr, int, fd, const char __user *, name,
>   */
>  ssize_t
>  do_getxattr(struct mnt_idmap *idmap, struct dentry *d,
> -	struct xattr_ctx *ctx)
> +	struct kernel_xattr_ctx *ctx)
>  {
>  	ssize_t error;
>  	char *kname = ctx->kname->name;
> @@ -754,7 +754,7 @@ getxattr(struct mnt_idmap *idmap, struct dentry *d,
>  {
>  	ssize_t error;
>  	struct xattr_name kname;
> -	struct xattr_ctx ctx = {
> +	struct kernel_xattr_ctx ctx = {
>  		.value    = value,
>  		.kvalue   = NULL,
>  		.size     = size,
> diff --git a/io_uring/xattr.c b/io_uring/xattr.c
> index 44905b82eea8..28b8f7b1af7c 100644
> --- a/io_uring/xattr.c
> +++ b/io_uring/xattr.c
> @@ -18,7 +18,7 @@
>  
>  struct io_xattr {
>  	struct file			*file;
> -	struct xattr_ctx		ctx;
> +	struct kernel_xattr_ctx		ctx;
>  	struct filename			*filename;
>  };
>  
> -- 
> 2.43.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

