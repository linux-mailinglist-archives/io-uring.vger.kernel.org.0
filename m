Return-Path: <io-uring+bounces-8464-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A0EEDAE62A5
	for <lists+io-uring@lfdr.de>; Tue, 24 Jun 2025 12:38:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1E5001925123
	for <lists+io-uring@lfdr.de>; Tue, 24 Jun 2025 10:38:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11E68288CA2;
	Tue, 24 Jun 2025 10:37:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="S5vnEboQ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56D8D28689C
	for <io-uring@vger.kernel.org>; Tue, 24 Jun 2025 10:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750761426; cv=none; b=V1AtXLSc+LbCQ5/Z5jxfb1zkXqXJpm3Amf0ERMWgbMoB+B+4KdUg36TBbTe68ZPQZQ93wiVUgdNWanx1ic70+AscBBiPBxJdJBwVdaRawuLWJtchWL2dyolsS7SiNQDCT9Zi6JOiXyuM6EK1Ji1+CMvWHul2jk66J6sZczHYU+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750761426; c=relaxed/simple;
	bh=CIZW1ZGLxAsOZc77hXEfkx7JARkl8uHxlQi7UeqJMLk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=q25LRe5W2+7DWbP//x8lBax0dxLGdmULXhLEZx4RQNRDBNep1y27FQyMSFTLHeO5tix6PCvRWZBqg3ddNipMqZX+tV0HF4xQXVbNHe9epqX5ctC5wpfPMbGtb5eFOSVwc2Ol24Ti3sBYtIX5C1sG9pkSDKOpV7eDhczFVK5Boak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=S5vnEboQ; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-acb5ec407b1so860051666b.1
        for <io-uring@vger.kernel.org>; Tue, 24 Jun 2025 03:37:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750761422; x=1751366222; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vig3sFKx5CIiTbV6+rwGmVyDkE6koLlV39giMQWKVyY=;
        b=S5vnEboQMThQKeH/Ul/y36yz7LiNAtCy+DvAWlM+z6o5PiyFaj81E8PVv/re9s17P9
         AELxxqzcVBSR092b9znUPi7dV3nfbBlAx47TJb1cn89e1A2OX/rfplEdtqGFS+GrcmPL
         UqQ2s00N4FlZsb6735Rtofe2CjoROFTQ2x1K7OMZ8xx7W89qb0L6bDJrwzYC2F/oblYy
         djg2pZvALJmuNJQ1yRx4BEke8roFb4HJcbeUcG1+ipzesk5ApPAi3HZmA6iT/0AxWFpc
         arTbkO3KBMyAoUQkFENSvKBL5OiaqjS/8OF8f+TDOp6x5uXdeVCmPfkNYy1QSUmy5514
         IzsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750761422; x=1751366222;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vig3sFKx5CIiTbV6+rwGmVyDkE6koLlV39giMQWKVyY=;
        b=a0RkU6Rwg1i41MZ3uKkUS/mDYZk9lrdpQwrpRoetrb8lYxDb3t5F1jvw95Xp3q80L1
         JFJdBh4KvDi8vecF2tXZ3KHkq2sg1NKcoszFhqmzTojGU4QUbXkGDfobfIAXt0qunKLJ
         KAZmrTz5EM7OVLX8djzM93aXaBvYCRa/p2KdNdHrGtjmpGD+e+fcoRpwksGcLmIk9tHG
         fkZvvEzbEGGJMmSX3KB1USJIDdrc9Sd9O37RbmQBnlwUulNe1v8rHDVbWCyEx2pqoD28
         veGkiUOtS1NGQUaUKSuPBOjHkCa9Dn7LbbjNGpRE4g9Z3AHoH7U+MtjSKSoeW0bT4++K
         LO/w==
X-Gm-Message-State: AOJu0YyQWdetDiOgVqOZoB525xNqP/vrpQC9Ivk6txpUjJSPV1l5L80J
	YFsMrB/ytmNIeDZ6CCgrGrPuvgESDiA09BIlcLR6zQgLBVhK0sS/2f4UR9w1FQ==
X-Gm-Gg: ASbGnct9VkJ5j6VJ7Iq0pG/CqmuLTH3wXFxz8NPvMg02c4heCwmHMp6EeZGC0h8vCjq
	I4mF+zMrvRtFLEYlch1cdufYAS6eXiA2wQpoKHfCa4c9sYSzBfnj7rwsQw0rMWJVXFd4JmcSBSW
	DN3ZI3xFD8lbg7MnX496iiT2OyQSPatj9IKxYou+KdtVYPj6LjCIHFXuo4qElt1Ajwjzhnp8kU9
	BlxEJmbAxHBDUJ2YTlTNzLbI+VjEjjCTvlCknM9ul1O7rRCtW1kHeW7muALecuxWWTUDQfEdNyk
	YtZ+/bWGymIMkmG8fq/wsqHF1dzfZVa+pj7pGbzCtQYPLrgia9gJ6qwf4RyZShgC4GpTnWvQ6sw
	=
X-Google-Smtp-Source: AGHT+IF+OaKcpJfiLkROPRTBIAY/k9gadz0WYVALygSyByomb1HlUG5o5GaqRQ5SDpUygKy23rrgeg==
X-Received: by 2002:a17:906:99c2:b0:ac6:fc40:c996 with SMTP id a640c23a62f3a-ae0579d88eemr1508775966b.23.1750761421818;
        Tue, 24 Jun 2025 03:37:01 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325::2ef? ([2620:10d:c092:600::1:112b])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ae053e801c1sm875316966b.17.2025.06.24.03.37.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Jun 2025 03:37:01 -0700 (PDT)
Message-ID: <a6be01c8-5e36-447d-acd1-3491bb50faaa@gmail.com>
Date: Tue, 24 Jun 2025 11:38:27 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 0/3] io_uring mm related abuses
To: io-uring@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>
References: <cover.1750760501.git.asml.silence@gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cover.1750760501.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/24/25 11:35, Pavel Begunkov wrote:
> Patch 1 uses unpin_user_folio instead of the page variant.
> Patches 2-3 make sure io_uring doesn't make any assumptions
> about user pointer alignments.

I didn't reproduce the alignment issue, sth wrong with my
KASAN'ed machine, need to fix that, and it did't trigger
without it.

> 
> Pavel Begunkov (3):
>    io_uring/rsrc: fix folio unpinning
>    io_uring/rsrc: don't rely on user vaddr alignment
>    io_uring: don't assume uaddr alignment in io_vec_fill_bvec
> 
>   io_uring/rsrc.c | 28 +++++++++++++++++++++-------
>   io_uring/rsrc.h |  1 +
>   2 files changed, 22 insertions(+), 7 deletions(-)
> 

-- 
Pavel Begunkov


