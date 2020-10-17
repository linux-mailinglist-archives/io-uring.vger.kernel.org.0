Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC81C291295
	for <lists+io-uring@lfdr.de>; Sat, 17 Oct 2020 17:02:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438461AbgJQPCM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 17 Oct 2020 11:02:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2438449AbgJQPCL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 17 Oct 2020 11:02:11 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A86DC061755
        for <io-uring@vger.kernel.org>; Sat, 17 Oct 2020 08:02:11 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id g29so3236511pgl.2
        for <io-uring@vger.kernel.org>; Sat, 17 Oct 2020 08:02:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3Av728nHUNWDB99Z9R2oPXgfeSaWAqr1kGKqCSrROkg=;
        b=l3DQGcmChwuutZXYo7hRJRTj652AaI25WSApAF4SR9zbf6NzjCsieQPaXMG3STe/ZL
         yhFv6RGW+omQOGF+/cXP6FAK/ZTu6097t6tcaAeGBCmo9MW3FLArj7kILhrq1LJtAQ4D
         UzCHwyN6mqig60fNBaygRFX9M9pQToLNuNAvwMiDAvfGQO6r8N0ToNGY80VUNzFeVrgJ
         rFKuU3GeYaccI+q99RGb1cmXmHhsIG7c3uj8wRodTA4hGX9fuUosx+cBCB4yo7kMZZ+C
         YSf2RONP6BAZoYnCvuhCRhpOn88jD1AQDYGsxPPFdwBmM5Tm1LgCwvmQ+FavlbLBHZM8
         YcsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3Av728nHUNWDB99Z9R2oPXgfeSaWAqr1kGKqCSrROkg=;
        b=s7XO58q3MfDtdG3oa2O7s6FvTdgMccPOfSxv+yTemrWJFdoACK2N9WxZ027T6svQIj
         WHl7XDwAtlPsMlr0EFDP8YJlBywEUdTaXxQ5YgTyiYMMh/59wLUyNE6/I20vjtWINwJu
         BHz1XNw/v8jfohwu8zjSw/SIEvEsENTk9JymdPvuqNN/rH/VKjz2H/5eK6tHTrOnr1Ge
         YMqdR9XKZ1TQl/mYHXXI3pw+EEzydiBt5g45wDBr2gyfiSAfJEo22YTQf3sCtCpzKyzg
         tNrS2/bwLt4gYx1KZhnlEfVjpwWDF0JmoiWB8ZgwhDLAErUKuZXz+n4/DfSLGXM2fHyS
         XYZQ==
X-Gm-Message-State: AOAM530WbqR6r3Hl4xg8aCdNzOabscPDSpSGLVL4OzUZJDUry5CKPpLp
        RNKeXFIsvYWjsLj2aRTtK5uOwiHBUrbgxZ3H
X-Google-Smtp-Source: ABdhPJyB6FbdNCnvkLijCDVBbwjGC+a0NwA6qlBeytGY5+f2CyXS0uMfYrWKL12OwEg86LRKbnJLyA==
X-Received: by 2002:a63:380d:: with SMTP id f13mr7612106pga.105.1602946930766;
        Sat, 17 Oct 2020 08:02:10 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id y80sm6298017pfb.144.2020.10.17.08.02.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 17 Oct 2020 08:02:10 -0700 (PDT)
Subject: Re: io_uring possibly the culprit for qemu hang (linux-5.4.y)
To:     Ju Hyung Park <qkrwngud825@gmail.com>
Cc:     Stefano Garzarella <sgarzare@redhat.com>, io-uring@vger.kernel.org,
        qemu-devel@nongnu.org
References: <CAD14+f3G2f4QEK+AQaEjAG4syUOK-9bDagXa8D=RxdFWdoi5fQ@mail.gmail.com>
 <20201001085900.ms5ix2zyoid7v3ra@steredhat>
 <CAD14+f1m8Xk-VC1nyMh-X4BfWJgObb74_nExhO0VO3ezh_G2jA@mail.gmail.com>
 <20201002073457.jzkmefo5c65zlka7@steredhat>
 <CAD14+f0h4Vp=bsgpByTmaOU-Vbz6nnShDHg=0MSg4WO5ZyO=vA@mail.gmail.com>
 <05afcc49-5076-1368-3cc7-99abcf44847a@kernel.dk>
 <CAD14+f0h-r7o=m0NvHxjCgKaQe24_MDupcDdSOu05PhXp8B1-w@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <7ea53adb-14c7-8c31-2f9e-44a3847ee91c@kernel.dk>
Date:   Sat, 17 Oct 2020 09:02:09 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAD14+f0h-r7o=m0NvHxjCgKaQe24_MDupcDdSOu05PhXp8B1-w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/17/20 8:29 AM, Ju Hyung Park wrote:
> Hi Jens.
> 
> On Sat, Oct 17, 2020 at 3:07 AM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> Would be great if you could try 5.4.71 and see if that helps for your
>> issue.
>>
> 
> Oh wow, yeah it did fix the issue.
> 
> I'm able to reliably turn off and start the VM multiple times in a row.
> Double checked by confirming QEMU is dynamically linked to liburing.so.1.
> 
> Looks like those 4 io_uring fixes helped.

Awesome, thanks for testing!

-- 
Jens Axboe

