Return-Path: <io-uring+bounces-8591-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E3400AF6616
	for <lists+io-uring@lfdr.de>; Thu,  3 Jul 2025 01:12:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3D12C52483F
	for <lists+io-uring@lfdr.de>; Wed,  2 Jul 2025 23:12:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 079CC243964;
	Wed,  2 Jul 2025 23:12:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="mzexuzGz"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8318924111D
	for <io-uring@vger.kernel.org>; Wed,  2 Jul 2025 23:12:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751497943; cv=none; b=QBAcEngaMh5o/9o1ma5A/gS5HIVfjUCksK0vItvWU6N37mzZ+4XYJl2cmZTnDbu+pYF2i1keF21AIG9Gbs+cRK4h7eSakkyK4cKpB2qxT96Tg9IDS/jFpq7wDCqKMc5FMC6Xyl8rOFi8Wsjq77GhKFm/QBzlbem/zk1j2Eo9CQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751497943; c=relaxed/simple;
	bh=W5DEVZVZD/XdBgp83mbAEPVPZScxL5P52rl1yMN/7Cw=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=RG4jb4hZQvoNFEb6R16Dek13iA7yTFANbLYa4Y/KOTRiwV6cPqzJysGdPrW2Xn99mYGMBuHKqv1k2WDp/IjHmc1swagIi6LzReIeBi+LFRbUzIe09MdcRJ5Nd5ocYd3cv3S29UgBI6GUQzjaRg0ywboamvMBttHmFvxCtmX6zf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=mzexuzGz; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2366e5e4dbaso2677145ad.1
        for <io-uring@vger.kernel.org>; Wed, 02 Jul 2025 16:12:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1751497942; x=1752102742; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7B9vig09hHsY0W2H5ZuA1ruKHor7ujjbbpl283tqHa4=;
        b=mzexuzGz1yrwmoxp/vQRQIr9HIKW6z6P6YM4/nErb9cjJysIiT83bDMtUhqUaAv4Dz
         u7hOG5t4sJSKTXsENAOPTqdvnWQb01d1cp0FG7PP4ayfqXAv5n92UAlnHgJr1w1WOpk1
         dGH7xqASoVweT9X9Jy7YPkrW67NwEaYw/aBTrC/MTrS3mNv/cWldYf2eicnV7aGpi9gx
         1R5eTcqL3vSnyE7ZgRGJhU6R+XzbJUnsikDe7Q5d+ByZm3FG5IhZjyGZLkWopz97qw4h
         ZJAzUHfEH3p/OsY4xcjQwSmXM/0SpS12Ui8SNErGM3CQBFpXDPxWr4HvftxwZx+mvTYD
         at4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751497942; x=1752102742;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7B9vig09hHsY0W2H5ZuA1ruKHor7ujjbbpl283tqHa4=;
        b=WHrGNamCMq4RvkDpppivJglNkByhwiAmHQvZFD7u60ROZmRFtTVrbTxc/u/T2Yg0mf
         IBJJsL/HzhI77zDpIqIwEF7CkYJ19Hwtv5S3PROnJFSQEoGzkXFaqP52Jk4Fj4enVd10
         ge7cNPLWRwqRQwmMeifXwGXOxeo6Vxu72idAciHjfi6iB04NxnNDdUKT+VevA9jx/hdg
         bw/6ZW4n7EZTD9K+lhAFcRS8j2s3zRdijzVQty+aMFk+lErSSPWT8SIzxWsVBTUnxXyJ
         PjsUp7Fowjo/uWzBmIsnfp94w9SBz3EAGsvh+KnfNRcW9phnWwr2QjpTG0J1UkTzwlvu
         uaTg==
X-Forwarded-Encrypted: i=1; AJvYcCWxar+K+CYdqrLWkAdoALARrYSwVBCALCf4gLCtznbu+Tm5anys64bkPasNeqYC3UnaJ8Hu/yMVNQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwxDwk/WRz5ZXYI5B5lgQF9rVUxxP7F68Gpb/ZoB1llHnlJU0EV
	cNHOXm6ZGSURYR9UnwEePSUzQUw5BYOEYezZu8jQhJIMFGrG6uyJAmoNKB0eUjDu2cs+9TTUFhb
	m9wKsRQM=
