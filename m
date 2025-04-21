Return-Path: <io-uring+bounces-7585-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7440AA94A0E
	for <lists+io-uring@lfdr.de>; Mon, 21 Apr 2025 02:28:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 200F07A4246
	for <lists+io-uring@lfdr.de>; Mon, 21 Apr 2025 00:27:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28D11846F;
	Mon, 21 Apr 2025 00:28:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="GmTLMmQq"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADC2D36D
	for <io-uring@vger.kernel.org>; Mon, 21 Apr 2025 00:28:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745195327; cv=none; b=RlHG/8ZDDb1nVQVCC1rS1voS1Nl0DIhnz+Ur2J0/ula/jMtM9k/gpmSqy2CpeNgO5ChdtkvugduwJNCE0lVBZZldrnYQPmjEFiNSB67q7J/C/rZmkX9zXttGc3K8y6cLcQaNruGK48xswrtMLZD8DZ2XeDvSIqabIMzYUPiPYd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745195327; c=relaxed/simple;
	bh=F/4vp0c/lFBEvYbxrQ2MpJeyRxW7caJ9HrSeY07q4gQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=LZa4bR+i5syqSc34+hXgwACzW3255EYgL4s2FkVLWg/d4IiLMz+2kedBcZxZq2wqPlRbSRmH8z7yAmFey3pB/mbXfU7YyMqJotv2YwUsrScn63dsB7f9XvZdtY/UoPQTyPcU9ooFa3uUeuIVLUZLD3McHZVp2m160V/MsgyYjCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=GmTLMmQq; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-af59c920d32so2353282a12.0
        for <io-uring@vger.kernel.org>; Sun, 20 Apr 2025 17:28:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1745195325; x=1745800125; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fkH6tpAaLZsNVZBMlGMw8oLaKnLAc6WfrVFVRcm5ylk=;
        b=GmTLMmQqHCDMM+O2UvY71wnAVDRfzmwYWtUldzZY2ma8DFQo8DzXUumGJq45Hhypxu
         I9Mc3XyYAp0LrIqveeBi5domDEoHsb5N6MWJ2I/NyILDGXQQ+MFBCRAK58cf2oi3ROsu
         g4bNvGDYjmPojxUELwfaSNvqkS7OM8tM3l/rTRsufuOS/5C+62BmXFnsdymzU9Em8aNl
         gX7r/UyesI/qgVhJ0J2Jv8CzThDcDrsChzeajm3tsOp5TdBjKos1AHTb++WlbzdpxtkB
         9ii5eGVi5cBK+FWrQdvYEkbxviZHfMQsAxN30WQKP9nBJ+QYLt6kiQ2oj3caK0bR3o+4
         rUmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745195325; x=1745800125;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fkH6tpAaLZsNVZBMlGMw8oLaKnLAc6WfrVFVRcm5ylk=;
        b=M3JMfvC74GfQjQ6bde2vxaBxcmXa513x8dfEeldAeW5g2tgjkobjcIzId4fmLe8Qw/
         zNFHJqegn7ib4XJr8IoHYMg5BVA2lyCrHEXpJsGZUE5AoXFJvgFlq4ceIIy8fDofY9KP
         PWgkAGwnrc7repexYeeYM5fHiw33D6HhijXxI9AOZMjG0s0NH+1yEQYfCrkFa9uplmeS
         yt3P957OshjxdL4c3CjpbDd47DtHBWbV7gJzaVnytblxDwFGP/IRGTLY5vxA3ExHxolc
         oKqjJkMRSZu4c4mgw1xKkLptKRimZrRd+qxgyWeg33h//r1LK4q4j8TMEZfUCoM6Mlxs
         i+lA==
X-Forwarded-Encrypted: i=1; AJvYcCUhoa9sqHCO4Zg4QJtJATfBXkS5kl/I1ahGu1ezN8f4/EAUCrpx7leiWCdFK9/HgWJIHZ1+fQXWlg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwBMbp4c4YylvOFBgZ7QaGP41FJqW2hfK59wKpa8JmmUiFJE8iC
	DMHBmLJ5/MluZsyrcBQCtTUU8A56Lwfpqdv0ZJ7rxgEZxHkH04E1jfSsCyNmAkk=
