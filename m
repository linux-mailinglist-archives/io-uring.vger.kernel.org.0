Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC7F8653399
	for <lists+io-uring@lfdr.de>; Wed, 21 Dec 2022 16:44:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230264AbiLUPop (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 21 Dec 2022 10:44:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229814AbiLUPon (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 21 Dec 2022 10:44:43 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7322F6168
        for <io-uring@vger.kernel.org>; Wed, 21 Dec 2022 07:44:42 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id o8-20020a17090a9f8800b00223de0364beso2677939pjp.4
        for <io-uring@vger.kernel.org>; Wed, 21 Dec 2022 07:44:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UZBFIqT10H+4UsayRiUEr9+GQIHOydECslxG/sJlSmw=;
        b=3HNbaurNAkTYR1KCD2VvPneuM3GJ2mdEHl1Bw3SqP94M6L8NabiSawtp1B+yTb6PpV
         7E7Xwd2FMVuxNS1mjjdh+7UzxKEe5v9sjYJnf1cxBnV4vgzH5ddkVMt+ZdYEEgTLRfko
         plz8mOP/nI1tdzk+xITX72tQOsg0sGx8We5s7QQoGXRj4CTMP50NphCcyk1s9hnJA7tH
         YiGuo/P7i4YEo3RUbhFbziayeuR5xH+ouM6irRl3JV35hJzeVTKumtAQaldO/KiPOrop
         nFxfidcBz/HVgOuO+t4DjNHnfNeg7RdkCDYfZZrrdy+O+jenHohgYAJnA9jYfIivG9A9
         ThtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UZBFIqT10H+4UsayRiUEr9+GQIHOydECslxG/sJlSmw=;
        b=7cjwZNRAy/K7tz3q6n1lfyRK7qaZ1dc0cttLkszHX3tubMyouw+z2vzg9SHRHTOYW2
         HdRFrU+v3d0qfejnIp6QqqU1U4J0enrVmiDFe7AKe5T7f85l6gU3ZhbiP2qh2D1bCS6+
         JLe8Kt/pPa9BXI5wOUGnjxBbyboZgSlFZUAIafnt+ax4X28/LAL+y2AgJnUFbCzO+sJE
         ifo4YYENxGex5uy/UTLGWJkkIGRySl5gZ/DYMpqkfnDnZMkOuVZZ9XUV0nPXSdrFXci3
         rjn+UeKNDE7YcBVk+lHOsPpzM1K6ITBZolOVTh5lm9Rd0NTD1QsCqj8F80k6eChWmkaM
         qrVg==
X-Gm-Message-State: AFqh2ko0ZDBK38cd7Tga6fFdWwMyrtRi0wtLBaBMf7lDIQ0qLrtftzIq
        7ENkincqNSzBl6NfHlrRqjbHCQ==
X-Google-Smtp-Source: AMrXdXtDYhES3XntKcIT5CzNq2CaOgU5xgI4oqyb0N1mgaTOjEWbRaxIHgW4R0BikSsie2GP6NYamQ==
X-Received: by 2002:a17:902:8644:b0:189:b74f:46ad with SMTP id y4-20020a170902864400b00189b74f46admr575210plt.3.1671637481784;
        Wed, 21 Dec 2022 07:44:41 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id k15-20020a170902c40f00b001869b988d93sm11649622plk.187.2022.12.21.07.44.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Dec 2022 07:44:41 -0800 (PST)
Message-ID: <7c89b1c8-f012-3965-ab77-3bc19b3cedaa@kernel.dk>
Date:   Wed, 21 Dec 2022 08:44:40 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [syzbot] WARNING in io_sync_cancel
Content-Language: en-US
To:     syzbot <syzbot+7df055631cd1be4586fd@syzkaller.appspotmail.com>,
        asml.silence@gmail.com, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <00000000000069608005f0580c52@google.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <00000000000069608005f0580c52@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/21/22 8:17 AM, syzbot wrote:
> Hello,
> 
> syzbot has tested the proposed patch but the reproducer is still triggering an issue:
> INFO: rcu detected stall in corrupted
> 
> rcu: INFO: rcu_preempt detected expedited stalls on CPUs/tasks: { P5788 } 2646 jiffies s: 2841 root: 0x0/T
> rcu: blocking rcu_node structures (internal RCU debug):

#syz test: git://git.kernel.dk/linux.git io_uring-6.2

-- 
Jens Axboe


