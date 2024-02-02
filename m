Return-Path: <io-uring+bounces-526-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EBE83847C81
	for <lists+io-uring@lfdr.de>; Fri,  2 Feb 2024 23:46:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 541E0B24E97
	for <lists+io-uring@lfdr.de>; Fri,  2 Feb 2024 22:46:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1805C5FF01;
	Fri,  2 Feb 2024 22:46:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="CqmZ6Sog"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DE7D5B697
	for <io-uring@vger.kernel.org>; Fri,  2 Feb 2024 22:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706913993; cv=none; b=igKiFCAaJVWTW3vLokL8SOd59ljQiwx3dZ9/ikgaRCsCprGOnb85AGjJYy6qPnMrpqKQyg+91XxCRBK1aJhjnruvn1UuNJFh1vJvktx+Fwq76PlPzBZsyU+WzVsKTl81lIkUXYUWJKMwZZD3Y0K68Pr8daTaA+KQOvmkie/qgsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706913993; c=relaxed/simple;
	bh=w3K2hJRJ6oPpOYtaNRuiEGaz5WENnExPNMlskLhvfcQ=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=f8wB39vbc3vSTHHDANd4U7J/XxYn5iR0OnM8VMwBd+H/iNB8TU3qaw384TGujHUgykMoCxn0W/vgpCODYSxJlohA5musb5crqAOCVbfySqtV30DysN42orFhzm1Ui64r2GYRwI3iI/m3EkNucn2V2qR0sHuRgaczq+8k1Hb3YWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=CqmZ6Sog; arc=none smtp.client-ip=209.85.219.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-68155fca099so7669566d6.1
        for <io-uring@vger.kernel.org>; Fri, 02 Feb 2024 14:46:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1706913989; x=1707518789; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DVl1ubv2D5PTzw1f7UgzOOmn9Um95ii2LCIhvTY7FSY=;
        b=CqmZ6Sogyr+bdBhSFFlcqInUFTHEOdn8ELy0giq4l00jbnzwZ8xScd7VkoU4VDqbc7
         7yqllgM8SbKu+nQyWlOBiQKCpcw/LyzADWbaaQZ+g10til0G5hvq3ClSgoeq1RH4kSmh
         /O4m6wYnYESoEHDRJ1m4KesbDERsTJYqrq0BtacQwdMeGU+43xeDo7HtIxB/QxKgepmX
         Ci7glsaFpT73c+seffJM+L9BWevYaFMs3ApRGicb3EQPPYRbGO0/Npt7uiDBTg7EuvbQ
         hldLiLDD443xtPLA6Prfg2i1G/tnjBkcPuVATTjepAuATIx8QQKRLO7scrhP8oswT/Rn
         sHBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706913989; x=1707518789;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DVl1ubv2D5PTzw1f7UgzOOmn9Um95ii2LCIhvTY7FSY=;
        b=o/d5ddZHpTxzpZ36Dz7nUD/7bWGIBfyYzpUMSIaDfZksjpbN0X0GlbemPWdcy12L0v
         a8ewOgI2NXwKG/QztjGEjG/hnMnIRt9ffKDEPdc8sgX3dfm1hGn1XXzLL7C6rSNZqJC7
         /Oi8K0HNcjtkNrN8EkohzYlB2mnPixNSC9/ygs6o6vTTDI4S6aCMBJyOREYy5hUvil00
         CTygmeQHn0EN4pha1mK6v7Ij+f/0PK4GgNe6W1K9fInKgb7zLD1OWY8egN0oWIlBEE1d
         6E8RoNVlN/0cldqc1TXVn719bB/Fj+UQ+ReTzRu062l0SGQLTfUmthLCmPVuh1/SvzYX
         MFRw==
X-Forwarded-Encrypted: i=0; AJvYcCUbYsGXHd1m4o+ym+3enVaCrxSgAGo5ptkrAy+hB4yReSe4lBEvWi/G5jp9TxivsqbrybHXa7xiWwXLiC1/v00yaou8ynnIrh8=
X-Gm-Message-State: AOJu0Yx+otTQx4Qo1CZGhLyEkUWidWkdrOJ6QkDOymYFI3J7eGlg/t6M
	md9Q44DnqXuijfpgVqchos2UU1GcVsQc4e2o7pdXO2AjG17aVVXo9oTrZP1kliY=
X-Google-Smtp-Source: AGHT+IHq5DDn92ZsM5EBGfNfmi07KfGm7V9OwZ5B1D9BCvqtg0tn1aA+ylleRdnGE6Rp7zJTZdM8gg==
X-Received: by 2002:ad4:4108:0:b0:685:3dbd:1752 with SMTP id i8-20020ad44108000000b006853dbd1752mr6942704qvp.6.1706913989101;
        Fri, 02 Feb 2024 14:46:29 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCXlZibNjbf43pzGMvEv5aPxK3Ut0F9G9FE7hIfRD/D5h6AMYAy39bEPK5Ht+13L3kXJuta/Zo8MwQ8ePCVRcGi6waWPdwrOjqLZetJl7uEvs2bXbwK6AYNVDDK0pS5pKrF9u6d9gF+G7f9+4fw6yYdUmmNXxFw=
Received: from [172.19.131.115] ([216.250.210.90])
        by smtp.gmail.com with ESMTPSA id pz10-20020ad4550a000000b0068681793468sm1207596qvb.36.2024.02.02.14.46.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Feb 2024 14:46:28 -0800 (PST)
Message-ID: <4d7b32a2-20e5-4408-a30b-cddb942ade25@kernel.dk>
Date: Fri, 2 Feb 2024 15:46:06 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 1/4] liburing: add api to set napi busy poll settings
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
To: Olivier Langlois <olivier@trillion01.com>
Cc: Stefan Roesch <shr@devkernel.io>, io-uring@vger.kernel.org,
 kernel-team@fb.com, ammarfaizi2@gnuweeb.org
References: <3b32446d8b259219d69bff81a6ef51c1ad0b64e3.camel@trillion01.com>
 <07EEF558-8000-436B-B9BD-0E0BAC40C2C3@kernel.dk>
 <a6bd8fc18d15bf1be4ccf0a8cd4f5445cd849fa2.camel@trillion01.com>
 <948ec12c-9601-4e96-b9b6-d97a6cebbde6@kernel.dk>
In-Reply-To: <948ec12c-9601-4e96-b9b6-d97a6cebbde6@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/2/24 3:20 PM, Jens Axboe wrote:
> On 2/2/24 1:23 PM, Olivier Langlois wrote:
>> On Fri, 2024-02-02 at 13:14 -0700, Jens Axboe wrote:
>>>
>>> Ah gotcha, yeah that?s odd and could not ever have worked. I wonder
>>> how that was tested?
>>>
>>> I?ll setup a liburing branch as well.
>>>
>> It is easy. You omit to check the function return value by telling to
>> yourself that it cannot fail...
>>
>> I caught my mistake on a second pass code review...
> 
> Oh I can see how that can happen, but then there should be no functional
> changes in terms of latency... Which means that it was never tested. The
> test results were from the original postings, so probably just fine.
> It's just that later versions would've failed. Looking at the example
> test case, it doesn't check the return value.

Setup a 'napi' branch with the patches, and some fixes on top. It's a
start... I'll try the example ping test here, just need to get off a
plane and be able to access test boxes.

-- 
Jens Axboe


