Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 600BF2DF60D
	for <lists+io-uring@lfdr.de>; Sun, 20 Dec 2020 17:15:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726896AbgLTQOz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 20 Dec 2020 11:14:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726772AbgLTQOz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 20 Dec 2020 11:14:55 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66391C0613CF
        for <io-uring@vger.kernel.org>; Sun, 20 Dec 2020 08:14:09 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id q4so4329915plr.7
        for <io-uring@vger.kernel.org>; Sun, 20 Dec 2020 08:14:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KuLV0/ZY673SHw3vEGicCEpu4HJPYivMzPMitS0rsyA=;
        b=Vq5HRW+dxfu48bj24L0Kvc9ailjZwrIg2dHmPth2SOSoLkQJY+YqpilNvKdzVfj0dh
         FPiMyKDbQTXLPuSaoG0rx2pkJWcEuM9FBhoZ+F9oWmaI6vIUHjMTRsE6HQqDe5n0SntT
         08s40+tKYXcV25iy628gqQ8uV/VxrNA7AKDGy8ZdXeXXz/WIAau7fqsHPiBvtKO+mO1g
         3cw8Xi9/adTgIXyeFWqcOtXbXyNwmAnV3ZD4xog8rdEyEpDPjuIc0HqQAy43KAm/fgg7
         V91EvINb8eRE8Dueu1+inwxfcX2LYAl7hBuD/GU4nsx0eKG38WKU4n5DaPXADmnBLN/h
         tYFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KuLV0/ZY673SHw3vEGicCEpu4HJPYivMzPMitS0rsyA=;
        b=Zn95kzSAJOARPBP8/6WyaVWt23g/rfhLCx9tZ5c2N+vWtJPz2wpI+LvcpOLjN7fzgE
         hCj47orRB9lmj45iwpaPz83YN8SKQMlwiZhxz8Q+2/FT1SIso992gO6upxXXIwqw2X9W
         jZQkVOWL7nRf5LFgbMWZ9KfRMcPvXglLSzrEYpZFbhh7yFeiIPm9V52Z1pZOJgspy32X
         FQFVm6Gl56FFrweapYHU5pPCEfNCzLc4ws0Bs0a/NVmT+lt+76nTn7B/ac88NiY0ChVb
         zz/BLoe/tRHC77Hyvhi34rNzcqkmNdkuxgcERxALeFi3n0rqHBf4NKZ5PMO1ePTHsSW3
         nqpg==
X-Gm-Message-State: AOAM533nhXGgW/GprTuIUuFoaEplXTKHLXzhlOMjP0FdOHiJyt/evF/h
        bJap42QMeO+YkyScX4WuI3pkDihSMh/mCA==
X-Google-Smtp-Source: ABdhPJzQXMWExCYz/IJcbPr75nRNeXvVVSh5ChNPcPwVD1Hes0dwnKF+1Ubtkp4FmVKgo28pOLb8rg==
X-Received: by 2002:a17:902:ac90:b029:da:fd0c:53ba with SMTP id h16-20020a170902ac90b02900dafd0c53bamr12726544plr.23.1608480848149;
        Sun, 20 Dec 2020 08:14:08 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id fw12sm13148487pjb.43.2020.12.20.08.14.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 20 Dec 2020 08:14:07 -0800 (PST)
Subject: Re: "Cannot allocate memory" on ring creation (not RLIMIT_MEMLOCK)
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Josef <josef.grieb@gmail.com>
Cc:     Norman Maurer <norman.maurer@googlemail.com>,
        Dmitry Kadashev <dkadashev@gmail.com>,
        io-uring <io-uring@vger.kernel.org>
References: <4dc9c74b-249d-117c-debf-4bb9e0df2988@kernel.dk>
 <2B352D6C-4CA2-4B09-8751-D7BB8159072D@googlemail.com>
 <d9205a43-ebd7-9412-afc6-71fdcf517a32@kernel.dk>
 <CAAss7+ps4xC785yMjXC6u8NiH9PCCQQoPiH+AhZT7nMX7Q_uEw@mail.gmail.com>
 <0fe708e2-086b-94a8-def4-e4ebd6e0b709@kernel.dk>
 <614f8422-3e0e-25b9-4cc2-4f1c07705ab0@kernel.dk>
 <986c85af-bb77-60d4-8739-49b662554157@gmail.com>
 <e88403ad-e272-2028-4d7a-789086e12d8b@kernel.dk>
 <df79018a-0926-093f-b112-3ed3756f6363@gmail.com>
 <CAAss7+peDoeEf8PL_REiU6s_wZ+Z=ZPMcWNdYt0i-C8jUwtc4Q@mail.gmail.com>
 <0fb27d06-af82-2e1b-f8c5-3a6712162178@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <ff816e37-ce0e-79c7-f9bf-9fa94d62484d@kernel.dk>
Date:   Sun, 20 Dec 2020 09:14:07 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <0fb27d06-af82-2e1b-f8c5-3a6712162178@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/20/20 6:00 AM, Pavel Begunkov wrote:
> On 20/12/2020 07:13, Josef wrote:
>>> Guys, do you share rings between processes? Explicitly like sending
>>> io_uring fd over a socket, or implicitly e.g. sharing fd tables
>>> (threads), or cloning with copying fd tables (and so taking a ref
>>> to a ring).
>>
>> no in netty we don't share ring between processes
>>
>>> In other words, if you kill all your io_uring applications, does it
>>> go back to normal?
>>
>> no at all, the io-wq worker thread is still running, I literally have
>> to restart the vm to go back to normal(as far as I know is not
>> possible to kill kernel threads right?)
>>
>>> Josef, can you test the patch below instead? Following Jens' idea it
>>> cancels more aggressively when a task is killed or exits. It's based
>>> on [1] but would probably apply fine to for-next.
>>
>> it works, I run several tests with eventfd read op async flag enabled,
>> thanks a lot :) you are awesome guys :)
> 
> Thanks for testing and confirming! Either we forgot something in
> io_ring_ctx_wait_and_kill() and it just can't cancel some requests,
> or we have a dependency that prevents release from happening.

Just a guess - Josef, is the eventfd for the ring fd itself?

BTW, the io_wq_cancel_all() in io_ring_ctx_wait_and_kill() needs to go.
We should just use targeted cancelation - that's cleaner, and the
cancel all will impact ATTACH_WQ as well. Separate thing to fix, though.

-- 
Jens Axboe

