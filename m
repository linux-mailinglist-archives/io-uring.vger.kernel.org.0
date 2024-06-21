Return-Path: <io-uring+bounces-2310-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3919F911B39
	for <lists+io-uring@lfdr.de>; Fri, 21 Jun 2024 08:16:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 754C5B2526B
	for <lists+io-uring@lfdr.de>; Fri, 21 Jun 2024 06:16:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EA09169399;
	Fri, 21 Jun 2024 06:13:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="FS2SMcKC";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="IXijYWjQ";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="fh4XyqMC";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="hDlCqEYm"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D55341422D6;
	Fri, 21 Jun 2024 06:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718950421; cv=none; b=ddFT4xj+ZuejYuD3RQIgAgNyXIqAUlhLNqdpMmMn9Bpabx5gY0uGPFsikOp+eJ5OmLThrJidfUz2SAqsslxzqGnjfna3X+fi0Ki8WlyuJ+ybqO2Jb3ODNptYI553AvnZjb7tKOGxFwqIgid/2vZeaGD6gztRn/KHp0nK4w/2kcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718950421; c=relaxed/simple;
	bh=H1yOHnnZomKfPCkKoE2Nl1Mv8caPKUYafiLXXNqWtwI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ljiPOjflbmxa7l9AOiM1RgEJ9doD8sCggUy6tx36mBCGFVSG/lsKoB2dT9+/dkRFAg/0EF9phZRK6dOm2n/JyDpOzE2oRkHrVurRSPg/9Y92R9foYTcnCuldSl80TkNNkrq/fniZKntT7Q0QmRNZxVhBakA7nS8bq7D8/oCHyHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=FS2SMcKC; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=IXijYWjQ; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=fh4XyqMC; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=hDlCqEYm; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id C4EA91F810;
	Fri, 21 Jun 2024 06:13:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1718950417; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=smsnvQ2BfnNUpQG0pyZzJeCK6vU4GpJ6PpSrfFohByU=;
	b=FS2SMcKCAXgnOW+jg4Adb411KsjfEwAXlNxgi+zL5DkOGH5K89qjqR+/Gasup5NZVKu2hb
	oYX4u7FYJ+uA8nRkT90qNOvxGnf7H0niw/EmucsPQEPdcjZgIcgKBHwwrOkx8begycf4xx
	97QPn5mR4ZOa+JtDZlAdBnWFdhavNY8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1718950417;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=smsnvQ2BfnNUpQG0pyZzJeCK6vU4GpJ6PpSrfFohByU=;
	b=IXijYWjQYh0hMzq3U+tSeat7YCzL+gLzUzA1OV7J0S09bSnLXpTWflX2KPgCdn+wUgJB/v
	gjMvh+9YwIHgtrCw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=fh4XyqMC;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=hDlCqEYm
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1718950416; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=smsnvQ2BfnNUpQG0pyZzJeCK6vU4GpJ6PpSrfFohByU=;
	b=fh4XyqMCrfxjPm7/L36T95rclUrwVjoTUYHlMLbnjdxrkiyxeK7tzsIbElltwNM8a0nFkR
	LAfHRP4AveOmZBdhgYWr1nD1v5Ure762HBiolyCEWARszFOeNj7GilB45T85iB9gson8XJ
	X3uOE91lk9NeOVpBTTWShs5JPxHNuoU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1718950416;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=smsnvQ2BfnNUpQG0pyZzJeCK6vU4GpJ6PpSrfFohByU=;
	b=hDlCqEYmVap8JO1fAzrmAkKf1bxlu3DS9YtB6aaKbD31Jkr2mnHw5VP+PU9kOHl50Y4ima
	1PsRC+FalamrcyCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8A1F213ABD;
	Fri, 21 Jun 2024 06:13:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id BGCxHw8adWbDfAAAD6G6ig
	(envelope-from <hare@suse.de>); Fri, 21 Jun 2024 06:13:35 +0000
Message-ID: <680ce641-729b-4150-b875-531a98657682@suse.de>
Date: Fri, 21 Jun 2024 08:13:34 +0200
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Patch v9 07/10] block: Add fops atomic write support
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
 snitzer@kernel.org, mpatocka@redhat.com, dm-devel@lists.linux.dev
References: <20240620125359.2684798-1-john.g.garry@oracle.com>
 <20240620125359.2684798-8-john.g.garry@oracle.com>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240620125359.2684798-8-john.g.garry@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C4EA91F810
