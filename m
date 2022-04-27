Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E733510FBD
	for <lists+io-uring@lfdr.de>; Wed, 27 Apr 2022 05:57:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241317AbiD0EA1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 27 Apr 2022 00:00:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229651AbiD0EAZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 27 Apr 2022 00:00:25 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54B7470910
        for <io-uring@vger.kernel.org>; Tue, 26 Apr 2022 20:57:15 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id bd19-20020a17090b0b9300b001d98af6dcd1so3906364pjb.4
        for <io-uring@vger.kernel.org>; Tue, 26 Apr 2022 20:57:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:to:references:from
         :in-reply-to:content-transfer-encoding;
        bh=gjDzr4jN+9IV8/Av6hZJPqUgDrXSe5n+214s66b/29w=;
        b=OmQe7vQPm+CnfP3eoUvIrSGaWMCBWqB7nRvEQfK7wtu+EMGoO07vmrdIilyCmNOTAT
         lp3TMoTImYJPLMxP5uAgswqf9CCLBZnbTHTpaIQ+65vN0eNaB6KGiNF3xyMVCeOWu1Ht
         X3XshIJ4exNR77nXYa7km9XUP6oZpsLkP2ECPMWt9dJBtDM9jR2WIbIjYnJ/wlZNpVsd
         vTvOxdqJr4k7uZB1dspGZynsExeQhJZ80ayqObDcjNttZwSV6nv92mVGucBhWHOz8wsP
         +k7Q1Kwpn41Y1z4LdkPqvHQe3Zm5jGUTZAQAefw3CSs4uNVRiLIT1dz3+NZgU4rlsWcw
         gdaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :to:references:from:in-reply-to:content-transfer-encoding;
        bh=gjDzr4jN+9IV8/Av6hZJPqUgDrXSe5n+214s66b/29w=;
        b=49ve/RrCOMV73XGiMw8NnZH24n6xWbuM1EOK9X3f/6+IW865deHNGIPqjVMPVhM+UA
         R9DOouiReWLFnoWX314G73vp9THNYXLySCDdS4yvRcKJWbYWCO8k7KZJ60KW8Sus2uYq
         lGD0DTSmEutmVMXWvxf2MNHQ7T3/WpDad9kSs01pXHK2RBCL+kNgxPGpVJQu+rQ/u+G/
         KmP3W0BKYfif0Js3SncpHnUOTPE4mahFUpEsK2bVkOK6fCs36TkCoUdnNkjIcjXOy6gy
         l1N8Cbclq21/I0BO1oRHYqP4SmDgrITBZjsHavp+0iUDs4geO6X0egfNtF/WUOAVr9L1
         0Csg==
X-Gm-Message-State: AOAM5318rYctxh84KcQ8WoShsYQfqIA2nAtK2u7VebxAwpmH0UPDzYgE
        XDUIZAIwxjsKgmIHz93s9hg=
X-Google-Smtp-Source: ABdhPJwBrCY7TVu8C+1aZNANqQEj7TpNzdEBiRYH1dB4050P7/fYF0YoZeZsQ2IPe6GGaB/b5vDFgw==
X-Received: by 2002:a17:902:ce0a:b0:15d:917:fad4 with SMTP id k10-20020a170902ce0a00b0015d0917fad4mr15039060plg.3.1651031834749;
        Tue, 26 Apr 2022 20:57:14 -0700 (PDT)
Received: from [192.168.255.10] ([106.53.33.166])
        by smtp.gmail.com with ESMTPSA id 18-20020a17090a1a1200b001da160621d1sm526740pjk.45.2022.04.26.20.57.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Apr 2022 20:57:14 -0700 (PDT)
Message-ID: <fa60c17f-a7eb-f075-e3eb-75f468a5df17@gmail.com>
Date:   Wed, 27 Apr 2022 11:57:19 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.1
Subject: Re: [PATCHSET 0/2] Add support for IORING_RECVSEND_POLL_FIRST
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <20220427015428.322496-1-axboe@kernel.dk>
From:   Hao Xu <haoxu.linux@gmail.com>
In-Reply-To: <20220427015428.322496-1-axboe@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 4/27/22 9:54 AM, Jens Axboe 写道:
> Hi,
> 
> I had a re-think on the flags2 addition [1] that was posted earlier
> today, and I don't really like the fact that flags2 then can't work
> with ioprio for read/write etc. We might also want to extend the
> ioprio field for other types of IO in the future.
> 
> So rather than do that, do a simpler approach and just add an io_uring
> specific flag set for send/recv and friends. This then allow setting
> IORING_RECVSEND_POLL_FIRST in sqe->addr2 for those, and if set, io_uring
> will arm poll first rather than attempt a send/recv operation.
> 
> [1] https://lore.kernel.org/io-uring/20220426183343.150273-1-axboe@kernel.dk/
> 
Looks good to me,

Reviewed-by: Hao Xu <howeyxu@tencent.com>
