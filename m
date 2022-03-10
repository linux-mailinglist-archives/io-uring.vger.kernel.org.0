Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77F0F4D4DA1
	for <lists+io-uring@lfdr.de>; Thu, 10 Mar 2022 16:52:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239232AbiCJPxL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 10 Mar 2022 10:53:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239293AbiCJPxK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 10 Mar 2022 10:53:10 -0500
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EC39184B4B
        for <io-uring@vger.kernel.org>; Thu, 10 Mar 2022 07:52:09 -0800 (PST)
Received: by mail-lj1-x22e.google.com with SMTP id u7so8288792ljk.13
        for <io-uring@vger.kernel.org>; Thu, 10 Mar 2022 07:52:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=FPTooQtI9dw/jIdih9qa6eJLYuoI+m64Sv2hWZch7UQ=;
        b=dIKaTvDXdjE49K0kfgAN9F5+H/4GGFl917behNQKmcHSJ2e66LmYcNkOb93XhidR/Y
         wntaxv85KJYEyvTQNkmR504j+JaVpmQRdu9jlsVtZdartEFYrkRUZrYUDNdMRB7edmLR
         M9Rw5V0XSAoITuZ3EPrt40pkC3cWBfSNWaZjxXeFcQIH+sz44dJjR9aGua+RAF5aUy3E
         P6V8rbOgcjtZew8Qlvotk6/6dfNQQQT/q1rJ1iBaynFgzPOxKth8mKRSAWkN4CZTEpGR
         aVzMZF8kZ59pnqTqELT0nIwbJUMYZ1rY/iZhaqquCE5Zh3stNf79Ngd2x8xb+SGzU8v5
         f2Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=FPTooQtI9dw/jIdih9qa6eJLYuoI+m64Sv2hWZch7UQ=;
        b=Mdo5tOrIWDPqMrGh1J122dCLgnRtHuBsMR9PlX80Mjdcng1dOKXUSyo4xC24BG/GmT
         39S93HrbgaCVOdt7LNfocssR5mA35epoyoH0IVj1GPW6VyHYMR2Q9y58/UdO17U22NGL
         8P6qfq6VbnCo4NB11bsL6POMOu2ljg8sV0nINCrbmVPfQPkPymALUNSmkeD8Mq64hj2U
         dznSaHxioKAqJnWJ/J5hZ/SI89Uvz21mkEQQx2ESinU+tlYVChp3SJgaTBsiktls7Voy
         aqA+NN/BN8u3gSehYKXGwyl7M3dtLbdKdaRrPIBF2/BiOqgtvtxaGWCrqILsPsUjLbwI
         o/5g==
X-Gm-Message-State: AOAM530aE7/0mr0VceeFPcE0p7x0efO8WJDHVBLvCm4FjBkKmumuKrVU
        A3w5QFZEqAc8u3PayGT3yQ==
X-Google-Smtp-Source: ABdhPJwxeukVT2AARWxaieRtSm2wGAY/bXSgBs87LmWzrtOOhLWXNkZtDNpYaIdYOH1nJmz6VC3M2Q==
X-Received: by 2002:a2e:a7cb:0:b0:246:4b50:efcd with SMTP id x11-20020a2ea7cb000000b002464b50efcdmr3380348ljp.511.1646927527595;
        Thu, 10 Mar 2022 07:52:07 -0800 (PST)
Received: from [172.31.10.33] ([109.72.231.42])
        by smtp.gmail.com with ESMTPSA id z1-20020a0565120c0100b00447a7c10e4dsm1039387lfu.31.2022.03.10.07.52.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Mar 2022 07:52:07 -0800 (PST)
Message-ID: <22ed0dd2-9389-0468-cd92-705535b756bb@gmail.com>
Date:   Thu, 10 Mar 2022 18:52:06 +0300
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
From:   Artyom Pavlov <newpavlov@gmail.com>
In-Reply-To: <9a23cd0e-b7eb-6a5c-a08d-14d63f47bb05@kernel.dk>
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

10.03.2022 18:46, Jens Axboe wrote:
> On 3/10/22 8:43 AM, Jens Axboe wrote:
>> On 3/10/22 8:36 AM, Artyom Pavlov wrote:
>>> After thinking about it a bit, I think this approach has one serious
>>> disadvantage: you lose successful result value of the initial request.
>>> Imagine we submit IORING_OP_READ and link IORING_OP_WAKEUP_RING to it.
>>> If the request is completed successfully, both ring1 and ring2 will
>>> lose number of read bytes.
>>
>> But you know what the result is, otherwise you would've gotten a cqe
>> posted if it wasn't what you asked for.
> 
> Can also be made more explicit by setting sqe->len to what you set the
> original request length to, and then pass that back in the cqe->res
> instead of using the pid from the task that sent it. Then you'd have it
> immediately available. Might make more sense than the pid, not sure
> anyone would care about that?

Maybe I am missing something, but we only know that the request to which
IORING_OP_WAKEUP_RING was linked completed successfully. How exactly do 
you retrieve the number of read bytes with the linking aproach?

Yes, passing positive result value would make more sense than PID of 
submitter, which is rarely, if ever, needed. IIUC we would not be able 
to use linking with such approach, since sqe->len has to be set in user 
code based on a received CQE, but I guess it should be fine in practice.
