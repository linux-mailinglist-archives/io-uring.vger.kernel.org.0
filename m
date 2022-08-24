Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6282459FFA5
	for <lists+io-uring@lfdr.de>; Wed, 24 Aug 2022 18:39:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237759AbiHXQjo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 24 Aug 2022 12:39:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238483AbiHXQjl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 24 Aug 2022 12:39:41 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7C1C9C8CE
        for <io-uring@vger.kernel.org>; Wed, 24 Aug 2022 09:39:39 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id a9so9074320ilr.12
        for <io-uring@vger.kernel.org>; Wed, 24 Aug 2022 09:39:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=YYuOmDFh7du2x98VE/mOc51jJKR8qw9B+E6i0d7pP4c=;
        b=2osH0E3s2aIGIgpQfUr6UMVnb9OemU/K9P+fKPp15btx/lt4v2xQGvvdHQW/BrGVGo
         xMaOA7imJR1O+dCiuYnf5gCne3/L2zGa8Xb7xIdCupIpBTi6kQfeW+8AwfJV2EKc5Rhg
         R4zzTDc3Qkf+7uFjnDBhpcek2fqlr4Bh06zla4uKHdxai8u45aSjFxipfU8ytsTTDATS
         3Umob1+60IC2+/39kbEisYTeZEvk3QxNCbpDInTa7RgzHsuk+qWbKifk4grBgA1JnACm
         5JPz6Cpq0r3ZrNJyJLnVNfz2SJCP41REAuHUL2D3Em73C9Pe7mHbQ20LH13JPqwipbu6
         fBAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=YYuOmDFh7du2x98VE/mOc51jJKR8qw9B+E6i0d7pP4c=;
        b=VPaVFq2PQX/Na1IzJlESvFbOnV0sZyZBysPk2+GIuHPV7KzYeB6XVH0vQfUTh23V5U
         DhmdZfgwmZKwUm86Ahssen4QGNTDCRkkRTGVWcDB5rnwBz7/voq9d+JYc2oRbw1WW5vB
         THxKpJiGTx2gGiICafTlPIEEeUY1IUbt9m6G/0xRJ/7actgDZgJv+Dac5FKR+V5+7UXP
         F1BqU+msg+bxKskZlRY9YobFzkPsI3jnXPUUy6L2hh8z5qjdsot0BzjyF0oGEoL60d81
         XSWrj0RJU/whXxsaCrC+h3mOdFcnkPxstf9Jbj467lDhkGaBErNy6aABnHJRWkWsuhib
         vvaw==
X-Gm-Message-State: ACgBeo0o0ngXq/5Ga2CA1x6hBI0IWTmI6xKSEoPfJhtfizXnBxbXQBra
        3KRJz9b5XHuH3JDqFtbvEBCHLIQuAYfr3A==
X-Google-Smtp-Source: AA6agR4WxPc6UpX/RJ2bhYh0u8Q+cvbo3acY5MP+3p1XcM8uRlUW1OUyzidoJKCRjfyt1stqUfwAig==
X-Received: by 2002:a92:cf52:0:b0:2e8:7021:6c03 with SMTP id c18-20020a92cf52000000b002e870216c03mr2411659ilr.193.1661359179189;
        Wed, 24 Aug 2022 09:39:39 -0700 (PDT)
Received: from [192.168.1.94] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id p9-20020a022909000000b00349f40c61edsm2026714jap.73.2022.08.24.09.39.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Aug 2022 09:39:38 -0700 (PDT)
Message-ID: <fa23ffc2-755e-7e04-362d-68fad7d69c85@kernel.dk>
Date:   Wed, 24 Aug 2022 10:39:37 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.2
Subject: Re: [syzbot] general protection fault in __io_sync_cancel
Content-Language: en-US
To:     syzbot <syzbot+bf76847df5f7359c9e09@syzkaller.appspotmail.com>,
        asml.silence@gmail.com, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <000000000000e9f4e905e6ff4495@google.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <000000000000e9f4e905e6ff4495@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

#syz test: git://git.kernel.dk/linux-block io_uring-6.0

-- 
Jens Axboe


