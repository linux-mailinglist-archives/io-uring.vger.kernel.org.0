Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A7604D4D9E
	for <lists+io-uring@lfdr.de>; Thu, 10 Mar 2022 16:52:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229475AbiCJPsF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 10 Mar 2022 10:48:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238333AbiCJPsE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 10 Mar 2022 10:48:04 -0500
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED3E5184633
        for <io-uring@vger.kernel.org>; Thu, 10 Mar 2022 07:46:59 -0800 (PST)
Received: by mail-io1-xd2b.google.com with SMTP id d62so6853283iog.13
        for <io-uring@vger.kernel.org>; Thu, 10 Mar 2022 07:46:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:references:in-reply-to:content-transfer-encoding;
        bh=elmUO2VJbM3J3tz1eeX9Vox2b1QAwWm73qrZWtrS0+8=;
        b=HV+QCzZpVMNM7b/GFlhX9reEI/adpqDSxBLmgs97ZVtNtOYVZ7t4TCW6juYV2Ev0//
         QwkmVjrgUynnDf9HifHvLuaN8THWJBb9n73je6vH0el/zjhP540vQM7FYPA2TnrrW+C/
         N7NTn/AhDjtLDlhOTKWUS/9ufVyOIremdJuNyytmNY1NjbdVx21Qw6uN9lvDqZ6R7ayn
         6blDFmPNAi+M0KxPHTvehANuqOG0nU2Gw77sCjq8392eRaQxb+U9sKiav557EzSEba26
         aYcxkLH0xNU9QsHymJU+Yme1VZL/v5nSP4gn2AYm3hn6xzuUkdkg6XPA4jemlGeg/61K
         Ixzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:references:in-reply-to
         :content-transfer-encoding;
        bh=elmUO2VJbM3J3tz1eeX9Vox2b1QAwWm73qrZWtrS0+8=;
        b=vwofZPvadObKmJU08i6F6sf+qUWvUYeUQ/SvCedta2sCVWda+UPHkRZYw58JoRjINh
         qfQgGfivoHYct/AavQnKcu2RKWqwR2lfewRASKZHFEDXY9+TRNmK0pyf6dGbkzIxne8i
         bR8qOrYSCCD07fk/w0TnQzbcQOBkzWQNQkOIX4JxTINTaHCkLjlVK5aTRbxX/6HHGKN/
         8sWgoaIWi3RxtwI5LRmeCBbq0e+Ky8rG2yEfTL/xTn7Tq5ePMslpTAJQ9mw6HrG2Lxlj
         s+mSbxtZu4gSnPXlF35+QPYsOJ8R9bf5gDfO2GzbTJyTQyHzU6KzY883QbmvM0F3mPNp
         JOIg==
X-Gm-Message-State: AOAM530Z3xtdIesA+NgPoEtyfQz444mJYxWQqCIiPgzQXsRL3a5+XT6h
        xQC+aRfo2knyUwEGPvy5XFHGNw==
X-Google-Smtp-Source: ABdhPJwxN+3NACeYx3M7NmVvU5VjoCOL3ycIiRISPSIOPMx7cilSieUHHL+stbNb4atthCFU0ptQRQ==
X-Received: by 2002:a05:6638:164a:b0:314:e841:c9f8 with SMTP id a10-20020a056638164a00b00314e841c9f8mr4450655jat.193.1646927218997;
        Thu, 10 Mar 2022 07:46:58 -0800 (PST)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id s12-20020a056602168c00b00648a9d133f3sm929634iow.25.2022.03.10.07.46.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Mar 2022 07:46:58 -0800 (PST)
Message-ID: <9a23cd0e-b7eb-6a5c-a08d-14d63f47bb05@kernel.dk>
Date:   Thu, 10 Mar 2022 08:46:57 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: Sending CQE to a different ring
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
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
In-Reply-To: <1bfafa03-8f5f-be7a-37a5-f3989596ff5a@kernel.dk>
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

On 3/10/22 8:43 AM, Jens Axboe wrote:
> On 3/10/22 8:36 AM, Artyom Pavlov wrote:
>> After thinking about it a bit, I think this approach has one serious
>> disadvantage: you lose successful result value of the initial request.
>> Imagine we submit IORING_OP_READ and link IORING_OP_WAKEUP_RING to it.
>> If the request is completed successfully, both ring1 and ring2 will
>> lose number of read bytes.
> 
> But you know what the result is, otherwise you would've gotten a cqe
> posted if it wasn't what you asked for.

Can also be made more explicit by setting sqe->len to what you set the
original request length to, and then pass that back in the cqe->res
instead of using the pid from the task that sent it. Then you'd have it
immediately available. Might make more sense than the pid, not sure
anyone would care about that?

-- 
Jens Axboe

