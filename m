Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16ACC51E0A1
	for <lists+io-uring@lfdr.de>; Fri,  6 May 2022 23:05:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1444070AbiEFVJe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 6 May 2022 17:09:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1444360AbiEFVJF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 6 May 2022 17:09:05 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F345B9E
        for <io-uring@vger.kernel.org>; Fri,  6 May 2022 14:05:20 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id s14so8590312plk.8
        for <io-uring@vger.kernel.org>; Fri, 06 May 2022 14:05:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:in-reply-to:references:from:date:message-id
         :subject:to;
        bh=VSSUIwdzgxQxnEkB7+u7pnweyPajIQMP3nQqWYs8VX0=;
        b=Pikzf05RvlgsNiSN1x8VQddbQlHNU8w6b4F5093LpuzcM0ntMpgrUYdcKzhnhHB48+
         nxofPjncbzlNuBNgooKcMle2Y5ylBJZ6O8MOl6jmb+4GXhkX7JY7QlgBzU7KDKtY2S+t
         hdYkJvFaRkTyMTuFzz2JqLAY96/AXzO6tgScVG1YJD9G5UO3G+tZ8nGL14yI0+9uPzhC
         wx/zFVXeSa1h7d0nK/9Qv4fLpnyxu41DB2or0mzOQHpWd2RcmeWfuVLsEUjsRWphAt0g
         4hy8H6gBdpRcYFXBRhobSZg5COn6SmVmFJv6lpApXA5BMZTju/Hca9z5AiK8OWFQZRyE
         91pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:in-reply-to:references
         :from:date:message-id:subject:to;
        bh=VSSUIwdzgxQxnEkB7+u7pnweyPajIQMP3nQqWYs8VX0=;
        b=X7eCC/JxwT5dTrNgWkcKnS+ls6nqD2nxOiVtCu4b698gD/3zupqmVsX8KOSyuW1DvU
         7IILQimE8dWkAhEskmTSrh7YEz+4Ckapf5/caOoGY8OftZ8TRiGaNOw7tHqaU+1heBLe
         ++BcK000uwTExIy1vfHw8j4skPrR2Qlfcr28DAoqVOUZgPR6C1g13plHnR1w0za6xuUl
         4qu+5r0ZFbXYHJfXi8ArlaDc0GhmLX8wfP6jHG3xbKvK/1E777reepE2E3qeDQcnSCSH
         Z6+w3FEk7YKUqJjDjH+jLa5ElJsG/WJPIWQ2B4elG+aH4FKaSaLyJL9wFaTVBu8ONVz2
         fvFg==
X-Gm-Message-State: AOAM53109kCDGL9kDgzK2PdcmOd+/xF9eCwLD3xU1I8rJzE4Ge6Mi+/M
        VAnMIwD++SPE62SzENjYZNYs6PBkCbKJ1gYCeg==
X-Google-Smtp-Source: ABdhPJx7z4moOE2gpr/KlS+3C9TQAnAO3wCwszoE5VU4KaQgpBr5SM/EngTmKFwvPUIFIAmNZ9KZadvdCoWslU4jbxM=
X-Received: by 2002:a17:90a:b106:b0:1d9:7cde:7914 with SMTP id
 z6-20020a17090ab10600b001d97cde7914mr6294782pjq.56.1651871119761; Fri, 06 May
 2022 14:05:19 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ac4:9906:0:b0:4ba:807b:b8f3 with HTTP; Fri, 6 May 2022
 14:05:18 -0700 (PDT)
Reply-To: warren001buffett@gmail.com
In-Reply-To: <CAD_xG_pvNZK6BFCW+28Xv4DE=_5rbDZXDok2BYNn9xw6Ma7iow@mail.gmail.com>
References: <CAD_xG_pvNZK6BFCW+28Xv4DE=_5rbDZXDok2BYNn9xw6Ma7iow@mail.gmail.com>
From:   Warren Buffett <guidayema@gmail.com>
Date:   Fri, 6 May 2022 21:05:18 +0000
Message-ID: <CAD_xG_pXizBD6pW=-K0ttmT_EZuS+8BZv7pSZcaHdzR-qQhVZA@mail.gmail.com>
Subject: Fwd: My name is Warren Buffett, an American businessman.
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.1 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:642 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4977]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [guidayema[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.5 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

My name is Warren Buffett, an American businessman and investor I have
something important to discuss with you.

Mr. Warren Buffett
warren001buffett@gmail.com
Chief Executive Officer: Berkshire Hathaway
aphy/Warren-Edward-Buffett
