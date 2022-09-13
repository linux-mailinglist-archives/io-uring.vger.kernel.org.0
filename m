Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D08895B7C77
	for <lists+io-uring@lfdr.de>; Tue, 13 Sep 2022 23:08:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229502AbiIMVIH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 13 Sep 2022 17:08:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbiIMVIG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 13 Sep 2022 17:08:06 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E05D669F4C
        for <io-uring@vger.kernel.org>; Tue, 13 Sep 2022 14:08:05 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id ay36so700473wmb.0
        for <io-uring@vger.kernel.org>; Tue, 13 Sep 2022 14:08:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date;
        bh=KQ08ovo8cE2Cv1PTDXttRfjzaZjAKihe6Dg0kiDovOA=;
        b=aHqn0FHX9oo4y08omSuZovGZFwyCbIeoGW7tiOEb2USEW8jiiGo6ae46gani0m5HMu
         WwIuDUwVTrNg12sf7XReMAxhjNxkPLTGukxoqr2zRDUU4tUhGAZQbMacXe9u9e2CTg6D
         PDxeaL2XX2ROxwsFBySW0sfts7LSccsuZ2dhCBxGmeBlGxqN+WmhmHkqCN4Y6/dhRGrv
         w2R+mFlD89UKWuc2L82bbIZFcN0ulYeKCJCGMOwcKV1ipOIlpZu2AsdgfQN1f3WrxB0l
         5auBPR6FLaKIfyaxqbZJzMwN2LkeOZBelRW5SrXoG3YZgPmOam5RYtrye1fS82mGfVG1
         lshg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=KQ08ovo8cE2Cv1PTDXttRfjzaZjAKihe6Dg0kiDovOA=;
        b=wvsT3lDRuZouzSUODua+DJQsD6FzR4RZBQo7hIg3fDxMsrgZ7OSAw50xMPAx023S2f
         QtmrCbyK7WPyk//1RoVzY/P+13MwEwQFVMiQF14xCk8G793F5cb9HXsjdmW6ZFBid/9o
         8tJuFZKE66sLh0rpa/4sff8W8EyguUrO7UkJUtUtEtrGjX6RUQWA1uIsOU1rsuMSOXR0
         x5PJ8jD5ThbRFyeYztVSxvMkgkLvUqxkvANMqua2nam1pLQ0GyC+vHVtHJKdXNdG32r2
         noLdRK+FhOjXAotjIkZbPwzz5kLwp1Rj+wktSN2tqEEXRoGd1EdmPEaKqST5qDqjPpua
         GDpQ==
X-Gm-Message-State: ACgBeo1oAVbEZirOdxldKP34poRQ9Pa5bsY4RvzcWhdOCyduGaykQ3+U
        mqqCA28X0lv+WDxUtchenshKbVzed6/LNxmE
X-Google-Smtp-Source: AA6agR7td6AyMAmbtsMgm0hU6//DSjUrwx6r9FRn+QEq5hJ8kvDeWVTZbB4eeNzN9hNu51mNtx602w==
X-Received: by 2002:a05:600c:2f88:b0:3a5:4014:4b47 with SMTP id t8-20020a05600c2f8800b003a540144b47mr831467wmn.96.1663103284103;
        Tue, 13 Sep 2022 14:08:04 -0700 (PDT)
Received: from [127.0.0.1] ([185.122.133.20])
        by smtp.gmail.com with ESMTPSA id bo23-20020a056000069700b0022a3517d3besm12854497wrb.5.2022.09.13.14.08.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Sep 2022 14:08:03 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     linux-block@vger.kernel.org, kernel-team@fb.com,
        Stefan Roesch <shr@fb.com>
Cc:     io-uring@vger.kernel.org
In-Reply-To: <20220912165325.2858746-1-shr@fb.com>
References: <20220912165325.2858746-1-shr@fb.com>
Subject: Re: [PATCH v1] block: blk_queue_enter() / __bio_queue_enter() must return -EAGAIN for nowait
Message-Id: <166310328309.12918.13628547136691339777.b4-ty@kernel.dk>
Date:   Tue, 13 Sep 2022 15:08:03 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailer: b4 0.10.0-dev-95855
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, 12 Sep 2022 09:53:25 -0700, Stefan Roesch wrote:
> Today blk_queue_enter() and __bio_queue_enter() return -EBUSY for the
> nowait code path. This is not correct: they should return -EAGAIN
> instead.
> 
> This problem was detected by fio. The following command exposed the
> above problem:
> 
> [...]

Applied, thanks!

[1/1] block: blk_queue_enter() / __bio_queue_enter() must return -EAGAIN for nowait
      commit: 56f99b8d06ef1ed1c9730948f9f05ac2b930a20b

Best regards,
-- 
Jens Axboe


