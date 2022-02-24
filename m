Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6652D4C2DD8
	for <lists+io-uring@lfdr.de>; Thu, 24 Feb 2022 15:05:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230080AbiBXOFO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Feb 2022 09:05:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232525AbiBXOFN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Feb 2022 09:05:13 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98FE7214F8B
        for <io-uring@vger.kernel.org>; Thu, 24 Feb 2022 06:04:43 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id a5so1108497pfv.9
        for <io-uring@vger.kernel.org>; Thu, 24 Feb 2022 06:04:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=nF16udT3i+I9kOUhTowohEeKu6aavjop4Wroe6B/uys=;
        b=5DbCILAUW20kF31eWyRXSk47T21Dpe1gXQ6IhGi/rfiZjJOt5mYfwnJ+x4EyEwQ03w
         NIDUzIKWJ1FqhOsZp7JikUx49cooaCo4i5HQQWn5zxqKXZDPf3bO8l60RQu4vQmGixI9
         MF1dw+GIDAvy6T2DOyMUOBtz69KJuJCk2JWHCZKyXF0aNFdKP4LbGFNEoIe0NZyRIGgb
         RorqmaIWW6aPkPLXE3NV57bHZshTUl/WAnlZDI0YXBqsDToDOlfxe5ot/SrmJ+5SlsKe
         ngEel+jug4887+vNpol7BQ9s/QEP5ODpXofWPjuh0uzci9VFuRAqMdt+vou5F4SoG6ro
         /5Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=nF16udT3i+I9kOUhTowohEeKu6aavjop4Wroe6B/uys=;
        b=drrFkllBBLcY/rgQDK6vlZMQw3M+pZHpY+cjbixTM0uEdKCDpwtw9LQBWcw9vARz+W
         Yhm47Zj/YkFxamF2QxZcFBd1HHBOYK23jwU4+1tBGQI8UkUxET68WgzWQ15Juae3qhbN
         +ywH9eDFDiG0G9zGq6oBbEFNs3QZo3Bj7J7qep2Z7eV+x73JHlg7eeEuKQulawR6/8Ix
         SXplBLGyGCWHd98LON5BPvAy8trJ3XaK7CRjbgSJN4ta9+IX2vwJKFCqv1S4oE/n0OC4
         vKPFuRzWguX/QUpKKXW6WMhcrtK4iZPiVD4GvwaU6kIc6jmqOA9lzLkWjnKrFJLc7f+W
         /iAA==
X-Gm-Message-State: AOAM530j3VCCU2O/0zYyOzDLmSVvvDC5OWdTq28dG/o3sdk/FqcaAJ4g
        CbNN1ljMSUx+XxksXyDQmb6fKg==
X-Google-Smtp-Source: ABdhPJwGm1awgzCr1i9zCic1w2kkrofxvW643Ib+/NzTCF+q66BaFxRbwcL0uxXfvYcm6ZeOdG62Ww==
X-Received: by 2002:a63:5063:0:b0:372:fafe:7bd6 with SMTP id q35-20020a635063000000b00372fafe7bd6mr2347274pgl.70.1645711482943;
        Thu, 24 Feb 2022 06:04:42 -0800 (PST)
Received: from [127.0.1.1] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id k11sm3543976pfu.150.2022.02.24.06.04.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Feb 2022 06:04:42 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     Dylan Yudaken <dylany@fb.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org
Cc:     kernel-team@fb.com
In-Reply-To: <20220224105015.1324208-1-dylany@fb.com>
References: <20220224105015.1324208-1-dylany@fb.com>
Subject: Re: [PATCH liburing] Remove fpos tests without linking
Message-Id: <164571148210.4489.1256055358138414325.b4-ty@kernel.dk>
Date:   Thu, 24 Feb 2022 07:04:42 -0700
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

On Thu, 24 Feb 2022 02:50:15 -0800, Dylan Yudaken wrote:
> There are still more discussions ([1]) to see how to have consistent
> r/w results without link, so do not test these cases.
> 
> [1] https://lore.kernel.org/io-uring/568473ab-8cf7-8488-8252-e8a2c0ec586f@kernel.dk
> 
> 

Applied, thanks!

[1/1] Remove fpos tests without linking
      commit: 896a1d3ab14a8777a45db6e7b67cf557a44923fb

Best regards,
-- 
Jens Axboe


