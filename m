Return-Path: <io-uring+bounces-2311-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 40D9F911B40
	for <lists+io-uring@lfdr.de>; Fri, 21 Jun 2024 08:17:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 636B01C20CFE
	for <lists+io-uring@lfdr.de>; Fri, 21 Jun 2024 06:17:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE7EA145B0C;
	Fri, 21 Jun 2024 06:15:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="x/1gyrsn";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="kcu4ZCT/";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="x/1gyrsn";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="kcu4ZCT/"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0323412F37F;
	Fri, 21 Jun 2024 06:15:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718950519; cv=none; b=NrZZXrWjsJlIi2FUgiX9k0qDO3XQERKVVVlljCjvoooTJaFjVrfosd9e3rzGQqagSkTycDzIJt0kFKuR+vtzez8LqZYWq1UJvejst8C3fJK/wHAkw3BCj4h90QFXDqBTlov85O/h1MZuuIA1HdeWWNBZPlkCBViW8PWYs2GdGsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718950519; c=relaxed/simple;
	bh=4czXBaAPhOadGKf9K8vtEAosC11pMdWactxubBgYbC8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YaqChylmBmA27e6gz0m66jeFChojykwqZj3oVmVjzP5nZd4VYl9ZyvbJ7Nuvt5Lty47fCT58pI2E+imoE0J/D8gXHPwfyscdDEzUxBSkNYDXmdCtnQGPG9YJB2fcXNqJvHVDoudbQ73f1QVTVcNTxy28/ICDgsfAwptYu2GvvgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=x/1gyrsn; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=kcu4ZCT/; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=x/1gyrsn; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=kcu4ZCT/; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 16A5621AA0;
	Fri, 21 Jun 2024 06:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1718950516; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=T9pLbvVp9iNJqGnH9A9tB391ZJFpNojG1aoYIyI8cJg=;
	b=x/1gyrsnJA7sy2uKZyw1w06HE7B+zo0RQ5RWUr71XxciXfSKUTUs34b1vHgNmtJfTCr+8n
	Ji/ABVCjg7SEMCKtafmLBNsGgie0Nf0wAt6qRxGf71S2xsroPcOEzgZZawBTCQ2VVbB0rW
	roL+pErZQa/hcBeonn6sBOX2k/sgGEs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1718950516;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=T9pLbvVp9iNJqGnH9A9tB391ZJFpNojG1aoYIyI8cJg=;
	b=kcu4ZCT/PFBBH0vbt9tds5bCktjxqcc+NTQ8T935wK7diAzGxBHRXynZ8FZu38z0opeNu4
	ruXhw45AMtZMWiBQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="x/1gyrsn";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="kcu4ZCT/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1718950516; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=T9pLbvVp9iNJqGnH9A9tB391ZJFpNojG1aoYIyI8cJg=;
	b=x/1gyrsnJA7sy2uKZyw1w06HE7B+zo0RQ5RWUr71XxciXfSKUTUs34b1vHgNmtJfTCr+8n
	Ji/ABVCjg7SEMCKtafmLBNsGgie0Nf0wAt6qRxGf71S2xsroPcOEzgZZawBTCQ2VVbB0rW
	roL+pErZQa/hcBeonn6sBOX2k/sgGEs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1718950516;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=T9pLbvVp9iNJqGnH9A9tB391ZJFpNojG1aoYIyI8cJg=;
	b=kcu4ZCT/PFBBH0vbt9tds5bCktjxqcc+NTQ8T935wK7diAzGxBHRXynZ8FZu38z0opeNu4
	ruXhw45AMtZMWiBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E05A913ABD;
	Fri, 21 Jun 2024 06:15:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 4CmoNHIadWbDfAAAD6G6ig
	(envelope-from <hare@suse.de>); Fri, 21 Jun 2024 06:15:14 +0000
