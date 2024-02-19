Return-Path: <io-uring+bounces-639-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 1FA2485ABDE
	for <lists+io-uring@lfdr.de>; Mon, 19 Feb 2024 20:17:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E4895B2181F
	for <lists+io-uring@lfdr.de>; Mon, 19 Feb 2024 19:17:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 052EE50A72;
	Mon, 19 Feb 2024 19:17:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="L+vMdNx5";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="s7FAO35e";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="L+vMdNx5";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="s7FAO35e"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 277FE5026E;
	Mon, 19 Feb 2024 19:17:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708370242; cv=none; b=EuuZK7hDt8/a6fztLghV0ppviae0JfjjYv4xV20lCmjj/5xnSpOSYMDYRqaD/I5IrwAV7ycLeh0qAXyZ8TjdxgW8jeBGWjeq9QpB47yQ9JU6xJKv/0SD6ofwHiFjkfeoSbWwvfr/tGYt4tk6WnBlca7bzbgJrULcSI/u9jP+d3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708370242; c=relaxed/simple;
	bh=sRfczU3h38e9XwnW/0H/0VrVNL08337uFZQFx5xcBrg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uvFdRoSfwXKhsZCpsa/22r1ZD0Z0voSXhBbmsHQk1yvG8gifli5AG8aM+FhtYaeoKOXUQ+wANE0u9bICbetqmM6ChI2pMrgpWUJiPRgojDhOlNYu6N6XTojoMjCN40772wwLlKa3u5QV+Zo+g6vs5Fb/08S++W0SQ86nhmvrpfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=L+vMdNx5; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=s7FAO35e; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=L+vMdNx5; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=s7FAO35e; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap2.dmz-prg2.suse.org (imap2.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:98])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 345AF21CDF;
	Mon, 19 Feb 2024 19:17:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1708370239;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hP0JzOSxa8Ak34PkLlYrH+BW+BeCI1kfUuoJPW8HusA=;
	b=L+vMdNx52tHJkwchBcBa001qK+SZbtkZ0/HROkYFTpK0Mp6T669V9VwOkeXDQTpQ2fHujp
	itj6yObR2GSzdmVyzY6nN++Gzw11Xb9rJnuhobwQBRoOg7xeCeTWPpEjTMyFFVrVdH1zO/
	QWJf0rogCt/jib7V0aowiiggrz/iFOo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1708370239;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hP0JzOSxa8Ak34PkLlYrH+BW+BeCI1kfUuoJPW8HusA=;
	b=s7FAO35emUqsBT78ndugZlEtb/uTp91WcAJqAHeiXy2r8Or+q1xNYrwiD46+AOf7djzZ9L
	PZKkia9ha8+FKbAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1708370239;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hP0JzOSxa8Ak34PkLlYrH+BW+BeCI1kfUuoJPW8HusA=;
	b=L+vMdNx52tHJkwchBcBa001qK+SZbtkZ0/HROkYFTpK0Mp6T669V9VwOkeXDQTpQ2fHujp
	itj6yObR2GSzdmVyzY6nN++Gzw11Xb9rJnuhobwQBRoOg7xeCeTWPpEjTMyFFVrVdH1zO/
	QWJf0rogCt/jib7V0aowiiggrz/iFOo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1708370239;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hP0JzOSxa8Ak34PkLlYrH+BW+BeCI1kfUuoJPW8HusA=;
	b=s7FAO35emUqsBT78ndugZlEtb/uTp91WcAJqAHeiXy2r8Or+q1xNYrwiD46+AOf7djzZ9L
	PZKkia9ha8+FKbAg==
Received: from imap2.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap2.dmz-prg2.suse.org (Postfix) with ESMTPS id 0B3F5139C6;
	Mon, 19 Feb 2024 19:17:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap2.dmz-prg2.suse.org with ESMTPSA
	id ciGVAj+p02UMUgAAn2gu4w
	(envelope-from <dsterba@suse.cz>); Mon, 19 Feb 2024 19:17:19 +0000
