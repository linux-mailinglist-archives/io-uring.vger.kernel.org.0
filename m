Return-Path: <io-uring+bounces-218-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E706D803D6E
	for <lists+io-uring@lfdr.de>; Mon,  4 Dec 2023 19:49:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A098228113C
	for <lists+io-uring@lfdr.de>; Mon,  4 Dec 2023 18:49:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 658B928DC0;
	Mon,  4 Dec 2023 18:49:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZS6Ptyi/"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01F97B2
	for <io-uring@vger.kernel.org>; Mon,  4 Dec 2023 10:49:00 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id 5b1f17b1804b1-40c032962c5so29774585e9.3
        for <io-uring@vger.kernel.org>; Mon, 04 Dec 2023 10:48:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701715738; x=1702320538; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tUYp6a+xGLyYOwUZUBhpLjfoPn8DKdApL5lcZLxp6IY=;
        b=ZS6Ptyi/HBdlN0fZEZulF12ZkJZq2EwDICbSkQaZ5GolEApdA+YPcrXmuEE1VUBIAQ
         WsjtI5XAqSyOG5WaR0w+WMr3QyFFpmoq473DWSjfWApZZs1FODVxh3BMfoQLjy3w5lJf
         RWN6B4f4lmqE408n36dAX/R/4D6TZUTmM7Em0a6cSbJKr0T393syu8ShkhJDpFc0dpvw
         adLWPq90aFIBvhslR/KxCu7lUppRmOofv9m9qj4V98nnzVgZoumsd553n3pa1600LTu4
         itjSRMGtn7qFaaFwhbRLW2u+TNCAitLLoGozgpwewN6YTu9UZlKxlTA/D5QIBPuFzFs+
         lg/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701715738; x=1702320538;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tUYp6a+xGLyYOwUZUBhpLjfoPn8DKdApL5lcZLxp6IY=;
        b=ZAPG+LwKPNkRybsSaq0J1SA2X2H29iuRyZjyUc+HR59WeOzMbSRu4hVsZijEHa2Jos
         LXMKN9lX3HZuI5Jh2LtiaUUeuUCNjNtvGHZMpEuPVbsqcx8+UOBedCb6G8zBDTcRRbj4
         z89NV7gMqEwbcd6g22Z32XRUPrLZuIs2Xsx/dnuZvl8nhHFWZPjKR0v/ilndu3cf05VC
         kEFpHuiW8x0MBZEloHIu7Zu/jIJQCf4Ifc6+ps6nxaXECOOS524xg00R7KUqpKPDnsaM
         Uo3yt1YWvydIFhp+j6+brfMIkeu3V3d1qJcYwLKgAedG5a8O8QtF9wLqXxNmqPZo1v04
         VDOA==
X-Gm-Message-State: AOJu0YywwA01+r7BOcBxbPE0goOJXEhsSPjxKmJySuybt1qgme8S2Wfo
	lm/Cjl4izHrbsXVm02CiMxt3l4yTtzg=
X-Google-Smtp-Source: AGHT+IH6aY56AVBstl9OknQQqt1nEZO3C7vMCaobOip0u6GjpARC5QGAQVxd3HDPhaaFmICk/3D0gQ==
X-Received: by 2002:a05:600c:4452:b0:40b:5e1e:fba3 with SMTP id v18-20020a05600c445200b0040b5e1efba3mr2071997wmn.88.1701715738124;
        Mon, 04 Dec 2023 10:48:58 -0800 (PST)
Received: from [192.168.8.100] ([85.255.232.94])
        by smtp.gmail.com with ESMTPSA id je18-20020a05600c1f9200b003feea62440bsm16296061wmb.43.2023.12.04.10.48.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Dec 2023 10:48:57 -0800 (PST)
Message-ID: <dc8ab9c2-164b-4346-8720-443c9b9660f5@gmail.com>
Date: Mon, 4 Dec 2023 18:45:51 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] iouring: one capable call per iouring instance
To: Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@meta.com>,
 linux-nvme@lists.infradead.org, io-uring@vger.kernel.org
Cc: hch@lst.de, sagi@grimberg.me, Keith Busch <kbusch@kernel.org>
References: <20231204175342.3418422-1-kbusch@meta.com>
 <a387fd6a-7d4c-49e0-bb89-be129b10781c@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <a387fd6a-7d4c-49e0-bb89-be129b10781c@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/4/23 18:05, Jens Axboe wrote:
> On 12/4/23 10:53 AM, Keith Busch wrote:
>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>> index 1d254f2c997de..4aa10b64f539e 100644
>> --- a/io_uring/io_uring.c
>> +++ b/io_uring/io_uring.c
>> @@ -3980,6 +3980,7 @@ static __cold int io_uring_create(unsigned entries, struct io_uring_params *p,
>>   		ctx->syscall_iopoll = 1;
>>   
>>   	ctx->compat = in_compat_syscall();
>> +	ctx->sys_admin = capable(CAP_SYS_ADMIN);
>>   	if (!ns_capable_noaudit(&init_user_ns, CAP_IPC_LOCK))
>>   		ctx->user = get_uid(current_user());
> 
> Hmm, what happens if the app starts as eg root for initialization
> purposes and drops caps after? That would have previously have caused
> passthrough to fail, but now it will work. Perhaps this is fine, after
> all this isn't unusual for eg opening device or doing other init special
> work?

The side effects would be quite a surprise when you initialize the ring
from a privileged process and then pass it to a less capable one. Ring
sharing would also be affected. Privilege downgrade also sounds like
a valid concern. The first two will be solved if restricted to
IORING_SETUP_DEFER_TASKRUN rings and

io_is_capable() {
	return ctx->sys_admin || capable();
}

And it still doesn't seem great bypassing it, when the question is
rather why it's expensive? I've seen before in the wild a fat BPF
program running on every call, is that what happens?

> In any case, that should definitely be explicitly mentioned in the
> commit message for a change like that.
> 

-- 
Pavel Begunkov

