Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2870C616450
	for <lists+io-uring@lfdr.de>; Wed,  2 Nov 2022 15:02:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231228AbiKBOCp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 2 Nov 2022 10:02:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231301AbiKBOC0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 2 Nov 2022 10:02:26 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F4996450
        for <io-uring@vger.kernel.org>; Wed,  2 Nov 2022 07:02:02 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id g13so9513767ile.0
        for <io-uring@vger.kernel.org>; Wed, 02 Nov 2022 07:02:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3L8OPvIMs12GOVVaW9mTowx43uLiZyMvWQkSrmBGTlU=;
        b=MSYJehSyfwgP5iKX1DgWC6aEyUG1j9Mup5Mx4q9A1cqO5iDJLFddfJp39kvWPAKOZl
         1F9NTt2ftqPE0vJWSBooybA0dIOsH9i6hiv0KGYCbwezlKuC5eNCnAAg4Q3KCAvsTXyd
         ObbBKFgHJAqHLKcOvXclNNYUjNmh2gWef+CZ5+kSm1J4Djg9YCzl+CzBe43esLWMCboY
         c1PavagvLltsNEnrL0M/DL9XGZhfmJ5sRaSlcqx4aKgUZ7X0ueR0Mc63FHH7WIhIU9Qh
         LsXXmJ6+4LXsPgYUp0RUNwawnfZOW8vR4zh6JGVYp/rgWj0zuNtAr+xc7LSSe6jcm0yM
         /J8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3L8OPvIMs12GOVVaW9mTowx43uLiZyMvWQkSrmBGTlU=;
        b=AYu3pHNai8+33bRhg8KY5ixqYIP9J/SREoFKvxEDo8YTjfEoGGFzgW4KdOs6vc2hjZ
         N8sv3oleNSOKleXwYrY7nROPsi0QXjNDvBh2rTEFLoKbOO8flMjF4IOGt9dkLsUMqXxc
         3L6gAwctdeVaVGm3ZYMSfzTmHfTWc4Gs1zxA9IubF4uFT5I6qHBGTElYfycLlqqLbIqd
         CEAf8pA4a6XvBNxnPEjf1WMwbZaEFQjD3diZFYCIAAN0AHv3nu2+X1ZwwAlNkDSA8Ge4
         IveDkXhyJbb4wFbr8FWpmmOIwcabJsI4DkKavfkjLUIMN0TXvo7MRcTZjk6RelzUy+i/
         HoUw==
X-Gm-Message-State: ACrzQf1+0xw6nNmaVNeKpW0lzl2JZkfYOSdCthpRL4AfSczh2qr/Xz4B
        N36cD8GQmPE8PKsAFF5MSlI4BrQWzG9mirBk
X-Google-Smtp-Source: AMsMyM7lQpn81j2+hvr+lnZQUGw0+Y124XsWFQd51K7ycB+QJ1jFmIvbHHv5gq7/tjSHOuOxDCGJ2w==
X-Received: by 2002:a92:c541:0:b0:2fa:771:f5f0 with SMTP id a1-20020a92c541000000b002fa0771f5f0mr15673787ilj.195.1667397721974;
        Wed, 02 Nov 2022 07:02:01 -0700 (PDT)
Received: from [127.0.0.1] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id l83-20020a6b3e56000000b006d2d993c75dsm2088243ioa.7.2022.11.02.07.02.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Nov 2022 07:02:01 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     Stefan Metzmacher <metze@samba.org>, io-uring@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <8945b01756d902f5d5b0667f20b957ad3f742e5e.1666895626.git.metze@samba.org>
References: <cover.1666895626.git.metze@samba.org> <8945b01756d902f5d5b0667f20b957ad3f742e5e.1666895626.git.metze@samba.org>
Subject: Re: [PATCH 1/1] io_uring/net: introduce IORING_SEND_ZC_REPORT_USAGE flag
Message-Id: <166739772070.41755.3589087170503269474.b4-ty@kernel.dk>
Date:   Wed, 02 Nov 2022 08:02:00 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailer: b4 0.11.0-dev-d9ed3
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, 27 Oct 2022 20:34:45 +0200, Stefan Metzmacher wrote:
> It might be useful for applications to detect if a zero copy
> transfer with SEND[MSG]_ZC was actually possible or not.
> The application can fallback to plain SEND[MSG] in order
> to avoid the overhead of two cqes per request.
> Or it can generate a log message that could indicate
> to an administrator that no zero copy was possible
> and could explain degraded performance.
> 
> [...]

Applied, thanks!

[1/1] io_uring/net: introduce IORING_SEND_ZC_REPORT_USAGE flag
      commit: 4847a0eae62976ac27f192cd59b9de72b390eff3

Best regards,
-- 
Jens Axboe


