Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68E5875CC13
	for <lists+io-uring@lfdr.de>; Fri, 21 Jul 2023 17:38:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232090AbjGUPiM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 21 Jul 2023 11:38:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232155AbjGUPiF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 21 Jul 2023 11:38:05 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F9702D53
        for <io-uring@vger.kernel.org>; Fri, 21 Jul 2023 08:37:43 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id ca18e2360f4ac-785ccd731a7so25476139f.0
        for <io-uring@vger.kernel.org>; Fri, 21 Jul 2023 08:37:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1689953842; x=1690558642;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xImyD+yO3rmnPTaZ7zqBHFog6zByR+hiw0FMy43ZAF8=;
        b=UulGhCEx4KwWU/aoh/p69DpJiAAlZIhvOw/Omy5Ef+6I0oJTjOueoxiO+vaULazwnW
         hZeSRoWbuHhbi0MwBy/wk+b7i/LZhZE4qZfDNYSJ6jG/VGlL3Z49VHBp/egk4WArYo4F
         U4l977ThHw87RH5YnvMZS3cuOT48alHqCEW3ue9+6wzsxWNFwNhYnve4G2qTaYKdoidp
         3KSrVBf4fKoRCBlfvmdJz1ahxgjgwFkHBYX9AVK8GbHpG0o4hFca6BVmx+xJ4UIcF+QU
         xo5m9LMr2y5Mk+AWXjZW5pzXCx92BgtTnPZ1ZrjO7M96jFqumEkAyxtVZsXm4xTUU0XK
         m4sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689953842; x=1690558642;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xImyD+yO3rmnPTaZ7zqBHFog6zByR+hiw0FMy43ZAF8=;
        b=Oit4WaqF0stfrOXONqxaN/RX9VH9NqDljBnYl27AzNLrKoilwnHTIZ4govMIzoBSRn
         N1FWkcFA6VkmE5ReprkQBirVc1oGiR00sniYnow8omtZR2MWgFLgjNy/8NK9z6TOKzFP
         MFvWL89Sx2VFIxx0sgCouR9yCzavjBGOjpHZAY3oXfounHpwZ+YLzVfdjOcEZVZTRclA
         S1M7bhJPaNBuuxwyjWdC4vLOh1j61HdpWrEInvcS06zdZJEcK37SgWjPAmK1+k5/EshV
         owPLxlNxI6YChnh7amufJul9x/jiXcw5wgmRF3B6fcOy/LsjGrpMg1yEd73cHbAlUb2K
         eL1g==
X-Gm-Message-State: ABy/qLYSp/nmjtgTITw3aj9waFobMeQXRr+RofcwPpxe2jrGgUYRYbPJ
        u4Nk6adme9Zfw0WE14bTvI4Ovg==
X-Google-Smtp-Source: APBJJlG48qoxmngjxjRPO6MDm2soMhCslTdV3I+hALANppSt3uIIp+jTj3IgysN60MjA5YXmyAzmbg==
X-Received: by 2002:a92:ad0f:0:b0:346:10c5:2949 with SMTP id w15-20020a92ad0f000000b0034610c52949mr1923136ilh.1.1689953841897;
        Fri, 21 Jul 2023 08:37:21 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id u6-20020a02aa86000000b0042b530d29c3sm1085205jai.164.2023.07.21.08.37.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Jul 2023 08:37:21 -0700 (PDT)
Message-ID: <70f56d4e-fe68-a002-0a1a-00cb778d6900@kernel.dk>
Date:   Fri, 21 Jul 2023 09:37:20 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 5/8] iomap: only set iocb->private for polled bio
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     io-uring@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de,
        andres@anarazel.de, david@fromorbit.com
References: <20230720181310.71589-1-axboe@kernel.dk>
 <20230720181310.71589-6-axboe@kernel.dk>
 <20230721153515.GN11352@frogsfrogsfrogs>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230721153515.GN11352@frogsfrogsfrogs>
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

On 7/21/23 9:35?AM, Darrick J. Wong wrote:
> On Thu, Jul 20, 2023 at 12:13:07PM -0600, Jens Axboe wrote:
>> iocb->private is only used for polled IO, where the completer will
>> find the bio to poll through that field.
>>
>> Assign it when we're submitting a polled bio, and get rid of the
>> dio->poll_bio indirection.
> 
> IIRC, the only time iomap actually honors HIPRI requests from the iocb
> is if the entire write can be satisfied with a single bio -- no zeroing
> around, no dirty file metadata, no writes past EOF, no unwritten blocks,
> etc.  Right?
> 
> There was only ever going to be one assign to dio->submit.poll_bio,
> which means the WRITE_ONCE isn't going to overwrite some non-NULL value.
> Correct?
> 
> All this does is remove the indirection like you said.
> 
> If the answers are {yes, yes} then I understand the HIPRI mechanism
> enough to say

Correct, yes to both. For multi bio or not a straight overwrite, iomap
disables polling.

> Reviewed-by: Darrick J. Wong <djwong@kernel.org>

Thanks!

-- 
Jens Axboe

