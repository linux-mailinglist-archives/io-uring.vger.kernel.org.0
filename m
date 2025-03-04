Return-Path: <io-uring+bounces-6925-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6FAD7A4DA08
	for <lists+io-uring@lfdr.de>; Tue,  4 Mar 2025 11:20:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E3FA7189A7DD
	for <lists+io-uring@lfdr.de>; Tue,  4 Mar 2025 10:20:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19DD81FDE08;
	Tue,  4 Mar 2025 10:20:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K8h+G+Zv"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5064E1FDA7B
	for <io-uring@vger.kernel.org>; Tue,  4 Mar 2025 10:20:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741083620; cv=none; b=VrQs3XXSyEkXbqAqLoN9xJBq/DBQHbhPg0y/ivqpFnneLsnDu/fa4dDLidE06HBV0Mxd7OtrCJ1T2DVxI8um5aKXtd+xIDY3hVIUVGrWSlqpcN27PZFQG0Ampql1HVlm79F1HTxsubCi0LtujswDJGqTbTnRM/ABbc3Bsou2EU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741083620; c=relaxed/simple;
	bh=OCP+w6I1Vr4Y7l7S2TjnlJxpl6yPX4qRnpfQ0dcCxN8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AjNnONZMUsnJLIraqZyQiwrvzZ6BFtBGiw6rorTzHu7BuxUM6deglmJxr+cR7xWAjyqLCPdGny6jSVefyLVSaVRtfxr5iwur3vJ02sjzUWli9CkS9oQWfQYAu8I/6kuaelAeZhGKXlvG0mPaIZlwOTUKKiNjunuhyivGUFoSaaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=K8h+G+Zv; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-abf48293ad0so524575766b.0
        for <io-uring@vger.kernel.org>; Tue, 04 Mar 2025 02:20:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741083616; x=1741688416; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YLG7Qi4Sf9iQfd4lWfcNiiQSQogMciLmT9ckFsmyAC8=;
        b=K8h+G+ZvixJlQGhPQWbjy5cMsCC0Y0xBSS8oGiNTQC2b2DNRaFUokL6tvEAjd71zbv
         hmyRa8H8FO0XjTKPQh6L20F0HNYeMDmeFfxcndb4lfD/YtjXDINRppyqVWfkE7UZvY5s
         GZnv04DysPbANiaKVTQcJgglL7Xb6vAJ3k8QgXQioNvJGGXB4ZhOUxc/AzpRTPjQAXK8
         q/kb6ih4ZSfrLdlUGbQ3DQh4gb5gK6fQpcvZj0c5wbxxNeO7gqDNktreSQFw5PbXP2dA
         P1EHQ3Ne7a74xqsESBA79Pz1ohlZeXKj6T7J1OeA7h5NBMQgCSyW04dY3eVwQPDuuv1P
         1ErQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741083616; x=1741688416;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YLG7Qi4Sf9iQfd4lWfcNiiQSQogMciLmT9ckFsmyAC8=;
        b=NQ3mma3GJEdtzLp4MNQU4dMRKsMtmcoh5aTOuD9xX8ENXTKJfnV1KPa5rSi2ObnjX4
         yEPhyOxOzm1fJPdU58/h13zhxW4ap95hzcwCWps/KpYYOwmwpt5R7g8eDi3JeU3EuW2V
         7fmGIWDYB4QvKjk3u94uh8bZuczoN8K4YxjwAnYz5zxGIJ5MJU0JNhXzOAtnMN+x5vWG
         flBlyqASi3Ct2BPWU9EyxsoK7Rn8cVT/u1s8U2dkMaFGNGPerSuxDZ9ZvWyHdnjAGnNP
         TXyzvJV4ZIE4LItf8KcFRvj5JxejtPtgk+PmUFYLaIYXFwL3I3eLSDlgqEU591sgj8Hs
         y5Ug==
