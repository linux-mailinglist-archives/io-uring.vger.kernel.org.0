Return-Path: <io-uring+bounces-13285-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0KCDGjsJA2pmzwEAu9opvQ
	(envelope-from <io-uring+bounces-13285-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 12 May 2026 13:04:27 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id D600451F07C
	for <lists+io-uring@lfdr.de>; Tue, 12 May 2026 13:04:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id F224A30398BC
	for <lists+io-uring@lfdr.de>; Tue, 12 May 2026 11:02:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0B76382F30;
	Tue, 12 May 2026 11:02:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CMGI6aSI"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7D4F37B007
	for <io-uring@vger.kernel.org>; Tue, 12 May 2026 11:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778583776; cv=none; b=GNaPEG/zfBwG8Pq4P58LlQOPk4lr/jMLRSwTRvfHDoA20TkMBC+eX1P4ftRDI26IF9rwk/nrp+YHtgA+L2H+FwjuKpJjFMLAT5pQQIIa9PQeEc5+PERzPgtfWGi+W6jICaDbm6U7AQz+Y0p3bgoENLNREU3dlOQ+Ys/Zh/eid5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778583776; c=relaxed/simple;
	bh=Ga5JPf6n1jpdDjVA+pd1zKMfPwv8abcvqFDXHuktbVA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kPZ8gnH97GXXWws1cu9FX0wjOWupfCa8rotYOID9KouWB2fBEnSz67AhmaDt3D3CMaSfdfS+GLRa+8cJzx25nVImYmrCIKPTb7o3/eJJWWfkNIISeX+pkmjyZIAMcQ3wJ5INYuxXejBdltB4O2qcPJ41HljLDgPGDBJh1kTT16Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CMGI6aSI; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4891f625344so50486455e9.0
        for <io-uring@vger.kernel.org>; Tue, 12 May 2026 04:02:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778583773; x=1779188573; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FFGUETPgm26h9XFyqe9suVV5/326pTXPraqjVQBHotQ=;
        b=CMGI6aSIa1QSUGEppO5DZE5bStYL/YvJxZ/qJsxprMZcqpr8jjcRldFTgDdmLikjRE
         3BnhZVQ38O8BBjeXER+GjcK13KWR8cV5Tp/jEfXjg+EGafjTy4NmUt3qe2tSG2sLzdMt
         +RWW76NNBeEe4ZR1P5NHKWyUaTlbPZDXLFkq6UEBFkThTiH6vzhf0zT6YtiUeAqvWzTe
         yIA/lz68/8Xbwmz9hW7HA41UF/9xcIqS6nlFjjKXFZXPdZjXTSgTN0XaPpsO5IxOaqF6
         u2ItGLIvsJhnqkeJN0wFNvCnY+cJGITxtre4L9T+lf6IN6JXzImjg4Cnpslix/VXYglj
         Teow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778583773; x=1779188573;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FFGUETPgm26h9XFyqe9suVV5/326pTXPraqjVQBHotQ=;
        b=I0HklQY7scVSD8qk39ZPHtYCWPR4xmXKItZa9cMjdubHhn8y/vwr5Dpd1pIHhiy6+6
         rAak6cGOd6WHdaqvsfy02AfWeZNozLmqB0zjTzNkGspSjv2t3N1xbe71Uk99LTcdiyER
         rnceIIp5R/f05o8yYW/mhD2bIFgsZBz9RDZ2mM9WVwV+xb4LjtOYxWq+5vlyJvdet6pj
         pnKQyDKGfL6bh1yxvsHTuBes0bSNy7pyLB4qKkct0Qev+qI76AwbBYcOJhmjNu0T8t2s
         coduBAklRoosQejubNQGsHwTgZwOSikewRvU8LHHOzxCiV9AKDDfHC/7URWj42fVI4tt
         M+sw==
X-Forwarded-Encrypted: i=1; AFNElJ8IS1qJtqomBQyLHQGyv2HSnrWoSYpcLMTAnNwv5HdDFRTdewQ7eHU2ynXyTJepg0bsGI48VcDvmA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzhYSDQI+Z6jR5GX1qvtvE506KtxPMGyS8nEaHiNGe+GwdQZvlv
	HPbipW+CwT7grw6tB+KX8lBk8NaOvAOcTLMk9gTUcJ3PuiApwQGcHDKc
X-Gm-Gg: Acq92OHZ9qr54LDFm6opIRI1kxHXNg1rhp/QYbnsEwl/dMqVIJQd1Ui8Dhznkr+EMYC
	hpYNjL5pitD2kx11Rj3/ALVzxu7/YsDDGrliiGfEYurEyjEHmFQ1N25Ih2nBHzOXieKG9GN7h2M
	c9FY3rjnIXKhFme4ya5x8iNuYDvUn1W+vet9RfrlQGBnxWdXmlgk1Q8jZN/06O0soXFLwsE0F18
	R5CyCq6gzQF4pUTCA/6KFo/Uf+QfDkNu9MWulnqpPP2OQdu4ZAwPg/kKl6OZH5mxH7df7uskoxk
	sp17iiAz1iOZAfDVwltLEOYH6UsxFfZjnya6bEJNRRmtG4q5eRuHPY5NFWjGj6L0+IO7ICZfiM8
	/rt5IB+OQkDG87ybUz50aSw+dpOc+vUc3vdfRtvE+lpL/W/09JIpm5hd2LIiBq5ZbkjNZbKsTx+
	1mfwpE2ob1p2lGkfFMbj0aK1YOPSxfo1mvvUQPCmfc0f0ZZfw8pCvfHvmBOKyB6U2IfinW1rOEW
	1ClSE5SZnI15z/uqGvSCwmoQA15R/gPltRwobM=
X-Received: by 2002:a05:600c:46d2:b0:48d:50a:6ef4 with SMTP id 5b1f17b1804b1-48e8e210753mr44805285e9.11.1778583772968;
        Tue, 12 May 2026 04:02:52 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325::372? ([2620:10d:c092:600::1:8c90])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48e8f3e174fsm23962585e9.3.2026.05.12.04.02.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 May 2026 04:02:52 -0700 (PDT)
Message-ID: <539e235a-2027-4bda-ae26-00200c53cbaa@gmail.com>
Date: Tue, 12 May 2026 12:02:46 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/5] io_uring/zcrx: notify user on frag copy fallback
To: =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@meta.com>,
 io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Simon Horman <horms@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, Vishwanath Seshagiri <vishs@fb.com>
