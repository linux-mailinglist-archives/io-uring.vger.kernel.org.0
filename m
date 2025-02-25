Return-Path: <io-uring+bounces-6755-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F12E6A446E9
	for <lists+io-uring@lfdr.de>; Tue, 25 Feb 2025 17:52:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 28419866C04
	for <lists+io-uring@lfdr.de>; Tue, 25 Feb 2025 16:44:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C1821A238A;
	Tue, 25 Feb 2025 16:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Uhl5E+0D"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4767F19E833;
	Tue, 25 Feb 2025 16:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740501723; cv=none; b=c0m6McybNAdlWebBeDpab6u9xL1bQ1fVqn4D3XUy2W9gkEpDzwI6bsXfLzBquT12g7x4QBKsNyWW5WZsCIuAZv0A6CJVKqPJo7q3atqokY46+w1hpG/LxmfB/dvjxp+KnmZMkIgvgda9jXhUa/QMMT8VGBjSgacq/VZi2hjpUAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740501723; c=relaxed/simple;
	bh=5wViJJEj6/LQCu+K0zKR02MkuSbh0RR1FMo5caHQGBM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fTQt7y44T0hnar87ylcdQmadAeOmOFMOSS9hlOAJobjQb8Pa759piJzTx8cqxylyE7Wz2UAdOxEQxO/daKzYVTjERX7Cjaoqk5cJjGM35WSYUfbYk4zmLUMh0Pr1sd2dB7n5bBMlnWnWlzt04tDAY9JGJer5IxaavX3uynH9moc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Uhl5E+0D; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-5dedd4782c6so10855183a12.3;
        Tue, 25 Feb 2025 08:42:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740501720; x=1741106520; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YiO5nCJ4pTXrhAnu9JQmLGsbsio1bUQAT86cUyjkyRk=;
        b=Uhl5E+0DZz7OwOjiiNpXxWR4/Ixv/5Pt7H00JS4z1v6qyHmMeQNMcGCjOU3Dji90MS
         8U+9zhYeu0hoKHJ/HUjSgqPgcSJjX3dnwidDfUTbLhQXNX+yURVWUkEs28Nr5P+dBJ8O
         d2biuIr38uD/xHvdWHUYiKz0qnsAVTamF4rZfB+pFcUeRvOW4XQ1mfn66urGkkU/LyUd
         8VnYwtQ3z7JGkMX0LxsC5an2d1BlN0mCimVES2WhcSTO0ApPp+Fgw2jmb7fYMjm0OVMB
         TtfnkhIgJsStdAvSuMaRF0CbeEJVtCSMqJZOvbvRbiGX++xQSIZl/daRf5s9ZkjLCdhM
         nBew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740501720; x=1741106520;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YiO5nCJ4pTXrhAnu9JQmLGsbsio1bUQAT86cUyjkyRk=;
        b=N6oQpDO++Ud/NQ91HRKLfpv+6vpnNzsGk3ydQ0YP3eLfn1M6P2XWR7JR/xuvgq9sb7
         R5aKk0uliGviTCy1jiGSE6NLKi6P2s2x4TIZNZxXAxsWYWHP8twf2wVLCyD/ia6zHkaf
         EgQ1LYKFvB89twUIz2B23nl3+ZqPdoyls+GFK4LrukzDXkaVDi5r2ECML+ku4mY9gt16
         XFZEkEtJ9EdF5lKgS1yu8xd+JyoE0grCQuiPrJBQvn4A+1kQyh7SOszoVzQMoVD4x/3a
         TH4Dg8w/xFqwAiJO+B3TJhBE0BX5sTdS6DkirnZUfVNQ7rO+8HWeRZYXH+4KXO9naNtL
         0Ukw==
X-Forwarded-Encrypted: i=1; AJvYcCUHfTnQeAiri1PoGRtBn6rvxwJxDEblrcROPeX00LVH1OOCfgw6caKmcKXmPXAMWYTrzcqcbUu2mA==@vger.kernel.org, AJvYcCXdX2djRWpNKk2ouCEXBO55qcyo9uvZeCP51C2arPdp6c7sBQAx2n0pJHu59OfhLEKSVPZ2zibWtpr0xxs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzrh7fsBZ5c2YlFSiVdUe8tkiy24QDjgkKFvWCDfNX5g6BPnX40
	Yr9Vyl0D94kliB+39WfGjWN2wDVN8xpHKxFE+I8s3O2dEIX3UI02
