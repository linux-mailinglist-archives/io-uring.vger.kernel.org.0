Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B58A06A0197
	for <lists+io-uring@lfdr.de>; Thu, 23 Feb 2023 04:46:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231962AbjBWDqI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 22 Feb 2023 22:46:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjBWDqH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 22 Feb 2023 22:46:07 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 883A1457D7
        for <io-uring@vger.kernel.org>; Wed, 22 Feb 2023 19:46:06 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id e5so12392488plg.8
        for <io-uring@vger.kernel.org>; Wed, 22 Feb 2023 19:46:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LsgXVTuZ5gs8wY39tz46RZqNBvlD333pgaPRJ3xqlZg=;
        b=qlC+p2Rdq3pYGwEVGIAMHRp3nzx64w5WuzpwaQfLOLpRkoPzRCOYdyfUOq6/I7DelG
         2OuJexCcdH0gupdMgYyxe02V8tzeasqGpUoHSps+8ooCW85Lu3iF+wEt0x6Yn6N5R3Lb
         Tyk/Y8zHBqggc76GNRIQ8ayKorAX90lzJbRARYXqT88JsLBYqVFgIt5+cbQeYy8MvKs7
         B6XF4nMVJnysxWOznRoobyoOL+Lr1iJaS2B3n82mQ3s/eF2biuwWorDk0cBG0Kv1my+O
         JknoUcI947WvqidBV04HOwEIwUYkmqIUdyywmEiv9PrJ+2mi7Zn+rz76exdAJIscEvfi
         Gl8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LsgXVTuZ5gs8wY39tz46RZqNBvlD333pgaPRJ3xqlZg=;
        b=dzMWfk6yIOlModyvHQGdPP0nOKGWnj9lqbJL2d/1el5sgFKu8KPVXf9NowIXAn2r+7
         YmTGzVmc7PFNJq6BSr0o4VofqaUJJ/9mYPNOM2mKBqBtQgDRgMGF0ga35NDDr+5QB2ss
         gWZLUGqFLT7XRSB8EDnqpVYdwIwCPGJSc8N1ZNZf/LgbGLKYJ3I7mWnIZk9MSPU6BMXv
         jgf/QwdMpe5BCjlLwjc5aLdvLlRNUAIhsBNy5rDzsre1OzfQNiT2gQDseXC+ru1VDZWD
         IwXYZ5h0i/dTrQ9kNSO0poN8Jzkth3+DnggG4Wmm8m43bIBTuAcyeb2xsQ0DSr9sCru9
         bhvA==
X-Gm-Message-State: AO0yUKXnEmJ+R0usis9BpkikTxEr9WqoVn30miTedN4cJyanxxdtEUm/
        Odu7Wj/BM1CtNNeuqF8zr50LOw==
X-Google-Smtp-Source: AK7set9ok2v/n765ixz4FIIK/4MnZhyIh/0UbCdNki1gtDZ8OHx9TQFlgU2Nztf+yyJzSfLGf8Lb2w==
X-Received: by 2002:a05:6a21:3399:b0:c7:6a98:5bd9 with SMTP id yy25-20020a056a21339900b000c76a985bd9mr13844647pzb.3.1677123965911;
        Wed, 22 Feb 2023 19:46:05 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id x24-20020a63db58000000b004fb71d96d78sm5558269pgi.2.2023.02.22.19.46.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Feb 2023 19:46:05 -0800 (PST)
Message-ID: <55a01e39-c28c-dde0-172c-feee378c2f74@kernel.dk>
Date:   Wed, 22 Feb 2023 20:46:04 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: [PATCH tools/io_uring] tools/io_uring: correctly set "ret" for
 sq_poll case
To:     Ziyang Zhang <ZiyangZhang@linux.alibaba.com>,
        asml.silence@gmail.com
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230221073736.628851-1-ZiyangZhang@linux.alibaba.com>
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230221073736.628851-1-ZiyangZhang@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/21/23 12:37?AM, Ziyang Zhang wrote:
> For sq_poll case, "ret" is not initialized or cleared/set. In this way,
> output of this test program is incorrect and we can not even stop this
> program by pressing CTRL-C.
> 
> Reset "ret" to zero in each submission/completion round, and assign
> "ret" to "this_reap".

Can you check if this issue also exists in the fio copy of this, which
is t/io_uring.c in:

git://git.kernel.dk/fio

The copy in the kernel is pretty outdated at this point, and should
probably get removed. But if the bug is in the above main version, then
we should fix it there and then ponder if we want to remove the one in
the kernel or just get it updated to match the upstream version.

-- 
Jens Axboe

