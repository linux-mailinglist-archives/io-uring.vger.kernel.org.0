Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A70297CE159
	for <lists+io-uring@lfdr.de>; Wed, 18 Oct 2023 17:40:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232258AbjJRPke (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 18 Oct 2023 11:40:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232419AbjJRPkd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 18 Oct 2023 11:40:33 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04B3E118
        for <io-uring@vger.kernel.org>; Wed, 18 Oct 2023 08:40:31 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id ca18e2360f4ac-7a66bf80fa3so15264139f.0
        for <io-uring@vger.kernel.org>; Wed, 18 Oct 2023 08:40:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1697643630; x=1698248430; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1Bd5E3LG7Pbb7dQMAtxMLTfJdPcuYRdZ6dsi++yfXIs=;
        b=bGHYvmiiC5GmZfZqV71hhjOwD81+5oGRWmidguUL4CIizEQsSB1Ab7o1hx6otBkyiG
         13pM7TkL1ohUPX7qI9MaYjHeYX1Gz2IYuaec9z1WN2K7XZwu+gQViMyUYvT4o8lfgSr7
         I/NASX3G0iR+UYtYo1ovph9szhbp4HG8OJBJY3JabaOIphVFWyjChrATAws9/2v1jEA6
         J8D6NYHtSuAwsYC7C2eFovFVdgv7j61XYFpSOw24r0+EK5NRC8h+1lzo2wDYOWWN6Jxb
         nboKtHUtNdJPv3u7M1dVlAQIFAQoage2kP0SFs9QjPzru+xpSrQlygdCZQlmp3RpUqnL
         lroQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697643630; x=1698248430;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1Bd5E3LG7Pbb7dQMAtxMLTfJdPcuYRdZ6dsi++yfXIs=;
        b=r+euHxU0Whamo9uQ7FPXxnR7BIfYIx7LYvVAUE+3B12bB1cRSW4/apwL1/ny9gAjSF
         dnlJipMXYlu158foynfQhi2W0kkSni81cUR6oEPnRa3eZvqt44iTkSkB2mtFA1YaQ6if
         nXcHrwMQjE7MlGOR9sTrBnPHq/mxns3cDZI3hTQ4L1UlyV9IrsnAfHcZ7hyJqAZoQtS2
         k3SHx4RRpX9QPjns4tjr8oiVcWxD44dHG3RUBbDdzu5E6Shl0il4p35wpNgmMd29LTRD
         BVBMCMeZVDAl3HE+yI9Y7omEok0le5lSmJIrFuLT54haj8661GF1R73F0DJewKppkpgK
         kPWw==
X-Gm-Message-State: AOJu0YzBhefOX5hk5MfjT5ZC2FVGDoVtf2QrnYEFKEvlmLpTB9KrL+xO
        FEa6KZzcwBnV4+hGEAj1lYOEjbIPeYHCOxZcpAFAKA==
X-Google-Smtp-Source: AGHT+IGJoWKWjrfSpEHD/mcGGxZeqUYuYRiA3uAqTnaBtSfv8k1VUEAYs+Yvh2B/K2eGi5cF+Sx4tQ==
X-Received: by 2002:a92:340d:0:b0:345:e438:7381 with SMTP id b13-20020a92340d000000b00345e4387381mr5440546ila.2.1697643629869;
        Wed, 18 Oct 2023 08:40:29 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id r3-20020a92d443000000b0034fcd8c20b3sm1208559ilm.23.2023.10.18.08.40.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Oct 2023 08:40:29 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cover.1695988793.git.asml.silence@gmail.com>
References: <cover.1695988793.git.asml.silence@gmail.com>
Subject: Re: [PATCH liburing 0/2] liburing IORING_SETUP_NO_SQARRAY support
Message-Id: <169764362885.2461799.6787998879515647020.b4-ty@kernel.dk>
Date:   Wed, 18 Oct 2023 09:40:28 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.13-dev-26615
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On Fri, 29 Sep 2023 13:09:39 +0100, Pavel Begunkov wrote:
> Patch 1 adds support for IORING_SETUP_NO_SQARRAY, i.e. not using and
> mmaping the first SQ indirection level sq_array.
> 
> Patch 2 defaults liburing to using IORING_SETUP_NO_SQARRAY. If it's
> not supported by the kernel we'll fallback to a setup without the
> flag. If the user specifically asks for IORING_SETUP_NO_SQARRAY,
> it'll also fail if the feature is unsupported.
> 
> [...]

Applied, thanks!

[1/2] setup: add IORING_SETUP_NO_SQARRAY support
      commit: 74c1191cbfa2b552b3ceaa63386d871c2d5d2136
[2/2] setup: default to IORING_SETUP_NO_SQARRAY
      commit: 3401b06c5e8291a2ad946bb181ab347f18a4c8c3

Best regards,
-- 
Jens Axboe



