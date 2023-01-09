Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5341662928
	for <lists+io-uring@lfdr.de>; Mon,  9 Jan 2023 15:58:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230487AbjAIO6W (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 Jan 2023 09:58:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229979AbjAIO6V (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 Jan 2023 09:58:21 -0500
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ECD71582C
        for <io-uring@vger.kernel.org>; Mon,  9 Jan 2023 06:58:19 -0800 (PST)
Received: by mail-io1-xd36.google.com with SMTP id h6so4600395iof.9
        for <io-uring@vger.kernel.org>; Mon, 09 Jan 2023 06:58:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Q/4wk+jR1ilnOhlUaGH75lGZX0qYzLDVs/Vv8i0phPI=;
        b=s5HPN1JFNtKS/5CZV7SlnMV76YShjUT++A0OglSyRQJbRVMIT9Qt4tINnxtP4zyIlt
         Q2ndDbx+o6ZFYtxzUIZX3JyX+Le8nceniE6keGv2IgYg26Agi+qg0tecGygDt4ti5TKo
         7apGLnepJOW70hgFUtcNyHftU9ERpdMuj7hFxaks2pwLVzLkNq4rZPtyoGcKY/cRx4vB
         kNbVibDFhmumddzJlWDXmFLWEAlN3vjggnPSTzcNz+XMZMdEQzUi8vuccvygG+FZzltE
         55cqPcSmCDqg3iB6cImlNIE56+cdhHp+lfzYegaFwstI6TQZjiiuw67YWxjULI6SbDpy
         ZFEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Q/4wk+jR1ilnOhlUaGH75lGZX0qYzLDVs/Vv8i0phPI=;
        b=Pn4tL68Lj6ib759u5jNCJENSHR3FeEGTa0HWhhDqcTuoQYbWeEDXM2c2Oi4QqS37kA
         UenvHGw53ke3pxN8FI5Vj3OHyCWtKJDxWOiVOVLzHAvK2vwAHrT0lKg8qvL3TP1JeF2i
         144aTc1wU4zkflJQhyQolEa8QiGVbC1Q5SUm0I8AXZcflcvn96Jhf+1gsbafyg+g1Nrc
         +5+PxjOdk+EeNxotLijqbNuBPROWRRE2s2howpI+jP2BerWowfLq5e9w45H3HaONeZC7
         WmP2N4WxS4mXx4ueEcsloCSs2SGOejdef+yDErfQD4htHbz5ywTbyE0e09VPK/jsCdig
         PkoA==
X-Gm-Message-State: AFqh2kpsBy3DgTEQ/VMpt+L2qA67sLJkkSi14JtxzysKbC0J6Z1M2fg9
        1eYiV31bjXvcR0xq3pbieRdavX6azQQtDU2Q
X-Google-Smtp-Source: AMrXdXvJVljFGmkhi8SC+lZ+EoTZhZ60ykQkylPLI8f6NemT8/1GGxbqYBrA9ZhB/t7XGASeQ92hjg==
X-Received: by 2002:a6b:7d46:0:b0:6ed:1ad7:56bc with SMTP id d6-20020a6b7d46000000b006ed1ad756bcmr9660532ioq.0.1673276298565;
        Mon, 09 Jan 2023 06:58:18 -0800 (PST)
Received: from [192.168.1.94] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id z1-20020a027a41000000b003760a908bfasm2886388jad.169.2023.01.09.06.58.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Jan 2023 06:58:18 -0800 (PST)
Message-ID: <da9e7c64-2187-5dfd-8d20-4d544778a109@kernel.dk>
Date:   Mon, 9 Jan 2023 07:58:14 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [syzbot] KASAN: use-after-free Read in io_wq_worker_wake
To:     syzbot <syzbot+b3ba2408ce0c74bb9230@syzkaller.appspotmail.com>,
        asml.silence@gmail.com, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <000000000000f0fb6005f1cfc17f@google.com>
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <000000000000f0fb6005f1cfc17f@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

#syz test: git://git.kernel.dk/linux.git syztest 

-- 
Jens Axboe


