Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2A523AA034
	for <lists+io-uring@lfdr.de>; Wed, 16 Jun 2021 17:44:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235507AbhFPPqa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Jun 2021 11:46:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235898AbhFPPo2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Jun 2021 11:44:28 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A08FEC06175F;
        Wed, 16 Jun 2021 08:38:04 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id c9so3201738wrt.5;
        Wed, 16 Jun 2021 08:38:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=GoxvotL3Me0AkkYlw0Ff9VWdCGCouBv8obyOROpBU3s=;
        b=JIHONi71Nj48KGtkEH/NRy6iWWByc6oMka1xJsStJInEQUoJ+mZUfmOhZL9L6/tjru
         RC1la52iSscfXcUHtOSBwWZPk6C/xcjpZadLT1ckoZU3pFhWr3GYFImkYBpUAy/9Wmn7
         TcHPTWaSrFmflG6GpolFXsbO/rFiiZFUbvIbbv+lodYA0vjCcDfpxjIMneHHdYE6UmvN
         IpC8cuTQcS1ppiZ1Xpuw+7xee9B0UN29FLOfFpledRhRZcpAb8Y9AuJEcHcg+gl6+EpB
         KREvwdWPrYKpvokS6lDbIKLjOb7xP8kIcfbKMuvG/Rsz4UYxZpm+wY0PUvgZcdoQrFfi
         wQWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GoxvotL3Me0AkkYlw0Ff9VWdCGCouBv8obyOROpBU3s=;
        b=YxcXXrAE0Dhifl7aO1MarbGijpawIRGXfzQvIoNMqq23IxKwcWQ+Xqoh0K1qpDYuli
         jeAHKnl/NOcNUGr7WWJl1v0Y7qSwlugjTA7D4ab/g+sRZvyabybI6vtUEUgfr4+W1Emm
         Vp+3thOQP8RKgd9aAl4HCId5nWpRegIfTWJj47JATShAr3u2W8PXAzvnrl9Bl6QO+5eM
         1lpQcDM8zS/SOb2A/VSR8+IqNwnFVeiG6kv2FR6Cji1qLiW0YqCPlruy+LhXJNOMGDeb
         FZvI3BHYqT6dZSkqcFmgaUA5SzFlkf8lT7VucPHWuxggwCAaTQXffutNQ9Px85qmL57/
         vslQ==
X-Gm-Message-State: AOAM530b/HWDJHJL1heLMsfk5nLLFf9nDAwLEA1A8S5ASGouSzpYoaXX
        jiCUpGgBG4BSzphu6FC8Af4Qz1Gl9PjsTg==
X-Google-Smtp-Source: ABdhPJx6yVfVZhC+1oyewsTvPSR+P9ygTHsXeC440287WrAeJnM3a3SkbitHn8/gFroWNlS5EgZ8fQ==
X-Received: by 2002:a5d:6e04:: with SMTP id h4mr25575wrz.256.1623857883112;
        Wed, 16 Jun 2021 08:38:03 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.128.74])
        by smtp.gmail.com with ESMTPSA id c20sm2098396wml.37.2021.06.16.08.38.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Jun 2021 08:38:02 -0700 (PDT)
Subject: Re: [PATCH] io_uring: store back buffer in case of failure
To:     Jens Axboe <axboe@kernel.dk>,
        Olivier Langlois <olivier@trillion01.com>,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <60c83c12.1c69fb81.e3bea.0806SMTPIN_ADDED_MISSING@mx.google.com>
 <93256513-08d8-5b15-aa98-c1e83af60b54@gmail.com>
 <b5b37477-985e-54da-fc34-4de389112365@kernel.dk>
 <4f32f06306eac4dd7780ed28c06815e3d15b43ad.camel@trillion01.com>
 <af2f7aa0-271f-ba70-8c6b-f6c6118e6f1f@gmail.com>
 <6bf916b4-ba6f-c401-9e8b-341f9a7b88f7@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <5007a641-23cf-195d-87ee-de193e19dc20@gmail.com>
Date:   Wed, 16 Jun 2021 16:37:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <6bf916b4-ba6f-c401-9e8b-341f9a7b88f7@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/16/21 3:44 PM, Jens Axboe wrote:
> On 6/16/21 8:01 AM, Pavel Begunkov wrote:
>> On 6/16/21 2:42 PM, Olivier Langlois wrote:
>>> On Tue, 2021-06-15 at 15:51 -0600, Jens Axboe wrote:
>>>> Ditto for this one, don't see it in my email nor on the list.
>>>>
>>> I can resend you a private copy of this one but as Pavel pointed out,
>>> it contains fatal flaws.
>>>
>>> So unless someone can tell me that the idea is interesting and has
>>> potential and can give me some a hint or 2 about how to address the
>>> challenges to fix the current flaws, it is pretty much a show stopper
>>> to me and I think that I am going to let it go...
>>
>> It'd need to go through some other context, e.g. task context.
>> task_work_add() + custom handler would work, either buf-select
>> synchronisation can be reworked, but both would rather be
>> bulky and not great.
> 
> Indeed - that'd solve both the passing around of locking state which
> I really don't like, and make it much simpler. Just use task work for
> the re-insert, and you can grab the ring lock unconditionally from
> there.

Hmm, it might be much simpler than I thought if we allocate
a separate struct callback_head, i.e. task_work, queued it
with exactly task_work_add() but not io_req_task_work_add(),
and continue with the request handler. 

-- 
Pavel Begunkov
