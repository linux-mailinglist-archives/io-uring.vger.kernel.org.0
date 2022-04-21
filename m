Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0849509FA1
	for <lists+io-uring@lfdr.de>; Thu, 21 Apr 2022 14:28:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354079AbiDUMb1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 21 Apr 2022 08:31:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352588AbiDUMb0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 21 Apr 2022 08:31:26 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4F7A30F5F
        for <io-uring@vger.kernel.org>; Thu, 21 Apr 2022 05:28:35 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id x80so4898040pfc.1
        for <io-uring@vger.kernel.org>; Thu, 21 Apr 2022 05:28:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=G/vvqdJtFqhZushQhXNz602vz/+jNdTl3gFwEbfQ3C4=;
        b=M6NOQhfTH+3QVIrWf9c1sNIzK82E4qY3D2hgekNfcWA0LXqp1gdiASEBNannqFY/EU
         nMYty9NPjRKWlOI0KVNtmtnNom6gYiRPQ1rRw2CFycmfN+L5NBx4ZeqHfuVWm/r7DpZl
         8c5wQ8hUkNUCcu5jfnMrJUhAOosV1ROREFI97mUNhcDquGsHV4d3gvaNtTQL6o2t8MX3
         cHZKQ789lU6FZ6aS3rTcwv9J47+oMfh6fpIsVYG7Wf/vbdV7QfmGw9UlbDi7dAKW1hva
         T7YPrvVWOMttaC4guHR4LW9QN1SWx5xTKjTCI9bzTYEtiCtt0ffyuGb35hmLXlw7ArV2
         vAVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=G/vvqdJtFqhZushQhXNz602vz/+jNdTl3gFwEbfQ3C4=;
        b=B1iiJGBxr23yrmo85/PJN3H8qxIOAXGQwWbVJT0PYV5CsS5K4nDbiHW/qY50Xmvp8n
         TgyfAhuuz+GI3CCJ9OzJ4AybMuZXzkJEUEcEUzQR6q8w/4zfCds+m755WxMis4ak7LiO
         RGEqCM9VbUmYZQXCgGUuRSDoqBzv0l7TSRYDOMQ3aWglsNdLowGwSRF6U1rSA3fJElBM
         rhKum0S1dLcPijPj8E8j5PvM1/tMepGk8Ug57FXV58DulcoTd75GqmKpIys6eqVzaPjr
         +O8PeUmlCAWDt2ya5k+Tm6fHFvdJf1o6BDmmMfyaAsc2OyH9UdjPsYsUm7i9X+fWy2ej
         8Bww==
X-Gm-Message-State: AOAM532b7OXUwWsWbIBxNZQSTTPVHWTY8upSi4+jwy8cY3dE8dmvGL45
        aSgzFodODM+KACNdb9QF0qAmvUCEXCaeoi+X
X-Google-Smtp-Source: ABdhPJzaTaSUFbIsugM0YiTK+jHFkfdrbsH/4Mzd4L+IS4+/4PWzxuVSrtmVbAfglRZ618LEBrFenQ==
X-Received: by 2002:a63:1141:0:b0:39c:b664:c508 with SMTP id 1-20020a631141000000b0039cb664c508mr24162407pgr.49.1650544115261;
        Thu, 21 Apr 2022 05:28:35 -0700 (PDT)
Received: from [127.0.1.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id pv7-20020a17090b3c8700b001cd4989ff43sm2787184pjb.10.2022.04.21.05.28.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Apr 2022 05:28:34 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     ammarfaizi2@gnuweeb.org
Cc:     alviro.iskandar@gnuweeb.org, gwml@vger.gnuweeb.org,
        io-uring@vger.kernel.org
In-Reply-To: <20220421075205.98770-1-ammar.faizi@intel.com>
References: <20220421075205.98770-1-ammar.faizi@intel.com>
Subject: Re: [PATCH liburing] arch/x86/syscall: Remove TODO comment
Message-Id: <165054411437.17122.17438818450360023359.b4-ty@kernel.dk>
Date:   Thu, 21 Apr 2022 06:28:34 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, 21 Apr 2022 14:52:30 +0700, Ammar Faizi wrote:
> From: Ammar Faizi <ammarfaizi2@gnuweeb.org>
> 
> nolibc support for x86 32-bit has been added in commit b7d8dd8bbf5b855
> ("arch/x86/syscall: Add x86 32-bit native syscall support"). But I
> forgot to remove the comment that says "We can't use CONFIG_NOLIBC for
> x86 (32-bit)".
> 
> [...]

Applied, thanks!

[1/1] arch/x86/syscall: Remove TODO comment
      commit: 4ad972d6d1b16e4fb069fc2f006265942cf33103

Best regards,
-- 
Jens Axboe


