Return-Path: <io-uring+bounces-13716-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id lDT+C5goLWrWdAQAu9opvQ
	(envelope-from <io-uring+bounces-13716-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 13 Jun 2026 11:53:28 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 80B5A67E4BA
	for <lists+io-uring@lfdr.de>; Sat, 13 Jun 2026 11:53:27 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YlTjjlMc;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13716-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c0a:e001:db::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13716-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9C898300F9D9
	for <lists+io-uring@lfdr.de>; Sat, 13 Jun 2026 09:53:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2785A3A63EC;
	Sat, 13 Jun 2026 09:53:13 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DF1835F193
	for <io-uring@vger.kernel.org>; Sat, 13 Jun 2026 09:53:11 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781344393; cv=none; b=Cvx7/tw9F0ycGG/pvNqi+EMGcecrz/VX+OTjQUGBWkzOaH7STAjCiRHqmjwUS8RFxYBd5xO4HMZK37D2Jc8AMpX/NctC3NVNFehIqipI9R64RDA6NcdH3aOy8g8pitFaAeBt8m9BTFHs1d/uwfFX4i7xEbxx4PgKeKbcpN41qRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781344393; c=relaxed/simple;
	bh=nsa/xqFgCfQ6As/U7LFHNU109oPvAMtkmMVTthWUFv8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EG2WfGkMPpXGgKj6d4PdLLP+z9Hk94qSARnp39UO2HsngZsQ0PwmYeunK/C8lMX59rXqJLOYgKCPR3amvuELmUOfmCZjeg7GCprUuomL0kLRZ/6QmV4Hl7jvayc3xkA1e2bFVw7rrn/vtgqRfKxsmp7xFRFIOZt3BbgrIAMW5Q4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YlTjjlMc; arc=none smtp.client-ip=209.85.128.52
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-490c1915793so14812735e9.2
        for <io-uring@vger.kernel.org>; Sat, 13 Jun 2026 02:53:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781344390; x=1781949190; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LDr7uB+HqKTFCCswWELw3SFqptqHrXh1cl865xzwKVM=;
        b=YlTjjlMcLnEJF4QjvoLAtM/+lSg9o8/EwVOb+33HTMUvQCS08DweroCh83jGelnvyA
         7Wlxlil2YZxqDxtLo+fu4wWzZbqyuvyOoKJ2gdoR1KM1buXumw1UGZanrAXDRyfAlqUa
         xZsPsGB2YNzhZ5TIp4nQ8GOGZrjq3VJ84RAQWb6aKpK+OrC2GwXveYHnCXPV4Sqe/9AC
         Zx0Qc+W+/hWUMXedm6rhQlgclsNIEVhIChVozUQHRfkUggerhfOGEHUbdTWa/isOgbXn
         CAsAd3Jzgxud9WMFzpDN0LFUFIYKNLPMcZ3MKqq3gnAg5uOcgUCvoAHybemL+MOiR7x1
         jW3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781344390; x=1781949190;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LDr7uB+HqKTFCCswWELw3SFqptqHrXh1cl865xzwKVM=;
        b=ZAcp6u21jnuz7GuATFX2/cI1Gy7CG2qDIgjKN3a/BHLudeSpc7SUEwvUmLc2tdQwMO
         gy3kn1tkWHPgZDQg+KgftjXDi9e+V4ZzzfVa6mfArX3MujwGANsoqkSP8EmfB0T0JNPj
         PsMk6k9mtJ/x6ekTqlWunRBHt+TQSk6aTPXUjMRXz0cGVOdKP7TsqigEU3xE0xbMnhwK
         cYRSJ47ni6UKn5+QCqkhRw58M0BHwewOiJziHRrXHMpV1khyzS9pxZSUZkCEwdns3CUr
         yqcL402ob5MxrmDzGgRirDvj2fuHmcSe9zLue0Uf0FCRi46MaNyYDUEzkpllIT9jbNRd
         U6QQ==
X-Forwarded-Encrypted: i=1; AFNElJ/k5tml7A6T3OPxJT74zAglJ+a50uE+1GeCmOwVW7LHN9Ytr96wDEkB+MmtTr8PATRiJgBgZGxhCg==@vger.kernel.org
X-Gm-Message-State: AOJu0YziW0s1KHguHwBC1j2GuhohpA+YMGEMQ1Rg4N1dkxUk0rI/GJu9
	G8v9JxmbQDVr3xozUjP5uBP3OZju6aNvP4QXBMm1cngpprGR6wWw2Hz4
X-Gm-Gg: Acq92OHH/hbA8rfh5Oyi4kjLfiIPXai/1S19fYdqBr5blwR0ImEX0uHKHndLigkXGR3
	tM6wqtuYK1pODLdGyrvDc0qRqdAfh14d1ip72FNz5ZXVsmMcsQfjGC/g85/pEQlbq2yEQMGI7Q7
	V4XhNaaFJIrNhu/450DECH5nJtxVunBbbnDGwqNhF3nGSTYxsIcRO9k9yk30LytHuDT13nI1UyD
	B/XEXLOp1mrOa21STd6FLfg0yjxhfMh5giCIZkSXWrNUTufpEZi/KPdvXf5a2EN9RoKXED8sAKd
	4vhLPRlmQNuVXyqtv0F0IDxc7Rkjnis3gxkalXD9BK26CGNbdJoHFelToZItaSmEwYdBIwDz+ap
	JZWn1FQHe1o/myNaHZIpgFj+8TqvPZy490lZS0S294akBrABoQ6Z3pUhep6SpNW2zE+RI9Exyji
	i8DebzmOEf+LGRexyM3VJlnvDl8qKTytI5rqSs3pVWng0mpb1BAqPdKT1D5EQ0wbnSeBWluz68P
	DZ8EKmQa2P7v1TL0ghSDr6ceWIJt5mVnaVJc8d3T3cZWXEmOfriOt6kKolvSbobzjUJt8e2TFju
	Xw==
X-Received: by 2002:a05:600c:a210:b0:490:e60b:5fcd with SMTP id 5b1f17b1804b1-490ec521002mr49829595e9.32.1781344389840;
        Sat, 13 Jun 2026 02:53:09 -0700 (PDT)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4922035b4absm64807955e9.11.2026.06.13.02.53.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 13 Jun 2026 02:53:09 -0700 (PDT)
Message-ID: <d0401fab-61c5-43e7-93ae-d4757433eb7a@gmail.com>
Date: Sat, 13 Jun 2026 10:53:02 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v2 1/2] netdev: expose io_uring rx_page_order
 order via netlink
