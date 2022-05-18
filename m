Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E00C52BA03
	for <lists+io-uring@lfdr.de>; Wed, 18 May 2022 14:38:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236506AbiERM1o (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 18 May 2022 08:27:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236592AbiERM1g (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 18 May 2022 08:27:36 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A83211E497
        for <io-uring@vger.kernel.org>; Wed, 18 May 2022 05:27:33 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id ds11so1896148pjb.0
        for <io-uring@vger.kernel.org>; Wed, 18 May 2022 05:27:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=2TkbZs53GfzGXYMy0Tkb/pZIfm/NBkEplUiZ5ndlfrQ=;
        b=iR33cwRZSuLPqe82aF9J52+m0GJz92NDh23/YGH6oQ7GXBi8EsF0+4Bv8QFZTaSjhK
         OtVptw7sHytWQb0YzWLytfHLiiLO2rPbIloiRy5njPhWniqtN3r6R5MwLnvwtMknB0WG
         he1yClNiz8uBGXMvTGa47lZF1e760av1Iho/EehyCn/n86zXH6lqRtdSPtYwF5eBAdMK
         5CXZHZTUno36K6/ggMhSoQ9+E7+XWZnrtdP0uUlcOcoqz7eXgx6qKFQu4ir6QXsJksPF
         c7hU6k/qX9gs/pmaH7/aagKnK4PxUMWViShv6DGlwJ3cUMxiwQ5FDb2qLz664BCy6hQm
         K3Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=2TkbZs53GfzGXYMy0Tkb/pZIfm/NBkEplUiZ5ndlfrQ=;
        b=nDSVtUtKqyrU6BBp+bw8DhgqCO/ZgUDB7fy0oINbNOQvOCigULBV84Cs74DfAjwy0j
         qe4Dzd+c8+mvl3Rx9ysB7ZfY+tuIj0rOIB2XapRPN0ksJowPW0sI2Fmh/cNhjZyn2evE
         /vza7PB+I3zBMGlohOnhmRKlNOZ51MuGHhFyx19GM1TN66D8Zg/jM8t9mBAJXjkmLQkO
         P/5ylYSYsxjkEPXT8K63hhuAWBkSB97Ah5swTzfPpby/mWjpA/Kpt2oCZOGC5S7OnBov
         jdpHBkylD5X5Y6a42CNFn9TsYWNhf8wuMXh1rr/MWZS0Q82pyoS13Ep1xzSBxxDS6Gyw
         +2Uw==
X-Gm-Message-State: AOAM532ixpCq8NuBLV0FdLZ5tUgR5RQX9KQWM4oiIne4agu9hvD0Jb8h
        cEFPwbg8tSrDDsYdgnnuySuyX+kg2jDXBg==
X-Google-Smtp-Source: ABdhPJwHHCd4xw1WBQ7WI/w2T45R/mRJJIh3b5vDTzBaGincfNMx6PNhadovNx/3auxsjrLvbJYaYg==
X-Received: by 2002:a17:90b:4b91:b0:1df:6f4f:21f9 with SMTP id lr17-20020a17090b4b9100b001df6f4f21f9mr12920393pjb.29.1652876852466;
        Wed, 18 May 2022 05:27:32 -0700 (PDT)
Received: from [127.0.1.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id mq7-20020a17090b380700b001cd4989ff5esm1428956pjb.37.2022.05.18.05.27.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 May 2022 05:27:31 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     Christoph Hellwig <hch@lst.de>
Cc:     io-uring@vger.kernel.org, asml.silence@gmail.com
In-Reply-To: <20220518084005.3255380-2-hch@lst.de>
References: <20220518084005.3255380-1-hch@lst.de> <20220518084005.3255380-2-hch@lst.de>
Subject: Re: [PATCH 1/6] io_uring: use a rwf_t for io_rw.flags
Message-Id: <165287685158.17775.2849875776478186991.b4-ty@kernel.dk>
Date:   Wed, 18 May 2022 06:27:31 -0600
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

On Wed, 18 May 2022 10:40:00 +0200, Christoph Hellwig wrote:
> Remove the bogus __force casts and just use the proper type instead.
> 
> 

Applied, thanks!

[1/6] io_uring: use a rwf_t for io_rw.flags
      commit: 20cbd21d899b72765e38481a926c7b2008c64350
[2/6] io_uring: don't use ERR_PTR for user pointers
      commit: 984824db844a9bd6e9e15ee469241982526a6ccd
[3/6] io_uring: drop a spurious inline on a forward declaration
      commit: ee67ba3b20f7dcd001b7743eb8e46880cb27fdc6
[4/6] io_uring: make apoll_events a __poll_t
      commit: 58f5c8d39e0ea07fdaaea6a85c49000da83dc0cc
[5/6] io_uring: consistently use the EPOLL* defines
      commit: a294bef57c55a45aef51d31e71d6892e8eba1483
[6/6] io_uring: use rcu_dereference in io_close
      commit: 0bf1dbee9baf3e78bff297245178f8c9a8ef8670

Best regards,
-- 
Jens Axboe


