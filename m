Return-Path: <io-uring+bounces-3612-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A424999AE86
	for <lists+io-uring@lfdr.de>; Sat, 12 Oct 2024 00:11:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D35FD1C21FE6
	for <lists+io-uring@lfdr.de>; Fri, 11 Oct 2024 22:11:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D85E71D1E79;
	Fri, 11 Oct 2024 22:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jpM0iIN8"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EAC61D1E72;
	Fri, 11 Oct 2024 22:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728684658; cv=none; b=jMj2fm2a7WvOmXImaYvpciyAR67e35cDgWJDxjRkeOk5OG5nVYzS0nR1biSSSLw17KMBvlpH4qCYt5m10c4Ko0X6N6fo/bbD1w3c/NA4KgrS2T/RQkBm2IfLF5sr25vcQzoAPohlXVAA27AtuYyIb4Yd21omnrkeUJBF7S+n1/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728684658; c=relaxed/simple;
	bh=wg6pRi+onjwnoF2BVP5lI+gruFCHW6D0Rhdmb8lK37Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=inS3Mqo/ByvyIK8IUhVqN7eaaRIvsY6h6j40xltiJjdOVBNFEtHPm4mwoipjpoD9vqHlxUF+4CIS6OWxdrifqRuWVXeRBpJSjU5eIrURoPTzmyY0Q0oqnUL041YdgUNgOvvOkyaOKJ3UCQJ6Sxa4KCLgnDahFSpFlY0S9K8jYz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jpM0iIN8; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-a994cd82a3bso348219566b.2;
        Fri, 11 Oct 2024 15:10:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728684655; x=1729289455; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=R5OD4eVOppchDADeH5TK2YgoYD1MkhKe4CxW+8Mgros=;
        b=jpM0iIN8JmoIp09QO8xkQJkBW0XYjKo3SXQ+cOgV0w09OX2AaX2GbBE+/xsyUsorbp
         ftLWtQvhP4D8oxtXhauuhIIA3ycQo7lu7uf+VyV0M00S/clOVBIKqKSwBIFFQBP/oI/r
         RsQOHmp7/ygHj/8HsZF4+xkv5Ljl9ulLzNJLaH0mbADvXtIteZ5a7zujzc1TnanlYj3F
         pSFhU76/ktKN/rC9SwO1JuQ+s1qd1r85MO+viRB+xCczScyQ3nRLHBnbjGw2yRoO5Nzm
         SG6ljBAdOFlswc/ReK8klgyx2ASTW/QoH2eqUONfhH8ufsMbKeJ28Qm8vXxTz+Tsbrfi
         6Ztw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728684655; x=1729289455;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=R5OD4eVOppchDADeH5TK2YgoYD1MkhKe4CxW+8Mgros=;
        b=VfkwBDYVN3R8RFoNdsdLQ+tIwVDXpK7frNnMX7bYRmLevvzyI8EQyUW0bpfMWGDYga
         tksO2VdP/2aMiM4AG57pov9VJa6wlOQ4W93Ek7lzom6pkCRYrrIIoeithIeh9knJhYEO
         kHNLyyZq97flQ40TxoVWj/PRMBe17b6Gbzk8bs7pP0Ot2PKlBYA8XklO4daxWNdj1ypj
         cQ4ACc+mbXO5vQVN22F/u2PzwYJ1nYo3AMmBiIUIXq1M1RVUGHbqEovzc+y6qHF1tsha
         Fj2B4ASzwNkwTflc4btPsvRGdqblMKKZxL8Js+uZoCMO13DKUIuT+ZYaeo98BGKM+Pqg
         LcFQ==
X-Forwarded-Encrypted: i=1; AJvYcCVyeFvL+xDoetHZqQjeudtg4VUb09Kg9/IgrrbYc324gbgp+HMvub39FNS3SVwLaOqzz0N2CRKm@vger.kernel.org, AJvYcCWyB+Is9y5V6EsElwkdZM9nGNTFNuuAa8w/Mavum3N83QDznzQMxEWwzRXj+nO+VrneF39rWuQysw==@vger.kernel.org
X-Gm-Message-State: AOJu0YydPblT/1j/DX3vM3NnokwSZB156vxIG2xh3uZOt2rxtH15Ubzk
	ljgkhmhjeeQ39qH2JM6vPFfj3Czxd8+YxApYaqEVnr5286+URG03
X-Google-Smtp-Source: AGHT+IEII3cVHQlu6CBBV3Rz3HMNJ14GQ6wjLRtDBksii8/CZ8GjbErVgZruxbb1GH3ycKF4xPYJFg==
X-Received: by 2002:a17:907:1c14:b0:a99:d74e:71aa with SMTP id a640c23a62f3a-a99d74e72b5mr132182166b.64.1728684655181;
        Fri, 11 Oct 2024 15:10:55 -0700 (PDT)
Received: from [192.168.42.194] ([85.255.233.136])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a99e9ec042bsm14249466b.66.2024.10.11.15.10.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Oct 2024 15:10:54 -0700 (PDT)
Message-ID: <1bd0a38c-b59c-4480-9557-b0383bde18d8@gmail.com>
Date: Fri, 11 Oct 2024 23:11:27 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 09/15] io_uring/zcrx: add interface queue and refill
 queue
To: Jens Axboe <axboe@kernel.dk>, David Wei <dw@davidwei.uk>,
 io-uring@vger.kernel.org, netdev@vger.kernel.org
Cc: Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Mina Almasry <almasrymina@google.com>
References: <20241007221603.1703699-1-dw@davidwei.uk>
 <20241007221603.1703699-10-dw@davidwei.uk>
 <8075828d-74c8-4a0c-8505-45259181f6bb@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <8075828d-74c8-4a0c-8505-45259181f6bb@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/9/24 18:50, Jens Axboe wrote:
> On 10/7/24 4:15 PM, David Wei wrote:
>> From: David Wei <davidhwei@meta.com>
...
>> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
>> index adc2524fd8e3..567cdb89711e 100644
>> --- a/include/uapi/linux/io_uring.h
>> +++ b/include/uapi/linux/io_uring.h
>> @@ -595,6 +597,9 @@ enum io_uring_register_op {
>>   	IORING_REGISTER_NAPI			= 27,
>>   	IORING_UNREGISTER_NAPI			= 28,
>>   
>> +	/* register a netdev hw rx queue for zerocopy */
>> +	IORING_REGISTER_ZCRX_IFQ		= 29,
>> +
> 
> Will need to change as the current tree has moved a bit beyond this. Not
> a huge deal, just an FYI as it obviously impacts userspace too.

Forgot to mention, I'll rebase it for completness for next iteration,
but I expect it'll need staging a branch with net/ changes shared
b/w pulled in both trees and taking io_uring bits after on top or
something similar. We can probably deal with all such io_uring
conflicts at that time.

-- 
Pavel Begunkov

