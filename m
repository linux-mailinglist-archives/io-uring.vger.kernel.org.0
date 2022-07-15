Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D8305766AC
	for <lists+io-uring@lfdr.de>; Fri, 15 Jul 2022 20:22:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229698AbiGOSWO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 15 Jul 2022 14:22:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230037AbiGOSWM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 15 Jul 2022 14:22:12 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F37261707
        for <io-uring@vger.kernel.org>; Fri, 15 Jul 2022 11:22:08 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id g16-20020a17090a7d1000b001ea9f820449so12265539pjl.5
        for <io-uring@vger.kernel.org>; Fri, 15 Jul 2022 11:22:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=4/FyjU6uBWan2kSoZSaU/6fj+++EQw3eJlaaItPX/nQ=;
        b=1/6brnyuOTj1rUlpQHv9IGU1OyraCVO0pVuUXSJiuexUN615vRZ3rV763vL1cUeevx
         wc5/qtbiwO5sdB+uKnLluQne2Dc9FwwxOtTzM0maAbrG5qPhxalV+eyTCIlfR8rJDcz8
         /8wPLjLOBZBTiddSqwe/X3D7BtSswk3hEjWLhJh005UaqNUfjjaTr0zX32UanHRpp3cz
         RAh78/gBG6cwrWFR4jOKW+OlQ77ANurx8LD3x0e5mIyfiyK26qUO85bURar6vYQ87ndX
         blz0tC5zgOTTpBYiRDHqUXJDyNXdLzinpCQZKgfReiTsSrcp21iNJ2dReioTws2zmzTF
         p62g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=4/FyjU6uBWan2kSoZSaU/6fj+++EQw3eJlaaItPX/nQ=;
        b=a31pa8WGu5TK3CyVxgwZbyf/pKRzD10V4ov60tdgDVccG2IreGR+TY5V9iZvJhazUt
         qrqf2dMT3h4QTCMfI208ge4c+yhCKtzTzsObLY4fA3vWdOrYA8Yf7p9fTSivNZFzJw+N
         vvL/N/d3lcSLrIXumntmKhJbPjcCTun5O30Q/5eROPW/8waQA3fzhb5nQw22cUDn++DK
         r6Ze2zxq+oQvPqT90r6zPKGpenjQNUlz1nqaEQhAKnwMDrXc0JTxA3IL1IOLZ2vwxS07
         hyJRwCHGl722MyCZllCCjkJWdn2T2mfKsIcjnE9v+kna6NjBkqKIT3IlA+ewXx27a872
         zZXA==
X-Gm-Message-State: AJIora8yORaYwmeGsY4nm8zOOCm7wi8nYGEJ1ALD15cxQP+UlgxVd2eY
        wFO40k8Ze0ihOhpDLHrRj5EdtA==
X-Google-Smtp-Source: AGRyM1uZ3WBzquNjBbsAtCg2f8rxYP66Ap6xJiLzcLDhbvbJjxlKebC8h9hmhECn9Lm4zRcgzb70Bg==
X-Received: by 2002:a17:903:41c8:b0:16c:59be:7651 with SMTP id u8-20020a17090341c800b0016c59be7651mr14649124ple.13.1657909327764;
        Fri, 15 Jul 2022 11:22:07 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id x63-20020a628642000000b0052514384f02sm4217482pfd.54.2022.07.15.11.22.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Jul 2022 11:22:07 -0700 (PDT)
Message-ID: <0f5cab9f-9c18-7114-2ca1-ad4eff13eb63@kernel.dk>
Date:   Fri, 15 Jul 2022 12:22:05 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH] io_uring: Don't require reinitable percpu_ref
Content-Language: en-US
To:     =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>
Cc:     asml.silence@gmail.com, fam.zheng@bytedance.com,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        roman.gushchin@linux.dev, usama.arif@bytedance.com
References: <8a9adb78-d9bb-a511-e4c1-c94cca392c9b@kernel.dk>
 <20220715174501.25216-1-mkoutny@suse.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220715174501.25216-1-mkoutny@suse.com>
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

On 7/15/22 11:45 AM, Michal Koutn? wrote:
> The commit 8bb649ee1da3 ("io_uring: remove ring quiesce for
> io_uring_register") removed the worklow relying on reinit/resurrection
> of the percpu_ref, hence, initialization with that requested is a relic.
> 
> This is based on code review, this causes no real bug (and theoretically
> can't). Technically it's a revert of commit 214828962dea ("io_uring:
> initialize percpu refcounters using PERCU_REF_ALLOW_REINIT") but since
> the flag omission is now justified, I'm not making this a revert.

Thanks, applied manually for 5.20 (new file location).

-- 
Jens Axboe

