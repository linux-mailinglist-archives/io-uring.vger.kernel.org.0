Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 618765104DA
	for <lists+io-uring@lfdr.de>; Tue, 26 Apr 2022 19:04:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348907AbiDZRH6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 Apr 2022 13:07:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244226AbiDZRH4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 Apr 2022 13:07:56 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 638701387D0
        for <io-uring@vger.kernel.org>; Tue, 26 Apr 2022 10:04:48 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id f4so24874iov.2
        for <io-uring@vger.kernel.org>; Tue, 26 Apr 2022 10:04:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=h3ELnL6Jy2MgUeo6P0f1eaAw2HEt4k9ee++VkwjYAdM=;
        b=lxuaFNSK0+e+UlKMM9nhmhWXRwG2T/f7v/0AhtjxqKRbWn8G3fnSxup1CV+14qs2ue
         r7hgI9cUM6ZaGBGGpx0uMfPN4letoWvnc0d1Rf7U+8B7Jz0XFhLmfTUB/09MXg/P6pcu
         KY3dJkesy7PBcZG+49oZY6VkPfDGidkOvo+R27YzCRLgTu0bFqQpLuofJwsaaZnX/Ayu
         TOUm5h0LLtiJpy9wx0xkRSoPE/LmlzFKGI0sImaQ6XPswI1wtx8rHBHw1ZZwZ5a/MxED
         lZVOBMDHrJ7m8Gf4rhsDTIOGczPVLBddKceQum2+U317CGp4iKgzGk59sJ9xgnKlTgTx
         l9xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=h3ELnL6Jy2MgUeo6P0f1eaAw2HEt4k9ee++VkwjYAdM=;
        b=CH9XxyZPBtB5JGepQ0uZgVpP1q1x0ICrRxsy3EzyYHQZDF4nzHni2m3/vKTG5vUHPx
         6f1PA1wsg0eTmFq7qv5kWThZil7765Aj3yDHzjhJHu9mLxJbC0TAZ9SX+iwtWo0OGyF1
         WB0YJJBIXWuMwRBUkG9T1NidAmdoPUMsp152l2hW3i3uCwdgvqBSKfhWo+ULp6NWsFdR
         1uch91sYUTNL/BzKxAFgzYu4OSBwx+xBoVcOcXGqO4eJ+d4FU8ZK19fSsxLF3Lu7TyAf
         IQIX6bz5FzhZ944F9qxzVKack9MBB9c5uFgIHhTdq3bt+Wrzbcthe28SP/Slu9Ll1w+T
         CuGQ==
X-Gm-Message-State: AOAM531KExuItaJrlYyApFPYRenWzwEXnpKce/tK8IGIeqSurfJPuWq7
        E/ACVzhSKuN9BB/tXpfMxoYREAjYJ+UsKg==
X-Google-Smtp-Source: ABdhPJxBHv7JG6+WKBruLEW2DqleqKyw99D9ib0Mw0aAZE64DDAoTMUP32MaIebudTsQ/c7zu3GX5Q==
X-Received: by 2002:a02:c801:0:b0:32a:e779:fabc with SMTP id p1-20020a02c801000000b0032ae779fabcmr5706553jao.219.1650992687662;
        Tue, 26 Apr 2022 10:04:47 -0700 (PDT)
Received: from [127.0.1.1] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id a22-20020a5d9816000000b006496d8651cfsm9566507iol.1.2022.04.26.10.04.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Apr 2022 10:04:47 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     almogkh@gmail.com
Cc:     io-uring@vger.kernel.org
In-Reply-To: <20220426163403.112692-1-almogkh@gmail.com>
References: <20220426163403.112692-1-almogkh@gmail.com>
Subject: Re: [PATCH] io_uring: replace smp_mb() with smp_mb__after_atomic() in io_sq_thread()
Message-Id: <165099268685.75076.5934147489871751028.b4-ty@kernel.dk>
Date:   Tue, 26 Apr 2022 11:04:46 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, 26 Apr 2022 19:34:03 +0300, Almog Khaikin wrote:
> The IORING_SQ_NEED_WAKEUP flag is now set using atomic_or() which
> implies a full barrier on some architectures but it is not required to
> do so. Use the more appropriate smp_mb__after_atomic() which avoids the
> extra barrier on those architectures.
> 
> 

Applied, thanks!

[1/1] io_uring: replace smp_mb() with smp_mb__after_atomic() in io_sq_thread()
      commit: 012b7e911e69791ea518ef3d084c12cb2b8f2914

Best regards,
-- 
Jens Axboe


