Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 796194D4EFF
	for <lists+io-uring@lfdr.de>; Thu, 10 Mar 2022 17:26:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234018AbiCJQ0Q (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 10 Mar 2022 11:26:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238997AbiCJQ0O (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 10 Mar 2022 11:26:14 -0500
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03AA427CD4
        for <io-uring@vger.kernel.org>; Thu, 10 Mar 2022 08:25:11 -0800 (PST)
Received: by mail-io1-xd29.google.com with SMTP id c23so7064250ioi.4
        for <io-uring@vger.kernel.org>; Thu, 10 Mar 2022 08:25:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=BUGqGiezS6p4bNtSZq5YD5C44hCgFORLESfkPIhH+HA=;
        b=m5OrC4NuzAyKIbSQKj7rxdxwi2CmruEgTuidaTIUBIMTYnA4LYUJ73UB+Gqic/klao
         PHH4PXregIWVRCu4sDCVzIqymgaT5T3Rqyl9CPrLYhFfz7aFQ0U9e4HZv7d1USSldVGz
         jzpjWnIBa8U6i0eEdevktmrWSewt/htHwSLokjPzTE/No1Rfuk3mTbr/OIqiEH9GPwqx
         +/3COtzjfvRx5p7Q98VuzjWr+vjoaiOP+J8m3BUXWzpMzCR/G7PS/eOr9S6Uo9sJ0Yuw
         9NGVPutnmV6ZAbMrTNEo0neRuu+3pKF+7IcfdKu2s6Zyy7GGTSsCURhS2NGzZTyUnWP+
         ppgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=BUGqGiezS6p4bNtSZq5YD5C44hCgFORLESfkPIhH+HA=;
        b=gz8OS04kljBgaCTvJg5uKqvIYeWGAG58sSAsUnx2M7oop4ddxrnUoOd0O8bZnuFDzL
         M4hmp+BC2+aELFMogsiZ3FEg6yZMLG0pJNHMKDqlI+S4sv40tAU3tfATufxaFH53rnYk
         xeQD8davwoFYCOfAAGgJx9+y7zTb0IZf041VZ5htcsZxM2OrDoQMSMKTeGHyUV6YvrcX
         zpaoJO0Bd4oHgHeFQ+kfz0Ax8mtHcBVBhWQuxpX3iE2bTzb1oZgbjkHm2Qvjlpg8T8x6
         3Wc5pdAzSQiR8Ib9MZWX+5cHnu6p3Ts7aQD6ClP2383ZQyEpqEZZm/F7de5oYPx4vRa/
         kVgg==
X-Gm-Message-State: AOAM532clPHiiHwTo88F43oFn5o71EU13/8EmOb2NGeKcw6aQtn+VwjC
        HU1wZ41zh7QBeaUAnUOPbxrASm62pPUCfSpj
X-Google-Smtp-Source: ABdhPJxJxH1rw9cxt+Dm4HRpaLNgwrK+oxtc0Y0Qw565CicyHhOGEAmMF34I74mSqJ5a2kJAdQszuA==
X-Received: by 2002:a02:782b:0:b0:317:ddef:fa78 with SMTP id p43-20020a02782b000000b00317ddeffa78mr4528175jac.226.1646929510993;
        Thu, 10 Mar 2022 08:25:10 -0800 (PST)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id x14-20020a927c0e000000b002c244d8dcc8sm2946964ilc.42.2022.03.10.08.25.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Mar 2022 08:25:10 -0800 (PST)
Message-ID: <93fa6d65-164c-3956-b143-9b3fb88a391a@kernel.dk>
Date:   Thu, 10 Mar 2022 09:25:10 -0700
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
 <2ba7fb27-0eec-e2a2-c986-529175c79cbe@kernel.dk>
 <0b9831d8-0597-9d17-e871-e964e257e8a7@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <0b9831d8-0597-9d17-e871-e964e257e8a7@gmail.com>
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

On 3/10/22 9:22 AM, Artyom Pavlov wrote:
>>> I like IORING_OP_WAKEUP_RING with sqe->len being copied to
>>> cqe->result. The only question I have is how should "negative" (i.e.
>>> bigger or equal to 2^31) lengths be handled. They either should be
>>> copied similarly to positive values or we should get an error.
>>
>> Any IO transferring syscall in Linux supports INT_MAX as the maximum in
>> one request, which is also why the res field is sized the way it is. So
>> you cannot transfer more than that anyway, hence it should not be an
>> issue (at least specific to io_uring).
>>
>>> Also what do you think about registering ring fds? Could it be
>>> beneficial?
>>
>> Definitely, it'll make the overhead a bit lower for issuing the
>> IORING_OP_MSG_RING (it's been renamed ;-) request.
>>
> 
> I mean the case when sqe->len is used to transfer arbitrary data set
> by user. I believe IORING_OP_MSG_RING behavior for this edge case
> should be explicitly documented.

Ah gotcha

> It looks like we have 3 options:
> 1) Copy sqe->len to cqe->result without any checks. Disadvantage:
> user-provided value may collide with EBADFD and EOVERFLOW.
> 2) Submit error CQE to the submitter ring.
> 3) Submit error CQE to the receiver ring (cqe->result will contain
> error code).

#1 should not be an issue, as cqe->result for those values is the
original ring result code, not the target ring.

I'd say the application should just case it to u32 and intepret it like
that, if it's worried about the signed nature of it?

-- 
Jens Axboe

