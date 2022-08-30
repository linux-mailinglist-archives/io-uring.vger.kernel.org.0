Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A97CC5A6602
	for <lists+io-uring@lfdr.de>; Tue, 30 Aug 2022 16:14:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229848AbiH3OOm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 30 Aug 2022 10:14:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229972AbiH3OOl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 30 Aug 2022 10:14:41 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79426F826F
        for <io-uring@vger.kernel.org>; Tue, 30 Aug 2022 07:14:40 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id i77so9309674ioa.7
        for <io-uring@vger.kernel.org>; Tue, 30 Aug 2022 07:14:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc;
        bh=i7zNg0BSUxqwtCI4z0pxRrzokR8vlBB38y5Casl7Awc=;
        b=x/D8aen/4r4ZlBBAFyRsZee67ThQrnuuVTWdIZ++jBIpG3tcAa/cPcVW8/GzJF4Pek
         APOvN9cX+xEV1mvL0bvuG+3E2PiibBgSluHcnktvzCcNecZNpelPJImGoDIK914W2mOj
         tRTmltN46kMCbEbbZMbS8BU98PGakTRkCRVlQKSIRerqMIWcyw4HhITB0v2G4ldGlegh
         Au6WvKcl+9JtFFwFR3rsoExQoWUn+8NpvitKO4qdGcNCGpy9sKXaDAVxtRZE6EyCCJ1L
         h5wbTSJ+cUOdn8JMmH07GSAhdEZvqRe4RoM/VhvI52ISVNLzrNQQz/UVG3ycQrfpOTJ+
         Q6jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc;
        bh=i7zNg0BSUxqwtCI4z0pxRrzokR8vlBB38y5Casl7Awc=;
        b=gEDrLXqINzxkPennbMFFq836dR2YlA49MRomPcRe+6p2z2/jAJqDCzp5VY3hGhQTsf
         4L+KUADBf/h+GzV+nJ3ZBU8/x6ggV++lK4V7R1fcgsIGGz38lwNJe5aRLbnzePdgn2Ry
         Jdi+K1yNqUFto9ELVinc3uhjQ1oqIZhDOtWL7hWJoOVq0KvIMKF/bNITo49JZSHDuGD6
         lYgPz8T7yPmhp55BSzqDlnXJqjmqD6q3kyIUM3FKTHR1TedFquSgFiMFjz9gHmQZkhLM
         YSf0PTPAiqV6zzMyylk3M9RGoeT7QmhFdn7Ojvs59bNou8qqY4szuNYa35TPU79Anclu
         7DFw==
X-Gm-Message-State: ACgBeo3292gQbWPCUsgZe3dGmWgdQMpJzArGAyIzYLVif9mV9Ln3Ujmw
        KsGOj4IHxZI6os5A3MoL2rghIuEQTy7z+Q==
X-Google-Smtp-Source: AA6agR5tBbIlgUln84Ol1tt7VPgk751SFID9WmLzW6T3veKSNvAM8Jyl9Ls50OTiJv1EiTsnFtbslA==
X-Received: by 2002:a05:6638:3a16:b0:349:d8cc:2d22 with SMTP id cn22-20020a0566383a1600b00349d8cc2d22mr12530344jab.224.1661868879853;
        Tue, 30 Aug 2022 07:14:39 -0700 (PDT)
Received: from [127.0.0.1] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id m13-20020a92cacd000000b002dd0bfd2467sm5670937ilq.11.2022.08.30.07.14.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Aug 2022 07:14:39 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kanna Scarlet <knscarlet@gnuweeb.org>,
        Caleb Sander <csander@purestorage.com>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        Muhammad Rizki <kiizuha@gnuweeb.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>
In-Reply-To: <20220830005122.885209-1-ammar.faizi@intel.com>
References: <20220830005122.885209-1-ammar.faizi@intel.com>
Subject: Re: [PATCH liburing v2 0/7] Export io_uring syscall functions
Message-Id: <166186887874.35842.10405862161728511204.b4-ty@kernel.dk>
Date:   Tue, 30 Aug 2022 08:14:38 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailer: b4 0.10.0-dev-65ba7
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, 30 Aug 2022 07:56:36 +0700, Ammar Faizi wrote:
> From: Ammar Faizi <ammarfaizi2@gnuweeb.org>
> 
> Hi Jens,
> 
> This series adds io_uring syscall functions and exports them. There
> are 7 patches in this series:
> 
> [...]

Applied, thanks!

[1/7] syscall: Make io_uring syscall arguments consistent
      commit: 09164272d3aa5f4727fdf2181284d29e88194201
[2/7] syscall: Add io_uring syscall functions
      commit: f0b43c84cb3d1a4af4f1a32193bcad66fe458488
[3/7] man: Clarify "man 2" entry for io_uring syscalls
      commit: 9a8512f6dbd259a52b3f98fb5e6324a9b2841c3c
[4/7] man: Add `io_uring_enter2()` function signature
      commit: 584b9ed0ceef30934e747435fe0b535528495de6
[5/7] man: Alias `io_uring_enter2()` to `io_uring_enter()`
      commit: 8251e2778b0a1a897337aa011cb59ec85de599e0
[6/7] test/io_uring_{enter,setup,register}: Use the exported syscall functions
      commit: 64208a184c155580bfde12ced79ff09d9bcc52a8
[7/7] man/io_uring_enter.2: Fix typo "which is behaves" -> "which behaves"
      commit: 1ef00fc157cd0fa96d4da355ee86c977b6e4169e

Best regards,
-- 
Jens Axboe


