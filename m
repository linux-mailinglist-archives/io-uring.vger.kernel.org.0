Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 656477A508D
	for <lists+io-uring@lfdr.de>; Mon, 18 Sep 2023 19:08:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231392AbjIRRIv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 18 Sep 2023 13:08:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231368AbjIRRIq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 18 Sep 2023 13:08:46 -0400
Received: from mail-oo1-xc2d.google.com (mail-oo1-xc2d.google.com [IPv6:2607:f8b0:4864:20::c2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF559FD
        for <io-uring@vger.kernel.org>; Mon, 18 Sep 2023 10:08:25 -0700 (PDT)
Received: by mail-oo1-xc2d.google.com with SMTP id 006d021491bc7-57af64cb99aso752743eaf.0
        for <io-uring@vger.kernel.org>; Mon, 18 Sep 2023 10:08:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695056905; x=1695661705; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:sender:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YgsQjPYSA4x9EUAST26pLIMgzwk5/fmUNEDBBVE+P4A=;
        b=grH+ZwK1UYdft+7Si3P+7Qi9uLWgQuuOv9eINrHhKroBVS1Kh6l3QkoNNGtH4pEakN
         BrzDNC0JnZTyHw0xLZDeHCMAiO6VTjx1L2pRAkxz+SpfxPAHSZnRq2GLxTBWoOA1SOIc
         JF1N82wp5zQby9S9b9Taun6y5IWbc8OKPhpLIx9Algzg3NFjCZ1P/hiFUwNO7s5nNFxg
         bLEEXtvB4//lmQQJP7mgXgAh1r23WkUg/9retWQTLykXkBxJ63yAg9T3DwFlu/YwwypM
         RnHDLK9gzhNTuWa4DBJMU55lquUBIYFe+9b6aJCrT41OnkF9WI28v/VOK1iQTGWwRJzZ
         wf6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695056905; x=1695661705;
        h=to:subject:message-id:date:from:sender:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YgsQjPYSA4x9EUAST26pLIMgzwk5/fmUNEDBBVE+P4A=;
        b=hR6lLb7GFC8gGoDTGv3uSSlXiGbAlO1jiJTtOsktmtmTUA7byLOcu7+AR4Yk6hf9ew
         Jbh147deZnioU/5bp3mbhOiQsW5h2jxu8n7PXrISbfS1I6u5qH9azt8o/t/zFDXDcBMp
         gkdmsHv5wsWaNY5uc4p21I8N1mxsgfZSbI/dMcc1t48Yh5Tf6a/Wxkk7XJRI/JIy7Ri/
         kAepMTajc+vHhBiFDn9020VBKl3FNQ6ak4+WvvgGMzH2QkaS5MtmaaMLjatxGHT+/YZm
         CfpLVJyW63VvKURpp5iyR9GzMQyq6hzuW6vQZT58o6O+Q+1DGaePiUgG97bdh4frl5J3
         fYxQ==
X-Gm-Message-State: AOJu0Yy90hjvd3NlbWHUh0d1NCuYJjSwi7RfZ9aHdrqki1Lwa8x/yXbz
        z7DKQCQ54gjmEyVRg+GvVz8cWVcBL5oNBtO29dA=
X-Google-Smtp-Source: AGHT+IF2GxNrWO1Srah90nHDU+JvJDmeDyKQlmweOAZYhoYGbE72HIbpNWeELu2uIrvyY/Q2RO3xUdYeJ37Umz9NSbU=
X-Received: by 2002:a05:6870:b691:b0:1d5:b442:5de7 with SMTP id
 cy17-20020a056870b69100b001d5b4425de7mr10340230oab.35.1695056904872; Mon, 18
 Sep 2023 10:08:24 -0700 (PDT)
MIME-Version: 1.0
Sender: mrmgfocus@gmail.com
Received: by 2002:a05:6358:9896:b0:139:8565:29c6 with HTTP; Mon, 18 Sep 2023
 10:08:24 -0700 (PDT)
From:   Dr Lisa Williams <lw4666555@gmail.com>
Date:   Mon, 18 Sep 2023 10:08:24 -0700
X-Google-Sender-Auth: C7EyQVAUxNXmFec-lYaEr8u-EYY
Message-ID: <CAPNbEC8qLbcSLphD80qGouFW-=FrAGfJjQ4nyZ=1GyFX+-2uRw@mail.gmail.com>
Subject: Hi,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.6 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_RANDOM_ENVFROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

My name is Dr. Lisa Williams, from the United States, currently living
in the United Kingdom.

I hope you consider my friend request. I will share some of my photos
and more details about me when I get your reply.

With love
Lisa
