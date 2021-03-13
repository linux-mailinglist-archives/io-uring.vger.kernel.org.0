Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30A9133A028
	for <lists+io-uring@lfdr.de>; Sat, 13 Mar 2021 20:02:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234366AbhCMTCE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 13 Mar 2021 14:02:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234329AbhCMTBk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 13 Mar 2021 14:01:40 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EF10C061574
        for <io-uring@vger.kernel.org>; Sat, 13 Mar 2021 11:01:40 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id p21so17980118pgl.12
        for <io-uring@vger.kernel.org>; Sat, 13 Mar 2021 11:01:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=etzd6dSAv6JKKsXGvImaRac1XGuniQs79OggVru5qtE=;
        b=TYBByVIr2Yp0uLh/BmLur0bOqOH+1nnzzXDuAX5zv7rk+VmdZqzb2ErkUp2Ly5A1Gd
         icBouGuyNgQOu/u4IrShxS6+FracQPQi4Q7YHN3DBtFYJoKo334svRR0GYSU5tS+ThXC
         SqbGhpfPRT+TJ7pGDg/4+hZ5FQ2VpOSjQ8vwrr4Cx8j0PSX3ulkmxYIVcfWaubJKJ2tg
         rg5sXPvudXvMC64KqwTFbgEgWj7kxcSlZmCZeMt7BL909pnMaCxYN2xSDtfHmRo3Y3w7
         Ey6LKxeDVs0ty2JV9O0XxBn2/yr0OJjfIF8P6H6fF0nlZNqjlX2nLuA6J1rDoYzcrH3K
         z1tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=etzd6dSAv6JKKsXGvImaRac1XGuniQs79OggVru5qtE=;
        b=K/oMe+cJfcVu0x3PTLM1jJzVsq0paBRSUp3+lnG+wpml/iov2hhqE5ZGNyyDKNMgdE
         CfPVPcKnDFkNL+Va/vKZw5D1057sfHU90da+9YjiHVgEt1tzkWNLjXH0iHphcnz93nXV
         m3IcfhYH4yM7FkmJqT2Z3sq9qdzUdS5m+nVCDxeLkxE5i4xlhSix6lnsyQw6dQRnhFbo
         uMRh2qqeCFgaEhUzsYFcPeR/EoXTFXJMITBhqgj9vlMuqIoFwZbykU08ze/UfC1rY4ec
         uWYLJV7Ei7gzRCgrv+DH7Ben3XHt0qbEYeR8uSaQMDNB+sWpgy+lmcvx4dPDzwoMzO7w
         pLzg==
X-Gm-Message-State: AOAM532grgLtlZpHDVUz9pO1xxyYRmR7eOmo4Hi1yY4cPxcetFeyxtrD
        W4DZ97cvZel1nhrdkUI/cMCgjA==
X-Google-Smtp-Source: ABdhPJxcs/GHYrNUDwdboHTnrHREIyvPSwd3/Ts3NFBdJ6l/4J/dAi1WGXbJR/rT3w0vAwsi8LCGvQ==
X-Received: by 2002:a63:5a02:: with SMTP id o2mr16549036pgb.202.1615662099518;
        Sat, 13 Mar 2021 11:01:39 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id y9sm6058997pja.50.2021.03.13.11.01.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 13 Mar 2021 11:01:38 -0800 (PST)
Subject: Re: [PATCH 5.12] io_uring: Convert personality_idr to XArray
From:   Jens Axboe <axboe@kernel.dk>
To:     yangerkun <yangerkun@huawei.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org
Cc:     Matthew Wilcox <willy@infradead.org>,
        Stefan Metzmacher <metze@samba.org>, yi.zhang@huawei.com
References: <7ccff36e1375f2b0ebf73d957f037b43becc0dde.1615212806.git.asml.silence@gmail.com>
 <803bad80-093a-5fbf-7677-754c9afad530@gmail.com>
 <8b553635-b3d9-cb36-34f0-83777bec94ab@huawei.com>
 <81464ae1-cac4-df4c-cd0e-1d518461d4c3@huawei.com>
 <7a905382-8598-f351-8a5b-423d7246200a@kernel.dk>
Message-ID: <e6c9ed79-827b-7a45-3ad8-9ba5a21d5780@kernel.dk>
Date:   Sat, 13 Mar 2021 12:01:39 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <7a905382-8598-f351-8a5b-423d7246200a@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/13/21 8:34 AM, Jens Axboe wrote:
> On 3/13/21 1:02 AM, yangerkun wrote:
>>
>>
>> 在 2021/3/9 19:23, yangerkun 写道:
>>>
>>>
>>> 在 2021/3/8 22:22, Pavel Begunkov 写道:
>>>> On 08/03/2021 14:16, Pavel Begunkov wrote:
>>>>> From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
>>>>>
>>>>> You can't call idr_remove() from within a idr_for_each() callback,
>>>>> but you can call xa_erase() from an xa_for_each() loop, so switch the
>>>>> entire personality_idr from the IDR to the XArray.  This manifests as a
>>>>> use-after-free as idr_for_each() attempts to walk the rest of the node
>>>>> after removing the last entry from it.
>>>>
>>>> yangerkun, can you test it and similarly take care of buffer idr?
>>>
>>> Will try it latter :)
>>
>> Sorry for the latter reply. The patch pass the testcase.
>>
>> Besides, should we apply this patch first to deal with the same UAF for
>> io_buffer_idr before convert to XArray?
>>
>> https://lore.kernel.org/io-uring/20210308065903.2228332-2-yangerkun@huawei.com/T/#u
> 
> Agree, and then defer an xarray conversion to 5.13. I'll take a look at
> your patch and get it applied.

That one is very broken, it both fails removal cases and it's got leak
issues too.

I'm going to take a look at just doing xarray instead.

-- 
Jens Axboe

