Return-Path: <io-uring+bounces-12243-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mGMZE1spk2kI2AEAu9opvQ
	(envelope-from <io-uring+bounces-12243-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 16 Feb 2026 15:27:39 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A08C2144A48
	for <lists+io-uring@lfdr.de>; Mon, 16 Feb 2026 15:27:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 43D8E30459FC
	for <lists+io-uring@lfdr.de>; Mon, 16 Feb 2026 14:23:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A011B310774;
	Mon, 16 Feb 2026 14:23:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="itcbTZv4"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DAEE299937
	for <io-uring@vger.kernel.org>; Mon, 16 Feb 2026 14:23:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771251812; cv=none; b=pm2mR+REvQ0yw3GzVqKk8KYcilsohqQJe4zWSJQ67sQCTd0KeklCmR0kCkAKIdb2zWUHzs7gI0SZmkve5MxucjqkrhzZ1d8wz+SVCcE+VVURzkThfMxpoSiqUrEQ4BwemG18iTeqRuj/N3kVFixJ9APNZgmGiu+sYOBUFk/NzoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771251812; c=relaxed/simple;
	bh=mfggzwf4B24n5rxC+2Kqv+0KmscCssNKpMcRD6aHq6o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RAZKT6Ig40NdWi93DyBVrYc++379UqjjW2+jfRS+4mcXp1ARq7e5/F1FHZS3RuX8mCetGtYOvNB5ihZAuAOARXtxN6860YDFjbJo2qjl/l+VLCoCUYHn644upshebg2TfoK38b25WgMPZi4cvcRWgySkS9yjbom/xgjME/akIAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=itcbTZv4; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4806cc07ce7so30486685e9.1
        for <io-uring@vger.kernel.org>; Mon, 16 Feb 2026 06:23:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771251809; x=1771856609; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cZfg1XdomPhbX+ZkmR1M/ky2W6FGRkuZqY2dALiobXg=;
        b=itcbTZv4gdVVHgjZ2caaTRvz8oUFs080vuvSjWimuxqZLDAQRiy+2y7ln8MEv5ppXR
         gacvBYKyZUGYinTQc8AEN04NPUn6fndlJ6XwnrY0uMQhKvHGgfNC+4ZS20N5DVMKYGVE
         1y0bUGh9BwPHYyGZx70yWpebzzEgKzwIxYowkEZLUw74yNsKCUUwCQRY1RW7dOy+IXUX
         lEgCyNSBzRRdBd2UZwjq8KWrSFDiD3tTgYHxAaULwt0Un0KpPhMDsn5GBNZbqpZ9Za4q
         xzrDk11nN2ICr6aOV1kAgyM6MgPj9qcX9UkDA+UZb4x6/B6iAJbBpRVZO8/HXWJYITEi
         5JrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771251809; x=1771856609;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cZfg1XdomPhbX+ZkmR1M/ky2W6FGRkuZqY2dALiobXg=;
        b=wiQYLPRqON/Xa686f67LTB7SSpTmxnGsuT10SiFnxBRrMDG9bY5rlt7lvtYpbEbpfa
         zCBMdoIGCh/uQXjkDtrA1c1W7ppM0HoOBlub5LYJ7q2+J91vTvsiKUu8eStl1W13aIxX
         u6/vOnJBiP2QnOZJMuNrwnRA9LzzWR5sa8r3i9zhb1f3q5Z3ug0aFjvqGfgZVCD2sYkS
         zOIpLIgaw9ID3lJpoRXo5K4xZZomjmEEAIBAjs7PGFN3F7gx7AlT/iFzMwuv0SNL84Ah
         0KcQTVcPuSscdTpYcAdZtZVLppcKN++YBUK4nZ9369bYcPaukqmNzOF/AhIZdDVMoUGA
         MvQQ==
X-Gm-Message-State: AOJu0Yzo6zpWmhLZNh56/3pvFD/LrI5NElxAFwSsrKb3VbR/Zc/qOP/I
	eWkFB7HBK0P+QqEsId07burECV19ws5GJcgXr39jGhvTY2wLnF7FHNbdJy4XzEaY
X-Gm-Gg: AZuq6aJSSFu20UvBzx6QVAJuiVyrz9QWESQvR16LSj+YwDdfKwaaauZ8ms7JyJu/70m
	gnCkUrJBFDMvydofzbSJI7Oncc+ptB+fRy24AGhcBIwpXbtzUoXjVZ7GyElYcrPWROnzhAY/CK/
	QEjY4SlhdPfDzrTBPhYwN2CA5SldwYAaFC674Ao4m1KVH7GeuOPBfVZ2D+LTxtcRav+L2+81yd9
	Pllj1ZprElmBUPnsKS6W+ahfjEd5Fj23gRhM/Pm4RA/3Mjoc0hitQYNCwqY/7CoLVkPjqX9xe6p
	3P6XFz24C32Vw9huTbwbjCyyJ9PH9NjoJU9tFLebamQIvwb4JA21z0B3zTtDDebP5ly/1uvWSe6
	jPcH1uUMc6tZldhn4ffI/s3a7iyvtg/Gh6A6mCWs2mim3v5NkMmeOpDuQQbipgc2v625aJJa5Tx
	K60jnuwtkwm/AwIM6uAePILDVkZqi1jlHBgX72dsKBe5ALLPZIoyFvtsRKI8bNB8YRXbZRYrVOJ
	d6pWj3Jbq3S537ZN/6G7kQRviwQYzb45IpMD/tELvWitPAL7h3frqezAw==
X-Received: by 2002:a05:600c:34d4:b0:465:a51d:d4 with SMTP id 5b1f17b1804b1-48373a1611fmr180172595e9.6.1771251809077;
        Mon, 16 Feb 2026 06:23:29 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:c3fa])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48370a3eb7asm130801345e9.1.2026.02.16.06.23.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Feb 2026 06:23:28 -0800 (PST)
