Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DCDC57FE30
	for <lists+io-uring@lfdr.de>; Mon, 25 Jul 2022 13:19:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232103AbiGYLS6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 25 Jul 2022 07:18:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbiGYLS5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 25 Jul 2022 07:18:57 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3D3D1580C
        for <io-uring@vger.kernel.org>; Mon, 25 Jul 2022 04:18:56 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id z13so15471026wro.13
        for <io-uring@vger.kernel.org>; Mon, 25 Jul 2022 04:18:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=mu5EkmWsiRMx80qxKC0kfOjEXdJawx/GE4uID7i94Vk=;
        b=Fh+9Fyx/+1mJ0WX+r1NEVNyQPsHbgIJB2Ei+JWcH+qIdeoTCVEbKRdEvvC9HMpMbDZ
         z2RmvYbTj7whEHnt6OGNiuqVeryaGo1+0+i9zA9w5fkrxgCQ+iljMAuRRLlrids2Wixm
         AA7qFDqZlL27FsWcET9yAjmtJCXlXuaVu0tTBarpJZiKa5zeGHwzRQT9/v14lBSANEZe
         nu3B8/siyGhMgrNWYdMlfNZT4dQBoe3+T7Jzzc5Fqc+NHg9qZYtPi10ApFBxSeGV+lZs
         4ROKsfdx0KezS4HCLFBM3sOLANPLDREhawtER+Pd5rIyqBDsqPgciGLF103mgDgYYbsI
         bsew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=mu5EkmWsiRMx80qxKC0kfOjEXdJawx/GE4uID7i94Vk=;
        b=I5kxQB408gLGeJ82ZHPW+NEkMBYtq/YAppWDfZ0jbeyCXu1lo0HQfHhZgtcUbDPqqF
         sJE0RiSQJFX9E5+LQwQqaCXb8ed71vx3+4O9yv6u6m93yeHUWuUNLgl11tIir+VPmI0o
         1pD5bb/fZqj8tQPWiQG8hcSH0DNeapHrn1bDCjqCfychfR6VG6RaZCt5lbdXdewlBSlj
         coyC77fiTlwBXxrNqEzzgvW+vHROO4E/NPK5FxZKclcTMIFeEPyiEg63IasjQ+6XUItG
         UUg6+kR5p+bEoqbsg/O8nhdt9PkR1wAB0yCv/8iyeI5SUu3FHEnr5aSwDlccSDlmeYyY
         N6IQ==
X-Gm-Message-State: AJIora/QyCNBQLWDk1LdLXQcTaP6EpV0e/39sJxo8SQUZglUB2ZlWWjJ
        qTDBye7UyrCnawLYPi+xbuE=
X-Google-Smtp-Source: AGRyM1sb4PH//rJgM+ASZXta39pqoRlpNrfh1EqMfkT6A5bIME2yqwRxAVHBWOOgXQSroMj1jkEriw==
X-Received: by 2002:adf:e88f:0:b0:21e:4ecd:7c0c with SMTP id d15-20020adfe88f000000b0021e4ecd7c0cmr7330745wrm.102.1658747934995;
        Mon, 25 Jul 2022 04:18:54 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:310::22ef? ([2620:10d:c093:600::1:9f35])
        by smtp.gmail.com with ESMTPSA id d6-20020a5d6446000000b0021db2dcd0aasm13916345wrw.108.2022.07.25.04.18.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Jul 2022 04:18:54 -0700 (PDT)
Message-ID: <7255f35a-40ca-0b24-4364-622171498bbd@gmail.com>
Date:   Mon, 25 Jul 2022 12:18:30 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH liburing 2/4] liburing: add zc send and notif helpers
Content-Language: en-US
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc:     Jens Axboe <axboe@kernel.dk>,
        io-uring Mailing List <io-uring@vger.kernel.org>
References: <cover.1658743360.git.asml.silence@gmail.com>
 <7f705b208e5f7baa6ee94904e39d3d0da2e28150.1658743360.git.asml.silence@gmail.com>
 <912620ff-7a2e-80b8-eea4-6f231304e33d@gnuweeb.org>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <912620ff-7a2e-80b8-eea4-6f231304e33d@gnuweeb.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/25/22 11:20, Ammar Faizi wrote:
> Hi Pavel,
> 
> On 7/25/22 5:03 PM, Pavel Begunkov wrote:
>> +static inline void io_uring_prep_notif_update(struct io_uring_sqe *sqe,
>> +                          __u64 new_tag, /* 0 to ignore */
>> +                          unsigned offset, unsigned nr)
>> +{
>> +    io_uring_prep_rw(IORING_OP_FILES_UPDATE, sqe, -1, (void *)new_tag, nr,
>> +             (__u64)offset);
>> +    sqe->ioprio = IORING_RSRC_UPDATE_NOTIF;
>> +}
>> +
> 
> This part breaks 32-bit architecture.
> 
>    include/liburing.h: In function ‘io_uring_prep_notif_update’:
>    In file included from syscall.h:14,
>                     from setup.c:5:
>    include/liburing.h: In function ‘io_uring_prep_notif_update’:
>    include/liburing.h:716:59: error: cast to pointer from integer of different size [-Werror=int-to-pointer-cast]
>      716 |         io_uring_prep_rw(IORING_OP_FILES_UPDATE, sqe, -1, (void *)new_tag, nr,
>          |                                                           ^
>    include/liburing.h:716:59: error: cast to pointer from integer of different size [-Werror=int-to-pointer-cast]
>      716 |         io_uring_prep_rw(IORING_OP_FILES_UPDATE, sqe, -1, (void *)new_tag, nr,
>          |

Got it, thanks

-- 
Pavel Begunkov
