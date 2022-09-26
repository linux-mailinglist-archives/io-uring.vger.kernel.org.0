Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B1345EB109
	for <lists+io-uring@lfdr.de>; Mon, 26 Sep 2022 21:14:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229831AbiIZTOg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 26 Sep 2022 15:14:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229829AbiIZTOe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 26 Sep 2022 15:14:34 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A116DEC5;
        Mon, 26 Sep 2022 12:14:32 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id x18so11701952wrm.7;
        Mon, 26 Sep 2022 12:14:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=aHBys9x6LguvpCLHZh+sN2PbgZwoys/B1hh8fK2xfEk=;
        b=ny3La7hux8741k0At8lLaAHtkg10XTxtq8/9fEyGCTOenvWvCja3ots2xrIEG/c5gm
         qWL5S7mtMv2lOjnLJ9M/Mc3uek6tnYBldaLn4cMfvZB4CCkKN8nBJCyHytBRe8E5ZX5z
         EhKNViGXUKaVFW6+fxYTBqfEezF3M3JpeA5en3Vvi/4foxG10q+syhT0RM/K2QzCSzj0
         SCzbNf67t72L66Urj6N2Lr5c1Yw08cqLUDDp2lF4kTVKBo3JKgS+iFXWtCPZ7ezYc7KD
         37KrGiwcbcEemT7gH3v2ghSHxJZ2AsPArCDwQTDERyiXHLdqyXQAOwEzmw38MgThUQWZ
         lsww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=aHBys9x6LguvpCLHZh+sN2PbgZwoys/B1hh8fK2xfEk=;
        b=DQ85ToWEmM7xytq5IXhYCgHlnKBvOrNQJIVkfvHuKIL2knbRKQ/NFoxZAXymOzyl6Z
         jdFZC3ZmKNQzyHewuxazrmfMPZf+H3skzQ6fldSB7+VxZI+JkjVOeG2Xwi6Xs8H/5jAK
         i+Q2UvM7TxL2YRCz8OzbPFw5cKwtPVuDvr4ipuXLB4lE1MMfdxHnfX0jb1msiMufyZ/5
         26xUAZysI2fDKYtB+qbwamWiClHAmALShB2hXH517C7qpoivYYp73de47i1dBdjnWYdj
         9jYdzcCYxeiZErlISMmJmJtyeHn07ta2mG97f9qd3YefJHQ37bWyNAKIl9W1eKFtM5H+
         M0zg==
X-Gm-Message-State: ACrzQf0QAEIrNZOfhK8LVIeecpQaD/xcMKlieBVii45INGRjbliyGtku
        cD+by1fGJ4aZ+wFs7ZEIlKU=
X-Google-Smtp-Source: AMsMyM5s0MLexL5fxrRUslMpnQz8Hspx8BqbkmNrBL0pteJU+N64e8MSn3TfCWwUKxkeP47CgQACFQ==
X-Received: by 2002:adf:d206:0:b0:228:64c1:c3fb with SMTP id j6-20020adfd206000000b0022864c1c3fbmr14370335wrh.260.1664219670735;
        Mon, 26 Sep 2022 12:14:30 -0700 (PDT)
Received: from [192.168.8.100] (94.196.228.157.threembb.co.uk. [94.196.228.157])
        by smtp.gmail.com with ESMTPSA id h6-20020a05600c350600b003b491f99a25sm13205819wmq.22.2022.09.26.12.14.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Sep 2022 12:14:30 -0700 (PDT)
Message-ID: <35d9be6b-89ca-f2a1-ce5f-53e72610db6e@gmail.com>
Date:   Mon, 26 Sep 2022 20:12:57 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH v2 1/3] io_uring: register single issuer task at creation
Content-Language: en-US
To:     Dylan Yudaken <dylany@fb.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-team@fb.com
References: <20220926170927.3309091-1-dylany@fb.com>
 <20220926170927.3309091-2-dylany@fb.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20220926170927.3309091-2-dylany@fb.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/26/22 18:09, Dylan Yudaken wrote:
> Instead of picking the task from the first submitter task, rather use the
> creator task or in the case of disabled (IORING_SETUP_R_DISABLED) the
> enabling task.
> 
> This approach allows a lot of simplification of the logic here. This
> removes init logic from the submission path, which can always be a bit
> confusing, but also removes the need for locking to write (or read) the
> submitter_task.
> 
> Users that want to move a ring before submitting can create the ring
> disabled and then enable it on the submitting task.

I think Dylan briefly mentioned before that it might be a good
idea to task limit registration as well. I can't think of a use
case at the moment but I agree we may find some in the future.


diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 242d896c00f3..60a471e43fd9 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3706,6 +3706,9 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
  	if (WARN_ON_ONCE(percpu_ref_is_dying(&ctx->refs)))
  		return -ENXIO;
  
+	if (ctx->submitter_task && ctx->submitter_task != current)
+		return -EEXIST;
+
  	if (ctx->restricted) {
  		if (opcode >= IORING_REGISTER_LAST)
  			return -EINVAL;


-- 
Pavel Begunkov
