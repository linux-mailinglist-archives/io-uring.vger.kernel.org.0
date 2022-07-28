Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DDCD583EF7
	for <lists+io-uring@lfdr.de>; Thu, 28 Jul 2022 14:37:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236273AbiG1MhC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 28 Jul 2022 08:37:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237841AbiG1Mg6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 28 Jul 2022 08:36:58 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5837B68DFA
        for <io-uring@vger.kernel.org>; Thu, 28 Jul 2022 05:36:53 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id ha11so1924522pjb.2
        for <io-uring@vger.kernel.org>; Thu, 28 Jul 2022 05:36:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=vHu2pcFEIe6G1WfsJEKsoKowne2sE6t0FZPvonvpI64=;
        b=Syrm5GXlMDKp3DKsnsXY+v/Soj61LUBJZx5XqO5aPND/w9OcDokw4OWb+4otnDkRI/
         Qd7X1LwAKaG0WZfoAE7B98ppzlDg0fa8Vso7uNYB+usG7q8+VfyIfTEOyC/j6qm07IdI
         jkstxCPJSOy5fDAOgaAjv9yDA5krF+nIaHYrYGpapmgNmi3/hGxNT/zWPiaVoisDwwFS
         1FIIk/5Lz6Gb12WQNMkyXCup3t/IOoa1QEjfoBeo3iU+kUpbXuIToWrRQLgp/rOU4t1B
         TNcxxr/NAxlUVSk4OCJgfbC5JJ1GeJ3JBA0UuwTDKJ5AE1OvxlItkUnWqBcv8zdvcN50
         72WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=vHu2pcFEIe6G1WfsJEKsoKowne2sE6t0FZPvonvpI64=;
        b=e8/4hAJL4Q1tNLDFggc2jzXyhFBYTIX0+YLF9tGEdreCt0LmDOqQkMMNgyxPPvIpZ8
         yxLtCBen1gpxu873wRpWN+bxU5JuFKEwv2q9gqCdWQ+xGKWC/gYDL7IOGdG/3S050Z+q
         3BT15iRFul9LE40/a6QFrEpDgaC3xOTNvzMR3WIsiOXezXtNEIf5Izhbh48sCRUrtkMj
         Y49TUJKR9gNaSH4tWO8hltKx8TlyHWrVbtfTRbQiwQsb3q6U+d+eGNGLgxqkk831UEVA
         4FEeR6bv3NA9J2ZKJ7E2rRi/5uAwUJo3EV6DoY0LI6DZPKdccm548hCyAm00LQd9vsEG
         rSsQ==
X-Gm-Message-State: AJIora8dGI3WmNhjx+xu+2Trad44jc8ylHQh8MrEAYIEXGGQD78RIhMH
        +mlYfcX/ZaJ+azfVHMd5mrlFtPPvqF/eZw==
X-Google-Smtp-Source: AGRyM1sYus+AT3bOXJjYqW7jRCTV4+VuEKsyTHQUHihTflQkNWykgD17DGC1QzpdSSwnWhgU2A8SAw==
X-Received: by 2002:a17:902:ccc4:b0:16c:5766:51f9 with SMTP id z4-20020a170902ccc400b0016c576651f9mr26113842ple.84.1659011812741;
        Thu, 28 Jul 2022 05:36:52 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id h14-20020aa796ce000000b0052ac5e304ccsm588082pfq.194.2022.07.28.05.36.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Jul 2022 05:36:52 -0700 (PDT)
Message-ID: <0a9c81d0-d6f6-effd-5d3f-132a92d54205@kernel.dk>
Date:   Thu, 28 Jul 2022 06:36:51 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH liburing v3 0/5] Add basic test for nvme uring passthrough
 commands
Content-Language: en-US
To:     Ankit Kumar <ankit.kumar@samsung.com>
Cc:     io-uring@vger.kernel.org, joshi.k@samsung.com
References: <CGME20220728093902epcas5p40813f72b828e68e192f98819d29b2863@epcas5p4.samsung.com>
 <20220728093327.32580-1-ankit.kumar@samsung.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220728093327.32580-1-ankit.kumar@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/28/22 3:33 AM, Ankit Kumar wrote:
> This patchset adds a way to test NVMe uring passthrough commands with
> nvme-ns character device. The uring passthrough was introduced with 5.19
> io_uring.
> 
> To send nvme uring passthrough commands we require helpers to fetch NVMe
> char device (/dev/ngXnY) specific fields such as namespace id, lba size etc.
> 
> How to run:
> ./test/io_uring_passthrough.t /dev/ng0n1
> 
> It requires argument to be NVMe device, if not the test will be skipped.
> 
> The test covers write/read with verify for sqthread poll, vectored / nonvectored
> and fixed IO buffers, which can be extended in future. As of now iopoll is not
> supported for passthrough commands, there is a test for such case.
> 
> Changes from v2 to v3
>  - Skip test if argument is not nvme device and remove prints, as
>    suggested by Jens.
>  - change nvme helper function name, as pointed by Jens.
>  - Remove wrong comment about command size, as per Kanchan's review

I didn't get patch 2/5, and lore didn't either. Can you resend the series?

-- 
Jens Axboe

