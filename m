Return-Path: <io-uring+bounces-2309-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 53036911AEF
	for <lists+io-uring@lfdr.de>; Fri, 21 Jun 2024 08:10:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 09473283A3B
	for <lists+io-uring@lfdr.de>; Fri, 21 Jun 2024 06:10:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E95D3153BFA;
	Fri, 21 Jun 2024 06:10:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="v1WgmSZn";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="CcsOCDl4";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="mLvFqehg";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="yJJWL2W0"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 560F413BC05;
	Fri, 21 Jun 2024 06:10:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718950230; cv=none; b=fX4oh5RVZptQM6kUtew38ox+HY/NvSWyMmWJS09YJ2TJE1QdP1MquL5daEGRv0xuL58Dc2wQ60StsuVwuUOm3WM8hF1Elwg2/fzgO8eutF+ZC+OjHnufAHkAi/wp5uOp65DQRu2htgckApSsbwwBwmn+wI0PLjgxG0ht7pvhlI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718950230; c=relaxed/simple;
	bh=9O1WYEFN0F+Kfn+QsvaLTbgfImfJcaj6f0G/oxkJbVc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lqKTkhoNyNz9cWXrPIQFmNQpHiZz7CPzKMTJc5zvrjst2uC6Kdu5rT1iULzEX8YI7heWJGLeQjd65tah8RzVf/0YllWs67lgASuGccqj0YLo1zGSwNZxx5oPJrFR4Knmh+ZbW6sThWu72dSSHwysTWqS3xAw6U2KwXvF0lYK/oQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=v1WgmSZn; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=CcsOCDl4; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=mLvFqehg; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=yJJWL2W0; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 6C0D721A2D;
	Fri, 21 Jun 2024 06:10:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1718950227; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=T3CPbOPcAz0ix9MEFGkkxzNzU78yxaTRatp3NJyJjYg=;
	b=v1WgmSZnzL9H5HskNQluBAaRh/1Gxivx7Db1eKgBG/MC5lR2H4rm2le7PRPAcWk7S5T2rV
	5yLFM19mPnMo8Ay5lZEBKp7NSm60gU3NV+P5Hxb2fME9/oAIoPdcL+IM7zTuGwNW2CKe1n
	UodlFaMFzrdGqUDldlmrnrnv2msI3mQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1718950227;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=T3CPbOPcAz0ix9MEFGkkxzNzU78yxaTRatp3NJyJjYg=;
	b=CcsOCDl4KQ/sxAJl5jh3nJAzclMa2GkNZZs6hhc3s3uikvsZDgenMvN5ZPdeCtK7BNV5u7
	rjQlZOZqZclnG/AA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1718950226; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=T3CPbOPcAz0ix9MEFGkkxzNzU78yxaTRatp3NJyJjYg=;
	b=mLvFqehgc7i7fUPwZvvzZBcl7ygJl/IAWGTAGCZd4yfuEtExSVBeLmKQFKjtj5bYF5i3bS
	/XrWHnXdZuutwRHJK1z+/JgfUSW4enRCjEvFdp18l9D2vm81vPd9G/WTvumT9xeDp6z6xX
	QZAhH2MeIs+ptxNoaOztIl6op55buAk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1718950226;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=T3CPbOPcAz0ix9MEFGkkxzNzU78yxaTRatp3NJyJjYg=;
	b=yJJWL2W0iHCvbABdiS29TjFXfpVyP4UMklyoHclNoHCNmNGOPhEIAoZPMnit/m1uj8Jv0W
	w7IW9m2i7iXndACA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2EB7713ABD;
	Fri, 21 Jun 2024 06:10:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id EFAMKlAZdWbEewAAD6G6ig
	(envelope-from <hare@suse.de>); Fri, 21 Jun 2024 06:10:24 +0000
Message-ID: <931f5353-5e1e-4053-a098-a272a0793ce8@suse.de>
Date: Fri, 21 Jun 2024 08:10:24 +0200
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Patch v9 06/10] block: Add atomic write support for statx
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
 <20240620125359.2684798-7-john.g.garry@oracle.com>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240620125359.2684798-7-john.g.garry@oracle.com>
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
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[31];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[kernel.org,vger.kernel.org,lists.infradead.org,mit.edu,google.com,linux.ibm.com,kvack.org,gmail.com,infradead.org,redhat.com,lists.linux.dev,oracle.com];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	R_RATELIMIT(0.00)[to_ip_from(RLusjj3u5c53i6g8q6enupwtij)];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,oracle.com:email,imap1.dmz-prg2.suse.org:helo]

On 6/20/24 14:53, John Garry wrote:
> From: Prasad Singamsetty <prasad.singamsetty@oracle.com>
> 
> Extend statx system call to return additional info for atomic write support
> support if the specified file is a block device.
> 
> Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
> Signed-off-by: Prasad Singamsetty <prasad.singamsetty@oracle.com>
> Signed-off-by: John Garry <john.g.garry@oracle.com>
> ---
>   block/bdev.c           | 36 ++++++++++++++++++++++++++----------
>   fs/stat.c              | 16 +++++++++-------
>   include/linux/blkdev.h |  6 ++++--
>   3 files changed, 39 insertions(+), 19 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich


