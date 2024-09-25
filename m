Return-Path: <io-uring+bounces-3295-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 278E4985295
	for <lists+io-uring@lfdr.de>; Wed, 25 Sep 2024 07:48:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D7E23283FCD
	for <lists+io-uring@lfdr.de>; Wed, 25 Sep 2024 05:48:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D4F584A32;
	Wed, 25 Sep 2024 05:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="atHRudHw";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="F4UfQTWz";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="atHRudHw";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="F4UfQTWz"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3014B41C94;
	Wed, 25 Sep 2024 05:48:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727243318; cv=none; b=nPoZj4jBFk3fz/jxYPHHvuWo1vwdz8hsVNWRk2pLgc8QgqLzvakf73h/zhRjgQBmqv/BnW1NvqNL4RPk305WUyBlVbRlnXCogiEChlEKLt4Zs34LkfHG+F1cvPDdm0TS0Da4se3M1XZ2aGo6zfkLBtPghIAlBsH98HPriUlu6+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727243318; c=relaxed/simple;
	bh=j9bql+QiM+ZHKuGQMvLh3g76Dofspwr0/9wgSEqiaKo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=C4vGDGCRaKyb2CaLi5XzPCRZBALMtQGh677dAMfS61msbYfEsr6XLR6pZY6GgEzIO0D8tM0tBaj/9HY9arhTrQpy9Y4BrLw2yiPRZ0Acc0Z+BWL2olOQQ3FInwmChTcWmF4g4qR1s2WXF0fqq6dfC667MfZGEghBE5SsR1HW4DQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=atHRudHw; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=F4UfQTWz; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=atHRudHw; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=F4UfQTWz; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 3B33D211E5;
	Wed, 25 Sep 2024 05:48:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1727243315; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WC5lMWPOQJyCMDITxuBay9ED03WWOnQxMVAZM6detzs=;
	b=atHRudHw4gBD0qUXsdWoWwdoyXfPXvIBS2A+KbXSHk0CrsNiA3a6OGFUWRhIc6mk3ysasV
	3HdjxlflV638ltA9o2Ktg5WNy7Qeh4tLixH+xX+4gzdSIGUF/bljn3N8bm3IN6lBiI3lYh
	iYdqnQISjqEK75rTtpMPrRxWJB6LlKk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1727243315;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WC5lMWPOQJyCMDITxuBay9ED03WWOnQxMVAZM6detzs=;
	b=F4UfQTWzbznrvneSEC8Lv/HkKkdGj9H5jaap5pNTs6fMQhal/zdNlNranqs4t29fM8m756
	rTNQDg/00eX0LsBQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1727243315; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WC5lMWPOQJyCMDITxuBay9ED03WWOnQxMVAZM6detzs=;
	b=atHRudHw4gBD0qUXsdWoWwdoyXfPXvIBS2A+KbXSHk0CrsNiA3a6OGFUWRhIc6mk3ysasV
	3HdjxlflV638ltA9o2Ktg5WNy7Qeh4tLixH+xX+4gzdSIGUF/bljn3N8bm3IN6lBiI3lYh
	iYdqnQISjqEK75rTtpMPrRxWJB6LlKk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1727243315;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WC5lMWPOQJyCMDITxuBay9ED03WWOnQxMVAZM6detzs=;
	b=F4UfQTWzbznrvneSEC8Lv/HkKkdGj9H5jaap5pNTs6fMQhal/zdNlNranqs4t29fM8m756
	rTNQDg/00eX0LsBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 604D913A66;
	Wed, 25 Sep 2024 05:48:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id LABIDTCk82azVAAAD6G6ig
	(envelope-from <hare@suse.de>); Wed, 25 Sep 2024 05:48:32 +0000
Message-ID: <da049cc8-8f36-460e-b7fa-efcde5b19dbb@suse.de>
Date: Wed, 25 Sep 2024 07:48:31 +0200
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 1/3] nvme: enable FDP support
To: Kanchan Joshi <joshi.k@samsung.com>, axboe@kernel.dk, kbusch@kernel.org,
 hch@lst.de, sagi@grimberg.me, martin.petersen@oracle.com,
 brauner@kernel.org, viro@zeniv.linux.org.uk, jack@suse.cz,
 jaegeuk@kernel.org, bcrl@kvack.org, dhowells@redhat.com, bvanassche@acm.org,
 asml.silence@gmail.com
Cc: linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 io-uring@vger.kernel.org, linux-block@vger.kernel.org, linux-aio@kvack.org,
 gost.dev@samsung.com, vishak.g@samsung.com, javier.gonz@samsung.com,
 Hui Qi <hui81.qi@samsung.com>, Nitesh Shetty <nj.shetty@samsung.com>
References: <20240924092457.7846-1-joshi.k@samsung.com>
 <CGME20240924093250epcas5p39259624b9ebabdef15081ea9bd663d41@epcas5p3.samsung.com>
 <20240924092457.7846-2-joshi.k@samsung.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240924092457.7846-2-joshi.k@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FREEMAIL_TO(0.00)[samsung.com,kernel.dk,kernel.org,lst.de,grimberg.me,oracle.com,zeniv.linux.org.uk,suse.cz,kvack.org,redhat.com,acm.org,gmail.com];
	TAGGED_RCPT(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[24];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -2.80
X-Spam-Flag: NO

On 9/24/24 11:24, Kanchan Joshi wrote:
> Flexible Data Placement (FDP), as ratified in TP 4146a, allows the host
> to control the placement of logical blocks so as to reduce the SSD WAF.
> 
> Userspace can send the data lifetime information using the write hints.
> The SCSI driver (sd) can already pass this information to the SCSI
> devices. This patch does the same for NVMe.
> 
> Fetch the placement-identifiers if the device supports FDP.
> The incoming write-hint is mapped to a placement-identifier, which in
> turn is set in the DSPEC field of the write command.
> 
> Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
> Signed-off-by: Hui Qi <hui81.qi@samsung.com>
> Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
> ---
>   drivers/nvme/host/core.c | 70 ++++++++++++++++++++++++++++++++++++++++
>   drivers/nvme/host/nvme.h |  4 +++
>   include/linux/nvme.h     | 19 +++++++++++
>   3 files changed, 93 insertions(+)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich


