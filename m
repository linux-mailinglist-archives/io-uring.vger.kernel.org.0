Return-Path: <io-uring+bounces-1251-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AB2DC88ECB4
	for <lists+io-uring@lfdr.de>; Wed, 27 Mar 2024 18:33:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 53FED29C9F1
	for <lists+io-uring@lfdr.de>; Wed, 27 Mar 2024 17:33:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83B36136E1C;
	Wed, 27 Mar 2024 17:33:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aTo0AkpA"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D51911304A6
	for <io-uring@vger.kernel.org>; Wed, 27 Mar 2024 17:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711560809; cv=none; b=KgFpCoevMVP8CMQoayWUWtAGKbFVLcwZJtJBZhXFv4flQPJDCMM68p+UxHnga8PxYidwOMoK8QK/e/3uwssEeQYl/Dsk1BoJ2IXGRZo2oG6sZzT1UCz3eTYpTYAIG7ZxTnzs/ARM+RgFxvyCG04pdfC999+bjotGfiMBttzei3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711560809; c=relaxed/simple;
	bh=7VBVjIdrs24qAFMgQCtHG4Q2ng2vs607l6fKUnWpeek=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=qglBRai9HiZlIc0/rBCz15y8c3vrhpDUZazmObbvfZAs0mrm6SG4umXODAerbuhlnFOgETat7cW3LvvvxLD8SQ4pk6etDFOJL6qeg872xBvZGcqp1V3StjDjt2JZP1i265/PKkV4VPzg62WPSWQPxH8mN26DFYCcZYJ5jythwzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aTo0AkpA; arc=none smtp.client-ip=209.85.167.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-513edc88d3cso18628e87.0
        for <io-uring@vger.kernel.org>; Wed, 27 Mar 2024 10:33:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1711560806; x=1712165606; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PmUiC96l+OA+p1Q4suKq4u4+70CACXjE0+E8oaYEXJ8=;
        b=aTo0AkpAEdLuJN3BPAltoEiE75/+Ox5F0ORInzVJGTd2zsEsAwrE+r2SD5YL12vjtR
         HE/HoZF+o9XFKszG5mDd7WBw9tZmKm8+glRSUjDxO1WCpqYKw62hymWg07LH+Zo8k6/2
         bBOjyDmlOIGEg1Dca4kkpbP6R7GkDy6hN+ydZsJqcWau7FZEflYNNb8q+7wr3/o7FXQ5
         A+AS+ioKhAkNPi8IUQn3eknmTFYRiGIGsmdOu7305am/obK/jUvpqdNCVkpWtmJlrmbN
         DA/caOVg1wWnvCdJ8UmeoeE2uW2uOd8KJLdZWNo+4raNmSULPiohIA+/NPdaCIJwoL5P
         9j1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711560806; x=1712165606;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PmUiC96l+OA+p1Q4suKq4u4+70CACXjE0+E8oaYEXJ8=;
        b=BCNam4vNBUzhVKC4bAzjPSuskXfig37g6BUuP9JRGda6ICMXAYRi/h4t46kB+Zc7zr
         OfkYAV4EHxQGJm6e4/HCU5fnYY5h2o1v2gDq58tXi2uXQlyTE9z5b0VRzSHJprVC8TPl
         /J2FeZVccOjGxtNPdoWLkLaByb4iYwF7zIfotS8kdZw2Onwxk0kAqqxbtM3R4L0auMl7
         EAwPg8hqWwDzaNPNfOPBeI29P2ASQ08TMETf9ADPnDqx5H+BwdIS7OOKomBf9Zu8ci5+
         WscQI3kIDS0SkydSGHTpu246G3JbbHwWEci+H+sn2I/X04kFpoV2YJ/gvPp/CpHffTAX
         qafg==
X-Forwarded-Encrypted: i=1; AJvYcCXK04vVIO0ua/QsUjeSqGanUpoZBWN8PaDuugQLYdpkdiWk/eZpZIOU+mxCLoZISRvph18lngZEHv4Ti8u3HNx84TnRcKxqvI0=
X-Gm-Message-State: AOJu0YxnpmHQQltPSZW8UJkDvux9byZnOeQeOv4aXLk+wiUveeVZspjH
	XGX89S2F0UXeI4Gk6hxD5pM21ZjD9U35bANfQrbobarJ/7xaV50a
X-Google-Smtp-Source: AGHT+IGKzUChd3O7tv3ywHgqLH/9Dgn7xg8rbJBVAkDN/++IH4WiW71+XEouKKGTgbxhsiKojTt6gg==
X-Received: by 2002:a05:6512:619:b0:515:a62a:8e3d with SMTP id b25-20020a056512061900b00515a62a8e3dmr101847lfe.11.1711560805779;
        Wed, 27 Mar 2024 10:33:25 -0700 (PDT)
Received: from [192.168.8.100] ([85.255.233.105])
        by smtp.gmail.com with ESMTPSA id c5-20020adfc045000000b0033e34c53354sm15488401wrf.56.2024.03.27.10.33.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Mar 2024 10:33:25 -0700 (PDT)
Message-ID: <24b6c05a-dc61-48ca-a359-66910a113ec5@gmail.com>
Date: Wed, 27 Mar 2024 17:28:05 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/4] io_uring: switch deferred task_work to an
 io_wq_work_list
Content-Language: en-US
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <20240326184615.458820-1-axboe@kernel.dk>
 <20240326184615.458820-3-axboe@kernel.dk>
 <22f87633-9efa-4cd2-ab5d-e6d225b28ad5@gmail.com>
 <7662a22e-caeb-4ffd-a4ee-482ff809e628@kernel.dk>
 <bb1b7259-5112-4c9b-a5f4-b5d9d95cfe68@kernel.dk>
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <bb1b7259-5112-4c9b-a5f4-b5d9d95cfe68@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/27/24 16:37, Jens Axboe wrote:
> On 3/27/24 9:45 AM, Jens Axboe wrote:
>>> smp_mb(), see the comment below, and fwiw "_after_atomic" would not
>>> work.
>>
>> For this one, I think all we need to do is have the wq_list_empty()
>> check be fully stable. If we read:
>>
>> nr_wait = atomic_read(&ctx->cq_wait_nr);
>>
>> right before a waiter does:
>>
>> atomic_set(&ctx->cq_wait_nr, foo);
>> set_current_state(TASK_INTERRUPTIBLE);
>>
>> then we need to ensure that the "I have work" check in
>> io_cqring_wait_schedule() sees the work. The spin_unlock() has release
>> semantics, and the current READ_ONCE() for work check sbould be enough,
>> no?
> 
> To answer my own question - no, it's not enough. Let me think about this
> a bit.

Right, to my knowledge release does nothing for write; read;
ordering, and all ops after can leak before the barrier.

-- 
Pavel Begunkov

