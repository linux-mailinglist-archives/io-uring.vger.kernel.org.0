Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09F63595BBB
	for <lists+io-uring@lfdr.de>; Tue, 16 Aug 2022 14:23:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232412AbiHPMX2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 16 Aug 2022 08:23:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229978AbiHPMX1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 16 Aug 2022 08:23:27 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78653638F
        for <io-uring@vger.kernel.org>; Tue, 16 Aug 2022 05:23:25 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id q7-20020a17090a7a8700b001f300db8677so9416224pjf.5
        for <io-uring@vger.kernel.org>; Tue, 16 Aug 2022 05:23:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc;
        bh=SMNHhtbXdpE+oyuIssVUmYfzIxhzHNezGE5XhG4JL2k=;
        b=Y0f6ccmcyrvn9GPf8kKcAtxxcWQSS5P3mUDHt0GFJaRciTmp3U2W0meKV4MI/RDTcs
         1T67cJIf1zcNAk6808sjJVe3Mm+QLBTQ5FWAXQzq2rfYr3FWAzHptdwPuI4OqO6sVeOs
         0mmj3SFyhgqBofqgGZdZtxpO7RMGyXRFEKaMI0e0cIO4pPRNUYL3/XT0hiIK9S8IZWdO
         hbsBPbLFJOtb0k8m10Me3HEedTVvkZj9ri4+UDaS04cgo3RL/xCfkwxU0iKWzmIP/hxW
         QwUOA3HmMJsU8ZxoBkWZ6/blEKs28oYU50RSc0NJqRTZF5TprNPmKhgkNXAgMZM/5rVJ
         vb7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc;
        bh=SMNHhtbXdpE+oyuIssVUmYfzIxhzHNezGE5XhG4JL2k=;
        b=yfmeISIaxYnq4Z4oN3ySmf+UgiRkvOr709w5Oq6FqUURrkehtXu9cf5P3LJSZFtOXH
         TGNEYsLlwHwg0iLnJWhN+c0KRoUjz/DUOe1uyTb5+A7eYpCKtLv2hYPMRq5j0l6JoQUZ
         wyhbZL8I+RM7JcLXxUgIRot+f0uFsH0owRglmiG6+Lt1V3H6ZXzNkIhOx3+PZbscFiI9
         Rib+nXBCoKHWPncq94hdZSQTG3DmflEjLrS42b1/reu1ptDIvmIAZJeDdIT6sriei/3M
         3TztJmynm1H8t+8JO5iqhOKLJJINVWdacdyQyvZ2lFkEbCzcm7j3wyNaczQ3u4ihPLpr
         N1rQ==
X-Gm-Message-State: ACgBeo0z4iViu09r6yp2hzjuvhH5i+sZ6CL88BtiSdfEE7gTAM1C7rRW
        uSCGLZIyLTHCw52wwFMDhWxfxFC9rVcMcA==
X-Google-Smtp-Source: AA6agR4eHrR2wDccmRcZzmEE/qYuMYlUflmfGxv66D384+jFXamtKgdSTarEjYG9t17zMAhCoVShhg==
X-Received: by 2002:a17:90b:2791:b0:1f3:c48:19d5 with SMTP id pw17-20020a17090b279100b001f30c4819d5mr22995523pjb.219.1660652604744;
        Tue, 16 Aug 2022 05:23:24 -0700 (PDT)
Received: from [127.0.1.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 185-20020a6204c2000000b0053524208008sm1742516pfe.218.2022.08.16.05.23.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Aug 2022 05:23:23 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     jslaby@suse.cz
Cc:     io-uring@vger.kernel.org, shr@fb.com
In-Reply-To: <20220816105134.9824-1-jslaby@suse.cz>
References: <20220816104645.9554-1-jslaby@suse.cz> <20220816105134.9824-1-jslaby@suse.cz>
Subject: Re: [PATCH v2] test/xattr: don't rely on NUL-termination
Message-Id: <166065260332.198111.1252860082138342519.b4-ty@kernel.dk>
Date:   Tue, 16 Aug 2022 06:23:23 -0600
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

On Tue, 16 Aug 2022 12:51:34 +0200, Jiri Slaby wrote:
> The returned value from io_uring_fgetxattr() needs not be NUL-terminated,
> as we stored non-NUL-terminated string by io_uring_fsetxattr()
> previously.
> 
> So don't use strlen() on value, but on VALUE1, and VALUE2 respectively.
> 
> This fixes random test failures.
> 
> [...]

Applied, thanks!

[1/1] test/xattr: don't rely on NUL-termination
      commit: bf3fedba890e66d644692910964fe1d8cbf4fb1b

Best regards,
-- 
Jens Axboe


