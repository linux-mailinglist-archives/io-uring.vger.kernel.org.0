Return-Path: <io-uring+bounces-3296-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 538D798529D
	for <lists+io-uring@lfdr.de>; Wed, 25 Sep 2024 07:49:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 106772845D5
	for <lists+io-uring@lfdr.de>; Wed, 25 Sep 2024 05:49:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25FF1153BFC;
	Wed, 25 Sep 2024 05:49:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="11O0PItZ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="x90jDMzu";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="11O0PItZ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="x90jDMzu"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78B7F1B85D5;
	Wed, 25 Sep 2024 05:49:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727243385; cv=none; b=eiEz2OVyQuDhNAll9ohiV5dV1rY+njOhrwZl9iBSlwv5QsIuIWY02psq22xkxjl9zHNGozd2hf87MYjV9LC1QUAlpYPt7KV4kw2KFtDFLqKZwucJQ+L1RG6aaU5TW/3wyD2Q391MKRPf/u6aeC5buAf+fKVHqvirYs3UThCb9bY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727243385; c=relaxed/simple;
	bh=P7cYHty3pb33GLDqv7pPFdzQIzzz8yn9fRVCcFpFk0w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=S28fStTZjunfN+dHixZulWhvZy3pf0Jyoe9GOG5V/lFT/6F3Q4EWFSk4DGnGi/Cf1mTe6DXS9e9V7AVrKpLeUA+guZFbPsK/ll4OfG4SwoBHMc/mjjNXGpy4yUK36DohZH8pjY/wo35g7bzFfDcILcpXbOtedDpRlcjHAF1t/BM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=11O0PItZ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=x90jDMzu; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=11O0PItZ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=x90jDMzu; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 8597A1F7EA;
	Wed, 25 Sep 2024 05:49:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1727243381; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AHpdRcf17YqPpnP5snNczbwlnu6M39hxK7K72p2XJF0=;
	b=11O0PItZLl9S6iWTowYTz2Wa7yvSh2bRjuyqxiV2YuQ0lKsE1VGiDASm8TRDwd32T5cxQj
	bW62EHga4AtHU3M92CJJ+8Am64ja0WPY2ThNxs/pvT05AQqlMoJ5Q3RogiZfVWl6TbKwLo
	+/w8rUdE7zDW+Kqwivbpb76a0qf4GTI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1727243381;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AHpdRcf17YqPpnP5snNczbwlnu6M39hxK7K72p2XJF0=;
	b=x90jDMzu5DB1GHUB5SEQO02q+/Yfl/z9Roa1SnFC9N2UYY5K3zLDQ0mSQmuGR8gnFMa3Bi
	cnjVDWIBkUz6PvDw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=11O0PItZ;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=x90jDMzu
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1727243381; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AHpdRcf17YqPpnP5snNczbwlnu6M39hxK7K72p2XJF0=;
	b=11O0PItZLl9S6iWTowYTz2Wa7yvSh2bRjuyqxiV2YuQ0lKsE1VGiDASm8TRDwd32T5cxQj
	bW62EHga4AtHU3M92CJJ+8Am64ja0WPY2ThNxs/pvT05AQqlMoJ5Q3RogiZfVWl6TbKwLo
	+/w8rUdE7zDW+Kqwivbpb76a0qf4GTI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1727243381;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AHpdRcf17YqPpnP5snNczbwlnu6M39hxK7K72p2XJF0=;
	b=x90jDMzu5DB1GHUB5SEQO02q+/Yfl/z9Roa1SnFC9N2UYY5K3zLDQ0mSQmuGR8gnFMa3Bi
	cnjVDWIBkUz6PvDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D1D3613A66;
	Wed, 25 Sep 2024 05:49:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id gBcPMHOk82YIVQAAD6G6ig
	(envelope-from <hare@suse.de>); Wed, 25 Sep 2024 05:49:39 +0000
Message-ID: <e73894e4-8f46-4fb2-a628-75e009d18fb0@suse.de>
Date: Wed, 25 Sep 2024 07:49:36 +0200
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 2/3] block, fs: restore kiocb based write hint
 processing
To: Kanchan Joshi <joshi.k@samsung.com>, axboe@kernel.dk, kbusch@kernel.org,
 hch@lst.de, sagi@grimberg.me, martin.petersen@oracle.com,
 brauner@kernel.org, viro@zeniv.linux.org.uk, jack@suse.cz,
 jaegeuk@kernel.org, bcrl@kvack.org, dhowells@redhat.com, bvanassche@acm.org,
 asml.silence@gmail.com
Cc: linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 io-uring@vger.kernel.org, linux-block@vger.kernel.org, linux-aio@kvack.org,
 gost.dev@samsung.com, vishak.g@samsung.com, javier.gonz@samsung.com,
 Nitesh Shetty <nj.shetty@samsung.com>
References: <20240924092457.7846-1-joshi.k@samsung.com>
 <CGME20240924093254epcas5p491d7f7cb62dbbf05fe29e0e75d44bff5@epcas5p4.samsung.com>
 <20240924092457.7846-3-joshi.k@samsung.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240924092457.7846-3-joshi.k@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8597A1F7EA
X-Spam-Score: -5.01
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-5.01 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	DWL_DNSWL_MED(-2.00)[suse.de:dkim];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RCPT_COUNT_TWELVE(0.00)[23];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FREEMAIL_TO(0.00)[samsung.com,kernel.dk,kernel.org,lst.de,grimberg.me,oracle.com,zeniv.linux.org.uk,suse.cz,kvack.org,redhat.com,acm.org,gmail.com];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	MID_RHS_MATCH_FROM(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spam-Level: 

On 9/24/24 11:24, Kanchan Joshi wrote:
> struct kiocb has a 2 bytes hole that developed post commit 41d36a9f3e53
> ("fs: remove kiocb.ki_hint").
> But write hint has made a comeback with commit 449813515d3e ("block, fs:
> Restore the per-bio/request data lifetime fields").
> 
> This patch uses the leftover space in kiocb to carve 1 byte field
> ki_write_hint.
> Restore the code that operates on kiocb to use ki_write_hint instead of
> inode hint value.
> 
> This does not bring any behavior change, but needed to enable per-io
> hints (by another patch).
> 
> Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
> Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
> ---
>   block/fops.c         | 6 +++---
>   fs/aio.c             | 1 +
>   fs/cachefiles/io.c   | 1 +
>   fs/direct-io.c       | 2 +-
>   fs/iomap/direct-io.c | 2 +-
>   include/linux/fs.h   | 8 ++++++++
>   io_uring/rw.c        | 1 +
>   7 files changed, 16 insertions(+), 5 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich


