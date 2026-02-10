Return-Path: <io-uring+bounces-12143-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8OwNC2Jyi2m7UQAAu9opvQ
	(envelope-from <io-uring+bounces-12143-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 10 Feb 2026 19:01:06 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 652E311E325
	for <lists+io-uring@lfdr.de>; Tue, 10 Feb 2026 19:01:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 31CEB30120F0
	for <lists+io-uring@lfdr.de>; Tue, 10 Feb 2026 18:01:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEDBF31ED80;
	Tue, 10 Feb 2026 18:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="pQ5rPdwU"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f48.google.com (mail-oo1-f48.google.com [209.85.161.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01E1E12E1E9
	for <io-uring@vger.kernel.org>; Tue, 10 Feb 2026 18:00:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770746458; cv=none; b=b7oj6w31ZuUWNqdnVATpLzZCo04g0WBaxz+k6sFXuiMc7zBeGJ/h2e9kVktPzqqzX7jpUVHpGyukMXAPc2vxCp9TpBTDvKrTRHJiL7Idlr+6UMgHDP2yZYzNCTQ/bTlq/MIwBn1+oP6S3v2hidUipVYhjLdFU63rQhSW0Nz26pc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770746458; c=relaxed/simple;
	bh=er72VwDfSI+2eDb+LJym7LDsAMBe46UATWtaDYqIReQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gEwm1LVx9su6yWwdp/n5sw79r8YJEDL+EQ8pXX4c1mvq8ua6PmrTz1hpUaK+6ZbLq4fsCfCM8u7DvGFD+w0Dpf8goI9wu3Va3FWC47m3ZRXn5wDAPKAiNMmIEwuv9T9rW0BRoCIfq71fIQa3NTQA8Y1xRs37FhRMyUCPKiX4QFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=pQ5rPdwU; arc=none smtp.client-ip=209.85.161.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oo1-f48.google.com with SMTP id 006d021491bc7-67242e24be4so876525eaf.1
        for <io-uring@vger.kernel.org>; Tue, 10 Feb 2026 10:00:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1770746456; x=1771351256; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=X3y2dMzcvbiVwpz18dYY5p7GLV+r7073Uyi9rb7xYAY=;
        b=pQ5rPdwUsXLG6Bv9fiJ4GoCT57/MXfxzyefhZtciiR2YqKOJhCbdsoLReBOSf0T3pE
         5hWvyEUoWdgl1je2fWWrWMxafzZfEu71UDsiThlR09D0VRjFplnKTGRB/9p0jge+5Bbf
         FEaRWwYGE0/7qik8nqycQ8HhkEqTz7L+mNoL/QUIDy4eMEJ9Z3hLWHEy/A9xtcxUJFJM
         cVZsswGAVllK6l4QDStyDbjq20oHFS12NA4bkn6RhPjMDUliz+CaHxXeGFTVa9KnDHNP
         aoWocDefJniCaduyguwJq4VA/9WgA/ZloQZ0gm4CJXvt2MG3M7lN68d+CQ+Ch3VkAj4d
         HCnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770746456; x=1771351256;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=X3y2dMzcvbiVwpz18dYY5p7GLV+r7073Uyi9rb7xYAY=;
        b=GaMlypIJbwA0rH9jFcvO7slZ4bi7rVnt/DYCNtKWYUPbwZu6Tk0d/XFUwvbIOC745E
         pUP841Tb9uS9YbL6brBbnLpu+Ry4zAIBVNLRCqKZCzPs6rx8fi8klLBBuY6tqS2jQq3C
         vjUvoUB38mikqbPeM+XmZiT6StPWtritY9unVU9d3cQVFuFIinD3hJDGe7qZsX7Pw2rv
         gnxwQhaOo+/IwZuiRR+pXnJo7aTRf+5JqOUjc+mED4kprqh8AOrJjHAlw4BnWy9k0U7O
         9rCAWp8LRnGLzYY9ai0P4cQmEWxStpte4KG931WjXDbVtET4f1awoTmtDEDM0vc5ubg3
         aiXg==
X-Forwarded-Encrypted: i=1; AJvYcCVTpsV58Mpdyb8xNvD9KZW7Kd70T8IRapoHCInfwzJqiUUk3ZYTGdCVvsvP1WnSkzdy1Jh4CZkqFQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YyHJdLQQOy5s09jpM8wuZ9tgtFVrsLzxIZ/pBcWcT6jdAS8yS2h
	+WW7gBI0sNR0m2j5RXDjw5KF/Td8DRGPFo9b9crm/lRytnAfg9dVgNe1Tg5MTi6yFt4=
X-Gm-Gg: AZuq6aJL4rgD1AB55xJyKs7TijSnKPwrgrrFNaWGLynTtL713C0muay1IamTqbsS/8F
	3L4qsTjmAfI9QcSYxaoUddkkVKoUOKhyq7eQOiBH2GvlxkWsUFxG2utp5GHXpru+lr635MwAA9A
	mRNzD2QbBX7YiHZDniOPERhWGXy8so0mHEcKcvOCrzSRE2nTc1PWkQ3171jYjKfaisd236RMLYk
	OhqW4NW1h6+2NvwEw3hPU3kh9puouHWVv82uKNc6rTQTgRZyxRBceT5vC7kznwWY4Np09WRvLP8
	j34kYfwfQYdw73YDaq1QzUYNlqvdnAuIpne/NXkpjjVByVSiCXZ/2KttlGBVgNVmOmyTkaKQ3PS
	SXd8riVRtFJdLZPArWedD+R1IOziVl1+e43fWgLF/wUdCC6XwyVIY2gUuTxadjEgUFgFInOTvJI
	ahe0kan4CXfFuunxGROhmRsvpHd0Ysw45eq4EaMXFLggSc46xdvwz8n75QW2Gjg0LNaUvMMzDZY
	Bw6euzR
X-Received: by 2002:a05:6820:825:b0:668:d715:109c with SMTP id 006d021491bc7-672fed84b42mr1459303eaf.65.1770746455602;
        Tue, 10 Feb 2026 10:00:55 -0800 (PST)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-66d3b2a75d4sm7939680eaf.15.2026.02.10.10.00.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Feb 2026 10:00:55 -0800 (PST)
Message-ID: <b8ed4d3b-efd0-42dc-8628-2a864b050518@kernel.dk>
Date: Tue, 10 Feb 2026 11:00:54 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 06/11] io_uring/kbuf: add buffer ring pinning/unpinning
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: Joanne Koong <joannelkoong@gmail.com>, io-uring@vger.kernel.org,
 krisman@suse.de, bernd@bsbernd.com, hch@infradead.org,
 asml.silence@gmail.com, linux-fsdevel@vger.kernel.org
References: <20260210002852.1394504-1-joannelkoong@gmail.com>
 <20260210002852.1394504-7-joannelkoong@gmail.com>
 <8826110e-cb5c-4923-99cd-b9f21f536d32@kernel.dk>
 <CADUfDZoiHYKrfb=NxLH=K99ALuDoABCnrOFC4_mZgqvT6qQPXw@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CADUfDZoiHYKrfb=NxLH=K99ALuDoABCnrOFC4_mZgqvT6qQPXw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org,suse.de,bsbernd.com,infradead.org];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12143-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,kernel.dk:mid,kernel.dk:email,kernel-dk.20230601.gappssmtp.com:dkim]
