Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C209B7401EC
	for <lists+io-uring@lfdr.de>; Tue, 27 Jun 2023 19:10:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229809AbjF0RKn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 27 Jun 2023 13:10:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbjF0RKm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 27 Jun 2023 13:10:42 -0400
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EB871708;
        Tue, 27 Jun 2023 10:10:41 -0700 (PDT)
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-6689430d803so2715724b3a.0;
        Tue, 27 Jun 2023 10:10:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687885841; x=1690477841;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QCwreXgAeapFWNeRBQ+PIDdq1pcxDkY0t7LqXpgTL40=;
        b=Jpm7sVu9mTIi9yW+4WcKRT72q+gwbNkg+u+zWHhO8PtzBLIYS6MQNd5zk2yzgv8obK
         zRN6zYtkdWOiGGSKx8zL99yX8w1s3Gf/Gd58ABW+J3hjEZ0M2HPOAgw51nVhLQ5uZen8
         bStQWyjRjUwfTUknzv6hPBrU6LbWwWBC8ATE4isgXHOWYB0zaJIvr+bbSqCm1/5EvlyH
         l7rIvVEEIVP4iWB23EKTXtCv0zB/dbEZpTtO1Kb0pvL+aMFgWYBHlZF9SVAVcKZ4+2O1
         lGJBQMZPCIoSlFL8irTiPFBaXEsltqCVf63Tz/711YYezawmjBre3IwzrjdwtORGVIH0
         NRLg==
X-Gm-Message-State: AC+VfDx8nDq1rjQng4QrdhVJJAcnm198MWljH/WeuYXQ46u6u7Dr0Duq
        emKdTGZigOpt3tx5o8vU2OM=
X-Google-Smtp-Source: ACHHUZ5WBVWb24zJ8B+PGseJCvivZdeiOCS3o/HCt1+PPio2kpc7GKG41VcUoceRKshrgljk89ecbQ==
X-Received: by 2002:a05:6a00:1356:b0:67f:e74a:d309 with SMTP id k22-20020a056a00135600b0067fe74ad309mr615067pfu.30.1687885840698;
        Tue, 27 Jun 2023 10:10:40 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:5a8b:4bea:e452:f031? ([2620:15c:211:201:5a8b:4bea:e452:f031])
        by smtp.gmail.com with ESMTPSA id t17-20020a62ea11000000b0066355064acbsm5644002pfh.104.2023.06.27.10.10.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Jun 2023 10:10:40 -0700 (PDT)
Message-ID: <e8924389-985a-42ad-9daf-eca2bf12fa57@acm.org>
Date:   Tue, 27 Jun 2023 10:10:36 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH 1/1] Add a new sysctl to disable io_uring system-wide
Content-Language: en-US
To:     Matteo Rizzo <matteorizzo@google.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Cc:     jordyzomer@google.com, evn@google.com, poprdi@google.com,
        corbet@lwn.net, axboe@kernel.dk, asml.silence@gmail.com,
        akpm@linux-foundation.org, keescook@chromium.org,
        rostedt@goodmis.org, dave.hansen@linux.intel.com,
        ribalda@chromium.org, chenhuacai@kernel.org, steve@sk2.org,
        gpiccoli@igalia.com, ldufour@linux.ibm.com
References: <20230627120058.2214509-1-matteorizzo@google.com>
 <20230627120058.2214509-2-matteorizzo@google.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230627120058.2214509-2-matteorizzo@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/27/23 05:00, Matteo Rizzo wrote:
> +Prevents all processes from creating new io_uring instances. Enabling this
> +shrinks the kernel's attack surface.
> +
> += =============================================================
> +0 All processes can create io_uring instances as normal. This is the default
> +  setting.
> +1 io_uring is disabled. io_uring_setup always fails with -EPERM. Existing
> +  io_uring instances can still be used.
> += =============================================================

I'm using fio + io_uring all the time on Android devices. I think we need a
better solution than disabling io_uring system-wide, e.g. a mechanism based
on SELinux that disables io_uring for apps and that keeps io_uring enabled
for processes started via 'adb root && adb shell ...'

Bart.

