Return-Path: <io-uring+bounces-5973-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E681A14EEF
	for <lists+io-uring@lfdr.de>; Fri, 17 Jan 2025 13:00:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6BA21164A07
	for <lists+io-uring@lfdr.de>; Fri, 17 Jan 2025 12:00:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40A501F790F;
	Fri, 17 Jan 2025 12:00:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mjEf+Vcx"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 900C0197A92;
	Fri, 17 Jan 2025 12:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737115242; cv=none; b=I+ohrv/KGgp4qDJg+2MV47aq8Pm+AgIiGugKl26kIsdbJGTeXQ4DfKU8HKFbiS9qd1yv+JiB6BeYkzUgo2/wxQVrG5JnT7BxW0wc1lXnCwJ9JCJoiXPAs5vyWVaod9FIrwUMUoYgN3cMO7A4oT9XNwVAmbsrQG1JhwpAXyhQQ6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737115242; c=relaxed/simple;
	bh=sLc0NnNScDF/UzXd4n5fYH9FJ+ryoVqX+KAE60eTNf4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OOfnTCBNOIpxFBApbnS1gHlUpoSbgjfkB6ybKHvYUIHUsPJdfvJ1TdJ7TCMH30ErfF+Xw8uPzN4g+MxgfXK2eMdQsfeDfWI7UldWTjPzXm1T1JkHQg1S+uUJKElGheiBk0McyzdZO5EICBX5DxSHZiLkBHJOnDmpISA7jCGqT1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mjEf+Vcx; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-5d414b8af7bso3768238a12.0;
        Fri, 17 Jan 2025 04:00:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737115239; x=1737720039; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=r71kH8voduAZ6erQ+OihOobxrBDi3PuPucngrLa88AE=;
        b=mjEf+VcxkpgzVghMKCIycqPoPW93qHodeR3eW8/kMuiwVtAaUdXsiuabbtXp8lE1ej
         Q4AewhI9QybKRHgX/Z7c+Q8TyY/g8eY3/r7pcssJcT5WA2BoLyTj/mk7giQ3bCY7EzMi
         VVsw1FCORCGwkvzsyOj+NJoIbDDURBVpNzM0w4wbjA1Vhc8+Aczglm8XmK1d+oYtuF37
         f7+pnjUNOAlOGrDItRSM1D9aF5JS06Egfb8e+RUiAEnfxVtd5c7cFnLk5X/31xfaMKBj
         V1S+dyPjxO2fJg3QBKd9td+D0ZbsITyCbPX7SiqQk4mzw3Ok8ydM+vBXtCljWGykVe3A
         DRyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737115239; x=1737720039;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=r71kH8voduAZ6erQ+OihOobxrBDi3PuPucngrLa88AE=;
        b=JYva99jpxAEQjUEoDn8ayTMvtfKOwe/M2Emci6mYyDYfwHi51Y/qck2mCY9P3/DoV+
         wO5Zg2oKYn+N1K94W0mngYHVc8IjeTP592W2kqUt4wfSaS+LLAymXVz6kUY+Gjbfl4a5
         NaIQzOyoauft7lQlSnj9Zb95tK4erxkw0/SDEUOKRAFP1GfCFzlP/5joCZ8o4nyPRrNx
         ecyTWcjPaQ/gZ9jn7PKrp1EdstnVcVpvArJUjj+LivKrhLRHbZT4EO2Kbdi5e7rz1KRS
         tBVxy+4pouTnucXG0Dc9zo9hL1hPvFGSi3LOc1R0XioldRaOGIAAJo3DzANqtPvdnDh3
         q5fw==
