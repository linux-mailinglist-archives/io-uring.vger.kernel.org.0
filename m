Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48BFE591710
	for <lists+io-uring@lfdr.de>; Sat, 13 Aug 2022 00:02:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233151AbiHLWCb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 12 Aug 2022 18:02:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237168AbiHLWCP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 12 Aug 2022 18:02:15 -0400
Received: from mail-oa1-x34.google.com (mail-oa1-x34.google.com [IPv6:2001:4860:4864:20::34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FFD6B515F
        for <io-uring@vger.kernel.org>; Fri, 12 Aug 2022 15:02:12 -0700 (PDT)
Received: by mail-oa1-x34.google.com with SMTP id 586e51a60fabf-116c7286aaaso2316663fac.11
        for <io-uring@vger.kernel.org>; Fri, 12 Aug 2022 15:02:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=7b2Up35ErSwKD8zyVzA/N90T16/FjnlVHowB7iFcLEg=;
        b=ZnzI7rdsERXVSUJ4iIuDgz22z/5i910JJk+ONRARWC2KAVR6/rr4Sripl2PFrQCrzq
         CugomJCjgJZSVs6d38HW+4ndXThUMnejQMSItrqyBY1Z4cKKeDgaozCdYEGgJFekasKv
         d/6GQo+bCVCMReb+iDHrukpZdljW75y6E66d0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=7b2Up35ErSwKD8zyVzA/N90T16/FjnlVHowB7iFcLEg=;
        b=1iBkNeUKO9rhcxU7IZKFbT/EydokF5jI3COaKoJ7mQ1JFqcNn9IuuCu9jiACovyc2r
         uthmbAFt4nTmqw6efVF/3Cw7r57J+0Zyxv1lFFyV+Vqn8j8UqM6xwuTZsj8y2s8UAHus
         Uhui5BWpPU5vPqvZGVikXGx6vSwX23NqxmWXhvL5X9pMPoPkq79MTfgzTCurxiwohXXt
         Yl5wkGDnQ1CLnL4+EbN4zxwudksTQySoM4+vQoCpmB6SKlk7b9DFDpp+GejES0eue7Xi
         lo+tQySV4IZD/bPdlWJumvA1ieIt/7bwqYkf30OE+BVIDUPvKj9r0V945np2lgb3w7tm
         /jZQ==
X-Gm-Message-State: ACgBeo1J9irmv0BIYr//NzyXtat4T7HVrTcDOG1P075USfac7X8zVe28
        Fp/w3TvNj7rHrLGkPRzPx9D4v5HroQq0hOr7
X-Google-Smtp-Source: AA6agR4y0cq1yNGd2+oJhxypDTpiuzomKVQ7f41p7dfTbVEow43Qu0vrDqW/rDYaYSpAsKIyJ4MEAA==
X-Received: by 2002:a05:6870:ea84:b0:10d:fabe:9202 with SMTP id s4-20020a056870ea8400b0010dfabe9202mr6606259oap.294.1660341731227;
        Fri, 12 Aug 2022 15:02:11 -0700 (PDT)
Received: from mail-oi1-f169.google.com (mail-oi1-f169.google.com. [209.85.167.169])
        by smtp.gmail.com with ESMTPSA id o14-20020a4a384e000000b00435a8024bc1sm544221oof.4.2022.08.12.15.02.10
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Aug 2022 15:02:10 -0700 (PDT)
Received: by mail-oi1-f169.google.com with SMTP id c185so2553285oia.7
        for <io-uring@vger.kernel.org>; Fri, 12 Aug 2022 15:02:10 -0700 (PDT)
X-Received: by 2002:a05:6808:2187:b0:33a:c507:d4f3 with SMTP id
 be7-20020a056808218700b0033ac507d4f3mr6541173oib.205.1660341730518; Fri, 12
 Aug 2022 15:02:10 -0700 (PDT)
MIME-Version: 1.0
References: <CAHk-=wioqj4HUQM_dXdVoSJtPe+z0KxNrJPg0cs_R3j-gJJxAg@mail.gmail.com>
 <D92A7993-60C6-438C-AFA9-FA511646153C@kernel.dk> <6458eb59-554a-121b-d605-0b9755232818@kernel.dk>
 <ca630c3c-80ad-ceff-61a9-63b253ba5dbd@kernel.dk> <433f4500-427d-8581-b852-fbe257aa6120@kernel.dk>
 <CAHk-=wi_oveXZexeUuxpJZnMLhLJWC=biyaZ8SoiNPd2r=6iUg@mail.gmail.com> <CAHk-=wj_2autvtY36nGbYYmgrcH4T+dW8ee1=6mV-rCXH7UF-A@mail.gmail.com>
In-Reply-To: <CAHk-=wj_2autvtY36nGbYYmgrcH4T+dW8ee1=6mV-rCXH7UF-A@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 12 Aug 2022 15:01:53 -0700
X-Gmail-Original-Message-ID: <CAHk-=whSsFdh5Z+J_bbk11NUrzmaXoBJiMGfeYyXdK3bn_cT9Q@mail.gmail.com>
Message-ID: <CAHk-=whSsFdh5Z+J_bbk11NUrzmaXoBJiMGfeYyXdK3bn_cT9Q@mail.gmail.com>
Subject: Re: [GIT PULL] io_uring fixes for 6.0-rc1
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>,
        Keith Busch <kbusch@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Aug 12, 2022 at 2:54 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> And yes, on this latest case it was once again "struct io_cmd_data".

Duh. I'm a nincompoop. I'm only looking at the BUG_ON(), but
io_cmd_data is the *good* case that should cover it all, the "cmd_sz"
is the problem case, and the problematic stricture name doesn't
actually show up in the BUILD_BUG_ON() output.

So you have to look at where it's inlined from and check them
individually, and yeah, it seems to be 'struct io_rw' every time.

                     Linus
