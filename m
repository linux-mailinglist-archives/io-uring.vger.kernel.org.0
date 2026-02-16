Return-Path: <io-uring+bounces-12236-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mIJdLfQCk2nF0wEAu9opvQ
	(envelope-from <io-uring+bounces-12236-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 16 Feb 2026 12:43:48 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 48EAE14314A
	for <lists+io-uring@lfdr.de>; Mon, 16 Feb 2026 12:43:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 17EFD300825D
	for <lists+io-uring@lfdr.de>; Mon, 16 Feb 2026 11:43:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 254223033CE;
	Mon, 16 Feb 2026 11:43:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QMl3rsNJ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B869030276A
	for <io-uring@vger.kernel.org>; Mon, 16 Feb 2026 11:43:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771242216; cv=none; b=a2qZAYBoGCpMDcmIJ/Wc5qSaHXDplDgn71qknzQ7/XBQUe4eZGTfoUnpp92thtk47aNxsmx6Qj/Y2hcnzypyWkzG/g2ZMVJH1yykntD3kCEnOOLDF+nlNhriIC3+L2v43XypSFSrfV8WtsBIzUlaVWbSj+S7UmXLe9ppqI25VDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771242216; c=relaxed/simple;
	bh=cq7nRGLMyx2jaeKs9rHbLE63UL5qIOpnOZRhJ+eoUIo=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=ikqRMfD2KXybXS+gXH3HlozbBbYdUTkBduXfpVe+4wEL4CeT3f0CDh0Wcg8Xqe0CxMP2hKP8ooHo7iQeT7bUWKvzyziIcTTcUrD+j4Fpoe2bPz6d0fFHstSwNJEIUCACYFF5Xv08/lmayDGNG4EpnFpnHl38xwpeNFKRPUPLiJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QMl3rsNJ; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4834826e5a0so29908015e9.2
        for <io-uring@vger.kernel.org>; Mon, 16 Feb 2026 03:43:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771242213; x=1771847013; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=f19oFcoFmeHgzYGL/7Btsolmci6MMTtjnsZ+q0mt5wE=;
        b=QMl3rsNJJSs449S1M0aesUHgjU0a1MyB/2rRLfmGzWFSpQCwDqfcDbGyYU36UW4Tbr
         jmvsunL+Xccrcj2PSGU8P5uD03a2iO5BtT4BE/a3UqZtxaTjKjpDVcsaxYX3rP8G4+rd
         ovUZ8uVUGTC/z+ug1FLhko/+Hb0xvuVkjfU2Fb/TFNtze6Hp98j2iGM0Qete6vkIVNCL
         cA70eoPe0oyLIi4nXoyZ69AuDmPZrK76b/8Ginmbh/ay9k5ycw+eUSZxLXCo0o/o5zZo
         /AmxkGEjZJJLZ4KU+4XzPJ0ctrPhDIQvDTpvhdFbTXR5SYuHeJixZwnIiIrVuyRbxyM4
         9H7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771242213; x=1771847013;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=f19oFcoFmeHgzYGL/7Btsolmci6MMTtjnsZ+q0mt5wE=;
        b=lf4oYt2cRUJzys31AIEROlpNu0aYXCcIGY18iC5aTIm4wGcK3SJljwwvPKBmFxgEAj
         LRYnaImT2uVrxXnQRHk/Wtjci+dXSrvTiKNeQRqp2ylpJj34d2xBi6tLLB8QP4eD1Pwn
         5Tm25j0YhKUprU37tdxdDWi/j3RXkr5k55XKopel8wPnrOq2gDwDyCj95+jbtfPjRMmg
         w8oQfiG70y4CNPXI1y5rHx/i0LWQcsXWor7+GT4AQU0u+IAU2YsSfWKdpoDYBVFy2Q2G
         XZsHLFk43JnzvCTN/Myu0zmw1IBM07AufiUDIfL/OvBl4R5S4krOkdk4BxcmxbFOn03m
         r3yA==
X-Forwarded-Encrypted: i=1; AJvYcCVZjop8+BSNydaSz3stdx/rpUMviyPBdM3gglFIHxGoh7cZ+Fn9ksIKd7/uqL2GhhJLTPKXZN9EeA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxImU7SUcXxC7GyLbYkUOmjJ6LmP6iUsK036ERnxN5kiqgIC3Rt
	k1quEBYLp0o8knmKdkAxX5QcF5E8STABB8uE+hnjgDOlNrFUvZcvkpgZ
X-Gm-Gg: AZuq6aIQZz4dYzMZ6SlDvkRGvzqokPz0L1R2QYZGYe3J2sSVcx4p+0RyTAAPygyip6E
	TbK0nqo5lBsdFqoCmK6KwxhcasAfQ3egeuMyj5l1d37Taa+pPXSgbjSuPAUz1o5unV4+zg9um1r
	WqwoivD9qmBFDQED7PvUlZ5ePT9sf3Nn2eUCt9tv25lHq/3CEjBP/RWwNHU/0c3knFnN2DNlmLh
	KTA93pJT1ua/psOuDgRl3jhlAVkV2hyTjG344vCmHulY8+Qp8c3lTE+sonKJK8Qkfgypf1icAj8
	RnMM6GsR58YbQyuMt+/Jsam5+Hk1WK2jfvAM6Mcj+EE20G613jgpOPmyJBZZSNX3pxlWFZDCfsF
	MkqBLlI2/f3IV+AGAb8+kvGsAQ/t908PQ+gv9b7202EL9Y4O5HKOaq+rXBq0Aw5hJF/mxu4FuOU
	+jKEbbZkXGxGPfhCN7G42t80RSkTI+T6TmNs5XXvipOhxgPXNuUPV97eQD8BFrXhRgHnqxWodeO
	em8ya0WwCZzLpJjfjMkJyTnkM6tNuTqk56jf1xG268ETB8mdoNwH9F0BQ==
X-Received: by 2002:a05:600c:5296:b0:482:eec4:74c with SMTP id 5b1f17b1804b1-48373a5d771mr159249405e9.22.1771242212931;
        Mon, 16 Feb 2026 03:43:32 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:c3fa])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48371a2392bsm153141285e9.6.2026.02.16.03.43.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Feb 2026 03:43:32 -0800 (PST)
