Return-Path: <io-uring+bounces-9314-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 084C7B38A68
	for <lists+io-uring@lfdr.de>; Wed, 27 Aug 2025 21:44:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C979C7A24E2
	for <lists+io-uring@lfdr.de>; Wed, 27 Aug 2025 19:43:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B60A61C84A6;
	Wed, 27 Aug 2025 19:44:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="F2kCDRZk"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF973F4F1
	for <io-uring@vger.kernel.org>; Wed, 27 Aug 2025 19:44:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756323881; cv=none; b=RIqT2kzyQsbxWrTdoZXog2rvQGQI071Xseqqlz3elbO17rwTQ9B1Xy73f8S9okJ5zoyfFGGr9lYsrHAuJdSf2z0wAhK/cM+k1CHgSDAEDEvT5CJoJedXt9QWUaU9NjIYPlcXLiVs32wH5ar09V+EIpOvnY2s7mRpu7x4f0wx0DM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756323881; c=relaxed/simple;
	bh=dZ/ooAeBg4368q5V9LDm/TkmMF2K+gVUaObDptXGi2E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=e2X+f6w63oNn0j5UzWTivgZY3Edw+I1EZ00DizyIwCTaxJB9gdDGpCfBNiQOip877LFR55ikNKgpSi1cCN8HJfrIxlvcz9uB7fH02h8UQnxXz0efUJp9FkRwGKQeYlZCuQhy5JZBfqt1LFH6J1eCyuZii26xd4h+VfQLx80epr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=F2kCDRZk; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-afcb7a7bad8so22219766b.3
        for <io-uring@vger.kernel.org>; Wed, 27 Aug 2025 12:44:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756323878; x=1756928678; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=X3K0SNltlAolTA2974QXNsNLCacycVtsGF/A3nwOgNw=;
        b=F2kCDRZkSi75akSfwRDImT6SCBBstuYVtbdISBkOEcog5fHQaw+5iyGK/eMmxSlf9X
         MR1Qrut2KMQR+T6HYRH4HcvxXZ2bBEZNm0vujdVzvfcNfiAFu76/mhe2ykiOCcuAgnen
         mkvjBgjbq+TyjWZ44X5Z+6g9EjSPUHQgqNDPw12CeWogG/g5lOk0EsoMQX4SkZBUnubO
         1T+jDZTRmhRkcd0xBmiYTDTC37Gqug9E413ZCmk6nby66JoG6ScVdVsP9BWoPdBRscpu
         mDrCDwPCzrEIPQS65sineSc1+84cyvFBV/X0jtEmyNP+y+IqnskkBtkPuGw0ET1aOY53
         X6pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756323878; x=1756928678;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=X3K0SNltlAolTA2974QXNsNLCacycVtsGF/A3nwOgNw=;
        b=b3x1pl8NVFn7pTkqDWiIrf2fZvai4fUcywNoxqZejRN1E3bHGcQGbusIC8GNwTRZGe
         i51aJFS7sWO39stlp1Y51quCCT1MGGmXjqBFafOQui/TTyJnyvFbqKrPW1QUXCcLkZzl
         rFksQ5wR3nQnnr2XjMV1GMVY0jOjAHof2nJBvUm0kH+oFmFBzS/brSX8iiNWbtuXxGF0
         BV5QtsW0m8cdyuP0U1+05nIbTffBwyK2sQ4nEYKCloVmizE4U0YStjc7mXTCIvtdCvmI
         Z132HllGDGNmMDIYUX6HomrnTKuK8ZjDtINvB+SXaz9/0WhYSw6q7L2MuViUVTmjljnf
         YUJg==
X-Gm-Message-State: AOJu0YyoSyYKu4UtL79fvMR7UjIe+jxkiTQ5BRusoNGNILS9ozq1fUHn
	cPOuqR8qTKzfDEjMdHmRa1aHZtFKLZc5DdSFdcsP6G0O8eCXbWCQsqKqk5AW3A==
X-Gm-Gg: ASbGncuOl0FdN51t+TUl1PMtSSWcJ1oZsgloIzE9B30VXXhZ8aJh/AC050cgWPbfg97
	SltD7MflRadw0SyAzaZRNXJSTtItkenMFcOPUb5levIOTkPb5MhgLxuQKPgqklEQgiOkIcf3fSA
	gDEMzGmgoElwBzLEvZ3xW5xeIIDxQhM8/Nj0rvhVpd7uYh9xBjg0ljhNbQ8SVozYxe1TU2D9K5H
	TO/m+qLvP3F8KIYKo4v5uhaCZtj4lEpbbLP+dGc+ILKYrbLVwvME9/h7iycg/ztF5Iu+Wg2Xkh/
	E8IIZdIT+YC5OgUSQgDn+R0BwRPMZNOVyexUsYwD3IX1oe6jnWjN/BzAgliPdq1pJqheQL/LS6R
	QN9n9Pwd0xgD/wJVVjKqnSI9BSw8iugZzb/IYHx/tID7iKA7C/USi
