Return-Path: <io-uring+bounces-5298-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B54E09E888E
	for <lists+io-uring@lfdr.de>; Mon,  9 Dec 2024 00:16:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9B2A3163E5D
	for <lists+io-uring@lfdr.de>; Sun,  8 Dec 2024 23:16:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5606189BBF;
	Sun,  8 Dec 2024 23:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BbXhserR"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D275D46B8;
	Sun,  8 Dec 2024 23:16:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733699765; cv=none; b=fX9BWfFTJ3/sVWub7k4/ZOlhRxLIJX/PEtZ8uCpOTmokTqApiAE8uTcxM5ae5N8M0Z/aD0PaNlcrqkC8gEqyINUgFPqYQaDKxtRTa+Zw1CH3QQw0PF04UK0BjEW0MnaChBZ5f3WurMVvUqXCSDfS8AsD2YgjBA/bcizIvwwtn0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733699765; c=relaxed/simple;
	bh=mOp/uxY76yVPNCAKKcZT0B6PY9DV7LzYH+jwdyj7WQ0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LvYImpa9nCfI/qgiyz410/pcOH7Kmb0wFsi9yhkT5RLkhxxKzKjT+U/aHepb//0H+3uaN4ZXfBA5D3EVTe3bPzc0Evh1LSkQGpvGXXwKefcZNRBHlS0rgSVAGoQi+G4dMIZMLe8AnOl0eLQLLdendYfFoTPkQA4fhjmnoQfwxeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BbXhserR; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-434ab938e37so24263085e9.0;
        Sun, 08 Dec 2024 15:16:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733699762; x=1734304562; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3uonts951Zs49qMwZ4dW1yrFDl17vLDA/L+Fp4VPI1I=;
        b=BbXhserR8miD5ynX/NuzjgWcY8Sav7tl26xXKdeamSJF+xvHSTfjB8Lz95vuwnstUR
         sore8fuXor9GXA3dFHlML4RWnpWnd9z/SHpMy0cZD7vYyaBRJ+Nb2GiV9Sx/2c5USLbi
         GISABQTMe921GIUZksVcSLsJRwZNNBCJzhcCDMDx/CL/te1OFpuRiL26E+xSFPGRE94f
         1NSJEbNQGufWaYsg9LFHV9L0nvExkC2Q2PAsNDV6/lstgpv1nEkT+PhtL08hsCZRdLcI
         JHd8VFrqFFkeer29RW+sD4IZxa0IJ3kVE1liZ40c/cavD5K2uqzo/zNAbfcIlbu7TPkt
         /spg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733699762; x=1734304562;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3uonts951Zs49qMwZ4dW1yrFDl17vLDA/L+Fp4VPI1I=;
        b=nnHRsoma/PeX5jPzLgStPd4ll95wZm4cflZezfesIGOPPGFaOd+MUd2SxGCymla4so
         257KjpCzJLoTQ5A2qTfCNIFBFPzCT1HS9HqwKGdM62EiJZOVfvvGt+hyb8lwM5L8isjq
         9hzHYV73ku1M6UmPied34GgHcFWo7pFJn0t9NNSAtzA2YWfZRZnYavj2n9G+tLHBtofC
         AtJi/57i3vI72GdSDw7f7SD7w/Gi/pXvoygh2VF14gqVB0dpzck7fp8DdrhMz6f9QQ0O
         QjKM8KdHQfrExi+Lc9kH33Nxuns/eJmkPm2w+kX6hFF3B94cRoMBi51vdxlslmtrDPtK
         zN/A==
X-Forwarded-Encrypted: i=1; AJvYcCVxFMIs4BAStLR/NDSeZaX5Cj48TaZRmkIHkgAQbbQ40w7Ux+IkwHZw6PZk3EHXT5ZLLvbq0xvN5Q==@vger.kernel.org, AJvYcCWQXoHyHGzqEOeYDYpHx0pLyjSVtRJoRTzJTnqEX/aPUTBVAPpQlwmVrFBAoaAv2LDooz42JadbxYViBYfQ4w==@vger.kernel.org
X-Gm-Message-State: AOJu0YyUiBwdhyoUBDfUFFPt/F/DZ0zMAMGwWmkU6+GS8m2dpOdLdq8w
	ZLS3ttXq4a94V9OQOZ9nU5uzlbq76zv79KdP7WfCFxpA0WyfYkrX
X-Gm-Gg: ASbGnctQRGotqErSHKOuDAsVGBuSczuGUPP4QbtUWKWg4ilRvtMB0++kP76vfxCtKrB
	i9Ef0njWwU7N7e2RXFAAIiBrTpCj1uUifAaOM2FzFCrCw3GGrCJ0XixUCzivJ5cEnWHNVctXM+a
	TYBu9nQdjOnO7REpYV1S5o6dbFzCegKCWhLJ8KJlByg0GWBpqyZWj1yHw6IyLZZElhgZ9oZ4RmW
	EaaWRtSf1KU/T++5iYzA1kK9/FlMRUiVYYH0s8rrIcR84wwCFFGHlGBJbbV
