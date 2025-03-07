Return-Path: <io-uring+bounces-6979-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 92FE6A56A14
	for <lists+io-uring@lfdr.de>; Fri,  7 Mar 2025 15:13:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 02C9B1893EE4
	for <lists+io-uring@lfdr.de>; Fri,  7 Mar 2025 14:13:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5EC8C21ADBC;
	Fri,  7 Mar 2025 14:13:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bRnnkelO"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8859513A86C
	for <io-uring@vger.kernel.org>; Fri,  7 Mar 2025 14:13:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741356793; cv=none; b=K3ez0edIJMZVBH87JeXRt4BGs9zJVJYrD3JI2fAi2oUIWaWxnS9Dd1zPAFpRCzqJH8qcSqZ0mj+pmu811gdfc+gdnHwyUPn/iukic+GZPWCp/zjOlMDjGETFSPrULzvEvt+a7F+DDvbt9JCYVvtFjJVQ4zOGZColFITmwGTSs9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741356793; c=relaxed/simple;
	bh=kX0Y72K2Hum6vVdfWTEOlJWYqG63G8S6lbNZw9Kmcys=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GURibbrlmOf3Uy38vZrez4i6gi7uh4XTQla0SUsLJDcReI0zDhKaOV/qoCz9yOrzcQ/aDE93nsUE5HgK5/JRHrlWKtjwbZO6e0Jyt4ZP6v9U+xjT4T6RLG8qYDztGCb9xwOFABTjxAJFqbNRkvW/UsG8gP5RCjTNvNd+vXSwpVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bRnnkelO; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-abf42913e95so282630666b.2
        for <io-uring@vger.kernel.org>; Fri, 07 Mar 2025 06:13:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741356790; x=1741961590; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BcC1/7jTqZGLZxZnKWYbex1ZtyOUHDZOjQbOaFIQwsE=;
        b=bRnnkelOGVpTMrbul6rkm3RnfL73hIMPRwMrBeNPjEx+TCSFK9zBz+UJXzkXPOxmPo
         RP2U0d46SaMIF/rd0zqMURR9MAExgXZBy3WX3Xso5RqPxZU0EnY/XBDrZ1GHffj+sNAS
         PDc4ldXpA1Tr5z3kjbgIfM+0A/iiNJiylrxs+G+3byaV9+6AZjhkQtZ/xY+UrlWH5U5I
         u7Yg/8cAednsAFwS38H+O9zI7ocjEZ356jmFnIJWUAo89Wh8MH3RWDPYMLb7QAS/5Iko
         k9Qr/Yl4RLDkpjim01cedS283GfJGpEnmhTY9wuBymy+PXsJ9PaCnCty31De2T/ehEmu
         oDBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741356790; x=1741961590;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BcC1/7jTqZGLZxZnKWYbex1ZtyOUHDZOjQbOaFIQwsE=;
        b=r/F6k9iGuNndmfxEiWOLS0HOawgBX/vXu/loQRa9xR/JbersPbHfEMoNhPwwmILklf
         GwvMe9Z9Fv6lQNijDw5BNavfePpp1+WdO8xt9rgRqcQxeQXnWTXufK9ycmPdOK17aeT2
         FzklSvBl69EHCJikgOoHC6mg7qNrLW3bQ5gYBf5bOhsgQpyjuglBnbEXLUlzxdAShefr
         +fFbZBSSHMTvs/Y1E4/B8+ogFIL7EKMdLa6HafNC+HWkZ9c9CZNt7Q7fDgB8ibRaE5CE
         6KcAV0kUaIc9C3CaIHqP43xhIbKW8PLPxaj6NDSMLfh1UYnrrvqSFEkxPSfwowo2SZn1
         9tOA==
X-Forwarded-Encrypted: i=1; AJvYcCWTU0/8nZECXxu5X9b55zKoyFy1sLliNlm74QnferjcSe8fzWQtCJQ9ac9nVxCB/Jh85g+TaplNIA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyfVrBLq0OgxfQmwac5WBpwTNN3/Vll6au5tzA0HD86utSEwOmQ
	M6ynN28x36DhIieSVYbOgDULFv58Vq+0PRcYWGFLPhtBXkl7UwzandUFTQ==
