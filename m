Return-Path: <io-uring+bounces-2893-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B31995B51A
	for <lists+io-uring@lfdr.de>; Thu, 22 Aug 2024 14:36:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 784521C215DF
	for <lists+io-uring@lfdr.de>; Thu, 22 Aug 2024 12:36:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF8C9149E14;
	Thu, 22 Aug 2024 12:36:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dx9PQ4IT"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18EEC1E4B0;
	Thu, 22 Aug 2024 12:36:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724330163; cv=none; b=M0UFpodBSACmjOKhDpZJbAbrtEQPXDfbE1twjuZF/WjjALrbpX0x7OGg9GZrXtFZ2CracthbVmhUgP43QphL9bi6J5ZWNDUtFpUVpQ339bpaiZNbfXyb5PznWm9Me8RRUwdNvk2A1nF2vF6kEI5A3O9dfOs/+XE2LWpgdtnXRZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724330163; c=relaxed/simple;
	bh=S70DdA1dESaqKRLnP0p46775oOyfgns/QuJT22Izx7o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HOWXZUUAaue5hjNkO0r0fevtc05MPbhh9ZA643FT2Y79FtgDAbcy7qjUO5x57v53wzrEAPSC5KoH7gvlwgAyjG4eGaoMtwffR0v5rYzyNYRICSVhWcA7iaARbcMvwgLbiw/8aqoMjuN3NyCjS48rw82U2g3D3U3p1BniRFZZWhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dx9PQ4IT; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-5a10835487fso1320540a12.1;
        Thu, 22 Aug 2024 05:36:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724330160; x=1724934960; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Y0pMPsBjfu3dCB3+6WO3b2ZXmLp2DSYl2Qd4E0/Rydo=;
        b=dx9PQ4ITHpWIP43NORaLMCFRyzn928a7Rucak37nrKDUTmG4kpZZPvfiaVrenBMcNw
         /YrYW+SHXmnyFSfWRKMLv8B9eSUSZTMTHhkdoySNW92AQCL3KKQdMDVsYLxnhu5FKp5O
         fS+hLatifvZuKBIQkLe8YgTpN9LYso4lULCiQ48DOD9PxsBNeBSxvLrj5YodunXeO89E
         mBYZv6tnlbQ1S6cKbJ4QqWKmQxakXgHjDb70oMaF6Ny2DI/L0q//A+7IOOHOyz/wDNYq
         h2R+iElACFTLps7TqewK1tXnzN1TPqA1smyLfG8jWFBOq0e+eyiyvlnOZMDJ+7xOoraM
         WYmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724330160; x=1724934960;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Y0pMPsBjfu3dCB3+6WO3b2ZXmLp2DSYl2Qd4E0/Rydo=;
        b=SCqFNUjHJCZisa4mkxJMW+gxH82Sk0CXm6offnaoOWdnYU/NHhuVTeOH5mzCvUH/Z9
         kZsZBztxgKVsVTYGLWiwHlsB2bwDcEbESDu4Ttie7YJV8LxRQ9FzmHPB5cV3f2KvS2kd
         s5OZL+aEmO617g08eWcNUuopVjlzyuepbxSQLKpekxnIXTKAUX9WIVNDjKWEBF6IJ00b
         25saGG6IkLr7X3UR3Ux8aSEOmbO0L2vNY1l8u7RKtMgl75sCkX+0qxvGC2BynECvgSpp
         yightc5/a1K6YvC06WdqDon9kFcgmIcHVuuNyLtBMV0yawjRn4iNm5IXrUImwoyyEf7n
         bWVw==
X-Forwarded-Encrypted: i=1; AJvYcCVNXiK/7/SOW9PHIGZngTfYsoL6FiFsFtsR962A4kj8l0zDQVzKwK874bwErF5S8w1sQtPFdUUbzFVicA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyFSXt0B7QapVdxNfaHorURmBlJF5nnNsBKfS2PqXlgxB+FF2U3
	nzmTnUg4i/QupEsh14MUNBPnClw3+fbN+jI0V17pKgyCV+xMCJzd
X-Google-Smtp-Source: AGHT+IGKNaV7MLhLQaURhHOFGPu6Kqf5Qp99mLeFBENxbzRW3NVESyNh9p4Lt3JNZQQSiaQRVAnJTA==
X-Received: by 2002:a05:6402:34d5:b0:5be:fbce:939e with SMTP id 4fb4d7f45d1cf-5bf1efb58c0mr4431296a12.0.1724330159914;
        Thu, 22 Aug 2024 05:35:59 -0700 (PDT)
Received: from [192.168.42.32] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5c04a3ead28sm881866a12.56.2024.08.22.05.35.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Aug 2024 05:35:59 -0700 (PDT)
Message-ID: <a8a281c1-802c-4eac-974a-12aaaf13ac4c@gmail.com>
Date: Thu, 22 Aug 2024 13:36:25 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 7/7] block: implement async secure erase
To: Christoph Hellwig <hch@infradead.org>
Cc: io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
 Conrad Meyer <conradmeyer@meta.com>, linux-block@vger.kernel.org,
 linux-mm@kvack.org
References: <cover.1724297388.git.asml.silence@gmail.com>
 <5ee52b6cc60fb3d4ecc3d689a3b30eabf4359dba.1724297388.git.asml.silence@gmail.com>
 <ZsbcYakQS-UQIL5W@infradead.org>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <ZsbcYakQS-UQIL5W@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/22/24 07:36, Christoph Hellwig wrote:
> On Thu, Aug 22, 2024 at 04:35:57AM +0100, Pavel Begunkov wrote:
>> Add yet another io_uring cmd implementing async secure erases.
>> It has same page cache races as async discards and write zeroes and
>> reuses the common paths in general.
> 
> How did you test this?  Asking because my interruption fix for secure

In short I didn't, exactly because it's a challenge finding
anything that supports it. At least the change here is minimal,
but ...

> discard is still pending because I could not find a test environment
> for it.  And also because for a "secure" [1] erase proper invalidation
> of the page cache actually matters, as otherwise you can still leak
> data to the device.
> 
> [2] LBA based "secure" erase can't actually be secure on any storage
> device that can write out of place.  Which is all of flash, but also
> modern HDDs when encountering error.  It's a really bad interface
> we should never have have started to support.

... I should just drop it, not like async support makes much
sense.

-- 
Pavel Begunkov

