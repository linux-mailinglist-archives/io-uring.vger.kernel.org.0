Return-Path: <io-uring+bounces-3642-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C5DDF99BC97
	for <lists+io-uring@lfdr.de>; Mon, 14 Oct 2024 00:37:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 715861F21333
	for <lists+io-uring@lfdr.de>; Sun, 13 Oct 2024 22:37:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B863913B287;
	Sun, 13 Oct 2024 22:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="asiSnKns"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 158DD13211F;
	Sun, 13 Oct 2024 22:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728859062; cv=none; b=Hk7tZJPvRKcWmwl0QYSqkKyGHvfzhMLEVusOEyVC4sFFjcpjsd+xvB2oKwoHdlR2Idxv0/SlgiRevRAFWuQGnm2ZQW5Iv+ahRFioF7a12Q24D05T7W+lrWQOG1aovMRYg9KKZ26C35Wa+Csfa/D7LHsQT3lMdcuax8VXZyA6r9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728859062; c=relaxed/simple;
	bh=lW5AlYjLHLn/ac6xvGbGyvSB0tEwv/4baFMyn6PdfJ4=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=rlNd5cxQ2XTPWdlTDN6F4NjdHevWY5U0FPl5D3EqNeMfBZZOobmJTBjQCmDI0/5xlgfhpacnJHax55UiIEllu7NnJbehlZFYXIim3rkcixM6CiLoQNIGS9f3DrskiyFPcXF3IRoDkrKGiG0kRznjJyjyOx/okLaSFTWYjyYPFAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=asiSnKns; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-a9a0ec0a94fso53247766b.1;
        Sun, 13 Oct 2024 15:37:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728859059; x=1729463859; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=y3VqFVF7Epsn5YtefffhxosYYm3sZIPBatq/mV/mo1c=;
        b=asiSnKns3VeHBy/8JQivBnP+pYl+zTtIx9odkDRouIDyc18ZNuQOvqmuXpd+KBCrTB
         KVQBWhnui98Gp14DrWFuyvuB0ghMp0M3n9sAPn4Jv8vPI/76JK8ZOen5hU8OgQfWytgW
         evtxD7YCMh/C/uJiJMV91Ve/PC0UCuNYBjhVSSjimfW/kkjprYbC8k06GuqSyKtGD00H
         2omMdtbnq1AFh8dgGbEbfFRWuiktcw8FilT0kf48rrmqXQu8MhfoVDx7kjAckiEnueyi
         oU8GwH9y5wrRn+8Vz1LxEhdGRtNBUoDsvJAUj4QgJMTcJ7iD55TC8dw2QY4SnAgnvoHP
         yOdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728859059; x=1729463859;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=y3VqFVF7Epsn5YtefffhxosYYm3sZIPBatq/mV/mo1c=;
        b=V44sPw0499mjAnS4KgF3vM+S5prZ9S59u04xD04l13Hg7Tp+Mlyoepea23i8VeQGBa
         uwDQTqbbUfnuELE12oOrwApbtXKIsQzeoathLqBLLsAcdUgMYFhXrLVznGbvzz0WJjaS
         bmBYHsBZ3y2eLVwsgdEmdHnLMAXmJj5hdyxn/IoRKaIeVr/kCI9fqxxEGdouUdC95Y2O
         ryqPF8JQ9YqwtfO1nU1jiXgHHONkn0uee9D7dhw62H8Nax0DH5AjrXFmT1wPrEmm8YB7
         3qFmaKPeNXw9kanHIA1CH4XyozIRxoMmlcXXqcZc15FIhaM4V8nDAz6M/3yiXsgMZMcK
         GfTw==
X-Forwarded-Encrypted: i=1; AJvYcCVC43jx+FIYKxWyU6+wZA93h8KkXCwmaGtxWy4GiHE9Pfg0/RoZxbC//2KNY8TOY6MxEDZu/mop@vger.kernel.org, AJvYcCWGQGHoR/ZAGXz4JTT/la3Ws8HsB8QTiU3ZE7Bj8HMjK4UcCczyj2Lhd2mi5zYJr2GywnrpDlcZ/A==@vger.kernel.org
X-Gm-Message-State: AOJu0YyIj0mcl71QCU7upki1KqExWdu+1VNdPtJJBVkx6Sx+1fVtmifG
	x0V/F/A4VSNr30rMhYxwEuzV8u9XeABRISCc5EyCvCiULKe3YCdW
X-Google-Smtp-Source: AGHT+IERAZxXWzDHJMEIrsoLP0P8X036eAOnnA0D4tp7D4pBmd9tecOQn3qpUaYWVf/oUU5c161BVA==
X-Received: by 2002:a17:907:7ea1:b0:a8d:2faf:d33d with SMTP id a640c23a62f3a-a99b9314adcmr798192166b.9.1728859059148;
        Sun, 13 Oct 2024 15:37:39 -0700 (PDT)
Received: from [192.168.42.245] ([85.255.233.136])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9a13f42e8bsm20226166b.58.2024.10.13.15.37.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 13 Oct 2024 15:37:38 -0700 (PDT)
Message-ID: <c32d011e-f9be-4e37-b765-266057812ee0@gmail.com>
Date: Sun, 13 Oct 2024 23:38:08 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 01/15] net: devmem: pull struct definitions out of
 ifdef
From: Pavel Begunkov <asml.silence@gmail.com>
To: Mina Almasry <almasrymina@google.com>
Cc: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org,
 netdev@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>
References: <20241007221603.1703699-1-dw@davidwei.uk>
 <20241007221603.1703699-2-dw@davidwei.uk>
 <CAHS8izMHmG8-Go6k63UaCtwvEcp=D73Ja0XfrTjNp_b5TUmUFA@mail.gmail.com>
 <ed21bca5-5087-4eff-814c-39180078a700@gmail.com>
 <CAHS8izNGdFTr789fFhV_NvYK0ORKPwn_KHu0CeaZp_xhg9PgCA@mail.gmail.com>
 <d7915d17-9ee2-4486-8d39-f9ccaa53fc13@gmail.com>
Content-Language: en-US
In-Reply-To: <d7915d17-9ee2-4486-8d39-f9ccaa53fc13@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/10/24 19:57, Pavel Begunkov wrote:
> On 10/10/24 19:01, Mina Almasry wrote:
...
>>
>> To be honest the tradeoff wins in the other direction for me. The
>> extra boiler plate is not that bad, and we can be sure that any code
> 
> We can count how often people break builds because a change
> was compiled just with one configuration in mind. Unfortunately,
> I did it myself a fair share of times, and there is enough of
> build robot reports like that. It's not just about boiler plate
> but rather overall maintainability.
> 
>> that touches net_devmem_dmabuf_binding will get a valid internals
>> since it won't compile if the feature is disabled. This could be
>> critical and could be preventing bugs.
> 
> I don't see the concern, if devmem is compiled out there wouldn't
> be a devmem provider to even create it, and you don't need to
> worry. If you think someone would create a binding without a devmem,
> then I don't believe it'd be enough to hide a struct definition
> to prevent that in the first place.
> 
> I think the maintainers can tell whichever way they think is
> better, I can drop the patch, even though I think it's much
> better with it.
Having a second thought, I'll drop the patch as asked. The
change is not essential to the series, I shouldn't care about
devmem here.

-- 
Pavel Begunkov

