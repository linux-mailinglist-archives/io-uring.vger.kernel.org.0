Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A10F35EDE37
	for <lists+io-uring@lfdr.de>; Wed, 28 Sep 2022 15:54:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234214AbiI1NyP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 28 Sep 2022 09:54:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234124AbiI1NyJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 28 Sep 2022 09:54:09 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C35C4937B2
        for <io-uring@vger.kernel.org>; Wed, 28 Sep 2022 06:53:57 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id r62so8453121pgr.12
        for <io-uring@vger.kernel.org>; Wed, 28 Sep 2022 06:53:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date;
        bh=yybFSvGdpGznbbaHhi2JFM7XiUowSXmaQo7ylpHMhOE=;
        b=C16ZApltXzcPPyHZTOrGaWxzNk6TrlpDb2PkGzuhylsX/JZ2A/NOFVMufRHX83g62h
         9Qk4ADw5UyLKyOQviyPhJrukNVUtTXMyNa0N4/gyB6cDXVFbjOTLPMatQXHrgHjGDwlJ
         2PBy8I8ZZhWNPDXjm7vTr+uF7beCZ/KoUTe4CiJXH2cuRBNtLOxQjMn/PwxbgkTxm1T5
         V0dBw820dOqL+VgplFS0J+s+w/MtDA4/qIWtUDelY5IppQDLPNRJ/OrXuDT2915wfAdt
         Nvtv1VnROfjzaEoDXyGwk9d0+UsvaqLWV8CIur8A5s3IWZdjKyq3mbmF8CfaVxBE9fgy
         xr/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=yybFSvGdpGznbbaHhi2JFM7XiUowSXmaQo7ylpHMhOE=;
        b=JeQYFE/kX+LtLjCnfe0tpAzqxX2TUOoXsnyiXftZ4YbscUO/20BugikoDCnlgx9i6L
         bgl8VgSKSbpW4TshHhpY+tgH6RKrDbttQdS45Vh9dwK85Zh0Y0QR//p3wYRYkVGj+/sd
         pGyw9W6SPxOOu0vVc12he8Poz5AyFZJuA9+Q3w+FvEZ325FCVHx/m6ItCJN+9WJfrKhX
         REpE8889/U7TgnF7m/f+F1HBf2ot6by3tOd10Y+dwvUn9N7S6XuvLOe1MHKxvHLaWVse
         Ua7zwcj2bAMg36bmsmgqeBH31ApIUgchBDG7dEH9++rNEB9s0F7tyJ6IErSgjn0slSp8
         QvAA==
X-Gm-Message-State: ACrzQf3+znv9VPdsOfZ8pSmyZI6ZZPVOGsl8hJuEPZteVfpymUw56PHO
        QlXr/xEKA8KedkouUJBTZm+l5A==
X-Google-Smtp-Source: AMsMyM4oIP+PDBJMJcJccnTHCAo/AyfS9l/Bq+/kO29O7EqKe0y0Lo2Mx4YJJNioqJJrtgW3BeaWqw==
X-Received: by 2002:a05:6a00:1488:b0:542:78a:3f8a with SMTP id v8-20020a056a00148800b00542078a3f8amr34836283pfu.85.1664373237268;
        Wed, 28 Sep 2022 06:53:57 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id u17-20020a170903125100b0017a032d7ae4sm1520846plh.104.2022.09.28.06.53.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Sep 2022 06:53:56 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <25a5e4ff7c480cf5c68be2e223a2fa9787ee6283.1664361932.git.asml.silence@gmail.com>
References: <25a5e4ff7c480cf5c68be2e223a2fa9787ee6283.1664361932.git.asml.silence@gmail.com>
Subject: Re: [PATCH liburing 1/1] liburing: add more zc helpers
Message-Id: <166437323666.10653.12467231658468189623.b4-ty@kernel.dk>
Date:   Wed, 28 Sep 2022 07:53:56 -0600
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

On Wed, 28 Sep 2022 12:02:58 +0100, Pavel Begunkov wrote:
> Add a helper for zc sendmsg and also for zc send with registered buffers
> (aka fixed).
> 
> 

Applied, thanks!

[1/1] liburing: add more zc helpers
      commit: 82a4dfc212478935f81f0f385da01458e8d5d7ec

Best regards,
-- 
Jens Axboe


