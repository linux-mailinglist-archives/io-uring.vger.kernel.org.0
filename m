Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C216275B40D
	for <lists+io-uring@lfdr.de>; Thu, 20 Jul 2023 18:23:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230210AbjGTQXS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 Jul 2023 12:23:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230163AbjGTQXS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 20 Jul 2023 12:23:18 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EED8710F5
        for <io-uring@vger.kernel.org>; Thu, 20 Jul 2023 09:23:16 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id ca18e2360f4ac-7835bbeb6a0so13930739f.0
        for <io-uring@vger.kernel.org>; Thu, 20 Jul 2023 09:23:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1689870196; x=1690474996;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=01h/C7wcvnglqcp2+Y4wFuwEOEXYz28b6e83ee9UZT0=;
        b=T+R3DzbGeF1LHxJYpwWrOguv2gBlNwmjGTe7A5YRy+RlsRzGgLa5GYIVINScdjlLN8
         /zyrSNEVkJfBQMCYP6xpIm5BEoqV0vV+pDBs5L/zbp96jKN7rVOKRjssY5CSj389I6TH
         pH6UP8/ApF57hLVUWObPUaouReKdUagM4EvjyyIkJOZA4j1s5ngohif72qX6iZtkme5Q
         itXVqagnWPQV52IVlS6v7gsS9iq86rLW9OtCki5LigCKGtL2qdiMZz2N4BUizx2QkFWM
         +sKdg8RqHi/dVMoahMxjO1gTopas1WzOMwLcM/UtbdCihdqEz+ELNrF+bLI4uiAOVQ6I
         8aFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689870196; x=1690474996;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=01h/C7wcvnglqcp2+Y4wFuwEOEXYz28b6e83ee9UZT0=;
        b=UoXv6W9vp7QBDaBM9y7+dMtjND5WmHo9u1a6iHifsegJFpUXTAXWEsaEPrj/xt7/1c
         49q138xa38XgaFeDPtGVJLyrPR+MJbDIfcRduVSg5xFV+yyCGskYQjhq8gxXZrh+Xg58
         0kBXnH2hkqM88iI1JpS/1HdZLVUMNjW4ELuI8B5DDaEyZU/99Glg9LkkQlUFLdnHjdXW
         QMFBR2AOVozLoCQtiUWvBIYFRYGgm3ZGE3+TwYP/lx2TG/Cpz22JzerKcR7hkrWtjlPl
         FQ8Lg7+CNAInLr0Dg4Qw1taVhk3UuDVK+0qI6vxQ3HIVHAsN1lqJ0tcoHRCpkQ7w0w0z
         5j5w==
X-Gm-Message-State: ABy/qLZ3Pg0LVlmCIawokIBIfc97OtqbsLa/a5qLvxYlQrHICwGM/7IQ
        XFSpZoMUezo8bZ9PMzzUH9Ku1A==
X-Google-Smtp-Source: APBJJlF7uNkzL/Mo2yVV42143Pv5nU2RKhSzKpLzFVF43sLg3VzUMNQAIgv8JAVbN2vMoRtbDjHlmg==
X-Received: by 2002:a05:6e02:1d11:b0:345:8a74:761b with SMTP id i17-20020a056e021d1100b003458a74761bmr12595716ila.1.1689870195719;
        Thu, 20 Jul 2023 09:23:15 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id do17-20020a0566384c9100b0042b10d42c90sm394756jab.113.2023.07.20.09.23.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Jul 2023 09:23:15 -0700 (PDT)
Message-ID: <cc9fa4dd-0528-9668-4c6c-28c4ecc9fd5a@kernel.dk>
Date:   Thu, 20 Jul 2023 10:23:14 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 3/6] iomap: treat a write through cache the same as FUA
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>
Cc:     io-uring@vger.kernel.org, linux-xfs@vger.kernel.org,
        andres@anarazel.de, david@fromorbit.com
References: <20230719195417.1704513-1-axboe@kernel.dk>
 <20230719195417.1704513-4-axboe@kernel.dk> <20230720045459.GC1811@lst.de>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230720045459.GC1811@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/19/23 10:54?PM, Christoph Hellwig wrote:
> On Wed, Jul 19, 2023 at 01:54:14PM -0600, Jens Axboe wrote:
>> Whether we have a write back cache and are using FUA or don't have
>> a write back cache at all is the same situation. Treat them the same.
> 
> This looks correct, but I think the IOMAP_DIO_WRITE_FUA is rather
> misnamed now which could lead to confusion.  The comment in

It is - should I rename it to IOMAP_DIO_STABLE_WRITE or something like
that as part of this change?

> __iomap_dio_rw when checking the flag and clearing IOMAP_DIO_NEED_SYNC
> also needs a little update to talk about writethrough semantics and
> not just FUA now.

Will do.

-- 
Jens Axboe

