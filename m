Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 227473E50D0
	for <lists+io-uring@lfdr.de>; Tue, 10 Aug 2021 04:01:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237279AbhHJCBu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 Aug 2021 22:01:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236645AbhHJCBu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 Aug 2021 22:01:50 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44950C0613D3
        for <io-uring@vger.kernel.org>; Mon,  9 Aug 2021 19:01:29 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id cp15-20020a17090afb8fb029017891959dcbso2044660pjb.2
        for <io-uring@vger.kernel.org>; Mon, 09 Aug 2021 19:01:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=wl7jDsMyaFwUVp7mnXcRceLAh1ErSd2NLNar+fihO0c=;
        b=cVsOekaDxfrHTGyhwCgOLDUXxnkx1NudUSmTxd+B6n0NETrktILTHw/kdJKJ1JoQkG
         HbZI1DAwwDjhse3b2iGF8AhPfY3RaG7HvPlnYpsLLlAY26WYe1G8Czzy2GxJfyYOrXK5
         2DXTcuKCEn7iwAr7atVRz8+FOcKRwC/Fpwjoai930R1aynpj+4k24Lbi/sXNBtHbqIY6
         gHsAmTSfLYa8gR8rgmB3L0R+M4A7wHkehGPBbLLmxYPRRrfmtAEUOXOtUuyZZNF0R/gd
         1WTF5Nw7wjbp/1gMGmMYsjy6kIA8vTQYzBqRXHCQNw+4b/pcVY8dE4uPKKcPoOv55pg6
         /wFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wl7jDsMyaFwUVp7mnXcRceLAh1ErSd2NLNar+fihO0c=;
        b=NVTrfLfoA1ss8H92LAJu+pu/m0xeCfWOnrWeAj2N1TW9gCO2iwBDzFuFPA4VmB9eaV
         4ejXdCgfECYbXLDjyU9NJYKvtv4+J9Chh7X4oq3DzT40MtfDxdQzgwMnUKRz3HsuSoRb
         kPmdAOiOdFAX24mdqphlrGG51QujKADgJmQhQuB4HynExEndpghJ83nY6RCawJTz//bh
         SFgRpAVZ5KIAlQp259MfFm214iYR3pajhNhL1zDDcerhYk60yrmPbREt+1zsplej9dJl
         od6nRifrfS7o9p8CPdrhuI2uZb3GkJQCn17Hqd166SO6/QnKi5Ltb9eqMjUWpiKpVOwV
         UODw==
X-Gm-Message-State: AOAM532+V21f0CeyTW9mwvP1/xZccXfmYk3SDAYicRVTMBpolyK8fCY8
        AqOJIJiQhjs6JCX0ZCuuOFCsafP55Keo8FZ/
X-Google-Smtp-Source: ABdhPJzKcskHNsoikES0CL0jgUfk63tix4xokFruj/N9mGT5IW393PB7A+MKQp00MdMNwcWqJ/WOkA==
X-Received: by 2002:aa7:8159:0:b029:3bb:9880:d8e8 with SMTP id d25-20020aa781590000b02903bb9880d8e8mr26661346pfn.3.1628560888538;
        Mon, 09 Aug 2021 19:01:28 -0700 (PDT)
Received: from [192.168.1.116] ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id 143sm21818721pfz.13.2021.08.09.19.01.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Aug 2021 19:01:28 -0700 (PDT)
Subject: Re: [PATCH 5.14] io_uring: fix ctx-exit io_rsrc_put_work() deadlock
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <0130c5c2693468173ec1afab714e0885d2c9c363.1628559783.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <63aed671-97d8-9de3-586a-69dc47ffac76@kernel.dk>
Date:   Mon, 9 Aug 2021 20:01:26 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <0130c5c2693468173ec1afab714e0885d2c9c363.1628559783.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/9/21 7:44 PM, Pavel Begunkov wrote:
> __io_rsrc_put_work() might need ->uring_lock, so nobody should wait for
> rsrc nodes holding the mutex. However, that's exactly what
> io_ring_ctx_free() does with io_wait_rsrc_data().
> 
> Split it into rsrc wait + dealloc, and move the first one out of the
> lock.

Applied, thanks.

-- 
Jens Axboe

