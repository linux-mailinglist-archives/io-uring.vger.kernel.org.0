Return-Path: <io-uring+bounces-2313-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 74DC4911B65
	for <lists+io-uring@lfdr.de>; Fri, 21 Jun 2024 08:19:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 215FCB23F06
	for <lists+io-uring@lfdr.de>; Fri, 21 Jun 2024 06:19:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD30116B723;
	Fri, 21 Jun 2024 06:17:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="q2q6LjI7";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="gLtfOlca";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="q2q6LjI7";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="gLtfOlca"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C35A169361;
	Fri, 21 Jun 2024 06:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718950647; cv=none; b=G72emMZrjwaU82BLRP4yjHXwZ+JXi2CSB88yPoXxa96fG1d5SFesi0qwG16j1MJg07M2tWpIVfaxfkdXTMBgwgAq03e408F4fAD5QrMeX15pgdYwdROqcNdt0NoQCUrOPapvz9UkA6uEmfGxcXSqsYnVVCLzo35MQNMGivWMMH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718950647; c=relaxed/simple;
	bh=lhaF1TdXEEGFpX6mO4PrmRoi8Yb6OvspG4qmTWJYmik=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ge2kZsCMm2OZKktlSSjTPCe98QKE9yEnNgQlzrS3KDcDSyX3WGiyZ/WEbsFpqWBhVomfRODxVccnQPmKIyry1738uucom6AEaA9g1kiAjywkoasTXL4OEBFCE83ch8PPkuUe+7G5be51dDPpue8W705agXMFE1wXXcBBird0Occ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=q2q6LjI7; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=gLtfOlca; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=q2q6LjI7; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=gLtfOlca; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 20ED121A8A;
	Fri, 21 Jun 2024 06:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1718950643; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=r1BlICI+5gigoBuJzINX9RLMovcoOejI1LZxSX8ehXg=;
	b=q2q6LjI7eDIzYi4henwTHx8dRZaXAa7+djX0kFR5UUHAuudm612MXBypNr5L9JL2tDJ6n2
	Y9PstPp7dMAetzheYdoenWPRwS+ttJ3wvFIHfKhd6/50oiS9OO1SxpHN6kGDfIvCbIsLJE
	iOtD2wq1yAlAgmwsCLDr1D2bwOxaIa0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1718950643;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=r1BlICI+5gigoBuJzINX9RLMovcoOejI1LZxSX8ehXg=;
	b=gLtfOlca4LtQoIRswmFkkMgUUOfoNpIVhowLo7kOWZagO0qVTO0s7HFZBroAJlDB7s8EXe
	qicHOQVc/Os4wTAg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=q2q6LjI7;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=gLtfOlca
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1718950643; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=r1BlICI+5gigoBuJzINX9RLMovcoOejI1LZxSX8ehXg=;
	b=q2q6LjI7eDIzYi4henwTHx8dRZaXAa7+djX0kFR5UUHAuudm612MXBypNr5L9JL2tDJ6n2
	Y9PstPp7dMAetzheYdoenWPRwS+ttJ3wvFIHfKhd6/50oiS9OO1SxpHN6kGDfIvCbIsLJE
	iOtD2wq1yAlAgmwsCLDr1D2bwOxaIa0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1718950643;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=r1BlICI+5gigoBuJzINX9RLMovcoOejI1LZxSX8ehXg=;
	b=gLtfOlca4LtQoIRswmFkkMgUUOfoNpIVhowLo7kOWZagO0qVTO0s7HFZBroAJlDB7s8EXe
	qicHOQVc/Os4wTAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9E88D13ABD;
	Fri, 21 Jun 2024 06:17:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id MNsdIvEadWbDfAAAD6G6ig
	(envelope-from <hare@suse.de>); Fri, 21 Jun 2024 06:17:21 +0000
Message-ID: <e2574365-cb5b-4376-aa8e-adf05b788337@suse.de>
Date: Fri, 21 Jun 2024 08:17:21 +0200
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Patch v9 10/10] nvme: Atomic write support
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
 Alan Adamson <alan.adamson@oracle.com>
