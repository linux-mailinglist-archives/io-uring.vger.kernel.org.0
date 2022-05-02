Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 045AD51711A
	for <lists+io-uring@lfdr.de>; Mon,  2 May 2022 15:59:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381744AbiEBODY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 2 May 2022 10:03:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385456AbiEBODT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 2 May 2022 10:03:19 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03E2E13DED
        for <io-uring@vger.kernel.org>; Mon,  2 May 2022 06:59:50 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id i24so12352681pfa.7
        for <io-uring@vger.kernel.org>; Mon, 02 May 2022 06:59:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=hn6D/1mqsOpZCb0UXXalBcsMMDA5nsOG2XFxL4M3FKo=;
        b=OxSrCcWoV2/rXEc6h151zY/qeO1X7dtWA9CugimCewGit5D5A4IuMRCiGXyidVeV6l
         3812vCWntOXN1sP5c48z5i5HoWOkTRvGONajtLg53LYaCjT/qd1vnBvrx8veSBXEYLnr
         2wKLCEC1o9H++kbF8zEQp9qq9W337Wpsy44u7wWH1qRSzv6jNTM0NitUxFJevAdqy0c0
         MyPslOJpkoFTmDeiARvhzcL9L/JvniGGm+wX3+8jWiz96rzO6ieki7yDV0KkqI7CATSK
         ulSDjmKVrsSRhiF/jQeGkcRJg/KYcNPYxOeUTg/DkeMEhRlH//OLk8qE5Nyjmy0WD8ro
         ngqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=hn6D/1mqsOpZCb0UXXalBcsMMDA5nsOG2XFxL4M3FKo=;
        b=SP6CjNHly731OjD3vTqM0PKI9OcBRiQabXC3+5PL5LwOlqWk3GRvZK4sr5ClSte9hn
         F1v9j8HVeovjnOwYC7lBoGlK0v6tHZdwy8S/p/SViHU4H74/bQ79hjGkNFfs8BqaxlOE
         QBMYMDGrLHG4h5HVRpQGcrfm2qAwgLxKfVuoAO0JrkxC3PEnSNHGmtb4JZWuaQIRr2vU
         wi72PLhXeIzvkuSn272ZMlCQPSM3Wieqq12pjdZf/g6ggNfWA22Jv+wEaIo0n20Kj5CA
         h+yforvpc7l4n2YWjKgNKq2hQBzZPNpYIZTbRpD02ZlN6gwIGB204kdmMccpHXR32aF/
         JPXA==
X-Gm-Message-State: AOAM531DWlGJqJH1Vvb6LgjihXJS39jVrKZo6QZ1SCJnC+lyp/dvSliq
        woC3lsFRsuEj4VmgkBHvl2FR1m+MDYwHYA==
X-Google-Smtp-Source: ABdhPJxjx8WuzrEbZdVN+JUHo6GpAlTb6LBcVDFNfVOhcRgFUPo/c8ggfXBLEvDX2E8e3plRhWZwfA==
X-Received: by 2002:a63:4a09:0:b0:382:597:3d0d with SMTP id x9-20020a634a09000000b0038205973d0dmr10027753pga.18.1651499989469;
        Mon, 02 May 2022 06:59:49 -0700 (PDT)
Received: from [192.168.4.166] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id u4-20020aa78484000000b0050dc762813dsm2176532pfn.23.2022.05.02.06.59.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 May 2022 06:59:49 -0700 (PDT)
Message-ID: <bb283ff5-6820-d096-2fca-ae7679698a50@kernel.dk>
Date:   Mon, 2 May 2022 07:59:47 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [REGRESSION] lxc-stop hang on 5.17.x kernels
Content-Language: en-US
To:     Daniel Harding <dharding@living180.net>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     regressions@lists.linux.dev, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <7925e262-e0d4-6791-e43b-d37e9d693414@living180.net>
 <6ad38ecc-b2a9-f0e9-f7c7-f312a2763f97@kernel.dk>
 <ccf6cea1-1139-cd73-c4e5-dc9799708bdd@living180.net>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ccf6cea1-1139-cd73-c4e5-dc9799708bdd@living180.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/2/22 7:36 AM, Daniel Harding wrote:
> On 5/2/22 16:26, Jens Axboe wrote:
>> On 5/2/22 7:17 AM, Daniel Harding wrote:
>>> I use lxc-4.0.12 on Gentoo, built with io-uring support
>>> (--enable-liburing), targeting liburing-2.1.  My kernel config is a
>>> very lightly modified version of Fedora's generic kernel config. After
>>> moving from the 5.16.x series to the 5.17.x kernel series, I started
>>> noticed frequent hangs in lxc-stop.  It doesn't happen 100% of the
>>> time, but definitely more than 50% of the time.  Bisecting narrowed
>>> down the issue to commit aa43477b040251f451db0d844073ac00a8ab66ee:
>>> io_uring: poll rework. Testing indicates the problem is still present
>>> in 5.18-rc5. Unfortunately I do not have the expertise with the
>>> codebases of either lxc or io-uring to try to debug the problem
>>> further on my own, but I can easily apply patches to any of the
>>> involved components (lxc, liburing, kernel) and rebuild for testing or
>>> validation.  I am also happy to provide any further information that
>>> would be helpful with reproducing or debugging the problem.
>> Do you have a recipe to reproduce the hang? That would make it
>> significantly easier to figure out.
> 
> I can reproduce it with just the following:
> 
>     sudo lxc-create --n lxc-test --template download --bdev dir --dir /var/lib/lxc/lxc-test/rootfs -- -d ubuntu -r bionic -a amd64
>     sudo lxc-start -n lxc-test
>     sudo lxc-stop -n lxc-test
> 
> The lxc-stop command never exits and the container continues running.
> If that isn't sufficient to reproduce, please let me know.

Thanks, that's useful! I'm at a conference this week and hence have
limited amount of time to debug, hopefully Pavel has time to take a look
at this.

-- 
Jens Axboe

