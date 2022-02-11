Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 272624B3004
	for <lists+io-uring@lfdr.de>; Fri, 11 Feb 2022 23:03:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244180AbiBKWDr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 11 Feb 2022 17:03:47 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236288AbiBKWDr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 11 Feb 2022 17:03:47 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 844F8C72
        for <io-uring@vger.kernel.org>; Fri, 11 Feb 2022 14:03:45 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id c3so5740166pls.5
        for <io-uring@vger.kernel.org>; Fri, 11 Feb 2022 14:03:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:in-reply-to:references:subject:message-id:date:mime-version
         :content-transfer-encoding;
        bh=2POW2w7lvVbXmXZyVW8XR9h7Hdpvjp2im19fardYC30=;
        b=JapK++UtR09u5svIH4oZ0T3AY9fKJDokbPVDRPRrOeBW4iptertyc93s2iXEuGdM3Q
         g+MZZnusxgiWkw8Flzf726yFtKvwWb2zXNpkCgx5LOeggEcyoMd5VE64ah/+36Cbskin
         MTicVpQtNL5zJj+PiLOB1aFlA1Sa+Vdx3dCqahefGfWCjwvoDkKEJA3OaodEOl7Xn2hU
         d7Dl6xwKuaQAQvkelca/PjC2lsA0N7lYNt90hRCAfl2eu3jWss6NKQhZdrSKg4ulBjvw
         PMrfh852wEfG7gxwlJLmQVteCtdkGkeMb+4a0/FvQ/u50ZCdyAts6O/Z/c6RgRxbs91c
         ED2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=2POW2w7lvVbXmXZyVW8XR9h7Hdpvjp2im19fardYC30=;
        b=aTIXPvp5zJNHUiqgooOIml/22FuU30NLIP1ncaKiTQvea9ybU7NKnlCq2owh80ITdY
         VijcTxqt2+uXbBkKgDn4O1iXGFV1m9A+HQpPEtNa0baiupWVB48ymJAN4Gq+WIDG7e/P
         kTCC7XAXFBUvvU+TOdUymgtgoEHvlS9bk4Dj8NRQ/C1IOXjZgmIJGdeljPAngR701W9U
         9awTtkiXqW/pH/nmg7mFTTqANn1u31E+C2fqaro0v722DGfEE9bj6W+gQhXzleNqICMt
         a+xP0iqMwCDYqnB6BnUGZ36SgbnuoFunkjELzLauanekBfd5tiEXaNDgNih3r7dfdfZ6
         1y0Q==
X-Gm-Message-State: AOAM530N8rme13Ytp/bGqcF2jUoRAbSu/ZzJRzfAzz2dibv0t1JYGwA/
        4LvedbsfUvDb4OimfJ0IqsvBMA==
X-Google-Smtp-Source: ABdhPJxwbBOVdZ/vkxmRHAIGWuMntJED5uR0H5UJlDNgr+AUFK1f23UFt6qs1wb2XeDpRTHZzC5wow==
X-Received: by 2002:a17:90a:1a47:: with SMTP id 7mr2464695pjl.222.1644617024902;
        Fri, 11 Feb 2022 14:03:44 -0800 (PST)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 142sm19428431pfy.41.2022.02.11.14.03.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Feb 2022 14:03:44 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, Akinobu Mita <akinobu.mita@gmail.com>
In-Reply-To: <20220210152924.14413-1-akinobu.mita@gmail.com>
References: <20220210152924.14413-1-akinobu.mita@gmail.com>
Subject: Re: [PATCH] Fix __io_uring_get_cqe() for IORING_SETUP_IOPOLL
Message-Id: <164461702387.21078.8567133944140020262.b4-ty@kernel.dk>
Date:   Fri, 11 Feb 2022 15:03:43 -0700
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

On Fri, 11 Feb 2022 00:29:24 +0900, Akinobu Mita wrote:
> If __io_uring_get_cqe() is called for the ring setup with IOPOLL, we must enter the kernel
> to get completion events. Even if that is called with wait_nr is zero.
> 
> 

Applied, thanks!

[1/1] Fix __io_uring_get_cqe() for IORING_SETUP_IOPOLL
      commit: 333561791386112e4801b61be15feaf4044c02c6

Best regards,
-- 
Jens Axboe <axboe@kernel.dk>
