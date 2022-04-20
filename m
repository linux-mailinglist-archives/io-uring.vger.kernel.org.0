Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D266250929F
	for <lists+io-uring@lfdr.de>; Thu, 21 Apr 2022 00:24:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243053AbiDTW1j (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 20 Apr 2022 18:27:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237210AbiDTW1i (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 20 Apr 2022 18:27:38 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3196710D7
        for <io-uring@vger.kernel.org>; Wed, 20 Apr 2022 15:24:51 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id u5so139071pjr.5
        for <io-uring@vger.kernel.org>; Wed, 20 Apr 2022 15:24:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:in-reply-to:references:subject:message-id:date:mime-version
         :content-transfer-encoding;
        bh=mmyJuM0335L2mWS79P6/bbBxRGoFrxDgKdjGMMIsaCU=;
        b=rSyDtGoZsyH6mMwJtnJwndfL/vJgMC4aEk+qCwN4RP0Hm+dyJ4E+GjhXz5f4gY4dgJ
         mlLcgt5ofdodPLhcf1bJyQcQqyL6H9dM9SkjeCkLM/lw24qIU2I4txOqr0qEP3Dq6Pe3
         A7luy+Yc/1xBeDKCedkxYm57tYXSEHTz+SKjbwsMAJGUVQWbnY2PS1bLLcvMXhttocni
         Wm7YASokxAD2pdB+Sz5SRua9xigJcAXcm8TXMCiyHyUNT9+tUNY7UoRjkwNc+f+VLq9E
         4cv/3d1DWeP3C1EmOFE7wZ6qswTThWgUbB3XjjnUZmjcEICcQxuyzpX3fGflgrBZzkJu
         EnVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=mmyJuM0335L2mWS79P6/bbBxRGoFrxDgKdjGMMIsaCU=;
        b=25qgWBPswAbswGZK75F7Qb5PetnCA/o+FzmpTnA3LeotnxFjPk41iKy3Vdfv9Jzkv4
         wfGDh9P4FuKN9CR2ums3CxFlj8fRtVqFC9hFpBLaWksvDDmmvbvVos7YoC7mFwGeN16Q
         oc2QaJG1cYYZr2ijZJLCxAWplx2Z+vwBsUvkucQMJ5txgV6daVz+PF9VJc4oTkeT80pw
         weR4+fUz0ZpAQzpQPa0/GLaAQr0ilqcnp1N1V7ctbV1KU+VZzrBeiCn6CC2YF107qmjQ
         wFj+NVujgepEgGH0XzBScshaGH73dqWx2BRJhp4ex01SqHdPOY5phPq/FAfEbUAWW++O
         LrjQ==
X-Gm-Message-State: AOAM530U1bGx7ZyPJCs/wvSxNOoqhSQ8ZH4qFtfdsXGMtFsefQq2zSLW
        EDRNrrK6+xA9l37kHDJ2yg00ibeEQKCZcA==
X-Google-Smtp-Source: ABdhPJxIGhS44ME90gbQDOdbjLB4+fJRApE7Ki4E8aWbOBiEwkmUyusuNpLt6zgNYLGP1X97EuHaMw==
X-Received: by 2002:a17:903:40cd:b0:158:fbc4:83ca with SMTP id t13-20020a17090340cd00b00158fbc483camr17009479pld.9.1650493490465;
        Wed, 20 Apr 2022 15:24:50 -0700 (PDT)
Received: from [127.0.1.1] ([2600:380:4975:46c0:9a40:772a:e789:f8db])
        by smtp.gmail.com with ESMTPSA id w22-20020a056a0014d600b0050a97172c4fsm8252892pfu.67.2022.04.20.15.24.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Apr 2022 15:24:50 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, asml.silence@gmail.com
In-Reply-To: <cover.1650458197.git.asml.silence@gmail.com>
References: <cover.1650458197.git.asml.silence@gmail.com>
Subject: Re: [PATCH for-next 0/3] timeout fixes & improvements
Message-Id: <165049348971.521838.6622952784723391225.b4-ty@kernel.dk>
Date:   Wed, 20 Apr 2022 16:24:49 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, 20 Apr 2022 13:40:52 +0100, Pavel Begunkov wrote:
> Fix the recent disarming syz report about deadlocking and brush a bit
> up timeout/completion locking.
> 
> Pavel Begunkov (3):
>   io_uring: fix nested timeout locking on disarming
>   io_uring: move tout locking in io_timeout_cancel()
>   io_uring: refactor io_disarm_next() locking
> 
> [...]

Applied, thanks!

[1/3] io_uring: fix nested timeout locking on disarming
      (no commit info)
[2/3] io_uring: move tout locking in io_timeout_cancel()
      commit: 03b1df2dbcaf77c46f6cc64747fd9151e36842ab
[3/3] io_uring: refactor io_disarm_next() locking
      commit: a850c21e744eda43d5d296a315d5a4208d3e2281

Best regards,
-- 
Jens Axboe


