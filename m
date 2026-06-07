Return-Path: <io-uring+bounces-13630-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id vnzWAjjoJWrbNQIAu9opvQ
	(envelope-from <io-uring+bounces-13630-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sun, 07 Jun 2026 23:52:56 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 6CF38651C1D
	for <lists+io-uring@lfdr.de>; Sun, 07 Jun 2026 23:52:55 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel-dk.20251104.gappssmtp.com header.s=20251104 header.b=EOuRu+kl;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13630-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.105.105.114 as permitted sender) smtp.mailfrom="io-uring+bounces-13630-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=none;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 77D233006F25
	for <lists+io-uring@lfdr.de>; Sun,  7 Jun 2026 21:52:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C16E330D23;
	Sun,  7 Jun 2026 21:52:52 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f45.google.com (mail-ot1-f45.google.com [209.85.210.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51FFF30FF36
	for <io-uring@vger.kernel.org>; Sun,  7 Jun 2026 21:52:50 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780869172; cv=none; b=CeOeNOWOdpPBZBl0zLrhZQxJK6GbRYArofO/rxhQ/DeTJHK/2QSJsqvVlBU636XBpL3ilqlmf6VL/c0dBOYTTNfwzz9gaK4xbQZBWpblp1cCjpFpzcc/7b6MejHViWnlqOzidPObYDyl1fShCvSQ5hBKAGVLzWCutVZbnr+n/lE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780869172; c=relaxed/simple;
	bh=VMy1dZmfUA5UZgNMJi9p32GTQf9/JqJFmX1Zue6eSK8=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=RCIdr/A3/IA4Sk5LCGclmaUEYCo0yFLK6GPNlFPYaHdu+TDWieD1nipWO5SJMDsK7hgigW0BC3B2PV7CVMNtIYKInS7cHXeQQP/LieC2NmLhl2V1gWsxVYdK7j7VdQDTaUAxahQ/axprKpEU/tVc1mhEa9I2E0bMxJNvVVGbCbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=EOuRu+kl; arc=none smtp.client-ip=209.85.210.45
Received: by mail-ot1-f45.google.com with SMTP id 46e09a7af769-7e71b2d527dso648167a34.1
        for <io-uring@vger.kernel.org>; Sun, 07 Jun 2026 14:52:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1780869169; x=1781473969; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=cDuiH5+HkfPGF8muV7E4tlFpe77YBCNs+BTGIbVbpds=;
        b=EOuRu+klLO2jJVxS/M5y7KsSS3LOwX+tF9bHIge4LBv8649kJ/t9EcWmqyRu5OK90C
         OrL0V2Zea8MrzvpJIjYjjZdF5oNLa51Z75BiUPG5FAxqm1YkgOGWkfAfcUKEWkuENECx
         T8ZAHpIiLKbXcGPQxXnn/LMr1zTf2iWWAYkKD78Z8JFaG775ko5ifUqdRHhfIEomNzJp
         9FYs8pLkNyq+MosCtPr0YY45CpeAvDDT6dg/1lSjuEPNBC6Ix6r2Mt9uopzIdMuElTHo
         o5XU/NwBqatuy4+D3Lw0l00uuYFBWATJQGiehrnIfa0KfKuloV3Zc199i/f1xHmQpR5W
         OHdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780869169; x=1781473969;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cDuiH5+HkfPGF8muV7E4tlFpe77YBCNs+BTGIbVbpds=;
        b=YfxZaC3V7w5Ng8+a5vZYXK7kLY8TUa7MKMLVORZutP73tExWP75fQegoswutgrIPAb
         Jhqf2bBymibQN2XFmw4Ror0/+O5cdG/kT/uWdQ0aXZ3Z8ZzpdjMYiIGGPnFq/j+UyZZ5
         Z0hEF3ONUyAXAYqkhfi2RS5rOEulhgp+4HXw2tgKHxh0dyb5aY0F+qPx4orrmb+uhDlY
         KAM3lzyFBVy8PY3/O53sCQ/KbZoDkgv6JCT5JSoAKukiDPuVU9YVC0MgXAjE37bUClkV
         k89g0Kh50ks1mJnVScyjluWkIfITi62tVdhdPpKKWZc7yu1sqz8YyIOWlltsyw9OsYcF
         Vqmg==
X-Gm-Message-State: AOJu0YwoQwXZot9Tv8hGN67cSWJzWb6ijT7GnVlbZnuZExDbi50sAj0o
	GVrZvNiyOdCVi2LTJixkmHwAiCuQlrJP0L6TYMXvzGZZVMh7c6M+mlcXbWAJ5Wqn5Y8=
X-Gm-Gg: Acq92OEP5kw+fCnDH+7UuiGSelbVWL89l14QsiAVYn5hp5ZNyQoXF4zXZkIqVTisoN+
	qpqTGG4RWS5YMmje/ZFYTOxfpBuD8XHifImes2esSjXE5fEbS1iM5rDkp38Z0krLDWAQ0q9IUvC
	3ahL4G5QNrq9GTuCsGcAzcbKyRC+dw8d7xA7O9cyRA4JMxLh/Jlnc4WeI/CbZn2y+xYn9FqW2f1
	GQGt+LtbBCthYzaKNP19JUVCR+3HkKvg81QUTHi3taSatIjSkb1awxj/G7BQyqbBgNGJO/zfCZx
	SpysZa4+XJ0pwSZ0m3KP4wE4b7MyJf1K9qhGqHVbiS04zVJ8CWqZzxKWzKwZ9epy1CqNWWJ1rUy
	ipjbtihT4/dGtryoAZpCsNo0//iC6B3v3nYXphjsIehyjzGgJ9xUXwQKfWZFLBvHYo5JJUOB5Ac
	1U8IvOfEFIwmHZSzEG2mYezaMVcjcjnZxniSzfvooLqdzn2gqw9uXPgJYoNpsszrN0WvcGgnvNl
	BdXWfrIdwfhfE45qXud
X-Received: by 2002:a05:6830:398b:b0:7d7:d100:2613 with SMTP id 46e09a7af769-7e70c603508mr8191077a34.1.1780869169427;
        Sun, 07 Jun 2026 14:52:49 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7e6e7468fa7sm10632133a34.1.2026.06.07.14.52.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 07 Jun 2026 14:52:48 -0700 (PDT)
Message-ID: <c28ab745-cfc4-42ea-bd52-bf3783b0743b@kernel.dk>
Date: Sun, 7 Jun 2026 15:52:47 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [BUG io_uring] Failed RECVSEND_BUNDLE can persistently shrink
 non-INC pbuf ring len and affect later READ operations
From: Jens Axboe <axboe@kernel.dk>
To: Federico Brasili <federico.brasili@gmail.com>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <CAAEr8jbY60noGj1fw_k91UJRBkyiRVoS6=nLhZ7Svwidjn4CAA@mail.gmail.com>
 <71417fb0-4060-4823-8e4f-f216ce0235d4@kernel.dk>
 <CAAEr8jZDdiYB2vp9VJzSqq2J-GssH8GhrLYYn_2W2KAjYwDzSQ@mail.gmail.com>
 <36351bf5-fb6a-4712-ae27-5b907452bdab@kernel.dk>
Content-Language: en-US
In-Reply-To: <36351bf5-fb6a-4712-ae27-5b907452bdab@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13630-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS(0.00)[m:federico.brasili@gmail.com,m:io-uring@vger.kernel.org,m:linux-kernel@vger.kernel.org,m:federicobrasili@gmail.com,s:lists@lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[3];
	ALIAS_RESOLVED(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel-dk.20251104.gappssmtp.com:dkim,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,kernel.dk:from_mime,kernel.dk:mid,vger.kernel.org:from_smtp]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 6CF38651C1D

On 6/7/26 3:38 PM, Jens Axboe wrote:
>> The reproducer runs unprivileged and demonstrates:
>>
>> 1. non-INC provided-buffer ring with entry0.len = 4096 and entry1.len = 4096
>> 2. IORING_OP_RECV + IOSQE_BUFFER_SELECT + IORING_RECVSEND_BUNDLE on an
>> empty SOCK_DGRAM socket
>> 3. CQE returns -EAGAIN, but entry0.len is changed from 4096 to 1
>> 4. a later unrelated IORING_OP_READ from a pipe using the same buffer
>> group returns 1 byte instead of 4096
>> 5. a second READ uses entry1 and returns 4096, so head/bid accounting
>> appears coherent in this repro
>>
>> I am not claiming privilege escalation from this. The demonstrated
>> issue is persistent provided-buffer descriptor length corruption after
>> a failed/no-data RECV_BUNDLE, affecting a later READ operation.
> 
> Right, I believe you already mentioned in the first email. It's just
> a bug that can cause the app to (rightfully) get confused about the
> state of a buffer.
> 
> And it's not a corruption in the sense that something else writes
> to this buffer length field, the kernel is deliberately writing
> to that valid piece of memory. It just misses restoring it when
> the operation fails.

IOW, it's a consistency issue. Words like unprivileged are tossed around
here, but the app could've just written this memory without even the
kernel to do it, it's application memory. There's absolutely nothing
privileged going on here, kernel isn't touching anything that the
application couldn't just have done itself, without involving the
kernel. The kernel _should_ not do it for this case, that's the bug. And
from a quick look, the fix would just be to remove that buf->len
assignment in this case. For the normal case of eg wanting to read 32b
where the length would've been truncated to 32b in the buffer, it should
be fine to leave it at 4096 or whatever size it is. For bundles,
userspace must iterate the buffers when it gets a completion for X
bytes. But the iteration should always be:

	unsigned this_len = min(buf->len, left);

and hence it should not matter if buf->len remains at the untouched
length, for a truncated end buffer.

-- 
Jens Axboe

