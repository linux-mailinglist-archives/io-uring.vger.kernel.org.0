Return-Path: <io-uring+bounces-2300-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A96DD9107B9
	for <lists+io-uring@lfdr.de>; Thu, 20 Jun 2024 16:14:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CB0931C210FF
	for <lists+io-uring@lfdr.de>; Thu, 20 Jun 2024 14:14:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 510531AD9C2;
	Thu, 20 Jun 2024 14:14:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="TYieyEJp";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="ql8zx4GC";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="TYieyEJp";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="ql8zx4GC"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BCDA1AB91B;
	Thu, 20 Jun 2024 14:14:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718892856; cv=none; b=Ja2zydANi4O/u9TIOaPjk4rUHRiF1QFTHcHyUJqNGj8AfN/b4puP/zFEsAujbJLbvUGw7ZzXj+OaCtq2joV0DDs0Tl04I9JYU/fFtMa/LkQUWAha0mL5/nR0SE3ekCJw0yh1pMK/rFBcpZVzam5eu/EB9vNm9AQU9tRCkzUE+XM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718892856; c=relaxed/simple;
	bh=DPp863t6Iv2CN9gXF2rMAItgxwljmraSFPCSsQe+Yfc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tGei7yl4H10INxe2Y9p6b+BUml7wZJk/PTlnd73CxU9EUOskd7y1MZ8PZrEE1Y1f+lsiLa8Kz+p1h4xyB8RVCZkfv/tyCn5/eNHjE7hiLOJUs/NOjn/EHCQWYBshk7baOWzSNZ8ablDvIvwp2oXz0yLCDW8uREPZdy56HX6VHU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=TYieyEJp; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=ql8zx4GC; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=TYieyEJp; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=ql8zx4GC; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 227FE1F8AA;
	Thu, 20 Jun 2024 14:14:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1718892852; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=W/VduWasdKCSLgKbJulCui0AKbISjLYU9oRgLacKJWk=;
	b=TYieyEJpcEliHFGUMOjVwd2MsHeTEJpl64iglSHvfZ5OZA0NbvyZ5bFjw3sVu98BxMeLfo
	X+4Y/mvXnRL7U8eOaEoMw2oDdybBRz0U2tIyZ8EGVJgmPZng6sdYCyAYKNvWXizhZPbPOC
	Q5/ZDx3q9VA6KEoS3xlzjy5Mj2BdhRo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1718892852;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=W/VduWasdKCSLgKbJulCui0AKbISjLYU9oRgLacKJWk=;
	b=ql8zx4GCDwPNmZBIEXu9VK0shr3zENQYJCB5gUg+QsV3semzmKkRj0Hq9/W7ouLeCyoCRO
	gCf4QDU3fx0VO9Bw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=TYieyEJp;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ql8zx4GC
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1718892852; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=W/VduWasdKCSLgKbJulCui0AKbISjLYU9oRgLacKJWk=;
	b=TYieyEJpcEliHFGUMOjVwd2MsHeTEJpl64iglSHvfZ5OZA0NbvyZ5bFjw3sVu98BxMeLfo
	X+4Y/mvXnRL7U8eOaEoMw2oDdybBRz0U2tIyZ8EGVJgmPZng6sdYCyAYKNvWXizhZPbPOC
	Q5/ZDx3q9VA6KEoS3xlzjy5Mj2BdhRo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1718892852;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=W/VduWasdKCSLgKbJulCui0AKbISjLYU9oRgLacKJWk=;
	b=ql8zx4GCDwPNmZBIEXu9VK0shr3zENQYJCB5gUg+QsV3semzmKkRj0Hq9/W7ouLeCyoCRO
	gCf4QDU3fx0VO9Bw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 35EA113AC1;
	Thu, 20 Jun 2024 14:14:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id MI3SBjI5dGZwWgAAD6G6ig
	(envelope-from <hare@suse.de>); Thu, 20 Jun 2024 14:14:10 +0000
Message-ID: <4be6fe89-c972-4bf9-9d5f-84614c1c5792@suse.de>
Date: Thu, 20 Jun 2024 16:14:09 +0200
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Patch v9 02/10] block: Generalize chunk_sectors support as
 boundary support
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
 <20240620125359.2684798-3-john.g.garry@oracle.com>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240620125359.2684798-3-john.g.garry@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-3.00 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[30];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[kernel.org,vger.kernel.org,lists.infradead.org,mit.edu,google.com,linux.ibm.com,kvack.org,gmail.com,infradead.org,redhat.com,lists.linux.dev];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	MID_RHS_MATCH_FROM(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	R_RATELIMIT(0.00)[to_ip_from(RL7q43nzpr7is614unuocxbefr)];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:email,suse.de:dkim]
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 227FE1F8AA
X-Spam-Flag: NO
X-Spam-Score: -3.00
X-Spam-Level: 

On 6/20/24 14:53, John Garry wrote:
> The purpose of the chunk_sectors limit is to ensure that a mergeble request
> fits within the boundary of the chunck_sector value.
> 
> Such a feature will be useful for other request_queue boundary limits, so
> generalize the chunk_sectors merge code.
> 
> This idea was proposed by Hannes Reinecke.
> 
> Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
> Signed-off-by: John Garry <john.g.garry@oracle.com>
> ---
>   block/blk-merge.c      | 20 ++++++++++++++------
>   drivers/md/dm.c        |  2 +-
>   include/linux/blkdev.h | 13 +++++++------
>   3 files changed, 22 insertions(+), 13 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich


