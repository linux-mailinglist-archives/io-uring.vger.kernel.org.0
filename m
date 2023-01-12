Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B482667D9B
	for <lists+io-uring@lfdr.de>; Thu, 12 Jan 2023 19:14:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231510AbjALSO0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 12 Jan 2023 13:14:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231146AbjALSNH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 12 Jan 2023 13:13:07 -0500
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 926BF13F11
        for <io-uring@vger.kernel.org>; Thu, 12 Jan 2023 09:42:13 -0800 (PST)
Received: by mail-il1-x129.google.com with SMTP id x6so5078316ill.10
        for <io-uring@vger.kernel.org>; Thu, 12 Jan 2023 09:42:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ic525rXDlsIcYaYZrzF97zBUlA+fwY1XOx9tK8OUiXE=;
        b=6pwo3MIKdkn3mwpS+FdO56+9VLFENdNpbZSXeXh5IIu2O/vycKPIDZVkN2SBTsMXh0
         VCBJmpgbH7aWgl17CDf0SeE13lQ5YOq6mDz88ZPM5TN5B59iwjUwDGHIaBj4c6HR+7Rf
         rDZIjY2W5uP/zoaLVQRhJwMbEUQ631s/vZOcw39dbZ+wjnAJG57+2weWAC8RqwHlK94T
         ed8vmoKReMdZE43b+wdzLvzJySRYHFklc27ydmHvnIbfN+HCbnCOgDfBTc7QPfvAF8kn
         4bt3YgKdf0mjYPOCbVlsUZd/7A+oEVeV0BO4T7uL7AsLZlDNJHbkbgIzK/Uh63Z/2+D6
         k8UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ic525rXDlsIcYaYZrzF97zBUlA+fwY1XOx9tK8OUiXE=;
        b=rZGKTTvF9pLVariCIVsiaJv8ZSpxdj0qJdvNoccDhGnKO8HkFbMrWfMNXPJANY0Bfw
         oquJmURToedX1tE1+VNNXoq1uL1L3qlzCH7iEq0jFha4rAs6gMEhlWnw9q5qljo19LUU
         9U0vzJngfniXun8YbNljoiJrYBytiG+scAIFXKM3wfn9Mf4fzKIBTNpUtPUOjVe2SlX1
         bN9U29RFcmxgV2Bjpiw50v0zc1jHP+ng4JhKlDfNeylNN9RimzC5oEEEDANkHAnXIUrQ
         YHxQjevjludiz6orA0ReOaHvUA1wcm8TPoqqpaLmjfs3nj1BPrrl3dDqtfo1zFIrV7oY
         Dl9g==
X-Gm-Message-State: AFqh2kpInG8eVJ/XjkGt29vs2qUyNXmJRb7QESnSGSRgaUi3V3f66OCa
        rS7vPeviqVR+FciRFXEm1roOBg==
X-Google-Smtp-Source: AMrXdXusMZKVRfz+I0FiNbs0ZgbJ4zYih2HKLbVkBZNu1hxLLEYSbjyuWVm3c/0AHzQXRcni+NMsGQ==
X-Received: by 2002:a92:1306:0:b0:30c:4991:2eac with SMTP id 6-20020a921306000000b0030c49912eacmr6091790ilt.0.1673545332885;
        Thu, 12 Jan 2023 09:42:12 -0800 (PST)
Received: from [192.168.1.94] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id c40-20020a023b28000000b0039d7e61f819sm5489571jaa.117.2023.01.12.09.42.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Jan 2023 09:42:12 -0800 (PST)
Message-ID: <d4f4556c-11ac-7533-f047-cdcfda9bddf8@kernel.dk>
Date:   Thu, 12 Jan 2023 10:42:11 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [syzbot] KASAN: use-after-free Read in io_fallback_tw
Content-Language: en-US
To:     syzbot <syzbot+ebcc33c1e81093c9224f@syzkaller.appspotmail.com>,
        asml.silence@gmail.com, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <0000000000005a33e305f212b7f3@google.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <0000000000005a33e305f212b7f3@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/12/23 8:24 AM, syzbot wrote:
> syzbot has found a reproducer for the following issue on:
> 
> HEAD commit:    0a093b2893c7 Add linux-next specific files for 20230112
> git tree:       linux-next
> console+strace: https://syzkaller.appspot.com/x/log.txt?x=14b3995a480000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=835f3591019836d5
> dashboard link: https://syzkaller.appspot.com/bug?extid=ebcc33c1e81093c9224f
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11613181480000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=101a000e480000

#syz test: git://git.kernel.dk/linux.git for-next

-- 
Jens Axboe


