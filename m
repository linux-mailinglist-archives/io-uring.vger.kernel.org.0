Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1608638AF6
	for <lists+io-uring@lfdr.de>; Fri, 25 Nov 2022 14:13:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229682AbiKYNNm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 25 Nov 2022 08:13:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbiKYNNk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 25 Nov 2022 08:13:40 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 083E024BC4
        for <io-uring@vger.kernel.org>; Fri, 25 Nov 2022 05:13:40 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id ci10so3689177pjb.1
        for <io-uring@vger.kernel.org>; Fri, 25 Nov 2022 05:13:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oMVB6+tuXkJCPZJMeGvGVlsMwl373e4NyQwnEBpw434=;
        b=iFFyv3r4YG2QoQ4EzUr/sNOPsYC58BQHSAATXysUSdHFgw6JXRlmvKfLslYBawBjzb
         yIs3Q4wE2zkRyrhTGrYX4iikgURKnRcwt8tX4Guct0+kDFi6x+zU9+9y0ENFnIbV/tvj
         iLU98hr0Omq7ypA1ewBvhhCAvB4SrY4tI/CyAwDZbR+z2LUvoj5IgHv3EO1rjfTl3lZ2
         sU5Kx9kK2eVX7H6f+24x+5mFDbl6w3FOmxl1l1FCxpmORTegKIJrLJpwI/DnW4prhpIO
         sAHCFQqLQWTt4wd2XTaZv6f0jvAz/Fhl3WjqvKSPFYMrzYMR8E7YHjQfH1n4IffuVAL3
         kNEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oMVB6+tuXkJCPZJMeGvGVlsMwl373e4NyQwnEBpw434=;
        b=LaBMjDTZ9ec8U8gFpTe5W89RfBUMnniMh3PF8nEqNwibJa2EHHNoi34COaXcT95Wf6
         hZIxbVhBhGLuMGeCV3MidvcKXmZWeVg8EOpJvcydNUwY0S65viFEEuAQQT4zvwxNg953
         fVVRJBV1UQJ6sDpzAdngahADzmdKRjamIHUSzkp3rKDJEKc3i3qkiIKXMCVRsyj6dvY+
         o0v+MXhkcAnRVsDEYoG087I9SGhrAOv/ZZdf67P3oagjDNm5Yv3SLtZHCCdd3N05LIUR
         FHHoXvzA4Q5xuUZ5YZTsDOFO/l76CljyZWB1PBLs5qpWyP2/FqtCxw4Bjlv2yIybAbcP
         9idw==
X-Gm-Message-State: ANoB5pkuVfVGeacXRWKI5vzL7ExpdKzcLB4wXGPYRertXK8DUNQEn+da
        +udXnh/irzTw5+/H2KROj7lYB8Lwtc6csaoF
X-Google-Smtp-Source: AA0mqf6Qy+HzwmGASZyvnuRYegxc7L7Y9vrE/+Ea66ft/Q5dvf31A8kmnc8jiqrgstamXBQ2kKhJog==
X-Received: by 2002:a17:90a:458a:b0:214:166e:e202 with SMTP id v10-20020a17090a458a00b00214166ee202mr41054677pjg.165.1669382019258;
        Fri, 25 Nov 2022 05:13:39 -0800 (PST)
Received: from [127.0.0.1] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id d6-20020a170902654600b00188fcc4fc00sm3362643pln.79.2022.11.25.05.13.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Nov 2022 05:13:38 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cover.1669310258.git.asml.silence@gmail.com>
References: <cover.1669310258.git.asml.silence@gmail.com>
Subject: Re: [PATCH for-next 0/2] random for-next io_uring patches
Message-Id: <166938201833.7977.10828326653350936954.b4-ty@kernel.dk>
Date:   Fri, 25 Nov 2022 06:13:38 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailer: b4 0.11.0-dev-28747
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, 24 Nov 2022 19:46:39 +0000, Pavel Begunkov wrote:
> 1/2 removes two spots io_req_complete_post() in favour of the generic
> infra. 2/2 inlines io_cq_unlock_post() back.
> 
> Pavel Begunkov (2):
>   io_uring: don't use complete_post in kbuf
>   io_uring: keep unlock_post inlined in hot path
> 
> [...]

Applied, thanks!

[1/2] io_uring: don't use complete_post in kbuf
      commit: c3b490930dbe6a6c98d3820f445757ddec1efb08
[2/2] io_uring: keep unlock_post inlined in hot path
      commit: 5d772916855f593672de55c437925daccc8ecd73

Best regards,
-- 
Jens Axboe


