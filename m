Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D4E8742B5E
	for <lists+io-uring@lfdr.de>; Thu, 29 Jun 2023 19:37:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232096AbjF2Rhn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 29 Jun 2023 13:37:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232054AbjF2Rhm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 29 Jun 2023 13:37:42 -0400
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EB15A1;
        Thu, 29 Jun 2023 10:37:41 -0700 (PDT)
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-666e97fcc60so873806b3a.3;
        Thu, 29 Jun 2023 10:37:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688060261; x=1690652261;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=x9y4omLSTUEBUieUvzd6rekQFuwG36HDtIqDRR92oWw=;
        b=L8xZmek1h/x0rva9tU69miFoE5MULXsaod2VSWvMe+5kS0ejIxkD8iBSALs6/BVDQS
         OhsBhCuW1h+PzNeeYFXYSB8pPf7jBK9YsMmWlcWNy0e0u6ctA6Y/2hod5STItXIYHihm
         exMBPDhcyeGOZJfryjgB4V6G11q2JARkDqdhvVUjLwsR+45yZ2dIIZ6xyoKnLkwM49uI
         NTPbWRrJ/BJelK0xLjah0hX94u/FaHX5zgk2QToMw2usw6v7zPQI6SVVQE2PI9IL1iIB
         OuNVLRDsIEKEMTEgELe6RDBcnsxOboRtN4p4vn+EB5AYYns+yAbtHpyGsxL1/mpdBtvS
         QqdA==
X-Gm-Message-State: ABy/qLaLIrbRj2gZrqJUvoTqIBzKBg2jq5kdVYuXVtB5ZsRy0NmTxPpI
        JUXLuM8iw255Du19BpaaT+I=
X-Google-Smtp-Source: APBJJlFTlk8wIDskGAI9zd2Hj0xnmbIxFkWni+tt21MHkFoarpjEPMCqwJmv4CcuTN/y1U6kJMmJFg==
X-Received: by 2002:a05:6a00:1402:b0:681:6169:e403 with SMTP id l2-20020a056a00140200b006816169e403mr587306pfu.8.1688060260830;
        Thu, 29 Jun 2023 10:37:40 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:a601:6da1:e847:d4b1? ([2620:15c:211:201:a601:6da1:e847:d4b1])
        by smtp.gmail.com with ESMTPSA id i26-20020aa7909a000000b006661562429fsm8847746pfa.97.2023.06.29.10.37.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Jun 2023 10:37:40 -0700 (PDT)
Message-ID: <6b7f5603-8ac1-6f29-798c-02d0b9a5543e@acm.org>
Date:   Thu, 29 Jun 2023 10:37:36 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v2 1/1] Add a new sysctl to disable io_uring system-wide
Content-Language: en-US
To:     Matteo Rizzo <matteorizzo@google.com>
Cc:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org, jordyzomer@google.com, evn@google.com,
        poprdi@google.com, corbet@lwn.net, axboe@kernel.dk,
        asml.silence@gmail.com, akpm@linux-foundation.org,
        keescook@chromium.org, rostedt@goodmis.org,
        dave.hansen@linux.intel.com, ribalda@chromium.org,
        chenhuacai@kernel.org, steve@sk2.org, gpiccoli@igalia.com,
        ldufour@linux.ibm.com, bhe@redhat.com, oleksandr@natalenko.name
References: <20230629132711.1712536-1-matteorizzo@google.com>
 <20230629132711.1712536-2-matteorizzo@google.com>
 <a0c8d74a-dcfe-78a7-74bd-4447ed6944dc@acm.org>
 <CAHKB1wKbSoK+=ceM_WLgBConNaua=0UPQv9ZmDp6LNXh3QNr=Q@mail.gmail.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <CAHKB1wKbSoK+=ceM_WLgBConNaua=0UPQv9ZmDp6LNXh3QNr=Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/29/23 08:28, Matteo Rizzo wrote:
> On Thu, 29 Jun 2023 at 17:16, Bart Van Assche <bvanassche@acm.org> wrote:
>>
>> On 6/29/23 06:27, Matteo Rizzo wrote:
>>> +static int __read_mostly sysctl_io_uring_disabled;
>>
>> Shouldn't this be a static key instead of an int in order to minimize the
>> performance impact on the io_uring_setup() system call? See also
>> Documentation/staging/static-keys.rst.
>>
> Is io_uring_setup in any hot path? io_uring_create is marked as __cold.

I confused io_uring_setup() with io_uring_enter() so please ignore my comment.

Bart.
