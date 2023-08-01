Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F28BF76C0FD
	for <lists+io-uring@lfdr.de>; Wed,  2 Aug 2023 01:35:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229679AbjHAXfL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 1 Aug 2023 19:35:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbjHAXfK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 1 Aug 2023 19:35:10 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A91C826B0
        for <io-uring@vger.kernel.org>; Tue,  1 Aug 2023 16:34:47 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id 41be03b00d2f7-5643140aa5fso561685a12.0
        for <io-uring@vger.kernel.org>; Tue, 01 Aug 2023 16:34:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1690932887; x=1691537687;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=z9mtYLgCllS9ypoxJCYiXNtN9ZGOxcY6Mye5Q2NFML8=;
        b=aHC1FYZGv7Yj9PHxYaRof/uMCWSjHHqGVpmVIilzQ5Ji+URG7g+uih1/vk8UvtMPkL
         XdUHsb2GNsIn0gLvk+9dGvUV8KS4Udde3yGzGFn0W8YKugvuNusb8ja35rd/nMSGBUnZ
         wtwLezLz3ObHy4XbLZ3IFa7Czdsk0B99t6Jeb06eHdS+61B6u+XMZHEQilIxZOMcL+9H
         w3lM3hQICtYipbglkVDb7v7fSAKfUbKUz0ffw2wNsm5fU3dJ8Zs8X9ZHDYu5L8UH9E01
         br1ETWCLQwnGj2TBmtwHc+dSgg2nR0WWTZK30ve8FqAa5N6geo4bcGPv3rRiD5X1f0CJ
         sJGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690932887; x=1691537687;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=z9mtYLgCllS9ypoxJCYiXNtN9ZGOxcY6Mye5Q2NFML8=;
        b=Wvk3xFoNT2wWGcPsauVEeEKd2qLtSbbicikslqsgbyYmzwo+ApSaeqxJPeSAJ6XPb8
         d+P+WDuRMDXBcwbvj9dywHw1TtzupJYqhAIhc1sALxYLK9sZUTyD12782MtowRbs6pnm
         iVK4h90mVYgvWwO1iXhAt2GXiyUTO6y8tD+bJqo6hBxZuRcXjWelM1ZUVQZHkGMVC5qa
         xc2Teu3irzBZhsHXCXfRQzqsm/QLCaPRPa0UlhzTtMZMR4SCsPmyzE5TOMv8RThuHsjy
         lly2+q9TIuFAfOFkrkMi7R2pg+mGDfAmyxmnFdx1Oz2l3CsGwfgH/TQxrqCkF58hkjy3
         vjGQ==
X-Gm-Message-State: ABy/qLZIOx+C/EdCoYxP9PP3+YUiVL8AEbGYAV5Kjfrik7FLvWMHnfEi
        xOPlNRfWYcvFgA0BVnN6YvbJjrL5jifPLhx/a54=
X-Google-Smtp-Source: APBJJlFLJPBysUZweYl0GUhiZTgNhdoBhVlEGOooQN8krHB2TmlewFi/fq6iSJMSWa2qs3Kg6pvydg==
X-Received: by 2002:a17:902:ea04:b0:1b8:a27d:f591 with SMTP id s4-20020a170902ea0400b001b8a27df591mr14114636plg.5.1690932886948;
        Tue, 01 Aug 2023 16:34:46 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 14-20020a17090a194e00b00268385b0501sm66690pjh.27.2023.08.01.16.34.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Aug 2023 16:34:46 -0700 (PDT)
Message-ID: <edebb2ed-8226-096d-d33a-d078f30a1221@kernel.dk>
Date:   Tue, 1 Aug 2023 17:34:45 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCHSET v6 0/8] Improve async iomap DIO performance
Content-Language: en-US
To:     Dave Chinner <david@fromorbit.com>
Cc:     io-uring@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de,
        andres@anarazel.de, djwong@kernel.org
References: <20230724225511.599870-1-axboe@kernel.dk>
 <ZMmDdEfyxIzpfezy@dread.disaster.area>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ZMmDdEfyxIzpfezy@dread.disaster.area>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/1/23 4:13 PM, Dave Chinner wrote:
> On Mon, Jul 24, 2023 at 04:55:03PM -0600, Jens Axboe wrote:
>> Hi,
>>
>> Hi,
>>
>> This patchset improves async iomap DIO performance, for XFS and ext4.
>> For full details on this patchset, see the v4 posting:
>>
>> https://lore.kernel.org/io-uring/20230720181310.71589-1-axboe@kernel.dk/
>>
>>  fs/iomap/direct-io.c | 163 ++++++++++++++++++++++++++++++++-----------
>>  include/linux/fs.h   |  35 +++++++++-
>>  io_uring/rw.c        |  26 ++++++-
>>  3 files changed, 179 insertions(+), 45 deletions(-)
>>
>> Can also be found here:
>>
>> https://git.kernel.dk/cgit/linux/log/?h=xfs-async-dio.6
>>
>> No change in performance since last time, and passes my testing without
>> complaints.
> 
> All looks good now. You can add:
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> 
> To all the patches in the series.

Great, thank you Dave!

-- 
Jens Axboe


