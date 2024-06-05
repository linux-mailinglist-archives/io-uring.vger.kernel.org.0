Return-Path: <io-uring+bounces-2127-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 52CF98FD580
	for <lists+io-uring@lfdr.de>; Wed,  5 Jun 2024 20:13:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D0F6528862B
	for <lists+io-uring@lfdr.de>; Wed,  5 Jun 2024 18:13:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 171F43D66;
	Wed,  5 Jun 2024 18:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ylR7LkpA"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f43.google.com (mail-ot1-f43.google.com [209.85.210.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5CFD624
	for <io-uring@vger.kernel.org>; Wed,  5 Jun 2024 18:08:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717610919; cv=none; b=ezmiIw4r7nog2boopmAdL2npjwgVy7ursU9XPUKLSnRbLPdQm0yFLOvly04x1QuyXyTJoPpEyHPjHKUX/rZ2eAlo6lIUPcH5qoDmj35/Fm48iu3H/qTau6nd5JvtMN4P4LLfe8LhKVTYBhgUnkXxcCFiOc736W77qdlJzxk2FEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717610919; c=relaxed/simple;
	bh=Ul5SlcXbBSD/oTuJXVxqmBhLKYhHYarSgPwIi/+RUDU=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=fklydz9GriFk7WqsJGCWy1i+KjaCFcmcK4MuAaQkK+ayK/Kwt0dpZ2jY0cKp2shA4STOEWpEMyvRZKzBKVAUozd6I8S28V4XsJFcboXYSq2Y1pNI3BeTvEnuaMgKRNsGp/ornTWuUHSC1OqJYArGlodHA97M+9LhEBdE78Vcpck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ylR7LkpA; arc=none smtp.client-ip=209.85.210.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f43.google.com with SMTP id 46e09a7af769-6f93a6d5d70so410a34.2
        for <io-uring@vger.kernel.org>; Wed, 05 Jun 2024 11:08:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1717610913; x=1718215713; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=JRzaN5sZFSegMf6pQo5Rt6wJQS24Jscg6qfOTaYVkPw=;
        b=ylR7LkpA9uqKN29tITDAOTtw8SEAWpbgZ5HH+36jfQGTDRg5LSa/Q1wmDILjpuQkmO
         VvvsgGmaxavQ0lVBWcm3ekJEPLQUJY/g3dAv+P/wy1HPstTbiYyqDUlA1b17ZTZFd6/E
         eJOm6NpRNOB8Gq1EhBVVWOu2jkVj6X/Q1rXAvv7xFa58xUc6D031fAdzjY7qwu/bxBLE
         5/3hovu3NAr+eTKc4usVjIsSEt3TCcAEu3VhIPNXgOyL1z597OeiI9HgcsX1AAQbyl8N
         GQLOAkW1M07ip96HDxW406dfp/XbnjOxVuDU37uIH94RBc8fhIH+e7UJi3D05ASCxioA
         hPdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717610913; x=1718215713;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JRzaN5sZFSegMf6pQo5Rt6wJQS24Jscg6qfOTaYVkPw=;
        b=ssd6cxUAaGfolwUaPaR71Vm6hBijnf4V6S+RmVbiyLkB+eqYbZbjAHXvG4ntSUPDe2
         5sK9AUs5i7WjHAqwfgaqdZKN7z60HVgXHodOBH625SacKJXwRGC6hrWOS6dy9dB2iJP0
         DO8xGvQblFHx+VQVwuqLJ0CqZQ0CrUP6hD9abhfWKSMplgOnSyC93uMHQ+EtvW3PBzfF
         0txvD4uQBH0u58tT/baCJ4Zrc4e4rQ02WVEn6hXPmqsyNe+s7cR+c9FomnzoOgWJdHba
         r1KeYSk8x6yBbCLesEuZJZ0mVBmoeKwg4tFsTXwdV2AooW85ct2gx2Ue5GRRX4VTNSBQ
         UZ9g==
X-Forwarded-Encrypted: i=1; AJvYcCVURe1yEqRlV9c1bunSaLgqXlVYhDz10KSlWsU8pqbBzxdQn1Zff6oaQfRyr04daLs69eLwrdA6JNQLwcrw/Hz5zfPryGGYjyg=
X-Gm-Message-State: AOJu0Yx7A2ljX8ZtQxeLqrsY11Yfq/50G/g+W/rzd50/BvHiZzZ7XGa1
	kMent+5SdTTLdjirkRtGZT6DF7fvUPgemVnSW1BaatyHO7I5IjHaM3t1iaQjf7DL3rOhbj3YENN
	5
X-Google-Smtp-Source: AGHT+IHOzUT4KGuRd4roNSkC9fH+vaK3ZFy6C92QG6EZ7/IQDmpSk9GZJmCaATUmpbfZMIUH7zTQ+A==
X-Received: by 2002:a05:6830:7203:b0:6f0:e529:4f0d with SMTP id 46e09a7af769-6f943433009mr3803004a34.1.1717610913538;
        Wed, 05 Jun 2024 11:08:33 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-6f923758b1bsm1765509a34.21.2024.06.05.11.08.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Jun 2024 11:08:32 -0700 (PDT)
Message-ID: <7401642d-3d29-4949-a10d-76868991d32c@kernel.dk>
Date: Wed, 5 Jun 2024 12:08:31 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/5] io_uring: mark exit side kworkers as task_work
 capable
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <20240604191314.454554-1-axboe@kernel.dk>
 <20240604191314.454554-3-axboe@kernel.dk>
 <a9d5af1e-533a-46c9-9a74-41998eb75288@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <a9d5af1e-533a-46c9-9a74-41998eb75288@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/5/24 9:01 AM, Pavel Begunkov wrote:
>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>> index 96f6da0bf5cd..3ad915262a45 100644
>> --- a/io_uring/io_uring.c
>> +++ b/io_uring/io_uring.c
>> @@ -234,6 +234,20 @@ static inline void io_req_add_to_cache(struct io_kiocb *req, struct io_ring_ctx
>>       wq_stack_add_head(&req->comp_list, &ctx->submit_state.free_list);
>>   }
>>   +static __cold void io_kworker_tw_start(void)
>> +{
>> +    if (WARN_ON_ONCE(!(current->flags & PF_NO_TASKWORK)))
>> +        return;
>> +    current->flags &= ~PF_NO_TASKWORK;
>> +}
>> +
>> +static __cold void io_kworker_tw_end(void)
>> +{
>> +    while (task_work_pending(current))
>> +        task_work_run();
> 
> Clear TIF_NOTIFY_SIGNAL/RESUME? Maybe even retrying task_work_run()
> after and looping around if there are items to execute.

Yeah good point, it should handle clear the notifiers too. Will make
that change.

-- 
Jens Axboe


