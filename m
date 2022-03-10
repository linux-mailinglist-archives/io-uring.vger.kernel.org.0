Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A87064D4F3A
	for <lists+io-uring@lfdr.de>; Thu, 10 Mar 2022 17:29:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238235AbiCJQ3y (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 10 Mar 2022 11:29:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240483AbiCJQ3x (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 10 Mar 2022 11:29:53 -0500
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EB234C798
        for <io-uring@vger.kernel.org>; Thu, 10 Mar 2022 08:28:52 -0800 (PST)
Received: by mail-lf1-x12b.google.com with SMTP id w27so10388181lfa.5
        for <io-uring@vger.kernel.org>; Thu, 10 Mar 2022 08:28:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=RbFNFI/H9d1lZ6luJZPDVCsnE/kO6dfgwxngoKU1A4g=;
        b=DjLAACGbw3oWwOKVVr5OKBtB1mvf5U4/Sm2vcU5yiTRn7GlQFYL/E9C7rsVNUr3rTd
         QquRWHPF4ZF4fzVgorHmO6A0JwGgaGgASOlC2nomlknK52tccprFfmQezDi2KzmPs7o9
         uP75SqEI2N4onpAzfdSQSgj3iM2Y89DQ1HUhIHwNyzi+K8xhBbHanPNNhAXrvqUwlDF7
         Wyeeb9CqZz7N8LuR9IRPCaMQ3VSytky9EkbKUZ1eGuJ94VanQhCb+7FhRru4FO2Kwnki
         sG8osuWwdlkecAkDhAMCekz/k0++cEDwBzXtWnyzXy1ilobULJwEEvdFbApo6Oth0g2+
         KsVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=RbFNFI/H9d1lZ6luJZPDVCsnE/kO6dfgwxngoKU1A4g=;
        b=BGb/HHCaFwrHFyu2tAWeoyPCq4DF3jFc/0CbTIIQ1DLua4JwM4eMLuJjrpStLhYlTb
         G5PX8xYB9YyltCKBg4vSnMglpvuDFuCjBPvqNA2bTNPmrhp0xO3C58mHT6wclu7g/9Jo
         W0QvEoi8qDynDl1JXCr//XbRKc7r/1Zi0SYr6BY3F9/jGNs50P5j73s5IkCzwnwKoX0i
         18tSV3dK0bIDtpTJj2EXnNP8cGhpiwGb1f0zeYsrBNsdLm2aFRlZJcyvKlc6375ynY07
         /aUTOrCwNmKbosiYXOvGsBhygeo6iGwYWxTZ89i9fWA1DFbY4zAi6FmXg3Uu2gupmbjb
         n6IQ==
X-Gm-Message-State: AOAM532+aUTI+nxoUC+B/nvuQNhAsytsfhi8laDNKQm/J7JDKi0VQNPk
        uJaNzOXm9WHwkflvWfMl3JDJvSMmnQ==
X-Google-Smtp-Source: ABdhPJx6/TsxYQxVIGQ/Teacqc8timXJZepsQMYwD6Yl84r2Pytbis4a6NOVN+5xJgJeRK3ZLTkD3w==
X-Received: by 2002:a05:6512:1151:b0:448:38a4:ecf9 with SMTP id m17-20020a056512115100b0044838a4ecf9mr3340148lfg.491.1646929730463;
        Thu, 10 Mar 2022 08:28:50 -0800 (PST)
Received: from [172.31.10.33] ([109.72.231.42])
        by smtp.gmail.com with ESMTPSA id s5-20020ac24645000000b00448628b8462sm414309lfo.249.2022.03.10.08.28.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Mar 2022 08:28:49 -0800 (PST)
Message-ID: <ccdc456d-05d0-15f5-2175-3ee8e73260a1@gmail.com>
Date:   Thu, 10 Mar 2022 19:28:49 +0300
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
 <0b9831d8-0597-9d17-e871-e964e257e8a7@gmail.com>
 <93fa6d65-164c-3956-b143-9b3fb88a391a@kernel.dk>
From:   Artyom Pavlov <newpavlov@gmail.com>
In-Reply-To: <93fa6d65-164c-3956-b143-9b3fb88a391a@kernel.dk>
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

>> It looks like we have 3 options:
>> 1) Copy sqe->len to cqe->result without any checks. Disadvantage:
>> user-provided value may collide with EBADFD and EOVERFLOW.
>> 2) Submit error CQE to the submitter ring.
>> 3) Submit error CQE to the receiver ring (cqe->result will contain
>> error code).
> 
> #1 should not be an issue, as cqe->result for those values is the
> original ring result code, not the target ring.
> 
> I'd say the application should just case it to u32 and intepret it like
> that, if it's worried about the signed nature of it?

Ah, indeed. I've missed that EBADFD and EOVERFLOW errors only can happen 
in the submitter ring, so the receiver ring can always interpret CQE 
with the IORING_CQE_F_MSG flag as a successfully received message from 
another ring.
