Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A30094F0A69
	for <lists+io-uring@lfdr.de>; Sun,  3 Apr 2022 16:54:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345221AbiDCO4M (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 3 Apr 2022 10:56:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355103AbiDCO4K (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 3 Apr 2022 10:56:10 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F37B510FD5
        for <io-uring@vger.kernel.org>; Sun,  3 Apr 2022 07:54:15 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id j20-20020a17090ae61400b001ca9553d073so655051pjy.5
        for <io-uring@vger.kernel.org>; Sun, 03 Apr 2022 07:54:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=q/JF2On4FsEXRK5itIPU8/GRRHQNNW5pURvQso6ilXE=;
        b=MdDj/NCJ0Bxf21jmONNVMhL6Zn4iNvTEW/9eDYrvRs9lPqlPKH+0RQPaDONQ6O4ZSH
         pHF4L2+C1fUT9XwNUY/xxZ3If1ua5Fad1LoIN+s8/21p3bLUBgCAfC0z+OvdDxVQJCHQ
         mwJx0WxhWzP0psm0ueWsZjuqek2oHL6xvcQl6aTrAJ9I6g3uud2V1SA4RYYcZOZM6P4h
         bX2Q0Yn17bbE/SJ/nLf5AxRX9XDG+XDSJmO6ZLNqeBAVx3WBtbwRismfGn5gS9PKUi8d
         syHuybadmzcK3yI8N14Zbt1yBmbX8G+M0ma9bkqfktd+nGIvTO4nPcAcTkxSlJvJfjbV
         noGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=q/JF2On4FsEXRK5itIPU8/GRRHQNNW5pURvQso6ilXE=;
        b=0UG96Ex+gCxy65pYo9t2FSj+OlWR9heHd2323lwwQba7rMXxME2DQl8FMdBAL0XcOo
         0mGLuW4xD4kVGcGw5GIJkdRJuMyavL3T49rznmrVQ3WawbBC9tGxB3s1Qxs9INXMWgS4
         2cg2mYr0C6Xbt8yOj9eoiINfI4Pzgy0iE1tBoH05Grj7qMZMNNYJWtJhQmIaw3XLljpp
         oBNFkVuv7rZJn1wFU9RGPp1OfHshLwffdYo+cYPKluGYp86LpnoixtKyTitOLTcPCmBn
         QC1vZ4FPAthvff4x7uO6EgI65u/pnleH88rfbxyWn8qEsq7JJGrXKdnUhAmO4WRJ4Es2
         9kKA==
X-Gm-Message-State: AOAM530bKohnoevk5gGmO+N8nQw7GAcZ5NQP+ZW3Pdl9T4g9qkJh574v
        hA+OApY8EFoT8P4V+DM2hQiQRQ==
X-Google-Smtp-Source: ABdhPJyDfzMbGKY92L9phkkTkr9O4oL/tsFj8WfKKwU7iHW4aXLXhqOD/Oe5ilZ2KqEYeKHYpLX0oQ==
X-Received: by 2002:a17:90b:1809:b0:1c7:28fb:bdd0 with SMTP id lw9-20020a17090b180900b001c728fbbdd0mr21588711pjb.231.1648997655427;
        Sun, 03 Apr 2022 07:54:15 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id p16-20020a056a000b5000b004faed463907sm9526492pfo.0.2022.04.03.07.54.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 03 Apr 2022 07:54:15 -0700 (PDT)
Message-ID: <c53378f8-87eb-43a6-afbb-e506c566ad26@kernel.dk>
Date:   Sun, 3 Apr 2022 08:54:14 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PULL|PATCH v3 0/7] liburing debian packaging fixes
Content-Language: en-US
To:     Eric Wong <e@80x24.org>
Cc:     io-uring@vger.kernel.org, Stefan Metzmacher <metze@samba.org>,
        Liu Changcheng <changcheng.liu@aliyun.com>
References: <20211116224456.244746-1-e@80x24.org>
 <20220121182635.1147333-1-e@80x24.org> <20220403084820.M206428@dcvr>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220403084820.M206428@dcvr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/3/22 2:48 AM, Eric Wong wrote:
> Eric Wong <e@80x24.org> wrote:
>> The previous patch 8/7 in v2 is squashed into 3/7 in this series.
>> Apologies for the delay since v2, many bad things happened :<
>>
>> The following changes since commit bbcaabf808b53ef11ad9851c6b968140fb430500:
>>
>>   man/io_uring_enter.2: make it clear that chains terminate at submit (2022-01-19 18:09:40 -0700)
>>
>> are available in the Git repository at:
>>
>>   https://yhbt.net/liburing.git deb-v3
>>
>> for you to fetch changes up to 77b99bb1dbe237eef38eceb313501a9fd247d672:
>>
>>   make-debs: remove dependency on git (2022-01-21 16:54:42 +0000)
> 
> Hi Jens, have you had a chance to look at this series?  Thanks.
> I mostly abandoned hacking for a few months :x

I never build distro packages and know very little about it, so would
really like Stefan et al to sign off on this. I'm about to cut the next
version of liburing, and would indeed be great to have better packaging
sorted before that.

Does it still apply to the curren tree?

-- 
Jens Axboe

