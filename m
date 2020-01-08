Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49144134FF7
	for <lists+io-uring@lfdr.de>; Thu,  9 Jan 2020 00:22:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727171AbgAHXWH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Jan 2020 18:22:07 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:39057 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726548AbgAHXWH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Jan 2020 18:22:07 -0500
Received: by mail-pj1-f67.google.com with SMTP id m1so272994pjv.4
        for <io-uring@vger.kernel.org>; Wed, 08 Jan 2020 15:22:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=idTV0a+8MiH1OisXB3/9lsN87GoZDMzj7s8vYjk0Mjs=;
        b=MJOgQw8vNdXb9aeyHaR1lyLfnCFttJmVvY52x1PdX/aPOyckhatEVd5INDIB0fOn2z
         CgCUEmqCrDfdMyu39k5np4TrAs1gCrm68GQ6XZpiDaAt+iratGAuaNbFOHYIXYrmlviR
         8DMI0PBRPFjodVPoju6mo3fBlu60aEDLBsgOezHjCcwO5C6nnRQHFVG9qZnT/dplEBeg
         +sTjS9qMUcYjc+l9Ni4qcDuR9BGy1vSdeDeVLtJWwbx6eUBfwSc9iwHJqwaoScsc97El
         T6vE1hhVpBHCfaevsT7rO+xkjQhTS5o/Q0+g2RzmxSU4cSJBnTnd+HF1zLDHMG+PkGxH
         9d5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=idTV0a+8MiH1OisXB3/9lsN87GoZDMzj7s8vYjk0Mjs=;
        b=dEDos8JHcOPd0OYGj+47BA8a/hyztVsTGFjxK4S4IZsP2zc1MhGFO0+Pnlw9iRjgy0
         cRMcgUnXiXX8lpWR7a5xq8nUtyOvxM2MRMeK0EJBHABF+tKE9+n0zs7we2I1gaR84dXp
         csJSkRq1aMBPfigO0z3YuAny/ol0dIutYAsjWCiKI6tlKO/tCcDaugKMYKeigW/cf8dv
         GhEJjMbTCXuXMeZ+NFB8ppn3enzvj3JCj/+yipOqugfc68I5XHyiBwBqKtCEHI1E3q6e
         c016PdHyRVS/EMZKF5HYMVRMitfrM8JtvHn9WOKQ6clTVQGKM1Dp6xoLSe86dmcw+1uQ
         ypPA==
X-Gm-Message-State: APjAAAXHtb3dTZWSJndxCYNAMZPbiJb96waXKhG+MAWLBPuq68dGxx+K
        tCnFO4rA5JjYEHRMP72SAsloyg==
X-Google-Smtp-Source: APXvYqwarFjYLTE++qOfxi3ZiTtcpNfA30knau5d/vurvLMjiSbZMTF/UX9Rs4FeuU0rZlGJy++vVA==
X-Received: by 2002:a17:902:ff07:: with SMTP id f7mr8235000plj.12.1578525726107;
        Wed, 08 Jan 2020 15:22:06 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id y38sm4798536pgk.33.2020.01.08.15.22.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jan 2020 15:22:05 -0800 (PST)
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
 <0b8a0f70-c2de-1b1c-28d4-5c578a3534eb@kernel.dk>
 <d42d5abd-c87b-1d97-00f3-95460a81c527@samba.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <7c97ddec-24b9-c88d-da7e-89aa161f1634@kernel.dk>