X-Rspamd-Queue-Id: 652E311E325
X-Rspamd-Action: no action

On 2/10/26 10:57 AM, Caleb Sander Mateos wrote:
> On Mon, Feb 9, 2026 at 5:07?PM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 2/9/26 5:28 PM, Joanne Koong wrote:
>>> +int io_uring_buf_ring_pin(struct io_uring_cmd *cmd, unsigned buf_group,
>>> +                       unsigned issue_flags, struct io_buffer_list **bl)
>>> +{
>>> +     struct io_ring_ctx *ctx = cmd_to_io_kiocb(cmd)->ctx;
>>> +     struct io_buffer_list *buffer_list;
>>> +     int ret = -EINVAL;
>>
>> Probably use the usual struct io_buffer_list *bl here and either use an
>> ERR_PTR return, or rename the passed on **bl to **blret or something.
>>
>>> +int io_uring_buf_ring_unpin(struct io_uring_cmd *cmd, unsigned buf_group,
>>> +                    unsigned issue_flags)
>>> +{
>>> +     struct io_ring_ctx *ctx = cmd_to_io_kiocb(cmd)->ctx;
>>> +     struct io_buffer_list *bl;
>>> +     int ret = -EINVAL;
>>> +
>>> +     io_ring_submit_lock(ctx, issue_flags);
>>> +
>>> +     bl = io_buffer_get_list(ctx, buf_group);
>>> +     if (bl && (bl->flags & IOBL_BUF_RING) && (bl->flags & IOBL_PINNED)) {
>>
>> Usually done as:
>>
>>         if ((bl->flags & (IOBL_BUF_RING|IOBL_PINNED)) == (IOBL_BUF_RING|IOBL_PINNED))
> 
> FWIW, modern compilers will perform this optimization automatically.
> They'll even optimize it further to !(~bl->flags &
> (IOBL_BUF_RING|IOBL_PINNED)): https://godbolt.org/z/xGoP4TfhP

Sure, it's not about that, it's more about the common way of doing it,
which makes it easier to read for people. FWIW, your example is easier
to read too than the original.

-- 
Jens Axboe

