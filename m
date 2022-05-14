Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC6E952727F
	for <lists+io-uring@lfdr.de>; Sat, 14 May 2022 17:15:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232473AbiENPPP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 14 May 2022 11:15:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229606AbiENPPP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 14 May 2022 11:15:15 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDDB529C88
        for <io-uring@vger.kernel.org>; Sat, 14 May 2022 08:15:10 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id m12so10601378plb.4
        for <io-uring@vger.kernel.org>; Sat, 14 May 2022 08:15:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=yxYfTzmdgXDRJuzOf6+8kExeX3BwtIEehq3fFFwM9ZA=;
        b=X1xea55dLaDn1Ynry/mXCdhPUt3kiYmxtZwc6HqNpK8qcqGWlt9PM3NdDbHWcuQ8bv
         sMpc/JQolbaKYtAcjZ/Gt5+b+2DUOWO6ulf2PDWRLwR4TpxjkEvHLOEENV4kg31+fP6r
         IXdBoZ+5o+7F6NXDHbGVlWMWORV6/c7SFxvxZpIv57fKWkwvO2n0mtjflsUFWOJ/YhKI
         AGAIpFitSVu9rylMDBFa2tRYJ6Gsr522McrgOD2tdeyqBbqW0j3w8JZ/X5pcCHwpt6H9
         7fGM1miW8f9U8c8OSo5veGjIgZ4r4AxNtuhmJUNXLf9OBFGGERbgX4Rx2qOiy+ibKVng
         SBEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=yxYfTzmdgXDRJuzOf6+8kExeX3BwtIEehq3fFFwM9ZA=;
        b=CDrSVJ7Q61HQeWxmj8dLMA25vX/vRJ/mGy0dNJ3FY5C52wW1M1LT6CVrjl0hYQ6X54
         DDdtYRbIH4zp0UeFdHmavVFD+hHkl/DLEjgygIpfkH42Lw6dkKZ7MTWvLd4F3eq+1Brk
         vmOAJhDh/IxIjaJV9avYRvUIyvS2NkwMRgreR78zEFlgILknE94JNBR5+/tMAc3pbBla
         9F1UrW1o3T0mWz7kMBf4d9WIZqtFgyjneSXMn4uyhP3tc7pM4jYeWEsMIWQKwpmLmIxp
         hFhYNdJgnpzptiQYz2J7HDetcoePA8hv7ILKohEy64UxfkOXmqeXoVxGnk5AMpoB5jCA
         zOzw==
X-Gm-Message-State: AOAM533wfNEM0vgrjorSFzXVIHGcTYuusVfSc7uIg8R6TAfdF3kwbBnT
        TLeeH2lcimfYFfNuekVbaE5Y3A==
X-Google-Smtp-Source: ABdhPJzqrtTc0B36vmr4kyK3at3Hw9boZmZtv9JvF29y9fwDMYLiwraAOeqWf61tbnBHSNwvAQi2VA==
X-Received: by 2002:a17:90b:4b81:b0:1dc:4dfe:9b01 with SMTP id lr1-20020a17090b4b8100b001dc4dfe9b01mr10349365pjb.110.1652541310195;
        Sat, 14 May 2022 08:15:10 -0700 (PDT)
Received: from [127.0.1.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id a14-20020a170902710e00b001613dfe1678sm2319170pll.273.2022.05.14.08.15.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 May 2022 08:15:09 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     haoxu.linux@gmail.com, io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com
In-Reply-To: <20220514142046.58072-1-haoxu.linux@gmail.com>
References: <20220514142046.58072-1-haoxu.linux@gmail.com>
Subject: Re: [PATCH v6 0/4] fast poll multishot mode
Message-Id: <165254130855.66431.107173099151957637.b4-ty@kernel.dk>
Date:   Sat, 14 May 2022 09:15:08 -0600
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

On Sat, 14 May 2022 22:20:42 +0800, Hao Xu wrote:
> Let multishot support multishot mode, currently only add accept as its
> first consumer.
> theoretical analysis:
>   1) when connections come in fast
>     - singleshot:
>               add accept sqe(userspace) --> accept inline
>                               ^                 |
>                               |-----------------|
>     - multishot:
>              add accept sqe(userspace) --> accept inline
>                                               ^     |
>                                               |--*--|
> 
> [...]

Applied, thanks!

[1/4] io_uring: add IORING_ACCEPT_MULTISHOT for accept
      commit: 390ed29b5e425ba00da2b6113b74a14949f71b02
[2/4] io_uring: add REQ_F_APOLL_MULTISHOT for requests
      commit: 227685ebfaba0bc7e2ddc47cef4556050b6d7a8f
[3/4] io_uring: let fast poll support multishot
      commit: dbc2564cfe0faff439dc46adb8c009589054ea46
[4/4] io_uring: implement multishot mode for accept
      commit: 4e86a2c980137f7be1ea600af5f1f5c8342ecc09

Best regards,
-- 
Jens Axboe


