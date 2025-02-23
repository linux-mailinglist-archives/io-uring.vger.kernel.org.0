Return-Path: <io-uring+bounces-6648-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 46DFBA41212
	for <lists+io-uring@lfdr.de>; Sun, 23 Feb 2025 23:45:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2222E188C556
	for <lists+io-uring@lfdr.de>; Sun, 23 Feb 2025 22:45:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB2AB203709;
	Sun, 23 Feb 2025 22:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="o+9MQXQs"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 684B01D8E1A
	for <io-uring@vger.kernel.org>; Sun, 23 Feb 2025 22:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740350693; cv=none; b=QZr0nYOI1SesOPD1vXnszgVrMvmgx9YEiDFe80pBL37RLwOuf4nYkbVd21enkaxRXDxH/+jZtxcGy7wjkRjXrNQkdyNdOPFXBS+w4icdRwrhtnsvSikTN2NCbqtAjU6IkwcdqgHpRxh6ok/FjUrAiECMoxn8+mGmvl7VurMuc1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740350693; c=relaxed/simple;
	bh=f6sd9faCJUtRF/qp5cpnd1mtep2DiJGT0/Gx4WolCDw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VUPZiPisUGSf81+VXpnORAopBCNkFmUjM9xxKAgueWnfkFyQAYYkuhulEyDH8OcmUkpFDBlWsIuYm8kbkDnMbPbuVRlH28sEgysPfazuiLsDxLaDvBgU9RhBIdSTKDxoX8pISXulX/HZ0cz2cyD2B08ae/HDrqjVOfw0m7tYb2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=o+9MQXQs; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-220ecbdb4c2so103682585ad.3
        for <io-uring@vger.kernel.org>; Sun, 23 Feb 2025 14:44:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1740350692; x=1740955492; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=A3kxpfRrUGeJsgV6DEhGjnuxoEwDLROtc0xQ9OQsQ0M=;
        b=o+9MQXQs/4N1tLkfNihmltrD8/fW5zdkoDHEP1aJmIn+FBAvPcUsYugBsUEWZuc+nE
         xCW3z06Tw79P0hBcuL4kqvQ850MnlfOCJ0WdXH1fsQ+3NhkXwMa/bXUNg1knxCBIp4Kb
         79tBC/rJ4D+Ruh2tnHK7SlCJtFddDpPa5LL/56uhEsVezBIFXrGQHFU2Sr9ePzC7b6hb
         rW7g6aCXuT8JplXeQCpVYx/PQFpYXC//k2oTRfTpJRyZAsS7o1dsU0VjhO2OjUyCuGvY
         W+gMah0mayN+EKZ3+G3eh4ekviWBZ99Z5S2+7YhOCxG53Nl6/D/16mCvIXm2fo7ULDqg
         y7DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740350692; x=1740955492;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=A3kxpfRrUGeJsgV6DEhGjnuxoEwDLROtc0xQ9OQsQ0M=;
        b=ChnpobFwDAgaKExT8GtjPu0gLDK+GkeUeq8xgkqv5SSzSfegfyx4+2woBlwZF4EOe3
         YsFe8wWZ4qdrsktFB5igwbiIsRXAyFsxcXlBmYqPI28EOYgOOlYlxTrkVjfjLzpeg800
         lukk3WGJ1DtTN+JiPGnjkGEhbGj/YMS9B2hdlF8XWPqIrPPLllr4zO9m/siO1vAdoSHL
         ezgRfzUTPQBPfWi7iK3mXVy7EqipTdbEqfQmK8rFwMIT7tS+R0wzJvy3tshFFdj1Syti
         wCqAVNrZX4Dt9FJRpqlcgq4zaA0Q1lvklyZvnm45sCwdMcWRXQxrmnyY7wPLcbNQ8E++
         ka8g==
