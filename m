Return-Path: <io-uring+bounces-8318-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F13AAD6C40
	for <lists+io-uring@lfdr.de>; Thu, 12 Jun 2025 11:32:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 42A5717E93B
	for <lists+io-uring@lfdr.de>; Thu, 12 Jun 2025 09:32:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3462224244;
	Thu, 12 Jun 2025 09:32:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="he5wGYrN"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17D621F583D;
	Thu, 12 Jun 2025 09:32:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749720728; cv=none; b=i9VGNfYDdMN8+w/nEFlWegAhyHK+iq7AvxyCJZzDijt5iRabQywsTp2SwLHBC3X2oiqeH/9DIZan628bbzMa4UNt0GsVCsTZOdOBXK6E7hAzcoDMHWZ8lHMua0dUXjPnLJF9szpfcRfFJiDBu3hKk2mHMEdOy4ujgDMLKSQMUKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749720728; c=relaxed/simple;
	bh=fjXkONU7XmuJaoZ3aT6+vTpOz6C4HuPYdk5YletMS4Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Hp0VOHi/9z2qJv17z1EIzwuZyyaV/myjKtgVyAUr6FXlvy6Z1R8/yvl6aPWgQh0tGmH8OniSeFv1P/1uV9CWRmF6zXx8mKBVaShZevgaJCC8+DZ3DWgLFdDt7ubuItW2BNGYNxvPx4fElSAWA9GH9p20j32pIkfMAcl9j37lAbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=he5wGYrN; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-ad88d77314bso160789466b.1;
        Thu, 12 Jun 2025 02:32:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749720725; x=1750325525; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=eCJsxEivkwvGkCehnqd6AJf/P7ksgfCcXbdvRxFOYIc=;
        b=he5wGYrN3e2jUhni8hkN8vqrn82N6vuDQvggT/EkLMxSuCZpf5wLZPgO7EeF1BFBF2
         o3nXXnR6W4nhgraTf9tpf2kHdWb7llhJVr0W+roELU06P2OOKj+csIdiVnkrfLMn1ocf
         ZsCFYovtlkApTH8NrwfIFu1dBpIRc5dasCxt84YVY14Pt7ccFU93Dmd3uEGPQ8J6FR3A
         HSMLhrP1UJE1t4I80dcxkDBA13vwWmjJ+sXEkOyYpXEBZ9rw1tkyFMChsdgkxsF62/kQ
         lh40rf6wBU0y3H+Gt4I78tDBmpFY8qlwc3g05xmjjob+2F3oPSVGdvx2eua+14Tnmh5V
         K+wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749720725; x=1750325525;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eCJsxEivkwvGkCehnqd6AJf/P7ksgfCcXbdvRxFOYIc=;
        b=W4diFmfGq+ZN7iBQmFjFzCUCfWQ6bGa3nqHIg8lpUmh8E7d7hshEkN/S0lw0UFiIba
         UK9vYUT6mwkVTdgdgvOXLA+jf94gqmJ1sag8QniaPVO6jeQ2iB2EOQQn7+oq9yp4m1W+
         NBO1gz9+FP+0itM58JF+XKuqr2t7HOSP+UOqhDEmj5/q5dddi16fbl8FbtNcWC5SL0Ui
         taW9va/GFgtZRKkM244ifipcZCCKGVqB55GJLaEmTTUEPQ81Wi6zGeiBTMhtFMwPUurh
         lvg1MVoc/aSV0QYZFmDHvH7hYmhJQhzzlZU55MCZJrStTmj5vvEom2TC8Fnrkvk1CQxT
         qAjw==
