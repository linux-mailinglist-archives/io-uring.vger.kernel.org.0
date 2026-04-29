Return-Path: <io-uring+bounces-13171-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eD30Hq0W8mljnwEAu9opvQ
	(envelope-from <io-uring+bounces-13171-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 29 Apr 2026 16:33:17 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 23797495D07
	for <lists+io-uring@lfdr.de>; Wed, 29 Apr 2026 16:33:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id B50163012CA3
	for <lists+io-uring@lfdr.de>; Wed, 29 Apr 2026 14:31:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B21E534D91F;
	Wed, 29 Apr 2026 14:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cY40mc0c"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42958277C9D
	for <io-uring@vger.kernel.org>; Wed, 29 Apr 2026 14:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777473117; cv=none; b=SJzeCPWJRXZqiIBsa29rlaQSmiKkQHwAHNrm3SETirWr3nEJB3NlTiAGB5fphIgDEW+/a7tQXrFswe5T2pIdgBbLpUYJexMfyf9akyTKEYA4U/8sNVPrQLtjLJ+GC1abWHcvmVWpuGtCbOyfVqvGj7WbrpBGgWEkorH9arBJLic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777473117; c=relaxed/simple;
	bh=y2HnhOMy4hyLpTmRJAP3RTbsxFjeenv2PvD2f098SG4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FlCbam5pk3g2P0nbjPAeVOvdF+vW42N9CWGK/fTC+kWnNFhBVRpo8FPM9FX/ZOF+PV0vVyHTpUx+8ilh1pdz8ChmQggliWw3AzJaz/nYmZb/W3EEvhnCG/lvnKACjxtIe9st43eX8BNMDpmYQf6znnReG8dSNuDROojWwPnPvOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cY40mc0c; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-48334ee0aeaso129209925e9.1
        for <io-uring@vger.kernel.org>; Wed, 29 Apr 2026 07:31:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777473115; x=1778077915; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NyS+iO9jeCHRrkgdMXm039A3CMe7fQPfQJh8kvEzuwU=;
        b=cY40mc0ceX2lbwrDp24/mbjChViYXMHK959eE6O0aMXVhdVm5q+LT4ew8+KApjgA1k
         IdEW1NYgbA+aEwOzoz50XoPEuDZgAIm6HyM6VaCTzWBFeXDRw/2TvVZGQn2i10oIFenD
         QupGtdOvshdESB20jvC12aJlxU3AUww6OksivxR5j8XRitAh3refLiMCXK3MuorxnaXd
         ietLSAJozplLI7FAiKRahqoKIOPXFZccRPYYE7nt9rXp4Tre5ckPgUSgNKPPhhDFRY96
         bkE6KOa+1YOcpEm7dIs++kfRxfw3OujaoFHQHPMpyfByu2CYimnGYCMLmKY6O5gqjT4p
         9Paw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777473115; x=1778077915;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NyS+iO9jeCHRrkgdMXm039A3CMe7fQPfQJh8kvEzuwU=;
        b=JLPN+gAy67kx20J3aKSWOq/tPdIbTplj9fXNkjFdsrZN9ogKkudtUnYajTboQxzija
         QDdb9BtjTPv6aZlSrq3Ats0uIkScersEEcGBngulmEiDAjWdhBR5Q5ppmlE9K6z/zu7D
         SJLzEZahUySpa05Eks7iAyKtZYsukXCriWr28y5dq3zjDG0PLk5UPLpGE4sufYTJnbuZ
         WY4B9AVQAeJJKERbuReyNWHg+nNuNFXnpa68okUUGp0qolshUY7UN/sXQ+TSa5pcSPFp
         HqCIGsYszATY56cszyGHHsWKjpDDmoq7d5Pxx9XQMo80GqySzFCuihrdOcDKN2/fae8r
         W2jg==
X-Forwarded-Encrypted: i=1; AFNElJ/fP9fwSyoXhznHnW6bI9wh6TJ1/tHS/0aPPF4TVjrGzGhn2H6vBA6RzsuGi+W0EKkBV+bNvmtHSA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzE2P6AqvIZZV8W0TNzKZv60OdaclV4OJ0G8Jm4W853W1IZ8NT3
	lt2juubmvksii5/pZg9/BpGd99o6cCG0lh1A08clP6pDAiFm+1QczFXj
X-Gm-Gg: AeBDiesAtmnS3Fk6Npy5MIiQIUp7Q+9G2jVUvKvHJf8H/Vvjawa8W8zbFY4ZGakI/t/
	9Y42DZTJcJb540eZdms3jF5kf582fZJEMkw1eyF7Qs88e8fzbWaf+LZzCg2g4U5npY2zH5WWMYG
	B1tGxz86MRRBsW8WakFiGT+TdcGjDsEltm47MEZxhXXoHXHkjCxQc04NsKi49a37omh30+lOi60
	RacOH+lKt000lOxrb+NwIjQNCj4gLa4nJRJ3EMPYfbhT/xwHOep9pP4yRU2+HKQV6gwL+E7aO2i
	BQ7rM9qq4LatbeFSaezScVXZCqMwXr/CrBjD0/DcthuRCkILnZamISPycYfb14bDkq2BclMZWOg
	DA0xkbxsVnUUF89al/U+azDNv921B7zXNeNEIUGGnqdV6VNLoLLsFO9dqY74i3tEQ7yj9VCKCO4
	jQymk/j3XD+YpayAXaIzjybk0AgOP/EfMA6OQINLkMtPwSlFF7rUekVCTADmZ33yqApPPKyK7CJ
	upreh0La97/Jk8d2BgMubPeLxT9iO0FhAJWjkax6ckhtJiDsXggXUicDKfCX7TbHgmlgAzxBXUt
	sMx/PaCN
X-Received: by 2002:a05:600c:5492:b0:489:1c1f:35e6 with SMTP id 5b1f17b1804b1-48a7b5124cemr68867815e9.6.1777473114207;
        Wed, 29 Apr 2026 07:31:54 -0700 (PDT)
Received: from [172.17.0.113] (218-211-0-146.static.cpe.unicatlc.net. [146.0.211.218])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48a7c57333fsm51551715e9.2.2026.04.29.07.31.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Apr 2026 07:31:53 -0700 (PDT)
Message-ID: <69bd0255-33ef-455f-98a8-db14a4d88708@gmail.com>
Date: Wed, 29 Apr 2026 15:31:39 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net] net: add net_iov_init() and use it to initialize
 ->page_type
