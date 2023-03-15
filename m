Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A1346BB772
	for <lists+io-uring@lfdr.de>; Wed, 15 Mar 2023 16:19:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229459AbjCOPTm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Mar 2023 11:19:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230283AbjCOPTm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Mar 2023 11:19:42 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44E57574EC
        for <io-uring@vger.kernel.org>; Wed, 15 Mar 2023 08:19:41 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id h83so239767iof.8
        for <io-uring@vger.kernel.org>; Wed, 15 Mar 2023 08:19:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1678893580;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zEfoBf9a+LfY4K4VAZ5rieVI/pstbtfljX5WCa6988w=;
        b=Csuon2TTNRZNBXri219l6EVL5j3pM7uaY21k08mdvR3E3bPLpgOrnQUw+4CpnotFHt
         5PkveMDEC6sKBpruU8xnHnC6GbbKssAzMDtRYkCDKOfHOhzSgG5O9NsOpfc69rA+iznJ
         o1pg2lp2HlJV2xN5S2AnbdAiMkfH8YxF5hF3x3DuN/mwQPxrdxoQ5VjS7D6KiTPq8m2L
         4ViJXPwEvOZQokbx+7omd49xkxL9F2iRB9hbG6Pl0+MbcvPA39Q3sqt5Q3GhCvWjMbKS
         jMPDzehhUPMUDqQDM9vqshy7rrWssE/lCISL5pVZnYpGXR6w1SF+2crkQtM1YlkDCImD
         U/0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678893580;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zEfoBf9a+LfY4K4VAZ5rieVI/pstbtfljX5WCa6988w=;
        b=OBweJZUzrAZw7LqAaoOMN4IsOqcyNX1nktVXFtArPcILlfkTNCmgsifQr9iWTo2sUS
         4tLubJxH/bRbgotpQloBmGC2aIrn/zDm1in3UWH37K6Adr7v7OH9twfL9Xc15SnKZqYb
         ZcagvwfbplqX1PkK/X5XK+aXBSHIMdj/kwR4cSUXqQa9FNh6kqLJbJGTSPcMwyREcM6T
         2xxs7eNedF4iC0LxooUk8bdSwGUU77/3o5KQXY4WEcq7V6zzn08TB7jVXa8CXHsyInAa
         A9+OopBYeMNnkhkV5YXJh6ICh4XwVWs6bBqDNHdOUtkQrcuwH4BBSfkzdA8gdYvli5f0
         aNEQ==
X-Gm-Message-State: AO0yUKWGNXGdUCW93CaHyxUr1VveWsnDnFW5I3HKZvwdtgXzbUF8uzGO
        aBUU2vXqq/jGhn8z6Benw7BxDg==
X-Google-Smtp-Source: AK7set8sFIdxdN2wm5CZL9sfTj25cucotSu2g/bKff7FlyaG9W+Dw8K8rPv0UXXbFf5rlONEQ/1Pmg==
X-Received: by 2002:a5d:8587:0:b0:74e:5fba:d5df with SMTP id f7-20020a5d8587000000b0074e5fbad5dfmr10605776ioj.0.1678893580641;
        Wed, 15 Mar 2023 08:19:40 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id b6-20020a05663801a600b004061ac1ddd1sm529805jaq.169.2023.03.15.08.19.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Mar 2023 08:19:40 -0700 (PDT)
Message-ID: <bc332b16-2ef6-80ea-40c4-27547c3b2ea0@kernel.dk>
Date:   Wed, 15 Mar 2023 09:19:39 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: Resizing io_uring SQ/CQ?
Content-Language: en-US
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        Ming Lei <ming.lei@redhat.com>
Cc:     io-uring@vger.kernel.org
References: <20230309134808.GA374376@fedora>
 <ZAqKDen5HtSGSXzd@ovpn-8-16.pek2.redhat.com>
 <2f928d56-a2ff-39ef-f7ae-b6cc1da4fc42@kernel.dk>
 <20230310134400.GB464073@fedora> <ZAtJPG3NDCbhAvZ7@ovpn-8-16.pek2.redhat.com>
 <20230315151524.GA14895@fedora>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230315151524.GA14895@fedora>
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

On 3/15/23 9:15 AM, Stefan Hajnoczi wrote:
> Hi Ming and Jens,
> It would be great if you have time to clarify whether deadlocks can
> occur or not. If you have any questions about the scenario I was
> describing, please let me know.

I don't believe there is. In anything not ancient, you are always
allowed to submit and the documentation should be updated to
describe that correctly. We don't return -EBUSY for submits with
overflow pending.

-- 
Jens Axboe


