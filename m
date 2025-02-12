Return-Path: <io-uring+bounces-6398-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F324A333AE
	for <lists+io-uring@lfdr.de>; Thu, 13 Feb 2025 00:55:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B78F416685E
	for <lists+io-uring@lfdr.de>; Wed, 12 Feb 2025 23:55:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E76F221129D;
	Wed, 12 Feb 2025 23:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="I9ZE+9o+"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f174.google.com (mail-il1-f174.google.com [209.85.166.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D53CF126C05
	for <io-uring@vger.kernel.org>; Wed, 12 Feb 2025 23:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739404538; cv=none; b=mS0dKuV4MR2PxsHUUkaMFXPEFx5SZx9rTc2wwemLpw2IsUayemv3GSM74dpgUauy0NsMxRME132EOA0aiuKgBE5t2EVIW0uCu9NDZ6Pr9o/Zworkdgx7npGv0fGBnIy4w4H48hOpIlLupezu2aoIyiHTbi43LtCiTp/b21RsmSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739404538; c=relaxed/simple;
	bh=BX2Vnm1dvN+dZi7mnduhrhCzZmg1hL39RaIgC960Fd0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UqTRLjHPJffDgWRVgiZKP4j5lQD7bb3Z3/THSRku9A0riDn3czQ9ZU9T8mD6QYLlSblhNlqmy6+Ys3HEyOp4L0as6rmn5A5WJ3Q70NprokVPbNnXC28l++vZcrQR4PhJdq28MHNF4S1wFaCQsgp8baBl0Eyp8I2Rj6/p7Ff8cQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=I9ZE+9o+; arc=none smtp.client-ip=209.85.166.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f174.google.com with SMTP id e9e14a558f8ab-3d150512bd5so1018315ab.3
        for <io-uring@vger.kernel.org>; Wed, 12 Feb 2025 15:55:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1739404536; x=1740009336; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5T5KWhJatXWshxJvkWL9bXGaHOpBQ3aVQM+8yUJxnE0=;
        b=I9ZE+9o+S3IEVbrhV1IB7OvF3hCXHavOvPZfVTtrzN/0g5jC4FCMLHhgU1pjxrrbLJ
         2QIyOYdsQaFLvSKl3IPWvVYh11xMI7xMtg0Lb75+Qg+PoCIkjN+XzaVqbetSdO1J6nmn
         JBn4KI+sqnBdUiYNn7XvMKsSWjD92nFraaWesaTukva4Lkxxc+25M98rjLHQhlK6yaU8
         /nEJz9oVzur0mki/8h8eEsgsWgdY03eWlpqLOyrX8WJTKn9ikj/wPG6f1mgswMQIJCkv
         PrkZjKSGRBXuTVMGrx2i1QhMjpkGLT62EC1utaYcbLiGu5mwJDdT3uc9mhNEYGfXzwod
         8cbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739404536; x=1740009336;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5T5KWhJatXWshxJvkWL9bXGaHOpBQ3aVQM+8yUJxnE0=;
        b=B/wsQngBjwl9HIrsKxNdf7DCprLUvgAGtI1IgXKk8CO5uxQfioLH0z+7i8WJPj4NvW
         fAVWoXqsGPoEQr395R2WyiSgbzY210rZxiyuqIWNofBgUtdQO3F8dtIAP4/FezxZq51K
         sPFkcKbh0jgfPqGqR1CEUPpCwRbnrfd2rnE3TgGawllIEVJKLmArQwb2wSL6adFEQYsY
         hUyPRNqapS1aTufxIJJ/wBdC6kSvaJSWditBnerS/bDtVL98wKcjwMeu/hqnGRsHV2Be
         BvxkCN0GB2vJtQWYrk3K41h0idpspZKdyMeD8SBlw5ie1/HncrqjsVJ+lA94LE6OaYvC
         c7mQ==
X-Forwarded-Encrypted: i=1; AJvYcCWwSNgQyubl+N1M3fidomapgIaYuqR09b0mcwXViiylG7eByZObR2w2yynbVmTEv/a25KAyQPLH/w==@vger.kernel.org
X-Gm-Message-State: AOJu0YxT8xy2pwDezv/II3XNyz4lQFk5pRAdWSeSYn6hzpfP9WHD1n3y
	jIlfniKywgyup00LsWEb2oqUIKdgzAENm3EKk/ErXeFBcx73nDRLtqJPHWECEJU=
X-Gm-Gg: ASbGncuMiX6Csv0pnOYXTSoS2IDZuxT+gmyPODehpqF8nA2hgndJq25V7lsf83XuBfg
	PI6F77dUZ5+LNpNmdojf1PoBCf0hK6WG/0wrzno+jboZHZG9/AyDLJErDR8R8B0WGFpOyFOvaKm
	Qg9ZAsSM8U1xQwnSqDZArAdrcFJlLYY8qQEYb8L0ov23JEbgljnGlvoI1dQDuPOclM6nv4avePS
	5Z980iZf9mEkkrDo8VwdHLCWiPh4+EpuEaEJWbXWrca0FREk1gmEQ3H99pRuMJrwqGPSpl7ljsu
	XvdOLj5LaFFk
X-Google-Smtp-Source: AGHT+IHYFHt0UZ3Eu9kV2C1JCYy+xM/C/iX1RnaOCm9KoKnIXKw2eDtPqV1Vosoku1pEt3y6yf61rg==
X-Received: by 2002:a05:6e02:1c2c:b0:3d0:4d76:79b8 with SMTP id e9e14a558f8ab-3d18c0abe5dmr9464135ab.0.1739404535904;
        Wed, 12 Feb 2025 15:55:35 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ed2816ee33sm50323173.31.2025.02.12.15.55.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Feb 2025 15:55:35 -0800 (PST)
Message-ID: <49382366-c561-44cb-8acb-7241d0b95dd2@kernel.dk>
Date: Wed, 12 Feb 2025 16:55:34 -0700
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
Cc: Pavel Begunkov <asml.silence@gmail.com>,
 Riley Thomasson <riley@purestorage.com>, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20250212204546.3751645-1-csander@purestorage.com>
 <401f9f7a-b813-43b0-b97f-0165072e2758@kernel.dk>
 <CADUfDZqK9+GLsRSdFVd47eZTsz863B3m16GtHc+Buiqdr7Jttg@mail.gmail.com>
 <999d55a6-b039-4a76-b0f6-3d055e91fd48@kernel.dk>
 <CADUfDZrjDF+xH1F98mMdR6brnPMARZ64yomfTYZ=5NStFM5osQ@mail.gmail.com>
 <Z60s3ryl5UotleV-@kbusch-mbp>
 <CADUfDZqa5v7Rb-EXp-v_iMXAESts8u-DisMtjdBEu2+kK-ykeQ@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CADUfDZqa5v7Rb-EXp-v_iMXAESts8u-DisMtjdBEu2+kK-ykeQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/12/25 4:46 PM, Caleb Sander Mateos wrote:
> On Wed, Feb 12, 2025 at 3:21?PM Keith Busch <kbusch@kernel.org> wrote:
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

Yes it's a good similar example - and I don't think it matters much
how it's used. If you rely on its completion before making progress AND
you set flags like IOSQE_ASYNC or LINK/DRAIN that will make it go async
on purposes, then yes you'd need to similarly link dependents on it. If
you don't set anything that forces it to go async, then it WILL complete
inline - there's nothing in its implementation that would cause it
needing to retry. Any failure would be fatal.

This is very much the same thing with the buf update / insertion, it'll
behave in exactly the same way. You could argue "but you need to handle
failures" and that is true. But if the failure case is that your
consumer of the buffer fails with an import failure, then you can just
as well handle that as you can the request getting failed with
-ECANCELED because your dependent link failed.

-- 
Jens Axboe

