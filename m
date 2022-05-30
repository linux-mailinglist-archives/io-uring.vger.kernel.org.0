Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58D3353861D
	for <lists+io-uring@lfdr.de>; Mon, 30 May 2022 18:28:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238967AbiE3Q2T (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 30 May 2022 12:28:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236376AbiE3Q2T (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 30 May 2022 12:28:19 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF918562EC
        for <io-uring@vger.kernel.org>; Mon, 30 May 2022 09:28:17 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id o6-20020a17090a0a0600b001e2c6566046so5050312pjo.0
        for <io-uring@vger.kernel.org>; Mon, 30 May 2022 09:28:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=qRvIldmsCBYfSvfhUrC6NspN4a7WA95ZLQ6ReVhZay0=;
        b=fE75HTIfKLSoM/4Nwtfg0/VnlTEfJqjtMM4g0GNe61RQp247IrxFt5+3FTSoHuln1R
         yEexZ1+en+AZpqBd6sWwi5atS+w5suaaxJ1a11OCu+cfdsGXl3qdE1LG8qe9hEbLF7ge
         cE2yUsvOAm4InUu4fTLTWB3yb5sm8tsfU4xzKl7eJLrwQxfVB1WPvY33yyQR/bCnp8V6
         5/SF31mkQCFcQg+eiBOkJBUHoPovM6u7xNKvZq6xF0K0XPwm5okFTGW2MF3lldF0OQ8S
         g7Py3YG/Q3jx+l2lYIT2KLDKt1C4MhO9WfM6i5j8QcwpWcGSzqqwRmvCu9//Z9JHCb7m
         8rPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=qRvIldmsCBYfSvfhUrC6NspN4a7WA95ZLQ6ReVhZay0=;
        b=2+G6GHULqd+HT5jJN/7JYwwqnWjDwY1IP5PIJ+haLi6iDofQcwPVohlTOV8yMJz1/e
         Qow3BfLDnw+wGKKPaRw3bhP2TyP0dr2vneZ1YV6JqRB1xTukm6YbeKJ0AAXRKas2kj/m
         PXtkAxnq+igthJMGOu/cY7peR9kcsf0KxrsLQOx4bLRrIUtNDe/CobkVuJ4CoR4W60pf
         pg8lLfZdm0nnw825SCg8xMWcGScLOMT6O58+JNUzH+RllPTwyZOifyK3JUgceLPkc5kU
         Hl6rmhDvpM7y6JI1xPkCGUM7JzncS+w0fymROWEDCHbQdhilXtEou/S6zJGeWYVxoBgp
         RQ3A==
X-Gm-Message-State: AOAM533UxAy48jZHJilE8XEugrhr59UWTrzgU5Y84pff3ITFQBNkO/1O
        udDzM5/u3MP/wLKjLg/Gf0NSDQ==
X-Google-Smtp-Source: ABdhPJxJwwPraQYGy40AfL+M7sjhR5jnrIAHYO8LjP4j4GPnqgsydh/fybe7qbjN1nc8c1PaIM4Mmw==
X-Received: by 2002:a17:902:9b84:b0:161:db34:61ef with SMTP id y4-20020a1709029b8400b00161db3461efmr55693255plp.138.1653928097365;
        Mon, 30 May 2022 09:28:17 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id r10-20020a17090a560a00b001df666ebddesm7298826pjf.6.2022.05.30.09.28.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 May 2022 09:28:16 -0700 (PDT)
Message-ID: <5f5a0896-8ba4-b526-d736-4343b507fb68@kernel.dk>
Date:   Mon, 30 May 2022 10:28:15 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH v2] io_uring: let IORING_OP_FILES_UPDATE support to choose
 fixed file slots
Content-Language: en-US
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com
References: <20220530131520.47712-1-xiaoguang.wang@linux.alibaba.com>
 <3064f1e4-c66b-a90b-8073-dc63525c5aca@kernel.dk>
 <08f2395c-50b2-850a-0ce9-583be34017e3@kernel.dk>
 <ea209f4d-cbf6-cc9f-ccab-9c28e9b58a35@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ea209f4d-cbf6-cc9f-ccab-9c28e9b58a35@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/30/22 10:15 AM, Xiaoguang Wang wrote:
> hi,
> 
>> On 5/30/22 7:18 AM, Jens Axboe wrote:
>>> On 5/30/22 7:15 AM, Xiaoguang Wang wrote:
>>>> @@ -5945,16 +5948,22 @@ static int io_statx(struct io_kiocb *req, unsigned int issue_flags)
>>>>  	return 0;
>>>>  }
>>>>  
>>>> +#define IORING_CLOSE_FD_AND_FILE_SLOT 1
>>>> +
>>> This should go into uapi/linux/io_uring.h - I'll just move it, no need
>>> for a v3 for that. Test case should add it too.
>> Here's what I merged so far:
>>
>> https://git.kernel.dk/cgit/linux-block/commit/?h=io_uring-5.19&id=f6b0e7c95c20d4889b811ada7fc0061e8cb4e82e
>>
>> Changes:
>>
>> - I re-wrote the commit message slightly
>> - Move flag to header where it belongs
>> - Get rid of 'goto' in io_files_update_with_index_alloc()
>> - Drop unneeded variable in io_files_update_with_index_alloc()
> I think file registration feature is much easier to use now, thanks!

Thanks for making the change! Will you send a v2 of the liburing test?
Then I'll get that queued up too.

-- 
Jens Axboe

