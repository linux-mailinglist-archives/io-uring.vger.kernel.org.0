Return-Path: <io-uring+bounces-6411-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6CE3DA3493F
	for <lists+io-uring@lfdr.de>; Thu, 13 Feb 2025 17:12:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2C6CA18919B3
	for <lists+io-uring@lfdr.de>; Thu, 13 Feb 2025 16:10:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B187119AD93;
	Thu, 13 Feb 2025 16:10:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Sg631rK5"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E187C1FF7AD;
	Thu, 13 Feb 2025 16:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739463013; cv=none; b=DxO9wE3eU6c5HtEUxPWzdtzCpGF5eQK4rc8OopfB3hgsyRBcBB9fCmZJ7kh7eOrYXWRI0jN+BLS9fC12ESHezK666UvlIHw4sRnSSmaukxerRXNBXpezp40zo9z5HXdS6iiEvzAfJIKxCBtmGcF4AptThJpFOO4zf+cbBDmO+lo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739463013; c=relaxed/simple;
	bh=POTqR1VX2kzjYfEvTFA26l8160v8n9AbEOUXWdKYD90=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aTijN77az5e+UCMODT/z30ipWNFTGsLMGJm+vZQzTbh726rQU6cWkCRqB2a5G//3oZSiYh7dGJrmNijkVRVL4VDdanHFyYj+QFv7Vjdrf1Js3FCxhfQZDTtPBYo1BUPhCxelniMy1mXHDkXQi9ZAJpCnsnwHdj0hNdvaSSMr0l8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Sg631rK5; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-aaeec07b705so173625466b.2;
        Thu, 13 Feb 2025 08:10:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739463010; x=1740067810; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=V0RSOTS6ZSx+7JkkuLcQ7G9Qngd1d3DUrkPX9jU/Jl8=;
        b=Sg631rK5IXFJjkcC/aD9d5Xc0ZLROTj59icMkWD/dKbkGgmL/QnbHoATUbKpW+Xo+M
         Wc2WpG+H6+MWwVdCVI06uP09VfzZyVrEgyHu2eeEuc1vEuQ1YTljqscDn2lsa2AFjTN4
         7BKBjfeRu5/EqbRitkJ6qhzPH+GHzCLylYQQGFH7+x//DYl7dfQCqa47Peh5K7/XiL5M
         f5jyKJiIwUFAx8hNgYOVegb9iYPXAjYLqhdNUl1igUxILhLUoGOIpWhfAOectnLyQ61f
         zy1mFeqjKUH4GB8B7HoVSsyIelWyRWuQoRQXf1PEe+Nwjv0d+7z1+g4MXCXqgMrcqXH8
         3xQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739463010; x=1740067810;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=V0RSOTS6ZSx+7JkkuLcQ7G9Qngd1d3DUrkPX9jU/Jl8=;
        b=le0bmBxfwGjllkdbjQKVaWGwjBJOJalFwffa1Zs54CBsFOCc+/mako/a2b9mPXQtEU
         3Qt1h6r/yGOpi1uDc8m4jtcfsFxQhqXAW5eUg15ZntDF2cQEFEmJPNZnjIDtg1LM5yOk
         GvWWqT51u66OKzt8QSBwdVzvN2FtcFR/MzcFO1+t5/lm7TWf+hehG9qnaa+OG7j4gf2y
         wVCezfVpDlxn4MSyPIS+C/n/uz2fs1gLzwXKrOyBfJ27zedkr+wvH5cyUOQak06eqgnX
         37jkH7f7hPYYZo5PJYOauyDpGemGpsw/haySxibF7Fx0ne3TVLDoTAkDkpXSBFfUnn87
         smpg==
X-Forwarded-Encrypted: i=1; AJvYcCVYXx9v+LVDDyb/bLoRY/KDTVSgSuS8lQFUuP1yjEwedM7PkQqPpgR/c12fQilrPNndmq552iDixQ==@vger.kernel.org, AJvYcCX3ONmZT5eaZDRTNUREWuIMf7lUQGhkc/caVMHEWVIR0yXddvrrplw8ErCFrfg6gzuDtIND+XrW5aqtuM1O@vger.kernel.org
X-Gm-Message-State: AOJu0Yy8LtaMiuetScO7YdXGmiPWyDNikxAaPhG4T9iPEF9iWbhqXcxg
	iYDzuMT11XvHcx0PKypQXFlslmlmOkGamlzoZuX2ww2V5+DPjjKMl8jl0g==