Message-ID: <d3c656f6-5ca3-4fc3-b734-25547aec4741@gmail.com>
Date: Mon, 16 Feb 2026 11:43:29 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: remove unneeded io_send_zc accounting
From: Pavel Begunkov <asml.silence@gmail.com>
To: Dylan Yudaken <dyudaken@gmail.com>, axboe@kernel.dk,
 io-uring@vger.kernel.org
References: <20260215231523.308665-1-dyudaken@gmail.com>
 <c8c715e9-1aa3-48d1-b080-8844be893571@gmail.com>
Content-Language: en-US
In-Reply-To: <c8c715e9-1aa3-48d1-b080-8844be893571@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12236-lists,io-uring=lfdr.de];
	FREEMAIL_TO(0.00)[gmail.com,kernel.dk,vger.kernel.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	FREEMAIL_FROM(0.00)[gmail.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 48EAE14314A
X-Rspamd-Action: no action

On 2/15/26 23:39, Pavel Begunkov wrote:
> On 2/15/26 23:15, Dylan Yudaken wrote:
>> zc->len and zc->buf are not actually used once you get to the retry
>> stage. The buffer remains in kmsg->msg.msg_iter, which is setup in
>> io_send_setup.
>> Note: it still seems needed in io_send due to io_send_select_buffer
>> needing it (for the len parameter).
>>
>> Signed-off-by: Dylan Yudaken <dyudaken@gmail.com>
>> ---
>> Hi,
>>
>> I'm reasonably sure this is correct - but I think Pavel might want to
>> double check that I did not miss anything. The tests seem to pass with no
>> changes.
> 
> Looks good, I'll have a look tomorrow

Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>

I like the change, and we should get rid of duplication between
send and sendmsg on top.

-- 
Pavel Begunkov