X-Gm-Gg: ASbGncsioRaS3YMoDOvJ/qS73K6zHLsg2RrWiedyOFvgjEHyfYhbrhRUm98LuYJ0Lmp
	Xisb5k89f8bEgFyEmaRc2GPp6IzaCc/TIEaMSa2NZ6rgC/tbP+mZrOupnlw8IoPi+x3jnXnhlXD
	7rwgaThIM0XTKebfNh7ytZgKeok2Q1C8vKbGSVhGW7nuQn14AAIwhkMidBWkc6QvRhBa4F1wtkZ
	qfXpS9JAgag2JQ23q2N1vAgaDzn/ThbJWhDNzmTNxp0ZGM3Z0zNMOiU+At1B83RcgKKeVo2P9Tx
	D9eL9ZMk74kl5+gm6fJ9nM0u/fjLk19J13bagcS35KGi3QQ=
X-Google-Smtp-Source: AGHT+IF7DsCE2jYouY3DD0g3XH1m2PfyEY4FRKZ6VWKxoJ4mlC37LVc/cSF+JaVm69Jwe/SiMzVHkw==
X-Received: by 2002:a17:90b:574d:b0:2ee:db8a:2a01 with SMTP id 98e67ed59e1d1-3087bcc2a1emr12771875a91.30.1745195324888;
        Sun, 20 Apr 2025 17:28:44 -0700 (PDT)
Received: from [192.168.1.12] ([97.126.136.10])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22c50eb4930sm53298655ad.139.2025.04.20.17.28.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 20 Apr 2025 17:28:44 -0700 (PDT)
Message-ID: <7a941493-9924-4086-acaa-55cd428d25a2@davidwei.uk>
Date: Sun, 20 Apr 2025 17:28:44 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH liburing 3/3] examples/zcrx: add refill queue allocation
 modes
Content-Language: en-GB
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1745146129.git.asml.silence@gmail.com>
 <6a52feca4f8842c6aa3ad4595c1d1da8150f6fc1.1745146129.git.asml.silence@gmail.com>
From: David Wei <dw@davidwei.uk>
In-Reply-To: <6a52feca4f8842c6aa3ad4595c1d1da8150f6fc1.1745146129.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2025-04-20 04:24, Pavel Begunkov wrote:
> Refill queue creating is backed by the region api, which can either be
> user or kernel allocated. Add an option to switch between the modes.
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  examples/zcrx.c | 46 ++++++++++++++++++++++++++++++++++++----------
>  1 file changed, 36 insertions(+), 10 deletions(-)
> 
> diff --git a/examples/zcrx.c b/examples/zcrx.c
> index 8989c9a4..eafe1969 100644
> --- a/examples/zcrx.c
> +++ b/examples/zcrx.c
> @@ -39,6 +39,13 @@
[...]
> @@ -128,6 +140,15 @@ static void setup_zcrx(struct io_uring *ring)
>  	if (ret)
>  		t_error(1, 0, "io_uring_register_ifq(): %d", ret);
>  
> +	if (cfg_rq_alloc_mode == RQ_ALLOC_USER) {

cfg_rq_alloc_mode == RQ_ALLOC_KERNEL?

> +		ring_ptr = mmap(NULL, ring_size,
> +				PROT_READ | PROT_WRITE,
> +				MAP_SHARED | MAP_POPULATE,
> +				ring->ring_fd, region_reg.mmap_offset);
> +		if (ring_ptr == MAP_FAILED)
> +			t_error(1, 0, "mmap(): refill ring");
> +	}
> +
>  	rq_ring.khead = (unsigned int *)((char *)ring_ptr + reg.offsets.head);
>  	rq_ring.ktail = (unsigned int *)((char *)ring_ptr + reg.offsets.tail);
>  	rq_ring.rqes = (struct io_uring_zcrx_rqe *)((char *)ring_ptr + reg.offsets.rqes);


