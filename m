Return-Path: <io-uring+bounces-13956-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id 9WcgHIsdUmqHMAMAu9opvQ
	(envelope-from <io-uring+bounces-13956-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2026 12:40:11 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id EC4467413EA
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2026 12:40:10 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="BrOW/QL0";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13956-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.234.253.10 as permitted sender) smtp.mailfrom="io-uring+bounces-13956-lists+io-uring=lfdr.de@vger.kernel.org";
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 48DA130151D2
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2026 10:39:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3B4A3BB116;
	Sat, 11 Jul 2026 10:39:56 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 159E23BADA7
	for <io-uring@vger.kernel.org>; Sat, 11 Jul 2026 10:39:54 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783766396; cv=none; b=nhll5xhpE6v623J6hVsc8m1p+8y2TcKhwVeOjIFdEQIDnqPAJoxg6Nd1BavoTI/Mg3W8tPIbOQIf3VXQ4dpNeqxDAG4mlEiG0kLIG5amBT2UkgJfFVCJfcSo30Bv/eDxps0f5sA0O2WbmQId2SN0xYTwnqVQ2TxgaL6AL547uOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783766396; c=relaxed/simple;
	bh=iLShBTObBjfUKeA+fEjxm1zrMqcpnd1Dt0/78RxIBzc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IYjXdtu1lAaE8lNmhKvptMrmjs5aY4X0bxfW494qyKdR/UYgO3Jmboa7dHhSbl9Vq/HyJE0TI5/XirldAelZ1vVIURc1ZpqhnmVpmRtBVR9VJRlYKk8+IPl+ZVdvy3+ZsCO28VLBbxNWaFeNEp8N4x6ihp3Kz0xkWBWxFKAAmQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BrOW/QL0; arc=none smtp.client-ip=209.85.208.50
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-698beff7178so3135941a12.3
        for <io-uring@vger.kernel.org>; Sat, 11 Jul 2026 03:39:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783766393; x=1784371193; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=aYrkNwa/f9nT5i8NZf+ZzcLIrhDN6BOEIOCenj+efqA=;
        b=BrOW/QL0cO2o4buJbXMtP04RtK4EhuacU5AlGBhUrcOIqIhyLbpKi5L2w76lm5h9ni
         NtlVxq87ByX11DG0F57V+Ihi/W0vDYWjbqXZdvWk+n9wktnZnOK4a3B8bLn4pdEHyutS
         xO71/uqdHuLb6EUL0Y3saF9WSJ3ddduhT3hqtkAppdC5s1Csr6WZK5bXlhSywTf8yunw
         vdKCXEqzUjvJQkTFgfcGw6ddm2k/igX+q5t7YfepRWHUQSGtOCadtBoDQc6u92xgOgbt
         97R1C0gKJgg1vHnupr0uYsKIlDtqxdChripIaG6xAEhcY5E7I9hTbXqAI9/gL3Ie/tZv
         uFXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783766393; x=1784371193;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=aYrkNwa/f9nT5i8NZf+ZzcLIrhDN6BOEIOCenj+efqA=;
        b=QIBVguiRWBoloROpp1nKx8T9Ge2bvEFVP8WdYPUHPgyWXRW7RjU7WEjgpWt61fykax
         r2Z6gqKU96sFbZ5+XHSRwEd0Ic3tgS3m04X78Fc8G7bTP50cHAVGmYN9n1PVe+PQD5z8
         3BL898OWuBDQIbcikbIaThHjuNPx8urnAcDJhLFxxn7ao4xsXyXqU32Y5vvB37q7UEp5
         zCZ3rDWPWXreI4+rEz1lHwcRVyV1urtxvwU7NOSsFy0kny8QkUc2w2C54XmMwOV22xzg
         NbUGIr7RpmR84lbfMQdmhj/gnv8Akp4weoSyvujhz7EsPb6SVTrFQquAPtB+zD5B6FBU
         ULPQ==
X-Gm-Message-State: AOJu0YyfFkQ9+tBoTkVPV3am+mEHSVO9e6mSTtq0/gKK0q/XCo0zgBKp
	BsDCD1pZVChWbcjBwg6/eem0Bw/pg/MpazXkoeQP6lBSn9uu5hXYsGKzIF+r1Q==
