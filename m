Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 477334CC8D7
	for <lists+io-uring@lfdr.de>; Thu,  3 Mar 2022 23:26:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231772AbiCCW1Q (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 3 Mar 2022 17:27:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231307AbiCCW1P (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 3 Mar 2022 17:27:15 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EB7610E045
        for <io-uring@vger.kernel.org>; Thu,  3 Mar 2022 14:26:29 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id z12-20020a17090ad78c00b001bf022b69d6so5203894pju.2
        for <io-uring@vger.kernel.org>; Thu, 03 Mar 2022 14:26:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=XACQHlLi9pUnVeNk0HA5X0mx+lcoUHDvDnGUswYcJtA=;
        b=w+8YRbRwQg260/7GntEetGkoMqft3aGj+UT6ki1OGztcghKzLNdFep30mPhE9FkIas
         HwqOh89GbrPrLrD+7YT//gfXLcCM2JIQkkKROrl6s3d2j94Mi4Wn8fT6GBaQ7xjsgY7T
         2R8Xq3rkBD2qTUlAZyNdFvfGoUxkAs5ZjmedMP+OppQu5cGsFhgAv4DzgeBJYzGwTdb5
         I6rr152AdkqM9iMnF7PeHFaCDmAaECqdxS2B0yCdTTo1Fzcxakcy34iozz1alfyNV913
         JDBBW6yINjLLtOXqf9gOi+JEjhwMZCd2Jjhv39JX4jgjwxjrHwVSSzrtvW6fCEBg3Lf7
         VqLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=XACQHlLi9pUnVeNk0HA5X0mx+lcoUHDvDnGUswYcJtA=;
        b=brXf9EJTneXXQ2vmgVllzDADK/rDigYMalyg+kEixaNj5MhkoE3fADCLE3nEZZFuly
         U+BnbMvp3QIyI6KnUPTOs2cO16MBj9IeWtR9ksehS359GCnGwpP0uVPiVr56StpYcxej
         rHMNu6obLpvrEZKZj1JACa2CrIHtujLbjWl3nD9XRbfInNQ3JSjISyhn7vzCVb31Llcc
         PEFs64Y/n2qgCQ6hIh264F3BcTHuygA5+J3Ef6wGquzMQb0pK2BU5pJ+fu+KFHmSJwoG
         psrMgAccWGhBCC0Tv2KhumNCMW9aON/X8aMIksWYSMOpKBcPRoObp9utS5gtODTsPVQV
         t7TA==
X-Gm-Message-State: AOAM531bPl5w4Kp4ggea1iEfufrc/SkHFMClu3nNvpDDrZFKf3KNOWGQ
        tvSCU1QeCHEjR0UJ1tsnxFWhdaDRk0zc8Q==
X-Google-Smtp-Source: ABdhPJxSQQYEaB8Vp3FcN+1sNhZJSDOwLtNjVwShnYQwTJCxI7T02lcg5xonjh5QWcbI3zNDFfgaew==
X-Received: by 2002:a17:902:cecf:b0:151:a56d:dd1f with SMTP id d15-20020a170902cecf00b00151a56ddd1fmr7044381plg.12.1646346388967;
        Thu, 03 Mar 2022 14:26:28 -0800 (PST)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id ck20-20020a17090afe1400b001bd0494a4e7sm3192213pjb.16.2022.03.03.14.26.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Mar 2022 14:26:28 -0800 (PST)
Message-ID: <757dd042-5a5a-b7e5-dc4c-bc998d66d403@kernel.dk>
Date:   Thu, 3 Mar 2022 15:26:27 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH] io_uring: add io_uring_enter(2) fixed file support
Content-Language: en-US
To:     Vito Caputo <vcaputo@pengaru.com>
Cc:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org, asml.silence@gmail.com
References: <20220303052811.31470-1-xiaoguang.wang@linux.alibaba.com>
 <4f197b0e-6066-b59e-aae0-2218e9c1b643@kernel.dk>
 <528ce414-c0fe-3318-483a-f51aa8a407b9@kernel.dk>
 <040e9262-4ebb-8505-5a14-6f399e40332c@kernel.dk>
 <951ea55c-b6a3-59e4-1011-4f46fae547b3@kernel.dk>
 <66bfc962-b983-e737-7c36-85784c52b7fa@kernel.dk>
 <8466f91e-416e-d53e-8c24-47a0b20412ac@kernel.dk>
 <20220303222435.je5b66aqkc5ddm4u@shells.gnugeneration.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220303222435.je5b66aqkc5ddm4u@shells.gnugeneration.com>
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

>> In trying this out in applications, I think the better registration API
>> is to allow io_uring to pick the offset. The application doesn't care,
>> it's just a magic integer there. And if we allow io_uring to pick it,
>> then that makes things a lot easier to deal with.
>>
>> For registration, pass in an array of io_uring_rsrc_update structs, just
>> filling in the ring_fd in the data field. Return value is number of ring
>> fds registered, and up->offset now contains the chosen offset for each
>> of them.
>>
>> Unregister is the same struct, but just with offset filled in.
>>
>> For applications using io_uring, which is all of them as far as I'm
>> aware, we can also easily hide this. This means we can get the optimized
>> behavior by default.
>>
> 
> Did you mean s/using io_uring/using liburing/ here?

I did, applications using liburing as their io_uring interface.

-- 
Jens Axboe

