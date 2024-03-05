Return-Path: <io-uring+bounces-829-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 07F9E8726A0
	for <lists+io-uring@lfdr.de>; Tue,  5 Mar 2024 19:36:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9CB121F29733
	for <lists+io-uring@lfdr.de>; Tue,  5 Mar 2024 18:36:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDEB117BBA;
	Tue,  5 Mar 2024 18:36:06 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 493F3D268;
	Tue,  5 Mar 2024 18:36:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709663766; cv=none; b=gKo4zwyKW5QtVVKaRpwsV6VeyALQrC8RRxrrr6YaaZxeucZHvj6o3HX3lrg1DHwiqikGFYODrrA5QiDp7MsArxpXnmaG2ZXHhOx4uirHaoR+8VuBaO3z8I6+oF9GC6jpuKQIk3KG64SMq3b7/+ZLJdGe34/85AOy4kI30G+QiCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709663766; c=relaxed/simple;
	bh=ScPDBP2+xLlyGbeLJq0uuHggemY92oF5d5a7x/Sh5RQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=m76f14Uq2UK/DA8rTPtt6kiwu3fNOZB2ZWqP0zKcw5xSyLN5iD0SnYEMYkb3IX3MRzAjsR0WOgYOob51aWMtnjQNv9UrpLukro/5JcveJEluPWQUrpPi3ux9xWzQyoXvCKTYXHUx67lhm1kXWwkzCs4Wm5ZTbvbgMW007h/5MSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-1dd178fc492so17930055ad.2;
        Tue, 05 Mar 2024 10:36:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709663764; x=1710268564;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZXQ9LvXhrZ4awIX2pYz9LC94uyjEwiGLnjC1ETlyf4g=;
        b=vSvyFaD9bmDSCxQBjavmBkLYYZ+v8vAUoyQEsyOnXDEVuCwhKl1jfYbtvR4anlTIQ1
         8M7NHGDWLLm6VT3ooP3Fmzs62l2+mfDz7ukobQBVd5SmMhcAVeBnatCMYnu1nFq7HAkI
         0nG6HJxLYwbrvkYipxZojDQf1N6TrD/zjm0j46583tLunfrRlqbKtWYmQjRz6v4udKip
         V3n1fhk9jxZgsd3XHpHoROqWBT40lJafcak5ZdCKcK8pxlfcDlgJLJpplSDW1DQevzjj
         n1OoLEJrHR0wKlbh0GohY2Mt6U5NB7OZ+fOjCKhOU/296Q1FkMa/faVuEYj+xeG48eK9
         m9Ow==
X-Forwarded-Encrypted: i=1; AJvYcCWotxFgKNQea8t34jTVtdSRwFvOTSKFwdhIO4ZsQs3WZZSRkNOeOcaXOtimPMOVlYkRiQE64EYgBrLpeTqrg2NfIFZ9JkLV6M2HZrsaXFdl7o/rGS9hgg0Gc/ON6svPMgIiUD3f3zBULw9RKXmIcCOJ5HrTX1pIbBMIOzofdIDz3SrEKn2OuHnbC4zpl+w/khMJuBlPzH820T4IZPaZ
X-Gm-Message-State: AOJu0YxCJ9AlNjne4tYAx8Qx2NPOxQnU342ja8yy85sfZ/+fmTbyrLVC
	riPbY7EUHQKFf6LSexfmvgGk6IFMcYyFdasAHzi9WXAFV9YpI7T2
X-Google-Smtp-Source: AGHT+IELhpSP7wTPf0gX0xnS5mV6x+gBxTVzPFdcE3vq5bT8dUTtKx84lXMSESwIKFeeH91JYleC0g==
X-Received: by 2002:a17:902:c94f:b0:1dc:a82a:2316 with SMTP id i15-20020a170902c94f00b001dca82a2316mr3345397pla.35.1709663764455;
        Tue, 05 Mar 2024 10:36:04 -0800 (PST)
Received: from ?IPV6:2620:0:1000:8411:3e11:2c1a:c1ee:7fe1? ([2620:0:1000:8411:3e11:2c1a:c1ee:7fe1])
        by smtp.gmail.com with ESMTPSA id w19-20020a1709029a9300b001d8f81ecebesm10839474plp.192.2024.03.05.10.36.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Mar 2024 10:36:04 -0800 (PST)
Message-ID: <c5b7fc1f-f233-4d25-952b-539607c2a0cc@acm.org>
Date: Tue, 5 Mar 2024 10:36:02 -0800
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/2] Introduce per-task io utilization boost
Content-Language: en-US
To: Christian Loehle <christian.loehle@arm.com>, linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, juri.lelli@redhat.com, mingo@redhat.com,
 rafael@kernel.org, dietmar.eggemann@arm.com, vschneid@redhat.com,
 vincent.guittot@linaro.org, Johannes.Thumshirn@wdc.com,
 adrian.hunter@intel.com, ulf.hansson@linaro.org, andres@anarazel.de,
 asml.silence@gmail.com, linux-pm@vger.kernel.org,
 linux-block@vger.kernel.org, io-uring@vger.kernel.org,
 Qais Yousef <qyousef@layalina.io>
References: <20240304201625.100619-1-christian.loehle@arm.com>
 <86f0af00-8765-4481-9245-1819fb2c6379@acm.org>
 <0dc6a839-2922-40ac-8854-2884196da9b9@arm.com>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <0dc6a839-2922-40ac-8854-2884196da9b9@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/5/24 01:13, Christian Loehle wrote:
> On 05/03/2024 00:20, Bart Van Assche wrote:
>> On 3/4/24 12:16, Christian Loehle wrote:
>>> - Higher cap is not always beneficial, we might place the task away
>>> from the CPU where the interrupt handler is running, making it run
>>> on an unboosted CPU which may have a bigger impact than the difference
>>> between the CPU's capacity the task moved to. (Of course the boost will
>>> then be reverted again, but a ping-pong every interval is possible).
>>
>> In the above I see "the interrupt handler". Does this mean that the NVMe
>> controller in the test setup only supports one completion interrupt for
>> all completion queues instead of one completion interrupt per completion
>> queue? There are already Android phones and developer boards available
>> that support the latter, namely the boards equipped with a UFSHCI 4.0 controller.
> 
> No, both NVMe test setups have one completion interrupt per completion queue,
> so this caveat doesn't affect them, higher capacity CPU is strictly better.
> The UFS and both mmc setups (eMMC with CQE and sdcard) only have one completion
> interrupt (on CPU0 on my setup).

I think that measurements should be provided in the cover letter for the
two types of storage controllers: one series of measurements for a
storage controller with a single completion interrupt and a second
series of measurements for storage controllers with one completion
interrupt per CPU.

> FWIW you do gain an additional ~20% (in my specific setup) if you move the ufshcd
> interrupt to a big CPU, too. Similarly for the mmc.
> Unfortunately the infrastructure is far from being there for the scheduler to move the
> interrupt to the same performance domain as the task, which is often optimal both in
> terms of throughput and in terms of power.
> I'll go looking for a stable testing platform with UFS as you mentioned, benefits of this
> patch will of course be greatly increased.

I'm not sure whether making the completion interrupt follow the workload
is a good solution. I'm concerned that this would increase energy
consumption by keeping the big cores active longer than necessary. I
like this solution better (improves storage performance on at least
devices with a UFSHCI 3.0 controller): "[PATCH v2 0/2] sched: blk:
Handle HMP systems when completing IO"
(https://lore.kernel.org/linux-block/20240223155749.2958009-1-qyousef@layalina.io/).

Thanks,

Bart.


