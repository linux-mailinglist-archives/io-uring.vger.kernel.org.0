Return-Path: <io-uring+bounces-8609-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 16EE3AFB799
	for <lists+io-uring@lfdr.de>; Mon,  7 Jul 2025 17:40:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 63CE24A6664
	for <lists+io-uring@lfdr.de>; Mon,  7 Jul 2025 15:40:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3014136672;
	Mon,  7 Jul 2025 15:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RFi1DEKs"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37E7C1DDC3F;
	Mon,  7 Jul 2025 15:39:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751902799; cv=none; b=g+z3SQ1LVn6WrCZEpnE+xsF7dXeEwkSbz6meA2OtMXWJkCfauj44OaVOcgVXfVo9YZIb01al5ptX3U4mXx6wBZQc7+C9DVpcnfrLUIGX3O0dkcw2kUIKnbVAg+Ds00q67dPXFfWOnHiaj2rBgg/NKHBaA0dTcA2XnvBek+T9/Y8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751902799; c=relaxed/simple;
	bh=ZhePww66v7+1u0nIf44yCLlcotDjaiAnFcUMwsGVNqU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=G35s7rAnBvxon/p/XRY4sYV9GZZqktFf6/HpCWoU1KNyyOwi7q31ciBhcyQD0NyrEjfstNpN7wV0jUbotv7HaflctJg3KEmSLczBDxmNn1/g5vQTAESBNLBlaFBhmkKcQS0XinbShJgoM2vodsoedYF6PD2R5GLgtxK3v2US1MI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RFi1DEKs; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-60c9d8a16e5so6021600a12.0;
        Mon, 07 Jul 2025 08:39:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751902796; x=1752507596; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ezjQuXHd5Rf3mpNjV8Fq8zwJgH75aSXDhZDfm3b1TCM=;
        b=RFi1DEKsK5xAwKTB1PhW4pIYpw/cY2GRAqlmIQeFkaxgCQavx1aFtvvRIudV0+Z5qk
         Oy7RNEDDK9yIrffoJRE11EFP9agoDvvQ/65+c/Fc7pKN6v8bsGzWpfnZBaN+AnXYX8/j
         GQdEPtEudQHOqtfLxj+RLw6Fnwnw7KKroFtg0qCXan4Kr7oKGBAMUWAkI7NvCN+/j7A0
         dRthouoLfW9g0OGWxfLFpYnbkyuhwowCsWn8uG2Ef5yUOYHkf3umU8tWhUUsSCfWtUv5
         F+tWRzwgeTyoERaxT7oP4POR9vzVz+IsvDcyGvs5nPe9c0cyZNdtRzpTntghUAoW8bZ8
         BNFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751902796; x=1752507596;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ezjQuXHd5Rf3mpNjV8Fq8zwJgH75aSXDhZDfm3b1TCM=;
        b=VoHmg+tsAArpdCmmDXluEfkW0zGu6MWRHS8WvyXk91Sg4eE9P2YmUNkplHnKrO4vvK
         uR0FstOWaz1aIdzkiI2pjZP+G2C1GfDnehqtOPaZXzcLcAaBAuD1eFsgopHsUawxnIrP
         mUKy7usKHmpl8NSL/Mp07J8FjNMAq/uGCqe8ssbqVyIXmBZQx9vPNjLWkKX7/y3ZAEyd
         qpeMxTu7oTPXoSiyDIf9JTZN/U2RO85NHEfPNf5j4CIWBtpDnWcSS/zcIEUa8OFEs0IH
         X4L7SpNYkUy2HB0+yJUErVw/5GGZ7q2h8aJA/JsHHZbwNcNIn67tJ8WlvctMZdopShKF
         WzUg==
X-Forwarded-Encrypted: i=1; AJvYcCVBvZKcUBYngIgUZgbfb3THjBl0eRZxRlu7ah67K/gPzTnpYnKRXBfryj1dZqw9j1MgwJZxTUbnsgQ6BaClHQ==@vger.kernel.org, AJvYcCVhxBfomePNfYOrBbo43dXI7S2QqjYTKnBX9kahEhfAzlWIDGsKgbG0bZyJe7MOu4qXVMxBkUxHm1oHCxY=@vger.kernel.org, AJvYcCWqNpFIXfP9Olc/tFVYnQjSOK4P7VdMcytwnyj7BX5JQ6un73rzoGNhhHupJbUhZNoaVkXyiqZtJec/Bw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxsGbsopAn/7/8rBHjvgT0kclySpXNDCmpU8wYBvWflY1eW2dzD
	HcPZMTs9BRS7uBxoNRjB7sCzefy3WKNM4HqN2TgAVBnoN2Pd+PrOgcsMGWAykQ==
