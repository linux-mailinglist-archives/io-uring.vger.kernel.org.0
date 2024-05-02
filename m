Return-Path: <io-uring+bounces-1706-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F7DD8B9C3D
	for <lists+io-uring@lfdr.de>; Thu,  2 May 2024 16:27:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C0FFA2828D9
	for <lists+io-uring@lfdr.de>; Thu,  2 May 2024 14:27:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 105FA7441E;
	Thu,  2 May 2024 14:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ad4UE0hG"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64578152788;
	Thu,  2 May 2024 14:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714660069; cv=none; b=LJjbUh9DgoUSjyRixYx+llrAwY+hQyWKZoQyU89OJ9Ufnuu8VH+VHNyUnv9tdMoALfbHstIfvoQXRRnHLo/ILsIZWaQUPga8TGrJ2mibBr2rnrShlD5WcEXXM35auWnif7ZqFU1Gijh/M1fsnteuA1Jdv9uVYBfQsOSaHl8ZSGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714660069; c=relaxed/simple;
	bh=4qpwOU55Cj3svKWyDsqHKth5mpRdtHN3TfcAGr68iRA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GKfmEOI8p9Yv1bfOiQjf1eHWVKTsFdd6F1lV0XYNAbNjEoCvLEqx9y0apTHzXAnSTHM5uYV/OiZ1Sm2uDO2MvMOtLJyhBVi0E4qA/dyBXYJ03G+KRpaKdcbA8PjNWoCP2aMsGUorp38ao3PN1VonzzV4IMSrKVJo84luFIr5wso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ad4UE0hG; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-a5557e3ebcaso337881766b.1;
        Thu, 02 May 2024 07:27:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714660065; x=1715264865; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mAySpOnIvvcb7FLaOZLYkZNAtElZPGVhaCtcNSkcU7I=;
        b=Ad4UE0hG74eCf2zqBqtC02TH6OAXuVPas7YuzO0Y9ONy9dT05GZnqXVvT7nsWbeMdF
         /5tPOz688spJYPW7tdGhi2F5ZMmp0V5rnvP2QeF03pDIlSwBcjpcCmvlgNawbjAW5p2G
         g6CaOITWD16lvAG5bkFQlxQqqAd7CKrSG0w+5F57hMOzfbkCR8BvmkKQ9UN7CaXnvjAe
         K7GjT5bqRQH2PngA1pJGfIdLhVpI4M+x3mf7VROXyPzagKMb08AfO2C5vSnb5XYmlKoe
         jp41DD8Ugs3g0tpHqkn3HV7bGxJDJG9A1PAZaeehoQVCSyxUGJxAMDMUnHaKUWgvueK+
         H39Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714660065; x=1715264865;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mAySpOnIvvcb7FLaOZLYkZNAtElZPGVhaCtcNSkcU7I=;
        b=Whb/1uHZ0jLfMQoQUQf+gkqTJ2uf3oTUU2tBMMWCSghJCc1kONOXD0pEuCL6JM171W
         aKOMMww6/QB1W9hUVj6ywXbAViME8yTon4cHKPV3mb+8Nfbms8rMHj3hPp9QMm1BOeG9
         eeltWSfx8e7enKzAX2eGW7G73siX7wVVv9/AUwdtgG5wpVPpmi3F3iMfesxuaa/xzrJ6
         sQQNLQDci1KcO+RSJ9NGy9QQVLrOj8oGMDCLVpjyx4yXdwi+AG/yf+56StTdGctUgTTE
         fLUw8HRVZngSI54DarKO8GDFYqIuwBUWF+1oz00XOf14MZwpHzplLx3N1PJkhQh1QsAK
         ITFw==
X-Forwarded-Encrypted: i=1; AJvYcCVuK4ou6egtMiMK+ECyDa3ZUl3odHwWVGMVpiUD25uI8WmNlc099a+rHG2EesYRKQrHi1uSob/Tc5VEtqT8kpriZCr69OqQResToboet6O2eT6+9FxvHWzud+laSsMZlhdutgPCMA==
X-Gm-Message-State: AOJu0YxZMCcvJ96dCiWJW7AwJB2HZlNmn4WiaIRebMlsK1AOdZllYacx
	anjJO+N4F6Gab4Wv9P192nTmlwCioKSU94N8zvnnimmK1P6ipDb4
X-Google-Smtp-Source: AGHT+IFyNLjJU/9GYulrXG7ugvMoucdugknsp3BO+zV7nVfIZhkl2axrXWYm3wMC44dLcuwPfAr4gg==
X-Received: by 2002:a17:906:a190:b0:a59:5191:f0bf with SMTP id s16-20020a170906a19000b00a595191f0bfmr2333245ejy.17.1714660065500;
        Thu, 02 May 2024 07:27:45 -0700 (PDT)
Received: from [192.168.42.210] (82-132-238-115.dab.02.net. [82.132.238.115])
        by smtp.gmail.com with ESMTPSA id q3-20020a1709060f8300b00a58a67afd2fsm624824ejj.53.2024.05.02.07.27.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 May 2024 07:27:45 -0700 (PDT)
Message-ID: <3f615d94-b1c2-4495-91c4-d74731ba2ab5@gmail.com>
Date: Thu, 2 May 2024 15:28:01 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/9] io_uring: support SQE group
To: Ming Lei <ming.lei@redhat.com>
Cc: Kevin Wolf <kwolf@redhat.com>, Jens Axboe <axboe@kernel.dk>,
 io-uring@vger.kernel.org, linux-block@vger.kernel.org
References: <20240408010322.4104395-1-ming.lei@redhat.com>
 <20240408010322.4104395-6-ming.lei@redhat.com>
 <e36cc8de-3726-4479-8fbd-f54fd21465a2@kernel.dk>
 <Ziey53aADgxDrXZw@redhat.com>
 <6077165e-a127-489e-9e47-6ec10b9d85d4@gmail.com> <ZjBffAzunso3lhsJ@fedora>
 <0f142448-3702-4be9-aad4-7ae6e1e5e785@gmail.com> <ZjEHhRoGP8z4syuP@fedora>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <ZjEHhRoGP8z4syuP@fedora>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/30/24 16:00, Ming Lei wrote:
> On Tue, Apr 30, 2024 at 01:27:10PM +0100, Pavel Begunkov wrote:
...
>>>> And what does it achieve? The infra has matured since early days,
>>>> it saves user-kernel transitions at best but not context switching
>>>> overhead, and not even that if you do wait(1) and happen to catch
>>>> middle CQEs. And it disables LAZY_WAKE, so CQ side batching with
>>>> timers and what not is effectively useless with links.
>>>
>>> Not only the context switch, it supports 1:N or N:M dependency which
>>
>> I completely missed, how N:M is supported? That starting to sound
>> terrifying.
> 
> N:M is actually from Kevin's idea.
> 
> sqe group can be made to be more flexible by:
> 
>      Inside the group, all SQEs are submitted in parallel, so there isn't any
>      dependency among SQEs in one group.
>      
>      The 1st SQE is group leader, and the other SQEs are group member. The whole
>      group share single IOSQE_IO_LINK and IOSQE_IO_DRAIN from group leader, and
>      the two flags can't be set for group members.
>      
>      When the group is in one link chain, this group isn't submitted until
>      the previous SQE or group is completed. And the following SQE or group
>      can't be started if this group isn't completed.
>      
>      When IOSQE_IO_DRAIN is set for group leader, all requests in this group
>      and previous requests submitted are drained. Given IOSQE_IO_DRAIN can
>      be set for group leader only, we respect IO_DRAIN for SQE group by
>      always completing group leader as the last on in the group.
>      
>      SQE group provides flexible way to support N:M dependency, such as:
>      
>      - group A is chained with group B together by IOSQE_IO_LINK
>      - group A has N SQEs
>      - group B has M SQEs
>      
>      then M SQEs in group B depend on N SQEs in group A.
> 
> 
>>
>>> is missing in io_uring, but also makes async application easier to write by
>>> saving extra context switches, which just adds extra intermediate states for
>>> application.
>>
>> You're still executing requests (i.e. ->issue) primarily from the
>> submitter task context, they would still fly back to the task and
>> wake it up. You may save something by completing all of them
>> together via that refcounting, but you might just as well try to
>> batch CQ, which is a more generic issue. It's not clear what
>> context switches you save then.
> 
> Wrt. the above N:M example, one io_uring_enter() is enough, and
> it can't be done in single context switch without sqe group, please
> see the liburing test code:

Do you mean doing all that in a single system call? The main
performance problem for io_uring is waiting, i.e. schedule()ing
the task out and in, that's what I meant by context switching.

-- 
Pavel Begunkov

