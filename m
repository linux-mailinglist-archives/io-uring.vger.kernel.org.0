Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51E136E3395
	for <lists+io-uring@lfdr.de>; Sat, 15 Apr 2023 22:37:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230097AbjDOUhR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 15 Apr 2023 16:37:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230046AbjDOUhQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 15 Apr 2023 16:37:16 -0400
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7736D3C16
        for <io-uring@vger.kernel.org>; Sat, 15 Apr 2023 13:37:13 -0700 (PDT)
Received: by mail-qt1-x82b.google.com with SMTP id d75a77b69052e-3e699254ac4so8628171cf.1
        for <io-uring@vger.kernel.org>; Sat, 15 Apr 2023 13:37:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1681591033; x=1684183033;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CgoGJGsT7i6ONOXxE463YKRFYAfc7X0lyHmSADzo+9Q=;
        b=Xo+eoW4hd84WD57ppZ5RApHDRfCnTtmWIEXo5U6D8ikCRBd8iy22ylwlXxbuBwUT1d
         MOPfSiZ9V0klOjnnjBuSEeOvohFY/NxTq473varbWX9slI5bbb5wBK3PnztMhZZtIC40
         J7osij7hIVDlhHECkivSzOxML/9dE5g+niHihk+/mf5PNr4MePCpUTLBJ/dcMibyuMKM
         nu9kSUhvJzQN4eHXjdRmd9U8DxtjrozKOm2UAgg7G6IgjwQ7wXZ2JbO4aXHjuv9yfaPb
         tSDt20EaOvYj4/o418/3piqP1LHjArhdRNXbcApbZm/BMJZrj+BEWCDFMyOJTjaGmNs0
         Dbww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681591033; x=1684183033;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CgoGJGsT7i6ONOXxE463YKRFYAfc7X0lyHmSADzo+9Q=;
        b=ZDizCXgUQwkxK6oFnu+CHPrwq+W8iJBj6ytqMhRiZc32MP5bDWftBPxLgZYXKm3GZY
         /zL76gOTVMSzvocxo3xEVOis4gbGBqt+mRe9XCG6J4ZYK+TFGB3vSNfBmICfCxV8VQNi
         c2hIlrdW9bywnZkDJll9rSdzFchz+B0F8bg8ZFDpe8/tbKQknYE94wl+1GEcQQeQsCQK
         RTeq7BjySHehZxASrJkt4A6nuqq73Ugst6PIVu8HxdKK3RYta2sts9e2VqVeg94q0H8K
         H11oHZVJ7qa6OdWR/uosbHrnWRoC6dsLFSEMf3TxNvWTvYp09l4ncTRT3UVxE8y7xZ0B
         lTvA==
X-Gm-Message-State: AAQBX9fgzPeJglgElpQOGYuPgfx44l625ZEf4OUfjYcyOJUPJ6eHoS7M
        NqkF+dq2MiB3SxId21Q9sPIxFw==
X-Google-Smtp-Source: AKy350Y4x7t5bMpKUjDxVIqbpneRiWcCDvPi8FK2yZr8KOUAnkXDYRkYqSHbIMO+YEUM+YMEGfxQ4Q==
X-Received: by 2002:a05:6214:3011:b0:5ef:5132:7ad7 with SMTP id ke17-20020a056214301100b005ef51327ad7mr9923548qvb.2.1681591033046;
        Sat, 15 Apr 2023 13:37:13 -0700 (PDT)
Received: from [172.19.131.144] ([216.250.210.6])
        by smtp.gmail.com with ESMTPSA id dw17-20020a0562140a1100b005eb28315286sm1973468qvb.113.2023.04.15.13.37.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 15 Apr 2023 13:37:12 -0700 (PDT)
Message-ID: <2a102115-6b2c-9078-848f-6d25022a1244@kernel.dk>
Date:   Sat, 15 Apr 2023 14:37:07 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH liburing 0/3] io_uring-udp fix, manpage fix, and hppa
 cross-compiler
Content-Language: en-US
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
References: <20230415165904.791841-1-ammarfaizi2@gnuweeb.org>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230415165904.791841-1-ammarfaizi2@gnuweeb.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/15/23 10:59 AM, Ammar Faizi wrote:
> Hi Jens,
> 
> There are three patches in this series:
> 
> 1. Fix the wrong IPv6 address in io_uring-udp (me).
> 
> Before:
> 
>     port bound to 49567
>     received 4 bytes 28 from ::2400:6180:0:d1:0:0:47048
>     received 4 bytes 28 from ::2400:6180:0:d1:0:0:54755
>     received 4 bytes 28 from ::2400:6180:0:d1:0:0:57968
> 
> (the IPv6 address is wrong)
> 
> After:
> 
>     port bound to 48033
>     received 4 bytes 28 from [2400:6180:0:d1::6a4:a00f]:40456
>     received 4 bytes 28 from [2400:6180:0:d1::6a4:a00f]:50306
>     received 4 bytes 28 from [2400:6180:0:d1::6a4:a00f]:52291
> 
> 2. io_uring_cqe_get_data() manpage fix (me).
> 
> The return value of io_uring_cqe_get_data() will be undefined if the
> user_data is not set from the SQE side.
> 
> 3. Add hppa cross-compiler to the CI (Alviro).

Applied, thanks.

-- 
Jens Axboe


