Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 383F060609C
	for <lists+io-uring@lfdr.de>; Thu, 20 Oct 2022 14:52:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229898AbiJTMwM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 Oct 2022 08:52:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbiJTMwL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 20 Oct 2022 08:52:11 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FBD817F283
        for <io-uring@vger.kernel.org>; Thu, 20 Oct 2022 05:52:11 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id h12so19715717pjk.0
        for <io-uring@vger.kernel.org>; Thu, 20 Oct 2022 05:52:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OL486cRIa/yjkXsURsjAZu0Hh8MyUBVelkMnNnPhT6Q=;
        b=UjO/JDY1FIN5uts78LmRtIxR84g/4ss1SSTNaZylujSbG5V55TZhRTxp/Y5CvoHRXi
         n45pW4nC1TF2MT1pEeT8o2QqgZZJEx3hffcAuL6ErDIwxQaf6wSburuNiwz/4mwbVKkV
         agaOyw9nsc7Uh63XMoE+jZpaOVr9HqJPHyRrYyWgjeQKf/+4Rx4MX42h7WrQykoqTNs1
         c551lnqpZVbHB9TGOqThzP6sqo/pKBZZRgBh0GTa6kFLrmGViOOD3FT8UUwLpou2BQBC
         LdpFS0GTtgsQRCh2t///xr4ohKu2GJZRLddnc3Per+ML3Yh3gfVeFcKRLqPdcpjqwClH
         9OEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OL486cRIa/yjkXsURsjAZu0Hh8MyUBVelkMnNnPhT6Q=;
        b=vDNIq1ZOp7cs679cUzbXcACMVPtjfAsel3AENPdxtxEoAbOpb23Qy9zleg7UZXUbio
         Vthg36/fiiGWmbXS3TNszzFa3gYamWVspSSkmGegAGT0sBd5tPXo1qSQB0F4zJMlpDAT
         YyuPAH9DcKRYW5SwWbWdu3QGPW6X8ihGokMf3cwBczyYYP/CWRMi3whvXgwsffk9t9p3
         Lk07QRiW1SlEyfBuMEDie+hHZXchlLiGDMjR/qye9Ps2oxSdtx/eNGFaP0SAMWAxZUp5
         xAFQdx3YoUm+l3YyjmSnEX0pzvmNqWGHOprcF744+jhp7x4Jll3hpE04/ITR+yJBKEVK
         o7XA==
X-Gm-Message-State: ACrzQf3vwoBxnU/gnMyx4aFv+bvClINKC3DZ5HQ2GjXNG5iGBYTaDHmO
        Qr+qLFx/C8zQNu3a7y/mcky9kg==
X-Google-Smtp-Source: AMsMyM60cDyvyOthu9kKpiIQifR9anhrqnoXVAMxGCKjYj8tunVESySU5eFBeH8DDzWI/qazI3MQ7g==
X-Received: by 2002:a17:902:ce12:b0:17a:3e76:8568 with SMTP id k18-20020a170902ce1200b0017a3e768568mr13922858plg.11.1666270330759;
        Thu, 20 Oct 2022 05:52:10 -0700 (PDT)
Received: from [192.168.4.201] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id b6-20020a170902650600b00186617af88fsm1560427plk.174.2022.10.20.05.52.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Oct 2022 05:52:10 -0700 (PDT)
Message-ID: <f905c8cb-702f-6b2c-8954-1a736feb1ee7@kernel.dk>
Date:   Thu, 20 Oct 2022 05:52:08 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
Subject: Re: [PATCH liburing v1 1/3] liburing: Clean up `-Wshorten-64-to-32`
 warnings from clang
Content-Language: en-US
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Dylan Yudaken <dylany@meta.com>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Facebook Kernel Team <kernel-team@fb.com>,
        Dylan Yudaken <dylany@fb.com>
References: <20221020114814.63133-1-ammar.faizi@intel.com>
 <20221020114814.63133-2-ammar.faizi@intel.com>
 <0e72af49-9e6c-2cc2-c53c-3966b20517cf@gnuweeb.org>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <0e72af49-9e6c-2cc2-c53c-3966b20517cf@gnuweeb.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/20/22 5:12 AM, Ammar Faizi wrote:
> On 10/20/22 6:52 PM, Ammar Faizi wrote:
>> From: Dylan Yudaken<dylany@fb.com>
>>
>> liburing has a couple of int shortening issues found by clang. Clean
>> them all. This cleanup is particularly useful for build systems that
>> include these files and run with that error enabled.
>>
>> Link:https://lore.kernel.org/io-uring/20221019145042.446477-1-dylany@meta.com
>> Signed-off-by: Dylan Yudaken<dylany@fb.com>
>> Co-authored-by: Ammar Faizi<ammarfaizi2@gnuweeb.org>
>> Signed-off-by: Ammar Faizi<ammarfaizi2@gnuweeb.org>
> 
> BTW, before it's too late. I think we should be consistent on the cast
> style:
> 
>    (type) a
> 
> or
> 
>    (type)a
> 
> What do you think?

I tend to prefer (type) a, but sometimes if you have multiple casts
or the lines become too long, I'll do (type)a. I don't think it's
super important in terms of style, as it isn't that prevalent.

-- 
Jens Axboe


