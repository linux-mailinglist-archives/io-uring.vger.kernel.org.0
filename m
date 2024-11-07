Return-Path: <io-uring+bounces-4537-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0718F9C0B0E
	for <lists+io-uring@lfdr.de>; Thu,  7 Nov 2024 17:14:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B2BDE1F22193
	for <lists+io-uring@lfdr.de>; Thu,  7 Nov 2024 16:14:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CBCA215C4C;
	Thu,  7 Nov 2024 16:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="L33PpzEo"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4B22212D0F;
	Thu,  7 Nov 2024 16:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730995884; cv=none; b=LTGxQpC499bZdeqghUy+fwgwhDLhbArl2JCXTGcn2sak1CSA9wnY1A/qPTfDWfb/vMF0MU8G0+0fv3IOUg6zxtyqMwh7up0Lilvx4193U75Idb0p1vFs/298oLPcmab75aRqVWZYN9yh+wGIkc6zx3Zc5QcWiuacUR5DDDTOAhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730995884; c=relaxed/simple;
	bh=X0RTAPVtrnK9/kMLFSHZjEgmVbLupuaPLEy6Y1924cE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Y0s5skNdRF1gNXfb904oWnjHERS7hawyowz7x6pDg2msSyiSYIhqtF3+hT3n3jFqH4WmgsNa9SD3RzMpAODyWRzUZJoHG8WMGy5RHxGyC8H0do8fjIswHo9tXwoXjFGD/Zv5OE+2VJvuwIkiRXjuQbvm+OKuBlIG/5EdAwbE6/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=L33PpzEo; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-a9e8522c10bso170211766b.1;
        Thu, 07 Nov 2024 08:11:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730995881; x=1731600681; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jZx8umh+eZry9u3ccLLUJCRB5y4xW300SaCc1qeEjDc=;
        b=L33PpzEoKAOPXlbsWDaBRA+mrdf3p7kCcNWTnjqGIrbLgjWOnV6pbXL2qonIEgSU+k
         8culP0naI5/j3DLJIrHsO5uKFz5X8rkDnUM1RbeAEJdQZ6o+bxAaUvht+rz6WywGtKsa
         mCoxVplxfmFcAXMdqcbZoF57ibeSdgD25f4fX+2G2fORmZMLu50tCPW55UmgD7aTZq9f
         CpeR+AGQCuSRdiZEmtFGgmgRQpmy0eNrhMmBDinG+ud+8n42addvWHP86ZczUKOUHyAa
         GNlpLT8Xm6uKsqIfJEm0czS5HoEYkE5Qeu4dA87p2ZFs2G2b6jP9tHWsIT/GjXVuG9je
         tfIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730995881; x=1731600681;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jZx8umh+eZry9u3ccLLUJCRB5y4xW300SaCc1qeEjDc=;
        b=KOMWxQzRfeQ8FWBIE5O5sC2R0UqDOv8zh/CfZ868FdUzqCcxOvHBrEaWM191O13cto
         wOugsQnvQMj7VHjMnAq5kBuQRCdRoKwMaMh1Zmc2cUK38iYIvSTkX5GKyU2qD8pvn+go
         SjSck33HS2191RI+Ehg+4EI1rva2EgyJ2BcIZUodauuX6tJUR64MhZ1nN0c0xTNR6Lkz
         CuBIzR/R2H7gYfN36dUltfuvGBuFgpPgtRTr0hLi1p0BOyVrUkAziw7HuuSLqkkogiaQ
         N8bu9Oy94+Mj112GlcSjhlPSoFYFzGRdHStip3zF6C4e9kFabIfOSjtmotifzqQcxVxS
         SkvA==
X-Forwarded-Encrypted: i=1; AJvYcCUuj7OA8eWZz6p0OlSfCXPOOhhBhffDi/rPLWjRsDM/u/UsEUNIjopXMyKa/pGXqZq4xjPYmJXOAeJXghNwzQ==@vger.kernel.org, AJvYcCWp8r6+dqKmC/HBiw4oHxS5bgCn5ny0VcL40wT6zDjcOt290KU2KHrzfVy77sbDV1M0TGr0LV+cGw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxgWD6ih5UI0E38Tjb3kWImF6Lbxo80bQoIXjufDuLWwCAW2yuD
	jjm+huv4W4ipxdzS6X4htezsCeNt20VgtHVkPXXjd8QYJHFdnl2k