X-Gm-Gg: ASbGncuUZxDuXc7L6cNdR6rs1Oqgl0IjQiyXxRRb+UgIo/o1Hh2GAIMJ3LofEMMBmHQ
	T3Fm11EFBXgblbY3orFOUTcan8QzXBnzCf/6uzAAlHuZ01DXrzuzt9uVacVXdh/XZumwvLf/4Uz
	iHtZ/E0X5bGXP7c2rTBoeM20gwZKMiU88eqB1pdvBFg56pqSHinLP83GhFV7JdF55yWbFmukpEr
	iFkyOy54FFC6A0ZvSjWX9QxSizJ1QDaWgrtb8ptr8EsHV3xsUOyTlSA0UEM7U6hLET1Ky6XSPVQ
	hfDxpMJAadTcHMpLX0Ce0R75lC0Exi6Mwy/hu6LPBsAlJDyE
X-Google-Smtp-Source: AGHT+IEPoar4Py0W2CI3KG0085jOkCPO1nsqdfRM3qpd6t++4MrTabzKUKLmtbPLsuiG4mbg6sFSnw==
X-Received: by 2002:a17:907:1909:b0:ab3:84ac:4dbc with SMTP id a640c23a62f3a-ab7f31a3665mr873085466b.0.1739463009583;
        Thu, 13 Feb 2025 08:10:09 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:1cb7])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aba53281cfcsm156447866b.79.2025.02.13.08.10.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Feb 2025 08:10:08 -0800 (PST)
Message-ID: <d7496fbf-ccec-4b38-81da-8b5674993b15@gmail.com>
Date: Thu, 13 Feb 2025 16:11:08 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] uring_cmd SQE corruptions
To: Caleb Sander Mateos <csander@purestorage.com>,
 Keith Busch <kbusch@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Riley Thomasson <riley@purestorage.com>,
 io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250212204546.3751645-1-csander@purestorage.com>
 <401f9f7a-b813-43b0-b97f-0165072e2758@kernel.dk>
 <CADUfDZqK9+GLsRSdFVd47eZTsz863B3m16GtHc+Buiqdr7Jttg@mail.gmail.com>
 <999d55a6-b039-4a76-b0f6-3d055e91fd48@kernel.dk>
 <CADUfDZrjDF+xH1F98mMdR6brnPMARZ64yomfTYZ=5NStFM5osQ@mail.gmail.com>
 <Z60s3ryl5UotleV-@kbusch-mbp>
 <CADUfDZqa5v7Rb-EXp-v_iMXAESts8u-DisMtjdBEu2+kK-ykeQ@mail.gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CADUfDZqa5v7Rb-EXp-v_iMXAESts8u-DisMtjdBEu2+kK-ykeQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2/12/25 23:46, Caleb Sander Mateos wrote:
> On Wed, Feb 12, 2025 at 3:21 PM Keith Busch <kbusch@kernel.org> wrote:
>>
>> On Wed, Feb 12, 2025 at 03:07:30PM -0800, Caleb Sander Mateos wrote:
>>>
>>> Yes, we completely agree. We are working on incorporating Keith's
>>> patchset now. It looks like there is still an open question about
>>> whether userspace will need to enforce ordering between the requests
>>> (either using linked operations or waiting for completions before
>>> submitting the subsequent operations).
>>
>> In its current form, my series depends on you *not* using linked
>> requests. I didn't think it would be a problem as it follows an existing
>> pattern from the IORING_OP_FILES_UPDATE operation. That has to complete
>> in its entirety before prepping any subsequent commands that reference
>> the index, and using links would get the wrong results.
> 
> As implementers of a ublk server, we would also prefer the current
> interface in your patch series! Having to explicitly order the
> requests would definitely make the interface more cumbersome and
> probably less performant. I was just saying that Ming and Pavel had
> raised some concerns about guaranteeing the order in which io_uring
> issues SQEs. IORING_OP_FILES_UPDATE is a good analogy. Do we have any
> examples of how applications use it? Are they waiting for a
> completion, linking it, or relying on io_uring to issue it
> synchronously?

With files you either handle it in user space by waiting for
completion or link them. The difference with buffers is that
linking wouldn't currently work for buffers, but we can change
that.

-- 
Pavel Begunkov


