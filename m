Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20B2F50ABFC
	for <lists+io-uring@lfdr.de>; Fri, 22 Apr 2022 01:33:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442562AbiDUXgA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 21 Apr 2022 19:36:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442558AbiDUXf7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 21 Apr 2022 19:35:59 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60DD13F89E
        for <io-uring@vger.kernel.org>; Thu, 21 Apr 2022 16:33:07 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id l127so6369957pfl.6
        for <io-uring@vger.kernel.org>; Thu, 21 Apr 2022 16:33:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:subject:to:cc
         :references:content-language:in-reply-to:content-transfer-encoding;
        bh=8PUlXciI2A9evvTWD64wT0yzak9WMui2iFOCoQYp1Qo=;
        b=M644v8gEFmCO5jX3JuVj80cOKUPZYNigSrWDmIKTxN4iBYN7RRx17H/WXIKtybkzOs
         gHuGCuUb5/2Y4q0PAwBhVwIAH7NEdJUAXNk0R3bvWjKaauknVSIE+osK6C31khyWSGqV
         +/MIN30NvG/1bL/x64Ej4XKH14WrlwlOEbvkequaDw82s5dagxGthjJHsa3E36Vzd2um
         1RGwRHC37VQU52cdbBupVxlkWqO0+6u0VHlVAgx4qg31wljljZeki2AIAmXbQu2T6NCh
         GAFSLCJw84pZSfkw2JFKYn4dgW5RciQPm368mB4wGdkuDVFjwKuw/rAhmlCbLu+HnBiq
         iGcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:from
         :subject:to:cc:references:content-language:in-reply-to
         :content-transfer-encoding;
        bh=8PUlXciI2A9evvTWD64wT0yzak9WMui2iFOCoQYp1Qo=;
        b=HPqeYxbUeP9OVPf2AmE7uRLcdM+MWXJ7VMGRgjJ4q9GIEPbw9EHypndwJHZCjcCV5l
         Bn6ZoYjMXezyWRAbXY9Lbus1HuyYoaoHrKVhX2VJwwwHXmXEStGOEBG6P3Sl+JjI8oWx
         JgPbqmutrAlj16BvEbdRyHmFpK4Nv2N6peUbf9n1r3814KpNenzJgaGWQGb5HAbOTTMO
         vb4UvsAvMfZU5+a5w+2Q8iAq4cqCwxfY5Jy8W19PiSDMqIcLG6IOAWaKAjA4n74dPXVz
         0rAyIufZGEedCFFATFqROF7w1KWqFJx84anVA6ws54wtswIldMYPJ7AMYGM4PaP8hDJ1
         E2Lg==
X-Gm-Message-State: AOAM530BCOansEUMcEroCg3Uy6QAxnv6e1TY03CPHJUjBJ+I9kMSnT3T
        SHd3mTlHh1f6Zh4NA5PcJXY/BA==
X-Google-Smtp-Source: ABdhPJzuZYv0sW9q8OZoDmmfbOPX+UHh3VAIdTDWRpkMgZKFtpJVJq2u5sEBYNthTN9h5ACG9jDyYQ==
X-Received: by 2002:a65:60c1:0:b0:39d:9c28:909a with SMTP id r1-20020a6560c1000000b0039d9c28909amr1552046pgv.352.1650583986827;
        Thu, 21 Apr 2022 16:33:06 -0700 (PDT)
Received: from ?IPV6:2600:380:4927:368a:ac15:d192:1695:2335? ([2600:380:4927:368a:ac15:d192:1695:2335])
        by smtp.gmail.com with ESMTPSA id w7-20020aa79547000000b0050ad0e82e6dsm194749pfq.215.2022.04.21.16.33.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Apr 2022 16:33:06 -0700 (PDT)
Message-ID: <b32cf3e2-a68c-b1b0-f3da-72e5f0b9d86c@kernel.dk>
Date:   Thu, 21 Apr 2022 17:33:04 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
From:   Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 6/6] io_uring: allow NOP opcode in IOPOLL mode
To:     Dylan Yudaken <dylany@fb.com>
Cc:     io-uring <io-uring@vger.kernel.org>,
        "Pavel Begunkov (Silence)" <asml.silence@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        FB Kernel Team <kernel-team@fb.com>,
        Dylan Yudaken <dylany@fb.com>
References: <20220421091345.2115755-1-dylany@fb.com>
 <20220421091345.2115755-7-dylany@fb.com>
Content-Language: en-US
In-Reply-To: <20220421091345.2115755-7-dylany@fb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Apr 21, 2022 at 3:17 AM Dylan Yudaken <dylany@fb.com> wrote:
>
> This is useful for tests so that IOPOLL can be tested without requiring
> files. NOP is acceptable in IOPOLL as it always completes immediately.

This one actually breaks two liburing test cases (link and defer) that
assume NOP on IOPOLL will return -EINVAL. Not a huge deal, but we do
need to figure out how to make them reliably -EINVAL in a different
way then.

Maybe add a nop_flags to the usual flags spot in the sqe, and define
a flag that says NOP_IOPOLL or something. Require this flag set for
allowing NOP on iopoll. That'd allow testing, but still retain the
-EINVAL behavior if not set.

Alternatively, modify test cases...

I'll drop this one for now, just because it fails the regression
tests.

-- 
Jens Axboe

