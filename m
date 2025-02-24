Return-Path: <io-uring+bounces-6659-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 79228A41F22
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 13:33:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E14EB3B0947
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 12:27:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92C73221F36;
	Mon, 24 Feb 2025 12:26:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LCqOKxS1"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C397B21930E;
	Mon, 24 Feb 2025 12:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740400008; cv=none; b=M/dTZPk8BaLT4b5Xq9jTPfG77mcHXzVAV0Raoy/3MwmYJR/SJQM+BJY/yztXv9D/zDrrWIMumLrSwWiAfxoPW2awDKGj8Y2jQ/qFlb1gB0YGVbQN2/kd2xSDeWjPBwMKm08qlhvHuRq+k+7TT3qtY/WcayZ9nT5/93q9NZGxwlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740400008; c=relaxed/simple;
	bh=vGlGepndYgWT2DQBTH8vv9ZPy9qn+806foZdcXyS1Xo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IKVFW0toGzTP/9xNXNtTt2rUlHv1eyKm9sF15/59sgJGO4WQ1AbSO7dH4WbTsB7C89KzZXUsCR88+7AmJHy82nFKK/5rR0dSG9WieNGcQTkAoyU6TjwvUJLyrClQ9PNJDFitfDh6OLzAcB+kJa8JThQSwV2D1f0PpbfImDerElk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LCqOKxS1; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-abbac134a19so669972166b.0;
        Mon, 24 Feb 2025 04:26:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740400005; x=1741004805; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Z3DINdR7U7YAAVkvMzjWHburtjPwkiuTtmGkvHpks3E=;
        b=LCqOKxS1Zp7+Kww/K+t/nUbuZG4n8YyzMm6cdoO7PgeHtaBI1gxi1JsFUU9A+Km4X2
         KfT4NPNz4fNIPwbkAqOgfRyZKtV8RUd1loV3VWJG5G2g44tkA/uPi9tKScnCV37LjZLb
         p/TuSYHhoDlSMJTxpVNEp/TTxtLHxFyBp0gszCkv0wKBwINj1JfDSOXuU/lSumi+m1FG
         jEDXhHEwRgiYoqdx+ksDd4mDjrtvKlnlL5X/HST9NsLZJxnMWbVhcP+Nyq2qPlkzjmWp
         Bb8LSlIDGxLWHr8JjQ4vwIRQGTz2ZRWXYk7y/k06phnZ6sJWSxH8lD6xTTRVAfhxMZsk
         rW8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740400005; x=1741004805;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Z3DINdR7U7YAAVkvMzjWHburtjPwkiuTtmGkvHpks3E=;
        b=jP0a/LxR/xp4M5PuQonGCyqtDhWt73KuOzj8cGodxFH37s5ksWvcIX99f3MGmmVBkz
         3JU2PAjqemH8dicI1CaymbrgZDfF2LSUzPRct3qbKcMuvV76iq4PD7aJ+9R1obbLQ9iE
         r/0kwzwAS/GTpi2Z6YvZUVtQ4aZBitNbfT7HZoNjCHZuzo8+jmqgeSyev0WR+TTbYfqo
         sy7Rf7dGcQLEWIMZTCozd9+fbDor4Yv1DD3wYud/D9jG90trBLXe3GDIq3oo3XQyJIHq
         W6RpnVCLWffOMNtvOTzZrRU0f5DgUDIvuJpzykvnqfdBS550Q42unu2+JGSK85dKoZ6+
         GbMg==
X-Forwarded-Encrypted: i=1; AJvYcCV3Bzx3KWd6K86azWfoysx7Ww/VsfXYozzkTDQBtYFMXEhvsHWz0VX/E51H4UTjt+W5hme9IKomdjkIEuj4@vger.kernel.org, AJvYcCVG+1DTS7qdgN3/aOyVzW3jXam3QSNdKtZ4A2hz5tqLO0NCtuARvS/eEj/ELPOSrp7+sSyvbOrIbQ==@vger.kernel.org, AJvYcCVTtZpXXENNi7GLPkLcpZPFvYVmSgsq5bwSekpA2+LdNDRHJwBuaPn9aKV9/urV57tSbKfGmxgdzJC//HVsXw==@vger.kernel.org
X-Gm-Message-State: AOJu0YyQ2IS+IDV25iq2CkMc3ErgQ2/sYZ2HZJvuwrxri4cXru/iCbZh
	QZNBxgm087UpzDHaa8Rrnkj3MVAuw+x4yP+s6nKrLQ5rv7vGMgzK
