Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F5D445FEF0
	for <lists+io-uring@lfdr.de>; Sat, 27 Nov 2021 14:48:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355166AbhK0Nvg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 27 Nov 2021 08:51:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354987AbhK0Ntf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 27 Nov 2021 08:49:35 -0500
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B014C06174A
        for <io-uring@vger.kernel.org>; Sat, 27 Nov 2021 05:46:21 -0800 (PST)
Received: by mail-il1-x133.google.com with SMTP id r2so11898800ilb.10
        for <io-uring@vger.kernel.org>; Sat, 27 Nov 2021 05:46:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:in-reply-to:references:subject:message-id:date:mime-version
         :content-transfer-encoding;
        bh=/rbKWSYj1TtsCLDx2e36TOwgVXc6MG78mEEGzPOqHhQ=;
        b=Ye3h2BPztouXx46IRtMiFr4MSfgYVTLJPULM/rQ0yP/TcSGfk5K0q3gzQAf8ZVNfOa
         lKPm+RzibiC7JUJbdK2efU9fDUXlUOttZ570ksRR+yx77eIs5C006NinMkq8lo5/KF/S
         WM7chSsoPyLvoDa15J6Jlh5nxFpGg4dvekCNXL0CassgZQgCdPWukHpgvLEX4DI281wQ
         QEtG9+2SuGIjIcD8IFc0LNdXyE7KPzVRiD1qAug7MdWt+E4NZqCrFjNgbcOPKxiPVTBe
         CG1J0DWNjTPUsYeulmIyC009PxO9Yc2ica9seZuNNft9acAJ2lXp1q3CQVyOjexFaO+P
         W4UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=/rbKWSYj1TtsCLDx2e36TOwgVXc6MG78mEEGzPOqHhQ=;
        b=b+E1pL2wO1x2e6BrS7oqapxa0BrX93aUum5Zl6wwjWZCEa6+6sHwhvg8K4mKOO5JpV
         JA3PS4LjUnPn3tEGmCD4ZoYwC73bcjfvigajjZyRNgvrer21y/70aq1BzqB83pCRMk+3
         QFW222gPIf8g7HjizlyGRk3YyOPcaTp+Ghw7f/ZS1tf9jie6s1ihErEAsuQb37kVQ7Jd
         ou8mA2v3CFA8FTLhtJpVZPZA9+SEsvv2nJICeoAXYizYOCNGDcg52fzK5CbocfkBJnJr
         g2B9Z7pUt5zOlETh8RLTJidPzuHVYPOdBKAe6SkYD6SLpPhIgORFYwsu7n7xF4AAIPv7
         wvSw==
X-Gm-Message-State: AOAM531ahGg7hPQtT7AUEzg4BTt9rgiMtVMleAkFaAQFEU9uMJp4ZLq/
        1lMTeDqjYvTBrnYhPxM/kmJAZg==
X-Google-Smtp-Source: ABdhPJwfYpfl2VDuttIyeUFNDTeKGMY6J78Mc/7iKl8UuOGmJyZJ/VmLCIFfBcjNIghTtCvzA4r+ZA==
X-Received: by 2002:a05:6e02:1d19:: with SMTP id i25mr41321141ila.9.1638020780480;
        Sat, 27 Nov 2021 05:46:20 -0800 (PST)
Received: from [127.0.1.1] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id m5sm4962322iln.11.2021.11.27.05.46.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 Nov 2021 05:46:20 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <fe5333e8832e6bacb5c9ca9ec8d0004a6fd2646d.1637958333.git.asml.silence@gmail.com>
References: <fe5333e8832e6bacb5c9ca9ec8d0004a6fd2646d.1637958333.git.asml.silence@gmail.com>
Subject: Re: [PATCH liburing 1/1] test: skip-cqe with hardlinks
Message-Id: <163802077989.625364.6989109780301499376.b4-ty@kernel.dk>
Date:   Sat, 27 Nov 2021 06:46:19 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, 26 Nov 2021 20:25:42 +0000, Pavel Begunkov wrote:
> Test IOSQE_CQE_SKIP_SUCCESS together with IOSQE_IO_HARDLINK.
> 
> 

Applied, thanks!

[1/1] test: skip-cqe with hardlinks
      (no commit info)

Best regards,
-- 
Jens Axboe