To: Dragos Tatulea <dtatulea@nvidia.com>,
 Donald Hunter <donald.hunter@gmail.com>, Jakub Kicinski <kuba@kernel.org>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 Andrew Lunn <andrew+netdev@lunn.ch>, Jens Axboe <axboe@kernel.dk>
Cc: Yael Chemla <ychemla@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 io-uring@vger.kernel.org
References: <20260612211709.1456966-2-dtatulea@nvidia.com>
 <20260612211709.1456966-3-dtatulea@nvidia.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20260612211709.1456966-3-dtatulea@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13716-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:dtatulea@nvidia.com,m:donald.hunter@gmail.com,m:kuba@kernel.org,m:davem@davemloft.net,m:edumazet@google.com,m:pabeni@redhat.com,m:horms@kernel.org,m:andrew+netdev@lunn.ch,m:axboe@kernel.dk,m:ychemla@nvidia.com,m:tariqt@nvidia.com,m:netdev@vger.kernel.org,m:linux-kernel@vger.kernel.org,m:io-uring@vger.kernel.org,m:donaldhunter@gmail.com,m:andrew@lunn.ch,s:lists@lfdr.de];
	FORGED_SENDER(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	FREEMAIL_TO(0.00)[nvidia.com,gmail.com,kernel.org,davemloft.net,google.com,redhat.com,lunn.ch,kernel.dk];
	RCPT_COUNT_TWELVE(0.00)[14];
	FORWARDED(0.00)[lists@lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	ALIAS_RESOLVED(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring,netdev];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,vger.kernel.org:from_smtp]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 80B5A67E4BA

On 6/12/26 22:17, Dragos Tatulea wrote:
> This adds observability for the io_uring zcrx rx-buf-len configuration.

It might be nicer to look it up in the queue, e.g. rxq->mp_params,
and make it a queue attribute instead of zcrx specific one. In either
case, no objections.

Acked-by: Pavel Begunkov <asml.silence@gmail.com>

-- 
Pavel Begunkov


