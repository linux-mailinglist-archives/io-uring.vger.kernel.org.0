Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55BC27585F9
	for <lists+io-uring@lfdr.de>; Tue, 18 Jul 2023 22:16:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229946AbjGRUQp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 18 Jul 2023 16:16:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbjGRUQp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 18 Jul 2023 16:16:45 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEF21B6
        for <io-uring@vger.kernel.org>; Tue, 18 Jul 2023 13:16:43 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id ca18e2360f4ac-785ccd731a7so68816039f.0
        for <io-uring@vger.kernel.org>; Tue, 18 Jul 2023 13:16:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1689711403; x=1690316203;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oVimXmbmZTbISW+7n71WjspppK5V6kmtNbt/YEu7vIA=;
        b=XQBKteELQXQuORaGgRT8MImSS86ueNUmG6KmdfwU/IYB/3xX2bftT3kU9krYco4iBf
         2EY8gyAq93spVBZSeqNYbMhhVAusjsvMI1i+kW9/79nxRDHJWUZIUOeXBLQUo4ITiaKl
         hN8dttzbEUwpb9easpzanAVhKCsCH1l3TletOmmAzhY0OFJkRLieHyvIBykbFUElb0ey
         TEyR95wK6S7ITaK/cyhFaVEkXNH5ouo6FD5Ijo1bJ8LI7BXHVca0G0EVijlMgl2+bk7e
         b6nyPVioInukFXEV/ytCqgQ5BKwCPXvEK6nzq5B/tYyL2ovFrPSa6xDzNIFvb7ztxnEk
         pByg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689711403; x=1690316203;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oVimXmbmZTbISW+7n71WjspppK5V6kmtNbt/YEu7vIA=;
        b=VqzsnC8RXC54Iu4XQvZ+1PygtHqweN+l69R9u6vWT+uiELcrVR3nkQhpuDlQLi02VZ
         3rAXuGQkM0VewhB7wjmKfqf3LCtOXw3XhTB7YDrDLQaxqeqISP+auR411jcqRD7w3AgL
         5jV+FVKw8lZjdUiSyJ9iDkmufAKtEw8KvfWArdtOgcPbxh+wWY/HzZuREeg3FgnciyW7
         2VAjnnwx8Z1f8B7eoLnsTzjDdh/CWZ+DLx1IPpPCcVP1BbUVs49QxvlBZbKuamj8y/yQ
         McrB9+Y8Yz1OpVmfNbHGCIxG5QEM18NdkSu1TR8QQjcDH/BWQIPkWdf5XWJlNBB9hdt1
         1U4Q==
X-Gm-Message-State: ABy/qLbD1s74r+OjL7LwjV/SOxi6I7RRldOvifaOh6lzn99/jnqdtew+
        7jnfW045AVSLZpr9n0gUFapT+Q==
X-Google-Smtp-Source: APBJJlG3LsH0V59+W63s/Sd5XTnlN8wuLVAG/nWDa1vOSLOvAlH/dGdy3BqBw/xqRu9m5tl1VqoSyg==
X-Received: by 2002:a05:6602:3f04:b0:780:d65c:d78f with SMTP id em4-20020a0566023f0400b00780d65cd78fmr3674323iob.2.1689711403339;
        Tue, 18 Jul 2023 13:16:43 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id x7-20020a5e8f47000000b00785cfdd968bsm845993iop.5.2023.07.18.13.16.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jul 2023 13:16:42 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     Ondrej Mosnacek <omosnace@redhat.com>
Cc:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20230718115607.65652-1-omosnace@redhat.com>
References: <20230718115607.65652-1-omosnace@redhat.com>
Subject: Re: [PATCH] io_uring: don't audit the capability check in
 io_uring_create()
Message-Id: <168971140212.1482414.1220631096211660246.b4-ty@kernel.dk>
Date:   Tue, 18 Jul 2023 14:16:42 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.13-dev-099c9
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On Tue, 18 Jul 2023 13:56:07 +0200, Ondrej Mosnacek wrote:
> The check being unconditional may lead to unwanted denials reported by
> LSMs when a process has the capability granted by DAC, but denied by an
> LSM. In the case of SELinux such denials are a problem, since they can't
> be effectively filtered out via the policy and when not silenced, they
> produce noise that may hide a true problem or an attack.
> 
> Since not having the capability merely means that the created io_uring
> context will be accounted against the current user's RLIMIT_MEMLOCK
> limit, we can disable auditing of denials for this check by using
> ns_capable_noaudit() instead of capable().
> 
> [...]

Applied, thanks!

[1/1] io_uring: don't audit the capability check in io_uring_create()
      commit: 6adc2272aaaf84f34b652cf77f770c6fcc4b8336

Best regards,
-- 
Jens Axboe



