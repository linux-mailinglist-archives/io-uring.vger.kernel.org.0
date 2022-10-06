Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26B945F6F94
	for <lists+io-uring@lfdr.de>; Thu,  6 Oct 2022 22:46:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232154AbiJFUq1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 6 Oct 2022 16:46:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbiJFUq1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 6 Oct 2022 16:46:27 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43135B4890
        for <io-uring@vger.kernel.org>; Thu,  6 Oct 2022 13:46:26 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id s206so2891082pgs.3
        for <io-uring@vger.kernel.org>; Thu, 06 Oct 2022 13:46:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CuzxlrAFUMYKMbhGcsUJvNhoqXSyV/UZcCRzqF+ezzE=;
        b=g3FwrM+/JzZo5LH8aizwAg8JMjbeMVv7LGMG3sDWlqhwbUnPS1uRaaK/9Jdg1DjsRG
         ggUPSPJbn8+niRIEZsAFBEJ784yyG+wxAM5AH4KS6r1F5R9dYGgPyAoSilnxjM1RAyV+
         8YE4bJDnJgIKaHTbIxPIqB0LLJjUjTiW8XDyArcLz/1XwiF5zNVsDYAkU78tUzbjP8dM
         W+MKhuSKP78KVwxGN0iVQnlvCdXkTrMAoZXQMrQLcfeRCbnpcTMC7arHbI9PAON5Pk/a
         l2wI7BOIuYjQFkqBtZfjeY6rzVDIuBd2aSNe2IbP7IMYOsF0o4lfStPu6AI3yQqQl5Mh
         fP4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CuzxlrAFUMYKMbhGcsUJvNhoqXSyV/UZcCRzqF+ezzE=;
        b=H36JIlqEneB7BXlZL4mh+7s03Vm0v687olXu4zdrlyIx6cN3zs2bh0LfZHsrFuG6ym
         8UvFmtOaV3P75940J0o1TnDSWZfe9er9uAR6tLZsW8+nounm7NHD+wY45M1HMO7jdeUv
         PSjLLWgkCE/0yye1715c660MXUokr2en0NFqL18wUwP7OPdI6EXFERHPZ9Uf0ouH/KMZ
         OtGMVFHImITWr01Cb0AztgG0c2mrTHnAsKC5mr28n0pqIEa5fxoZjbt55WaBbYANU3rv
         T1Q9GO1y0edPYnCM9NMEaSLcX7g3T4zVQS76KJ4oHKv2zLmrLT2dSfDCrdmjdFQlwNMS
         4Tfg==
X-Gm-Message-State: ACrzQf1Oaio2Py+vyF6bCJ+NCkCKuSlByzuyjcXNQNZTjGZuxbBViwOE
        sbJ1sgrkC+t8322CT1LW62YJkDZq97NXAQ==
X-Google-Smtp-Source: AMsMyM4LrPFFzWkihM4Lr8h1oipZoutAsBf1yip61gKYWIZbv91cjp4mSkJSpffWWprzkYFQg9RhMg==
X-Received: by 2002:a05:6a00:1d83:b0:561:d2f8:b86d with SMTP id z3-20020a056a001d8300b00561d2f8b86dmr1291283pfw.57.1665089185628;
        Thu, 06 Oct 2022 13:46:25 -0700 (PDT)
Received: from ?IPV6:2620:10d:c085:21d6::10c4? ([2620:10d:c090:400::5:9a90])
        by smtp.gmail.com with ESMTPSA id j5-20020a170903024500b00178650510f9sm37278plh.160.2022.10.06.13.46.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Oct 2022 13:46:24 -0700 (PDT)
Message-ID: <266638fb-7406-907d-c537-656bed72fac3@kernel.dk>
Date:   Thu, 6 Oct 2022 14:46:22 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH for-next 0/2] net fixes
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1664486545.git.asml.silence@gmail.com>
 <166449523995.2986.3987117149082797841.b4-ty@kernel.dk>
 <27c5613c-6333-c908-0c73-02904a8e5c37@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <27c5613c-6333-c908-0c73-02904a8e5c37@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/6/22 2:30 PM, Pavel Begunkov wrote:
> On 9/30/22 00:47, Jens Axboe wrote:
>> On Thu, 29 Sep 2022 22:23:17 +0100, Pavel Begunkov wrote:
>>> two extra io_uring/net fixes
>>>
>>> Pavel Begunkov (2):
>>>    io_uring/net: don't update msg_name if not provided
>>>    io_uring/net: fix notif cqe reordering
>>>
>>> io_uring/net.c | 27 +++++++++++++++++++++------
>>>   1 file changed, 21 insertions(+), 6 deletions(-)
>>>
>>> [...]
>>
>> Applied, thanks!
> 
> Hmm, where did these go? Don't see neither in for-6.1
> nor 6.1-late

They are in for-6.1/io_uring with the shas listed here too:

>> [1/2] io_uring/net: don't update msg_name if not provided
>>        commit: 6f10ae8a155446248055c7ddd480ef40139af788
>> [2/2] io_uring/net: fix notif cqe reordering
>>        commit: 108893ddcc4d3aa0a4a02aeb02d478e997001227

Top of tree, in fact:

https://git.kernel.dk/cgit/linux-block/log/?h=for-6.1/io_uring

-- 
Jens Axboe