Message-ID: <d56b5f70-382e-4017-81f4-c9ae7a6c1b56@gmail.com>
Date: Mon, 16 Feb 2026 14:23:26 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH io_uring-7.1 v6 0/5] BPF controlled io_uring
To: io-uring@vger.kernel.org
Cc: bpf@vger.kernel.org, axboe@kernel.dk,
 Alexei Starovoitov <alexei.starovoitov@gmail.com>
References: <cover.1770836401.git.asml.silence@gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cover.1770836401.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-12243-lists,io-uring=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,kernel.dk,gmail.com];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	FREEMAIL_FROM(0.00)[gmail.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: A08C2144A48
X-Rspamd-Action: no action

On 2/11/26 19:04, Pavel Begunkov wrote:
> This series introduces a way to override the standard io_uring_enter
> syscall execution with an extendible event loop, which can be controlled
> by BPF via new io_uring struct_ops or from within the kernel.

Let me know if there are any concerns or comments. There are some
parts that I'll need to add like timeouts for waiting, but those
will be natural extensions, and this feels like a good base to
move forward in general.

> There are multiple use cases I want to cover with this:
> 
> - Syscall avoidance. Instead of returning to the userspace for
>    CQE processing, a part of the logic can be moved into BPF to
>    avoid excessive number of syscalls.
> 
> - Access to in-kernel io_uring resources. For example, there are
>    registered buffers that can't be directly accessed by the userspace,
>    however we can give BPF the ability to peek at them. It can be used
>    to take a look at in-buffer app level headers to decide what to do
>    with data next and issuing IO using it.
> 
> - Smarter request ordering and linking. Request links are pretty
>    limited and inflexible as they can't pass information from one
>    request to another. With BPF we can peek at CQEs and memory and
>    compile a subsequent request.
> 
> - Feature semi-deprecation. It can be used to simplify handling
>    of deprecated features by moving it into the callback out core
>    io_uring. For example, it should be trivial to simulate
>    IOSQE_IO_DRAIN. Another target could be request linking logic.
> 
> - It can serve as a base for custom algorithms and fine tuning.
>    Often, it'd be impractical to introduce a generic feature because
>    it's either niche or requires a lot of configuration. For example,
>    there is support min-wait, however BPF can help to further fine tune
>    it by doing it in multiple steps with different number of CQEs /
>    timeouts. Another feature people were asking about is allowing
>    to over queue SQEs but make the kernel to maintain a given QD.
> 
> - Smarter polling. Napi polling is performed only once per syscall
>    and then it switches to waiting. We can do smarter and intermix
>    polling with waiting using the hook.
-- 
Pavel Begunkov


