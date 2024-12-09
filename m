Return-Path: <io-uring+bounces-5305-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 55D539E8D5F
	for <lists+io-uring@lfdr.de>; Mon,  9 Dec 2024 09:29:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 50C84163D2B
	for <lists+io-uring@lfdr.de>; Mon,  9 Dec 2024 08:29:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFBD01C2DA2;
	Mon,  9 Dec 2024 08:29:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="WF3WZ7Rg";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="IzbpKzuE";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="WF3WZ7Rg";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="IzbpKzuE"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AD93374EA;
	Mon,  9 Dec 2024 08:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733732980; cv=none; b=P/hr08Orm34n1AzYMInUqjD1IFT+kWB3nG3/UToi9+HV+XNKUmjYTeFAq/SmtgVkXfsQ4uvdLrRjUj23nNrSCVKvf2mqh+cjIvpvfY9Eo8hxb0VTAqezTGh2kPOaU0CYaShQ6whFqgpT94tutNSeti7UcP75z8Sa9Zs1eZbQ+z4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733732980; c=relaxed/simple;
	bh=7Mbhoe4WjVsfqdwY/IKcsiT02FOUO1FubG5PSm7zCo4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eoqrDePc6SIGsExlVFcpUkZFsKVjixS0k764xJBrUYQEF3ZF3My+XRZxPVgnlcoAglz7uAq+8NPlOfKAajKqfZ83DyxQelk1YNvpAhBPXbVcu8Jn2qTo/dXWB3zLqpO2M2korihlpps0dpeETBe2WhsryKC/P9NztGnt6RvzriQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=WF3WZ7Rg; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=IzbpKzuE; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=WF3WZ7Rg; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=IzbpKzuE; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 6A6D520653;
	Mon,  9 Dec 2024 08:29:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1733732977; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RtMhn/ytJn4lebYTKmH6iouLQnLKkE93zAmSyItthAo=;
	b=WF3WZ7RgNeLn1XmG6OuOw1lI0dPi3GjG0DhtY0c/qkPMyrcnYBE06FDMxqiIu+gVC6tVFE
	RlzdpfaruKePXapxrZG5QBHXhrcqER7gPoARrsQctupAeG7CUSDgR7gbR3w3M/pQ2mQbfB
	RdtkUG2yeazfy2maYxCnjnpm6gxsVtg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1733732977;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RtMhn/ytJn4lebYTKmH6iouLQnLKkE93zAmSyItthAo=;
	b=IzbpKzuE4k8fmGEGDQKKIx5mrimhtAOPZEMjgFJZkLua9QeSxL9xN6K/PpVKc/UavtAcvr
	5vQesqaSHVdxITAQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1733732977; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RtMhn/ytJn4lebYTKmH6iouLQnLKkE93zAmSyItthAo=;
	b=WF3WZ7RgNeLn1XmG6OuOw1lI0dPi3GjG0DhtY0c/qkPMyrcnYBE06FDMxqiIu+gVC6tVFE
	RlzdpfaruKePXapxrZG5QBHXhrcqER7gPoARrsQctupAeG7CUSDgR7gbR3w3M/pQ2mQbfB
	RdtkUG2yeazfy2maYxCnjnpm6gxsVtg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1733732977;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RtMhn/ytJn4lebYTKmH6iouLQnLKkE93zAmSyItthAo=;
	b=IzbpKzuE4k8fmGEGDQKKIx5mrimhtAOPZEMjgFJZkLua9QeSxL9xN6K/PpVKc/UavtAcvr
	5vQesqaSHVdxITAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id F0B4B13AF4;
	Mon,  9 Dec 2024 08:29:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id g3S/OHCqVmfoDQAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 09 Dec 2024 08:29:36 +0000
Message-ID: <016cce77-a71e-4bef-9712-f469c45653dd@suse.de>
Date: Mon, 9 Dec 2024 09:29:36 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv12 05/12] block: introduce a write_stream_granularity
 queue limit
To: Keith Busch <kbusch@meta.com>, axboe@kernel.dk, hch@lst.de,
 linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org
Cc: sagi@grimberg.me, asml.silence@gmail.com, anuj20.g@samsung.com,
 joshi.k@samsung.com, Keith Busch <kbusch@kernel.org>
References: <20241206221801.790690-1-kbusch@meta.com>
 <20241206221801.790690-6-kbusch@meta.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20241206221801.790690-6-kbusch@meta.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -2.80
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_TLS_ALL(0.00)[];
	TAGGED_RCPT(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[12];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[grimberg.me,gmail.com,samsung.com,kernel.org];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:mid,suse.de:email,lst.de:email]
X-Spam-Flag: NO
X-Spam-Level: 

On 12/6/24 23:17, Keith Busch wrote:
> From: Christoph Hellwig <hch@lst.de>
> 
> Export the granularity that write streams should be discarded with,
> as it is essential for making good use of them.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Keith Busch <kbusch@kernel.org>
> ---
>   Documentation/ABI/stable/sysfs-block | 8 ++++++++
>   block/blk-sysfs.c                    | 3 +++
>   include/linux/blkdev.h               | 7 +++++++
>   3 files changed, 18 insertions(+)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

