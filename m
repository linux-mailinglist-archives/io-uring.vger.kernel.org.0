Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 648DA4E6867
	for <lists+io-uring@lfdr.de>; Thu, 24 Mar 2022 19:12:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347622AbiCXSNz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Mar 2022 14:13:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234332AbiCXSNz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Mar 2022 14:13:55 -0400
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2511B652EF
        for <io-uring@vger.kernel.org>; Thu, 24 Mar 2022 11:12:23 -0700 (PDT)
Received: by mail-il1-x134.google.com with SMTP id i1so3739298ila.0
        for <io-uring@vger.kernel.org>; Thu, 24 Mar 2022 11:12:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=WhNFg1YqQYqMySpk684iRaBl+r9K/Q4LRh7SPJ7sAns=;
        b=njkntam96H5QI7WW6jlsYij2BYugrJ7cqfI5UjzZ5y0U2mSOLDpdu/B02RBAZuz4y8
         qGWZ/IxQWu7jxBvwx0lUsHhfdRNU+NxUcyIFdkbWY498kqS8PY1fPBy1SvScwERGEYL+
         3aoDKcxkoj269rWqOnjJ7oPR1Z9bv0P8sMLbIwCJbNMhZvhQ9hUh0pg17J9jY+OVo2tz
         eAqjrUf3+Js7TrJRYWEp6PFTzj5aTjtRlAfFEJABGQaFPphSGOqPIrUNm1HkJKtUM8m9
         /+Ss3qQpKBIMCC06xMJMMV65evivd5ZxyLCYQEcyPR52HKTOF69H/1rspNJXu/7PyoT3
         H3ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=WhNFg1YqQYqMySpk684iRaBl+r9K/Q4LRh7SPJ7sAns=;
        b=P8hIfHLLEKsyJYfFOwrwesrw0VdCDwxkmjtBIRtJv58khhie5SXMDTAl1+waO7xHr/
         WVLaiLua161Fuhs1YGg9KSSTu24fZilVPIUdYAIwMs/FIt9hYdvzE/Vntu4kUUN8+MpU
         zxOrUA7UN3+lNkqmWFQELXR95hh30uYlZ8+4b1twqsPFYS4gHnEHpiJSruu+OtbvJVbj
         lgmHzQPhFRT5wfl2rL3MqfLAspoaNPFakJsiDUMTVNOxmQ4+LOvfaZwq544eKSWr/spw
         8ylONPZBFG99xoYIKdIMsgx/Teql4ByzRLu9/LTDVFTYBVwABq5pi/zjulnpqCJam1FE
         0xAA==
X-Gm-Message-State: AOAM531+K/WINKYw78jHnRm1CO6pxImbLjO/xTN6MgPQSysC+gXi28gK
        weyR3bLuELeANPmvAPVt5gufz+MeZXwup7/c
X-Google-Smtp-Source: ABdhPJxh4YNs7iYUb4FeEGUV4vw5q+dEtWcNc3R4Kanq+ckrO/kxXRBml1Z166fA61LypumkhH9w7w==
X-Received: by 2002:a05:6e02:1563:b0:2c8:8353:4584 with SMTP id k3-20020a056e02156300b002c883534584mr53796ilu.17.1648145542341;
        Thu, 24 Mar 2022 11:12:22 -0700 (PDT)
Received: from [127.0.1.1] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id h24-20020a6bfb18000000b006497692016bsm1865852iog.15.2022.03.24.11.12.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Mar 2022 11:12:22 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     Dylan Yudaken <dylany@fb.com>, io-uring@vger.kernel.org,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     kernel-team@fb.com
In-Reply-To: <20220324143547.2882041-1-dylany@fb.com>
References: <20220324143547.2882041-1-dylany@fb.com>
Subject: Re: [PATCH liburing] add tests for nonblocking accept sockets
Message-Id: <164814554179.101530.3418845189785992301.b4-ty@kernel.dk>
Date:   Thu, 24 Mar 2022 12:12:21 -0600
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

On Thu, 24 Mar 2022 07:35:47 -0700, Dylan Yudaken wrote:
> Add tests for accept sockets with O_NONBLOCK. Add a test for queueing the
> accept both before and after connect(), which tests slightly different
> code paths. After connect() has always worked, but before required changes
> to the kernel.
> 
> 

Applied, thanks!

[1/1] add tests for nonblocking accept sockets
      commit: 7a3a27b6a384f51b67f7e7086f47cf552fa70dc4

Best regards,
-- 
Jens Axboe


