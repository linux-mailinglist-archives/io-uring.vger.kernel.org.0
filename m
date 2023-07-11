Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E2E674F959
	for <lists+io-uring@lfdr.de>; Tue, 11 Jul 2023 22:51:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230314AbjGKUvI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 11 Jul 2023 16:51:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230078AbjGKUvH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 11 Jul 2023 16:51:07 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D94110E3
        for <io-uring@vger.kernel.org>; Tue, 11 Jul 2023 13:51:06 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id d2e1a72fcca58-676cc97ca74so1394047b3a.1
        for <io-uring@vger.kernel.org>; Tue, 11 Jul 2023 13:51:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1689108665; x=1689713465;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4KQjS5IB3HxBUPRZ52PjYkeXdm3xeIYaSrFkecAH7Y8=;
        b=Yg8x27vG/jo6ntfVpqL8SMdc3Am7rOf3C7GPs7yktDM+ZCn1UZeK40SAnkL01dlsV4
         UV3H+VsihfkXwmmDVvR8Bp7NbGejdB7OkPyrboUWGD10jjFZvA7ujOiXM0wKU8ICxCa9
         mhjH+wEBOxEY1/vBCewgN6lm5PkMnN0sfDKN0C8W2jf00OuT7utWoK+M/Yo5mMdlTcb2
         N3Jv/ubTq/TgNQhiTmxnuGB+2RUcCikJDdu/em9DUt8s6T0QbiacuYCWMop1NvbK+fHa
         HykDUrvNmHuUudYMqoYnAO+WTHE+TVMR6migYeCZIoxOePT3b0g7Gnjl/vY/uB85/xqC
         4wtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689108665; x=1689713465;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4KQjS5IB3HxBUPRZ52PjYkeXdm3xeIYaSrFkecAH7Y8=;
        b=QUU/UKicY3aRDU2yjSBXWgqM2Ac2hmf0CAi2ZHJqA9L4xbU7UOFULmtfNjuFw/ohNs
         C9fZQmYaO+hRlcUkmbWX6qYGGUsPnwfBEuz7LvKB7hC/TkWu2p+QIdK31IoAgUz+sa2Z
         /WCgfbz/A/vRrmrkv4XWegJD9UCa924caJOgaHjktQ6NQhIOm4rcrpPtcY3wagiud1SR
         E+pU298F5K3jpOlO5x78Gv8hLWZzGOrrMkroPM12JCNNCNR0/F8r3/spEHAcM7zBiVzT
         lzann/COpF48TsLGK9pD4j2va7f0+MLr3GyUFtuAB4ph3DlWjKq8C1JVbWUpktF95pi3
         /ZYA==
X-Gm-Message-State: ABy/qLbVNZv4ozxakjVGMklEeGQSlzIYGaqf52Zwtw2+J647wpUKeLdj
        RybW+jQZ480Wxe62JqMDUSlVLEJIuJYyEm9IQFw=
X-Google-Smtp-Source: APBJJlFiXWlodvDO3oWvF0y1nyHpjI/oSicwjLwdAwZM3FzbLVW/18gjH31OMzxUAL3pjMrR0gZrqg==
X-Received: by 2002:a05:6a00:e8e:b0:677:3439:874a with SMTP id bo14-20020a056a000e8e00b006773439874amr18907425pfb.3.1689108665547;
        Tue, 11 Jul 2023 13:51:05 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id w19-20020aa78593000000b0067886c78745sm2148776pfn.66.2023.07.11.13.51.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jul 2023 13:51:04 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org, asml.silence@gmail.com,
        Matteo Rizzo <matteorizzo@google.com>
Cc:     corbet@lwn.net, akpm@linux-foundation.org, keescook@chromium.org,
        ribalda@chromium.org, rostedt@goodmis.org, jannh@google.com,
        chenhuacai@kernel.org, gpiccoli@igalia.com, ldufour@linux.ibm.com,
        evn@google.com, poprdi@google.com, jordyzomer@google.com,
        jmoyer@redhat.com, krisman@suse.de
In-Reply-To: <20230630151003.3622786-1-matteorizzo@google.com>
References: <20230630151003.3622786-1-matteorizzo@google.com>
Subject: Re: [PATCH v3 0/1] Add a sysctl to disable io_uring system-wide
Message-Id: <168910866387.217585.15007808058378960214.b4-ty@kernel.dk>
Date:   Tue, 11 Jul 2023 14:51:03 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.13-dev-099c9
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On Fri, 30 Jun 2023 15:10:02 +0000, Matteo Rizzo wrote:
> Over the last few years we've seen many critical vulnerabilities in
> io_uring[1] which could be exploited by an unprivileged process to gain
> control over the kernel. This patch introduces a new sysctl which disables
> the creation of new io_uring instances system-wide.
> 
> The goal of this patch is to give distros, system admins, and cloud
> providers a way to reduce the risk of privilege escalation through io_uring
> where disabling it with seccomp or at compile time is not practical. For
> example a distro or cloud provider might want to disable io_uring by
> default and have users enable it again if they need to run a program that
> requires it. The new sysctl is designed to let a user with root on the
> machine enable and disable io_uring systemwide at runtime without requiring
> a kernel recompilation or a reboot.
> 
> [...]

Applied, thanks!

[1/1] io_uring: add a sysctl to disable io_uring system-wide
      commit: d55f54dac19a0cee1818353ab5aa3edac9034db4

Best regards,
-- 
Jens Axboe



