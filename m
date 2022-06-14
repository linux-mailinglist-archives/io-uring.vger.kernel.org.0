Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95C0754B50E
	for <lists+io-uring@lfdr.de>; Tue, 14 Jun 2022 17:50:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244578AbiFNPtM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Jun 2022 11:49:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242977AbiFNPtK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Jun 2022 11:49:10 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AF2E2C10A
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 08:49:10 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id u8so11820936wrm.13
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 08:49:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=NMnF3bU5vcTriQxI5POSKjxS4zEO34YDddO6t216FvM=;
        b=RzFL0TTEbt3hPJbFWikSvyAVxFlHpzY0Nd2e1h87fNbs5vvmYE3DdsfVJ2ozrcTz2/
         RvecxrsIEKRwq0E++hVuOj8yyvbQUTOilsdRoe4fj9vKTzQ1P30+OS+pZOarLOwknpxt
         L7iHsOTovvVKfDVCukri9RxdEkl/cz4ahUxvL9c5UGTyCDHNC8263h7beeA+iC2BvOe9
         1ql0C7iaVtjKkc4x4Z4ndlsVND0+TdQESO76Kr4XyqXbl9ooh7fueuHt0eCV2mxbOMy4
         xRfYgNS7MTxhZpnvhP49yWFA+x7pdmb0tIvHHwHCBzAXH7nl01J2dXKjPflHm1d2llzy
         8IzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=NMnF3bU5vcTriQxI5POSKjxS4zEO34YDddO6t216FvM=;
        b=2vmrwlnmy1CSNrS+8Iq7WmbtBrvhpsuddRy97UlflJw+u1ZnQuSbnUcDM23OCiZ8nO
         VM27HMIb4rcPsZz+zgKGCFLxzaHk7meaHZ0V9H1VpbzvuEHC4HTtFcoU24WiLwaBlFfd
         y+R/BH+nqzt5KGKW0XH8f5PulRRlpc+PJ0plh1E3Njsij+WCPUrXCEy9fGuW2eFFZhlk
         XD6FnbmwPjyo8EV+XXRD31+J1/Ah8upyNdPTPsbntuYQ8aj72JsZe+ZcIlg2jQwAbTo6
         cP0hknyQrtNiJb+MVngLrRuDEuCcvGOfkCR1NS9C9UQ7rSUalgcSuVrJyyEsmO4d9/H2
         dG1Q==
X-Gm-Message-State: AJIora+SZ7cHmK/52sPybs3y0F59XabsqycdLu9gsy11MSIt+YBgpx8x
        mFNWwTnmv6kLtrqwwFpSfibnl0XDwnSvjw==
X-Google-Smtp-Source: AGRyM1us98CBAJaD1QICH4TGvS8U77n7nqm6a5543hcfKfYO+6pezJaPRfe/oCXDz+drJjU07rLqUg==
X-Received: by 2002:a5d:64e6:0:b0:218:29d3:ee74 with SMTP id g6-20020a5d64e6000000b0021829d3ee74mr5651797wri.657.1655221748737;
        Tue, 14 Jun 2022 08:49:08 -0700 (PDT)
Received: from [192.168.8.198] (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id b12-20020a05600010cc00b0020c5253d90asm12170765wrx.86.2022.06.14.08.49.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jun 2022 08:49:08 -0700 (PDT)
Message-ID: <da4c0717-be10-c298-9074-b237ea613ba5@gmail.com>
Date:   Tue, 14 Jun 2022 16:48:49 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH liburing v2 0/3] single-issuer and poll benchmark
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1655219150.git.asml.silence@gmail.com>
 <9b2daabd-3412-7cd8-79d8-8a9dfe4b27d2@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <9b2daabd-3412-7cd8-79d8-8a9dfe4b27d2@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/14/22 16:30, Jens Axboe wrote:
> On 6/14/22 9:27 AM, Pavel Begunkov wrote:
>> Add some tests to check the kernel enforcing single-issuer right, and
>> add a simple poll benchmark, might be useful if we do poll changes.
> 
> Should we add a benchmark/ or something directory rather than use
> examples/ ?
> 
> I know Dylan was looking at that at one point. I don't feel too
> strongly, as long as it doesn't go into test/.

I don't care much myself, I can respin it once (if) the kernel
side is queued.

-- 
Pavel Begunkov