Date:   Wed, 8 Jan 2020 16:22:04 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <d42d5abd-c87b-1d97-00f3-95460a81c527@samba.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/8/20 4:11 PM, Stefan Metzmacher wrote:
> Am 09.01.20 um 00:05 schrieb Jens Axboe:
>> On 1/8/20 4:03 PM, Stefan Metzmacher wrote:
>>> Am 08.01.20 um 23:53 schrieb Jens Axboe:
>>>> On 1/8/20 10:04 AM, Stefan Metzmacher wrote:
>>>>> Am 08.01.20 um 17:40 schrieb Jens Axboe:
>>>>>> On 1/8/20 9:32 AM, Stefan Metzmacher wrote:
>>>>>>> Am 08.01.20 um 17:20 schrieb Jens Axboe:
>>>>>>>> On 1/8/20 6:05 AM, Stefan Metzmacher wrote:
>>>>>>>>> Hi Jens,
>>>>>>>>>
>>>>>>>>>> This works just like openat(2), except it can be performed async. For
>>>>>>>>>> the normal case of a non-blocking path lookup this will complete
>>>>>>>>>> inline. If we have to do IO to perform the open, it'll be done from
>>>>>>>>>> async context.
>>>>>>>>>
>>>>>>>>> Did you already thought about the credentials being used for the async
>>>>>>>>> open? The application could call setuid() and similar calls to change
>>>>>>>>> the credentials of the userspace process/threads. In order for
>>>>>>>>> applications like samba to use this async openat, it would be required
>>>>>>>>> to specify the credentials for each open, as we have to multiplex
>>>>>>>>> requests from multiple user sessions in one process.
>>>>>>>>>
>>>>>>>>> This applies to non-fd based syscall. Also for an async connect
>>>>>>>>> to a unix domain socket.
>>>>>>>>>
>>>>>>>>> Do you have comments on this?
>>>>>>>>
>>>>>>>> The open works like any of the other commands, it inherits the
>>>>>>>> credentials that the ring was setup with. Same with the memory context,
>>>>>>>> file table, etc. There's currently no way to have multiple personalities
>>>>>>>> within a single ring.
>>>>>>>
>>>>>>> Ah, it's user = get_uid(current_user()); and ctx->user = user in
>>>>>>> io_uring_create(), right?
>>>>>>
>>>>>> That's just for the accounting, it's the:
>>>>>>
>>>>>> ctx->creds = get_current_cred();
>>>>>
>>>>> Ok, I just looked at an old checkout.
>>>>>
>>>>> In kernel-dk-block/for-5.6/io_uring-vfs I see this only used in
>>>>> the async processing. Does a non-blocking openat also use ctx->creds?
>>>>
>>>> There's basically two sets here - one set is in the ring, and the other
>>>> is the identity that the async thread (briefly) assumes if we have to go
>>>> async. Right now they are the same thing, and hence we don't need to
>>>> play any tricks off the system call submitting SQEs to assume any other
>>>> identity than the one we have.
>>>
>>> I see two cases using it io_sq_thread() and
>>> io_wq_create()->io_worker_handle_work() call override_creds().
>>>
>>> But aren't non-blocking syscall executed in the context of the thread
>>> calling io_uring_enter()->io_submit_sqes()?
>>> In only see some magic around ctx->sqo_mm for that case, but ctx->creds
>>> doesn't seem to be used in that case. And my design would require that.
>>
>> For now, the sq thread (which is used if you use IORING_SETUP_SQPOLL)
>> currently requires fixed files, so it can't be used with open at the
>> moment anyway. But if/when enabled, it'll assume the same credentials
>> as the async context and syscall path.
> 
> I'm sorry, but I'm still unsure we're talking about the same thing
> (or maybe I'm missing some basics here).
> 
> My understanding of the io_uring_enter() is that it will execute as much
> non-blocking calls as it can without switching to any other kernel thread.

Correct, any SQE that we can do without switching, we will.

> And my fear is that openat will use get_current_cred() instead of
> ctx->creds.

OK, I think I follow your concern. So you'd like to setup the rings from
a _different_ user, and then later on use it for submission for SQEs that
a specific user. So sort of the same as our initial discussion, except
the mapping would be static. The difference being that you might setup
the ring from a different user than the user that would be submitting IO
on it?

If so, then we do need something to support that, probably an
IORING_REGISTER_CREDS or similar. This would allow you to replace the
creds you currently have in ctx->creds with whatever new one.

> I'm I missing something?

I think we're talking about the same thing, just different views of it :-)

-- 
Jens Axboe

