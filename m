Return-Path: <io-uring+bounces-5567-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EB4509F6A32
	for <lists+io-uring@lfdr.de>; Wed, 18 Dec 2024 16:38:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2650118818F3
	for <lists+io-uring@lfdr.de>; Wed, 18 Dec 2024 15:38:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA9435FEE6;
	Wed, 18 Dec 2024 15:37:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="jWdjYzsZ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77E2219B5B1
	for <io-uring@vger.kernel.org>; Wed, 18 Dec 2024 15:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734536248; cv=none; b=aimIuAp1EpFMydhp4sf5F0FIYXG5T5wsGpYifhNdc8SFNazYX3Zbg7mWCoxf0P4PGTLGpoHA1VbOhFyIdkwkmwohqeg8CUfcyRUUDKXLKb0MJ45xkN9ia1uL2h1CIc01qPBdXzDA2rG4Tcs0UM/WGDH4h3grW/UdmMyF5fJ8f3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734536248; c=relaxed/simple;
	bh=gao6czzibJqEZRptMiYwty7cBsv1vb3L39/TgD+7qqA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tEL1rRIkkHYokZbSocsSRhwASN2Ghrsp5MFCpAYgYU8URwYg6xVaCZqzFmElWy8UCQ1HjBvDp8rRCgKusINBoGwqMVa5vdms2hMNo+uCB6wT2uIH7nJJXzdm7v+eRZq1aT51o0BWFEXzWb38NNxffkxWU0RUDnbQP63k12nm73w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=jWdjYzsZ; arc=none smtp.client-ip=209.85.166.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f53.google.com with SMTP id ca18e2360f4ac-8442ec2adc7so219584439f.2
        for <io-uring@vger.kernel.org>; Wed, 18 Dec 2024 07:37:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1734536244; x=1735141044; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xCWIedeOIDLA9KEmQ7svIjXgkIvqgZiu/wSdQj94Dyk=;
        b=jWdjYzsZvRN690Q4P1/PHi2Km1vCGSUaHXQTwSOj36PTLKL+KEBMZYiVaiTI8/fYd/
         QVAsVClrW4VjZpnXWrcBzo4oY8y7lgq5GWnvvLj2/z1UcOonmRCtzDnf2aupkYYRWRR2
         uvUA3P8Guf/VarbxmKGDbIfTlIlZo5zHpC98DyXOTK7c3n4+t6Wm4MhY9XpBlqpXlNL2
         qgmXjA4sgeE3lHE9jWegdu5ByQLrX6SMZ/odEZuHJOlsDWEV/dhaKfNNn+13pIxdnUGi
         9JroKvUVX+0k/+wH1GsFmS6nMr6jhEiUAywpc0I4HIG5IX0Zufq2a94jDtDMqZXZNkV5
         NNEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734536244; x=1735141044;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xCWIedeOIDLA9KEmQ7svIjXgkIvqgZiu/wSdQj94Dyk=;
        b=ObsLFUY/ufKe2XGVzJkK9YJarM+XIEM/r8B9pmuob+C4RVBJcjWAX7qcRYiNonHzua
         F5m6m/gspb+DkUqtJGks2O+NmaA/AdWBKMpLBLYzdBgz9/GFY00SbAmjPtpcbUb0mLhz
         vSXuOgO9+YpHJnECd4yGulCGj+2PXEfhunKnl2a0KrSkPPY2Uw9H7EukD29xkeZNuCE2
         URTTdoHBY5VcLeGL0qmFok85GSHIRKHKWASWoLwkD8CrcWfsJ8W+leSoCTxV5G2qMV1g
         xIi6UZRdA9kGKv+qKbYPgJrBdnjiFfQuJpegAFvqDmZLc/rVSD9Kgy4jPC7F9i2ZNTQv
         4foQ==
X-Gm-Message-State: AOJu0Yy56q5bHWUQT1J1jKhZMS1aoYhFnup2JEp+poapDFJvEtgUsO5V
	8ubV0wiLbSSJ9LLFnqp7cvnmk9yLcYK8o0a3lz9FPU7mQQJj0RPXdDyhQXfJ1aA=
X-Gm-Gg: ASbGncsve6rnxEUrHvwZZ+QgxD1KKynOpkQF65e67Vq4Xve03SScpJA3rkcysvLADcg
	jd8HJXKSWWjWZejiSz1rHSHE+du00SKEeWEjUHyo0DIDRRfidmdH7gvwTNNf0vEb9s5AuaAy3Ey
	BU7WtMGSHER8AqSxspbKLI6tHyMqDZJiP9DtuEMEmYuMXyH3lljFTnCcvs58CmpW080FZR+eLCh
	ay/OwyhV1XUO4VvLJm+tXfDALEBYKU8xsidghzP4QCmURqhJwBD
X-Google-Smtp-Source: AGHT+IHRcSJhBTORIGgf/3AJbHmBICHKAwGzgUM1VeaVIokxlw4dsWY6fIGzXOT9+jsrIkvpphwMtg==
X-Received: by 2002:a05:6602:1482:b0:834:d7b6:4fea with SMTP id ca18e2360f4ac-8475854350amr358317039f.6.1734536244482;
        Wed, 18 Dec 2024 07:37:24 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-844f62929c9sm237246539f.26.2024.12.18.07.37.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Dec 2024 07:37:23 -0800 (PST)
Message-ID: <c749b8b2-2697-4130-8d1a-022c4beb2acc@kernel.dk>
Date: Wed, 18 Dec 2024 08:37:22 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/rw: don't mask in f_iocb_flags
To: Anuj gupta <anuj1072538@gmail.com>
Cc: io-uring <io-uring@vger.kernel.org>, Kanchan Joshi <joshi.k@samsung.com>,
 Anuj Gupta <anuj20.g@samsung.com>
References: <1c89cb7e-ddd0-4e22-a04a-4579855b52f2@kernel.dk>
 <CACzX3As-h6+=KXm3mfJ6+9ScB4EJKad+4phEjiTPY-e0t3ndGA@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CACzX3As-h6+=KXm3mfJ6+9ScB4EJKad+4phEjiTPY-e0t3ndGA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/18/24 8:08 AM, Anuj gupta wrote:
>> The identitied commit breaks test cases which end up reporting -EAGAIN
>> rather than just blocking/retrying. I have not tested this with the
>> metadata path, so please do that...
> 
> Tested the metadata path, works fine.
> Feel free to add:
> Reviewed-by: Anuj Gupta <anuj20.g@samsung.com>

Great, thanks for testing!

-- 
Jens Axboe


