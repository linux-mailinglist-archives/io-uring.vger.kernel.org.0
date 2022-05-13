Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BBE2526257
	for <lists+io-uring@lfdr.de>; Fri, 13 May 2022 14:51:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380423AbiEMMvs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 13 May 2022 08:51:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244014AbiEMMvs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 13 May 2022 08:51:48 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4DCC56C03
        for <io-uring@vger.kernel.org>; Fri, 13 May 2022 05:51:46 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id cq17-20020a17090af99100b001dc0386cd8fso7687896pjb.5
        for <io-uring@vger.kernel.org>; Fri, 13 May 2022 05:51:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:in-reply-to:references:subject:message-id:date:mime-version
         :content-transfer-encoding;
        bh=3cLNufzkzsk5VJH7sGsdJfZHjmRhXBMLW7N7CcG3N/o=;
        b=RZBgCGh1XM1uc4feJpYhlpW7WnpH3ecb7Zx5tOzFdSexvuFIopySiHgIHD2aCZ9x17
         zdP3s+UiJaVQHkgeFzAObcwrBxgJi3tGD6gMeouOLmKr6Xkw7rDZY6V3iP/19TykpdMS
         frtzTDSaJIyLuyxX2G0ijv9Wu/klj/SExCVNjR1Yg2bxnQ+rIC6Myh3m1QiQzJl0kBhP
         9NjiDvIRA92Z2aQZIyXv3b8c9w0oCGoTE+Vx/buZ5922GYMcVAbLGjT+cr01ucVkxXSS
         YVhhXbYUrywXa5ysEJCbbOQ0F/eZ+RrmyS+NLXPqh1av8QHDDurXZqgId44fJYVWsI7Q
         jdMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=3cLNufzkzsk5VJH7sGsdJfZHjmRhXBMLW7N7CcG3N/o=;
        b=bP9j3cnjHrlM+Fa7HrhD+Fv+JiPUJHo5ce2+2HRvKmKb9CC+7e+MU4gVI4SxzRTgoP
         8z4A9XhquWMqkDuXvgUfNyaOvxEd1o5tICrpqROVGAWIP/E3SG6xrykcHrMYbaSg0QQo
         gXoWJsqV76vmbGpPmQc8wY6GpZg+g37z3XRiyeqdD1qPgY8m8p7CDIL4su8MrzS+j5m8
         xQchMMH/O82XQz11g7LEDdn1tSwTbb4WsM/Qe8sIcL9sWw7JJi907CJRa1pVgMkEkj75
         /Y+kqV6dczNsIvY9reuTd6KXYmGN+TqHZj6i6C7k6JABQNGy8y0RY4wTWVLMh07QFvE/
         b20Q==
X-Gm-Message-State: AOAM530No/W/aloBuvWUuNsvGiytRObvypGPHHRZHP0ZbzA59qFOw5cA
        1Q2HLb0PKvPCWwCUarE+cnCdJ/8A/2CpLw==
X-Google-Smtp-Source: ABdhPJy7BEYqcUTn70vZsH3WhVnjnpjIHVM5lv8bag/U8oOktyoD6JSAb6IuZT5t82dzSD4NQhTDag==
X-Received: by 2002:a17:90b:14ce:b0:1dc:eff5:52b6 with SMTP id jz14-20020a17090b14ce00b001dceff552b6mr15904984pjb.148.1652446305966;
        Fri, 13 May 2022 05:51:45 -0700 (PDT)
Received: from [127.0.1.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id o9-20020a170902bcc900b0015e8d4eb1f7sm1819621pls.65.2022.05.13.05.51.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 May 2022 05:51:45 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, asml.silence@gmail.com
In-Reply-To: <f168b4f24181942f3614dd8ff648221736f572e6.1652433740.git.asml.silence@gmail.com>
References: <f168b4f24181942f3614dd8ff648221736f572e6.1652433740.git.asml.silence@gmail.com>
Subject: Re: [PATCH] io_uring: avoid iowq again trap
Message-Id: <165244630463.77357.10994886323758143279.b4-ty@kernel.dk>
Date:   Fri, 13 May 2022 06:51:44 -0600
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

On Fri, 13 May 2022 11:24:56 +0100, Pavel Begunkov wrote:
> If an opcode handler semi-reliably returns -EAGAIN, io_wq_submit_work()
> might continue busily hammer the same handler over and over again, which
> is not ideal. The -EAGAIN handling in question was put there only for
> IOPOLL, so restrict it to IOPOLL mode only.
> 
> 

Applied, thanks!

[1/1] io_uring: avoid iowq again trap
      (no commit info)

Best regards,
-- 
Jens Axboe


