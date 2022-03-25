Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8DAD4E7D81
	for <lists+io-uring@lfdr.de>; Sat, 26 Mar 2022 01:22:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233748AbiCYWJS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 25 Mar 2022 18:09:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233742AbiCYWJS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 25 Mar 2022 18:09:18 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8F0932EE6
        for <io-uring@vger.kernel.org>; Fri, 25 Mar 2022 15:07:42 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id v4so8724332pjh.2
        for <io-uring@vger.kernel.org>; Fri, 25 Mar 2022 15:07:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:in-reply-to:references:subject:message-id:date:mime-version
         :content-transfer-encoding;
        bh=vGdR4gnRgHJPSXtz4WMBxzpGoWitKsYNLNHXxLUJcKA=;
        b=X1klt6w+fLciSiw7phBZVCnqSw2f41A/m83Av2NcKOpg57h/LmZuUkJ+KLsnFiWDt3
         D1PHzQa0HA2HnJr/0eKiolFKgLPD6CqBLq0K0MCVTCcq1vwygufhGbt8NuhQY3GLNONT
         RaWG312jUw58rfvRwLB2USTKIz52g7rsBwAOEocBUyTWQaQeDvPvhaEnUwDr1koFCnJP
         Vlcbota51CZ6XC/HWWRF8wJrTT2dpwKsmsPjU37Fa+3F6CtRDP5lKwjApHbstZRU2K9q
         JRxuYFmgt90b/7d/dCi0kQKFVrgaFghgf6CUgDN8cSQtGNDh8+oJU866sxK+jTQcvYPB
         w4oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=vGdR4gnRgHJPSXtz4WMBxzpGoWitKsYNLNHXxLUJcKA=;
        b=FLiR/90guRDTnwMVrx/QS7FOFLpJ0xZ51BXHrz8kSJhtOJ8TfRUL5xAiqinIqEp2Gb
         pqpwwVGEk0FUhz4Lx0Is6rayDOLT8XSVBANKT8qcMVQZeZfTW4LUMvtKgLdgiNsJW1Kv
         kr7m93sFRn2+9Ck6sCMDWkZ6jOdn2yWObATXZgZ6afL7/P+wtMed+/dX93k7IjSk8JEh
         Iu0dybK2S1JIZJw1tbtIDKH29rId08yY6ar6m/NiGRIth84l/Z5myb5yGAbJKbfBbHK7
         +QPyUnZCEU03+9XEE2f5pqgDdQ94Drvxwlz608bGoFce3hNTApQ+MLi9LaHiCIgUhRj6
         4CJw==
X-Gm-Message-State: AOAM5304sR2fRnt1UQB7mGlPC3odOlVAgsO6/bc5vqEOfFTBmubH0Q3M
        GU7L2HxtL8tsi3R66ku7eK122RYcNEGMFU/z
X-Google-Smtp-Source: ABdhPJzSQQnwMLnwI7ZBBgHPeqs9aOyf1D05naBZI/aWcO/DbJ6yfFCIqpgLHWKK/EYP4UdyVmNpSw==
X-Received: by 2002:a17:90b:4c44:b0:1c7:1326:ec90 with SMTP id np4-20020a17090b4c4400b001c71326ec90mr26981503pjb.87.1648246062162;
        Fri, 25 Mar 2022 15:07:42 -0700 (PDT)
Received: from [127.0.1.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d16-20020a056a00245000b004f7728a4346sm8025575pfj.79.2022.03.25.15.07.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Mar 2022 15:07:41 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <accee442376f33ce8aaebb099d04967533efde92.1648226048.git.asml.silence@gmail.com>
References: <accee442376f33ce8aaebb099d04967533efde92.1648226048.git.asml.silence@gmail.com>
Subject: Re: [PATCH 5.18] io_uring: fix leaking uid in files registration
Message-Id: <164824606076.470461.2361305622685411284.b4-ty@kernel.dk>
Date:   Fri, 25 Mar 2022 16:07:40 -0600
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

On Fri, 25 Mar 2022 16:36:31 +0000, Pavel Begunkov wrote:
> When there are no files for __io_sqe_files_scm() to process in the
> range, it'll free everything and return. However, it forgets to put uid.
> 
> 

Applied, thanks!

[1/1] io_uring: fix leaking uid in files registration
      commit: c86d18f4aa93e0e66cda0e55827cd03eea6bc5f8

Best regards,
-- 
Jens Axboe