X-Google-Smtp-Source: AGHT+IGc3z4nWBB5yzAi5UXBEI3uoOuD5O6RJAuBPRupcsVsYuNMUTaxAbDh4t1o+kN+KkNDsTB6Tg==
X-Received: by 2002:a05:600c:1e0c:b0:434:f3a1:b214 with SMTP id 5b1f17b1804b1-434f3a1b5b5mr16893375e9.28.1733699761831;
        Sun, 08 Dec 2024 15:16:01 -0800 (PST)
Received: from [192.168.42.233] ([85.255.235.149])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-434f55733d2sm28898095e9.40.2024.12.08.15.16.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 08 Dec 2024 15:16:01 -0800 (PST)
Message-ID: <96af56e8-921d-4d64-8991-9b0e53c782b3@gmail.com>
Date: Sun, 8 Dec 2024 23:16:57 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v7 00/16] fuse: fuse-over-io-uring
To: Bernd Schubert <bernd.schubert@fastmail.fm>,
 Bernd Schubert <bschubert@ddn.com>, Miklos Szeredi <miklos@szeredi.hu>
Cc: Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
 io-uring@vger.kernel.org, Joanne Koong <joannelkoong@gmail.com>,
 Josef Bacik <josef@toxicpanda.com>, Amir Goldstein <amir73il@gmail.com>,
 Ming Lei <tom.leiming@gmail.com>, David Wei <dw@davidwei.uk>,
 bernd@bsbernd.com
References: <20241127-fuse-uring-for-6-10-rfc4-v7-0-934b3a69baca@ddn.com>
 <57546d3d-1f62-4776-ba0c-f6a8271ee612@gmail.com>
 <a7b291db-90eb-4b16-a1a4-3bf31d251174@fastmail.fm>
 <eadccc5d-79f8-4c26-a60c-2b5bf9061734@fastmail.fm>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <eadccc5d-79f8-4c26-a60c-2b5bf9061734@fastmail.fm>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/6/24 11:36, Bernd Schubert wrote:
> On 12/3/24 15:32, Bernd Schubert wrote:
>> On 12/3/24 15:24, Pavel Begunkov wrote:
>>> On 11/27/24 13:40, Bernd Schubert wrote:
>>>> [I removed RFC status as the design should be in place now
>>>> and as xfstests pass. I still reviewing patches myself, though
>>>> and also repeatings tests with different queue sizes.]
>>>
>>> I left a few comments, but it looks sane. At least on the io_uring
>>> side nothing weird caught my eye. Cancellations might be a bit
>>> worrisome as usual, so would be nice to give it a good run with
>>> sanitizers.
>>
>> Thanks a lot for your reviews, new series is in preparation, will
>> send it out tomorrow to give a test run over night. I'm
>> running xfstests on a kernel that has lockdep and ASAN enabled, which
>> is why it takes around 15 hours (with/without FOPEN_DIRECT_IO).
> 
> I found a few issues myself and somehow xfstests take more
> than twice as long right with 6.13 *and a slightly different kernel
> config. Still waiting for test completion.
> 
> 
> I have a question actually regarding patch 15 that handles
> IO_URING_F_CANCEL. I think there there is a race in v7 and before,
> as the fuse entry state FRRS_WAIT might not have been reached _yet_
> and then io_uring_cmd_done() would not be called.
> Can I do it like this in fuse_uring_cancel()

A IO_URING_F_CANCEL doesn't cancel a request nor removes it
from io_uring's cancellation list, io_uring_cmd_done() does.
You might also be getting multiple IO_URING_F_CANCEL calls for
a request until the request is released.


> if (need_cmd_done) {
> 	io_uring_cmd_done(cmd, -ENOTCONN, 0, issue_flags);
> } else {
> 	/*
> 	 * We don't check for the actual state, but let io-uring
> 	 * layer handle if re-sending the IO_URING_F_CANCEL SQE is still
> 	 * needed.
> 	 */
> 	ret = -EAGAIN;
> }
> 
> I.e. lets assume umount races with IO_URING_F_CANCEL (for example umount
> triggers a daemon crash). The umount process/task could now already do
> or start to do io_uring_cmd_done and just around the same time and
> IO_URING_F_CANCEL comes in.
> My question is if io-uring knows that re-sending the
> IO_URING_F_CANCEL is still needed or will it avoid re-sending if
> io_uring_cmd_done() was already done?
> I could also add state checking in the fuse_uring_cancel function.
-- 
Pavel Begunkov


