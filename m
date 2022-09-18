Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 115B35BC074
	for <lists+io-uring@lfdr.de>; Mon, 19 Sep 2022 00:49:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229519AbiIRWtq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 18 Sep 2022 18:49:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbiIRWtn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 18 Sep 2022 18:49:43 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34D50627D
        for <io-uring@vger.kernel.org>; Sun, 18 Sep 2022 15:49:41 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id b23so26378475pfp.9
        for <io-uring@vger.kernel.org>; Sun, 18 Sep 2022 15:49:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date;
        bh=PmytAVK7opAEdDQ4rXfFCDzoBVwcyAQAcuiTT/JlG88=;
        b=ml3Hdfxrphgv7cy+0vEZM/yE0r0wbBNOSD4Nd9qVDR87OKIt++qihYmihm/w5bxxxn
         fQe6zUwQ3kpv5573IxP/+hkxwQus0j4RCzr2FIavdwOh4SBnn9fUX1DzxuMg98cT2oQj
         baLAhY4GSuIPbJO7stPvYAxMlvhNr67wUcno1m+dYxtyJTdATR7FsgnYwHwtKeccOPOo
         z6PlXPG37LrguHp9cYiRXH5pg+ynH9SumfyHZ09c7U61N6gf139gSFocCp29WfXo+boC
         7ifDsxdWadDJXAR5Xfi9ODdwCGJvYabkYlIK1uNavOEg6CB2soB6onL5IIXyBLW56fbC
         ESrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=PmytAVK7opAEdDQ4rXfFCDzoBVwcyAQAcuiTT/JlG88=;
        b=WjoPsZ/lpmLYRgSg3grRH9xWBtsalOP5OYImdEMLaeK5xR5sBJxiy47DlTZDmnHnLP
         Wpuns/3AKj7IsPaGNFqPBKF/dKXHErT1daPgaAFm/ckIilk675GZhlN5FB9qUTnXBDey
         7cLN+SW70WQy7ylvhVq0qnx5jkgORruJJOMen1nNZwj8hfMCQPRh9FmakbGj4/y/Wvyq
         v1DEV15N4c3GR8I3LLpzvu1/0T36KPiuPjR/6kvDu8ieQ4gGGFxo/MpMuMZ5JfM88/PU
         irFIJtQnCcoqIiI9E84llFG8Y7DM6q+khgzhzVUF2iTTkt/2PkZImrHigGlgejy/JbY0
         pALw==
X-Gm-Message-State: ACrzQf3K1QGIGt3qYwPBqo3FlR1u4+1Ykr6e9kGKwt3O08hTmt9JvNg5
        JCnmEiGpT379hcDNPf2Qp/Z701RkKoKZKQ==
X-Google-Smtp-Source: AMsMyM4gcdaYRflmkD9No5QTRbPo7IOD10aN64igMm63/yvkRISaxwIpP/3j3N2XFoU679TrSGgS3g==
X-Received: by 2002:a63:a18:0:b0:439:8dd3:c3a8 with SMTP id 24-20020a630a18000000b004398dd3c3a8mr13442940pgk.220.1663541380606;
        Sun, 18 Sep 2022 15:49:40 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id j13-20020a170902da8d00b0017887d6aa1dsm4500551plx.146.2022.09.18.15.49.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Sep 2022 15:49:40 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     Stefan Metzmacher <metze@samba.org>, asml.silence@gmail.com,
        io-uring@vger.kernel.org
In-Reply-To: <cover.1663363798.git.metze@samba.org>
References: <cover.1663363798.git.metze@samba.org>
Subject: Re: (subset) [PATCH for-6.0 0/5] IORING_OP_SEND_ZC improvements
Message-Id: <166354137966.4178.138118771429158655.b4-ty@kernel.dk>
Date:   Sun, 18 Sep 2022 16:49:39 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailer: b4 0.10.0-dev-355bd
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, 16 Sep 2022 23:36:24 +0200, Stefan Metzmacher wrote:
> I did some initial testing with IORING_OP_SEND_ZC.
> While reading the code I think I found a race that
> can lead to IORING_CQE_F_MORE being missing even if
> the net layer got references.
> 
> While there I added some code to allow userpace to
> know how effective the IORING_OP_SEND_ZC attempt was,
> in order to avoid it it's not used (e.g. on a long living tcp
> connection).
> 
> [...]

Applied, thanks!

[1/5] io_uring/opdef: rename SENDZC_NOTIF to SEND_ZC
      commit: 9bd3f728223ebcfef8e9d087bdd142f0e388215d

Best regards,
-- 
Jens Axboe


