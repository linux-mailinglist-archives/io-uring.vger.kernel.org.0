Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B28F36FCBDD
	for <lists+io-uring@lfdr.de>; Tue,  9 May 2023 18:56:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232747AbjEIQ4C (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 9 May 2023 12:56:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234146AbjEIQz5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 9 May 2023 12:55:57 -0400
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59B405592
        for <io-uring@vger.kernel.org>; Tue,  9 May 2023 09:55:37 -0700 (PDT)
Received: by mail-il1-x133.google.com with SMTP id e9e14a558f8ab-3357ea1681fso493815ab.1
        for <io-uring@vger.kernel.org>; Tue, 09 May 2023 09:55:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1683651336; x=1686243336;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=M99v2oSk5Zw/R5pw6TMXoO8HTOcL3iX6x+QANsvXHn0=;
        b=nw42TFhjvS20Sm1KQRHjcqztVks5L+rL5PfFA4DM+VLRlkicZy/SMjm/+P35agvpJ6
         0fy9drliNrmfdxiK3ZETRU0VyppcgqItDAZnUWtT4ocuouF9HzIzERLOg1Rj4povaH5z
         b4TeGFHBVg9+tpZO3wG5XzPLEQ2eHrzPXAkl3P8jszyq6OATNNUf5bzKfJUo+Z1ve6Mn
         S6BqPUuM2UIKRW/Q2eUAboxUMrVObPGRAeOq7i6mzOODsH4CWgk7pWnvmNkzitcT6NAP
         HEdu6jB8crZpEEfwWYe5ifjMoNGd2vb/nPO530kpFXkllsmRdRjgn/IIwwImULoBVo4y
         gs4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683651336; x=1686243336;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=M99v2oSk5Zw/R5pw6TMXoO8HTOcL3iX6x+QANsvXHn0=;
        b=FzlpvcYAQ6F+MdHuBGdGVuOk7VY23QCxv8bKkfku3ZD+5ggEA8Xix1zAb7BZ6Fkb0h
         KDwGkpTHRowrv1VFRCGkePkqEDK+vJtkEfeja0WAXhWivBoOYyUiMMsFOZU+6snpxua+
         Bw3x+XC5VlujjvyxPuZVOvUTXYuYQmovb9gwUT0WKEe2nr0xOU6Ip4xWowznJG6Zpn1C
         bvEDJCaeRtZUQ3fsCLHBM/7ZU0lpZTgcjCiwGRw4Ys5fJmuYPygVMtSo58UUxedy+mBR
         w/x7J22hTAW8Gaqm25Fks4DRXk9hE2WPL7ROiX7jdzs0OYVcR1TV+CPoiiwyPmpQ30P1
         tyaQ==
X-Gm-Message-State: AC+VfDzsHAsSPiSNPFqw94fddt2zy0pNBfIfdudGZJ+b1y1As04u7CWm
        HV8fXkk1eHxlH5Si9tVDUSHtUQ==
X-Google-Smtp-Source: ACHHUZ45ERK48eSf4fRmxV6a4A56X4dx/bmDEP2oJ4KQZazCYhPAVEsq1amsvvs3C6mbOkKpuT8JLw==
X-Received: by 2002:a05:6e02:1d05:b0:331:1129:b8a9 with SMTP id i5-20020a056e021d0500b003311129b8a9mr7806137ila.1.1683651336617;
        Tue, 09 May 2023 09:55:36 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id y19-20020a056638229300b004166c24e30dsm2148946jas.32.2023.05.09.09.55.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 May 2023 09:55:35 -0700 (PDT)
Message-ID: <f3c4fce2-657c-2743-6d05-9af29b35fcbe@kernel.dk>
Date:   Tue, 9 May 2023 10:55:34 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [GIT PULL] Final io_uring updates for 6.4-rc1
Content-Language: en-US
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Chen-Yu Tsai <wenst@chromium.org>,
        io-uring <io-uring@vger.kernel.org>, linux-kernel@vger.kernel.org
References: <9b2e791d-aeba-a2c7-1877-797ff5c680a3@kernel.dk>
 <20230508031852.GA4029098@google.com>
 <fb84f054-517c-77d4-eb11-d3df61f53701@kernel.dk>
 <CAGXv+5GpeJ8hWt2Sc6L+4GB-ghA4vESobEaFGpo1_ZyPhOvW0g@mail.gmail.com>
 <6d6a494b-3c1a-2bf6-79e3-0ccc81166a67@kernel.dk>
 <CAHk-=wjspoBCSrwL2s=qof3GFnZ4BmMzFbCcEx3VpVP81zXwrg@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAHk-=wjspoBCSrwL2s=qof3GFnZ4BmMzFbCcEx3VpVP81zXwrg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/9/23 10:52?AM, Linus Torvalds wrote:
> On Tue, May 9, 2023 at 6:59?AM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> Oops yes, thanks for noticing. I'll correct that and add your tested-by.
> 
> .. this build problem isn't caught by Guenter's build testing, but can
> we please make sure that it's fixed in my tree by -rc2?
> 
> It would be lovely to have a release that doesn't end up having silly
> build problems pending for too long. Even if they might be unusual
> configs.

It's in my tree, it'll go your way before -rc2 for sure.

-- 
Jens Axboe

