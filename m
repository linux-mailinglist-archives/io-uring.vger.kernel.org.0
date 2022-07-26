Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EA5F58179E
	for <lists+io-uring@lfdr.de>; Tue, 26 Jul 2022 18:41:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230108AbiGZQl1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 Jul 2022 12:41:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239561AbiGZQlK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 Jul 2022 12:41:10 -0400
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79E241CB
        for <io-uring@vger.kernel.org>; Tue, 26 Jul 2022 09:40:47 -0700 (PDT)
Received: by mail-il1-x131.google.com with SMTP id h14so7507332ilq.12
        for <io-uring@vger.kernel.org>; Tue, 26 Jul 2022 09:40:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=0ekOuEplGSLhpA/XIfl9FiICRyZLhCP7lUSeoVmDQ0g=;
        b=Iw2nyVM7VOxNXZzvO4a1o5cikRgTk8wrHoxmGKSCEQtQQ+vzmqtTwEbNBnqfAgGfhL
         rSdj+0zmMxIT5F2v3LV1bb0E9Q4+8d4MgUGc/MGUiMuw7lBNP0IRNLCX8WGKI946wnXd
         vvKliGmryKckBk0eySJ8VWTYJCMCvpeQLJi+P8LErO/R8shabPuiOMVANn9Zba1QWmJ6
         9BPZvnafQYxoS+BCxtezjyKDUysSRjSvWhqdmwBt+M9J/L3lkJ4UKsfE2LyJ/474NqAM
         hslKvAg+0hnxi+EhfR2zvc58Hx5lYjiLPKh2nLdzb9tj3XziAQbUQg1EoFOmZluFgVKq
         UzZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=0ekOuEplGSLhpA/XIfl9FiICRyZLhCP7lUSeoVmDQ0g=;
        b=VH7Xgve7xPU5fjUzG7kTCGn7DKhYT+tu8RKYghi3lz1wwFkhjbKhIc/eHoPNKfBoMC
         vdJc9fiB2JyuHbBtMVOCbnCPYubjonW2biHsbX1iZyVTKPqHUq0wNaCAz7BkwmwkM+n5
         0s47Miy7uu/WvBVPxk1DlVSCM3cmCdD/4qujHYlDLPJytOs4iOQ63dxUbaIRdpYZhVji
         mRnbCNYXn61vo6aL5d07cOSVyQ3ShES9cOG9aEyRjCaMQ+1XiAi1OUz5bk0nzOO23lar
         3aKv3D9nhGLv5fAgYquKv3c6CWZp/7z6hX4V21dO9SACjUPzWJUddRsdzBuH6IMrdxMX
         MVsw==
X-Gm-Message-State: AJIora+r/Z4lkczyzRjEiysKfVUTbR9ZRxMLS1D2vLu/AatQYQze/DLr
        oC7QlfdegEXA4HZUJeobfAtXCQ==
X-Google-Smtp-Source: AGRyM1sW5G0gSMSwzuppg2PkrINaLfW4K0AbzD0x3C23q6wJ25SSoSSxjZ3cE1iEl5ivWCMCqO1iOg==
X-Received: by 2002:a05:6e02:1545:b0:2dc:c6f9:8f99 with SMTP id j5-20020a056e02154500b002dcc6f98f99mr6799506ilu.47.1658853646865;
        Tue, 26 Jul 2022 09:40:46 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id a8-20020a92ce48000000b002dd1de03f3dsm4561224ilr.4.2022.07.26.09.40.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Jul 2022 09:40:45 -0700 (PDT)
Message-ID: <d14c5be4-b9d8-a52c-12db-6f697784fd9e@kernel.dk>
Date:   Tue, 26 Jul 2022 10:40:44 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH liburing 0/5] multishot recvmsg docs and example
Content-Language: en-US
To:     Ammar Faizi <ammarfaizi2@gmail.com>
Cc:     Dylan Yudaken <dylany@fb.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Facebook Kernel Team <kernel-team@fb.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>
References: <20220726121502.1958288-1-dylany@fb.com>
 <165885259629.1516215.11114286078111026121.b4-ty@kernel.dk>
 <e1d3c53d-6b31-c18b-7259-69467afa8088@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <e1d3c53d-6b31-c18b-7259-69467afa8088@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/26/22 10:32 AM, Ammar Faizi wrote:
> 
> 
> On 7/26/22 11:23 PM, Jens Axboe wrote:
>> [5/5] add an example for a UDP server
>>        commit: 61d472b51e761e61cbf46caea40aaf40d8ed1484
> 
> This one breaks clang-13 build, I'll send a patch.

Hmm, built fine with clang-13/14 here?

-- 
Jens Axboe

