Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79A927131EC
	for <lists+io-uring@lfdr.de>; Sat, 27 May 2023 04:23:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230519AbjE0CXD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 26 May 2023 22:23:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237745AbjE0CXC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 26 May 2023 22:23:02 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0772A13D
        for <io-uring@vger.kernel.org>; Fri, 26 May 2023 19:23:00 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id d2e1a72fcca58-645cfeead3cso333479b3a.1
        for <io-uring@vger.kernel.org>; Fri, 26 May 2023 19:23:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1685154179; x=1687746179;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p2feBH12Z8SAMM4VHEI/+F0SHxrti0MmxwQP67KTgb0=;
        b=noBfmriExgMGn2b8MFvbVyEoZoun6FBd5DwIGBLr4TNPcOoejcTsnnbvQeXl96iGRL
         dx+QCrbqDeIcU2emn9CsH1DVxlRidKtV7oSLywd67su8Ab5ybn4KC0a/mZ3db4yo0KFs
         ppTMn+/vAqyzDrk4kwj1RMI7UKraCavSqtqMyBsbDyiTkZaxZbe0u5E75tbRRAv292zR
         2DTo2VP6b2zcpyu2KAgyLD5d5sjcC7zx7F1Mut9qUoUs6uG9mIA/zZ9Zp5kthFhTc4Zw
         8X5sZzsGAVzH1fbKoI+gv/03V5t8+q9R/5/QlC3/dJqHO5otrs66YMNRr2G0UGV00+50
         dJ1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685154179; x=1687746179;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=p2feBH12Z8SAMM4VHEI/+F0SHxrti0MmxwQP67KTgb0=;
        b=QlEA+lijo+DNLYNxeM/re8sjSSggsc550rYXOK2AR40Hb5bKzRe3OWT+JGehtGE5+2
         4t3aZH1gV9KBts21dm+QqysOe9UE1o7czwNfB0v99OU7J6aLCwnPFkEU/Xs9iXNigZHw
         2dK7mYXAmnoxiYFDbZqpek4mk6TTsQMT/IoV0MeIWJgkeIYQ14WPQaIbLBijTMOrGa02
         Vp9Wie1iaeowhVoX4HqtKuwHmuCHoJ6o7xGVXp/oduJ1KNemaEkdBp4+iEwo+8cQr7g+
         qV8IlKE5n69L2WDu+hzWiWQHDIVZOoRSfc54kvQXNTJvD8kzi1PSrmDXhw+63t6Jj0v+
         l7jg==
X-Gm-Message-State: AC+VfDzrPhQFQt9w95bCpqcCxv7muVUUlEuyGEDkYVmHdc82IYrvD8HU
        0s/1XWEs+sEVCEGpz6LZeaib+8IsPFfjVkds10U=
X-Google-Smtp-Source: ACHHUZ40W6Mr5T4Xt+0WJqXTQ8R/RI/WTlVcHGY/74/Gz2T1YLhxuJl8LM3gs7fVqSLffHfwz0wO0w==
X-Received: by 2002:a05:6a21:339a:b0:101:367:97ef with SMTP id yy26-20020a056a21339a00b00101036797efmr4041064pzb.1.1685154179145;
        Fri, 26 May 2023 19:22:59 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id a21-20020aa78655000000b0064f83595bbcsm3265142pfo.58.2023.05.26.19.22.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 May 2023 19:22:58 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, Ben Noordhuis <info@bnoordhuis.nl>
Cc:     stable@vger.kernel.org
In-Reply-To: <20230506095502.13401-1-info@bnoordhuis.nl>
References: <64e5fbc2-b49f-5b7e-2a1e-aa1cef08e20c@kernel.dk>
 <20230506095502.13401-1-info@bnoordhuis.nl>
Subject: Re: [PATCH] io_uring: undeprecate epoll_ctl support
Message-Id: <168515417829.871550.12902048630559626887.b4-ty@kernel.dk>
Date:   Fri, 26 May 2023 20:22:58 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.13-dev-00303
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On Sat, 06 May 2023 11:55:02 +0200, Ben Noordhuis wrote:
> Libuv recently started using it so there is at least one consumer now.
> 
> 

Applied, thanks!

[1/1] io_uring: undeprecate epoll_ctl support
      commit: 4ea0bf4b98d66a7a790abb285539f395596bae92

Best regards,
-- 
Jens Axboe



