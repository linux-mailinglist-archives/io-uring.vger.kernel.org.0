Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A983626A5F
	for <lists+io-uring@lfdr.de>; Sat, 12 Nov 2022 17:00:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230447AbiKLQAd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 12 Nov 2022 11:00:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230257AbiKLQAc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 12 Nov 2022 11:00:32 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EEF013DFB
        for <io-uring@vger.kernel.org>; Sat, 12 Nov 2022 08:00:31 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id v3so6700680pgh.4
        for <io-uring@vger.kernel.org>; Sat, 12 Nov 2022 08:00:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0feAgfD67gdhLi22lYYT+MnadL3HyaKN/JV5g+vrsVY=;
        b=Au+Wlq/oHGQzxnonnsllF68+W07wKiEJ0FBms7QqjN20KKsSeE6YwZew5N3yotrvX5
         bNQaqJ0/LYvZ/d1Rhp43YMLRJysZXgXyLVyWsxmjSx98zE5dZ2tM/lJPmiSxQS8WDOnM
         E70Zw8PEa4Jbx1feiGMzNhjn64c7OZswkrDvCbybUbOR/hUyMB49xSE3mHzhjZiX15u3
         JczA9Dze4fsDsdjUNYitito9jPOLmrUDi0WAM6HKyKGseqiCKhCAMbubXHYzEYHQ5xnz
         0hMWoKluewZGBw+/sMf6MckMocS3xtpAJTxLc7kRcsrRMZQJnSPaY/rDDCwHt7/TCSFv
         fc5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0feAgfD67gdhLi22lYYT+MnadL3HyaKN/JV5g+vrsVY=;
        b=qio/kRJtUZ5uxljzntSbe+0mgXrVCNfOZwWKve11vYu/FZXjOBedFgfJ3MuIq9NfKt
         FdDg+1g2HJLZKORIAC+ljYdmePL4Dwod8w9LvTTvZO+RGS15uYD11ui741uu1rmtd5p4
         8EtsnSBvo61PAdN5eycc+DC4P7NGBoUhTgdrhB5S4sFzjS6vZ3qvuxD3WdspluViT/Ol
         k9RMDGxYx5tpeIBnZAxBogKWu74jJbN4oI2qa9e1GThHIFMlMjTb7CNoY6lUPJeBc4Fg
         ynDp7vACbcdEEd4/bQo6ungQVf4Qv6KWjDKhvt1vh7F8ukCSixoPL63pn8w5dyaz0Zm8
         zwWw==
X-Gm-Message-State: ANoB5pmApigW/cu1MW21dfG6IIwqwMokh1vjtySrgSo/vIGuV97XLGnn
        sOctU7C7B/6YT1tuSAMCulJRcWBFt35krA==
X-Google-Smtp-Source: AA0mqf4FHtxS1h0a7gnIzPdwhkeVNpDeyOnaTl2GtRTmAPKgCwHG1yUNfu7dKFZXPYGdn3RETaqoGw==
X-Received: by 2002:aa7:9011:0:b0:561:c295:7568 with SMTP id m17-20020aa79011000000b00561c2957568mr7262727pfo.35.1668268830633;
        Sat, 12 Nov 2022 08:00:30 -0800 (PST)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id p4-20020a622904000000b0056d73ef41fdsm3471141pfp.75.2022.11.12.08.00.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Nov 2022 08:00:29 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cover.1668162751.git.asml.silence@gmail.com>
References: <cover.1668162751.git.asml.silence@gmail.com>
Subject: Re: [PATCH for-next 0/2] small tw add improvements
Message-Id: <166826882960.6274.15659185946887455040.b4-ty@kernel.dk>
Date:   Sat, 12 Nov 2022 09:00:29 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailer: b4 0.11.0-dev-d9ed3
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, 11 Nov 2022 16:54:07 +0000, Pavel Begunkov wrote:
> Fiddle with inlining of task_work add so the compiler generates more
> concise and efficient code.
> 
> Pavel Begunkov (2):
>   io_uring: inline io_req_task_work_add()
>   io_uring: split tw fallback into a function
> 
> [...]

Applied, thanks!

[1/2] io_uring: inline io_req_task_work_add()
      commit: 912f3f541dd8fb9e987e4bef0f2466b5233ec480
[2/2] io_uring: split tw fallback into a function
      commit: 79fde04791f9a6789ff1a9b90b06e754efb55bd7

Best regards,
-- 
Jens Axboe


