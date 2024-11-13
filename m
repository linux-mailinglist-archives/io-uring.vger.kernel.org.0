Return-Path: <io-uring+bounces-4664-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D9FBC9C7D28
	for <lists+io-uring@lfdr.de>; Wed, 13 Nov 2024 21:52:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5B36A1F22B38
	for <lists+io-uring@lfdr.de>; Wed, 13 Nov 2024 20:52:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B072205E13;
	Wed, 13 Nov 2024 20:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="gNhm5Tod"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f42.google.com (mail-oa1-f42.google.com [209.85.160.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8710020513F
	for <io-uring@vger.kernel.org>; Wed, 13 Nov 2024 20:51:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731531115; cv=none; b=XtvauGbqBUYDdBjQ7lcVMsRUEmBDzyloAjkW77+pYQgqnBOcdKjay6bUzjhBxKYktQBjH5TAXPcEY9OPTTicCg2uZGQspqE9aBsADHL/Os3yeDxyxKjlf8rHNRQVFk+YULL2Tv5y9k8G7tYH8meHX4S27LYCJxgjk6aa3qaXkGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731531115; c=relaxed/simple;
	bh=QpWF3KKY11uITtp1LyQktCr06S/wpts4SgMopMh5/iQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZrrIu4t5QRpioLmgvxaVNME7zYVDEELyTFQKTdCGAViFtfl7E7lCiVmeTlqNwHg7SBcuYbxhe5Vdbh6W3i1yaOAq4fubdlH9A/Mm/vdG0ZGC0GAaslEeTz7g3U7cKU9UVZbelNvzMFrIIBaJWDT+hvpxWTCRLozDdpOtjPPXkwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=gNhm5Tod; arc=none smtp.client-ip=209.85.160.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f42.google.com with SMTP id 586e51a60fabf-295eb32566dso797150fac.1
        for <io-uring@vger.kernel.org>; Wed, 13 Nov 2024 12:51:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1731531111; x=1732135911; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FU0Uq6tZfqhLW7zTHB3UvLVsIx1+QgdH15vw3E3v+9I=;
        b=gNhm5Tod6oasR1IHHFmKKr/qBsWGCfGIvzcg5EzVBnIqWH5okqQcMSUO9TvsRvXC8E
         1mDevshp+fT1NjHZpybeLxDt4Ig5jVwwQiJojmz8gyHd90s9mTCYXK3zT/9XUJRckCKj
         QRwGerEBtbLENVG8b218bZNhcavmHrmI0PxRq2n4Jqc958DN9P4ZxqVc6icKIptXnAFY
         8T/HU+91Gh4U4X8Y9oa4EEtjXzWfHFKWzicDdhXwmjNLr+X0+dGiMqtAJ16soMRMHTMp
         W5MSAoiQVAlbEAdqcq3GV0YaGOeSa7pgcxRR4fKJ1Tu3MjfMQOIODb/YId1WKPZUO4ZM
         1+3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731531111; x=1732135911;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FU0Uq6tZfqhLW7zTHB3UvLVsIx1+QgdH15vw3E3v+9I=;
        b=trTrDgPeB5vkJat+dvz89zZayAugc3FicZhzdqRJsLwoj+ZN4Vr4BketeboZrmg/3X
         Roj8A6x+vuHuAGBW2UUJWz8pM+ex4qeL2KfNAwVJxV0Eo5lDEd5SDuZPoPG1uOXwcblq
         GT29Mna+Pw7dOAVm0IsqSI5t5KzX8p61pLbM5VwVpPy27tDA3wTe2voIfaSR3WecYwOt
         eBiCCOeJjqDVBmMikcnQB8mSAInkF8Y/AiT6m2JM/tcvLBlxtLhFo1TRp0lcEcHcxEVp
         pJktrpG2IkhF1tihu2kOLM3KlBDXmv/vigLB3fjtfdynEZLNGViPlt7deu6XdWxPpu58
         L/Bg==
X-Forwarded-Encrypted: i=1; AJvYcCXw3BYgXVVv0X4ruEGCmxymnX4glDSTgE0MxtTPtIEVU9ypX4N4Uz4NHzkHyvFJ4ypNxwBmVrRcIQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx/4onbMAOlNMogopcMoG/t+lg70L/ynJEL/MHkscaL9oYJH+3B
	0jvf2VdXTXh1xqs42z8AHWLCFl8qd3QMtP83LAtt57DdhJbhdLp/pdIA+/5ychg=
X-Google-Smtp-Source: AGHT+IGezMqio38lqokF3/YlzSrsEv2nuKdbrSqS8PqApuQDKwmdb/YnN439LHoKX0bRZy3D+8M0gQ==
X-Received: by 2002:a05:6871:209:b0:288:67c0:1bbf with SMTP id 586e51a60fabf-295600f0491mr20870572fac.22.1731531111227;
        Wed, 13 Nov 2024 12:51:51 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-295e9337321sm1169214fac.46.2024.11.13.12.51.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Nov 2024 12:51:50 -0800 (PST)
Message-ID: <2f7fa13a-71d9-4a8d-b8f4-5f657fdaab60@kernel.dk>
Date: Wed, 13 Nov 2024 13:51:48 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: don't reorder requests passed to ->queue_rqs
To: Chaitanya Kulkarni <chaitanyak@nvidia.com>, Christoph Hellwig <hch@lst.de>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
 Keith Busch <kbusch@kernel.org>, Sagi Grimberg <sagi@grimberg.me>,
 Pavel Begunkov <asml.silence@gmail.com>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "virtualization@lists.linux.dev" <virtualization@lists.linux.dev>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
References: <20241113152050.157179-1-hch@lst.de>
 <eb2faaba-c261-48de-8316-c8e34fdb516c@nvidia.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <eb2faaba-c261-48de-8316-c8e34fdb516c@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/13/24 1:36 PM, Chaitanya Kulkarni wrote:
> On 11/13/24 07:20, Christoph Hellwig wrote:
>> Hi Jens,
>>
>> currently blk-mq reorders requests when adding them to the plug because
>> the request list can't do efficient tail appends.  When the plug is
>> directly issued using ->queue_rqs that means reordered requests are
>> passed to the driver, which can lead to very bad I/O patterns when
>> not corrected, especially on rotational devices (e.g. NVMe HDD) or
>> when using zone append.
>>
>> This series first adds two easily backportable workarounds to reverse
>> the reording in the virtio_blk and nvme-pci ->queue_rq implementations
>> similar to what the non-queue_rqs path does, and then adds a rq_list
>> type that allows for efficient tail insertions and uses that to fix
>> the reordering for real and then does the same for I/O completions as
>> well.
> 
> Looks good to me. I ran the quick performance numbers [1].
> 
> Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
> 
> -ck
> 
> fio randread iouring workload :-
> 
> IOPS :-
> -------
> nvme-orig:           Average IOPS: 72,690
> nvme-new-no-reorder: Average IOPS: 72,580
> 
> BW :-
> -------
> nvme-orig:           Average BW: 283.9 MiB/s
> nvme-new-no-reorder: Average BW: 283.4 MiB/s

Thanks for testing, but you can't verify any kind of perf change with
that kind of setup. I'll be willing to bet that it'll be 1-2% drop at
higher rates, which is substantial. But the reordering is a problem, not
just for zoned devices, which is why I chose to merge this.

-- 
Jens Axboe

