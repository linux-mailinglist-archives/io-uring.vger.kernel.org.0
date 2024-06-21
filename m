Return-Path: <io-uring+bounces-2306-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 44A36911AB0
	for <lists+io-uring@lfdr.de>; Fri, 21 Jun 2024 07:56:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EE95C28335A
	for <lists+io-uring@lfdr.de>; Fri, 21 Jun 2024 05:56:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E17B0139CE5;
	Fri, 21 Jun 2024 05:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="EMMK1RfI";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="4L8kd9sl";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="EMMK1RfI";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="4L8kd9sl"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C1771369BB;
	Fri, 21 Jun 2024 05:56:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718949372; cv=none; b=uzbqjmvR/BzYAzMyY98JJ3ofXrBLF/FgRBJnecteLLydzRWgvZG5kZK+7RpSUQjj72Vy4uUZiPjhvfoNSZ4fAKQj5XpKWDO1f/A5Yt/kKaeJ18yEFRvKcXaKkpHYPVJNzBhETgrnRxhry4Ra0cvUp2YscmahZ5BidYNV7aIh+RU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718949372; c=relaxed/simple;
	bh=nunYsAPT5u4+SY+dfKlBWpXTDzBTFLCRvlpMwJeKB7g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=T4jTrScW8gD6hCB62jF+ZR524HxcCjyljyx8C+Y3+3utDpLh9VNiWLIycSq8Uq9uICopQnC0IkaFaPiI5VW9fZCBinoB4/ysb8I96ErMpAyA7/0bx5GCnZre3FbZpU+R1PSKqyL8yy2jUjnk+rv6BvJGQWD2vnCkHJY0D17mtF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=EMMK1RfI; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=4L8kd9sl; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=EMMK1RfI; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=4L8kd9sl; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 4A40D1FB51;
	Fri, 21 Jun 2024 05:56:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1718949369; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Tzs1uWbqYDjrVbt6j5jc0RX32zWwNTB/IuFKdea3/lk=;
	b=EMMK1RfIvC+AAjKvN1vCekL0/GtGFJ+n0cCaP9DBuqSREh5h4pZ8Pp5zcJ/qkSGksAgMuw
	IOVQFo+6fRYrIIGuyWvIpNS8Ye5+HZJGpqXQukgSZ05IErTyMGxjjsVO4k7262Yaj/sTxb
	/ij1hVOSvcg8Zl5iMR7yBRwyTf9OtLU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1718949369;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Tzs1uWbqYDjrVbt6j5jc0RX32zWwNTB/IuFKdea3/lk=;
	b=4L8kd9sl/Mdr03kr3F069mHEXM+zT1r18vc5GDFIUc6ljiV4C8m1g1wQ9mPmGswpS+0bd5
	GFjdp5bcTK7hu8BQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1718949369; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Tzs1uWbqYDjrVbt6j5jc0RX32zWwNTB/IuFKdea3/lk=;
	b=EMMK1RfIvC+AAjKvN1vCekL0/GtGFJ+n0cCaP9DBuqSREh5h4pZ8Pp5zcJ/qkSGksAgMuw
	IOVQFo+6fRYrIIGuyWvIpNS8Ye5+HZJGpqXQukgSZ05IErTyMGxjjsVO4k7262Yaj/sTxb
	/ij1hVOSvcg8Zl5iMR7yBRwyTf9OtLU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1718949369;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Tzs1uWbqYDjrVbt6j5jc0RX32zWwNTB/IuFKdea3/lk=;
	b=4L8kd9sl/Mdr03kr3F069mHEXM+zT1r18vc5GDFIUc6ljiV4C8m1g1wQ9mPmGswpS+0bd5
	GFjdp5bcTK7hu8BQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0A86413ABD;
	Fri, 21 Jun 2024 05:56:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id rKd1O/cVdWbQdwAAD6G6ig
	(envelope-from <hare@suse.de>); Fri, 21 Jun 2024 05:56:07 +0000
Message-ID: <373ec4bc-0919-47b1-bac1-55914c369e13@suse.de>
Date: Fri, 21 Jun 2024 07:56:06 +0200
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Patch v9 03/10] fs: Initial atomic write support
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
 <20240620125359.2684798-4-john.g.garry@oracle.com>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240620125359.2684798-4-john.g.garry@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -2.79
X-Spam-Level: 
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.79 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[31];
	TAGGED_RCPT(0.00)[];
	ARC_NA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	R_RATELIMIT(0.00)[to_ip_from(RLusjj3u5c53i6g8q6enupwtij)];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[kernel.org,vger.kernel.org,lists.infradead.org,mit.edu,google.com,linux.ibm.com,kvack.org,gmail.com,infradead.org,redhat.com,lists.linux.dev,oracle.com];
	MID_RHS_MATCH_FROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RCVD_COUNT_TWO(0.00)[2];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email]

On 6/20/24 14:53, John Garry wrote:
> From: Prasad Singamsetty <prasad.singamsetty@oracle.com>
> 
> An atomic write is a write issued with torn-write protection, meaning
> that for a power failure or any other hardware failure, all or none of the
> data from the write will be stored, but never a mix of old and new data.
> 
> Userspace may add flag RWF_ATOMIC to pwritev2() to indicate that the
> write is to be issued with torn-write prevention, according to special
> alignment and length rules.
> 
> For any syscall interface utilizing struct iocb, add IOCB_ATOMIC for
> iocb->ki_flags field to indicate the same.
> 
> A call to statx will give the relevant atomic write info for a file:
> - atomic_write_unit_min
> - atomic_write_unit_max
> - atomic_write_segments_max
> 
> Both min and max values must be a power-of-2.
> 
> Applications can avail of atomic write feature by ensuring that the total
> length of a write is a power-of-2 in size and also sized between
> atomic_write_unit_min and atomic_write_unit_max, inclusive. Applications
> must ensure that the write is at a naturally-aligned offset in the file
> wrt the total write length. The value in atomic_write_segments_max
> indicates the upper limit for IOV_ITER iovcnt.
> 
> Add file mode flag FMODE_CAN_ATOMIC_WRITE, so files which do not have the
> flag set will have RWF_ATOMIC rejected and not just ignored.
> 
> Add a type argument to kiocb_set_rw_flags() to allows reads which have
> RWF_ATOMIC set to be rejected.
> 
> Helper function generic_atomic_write_valid() can be used by FSes to verify
> compliant writes. There we check for iov_iter type is for ubuf, which
> implies iovcnt==1 for pwritev2(), which is an initial restriction for
> atomic_write_segments_max. Initially the only user will be bdev file
> operations write handler. We will rely on the block BIO submission path to
> ensure write sizes are compliant for the bdev, so we don't need to check
> atomic writes sizes yet.
> 
> Signed-off-by: Prasad Singamsetty <prasad.singamsetty@oracle.com>
> jpg: merge into single patch and much rewrite
> Acked-by: "Darrick J. Wong" <djwong@kernel.org>
> Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
> Signed-off-by: John Garry <john.g.garry@oracle.com>
> ---
>   fs/aio.c                |  8 ++++----
>   fs/btrfs/ioctl.c        |  2 +-
>   fs/read_write.c         | 18 +++++++++++++++++-
>   include/linux/fs.h      | 17 +++++++++++++++--
>   include/uapi/linux/fs.h |  5 ++++-
>   io_uring/rw.c           |  9 ++++-----
>   6 files changed, 45 insertions(+), 14 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich


