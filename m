Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5039E5138B1
	for <lists+io-uring@lfdr.de>; Thu, 28 Apr 2022 17:41:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348684AbiD1PnJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 28 Apr 2022 11:43:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349432AbiD1Pm6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 28 Apr 2022 11:42:58 -0400
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E380B8204
        for <io-uring@vger.kernel.org>; Thu, 28 Apr 2022 08:39:34 -0700 (PDT)
Received: by mail-il1-x130.google.com with SMTP id e1so2228122ile.2
        for <io-uring@vger.kernel.org>; Thu, 28 Apr 2022 08:39:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=OTiwe2B8rcUTI1j/SK3IzHaXYBhsCj6uIQbvt9mJoW8=;
        b=ipfJ7mfMBx1Gh7S27tOSuhiVa4tGtVpllk6Wp5RAxvOy62JewaAVekq9L7hm3Rw4Dz
         CXzsm9JZz/m5595XdVfjTk1u/u53HX2rbqoGiwpAJ0yH3l+ppPrfg6w+07ZoOCCt8y0B
         SjumJbNHwlEv2zNZmCR2hHbghukJqeDZtbDGqclEHxfmJ8diXalU9JjDQZ3/PhWz9UIT
         SNOvc0+zcKpNV5BKUQLpjoi6wjRd5FXZIG1VGxNe+/VQTEDSv36gbBAybf5N3vAW3SN0
         7YTIjH4j7hb/++l/0QN9k6hGAGczcQguvm5tkgsUCuk12wxDejfjV/U9kMjcVMuneh6z
         gIdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=OTiwe2B8rcUTI1j/SK3IzHaXYBhsCj6uIQbvt9mJoW8=;
        b=r0FtQsbA9dEs/PbgY0udXY04E3As6CWZsuT6BmwrfS5iO4LvDsvrvhf95FXmS7v1Xd
         WqUhrQ5zgMImz7vWeBlPfMmuQKDIGHL1UTU3I/q9rZ4sHN8uhzRwRn4gl/WRaY5MXzWv
         wvgBgE7XEWzQ2ujSQkciKLRe16ilqtr5Mf0z81LXzpICYxf6xPf3vbmCl612MZo0dKoa
         0ARs5UVbnhBgX1S6rzsGJvyj41V4QBA+a9sbOykWm6vWErpn8lnTijXQmrG5bQhyvwYx
         fokglp3MDurSxnHe3HMkpJVPJeI2LMjylr0GYe5Pk2NjXEbQSOauI6c/aEOdh9CGry0f
         C9SA==
X-Gm-Message-State: AOAM531LwzBBxdbqGewbh2G8KSkyYf5N2K3kyHZnpF/iIGVW3qkNowV9
        0HBhs2xb5/QxOVH/Y+GTQjrJgw==
X-Google-Smtp-Source: ABdhPJwoRg8obuWEqLY+gYStieJPIHXgUsTUSpgt9B5G+awAdRdZhGFqY8ZPjyjvL7QqNgZHMMsaIw==
X-Received: by 2002:a92:c54b:0:b0:2cc:3de1:ae5b with SMTP id a11-20020a92c54b000000b002cc3de1ae5bmr13217754ilj.288.1651160373684;
        Thu, 28 Apr 2022 08:39:33 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id u1-20020a056e02080100b002cd6b0e772dsm110390ilm.45.2022.04.28.08.39.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Apr 2022 08:39:33 -0700 (PDT)
Message-ID: <001823d5-13cb-1b03-9ffa-686081123d08@kernel.dk>
Date:   Thu, 28 Apr 2022 09:39:31 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [syzbot] KASAN: use-after-free Read in add_wait_queue
Content-Language: en-US
To:     syzbot <syzbot+950cee6d91e62329be2c@syzkaller.appspotmail.com>,
        asml.silence@gmail.com, gregkh@linuxfoundation.org,
        io-uring@vger.kernel.org, jirislaby@kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <000000000000765a6105ddb8a8b9@google.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <000000000000765a6105ddb8a8b9@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SORTED_RECIPS,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

#syz fix: io_uring: fix assuming triggered poll waitqueue is the single poll

-- 
Jens Axboe

