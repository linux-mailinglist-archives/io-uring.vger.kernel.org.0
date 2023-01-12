Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C8D66668B6
	for <lists+io-uring@lfdr.de>; Thu, 12 Jan 2023 03:10:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236081AbjALCKg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 11 Jan 2023 21:10:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236438AbjALCKf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 11 Jan 2023 21:10:35 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4DE344C6B;
        Wed, 11 Jan 2023 18:10:34 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id w3so18765677ply.3;
        Wed, 11 Jan 2023 18:10:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-language:content-transfer-encoding:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iho+f3pc84x6NOMCNkEw696Gmhy3jxu2U1jc8qOkN3g=;
        b=SNrUPC8NKSWzLZwS702sIYQUkstgITBDEsML5UO7GLnT2ImhzgjfpZo7xKfo7RBt7F
         iQbvQlYGSDAJwbVbJppvw5lxmd31rXOE9KPC36KPOAl7dChfdMCc6RPWgK5kJaexSkML
         e1dwVU5uBfHykYi7+vkefrk2vl3DoHKxsES8TlZ0J2nsbnDVOpd6l9edgj3M0COCkde4
         QON1eMlc6cT3An+7pSKu2bfJ//tCp1hEJeamtIKPos+q2s7D9Xm3y71N5H7JfptvaGB2
         ZGyghmUgoUuPO5t/vMvw5Leume/XEOGRCno5nqj+kpLRnnn/PdDbVmvnAn2ioDnWzeHp
         AUXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-language:content-transfer-encoding:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iho+f3pc84x6NOMCNkEw696Gmhy3jxu2U1jc8qOkN3g=;
        b=fSZEWH61COattnbjAiNYc3D2DwrRG8cG3Jl1yIBFNx0sl+vhgSJKmiD1sRhtmDVXCo
         hyLg6Uyj6ZPAJZfoMqtay5caLH8V6uFlAr2Sz9r6yFV740VqPLjSji5fS2s+8129PLM6
         D+WOhhuTeQyDhoGzb2T9M0r1eVLMXS1yL7J4V8v1G7doNQ4C/QfjCNabyUNBhQitWdY1
         2ZKuEQJRmojUTOkpV1LqEoHObxIw0ocg44WfPJybFhTjg+yEbqR7fCUt37DffMl3nUVb
         HooNyX0tkYo+cklE35TQaH0vbbGZkHZp8TK2sSF+mfFWACJAsQobUYPRhHkfwr2MDg2J
         HWqQ==
X-Gm-Message-State: AFqh2krdb2jor4LSWKrME7Agzp+4cqWJudVTNMxz0pK6gjCLuQiMTmMJ
        IH4uMEh4/BXz5pKXpL63SRI=
X-Google-Smtp-Source: AMrXdXufmEW9VkwpA98K6v0miVcK38cf2WecZpFgvwKp8LSIVx3G3I+wFbbzL3Ec00sX2YFtfBUwfA==
X-Received: by 2002:a05:6a21:788e:b0:b5:9fd7:bb64 with SMTP id bf14-20020a056a21788e00b000b59fd7bb64mr7107261pzc.39.1673489434428;
        Wed, 11 Jan 2023 18:10:34 -0800 (PST)
Received: from [192.168.1.101] ([166.111.139.111])
        by smtp.gmail.com with ESMTPSA id c10-20020a63d14a000000b004468cb97c01sm9081586pgj.56.2023.01.11.18.10.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Jan 2023 18:10:33 -0800 (PST)
Subject: Re: [PATCH] io_uring: Add NULL checks for current->io_uring
To:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        TOTE Robot <oslab@tsinghua.edu.cn>
References: <20230111101907.600820-1-baijiaju1990@gmail.com>
 <63d8e95e-894c-4268-648e-35e504ea80b6@kernel.dk>
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
Message-ID: <a2d622dc-a28e-acf7-2863-a2a0310c8697@gmail.com>
Date:   Thu, 12 Jan 2023 10:10:31 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.0
MIME-Version: 1.0
In-Reply-To: <63d8e95e-894c-4268-648e-35e504ea80b6@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 2023/1/11 22:49, Jens Axboe wrote:
> On 1/11/23 3:19 AM, Jia-Ju Bai wrote:
>> As described in a previous commit 998b30c3948e, current->io_uring could
>> be NULL, and thus a NULL check is required for this variable.
>>
>> In the same way, other functions that access current->io_uring also
>> require NULL checks of this variable.
> This seems odd. Have you actually seen traces of this, or is it just
> based on "guess it can be NULL sometimes, check it in all spots"?
>

Thanks for the reply!
I checked the previous commit and inferred that there may be some problems.
I am not quite sure of this, and thus want to listen to your opinions :)


Best wishes,
Jia-Ju Bai
