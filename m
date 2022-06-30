Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEC9D561EA9
	for <lists+io-uring@lfdr.de>; Thu, 30 Jun 2022 17:02:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235353AbiF3PCc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Jun 2022 11:02:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235362AbiF3PC2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Jun 2022 11:02:28 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E60F1FCC4
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 08:02:28 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id m13so19465812ioj.0
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 08:02:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=Q+WQO3gtRoEnsX9UQiEkH1N5UBCU7ezfDoe3FQLdpR0=;
        b=032+iQW/D/CJFyCrhHVAaGqARq4CcvKHM+3VX/4RQ/4LmRtlzehI7Bc1AHgT5ufmPA
         AXlE4JTBhqDpuxl5bKzFvk9XcTRrYKBKdPgvL+TNRj8pvhZBuIp5wFd1kar2ylPuWgBU
         zb7xawVNX+gc5eN9uSpWC0+hQbKjquw0cnE1pvOsVNUMEHTBxZ8dUh58RUvKA4Y7eNC3
         C5tIya24kBUddAX+jh5KD4r8lewwEp581GpV3unXWa0v0LDw/huIz6+wOXcnTJQcYqro
         9226T0PCnwm3563VbcozR8PDi7KLR3iHVoSZygHQzOt78GrKyoIakv3eLtzoU077nn3i
         xB7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=Q+WQO3gtRoEnsX9UQiEkH1N5UBCU7ezfDoe3FQLdpR0=;
        b=OSoLZGtJ7RiIt6uRDlXA6JWKnSoyP9qGBIXf2SKOSBeFUPFEPOCqmBWBiadzC0PChJ
         uDsF8U/hSVWT9pt8xyKoqky+TYycPaoLsRYKkQIwg0BEFqHmH8k7Id0W1dST1/VKSqvK
         zmkH0P0H9MsKq9/+7iZpWLWNLmUlcZkCEdcXdU4z/IAjSTUSQN8+im5yjzvFhLYg7yk+
         JyFpd3pmXqiAzKGB9NQtMQgvvH8bjePzA2Yr89A8bLQgjW8fPd3T7HbM5tnE1Nmsb/l4
         Mvap3JWGofaNBFk+14N/7FfcIxl3zu1Od9CPzm7Ju3YF3f09K9RUS/wNURjnqgiGgy8X
         ZMfQ==
X-Gm-Message-State: AJIora8QjGJcQ+iA3iA4c6srCo7sYK8PmADEjufdMUE4iWkqUWfpZHWJ
        M6dHBx/KSdEuQvTRtFrVtXp0f/s4eEFOQw==
X-Google-Smtp-Source: AGRyM1vaGI5paXctZ+gI6GNr4kU8jtQzYD4fOqw9EaRB47DaMt8230MeFfgrdp9BZm+XzBmIiW0mWA==
X-Received: by 2002:a05:6638:25cd:b0:33c:b17e:d621 with SMTP id u13-20020a05663825cd00b0033cb17ed621mr5363884jat.61.1656601347447;
        Thu, 30 Jun 2022 08:02:27 -0700 (PDT)
Received: from [127.0.1.1] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id cn22-20020a0566383a1600b0033171dafaa0sm729040jab.178.2022.06.30.08.02.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jun 2022 08:02:27 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     dylany@fb.com, io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com, kernel-team@fb.com
In-Reply-To: <20220630142812.3212964-1-dylany@fb.com>
References: <20220630142812.3212964-1-dylany@fb.com>
Subject: Re: [PATCH liburing] add a test for async reads with buffer_select
Message-Id: <165660134685.537575.7761266801951363984.b4-ty@kernel.dk>
Date:   Thu, 30 Jun 2022 09:02:26 -0600
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

On Thu, 30 Jun 2022 07:28:12 -0700, Dylan Yudaken wrote:
> Async reads had a bug with buffer selection.
> Add a regression test for this.
> It fails without the kernel commit: "io_uring: fix provided buffer import"
> 
> 

Applied, thanks!

[1/1] add a test for async reads with buffer_select
      commit: 6c90ac3c9fb874d406656c9e7a68805c83a055a0

Best regards,
-- 
Jens Axboe


