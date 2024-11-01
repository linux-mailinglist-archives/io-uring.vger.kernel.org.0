Return-Path: <io-uring+bounces-4339-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A1B109B9A01
	for <lists+io-uring@lfdr.de>; Fri,  1 Nov 2024 22:17:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 583E11F22F92
	for <lists+io-uring@lfdr.de>; Fri,  1 Nov 2024 21:17:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C26501E2604;
	Fri,  1 Nov 2024 21:16:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W3iJBmUA"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A50E1547DC;
	Fri,  1 Nov 2024 21:16:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730495815; cv=none; b=iRW1zYCv769bCX9O8L8qlDxOFEXnmiP2s8cL+/kYZmGDnunMByk4D+QCLrbbjFgt8lA10OQsfOXAEQqLbBPWmsogCec5dWMF8PLw8j+RLqeXL1nMN/sj+R6l6N/f5xo/Cw6AVCNdeTmew8WruOcqq7fcRrODGT2GjNbVeIpE6AQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730495815; c=relaxed/simple;
	bh=xOtjIU76/6UVuXbA47J7OkfyU328phIrEkAD9TrtXbs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uckog/uWMVAOLG91Es65jywi8gs3V6Hl61+z91ewuW82dqHjvBs0qn0sgYRa6Pm+TnpZOjp00TMblB9ekcJg8vxC0PGx0ctXb4tmv+vUM1TAu74ZlvMhr2WFh8gNTgRM9pxbU7eNeDmf2KHkPhmPjjQ+AB8FWq4hj+iLz3agZ+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=W3iJBmUA; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-37d3ecad390so2138245f8f.1;
        Fri, 01 Nov 2024 14:16:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730495811; x=1731100611; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1H7uxdTQs0chBY951yxomZ1Iay/UJ/Umw2IFMPAb96U=;
        b=W3iJBmUAwF4gh/vASHvKMduYIXVMAzhbQ8CfZx1ogdko6VbGp/fY0oeVU5cW1EuK9g
         2p00pcg4lbNWC0wx0YGi5DB9miNuWIF0udRXE0yDsXTjtss7UOhwa/yn4oVH9FmMx3Oo
         Fnj7SgaKhOB2Az/PSua3JMJnM5XrQmFy9D1HFyhB08uX0ZDGWpaHDljki+2QsMzESASl
         XYdbc9pf8BvdhKYtmWQVJS881Ljj2hVssTIV/YtgepqWD6gim06ZvxZNo+eA0MvUOF9y
         p6aLb2RcEBdB0Z3o3vo/J/VjVWz0mmDg/zX0SkQEyZLixfU58FddG6fBSA13ndQYQzFF
         41ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730495811; x=1731100611;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1H7uxdTQs0chBY951yxomZ1Iay/UJ/Umw2IFMPAb96U=;
        b=YqoEEHC39W1+Z4RhCGDzx0UsuXavmEuid8GzKbt8asMFy4W9j6z/oEi/eqR3y4WKAR
         tyiyhAS8RDtRwvFdkmYcPSGjx8jy9C0ICGqCo21FxgLfXQwoeNWP/1ZsCzSlkmefxVAr
         +QJJr+E+EThIb3rPrhocoQPCX5eYBGld6Vi4/WLQCzhYuQfgHMN5LwFkODe72XG1Xb+k
         KZNYoAB0wEV2NKxttVlG+VV0JRVFdB9ijVaIbd6HHs0/dlorpPYYfbX1DnwqcxUkYF9X
         DOA4WmQs+hCb3qSmHQpAmO/zSU+rWCxXK1WEgR0fQTsTUTDqrOjhRo+OvhHV/rGUwr0e
         1u1g==
X-Forwarded-Encrypted: i=1; AJvYcCUa3bpj9yATGwO+9zCNoaur0OQPHQdhawD85KWdJJoG7MVDmq0EgMc4HMDn7QLOJjjfO8pgU5E=@vger.kernel.org
X-Gm-Message-State: AOJu0YzVaU2OBbIllecQ8zZEdVAXGCaHZ07a7+j0+bD4tqUlFwh91/90
	qNwQK4iJgHQnvj6fzo5g1Ju0qAYN7Iw+ZH8VCR1G9wypA4PYzUAS
X-Google-Smtp-Source: AGHT+IE45Fg2IaFv0E0Tasg4G8KbNNnKCYo5tESLUWMrR/gklV5Og5b2jX0lBMsOj9u9J9lhadJ6mg==
X-Received: by 2002:a5d:64e8:0:b0:37d:321e:ef0c with SMTP id ffacd0b85a97d-381c797507fmr3873433f8f.11.1730495810727;
        Fri, 01 Nov 2024 14:16:50 -0700 (PDT)
Received: from [192.168.42.19] ([85.255.236.151])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-381c118905dsm6169035f8f.114.2024.11.01.14.16.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Nov 2024 14:16:50 -0700 (PDT)
Message-ID: <f675b3ec-d2b3-4031-8c6e-f5e544faedc2@gmail.com>
Date: Fri, 1 Nov 2024 21:17:02 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 12/15] io_uring/zcrx: add io_recvzc request
To: Mina Almasry <almasrymina@google.com>, David Wei <dw@davidwei.uk>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jesper Dangaard Brouer
 <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>,
 Pedro Tammela <pctammela@mojatatu.com>
References: <20241029230521.2385749-1-dw@davidwei.uk>
 <20241029230521.2385749-13-dw@davidwei.uk>
 <CAHS8izP=S8nEk77A+dfBzOyq7ddcGUNYNkVGDhpfJarzdx3vGw@mail.gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CAHS8izP=S8nEk77A+dfBzOyq7ddcGUNYNkVGDhpfJarzdx3vGw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11/1/24 20:11, Mina Almasry wrote:
> On Tue, Oct 29, 2024 at 4:06 PM David Wei <dw@davidwei.uk> wrote:
>>
> ...
>> +static void io_zcrx_get_buf_uref(struct net_iov *niov)
>> +{
>> +       atomic_long_add(IO_ZC_RX_UREF, &niov->pp_ref_count);
>> +}
>> +
> 
> This is not specific to io_rcrx I think. Please rename this and put it
> somewhere generic, like netmem.h.
> 
> Then tcp_recvmsg_dmabuf can use the same helper instead of the very
> ugly call it currently does:
> 
> - atomic_long_inc(&niov->pp_ref_count);
> + net_iov_pp_ref_get(niov, 1);
> 
> Or something.
> 
> In general I think io_uring code can do whatever it wants with the
> io_uring specific bits in net_iov (everything under net_area_owner I
> think), but please lets try to keep any code touching the generic
> net_iov fields (pp_pagic, pp_ref_count, and others) in generic
> helpers.

I'm getting confused, io_uring shouldn't be touching these
fields, but on the other hand should export net/ private
netmem_priv.h and page_pool_priv.h and directly hard code a bunch
of low level setup io_uring that is currently in page_pool.c

-- 
Pavel Begunkov