X-Google-Smtp-Source: AGHT+IGczvfbAwwsD62pJxBDhKgXjC1OcDhuFbX0ZXuPbr5wnxF9zmPaw/lGLmGi+Pz1br+vfBR4og==
X-Received: by 2002:a17:906:d118:b0:afe:92ad:a014 with SMTP id a640c23a62f3a-afe92ada87dmr753203466b.48.1756323878045;
        Wed, 27 Aug 2025 12:44:38 -0700 (PDT)
Received: from [192.168.8.100] ([148.252.140.97])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-afe78918178sm776367766b.103.2025.08.27.12.44.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Aug 2025 12:44:37 -0700 (PDT)
Message-ID: <1a94d436-aa3d-4f15-8b98-6addee8d8595@gmail.com>
Date: Wed, 27 Aug 2025 20:45:59 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC v1 3/3] io_uring: introduce io_uring querying
To: Gabriel Krisman Bertazi <krisman@suse.de>
Cc: io-uring@vger.kernel.org
References: <cover.1756300192.git.asml.silence@gmail.com>
 <6adf4bd06950d999f127595fe4d24d048ce03f5f.1756300192.git.asml.silence@gmail.com>
 <87sehc1w0i.fsf@mailhost.krisman.be>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <87sehc1w0i.fsf@mailhost.krisman.be>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/27/25 19:04, Gabriel Krisman Bertazi wrote:
> Pavel Begunkov <asml.silence@gmail.com> writes:
> 
>> There are many characteristics of a ring or the io_uring subsystem the
>> user wants to query. Sometimes it's needed to be done before there is a
>> created ring, and sometimes it's needed at runtime in a slow path.
>> Introduce a querying interface to achieve that.
>>
>> It was written with several requirements in mind:
>> - Can be used with or without an io_uring instance.
>> - Can query multiple attributes in one syscall.
>> - Backward and forward compatible.
>> - Should be reasobably easy to use.
>> - Reduce the kernel code size for introducing new query types.
> 
> Hello, Pavel.
> 
> Correct me if I'm wrong, or if I completely missed the point, but this
> is mostly about returning static information about what the kernel

It's primarily about configuring rings from within the application
at different steps, and it's always a huge mess when that requires
reading and parsing a text file. It's not all static either, my
main agenda here (not included) involves calculations.

> supports, which can all be calculated at compile-time.
I assume you mean kernel compilation, I can't rely on app
recompilation every time kernel changes.

> It seems it should be laid out as a procfs/sysfs /sys/kernel/io_uring
> subtree instead, making it quickly parseable with the usual coreutils
> command line tools, and then abstracted by some liburing APIs.  I don't
> see the advantage of creating a custom way for fetching kernel features
> information that only works for io_uring.
> 
> Sure, parsing sysfs is slow, but it doesn't need to be fast.  It is
> annoying, but it can be abstracted in userspace by liburing.  It is more

FWIW, I see usefulness in it not being painstakingly slow as it
might easily become with files. E.g. it can be reused to return
stats the app needs at runtime.

Funnily, it'd would create a dependency where you can't create
a ring without having another downgraded ring or using read/write
etc. syscall.

And that also won't work with fd-less ring, aka
IORING_SETUP_REGISTERED_FD_ONLY. Not sure why those are a thing,
but it wouldn't hurt to support it.

> consistent with the rest of the kernel and, for me, when tracking
> customer issues, I can trust the newly introduce files will show up in
> their supportconfig/sosreport without any extra change to these
> applications.
> 
> Then there is the part about probing a specific ring for something, and
> we have fdinfo. What information do we want to probe of a
> particular ring that is missing?  Perhaps this feature should be split from the
> general "is this feature supported" part.

The existing io_uring fdinfo is a huge mess. The format is not
great and it prints too much garbage, parsing it will be a misery.
It's not better implementation wise either, evident by the amount
of bugs it had and reversed lock nesting with trylocks.

And some queries are going to be parameterised, and there is no
good way to pass that to a file read.

-- 
Pavel Begunkov


