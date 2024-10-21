Return-Path: <io-uring+bounces-3848-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A7F7E9A6C64
	for <lists+io-uring@lfdr.de>; Mon, 21 Oct 2024 16:40:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D67BF1C21B33
	for <lists+io-uring@lfdr.de>; Mon, 21 Oct 2024 14:40:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A9181FAC3A;
	Mon, 21 Oct 2024 14:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SFFnsk71"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E72F81FA25B
	for <io-uring@vger.kernel.org>; Mon, 21 Oct 2024 14:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729521617; cv=none; b=MDRoUPJj5peV8EwOpr+S3P0tghar/WP3un3B4p+M5KfPvheOatImqV1bfPFjt4B2cOczwuyfltnglCdY6/vqSWwcDiPK3T63xQe9/NITrDDGHWIW6Hikc9ktmHdRT9uPX0Ic6Jy08yp31NvI8o8HdyKhmIQnGE57LAVomNj55e8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729521617; c=relaxed/simple;
	bh=Qb1J4ESPnoxMNJqmJyqgTEhGUYpIL/sGVVxxzKXx1HA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Mm7svr7Qdnrkl3UdiVmFHmPJaUsDHzwXOk1aQc2y5NpcD4/ZaTUcgZ8J3whpr0SL01FS9LpZ6rAjTUHWhppnKXRJ8SY4pCQeJstFmMwkhoVuTQZeHTJlLZUylXMmgijj3B5TNqw16c+7qUk+SPv5YPDyj35FIDBdnXJ83n7igoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SFFnsk71; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729521614;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jZ/ST2n2o+s+ljcXLA0TYyh1FPWIv37+D3gxR3SEmjE=;
	b=SFFnsk713P65FzwXBnv/YoEK05i2OUqpegHYEO4XTHda7gF3ArygZZQWrs9dXMLTUUigqS
	OradVFj79C7cfBmx60Tsu13M1jk40u5+R5ZKhaYofl0qUGT+f94/JXB2K9frHLgvR7ujr8
	Pnm27oINwT31HkH5StOEA3pIRbWUcZQ=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-328-Vk27AbSLNt2dh8-PxRd_AQ-1; Mon, 21 Oct 2024 10:40:13 -0400
X-MC-Unique: Vk27AbSLNt2dh8-PxRd_AQ-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-37d5016d21eso1893716f8f.3
        for <io-uring@vger.kernel.org>; Mon, 21 Oct 2024 07:40:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729521612; x=1730126412;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jZ/ST2n2o+s+ljcXLA0TYyh1FPWIv37+D3gxR3SEmjE=;
        b=whP+DoR9/6N7F5+F6peQL95KV0XQLsskBcqvtBN9vX36YfMOmP2i3fLVuE37U28zAJ
         +Te55fpbIO78jVurntUxtZmlF2wyuCqo8vd/bOlx1N0JLln1CQSVivImluaG2tyijHVm
         qtm/dCaguyGkLDlKR0nrrS6YjA6uMg2CPCbH0ky8V0VYydhuP+f93qGjYmyVi96cfMQ6
         7tbNPaTJwMjJw6uVAfjO6nvzkghqV+QD5/ZvUAbpgLFpT+W2wamSyEkfYB4cctzpTVO2
         bYEs9cXl8tXlbQh2sJxRs/VllM+xHyLYnmDHXDIRFIuh4lipgjRutqu5uGzcLHZIqqn9
         Mftw==
X-Forwarded-Encrypted: i=1; AJvYcCWDROhvKAIBIutT8XLJSCmPBos+odQl3mbj/uVk9fZTlWcZhAGuFpAk2GVCoTtJdvbIeevnMOcKwA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyyHo+KgNZ/wwbysHYOUI8X6nU0A/h+7cMuilZJ5mjvZ3+i6n3G
	nqVAmpONzA3JDxSE6kOJpxrVm26zuxUUsv5m0ujPTAZDwHQ/gdv9nLFtJJ7iGhFy3X4pexaIzYK
	R3uBuLyB0uL9s4xEmi9qPxttWuenvKwF/mDo/fTz7s2SG97PcwLSf3RDJo5WJ35qXg+o=
X-Received: by 2002:a5d:5271:0:b0:37d:387c:7092 with SMTP id ffacd0b85a97d-37eab4d1178mr6286634f8f.7.1729521612156;
        Mon, 21 Oct 2024 07:40:12 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE7/5labcUqsZBuqFnZonhZTBc1BKmhXe+frMb36S+aYhl3kVjymM+TEQ1VQ61MDBDEBRa/Xg==
X-Received: by 2002:a5d:5271:0:b0:37d:387c:7092 with SMTP id ffacd0b85a97d-37eab4d1178mr6286623f8f.7.1729521611833;
        Mon, 21 Oct 2024 07:40:11 -0700 (PDT)
Received: from ?IPV6:2a0d:3344:1b73:a910::f71? ([2a0d:3344:1b73:a910::f71])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-37ee0a485dcsm4487102f8f.34.2024.10.21.07.40.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Oct 2024 07:40:11 -0700 (PDT)
Message-ID: <4f61bdef-69d0-46df-abd7-581a62142986@redhat.com>
Date: Mon, 21 Oct 2024 16:40:09 +0200
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 14/15] io_uring/zcrx: add copy fallback
To: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org,
 netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>,
 Jakub Kicinski <kuba@kernel.org>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jesper Dangaard Brouer
 <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Mina Almasry <almasrymina@google.com>,
 Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>,
 Pedro Tammela <pctammela@mojatatu.com>
References: <20241016185252.3746190-1-dw@davidwei.uk>
 <20241016185252.3746190-15-dw@davidwei.uk>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <20241016185252.3746190-15-dw@davidwei.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/16/24 20:52, David Wei wrote:
> @@ -540,6 +562,34 @@ static const struct memory_provider_ops io_uring_pp_zc_ops = {
>  	.scrub			= io_pp_zc_scrub,
>  };
>  
> +static void io_napi_refill(void *data)
> +{
> +	struct io_zc_refill_data *rd = data;
> +	struct io_zcrx_ifq *ifq = rd->ifq;
> +	netmem_ref netmem;
> +
> +	if (WARN_ON_ONCE(!ifq->pp))
> +		return;
> +
> +	netmem = page_pool_alloc_netmem(ifq->pp, GFP_ATOMIC | __GFP_NOWARN);
> +	if (!netmem)
> +		return;
> +	if (WARN_ON_ONCE(!netmem_is_net_iov(netmem)))
> +		return;
> +
> +	rd->niov = netmem_to_net_iov(netmem);
> +}
> +
> +static struct net_iov *io_zc_get_buf_task_safe(struct io_zcrx_ifq *ifq)
> +{
> +	struct io_zc_refill_data rd = {
> +		.ifq = ifq,
> +	};
> +
> +	napi_execute(ifq->napi_id, io_napi_refill, &rd);

Under UDP flood the above has unbounded/unlimited execution time, unless
you set NAPI_STATE_PREFER_BUSY_POLL. Is the allocation schema here
somehow preventing such unlimited wait?

Thanks,

Paolo


