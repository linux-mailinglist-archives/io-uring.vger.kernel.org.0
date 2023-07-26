Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0139E76425B
	for <lists+io-uring@lfdr.de>; Thu, 27 Jul 2023 01:08:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230345AbjGZXIB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 26 Jul 2023 19:08:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbjGZXIA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 26 Jul 2023 19:08:00 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68C841738
        for <io-uring@vger.kernel.org>; Wed, 26 Jul 2023 16:07:59 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id d9443c01a7336-1b89b0c73d7so502575ad.1
        for <io-uring@vger.kernel.org>; Wed, 26 Jul 2023 16:07:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1690412879; x=1691017679;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=p7/oP7WoNWR+PINLXplV3oHqqLL4+fszPcNGIJhuEWk=;
        b=ViPNVRYFQndVCfDDCO2WY1Xa/4+syxVzQc2rXiDbFlNk4A6czSB3atXb3iPQy7ecEz
         1tXLWyO68zep2iAOs4A9PVnSS104OtFplD2OA1T/uhf9LeEcz+qVaauqWWwqCeUao8mH
         9qTo9FZGnS+oVLe7dFSNvQ9DnHss5V0+H17NucvSTl92mpaihqOe0vVptSU6tI3spr40
         pTKT5WA1079BYj//OmngM+UpAtsrGqunTm38EpaGdksppOcxLJcVQHGIKZDEdiDe7WLL
         OsXaMx3mE9PKIV91crcEeYClE3BP+y5iejYocmMhZua/mqx9PefkacWDNV0PWeZMY1ki
         0Vzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690412879; x=1691017679;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=p7/oP7WoNWR+PINLXplV3oHqqLL4+fszPcNGIJhuEWk=;
        b=DuuNSdUSbmkH1jsnUPMYn3u7LgwSB40xeKwr9NzU22LPlmMEU0PHaDzqdKj0KZqv6G
         QW4cdqUHvyzbtGKU3MjwUZtTu3XxBExBoxQhmwqSCTPqsEw14xMEgt47jguRhYCRqkSt
         Qo95xr9eWlax4LUsCUV0QxRo6Zm8zo1LVMbvl/GhZ3kiJq/dMLqcWHo8l4daBYjbpqga
         USd03sdd1DIRNk7vVeDwKV/K0Ygtl+PH+f4ub9vt+dpnptEgvQRVbnQUivURm+n7kNNJ
         9GOeW5X3BbjUpzyVitxmng0E6qhP8TKw8LgK6Fx0kq0Hi+EZUkjDlxlIiCN0Q4bo3isd
         bxjg==
X-Gm-Message-State: ABy/qLbMMAXt8I5o9ORXdYIWSRpwe8PVYGoGGPs6xpaIQkPlQQ+ADqX3
        QOXgNNLje0vqPXE33IPOn3AAKzMR0RTkPiIjkaE=
X-Google-Smtp-Source: APBJJlHXKScTmXEgilon30N8c3qbXnKPqUp0hZOJIl/faT7MRn4jaUH13Oir3gHFy6jkpcyqnYXaFg==
X-Received: by 2002:a17:902:e809:b0:1b8:35fa:cdcc with SMTP id u9-20020a170902e80900b001b835facdccmr4193440plg.5.1690412878728;
        Wed, 26 Jul 2023 16:07:58 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id a14-20020a17090abe0e00b0025dc5749b4csm1704311pjs.21.2023.07.26.16.07.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Jul 2023 16:07:58 -0700 (PDT)
Message-ID: <786a1eda-4592-789b-aaea-e70efbabeaa5@kernel.dk>
Date:   Wed, 26 Jul 2023 17:07:57 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCHSET v6 0/8] Improve async iomap DIO performance
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-xfs@vger.kernel.org
Cc:     hch@lst.de, andres@anarazel.de, david@fromorbit.com,
        djwong@kernel.org
References: <20230724225511.599870-1-axboe@kernel.dk>
In-Reply-To: <20230724225511.599870-1-axboe@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/24/23 4:55?PM, Jens Axboe wrote:
> Hi,
> 
> Hi,
> 
> This patchset improves async iomap DIO performance, for XFS and ext4.
> For full details on this patchset, see the v4 posting:
> 
> https://lore.kernel.org/io-uring/20230720181310.71589-1-axboe@kernel.dk/
> 
>  fs/iomap/direct-io.c | 163 ++++++++++++++++++++++++++++++++-----------
>  include/linux/fs.h   |  35 +++++++++-
>  io_uring/rw.c        |  26 ++++++-
>  3 files changed, 179 insertions(+), 45 deletions(-)
> 
> Can also be found here:
> 
> https://git.kernel.dk/cgit/linux/log/?h=xfs-async-dio.6
> 
> No change in performance since last time, and passes my testing without
> complaints.
> 
> Changes in v6:
> - Drop the polled patch, it's not needed anymore
> - Change the "inline is safe" logic based on Dave's suggestions
> - Gate HIPRI on INLINE_COMP|CALLER_COMP, so polled IO follows the
>   same rules as inline/deferred completions.
> - INLINE_COMP is purely for reads, writes can user CALLER_COMP to
>   avoid a workqueue punt. This is necessary as we need to invalidate
>   pages on write completions, and if we race with a buffered reader
>   or writer on the file.

Dave, are you happy with this one?

-- 
Jens Axboe

