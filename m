Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A315059062D
	for <lists+io-uring@lfdr.de>; Thu, 11 Aug 2022 20:08:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231352AbiHKSIt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 11 Aug 2022 14:08:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbiHKSIs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 11 Aug 2022 14:08:48 -0400
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D15AA220C
        for <io-uring@vger.kernel.org>; Thu, 11 Aug 2022 11:08:45 -0700 (PDT)
Received: by mail-il1-x134.google.com with SMTP id z13so597565ilq.9
        for <io-uring@vger.kernel.org>; Thu, 11 Aug 2022 11:08:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=HE2GTmyQrCwEOBrwByEM4ojMdnw0XmOJ6nETNaA+tWc=;
        b=xzhIvn/Es2ksZd/4FowlLsVez2Ux9GgSuHNnZvaZjIvFT2fWHKLGIoIn1GnsLA64EI
         6u6LyKmftldJvTYGE+BWMPc0s2BSe7C8pWCW20M6yEIWK2zJAteyGpGi0TtDQDRfwpLJ
         PNspl7RZeO6fMD6GcMRBjY/rzqlDQsK4kuc+pddM4M2uP2f6ZJXtToJ+Xc0MOemVpNtc
         4luhbyFbaXS72WENdfObXdy9HjjhdT8CPRWeYnJj6UzR12mkZSI6LArvWNAixEnN81Yt
         OLKVHNcSXi0wKxEjavr4sLEANhqA4n+CQ+Fvi9W1CSnu+7YaLhaO4ivzW/ceJeLf6Q7o
         BLAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=HE2GTmyQrCwEOBrwByEM4ojMdnw0XmOJ6nETNaA+tWc=;
        b=eUiWA+UrNru+gG8XjWUTESG9rjnxS0+9H/q/9v9ZIgimf8gjRp0D3Y1SHjWFSTrMX+
         95G4tEfoolfilZJpk8Ge0yV5fwZrDfRg7D3g6KkT6UF6cjoUicwGnRuQ/K1ojGHggu2C
         y8Cbg4h61C47LNvmAYzhsqvIH7NWqg8mK81X/OOGue/p00pF/lZh+4PSLvCeF+XF2MG+
         UOhUNDN0j2IMEk/1sDDb1xi9SmJ52T/VfxLqG2LThQTXMzaMOvwmIisOdbFg5NDjGPy/
         PDZynfSQJOgWpL+rET1QvXVqDixIy21mqy57VyWTLawwobBtTV3fSvbxCDel982LrK4o
         gBpQ==
X-Gm-Message-State: ACgBeo3JDVWfyFls3USqaRB1UZIzQhp23buWw8uDw6PTTHock70UQxL+
        KnMNvKvnU4ZXO1ebIRQZngjr8Q==
X-Google-Smtp-Source: AA6agR78c4WWGkDE6zw4G5hqtIjA80yC3XPmKp+nAcWBT2GVHhzFZ9pcLFCmufqA/oVy4rxFYTGo/Q==
X-Received: by 2002:a92:c56e:0:b0:2e0:e44c:7296 with SMTP id b14-20020a92c56e000000b002e0e44c7296mr198724ilj.23.1660241324588;
        Thu, 11 Aug 2022 11:08:44 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id i9-20020a02c609000000b003434bb60a03sm47433jan.158.2022.08.11.11.08.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Aug 2022 11:08:44 -0700 (PDT)
Message-ID: <ae138911-c669-5332-19ca-423d8f1a447b@kernel.dk>
Date:   Thu, 11 Aug 2022 12:08:43 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH] io_uring: fix error handling for io_uring_cmd
Content-Language: en-US
To:     Kanchan Joshi <joshi.k@samsung.com>
Cc:     anuj20.g@samsung.com, io-uring@vger.kernel.org, ming.lei@redhat.com
References: <CGME20220811092503epcas5p2e945f7baa5cb0cd7e3d326602c740edb@epcas5p2.samsung.com>
 <20220811091459.6929-1-anuj20.g@samsung.com>
 <166023229266.192493.17453600546633974619.b4-ty@kernel.dk>
 <f172af9b-2321-c819-2e29-357d4f130159@kernel.dk>
 <20220811173553.GA16993@test-zns>
 <9b80f3d8-bef6-11a2-deb2-f94750414404@kernel.dk>
 <20220811175709.GB16993@test-zns>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220811175709.GB16993@test-zns>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/11/22 11:57 AM, Kanchan Joshi wrote:
>>> BTW, we noticed the original issue while testing fixedbufs support.
>>> Thinking to add a liburing test that involves sending a command which
>>> nvme will fail during submission. Can come in handy.
>>
>> I think that's a good idea - if you had eg a NOP linked after a passthru
>> command that failed, then that would catch this case.
> 
> Right. For now in liburing test we don't do anything that is guranteed
> to fail from nvme-side. Test issues iopoll (that fails) but that failure
> comes from io_uring itself (as .iopoll is not set). So another test that
> will form a bad passthru command (e.g. wrong nsid) which only nvme can
> (and will) fail.

Yes, that's a good idea in general, testing only successful completions
doesn't really give full coverage.

-- 
Jens Axboe

