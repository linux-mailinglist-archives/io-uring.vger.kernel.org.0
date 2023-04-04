Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0DE96D6766
	for <lists+io-uring@lfdr.de>; Tue,  4 Apr 2023 17:33:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234086AbjDDPdb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 4 Apr 2023 11:33:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234770AbjDDPdb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 4 Apr 2023 11:33:31 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C6F94687
        for <io-uring@vger.kernel.org>; Tue,  4 Apr 2023 08:33:26 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id ca18e2360f4ac-7585535bd79so17167339f.0
        for <io-uring@vger.kernel.org>; Tue, 04 Apr 2023 08:33:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1680622405;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XbhK25A/Zo88U5nLLONnP5BItoc7Nfx7P7/6Fshmob0=;
        b=aIpKbYob5WBpmG9EONo6N+1pA0KkR0Sg28a2mbCHA5lf4Y4NLDeJHmqbggDlbPhudz
         rhNL5IJvlU4v+SCuLsuwxwaIl9kppsWpFIAR7R80pYzHrk5PBTkeuUvq2y9XbNOIbSTb
         w/n8Yw7yQlWt0GMKFZC0RIbWv5q2B7IddF2bb4FjzZNLBApDp4UZ3IS5OpuynNxh6Zok
         t6y5NPDskHJd1FsZ53mNavMdtRsQfQ6aFMKbRIJVwM1x0fspi8WB6kngRmibk7ykp8mZ
         Pnss27KOh1Vgnf+6latH4v/w+vPimqtAQvMwYVKv0e4QJ/UklGBWsLDzGZOljbAcPGLT
         BLtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680622405;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XbhK25A/Zo88U5nLLONnP5BItoc7Nfx7P7/6Fshmob0=;
        b=6GtN1/HJCa+bnV3p6/3TlyBbAwdgXsWq41Z2sWp+w7iDsfeLbJvwd3JrF8bzxGLK2q
         KzIBgNYL26Y6gM0077gr2UPcksfGOZe/tcgvJ+DQ2GorPAe3Pn5Tek4DwkzQVVMi6xEx
         OkHNZtYZc4gF1lglvTqI/sOlUesTEZm23l0S4Iuu9PD1ZJ8wUHc09FHQkPyl/fR9rg75
         +WyQfNLIzmLuJMC5+bGbmxzIV7L3JsuiMwJZOe76dVK2lIjdWaid7ora8CQd9ogESOFE
         eNYNv7kiIE1GtqMyd/T20b4TAIao9rnGf+MJ7tY5BMKydAbvCuO/LMC9afY0qiMYtnA9
         L7jQ==
X-Gm-Message-State: AAQBX9dMNbisFyC3PTBbdv16K2YQYm9Y5AiTtOq3s3e1OTU7KKwPLNb5
        +453SavVK9EV6aVE4vcwzMzPnQ==
X-Google-Smtp-Source: AKy350bNL3aXRQ2T/M5Gagl5IHA1PmKko5z4hCrnITAXC/NvtmgDttDgALF66K+5ZLnYAw6gL1PRlg==
X-Received: by 2002:a92:c214:0:b0:325:e065:8bf8 with SMTP id j20-20020a92c214000000b00325e0658bf8mr90884ilo.0.1680622405495;
        Tue, 04 Apr 2023 08:33:25 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id l4-20020a056e020e4400b00326490741e1sm3171650ilk.77.2023.04.04.08.33.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 08:33:25 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
Cc:     Gabriel Krisman Bertazi <krisman@suse.de>
In-Reply-To: <6914bc136c752f50fc8a818773a4cb61b5e39077.1680576220.git.asml.silence@gmail.com>
References: <6914bc136c752f50fc8a818773a4cb61b5e39077.1680576220.git.asml.silence@gmail.com>
Subject: Re: [PATCH liburing 1/1] examples: add rsrc update benchmark
Message-Id: <168062240489.178510.1631723061998732758.b4-ty@kernel.dk>
Date:   Tue, 04 Apr 2023 09:33:24 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.13-dev-00303
X-Spam-Status: No, score=0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On Tue, 04 Apr 2023 13:37:39 +0100, Pavel Begunkov wrote:
> Add a stupid benchmark updating files in a loop mainly for profiling
> purposes and estimating the rsrc update overhead.
> 
> 

Applied, thanks!

[1/1] examples: add rsrc update benchmark
      commit: c0940508607ff842d88344962eaa1bb5252d9ff3

Best regards,
-- 
Jens Axboe