X-Forwarded-Encrypted: i=1; AJvYcCU+TfRoR7kYoTn/aWCSQsrl77X3MujVsQ64LfNHhqo7HuZkijBrvA0yP0aLKptrtJkBjpeFsw59vguz7WukiA==@vger.kernel.org, AJvYcCXynM+J+PjP0y1qB98ejN4tA8HfUHoyVcCsExDgNdUno/QYV9kGSgvCZU01s2mJHbr/RYyVG4JjuA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxe/LDntWEW2WdOJ4viMOPSfkDZ+/G2NT9+IBRh5K7FWngpJNM/
	CsIZBr08d6kCcRDh4/GSe7IHdDALgWJ4HU3pAP1K9R+QB+G4DNwp
X-Gm-Gg: ASbGncvAuos1hcn9LhwGow5mPDtl1ciezK+R/zyFtFjdxlLlbYBaLag7PJI1GoWpsiJ
	p2kbGdF5VfipgmOtyQhlW73EVTZYbKKRBb5jdp1hDjIl3lKEpVTvRtZMu3PpGZvBtNISd+Lnmm9
	N/3qkRl3eID+rPOxxr6vAE5P9HJVG6C5MJT7JnpQqzFU44y8q1JsvDHCxIShdZVOcAqy4T3hwN4
	Ck0n6hnyz5Mlew7JSFN17m7CShIv6hhRQxgacGWaC7AHO5aDni9oAhCnTnejdggGHnseiBXf8FR
	uIkEd8YtDOe20Q==
X-Google-Smtp-Source: AGHT+IGFuQEpyk/8l4lmLmqs2XyjMHcktD9E1IHBLJbswlQHIDAxTeOGdsWcAMkAv237IL9eqmp07g==
X-Received: by 2002:a17:907:7faa:b0:ab3:30c5:f6d3 with SMTP id a640c23a62f3a-ab38b0b7f5amr217112266b.9.1737115238658;
        Fri, 17 Jan 2025 04:00:38 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:56de])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab384fce017sm156801466b.182.2025.01.17.04.00.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Jan 2025 04:00:38 -0800 (PST)
Message-ID: <16d59c17-1634-4b65-bddd-a24bc5ba2646@gmail.com>
Date: Fri, 17 Jan 2025 12:01:23 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 00/17] fuse: fuse-over-io-uring
To: Bernd Schubert <bernd@bsbernd.com>, Miklos Szeredi <miklos@szeredi.hu>,
 Bernd Schubert <bschubert@ddn.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
 io-uring@vger.kernel.org, Joanne Koong <joannelkoong@gmail.com>,
 Josef Bacik <josef@toxicpanda.com>, Amir Goldstein <amir73il@gmail.com>,
 Ming Lei <tom.leiming@gmail.com>, David Wei <dw@davidwei.uk>
References: <20250107-fuse-uring-for-6-10-rfc4-v9-0-9c786f9a7a9d@ddn.com>
 <CAJfpegvUamsi+UzQJm-iUUuHZFRBxDZpR0fiBGuv9QEkkFEnYQ@mail.gmail.com>
 <3135725b-fe31-42bd-bb9b-d554ebb41494@bsbernd.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <3135725b-fe31-42bd-bb9b-d554ebb41494@bsbernd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/17/25 09:12, Bernd Schubert wrote:
> On 1/17/25 10:07, Miklos Szeredi wrote:
>> On Tue, 7 Jan 2025 at 01:25, Bernd Schubert <bschubert@ddn.com> wrote:
>>>
>>> This adds support for io-uring communication between kernel and
>>> userspace daemon using opcode the IORING_OP_URING_CMD. The basic
>>> approach was taken from ublk.
>>
>> I think this is in a good shape.   Let's pull v10 into
>> fuse.git#for-next and maybe we can have go at v6.14.
>>
>> Any objections?

Sounds right, io_uring adjacent bits look good. Bernd, feel free
to stick to the series in general:

Reviewed-by: Pavel Begunkov <asml.silence@gmail.com> # io_uring


> Sounds great, I will have v10 in the next hours (got distracted all
> week), there is a start up race fix I found in our branch with page
> pinning (which slows down start up).

-- 
Pavel Begunkov


