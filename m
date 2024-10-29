Return-Path: <io-uring+bounces-4153-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0AB949B5543
	for <lists+io-uring@lfdr.de>; Tue, 29 Oct 2024 22:51:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 94A5BB22303
	for <lists+io-uring@lfdr.de>; Tue, 29 Oct 2024 21:51:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C37DC1DEFFD;
	Tue, 29 Oct 2024 21:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="yfY9XSKs";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="8w7Y1yCe";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="yfY9XSKs";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="8w7Y1yCe"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00DF7194AD6;
	Tue, 29 Oct 2024 21:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730238685; cv=none; b=RuO0P6I3lYcn27/4jAI0+/LKma+/IWtqYRtht5ushlQ9c9u2+BMUZIwEp5uGvFKlsqeaKh1wswyz02Vk2duwulp1AJjoUUVSF1BEe3O31hI4p6uWfPpH5z+pgl+HKCTFQ9a3fyyMZOBlckM4BVltcIA7A9TTLSVqcZMuowE9nZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730238685; c=relaxed/simple;
	bh=8Uu1YgwSM9A9HIece66TROqs3TFvV8LqiKHIapaJNhk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SWJZzB2n+9pNnvhlaqkXdM8i0cjoUXh4kK+SJYq7/nqZ9glL5OvYqrPZ5uDLUDstFq35bDi0B6WCsuJHURn1WPL+qDteZulVUFLxdOk9njBxMuRW1y/ScVBuMiZGP4U4B4Qe7JuFOGsMWTlahfIjLqi2mONG71S2IOY/3wWIpQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=yfY9XSKs; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=8w7Y1yCe; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=yfY9XSKs; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=8w7Y1yCe; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 2421021EA7;
	Tue, 29 Oct 2024 21:51:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1730238681;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ErBlRuPZilid7W+V2PDj60AUsSW3rqYKe3JjGY5yH6o=;
	b=yfY9XSKsh9w5dt4V4dRWMiOnRukGMVUmZ4fojStBWJOfS7ICCwd9KyNw7rfI9B55Gsskk8
	DulfhAFpavbr023qzklhlqpdAvmEP+yg7cmPiXji1okwafAz0qtsCyMV8aCfllsSJcp95Z
	X+BNRZeL/SW+6eMgdC+3ErNw/sot8LE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1730238681;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ErBlRuPZilid7W+V2PDj60AUsSW3rqYKe3JjGY5yH6o=;
	b=8w7Y1yCeMUT4ZxmunL1ICUpLfrWosV/VQ8R5MENBOCktKJvBmLWeKGQGCW4U1mvxk+pPra
	LDcXsqzeJbDCdsDg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1730238681;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ErBlRuPZilid7W+V2PDj60AUsSW3rqYKe3JjGY5yH6o=;
	b=yfY9XSKsh9w5dt4V4dRWMiOnRukGMVUmZ4fojStBWJOfS7ICCwd9KyNw7rfI9B55Gsskk8
	DulfhAFpavbr023qzklhlqpdAvmEP+yg7cmPiXji1okwafAz0qtsCyMV8aCfllsSJcp95Z
	X+BNRZeL/SW+6eMgdC+3ErNw/sot8LE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1730238681;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ErBlRuPZilid7W+V2PDj60AUsSW3rqYKe3JjGY5yH6o=;
	b=8w7Y1yCeMUT4ZxmunL1ICUpLfrWosV/VQ8R5MENBOCktKJvBmLWeKGQGCW4U1mvxk+pPra
	LDcXsqzeJbDCdsDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 11426139A2;
	Tue, 29 Oct 2024 21:51:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id UEsHBNlYIWcheAAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Tue, 29 Oct 2024 21:51:21 +0000
Date: Tue, 29 Oct 2024 22:51:04 +0100
From: David Sterba <dsterba@suse.cz>
To: Mark Harmstone <maharmstone@fb.com>
Cc: linux-btrfs@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [PATCH 5/5] btrfs: add io_uring command for encoded reads
Message-ID: <20241029215104.GT31418@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20241022145024.1046883-1-maharmstone@fb.com>
 <20241022145024.1046883-6-maharmstone@fb.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241022145024.1046883-6-maharmstone@fb.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Score: -4.00
X-Spamd-Result: default: False [-4.00 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_TLS_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[twin.jikos.cz:mid,suse.cz:replyto,imap1.dmz-prg2.suse.org:helo];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[]
X-Spam-Flag: NO
X-Spam-Level: 

On Tue, Oct 22, 2024 at 03:50:20PM +0100, Mark Harmstone wrote:
> +static int btrfs_uring_encoded_read(struct io_uring_cmd *cmd,
> +				    unsigned int issue_flags)
> +{
> +	size_t copy_end_kernel = offsetofend(struct btrfs_ioctl_encoded_io_args,
> +					     flags);
> +	size_t copy_end;
> +	struct btrfs_ioctl_encoded_io_args args = { 0 };
> +	int ret;
> +	u64 disk_bytenr, disk_io_size;
> +	struct file *file = cmd->file;
> +	struct btrfs_inode *inode = BTRFS_I(file->f_inode);
> +	struct btrfs_fs_info *fs_info = inode->root->fs_info;
> +	struct extent_io_tree *io_tree = &inode->io_tree;
> +	struct iovec iovstack[UIO_FASTIOV];
> +	struct iovec *iov = iovstack;
> +	struct iov_iter iter;
> +	loff_t pos;
> +	struct kiocb kiocb;
> +	struct extent_state *cached_state = NULL;
> +	u64 start, lockend;
> +	void __user *sqe_addr = u64_to_user_ptr(READ_ONCE(cmd->sqe->addr));
> +
> +	if (!capable(CAP_SYS_ADMIN)) {
> +		ret = -EPERM;
> +		goto out_acct;
> +	}

Access level check must be done first before any data are read, in this
case cmd->file and sqe_addr. Fixed.

