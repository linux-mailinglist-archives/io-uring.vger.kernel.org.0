Return-Path: <io-uring+bounces-5805-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C528BA0937D
	for <lists+io-uring@lfdr.de>; Fri, 10 Jan 2025 15:31:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 39A0A3AA494
	for <lists+io-uring@lfdr.de>; Fri, 10 Jan 2025 14:31:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35506210F75;
	Fri, 10 Jan 2025 14:31:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kEXlcmrV"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69A8A210F7B;
	Fri, 10 Jan 2025 14:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736519493; cv=none; b=cKPYEtaLe3GnHsdkSt6e7oMHrMwomQOrpu/s3mx/mpdC4Vpo9id/SOd5nGt7mvJypk5D2h88WMSE2883euTshst1aNy9NGB2dNOUMaroH3nzOunK0WbozlZp439t3pStdoYui4UbJnEICbQaGg1BUhK8boBwirVxI7L4CwyW9D4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736519493; c=relaxed/simple;
	bh=7KDfgT8ECTSyjzu0J0NRPudRsC3OMKAfw/9PrzyETUg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hG26gQCegs/LHDREMpI3OpKjyHtiDkgFmoOm5e+A0ejWLJuwb5KuW5T9VjnAnrFSuZGnrnmYGsgzn9kk/iRwd+lmAXawgwyGmdUuTFWiYzcgRyVviVJJ5ukFZwp5pjU3toNCysHIN36G3GDc7zqeqh4JnMiewMKsUGPlb80FS4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kEXlcmrV; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-5d3e6f6cf69so3368505a12.1;
        Fri, 10 Jan 2025 06:31:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736519490; x=1737124290; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=V5T0984aVBnJm2X38bTD7z3b7k5xy8zQXEN+fsfcuss=;
        b=kEXlcmrVsTydvDoIJvCmHoqjxOuzUWfPx5C7E7rVEV0zDeEsE2/1rU5Qv/DsFSUVo4
         UuIlOKEiInUDD943libty3IoXjCQ+qXh51dzVT4P5yIV6LzgwAH2hzmWw6D2f7kVixRi
         8Agi/DpkdGM+KeDe6n6aUVwhwhSjtuDGW64YwaiIja6l8BrDHMtkBiBh34wfxycFOK9i
         1Rho2AthCWppDVB8qjv5uU7vkS8CwNsC3dODRlyQMOThE7ZkItsjSoK60GGcvHK4Q0Oo
         vLOB1Y9Sc9Q5Dgj/bfohCnT/5/0/GBtENJJUfJ8s9igWnOjUjDhBoyZ7gAewaaPPX8Wi
         oLog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736519490; x=1737124290;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=V5T0984aVBnJm2X38bTD7z3b7k5xy8zQXEN+fsfcuss=;
        b=Cvbtzm/EmMrJyJOcQObtmcjeMk0vO8p5+VV8xmSElbaHZpmgk+Awnt+ZFlHMvGbxFA
         yDooTEiIQXGQkxyrJBSMKxytM4HfTUIwQnlshl1bliGZgoEPumjYTb/frk6Omrc/vCiQ
         MgzFi+HsAxBjBTrwpVJ11Q6MtKpCDWpQ7D4KSsEDINwXLqVPRombaOJIB73Om01hkVYX
         J5XAkvSmvT+WSCATQSuNMvu7v3BEmmbgOzt2AB2NXAI4gwzei1ix1iC1u8zrmm/T6nw7
         dJARH17dpN51z7SCA8U3cWwJzguS6b0/duxLuxVIcjifBC4ndAGfS3VFHV/Js3KqkgZ4
         1IRg==
X-Forwarded-Encrypted: i=1; AJvYcCXF80ffVjEL//qGsgc6fcxjgBDexdrVUro75jrIhqboXg8bVgmuCtEr4jb08apllK0Hbl5idjorDg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyucAuZcb2MAOHEHZceQM5XU9zdKgZ2yolSdNRIhmpavKuWT3h9
	YQFo8hGbSgMWk2YGmzmzmovp5/4jCtgudQ9Z8yJKw+Gks/jlGm45
