Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFDD4607547
	for <lists+io-uring@lfdr.de>; Fri, 21 Oct 2022 12:44:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230022AbiJUKo3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 21 Oct 2022 06:44:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230010AbiJUKo2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 21 Oct 2022 06:44:28 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6328B5E
        for <io-uring@vger.kernel.org>; Fri, 21 Oct 2022 03:44:20 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id h13so2208434pfr.7
        for <io-uring@vger.kernel.org>; Fri, 21 Oct 2022 03:44:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jLiMQvErsz5nhsIXaAYmdYWoZ+DPukc3JkJRkapzirE=;
        b=ZcFLBZ+jt4g60FQJdu1lLHlRb4KFdo3VtUj/iFMT7ss27xzQIIZhTy4w9k/+hvM3JB
         j3pkpxAJI+BcgTBhcpG2JmyeBnDrGey9scCMdZuzTKCGoJShG04awkx4dY+/JI6/Opjx
         +ajzodPDO2vtLhxbxezRIUhjqkOMTXNUPVeRT7MKs4AXnY863d+lthBEkOyVun7UNUfT
         eyzrKWf/i0L/q1dw1md6EPdh0nFUcQjHSggIvbvERwVDp8byUqNCrQ+JVKJGIRkrzeZq
         Nc/a42Q7HaVvIYh2B2VuI1KCJkEr4UWpLCjSSywmKXnyjYrkTVT1m26TtqTbCeZcPFio
         01Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jLiMQvErsz5nhsIXaAYmdYWoZ+DPukc3JkJRkapzirE=;
        b=gkvzY62gKiY3KWbIbikhj7zNOqJW5SJeRUtLp8fByeP64oJN5pZLGJZNXkgqjteozn
         8zSXmVaeCwWmuAhFHUIawTAC8bSNFGLNk+ZRggjwV9LpxSRMgJVmQt3g6AGeNatucU+h
         VMZdmf8XKkfO0rAB3xorPAX1N0b7/CoF52Gl9sgUAsT1n6Tcis+0Yt+5NcIGe5NvinqK
         qQw+GOSuvmX4EDku78z2OkhherJ7MakZxDs6a0/LBv2vwCQB8JHB7qzA57EgsBLAHwN7
         cmRuq/9fIQd15jC3RaO4F+td1u8qJLBFz32IO+IiUEP45T2qLW74fNel6BwuDYGW1IF7
         OgZA==
X-Gm-Message-State: ACrzQf1q0LnaD/zpWvFzkL9OxsWzfkoeH/j/NBLg0sOjdEMq7vpO8mGg
        jICecH18SYbCL1DKNP36KE/myLKeoeRxCNz0
X-Google-Smtp-Source: AMsMyM5UsBqH7FW7RsIop8pYjbx5ea7k2TGpsTZpg7vuocii5rKRzzuRWf3q5G9ZbxWk1gA8V6AAcA==
X-Received: by 2002:a63:4651:0:b0:43c:1cb7:5c09 with SMTP id v17-20020a634651000000b0043c1cb75c09mr16148560pgk.259.1666349060207;
        Fri, 21 Oct 2022 03:44:20 -0700 (PDT)
Received: from [127.0.0.1] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id s3-20020aa78bc3000000b0056323de479bsm14858218pfd.120.2022.10.21.03.44.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Oct 2022 03:44:19 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Dylan Yudaken <dylany@meta.com>
Cc:     io-uring@vger.kernel.org
In-Reply-To: <20221021081207.2607808-1-dylany@meta.com>
References: <20221021081207.2607808-1-dylany@meta.com>
Subject: Re: [PATCH liburing] fix recv-multishot test skipping in 6.1
Message-Id: <166634905933.216036.16588950912394303703.b4-ty@kernel.dk>
Date:   Fri, 21 Oct 2022 03:44:19 -0700
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

On Fri, 21 Oct 2022 01:12:07 -0700, Dylan Yudaken wrote:
> This test was skipping in IORING_SETUP_DEFER_TASKRUN as it was not
> flushing the work queue before checking for completions.
> 
> Additionally fix the test to only skip if it is the first loop.
> 
> 

Applied, thanks!

[1/1] fix recv-multishot test skipping in 6.1
      commit: 30ef21439266741149b52540fe190ef21f9629ba

Best regards,
-- 
Jens Axboe