X-Forwarded-Encrypted: i=1; AJvYcCVSNF5Fz/zSFF+UwToLBjcUycYazfxEk9grloxvbxMlbncrElhJcqfYV1skaWZf/AWllBk=@vger.kernel.org, AJvYcCXh4wqUXz4jVXBr1qMcMhGMtE3p2NG+Ie7N8h0P6QgEKqJGaIdK2bHAYOxgST63wdSoid7Z/6y2LyPRGMhQ@vger.kernel.org
X-Gm-Message-State: AOJu0YwFsf5bhiITEg367mzrLTPZBf5FQ8LqVV5VTWkCyxW2C1uKdh1g
	ztmOXUs/KcBBqIuy1m/l7W+imF7ZKo9ryQocoHS4g7GdQ0XuEzTs7IBiZYlW6A==
X-Gm-Gg: ASbGncsAh84GLLwDb/a+NneYfENWcE2jTg/7V5oJJ9CiXf25NXMOZofscIRf6ed5L7g
	aTBbryGayyGWjTkFt7Tnsg+SI1aZ2EMw/DYoWF520KJ9hNf/mRsa4qixHypQGRCPSuOD3oqbM42
	G6bnQdW+HuolwuN4W4Bb+VWbirV6eFGVu09++KSi1zGcZ0T4BIXK1JiXfHV/NBgCczVU0pvTU8j
	4TbLZbpp3EI53/7IMK2rnrpThPSa8W6GKthb0ojrEy0HUR0m33i+ynaenUMEB20S7YHAeMkBRMU
	Wb7rDYLSJzWM1912OIkWF5dizXaTlzTuqpbncDsYWV4RvOcgpgnOaY2R0P1l8zxcMfjrSKQtGiK
	JgL57ZHMe36of5RGIIQ==
X-Google-Smtp-Source: AGHT+IFk5VbJtxAhNF/55f923ZLJvy/heiuxusUdJGsctgKxkDgGsjMqsZ7BI1Rd/xG/CWbwrnZuiQ==
X-Received: by 2002:a17:907:9803:b0:ad8:9e80:6bc3 with SMTP id a640c23a62f3a-ade893db0e9mr668476866b.1.1749720725285;
        Thu, 12 Jun 2025 02:32:05 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:be2])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-adead8d773dsm102079166b.41.2025.06.12.02.32.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Jun 2025 02:32:04 -0700 (PDT)
Message-ID: <6649c552-5a84-4a3a-b276-fc9f4008d019@gmail.com>
Date: Thu, 12 Jun 2025 10:33:29 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC v2 4/5] io_uring/bpf: add handle events callback
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: io-uring@vger.kernel.org, Martin KaFai Lau <martin.lau@linux.dev>,
 bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
References: <cover.1749214572.git.asml.silence@gmail.com>
 <1c8fcadfb605269011618e285a4d9e066542dba2.1749214572.git.asml.silence@gmail.com>
 <CAADnVQKOmYmFZwMZJmtAc5v9v1gBJqO-FyGeBZDZe1tT5qPKWA@mail.gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CAADnVQKOmYmFZwMZJmtAc5v9v1gBJqO-FyGeBZDZe1tT5qPKWA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/12/25 03:28, Alexei Starovoitov wrote:
> On Fri, Jun 6, 2025 at 6:58 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>
>> +static inline int io_run_bpf(struct io_ring_ctx *ctx, struct iou_loop_state *state)
>> +{
>> +       scoped_guard(mutex, &ctx->uring_lock) {
>> +               if (!ctx->bpf_ops)
>> +                       return IOU_EVENTS_STOP;
>> +               return ctx->bpf_ops->handle_events(ctx, state);
>> +       }
>> +}
> 
> you're grabbing the mutex before calling bpf prog and doing
> it in a loop million times a second?
> Looks like massive overhead for program invocation.
> I'm surprised it's fast.

You need the lock to submit anything with io_uring, so there is
a parity with how it already is. And the program is just a test
and pretty silly in nature, normally you'd either get higher
batching, and the user (incl bpf) can specifically specify to
wait for more, or it'll be intermingled with sleeping at which
point the mutex is not a problem. I'll write a storage IO
example for the next time.

If there will be a good use case, I can try to relax it for
programs that don't issue requests, but that might make
sync more complicated, especially on the reg/unreg side.

-- 
Pavel Begunkov


