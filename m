Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43A644D4D95
	for <lists+io-uring@lfdr.de>; Thu, 10 Mar 2022 16:52:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229596AbiCJPoy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 10 Mar 2022 10:44:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiCJPox (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 10 Mar 2022 10:44:53 -0500
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E844A184628
        for <io-uring@vger.kernel.org>; Thu, 10 Mar 2022 07:43:52 -0800 (PST)
Received: by mail-io1-xd31.google.com with SMTP id c23so6904697ioi.4
        for <io-uring@vger.kernel.org>; Thu, 10 Mar 2022 07:43:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=3JIu9tzm5dKlKuyfvYx+Vl4iuiC9S4DyMD+M32fzD0Q=;
        b=ULMaM5cbJ8wx8E4T13nbmEOihjpOF2N5kU6c588eYd0xjcJB6WbMtKhV0pAn3uOASM
         ZGVoKinqlZRE/s2MNFWDTlU2fEOkoSO7lpi1EwikX0Aifzr+EmIUj4yEf9lmvoo9hzhz
         fv2Zl+/eUdllRRz/nJDLFWdJ2rG4xi8YLTCXxpTrc+5TB9LCK24pNPaqtZDPYGDsJN2C
         wuqNWS50tXnWUmm7OhErzRrIDT+U3SeXpULZcXfbhm41bGqZvM6jHgQQCcwrsgNVDS5M
         dunafg/kp1RuoqSWexjoKXjcOVf2saS2Rdy+D1MD+OJkrdpDHJg5N2u15U0uzDVCSukO
         lnQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=3JIu9tzm5dKlKuyfvYx+Vl4iuiC9S4DyMD+M32fzD0Q=;
        b=ExImoZf25VVHZKdWBTIG8h3idl1LzOD1nyteB1WF4sDOKvz7YpIlTDrPqRffJ0yz7p
         +btQazRyFgtVdQQS0dWRz8oaPM7MgJc63jaVeUGjHtehJa3awtMs2z5b+TmDwYmVgJ3F
         6azMGDlnNZGXkeiCPvGdZ3pSV5FL+ofzeNtkGT+6BiLgXGA8YtRT/c1L0JI/gOcLkkng
         xxSykM70J5eeJK1Ij2/cqC3syRT6arOCaxSqqvdrdvcCVJE8Z+c8yGc/njvOnS0IFblA
         6s0ZWH+t5E+Y+9pxTT+mQ0WR1wbockk6CDWvs9fH0oRSXFv54MWDgMGcleoepXdBAN+e
         yL2A==
X-Gm-Message-State: AOAM530PJmh6FnVJP0pu2TXSCtf/caIjCmRtSI+GxsnCcdto/L5lL7HU
        X7bvoE6Om+WtEzSDo8E17KDMQA==
X-Google-Smtp-Source: ABdhPJxyzeG3VkOh7ClGnKIDn4DzwDNS+7sQhnHO+NOsdYgnNqeveZEHzrwfHxXn0KZ1l9rnInpZcA==
X-Received: by 2002:a02:6a5e:0:b0:317:cb94:d0f7 with SMTP id m30-20020a026a5e000000b00317cb94d0f7mr4387071jaf.11.1646927032248;
        Thu, 10 Mar 2022 07:43:52 -0800 (PST)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id t10-20020a056602140a00b00648b2f4d60esm597858iov.28.2022.03.10.07.43.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Mar 2022 07:43:51 -0800 (PST)
Message-ID: <1bfafa03-8f5f-be7a-37a5-f3989596ff5a@kernel.dk>
Date:   Thu, 10 Mar 2022 08:43:51 -0700
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
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <0cbbe6d4-048d-9acb-2ea4-599d41f8eb28@gmail.com>
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

On 3/10/22 8:36 AM, Artyom Pavlov wrote:
> After thinking about it a bit, I think this approach has one serious
> disadvantage: you lose successful result value of the initial request.
> Imagine we submit IORING_OP_READ and link IORING_OP_WAKEUP_RING to it.
> If the request is completed successfully, both ring1 and ring2 will
> lose number of read bytes.

But you know what the result is, otherwise you would've gotten a cqe
posted if it wasn't what you asked for.

-- 
Jens Axboe

