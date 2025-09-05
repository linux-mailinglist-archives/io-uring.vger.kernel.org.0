Return-Path: <io-uring+bounces-9588-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E2FCB4540D
	for <lists+io-uring@lfdr.de>; Fri,  5 Sep 2025 12:04:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 53B583AD47E
	for <lists+io-uring@lfdr.de>; Fri,  5 Sep 2025 10:04:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA49A2BD59C;
	Fri,  5 Sep 2025 10:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="J0xUkBsO"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B8DE28C5A4
	for <io-uring@vger.kernel.org>; Fri,  5 Sep 2025 10:04:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757066663; cv=none; b=gDcJEsqtH5klpV+i5oZEKrlnHsdw0mJheA3Eo+TODupjxBKqmcmHtIXnYcF5gMBW26YHkQnjB0E8os+1FJnf7SNzP//zU+IiLmC5iErbdL4jUA23V9Oz+Z+gEsHsQnizh8qx6brpmPs8fi03uQuX84xys+/TJvk9G9hjtyEu0Gk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757066663; c=relaxed/simple;
	bh=o7txIwtxMhIHUx4P828qidppHpAeVuRrrdwm9WvKU5w=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=DZmYMhdLMQTR75WPe+usYUlQil7aP+jNtZzjW8SWC7XwW2c+dOlunXQy/hACrPj7EeNU16HvCT+XKEOw1XE5STJtVFW3oV0DicMYbFhE6R0GJrvvjPeA94/Pgv4eyTHpLUc4ZryctE/AqVYVFQyx/DSLR2eA8uO/x7NbgnTlibo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=J0xUkBsO; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757066661;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=awGkqZmdOIz0Jf4DYwVDUKWG2obdvFs2eFy/pOJ5Q1U=;
	b=J0xUkBsOGUDO/umWycgoLp59MGWgLtpY0g/7yTBn9Stcn7Nios3KxYcV0c2A8lYL6KfzAB
	Y1Sjex/31kZsGDBDhxBwnjX44KeHX/pNDzlZXhk/2MLXS6uoT4BJptJtXUEPkbgg5D4yFN
	GTkkw6MF1eKrHXLULUq7lk8CR6qtpuU=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-31-NGFaDLX4PM--iTpT1_AewA-1; Fri, 05 Sep 2025 06:04:20 -0400
X-MC-Unique: NGFaDLX4PM--iTpT1_AewA-1
X-Mimecast-MFC-AGG-ID: NGFaDLX4PM--iTpT1_AewA_1757066659
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45cb5dbda9cso11813845e9.2
        for <io-uring@vger.kernel.org>; Fri, 05 Sep 2025 03:04:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757066659; x=1757671459;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=awGkqZmdOIz0Jf4DYwVDUKWG2obdvFs2eFy/pOJ5Q1U=;
        b=NNTL9j/jDVUDbDgxN1Uk0PdX9lsetLhJ0Mh+5uOGRvAlcTbvcux+UvZbdB/hyeeTZ3
         vXnFsVOMQd+wEcT7FCpVHV6BrSWp+5p6UfKrlQsh86o7IL5WdND/5HmA2D0RcUCFf6Nf
         FVn6cSfE0XGP5IJ9Q/yqKa3mCdphQE8EGnUM7uL4u+HO7CLNfNzzuO++t59MPni9X3se
         rNQ3tgO+Fq35bS5XY4cVvQTWHUygwE/z/+6wCARU3/zwtNTqZIAZxrELE0T3F3ss4N3G
         fjT74As3MFMrWgIT8F9twECqjHqv3COk1+us5mz8bpcooa0LvlMaPdq5IFKj2EhwMmhu
         Z1xQ==
