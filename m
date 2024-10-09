Return-Path: <io-uring+bounces-3508-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F0B49974D6
	for <lists+io-uring@lfdr.de>; Wed,  9 Oct 2024 20:22:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1AE99B25754
	for <lists+io-uring@lfdr.de>; Wed,  9 Oct 2024 18:22:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8867E1DFDAB;
	Wed,  9 Oct 2024 18:22:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mojatatu-com.20230601.gappssmtp.com header.i=@mojatatu-com.20230601.gappssmtp.com header.b="Ob/NK7wU"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D3A019DF66
	for <io-uring@vger.kernel.org>; Wed,  9 Oct 2024 18:21:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728498121; cv=none; b=Cl++pQOTEBbGZpmNBzXMDRuzvtL0NODdfziUFFIQfcSZZHz0uDC6vRIU9Yg5eOYL8hK9iIcZ3LuKRHZSuonLGcfdCE6fpepW3U1evCRFwDD06ij0yRwoyYIS9Wkct5XXM2tWyhukRDcSD8HKPOUPEq7wy4Dpyuj/UTPzQa7IOV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728498121; c=relaxed/simple;
	bh=9vUqdo/igjOOWhIzRu+RuHFHMt0Ihut8MO7+sJ/ofWY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DDLx3fEiMob3zMAw/WsWLOP4axbuS49d6oaz3V7UVD1vtuMGv+DkBq7uJepvDejmzUp37zF+ekBng+6bmbmsslIrAGlhMkHEw1IlQW5oeeAtV2FOyVe6Pwt+ioJBwuI4DpkG2wXdujyIJtHsyf5Y4dcrD2Lh+nf0892Pp/Wq8d8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mojatatu.com; spf=none smtp.mailfrom=mojatatu.com; dkim=pass (2048-bit key) header.d=mojatatu-com.20230601.gappssmtp.com header.i=@mojatatu-com.20230601.gappssmtp.com header.b=Ob/NK7wU; arc=none smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mojatatu.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=mojatatu.com
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-7ea24595bccso31614a12.2
        for <io-uring@vger.kernel.org>; Wed, 09 Oct 2024 11:21:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20230601.gappssmtp.com; s=20230601; t=1728498119; x=1729102919; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=V3vTDTrile6KBch07lGA099oISlwP9LY4LGSBOhW8NA=;
        b=Ob/NK7wU8RjM7GQpTn1n5DkoS/JRoZ9n/X1MmSLoI78h4wFaIJqRXh25cVHr7UoxPz
         lfiAjqb8/s99BPZCtzWQkIDQXcP1UiDC4JNjcV2Q/1LJoosUWBn/sVxf8i2G2GoOHBzL
         E3UTFEN3E/J30Cp5uyELi9XG7KUWFyaxFE0vaFbPqh8YrxXmFOB8xLJDfpps8mMTjFep
         MzTBbUr6+b2MrpdRZFYt6vHNzLGdqLlcTv4hBZhBvoKqRbv2a0AoJk10HgCHmboa+3RN
         miXeZTWaI4miIBcytrA/CepY8cD/dZXNeO7HKXCgu1Jzm1dA1/3DDm4B91ScK2pJ0laV
         TNPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728498119; x=1729102919;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=V3vTDTrile6KBch07lGA099oISlwP9LY4LGSBOhW8NA=;
        b=bc7FbVdLtuKGUdWAJN7sOipn4qW0EocuSmpKv2ZY4NGVOkdsnBHD63pKPNlINk1Qyy
         kqU/AXd9wgsrsJ50an5k/xEichgy0Conwos+oX5qf9ZSf4oGxDcb386ksOdxmGErXELi
         y8IuXh0AiibuR1WqBPJrtiDIjNeq7CIggolnDnXnpB2kUMM0Z6ecUn/B88SGtjzHl64i
         E2HjOZ+8+wEQhIjPfGrE1YazYJcmNtG623ewH2Z65N3PNT6b1zClGE3uKaSnelthFjp0
         8UFoNHdLlbWS+RxWzbFVVqbr9IfdTKdNShm3K+w3zxTjxl8mBLjA+s9OKaU0gel+L7Q0
         9B0A==
X-Gm-Message-State: AOJu0YwFPDd99zQLJOviQxQt1xB7YgT2VPScXeC9liLtX+5yXqKDGw8S
	8VWpnaxD4nvFE17iasMVuQwjYUgsXX98kkDxjr41rAohGiYXwOaofY2Wy/6eXwYvl/esdIg2ZN3
	11g==
X-Google-Smtp-Source: AGHT+IHy19IxD1JrAX1P/Z0WPsSWC563cGxLzRYuPaIEJcXD6anZgDoB8xw/Hkgptq4KG0CZf3ukvg==
X-Received: by 2002:a05:6a21:3944:b0:1d3:42f3:ff6d with SMTP id adf61e73a8af0-1d8a3c3a455mr4541182637.31.1728498119360;
        Wed, 09 Oct 2024 11:21:59 -0700 (PDT)
Received: from [192.168.50.25] ([179.218.14.134])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71df0cd0b38sm8022236b3a.49.2024.10.09.11.21.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Oct 2024 11:21:59 -0700 (PDT)
Message-ID: <2b23d0ba-493b-48ba-beca-adc1d1e0be61@mojatatu.com>
Date: Wed, 9 Oct 2024 15:21:53 -0300
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 00/15] io_uring zero copy rx
To: Mina Almasry <almasrymina@google.com>, David Wei <dw@davidwei.uk>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>
References: <20241007221603.1703699-1-dw@davidwei.uk>
 <CAHS8izOv9cB60oUbxz_52BMGi7T4_u9rzTOCb23LGvZOX0QXqg@mail.gmail.com>
Content-Language: en-US
From: Pedro Tammela <pctammela@mojatatu.com>
In-Reply-To: <CAHS8izOv9cB60oUbxz_52BMGi7T4_u9rzTOCb23LGvZOX0QXqg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 09/10/2024 13:55, Mina Almasry wrote:
> [...]
> 
> If not, I would like to see a comparison between TCP RX zerocopy and
> this new io-uring zerocopy. For Google for example we use the TCP RX
> zerocopy, I would like to see perf numbers possibly motivating us to
> move to this new thing.
> 
> [1] https://lwn.net/Articles/752046/
> 

Hi!

 From my own testing, the TCP RX Zerocopy is quite heavy on the page 
unmapping side. Since the io_uring implementation is expected to be 
lighter (see patch 11), I would expect a simple comparison to show 
better numbers for io_uring.

To be fair to the existing implementation, it would then be needed to be 
paired with some 'real' computation, but that varies a lot. As we 
presented in netdevconf this year, HW-GRO eventually was the best option 
for us (no app changes, etc...) but still a case by case decision.