X-Gm-Gg: ASbGncvtB2e9/DzR1OKAVLXtS1Wy9lA/k4Qo0nqGc4S6VYB4pae2rPc2WUcDm0kCh7f
	j2L00EMSCpe4fxXH84V3AL1aUuXsRGjHXhbPzrj9KkfAsQxwL1jYYjnJzTGWHpobMrZiMQ1ODxR
	O4tyGg88IxHx4QT11XkqN8tWczh93HsfzqAZaXacCQc3ivsZLeO7kSbsVuCCH1JSwgd9LSocofq
	BK8RmHm+wWNZuBk3H+yecu6CqaozKy65GnkT4axFkQMQKxFrGeoXy+b50QUiLhY04cs
X-Google-Smtp-Source: AGHT+IHyAIdwPyEoI3g4LpiWh/cbbRIM7y6OSnWyhUY/KKSqU72iclDx8uAG5kiN28DrBkEnUQfVIQ==
X-Received: by 2002:a05:6402:2349:b0:5d0:a80d:bce9 with SMTP id 4fb4d7f45d1cf-5d972e178d6mr9718452a12.20.1736519489355;
        Fri, 10 Jan 2025 06:31:29 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:325::46? ([2620:10d:c092:600::1:1552])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5d9900c440bsm1661931a12.26.2025.01.10.06.31.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Jan 2025 06:31:28 -0800 (PST)
Message-ID: <0bef178c-bb78-4afb-b144-fa2f733c173b@gmail.com>
Date: Fri, 10 Jan 2025 14:32:24 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [kernel?] KASAN: slab-use-after-free Read in
 thread_group_cputime
To: Jens Axboe <axboe@kernel.dk>, Dmitry Vyukov <dvyukov@google.com>,
 syzbot <syzbot+3d92cfcfa84070b0a470@syzkaller.appspotmail.com>,
 io-uring@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <678125df.050a0220.216c54.0011.GAE@google.com>
 <CACT4Y+YKGy5a=8=HgyX38To+1yME59n9r=1pJahRVvx_n6F-Bw@mail.gmail.com>
 <CAN-bNdcDs6aMS50Awc_tuUrtUe2-KA=5de1bT_uZbungNG0qHg@mail.gmail.com>
 <8bcf5df2-91b9-4675-8305-77aa7ad999c8@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <8bcf5df2-91b9-4675-8305-77aa7ad999c8@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/10/25 14:13, Jens Axboe wrote:
> On 1/10/25 7:13 AM, Pavel Begunkov wrote:
>> On 1/10/25 13:56, Dmitry Vyukov wrote:
>>> On Fri, 10 Jan 2025 at 14:51, syzbot
>>> <syzbot+3d92cfcfa84070b0a470@syzkaller.appspotmail.com> wrote:
...
>>> #syz set subsystems: io-uring
>>>
>>> +maintainers
>>
>> Thanks. It probably needs something like below.
>>
>> diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
>> index 6df5e649c413..5768e31e99b1 100644
>> --- a/io_uring/sqpoll.c
>> +++ b/io_uring/sqpoll.c
>> @@ -268,8 +268,12 @@ static int io_sq_thread(void *data)
>>          DEFINE_WAIT(wait);
>>
>>          /* offload context creation failed, just exit */
>> -       if (!current->io_uring)
>> +       if (!current->io_uring) {
>> +               mutex_lock(&sqd->lock);
>> +               sqd->thread = NULL;
>> +               mutex_unlock(&sqd->lock);
>>                  goto err_out;
>> +       }
>>
>>          snprintf(buf, sizeof(buf), "iou-sqp-%d", sqd->task_pid);
>>          set_task_comm(current, buf);
> 
> Indeed - can you send that out and I can include it in this weeks pull?

Done

-- 
Pavel Begunkov


