Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 164356E9C35
	for <lists+io-uring@lfdr.de>; Thu, 20 Apr 2023 21:04:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229848AbjDTTEr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 Apr 2023 15:04:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230228AbjDTTEq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 20 Apr 2023 15:04:46 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4376B2108
        for <io-uring@vger.kernel.org>; Thu, 20 Apr 2023 12:04:45 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id ca18e2360f4ac-760f040ecccso7883539f.1
        for <io-uring@vger.kernel.org>; Thu, 20 Apr 2023 12:04:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1682017484; x=1684609484;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jXPxpRXYt98TRHqVZ215l3PKl9165a9akVL7T1VmKTU=;
        b=tyfFEpcLyg5grA56/oJaEdayD3CMbsS6bz6TncwNidKnmHV54lwhDT9HmAfhgAFIP1
         W+xatcm9qJ/cloezd1bao5SpBZtrBitwmPe1XUIn+9Cc8qRqb6y+JENiSUrhIOSTB6xh
         NCOClxFrQlBZz94Kxv+/jtV5hXldRmsmUr/9qtzdy+z2/71gRaFRZqWD+M5VM4XJJ10V
         jdEC+bjr+4/C7k2kbUiW9GhCHabHEV41ZvwNHq1a+saIz9pLchIVQM3os3qveolRZQd2
         LaDDiK6+n+89IJzhrXNmfYaCOZL9YvfkAE8TgTiuLj03l5R52R6qv5XojVkJ5jO0UuPD
         eFYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682017484; x=1684609484;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jXPxpRXYt98TRHqVZ215l3PKl9165a9akVL7T1VmKTU=;
        b=WuUJOZqEpdD7BIevUuGZxlPzHsNJqcqw8KvSvru4t6EOA69sy2jEqJMJG/g+SWHYDL
         fgCDa/alG0/bjZLL0sJ/yl/eCZLAm1c7jf0zwDuJGefT973hbOr2oNH4y2r8nboF/XaB
         KrctCDAksm9DAP5ykjMaTWKJ3K9DBjIhnw2j7y7pqp1MzKnjrI0bkT6oyE/8XuPinUEN
         Y2P+xPHNlDdU8P42QhiKQRdo8chtuOuymyqHpXqX5ERiOCGy6fw+sm3MBlythsV47yos
         1QTe0GxPfOJ3xKHwqcU5u/eoZWFovTF9eFd1xyYGg0mIkWtDF7Y5k1GGMkLu98SBQyC0
         6KYQ==
X-Gm-Message-State: AAQBX9fNDw3d7o1P2Jy36/8Pi/oKjTWLWS4wR2qFCJboArahxPMe+gz7
        /uj7zjZpURKV1zmOmxZzW6d+L9ck+VMBdO29ot0=
X-Google-Smtp-Source: AKy350ZT40LwhvIvaPUY2DjWgjrCiY1hmKEpleM/at9WY6QZ0xLpjRsKngoy4Xdx20gXAgwWw5DaTQ==
X-Received: by 2002:a05:6602:1555:b0:763:6aab:9f3e with SMTP id h21-20020a056602155500b007636aab9f3emr2027909iow.1.1682017484591;
        Thu, 20 Apr 2023 12:04:44 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id j3-20020a5d9d03000000b00762f8d3156asm566959ioj.14.2023.04.20.12.04.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Apr 2023 12:04:44 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     Gabriel Krisman Bertazi <krisman@suse.de>
Cc:     io-uring@vger.kernel.org
In-Reply-To: <20230420185728.4104-1-krisman@suse.de>
References: <20230420185728.4104-1-krisman@suse.de>
Subject: Re: [PATCH] test/file-verify.t: Don't run over mlock limit when
 run as non-root
Message-Id: <168201748364.133109.2454297166789207140.b4-ty@kernel.dk>
Date:   Thu, 20 Apr 2023 13:04:43 -0600
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


On Thu, 20 Apr 2023 14:57:28 -0400, Gabriel Krisman Bertazi wrote:
> test/file-verify tries to get 2MB of pinned memory at once, which is
> higher than the default allowed for non-root users in older
> kernels (64kb before v5.16, nowadays 8mb).  Skip the test for non-root
> users if the registration fails instead of failing the test.
> 
> 

Applied, thanks!

[1/1] test/file-verify.t: Don't run over mlock limit when run as non-root
      commit: b7f85996a5cb290fc2ad7d2f4d7341fc54321016

Best regards,
-- 
Jens Axboe



