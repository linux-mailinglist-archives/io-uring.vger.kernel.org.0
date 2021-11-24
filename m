Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FB9A45CEE4
	for <lists+io-uring@lfdr.de>; Wed, 24 Nov 2021 22:28:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242916AbhKXVbK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 24 Nov 2021 16:31:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232874AbhKXVbJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 24 Nov 2021 16:31:09 -0500
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52AD7C061574
        for <io-uring@vger.kernel.org>; Wed, 24 Nov 2021 13:27:59 -0800 (PST)
Received: by mail-io1-xd2f.google.com with SMTP id f9so4949199ioo.11
        for <io-uring@vger.kernel.org>; Wed, 24 Nov 2021 13:27:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:in-reply-to:references:subject:message-id:date:mime-version
         :content-transfer-encoding;
        bh=zyi9CixalvEz7ixqPUk2tzfTGmzIT9lStqhdQtPW7hY=;
        b=QmNw1Zl4NBZuP/tFIUNnUfmZsGTFIklPfMPcjn//9zJLLfX11TvE3lGY3NfxKauD0G
         OUb+JLKbNQhdmL+rrWbTYetla54ROt7ixb3c4mRyDYH3W89ftUeyKva4jw/SirYCg/yz
         WOUF7jwtqPKrDLwWhKmuoBbWgbYsFXI4f+7nIHpM/t2wB62PRt5f8POSrYS347JSwWx6
         xXyeO0iuW/L9lMiF6ldKG5ZNE6B/EDX0zLh3N2yCk+jO1f2I0lJbENyTB9TpGZYgOAJN
         kjX6b0VlPES+tx/WRGVPuHC+oGLv4hTO09p4rp0ufs6FCq35DnbQrvG+k27ioo/pMeQY
         sdiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=zyi9CixalvEz7ixqPUk2tzfTGmzIT9lStqhdQtPW7hY=;
        b=r1j5RiBAxoJ0t/XYlvTfbUsZqTtAuaG+ajmcCcfv9vbnL1m1192490+qX3YSRDR/Rf
         QCVS/i5BsIuA1rg2Ynuje/y1TwYogunFW9cJdxDxX3qakl0kS65+0V5SDbn+EzmeRsJL
         4YU5rZ8hxeytvcyklIWivQTvSgQEGi8FfBnm+LYDUwPhrMLRQSDFp/5gt3eYWxf8ZC+C
         xy+qTS46ZlCSiFFaUd2fvzdnmf5JsLsR9o2XY8JvnVse2qPMBwmRLmxivRHF0GLGcHW2
         Ues3GVv03Eiic4FrJmrAHw2pJNpd8RjTo4gY/Yu/Wn7zh4xUfsl8HAqmio7knO1jIDTh
         qKDg==
X-Gm-Message-State: AOAM531dEkTgRh1ZndJ9jT6qvjvRvg00i7GXoRUwbv/kd/aOcGp/8TKC
        hheOmjpb3dIG7UbHPCGfXjm+JdzPEeyaAAWa
X-Google-Smtp-Source: ABdhPJyUHeWzSPG0TfIotwGY8RKXDei67GUgLIDYA7AEMxlHZh4R/xwwaVSXiGanvhO7b3nBdI5Scg==
X-Received: by 2002:a5d:9f51:: with SMTP id u17mr18770426iot.73.1637789278568;
        Wed, 24 Nov 2021 13:27:58 -0800 (PST)
Received: from [127.0.1.1] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id z17sm523941ior.22.2021.11.24.13.27.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Nov 2021 13:27:58 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
In-Reply-To: <cover.1637786880.git.asml.silence@gmail.com>
References: <cover.1637786880.git.asml.silence@gmail.com>
Subject: Re: [PATCH liburing v2 0/2] cqe skip tests
Message-Id: <163778927813.495907.10942381413786820994.b4-ty@kernel.dk>
Date:   Wed, 24 Nov 2021 14:27:58 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, 24 Nov 2021 20:58:10 +0000, Pavel Begunkov wrote:
> add tests for IOSQE_CQE_SKIP_SUCCESS
> 
> v2: rebase
>     update io_uring.h
>     use IORING_FEAT_CQE_SKIP for compat checks
> 
> Pavel Begunkov (2):
>   io_uring.h: update to reflect cqe-skip feature
>   tests: add tests for IOSQE_CQE_SKIP_SUCCESS
> 
> [...]

Applied, thanks!

[1/2] io_uring.h: update to reflect cqe-skip feature
      commit: 2b0b33a7fd274e56d923d8dd027679feb1fd7eeb
[2/2] tests: add tests for IOSQE_CQE_SKIP_SUCCESS
      commit: 78f733007fd0ed50ec12421805716922541d8d47

Best regards,
-- 
Jens Axboe