To: Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc: netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
 andrew+netdev@lunn.ch, horms@kernel.org, axboe@kernel.dk,
 almasrymina@google.com, sdf@fomichev.me, hawk@kernel.org,
 akpm@linux-foundation.org, rppt@kernel.org, vbabka@kernel.org,
 io-uring@vger.kernel.org
References: <20260428025320.853452-1-kuba@kernel.org>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20260428025320.853452-1-kuba@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 23797495D07
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13171-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCPT_COUNT_TWELVE(0.00)[15];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring,netdev];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]

On 4/28/26 03:53, Jakub Kicinski wrote:
> Commit db359fccf212 ("mm: introduce a new page type for page pool in
> page type") added a page_type field to struct net_iov at the same
> offset as struct page::page_type, so that page_pool_set_pp_info() can
> call __SetPageNetpp() uniformly on both pages and net_iovs.
> 
> The page-type API requires the field to hold the UINT_MAX "no type"
> sentinel before a type can be set; for real struct page that invariant
> is established by the page allocator on free. struct net_iov is not
> allocated through the page allocator, so the field is left as zero
> (io_uring zcrx, which uses __GFP_ZERO) or as slab garbage (devmem,
> which uses kvmalloc_objs() without zeroing). When the page pool then
> calls page_pool_set_pp_info() on a freshly-bound niov,
> __SetPageNetpp()'s VM_BUG_ON_PAGE(page->page_type != UINT_MAX) fires
> and the kernel BUGs. Triggered in selftests by io_uring zcrx setup
> through the fbnic queue restart path:

Looks good to me,

Acked-by: Pavel Begunkov <asml.silence@gmail.com>

-- 
Pavel Begunkov


