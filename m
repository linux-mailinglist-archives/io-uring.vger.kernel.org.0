Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28C2F67E6FD
	for <lists+io-uring@lfdr.de>; Fri, 27 Jan 2023 14:46:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231641AbjA0NqM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 27 Jan 2023 08:46:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232339AbjA0NqK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 27 Jan 2023 08:46:10 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6E2C77DC1
        for <io-uring@vger.kernel.org>; Fri, 27 Jan 2023 05:46:05 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id e10so3226951pgc.9
        for <io-uring@vger.kernel.org>; Fri, 27 Jan 2023 05:46:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BZ5QMSBTsX5JA82kC9uG3xUNcFe/RgJ5FnAFfHvCMlc=;
        b=SqTio/WuTNbZHvyMILJ42IqZ330NltUw/cBJ+R8ytSUTo5stPpuc5xJVrEqpV9XUyc
         1lUiOGbQJXpkJBt+Au3FQ/K8ci09loQcRT8jScT5WMRABJBT6JxLoFjMJKnfMkyJBJ8A
         b5rRLI19e1jiIwD3lHCAhyZ25fM5VJ7/vTkZaDs2s+iCGnuPiepwjogaODYqr7NHgC/l
         5xuVVHb4ef+RKIlG4+n0rt7sBj7yg8X6ZGwnl2xwNb6JDbpMSXckrWQ3lrIaXZ4CnOSm
         2z7iU6iF36Xe3Fuec2UsUj96TbViw+hQtudX18HzhB8+4uP2ZPYD4/De+QBqEpODZhP6
         XpXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BZ5QMSBTsX5JA82kC9uG3xUNcFe/RgJ5FnAFfHvCMlc=;
        b=QN6UP+Sf2gnvuhIN5qsZM3zAd8V42QCCgGVDZdGCXjtkPMN4yICijfgfa1rYyCbFQ5
         LkLSaKb0gUYxFN5u2tHOjGJvVsbfcBkAkonuC//gVtdcmCqN+U7fI7gxvxP7aCjAkMEH
         ZoU6jjBmd/XMRA/jOn2hHojxjx4HbmLKKA9PyF1LpUAwjp+9fLj9av+A0xxzh5OlHWR2
         B9YgxqDfJzAYq7gZkASDz0SjNu09HMrKIa/PLa3qyboDP+G8o5/mxfpj5c9L5J1zfQqE
         CkYbsqwy5kBcO8ZOhg7XB5NOVyMK4kk+Z4SEAtRlHKF2AO8oZh/O10jzN1Qsw1DEDQMf
         Rrvw==
X-Gm-Message-State: AO0yUKWGoKalSn5WN3ef6m8xJ+Jc7lSr4SILUW1jZ4inYyhkP5J88kBB
        didj/VUwqdYk9QWZEzlPTiRO5A==
X-Google-Smtp-Source: AK7set98AbTj6Z8aab1sh+RdUeSX1Fs3jDhNWiujEC0micctZsXBVFyHAk5CS01aY3+kJGEvTx++jg==
X-Received: by 2002:aa7:97a3:0:b0:590:761e:6dc9 with SMTP id d3-20020aa797a3000000b00590761e6dc9mr1609868pfq.1.1674827165079;
        Fri, 27 Jan 2023 05:46:05 -0800 (PST)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id b25-20020a056a0002d900b0058bbe1240easm2602912pft.190.2023.01.27.05.46.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Jan 2023 05:46:04 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Dylan Yudaken <dylany@meta.com>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com
In-Reply-To: <20230127111133.2551653-1-dylany@meta.com>
References: <20230127111133.2551653-1-dylany@meta.com>
Subject: Re: [PATCH liburing 0/2] liburing: patches for drain bug
Message-Id: <167482716378.273660.1586438495902646606.b4-ty@kernel.dk>
Date:   Fri, 27 Jan 2023 06:46:03 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12.0
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On Fri, 27 Jan 2023 03:11:31 -0800, Dylan Yudaken wrote:
> Two patches for the drain bug I just sent a patch for.  Patch 1 definitely
> fails, but patch 2 I am sending just in case as it exercises some more
> code paths.
> 
> Dylan Yudaken (2): add a test using drain with IORING_SETUP_DEFER_TASKRUN
>   run link_drain test with defer_taskrun too
> 
> [...]

Applied, thanks!

[1/2] add a test using drain with IORING_SETUP_DEFER_TASKRUN
      (no commit info)
[2/2] run link_drain test with defer_taskrun too
      (no commit info)

Best regards,
-- 
Jens Axboe



