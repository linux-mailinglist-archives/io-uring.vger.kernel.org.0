Return-Path: <io-uring+bounces-2299-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BF8859107A9
	for <lists+io-uring@lfdr.de>; Thu, 20 Jun 2024 16:13:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3DF771F21CC0
	for <lists+io-uring@lfdr.de>; Thu, 20 Jun 2024 14:13:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C98771AD4B9;
	Thu, 20 Jun 2024 14:12:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="zt1JXUWO";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="miN6IEO0";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="zt1JXUWO";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="miN6IEO0"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3767D1ACE8B;
	Thu, 20 Jun 2024 14:12:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718892778; cv=none; b=rZ1IXygB43zgWEcCDU/VxCN0ZK2AFW7Pxpiozjlf9+CJMmlrxXAObzJi6+PV7uaG8auytBpkVu5amrfFMihxivlcQXN6qnTCBQkVQfZMcFi6ePnZhE9dw4Wd1fvfUB5yohH9SURa5u+q8/4uvbG+Wd55+fBdzLLtSuxuH7XqP/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718892778; c=relaxed/simple;
	bh=a2igiApBU77fBP9Tg9BAAqeh+G6mxLYKf93fVQlTysI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=s01NqK6GU3r821pGpSzKqQkvKzjbUYT4wLZ1GRhvblHm1qISBgbqg/Uga571v+VsdegPuEtMFJ9rXwe0ZnIJ2ArmqOeBUo61N7UVNWzuUwRcV/kRhWJr5kv+RiciGp/Zs2mZUX+H1v53l0yDZGRHqW4bKnh+OxfpzdMqhAzJwEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=zt1JXUWO; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=miN6IEO0; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=zt1JXUWO; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=miN6IEO0; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 71E341F8A3;
	Thu, 20 Jun 2024 14:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1718892775; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2bOUA5QxJ31WCm6TPcJHCbjgJxpPmWHLpzok2TtDYqc=;
	b=zt1JXUWOXSP38EVlKaw+5G4O5YWCV2Nlcx6R+3dFKt1zVJGR4gP7Vbn6WZCxRqF0IwJM6j
	pFAR7qiyPX5cF3RCLcLfSPDkvVLJIjUKdo40QMdT+lqWYp/hEYMpPZORETKBnTQsfPxUgz
	nmePGnARD5yj1dAqT1Kx5i/XaR/Lqhg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1718892775;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2bOUA5QxJ31WCm6TPcJHCbjgJxpPmWHLpzok2TtDYqc=;
	b=miN6IEO0C7jAdufzLA7ujwgUOVZD2Kz32tibXGEWysr9O0buLyUIA2aBENYXrk12wrGJWa
	nJp2TA0rIFLNnACA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1718892775; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2bOUA5QxJ31WCm6TPcJHCbjgJxpPmWHLpzok2TtDYqc=;
	b=zt1JXUWOXSP38EVlKaw+5G4O5YWCV2Nlcx6R+3dFKt1zVJGR4gP7Vbn6WZCxRqF0IwJM6j
	pFAR7qiyPX5cF3RCLcLfSPDkvVLJIjUKdo40QMdT+lqWYp/hEYMpPZORETKBnTQsfPxUgz
	nmePGnARD5yj1dAqT1Kx5i/XaR/Lqhg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1718892775;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2bOUA5QxJ31WCm6TPcJHCbjgJxpPmWHLpzok2TtDYqc=;
	b=miN6IEO0C7jAdufzLA7ujwgUOVZD2Kz32tibXGEWysr9O0buLyUIA2aBENYXrk12wrGJWa
	nJp2TA0rIFLNnACA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8419713AC1;
	Thu, 20 Jun 2024 14:12:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id srm0HOU4dGZwWgAAD6G6ig
	(envelope-from <hare@suse.de>); Thu, 20 Jun 2024 14:12:53 +0000
Message-ID: <cfb9db60-6ff0-4c3a-9252-57d5e9c64d65@suse.de>
Date: Thu, 20 Jun 2024 16:12:52 +0200
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Patch v9 01/10] block: Pass blk_queue_get_max_sectors() a
 request pointer
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
 Luis Chamberlain <mcgrof@kernel.org>
References: <20240620125359.2684798-1-john.g.garry@oracle.com>
 <20240620125359.2684798-2-john.g.garry@oracle.com>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240620125359.2684798-2-john.g.garry@oracle.com>
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
	FREEMAIL_CC(0.00)[kernel.org,vger.kernel.org,lists.infradead.org,mit.edu,google.com,linux.ibm.com,kvack.org,gmail.com,infradead.org,redhat.com,lists.linux.dev];
	MID_RHS_MATCH_FROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RCVD_COUNT_TWO(0.00)[2];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,imap1.dmz-prg2.suse.org:helo]

On 6/20/24 14:53, John Garry wrote:
> Currently blk_queue_get_max_sectors() is passed a enum req_op. In future
> the value returned from blk_queue_get_max_sectors() may depend on certain
> request flags, so pass a request pointer.
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Keith Busch <kbusch@kernel.org>
> Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
> Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
> Signed-off-by: John Garry <john.g.garry@oracle.com>
> ---
>   block/blk-merge.c | 3 ++-
>   block/blk-mq.c    | 2 +-
>   block/blk.h       | 6 ++++--
>   3 files changed, 7 insertions(+), 4 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich


