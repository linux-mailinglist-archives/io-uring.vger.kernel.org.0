Return-Path: <io-uring+bounces-363-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 19AA0820767
	for <lists+io-uring@lfdr.de>; Sat, 30 Dec 2023 17:32:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C42B31F219F2
	for <lists+io-uring@lfdr.de>; Sat, 30 Dec 2023 16:32:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F57915E85;
	Sat, 30 Dec 2023 16:28:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="njIpK6EX"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A7BA15AF6;
	Sat, 30 Dec 2023 16:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-40d5d898162so25886805e9.3;
        Sat, 30 Dec 2023 08:28:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1703953734; x=1704558534; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4PJjJ5P2lmakK/ZCpJsmjyUxZS9P8Pqa9ckPYMHsh98=;
        b=njIpK6EX4WAvTD9sXchjT0Q12ITe15ln+pe4N1sJDh4F9rBsYOUsFWiIr6PX/vIECI
         eNG2ny8oYrBGYrWOqDHrU+NuY3WPnwVdvf9l2JDmHm52LqSucnoJwQvFiC9NXiYy/ESj
         RKm4zMHdV0FoA97TQHGUTpTwR0xNw++R5dF9qqDJttzcIyMmmMQYmuSK3zuxowJGO2F6
         Qa0TbsouMpoEJV3bXvEkwk2i0wBmt7Iqoy9HqEtEsIjEzxjpdY+ZG5sMFBWeL9ymOCAX
         +Gy1RLPtwvHnr6O8EwHU315OopjifJ+Aeha4SGMTzqs6othxBCuePkSMwv5tFnxs9rlt
         Qo3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703953734; x=1704558534;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4PJjJ5P2lmakK/ZCpJsmjyUxZS9P8Pqa9ckPYMHsh98=;
        b=DmistMR++75wNHFC8/0QPkkQ45drPS0jxkGI9GvEFPef7UP2aP/XBUV2G5uadp7tKh
         oOIz6fjZWiuDyFc70Xf6FRscFyyrURbenYhLKgbroX2UktsFn6a+/vwblJotQhgMh0zS
         nKMXBtnQJUlvoPleDbReXdV2MmOUJcDQQxHu7sloO9zgfIamjp9/jitHKPssBNJK96RO
         v36pinU8MS9je6G7CdPnso6N5D8bJwNGESRM/Z+WqBngSPOSbleXp6oIPngU6k17aQXe
         xgN5EQBfPXTtFwP500nZRZuittHARy5gJi7Qi2Bzp3AzNhxthljyeyDqCAEBa+4TqmgM
         00JQ==
X-Gm-Message-State: AOJu0Yyq2KxwB3M7J+1nFBC5vGUWHnfcoEN1RY8ruQCcUIwoZSIHfFpP
	tNlypOXY/DRR3nZGvnmRlp4=
X-Google-Smtp-Source: AGHT+IGcQKEXsZPFWWU+GHoaVIbz1+IkW4rvDfTElfSQJ0+HBgKHWuZERRpM0wdhbb4pcu/wWZ/9QQ==
X-Received: by 2002:a05:600c:4e09:b0:40d:7b1f:e424 with SMTP id b9-20020a05600c4e0900b0040d7b1fe424mr1547015wmq.20.1703953733611;
        Sat, 30 Dec 2023 08:28:53 -0800 (PST)
Received: from [192.168.8.100] ([148.252.133.126])
        by smtp.gmail.com with ESMTPSA id p2-20020a05600c1d8200b0040596352951sm43557299wms.5.2023.12.30.08.28.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 30 Dec 2023 08:28:53 -0800 (PST)
Message-ID: <7967c7a9-3d17-44de-a170-2b5354460126@gmail.com>
Date: Sat, 30 Dec 2023 16:27:17 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6] io_uring: Statistics of the true utilization of sq
 threads.
Content-Language: en-US
To: Jens Axboe <axboe@kernel.dk>, Xiaobing Li <xiaobing.li@samsung.com>
Cc: linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
 kun.dou@samsung.com, peiwei.li@samsung.com, joshi.k@samsung.com,
 kundan.kumar@samsung.com, wenwen.chen@samsung.com, ruyi.zhang@samsung.com,
 cliang01.li@samsung.com, xue01.he@samsung.com
References: <CGME20231225055252epcas5p43ae8016d329b160f688def7b4f9d4ddb@epcas5p4.samsung.com>
 <20231225054438.44581-1-xiaobing.li@samsung.com>
 <170360833542.1229482.7687326255574388809.b4-ty@kernel.dk>
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <170360833542.1229482.7687326255574388809.b4-ty@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/26/23 16:32, Jens Axboe wrote:
> 
> On Mon, 25 Dec 2023 13:44:38 +0800, Xiaobing Li wrote:
>> Count the running time and actual IO processing time of the sqpoll
>> thread, and output the statistical data to fdinfo.
>>
>> Variable description:
>> "work_time" in the code represents the sum of the jiffies of the sq
>> thread actually processing IO, that is, how many milliseconds it
>> actually takes to process IO. "total_time" represents the total time
>> that the sq thread has elapsed from the beginning of the loop to the
>> current time point, that is, how many milliseconds it has spent in
>> total.
>>
>> [...]
> 
> Applied, thanks!
> 
> [1/1] io_uring: Statistics of the true utilization of sq threads.
>        commit: 9f7e5872eca81d7341e3ec222ebdc202ff536655

I don't believe the patch is near complete, there are still
pending question that the author ignored (see replies to
prev revisions).

Why it uses jiffies instead of some task run time?
Consequently, why it's fine to account irq time and other
preemption? (hint, it's not)

Why it can't be done with userspace and/or bpf? Why
can't it be estimated by checking and tracking
IORING_SQ_NEED_WAKEUP in userspace?

What's the use case in particular? Considering that
one of the previous revisions was uapi-less, something
is really fishy here. Again, it's a procfs file nobody
but a few would want to parse to use the feature.

Why it just keeps aggregating stats for the whole
life time of the ring? If the workload changes,
that would either totally screw the stats or would make
it too inert to be useful. That's especially relevant
for long running (days) processes. There should be a
way to reset it so it starts counting anew.


I say the patch has to be removed until all that is
figured, but otherwise I'll just leave a NACK for
history.

-- 
Pavel Begunkov

