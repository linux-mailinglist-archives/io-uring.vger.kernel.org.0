Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B70BB52604C
	for <lists+io-uring@lfdr.de>; Fri, 13 May 2022 12:58:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231867AbiEMK4Z (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 13 May 2022 06:56:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232124AbiEMK4D (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 13 May 2022 06:56:03 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97EEB31922
        for <io-uring@vger.kernel.org>; Fri, 13 May 2022 03:56:00 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id l7-20020a17090aaa8700b001dd1a5b9965so7469012pjq.2
        for <io-uring@vger.kernel.org>; Fri, 13 May 2022 03:56:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:to:cc:references
         :from:in-reply-to:content-transfer-encoding;
        bh=bLUocIuCSugMrpq0bJ+l+vLwclGHmzOrxPmDFuwEO94=;
        b=G/07VDSSbbEuVb5d4B7k2CEVARVGwMmMxI5Qe1hICKeFQvV0MK9NLYRW8wh4eUmJg0
         4W8lqxA7Af0qcS+DuRO/d9scWQs6Bh6fUOT1sy0ZGWxyzzMrCZj9M8Kz3n2Ui28MgnnF
         DVa5WX2Vk1oOot1a3EhTTK80kl2lwafla7WWqYobEVXpn/H3dQU6mhZ4w6R84RP0Vd8a
         UWiOcBYDoW36DRDJuR1ZTdrul4EZLsByRlK3h5Z1QHc0IOGvXFpuPYX8tnnzCe3wBdli
         XcKXs3DvPj75YT/oZ8BgDQQuGBaC040SSBEI6XHC/6kZAwBEwlCIHZEJ8htKrtUIqVzQ
         gq/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :to:cc:references:from:in-reply-to:content-transfer-encoding;
        bh=bLUocIuCSugMrpq0bJ+l+vLwclGHmzOrxPmDFuwEO94=;
        b=u5VpNee/7SPzCYRIPVDcqJsMZbBeYh7KbWYfvy2iCWnEADLOVY6ngmyKFrzo+Rvq62
         Y1TzBBTY/FJ5nx3K6GQkU1N7i+3m0Pur9iDFhS+jY3uKJpVAazcKPE4+20u2kMLy/Jtr
         xkjAPevPv7kKNKXdbspCQv8f2whbDdsgyZwhrpCB20gFw8CLAYk45gs7/6tjz8Hhr85d
         n1IvO2JKPUnV6MV+tldvj+JH991tk9n8AaAXQKDjMPDYKcZqUvMKmeyxrc6ktY9reTtR
         KuB22Fef7y//4seZ+2A8lx98FKDXDmjPldr4j9EkelWl4C293VaxavuALTfYJic9JPKV
         p65w==
X-Gm-Message-State: AOAM531kJAdmuM+1v4lsrFX8utsha0UMi+umxTHslYZyc5RsJN8azU+j
        ObWX+vfrltlDLlqMVwAXV8KU/WlGsXU=
X-Google-Smtp-Source: ABdhPJw/FX2br+unfoN58P6WuvhAMmTFikiFT364qapoY8Tq5wqnT2E/MHUEf49C8EhkBaI3vSV/jw==
X-Received: by 2002:a17:902:e94e:b0:158:91e6:501 with SMTP id b14-20020a170902e94e00b0015891e60501mr4182894pll.29.1652439360108;
        Fri, 13 May 2022 03:56:00 -0700 (PDT)
Received: from [192.168.255.10] ([106.53.4.151])
        by smtp.gmail.com with ESMTPSA id m28-20020a62a21c000000b0050dc76281f5sm1459301pff.207.2022.05.13.03.55.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 May 2022 03:55:59 -0700 (PDT)
Message-ID: <b7f610d8-4afe-9876-2dc5-6933cfa6ee06@gmail.com>
Date:   Fri, 13 May 2022 18:56:13 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Subject: Re: [PATCHSET v2 0/6] Allow allocated direct descriptors
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com
References: <20220509155055.72735-1-axboe@kernel.dk>
From:   Hao Xu <haoxu.linux@gmail.com>
In-Reply-To: <20220509155055.72735-1-axboe@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2022/5/9 下午11:50, Jens Axboe 写道:
> Hi,
> 
> Currently using direct descriptors with open or accept requires the
> application to manage the descriptor space, picking which slot to use
> for any given file. However, there are cases where it's useful to just
> get a direct descriptor and not care about which value it is, instead
> just return it like a normal open or accept would.
> 
> This will also be useful for multishot accept support, where allocated
> direct descriptors are a requirement to make that feature work with
> these kinds of files.
> 
> This adds support for allocating a new fixed descriptor. This is chosen
> by passing in IORING_FILE_INDEX_ALLOC as the fixed slot, which is beyond
> any valid value for the file_index.
> 
> Can also be found here:
> 
> https://git.kernel.dk/cgit/linux-block/log/?h=for-5.19/io_uring-fixed-alloc
> 
>   fs/io_uring.c                 | 113 +++++++++++++++++++++++++++++++---
>   include/uapi/linux/io_uring.h |  17 ++++-
>   2 files changed, 120 insertions(+), 10 deletions(-)
> 
> v2:	- Fix unnecessary clear (Hao)
> 	- Add define for allocating a descriptor rather than use
> 	  UINT_MAX.
> 	- Add patch bumping max file table size to 1M (from 32K)
> 	- Add ability to register a sparse file table upfront rather
> 	  then have the application pass in a big array of -1.
> 

Reviewed-by: Hao Xu <howeyxu@tencent.com>

