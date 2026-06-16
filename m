Return-Path: <io-uring+bounces-13744-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id ybsRFCk8MWqFegUAu9opvQ
	(envelope-from <io-uring+bounces-13744-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 16 Jun 2026 14:06:01 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0701968F15A
	for <lists+io-uring@lfdr.de>; Tue, 16 Jun 2026 14:06:01 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RSqjkNkN;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13744-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c04:e001:36c::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13744-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 6086B317AA76
	for <lists+io-uring@lfdr.de>; Tue, 16 Jun 2026 11:59:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89EE943CEC7;
	Tue, 16 Jun 2026 11:59:02 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-dy1-f178.google.com (mail-dy1-f178.google.com [74.125.82.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 506FA3B7750
	for <io-uring@vger.kernel.org>; Tue, 16 Jun 2026 11:59:01 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781611142; cv=none; b=cj0avm1S0zvSBVCb1/dde9nGm3YMj5VpHV4n782WapqhlqKpmcfOtI3EHi6Dn0r+Y8LZVy0XYanTITrJ1O0qkcnF89wheKedzwXd2DAYeTLETVD+IHa/DHbV8C9Mi+vKNPjPw2ScEaJ266sa0QOLoZs9fuRVOSo2XiCg8APz4T8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781611142; c=relaxed/simple;
	bh=YjyDwM56jj3ck9czMA3EKniiIiPNImL2Oy+lMeO7nTI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aYNuzXijO4twU+894qJl1OX7IydhzjQGWRiBo5LuEsfpV2+5BVVaUAdVbw6wpVVgPKIMVKV3aLWMwG/oARKvM/bZHAa8KLG6DYUO49FZcfOjzw9m6Efw8mxQ2NO0f39jmV01k8n7jNyNybtJgKOxeaFX5Qp99De4nOMuYgKtV4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RSqjkNkN; arc=none smtp.client-ip=74.125.82.178
Received: by mail-dy1-f178.google.com with SMTP id 5a478bee46e88-306f36df4feso3074198eec.0
        for <io-uring@vger.kernel.org>; Tue, 16 Jun 2026 04:59:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781611140; x=1782215940; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cOYpESX981Rq4adIIEfG1WpSNiPgBSeZzxBAEnkFj7o=;
        b=RSqjkNkN+5t9GXGQdzg4XxykC8/aiszMz5K7dgfBR2gKlQ3HUyrBPY0GYk/3wYPqr2
         l/rTCjFuTCP+d4/7kEddgAShHdQmo0CXWA09rwPdCLfshe8jHu+twPXagab7ch5xzHDu
         JVWqpargrd+QKjwGDWQ4JZ88CQMqtW7VrXwGs45vTVVe5FITxejhOsJsEJW4bIEeAoF/
         afZelZvMBwOgw/A9jVJjPjhIdkStc55+K+X1xiwcLOH8u7+xebTvEb6sUySKev/pEwE9
         M5RLFSIhR65k6UeoP9RuUOD4g8kHxBupBd4yAzKJHTSf9UljNOPJQAE6S4YJPJPiviu5
         K7ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781611140; x=1782215940;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cOYpESX981Rq4adIIEfG1WpSNiPgBSeZzxBAEnkFj7o=;
        b=qWhIlPS8BaUwaX45/7Npzx0hF1CTNHScHEUlu3xAyNyxUZ254oGHuH3IlkMxw8rRGT
         S8b82twN74+bBy8tTxul4U8ucl8vty85irNw4mZMO4IlTZSmP45N6qByBbKyyPdmzahp
         xx3hW35UsnWqc2eC6K6hXNo1Ep1UpPwpm4on7wQnfa89NrZEUe7cLrTjEW1dmBr2Nerg
         0cKlcuPTc/lJ4i6MMkP0BcZ9wxOwKqbXFUAIDz2tS/I9T6uvy9Jo+ia7kR3gVezB8vMS
         0I4P77ZIWBSKtj//pJjMyVZlAsfjnASoRnmsnaEgc+9yIj9NqwegHXECE8PKgzgyakEZ
         GnaA==
X-Gm-Message-State: AOJu0YxiWsU6wXWdfcB7Tq06gDWKHWgaugU6P79iUPHR2GDquu2azxgg
	qKEaoxoJUbL0+jMqozM/wfLbzDaaAaDoXj56k8hBuIS+SI46aDU3gKtu
X-Gm-Gg: Acq92OGR7SDzVuOrm6fgpOt+YfpHYNaQsZq+WsJ/DkxOobXLE5mWc6nvlcdlOdD8una
	Tttg9rybrme3Y5VP/oXCpoN6EyTT0bBvyUYlkZHmivVh1vEICEbwM/aGo8ZaAjS5eiiJW3Wcdwi
	QF1LS3JeO24mlWSBPLUeMa5qdgI85aKYqk/lWVZHVED8VjGvhm4xd3mdAj37e4ysP4KJryiFLrB
	xBCwQR/suRIWM7SoJcFg6XlfYw1ASzSwLBAbNQVMiPNJMFVLbHie+E1RGxxXD55hfi0HSI6WGEY
	gmeVjkpIqayR9FXQp5eowPxvkoDSZ9/4po1AShsVrmd9hBWCzNZwae9DkRcHs7STe8VpwvmGEqI
	qLRgiLtiZBIKeYF4s+aicEFktcaIIugb3LvDDHu2OsJ269oZYncqJ8WXZOprtGAnLlkBSyq8L+/
	09es5l27QTrxlTTQ5u+2IGByjoHh2czyIumebmsg+N8Qu+7sE=
X-Received: by 2002:a05:7300:1802:b0:2ef:1d11:18b0 with SMTP id 5a478bee46e88-30ba3965b7amr1988800eec.17.1781611140293;
        Tue, 16 Jun 2026 04:59:00 -0700 (PDT)
Received: from [100.82.100.73] ([63.216.146.178])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3081ea447b4sm17473762eec.23.2026.06.16.04.58.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Jun 2026 04:58:59 -0700 (PDT)
Message-ID: <cfdb0fcf-5687-448a-ba44-3b16535b3a90@gmail.com>
Date: Tue, 16 Jun 2026 19:58:56 +0800
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/register: preserve SQ array entries on resize
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260608133316.3656440-1-guzebing1612@gmail.com>
From: guzebing <guzebing1612@gmail.com>
In-Reply-To: <20260608133316.3656440-1-guzebing1612@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13744-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER(0.00)[guzebing1612@gmail.com,io-uring@vger.kernel.org];
	TO_DN_SOME(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:axboe@kernel.dk,m:io-uring@vger.kernel.org,m:linux-kernel@vger.kernel.org,s:lists@lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	FREEMAIL_FROM(0.00)[gmail.com];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[guzebing1612@gmail.com,io-uring@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[3];
	ALIAS_RESOLVED(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 0701968F15A

Hi Jens,

A gentle ping on this patch.

Please allow me to add some details about the root cause and the
reproducer.

There appear to be two related parts to how the resize path migrates 
pending SQ entries in regular SQ-array mode.

1. It copies SQEs by walking the logical SQ head/tail range directly.
For a pending SQ entry in regular SQ-array mode, the resize path should
first resolve the old sq_array[] entry to find the source physical SQE
slot, and then copy that SQE into the new SQE array.

2. The old resize path switches ctx->sq_array to the SQ array in the
new ring, but it does not initialize the SQ array entries for the 
pending submissions.


And I reproduced this with a small test that:

1. creates a ring with IORING_SETUP_SINGLE_ISSUER | 
IORING_SETUP_DEFER_TASKRUN,
2. writes two NOP SQEs into physical slots 1 and 2,
3. queues two pending entries by setting sq_array[0] = 1 and
    sq_array[1] = 2 and advancing the SQ tail,
4. resizes the ring,
5. calls io_uring_enter() to submit those pending SQ entries.

Without the fix, the subsequent submission path can consume the wrong 
SQE after resize and return a CQE with the wrong user_data. With the 
patch applied, pending SQ entries are migrated using the old SQ-array 
mapping, so they still refer to the intended SQEs after resize.

Could you please take a look when you have a chance? I would also
appreciate feedback if you think this is not the right direction, or if
there is a better way to preserve pending SQ-array entries during resize.

Thanks,
guzebing

