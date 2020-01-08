Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBCDC134FC3
	for <lists+io-uring@lfdr.de>; Thu,  9 Jan 2020 00:06:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727387AbgAHXGC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Jan 2020 18:06:02 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:37966 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726548AbgAHXGC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Jan 2020 18:06:02 -0500
Received: by mail-pj1-f65.google.com with SMTP id l35so260190pje.3
        for <io-uring@vger.kernel.org>; Wed, 08 Jan 2020 15:06:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=y71wpJlCiToTGr7euD0QtQPbSSe7nZB0k6rUFx/PuqQ=;
        b=DXsn7Mp6w/hrPymIx+PxWHMmmJkAtFdVo8ic7sBLYTkKN/ceI0kanFsQOfLyX/GuT5
         Go5pJWt4qqEG+d1VPM3jvi2ML4HWaiTjcPoLWOFkk+IA3aSmgwU8z690/my6N1m2PrE+
         T1UpX4FmFcEhNSXguPjPGG4f5J1lz6wJq9ImZymZJvuiQX2THmQCUu/hQLsuhU/n/Toe
         wXGn2rt3zJksALVVw1wFVJP2WZEwWLWaVWToMWa+Il7xBVeE7/tr1PpL1EcLDMAJSqXn
         sFTp2G5fBdT6+7JlJMh5xq2Hh59OUbsk1Aw042N/ahYiY54bYi/aKjvJ7oGRUpnsBOMX
         9kGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=y71wpJlCiToTGr7euD0QtQPbSSe7nZB0k6rUFx/PuqQ=;
        b=dF2IJ82T03XZ5dgBkANirlPnQujUoCW9ASBqRXJ/VHPLGZfyERNXNzoIf1RxBmaGSz
         C+OZYxc1SmnDBGNo5rHoA8cOGTZVdUVoO8BHn1AM1Z0i3ea1k8Glhv/OhKk/X8wEFoVa
         Om59OL0LkwewmTyuxEXNVBH9pbN0GwWuP6+vyYVNmiGIp/CZFCeX3uVuev4XBCYmLTIC
         k91Rj6AVKL8+dkl8oAbQAacfTS1uqcDSMfG9hqocWMkTqRoA2UFD5abGx3b9OuFDwkuq
         dvdSgdrhjwujKgPYfia2yfobM/vLXZCBuNVXKI75v5C2ZmiyLdBvVTv7TTi/+7vHVGKC
         hL9g==
X-Gm-Message-State: APjAAAXJg+cjlgyvpGxzLpWHWj5BCcj2XKpm8UYAxCm3CwNyIxjQV+vV
        P3GTH2z6MrgcJE4f4eKZ6nJ9hg==
X-Google-Smtp-Source: APXvYqxD9zqM9kFRsvGOETS+fYAURcAHh/FcpaMPs7BuaiSGfyAxxZyN8uWWGKBBqV8vEyc0vKBa+Q==
X-Received: by 2002:a17:902:59d8:: with SMTP id d24mr7694685plj.318.1578524761186;
        Wed, 08 Jan 2020 15:06:01 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id n4sm4588476pgg.88.2020.01.08.15.06.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jan 2020 15:06:00 -0800 (PST)
Subject: Re: [PATCH 3/6] io_uring: add support for IORING_OP_OPENAT
To:     Stefan Metzmacher <metze@samba.org>, io-uring@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk
References: <20200107170034.16165-1-axboe@kernel.dk>
 <20200107170034.16165-4-axboe@kernel.dk>
 <82a015c4-f5b9-7c85-7d80-78964cb0d82e@samba.org>
 <4ccb935c-7ff9-592f-8c27-0af3d38326d7@kernel.dk>
 <2afdd5a5-0eb5-8fba-58d1-03001abbab7e@samba.org>
 <9672da37-bf6f-ce2d-403c-5e2692c67782@kernel.dk>
 <d0f0e726-8e6f-aa43-07b6-fdb3b49ce1bc@samba.org>
 <d5a5dc20-7e11-8489-b9d5-c2cf8a4bdf4b@kernel.dk>
 <a0f1b3a0-9827-b3e1-da0c-a2b71151fd4e@samba.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <0b8a0f70-c2de-1b1c-28d4-5c578a3534eb@kernel.dk>
Date:   Wed, 8 Jan 2020 16:05:59 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <a0f1b3a0-9827-b3e1-da0c-a2b71151fd4e@samba.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/8/20 4:03 PM, Stefan Metzmacher wrote:
> Am 08.01.20 um 23:53 schrieb Jens Axboe:
>> On 1/8/20 10:04 AM, Stefan Metzmacher wrote:
>>> Am 08.01.20 um 17:40 schrieb Jens Axboe:
>>>> On 1/8/20 9:32 AM, Stefan Metzmacher wrote:
>>>>> Am 08.01.20 um 17:20 schrieb Jens Axboe:
>>>>>> On 1/8/20 6:05 AM, Stefan Metzmacher wrote:
>>>>>>> Hi Jens,
>>>>>>>
>>>>>>>> This works just like openat(2), except it can be performed async. For
>>>>>>>> the normal case of a non-blocking path lookup this will complete
>>>>>>>> inline. If we have to do IO to perform the open, it'll be done from
>>>>>>>> async context.
>>>>>>>
>>>>>>> Did you already thought about the credentials being used for the async
>>>>>>> open? The application could call setuid() and similar calls to change
>>>>>>> the credentials of the userspace process/threads. In order for
>>>>>>> applications like samba to use this async openat, it would be required
>>>>>>> to specify the credentials for each open, as we have to multiplex
>>>>>>> requests from multiple user sessions in one process.
>>>>>>>
>>>>>>> This applies to non-fd based syscall. Also for an async connect
>>>>>>> to a unix domain socket.
>>>>>>>
>>>>>>> Do you have comments on this?
>>>>>>
>>>>>> The open works like any of the other commands, it inherits the
>>>>>> credentials that the ring was setup with. Same with the memory context,
>>>>>> file table, etc. There's currently no way to have multiple personalities
>>>>>> within a single ring.
>>>>>
>>>>> Ah, it's user = get_uid(current_user()); and ctx->user = user in
>>>>> io_uring_create(), right?
>>>>
>>>> That's just for the accounting, it's the:
>>>>
>>>> ctx->creds = get_current_cred();
>>>
>>> Ok, I just looked at an old checkout.
>>>
>>> In kernel-dk-block/for-5.6/io_uring-vfs I see this only used in
>>> the async processing. Does a non-blocking openat also use ctx->creds?
>>
>> There's basically two sets here - one set is in the ring, and the other
>> is the identity that the async thread (briefly) assumes if we have to go
>> async. Right now they are the same thing, and hence we don't need to
>> play any tricks off the system call submitting SQEs to assume any other
>> identity than the one we have.
> 
> I see two cases using it io_sq_thread() and
> io_wq_create()->io_worker_handle_work() call override_creds().
> 
> But aren't non-blocking syscall executed in the context of the thread
> calling io_uring_enter()->io_submit_sqes()?
> In only see some magic around ctx->sqo_mm for that case, but ctx->creds
> doesn't seem to be used in that case. And my design would require that.

For now, the sq thread (which is used if you use IORING_SETUP_SQPOLL)
currently requires fixed files, so it can't be used with open at the
moment anyway. But if/when enabled, it'll assume the same credentials
as the async context and syscall path.

-- 
Jens Axboe

