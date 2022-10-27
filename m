Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D42B460FC61
	for <lists+io-uring@lfdr.de>; Thu, 27 Oct 2022 17:52:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236277AbiJ0Pwv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 27 Oct 2022 11:52:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236306AbiJ0Pws (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 27 Oct 2022 11:52:48 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71851180279
        for <io-uring@vger.kernel.org>; Thu, 27 Oct 2022 08:52:44 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id o65so1906572iof.4
        for <io-uring@vger.kernel.org>; Thu, 27 Oct 2022 08:52:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fY9Mt4Q8XefsFB69z6T/jUSxYwtkZspHJVVRnAtmH0k=;
        b=t/DO2GO29vpisSA0o+1QVbQCava2H7QaZqwk4CMPVGCLabdE0a1SYVWUrkivIPNkhV
         +EcTKKsFbA5BE5QcFw1ip+ZmHbBxgnGehdE24jIhir3FnfRfQ1oFYYZdKsKP9HuYPZlZ
         IqkIpetLF4I6y0o5BOhEwv0BFqr7CfC1OBObjagwMzC0Xh58MAAr4p0dssF+/tEaol92
         fSCPHpPXY4uiseuQdLi0mIqkacM3WYLuHyEUp58oAwCccYL9Cc1HaqQbkLLFSV07npPf
         t0/hgBgjVuPy3ehIIa1zpfHI6tgYl2L5h9I74m68Kp8tSLtqIOtMG+zEnlip9ETmfAHk
         jalg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fY9Mt4Q8XefsFB69z6T/jUSxYwtkZspHJVVRnAtmH0k=;
        b=xGJ2GISwxaNA/EwqmQ36sCPhiDagXf25sr/RD3jwWxoSuc7gMYfthg/dvS7ZSZEVdd
         2KZ4WN0MKVmz/xiIHlAQdnkccOm6WFEBi4DhQpo/1QvynmWn/KN241aQTRuCsIq23e+K
         7Oo0ko9LdSsUPA42mhAy2ca51LwLoPQDL5YFKcab/ZNVLY4Mg2gFHuWWdaBVACp6D4KY
         rm4GvH1dRNdnGFFf7/kysxNLDbwTExdd/Xyn7zy1GW6dC1sTeABBGxBbKiT1O6fNux96
         6DQtgz+16O24MmZ1fl09rmt2Xbt84uS3VozwzD+YwFmAWnbq9HGWoOUTQRVjp1pPAExb
         DSqA==
X-Gm-Message-State: ACrzQf0NuuTHh5HowhoL6JmbEFQU63Zs4VNqR1Fmf4m5wDu5x4ia7X5U
        3YFTQUFFTafLBcZd/eB1zq76Vw==
X-Google-Smtp-Source: AMsMyM421K1DNQr2KeM7iNNbwpYkiRJZlKMoS8lFnrvws7Nqn1eOY+WHlkzSjV8zOH3qLuaXJMqZzQ==
X-Received: by 2002:a05:6602:2dd5:b0:6bc:7b66:2cb8 with SMTP id l21-20020a0566022dd500b006bc7b662cb8mr29283588iow.17.1666885963775;
        Thu, 27 Oct 2022 08:52:43 -0700 (PDT)
Received: from [127.0.0.1] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id w18-20020a02b0d2000000b00363ff12ca47sm695984jah.125.2022.10.27.08.52.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Oct 2022 08:52:43 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Dylan Yudaken <dylany@meta.com>
Cc:     kernel-team@fb.com, io-uring@vger.kernel.org
In-Reply-To: <20221027144429.3971400-1-dylany@meta.com>
References: <20221027144429.3971400-1-dylany@meta.com>
Subject: Re: [PATCH 0/2] io_uring: fix locking in __io_run_local_work
Message-Id: <166688596303.4196.7993542008383265110.b4-ty@kernel.dk>
Date:   Thu, 27 Oct 2022 09:52:43 -0600
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

On Thu, 27 Oct 2022 07:44:27 -0700, Dylan Yudaken wrote:
> If locked was not set in __io_run_local_work, but some task work managed
> to lock the context, it would leave things locked indefinitely.  Fix that
> by passing the pointer in.
> 
> Patch 1 is a tiny cleanup to simplify things
> Patch 2 is the fix
> 
> [...]

Applied, thanks!

[1/2] io_uring: use io_run_local_work_locked helper
      commit: 8de11cdc96bf58b324c59a28512eb9513fd02553
[2/2] io_uring: unlock if __io_run_local_work locked inside
      commit: b3026767e15b488860d4bbf1649d69612bab2c25

Best regards,
-- 
Jens Axboe


