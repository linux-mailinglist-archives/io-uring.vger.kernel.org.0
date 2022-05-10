Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4A56520CA4
	for <lists+io-uring@lfdr.de>; Tue, 10 May 2022 06:21:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236177AbiEJEZJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 10 May 2022 00:25:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236322AbiEJEXp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 10 May 2022 00:23:45 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76B7A1D077F
        for <io-uring@vger.kernel.org>; Mon,  9 May 2022 21:18:03 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id v10so13644860pgl.11
        for <io-uring@vger.kernel.org>; Mon, 09 May 2022 21:18:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:to:cc:references
         :from:in-reply-to:content-transfer-encoding;
        bh=QI/wpd53jr3RGo0zcvZblNB9lKFoTtCuaXGtdCSbxdc=;
        b=l+j0GVcaD/NXxm5x95K3SN3YqX7izl/pkNTc6MnOAYqz1vXIhTrSdUSdy/bc5agmyI
         v6tT1cLyhtIlS51S8pXZ8Nd38QIfPSEYO7Y2a2g0hgd08oKFG1/26OZI9z+iMq328zlm
         2lW6lqndBQVKJ6F1itcYLbFP3233fIkIRQTYk8JRZREeeQ8jhjIpFAQ//aj/rwBJjVxd
         vyR61TqoXEcXH9jfcM5yjVBpLSp5VLaVYHKPFF4vl0dXYeK38EyrcHQGEEyK75DgQtdJ
         IiFJGpeYOlft4IJ4UAsoizbpwOGfuV414kB88E5DQk3/k3S5VsY8l0goKTD0zHKoR1fF
         7DoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :to:cc:references:from:in-reply-to:content-transfer-encoding;
        bh=QI/wpd53jr3RGo0zcvZblNB9lKFoTtCuaXGtdCSbxdc=;
        b=2pSLeFmcQn8YPdF6to8bb0Ev5GyQ9gHpRuN0tHGaFdu2xvoSzJsttUYqvk1yz5Kr9E
         e143Aec2DyJYe6hsGJrA/ofH7ML/cS0OBPK7ZypW95lhQHXzZYgvtm4cbulzKpXCWEnC
         dH4lxEl99G83nNXZ3iTubcB/Thu+qqC/Ble/KQ+QzJZfQ8Npvc3HG4y3mOh3l2DwPpTU
         kDCX0Gbzt7EStJpSYgcz4z/HnX673qngtysJZQw5CT8Uqqzv1ofZo+ATZjoEXgFrP4Is
         aUHoUDdd3uBzBlE3qmgshR34sR2HxjNVnI+Lr8I0/E5naDybjHJ5fRDMK/TsksXqHiEw
         T7Tg==
X-Gm-Message-State: AOAM531/eNXuqFNohZGGeFkxTWfQuaKBRTuBNcL6Gbrh2I1dUEzuJkdR
        EiS42GUQpwJZQqkQavcmmQA=
X-Google-Smtp-Source: ABdhPJwcr/+PKqJhK0Mf29mX/9hO/ooWa95iuaewsRj6/oB08VvA0+NGFmMaHtrL+F1oZy/mfWMsow==
X-Received: by 2002:a65:6055:0:b0:3c6:adfd:5135 with SMTP id a21-20020a656055000000b003c6adfd5135mr7699863pgp.146.1652156283000;
        Mon, 09 May 2022 21:18:03 -0700 (PDT)
Received: from [192.168.255.10] ([106.53.33.166])
        by smtp.gmail.com with ESMTPSA id d28-20020a634f1c000000b003c260491adesm9299764pgb.82.2022.05.09.21.18.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 May 2022 21:18:02 -0700 (PDT)
Message-ID: <45b7718f-df75-ef5b-f9c9-17bdb0caeb57@gmail.com>
Date:   Tue, 10 May 2022 12:18:14 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Subject: Re: [PATCH v5 0/4] fast poll multishot mode
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>
References: <SG2PR01MB241138EDCD004D6C19374E80FFC79@SG2PR01MB2411.apcprd01.prod.exchangelabs.com>
 <SG2PR01MB241141296FA6C3B5551EA2BBFFC79@SG2PR01MB2411.apcprd01.prod.exchangelabs.com>
 <e43d206b-1fdf-556b-4667-c2572709c18f@kernel.dk>
 <c3eabd1b-c68a-498a-8dac-73bb51a7a654@kernel.dk>
From:   Hao Xu <haoxu.linux@gmail.com>
In-Reply-To: <c3eabd1b-c68a-498a-8dac-73bb51a7a654@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2022/5/10 上午11:22, Jens Axboe 写道:
> On 5/9/22 9:15 PM, Jens Axboe wrote:
>> On 5/8/22 9:43 AM, Hao Xu wrote:
>>> Sorry for polluting the list, not sure why the cover-letter isn't
>>> wired with the other patches..
>>
>> Yeah not sure what's going on, but at least they are making it

It turns out that the outlook SMTP server changed the message-id and
thus messed up the thread linkchain..

>> through... Maybe we should base this on the
>> for-5.19/io_uring-alloc-fixed branch? The last patch needs to be updated
>> for that anyway. I'd think the only sane check there now is if it's a
>> multishot direct accept request, then the request must also specify
>> IORING_FILE_INDEX_ALLOC to ensure that we allocate descriptors.
> 
> Oh, and I'm assuming you added some comprehensive tests for this for
> liburing? Both functionally, but also checking the cases that should
> fail (like mshot + fixed without alloc, etc). When you send out the
> next/final version, would be great if you could do a the same for the
> liburing side.

Sure, I'll rebase it with the comments and also post liburing tests in
the next version

Regards,
Hao

> 

