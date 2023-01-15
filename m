Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02ACF66B224
	for <lists+io-uring@lfdr.de>; Sun, 15 Jan 2023 16:37:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231214AbjAOPhB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 15 Jan 2023 10:37:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231179AbjAOPg7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 15 Jan 2023 10:36:59 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1206A59D6
        for <io-uring@vger.kernel.org>; Sun, 15 Jan 2023 07:36:58 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id a184so19324093pfa.9
        for <io-uring@vger.kernel.org>; Sun, 15 Jan 2023 07:36:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hSeDyeso2x3KnbABBN+qliwkXZgHdFO+9/OlByRvPcY=;
        b=lg+xV8niy3GaeMcaouAyFfuf/lHxhns1lf+BXAG3xAGrrlICJYj+1yyu1uztOtdMTB
         Kze4nx60HpjeWolvQDkT8+pIwVKTEqKH6PIqQjcnkfdw8fQPwz7r8J4AFzd7vCoxsI80
         ThuLoLbo6bIi1cx0lzp8j4pHQO3FD69436ep0xf5X0h8P6I2M6iSGtx8Z6VsE/BhVfBh
         ypHQGUpp5IvUp2cXxdodr35eLV1rnvCq1cdL8OqtUmuL44Osno3u8VEurg6EjtW60y9J
         Qih0z/AZ4MD2rOJV+8QOAif3JsLtd7LZCiTEXw3/Mq9Y8mbPjZ32VGg4GSfNxvMjI+RS
         aHgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hSeDyeso2x3KnbABBN+qliwkXZgHdFO+9/OlByRvPcY=;
        b=U2zzAx2U0/GmdnnZWBqfKTZf37Hd3Mns9sEnPSbj3ilJ6psGSQXtlAwfYhrE+uwk0/
         /ydaDxIR67RgkmBM218kbIbhtsGZudML6DARiVsLiltHKF22R4wxSAlerlp96pHE+U8w
         ZOsxAz+yY2gQQ+y8LDSx/FVCXtNUMsbIMCAH+IYRGuHae2dPrFFub0J1AhCPduBR85JU
         s+WIB31AtbVOQhYqDZz6Wn51ELfuz2KTdXFM6m8A2ZK1EzKZOpy9X+HEBhrZdCRQkCtI
         eWSiCTrZye/HKXAn6NEEq7kfnqX2rpQIfkOkAI7qGKybDVuK+U6PBchPLO5BPdoqxG7I
         ByWg==
X-Gm-Message-State: AFqh2krOuRqXZ+iEZWjqyxRQbDj3woeTE45SrqRqio0WLoBZOu2KAVFC
        1+a6LHHbkK0MB9Q3nrDMp99U7ZcUQMCHm5H9
X-Google-Smtp-Source: AMrXdXsVLLjgQMwplIN6DALg7AI63AFE0mm8VXb4b56vw56ulnGJlFeHzfFWswYgwNt5hG+qH6ibGw==
X-Received: by 2002:a62:1996:0:b0:582:d97d:debc with SMTP id 144-20020a621996000000b00582d97ddebcmr9398511pfz.3.1673797017468;
        Sun, 15 Jan 2023 07:36:57 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id i6-20020aa796e6000000b005884d68d54fsm13012850pfq.1.2023.01.15.07.36.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 15 Jan 2023 07:36:56 -0800 (PST)
Message-ID: <ecfa3acb-44d7-e0a5-903e-0607ca134c3d@kernel.dk>
Date:   Sun, 15 Jan 2023 08:36:55 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [Report] Use-After-Free in io_wq_worker_running
Content-Language: en-US
To:     Homin Rhee <hominlab@gmail.com>, io-uring@vger.kernel.org
References: <CAA2QpBfokQQ=eX=Ek4f4-cft25cRkqALZZB6B=VYYmfUKk5Mzg@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAA2QpBfokQQ=eX=Ek4f4-cft25cRkqALZZB6B=VYYmfUKk5Mzg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/15/23 6:19 AM, Homin Rhee wrote:
> Hello,
> I'm iCAROS7 and my syzkaller hit follow KASAN bug via UAF.
> 
> Target kernel commit: 0bf913e07b37
> Target arch: amd64
> Host syzkaller version: 96166539c4c242fccd41c7316b7080377dca428b
> Host CPU: Intel i7 12700K
> Host OS: Kubuntu 22.04.1 LTS (5.18.19-051819-generic)

This is a duplicate, see the mailing list. But in any case, it's
fixed as of:

commit e6db6f9398dadcbc06318a133d4c44a2d3844e61
Author: Jens Axboe <axboe@kernel.dk>
Date:   Sun Jan 8 10:39:17 2023 -0700

    io_uring/io-wq: only free worker if it was allocated for creation

caused by a buggy commit that went into 6.2-rc3.

-- 
Jens Axboe


