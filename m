Return-Path: <io-uring+bounces-8321-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A8F4AD734E
	for <lists+io-uring@lfdr.de>; Thu, 12 Jun 2025 16:13:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DA00D17CD80
	for <lists+io-uring@lfdr.de>; Thu, 12 Jun 2025 14:09:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8272225B30F;
	Thu, 12 Jun 2025 14:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="eWKXF7PH"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f42.google.com (mail-io1-f42.google.com [209.85.166.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E16E1253923
	for <io-uring@vger.kernel.org>; Thu, 12 Jun 2025 14:07:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749737250; cv=none; b=PVPLrj0rLJnsP+/E5Uu+C7BFyX/6NdoH60zlcAcC1/hKOps6UDQY12NCgkxAC/peqX8pCYpgouHW1r220n8RId+Q4CDfB4/RRI04M+wcJsGxsrDmZIQyM2CyMSX9dDI1kd6t6s5o2dPNF+XXqzJ4ky/GBHEVMfHQxhdyFOypUC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749737250; c=relaxed/simple;
	bh=ZlKxXddzvj0sXC2oFaswxrLnTGaZARGcaCxTzDGh+pM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TppB9MSXZ87WdcPr7kUZxwP3THFQa5Dt0ZIO91y7SBBZQ6MRvjD4vbUDH50FrdlFZVbwnlNz6wHMNPatqOWOi7b7cqzprCeJJWl3xzQaffZi/oD9oGX3jWP2HFAwUhwzMJHK11suIC89re5aREY/TzzOzJh3TVwxQHidsFxadbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=eWKXF7PH; arc=none smtp.client-ip=209.85.166.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f42.google.com with SMTP id ca18e2360f4ac-872886ed65aso90602739f.1
        for <io-uring@vger.kernel.org>; Thu, 12 Jun 2025 07:07:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1749737248; x=1750342048; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=v7BaPEJdKodlX+vyBzolZJORQM5uM4U2VT2SEvpE3y0=;
        b=eWKXF7PHthlvSUHo2L0mT7TZPZVHmB8dQfitUDKzHVJJVL2i9WgDAKvnaUTC5auDFW
         +tD43WlkaLI/aacQwM+1hiBXVhdtJ9ZU6aPvvxB8R0/DEgyx0nhgN5b6pjBDaf9yq/BT
         UeA/Erknw1tQqGAFXE6uc44jhhcNKjSWQIultjeHa7CFqpjFW1/ZD11+Z068w1iYEAHe
         0NylkR/LY4DTOQXB1QCW9xdHmUlgFRuw53Edz1ZjpEQTfRwfPfaWTUjs1YygN0wfwv/S
         uATBxdizd02kWSCdiQt0ZdKfspQd6d2XoVUj0APzVfphlueoYsmyC4Sp/rvkvSqo+sNo
         RTcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749737248; x=1750342048;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=v7BaPEJdKodlX+vyBzolZJORQM5uM4U2VT2SEvpE3y0=;
        b=xAxkJzUYxjg/+6vXAF1hxhBWtPcuxS9IkExfc0wSRYfdTYW08Tde6cMQF694Y0OQSq
         jc1Y4r3V7dj8CeJTmbtSbzaTcqVms9aGhcijSvHbN0w948+Dl5EtMiP7IS5fHW0MdXVw
         M5K7fRNfgRB5la/7ZWSg6s0nU9rgvIC6u3z+Gh0CzrS1D0PyqVvNkiAySTQhzmbx3/Sp
         S9XEYY+wTAbJrJ402nTph4RSGzZNwLGSiLyW66AvpOmD5y3HURoI9AXz14lc54Wu7Myu
         PpXgX9FzqFolRL+u2xPalTLRxtbaFUC1QdEpUw7mg6cWtkt5rKhie1Iw7oo6SMbcuNPs
         tVwA==
X-Gm-Message-State: AOJu0YxDkL9WJfV7etrMEIoUUjvx5YZar0eHvn2jn8u+jQ7N3sjEBHre
	nmsMrfGMwBZizTEU35acSeW3aOOcZ6rmvrhbMKj3IcHKY4NLae5+7oVz8fZdgOoiUjpC78brrQl
	tJVYU
X-Gm-Gg: ASbGncteGqxRrYpmRNl+NOxf7b9MU6dnrb7K08rqtlJENQLZOKzZT2PkA5MLD7kbuCn
	LTI4gzizKNdetttOgv0XHKBBYoBCe/GGi2YvQtdiX8GcRNyok0inbsp2mCcJFKJI9kl+pb6Iec+
	tGXOoeJLPGsCNpMUUw9nvk4FFiBO8Dj2Z99VV9N+BqAik3QMhjUHZYOKxTXtpyg22GSf1fcQJpw
	yvJJkEQ3lqAYuSbN6KinxAeei2lXxotEti37DHCb5OMuHmkTdHCtUDo1/IlEFd74s8BiJr9jiNL
	XcqRvFBiTAf+pl9M4DSkgaEoNzi4qf+DgvgrdeGDVpdqmc4Rr7D+IpLazBE=
X-Google-Smtp-Source: AGHT+IEWCCCjDjSoMklKVcYCB9WmouD1OwKf8Ba8LILdXB0kk8qnSuDBdbKmmY1TIsfRF6uiFQot2Q==
X-Received: by 2002:a05:6602:480a:b0:875:95b6:4666 with SMTP id ca18e2360f4ac-875bc3ce053mr876867639f.1.1749737248018;
        Thu, 12 Jun 2025 07:07:28 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-875c7c39bf7sm36016539f.0.2025.06.12.07.07.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Jun 2025 07:07:27 -0700 (PDT)
Message-ID: <bf35d09b-e259-46b0-88d5-e950d9ced964@kernel.dk>
Date: Thu, 12 Jun 2025 08:07:26 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC v2 4/5] io_uring/bpf: add handle events callback
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>,
 Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org, Martin KaFai Lau <martin.lau@linux.dev>,
 bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
References: <cover.1749214572.git.asml.silence@gmail.com>
 <1c8fcadfb605269011618e285a4d9e066542dba2.1749214572.git.asml.silence@gmail.com>
 <CAADnVQKOmYmFZwMZJmtAc5v9v1gBJqO-FyGeBZDZe1tT5qPKWA@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAADnVQKOmYmFZwMZJmtAc5v9v1gBJqO-FyGeBZDZe1tT5qPKWA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/11/25 8:28 PM, Alexei Starovoitov wrote:
> On Fri, Jun 6, 2025 at 6:58?AM Pavel Begunkov <asml.silence@gmail.com> wrote:
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

Grabbing a mutex is only expensive if it's contended, or obviously
if it's already held. Repeatedly grabbing it on submission where
submission is the only one expected to grab it (or off that path, at
least) means it should be very cheap.

-- 
Jens Axboe

