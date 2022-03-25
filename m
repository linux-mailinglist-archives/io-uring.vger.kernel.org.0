Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE01A4E73A5
	for <lists+io-uring@lfdr.de>; Fri, 25 Mar 2022 13:39:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353236AbiCYMlD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 25 Mar 2022 08:41:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243507AbiCYMlD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 25 Mar 2022 08:41:03 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 299772126E
        for <io-uring@vger.kernel.org>; Fri, 25 Mar 2022 05:39:29 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id o8so6315056pgf.9
        for <io-uring@vger.kernel.org>; Fri, 25 Mar 2022 05:39:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:in-reply-to:references:subject:message-id:date:mime-version
         :content-transfer-encoding;
        bh=ooIN4Rxo7JIBOx57OWsR8hIMSdZ56KFXeKuSi4Fp82Q=;
        b=cwmBRXlLFLuovrIz70zGv4a2HkoAX+fOtqnssF6gZvmysRfF0i+9m+SUFp7lXKN8Hz
         L9iEUd3nmcT7U06Howix04g9WgjV5IH95sNu2HuzpuRuspuslQIO3792KRr10H8DJv05
         JQumrwgraYKId0S3Q7SWGh1KzJuebsPTy0hIU/VxYhdbCM5qY12qFmPpUzGRftPiZp+g
         vmMD+ATCzXj8AklxEyyYkiEL13igzbfn5UkXA0bZH+ndnGGW3eQmXhqAtyozLjYzUDme
         Nkurd5bSXOhkOZksc6GTm92Vzt8IgExqlS0VI9HsvZuveVgY4G/cq34lXWyZFcOdtFDe
         qZew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=ooIN4Rxo7JIBOx57OWsR8hIMSdZ56KFXeKuSi4Fp82Q=;
        b=GtyQ4jaiTXSbq7EvbsNAPg7AQVGrNZ4WctCEJ4/eY3YFgAShokwWgUksXPm8uaksXt
         KgfIe92lUqT9EIrm+NMPG2Fjy1Rj7OjL4XTinlOSCNIigAsH+gED3kTdhEmxfzf6U7Dw
         BbVNJ//M59cD6I7reSNluMH2e3NGUG+3D6Mv/dCmXZkE4NdvCzKke1sqOuKycVC/dOEQ
         lsXEnI2uMJymYCphKvEbNH6We3hT5x7RTeiyxF0Uwhee3z+sZnLdzsKu4EMpuyLFr51r
         bKAvAQpMYwLtCahhg+solAQ7rSUBhm/xl9aHV3FL9FtiZ+1T+ke2xcEJFj3ByuQjFk3N
         GIOw==
X-Gm-Message-State: AOAM532GOBVrecJoJT1jjKckO7BrDIsBWQNuynCdQGlA9UtGwoymDH0i
        g586HJQwzfb2o1r1B0RJv5/mag==
X-Google-Smtp-Source: ABdhPJwixPlx5ODNGJ8x16isoQp4zfuZED9MEPv0nPsTlAQYiEXAGSbIh9Hkb3ltRx7r8uzFiiEoNA==
X-Received: by 2002:a63:78ca:0:b0:398:ae5:6515 with SMTP id t193-20020a6378ca000000b003980ae56515mr422469pgc.345.1648211968516;
        Fri, 25 Mar 2022 05:39:28 -0700 (PDT)
Received: from [127.0.1.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id m18-20020a639412000000b003820bd9f2f2sm5525726pge.53.2022.03.25.05.39.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Mar 2022 05:39:28 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
In-Reply-To: <cover.1648209006.git.asml.silence@gmail.com>
References: <cover.1648209006.git.asml.silence@gmail.com>
Subject: Re: (subset) [PATCH 0/5] small for-next cleanups
Message-Id: <164821196772.10194.5871710538755489782.b4-ty@kernel.dk>
Date:   Fri, 25 Mar 2022 06:39:27 -0600
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

On Fri, 25 Mar 2022 11:52:13 +0000, Pavel Begunkov wrote:
> Minor cleanups around the code w/o any particular theme.
> 
> Pavel Begunkov (5):
>   io_uring: cleanup conditional submit locking
>   io_uring: partially uninline io_put_task()
>   io_uring: silence io_for_each_link() warning
>   io_uring: refactor io_req_add_compl_list()
>   io_uring: improve req fields comments
> 
> [...]

Applied, thanks!

[5/5] io_uring: improve req fields comments
      commit: 41cdcc2202d4c466534b8f38975d2e6b16317c0c

Best regards,
-- 
Jens Axboe


