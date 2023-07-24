Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3129575FB2F
	for <lists+io-uring@lfdr.de>; Mon, 24 Jul 2023 17:50:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231159AbjGXPue (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Jul 2023 11:50:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231359AbjGXPud (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 Jul 2023 11:50:33 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB8F0B0
        for <io-uring@vger.kernel.org>; Mon, 24 Jul 2023 08:50:25 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id ca18e2360f4ac-760dff4b701so56076739f.0
        for <io-uring@vger.kernel.org>; Mon, 24 Jul 2023 08:50:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1690213825; x=1690818625;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RIsGgKww9Eb9PV4fKcvrXzf2hZ8SDdRIJ2lqhbJPbJQ=;
        b=owmGOTF+NRNxB4d7mwEMH/srf6ZO86sCeA9RYlA2xU+3tARUIMj5MSrcFV+blaqX2T
         h/DNPpYOOivTX8NaHKjWzGenwwSPRcvvqW+Tk+qdppXYRyjBhVYx4f3RPR+PhAySz7qb
         +lXyGwJqDiCsovfQ9A68Uhf5enWmzwFRHhiZ4jEqtH4LLhYvRMtKRvmZxx7j5nNcua3f
         m68WS24q4UwLYVAj6e4Z0zZ8qUErgBzfvjoBfFOkeSFkPK/cscV7C5OMsIu+zFbG9M8t
         AwFRyzE6T87xjDBXixmz6psfFGuszmC8UmbWlCoXuJ+OoLHxwxXKzUHgOIElucUcWpQ+
         Jqng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690213825; x=1690818625;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RIsGgKww9Eb9PV4fKcvrXzf2hZ8SDdRIJ2lqhbJPbJQ=;
        b=B+iKSLKA8B1kmdmFkgAA1L0xbrixOEd9JAYRilbJKhaLfxCPyFin4PCEXp4w16dGtR
         3OPNfYXKODl9bcOxdrr1Zvl2Jjegv70PiQOJyhjewj3U5ngYs3EQOVhAUMOxgvF7JlxX
         SJJbrkp5lcb4DI+n4z68vx7w4iLgO8CZsK474lT5wUNC9ne1ydwkNzVOxPHj3ufeIBbG
         IMUGmTl02oSxaR3lHiC4M7MBDFAj1RiA+WhILz6+nF1EtSchSBm+DMRWQEVnzruxuCyW
         LG6x8JSZcP4uvv+WwpLn1xVTi2pv3xxQ114cRjx/3UlsTYVZWbaG+6XC3VEnOZSJP6ZE
         meTA==
X-Gm-Message-State: ABy/qLYga+DIN32jhHw6yM3sPoXeVtdTFziZiZLMgUjjDY4nrXXV5MDE
        x8ze2szdbMSdK9qm4KyLjfUa2A==
X-Google-Smtp-Source: APBJJlHXzYYl5MkD6ZjEsZRCsiXpMK0FkxLXK+k8wkt+S6Et1/6HEGKXVp0UJrNVR8gc854pfJh2nA==
X-Received: by 2002:a05:6602:3e87:b0:780:cb36:6f24 with SMTP id el7-20020a0566023e8700b00780cb366f24mr8220438iob.2.1690213825340;
        Mon, 24 Jul 2023 08:50:25 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id t23-20020a05663801f700b00420e6c58971sm3008295jaq.178.2023.07.24.08.50.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Jul 2023 08:50:24 -0700 (PDT)
Message-ID: <140065e3-0368-0b5d-8a0d-afe49b741ad2@kernel.dk>
Date:   Mon, 24 Jul 2023 09:50:24 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH] io_uring: Use io_schedule* in cqring wait
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>,
        Phil Elwell <phil@raspberrypi.com>
Cc:     andres@anarazel.de, asml.silence@gmail.com, david@fromorbit.com,
        hch@lst.de, io-uring@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org,
        stable <stable@vger.kernel.org>
References: <CAMEGJJ2RxopfNQ7GNLhr7X9=bHXKo+G5OOe0LUq=+UgLXsv1Xg@mail.gmail.com>
 <2023072438-aftermath-fracture-3dff@gregkh>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <2023072438-aftermath-fracture-3dff@gregkh>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/24/23 9:48?AM, Greg KH wrote:
> On Mon, Jul 24, 2023 at 04:35:43PM +0100, Phil Elwell wrote:
>> Hi Andres,
>>
>> With this commit applied to the 6.1 and later kernels (others not
>> tested) the iowait time ("wa" field in top) in an ARM64 build running
>> on a 4 core CPU (a Raspberry Pi 4 B) increases to 25%, as if one core
>> is permanently blocked on I/O. The change can be observed after
>> installing mariadb-server (no configuration or use is required). After
>> reverting just this commit, "wa" drops to zero again.
> 
> This has been discussed already:
> 	https://lore.kernel.org/r/12251678.O9o76ZdvQC@natalenko.name
> 
> It's not a bug, mariadb does have pending I/O, so the report is correct,
> but the CPU isn't blocked at all.

Indeed - only thing I can think of is perhaps mariadb is having a
separate thread waiting on the ring in perpetuity, regardless of whether
or not it currently has IO.

But yes, this is very much ado about nothing...

-- 
Jens Axboe

