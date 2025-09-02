Return-Path: <io-uring+bounces-9533-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CF873B3FAE7
	for <lists+io-uring@lfdr.de>; Tue,  2 Sep 2025 11:42:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2D830163180
	for <lists+io-uring@lfdr.de>; Tue,  2 Sep 2025 09:42:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E37D82EC0A5;
	Tue,  2 Sep 2025 09:42:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="E9zJZ1ao"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DA482EC0A1
	for <io-uring@vger.kernel.org>; Tue,  2 Sep 2025 09:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756806161; cv=none; b=L7/IEBHGVSyr+TWV/NrSZ4V1LXncq4qqoDn9OZhUI2YS1rnHWoL0qY+HWViMfqqn7M1DBU7ORmCgvBziAHBNDFD5gKoLvi2vm0bkXNfOeBDaxlUYMB7Tp+9/Xwgv+F5mAmWpw6SLxIhm9OXFwOANqyE14k4iakGaju1+w2vlYtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756806161; c=relaxed/simple;
	bh=i4FWrMpTncOFRXoqXlabsDTohw1HlWD08a2XpGq8Mr4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TAOciglP0j2Jy4LpAdBe38e5rzwg4nk2pwwQ/kzyRlE5dCwy4Q+oHA8TRnhjtx3BNabT7gqsMINs4Jv7igpwLDI7lAacGiV+TWPsiCntHyn/d3Ct0gPKq2KdqX6i1g6Mx9iKq5IzSN9aWX6pzv1gf99YH+fDDWWwU3j41oZmo9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=E9zJZ1ao; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756806157;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=asWSuLH6iU8nN8yxFqi4dFvgrrSedS75Z/J4pSraBcc=;
	b=E9zJZ1aoIwXJLF8wtF0rPENWj8qxa0CoI7H1xy4OIJ5KNO8nqolaTnri3pmpEvVZnmlBc+
	c/JvZvfvQRe9OCz4oAasfVW6exC529zBP4v7YhSH6c12gSCUNzTFWeghucHKTelhZxJOAQ
	RbOADTL875KPGE75VjXAqmUyCY/ZpO4=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-455-dIE3kJYpNoGsAMeMQhXgow-1; Tue, 02 Sep 2025 05:42:36 -0400
X-MC-Unique: dIE3kJYpNoGsAMeMQhXgow-1
X-Mimecast-MFC-AGG-ID: dIE3kJYpNoGsAMeMQhXgow_1756806155
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45b9c1b756cso973845e9.3
        for <io-uring@vger.kernel.org>; Tue, 02 Sep 2025 02:42:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756806155; x=1757410955;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=asWSuLH6iU8nN8yxFqi4dFvgrrSedS75Z/J4pSraBcc=;
        b=xT6EJnjkAvPyiUb1xwZ+1hJDIWARrxxFViv/KQ7Mw2iFZiT4CzwIa0EeeTMFjUD1Li
         p9KonGF/IBaHcNojJjXK5X/F77e7jgXUOPSoFZjrz7iQQOo35tklH4KKlWpCW6n0b8xw
         HX67IoeTa/vK/2oj8C3C9V7S5CbzBGZ+2gbnupF40eLLkl7GNGcpPzvdnJuk/UanlxDc
         UNL2VG8JA+Q8fPKJAifRQIzcI4lUsac3ZdsxiDtfnnb/Z4vRA+QPIGSkVHlsiUUVkXup
         bO7us7+K5h+hy0oKOHWiSCO4T7ksK72ROjdm5s8qQjp+F+moI+Xr4+clymhAAN/LNZ9/
         SBOg==
X-Forwarded-Encrypted: i=1; AJvYcCXmp11b7Y6z3DqWnmxuckV3RTryCAptnSJTtBuDLGJWjik5IYczRddCYiJ3AoXRpbyMHbHyTlsc+Q==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxw98Q5GrZSoYJdM+W1lV4u39WauadSJphFjZglpT+wQe32O5VQ
	sxZglqmju18sBONdpnZ0GwRF8umDCEK3mfHE7KWmUvvSzAgtOWYDBN9xNUjz3dbVvz3772gW/03
	Hn1fk+71iuXWAfqYqZrM8qIp21mCLhTZxHiqMyTobnO3lvmMU0x/SKDtwIG5e
X-Gm-Gg: ASbGnctRB3RiivGDzd+Fd9ly8GrdBNuSt8qufaRJ9S+mceppoQPWF7y1a9BBdsVdVHC
	XBs9z8SXelwdCCnMAVZliAd12VdPcNTle4PD9xo3/8nDBHZwMnY0dk8/7+2RBYVEVitxfA4bIUx
	FQKHM8GG8ZOar/dEGGy2UHt72WwW8dlpnbKEFc7TdE4bhqlPdP8p8HPkYp5E+sW+omOjYBhi5Q+
	kC+j0ab3HFZCqewHteK5p0bSL0BQC/vxzB+SIzcem7tKB84R9C0G2531ZPtd9wAjJfdSALs61un
	fq2ycoqn2rni4JoHZl3pag7Q1zQo5hLuGxR7gvsHXLdzDGHsB33ozyoht34auddkSWB3rvrzOOa
	gd1Gj2+Ffg908A/GCPO5+XYHIN1s5sUvY0zGANglnT4xv3tg5Q7FFPM4skxHhIksSHxU=
X-Received: by 2002:a05:600c:1ca4:b0:43c:ec4c:25b4 with SMTP id 5b1f17b1804b1-45b8554e2ffmr100852685e9.10.1756806154846;
        Tue, 02 Sep 2025 02:42:34 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEDiNU8UZPL8aTl3qS6g7/9CMF4yIxtcwFaCcDzAuhGVy5bNnLkv/vvSAEHWB2EXNvzk4IR6w==
X-Received: by 2002:a05:600c:1ca4:b0:43c:ec4c:25b4 with SMTP id 5b1f17b1804b1-45b8554e2ffmr100852105e9.10.1756806154215;
        Tue, 02 Sep 2025 02:42:34 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f1f:3f00:731a:f5e5:774e:d40c? (p200300d82f1f3f00731af5e5774ed40c.dip0.t-ipconnect.de. [2003:d8:2f1f:3f00:731a:f5e5:774e:d40c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b8acbe982sm57017205e9.6.2025.09.02.02.42.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Sep 2025 02:42:33 -0700 (PDT)
Message-ID: <22019944-2ef2-4463-9b3f-23c9e7c70b2f@redhat.com>
Date: Tue, 2 Sep 2025 11:42:30 +0200
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 26/37] drm/i915/gem: drop nth_page() usage within SG
 entry
To: Tvrtko Ursulin <tursulin@ursulin.net>, linux-kernel@vger.kernel.org
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Jani Nikula <jani.nikula@linux.intel.com>,
 Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Alexander Potapenko <glider@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Brendan Jackman <jackmanb@google.com>, Christoph Lameter <cl@gentwo.org>,
 Dennis Zhou <dennis@kernel.org>, Dmitry Vyukov <dvyukov@google.com>,
 dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
 iommu@lists.linux.dev, io-uring@vger.kernel.org,
 Jason Gunthorpe <jgg@nvidia.com>, Jens Axboe <axboe@kernel.dk>,
 Johannes Weiner <hannes@cmpxchg.org>, John Hubbard <jhubbard@nvidia.com>,
 kasan-dev@googlegroups.com, kvm@vger.kernel.org,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Linus Torvalds <torvalds@linux-foundation.org>, linux-arm-kernel@axis.com,
 linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
 linux-ide@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mips@vger.kernel.org, linux-mmc@vger.kernel.org, linux-mm@kvack.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 linux-scsi@vger.kernel.org, Marco Elver <elver@google.com>,
 Marek Szyprowski <m.szyprowski@samsung.com>, Michal Hocko <mhocko@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Muchun Song <muchun.song@linux.dev>,
 netdev@vger.kernel.org, Oscar Salvador <osalvador@suse.de>,
 Peter Xu <peterx@redhat.com>, Robin Murphy <robin.murphy@arm.com>,
 Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
 virtualization@lists.linux.dev, Vlastimil Babka <vbabka@suse.cz>,
 wireguard@lists.zx2c4.com, x86@kernel.org, Zi Yan <ziy@nvidia.com>
References: <20250901150359.867252-1-david@redhat.com>
 <20250901150359.867252-27-david@redhat.com>
 <4bbf5590-7591-4dfc-a23e-0bda6cb31a80@ursulin.net>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <4bbf5590-7591-4dfc-a23e-0bda6cb31a80@ursulin.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 02.09.25 11:22, Tvrtko Ursulin wrote:
> 
> On 01/09/2025 16:03, David Hildenbrand wrote:
>> It's no longer required to use nth_page() when iterating pages within a
>> single SG entry, so let's drop the nth_page() usage.
>>
>> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>> Cc: Jani Nikula <jani.nikula@linux.intel.com>
>> Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
>> Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
>> Cc: Tvrtko Ursulin <tursulin@ursulin.net>
>> Cc: David Airlie <airlied@gmail.com>
>> Cc: Simona Vetter <simona@ffwll.ch>
>> Signed-off-by: David Hildenbrand <david@redhat.com>
>> ---
>>    drivers/gpu/drm/i915/gem/i915_gem_pages.c | 2 +-
>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/gpu/drm/i915/gem/i915_gem_pages.c b/drivers/gpu/drm/i915/gem/i915_gem_pages.c
>> index c16a57160b262..031d7acc16142 100644
>> --- a/drivers/gpu/drm/i915/gem/i915_gem_pages.c
>> +++ b/drivers/gpu/drm/i915/gem/i915_gem_pages.c
>> @@ -779,7 +779,7 @@ __i915_gem_object_get_page(struct drm_i915_gem_object *obj, pgoff_t n)
>>    	GEM_BUG_ON(!i915_gem_object_has_struct_page(obj));
>>    
>>    	sg = i915_gem_object_get_sg(obj, n, &offset);
>> -	return nth_page(sg_page(sg), offset);
>> +	return sg_page(sg) + offset;
>>    }
>>    
>>    /* Like i915_gem_object_get_page(), but mark the returned page dirty */
> 
> LGTM. If you want an ack to merge via a tree other than i915 you have
> it. I suspect it might be easier to coordinate like that.

Yeah, it would be best to route all of that through the MM tree. Thanks!

-- 
Cheers

David / dhildenb