X-Gm-Gg: ASbGncuh/G4Xvfjc7G+UxQqyHx4VykcKrMBIAPsOOTkauP1UZT7k4K4rEm+pfRbPASs
	FOXko/nXQ8VMzD9xSJlRM9NBV6lKBbrY7e8wgxJ5A385mEH1WNV113aVA0YKckFv8iUdgs6Z6av
	wQIYYwZh9BcFtafT7GvX0OE9/p88gbVWUAJbCk2Gm9tdIDlUMR5PrDBU0hr3epC6XRBWIid88wg
	CnCzeFmxowgGetsPjsPGexC+VIKPj53kQf7K2DENsI4aUqM27JMx48UB8ZiDIPx7FXci9LxNQ6q
	TYPWd8l8B2juaKS5Pqik+pklR1yqdq3/hvtp4TavZcfvpfSWEEulPR0Shl04rdPf3Zu8Pw2La/+
	X1Q==
X-Google-Smtp-Source: AGHT+IEHP5bE1PM/gjPL0VBD8Onl9Y3O/wT2qoXryOCBRyDu+tUmsmDPPNLMinpNHWDeeTwkRDvxRg==
X-Received: by 2002:a17:907:3608:b0:abf:6bf6:a397 with SMTP id a640c23a62f3a-ac252a9e1afmr390385166b.15.1741356789358;
        Fri, 07 Mar 2025 06:13:09 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:1422])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac23973a0aasm279599966b.89.2025.03.07.06.13.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Mar 2025 06:13:08 -0800 (PST)
Message-ID: <41f97663-c507-46a0-8097-75f699450045@gmail.com>
Date: Fri, 7 Mar 2025 14:14:15 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/9] Add support for vectored registered buffers
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc: Andres Freund <andres@anarazel.de>
References: <cover.1741102644.git.asml.silence@gmail.com>
 <174126247411.11491.2089976822738509043.b4-ty@kernel.dk>
 <32fb7fd4-3e70-45d6-afd2-fae07ed66b1f@kernel.dk>
 <2bf0657e-aa48-449c-b78b-df209839a28a@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <2bf0657e-aa48-449c-b78b-df209839a28a@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/6/25 22:59, Jens Axboe wrote:
> On 3/6/25 5:10 AM, Jens Axboe wrote:
>> On 3/6/25 5:01 AM, Jens Axboe wrote:
>>>
>>> On Tue, 04 Mar 2025 15:40:21 +0000, Pavel Begunkov wrote:
>>>> Add registered buffer support for vectored io_uring operations. That
>>>> allows to pass an iovec, all entries of which must belong to and
>>>> point into the same registered buffer specified by sqe->buf_index.
>>>>
>>>> The series covers zerocopy sendmsg and reads / writes. Reads and
>>>> writes are implemented as new opcodes, while zerocopy sendmsg
>>>> reuses IORING_RECVSEND_FIXED_BUF for the api.
>>>>
>>>> [...]
>>>
>>> Applied, thanks!
>>>
>>> [1/9] io_uring: introduce struct iou_vec
>>>        commit: 32fd3277b4ae0f5e6f3a306b464f9b031e2408a8
>>> [2/9] io_uring: add infra for importing vectored reg buffers
>>>        commit: 1a3339cbca2225dbcdc1f4da2b25ab83da818f1d
>>> [3/9] io_uring/rw: implement vectored registered rw
>>>        commit: 7965e1cd6199cf9c87fa02e904cbc50c45c7310f
>>> [4/9] io_uring/rw: defer reg buf vec import
>>>        commit: 5f0a1f815dad9490db822013a2f1feba3371f4d1
>>> [5/9] io_uring/net: combine msghdr copy
>>>        commit: bc007e0aea60926b75b6a459ad8cf7ac357fb290
>>> [6/9] io_uring/net: pull vec alloc out of msghdr import
>>>        commit: 8ff671f394f97e31bc6c1acec9ebbdb108177df9
>>> [7/9] io_uring/net: convert to struct iou_vec
>>>        commit: 57b309177530bf99e59da21d1b1888ac4024072a
>>> [8/9] io_uring/net: implement vectored reg bufs for zctx
>>>        commit: 6836bdad87cb83e96df0702d02d264224b0ffd2d
>>> [9/9] io_uring: cap cached iovec/bvec size
>>>        commit: 0be2ba0a44e3670ac3f9eecd674341d77767288d
>>
>> Note: the vectored fixed read/write opcodes got renumbered, as they
>> didn't sit on top of the epoll wait patches. Just a heads up, in terms
>> of the liburing side.
>>
>> I'll get the basic epoll wait bits pushed up to liburing as well.
> 
> And one more note: this breaks 32-bit compiles due to a bad assumption
> on iovec vs bio_vec sizing, so I've dropped it for now. Hopefully we can
> get a v3 into the 6.15 branch.

I saw that, at least the build check did the job. I'm inclined
to the option in my reply to 2/9. It's generic in a sense that
it can be unconditional, might be a good idea to kill the
if and have extra memory consumption for now until improved.

-- 
Pavel Begunkov


