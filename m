Return-Path: <io-uring+bounces-6420-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0FE6FA34C3C
	for <lists+io-uring@lfdr.de>; Thu, 13 Feb 2025 18:45:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8DB693A3600
	for <lists+io-uring@lfdr.de>; Thu, 13 Feb 2025 17:44:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDC0D221553;
	Thu, 13 Feb 2025 17:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="fU9IlGGn"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f174.google.com (mail-il1-f174.google.com [209.85.166.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC6252040B7
	for <io-uring@vger.kernel.org>; Thu, 13 Feb 2025 17:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739468697; cv=none; b=uDgT4c1YAljTsRIeTpScLNDfABPSGJyiRf6/LG3pw9DXK3Ld2FGRjYO2J4THCgMqa5bJRCr1oUyYwyg6ggWdKG6efJN6gWuF/L6jhnn7vOhi1RU5aElrl0s3QzlD+C1LLkPIFH9NUaDfXthH++CMnwhSn3q1bLemTJO48x1h/Kc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739468697; c=relaxed/simple;
	bh=hrpLg2JhgMbx+D1O6IZSnxWLxFOKlv+y7zfb9vkifI4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fgH9J4r8OEemb5pljkOiUcSHemxLmEGwrKQzgBXUQuhQY1fUFyXiFTQKgtv9U3gfhcDXDAXNBd5W+AtoMh0UEBIwzVqQMJtbSS1oi2V2rH4Erlg0H4gQjPqmVRf00/6nmz4O/GXNZUIGsG6EjVCmvAK4tTRqfpK3MKJpWL9h86k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=fU9IlGGn; arc=none smtp.client-ip=209.85.166.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f174.google.com with SMTP id e9e14a558f8ab-3cf82bd380bso8381465ab.0
        for <io-uring@vger.kernel.org>; Thu, 13 Feb 2025 09:44:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1739468695; x=1740073495; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bK6m8E4s0v6G7z1TcnwnBz+16kXFrHv6/vH+jaejNVY=;
        b=fU9IlGGnZTAER9ZzOrPYzPP/ZE4t6rqkGjvr378Oc27I83kDQT0wdF2lN1euTw+R5M
         DrTildnQ+cXwzhcPTsl5n7KCai55IHf4OxlpcrQnzjcmiNbPQMultRusJCV2Eze2b+ft
         2C8T6z3lT/fv7JGOdkpl3qLk1s0P+BgCeNJ/oqjVEpDm/93cSKe1mDxU7NzA+MT+MgsY
         B323HKEC5wTG9+3lxCz+LPFq8ruZJgyE2GHleou9wtu4VkJ285eNI1Saam+yLUdqY+Bo
         vqY8tpTKIlOSkdZK2iMIVKqSF2EfBtn/nXe5NAlRLo2ezTs3tDR2k8drP85t7eLkzb7M
         4+oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739468695; x=1740073495;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bK6m8E4s0v6G7z1TcnwnBz+16kXFrHv6/vH+jaejNVY=;
        b=rMfAanr3k4h6wwgOhH2QbWBNEyT7MM+8RwrOBLWrRB2RLFpGinpz2CwOmt/C3g2cZ9
         SjJrzcziYEX1XClNbVBvpj1e0AjiyDhm2rBRAV/h+t/JNRDbGJhzZzrgq5CUd+5LTh2p
         Z69d6t90JOL/4zyAuhGhUujCvFOoTqNSZYFAE4368yi8BYP+Wi93X5OnkPFMFpTmKGBw
         UDkJbVRfipVGZUezZQXEKGwRgzrHrb8BabMGZ/x3DaTulnDPKq7h/neVYC3OG5bR36tz
         M7Ntn5xl8pSYdTDT6ZZ8pzRj7M3K68NEetOYfByLZbu96NCbRTG5sThmms/TPsfIiIHm
         46dA==
X-Forwarded-Encrypted: i=1; AJvYcCUppqDR6NaWmCn1axQymzyiJ6sAymQR4R/N2SeGP5pBSn/OSFGzjpRNyAHtq3K2xtSHW8IXhw1j1g==@vger.kernel.org
X-Gm-Message-State: AOJu0YzoepR3gPwVSzjrDI1smSBnNEN6WHOV8MItISE1VmAXxsV+rFfS
	1b4wrZ3CbJxRAAQ4k++KRT2Hm04ld6iDRyJf34lpAB/rQ+AjPrsMgvT6eXmBYOE=
X-Gm-Gg: ASbGncu6pLPrEIn0/l+02qKPzmgzDTDpwy6WESmn2/JTMED97jcoJ3R8NF/6FWiPE5M
	jqs318pVS/yJc8h+nIR6p6vPFDlwLxVi4trXzh5M7ASPdbF7hXzWL33WnIZopNBksXkseDt4eWH
	2ro/JE4B/1B7gc8ZTgrNiPADzz2O4Dg9zMgBfNR3LO46Zd+UIhgUPwUx5e86cPe15ZuQLNm+J99
	bddmsPTi9QDDiwfu8r4SgL9AyAJ254RAvZshpGjgOIiqErwDdq/fFJ+p24atBE1Ot1zA1MegU4t
	8RX9VGUSrgw=
X-Google-Smtp-Source: AGHT+IE1Ezg0Y8aXI/E6ioGTW0+26Fz1xogeYAi7H3667OkEIBvf6oS6rUrX2UK7Mmd/m6ZRO2sM+g==
X-Received: by 2002:a05:6e02:1d0a:b0:3d0:2548:83c1 with SMTP id e9e14a558f8ab-3d17be271c8mr74490995ab.6.1739468695007;
        Thu, 13 Feb 2025 09:44:55 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ed2819d118sm409197173.65.2025.02.13.09.44.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Feb 2025 09:44:54 -0800 (PST)
Message-ID: <b559f593-512d-48c3-81cc-ae85b3a194ec@kernel.dk>
Date: Thu, 13 Feb 2025 10:44:53 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 00/11] io_uring zero copy rx
To: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org,
 netdev@vger.kernel.org
Cc: Pavel Begunkov <asml.silence@gmail.com>, Jakub Kicinski
 <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Mina Almasry <almasrymina@google.com>,
 Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>,
 Pedro Tammela <pctammela@mojatatu.com>
References: <20250212185859.3509616-1-dw@davidwei.uk>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20250212185859.3509616-1-dw@davidwei.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/12/25 11:57 AM, David Wei wrote:
> This patchset contains io_uring patches needed by a new io_uring request
> implementing zero copy rx into userspace pages, eliminating a kernel to
> user copy.

Still looks good to me - I'll be rebasing the for-6.15/io_uring branch
post -rc3 this weekend, and then setup a branch for this and get it
applied.

-- 
Jens Axboe