X-Gm-Gg: AfdE7ckaG3Old27pvzhtClBjrZ5/47hVhGBetc/D8mCIMjSI55ITIKeF6xdv9ilXx6m
	7QGOfSz2uWS1IIxk39AJeLCpvZGlXIfhQNsdfCKjv+Q0peQbHoimb22MgVetWgNsKN3FfzkXUHm
	iUWa730iBqpnohRBXSva79uabmbBVaFWXulexGLBQYKuyJLg4Z/GUgc040gtyzBMRWcy3X9dnZr
	7/CAlNkfafD4sbyTI29h7QcFaSRKNq4/X2pB5StjQIe4k7Od/fMAtz2+ts6qTkP1z3JJJPXcd+J
	a2D3QLynmq+T3SFDSvYlxc4e4zcLjvavftiWUjfp1ooPaDKtyqOg+SNb0JLOFpZvym7318CXd42
	QQ1LXZJhnbHvrtEju8mjhUpDbM6+iU2+MQelUY/4yeYiL10eKg0elldQWFoKHUs+v3hU5hAetAr
	zWAtDpTfu9sezS9BjwuMOl76Y3P3LwMdhTJdFsmb2PAIJe9ycEPftu+hgV9UzHY9FZEaLsRWtR8
	ODTod8lKjWzrK+dg2Bkmy7FJBBi83Nok98YJ/67TKf50HI=
X-Received: by 2002:a05:6402:3898:b0:698:c1d9:8134 with SMTP id 4fb4d7f45d1cf-69c5f0c7e16mr1115982a12.9.1783766393300;
        Sat, 11 Jul 2026 03:39:53 -0700 (PDT)
Received: from [10.228.209.141] (82-132-222-132.dab.02.net. [82.132.222.132])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-69aa805105bsm6342929a12.21.2026.07.11.03.39.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Jul 2026 03:39:50 -0700 (PDT)
Message-ID: <daa46660-48be-497b-98a9-7784160d9fe2@gmail.com>
Date: Sat, 11 Jul 2026 11:39:35 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH review-only 00/17] zcrx RQ improvements and dynamic memory
 provisioning
To: io-uring@vger.kernel.org
Cc: netdev@vger.kernel.org
References: <cover.1783616211.git.asml.silence@gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cover.1783616211.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13956-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:io-uring@vger.kernel.org,m:netdev@vger.kernel.org,s:lists@lfdr.de];
	RCPT_COUNT_TWO(0.00)[2];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[gmail.com:+];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_NONE(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: EC4467413EA

Looks like the last patch wasn't delivered, I'm going to
resend.

On 7/11/26 10:11, Pavel Begunkov wrote:
> Sending it out mainly to trigger review bots. The first half improves
> the refill queue implementation and improves refilling limits, which
> shows up when niovs are heavily fragmented like with large rx pages.
> The 2nd half adds dynamic backing memory provisioning.
> 
> Pavel Begunkov (17):
>    io_uring/zcrx: scale refilling with large pages
>    io_uring/zcrx: move RQ head/tail to separate cache lines
>    io_uring/zcrx: add RQ iterator
>    io_uring/zcrx: cache RQ tail
>    io_uring/zcrx: coalesce same-niov RQEs on refill
>    io_uring/zcrx: constify area_reg on import
>    io_uring/zcrx: add helper for deriving area token
>    io_uring/zcrx: don't pass ifq_reg to area creation
>    io_uring/zcrx: split dmabuf unmap and release
>    io_uring/zcrx: unmap under netdev lock
>    io_uring/zcrx: split append out of area creation
>    io_uring/zcrx: move freelist lock to struct zcrx
>    io_uring/zcrx: array of areas
>    io_uring/zcrx: pass area_id to __zcrx_create_area()
>    io_uring/zcrx: add dynamic area creation
>    io_urint/zcrx: narrow var scope in io_zcrx_recv_skb()
>    io_uring/zcrx: don't reload skb_shinfo
> 
>   include/uapi/linux/io_uring/zcrx.h |   7 +
>   io_uring/query.c                   |   2 +-
>   io_uring/zcrx.c                    | 445 +++++++++++++++++++++--------
>   io_uring/zcrx.h                    |  15 +-
>   4 files changed, 345 insertions(+), 124 deletions(-)
> 

-- 
Pavel Begunkov