X-Gm-Gg: ASbGncs5jYmd8ELZ46dE+lqM+uJ7RhuJwKMsCYyXfmqUPlWP+dQ7ZVYAIi35i90dfT1
	S9KZHwdI3Iy8hA8Cg4c5Kq1A2TFm4Z0tMQh8OkvuKMF+q1uJcM+YZmKvUHJqFK3Is2mYW/mGCsD
	UpZ4OfhgIl9UyUesBuiKplO8KjsyFy6lELUWKt90fFRneEG2Dq6W0id64nxB4AiPH+RkGl34Hlo
	haSImqueDc+N8+AH0Tzfkm0oxWhxe9HA66Oe/QZDFCmTh7kxsSFZCrA0mg++YzmjFMTEDaJLjnZ
	Z1YE1yLqX+jhvqBndxXbxG+e9g6NAhpoGTAb6SFWzz63iGHUhMY9IfMPICY=
X-Google-Smtp-Source: AGHT+IH8L/KI4RvCadlDZyccK4lBIzA7goaTDNlGRXtE+85csj2TkvksvFPrY0HaLmx4pWJ/nbSNDw==
X-Received: by 2002:a17:907:1c0d:b0:ab7:f0fa:1341 with SMTP id a640c23a62f3a-abc09d379b4mr1093453566b.56.1740400004729;
        Mon, 24 Feb 2025 04:26:44 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:bd30])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aba532322f1sm2258286766b.19.2025.02.24.04.26.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Feb 2025 04:26:44 -0800 (PST)
Message-ID: <99a7a0ce-eb2f-4421-9f8e-e7f9d749b674@gmail.com>
Date: Mon, 24 Feb 2025 12:27:45 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] Fuse: Add backing file support for uring_cmd
To: Bernd Schubert <bernd@bsbernd.com>, Amir Goldstein <amir73il@gmail.com>,
 Moinak Bhattacharyya <moinakb001@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
References: <CAKXrOwbkMUo9KJd7wHjcFzJieTFj6NPWPp0vD_SgdS3h33Wdsg@mail.gmail.com>
 <db432e5b-fc90-487e-b261-7771766c56cb@bsbernd.com>
 <e0019be0-1167-4024-8268-e320fee4bc50@gmail.com>
 <CAOQ4uxiVvc6i+5bV1PDMcvS8bALFdp86i==+ZQAAfxKY6AjGiQ@mail.gmail.com>
 <a8af0bfc-d739-49aa-ac3f-4f928741fb7a@bsbernd.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <a8af0bfc-d739-49aa-ac3f-4f928741fb7a@bsbernd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/21/25 17:13, Bernd Schubert wrote:
> On 2/21/25 17:24, Amir Goldstein wrote:
...
>>> +/*
>>> + * Register new backing file for passthrough, getting backing map from
>>> URING_CMD data
>>> + */
>>> +static int fuse_uring_backing_open(struct io_uring_cmd *cmd,
>>> +    unsigned int issue_flags, struct fuse_conn *fc)
>>> +{
>>> +    const struct fuse_backing_map *map = io_uring_sqe_cmd(cmd->sqe);
>>> +    int ret = fuse_backing_open(fc, map);
>>> +
>>
>> I am not that familiar with io_uring, so I need to ask -
>> fuse_backing_open() does
>> fb->cred = prepare_creds();
>> to record server credentials
>> what are the credentials that will be recorded in the context of this
>> io_uring command?
> 
> This is run from the io_uring_enter() syscall - it should not make

That's not necessarily true ...

> a difference to an ioctl, AFAIK. Someone from @io-uring please
> correct me if I'm wrong.

... but it's executed in a context that inherits creds from the
task that submitted the request. It might be trickier if the app
changes creds at runtime, but IIRC the request tries to grab
creds at submission time.

-- 
Pavel Begunkov


