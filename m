Return-Path: <io-uring+bounces-4985-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 239759D62C9
	for <lists+io-uring@lfdr.de>; Fri, 22 Nov 2024 18:11:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A3022160644
	for <lists+io-uring@lfdr.de>; Fri, 22 Nov 2024 17:11:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2A0A7080C;
	Fri, 22 Nov 2024 17:11:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="upR6w/ke"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f176.google.com (mail-oi1-f176.google.com [209.85.167.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8422442056
	for <io-uring@vger.kernel.org>; Fri, 22 Nov 2024 17:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732295499; cv=none; b=cI0MjTNDzhCHxvf1JZzd9r26+h3aFaSBIvTlDtbJdNpFL9aK6NW/zQ26YjmXtknCSQJWuAKWJcSryODOVb/ktxcp+OCf5aABSu64kqFuezJ8+SmK5Y8+2/NzX7iaVfvCCS7+RFJo4yL2As4cB74WFniM/fqSEHi0j9jQoWKMwNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732295499; c=relaxed/simple;
	bh=aEnc+J3sYwjdy/5+CfhThtZw5t40hc6bqNbOmeUKNeQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=paX4S8RbF+7K8tdiVoHizpZnUsEU2PC4KqALG07oyRO9DkDjtm5z4M0q0mR6hzCBgR9mq1uBHaYj+mD2JeHB83t89D6eVWjgW3bAVjSUmNqjLgs6zMYpV1b0E392gU3Dmpuhl9isEH67WuLyG2Dr7/LU/cLc8HWE0Czsxu4muZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=upR6w/ke; arc=none smtp.client-ip=209.85.167.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f176.google.com with SMTP id 5614622812f47-3e60f6ea262so1120493b6e.1
        for <io-uring@vger.kernel.org>; Fri, 22 Nov 2024 09:11:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1732295496; x=1732900296; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=zrxVAY7uD1Y2L62TTuf8aYzuyqT6W7swqfl/M01OtSE=;
        b=upR6w/ke0cQ9fdtxx/X9LqEzxla1Uj4uZiU2lI+HwXS82G0Q73g9AdCQf8yVHmHngk
         g4chD+kPyHttZaHqO8yBA0onUYPXo1YjZp0xjM5ycPfj00uSisCgFc+/WKvn/BVp7N44
         d5kdrn0x2V/qoIMk9ED34/YM1m/iKxusBal/g+sINKT4Ef/uox5RWpzUVUJBc0Z31t5l
         oOvOtVRNevBptc9f46FtqTWADp0YXumX3wSrf7Ti9REBe8A7+7gz1WMh/3zsmYKq9yhe
         es/gTV4VAS4Ww/Uhddlblvqx8w82c35bj/mN0MCA4G20uv5NB0Tx7C7s1ogVUk7X/VWS
         rEjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732295496; x=1732900296;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zrxVAY7uD1Y2L62TTuf8aYzuyqT6W7swqfl/M01OtSE=;
        b=QcNjo7MtSretaQ3N0Q3jfPs7YfzDAezPilmAw3JQCogIkXHdXgt/cRGU57wWV/O07B
         Aq8T2/B9Ph5IGBZw9GQsr3PGWZOY4qs20kxMvosvnXlFogdtBbGg7HbxFEGV4Ypb69of
         dTg4wyY32SmqP5oUxXMswa3h8+24gdjEv+FM+DT+gVF0Ly5IJNQjaOsgDuLWh7c4Hv+l
         j0bvY0+bOwwKubhNWNTDfjmlAxMkrpI/H3qGnHBUMCeq0m9OO07pmg2u3XFZf1bQ9TPC
         fEam/DPcBZXAnyezpZ655O9JckjGM7U1alrP5JniWSeZG+9wAtE+m+F1ofeR1vqV2UNX
         QYww==
X-Forwarded-Encrypted: i=1; AJvYcCVlNSoLul/vpmwP+1TwSK83awfC9LtTta9Mq63Q8IDKKveajGH+7tvHLFF7pZYfVNVpfbEqO7oRxA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxgc9A+n5yB9W1BSbCunG+Dc9vKPDhyGMEoQvc8kPUHg9kT3Ck5
	g1is9JwbWtaEdUG8DmZzmAQ/OIgMZ2p4XjO8qx7QkT47qkRlD+wHcLrcLe4Frq2/dTq+T1xoSEq
	dMw4=
X-Gm-Gg: ASbGnctzSKCxiNd9IGz3AGLrqMzjAIl29pBEVmOUfafGIAmKQJKDBvIno4SSJvG+yk7
	2+vRL9AVzvNUWi+sUOpN4Yq/+QOUf7K9RhSZygZWram7QcHOgca4hwyHI5f+Nik/5E9BRq+PZqo
	HMWOGJoFFSMChMZSTCtdYVTMaUVUY2uiAK7hjznkmHNhhB+MIansflkaHdrolVAE4zeZK+PJReD
	v6G/txowZGqIFnUGiYxAFHBVklBcTyj6Ob+QDNEBhbr3Q==
X-Google-Smtp-Source: AGHT+IEem6iDmSq8/D3K0tXl3RwOj/scFVB8jUICOZKuiC3zIvH/Qp5kEatVI5pM6fogX8079UOhCA==
X-Received: by 2002:a05:6808:1a0d:b0:3e7:c4ca:7888 with SMTP id 5614622812f47-3e915b60b2emr3996865b6e.37.1732295496507;
        Fri, 22 Nov 2024 09:11:36 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-71c0383ecc2sm484903a34.69.2024.11.22.09.11.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Nov 2024 09:11:36 -0800 (PST)
Message-ID: <988485cb-a8da-4113-bcd5-3c1d1b2ab24f@kernel.dk>
Date: Fri, 22 Nov 2024 10:11:35 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/6] io_uring: replace defer task_work llist with
 io_wq_work_list
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <20241122161645.494868-1-axboe@kernel.dk>
 <20241122161645.494868-3-axboe@kernel.dk>
 <f0c124b6-9a38-45ed-86ac-b219a51917e9@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <f0c124b6-9a38-45ed-86ac-b219a51917e9@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/22/24 10:07 AM, Pavel Begunkov wrote:
> On 11/22/24 16:12, Jens Axboe wrote:
> ...
>>   static inline void io_req_local_work_add(struct io_kiocb *req,
>>                        struct io_ring_ctx *ctx,
>> -                     unsigned flags)
>> +                     unsigned tw_flags)
>>   {
>> -    unsigned nr_wait, nr_tw, nr_tw_prev;
>> -    struct llist_node *head;
>> +    unsigned nr_tw, nr_tw_prev, nr_wait;
>> +    unsigned long flags;
>>         /* See comment above IO_CQ_WAKE_INIT */
>>       BUILD_BUG_ON(IO_CQ_WAKE_FORCE <= IORING_MAX_CQ_ENTRIES);
>>         /*
>> -     * We don't know how many reuqests is there in the link and whether
>> -     * they can even be queued lazily, fall back to non-lazy.
>> +     * We don't know how many requests are in the link and whether they can
>> +     * even be queued lazily, fall back to non-lazy.
>>        */
>>       if (req->flags & (REQ_F_LINK | REQ_F_HARDLINK))
>> -        flags &= ~IOU_F_TWQ_LAZY_WAKE;
>> +        tw_flags &= ~IOU_F_TWQ_LAZY_WAKE;
>>   -    guard(rcu)();
> 
> protects against ctx->task deallocation, see a comment in
> io_ring_exit_work() -> synchronize_rcu()

Yeah that's just an editing mistake.

>> +    spin_lock_irqsave(&ctx->work_lock, flags);
>> +    wq_list_add_tail(&req->io_task_work.work_node, &ctx->work_list);
>> +    nr_tw_prev = ctx->work_items++;
> 
> Is there a good reason why it changes the semantics of
> what's stored across adds? It was assigning a corrected
> nr_tw, this one will start heavily spamming with wake_up()
> in some cases.

Not sure I follow, how so? nr_tw_prev will be the previous count, just
like before. Except we won't need to dig into the list to find it, we
have it readily available. nr_tw will be the current code, or force wake
if needed. As before.

-- 
Jens Axboe

