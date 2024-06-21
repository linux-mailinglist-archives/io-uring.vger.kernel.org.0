Return-Path: <io-uring+bounces-2307-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5716F911AC1
	for <lists+io-uring@lfdr.de>; Fri, 21 Jun 2024 07:57:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D569C1F231B4
	for <lists+io-uring@lfdr.de>; Fri, 21 Jun 2024 05:57:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98C1315532C;
	Fri, 21 Jun 2024 05:57:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="LST7QCSb";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="fBAhZOpA";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="LST7QCSb";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="fBAhZOpA"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 374C1145B0C;
	Fri, 21 Jun 2024 05:57:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718949439; cv=none; b=GeAxyeJlbRYELXQCCcP5MpF/05Nvt1oKfxgdag1MrMygmUEhv/faOE6iGrTXBAEE8MiHZSsqX7BLfehwUJOLoU+HoVDxgCl3bciKv0CqcWGGuFwJKK9mbgg9jBemXsVtPii3NLUDiB3SdzPw8msyCeKo+FL0J2eKszb9KwNUJ7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718949439; c=relaxed/simple;
	bh=3FWLKn5K0ErXbmILXLs7fPFfTTMmVZpYKy3ZAHE0lwo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=J2P0z+C8F7xUpDnFycvhN7o3uzQzFQZvUJRYi+9+Op6PP/+ENQA81QIcS+aMloz0LuwXCVuAbNGKm39IqXuRnDQzUfYbY2izbsq+8bFdxRcyJBdEkJeMiX3txVb/BCt8iKXYPN0vwdbvjh+V93p4aHFa5x3M8VgTwFGCadJD/RA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=LST7QCSb; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=fBAhZOpA; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=LST7QCSb; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=fBAhZOpA; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1FD93218A9;
	Fri, 21 Jun 2024 05:57:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1718949435; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ovA3ypUckpMqn6TngarvdeHZiDhWZvd9lW6hu/f/h50=;
	b=LST7QCSb7TkDwPKJWWGHQcU2UG4DhgT/qHNkO0UkPt2wGHfZljzx4sIYLZ7i6GWwOI0I1l
	UM6OKzji9goj2c1PXl5eyWdacmynHSvBNiH8BjK3ZIGd8sZmgYt/7xcg1MN7z3L4sCk2vV
	jK8C0Ab3+KCfzg5qIRBOjKIgID69C3k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1718949435;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ovA3ypUckpMqn6TngarvdeHZiDhWZvd9lW6hu/f/h50=;
	b=fBAhZOpAHbJyBe46vhab2QmnLRO8DCfEgVSATCl66PSKELbUYChrOaNIfgpb24yFdOch6S
	yzHBHGiI1UNsn4BA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=LST7QCSb;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=fBAhZOpA
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1718949435; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ovA3ypUckpMqn6TngarvdeHZiDhWZvd9lW6hu/f/h50=;
	b=LST7QCSb7TkDwPKJWWGHQcU2UG4DhgT/qHNkO0UkPt2wGHfZljzx4sIYLZ7i6GWwOI0I1l
	UM6OKzji9goj2c1PXl5eyWdacmynHSvBNiH8BjK3ZIGd8sZmgYt/7xcg1MN7z3L4sCk2vV
	jK8C0Ab3+KCfzg5qIRBOjKIgID69C3k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1718949435;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ovA3ypUckpMqn6TngarvdeHZiDhWZvd9lW6hu/f/h50=;
	b=fBAhZOpAHbJyBe46vhab2QmnLRO8DCfEgVSATCl66PSKELbUYChrOaNIfgpb24yFdOch6S
	yzHBHGiI1UNsn4BA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2D8FD13ABD;
	Fri, 21 Jun 2024 05:57:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id uGJ9CDkWdWbQdwAAD6G6ig
	(envelope-from <hare@suse.de>); Fri, 21 Jun 2024 05:57:13 +0000
Message-ID: <9c41e336-7918-4b4a-bafe-40ec80397cb3@suse.de>
Date: Fri, 21 Jun 2024 07:57:12 +0200
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Patch v9 04/10] fs: Add initial atomic write support info to
 statx
Content-Language: en-US
To: John Garry <john.g.garry@oracle.com>, axboe@kernel.dk, kbusch@kernel.org,
 hch@lst.de, sagi@grimberg.me, jejb@linux.ibm.com,
 martin.petersen@oracle.com, viro@zeniv.linux.org.uk, brauner@kernel.org,
 dchinner@redhat.com, jack@suse.cz
Cc: djwong@kernel.org, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-fsdevel@vger.kernel.org, tytso@mit.edu, jbongio@google.com,
 linux-scsi@vger.kernel.org, ojaswin@linux.ibm.com, linux-aio@kvack.org,
 linux-btrfs@vger.kernel.org, io-uring@vger.kernel.org, nilay@linux.ibm.com,
 ritesh.list@gmail.com, willy@infradead.org, agk@redhat.com,
 snitzer@kernel.org, mpatocka@redhat.com, dm-devel@lists.linux.dev,
 Prasad Singamsetty <prasad.singamsetty@oracle.com>
References: <20240620125359.2684798-1-john.g.garry@oracle.com>
 <20240620125359.2684798-5-john.g.garry@oracle.com>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240620125359.2684798-5-john.g.garry@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-3.00 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	XM_UA_NO_VERSION(0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	ARC_NA(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RCPT_COUNT_TWELVE(0.00)[31];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[kernel.org,vger.kernel.org,lists.infradead.org,mit.edu,google.com,linux.ibm.com,kvack.org,gmail.com,infradead.org,redhat.com,lists.linux.dev,oracle.com];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	R_RATELIMIT(0.00)[to_ip_from(RL7q43nzpr7is614unuocxbefr)];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:dkim]
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 1FD93218A9
X-Spam-Flag: NO
X-Spam-Score: -3.00
X-Spam-Level: 

On 6/20/24 14:53, John Garry wrote:
> From: Prasad Singamsetty <prasad.singamsetty@oracle.com>
> 
> Extend statx system call to return additional info for atomic write support
> support for a file.
> 
> Helper function generic_fill_statx_atomic_writes() can be used by FSes to
> fill in the relevant statx fields. For now atomic_write_segments_max will
> always be 1, otherwise some rules would need to be imposed on iovec length
> and alignment, which we don't want now.
> 
> Signed-off-by: Prasad Singamsetty <prasad.singamsetty@oracle.com>
> jpg: relocate bdev support to another patch
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
> Signed-off-by: John Garry <john.g.garry@oracle.com>
> ---
>   fs/stat.c                 | 34 ++++++++++++++++++++++++++++++++++
>   include/linux/fs.h        |  3 +++
>   include/linux/stat.h      |  3 +++
>   include/uapi/linux/stat.h | 12 ++++++++++--
>   4 files changed, 50 insertions(+), 2 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich


