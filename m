Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B11DF561F0A
	for <lists+io-uring@lfdr.de>; Thu, 30 Jun 2022 17:19:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234536AbiF3PTP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Jun 2022 11:19:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234403AbiF3PTO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Jun 2022 11:19:14 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24B38377D4
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 08:19:14 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id c65so27034236edf.4
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 08:19:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=nV9Ygpm8Mwfwj+N5zP6HeULfEByYXBMmo7SROkONxMU=;
        b=dh+UrfQ73aey1Udgw0D+aDHSEtGUrnezNnK119oYXsPwwV6otmppAXb6L2rTK50AfM
         p1hsfwLc+52DSj2HGYmIEBn1c5ngBnXvhbmQM3KBIjpkvCTiPHjBRpZVWcx4gSVogFTR
         SJyRzU+J0P/sAtFWMBmu2hp5yZmPQfl4IuUp5OlLpAxjSxR3/K4HaUM+dOqOnhxV/HuD
         Ljd6bcdOi03cvdgJUZD+R+FwK/PHWwvGrjcWbJ11sqVpwmcCiZ5kWnwIks5ZG+sFdNgr
         vZuPMFUQQUkuV35aQR8/F5vW0tl844M9ZcQBTVu8DQNKaGAc73BJE85XAmyMEyqPFj4Y
         d0KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=nV9Ygpm8Mwfwj+N5zP6HeULfEByYXBMmo7SROkONxMU=;
        b=MyPQ0TYGBiAKoH2L0RAdILJEbeRCbvIK38AonQ/600I1nsKOwFRq/3JoPLkQ+aPB33
         CJUci8F1dpEAVHNaFhtRFMedFqYY2IKCWZYwgCcSYhdJMt3/peUrdEYXtH503rVzQmGP
         s8OaK1UmS29QHO3KMAWFIXD1W2jUBGg5DT3d4jICVvt7hbXdSrBlUMtU+VPM5kL2ap+F
         bZPczZn/UPYN+qZz5QzMSBaSjVB6CatcoWB6cvzAgkPke/QXVsNR5vz+0LsVB5XQ699P
         Ymw12bUFkmGoWFoLoAsDCV122YqQGbTltNY0iYkGasJF5qyxxP/Uv0G5O+OvBVsDiG+5
         uNmg==
X-Gm-Message-State: AJIora8EzQaQkVE99vteMNQCJsqrb/atH6Ly6eR6aulmXuYYNKWh31Qq
        HrfpoWOr8vK5TLGMagTE1fF6bGCotzIIYw/y
X-Google-Smtp-Source: AGRyM1sKAb6l/4kYVL+mdQv8UaIiCjTowYKtvdI1huSRg1Pf7rIMVKbOkUw5KWz/5yvEaitFFg4G4A==
X-Received: by 2002:a05:6402:2804:b0:431:7dde:6fb5 with SMTP id h4-20020a056402280400b004317dde6fb5mr12349341ede.379.1656602352620;
        Thu, 30 Jun 2022 08:19:12 -0700 (PDT)
Received: from [192.168.8.198] (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id ds12-20020a0564021ccc00b00437d3e6c4c7sm3265047edb.53.2022.06.30.08.19.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jun 2022 08:19:12 -0700 (PDT)
Message-ID: <6528f78f-3236-6964-127c-7c91b67b854b@gmail.com>
Date:   Thu, 30 Jun 2022 16:18:58 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH for-next 3/3] test range file alloc
Content-Language: en-US
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc:     Eli Schwartz <eschwartz93@gmail.com>, Jens Axboe <axboe@kernel.dk>,
        io-uring Mailing List <io-uring@vger.kernel.org>
References: <cover.1656580293.git.asml.silence@gmail.com>
 <decaf87bd125ad0e77261985e521926aff66ff34.1656580293.git.asml.silence@gmail.com>
 <30f95627-eb6c-c743-8fb2-11b0b874e00b@kernel.dk>
 <af745cb5-908c-1532-e5ea-a875a5166ec7@gmail.com>
 <a72fcfe9-cc9e-9ca0-9fc7-d97fe44d4599@gnuweeb.org>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <a72fcfe9-cc9e-9ca0-9fc7-d97fe44d4599@gnuweeb.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/30/22 15:31, Ammar Faizi wrote:
> On 6/30/22 9:19 PM, Pavel Begunkov wrote:
>> On 6/30/22 14:09, Jens Axboe wrote:
>>> On 6/30/22 3:13 AM, Pavel Begunkov wrote:
>>>> @@ -949,5 +1114,11 @@ int main(int argc, char *argv[])
>>>>           return ret;
>>>>       }
>>>> +    ret = test_file_alloc_ranges();
>>>> +    if (ret) {
>>>> +        printf("test_partial_register_fail failed\n");
>>>> +        return ret;
>>>> +    }
>>>
>>> If you're returning this directly, test_file_alloc_ranges() should use
>>> the proper T_EXIT_foo return codes.
>>
>> Nobody cared enough to "fix" all tests to use those new codes, most
>> of the cases just return what they've got, but whatever. Same with
>> stdout vs stderr.
> 
> That error code rule was invented since commit:
> 
>     68103b731c34a9f83c181cb33eb424f46f3dcb94 ("Merge branch 'exitcode-protocol' of ....")
> 
>     Ref: https://github.com/axboe/liburing/pull/621/files
> 
> Thanks to Eli who did it. Eli also fixed all tests. Maybe some are still
> missing, but if we find it, better to fix it.

Have no idea what you're talking about but I'm having
hard time calling 6 returns out of 21 in this file "all".

-- 
Pavel Begunkov
