Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43D29598430
	for <lists+io-uring@lfdr.de>; Thu, 18 Aug 2022 15:28:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244768AbiHRN1s (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 18 Aug 2022 09:27:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244770AbiHRN1q (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 18 Aug 2022 09:27:46 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C18A4B5176
        for <io-uring@vger.kernel.org>; Thu, 18 Aug 2022 06:27:41 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id d68so1051353iof.11
        for <io-uring@vger.kernel.org>; Thu, 18 Aug 2022 06:27:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc;
        bh=Bx7Y8iXS03j7BLXQkGIIGRXmKPcI2xOmAlWPfj6h7xc=;
        b=mtlY0R07G3Ei5Bswd0/PGBv+YqakQImNJz1KJSJkcc4fsSZt4fmDo7bt/qdlRdnI/j
         B0rmS3YF0Zl1GAcSBnWCev4bWhU/mxoIsIjUBkf7tzFSqXO67Wl5cpsHBrGyHhkrJBUF
         nRKoyaySh36wbOS3Y4UoCpThv+pXycfNcg4Hq+35JCSd6Hz2Yh5Vvbkxw8k754AGGmyO
         JrVP9mZdGKNEOP9/zYtUh8HwTdpfHtL6V31d05YB/Hb6DE126awYhmYAcaxikpHa0O8r
         pMjsh18gvrQU1InNk45L4lOwVD/IPBf0HdGFjiY6EKhAi7XqKVyTIyZeseJHJGpnIqKC
         fxvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc;
        bh=Bx7Y8iXS03j7BLXQkGIIGRXmKPcI2xOmAlWPfj6h7xc=;
        b=nwvMUpC1M9y1FuEQTolzSF6du/lpkuMAqIL4fK0DXhXgYwjb6y7WP3pZbHa5tv0l0+
         dddRcGu4OHzS++wiQ3U2g34IKoDxwzA/jIAAP4zh2b/cuQkpvlJPNPmEUf+E58xy/bZH
         JExbyWRUG3WkIHZdLK5GIHlM6sKVoddr5xMiXq83pDb1lYJ+S0moexrhnj34B4WtjjGw
         0vrm5OcBJiLWIPcojxtOFsktL2OUzmIQ6gemwR7eQl5FhroZOSZeXFoQTXtooD5ayJk4
         Ok6DkcZ6vEPmRedjGH2+/cpbrlQaeHtpt76S27kncrt0ZUzn1vG6Nc2iRakP4WfIEVeT
         ZiMQ==
X-Gm-Message-State: ACgBeo2QubbyvTd9WK+Mg8xygH64+pZl0G8vgqbTD7s+1RPqhF6CkEH6
        VplI4nwOZWa1dNZZk2QXDLNK1WFOBCZH8Q==
X-Google-Smtp-Source: AA6agR4KHvdGXMTwa5zODR5a78lGOXsa4WVEckuvj3xk2gXA0yN+qunetKmUfMsmRba86DzDE/7FqA==
X-Received: by 2002:a05:6638:3444:b0:343:ee62:8a05 with SMTP id q4-20020a056638344400b00343ee628a05mr1375870jav.224.1660829260483;
        Thu, 18 Aug 2022 06:27:40 -0700 (PDT)
Received: from [127.0.1.1] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id b4-20020a029144000000b00331598832besm618062jag.25.2022.08.18.06.27.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 06:27:38 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     asml.silence@gmail.com, io-uring@vger.kernel.org
In-Reply-To: <42f33b9a81dd6ae65dda92f0372b0ff82d548517.1660822636.git.asml.silence@gmail.com>
References: <42f33b9a81dd6ae65dda92f0372b0ff82d548517.1660822636.git.asml.silence@gmail.com>
Subject: Re: [PATCH for-5.20] io_uring/net: use right helpers for async_data
Message-Id: <166082925762.4808.12742638364414264518.b4-ty@kernel.dk>
Date:   Thu, 18 Aug 2022 07:27:37 -0600
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

On Thu, 18 Aug 2022 12:38:34 +0100, Pavel Begunkov wrote:
> There is another spot where we check ->async_data directly instead of
> using req_has_async_data(), which is the way to do it, fix it up.
> 
> 

Applied, thanks!

[1/1] io_uring/net: use right helpers for async_data
      commit: 3f743e9bbb8fe20f4c477e4bf6341c4187a4a264

Best regards,
-- 
Jens Axboe


