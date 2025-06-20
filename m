Return-Path: <io-uring+bounces-8441-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E145AE1F63
	for <lists+io-uring@lfdr.de>; Fri, 20 Jun 2025 17:50:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3D7234C2AD1
	for <lists+io-uring@lfdr.de>; Fri, 20 Jun 2025 15:49:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FDE82E716B;
	Fri, 20 Jun 2025 15:47:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="OY4QPDGE";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="OA1nHk4N";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="OY4QPDGE";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="OA1nHk4N"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F157B2D3A86
	for <io-uring@vger.kernel.org>; Fri, 20 Jun 2025 15:47:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750434468; cv=none; b=utaGxDZFcB/BhMF2MorNineMO203IycVMMOyyfr71Iay2wBot5q1mIwZs5iTaJVS147FfmnUPeCJoSFI8B/gGwCbLvpkSBRG+JGIsoVucogrBJDjWnK6S9siC2w3jgl5M//YIIvLCDtra4+zhI8jpqr84XuvfwqrlwqnG2L7u9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750434468; c=relaxed/simple;
	bh=eMGC5Ax1af3GV4qbwjp8a8GGUC5Nhvn9YI171BLAqds=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=spK1qhgBSFDdd3XuUJ76HrwAFofiPIBqxmydrHcLhgDfwz2+ZUDu1oYh2pKKZovoCvqA0WZ2oUNojTX/KMjkYjkTzo9TpTXe3Ql/7FD2ErHCM7fcuYrRtwka1/fPfRehLeSPiJrlVu7VlsrN7m4Je3DtE6IuCSj2IAswRwDNExM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=OY4QPDGE; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=OA1nHk4N; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=OY4QPDGE; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=OA1nHk4N; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 4A4411F38D;
	Fri, 20 Jun 2025 15:47:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1750434465;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jb4rmzCBy2JbwhbSe1U00gQREDjOVt6Lc3XN3bwP9Eg=;
	b=OY4QPDGEDmD1mjpSUfxgQF9dRz0+RmTiFM0YBezqiBiVP/h+fad6RL/NKIq5/uN3TlqoxF
	2rDcKUc8QmoJ4VAqohWdbSZ+TMpHtQLtbx58L4x8FG+/MkRboprcKOOXAn02Fs9BJPLBdS
	QaR1E9d7okOCGlnvwaxqrxNlgs8LuZM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1750434465;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jb4rmzCBy2JbwhbSe1U00gQREDjOVt6Lc3XN3bwP9Eg=;
	b=OA1nHk4NQy+b6Sd2iYbdFO+su7/TkYvinaDaqefaxibMSqckDDxhy/UcEGCRyS0CHanwY4
	RGB67sCFNhA4//Dg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1750434465;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jb4rmzCBy2JbwhbSe1U00gQREDjOVt6Lc3XN3bwP9Eg=;
	b=OY4QPDGEDmD1mjpSUfxgQF9dRz0+RmTiFM0YBezqiBiVP/h+fad6RL/NKIq5/uN3TlqoxF
	2rDcKUc8QmoJ4VAqohWdbSZ+TMpHtQLtbx58L4x8FG+/MkRboprcKOOXAn02Fs9BJPLBdS
	QaR1E9d7okOCGlnvwaxqrxNlgs8LuZM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1750434465;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jb4rmzCBy2JbwhbSe1U00gQREDjOVt6Lc3XN3bwP9Eg=;
	b=OA1nHk4NQy+b6Sd2iYbdFO+su7/TkYvinaDaqefaxibMSqckDDxhy/UcEGCRyS0CHanwY4
	RGB67sCFNhA4//Dg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 23C9713736;
	Fri, 20 Jun 2025 15:47:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 67OFCKGCVWgoZQAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Fri, 20 Jun 2025 15:47:45 +0000
Date: Fri, 20 Jun 2025 17:47:43 +0200
From: David Sterba <dsterba@suse.cz>
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
	David Sterba <dsterba@suse.com>, Jens Axboe <axboe@kernel.dk>,
	Mark Harmstone <maharmstone@fb.com>, linux-btrfs@vger.kernel.org,
	io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] io_uring/btrfs: remove struct io_uring_cmd_data
Message-ID: <20250620154743.GY4037@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20250619192748.3602122-1-csander@purestorage.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250619192748.3602122-1-csander@purestorage.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Flag: NO
X-Spam-Score: -4.00
X-Spamd-Result: default: False [-4.00 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FROM_HAS_DN(0.00)[];
	URIBL_BLOCKED(0.00)[suse.cz:replyto,imap1.dmz-prg2.suse.org:helo,twin.jikos.cz:mid];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[9];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:replyto,imap1.dmz-prg2.suse.org:helo]
X-Spam-Level: 

On Thu, Jun 19, 2025 at 01:27:44PM -0600, Caleb Sander Mateos wrote:
> btrfs's ->uring_cmd() implementations are the only ones using io_uring_cmd_data
> to store data that lasts for the lifetime of the uring_cmd. But all uring_cmds
> have to pay the memory and CPU cost of initializing this field and freeing the
> pointer if necessary when the uring_cmd ends. There is already a pdu field in
> struct io_uring_cmd that ->uring_cmd() implementations can use for storage. The
> only benefit of op_data seems to be that io_uring initializes it, so
> ->uring_cmd() can read it to tell if there was a previous call to ->uring_cmd().
> 
> Introduce a flag IORING_URING_CMD_REISSUE that ->uring_cmd() implementations can
> use to tell if this is the first call to ->uring_cmd() or a reissue of the
> uring_cmd. Switch btrfs to use the pdu storage for its btrfs_uring_encoded_data.
> If IORING_URING_CMD_REISSUE is unset, allocate a new btrfs_uring_encoded_data.
> If it's set, use the existing one in op_data. Free the btrfs_uring_encoded_data
> in the btrfs layer instead of relying on io_uring to free op_data. Finally,
> remove io_uring_cmd_data since it's now unused.
> 
> Caleb Sander Mateos (4):
>   btrfs/ioctl: don't skip accounting in early ENOTTY return
>   io_uring/cmd: introduce IORING_URING_CMD_REISSUE flag
>   btrfs/ioctl: store btrfs_uring_encoded_data in io_btrfs_cmd
>   io_uring/cmd: remove struct io_uring_cmd_data

The first patch is a fix so it can be put to a -rc queue.

The rest change the io_uring logic, so it's not up to me, but regarding
how to merge them either via btrfs or io_uring tree work for me.

