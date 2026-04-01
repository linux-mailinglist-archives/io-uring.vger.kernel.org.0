Return-Path: <io-uring+bounces-12917-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KPdNECA8zWn5awYAu9opvQ
	(envelope-from <io-uring+bounces-12917-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 01 Apr 2026 17:39:12 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 9656D37D488
	for <lists+io-uring@lfdr.de>; Wed, 01 Apr 2026 17:39:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 59A6730ABD4B
	for <lists+io-uring@lfdr.de>; Wed,  1 Apr 2026 15:03:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 648F12DAFB0;
	Wed,  1 Apr 2026 15:03:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="M8VAWvue"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f46.google.com (mail-oa1-f46.google.com [209.85.160.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66BD835F169
	for <io-uring@vger.kernel.org>; Wed,  1 Apr 2026 15:03:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775055829; cv=none; b=fCMcddcuytiJTsM3pZtSuD0FvQsT2iT5RV3GJhCk4NBkm0qgWCXc5D6likXda2tFkLaZFyK+JLh1e36vudEMBVulJFtHCQXzB5CW2wIzdSJRiKW2au93WZGdpd1S6tckndR/DnIL1Ud+qfOHF+OTjX1wqt5voX3JgM80yNEk0x8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775055829; c=relaxed/simple;
	bh=eJO+rNnSBa3OnrgQs1l1jYc2J1IZx8Kxb6pxYhSGviA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BkSt8deRXTSxQFRizmrCQ6FJ94RrRa9E0KNy4JJOrCZwJp1ZyWKPpAGYK3xdBjWv+jdwjftQDgY46pqt8QcMlUik+u0iTWbtLt4fmK/LOtLzf8e7XieLgIflAmIjRkZtuuHZLbjCddStXCOv+3rEIn2fGQlNbWPj3OUHmV79drk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=M8VAWvue; arc=none smtp.client-ip=209.85.160.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f46.google.com with SMTP id 586e51a60fabf-417c34b0509so5292610fac.1
        for <io-uring@vger.kernel.org>; Wed, 01 Apr 2026 08:03:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1775055826; x=1775660626; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=p91ZNxa2LkoEef9tkp+BamFstvlICmGYOzGG4lA5VMM=;
        b=M8VAWvueBxSR1X0CL14WggbZT86j1RK2n/79alnwKoSE8FW5huYYBELd9irytyMOz8
         GqMftLr34T0HaGKmMhkf39vXfOPdq9gIsTe/pUTYt1afEEXuObdr7dW9ck40hwoSfLJy
         3Rin6RTiniM1Cr/uj0r6kp3Q8fdq9Qf8m2dzhMeiqIwyWPKpbK8QpFo9yFtAzmBkARtm
         eDrXB6c3dJEZDLDGWR4E8OXfZkQ3bsIO+tutDxi8NrnNuwZIR5j0ejy+10XMy/fEpJFW
         TYjJD9vaUKv6jHD2YFPB4w6yqx4RbBdLh06MdEwkqWiPT82ngvClphLv9yNDm6QlxZXq
         Bb8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775055826; x=1775660626;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=p91ZNxa2LkoEef9tkp+BamFstvlICmGYOzGG4lA5VMM=;
        b=a9sEqWsm1HsI536JNgyOUK0I9WhHu1l1/QVltSynB2vLXdeIgjxPUhBfiRm+jvq/iT
         S9Qg1DRAg9HNnBpvO/RPtUiWTKT+iLpDMym2OW4D49bCgIotH/st6ox5FW/2pnwzRFH8
         KBnZN49XgmTGF6cLcLgPHnV9FQ1MUPOD2ozoBVo8wimw2UaJLuh7B4RcmwU6frOurDOk
         kt0YSGWjGHGpHRJomYqCJ+j6ggzdYQgSouXKZkSOTPpd2VtsRhdLXw/lp59GEPrWtjxd
         ThomUBjG5FWsEOJPniiYIrkWhGxBVn5z1qdC5B2lZJhux3nx3BUmZjdKmUlfHT32DlNq
         FiBQ==
X-Forwarded-Encrypted: i=1; AJvYcCV7eK6rPPeCWzoBh3uiyDq8wU6+qlW+dlND7/wm6tmL0HjahzZrkVYDeugEZ1vzN50qylq9T5PQdQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzQ9DTNckhgxJd6aOyakIvaogKD2faBkULGh3a+ZB5kqyh732vx
	oexbnuzc9BmlVDPe2S87ebjXXVNGhhwVrI6PBJrcF4IGvZbo3EhwYOCjvLghRghVC7c=
X-Gm-Gg: ATEYQzyy8Y4mc+K2gHjVqRFrRoj9PZCmI97JrjcSdJK2jSBEYKAw0lpPIlB3bjGUF2J
	ATUI5e1zZEpzvqDDb07fQobVzVc9mgHdKLR0jo+PhNcP1hyJPuggD7Ii7JFejNunCk00/hs7jZc
	Q0nzuSN9T6aHgQf+3MND4ACHSORJc5F79XgiO2p9WSPBin3XI9YQrAgBeQz6uUmIF22QBFoeGLW
	2x9zcB+mSm6RtYhG4ByVOrpcBvkgTrCsE/B7lU65kY+LlfNx4qIyXZNFaMLtevMwBtnBHzgg1e/
	0rN5I5qrGW4B5hQiw0SavOprRKh/ry/1guL+a3FT+9g0Re7WoVicM9+S4S7HJG19bO7yAsEWOy5
	feH3T6iVP5ibeL9xWB4FAmCxkiLbwltNshieGTD8lybE+Wa7gSaKWnJnf0sIdzW8s7eI7T1OZ5n
	7+97lRVRR3urpa3Cgmast1c7QsXikg+yVIyxT4XwOCiGljveyVPOj5gevzR7DBQwSBzfjdfgxZX
	khlaneY32Y4P9HCvJk=
X-Received: by 2002:a05:6871:d212:b0:417:7b1d:1b2 with SMTP id 586e51a60fabf-422cff53c2amr2500123fac.42.1775055826021;
        Wed, 01 Apr 2026 08:03:46 -0700 (PDT)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-422eaed6647sm68597fac.2.2026.04.01.08.03.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Apr 2026 08:03:44 -0700 (PDT)
Message-ID: <49a977f3-45da-41dd-9fd6-75fd6760a591@kernel.dk>
Date: Wed, 1 Apr 2026 09:03:43 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: io_uring_prep_timeout() leading to an IO pressure close to 100
To: Fiona Ebner <f.ebner@proxmox.com>, linux-kernel@vger.kernel.org
Cc: hannes@cmpxchg.org, surenb@google.com, peterz@infradead.org,
 io-uring@vger.kernel.org
References: <14bc6266-5bc9-4454-9518-d1016bfe417b@proxmox.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <14bc6266-5bc9-4454-9518-d1016bfe417b@proxmox.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-12917-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DMARC_NA(0.00)[kernel.dk];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,kernel.dk:mid,kernel-dk.20230601.gappssmtp.com:dkim]
X-Rspamd-Queue-Id: 9656D37D488
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 4/1/26 8:59 AM, Fiona Ebner wrote:
> Dear maintainers,
> 
> I'm currently investigating an issue with QEMU causing an IO pressure
> value of nearly 100 when io_uring is used for the event loop of a QEMU
> iothread (which is the case since QEMU 10.2 if io_uring is enabled
> during configuration and available).

It's not "IO pressure", it's the useless iowait metric...

> The cause seems to be the io_uring_prep_timeout() call that is used for
> blocking wait. I attached a minimal reproducer below, which exposes the
> issue [0].
> 
> This was observed on a kernel based on 7.0-rc6 as well as 6.17.13. I
> haven't investigated what happens inside the kernel yet, so I don't know
> if it is an accounting issue or within io_uring.
> 
> Let me know if you need more information or if I should test something
> specific.

If you won't want it, just turn it off with io_uring_set_iowait().

-- 
Jens Axboe

