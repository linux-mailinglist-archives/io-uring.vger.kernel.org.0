Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D4E9564751
	for <lists+io-uring@lfdr.de>; Sun,  3 Jul 2022 15:00:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231419AbiGCNAX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 3 Jul 2022 09:00:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbiGCNAW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 3 Jul 2022 09:00:22 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE0C732B
        for <io-uring@vger.kernel.org>; Sun,  3 Jul 2022 06:00:21 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id k14so6346500plh.4
        for <io-uring@vger.kernel.org>; Sun, 03 Jul 2022 06:00:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=w30BfF1i/+5huQNwQxVcjTGXkb36F3GQzrctPfmsQZw=;
        b=M/RsmaYLDHnO3mfXtnw8JVNWRiaSCT7KzY5Te90lWaJ2LK40E3DrjgykYOPr3hFkHk
         sib1Yu54nc4H5vSTLa5Vxx/vTTK1vyxY6f5n5THu4f57PBdkcUyRcm3IkEqHA9mOdNEq
         vl6iaRRfwd5lfLgHyjK30E0bsVsRWLD8ELfLjf75SPGy1W5qCcGLNofCravOp864I/er
         E+ee4gtP36Ue2+kWuvzlO/01ArjRg3dDLDIdZfHI0AnJkNfaYW48i5GRcshPRmEi0nB2
         kZSkcGg55SHnHplglgVVDr3l3AlsJTJ0MLkQLSD2NoI9Gr/bHgxSvvr50qIPQZo6oncK
         Zjdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=w30BfF1i/+5huQNwQxVcjTGXkb36F3GQzrctPfmsQZw=;
        b=ySwub8Yb8RpmZcCcRw7duziOC5PCzxWKKXE2fSOeSS/6YzJSdN9uLJvkoXzTE7E2hn
         2JMc3CjGvVKBz8POkkPurMFzye4GFM+tJtIhehc410e9zSWnGsTFYmeJ7U8Wu01pGY+S
         PCiY0z2kbx1WptKZEH6M38JIMNm/x/idN5ryw1kfShvynZEDY8r0Tww8qUEg5qzhdcPi
         hg+wN+5xFpbXg2+3RKAZlIzqR7GPMfY/X0LyRlW2eYHmoascunLXGz0GWkYMQCNHlbfG
         BN+ZPSXKe0V+m1LqCxBQxDBEELtwXmbFW4JgBB2SfOjRbT6zmg+TtN45ZS33Xx6NSWJh
         6a8Q==
X-Gm-Message-State: AJIora9SkyF7dOM7HfBZFVCmVunyrCRxZPyCeaSDp6xjM4Ph4HEnWar8
        iVas4CG/PJvzp+cBMwY/MA85CMPFYtdq0g==
X-Google-Smtp-Source: AGRyM1uyQxUCeczkw0ZBSA0rMLCewB01vsbGZrsEAtvatUkwjFVHm5235huT4dcFibd2iorGVhh9Ug==
X-Received: by 2002:a17:902:e5c3:b0:16a:67e7:d999 with SMTP id u3-20020a170902e5c300b0016a67e7d999mr28954861plf.32.1656853221259;
        Sun, 03 Jul 2022 06:00:21 -0700 (PDT)
Received: from [127.0.1.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id s26-20020a65645a000000b0040c755b7651sm18720654pgv.41.2022.07.03.06.00.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Jul 2022 06:00:20 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     ammarfaizi2@gnuweeb.org
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com,
        gwml@vger.gnuweeb.org, dylany@fb.com
In-Reply-To: <20220703063755.189175-1-ammar.faizi@intel.com>
References: <20220703063755.189175-1-ammar.faizi@intel.com>
Subject: Re: [PATCH liburing] test/helpers: Use a proper cast for `(struct sockaddr *)` argument
Message-Id: <165685322035.1103909.10554403221181770675.b4-ty@kernel.dk>
Date:   Sun, 03 Jul 2022 07:00:20 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sun, 3 Jul 2022 13:44:05 +0700, Ammar Faizi wrote:
> From: Ammar Faizi <ammarfaizi2@gnuweeb.org>
> 
> Sometimes the compiler accepts (struct sockaddr_in *) to be passed in
> to (struct sockaddr *) without a cast. But not all compilers agree with
> that. Building with clang 13.0.1 yields the following error:
> 
>   error: incompatible pointer types passing 'struct sockaddr_in *' to \
>   parameter of type 'struct sockaddr *' [-Werror,-Wincompatible-pointer-types]
> 
> [...]

Applied, thanks!

[1/1] test/helpers: Use a proper cast for `(struct sockaddr *)` argument
      commit: 752c325dcde43be8d87f83b16d346beac5e1de2a

Best regards,
-- 
Jens Axboe


