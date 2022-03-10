Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AB144D4E3B
	for <lists+io-uring@lfdr.de>; Thu, 10 Mar 2022 17:12:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235566AbiCJQNU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 10 Mar 2022 11:13:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241731AbiCJQNI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 10 Mar 2022 11:13:08 -0500
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA03118FAC7
        for <io-uring@vger.kernel.org>; Thu, 10 Mar 2022 08:12:07 -0800 (PST)
Received: by mail-io1-xd33.google.com with SMTP id r2so6970982iod.9
        for <io-uring@vger.kernel.org>; Thu, 10 Mar 2022 08:12:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=VrMP28PXxg1sdoQofpkifvSHZfiMzWbnkbcqUN3FEXg=;
        b=QXErd6zfgub0c84rJq/mvfh7tCc44I7crClsWOlOTFHEZy94UOMbrGPoIzylpNQbdF
         Var/a/RmP2gfYY/rUWEXP/n6j1vF8A7Iheaza8PfA6xP4zZSWHlHZj+AxMv7g0XJUni3
         xy9XMzs0cusVrUYHtdCXP4luMOxDy7+tXNYoOzla2FY46v+nOckCU82zduFxiuo0wKv7
         vIFJIF2OmphlllCcnDyHDQLI0zlCMXNEG3B8wtRl6XE0qJMlyDN+ag3kPVgPNh++5ac2
         Ey2g8/vzi9TEUKOpoWWqfOtn96EpiG6zMApp2tbX8sUTTc6e34FdY5WhXXEV0vZxHdzA
         v51Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=VrMP28PXxg1sdoQofpkifvSHZfiMzWbnkbcqUN3FEXg=;
        b=wyxUU1QKXif49hUk0GIkWGof/D7BHfxxUAF+0KBI65eRgmTI5CvprEqUaVqWtoYg87
         g6YFsoXHejpx07Fl2FhWunJirdfCHqi0sHH4WpkWeaS7x5OTvv7f34UFqndJOHUAP53J
         vx9MoObHK/uvZcEVdQs4FZVT8MspUZ1v/wvXNTDR4RjKNebl6y1cUOmQsVNC8PQB1NH/
         HtCgNcNqkeeDDL+rCKTNEHp5MDkgtQs1Y+JxSvOBd/otA/4sSALuDonrzzAhyJc8Smne
         FpDu4VzL4VvEYFbvjGw7JVQ3HST3oWc8xEF/RILmSCeYkDDOqcG+KKbmzicQtK1tY/FD
         5YLA==
X-Gm-Message-State: AOAM531wRaD8OWdnJTeWNH4/hRz3yoMNTss0HPQbaIEqPghUbE2C8rmd
        JOBPo49jfR+XCvtJNu0noV3IAMdqSMYVBQ9O
X-Google-Smtp-Source: ABdhPJxYOk9QhSfNH0hgJKNjDcE4LyX1ORL+Y+RiWxNddTMUt8OP2kSmrO/7VCvf0Spww4TH5uKTFg==
X-Received: by 2002:a5d:85d2:0:b0:5ed:a17c:a25c with SMTP id e18-20020a5d85d2000000b005eda17ca25cmr4411895ios.85.1646928726744;
        Thu, 10 Mar 2022 08:12:06 -0800 (PST)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id b11-20020a92c56b000000b002c76a618f52sm758899ilj.63.2022.03.10.08.12.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Mar 2022 08:12:06 -0800 (PST)
Message-ID: <2ba7fb27-0eec-e2a2-c986-529175c79cbe@kernel.dk>
Date:   Thu, 10 Mar 2022 09:12:05 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: Sending CQE to a different ring
Content-Language: en-US
To:     Artyom Pavlov <newpavlov@gmail.com>, io-uring@vger.kernel.org
References: <bf044fd3-96c0-3b54-f643-c62ae333b4db@gmail.com>
 <e31e5b96-5c20-d49b-da90-db559ba44927@kernel.dk>
 <c4a02dbd-8dff-a311-ce4a-e7daffd6a22a@gmail.com>
 <478d1650-139b-f02b-bebf-7d54aa24eae2@kernel.dk>
 <a13e9f56-0f1c-c934-9ca7-07ca8f82c6c8@gmail.com>
 <9f8c753d-fed4-08ac-7b39-aee23b8ba04c@kernel.dk>
 <f12c2f2b-858a-421c-d663-b944b2adb472@kernel.dk>
 <0cbbe6d4-048d-9acb-2ea4-599d41f8eb28@gmail.com>
 <1bfafa03-8f5f-be7a-37a5-f3989596ff5a@kernel.dk>
 <9a23cd0e-b7eb-6a5c-a08d-14d63f47bb05@kernel.dk>
 <22ed0dd2-9389-0468-cd92-705535b756bb@gmail.com>
 <21c3b3b6-31bb-1183-99b7-7c8ab52e953d@kernel.dk>
 <4b2ee3a3-d745-def3-8a15-eb8840301247@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <4b2ee3a3-d745-def3-8a15-eb8840301247@gmail.com>
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

On 3/10/22 9:07 AM, Artyom Pavlov wrote:
>>> Yes, passing positive result value would make more sense than PID of
>>> submitter, which is rarely, if ever, needed. IIUC we would not be able
>>> to use linking with such approach, since sqe->len has to be set in
>>> user code based on a received CQE, but I guess it should be fine in
>>> practice.
>>
>> Right, and using sqe->len and passing it through makes a lot more sense
>> in general as you can pass whatever you want there. If you want to use
>> the pid, you can use it like that. Or for whatever else you'd want. That
>> gives you both 'len' and 'user_data' as information you can pass between
>> the rings.
>>
>> It could also be used as `len` holding a message type, and `user_data`
>> holding a pointer to a struct. For example.
> 
> I like IORING_OP_WAKEUP_RING with sqe->len being copied to
> cqe->result. The only question I have is how should "negative" (i.e.
> bigger or equal to 2^31) lengths be handled. They either should be
> copied similarly to positive values or we should get an error.

Any IO transferring syscall in Linux supports INT_MAX as the maximum in
one request, which is also why the res field is sized the way it is. So
you cannot transfer more than that anyway, hence it should not be an
issue (at least specific to io_uring).

> Also what do you think about registering ring fds? Could it be
> beneficial?

Definitely, it'll make the overhead a bit lower for issuing the
IORING_OP_MSG_RING (it's been renamed ;-) request.

-- 
Jens Axboe

