Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 070AA590081
	for <lists+io-uring@lfdr.de>; Thu, 11 Aug 2022 17:44:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236486AbiHKPn4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 11 Aug 2022 11:43:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236427AbiHKPno (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 11 Aug 2022 11:43:44 -0400
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D160F9FAAD
        for <io-uring@vger.kernel.org>; Thu, 11 Aug 2022 08:38:14 -0700 (PDT)
Received: by mail-il1-x130.google.com with SMTP id j20so10142732ila.6
        for <io-uring@vger.kernel.org>; Thu, 11 Aug 2022 08:38:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc;
        bh=yVPf9O+ocz+x+5P59o1KLoP+RNX/43F6g7pj/m1CaeI=;
        b=OfXNMCg77xeI4zB0j9qiFlDC/ND+ucBOAMR4sbqcDrQMj0JKN1JmhmQTS4VDhzrSHn
         FNWQYLNEgx2tDejOlOptgk4FmeYZqeqsnhaGVbROOzekbUmFvKVxIrMv+F6C0nyMz1Lt
         2t4e3vMuWT3ECoXaLXp1DPsb8W/Ea71IZQTR0eClNUakepXF6ns5PWFhevpll4Hr0J36
         BlHDu3YV9DCY6OKzD4LMckyeg0v1T7lfMFLcOf4XeYVEEMf8s8+H3NJ5r8hahX78alGh
         OK+YLs9yO13xEyhtCn44gpo8o5jTI1F5DcyRIRXkIBcwXtBe6hLQgTe21HdQvnppq2RC
         L27A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc;
        bh=yVPf9O+ocz+x+5P59o1KLoP+RNX/43F6g7pj/m1CaeI=;
        b=YNveFrHCjV/+GdP/O2hKL4QrSIfQq249itvXUsbSQnImqmCaSvY/9eVj8UbR2+W5/K
         GST+Pjy9ccya70CBfAVlUCKdyuR/8yFIMks/0BFVkZyBt2z4cgWddsVw9cC0SoM3u5MM
         AaWPqn5nNpZywArsWjN8hvaHS69ETR9wraO+JtFnEXQQ1Msgt/T8SyyKIHiqYeHzEzbG
         9mJsRKxt0VRvjysLa6u5hrNfHRB1ERKD7puUor3wC0Zret6eTfvwOqRDtJqBxh2/SY2a
         9V2rYeRyqGhSp4Bg8Mgg+WkLm69SggT332hBW94L8jbnQeSbU2r7gITVLA+xIk4DWCmk
         pUdg==
X-Gm-Message-State: ACgBeo2SrdegoWmee2P5kSzZJf2yWUSNtSzc4vzvq4eAh8iAtwgNoNM/
        t+k/jY2+qltPZzHOyyk8h7Md7A==
X-Google-Smtp-Source: AA6agR4c+lmYF7C0ysV2JnnYMIHvHYNqSqlnjlrRsxk+fyJFrRmewxViV0PmgcwlMAiYO7tnkv0/EA==
X-Received: by 2002:a92:ca47:0:b0:2de:a702:7a20 with SMTP id q7-20020a92ca47000000b002dea7027a20mr15695975ilo.307.1660232293320;
        Thu, 11 Aug 2022 08:38:13 -0700 (PDT)
Received: from [127.0.1.1] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id e12-20020a0566380ccc00b003434d0ae6e8sm1064719jak.118.2022.08.11.08.38.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Aug 2022 08:38:12 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     anuj20.g@samsung.com
Cc:     joshi.k@samsung.com, io-uring@vger.kernel.org, ming.lei@redhat.com
In-Reply-To: <20220811091459.6929-1-anuj20.g@samsung.com>
References: <CGME20220811092503epcas5p2e945f7baa5cb0cd7e3d326602c740edb@epcas5p2.samsung.com> <20220811091459.6929-1-anuj20.g@samsung.com>
Subject: Re: [PATCH] io_uring: fix error handling for io_uring_cmd
Message-Id: <166023229266.192493.17453600546633974619.b4-ty@kernel.dk>
Date:   Thu, 11 Aug 2022 09:38:12 -0600
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

On Thu, 11 Aug 2022 14:44:59 +0530, Anuj Gupta wrote:
> Commit 97b388d70b53 ("io_uring: handle completions in the core") moved the
> error handling from handler to core. But for io_uring_cmd handler we end
> up completing more than once (both in handler and in core) leading to
> use_after_free.
> Change io_uring_cmd handler to avoid calling io_uring_cmd_done in case
> of error.
> 
> [...]

Applied, thanks!

[1/1] io_uring: fix error handling for io_uring_cmd
      commit: f1bb0fd63c374e1410ff05fb434aa78e1ce09ae4

Best regards,
-- 
Jens Axboe


