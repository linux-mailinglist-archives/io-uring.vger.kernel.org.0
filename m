Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31EDE4BFF76
	for <lists+io-uring@lfdr.de>; Tue, 22 Feb 2022 17:57:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234428AbiBVQ6M (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 22 Feb 2022 11:58:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234429AbiBVQ6I (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 22 Feb 2022 11:58:08 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A4E116C4C8
        for <io-uring@vger.kernel.org>; Tue, 22 Feb 2022 08:57:42 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id h125so17532033pgc.3
        for <io-uring@vger.kernel.org>; Tue, 22 Feb 2022 08:57:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=fGtVA4v2Imgtv+1DAzHyalIW1BRpOdPrTLMvDsJj4MU=;
        b=SSixR/HaP0Qk8BX5aLvr68m7DPIp6CsFQ6B7QkqF/hnhUYQsF1GK7qsC42J3qMb2+k
         8O2CnrQk6UWeF5YNhizeRdMWNiVbStL1s4hE9V3CL9y2gKrfcLsMM43Yc1rqcqWjKHui
         1TOxcRNZC9Nc1firsYFfhNhQN9PUUQgr1pEdDZssGLvhm9SS3xH++n7NPN/YnSZHCtVt
         Ehect0uFpWgJZlYnYrjn25wW7/zQPQcp9xt42hePh7F9bTpyRsWFPo8WU1LBv4K6OF48
         PA0KD+XQ4pxp4BbF85EPzguj3aOE3FyoQmz9C0ZQi/mytPVSZEHBNURXBqtR/j04EFFK
         rE8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=fGtVA4v2Imgtv+1DAzHyalIW1BRpOdPrTLMvDsJj4MU=;
        b=XiX+54GVF5zwvCWxqG00FrJlzZamf/EgN17g9ZdNxibtUY4yVx7ZYspXJFuMuBrds4
         AKJaqHCUlgMjjf6SF16IalrJjVy7itw+K66P/qEm51VLUGmwJolkngQhz23bQTyrurNC
         leroU9sfOMwytJTGczNwmZ7KkJpFVE/OehfJt95jy0CuVVv/MVmAztleMDL2il3IS2KJ
         g7gCrs+Xl7R60iUb4MpWF3XTIoHgPV3kePlPU4AClSABB5ueidIUF3CJtdhdT6imOqD9
         CogTsrAKgl/CmWqNR+16lj0Z2waEv6qc6P9xRjnAcLUNVymxmO39f4WP6ctokZkHSdTe
         9++w==
X-Gm-Message-State: AOAM5320nSi591qpgoIrsyrDqEQ5bIStYDpd+Ana7QWR+DBCITC2WqH2
        xUkF+ND3CSfk8W36kxO64g9YYA==
X-Google-Smtp-Source: ABdhPJyiI06PlMZS/ButWJUgzp+2oRjoNdh0QpkVp3KsMIXFeGADbGkzDjOTaLyMBMH6S0fcK0RjwQ==
X-Received: by 2002:a63:eb0c:0:b0:373:334d:c32f with SMTP id t12-20020a63eb0c000000b00373334dc32fmr20653745pgh.358.1645549061451;
        Tue, 22 Feb 2022 08:57:41 -0800 (PST)
Received: from [127.0.1.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id g14sm13699237pfj.80.2022.02.22.08.57.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Feb 2022 08:57:41 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     Dylan Yudaken <dylany@fb.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org
Cc:     syzbot+ca8bf833622a1662745b@syzkaller.appspotmail.com,
        kernel-team@fb.com
In-Reply-To: <20220222161751.995746-1-dylany@fb.com>
References: <20220222161751.995746-1-dylany@fb.com>
Subject: Re: [PATCH] io_uring: disallow modification of rsrc_data during quiesce
Message-Id: <164554906047.78915.7213616400125153126.b4-ty@kernel.dk>
Date:   Tue, 22 Feb 2022 09:57:40 -0700
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

On Tue, 22 Feb 2022 08:17:51 -0800, Dylan Yudaken wrote:
> io_rsrc_ref_quiesce will unlock the uring while it waits for references to
> the io_rsrc_data to be killed.
> There are other places to the data that might add references to data via
> calls to io_rsrc_node_switch.
> There is a race condition where this reference can be added after the
> completion has been signalled. At this point the io_rsrc_ref_quiesce call
> will wake up and relock the uring, assuming the data is unused and can be
> freed - although it is actually being used.
> 
> [...]

Applied, thanks!

[1/1] io_uring: disallow modification of rsrc_data during quiesce
      commit: 80912cef18f16f8fe59d1fb9548d4364342be360

Best regards,
-- 
Jens Axboe


