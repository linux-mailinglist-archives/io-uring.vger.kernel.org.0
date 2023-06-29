Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D9B47429A8
	for <lists+io-uring@lfdr.de>; Thu, 29 Jun 2023 17:29:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232212AbjF2P3O (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 29 Jun 2023 11:29:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231838AbjF2P3N (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 29 Jun 2023 11:29:13 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2529BAA
        for <io-uring@vger.kernel.org>; Thu, 29 Jun 2023 08:29:01 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id 4fb4d7f45d1cf-51de9c2bc77so251909a12.3
        for <io-uring@vger.kernel.org>; Thu, 29 Jun 2023 08:29:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1688052539; x=1690644539;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=wx+4npIK6ggBgqg5Ikl2o+KTDuvkPqB2u/Qe38+I6NE=;
        b=UQpGkCL9YJMy/UxnCWGkbYSo26IJe8fB3U1ktSJh4v7wU4gpys4x7S7HS3Bt0qNSkR
         8VhE/MZA4H/OItizG+6x8ZEm7qrqxtvNk3eUZzbYSdagQAnZMZYN4iipupCFl763YTK6
         cSF9lcu+lpL1lFDBd+DGKaXsY1ptwFsXNhfzTftFMDOfdR2G0xo8owDMs4bbaE29DxAX
         CFgh1OzTalgyAB5ztyfoaj2xzkqs3h+MmbuvQ7Wbd9QcWH4mcHN1/3inlIMSXCgDtiix
         ZhCH/Dyi2TIAZW7BFOScweCd1c8B5WrQP+W9zYaSJH8l/35h++oP+7qEkE1Uis0gfC6b
         HdVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688052539; x=1690644539;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wx+4npIK6ggBgqg5Ikl2o+KTDuvkPqB2u/Qe38+I6NE=;
        b=RTFGD0fcpu6G1+8aOkWf0qkO+0927NPc2kDnySsJ1f6tnK8ltghPsAXWrncMvv5k6G
         sPShKLIGCNRV2kD9mb0fapljH6kdiMoeF9bIZLoxCghwF6nfiU0brxLexIOVflY56lee
         Z1iiBnERpmLstDe8hKAZ0AGAKidhWKT1j88JWfdAT5Ty9PxTp0ioFlB7qUWTQWFuHmxQ
         bWdfHPr1IVf/FPwcfqvAxUigcgitKtVjpLghwj3ilfaNbD1owTHRYKBybYi6kC/dNnV0
         MScKCkjrMQZJdVJPXMeIDy+0oJ9P/6GTqm+n1NxzaTt/Kml1kNcdktoiXI5Ech0/JUAg
         3tuw==
X-Gm-Message-State: AC+VfDyv40g/wypBBDxqq4VLo8Y1dJkJUAS03a+fMa+XCtweqn698a59
        DD2aUNGy9GVn5p7CMV1bYAboW6QxfWifO4n59pURJg==
X-Google-Smtp-Source: ACHHUZ7Kr52/aPyBqXhipnCviex3Yi6PzBfiMQbTr8pydMywJDNM9uEvS6ZGzqlBViBHQ+2sIfdMbQH2vP5eOa/+THc=
X-Received: by 2002:a17:907:97d6:b0:988:57b4:2853 with SMTP id
 js22-20020a17090797d600b0098857b42853mr29800648ejc.25.1688052539500; Thu, 29
 Jun 2023 08:28:59 -0700 (PDT)
MIME-Version: 1.0
References: <20230629132711.1712536-1-matteorizzo@google.com>
 <20230629132711.1712536-2-matteorizzo@google.com> <a0c8d74a-dcfe-78a7-74bd-4447ed6944dc@acm.org>
In-Reply-To: <a0c8d74a-dcfe-78a7-74bd-4447ed6944dc@acm.org>
From:   Matteo Rizzo <matteorizzo@google.com>
Date:   Thu, 29 Jun 2023 17:28:47 +0200
Message-ID: <CAHKB1wKbSoK+=ceM_WLgBConNaua=0UPQv9ZmDp6LNXh3QNr=Q@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] Add a new sysctl to disable io_uring system-wide
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org, jordyzomer@google.com, evn@google.com,
        poprdi@google.com, corbet@lwn.net, axboe@kernel.dk,
        asml.silence@gmail.com, akpm@linux-foundation.org,
        keescook@chromium.org, rostedt@goodmis.org,
        dave.hansen@linux.intel.com, ribalda@chromium.org,
        chenhuacai@kernel.org, steve@sk2.org, gpiccoli@igalia.com,
        ldufour@linux.ibm.com, bhe@redhat.com, oleksandr@natalenko.name
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

On Thu, 29 Jun 2023 at 17:16, Bart Van Assche <bvanassche@acm.org> wrote:
>
> On 6/29/23 06:27, Matteo Rizzo wrote:
> > +static int __read_mostly sysctl_io_uring_disabled;
>
> Shouldn't this be a static key instead of an int in order to minimize the
> performance impact on the io_uring_setup() system call? See also
> Documentation/staging/static-keys.rst.
>
> Thanks,
>
> Bart.

Is io_uring_setup in any hot path? io_uring_create is marked as __cold.

--
Matteo
