Return-Path: <io-uring+bounces-6933-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EF082A4E37D
	for <lists+io-uring@lfdr.de>; Tue,  4 Mar 2025 16:33:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AAA4217F4E5
	for <lists+io-uring@lfdr.de>; Tue,  4 Mar 2025 15:27:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCDA0291FBD;
	Tue,  4 Mar 2025 15:17:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MXVqitqv"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 235DE28D05D
	for <io-uring@vger.kernel.org>; Tue,  4 Mar 2025 15:17:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741101425; cv=none; b=axRNFEIHrlXhJXC5mFNaOOtdguCvGD/WohsytQqRjMJ5LbK6LDuN1jkxhxoY029w73pOUt0FK5fhgbVn5gHErRxd/4yjQxjE871SfZVtvZM3mA/1Z+JPbXOAUhBqgSqOc2erXvX1M5Y5bv2KDp4H35PEXngL3TQrFuUE5ANnXag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741101425; c=relaxed/simple;
	bh=xjcKEXP5jAfCiSUUz6fjVd8Hsn30AytpNcFfT7b8uIw=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=XtI+akFyu/q38PDBuaQ/9HEWkzjn/z7fva4cD79hcHAUo9OfldJWMAcZPeDhvXA6dz8CHFKcBu4qAiHMikYKwaAcfe4m3Gt743luHl3zZcF9z38eMSBcFg5EoqBx9M3uJx9SrEHI9pfzE8K6v8wt21+7fcjrXcHPcj/tpR2NHzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MXVqitqv; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-5e0373c7f55so8875498a12.0
        for <io-uring@vger.kernel.org>; Tue, 04 Mar 2025 07:17:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741101422; x=1741706222; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=+ALTJqAZUqbI5/3XhYOF3OjwZcPQJTsmPJuGItJiNXw=;
        b=MXVqitqvOacLtnhFCX9cSlU6TFKGgn9dKWC5Fwo4VJHo20cjFR/1PzMbB3Or2pvMuf
         gYjiVpaorXZQ9JMe/om8Ktm1CsbyXsxmZHpRfL/Km0cU4vYSxs24iDsHYSKz5QV2iDm2
         3PFdLB9elD6Apl/vhb5VTBVE2scnFVJc50JmPC9/KuTERK3ScBCadVFz064EyKnMZDb6
         gxOLukyMtOkZRbHp/CZ79326FXVOiJu/aI2dj3yeFFeagJMIxOPRSAf5FNo9oBhX97/t
         LqC5YskykKDJc+GMKJlg88rz5Xtr6wzbyRfFU5pcjzBBAiUU0uEnHNXwNIqKOZ2RQrF8
         dC8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741101422; x=1741706222;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+ALTJqAZUqbI5/3XhYOF3OjwZcPQJTsmPJuGItJiNXw=;
        b=blFECPD4TDiNPLNY24+o9BoADUlC63mcIQUd2W7vDLlEbUdZ37yxJLmkDEMp+TxcLV
         S9bSr9Y1J0ENXg8TR6+gG0O1kdYwC+lRPKCsX7Ak54/1m8s4rFr6MdXushyzmVUgqrKi
         1PZtqg54qopXeMZhSJ9kEE25ZcMMxUnFiyB0CGEvxzH9JAXMFLBZ+V9Q3526gtpNbCr6
         bEzHuyveqhwfDZqlL1w8N7jvhDDOqiWS9vAVVNNHYthilGCGXf62Vw94JUdVu0Y/lYHQ
         r5Y7ReMocU1BKWIqhbwRGqgvl7JE1ImonNoElYYT67A7cPB1J9KVDSfgb+MQvn/7/F8O
         wQ7Q==
X-Gm-Message-State: AOJu0Yy67YWwVgF64snrOAJsY9mvTvQlWnS1AvyLbbXm5VLJ8SOlnI3s
	8jmPr5FyafN0PZXIP0/GoYeRHPntNOpSWjKLiw7Oq9gZp9M8CflRnLkPGg==
X-Gm-Gg: ASbGncvToIlMM+MHrcef8PIAKQB2lqE0pVtN60TjP28z4i7O/lDJhw4/SRGGmSOKa53
	4hS5pAs3V7RQX9Hjx5WCo7twXgGorVssTRBEuXJrZfSaxJRIXkvZQdkjsQLLiPJf+o31x3S105X
	pzi94JP0l9tgS+wkVFgLtGQotf+FNOxgJW88yq1383kq/5IV9AjDMJ0AyoK7sAe6bRAyXIYAQyR
	pbqY4z8B8ASkIlJ8e00+b0tOHoOsqecWOvbj9/sKmqJMv3TAQXoL61iMhTESCwpWChU66yMTnBf
	gdX7w8LBtGDmUbQsB28YHALPq7KDE1jQHwHR37JR+eJilFp68mvf7gKyjo+xuINkUMGv6hsY8yj
	ZdA==
X-Google-Smtp-Source: AGHT+IFB55EU4r74eXyi4FeDQ/EZeYJI0r2S4hTUrTCICWBqc3Dv5rqmMrg7olPKf+OJY8GO8wpTOA==
X-Received: by 2002:a17:907:1ca2:b0:abf:6842:d46 with SMTP id a640c23a62f3a-abf684213e6mr1003486866b.32.1741101422006;
        Tue, 04 Mar 2025 07:17:02 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:3bd7])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac1e5aff06esm218450266b.130.2025.03.04.07.17.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Mar 2025 07:17:01 -0800 (PST)
Message-ID: <8ad09b2e-7bc6-4379-be68-033e9e164ee8@gmail.com>
Date: Tue, 4 Mar 2025 15:18:11 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/8] io_uring: add infra for importing vectored reg
 buffers
From: Pavel Begunkov <asml.silence@gmail.com>
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: io-uring@vger.kernel.org, Andres Freund <andres@anarazel.de>
References: <cover.1741014186.git.asml.silence@gmail.com>
 <841b4d5b039b9db84aa1e1415a6d249ea57646f6.1741014186.git.asml.silence@gmail.com>
 <CADUfDZobvM1V38qSizh=WqAv1o5-pTOSZ+PUDMgEhgY3OVAssg@mail.gmail.com>
 <9a5e3d75-afef-4942-881c-444d35472758@gmail.com>
Content-Language: en-US
In-Reply-To: <9a5e3d75-afef-4942-881c-444d35472758@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 3/4/25 10:05, Pavel Begunkov wrote:
> On 3/3/25 20:49, Caleb Sander Mateos wrote:
>> On Mon, Mar 3, 2025 at 7:51 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
> ...
>>> +       for (i = 0; i < nr_iovs; i++)
>>> +               max_segs += (iov[i].iov_len >> shift) + 2;
>>
>> Sees like this may overestimate a bit. I think something like this
>> would give the exact number of segments for each iovec?
>> (((u64)iov_base & folio_mask) + iov_len + folio_mask) >> folio_shift
> 
> It's overestimated exactly to avoid a beast like this.

And it'd be broken as well for 0 len.

-- 
Pavel Begunkov


