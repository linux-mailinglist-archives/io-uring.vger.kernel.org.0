Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8B40675A5C
	for <lists+io-uring@lfdr.de>; Fri, 20 Jan 2023 17:45:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229612AbjATQpi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 20 Jan 2023 11:45:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230407AbjATQph (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 20 Jan 2023 11:45:37 -0500
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16E68CDF5
        for <io-uring@vger.kernel.org>; Fri, 20 Jan 2023 08:45:36 -0800 (PST)
Received: by mail-il1-x130.google.com with SMTP id i1so2962783ilu.8
        for <io-uring@vger.kernel.org>; Fri, 20 Jan 2023 08:45:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dlwm0dZOPstviLD8ECXWUPSZ1ZbHMfCMMJ3MFW0u1IQ=;
        b=vWYVs6WYpfOFbHeCCSBfZs0ZEBZp8ygwdtFiQAAI5HD8cs36KvPxh2HgSGfMU9TJIF
         kTM1PUBKBYPakrjSW3K6FGIVcRtgytKr3NlAQ9Pp/nipxccHaEXBEkNJ1VRSuV+o8uMw
         HvwWvX6E9NMIOv5ZVT40OFlLP+5lUb380eRlCvfcPDF3XgjQjtnIAXR+EC/gKKZJM7Ap
         IPbZDTJ8Txa4bUVHVzY9JyGwpPscc5VIk3TAnQKYcHseZpNHOwITR+Opa51k8JZzxdVb
         otAXI9MvaEjPoytD+h2lo63VeHwdEp+wb2HwElLILr7JGf0S+wkvlc5qrSLRdCaxIeCf
         pu+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dlwm0dZOPstviLD8ECXWUPSZ1ZbHMfCMMJ3MFW0u1IQ=;
        b=1tIasXzvsOq4VPQFoprw0sA0iqcUGM6W83BzbpCVVmVmr8vFn57Kaf4XRZBjA6190n
         EZOjo2bxE34Jrka8hkWGW4h6neCZSTqtX+r4S4qIPGGVdOFCowO1IbZAd1LPE5j/5uT/
         n1A+h9yLr/TJp7APCZlQpaYZKRwZr/Skqr/nZNyXXMmtkcDHWhfc3yLai5IYrcI3HKnn
         qLQ5WVj3X3d3Czi5sJilNcjK4Hm4F8DGoDmf5gplPS89BBz4NP1jfLZFcMGSJFGf4dUu
         CNKqZwYSvvevuUToIZhGbsTODk2FmJeFgVXfVADubfwJ5EPduI4/vPCVkfxRTZ26O3WY
         KmXw==
X-Gm-Message-State: AFqh2kpSSyeejVRr8coHP+SV7cToNT9yv51oYjxXJHwwCpybbV+yzh1C
        IWQoMsyH0ymxV9Q0Conl+NCDBpEChglFYRMy
X-Google-Smtp-Source: AMrXdXuS8l/5Gvy58juIzzW0qhfrbChw8rDACQNY2X0pHzMWLroXjlDx2rVbgQ9A2Wi/PBXMHtfleA==
X-Received: by 2002:a92:d3c2:0:b0:30f:4feb:50c7 with SMTP id c2-20020a92d3c2000000b0030f4feb50c7mr447797ilh.3.1674233135341;
        Fri, 20 Jan 2023 08:45:35 -0800 (PST)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id cp20-20020a056638481400b0039e5ac0cbc0sm544177jab.108.2023.01.20.08.45.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Jan 2023 08:45:34 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cover.1674232514.git.asml.silence@gmail.com>
References: <cover.1674232514.git.asml.silence@gmail.com>
Subject: Re: (subset) [PATCH for-6.2 v2 0/3] msg_ring fixes
Message-Id: <167423313461.677701.13328458976591548131.b4-ty@kernel.dk>
Date:   Fri, 20 Jan 2023 09:45:34 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12-dev-78c63
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On Fri, 20 Jan 2023 16:38:04 +0000, Pavel Begunkov wrote:
> First two patches are msg_ring fixes. 3/3 can go 6.3
> 
> v2: fail msg_ring'ing to disabled rings
> 
> Pavel Begunkov (3):
>   io_uring/msg_ring: fix flagging remote execution
>   io_uring/msg_ring: fix remote queue to disabled ring
>   io_uring/msg_ring: optimise with correct tw notify method
> 
> [...]

Applied, thanks!

[1/3] io_uring/msg_ring: fix flagging remote execution
      commit: 79ee63a3cfb1da7464814f1514fefb6a69615702
[2/3] io_uring/msg_ring: fix remote queue to disabled ring
      commit: b85dfd720541567b2d56714aa3b1ece85d7ec971

Best regards,
-- 
Jens Axboe



