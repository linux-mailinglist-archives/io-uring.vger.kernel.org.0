Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C740464E151
	for <lists+io-uring@lfdr.de>; Thu, 15 Dec 2022 19:52:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230368AbiLOSwN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 15 Dec 2022 13:52:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230443AbiLOSwF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 15 Dec 2022 13:52:05 -0500
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C40BE183B9
        for <io-uring@vger.kernel.org>; Thu, 15 Dec 2022 10:52:03 -0800 (PST)
Received: by mail-lf1-x133.google.com with SMTP id b13so17090585lfo.3
        for <io-uring@vger.kernel.org>; Thu, 15 Dec 2022 10:52:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=H4EsdgO6at5OT/pRm6ME2FVKP6S9qjkMyU8H5M18aqE=;
        b=LexFfSoTABPLoepz0MKFlJLnvrh+yaVG0Vyw8aGTdARoqbg35AGR7egWdLsJkB+qhj
         qcJxlWB+PKrJRUmdOkUgXvK+H9KErupAF71C76Oc7/mmfXBTl/n1iWmEEyyCiYOOZde4
         /yU4++4+ygoqd0mTbAO0tWpeZ/QSiAu6kTUto=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=H4EsdgO6at5OT/pRm6ME2FVKP6S9qjkMyU8H5M18aqE=;
        b=ffzEur6N+AkV7Jup8bDHqIHRrBnDkXt0Ppiax80gAV+XWnVtFynJWse3uwkdxaY2vI
         VFCGRdWLjLaBZlaoMwEXhWRa43V4KxU9c3FhGXGZjUY+uJVk9+dqHAwE4Jt7dH3tt6gK
         TXQa1Vh06mfyIQjOTX2s3UwniQAiiCPlXFrsoGbrle7iSAFBu9RTkqAIJ0KvuHhjMxeN
         QmzPDmc3+96JDlioly4D3+lpI6DI6HAuR6fbyKUtKnqioyuraxMJ2kXgrk/w9hkP2YB1
         hvxyZEz0fAs0UIT2RAX8z8Czio+6Av0g31POUVLstgd3IHmn6RD9GdurStSLE2rOCrMd
         4Nsg==
X-Gm-Message-State: ANoB5pnG34YH4tnJ/njHYW/HCoKjxVbRliYtgNOhUKFFgmFQ7J0Nluhw
        K+cvZdPNsBYiS7nNo7GLBOWabApmqB6rvO9iX+n4CQ==
X-Google-Smtp-Source: AA0mqf66pS+eio5dOpQgLq1Zc5n71FQh38McrZoFTkUFs3GydUteupIGiYaM44jue7mv4Ah32gnZ50QJbDMeqwZJdHg=
X-Received: by 2002:ac2:510c:0:b0:4af:d4e:dfa7 with SMTP id
 q12-20020ac2510c000000b004af0d4edfa7mr27424063lfb.582.1671130322187; Thu, 15
 Dec 2022 10:52:02 -0800 (PST)
MIME-Version: 1.0
References: <20221215184138.795576-1-dylany@meta.com> <167113016853.52282.4184815382776784529.b4-ty@kernel.dk>
In-Reply-To: <167113016853.52282.4184815382776784529.b4-ty@kernel.dk>
From:   Joel Fernandes <joel@joelfernandes.org>
Date:   Thu, 15 Dec 2022 13:51:50 -0500
Message-ID: <CAEXW_YSUTzKurSdGxR=tWAoPu=V2xxiqRuPGiD3C892hUiQp7Q@mail.gmail.com>
Subject: Re: [PATCH] io_uring: use call_rcu_hurry if signaling an eventfd
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Dylan Yudaken <dylany@meta.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-team@fb.com,
        "Paul E . McKenney" <paulmck@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Dec 15, 2022 at 1:49 PM Jens Axboe <axboe@kernel.dk> wrote:
>
>
> On Thu, 15 Dec 2022 10:41:38 -0800, Dylan Yudaken wrote:
> > io_uring uses call_rcu in the case it needs to signal an eventfd as a
> > result of an eventfd signal, since recursing eventfd signals are not
> > allowed. This should be calling the new call_rcu_hurry API to not delay
> > the signal.
> >
> > Signed-off-by: Dylan Yudaken <dylany@meta.com>
> >
> > [...]
>
> Applied, thanks!
>
> [1/1] io_uring: use call_rcu_hurry if signaling an eventfd
>       commit: de8f0209fe8064172a86a61537a7b21d6e5334ad

Reviewed-by: Joel Fernandes (Google) <joel@joelfernandes.org>

thanks,

 - Joel
