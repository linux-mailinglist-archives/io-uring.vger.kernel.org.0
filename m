Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39DCC606087
	for <lists+io-uring@lfdr.de>; Thu, 20 Oct 2022 14:47:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229514AbiJTMrd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 Oct 2022 08:47:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229658AbiJTMrc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 20 Oct 2022 08:47:32 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0C5D18B088
        for <io-uring@vger.kernel.org>; Thu, 20 Oct 2022 05:47:29 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id i3so20146054pfk.9
        for <io-uring@vger.kernel.org>; Thu, 20 Oct 2022 05:47:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Uo34Kor+krj3wTNkf2ckk7mrtzA70xpO6EYPrNK6ZSo=;
        b=fx7iLwB5+OpHrFy45xTy9VfjTXALIhiqkNANqk/JBfSVI+eWkuVgZusKmmDgOK+9gi
         jUAoVuZbEeRUo7RVn1eppGg+IoHf7UMpbF0PwiRjsaRXdnlx1w5KPZrS3LTQCOZUV8Gd
         Vk/8vojhNCki9aHD/bTxmuMCbJPN6HogNl+7PZWjED6qq3c1kKBU/UaJ7eFDWQsTK+ms
         ybp93q70XFsUPTYIhOBc4JCi5eKVTxmgV2C0if6Nm7gEtbES4O2biyGU8mtNSNTZbUIH
         tLmvpB6v/yGl6+X8f87mTQ2XH1io5vjionJ/iS31ESAjrrIJzZFeFEts+bLyePCa0cPN
         pMWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Uo34Kor+krj3wTNkf2ckk7mrtzA70xpO6EYPrNK6ZSo=;
        b=Pb35PvdjWfIHszT/GBk7m0bqnRRbJ1sB+ZuEYmsTdPB8ba9x171Aairq9pp4AQTfCl
         ziAJpI110x+6EZdl3k7g2wQtPZdQhhJOInmjHoNl+HPnyWc1qjWqOCgCfdw8NKdQnaFH
         vQwtoU6m/1qNQ1Ivyz6INkIhcROIAD1pvcGaJin9awqgrlaRy0cJHrrahuIvAkWQkhZ0
         I0LuSyTVD/HwPIUA4zM9REiE8TcFXti96OBMYgCpSoWiJjYjU2RMiSDT51twAw+V5GqJ
         pFU6NqAqh+k9jClm5AMMVjOC/DTv2QtaFky5moqBiGFbbL6bZrOwi1lCZjnDOZjAYc8O
         1ToQ==
X-Gm-Message-State: ACrzQf0Ub5BnhWleuBK7o+GFaczzSvk9GpQj8t2mSo8RL6GEA1o8PvCC
        U0+0mXQX8qEN2dKeJo1KypBhlQ==
X-Google-Smtp-Source: AMsMyM42Cwh37hB71+Ye5VLkZZYt3maCCBSmeuLGOc2325j3v01GM7k/YyZrSz5iEdnctuW30UvpNQ==
X-Received: by 2002:a63:6909:0:b0:41c:9f4f:a63c with SMTP id e9-20020a636909000000b0041c9f4fa63cmr12115396pgc.76.1666270049300;
        Thu, 20 Oct 2022 05:47:29 -0700 (PDT)
Received: from [127.0.0.1] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id m12-20020a170902768c00b00176675adbe1sm2035164pll.208.2022.10.20.05.47.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Oct 2022 05:47:28 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     Dylan Yudaken <dylany@meta.com>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring@vger.kernel.org,
        Frank Rehwinkel <frankrehwinkel@gmail.com>
In-Reply-To: <20221020115141.3723324-1-dylany@meta.com>
References: <20221020115141.3723324-1-dylany@meta.com>
Subject: Re: [PATCH liburing] Document maximum ring size for io_uring_register_buf_ring
Message-Id: <166627004805.161439.7287991206147032037.b4-ty@kernel.dk>
Date:   Thu, 20 Oct 2022 05:47:28 -0700
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

On Thu, 20 Oct 2022 04:51:41 -0700, Dylan Yudaken wrote:
> The maximum size was not documented, so do that.
> 
> 

Applied, thanks!

[1/1] Document maximum ring size for io_uring_register_buf_ring
      (no commit info)

Best regards,
-- 
Jens Axboe


