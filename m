Return-Path: <io-uring+bounces-13921-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id AUaUGuRxTmqcMwIAu9opvQ
	(envelope-from <io-uring+bounces-13921-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 08 Jul 2026 17:51:00 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id E139572848A
	for <lists+io-uring@lfdr.de>; Wed, 08 Jul 2026 17:50:59 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel-dk.20251104.gappssmtp.com header.s=20251104 header.b=mjGDCQ7O;
	dmarc=none;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13921-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.232.135.74 as permitted sender) smtp.mailfrom="io-uring+bounces-13921-lists+io-uring=lfdr.de@vger.kernel.org";
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 5B5A9301FF36
	for <lists+io-uring@lfdr.de>; Wed,  8 Jul 2026 15:50:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D86637F8DD;
	Wed,  8 Jul 2026 15:50:50 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f48.google.com (mail-oo1-f48.google.com [209.85.161.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DA74373BF8
	for <io-uring@vger.kernel.org>; Wed,  8 Jul 2026 15:50:47 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783525850; cv=none; b=VVKLDrJw4ijF/hRmZefoE9ZyffKW6ZWYaM1vg55a6o/y7Y+4gIQpirXdhyUEHn9Qg5a6SI/JndxXEhEqaVvZabKW8WyygsT3CkdJX3fdgr3ANayJwpUV1uNNGU7khRXyDo2ObROaNCAYkzHu7o7gP8gPtZXz/sL39jlCD3iZBtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783525850; c=relaxed/simple;
	bh=W+9LTNT3r4t1s73YprNuG5DwYdgfPjuZSmgyXHRohEM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pzCJyrIDsA+PKXfF6THAbDyf+Fo7lDSFts3PCwAb+IMviTrvfMKfVwK2UgZFNSYOyXf+p3YL/y0rO6wxsdEsh/APUnlc4s3OGDrWxK4bdH5jz54NnR7d8NWbkbAZ6LA51pYR8/d2iA42RIDX4fqH2iw0KE2NpmXGYXAO5Vp4MHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=mjGDCQ7O; arc=none smtp.client-ip=209.85.161.48
Received: by mail-oo1-f48.google.com with SMTP id 006d021491bc7-6a1160a2c42so493460eaf.0
        for <io-uring@vger.kernel.org>; Wed, 08 Jul 2026 08:50:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1783525847; x=1784130647; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uwINqnUpR+2ewKtt6aPXAWXCQ+z8muVF+g3BPgX9RZg=;
        b=mjGDCQ7O/jaA/0O9/iWrQ1QH9tm9Lt/5DdVLhS7BeP7O/YclteaMBVz4nrSq0Edleo
         s0nngqvzqlOQ9vKx00W4QJDu8eWHcmZz1ct3ro0BkHXZ7qoxINtrR53/v/iyxosO0qYm
         +dN7WFVM6vxuhiVi1BjWBBmeeyAsmA/o2hNZeZH+7Z49rWmBjtjVktLvOk0eMvZ3aNff
         wT7l65zy+F76vKoHrvXmMF5Cxlo5HCAa+IS/xSM1WfU2uX/mUka3z5vzmR25GWSrfW6Q
         6UWwyTIB9LI2H3d2FTiSCfogqGqpW7Fz9jZunxVrh/kd9T4ydYsifhoJZr3ljYoeNI9d
         uyjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783525847; x=1784130647;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uwINqnUpR+2ewKtt6aPXAWXCQ+z8muVF+g3BPgX9RZg=;
        b=JhVEB37VW1kp/sdiT4cXlmR+bRJC4K/Tfqyrr3ciKraNR6G57E4LNGxHd1c+8Z1jsP
         9UNtkU18ed1FJtiQbvpYf+YhkO/Z6zH9jN/007z5ygdtmL2XOU6Nt1dDcRXYJp6Nei+2
         KIZPVf1/lLKxOep6tjjt82480Ode5v5gIzhgSTbw0246jRRF6pVwjCcQD9m+8uMCe57r
         N0nffFIctIiNbBKzhAabJNlASJPWlsUM0D2/3NtRzcLnJgs388MFmN+uUsjM+lAUR4VY
         nAybs5hwvP34OuWLWPhIrV3sMYgI50yUqci1/+uubaPHiH2UyCq88h70vBtN7UCjhCGw
         bf5A==
X-Forwarded-Encrypted: i=1; AFNElJ8e4r6yOQxlTU2epjBQreTDVv/2AKlDFxYghDZSxsvLA4yk7r9e9WPM6b+pfOEFmm+TWfDlzTsInQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzcoTFazT8NlCQs4NbzUmEA7nn+ytwbh49CEraRZN2i8VIz7JBr
	ULea1SoT3x3GAZCFB0pj2GT9xmWMBFU/Ay99MdBxB1OPkzR/B0iQxVzWvZ5fIeUsp8I=
X-Gm-Gg: AfdE7cmHNYqmU53wUaotT4gOElHY94Zp8/nw9M7mWX5QNxJBqNjMQgpTZ/5vAqT2vtq
	5e2uJrg92Ulg0zItgCKRtfWMPr5pyRheuQfuo12t+bxzB0O+jg43kkuXlUZeFb9deNzjSEHzEBB
	rq9UX4LVDaWT97JK0tUvsu+dujvz8dKYnpbEm1DlReouWNC+xEdj2eQFD8Pn+2TjSNvWJ2S+chC
	iFZKK9HR4F172UKrLL6JXbaOECCQC+hV8HNiWnlGQGFcoz6GgWhRE+BrA5CIBGVb4vupA98g9a5
	OhsUwizWCRu7TZJn0woHJGzPSOv84JkIDn+0oxqY4P81q+WclRWDM40UiAgoZyNOaH5I2cryBe5
	yoiF3AjRip6raUpWErqEQqsxLJOTfUfJB53m8yKmPo2uag+vkJqMmL3lc8Kc9bVgyjyFWVeSfDh
	OzHY1N84YWo7kWxYauMzC7aV2G34sZDvIBVA4wnXwbey0TcdNaBEPOkWNHV+vMFI1T3Yjq3kc=
X-Received: by 2002:a05:6820:2915:b0:6a1:3dd5:adf2 with SMTP id 006d021491bc7-6a36da8fc74mr2075423eaf.53.1783525847011;
        Wed, 08 Jul 2026 08:50:47 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-44cfb1d1ff0sm17018155fac.7.2026.07.08.08.50.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jul 2026 08:50:46 -0700 (PDT)
Message-ID: <18ebc6be-f76e-43f5-ba73-8ab4f83c3b2b@kernel.dk>
Date: Wed, 8 Jul 2026 09:50:45 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/net: clear stale vec on buffer peek error after
 expansion
To: Gabriel Krisman Bertazi <krisman@suse.de>, Feng Xue
 <feng.xue@outlook.com>, "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 Pavel Begunkov <asml.silence@gmail.com>
References: <SY0P300MB0070983BEEB976B8F46E3D4790FF2@SY0P300MB0070.AUSP300.PROD.OUTLOOK.COM>
 <87ldblwkm5.fsf@mailhost.krisman.be>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <87ldblwkm5.fsf@mailhost.krisman.be>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS(0.00)[m:krisman@suse.de,m:feng.xue@outlook.com,m:io-uring@vger.kernel.org,m:linux-kernel@vger.kernel.org,m:asml.silence@gmail.com,m:asmlsilence@gmail.com,s:lists@lfdr.de];
	DMARC_NA(0.00)[kernel.dk];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_TO(0.00)[suse.de,outlook.com,vger.kernel.org];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	FORGED_SENDER(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13921-lists,io-uring=lfdr.de];
	TO_DN_SOME(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	RCVD_COUNT_FIVE(0.00)[5];
	ALIAS_RESOLVED(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	PRECEDENCE_BULK(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,gmail.com];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	RCPT_COUNT_FIVE(0.00)[5];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,vger.kernel.org:from_smtp,outlook.com:email,kernel.dk:mid,kernel.dk:from_mime,kernel-dk.20251104.gappssmtp.com:dkim]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: E139572848A

On 7/8/26 9:45 AM, Gabriel Krisman Bertazi wrote:
> Feng Xue <feng.xue@outlook.com> writes:
> 
>> Subject: [PATCH] io_uring/net: clear stale vec on buffer peek error after expansion
>>
>> When io_ring_buffers_peek() expands the iovec array during a bundle
>> recv retry, it frees the old array (A) and allocates a new one (B).
>> If access_ok() then fails, B is also freed and -EFAULT is returned.
>>
>> The callers io_recv_buf_select() and io_send_select_buffer() only
>> update kmsg->vec.iovec on success, so on this error path vec.iovec
>> still points to freed A. The stale pointer survives into the netmsg
>> alloc cache via io_netmsg_recycle() (vec.nr < IO_VEC_CACHE_SOFT_CAP
>> so io_vec_free is not called). A subsequent bundle operation reuses
>> the cached hdr, sees vec.iovec non-NULL, sets REQ_F_NEED_CLEANUP,
>> and passes the dangling pointer back to io_ring_buffers_peek() ?
>> which writes iovec entries to freed memory (use-after-free).
>>
>> If the alloc cache is full, the alternative cleanup path through
>> io_clean_op() ? io_vec_free() kfree()s the already-freed A
>> (double-free).
>>
>> Fix this by NULLing vec.iovec and zeroing vec.nr on the error path
>> when expansion occurred (detected by arg.iovs != kmsg->vec.iovec).
>> Do not call io_vec_free() here ? A is already freed by the expansion
>> block, so kfree()ing it again would itself be a double-free.
>>
>> Apply the same fix to io_send_select_buffer() which has the identical
>> update-after-success pattern.
> 
> cleaning in the caller makes the issue much more likely to happen again
> in a future use of this function.  It would be better to fix the bad
> semantics of io_ring_buffers_peek instead.
> 
> In fact, this is exactly the point of this patch, which I believe
> already fixed this issue:
> 
> https://lore.kernel.org/io-uring/178338543579.49877.9882374687710864124.b4-ty@b4/T/#t

Indeed, this version is just a terrible LLM version of trying to fix the
same thing, but not understanding the issue.

-- 
Jens Axboe

