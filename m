Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 478264BAA4E
	for <lists+io-uring@lfdr.de>; Thu, 17 Feb 2022 20:51:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240102AbiBQTvh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 17 Feb 2022 14:51:37 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233966AbiBQTvg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 17 Feb 2022 14:51:36 -0500
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66BCA12E173
        for <io-uring@vger.kernel.org>; Thu, 17 Feb 2022 11:51:21 -0800 (PST)
Received: by mail-io1-xd2c.google.com with SMTP id c23so267635ioi.4
        for <io-uring@vger.kernel.org>; Thu, 17 Feb 2022 11:51:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=2dcA/6gLsbKZFB+WFymwOUXCsSuxQfOADqfv4IvAXoM=;
        b=cFCQfnHS3K/DlP8d1VPqSnCTbKx1iZzVkmolMF3s2DL60iDMsfY0vKXnLMGOccRkeT
         UuYVsWtKkULwOTztg03a2tqHRIkuywXZPj7y9ddFOWdbLmrWLm5ydStyblCFQ4aNFXaZ
         hDBVTNzMNknv20XeKtxuzX9qSE3Vna5LGZ71HdSTM6tG+6kukaLTnwQDzinDt2Luf0gA
         ibGLuOe87F5D3M6bom33jI/utqryc8i/bDNdaTOzPBzKXflsN992SAtWLZw611wyCUBf
         z1mzh0NionythAlC6SNcokdK9SsiZyK8tvgoASPV5+2KELSPS6Q2+fATauRMl55kbYD/
         74kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=2dcA/6gLsbKZFB+WFymwOUXCsSuxQfOADqfv4IvAXoM=;
        b=TtZkxbizhwb9KrmEroshm3c7pmt7uSW3paY4GVCl4d6u/ezSCVqOElel7mScBTIyPT
         H08lZhVlHsh93DPy3kHMv3o/wD9Jlkz10xde3ZxFFHTSN0pS+59AXEMPdIAFJsHwaxpT
         Ooe8fn2qRVVSh39SjiyFgsTAk5b0YQ09CpnR8vL9wUfy7m63ClCuVcI+ETxKGRZRhU3c
         2Qa41iMQLHX4Z/QPM3Ur4B4krp4UzGX3DYjO8vYjwL30KmWPBG+6M20Cq8z80SgI9xyx
         jnhtBmbUKwOuLgVXz8CTlgfNYe4vqe5i1/xyNQEmi6X5mGUGlJDSHbToqGfDQkNzLlKa
         3YQQ==
X-Gm-Message-State: AOAM532vnHzderLgEYTwQJVDsLhkxI3Ke0gRFxiB84g0OXtTCzv5qE+g
        kq1TgRKXnbUIPi/xtJfF0VQ41W2nTB0KdA==
X-Google-Smtp-Source: ABdhPJwAzxnstaPx9fMxE6NFTg1pXbvI/p9jgna6qP/N+AALouNmT2tdhGwFdWp3BiOOrXE7cqCPKA==
X-Received: by 2002:a05:6638:d85:b0:314:81d4:2319 with SMTP id l5-20020a0566380d8500b0031481d42319mr3002441jaj.105.1645127480506;
        Thu, 17 Feb 2022 11:51:20 -0800 (PST)
Received: from m1.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id c24sm197351ioh.40.2022.02.17.11.51.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Feb 2022 11:51:19 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     Olivier Langlois <olivier@trillion01.com>
Cc:     io-uring <io-uring@vger.kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <bd7c0495f7656e803e5736708591bb665e6eaacd.1645041650.git.olivier@trillion01.com>
References: <bd7c0495f7656e803e5736708591bb665e6eaacd.1645041650.git.olivier@trillion01.com>
Subject: Re: [PATCH] io_uring: Remove unneeded test in io_run_task_work_sig()
Message-Id: <164512747966.22697.4097732498015286286.b4-ty@kernel.dk>
Date:   Thu, 17 Feb 2022 12:51:19 -0700
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

On Wed, 16 Feb 2022 14:53:42 -0500, Olivier Langlois wrote:
> Avoid testing TIF_NOTIFY_SIGNAL twice by calling task_sigpending()
> directly from io_run_task_work_sig()
> 
> 

Applied, thanks!

[1/1] io_uring: Remove unneeded test in io_run_task_work_sig()
      commit: 9e9d83faa9f59266aa772148e32c265c8ad194d3

Best regards,
-- 
Jens Axboe