X-Gm-Gg: ASbGncvzPeFT41pFMPNzgpo2UqlCOd50igmMP81NFAW7DUUMmFbb/Awcu34eUiwMbPB
	SkJPzDN3AtO8DjocWd4cP7jCTj7zvTBZ6A6ZVTp+krRRXtPej74rg1PikvveCITpgga6tbCiKB5
	qhxTZQZIacuMWMeK8FNG2h3wnKmCMqO9W2/xxEqmcf7A+6xSMYcmG0WAwG2Lr0Fff9IMmvk5l/E
	xgK/MHzMMIsNdn2TxMbBHgekO8OB+/RZE73x3d/wav45YaAfQGjS0QUYKdo4maQdOvIPNenKykX
	OLKfVFI1xzjTr4fQEqPHXf3oc4JoPKyECtM10aJQlzCRBEDFfeAqBnBN2BVhcW1LpQKX52wCGNY
	raK3hYAk=
X-Google-Smtp-Source: AGHT+IECUz+0dR+mX/jDHZopafgoqx5arH4cJ6TohfaPi6RZy5DB6VxRs0wsEPpg/JVzP6t3CV7CTA==
X-Received: by 2002:a17:907:c29:b0:ad5:78ca:2126 with SMTP id a640c23a62f3a-ae4109062f9mr811114166b.59.1751902795974;
        Mon, 07 Jul 2025 08:39:55 -0700 (PDT)
Received: from [192.168.8.100] ([148.252.146.232])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-60fcb0c78efsm5939890a12.44.2025.07.07.08.39.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Jul 2025 08:39:55 -0700 (PDT)
Message-ID: <e210595b-d01f-4405-9b5d-a486ddca49ed@gmail.com>
Date: Mon, 7 Jul 2025 16:41:23 +0100
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
 <f2216c30-6540-4b1a-b798-d9a3f83547b2@gmail.com>
 <aGveLlLDcsyCBKuU@infradead.org>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <aGveLlLDcsyCBKuU@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/7/25 15:48, Christoph Hellwig wrote:
> On Mon, Jul 07, 2025 at 12:15:54PM +0100, Pavel Begunkov wrote:
>>> to attach to / detach from a dma_buf, and then have an iter that
>>> specifies a dmabuf and offsets into.  That way the code behind the
>>> file operations can forward the attachment to all the needed
>>> devices (including more/less while it remains attached to the file)
>>> and can pick the right dma address for each device.
>>
>> By "iter that specifies a dmabuf" do you mean an opaque file-specific
>> structure allocated inside the new fop?
> 
> I mean a reference the actual dma_buf (probably indirect through the file
> * for it, but listen to the dma_buf experts for that and not me).

My expectation is that io_uring would pass struct dma_buf to the
file during registration, so that it can do a bunch of work upfront,
but iterators will carry sth already pre-attached and pre dma mapped,
probably in a file specific format hiding details for multi-device
support, and possibly bundled with the dma-buf pointer if necessary.
(All modulo move notify which I need to look into first).

>> Akin to what Keith proposed back
>> then. That sounds good and has more potential for various optimisations.
>> My concern would be growing struct iov_iter by an extra pointer:
> 
>> struct iov_iter {
>> 	union {
>> 		struct iovec *iov;
>> 		struct dma_seg *dmav;
>> 		...
>> 	};
>> 	void *dma_token;	
>> };
>>
>> But maybe that's fine. It's 40B -> 48B,
> 
> Alternatively we could the union point to a struct that has the dma buf
> pointer and a variable length array of dma_segs. Not sure if that would
> create a mess in the callers, though.

Iteration helpers adjust the pointer, so either it needs to store
the pointer directly in iter or keep the current index. It could rely
solely on offsets, but that'll be a mess with nested loops (where the
inner one would walk some kind of sg table).

>> and it'll get back to
>> 40 when / if xarray_start / ITER_XARRAY is removed.
> 
> Would it?  At least for 64-bit architectures nr_segs is the same size.

Ah yes

-- 
Pavel Begunkov


