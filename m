Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 334A85EC5B3
	for <lists+io-uring@lfdr.de>; Tue, 27 Sep 2022 16:15:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231796AbiI0OPZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 27 Sep 2022 10:15:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231765AbiI0OPY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 27 Sep 2022 10:15:24 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D90EF1930
        for <io-uring@vger.kernel.org>; Tue, 27 Sep 2022 07:15:21 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id x1-20020a17090ab00100b001fda21bbc90so15687826pjq.3
        for <io-uring@vger.kernel.org>; Tue, 27 Sep 2022 07:15:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date;
        bh=UdKZgUSYjmlfkFev7OeTn+dMxkbVk96GkqHx+r5fyd4=;
        b=s3fnnyQz9c++IUs0T1FCIRyfcmMFEkL5nil0nOfleFuXQxoY8lFwEdkN6AtQyMVbQC
         8cUjcnRFrrchbnMYx6qK9WGSO/Rv0iFZVHHRuc+P5vVdY8Lg4QnfROQWN764RXCJQ2Vb
         NkJybSf+yhLaLNUq+YnvDIOS3ey4FfQBcDO/SRTJunKAQZ7hFufRRtX7p4JgaVRsvQ2Y
         3Xzs5rr51+IWy6ZMOQlUCHgoncYC/b3SfkF3tfWbkNmUL6VC3DociLyZl2g4RUxtKB9T
         PXl1kGHKO1QJR7z91pe0pzc2POJUmGjqqeMH2c5++irKQh376lLhmir6/j7I+zhENxFC
         9i0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=UdKZgUSYjmlfkFev7OeTn+dMxkbVk96GkqHx+r5fyd4=;
        b=VithV096n7HC3N+bBg192C1H/8o4UBinumIukNkEm5wEKHh/JsZa8nVWnHe0ehmXCh
         wSUK3afSkqDQ2FVuFfebxHwb3Ki33XiqwhzYJ69Fo1RnCxDNIlriIv8O7PmwICPDjWSv
         wN5lgEm1jYIzz/b2eu6K3A7TD1g/2j8PIhavgTLAPMlyWmtvipn+vhs4QB4nK7Qd8LTa
         RatiqmLCeeuQimaDgQGQi1z3Kl7v3Y7THVM0Annc2NT2ExPL4y1dg4S5JaHjcfvr9T8T
         Sx4eV4t4Rtsz6YmQ4XpIBLlP6unmMsZncPIMJnAFnqKfTkFRt0HlSYl3tnA9/oyie76S
         E3Zg==
X-Gm-Message-State: ACrzQf0Rp1BfNHC1fdPQAE3ftkGlT+lMz87VFb4TS7C/TYn16A1p66Fp
        3ggu2BmeZFX7XQ6K2Nh7AK4Xcg==
X-Google-Smtp-Source: AMsMyM62louFTQhYqR2v5HTDc9Od8snl3ME1wy6njeRL//CRcvfJ53mRRczyDeWp1boRxeM1i8rItQ==
X-Received: by 2002:a17:90a:aa8c:b0:205:98b8:f8d5 with SMTP id l12-20020a17090aaa8c00b0020598b8f8d5mr4938303pjq.159.1664288121316;
        Tue, 27 Sep 2022 07:15:21 -0700 (PDT)
Received: from [127.0.0.1] ([2620:10d:c090:400::5:5bca])
        by smtp.gmail.com with ESMTPSA id o188-20020a625ac5000000b00537fb1f9f25sm1817662pfb.110.2022.09.27.07.15.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Sep 2022 07:15:20 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     Dylan Yudaken <dylany@fb.com>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com
In-Reply-To: <20220927102202.69069-1-dylany@fb.com>
References: <20220927102202.69069-1-dylany@fb.com>
Subject: Re: [PATCH liburing v2 0/3] 6.0 updates
Message-Id: <166428812019.32417.13623795874107476231.b4-ty@kernel.dk>
Date:   Tue, 27 Sep 2022 08:15:20 -0600
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

On Tue, 27 Sep 2022 03:21:59 -0700, Dylan Yudaken wrote:
> liburing updates for 6.0:
> 
> Patch 1 updates to account for the single issuer ring being assigned at
> ring creation time.
> Patch 2 updates man pages from 5.20 -> 6.0
> Patch 3 reduces test flakiness
> 
> [...]

Applied, thanks!

[1/3] handle single issuer task registration at ring creation
      commit: f37012787e5cde63fb30ae92c9ac25153298dc5b
[2/3] update documentation to reflect no 5.20 kernel
      commit: b08210967b53c339a1cb983e176e8b53b5c8e0db
[3/3] give open-direct-pick.c a unique path
      commit: eb90f4229c0526bace370175eeec1329bf72311b

Best regards,
-- 
Jens Axboe


