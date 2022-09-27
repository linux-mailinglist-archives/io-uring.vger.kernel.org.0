Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F4275EB66B
	for <lists+io-uring@lfdr.de>; Tue, 27 Sep 2022 02:43:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229555AbiI0AnU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 26 Sep 2022 20:43:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbiI0AnT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 26 Sep 2022 20:43:19 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11C5774DF7
        for <io-uring@vger.kernel.org>; Mon, 26 Sep 2022 17:43:18 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id w10so7695777pll.11
        for <io-uring@vger.kernel.org>; Mon, 26 Sep 2022 17:43:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date;
        bh=LNSmy9qd4nBdGauRFoqgVtLB0ZNSHeabIUmceqXfJVc=;
        b=7RYjaSRvrFrQV+9MePU2j+ahDjtsRV97QgYCqLN6KxKdYWJ9oAVYLnhg3ypHKhCJSk
         y8iWlgs6Axi606njVrkHm0X3t84WW7zY9fq5PNx55F+Laob+G9k9X8Vst0ExByOYV8eX
         IYHn2awCSUi99CJacXLiQamJndtHLC3V+SdnNVqG93XHrHvsvfgxTirzQcM/9D/hK1wt
         c8+BigU1XZ/eGpsSEd2uB+IbrmXW8y4MyoMYpunMvxWCzw4wKVAcsfox6XAKG5xRNkyD
         VC908YRGv1OEXHoSih1PfnIZzzZ5PdSD2m8Jg8cVk4lQNtPp6g7n8277N1UZpRw8+YLu
         XIYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=LNSmy9qd4nBdGauRFoqgVtLB0ZNSHeabIUmceqXfJVc=;
        b=l6Ewi/xd8/DTAcoqy6T8vVijmS5dvTrB6HEBMDOUhyF8GwSFQZ1io+WZT2u5wZnv7c
         kHaS0mDWgNVuanFNRNwj3GhSCwgUM1KHddUn9IcQQ1lvh0kyNHt/u3G3JLOMSx1m9BWt
         GufD3A9lyEbfj7fK9fg7FdwmM1R/d9beN9fnN48+Bmw3i9EaCyuzBa50gfw35nSWVlgv
         NFIL0HDDR0KWgsB6tqtnydPNajnmAq5Pn9omDG/bckbbkIg1f3k7PeztN4LyjIZX3QlM
         8hviZu74qCOweij97SuX1huyjiMFm/S4JIAcOFXPGsb9NCiUYbAaJ0HdF1vlemO1OGxn
         6laQ==
X-Gm-Message-State: ACrzQf0bfvPa2+pdPqBBfSPuxP5wOKnmI98a3RYkW2dcmHTQWbGCKEPt
        6L/D4eTMmeFTTuabiPqq59kzsx9CC9QzIg==
X-Google-Smtp-Source: AMsMyM7Lj5bvLr/pT+O+cSgLAC1RIatpYFDrJfER4CTGfM5xG2ga1tSmJZ/Ir9zeioH27Wk/7U/RqA==
X-Received: by 2002:a17:903:210b:b0:178:80f1:1b01 with SMTP id o11-20020a170903210b00b0017880f11b01mr24783306ple.96.1664239397423;
        Mon, 26 Sep 2022 17:43:17 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id q30-20020a17090a4fa100b001fb47692333sm67617pjh.23.2022.09.26.17.43.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Sep 2022 17:43:17 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
In-Reply-To: <cover.1664234240.git.asml.silence@gmail.com>
References: <cover.1664234240.git.asml.silence@gmail.com>
Subject: Re: [PATCH for-next 0/2] rw link fixes
Message-Id: <166423939676.14387.16777903330163991810.b4-ty@kernel.dk>
Date:   Mon, 26 Sep 2022 18:43:16 -0600
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

On Tue, 27 Sep 2022 00:20:27 +0100, Pavel Begunkov wrote:
> 1/2 fixes an unexpected link breakage issue with reads.
> 2/2 makes pre-retry setup fails a bit nicer.
> 
> Pavel Begunkov (2):
>   io_uring/rw: fix unexpected link breakage
>   io_uring/rw: don't lose short results on io_setup_async_rw()
> 
> [...]

Applied, thanks!

[1/2] io_uring/rw: fix unexpected link breakage
      commit: 99562357ddaa4ec7f62e0cf68c13cbcde41e8e8e
[2/2] io_uring/rw: don't lose short results on io_setup_async_rw()
      commit: 819c4df334438b7d47ccccb5549a8b862ef38e03

Best regards,
-- 
Jens Axboe


