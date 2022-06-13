Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E364A54A156
	for <lists+io-uring@lfdr.de>; Mon, 13 Jun 2022 23:30:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349787AbiFMV37 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 13 Jun 2022 17:29:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352890AbiFMV3K (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 13 Jun 2022 17:29:10 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 309CB229
        for <io-uring@vger.kernel.org>; Mon, 13 Jun 2022 14:23:11 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id 3-20020a17090a174300b001e426a02ac5so10007846pjm.2
        for <io-uring@vger.kernel.org>; Mon, 13 Jun 2022 14:23:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=YGhGRx4mHQFNW7MOr+A/NvSpelXxEDEpH9pCf2c4K9Y=;
        b=e91p9YVuNw2svM7xGlkwIt3gt845c9MHeu9PvaOGs+Vha+DkM1Berot+EIT2OQP/Gf
         OlhMaXY5Q9PgdGbExDbbALd2dXY3yTet8S7lQCdIrmrWArYMDVwl8VG1hNBvKMLDyWj0
         R+9pl51Pz8HjVKzxDyVk3TpqH63uoliPxUvMc3+/7dKV7s+v8zXaHLnnPsQ777lyDeMn
         1qrb5qyHxMjDWi+LI12dbCig/FUBwQso/XqnJLOhL0R1PWn36zal2HRGOjXonFI2T9KF
         9cpR5zh4cv7ioaGCDF5pYluVrUf2uprNG5mHbSfX90ulRdkiFvCzG+Kw420VsHaZJkt8
         q+Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=YGhGRx4mHQFNW7MOr+A/NvSpelXxEDEpH9pCf2c4K9Y=;
        b=7H+hg0KzQqdpMd5wXRM7SyqHZBtWKMEj4Yc7fUoJSYwlPFF/WpiUGuMF77BKyv8tJU
         T0h0z9cXz8umEl0sefL1HgEFjCssTuNVekQLFaEJfqAriEdXuPYkJJc82yaAoauZehPm
         DrEqSMqsP1fSUia8181zk5lx6SiJG4xORbLuz3fbG/Hh1mArqAU1ZfRtohyJ8ZGG/rCz
         G7HAGINsiFG6WHk/qXC/hrSGO4G40UApEDaC/jvUeMhQ8zLjecQH1Im0xZ65L3fKdfWJ
         TcR1x851bhxF53pkobFMN98LqrQrr/vveFbxMDP6EsU44CKtQtnZOclSxuSVrtKGIGJb
         D7ZQ==
X-Gm-Message-State: AJIora8bL+j0/aYjt8+6AbWGki09xaq+qIsJO0YdZiTmzDP8RLOMfWZQ
        h/vD/mNEcznrWYs+UWMCJ17LHkMYH64O3L3Y
X-Google-Smtp-Source: AGRyM1uq89Xc9p9O38GVzZEYANll8SwiM7BSy7dJocj+fokdY79yBSrEkIVy0e6bEzU+vEnTZ0mwDg==
X-Received: by 2002:a17:902:788b:b0:168:bffe:4049 with SMTP id q11-20020a170902788b00b00168bffe4049mr1062237pll.75.1655155390401;
        Mon, 13 Jun 2022 14:23:10 -0700 (PDT)
Received: from [127.0.1.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id y18-20020aa793d2000000b0050dc76281e3sm5813828pff.189.2022.06.13.14.23.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jun 2022 14:23:09 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, hao.xu@linux.dev
Cc:     asml.silence@gmail.com
In-Reply-To: <20220613112231.998738-1-hao.xu@linux.dev>
References: <20220613112231.998738-1-hao.xu@linux.dev>
Subject: Re: [PATCH] io_uring: remove duplicate cqe skip check
Message-Id: <165515538964.7320.18065366235915830827.b4-ty@kernel.dk>
Date:   Mon, 13 Jun 2022 15:23:09 -0600
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

On Mon, 13 Jun 2022 19:22:31 +0800, Hao Xu wrote:
> From: Hao Xu <howeyxu@tencent.com>
> 
> Remove duplicate cqe skip check in __io_fill_cqe32_req()
> 
> 

Applied, thanks!

[1/1] io_uring: remove duplicate cqe skip check
      commit: 5703449632a7f565d71ebbf5393b284074939814

Best regards,
-- 
Jens Axboe


