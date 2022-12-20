Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D14F9651A8D
	for <lists+io-uring@lfdr.de>; Tue, 20 Dec 2022 07:10:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232678AbiLTGJc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 20 Dec 2022 01:09:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229769AbiLTGJb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 20 Dec 2022 01:09:31 -0500
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A52B026EC
        for <io-uring@vger.kernel.org>; Mon, 19 Dec 2022 22:09:29 -0800 (PST)
Received: by mail-ej1-x644.google.com with SMTP id t17so26855060eju.1
        for <io-uring@vger.kernel.org>; Mon, 19 Dec 2022 22:09:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eZx+l47CzuZ3xlEKU80E40CSh3ZgdwDHh7dVN/b5kRo=;
        b=UlISU/fKRQ1Hz+/V0lJ7TuZ/t0ZRVZiQEAxiciy8BUiFUm27wD3kYRRAWKv2v5SmoD
         wVU9b3M9IArce+Nr9KWIyGjIu2QR3Z9G5KO4cf0ptEhTwiYXhXUwPCyigNyLPbgrawhl
         hZJeu29S8zU/+uinFRTAJmIXPq7lAdtA/wnpWNiazkp6NqgYaY0MxqMQdoqDWaXxrB9o
         XhOHho1u/Y+5xAuED57LpuuiDNKJAfga0qZw5VBvowQF98RSSSf2BqmVC7R4CLsm/fvb
         P3evxRRyShqzU+vTujMcy97mi9nTvvvUQAKGhLUeN6XKtEXcU9e3VXO9/lFCMr8fJuCd
         BhQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eZx+l47CzuZ3xlEKU80E40CSh3ZgdwDHh7dVN/b5kRo=;
        b=Lh+gz12teTQEse6IQknlC+QUhV+ZGApdv9yIddvuSSoJiFuXLIaCBz4+8Q50R8k27w
         /0/54TyrDoGydWLVvrneYi4CZdfaOkTmtgveIzz3lwF7/kGzYj5/mRoYyeAL7D/xJMTE
         nj/OpF3tx9jhFkfBtgY+NPGuIeA/gXYhEf7gmwROEQ2refuFQUooznlqgKD5O636JGFs
         P3r+MteGPyZOV9HNmIw6xXMaayIvzXh3XjxyevPpmYXhREPHivV9ijZvv0NJLYu+Rrrz
         vR8eRJCWnrGPYUJi6Xu+znu42TAK0Wju8srQjXSXkCW8DKVZDIYtLG7HpbagGixa9YRG
         Z2qg==
X-Gm-Message-State: ANoB5pmNiqQBZArOl+Ly2J74DKqlA+DipJijaRFg/BrKDlLdrE0acPUR
        /oxRMUBWtqxMYPnmslJ27RqNeWeCsLrbGUsgOCI=
X-Google-Smtp-Source: AA0mqf7ppxLF7qxPmNCdfEgtJwV5Vd4oFzSPHummjuidUWmJq1YWv5y0jyi/bQtjJpVrvOuobujSyRg8BUsF3Bq0eW4=
X-Received: by 2002:a17:906:7e57:b0:7c1:bb5:1937 with SMTP id
 z23-20020a1709067e5700b007c10bb51937mr12211453ejr.251.1671516568064; Mon, 19
 Dec 2022 22:09:28 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:7208:104:b0:60:28cf:890c with HTTP; Mon, 19 Dec 2022
 22:09:27 -0800 (PST)
Reply-To: seyba_daniel@yahoo.com
From:   Seyba Daniel <belitourdamien@gmail.com>
Date:   Tue, 20 Dec 2022 07:09:27 +0100
Message-ID: <CAE8i9FjCvntzeaUjdSVrbFfC80PY7XPQ13cF9rOBSPdrSQ+waA@mail.gmail.com>
Subject: Seyba Daniel
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.3 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

I urgently seek your service to represent me in investing in
your region / country and you will be rewarded for your service without
affecting your present job with very little time invested in it
My dearest regards

Seyba Daniel
