Return-Path: <io-uring+bounces-9063-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C06DBB2C70D
	for <lists+io-uring@lfdr.de>; Tue, 19 Aug 2025 16:31:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 814CD3AA88D
	for <lists+io-uring@lfdr.de>; Tue, 19 Aug 2025 14:31:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFF2A222568;
	Tue, 19 Aug 2025 14:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="oWBkkCMp"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f173.google.com (mail-il1-f173.google.com [209.85.166.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FEE5EAD7
	for <io-uring@vger.kernel.org>; Tue, 19 Aug 2025 14:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755613898; cv=none; b=QP7MKH0mtbbGOVHvkP3sTqZGPUQ2D9AbAK/CdQClRbbLgWs2QXuNq/SqhWST/QgmfEnAMy0BlnCcMGNKm4VkpUeWW31c8IY8n8DdZ1/rQN8PON0TKLllmpPm5qN1Z1n1C/+P7t/f+r58cxV3BI7IZgwwp8iVddztCBWWcgUDz+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755613898; c=relaxed/simple;
	bh=aLgspp/S2Iyk7P+ohrNd+Glpp1/PEFHJ2Kkg2qlTk90=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Vl0jxjOS/m9xmCXE4E5xNSjskb8pQJjXhlgE7DCNG2VuK6/FuF0VGlttI9Dv7nIgfIc/QQrUgr3oOz49wFCR8JbXn24mUc2Ahb8muHdW0R2wYa+g6wfVxqx6oMb1nQgjAwNEC8X32mSRY7bmHLhbAYYwUostxztzcEzAspfamB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=oWBkkCMp; arc=none smtp.client-ip=209.85.166.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f173.google.com with SMTP id e9e14a558f8ab-3e67b29c46dso828125ab.1
        for <io-uring@vger.kernel.org>; Tue, 19 Aug 2025 07:31:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1755613894; x=1756218694; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=doQ/KLJHjELZTX3A+SEqng+U0KrReSrU3S8Go5Pjk/c=;
        b=oWBkkCMpopgKL2ZkilDQUc/QcBo7nFtZt1WFZCTTMuUwruZxSjVXNHETP2xNG9Tz3Y
         Fug2XfG9Gv3fKjastcoxyJUt4zogqqkAZTRvd2XuIoySejawM+fPLXW4+kiDRcqiksh+
         D6XxqIKVN6njP/uHVTl2lQFhzNzWBLb+CWpHfJjs8uJCvaG3R2EABS5hEmissrP0ZS3q
         ahwbAuCKNPAONcrCVoLogPPns/7qPoDDBZ+6yN6vxQAaH11srnSFoyQXZBhg1BnHpkcr
         Dve6Pd9AUIRdzhQGxyi3Ith8+os51T2L5BKJ5uv4gTeBreGWnU4e/ocu1otAb0LboOIp
         q9NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755613894; x=1756218694;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=doQ/KLJHjELZTX3A+SEqng+U0KrReSrU3S8Go5Pjk/c=;
        b=VPQh6I1Zqz75bImIZpLtSceBXlBN53UPZGwoySllzY7SKo5WBbjrVb512U9TbUasuy
         0N3ZyxWARQjdQYZVsFbUou/JgKn3KZ1EE9xhvQalIPesoAUtwma9H60lZSMKc3KnDWzJ
         5vmV+RAplxHXU0B8eNbTDdTWIeJ94fJ6dYrdrRQ/yffOZ2rp3EFKK3K4V52RDvGeB7+w
         nfmhx36YK5Hb8a3jxsb11w5Bemd0xpDxlVkRjTxCNgUT+dLWLtS/ljijfdUQ5m2k43e2
         qulz7ehM5t386Q6XeKWwjFkfndCk3MSkrsI8ZjzBCWLepV532IRbiNQc+X2RKqKMg0K3
         bGeg==
X-Gm-Message-State: AOJu0YxztM37rBmcaWcu5WF43YCXlpsDfygnhc0/AkuT/+sQjJSiEoA6
	HiL7si9lCIseG6a8j/XOGvPEmkVNhDi/JWFf6NOxk/x2KT7rTNzWC2aGfX3nHYQkDZ8=
X-Gm-Gg: ASbGncuyLCui6v4VUyTcftxJHOkOrFgkDExLR5Lts46m5YJfa2TeU8e2uiv0Ygqf62K
	0RbGqtg1eEjVg1KJRq9UWntsI35oJRyRiGpZxMx8MDQJ620J9uM+bhflCKwbFRYLB2YCdMvF6AL
	imqK+fB0ZGFrqfeIk09nzV9XSE5zCQp3fEryXOIZBRzUzMMDoj+ZMlwWGkRJUfA1vVp/FuswKgV
	zUMB+DW6bd0tH39+9RadjH+FsBhVWG5jtgzZzphZdcA1j3OBtKQF/uZk2UfWa04Wl/5rH/s5/79
	GnDEK58hfUNoam+8l/PuPDZpdQ1WKozkS0vost5PXzW8HtfCx+HdHQKWdKnKmJpN32eZZu42mRF
	WBjNkY7QJ2+4leYXIjm4=
X-Google-Smtp-Source: AGHT+IEKbR8eoJ1SE0BPDNQZcfv8Rv5/aQsE2wCBi4HEAy89e5guWPSDvlBMvL4OF/dGm4IfDJJ3MQ==
X-Received: by 2002:a05:6e02:1947:b0:3e5:83c5:fe10 with SMTP id e9e14a558f8ab-3e6764f2d64mr38460575ab.0.1755613894370;
        Tue, 19 Aug 2025 07:31:34 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3e57e67c179sm44461715ab.27.2025.08.19.07.31.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Aug 2025 07:31:33 -0700 (PDT)
Message-ID: <628449dc-45e7-4cdf-ad65-7c97e6b2bb6b@kernel.dk>
Date: Tue, 19 Aug 2025 08:31:32 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: uring_cmd: add multishot support without poll
To: Ming Lei <ming.lei@redhat.com>
Cc: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
 Caleb Sander Mateos <csander@purestorage.com>
References: <20250810025024.1659190-1-ming.lei@redhat.com>
 <393638fa-566a-4210-9f7e-79061de43bb4@kernel.dk> <aKRd05_pzVwhPfxI@fedora>
 <91bc3fdf-880d-4b71-94b3-ac72ca0f3640@kernel.dk> <aKSJ8yg7GRh6UzTr@fedora>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <aKSJ8yg7GRh6UzTr@fedora>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/19/25 8:28 AM, Ming Lei wrote:
> On Tue, Aug 19, 2025 at 08:01:18AM -0600, Jens Axboe wrote:
>> On 8/19/25 5:19 AM, Ming Lei wrote:
>>>>> @@ -251,6 +264,11 @@ int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags)
>>>>>  	}
>>>>>  
>>>>>  	ret = file->f_op->uring_cmd(ioucmd, issue_flags);
>>>>> +	if (ioucmd->flags & IORING_URING_CMD_MULTISHOT) {
>>>>> +		if (ret >= 0)
>>>>> +			return IOU_ISSUE_SKIP_COMPLETE;
>>>>> +		io_kbuf_recycle(req, issue_flags);
>>>>> +	}
>>>>>  	if (ret == -EAGAIN) {
>>>>>  		ioucmd->flags |= IORING_URING_CMD_REISSUE;
>>>>>  		return ret;
>>>>
>>>> Missing recycle for -EAGAIN?
>>>
>>> io_kbuf_recycle() is done above if `ret < 0`
>>
>> Inside the multishot case. I don't see anywhere where it's forbidden to
>> use IOSQE_BUFFER_SELECT without having multishot set? Either that needs
> 
> REQ_F_BUFFER_SELECT is supposed to be allowed for IORING_URING_CMD_MULTISHOT
> only, and it is checked in io_uring_cmd_prep().
> 
>> to be explicit for now, or the recycling should happen generically.
>> Probably the former I would suspect.
> 
> Yes, the former is exactly what the patch is doing.

Is it? Because looking at v2, you check if IORING_URING_CMD_FIXED is
set, and you fail for that case if REQ_F_BUFFER_SELECT is set. Then you
have a IORING_URING_CMD_MULTISHOT where the opposite is true, which
obviously makes sense.

But no checks if neither is set?

You could add that in io_uring_cmd_select_buffer(), eg fail if
IORING_URING_CMD_MULTISHOT isn't set. Which if done, then the prep side
checking could probably just go away.

-- 
Jens Axboe