X-Forwarded-Encrypted: i=1; AJvYcCX+1YSZERlkVAoR8uUBzkX8S8c+xn+u6EojTFh1YsfEKlV+bfiw1LEO4+ZeLrVIakPdogmI7/Dr0A==@vger.kernel.org
X-Gm-Message-State: AOJu0YyG8psFvJFpU/ij4WEa66SRPI/73KAN34TAlzQr3lJdVX3kzGJJ
	Is+Ky6DbXkxhruAFXAFS4kh+Z1X/uIsOg8QsCgqGNMk2nLoB+/3SYwynU3De0z0kcf7V2TDXQGX
	1
X-Gm-Gg: ASbGncvwcsUMNKHCdzm7v4IYe5XV6ihU5obJ39jUc8vGEvl3HoDnDxk+8sZ1fx7HXWz
	ZMstt0guvQ7xal6rM9+ejjI8gIq6bdctY75tN1yei1TCccRULD5jZcXD4b8e4c1kveQKGsHYNuA
	DqmIW4zjS57UKefejfo5FnYwpnHGi3mI1898PfsznfghEMe3zu6/JQ34rmc/dfVEXNKB2wjGtJR
	jky2gS/I30sOu2ZgUg0ELA5tSneI1IJSYu/vH3OCdGjuxBIeQ+TjD3wJSrzdpOHldvF0L3MXQLC
	Yi4TqH/3zLA/g2QrAdJyY+XC218DBf+a
X-Google-Smtp-Source: AGHT+IGsyp8Io3B6RN881MLVLo2bQSDEeB8pLLWwFZaFq2aAauKnyYQ8AFgfaSllo9eHicSP89KPRQ==
X-Received: by 2002:a17:903:1cc:b0:220:e336:94e with SMTP id d9443c01a7336-221a0ed738emr164312975ad.15.1740350691713;
        Sun, 23 Feb 2025 14:44:51 -0800 (PST)
Received: from [192.168.1.12] ([97.126.136.10])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73261a0c0b8sm15938832b3a.164.2025.02.23.14.44.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 23 Feb 2025 14:44:51 -0800 (PST)
Message-ID: <ae3aa110-f21f-4c1d-9271-bcbd8ea83c08@davidwei.uk>
Date: Sun, 23 Feb 2025 14:44:50 -0800
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] io_uring/zcrx: add single shot recvzc
Content-Language: en-GB
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
References: <20250221205146.1210952-1-dw@davidwei.uk>
 <20250221205146.1210952-2-dw@davidwei.uk>
 <92bc1fca-ea5e-42eb-bdb3-c53854193ce7@gmail.com>
From: David Wei <dw@davidwei.uk>
In-Reply-To: <92bc1fca-ea5e-42eb-bdb3-c53854193ce7@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2025-02-21 16:56, Pavel Begunkov wrote:
> On 2/21/25 20:51, David Wei wrote:
>> diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
>> index f2d326e18e67..74bca4e471bc 100644
>> --- a/io_uring/zcrx.c
>> +++ b/io_uring/zcrx.c
> ...
>>   static int io_zcrx_tcp_recvmsg(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
>>                   struct sock *sk, int flags,
>> -                unsigned issue_flags)
>> +                unsigned issue_flags, unsigned int *outlen)
>>   {
>> +    unsigned int len = *outlen;
>> +    bool limit = len != UINT_MAX;
>>       struct io_zcrx_args args = {
>>           .req = req,
>>           .ifq = ifq,
>>           .sock = sk->sk_socket,
>>       };
>>       read_descriptor_t rd_desc = {
>> -        .count = 1,
>> +        .count = len,
>>           .arg.data = &args,
>>       };
>>       int ret;
>>         lock_sock(sk);
>>       ret = tcp_read_sock(sk, &rd_desc, io_zcrx_recv_skb);
>> +    if (limit && ret)
>> +        *outlen = len - ret;
> 
> ret can be negative, the check will pass and the calculations
> will turn it into something weird.
> 

:facepalm:

ret is an int and if (ret) is any non-zero value... I'll be more
explicit here to say ret > 0