Message-ID: <a6867ed2-53e2-41ef-a668-6a031b52e5a5@suse.de>
Date: Fri, 21 Jun 2024 08:15:14 +0200
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Patch v9 08/10] scsi: sd: Atomic write support
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
 <20240620125359.2684798-9-john.g.garry@oracle.com>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240620125359.2684798-9-john.g.garry@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 16A5621AA0
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
	XM_UA_NO_VERSION(0.01)[];
	MX_GOOD(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[30];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[kernel.org,vger.kernel.org,lists.infradead.org,mit.edu,google.com,linux.ibm.com,kvack.org,gmail.com,infradead.org,redhat.com,lists.linux.dev];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[oracle.com:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:email,suse.de:dkim]
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org

On 6/20/24 14:53, John Garry wrote:
> Support is divided into two main areas:
> - reading VPD pages and setting sdev request_queue limits
> - support WRITE ATOMIC (16) command and tracing
> 
> The relevant block limits VPD page need to be read to allow the block layer
> request_queue atomic write limits to be set. These VPD page limits are
> described in sbc4r22 section 6.6.4 - Block limits VPD page.
> 
> There are five limits of interest:
> - MAXIMUM ATOMIC TRANSFER LENGTH
> - ATOMIC ALIGNMENT
> - ATOMIC TRANSFER LENGTH GRANULARITY
> - MAXIMUM ATOMIC TRANSFER LENGTH WITH BOUNDARY
> - MAXIMUM ATOMIC BOUNDARY SIZE
> 
> MAXIMUM ATOMIC TRANSFER LENGTH is the maximum length for a WRITE ATOMIC
> (16) command. It will not be greater than the device MAXIMUM TRANSFER
> LENGTH.
> 
> ATOMIC ALIGNMENT and ATOMIC TRANSFER LENGTH GRANULARITY are the minimum
> alignment and length values for an atomic write in terms of logical blocks.
> 
> Unlike NVMe, SCSI does not specify an LBA space boundary, but does specify
> a per-IO boundary granularity. The maximum boundary size is specified in
> MAXIMUM ATOMIC BOUNDARY SIZE. When used, this boundary value is set in the
> WRITE ATOMIC (16) ATOMIC BOUNDARY field - layout for the WRITE_ATOMIC_16
> command can be found in sbc4r22 section 5.48. This boundary value is the
> granularity size at which the device may atomically write the data. A value
> of zero in WRITE ATOMIC (16) ATOMIC BOUNDARY field means that all data must
> be atomically written together.
> 
> MAXIMUM ATOMIC TRANSFER LENGTH WITH BOUNDARY is the maximum atomic write
> length if a non-zero boundary value is set.
> 
> For atomic write support, the WRITE ATOMIC (16) boundary is not of much
> interest, as the block layer expects each request submitted to be executed
> atomically. However, the SCSI spec does leave itself open to a quirky
> scenario where MAXIMUM ATOMIC TRANSFER LENGTH is zero, yet MAXIMUM ATOMIC
> TRANSFER LENGTH WITH BOUNDARY and MAXIMUM ATOMIC BOUNDARY SIZE are both
> non-zero. This case will be supported.
> 
> To set the block layer request_queue atomic write capabilities, sanitize
> the VPD page limits and set limits as follows:
> - atomic_write_unit_min is derived from granularity and alignment values.
>    If no granularity value is not set, use physical block size
> - atomic_write_unit_max is derived from MAXIMUM ATOMIC TRANSFER LENGTH. In
>    the scenario where MAXIMUM ATOMIC TRANSFER LENGTH is zero and boundary
>    limits are non-zero, use MAXIMUM ATOMIC BOUNDARY SIZE for
>    atomic_write_unit_max. New flag scsi_disk.use_atomic_write_boundary is
>    set for this scenario.
> - atomic_write_boundary_bytes is set to zero always
> 
> SCSI also supports a WRITE ATOMIC (32) command, which is for type 2
> protection enabled. This is not going to be supported now, so check for
> T10_PI_TYPE2_PROTECTION when setting any request_queue limits.
> 
> To handle an atomic write request, add support for WRITE ATOMIC (16)
> command in handler sd_setup_atomic_cmnd(). Flag use_atomic_write_boundary
> is checked here for encoding ATOMIC BOUNDARY field.
> 
> Trace info is also added for WRITE_ATOMIC_16 command.
> 
> Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
> Signed-off-by: John Garry <john.g.garry@oracle.com>
> ---
>   drivers/scsi/scsi_trace.c   | 22 +++++++++
>   drivers/scsi/sd.c           | 93 ++++++++++++++++++++++++++++++++++++-
>   drivers/scsi/sd.h           |  8 ++++
>   include/scsi/scsi_proto.h   |  1 +
>   include/trace/events/scsi.h |  1 +
>   5 files changed, 124 insertions(+), 1 deletion(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich


