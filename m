Return-Path: <io-uring+bounces-8606-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 197A6AFB213
	for <lists+io-uring@lfdr.de>; Mon,  7 Jul 2025 13:14:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 54ABB7A234D
	for <lists+io-uring@lfdr.de>; Mon,  7 Jul 2025 11:13:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52E63292900;
	Mon,  7 Jul 2025 11:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UMo9NfOm"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F072286412;
	Mon,  7 Jul 2025 11:14:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751886869; cv=none; b=hURLY24HF5GErRBNwW4W3k/avBviE1u7M83jQqHiygLsC1dUllPhQsygoz6ey3hHuEh1bvGWzo07PCYsC1kGC8pYklVW5TAYAPyZwS4BiZGYkeGuXS2Q9lGXdXqlgtgrBdE+cp/y1thfykZiUqQnwv+ZU+0K2Lg7lbB7V52i+vQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751886869; c=relaxed/simple;
	bh=wwNXOhUEkGQ4Opb7mt27btwQxprj7tTLk9RgnSGIES0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NHPAyOKQ6iH+I46CPTAoS9HdbTcLBjgLsctVFunNyMVvk/YNXq/114klT2LQC68BLhUnXIbM/zxg1L5yxS9LJgfmPiFONM+OOW2fNO0FqKXkLczvORc9xbvVbFM9bt13Sfl1XsNonOXdelPTypooAasTfay0jR8bIGULtgO73V4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UMo9NfOm; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-ae0bde4d5c9so618688866b.3;
        Mon, 07 Jul 2025 04:14:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751886866; x=1752491666; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ISbJeBw9NAi5f57BeJCVw181+eBAYp7u8b9Kdohio9o=;
        b=UMo9NfOmOSGbxiBAzf71HNdkuFC5l6f3NKcKIe/1W3nD8dQtvnRGhSKGe9N3kgqLxJ
         41X9JZwffr7XouSoEVHQjND8TLxbfW/2qZj40hmu/i46j3hemHHY8XurNwq//FdeVaDX
         JcYm3cmDw58v8QAZF+EP1hvFS3gc8PRWrG5c9a3v969N1b0iWn3RTRWene2enUdaajcf
         OvkyJuq+JmKljJ+lruF/YQR2JxanWFp+XhoK5bO97v+4/WCpdTAFvuzaxcSnvM4S+nnt
         vvChgeURE04XN4ZyUAYf4u+3uLlBS5qQhFwrQAVuR41VXH8rxKPCAAJau/d9LWyS8Cvx
         /qcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751886866; x=1752491666;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ISbJeBw9NAi5f57BeJCVw181+eBAYp7u8b9Kdohio9o=;
        b=BwYJRzgP46HkG1xNF5NtkIBueXuidvFuHaSWzZb/Wmc2fhKlDwqn+cZUSHd15q2OJ0
         3rBsd0IKcGx0UmIIIEtdEb1ix9BcKkXH7XKNYGUDUtG6KQbMkp/nJLc61KeaVg+nAEvQ
         j4SnDt9BvmQdF2RYNOKMll9s8UUoyfvfgvmJ+XmybOX9Q9XkOWvdJqOAoUpGpBCYN1Ml
         oAMC8g/G9kTwLVZU8etG5HkZE9QGXzq0OxCKDqpFy2P3iJiUCNkKMjJI7hPCahWEjzU0
         7xMAJpTkL1+NgBcZAEPEQu4kwWVe8kRZTWDxiVgGSA0nZmXhyUPgC+nIcE8mfzi0xs8Y
         rFcg==
X-Forwarded-Encrypted: i=1; AJvYcCWxlyDx0+Ns6tyCgxIlkv3LXrtzRJeI5WmXX5kZWgUu7pqgci/X1bdjuEIv9VQEja+ITMOntn72jFtmAw==@vger.kernel.org, AJvYcCXLDUGzRzAWeqvNqLSj5iZrhJneSQYwThUl2v3bnYDPyLyfrNVYNx3YtwZX1c7JcETdnz5albyX4wxOx5E=@vger.kernel.org, AJvYcCXNwYqwZdySWRHcpa4J48mneLc5v5SHS8CdGVvTO31NXZQ+WgAIBqg6bzUklnAu0m0q8e5qn5U22RKfPeSVyA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzSCerHjTCL5obybB1SlBlneKeQMOtH1Z3Dkrto4swHdr4Yahhy
	XgBq09s8PtfTA7pVWc4VNIrBjnsuJQ6ldtVCXM28UCz2c7GMHmdUfp9I
X-Gm-Gg: ASbGncumIL/65aVnZoCmuOBo6Ycyhv9uDb42KabGuTiFH7V9AO0KB/Mg2MW0LUJP1TE
	nPt0/7dB87PW8XovK0ENs10m+/fzvemEwlTZHTlPyjXgr/70KmV2msAbdgkKCvR8g8l+C7H3ET5
	9BMRdGO6+kXzRySBFGogLiabWFq9KSwenIUKeX7yJfUl0umbFdfhw3eHG/7LqE8vbPBmmkxyUd4
	NweLz7NkkgAXmScTBWYaRZ2iOQpq5jW+tZHyAosuOh0NZnCwRhC2awpV9iZcNuFF59DOHvQ7lHl
	0sEN8gmT39N7fgbcRSeF+d69WxBO4pE5Iymz+CHBWgVYArP00CsYOfxwtUUa+DVL0MeNS/kRg9b
	Fs6H5SujD9A==
X-Google-Smtp-Source: AGHT+IHXy0DieX4Ryfe7fnqNm2npiGA05vFcH84u4de0iwjmdTb2PEXlvbji/iKcic0iBMD+4uS9wg==
X-Received: by 2002:a17:907:dab:b0:ae0:c523:780c with SMTP id a640c23a62f3a-ae4108c85a2mr739098066b.5.1751886865420;
        Mon, 07 Jul 2025 04:14:25 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325::1ac? ([2620:10d:c092:600::1:adc3])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ae3f6b0336asm688993666b.115.2025.07.07.04.14.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Jul 2025 04:14:24 -0700 (PDT)
Message-ID: <f2216c30-6540-4b1a-b798-d9a3f83547b2@gmail.com>
Date: Mon, 7 Jul 2025 12:15:54 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 00/12] io_uring dmabuf read/write support
To: Christoph Hellwig <hch@infradead.org>
Cc: io-uring@vger.kernel.org, linux-block@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 Keith Busch <kbusch@kernel.org>, David Wei <dw@davidwei.uk>,
 Vishal Verma <vishal1.verma@intel.com>,
 Sumit Semwal <sumit.semwal@linaro.org>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
 linaro-mm-sig@lists.linaro.org
References: <cover.1751035820.git.asml.silence@gmail.com>
 <aGaSb5rpLD9uc1IK@infradead.org>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <aGaSb5rpLD9uc1IK@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/3/25 15:23, Christoph Hellwig wrote:
> [Note: it would be really useful to Cc all relevant maintainers]

Will do next time

> On Fri, Jun 27, 2025 at 04:10:27PM +0100, Pavel Begunkov wrote:
>> This series implements it for read/write io_uring requests. The uAPI
>> looks similar to normal registered buffers, the user will need to
>> register a dmabuf in io_uring first and then use it as any other
>> registered buffer. On registration the user also specifies a file
>> to map the dmabuf for.
> 
> Just commenting from the in-kernel POV here, where the interface
> feels wrong.
> 
> You can't just expose 'the DMA device' up file operations, because
> there can be and often is more than one.  Similarly stuffing a
> dma_addr_t into an iovec is rather dangerous.
> 
> The model that should work much better is to have file operations
> to attach to / detach from a dma_buf, and then have an iter that
> specifies a dmabuf and offsets into.  That way the code behind the
> file operations can forward the attachment to all the needed
> devices (including more/less while it remains attached to the file)
> and can pick the right dma address for each device.

By "iter that specifies a dmabuf" do you mean an opaque file-specific
structure allocated inside the new fop? Akin to what Keith proposed back
then. That sounds good and has more potential for various optimisations.
My concern would be growing struct iov_iter by an extra pointer:

struct dma_seg {
	size_t 	off;
	unsigned len;
};

struct iov_iter {
	union {
		struct iovec *iov;
		struct dma_seg *dmav;
		...
	};
	void *dma_token;	
};

But maybe that's fine. It's 40B -> 48B, and it'll get back to
40 when / if xarray_start / ITER_XARRAY is removed.

> I also remember some discussion that new dma-buf importers should
> use the dynamic imported model for long-term imports, but as I'm
> everything but an expert in that area I'll let the dma-buf folks
> speak.

I'll take a look

-- 
Pavel Begunkov