X-Gm-Gg: ASbGncvyAmH138mdn+PZJWT6r0o3FCt0K90EXOZvBgyoFgD2ERuHJIlc/cGrZTZZF+3
	+fYRRpekKTIYe6/WuVDS9lsNdhUQ+ziudrVywB+oeDco+NmK/7EtZzibWyseJoAotEzOdBDevw5
	JjBLYXSW4Xtrdb0nkr1VXw0HjcQvdKQd8o5V0hPIB037ht84Rxe4I4b0jyvkBCcRTbcbR3T7MJI
	kn1StdGeuOTBCqce3NGDWi1GtLlK7wJ44cRmgqNaUDafO0Jf4VaE85oU+YTN0mBg8aZLBobcbNJ
	CyGQxNjZmXlZXJhAVTSOFb4xy2k5FFawOcIMqfBoLaSYSL6slQAncnib1+0YidtXMEyDYySJNaS
	jLwID1HI/Jqv2lo4/OUuodRJP
X-Google-Smtp-Source: AGHT+IGa8Z8TPVM3onlmsTgi7J/k2r2fh4iKp05ofZWWu93QFGrAxUe1M/JCABSLqt4DopZqV1CiNg==
X-Received: by 2002:a17:902:f745:b0:235:e1e4:edb0 with SMTP id d9443c01a7336-23c7b8ff87emr466125ad.22.1751497941755;
        Wed, 02 Jul 2025 16:12:21 -0700 (PDT)
Received: from ?IPV6:2a03:83e0:1156:1:14f8:5a41:7998:a806? ([2620:10d:c090:500::5:b65f])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23acb2e2493sm147183555ad.48.2025.07.02.16.12.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Jul 2025 16:12:21 -0700 (PDT)
Message-ID: <01e5a711-fe8b-4d5c-b8c6-325fe2d67dff@davidwei.uk>
Date: Wed, 2 Jul 2025 16:12:19 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/6] zcrx huge pages support Vol 1
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1751466461.git.asml.silence@gmail.com>
Content-Language: en-US
From: David Wei <dw@davidwei.uk>
In-Reply-To: <cover.1751466461.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2025-07-02 07:29, Pavel Begunkov wrote:
> Use sgtable as the common format b/w dmabuf and user pages, deduplicate
> dma address propagation handling, and use it to omptimise dma mappings.
> It also prepares it for larger size for NIC pages.
> 
> v4: further restrict kmap fallback length, v3 isn't be generic
>      enough to cover future uses.
> 
> v3: truncate kmap'ed length by both pages
> 
> v2: Don't coalesce into folios, just use sg_alloc_table_from_pages()
>      for now. Coalescing will return back later.
> 
>      Improve some fallback copy code. Patch 1, and Patch 6 adding a
>      helper to work with larger pages, which also allows to get rid
>      of skb_frag_foreach_page.
> 
>      Return copy fallback helpers back to pages instead of folios,
>      the latter wouldn't be correct in all cases.
> 
> Pavel Begunkov (6):
>    io_uring/zcrx: always pass page to io_zcrx_copy_chunk
>    io_uring/zcrx: return error from io_zcrx_map_area_*
>    io_uring/zcrx: introduce io_populate_area_dma
>    io_uring/zcrx: allocate sgtable for umem areas
>    io_uring/zcrx: assert area type in io_zcrx_iov_page
>    io_uring/zcrx: prepare fallback for larger pages
> 
>   io_uring/zcrx.c | 241 +++++++++++++++++++++++++-----------------------
>   io_uring/zcrx.h |   1 +
>   2 files changed, 128 insertions(+), 114 deletions(-)
> 

What did you use to test this patch series or will that come with vol 2?

