Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 980DD54B1DD
	for <lists+io-uring@lfdr.de>; Tue, 14 Jun 2022 15:01:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231790AbiFNNBg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Jun 2022 09:01:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235202AbiFNNBg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Jun 2022 09:01:36 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A21F133E96
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 06:01:35 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id h19so7965582wrc.12
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 06:01:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=rL4/6j7vIV/LO9/2ckxdbqOHqwbSjp1EZ3UVPFJs5iU=;
        b=B5/88R7LDJklni7Ibak2UjYh3YfAbAlD/2jJJClLhUkb4SyZc/QrSz6yIOK+FX1ebt
         kN+qllI3YIWncrzJzVlm6IRUOtPPulY/kJ3hHbZL2dLiEIDqNFq4xMRGEcjdSpliHEH5
         2Uxt0SLmcWzkPiT2QV4Em/i/Yfl+TOKUDOn6ciLjjesTPTAtHQ27A7FJCPvyd5QEfktW
         b3kVix6d2Z5nubfQz4XoxbNzbhCPRTAqX1TBAEy8LU+UCkzs2JEb6aqWpnFIEjBVffQ4
         TpgbAlLj9aomxCjSdHtL5kRlRaapQIBiYd/bxgHukY6kRFysgexuY8QzzVBUSCpvtyve
         LC2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=rL4/6j7vIV/LO9/2ckxdbqOHqwbSjp1EZ3UVPFJs5iU=;
        b=EQ8PHrKk+pkUAZvKQkutdNXXlV7V/hd9sJJr0oxdXJASqBsy5iVQuwuc6Y4GlVW3CL
         jOa9CHoTU5qHKasAlNIvu9G0JfZXsEF6nPAMzG/WxLLf3VCeHY5qIfNyJ/p6H5EohQg9
         uPTByp0ZXmbFVuCexjbUdNKJBzoaXJ6zCA0dhDBosFJw9C3TM51R7QebRzs2upuPAnm4
         HFQ5EuxMIDiDkxYSscvuNsuNlt+ELfHVkEXs2g0G6eFY50c1a1h3sXDDXnMGOJkiLTnJ
         15pHENpD22zrQCAVozFCBKWTWDp/W3xCUrXi5pZPVXs+NR8BUtODj5BxE9iSIRUGGM4R
         Z5Ng==
X-Gm-Message-State: AJIora8osBuSwHccfU/trPvN0yZ53FrzIHi9KRZAxWw75F1fqGWK1Vxa
        0rhAz1FmH0BITEFp1CemxxmA2AD6mG2ZRA==
X-Google-Smtp-Source: AGRyM1v00fux140K0GE0u7kv9ahuSGxqjUNiz75IXecawrMkrAUHVic2lL6Q9OVDRZMknLkqIQSpwQ==
X-Received: by 2002:adf:d1ca:0:b0:218:47c0:c4d2 with SMTP id b10-20020adfd1ca000000b0021847c0c4d2mr4821586wrd.639.1655211694288;
        Tue, 14 Jun 2022 06:01:34 -0700 (PDT)
Received: from [192.168.8.198] (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id q14-20020adfea0e000000b00213ba4b5d94sm14153239wrm.27.2022.06.14.06.01.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jun 2022 06:01:33 -0700 (PDT)
Message-ID: <ad097aeb-d0f4-04df-c64f-3d6c69a71a0b@gmail.com>
Date:   Tue, 14 Jun 2022 14:01:07 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH for-next 05/25] io_uring: move cancel_seq out of io-wq
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1655209709.git.asml.silence@gmail.com>
 <e25a399d960ee8b6b44e53d46968e1075a86f77e.1655209709.git.asml.silence@gmail.com>
 <33f6f7cc-b685-704d-dfc6-f8a1c0b89855@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <33f6f7cc-b685-704d-dfc6-f8a1c0b89855@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/14/22 13:52, Jens Axboe wrote:
> On 6/14/22 6:29 AM, Pavel Begunkov wrote:
>> io-wq doesn't use ->cancel_seq, it's only important to io_uring and
>> should be stored there.
> 
> It isn't there because it's io-wq only, but to save space. This adds 8
> bytes to io_kiocb, as far as I can tell?

Ah ok, makes sense. It's worth a comment though

-- 
Pavel Begunkov
