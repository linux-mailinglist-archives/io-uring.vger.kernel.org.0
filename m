Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 849265047E7
	for <lists+io-uring@lfdr.de>; Sun, 17 Apr 2022 15:37:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233866AbiDQNaC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 17 Apr 2022 09:30:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234163AbiDQNaB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 17 Apr 2022 09:30:01 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 959651099
        for <io-uring@vger.kernel.org>; Sun, 17 Apr 2022 06:27:25 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id s14-20020a17090a880e00b001caaf6d3dd1so15263746pjn.3
        for <io-uring@vger.kernel.org>; Sun, 17 Apr 2022 06:27:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=2lsv0ntY4n+MI/Hd3e+PEhNvyJ29+Oq+Iyeq2UXcg+Q=;
        b=yELFNctQNh8f9kq818ppMkx1U+LhZFvvzoNJBrgFCYj8wM16rEoGsJERr95ZJLzq67
         1ppvMprwsyYqIMq88GVAAKx+l9cXpeWFkYNrgJACHo738WLr9MvgBrqaMXoAtKaHVAv/
         IIyG/vuxcQOAdSnKZoCqCyU4HC/+W9exGvPxAg4/zv1MuxwWTzbuvFoC27VrsGqbz4io
         LWmnXaHFVLtxgb10txwAhlwxqQ2vbbG62p8UDzHtDUyM2Ib21uY7g/BJaTbY4AC3ilSW
         RoSvsasdkeYR0KwSisIFoIz2a1/yPOF9Vd20W6/9YgWyaABfpGDhr5mCu/lBrZfcPkpv
         gwQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=2lsv0ntY4n+MI/Hd3e+PEhNvyJ29+Oq+Iyeq2UXcg+Q=;
        b=BDArlLUHpuwuGBFgYpR2cdG8PC+sWqL1hIuf4naxrp81J4pZ37IlASJ9XkdRd/mtok
         xVlw0yt2cVAyIDi97UwpkTeqfnmsaPLEWYWE9UpxomlEVlwzezGmfssxGRJ1oRWx/iPN
         JxczzT90aCfWh4nN8D1p5rLiZZ8j27xtRLbVxpwt2iQfnbIp/vHCgnZjKCbyED4quknM
         8QLQnuYEMYtIN9kgRuglNwvMpOIpqeqYlzZxIv0Jxewk/gC5LpBcxfTIrjpPGw477kRu
         OWXom0um8MVHs7iUudX0+C/inB/XUkReeF14tek/TU1r4Pu/MsHBm+CFeni1UA+hTW7m
         mk/Q==
X-Gm-Message-State: AOAM531ZP368Lw9VBIxTHjfHWqxhng0IfzV/4XKu8Y6YCqwk0tvg3Kr3
        NHdOicAQZBTfyT8NO7Ok/1a1BA==
X-Google-Smtp-Source: ABdhPJw1y3DOoUi6NRe3MQxj9rsC0yTa3f5ata6PXmG6W714zzk2jMCcR08ZklwR9kHaadkF/2yXWQ==
X-Received: by 2002:a17:902:8698:b0:158:99d4:6256 with SMTP id g24-20020a170902869800b0015899d46256mr7144705plo.104.1650202044452;
        Sun, 17 Apr 2022 06:27:24 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id s35-20020a17090a2f2600b001cd67e544e4sm10193811pjd.2.2022.04.17.06.27.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 17 Apr 2022 06:27:23 -0700 (PDT)
Message-ID: <6ab618f8-f88b-0771-a739-04cd9cdc1a3c@kernel.dk>
Date:   Sun, 17 Apr 2022 07:27:22 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [syzbot] memory leak in iovec_from_user
Content-Language: en-US
To:     syzbot <syzbot+96b43810dfe9c3bb95ed@syzkaller.appspotmail.com>,
        asml.silence@gmail.com, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <000000000000951a1505dccf8b73@google.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <000000000000951a1505dccf8b73@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

#syz test: git://git.kernel.dk/linux-block io_uring-5.18

-- 
Jens Axboe

