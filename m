Return-Path: <io-uring+bounces-4240-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D5539B6DA1
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 21:26:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B0AC51F21EAE
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 20:26:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 403A121744F;
	Wed, 30 Oct 2024 20:25:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="fyHJnpJU"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f46.google.com (mail-io1-f46.google.com [209.85.166.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93418213ED2
	for <io-uring@vger.kernel.org>; Wed, 30 Oct 2024 20:25:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730319936; cv=none; b=Qq55PdT+jXxcqC00TgOWEaYMoqs9YocWU57HbPTeceOaqA2TAF8wZp/RxcZmUV89py9NW70i3+o0/tNVsTvePzLk3wQwXr+88QG+VURFSLwxV8maHw1D5LKE2T5KPdVIhWZuOaN5PTzj+gRrA29pnJyas/TI5RjG02N2K0nm/C0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730319936; c=relaxed/simple;
	bh=+uRMkLLCF5iieoQKk10L/haJG3t2kliE037fznPp2u8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tRcTJu1gv+xa/raWGYHaKghuH2HUe2RDsuvRXdnwzAA6ADKMmSenOOxsbh4JajoAO1UHgYgMk9VOIGjTzToYqj05CUINEhtMz29P1KTj66XRXCgvbBRdrZi1+yq6sBKaV4uQcfA4EjHREXxPz8bOxa1Ab7zc2RPRQiTLYrVzORA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=fyHJnpJU; arc=none smtp.client-ip=209.85.166.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f46.google.com with SMTP id ca18e2360f4ac-8323b555a6aso8499939f.3
        for <io-uring@vger.kernel.org>; Wed, 30 Oct 2024 13:25:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1730319930; x=1730924730; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=p1xwNrrbQwfJc8qTRA/s1aEcrnDcXeFu4k0qDwq6S4Q=;
        b=fyHJnpJUHxqTcvFwKWazrUfzLM1hZjAQt5elUSn5xwaoqtu1b7xZd9HRfr7dcaU6PF
         VZPiO/Vgki94o/niM/b8/5vS1TfEi7gvQ8Vbc64YD0AcROjBA4rfMa6Y2zH4vUxzEBRo
         JV//GKery0fepwUF5EuY+kqTz9G3QP7KQuVvvS1IFGiCNVQmgDLlXt5XeUoiB8DuSWiD
         s1qGqG1nex6Jh/XfyMjwgex17gL3r9bUjB0UpFva9RuatxRRGQT0SNUOvhV3zKb9VTjQ
         N+8YZz+wCTOoaxcgJaHPo/NJUyh94TUGDmYu262OWEiLtcYuSMjYdI+8ZkZ+Lr+2ofn5
         bUxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730319930; x=1730924730;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=p1xwNrrbQwfJc8qTRA/s1aEcrnDcXeFu4k0qDwq6S4Q=;
        b=mqSzu9T8IHYZ4JoPYS3ziJlfE0JgwHFdxIL785MzdX+03g/bb5FnErW7ztGm1WiCeT
         Kq1SL5KtwsuFTIE8jBgyw0KjGSAc2lSXLLp7UeximfPmKiUm6FKiwN+OlwNAjy+i9jCE
         34Iy5JeWMq7N6cxzYRjsfoTUTTIEjs0O2QitKlbJO3iyGy+/CybQmjzmR2DPDfj+fAwC
         VArn3E0qVSc9CO4UP/L2VUat/ai091TAw1WbeIbRaraEJoFnaWtGqUvV++yIeuxs+wvC
         VhPg4OkJO5u0sXUyYToZ2suXac/extkqF+sxs8kfvgxjtBd2XlVDohOTqI2sDOt4z2q+
         adcg==
X-Gm-Message-State: AOJu0Yx4OhPuu6V+8vG0j/0qVMB4WqylP3HhN2qIlNjKyihYo5+6L/tF
	56m8woiN9r8ZA+1MdnR6zbC+MPRWm28stngJY76azjz2RNhU8MYISmtGIGA7v2F7mV0ICXIGIJx
	jQrI=
X-Google-Smtp-Source: AGHT+IG6rrv3AJnnLn1xfKak6nx+G+obbfU8wdKAZ4JrjW5HDOpoBzfReWtF+H4xeaWqoMfKTHvUFg==
X-Received: by 2002:a05:6602:2c03:b0:83a:b52b:5cbb with SMTP id ca18e2360f4ac-83b64f7ff31mr109143339f.5.1730319930161;
        Wed, 30 Oct 2024 13:25:30 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-83b138920d3sm260310239f.53.2024.10.30.13.25.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Oct 2024 13:25:28 -0700 (PDT)
Message-ID: <eb449a55-f1de-4bab-a068-0cbfdd84267c@kernel.dk>
Date: Wed, 30 Oct 2024 14:25:27 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC] io_uring/rsrc: add last-lookup cache hit to
 io_rsrc_node_lookup()
To: Jann Horn <jannh@google.com>
Cc: io-uring <io-uring@vger.kernel.org>
References: <db316d73-cb32-4f7f-beb0-68f253f5e0c5@kernel.dk>
 <CAG48ez1291n=0yi3PvT0V0YXxwtP9rUbXMghYsFdkia1Op8Mzw@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAG48ez1291n=0yi3PvT0V0YXxwtP9rUbXMghYsFdkia1Op8Mzw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 10/30/24 11:20 AM, Jann Horn wrote:
> On Wed, Oct 30, 2024 at 5:58?PM Jens Axboe <axboe@kernel.dk> wrote:
>> This avoids array_index_nospec() for repeated lookups on the same node,
>> which can be quite common (and costly). If a cached node is removed from
> 
> You're saying array_index_nospec() can be quite costly - which
> architecture is this on? Is this the cost of the compare+subtract+and
> making the critical path longer?

Tested this on arm64, in a vm to be specific. Let me try and generate
some numbers/profiles on x86-64 as well. It's noticeable there as well,
though not quite as bad as the below example. For arm64, with the patch,
we get roughly 8.7% of the time spent getting a resource - without it's
66% of the time. This is just doing a microbenchmark, but it clearly
shows that anything following the barrier on arm64 is very costly:

  0.98 │       ldr   x21, [x0, #96]
       │     ↓ tbnz  w2, #1, b8
  1.04 │       ldr   w1, [x21, #144]
       │       cmp   w1, w19
       │     ↓ b.ls  a0
       │ 30:   mov   w1, w1
       │       sxtw  x0, w19
       │       cmp   x0, x1
       │       ngc   x0, xzr
       │       csdb
       │       ldr   x1, [x21, #160]
       │       and   w19, w19, w0
 93.98 │       ldr   x19, [x1, w19, sxtw #3]

and accounts for most of that 66% of the total cost of the micro bench,
even though it's doing a ton more stuff than simple getting this node
via a lookup.

>> the given table, it'll get cleared in the cache as well.
>> io_reset_rsrc_node() takes care of that, which is used in the spots
>> that's replacing a node.
>>
>> Note: need to double check this is 100% safe wrt speculation, but I
>> believe it should be as we're not using the passed in value to index
>> any arrays (directly).
>>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>
>> ---
>>
>> Sending this out as an RFC, as array_index_nospec() can cause stalls for
>> frequent lookups. For buffers, it's not unusual to have larger regions
>> registered, which means hitting the same resource node lookup all the
>> time.
>>
>> At the same time, I'm not 100% certain on the sanity of this. Before
>> you'd always do:
>>
>> index = array_index_nospec(index, max_nr);
>> node = some_table[index];
>>
>> and now you can do:
>>
>> if (index == last_index)
>>         return last_node;
>> last_node = some_table[array_index_nospec(index, max_nr)];
>> last_index = index;
>> return last_node;
>>
>> which _seems_ like it should be safe as no array indexing occurs. Hence
>> the Jann CC :-)
> 
> I guess the overall approach should be safe as long as you make sure
> that last_node is always valid or NULL, though I wonder if it wouldn't

Right, that obviously has to be true.

> be a more straightforward improvement to make sure the table has a
> power-of-two size and then using a bitwise AND to truncate the
> index... with that I think you'd maybe just have a single-cycle
> lengthening of the critical path? Though we would need a new helper
> for that in nospec.h.

That might work too. I don't necessarily control the size of the array,
but I could indeed just oversize it to ensure it's a power of two.
That'd certainly help code generation for the truncation, but not get
rid of the csdb()?

>> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
>> index 77fd508d043a..c283179b0c89 100644
>> --- a/include/linux/io_uring_types.h
>> +++ b/include/linux/io_uring_types.h
>> @@ -57,6 +57,8 @@ struct io_wq_work {
>>
>>  struct io_rsrc_data {
>>         unsigned int                    nr;
>> +       unsigned int                    last_index;
>> +       struct io_rsrc_node             *last_node;
>>         struct io_rsrc_node             **nodes;
>>  };
>>
>> diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
>> index 9829c51105ed..413d003bc5d7 100644
>> --- a/io_uring/rsrc.c
>> +++ b/io_uring/rsrc.c
>> @@ -139,6 +139,8 @@ __cold void io_rsrc_data_free(struct io_rsrc_data *data)
>>                 if (data->nodes[data->nr])
>>                         io_put_rsrc_node(data->nodes[data->nr]);
>>         }
>> +       data->last_node = NULL;
>> +       data->last_index = -1U;
>>         kvfree(data->nodes);
>>         data->nodes = NULL;
>>         data->nr = 0;
>> @@ -150,6 +152,7 @@ __cold int io_rsrc_data_alloc(struct io_rsrc_data *data, unsigned nr)
>>                                         GFP_KERNEL_ACCOUNT | __GFP_ZERO);
>>         if (data->nodes) {
>>                 data->nr = nr;
>> +               data->last_index = -1U;
>>                 return 0;
>>         }
>>         return -ENOMEM;
>> diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
>> index a40fad783a69..e2795daa877d 100644
>> --- a/io_uring/rsrc.h
>> +++ b/io_uring/rsrc.h
>> @@ -70,8 +70,16 @@ int io_register_rsrc(struct io_ring_ctx *ctx, void __user *arg,
>>  static inline struct io_rsrc_node *io_rsrc_node_lookup(struct io_rsrc_data *data,
>>                                                        int index)
>>  {
>> -       if (index < data->nr)
>> -               return data->nodes[array_index_nospec(index, data->nr)];
>> +       if (index < data->nr) {
>> +               if (index != data->last_index) {
>> +                       index = array_index_nospec(index, data->nr);
>> +                       if (data->nodes[index]) {
> 
> I guess I'm not sure if eliding the array_index_nospec() is worth
> adding a new branch here that you could mispredict... probably depends
> on your workload, I guess?
> 
>> +                               data->last_index = index;
>> +                               data->last_node = data->nodes[index];
> 
> This seems a bit functionally broken - if data->nodes[index] is NULL,
> you just leave data->last_node set to its previous value and return
> that?

Ah true, yeah it should always clear it. Should set it regardless, that
branch can go away.

-- 
Jens Axboe

