Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74D4D4D4F2B
	for <lists+io-uring@lfdr.de>; Thu, 10 Mar 2022 17:26:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243756AbiCJQZF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 10 Mar 2022 11:25:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243761AbiCJQYy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 10 Mar 2022 11:24:54 -0500
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56A03199D53
        for <io-uring@vger.kernel.org>; Thu, 10 Mar 2022 08:22:54 -0800 (PST)
Received: by mail-lf1-x130.google.com with SMTP id n19so10316543lfh.8
        for <io-uring@vger.kernel.org>; Thu, 10 Mar 2022 08:22:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=klCH3DU2vIquEWsH7akTZTfgPD28XcgQkS1rkwT1SmE=;
        b=RDuwQJ9jYOkf+eTbdntGvUoDNSkZUE1rz9GQi51mym9Fc20xTQwgyrv1aO3KfmZK2U
         fbqiBGRAOATBDIqCiSdTakV/ueJhw1yfM0p3gW9D2D3cC+bm1WVVp+ZenvBsc1m3M6kv
         8Yo1LQDA68KgpMGG45LRwmQsCTho+XoabmPwhmdb8kGO/niXXmFw6axXh6S7I9zNuvfd
         y3MgiUVQtr/x1Cpp15LyGZmMmCtbZFTTRFiZPatPqnndNbrUclwajNrZ3iv7XyVRaNNj
         3qPqsrcg/06HZEx4n60D173P2MCn6+K3+3U0aIWBfYNFsbEhCiF8tkvt8BNNFd/0kKNR
         fQww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=klCH3DU2vIquEWsH7akTZTfgPD28XcgQkS1rkwT1SmE=;
        b=okFyzNHFKkDXBOBO1ZGEEbbE3IqNuKmTguss9YfDu4Uk7w7/DZ8Vlj8Jofrid6joPt
         bvvScA7kansx3+F+EsVtVoRGEu1BMVN9d/9n/QNqX+uMV+vyF/x8Nd7oA/emrpuP4Yxq
         TfEz82A9sCcEuUaiVHbzbMpvpSda0Oybs4OmjQMBsDzS07LYaxrD/xHCMuwBWWRA42rb
         q704NIBsliOOIiXwqgxiK79OA50ViB5sVgka/AXFQ0UWB1wVHBrCKaDr55WTquBuw9O0
         rNaiuy3m88hyBfL87tQNN6m+JUAzznaLvnNUD/qIcnhAoprPeUC8YsBtQp+Z0XAEIvgV
         T18w==
X-Gm-Message-State: AOAM532VeTRLGqDxRZOPcmz4UGuBQys9MzJxAZDrsHz3zdxUR0hdgUzl
        4lJZkIsF48ysTVhGTDkdXcwM+W7Nhw==
X-Google-Smtp-Source: ABdhPJwRPY6ebqvON+7Wz2uA0Hzaa1Bw0kggGldPQnAQRptYs5NtNlnD5I+b7U63TrSr1d3aLyOR0Q==
X-Received: by 2002:a05:6512:10c8:b0:448:3fdc:6407 with SMTP id k8-20020a05651210c800b004483fdc6407mr3312757lfg.360.1646929372539;
        Thu, 10 Mar 2022 08:22:52 -0800 (PST)
Received: from [172.31.10.33] ([109.72.231.42])
        by smtp.gmail.com with ESMTPSA id o3-20020a2ebd83000000b002461808adbdsm1092057ljq.106.2022.03.10.08.22.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Mar 2022 08:22:52 -0800 (PST)
Message-ID: <0b9831d8-0597-9d17-e871-e964e257e8a7@gmail.com>
Date:   Thu, 10 Mar 2022 19:22:51 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: Sending CQE to a different ring
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
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
From:   Artyom Pavlov <newpavlov@gmail.com>
In-Reply-To: <2ba7fb27-0eec-e2a2-c986-529175c79cbe@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

>> I like IORING_OP_WAKEUP_RING with sqe->len being copied to
>> cqe->result. The only question I have is how should "negative" (i.e.
>> bigger or equal to 2^31) lengths be handled. They either should be
>> copied similarly to positive values or we should get an error.
> 
> Any IO transferring syscall in Linux supports INT_MAX as the maximum in
> one request, which is also why the res field is sized the way it is. So
> you cannot transfer more than that anyway, hence it should not be an
> issue (at least specific to io_uring).
> 
>> Also what do you think about registering ring fds? Could it be
>> beneficial?
> 
> Definitely, it'll make the overhead a bit lower for issuing the
> IORING_OP_MSG_RING (it's been renamed ;-) request.
> 

I mean the case when sqe->len is used to transfer arbitrary data set by 
user. I believe IORING_OP_MSG_RING behavior for this edge case should be 
explicitly documented.

It looks like we have 3 options:
1) Copy sqe->len to cqe->result without any checks. Disadvantage: 
user-provided value may collide with EBADFD and EOVERFLOW.
2) Submit error CQE to the submitter ring.
3) Submit error CQE to the receiver ring (cqe->result will contain error 
code).
