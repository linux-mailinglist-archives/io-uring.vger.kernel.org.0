Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0F0B4E1999
	for <lists+io-uring@lfdr.de>; Sun, 20 Mar 2022 05:09:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229661AbiCTEK1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 20 Mar 2022 00:10:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbiCTEK0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 20 Mar 2022 00:10:26 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91273143C4C
        for <io-uring@vger.kernel.org>; Sat, 19 Mar 2022 21:09:01 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id t2so12793438pfj.10
        for <io-uring@vger.kernel.org>; Sat, 19 Mar 2022 21:09:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:in-reply-to:references:subject:message-id:date:mime-version
         :content-transfer-encoding;
        bh=e4ePsxVVzhC7F6Z6u3a9GqtmUYF8QrK4lzGMFxMl0qs=;
        b=sDClU3nz01VSoKynxjlKt51uzfayeOcHJFo/ECCc/kNba6m5ZrWUArH+DFNxdNl+zD
         Y/8yRbmx7MEdfGs4Niz8c8FiN2wtCtOsdM3uAawDJQ4F0edgsTcOkVaxpk+RisdwJVGo
         jpowxHsD4eWGRaY7ASqHwpZZz0HAN0qhBYbIUTQCStNZLvUWhyD3pjmr0fPPnu8ptBQ3
         c2F+9pvH/SrI8XeGqaxm8MN7uE8pBe9KNlk77MYtaRgyJlhsIYP8c1ztai10FW038wlD
         bNR/V1mKFIO/CwoaxTcR570I4723MgbgS4OgwPcllU4cQH0I4eSHaXwc2bULWb2XLv4a
         2ZSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=e4ePsxVVzhC7F6Z6u3a9GqtmUYF8QrK4lzGMFxMl0qs=;
        b=Sl3iZJ7tgejxkJoIU4NxowAnvY4Tmn808uyGLxZCgm6gqo8hurPyL4R66PgeuIUuJi
         8MgTtLsntdIDKb3Gro1VcGmVkGnejoRkMiJRGN16m3lU8yNdkhVcT0z2Gtk2Y68wNd7c
         R0fgk50I85ub1yw+sqkLA+ilM3jOF0auwG9vUUyTg5C086c7GSMWAmT49B0Nw5hKejFG
         /4r0Cn9TA2n4F52XoSwjzEp0JCCju9XxBPLqdTfvzZd9ETMPIGNAvfuENxpssLcFyssp
         s3BpdGBFlNKxrU68xVGJI/ff59DfaCpnNFAOKeR4dc4gcxfcUrye6r5KZ7NVW6wZkWVB
         bw6g==
X-Gm-Message-State: AOAM533/c3ZMiPS6Et8f/OVpWVLPkuRtrsf5W2LFqfjJWw8BE/u+dYVH
        DoAUDJHZdXj3sE3VVZOVI5HFYw==
X-Google-Smtp-Source: ABdhPJy942w1mZMltY84opgP3b8qF+yjKH+RSr+Ixjh3TLNDSVxh/lncG3QdHG7VljbUmz6e7cZeTA==
X-Received: by 2002:a05:6a00:10cf:b0:4f6:5834:aefb with SMTP id d15-20020a056a0010cf00b004f65834aefbmr17472125pfu.77.1647749340990;
        Sat, 19 Mar 2022 21:09:00 -0700 (PDT)
Received: from [127.0.1.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id w6-20020a17090a460600b001bf355e964fsm16106263pjg.0.2022.03.19.21.09.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Mar 2022 21:09:00 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     Haiyue Wang <haiyue.wang@intel.com>, io-uring@vger.kernel.org
In-Reply-To: <20220320032653.5986-1-haiyue.wang@intel.com>
References: <20220320032653.5986-1-haiyue.wang@intel.com>
Subject: Re: [PATCH liburing v1] .gitignore: Add `test/drop-submit` to .gitignore
Message-Id: <164774934024.253418.14589165235690051814.b4-ty@kernel.dk>
Date:   Sat, 19 Mar 2022 22:09:00 -0600
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

On Sun, 20 Mar 2022 11:26:53 +0800, Haiyue Wang wrote:
> The commit c56200f72a01 forgot to add it to .gitignore when creating
> this test.
> 
> 

Applied, thanks!

[1/1] .gitignore: Add `test/drop-submit` to .gitignore
      commit: 24908966b850a90256271c6fed020ddd5b9f997a

Best regards,
-- 
Jens Axboe