References: <20260422112522.3316660-1-cleger@meta.com>
 <20260422112522.3316660-3-cleger@meta.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20260422112522.3316660-3-cleger@meta.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D600451F07C
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13285-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[gmail.com:+];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCPT_COUNT_TWELVE(0.00)[15];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,meta.com:email]
X-Rspamd-Action: no action

On 4/22/26 12:25, Clément Léger wrote:
> Add a ZCRX_NOTIF_COPY notification type to signal userspace when a
> received fragment could not be delivered using zero-copy and was
> instead copied into a buffer.
> 
> Signed-off-by: Clément Léger <cleger@meta.com>
> ---
>   include/uapi/linux/io_uring/zcrx.h | 1 +
>   io_uring/zcrx.c                    | 7 ++++++-
>   io_uring/zcrx.h                    | 3 ++-
>   3 files changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/include/uapi/linux/io_uring/zcrx.h b/include/uapi/linux/io_uring/zcrx.h
> index b8596d7d47b6..e0c0079626c8 100644
> --- a/include/uapi/linux/io_uring/zcrx.h
> +++ b/include/uapi/linux/io_uring/zcrx.h
> @@ -70,6 +70,7 @@ enum zcrx_features {
>   
>   enum zcrx_notification_type {
>   	ZCRX_NOTIF_NO_BUFFERS = 1 << 0,
> +	ZCRX_NOTIF_COPY = 1 << 1
>   };
>   
>   struct zcrx_notification_desc {
> diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
> index 35ca28cb6583..732e585aa13a 100644
> --- a/io_uring/zcrx.c
> +++ b/io_uring/zcrx.c
> @@ -1510,8 +1510,13 @@ static int io_zcrx_copy_frag(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
>   			     const skb_frag_t *frag, int off, int len)
>   {
>   	struct page *page = skb_frag_page(frag);
> +	int ret;
> +
> +	ret = io_zcrx_copy_chunk(req, ifq, page, off + skb_frag_off(frag), len);
> +	if (ret > 0)
> +		zcrx_send_notif(ifq, ZCRX_NOTIF_COPY);

We also copy the linear part if present, depends on the semantics
would make sense adding it there as well.

Pavel Begunkov


