Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C0A76F719F
	for <lists+io-uring@lfdr.de>; Thu,  4 May 2023 19:54:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229482AbjEDRy0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 May 2023 13:54:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbjEDRyZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 May 2023 13:54:25 -0400
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE2E6E72
        for <io-uring@vger.kernel.org>; Thu,  4 May 2023 10:54:24 -0700 (PDT)
Received: by mail-il1-x130.google.com with SMTP id e9e14a558f8ab-32ea67ffec0so75835ab.0
        for <io-uring@vger.kernel.org>; Thu, 04 May 2023 10:54:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1683222863; x=1685814863;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zqOzZ62E2Qjo++r0s7JK7yU4Z1ely6sqVTI0j9/wojY=;
        b=TJIBlHGhzmsm+jECCtT+pRaxYCCUWGx2EufOK614sxzJm66vDLdyvkyy1/RWzqG9IS
         y2DHKHt0QcixGi13AJ2vhFTL8br7FLSHukt9A9TOmYQOCaxWUWiorhicqEiMuFpvXLpZ
         hjoCgP3eKtAbFBhaSAcvAfHHOBXWyP3onV2f7saP3EK6R2n5YkDpkM9xuApvDFfJIylK
         gZDBxG4Vbnh1r2FELguKEDjmucXQpFMAVSurjcMgsLXlymElTAPHGHBtZGO8rANyRhu/
         Iv4GZONuPZjLB2YFbqoqbg6L3zsvwOPI4JK/UnrCZoyuVO6H0XbVph7rM1vMui5aDfIK
         ZtBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683222863; x=1685814863;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zqOzZ62E2Qjo++r0s7JK7yU4Z1ely6sqVTI0j9/wojY=;
        b=JnaYDcKyE6k+dXHFuU2tmNbzTKjhkJDgAKnlT+O4DosZcQ/GTFjgIyoBYgG635Xx4p
         USyimoeHUAuZ2qN6TRovJTvuXckl4pRH301FX54H09SPGDCzLehNZTavLMp2hz7X6IHh
         5RBtBKS3iJpqtdh93IfsRbLe28l6uUCBhyuedWexjITDl367S6DLWYZco+TkEkvFJyae
         GXwqu9zg2jOYpn1KIjdEuouWZ8X0/HVPM4F6+1jIfclX+mDNWRgxA4La02B2p/48WIUS
         e+DOonCzvw2+HcVGQb/HvNTBqgVzjmr7DKApVsOLyUSkyQrLeS7ivEzOGNfO+nX6ILI3
         3SeQ==
X-Gm-Message-State: AC+VfDxjqSIN8ml8C4fLW2v6smAGEHbcUosGH9+Ru/0Akk0gDEbiRbz6
        a4wruOj6quIvLrr8ARKBSSx5F8CrK6x4p8gupG8=
X-Google-Smtp-Source: ACHHUZ7GC+Mqmkl3jY4sZHxf3IUbQsPq6G7P8+5aUPISN8aDhXJVJKsBXlgA0WTz5lvrc8uFvIgm8g==
X-Received: by 2002:a05:6e02:1be4:b0:32a:a8d7:f099 with SMTP id y4-20020a056e021be400b0032aa8d7f099mr13258992ilv.3.1683222863508;
        Thu, 04 May 2023 10:54:23 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id a192-20020a0216c9000000b0040fa63bfbf1sm10627398jaa.117.2023.05.04.10.54.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 May 2023 10:54:22 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, Haiyue Wang <haiyue.wang@intel.com>
In-Reply-To: <20230504053835.118208-1-haiyue.wang@intel.com>
References: <20230504053835.118208-1-haiyue.wang@intel.com>
Subject: Re: [PATCH liburing v1] .gitignore: Add
 `examples/rsrc-update-bench`
Message-Id: <168322286200.1397172.4251072122192015033.b4-ty@kernel.dk>
Date:   Thu, 04 May 2023 11:54:22 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.13-dev-00303
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On Thu, 04 May 2023 13:38:35 +0800, Haiyue Wang wrote:
> The commit c0940508607f ("examples: add rsrc update benchmark") didn't
> add the built example binary into `.gitignore` file.
> 
> 

Applied, thanks!

[1/1] .gitignore: Add `examples/rsrc-update-bench`
      commit: 9b56e492fca8465a45676c598509e8ae0a5dc56e

Best regards,
-- 
Jens Axboe