X-Gm-Message-State: AOJu0Yw60v1xWhBNwGLIUV81TDLquneAVCmvBJ688WjOIt4zS7apqFMX
	5DmOMK7H0vlC3H3tMXXwYyOLJ1dSzf8dIUU6J2mtwVyBdFLihHxG
X-Gm-Gg: ASbGnctJuviYqeD0FV4dCtKNhlIb9WYhuS5LlxidrRhXXh6zGtVj9wqaplBsOJDNTPF
	rJM7h51Kk/3wcLRldBOpgACPiTIgxITcl+0RLgERWuoADqFYYX11kn240kY3IgieyPpdiBDbwMk
	Mh9vj5racBX8WM8bQ7M1lg0Li6HEHeP6fQfN2xlSdHlqD3WLC/PVpARpiSxOiKU0aDNK4QOJzBr
	8WVYKWdEwGm0Yx+95xymQu+l4wk4h+4bdPddtTQmLKIvAs3Qh1/pdOCMiiWBTyeuOOkyoI20wYF
	fiWK2bjmESNFaFE03hL8do8gwicphMo2wBi7Kkbq3kDK2CUaQaSvgqoB/msHhH23BqUVehL0Cu9
	4XQ==
X-Google-Smtp-Source: AGHT+IHfibnzaaQ4d9pTyVplY59aqUsME23Lm3XROGJg8x4rqBmcHLDza1DPuw/za0jjag57sUAnDQ==
X-Received: by 2002:a17:907:1ca1:b0:abf:6744:5e9c with SMTP id a640c23a62f3a-abf674462f0mr1074153066b.5.1741083616232;
        Tue, 04 Mar 2025 02:20:16 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:87eb])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac1e152fdd4sm206797866b.176.2025.03.04.02.20.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Mar 2025 02:20:15 -0800 (PST)
Message-ID: <84f7831c-5ed1-4d6b-87f4-0dd88fe2ed16@gmail.com>
Date: Tue, 4 Mar 2025 10:21:26 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/8] Add support for vectored registered buffers
To: Andres Freund <andres@anarazel.de>
Cc: io-uring@vger.kernel.org
References: <cover.1741014186.git.asml.silence@gmail.com>
 <lscml6pt36b2nebr7mjt5z76mtj2bctr5jxjv7qc2x4cq4ggyv@x35mco47jda6>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <lscml6pt36b2nebr7mjt5z76mtj2bctr5jxjv7qc2x4cq4ggyv@x35mco47jda6>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/3/25 21:03, Andres Freund wrote:
> Hi,
> 
> On 2025-03-03 15:50:55 +0000, Pavel Begunkov wrote:
>> Add registered buffer support for vectored io_uring operations. That
>> allows to pass an iovec, all entries of which must belong to and
>> point into the same registered buffer specified by sqe->buf_index.
> 
> This is very much appreciated!'

Glad to hear. I do remember you mentioning the contention issue
in the list. A bunch of other people who were interested as well.

>> The series covers zerocopy sendmsg and reads / writes. Reads and
>> writes are implemented as new opcodes, while zerocopy sendmsg
>> reuses IORING_RECVSEND_FIXED_BUF for the api.
>>
>> Results are aligned to what one would expect from registered buffers:
>>
>> t/io_uring + nullblk, single segment 16K:
>>    34 -> 46 GiB/s
> 
> FWIW, I'd expect bigger wins with real IO when using 1GB huge pages. I

I didn't even benchmark it meaningfully as we should be able to
extrapolate results from registered buffer test, but I agree, such
contention might make it even more desirable.


> encountered when there were a lot of reads from a large nvme raid into a small
> set of shared huge pages (database buffer pool), by many proceses
> concurrently. The constant pinning/unpinning of the relevant folio caused a
> lot of contention.
> 
> Unfortunately switching to registered buffers would, until now, have required
> using non-vectored IO, which causes significant performance regressions in
> other cases...

-- 
Pavel Begunkov


