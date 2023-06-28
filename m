Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78A6D7414A6
	for <lists+io-uring@lfdr.de>; Wed, 28 Jun 2023 17:12:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229924AbjF1PM4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 28 Jun 2023 11:12:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230420AbjF1PM4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 28 Jun 2023 11:12:56 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FE12A1
        for <io-uring@vger.kernel.org>; Wed, 28 Jun 2023 08:12:55 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id a640c23a62f3a-98e39784a85so194080866b.1
        for <io-uring@vger.kernel.org>; Wed, 28 Jun 2023 08:12:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687965173; x=1690557173;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=TEPHgY7GKbiF+bbsFDPJ1N0ThqLb/95Yk4P2Ndq0Cf0=;
        b=1HSbYA14PwbTl7aYIHkFeD4WrFU+1yU3qwZYGOcDz5Kg4jiCY4/xPW0Ba4ZZyh1ozn
         RyQkFx3+XorZswA3SbauYwj+467/ZTVzAkFrdcdaHS+RFaNBW//EIwjneVySSVvCpII/
         +nu1GrCqx/kJP+2kuEeyPvaW0e1l5/P8YpkJuubdQO4N4shz/sNJUaSkNqAPukX5Q7vT
         jhGJCfvrnI8F5hBiHiMx6dStMtn3R7kBcVUv2MHUGLpXXNV4VFqBoWvuy2UDh1aU0ES6
         IEg/hMzwZoMrkZb9tCN6l8d4tWYJ0C7FF1cxOeHzDQyCFOtfOhSZEiQxPrcTYlAHBnio
         NZqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687965173; x=1690557173;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TEPHgY7GKbiF+bbsFDPJ1N0ThqLb/95Yk4P2Ndq0Cf0=;
        b=W25f0K3izMtSAVmPAttp7Dqcj6qxIliFnRBRETFpOCRClliJ0EdufThBRaR/yETJa1
         WMkA1QzB8HPHQXflJLtKQpUKK8K8qafiBxB5S9a5nWpPPStSpOqUr3+Ge3xwjz6weayS
         pmOSUQdxzJP9MeKVW11yXnfrhI6EmQurINcvB2UG+QpAZviFT/3xLd+Tx2G794okzy4X
         NakL6z12gJPq/ZdvMFf+Tvfb9nHGodKtBBL4BBPrOcI1u+DbXYVLSWATafwoenSanbiH
         k1mkTVWwUYz6XMAOiCKPasD1g5qxCZE24HaMPpCWyyUtu01+lB7qAyl6kXmRe6gqYu0S
         XkWA==
X-Gm-Message-State: AC+VfDxFbIoPcZOiOiIZ3+K/Wy0EwbR4rdf/jRvDY+tZAWXviOoUALEU
        hzxWK+4qHYIKirWceytYpon301LDr9FMx1iZbrU5hepK92lmX+1VMBnF0g==
X-Google-Smtp-Source: ACHHUZ7UuL8ZBMWlyWdJrkY3dNefm8jZW8JSGnKNDdEDVURdgVH+tvbbzsH4uStA2/DZ58NExa0jwW00Jh2AaaCClJM=
X-Received: by 2002:a17:907:2d25:b0:992:4723:76f4 with SMTP id
 gs37-20020a1709072d2500b00992472376f4mr1378215ejc.6.1687965173386; Wed, 28
 Jun 2023 08:12:53 -0700 (PDT)
MIME-Version: 1.0
References: <20230627120058.2214509-1-matteorizzo@google.com>
 <20230627120058.2214509-2-matteorizzo@google.com> <e8924389-985a-42ad-9daf-eca2bf12fa57@acm.org>
 <CAHKB1wJANtT27WM6hrhDy_x9H9Lsn4qRjPDmXdKosoL93TJRYg@mail.gmail.com> <CANiDSCvjCoj3Q3phbmdhdG-veHNRrfD-gBu=FuZkmrgJ2uxiJg@mail.gmail.com>
In-Reply-To: <CANiDSCvjCoj3Q3phbmdhdG-veHNRrfD-gBu=FuZkmrgJ2uxiJg@mail.gmail.com>
From:   Matteo Rizzo <matteorizzo@google.com>
Date:   Wed, 28 Jun 2023 17:12:42 +0200
Message-ID: <CAHKB1w+UyOnC_rOBABVhmzG+XeePaWYgPJWxX9NUeqnAi9WcgA@mail.gmail.com>
Subject: Re: [PATCH 1/1] Add a new sysctl to disable io_uring system-wide
To:     Ricardo Ribalda <ribalda@chromium.org>
Cc:     Bart Van Assche <bvanassche@acm.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
        jordyzomer@google.com, evn@google.com, poprdi@google.com,
        corbet@lwn.net, axboe@kernel.dk, asml.silence@gmail.com,
        akpm@linux-foundation.org, keescook@chromium.org,
        rostedt@goodmis.org, dave.hansen@linux.intel.com,
        chenhuacai@kernel.org, steve@sk2.org, gpiccoli@igalia.com,
        ldufour@linux.ibm.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, 28 Jun 2023 at 13:44, Ricardo Ribalda <ribalda@chromium.org> wrote:
>
> Have you considered that the new sysctl is "sticky like kexec_load_disabled.
> When the user disables it there is no way to turn it back on until the
> system is rebooted.

Are you suggesting making this sysctl sticky? Are there any examples of how to
implement a sticky sysctl that can take more than 2 values in case we want to
add an intermediate level that still allows privileged processes to use
io_uring? Also, what would be the use case? Preventing privileged processes
from re-enabling io_uring?

Thanks!
--
Matteo