X-Google-Smtp-Source: AGHT+IEfgsniFRZsELlf4oZ//mbWv4b8tAt2MDqnPvSmkBLGOxXL1uxUwxoJyOiqN5wqAb2MZJHARA==
X-Received: by 2002:a17:907:7f2a:b0:a99:6265:ed35 with SMTP id a640c23a62f3a-a9eec991e4cmr10110266b.10.1730995880676;
        Thu, 07 Nov 2024 08:11:20 -0800 (PST)
Received: from [192.168.42.207] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9ee0a17678sm110983566b.10.2024.11.07.08.11.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Nov 2024 08:11:20 -0800 (PST)
Message-ID: <56de1181-b37d-4952-9b2f-0565c6f53ab8@gmail.com>
Date: Thu, 7 Nov 2024 16:11:20 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v4 12/15] io_uring/cmd: let cmds to know about dying
 task
To: Bernd Schubert <bschubert@ddn.com>, Ming Lei <ming.lei@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Jens Axboe <axboe@kernel.dk>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
 Joanne Koong <joannelkoong@gmail.com>, Amir Goldstein <amir73il@gmail.com>,
 Ming Lei <tom.leiming@gmail.com>
References: <20241016-fuse-uring-for-6-10-rfc4-v4-0-9739c753666e@ddn.com>
 <20241016-fuse-uring-for-6-10-rfc4-v4-12-9739c753666e@ddn.com>
 <b4e388fe-4986-4ce7-b696-31f2d725cf1c@gmail.com>
 <473a3eb3-5472-4f1c-8709-f30ef3bee310@ddn.com>
 <f8e7a026-da8a-4ce4-9b76-24c7eef4a80a@gmail.com>
 <9db7b714-55f4-4017-9d30-cdb4aeac2886@ddn.com>
 <CAFj5m9L9xjYcm2-B_Dv=L3Ne3kRY5DVQ8mU7pqocqXE13Ajp-g@mail.gmail.com>
 <c85045a5-0865-45d2-b561-d6b1cfb75c38@ddn.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <c85045a5-0865-45d2-b561-d6b1cfb75c38@ddn.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11/6/24 19:34, Bernd Schubert wrote:
> On 11/6/24 05:44, Ming Lei wrote:
>> On Wed, Nov 6, 2024 at 7:02 AM Bernd Schubert <bschubert@ddn.com> wrote:
>>>
>>>
>>>
>>> On 11/5/24 02:08, Pavel Begunkov wrote:
>>>>
>>>> FWIW, the original version is how it's handled in several places
>>>> across io_uring, and the difference is a gap for !DEFER_TASKRUN
>>>> when a task_work is queued somewhere in between when a task is
>>>> started going through exit() but haven't got PF_EXITING set yet.
>>>> IOW, should be harder to hit.
>>>>
>>>
>>> Does that mean that the test for PF_EXITING is racy and we cannot
>>> entirely rely on it?
>>
>> Another solution is to mark uring_cmd as io_uring_cmd_mark_cancelable(),
>> which provides a chance to cancel cmd in the current context.

In short, F_CANCEL not going to help, unfortunately.

The F_CANCEL path can and likely to be triggered from a kthread instead
of the original task. See call sites of io_uring_try_cancel_requests(),
where the task termination/exit path, i.e. io_uring_cancel_generic(), in
most cases will skip the call bc of the tctx_inflight() check.

Also, io_uring doesn't try to cancel queued task_work (the callback
is supposed to check if it need to fail the request), so if someone
queued up a task_work including via __io_uring_cmd_do_in_task() and
friends, even F_CANCEL won't be able to cancel it.


> Yeah, I have that, see
> [PATCH RFC v4 14/15] fuse: {io-uring} Prevent mount point hang on fuse-server termination
> 
> As I just wrote to Pavel, getting IO_URING_F_TASK_DEAD is rather hard
> in my current branch.IO_URING_F_CANCEL didn't make a difference ,
> I had especially tried to disable it - still neither
> IO_URING_F_TASK_DEAD nor the crash got easily triggered. So I
> reenabled IO_URING_F_CANCEL and then eventually
> got IO_URING_F_TASK_DEAD - i.e. without checking the underlying code,
> looks like we need both for safety measures.

-- 
Pavel Begunkov

