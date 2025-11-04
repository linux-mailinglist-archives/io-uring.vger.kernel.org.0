Return-Path: <io-uring+bounces-10360-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E434BC31442
	for <lists+io-uring@lfdr.de>; Tue, 04 Nov 2025 14:41:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DE0D23B2F23
	for <lists+io-uring@lfdr.de>; Tue,  4 Nov 2025 13:38:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77A8A2BE62E;
	Tue,  4 Nov 2025 13:38:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QDKE3zMT"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C061C2F90C4
	for <io-uring@vger.kernel.org>; Tue,  4 Nov 2025 13:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762263487; cv=none; b=oeJc89hMRCW1PO3a6rpGBXS7220KNDYNZLPnPicFssA6YQ+Dy3CLJVpp12vfTtFpPiaPPTqh4UT0um+LvLcZ9LLgAFAoYLqizqsuJNXqduR5InlPmhDkYZ14LM9eWZQQUKw71QEN5YbC2Ti5H3h7UydbcYm6mIlKSyhiVSJQBpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762263487; c=relaxed/simple;
	bh=b+4MFJ1P4fD0WLQwYtySbmNZfeOBeQMdgCxN60MzNfY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fZAoGRHf/LwHJ5iNbfSzXuOA4cyQlk2IQVKgOvuF0RDwcYMsPfj/6IN++OdKn/dU5wyWXd/ELN+0xA0hCjXgoZ++xsWxbQm1bxGkFdfxoKKF5hcgEnsf3r/Yv0nc11itjZd88p6xXn1auM2ERapFlsa4gMcxMTzkn7aUTmMwoDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QDKE3zMT; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-477563e28a3so5160925e9.1
        for <io-uring@vger.kernel.org>; Tue, 04 Nov 2025 05:38:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762263484; x=1762868284; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=716JUp54HLtiXbrW2pmciFc8haFAbjAYRpxOJ1zhcr0=;
        b=QDKE3zMTLH9+fhrItuC/xGBYWZf/l7BRYt7AmqMwZtcGOydZPu9ZGOHOd0hzSnuikn
         0umotZByJQ61oElBEus13qYKEInjW+NOuf2d8moa23sO7WLjxh/pmWSBIGcPqhNwoGmD
         1F3XlC/kbV8g/fGq7spGelkb9N20p0rwS/0eSqqzG16WnSMZviHVop5BxUoKdvAPXOp1
         hfyIiC7FSIz8PmfhjLobIMy86cQMfGLdyWRfJKebz7DcKF7tc0lgWFCFSCJFRXX1HauH
         73twDbuQR2DQgbhu7r9dl/xbvPGTaN07l7iVzhjvxag0pJ15vu/Mk3TRXc/0MiL8HyI8
         8R3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762263484; x=1762868284;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=716JUp54HLtiXbrW2pmciFc8haFAbjAYRpxOJ1zhcr0=;
        b=dbaaO8KnK3EtUAFVhmPrMfLhslkLvz5JOngGFo3cCATf0sdMptZUleit8ksK9pP2D0
         aDbgTRv/WuuamFabgqfN/4ppKkPPJMjPO5O4XMzOcTYjKmlqstK2ltOOQnbYWIVT5X5+
         IxvO9s7ooYL43v1gJGTbhZzzgrWHzbFnyDSrUkj7OKLcRPg1GaUu35xlGYfZKHvchNN/
         4MrH9dFpFN/tuYwtVXg2Ypp3QR6gZHDZGVyLPXIQEIk+fejktd6wLRjXWGVH4+efa8Nv
         wLIV14U46QKE+LA0y9D6ZoFVKAd14ZLGRJlRTCq58cAF7qRL33NHMtbaw/tU9sIohdaq
         AfCA==
X-Forwarded-Encrypted: i=1; AJvYcCX78AIs98REh0WC+QyWX01+L9HxkfSWqIBvaQRsev9FyCHgFHFOYx+esyR6SJ3PybvrVXa6k33/fQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz7I8QI8l5xZhfhzCIm0LaU92a5yCzamwnGclwbQv3z6vc+pcbz
	STppAZguvfpOYVlj15pHnenvhM27uOuMB+yvZSHS4TNPcvo51L9t3Wi9
X-Gm-Gg: ASbGncs4COMPjqtpF1+A7ljKFKxYYgmxBVPN6UYs5jTCcktLVfvB+16PEiKHj2l1uAd
	egD4+7O0c32pkOTLFjtnGNPmuiYBMpMsp2eWMgiH/Q/hgz0lwDvIQQSK99/bgaP7+e8nDeTSRQ2
	VhzuzrMCg+s1JFCDl9it5q0XgOFlcJHnPTW+heVvDs4hlRdQV42wLH5M1cN8OlBm+m1rI7/mzmG
	BCONj72gBVWi0YQIYICHUJBFptlspTuzIVAzAaht5y9l/Jt+1yUpBiU2NtcuvnGOS1J/UNNHguW
	cSUha6jspr1NAoyYfYY3/aQZssZi7K04USkc5FH4mqiOvAPkWofKzJaiTlOGMEB97tH+VhcW1/s
	U/BPpEU5WAjWnZyvrY7prREA07U7kGoJO9gaAag7LQiP0yxYKjOGf39Kjrk1wxTaXLav4r2CyKk
	GGP0Xir1Yt10abX0UPeFFRQzdsPNkzUUMIKo626pelhlIW5qE9gpY=
X-Google-Smtp-Source: AGHT+IGIdycrxy71HgH6Af4ITn325431vaJhiq25nsAZXoIWw1PHU3PRJFe7+cWlwbxB69ZNS54Gfg==
X-Received: by 2002:a05:600c:282:b0:471:793:e795 with SMTP id 5b1f17b1804b1-47754b897e3mr20588295e9.0.1762263483818;
        Tue, 04 Nov 2025 05:38:03 -0800 (PST)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429dc1fdae2sm4837075f8f.41.2025.11.04.05.38.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Nov 2025 05:38:03 -0800 (PST)
Message-ID: <e92c80f7-de26-4a06-a100-5947e6ccc739@gmail.com>
Date: Tue, 4 Nov 2025 13:38:00 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 09/12] io_uring/zcrx: reverse ifq refcount
To: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org,
 netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
References: <20251103234110.127790-1-dw@davidwei.uk>
 <20251103234110.127790-10-dw@davidwei.uk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20251103234110.127790-10-dw@davidwei.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/3/25 23:41, David Wei wrote:
> Add two refcounts to struct io_zcrx_ifq to reverse the refcounting
> relationship i.e. rings now reference ifqs instead. As a result of this,

Note, you don't need the 2nd refcount in this patch as there is
only one io_uring using it. I hope not, but there is a chance
we might need to backport it, which is why it's midly preferably
to be kept separate.

> remove ctx->refs that an ifq holds on a ring via the page pool memory
> provider.

Nice!

> The first ref is ifq->refs, held by internal users of an ifq, namely
> rings and the page pool memory provider associated with an ifq. This is
> needed to keep the ifq around until the page pool is destroyed.
> 
> The second ref is ifq->user_refs, held by userspace facing users like
> rings. For now, only the ring that created the ifq will have a ref, but
> with ifq sharing added, this will include multiple rings.
> 
> ifq->refs will be 1 larger than ifq->user_refs, with the extra ref held

Can be larger than +1 as there might be multiple page pools
referring to it.

> by the page pool. Once ifq->user_refs falls to 0, the ifq is cleaned up
> including destroying the page pool. Once the page pool is destroyed,
> ifq->refs will fall to 0 and free the ifq.
-- 
Pavel Begunkov