X-Spam-Score: -3.00
X-Spam-Level: 
X-Spam-Flag: NO
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
	RCPT_COUNT_TWELVE(0.00)[30];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[kernel.org,vger.kernel.org,lists.infradead.org,mit.edu,google.com,linux.ibm.com,kvack.org,gmail.com,infradead.org,redhat.com,lists.linux.dev];
	RCVD_TLS_ALL(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TAGGED_RCPT(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:email,suse.de:dkim,oracle.com:email]
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org

On 6/20/24 14:53, John Garry wrote:
> Support atomic writes by submitting a single BIO with the REQ_ATOMIC set.
> 
> It must be ensured that the atomic write adheres to its rules, like
> naturally aligned offset, so call blkdev_dio_invalid() ->
> blkdev_atomic_write_valid() [with renaming blkdev_dio_unaligned() to
> blkdev_dio_invalid()] for this purpose. The BIO submission path currently
> checks for atomic writes which are too large, so no need to check here.
> 
> In blkdev_direct_IO(), if the nr_pages exceeds BIO_MAX_VECS, then we cannot
> produce a single BIO, so error in this case.
> 
> Finally set FMODE_CAN_ATOMIC_WRITE when the bdev can support atomic writes
> and the associated file flag is for O_DIRECT.
> 
> Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
> Signed-off-by: John Garry <john.g.garry@oracle.com>
> ---
>   block/fops.c | 20 +++++++++++++++++---
>   1 file changed, 17 insertions(+), 3 deletions(-)
> 
> diff --git a/block/fops.c b/block/fops.c
> index 376265935714..be36c9fbd500 100644
> --- a/block/fops.c
> +++ b/block/fops.c
> @@ -34,9 +34,12 @@ static blk_opf_t dio_bio_write_op(struct kiocb *iocb)
>   	return opf;
>   }
>   
> -static bool blkdev_dio_unaligned(struct block_device *bdev, loff_t pos,
> -			      struct iov_iter *iter)
> +static bool blkdev_dio_invalid(struct block_device *bdev, loff_t pos,
> +				struct iov_iter *iter, bool is_atomic)
>   {
> +	if (is_atomic && !generic_atomic_write_valid(iter, pos))
> +		return true;
> +
>   	return pos & (bdev_logical_block_size(bdev) - 1) ||
>   		!bdev_iter_is_aligned(bdev, iter);
>   }
> @@ -72,6 +75,8 @@ static ssize_t __blkdev_direct_IO_simple(struct kiocb *iocb,
>   	bio.bi_iter.bi_sector = pos >> SECTOR_SHIFT;
>   	bio.bi_write_hint = file_inode(iocb->ki_filp)->i_write_hint;
>   	bio.bi_ioprio = iocb->ki_ioprio;
> +	if (iocb->ki_flags & IOCB_ATOMIC)
> +		bio.bi_opf |= REQ_ATOMIC;
>   
>   	ret = bio_iov_iter_get_pages(&bio, iter);
>   	if (unlikely(ret))
> @@ -343,6 +348,9 @@ static ssize_t __blkdev_direct_IO_async(struct kiocb *iocb,
>   		task_io_account_write(bio->bi_iter.bi_size);
>   	}
>   
> +	if (iocb->ki_flags & IOCB_ATOMIC)
> +		bio->bi_opf |= REQ_ATOMIC;
> +
>   	if (iocb->ki_flags & IOCB_NOWAIT)
>   		bio->bi_opf |= REQ_NOWAIT;
>   
> @@ -359,12 +367,13 @@ static ssize_t __blkdev_direct_IO_async(struct kiocb *iocb,
>   static ssize_t blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
>   {
>   	struct block_device *bdev = I_BDEV(iocb->ki_filp->f_mapping->host);
> +	bool is_atomic = iocb->ki_flags & IOCB_ATOMIC;
>   	unsigned int nr_pages;
>   
>   	if (!iov_iter_count(iter))
>   		return 0;
>   
> -	if (blkdev_dio_unaligned(bdev, iocb->ki_pos, iter))
> +	if (blkdev_dio_invalid(bdev, iocb->ki_pos, iter, is_atomic))

Why not passing in iocb->ki_flags here?
Or, indeed, the entire iocb?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich


