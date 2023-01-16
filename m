Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 164E666D0B8
	for <lists+io-uring@lfdr.de>; Mon, 16 Jan 2023 22:09:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231719AbjAPVJM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 16 Jan 2023 16:09:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233233AbjAPVJL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 16 Jan 2023 16:09:11 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07B0423858
        for <io-uring@vger.kernel.org>; Mon, 16 Jan 2023 13:09:11 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id 36so20477911pgp.10
        for <io-uring@vger.kernel.org>; Mon, 16 Jan 2023 13:09:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iaJciH/Wsecu5l9TebEyhmGPN9puTClZTuf7xJs3pXE=;
        b=WLLuRcO6Ls+zOXa4M31JZlqwDxk2bQOdHCwnUkqrmXzt+518dCyDUW4g7fHK/IlQc5
         Pj/3nfysFBKX/Ysc9g4FuUxSyNPOpYORo2qCiQTx58CY7+QN+bghUXAJ0o9W6U7+utFg
         HGGLZcakMNOT/9VOfXz6+eYyyVdVryMHj+NcEiOn1OAtp8eW/mHihSYCThRZXXd7jaxu
         bn53DAg87xc5PTtrziZ3A2PEDCYNIqxA2x0O9vnHmh1wMHNPlMGP9NkxPzExL9mxBHEY
         lojhrYH5Lf0GnUITVslIKPg416Bd7K09wv0S9ZUg9zE2rg+VZHGcGZwdM7Wr2S2BIgqp
         XyYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iaJciH/Wsecu5l9TebEyhmGPN9puTClZTuf7xJs3pXE=;
        b=pu10AqdmmtGnkmG7VvNkhKMxPK3OgFAES1bXm6L6LNh5Y+39/VYXxU0mZG/wRh2MRX
         Sp372iuJ2UTXpWnP7c62sM0pR2mWN7Mt/PdYUkyHCp9s8AMKy5h12e5Xo/c8DDktLJXO
         zCwY16W9X3KWh7w4pfHhFyXbJ3H3Y+BVk5dOfkgtS/Nw8kfWFDlSZOV2s3OrvYWDRhVs
         f9okoFtuNHMTE+tkYpt9tfZ3H4hkg1heGVm/MGBStWlcwG6OcyZTdpq6N7qEE5RaXEZt
         bCFloDycKQP7fjX/JkM9MyB0WmGlRrsbyQnyKZrUtYMAbMoKw9RIEiRjxGz412vRbaV7
         sQsA==
X-Gm-Message-State: AFqh2kqQwh1jJmRp4ySvfgpRXjvuXRoPX0S2OOk8mg+tFf5Xtf36Yyjj
        lBiJlTcCpc9j6EX6hjiGpAYoHqN7enEnL+f4
X-Google-Smtp-Source: AMrXdXvFEV6XH1XKDq0123EwMl4JhqmIozMsW9ihazdj1L/zq+s34WXAS/TFaJ5UIQJXIFJdM/BUhQ==
X-Received: by 2002:a62:e919:0:b0:58d:be61:7d9e with SMTP id j25-20020a62e919000000b0058dbe617d9emr249383pfh.0.1673903350301;
        Mon, 16 Jan 2023 13:09:10 -0800 (PST)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id i5-20020a626d05000000b0058bca3b8f76sm4322494pfc.78.2023.01.16.13.09.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Jan 2023 13:09:09 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cover.1673887636.git.asml.silence@gmail.com>
References: <cover.1673887636.git.asml.silence@gmail.com>
Subject: Re: [PATCH for-next 0/5] random for-next patches
Message-Id: <167390334964.348119.1839379323147508599.b4-ty@kernel.dk>
Date:   Mon, 16 Jan 2023 14:09:09 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12-dev-78c63
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On Mon, 16 Jan 2023 16:48:56 +0000, Pavel Begunkov wrote:
> 1/5 returns back an old lost optimisation
> Others are small cleanups
> 
> Pavel Begunkov (5):
>   io_uring: return back links tw run optimisation
>   io_uring: don't export io_put_task()
>   io_uring: simplify fallback execution
>   io_uring: optimise ctx flags layout
>   io_uring: refactor __io_req_complete_post
> 
> [...]

Applied, thanks!

[1/5] io_uring: return back links tw run optimisation
      commit: b48f4ef033089cf03c28bb09ae054dbfdf11635a
[2/5] io_uring: don't export io_put_task()
      commit: 41cc377f69cc1702d989c33eccbacd845d463c72
[3/5] io_uring: simplify fallback execution
      commit: ae96a39a7537ab49b9fb497e7c5e860ffc6fde72
[4/5] io_uring: optimise ctx flags layout
      commit: 4a26869e3c95ee20d03b178e413a619928a84d26
[5/5] io_uring: refactor __io_req_complete_post
      commit: 2c5c148670c650381bce849e164757ab6a2729be

Best regards,
-- 
Jens Axboe