Date: Mon, 19 Feb 2024 20:16:34 +0100
From: David Sterba <dsterba@suse.cz>
To: John Garry <john.g.garry@oracle.com>
Cc: axboe@kernel.dk, kbusch@kernel.org, hch@lst.de, sagi@grimberg.me,
	jejb@linux.ibm.com, martin.petersen@oracle.com, djwong@kernel.org,
	viro@zeniv.linux.org.uk, brauner@kernel.org, dchinner@redhat.com,
	jack@suse.cz, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-fsdevel@vger.kernel.org, tytso@mit.edu, jbongio@google.com,
	linux-scsi@vger.kernel.org, ojaswin@linux.ibm.com,
	linux-aio@kvack.org, linux-btrfs@vger.kernel.org,
	io-uring@vger.kernel.org, nilay@linux.ibm.com,
	ritesh.list@gmail.com,
	Prasad Singamsetty <prasad.singamsetty@oracle.com>
Subject: Re: [PATCH v4 03/11] fs: Initial atomic write support
Message-ID: <20240219191634.GY355@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20240219130109.341523-1-john.g.garry@oracle.com>
 <20240219130109.341523-4-john.g.garry@oracle.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240219130109.341523-4-john.g.garry@oracle.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Level: 
X-Spamd-Bar: /
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=L+vMdNx5;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=s7FAO35e
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-0.26 / 50.00];
	 HAS_REPLYTO(0.30)[dsterba@suse.cz];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:98:from];
	 TO_DN_SOME(0.00)[];
	 REPLYTO_ADDR_EQ_FROM(0.00)[];
	 R_RATELIMIT(0.00)[to_ip_from(RLpoxz4e4fx16srn3jiqdcgp9j)];
	 RCVD_COUNT_THREE(0.00)[3];
	 DKIM_TRACE(0.00)[suse.cz:+];
	 MX_GOOD(-0.01)[];
	 NEURAL_HAM_SHORT(-0.20)[-1.000];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 BAYES_HAM(-0.55)[80.88%];
	 ARC_NA(0.00)[];
	 R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	 FROM_HAS_DN(0.00)[];
	 FREEMAIL_ENVRCPT(0.00)[gmail.com];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 TAGGED_RCPT(0.00)[];
	 MIME_GOOD(-0.10)[text/plain];
	 NEURAL_HAM_LONG(-1.00)[-1.000];
	 DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	 RCPT_COUNT_TWELVE(0.00)[26];
	 DBL_BLOCKED_OPENRESOLVER(0.00)[oracle.com:email,suse.cz:dkim];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FREEMAIL_CC(0.00)[kernel.dk,kernel.org,lst.de,grimberg.me,linux.ibm.com,oracle.com,zeniv.linux.org.uk,redhat.com,suse.cz,vger.kernel.org,lists.infradead.org,mit.edu,google.com,kvack.org,gmail.com];
	 RCVD_TLS_ALL(0.00)[];
	 SUSPICIOUS_RECIPS(1.50)[]
X-Spam-Score: -0.26
X-Rspamd-Queue-Id: 345AF21CDF
X-Spam-Flag: NO

On Mon, Feb 19, 2024 at 01:01:01PM +0000, John Garry wrote:
> From: Prasad Singamsetty <prasad.singamsetty@oracle.com>
> --- a/include/uapi/linux/fs.h
> +++ b/include/uapi/linux/fs.h
> @@ -301,9 +301,12 @@ typedef int __bitwise __kernel_rwf_t;
>  /* per-IO O_APPEND */
>  #define RWF_APPEND	((__force __kernel_rwf_t)0x00000010)
>  
> +/* Atomic Write */
> +#define RWF_ATOMIC	((__force __kernel_rwf_t)0x00000040)

Should this be 0x20 so it's the next bit after RWF_APPEND?

