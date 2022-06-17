Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4954854F85B
	for <lists+io-uring@lfdr.de>; Fri, 17 Jun 2022 15:35:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236431AbiFQNfD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 17 Jun 2022 09:35:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236198AbiFQNfC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 17 Jun 2022 09:35:02 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E5192DD40
        for <io-uring@vger.kernel.org>; Fri, 17 Jun 2022 06:35:02 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id q140so4079540pgq.6
        for <io-uring@vger.kernel.org>; Fri, 17 Jun 2022 06:35:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:in-reply-to:references:subject:message-id:date:mime-version
         :content-transfer-encoding;
        bh=hVLgw9IiRZK2cvfiYP4/SaV8vIt3Q7+Z5/U5NrozRVw=;
        b=f5KAyzo/icgwFnhfcQt+9w8aQEmk3a2bcX26uFIZUHsnTAAVbzzvNT6RAlYnET6DoW
         3Ke+lO3KBxxbv1J4SVVUkpeP5VT2diIUSJHLLLiXYoU+ahgZmtHNI8UnVa/RCfvXivs6
         D0cELJDe42QSilDbIPAwfjR3dazv2MdpWmgGu080e5tvrb6bc0kaRH6Ml5P5JZNA/ioN
         Py/XAOVDo4uLDNvKfZRH1FmMUcOCuD9uoCRWfl6WCF6ABcjak1yM+Bj2hx4TviM+qLRU
         Qp3uDiahr3X9cth8YxD8Qs5uHbG0B7L5z1qieinp6ZAYOeLWJ6eiNqvjxSw86IJSH2dC
         /ctQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=hVLgw9IiRZK2cvfiYP4/SaV8vIt3Q7+Z5/U5NrozRVw=;
        b=IGdMIpLiQvCI0IjsE17iyrYojIVR6XXQaWmrB16IY33rRCgxRaQEWkuTercV1ULr2v
         /A2FzOHnUqOlW8BQAMmUx8WizJX0qKhH2/pWlV0sFQOCXEn06RDIlv7HudKX1Pu6AsH9
         G5XWWG9bsDnX7nF1XQTMo0T59sYv9Bdlv+nnlY07LE5L04t7fvAh8pMY9U99QrqD2iym
         eVWLKr+HZjdsgiAyuU9A71eqHWdXcDryzJm0ISmVnYnDa6hdMZIEPcyvBdAydimPhA7X
         gDgBIVRXmvKUD2De/xWjwVROWs/QeGHvO7MIp/zECoc/QXAPeK8dWRzsBwmK4678vWmZ
         NUpg==
X-Gm-Message-State: AJIora9TUpBpS13rv2xcb2E2H0VYT+hhDgg0rugv0siEux8T5pF0cED3
        3UaSYfgvfTmflKM3c1dY5jT169eo1+Lzew==
X-Google-Smtp-Source: AGRyM1vs+Y9ZoT/5VKQHUOS8h80UNtYQ5sUCExs/IZrN0nLmNZeR2mtZIGeGXzXABSfj4eXE+tyu6g==
X-Received: by 2002:a05:6a00:139f:b0:51b:e21f:b72 with SMTP id t31-20020a056a00139f00b0051be21f0b72mr10165266pfg.75.1655472901284;
        Fri, 17 Jun 2022 06:35:01 -0700 (PDT)
Received: from [127.0.1.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id g15-20020a63b14f000000b003fd3737f167sm3770098pgp.19.2022.06.17.06.35.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jun 2022 06:35:00 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, asml.silence@gmail.com
In-Reply-To: <cover.1655455613.git.asml.silence@gmail.com>
References: <cover.1655455613.git.asml.silence@gmail.com>
Subject: Re: [PATCH for-next 0/6] clean up __io_fill_cqe_req()
Message-Id: <165547290061.360864.5731526604877823833.b4-ty@kernel.dk>
Date:   Fri, 17 Jun 2022 07:35:00 -0600
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

On Fri, 17 Jun 2022 09:47:59 +0100, Pavel Begunkov wrote:
> Clean up __io_fill_cqe_req() after recent changes
> 
> Pavel Begunkov (6):
>   io_uring: don't expose io_fill_cqe_aux()
>   io_uring: don't inline __io_get_cqe()
>   io_uring: introduce io_req_cqe_overflow()
>   io_uring: deduplicate __io_fill_cqe_req tracing
>   io_uring: deduplicate io_get_cqe() calls
>   io_uring: change ->cqe_cached invariant for CQE32
> 
> [...]

Applied, thanks!

[1/6] io_uring: don't expose io_fill_cqe_aux()
      (no commit info)
[2/6] io_uring: don't inline __io_get_cqe()
      (no commit info)
[3/6] io_uring: introduce io_req_cqe_overflow()
      (no commit info)
[4/6] io_uring: deduplicate __io_fill_cqe_req tracing
      (no commit info)
[5/6] io_uring: deduplicate io_get_cqe() calls
      (no commit info)
[6/6] io_uring: change ->cqe_cached invariant for CQE32
      (no commit info)

Best regards,
-- 
Jens Axboe