X-Forwarded-Encrypted: i=1; AJvYcCUc0Hn6A8XAmzLMk6h5hj7PNNAs1PY+6k8Spqtyf9cgYL5z9di9byBubdw8xyTDnSWu5mG8Cz4EKg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwG6idZajFyKj0aMUgxkt9ttWboz0xWoyxixCXMEDRrLziFGaOS
	SdHJmM1tClk+NFl7Hs4N4YtbX97yC62WQ+e8wNW4fXQ0BqIxBlRp2hBKDMWd+cVRxPv3d2mkG6k
	9DXV+O9jiQAFOsTC4dbNMY1Kxt3kNNxXfwi0bYcveHMGzxTopw8jBR4hZ4CPN
X-Gm-Gg: ASbGncuMlJtHXqHGiDbpy/DjGKtg2qLMmANVIXwkoWu2ywPgbh1u+PNMBhuQt/T9P99
	5bggTBkupdLOUo2gdGC5u8A68fUXJMFXJvmL7cgv4Jw4KR6xcJAupyz5HoJoo9AN42W+cGMxdhH
	yEFLm9/45EBvnpFYjPWqK8KY/Gdk10PLLVTHy9kzosEFu6FPnRxYNQU98rQrpR0n8H29pdbPR96
	HcnH0B4paCrGgiaXBMOWWSknZzdNCcWvYGFDp3bZoZuoZd+zteXCym7v8I5mrb1ZioQZaePo5pg
	2TJNu8xAJ0g4pDe40BxCUNBFSeUiNRGlfZqGlGvTAxk9QUNkY67QwYRLYX5QGNUHW1jtmzZclgL
	+mqDS0EcWOYOQSzpj747opAguM16Mldpe0tGhjpLP5azbuE5BdFDPjgiq
X-Received: by 2002:a05:600c:4383:b0:45c:b5bb:7b51 with SMTP id 5b1f17b1804b1-45cb5bb7d6dmr66250945e9.30.1757066658737;
        Fri, 05 Sep 2025 03:04:18 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEATYTHWNCVYm2JSlvRaRfzjlHcEv0dS0pGkNfzPAUAL8CJZxqBF9RojGEpR+A9yyhLQ6VadQ==
X-Received: by 2002:a05:600c:4383:b0:45c:b5bb:7b51 with SMTP id 5b1f17b1804b1-45cb5bb7d6dmr66250675e9.30.1757066658286;
        Fri, 05 Sep 2025 03:04:18 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f4d:e00:298:59cc:2514:52? (p200300d82f4d0e00029859cc25140052.dip0.t-ipconnect.de. [2003:d8:2f4d:e00:298:59cc:2514:52])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b7e8879cesm324061025e9.12.2025.09.05.03.04.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Sep 2025 03:04:17 -0700 (PDT)
Message-ID: <6177c4fd-227a-4dc1-89cc-eec44300f6fa@redhat.com>
Date: Fri, 5 Sep 2025 12:04:16 +0200
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [io-uring?] KASAN: null-ptr-deref Read in
 io_sqe_buffer_register
To: syzbot <syzbot+1ab243d3eebb2aabf4a4@syzkaller.appspotmail.com>,
 akpm@linux-foundation.org, axboe@kernel.dk, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <68bab02f.050a0220.192772.0189.GAE@google.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <68bab02f.050a0220.192772.0189.GAE@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 05.09.25 11:41, syzbot wrote:
> Hello,
> 
> syzbot tried to test the proposed patch but the build/boot failed:
> 
> failed to apply patch:
> checking file mm/gup.c
> patch: **** unexpected end of file in patch
> 
> 
> 
> Tested on:
> 
> commit:         be5d4872 Add linux-next specific files for 20250905
> git tree:       linux-next
> kernel config:  https://syzkaller.appspot.com/x/.config?x=fbc16d9faf3a88a4
> dashboard link: https://syzkaller.appspot.com/bug?extid=1ab243d3eebb2aabf4a4
> compiler:
> patch:          https://syzkaller.appspot.com/x/patch.diff?x=1127e962580000
> 

#syz test https://github.com/davidhildenbrand/linux.git nth_page

-- 
Cheers

David / dhildenb