X-Gm-Gg: ASbGncv9Y6UU4oBh+2Qu8JOyS99w49FG2UZRvCT7yYbUIoXmL5iapCQCd1EYkzD6Vby
	eXxMmdzAHWewXNbB+urJ1znjaAYAYnjt7yUgc39GpOC34TqcyxM+WW3Z/LqZq80yf71F3w3QyFm
	5l3sxvRivAQPkDvFF+WP5NU/dMR2oObRep1msDlQEdf4wRuQKb7PtatmbCmsOGHG3zzI9jv8H23
	T2MfOiY1Lo/Zdk635GoEPxsGiNhOqWgV2/9A+pRqA7f4M2leK+b9HZ3XTIfqP1bnyYOSmJkNYDB
	yMuHu8VUAiH6FLgYk7cutBzjCQ9G1DNJ2KGPsRebQdoMz2UJYXFgXMgV+D8=
X-Google-Smtp-Source: AGHT+IEcpZ/XeO55JOHBakTYiykv0xTRGYQBELCSzDDzvL4T4jgen0+Sa5FQWNx8N0wSzBdgwrCdZQ==
X-Received: by 2002:a05:6402:4611:b0:5e4:a0c4:e31f with SMTP id 4fb4d7f45d1cf-5e4a0c4e3a9mr218820a12.0.1740501720494;
        Tue, 25 Feb 2025 08:42:00 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:9e08])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5e460ff8694sm1433571a12.50.2025.02.25.08.41.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Feb 2025 08:41:59 -0800 (PST)
Message-ID: <a5ceb705-a561-4f84-a4de-5f2e4b3e2de8@gmail.com>
Date: Tue, 25 Feb 2025 16:42:59 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv5 09/11] ublk: zc register/unregister bvec
To: Keith Busch <kbusch@kernel.org>
Cc: Keith Busch <kbusch@meta.com>, ming.lei@redhat.com, axboe@kernel.dk,
 linux-block@vger.kernel.org, io-uring@vger.kernel.org, bernd@bsbernd.com,
 csander@purestorage.com
References: <20250224213116.3509093-1-kbusch@meta.com>
 <20250224213116.3509093-10-kbusch@meta.com>
 <90747c18-01ae-4995-9505-0bd29b7f17ab@gmail.com>
 <Z73vfy0wlCxwf4hp@kbusch-mbp>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <Z73vfy0wlCxwf4hp@kbusch-mbp>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/25/25 16:27, Keith Busch wrote:
> On Tue, Feb 25, 2025 at 04:19:37PM +0000, Pavel Begunkov wrote:
>> On 2/24/25 21:31, Keith Busch wrote:
>>> From: Keith Busch <kbusch@kernel.org>
>>>
>>> Provide new operations for the user to request mapping an active request
>>> to an io uring instance's buf_table. The user has to provide the index
>>> it wants to install the buffer.
>>
>> Do we ever fail requests here? I don't see any result propagation.
>> E.g. what if the ublk server fail, either being killed or just an
>> io_uring request using the buffer failed? Looking at
>> __ublk_complete_rq(), shouldn't someone set struct ublk_io::res?
> 
> If the ublk server is killed, the ublk driver timeout handler will abort
> all incomplete requests.
> 
> If a backend request using this buffer fails, for example -EFAULT, then
> the ublk server notifies the ublk driver frontend with that status in a
> COMMIT_AND_FETCH command, and the ublk driver completes that frontend
> request with an appropriate error status.

I see. IIUC, the API assumes that in normal circumstances you
first unregister the buffer, and then issue another command like
COMMIT_AND_FETCH to finally complete the ublk request. Is that it?

Regardless

Reviewed-by: Pavel Begunkov <asml.silence@gmail.com> # io_uring

-- 
Pavel Begunkov


