Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11DAF5B208F
	for <lists+io-uring@lfdr.de>; Thu,  8 Sep 2022 16:28:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231655AbiIHO2z (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 8 Sep 2022 10:28:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231513AbiIHO2y (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 8 Sep 2022 10:28:54 -0400
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7F03FB8E5
        for <io-uring@vger.kernel.org>; Thu,  8 Sep 2022 07:28:51 -0700 (PDT)
Received: by mail-il1-x134.google.com with SMTP id m16so6324046ilg.3
        for <io-uring@vger.kernel.org>; Thu, 08 Sep 2022 07:28:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date;
        bh=50cQJ6Twihg5oVxtMwss89+brx1C9LPioNT2hJo5VDg=;
        b=0QL0fRqEqPj0Xdgcz+wZc7i1OZXVjbBxM3FT+GEgA5Ons72i+E5dP+LjboNnV7S5Me
         9QJ6O0/vMXVkJ1JNm4ehlO528HC0mpyZTAZOBG1MLAz8+HZgGpEF/12Lp7nkNjbE4Fpa
         3wZrinHf2rX3lKHRcTHMiye9zWr3vwIo6Ht1ipl3j2J57O1EMcuSOWRtrpF9J4VGXjYo
         njR0pxH59+fr5D/CZCUN1i2a2ltkCIAadC/CBvgCcZ0bPC341xADRYAF7xd62bv6JHks
         6VPOugTWwBCJ2ggoSTwuOyGtfqjToQEHXAlolNszYWhLfYT00EmjJkelCbc01nhxUuOW
         3F0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=50cQJ6Twihg5oVxtMwss89+brx1C9LPioNT2hJo5VDg=;
        b=urIdaymP3Sq0hjFs9FAe8b9o2fo5RXJ6Vt8VPtarL0byDcE81FqF+bvTcYEJfyf7er
         cjcjHOrHf78y7crZtmMTBxOBz/maS3YAAYOJrXS5n5A1KJW7fJBhVnqzmgf1Gsn2nKOI
         6fvK8lNaC8wv5GKElG63IwEVkWuJ73LfonoyTYrlNGHKPUsy3zIftUiiKdWUthYzH4Mp
         115kM/z8js8AXVtOOoXmM0q2GjulQSun4gLbZL7Lwe6iSE3rdBbnUTCQUvE6nJnARKEF
         +c5aCLOK+EZ0IbUpT1GGC2GZTd8TI9GP7MBgNeJwIMYcRvWya7Xkkm/p4ke7J98NX18l
         Fg1Q==
X-Gm-Message-State: ACgBeo3yUaxW2JXahDhe82j2zBrTAnHP4S2VGp1hwkdfuKonXsiG9/9d
        4wT3xQxfoy8EES+ByB4yFtU/ktN63kzf5w==
X-Google-Smtp-Source: AA6agR7V17Vi/l9PYrexPQDru2WxeBVWMgWF1GVTkoaaJS7Rnzq0jsXatSTwvmNmf61EJh4EjU3hIQ==
X-Received: by 2002:a92:ca48:0:b0:2f1:eab0:2039 with SMTP id q8-20020a92ca48000000b002f1eab02039mr1949015ilo.305.1662647331040;
        Thu, 08 Sep 2022 07:28:51 -0700 (PDT)
Received: from [127.0.0.1] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id i18-20020a056638381200b003584a5d30c4sm254521jav.46.2022.09.08.07.28.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Sep 2022 07:28:50 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
In-Reply-To: <ab1d0657890d6721339c56d2e161a4bba06f85d0.1662642013.git.asml.silence@gmail.com>
References: <ab1d0657890d6721339c56d2e161a4bba06f85d0.1662642013.git.asml.silence@gmail.com>
Subject: Re: [PATCH 6.0] io_uring/net: copy addr for zc on POLL_FIRST
Message-Id: <166264733023.466947.187431908453283317.b4-ty@kernel.dk>
Date:   Thu, 08 Sep 2022 08:28:50 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailer: b4 0.10.0-dev-65ba7
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, 8 Sep 2022 14:01:10 +0100, Pavel Begunkov wrote:
> Every time we return from an issue handler and expect the request to be
> retried we should also setup it for async exec ourselves. Do that when
> we return on IORING_RECVSEND_POLL_FIRST in io_sendzc(), otherwise it'll
> re-read the address, which might be a surprise for the userspace.
> 
> 

Applied, thanks!

[1/1] io_uring/net: copy addr for zc on POLL_FIRST
      commit: 3c8400532dd8305024ff6eea38707de20b1b9822

Best regards,
-- 
Jens Axboe


