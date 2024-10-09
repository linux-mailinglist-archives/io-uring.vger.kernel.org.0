Return-Path: <io-uring+bounces-3515-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B2B5799755F
	for <lists+io-uring@lfdr.de>; Wed,  9 Oct 2024 21:05:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7510B286BE9
	for <lists+io-uring@lfdr.de>; Wed,  9 Oct 2024 19:05:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 228031E1331;
	Wed,  9 Oct 2024 19:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LF9kndKd"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A03F1A286D;
	Wed,  9 Oct 2024 19:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728500706; cv=none; b=NrYkX1AND0I0kO3oqK2ZCBXgcV7ay6y8c6a8+vfWluBChwhPsO34SCajdZqUvXpkAX8tEkUarcjhYHaRQeEbV3yTcr/XXxw/ZOvyYlw2MU/GKhimCNqZHZEUTj4MRVaoGSO3P2UPioldQimU2imggTo44L1woUI7UzBgoCNjx6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728500706; c=relaxed/simple;
	bh=YCElRbHTuivumaUfA11NOdYexMbnHbUheYdB+WtwxSA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=M+xLpa1MwlGknfM2kZpIPy4t+WpBnHo5CR5bzDgPxVvNgqkLnzyzQLQEEOt+chIpy7BnmGLTarVsWEUiFM5S8vwpF7Uud98ims6dgJAMSHDbEAd6KecrDNH0XNanqEj1/WOcEdzILnxBU/ry1VGxlX69Hxjn2spccfKYZq0xzgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LF9kndKd; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-a99415adecaso223799266b.0;
        Wed, 09 Oct 2024 12:05:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728500702; x=1729105502; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vb12skGKJkpjyMLmoKUCtJ3dVlCuI/sXbMpA7d/2hqU=;
        b=LF9kndKd4ucqSngQIn4WAk7QkGcfiLlK18HvNv09WSs4mXUCzt7ug+SFHMUZ85QK9I
         RbfMN9dV8uyRXXZkDLFIcawJqWfu4HebWIeYF+TH7MdYQ0YLaGxf+LTWgw9LmNy1Ldmv
         InrvlPA6liGtmIvUXI74hEdAYFNq4eu8e/aYtfxGLRXdeXnpxz0ooHH/woYMVT12DBVr
         J3yQAGjV4tuD1rKXBP6DonCfVRdZ4IGjMop2VV6vf+ri60OBGfPqsFAsdC0lWXbRznsl
         TDTqSWBEsqJZEBoErf1INB7jwGfFat8sJvtMm4pHy3eXawaoAE+VMRJjhsr/6cPWaakL
         BtEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728500702; x=1729105502;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vb12skGKJkpjyMLmoKUCtJ3dVlCuI/sXbMpA7d/2hqU=;
        b=kx+zIsxjmR1EpgNTnZ/7Qn9qAr1tlOThCnfDZKLWGylV7y+mFYmYk26/IX82OIs6CG
         qPBZozA5DK1hreJhNZD0LSocijdl+dJS3U/tDNADq5lRNp/am1+rIFqRDbdB/P9bV7h6
         pNz3ybzZA1Eus8ol+PhpWbmz3fhjD8jbzAZe44XJujuz0TebNwZah77jEd4z6hcf4tkp
         bYm3YonhdS1azC9oG9xgnviJB5OFazAJXkDQF4idNTFn6/7tOZHv+3UV5Dt20a+kpfl5
         rQVuUa7LZ4/38KvcpkLarjd3ebaasUwmkK7K5rtV8DB8Cqfevf2jJD9sevIksrM1rmVJ
         KdAw==
X-Forwarded-Encrypted: i=1; AJvYcCVE72QQygmxhTkXbsXcaP2Ci3tqPo0sBXqNS/ZBBWH+1tw/F01Yipj2H/97fwQL7Vc9w31xuUHS@vger.kernel.org, AJvYcCVUfjdnC+IjpviR3Bwze6Kmq0Dqu1C/0RHlsyETV4su+XnuKlh4KgzVIE0qFuwsY/TbBc+iYiEZ7g==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx+gJHjUnPv6D2UVbitF7RyrfB1afJubb79z+RTpK7yaUCqbs25
	i57pgVXSqSCbOQRcsSwDANBm8QhLakuZ1rn5rzDa6GLYSsSKMz7B
X-Google-Smtp-Source: AGHT+IFN+CMFlWwSHVJ2A8satLMBRRBJW5cmEKXtx3YFIu9GKwghhVL+xdnPIKAPJqopewRfXJmieA==
X-Received: by 2002:a17:907:7f1b:b0:a8d:2281:94d9 with SMTP id a640c23a62f3a-a99a13ae729mr73802066b.23.1728500702468;
        Wed, 09 Oct 2024 12:05:02 -0700 (PDT)
Received: from [192.168.42.9] ([148.252.145.180])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a994205dc60sm604192966b.87.2024.10.09.12.05.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Oct 2024 12:05:01 -0700 (PDT)
Message-ID: <22c7cad9-72d1-46da-9f69-31b7837b9de8@gmail.com>
Date: Wed, 9 Oct 2024 20:05:37 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 10/15] io_uring/zcrx: add io_zcrx_area
To: Jens Axboe <axboe@kernel.dk>, David Wei <dw@davidwei.uk>,
 io-uring@vger.kernel.org, netdev@vger.kernel.org
Cc: Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Mina Almasry <almasrymina@google.com>
References: <20241007221603.1703699-1-dw@davidwei.uk>
 <20241007221603.1703699-11-dw@davidwei.uk>
 <f3b7b9c3-3cde-423f-b8a7-28cead30204e@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <f3b7b9c3-3cde-423f-b8a7-28cead30204e@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/9/24 19:02, Jens Axboe wrote:
> On 10/7/24 4:15 PM, David Wei wrote:
...
>> +struct io_zcrx_area {
>> +	struct net_iov_area	nia;
>> +	struct io_zcrx_ifq	*ifq;
>> +
>> +	u16			area_id;
>> +	struct page		**pages;
>> +
>> +	/* freelist */
>> +	spinlock_t		freelist_lock ____cacheline_aligned_in_smp;
>> +	u32			free_count;
>> +	u32			*freelist;
>> +};
> 
> I'm wondering if this really needs an aligned lock? Since it's only a
> single structure, probably not a big deal. But unless there's evidence
> to the contrary, might not be a bad idea to just kill that.

napi and IORING_OP_RECV_ZC can run on different CPUs, I wouldn't
want the fields before the lock being contended by the lock
because of cache line sharing, would especially hurt until it's
warmed up well. Not really profiled, but not like we need to
care about space here.

-- 
Pavel Begunkov

