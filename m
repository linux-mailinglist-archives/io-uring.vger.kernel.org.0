Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F50D4C2DEA
	for <lists+io-uring@lfdr.de>; Thu, 24 Feb 2022 15:10:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235347AbiBXOKI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Feb 2022 09:10:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235345AbiBXOKH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Feb 2022 09:10:07 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAE7C294FD8
        for <io-uring@vger.kernel.org>; Thu, 24 Feb 2022 06:09:37 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id z16so1973209pfh.3
        for <io-uring@vger.kernel.org>; Thu, 24 Feb 2022 06:09:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=6uSFcRh977j3Bx1kfIX4+3EiqN8hp8dYbzHtQZYbcWo=;
        b=e81G07Ud62mTHBJnnC8XZU/Id/rMiALndqwWL16+doY/o59esVzq00tuAEgLF4MICT
         KgWCIsHE+O6o9vJaVH10uCghOOZaJpUI2+Yk4YdVnATmHoGSN9DhlN01s/Oq296HFQug
         WgHgT/2nBB3xdfVGlNf69Ya7jAaRn9lE7EydORdvp7CrFIJHURseaNVhFe/9ijOkKbCE
         iMUyB6do8HUJGaEmGq2jYV3h+PvSLV88Ajxhn05HvQBd3WE9n8SMW5K5DnGudvCAyhuX
         NWtWyT5eBpvVMykzykskqPQYoV3dW5HJgBAL//uQ9I4/u+Eog5PyhQlEMNInebqwgqp8
         /7+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=6uSFcRh977j3Bx1kfIX4+3EiqN8hp8dYbzHtQZYbcWo=;
        b=F4vJIOL1lLV4V/MjZyjA/Aq9eH/LyHznnw+YEhgPJYHQuwqDWJrj6LFL0wEvNhtQHz
         Bx008ITdWP61PwIAKlAVkZ4W4xrqjBaSVlOHZV0Fxrb6a9WYu4Id6XRlRKQKpTF4CC+H
         mJL5FHpeYE6+M5VI/8GrgbM6lP1FUvPntp31yQyPDIZaYtLUbNl95krhH9CeHLX0eEEy
         9M4IHI3oj3rycpXr1iZvWQr0F9n/WomBxLdg1M3CfGA9YXvVrgaY9ejZUBid+SsLwrBt
         /pCMtc4EEC8S00m28V0U+tEP5gniG7FEX02E2YvwAZGJRbiJJkPivr95ljZllFvH2HF2
         BJmg==
X-Gm-Message-State: AOAM532QKU+jT2L+qqvw0sMxG0kdx3x5Mrg1Gx1Gy8mwo81ZnfXwrNtj
        bMo+DR625lKRkZLv6vqkNSERPzCTla3mtg==
X-Google-Smtp-Source: ABdhPJwjPDDk2FHV1wINHa1ePjVwAGPVazkdZ22NM9OiLpQjOnoIJKdVtVm5n4Nqht+w3V4cYAc/ow==
X-Received: by 2002:a05:6a00:1a09:b0:4e1:67a7:2c87 with SMTP id g9-20020a056a001a0900b004e167a72c87mr3141217pfv.37.1645711777421;
        Thu, 24 Feb 2022 06:09:37 -0800 (PST)
Received: from [192.168.4.155] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id gz13-20020a17090b0ecd00b001bc5defa657sm6491531pjb.11.2022.02.24.06.09.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Feb 2022 06:09:36 -0800 (PST)
Message-ID: <a906fc93-1295-f27c-b96a-32571039bf92@kernel.dk>
Date:   Thu, 24 Feb 2022 07:09:35 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH v3 0/2] io-uring: Make statx api stable
Content-Language: en-US
To:     Marek Szyprowski <m.szyprowski@samsung.com>, kernel-team@fb.com,
        Stefan Roesch <shr@fb.com>, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Cc:     viro@zeniv.linux.org.uk
References: <20220215180328.2320199-1-shr@fb.com>
 <164555550976.110748.6933069169641927964.b4-ty@kernel.dk>
 <CGME20220224124715eucas1p2a7d1b7f2a5131ef1dd5b8280c1d3749b@eucas1p2.samsung.com>
 <5e0084b9-0090-c2a6-ab64-58fd1887d95f@samsung.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <5e0084b9-0090-c2a6-ab64-58fd1887d95f@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/24/22 5:47 AM, Marek Szyprowski wrote:
> Hi,
> 
> On 22.02.2022 19:45, Jens Axboe wrote:
>> On Tue, 15 Feb 2022 10:03:26 -0800, Stefan Roesch wrote:
>>> One of the key architectual tenets of io-uring is to keep the
>>> parameters for io-uring stable. After the call has been submitted,
>>> its value can be changed.  Unfortunaltely this is not the case for
>>> the current statx implementation.
>>>
>>> Patches:
>>>   Patch 1: fs: replace const char* parameter in vfs_statx and do_statx with
>>>            struct filename
>>>     Create filename object outside of do_statx and vfs_statx, so io-uring
>>>     can create the filename object during the prepare phase
>>>
>>> [...]
>> Applied, thanks!
>>
>> [1/2] fs: replace const char* parameter in vfs_statx and do_statx with struct filename
>>        commit: 30512d54fae354a2359a740b75a1451b68aa3807
>> [2/2] io-uring: Copy path name during prepare stage for statx
>>        commit: 1e0561928e3ab5018615403a2a1293e1e44ee03e
> 
> Those 2 commits landed in todays Linux next-20220223. They affect 
> userspace in a way that breaks systemd opration:
> 
> ...
> 
> Freeing unused kernel image (initmem) memory: 1024K
> Run /sbin/init as init process
> systemd[1]: System time before build time, advancing clock.
> systemd[1]: Cannot be run in a chroot() environment.
> systemd[1]: Freezing execution.
> 
> Reverting them on top of next-20220223 fixes the boot issue. Btw, those 
> patches are not bisectable. The code at 
> 30512d54fae354a2359a740b75a1451b68aa3807 doesn't compile.

Thanks, I'll drop them from for-next until we figure out what that is.

-- 
Jens Axboe

