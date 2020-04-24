Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA9EE1B7FAC
	for <lists+io-uring@lfdr.de>; Fri, 24 Apr 2020 22:03:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727059AbgDXUDn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Apr 2020 16:03:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726908AbgDXUDn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Apr 2020 16:03:43 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15A71C09B049
        for <io-uring@vger.kernel.org>; Fri, 24 Apr 2020 13:03:43 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id g4so11284408ljl.2
        for <io-uring@vger.kernel.org>; Fri, 24 Apr 2020 13:03:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zKiBGaITMWdq+RcJCKiD/KTBLwCH1eJL3pgyLRaRR50=;
        b=RTCTUpbhuswy3xPMW3RGLlJF3lmnhyCRiVwB/lbeWvf4CUaD1xhJGKhESpvFHrwbnL
         tCHhM4ASu3oXvIwAawcrwqPxV2i+vbr7hayLfIX+RIQg/QzXYPBweoWWoTGgDiiOG1xp
         JD9DhVMgeTcS82lfo5xUOCeCz2bxZN0lUPjzg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zKiBGaITMWdq+RcJCKiD/KTBLwCH1eJL3pgyLRaRR50=;
        b=WUmsrOQsGQ4I1HS0JNbIIVBveDh9V4jcsTiNqzHsy9uMAPAFrvlrvv01DtzNijtb43
         1VfVRAG7Ii8spSz1ZumAcwWD+wR3E6BHK4Z3rYEkc72Im6RyNFFsKefXw4N7PuX3F5z5
         vfeyb31I8xNH8RUzECRQJ2CvubuB2XOtse5ElAhO/RQNmQyAGtnF2/GPM1zoAXe709qa
         +y98y/V57wIDNoITrRZR+FCa66RzDDUXDji9tsZWOTXe3le26Tnku/bgLUheAcd9QMPt
         KGVCm2Q8hjIE6GAVW7lUAR8liayqlSVzCHFFpbUpm83GQPulKZL/ZgHIRTFU1pyRsNIp
         cUAg==
X-Gm-Message-State: AGi0PuYdJDHEaRuOoNhskYvb3HAoy8SHR7IhrKAuiLyGajNNIAp4q+iE
        uh74QSMtLy30AEX2ElLZfFeXJgdGae4=
X-Google-Smtp-Source: APiQypKfe5kds1LCwMB6t6wI8Kk7dpqd++fgQor696J8FI332yXlNj6/yR70yBD8Umu0gO40PFrV4w==
X-Received: by 2002:a2e:b17a:: with SMTP id a26mr6563774ljm.215.1587758620911;
        Fri, 24 Apr 2020 13:03:40 -0700 (PDT)
Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com. [209.85.208.180])
        by smtp.gmail.com with ESMTPSA id t16sm4780253ljg.41.2020.04.24.13.03.40
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Apr 2020 13:03:40 -0700 (PDT)
Received: by mail-lj1-f180.google.com with SMTP id u6so11243173ljl.6
        for <io-uring@vger.kernel.org>; Fri, 24 Apr 2020 13:03:40 -0700 (PDT)
X-Received: by 2002:a2e:9a54:: with SMTP id k20mr5154247ljj.265.1587758619521;
 Fri, 24 Apr 2020 13:03:39 -0700 (PDT)
MIME-Version: 1.0
References: <156f8353-5841-39ad-3bc2-af9cadac3c71@kernel.dk>
In-Reply-To: <156f8353-5841-39ad-3bc2-af9cadac3c71@kernel.dk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 24 Apr 2020 13:03:23 -0700
X-Gmail-Original-Message-ID: <CAHk-=wibcCGvPy=PjevdSzEtzrYPWJnLo+t=S3zy3AQ5+NNeEg@mail.gmail.com>
Message-ID: <CAHk-=wibcCGvPy=PjevdSzEtzrYPWJnLo+t=S3zy3AQ5+NNeEg@mail.gmail.com>
Subject: Re: [GIT PULL] io_uring fix for 5.7-rc3
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Apr 24, 2020 at 11:03 AM Jens Axboe <axboe@kernel.dk> wrote:
>
> Single fixup for a change that went into -rc2, please pull.

I'd like to point out that this was exactly the code that I pointed to
as being badly written and hard to understand:

 "That whole apoll thing is disgusting.

  I cannot convince myself it is right. How do you convince yourself?"

And you at that time claimed it was all fairly simple and clear.

I repeat: that whole apoll thing is disgusting. It wasn't simple and
clear and only a few obvious cases that had issues.

In fact, now it's even less clear, with an even more complicated check
for when to restore things,

I think that whole approach needs re-thinking. Is the union really worth it?

Can you guarantee and explain why _this_ time it is right?

                Linus
