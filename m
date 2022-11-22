Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 217E1633D27
	for <lists+io-uring@lfdr.de>; Tue, 22 Nov 2022 14:10:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229728AbiKVNKQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 22 Nov 2022 08:10:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232552AbiKVNKO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 22 Nov 2022 08:10:14 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5798D28D
        for <io-uring@vger.kernel.org>; Tue, 22 Nov 2022 05:10:04 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id 136so14071804pga.1
        for <io-uring@vger.kernel.org>; Tue, 22 Nov 2022 05:10:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=K7NSd52jhcj9KM1R6I6iIGUXZhVIq0rC03oQFrnBBnk=;
        b=s0URsty13QJUXRgxM/Jeje6MGIkxOZgnd4qRIJ/dGZnY51LUDXdqpYLU3nReAIN0qZ
         DlfDfpV3b+rbqVRKshvAhmOztg1uzLJvG+s3OgoMib+u5HcLsOI3W8/mYg/cfSkZvsOV
         hHvXZlYIIaEh0G7JqS62FokOH5TxBPTS1U6C9CmC5qlLaiWkuqUXsSC1qAvZtbjUskI/
         ZcRSYUhWI2KqpQ0efkaidCwQVhUqJRvQzc0CnJBjYaZYP8M1YS6N1Kx9jHcUwPxJYm9s
         x4Qk9d+cPN/2rTI9NWAuZxDOnGkBoAkS1J6FDK3VQRygXa9uRZmLMcuZW1eCUYcb5K0j
         Mafw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=K7NSd52jhcj9KM1R6I6iIGUXZhVIq0rC03oQFrnBBnk=;
        b=P3brl4oGzd/6zgqw2f2iYGN18wXnCWseDrHBSBEcAQRqZwH/r7SLWJIR95jrn7HV/U
         9x4hCzYgnU+gGFPH4luXKFBDMIw1qfxprhyiOTZtL6YVSJTkI0W8AXAoE3qrSh1ZBvSn
         7rlejEKz2mW79r8V/uYduxfLCzwzXg2qIND1KYG7+47y5UIHCqif7xrw+8vHW05NYkzG
         JI7MsBjoAhywgbt6EUqwizZvu2MRW9GYtapWnPvIKdx1riRY0Y2Vu9FVc78q40pZyz0F
         dVKSuLLZYW6OF62Dxj3AXdYSK0wFFhdCXklj8EXQ+GtG6NQ0pTwwUIJzfUwLBw7vVqbK
         JTBA==
X-Gm-Message-State: ANoB5pk6QvwzmRUOpjLIZbGypV0JgbugwFQW9vGSiANSXDERS607XqBs
        j/WHF64Thp/MCiae3kDLIloN9A==
X-Google-Smtp-Source: AA0mqf4/nG1BmTO0Tfggtb9gK7OHAug72DigugH9Gm+ePUUMq3nFYtdoLtVgXQNncGe9TH5o20SV6w==
X-Received: by 2002:a63:d556:0:b0:435:7957:559d with SMTP id v22-20020a63d556000000b004357957559dmr11161458pgi.122.1669122603647;
        Tue, 22 Nov 2022 05:10:03 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id g10-20020a170902d1ca00b00178acc7ef16sm10180428plb.253.2022.11.22.05.10.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Nov 2022 05:10:03 -0800 (PST)
Message-ID: <faf3166b-0ae1-ff67-2d25-5d008e394d2c@kernel.dk>
Date:   Tue, 22 Nov 2022 06:10:01 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH -next] io_uring: Fix build error without CONFIG_EVENTFD
To:     Zhang Qilong <zhangqilong3@huawei.com>, dylany@fb.com,
        asml.silence@gmail.com
Cc:     io-uring@vger.kernel.org
References: <20221122120243.76186-1-zhangqilong3@huawei.com>
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20221122120243.76186-1-zhangqilong3@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        T_SPF_TEMPERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/22/22 5:02 AM, Zhang Qilong wrote:
> If CONFIG_IO_URING=y, CONFIG_EVENTFD=n, bulding fails:
> 
> io_uring/io_uring.c: In function ‘io_eventfd_ops’:
> io_uring/io_uring.c:498:3: error: implicit declaration of function ‘eventfd_signal_mask’; did you mean ‘eventfd_signal’? [-Werror=implicit-function-declaration]
>    eventfd_signal_mask(ev_fd->cq_ev_fd, 1, EPOLL_URING_WAKE);
> 
> This patch fixes that.

Thanks, folded in.

-- 
Jens Axboe