References: <20240620125359.2684798-1-john.g.garry@oracle.com>
 <20240620125359.2684798-11-john.g.garry@oracle.com>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240620125359.2684798-11-john.g.garry@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 20ED121A8A
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
	RCPT_COUNT_TWELVE(0.00)[31];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[kernel.org,vger.kernel.org,lists.infradead.org,mit.edu,google.com,linux.ibm.com,kvack.org,gmail.com,infradead.org,redhat.com,lists.linux.dev,oracle.com];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,oracle.com:email,suse.de:email,suse.de:dkim]
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org

On 6/20/24 14:53, John Garry wrote:
> From: Alan Adamson <alan.adamson@oracle.com>
> 
> Add support to set block layer request_queue atomic write limits. The
> limits will be derived from either the namespace or controller atomic
> parameters.
> 
> NVMe atomic-related parameters are grouped into "normal" and "power-fail"
> (or PF) class of parameter. For atomic write support, only PF parameters
> are of interest. The "normal" parameters are concerned with racing reads
> and writes (which also applies to PF). See NVM Command Set Specification
> Revision 1.0d section 2.1.4 for reference.
> 
> Whether to use per namespace or controller atomic parameters is decided by
> NSFEAT bit 1 - see Figure 97: Identify – Identify Namespace Data
> Structure, NVM Command Set.
> 
> NVMe namespaces may define an atomic boundary, whereby no atomic guarantees
> are provided for a write which straddles this per-lba space boundary. The
> block layer merging policy is such that no merges may occur in which the
> resultant request would straddle such a boundary.
> 
> Unlike SCSI, NVMe specifies no granularity or alignment rules, apart from
> atomic boundary rule. In addition, again unlike SCSI, there is no
> dedicated atomic write command - a write which adheres to the atomic size
> limit and boundary is implicitly atomic.
> 
> If NSFEAT bit 1 is set, the following parameters are of interest:
> - NAWUPF (Namespace Atomic Write Unit Power Fail)
> - NABSPF (Namespace Atomic Boundary Size Power Fail)
> - NABO (Namespace Atomic Boundary Offset)
> 
> and we set request_queue limits as follows:
> - atomic_write_unit_max = rounddown_pow_of_two(NAWUPF)
> - atomic_write_max_bytes = NAWUPF
> - atomic_write_boundary = NABSPF
> 
> If in the unlikely scenario that NABO is non-zero, then atomic writes will
> not be supported at all as dealing with this adds extra complexity. This
> policy may change in future.
> 
> In all cases, atomic_write_unit_min is set to the logical block size.
> 
> If NSFEAT bit 1 is unset, the following parameter is of interest:
> - AWUPF (Atomic Write Unit Power Fail)
> 
> and we set request_queue limits as follows:
> - atomic_write_unit_max = rounddown_pow_of_two(AWUPF)
> - atomic_write_max_bytes = AWUPF
> - atomic_write_boundary = 0
> 
> A new function, nvme_valid_atomic_write(), is also called from submission
> path to verify that a request has been submitted to the driver will
> actually be executed atomically. As mentioned, there is no dedicated NVMe
> atomic write command (which may error for a command which exceeds the
> controller atomic write limits).
> 
> Note on NABSPF:
> There seems to be some vagueness in the spec as to whether NABSPF applies
> for NSFEAT bit 1 being unset. Figure 97 does not explicitly mention NABSPF
> and how it is affected by bit 1. However Figure 4 does tell to check Figure
> 97 for info about per-namespace parameters, which NABSPF is, so it is
> implied. However currently nvme_update_disk_info() does check namespace
> parameter NABO regardless of this bit.
> 
> Signed-off-by: Alan Adamson <alan.adamson@oracle.com>
> Reviewed-by: Keith Busch <kbusch@kernel.org>
> Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
> jpg: total rewrite
> Signed-off-by: John Garry <john.g.garry@oracle.com>
> ---
>   drivers/nvme/host/core.c | 52 ++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 52 insertions(+)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich


